#!/usr/bin/env python3
"""
Apply a vasm translation file to a section .asm file.

Uses ROM addresses from the translation header to determine which dc.w lines
to replace. Only replaces dc.w lines whose ROM address falls within the
translated range. Handles split dc.w lines at boundaries by emitting remaining
bytes as a new dc.w line.

Usage: python3 tools/apply_translation.py <section_file> <translation_file> <start_line> <end_line>

start_line/end_line define the search range in the section file (1-indexed, inclusive).
The actual replacement uses ROM address matching from the translation file header.
"""

import re
import sys

def extract_rom_addr(line):
    """Extract ROM address from dc.w comment like '; $XXXXXX'."""
    m = re.search(r';\s*\$([0-9A-Fa-f]{6})', line)
    if m:
        return int(m.group(1), 16)
    return None

def extract_dc_w_words(line):
    """Extract the hex words from a dc.w line."""
    stripped = line.strip()
    if not stripped.startswith('dc.w'):
        return []
    parts = stripped.split(';')[0].strip()
    parts = parts[4:].strip()  # remove 'dc.w'
    words = []
    for w in parts.split(','):
        w = w.strip()
        if w.startswith('$'):
            words.append(w)
    return words

def get_translation_range(translation_lines):
    """Extract the translated byte range from the vasm header.

    Looks for function headers like:
    ; NNN bytes | $XXXXXX-$YYYYYY
    Returns (first_start, last_end) as the full coverage range.
    """
    first_start = None
    last_end = None
    for line in translation_lines:
        m = re.match(r'^;\s*\d+\s+bytes\s*\|\s*\$([0-9A-Fa-f]+)-\$([0-9A-Fa-f]+)', line)
        if m:
            start = int(m.group(1), 16)
            end = int(m.group(2), 16)
            if first_start is None or start < first_start:
                first_start = start
            if last_end is None or end > last_end:
                last_end = end
    return first_start, last_end

def count_dc_w_bytes(line):
    """Count bytes in a dc.w line."""
    return len(extract_dc_w_words(line)) * 2

def format_dc_w_line(words, addr):
    """Format words as a dc.w line with address comment."""
    word_str = ','.join(words)
    return f'    dc.w    {word_str}; ${addr:06X}\n'

def main():
    if len(sys.argv) != 5:
        print(f"Usage: {sys.argv[0]} <section_file> <translation_file> <start_line> <end_line>")
        sys.exit(1)

    section_file = sys.argv[1]
    translation_file = sys.argv[2]
    start_line = int(sys.argv[3])
    end_line = int(sys.argv[4])

    with open(section_file, 'r') as f:
        section_lines = f.readlines()

    with open(translation_file, 'r') as f:
        translation_lines = f.readlines()

    # Get translated ROM address range
    trans_start, trans_end = get_translation_range(translation_lines)
    if trans_start is None:
        print("ERROR: Could not extract translation range from header")
        sys.exit(1)

    print(f"Translation covers ROM ${trans_start:06X}-${trans_end:06X}")

    # Find dc.w lines within search range whose ROM address is in translated range
    start_idx = start_line - 1
    end_idx = end_line  # exclusive

    first_replace = None
    last_replace = None
    replaced_bytes = 0
    suffix_line = None  # dc.w line for bytes after translation end

    for i in range(start_idx, min(end_idx, len(section_lines))):
        line = section_lines[i]
        addr = extract_rom_addr(line)
        if addr is not None and line.strip().startswith('dc.w'):
            line_bytes = count_dc_w_bytes(line)
            line_end = addr + line_bytes - 1
            # Replace this line if it overlaps with translation range
            if addr <= trans_end and line_end >= trans_start:
                if first_replace is None:
                    first_replace = i
                last_replace = i
                replaced_bytes += line_bytes

                # Check if this line extends beyond the translation end
                if line_end > trans_end:
                    # Split: keep bytes after trans_end+1 as suffix dc.w
                    words = extract_dc_w_words(line)
                    # Each word is 2 bytes. Translation ends at trans_end (inclusive).
                    # Byte at trans_end+1 is the first untranslated byte.
                    cut_offset = trans_end + 1 - addr  # byte offset within line
                    cut_word = cut_offset // 2  # word index to start suffix
                    if cut_offset % 2 != 0:
                        print(f"WARNING: Translation boundary at ${trans_end:06X} falls mid-word!")
                        print(f"  Line at ${addr:06X}, cut_offset={cut_offset}")
                    if cut_word < len(words):
                        suffix_words = words[cut_word:]
                        suffix_addr = addr + cut_word * 2
                        suffix_line = format_dc_w_line(suffix_words, suffix_addr)
                        print(f"Split dc.w line at ${addr:06X}: keeping {len(suffix_words)} suffix words at ${suffix_addr:06X}")

    if first_replace is None:
        print("ERROR: No dc.w lines found matching translation range")
        sys.exit(1)

    print(f"Section file: {section_file}")
    print(f"Replacing lines {first_replace+1}-{last_replace+1} ({last_replace-first_replace+1} dc.w lines)")
    print(f"DC.W bytes in replaced block: {replaced_bytes}")
    print(f"Translation file: {translation_file} ({len(translation_lines)} lines)")

    # Build output
    output_lines = []
    output_lines.extend(section_lines[:first_replace])
    output_lines.extend(translation_lines)
    if suffix_line:
        output_lines.append(suffix_line)
    output_lines.extend(section_lines[last_replace+1:])

    with open(section_file, 'w') as f:
        f.writelines(output_lines)

    print(f"Done. New file has {len(output_lines)} lines (was {len(section_lines)})")

if __name__ == '__main__':
    main()
