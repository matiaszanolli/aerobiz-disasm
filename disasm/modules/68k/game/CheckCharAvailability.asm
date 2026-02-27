; ============================================================================
; CheckCharAvailability -- Check whether a character is available for a turn based on morale stat and route slot morale, returning 1 if a scaled random roll passes.
; 154 bytes | $021CF0-$021D89
; ============================================================================
CheckCharAvailability:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d2
    move.l  $18(a7), d4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  $1(a2), d3
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d4, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.l  a2, -(a7)
    jsr GetByteField4
    mulu.w  #$c, d0
    movea.l  #$00FFA6C1,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$64,d2
    sub.w   d0, d2
    pea     ($00C8).w
    pea     ($0032).w
    move.w  d3, d0
    add.w   d2, d0
    addi.w  #$fffb, d0
    move.l  d0, -(a7)
    jsr MulDiv
    move.w  d0, d2
    pea     ($0032).w
    clr.l   -(a7)
    jsr RandRange
    lea     $18(a7), a7
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_21d82
    moveq   #$1,d0
    bra.b   l_21d84
l_21d82:
    moveq   #$0,d0
l_21d84:
    movem.l (a7)+, d2-d4/a2
    rts
