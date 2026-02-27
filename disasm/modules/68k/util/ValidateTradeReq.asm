; ============================================================================
; ValidateTradeReq -- Validate a trade request by checking $FF09C2 records for type 3/4 codes and comparing char type values via the D648 lookup.
; 156 bytes | $02051C-$0205B7
; ============================================================================
ValidateTradeReq:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d5
    movea.l  #$0000D648,a4
    moveq   #$1,d4
    moveq   #$7,d3
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d5, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FF09C2,a2
    clr.w   d2
l_20554:
    cmpi.b  #$3, (a2)
    bne.b   l_2056c
    moveq   #$0,d0
    move.b  $1(a2), d0
l_20560:
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    move.w  d0, d3
    bra.b   l_20596
l_2056c:
    cmpi.b  #$4, (a2)
    bne.b   l_2058c
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA2C,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    bra.b   l_20560
l_2058c:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    bcs.b   l_20554
l_20596:
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   l_205b0
    moveq   #$2,d4
l_205b0:
    move.w  d4, d0
    movem.l (a7)+, d2-d5/a2-a4
    rts
