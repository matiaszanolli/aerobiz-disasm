; ============================================================================
; DrawQuarterResultsScreen -- Renders the full quarterly results screen with decompressed tile backgrounds, per-player score panels, route-flag icon strips, and divider markers for all four players.
; 1196 bytes | $026CD8-$027183
; ============================================================================
DrawQuarterResultsScreen:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF14B0,a5
    pea     ($0004E382).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0007).w
    pea     ($0308).w
    jsr VRAMBulkLoad
    pea     ($00FF1804).l
    pea     ($0007).w
    pea     ($0001).w
    pea     ($0640).w
    jsr DrawTileGrid
    lea     $2c(a7), a7
    movea.l  #$00FF0018,a2
    moveq   #$3F,d6
    clr.w   d7
    movea.l  #$0004E378,a4
    movea.l  #$0004E37A,a3
l_26d42:
    cmpi.w  #$1, $a(a6)
    bne.b   l_26d82
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d0
    andi.l  #$ffff, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    pea     ($00041584).l
    jsr PrintfWide
    lea     $c(a7), a7
l_26d82:
    moveq   #$50,d2
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d4
    mulu.w  #$30, d4
    addi.w  #$40, d4
    pea     ($0004E380).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26dae
    addq.l  #$7, d0
l_26dae:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26dba
    addq.l  #$7, d0
l_26dba:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    addq.w  #$4, d2
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (CountRouteFlags,PC)
    nop
    lea     $20(a7), a7
    move.w  d0, d5
    beq.w   l_26ec0
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0644).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    addq.w  #$4, d2
    clr.w   d3
    bra.b   l_26e60
l_26e26:
    pea     ($0004E37E).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26e3c
    addq.l  #$7, d0
l_26e3c:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26e48
    addq.l  #$7, d0
l_26e48:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_26e60:
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    bge.b   l_26e6a
    addq.l  #$1, d0
l_26e6a:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_26e26
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    moveq   #$2,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_26ec0
    pea     ($0004E37C).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26e9e
    addq.l  #$7, d0
l_26e9e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26eaa
    addq.l  #$7, d0
l_26eaa:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$4, d2
l_26ec0:
    moveq   #$0,d0
    move.b  $2(a2), d0
    sub.w   d5, d0
    addi.w  #$ffff, d0
    move.w  d0, d5
    tst.w   d5
    beq.b   l_26f36
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    jsr SignedMod
    tst.l   d0
    bne.b   l_26f36
    clr.w   d3
    bra.b   l_26f1c
l_26ee6:
    move.l  a3, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26ef8
    addq.l  #$7, d0
l_26ef8:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26f04
    addq.l  #$7, d0
l_26f04:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_26f1c:
    moveq   #$0,d0
    move.w  d5, d0
    bge.b   l_26f24
    addq.l  #$1, d0
l_26f24:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_26ee6
    moveq   #$0,d0
    move.w  d5, d0
    bra.w   l_26fd0
l_26f36:
    tst.w   d5
    beq.w   l_27012
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0642).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    addq.w  #$4, d2
    clr.w   d3
    bra.b   l_26fb6
l_26f80:
    move.l  a3, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26f92
    addq.l  #$7, d0
l_26f92:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26f9e
    addq.l  #$7, d0
l_26f9e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_26fb6:
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    bge.b   l_26fc0
    addq.l  #$1, d0
l_26fc0:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_26f80
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
l_26fd0:
    moveq   #$2,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_27012
    move.l  a4, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26ff0
    addq.l  #$7, d0
l_26ff0:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26ffc
    addq.l  #$7, d0
l_26ffc:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$4, d2
l_27012:
    tst.b   $3(a2)
    beq.b   l_27084
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    jsr SignedMod
    tst.l   d0
    bne.b   l_27084
    clr.w   d3
    bra.b   l_27066
l_2702c:
    pea     ($0004E376).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_27042
    addq.l  #$7, d0
l_27042:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_2704e
    addq.l  #$7, d0
l_2704e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_27066:
    moveq   #$0,d0
    move.b  $3(a2), d0
    bge.b   l_27070
    addq.l  #$1, d0
l_27070:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_2702c
    moveq   #$0,d0
    move.b  $3(a2), d0
    bra.w   l_27128
l_27084:
    tst.b   $3(a2)
    beq.w   l_2716c
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0640).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    addq.w  #$4, d2
    clr.w   d3
    bra.b   l_2710a
l_270d0:
    pea     ($0004E376).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_270e6
    addq.l  #$7, d0
l_270e6:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_270f2
    addq.l  #$7, d0
l_270f2:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_2710a:
    moveq   #$0,d0
    move.b  $3(a2), d0
    subq.l  #$1, d0
    bge.b   l_27116
    addq.l  #$1, d0
l_27116:
    asr.l   #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_270d0
    moveq   #$0,d0
    move.b  $3(a2), d0
    subq.l  #$1, d0
l_27128:
    moveq   #$2,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_2716c
    pea     ($0004E374).l
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_2714c
    addq.l  #$7, d0
l_2714c:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_27158
    addq.l  #$7, d0
l_27158:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
l_2716c:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d7
    cmpi.w  #$4, d7
    bcs.w   l_26d42
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
