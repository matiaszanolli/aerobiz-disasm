; ============================================================================
; HandleCharListAction -- Sets background, draws event frame via GenerateEventResult and ProcessEventSequence, formats a player-name string, shows a dialog with tile icon, and runs char-list navigation loop
; 516 bytes | $017906-$017B09
; ============================================================================
HandleCharListAction:
    link    a6,#-$80
    movem.l d2-d4/a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00FF0008,a4
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($008F).w
    pea     ($0008).w
    pea     ($000C).w
    pea     ($0004).w
    pea     ($000A).w
    jsr (GenerateEventResult,PC)
    nop
    jsr (ProcessEventSequence,PC)
    nop
    move.w  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$00047A88,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F960).l
    pea     -$80(a6)
    jsr sprintf
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$80(a6)
    move.w  ($00FFA792).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  (a4), d2
    add.w   d2, d2
    addq.w  #$5, d2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0050).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.l   -(a7)
    jsr ReadInput
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   l_179e4
    moveq   #$1,d3
    bra.b   l_179e6
l_179e4:
    moveq   #$0,d3
l_179e6:
    clr.w   d4
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
l_179f0:
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0001).w
    pea     ($0005).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0050).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    tst.w   d3
    beq.b   l_17a62
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_17a62
l_17a54:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_179f0
l_17a62:
    clr.w   d3
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d4
    andi.w  #$30, d0
    beq.b   l_17ab2
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_17aec
    move.w  d2, d0
    ext.l   d0
    subq.l  #$5, d0
    bge.b   l_17a9a
    addq.l  #$1, d0
l_17a9a:
    asr.l   #$1, d0
    move.w  d0, (a4)
    jsr (ProcessEventSequence,PC)
    nop
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_17aec
l_17ab2:
    move.w  d4, d0
    andi.w  #$1, d0
    beq.b   l_17acc
    move.w  #$1, (a3)
    cmpi.w  #$5, d2
    bne.b   l_17ac8
    moveq   #$9,d2
    bra.b   l_17a54
l_17ac8:
    subq.w  #$2, d2
    bra.b   l_17a54
l_17acc:
    move.w  d4, d0
    andi.w  #$2, d0
    beq.w   l_17a54
    move.w  #$1, (a3)
    cmpi.w  #$9, d2
    bne.b   l_17ae6
    moveq   #$5,d2
    bra.w   l_17a54
l_17ae6:
    addq.w  #$2, d2
    bra.w   l_17a54
l_17aec:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    clr.l   -(a7)
    jsr CmdSetBackground
    movem.l -$98(a6), d2-d4/a2-a4
    unlk    a6
    rts
