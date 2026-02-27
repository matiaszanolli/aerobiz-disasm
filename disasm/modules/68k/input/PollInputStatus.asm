; ============================================================================
; PollInputStatus -- Alternating poll: odd calls wait for zero, even calls wait for data bit4 set
; 26 bytes | $001C6C-$001C85
; ============================================================================
PollInputStatus:
    bchg    #$0, d6
    bne.b   l_01c86
PollInputStatus_Main:                                        ; $001C72
    move.b  #$20, (a0)
l_01c76:
    move.b  (a0), d0
    btst    #$4, d0
    dbne    d7, $1C76
    beq.b   l_01c9a
    move.b  (a0), d0
    rts
