; ============================================================================
; ClearAircraftSlot -- Clears one byte in the aircraft roster array at $FF05C4, indexed by (player * 57 + slot), removing an aircraft from a fleet slot
; 24 bytes | $02C97C-$02C993
; ============================================================================
ClearAircraftSlot:
    move.w  $6(a7), d0
    mulu.w  #$39, d0
    add.w   $a(a7), d0
    movea.l  #$00FF05C4,a0
    clr.b   (a0,d0.w)
    rts
