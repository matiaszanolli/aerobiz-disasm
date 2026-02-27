; ============================================================================
; CheckCharRelation -- Test if char code D2 is present in player relation bitfield at $FFA6A0 or $FFBD6C
; 124 bytes | $0079A8-$007A23
; ============================================================================
CheckCharRelation:
    movem.l d2-d6, -(a7)
    move.l  $20(a7), d2
    move.l  $1c(a7), d4
    move.l  $18(a7), d5
    clr.w   d3
    cmpi.w  #$20, d2
    bge.b   l_079da
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    bra.b   l_07a18
l_079da:
    cmpi.w  #$ff, d4
    bne.b   l_079f0
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
l_079f0:
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    mulu.w  #$e, d1
    move.w  d4, d6
    add.w   d6, d6
    add.w   d6, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
l_07a18:
    beq.b   l_07a1c
    moveq   #$1,d3
l_07a1c:
    move.w  d3, d0
    movem.l (a7)+, d2-d6
    rts
