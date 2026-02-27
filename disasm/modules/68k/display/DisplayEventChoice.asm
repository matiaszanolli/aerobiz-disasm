; ============================================================================
; DisplayEventChoice -- Show event dialog with choice tiles, handle scrolling selection input, return chosen option index
; 394 bytes | $00D28C-$00D415
; ============================================================================
DisplayEventChoice:
    link    a6,#-$80
    movem.l d2-d3/a2, -(a7)
    movea.l  #$00000D64,a2
    move.w  $a(a6), d0
    lsl.w   #$2, d0
    movea.l  #$000476F4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E628).l
    pea     -$80(a6)
    jsr sprintf
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($000C).w
    pea     ($0003).w
    jsr SetTextCursor
    pea     ($0003E622).l
    jsr PrintfWide
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$80(a6)
    clr.l   -(a7)
    bsr.w DisplayMessageWithParams
    lea     $14(a7), a7
    clr.w   d3
.l0d300:
    move.w  d3, d2
    add.w   d2, d2
    addq.w  #$3, d2
    cmpi.w  #$4, d3
    bne.b   .l0d30e
    addq.w  #$1, d2
.l0d30e:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
.l0d33e:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d2
    andi.l  #$33, d0
    beq.b   .l0d33e
    move.w  d2, d0
    andi.w  #$20, d0
    beq.b   .l0d390
    cmpi.w  #$4, d3
    bne.b   .l0d3d2
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    moveq   #-$1,d3
    bra.b   .l0d3d2
.l0d390:
    move.w  d2, d0
    andi.w  #$3, d0
    beq.w   .l0d300
    move.w  d2, d0
    andi.w  #$1, d0
    beq.b   .l0d3ba
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0d3b2
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0d3b4
.l0d3b2:
    moveq   #$0,d0
.l0d3b4:
    move.w  d0, d3
    bra.w   .l0d300
.l0d3ba:
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   .l0d3ce
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0d3b4
.l0d3ce:
    moveq   #$4,d0
    bra.b   .l0d3b4
.l0d3d2:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($000C).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0013).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    move.w  d3, d0
    movem.l -$8c(a6), d2-d3/a2
    unlk    a6
    rts
