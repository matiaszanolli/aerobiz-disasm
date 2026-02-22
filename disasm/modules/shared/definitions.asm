; ============================================================================
; Sega Genesis Hardware Register Definitions
; ============================================================================
; Canonical hardware register equates for the Sega Genesis / Mega Drive.
; Included globally from aerobiz.asm -- do NOT redefine these in section files.
;
; Reference: docs/genesis-software-development-manual.md
;            docs/genesis-technical-overview.md
; ============================================================================

; ============================================================================
; VDP (Video Display Processor) Ports
; ============================================================================
VDP_DATA            equ $C00000        ; VDP Data Port (read/write)
VDP_CTRL            equ $C00004        ; VDP Control Port (read/write)
VDP_HVCOUNTER       equ $C00008        ; H/V Counter (read only)
PSG                 equ $C00011        ; PSG (SN76489) sound port

; ============================================================================
; VDP Register Constants
; ============================================================================
; Write to VDP_CTRL as: move.w #$8RVV, VDP_CTRL
; where R = register number, VV = value
;
; VDP Register Summary:
;   $80xx  Reg 00: Mode Set 1 (H-INT enable, HV counter latch, etc.)
;   $81xx  Reg 01: Mode Set 2 (display enable, V-INT enable, DMA enable, V30)
;   $82xx  Reg 02: Plane A name table base (addr = value * $400)
;   $83xx  Reg 03: Window name table base (addr = value * $400)
;   $84xx  Reg 04: Plane B name table base (addr = value * $2000)
;   $85xx  Reg 05: Sprite table base (addr = value * $200)
;   $87xx  Reg 07: Background color (palette:color)
;   $88xx  Reg 08: Unused
;   $89xx  Reg 09: Unused
;   $8Axx  Reg 10: H-INT counter
;   $8Bxx  Reg 11: Mode Set 3 (ext INT, V-scroll mode, H-scroll mode)
;   $8Cxx  Reg 12: Mode Set 4 (H40/H32, interlace, shadow/highlight)
;   $8Dxx  Reg 13: H-scroll table base (addr = value * $400)
;   $8Fxx  Reg 15: Auto-increment (bytes added after each VDP access)
;   $90xx  Reg 16: Scroll size (V-scroll size : H-scroll size)
;   $91xx  Reg 17: Window H position
;   $92xx  Reg 18: Window V position
;   $93xx  Reg 19: DMA length low
;   $94xx  Reg 20: DMA length high
;   $95xx  Reg 21: DMA source low
;   $96xx  Reg 22: DMA source mid
;   $97xx  Reg 23: DMA source high + DMA type (bits 6-7)

; ============================================================================
; Z80 Control
; ============================================================================
Z80_BUSREQ          equ $A11100        ; Z80 bus request (write $0100 to request)
Z80_RESET           equ $A11200        ; Z80 reset (write $0100 to assert reset)
Z80_RAM             equ $A00000        ; Z80 RAM base (8KB: $A00000-$A01FFF)
Z80_RAM_END         equ $A02000        ; Z80 RAM end (exclusive)

; ============================================================================
; YM2612 FM Sound Chip
; ============================================================================
YM2612_A0           equ $A04000        ; Address port (Part I)
YM2612_D0           equ $A04001        ; Data port (Part I)
YM2612_A1           equ $A04002        ; Address port (Part II)
YM2612_D1           equ $A04003        ; Data port (Part II)

; ============================================================================
; I/O Ports (Controllers)
; ============================================================================
IO_VERSION          equ $A10001        ; Hardware version register
IO_DATA1            equ $A10003        ; Controller 1 data port
IO_DATA2            equ $A10005        ; Controller 2 data port
IO_DATA3            equ $A10007        ; Expansion port data
IO_CTRL1            equ $A10009        ; Controller 1 control port
IO_CTRL2            equ $A1000B        ; Controller 2 control port
IO_CTRL3            equ $A1000D        ; Expansion port control

; ============================================================================
; SRAM / ROM Banking
; ============================================================================
SRAM_CTRL           equ $A130F1        ; SRAM control / ROM bank register
; Bank registers (for ROMs > 4MB, if used):
; $A130F3, $A130F5, $A130F7, $A130F9, $A130FB, $A130FD, $A130FF

; ============================================================================
; 68K Work RAM
; ============================================================================
WORK_RAM            equ $FF0000        ; 68K Work RAM base (64KB)
WORK_RAM_END        equ $FFFFFF        ; 68K Work RAM end (inclusive)
STACK_TOP           equ $00000000      ; Placeholder -- set from vector table

; ============================================================================
; VDP Access Macros (documentation only -- vasm doesn't support macros natively)
; ============================================================================
; VRAM write:  move.l #$40000000 | (addr << 16) | (addr >> 14), VDP_CTRL
; CRAM write:  move.l #$C0000000 | (addr << 16) | (addr >> 14), VDP_CTRL
; VSRAM write: move.l #$40000010 | (addr << 16) | (addr >> 14), VDP_CTRL
; VRAM read:   move.l #$00000000 | (addr << 16) | (addr >> 14), VDP_CTRL
; DMA:         Set regs 19-23, then write VRAM/CRAM/VSRAM address with DMA bit
