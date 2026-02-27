; ============================================================================
; ParseInputExtended -- Decode extended device packet: mark type 2, sign-extend XY movement deltas
; 78 bytes | $001B22-$001B6F
; ============================================================================
ParseInputExtended:
l_01b22:
    move.w  #$2, (a1)+
    move.w  d2, d3
    swap    d2
    move.b  d2, d0
    bsr.w XorAndUpdate
    move.w  d3, (a1)+
    andi.w  #$ff, d3
    moveq   #$0,d0
    move.b  -$2(a1), d0
    btst    #$0, -$4(a1)
    beq.b   l_01b48
    subi.w  #$100, d0
l_01b48:
    btst    #$2, -$4(a1)
    beq.b   l_01b52
    clr.b   d0
l_01b52:
    btst    #$1, -$4(a1)
    beq.b   l_01b5e
    subi.w  #$100, d3
l_01b5e:
    btst    #$3, -$4(a1)
    beq.b   l_01b68
    clr.b   d3
l_01b68:
    neg.w   d3
    move.w  d0, (a1)+
    move.w  d3, (a1)+
    rts
