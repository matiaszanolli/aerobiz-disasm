; ============================================================================
; OrchestrateGraphicsPipeline -- Render a comparative chart of character statistics across multiple rows for the planning screen, showing char name, city relation delta, availability count, and aircraft count.
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
