; ============================================================================
; CalcMatchScore -- Writes char/player IDs and win/draw flags into match record at $FF88DC
; 206 bytes | $0349F2-$034ABF
; ============================================================================
CalcMatchScore:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d2
    move.l  $28(a7), d3
    move.l  $24(a7), d4
    move.l  $20(a7), d5
    move.w  d2, d0
    mulu.w  #$30, d0
    move.w  $1e(a7), d1
    mulu.w  #$c, d1
    add.w   d1, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d5, (a2)
    move.w  d4, $2(a2)
    move.w  d3, $4(a2)
    move.w  d5, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.b  $1(a1), d1
    sub.l   d1, d0
    bne.b   l_34a58
    move.w  #$1, $6(a2)
    bra.b   l_34a5e
l_34a58:
    move.w  #$3, $6(a2)
l_34a5e:
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.b  $1(a1), d1
    sub.l   d1, d0
    bne.b   l_34a8a
    move.w  #$1, $8(a2)
    bra.b   l_34a90
l_34a8a:
    move.w  #$3, $8(a2)
l_34a90:
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.b   $1(a1)
    bne.b   l_34ab4
    move.w  #$1, $a(a2)
    bra.b   l_34aba
l_34ab4:
    move.w  #$3, $8(a2)
l_34aba:
    movem.l (a7)+, d2-d5/a2
    rts
