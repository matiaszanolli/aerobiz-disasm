; ============================================================================
; FindRouteSlotByCharState -- Searches the player's route-slot array for a slot whose char code and state byte match the given values, returning the slot index or -1 if not found.
; 58 bytes | $028436-$02846F
; ============================================================================
FindRouteSlotByCharState:
    move.l  d2, -(a7)
    move.l  $c(a7), d1
    move.w  $a(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_28450:
    cmpi.b  #$1, $1(a1)
    bne.b   l_28460
    cmp.b   (a1), d1
    bne.b   l_28460
    move.w  d2, d0
    bra.b   l_2846c
l_28460:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_28450
    moveq   #-$1,d0
l_2846c:
    move.l  (a7)+, d2
    rts
