#!/usr/bin/env python3
"""
Translate a block of capstone disassembly to vasm-compatible 68K assembly.

Usage: python3 tools/translate_block.py <disasm_file> [--start ADDR] [--end ADDR]

Rules (from MEMORY.md / KNOWN_ISSUES.md):
- JSR abs.l → dc.w (vasm may choose abs.w for small addresses)
- BSR.W → dc.w (vasm +2 displacement bug)
- JSR (PC,d16) → dc.w + nop
- PEA → safe as mnemonic with (.w) or (.l) suffix
- Branch targets → local labels (.lXXXXX)
- $FFxxxx addresses → force ($00FFxxxx).l suffix
- MOVEM → use capstone's register list (correct for load direction)
"""

import re
import sys
import struct

def parse_disasm_line(line):
    """Parse a capstone disassembly line into (addr, raw_bytes, mnemonic, operands)."""
    m = re.match(r'\s*\$([0-9A-Fa-f]+):\s+([0-9A-Fa-f]+)\s+(\S+)\s*(.*)', line)
    if not m:
        return None
    addr = int(m.group(1), 16)
    raw = m.group(2)
    mnem = m.group(3)
    ops = m.group(4).strip()
    raw_bytes = bytes.fromhex(raw)
    return (addr, raw_bytes, mnem, ops)

def needs_abs_l(addr_val):
    """Check if an address needs .l forcing (can't use abs.w sign extension)."""
    # abs.w sign-extends from 16-bit: $0000-$7FFF and $FF8000-$FFFFFF
    # Addresses $8000-$FEFFFF and $00FF0000+ need abs.l
    if addr_val > 0x7FFF and addr_val < 0xFF8000:
        return True
    # $00FFxxxx is fine for abs.w if sign-extended ($FFxxxx)
    # But vasm may not handle it correctly for clr/tst/move to these
    # Force .l for any RAM address
    if addr_val >= 0xFF0000:
        return True
    return False

def format_immediate(val, size='w'):
    """Format an immediate value."""
    if val < 0:
        return f'#-${abs(val):X}'
    return f'#${val:X}'

def capstone_to_vasm(addr, raw_bytes, mnem, ops, branch_targets, func_start):
    """Convert a single capstone instruction to vasm syntax.

    Returns (vasm_line, is_dc_w, comment) tuple.
    """
    word0 = struct.unpack('>H', raw_bytes[0:2])[0]
    instr_len = len(raw_bytes)

    # === Special cases: keep as dc.w ===

    # JSR abs.l ($4EB9)
    if word0 == 0x4EB9 and instr_len == 6:
        target = struct.unpack('>I', raw_bytes[2:6])[0]
        w1, w2 = struct.unpack('>HH', raw_bytes[2:6])
        return f'dc.w    ${word0:04X},${w1:04X},${w2:04X}', True, f'jsr ${target:06X}'

    # BSR.W ($6100)
    if word0 == 0x6100:
        disp = struct.unpack('>h', raw_bytes[2:4])[0]
        target = addr + 2 + disp
        return f'dc.w    ${word0:04X},${raw_bytes[2]:02X}{raw_bytes[3]:02X}', True, f'bsr.w ${target:06X}'

    # JSR (d16,PC) ($4EBA)
    if word0 == 0x4EBA:
        disp = struct.unpack('>h', raw_bytes[2:4])[0]
        target = addr + 2 + disp
        return f'dc.w    ${word0:04X},${raw_bytes[2]:02X}{raw_bytes[3]:02X}', True, f'jsr ${target:06X}(pc)'

    # JMP (d16,PC) ($4EFB) - jump table dispatch
    if word0 == 0x4EFB:
        ext = struct.unpack('>H', raw_bytes[2:4])[0]
        return f'dc.w    ${word0:04X},${ext:04X}', True, f'jmp (pc,d{(ext>>12)&7}.w)'

    # === Translate to mnemonics ===

    mnem_lower = mnem.rstrip('.').lower()

    # Handle size suffix from capstone
    size = ''
    if '.' in mnem:
        parts = mnem.split('.')
        mnem_lower = parts[0].lower()
        size = '.' + parts[1].lower()

    # RTS
    if mnem_lower == 'rts':
        return 'rts', False, None

    # RTE
    if mnem_lower == 'rte':
        return 'rte', False, None

    # NOP
    if mnem_lower == 'nop':
        return 'nop', False, None

    # PEA — no size suffix, format as pea ($XX).w or pea ($XXXXXXXX).l
    # For abs.w with values >= $8000, use negative signed form (vasm treats unsigned > $7FFF as out of range)
    if mnem_lower == 'pea':
        m_abs = re.match(r'\$([0-9a-fA-F]+)\.(w|l)', ops, re.I)
        if m_abs:
            val = int(m_abs.group(1), 16)
            suffix = m_abs.group(2).lower()
            if suffix == 'w':
                if val >= 0x8000 and val <= 0xFFFF:
                    signed_val = val - 0x10000  # sign-extend 16-bit
                    return f'pea     (-${abs(signed_val):X}).w', False, None
                return f'pea     (${val:04X}).w', False, None
            else:
                return f'pea     (${val:08X}).l', False, None
        m_abs2 = re.match(r'\$([0-9a-fA-F]+)$', ops)
        if m_abs2:
            val = int(m_abs2.group(1), 16)
            if val <= 0x7FFF:
                return f'pea     (${val:04X}).w', False, None
            else:
                return f'pea     (${val:08X}).l', False, None
        # PEA with register-relative: pea $XX(An)
        m_rel = re.match(r'(-?\$[0-9a-fA-F]+)\((a\d)\)', ops, re.I)
        if m_rel:
            return f'pea     {m_rel.group(1).lower()}({m_rel.group(2).lower()})', False, None
        return f'pea     {ops.lower()}', False, None

    # LINK
    if mnem_lower == 'link':
        m = re.match(r'(\w+),\s*#?\$?(-?[0-9a-fA-F]+)', ops)
        if m:
            reg = m.group(1).lower()
            val = int(m.group(2), 16)
            if val > 0x7FFF:
                val = val - 0x10000  # sign extend
            return f'link    {reg},#-${abs(val):X}' if val < 0 else f'link    {reg},#${val:X}', False, None

    # UNLK
    if mnem_lower == 'unlk':
        return f'unlk    {ops.lower()}', False, None

    # MOVEQ — sign-extend values $80-$FF to avoid vasm warnings
    if mnem_lower == 'moveq':
        m = re.match(r'#\$([0-9a-fA-F]+),\s*(\w+)', ops)
        if m:
            val = int(m.group(1), 16)
            reg = m.group(2).lower()
            if val >= 0x80 and val <= 0xFF:
                signed_val = val - 0x100  # e.g. $FF -> -1
                return f'moveq   #-${abs(signed_val):X},{reg}', False, None
            return f'moveq   #${val:X},{reg}', False, None

    # LEA — no size suffix
    if mnem_lower == 'lea':
        size = ''  # LEA has no size

    # Bit operations — no size suffix (implicit: long for Dn, byte for memory)
    # EXG, SWAP — also no size suffix (always 32-bit)
    if mnem_lower in ('btst', 'bchg', 'bclr', 'bset', 'exg', 'swap'):
        size = ''

    # MOVEA — format #$imm with full 8-digit addresses for RAM
    if mnem_lower == 'movea':
        m_imm = re.match(r'#\$([0-9a-fA-F]+),\s*(a\d)', ops, re.I)
        if m_imm:
            val = int(m_imm.group(1), 16)
            reg = m_imm.group(2).lower()
            return f'movea{size}  #${val:08X},{reg}', False, None

    # Convert operands
    vasm_ops = convert_operands(ops, mnem_lower, size, addr, branch_targets, func_start)

    # Pad mnemonic
    if size:
        full_mnem = f'{mnem_lower}{size}'
    else:
        full_mnem = mnem_lower

    return f'{full_mnem:<8s}{vasm_ops}', False, None

def convert_operands(ops, mnem, size, addr, branch_targets, func_start):
    """Convert capstone operand syntax to vasm syntax."""
    if not ops:
        return ''

    # Split operands (careful with parentheses)
    parts = split_operands(ops)
    converted = []

    for part in parts:
        converted.append(convert_single_operand(part.strip(), mnem, size, addr, branch_targets, func_start))

    return ', '.join(converted)

def split_operands(ops):
    """Split operands by comma, respecting parentheses."""
    result = []
    depth = 0
    current = ''
    for ch in ops:
        if ch == '(' or ch == '{':
            depth += 1
        elif ch == ')' or ch == '}':
            depth -= 1
        elif ch == ',' and depth == 0:
            result.append(current)
            current = ''
            continue
        current += ch
    if current:
        result.append(current)
    return result

def convert_single_operand(op, mnem, size, addr, branch_targets, func_start):
    """Convert a single operand from capstone to vasm syntax."""
    op = op.strip()

    # Branch targets → local labels
    if mnem in ('bra', 'beq', 'bne', 'bcc', 'bcs', 'bge', 'bgt', 'ble', 'blt',
                'bhi', 'bls', 'bpl', 'bmi', 'bvc', 'bvs'):
        m = re.match(r'\$([0-9a-fA-F]+)', op)
        if m:
            target = int(m.group(1), 16)
            label = f'l_{target:05x}'
            branch_targets.add(target)
            return label

    # DBRA/DBcc targets
    if mnem in ('dbra', 'dbeq', 'dbne', 'dbf'):
        parts = split_operands(op)
        if len(parts) == 2:
            m = re.match(r'\$([0-9a-fA-F]+)', parts[1].strip())
            if m:
                target = int(m.group(1), 16)
                label = f'l_{target:05x}'
                branch_targets.add(target)
                return f'{parts[0].strip().lower()},{label}'

    # Register names → lowercase
    op_lower = op.lower()

    # Immediate values: #$XX or #XX
    if op.startswith('#'):
        return op_lower

    # Absolute addresses: $XXXX.l or $XXXX.w
    m = re.match(r'\$([0-9a-fA-F]+)\.([wl])', op)
    if m:
        val = int(m.group(1), 16)
        suffix = m.group(2)
        if suffix == 'l' or needs_abs_l(val):
            return f'(${val:08X}).l'
        return f'${val:04X}'

    # Bare absolute address (no suffix): $XXXX
    m = re.match(r'^\$([0-9a-fA-F]+)$', op)
    if m:
        val = int(m.group(1), 16)
        if needs_abs_l(val):
            return f'(${val:08X}).l'
        return f'${val:X}'

    # (d16, An) → $XXXX(An)
    m = re.match(r'\(\$(-?[0-9a-fA-F]+),\s*(a\d|sp)\)', op, re.I)
    if m:
        disp = int(m.group(1), 16)
        reg = m.group(2).lower()
        if reg == 'sp':
            reg = 'sp'
        if disp > 0x7FFF:
            disp = disp - 0x10000
        if disp < 0:
            return f'-${abs(disp):X}({reg})'
        return f'${disp:04X}({reg})'

    # -(An) → -(an)
    m = re.match(r'-\((a\d|sp)\)', op, re.I)
    if m:
        return f'-({m.group(1).lower()})'

    # (An)+ → (an)+
    m = re.match(r'\((a\d|sp)\)\+', op, re.I)
    if m:
        return f'({m.group(1).lower()})+'

    # (An) → (an)
    m = re.match(r'\((a\d|sp)\)$', op, re.I)
    if m:
        return f'({m.group(1).lower()})'

    # (d8, An, Xn.s) → d8(An,Xn.s)
    m = re.match(r'\(\$?(-?[0-9a-fA-F]+)?,\s*(a\d|sp),\s*(d\d|a\d)\.(w|l)\)', op, re.I)
    if m:
        disp = int(m.group(1) or '0', 16)
        base = m.group(2).lower()
        idx = m.group(3).lower()
        idx_size = m.group(4).lower()
        if disp > 0:
            return f'${disp:X}({base},{idx}.{idx_size})'
        return f'({base},{idx}.{idx_size})'

    # (An, Xn.s) without displacement
    m = re.match(r'\((a\d|sp),\s*(d\d|a\d)\.(w|l)\)', op, re.I)
    if m:
        base = m.group(1).lower()
        idx = m.group(2).lower()
        idx_size = m.group(3).lower()
        return f'({base},{idx}.{idx_size})'

    # LEA.L (d8, An, Xn) patterns
    m = re.match(r'\((a\d),\s*(d\d)\.(w|l)\)', op, re.I)
    if m:
        base = m.group(1).lower()
        idx = m.group(2).lower()
        idx_size = m.group(3).lower()
        return f'({base},{idx}.{idx_size})'

    # PEA with absolute
    # Already handled by absolute address patterns above

    # MOVEM register list
    if '{' in op:
        # Capstone uses {d0, d1, d2} format
        regs = re.findall(r'[ad]\d|sp', op, re.I)
        if regs:
            return format_reglist(regs)

    # Simple register
    if re.match(r'^[ad]\d$', op, re.I):
        return op.lower()
    if op.lower() in ('sp', 'a7', 'sr', 'ccr', 'usp', 'pc'):
        return op.lower()

    return op_lower

def format_reglist(regs):
    """Format a register list for MOVEM in vasm syntax (e.g., d2-d7/a2-a5)."""
    regs = [r.lower() for r in regs]

    d_regs = sorted([int(r[1]) for r in regs if r.startswith('d')])
    a_regs = sorted([int(r[1]) for r in regs if r.startswith('a')])

    parts = []
    if d_regs:
        parts.append(format_reg_range('d', d_regs))
    if a_regs:
        parts.append(format_reg_range('a', a_regs))

    return '/'.join(parts)

def format_reg_range(prefix, nums):
    """Format consecutive register numbers as ranges."""
    if not nums:
        return ''

    ranges = []
    start = nums[0]
    end = nums[0]

    for n in nums[1:]:
        if n == end + 1:
            end = n
        else:
            if start == end:
                ranges.append(f'{prefix}{start}')
            else:
                ranges.append(f'{prefix}{start}-{prefix}{end}')
            start = n
            end = n

    if start == end:
        ranges.append(f'{prefix}{start}')
    else:
        ranges.append(f'{prefix}{start}-{prefix}{end}')

    return '/'.join(ranges)

def translate_function(lines, func_start, func_end, global_branch_targets=None, block_start=None, block_end=None):
    """Translate a function from capstone output to vasm assembly."""
    branch_targets = set(global_branch_targets) if global_branch_targets else set()
    instructions = []

    # First pass: parse all instructions and collect branch targets
    for line in lines:
        parsed = parse_disasm_line(line)
        if not parsed:
            continue
        addr, raw_bytes, mnem, ops = parsed
        if addr < func_start or addr >= func_end:
            continue
        instructions.append(parsed)

        # Collect branch targets
        mnem_lower = mnem.split('.')[0].lower()
        if mnem_lower in ('bra', 'beq', 'bne', 'bcc', 'bcs', 'bge', 'bgt', 'ble', 'blt',
                          'bhi', 'bls', 'bpl', 'bmi', 'bvc', 'bvs'):
            m = re.match(r'\$([0-9a-fA-F]+)', ops)
            if m:
                branch_targets.add(int(m.group(1), 16))
        if mnem_lower in ('dbra', 'dbeq', 'dbne', 'dbf'):
            parts = ops.split(',')
            if len(parts) >= 2:
                m = re.match(r'\s*\$([0-9a-fA-F]+)', parts[-1])
                if m:
                    branch_targets.add(int(m.group(1), 16))

    # Second pass: generate vasm output
    output = []
    for addr, raw_bytes, mnem, ops in instructions:
        # Insert branch target label if needed (skip func_start — already emitted by caller)
        if addr in branch_targets and addr != func_start:
            output.append(f'l_{addr:05x}:')

        # Check if this is a branch to an external address (outside block range)
        # If so, emit as dc.w to avoid unresolvable label references
        external_branch = False
        if block_start is not None and block_end is not None:
            mnem_lower = mnem.split('.')[0].lower()
            if mnem_lower in ('bra', 'beq', 'bne', 'bcc', 'bcs', 'bge', 'bgt', 'ble', 'blt',
                              'bhi', 'bls', 'bpl', 'bmi', 'bvc', 'bvs'):
                m_target = re.match(r'\$([0-9a-fA-F]+)', ops)
                if m_target:
                    target = int(m_target.group(1), 16)
                    if target < block_start or target >= block_end:
                        external_branch = True
            if mnem_lower in ('dbra', 'dbeq', 'dbne', 'dbf'):
                parts = ops.split(',')
                if len(parts) >= 2:
                    m_target = re.match(r'\s*\$([0-9a-fA-F]+)', parts[-1])
                    if m_target:
                        target = int(m_target.group(1), 16)
                        if target < block_start or target >= block_end:
                            external_branch = True

        if external_branch:
            # Emit as dc.w to avoid external label references
            words = [f'${b1:02X}{b2:02X}' for b1, b2 in zip(raw_bytes[::2], raw_bytes[1::2])]
            word_str = ','.join(words)
            mnem_lower = mnem.split('.')[0].lower()
            m_target = re.match(r'.*\$([0-9a-fA-F]+)', ops)
            target = int(m_target.group(1), 16) if m_target else 0
            line = f'    dc.w    {word_str:<52s}; {mnem_lower} ${target:06X}'
        else:
            vasm, is_dcw, comment = capstone_to_vasm(addr, raw_bytes, mnem, ops, branch_targets, func_start)

            # Format with proper indentation and address comment
            if comment:
                line = f'    {vasm:<52s}; {comment}'
            else:
                line = f'    {vasm}'

        output.append(line)

    return output

def find_rts_boundaries(lines, block_start, block_end):
    """Find function boundaries based on RTS markers."""
    functions = []
    current_start = block_start

    for line in lines:
        parsed = parse_disasm_line(line)
        if not parsed:
            continue
        addr, raw_bytes, mnem, ops = parsed
        if addr < block_start or addr >= block_end:
            continue

        if mnem == 'RTS':
            func_end = addr + 2
            functions.append((current_start, func_end))
            current_start = func_end

    return functions

def collect_all_branch_targets(lines, functions):
    """Collect all branch targets across all functions (for cross-function labels)."""
    all_targets = set()
    for fstart, fend in functions:
        for line in lines:
            parsed = parse_disasm_line(line)
            if not parsed:
                continue
            addr, raw_bytes, mnem, ops = parsed
            if addr < fstart or addr >= fend:
                continue
            mnem_lower = mnem.split('.')[0].lower()
            if mnem_lower in ('bra', 'beq', 'bne', 'bcc', 'bcs', 'bge', 'bgt', 'ble', 'blt',
                              'bhi', 'bls', 'bpl', 'bmi', 'bvc', 'bvs'):
                m = re.match(r'\$([0-9a-fA-F]+)', ops)
                if m:
                    all_targets.add(int(m.group(1), 16))
            if mnem_lower in ('dbra', 'dbeq', 'dbne', 'dbf'):
                parts = ops.split(',')
                if len(parts) >= 2:
                    m = re.match(r'\s*\$([0-9a-fA-F]+)', parts[-1])
                    if m:
                        all_targets.add(int(m.group(1), 16))
    return all_targets


def main():
    if len(sys.argv) < 2:
        print(f'Usage: {sys.argv[0]} <disasm_file> [--start ADDR] [--end ADDR]')
        sys.exit(1)

    disasm_file = sys.argv[1]

    with open(disasm_file) as f:
        lines = f.readlines()

    # Parse optional address range
    start_addr = None
    end_addr = None
    for i, arg in enumerate(sys.argv[2:]):
        if arg == '--start' and i + 3 < len(sys.argv):
            start_addr = int(sys.argv[i + 3], 16)
        if arg == '--end' and i + 3 < len(sys.argv):
            end_addr = int(sys.argv[i + 3], 16)

    # Find function boundaries
    all_parsed = [parse_disasm_line(l) for l in lines]
    all_parsed = [p for p in all_parsed if p]

    if not all_parsed:
        print("No instructions found", file=sys.stderr)
        sys.exit(1)

    if start_addr is None:
        start_addr = all_parsed[0][0]
    if end_addr is None:
        end_addr = all_parsed[-1][0] + len(all_parsed[-1][1])

    functions = find_rts_boundaries(lines, start_addr, end_addr)

    # Collect branch targets globally to handle cross-function branches
    global_branch_targets = collect_all_branch_targets(lines, functions)
    func_starts = {fstart for fstart, _ in functions}

    print(f'; === Translated block ${start_addr:06X}-${end_addr:06X} ===')
    print(f'; {len(functions)} functions, {end_addr - start_addr} bytes')
    print()

    for i, (fstart, fend) in enumerate(functions):
        size = fend - fstart
        print(f'; ============================================================================')
        print(f'; func_{fstart:06X} -- (TODO: name)')
        print(f'; {size} bytes | ${fstart:06X}-${fend-1:06X}')
        print(f'; ============================================================================')
        print(f'func_{fstart:06X}:')
        # Emit l_XXXXX alias if this function start is a branch target from another function
        if fstart in global_branch_targets:
            print(f'l_{fstart:05x}:')

        output = translate_function(lines, fstart, fend, global_branch_targets, start_addr, end_addr)
        for line in output:
            print(line)

        print()

if __name__ == '__main__':
    main()
