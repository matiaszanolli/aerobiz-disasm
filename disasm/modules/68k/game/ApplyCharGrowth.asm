; ============================================================================
; ApplyCharGrowth -- Decrements training counter for chars matched against given char; returns 1 if any counter changed
; 194 bytes | $035060-$035121
; ============================================================================
ApplyCharGrowth:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d3
    move.l  $1c(a7), d4
    clr.w   d5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d0
    move.b  $4(a1), d0
    mulu.w  #$14, d0
    move.w  d3, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $4(a1), d2
    bra.b   l_35104
l_350a6:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d4, d0
    beq.b   l_350b8
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d4, d0
    bne.b   l_350fe
l_350b8:
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcc.b   l_350fe
    cmpi.b  #$2, $3(a2)
    bls.b   l_350fe
    subq.b  #$1, $3(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    subq.b  #$1, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    subq.b  #$1, (a0,d0.w)
    moveq   #$1,d5
l_350fe:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_35104:
    moveq   #$0,d0
    move.b  $4(a1), d0
    moveq   #$0,d1
    move.b  $5(a1), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_350a6
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2
    rts
