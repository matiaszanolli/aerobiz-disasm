; ============================================================================
; ProgressGamePhase -- Advances one flight-slot record: clears it if it matches the turn record, otherwise computes bearing and step-size from city positions and writes tile-code and speed
; 344 bytes | $01AA58-$01ABAF
; ============================================================================
ProgressGamePhase:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    movea.l $8(a6), a3
    movea.l $10(a6), a1
    movea.l $c(a6), a0
    movea.l  #$00FF153C,a2
    clr.w   d2
l_1aa74:
    cmpa.l  a2, a3
    beq.b   l_1aaa2
    move.b  $1(a3), d0
    cmp.b   $1(a2), d0
    bne.b   l_1aaa2
    move.b  $2(a3), d0
    cmp.b   $2(a2), d0
    bne.b   l_1aaa2
l_1aa8c:
    pea     ($0012).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    bra.w   l_1aba6
l_1aaa2:
    moveq   #$12,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_1aa74
    moveq   #$0,d2
    move.b  (a0), d2
    moveq   #$0,d0
    move.b  $1(a0), d0
    move.w  d0, -$2(a6)
    moveq   #$0,d6
    move.b  (a1), d6
    moveq   #$0,d7
    move.b  $1(a1), d7
    cmp.w   d6, d2
    bne.b   l_1aad0
    cmp.w   -$2(a6), d7
    beq.b   l_1aa8c
l_1aad0:
    move.w  #$8560, d3
    cmp.w   d6, d2
    bhi.b   l_1aadc
    moveq   #$0,d4
    bra.b   l_1aade
l_1aadc:
    moveq   #$1,d4
l_1aade:
    tst.w   d4
    beq.b   l_1aaec
    moveq   #$0,d4
    move.w  d2, d4
    moveq   #$0,d0
    move.w  d6, d0
    bra.b   l_1aaf4
l_1aaec:
    moveq   #$0,d4
    move.w  d6, d4
    moveq   #$0,d0
    move.w  d2, d0
l_1aaf4:
    sub.l   d0, d4
    move.w  -$2(a6), d5
    sub.w   d7, d5
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    cmp.l   d1, d0
    bgt.b   l_1ab52
    move.w  d4, d0
    ext.l   d0
    bge.b   l_1ab12
    addq.l  #$1, d0
l_1ab12:
    asr.l   #$1, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_1ab20
    addq.w  #$4, d3
    bra.b   l_1ab52
l_1ab20:
    move.w  d4, d0
    ext.l   d0
    bge.b   l_1ab28
    addq.l  #$1, d0
l_1ab28:
    asr.l   #$1, d0
    neg.l   d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_1ab38
    addq.w  #$8, d3
    bra.b   l_1ab52
l_1ab38:
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    neg.l   d1
    cmp.l   d1, d0
    ble.b   l_1ab4e
    addi.w  #$c, d3
    bra.b   l_1ab52
l_1ab4e:
    ori.w   #$1000, d3
l_1ab52:
    cmp.w   d6, d2
    bls.b   l_1ab5e
    move.l  #$800, d0
    bra.b   l_1ab60
l_1ab5e:
    moveq   #$0,d0
l_1ab60:
    or.w    d0, d3
    tst.w   d5
    ble.b   l_1ab6c
    move.w  d5, d0
    ext.l   d0
    bra.b   l_1ab72
l_1ab6c:
    move.w  d5, d0
    ext.l   d0
    neg.l   d0
l_1ab72:
    add.w   d4, d0
    move.w  d0, d4
    cmpi.w  #$80, d4
    bls.b   l_1ab84
    move.l  #$80, d0
    bra.b   l_1ab86
l_1ab84:
    moveq   #$40,d0
l_1ab86:
    move.w  d0, d4
    move.w  d2, $4(a3)
    move.w  -$2(a6), $6(a3)
    move.w  d6, $8(a3)
    move.w  d7, $a(a3)
    clr.w   $c(a3)
    move.w  d4, $e(a3)
    move.w  d3, $10(a3)
l_1aba6:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts
