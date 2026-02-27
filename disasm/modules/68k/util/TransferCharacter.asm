; ============================================================================
; TransferCharacter -- Runs the character hire/transfer negotiation UI: shows the transfer screen with stat comparison, loops reading input (A to negotiate, B to cancel, up/down to scroll), checks salary cap and age limit conditions, shows result dialogs, and returns the hired slot index or $FF on cancel
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
    jsr (RenderCharTransfer,PC)
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
    jsr (ShowCharInfoPageS2,PC)
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
    jsr (RenderCharTransfer,PC)
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
    jsr (ShowCharInfoPageS2,PC)
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
    jsr (RenderCharTransfer,PC)
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
    jsr (FindCharSlotInGroup,PC)
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
    jsr (ShowCharInfoPageS2,PC)
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
    jsr (ShowCharInfoPageS2,PC)
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
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    bra.w   .l2d566
.l2d7fc:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (DrawCharStatus,PC)
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
    jsr (ShowCharInfoPageS2,PC)
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
