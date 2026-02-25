#!/usr/bin/env python3
"""
translate.py -- Automated M68K translation tool for Aerobiz disassembly.

Modes:
  translate (default):  Produce vasm-compatible assembly from ROM address range
  --verify:             Compare ROM bytes vs build, report mismatches
  --find-function:      Find function boundaries from a given address

Usage:
    python3 tools/translate.py 0x6B78 0x6EEA           # translate range
    python3 tools/translate.py --verify 0x6B78 0x6EEA   # verify build
    python3 tools/translate.py --find-function 0x6B78    # find boundaries

Uses Capstone for reliable M68K instruction decode, then classifies each
instruction as safe-as-mnemonic or must-stay-as-dc.w per KNOWN_ISSUES.md.
"""

import argparse
import re
import struct
import sys

import capstone
from capstone import m68k as cs_m68k

ORIGINAL_ROM = 'Aerobiz Supersonic (USA).gen'
BUILD_ROM = 'build/aerobiz.bin'

# --- Opcode classification ---

# First opword values that MUST stay as dc.w
FORCE_DCW_OPWORDS = {
    0x4EB9,  # JSR abs.l -- vasm may optimize to abs.w
    0x6100,  # BSR.W    -- vasm +2 displacement bug
    0x4EBA,  # JSR (d16,PC) -- displacement safety
}

# Mnemonics where we drop the size suffix (vasm convention)
STRIP_SIZE = {
    'link.w': 'link',
    'lea.l': 'lea',
    'pea.l': 'pea',
    'exg.l': 'exg',
    'btst.b': 'btst',
    'btst.l': 'btst',
    'bchg.b': 'bchg',
    'bchg.l': 'bchg',
    'bclr.b': 'bclr',
    'bclr.l': 'bclr',
    'bset.b': 'bset',
    'bset.l': 'bset',
}

# Branch mnemonics (all safe as mnemonics, targets become local labels)
BRANCH_MNEMONICS = {
    'bra', 'bsr',  # bsr.b is safe (only bsr.w/$6100 is dc.w)
    'beq', 'bne', 'bcs', 'bcc', 'bmi', 'bpl',
    'bvs', 'bvc', 'bge', 'bgt', 'ble', 'blt',
    'bhi', 'bls',
}

# DBcc mnemonics
DBCC_MNEMONICS = {
    'dbra', 'dbeq', 'dbne', 'dbcs', 'dbcc', 'dbmi', 'dbpl',
    'dbvs', 'dbvc', 'dbge', 'dbgt', 'dble', 'dblt',
    'dbhi', 'dbls', 'dbf', 'dbt',
}


def load_rom(path):
    with open(path, 'rb') as f:
        return f.read()


def parse_addr(s):
    s = s.strip().lstrip('$')
    if s.startswith('0x') or s.startswith('0X'):
        return int(s, 16)
    # Try hex first (all our addresses are hex)
    return int(s, 16)


def parse_end(s, start):
    s = s.strip()
    if s.startswith('+'):
        return start + int(s[1:])
    return parse_addr(s)


# --- Capstone to vasm syntax transforms ---

def is_branch(mnemonic):
    """Check if mnemonic is a branch instruction (Bcc/BRA)."""
    base = mnemonic.split('.')[0]
    return base in BRANCH_MNEMONICS


def is_dbcc(mnemonic):
    """Check if mnemonic is a DBcc instruction."""
    base = mnemonic.split('.')[0]
    return base in DBCC_MNEMONICS


def fix_mnemonic(mnemonic):
    """Strip unnecessary size suffixes per vasm convention."""
    return STRIP_SIZE.get(mnemonic, mnemonic)


def format_neg_imm(val, size_bits):
    """Format a negative immediate value (for LINK, etc)."""
    if size_bits == 1:  # word
        if val > 0x7FFF:
            neg = 0x10000 - val
            return f'#-${neg:x}'
    elif size_bits == 2:  # long
        if val > 0x7FFFFFFF:
            neg = 0x100000000 - val
            return f'#-${neg:x}'
    return None


def fix_operands(op_str, insn, label_map, func_start, func_end):
    """Transform Capstone op_str to vasm syntax."""
    mnemonic = insn.mnemonic

    # Branch targets -> local labels (or keep as dc.w if unresolvable)
    base_mn = mnemonic.split('.')[0]
    if base_mn in BRANCH_MNEMONICS:
        # op_str is just the target address like "$6cd4"
        target = _parse_branch_target(op_str)
        if target is not None and target in label_map:
            return label_map[target]
        elif target is not None:
            # External branch or target in undecoded region -- keep address
            return f'${target:06x}'
        return op_str

    # DBcc: "d0, $1d532" -> "d0,.lXXXX"
    if base_mn in DBCC_MNEMONICS:
        parts = op_str.split(', ')
        if len(parts) == 2:
            reg = parts[0]
            target = _parse_branch_target(parts[1])
            if target is not None and target in label_map:
                return f'{reg},{label_map[target]}'
            elif target is not None:
                return f'{reg},${target:06x}'
        return op_str

    # Split on ", " (Capstone's separator)
    parts = op_str.split(', ')
    fixed = [_fix_single_operand(p, insn) for p in parts]
    return ','.join(fixed)


def _parse_branch_target(s):
    """Parse a branch target address from Capstone op_str."""
    s = s.strip()
    m = re.match(r'^\$([0-9a-fA-F]+)$', s)
    if m:
        return int(m.group(1), 16)
    return None


def _fix_single_operand(s, insn):
    """Fix a single operand string from Capstone to vasm convention."""
    s = s.strip()

    # Register a7 -> sp
    s = _normalize_a7(s)

    # Absolute long: "$ff1802.l" -> "($00FF1802).l"
    m = re.match(r'^\$([0-9a-fA-F]+)\.l$', s)
    if m:
        addr = int(m.group(1), 16)
        return f'(${addr:08X}).l'

    # Absolute word: "$10.w" -> "($0010).w"
    # For values > $7FFF, sign-extend to full address for vasm: ($FFFFAAAA).w
    m = re.match(r'^\$([0-9a-fA-F]+)\.w$', s)
    if m:
        addr = int(m.group(1), 16)
        if addr > 0x7FFF:
            full = 0xFFFF0000 | addr
            return f'(${full:08X}).w'
        return f'(${addr:04X}).w'

    # Bare absolute (no .l/.w suffix) -- e.g. jsr target
    # Capstone shows "jsr $1dfbe.l" for abs.l, handled above
    # Capstone shows "$1dfbe" bare for some -- treat as abs.l
    m = re.match(r'^\$([0-9a-fA-F]+)$', s)
    if m:
        addr = int(m.group(1), 16)
        if addr >= 0x8000:
            return f'${addr:08X}'
        return f'${addr:04X}'

    # Immediate: "#$xxx"
    m = re.match(r'^#\$([0-9a-fA-F]+)$', s)
    if m:
        val = int(m.group(1), 16)
        return _format_immediate(val, insn)

    # Negative immediate: "#-$xxx" (Capstone sometimes shows these)
    m = re.match(r'^#-\$([0-9a-fA-F]+)$', s)
    if m:
        val = int(m.group(1), 16)
        return f'#-${val:x}'

    # Zero immediate
    if s == '#$0' or s == '#0':
        return '#$0'

    # Displacement with register: "$a(a6)" -> "$000a(a6)"
    m = re.match(r'^(-?)(\$[0-9a-fA-F]+)\(([^)]+)\)$', s)
    if m:
        sign = m.group(1)
        disp_str = m.group(2)
        reg = m.group(3)
        disp = int(disp_str[1:], 16)
        if sign == '-':
            return f'-${disp:04x}({reg})'
        return f'${disp:04x}({reg})'

    # Indexed: "($base,$xn.s)" or "$d8($base,$xn.s)" -- pass through
    # Pre/post-increment/decrement: "-(a0)", "(a0)+" -- pass through
    # Register names: d0-d7, a0-a6, sp -- pass through
    # Register lists: "d2-d7/a2-a5" -- pass through

    return s


def _normalize_a7(s):
    """Replace a7 with sp in operand strings."""
    # Be careful not to replace inside hex numbers
    # a7 appears as register name, typically at word boundaries
    s = re.sub(r'\ba7\b', 'sp', s)
    return s


def _format_immediate(val, insn):
    """Format an immediate value based on instruction context."""
    mnemonic = insn.mnemonic

    # LINK: show as negative
    if mnemonic.startswith('link'):
        if val > 0x7FFF:
            neg = 0x10000 - val
            return f'#-${neg:x}'
        return f'#${val:x}'

    # MOVEQ: always byte-sized, show as $XX
    if mnemonic == 'moveq':
        return f'#${val:x}'

    # For other instructions, pad based on operation size
    # Detect size from mnemonic suffix
    if '.b' in mnemonic:
        return f'#${val:02x}'
    elif '.l' in mnemonic:
        if val <= 0xFF:
            return f'#${val:x}'
        elif val <= 0xFFFF:
            return f'#${val:04x}'
        return f'#${val:08x}'
    else:  # .w or unsized
        if val <= 0xFF:
            return f'#${val:x}'
        return f'#${val:04x}'


# --- Instruction classification ---

def classify_instruction(insn, rom, label_map, func_start, func_end):
    """Classify instruction as mnemonic or dc.w.
    Returns: ('MNEMONIC', asm_text) or ('DCW', dc_w_text, comment)
    """
    opword = struct.unpack_from('>H', insn.bytes)[0]

    # Check for forced dc.w opcodes
    if opword in FORCE_DCW_OPWORDS:
        words = []
        for i in range(0, len(insn.bytes), 2):
            w = struct.unpack_from('>H', insn.bytes, i)[0]
            words.append(f'${w:04x}')
        dc_w = ','.join(words)
        comment = f'{insn.mnemonic} ${_get_call_target(insn, opword):06X}'
        return ('DCW', f'dc.w    {dc_w}', comment)

    # Branches/DBcc to unresolved targets: emit as dc.w
    mn_base = insn.mnemonic.split('.')[0]
    if mn_base in BRANCH_MNEMONICS or mn_base in DBCC_MNEMONICS:
        op = insn.op_str
        if mn_base in DBCC_MNEMONICS:
            parts = op.split(', ')
            target_str = parts[1] if len(parts) == 2 else op
        else:
            target_str = op
        target = _parse_branch_target(target_str)
        if target is not None and target not in label_map:
            # External branch -- must stay as dc.w
            words = []
            for i in range(0, len(insn.bytes), 2):
                w = struct.unpack_from('>H', insn.bytes, i)[0]
                words.append(f'${w:04x}')
            dc_w = ','.join(words)
            comment = f'{insn.mnemonic} ${target:06X}'
            return ('DCW', f'dc.w    {dc_w}', comment)

    # Everything else: mnemonic
    mn = fix_mnemonic(insn.mnemonic)
    ops = fix_operands(insn.op_str, insn, label_map, func_start, func_end)
    if ops:
        asm = f'{mn:<8s}{ops}'
    else:
        asm = mn
    return ('MNEMONIC', asm)


def _get_call_target(insn, opword):
    """Extract the call target address from a JSR/BSR instruction."""
    if opword == 0x4EB9:  # JSR abs.l
        if len(insn.bytes) >= 6:
            return struct.unpack_from('>I', insn.bytes, 2)[0]
    elif opword == 0x6100:  # BSR.W
        if len(insn.bytes) >= 4:
            disp = struct.unpack_from('>h', insn.bytes, 2)[0]
            return insn.address + 2 + disp
    elif opword == 0x4EBA:  # JSR (d16,PC)
        if len(insn.bytes) >= 4:
            disp = struct.unpack_from('>h', insn.bytes, 2)[0]
            return insn.address + 2 + disp
    return 0


# --- Branch label collection ---

def collect_branch_targets(instructions, func_start, func_end):
    """Collect all intra-function branch targets."""
    targets = set()
    for insn in instructions:
        mn_base = insn.mnemonic.split('.')[0]
        if mn_base in BRANCH_MNEMONICS or mn_base in DBCC_MNEMONICS:
            # Parse target from op_str
            op = insn.op_str
            # For DBcc, target is second operand
            if mn_base in DBCC_MNEMONICS:
                parts = op.split(', ')
                if len(parts) == 2:
                    op = parts[1]
            target = _parse_branch_target(op)
            if target is not None and func_start <= target <= func_end:
                targets.add(target)
    return targets


def assign_labels(targets):
    """Create label map: address -> label name."""
    label_map = {}
    for addr in sorted(targets):
        label_map[addr] = f'.l{addr:04x}'
    return label_map


# --- Mode 1: Translate ---

def translate(rom, start, end):
    """Produce vasm-compatible assembly for ROM range."""
    cs = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_M68K_000)
    cs.detail = True

    chunk = rom[start:end]
    instructions = list(cs.disasm(chunk, start))

    # Pass 1: collect branch targets, filtering to decoded addresses only
    decoded_addrs = {insn.address for insn in instructions}
    targets = collect_branch_targets(instructions, start, end)
    targets = {t for t in targets if t in decoded_addrs}
    label_map = assign_labels(targets)

    # Emit header
    size = end - start
    lines = [
        f'; ============================================================================',
        f'; sub_{start:06X} -- (TODO: describe)',
        f'; Called: ?? times.',
        f'; {size} bytes | ${start:06X}-${end - 1:06X}',
        f'; ============================================================================',
        f'sub_{start:06X}:{" " * 50}; ${start:06X}',
    ]

    # Pass 2: emit instructions
    for insn in instructions:
        # Label line
        if insn.address in label_map:
            label = label_map[insn.address]
            addr_comment = f'; ${insn.address:06X}'
            lines.append(f'{label}:{" " * (56 - len(label) - 1)}{addr_comment}')

        classification = classify_instruction(insn, rom, label_map, start, end)
        if classification[0] == 'DCW':
            dc_text = classification[1]
            comment = classification[2]
            lines.append(f'    {dc_text:<52s}; {comment}')
        else:
            asm_text = classification[1]
            lines.append(f'    {asm_text}')

    # Report any undecoded trailing bytes
    if instructions:
        last = instructions[-1]
        decoded_end = last.address + last.size
        remaining = end - decoded_end
        if remaining > 0:
            lines.append(f'    ; WARNING: {remaining} undecoded trailing bytes at ${decoded_end:06X}')
            for off in range(decoded_end, end, 2):
                if off + 2 <= end:
                    w = struct.unpack_from('>H', rom, off)[0]
                    lines.append(f'    dc.w    ${w:04x}')
                else:
                    b = rom[off]
                    lines.append(f'    dc.b    ${b:02x}')

    return '\n'.join(lines)


# --- Mode 2: Verify ---

def verify(original_path, built_path, start, end, max_mismatches=10):
    """Compare ROM bytes vs built ROM at given range."""
    original = load_rom(original_path)
    try:
        built = load_rom(built_path)
    except FileNotFoundError:
        print(f'ERROR: {built_path} not found. Run "make all" first.')
        return False

    cs = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_M68K_000)

    mismatches = []
    for offset in range(start, min(end, len(original), len(built))):
        if original[offset] != built[offset]:
            mismatches.append(offset)
            if len(mismatches) >= max_mismatches:
                break

    if not mismatches:
        print(f'MATCH: ${start:06X}-${end - 1:06X} ({end - start} bytes)')
        return True

    print(f'MISMATCH: {len(mismatches)} difference(s) found\n')
    for off in mismatches:
        orig_b = original[off]
        built_b = built[off]
        print(f'  ${off:06X}: ROM=${orig_b:02X}  Built=${built_b:02X}')

        # Show context: aligned to word boundary, 8 bytes around mismatch
        ctx_start = max(start, (off - 4) & ~1)
        ctx_end = min(end, off + 6)
        orig_hex = original[ctx_start:ctx_end].hex().upper()
        built_hex = built[ctx_start:ctx_end].hex().upper()
        print(f'    ROM   ${ctx_start:06X}: {orig_hex}')
        print(f'    Built ${ctx_start:06X}: {built_hex}')

        # Disassemble ROM context
        window = original[ctx_start:ctx_end]
        for insn in cs.disasm(window, ctx_start):
            if insn.address <= off < insn.address + insn.size:
                print(f'    ROM disasm:   {insn.mnemonic} {insn.op_str}')
                break
        window = built[ctx_start:ctx_end]
        for insn in cs.disasm(window, ctx_start):
            if insn.address <= off < insn.address + insn.size:
                print(f'    Built disasm: {insn.mnemonic} {insn.op_str}')
                break
        print()

    return False


# --- Mode 3: Find function boundaries ---

def find_function(rom, addr):
    """Find function boundaries around an address."""
    cs = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_M68K_000)
    cs.detail = True

    # Scan backward for previous RTS/RTE
    func_start = addr
    scan_pos = addr - 2
    min_scan = max(0, addr - 0x4000)
    while scan_pos >= min_scan:
        w = struct.unpack_from('>H', rom, scan_pos)[0]
        if w in (0x4E75, 0x4E73):  # RTS or RTE
            func_start = scan_pos + 2
            break
        scan_pos -= 2

    # Scan forward from func_start to find end (RTS/RTE)
    func_end = func_start
    scan_pos = func_start
    max_scan = min(len(rom), func_start + 0x4000)
    while scan_pos < max_scan:
        chunk = rom[scan_pos:min(scan_pos + 10, max_scan)]
        decoded = False
        for insn in cs.disasm(chunk, scan_pos):
            scan_pos = insn.address + insn.size
            if insn.id in (capstone.m68k.M68K_INS_RTS, capstone.m68k.M68K_INS_RTE):
                func_end = scan_pos
                decoded = True
                break
            decoded = True
            break  # one instruction at a time
        if func_end > func_start:
            break
        if not decoded:
            scan_pos += 2

    size = func_end - func_start
    print(f'Function: ${func_start:06X} - ${func_end - 1:06X} ({size} bytes)')
    print()

    # Collect branch targets
    chunk = rom[func_start:func_end]
    instructions = list(cs.disasm(chunk, func_start))
    targets = collect_branch_targets(instructions, func_start, func_end)

    if targets:
        print(f'Branch targets ({len(targets)}):')
        for t in sorted(targets):
            print(f'  .l{t:04x}  (${t:06X})')
        print()

    # Show external calls
    external_calls = []
    for insn in instructions:
        opword = struct.unpack_from('>H', insn.bytes)[0]
        if opword in FORCE_DCW_OPWORDS:
            target = _get_call_target(insn, opword)
            if target:
                external_calls.append((insn.address, opword, target))

    if external_calls:
        print(f'External calls ({len(external_calls)}):')
        for addr, op, target in external_calls:
            kind = {0x4EB9: 'jsr', 0x6100: 'bsr.w', 0x4EBA: 'jsr(pc)'}[op]
            print(f'  ${addr:06X}: {kind} ${target:06X}')
        print()

    return func_start, func_end


# --- CLI ---

def main():
    parser = argparse.ArgumentParser(
        description='M68K translation tool for Aerobiz disassembly')

    parser.add_argument('start', nargs='?',
        help='Start address (hex, 0x prefix optional)')
    parser.add_argument('end', nargs='?',
        help='End address or +length')

    parser.add_argument('--verify', action='store_true',
        help='Compare ROM vs build bytes')
    parser.add_argument('--find-function', metavar='ADDR',
        help='Find function boundaries from address')
    parser.add_argument('--rom', default=ORIGINAL_ROM,
        help='Path to original ROM')
    parser.add_argument('--build', default=BUILD_ROM,
        help='Path to built ROM')
    parser.add_argument('--max-mismatches', type=int, default=10,
        help='Max mismatches to report (verify mode)')

    args = parser.parse_args()

    if args.find_function:
        rom = load_rom(args.rom)
        addr = parse_addr(args.find_function)
        find_function(rom, addr)
    elif args.verify:
        if not args.start or not args.end:
            parser.error('--verify requires start and end addresses')
        start = parse_addr(args.start)
        end = parse_end(args.end, start)
        verify(args.rom, args.build, start, end, args.max_mismatches)
    else:
        if not args.start or not args.end:
            parser.error('translate mode requires start and end addresses')
        start = parse_addr(args.start)
        end = parse_end(args.end, start)
        rom = load_rom(args.rom)
        print(translate(rom, start, end))


if __name__ == '__main__':
    main()
