; ===========================================================================
; Aerobiz Supersonic (USA) -- Vector Table and ROM Header
; $000000-$0001FF (512 bytes)
;
; Auto-generated from ROM dump. Labels will be added as code is translated.
; ===========================================================================

; ===========================================================================
; Exception Vector Table ($000000-$0000FF)
; 64 longword entries = 256 bytes
; Reference: Motorola 68000 Programmer's Reference, Section 6
; ===========================================================================

; --- Reset Vectors ---
    dc.l    $00FFF000           ; $0000: Initial Stack Pointer
    dc.l    $00000200           ; $0004: Reset vector -- program entry point -> $000200

; --- Exception Handlers ---
    dc.l    $00000F84           ; $0008: Bus Error -> $000F84
    dc.l    $00000F8A           ; $000C: Address Error -> $000F8A
    dc.l    $00000F90           ; $0010: Illegal Instruction -> $000F90
    dc.l    $00000F96           ; $0014: Zero Divide -> $000F96
    dc.l    $00000F9C           ; $0018: CHK Instruction -> $000F9C
    dc.l    $00000FA2           ; $001C: TRAPV Instruction -> $000FA2
    dc.l    $00000FA8           ; $0020: Privilege Violation -> $000FA8
    dc.l    $00000FAE           ; $0024: Trace -> $000FAE
    dc.l    $00000FB4           ; $0028: Line-A Emulator (1010) -> $000FB4
    dc.l    $00000FBA           ; $002C: Line-F Emulator (1111) -> $000FBA

; --- Reserved (vectors 12-15) ---
    dc.l    $00000FC0           ; $0030: Reserved -> $000FC0
    dc.l    $00000FC6           ; $0034: Reserved -> $000FC6
    dc.l    $00000FCC           ; $0038: Reserved -> $000FCC
    dc.l    $00000FD2           ; $003C: Uninitialized Interrupt Vector -> $000FD2

; --- Reserved (vectors 16-23) ---
    dc.l    $00000000           ; $0040: Reserved
    dc.l    $00000000           ; $0044: Reserved
    dc.l    $00000000           ; $0048: Reserved
    dc.l    $00000000           ; $004C: Reserved
    dc.l    $00000000           ; $0050: Reserved
    dc.l    $00000000           ; $0054: Reserved
    dc.l    $00000000           ; $0058: Reserved
    dc.l    $00000000           ; $005C: Reserved

; --- Spurious Interrupt ---
    dc.l    $00000000           ; $0060: Spurious Interrupt

; --- Auto-vectored Interrupts (Levels 1-7) ---
    dc.l    $00000000           ; $0064: Level 1 Interrupt (unused on Genesis)
    dc.l    $00001480           ; $0068: Level 2 Interrupt -- EXT (active on Genesis) -> $001480
    dc.l    $00000000           ; $006C: Level 3 Interrupt (unused on Genesis)
    dc.l    $00001484           ; $0070: Level 4 Interrupt -- H-Blank (Horizontal) -> $001484
    dc.l    $00000000           ; $0074: Level 5 Interrupt (unused on Genesis)
    dc.l    $000014E6           ; $0078: Level 6 Interrupt -- V-Blank (Vertical) -> $0014E6
    dc.l    $00000000           ; $007C: Level 7 Interrupt -- NMI (active on Genesis, active-low on cartridge pin B32)

; --- TRAP Instruction Vectors ---
    dc.l    $00000000           ; $0080: TRAP #0
    dc.l    $00000000           ; $0084: TRAP #1
    dc.l    $00000000           ; $0088: TRAP #2
    dc.l    $00000000           ; $008C: TRAP #3
    dc.l    $00000000           ; $0090: TRAP #4
    dc.l    $00000000           ; $0094: TRAP #5
    dc.l    $00000000           ; $0098: TRAP #6
    dc.l    $00000000           ; $009C: TRAP #7
    dc.l    $00000000           ; $00A0: TRAP #8
    dc.l    $00000000           ; $00A4: TRAP #9
    dc.l    $00000000           ; $00A8: TRAP #10
    dc.l    $00000000           ; $00AC: TRAP #11
    dc.l    $00000000           ; $00B0: TRAP #12
    dc.l    $00000000           ; $00B4: TRAP #13
    dc.l    $00000000           ; $00B8: TRAP #14
    dc.l    $00000000           ; $00BC: TRAP #15

; --- Reserved (vectors 48-63) ---
    dc.l    $00000000           ; $00C0: Reserved
    dc.l    $00000000           ; $00C4: Reserved
    dc.l    $00000000           ; $00C8: Reserved
    dc.l    $00000000           ; $00CC: Reserved
    dc.l    $00000000           ; $00D0: Reserved
    dc.l    $00000000           ; $00D4: Reserved
    dc.l    $00000000           ; $00D8: Reserved
    dc.l    $00000000           ; $00DC: Reserved
    dc.l    $00000000           ; $00E0: Reserved
    dc.l    $00000000           ; $00E4: Reserved
    dc.l    $00000000           ; $00E8: Reserved
    dc.l    $00000000           ; $00EC: Reserved
    dc.l    $00000000           ; $00F0: Reserved
    dc.l    $00000000           ; $00F4: Reserved
    dc.l    $00000000           ; $00F8: Reserved
    dc.l    $00000000           ; $00FC: Reserved

; ===========================================================================
; ROM Header ($000100-$0001FF)
; 256 bytes -- Sega Genesis/Mega Drive ROM header format
; ===========================================================================

; Console name ($100-$10F)
    dc.b    "SEGA GENESIS    "

; Copyright / Date ($110-$11F)
    dc.b    "(C)T-76 1994.DEC"

; Domestic name ($120-$14F) -- Japanese (Shift-JIS)
    dc.b    $83,$47,$83,$41,$83,$7D,$83,$6C,$83,$57,$83,$81,$83,$93,$83,$67
    dc.b    $82,$51,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    dc.b    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

; Overseas name ($150-$17F)
    dc.b    "AEROBIZ         "
    dc.b    " SUPERSONIC     "
    dc.b    "                "

; Serial number / Product code ($180-$18D)
    dc.b    "GM T-76136 -00"

; Checksum ($18E-$18F)
    dc.w    $4620

; I/O support ($190-$19F)
    dc.b    "J               "

; ROM address range ($1A0-$1A7)
    dc.l    $00000000           ; ROM start
    dc.l    $000FFFFF           ; ROM end

; RAM address range ($1A8-$1AF)
    dc.l    $00FF0000           ; RAM start
    dc.l    $00FFFFFF           ; RAM end

; SRAM / Backup RAM info ($1B0-$1BB)
    dc.b    "RA"             ; "RA" = SRAM present
    dc.w    $F820               ; SRAM type (battery-backed, odd byte addressed)
    dc.l    $00200001           ; SRAM start
    dc.l    $00203FFF           ; SRAM end

; Modem support ($1BC-$1C7)
    dc.b    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

; Notes / Memo ($1C8-$1EF)
    dc.b    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    dc.b    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    dc.b    $20,$20,$20,$20,$20,$20,$20,$20

; Region codes ($1F0-$1FF)
    dc.b    $55,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20  ; "U"

