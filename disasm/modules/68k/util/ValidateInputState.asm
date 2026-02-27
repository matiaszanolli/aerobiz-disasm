; ============================================================================
; ValidateInputState -- Checks whether a given character slot index is currently locked (active) in any of the 4 player route bitmask arrays at $FF08EC: returns 1 if the corresponding bit is set in any player's mask, 0 otherwise (or 0 if the index is >= 32).
; 66 bytes | $01F0FA-$01F13B
; ============================================================================
ValidateInputState:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d3
    cmpi.w  #$20, d3
    bcc.b   l_1f132
    clr.w   d4
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d3
    movea.l  #$00FF08EC,a0
    clr.w   d2
l_1f11c:
    move.l  d3, d0
    and.l   (a0), d0
    beq.b   l_1f126
    moveq   #$1,d4
    bra.b   l_1f134
l_1f126:
    addq.l  #$4, a0
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1f11c
    bra.b   l_1f134
l_1f132:
    clr.w   d4
l_1f134:
    move.w  d4, d0
    movem.l (a7)+, d2-d4
    rts
