; ============================================================================
; ComputeRouteProfit -- Compute route profit eligibility by ANDing region mask against active bitfield and excluding blocked entities
; 60 bytes | $00F722-$00F75D
; ============================================================================
ComputeRouteProfit:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    move.w  $e(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    move.l  (a0,d0.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    move.l  (a0,d1.w), d1
    not.l   d1
    and.l   d1, d0
    move.l  d0, d2
    move.l  (a7)+, d2
    rts
