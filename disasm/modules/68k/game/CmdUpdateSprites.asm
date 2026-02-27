; ============================================================================
; CmdUpdateSprites -- Copy sprite data from ROM table into work RAM sprite buffer, applying position offsets
; 90 bytes | $00074A-$0007A3
; ============================================================================
CmdUpdateSprites:
    move.l  $e(a6), d0
    move.l  $12(a6), d1
    movea.l $16(a6), a0
    move.l  $1a(a6), d2
    move.l  $1e(a6), d3
    andi.l  #$ffff, d2
    swap    d3
    andi.l  #$ffff0000, d3
    movea.l  #$00FFF08A,a1
    lsl.l   #$3, d0
    bra.b   l_0078a
l_00776:
    move.l  (a0)+, d4
    add.l   d3, d4
    move.l  d4, (a1,d0.w)
    addq.w  #$4, d0
    move.l  (a0)+, d4
    add.w   d2, d4
    move.l  d4, (a1,d0.w)
    addq.w  #$4, d0
l_0078a:
    dbra    d1, $776
    jsr (InitSpriteLinks,PC)
    nop
    move.w  sr, -(a7)
    ori.w   #$700, sr
    jsr (InitDisplayLayout,PC)
    nop
    move.w  (a7)+, sr
    rts
