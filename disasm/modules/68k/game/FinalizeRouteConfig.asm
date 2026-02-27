; ============================================================================
; FinalizeRouteConfig -- Orchestrate the full route configuration finalization pipeline: InitializeRoutePipeline, FinalizeCandidateRoutes, FinalizeRouteSelection.
; 20 bytes | $0214D6-$0214E9
; ============================================================================
FinalizeRouteConfig:
    jsr (InitializeRoutePipeline,PC)
    nop
    jsr (FinalizeCandidateRoutes,PC)
    nop
    jsr (FinalizeRouteSelection,PC)
    nop
    rts
