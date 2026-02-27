; ============================================================================
; RenderRouteUIElements -- Render the UI frame elements for a character's route panel: decompress base graphic, TilePlacement for stat bars, and aircraft type label.
; 410 bytes | $020DB8-$020F51
; ============================================================================
RenderRouteUIElements:
    movem.l d2/a2-a4, -(a7)
    move.l  $14(a7), d2
    movea.l  #$00000D64,a3
    movea.l  #$0001E044,a4
    move.l  ($000A1AEC).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0026).w
    pea     ($0101).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0017).w
    pea     ($0010).w
    pea     ($0032).w
    pea     ($0101).w
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0017).w
    pea     ($0068).w
    pea     ($0034).w
    pea     ($0109).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0017).w
    pea     ($00B0).w
    pea     ($0036).w
    pea     ($0111).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0007).w
    pea     ($00B0).w
    pea     ($0038).w
    pea     ($0119).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    cmpi.w  #$20, d2
    bge.w   l_20f4c
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.w   l_20f4c
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000D).w
    pea     ($0004).w
    jsr SetTextWindow
    pea     ($000D).w
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a2), d0
    mulu.w  #$3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041210).l
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    pea     ($0067).w
    pea     ($0008).w
    pea     ($0030).w
    pea     ($0121).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
l_20f4c:
    movem.l (a7)+, d2/a2-a4
    rts
