; ============================================================================
; ScanCharRoster -- Checks if a char pair is already in the alliance bitmask or if any roster slot is still available; returns 1 if open
; 208 bytes | $0338E6-$0339B5
; ============================================================================
ScanCharRoster:
    movem.l d2-d7/a2, -(a7)
    move.l  $24(a7), d2
    move.l  $20(a7), d3
    move.l  $28(a7), d6
    clr.w   d5
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    lea     $10(a7), a7
    move.w  d0, d7
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d2, d1
    movea.l  #$00FFA7BC,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    and.l   d1, d0
    bne.b   l_339ae
    cmp.w   d6, d7
    beq.b   l_339ac
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  (a2), d2
    bra.b   l_33984
l_3396c:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    tst.b   (a0,d0.w)
    bne.b   l_33998
    addq.w  #$1, d2
l_33984:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_3396c
l_33998:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_339ae
l_339ac:
    moveq   #$1,d5
l_339ae:
    move.w  d5, d0
    movem.l (a7)+, d2-d7/a2
    rts
