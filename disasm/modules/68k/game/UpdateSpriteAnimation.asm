; ============================================================================
; UpdateSpriteAnimation -- Display a player's summary screen showing financial summary (revenue, expenses) and route statistics (routes, chars, aircraft), waiting for a button press.
; 454 bytes | $024A4A-$024C0F
; ============================================================================
UpdateSpriteAnimation:
    link    a6,#$0
    movem.l d2/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF09A2,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0290,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03F0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ResourceLoad
    jsr PreLoopInit
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007651E).l
    jsr DisplaySetup
    move.l  ($000A1B20).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($006E).w
    pea     ($0375).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $24(a7), a7
    pea     ($00071FC0).l
    pea     ($0017).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($0004).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($000C).w
    jsr SetTextWindow
    lea     $2c(a7), a7
    move.l  $e(a5), -(a7)
    move.l  $a(a5), -(a7)
    pea     ($0004139E).l
    jsr PrintfWide
    pea     ($0004).w
    pea     ($0010).w
    pea     ($0006).w
    pea     ($000C).w
    jsr SetTextWindow
    move.l  $4(a4), -(a7)
    move.l  (a4), -(a7)
    pea     ($00041392).l
    jsr PrintfWide
    lea     $28(a7), a7
    pea     ($0006).w
    pea     ($0010).w
    pea     ($000B).w
    pea     ($000C).w
    jsr SetTextWindow
    moveq   #$0,d0
    move.w  $4(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $2(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    pea     ($00041380).l
    jsr PrintfWide
    pea     ($0006).w
    pea     ($0010).w
    pea     ($0012).w
    pea     ($000C).w
    jsr SetTextWindow
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    pea     ($0004136C).l
    jsr PrintfWide
    lea     $10(a7), a7
    jsr ResourceUnload
.l24bee:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   .l24bee
    movem.l -$14(a6), d2/a2-a5
    unlk    a6
    rts
