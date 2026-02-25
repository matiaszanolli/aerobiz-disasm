#!/usr/bin/env python3
"""
Find contiguous untranslated dc.w code blocks in section files.

Scans the 4 main section files (section_000200.asm through section_030000.asm)
for contiguous runs of "full" dc.w lines (4+ words per line = dump format),
filtering out:
  - Blocks smaller than 16 bytes
  - Known data regions (strings, Z80 driver, graphics)
  - Blocks classified as data (no code-like opcodes found)

Key heuristic: untranslated dump lines have 8 dc.w words (16 bytes/line).
Translated code uses dc.w sparingly (1-3 words for bsr.w/jsr calls).
A "full dc.w line" with 4+ words is treated as untranslated code.
Contiguous runs of such lines (allowing labels, comments, blank lines
between them but NOT mnemonic instructions) form untranslated blocks.
"""

import re
import os
import sys

SECTION_FILES = [
    "disasm/sections/section_000200.asm",
    "disasm/sections/section_010000.asm",
    "disasm/sections/section_020000.asm",
    "disasm/sections/section_030000.asm",
]

# Known data regions to exclude (start_inclusive, end_inclusive)
DATA_REGIONS = [
    (0x000200, 0x0002F9),   # Boot data table (vectors/init data before code at $2FA)
    (0x002696, 0x003BE7),   # Z80 sound driver binary
    (0x03E182, 0x03FFFF),   # Game text strings + string data
]

# Common 68K opcodes that strongly indicate code (first word of instruction)
CODE_OPCODES = {
    0x4E75,  # RTS
    0x4E73,  # RTE
    0x4E71,  # NOP
    0x4E56,  # LINK A6,#imm
    0x4E5E,  # UNLK A6
    0x4E40,  # TRAP #0
}

# Opcode prefixes that indicate code (high byte patterns)
CODE_OPCODE_RANGES = [
    (0x4EB9, 0x4EB9),  # JSR abs.l
    (0x4EBA, 0x4EBA),  # JSR (d16,PC)
    (0x4EF9, 0x4EF9),  # JMP abs.l
    (0x4EFB, 0x4EFB),  # JMP (d8,PC,Xn)
    (0x48E7, 0x48E7),  # MOVEM.L Rlist,-(SP)
    (0x4CDF, 0x4CDF),  # MOVEM.L (SP)+,Rlist
    (0x4CD7, 0x4CD7),  # MOVEM.L (SP),Rlist (alt)
]

# 68K mnemonic instructions that indicate translated code
MNEMONIC_PATTERN = re.compile(
    r'^\s+(?:move|movea|movem|moveq|lea|pea|clr|add|adda|addi|addq|addx|'
    r'sub|suba|subi|subq|subx|and|andi|or|ori|eor|eori|not|neg|negx|'
    r'ext|swap|tst|cmp|cmpa|cmpi|cmpm|'
    r'bra|bsr|bne|beq|bge|bgt|ble|blt|bcc|bcs|bhi|bls|bpl|bmi|bvc|bvs|'
    r'jsr|jmp|rts|rte|rtr|'
    r'dbra|dbne|dbeq|dbf|'
    r'lsl|lsr|asl|asr|rol|ror|roxl|roxr|'
    r'btst|bset|bclr|bchg|'
    r'mulu|muls|divu|divs|'
    r'link|unlk|nop|trap|'
    r'exg|abcd|sbcd|nbcd|tas|'
    r'stop|reset|illegal)\b',
    re.IGNORECASE
)

# dc.w line with address comment
DCW_WITH_ADDR = re.compile(r'^\s+dc\.w\s+(.*?);\s*\$([0-9A-Fa-f]+)')

# dc.w line without address comment
DCW_NO_ADDR = re.compile(r'^\s+dc\.w\s+')

# Comment-only or blank lines
COMMENT_OR_BLANK = re.compile(r'^\s*(;.*)?$')

# Label lines
LABEL_PATTERN = re.compile(r'^[A-Za-z_\.]\w*:')


def is_in_data_region(addr):
    """Check if an address falls within a known data region."""
    for start, end in DATA_REGIONS:
        if start <= addr <= end:
            return True
    return False


def count_dcw_words(operands_str):
    """Count number of dc.w word values in an operand string."""
    operands_str = operands_str.strip()
    if not operands_str:
        return 0
    words = [w.strip() for w in operands_str.split(',') if w.strip()]
    return len(words)


def parse_dcw_values(operands_str):
    """Parse dc.w operand values into a list of integers."""
    operands_str = operands_str.strip()
    if not operands_str:
        return []
    values = []
    for w in operands_str.split(','):
        w = w.strip()
        if w.startswith('$'):
            try:
                values.append(int(w[1:], 16))
            except ValueError:
                pass
    return values


def has_code_opcodes(all_values):
    """Check if a list of word values contains likely 68K opcodes."""
    for v in all_values:
        if v in CODE_OPCODES:
            return True
        for lo, hi in CODE_OPCODE_RANGES:
            if lo <= v <= hi:
                return True
        # Check for MOVEM patterns (0x48xx or 0x4Cxx)
        if (v & 0xFF00) == 0x4800 or (v & 0xFF00) == 0x4C00:
            return True
        # BSR.W pattern: 0x6100
        if v == 0x6100:
            return True
        # BRA.W pattern: 0x6000
        if v == 0x6000:
            return True
        # Bcc.W patterns: 0x66xx, 0x67xx, etc. (word displacement = 0x0000)
        if (v & 0xF000) == 0x6000 and (v & 0x00FF) == 0x00:
            return True
    return False


def classify_block(all_values):
    """
    Classify a dc.w block as 'code', 'data', or 'mixed'.
    Returns (classification, code_indicator_count).
    """
    if not all_values:
        return 'data', 0

    code_indicators = 0
    for v in all_values:
        if v in CODE_OPCODES:
            code_indicators += 1
        for lo, hi in CODE_OPCODE_RANGES:
            if lo <= v <= hi:
                code_indicators += 1
                break
        # MOVEM patterns
        if (v & 0xFF00) == 0x4800 or (v & 0xFF00) == 0x4C00:
            code_indicators += 1
        if v == 0x6100 or v == 0x6000:
            code_indicators += 1
        if (v & 0xF000) == 0x6000 and (v & 0x00FF) == 0x00:
            code_indicators += 1

    # A block with several code opcodes is likely code
    # A block with none is likely data
    if code_indicators == 0:
        return 'data', 0
    elif code_indicators >= 3:
        return 'code', code_indicators
    else:
        return 'mixed', code_indicators


def is_full_dcw_line(line):
    """
    Check if a line is a "full" dc.w dump line (4+ words).
    Returns (True, addr, word_count, values) or (False, None, 0, []).
    """
    m = DCW_WITH_ADDR.match(line)
    if m:
        operands = m.group(1)
        addr = int(m.group(2), 16)
        wc = count_dcw_words(operands)
        if wc >= 4:
            values = parse_dcw_values(operands)
            return True, addr, wc, values
    return False, None, 0, []


def is_short_dcw_line(line):
    """Check if a line is a short dc.w (1-3 words, typically inline calls)."""
    m = DCW_WITH_ADDR.match(line)
    if m:
        operands = m.group(1)
        wc = count_dcw_words(operands)
        if 1 <= wc <= 3:
            values = parse_dcw_values(operands)
            return True, int(m.group(2), 16), wc, values
    if DCW_NO_ADDR.match(line) and not DCW_WITH_ADDR.match(line):
        return True, None, 0, []
    return False, None, 0, []


def analyze_section(filepath):
    """
    Find contiguous untranslated dc.w blocks in a section file.
    """
    blocks = []

    if not os.path.exists(filepath):
        print(f"WARNING: {filepath} not found, skipping")
        return blocks

    with open(filepath, 'r') as f:
        lines = f.readlines()

    block_start_addr = None
    block_end_addr = None
    block_total_words = 0
    block_start_line = None
    block_line_count = 0
    block_all_values = []
    gap_lines = 0

    def flush_block():
        nonlocal block_start_addr, block_end_addr, block_total_words
        nonlocal block_start_line, block_line_count, gap_lines, block_all_values
        if block_start_addr is not None and block_total_words > 0:
            if not is_in_data_region(block_start_addr):
                classification, code_count = classify_block(block_all_values)
                blocks.append({
                    'start': block_start_addr,
                    'total_words': block_total_words,
                    'line_start': block_start_line,
                    'line_count': block_line_count,
                    'classification': classification,
                    'code_indicators': code_count,
                })
        block_start_addr = None
        block_end_addr = None
        block_total_words = 0
        block_start_line = None
        block_line_count = 0
        block_all_values = []
        gap_lines = 0

    for i, raw_line in enumerate(lines):
        line = raw_line.rstrip()
        lineno = i + 1

        is_full, addr, wc, values = is_full_dcw_line(line)

        if is_full:
            if is_in_data_region(addr):
                flush_block()
                continue

            if block_start_addr is None:
                block_start_addr = addr
                block_start_line = lineno
                block_end_addr = addr
                block_total_words = wc
                block_line_count = 1
                block_all_values = list(values)
                gap_lines = 0
            else:
                block_end_addr = addr
                block_total_words += wc
                block_line_count += 1
                block_all_values.extend(values)
                gap_lines = 0
            continue

        # Check if it's a short dc.w line
        is_short, saddr, swc, svalues = is_short_dcw_line(line)
        if is_short:
            if block_start_addr is not None:
                block_total_words += swc
                if saddr is not None:
                    block_end_addr = saddr
                block_line_count += 1
                block_all_values.extend(svalues)
                gap_lines = 0
                continue
            else:
                continue

        if MNEMONIC_PATTERN.match(line):
            flush_block()
            continue

        if COMMENT_OR_BLANK.match(line) or LABEL_PATTERN.match(line):
            if block_start_addr is not None:
                gap_lines += 1
                if gap_lines > 10:
                    flush_block()
            continue

        flush_block()

    flush_block()

    return blocks


def main():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    all_blocks = []

    for section_file in SECTION_FILES:
        filepath = os.path.join(base_dir, section_file)
        blocks = analyze_section(filepath)

        for block in blocks:
            byte_size = block['total_words'] * 2
            block['byte_size'] = byte_size
            block['file'] = os.path.basename(section_file)

        all_blocks.extend(blocks)

    # Filter out blocks smaller than 16 bytes
    all_blocks = [b for b in all_blocks if b['byte_size'] >= 16]

    # Separate code blocks from data blocks
    code_blocks = [b for b in all_blocks if b['classification'] in ('code', 'mixed')]
    data_blocks = [b for b in all_blocks if b['classification'] == 'data']

    # Sort code blocks by size (largest first)
    code_blocks.sort(key=lambda b: b['byte_size'], reverse=True)
    data_blocks.sort(key=lambda b: b['byte_size'], reverse=True)

    # Print code blocks
    print("=" * 100)
    print("UNTRANSLATED dc.w CODE BLOCKS (>= 16 bytes, excluding known data regions)")
    print("=" * 100)
    print()
    print(f"{'#':>4}  {'Section File':<28}  {'Start':>10}  {'End':>10}  {'Size':>8}  {'Lines':>6}  {'Type':<6}")
    print(f"{'':>4}  {'':28}  {'(ROM)':>10}  {'(ROM)':>10}  {'(bytes)':>8}  {'':>6}  {'':6}")
    print("-" * 100)

    total_code_bytes = 0
    total_code_blocks = 0

    for idx, block in enumerate(code_blocks, 1):
        end_addr = block['start'] + block['byte_size']
        tag = block['classification'].upper()
        print(f"{idx:4d}  {block['file']:<28}  ${block['start']:08X}  ${end_addr:08X}  {block['byte_size']:8d}  {block['line_count']:6d}  {tag:<6}")
        total_code_bytes += block['byte_size']
        total_code_blocks += 1

    print("-" * 100)
    print(f"\nCode Block Summary:")
    print(f"  Total code blocks:  {total_code_blocks}")
    print(f"  Total code bytes:   {total_code_bytes:,} ({total_code_bytes / 1024:.1f} KB)")

    if code_blocks:
        min_addr = min(b['start'] for b in code_blocks)
        max_addr = max(b['start'] + b['byte_size'] for b in code_blocks)
        print(f"  ROM range:          ${min_addr:06X}-${max_addr:06X}")

    print()

    # Per-section breakdown (code only)
    print("Per-section breakdown (code blocks only):")
    for section_file in SECTION_FILES:
        basename = os.path.basename(section_file)
        section_blocks = [b for b in code_blocks if b['file'] == basename]
        section_bytes = sum(b['byte_size'] for b in section_blocks)
        print(f"  {basename}: {len(section_blocks)} blocks, {section_bytes:,} bytes ({section_bytes / 1024:.1f} KB)")

    print()
    print("Top 20 largest code blocks:")
    print("-" * 100)
    for idx, block in enumerate(code_blocks[:20], 1):
        end_addr = block['start'] + block['byte_size']
        tag = block['classification'].upper()
        print(f"  {idx:2d}. ${block['start']:06X}-${end_addr:06X}  {block['byte_size']:6d} bytes  {tag:<6}  ({block['file']}, line {block['line_start']})")

    # Print data blocks summary
    if data_blocks:
        total_data_bytes = sum(b['byte_size'] for b in data_blocks)
        print()
        print("=" * 100)
        print(f"DATA BLOCKS (dc.w blocks with no code opcodes detected) -- {len(data_blocks)} blocks, {total_data_bytes:,} bytes ({total_data_bytes / 1024:.1f} KB)")
        print("=" * 100)
        print()
        print(f"{'#':>4}  {'Section File':<28}  {'Start':>10}  {'End':>10}  {'Size':>8}  {'Lines':>6}")
        print("-" * 100)
        for idx, block in enumerate(data_blocks, 1):
            end_addr = block['start'] + block['byte_size']
            print(f"{idx:4d}  {block['file']:<28}  ${block['start']:08X}  ${end_addr:08X}  {block['byte_size']:8d}  {block['line_count']:6d}")
        print("-" * 100)

    # Grand total
    total_all = total_code_bytes + sum(b['byte_size'] for b in data_blocks)
    print()
    print(f"Grand total (all dc.w blocks >= 16 bytes): {len(code_blocks) + len(data_blocks)} blocks, {total_all:,} bytes ({total_all / 1024:.1f} KB)")
    print(f"  Code/mixed: {total_code_blocks} blocks, {total_code_bytes:,} bytes")
    print(f"  Data:       {len(data_blocks)} blocks, {sum(b['byte_size'] for b in data_blocks):,} bytes")


if __name__ == '__main__':
    main()
