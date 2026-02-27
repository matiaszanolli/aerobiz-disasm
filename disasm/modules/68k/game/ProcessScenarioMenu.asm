; ============================================================================
; ProcessScenarioMenu -- Load and display a scenario screen background: ResourceLoad, clear two display areas via GameCommand $1A, LoadScreen, ResourceUnload.
; 102 bytes | $0237D0-$023835
; ============================================================================
ProcessScenarioMenu:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    jsr ResourceLoad
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr LoadScreen
    lea     $28(a7), a7
    jsr ResourceUnload
    move.l  (a7)+, d2
    rts
