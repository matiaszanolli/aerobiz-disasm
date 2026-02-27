; ============================================================================
; ReadCharInput -- Handles character salary-quantity input: sets up a dual-column tile display with salary and count tables, shows remaining budget and current total, runs HandleCharInteraction animations, and loops processing up/down input to adjust the quantity until the player confirms or cancels
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
    jsr (HandleCharInteraction,PC)
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
    jsr (HandleCharInteraction,PC)
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
    jsr (HandleCharInteraction,PC)
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
