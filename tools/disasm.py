#!/usr/bin/env python3
"""
disasm.py -- Reliable M68K disassembler for Aerobiz ROM using Capstone.

Usage:
    python3 tools/disasm.py <start_hex> [end_hex|+length]

Examples:
    python3 tools/disasm.py 0x5A04 0x5C64
    python3 tools/disasm.py 0x5A04 +608
    python3 tools/disasm.py 5A04 5C64     # 0x prefix optional
"""

import sys
import capstone

ROM = 'build/aerobiz.bin'


def parse_addr(s):
    s = s.strip()
    if s.startswith('+'):
        return int(s[1:])   # length
    return int(s, 16)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    start = parse_addr(sys.argv[1])
    if len(sys.argv) >= 3:
        arg2 = sys.argv[2]
        if arg2.startswith('+'):
            end = start + int(arg2[1:])
        else:
            end = parse_addr(arg2)
    else:
        end = start + 256

    data = open(ROM, 'rb').read()
    chunk = data[start:end]

    cs = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_M68K_000)
    cs.detail = False

    offset = 0
    for insn in cs.disasm(chunk, start):
        raw = insn.bytes.hex().upper()
        print(f'  ${insn.address:06X}: {raw:<12} {insn.mnemonic.upper()} {insn.op_str}')
        offset = insn.address - start + len(insn.bytes)

    # Report any trailing bytes capstone couldn't decode
    remaining = chunk[offset:]
    if remaining:
        addr = start + offset
        raw = remaining.hex().upper()
        print(f'  ${addr:06X}: {raw} (undecoded)')


if __name__ == '__main__':
    main()
