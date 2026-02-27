; ============================================================================
; ComputeDisplayAttrsUpper -- Compute max RGB nibble attributes for 8 tile rows (forward), write to display
; 212 bytes | $004D54-$004E27
; ============================================================================
ComputeDisplayAttrsUpper:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d7
    movea.l $8(a6), a3
    lea     -$6(a6), a4
    lea     -$4(a6), a5
    clr.w   d6
l_04d6e:
    move.w  d6, d0
    moveq   #$9,d1
    lsl.w   d1, d0
    move.w  d0, -$2(a6)
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d0, (a5)
    move.w  d6, d0
    add.w   d0, d0
    move.w  d0, (a4)
    move.w  d7, d2
    movea.l a3, a2
    bra.b   l_04dc8
l_04d8a:
    move.w  (a2), d5
    andi.w  #$e00, d5
    move.w  (a2), d4
    andi.w  #$e0, d4
    move.w  (a2), d3
    andi.w  #$e, d3
    cmp.w   -$2(a6), d5
    bcc.b   l_04da6
    move.w  -$2(a6), d5
l_04da6:
    cmp.w   (a5), d4
    bcc.b   l_04dac
    move.w  (a5), d4
l_04dac:
    cmp.w   (a4), d3
    bcc.b   l_04db2
    move.w  (a4), d3
l_04db2:
    move.w  d5, d0
    add.w   d4, d0
    add.w   d3, d0
    move.w  d2, d1
    add.w   d1, d1
    lea     -$86(a6), a0
    move.w  d0, (a0,d1.w)
    addq.w  #$1, d2
    addq.l  #$2, a2
l_04dc8:
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$0,d1
    move.w  $12(a6), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_04d8a
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    pea     (a0, d0.w)
    bsr.w WriteCharUIDisplay
    lea     $c(a7), a7
    tst.w   $16(a6)
    beq.b   l_04e14
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_04e14:
    addq.w  #$1, d6
    cmpi.w  #$8, d6
    blt.w   l_04d6e
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts
