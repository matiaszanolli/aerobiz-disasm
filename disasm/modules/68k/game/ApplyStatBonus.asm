; ============================================================================
; ApplyStatBonus -- Counts unfulfilled skill slots (type=1 with unmet stat threshold) for a player; returns count
; 158 bytes | $036922-$0369BF
; ============================================================================
ApplyStatBonus:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d4
    clr.w   d2
    move.w  d4, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
l_3693e:
    tst.b   $1(a2)
    beq.b   l_369ac
    cmpi.b  #$1, $1(a2)
    bne.b   l_3698c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr GetModeRowOffset
    moveq   #$0,d1
    move.b  $3(a2), d1
    add.w   d1, d0
    move.w  d0, d6
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr CalcCharRating
    lea     $10(a7), a7
    move.w  d0, d5
    cmp.w   d5, d6
    bcs.b   l_369ae
    bra.b   l_369ac
l_3698c:
    cmpi.b  #$3, $1(a2)
    beq.b   l_369ac
    cmpi.b  #$5, $1(a2)
    beq.b   l_369ac
    cmpi.b  #$6, $1(a2)
    bne.b   l_369ae
    cmpi.b  #$1, $3(a2)
    bhi.b   l_369ae
l_369ac:
    addq.w  #$1, d2
l_369ae:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_3693e
    move.w  d2, d0
    movem.l (a7)+, d2-d6/a2
    rts
