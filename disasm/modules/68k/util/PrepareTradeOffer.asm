; ============================================================================
; PrepareTradeOffer -- Iterate a player's route slots, compute per-slot revenue via CalcCharProfit, and accumulate totals into the player record financial fields.
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
    jsr (CalcCharProfit,PC)
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
