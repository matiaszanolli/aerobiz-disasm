; ============================================================================
; ShowRouteInfoDlg -- Displays a route-info dialog showing pending city-pair relation entries; scans pending slots, formats city names from lookup table, and prints them.
; 706 bytes | $012514-$0127D5
; ============================================================================
ShowRouteInfoDlg:
    link    a6,#-$190
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$0003B22C,a5
    pea     ($0050).w
    clr.l   -(a7)
    pea     -$a0(a6)
    jsr MemFillByte
    jsr ResourceLoad
    jsr PreLoopInit
    move.l  ($00095118).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $14(a7), a7
    move.w  $a(a6), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
    clr.w   d4
    bra.w   .l12606
.l12570:
    cmpi.b  #$ff, (a3)
    beq.w   .l12600
    move.b  $a(a3), d0
    andi.l  #$80, d0
    beq.b   .l12600
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  (a2), d0
    cmp.b   (a4), d0
    bcc.b   .l125c6
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d7
    move.b  $1(a2), d7
    moveq   #$0,d6
    move.b  (a4), d6
    moveq   #$0,d5
    move.b  $1(a4), d5
    bra.b   .l125da
.l125c6:
    moveq   #$0,d6
    move.b  (a2), d6
    moveq   #$0,d5
    move.b  $1(a2), d5
    moveq   #$0,d3
    move.b  (a4), d3
    moveq   #$0,d7
    move.b  $1(a4), d7
.l125da:
    pea     ($00FF1804).l
    pea     ($0001).w
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr DrawTilemapLineWrap
    lea     $18(a7), a7
    addq.w  #$1, d4
.l12600:
    moveq   #$14,d0
    adda.l  d0, a3
    addq.w  #$1, d2
.l12606:
    cmpi.w  #$28, d2
    blt.w   .l12570
    movea.l  #$0005E948,a2
    clr.w   d2
    clr.w   d3
    bra.b   .l12670
.l1261a:
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   $c(a6), d0
    beq.b   .l1266c
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0761).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d3
.l1266c:
    addq.l  #$2, a2
    addq.w  #$1, d2
.l12670:
    cmpi.w  #$20, d2
    blt.b   .l1261a
    pea     ($02C0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    pea     ($00070198).l
    pea     ($0014).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $28(a7), a7
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    jsr DisplaySetup
    lea     $c(a7), a7
    cmpi.w  #$1, d3
    bne.b   .l126dc
    pea     ($0003F238).l
    pea     -$f0(a6)
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l126f2
.l126dc:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004799A).l, -(a7)
    pea     -$f0(a6)
    jsr     (a5)
    lea     $c(a7), a7
.l126f2:
    cmpi.w  #$1, d4
    bne.b   .l12708
    pea     ($0003F230).l
    pea     -$140(a6)
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l1271e
.l12708:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004799E).l, -(a7)
    pea     -$140(a6)
    jsr     (a5)
    lea     $c(a7), a7
.l1271e:
    tst.w   d4
    bne.b   .l12738
    pea     -$f0(a6)
    pea     ($0003F22C).l
.l1272c:
    pea     -$190(a6)
    jsr     (a5)
    lea     $c(a7), a7
    bra.b   .l12760
.l12738:
    tst.w   d3
    bne.b   .l12748
    pea     -$140(a6)
    pea     ($0003F228).l
    bra.b   .l1272c
.l12748:
    pea     -$140(a6)
    pea     -$f0(a6)
    move.l  ($000479A2).l, -(a7)
    pea     -$190(a6)
    jsr     (a5)
    lea     $10(a7), a7
.l12760:
    pea     -$190(a6)
    move.l  ($000479A6).l, -(a7)
    pea     -$a0(a6)
    jsr     (a5)
    jsr ResourceUnload
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$a0(a6)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $20(a7), a7
    tst.w   d4
    ble.b   .l127ae
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (GetCharStatField,PC)
    nop
    addq.l  #$8, a7
.l127ae:
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000479AA).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  d0, d2
    movem.l -$1b8(a6), d2-d7/a2-a5
    unlk    a6
    rts
