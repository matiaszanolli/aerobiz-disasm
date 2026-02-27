; ============================================================================
; InitScenarioDisplay -- Clears the scenario display area by issuing two GameCommands (clear screen and reset display mode); used to initialize the scenario menu background
; 42 bytes | $02C2D0-$02C2F9
; ============================================================================
InitScenarioDisplay:
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    lea     $28(a7), a7
    rts
