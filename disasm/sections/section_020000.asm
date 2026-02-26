; ===========================================================================
; ROM Data: $020000-$02FFFF
; 65536 bytes (32768 words)
; ===========================================================================

; === Translated block $020000-$0206EE ===
; 5 functions, 1774 bytes

; ============================================================================
; CalcTradeGains -- (TODO: name)
; 892 bytes | $020000-$02037B
; ============================================================================
CalcTradeGains:
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0376                                 ; jsr $02037C(pc)
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
    dc.w    $4EBA,$0412                                 ; jsr $020448(pc)
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
    dc.w    $4EBA,$03FA                                 ; jsr $020448(pc)
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

; ============================================================================
; GetRouteSlotDetails -- (TODO: name)
; 204 bytes | $02037C-$020447
; ============================================================================
GetRouteSlotDetails:
    link    a6,#$0
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $8(a6), d2
    clr.w   d3
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmp.w   ($00FF09D6).l, d2
    beq.b   l_203cc
    movea.l  #$00FF09CA,a3
    cmpi.b  #$1, (a3)
    bne.b   l_203ce
    move.b  (a2), d0
    cmp.b   $1(a3), d0
    beq.b   l_203cc
    move.b  $1(a2), d0
    cmp.b   $1(a3), d0
    bne.b   l_203ce
l_203cc:
    moveq   #$1,d3
l_203ce:
    cmpi.w  #$1, d3
    bne.b   l_20436
    cmpi.b  #$2, $3(a2)
    bls.b   l_20432
    moveq   #$0,d0
    move.b  $3(a2), d0
    addi.w  #$ffff, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    bge.b   l_203fe
    addq.l  #$1, d0
l_203fe:
    asr.l   #$1, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    ble.b   l_2041a
    moveq   #$0,d0
    move.b  $3(a2), d0
    bge.b   l_20414
    addq.l  #$1, d0
l_20414:
    asr.l   #$1, d0
    ext.l   d0
    bra.b   l_2041e
l_2041a:
    moveq   #$0,d0
    move.w  d2, d0
l_2041e:
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_2042c
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_2042e
l_2042c:
    moveq   #$1,d0
l_2042e:
    move.w  d0, d2
    bra.b   l_2043c
l_20432:
    moveq   #$1,d2
    bra.b   l_2043c
l_20436:
    moveq   #$0,d2
    move.b  $3(a2), d2
l_2043c:
    move.w  d2, d0
    movem.l -$10(a6), d2-d3/a2-a3
    unlk    a6
    rts

; ============================================================================
; CalcSlotValue -- (TODO: name)
; 212 bytes | $020448-$02051B
; ============================================================================
CalcSlotValue:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $28(a7), d3
    move.l  $24(a7), d6
    cmpi.w  #$20, d3
    bcc.b   l_20482
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d2
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FF0420,a0
    lea     (a0,d2.w), a2
    moveq   #$6,d5
    bra.b   l_204a4
l_20482:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$4,d5
l_204a4:
    clr.w   d3
    clr.w   d4
    clr.w   d2
    bra.b   l_204e6
l_204ac:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bne.b   l_204e0
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmpi.w  #$1, d0
    bne.b   l_204e0
    moveq   #$0,d0
    move.b  $2(a4), d0
    add.w   d0, d3
    addq.w  #$1, d4
l_204e0:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
l_204e6:
    cmp.w   d5, d2
    bcs.b   l_204ac
    tst.w   d4
    beq.b   l_20514
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$6A,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d3
l_20514:
    move.w  d3, d0
    movem.l (a7)+, d2-d6/a2-a4
    rts

; ============================================================================
; ValidateTradeReq -- (TODO: name)
; 156 bytes | $02051C-$0205B7
; ============================================================================
ValidateTradeReq:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d5
    movea.l  #$0000D648,a4
    moveq   #$1,d4
    moveq   #$7,d3
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d5, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FF09C2,a2
    clr.w   d2
l_20554:
    cmpi.b  #$3, (a2)
    bne.b   l_2056c
    moveq   #$0,d0
    move.b  $1(a2), d0
l_20560:
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    move.w  d0, d3
    bra.b   l_20596
l_2056c:
    cmpi.b  #$4, (a2)
    bne.b   l_2058c
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA2C,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    bra.b   l_20560
l_2058c:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    bcs.b   l_20554
l_20596:
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   l_205b0
    moveq   #$2,d4
l_205b0:
    move.w  d4, d0
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; PrepareTradeOffer -- (TODO: name)
; 310 bytes | $0205B8-$0206ED
; ============================================================================
PrepareTradeOffer:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d4
    move.b  $4(a3), d4
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d4
    move.l  $a(a3), $16(a3)
    move.l  $e(a3), $1a(a3)
    move.l  $12(a3), $1e(a3)
    clr.l   $a(a3)
    clr.l   $e(a3)
    clr.l   $12(a3)
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.w   l_206d2
l_20616:
    andi.b  #$fa, $a(a2)
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_206c4
    moveq   #$0,d0
    move.w  $8(a2), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    moveq   #$0,d1
    move.w  $4(a2), d1
    jsr Multiply32
    move.l  #$2710, d1
    jsr SignedDiv
    move.w  d0, $e(a2)
    moveq   #$0,d0
    move.b  $3(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$005E                                 ; jsr $0206EE(pc)
    nop
    lea     $10(a7), a7
    move.w  d0, $6(a2)
    moveq   #$0,d0
    move.w  $e(a2), d0
    add.l   d0, $a(a3)
    moveq   #$0,d0
    move.w  $6(a2), d0
    add.l   d0, $e(a3)
    moveq   #$0,d3
    move.w  $8(a2), d3
    move.l  d3, d0
    add.l   d3, d3
    add.l   d0, d3
    lsl.l   #$2, d3
    add.l   d3, $12(a3)
    bra.b   l_206cc
l_206c4:
    clr.w   $e(a2)
    clr.w   $6(a2)
l_206cc:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_206d2:
    cmp.w   d4, d2
    bcs.w   l_20616
    move.l  $e(a3), d0
    sub.l   d0, $6(a3)
    move.l  $a(a3), d0
    add.l   d0, $6(a3)
    movem.l (a7)+, d2-d4/a2-a3
    rts

; ---------------------------------------------------------------------------
CalcCharProfit:                                                  ; $0206EE
    movem.l d2-d6/a2-a3,-(sp)
    move.l  $0024(sp),d2
    move.l  $002c(sp),d3
    move.l  $0020(sp),d4
    move.l  $0028(sp),d5
    move.w  d5,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.w  d4,d1
    add.w   d1,d1
    movea.l #$00ff0728,a0
    move.b  (a0,d1.w),d1
    andi.l  #$ff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d5
    asr.l   #$6,d5
    cmpi.w  #$20,d2
    bcs.b   .l207aa
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    tst.l   d0
    ble.b   .l2078e
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,-(sp)
    bra.b   .l20790
.l2078e:                                                ; $02078E
    clr.l   -(sp)
.l20790:                                                ; $020790
    moveq   #$0,d0
    move.b  $0001(a2),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  (sp)+,d1
    bra.b   .l207d4
.l207aa:                                                ; $0207AA
    moveq   #$0,d0
    move.b  $0001(a2),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.w  d2,d1
    add.w   d1,d1
    movea.l #$00ff0728,a0
    move.b  (a0,d1.w),d1
    andi.l  #$ff,d1
.l207d4:                                                ; $0207D4
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d6
    asr.l   #$6,d6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
    move.w  d0,d2
    moveq   #$0,d0
    move.w  $0002(a2),d0
    moveq   #$32,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    add.l   (sp)+,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $0002(a2),d0
    moveq   #$32,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.b  $0008(a2),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  (sp)+,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.b  $0008(a2),d1
    add.w   d1,d0
    move.w  d0,d4
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  ($00FF1294).l,d1
    ext.l   d1
    addi.l  #$32,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    lsr.l   #$1,d0
    move.l  d0,d2
    move.l  #$2710,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    add.w   d5,d0
    add.w   d6,d0
    move.w  d0,d2
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l208e8
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    bra.b   .l208ea
.l208e8:                                                ; $0208E8
    moveq   #$1,d0
.l208ea:                                                ; $0208EA
    move.w  d0,d2
    movem.l (sp)+,d2-d6/a2-a3
    rts
; ---------------------------------------------------------------------------
; === Translated block $0208F0-$020A62 ===
; 2 functions, 370 bytes

; ============================================================================
; UpdateRouteFieldValues -- (TODO: name)
; 300 bytes | $0208F2-$020A1D
; ============================================================================
UpdateRouteFieldValues:
    link    a6,#-$8
    movem.l d2-d3/a2-a4, -(a7)
    movea.l  #$00FF09A2,a4
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF0420,a2
    clr.w   d3
l_2091a:
    clr.w   d2
l_2091c:
    moveq   #$0,d0
    move.b  (a2), d0
    cmpi.w  #$4, d0
    bcc.b   l_2096e
    pea     -$8(a6)
    pea     -$4(a6)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    move.w  ($00FF0006).l, d0
    move.l  d0, -(a7)
    jsr CalcCharOutput
    lea     $18(a7), a7
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$4(a6), d0
    add.l   d0, (a4,a0.l)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$8(a6), d0
    add.l   d0, $4(a4, a0.l)
l_2096e:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_2091c
    addq.w  #$1, d3
    cmpi.w  #$20, d3
    bcs.b   l_2091a
    movea.l  #$00FF04E0,a2
    moveq   #$20,d3
l_20988:
    clr.w   d2
l_2098a:
    moveq   #$0,d0
    move.b  (a2), d0
    cmpi.w  #$4, d0
    bcc.b   l_209dc
    pea     -$8(a6)
    pea     -$4(a6)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    move.w  ($00FF0006).l, d0
    move.l  d0, -(a7)
    jsr CalcCharOutput
    lea     $18(a7), a7
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$4(a6), d0
    add.l   d0, (a4,a0.l)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$8(a6), d0
    add.l   d0, $4(a4, a0.l)
l_209dc:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_2098a
    addq.w  #$1, d3
    cmpi.w  #$59, d3
    bcs.b   l_20988
    movea.l  #$00FF0018,a2
    movea.l a4, a3
    clr.w   d3
l_209f8:
    move.l  $4(a3), d0
    sub.l   d0, $6(a2)
    move.l  (a3), d0
    add.l   d0, $6(a2)
    moveq   #$24,d0
    adda.l  d0, a2
    addq.l  #$8, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_209f8
    movem.l -$1c(a6), d2-d3/a2-a4
    unlk    a6
    rts


; === Translated block $020A1E-$020A64 ===
; 1 functions, 70 bytes

; ============================================================================
; UpdateGameStateCounters -- (TODO: name)
; 70 bytes | $020A1E-$020A63
; ============================================================================
UpdateGameStateCounters:
    movea.l  #$00FF0338,a0
    clr.w   d0
l_20a26:
    clr.w   d1
l_20a28:
    cmpi.b  #$6, $1(a0)
    bne.b   l_20a50
    subq.b  #$1, $3(a0)
    tst.b   $3(a0)
    bne.b   l_20a50
    clr.b   (a0)
    clr.b   $1(a0)
    clr.b   $2(a0)
    clr.b   $3(a0)
    clr.w   $4(a0)
    clr.w   $6(a0)
l_20a50:
    addq.l  #$8, a0
    addq.w  #$1, d1
    cmpi.w  #$4, d1
    bcs.b   l_20a28
    addq.w  #$1, d0
    cmpi.w  #$4, d0
    bcs.b   l_20a26
    rts


; ============================================================================
; ShowGameScreen -- (TODO: describe)
; Called: ?? times.
; 212 bytes | $020A64-$020B37
; ============================================================================
ShowGameScreen:                                                  ; $020A64
    movem.l d2-d3,-(sp)
    moveq   #$0,d3
    move.b  ($00FF0016).l,d3
    move.w  ($00FFA6B0).l,d2
    andi.w  #$7fff,d2
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0010).w
    pea     ($0010).w
    pea     ($000769FE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($00071098).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.l  ($000A1AF0).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($00FA).w
    pea     ($0001).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$004c                                 ; jsr $020B38
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0454                                 ; jsr $020F52
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04e8                                 ; jsr $020FF2
    nop
    lea     $001c(sp),sp
    move.w  ($00FFA6B0).l,d0
    andi.w  #$8000,d0
    beq.b   .l20b2c
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0670                                 ; jsr $021196
    nop
    addq.l  #$4,sp
.l20b2c:                                                ; $020B2C
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    movem.l (sp)+,d2-d3
    rts
; === Translated block $020B38-$021E5E ===
; 29 functions, 4902 bytes

; ============================================================================
; InitializeRouteDisplay -- (TODO: name)
; 640 bytes | $020B38-$020DB7
; ============================================================================
InitializeRouteDisplay:
    link    a6,#-$4
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0003AB2C,a4
    movea.l  #$00FF899C,a5
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    lea     -$4(a6), a2
    clr.l   -(a7)
    pea     ($00FB).w
    pea     ($0026).w
    pea     ($0008).w
    pea     ($0010).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$021C                                 ; jsr $020DB8(pc)
    nop
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0006).w
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004120C).l
    jsr PrintfNarrow
    pea     ($0002).w
    pea     ($0006).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041208).l
    jsr PrintfNarrow
    pea     ($0003).w
    pea     ($0006).w
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$0,d3
    move.b  $1(a3), d3
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    pea     ($00041200).l
    jsr PrintfWide
    pea     ($0004).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr CalcCityCharBonus
    pea     ($0003).w
    pea     ($0012).w
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.b  $3(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000411FC).l
    jsr PrintfWide
    pea     ($0003).w
    pea     ($001B).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000411F8).l
    jsr PrintfWide
    pea     ($0004).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d4
    movea.l  #$0005F6F4,a0
    move.w  (a0,d0.w), d3
    pea     ($0010).w
    pea     ($0030).w
    pea     ($000767DE).l
    jsr DisplaySetup
    pea     ($000733F0).l
    pea     ($0006).w
    pea     ($000C).w
    pea     ($0005).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $30(a7), a7
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C7C4,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0048).w
    pea     ($0127).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    pea     ($00073480).l
    pea     ($0005).w
    pea     ($000C).w
    pea     ($0008).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    movea.l  #$0005F6F2,a0
    move.w  (a0,d4.w), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l  #$0009C7E0,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($003C).w
    pea     ($016F).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    lea     $1c(a7), a7
    cmpi.w  #$20, d2
    bcc.b   l_20dae
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$04F8                                 ; jsr $0212A2(pc)
    nop
l_20dae:
    movem.l -$20(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; RenderRouteUIElements -- (TODO: name)
; 410 bytes | $020DB8-$020F51
; ============================================================================
RenderRouteUIElements:
    movem.l d2/a2-a4, -(a7)
    move.l  $14(a7), d2
    movea.l  #$00000D64,a3
    movea.l  #$0001E044,a4
    move.l  ($000A1AEC).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0026).w
    pea     ($0101).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0017).w
    pea     ($0010).w
    pea     ($0032).w
    pea     ($0101).w
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0017).w
    pea     ($0068).w
    pea     ($0034).w
    pea     ($0109).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0017).w
    pea     ($00B0).w
    pea     ($0036).w
    pea     ($0111).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0007).w
    pea     ($00B0).w
    pea     ($0038).w
    pea     ($0119).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    cmpi.w  #$20, d2
    bge.w   l_20f4c
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.w   l_20f4c
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000D).w
    pea     ($0004).w
    jsr SetTextWindow
    pea     ($000D).w
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a2), d0
    mulu.w  #$3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041210).l
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    pea     ($0067).w
    pea     ($0008).w
    pea     ($0030).w
    pea     ($0121).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
l_20f4c:
    movem.l (a7)+, d2/a2-a4
    rts

; ============================================================================
; DisplayRouteInfo -- (TODO: name)
; 160 bytes | $020F52-$020FF1
; ============================================================================
DisplayRouteInfo:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    move.l  $10(a7), d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    move.w  d0, d2
    move.l  ($000A1AF4).l, -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($0006).w
    pea     ($01DB).w
    move.w  d2, d0
    mulu.w  #$6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF899C,a0
    pea     (a0, d0.w)
    jsr CmdPlaceTile
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    pea     ($0007).w
    pea     ($00D8).w
    pea     ($003A).w
    pea     ($01DB).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; RenderQuarterScreenGrid -- (TODO: name)
; 420 bytes | $020FF2-$021195
; ============================================================================
RenderQuarterScreenGrid:
    link    a6,#-$3C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    movea.l  #$00FF1804,a5
    move.l  ($000A1AF8).l, -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0010).w
    pea     ($01E1).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    lea     $14(a7), a7
    cmpi.w  #$20, d3
    bcc.b   l_21054
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$6,d7
    bra.b   l_21076
l_21054:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$4,d7
l_21076:
    move.w  #$640, d5
    moveq   #$D,d6
    moveq   #$5,d4
    clr.w   d3
    bra.w   l_21186
l_21084:
    cmpi.b  #$f, (a2)
    bcc.w   l_21180
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    lea     -$3c(a6), a3
    clr.w   d2
l_210bc:
    move.w  d5, d0
    add.w   d2, d0
    ori.w   #$6000, d0
    move.w  d0, (a3)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   l_210bc
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    move.b  (a4), d2
    andi.w  #$7f, d2
    cmpi.w  #$4, d2
    bge.b   l_2116e
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$18, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$1e1, d0
    move.l  d0, -(a7)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
l_2116e:
    addi.w  #$1e, d5
    addq.w  #$5, d4
    move.w  d4, d0
    cmpi.w  #$f, d0
    blt.b   l_21180
    addq.w  #$6, d6
    moveq   #$5,d4
l_21180:
    addq.l  #$1, a2
    addq.l  #$1, a4
    addq.w  #$1, d3
l_21186:
    cmp.w   d7, d3
    blt.w   l_21084
    movem.l -$64(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; InitializeRelationPanel -- (TODO: name)
; 268 bytes | $021196-$0212A1
; ============================================================================
InitializeRelationPanel:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    movea.l  #$0003B246,a4
    movea.l  #$0003AB2C,a5
    move.l  ($000A1AFC).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0047).w
    pea     ($01F1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($00071798).l
    pea     ($0003).w
    pea     ($001E).w
    pea     ($000F).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    pea     ($0011).w
    pea     ($0001).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004122A).l
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$F,d3
    clr.w   d2
l_21252:
    pea     ($000F).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041226).l
    jsr     (a4)
    pea     ($0011).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041222).l
    jsr     (a4)
    lea     $20(a7), a7
    addq.w  #$4, d3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_21252
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; DisplayRouteEvent -- (TODO: name)
; 276 bytes | $0212A2-$0213B5
; ============================================================================
DisplayRouteEvent:
    movem.l d2/a2-a3, -(a7)
    move.l  $10(a7), d2
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    movea.l  #$0005F9BE,a0
    move.b  (a0,d2.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.w   l_213b0
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0009C808,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($0030).w
    pea     ($01AB).w
    pea     ($00FF899C).l
    jsr CmdPlaceTile2
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0028).w
    pea     ($0038).w
    pea     ($000A).w
    pea     ($01AB).w
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0028).w
    pea     ($0050).w
    pea     ($000C).w
    pea     ($01B7).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $2c(a7), a7
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0048).w
    pea     ($0038).w
    pea     ($000E).w
    pea     ($01C3).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0048).w
    pea     ($0050).w
    pea     ($0010).w
    pea     ($01CF).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
l_213b0:
    movem.l (a7)+, d2/a2-a3
    rts

; ============================================================================
; GameLogic1 -- (TODO: name)
; 62 bytes | $0213B6-$0213F3
; ============================================================================
GameLogic1:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $1c(a7), a7
    dc.w    $4EBA,$0012                                 ; jsr $0213F4(pc)
    nop
    dc.w    $4EBA,$00EE                                 ; jsr $0214D6(pc)
    nop
    jsr SetupEventUI
    rts

; ============================================================================
; InitRouteFields -- (TODO: name)
; 20 bytes | $0213F4-$021407
; ============================================================================
InitRouteFields:
    dc.w    $4EBA,$0012                                 ; jsr $021408(pc)
    nop
    dc.w    $4EBA,$004A                                 ; jsr $021446(pc)
    nop
    dc.w    $4EBA,$008A                                 ; jsr $02148C(pc)
    nop
    rts

; ============================================================================
; InitRouteFieldA -- (TODO: name)
; 62 bytes | $021408-$021445
; ============================================================================
InitRouteFieldA:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09C2,a2
    clr.w   d2
l_21414:
    cmpi.b  #$ff, (a2)
    beq.b   l_21436
    tst.b   $3(a2)
    beq.b   l_21424
    subq.b  #$1, $3(a2)
l_21424:
    tst.b   $3(a2)
    bne.b   l_21436
    move.b  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0CEA                                 ; jsr $02211A(pc)
    nop
    addq.l  #$4, a7
l_21436:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_21414
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; InitRouteFieldB -- (TODO: name)
; 70 bytes | $021446-$02148B
; ============================================================================
InitRouteFieldB:
    move.l  a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21488
    tst.b   $2(a2)
    beq.b   l_21472
    clr.b   $2(a2)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
l_21472:
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.b  #$ff, (a2)
l_21488:
    movea.l (a7)+, a2
    rts

; ============================================================================
; InitRouteFieldC -- (TODO: name)
; 74 bytes | $02148C-$0214D5
; ============================================================================
InitRouteFieldC:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09CE,a2
    clr.w   d2
l_21498:
    cmpi.b  #$ff, (a2)
    beq.b   l_214b4
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.b  #$ff, (a2)
l_214b4:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_21498
    cmpi.w  #$ff, ($00FF09D6).l
    beq.b   l_214d0
    move.w  #$ff, ($00FF09D6).l
l_214d0:
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; FinalizeRouteConfig -- (TODO: name)
; 20 bytes | $0214D6-$0214E9
; ============================================================================
FinalizeRouteConfig:
    dc.w    $4EBA,$0012                                 ; jsr $0214EA(pc)
    nop
    dc.w    $4EBA,$053C                                 ; jsr $021A1A(pc)
    nop
    dc.w    $4EBA,$061E                                 ; jsr $021B02(pc)
    nop
    rts

; ============================================================================
; InitializeRoutePipeline -- (TODO: name)
; 32 bytes | $0214EA-$021509
; ============================================================================
InitializeRoutePipeline:
    dc.w    $4EBA,$001E                                 ; jsr $02150A(pc)
    nop
    dc.w    $4EBA,$016E                                 ; jsr $021660(pc)
    nop
    dc.w    $4EBA,$027A                                 ; jsr $021772(pc)
    nop
    dc.w    $4EBA,$0326                                 ; jsr $021824(pc)
    nop
    dc.w    $4EBA,$046A                                 ; jsr $02196E(pc)
    nop
    rts

; ============================================================================
; SelectActiveRoute -- (TODO: name)
; 342 bytes | $02150A-$02165F
; ============================================================================
SelectActiveRoute:
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$00FF0006,a5
    movea.l  #$0005F9DE,a3
    clr.w   d2
l_2151c:
    move.w  (a3), d0
    cmp.w   (a5), d0
    bgt.b   l_2155e
    move.w  (a5), d0
    ext.l   d0
    move.w  (a3), d1
    ext.l   d1
    addq.l  #$4, d1
    cmp.l   d1, d0
    bgt.b   l_2155e
    move.w  (a5), d0
    ext.l   d0
    move.w  (a3), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  (a7)+, d1
    cmp.l   d1, d0
    blt.b   l_21568
l_2155e:
    addq.l  #$8, a3
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_2151c
l_21568:
    cmpi.w  #$6, d2
    blt.b   l_21574
l_2156e:
    moveq   #$0,d0
    bra.w   l_2165a
l_21574:
    movea.l  #$00FF09C2,a4
    tst.b   (a4)
    beq.b   l_2156e
    cmpi.b  #$ff, (a4)
    beq.b   l_21590
    move.b  (a4), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0B90                                 ; jsr $02211A(pc)
    nop
    addq.l  #$4, a7
l_21590:
    movea.l a3, a2
    addq.l  #$3, a2
    clr.w   d3
    bra.w   l_2161a
l_2159a:
    pea     ($0002).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0A00                                 ; jsr $021FA6(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_215bc
    pea     ($0002).w
    dc.w    $4EBA,$0B64                                 ; jsr $02211A(pc)
    nop
    addq.l  #$4, a7
l_215bc:
    pea     ($0003).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$09DE                                 ; jsr $021FA6(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_215de
    pea     ($0003).w
    dc.w    $4EBA,$0B42                                 ; jsr $02211A(pc)
    nop
    addq.l  #$4, a7
l_215de:
    pea     ($0004).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$09BC                                 ; jsr $021FA6(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_21600
    pea     ($0004).w
    dc.w    $4EBA,$0B20                                 ; jsr $02211A(pc)
    nop
    addq.l  #$4, a7
l_21600:
    move.b  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0D54                                 ; jsr $02235A(pc)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21616
    dc.w    $4EBA,$0D9A                                 ; jsr $0223AC(pc)
    nop
l_21616:
    addq.l  #$1, a2
    addq.w  #$1, d3
l_2161a:
    cmpi.w  #$5, d3
    bge.b   l_21628
    cmpi.b  #$ff, (a2)
    bne.w   l_2159a
l_21628:
    clr.b   (a4)
    move.b  d2, $1(a4)
    move.b  $1(a5), $2(a4)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr RandRange
    addq.l  #$8, a7
    add.b   $1(a3), d0
    sub.b   $1(a5), d0
    addq.b  #$4, d0
    move.b  d0, $3(a4)
    moveq   #$1,d0
l_2165a:
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; ProcessRouteOptionB -- (TODO: name)
; 274 bytes | $021660-$021771
; ============================================================================
ProcessRouteOptionB:
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$0002211A,a3
    movea.l  #$00021FD4,a4
    movea.l  #$0005FA0E,a5
    movea.l  #$00FF09C2,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21688
l_21682:
    moveq   #$0,d0
    bra.w   l_2176c
l_21688:
    pea     ($003F).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21682
    pea     ($0006).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $3(a5, a0.l), d0
    andi.l  #$ff, d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    pea     ($0002).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    tst.w   d0
    beq.b   l_216e2
    pea     ($0002).w
    jsr     (a3)
    addq.l  #$4, a7
l_216e2:
    pea     ($0003).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_216fa
    pea     ($0003).w
    jsr     (a3)
    addq.l  #$4, a7
l_216fa:
    pea     ($0004).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_21712
    pea     ($0004).w
    jsr     (a3)
    addq.l  #$4, a7
l_21712:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $3(a5, a0.l), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0C38                                 ; jsr $02235A(pc)
    nop
    tst.w   d0
    beq.b   l_21730
    dc.w    $4EBA,$0C80                                 ; jsr $0223AC(pc)
    nop
l_21730:
    move.b  #$1, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $2(a5, a0.l), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr RandRange
    lea     $c(a7), a7
    addq.b  #$1, d0
    move.b  d0, $3(a2)
    moveq   #$1,d0
l_2176c:
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; MatchRouteOption -- (TODO: name)
; 178 bytes | $021772-$021823
; ============================================================================
MatchRouteOption:
    movem.l d2-d3/a2-a3, -(a7)
    movea.l  #$00021FA6,a3
    movea.l  #$0005FA2A,a2
    clr.w   d2
    move.w  ($00FF0006).l, d3
l_2178a:
    cmp.w   (a2), d3
    beq.b   l_21798
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$11, d2
    blt.b   l_2178a
l_21798:
    cmpi.w  #$11, d2
    blt.b   l_217a2
l_2179e:
    moveq   #$0,d0
    bra.b   l_2181e
l_217a2:
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0DAC                                 ; jsr $022554(pc)
    nop
    move.w  d0, d3
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_2179e
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_2179e
    pea     ($0003).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_217ea
    pea     ($0003).w
    dc.w    $4EBA,$0936                                 ; jsr $02211A(pc)
    nop
    addq.l  #$4, a7
l_217ea:
    move.b  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0B6A                                 ; jsr $02235A(pc)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21800
    dc.w    $4EBA,$0BB0                                 ; jsr $0223AC(pc)
    nop
l_21800:
    movea.l  #$00FF09C6,a2
    move.b  #$4, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    move.b  #$1, $3(a2)
    moveq   #$1,d0
l_2181e:
    movem.l (a7)+, d2-d3/a2-a3
    rts

; ============================================================================
; ProcessRouteOptionC -- (TODO: name)
; 330 bytes | $021824-$02196D
; ============================================================================
ProcessRouteOptionC:
    movem.l d2-d4/a2-a5, -(a7)
    movea.l  #$0001D6A4,a5
    movea.l  #$00FF09C6,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21840
l_2183a:
    moveq   #$0,d0
    bra.w   l_21968
l_21840:
    pea     ($0006).w
    clr.l   -(a7)
    jsr     (a5)
    move.w  d0, d2
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0782                                 ; jsr $021FD4(pc)
    nop
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_21840
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$076C                                 ; jsr $021FD4(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_21840
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $1(a2), d4
    add.b   $3(a2), d4
    addi.b  #$ff, d4
    andi.l  #$ff, d4
    clr.w   d3
l_21896:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d2, d0
    ble.b   l_218b6
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d2
    bra.b   l_218ca
l_218b6:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d2, d1
    sub.w   d0, d1
    moveq   #$0,d0
    move.b  $2(a2), d0
    add.w   d0, d1
    move.w  d1, d2
l_218ca:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    addi.l  #$a, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF1298,a0
    lea     (a0,d1.w), a0
    movea.l a0, a3
    addq.l  #$2, a0
    movea.l a0, a4
    move.b  (a0), d1
    andi.l  #$ff, d1
    ext.l   d1
    cmp.l   d1, d0
    bgt.b   l_2190a
    move.b  (a4), d0
    cmp.b   $3(a3), d0
    bcc.b   l_21912
l_2190a:
    addq.w  #$1, d3
    cmpi.w  #$a, d3
    blt.b   l_21896
l_21912:
    cmpi.w  #$a, d3
    bge.w   l_2183a
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    tst.l   d0
    beq.w   l_2183a
    move.b  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0A2A                                 ; jsr $02235A(pc)
    nop
    tst.w   d0
    beq.b   l_2193e
    dc.w    $4EBA,$0A72                                 ; jsr $0223AC(pc)
    nop
l_2193e:
    movea.l  #$00FF09C6,a2
    move.b  #$3, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    pea     ($0004).w
    pea     ($0002).w
    jsr     (a5)
    lea     $c(a7), a7
    move.b  d0, $3(a2)
    moveq   #$1,d0
l_21968:
    movem.l (a7)+, d2-d4/a2-a5
    rts

; ============================================================================
; ProcessRouteOptionD -- (TODO: name)
; 172 bytes | $02196E-$021A19
; ============================================================================
ProcessRouteOptionD:
    movem.l d2/a2-a3, -(a7)
    movea.l  #$0001D6A4,a3
    movea.l  #$00FF09C6,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_2198a
l_21984:
    moveq   #$0,d0
    bra.w   l_21a14
l_2198a:
    pea     ($0007).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21984
l_21998:
    pea     ($0006).w
    clr.l   -(a7)
    jsr     (a3)
    move.w  d0, d2
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$062A                                 ; jsr $021FD4(pc)
    nop
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_21998
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0614                                 ; jsr $021FD4(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_21998
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    move.b  (a0,d0.w), d1
    move.l  d1, -(a7)
    dc.w    $4EBA,$097E                                 ; jsr $02235A(pc)
    nop
    tst.w   d0
    beq.b   l_219ea
    dc.w    $4EBA,$09C6                                 ; jsr $0223AC(pc)
    nop
l_219ea:
    movea.l  #$00FF09C6,a2
    move.b  #$2, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    pea     ($0004).w
    pea     ($0002).w
    jsr     (a3)
    lea     $c(a7), a7
    move.b  d0, $3(a2)
    moveq   #$1,d0
l_21a14:
    movem.l (a7)+, d2/a2-a3
    rts

; ============================================================================
; FinalizeCandidateRoutes -- (TODO: name)
; 14 bytes | $021A1A-$021A27
; ============================================================================
FinalizeCandidateRoutes:
    dc.w    $4EBA,$000C                                 ; jsr $021A28(pc)
    nop
    dc.w    $4EBA,$0072                                 ; jsr $021A94(pc)
    nop
    rts

; ============================================================================
; InitRouteFieldA2 -- (TODO: name)
; 108 bytes | $021A28-$021A93
; ============================================================================
InitRouteFieldA2:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21a3c
l_21a38:
    moveq   #$0,d0
    bra.b   l_21a8e
l_21a3c:
    pea     ($000F).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21a38
    pea     ($001F).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    pea     ($0005).w
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0540                                 ; jsr $021FA6(pc)
    nop
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_21a38
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0A34                                 ; jsr $0224AC(pc)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21a38
    clr.b   (a2)
    move.b  d2, $1(a2)
    clr.b   $2(a2)
    moveq   #$1,d0
l_21a8e:
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; InitRouteFieldB2 -- (TODO: name)
; 110 bytes | $021A94-$021B01
; ============================================================================
InitRouteFieldB2:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21aa8
l_21aa4:
    moveq   #$0,d0
    bra.b   l_21afc
l_21aa8:
    pea     ($0007).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21aa4
    pea     ($0058).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    pea     ($0005).w
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$04D4                                 ; jsr $021FA6(pc)
    nop
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_21aa4
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$09C8                                 ; jsr $0224AC(pc)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21aa4
    move.b  #$1, (a2)
    move.b  d2, $1(a2)
    clr.b   $2(a2)
    moveq   #$1,d0
l_21afc:
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; FinalizeRouteSelection -- (TODO: name)
; 14 bytes | $021B02-$021B0F
; ============================================================================
FinalizeRouteSelection:
    dc.w    $4EBA,$000C                                 ; jsr $021B10(pc)
    nop
    dc.w    $4EBA,$02D8                                 ; jsr $021DE2(pc)
    nop
    rts

; ============================================================================
; InitRouteFieldC2 -- (TODO: name)
; 140 bytes | $021B10-$021B9B
; ============================================================================
InitRouteFieldC2:
    link    a6,#-$8
    movem.l d2-d3/a2-a3, -(a7)
    lea     -$8(a6), a3
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    clr.w   d2
l_21b30:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a3,a0.l)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_21b30
    movea.l  #$00FF09CE,a2
    clr.w   d3
    clr.w   d2
l_21b58:
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    pea     (a2, d0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a3,a0.l), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0026                                 ; jsr $021B9C(pc)
    nop
    lea     $c(a7), a7
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_21b58
    tst.w   d3
    ble.b   l_21b90
    moveq   #$1,d0
    bra.b   l_21b92
l_21b90:
    moveq   #$0,d0
l_21b92:
    movem.l -$18(a6), d2-d3/a2-a3
    unlk    a6
    rts

; ============================================================================
; EvaluateTurnAvailability -- (TODO: name)
; 256 bytes | $021B9C-$021C9B
; ============================================================================
EvaluateTurnAvailability:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d6
    movea.l $10(a6), a2
    tst.w   $e(a6)
    bgt.b   l_21bb8
l_21bb2:
    moveq   #$0,d0
    bra.w   l_21c92
l_21bb8:
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d7
    move.b  $4(a3), d7
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d7
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00BE                                 ; jsr $021C9C(pc)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21bb2
    clr.w   d5
    clr.w   d4
    bra.w   l_21c88
l_21bf0:
    cmp.w   d7, d5
    bge.w   l_21c90
l_21bf6:
    move.w  d7, d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d3
    clr.w   d2
    bra.b   l_21c1e
l_21c0e:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    move.w  -$4(a6, d0.l), d0
    cmp.w   d3, d0
    beq.b   l_21c22
    addq.w  #$1, d2
l_21c1e:
    cmp.w   d4, d2
    blt.b   l_21c0e
l_21c22:
    cmp.w   d4, d2
    blt.b   l_21bf6
    move.w  d6, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    moveq   #$2,d1
    cmp.l   d0, d1
    beq.b   l_21c86
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$009C                                 ; jsr $021CF0(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_21c86
    dc.w    $4EBA,$012A                                 ; jsr $021D8A(pc)
    nop
    tst.w   d0
    beq.b   l_21c6c
    clr.b   (a2)
    bra.b   l_21c70
l_21c6c:
    move.b  #$1, (a2)
l_21c70:
    move.b  d6, $1(a2)
    move.b  d3, $2(a2)
    addq.l  #$4, a2
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
    move.w  d3, -$4(a6, d0.l)
    addq.w  #$1, d4
l_21c86:
    addq.w  #$1, d5
l_21c88:
    cmp.w   $e(a6), d5
    blt.w   l_21bf0
l_21c90:
    move.w  d4, d0
l_21c92:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ============================================================================
; CalculateTurnCapacity -- (TODO: name)
; 84 bytes | $021C9C-$021CEF
; ============================================================================
CalculateTurnCapacity:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    cmpi.w  #$14, d2
    bge.b   l_21cb0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_21cb2
l_21cb0:
    moveq   #$14,d0
l_21cb2:
    move.w  ($00FF0006).l, d1
    andi.l  #$3, d1
    moveq   #$3,d3
    cmp.l   d1, d3
    bne.b   l_21cc8
    moveq   #$A,d1
    bra.b   l_21cca
l_21cc8:
    moveq   #$0,d1
l_21cca:
    add.w   d1, d0
    move.w  d0, d2
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bge.b   l_21ce8
    moveq   #$1,d0
    bra.b   l_21cea
l_21ce8:
    moveq   #$0,d0
l_21cea:
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; CheckCharAvailability -- (TODO: name)
; 154 bytes | $021CF0-$021D89
; ============================================================================
CheckCharAvailability:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d2
    move.l  $18(a7), d4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  $1(a2), d3
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d4, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.l  a2, -(a7)
    jsr GetByteField4
    mulu.w  #$c, d0
    movea.l  #$00FFA6C1,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$64,d2
    sub.w   d0, d2
    pea     ($00C8).w
    pea     ($0032).w
    move.w  d3, d0
    add.w   d2, d0
    addi.w  #$fffb, d0
    move.l  d0, -(a7)
    jsr MulDiv
    move.w  d0, d2
    pea     ($0032).w
    clr.l   -(a7)
    jsr RandRange
    lea     $18(a7), a7
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_21d82
    moveq   #$1,d0
    bra.b   l_21d84
l_21d82:
    moveq   #$0,d0
l_21d84:
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; CheckTurnTiming -- (TODO: name)
; 88 bytes | $021D8A-$021DE1
; ============================================================================
CheckTurnTiming:
    move.l  d2, -(a7)
    move.w  ($00FFA6B2).l, d0
    ext.l   d0
    moveq   #$3C,d2
    sub.l   d0, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    add.l   d0, d2
    moveq   #$A,d0
    cmp.l   d2, d0
    bge.b   l_21dc0
    move.w  ($00FFA6B2).l, d0
    ext.l   d0
    moveq   #$3C,d2
    sub.l   d0, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    add.l   d0, d2
    bra.b   l_21dc2
l_21dc0:
    moveq   #$A,d2
l_21dc2:
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bge.b   l_21ddc
    moveq   #$1,d0
    bra.b   l_21dde
l_21ddc:
    moveq   #$0,d0
l_21dde:
    move.l  (a7)+, d2
    rts

; ============================================================================
; ProcessTurnCheckpoint -- (TODO: name)
; 58 bytes | $021DE2-$021E1B
; ============================================================================
ProcessTurnCheckpoint:
    move.l  d2, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    move.l  d0, -(a7)
    dc.w    $4EBA,$05F4                                 ; jsr $0223EA(pc)
    nop
    addq.l  #$4, a7
    move.l  d0, -(a7)
    dc.w    $4EBA,$001C                                 ; jsr $021E1C(pc)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_21e10
    moveq   #$0,d0
    bra.b   l_21e18
l_21e10:
    move.w  d2, ($00FF09D6).l
    moveq   #$1,d0
l_21e18:
    move.l  (a7)+, d2
    rts

; ============================================================================
; ValidateTurnDelay -- (TODO: name)
; 66 bytes | $021E1C-$021E5D
; ============================================================================
ValidateTurnDelay:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    move.w  d2, d0
    ext.l   d0
    subi.l  #$5a, d0
    ble.b   l_21e3a
    move.w  d2, d0
    ext.l   d0
    subi.l  #$5a, d0
    bra.b   l_21e3c
l_21e3a:
    moveq   #$0,d0
l_21e3c:
    move.w  d0, d2
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_21e58
    moveq   #$1,d0
    bra.b   l_21e5a
l_21e58:
    moveq   #$0,d0
l_21e5a:
    move.l  (a7)+, d2
    rts

ProcessTradeAction:                                                  ; $021E5E
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0020(sp),d4
    movea.l $0028(sp),a3
    movea.l $0024(sp),a4
    moveq   #$0,d2
    move.b  (a4),d2
    moveq   #$0,d3
    move.b  (a3),d3
    movea.l #$00ff09c2,a2
    clr.w   d5
    moveq   #$0,d0
    move.b  (a2),d0
    moveq   #$4,d1
    cmp.l   d1,d0
    dc.w    $6200,$00ac                                 ; bhi.w $021F34
    add.l   d0,d0
    move.w  $21e94(pc,d0.l),d0
    jmp     $21e94(pc,d0.w)
    ; WARNING: 274 undecoded trailing bytes at $021E94
    dc.w    $000a
    dc.w    $0042
    dc.w    $005a
    dc.w    $007e
    dc.w    $0084
    dc.w    $1004
    dc.w    $2f00
    dc.w    $4878
    dc.w    $0005
    dc.w    $7000
    dc.w    $102a
    dc.w    $0001
    dc.w    $e748
    dc.w    $207c
    dc.w    $0005
    dc.w    $f9e1
    dc.w    $4870
    dc.w    $0000
    dc.w    $4eba
    dc.w    $05c6
    dc.w    $4e71
    dc.w    $4fef
    dc.w    $000c
    dc.w    $4a40
    dc.w    $676e
    dc.w    $7401
    dc.w    $3003
    dc.w    $48c0
    dc.w    $6c02
    dc.w    $5280
    dc.w    $e280
    dc.w    $3600
    dc.w    $605e
    dc.w    $7000
    dc.w    $102a
    dc.w    $0001
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $fa11
    dc.w    $1030
    dc.w    $0000
    dc.w    $b004
    dc.w    $6648
    dc.w    $60d8
    dc.w    $7000
    dc.w    $1004
    dc.w    $0280
    dc.w    $0000
    dc.w    $ffff
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $d648
    dc.w    $588f
    dc.w    $7200
    dc.w    $122a
    dc.w    $0001
    dc.w    $b041
    dc.w    $6628
    dc.w    $0642
    dc.w    $0019
    dc.w    $6022
    dc.w    $b82a
    dc.w    $0001
    dc.w    $6016
    dc.w    $7000
    dc.w    $102a
    dc.w    $0001
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0632
    dc.w    $4e71
    dc.w    $588f
    dc.w    $7200
    dc.w    $1204
    dc.w    $b041
    dc.w    $6604
    dc.w    $7464
    dc.w    $7664
    dc.w    $588a
    dc.w    $5245
    dc.w    $0c45
    dc.w    $0002
    dc.w    $6d00
    dc.w    $ff40
    dc.w    $247c
    dc.w    $00ff
    dc.w    $09ca
    dc.w    $4a12
    dc.w    $6616
    dc.w    $b82a
    dc.w    $0001
    dc.w    $6610
    dc.w    $7000
    dc.w    $102a
    dc.w    $0002
    dc.w    $9440
    dc.w    $7000
    dc.w    $102a
    dc.w    $0002
    dc.w    $9640
    dc.w    $0c42
    dc.w    $0001
    dc.w    $6f06
    dc.w    $3002
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7001
    dc.w    $3400
    dc.w    $0c42
    dc.w    $0064
    dc.w    $6c06
    dc.w    $3002
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7064
    dc.w    $1880
    dc.w    $0c43
    dc.w    $0001
    dc.w    $6f06
    dc.w    $3003
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7001
    dc.w    $3600
    dc.w    $0c43
    dc.w    $0064
    dc.w    $6c06
    dc.w    $3003
    dc.w    $48c0
    dc.w    $6002
    dc.w    $7064
    dc.w    $1680
    dc.w    $4cdf
    dc.w    $1c3c
    dc.w    $4e75
; === Translated block $021FA6-$021FD4 ===
; 1 functions, 46 bytes

; ============================================================================
; CheckEventCondition -- (TODO: name)
; 46 bytes | $021FA6-$021FD3
; ============================================================================
CheckEventCondition:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    dc.w    $4EBA,$000C                                 ; jsr $021FD4(pc)
    nop
    addq.l  #$8, a7
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; CheckEventMatch -- (TODO: describe)
; Called: ?? times.
; 310 bytes | $021FD4-$022109
; ============================================================================
CheckEventMatch:                                                  ; $021FD4
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0024(sp),d2
    move.l  $0020(sp),d4
    movea.l #$d648,a4
    movea.l #$00ff09c2,a2
    clr.w   d5
    cmpi.b  #$ff,(a2)
    beq.w   .l22106
    cmpi.w  #$5,d2
    beq.b   .l22006
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d2,d0
    bne.w   .l22106
.l22006:                                                ; $022006
    tst.w   d2
    beq.b   .l22010
    cmpi.w  #$5,d2
    bne.b   .l22058
.l22010:                                                ; $022010
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$3,d0
    movea.l #$0005f9e1,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.w   d3
    bra.b   .l2204c
.l22028:                                                ; $022028
    moveq   #$0,d0
    move.b  (a3),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    bne.b   .l22048
.l22042:                                                ; $022042
    moveq   #$1,d0
    dc.w    $6000,$00ce                                 ; bra.w $022114
.l22048:                                                ; $022048
    addq.l  #$1,a3
    addq.w  #$1,d3
.l2204c:                                                ; $02204C
    cmpi.w  #$5,d3
    bge.b   .l22058
    cmpi.b  #$ff,(a3)
    bne.b   .l22028
.l22058:                                                ; $022058
    cmpi.w  #$1,d2
    beq.b   .l22064
    cmpi.w  #$5,d2
    bne.b   .l22092
.l22064:                                                ; $022064
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005fa11,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    beq.b   .l22042
.l22092:                                                ; $022092
    cmpi.w  #$2,d2
    beq.b   .l2209e
    cmpi.w  #$5,d2
    bne.b   .l220a8
.l2209e:                                                ; $02209E
    moveq   #$0,d0
    move.b  $0001(a2),d0
    cmp.w   d4,d0
    beq.b   .l22042
.l220a8:                                                ; $0220A8
    cmpi.w  #$3,d2
    beq.b   .l220b4
    cmpi.w  #$5,d2
    bne.b   .l220d2
.l220b4:                                                ; $0220B4
    moveq   #$0,d0
    move.b  $0001(a2),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    beq.w   .l22042
.l220d2:                                                ; $0220D2
    cmpi.w  #$4,d2
    beq.b   .l220de
    cmpi.w  #$5,d2
    bne.b   .l22106
.l220de:                                                ; $0220DE
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eba,$046c                                 ; jsr $022554
    nop
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    beq.w   .l22042
.l22106:                                                ; $022106
    addq.l  #$4,a2
    addq.w  #$1,d5
    dc.w    $0C45,$0002,$6D00                                ; $02210A
; === Translated block $022110-$022554 ===
; 8 functions, 1092 bytes

; ============================================================================
; StubCodeFragment -- (TODO: name)
; 10 bytes | $022110-$022119
; ============================================================================
StubCodeFragment:
    dc.w    $FEDE
    moveq   #$0,d0
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; ProcessEventState -- (TODO: name)
; 576 bytes | $02211A-$022359
; ============================================================================
ProcessEventState:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$000181C6,a4
    lea     -$80(a6), a5
    movea.l  #$00FF09C2,a3
    clr.w   d2
l_22138:
    cmp.b   (a3), d5
    beq.b   l_22146
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_22138
l_22146:
    cmpi.w  #$2, d2
    bge.w   l_22350
    tst.b   (a3)
    bne.w   l_2220e
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$3, d0
    movea.l  #$0005F9DE,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    addq.l  #$3, a2
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047DC0).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $28(a7), a7
    move.b  #$ff, (a3)
    clr.w   d2
    bra.b   l_221fc
l_221da:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    andi.b  #$fe, (a0,d0.w)
    addq.l  #$1, a2
    addq.w  #$1, d2
l_221fc:
    cmpi.b  #$ff, (a2)
    beq.w   l_22350
    cmpi.w  #$5, d2
    blt.b   l_221da
    bra.w   l_22350
l_2220e:
    cmpi.b  #$2, (a3)
    bne.w   l_2229e
    move.b  $1(a3), d5
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.b  #$ff, (a3)
    moveq   #$0,d0
    move.b  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  (a2), d3
    moveq   #$0,d4
    move.b  $1(a2), d4
    clr.w   d2
    bra.b   l_22260
l_2224e:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    addq.b  #$1, d3
    addq.w  #$1, d2
l_22260:
    cmp.w   d4, d2
    blt.b   l_2224e
    moveq   #$0,d0
    move.b  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $2(a2), d3
    moveq   #$0,d4
    move.b  $3(a2), d4
    clr.w   d2
    bra.b   l_22296
l_22284:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    addq.b  #$1, d3
    addq.w  #$1, d2
l_22296:
    cmp.w   d4, d2
    blt.b   l_22284
    bra.w   l_22350
l_2229e:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    cmp.b   d1, d0
    beq.b   l_222b8
    moveq   #$3,d1
    cmp.b   d1, d0
    beq.b   l_2231a
    moveq   #$4,d1
    cmp.b   d1, d0
    beq.b   l_22320
    bra.w   l_22350
l_222b8:
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d3
    moveq   #$0,d0
    move.b  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047DF0).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    jsr ClearListArea
    moveq   #$0,d0
    move.b  d3, d0
    movea.l  #$00FF09D8,a0
    andi.b  #$fd, (a0,d0.w)
    bra.b   l_22332
l_2231a:
    move.b  $1(a3), d3
    bra.b   l_22332
l_22320:
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$022A                                 ; jsr $022554(pc)
    nop
    addq.l  #$4, a7
    move.b  d0, d3
l_22332:
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    move.b  #$ff, (a3)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
l_22350:
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; CheckRouteEventMatch -- (TODO: name)
; 82 bytes | $02235A-$0223AB
; ============================================================================
CheckRouteEventMatch:
    movem.l d2/a2, -(a7)
    move.l  $c(a7), d2
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_223a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  d2, d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  (a7)+, d1
    cmp.w   d1, d0
    bne.b   l_223a4
    moveq   #$1,d0
    bra.b   l_223a6
l_223a4:
    moveq   #$0,d0
l_223a6:
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; FinalizeRouteEvent -- (TODO: name)
; 62 bytes | $0223AC-$0223E9
; ============================================================================
FinalizeRouteEvent:
    move.l  a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_223e6
    clr.b   $2(a2)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $14(a7), a7
    move.b  #$ff, (a2)
l_223e6:
    movea.l (a7)+, a2
    rts

; ============================================================================
; AggregateCharAvailability -- (TODO: name)
; 114 bytes | $0223EA-$02245B
; ============================================================================
AggregateCharAvailability:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $4(a2), d4
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d4
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    clr.w   d2
    bra.b   l_2243c
l_2242a:
    move.l  a2, -(a7)
    dc.w    $4EBA,$002E                                 ; jsr $02245C(pc)
    nop
    addq.l  #$4, a7
    add.w   d0, d3
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_2243c:
    cmp.w   d4, d2
    bcs.b   l_2242a
    tst.w   d4
    bne.b   l_22448
    moveq   #$0,d0
    bra.b   l_22456
l_22448:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr SignedDiv
l_22456:
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; CalcCharMorale -- (TODO: name)
; 36 bytes | $02245C-$02247F
; ============================================================================
CalcCharMorale:
    movea.l $4(a7), a0
    moveq   #$0,d0
    move.b  $b(a0), d0
    move.l  d0, -(a7)
    pea     ($0064).w
    moveq   #$0,d0
    move.b  $3(a0), d0
    move.l  d0, -(a7)
    jsr MulDiv
    lea     $c(a7), a7
    rts

; ============================================================================
; LinearByteSearch -- (TODO: name)
; 44 bytes | $022480-$0224AB
; ============================================================================
LinearByteSearch:
    movem.l d2-d3, -(a7)
    move.l  $14(a7), d3
    move.l  $10(a7), d1
    movea.l $c(a7), a0
    clr.w   d2
    bra.b   l_224a0
l_22494:
    cmp.b   (a0), d3
    bne.b   l_2249c
    moveq   #$1,d0
    bra.b   l_224a6
l_2249c:
    addq.l  #$1, a0
    addq.w  #$1, d2
l_224a0:
    cmp.w   d1, d2
    bcs.b   l_22494
    moveq   #$0,d0
l_224a6:
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; CheckAirRouteAvail -- (TODO: name)
; 168 bytes | $0224AC-$022553
; ============================================================================
CheckAirRouteAvail:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
    movea.l  #$00FF0018,a2
    clr.w   d2
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d5
    bra.b   l_22546
l_224dc:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_2250a
    moveq   #$0,d0
    move.b  $4(a2), d0
    moveq   #$0,d1
    move.b  $5(a2), d1
    add.l   d1, d0
    ble.b   l_22540
l_22506:
    moveq   #$1,d0
    bra.b   l_2254e
l_2250a:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  d5, d1
    andi.l  #$ffff, d1
    sub.l   d1, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    mulu.w  #$e, d1
    move.w  d4, d6
    add.w   d6, d6
    add.w   d6, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
    bne.b   l_22506
l_22540:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_22546:
    cmpi.w  #$4, d2
    blt.b   l_224dc
    moveq   #$0,d0
l_2254e:
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; CalcEventValue -- (TODO: describe)
; Called: ?? times.
; 100 bytes | $022554-$0225B7
; ============================================================================
CalcEventValue:                                                  ; $022554
    movem.l d2-d4/a2,-(sp)
    move.l  $0014(sp),d4
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005fa2a,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    cmpi.b  #$ff,$0002(a2)
    beq.b   .l2257c
    moveq   #$0,d0
    move.b  $0002(a2),d0
    bra.b   .l225b2
.l2257c:                                                ; $02257C
    movea.l #$00ff0018,a2
    clr.w   d3
    clr.w   d2
.l22586:                                                ; $022586
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d3
    moveq   #$24,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l22586
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,d1
    lsl.l   #$3,d0
    sub.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    moveq   #$20,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
.l225b2:                                                ; $0225B2
    movem.l (sp)+,d2-d4/a2
    rts
; ============================================================================
; SetupEventUI -- (TODO: describe)
; Called: ?? times.
; 84 bytes | $0225B8-$02260B
; ============================================================================
SetupEventUI:                                                  ; $0225B8
    move.l  a2,-(sp)
    movea.l #$0002260c,a2
    dc.w    $4eba,$1166                                 ; jsr $023728
    nop
    cmpi.w  #$1,d0
    bne.b   .l225dc
    pea     ($0001).w
    pea     ($0010).w
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    addq.l  #$8,sp
.l225dc:                                                ; $0225DC
    clr.l   -(sp)
    jsr     (a2)
    pea     ($0001).w
    jsr     (a2)
    dc.w    $4eba,$0722                                 ; jsr $022D0A
    nop
    dc.w    $4eba,$09da                                 ; jsr $022FC8
    nop
    pea     ($0004).w
    jsr     (a2)
    pea     ($0002).w
    jsr     (a2)
    pea     ($0003).w
    jsr     (a2)
    lea     $0014(sp),sp
    movea.l (sp)+,a2
    rts
    dc.w    $48E7,$3020                                      ; $02260C

; === Translated block $022610-$0232B6 ===
; 8 functions, 3238 bytes

; ============================================================================
; DispatchRouteEvent -- (TODO: name)
; 114 bytes | $022610-$022681
; ============================================================================
DispatchRouteEvent:
    move.l  $10(a7), d3
    movea.l  #$00FF09C2,a2
    clr.w   d2
l_2261c:
    cmp.b   (a2), d3
    bne.b   l_22672
    moveq   #$0,d0
    move.b  d3, d0
    ext.l   d0
    moveq   #$4,d1
    cmp.l   d1, d0
    bhi.b   l_22672
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000A
    dc.w    $0014
    dc.w    $001E
    dc.w    $0028
    dc.w    $0032
    move.l  a2, -(a7)
    dc.w    $4EBA,$003E                                 ; jsr $022682(pc)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    dc.w    $4EBA,$02D8                                 ; jsr $022926(pc)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    dc.w    $4EBA,$04FE                                 ; jsr $022B56(pc)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    dc.w    $4EBA,$05E4                                 ; jsr $022C46(pc)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    dc.w    $4EBA,$0410                                 ; jsr $022A7C(pc)
    nop
l_22670:
    addq.l  #$4, a7
l_22672:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_2261c
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; HandleRouteEventType0 -- (TODO: name)
; 676 bytes | $022682-$022925
; ============================================================================
HandleRouteEventType0:
    link    a6,#-$C0
    movem.l d2/a2-a5, -(a7)
    movea.l $8(a6), a2
    lea     -$80(a6), a4
    movea.l  #$0003B22C,a5
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    movea.l  #$0005F9DE,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    jsr RunTransitionSteps
    pea     ($0005).w
    move.l  a3, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    pea     ($0002).w
    jsr InitInfoPanel
    lea     $c(a7), a7
    moveq   #$0,d0
    move.b  $2(a2), d0
    cmp.w   ($00FF0006).l, d0
    bne.w   l_2285c
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047E22).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    dc.w    $4EBA,$107C                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    movea.l a3, a0
    addq.l  #$4, a0
    movea.l a0, a2
    cmpi.b  #$ff, (a0)
    bne.b   l_22750
    moveq   #$0,d0
    move.b  $3(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$c0(a6)
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   l_227a6
l_22750:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $3(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004130C).l
    pea     -$c0(a6)
    jsr     (a5)
    lea     $10(a7), a7
l_227a6:
    pea     -$c0(a6)
    pea     ($00047E3E).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    dc.w    $4EBA,$0FC4                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    movea.l a3, a2
    addq.l  #$3, a2
    clr.w   d2
    bra.b   l_227fc
l_227d6:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    ori.b   #$1, (a0,d0.w)
    addq.l  #$1, a2
    addq.w  #$1, d2
l_227fc:
    cmpi.w  #$5, d2
    bge.b   l_22808
    cmpi.b  #$ff, (a2)
    bne.b   l_227d6
l_22808:
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$0B62                                 ; jsr $023386(pc)
    nop
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    lea     $10(a7), a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $2(a3), d0
    move.l  d0, -(a7)
    movea.w d2, a0
    move.b  $3(a3, a0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0C3A                                 ; jsr $023490(pc)
    nop
    bra.b   l_228da
l_2285c:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047E5C).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    dc.w    $4EBA,$0F00                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    clr.l   -(a7)
    pea     ($0002).w
    jsr CheckEventMatch
    lea     $20(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_228dc
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047E98).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    dc.w    $4EBA,$0EB8                                 ; jsr $02377C(pc)
    nop
    lea     $10(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
l_228da:
    addq.l  #$8, a7
l_228dc:
    dc.w    $4EBA,$0ECA                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    pea     ($0005).w
    move.l  a3, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    jsr UpdateIfActive
    clr.l   -(a7)
    pea     ($0002).w
    jsr CheckEventMatch
    lea     $10(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_2291c
    move.w  #$64, ($00FF1294).l
l_2291c:
    movem.l -$d4(a6), d2/a2-a5
    unlk    a6
    rts

; ============================================================================
; HandleRouteEventType1 -- (TODO: name)
; 342 bytes | $022926-$022A7B
; ============================================================================
HandleRouteEventType1:
    link    a6,#-$80
    movem.l a2-a4, -(a7)
    movea.l $8(a6), a3
    lea     -$80(a6), a4
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA0E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr RunTransitionSteps
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    pea     ($0003).w
    jsr InitInfoPanel
    lea     $c(a7), a7
    moveq   #$0,d0
    move.b  $2(a3), d0
    cmp.w   ($00FF0006).l, d0
    bne.w   l_22a16
    moveq   #$0,d0
    move.b  $3(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047ECE).l
    move.l  a4, -(a7)
    jsr sprintf
    move.l  a4, -(a7)
    dc.w    $4EBA,$0DDA                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    moveq   #$0,d0
    move.b  $3(a2), d0
    movea.l  #$00FF09D8,a0
    ori.b   #$2, (a0,d0.w)
    moveq   #$0,d0
    move.b  $3(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    pea     ($0001).w
    dc.w    $4EBA,$0990                                 ; jsr $023386(pc)
    nop
    lea     $28(a7), a7
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0A80                                 ; jsr $023490(pc)
    nop
    bra.b   l_22a50
l_22a16:
    moveq   #$0,d0
    move.b  $3(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047EEC).l
    move.l  a4, -(a7)
    jsr sprintf
    move.l  a4, -(a7)
    dc.w    $4EBA,$0D42                                 ; jsr $02377C(pc)
    nop
    lea     $10(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
l_22a50:
    dc.w    $4EBA,$0D56                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    jsr UpdateIfActive
    movem.l -$8c(a6), a2-a4
    unlk    a6
    rts

; ============================================================================
; HandleAirlineRouteEvent -- (TODO: name)
; 218 bytes | $022A7C-$022B55
; ============================================================================
HandleAirlineRouteEvent:
    link    a6,#-$84
    movem.l d2/a2-a3, -(a7)
    movea.l $8(a6), a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA2A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    jsr CalcEventValue
    move.w  d0, d2
    move.b  d2, -$81(a6)
    pea     ($0001).w
    pea     -$81(a6)
    jsr AnimateInfoPanel
    cmpi.b  #$3b, $2(a2)
    beq.b   l_22aca
    moveq   #$5,d0
    bra.b   l_22acc
l_22aca:
    moveq   #$6,d0
l_22acc:
    move.l  d0, -(a7)
    jsr InitInfoPanel
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.b  #$3b, $2(a2)
    beq.b   l_22af2
    pea     ($00047FB8).l
    bra.b   l_22af8
l_22af2:
    pea     ($00047FC2).l
l_22af8:
    pea     ($00047F70).l
    pea     -$80(a6)
    jsr sprintf
    pea     -$80(a6)
    dc.w    $4EBA,$0C6E                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $2c(a7), a7
    dc.w    $4EBA,$0C82                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    pea     ($0001).w
    pea     -$81(a6)
    jsr PlaceItemTiles
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    movem.l -$90(a6), d2/a2-a3
    unlk    a6
    rts

; ============================================================================
; HandleRouteEventType2 -- (TODO: name)
; 240 bytes | $022B56-$022C45
; ============================================================================
HandleRouteEventType2:
    link    a6,#-$80
    movem.l d2-d4/a2-a4, -(a7)
    movea.l $8(a6), a3
    lea     -$80(a6), a4
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0C4C                                 ; jsr $0237D0(pc)
    nop
    pea     ($0004).w
    jsr InitInfoPanel
    cmpi.b  #$2, $1(a3)
    bne.b   l_22ba2
    pea     ($00041316).l
    bra.b   l_22bb4
l_22ba2:
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
l_22bb4:
    pea     ($00047FCE).l
    move.l  a4, -(a7)
    jsr sprintf
    move.l  a4, -(a7)
    dc.w    $4EBA,$0BB6                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $20(a7), a7
    dc.w    $4EBA,$0BCA                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d4
    move.b  $1(a2), d4
    clr.w   d2
    bra.b   l_22c0a
l_22bf6:
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    addq.w  #$1, d3
    addq.w  #$1, d2
l_22c0a:
    cmp.w   d4, d2
    bcs.b   l_22bf6
    moveq   #$0,d3
    move.b  $2(a2), d3
    moveq   #$0,d4
    move.b  $3(a2), d4
    clr.w   d2
    bra.b   l_22c32
l_22c1e:
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    addq.w  #$1, d3
    addq.w  #$1, d2
l_22c32:
    cmp.w   d4, d2
    bcs.b   l_22c1e
    dc.w    $4EBA,$0BFE                                 ; jsr $023836(pc)
    nop
    movem.l -$98(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; HandleRouteEventType3 -- (TODO: name)
; 196 bytes | $022C46-$022D09
; ============================================================================
HandleRouteEventType3:
    link    a6,#-$80
    movem.l a2-a3, -(a7)
    movea.l $8(a6), a2
    lea     -$80(a6), a3
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    pea     ($0004).w
    jsr InitInfoPanel
    moveq   #$0,d0
    move.b  $2(a2), d0
    cmp.w   ($00FF0006).l, d0
    bne.b   l_22c98
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047FF4).l
    bra.b   l_22cb0
l_22c98:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00048020).l
l_22cb0:
    move.l  a3, -(a7)
    jsr sprintf
    move.l  a3, -(a7)
    dc.w    $4EBA,$0AC0                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    dc.w    $4EBA,$0AD8                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    lea     $2c(a7), a7
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    movem.l -$88(a6), a2-a3
    unlk    a6
    rts

; ============================================================================
; RenderGameUI -- (TODO: name)
; 702 bytes | $022D0A-$022FC7
; ============================================================================
RenderGameUI:
    link    a6,#-$80
    movem.l d2/a2-a5, -(a7)
    movea.l  #$000238F0,a3
    movea.l  #$00023958,a4
    lea     -$80(a6), a5
    movea.l  #$00FF09CA,a2
    tst.b   (a2)
    bne.w   l_22e92
    tst.b   $2(a2)
    bne.w   l_22fbe
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0576                                 ; jsr $0232B6(pc)
    nop
    addq.l  #$4, a7
    move.w  d0, d2
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d1, d0
    bhi.b   l_22dca
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000A
    dc.w    $001E
    dc.w    $001E
    dc.w    $0032
    dc.w    $0046
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($0008).w
    bra.b   l_22dc6
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($0009).w
    bra.b   l_22dc6
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000A).w
    bra.b   l_22dc6
    pea     ($0001).w
    jsr LoadDisplaySet
    jsr AnimateScrollWipe
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    pea     ($0007).w
l_22dc6:
    jsr     (a3)
    addq.l  #$4, a7
l_22dca:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047D94,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$5, d2
    bne.b   l_22df8
    pea     ($00041328).l
    bra.b   l_22dfe
l_22df8:
    pea     ($00041326).l
l_22dfe:
    pea     ($0004805A).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    dc.w    $4EBA,$096C                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    pea     ($0018).w
    jsr GameCommand
    jsr ClearInfoPanel
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    lea     $2c(a7), a7
    pea     ($0003).w
    pea     ($0001).w
    jsr RandRange
    mulu.w  #$a, d0
    move.b  d0, $2(a2)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0610                                 ; jsr $023490(pc)
    nop
    lea     $18(a7), a7
    dc.w    $4EBA,$091E                                 ; jsr $0237A8(pc)
    nop
    bra.w   l_22fbe
l_22e92:
    cmpi.b  #$1, (a2)
    bne.w   l_22fbe
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0464                                 ; jsr $023308(pc)
    nop
    move.w  d0, d2
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    lea     $2c(a7), a7
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.b   l_22f5e
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0008
    dc.w    $0022
    dc.w    $003C
    dc.w    $0050
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000B).w
    bra.b   l_22f5a
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000D).w
    bra.b   l_22f5a
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000E).w
    bra.b   l_22f5a
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000C).w
l_22f5a:
    jsr     (a3)
    addq.l  #$4, a7
l_22f5e:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047DAC,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004808E).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    dc.w    $4EBA,$07EC                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    dc.w    $4EBA,$0804                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
l_22fbe:
    movem.l -$94(a6), d2/a2-a5
    unlk    a6
    rts

; ============================================================================
; UpdateGameStateS2 -- (TODO: name)
; 750 bytes | $022FC8-$0232B5
; ============================================================================
UpdateGameStateS2:
    link    a6,#-$A0
    movem.l d2-d3/a2-a5, -(a7)
    lea     -$80(a6), a5
    movea.l  #$00FF09CE,a2
    clr.w   d3
l_22fdc:
    tst.b   (a2)
    bne.w   l_23112
    tst.w   ($00FF000A).l
    beq.b   l_22ff8
    pea     ($0012).w
    clr.l   -(a7)
    jsr DecompressTilePair
    addq.l  #$8, a7
l_22ff8:
    clr.l   -(a7)
    jsr InitInfoPanel
    moveq   #$0,d0
    move.b  $2(a2), d0
    mulu.w  #$14, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    mulu.w  #$320, d0
    add.l   (a7)+, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000480DC).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    dc.w    $4EBA,$0712                                 ; jsr $02377C(pc)
    nop
    lea     $1c(a7), a7
    tst.w   ($00FF000A).l
    beq.b   l_23088
    pea     ($0003).w
    jsr TogglePageDisplay
    addq.l  #$4, a7
    bra.b   l_23098
l_23088:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
l_23098:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  $1(a4), d2
    addi.w  #$ffec, d2
    tst.w   d2
    ble.b   l_230c0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_230c2
l_230c0:
    moveq   #$0,d0
l_230c2:
    move.b  d0, $1(a4)
    pea     ($0001).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0502                                 ; jsr $0235D8(pc)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_23102
    pea     ($00048114).l
    dc.w    $4EBA,$0690                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $c(a7), a7
l_23102:
    dc.w    $4EBA,$06A4                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    bra.w   l_2320e
l_23112:
    cmpi.b  #$1, (a2)
    bne.w   l_2320e
    tst.w   ($00FF000A).l
    beq.b   l_23132
    pea     ($0013).w
    pea     ($0001).w
    jsr DecompressTilePair
    addq.l  #$8, a7
l_23132:
    pea     ($0001).w
    jsr InitInfoPanel
    moveq   #$0,d0
    move.b  $2(a2), d0
    mulu.w  #$14, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    mulu.w  #$320, d0
    add.l   (a7)+, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00048158).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    dc.w    $4EBA,$05D6                                 ; jsr $02377C(pc)
    nop
    lea     $1c(a7), a7
    tst.w   ($00FF000A).l
    beq.b   l_231c4
    pea     ($0003).w
    jsr TogglePageDisplay
    addq.l  #$4, a7
    bra.b   l_231d4
l_231c4:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
l_231d4:
    dc.w    $4EBA,$05D2                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  $1(a4), d2
    addi.w  #$fff6, d2
    tst.w   d2
    ble.b   l_23208
    move.w  d2, d0
    ext.l   d0
    bra.b   l_2320a
l_23208:
    moveq   #$0,d0
l_2320a:
    move.b  d0, $1(a4)
l_2320e:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$2, d3
    blt.w   l_22fdc
    cmpi.w  #$ff, ($00FF09D6).l
    beq.w   l_232ac
    pea     ($000F).w
    jsr InitInfoPanel
    move.w  ($00FF09D6).l, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     -$a0(a6)
    jsr StringConcat
    pea     -$a0(a6)
    pea     ($00048198).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    dc.w    $4EBA,$051A                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    pea     -$a0(a6)
    pea     ($000481DA).l
    move.l  a5, -(a7)
    jsr sprintf
    lea     $30(a7), a7
    move.l  a5, -(a7)
    dc.w    $4EBA,$04EE                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    dc.w    $4EBA,$0506                                 ; jsr $0237A8(pc)
    nop
    jsr ClearInfoPanel
l_232ac:
    movem.l -$b8(a6), d2-d3/a2-a5
    unlk    a6
    rts


; ============================================================================
; ClassifyEvent -- (TODO: describe)
; Called: ?? times.
; 82 bytes | $0232B6-$023307
; ============================================================================
ClassifyEvent:                                                  ; $0232B6
    moveq   #$0,d0
    move.w  $0006(sp),d0
    moveq   #$15,d1
    cmp.w   d1,d0
    beq.b   .l232f4
    moveq   #$3,d1
    cmp.w   d1,d0
    beq.b   .l232f8
    moveq   #$1c,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$13,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$f,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$10,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$7,d1
    cmp.w   d1,d0
    beq.b   .l23300
    moveq   #$18,d1
    cmp.w   d1,d0
    beq.b   .l23300
    moveq   #$1a,d1
    cmp.w   d1,d0
    beq.b   .l23300
    bra.b   .l23304
.l232f4:                                                ; $0232F4
    moveq   #$1,d0
    bra.b   .l23306
.l232f8:                                                ; $0232F8
    moveq   #$2,d0
    bra.b   .l23306
.l232fc:                                                ; $0232FC
    moveq   #$3,d0
    bra.b   .l23306
.l23300:                                                ; $023300
    moveq   #$4,d0
    bra.b   .l23306
.l23304:                                                ; $023304
    moveq   #$5,d0
.l23306:                                                ; $023306
    rts

; === Translated block $023308-$02377C ===
; 6 functions, 1140 bytes

; ============================================================================
; ProcessTradeS2 -- (TODO: name)
; 126 bytes | $023308-$023385
; ============================================================================
ProcessTradeS2:
    moveq   #$0,d0
    move.w  $6(a7), d0
    moveq   #$52,d1
    cmp.l   d1, d0
    bhi.b   l_23382
    lea     $23348(pc), a0
    nop
    moveq   #$C,d1
    cmp.b   (a0)+, d0
    dbls    d1, ($0002331C).l
    bne.b   l_23382
    add.l   d1, d1
    dc.w    $303B,$1806                                 ; move.w (6,pc,d1.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0028
    dc.w    $0028
    dc.w    $004C
    dc.w    $004C
    dc.w    $0028
    dc.w    $0028
    dc.w    $0050
    dc.w    $0050
    dc.w    $004C
    dc.w    $0028
    dc.w    $004C
    dc.w    $0028
    dc.w    $0050
    dc.w    $0006
    btst    d3, (a4)+
    move.b  (a6)+, -(a6)
    move.l  -(a7), -(a2)
    dc.w    $2A36,$3A3C                                 ; move.l $3c(a6, d3.l), d5 - ext word has junk in bits 10-8
    addq.b  #$1, d0
    move.w  ($00FF0006).l, d0
    andi.l  #$3, d0
    beq.b   l_23376
    move.w  ($00FF0006).l, d0
    andi.l  #$3, d0
    moveq   #$3,d1
    cmp.l   d0, d1
    bne.b   l_23382
l_23376:
    moveq   #$1,d0
    bra.b   l_23384
    moveq   #$2,d0
    bra.b   l_23384
    moveq   #$3,d0
    bra.b   l_23384
l_23382:
    moveq   #$4,d0
l_23384:
    rts

; ============================================================================
; GetCharStatsS2 -- (TODO: name)
; 266 bytes | $023386-$02348F
; ============================================================================
GetCharStatsS2:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d5
    tst.w   d5
    bne.b   l_23396
    moveq   #$1,d4
    bra.b   l_233a0
l_23396:
    cmpi.w  #$1, d5
    bne.w   l_2348a
    moveq   #$2,d4
l_233a0:
    clr.w   d3
l_233a2:
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_233b4:
    cmpi.b  #$5, $1(a2)
    bne.b   l_233f4
    cmpi.b  #$20, (a2)
    bcc.b   l_233da
    moveq   #$0,d0
    move.b  (a2), d0
    mulu.w  #$6, d0
    moveq   #$0,d1
    move.b  $2(a2), d1
    add.w   d1, d0
    movea.l  #$00FF0420,a0
    bra.b   l_233ee
l_233da:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    moveq   #$0,d1
    move.b  $2(a2), d1
    add.w   d1, d0
    movea.l  #$00FF04E0,a0
l_233ee:
    move.b  #$ff, (a0,d0.w)
l_233f4:
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    subq.l  #$1, d0
    moveq   #$5,d1
    cmp.l   d1, d0
    bhi.b   l_23474
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000C
    dc.w    $0062
    dc.w    $000C
    dc.w    $0062
    dc.w    $000C
    dc.w    $0032
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    and.w   d4, d0
    cmp.w   d4, d0
    bne.b   l_23474
    tst.w   d5
    bne.b   l_2346e
l_2343c:
    ori.b   #$40, $1(a2)
    bra.b   l_23474
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CheckEventMatch
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_2343c
    pea     ($0001).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CheckEventMatch
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_23474
l_2346e:
    ori.b   #$80, $1(a2)
l_23474:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   l_233b4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   l_233a2
l_2348a:
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; GetCharRelationS2 -- (TODO: name)
; 328 bytes | $023490-$0235D7
; ============================================================================
GetCharRelationS2:
    link    a6,#-$88
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d5
    movea.l  #$0001D6A4,a3
    clr.w   d3
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$8(a6, d0.w), a0
    movea.l a0, a2
    bra.b   l_234d0
l_234b6:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
    move.w  d0, (a2)
    add.w   (a2)+, d3
    addq.w  #$1, d2
l_234d0:
    cmpi.w  #$4, d2
    blt.b   l_234b6
    tst.w   d3
    bgt.b   l_234e0
l_234da:
    moveq   #$0,d0
    bra.w   l_235ce
l_234e0:
    clr.w   d2
l_234e2:
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    move.w  d0, d3
    add.w   d0, d0
    tst.w   -$8(a6, d0.w)
    bgt.b   l_234fe
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    blt.b   l_234e2
l_234fe:
    cmpi.w  #$14, d2
    bge.b   l_234da
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$018A                                 ; jsr $023698(pc)
    nop
    addq.l  #$8, a7
    movea.l d0, a2
    move.l  a2, d0
    beq.b   l_234da
    pea     ($0063).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    subi.l  #$28, d1
    moveq   #$A,d6
    cmp.l   d1, d6
    bge.b   l_23544
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    subi.l  #$28, d1
    bra.b   l_23546
l_23544:
    moveq   #$A,d1
l_23546:
    cmp.l   d1, d0
    bge.b   l_234da
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.l   d0
    beq.b   l_234da
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.w   l_234da
    move.b  $a(a2), d0
    andi.l  #$2, d0
    moveq   #$2,d1
    cmp.l   d0, d1
    beq.w   l_234da
    pea     ($0001).w
    move.l  a2, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0050                                 ; jsr $0235D8(pc)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_235cc
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($0004821C).l
    pea     -$88(a6)
    jsr sprintf
    pea     -$88(a6)
    dc.w    $4EBA,$01C2                                 ; jsr $02377C(pc)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
l_235cc:
    moveq   #$1,d0
l_235ce:
    movem.l -$a4(a6), d2-d6/a2-a3
    unlk    a6
    rts

; ============================================================================
; ExecuteTradeOffer -- (TODO: name)
; 192 bytes | $0235D8-$023697
; ============================================================================
ExecuteTradeOffer:
    movem.l d2-d5/a2, -(a7)
    move.l  $20(a7), d3
    move.l  $18(a7), d4
    movea.l $1c(a7), a2
    move.b  $a(a2), d0
    andi.l  #$2, d0
    moveq   #$2,d1
    cmp.l   d0, d1
    bne.b   l_235fe
l_235f8:
    moveq   #$0,d0
    bra.w   l_23692
l_235fe:
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    move.w  d0, d2
    cmp.w   d2, d3
    bcc.b   l_235f8
    moveq   #$0,d5
    move.b  $3(a2), d5
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d3, d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    moveq   #$0,d0
    move.b  $3(a2), d0
    cmp.w   d5, d0
    bcc.b   l_2366a
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.w  d5, d2
    sub.w   d0, d2
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    sub.b   d2, (a0,d0.w)
l_2366a:
    move.l  a2, -(a7)
    jsr GetByteField4
    lea     $c(a7), a7
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d4, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    adda.l  d0, a0
    movea.l a0, a2
    sub.b   d3, (a2)
    moveq   #$1,d0
l_23692:
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; FinalizeTrade -- (TODO: name)
; 144 bytes | $023698-$023727
; ============================================================================
FinalizeTrade:
    movem.l d2-d5/a2, -(a7)
    move.l  $1c(a7), d3
    move.l  $18(a7), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $4(a2), d4
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d4
    cmpi.w  #$1, d4
    bcc.b   l_236ce
l_236ca:
    moveq   #$0,d0
    bra.b   l_23722
l_236ce:
    subq.w  #$1, d4
    clr.w   d2
l_236d2:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    mulu.w  #$14, d0
    move.w  d5, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$ff, d3
    beq.b   l_2371a
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d3, d0
    beq.b   l_2371a
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
    beq.b   l_2371a
    addq.w  #$1, d2
    cmpi.w  #$100, d2
    blt.b   l_236d2
l_2371a:
    cmpi.w  #$100, d2
    bge.b   l_236ca
    move.l  a2, d0
l_23722:
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; RenderScenarioScreen -- (TODO: name)
; 84 bytes | $023728-$02377B
; ============================================================================
RenderScenarioScreen:
    clr.w   d1
l_2372a:
    move.w  d1, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09C2,a0
    cmpi.b  #$ff, (a0,d0.w)
    beq.b   l_23740
l_2373c:
    moveq   #$1,d0
    bra.b   l_2377a
l_23740:
    addq.w  #$1, d1
    cmpi.w  #$2, d1
    blt.b   l_2372a
    cmpi.b  #$ff, ($00FF09CA).l
    bne.b   l_2373c
    clr.w   d1
l_23754:
    move.w  d1, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09CE,a0
    cmpi.b  #$ff, (a0,d0.w)
    bne.b   l_2373c
    addq.w  #$1, d1
    cmpi.w  #$2, d1
    blt.b   l_23754
    cmpi.w  #$ff, ($00FF09D6).l
    bne.b   l_2373c
    moveq   #$0,d0
l_2377a:
    rts


; ============================================================================
; DrawLabeledBox -- (TODO: describe)
; Called: ?? times.
; 44 bytes | $02377C-$0237A7
; ============================================================================
DrawLabeledBox:                                                  ; $02377C
    move.l  a2,-(sp)
    movea.l $0008(sp),a2
    pea     ($000A).w
    pea     ($001D).w
    pea     ($0011).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.l  a2,-(sp)
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0014(sp),sp
    movea.l (sp)+,a2
    rts
; ============================================================================
; ClearListArea -- (TODO: describe)
; Called: ?? times.
; 40 bytes | $0237A8-$0237CF
; ============================================================================
ClearListArea:                                                  ; $0237A8
    move.l  #$8000,-(sp)
    pea     ($000A).w
    pea     ($001D).w
    pea     ($0011).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
; === Translated block $0237D0-$0238F0 ===
; 4 functions, 288 bytes

; ============================================================================
; ProcessScenarioMenu -- (TODO: name)
; 102 bytes | $0237D0-$023835
; ============================================================================
ProcessScenarioMenu:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    jsr ResourceLoad
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr LoadScreen
    lea     $28(a7), a7
    jsr ResourceUnload
    move.l  (a7)+, d2
    rts

; ============================================================================
; DisplayScenarioMenu -- (TODO: name)
; 38 bytes | $023836-$02385B
; ============================================================================
DisplayScenarioMenu:
    jsr ResourceLoad
    jsr PreLoopInit
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $c(a7), a7
    jsr ResourceUnload
    rts

; ============================================================================
; HandleScenarioMenuSelect -- (TODO: name)
; 58 bytes | $02385C-$023895
; ============================================================================
HandleScenarioMenuSelect:
    link    a6,#$0
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    moveq   #$14,d1
    jsr SignedMod
    move.w  d0, d2
    pea     ($0010).w
    pea     ($0030).w
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0004825C,a0
    move.l  (a0,d0.w), -(a7)
    jsr DisplaySetup
    move.l  -$4(a6), d2
    unlk    a6
    rts

; ============================================================================
; ValidateMenuOption -- (TODO: name)
; 90 bytes | $023896-$0238EF
; ============================================================================
ValidateMenuOption:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$14,d1
    jsr SignedMod
    move.w  d0, d2
    add.w   d0, d0
    movea.l  #$000482AC,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l  #$00088C90,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0078).w
    pea     ($0640).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    lea     $14(a7), a7
    move.l  (a7)+, d2
    rts

; ============================================================================
; InitInfoPanel -- (TODO: describe)
; Called: 9 times.
; 64 bytes | $0238F0-$02392F
; ============================================================================
InitInfoPanel:                                                  ; $0238F0
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $6100,$ff60                                 ; bsr.w $02385C
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $6100,$ff92                                 ; bsr.w $023896
    pea     ($000700A8).l
    pea     ($000A).w
    pea     ($000C).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    move.l  (sp)+,d2
    rts
; ============================================================================
; ClearInfoPanel -- Clear info panel area with priority flag via GameCommand #$1A
; Called: 11 times.
; 40 bytes | $023930-$023957
; ============================================================================
ClearInfoPanel:                                                  ; $023930
    move.l  #$8000,-(sp)
    pea     ($000A).w
    pea     ($000C).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
; ============================================================================
; AnimateInfoPanel -- (TODO: describe)
; Called: 7 times.
; 98 bytes | $023958-$0239B9
; ============================================================================
AnimateInfoPanel:                                                  ; $023958
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d3
    movea.l $0010(sp),a2
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$004e                                 ; jsr $0239BA
    nop
    addq.l  #$8,sp
    clr.w   d2
.l23974:                                                ; $023974
    pea     ($0006).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$00aa                                 ; jsr $023A34
    nop
    pea     ($0006).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$0016                                 ; jsr $0239BA
    nop
    lea     $0020(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    bcs.b   .l23974
    movem.l (sp)+,d2-d3/a2
    rts
    dc.w    $48E7,$3030,$262F                                ; $0239BA
; === Translated block $0239C0-$023A34 ===
; 1 functions, 116 bytes

; ============================================================================
; FinalizeScenarioScreen -- (TODO: name)
; 116 bytes | $0239C0-$023A33
; ============================================================================
FinalizeScenarioScreen:
    dc.w    $0018,$246F                     ; ori.b #$6f,(a0)+ - high byte $24 is compiler junk
    dc.w    $0014,$4242                     ; ori.b #$42,(a4) - high byte $42 is compiler junk
    bra.b   l_23a24
l_239ca:
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($076D).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.l  #$1, a2
    addq.w  #$1, d2
l_23a24:
    cmp.w   d3, d2
    bcc.b   l_23a2e
    cmpi.b  #$ff, (a2)
    bne.b   l_239ca
l_23a2e:
    movem.l (a7)+, d2-d3/a2-a3
    rts

; ============================================================================
; PlaceItemTiles -- (TODO: describe)
; Called: 9 times.
; 86 bytes | $023A34-$023A89
; ============================================================================
PlaceItemTiles:                                                  ; $023A34
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d3
    movea.l $0010(sp),a2
    clr.w   d2
    bra.b   .l23a7a
.l23a44:                                                ; $023A44
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00F0).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    addq.l  #$1,a2
    addq.w  #$1,d2
.l23a7a:                                                ; $023A7A
    cmp.w   d3,d2
    bcc.b   .l23a84
    cmpi.b  #$ff,(a2)
    bne.b   .l23a44
.l23a84:                                                ; $023A84
    movem.l (sp)+,d2-d3/a2
    rts
; ============================================================================
; DecompressTilePair -- (TODO: describe)
; Called: ?? times.
; 134 bytes | $023A8A-$023B0F
; ============================================================================
DecompressTilePair:                                                  ; $023A8A
    movem.l d2-d3,-(sp)
    move.l  $000c(sp),d2
    move.l  $0010(sp),d3
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    add.w   d0,d0
    movea.l #$000482ac,a0
    move.w  (a0,d0.w),d0
    andi.l  #$ffff,d0
    lsl.l   #$2,d0
    movea.l #$00088c90,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    add.w   d0,d0
    movea.l #$000482ac,a0
    move.w  (a0,d0.w),d0
    andi.l  #$ffff,d0
    lsl.l   #$2,d0
    movea.l #$00088c90,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF3804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0010(sp),sp
    movem.l (sp)+,d2-d3
    rts
; ============================================================================
; TogglePageDisplay -- (TODO: describe)
; Called: ?? times.
; 90 bytes | $023B10-$023B69
; ============================================================================
TogglePageDisplay:                                                  ; $023B10
    movem.l d2-d4,-(sp)
    move.l  $0010(sp),d4
    moveq   #$1,d2
.l23b1a:                                                ; $023B1A
    clr.l   -(sp)
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l #$000482d4,a0
    move.w  (a0,d0.l),d0
    add.w   d0,d0
    movea.l #$00ff1804,a0
    pea     (a0,d0.w)
    pea     ($0078).w
    pea     ($0640).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    moveq   #$1,d0
    eor.w   d0,d2
    clr.l   -(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
    lea     $001c(sp),sp
    move.w  d0,d3
    tst.w   d3
    beq.b   .l23b1a
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
; ============================================================================
; AnimateScrollEffect -- (TODO: describe)
; 304 bytes | $023B6A-$023C99
; ============================================================================
AnimateScrollEffect:                                                  ; $023B6A
    movem.l d2-d4/a2-a3,-(sp)
    movea.l #$0001d98c,a2
    movea.l #$0d64,a3
    tst.w   ($00FF000A).l
    beq.w   .l23c94
    clr.l   -(sp)
    move.l  #$fc00,-(sp)
    pea     ($0400).w
    pea     ($0001).w
    pea     ($0007).w
    jsr     (a3)
    lea     $0014(sp),sp
    clr.w   d2
    moveq   #$1,d4
.l23ba2:                                                ; $023BA2
    clr.w   d3
.l23ba4:                                                ; $023BA4
    add.w   d4,d2
    cmpi.w  #$0100,d2
    blt.b   .l23bb0
    subi.w  #$0100,d2
.l23bb0:                                                ; $023BB0
    add.w   d4,d3
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    cmpi.w  #$20,d3
    blt.b   .l23ba4
    addq.w  #$1,d4
    cmpi.w  #$10,d4
    ble.b   .l23ba2
    clr.w   d3
.l23be2:                                                ; $023BE2
    addi.w  #$10,d2
    cmpi.w  #$0100,d2
    blt.b   .l23bf0
    subi.w  #$0100,d2
.l23bf0:                                                ; $023BF0
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    ble.b   .l23be2
    moveq   #$10,d4
.l23c1a:                                                ; $023C1A
    clr.w   d3
.l23c1c:                                                ; $023C1C
    add.w   d4,d2
    cmpi.w  #$0100,d2
    blt.b   .l23c28
    subi.w  #$0100,d2
.l23c28:                                                ; $023C28
    add.w   d4,d3
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    cmpi.w  #$18,d3
    blt.b   .l23c1c
    subq.w  #$1,d4
    cmpi.w  #$1,d4
    bge.b   .l23c1a
    bra.b   .l23c7c
.l23c5a:                                                ; $023C5A
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    addq.w  #$1,d2
.l23c7c:                                                ; $023C7C
    cmpi.w  #$0100,d2
    blt.b   .l23c5a
    clr.l   -(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0010(sp),sp
.l23c94:                                                ; $023C94
    movem.l (sp)+,d2-d4/a2-a3
    rts
; ============================================================================
; AnimateScrollWipe -- (TODO: describe)
; Called: ?? times.
; 230 bytes | $023C9A-$023D7F
; ============================================================================
AnimateScrollWipe:                                                  ; $023C9A
    movem.l d2/a2-a3,-(sp)
    movea.l #$0001d98c,a2
    movea.l #$0d64,a3
    tst.w   ($00FF000A).l
    beq.w   .l23d7a
    pea     ($0010).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($FFFFFFF0).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0030(sp),sp
    pea     ($0010).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($FFFFFFF0).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0030(sp),sp
    moveq   #$f,d2
.l23d26:                                                ; $023D26
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    neg.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0030(sp),sp
    subq.w  #$1,d2
    tst.w   d2
    bgt.b   .l23d26
    clr.l   -(sp)
    pea     ($0016).w
    clr.l   -(sp)
    clr.l   -(sp)
    jsr     (a2)
    lea     $0010(sp),sp
.l23d7a:                                                ; $023D7A
    movem.l (sp)+,d2/a2-a3
    rts
; ============================================================================
; RunTransitionSteps -- (TODO: describe)
; Called: ?? times.
; 54 bytes | $023D80-$023DB5
; ============================================================================
RunTransitionSteps:                                                  ; $023D80
    move.l  a2,-(sp)
    movea.l #$00023dc6,a2
    tst.w   ($00FF000A).l
    beq.b   .l23db2
    jsr     (a2)
    dc.w    $4eba,$0070                                 ; jsr $023E04
    nop
    jsr     (a2)
    dc.w    $4eba,$0068                                 ; jsr $023E04
    nop
    pea     ($0006).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    jsr     (a2)
.l23db2:                                                ; $023DB2
    movea.l (sp)+,a2
    rts
; ============================================================================
; UpdateIfActive -- (TODO: describe)
; Called: ?? times.
; 16 bytes | $023DB6-$023DC5
; ============================================================================
UpdateIfActive:                                                  ; $023DB6
    tst.w   ($00FF000A).l
    beq.b   .l23dc4
    dc.w    $4eba,$0044                                 ; jsr $023E04
    nop
.l23dc4:                                                ; $023DC4
    rts
; === Translated block $023DC6-$023EA8 ===
; 3 functions, 226 bytes

; ============================================================================
; LookupCharCode -- (TODO: name)
; 62 bytes | $023DC6-$023E03
; ============================================================================
LookupCharCode:
    move.l  d2, -(a7)
    clr.w   d2
l_23dca:
    pea     ($0004).w
    pea     ($0015).w
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$0005FA6E,a0
    pea     (a0, d0.w)
    jsr DisplaySetup
    pea     ($0002).w
    pea     ($000E).w
    jsr GameCommand
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_23dca
    move.l  (a7)+, d2
    rts

; ============================================================================
; CompareCharCode -- (TODO: name)
; 60 bytes | $023E04-$023E3F
; ============================================================================
CompareCharCode:
    move.l  d2, -(a7)
    moveq   #$6,d2
l_23e08:
    pea     ($0004).w
    pea     ($0015).w
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$0005FA6E,a0
    pea     (a0, d0.w)
    jsr DisplaySetup
    pea     ($0002).w
    pea     ($000E).w
    jsr GameCommand
    lea     $14(a7), a7
    subq.w  #$1, d2
    tst.w   d2
    bge.b   l_23e08
    move.l  (a7)+, d2
    rts

; ============================================================================
; ValidateCharCode -- (TODO: name)
; 104 bytes | $023E40-$023EA7
; ============================================================================
ValidateCharCode:
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A7E).l
    jsr DisplaySetup
    move.l  ($000A1B10).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($002C).w
    pea     ($0342).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
    pea     ($00071F40).l
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0017).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    rts

; ============================================================================
; RunQuarterScreen -- (TODO: describe)
; Called: ?? times.
; 1188 bytes | $023EA8-$02434B
; ============================================================================
RunQuarterScreen:                                                  ; $023EA8
    link    a6,#-$4
    movem.l d2-d7/a2-a5,-(sp)
    movea.l #$0d64,a3
    movea.l #$00ff13fc,a4
    movea.l #$0001e044,a5
    clr.w   d4
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  ($00FF9A1C).l,d7
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$c43c                           ; jsr $01C43C
    lea     $0018(sp),sp
    dc.w    $6100,$ff34                                 ; bsr.w $023E40
    moveq   #$e,d3
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($00C0).w
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0028(sp),sp
    tst.w   d0
    beq.b   .l23f50
    moveq   #$1,d0
    bra.b   .l23f52
.l23f50:                                                ; $023F50
    moveq   #$0,d0
.l23f52:                                                ; $023F52
    move.w  d0,-$0002(a6)
    clr.w   -$0004(a6)
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    clr.w   d6
    clr.w   d5
.l23f6c:                                                ; $023F6C
    cmpi.w  #$1,d4
    bne.w   .l23ffe
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  ($00FF0016).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  ($00FF0016).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$c43c                           ; jsr $01C43C
    lea     $001c(sp),sp
    dc.w    $6100,$fe7c                                 ; bsr.w $023E40
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($00C0).w
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    clr.w   d4
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
.l23ffe:                                                ; $023FFE
    tst.w   -$0002(a6)
    beq.b   .l24014
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    bne.w   .l23f6c
.l24014:                                                ; $024014
    clr.w   -$0002(a6)
    addq.w  #$1,d5
    cmpi.w  #$1,d5
    bne.b   .l24080
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00C5).w
    pea     ($0048).w
    pea     ($0039).w
    pea     ($0770).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00D2).w
    pea     ($0048).w
    pea     ($003A).w
    pea     ($0771).w
    jsr     (a5)
    lea     $001c(sp),sp
.l24072:                                                ; $024072
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    bra.b   .l240a0
.l24080:                                                ; $024080
    cmpi.w  #$f,d5
    bne.b   .l24098
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    addq.l  #$8,sp
    bra.b   .l24072
.l24098:                                                ; $024098
    cmpi.w  #$1e,d5
    bne.b   .l240a0
    clr.w   d5
.l240a0:                                                ; $0240A0
    move.w  -$0004(a6),d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$3f,d0
    move.w  d0,-$0004(a6)
    ext.l   d0
    moveq   #$10,d1
    cmp.w   d1,d0
    dc.w    $6700,$01d6                                 ; beq.w $024298
    moveq   #$20,d1
    cmp.w   d1,d0
    beq.b   .l240ee
    moveq   #$8,d1
    cmp.w   d1,d0
    dc.w    $6700,$0102                                 ; beq.w $0241D2
    moveq   #$4,d1
    cmp.w   d1,d0
    dc.w    $6700,$015a                                 ; beq.w $024232
    moveq   #$1,d1
    cmp.w   d1,d0
    dc.w    $6700,$016e                                 ; beq.w $02424E
    moveq   #$2,d1
    cmp.w   d1,d0
    dc.w    $6700,$018c                                 ; beq.w $024274
    dc.w    $6000,$0194                                 ; bra.w $024280
.l240ee:                                                ; $0240EE
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    tst.w   d6
    bne.b   .l24132
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0004(a2),d0
    moveq   #$0,d1
    move.b  $0005(a2),d1
    add.l   d1,d0
    dc.w    $6f00,$016c                                 ; ble.w $024288
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$021e                                 ; jsr $024344
    nop
    addq.l  #$4,sp
    moveq   #$1,d4
    dc.w    $6000,$0158                                 ; bra.w $024288
.l24132:                                                ; $024132
    move.w  d6,d0
    ext.l   d0
    subq.l  #$1,d0
    moveq   #$4,d1
    cmp.l   d1,d0
    dc.w    $6200,$014a                                 ; bhi.w $024288
    add.l   d0,d0
    move.w  $2414a(pc,d0.l),d0
    jmp     $2414a(pc,d0.w)
    ; WARNING: 514 undecoded trailing bytes at $02414A
    dc.w    $000a
    dc.w    $0040
    dc.w    $004e
    dc.w    $005c
    dc.w    $0070
    dc.w    $4878
    dc.w    $077d
    dc.w    $4878
    dc.w    $0002
    dc.w    $4878
    dc.w    $0016
    dc.w    $4878
    dc.w    $0017
    dc.w    $4878
    dc.w    $0009
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $001a
    dc.w    $4e93
    dc.w    $4fef
    dc.w    $001c
    dc.w    $4878
    dc.w    $0004
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $12ee
    dc.w    $508f
    dc.w    $60a2
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0d68
    dc.w    $4e71
    dc.w    $6092
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $08aa
    dc.w    $4e71
    dc.w    $6084
    dc.w    $3007
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $10a0
    dc.w    $4e71
    dc.w    $60cc
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $1c82
    dc.w    $4e71
    dc.w    $588f
    dc.w    $4eba
    dc.w    $1f28
    dc.w    $4e71
    dc.w    $6000
    dc.w    $ff5c
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5680
    dc.w    $721d
    dc.w    $b280
    dc.w    $6f08
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5680
    dc.w    $6002
    dc.w    $701d
    dc.w    $3600
    dc.w    $48c0
    dc.w    $0480
    dc.w    $0000
    dc.w    $000e
    dc.w    $7203
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $e08a
    dc.w    $3c00
    dc.w    $2f3c
    dc.w    $0000
    dc.w    $8000
    dc.w    $4878
    dc.w    $0002
    dc.w    $4878
    dc.w    $0002
    dc.w    $4878
    dc.w    $00c0
    dc.w    $3003
    dc.w    $48c0
    dc.w    $e788
    dc.w    $2f00
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0740
    dc.w    $4e95
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $000e
    dc.w    $4e93
    dc.w    $4fef
    dc.w    $0024
    dc.w    $6056
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5780
    dc.w    $720e
    dc.w    $b280
    dc.w    $6c08
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5780
    dc.w    $60a2
    dc.w    $700e
    dc.w    $609e
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3002
    dc.w    $48c0
    dc.w    $5680
    dc.w    $7204
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $e146
    dc.w    $3400
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $c43c
    dc.w    $588f
    dc.w    $6100
    dc.w    $fbd0
    dc.w    $6014
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3002
    dc.w    $48c0
    dc.w    $5280
    dc.w    $60d8
    dc.w    $4254
    dc.w    $4279
    dc.w    $00ff
    dc.w    $a7d8
    dc.w    $4878
    dc.w    $0003
    dc.w    $4878
    dc.w    $000e
    dc.w    $4e93
    dc.w    $508f
    dc.w    $6000
    dc.w    $fcd6
    dc.w    $4254
    dc.w    $4279
    dc.w    $00ff
    dc.w    $a7d8
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4e95
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $000e
    dc.w    $4e93
    dc.w    $4fef
    dc.w    $0024
    dc.w    $7000
    dc.w    $1039
    dc.w    $00ff
    dc.w    $0016
    dc.w    $b042
    dc.w    $6748
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $d71c
    dc.w    $4878
    dc.w    $0001
    dc.w    $3007
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $7000
    dc.w    $1039
    dc.w    $00ff
    dc.w    $0016
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6a2e
    dc.w    $4878
    dc.w    $0002
    dc.w    $3007
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $7000
    dc.w    $1039
    dc.w    $00ff
    dc.w    $0016
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6b78
    dc.w    $4fef
    dc.w    $0018
    dc.w    $6100
    dc.w    $fb2e
    dc.w    $6024
    dc.w    $42a7
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $538e
    dc.w    $4878
    dc.w    $077d
    dc.w    $4878
    dc.w    $0009
    dc.w    $4878
    dc.w    $0020
    dc.w    $4878
    dc.w    $0014
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $001a
    dc.w    $4e93
    dc.w    $4cee
    dc.w    $3cfc
    dc.w    $ffd4
    dc.w    $4e5e
    dc.w    $4e75
    dc.w    $4e56
    dc.w    $fff8
    dc.w    $48e7
    dc.w    $3f3c
; === Translated block $02434C-$026270 ===
; 14 functions, 7972 bytes

; ============================================================================
; HandleTextCompression -- (TODO: name)
; 914 bytes | $02434C-$0246DD
; ============================================================================
HandleTextCompression:
    move.l  $8(a6), d7
    movea.l  #$00000D64,a3
    movea.l  #$00FF13FC,a4
    movea.l  #$0003B270,a5
    moveq   #$1,d6
    jsr ResourceLoad
    jsr PreLoopInit
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $4(a2), d4
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d4
    clr.w   d3
    pea     ($0004E28A).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0018).w
    pea     ($037B).w
    jsr VRAMBulkLoad
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    pea     ($0019).w
    pea     ($0001).w
    jsr SetTextCursor
    cmpi.w  #$1, d4
    bne.b   .l243f4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041350).l
    bra.b   .l24400
.l243f4:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041346).l
.l24400:
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0004E0F6).l
    jsr DisplaySetup
    lea     $1c(a7), a7
    pea     ($0004E116).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0004E18E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad
    pea     ($0001).w
    pea     ($0005).w
    jsr SetTextCursor
    pea     ($0004133E).l
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr SetTextCursor
    pea     ($00041332).l
    jsr     (a5)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($001A).w
    jsr SetTextCursor
    pea     ($0004132C).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0220                                 ; jsr $0246DE(pc)
    nop
    jsr ResourceUnload
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l244dc
    moveq   #$1,d0
    bra.b   .l244de
.l244dc:
    moveq   #$0,d0
.l244de:
    move.w  d0, -$6(a6)
    clr.w   d5
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    clr.w   d2
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$4,d1
    jsr SignedMod
    move.l  d0, -$4(a6)
.l24500:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$1d, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0773).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    tst.w   -$6(a6)
    beq.b   .l2454e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   .l24500
.l2454e:
    clr.w   -$6(a6)
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.b   .l245d6
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    tst.w   d6
    beq.w   .l246c4
    cmpi.w  #$4, d2
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    pea     ($000C).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    add.w   d2, d0
    mulu.w  #$14, d0
    move.w  d7, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    pea     (a0, d0.w)
    jsr FormatRelationDisplay
    lea     $30(a7), a7
    clr.w   d6
    bra.w   .l246c4
.l245d6:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l245ea
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    bra.w   .l246d4
.l245ea:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l24668
    move.w  #$1, (a4)
    moveq   #$1,d6
    cmpi.w  #$1, d4
    ble.b   .l24600
    subq.w  #$1, d2
.l24600:
    tst.w   d2
    bge.w   .l246c4
    subq.w  #$4, d3
    cmpi.w  #$4, d4
    ble.b   .l24662
    moveq   #$3,d2
    tst.w   d3
    bge.b   .l24628
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    bge.b   .l2461e
    addq.l  #$3, d0
.l2461e:
    asr.l   #$2, d0
    move.l  d0, d3
    lsl.w   #$2, d3
    move.w  -$2(a6), d2
.l24628:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0086                                 ; jsr $0246DE(pc)
    nop
    lea     $2c(a7), a7
    bra.b   .l246c4
.l24662:
    clr.w   d3
    clr.w   d2
    bra.b   .l246c4
.l24668:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l246c4
    move.w  #$1, (a4)
    moveq   #$1,d6
    cmpi.w  #$1, d4
    ble.b   .l2467e
    addq.w  #$1, d2
.l2467e:
    cmpi.w  #$3, d2
    bgt.b   .l24698
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l246b0
.l24698:
    addq.w  #$4, d3
    cmpi.w  #$4, d4
    ble.b   .l246ac
    cmp.w   d4, d3
    blt.b   .l246a6
    clr.w   d3
.l246a6:
    clr.w   d2
    bra.w   .l24628
.l246ac:
    clr.w   d3
    bra.b   .l246be
.l246b0:
    move.w  d2, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l246c4
.l246be:
    move.w  d4, d2
    addi.w  #$ffff, d2
.l246c4:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l24500
.l246d4:
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; DecompressGraphicsData -- (TODO: name)
; 876 bytes | $0246DE-$024A49
; ============================================================================
DecompressGraphicsData:
    link    a6,#-$10
    movem.l d2-d6/a2-a5, -(a7)
    movea.l  #$00FF1804,a3
    movea.l  #$00000D64,a4
    movea.l  #$0004E0F4,a5
    move.w  $a(a6), d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$1,d6
    moveq   #$3,d5
    pea     ($0010).w
    pea     ($0020).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.l  a5, d0
    addi.l  #$9a, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    clr.w   d4
.l247ac:
    cmpi.b  #$ff, (a2)
    beq.w   .l24a40
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeMatch
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l24838
    pea     ($0010).w
    pea     ($0020).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.l  a5, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    move.l  a5, d0
    addi.l  #$9a, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($0375).w
    bra.b   .l24886
.l24838:
    pea     ($0004E056).l
    pea     ($0002).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004E0CE).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($036F).w
.l24886:
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    moveq   #-$1,d3
    move.b  $a(a2), d0
    btst    #$2, d0
    beq.b   .l248a0
    clr.w   d3
    bra.b   .l248ba
.l248a0:
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   .l248ae
    moveq   #$10,d3
    bra.b   .l248ba
.l248ae:
    move.b  $a(a2), d0
    btst    #$0, d0
    beq.b   .l248ba
    moveq   #$8,d3
.l248ba:
    move.w  d3, d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bge.b   .l24916
    clr.w   d2
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    addi.l  #$637b, d0
    move.l  d0, d3
.l248d8:
    move.w  d2, d0
    add.w   d0, d0
    move.w  d3, -$10(a6, d0.w)
    addq.l  #$1, d3
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   .l248d8
    pea     -$10(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
.l24916:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041368).l
    jsr PrintfWide
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041364).l
    jsr PrintfWide
    lea     $30(a7), a7
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, d2
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    mulu.w  #$a, d0
    move.w  d0, d2
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  $10(a2), d0
    move.l  d0, -(a7)
    jsr MulDiv
    move.w  d0, d2
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$1a, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    cmpi.w  #$64, d2
    bgt.b   .l24a0e
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004135E).l
    bra.b   .l24a28
.l24a0e:
    cmpi.w  #$64, d2
    bge.b   .l24a1a
    move.w  d2, d0
    ext.l   d0
    bra.b   .l24a1c
.l24a1a:
    moveq   #$64,d0
.l24a1c:
    move.w  d0, d2
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041358).l
.l24a28:
    jsr PrintfWide
    lea     $20(a7), a7
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    blt.w   .l247ac
.l24a40:
    movem.l -$34(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; UpdateSpriteAnimation -- (TODO: name)
; 454 bytes | $024A4A-$024C0F
; ============================================================================
UpdateSpriteAnimation:
    link    a6,#$0
    movem.l d2/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF09A2,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0290,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03F0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ResourceLoad
    jsr PreLoopInit
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007651E).l
    jsr DisplaySetup
    move.l  ($000A1B20).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($006E).w
    pea     ($0375).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $24(a7), a7
    pea     ($00071FC0).l
    pea     ($0017).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($0004).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($000C).w
    jsr SetTextWindow
    lea     $2c(a7), a7
    move.l  $e(a5), -(a7)
    move.l  $a(a5), -(a7)
    pea     ($0004139E).l
    jsr PrintfWide
    pea     ($0004).w
    pea     ($0010).w
    pea     ($0006).w
    pea     ($000C).w
    jsr SetTextWindow
    move.l  $4(a4), -(a7)
    move.l  (a4), -(a7)
    pea     ($00041392).l
    jsr PrintfWide
    lea     $28(a7), a7
    pea     ($0006).w
    pea     ($0010).w
    pea     ($000B).w
    pea     ($000C).w
    jsr SetTextWindow
    moveq   #$0,d0
    move.w  $4(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $2(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    pea     ($00041380).l
    jsr PrintfWide
    pea     ($0006).w
    pea     ($0010).w
    pea     ($0012).w
    pea     ($000C).w
    jsr SetTextWindow
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    pea     ($0004136C).l
    jsr PrintfWide
    lea     $10(a7), a7
    jsr ResourceUnload
.l24bee:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   .l24bee
    movem.l -$14(a6), d2/a2-a5
    unlk    a6
    rts

; ============================================================================
; OrchestrateGraphicsPipeline -- (TODO: name)
; 746 bytes | $024C10-$024EF9
; ============================================================================
OrchestrateGraphicsPipeline:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $14(a6), a3
    movea.l  #$0003B270,a4
    movea.l  #$0003AB2C,a5
    moveq   #$2,d4
    moveq   #$3,d5
    jsr PreLoopInit
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004978E).l
    jsr DisplaySetup
    pea     ($0004E116).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($0004E18E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($000413CE).l
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($000413C6).l
    jsr     (a4)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    addi.l  #$11, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($000413C0).l
    jsr     (a4)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    addi.l  #$17, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($000413BA).l
    jsr     (a4)
    lea     $24(a7), a7
    clr.w   d2
    bra.w   .l24ed2
.l24d1e:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    lea     (a3,d0.l), a0
    move.w  $e(a6), d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.w  (a0), d6
    move.w  $a(a6), d0
    lsl.w   #$5, d0
    move.w  d6, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0004E0F6).l
    jsr DisplaySetup
    pea     ($0004E116).l
    pea     ($0002).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($0004E18E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $2c(a7), a7
    movea.l  #$00FF1278,a0
    move.b  (a0,d6.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000413B6).l
    jsr     (a4)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$c, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000413B2).l
    jsr     (a4)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$12, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    pea     ($000413AE).l
    jsr     (a4)
    move.w  $a(a6), d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    clr.w   d7
    bra.b   .l24e9a
.l24e8a:
    cmp.b   (a2), d6
    bne.b   .l24e96
    moveq   #$0,d7
    move.b  $1(a2), d7
    bra.b   .l24ea0
.l24e96:
    addq.l  #$4, a2
    addq.w  #$1, d3
.l24e9a:
    cmpi.w  #$5, d3
    blt.b   .l24e8a
.l24ea0:
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$18, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $30(a7), a7
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000413AA).l
    jsr     (a4)
    addq.l  #$8, a7
    addq.w  #$1, d2
.l24ed2:
    cmpi.w  #$5, d2
    bge.b   .l24ef0
    move.w  $e(a6), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  $12(a6), d1
    ext.l   d1
    cmp.l   d1, d0
    blt.w   .l24d1e
.l24ef0:
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; InitGraphicsMemory -- (TODO: name)
; 858 bytes | $024EFA-$025253
; ============================================================================
InitGraphicsMemory:
    link    a6,#-$2C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l  #$00000D64,a4
    lea     -$2c(a6), a5
    moveq   #$1,d5
    jsr ResourceLoad
    jsr PreLoopInit
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    addq.l  #$4, a7
    move.w  d7, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d4
    clr.w   d2
.l24f40:
    tst.b   (a3)
    beq.b   .l24f54
.l24f44:
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  d2, (a5,a0.l)
    addq.w  #$1, d4
    bra.b   .l24f7c
.l24f54:
    move.w  d7, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
.l24f68:
    cmp.b   (a2), d2
    bne.b   .l24f72
    tst.b   $1(a2)
    bne.b   .l24f44
.l24f72:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$5, d3
    blt.b   .l24f68
.l24f7c:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   .l24f40
    tst.w   d4
    ble.w   .l2524a
    move.l  a5, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FC72                                 ; bsr.w $024C10
    jsr ResourceUnload
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l24fba
    moveq   #$1,d0
    bra.b   .l24fbc
.l24fba:
    moveq   #$0,d0
.l24fbc:
    move.w  d0, -$a(a6)
    clr.w   d6
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    clr.w   d3
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedDiv
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    move.l  d0, -$4(a6)
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    subq.l  #$1, d0
    move.l  d0, -$8(a6)
.l24ffa:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$1d, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0773).w
    jsr TilePlacement
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    tst.w   -$a(a6)
    beq.b   .l25048
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   .l24ffa
.l25048:
    clr.w   -$a(a6)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d6
    andi.w  #$20, d0
    beq.w   .l25116
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    tst.w   d5
    beq.b   .l24ffa
    moveq   #$D,d5
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), -$c(a6)
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  -$c(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharProfile
    pea     ($0010).w
    pea     ($000E).w
    jsr     (a4)
    lea     $20(a7), a7
    clr.w   d5
    bra.w   .l24ffa
.l25116:
    move.w  d6, d0
    andi.w  #$10, d0
    beq.b   .l2512e
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   .l2524a
.l2512e:
    move.w  d6, d0
    andi.w  #$1, d0
    beq.b   .l251b2
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d5
    subq.w  #$1, d2
    tst.w   d2
    bge.w   .l24ffa
    cmpi.w  #$5, d4
    ble.b   .l251ac
    moveq   #$4,d2
    subq.w  #$5, d3
    tst.w   d3
    bge.b   .l2515e
    move.w  -$2(a6), d3
    move.w  -$6(a6), d2
.l2515e:
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000C).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    jsr PreLoopInit
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $20(a7), a7
.l2518c:
    move.l  a5, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FA6E                                 ; bsr.w $024C10
    lea     $10(a7), a7
    bra.w   .l24ffa
.l251ac:
    clr.w   d2
    bra.w   .l24ffa
.l251b2:
    move.w  d6, d0
    andi.w  #$2, d0
    beq.w   .l24ffa
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d5
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bgt.b   .l251e2
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l25240
.l251e2:
    cmpi.w  #$5, d4
    ble.b   .l25214
    clr.w   d2
    addq.w  #$5, d3
    cmp.w   d4, d3
    ble.b   .l251f4
    clr.w   d3
    clr.w   d2
.l251f4:
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000C).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   .l2518c
.l25214:
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    bge.b   .l25234
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    bra.b   .l2523a
.l25234:
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
.l2523a:
    move.w  d0, d2
    bra.w   .l24ffa
.l25240:
    cmpi.w  #$5, d4
    bge.w   .l24ffa
    bra.b   .l25214
.l2524a:
    movem.l -$54(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; InitMainGameS2 -- (TODO: name)
; 1446 bytes | $025254-$0257F9
; ============================================================================
InitMainGameS2:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d4
    movea.l  #$00000D64,a3
    lea     -$20(a6), a4
    lea     -$2(a6), a5
    moveq   #$1,d3
    jsr PreLoopInit
    pea     ($001E).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0680                                 ; jsr $025918(pc)
    nop
    clr.l   -(a7)
    jsr ReadInput
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   .l252b0
    moveq   #$1,d7
    bra.b   .l252b2
.l252b0:
    moveq   #$0,d7
.l252b2:
    clr.w   (a5)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d5
    clr.w   -$22(a6)
.l252c6:
    cmpi.w  #$1, d3
    bne.w   .l2541c
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    jsr ResourceLoad
    pea     ($0002).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $2c(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0001).w
    pea     ($0003).w
    jsr SetTextCursor
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0005F912,a0
    move.l  (a0,d0.l), -(a7)
    jsr PrintfWide
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0017).w
    jsr LoadSlotGraphics
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0007).w
    pea     ($00B8).w
    pea     ($0004).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000F).w
    pea     ($00B8).w
    pea     ($0005).w
    pea     ($0771).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    jsr ResourceUnload
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$03EA                                 ; jsr $0257FA(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d6
    clr.w   d3
.l2541c:
    tst.w   d7
    beq.b   .l2543e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l2543e
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l252c6
.l2543e:
    clr.w   d7
    addq.w  #$1, -$22(a6)
    cmpi.w  #$1, -$22(a6)
    bne.b   .l254b4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000C).w
    pea     ($0010).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000C).w
    pea     ($00B0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l254a6:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.b   .l254da
.l254b4:
    cmpi.w  #$28a, -$22(a6)
    bne.b   .l254ce
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l254a6
.l254ce:
    cmpi.w  #$514, -$22(a6)
    bne.b   .l254da
    clr.w   -$22(a6)
.l254da:
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3f, d0
    move.w  d0, (a5)
    andi.w  #$20, d0
    beq.w   .l25738
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    tst.w   d6
    ble.w   .l2570c
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($0004).w
    pea     ($0010).w
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0001).w
    pea     ($0005).w
    pea     ($0010).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    pea     ($0017).w
    jsr SetTextWindow
    lea     $1c(a7), a7
    cmpi.w  #$2, d2
    bne.b   .l2557a
    pea     ($000413D8).l
    jsr PrintfNarrow
    addq.l  #$4, a7
    bra.b   .l25596
.l2557a:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000413D4).l
    jsr PrintfNarrow
    addq.l  #$8, a7
.l25596:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CollectPlayerChars
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$05A6                                 ; jsr $025B62(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d6
    cmpi.w  #$ff, d0
    beq.w   .l25664
    move.w  d6, d0
    mulu.w  #$a, d0
    add.w   d0, d0
    movea.l  #$00FF1A04,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  $4(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharCompare
    lea     $10(a7), a7
    moveq   #$1,d3
.l2560a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   .l2560a
.l2561a:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$30, d0
    beq.b   .l2561a
    jsr ResourceLoad
    move.l  #$8000, -(a7)
    pea     ($0013).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $28(a7), a7
    bra.b   .l2566c
.l25664:
    moveq   #$1,d3
    jsr ResourceLoad
.l2566c:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0017).w
    jsr LoadSlotGraphics
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0007).w
    pea     ($00B8).w
    pea     ($0004).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000F).w
    pea     ($00B8).w
    pea     ($0005).w
    pea     ($0771).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    bra.b   .l2570e
.l2570c:
    moveq   #$1,d3
.l2570e:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00D0                                 ; jsr $0257FA(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d6
    bra.w   .l252c6
.l25738:
    move.w  (a5), d0
    andi.w  #$10, d0
    beq.b   .l25750
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   .l257f0
.l25750:
    move.w  (a5), d0
    andi.w  #$8, d0
    beq.b   .l25776
    move.w  #$1, ($00FF13FC).l
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
.l25766:
    moveq   #$5,d1
    jsr SignedMod
    move.w  d0, d5
.l25770:
    moveq   #$1,d3
    bra.w   .l252c6
.l25776:
    move.w  (a5), d0
    andi.w  #$4, d0
    beq.b   .l2578e
    move.w  #$1, ($00FF13FC).l
    move.w  d5, d0
    ext.l   d0
    addq.l  #$4, d0
    bra.b   .l25766
.l2578e:
    move.w  (a5), d0
    andi.w  #$2, d0
    beq.b   .l257d6
    move.w  #$1, ($00FF13FC).l
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
.l257a4:
    moveq   #$7,d1
    jsr SignedMod
    move.w  d0, d2
    pea     ($001E).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$014C                                 ; jsr $025918(pc)
    nop
    lea     $18(a7), a7
    bra.b   .l25770
.l257d6:
    move.w  (a5), d0
    andi.w  #$1, d0
    beq.w   .l252c6
    move.w  #$1, ($00FF13FC).l
    move.w  d2, d0
    ext.l   d0
    addq.l  #$6, d0
    bra.b   .l257a4
.l257f0:
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; LoadRouteMapDisplay -- (TODO: name)
; 286 bytes | $0257FA-$025917
; ============================================================================
LoadRouteMapDisplay:
    link    a6,#-$3C
    movem.l d2-d7/a2-a4, -(a7)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767DE).l
    jsr DisplaySetup
    lea     $c(a7), a7
    move.w  #$640, d4
    moveq   #$3,d5
    moveq   #$3,d7
    clr.w   d6
    move.w  $12(a6), d0
    add.w   d0, d0
    movea.l  #$0005F908,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d3
    move.b  (a4), d3
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   $14(a6), d0
    movea.l d0, a3
    bra.w   .l258fc
.l2584a:
    cmpi.w  #$1, $1a(a6)
    bne.b   .l258c4
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($001E).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     -$3c(a6), a2
    clr.w   d2
.l2588a:
    move.w  d4, d0
    add.w   d2, d0
    ori.w   #$4000, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   .l2588a
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
.l258c4:
    move.w  d7, d0
    ext.l   d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000413E6).l
    jsr PrintfNarrow
    lea     $10(a7), a7
    add.w   (a3), d6
    addi.w  #$1e, d4
    addq.w  #$7, d5
    addq.l  #$2, a3
    addq.w  #$1, d3
.l258fc:
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    cmp.l   d1, d0
    ble.w   .l2584a
    move.w  d6, d0
    movem.l -$60(a6), d2-d7/a2-a4
    unlk    a6
    rts

; ============================================================================
; UpdateCharOccupancy -- (TODO: name)
; 228 bytes | $025918-$0259FB
; ============================================================================
UpdateCharOccupancy:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d7
    movea.l $30(a7), a4
    move.w  $2e(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d3
    moveq   #$0,d4
    move.b  (a1), d4
    moveq   #$0,d5
    move.b  $1(a1), d5
    move.w  d4, d6
    ext.l   d6
    move.l  d6, d0
    add.l   d6, d6
    add.l   d0, d6
    add.l   d6, d6
    bra.b   .l25992
.l25950:
    movea.l  #$00FF1704,a0
    lea     (a0,d6.w), a3
    movea.l  #$00FF0420,a0
    lea     (a0,d6.w), a2
    clr.w   d2
.l25966:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l25980
    addq.w  #$1, d3
    moveq   #$0,d0
    move.b  (a3), d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
.l25980:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   .l25966
    addq.l  #$6, d6
    subq.w  #$1, d5
    addq.w  #$1, d4
.l25992:
    tst.w   d5
    bgt.b   .l25950
    moveq   #$0,d4
    move.b  $2(a1), d4
    moveq   #$0,d5
    move.b  $3(a1), d5
    bra.b   .l259f0
.l259a4:
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l259c6:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l259e0
    addq.w  #$1, d3
    moveq   #$0,d0
    move.b  (a3), d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
.l259e0:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l259c6
    subq.w  #$1, d5
    addq.w  #$1, d4
.l259f0:
    tst.w   d5
    bgt.b   .l259a4
    move.w  d3, d0
    movem.l (a7)+, d2-d7/a2-a4
    rts

; ============================================================================
; RenderPlayerDataDisplay -- (TODO: name)
; 358 bytes | $0259FC-$025B61
; ============================================================================
RenderPlayerDataDisplay:
    link    a6,#-$C
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d6
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    lea     -$a(a6), a2
    move.w  d4, d5
    mulu.w  #$a, d5
    move.w  d6, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$5,d1
    cmp.l   d0, d1
    ble.b   .l25a3e
    move.w  d6, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    bra.b   .l25a40
.l25a3e:
    moveq   #$5,d0
.l25a40:
    move.w  d0, d6
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($000B).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $2c(a7), a7
    pea     ($0009).w
    pea     ($0002).w
    jsr     (a4)
    pea     ($00041408).l
    jsr     (a3)
    pea     ($0009).w
    pea     ($000D).w
    jsr     (a4)
    pea     ($000413FE).l
    jsr     (a3)
    pea     ($0009).w
    pea     ($0019).w
    jsr     (a4)
    pea     ($000413F8).l
    jsr     (a3)
    lea     $24(a7), a7
    clr.w   d3
    moveq   #$B,d2
    bra.w   .l25b52
.l25aba:
    pea     ($000A).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00FF1A04,a0
    pea     (a0, d0.w)
    clr.l   -(a7)
    jsr MemCopy
    addi.w  #$a, d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    jsr     (a4)
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000413F4).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000D).w
    jsr     (a4)
    lea     $2c(a7), a7
    move.w  $4(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E2DE,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000413F0).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0016).w
    jsr     (a4)
    move.l  $6(a2), d0
    lsr.l   #$2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000413EA).l
    jsr     (a3)
    lea     $18(a7), a7
    addq.w  #$1, d4
    addq.w  #$1, d3
    addq.w  #$2, d2
.l25b52:
    cmp.w   d6, d3
    blt.w   .l25aba
    movem.l -$2c(a6), d2-d6/a2-a4
    unlk    a6
    rts

; ============================================================================
; HandleRouteSelectionS2 -- (TODO: name)
; 738 bytes | $025B62-$025E43
; ============================================================================
HandleRouteSelectionS2:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d4
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    movea.l  #$00FF13FC,a4
    lea     -$c(a6), a5
    moveq   #$1,d7
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l25b98
    moveq   #$1,d0
    bra.b   .l25b9a
.l25b98:
    moveq   #$0,d0
.l25b9a:
    move.w  d0, -$a(a6)
    clr.w   d5
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    clr.w   d3
    clr.w   d2
    clr.w   d6
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedDiv
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    move.l  d0, -$4(a6)
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    subq.l  #$1, d0
    move.l  d0, -$8(a6)
.l25bd6:
    cmpi.w  #$1, d7
    bne.b   .l25c10
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FDF4                                 ; bsr.w $0259FC
    lea     $2c(a7), a7
    clr.w   d7
.l25c10:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$58, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0773).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $2c(a7), a7
    tst.w   -$a(a6)
    beq.b   .l25c66
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l25bd6
.l25c66:
    clr.w   -$a(a6)
    cmpi.w  #$5, d4
    ble.w   .l25d14
    move.w  d4, d0
    sub.w   d3, d0
    move.w  d0, (a5)
    cmpi.w  #$5, (a5)
    ble.b   .l25c82
    move.w  #$5, (a5)
.l25c82:
    addq.w  #$1, d6
    cmpi.w  #$1, d6
    bne.b   .l25cf4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0050).w
    pea     ($00F0).w
    pea     ($0039).w
    pea     ($0770).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$54, d0
    move.l  d0, -(a7)
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0771).w
    jsr     (a3)
    lea     $1c(a7), a7
.l25ce6:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   .l25d14
.l25cf4:
    cmpi.w  #$f, d6
    bne.b   .l25d0c
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l25ce6
.l25d0c:
    cmpi.w  #$1e, d6
    bne.b   .l25d14
    clr.w   d6
.l25d14:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$30, d0
    beq.b   .l25d4c
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    andi.w  #$20, d0
    beq.w   .l25df6
    move.w  d3, d0
    add.w   d2, d0
    move.w  d0, d2
    bra.w   .l25dfa
.l25d4c:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l25dc2
    move.w  #$1, (a4)
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bgt.b   .l25d74
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l25db8
.l25d74:
    cmpi.w  #$5, d4
    ble.b   .l25d8c
    clr.w   d2
    addq.w  #$5, d3
    cmp.w   d4, d3
    ble.b   .l25d86
    clr.w   d3
    clr.w   d2
.l25d86:
    moveq   #$1,d7
    bra.w   .l25bd6
.l25d8c:
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    bge.b   .l25dac
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    bra.b   .l25db2
.l25dac:
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
.l25db2:
    move.w  d0, d2
    bra.w   .l25bd6
.l25db8:
    cmpi.w  #$5, d4
    bge.w   .l25bd6
    bra.b   .l25d8c
.l25dc2:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.w   .l25bd6
    move.w  #$1, (a4)
    subq.w  #$1, d2
    tst.w   d2
    bge.w   .l25bd6
    cmpi.w  #$5, d4
    ble.b   .l25df0
    moveq   #$4,d2
    subq.w  #$5, d3
    tst.w   d3
    bge.b   .l25d86
    move.w  -$2(a6), d3
    move.w  -$6(a6), d2
    bra.b   .l25d86
.l25df0:
    clr.w   d2
    bra.w   .l25bd6
.l25df6:
    move.w  #$ff, d2
.l25dfa:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0009).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    move.w  d2, d0
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; DisplayPlayerStatsScreen -- (TODO: name)
; 686 bytes | $025E44-$0260F1
; ============================================================================
DisplayPlayerStatsScreen:
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $20(a7), d2
    movea.l  #$0003B246,a4
    movea.l  #$0003AB2C,a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    jsr ResourceLoad
    jsr PreLoopInit
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A598).l
    jsr DisplaySetup
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $24(a7), a7
    move.w  ($00FF0004).l, d4
    addq.w  #$4, d4
    pea     ($0017).w
    pea     ($0018).w
    pea     ($0001).w
    pea     ($0004).w
    jsr DrawBox
    pea     ($0002).w
    pea     ($0006).w
    jsr     (a5)
    pea     ($000414DA).l
    jsr     (a4)
    pea     ($0009).w
    pea     ($0015).w
    pea     ($0004).w
    pea     ($0006).w
    jsr SetTextWindow
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041498).l
    jsr     (a4)
    pea     ($0009).w
    pea     ($0006).w
    jsr     (a5)
    lea     $10(a7), a7
    cmpi.w  #$7, d4
    bge.b   .l25f52
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041476).l
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l25f5c
.l25f52:
    pea     ($00041452).l
    jsr     (a4)
    addq.l  #$4, a7
.l25f5c:
    pea     ($000B).w
    pea     ($0006).w
    jsr     (a5)
    pea     ($00041438).l
    jsr     (a4)
    pea     ($0004).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041436).l
    jsr     (a4)
    pea     ($0006).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041434).l
    jsr     (a4)
    pea     ($0009).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041432).l
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($000B).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041430).l
    jsr     (a4)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $1c(a7), a7
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0130,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
.l25ff2:
    moveq   #$5,d4
    move.w  d2, d3
    addi.w  #$e, d3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    cmpi.w  #$2, d2
    bne.b   .l26016
    pea     ($0004141C).l
    bra.b   .l26024
.l26016:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
.l26024:
    pea     ($0004142C).l
    jsr     (a4)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$11, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $18(a7), a7
    tst.l   (a3)
    ble.b   .l2605a
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($00041418).l
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l26064
.l2605a:
    pea     ($00041414).l
    jsr     (a4)
    addq.l  #$4, a7
.l26064:
    addq.l  #$1, a2
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.w   .l25ff2
    move.w  ($00FF0002).l, d2
    mulu.w  #$f, d2
    addi.w  #$7a3, d2
    pea     ($0016).w
    pea     ($0005).w
    jsr     (a5)
    move.w  ($00FF0004).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0005F6DE,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a4)
    pea     ($0016).w
    pea     ($0010).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004140E).l
    jsr     (a4)
    lea     $20(a7), a7
    jsr ResourceUnload
.l260ce:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$30, d0
    beq.b   .l260ce
    jsr ResourceLoad
    movem.l (a7)+, d2-d4/a2-a5
    rts

; ============================================================================
; WaitForAButtonPress -- (TODO: name)
; 54 bytes | $0260F2-$026127
; ============================================================================
WaitForAButtonPress:
    jsr PreLoopInit
    jsr ShowGameStatus
    pea     ($0014).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
.l2610e:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   .l2610e
    rts

; ============================================================================
; GameUpdate4 -- (TODO: name)
; 128 bytes | $026128-$0261A7
; ============================================================================
GameUpdate4:
    movem.l d2/a2, -(a7)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    lea     $c(a7), a7
    dc.w    $4EBA,$0066                                 ; jsr $0261A8(pc)
    nop
    dc.w    $4EBA,$019C                                 ; jsr $0262E4(pc)
    nop
    dc.w    $4EBA,$0296                                 ; jsr $0263E4(pc)
    nop
    dc.w    $4EBA,$14A2                                 ; jsr $0275F6(pc)
    nop
    movea.l  #$00FF0018,a2
    clr.w   d2
.l26160:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2617a
    dc.w    $4EBA,$14C6                                 ; jsr $02763C(pc)
    nop
.l2617a:
    cmpi.b  #$60, $22(a2)
    bhi.b   .l26190
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$174E                                 ; jsr $0278D8(pc)
    nop
    addq.l  #$4, a7
.l26190:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l26160
    jsr ResourceLoad
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; CalculatePlayerWealth -- (TODO: name)
; 200 bytes | $0261A8-$02626F
; ============================================================================
CalculatePlayerWealth:
    link    a6,#-$4
    movem.l d2-d3/a2-a5, -(a7)
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l261ee
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF00E8).l
    jsr MemFillByte
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF0130).l
    jsr MemFillByte
    lea     $18(a7), a7
.l261ee:
    move.l  #$ff0018, -$4(a6)
    movea.l  #$00FF00E8,a4
    movea.l  #$00FF09A2,a5
    movea.l  #$00FF01B0,a3
    movea.l  #$00FF0130,a2
    clr.w   d3
.l26210:
    movea.l -$4(a6), a0
    move.l  $12(a0), d0
    add.l   d0, $8(a4)
    movea.l -$4(a6), a0
    move.l  $a(a0), d2
    add.l   (a5), d2
    add.l   d2, (a4)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0040                                 ; jsr $026270(pc)
    nop
    addq.l  #$4, a7
    add.l   $4(a5), d0
    move.l  d0, d2
    add.l   d2, $4(a4)
    clr.w   d2
.l26242:
    move.l  (a3), d0
    add.l   d0, (a2)
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    bcs.b   .l26242
    moveq   #$24,d0
    add.l   d0, -$4(a6)
    moveq   #$C,d0
    adda.l  d0, a4
    addq.l  #$8, a5
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l26210
    movem.l -$1c(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; CalcPlayerWealth -- (TODO: describe)
; Called: ?? times.
; 116 bytes | $026270-$0262E3
; ============================================================================
CalcPlayerWealth:                                                  ; $026270
    movem.l d2/a2-a3,-(sp)
    move.l  $0010(sp),d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    move.w  d2,d0
    mulu.w  #$6,d0
    movea.l #$00ff0290,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$c,d0
    movea.l #$00ff03f0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d2
    move.w  (a3),d2
    add.l   $000e(a1),d2
    moveq   #$0,d0
    move.w  $0002(a3),d0
    add.l   d0,d2
    moveq   #$0,d0
    move.w  $0004(a3),d0
    add.l   d0,d2
    moveq   #$0,d0
    move.w  (a2),d0
    moveq   #$0,d1
    move.w  $0002(a2),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  $0004(a2),d1
    add.l   d1,d0
    add.l   d0,d2
    move.l  d2,d0
    movem.l (sp)+,d2/a2-a3
    rts
CalcPlayerRankings:                                                  ; $0262E4
    link    a6,#-$8
    movem.l d2-d3/a2-a4,-(sp)
    movea.l #$00ff0270,a2
    movea.l #$00ffbe00,a3
    clr.w   d3
.l262fa:                                                ; $0262FA
    clr.w   d2
.l262fc:                                                ; $0262FC
    move.b  #$01,(a2)
    move.w  #$1,(a3)
    addq.l  #$1,a2
    addq.l  #$2,a3
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    bcs.b   .l262fc
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    bcs.b   .l262fa
    move.l  #$00ff00e8,-$0004(a6)
    clr.w   d3
.l26322:                                                ; $026322
    move.l  #$00ff00e8,-$0008(a6)
    clr.w   d1
.l2632c:                                                ; $02632C
    cmp.w   d1,d3
    beq.w   .l263ba
    move.w  d3,d0
    lsl.w   #$3,d0
    movea.l #$00ff0270,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    lsl.w   #$4,d0
    movea.l #$00ffbe00,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    lsl.w   #$5,d0
    movea.l #$00ff0130,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    move.w  d1,d0
    lsl.w   #$5,d0
    movea.l #$00ff0130,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d2
.l26374:                                                ; $026374
    move.l  (a1),d0
    cmp.l   (a4),d0
    bcc.b   .l26380
    addq.b  #$01,(a2)
    addq.w  #$1,(a3)
    bra.b   .l263aa
.l26380:                                                ; $026380
    move.l  (a1),d0
    cmp.l   (a4),d0
    bne.b   .l263aa
    addq.w  #$1,(a3)
    movea.l -$0004(a6),a0
    move.l  (a0),d0
    movea.l -$0008(a6),a0
    cmp.l   (a0),d0
    bcs.b   .l263a8
    movea.l -$0004(a6),a0
    move.l  (a0),d0
    movea.l -$0008(a6),a0
    cmp.l   (a0),d0
    bne.b   .l263aa
    cmp.w   d1,d3
    bls.b   .l263aa
.l263a8:                                                ; $0263A8
    addq.b  #$01,(a2)
.l263aa:                                                ; $0263AA
    addq.l  #$1,a2
    addq.l  #$2,a3
    addq.l  #$4,a1
    addq.l  #$4,a4
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    bcs.b   .l26374
.l263ba:                                                ; $0263BA
    moveq   #$c,d0
    add.l   d0,-$0008(a6)
    addq.w  #$1,d1
    cmpi.w  #$4,d1
    bcs.w   .l2632c
    moveq   #$c,d0
    add.l   d0,-$0004(a6)
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    bcs.w   .l26322
    movem.l -$001c(a6),d2-d3/a2-a4
    unlk    a6
    rts
; === Translated block $0263E4-$027184 ===
; 2 functions, 3488 bytes

; ============================================================================
; UpdatePlayerStatusDisplay -- (TODO: name)
; 374 bytes | $0263E4-$026559
; ============================================================================
UpdatePlayerStatusDisplay:
    link    a6,#$0
    movem.l d2-d7/a2-a4, -(a7)
    movea.l  #$00FF0018,a4
    movea.l  #$00FF09A2,a3
    movea.l  #$00FF99E0,a2
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF99E0).l
    jsr MemFillByte
    lea     $c(a7), a7
    moveq   #$0,d3
    moveq   #$0,d6
    clr.w   d2
l_2641a:
    move.l  $a(a4), d0
    add.l   (a3), d0
    add.l   d0, (a2)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FE46                                 ; bsr.w $026270
    addq.l  #$4, a7
    add.l   $4(a3), d0
    add.l   d0, $4(a2)
    cmp.l   (a2), d3
    bls.b   l_2643e
    move.l  d3, d0
    bra.b   l_26440
l_2643e:
    move.l  (a2), d0
l_26440:
    move.l  d0, d3
    cmp.l   $4(a2), d3
    bls.b   l_2644c
    move.l  d3, d0
    bra.b   l_26450
l_2644c:
    move.l  $4(a2), d0
l_26450:
    move.l  d0, d3
    move.l  $12(a4), $8(a2)
    cmp.l   $8(a2), d6
    bls.b   l_26462
    move.l  d6, d0
    bra.b   l_26466
l_26462:
    move.l  $8(a2), d0
l_26466:
    move.l  d0, d6
    moveq   #$24,d0
    adda.l  d0, a4
    addq.l  #$8, a3
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_2641a
    dc.w    $4EBA,$00DE                                 ; jsr $02655A(pc)
    nop
    moveq   #$4,d2
    moveq   #$1,d5
    clr.w   d7
l_26486:
    cmpi.w  #$5, d2
    bcc.b   l_264a8
    move.l  d6, -(a7)
    move.l  d3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00FA                                 ; jsr $026598(pc)
    nop
    lea     $10(a7), a7
    bra.b   l_264b0
l_264a8:
    dc.w    $4EBA,$0D1C                                 ; jsr $0271C6(pc)
    nop
    moveq   #$1,d7
l_264b0:
    cmpi.w  #$4, d2
    bls.b   l_264d2
l_264b6:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$30, d0
    beq.b   l_264b6
    bra.b   l_264ec
l_264d2:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$33, d0
    beq.b   l_264d2
l_264ec:
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_26504
    cmpi.w  #$5, d2
    bne.b   l_26500
    moveq   #$4,d2
    moveq   #$1,d5
    bra.b   l_26486
l_26500:
    moveq   #$5,d2
    bra.b   l_26486
l_26504:
    move.w  d4, d0
    andi.w  #$10, d0
    beq.b   l_26512
    tst.w   d7
    bne.b   l_26544
    bra.b   l_26500
l_26512:
    move.w  d4, d0
    andi.w  #$1, d0
    beq.b   l_2652a
    tst.w   d2
    bne.b   l_26522
    moveq   #$4,d2
    bra.b   l_26524
l_26522:
    subq.w  #$1, d2
l_26524:
    clr.w   d5
    bra.w   l_26486
l_2652a:
    move.w  d4, d0
    andi.w  #$2, d0
    beq.w   l_26486
    cmpi.w  #$4, d2
    bne.b   l_2653e
    clr.w   d2
    bra.b   l_26524
l_2653e:
    addq.w  #$1, d2
    bra.b   l_26524
    bra.b   l_26550
l_26544:
    jsr ResourceLoad
    jsr ClearBothPlanes
l_26550:
    movem.l -$24(a6), d2-d7/a2-a4
    unlk    a6
    rts

; ============================================================================
; InitLeaderboardData -- (TODO: name)
; 62 bytes | $02655A-$026597
; ============================================================================
InitLeaderboardData:
    movem.l d2/a2-a3, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF14B0).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF99E0,a3
    movea.l  #$00FF14B0,a2
    clr.w   d2
l_26582:
    move.w  d2, (a2)
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_26582
    movem.l (a7)+, d2/a2-a3
    rts


; === Translated block $026598-$027184 ===
; 5 functions, 3052 bytes

; ============================================================================
; RenderQuarterReport -- (TODO: name)
; 1176 bytes | $026598-$026A2F
; ============================================================================
RenderQuarterReport:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d5
    move.l  $14(a6), d6
    move.l  $8(a6), d7
    movea.l  #$0003B270,a4
    movea.l  #$00000D64,a5
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_265c4
    addq.l  #$3, d0
l_265c4:
    asr.l   #$2, d0
    addi.w  #$7a3, d0
    move.w  d0, d2
    cmpi.w  #$1, d7
    bne.w   l_26850
    jsr ResourceLoad
    jsr ClearTileArea
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    pea     ($00041560).l
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A9E).l
    jsr DisplaySetup
    move.l  ($000A1B68).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0015).w
    pea     ($030F).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($00073378).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    move.l  ($000A1B24).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($001A).w
    pea     ($0324).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($0004).w
    pea     ($0021).w
    pea     ($00FF0118).l
    jsr DisplaySetup
    pea     ($0001).w
    pea     ($0016).w
    jsr SetTextCursor
    lea     $14(a7), a7
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.b   l_26726
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0008
    dc.w    $0010
    dc.w    $0018
    dc.w    $0020
    pea     ($0004155C).l
    bra.b   l_26722
    pea     ($00041558).l
    bra.b   l_26722
    pea     ($00041554).l
    bra.b   l_26722
    pea     ($00041550).l
l_26722:
    jsr     (a4)
    addq.l  #$4, a7
l_26726:
    pea     ($0001).w
    pea     ($001A).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0004154C).l
    jsr     (a4)
    lea     $10(a7), a7
    movea.l  #$00FF0018,a2
    movea.l  #$00FF14B0,a3
    clr.w   d2
    moveq   #$0,d3
    move.w  d2, d3
    move.l  d3, d0
    add.l   d3, d3
    add.l   d0, d3
    add.l   d3, d3
l_26760:
    moveq   #$0,d4
    move.b  $2(a2), d4
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d4
    cmpi.w  #$1, d4
    ble.b   l_2677c
    pea     ($0007257E).l
    bra.b   l_26782
l_2677c:
    pea     ($00072524).l
l_26782:
    pea     ($0005).w
    pea     ($0009).w
    move.l  d3, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$754, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0007).w
    move.l  d3, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    jsr FillTileRect
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0005).w
    jsr SetTextCursor
    moveq   #$0,d4
    move.b  $2(a2), d4
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041548).l
    jsr     (a4)
    lea     $10(a7), a7
    moveq   #$24,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.l  #$6, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_26760
    bra.b   l_2687e
l_26850:
    move.l  #$8000, -(a7)
    pea     ($0018).w
    pea     ($0014).w
    pea     ($0004).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    lea     $28(a7), a7
l_2687e:
    moveq   #$0,d0
    move.w  $e(a6), d0
    moveq   #$4,d1
    cmp.l   d1, d0
    bhi.w   l_26a1a
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000A
    dc.w    $0050
    dc.w    $0096
    dc.w    $00DC
    dc.w    $011E
    pea     ($0001).w
    move.l  d5, -(a7)
    dc.w    $4EBA,$0188                                 ; jsr $026A30(pc)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041536).l
    bra.w   l_26a16
    pea     ($0001).w
    move.l  d5, -(a7)
    dc.w    $4EBA,$026A                                 ; jsr $026B58(pc)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041524).l
    bra.w   l_26a16
    pea     ($0001).w
    move.l  d6, -(a7)
    dc.w    $4EBA,$02E0                                 ; jsr $026C14(pc)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041512).l
    bra.w   l_26a16
    pea     ($0001).w
    dc.w    $4EBA,$0360                                 ; jsr $026CD8(pc)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $28(a7), a7
    pea     ($00041500).l
    bra.b   l_26a16
    clr.l   -(a7)
    move.l  d5, -(a7)
    dc.w    $4EBA,$0076                                 ; jsr $026A30(pc)
    nop
    pea     ($0001).w
    move.l  d5, -(a7)
    dc.w    $4EBA,$0192                                 ; jsr $026B58(pc)
    nop
    clr.l   -(a7)
    move.l  d6, -(a7)
    dc.w    $4EBA,$0244                                 ; jsr $026C14(pc)
    nop
    clr.l   -(a7)
    dc.w    $4EBA,$0300                                 ; jsr $026CD8(pc)
    nop
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $24(a7), a7
    pea     ($000414EE).l
l_26a16:
    jsr     (a4)
    addq.l  #$4, a7
l_26a1a:
    cmpi.w  #$1, d7
    bne.b   l_26a26
    jsr ResourceUnload
l_26a26:
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; DisplayRouteCargoInfo -- (TODO: name)
; 296 bytes | $026A30-$026B57
; ============================================================================
DisplayRouteCargoInfo:
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $24(a7), d5
    move.l  $28(a7), d7
    movea.l  #$00FF99E0,a2
    movea.l  #$00FF14B0,a3
    cmpi.w  #$1, d7
    moveq   #$1,d6
    clr.w   d4
    moveq   #$0,d0
    move.w  d4, d0
    add.l   d0, d0
    lea     (a3,d0.l), a0
    movea.l a0, a3
l_26a5c:
    move.l  (a2), d2
    sub.l   $4(a2), d2
    cmpi.w  #$1, d7
    bne.b   l_26a94
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    move.l  d2, -(a7)
    pea     ($00041572).l
    jsr PrintfNarrow
    lea     $10(a7), a7
l_26a94:
    tst.l   d5
    beq.w   l_26b42
    move.l  $4(a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d5, d1
    jsr UnsignedDivide
    move.w  d0, d2
    tst.w   d2
    ble.b   l_26aea
    pea     ($0759).w
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    clr.l   -(a7)
    jsr FillTileRect
    lea     $20(a7), a7
l_26aea:
    move.l  (a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d5, d1
    jsr UnsignedDivide
    move.w  d0, d3
    sub.w   d2, d3
    tst.w   d3
    ble.b   l_26b42
    pea     ($075A).w
    pea     ($0009).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr FillTileRect
    lea     $20(a7), a7
l_26b42:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_26a5c
    movem.l (a7)+, d2-d7/a2-a3
    rts

; ============================================================================
; ShowRoutePassengers -- (TODO: name)
; 188 bytes | $026B58-$026C13
; ============================================================================
ShowRoutePassengers:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d4
    move.l  $20(a7), d5
    movea.l  #$00FF99E0,a3
    movea.l  #$00FF14B0,a2
    clr.w   d2
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    movea.l a0, a2
l_26b7e:
    tst.l   d4
    beq.b   l_26bcc
    move.l  (a3), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d4, d1
    jsr UnsignedDivide
    move.w  d0, d3
    beq.b   l_26bcc
    pea     ($0758).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    clr.l   -(a7)
    jsr FillTileRect
    lea     $20(a7), a7
l_26bcc:
    cmpi.w  #$1, d5
    bne.b   l_26bfe
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    move.l  (a3), -(a7)
    pea     ($00041578).l
    jsr PrintfNarrow
    lea     $10(a7), a7
l_26bfe:
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_26b7e
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; DisplayRouteFunds -- (TODO: name)
; 196 bytes | $026C14-$026CD7
; ============================================================================
DisplayRouteFunds:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d4
    move.l  $20(a7), d5
    movea.l  #$00FF99E0,a3
    movea.l  #$00FF14B0,a2
    clr.w   d2
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    movea.l a0, a2
l_26c3a:
    cmpi.w  #$1, d5
    bne.b   l_26c8a
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    pea     ($0014).w
    jsr SetTextCursor
    move.l  $8(a3), -(a7)
    pea     ($0004157E).l
    jsr PrintfNarrow
    move.w  (a2), d0
    mulu.w  #$6, d0
    addq.w  #$6, d0
    move.l  d0, -(a7)
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr PlaceIconTiles
    lea     $20(a7), a7
l_26c8a:
    tst.l   d4
    beq.b   l_26cc2
    move.l  $8(a3), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d4, d1
    jsr UnsignedDivide
    move.w  d0, d3
    beq.b   l_26cc2
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    mulu.w  #$6, d0
    addq.w  #$7, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr DrawTileStrip
    lea     $c(a7), a7
l_26cc2:
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_26c3a
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; DrawQuarterResultsScreen -- (TODO: name)
; 1196 bytes | $026CD8-$027183
; ============================================================================
DrawQuarterResultsScreen:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF14B0,a5
    pea     ($0004E382).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0007).w
    pea     ($0308).w
    jsr VRAMBulkLoad
    pea     ($00FF1804).l
    pea     ($0007).w
    pea     ($0001).w
    pea     ($0640).w
    jsr DrawTileGrid
    lea     $2c(a7), a7
    movea.l  #$00FF0018,a2
    moveq   #$3F,d6
    clr.w   d7
    movea.l  #$0004E378,a4
    movea.l  #$0004E37A,a3
l_26d42:
    cmpi.w  #$1, $a(a6)
    bne.b   l_26d82
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d0
    andi.l  #$ffff, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    pea     ($00041584).l
    jsr PrintfWide
    lea     $c(a7), a7
l_26d82:
    moveq   #$50,d2
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d4
    mulu.w  #$30, d4
    addi.w  #$40, d4
    pea     ($0004E380).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26dae
    addq.l  #$7, d0
l_26dae:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26dba
    addq.l  #$7, d0
l_26dba:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    addq.w  #$4, d2
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$03B0                                 ; jsr $027184(pc)
    nop
    lea     $20(a7), a7
    move.w  d0, d5
    beq.w   l_26ec0
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0644).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    addq.w  #$4, d2
    clr.w   d3
    bra.b   l_26e60
l_26e26:
    pea     ($0004E37E).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26e3c
    addq.l  #$7, d0
l_26e3c:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26e48
    addq.l  #$7, d0
l_26e48:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_26e60:
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    bge.b   l_26e6a
    addq.l  #$1, d0
l_26e6a:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_26e26
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    moveq   #$2,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_26ec0
    pea     ($0004E37C).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26e9e
    addq.l  #$7, d0
l_26e9e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26eaa
    addq.l  #$7, d0
l_26eaa:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$4, d2
l_26ec0:
    moveq   #$0,d0
    move.b  $2(a2), d0
    sub.w   d5, d0
    addi.w  #$ffff, d0
    move.w  d0, d5
    tst.w   d5
    beq.b   l_26f36
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    jsr SignedMod
    tst.l   d0
    bne.b   l_26f36
    clr.w   d3
    bra.b   l_26f1c
l_26ee6:
    move.l  a3, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26ef8
    addq.l  #$7, d0
l_26ef8:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26f04
    addq.l  #$7, d0
l_26f04:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_26f1c:
    moveq   #$0,d0
    move.w  d5, d0
    bge.b   l_26f24
    addq.l  #$1, d0
l_26f24:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_26ee6
    moveq   #$0,d0
    move.w  d5, d0
    bra.w   l_26fd0
l_26f36:
    tst.w   d5
    beq.w   l_27012
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0642).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    addq.w  #$4, d2
    clr.w   d3
    bra.b   l_26fb6
l_26f80:
    move.l  a3, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26f92
    addq.l  #$7, d0
l_26f92:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26f9e
    addq.l  #$7, d0
l_26f9e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_26fb6:
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    bge.b   l_26fc0
    addq.l  #$1, d0
l_26fc0:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_26f80
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
l_26fd0:
    moveq   #$2,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_27012
    move.l  a4, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26ff0
    addq.l  #$7, d0
l_26ff0:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26ffc
    addq.l  #$7, d0
l_26ffc:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$4, d2
l_27012:
    tst.b   $3(a2)
    beq.b   l_27084
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    jsr SignedMod
    tst.l   d0
    bne.b   l_27084
    clr.w   d3
    bra.b   l_27066
l_2702c:
    pea     ($0004E376).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_27042
    addq.l  #$7, d0
l_27042:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_2704e
    addq.l  #$7, d0
l_2704e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_27066:
    moveq   #$0,d0
    move.b  $3(a2), d0
    bge.b   l_27070
    addq.l  #$1, d0
l_27070:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_2702c
    moveq   #$0,d0
    move.b  $3(a2), d0
    bra.w   l_27128
l_27084:
    tst.b   $3(a2)
    beq.w   l_2716c
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0640).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    addq.w  #$4, d2
    clr.w   d3
    bra.b   l_2710a
l_270d0:
    pea     ($0004E376).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_270e6
    addq.l  #$7, d0
l_270e6:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_270f2
    addq.l  #$7, d0
l_270f2:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_2710a:
    moveq   #$0,d0
    move.b  $3(a2), d0
    subq.l  #$1, d0
    bge.b   l_27116
    addq.l  #$1, d0
l_27116:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_270d0
    moveq   #$0,d0
    move.b  $3(a2), d0
    subq.l  #$1, d0
l_27128:
    moveq   #$2,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_2716c
    pea     ($0004E374).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_2714c
    addq.l  #$7, d0
l_2714c:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_27158
    addq.l  #$7, d0
l_27158:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
l_2716c:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d7
    cmpi.w  #$4, d7
    bcs.w   l_26d42
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts


; ============================================================================
; CountRouteFlags -- (TODO: describe)
; Called: ?? times.
; 66 bytes | $027184-$0271C5
; ============================================================================
CountRouteFlags:                                                  ; $027184
    movem.l d2-d4,-(sp)
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff08ec,a0
    move.l  (a0,d0.w),d4
    clr.w   d3
    tst.l   d4
    bne.b   .l271a2
    clr.w   d3
    bra.b   .l271be
.l271a2:                                                ; $0271A2
    clr.w   d2
.l271a4:                                                ; $0271A4
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    and.l   d4,d0
    beq.b   .l271b4
    addq.w  #$1,d3
.l271b4:                                                ; $0271B4
    addq.w  #$1,d2
    cmpi.w  #$20,d2
    bcs.b   .l271a4
    subq.w  #$1,d3
.l271be:                                                ; $0271BE
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
; ============================================================================
; ShowGameStatus -- (TODO: describe)
; Called: ?? times.
; 1072 bytes | $0271C6-$0275F5
; ============================================================================
ShowGameStatus:                                                  ; $0271C6
    link    a6,#-$e4
    movem.l d2-d5/a2-a5,-(sp)
    move.w  #$7c00,-$0002(a6)
    clr.w   -$0004(a6)
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    dc.w    $4eb9,$0000,$68ca                           ; jsr $0068CA
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $002c(sp),sp
    pea     ($0004).w
    pea     ($0021).w
    pea     ($00FF0118).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0001).w
    pea     ($0025).w
    pea     -$0002(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0001).w
    pea     ($0026).w
    pea     -$0004(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A9E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $0030(sp),sp
    move.l  ($000A1B68).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0015).w
    pea     ($030F).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($00073378).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l272c4
    addq.l  #$3,d0
.l272c4:                                                ; $0272C4
    asr.l   #$2,d0
    addi.w  #$07a3,d0
    move.w  d0,d2
    pea     ($0001).w
    pea     ($0005).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($00041598).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0010(sp),sp
    movea.l #$0005faa6,a2
    clr.w   d3
    move.w  d3,d0
    lsl.w   #$5,d0
    lea     -$00e4(a6),a0
    lea     (a0,d0.w),a1
    movea.l a1,a3
    moveq   #$0,d5
    move.w  d3,d5
    lsl.l   #$4,d5
    addi.l  #$0640,d5
.l27312:                                                ; $027312
    clr.w   d2
    move.w  d2,d4
    ext.l   d4
    add.l   d5,d4
.l2731a:                                                ; $02731A
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  d4,(a3,a0.l)
    addq.l  #$1,d4
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l2731a
    move.l  a3,-(sp)
    pea     ($0002).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    addi.w  #$fffe,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$2,d0
    movea.l #$000a1ac8,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0010).w
    move.l  d5,-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0030(sp),sp
    addq.l  #$2,a2
    moveq   #$10,d0
    add.l   d0,d5
    moveq   #$20,d0
    adda.l  d0,a3
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    bcs.w   .l27312
    movea.l #$00ff0018,a5
    clr.w   d2
.l273aa:                                                ; $0273AA
    moveq   #$0,d0
    move.b  $0001(a5),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d4
    movea.l #$0005faa6,a2
    move.w  d2,d0
    lsl.w   #$3,d0
    movea.l #$00ff0270,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    lsl.w   #$5,d0
    movea.l #$00ff0130,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d3
.l273e6:                                                ; $0273E6
    tst.l   (a4)
    beq.w   .l27492
    moveq   #$0,d0
    move.w  d2,d0
    addi.l  #$0754,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  (a4),-(sp)
    pea     ($00041592).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    addq.w  #$7,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
    lea     $0010(sp),sp
    bra.b   .l274ce
.l27492:                                                ; $027492
    pea     ($075C).w
    pea     ($0005).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
.l274ce:                                                ; $0274CE
    cmp.w   d4,d3
    bne.b   .l27522
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    lsl.w   #$3,d0
    addi.w  #$fff8,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$3,d0
    addi.w  #$fff8,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0760).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
.l27522:                                                ; $027522
    addq.l  #$2,a2
    addq.l  #$1,a3
    addq.l  #$4,a4
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    bcs.w   .l273e6
    moveq   #$24,d0
    adda.l  d0,a5
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.w   .l273aa
    movea.l #$0005fab4,a2
    clr.w   d2
    move.w  d2,d0
    lsl.w   #$3,d0
    movea.l #$00ff0277,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
.l27558:                                                ; $027558
    moveq   #$0,d0
    move.w  d2,d0
    addi.l  #$0754,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d1
    add.w   d1,d0
    addi.w  #$fffe,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d1
    add.w   d1,d0
    addi.w  #$fffe,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $002c(sp),sp
    addq.l  #$8,a3
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.w   .l27558
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    movem.l -$0104(a6),d2-d5/a2-a5
    unlk    a6
    rts
; === Translated block $0275F6-$027AA4 ===
; 4 functions, 1198 bytes

; ============================================================================
; UpdatePlayerHealthBars -- (TODO: name)
; 70 bytes | $0275F6-$02763B
; ============================================================================
UpdatePlayerHealthBars:
    movea.l  #$00FF0018,a0
    clr.w   d1
l_275fe:
    tst.l   $6(a0)
    blt.b   l_2761a
    cmpi.b  #$64, $22(a0)
    bls.b   l_27612
    addq.b  #$1, $22(a0)
    bra.b   l_2762e
l_27612:
    move.b  #$65, $22(a0)
    bra.b   l_2762e
l_2761a:
    cmpi.b  #$64, $22(a0)
    bcs.b   l_2762a
    move.b  #$63, $22(a0)
    bra.b   l_2762e
l_2762a:
    subq.b  #$1, $22(a0)
l_2762e:
    moveq   #$24,d0
    adda.l  d0, a0
    addq.w  #$1, d1
    cmpi.w  #$4, d1
    bcs.b   l_275fe
    rts

; ============================================================================
; CheckDisplayGameWin -- (TODO: name)
; 224 bytes | $02763C-$02771B
; ============================================================================
CheckDisplayGameWin:
    movem.l d2-d5/a2-a4, -(a7)
    move.w  ($00FF0004).l, d5
    addq.w  #$4, d5
    cmpi.w  #$7, d5
    bcc.b   l_27654
    moveq   #$0,d0
    move.w  d5, d0
    bra.b   l_27656
l_27654:
    moveq   #$7,d0
l_27656:
    move.w  d0, d5
    movea.l  #$00FF0018,a4
    clr.w   d4
    move.w  d4, d0
    lsl.w   #$4, d0
    movea.l  #$00FFBE00,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
l_27670:
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    cmpi.w  #$1, (a3,a0.l)
    bne.b   l_276e2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FAE8                                 ; bsr.w $027184
    addq.l  #$4, a7
    cmpi.w  #$6, d0
    bcs.b   l_276e2
    clr.w   d2
    movea.l a3, a2
    clr.w   d3
l_276ac:
    cmpi.w  #$1, (a2)
    bne.b   l_276b4
    addq.w  #$1, d2
l_276b4:
    addq.l  #$2, a2
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    bcs.b   l_276ac
    cmp.w   d5, d2
    bcs.b   l_276e2
    move.b  d4, ($00FF0016).l
    pea     ($0064).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0042                                 ; jsr $02771C(pc)
    nop
    lea     $c(a7), a7
l_276e2:
    moveq   #$24,d0
    adda.l  d0, a4
    moveq   #$10,d0
    adda.l  d0, a3
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_27670
    move.w  ($00FF0006).l, d0
    cmp.w   ($00FFA6B2).l, d0
    blt.b   l_27716
    jsr ClearBothPlanes
    pea     ($0004).w
    jsr ShowPlayerScreen
    addq.l  #$4, a7
l_27714:
    bra.b   l_27714
l_27716:
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; DisplayPlayerLeaderboard -- (TODO: name)
; 444 bytes | $02771C-$0278D7
; ============================================================================
DisplayPlayerLeaderboard:
    link    a6,#-$C8
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    lea     -$a0(a6), a3
    movea.l  #$0003B22C,a4
    movea.l  #$000482D8,a5
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.b  #$1, (a2)
    bne.w   l_278bc
    jsr ClearBothPlanes
    move.w  #$1, ($00FF000A).l
    move.w  #$1, ($00FF0008).l
    move.w  #$1, ($00FF000C).l
    move.w  #$1, ($00FF000E).l
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0001).w
    pea     ($0012).w
    jsr MenuSelectEntry
    lea     $24(a7), a7
    jsr ResourceUnload
    cmpi.w  #$7, d3
    bcs.b   l_277ca
    pea     ($000416D0).l
    bra.b   l_277e2
l_277ca:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  $1c(a5), -(a7)
    pea     -$c8(a6)
    jsr     (a4)
    lea     $c(a7), a7
    pea     -$c8(a6)
l_277e2:
    move.l  ($000482D8).l, -(a7)
    move.l  a3, -(a7)
    jsr     (a4)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $20(a7), a7
    clr.w   d3
    moveq   #$1,d2
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    bra.b   l_27876
l_2781a:
    move.w  d2, d0
    andi.w  #$1, d0
    beq.b   l_27836
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  (a2), -(a7)
    bra.b   l_27860
l_27836:
    move.w  d4, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  (a2), -(a7)
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
l_27860:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    addq.l  #$4, a2
    addq.w  #$1, d3
    addq.w  #$1, d2
l_27876:
    cmpi.w  #$4, d3
    blt.b   l_2781a
    moveq   #$5,d2
l_2787e:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_2787e
    pea     ($0014).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_278bc:
    jsr ClearBothPlanes
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowPlayerScreen
    movem.l -$e4(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; ManagePlayerInvoice -- (TODO: name)
; 460 bytes | $0278D8-$027AA3
; ============================================================================
ManagePlayerInvoice:
    link    a6,#-$C4
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d2
    lea     -$c0(a6), a3
    movea.l  #$00027ACA,a4
    movea.l  #$00007912,a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   (a2)
    bne.b   l_27918
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    bra.w   l_27a9a
l_27918:
    move.b  ($00FF0016).l, d4
    move.b  d2, ($00FF0016).l
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    pea     ($0013).w
    jsr MenuSelectEntry
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0004).w
    pea     ($000A).w
    pea     ($0018).w
    jsr LoadCompressedGfx
    jsr ResourceUnload
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    move.l  d0, d3
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00041718).l
    move.l  a3, -(a7)
    jsr sprintf
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($000416EC).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $28(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_27a4c
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($0012).w
    jsr MenuSelectEntry
    jsr ResourceLoad
    pea     ($0004).w
    pea     ($000A).w
    pea     ($0019).w
    jsr LoadCompressedGfx
    jsr ResourceUnload
    movea.l  #$00FF00A8,a0
    pea     (a0, d3.w)
    pea     ($000416D4).l
    move.l  a3, -(a7)
    jsr sprintf
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    bra.b   l_27a8e
l_27a4c:
    dc.w    $4EBA,$0056                                 ; jsr $027AA4(pc)
    nop
    cmpi.w  #$1, d0
    bls.b   l_27a6c
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    clr.b   (a2)
    subq.w  #$1, ($00FF0A34).l
    bra.b   l_27a8e
l_27a6c:
    clr.w   -$c2(a6)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$c2(a6)
    jsr DisplaySetup
    jsr PreLoopInit
    clr.l   -(a7)
    jsr GameSetup1
l_27a8e:
    jsr PreLoopInit
    move.b  d4, ($00FF0016).l
l_27a9a:
    movem.l -$e0(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; CountActivePlayers -- (TODO: describe)
; Called: ?? times.
; 38 bytes | $027AA4-$027AC9
; ============================================================================
CountActivePlayers:                                                  ; $027AA4
    move.l  d2,-(sp)
    clr.w   d1
    movea.l #$00ff0018,a0
    clr.w   d2
.l27ab0:                                                ; $027AB0
    cmpi.b  #$01,(a0)
    bne.b   .l27ab8
    addq.w  #$1,d1
.l27ab8:                                                ; $027AB8
    moveq   #$24,d0
    adda.l  d0,a0
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.b   .l27ab0
    move.w  d1,d0
    move.l  (sp)+,d2
    rts
    dc.w    $48E7,$3E30,$282F                                ; $027ACA
; === Translated block $027AD0-$027F18 ===
; 2 functions, 1096 bytes

; ============================================================================
; ProcessCharAnimationsS2 -- (TODO: name)
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
    dc.w    $4EBA,$000C                                 ; jsr $027D66(pc)
    nop
    addq.l  #$4, a7
    movem.l (a7)+, d2-d6/a2-a3
    rts

; ============================================================================
; InitQuarterStart -- (TODO: name)
; 434 bytes | $027D66-$027F17
; ============================================================================
InitQuarterStart:
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$0001D520,a4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.w   ($00FF0004).l
    bne.b   l_27d9e
    cmpi.b  #$1, (a2)
    bne.b   l_27d9e
    addi.l  #$30d40, $6(a2)
    bra.b   l_27da6
l_27d9e:
    addi.l  #$186a0, $6(a2)
l_27da6:
    cmpi.l  #$186a0, $6(a2)
    ble.b   l_27db6
    move.l  $6(a2), d0
    bra.b   l_27dbc
l_27db6:
    move.l  #$186a0, d0
l_27dbc:
    move.l  d0, $6(a2)
    clr.l   $a(a2)
    clr.l   $e(a2)
    clr.l   $12(a2)
    clr.l   $16(a2)
    clr.l   $1a(a2)
    clr.l   $1e(a2)
    move.b  #$64, $22(a2)
    pea     ($000C).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d4
    movea.l  #$00FF00E8,a0
    pea     (a0, d0.w)
    jsr     (a4)
    pea     ($0020).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    move.l  d0, d2
    movea.l  #$00FF0130,a0
    pea     (a0, d0.w)
    jsr     (a4)
    pea     ($0020).w
    clr.l   -(a7)
    movea.l  #$00FF01B0,a0
    pea     (a0, d2.w)
    jsr     (a4)
    dc.w    $6100,$E4B8                                 ; bsr.w $0262E4
    pea     ($0006).w
    clr.l   -(a7)
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0290,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $3(a3), $1(a2)
    move.b  $2(a3), $2(a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   l_27e84
    addq.l  #$1, d0
l_27e84:
    asr.l   #$1, d0
    moveq   #$64,d1
    cmp.l   d0, d1
    ble.b   l_27e9a
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   l_27e96
    addq.l  #$1, d0
l_27e96:
    asr.l   #$1, d0
    bra.b   l_27e9c
l_27e9a:
    moveq   #$64,d0
l_27e9c:
    move.b  d0, $3(a2)
    moveq   #$0,d2
    move.b  $1(a2), d2
    mulu.w  ($00FF999C).l, d2
    moveq   #$0,d0
    move.b  $2(a2), d0
    mulu.w  ($00FFBA68).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    mulu.w  ($00FF1288).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    move.b  d2, (a2)
    movea.l  #$00FF03F0,a0
    lea     (a0,d4.w), a2
    clr.w   (a2)
    clr.w   $2(a2)
    clr.w   $4(a2)
    clr.b   $9(a2)
    clr.b   $a(a2)
    clr.b   $b(a2)
    pea     ($0008).w
    clr.l   -(a7)
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FF09A2,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $c(a7), a7
    movem.l (a7)+, d2-d4/a2-a4
    rts

; ============================================================================
; BuildRouteLoop -- (TODO: describe)
; Called: ?? times.
; 220 bytes | $027F18-$027FF3
; ============================================================================
BuildRouteLoop:                                                  ; $027F18
    movem.l d2-d4/a2,-(sp)
    moveq   #$0,d4
    move.b  ($00FF0016).l,d4
    move.w  ($00FF9A1C).l,d3
.l27f2a:                                                ; $027F2A
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    lea     $0014(sp),sp
    move.w  d0,d2
    cmpi.w  #$4,d2
    bge.b   .l27f8e
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d2,d1
    lsl.w   #$3,d1
    add.w   d1,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    tst.b   $0001(a2)
    bne.b   .l27faa
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0070                                 ; jsr $027FF4
    nop
    lea     $000c(sp),sp
    bra.b   .l27fa8
.l27f8e:                                                ; $027F8E
    cmpi.w  #$4,d2
    bne.b   .l27faa
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05d4                                 ; jsr $028576
    nop
    addq.l  #$8,sp
.l27fa8:                                                ; $027FA8
    move.w  d0,d3
.l27faa:                                                ; $027FAA
    cmpi.w  #$ff,d2
    bne.w   .l27f2a
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $0018(sp),sp
    movem.l (sp)+,d2-d4/a2
    rts
; === Translated block $027FF4-$028B46 ===
; 5 functions, 2898 bytes

; ============================================================================
; FinalizeQuarterEnd -- (TODO: name)
; 1090 bytes | $027FF4-$028435
; ============================================================================
FinalizeQuarterEnd:
    link    a6,#-$50
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $c(a6), d3
    movea.l  #$000482FC,a3
    movea.l  #$0001183A,a4
    lea     $12(a6), a5
    clr.w   d5
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ResourceLoad
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ScanRouteSlots
    lea     $24(a7), a7
    jsr ResourceUnload
l_2807e:
    cmpi.w  #$1, d5
    bne.b   l_280d8
    jsr ResourceLoad
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ScanRouteSlots
    lea     $24(a7), a7
    jsr ResourceUnload
    clr.w   d5
l_280d8:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $8(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0019).w
    pea     ($0007).w
    jsr SetTextCursor
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor
    pea     $12(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseCharList
    lea     $2c(a7), a7
    move.w  d0, d4
    cmpi.w  #$ff, d0
    beq.w   l_283ec
    movea.l  #$00FF09D8,a0
    move.b  (a0,d4.w), d0
    andi.b  #$3, d0
    beq.b   l_281ca
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $24(a3), -(a7)
l_281ba:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $18(a7), a7
    bra.w   l_2807e
l_281ca:
    move.w  d4, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FFA6B0).l
    jsr ShowGameScreen
    moveq   #$1,d5
    jsr ResourceUnload
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0244                                 ; jsr $028436(pc)
    nop
    addq.l  #$8, a7
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.w   l_283d6
    move.b  #$1, $1(a2)
    move.b  d4, (a2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRouteRevenue
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$c, d0
    bgt.w   l_283b4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.w  d0, d6
    ble.w   l_28360
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $10(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0640                                 ; jsr $0288A4(pc)
    nop
    lea     $1c(a7), a7
    move.w  d0, d6
    ble.w   l_2834a
    move.b  d6, $2(a2)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $c(a3), -(a7)
    pea     -$50(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$50(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $24(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_2834a
    pea     ($0008).w
    pea     ($000A).w
    jsr GameCmd16
    pea     ($000A).w
    pea     ($0028).w
    jsr GameCmd16
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0015).w
    jsr LoadCompressedGfx
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $20(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $18(a7), a7
    bra.w   l_283ec
l_2834a:
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    bra.w   l_2807e
l_28360:
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    tst.b   (a0,d0.w)
    beq.b   l_2839e
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $14(a3), -(a7)
    bra.w   l_281ba
l_2839e:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $18(a3), -(a7)
    bra.w   l_281ba
l_283b4:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $18(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $18(a7), a7
    bra.w   l_2834a
l_283d6:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $1c(a3), -(a7)
    bra.w   l_281ba
l_283ec:
    cmpi.w  #$1, d5
    bne.b   l_2842a
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
l_2842a:
    move.w  (a5), d0
    movem.l -$78(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; SnapshotGameState -- (TODO: name)
; 58 bytes | $028436-$02846F
; ============================================================================
SnapshotGameState:
    move.l  d2, -(a7)
    move.l  $c(a7), d1
    move.w  $a(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_28450:
    cmpi.b  #$1, $1(a1)
    bne.b   l_28460
    cmp.b   (a1), d1
    bne.b   l_28460
    move.w  d2, d0
    bra.b   l_2846c
l_28460:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_28450
    moveq   #-$1,d0
l_2846c:
    move.l  (a7)+, d2
    rts

; ============================================================================
; ValidateGameStateS2 -- (TODO: name)
; 262 bytes | $028470-$028575
; ============================================================================
ValidateGameStateS2:
    link    a6,#-$40
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d3
    move.l  $c(a6), d4
    clr.w   d6
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FF8C                                 ; bsr.w $028436
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRouteRevenue
    move.w  d0, d5
    move.b  d3, (a3)
    move.b  #$2, $1(a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRouteRevenue
    move.w  d0, d3
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00048324).l, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $30(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_2856a
    cmp.w   d3, d5
    ble.b   l_2852a
    lea     -$40(a6), a2
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00048328).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   l_28530
l_2852a:
    movea.l ($0004832C).l, a2
l_28530:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_2855c
    moveq   #$1,d6
    bra.b   l_2856a
l_2855c:
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
l_2856a:
    move.w  d6, d0
    movem.l -$5c(a6), d2-d6/a2-a3
    unlk    a6
    rts

; ============================================================================
; ProcessUndoRedo -- (TODO: name)
; 814 bytes | $028576-$0288A3
; ============================================================================
ProcessUndoRedo:
    link    a6,#-$50
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d3
    movea.l  #$00007912,a4
    movea.l  #$00048330,a5
    clr.w   d5
    jsr ResourceLoad
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
l_285d0:
    cmpi.w  #$1, d5
    bne.b   l_2861e
    jsr ResourceLoad
    jsr ClearBothPlanes
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
    clr.w   d5
l_2861e:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048330).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor
    pea     $e(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseCharList
    lea     $20(a7), a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    beq.w   l_28896
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   (a2)
    beq.w   l_28886
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmpi.w  #$e, d2
    bge.b   l_286e8
    move.w  d2, d0
    ext.l   d0
    bra.b   l_286ea
l_286e8:
    moveq   #$E,d0
l_286ea:
    move.w  d0, d2
    tst.w   d2
    ble.w   l_28868
    jsr ClearBothPlanes
    move.w  d4, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FFA6B0).l
    jsr ShowGameScreen
    jsr ResourceUnload
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $4(a5), -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$017A                                 ; jsr $0288A4(pc)
    nop
    lea     $18(a7), a7
    move.w  d0, d2
    ble.w   l_28862
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d2
    bne.b   l_28754
    pea     ($00041ACE).l
    bra.b   l_2875a
l_28754:
    pea     ($00041AC8).l
l_2875a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $8(a5), -(a7)
    pea     -$50(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$50(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_28862
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  d2, d5
    bra.b   l_28810
l_287a8:
    pea     ($0011).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    subq.b  #$1, (a2)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AC4).l
    jsr PrintfNarrow
    subq.b  #$1, $1(a3)
    pea     ($0011).w
    pea     ($0001).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AC0).l
    jsr PrintfNarrow
    pea     ($0005).w
    pea     ($000E).w
    jsr GameCommand
    lea     $28(a7), a7
l_28810:
    subq.w  #$1, d2
    bge.b   l_287a8
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d5
    bne.b   l_28830
    pea     ($00041AB6).l
    bra.b   l_28836
l_28830:
    pea     ($00041AAA).l
l_28836:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $c(a5), -(a7)
    pea     -$50(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$50(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
l_28862:
    moveq   #$1,d5
    bra.w   l_285d0
l_28868:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $14(a5), -(a7)
l_28876:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    bra.w   l_285d0
l_28886:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $10(a5), -(a7)
    bra.b   l_28876
l_28896:
    move.w  $e(a6), d0
    movem.l -$70(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; ResetGameStateS2 -- (TODO: name)
; 674 bytes | $0288A4-$028B45
; ============================================================================
ResetGameStateS2:
    link    a6,#-$54
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    lea     -$52(a6), a4
    lea     -$2a(a6), a5
    clr.w   d2
    bra.b   l_288e6
l_288c8:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8000, (a5,a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8543, (a4,a0.l)
    addq.w  #$1, d2
l_288e6:
    cmp.w   d5, d2
    blt.b   l_288c8
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a5,a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a4,a0.l)
    move.w  #$8541, -$2a(a6)
    move.w  #$8542, -$52(a6)
    moveq   #$2,d7
    moveq   #$15,d6
    pea     ($0004).w
    pea     ($0017).w
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr DrawBox
    pea     ($0004).w
    pea     ($0017).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetTextWindow
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
    pea     ($00041AE4).l
    jsr PrintfNarrow
    clr.l   -(a7)
    jsr ReadInput
    lea     $30(a7), a7
    tst.w   d0
    beq.b   l_28970
    moveq   #$1,d0
    bra.b   l_28972
l_28970:
    moveq   #$0,d0
l_28972:
    move.w  d0, -$2(a6)
    clr.w   d3
    moveq   #$1,d4
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d2
l_28984:
    tst.w   d4
    beq.w   l_28a6c
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AE0).l
    jsr PrintfWide
    lea     $10(a7), a7
    cmpi.w  #$1, d2
    bne.b   l_289f4
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0005).w
    pea     ($0017).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($00041ADA).l
    bra.b   l_28a0a
l_289f4:
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
    addq.l  #$8, a7
    pea     ($00041AD4).l
l_28a0a:
    jsr PrintfNarrow
    move.l  a5, -(a7)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $20(a7), a7
    move.l  a4, -(a7)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    clr.w   d4
l_28a6c:
    tst.w   -$2(a6)
    beq.b   l_28a82
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_28984
l_28a82:
    clr.w   -$2(a6)
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d3
    andi.w  #$8, d0
    beq.b   l_28acc
    move.w  #$1, (a3)
    cmp.w   d5, d2
    bge.b   l_28ac8
    addq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8541, -$2(a5, a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8542, -$2(a4, a0.l)
l_28ac8:
    moveq   #$1,d4
    bra.b   l_28b2a
l_28acc:
    move.w  d3, d0
    andi.w  #$4, d0
    beq.b   l_28b04
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$1,d1
    cmp.l   d0, d1
    bgt.b   l_28ac8
    subq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8000, (a5,a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8543, (a4,a0.l)
    bra.b   l_28ac8
l_28b04:
    move.w  d3, d0
    andi.w  #$10, d0
    beq.b   l_28b18
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d2
    bra.b   l_28b3a
l_28b18:
    move.w  d3, d0
    andi.w  #$20, d0
    beq.b   l_28b2a
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    bra.b   l_28b3a
l_28b2a:
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.w   l_28984
l_28b3a:
    move.w  d2, d0
    movem.l -$7c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; RunEventSequence -- (TODO: describe)
; Called: ?? times.
; 38 bytes | $028B46-$028B6B
; ============================================================================
RunEventSequence:                                                  ; $028B46
    dc.w    $4eb9,$0003,$a9ac                           ; jsr $03A9AC
    dc.w    $4eba,$001e                                 ; jsr $028B6C
    nop
    dc.w    $4eba,$049c                                 ; jsr $028FF0
    nop
    dc.w    $4eba,$0608                                 ; jsr $029162
    nop
    dc.w    $4eba,$07ec                                 ; jsr $02934C
    nop
    dc.w    $4eba,$089c                                 ; jsr $029402
    nop
    rts
    dc.w    $4E56,$FF6C                                      ; $028B6C
; === Translated block $028B70-$028EBE ===
; 2 functions, 846 bytes

; ============================================================================
; DecrementEventTimers -- (TODO: name)
; 576 bytes | $028B70-$028DAF
; ============================================================================
DecrementEventTimers:
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00048348,a4
    movea.l  #$0005EB2C,a5
    movea.l  #$0005FAB6,a2
    clr.w   d3
    movea.l a4, a3
    addq.l  #$8, a3
l_28b8c:
    move.w  (a2), d5
    lsl.w   #$2, d5
    add.w   $2(a2), d5
    addi.w  #$e174, d5
    cmp.w   ($00FF0006).l, d5
    bne.w   l_28d92
    tst.b   $4(a2)
    bne.b   l_28bf0
    moveq   #$10,d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  $7(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  ($00048348).l, -(a7)
l_28bde:
    pea     -$80(a6)
    jsr sprintf
    lea     $10(a7), a7
    bra.w   l_28ccc
l_28bf0:
    cmpi.b  #$1, $4(a2)
    bne.b   l_28c1e
    moveq   #$10,d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  $4(a4), -(a7)
l_28c0c:
    pea     -$80(a6)
    jsr sprintf
    lea     $c(a7), a7
    bra.w   l_28ccc
l_28c1e:
    cmpi.b  #$2, $4(a2)
    bne.b   l_28c6c
    moveq   #$10,d2
    cmpi.b  #$2, $7(a2)
    bcc.b   l_28c48
    pea     ($00041F72).l
l_28c36:
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  (a3), -(a7)
    bra.b   l_28bde
l_28c48:
    cmpi.b  #$4, $7(a2)
    bcc.b   l_28c58
    pea     ($00041F6A).l
    bra.b   l_28c36
l_28c58:
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  $24(a4), -(a7)
    bra.b   l_28c0c
l_28c6c:
    cmpi.b  #$3, $4(a2)
    bne.b   l_28c9e
    moveq   #$11,d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.l  $c(a4), -(a7)
    bra.w   l_28c0c
l_28c9e:
    cmpi.b  #$4, $4(a2)
    bne.b   l_28caa
l_28ca6:
    moveq   #$10,d2
    bra.b   l_28ccc
l_28caa:
    cmpi.b  #$5, $4(a2)
    beq.b   l_28cca
    cmpi.b  #$6, $4(a2)
    beq.b   l_28ca6
    cmpi.b  #$7, $4(a2)
    beq.b   l_28cca
    cmpi.b  #$8, $4(a2)
    bne.b   l_28ccc
l_28cca:
    moveq   #$11,d2
l_28ccc:
    cmpi.b  #$ff, $4(a2)
    beq.w   l_28d78
    pea     -$94(a6)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00D0                                 ; jsr $028DB0(pc)
    nop
    move.w  d0, d4
    move.l  d0, -(a7)
    pea     -$94(a6)
    jsr AnimateInfoPanel
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr InitInfoPanel
    cmpi.b  #$4, $4(a2)
    bne.b   l_28d0a
    move.l  $10(a4), -(a7)
    bra.b   l_28d46
l_28d0a:
    cmpi.b  #$5, $4(a2)
    bne.b   l_28d18
    move.l  $14(a4), -(a7)
    bra.b   l_28d46
l_28d18:
    cmpi.b  #$6, $4(a2)
    bne.b   l_28d26
    move.l  $18(a4), -(a7)
    bra.b   l_28d46
l_28d26:
    cmpi.b  #$7, $4(a2)
    bne.b   l_28d34
    move.l  $1c(a4), -(a7)
    bra.b   l_28d46
l_28d34:
    cmpi.b  #$8, $4(a2)
    bne.b   l_28d42
    move.l  $20(a4), -(a7)
    bra.b   l_28d46
l_28d42:
    pea     -$80(a6)
l_28d46:
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    jsr ClearInfoPanel
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     -$94(a6)
    jsr PlaceItemTiles
    lea     $28(a7), a7
l_28d78:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$013E                                 ; jsr $028EBE(pc)
    nop
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$016E                                 ; jsr $028EFA(pc)
    nop
    addq.l  #$8, a7
l_28d92:
    cmp.w   ($00FF0006).l, d5
    bgt.b   l_28da6
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$37, d3
    bcs.w   l_28b8c
l_28da6:
    movem.l -$b4(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; PackEventRecord -- (TODO: name)
; 270 bytes | $028DB0-$028EBD
; ============================================================================
PackEventRecord:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $14(a7), d3
    movea.l $18(a7), a2
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$0005FAB6,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    movea.l a0, a3
    cmpi.b  #$1, $4(a3)
    beq.b   l_28de0
    cmpi.b  #$2, $4(a3)
    bne.w   l_28e66
l_28de0:
    moveq   #$1,d2
    cmpi.b  #$34, $5(a3)
    bne.b   l_28df2
    move.b  #$1f, (a2)
    bra.w   l_28eb6
l_28df2:
    cmpi.b  #$1d, $5(a3)
    bne.b   l_28e02
    move.b  #$35, (a2)
    bra.w   l_28eb6
l_28e02:
    cmpi.b  #$16, $5(a3)
    bne.b   l_28e12
    move.b  #$7, (a2)
    bra.w   l_28eb6
l_28e12:
    cmpi.b  #$1f, $5(a3)
    bne.b   l_28e22
    move.b  #$a, (a2)
    bra.w   l_28eb6
l_28e22:
    cmpi.b  #$19, $5(a3)
    bne.b   l_28e32
    move.b  #$33, (a2)
    bra.w   l_28eb6
l_28e32:
    cmpi.b  #$1b, $5(a3)
    bne.b   l_28e40
    move.b  #$34, (a2)
    bra.b   l_28eb6
l_28e40:
    cmpi.b  #$20, $5(a3)
    bne.b   l_28e58
    moveq   #$3,d2
    move.b  #$b, (a2)+
    move.b  #$38, (a2)+
    move.b  #$39, (a2)
    bra.b   l_28eb6
l_28e58:
    cmpi.b  #$17, $5(a3)
    bne.b   l_28eb6
    move.b  #$31, (a2)
    bra.b   l_28eb6
l_28e66:
    cmpi.b  #$4, $4(a3)
    bne.b   l_28e8e
    movea.l  #$00FF1298,a3
    clr.w   d2
    clr.w   d3
l_28e78:
    cmpi.b  #$9, (a3)
    bne.b   l_28e82
    move.b  d3, (a2)+
    addq.w  #$1, d2
l_28e82:
    addq.l  #$4, a3
    addq.w  #$1, d3
    cmpi.w  #$59, d3
    bcs.b   l_28e78
    bra.b   l_28eb6
l_28e8e:
    clr.w   d2
    movea.l a1, a3
    move.w  d3, d1
    bra.b   l_28eb0
l_28e96:
    cmp.w   d3, d1
    beq.b   l_28ea6
    cmp.w   d3, d1
    bls.b   l_28eb6
    cmpi.b  #$ff, $4(a3)
    bne.b   l_28eb6
l_28ea6:
    move.b  $5(a3), (a2)+
    addq.w  #$1, d2
    addq.l  #$8, a3
    addq.w  #$1, d1
l_28eb0:
    cmpi.w  #$37, d1
    bcs.b   l_28e96
l_28eb6:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2-a3
    rts

; ============================================================================
; WriteEventField -- (TODO: describe)
; Called: ?? times.
; 60 bytes | $028EBE-$028EF9
; ============================================================================
WriteEventField:                                                  ; $028EBE
    move.w  $0006(sp),d0
    lsl.w   #$3,d0
    movea.l #$0005fab6,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    tst.b   $0006(a1)
    bne.b   .l28ee6
    moveq   #$0,d0
    move.b  $0005(a1),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    bra.b   .l28ef2
.l28ee6:                                                ; $028EE6
    moveq   #$0,d0
    move.b  $0005(a1),d0
    movea.l #$00ff99a4,a0
.l28ef2:                                                ; $028EF2
    move.b  $0007(a1),(a0,d0.w)
    rts
; === Translated block $028EFA-$02949A ===
; 6 functions, 1440 bytes

; ============================================================================
; UnpackEventRecord -- (TODO: name)
; 246 bytes | $028EFA-$028FEF
; ============================================================================
UnpackEventRecord:
    link    a6,#$0
    movem.l d2-d4/a2-a5, -(a7)
    move.w  $a(a6), d0
    lsl.w   #$3, d0
    movea.l  #$0005FAB6,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    cmpi.b  #$1, $6(a5)
    bne.w   l_28fe6
    move.w  #$ff, d4
    movea.l  #$00FF1298,a2
    clr.w   d2
l_28f2a:
    move.b  (a2), d0
    cmp.b   $5(a5), d0
    bne.b   l_28f36
    move.w  d2, d4
    bra.b   l_28f40
l_28f36:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_28f2a
l_28f40:
    cmpi.w  #$59, d4
    bcc.w   l_28fe6
    movea.l  #$00FF0018,a3
    clr.w   d3
    move.w  d3, d0
    mulu.w  #$39, d0
    movea.l  #$00FF05C4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_28f62:
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    cmp.b   $5(a5), d0
    bne.b   l_28fb0
    movea.l  #$00FF1298,a2
    clr.w   d2
l_28f82:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    moveq   #$0,d1
    move.b  (a2), d1
    movea.l d1, a0
    move.b  d0, (a4,a0.l)
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_28f82
    bra.b   l_28fd4
l_28fb0:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    moveq   #$0,d1
    move.b  $5(a5), d1
    movea.l d1, a0
    move.b  d0, (a4,a0.l)
l_28fd4:
    moveq   #$24,d0
    adda.l  d0, a3
    moveq   #$39,d0
    adda.l  d0, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_28f62
l_28fe6:
    movem.l -$1c(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; CheckEventConditionS2 -- (TODO: name)
; 370 bytes | $028FF0-$029161
; ============================================================================
CheckEventConditionS2:
    link    a6,#-$84
    movem.l d2-d3/a2-a4, -(a7)
    lea     -$80(a6), a3
    movea.l  #$0002377C,a4
    movea.l  #$0005F9DE,a2
    clr.w   d3
l_2900a:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    subq.l  #$2, d1
    cmp.l   d1, d0
    bne.w   l_290aa
    clr.w   d2
    cmpi.w  #$5, (a2)
    bne.b   l_2902a
l_29026:
    clr.w   d2
    bra.b   l_29052
l_2902a:
    cmpi.w  #$29, (a2)
    bne.b   l_29034
    moveq   #$3,d2
    bra.b   l_29052
l_29034:
    cmpi.w  #$31, (a2)
    beq.b   l_29026
    cmpi.w  #$4b, (a2)
    beq.b   l_29026
    cmpi.w  #$67, (a2)
    bne.b   l_2904a
    moveq   #$1,d2
    bra.b   l_29052
l_2904a:
    cmpi.w  #$92, (a2)
    bne.b   l_29052
    moveq   #$2,d2
l_29052:
    pea     ($0005).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0004838C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000483A0).l, -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    move.l  a3, -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    pea     ($0005).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    lea     $28(a7), a7
l_290aa:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$6, d3
    bcs.w   l_2900a
    movea.l  #$0005FA2A,a2
    clr.w   d3
l_290be:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    subq.l  #$4, d1
    cmp.l   d1, d0
    bne.b   l_2914c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcEventValue
    move.w  d0, d2
    move.b  d2, -$81(a6)
    pea     ($0001).w
    pea     -$81(a6)
    jsr AnimateInfoPanel
    lea     $c(a7), a7
    cmpi.w  #$3b, d2
    bne.b   l_29102
    move.l  ($00048388).l, -(a7)
    bra.b   l_29124
l_29102:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048384).l, -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    move.l  a3, -(a7)
l_29124:
    jsr     (a4)
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    pea     ($0001).w
    pea     -$81(a6)
    jsr PlaceItemTiles
    lea     $14(a7), a7
l_2914c:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$11, d3
    bcs.w   l_290be
    movem.l -$98(a6), d2-d3/a2-a4
    unlk    a6
    rts

; ============================================================================
; ExecuteEventAction -- (TODO: name)
; 490 bytes | $029162-$02934B
; ============================================================================
ExecuteEventAction:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    lea     -$80(a6), a4
    movea.l  #$0005ECFC,a5
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    movea.l  #$00FFA6B8,a2
    clr.w   d3
    movea.l  #$00FF1278,a0
    lea     (a0,d3.w), a3
l_2919c:
    moveq   #$0,d5
    move.b  $6(a2), d5
    lsl.w   #$2, d5
    addi.w  #$ff24, d5
    moveq   #$0,d4
    move.b  $7(a2), d4
    lsl.w   #$2, d4
    addi.w  #$ff24, d4
    move.w  #$ff, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  d5, d1
    ext.l   d1
    subq.l  #$2, d1
    cmp.l   d1, d0
    bne.b   l_291fe
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048370).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    clr.w   d2
    bra.w   l_292b4
l_291fe:
    cmp.w   ($00FF0006).l, d5
    bne.b   l_29238
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048378).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    moveq   #$1,d2
    bra.b   l_292b4
l_29238:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$4, d1
    cmp.l   d1, d0
    bne.b   l_2927c
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($0004837C).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    moveq   #$2,d2
    bra.b   l_292b4
l_2927c:
    cmp.w   ($00FF0006).l, d4
    bne.b   l_292b4
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048380).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    moveq   #$3,d2
l_292b4:
    cmpi.w  #$4, d2
    bcc.b   l_29332
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0004).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0008).w
    pea     ($0009).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    move.l  a4, -(a7)
    jsr DrawLabeledBox
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    tst.w   d2
    bne.b   l_2932c
    move.l  ($00048374).l, -(a7)
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $c(a7), a7
l_2932c:
    jsr ClearListArea
l_29332:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$1, a3
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.w   l_2919c
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; ApplyEventEffectS2 -- (TODO: name)
; 182 bytes | $02934C-$029401
; ============================================================================
ApplyEventEffectS2:
    link    a6,#-$20
    movem.l d2-d4/a2-a4, -(a7)
    lea     -$20(a6), a4
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF02E8,a2
    clr.w   d3
l_29372:
    clr.w   d2
l_29374:
    tst.b   $1(a2)
    beq.b   l_2938c
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$0,d1
    move.b  (a2), d1
    add.l   d1, d1
    movea.l d1, a0
    add.w   d0, (a4,a0.l)
l_2938c:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   l_29374
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_29372
    movea.l a4, a3
    clr.w   d4
l_293a2:
    cmpi.w  #$f, (a3)
    bcs.b   l_293ee
    pea     ($0064).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$1E,d1
    cmp.l   d0, d1
    ble.b   l_293ee
    movea.l  #$00FF02E8,a2
    clr.w   d3
l_293c4:
    clr.w   d2
l_293c6:
    tst.b   $1(a2)
    beq.b   l_293dc
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   l_293dc
    addq.b  #$1, $2(a2)
l_293dc:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   l_293c6
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_293c4
l_293ee:
    addq.l  #$2, a3
    addq.w  #$1, d4
    cmpi.w  #$10, d4
    bcs.b   l_293a2
    movem.l -$38(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; HandleEventConsequence -- (TODO: name)
; 120 bytes | $029402-$029479
; ============================================================================
HandleEventConsequence:
    movem.l d2-d4/a2, -(a7)
    clr.w   d2
l_29408:
    pea     ($0004).w
    clr.l   -(a7)
    movea.l  #$00FF099C,a0
    pea     (a0, d2.w)
    jsr MemFillByte
    lea     $c(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_29408
    movea.l  #$00FF0338,a2
    clr.w   d2
l_29432:
    clr.w   d3
l_29434:
    cmpi.b  #$3, $1(a2)
    bne.b   l_29462
    cmpi.b  #$1, $3(a2)
    bhi.b   l_29462
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
    moveq   #$1,d0
    lsl.b   d4, d0
    movea.l  #$00FF099C,a0
    or.b    d0, (a0,d2.w)
l_29462:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_29434
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_29432
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; GameLogic2 -- (TODO: name)
; 32 bytes | $02947A-$029499
; ============================================================================
GameLogic2:
    dc.w    $4EBA,$001E                                 ; jsr $02949A(pc)
    nop
    dc.w    $4EBA,$0076                                 ; jsr $0294F8(pc)
    nop
    dc.w    $4EBA,$00F8                                 ; jsr $029580(pc)
    nop
    jsr UpdateSlotEvents
    dc.w    $4EBA,$0424                                 ; jsr $0298B8(pc)
    nop
    rts

; ============================================================================
; InitQuarterEvent -- (TODO: describe)
; Called: ?? times.
; 94 bytes | $02949A-$0294F7
; ============================================================================
InitQuarterEvent:                                                  ; $02949A
    move.l  d2,-(sp)
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l294a8
    addq.l  #$3,d0
.l294a8:                                                ; $0294A8
    asr.l   #$2,d0
    move.w  d0,d2
    movea.l #$0005fcb0,a0
    move.b  (a0,d2.w),d0
    andi.l  #$ff,d0
    move.w  d0,($00FFBD4C).l
    movea.l #$0005fc6e,a0
    move.b  (a0,d2.w),d0
    andi.l  #$ff,d0
    move.w  d0,($00FF1294).l
    clr.l   -(sp)
    pea     ($0002).w
    dc.w    $4eb9,$0002,$1fd4                           ; jsr $021FD4
    addq.l  #$8,sp
    cmpi.w  #$1,d0
    bne.b   .l294f4
    move.w  #$64,($00FF1294).l
.l294f4:                                                ; $0294F4
    move.l  (sp)+,d2
    rts
; === Translated block $0294F8-$029ABC ===
; 3 functions, 1476 bytes

; ============================================================================
; MakeAIDecision -- (TODO: name)
; 136 bytes | $0294F8-$02957F
; ============================================================================
MakeAIDecision:
    movem.l d2/a2-a4, -(a7)
    movea.l  #$000090F4,a4
    movea.l  #$00FF0120,a2
    movea.l  #$00FF03F0,a3
    clr.w   d2
l_29510:
    moveq   #$0,d0
    move.b  $9(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    add.b   $1(a2), d0
    move.b  d0, $1(a2)
    moveq   #$0,d0
    move.b  $a(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    add.b   $2(a2), d0
    move.b  d0, $2(a2)
    moveq   #$0,d0
    move.b  $b(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $24(a7), a7
    add.b   $3(a2), d0
    move.b  d0, $3(a2)
    addq.l  #$4, a2
    moveq   #$C,d0
    adda.l  d0, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_29510
    movem.l (a7)+, d2/a2-a4
    rts

; ============================================================================
; AnalyzeRouteProfit -- (TODO: name)
; 824 bytes | $029580-$0298B7
; ============================================================================
AnalyzeRouteProfit:
    link    a6,#-$4
    movem.l d2-d5/a2-a5, -(a7)
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($00FF0290).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF1298,a3
    move.l  #$ff8824, -$4(a6)
    clr.w   d4
l_295ae:
    movea.l -$4(a6), a0
    tst.b   $1(a0)
    beq.w   l_2968c
    movea.l  #$00FF0290,a4
    move.w  d4, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    movea.l  #$00FF0018,a5
    clr.w   d3
l_295d8:
    tst.b   (a2)
    beq.w   l_2967a
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.l  d0, d2
    ext.l   d2
    addq.l  #$2, d2
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$A,d1
    jsr SignedDiv
    cmpi.w  #$1, d0
    ble.b   l_29620
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$A,d1
    jsr SignedDiv
    ext.l   d0
    bra.b   l_29622
l_29620:
    moveq   #$1,d0
l_29622:
    moveq   #$0,d1
    move.b  (a2), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  (a7)+, d1
    jsr Multiply32
    move.l  d0, d2
    asr.l   #$2, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    addi.l  #$1e, d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_29674
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_29676
l_29674:
    moveq   #$1,d0
l_29676:
    move.w  d0, d2
    add.w   d2, (a4)
l_2967a:
    addq.l  #$6, a4
    addq.l  #$2, a2
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_295d8
l_2968c:
    addq.l  #$4, a3
    addq.l  #$2, -$4(a6)
    addq.w  #$1, d4
    cmpi.w  #$59, d4
    bcs.w   l_295ae
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0290,a4
    clr.w   d3
l_296aa:
    clr.w   d5
l_296ac:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    beq.b   l_2972a
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    addq.w  #$1, d0
    move.l  d0, d2
    moveq   #$0,d0
    move.b  $3(a3), d0
    addi.w  #$14, d0
    mulu.w  d0, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    addi.l  #$1e, d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    add.w   d2, $2(a4)
l_2972a:
    addq.w  #$1, d5
    cmpi.w  #$7, d5
    bcs.w   l_296ac
    moveq   #$24,d0
    adda.l  d0, a5
    addq.l  #$6, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_296aa
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0290,a4
    clr.w   d3
l_29752:
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
l_29764:
    cmpi.b  #$1, $1(a2)
    bne.b   l_297d0
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a3), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d2, d1
    addq.l  #$1, d1
    jsr Multiply32
    tst.l   d0
    bge.b   l_297b4
    addq.l  #$3, d0
l_297b4:
    asr.l   #$2, d0
    move.w  d0, d2
    cmpi.w  #$1, d2
    bcc.b   l_297c2
    moveq   #$1,d0
    bra.b   l_297c6
l_297c2:
    moveq   #$0,d0
    move.w  d2, d0
l_297c6:
    move.w  d0, d2
    add.w   d2, $4(a2)
    add.w   d2, $4(a4)
l_297d0:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.b   l_29764
    moveq   #$24,d0
    adda.l  d0, a5
    addq.l  #$6, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_29752
    movea.l  #$00FF03F0,a3
    movea.l  #$00FF0120,a2
    clr.w   d3
l_297f8:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    move.w  d0, (a3)
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    move.w  d0, $2(a3)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $24(a7), a7
    move.w  d0, $4(a3)
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_297f8
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0290,a4
    movea.l  #$00FF03F0,a3
    clr.w   d3
l_2986e:
    moveq   #$0,d2
    move.w  (a4), d2
    moveq   #$0,d0
    move.w  $2(a4), d0
    add.l   d0, d2
    moveq   #$0,d0
    move.w  $4(a4), d0
    add.l   d0, d2
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  $2(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  $4(a3), d1
    add.l   d1, d0
    add.l   d0, d2
    sub.l   d2, $6(a5)
    moveq   #$24,d0
    adda.l  d0, a5
    addq.l  #$6, a4
    moveq   #$C,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_2986e
    movem.l -$24(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; OptimizeCosts -- (TODO: name)
; 516 bytes | $0298B8-$029ABB
; ============================================================================
OptimizeCosts:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00005FF6,a4
    lea     -$80(a6), a5
    movea.l  #$00FF0018,a3
    movea.l  #$00FF0338,a2
    clr.w   d3
l_298d8:
    clr.w   d4
l_298da:
    cmpi.b  #$6, $1(a2)
    bne.w   l_29a98
    cmpi.b  #$4, $3(a2)
    bne.w   l_29a98
    moveq   #$0,d2
    move.b  (a2), d2
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000420E6).l
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0064).w
    pea     ($0001).w
    jsr RandRange
    lea     $1c(a7), a7
    move.w  d4, d1
    mulu.w  #$7, d1
    moveq   #$0,d5
    move.b  $2(a2), d5
    add.w   d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bgt.w   l_299ec
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    beq.b   l_299a0
    jsr ResourceLoad
    jsr PreLoopInit
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a4)
    lea     $18(a7), a7
    jsr ResourceUnload
    bra.b   l_299b2
l_299a0:
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a4)
    lea     $c(a7), a7
l_299b2:
    pea     ($0008).w
    pea     ($001E).w
    pea     ($0013).w
    pea     ($0001).w
    jsr DrawBox
    move.l  a5, -(a7)
    pea     ($000420D2).l
    jsr PrintfWide
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $20(a7), a7
    bra.w   l_29a98
l_299ec:
    cmpi.b  #$1, (a3)
    bne.w   l_29a86
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    beq.b   l_29a3e
    jsr ResourceLoad
    jsr ClearBothPlanes
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0012).w
    jsr     (a4)
    lea     $18(a7), a7
    jsr ResourceUnload
    bra.b   l_29a50
l_29a3e:
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a4)
    lea     $c(a7), a7
l_29a50:
    pea     ($0008).w
    pea     ($001E).w
    pea     ($0013).w
    pea     ($0001).w
    jsr DrawBox
    move.l  a5, -(a7)
    pea     ($000420C6).l
    jsr PrintfWide
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $20(a7), a7
l_29a86:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
l_29a98:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_298da
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_298d8
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; RunTurnSequence -- (TODO: describe)
; Called: ?? times.
; 1490 bytes | $029ABC-$02A08D
; ============================================================================
RunTurnSequence:                                                  ; $029ABC
    link    a6,#-$4
    movem.l d2-d6/a2-a5,-(sp)
    movea.l #$0d64,a3
    movea.l #$00ff1804,a4
    movea.l #$5092,a5
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    moveq   #$0,d4
    move.b  ($00FF0016).l,d4
    move.w  d4,d0
    mulu.w  #$c,d0
    movea.l #$00ff03f0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0004C68E).l
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($0003).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0004C696).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00B2).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($0004C610).l
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($000C).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($0004C618).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00AE).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0018(sp),sp
    pea     ($0004C596).l
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0004C59E).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00AA).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($00072A6C).l
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($00072A88).l
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($000D).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $001c(sp),sp
    pea     ($00072AA4).l
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076ADE).l
    jsr     (a5)
    move.l  ($000A1B30).l,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($0048).w
    pea     ($005B).w
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($0007267C).l
    pea     ($0012).w
    pea     ($001C).w
    pea     ($0001).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076B1E).l
    jsr     (a5)
    pea     ($0004BD5A).l
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $0028(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004BD96).l
    pea     ($001E).w
    pea     ($003D).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    move.l  ($000A1B60).l,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($001E).w
    pea     ($0001).w
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    lea     $0028(sp),sp
    pea     ($000732DC).l
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($000D).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $001c(sp),sp
    pea     ($0004C178).l
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004C1B4).l
    pea     ($001E).w
    pea     ($001F).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0030(sp),sp
    pea     ($0004C734).l
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0640).w
    dc.w    $4eb9,$0001,$d7be                           ; jsr $01D7BE
    pea     ($0004C854).l
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0649).w
    dc.w    $4eb9,$0001,$d7be                           ; jsr $01D7BE
    lea     $0020(sp),sp
    clr.w   d2
.l29d7c:                                                ; $029D7C
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0354                                 ; jsr $02A0DE
    nop
    addq.l  #$8,sp
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l29d7c
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l29db0
    moveq   #$1,d5
    bra.b   .l29db2
.l29db0:                                                ; $029DB0
    moveq   #$0,d5
.l29db2:                                                ; $029DB2
    clr.w   d2
    moveq   #$1,d3
.l29db6:                                                ; $029DB6
    cmpi.w  #$1,d3
    bne.b   .l29dda
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($000420FE).l
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $0014(sp),sp
    clr.w   d3
.l29dda:                                                ; $029DDA
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076ADE).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004C158).l
    jsr     (a5)
    lea     $0018(sp),sp
    tst.w   d5
    beq.b   .l29e1e
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l29e1e
    pea     ($0002).w
.l29e14:                                                ; $029E14
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    bra.b   .l29db6
.l29e1e:                                                ; $029E1E
    clr.w   d5
    pea     ($003C).w
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eba,$0886                                 ; jsr $02A6B8
    nop
    move.w  d0,d6
    pea     ($0008).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0014(sp),sp
    move.w  d6,d0
    andi.w  #$10,d0
    bne.w   .l2a02e
    move.w  d6,d0
    andi.w  #$20,d0
    beq.w   .l2a006
    move.w  #$0ccc,-$0002(a6)
    pea     ($0001).w
    move.w  d2,d6
    ext.l   d6
    addi.l  #$34,d6
    move.l  d6,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    move.w  #$0866,-$0002(a6)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    addi.l  #$37,d0
    move.l  d0,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    lea     $0018(sp),sp
    move.w  d2,d0
    ext.l   d0
    tst.w   d0
    beq.b   .l29eb0
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l29f12
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.w   .l29f6a
    bra.w   .l29fbe
.l29eb0:                                                ; $029EB0
    moveq   #$0,d0
    move.b  $0009(a2),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05b2                                 ; jsr $02A474
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l29fbe
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0009(a2),d1
    cmp.l   d1,d0
    beq.w   .l29fbe
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0184                                 ; jsr $02A07E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.w   .l29fbe
    move.b  d3,$0009(a2)
    bra.w   .l29fbe
.l29f12:                                                ; $029F12
    moveq   #$0,d0
    move.b  $000b(a2),d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$054e                                 ; jsr $02A474
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    blt.w   .l29fbe
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $000b(a2),d1
    cmp.l   d1,d0
    beq.b   .l29fbe
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0128                                 ; jsr $02A07E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l29fbe
    move.b  d3,$000b(a2)
    bra.b   .l29fbe
.l29f6a:                                                ; $029F6A
    moveq   #$0,d0
    move.b  $000a(a2),d0
    move.l  d0,-(sp)
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04f6                                 ; jsr $02A474
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    blt.b   .l29fbe
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $000a(a2),d1
    cmp.l   d1,d0
    beq.b   .l29fbe
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00d2                                 ; jsr $02A07E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l29fbe
    move.b  d3,$000a(a2)
.l29fbe:                                                ; $029FBE
    move.w  #$0222,-$0002(a6)
    pea     ($0001).w
    move.l  d6,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    move.w  #$0424,-$0002(a6)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    addi.l  #$37,d0
    move.l  d0,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    moveq   #$1,d3
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00e2                                 ; jsr $02A0DE
    nop
    lea     $0020(sp),sp
    bra.b   .l2a026
.l2a006:                                                ; $02A006
    move.w  d6,d0
    andi.w  #$8,d0
    beq.b   .l2a016
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l2a01c
.l2a016:                                                ; $02A016
    move.w  d2,d0
    ext.l   d0
    addq.l  #$2,d0
.l2a01c:                                                ; $02A01C
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
.l2a026:                                                ; $02A026
    pea     ($0005).w
    bra.w   .l29e14
.l2a02e:                                                ; $02A02E
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0001).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0028(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $02A07E-$02A738 ===
; 5 functions, 1722 bytes

; ============================================================================
; ValidateRouteNetwork -- (TODO: name)
; 96 bytes | $02A07E-$02A0DD
; ============================================================================
ValidateRouteNetwork:
    link    a6,#-$84
    move.l  d2, -(a7)
    move.w  $e(a6), d0
    lsl.w   #$2, d0
    movea.l  #$000483B8,a0
    move.l  (a0,d0.w), -(a7)
    move.w  $12(a6), d0
    lsl.w   #$2, d0
    movea.l  #$000483A4,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$80(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$80(a6)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    cmpi.w  #$1, d0
    bne.b   l_2a0d2
    moveq   #$1,d2
    bra.b   l_2a0d4
l_2a0d2:
    clr.w   d2
l_2a0d4:
    move.w  d2, d0
    move.l  -$88(a6), d2
    unlk    a6
    rts

; ============================================================================
; ProcessRouteDisplayS2 -- (TODO: name)
; 918 bytes | $02A0DE-$02A473
; ============================================================================
ProcessRouteDisplayS2:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d6
    lea     -$8(a6), a3
    lea     -$2(a6), a4
    movea.l  #$00FF0120,a5
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  d6, d0
    mulu.w  #$9, d0
    addq.w  #$3, d0
    move.w  d0, (a3)
    moveq   #$A,d7
    clr.w   d3
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    move.w  d6, d0
    ext.l   d0
    tst.w   d0
    beq.b   l_2a148
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_2a1cc
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_2a250
    bra.w   l_2a2d0
l_2a148:
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03F9,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d0, (a4)
    clr.w   d2
l_2a1ac:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $1(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a1ac
    bra.w   l_2a2d0
l_2a1cc:
    moveq   #$2,d2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03FB,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.w  d0, (a4)
    clr.w   d2
l_2a230:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $3(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a230
    bra.w   l_2a2d0
l_2a250:
    moveq   #$1,d2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03FA,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.w  d0, (a4)
    clr.w   d2
l_2a2b4:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $2(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a2b4
l_2a2d0:
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$6(a6), -(a7)
    pea     ($00042118).l
    jsr PrintfNarrow
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00042114).l
    jsr PrintfWide
    lea     $20(a7), a7
    pea     ($0001).w
    pea     ($0008).w
    move.w  (a4), d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    move.w  d7, d0
    addq.w  #$3, d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    jsr RenderTileStrip
    move.w  d3, d0
    ext.l   d0
    bge.b   l_2a350
    addq.l  #$3, d0
l_2a350:
    asr.l   #$2, d0
    move.w  d0, d3
    cmpi.w  #$32, d3
    bge.b   l_2a3ac
    moveq   #$3,d2
    move.l  #$8000, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$17, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  (a3), d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
    pea     ($0640).w
    bra.b   l_2a3fc
l_2a3ac:
    moveq   #$15,d2
    move.l  #$8000, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$17, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  (a3), d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
    pea     ($0649).w
l_2a3fc:
    jsr TilePlacement
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01AA                                 ; jsr $02A5D2(pc)
    nop
    move.l  d5, d0
    lsl.l   #$2, d0
    movea.l  #$000A1B34,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($000E).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$b6, d0
    move.l  d0, -(a7)
    pea     ($00FF899C).l
    jsr CmdPlaceTile
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; ShowRouteSelectMenu -- (TODO: name)
; 350 bytes | $02A474-$02A5D1
; ============================================================================
ShowRouteSelectMenu:
    link    a6,#-$8
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $10(a6), d2
    move.l  $c(a6), d4
    move.l  $8(a6), d7
    lea     -$6(a6), a2
    movea.l  #$00FF13FC,a3
    moveq   #$1,d5
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004211E).l
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_2a4c0
    moveq   #$1,d6
    bra.b   l_2a4c2
l_2a4c0:
    moveq   #$0,d6
l_2a4c2:
    clr.w   (a2)
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d3
    bra.w   l_2a5c0
l_2a4d2:
    tst.w   d3
    beq.b   l_2a534
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$000A1B34,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($000E).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$b6, d0
    move.l  d0, -(a7)
    pea     ($00FF899C).l
    jsr CmdPlaceTile
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00A8                                 ; jsr $02A5D2(pc)
    nop
    lea     $20(a7), a7
    clr.w   d3
l_2a534:
    tst.w   d6
    beq.b   l_2a54c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_2a54c
    pea     ($0003).w
    bra.b   l_2a5b4
l_2a54c:
    clr.w   d6
    move.w  -$6(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, (a2)
    andi.w  #$30, d0
    beq.b   l_2a582
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d5
    move.w  (a2), d0
    andi.w  #$10, d0
    beq.b   l_2a5b0
    moveq   #-$1,d2
    bra.b   l_2a5b0
l_2a582:
    move.w  (a2), d0
    andi.w  #$1, d0
    beq.b   l_2a598
    move.w  #$1, (a3)
    subq.w  #$1, d2
    tst.w   d2
    bge.b   l_2a5ae
    moveq   #$4,d2
    bra.b   l_2a5ae
l_2a598:
    move.w  (a2), d0
    andi.w  #$2, d0
    beq.b   l_2a5b0
    move.w  #$1, (a3)
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    ble.b   l_2a5ae
    clr.w   d2
l_2a5ae:
    moveq   #$1,d3
l_2a5b0:
    pea     ($0006).w
l_2a5b4:
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_2a5c0:
    tst.w   d5
    bne.w   l_2a4d2
    move.w  d2, d0
    movem.l -$28(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ============================================================================
; RenderRouteIndicator -- (TODO: name)
; 230 bytes | $02A5D2-$02A6B7
; ============================================================================
RenderRouteIndicator:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d3
    move.l  $20(a7), d5
    move.l  $24(a7), d6
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d5, d0
    ext.l   d0
    tst.w   d0
    beq.b   l_2a608
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_2a612
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   l_2a61c
    bra.b   l_2a624
l_2a608:
    clr.w   d4
    moveq   #$0,d2
    move.b  $1(a2), d2
    bra.b   l_2a624
l_2a612:
    moveq   #$2,d4
    moveq   #$0,d2
    move.b  $3(a2), d2
    bra.b   l_2a624
l_2a61c:
    moveq   #$1,d4
    moveq   #$0,d2
    move.b  $2(a2), d2
l_2a624:
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    add.w   d0, d2
    move.w  d5, d3
    mulu.w  #$9, d3
    addq.w  #$3, d3
    tst.w   d2
    ble.b   l_2a650
    move.w  d2, d0
    ext.l   d0
    bra.b   l_2a652
l_2a650:
    moveq   #$0,d0
l_2a652:
    move.w  d0, d2
    cmpi.w  #$64, d2
    bge.b   l_2a660
    move.w  d2, d0
    ext.l   d0
    bra.b   l_2a662
l_2a660:
    moveq   #$64,d0
l_2a662:
    move.w  d0, d2
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($006F).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d3, d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $30(a7), a7
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; WaitInputWithTimeout -- (TODO: name)
; 128 bytes | $02A6B8-$02A737
; ============================================================================
WaitInputWithTimeout:
    link    a6,#-$4
    movem.l d2-d4, -(a7)
    move.l  $10(a6), d3
    move.w  #$88, -$2(a6)
    pea     ($0001).w
    move.w  $a(a6), d4
    ext.l   d4
    lsl.l   #$4, d4
    move.w  $e(a6), d0
    ext.l   d0
    add.l   d0, d4
    move.l  d4, -(a7)
    pea     -$2(a6)
    jsr DisplaySetup
    lea     $c(a7), a7
l_2a6ee:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d2
    and.w   d3, d0
    bne.b   l_2a716
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    tst.w   d2
    beq.b   l_2a6ee
l_2a716:
    move.w  #$666, -$2(a6)
    pea     ($0001).w
    move.l  d4, -(a7)
    pea     -$2(a6)
    jsr DisplaySetup
    move.w  d2, d0
    movem.l -$10(a6), d2-d4
    unlk    a6
    rts

; ============================================================================
; RunAITurn -- (TODO: describe)
; Called: ?? times.
; 144 bytes | $02A738-$02A7C7
; ============================================================================
RunAITurn:                                                  ; $02A738
    movem.l d2/a2,-(sp)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    cmpi.b  #$01,(a2)
    bne.b   .l2a776
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0eb8                                 ; jsr $02B61C
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0058                                 ; jsr $02A7C8
    nop
    addq.l  #$8,sp
.l2a776:                                                ; $02A776
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$01a4                                 ; jsr $02A922
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04e0                                 ; jsr $02AC6A
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0656                                 ; jsr $02ADEC
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$08ca                                 ; jsr $02B06C
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0c8c                                 ; jsr $02B43A
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$038a                                 ; jsr $02AB44
    nop
    lea     $0018(sp),sp
    movem.l (sp)+,d2/a2
    rts
; === Translated block $02A7C8-$02BDB8 ===
; 10 functions, 5616 bytes

; ============================================================================
; LoadRouteDataS2 -- (TODO: name)
; 346 bytes | $02A7C8-$02A921
; ============================================================================
LoadRouteDataS2:
    link    a6,#-$88
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d5
    lea     -$88(a6), a4
    movea.l  #$00FF00A8,a5
    clr.w   d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
.l2a7f0:
    clr.w   d3
    pea     ($0008).w
    clr.l   -(a7)
    pea     -$8(a6)
    jsr MemFillByte
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    lea     $14(a7), a7
    cmpi.w  #$20, d0
    bge.b   .l2a838
    clr.w   d2
    movea.l  #$00FF099C,a0
    lea     (a0,d2.w), a0
    movea.l a0, a2
.l2a82c:
    cmp.w   d5, d2
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   .l2a82c
.l2a838:
    tst.w   d3
    beq.w   .l2a90c
    cmpi.w  #$4, d3
    bcc.w   .l2a90c
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   .l2a882
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $c(a7), a7
    jsr ResourceUnload
.l2a882:
    cmpi.w  #$1, d3
    bne.b   .l2a8aa
    move.l  (a3), -(a7)
    moveq   #$0,d0
    move.w  -$8(a6), d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    pea     ($0004219C).l
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   .l2a8f2
.l2a8aa:
    cmpi.w  #$2, d3
    bne.b   .l2a8de
    move.l  (a3), -(a7)
    moveq   #$0,d0
    move.w  -$6(a6), d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    moveq   #$0,d0
    move.w  -$8(a6), d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    pea     ($0004217A).l
    move.l  a4, -(a7)
    jsr sprintf
    lea     $14(a7), a7
    bra.b   .l2a8f2
.l2a8de:
    move.l  (a3), -(a7)
    pea     ($00042152).l
    move.l  a4, -(a7)
    jsr sprintf
    lea     $c(a7), a7
.l2a8f2:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
.l2a90c:
    addq.l  #$4, a3
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.w   .l2a7f0
    movem.l -$a8(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; ProcessCharAnimS2 -- (TODO: name)
; 546 bytes | $02A922-$02AB43
; ============================================================================
ProcessCharAnimS2:
    link    a6,#-$100
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d6
    lea     -$100(a6), a4
    movea.l  #$000483C4,a5
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d5
.l2a95c:
    move.b  $1(a2), d0
    andi.b  #$c0, d0
    beq.w   .l2ab2e
    cmpi.b  #$1, (a3)
    bne.w   .l2ab1c
    move.b  $1(a2), d0
    btst    #$6, d0
    beq.b   .l2a97e
    clr.w   d3
    bra.b   .l2a980
.l2a97e:
    moveq   #$1,d3
.l2a980:
    andi.b  #$3f, $1(a2)
    cmpi.b  #$6, $1(a2)
    bne.b   .l2a994
    moveq   #$0,d4
    move.b  (a2), d4
    bra.b   .l2a9a6
.l2a994:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
.l2a9a6:
    cmpi.b  #$1, $1(a2)
    bne.b   .l2a9e0
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042244).l
.l2a9d0:
    move.l  a4, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.w   .l2aac4
.l2a9e0:
    cmpi.b  #$3, $1(a2)
    bne.b   .l2aa0c
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042212).l
    bra.b   .l2a9d0
.l2aa0c:
    cmpi.b  #$5, $1(a2)
    bne.b   .l2aa7e
    moveq   #$0,d2
    move.b  $2(a2), d2
    cmpi.b  #$20, (a2)
    bcc.b   .l2aa32
    moveq   #$0,d0
    move.b  (a2), d0
    mulu.w  #$6, d0
    add.w   d2, d0
    movea.l  #$00FF1704,a0
    bra.b   .l2aa40
.l2aa32:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    add.w   d2, d0
    movea.l  #$00FF1620,a0
.l2aa40:
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000421DC).l
    bra.b   .l2aab8
.l2aa7e:
    cmpi.b  #$6, $1(a2)
    bne.b   .l2aac4
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($000421B8).l
.l2aab8:
    move.l  a4, -(a7)
    jsr sprintf
    lea     $14(a7), a7
.l2aac4:
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    beq.b   .l2aafa
    jsr ResourceLoad
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $c(a7), a7
    jsr ResourceUnload
.l2aafa:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
.l2ab1c:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
.l2ab2e:
    addq.l  #$8, a2
    addq.w  #$1, d5
    cmpi.w  #$4, d5
    bcs.w   .l2a95c
    movem.l -$124(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; UpdateCharStateS2 -- (TODO: name)
; 294 bytes | $02AB44-$02AC69
; ============================================================================
UpdateCharStateS2:
    link    a6,#-$80
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $8(a6), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d3, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
.l2ab76:
    tst.b   $2(a2)
    beq.w   .l2ac54
    subq.b  #$1, $2(a2)
    tst.b   $2(a2)
    bne.b   .l2abe4
    moveq   #$0,d2
    move.b  (a2), d2
    cmpi.b  #$1, (a4)
    bne.b   .l2abb2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0E7A                                 ; jsr $02BA24(pc)
    nop
    lea     $c(a7), a7
.l2abb2:
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.b  $1(a2), d0
    add.b   d0, (a3)
    move.b  $1(a2), d0
    add.b   d0, $1(a3)
    move.b  #$ff, (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    bra.b   .l2ac54
.l2abe4:
    moveq   #$0,d2
    move.b  (a2), d2
    cmpi.b  #$1, (a4)
    bne.b   .l2ac54
    jsr ClearBothPlanes
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    jsr ResourceUnload
    movea.l  #$00FF1278,a0
    move.b  (a0,d2.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004227A).l
    pea     -$80(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $2c(a7), a7
.l2ac54:
    addq.l  #$4, a2
    addq.w  #$1, d4
    cmpi.w  #$5, d4
    bcs.w   .l2ab76
    movem.l -$98(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; HandleCharEventTrigger -- (TODO: name)
; 386 bytes | $02AC6A-$02ADEB
; ============================================================================
HandleCharEventTrigger:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$80(a6), a4
    movea.l  #$0000D648,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
.l2aca4:
    cmpi.b  #$3, $1(a2)
    bne.w   .l2add6
    moveq   #$0,d2
    move.b  (a2), d2
    cmpi.b  #$1, (a3)
    bne.w   .l2adac
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$4, a7
    cmp.w   ($00FF9A1C).l, d0
    beq.b   .l2ad12
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, d5
    jsr ResourceLoad
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0003).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $1c(a7), a7
    jsr ResourceUnload
.l2ad12:
    clr.l   -(a7)
    pea     ($000E).w
    jsr MenuSelectEntry
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042304).l
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$4, a7
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000422C8).l
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    pea     ($0007).w
    jsr SelectMenuItem
    lea     $28(a7), a7
.l2adac:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    or.l    d0, (a0,d1.w)
.l2add6:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   .l2aca4
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; ManageTurnDisplay -- (TODO: name)
; 640 bytes | $02ADEC-$02B06B
; ============================================================================
ManageTurnDisplay:
    link    a6,#-$80
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d6
.l2ae1c:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmpi.w  #$5, d0
    bne.w   .l2b056
    subq.b  #$1, $3(a2)
    tst.b   $3(a2)
    bne.w   .l2b056
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d2
    move.b  $2(a2), d2
    cmpi.w  #$20, d3
    bcc.b   .l2ae6c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d7
    add.w   d2, d0
    movea.l  #$00FF0420,a0
    move.b  d5, (a0,d0.w)
    move.w  d7, d0
    add.w   d2, d0
    movea.l  #$00FF1704,a0
    bra.b   .l2ae88
.l2ae6c:
    move.w  d3, d0
    lsl.w   #$2, d0
    add.w   d2, d0
    movea.l  #$00FF0460,a0
    move.b  d5, (a0,d0.w)
    move.w  d3, d0
    lsl.w   #$2, d0
    add.w   d2, d0
    movea.l  #$00FF15A0,a0
.l2ae88:
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    cmpi.b  #$1, (a3)
    bne.w   .l2b044
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmp.w   ($00FF9A1C).l, d0
    beq.b   .l2aef4
    jsr ResourceLoad
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $c(a7), a7
    jsr ResourceUnload
.l2aef4:
    cmpi.w  #$3, d2
    bcc.b   .l2aefe
.l2aefa:
    clr.w   d4
    bra.b   .l2af24
.l2aefe:
    cmpi.w  #$6, d2
    bcc.b   .l2af08
    moveq   #$1,d4
    bra.b   .l2af24
.l2af08:
    cmpi.w  #$a, d2
    bcs.b   .l2aefa
    cmpi.w  #$d, d2
    bcc.b   .l2af18
    moveq   #$2,d4
    bra.b   .l2af24
.l2af18:
    cmpi.w  #$d, d2
    bne.b   .l2af22
    moveq   #$3,d4
    bra.b   .l2af24
.l2af22:
    moveq   #$4,d4
.l2af24:
    clr.l   -(a7)
    pea     ($000E).w
    jsr MenuSelectEntry
    pea     ($0009).w
    pea     ($000C).w
    pea     ($0007).w
    pea     ($000A).w
    jsr DrawBox
    pea     ($000424C9).l
    jsr PrintfNarrow
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0DB4                                 ; jsr $02BD0E(pc)
    nop
    lea     $20(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    tst.w   d2
    beq.b   .l2af88
    cmpi.w  #$7, d2
    bne.b   .l2af90
.l2af88:
    pea     ($000424AE).l
    bra.b   .l2af96
.l2af90:
    pea     ($000424AC).l
.l2af96:
    pea     ($000424B2).l
    pea     -$80(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $2c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$000483CC,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0009).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($000C).w
    pea     ($0007).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0007).w
    jsr SelectMenuItem
    lea     $20(a7), a7
.l2b044:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
.l2b056:
    addq.l  #$8, a2
    addq.w  #$1, d6
    cmpi.w  #$4, d6
    bcs.w   .l2ae1c
    movem.l -$a0(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ============================================================================
; ProcessCharModifier -- (TODO: name)
; 974 bytes | $02B06C-$02B439
; ============================================================================
ProcessCharModifier:
    link    a6,#-$80
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  #$ff, d7
    clr.w   d6
.l2b0a0:
    cmpi.b  #$1, $1(a2)
    bne.w   .l2b424
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr GetModeRowOffset
    add.b   d0, $3(a2)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharRating
    lea     $10(a7), a7
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $3(a2), d0
    cmp.w   d3, d0
    bcs.w   .l2b424
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.l  d0, d4
    moveq   #$0,d0
    move.b  $2(a2), d0
    cmp.w   d0, d4
    ble.b   .l2b136
    moveq   #$0,d4
    move.b  $2(a2), d4
    bra.b   .l2b14c
.l2b136:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.l  d0, d4
.l2b14c:
    ext.l   d4
    add.b   d4, $1(a3)
    cmpi.b  #$1, (a5)
    bne.w   .l2b410
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d3
    cmp.w   d3, d7
    beq.b   .l2b1ac
    jsr ResourceLoad
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
    move.w  d3, d7
.l2b1ac:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.w   d4
    bne.b   .l2b1ea
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($00042530).l
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    bra.w   .l2b412
.l2b1ea:
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.w  d4, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l2b23e
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d4
    bne.b   .l2b214
    pea     ($00042506).l
    bra.b   .l2b21a
.l2b214:
    pea     ($00042500).l
.l2b21a:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004250C).l
    pea     -$80(a6)
    jsr sprintf
    lea     $14(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    bra.b   .l2b282
.l2b23e:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d4
    bne.b   .l2b25a
    pea     ($000424D0).l
    bra.b   .l2b260
.l2b25a:
    pea     ($000424CA).l
.l2b260:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000424D6).l
    pea     -$80(a6)
    jsr sprintf
    lea     $14(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
.l2b282:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($001E).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0546).w
    jsr TilePlacement
    pea     ($0014).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0548).w
    jsr TilePlacement
    pea     ($000A).w
    jsr PollInputChange
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $30(a7), a7
    cmpi.w  #$20, d2
    bcc.b   .l2b388
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d2, d1
    sub.w   d0, d1
    bra.b   .l2b3b6
.l2b388:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d2, d1
    sub.w   d0, d1
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBD,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    add.w   d0, d1
.l2b3b6:
    addi.w  #$1f, d1
    move.w  d1, d3
    moveq   #$0,d2
    move.b  (a4), d2
    moveq   #$0,d0
    move.b  $1(a4), d0
    sub.w   d0, d2
    bra.b   .l2b40a
.l2b3ca:
    addq.b  #$1, (a4)
    addq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$660, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    jsr PlaceFormattedTiles
    pea     ($0001).w
    jsr PollInputChange
    lea     $18(a7), a7
.l2b40a:
    subq.w  #$1, d4
    bge.b   .l2b3ca
    bra.b   .l2b412
.l2b410:
    add.b   d4, (a4)
.l2b412:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
.l2b424:
    addq.l  #$8, a2
    addq.w  #$1, d6
    cmpi.w  #$4, d6
    bcs.w   .l2b0a0
    movem.l -$a8(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; HandleCharSelectionS2 -- (TODO: name)
; 326 bytes | $02B43A-$02B57F
; ============================================================================
HandleCharSelectionS2:
    link    a6,#-$80
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$80(a6), a3
    movea.l  #$0005F04C,a4
    movea.l  #$0003B22C,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  #$ff, ($00FF09A0).l
    pea     ($000F).w
    pea     ($0001).w
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$2,d1
    cmp.l   d0, d1
    ble.w   .l2b576
    pea     ($000A).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00DC                                 ; jsr $02B580(pc)
    nop
    lea     $10(a7), a7
    cmpi.w  #$1, d0
    bne.w   .l2b576
    move.b  d2, ($00FF09A0).l
    cmpi.b  #$1, (a2)
    bne.w   .l2b576
    jsr PreLoopInit
    jsr ResourceUnload
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    pea     ($00042604).l
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    pea     ($000425C8).l
    move.l  a3, -(a7)
    jsr     (a5)
    lea     $2c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowCharInfoPage
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00042580).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowCharInfoPage
    lea     $28(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    pea     ($0004254A).l
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
.l2b576:
    movem.l -$98(a6), d2-d3/a2-a5
    unlk    a6
    rts

; ============================================================================
; ValidateCharSlot -- (TODO: name)
; 156 bytes | $02B580-$02B61B
; ============================================================================
ValidateCharSlot:
    movem.l d2-d6/a2, -(a7)
    move.l  $20(a7), d4
    move.l  $1c(a7), d6
    clr.w   d5
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   .l2b59a
    addq.l  #$3, d0
.l2b59a:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d3
    movea.l  #$00FFA6B8,a2
    clr.w   d2
.l2b5aa:
    moveq   #$0,d0
    move.b  $6(a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   .l2b5da
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  $7(a2), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l2b5da
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   .l2b5da
    moveq   #$1,d5
    bra.b   .l2b5e6
.l2b5da:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   .l2b5aa
.l2b5e6:
    cmpi.w  #$1, d5
    bne.b   .l2b614
    movea.l  #$0005F07C,a0
    move.b  (a0,d4.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    cmpi.w  #$3, d0
    bne.b   .l2b614
    clr.w   d5
.l2b614:
    move.w  d5, d0
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; ShowCharStatus -- (TODO: name)
; 330 bytes | $02B61C-$02B765
; ============================================================================
ShowCharStatus:
    link    a6,#-$C8
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $8(a6), d2
    movea.l  #$00007912,a3
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    lsl.l   #$2, d0
    addq.l  #$1, d0
    move.w  ($00FF0006).l, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.w   .l2b73e
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ResourceLoad
    jsr ClearBothPlanes
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    jsr ResourceUnload
    move.w  ($00FF0004).l, d3
    addq.w  #$4, d3
    cmpi.w  #$7, d3
    bcc.b   .l2b6ba
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2b6bc
.l2b6ba:
    moveq   #$7,d0
.l2b6bc:
    move.w  d0, d3
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($00042730).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($000426C2).l
    pea     -$c8(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$c8(a6)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004267A).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0004263A).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    bra.b   .l2b75c
.l2b73e:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0020                                 ; jsr $02B766(pc)
    nop
    addq.l  #$4, a7
    tst.l   $6(a2)
    ble.b   .l2b75c
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowAnnualReport
.l2b75c:
    movem.l -$d8(a6), d2-d3/a2-a3
    unlk    a6
    rts

; ============================================================================
; RenderStatusScreenS2 -- (TODO: name)
; 290 bytes | $02B766-$02B887
; ============================================================================
RenderStatusScreenS2:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$0003B270,a4
    movea.l  #$0003AB2C,a5
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A598).l
    jsr DisplaySetup
    pea     ($0013).w
    pea     ($0018).w
    pea     ($0003).w
    pea     ($0004).w
    jsr DrawBox
    pea     ($0004).w
    pea     ($0006).w
    jsr     (a5)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00042772).l
    jsr     (a4)
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0130,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l2b7ea:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    jsr     (a5)
    cmpi.w  #$2, d2
    bne.b   .l2b808
    pea     ($00042762).l
    bra.b   .l2b816
.l2b808:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
.l2b816:
    pea     ($0004276E).l
    jsr     (a4)
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0016).w
    jsr     (a5)
    lea     $18(a7), a7
    tst.l   (a2)
    beq.b   .l2b848
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    pea     ($0004275E).l
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l2b852
.l2b848:
    pea     ($0004275A).l
    jsr     (a4)
    addq.l  #$4, a7
.l2b852:
    addq.l  #$1, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   .l2b7ea
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearTileArea
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$000E                                 ; jsr $02B888(pc)
    nop
    lea     $c(a7), a7
    movem.l (a7)+, d2-d3/a2-a5
    rts


; === Translated block $02B888-$02BDB8 ===
; 3 functions, 1328 bytes

; ============================================================================
; ShowCharDetailS2 -- (TODO: name)
; 412 bytes | $02B888-$02BA23
; ============================================================================
ShowCharDetailS2:
    link    a6,#-$50
    movem.l d2/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0001183A,a3
    movea.l  #$00047C40,a4
    lea     -$50(a6), a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.b  #$64, $22(a2)
    bcc.b   l_2b8fa
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0011).w
    jsr MenuSelectEntry
    lea     $30(a7), a7
l_2b8fa:
    moveq   #$0,d0
    move.b  $22(a2), d0
    moveq   #$60,d1
    sub.l   d1, d0
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.w   l_2ba08
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0080
    dc.w    $0036
    dc.w    $0020
    dc.w    $0008
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  ($00047C40).l, -(a7)
    bra.w   l_2b9fc
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $4(a4), -(a7)
    bra.w   l_2b9fc
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $8(a4), -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a5, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $c(a4), -(a7)
    bra.b   l_2b9fc
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $10(a4), -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a5, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $14(a4), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $18(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $18(a4), -(a7)
l_2b9fc:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $18(a7), a7
l_2ba08:
    cmpi.b  #$64, $22(a2)
    bcc.b   l_2ba1a
    pea     ($0007).w
    jsr SelectMenuItem
l_2ba1a:
    movem.l -$64(a6), d2/a2-a5
    unlk    a6
    rts

; ============================================================================
; DisplayStationDetail -- (TODO: name)
; 746 bytes | $02BA24-$02BD0D
; ============================================================================
DisplayStationDetail:
    link    a6,#-$84
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d5
    move.l  $c(a6), d6
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00005092,a4
    movea.l  #$0001D98C,a5
    jsr ResourceLoad
    clr.l   -(a7)
    move.l  #$fc00, -(a7)
    pea     ($0400).w
    pea     ($0001).w
    pea     ($0007).w
    jsr     (a2)
    jsr PreLoopInit
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr     (a5)
    move.w  #$866, -$2(a6)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$2(a6)
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A0EE).l
    jsr     (a4)
    pea     ($0004A25E).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($003E).w
    pea     ($0025).w
    jsr VRAMBulkLoad
    pea     ($0004A10E).l
    pea     ($000C).w
    pea     ($000E).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($00049F78).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0024).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    pea     ($00049DC8).l
    pea     ($000C).w
    pea     ($0012).w
    pea     ($0003).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    moveq   #$12,d4
    moveq   #$7,d3
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    pea     ($0004A514).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0008).w
    pea     ($0063).w
    jsr VRAMBulkLoad
    pea     ($0004A504).l
    pea     ($0002).w
    pea     ($0004).w
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $30(a7), a7
    jsr ResourceUnload
    cmpi.w  #$1, d5
    bne.b   l_2bbd0
    pea     ($0004277E).l
    bra.b   l_2bbd6
l_2bbd0:
    pea     ($00042776).l
l_2bbd6:
    movea.l  #$00FF1278,a0
    move.b  (a0,d6.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00042784).l
    pea     -$82(a6)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     -$82(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $28(a7), a7
    cmpi.w  #$1, ($00FF000A).l
    bne.w   l_2bcca
    clr.l   -(a7)
    jsr LoadDisplaySet
    addq.l  #$4, a7
    clr.w   d2
l_2bc3c:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a5)
    move.w  d2, d0
    andi.w  #$1, d0
    beq.b   l_2bc62
    move.w  #$2cc, -$2(a6)
    bra.b   l_2bc68
l_2bc62:
    move.w  #$468, -$2(a6)
l_2bc68:
    pea     ($0001).w
    pea     ($001C).w
    pea     -$2(a6)
    jsr     (a4)
    lea     $1c(a7), a7
    cmpi.w  #$4c, d2
    bne.b   l_2bca8
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
l_2bca8:
    addq.w  #$1, d2
    cmpi.w  #$98, d2
    blt.b   l_2bc3c
    pea     ($0018).w
    jsr     (a2)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0018).w
    jsr     (a2)
    lea     $10(a7), a7
l_2bcca:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ResourceLoad
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0007).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a5)
    jsr ClearBothPlanes
    movem.l -$a8(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; ShowFacilityMenu -- (TODO: name)
; 170 bytes | $02BD0E-$02BDB7
; ============================================================================
ShowFacilityMenu:
    link    a6,#-$3C
    movem.l d2-d3/a2, -(a7)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    pea     ($0010).w
    pea     ($0030).w
    pea     ($000767DE).l
    jsr DisplaySetup
    move.w  #$30e, d3
    move.w  $a(a6), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($001E).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $2c(a7), a7
    lea     -$3c(a6), a2
    clr.w   d2
l_2bd7c:
    move.w  d3, d0
    add.w   d2, d0
    ori.w   #$6000, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   l_2bd7c
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0009).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    movem.l -$48(a6), d2-d3/a2
    unlk    a6
    rts


; ============================================================================
; ShowAnnualReport -- (TODO: describe)
; Called: ?? times.
; 1298 bytes | $02BDB8-$02C2C9
; ============================================================================
ShowAnnualReport:                                                  ; $02BDB8
    link    a6,#-$b0
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d4
    lea     -$00a6(a6),a3
    movea.l #$0001183a,a4
    movea.l #$0004843c,a5
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$4,d0
    sub.l   d1,d0
    lsl.l   #$2,d0
    addq.l  #$1,d0
    move.w  ($00FF0006).l,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.w   .l2c2c0
    clr.w   -$00ac(a6)
    clr.w   -$00aa(a6)
    clr.w   d7
    move.w  d4,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,-$0002(a6)
    clr.w   d2
.l2be28:                                                ; $02BE28
    cmp.w   d4,d2
    beq.b   .l2be6c
    move.w  d2,d0
    lsl.w   #$3,d0
    add.w   -$0002(a6),d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.b   .l2be6c
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  -$0002(a6),d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)
    beq.b   .l2be6c
    move.w  #$1,-$00aa(a6)
    move.w  d2,-$00a8(a6)
.l2be6c:                                                ; $02BE6C
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2be28
    move.w  ($00FF0004).l,d0
    addq.w  #$4,d0
    move.w  d0,-$0004(a6)
    cmpi.w  #$7,-$0004(a6)
    bge.b   .l2be90
    move.w  -$0004(a6),d0
    ext.l   d0
    bra.b   .l2be92
.l2be90:                                                ; $02BE90
    moveq   #$7,d0
.l2be92:                                                ; $02BE92
    move.w  d0,-$0004(a6)
    moveq   #-$1,d5
    clr.w   d3
.l2be9a:                                                ; $02BE9A
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    cmpi.w  #$ff,d0
    bne.b   .l2beba
    move.w  #$1,-$00ac(a6)
.l2beba:                                                ; $02BEBA
    move.w  d4,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.b   .l2bef0
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)
    beq.b   .l2bef0
    addq.w  #$1,d7
    bra.b   .l2bf38
.l2bef0:                                                ; $02BEF0
    move.w  d3,-$0006(a6)
    clr.w   d2
.l2bef6:                                                ; $02BEF6
    cmp.w   d4,d2
    beq.b   .l2bf30
    move.w  d2,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.b   .l2bf30
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)
    beq.b   .l2bf30
    move.w  d2,d5
    bra.b   .l2bf38
.l2bf30:                                                ; $02BF30
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2bef6
.l2bf38:                                                ; $02BF38
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    blt.w   .l2be9a
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$74f8                           ; jsr $0074F8
    addq.l  #$8,sp
    move.w  d0,d2
    tst.w   d2
    bgt.b   .l2bfae
    dc.w    $4eba,$0368                                 ; jsr $02C2CA
    nop
    move.w  -$0002(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  $0024(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    move.l  $0028(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $002c(sp),sp
    bra.w   .l2c2aa
.l2bfae:                                                ; $02BFAE
    cmpi.w  #$1,-$00aa(a6)
    bne.w   .l2c048
    move.w  d7,d0
    ext.l   d0
    move.w  -$0004(a6),d1
    ext.l   d1
    subq.l  #$1,d1
    cmp.l   d1,d0
    blt.w   .l2c2c0
    dc.w    $4eba,$02fe                                 ; jsr $02C2CA
    nop
    move.w  -$0002(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.w  -$00a8(a6),d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.l  ($0004843C).l,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0028(sp),sp
    move.w  -$00a8(a6),d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.l  $0004(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $000c(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    bra.w   .l2c2b2
.l2c048:                                                ; $02C048
    move.w  d7,d0
    ext.l   d0
    move.w  -$0004(a6),d1
    ext.l   d1
    subq.l  #$1,d1
    cmp.l   d1,d0
    bne.w   .l2c114
    dc.w    $4eba,$026e                                 ; jsr $02C2CA
    nop
    cmpi.w  #$3,($00FF0004).l
    bge.b   .l2c0ac
    pea     ($00042ECE).l
    move.l  $0008(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0024(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $000c(a5),-(sp)
    bra.w   .l2c2b8
.l2c0ac:                                                ; $02C0AC
    move.w  -$0006(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  $0008(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0024(sp),sp
    move.w  d5,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l2c2c0
    move.w  -$0006(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.l  $0010(a5),-(sp)
    bra.w   .l2c29e
.l2c114:                                                ; $02C114
    cmp.w   -$0004(a6),d7
    bne.w   .l2c2c0
    cmpi.w  #$1,-$00ac(a6)
    bne.b   .l2c140
    dc.w    $4eba,$01a4                                 ; jsr $02C2CA
    nop
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $0014(a5),-(sp)
    bra.w   .l2c2b8
.l2c140:                                                ; $02C140
    dc.w    $4eba,$0188                                 ; jsr $02C2CA
    nop
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    tst.w   d2
    bne.b   .l2c170
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $001c(a5),-(sp)
    bra.b   .l2c1a0
.l2c170:                                                ; $02C170
    move.w  d2,d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0,d1
    move.l  d1,d0
    add.l   d0,d0
    add.l   d1,d0
    move.l  d0,-(sp)
    move.l  $0018(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $000c(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  a3,-(sp)
.l2c1a0:                                                ; $02C1A0
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0018(sp),sp
    clr.l   -$00b0(a6)
    moveq   #-$1,d7
    clr.w   d3
.l2c1b4:                                                ; $02C1B4
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    move.l  (a0,d0.w),d5
    tst.l   d5
    beq.w   .l2c26a
    move.w  d4,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.w   .l2c26a
    moveq   #-$1,d6
    clr.w   d2
.l2c1f0:                                                ; $02C1F0
    move.w  d2,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$2,d0
    bne.b   .l2c210
    move.w  d2,d6
    bra.b   .l2c218
.l2c210:                                                ; $02C210
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2c1f0
.l2c218:                                                ; $02C218
    move.w  d6,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l2c238
    move.w  d6,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    move.l  (a0,d0.w),d2
    bra.b   .l2c23a
.l2c238:                                                ; $02C238
    moveq   #$0,d2
.l2c23a:                                                ; $02C23A
    move.l  d2,d0
    moveq   #$b,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    move.l  d5,d0
    lsl.l   #$2,d0
    add.l   d5,d0
    add.l   d0,d0
    move.l  (sp)+,d1
    cmp.l   d1,d0
    bcc.b   .l2c26a
    cmp.w   -$0002(a6),d3
    bne.b   .l2c25e
    move.w  d3,d7
    bra.b   .l2c274
.l2c25e:                                                ; $02C25E
    cmp.l   -$00b0(a6),d5
    bls.b   .l2c26a
    move.l  d5,-$00b0(a6)
    move.w  d3,d7
.l2c26a:                                                ; $02C26A
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    blt.w   .l2c1b4
.l2c274:                                                ; $02C274
    move.w  d7,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l2c2c0
    move.w  d6,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.w  d7,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  $0020(a5),-(sp)
.l2c29e:                                                ; $02C29E
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $0010(sp),sp
.l2c2aa:                                                ; $02C2AA
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
.l2c2b2:                                                ; $02C2B2
    pea     ($0004).w
    move.l  a3,-(sp)
.l2c2b8:                                                ; $02C2B8
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
.l2c2c0:                                                ; $02C2C0
    movem.l -$00d8(a6),d2-d7/a2-a5
    unlk    a6
    rts
    dc.w    $42A7,$4878,$0020; $02C2CA
; === Translated block $02C2D0-$02C2FA ===
; 1 functions, 42 bytes

; ============================================================================
; InitScenarioDisplay -- (TODO: name)
; 42 bytes | $02C2D0-$02C2F9
; ============================================================================
InitScenarioDisplay:
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    lea     $28(a7), a7
    rts

; ============================================================================
; RunScenarioMenu -- (TODO: describe)
; Called: ?? times.
; 1254 bytes | $02C2FA-$02C7DF
; ============================================================================
RunScenarioMenu:                                                  ; $02C2FA
    link    a6,#-$108
    movem.l d2-d7/a2-a5,-(sp)
    lea     -$0084(a6),a4
    movea.l #$000483f0,a5
    cmpi.w  #$fffe,($00FF0A32).l
    bne.b   .l2c320
    dc.w    $4eba,$05b8                                 ; jsr $02C8D0
    nop
    dc.w    $6000,$04b8                                 ; bra.w $02C7D6
.l2c320:                                                ; $02C320
    cmpi.w  #$ffff,($00FF0A32).l
    dc.w    $6700,$04ac                                 ; beq.w $02C7D6
    moveq   #$0,d3
    move.b  ($00FF0016).l,d3
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  ($00FF0A32).l,d4
    andi.w  #$ff,d4
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    move.b  (a0,d0.w),d2
    andi.l  #$ff,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0628                                 ; jsr $02C994
    nop
    move.w  d0,d5
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d7
    moveq   #$0,d6
    move.w  ($00FF0A32).l,d6
    asr.l   #$8,d6
    andi.w  #$ff,d6
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9d92                           ; jsr $009D92
    lea     $0010(sp),sp
    move.w  d0,-$0002(a6)
    cmpi.w  #$6,d5
    ble.b   .l2c3b4
    move.w  d5,d0
    ext.l   d0
    bra.b   .l2c3b6
.l2c3b4:                                                ; $02C3B4
    moveq   #$6,d0
.l2c3b6:                                                ; $02C3B6
    move.w  d0,d5
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l2c3c6
    moveq   #$f,d1
    add.l   d1,d0
.l2c3c6:                                                ; $02C3C6
    asr.l   #$4,d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$01f4,d0
    move.w  d5,d1
    ext.l   d1
    movea.l d7,a0
    move.w  -$0002(a6),d7
    ext.l   d7
    exg     d7,a0
    add.l   a0,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$07d0,d0
    move.l  d0,d5
    cmpi.b  #$01,(a2)
    dc.w    $6600,$031e                                 ; bne.w $02C718
    tst.w   d2
    bne.b   .l2c40e
    move.l  ($0005EB2C).l,-(sp)
    pea     ($00042F34).l
    bra.b   .l2c422
.l2c40e:                                                ; $02C40E
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005eb2c,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($0004842C).l,-(sp)
.l2c422:                                                ; $02C422
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0000,$814a                           ; jsr $00814A
    pea     ($0001).w
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a4,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $0030(sp),sp
    cmpi.w  #$4,d6
    bge.b   .l2c4c8
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005eb2c,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d6,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a5,a0.l),-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    move.w  d6,d0
    lsl.w   #$2,d0
    movea.l #$000483e0,a0
    move.l  (a0,d0.w),-(sp)
    move.l  $0010(a5),-(sp)
    pea     -$0106(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $0018(sp),sp
    lea     -$0106(a6),a3
    dc.w    $6000,$00b0                                 ; bra.w $02C576
.l2c4c8:                                                ; $02C4C8
    move.w  d6,d0
    ext.l   d0
    subq.l  #$4,d0
    moveq   #$3,d1
    cmp.l   d1,d0
    dc.w    $6200,$0096                                 ; bhi.w $02C56A
    add.l   d0,d0
    move.w  $2c4e0(pc,d0.l),d0
    jmp     $2c4e0(pc,d0.w)
    ; WARNING: 768 undecoded trailing bytes at $02C4E0
    dc.w    $0008
    dc.w    $002a
    dc.w    $004a
    dc.w    $005e
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3004
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $e680
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $0014
    dc.w    $6054
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $001c
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4fef
    dc.w    $000c
    dc.w    $6040
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $0024
    dc.w    $60de
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3004
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $e680
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $002c
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4fef
    dc.w    $0010
    dc.w    $3006
    dc.w    $48c0
    dc.w    $e788
    dc.w    $2040
    dc.w    $2675
    dc.w    $88f8
    dc.w    $42a7
    dc.w    $2f0c
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $025e
    dc.w    $4e71
    dc.w    $4878
    dc.w    $0020
    dc.w    $4878
    dc.w    $0020
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $a942
    dc.w    $4878
    dc.w    $000f
    dc.w    $4878
    dc.w    $0001
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $ab2c
    dc.w    $2f05
    dc.w    $4879
    dc.w    $0004
    dc.w    $2f20
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b270
    dc.w    $4fef
    dc.w    $002c
    dc.w    $42a7
    dc.w    $2f0b
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $021c
    dc.w    $4e71
    dc.w    $4878
    dc.w    $0020
    dc.w    $4878
    dc.w    $0020
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $a942
    dc.w    $4878
    dc.w    $0019
    dc.w    $4878
    dc.w    $0013
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $ab2c
    dc.w    $3003
    dc.w    $c0fc
    dc.w    $0024
    dc.w    $207c
    dc.w    $00ff
    dc.w    $001e
    dc.w    $2f30
    dc.w    $0000
    dc.w    $4879
    dc.w    $0004
    dc.w    $2f1a
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b270
    dc.w    $4fef
    dc.w    $002c
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $2f39
    dc.w    $0004
    dc.w    $8430
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $7912
    dc.w    $4fef
    dc.w    $0014
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6600
    dc.w    $00ae
    dc.w    $baaa
    dc.w    $0006
    dc.w    $6e00
    dc.w    $0088
    dc.w    $33fc
    dc.w    $ffff
    dc.w    $00ff
    dc.w    $0a32
    dc.w    $9baa
    dc.w    $0006
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f39
    dc.w    $0004
    dc.w    $8434
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $2f0c
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $7912
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $2f2d
    dc.w    $0034
    dc.w    $2f0c
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b22c
    dc.w    $4fef
    dc.w    $002c
    dc.w    $42a7
    dc.w    $2f0c
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0140
    dc.w    $4e71
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $02ca
    dc.w    $4e71
    dc.w    $4fef
    dc.w    $0014
    dc.w    $6034
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $2f39
    dc.w    $0004
    dc.w    $8438
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $7912
    dc.w    $4fef
    dc.w    $0014
    dc.w    $42a7
    dc.w    $2f2d
    dc.w    $0038
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $00f8
    dc.w    $4e71
    dc.w    $4fef
    dc.w    $000c
    dc.w    $4878
    dc.w    $0040
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0010
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $0d64
    dc.w    $4fef
    dc.w    $000c
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $814a
    dc.w    $4878
    dc.w    $0007
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $9f4a
    dc.w    $6000
    dc.w    $00c0
    dc.w    $4246
    dc.w    $2005
    dc.w    $0680
    dc.w    $0000
    dc.w    $2710
    dc.w    $b0aa
    dc.w    $0006
    dc.w    $6c3c
    dc.w    $3004
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $9d92
    dc.w    $508f
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6f22
    dc.w    $33fc
    dc.w    $ffff
    dc.w    $00ff
    dc.w    $0a32
    dc.w    $9baa
    dc.w    $0006
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3003
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0220
    dc.w    $4e71
    dc.w    $508f
    dc.w    $7c01
    dc.w    $4878
    dc.w    $0008
    dc.w    $4878
    dc.w    $001c
    dc.w    $4878
    dc.w    $0011
    dc.w    $4878
    dc.w    $0002
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $5a04
    dc.w    $0c46
    dc.w    $0001
    dc.w    $6624
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3003
    dc.w    $e948
    dc.w    $207c
    dc.w    $00ff
    dc.w    $00a8
    dc.w    $4870
    dc.w    $0000
    dc.w    $4879
    dc.w    $0004
    dc.w    $2f00
    dc.w    $6022
    dc.w    $3002
    dc.w    $e548
    dc.w    $207c
    dc.w    $0005
    dc.w    $eb2c
    dc.w    $2f30
    dc.w    $0000
    dc.w    $3003
    dc.w    $e948
    dc.w    $207c
    dc.w    $00ff
    dc.w    $00a8
    dc.w    $4870
    dc.w    $0000
    dc.w    $4879
    dc.w    $0004
    dc.w    $2ede
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $b270
    dc.w    $4878
    dc.w    $001e
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $e2f4
    dc.w    $4cee
    dc.w    $3cfc
    dc.w    $fed0
    dc.w    $4e5e
    dc.w    $4e75
; === Translated block $02C7E0-$02C9C8 ===
; 4 functions, 488 bytes

; ============================================================================
; GetAirlineScenarioInfo -- (TODO: name)
; 240 bytes | $02C7E0-$02C8CF
; ============================================================================
GetAirlineScenarioInfo:
    link    a6,#$0
    movem.l d2-d4, -(a7)
    move.l  $8(a6), d3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    move.w  d2, d0
    ext.l   d0
    moveq   #$7,d1
    jsr SignedMod
    add.w   d0, d0
    movea.l  #$00048468,a0
    move.w  (a0,d0.w), d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0008).w
    pea     ($0004).w
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00042F6A).l
    jsr PrintfWide
    lea     $24(a7), a7
    pea     ($0001).w
    pea     ($0640).w
    pea     ($0039).w
    pea     ($0040).w
    pea     ($0008).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
    lea     $18(a7), a7
    move.l  $c(a6), -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0003).w
    pea     ($079E).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr DrawCharInfoPanel
    pea     ($0008).w
    pea     ($000E).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    movem.l -$c(a6), d2-d4
    unlk    a6
    rts

; ============================================================================
; ResetScenarioMenuS2 -- (TODO: name)
; 172 bytes | $02C8D0-$02C97B
; ============================================================================
ResetScenarioMenuS2:
    movem.l d2-d6/a2, -(a7)
    clr.w   d4
    move.w  #$ffff, ($00FF0A32).l
    pea     ($0020).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$1A,d1
    cmp.l   d0, d1
    bge.w   l_2c976
    pea     ($0058).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d6
    blt.b   l_2c922
    cmpi.w  #$26, d6
    beq.b   l_2c922
    cmpi.w  #$28, d6
    beq.b   l_2c922
    cmpi.w  #$32, d6
    blt.b   l_2c976
    cmpi.w  #$36, d6
    bgt.b   l_2c976
l_2c922:
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    movea.l  #$0005FCF2,a2
    clr.w   d3
l_2c93e:
    clr.w   d2
l_2c940:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d5, d0
    bne.b   l_2c94c
    moveq   #$1,d4
    bra.b   l_2c956
l_2c94c:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_2c940
l_2c956:
    cmpi.w  #$1, d4
    beq.b   l_2c964
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    blt.b   l_2c93e
l_2c964:
    tst.w   d4
    bne.b   l_2c96a
    moveq   #$7,d3
l_2c96a:
    move.w  d3, d0
    lsl.w   #$8, d0
    or.w    d6, d0
    move.w  d0, ($00FF0A32).l
l_2c976:
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; ClearAircraftSlot -- (TODO: name)
; 24 bytes | $02C97C-$02C993
; ============================================================================
ClearAircraftSlot:
    move.w  $6(a7), d0
    mulu.w  #$39, d0
    add.w   $a(a7), d0
    movea.l  #$00FF05C4,a0
    clr.b   (a0,d0.w)
    rts

; ============================================================================
; CountAircraftType -- (TODO: name)
; 52 bytes | $02C994-$02C9C7
; ============================================================================
CountAircraftType:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d4
    movea.l  #$00FF1298,a0
    clr.w   d2
    clr.w   d3
    bra.b   l_2c9ba
l_2c9a8:
    moveq   #$0,d0
    move.b  (a0), d0
    move.w  d4, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_2c9b6
    addq.w  #$1, d3
l_2c9b6:
    addq.l  #$4, a0
    addq.w  #$1, d2
l_2c9ba:
    cmpi.w  #$59, d2
    blt.b   l_2c9a8
    move.w  d3, d0
    movem.l (a7)+, d2-d4
    rts

RunPurchaseMenu:                                                  ; $02C9C8
    link    a6,#-$4
    movem.l d2-d4/a2-a3,-(sp)
    movea.l #$00ff9a1c,a2
    movea.l #$0001d71c,a3
    moveq   #$0,d4
    move.b  ($00FF0016).l,d4
    jsr     (a3)
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0001).w
    pea     ($0009).w
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    dc.w    $4eba,$00fa                                 ; jsr $02CAF6
    nop
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0174                                 ; jsr $02CB7C
    nop
    lea     $000c(sp),sp
    dc.w    $4eba,$0288                                 ; jsr $02CC9A
    nop
    clr.w   d3
.l2ca18:                                                ; $02CA18
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$00ff1584,a0
    cmpi.w  #$1,(a0,d0.w)
    bne.b   .l2ca2e
    move.w  d3,d2
    bra.b   .l2ca36
.l2ca2e:                                                ; $02CA2E
    addq.w  #$1,d3
    cmpi.w  #$b,d3
    bcs.b   .l2ca18
.l2ca36:                                                ; $02CA36
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$028c                                 ; jsr $02CCD0
    nop
    addq.l  #$8,sp
    move.w  d0,d2
    move.w  #$ff,($00FF17C6).l
    cmpi.w  #$b,d2
    bcc.b   .l2ca70
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$07fc                                 ; jsr $02D264
    nop
    addq.l  #$8,sp
    bra.b   .l2ca36
.l2ca70:                                                ; $02CA70
    cmpi.w  #$b,d2
    bne.b   .l2ca86
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1856                                 ; jsr $02E2D4
    nop
    addq.l  #$4,sp
    bra.b   .l2ca36
.l2ca86:                                                ; $02CA86
    cmpi.w  #$b,d2
    bhi.b   .l2cab2
    jsr     (a3)
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0007).w
    clr.l   -(sp)
    dc.w    $4eba,$04ae                                 ; jsr $02CF50
    nop
    lea     $000c(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    bra.b   .l2ca36
.l2cab2:                                                ; $02CAB2
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A
    jsr     (a3)
    pea     ($0001).w
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0018(a6),d2-d4/a2-a3
    unlk    a6
    rts
; === Translated block $02CAF6-$02F430 ===
; 25 functions, 10554 bytes

; ============================================================================
; UpdateSelectionS2 -- (TODO: name)
; 134 bytes | $02CAF6-$02CB7B
; ============================================================================
UpdateSelectionS2:
    movem.l d2-d3/a2-a4, -(a7)
    movea.l  #$00FFBD5A,a4
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   .l2cb0c
    addq.l  #$3, d0
.l2cb0c:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d3
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF17C8).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FFA6B8,a2
    movea.l  #$00FF17C8,a3
    move.w  #$ff, (a4)
    clr.w   d2
.l2cb3c:
    moveq   #$0,d0
    move.b  $6(a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   .l2cb68
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  $7(a2), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l2cb68
    move.w  #$1, (a3)
    cmpi.w  #$ff, (a4)
    bne.b   .l2cb68
    move.w  d2, (a4)
.l2cb68:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   .l2cb3c
    movem.l (a7)+, d2-d3/a2-a4
    rts

; ============================================================================
; RefreshControlState -- (TODO: name)
; 286 bytes | $02CB7C-$02CC99
; ============================================================================
RefreshControlState:
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $20(a7), d4
    movea.l  #$00FF1584,a4
    movea.l  #$00FFBD5A,a5
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($00FF17E8).l
    jsr MemFillByte
    pea     ($0018).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    pea     ($0016).w
    pea     ($00FF).w
    pea     ($00FF880C).l
    jsr MemFillByte
    lea     $24(a7), a7
    move.w  (a5), d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  (a5), d0
    add.w   d0, d0
    movea.l  #$00FF17C8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  (a5), d2
    bra.b   .l2cc40
.l2cbee:
    cmpi.w  #$1, (a3)
    bne.b   .l2cc38
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF17E8,a0
    move.w  #$1, (a0,d0.w)
    moveq   #$0,d0
    move.b  (a2), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$1, (a4,a0.l)
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF880C,a0
    cmpi.w  #$ffff, (a0,d0.w)
    bne.b   .l2cc38
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF880C,a0
    move.w  d2, (a0,d0.w)
.l2cc38:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
.l2cc40:
    cmpi.w  #$10, d2
    bcs.b   .l2cbee
    clr.w   d2
.l2cc48:
    movea.l  #$0005F07C,a0
    move.b  (a0,d2.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$3, d3
    bne.b   .l2cc7e
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a4,a0.l)
.l2cc7e:
    addq.w  #$1, d2
    cmpi.w  #$b, d2
    bcs.b   .l2cc48
    move.w  #$1, ($00FF17FE).l
    move.w  #$1, $16(a4)
    movem.l (a7)+, d2-d4/a2-a5
    rts

; ============================================================================
; InitControllerS2 -- (TODO: name)
; 54 bytes | $02CC9A-$02CCCF
; ============================================================================
InitControllerS2:
    movea.l  #$00FF1480,a1
    movea.l  #$00FF0002,a0
    tst.w   (a0)
    beq.b   .l2ccce
    cmpi.w  #$1, (a0)
    beq.b   .l2ccce
    cmpi.w  #$2, (a0)
    beq.b   .l2ccce
    move.w  #$15, $10(a1)
    move.w  #$1, $12(a1)
    move.w  #$17, $14(a1)
    move.w  #$3, $16(a1)
.l2ccce:
    rts

; ============================================================================
; ClearControllerS2 -- (TODO: name)
; 640 bytes | $02CCD0-$02CF4F
; ============================================================================
ClearControllerS2:
    link    a6,#-$80
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $8(a6), d4
    movea.l  #$00000D64,a2
    movea.l  #$00007912,a3
    movea.l  #$00048476,a4
    move.w  $e(a6), d2
    jsr ClearBothPlanes
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    dc.w    $4EBA,$024A                                 ; jsr $02CF50(pc)
    nop
    lea     $c(a7), a7
    jsr ResourceUnload
.l2cd14:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  (a4), -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $14(a7), a7
    clr.w   d3
.l2cd2a:
    pea     ($0007).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$03D4                                 ; jsr $02D10C(pc)
    nop
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   .l2cdba
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($0018).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($00A0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l2cdac:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   .l2cdda
.l2cdba:
    cmpi.w  #$f, d3
    bne.b   .l2cdd2
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2cdac
.l2cdd2:
    cmpi.w  #$1e, d3
    bne.b   .l2cdda
    clr.w   d3
.l2cdda:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.b   .l2ce60
    cmpi.w  #$b, d2
    bcc.w   .l2cf02
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF1584,a0
    tst.w   (a0,d0.w)
    bne.w   .l2cf02
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048482).l, -(a7)
    pea     -$80(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  (a4), -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $14(a7), a7
    bra.w   .l2cd2a
.l2ce60:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l2ce6e
    moveq   #$C,d2
    bra.w   .l2cf02
.l2ce6e:
    move.w  d5, d0
    andi.w  #$4, d0
    beq.b   .l2cec4
.l2ce76:
    tst.w   d2
    bne.b   .l2ce7e
    moveq   #$A,d2
    bra.b   .l2ce94
.l2ce7e:
    cmpi.w  #$3, d2
    bne.b   .l2ce88
    moveq   #$B,d2
    bra.b   .l2ce94
.l2ce88:
    cmpi.w  #$b, d2
    bne.b   .l2ce92
    moveq   #$2,d2
    bra.b   .l2ce94
.l2ce92:
    subq.w  #$1, d2
.l2ce94:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF17E8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2ce76
.l2cea6:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    bra.w   .l2cd2a
.l2cec4:
    move.w  d5, d0
    andi.w  #$8, d0
    beq.w   .l2cd2a
.l2cece:
    cmpi.w  #$a, d2
    bne.b   .l2ced8
    clr.w   d2
    bra.b   .l2ceee
.l2ced8:
    cmpi.w  #$2, d2
    bne.b   .l2cee2
    moveq   #$B,d2
    bra.b   .l2ceee
.l2cee2:
    cmpi.w  #$b, d2
    bne.b   .l2ceec
    moveq   #$3,d2
    bra.b   .l2ceee
.l2ceec:
    addq.w  #$1, d2
.l2ceee:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF17E8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2cece
    bra.b   .l2cea6
.l2cf02:
    cmpi.w  #$c, d2
    bcc.b   .l2cf44
    cmpi.w  #$b, d2
    bne.b   .l2cf2e
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1458                                 ; jsr $02E374(pc)
    nop
    lea     $c(a7), a7
    cmpi.w  #$10, d0
    bcs.b   .l2cf44
    bra.w   .l2cd14
.l2cf2e:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$03B6                                 ; jsr $02D2EC(pc)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   .l2cd14
.l2cf44:
    move.w  d2, d0
    movem.l -$9c(a6), d2-d5/a2-a4
    unlk    a6
    rts

; ============================================================================
; ShowRoutePanel -- (TODO: name)
; 444 bytes | $02CF50-$02D10B
; ============================================================================
ShowRoutePanel:
    link    a6,#$0
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    movea.l  #$00000D64,a4
    movea.l  #$0004E65E,a5
    jsr ResourceLoad
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    pea     ($0001).w
    jsr CmdSetBackground
    pea     ($0010).w
    pea     ($0030).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, d0
    addi.l  #$e8, d0
    move.l  d0, -(a7)
    pea     ($0063).w
    pea     ($017B).w
    jsr VRAMBulkLoad
    lea     $30(a7), a7
    movea.l  #$00FF17E8,a3
    movea.l  #$00FF1480,a2
    clr.w   d2
.l2cfca:
    cmpi.w  #$1, (a3)
    bne.b   .l2d016
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    add.l   d0, d0
    lea     (a5,d0.l), a0
    lea     $22(a0), a0
    move.l  a0, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  $2(a2), d1
    add.l   d1, d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$0,d1
    move.w  (a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
.l2d016:
    addq.l  #$2, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$b, d2
    bcs.b   .l2cfca
    move.l  a5, d0
    addi.l  #$d6, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  $2(a2), d1
    add.l   d1, d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$0,d1
    move.w  (a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A7DA).l
    jsr DisplaySetup
    lea     $28(a7), a7
    pea     ($0004A7FA).l
    pea     ($000C).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004AAFA).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($017A).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    pea     ($077F).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    movem.l -$1c(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; ShowCharPanelS2 -- (TODO: name)
; 344 bytes | $02D10C-$02D263
; ============================================================================
ShowCharPanelS2:
    link    a6,#$0
    movem.l d2/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    movea.l  #$00000D64,a5
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1480,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$b, d2
    bge.b   .l2d154
    move.w  d2, d0
    mulu.w  #$90, d0
    add.w   d0, d0
    movea.l  #$0004F3A6,a0
    pea     (a0, d0.w)
    bra.b   .l2d15a
.l2d154:
    pea     ($0004FEE6).l
.l2d15a:
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0640).w
    jsr DrawTileGrid
    pea     ($6000).w
    pea     ($0003).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0640).w
    jsr TilePlacement
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0020).w
    pea     ($000F).w
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0014).w
    pea     ($0010).w
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    cmpi.w  #$b, d2
    bge.b   .l2d22c
    pea     ($0010).w
    pea     ($0008).w
    jsr     (a4)
    tst.w   d2
    beq.b   .l2d208
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    bra.b   .l2d20e
.l2d208:
    pea     ($0004465A).l
.l2d20e:
    pea     ($0004465E).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($0016).w
    jsr     (a4)
    lea     $18(a7), a7
    pea     ($00044652).l
    bra.b   .l2d258
.l2d22c:
    cmpi.w  #$b, d2
    bne.b   .l2d25a
    pea     ($0010).w
    pea     ($0008).w
    jsr     (a4)
    pea     ($00044646).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($0016).w
    jsr     (a4)
    lea     $14(a7), a7
    pea     ($00044640).l
.l2d258:
    jsr     (a3)
.l2d25a:
    movem.l -$14(a6), d2/a2-a5
    unlk    a6
    rts

; ============================================================================
; CheckCharGroup -- (TODO: name)
; 136 bytes | $02D264-$02D2EB
; ============================================================================
CheckCharGroup:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d2
    move.l  $10(a7), d3
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF880C,a0
    move.w  (a0,d0.w), d2
    moveq   #$1,d4
.l2d280:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00E8                                 ; jsr $02D376(pc)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l2d2e6
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0160                                 ; jsr $02D40C(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    clr.w   d4
    cmpi.w  #$ff, d2
    bne.b   .l2d2d0
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2d2e6
.l2d2d0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$07C2                                 ; jsr $02DAA0(pc)
    nop
    addq.l  #$8, a7
    bra.b   .l2d280
.l2d2e6:
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; ProcessCrewSalary -- (TODO: name)
; 138 bytes | $02D2EC-$02D375
; ============================================================================
ProcessCrewSalary:
    movem.l d2-d3/a2, -(a7)
    move.l  $10(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.l   $6(a2)
    bge.b   .l2d32e
    clr.w   d2
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004847A).l, -(a7)
.l2d31c:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    bra.b   .l2d36e
.l2d32e:
    move.w  d3, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l2d342:
    cmpi.b  #$a, $1(a2)
    bcs.b   .l2d354
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   .l2d342
.l2d354:
    cmpi.w  #$5, d2
    bne.b   .l2d36c
    clr.w   d2
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004847E).l, -(a7)
    bra.b   .l2d31c
.l2d36c:
    moveq   #$1,d2
.l2d36e:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; CheckCharSlotFull -- (TODO: name)
; 150 bytes | $02D376-$02D40B
; ============================================================================
CheckCharSlotFull:
    movem.l d2-d3/a2, -(a7)
    move.l  $10(a7), d2
    move.l  $14(a7), d3
    move.w  d2, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l2d396:
    cmpi.b  #$a, $1(a2)
    bcs.b   .l2d3a8
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   .l2d396
.l2d3a8:
    cmpi.w  #$5, d2
    bne.b   .l2d402
    clr.w   d2
    move.w  d3, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d3
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004849E).l, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1F6C                                 ; jsr $02F34A(pc)
    nop
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484AE).l, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1F52                                 ; jsr $02F34A(pc)
    nop
    lea     $28(a7), a7
    bra.b   .l2d404
.l2d402:
    moveq   #$1,d2
.l2d404:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; TransferCharacter -- (TODO: name)
; 1268 bytes | $02D40C-$02D8FF
; ============================================================================
TransferCharacter:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$0004848A,a5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  $e(a6), d4
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00FF880C,a0
    move.w  (a0,d0.w), -$2(a6)
    cmpi.w  #$1, $12(a6)
    bne.w   .l2d4ec
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$047A                                 ; jsr $02D900(pc)
    nop
    lea     $10(a7), a7
    jsr ResourceUnload
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d4c2
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $2c(a5), -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1E92                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    bra.b   .l2d506
.l2d4c2:
    move.l  $10(a5), -(a7)
    move.l  ($000484BA).l, -(a7)
    pea     ($00044662).l
    pea     -$84(a6)
    jsr sprintf
    lea     $10(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)
    bra.b   .l2d510
.l2d4ec:
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0402                                 ; jsr $02D900(pc)
    nop
    lea     $10(a7), a7
.l2d506:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $10(a5), -(a7)
.l2d510:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1E32                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    clr.w   d2
    clr.w   -$88(a6)
    bra.b   .l2d55e
.l2d528:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF17C8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2d55c
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d55c
    addq.w  #$1, -$88(a6)
.l2d55c:
    addq.w  #$1, d2
.l2d55e:
    cmpi.w  #$10, d2
    bcs.b   .l2d528
    clr.w   d6
.l2d566:
    pea     ($0004).w
    pea     ($000E).w
    jsr GameCommand
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    lea     $10(a7), a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d5a6
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2d5a2
    addq.l  #$1, d0
.l2d5a2:
    asr.l   #$1, d0
    move.w  d0, d2
.l2d5a6:
    cmp.w   ($00FF17C6).l, d4
    beq.b   .l2d60e
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    move.w  d0, d2
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d5f2
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2d5ee
    addq.l  #$1, d0
.l2d5ee:
    asr.l   #$1, d0
    move.w  d0, d2
.l2d5f2:
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$02FA                                 ; jsr $02D900(pc)
    nop
    lea     $18(a7), a7
.l2d60e:
    cmpi.w  #$1, -$88(a6)
    bls.w   .l2d6b0
    addq.w  #$1, d6
    cmpi.w  #$1, d6
    bne.b   .l2d690
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0050).w
    pea     ($007C).w
    pea     ($0039).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0098).w
    pea     ($007C).w
    pea     ($003A).w
    pea     ($0771).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l2d67e:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.b   .l2d6b0
.l2d690:
    cmpi.w  #$64, d6
    bne.b   .l2d6a8
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2d67e
.l2d6a8:
    cmpi.w  #$c8, d6
    bne.b   .l2d6b0
    clr.w   d6
.l2d6b0:
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, -$4(a6)
    andi.w  #$20, d0
    beq.w   .l2d822
    clr.w   d7
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1E66                                 ; jsr $02F548(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, -$86(a6)
    move.w  d5, d0
    mulu.w  #$14, d0
    move.w  -$86(a6), d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    cmpi.w  #$5, -$86(a6)
    bne.b   .l2d734
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $14(a5), -(a7)
    bra.w   .l2d7c6
.l2d734:
    cmpi.b  #$a, $1(a2)
    bcs.b   .l2d790
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $18(a5), -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1BFA                                 ; jsr $02F34A(pc)
    nop
    movea.l  #$00FF1278,a0
    move.b  (a0,d4.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $28(a5), -(a7)
    pea     -$84(a6)
    jsr sprintf
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)
    bra.b   .l2d7c6
.l2d790:
    moveq   #$0,d0
    move.w  d2, d0
    cmp.l   $6(a4), d0
    ble.b   .l2d7a8
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $1c(a5), -(a7)
    bra.b   .l2d7c6
.l2d7a8:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    moveq   #$63,d1
    cmp.l   d0, d1
    bgt.b   .l2d7d8
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $20(a5), -(a7)
.l2d7c6:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1B7C                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    moveq   #$1,d7
.l2d7d8:
    cmpi.w  #$1, d7
    bne.b   .l2d7fc
.l2d7de:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $10(a5), -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1B5A                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    bra.w   .l2d566
.l2d7fc:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$023E                                 ; jsr $02DA42(pc)
    nop
    addq.l  #$4, a7
    move.w  d0, -$4(a6)
    cmpi.w  #$1, -$4(a6)
    beq.w   .l2d8f4
    tst.w   -$4(a6)
    bne.w   .l2d8e0
    bra.b   .l2d7de
.l2d822:
    move.w  -$4(a6), d0
    andi.w  #$10, d0
    beq.b   .l2d850
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $24(a5), -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1B0A                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    move.w  #$ff, d4
    bra.w   .l2d8f4
.l2d850:
    move.w  -$4(a6), d0
    andi.w  #$1, d0
    beq.b   .l2d898
.l2d85a:
    cmp.w   -$2(a6), d4
    bne.b   .l2d864
    moveq   #$F,d4
    bra.b   .l2d866
.l2d864:
    subq.w  #$1, d4
.l2d866:
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d85a
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FF17C8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2d85a
    bra.b   .l2d8e0
.l2d898:
    move.w  -$4(a6), d0
    andi.w  #$2, d0
    beq.b   .l2d8e0
.l2d8a2:
    cmpi.w  #$f, d4
    bne.b   .l2d8ae
    move.w  -$2(a6), d4
    bra.b   .l2d8b0
.l2d8ae:
    addq.w  #$1, d4
.l2d8b0:
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d8a2
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FF17C8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2d8a2
.l2d8e0:
    pea     ($0004).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l2d566
.l2d8f4:
    move.w  d4, d0
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; RenderCharTransfer -- (TODO: name)
; 322 bytes | $02D900-$02DA41
; ============================================================================
RenderCharTransfer:
    link    a6,#$0
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d4
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$1, $12(a6)
    bne.b   .l2d984
    cmpi.w  #$1, $16(a6)
    bne.b   .l2d97e
    pea     ($0002).w
    pea     ($0001).w
    pea     ($000A).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowCharProfile
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004E3AC).l
    jsr DisplaySetup
    lea     $24(a7), a7
.l2d97e:
    move.w  d2, ($00FF17C6).l
.l2d984:
    pea     ($0002).w
    pea     ($000A).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowCharStats
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0014).w
    pea     ($0002).w
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.b  $6(a2), d0
    addi.l  #$76c, d0
    move.l  d0, -(a7)
    pea     ($00044674).l
    jsr     (a3)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    move.w  d0, d2
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d4.w), d3
    andi.l  #$ff, d3
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    cmp.w   d3, d0
    bne.b   .l2da0e
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2da0a
    addq.l  #$1, d0
.l2da0a:
    asr.l   #$1, d0
    move.w  d0, d2
.l2da0e:
    pea     ($0016).w
    pea     ($0002).w
    jsr     (a4)
    pea     ($0004466E).l
    jsr     (a3)
    pea     ($0016).w
    pea     ($0007).w
    jsr     (a4)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($00044668).l
    jsr     (a3)
    movem.l -$18(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; DrawCharStatus -- (TODO: name)
; 94 bytes | $02DA42-$02DA9F
; ============================================================================
DrawCharStatus:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    movea.l  #$00FF1278,a0
    move.b  (a0,d2.w), d3
    andi.l  #$ff, d3
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$000484EA,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$18BA                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; ManageCharStatsS2 -- (TODO: name)
; 970 bytes | $02DAA0-$02DE69
; ============================================================================
ManageCharStatsS2:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d7
    movea.l  #$00000D64,a5
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  #$1, -$2(a6)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1A6C                                 ; jsr $02F548(pc)
    nop
    move.w  d0, -$86(a6)
    move.w  d4, d0
    mulu.w  #$14, d0
    move.w  -$86(a6), d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d7, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    move.w  d0, d6
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   .l2db58
    moveq   #$0,d0
    move.w  d6, d0
    bge.b   .l2db54
    addq.l  #$1, d0
.l2db54:
    asr.l   #$1, d0
    move.w  d0, d6
.l2db58:
    move.l  $6(a4), d0
    moveq   #$0,d1
    move.w  d6, d1
    jsr SignedDiv
    move.w  d0, d3
    cmpi.w  #$a, d3
    bcc.b   .l2db74
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2db76
.l2db74:
    moveq   #$A,d0
.l2db76:
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ble.b   .l2db92
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2db9e
.l2db92:
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, d0
.l2db9e:
    move.w  d0, d3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$63,d1
    sub.l   d0, d1
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ble.b   .l2dbc0
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   .l2dbd2
.l2dbc0:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$63,d1
    sub.l   d0, d1
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.l   d0, d1
    move.l  d1, d0
.l2dbd2:
    move.w  d0, d3
    move.l  #$8000, -(a7)
    pea     ($0005).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$1, d0
    beq.b   .l2dc04
    pea     ($000446AE).l
    bra.b   .l2dc0a
.l2dc04:
    pea     ($000446A8).l
.l2dc0a:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004848A).l, -(a7)
    pea     -$84(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1716                                 ; jsr $02F34A(pc)
    nop
    pea     ($0050).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0226                                 ; jsr $02DE6A(pc)
    nop
    clr.l   -(a7)
    jsr ReadInput
    lea     $30(a7), a7
    tst.w   d0
    beq.b   .l2dc5c
    moveq   #$1,d2
    bra.b   .l2dc5e
.l2dc5c:
    moveq   #$0,d2
.l2dc5e:
    tst.w   d2
    beq.b   .l2dc7e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l2dc7e
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l2dc5e
.l2dc7e:
    clr.w   d2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    moveq   #$0,d0
    move.w  -$86(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$01C6                                 ; jsr $02DE6C(pc)
    nop
    lea     $18(a7), a7
    move.w  d0, -$4(a6)
    andi.w  #$20, d0
    beq.w   .l2ddce
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0016).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  d6, d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  -$2(a6), d0
    subq.l  #$1, d0
    beq.b   .l2dcfc
    pea     ($000446A0).l
    bra.b   .l2dd02
.l2dcfc:
    pea     ($0004469A).l
.l2dd02:
    moveq   #$0,d0
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    move.l  ($0004848E).l, -(a7)
    pea     -$84(a6)
    jsr sprintf
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$84(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1618                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, -$4(a6)
    cmpi.w  #$1, -$4(a6)
    bne.b   .l2dd7c
    moveq   #$0,d0
    move.w  d6, d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    jsr Multiply32
    sub.l   d0, $6(a4)
    move.b  d7, (a2)
    move.b  -$1(a6), d0
    add.b   d0, $1(a2)
    move.b  #$1, $2(a2)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048492).l, -(a7)
    bra.w   .l2de0a
.l2dd7c:
    tst.w   -$4(a6)
    bne.w   .l2dc5e
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$1, d0
    beq.b   .l2dd94
    pea     ($00044692).l
    bra.b   .l2dd9a
.l2dd94:
    pea     ($0004468C).l
.l2dd9a:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004848A).l, -(a7)
    pea     -$84(a6)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1588                                 ; jsr $02F34A(pc)
    nop
    lea     $24(a7), a7
    bra.w   .l2dc5e
.l2ddce:
    move.w  -$4(a6), d0
    andi.w  #$10, d0
    beq.w   .l2dc5e
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0016).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048496).l, -(a7)
.l2de0a:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1538                                 ; jsr $02F34A(pc)
    nop
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; FinalizeTransfer -- (TODO: name)
; 2 bytes | $02DE6A-$02DE6B
; ============================================================================
FinalizeTransfer:
    rts

; ============================================================================
; DrawCharPanelS2 -- (TODO: name)
; 918 bytes | $02DE6C-$02E201
; ============================================================================
DrawCharPanelS2:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d4
    move.l  $1c(a6), d7
    movea.l $14(a6), a2
    movea.l  #$00000D64,a4
    movea.l  #$0001E044,a5
    move.w  d2, d0
    mulu.w  #$14, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d3
    move.b  $1(a3), d3
    add.w   (a2), d3
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004E3AC).l
    jsr DisplaySetup
    pea     ($0004E498).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0028).w
    pea     ($005B).w
    jsr VRAMBulkLoad
    pea     ($0004E3CC).l
    pea     ($0006).w
    pea     ($0011).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$02B8                                 ; jsr $02E202(pc)
    nop
    lea     $c(a7), a7
    moveq   #$0,d2
    move.b  $1(a3), d2
    bra.w   .l2dfe6
.l2df5c:
    addq.w  #$1, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2df84
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2df76
    addq.l  #$1, d0
.l2df76:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addi.w  #$fff8, d4
    bra.b   .l2df96
.l2df84:
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2df8c
    addq.l  #$1, d0
.l2df8c:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addq.w  #$8, d4
.l2df96:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d6
    lsl.w   #$4, d6
    addi.w  #$a8, d6
    subq.w  #$1, d2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    addq.w  #$1, d2
.l2dfe6:
    cmp.w   d3, d2
    bcs.w   .l2df5c
    clr.w   d2
.l2dfee:
    pea     ($0004).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0014).w
    pea     ($001C).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    pea     ($000446BC).l
    jsr PrintfWide
    pea     ($0016).w
    pea     ($0014).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$0,d1
    move.w  (a2), d1
    jsr Multiply32
    move.l  d0, -(a7)
    pea     ($000446B6).l
    jsr PrintfWide
    lea     $30(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$1, d2
    bne.b   .l2e0b8
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0080).w
    pea     ($003A).w
    pea     ($0773).w
    jsr     (a5)
    lea     $1c(a7), a7
.l2e0aa:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l2e0d8
.l2e0b8:
    cmpi.w  #$f, d2
    bne.b   .l2e0d0
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2e0aa
.l2e0d0:
    cmpi.w  #$1e, d2
    bne.b   .l2e0d8
    clr.w   d2
.l2e0d8:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d5
    andi.w  #$20, d0
    bne.w   .l2e1f6
    move.w  d5, d0
    andi.w  #$10, d0
    bne.w   .l2e1f6
    move.w  d5, d0
    andi.w  #$4, d0
    beq.b   .l2e148
    cmpi.w  #$1, (a2)
    bls.w   .l2e1e6
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$A,d1
    sub.l   d0, d1
    addq.l  #$1, d1
    move.l  d1, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    subq.w  #$1, (a2)
    subq.w  #$1, d3
    bra.w   .l2e1e6
.l2e148:
    move.w  d5, d0
    andi.w  #$8, d0
    beq.w   .l2e1e6
    move.w  (a2), d0
    cmp.w   $1a(a6), d0
    bcc.w   .l2e1e6
    addq.w  #$1, (a2)
    addq.w  #$1, d3
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2e186
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   .l2e178
    addq.l  #$1, d0
.l2e178:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addi.w  #$fff8, d4
    bra.b   .l2e198
.l2e186:
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   .l2e18e
    addq.l  #$1, d0
.l2e18e:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addq.w  #$8, d4
.l2e198:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d6
    lsl.w   #$4, d6
    addi.w  #$a8, d6
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$A,d1
    sub.l   d0, d1
    addq.l  #$1, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
.l2e1e6:
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   .l2dfee
.l2e1f6:
    move.w  d5, d0
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; RenderCharDetails -- (TODO: name)
; 210 bytes | $02E202-$02E2D3
; ============================================================================
RenderCharDetails:
    movem.l d2-d4/a2, -(a7)
    move.l  $1c(a7), d2
    move.l  $14(a7), d3
    move.w  d3, d0
    mulu.w  #$14, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.w   .l2e2be
.l2e22c:
    addq.w  #$1, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2e254
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2e246
    addq.l  #$1, d0
.l2e246:
    asr.l   #$1, d0
    move.l  d0, d3
    mulu.w  #$18, d3
    addi.w  #$fff8, d3
    bra.b   .l2e266
.l2e254:
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2e25c
    addq.l  #$1, d0
.l2e25c:
    asr.l   #$1, d0
    move.l  d0, d3
    mulu.w  #$18, d3
    addq.w  #$8, d3
.l2e266:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d4
    lsl.w   #$4, d4
    addi.w  #$a8, d4
    subq.w  #$1, d2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d2
.l2e2be:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    cmp.l   d1, d0
    blt.w   .l2e22c
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; SelectCharSlot -- (TODO: name)
; 160 bytes | $02E2D4-$02E373
; ============================================================================
SelectCharSlot:
    movem.l d2-d5, -(a7)
    move.l  $14(a7), d4
    moveq   #$1,d3
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0086                                 ; jsr $02E374(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$10, d5
    bcc.b   .l2e36e
.l2e2fe:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0062                                 ; jsr $02E374(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.b   .l2e36e
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0130                                 ; jsr $02E466(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    move.w  d2, d5
    clr.w   d3
    cmpi.w  #$10, d2
    bcc.b   .l2e36e
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0580                                 ; jsr $02E8D8(pc)
    nop
    addq.l  #$8, a7
    move.w  d0, d2
    beq.b   .l2e2fe
    dc.w    $4EBA,$0E6E                                 ; jsr $02F1D2(pc)
    nop
    cmpi.w  #$1, d0
    beq.b   .l2e2fe
.l2e36e:
    movem.l (a7)+, d2-d5
    rts

; ============================================================================
; FindAvailableSlot -- (TODO: name)
; 242 bytes | $02E374-$02E465
; ============================================================================
FindAvailableSlot:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $28(a7), d2
    move.l  $20(a7), d5
    move.l  $24(a7), d6
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    adda.l  d0, a0
    tst.b   $1(a0)
    beq.b   .l2e3a8
    move.w  d2, d4
    bra.w   .l2e45e
.l2e3a8:
    move.w  #$ff, d4
    move.w  d2, d3
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.b   .l2e3b8
    clr.w   d3
.l2e3b8:
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    lea     (a3,d0.l), a0
    movea.l a0, a2
    move.w  d3, d2
    bra.b   .l2e3d6
.l2e3c8:
    tst.b   $1(a2)
    beq.b   .l2e3d2
    move.w  d2, d4
    bra.b   .l2e3dc
.l2e3d2:
    addq.l  #$2, a2
    addq.w  #$1, d2
.l2e3d6:
    cmpi.w  #$10, d2
    bcs.b   .l2e3c8
.l2e3dc:
    cmpi.w  #$ff, d4
    bne.b   .l2e3fa
    movea.l a3, a2
    clr.w   d2
    bra.b   .l2e3f6
.l2e3e8:
    tst.b   $1(a2)
    beq.b   .l2e3f2
    move.w  d2, d4
    bra.b   .l2e3fa
.l2e3f2:
    addq.l  #$2, a2
    addq.w  #$1, d2
.l2e3f6:
    cmp.w   d3, d2
    bcs.b   .l2e3e8
.l2e3fa:
    cmpi.w  #$ff, d4
    bne.b   .l2e45e
    cmpi.w  #$1, d6
    bne.b   .l2e422
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048486).l, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    bra.b   .l2e456
.l2e422:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484E2).l, -(a7)
    pea     ($000B).w
    dc.w    $4EBA,$0F14                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484E6).l, -(a7)
    pea     ($000B).w
    dc.w    $4EBA,$0EF8                                 ; jsr $02F34A(pc)
    nop
.l2e456:
    lea     $14(a7), a7
    move.w  #$ff, d4
.l2e45e:
    move.w  d4, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts

; ============================================================================
; AddCharToTeam -- (TODO: name)
; 1138 bytes | $02E466-$02E8D7
; ============================================================================
AddCharToTeam:
    link    a6,#-$84
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6
    movea.l  #$000484BA,a3
    movea.l  #$0002F34A,a4
    movea.l  #$00000D64,a5
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   .l2e490
    addq.l  #$3, d0
.l2e490:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, -$2(a6)
    clr.w   d4
    clr.w   d2
.l2e49e:
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    tst.b   (a0,d0.w)
    beq.b   .l2e4b6
    addq.w  #$1, d4
.l2e4b6:
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   .l2e49e
    cmpi.w  #$1, d4
    bls.b   .l2e4c8
    moveq   #$0,d7
    bra.b   .l2e4ca
.l2e4c8:
    moveq   #$1,d7
.l2e4ca:
    move.w  $e(a6), d2
    cmpi.w  #$1, $12(a6)
    bne.b   .l2e546
    jsr ResourceLoad
    jsr PreLoopInit
    jsr ResourceUnload
    move.l  $4(a3), -(a7)
    move.l  ($000484BA).l, -(a7)
    pea     ($000446CA).l
    pea     -$82(a6)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$82(a6)
    pea     ($000B).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0002).w
    pea     ($0001).w
    pea     ($000A).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr ShowCharProfile
    lea     $18(a7), a7
    move.w  d2, ($00FF17C6).l
    bra.w   .l2e5d0
.l2e546:
    move.l  #$8000, -(a7)
    pea     ($000E).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000E).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    lea     $28(a7), a7
    pea     ($0002).w
    pea     ($0001).w
    pea     ($000A).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr ShowCharProfile
    move.w  d2, ($00FF17C6).l
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $4(a3), -(a7)
    pea     ($000B).w
    jsr     (a4)
    lea     $2c(a7), a7
.l2e5d0:
    cmp.w   ($00FF17C6).l, d2
    beq.b   .l2e600
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr ShowCharStats
    lea     $14(a7), a7
    move.w  d2, ($00FF17C6).l
.l2e600:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0014).w
    pea     ($001D).w
    jsr SetTextCursor
    pea     ($0001).w
    pea     ($000446C6).l
    jsr PrintfWide
    pea     ($0014).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0003).w
    jsr PlaceIconTiles
    lea     $30(a7), a7
    pea     ($0004).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0BC2                                 ; jsr $02F218(pc)
    nop
    addq.l  #$8, a7
    clr.w   d3
.l2e65e:
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    cmp.w   ($00FF17C6).l, d2
    beq.b   .l2e69a
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr ShowCharStats
    lea     $14(a7), a7
    move.w  d2, ($00FF17C6).l
.l2e69a:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0E4C                                 ; jsr $02F4EE(pc)
    nop
    move.w  d0, d4
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0016).w
    pea     ($0013).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($000446C0).l
    jsr PrintfWide
    lea     $24(a7), a7
    tst.w   d7
    bne.w   .l2e774
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   .l2e754
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0050).w
    pea     ($007C).w
    pea     ($0039).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0098).w
    pea     ($007C).w
    pea     ($003A).w
    pea     ($0771).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l2e746:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l2e774
.l2e754:
    cmpi.w  #$50, d3
    bne.b   .l2e76c
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2e746
.l2e76c:
    cmpi.w  #$a0, d3
    bne.b   .l2e774
    clr.w   d3
.l2e774:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.w   .l2e844
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)
    bne.b   .l2e7c0
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $28(a3), -(a7)
.l2e7b2:
    pea     ($000B).w
    jsr     (a4)
    lea     $14(a7), a7
    bra.w   .l2e65e
.l2e7c0:
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $7(a2), d0
    cmp.w   -$2(a6), d0
    bcc.b   .l2e7ec
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  $10(a3), -(a7)
    bra.b   .l2e81c
.l2e7ec:
    move.w  -$2(a6), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $6(a2), d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$F,d1
    cmp.l   d0, d1
    bgt.b   .l2e810
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  $c(a3), -(a7)
    bra.b   .l2e81c
.l2e810:
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  $8(a3), -(a7)
.l2e81c:
    pea     ($000B).w
    jsr     (a4)
    lea     $14(a7), a7
    move.w  d0, d5
    cmpi.w  #$1, d5
    beq.w   .l2e8cc
    tst.w   d5
    bne.w   .l2e8bc
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $4(a3), -(a7)
    bra.w   .l2e7b2
.l2e844:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l2e868
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $2c(a3), -(a7)
    pea     ($000B).w
    jsr     (a4)
    lea     $14(a7), a7
    move.w  #$ff, d2
    bra.b   .l2e8cc
.l2e868:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l2e892
.l2e870:
    tst.w   d2
    bne.b   .l2e878
    moveq   #$F,d2
    bra.b   .l2e87a
.l2e878:
    subq.w  #$1, d2
.l2e87a:
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    tst.b   (a0,d0.w)
    beq.b   .l2e870
    bra.b   .l2e8bc
.l2e892:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l2e8bc
.l2e89a:
    cmpi.w  #$f, d2
    bne.b   .l2e8a4
    clr.w   d2
    bra.b   .l2e8a6
.l2e8a4:
    addq.w  #$1, d2
.l2e8a6:
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    tst.b   (a0,d0.w)
    beq.b   .l2e89a
.l2e8bc:
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l2e65e
.l2e8cc:
    move.w  d2, d0
    movem.l -$ac(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; UpdateCharDisplayS2 -- (TODO: name)
; 686 bytes | $02E8D8-$02EB85
; ============================================================================
UpdateCharDisplayS2:
    link    a6,#-$54
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d5
    lea     -$2(a6), a4
    lea     -$52(a6), a5
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  #$1, (a4)
    moveq   #$0,d6
    move.b  $1(a2), d6
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0BD6                                 ; jsr $02F4EE(pc)
    nop
    move.w  d0, d3
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.l  #$8000, -(a7)
    pea     ($0011).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $20(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0011).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($000A).w
    pea     ($0010).w
    pea     ($000A).w
    pea     ($0001).w
    jsr DrawBox
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($000B).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    lea     $18(a7), a7
.l2e9b4:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($000484CE).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    dc.w    $4EBA,$0974                                 ; jsr $02F34A(pc)
    nop
    lea     $20(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$018A                                 ; jsr $02EB86(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    andi.w  #$20, d0
    beq.w   .l2eb6e
    moveq   #$0,d0
    move.w  (a4), d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a4), d0
    move.l  d0, -(a7)
    move.l  ($000484D2).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    dc.w    $4EBA,$0908                                 ; jsr $02F34A(pc)
    nop
    lea     $24(a7), a7
    move.w  d0, d2
    cmpi.w  #$1, d2
    bne.w   .l2eb64
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    moveq   #$0,d0
    move.w  (a4), d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    add.l   d0, $6(a3)
    move.b  $1(a4), d0
    sub.b   d0, (a2)
    move.b  $1(a4), d0
    sub.b   d0, $1(a2)
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$071C                                 ; jsr $02F218(pc)
    nop
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  (a4), d0
    subq.l  #$1, d0
    beq.b   .l2eb14
    pea     ($000446D2).l
    bra.b   .l2eb1a
.l2eb14:
    pea     ($000446D0).l
.l2eb1a:
    movea.l  #$00FF1278,a0
    move.b  (a0,d4.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  (a4), d0
    move.l  d0, -(a7)
    move.l  ($000484D6).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    dc.w    $4EBA,$07F0                                 ; jsr $02F34A(pc)
    nop
    lea     $28(a7), a7
    bra.b   .l2eb7a
.l2eb64:
    tst.w   d2
    bne.w   .l2e9b4
    bra.w   .l2e9b4
.l2eb6e:
    move.w  d2, d0
    andi.w  #$10, d0
    beq.w   .l2e9b4
    clr.w   (a4)
.l2eb7a:
    move.w  (a4), d0
    movem.l -$78(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; ReadCharInput -- (TODO: name)
; 1100 bytes | $02EB86-$02EFD1
; ============================================================================
ReadCharInput:
    link    a6,#-$70
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $14(a6), d7
    movea.l $10(a6), a2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    movea.l  #$00000D64,a5
    moveq   #$1,d6
    moveq   #$14,d5
    moveq   #$15,d2
    moveq   #$A,d3
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    jsr DisplaySetup
    move.l  ($000A1B04).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
    pea     ($0007194C).l
    pea     ($0006).w
    pea     ($000A).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.w   d2
.l2ec38:
    move.w  d2, d0
    addi.w  #$3d94, d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$70(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$24, d2
    bcs.b   .l2ec38
    clr.w   d2
.l2ec50:
    move.w  d2, d0
    addi.w  #$2d7f, d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$28(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    bcs.b   .l2ec50
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $2c(a7), a7
    moveq   #$1,d2
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($00044704).l
    jsr     (a3)
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($00044700).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a4)
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.w  (a2), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    pea     ($000446FA).l
    jsr     (a3)
    lea     $2c(a7), a7
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000446F6).l
    jsr     (a3)
    pea     ($0001).w
    dc.w    $4EBA,$02AA                                 ; jsr $02EFD2(pc)
    nop
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000446F2).l
    jsr     (a3)
    lea     $2c(a7), a7
    move.w  d7, d0
    ext.l   d0
    subq.l  #$1, d0
    bgt.b   .l2ed7a
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
    clr.w   d2
.l2ed7a:
    clr.w   d3
.l2ed7c:
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   .l2edec
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0050).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l2edde:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l2ee0c
.l2edec:
    cmpi.w  #$1f4, d3
    bne.b   .l2ee04
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2edde
.l2ee04:
    cmpi.w  #$3e8, d3
    bne.b   .l2ee0c
    clr.w   d3
.l2ee0c:
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d4
    andi.w  #$20, d0
    bne.w   .l2efc6
    move.w  d4, d0
    andi.w  #$10, d0
    beq.b   .l2ee3c
    jsr PreLoopInit
    bra.w   .l2efc6
.l2ee3c:
    move.w  d4, d0
    andi.w  #$4, d0
    beq.w   .l2eef6
    cmpi.w  #$1, (a2)
    ble.w   .l2ed7c
    subq.w  #$1, (a2)
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000446EE).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a4)
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.w  (a2), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    pea     ($000446E8).l
    jsr     (a3)
    lea     $20(a7), a7
    tst.w   d2
    bne.b   .l2eebe
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
    moveq   #$1,d2
.l2eebe:
    clr.l   -(a7)
    dc.w    $4EBA,$0110                                 ; jsr $02EFD2(pc)
    nop
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000446E4).l
.l2eeee:
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l2ed7c
.l2eef6:
    move.w  d4, d0
    andi.w  #$8, d0
    beq.w   .l2ed7c
    cmp.w   (a2), d7
    ble.w   .l2ed7c
    addq.w  #$1, (a2)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000446E0).l
    jsr     (a3)
    pea     ($0001).w
    dc.w    $4EBA,$009E                                 ; jsr $02EFD2(pc)
    nop
    lea     $14(a7), a7
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
    bgt.b   .l2ef84
    cmpi.w  #$1, d2
    bne.b   .l2ef84
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    lea     $28(a7), a7
    clr.w   d2
.l2ef84:
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000446DC).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a4)
    lea     $18(a7), a7
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.w  (a2), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    pea     ($000446D6).l
    bra.w   .l2eeee
.l2efc6:
    move.w  d4, d0
    movem.l -$98(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; HandleCharInteraction -- (TODO: name)
; 512 bytes | $02EFD2-$02F1D1
; ============================================================================
HandleCharInteraction:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d4
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    clr.w   d2
    clr.w   d3
    move.w  #$750, d6
    cmpi.w  #$1, d4
    bne.w   .l2f0dc
    moveq   #$30,d4
    move.w  #$a8, d5
    pea     ($0004).w
    jsr LoadDisplaySet
    addq.l  #$4, a7
    bra.b   .l2f042
.l2f00a:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
.l2f042:
    cmpi.w  #$28, d2
    blt.b   .l2f00a
    bra.b   .l2f08a
.l2f04a:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    addq.w  #$6, d3
.l2f08a:
    cmpi.w  #$48, d3
    blt.b   .l2f04a
    add.w   d2, d4
    clr.w   d2
.l2f094:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    cmpi.w  #$20, d2
    blt.b   .l2f094
    bra.w   .l2f1c4
.l2f0dc:
    move.w  #$c0, d4
    moveq   #$60,d5
    pea     ($0005).w
    jsr LoadDisplaySet
    addq.l  #$4, a7
    bra.b   .l2f12e
.l2f0f0:
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
.l2f12e:
    cmpi.w  #$18, d2
    blt.b   .l2f0f0
    bra.b   .l2f176
.l2f136:
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    addq.w  #$6, d3
.l2f176:
    cmpi.w  #$48, d3
    blt.b   .l2f136
    sub.w   d2, d4
    clr.w   d2
.l2f180:
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    cmpi.w  #$30, d2
    blt.b   .l2f180
.l2f1c4:
    pea     ($0018).w
    jsr     (a2)
    addq.l  #$4, a7
    movem.l (a7)+, d2-d6/a2-a3
    rts

; ============================================================================
; CheckCharLimit -- (TODO: name)
; 70 bytes | $02F1D2-$02F217
; ============================================================================
CheckCharLimit:
    move.l  d2, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000484DA).l, -(a7)
    pea     ($000B).w
    dc.w    $4EBA,$0162                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    tst.w   d2
    bne.b   .l2f212
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000484DE).l, -(a7)
    pea     ($000B).w
    dc.w    $4EBA,$0140                                 ; jsr $02F34A(pc)
    nop
    lea     $14(a7), a7
.l2f212:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts

; ============================================================================
; RefreshCharPanel -- (TODO: name)
; 306 bytes | $02F218-$02F349
; ============================================================================
RefreshCharPanel:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    move.l  $20(a7), d3
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    movea.l  #$00FF00A8,a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    pea     ($0004975E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0008).w
    pea     ($0328).w
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    pea     ($00049706).l
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0019).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    pea     ($0019).w
    pea     ($000A).w
    jsr     (a4)
    addq.l  #$8, a7
    cmpi.w  #$2, d3
    bne.b   .l2f2ea
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    jsr     (a3)
    pea     ($0019).w
    pea     ($0013).w
    jsr     (a4)
    lea     $c(a7), a7
    move.l  $6(a2), -(a7)
    pea     ($00044714).l
    bra.b   .l2f340
.l2f2ea:
    cmpi.w  #$3, d3
    bne.b   .l2f316
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    jsr     (a3)
    pea     ($0019).w
    pea     ($0013).w
    jsr     (a4)
    lea     $c(a7), a7
    move.l  $6(a2), -(a7)
    pea     ($0004470E).l
    bra.b   .l2f340
.l2f316:
    cmpi.w  #$4, d3
    bne.b   .l2f344
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    jsr     (a3)
    pea     ($0019).w
    pea     ($0013).w
    jsr     (a4)
    lea     $c(a7), a7
    move.l  $6(a2), -(a7)
    pea     ($00044708).l
.l2f340:
    jsr     (a3)
    addq.l  #$8, a7
.l2f344:
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; ShowCharInfoPageS2 -- (TODO: name)
; 230 bytes | $02F34A-$02F42F
; ============================================================================
ShowCharInfoPageS2:
    link    a6,#-$4
    movem.l d2-d3, -(a7)
    move.l  $8(a6), d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.l  $c(a6), -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003).w
    pea     ($079E).w
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$000485BE,a0
    move.w  (a0,d0.w), d1
    move.l  d1, -(a7)
    jsr DrawCharInfoPanel
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0008).w
    pea     ($000B).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004471A).l
    jsr PrintfWide
    lea     $20(a7), a7
    cmpi.w  #$1, $16(a6)
    bne.b   .l2f40e
    pea     ($0009).w
    pea     ($0002).w
    jsr SelectPreviewPage
    move.w  d0, d3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0020).w
    pea     ($0008).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $24(a7), a7
    bra.b   .l2f424
.l2f40e:
    cmpi.w  #$1, $1a(a6)
    bne.b   .l2f424
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
.l2f424:
    move.w  d3, d0
    movem.l -$c(a6), d2-d3
    unlk    a6
    rts

; ============================================================================
; ShowCharInfoPage -- (TODO: describe)
; Called: ?? times.
; 190 bytes | $02F430-$02F4ED
; ============================================================================
ShowCharInfoPage:                                                  ; $02F430
    link    a6,#$0
    movem.l d2-d3,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  $000a(a6),d2
    move.l  $000c(a6),-(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0003).w
    pea     ($079E).w
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$000485d6,a0
    move.w  (a0,d0.w),d1
    move.l  d1,-(sp)
    dc.w    $4eb9,$0000,$643c                           ; jsr $00643C
    lea     $0030(sp),sp
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
    cmpi.w  #$1,$0016(a6)
    bne.b   .l2f4cc
    pea     ($0009).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$7784                           ; jsr $007784
    move.w  d0,d3
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0020).w
    pea     ($0008).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    bra.b   .l2f4e2
.l2f4cc:                                                ; $02F4CC
    cmpi.w  #$1,$001a(a6)
    bne.b   .l2f4e2
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
.l2f4e2:                                                ; $02F4E2
    move.w  d3,d0
    movem.l -$0008(a6),d2-d3
    unlk    a6
    rts
; ============================================================================
; CalcCharScore -- (TODO: describe)
; Called: ?? times.
; 90 bytes | $02F4EE-$02F547
; ============================================================================
CalcCharScore:                                                  ; $02F4EE
    movem.l d2/a2,-(sp)
    move.w  $000e(sp),d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l2f512
    addq.l  #$3,d0
.l2f512:                                                ; $02F512
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d2
    ext.l   d0
    moveq   #$3c,d1
    sub.l   d0,d1
    moveq   #$0,d0
    move.b  $0006(a2),d0
    ext.l   d0
    add.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.w  $0004(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    movem.l (sp)+,d2/a2
    rts
; ============================================================================
; FindCharSlotInGroup -- (TODO: describe)
; Called: ?? times.
; 94 bytes | $02F548-$02F5A5
; ============================================================================
FindCharSlotInGroup:                                                  ; $02F548
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d3
    move.w  $0012(sp),d0
    mulu.w  #$14,d0
    movea.l #$00ff02e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    movea.l a0,a2
    clr.w   d2
.l2f568:                                                ; $02F568
    tst.b   $0001(a2)
    beq.b   .l2f57a
    moveq   #$0,d0
    move.b  (a2),d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    beq.b   .l2f584
.l2f57a:                                                ; $02F57A
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$5,d2
    bcs.b   .l2f568
.l2f584:                                                ; $02F584
    cmpi.w  #$5,d2
    bne.b   .l2f59e
    movea.l a1,a2
    clr.w   d2
.l2f58e:                                                ; $02F58E
    tst.b   $0001(a2)
    beq.b   .l2f59e
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$5,d2
    bcs.b   .l2f58e
.l2f59e:                                                ; $02F59E
    move.w  d2,d0
    movem.l (sp)+,d2-d3/a2
    rts
; === Translated block $02F5A6-$02F712 ===
; 1 functions, 364 bytes

; ============================================================================
; GameUpdate1 -- (TODO: name)
; 364 bytes | $02F5A6-$02F711
; ============================================================================
GameUpdate1:
    link    a6,#$0
    movem.l d2-d4/a2-a3, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$0003B270,a3
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0007).w
    jsr SelectMenuItem
    move.w  ($00FF0006).l, d0
    ext.l   d0
    addq.l  #$3, d0
    moveq   #$4,d1
    jsr SignedMod
    move.l  d0, d3
    mulu.w  #$3, d3
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    moveq   #$C,d1
    jsr SignedMod
    move.w  d0, d3
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_2f628
    addq.l  #$3, d0
l_2f628:
    asr.l   #$2, d0
    addi.w  #$7a3, d0
    move.w  d0, d4
    pea     ($001E).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $30(a7), a7
    pea     ($000C).w
    pea     ($000C).w
    jsr SetTextCursor
    jsr ResourceUnload
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005F096,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004472A).l
    jsr     (a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044726).l
    jsr     (a3)
    pea     ($000D).w
    jsr LoadDisplaySet
    lea     $1c(a7), a7
    clr.w   d2
l_2f68e:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000C).w
    pea     ($000C).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($000C).w
    pea     ($000C).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005F096,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044722).l
    jsr     (a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004471E).l
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $18(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_2f68e
    pea     ($0018).w
    jsr     (a2)
    movem.l -$14(a6), d2-d4/a2-a3
    unlk    a6
    rts

ShowQuarterReport:                                                  ; $02F712
    link    a6,#-$a0
    movem.l d2-d6/a2-a5,-(sp)
    lea     -$00a0(a6),a3
    movea.l #$0001183a,a4
    movea.l #$0003b22c,a5
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04c4                                 ; jsr $02FC14
    nop
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    clr.w   ($00FF99A0).l
    clr.l   -(sp)
    move.l  ($00047B48).l,-(sp)
    pea     ($0004).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0464                                 ; jsr $02FBD6
    nop
    lea     $0014(sp),sp
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$4,d0
    sub.l   d1,d0
    lsl.l   #$2,d0
    move.w  ($00FF0006).l,d1
    ext.l   d1
    sub.l   d0,d1
    moveq   #$1,d0
    cmp.l   d1,d0
    bne.b   .l2f7ae
    tst.w   ($00FF14B8).l
    bne.b   .l2f7ae
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0568                                 ; jsr $02FD10
    nop
    addq.l  #$4,sp
.l2f7ae:                                                ; $02F7AE
    tst.l   $0006(a2)
    bge.b   .l2f7c8
    cmpi.b  #$64,$0022(a2)
    bcc.b   .l2f7c8
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05ce                                 ; jsr $02FD90
    nop
    addq.l  #$4,sp
.l2f7c8:                                                ; $02F7C8
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$ff76                           ; jsr $00FF76
    move.w  d0,d4
    clr.l   -(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$fff8                           ; jsr $00FFF8
    lea     $000c(sp),sp
    move.w  d0,d6
    cmpi.w  #$46,($00FF1294).l
    blt.b   .l2f818
    pea     ($0002).w
    move.l  ($00047B28).l,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$03c6                                 ; jsr $02FBD6
    nop
    lea     $0010(sp),sp
.l2f818:                                                ; $02F818
    tst.w   d4
    ble.b   .l2f858
    cmpi.w  #$1,d4
    bne.b   .l2f82a
    pea     ($00044754).l
    bra.b   .l2f830
.l2f82a:                                                ; $02F82A
    pea     ($0004474C).l
.l2f830:                                                ; $02F830
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($00047C70).l,-(sp)
    move.l  a3,-(sp)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3,-(sp)
    pea     ($0002).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0386                                 ; jsr $02FBD6
    nop
    lea     $0020(sp),sp
.l2f858:                                                ; $02F858
    tst.w   d6
    ble.b   .l2f898
    cmpi.w  #$1,d6
    bne.b   .l2f86a
    pea     ($00044744).l
    bra.b   .l2f870
.l2f86a:                                                ; $02F86A
    pea     ($0004473A).l
.l2f870:                                                ; $02F870
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($00047C74).l,-(sp)
    move.l  a3,-(sp)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3,-(sp)
    pea     ($0003).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0346                                 ; jsr $02FBD6
    nop
    lea     $0020(sp),sp
.l2f898:                                                ; $02F898
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0004).w
    move.l  ($00047B44).l,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0018(sp),sp
    tst.w   d0
    bne.b   .l2f8dc
    move.w  #$1,($00FF99A0).l
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0158                                 ; jsr $02FA28
    nop
    lea     $000c(sp),sp
    dc.w    $6000,$013a                                 ; bra.w $02FA14
.l2f8dc:                                                ; $02F8DC
    clr.w   d5
    clr.w   d3
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00047b6c,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00047b60,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($00047B40).l,-(sp)
    move.l  a3,-(sp)
    jsr     (a5)
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0028(sp),sp
    cmpi.w  #$1,d0
    dc.w    $6600,$00e2                                 ; bne.w $02FA08
    moveq   #$2,d5
    move.w  d3,d0
    ext.l   d0
    moveq   #$3,d1
    cmp.l   d1,d0
    dc.w    $6200,$00d6                                 ; bhi.w $02FA0A
    add.l   d0,d0
    move.w  $2f940(pc,d0.l),d0
    jmp     $2f940(pc,d0.w)
    ; WARNING: 232 undecoded trailing bytes at $02F940
    dc.w    $0008
    dc.w    $0018
    dc.w    $00aa
    dc.w    $00b8
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0676
    dc.w    $4e71
    dc.w    $588f
    dc.w    $6000
    dc.w    $00b4
    dc.w    $4a44
    dc.w    $6638
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0004
    dc.w    $2f39
    dc.w    $0004
    dc.w    $7b9c
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0018
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6600
    dc.w    $0088
    dc.w    $3004
    dc.w    $2f00
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0e70
    dc.w    $4e71
    dc.w    $508f
    dc.w    $6076
    dc.w    $3004
    dc.w    $48c0
    dc.w    $72fe
    dc.w    $b280
    dc.w    $66e4
    dc.w    $4879
    dc.w    $0004
    dc.w    $472e
    dc.w    $2f39
    dc.w    $0004
    dc.w    $7b98
    dc.w    $2f0b
    dc.w    $4e95
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0004
    dc.w    $2f0b
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0024
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0004
    dc.w    $2f39
    dc.w    $0004
    dc.w    $7be0
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0018
    dc.w    $6020
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $8214
    dc.w    $6000
    dc.w    $ff5c
    dc.w    $3006
    dc.w    $2f00
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $861a
    dc.w    $6088
    dc.w    $7a01
    dc.w    $5243
    dc.w    $0c43
    dc.w    $0004
    dc.w    $6d00
    dc.w    $fece
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0132
    dc.w    $4e71
    dc.w    $4cee
    dc.w    $3c7c
    dc.w    $ff3c
    dc.w    $4e5e
    dc.w    $4e75

; === Translated block $02FA28-$02FBD6 ===
; 2 functions, 430 bytes

; ============================================================================
; CalcCharScoreS2 -- (TODO: name)
; 292 bytes | $02FA28-$02FB4B
; ============================================================================
CalcCharScoreS2:
    link    a6,#$0
    movem.l d2-d3, -(a7)
    move.l  $8(a6), d3
    move.l  ($000A1B28).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($003E).w
    pea     ($0109).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($000725D8).l
    pea     ($0008).w
    pea     ($0008).w
    pea     ($0008).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
l_2fa80:
    clr.w   d2
l_2fa82:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($00047B4C).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    pea     ($0004).w
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    jsr RunPlayerSelectUI
    lea     $24(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   l_2fae8
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($00047B50).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_2fb42
    bra.b   l_2fa80
l_2fae8:
    move.w  d2, d0
    ext.l   d0
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.b   l_2fa82
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0008
    dc.w    $0018
    dc.w    $0024
    dc.w    $0030
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$04BA                                 ; jsr $02FFC4(pc)
    nop
l_2fb0e:
    addq.l  #$4, a7
    bra.w   l_2fa82
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$11EA                                 ; jsr $030D04(pc)
    nop
    bra.b   l_2fb0e
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowStatsSummary
    bra.b   l_2fb0e
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RunCharManagement
    addq.l  #$8, a7
    bra.w   l_2fa82
l_2fb42:
    movem.l -$8(a6), d2-d3
    unlk    a6
    rts

; ============================================================================
; FindCharSlotInGroupS2 -- (TODO: name)
; 138 bytes | $02FB4C-$02FBD5
; ============================================================================
FindCharSlotInGroupS2:
    link    a6,#-$4
    move.l  d2, -(a7)
    move.l  $8(a6), d2
    clr.l   -(a7)
    pea     ($000B).w
    pea     ($000B).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    clr.l   -(a7)
    move.l  ($00047B54).l, -(a7)
    pea     ($0004).w
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0050                                 ; jsr $02FBD6(pc)
    nop
    lea     $2c(a7), a7
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.l  -$8(a6), d2
    unlk    a6
    rts


; ============================================================================
; ShowText -- Thin wrapper around ShowTextDialog with simplified params
; Called: 37 times.
; 62 bytes | $02FBD6-$02FC13
; ============================================================================
ShowText:                                                  ; $02FBD6
    movem.l d2-d3,-(sp)
    move.l  $0018(sp),d2
    move.l  $0010(sp),d3
    move.l  $000c(sp),d1
    movea.l $0014(sp),a0
    pea     ($0001).w
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a0,-(sp)
    move.w  d1,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0018(sp),sp
    movem.l (sp)+,d2-d3
    rts
; === Translated block $02FC14-$030000 ===
; 3 functions, 1004 bytes

; ============================================================================
; ProcessGameUpdateS2 -- (TODO: name)
; 252 bytes | $02FC14-$02FD0F
; ============================================================================
ProcessGameUpdateS2:
    movem.l d2/a2, -(a7)
    move.l  $c(a7), d2
    movea.l  #$00010CAC,a2
    jsr PreLoopInit
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076AFE).l
    jsr DisplaySetup
    move.l  ($000A1B5C).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($00C2).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
    pea     ($00072E5C).l
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($077D).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr ShowPlayerChart
    pea     ($0006).w
    pea     ($0004).w
    clr.l   -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    pea     ($000C).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    pea     ($000C).w
    pea     ($0019).w
    pea     ($0003).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; UpdateGameLoopS2 -- (TODO: name)
; 128 bytes | $02FD10-$02FD8F
; ============================================================================
UpdateGameLoopS2:
    link    a6,#-$4
    movem.l d2-d4, -(a7)
    move.l  $8(a6), d4
    clr.w   d2
l_2fd1e:
    clr.w   d3
l_2fd20:
    clr.l   -(a7)
    move.w  d2, d0
    add.w   d0, d0
    add.w   d3, d0
    lsl.w   #$2, d0
    movea.l  #$00047C78,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FE98                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    addq.w  #$1, d3
    cmpi.w  #$2, d3
    blt.b   l_2fd20
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_2fd1e
    clr.w   d2
l_2fd56:
    clr.l   -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047C90,a0
    move.l  (a0,d0.w), -(a7)
    tst.w   d2
    bne.b   l_2fd6e
    moveq   #$3,d0
    bra.b   l_2fd70
l_2fd6e:
    moveq   #$0,d0
l_2fd70:
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FE5E                                 ; bsr.w $02FBD6
    lea     $10(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_2fd56
    movem.l -$10(a6), d2-d4
    unlk    a6
    rts

; ============================================================================
; ProcessGameFrame -- (TODO: name)
; 564 bytes | $02FD90-$02FFC3
; ============================================================================
ProcessGameFrame:
    link    a6,#-$A0
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d5
    lea     -$a0(a6), a3
    movea.l  #$0002FBD6,a4
    movea.l  #$00047C40,a5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d6
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $22(a2), d0
    moveq   #$63,d1
    cmp.b   d1, d0
    beq.b   l_2fde2
    moveq   #$62,d1
    cmp.b   d1, d0
    beq.b   l_2fe1c
    moveq   #$61,d1
    cmp.b   d1, d0
    beq.b   l_2fe3c
    bra.w   l_2fe86
l_2fde2:
    pea     ($0002).w
    move.l  ($00047C40).l, -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $8(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    lea     $1c(a7), a7
    pea     ($0002).w
    move.l  a3, -(a7)
    bra.b   l_2fe90
l_2fe1c:
    pea     ($0002).w
    move.l  $4(a5), -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $10(a7), a7
    pea     ($0002).w
    move.l  $c(a5), -(a7)
    bra.b   l_2fe90
l_2fe3c:
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $10(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a3, -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    pea     ($0002).w
    move.l  $14(a5), -(a7)
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $2c(a7), a7
    pea     ($0002).w
    move.l  $18(a5), -(a7)
    bra.b   l_2fe90
l_2fe86:
    pea     ($0002).w
    move.l  ($00047C40).l, -(a7)
l_2fe90:
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.l  $1c(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr SumPlayerStats
    lea     $2c(a7), a7
    tst.w   d0
    ble.b   l_2ff2a
    moveq   #$0,d3
    clr.w   d2
l_2fec8:
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharScore
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    add.l   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   l_2fec8
    move.l  d3, -(a7)
    move.l  $20(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0002).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $1c(a7), a7
l_2ff2a:
    movea.l  #$00FF0018,a0
    lea     (a0,d6.w), a2
    moveq   #$0,d0
    move.b  $4(a2), d0
    moveq   #$0,d1
    move.b  $5(a2), d1
    add.w   d1, d0
    ble.b   l_2ff8e
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CountProfitableRelations
    addq.l  #$4, a7
    move.w  d0, d2
    tst.w   d2
    ble.b   l_2ff8e
    cmpi.w  #$1, d2
    bne.b   l_2ff64
    pea     ($00044762).l
    bra.b   l_2ff6a
l_2ff64:
    pea     ($0004475A).l
l_2ff6a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $24(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0001).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
l_2ff8e:
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcTotalCharValue
    addq.l  #$4, a7
    move.l  d0, d2
    beq.b   l_2ffba
    move.l  d2, -(a7)
    move.l  $28(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0003).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)
l_2ffba:
    movem.l -$c4(a6), d2-d6/a2-a5
    unlk    a6
    rts


; === Translated block $02FFC4-$030000 ===
; 1 functions, 60 bytes

; ============================================================================
; GetCurrentGameMode -- (TODO: name)
; 60 bytes | $02FFC4-$02FFFF
; ============================================================================
GetCurrentGameMode:
    link    a6,#-$15C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    lea     -$1c(a6), a5
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$06DE                                 ; jsr $0306B8(pc)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    dc.w    $6700,$02D4                                         ; beq $0302BA
    pea     ($001C).w
    pea     ($00FF).w
    move.l  a5, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    clr.w   d4
    clr.w   d6



