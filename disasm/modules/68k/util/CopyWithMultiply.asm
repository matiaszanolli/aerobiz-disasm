; ============================================================================
; CopyWithMultiply -- Copy a row range between two tile buffers using row*width offset arithmetic
; 206 bytes | $0051B6-$005283
; ============================================================================
CopyWithMultiply:
    link    a6,#$0
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    move.l  $18(a6), d4
    move.l  $24(a6), d5
    move.l  $20(a6), d6
    move.l  $1c(a6), d7
    movea.l  #$00FFA77E,a4
    tst.w   d3
    bne.b   l_051ea
    moveq   #$0,d0
    move.w  ($00FF88D6).l, d0
    bra.b   l_051f2
l_051ea:
    moveq   #$0,d0
    move.w  ($00FFA6B4).l, d0
l_051f2:
    movea.l d0, a3
    moveq   #$0,d0
    move.w  $12(a6), d0
    moveq   #$0,d1
    move.w  (a4), d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    add.l   d1, d0
    add.l   d0, d0
    adda.l  d0, a3
    tst.w   d7
    bne.b   l_0521c
    moveq   #$0,d0
    move.w  ($00FF88D6).l, d0
    bra.b   l_05224
l_0521c:
    moveq   #$0,d0
    move.w  ($00FFA6B4).l, d0
l_05224:
    movea.l d0, a2
    moveq   #$0,d0
    move.w  d5, d0
    moveq   #$0,d1
    move.w  (a4), d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d6, d1
    add.l   d1, d0
    add.l   d0, d0
    adda.l  d0, a2
    move.w  $16(a6), d3
    add.w   d3, d3
    clr.w   d2
    bra.b   l_05276
l_05248:
    move.l  a2, -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0006).w
    jsr GameCommand
    lea     $14(a7), a7
    moveq   #$0,d0
    move.w  (a4), d0
    add.l   d0, d0
    adda.l  d0, a3
    moveq   #$0,d0
    move.w  (a4), d0
    add.l   d0, d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_05276:
    cmp.w   d4, d2
    bcs.b   l_05248
    movem.l -$24(a6), d2-d7/a2-a4
    unlk    a6
    rts
