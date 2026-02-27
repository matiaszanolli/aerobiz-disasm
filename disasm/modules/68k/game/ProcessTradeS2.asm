; ============================================================================
; ProcessTradeS2 -- Determine trade result category (1-4) based on character type via jump table and current game phase timing via frame_counter mod 4.
; 126 bytes | $023308-$023385
; ============================================================================
ProcessTradeS2:
    moveq   #$0,d0
    move.w  $6(a7), d0
    moveq   #$52,d1
    cmp.l   d1, d0
    bhi.b   l_23382
    lea     $23348(pc), a0
    nop
    moveq   #$C,d1
    cmp.b   (a0)+, d0
    dbls    d1, ($0002331C).l
    bne.b   l_23382
    add.l   d1, d1
    dc.w    $303B,$1806                                 ; move.w (6,pc,d1.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0028
    dc.w    $0028
    dc.w    $004C
    dc.w    $004C
    dc.w    $0028
    dc.w    $0028
    dc.w    $0050
    dc.w    $0050
    dc.w    $004C
    dc.w    $0028
    dc.w    $004C
    dc.w    $0028
    dc.w    $0050
    dc.w    $0006
    btst    d3, (a4)+
    move.b  (a6)+, -(a6)
    move.l  -(a7), -(a2)
    dc.w    $2A36,$3A3C                                 ; move.l $3c(a6, d3.l), d5 - ext word has junk in bits 10-8
    addq.b  #$1, d0
    move.w  ($00FF0006).l, d0
    andi.l  #$3, d0
    beq.b   l_23376
    move.w  ($00FF0006).l, d0
    andi.l  #$3, d0
    moveq   #$3,d1
    cmp.l   d0, d1
    bne.b   l_23382
l_23376:
    moveq   #$1,d0
    bra.b   l_23384
    moveq   #$2,d0
    bra.b   l_23384
    moveq   #$3,d0
    bra.b   l_23384
l_23382:
    moveq   #$4,d0
l_23384:
    rts
