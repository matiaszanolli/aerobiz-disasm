; ============================================================================
; WaitInputReady -- Wait for port device ready signal then initiate input data parse
; 50 bytes | $001AA2-$001AD3
; ============================================================================
WaitInputReady:
l_01aa2:
    move.b  #$20, (a0)
    move.b  #$60, $6(a0)
    btst    #$4, (a0)
    beq.w   l_01ace
    move.w  #$ff, d7
    bsr.w WaitInputZero
    bcs.w   l_01ace
    moveq   #$0,d6
    bsr.w PollInputStatus
    bcs.w   l_01ace
    bsr.w ParseInputData
l_01ace:
    move.b  #$60, (a0)
    rts
