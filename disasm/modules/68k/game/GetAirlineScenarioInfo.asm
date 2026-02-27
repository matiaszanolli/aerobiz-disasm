; ============================================================================
; GetAirlineScenarioInfo -- Displays info for a single airline scenario entry: looks up region and range, draws airline name in a text window, places the character sprite, and calls DrawCharInfoPanel to render the scenario info card; waits for button press
; 240 bytes | $02C7E0-$02C8CF
; ============================================================================
GetAirlineScenarioInfo:
    link    a6,#$0
    movem.l d2-d4, -(a7)
    move.l  $8(a6), d3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    move.w  d2, d0
    ext.l   d0
    moveq   #$7,d1
    jsr SignedMod
    add.w   d0, d0
    movea.l  #$00048468,a0
    move.w  (a0,d0.w), d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0008).w
    pea     ($0004).w
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042F6A).l
    jsr PrintfWide
    lea     $24(a7), a7
    pea     ($0001).w
    pea     ($0640).w
    pea     ($0039).w
    pea     ($0040).w
    pea     ($0008).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
    lea     $18(a7), a7
    move.l  $c(a6), -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0003).w
    pea     ($079E).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr DrawCharInfoPanel
    pea     ($0008).w
    pea     ($000E).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    movem.l -$c(a6), d2-d4
    unlk    a6
    rts
