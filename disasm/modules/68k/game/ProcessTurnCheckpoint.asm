; ============================================================================
; ProcessTurnCheckpoint -- Select a random player for a trade turn via RandRange(3) and validate timing/availability via AggregateCharAvailability and ValidateTurnDelay.
; 58 bytes | $021DE2-$021E1B
; ============================================================================
ProcessTurnCheckpoint:
    move.l  d2, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    move.l  d0, -(a7)
    jsr (AggregateCharAvailability,PC)
    nop
    addq.l  #$4, a7
    move.l  d0, -(a7)
    jsr (ValidateTurnDelay,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_21e10
    moveq   #$0,d0
    bra.b   l_21e18
l_21e10:
    move.w  d2, ($00FF09D6).l
    moveq   #$1,d0
l_21e18:
    move.l  (a7)+, d2
    rts
