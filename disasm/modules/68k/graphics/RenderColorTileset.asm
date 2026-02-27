; ============================================================================
; RenderColorTileset -- Animates a palette-cycle effect over 8 steps: each step incrementally fades each color component toward the target palette and calls DisplaySetup; optionally delays between steps
; 360 bytes | $03B9D4-$03BB3B
; ============================================================================
RenderColorTileset:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    lea     -$6(a6), a5
    moveq   #$0,d0
    move.w  $16(a6), d0
    add.l   d0, d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    move.l  $8(a6), -(a7)
    jsr MemMove
    lea     $c(a7), a7
    clr.w   -$4(a6)
l_3ba04:
    moveq   #$7,d0
    sub.w   -$4(a6), d0
    move.w  d0, -$2(a6)
    clr.w   d5
    move.w  d5, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    lea     (a0,d0.w), a1
    movea.l a1, a2
    moveq   #$0,d0
    move.w  d5, d0
    add.l   d0, d0
    lea     (a4,d0.l), a0
    movea.l a0, a3
    bra.w   l_3baec
l_3ba2e:
    move.w  (a3), d0
    andi.l  #$e00, d0
    moveq   #$9,d1
    asr.l   d1, d0
    move.w  d0, (a5)
    move.w  (a3), d7
    andi.l  #$e0, d7
    asr.l   #$5, d7
    move.w  (a3), d6
    andi.l  #$e, d6
    asr.l   #$1, d6
    move.w  (a2), d4
    andi.l  #$e00, d4
    moveq   #$9,d0
    asr.l   d0, d4
    move.w  (a2), d3
    andi.l  #$e0, d3
    asr.l   #$5, d3
    move.w  (a2), d2
    andi.l  #$e, d2
    asr.l   #$1, d2
    cmp.w   (a5), d4
    bls.b   l_3ba78
    subq.w  #$1, d4
    bra.b   l_3ba92
l_3ba78:
    cmp.w   (a5), d4
    bcc.b   l_3ba92
    move.w  -$2(a6), d0
    cmp.w   (a5), d0
    bcc.b   l_3ba8c
    moveq   #$0,d0
    move.w  d4, d0
    addq.l  #$1, d0
    bra.b   l_3ba90
l_3ba8c:
    moveq   #$0,d0
    move.w  d4, d0
l_3ba90:
    move.w  d0, d4
l_3ba92:
    cmp.w   d7, d3
    bls.b   l_3ba9a
    subq.w  #$1, d3
    bra.b   l_3bab2
l_3ba9a:
    cmp.w   d7, d3
    bcc.b   l_3bab2
    cmp.w   -$2(a6), d7
    bls.b   l_3baac
    moveq   #$0,d0
    move.w  d3, d0
    addq.l  #$1, d0
    bra.b   l_3bab0
l_3baac:
    moveq   #$0,d0
    move.w  d3, d0
l_3bab0:
    move.w  d0, d3
l_3bab2:
    cmp.w   d6, d2
    bls.b   l_3baba
    subq.w  #$1, d2
    bra.b   l_3bad2
l_3baba:
    cmp.w   d6, d2
    bcc.b   l_3bad2
    cmp.w   -$2(a6), d6
    bls.b   l_3bacc
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    bra.b   l_3bad0
l_3bacc:
    moveq   #$0,d0
    move.w  d2, d0
l_3bad0:
    move.w  d0, d2
l_3bad2:
    move.w  d4, d0
    moveq   #$9,d1
    lsl.w   d1, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.w   d1, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    move.w  d0, (a2)
    addq.l  #$2, a3
    addq.l  #$2, a2
    addq.w  #$1, d5
l_3baec:
    cmp.w   $16(a6), d5
    bcs.w   l_3ba2e
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    jsr DisplaySetup
    lea     $c(a7), a7
    tst.w   $1a(a6)
    beq.b   l_3bb24
    move.w  $1a(a6), d0
    move.l  d0, -(a7)
    bsr.w DelayWithInputCheck
    addq.l  #$4, a7
l_3bb24:
    addq.w  #$1, -$4(a6)
    cmpi.w  #$8, -$4(a6)
    bcs.w   l_3ba04
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts
