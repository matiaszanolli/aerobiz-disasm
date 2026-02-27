; ============================================================================
; InitializeRoutePipeline -- Run the full route option selection pipeline: SelectActiveRoute, ProcessRouteOptionB, MatchRouteOption, ProcessRouteOptionC, ProcessRouteOptionD.
; 32 bytes | $0214EA-$021509
; ============================================================================
InitializeRoutePipeline:
    jsr (SelectActiveRoute,PC)
    nop
    jsr (ProcessRouteOptionB,PC)
    nop
    jsr (MatchRouteOption,PC)
    nop
    jsr (ProcessRouteOptionC,PC)
    nop
    jsr (ProcessRouteOptionD,PC)
    nop
    rts
