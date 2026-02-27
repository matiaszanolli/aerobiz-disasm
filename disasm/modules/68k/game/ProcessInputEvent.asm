; ============================================================================
; ProcessInputEvent -- Main event processing loop for one game turn: initialises route and input buffers, checks which players have active routes, calls MapInputToAction for the current city, iterates all 4 player/city combinations accumulating route scores, then for each of 7 city slots calls UpdateAnimation/PositionUIControl/ValidateInputState and FadeGraphics.
; 794 bytes | $01EC40-$01EF59
; ============================================================================
ProcessInputEvent:
    link    a6,#-$4
    movem.l d2-d6/a2-a5, -(a7)
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF01B0).l
    jsr MemFillByte
    pea     ($0070).w
    clr.l   -(a7)
    pea     ($00FF1004).l
    jsr MemFillByte
    lea     $18(a7), a7
    clr.w   d3
    movea.l  #$00FF0018,a5
    clr.w   d2
l_1ec7a:
    tst.b   $4(a5)
    beq.b   l_1ec84
    moveq   #$1,d3
    bra.b   l_1ec90
l_1ec84:
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ec7a
l_1ec90:
    moveq   #$1,d6
    cmpi.w  #$1, d3
    bne.w   l_1edde
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    jsr (MapInputToAction,PC)
    nop
    addq.l  #$8, a7
    moveq   #$1,d6
    movea.l  #$00FF0018,a5
    clr.w   d2
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1ecc8:
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.b   l_1ed54
l_1ecf0:
    tst.w   $4(a2)
    bne.b   l_1ed16
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (RenderAnimFrame,PC)
    nop
    pea     ($0007).w
    jsr (UpdateAnimation,PC)
    nop
    lea     $c(a7), a7
l_1ed16:
    moveq   #$0,d0
    move.w  $8(a3), d0
    bge.b   l_1ed22
    moveq   #$7F,d1
    add.l   d1, d0
l_1ed22:
    asr.l   #$7, d0
    moveq   #$0,d1
    move.w  (a2), d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    moveq   #$0,d0
    move.w  $8(a3), d0
    bge.b   l_1ed3c
    moveq   #$7F,d1
    add.l   d1, d0
l_1ed3c:
    asr.l   #$7, d0
    moveq   #$0,d1
    move.w  $2(a2), d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    moveq   #$14,d0
    adda.l  d0, a3
    addq.l  #$8, a2
    addq.w  #$1, d3
l_1ed54:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  $4(a5), d1
    cmp.l   d1, d0
    blt.b   l_1ecf0
    clr.w   d4
    move.w  ($00FF0002).l, d3
l_1ed6a:
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    moveq   #$0,d1
    move.w  d4, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.b   l_1ed6a
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d3
    move.w  ($00FF0002).l, d0
    ext.l   d0
    bge.b   l_1eda6
    addq.l  #$1, d0
l_1eda6:
    asr.l   #$1, d0
    addq.l  #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    moveq   #$24,d0
    adda.l  d0, a5
    moveq   #$1C,d0
    adda.l  d0, a4
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1ecc8
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_1edde
    pea     ($003C).w
    jsr PollInputChange
    addq.l  #$4, a7
l_1edde:
    movea.l  #$0005ECBC,a3
    clr.w   d4
l_1ede6:
    clr.w   d3
    clr.w   d2
l_1edea:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d5
    bcc.b   l_1ee26
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_1ee26
    moveq   #$1,d3
    bra.b   l_1ee2e
l_1ee26:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1edea
l_1ee2e:
    cmpi.w  #$1, d3
    bne.w   l_1ef2e
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (MapInputToAction,PC)
    nop
    addq.l  #$8, a7
    moveq   #$1,d6
    moveq   #$0,d3
    move.b  $2(a3), d3
    bra.b   l_1ee98
l_1ee54:
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_1ee66:
    tst.b   $1(a2)
    bne.b   l_1ee76
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ee66
l_1ee76:
    cmpi.w  #$4, d2
    bcc.b   l_1ee96
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (PositionUIControl,PC)
    nop
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    addq.l  #$8, a7
l_1ee96:
    addq.w  #$1, d3
l_1ee98:
    moveq   #$0,d0
    move.b  $2(a3), d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_1ee54
    moveq   #$0,d3
    move.b  (a3), d3
    bra.b   l_1ef1a
l_1eeb4:
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_1eec6:
    tst.b   $1(a2)
    bne.b   l_1eed6
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1eec6
l_1eed6:
    cmpi.w  #$4, d2
    bcc.b   l_1ef18
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ValidateInputState,PC)
    nop
    cmpi.w  #$1, d0
    bne.b   l_1eefc
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FadeGraphics,PC)
    nop
    bra.b   l_1ef08
l_1eefc:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (PositionUIControl,PC)
    nop
l_1ef08:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    lea     $c(a7), a7
l_1ef18:
    addq.w  #$1, d3
l_1ef1a:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_1eeb4
l_1ef2e:
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_1ef44
    pea     ($003C).w
    jsr PollInputChange
    addq.l  #$4, a7
l_1ef44:
    addq.l  #$4, a3
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.w   l_1ede6
    movem.l -$28(a6), d2-d6/a2-a5
    unlk    a6
    rts
