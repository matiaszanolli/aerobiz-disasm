; ============================================================================
; ComputeDisplayAttrsLower -- Compute max RGB nibble attributes for 8 tile rows (reverse), write to display
; 210 bytes | $004E28-$004EF9
; ============================================================================
ComputeDisplayAttrsLower:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d7
    movea.l $8(a6), a3
    lea     -$6(a6), a4
    lea     -$4(a6), a5
    moveq   #$7,d6
l_04e42:
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
    bra.b   l_04e9c
l_04e5e:
    move.w  (a2), d5
    andi.w  #$e00, d5
    move.w  (a2), d4
    andi.w  #$e0, d4
    move.w  (a2), d3
    andi.w  #$e, d3
    cmp.w   -$2(a6), d5
    bcc.b   l_04e7a
    move.w  -$2(a6), d5
l_04e7a:
    cmp.w   (a5), d4
    bcc.b   l_04e80
    move.w  (a5), d4
l_04e80:
    cmp.w   (a4), d3
    bcc.b   l_04e86
    move.w  (a4), d3
l_04e86:
    move.w  d5, d0
    add.w   d4, d0
    add.w   d3, d0
    move.w  d2, d1
    add.w   d1, d1
    lea     -$86(a6), a0
    move.w  d0, (a0,d1.w)
    addq.w  #$1, d2
    addq.l  #$2, a2
l_04e9c:
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$0,d1
    move.w  $12(a6), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_04e5e
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
    beq.b   l_04ee8
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_04ee8:
    subq.w  #$1, d6
    tst.w   d6
    bge.w   l_04e42
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts
