; ============================================================================
; ComputeMonthlyAircraftCosts -- Compute per-player monthly aircraft operating costs from hub city, aircraft class stats, and scenario multipliers
; 1002 bytes | $00BC84-$00C06D
; ============================================================================
ComputeMonthlyAircraftCosts:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF0018,a5
    clr.w   d7
    clr.w   -$2(a6)
.l0bc98:
    moveq   #$0,d0
    move.b  $1(a5), d0
    add.w   d0, d7
    addq.w  #$1, -$2(a6)
    cmpi.w  #$4, -$2(a6)
    blt.b   .l0bc98
    move.w  d7, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    move.w  d0, d7
    movea.l  #$00FF0018,a5
    clr.w   -$2(a6)
.l0bcc4:
    moveq   #$0,d0
    move.b  $1(a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$4(a6)
    moveq   #$0,d0
    move.b  $1(a5), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a5), d0
    lsl.w   #$3, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)
    moveq   #$0,d0
    move.b  (a2), d0
    bge.b   .l0bd1a
    addq.l  #$1, d0
.l0bd1a:
    asr.l   #$1, d0
    move.l  d0, d4
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.l   d1, d0
    cmp.l   d0, d4
    bge.b   .l0bd3a
    moveq   #$0,d0
    move.b  (a2), d0
    bge.b   .l0bd36
    addq.l  #$1, d0
.l0bd36:
    asr.l   #$1, d0
    bra.b   .l0bd46
.l0bd3a:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.l   d1, d0
.l0bd46:
    move.w  d0, d4
    move.w  ($00FF0004).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d4
    move.w  ($00FF0004).l, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    moveq   #$32,d1
    sub.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    ext.l   d1
    cmp.l   d1, d0
    ble.b   .l0bd94
    move.w  d4, d0
    ext.l   d0
    bra.b   .l0bda8
.l0bd94:
    move.w  ($00FF0004).l, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    moveq   #$32,d1
    sub.l   d0, d1
    move.l  d1, d0
.l0bda8:
    move.w  d0, d4
    add.b   d4, $1(a2)
    movea.l -$a(a6), a0
    move.b  d4, (a0)
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d3
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d6
.l0bdd8:
    addq.w  #$1, d7
    cmpi.w  #$4, d7
    blt.b   .l0bde2
    clr.w   d7
.l0bde2:
    moveq   #$0,d0
    move.b  $2(a4), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $2(a4), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $2(a4), d0
    moveq   #$0,d1
    move.b  $3(a4), d1
    add.w   d1, d0
    move.w  d0, -$6(a6)
    moveq   #$0,d3
    move.b  $2(a4), d3
    bra.w   .l0bf06
.l0be26:
    tst.w   d4
    ble.w   .l0bf0e
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.w   .l0bf00
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)
    clr.w   d5
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmpi.w  #$e, d2
    ble.b   .l0be7e
    moveq   #$E,d2
    bra.b   .l0be8c
.l0be7e:
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ext.l   d2
.l0be8c:
    cmp.w   d2, d4
    bge.b   .l0be94
    move.w  d4, d0
    bra.b   .l0be96
.l0be94:
    move.w  d2, d0
.l0be96:
    ext.l   d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  -$4(a6), d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0bec2
    tst.w   d6
    bne.b   .l0beee
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    bge.b   .l0bebc
    addq.l  #$1, d0
.l0bebc:
    asr.l   #$1, d0
    move.l  d0, -(a7)
    bra.b   .l0bee4
.l0bec2:
    tst.w   d6
    ble.b   .l0beee
    move.w  d3, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0beee
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
.l0bee4:
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d2
.l0beee:
    cmpi.w  #$1, d5
    bne.b   .l0bf00
    add.b   d2, $1(a2)
    movea.l -$a(a6), a0
    move.b  d2, (a0)
    sub.w   d2, d4
.l0bf00:
    addq.l  #$4, a3
    addq.l  #$2, a2
    addq.w  #$1, d3
.l0bf06:
    cmp.w   -$6(a6), d3
    blt.w   .l0be26
.l0bf0e:
    tst.w   d4
    ble.w   .l0c048
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a4), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  (a4), d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    add.w   d1, d0
    move.w  d0, -$6(a6)
    moveq   #$0,d3
    move.b  (a4), d3
    bra.w   .l0c040
.l0bf50:
    tst.w   d4
    ble.w   .l0c048
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a5), d1
    cmp.l   d1, d0
    beq.w   .l0c03a
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.w   .l0c03a
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)
    clr.w   d5
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmpi.w  #$e, d2
    ble.b   .l0bfb8
    moveq   #$E,d2
    bra.b   .l0bfc6
.l0bfb8:
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ext.l   d2
.l0bfc6:
    cmp.w   d2, d4
    bge.b   .l0bfce
    move.w  d4, d0
    bra.b   .l0bfd0
.l0bfce:
    move.w  d2, d0
.l0bfd0:
    ext.l   d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  -$4(a6), d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0bffc
    tst.w   d6
    bne.b   .l0c028
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    bge.b   .l0bff6
    addq.l  #$1, d0
.l0bff6:
    asr.l   #$1, d0
    move.l  d0, -(a7)
    bra.b   .l0c01e
.l0bffc:
    tst.w   d6
    ble.b   .l0c028
    move.w  d3, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0c028
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
.l0c01e:
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d2
.l0c028:
    cmpi.w  #$1, d5
    bne.b   .l0c03a
    add.b   d2, $1(a2)
    movea.l -$a(a6), a0
    move.b  d2, (a0)
    sub.w   d2, d4
.l0c03a:
    addq.l  #$4, a3
    addq.l  #$2, a2
    addq.w  #$1, d3
.l0c040:
    cmp.w   -$6(a6), d3
    blt.w   .l0bf50
.l0c048:
    addq.w  #$1, d6
    cmpi.w  #$5, d6
    blt.w   .l0bdd8
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, -$2(a6)
    cmpi.w  #$4, -$2(a6)
    blt.w   .l0bcc4
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts
