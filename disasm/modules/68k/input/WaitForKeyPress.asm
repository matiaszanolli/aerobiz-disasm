; ============================================================================
; WaitForKeyPress -- Loop selecting random aircraft/city indices until finding one valid for player count and region constraints
; 276 bytes | $00B1E6-$00B2F9
; ============================================================================
WaitForKeyPress:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d5
    movea.l  #$00FF0002,a3
.l0b1f4:
    cmpi.w  #$3, ($00FF0004).l
    ble.b   .l0b212
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (GetPlayerModelSelect,PC)
    nop
    addq.l  #$4, a7
    move.w  d0, d2
    bra.w   .l0b29a
.l0b212:
    pea     ($001F).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$2, d2
    beq.b   .l0b1f4
    cmpi.w  #$3, d2
    beq.b   .l0b1f4
    cmpi.w  #$7, d2
    bne.b   .l0b238
    tst.w   (a3)
    beq.b   .l0b1f4
.l0b238:
    cmpi.w  #$8, d2
    beq.b   .l0b1f4
    cmpi.w  #$b, d2
    bne.b   .l0b248
    tst.w   (a3)
    beq.b   .l0b1f4
.l0b248:
    cmpi.w  #$9, d2
    bne.b   .l0b254
    cmpi.w  #$1, (a3)
    beq.b   .l0b1f4
.l0b254:
    cmpi.w  #$a, d2
    bne.b   .l0b260
    cmpi.w  #$1, (a3)
    beq.b   .l0b1f4
.l0b260:
    cmpi.w  #$a, d2
    bne.b   .l0b26c
    cmpi.w  #$2, (a3)
    beq.b   .l0b1f4
.l0b26c:
    cmpi.w  #$12, d2
    beq.b   .l0b1f4
    cmpi.w  #$14, d2
    beq.w   .l0b1f4
    cmpi.w  #$15, d2
    beq.w   .l0b1f4
    cmpi.w  #$16, d2
    beq.w   .l0b1f4
    cmpi.w  #$1b, d2
    beq.w   .l0b1f4
    cmpi.w  #$1f, d2
    beq.w   .l0b1f4
.l0b29a:
    moveq   #$1,d4
    movea.l  #$00FF0018,a2
    clr.w   d3
    bra.b   .l0b2e6
.l0b2a6:
    tst.b   (a2)
    bne.b   .l0b2d6
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  (a7)+, d1
    cmp.w   d1, d0
.l0b2d0:
    bne.b   .l0b2e0
    clr.w   d4
    bra.b   .l0b2ea
.l0b2d6:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d2, d0
    bra.b   .l0b2d0
.l0b2e0:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d3
.l0b2e6:
    cmp.w   d5, d3
    bcs.b   .l0b2a6
.l0b2ea:
    cmpi.w  #$1, d4
    bne.w   .l0b1f4
    move.w  d2, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts
