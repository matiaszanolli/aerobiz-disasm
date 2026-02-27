; ============================================================================
; InitGameDatabase -- Show new game setup screen, let player choose player count (1 or 2), return selection
; 382 bytes | $00A156-$00A2D3
; ============================================================================
InitGameDatabase:
    link    a6,#-$24
    movem.l d2-d4/a2-a4, -(a7)
    lea     -$24(a6), a3
    movea.l  #$00048F60,a4
    jsr PreLoopInit
    move.w  #$56b5, -$4(a6)
    move.w  #$6f7b, -$2(a6)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    pea     ($0010).w
    pea     ($0030).w
    move.l  a4, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.l  a4, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    pea     ($0018).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    move.l  a4, d0
    addi.l  #$142, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($004A).w
    pea     ($0301).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    jsr ResourceUnload
    clr.w   d2
    moveq   #$1,d4
    movea.l a3, a2
    moveq   #$12,d0
    adda.l  d0, a2
.l0a234:
    cmp.w   d4, d2
    beq.b   .l0a266
    move.w  #$40, (a2)
    move.w  #$40, $14(a3)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$60, $12(a3, a0.l)
    pea     ($0002).w
    pea     ($0039).w
    move.l  a2, -(a7)
    jsr DisplaySetup
    lea     $c(a7), a7
    move.w  d2, d4
.l0a266:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d3
    andi.l  #$33, d0
    beq.b   .l0a266
    move.w  d3, d0
    andi.w  #$30, d0
    beq.b   .l0a292
    move.w  d3, d0
    andi.w  #$20, d0
    beq.b   .l0a234
    bra.b   .l0a2bc
.l0a292:
    move.w  d3, d0
    andi.w  #$1, d0
    beq.b   .l0a2a6
    cmpi.w  #$1, d2
    bne.b   .l0a234
    moveq   #$1,d4
    clr.w   d2
    bra.b   .l0a234
.l0a2a6:
    move.w  d3, d0
    andi.w  #$2, d0
    beq.b   .l0a234
    tst.w   d2
    bne.w   .l0a234
    clr.w   d4
    moveq   #$1,d2
    bra.w   .l0a234
.l0a2bc:
    jsr ResourceLoad
    jsr PreLoopInit
    move.w  d2, d0
    movem.l -$3c(a6), d2-d4/a2-a4
    unlk    a6
    rts
