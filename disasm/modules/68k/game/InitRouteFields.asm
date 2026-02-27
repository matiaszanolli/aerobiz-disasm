; ============================================================================
; InitRouteFields -- Dispatch initialization of all three route field sub-records by calling InitRouteFieldA, InitRouteFieldB, and InitRouteFieldC in sequence.
; 20 bytes | $0213F4-$021407
; ============================================================================
InitRouteFields:
    jsr (InitRouteFieldA,PC)
    nop
    jsr (InitRouteFieldB,PC)
    nop
    jsr (InitRouteFieldC,PC)
    nop
    rts
