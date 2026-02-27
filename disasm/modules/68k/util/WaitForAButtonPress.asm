; ============================================================================
; WaitForAButtonPress -- Initialises the display loop, shows the game status bar, issues a wait tile command, then polls until A-button (bit 4) is pressed.
; 54 bytes | $0260F2-$026127
; ============================================================================
WaitForAButtonPress:
    jsr PreLoopInit
    jsr ShowGameStatus
    pea     ($0014).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
.l2610e:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   .l2610e
    rts
