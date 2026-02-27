; ============================================================================
; UpdateCharMetrics -- Records a char-pair relation, updates alliance bitmasks and VSRAM, adjusts stamina, shows relation panel
; 774 bytes | $0339DC-$033CE1
; ============================================================================
UpdateCharMetrics:
    link    a6,#-$18
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $10(a6), d4
    move.l  $c(a6), d5
    movea.l  #$00FFA6A0,a4
    lea     -$18(a6), a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    pea     ($0003).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lea     $c(a7), a7
    move.l  d0, (a5)
    move.l  $6(a2), d0
    cmp.l   (a5), d0
    ble.w   l_33cd4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d6
    cmp.w   d6, d2
    beq.b   l_33a54
    addq.b  #$1, $4(a2)
    bra.b   l_33a58
l_33a54:
    addq.b  #$1, $5(a2)
l_33a58:
    pea     ($0014).w
    clr.l   -(a7)
    pea     -$14(a6)
    jsr MemFillByte
    lea     -$14(a6), a3
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ApplyRelationBonus,PC)
    nop
    move.b  #$4, $a(a3)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InsertRelationRecord
    lea     $30(a7), a7
    cmp.w   d6, d2
    beq.b   l_33b08
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    moveq   #$1,d0
    lsl.b   d6, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d2, d1
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    moveq   #$1,d0
    lsl.b   d2, d0
    move.w  d3, d1
    mulu.w  #$7, d1
    add.w   d6, d1
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    bra.w   l_33bba
l_33b08:
    cmpi.w  #$20, d5
    bcc.b   l_33b26
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    bra.b   l_33b60
l_33b26:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d5, d7
    sub.w   d0, d7
    moveq   #$1,d0
    lsl.w   d7, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d2, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a2)
l_33b60:
    cmpi.w  #$20, d4
    bcc.b   l_33b80
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    or.l    d0, (a4,a0.l)
    bra.b   l_33bba
l_33b80:
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d4, d7
    sub.w   d0, d7
    moveq   #$1,d0
    lsl.w   d7, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d6, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a2)
l_33bba:
    clr.b   $2(a2)
    clr.w   d2
l_33bc0:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    and.l   (a4,a0.l), d0
    beq.b   l_33bdc
    addq.b  #$1, $2(a2)
l_33bdc:
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    bcs.b   l_33bc0
    move.l  (a5), d0
    sub.l   d0, $6(a2)
    move.l  a3, -(a7)
    jsr GetByteField4
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    adda.l  d0, a0
    movea.l a0, a2
    move.l  a3, -(a7)
    jsr GetLowNibble
    sub.b   d0, (a2)
    move.w  d5, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a3), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a3), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    jsr DrawBox
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000448BA).l
    jsr PrintfWide
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    pea     ($001E).w
    jsr PollInputChange
    moveq   #$1,d3
    bra.b   l_33cd6
l_33cd4:
    clr.w   d3
l_33cd6:
    move.w  d3, d0
    movem.l -$40(a6), d2-d7/a2-a5
    unlk    a6
    rts
