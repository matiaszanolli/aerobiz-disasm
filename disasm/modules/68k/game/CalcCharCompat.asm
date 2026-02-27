; ============================================================================
; CalcCharCompat -- Computes compatibility score for a char pair: multiplies stat fields, divides by totals, scales by CharCodeScore
; 206 bytes | $033E94-$033F61
; ============================================================================
CalcCharCompat:
    movem.l d2-d3/a2-a4, -(a7)
    movea.l $18(a7), a2
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a4), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    andi.l  #$ffff, d1
    moveq   #$0,d3
    move.b  $1(a3), d3
    andi.l  #$ffff, d3
    add.l   d3, d1
    jsr SignedDiv
    addi.w  #$32, d0
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    movem.l (a7)+, d2-d3/a2-a4
    rts
