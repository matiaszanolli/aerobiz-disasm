; ============================================================================
; FinalizeCandidateRoutes -- Finalize both trade candidate route fields by calling InitRouteFieldA2 and InitRouteFieldB2.
; 14 bytes | $021A1A-$021A27
; ============================================================================
FinalizeCandidateRoutes:
    jsr (InitRouteFieldA2,PC)
    nop
    jsr (InitRouteFieldB2,PC)
    nop
    rts
