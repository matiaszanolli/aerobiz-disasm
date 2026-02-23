# BACKLOG -- Task Queue

Pick the highest-priority unclaimed task. Mark it `IN PROGRESS` with your session date before starting. Mark `DONE` when complete with commit hash.

**Priority levels:** P0 = blocking other work, P1 = high impact, P2 = infrastructure, P3 = nice to have.

---

## P0 -- Blockers

### B-001: Initial ROM dump as dc.w
**Status:** DONE (2026-02-23)
**Why:** Foundation for all subsequent work. Need the complete ROM as raw data words.
**Approach:** Python script generated all assembly source from ROM binary. Split into header.asm (vectors + ROM header) and 16 x 64KB section files (dc.w data with 8 words per line, address comments).
**Acceptance:** `make verify` passes -- byte-identical (MD5: `1269f44e846a88a2de945de082428b39`).
**Key files:** `disasm/aerobiz.asm`, `disasm/sections/header.asm`, `disasm/sections/section_*.asm`

### B-002: Identify and label vector table
**Status:** DONE (2026-02-23)
**Why:** The vector table at $000000-$0000FF defines all entry points (reset, interrupts, exceptions). This is the roadmap for everything else.
**Approach:** All 64 vectors extracted from ROM and labeled with descriptive comments in header.asm. Key targets: Entry point at $000200, exception handlers clustered at $000F84-$000FD2, H-INT at $001484, V-INT at $000014E6, EXT INT at $001480. Labels placed at vector target addresses in data sections (EntryPoint, BusError, etc.).
**Acceptance:** All 64 vectors labeled. Reset vector -> $000200 (EntryPoint). ROM map updated.
**Key files:** `disasm/sections/header.asm`, `analysis/ROM_MAP.md`

---

## P1 -- High Impact

### B-003: Map ROM sections (code vs data vs padding)
**Status:** DONE (2026-02-23)
**Why:** Understanding ROM layout is prerequisite for targeted disassembly.
**Approach:** Heuristic scan counting 68K instruction markers (RTS, RTE, JSR, BSR, Bcc) per 4KB block. Combined with padding detection (runs of $00/$FF) and ASCII string detection. Identified 5 major code regions, 3 padding regions, mixed/data zones.
**Acceptance:** `analysis/ROM_MAP.md` populated with major regions, code density heatmap, statistics (854 RTS, 3873 JSR, ~30% padding).

### B-004: Trace entry point and main loop
**Status:** DONE (2026-02-23)
**Why:** Understanding the main execution flow tells us where everything else hangs from.
**Approach:** Disassembled from reset vector ($200) through TMSS boot -> game init -> main game entry ($D5B6) -> main loop ($D608). Traced V-INT ($14E6), H-INT ($1484), EXT INT ($1480), and exception handlers ($F84-$FE0). Identified Z80 sound driver at $2696-$3BE7 (5458 bytes).
**Acceptance:** `analysis/SYSTEM_EXECUTION_FLOW.md` fully documented: boot sequence, main game loop, V-INT/H-INT/exception handlers, Z80 sound driver location.

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
| B-003 | ROM sections mapped (code/data/padding heatmap, 854 functions) | -- | 2026-02-23 |
| B-004 | Entry point traced, main loop + all interrupt handlers documented | -- | 2026-02-23 |
| B-001 | Initial ROM dump as dc.w (byte-identical, 16 section files) | f46553e | 2026-02-23 |
| B-002 | Vector table identified and labeled (all 64 vectors) | f46553e | 2026-02-23 |
| -- | Project scaffolding created | 412e6cf | 2026-02-22 |
