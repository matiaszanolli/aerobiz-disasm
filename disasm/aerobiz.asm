; ============================================================================
; Aerobiz Supersonic (Sega Genesis / Mega Drive)
; Full ROM Reassembly - Entry Point
; ============================================================================
;
; This is the top-level assembly file. It includes all sections in ROM order.
; Build with: make all
; Verify with: make verify
;
; ROM Layout (to be refined as disassembly progresses):
;   $000000-$0001FF   Header + Vector Table (512 bytes)
;   $000200-$??????   Game Code + Data (TBD)
;
; ============================================================================

; Hardware definitions
    include "modules/shared/definitions.asm"

; ============================================================================
; ROM Sections (included in address order)
; ============================================================================

; --- Header and Vector Table ---
    include "sections/header.asm"

; --- Code and Data Sections ---
; (Add sections here as the ROM is mapped and split)
;
; Example (uncomment and adapt as sections are created):
;   include "sections/code_0200.asm"
;   include "sections/data_XXXXX.asm"
;
; For now, the ROM content beyond the header will be added as raw dc.w
; data in section files, then progressively translated to mnemonics.
; ============================================================================
