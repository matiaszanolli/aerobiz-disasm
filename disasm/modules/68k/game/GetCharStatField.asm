; ============================================================================
; GetCharStatField -- Interactive character stat browser; displays stats across relation slots with arrow-key navigation and page scrolling, returning the selected stat value.
; 710 bytes | $012B3E-$012E03
; ============================================================================
GetCharStatField:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$00000D64,a5
    clr.w   d4
    moveq   #$1,d7
    jsr PreLoopInit
    move.w  d5, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l12b7e
    moveq   #$1,d0
    bra.b   .l12b80
.l12b7e:
    moveq   #$0,d0
.l12b80:
    move.w  d0, -$2(a6)
    clr.w   d6
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    jsr ResourceLoad
    moveq   #$0,d0
    movea.l d0, a4
    clr.w   d2
    clr.w   d3
.l12ba0:
    move.w  d5, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
.l12bb2:
    cmpi.w  #$28, d2
    blt.b   .l12bbc
    movea.l a3, a2
    clr.w   d2
.l12bbc:
    tst.w   d2
    bge.b   .l12bc8
    movea.l a3, a2
    lea     $30c(a2), a2
    moveq   #$27,d2
.l12bc8:
    move.b  $a(a2), d0
    btst    #$7, d0
    bne.b   .l12be8
    cmpi.w  #$1, d4
    bne.b   .l12be0
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    bra.b   .l12bb2
.l12be0:
    moveq   #$14,d0
    suba.l  d0, a2
    subq.w  #$1, d2
    bra.b   .l12bb2
.l12be8:
    cmpa.l  a2, a4
    beq.b   .l12c66
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    pea     ($0001).w
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationDisplay
    lea     $14(a7), a7
    movea.l a2, a4
.l12c66:
    cmpi.w  #$1, d7
    bne.b   .l12c90
    jsr ResourceUnload
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003F268).l
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    clr.w   d7
.l12c90:
    tst.w   -$2(a6)
    beq.b   .l12ca6
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l12ba0
.l12ca6:
    clr.w   -$2(a6)
    cmpi.w  #$2, $e(a6)
    bge.b   .l12cd6
.l12cb2:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$30, d0
    beq.b   .l12cb2
    cmpi.w  #$20, d6
    bne.w   .l12dfa
    bra.w   .l12dfa
.l12cd6:
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   .l12d46
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0078).w
    pea     ($0039).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0078).w
    pea     ($0078).w
    pea     ($003A).w
    pea     ($0771).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l12d38:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l12d66
.l12d46:
    cmpi.w  #$f, d3
    bne.b   .l12d5e
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l12d38
.l12d5e:
    cmpi.w  #$1e, d3
    bne.b   .l12d66
    clr.w   d3
.l12d66:
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d6
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l12d98
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l12daa
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   .l12dba
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   .l12dcc
    bra.b   .l12dde
.l12d98:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$1,d2
.l12da6:
    move.w  d2, d0
    bra.b   .l12dfa
.l12daa:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    bra.b   .l12da6
.l12dba:
    move.w  #$1, ($00FF13FC).l
    clr.w   d4
    moveq   #$14,d0
    suba.l  d0, a2
    subq.w  #$1, d2
    bra.b   .l12dea
.l12dcc:
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d4
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    bra.b   .l12dea
.l12dde:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l12dea:
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l12ba0
.l12dfa:
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
