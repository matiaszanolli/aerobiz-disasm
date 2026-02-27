; ============================================================================
; DisplayUpdate -- On timer tick, copy or clear sprite entries then reinitialize display layout
; 108 bytes | $001660-$0016CB
; ============================================================================
DisplayUpdate:
    moveq   #$0,d0
    move.w  $b28(a5), d0
    subq.w  #$1, d0
    bne.b   l_016c6
    moveq   #$0,d0
    move.l  d0, d1
    move.l  d0, d2
    move.b  $b2b(a5), d0
    move.b  $b2c(a5), d2
    move.l  d0, d1
    lsl.l   #$3, d1
    lsl.l   #$1, d0
    subq.w  #$1, d2
    movea.l  #$00FFFB3E,a0
    movea.l  #$00FFF08A,a1
    move.b  $b2d(a5), d3
    beq.b   l_016a8
l_01692:
    move.w  (a0,d0.w), (a1,d1.w)
    addq.w  #$2, d0
    addq.w  #$8, d1
    dbra    d2, $1692
    move.b  #$0, $b2d(a5)
    bra.b   l_016ba
l_016a8:
    move.w  #$0, (a1,d1.w)
    addq.w  #$8, d1
    dbra    d2, $16A8
    move.b  #$1, $b2d(a5)
l_016ba:
    jsr (InitSpriteLinks,PC)
    bsr.w InitDisplayLayout
    move.w  $b26(a5), d0
l_016c6:
    move.w  d0, $b28(a5)
    rts
