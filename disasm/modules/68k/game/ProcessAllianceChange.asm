; ============================================================================
; ProcessAllianceChange -- Handles player joining/leaving alliance: shows text, scans for matching chars, presents yes/no dialog
; 536 bytes | $0307FC-$030A13
; ============================================================================
ProcessAllianceChange:
    link    a6,#-$F0
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    movea.l  #$000101CA,a3
    lea     -$a0(a6), a4
    movea.l  #$00047B94,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (IsAllianceSlotValid,PC)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    beq.w   .l30a0a
    moveq   #$0,d5
    move.b  $4(a2), d5
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d5
    tst.w   d2
    ble.w   .l309c8
    cmpi.w  #$1, d2
    bne.b   .l30864
    pea     ($000447BC).l
    bra.b   .l3086a
.l30864:
    pea     ($000447B4).l
.l3086a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047B94).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $20(a7), a7
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    clr.w   d2
    bra.b   .l30904
.l308a8:
    moveq   #$0,d6
    move.w  $e(a2), d6
    moveq   #$0,d0
    move.w  $6(a2), d0
    sub.l   d0, d6
    tst.l   d6
    bge.b   .l308f0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (GetAllianceScore,PC)
    nop
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (RunAIMainLoop,PC)
    nop
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    cmpi.w  #$10, d0
    bne.b   .l308fe
    bra.w   .l30a04
.l308f0:
    move.w  d4, d0
    add.w   d0, d0
    lea     -$f0(a6), a0
    move.w  d2, (a0,d0.w)
    addq.w  #$1, d4
.l308fe:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l30904:
    cmp.w   d5, d2
    blt.b   .l308a8
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    addq.l  #$4, a7
    tst.w   d4
    ble.b   .l3098c
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    move.l  $14(a5), -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.w   .l30a0a
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$f0(a6), a0
    lea     (a0,d0.w), a1
    movea.l a1, a2
    bra.b   .l30986
.l3094e:
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (GetAllianceScore,PC)
    nop
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (RunAIMainLoop,PC)
    nop
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    cmpi.w  #$10, d0
    beq.w   .l30a04
    addq.l  #$2, a2
    addq.w  #$1, d2
.l30986:
    cmp.w   d4, d2
    blt.b   .l3094e
    bra.b   .l30a04
.l3098c:
    pea     ($000447A4).l
    move.l  $4(a5), -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a4, -(a7)
    pea     ($0004).w
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    clr.l   -(a7)
    move.l  $10(a5), -(a7)
    pea     ($0004).w
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $2c(a7), a7
    bra.b   .l30a0a
.l309c8:
    clr.w   d2
    bra.b   .l30a00
.l309cc:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (GetAllianceScore,PC)
    nop
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (RunAIMainLoop,PC)
    nop
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    cmpi.w  #$10, d0
    beq.b   .l30a04
    addq.w  #$1, d2
.l30a00:
    cmp.w   d5, d2
    blt.b   .l309cc
.l30a04:
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
.l30a0a:
    movem.l -$114(a6), d2-d6/a2-a5
    unlk    a6
    rts
