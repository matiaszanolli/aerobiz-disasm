; ============================================================================
; InputStateMachine -- Drive multi-step read sequence collecting 4 data bytes from extended device
; 124 bytes | $001B70-$001BEB
; ============================================================================
InputStateMachine:
l_01b70:
    move.b  #$20, (a0)
    move.b  #$60, $6(a0)
    move.w  #$ff, d7
    btst    #$4, (a0)
    beq.w   l_01be6
    bsr.w WaitInputZero
    bcs.w   l_01be6
    andi.b  #$f, d0
    bsr.w PollInputStatus_Main
    bcs.w   l_01be6
    andi.b  #$f, d0
    bsr.w WaitInputZero
    bcs.w   l_01be6
    move.b  d0, (a2)+
    bsr.w PollInputStatus_Main
    bcs.w   l_01be6
    move.b  d0, (a2)+
    bsr.w WaitInputZero
    bcs.w   l_01be6
    move.b  d0, (a2)+
    moveq   #$0,d6
    bsr.w PollInputStatus
    bcs.w   l_01be6
    move.b  d0, (a2)+
    andi.l  #$f0f0f0f, -(a2)
    bsr.b   $1BEC
    bcs.w   l_01be6
    bsr.b   $1BEC
    bcs.w   l_01be6
    bsr.b   $1BEC
    bcs.w   l_01be6
    bsr.b   $1BEC
    bcs.w   l_01be6
l_01be6:
    move.b  #$60, (a0)
    rts
