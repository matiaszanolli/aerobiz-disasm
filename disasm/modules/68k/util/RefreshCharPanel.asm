; ============================================================================
; RefreshCharPanel -- Redraws the character info summary panel: decompresses and loads the char-panel tile sheet into VRAM, draws the panel frame, sets up a text window, and prints the airline name and financial figure (revenue, profit, or salary total depending on mode)
; 306 bytes | $02F218-$02F349
; ============================================================================
RefreshCharPanel:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    move.l  $20(a7), d3
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    movea.l  #$00FF00A8,a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    pea     ($0004975E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0008).w
    pea     ($0328).w
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    pea     ($00049706).l
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0019).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    pea     ($0019).w
    pea     ($000A).w
    jsr     (a4)
    addq.l  #$8, a7
    cmpi.w  #$2, d3
    bne.b   .l2f2ea
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    jsr     (a3)
    pea     ($0019).w
    pea     ($0013).w
    jsr     (a4)
    lea     $c(a7), a7
    move.l  $6(a2), -(a7)
    pea     ($00044714).l
    bra.b   .l2f340
.l2f2ea:
    cmpi.w  #$3, d3
    bne.b   .l2f316
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    jsr     (a3)
    pea     ($0019).w
    pea     ($0013).w
    jsr     (a4)
    lea     $c(a7), a7
    move.l  $6(a2), -(a7)
    pea     ($0004470E).l
    bra.b   .l2f340
.l2f316:
    cmpi.w  #$4, d3
    bne.b   .l2f344
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    pea     (a5, d0.l)
    jsr     (a3)
    pea     ($0019).w
    pea     ($0013).w
    jsr     (a4)
    lea     $c(a7), a7
    move.l  $6(a2), -(a7)
    pea     ($00044708).l
.l2f340:
    jsr     (a3)
    addq.l  #$8, a7
.l2f344:
    movem.l (a7)+, d2-d3/a2-a5
    rts
