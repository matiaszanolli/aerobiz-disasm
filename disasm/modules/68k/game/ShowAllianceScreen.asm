; ============================================================================
; ShowAllianceScreen -- Shows the alliance/relationship screen for a player: issues a GameCommand overlay, calls ShowText with a region label, loads resources, then calls LoadScreen and ShowRelPanel to render the relationship map and portrait panel
; 138 bytes | $02FB4C-$02FBD5
; ============================================================================
ShowAllianceScreen:
    link    a6,#-$4
    move.l  d2, -(a7)
    move.l  $8(a6), d2
    clr.l   -(a7)
    pea     ($000B).w
    pea     ($000B).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    clr.l   -(a7)
    move.l  ($00047B54).l, -(a7)
    pea     ($0004).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ShowText,PC)
    nop
    lea     $2c(a7), a7
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.l  -$8(a6), d2
    unlk    a6
    rts
