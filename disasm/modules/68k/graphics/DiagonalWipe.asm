; ============================================================================
; DiagonalWipe -- Performs a tiled diagonal wipe transition by expanding a strip of tiles outward from a start position using random step sizes until the full screen span is covered
; Called: ?? times.
; 510 bytes | $01ACBA-$01AEB7
; ============================================================================
; --- Phase: Setup ---
; Args (right-to-left push order on caller's stack):
;   $24(sp) = d5: X pixel origin (tile column base, before scale)
;   $28(sp) = d4: Y pixel origin (tile row base, before scale)
;   $2C(sp) = d7: mode (0 = close/reveal; 1 = open/hide)
; d2 = forward offset counter, d3 = backward offset counter
; d6 = tile graphic index ($0750 = wipe strip tile)
; a2 = GameCommand, a3 = TilePlacement
DiagonalWipe:                                                  ; $01ACBA
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $0028(sp),d4
    move.l  $0024(sp),d5
    move.l  $002c(sp),d7
; a2 = GameCommand ($0D64) -- central VDP/display dispatcher
    movea.l #$0d64,a2
; a3 = TilePlacement ($01E044) -- builds tile params and issues GameCmd #15
    movea.l #$0001e044,a3
; d6 = tile index $0750: the wipe strip tile used throughout
    move.w  #$0750,d6
    clr.w   d2
    clr.w   d3
; d7==1 = "open" (hide/wipe-out) mode; d7==0 = "close" (reveal) mode
    cmpi.w  #$1,d7
    bne.w   .l1adb8
; --- Phase: Mode 1 (open/hide) -- coordinate scaling ---
; Scale X: d5 = d5*8 + $3C ($3C=60: right-edge margin offset for open-mode origin)
    lsl.w   #$3,d5
    addi.w  #$3c,d5
; Scale Y: d4 = d4*8 + $A (top-edge alignment; $A=10 pixel fine offset)
    lsl.w   #$3,d4
    addi.w  #$a,d4
; LoadDisplaySet: load graphics mode 4 (display state for mode-1 wipe)
    pea     ($0004).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    addq.l  #$4,sp
; Jump into loop check first (d2 starts at 0, must reach $14 before placing any tile)
    bra.b   .l1ad46
; --- Mode 1, Phase A: expand one strip rightward from origin ---
; Place a 2x2 tile at Y=d4 (fixed), X=d5+d2 (advancing each frame)
; No priority flag (0 = behind sprites) -- open/hide mode overlays existing screen
.l1ad00:                                                ; $01AD00
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
; Y = d4 (fixed row -- the wipe sweeps horizontally at this row)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
; X = d5 + d2 (rightward advance: d2 grows each iteration)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
; Tile $0750 = wipe strip tile graphic
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
; GameCommand #$0E: flush VDP output after placing tile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
; Step = SignedDiv(d2, $14) + 2; $14=20 gives small quotient, +2 ensures min 2-pixel advance
; Varying step produces randomized sweep speed for organic wipe feel
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$2,d0
    add.w   d0,d2
; Loop until d2 >= $14 (20 pixels = Phase A coverage complete)
.l1ad46:                                                ; $01AD46
    cmpi.w  #$14,d2
    blt.b   .l1ad00
    bra.b   .l1adae
; --- Mode 1, Phase B: expand both strips symmetrically from Phase-A endpoint ---
; d2 advances right (forward), d3 advances left (backward from origin)
; Together they fill the diagonal band outward in both directions
.l1ad4e:                                                ; $01AD4E
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
; Y = d4 - d3 (upper/backward strip moves up from the origin row)
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
; X = d5 + d2 (lower/forward strip continues rightward)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
; Advance d2 (forward strip): step = d2/$14 + 1
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
; Advance d3 (backward strip): step = d2/$14 + 1 (same computation, applied to d3)
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d3
; Extra +1 per iteration ensures wipe completes within bounded frame count
    addq.w  #$1,d2
    addq.w  #$1,d3
; Loop until d3 >= $22 (34 pixels = full half-screen diagonal band covered)
.l1adae:                                                ; $01ADAE
    cmpi.w  #$22,d3
    blt.b   .l1ad4e
    bra.w   .l1ae9a
; --- Phase: Mode 0 (close/reveal) -- coordinate scaling ---
; Both axes scaled by 8 (same pixel-to-tile conversion as mode-1)
.l1adb8:                                                ; $01ADB8
    move.w  d5,d0
    lsl.w   #$3,d0
    move.w  d0,d5
    move.w  d4,d0
    lsl.w   #$3,d0
    move.w  d0,d4
; LoadDisplaySet: load graphics mode 5 (display state for mode-0/reveal wipe)
    pea     ($0005).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    addq.l  #$4,sp
    bra.b   .l1ae3c
; --- Mode 0, Phase A: bilateral expansion from origin ---
; Priority flag $0800: tiles appear above background but below high-priority sprites
; d3 expands rightward (+Y), d2 expands leftward (-X) simultaneously
.l1add2:                                                ; $01ADD2
; $0800 = tile priority bit (below $8000 priority used in mode-1)
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
; Y = d4 + d3 (rightward/downward expansion from origin row)
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
; X = d5 - d2 (leftward expansion from origin column -- reveals from center outward)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
; Advance d2 using: step = ($36 - d2) / $14 + 1
; $36=54 = total reveal width; as d2 grows the step shrinks = ease-out deceleration
    move.w  d2,d0
    ext.l   d0
    moveq   #$36,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
; Advance d3 using same formula (symmetric easing for the rightward direction)
    move.w  d2,d0
    ext.l   d0
    moveq   #$36,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d3
; Loop until d3 >= $22 (34 pixels -- same band width as mode-1)
.l1ae3c:                                                ; $01AE3C
    cmpi.w  #$22,d3
    blt.b   .l1add2
    bra.b   .l1ae94
; --- Mode 0, Phase B: complete leftward coverage ---
; d3 is now frozen at $22 (right side fully covered by Phase A)
; d2 continues advancing leftward until it reaches $36 (full screen width covered)
.l1ae44:                                                ; $01AE44
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
; Y = d4 + d3 (right strip holds at its Phase-A endpoint)
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
; X = d5 - d2 (left strip continues expanding toward screen edge)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
; Advance d2 by (step + 1) + 1 = step + 2; double increment for faster Phase B completion
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
    addq.w  #$1,d2
; Loop until d2 >= $36 (54 pixels = full horizontal screen coverage complete)
.l1ae94:                                                ; $01AE94
    cmpi.w  #$36,d2
    blt.b   .l1ae44
; --- Phase: Finalize ---
.l1ae9a:                                                ; $01AE9A
; GameCommand #$18: trigger display commit / DMA flush after wipe completes
    pea     ($0018).w
    jsr     (a2)
; GameCmd16 #$0F mode 1: clear wipe overlay sprite layer
    pea     ($0001).w
    pea     ($000F).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    lea     $000c(sp),sp
    movem.l (sp)+,d2-d7/a2-a3
    rts
ShowPlayerCompare:                                                  ; $01AEB8
    link    a6,#$0
    movem.l d2-d7/a2,-(sp)
    move.l  $001c(a6),d5
    move.l  $0010(a6),d6
    move.l  $0008(a6),d7
    movea.l #$0d64,a2
    cmp.w   d6,d7
    bne.b   .l1aee2
    move.w  #$0770,d4
    move.w  #$0771,d3
    bra.w   .l1af88
.l1aee2:                                                ; $01AEE2
    move.w  #$0772,d4
    move.w  #$0773,d3
    bra.w   .l1af88
.l1aeee:                                                ; $01AEEE
    cmpi.w  #$1,d2
    bne.b   .l1af6c
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0039).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $0016(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($003A).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    clr.w   d2
    bra.b   .l1af8a
.l1af6c:                                                ; $01AF6C
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0010(sp),sp
.l1af88:                                                ; $01AF88
    moveq   #$1,d2
.l1af8a:                                                ; $01AF8A
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    addq.l  #$4,sp
    move.w  d0,d5
    ext.l   d0
    moveq   #$0,d1
    move.w  $001a(a6),d1
    and.l   d1,d0
    beq.w   .l1aeee
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    move.w  d5,d0
    movem.l -$001c(a6),d2-d7/a2
    unlk    a6
    rts
; ---------------------------------------------------------------------------
GetModeRowOffset:                                                  ; $01AFCA
    move.l  $0008(sp),d1
    tst.w   d1
    bne.b   .l1afd6
    moveq   #$2a,d1
    bra.b   .l1afec
.l1afd6:                                                ; $01AFD6
    cmpi.w  #$1,d1
    bne.b   .l1afe0
    moveq   #$26,d1
    bra.b   .l1afec
.l1afe0:                                                ; $01AFE0
    cmpi.w  #$2,d1
    bne.b   .l1afea
    moveq   #$22,d1
    bra.b   .l1afec
.l1afea:                                                ; $01AFEA
    moveq   #$19,d1
.l1afec:                                                ; $01AFEC
    move.w  d1,d0
    rts
