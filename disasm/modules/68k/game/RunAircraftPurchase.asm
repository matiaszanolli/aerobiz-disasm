; ============================================================================
; RunAircraftPurchase -- Initialize all players financial state: starting cash, accumulators, char stat tables, routes; call aircraft sort and cost routines
; 518 bytes | $00BA7E-$00BC83
; ============================================================================
RunAircraftPurchase:
    movem.l d2-d6/a2-a5, -(a7)
    movea.l  #$00FF0120,a4
    movea.l  #$00FF0018,a2
    movea.l  #$00FF03F0,a5
    jsr CountActivePlayers
    move.w  d0, d5
    move.l  #$5f5e0ff, d4
    clr.w   d3
.l0baa4:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.b  #$1, $2(a2)
    clr.b   $3(a2)
    clr.b   $4(a2)
    clr.b   $5(a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    addi.l  #$64, d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    addi.l  #$32, d1
    jsr Multiply32
    move.w  ($00FF0002).l, d1
    ext.l   d1
    addi.l  #$a, d1
    jsr Multiply32
    move.w  ($00FF0004).l, d1
    ext.l   d1
    moveq   #$A,d6
    sub.l   d1, d6
    move.l  d6, d1
    jsr Multiply32
    move.l  #$2710, d1
    jsr SignedDiv
    move.l  #$3e8, d1
    jsr Multiply32
    move.l  d0, $6(a2)
    cmpi.w  #$4, ($00FF0004).l
    bne.b   .l0bb64
    tst.w   d5
    beq.b   .l0bb64
    cmpi.b  #$1, (a2)
    bne.b   .l0bb52
    cmp.l   $6(a2), d4
    bge.b   .l0bb4a
    move.l  d4, d0
    bra.b   .l0bb4e
.l0bb4a:
    move.l  $6(a2), d0
.l0bb4e:
    move.l  d0, d4
    bra.b   .l0bb64
.l0bb52:
    cmp.l   $6(a2), d4
    ble.b   .l0bb5c
    move.l  d4, d0
    bra.b   .l0bb60
.l0bb5c:
    move.l  $6(a2), d0
.l0bb60:
    move.l  d0, $6(a2)
.l0bb64:
    clr.l   $a(a2)
    clr.l   $e(a2)
    clr.l   $12(a2)
    clr.l   $16(a2)
    clr.l   $1a(a2)
    clr.l   $1e(a2)
    move.b  #$64, $22(a2)
    moveq   #$24,d0
    adda.l  d0, a2
    move.b  $3(a3), $1(a4)
    move.b  $2(a3), $2(a4)
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   .l0bb9c
    addq.l  #$1, d0
.l0bb9c:
    asr.l   #$1, d0
    moveq   #$64,d1
    cmp.l   d0, d1
    ble.b   .l0bbb2
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   .l0bbae
    addq.l  #$1, d0
.l0bbae:
    asr.l   #$1, d0
    bra.b   .l0bbb4
.l0bbb2:
    moveq   #$64,d0
.l0bbb4:
    move.b  d0, $3(a4)
    moveq   #$0,d2
    move.b  $1(a4), d2
    mulu.w  ($00FF999C).l, d2
    moveq   #$0,d0
    move.b  $2(a4), d0
    mulu.w  ($00FFBA68).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.b  $3(a4), d0
    mulu.w  ($00FF1288).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    move.b  d2, (a4)
    addq.l  #$4, a4
    clr.b   $9(a5)
    clr.b   $a(a5)
    clr.b   $b(a5)
    moveq   #$C,d0
    adda.l  d0, a5
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ComputeAircraftSpeedDisp,PC)
    nop
    addq.l  #$4, a7
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   .l0baa4
    jsr (SortAircraftByMetric,PC)
    nop
    jsr (ComputeMonthlyAircraftCosts,PC)
    nop
    movea.l  #$00FF0018,a2
    clr.w   d3
.l0bc2e:
    movea.l  #$00FF1298,a3
    clr.w   d2
.l0bc36:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    move.w  d3, d1
    mulu.w  #$39, d1
    moveq   #$0,d6
    move.b  (a3), d6
    add.w   d6, d1
    movea.l  #$00FF05C4,a0
    move.b  d0, (a0,d1.w)
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    blt.b   .l0bc36
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0bc2e
    bsr.w ComputeDividends
    movem.l (a7)+, d2-d6/a2-a5
    rts
