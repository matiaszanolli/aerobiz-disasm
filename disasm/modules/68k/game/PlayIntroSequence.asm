; ============================================================================
; PlayIntroSequence -- Loads resources, configures scroll bars and clears the screen to set up the intro animation environment before RunIntroLoop
; 52 bytes | $03BD1E-$03BD51
; ============================================================================
PlayIntroSequence:
    jsr ResourceLoad
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollBarMode
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    bsr.w UpdateScrollRegisters
    lea     $20(a7), a7
    jsr ClearScreen
    rts
