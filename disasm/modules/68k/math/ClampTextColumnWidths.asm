; ============================================================================
; ClampTextColumnWidths -- Clamps two width values to the range 0–32 and stores them in win_right_dup ($FF1290) and win_right ($FF1000); used to set text column counters
; 54 bytes | $03AAB0-$03AAE5
; ============================================================================
ClampTextColumnWidths:
    move.l  d2, -(a7)
    move.l  $c(a7), d2
    move.l  $8(a7), d1
    cmpi.w  #$20, d1
    bls.b   l_3aac4
    moveq   #$20,d0
    bra.b   l_3aac8
l_3aac4:
    moveq   #$0,d0
    move.w  d1, d0
l_3aac8:
    move.w  d0, ($00FF1290).l
    cmpi.w  #$20, d2
    bls.b   l_3aad8
    moveq   #$20,d0
    bra.b   l_3aadc
l_3aad8:
    moveq   #$0,d0
    move.w  d2, d0
l_3aadc:
    move.w  d0, ($00FF1000).l
    move.l  (a7)+, d2
    rts
