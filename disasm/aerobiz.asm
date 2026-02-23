; ===========================================================================
; Aerobiz Supersonic (USA) -- Main Assembly Entry Point
; Sega Genesis / Mega Drive
;
; ROM: 1MB ($000000-$0FFFFF)
; Build: make all -> build/aerobiz.bin
; Verify: make verify (md5sum check against original ROM)
; ===========================================================================

; --- Hardware Definitions ---
    include "modules/shared/definitions.asm"

; ===========================================================================
; ROM Layout
; ===========================================================================
; $000000-$0000FF  Vector table (256 bytes)
; $000100-$0001FF  ROM header (256 bytes)
; $000200-$0FFFFF  Code and data (1,048,064 bytes)
; ===========================================================================

; --- Vector Table + ROM Header ($000000-$0001FF) ---
    include "sections/header.asm"

; --- Code and Data Sections ---
    include "sections/section_000200.asm"          ; $000200-$00FFFF
    include "sections/section_010000.asm"          ; $010000-$01FFFF
    include "sections/section_020000.asm"          ; $020000-$02FFFF
    include "sections/section_030000.asm"          ; $030000-$03FFFF
    include "sections/section_040000.asm"          ; $040000-$04FFFF
    include "sections/section_050000.asm"          ; $050000-$05FFFF
    include "sections/section_060000.asm"          ; $060000-$06FFFF
    include "sections/section_070000.asm"          ; $070000-$07FFFF
    include "sections/section_080000.asm"          ; $080000-$08FFFF
    include "sections/section_090000.asm"          ; $090000-$09FFFF
    include "sections/section_0A0000.asm"          ; $0A0000-$0AFFFF
    include "sections/section_0B0000.asm"          ; $0B0000-$0BFFFF
    include "sections/section_0C0000.asm"          ; $0C0000-$0CFFFF
    include "sections/section_0D0000.asm"          ; $0D0000-$0DFFFF
    include "sections/section_0E0000.asm"          ; $0E0000-$0EFFFF
    include "sections/section_0F0000.asm"          ; $0F0000-$0FFFFF

; --- End of ROM ---

