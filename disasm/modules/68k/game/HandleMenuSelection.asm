; ============================================================================
; HandleMenuSelection -- Highlights a selected city on the route map: places a tile at the city's computed pixel coordinates, draws a stat box via GameCommand, and refreshes via GameCmd16.
; 124 bytes | $01B9A0-$01BA1B
; ============================================================================
HandleMenuSelection:
    link    a6,#$0
    pea     ($0006).w
    pea     ($06A0).w
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$6, d0
    add.l   ($000A1B58).l, d0
    move.l  d0, -(a7)
    jsr CmdPlaceTile
    move.w  $12(a6), d0
    ext.l   d0
    lsl.l   #$3, d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    lsl.l   #$3, d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($00047CE4).l
    pea     ($0001).w
    pea     ($0039).w
    pea     ($000F).w
    jsr GameCommand
    pea     ($000A).w
    pea     ($000E).w
    jsr GameCommand
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0039).w
    jsr GameCmd16
    unlk    a6
    rts
