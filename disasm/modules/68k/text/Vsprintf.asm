; ============================================================================
; Vsprintf -- C-style vsprintf implementation: formats a string into a buffer using a format string and va_list; supports %d, %u, %x, %s, %c, %w, width/precision, left-align, zero-pad, $ currency
; 538 bytes | $03AFF2-$03B20B
; ============================================================================
Vsprintf:
    link    a6,#-$EC
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a3
    lea     -$e6(a6), a4
    lea     -$e2(a6), a5
    lea     -$c8(a6), a2
    move.l  $8(a6), (a5)
    bra.w   l_3b1ea
l_3b012:
    cmpi.b  #$25, d2
    bne.w   l_3b1e8
    lea     -$de(a6), a0
    move.l  a0, (a4)
    moveq   #$6,d5
    clr.w   d7
    clr.w   d6
    clr.w   -$e8(a6)
    clr.w   -$ea(a6)
    movea.l (a5), a0
    move.b  (a0), d2
    cmpi.b  #$2d, d2
    bne.b   l_3b040
    moveq   #$1,d6
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2
l_3b040:
    cmpi.b  #$24, d2
    bne.b   l_3b064
    move.w  #$1, -$e8(a6)
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2
    cmpi.b  #$24, d2
    bne.b   l_3b064
    move.w  #$1, -$ea(a6)
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2
l_3b064:
    cmpi.b  #$30, d2
    bne.b   l_3b06e
    moveq   #$30,d0
    bra.b   l_3b070
l_3b06e:
    moveq   #$20,d0
l_3b070:
    move.b  d0, -$eb(a6)
    cmpi.b  #$30, d2
    bcs.b   l_3b094
    cmpi.b  #$39, d2
    bhi.b   l_3b094
    pea     -$e2(a6)
    bsr.w ParseDecimalDigit
    addq.l  #$4, a7
    move.l  d0, d3
    andi.l  #$ffff, d3
    bra.b   l_3b096
l_3b094:
    moveq   #$0,d3
l_3b096:
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d0
    move.b  d0, d2
    cmpi.b  #$2e, d0
    bne.b   l_3b0b8
    pea     -$e2(a6)
    bsr.w ParseDecimalDigit
    addq.l  #$4, a7
    move.w  d0, d5
    moveq   #$1,d7
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d2
l_3b0b8:
    moveq   #$0,d0
    move.b  d2, d0
    move.l  d0, -(a7)
    jsr ToUpperCase
    moveq   #$4C,d1
    cmp.l   d0, d1
    bne.b   l_3b0d0
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d2
l_3b0d0:
    clr.b   d4
    moveq   #$0,d0
    move.b  d2, d0
    move.l  d0, -(a7)
    jsr ToUpperCase
    addq.l  #$8, a7
    andi.l  #$ff, d0
    moveq   #$44,d1
    cmp.b   d1, d0
    beq.b   l_3b114
    moveq   #$55,d1
    cmp.b   d1, d0
    beq.b   l_3b124
    moveq   #$58,d1
    cmp.b   d1, d0
    beq.b   l_3b13a
    moveq   #$53,d1
    cmp.b   d1, d0
    beq.b   l_3b146
    moveq   #$43,d1
    cmp.b   d1, d0
    beq.b   l_3b15a
    moveq   #$57,d1
    cmp.b   d1, d0
    beq.b   l_3b166
    tst.b   d0
    beq.w   l_3b202
    bra.w   l_3b1e8
l_3b114:
    tst.l   (a3)
    bge.b   l_3b124
    neg.l   (a3)
    movea.l (a4), a0
    addq.l  #$1, (a4)
    move.b  #$2d, (a0)
    subq.w  #$1, d3
l_3b124:
    move.l  (a3), -(a7)
    pea     -$e6(a6)
    bsr.w IntToDecimalStr
l_3b12e:
    addq.l  #$8, a7
    sub.w   d0, d3
    addq.l  #$4, a3
l_3b134:
    ori.b   #$1, d4
    bra.b   l_3b16c
l_3b13a:
    move.l  (a3), -(a7)
    pea     -$e6(a6)
    bsr.w IntToHexStr
    bra.b   l_3b12e
l_3b146:
    move.l  (a3), (a4)
    move.l  (a4), -(a7)
    bsr.w CountFormatChars
    addq.l  #$4, a7
    sub.w   d0, d3
    addq.l  #$4, a3
    ori.b   #$2, d4
    bra.b   l_3b16c
l_3b15a:
    subq.w  #$1, d3
    move.l  (a3)+, d0
    movea.l (a4), a0
    addq.l  #$1, (a4)
    move.b  d0, (a0)
    bra.b   l_3b134
l_3b166:
    add.w   d5, d5
    add.w   d3, d3
    bra.b   l_3b124
l_3b16c:
    btst    #$0, d4
    beq.b   l_3b182
    movea.l (a4), a0
    clr.b   (a0)
    lea     -$de(a6), a0
    move.l  a0, (a4)
    clr.w   d7
    ori.b   #$2, d4
l_3b182:
    btst    #$1, d4
    beq.b   l_3b1ea
    move.w  d3, d2
    bra.b   l_3b190
l_3b18c:
    move.b  -$eb(a6), (a2)+
l_3b190:
    move.l  d3, d0
    subq.w  #$1, d3
    tst.w   d0
    ble.b   l_3b19c
    tst.w   d6
    beq.b   l_3b18c
l_3b19c:
    tst.w   -$e8(a6)
    beq.b   l_3b1b8
    move.b  #$24, (a2)+
    bra.b   l_3b1b8
l_3b1a8:
    tst.w   d7
    beq.b   l_3b1b0
    tst.w   d5
    ble.b   l_3b1b6
l_3b1b0:
    movea.l (a4), a0
    move.b  (a0), (a2)+
    subq.w  #$1, d5
l_3b1b6:
    addq.l  #$1, (a4)
l_3b1b8:
    movea.l (a4), a0
    tst.b   (a0)
    bne.b   l_3b1a8
    tst.w   -$e8(a6)
    beq.b   l_3b1da
    cmpi.w  #$1, -$ea(a6)
    beq.b   l_3b1da
    move.b  #$30, (a2)+
    move.b  #$4b, (a2)+
    bra.b   l_3b1da
l_3b1d6:
    move.b  -$eb(a6), (a2)+
l_3b1da:
    move.l  d2, d0
    subq.w  #$1, d2
    tst.w   d0
    ble.b   l_3b1ea
    tst.w   d6
    bne.b   l_3b1d6
    bra.b   l_3b1ea
l_3b1e8:
    move.b  d2, (a2)+
l_3b1ea:
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d2
    bne.w   l_3b012
    clr.b   (a2)
    lea     -$c8(a6), a0
    movea.l $10(a6), a1
l_3b1fe:
    move.b  (a0)+, (a1)+
    bne.b   l_3b1fe
l_3b202:
    movem.l -$114(a6), d2-d7/a2-a5
    unlk    a6
    rts
