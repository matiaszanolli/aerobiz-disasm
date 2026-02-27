; ============================================================================
; CountCharPairSlots -- Counts occupied $FFBA80 pair slots for a player; returns slot count
; 48 bytes | $0360C2-$0360F1
; ============================================================================
CountCharPairSlots:
    move.l  d2, -(a7)
    clr.w   d1
    move.w  $a(a7), d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_360da:
    tst.b   $1(a1)
    beq.b   l_360e2
    addq.w  #$1, d1
l_360e2:
    addq.l  #$2, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_360da
    move.w  d1, d0
    move.l  (a7)+, d2
    rts
