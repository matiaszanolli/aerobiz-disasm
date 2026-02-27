; ============================================================================
; CmdClearSprites -- Zero out N sprite entries in work RAM sprite buffer and refresh display layout
; 52 bytes | $0007A4-$0007D7
; ============================================================================
CmdClearSprites:
    move.l  $e(a6), d0
    move.l  $12(a6), d1
    moveq   #$0,d2
    lsl.l   #$3, d0
    movea.l  #$00FFF08A,a4
    bra.b   l_007be
l_007b8:
    move.w  d2, (a4,d0.w)
    addq.w  #$8, d0
l_007be:
    dbra    d1, $7B8
    jsr (InitSpriteLinks,PC)
    nop
    move.w  sr, -(a7)
    ori.w   #$700, sr
    jsr (InitDisplayLayout,PC)
    nop
    move.w  (a7)+, sr
    rts
