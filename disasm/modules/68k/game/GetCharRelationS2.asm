; ============================================================================
; GetCharRelationS2 -- Execute a relationship-based char trade by finding a compatible player, checking willingness scaled by relation distance, and calling ExecuteTradeOffer.
; 328 bytes | $023490-$0235D7
; ============================================================================
GetCharRelationS2:
    link    a6,#-$88
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d5
    movea.l  #$0001D6A4,a3
    clr.w   d3
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$8(a6, d0.w), a0
    movea.l a0, a2
    bra.b   l_234d0
l_234b6:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
    move.w  d0, (a2)
    add.w   (a2)+, d3
    addq.w  #$1, d2
l_234d0:
    cmpi.w  #$4, d2
    blt.b   l_234b6
    tst.w   d3
    bgt.b   l_234e0
l_234da:
    moveq   #$0,d0
    bra.w   l_235ce
l_234e0:
    clr.w   d2
l_234e2:
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    move.w  d0, d3
    add.w   d0, d0
    tst.w   -$8(a6, d0.w)
    bgt.b   l_234fe
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    blt.b   l_234e2
l_234fe:
    cmpi.w  #$14, d2
    bge.b   l_234da
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FinalizeTrade,PC)
    nop
    addq.l  #$8, a7
    movea.l d0, a2
    move.l  a2, d0
    beq.b   l_234da
    pea     ($0063).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    subi.l  #$28, d1
    moveq   #$A,d6
    cmp.l   d1, d6
    bge.b   l_23544
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    subi.l  #$28, d1
    bra.b   l_23546
l_23544:
    moveq   #$A,d1
l_23546:
    cmp.l   d1, d0
    bge.b   l_234da
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.l   d0
    beq.b   l_234da
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.w   l_234da
    move.b  $a(a2), d0
    andi.l  #$2, d0
    moveq   #$2,d1
    cmp.l   d0, d1
    beq.w   l_234da
    pea     ($0001).w
    move.l  a2, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ExecuteTradeOffer,PC)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_235cc
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($0004821C).l
    pea     -$88(a6)
    jsr sprintf
    pea     -$88(a6)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
l_235cc:
    moveq   #$1,d0
l_235ce:
    movem.l -$a4(a6), d2-d6/a2-a3
    unlk    a6
    rts
