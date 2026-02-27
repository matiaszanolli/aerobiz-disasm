; ============================================================================
; GameLogic1 -- Initialize game logic: clear screen, load graphics, then call InitRouteFields, FinalizeRouteConfig, and SetupEventUI.
; 62 bytes | $0213B6-$0213F3
; ============================================================================
GameLogic1:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $1c(a7), a7
    jsr (InitRouteFields,PC)
    nop
    jsr (FinalizeRouteConfig,PC)
    nop
    jsr SetupEventUI
    rts
