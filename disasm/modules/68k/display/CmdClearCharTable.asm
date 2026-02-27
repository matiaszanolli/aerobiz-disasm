; ============================================================================
; CmdClearCharTable -- Zero all character animation table buffers and reset associated control flags
; 64 bytes | $000AE8-$000B27
; ============================================================================
CmdClearCharTable:
    movea.l  #$00FFF336,a0
    move.l  #$1ff, d0
    moveq   #$0,d1
l_00af6:
    move.l  d1, (a0)+
    dbra    d0, $AF6
    moveq   #$7,d0
    movea.l  #$00FFF316,a0
l_00b04:
    move.l  d1, (a0)+
    dbra    d0, $B04
    move.b  d1, $2fb(a5)
    move.w  d1, $2fc(a5)
    move.w  d1, $304(a5)
    move.w  d1, $300(a5)
    move.w  d1, $302(a5)
    move.b  d1, $2fe(a5)
    move.b  d1, $2ff(a5)
    rts
