; ============================================================================
; MainLoop -- Main game loop (runs every frame, iterates forever)
; ============================================================================
MainLoop:                                                    ; $00D608
    jsr GameUpdate1
    jsr GameUpdate2
    clr.w   $00FF17C4                                        ; Clear per-frame work flag
    jsr GameLogic1
    jsr GameLogic2
    pea     ($0001).w                                        ; Push argument 1
    jsr InitAllCharRecords
    addq.l  #4,sp                                            ; Clean up pea argument
    jsr GameUpdate3
    jsr GameUpdate4
    addq.w  #1,$00FF0006                                     ; Increment frame counter
    bra.s   MainLoop                                         ; Loop forever
; ---
    rts                                                      ; $00D646 (dead code after MainLoop bra.s)
