#!/usr/bin/env python3
"""Fix moveq sign warnings: moveq #$FF,d0 -> moveq #-$1,d0"""
import re
import sys

def fix_moveq(match):
    prefix = match.group(1)
    hexval = match.group(2)
    reg = match.group(3)
    val = int(hexval, 16)
    if val >= 0x80:
        signed = val - 0x100
        return f'{prefix}#-${abs(signed):X},{reg}'
    return match.group(0)

files = sys.argv[1:] or [
    'disasm/sections/section_000200.asm',
    'disasm/sections/section_010000.asm',
    'disasm/sections/section_020000.asm',
    'disasm/sections/section_030000.asm',
]

for fname in files:
    with open(fname) as f:
        content = f.read()
    pattern = r'(    moveq   )#\$([89a-fA-F][0-9a-fA-F]),(d\d)'
    new_content = re.sub(pattern, fix_moveq, content)
    if new_content != content:
        count = len(re.findall(pattern, content))
        with open(fname, 'w') as f:
            f.write(new_content)
        print(f'{fname}: fixed {count}')
    else:
        print(f'{fname}: ok')
