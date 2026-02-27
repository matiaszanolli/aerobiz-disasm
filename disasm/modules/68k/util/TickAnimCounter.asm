; ============================================================================
; TickAnimCounter -- Increment the animation frame counter at $FFBDE2 by one
; 10 bytes | $006252-$00625B
; ============================================================================
TickAnimCounter:
    movea.l  #$00FFBDE2,a0
    addq.w  #$1, (a0)
    rts
