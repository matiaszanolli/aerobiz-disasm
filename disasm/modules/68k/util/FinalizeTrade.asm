; ============================================================================
; FinalizeTrade -- Find a suitable route slot for a trade by randomly searching a player's active routes for a slot matching the offered/accepted char codes.
; 144 bytes | $023698-$023727
; ============================================================================
FinalizeTrade:
    movem.l d2-d5/a2, -(a7)
    move.l  $1c(a7), d3
    move.l  $18(a7), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $4(a2), d4
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d4
    cmpi.w  #$1, d4
    bcc.b   l_236ce
l_236ca:
    moveq   #$0,d0
    bra.b   l_23722
l_236ce:
    subq.w  #$1, d4
    clr.w   d2
l_236d2:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    mulu.w  #$14, d0
    move.w  d5, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$ff, d3
    beq.b   l_2371a
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d3, d0
    beq.b   l_2371a
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
    beq.b   l_2371a
    addq.w  #$1, d2
    cmpi.w  #$100, d2
    blt.b   l_236d2
l_2371a:
    cmpi.w  #$100, d2
    bge.b   l_236ca
    move.l  a2, d0
l_23722:
    movem.l (a7)+, d2-d5/a2
    rts
