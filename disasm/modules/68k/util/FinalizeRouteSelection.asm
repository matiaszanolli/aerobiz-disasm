; ============================================================================
; FinalizeRouteSelection -- Finalize route field C2 and run the turn checkpoint by calling InitRouteFieldC2 and ProcessTurnCheckpoint.
; 14 bytes | $021B02-$021B0F
; ============================================================================
FinalizeRouteSelection:
    jsr (InitRouteFieldC2,PC)
    nop
    jsr (ProcessTurnCheckpoint,PC)
    nop
    rts
