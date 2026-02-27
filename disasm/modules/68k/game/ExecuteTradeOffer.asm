; ============================================================================
; ExecuteTradeOffer -- Execute a trade offer by checking char capacity via GetLowNibble, adjusting the capacity field, subtracting relationship values at $FFBA81, and updating $FFB9E8.
; 192 bytes | $0235D8-$023697
; ============================================================================
ExecuteTradeOffer:
    movem.l d2-d5/a2, -(a7)
    move.l  $20(a7), d3
    move.l  $18(a7), d4
    movea.l $1c(a7), a2
    move.b  $a(a2), d0
    andi.l  #$2, d0
    moveq   #$2,d1
    cmp.l   d0, d1
    bne.b   l_235fe
l_235f8:
    moveq   #$0,d0
    bra.w   l_23692
l_235fe:
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    move.w  d0, d2
    cmp.w   d2, d3
    bcc.b   l_235f8
    moveq   #$0,d5
    move.b  $3(a2), d5
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d3, d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    moveq   #$0,d0
    move.b  $3(a2), d0
    cmp.w   d5, d0
    bcc.b   l_2366a
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.w  d5, d2
    sub.w   d0, d2
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
l_2366a:
    move.l  a2, -(a7)
    jsr GetByteField4
    lea     $c(a7), a7
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d4, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    adda.l  d0, a0
    movea.l a0, a2
    sub.b   d3, (a2)
    moveq   #$1,d0
l_23692:
    movem.l (a7)+, d2-d5/a2
    rts
