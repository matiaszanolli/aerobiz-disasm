; ============================================================================
; RunEventSequence -- Top-level dispatcher that calls DecrementEventTimers, CheckEventConditionS2, ExecuteEventAction, ApplyEventEffectS2, and HandleEventConsequence in sequence to process all game events for the current turn.
; Called: ?? times.
; 38 bytes | $028B46-$028B6B
; ============================================================================
RunEventSequence:                                                  ; $028B46
    dc.w    $4eb9,$0003,$a9ac                           ; jsr $03A9AC
    dc.w    $4eba,$001e                                 ; jsr $028B6C
    nop
    dc.w    $4eba,$049c                                 ; jsr $028FF0
    nop
    dc.w    $4eba,$0608                                 ; jsr $029162
    nop
    dc.w    $4eba,$07ec                                 ; jsr $02934C
    nop
    dc.w    $4eba,$089c                                 ; jsr $029402
    nop
    rts
    dc.w    $4E56,$FF6C                                      ; $028B6C
; === Translated block $028B70-$028EBE ===
; 2 functions, 846 bytes
