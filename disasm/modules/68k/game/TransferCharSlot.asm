; ============================================================================
; TransferCharSlot -- Moves stamina from a source char slot to a destination slot; updates alliance stamina counters; returns success
; 320 bytes | $03345E-$03359D
; ============================================================================
TransferCharSlot:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    move.l  $10(a6), d5
    clr.w   d6
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d7
    move.b  $3(a2), d7
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    move.w  d0, d2
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, -$2(a6)
    move.l  a2, -(a7)
    jsr GetLowNibble
    lea     $10(a7), a7
    move.w  d0, d4
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    cmp.w   $2(a5), d2
    bhi.w   l_33592
    tst.b   $1(a3)
    beq.b   l_33592
    moveq   #$0,d2
    move.b  $1(a3), d2
    cmp.w   d4, d2
    bls.b   l_33526
    moveq   #$0,d2
    move.w  d4, d2
    bra.b   l_33532
l_33526:
    moveq   #$0,d2
    move.b  $1(a3), d2
    andi.l  #$ffff, d2
l_33532:
    add.b   d4, $1(a4)
    sub.b   d2, $1(a3)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr SetHighNibble
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    moveq   #$0,d2
    move.b  $3(a2), d2
    move.w  d7, d0
    sub.w   d2, d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
    moveq   #$1,d6
l_33592:
    move.w  d6, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
