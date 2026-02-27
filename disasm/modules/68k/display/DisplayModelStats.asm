; ============================================================================
; DisplayModelStats -- Show aircraft model names and numbers in a table, handle scrolling selection of aircraft type
; 556 bytes | $00AD02-$00AF2D
; ============================================================================
DisplayModelStats:
    movem.l d2-d5/a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    movea.l  #$00FF13FC,a4
    clr.l   -(a7)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($000C).w
    pea     ($0017).w
    pea     ($0003).w
    pea     ($0004).w
    jsr DrawBox
    lea     $2c(a7), a7
    moveq   #$7,d4
    moveq   #$4,d3
    clr.w   d2
.l0ad52:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047670,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E5C8).l
    jsr PrintfNarrow
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0012).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5BE).l
    jsr PrintfWide
    lea     $20(a7), a7
    addq.w  #$2, d3
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   .l0ad52
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000475E4).l, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0add8
    moveq   #$1,d4
    bra.b   .l0adda
.l0add8:
    moveq   #$0,d4
.l0adda:
    clr.w   d5
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    clr.w   d2
.l0ade6:
    move.w  d2, d3
    add.w   d3, d3
    addq.w  #$4, d3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0030).w
    pea     ($0002).w
    pea     ($0544).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    tst.w   d4
    beq.b   .l0ae3a
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0ae3a
    pea     ($0002).w
.l0ae30:
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   .l0ade6
.l0ae3a:
    clr.w   d4
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$30, d0
    beq.b   .l0aecc
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    andi.w  #$20, d0
    beq.w   .l0af14
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, d3
    move.l  d0, -(a7)
    pea     ($0030).w
    pea     ($0002).w
    pea     ($0546).w
    jsr     (a3)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d3, -(a7)
    pea     ($0030).w
    pea     ($0002).w
    pea     ($0548).w
    jsr     (a3)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.w  d2, ($00FF0004).l
    moveq   #$1,d2
    bra.b   .l0af16
.l0aecc:
    move.w  d5, d0
    andi.w  #$3, d0
    beq.b   .l0af0c
    move.w  #$1, (a4)
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0aef4
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0aef0
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0af0a
.l0aef0:
    moveq   #$0,d0
    bra.b   .l0af0a
.l0aef4:
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   .l0af08
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0af0a
.l0af08:
    moveq   #$4,d0
.l0af0a:
    move.w  d0, d2
.l0af0c:
    pea     ($0005).w
    bra.w   .l0ae30
.l0af14:
    clr.w   d2
.l0af16:
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16
    addq.l  #$8, a7
    move.w  d2, d0
    movem.l (a7)+, d2-d5/a2-a4
    rts
