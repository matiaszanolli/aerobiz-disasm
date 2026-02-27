; ============================================================================
; DisplayScenarioMenu -- Initialize resources and load the scenario menu graphics for full display via ResourceLoad, PreLoopInit, LoadScreenGfx, ResourceUnload.
; 38 bytes | $023836-$02385B
; ============================================================================
DisplayScenarioMenu:
    jsr ResourceLoad
    jsr PreLoopInit
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $c(a7), a7
    jsr ResourceUnload
    rts
