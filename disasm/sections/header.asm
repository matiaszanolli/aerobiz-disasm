; ============================================================================
; Sega Genesis ROM Header + Vector Table
; ============================================================================
; $000000-$0001FF (512 bytes)
;
; The vector table occupies $000000-$0000FF (256 bytes, 64 longwords).
; The ROM header occupies $000100-$0001FF (256 bytes).
;
; Reference: docs/genesis-software-development-manual.md
; ============================================================================

; ============================================================================
; 68000 Vector Table ($000000-$0000FF)
; ============================================================================
; Fill in from your ROM dump. The first two entries are critical:
;   Vector 0 ($000000): Initial Stack Pointer (typically $00FFFFFF or $00FF0000)
;   Vector 1 ($000004): Reset PC (entry point - where execution begins)
;
; Template (replace with actual ROM values):
;
;   org $000000
;
; vec_00_sp_init:
;   dc.l $00FFFFFF          ; Initial SP — top of Work RAM
; vec_01_reset:
;   dc.l entry_point        ; Reset vector — program entry point
; vec_02_bus_error:
;   dc.l exception_bus_error
; vec_03_addr_error:
;   dc.l exception_addr_error
; vec_04_illegal_instr:
;   dc.l exception_illegal
; vec_05_div_zero:
;   dc.l exception_divzero
; vec_06_chk:
;   dc.l exception_chk
; vec_07_trapv:
;   dc.l exception_trapv
; vec_08_privilege:
;   dc.l exception_privilege
; vec_09_trace:
;   dc.l exception_trace
; vec_10_linea:
;   dc.l exception_linea
; vec_11_linef:
;   dc.l exception_linef
;
;   ; Vectors 12-23: Reserved
;   dc.l 0,0,0,0,0,0,0,0,0,0,0,0
;
;   ; Vector 24: Spurious interrupt
;   dc.l int_spurious
;
;   ; Vectors 25-31: Auto-vectored interrupts (levels 1-7)
;   dc.l int_level1         ; Level 1 (external)
;   dc.l int_level2         ; Level 2 (external)
;   dc.l int_level3         ; Level 3 (external)
;   dc.l int_hblank         ; Level 4 = H-INT (horizontal blank)
;   dc.l int_level5         ; Level 5 (external)
;   dc.l int_vblank         ; Level 6 = V-INT (vertical blank)
;   dc.l int_level7         ; Level 7 (NMI — active high on 32X, unused on bare Genesis)
;
;   ; Vectors 32-47: TRAP #0 through TRAP #15
;   dc.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;
;   ; Vectors 48-63: Reserved
;   dc.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;
; ============================================================================
; Sega Genesis ROM Header ($000100-$0001FF)
; ============================================================================
; Fill in from your ROM dump.
;
; Template:
;
;   org $000100
;
; rom_header:
;   dc.b "SEGA MEGA DRIVE "                  ; $100-$10F: Console name (16 bytes)
;   dc.b "(C)KOEI 1994.XXX"                  ; $110-$11F: Copyright (16 bytes)
;   dc.b "AEROBIZ SUPERSONIC              "  ; $120-$14F: Domestic name (48 bytes)
;   dc.b "AEROBIZ SUPERSONIC              "  ; $150-$17F: Overseas name (48 bytes)
;   dc.b "GM XXXXXXXX-XX"                    ; $180-$18D: Product code (14 bytes)
;   dc.w $0000                               ; $18E-$18F: Checksum
;   dc.b "J               "                  ; $190-$19F: I/O support (16 bytes)
;   dc.l $00000000                           ; $1A0-$1A3: ROM start address
;   dc.l $001FFFFF                           ; $1A4-$1A7: ROM end address (2MB example)
;   dc.l $00FF0000                           ; $1A8-$1AB: RAM start address
;   dc.l $00FFFFFF                           ; $1AC-$1AF: RAM end address
;   dc.b "            "                      ; $1B0-$1BB: SRAM info (12 bytes)
;   dc.b "            "                      ; $1BC-$1C7: Padding (12 bytes)
;   dc.b "                                "  ; $1C8-$1EF: Modem info / memo (40 bytes)
;   dc.b "JUE             "                  ; $1F0-$1FF: Region (16 bytes)
;
; ============================================================================
