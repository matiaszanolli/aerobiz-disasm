#!/usr/bin/env python3
"""
Disassemble a ROM region that may contain jump tables.

Scans for jump table dispatch patterns (MOVE.W (PC,Dn) + JMP (PC,Dn)),
determines table boundaries, then runs capstone on each code segment.

Output format matches capstone (tools/disasm.py) for compatibility with
translate_block.py.

Usage: pyenv exec python3 tools/disasm_jtab.py <rom_file> <start_hex> <end_hex>
"""

import struct
import subprocess
import sys


def read_rom(path, start, end):
    with open(path, 'rb') as f:
        f.seek(start)
        return f.read(end - start)


def find_jump_tables(data, base):
    """Find MOVE.W (PC,Dn) + JMP (PC,Dn) dispatch pairs and their data tables."""
    tables = []
    i = 0
    while i < len(data) - 8:
        w0 = struct.unpack('>H', data[i:i+2])[0]
        # MOVE.W (d8,PC,Dn.x),Dm: opcode is 0x303B for D0 dest, but could be others
        # General pattern: 0x3x3B where x encodes dest reg
        # More precisely: bits[15:12]=0011, bits[8:6]=000 (word), bits[5:0]=111011 (PC indexed)
        # So mask = 0xF1FF, value = 0x303B (any Dn destination)
        if (w0 & 0xF1FF) == 0x303B:
            w1 = struct.unpack('>H', data[i+2:i+4])[0]
            w2 = struct.unpack('>H', data[i+4:i+6])[0]
            w3 = struct.unpack('>H', data[i+6:i+8])[0]
            # Next instruction should be JMP (d8,PC,Dn): $4EFB xxxx
            if w2 == 0x4EFB:
                dispatch_addr = base + i
                table_addr = base + i + 8  # table starts right after the 2 instructions

                # Determine table size: entries are word offsets relative to table_addr
                entries = []
                j = i + 8
                while j + 1 < len(data):
                    entry_raw = struct.unpack('>H', data[j:j+2])[0]
                    signed = entry_raw if entry_raw < 0x8000 else entry_raw - 0x10000
                    target = table_addr + signed
                    # Valid entry: target must be within the block
                    if target < base or target >= base + len(data):
                        break
                    entries.append(entry_raw)
                    j += 2
                    if len(entries) > 256:
                        break

                if entries:
                    table_end = table_addr + len(entries) * 2
                    tables.append({
                        'dispatch_addr': dispatch_addr,
                        'table_addr': table_addr,
                        'table_end': table_end,
                        'entries': entries,
                        'dispatch_bytes': data[i:i+8],
                    })
                    i = j
                    continue
        i += 2
    return tables


def disasm_capstone(start, end):
    """Run capstone disassembler on a code segment. Returns list of output lines."""
    if start >= end:
        return []
    result = subprocess.run(
        ['pyenv', 'exec', 'python3', 'tools/disasm.py', f'{start:06X}', f'{end:06X}'],
        capture_output=True, text=True, timeout=30
    )
    lines = []
    for line in result.stdout.strip().split('\n'):
        if line and 'undecoded' not in line:
            lines.append(line)
    return lines


def main():
    if len(sys.argv) < 4:
        print(f'Usage: {sys.argv[0]} <rom_file> <start_hex> <end_hex>', file=sys.stderr)
        sys.exit(1)

    rom_file = sys.argv[1]
    start = int(sys.argv[2], 16)
    end = int(sys.argv[3], 16)

    data = read_rom(rom_file, start, end)
    tables = find_jump_tables(data, start)

    if tables:
        print(f'; {len(tables)} jump table(s) found', file=sys.stderr)
        for t in tables:
            n = len(t['entries'])
            print(f';   dispatch ${t["dispatch_addr"]:06X}, '
                  f'table ${t["table_addr"]:06X}-${t["table_end"]:06X} ({n} entries)',
                  file=sys.stderr)

    # Build segments: code, dispatch, table, code, ...
    segments = []
    pos = start
    for t in sorted(tables, key=lambda x: x['dispatch_addr']):
        if pos < t['dispatch_addr']:
            segments.append(('code', pos, t['dispatch_addr']))
        segments.append(('dispatch', t))
        segments.append(('table', t))
        pos = t['table_end']
    if pos < end:
        segments.append(('code', pos, end))

    for seg in segments:
        if seg[0] == 'code':
            for line in disasm_capstone(seg[1], seg[2]):
                print(line)
        elif seg[0] == 'dispatch':
            t = seg[1]
            db = t['dispatch_bytes']
            w = [struct.unpack('>H', db[i:i+2])[0] for i in range(0, 8, 2)]
            addr = t['dispatch_addr']
            # Emit as raw hex so translate_block.py keeps them as dc.w
            print(f'  ${addr:06X}: {db[0:4].hex().upper():8s}     '
                  f'MOVE.W ({w[1] & 0xFF},PC,D{(w[1]>>12)&7}.{"L" if w[1]&0x800 else "W"}),D{(w[0]>>9)&7}')
            print(f'  ${addr+4:06X}: {db[4:8].hex().upper():8s}     '
                  f'JMP ({w[3] & 0xFF},PC,D{(w[3]>>12)&7}.{"L" if w[3]&0x800 else "W"})')
        elif seg[0] == 'table':
            t = seg[1]
            addr = t['table_addr']
            for entry in t['entries']:
                signed = entry if entry < 0x8000 else entry - 0x10000
                target = t['table_addr'] + signed
                print(f'  ${addr:06X}: {entry:04X}         DC.W ${entry:04X}')
                addr += 2


if __name__ == '__main__':
    main()
