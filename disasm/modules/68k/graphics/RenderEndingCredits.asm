; ============================================================================
; RenderEndingCredits -- Renders the game ending/credits screen: decompresses staff-roll graphics, animates horizontal scroll oscillation, and displays multiple credit text blocks before returning
; 678 bytes | $03C69C-$03C941
;
; No arguments. Called directly after game end condition is met.
;
; Registers set up in prologue:
;   a2 = -$C0(a6): local $C0 (192) byte frame buffer (receives MemMove'd credit blocks)
;   a3 = $45B2 (MemMove function pointer)
;   a4 = $D64  (GameCommand function pointer)
;   a5 = $3B994 (local animation step function pointer -- single VBlank wait + frame advance)
;
; Key resources:
;   $76FB6 = display setup palette/parameter table for credits screen background
;   $B754C = LZ-compressed staff-roll main graphic data pointer
;   $76F16/$76F36/$76FB6/$48D30/$76FD6 = LZ credit text block source addresses (5 blocks)
;   $7651E/$76FF6 = additional credit block source addresses (3 more blocks in second wave)
;   $760A6/$76246/$75F8E/$76066 = GameCommand #$1B text placement data addresses
;
; H-scroll oscillation:
;   d2 counts down from $10 to 1.
;   Even frames:  H-scroll = $200 - (d2/2)  (ramp down from $100 toward $1FF)
;   Odd frames:   H-scroll = d2/2             (ramp up from $8 toward 0)
;   Creates a symmetric left-right oscillation of the credits background.
; ============================================================================
RenderEndingCredits:
    link    a6,#-$C0
    movem.l d2-d3/a2-a5, -(a7)
    lea     -$c0(a6), a2                            ; a2 = local 192-byte credit block buffer
    movea.l  #$000045B2,a3                          ; a3 = MemMove function pointer ($45B2)
    movea.l  #$00000D64,a4                          ; a4 = GameCommand function pointer
    movea.l  #$0003B994,a5                          ; a5 = animation step function (VBlank + frame)
    ; --- Phase: Set up display for credits screen ---
    pea     ($0010).w                               ; DisplaySetup arg
    pea     ($0020).w                               ; DisplaySetup arg
    pea     ($00076FB6).l                           ; credits screen palette/resource table
    jsr DisplaySetup
    ; --- Phase: Decompress main staff-roll graphic and place tiles ---
    move.l  ($000B754C).l, -(a7)                   ; compressed graphic data pointer (from $B754C)
    pea     ($00FF1804).l                           ; decompress into save_buf_base ($FF1804)
    jsr LZ_Decompress
    pea     ($01A0).w                               ; tile width = $1A0 = 416 tiles
    pea     ($0400).w                               ; VRAM tile index $400
    pea     ($00FF1804).l                           ; decompressed source data
    jsr CmdPlaceTile                               ; write tiles to VRAM
    lea     $20(a7), a7
    ; --- Phase: Initialise H-scroll registers via GameCommand #$23 ---
    ; GameCommand #$23 sets up the H-scroll hardware registers.
    clr.l   -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0023).w                               ; GameCommand #$23 (H-scroll / tile-grid init)
    jsr     (a4)
    ; --- Phase: Load 5 credit text blocks into local buffer via MemMove ---
    ; MemMove args: (count, dest, src) -- copies 'count' bytes from src to dest
    pea     ($0020).w                               ; count = $20 = 32 bytes
    move.l  a2, -(a7)                               ; dest = local buffer base (a2+$00)
    pea     ($00076F16).l                           ; src = credit block 1 data
    jsr     (a3)                                    ; MemMove
    lea     $28(a7), a7
    pea     ($0020).w                               ; 32 bytes
    move.l  a2, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; dest = buffer+$20
    pea     ($00076F36).l                           ; src = credit block 2 data
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; dest = buffer+$40
    pea     ($00076FB6).l                           ; src = credit block 3 data
    jsr     (a3)
    pea     ($0040).w                               ; 64 bytes
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; dest = buffer+$60
    pea     ($00048D30).l                           ; src = credit block 4 data (64 bytes)
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    addi.l  #$a0, d0
    move.l  d0, -(a7)                               ; dest = buffer+$A0
    pea     ($00076FD6).l                           ; src = credit block 5 data
    jsr     (a3)
    lea     $30(a7), a7
    ; --- Phase: Render first color tileset from buffer ---
    pea     ($0003).w                               ; RenderColorTileset arg: color set 3
    pea     ($0030).w                               ; arg
    clr.l   -(a7)
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; src = buffer+$60 (64-byte block 4)
    move.l  a2, -(a7)                               ; base = local buffer
    bsr.w RenderColorTileset                        ; render palette tiles from credit block data
    ; --- Phase: Clear both scroll planes via GameCommand #$1A ---
    ; First clear: entire plane (priority $8000, 64x32)
    move.l  #$8000, -(a7)
    pea     ($0040).w                               ; height = $40
    pea     ($0020).w                               ; width = $20
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w                               ; GameCommand #$1A = ClearTileArea
    jsr     (a4)
    lea     $30(a7), a7
    ; Second clear: plane B (no priority)
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    ; --- Phase: Set scroll quadrant and initialise scroll registers ---
    pea     ($0001).w                               ; quadrant arg
    pea     ($0001).w
    jsr SetScrollQuadrant                           ; position the credits plane
    clr.l   -(a7)                                   ; H-scroll plane B = 0
    pea     ($0100).w                               ; H-scroll plane A = $100 (256 pixels offset)
    clr.l   -(a7)                                   ; V-scroll = 0
    bsr.w UpdateScrollRegisters                    ; write scroll values to VDP
    lea     $30(a7), a7
    ; --- Phase: Place first credit text block via GameCommand #$1B ---
    pea     ($000760A6).l                           ; text data for first credits panel
    pea     ($0008).w                               ; width = 8
    pea     ($001A).w                               ; height = $1A = 26
    pea     ($0003).w                               ; y = 3
    pea     ($0003).w                               ; x = 3
    pea     ($0001).w
    pea     ($001B).w                               ; GameCommand #$1B = DrawText
    jsr     (a4)
    pea     ($0001).w                               ; animation step count = 1
    jsr     (a5)                                    ; call animation step (wait 1 frame)
    lea     $20(a7), a7
    ; --- Place second credit text block ---
    pea     ($00076246).l
    pea     ($0006).w
    pea     ($001A).w
    pea     ($0009).w                               ; y = 9
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0001).w
    jsr     (a5)
    lea     $20(a7), a7
    ; --- Place third credit text block ---
    pea     ($00075F8E).l
    pea     ($0004).w
    pea     ($001B).w                               ; height = $1B
    pea     ($000F).w                               ; y = $F = 15
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    ; --- Phase: Load second wave of 3 credit blocks into buffer ---
    pea     ($0020).w
    move.l  a2, -(a7)                               ; dest = buffer+$00
    pea     ($0007651E).l                           ; src = credit block wave-2, entry 1
    jsr     (a3)                                    ; MemMove
    lea     $28(a7), a7
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; dest = buffer+$20
    pea     ($0007651E).l                           ; same source (duplicate copy -- NOTE: both use same src)
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; dest = buffer+$40
    pea     ($00076FF6).l                           ; src = credit block wave-2, entry 3
    jsr     (a3)
    ; --- Phase: Render second color tileset ---
    pea     ($0003).w
    pea     ($0030).w
    clr.l   -(a7)
    move.l  a2, -(a7)                               ; base = local buffer
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; src = buffer+$60 (reused slot for second palette)
    bsr.w RenderColorTileset
    ; --- Wait $20 frames for the new tileset to display ---
    pea     ($0020).w                               ; wait $20 frames
    jsr     (a5)
    lea     $30(a7), a7
    ; =========================================================================
    ; H-scroll oscillation animation: d2 counts down from $10 to 1
    ; =========================================================================
    moveq   #$10,d2                                 ; d2 = oscillation counter (16 steps)
l_3c8ba:
    ; Compute H-scroll value from d2: odd/even determines ramp direction
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod                                   ; d0 = d2 mod 2 (0=even, 1=odd)
    tst.l   d0
    beq.b   l_3c8d6                                 ; even -> compute $200 - d2/2 (ramp down)
    ; --- Odd step: H-scroll = d2/2 (ramp up from 0 toward $8) ---
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3c8d2
    addq.l  #$1, d0                                 ; bias for signed right-shift
l_3c8d2:
    asr.l   #$1, d0                                 ; d0 = d2 / 2 (positive offset)
    bra.b   l_3c8ea
l_3c8d6:
    ; --- Even step: H-scroll = $200 - d2/2 (ramp down from $100 toward $1F8) ---
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3c8de
    addq.l  #$1, d0
l_3c8de:
    asr.l   #$1, d0                                 ; d0 = d2 / 2
    move.l  #$200, d1
    sub.l   d0, d1                                  ; d1 = $200 - (d2/2)
    move.l  d1, d0                                  ; d0 = H-scroll value
l_3c8ea:
    ; --- Update scroll registers with computed H-scroll value ---
    move.w  d0, d3                                  ; d3 = H-scroll value for this frame
    clr.l   -(a7)                                   ; V-scroll plane B = 0
    move.w  d3, d0
    move.l  d0, -(a7)                               ; H-scroll plane A = d3
    clr.l   -(a7)                                   ; H-scroll plane B = 0
    bsr.w UpdateScrollRegisters                    ; write to VDP scroll registers
    pea     ($0001).w                               ; advance 1 frame
    jsr     (a5)
    lea     $10(a7), a7
    subq.w  #$1, d2                                 ; oscillation counter--
    tst.w   d2
    bne.b   l_3c8ba                                 ; not done -> next oscillation step
    ; --- Phase: Reset scroll to 0 and wait $80 frames for settle ---
    clr.l   -(a7)                                   ; all scroll regs = 0
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    pea     ($0080).w                               ; wait $80 = 128 frames
    jsr     (a5)
    ; --- Phase: Place final credits text panel via GameCommand #$1B ---
    pea     ($00076066).l                           ; final credits text data
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0014).w                               ; y = $14 = 20
    pea     ($0009).w                               ; x = 9
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)                                    ; GameCommand #$1B: display final credits
    movem.l -$d8(a6), d2-d3/a2-a5
    unlk    a6
    rts
