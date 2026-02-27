; ============================================================================
; GameLogic2 -- Calls InitQuarterEvent, MakeAIDecision, AnalyzeRouteProfit, UpdateSlotEvents, and OptimizeCosts in sequence to perform the AI game-logic phase for the current quarter.
; 32 bytes | $02947A-$029499
; ============================================================================
GameLogic2:
    jsr (InitQuarterEvent,PC)
    nop
    jsr (MakeAIDecision,PC)
    nop
    jsr (AnalyzeRouteProfit,PC)
    nop
    jsr UpdateSlotEvents
    jsr (OptimizeCosts,PC)
    nop
    rts
