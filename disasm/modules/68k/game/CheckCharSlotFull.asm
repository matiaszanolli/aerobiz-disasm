; ============================================================================
; CheckCharSlotFull -- Checks if a player's character roster has a free slot: scans 5 route record entries for one with salary < 10; if all are full retrieves the blocking character and shows two info dialogs; returns 1 if a slot is free, 0 if full
; 150 bytes | $02D376-$02D40B
; ============================================================================
CheckCharSlotFull:
    movem.l d2-d3/a2, -(a7)
    move.l  $10(a7), d2
    move.l  $14(a7), d3
    move.w  d2, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l2d396:
    cmpi.b  #$a, $1(a2)
    bcs.b   .l2d3a8
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   .l2d396
.l2d3a8:
    cmpi.w  #$5, d2
    bne.b   .l2d402
    clr.w   d2
    move.w  d3, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d3
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004849E).l, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484AE).l, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $28(a7), a7
    bra.b   .l2d404
.l2d402:
    moveq   #$1,d2
.l2d404:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2
    rts
