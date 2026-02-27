; ============================================================================
; GameEntry -- Main game entry point (called after boot initialization)
; ============================================================================
; Sets up game state, initializes subsystems, configures display, then enters
; the main loop. Called once from boot code via jmp.
; ============================================================================
GameEntry:                                                   ; $00D5B6
    jsr PreGameInit
    bsr.w InitGameGraphicsMode
    bsr.w InitGameAudioState
    pea     ($0001).w                                        ; Push argument 1
    jsr GameSetup1
    jsr GameSetup2
    bsr.w ClearDisplayBuffers
    pea     ($0010).w                                        ; Push display mode $10
    clr.l   -(sp)                                            ; Push zero (default param)
    pea     $0007651E                                        ; Push display config ptr
    jsr DisplaySetup
    lea     $10(sp),sp                                       ; Clean 16 bytes of stack args
    jsr RunScreenLoop
    jsr (GameLoopSetup,PC)
    nop
    clr.w   $00FF0006                                        ; Clear per-frame update flag
    rts
