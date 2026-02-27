; ============================================================================
; DrawCharPanelS2 -- Draws the character stat-adjustment panel: sets up the display and loads panel graphics, calls RenderCharDetails to draw current char slots, then runs an input loop allowing the player to adjust allocated stat points with live tile updates and cost dialogs
; 918 bytes | $02DE6C-$02E201
; ============================================================================
DrawCharPanelS2:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d4
    move.l  $1c(a6), d7
    movea.l $14(a6), a2
    movea.l  #$00000D64,a4
    movea.l  #$0001E044,a5
    move.w  d2, d0
    mulu.w  #$14, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d3
    move.b  $1(a3), d3
    add.w   (a2), d3
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004E3AC).l
    jsr DisplaySetup
    pea     ($0004E498).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0028).w
    pea     ($005B).w
    jsr VRAMBulkLoad
    pea     ($0004E3CC).l
    pea     ($0006).w
    pea     ($0011).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (RenderCharDetails,PC)
    nop
    lea     $c(a7), a7
    moveq   #$0,d2
    move.b  $1(a3), d2
    bra.w   .l2dfe6
.l2df5c:
    addq.w  #$1, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2df84
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2df76
    addq.l  #$1, d0
.l2df76:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addi.w  #$fff8, d4
    bra.b   .l2df96
.l2df84:
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2df8c
    addq.l  #$1, d0
.l2df8c:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addq.w  #$8, d4
.l2df96:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d6
    lsl.w   #$4, d6
    addi.w  #$a8, d6
    subq.w  #$1, d2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    addq.w  #$1, d2
.l2dfe6:
    cmp.w   d3, d2
    bcs.w   .l2df5c
    clr.w   d2
.l2dfee:
    pea     ($0004).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0014).w
    pea     ($001C).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    pea     ($000446BC).l
    jsr PrintfWide
    pea     ($0016).w
    pea     ($0014).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$0,d1
    move.w  (a2), d1
    jsr Multiply32
    move.l  d0, -(a7)
    pea     ($000446B6).l
    jsr PrintfWide
    lea     $30(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$1, d2
    bne.b   .l2e0b8
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0080).w
    pea     ($003A).w
    pea     ($0773).w
    jsr     (a5)
    lea     $1c(a7), a7
.l2e0aa:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l2e0d8
.l2e0b8:
    cmpi.w  #$f, d2
    bne.b   .l2e0d0
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2e0aa
.l2e0d0:
    cmpi.w  #$1e, d2
    bne.b   .l2e0d8
    clr.w   d2
.l2e0d8:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d5
    andi.w  #$20, d0
    bne.w   .l2e1f6
    move.w  d5, d0
    andi.w  #$10, d0
    bne.w   .l2e1f6
    move.w  d5, d0
    andi.w  #$4, d0
    beq.b   .l2e148
    cmpi.w  #$1, (a2)
    bls.w   .l2e1e6
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$A,d1
    sub.l   d0, d1
    addq.l  #$1, d1
    move.l  d1, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    subq.w  #$1, (a2)
    subq.w  #$1, d3
    bra.w   .l2e1e6
.l2e148:
    move.w  d5, d0
    andi.w  #$8, d0
    beq.w   .l2e1e6
    move.w  (a2), d0
    cmp.w   $1a(a6), d0
    bcc.w   .l2e1e6
    addq.w  #$1, (a2)
    addq.w  #$1, d3
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2e186
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   .l2e178
    addq.l  #$1, d0
.l2e178:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addi.w  #$fff8, d4
    bra.b   .l2e198
.l2e186:
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   .l2e18e
    addq.l  #$1, d0
.l2e18e:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addq.w  #$8, d4
.l2e198:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d6
    lsl.w   #$4, d6
    addi.w  #$a8, d6
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$A,d1
    sub.l   d0, d1
    addq.l  #$1, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
.l2e1e6:
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   .l2dfee
.l2e1f6:
    move.w  d5, d0
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
