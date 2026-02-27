; ============================================================================
; LoadScenarioState -- Orchestrate scenario setup: run selection, model stats, portfolio, player select, aircraft stats, and purchase screens
; 594 bytes | $00A2D4-$00A525
; ============================================================================
LoadScenarioState:
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$0004C974,a2
    movea.l  #$00000D64,a3
    movea.l  #$00FF1804,a4
    movea.l  #$00005092,a5
    clr.w   d2
    pea     ($0001).w
    jsr CmdSetBackground
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.l  a2, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  a2, d0
    addi.l  #$722, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    pea     ($0104).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    pea     ($000D).w
    jsr     (a3)
    pea     ($000C).w
    jsr     (a3)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a5)
    lea     $30(a7), a7
    jsr ResourceUnload
.l0a37a:
    cmpi.w  #$1, d2
    bne.w   .l0a408
    jsr ResourceLoad
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0001).w
    jsr CmdSetBackground
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a2, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    move.l  a2, d0
    addi.l  #$722, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    pea     ($0104).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    jsr ResourceUnload
    clr.w   d2
.l0a408:
    jsr (HandleScenarioTurns,PC)
    nop
    tst.w   d0
    bne.b   .l0a418
    clr.w   d2
    bra.w   .l0a51e
.l0a418:
    jsr (BuildAircraftAttrTable,PC)
    nop
    move.w  ($00FF0002).l, d0
    mulu.w  #$3c, d0
    addq.w  #$1, d0
    move.w  d0, ($00FF0006).l
    jsr (UpdateEventSchedule,PC)
    nop
    jsr (DisplayModelStats,PC)
    nop
    tst.w   d0
    beq.w   .l0a37a
    jsr (RunPortfolioManagement,PC)
    nop
    tst.w   d0
    beq.w   .l0a37a
    jsr (ProcessPlayerSelectInput,PC)
    nop
    tst.w   d0
    bne.b   .l0a45e
.l0a458:
    moveq   #$1,d2
    bra.w   .l0a37a
.l0a45e:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0001).w
    jsr CmdSetBackground
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a2, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    move.l  a2, d0
    addi.l  #$722, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    pea     ($0104).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    jsr (RunAircraftStatsDisplay,PC)
    nop
    move.w  d0, d2
    cmpi.w  #$1, d0
    bne.w   .l0a458
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d3
    addq.w  #$1, d0
    move.w  d0, ($00FF0006).l
    move.w  d3, d0
    addi.w  #$50, d0
    move.w  d0, ($00FFA6B2).l
    jsr (RunAircraftPurchase,PC)
    nop
    jsr CalcPlayerRankings
    jsr (RunAircraftParamShuffle,PC)
    nop
.l0a51e:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2-a5
    rts
