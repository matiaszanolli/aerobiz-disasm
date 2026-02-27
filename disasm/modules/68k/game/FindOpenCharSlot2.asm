; ============================================================================
; FindOpenCharSlot2 -- Finds an available open char slot for two char indices under a player; dispatches to ScanCharRoster or GetActiveCharCount
; 212 bytes | $033812-$0338E5
; ============================================================================
FindOpenCharSlot2:
    link    a6,#-$4
    movem.l d2-d7/a2, -(a7)
    move.l  $10(a6), d2
    move.l  $c(a6), d3
    move.l  $8(a6), d5
    lea     -$2(a6), a2
    clr.w   d6
    cmpi.w  #$59, d3
    bcc.w   l_338da
    cmpi.w  #$59, d2
    bcc.w   l_338da
    cmp.w   d2, d3
    beq.w   l_338da
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, (a2)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d7
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    move.w  d0, -$4(a6)
    cmp.w   d3, d4
    beq.b   l_33892
    cmp.w   -$4(a6), d2
    bne.b   l_338da
l_33892:
    cmp.w   d3, d4
    beq.b   l_3389c
    move.w  d3, d4
    move.w  d2, d3
    move.w  d4, d2
l_3389c:
    cmp.w   (a2), d7
    beq.b   l_338c0
    cmpi.w  #$20, d2
    bcc.b   l_338da
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ScanCharRoster,PC)
    nop
    bra.b   l_338d8
l_338c0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (GetActiveCharCount,PC)
    nop
l_338d8:
    move.w  d0, d6
l_338da:
    move.w  d6, d0
    movem.l -$20(a6), d2-d7/a2
    unlk    a6
    rts
