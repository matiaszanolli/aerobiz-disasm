; ============================================================================
; CalcTradeGains -- Calculate net trade gains for a route slot by scoring char-code compatibility, multiplying by slot value, and applying a signed division.
; 892 bytes | $020000-$02037B
; ============================================================================
CalcTradeGains:
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (GetRouteSlotDetails,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d4
    movea.l -$4(a6), a0
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d7, d1
    cmp.l   d1, d0
    bgt.b   l_20076
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (CalcSlotValue,PC)
    nop
    addq.l  #$8, a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (CalcSlotValue,PC)
    nop
    addq.l  #$8, a7
    add.l   (a7)+, d0
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d2, d1
    addi.l  #$64, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d3
l_20076:
    move.w  $8(a2), $12(a2)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    move.w  d0, d2
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$0,d1
    move.w  d2, d1
    sub.l   d1, d0
    moveq   #$64,d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    jsr SignedDiv
    addi.w  #$32, d0
    move.w  d0, d5
    movea.l -$4(a6), a0
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d7, d1
    cmp.l   d1, d0
    ble.b   l_2012a
    move.w  (a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  $2(a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    moveq   #$0,d1
    move.w  (a4), d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a3), d0
    moveq   #$0,d1
    move.w  (a3), d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.w  (a3), d1
    moveq   #$0,d2
    move.w  (a4), d2
    add.l   d2, d1
    jsr UnsignedDivide
    bra.w   l_201b0
l_2012a:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    andi.l  #$ffff, d1
    moveq   #$0,d2
    move.b  $1(a4), d2
    andi.l  #$ffff, d2
    add.l   d2, d1
    jsr SignedDiv
l_201b0:
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d5, d1
    sub.l   d1, d0
    addi.l  #$64, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d0, d3
    cmpi.w  #$7, d4
    bcc.b   l_201e2
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_201e4
l_201e2:
    moveq   #$7,d0
l_201e4:
    lsl.l   #$2, d0
    moveq   #$68,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d3
    move.l  a2, -(a7)
    jsr GetByteField4
    lea     $c(a7), a7
    move.w  d0, d2
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    andi.l  #$ffff, d5
    move.l  d5, d0
    lsl.l   #$2, d5
    add.l   d0, d5
    add.l   d5, d5
    moveq   #$0,d0
    move.w  d3, d0
    cmp.l   d0, d5
    bge.b   l_2025e
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    andi.l  #$ffff, d5
    move.l  d5, d0
    lsl.l   #$2, d5
    add.l   d0, d5
    add.l   d5, d5
    bra.b   l_20262
l_2025e:
    moveq   #$0,d5
    move.w  d3, d5
l_20262:
    cmpi.w  #$7, d4
    bcc.b   l_2026e
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_20270
l_2026e:
    moveq   #$7,d0
l_20270:
    mulu.w  d5, d0
    move.w  d0, $8(a2)
    cmpi.w  #$7, d4
    bls.w   l_202fc
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    mulu.w  #$a, d0
    move.w  d3, d1
    sub.w   d0, d1
    move.w  d1, d5
    ble.b   l_202fc
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_202ea
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    bra.b   l_202ee
l_202ea:
    move.w  d5, d0
    ext.l   d0
l_202ee:
    move.w  d0, d5
    move.w  d4, d0
    addi.w  #$fff9, d0
    mulu.w  d5, d0
    add.w   d0, $8(a2)
l_202fc:
    moveq   #$0,d0
    move.w  $8(a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr SignedDiv
    move.w  d0, $10(a2)
    mulu.w  d4, d0
    move.w  d0, $8(a2)
    moveq   #$0,d2
    move.w  $8(a2), d2
    move.l  d2, d0
    add.l   d2, d2
    add.l   d0, d2
    lsl.l   #$2, d2
    move.w  d6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF01B0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l -$4(a6), a0
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d7, d1
    cmp.l   d1, d0
    ble.b   l_20350
    add.l   d2, $1c(a3)
    bra.b   l_2036c
l_20350:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    add.l   d2, (a3,a0.l)
l_2036c:
    move.w  #$1, $4(a5)
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
