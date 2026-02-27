; ============================================================================
; ShowGameOverScreen -- Clears screen, loads game-over graphics, resets scroll registers, and clears the display; called when all players are bankrupt
; 62 bytes | $03C17A-$03C1B7
; ============================================================================
ShowGameOverScreen:
    clr.l   -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0023).w
    jsr GameCommand
    jsr ResourceLoad
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    bsr.w UpdateScrollRegisters
    lea     $28(a7), a7
    jsr ClearScreen
    rts
