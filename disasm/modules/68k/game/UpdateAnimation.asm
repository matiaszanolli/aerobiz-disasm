; ============================================================================
; UpdateAnimation -- Renders the animation bar chart for a city slot: computes the peak traffic value across all active player/city combinations, then scales each player's bar height by dividing total traffic by a year-difficulty factor and renders each bar as a tile column via TilePlacement and GameCommand, printing the numeric value and a row icon alongside.
; 534 bytes | $01F13C-$01F351
; ============================================================================
UpdateAnimation:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d6
    movea.l  #$00FF0002,a4
    cmpi.w  #$1, ($00FF000A).l
    bne.w   l_1f34c
    clr.w   d5
    cmpi.w  #$7, d6
    bcc.b   l_1f1a6
    clr.w   d3
l_1f160:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$20, d2
    bcc.b   l_1f19c
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    cmp.w   d5, d4
    bls.b   l_1f19c
    move.w  d4, d5
l_1f19c:
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_1f160
    bra.b   l_1f1f4
l_1f1a6:
    movea.l  #$00FF0018,a3
    clr.w   d3
l_1f1ae:
    clr.w   d4
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_1f1d4
l_1f1c6:
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d4
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_1f1d4:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    blt.b   l_1f1c6
    cmp.w   d5, d4
    bls.b   l_1f1e8
    move.w  d4, d5
l_1f1e8:
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_1f1ae
l_1f1f4:
    tst.w   (a4)
    bne.b   l_1f200
    move.l  #$c0, d2
    bra.b   l_1f222
l_1f200:
    cmpi.w  #$1, (a4)
    bne.b   l_1f20e
    move.l  #$190, d2
    bra.b   l_1f222
l_1f20e:
    cmpi.w  #$2, (a4)
    bne.b   l_1f21c
    move.l  #$1a0, d2
    bra.b   l_1f222
l_1f21c:
    move.l  #$320, d2
l_1f222:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d2, d1
    jsr Multiply32
    move.l  d0, d4
    moveq   #$1,d0
    cmp.l   d4, d0
    bcc.b   l_1f242
    move.l  d4, d0
    bra.b   l_1f244
l_1f242:
    moveq   #$1,d0
l_1f244:
    move.l  d0, d4
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d3
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d6, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF01B0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d5
    move.w  d3, d5
    move.l  d5, d0
    lsl.l   #$2, d5
    add.l   d0, d5
    addq.l  #$5, d5
    moveq   #$0,d7
    move.w  d3, d7
    move.l  d7, d0
    lsl.l   #$2, d7
    add.l   d0, d7
    lsl.l   #$3, d7
    addi.l  #$18, d7
l_1f292:
    move.l  (a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    lsl.l   #$3, d0
    move.l  d4, d1
    jsr UnsignedDivide
    move.w  d0, d2
    cmpi.w  #$a0, d2
    bcc.b   l_1f2b4
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_1f2ba
l_1f2b4:
    move.l  #$a0, d0
l_1f2ba:
    addi.w  #$40, d0
    move.w  d0, d2
    move.w  d7, d6
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0750).w
    jsr TilePlacement
    pea     ($0002).w
    pea     ($000E).w
    jsr GameCommand
    move.l  d5, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.l  (a2), -(a7)
    pea     ($000411F2).l
    jsr PrintfNarrow
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($001D).w
    pea     ($0001).w
    pea     ($0001).w
    jsr PlaceIconTiles
    lea     $18(a7), a7
    moveq   #$28,d0
    add.l   d0, d7
    addq.l  #$5, d5
    moveq   #$20,d0
    adda.l  d0, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_1f292
l_1f34c:
    movem.l (a7)+, d2-d7/a2-a4
    rts
