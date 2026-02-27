; ============================================================================
; ClearRoutePendingFlags -- Clears the pending flag (bit 7 of offset $A) on all 40 relation slots for a given player, resetting their dirty state.
; 42 bytes | $012E04-$012E2D
; ============================================================================
ClearRoutePendingFlags:
    move.w  $6(a7), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d1
.l12e1a:
    andi.b  #$7f, $a(a1)
    moveq   #$14,d0
    adda.l  d0, a1
    addq.w  #$1, d1
    cmpi.w  #$28, d1
    blt.b   .l12e1a
    rts
