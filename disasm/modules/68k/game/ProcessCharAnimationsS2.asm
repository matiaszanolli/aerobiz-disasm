; ============================================================================
; ProcessCharAnimationsS2 -- Processes pending char animation and move records for a player at turn end: credits char revenue to route income, evicts expired char relations, resets char state slots, and applies accumulated city-popularity bonuses.
; 662 bytes | $027AD0-$027D65
; ============================================================================
ProcessCharAnimationsS2:
    dc.w    $0020,$3004                     ; ori.b #$4,-(a0) - high byte $30 is compiler junk
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d4, d0
    lsl.l   #$5, d0
    move.l  d0, d6
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
l_27afa:
    cmpi.b  #$5, $1(a2)
    bne.b   l_27b60
    cmpi.b  #$20, (a2)
    bcc.b   l_27b20
    moveq   #$0,d0
    move.b  (a2), d0
    mulu.w  #$6, d0
    moveq   #$0,d1
    move.b  $2(a2), d1
    add.w   d1, d0
    movea.l  #$00FF1704,a0
    bra.b   l_27b34
l_27b20:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    moveq   #$0,d1
    move.b  $2(a2), d1
    add.w   d1, d0
    movea.l  #$00FF15A0,a0
l_27b34:
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr CalcCharValue
    lea     $c(a7), a7
    move.l  d0, d2
    add.l   d2, $6(a3)
l_27b60:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_27afa
l_27b7e:
    moveq   #$0,d3
    move.b  $4(a3), d3
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d3
    moveq   #$0,d0
    move.b  $4(a3), d0
    mulu.w  #$14, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  #$320, d1
    jsr Multiply32
    move.l  d0, d5
    add.l   (a7)+, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $4(a3), d2
    bra.b   l_27bea
l_27bc0:
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcc.b   l_27be4
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr RemoveCharRelation
    lea     $c(a7), a7
    bra.b   l_27bee
l_27be4:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_27bea:
    cmp.w   d3, d2
    bcs.b   l_27bc0
l_27bee:
    cmp.w   d3, d2
    bcs.b   l_27b7e
    moveq   #$0,d3
    move.b  $4(a3), d3
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d3
    movea.l  #$00FF9A20,a0
    lea     (a0,d5.w), a2
    clr.w   d2
    bra.b   l_27c2e
l_27c0e:
    clr.w   $e(a2)
    clr.w   $6(a2)
    clr.w   $10(a2)
    clr.w   $8(a2)
    clr.w   $12(a2)
    move.b  #$4, $a(a2)
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_27c2e:
    cmp.w   d3, d2
    bcs.b   l_27c0e
    movea.l  #$00FF8824,a2
    clr.w   d2
l_27c3a:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    and.l   (a0,d1.w), d0
    bne.b   l_27c7c
    moveq   #$0,d3
    move.b  (a3), d3
    moveq   #$0,d0
    move.b  $1(a3), d0
    sub.w   d0, d3
    sub.b   d3, (a3)
    sub.b   d3, $1(a2)
l_27c7c:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    bcs.b   l_27c3a
    moveq   #$20,d2
l_27c88:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d3
    move.b  (a3), d3
    moveq   #$0,d0
    move.b  $1(a3), d0
    sub.w   d0, d3
    sub.b   d3, (a3)
    sub.b   d3, $1(a2)
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_27c88
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr CollectCharRevenue
    addq.l  #$8, a7
    move.w  d4, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    movea.l  #$00FFB9E8,a0
    lea     (a0,d6.w), a3
l_27ce8:
    cmpi.b  #$ff, (a2)
    beq.b   l_27d14
    tst.b   $1(a2)
    beq.b   l_27d14
    moveq   #$0,d0
    move.b  (a2), d0
    add.l   d0, d0
    movea.l d0, a0
    move.b  $1(a2), d0
    add.b   d0, (a3,a0.l)
    moveq   #$0,d0
    move.b  (a2), d0
    add.l   d0, d0
    movea.l d0, a0
    move.b  $1(a2), d0
    add.b   d0, $1(a3, a0.l)
l_27d14:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   l_27ce8
    movea.l  #$00FFB9E8,a0
    lea     (a0,d6.w), a2
    clr.w   d2
l_27d2a:
    moveq   #$0,d0
    move.b  $1(a2), d0
    tst.w   d0
    ble.b   l_27d48
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ApplyCharBonus
    addq.l  #$8, a7
l_27d48:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   l_27d2a
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (InitQuarterStart,PC)
    nop
    addq.l  #$4, a7
    movem.l (a7)+, d2-d6/a2-a3
    rts
