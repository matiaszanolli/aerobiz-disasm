; ============================================================================
; InitGameGraphicsMode -- Set VDP display mode, configure scroll planes, build tile table, set input_mask, initialize tile buffer
; 234 bytes | $00D416-$00D4FF
; ============================================================================
InitGameGraphicsMode:
    link    a6,#-$60
    movem.l d2/a2, -(a7)
    movea.l  #$00000D64,a2
    clr.w   ($00FFA790).l
    move.l  #$8c81, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollOffset
    pea     ($0033).w
    pea     ($0200).w
    pea     ($00001D88).l
    jsr CmdPlaceTile2
    lea     $28(a7), a7
    clr.w   d2
.l0d470:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0004771C,a0
    move.w  (a0,d0.w), d0
    addi.w  #$200, d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$60(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$30, d2
    bcs.b   .l0d470
    pea     -$60(a6)
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000C).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($000476FC).l
    jsr DisplaySetup
    pea     ($0004).w
    jsr     (a2)
    lea     $2c(a7), a7
    andi.l  #$f, d0
    moveq   #$F,d1
    cmp.l   d0, d1
    bne.b   .l0d4da
    moveq   #$0,d0
    bra.b   .l0d4e0
.l0d4da:
    move.l  #$ffff, d0
.l0d4e0:
    move.w  d0, ($00FFA790).l
    jsr InitTileBuffer
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    movem.l -$68(a6), d2/a2
    unlk    a6
    rts
