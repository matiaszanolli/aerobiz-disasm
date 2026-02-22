# BACKLOG -- Task Queue

Pick the highest-priority unclaimed task. Mark it `IN PROGRESS` with your session date before starting. Mark `DONE` when complete with commit hash.

**Priority levels:** P0 = blocking other work, P1 = high impact, P2 = infrastructure, P3 = nice to have.

---

## P0 -- Blockers

### B-001: Initial ROM dump as dc.w
**Status:** OPEN
**Why:** Foundation for all subsequent work. Need the complete ROM as raw data words.
**Approach:** Use `m68k_disasm.py` or a hex dump tool to convert the ROM binary into `dc.w` statements. Split into logical sections based on the vector table and known Genesis ROM structure.
**Acceptance:** `make all` produces a ROM that is byte-identical to the original (`make verify` passes).
**Key files:** `disasm/aerobiz.asm`, `disasm/sections/`

### B-002: Identify and label vector table
**Status:** OPEN (depends on B-001)
**Why:** The vector table at $000000-$0000FF defines all entry points (reset, interrupts, exceptions). This is the roadmap for everything else.
**Approach:** Read the first 256 bytes. Label SP init, reset vector, bus error, address error, illegal instruction, divide by zero, CHK, TRAPV, privilege violation, trace, Line-A, Line-F, and all interrupt vectors (especially V-INT at vector $78 and H-INT at vector $70).
**Acceptance:** All 64 vectors labeled with meaningful names. Reset vector traced to entry point.
**Key files:** `disasm/sections/header.asm`

---

## P1 -- High Impact

### B-003: Map ROM sections (code vs data vs padding)
**Status:** OPEN (depends on B-002)
**Why:** Understanding ROM layout is prerequisite for targeted disassembly.
**Approach:** Scan for patterns -- NOP sleds (padding), ASCII strings (data), consistent opcode patterns (code). Use the vector table to identify code entry points. Map out sections with address ranges and purposes.
**Acceptance:** ROM map document in `analysis/ROM_MAP.md` with address ranges, types, and notes.

### B-004: Trace entry point and main loop
**Status:** OPEN (depends on B-002)
**Why:** Understanding the main execution flow tells us where everything else hangs from.
**Approach:** Follow reset vector -> initialization -> main loop. Document the V-INT handler. Identify the game state machine.
**Acceptance:** `analysis/SYSTEM_EXECUTION_FLOW.md` with boot sequence, main loop, and V-INT handler documented.

### B-005: Identify and document the sound driver
**Status:** OPEN (depends on B-003)
**Why:** Sound driver is usually self-contained Z80 code loaded during boot. Identifying it early prevents it from being confused with game data.
**Approach:** Look for Z80 bus request sequences, Z80 RAM writes during init. The Z80 program is typically a contiguous block loaded to $A00000.
**Acceptance:** Z80 sound driver binary identified and extracted. Load address and size documented.

---

## P2 -- Infrastructure

### B-006: Build function reference index
**Status:** OPEN (depends on B-004)
**Why:** As functions are identified, we need a searchable reference.
**Approach:** Create `analysis/FUNCTION_REFERENCE.md` and `analysis/FUNCTION_QUICK_LOOKUP.md` following the VRD project patterns. Auto-generate as functions are labeled.
**Acceptance:** Reference files exist and are populated with at least the boot/init functions.

### B-007: Set up Navigator index
**Status:** OPEN (depends on B-003)
**Why:** The Navigator agent needs its index populated to be useful.
**Approach:** Create `analysis/agent-scratch/navigator/index.md` with document registry, key facts, known pitfalls, and cross-references.
**Acceptance:** Navigator can answer basic queries about where documentation lives.

---

## P3 -- Nice to Have

### B-008: Identify text encoding and string tables
**Status:** OPEN (depends on B-003)
**Why:** Aerobiz has significant text content (airline names, city names, menus). Finding the text encoding early enables data table documentation.
**Approach:** Search for known ASCII strings in the ROM (e.g., "KOEI", game title from header). Trace how text is rendered to identify the encoding table.
**Acceptance:** Text encoding documented. At least one string table located and labeled.

---

## Done

| ID | Description | Commit | Date |
|----|-------------|--------|------|
| -- | Project scaffolding created | -- | 2026-02-22 |
