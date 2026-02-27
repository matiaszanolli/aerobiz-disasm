; ============================================================================
; ComputeAircraftSpeedDisp -- Fill speed and capacity display values for a player aircraft type into the  scheduling table
; 318 bytes | $00C06E-$00C1AB
; ============================================================================
ComputeAircraftSpeedDisp:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$00FFB9E8,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a3), d0
    movea.l  #$00FF99A4,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    cmpi.w  #$2, d2
    beq.b   .l0c0c2
    cmpi.w  #$3, d2
    bne.b   .l0c0c6
.l0c0c2:
    moveq   #$2,d2
    bra.b   .l0c0dc
.l0c0c6:
    cmpi.w  #$4, d2
    bcs.b   .l0c0dc
    pea     ($0001).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d2
.l0c0dc:
    move.w  ($00FF0002).l, d0
    mulu.w  #$12, d0
    move.w  d2, d1
    mulu.w  #$6, d1
    add.w   d1, d0
    movea.l  #$0005F96E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    move.l  d0, d2
    lea     (a5,d0.l), a0
    moveq   #$0,d1
    move.w  (a4), d1
    add.l   d1, d1
    adda.l  d1, a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    addi.l  #$a, d0
    moveq   #$A,d1
    jsr SignedDiv
    move.b  d0, (a2)
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  ($00FF0002).l, d1
    ext.l   d1
    addq.l  #$3, d1
    cmp.l   d1, d0
    bge.b   .l0c144
    moveq   #$0,d0
    move.b  (a2), d0
    bra.b   .l0c14e
.l0c144:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    addq.l  #$3, d0
.l0c14e:
    move.b  d0, (a2)
    move.b  (a2), $1(a2)
    lea     (a5,d2.l), a0
    moveq   #$0,d0
    move.w  $2(a4), d0
    add.l   d0, d0
    adda.l  d0, a0
    movea.l a0, a2
    move.w  ($00FF0004).l, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    add.b   d0, (a2)
    move.b  (a2), $1(a2)
    lea     (a5,d2.l), a0
    moveq   #$0,d0
    move.w  $4(a4), d0
    add.l   d0, d0
    adda.l  d0, a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$28,d1
    jsr SignedDiv
    add.b   d0, (a2)
    move.b  (a2), $1(a2)
    movem.l (a7)+, d2-d3/a2-a5
    rts
