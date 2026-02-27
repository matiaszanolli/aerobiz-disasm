; ============================================================================
; ManageTurnDisplay -- Iterates pending turn-display events per player (state=5), loads city/char resource, draws facility-level summary box with turn counter dialog, clears the event slot when done
; 640 bytes | $02ADEC-$02B06B
; ============================================================================
ManageTurnDisplay:
    link    a6,#-$80
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d6
.l2ae1c:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmpi.w  #$5, d0
    bne.w   .l2b056
    subq.b  #$1, $3(a2)
    tst.b   $3(a2)
    bne.w   .l2b056
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d2
    move.b  $2(a2), d2
    cmpi.w  #$20, d3
    bcc.b   .l2ae6c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d7
    add.w   d2, d0
    movea.l  #$00FF0420,a0
    move.b  d5, (a0,d0.w)
    move.w  d7, d0
    add.w   d2, d0
    movea.l  #$00FF1704,a0
    bra.b   .l2ae88
.l2ae6c:
    move.w  d3, d0
    lsl.w   #$2, d0
    add.w   d2, d0
    movea.l  #$00FF0460,a0
    move.b  d5, (a0,d0.w)
    move.w  d3, d0
    lsl.w   #$2, d0
    add.w   d2, d0
    movea.l  #$00FF15A0,a0
.l2ae88:
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    cmpi.b  #$1, (a3)
    bne.w   .l2b044
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmp.w   ($00FF9A1C).l, d0
    beq.b   .l2aef4
    jsr ResourceLoad
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $c(a7), a7
    jsr ResourceUnload
.l2aef4:
    cmpi.w  #$3, d2
    bcc.b   .l2aefe
.l2aefa:
    clr.w   d4
    bra.b   .l2af24
.l2aefe:
    cmpi.w  #$6, d2
    bcc.b   .l2af08
    moveq   #$1,d4
    bra.b   .l2af24
.l2af08:
    cmpi.w  #$a, d2
    bcs.b   .l2aefa
    cmpi.w  #$d, d2
    bcc.b   .l2af18
    moveq   #$2,d4
    bra.b   .l2af24
.l2af18:
    cmpi.w  #$d, d2
    bne.b   .l2af22
    moveq   #$3,d4
    bra.b   .l2af24
.l2af22:
    moveq   #$4,d4
.l2af24:
    clr.l   -(a7)
    pea     ($000E).w
    jsr MenuSelectEntry
    pea     ($0009).w
    pea     ($000C).w
    pea     ($0007).w
    pea     ($000A).w
    jsr DrawBox
    pea     ($000424C9).l
    jsr PrintfNarrow
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ShowFacilityMenu,PC)
    nop
    lea     $20(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    tst.w   d2
    beq.b   .l2af88
    cmpi.w  #$7, d2
    bne.b   .l2af90
.l2af88:
    pea     ($000424AE).l
    bra.b   .l2af96
.l2af90:
    pea     ($000424AC).l
.l2af96:
    pea     ($000424B2).l
    pea     -$80(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $2c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$000483CC,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0009).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($000C).w
    pea     ($0007).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0007).w
    jsr SelectMenuItem
    lea     $20(a7), a7
.l2b044:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
.l2b056:
    addq.l  #$8, a2
    addq.w  #$1, d6
    cmpi.w  #$4, d6
    bcs.w   .l2ae1c
    movem.l -$a0(a6), d2-d7/a2-a3
    unlk    a6
    rts
