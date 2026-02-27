; ============================================================================
; FormatRouteDetails -- Formats and renders the route details screen; clears display, decompresses background tiles, builds city-pair rows with profit indicators, and calls ShowDialog.
; 872 bytes | $0127D6-$012B3D
; ============================================================================
FormatRouteDetails:
    link    a6,#-$140
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d7
    jsr ResourceLoad
    pea     ($0050).w
    clr.l   -(a7)
    pea     -$50(a6)
    jsr MemFillByte
    jsr ClearBothPlanes
    moveq   #$0,d0
    move.w  d4, d0
    lsl.l   #$2, d0
    movea.l  #$0009511C,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $14(a7), a7
    moveq   #$7,d5
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    moveq   #$0,d0
    move.b  $4(a5), d0
    mulu.w  #$14, d0
    move.w  d7, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d6
    clr.w   d2
    bra.w   .l12942
.l1285c:
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.w   .l1293c
    move.b  $a(a2), d0
    andi.l  #$80, d0
    cmpi.l  #$80, d0
    bne.w   .l1293c
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   .l128c4
    moveq   #$1,d3
    bra.b   .l128c6
.l128c4:
    moveq   #$2,d3
.l128c6:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    jsr DrawRoutePair
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr GetCharRelation
    lea     $c(a7), a7
    move.l  d0, -(a7)
    jsr TilePlacement
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    addq.w  #$1, d5
    addq.w  #$1, d6
.l1293c:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l12942:
    moveq   #$0,d0
    move.b  $5(a5), d0
    cmp.w   d2, d0
    bhi.w   .l1285c
    pea     ($02E0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    jsr DisplaySetup
    lea     $18(a7), a7
    clr.w   d3
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    move.l  (a0,d0.w), d0
    and.l   $10(a6), d0
    move.l  d0, d4
    beq.b   .l129f6
    clr.w   d2
.l12994:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    cmp.l   d4, d0
    beq.b   .l129aa
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    bcs.b   .l12994
.l129aa:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a4), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($0761).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d3
.l129f6:
    pea     ($00070198).l
    pea     ($0017).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    cmpi.w  #$1, d3
    bne.b   .l12a34
    pea     ($0003F258).l
    pea     -$a0(a6)
    jsr sprintf
    addq.l  #$8, a7
    bra.b   .l12a4e
.l12a34:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004799A).l, -(a7)
    pea     -$a0(a6)
    jsr sprintf
    lea     $c(a7), a7
.l12a4e:
    cmpi.w  #$1, d6
    bne.b   .l12a68
    pea     ($0003F250).l
    pea     -$f0(a6)
    jsr sprintf
    addq.l  #$8, a7
    bra.b   .l12a82
.l12a68:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.l  ($0004799E).l, -(a7)
    pea     -$f0(a6)
    jsr sprintf
    lea     $c(a7), a7
.l12a82:
    tst.w   d6
    bne.b   .l12aa0
    pea     -$a0(a6)
    pea     ($0003F24C).l
.l12a90:
    pea     -$140(a6)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   .l12acc
.l12aa0:
    tst.w   d3
    bne.b   .l12ab0
    pea     -$f0(a6)
    pea     ($0003F248).l
    bra.b   .l12a90
.l12ab0:
    pea     -$f0(a6)
    pea     -$a0(a6)
    move.l  ($000479A2).l, -(a7)
    pea     -$140(a6)
    jsr sprintf
    lea     $10(a7), a7
.l12acc:
    pea     -$140(a6)
    move.l  ($000479A6).l, -(a7)
    pea     -$50(a6)
    jsr sprintf
    jsr ResourceUnload
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$50(a6)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $20(a7), a7
    tst.w   d6
    beq.b   .l12b1a
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (GetCharStatField,PC)
    nop
    addq.l  #$8, a7
.l12b1a:
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000479AA).l, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    movem.l -$168(a6), d2-d7/a2-a5
    unlk    a6
    rts
