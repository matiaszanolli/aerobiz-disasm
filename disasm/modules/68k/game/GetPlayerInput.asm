; ============================================================================
; GetPlayerInput -- Checks whether a given player's airline has any active route slots: scans up to 4 entries in the player's route table at $FFBA80 (checking byte at offset +1) and returns 1 in D0 if any slot is active, 0 otherwise.
; 50 bytes | $01EC0E-$01EC3F
; ============================================================================
GetPlayerInput:
    move.l  d2, -(a7)
    clr.w   d1
    move.w  $a(a7), d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_1ec26:
    tst.b   $1(a1)
    beq.b   l_1ec30
    moveq   #$1,d1
    bra.b   l_1ec3a
l_1ec30:
    addq.l  #$2, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ec26
l_1ec3a:
    move.w  d1, d0
    move.l  (a7)+, d2
    rts
