#!/usr/bin/env python3
"""
gen_call_graph.py -- Generate call graph cross-reference for Aerobiz Supersonic disassembly.

Scans the 4 primary code section files and builds:
  {callee: [caller, ...]} dict
  Output: analysis/CALL_GRAPH.md

Call patterns matched:
  jsr FunctionName          (abs.l)
  jsr (FunctionName,PC)     (PC-relative)
  bsr.w FunctionName
  bsr.s FunctionName

Global label rules:
  - Match: ^[A-Za-z][A-Za-z0-9_]*:  (not starting with dot, not l_XXXXXX)
  - Skip: starts with dot (local label)
  - Skip: matches l_[0-9a-fA-F]+  (auto-generated address labels)

Usage:
  python3 tools/gen_call_graph.py > analysis/CALL_GRAPH.md
"""

import re
import sys
from collections import defaultdict
from pathlib import Path

# ---- Configuration --------------------------------------------------------

REPO_ROOT = Path(__file__).parent.parent
SECTION_FILES = [
    REPO_ROOT / "disasm/sections/section_000200.asm",
    REPO_ROOT / "disasm/sections/section_010000.asm",
    REPO_ROOT / "disasm/sections/section_020000.asm",
    REPO_ROOT / "disasm/sections/section_030000.asm",
]
FUNCTION_REFERENCE = REPO_ROOT / "analysis/FUNCTION_REFERENCE.md"

# ---- Regex patterns -------------------------------------------------------

# Global label: starts at column 0, letter/underscore start, ends with ':'
# Must NOT start with dot (local), NOT be l_XXXXXX (auto-generated)
RE_GLOBAL_LABEL = re.compile(r'^([A-Za-z][A-Za-z0-9_]*):\s*(?:;.*)?$')
RE_AUTO_LABEL   = re.compile(r'^l_[0-9A-Fa-f]+$')

# Call instructions -- extract callee name
# jsr FunctionName
RE_JSR_ABS = re.compile(r'^\s+jsr\s+([A-Za-z][A-Za-z0-9_]*)\s*(?:;.*)?$')
# jsr (FunctionName,PC)
RE_JSR_PC  = re.compile(r'^\s+jsr\s+\(([A-Za-z][A-Za-z0-9_]*)\s*,\s*PC\)\s*(?:;.*)?$')
# bsr.w FunctionName
RE_BSR_W   = re.compile(r'^\s+bsr\.w\s+([A-Za-z][A-Za-z0-9_]*)\s*(?:;.*)?$')
# bsr.s FunctionName
RE_BSR_S   = re.compile(r'^\s+bsr\.s\s+([A-Za-z][A-Za-z0-9_]*)\s*(?:;.*)?$')

CALL_PATTERNS = [RE_JSR_ABS, RE_JSR_PC, RE_BSR_W, RE_BSR_S]

# ---- Helpers ---------------------------------------------------------------

def is_function_label(name: str) -> bool:
    """Return True if name looks like a real function (not auto-generated)."""
    if RE_AUTO_LABEL.match(name):
        return False
    return True


def parse_function_names_from_reference(path: Path) -> list[str]:
    """Extract function names from FUNCTION_REFERENCE.md (| $addr | Name | ... rows)."""
    names = []
    re_row = re.compile(r'^\|\s*\$[0-9A-Fa-f]+\s*\|\s*(\S+)\s*\|')
    try:
        with open(path, encoding='utf-8') as f:
            for line in f:
                m = re_row.match(line)
                if m:
                    name = m.group(1)
                    if name and name != 'Name':
                        names.append(name)
    except FileNotFoundError:
        pass
    return names


# ---- Main pass: scan section files ----------------------------------------

def build_call_graph(section_files: list[Path]):
    """
    Returns:
        all_callees: set of all callee names encountered in calls
        all_function_labels: set of all global function labels found in source
        callers_of: dict {callee: {caller: count}}
        callees_of: dict {caller: {callee: count}}
    """
    all_function_labels: set[str] = set()
    callers_of: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    callees_of: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    all_callees: set[str] = set()

    for section_path in section_files:
        current_function = None
        with open(section_path, encoding='utf-8') as f:
            for line in f:
                line_stripped = line.rstrip()

                # Check for global label
                m = RE_GLOBAL_LABEL.match(line_stripped)
                if m:
                    label = m.group(1)
                    if is_function_label(label):
                        current_function = label
                        all_function_labels.add(label)
                    # auto-generated labels don't change current_function
                    continue

                # Skip local labels (start with dot)
                if line_stripped.lstrip().startswith('.'):
                    continue

                # Try each call pattern
                for pat in CALL_PATTERNS:
                    cm = pat.match(line_stripped)
                    if cm:
                        callee = cm.group(1)
                        all_callees.add(callee)
                        if current_function is not None:
                            callers_of[callee][current_function] += 1
                            callees_of[current_function][callee] += 1
                        else:
                            # Calls before any function label (top-level init code)
                            sentinel = '__top_level__'
                            callers_of[callee][sentinel] += 1
                            callees_of[sentinel][callee] += 1
                        break  # only match one pattern per line

    return all_callees, all_function_labels, callers_of, callees_of


# ---- Output formatting ----------------------------------------------------

def format_call_graph(
    all_callees: set[str],
    all_function_labels: set[str],
    callers_of: dict,
    callees_of: dict,
    reference_names: list[str],
) -> str:
    lines = []

    # Combine all known function names: labels seen in source + FUNCTION_REFERENCE names
    all_functions: set[str] = set(all_function_labels) | set(reference_names)

    # Compute total call counts per callee
    def total_calls(callee: str) -> int:
        return sum(callers_of[callee].values())

    def total_calls_made(caller: str) -> int:
        return sum(callees_of[caller].values())

    # Sorted callee list by total inbound calls (desc), then name
    all_callees_sorted = sorted(all_callees, key=lambda c: (-total_calls(c), c))

    # ---- Header -----------------------------------------------------------
    lines.append("# Call Graph -- Aerobiz Supersonic")
    lines.append("")
    lines.append("Auto-generated by `tools/gen_call_graph.py`.")
    lines.append("")
    lines.append("## Statistics")
    lines.append("")
    lines.append(f"- **Functions with labels in source:** {len(all_function_labels)}")
    lines.append(f"- **Unique callees (symbolic):** {len(all_callees)}")
    lines.append(f"- **Total call sites:** {sum(total_calls(c) for c in all_callees)}")
    lines.append(f"- **Leaf functions (no outgoing calls):** "
                 f"{sum(1 for f in all_function_labels if not callees_of[f])}")
    lines.append(f"- **Root functions (no incoming calls):** "
                 f"{sum(1 for f in all_function_labels if not callers_of[f])}")
    lines.append("")

    # ---- Top-20 most-called -----------------------------------------------
    lines.append("## Top 20 Most-Called Functions")
    lines.append("")
    lines.append("| Rank | Callee | Total Calls | Unique Callers |")
    lines.append("|------|--------|-------------|----------------|")
    top20 = all_callees_sorted[:20]
    for rank, callee in enumerate(top20, 1):
        tc = total_calls(callee)
        uc = len(callers_of[callee])
        lines.append(f"| {rank} | {callee} | {tc} | {uc} |")
    lines.append("")

    # ---- Leaf functions ---------------------------------------------------
    leaf_functions = sorted(
        f for f in all_function_labels if not callees_of[f]
    )
    lines.append("## Leaf Functions (call nothing)")
    lines.append("")
    lines.append(f"These {len(leaf_functions)} functions make no symbolic calls "
                 f"(may still use JMP, indirect calls, or inline code).")
    lines.append("")
    lines.append("| Function | Callers |")
    lines.append("|----------|---------|")
    for name in leaf_functions:
        tc = total_calls(name)
        lines.append(f"| {name} | {tc} |")
    lines.append("")

    # ---- Root functions (no callers) --------------------------------------
    root_functions = sorted(
        f for f in all_function_labels if not callers_of[f]
    )
    lines.append("## Root Functions (no symbolic callers)")
    lines.append("")
    lines.append(f"These {len(root_functions)} functions have no recorded symbolic callers. "
                 f"They may be called from jump tables, indirect JMP, interrupt vectors, or "
                 f"from dc.w blocks not yet translated.")
    lines.append("")
    lines.append("| Function | Calls Made |")
    lines.append("|----------|-----------|")
    for name in root_functions:
        cm = total_calls_made(name)
        lines.append(f"| {name} | {cm} |")
    lines.append("")

    # ---- Full cross-reference (callee -> callers) -------------------------
    lines.append("## Full Cross-Reference (callee -> callers)")
    lines.append("")
    lines.append("Every symbolic callee, sorted alphabetically. "
                 "For each callee: list of callers with per-caller call count.")
    lines.append("")

    for callee in sorted(all_callees):
        tc = total_calls(callee)
        caller_dict = callers_of[callee]
        # Sort callers: top-level first if present, then alphabetical
        sorted_callers = sorted(caller_dict.keys(), key=lambda c: (c == '__top_level__', c))
        # Mark if callee is a known function label
        in_source = " [unlabeled]" if callee not in all_function_labels else ""
        lines.append(f"### {callee}{in_source}")
        lines.append(f"- **Total calls:** {tc}")
        lines.append(f"- **Unique callers:** {len(caller_dict)}")
        lines.append("")
        lines.append("| Caller | Count |")
        lines.append("|--------|-------|")
        for caller in sorted_callers:
            count = caller_dict[caller]
            display_caller = "(top-level init)" if caller == '__top_level__' else caller
            lines.append(f"| {display_caller} | {count} |")
        lines.append("")

    return "\n".join(lines) + "\n"


# ---- Entry point ----------------------------------------------------------

def main():
    # Parse function names from reference doc for completeness check
    reference_names = parse_function_names_from_reference(FUNCTION_REFERENCE)

    # Build call graph
    all_callees, all_function_labels, callers_of, callees_of = build_call_graph(SECTION_FILES)

    # Format output
    output = format_call_graph(
        all_callees, all_function_labels, callers_of, callees_of, reference_names
    )

    print(output, end='')


if __name__ == '__main__':
    main()
