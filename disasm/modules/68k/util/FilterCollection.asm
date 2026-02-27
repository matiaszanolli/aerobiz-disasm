; ============================================================================
; FilterCollection -- Updates per-player demand/capacity scores for all 4 players and 7 cities: computes each player's aggregate demand score (weighted sum of char-stat bytes multiplied by economy/popularity factors), clamps it to 0-100, stores in the demand table at $FF0230, then distributes route capacity scores (clamped 0-50) per city into adjacent word slots.
; 314 bytes | $01E854-$01E98D
; ============================================================================
FilterCollection:
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0120,a3
    movea.l  #$00FF0230,a5
    clr.w   d5
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF01B0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1e876:
    moveq   #$0,d2
    move.b  $1(a3), d2
    mulu.w  ($00FF999C).l, d2
    moveq   #$0,d0
    move.b  $2(a3), d0
    mulu.w  ($00FFBA68).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.b  $3(a3), d0
    mulu.w  ($00FF1288).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    move.b  d2, (a3)
    move.l  $1c(a4), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    cmpi.l  #$ffff, d4
    bge.b   l_1e8ec
    move.l  $1c(a4), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    bra.b   l_1e8f2
l_1e8ec:
    move.l  #$ffff, d4
l_1e8f2:
    cmpi.w  #$64, d4
    bls.b   l_1e8fe
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_1e900
l_1e8fe:
    moveq   #$64,d0
l_1e900:
    move.w  d0, (a5)
    clr.w   d3
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    lea     (a4,d0.l), a0
    movea.l a0, a2
l_1e910:
    move.l  (a2), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    cmpi.l  #$ffff, d4
    bge.b   l_1e94a
    move.l  (a2), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    bra.b   l_1e950
l_1e94a:
    move.l  #$ffff, d4
l_1e950:
    cmpi.w  #$32, d4
    bls.b   l_1e95c
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_1e95e
l_1e95c:
    moveq   #$32,d0
l_1e95e:
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  d0, $2(a5, a0.l)
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    bcs.b   l_1e910
    addq.l  #$4, a3
    moveq   #$10,d0
    adda.l  d0, a5
    moveq   #$20,d0
    adda.l  d0, a4
    addq.w  #$1, d5
    cmpi.w  #$4, d5
    bcs.w   l_1e876
    movem.l (a7)+, d2-d5/a2-a5
    rts

CalcCityStats:                                                  ; $01E98E
    link    a6,#-$8
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0008(a6),d5
    lea     -$0006(a6),a5
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.w   d5
    moveq   #$0,d6
    moveq   #$0,d0
    move.b  (a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1e9f8
.l1e9d8:                                                ; $01E9D8
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d5
    moveq   #$0,d0
    move.b  $0003(a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   d0,d6
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1e9f8:                                                ; $01E9F8
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    cmp.l   d1,d0
    blt.b   .l1e9d8
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    asr.l   #$1,d0
    move.w  d0,d5
    move.l  d6,d0
    add.l   d0,d0
    add.l   d6,d0
    lsr.l   #$1,d0
    move.l  d0,d6
    moveq   #$0,d0
    move.b  $0002(a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1eaa2
.l1ea36:                                                ; $01EA36
    moveq   #$0,d0
    move.b  $0002(a3),d0
    moveq   #$0,d1
    move.w  d4,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$01c8                                 ; jsr $01EC0E
    nop
    addq.l  #$4,sp
    tst.w   d0
    ble.b   .l1ea82
    moveq   #$0,d0
    move.b  $0001(a2),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    asr.l   #$1,d0
    add.w   d0,d5
    moveq   #$0,d0
    move.b  $0003(a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsr.l   #$1,d0
    bra.b   .l1ea9c
.l1ea82:                                                ; $01EA82
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d5
    moveq   #$0,d0
    move.b  $0003(a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
.l1ea9c:                                                ; $01EA9C
    add.l   d0,d6
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1eaa2:                                                ; $01EAA2
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    cmp.l   d1,d0
    blt.b   .l1ea36
    moveq   #$0,d1
    move.w  d5,d1
    move.l  d6,d0
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d6
    clr.w   d2
.l1eac0:                                                ; $01EAC0
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    clr.w   (a5,a0.l)
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1eac0
    moveq   #$0,d0
    move.b  (a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1eb44
.l1eaea:                                                ; $01EAEA
    clr.w   d2
.l1eaec:                                                ; $01EAEC
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0
    moveq   #$0,d1
    move.b  $0002(a2),d1
    cmp.w   d1,d0
    bcc.b   .l1eb38
    moveq   #$2,d3
    bra.b   .l1eb20
.l1eb06:                                                ; $01EB06
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  -$2(a5,a0.l),d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    subq.w  #$1,d3
.l1eb20:                                                ; $01EB20
    cmp.w   d2,d3
    bgt.b   .l1eb06
    moveq   #$0,d0
    move.b  $0002(a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    bra.b   .l1eb40
.l1eb38:                                                ; $01EB38
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1eaec
.l1eb40:                                                ; $01EB40
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1eb44:                                                ; $01EB44
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    cmp.l   d1,d0
    blt.b   .l1eaea
    moveq   #$0,d0
    move.b  $0002(a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1ebc4
.l1eb6a:                                                ; $01EB6A
    clr.w   d2
.l1eb6c:                                                ; $01EB6C
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0
    moveq   #$0,d1
    move.b  $0002(a2),d1
    cmp.w   d1,d0
    bcc.b   .l1ebb8
    moveq   #$2,d3
    bra.b   .l1eba0
.l1eb86:                                                ; $01EB86
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  -$2(a5,a0.l),d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    subq.w  #$1,d3
.l1eba0:                                                ; $01EBA0
    cmp.w   d2,d3
    bgt.b   .l1eb86
    moveq   #$0,d0
    move.b  $0002(a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    bra.b   .l1ebc0
.l1ebb8:                                                ; $01EBB8
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1eb6c
.l1ebc0:                                                ; $01EBC0
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1ebc4:                                                ; $01EBC4
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    cmp.l   d1,d0
    blt.b   .l1eb6a
    clr.w   d3
    clr.w   d2
.l1ebd6:                                                ; $01EBD6
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0
    add.w   d0,d3
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1ebd6
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
    move.w  d5,(a4)
    move.b  d3,$0002(a4)
    move.b  d6,$0003(a4)
    movem.l -$002c(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $01EC0E-$020000 ===
; 11 functions, 5106 bytes
