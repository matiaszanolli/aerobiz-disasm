; ============================================================================
; AddCharToTeam -- Adds a character to a player's team: shows the character profile panel and hire dialog with age/salary info, runs an input loop (up/down to browse slots, A to confirm, B to cancel), shows cost/rejection dialogs, and returns the assigned slot index
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
    jsr (RefreshCharPanel,PC)
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
    jsr (CalcCharScore,PC)
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
