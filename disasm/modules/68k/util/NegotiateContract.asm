; ============================================================================
; NegotiateContract -- Resolves a contract renegotiation: adjusts level/stats if both chars are available, triggers growth/levelup
; 632 bytes | $032A28-$032C9F
; ============================================================================
NegotiateContract:
    link    a6,#$0
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $8(a6), d4
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, d7
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d1
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    lea     $c(a7), a7
    move.w  d0, d3
    move.w  $4(a2), d0
    sub.w   d3, d0
    ext.l   d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d3, d1
    ext.l   d1
    jsr SignedDiv
    move.w  d0, d3
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.w   d3
    ble.w   l_32c94
    moveq   #$0,d3
    move.b  (a4), d3
    moveq   #$0,d0
    move.b  $1(a4), d0
    sub.w   d0, d3
    moveq   #$0,d6
    move.b  (a3), d6
    moveq   #$0,d0
    move.b  $1(a3), d0
    sub.w   d0, d6
    moveq   #$0,d0
    move.b  $b(a2), d0
    andi.l  #$ffff, d0
    moveq   #$5F,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.b  $3(a2), d1
    sub.w   d1, d0
    move.w  d0, d5
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$E,d1
    sub.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    ble.b   l_32b34
    move.w  d5, d0
    ext.l   d0
    bra.b   l_32b40
l_32b34:
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$E,d1
    sub.l   d0, d1
    move.l  d1, d0
l_32b40:
    move.w  d0, d5
    tst.w   d3
    beq.b   l_32bbc
    tst.w   d6
    beq.b   l_32bbc
    tst.w   d5
    ble.b   l_32bbc
    cmp.w   d6, d3
    bcc.b   l_32b58
    moveq   #$0,d2
    move.w  d3, d2
    bra.b   l_32b5c
l_32b58:
    moveq   #$0,d2
    move.w  d6, d2
l_32b5c:
    moveq   #$0,d0
    move.w  d2, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_32b6e
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_32b72
l_32b6e:
    move.w  d5, d0
    ext.l   d0
l_32b72:
    move.w  d0, d2
    cmpi.b  #$7, $3(a2)
    bcs.b   l_32b8c
    cmpi.w  #$2, d2
    bcc.b   l_32b88
l_32b82:
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_32bac
l_32b88:
    moveq   #$2,d0
    bra.b   l_32bac
l_32b8c:
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_32b82
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, d0
l_32bac:
    move.w  d0, d2
    add.b   d2, $3(a2)
    add.b   d2, $1(a4)
    add.b   d2, $1(a3)
    moveq   #$1,d2
l_32bbc:
    tst.w   d2
    bne.w   l_32c94
    tst.w   d3
    bne.b   l_32bf6
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ApplyCharGrowth,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_32bf6
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ProcessLevelUp,PC)
    nop
    addq.l  #$8, a7
l_32bf6:
    tst.w   d6
    bne.b   l_32c2e
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ApplyCharGrowth,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_32c2e
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ProcessLevelUp,PC)
    nop
    addq.l  #$8, a7
l_32c2e:
    tst.w   d5
    bgt.b   l_32c94
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    move.w  d0, d3
    cmpi.w  #$9, d0
    bcc.b   l_32c94
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)
    beq.b   l_32c82
    addq.w  #$1, d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    addq.l  #$8, a7
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    subq.b  #$1, (a0,d0.w)
    bra.b   l_32c94
l_32c82:
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (TrainCharSkill,PC)
    nop
l_32c94:
    move.w  d2, d0
    movem.l -$24(a6), d2-d7/a2-a4
    unlk    a6
    rts
