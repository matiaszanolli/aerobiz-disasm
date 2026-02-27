; ============================================================================
; DrawCharInfoPanel -- Draw a character info panel with tile graphics, stat bar, and scroll bar overlays
; Called: ?? times.
; 804 bytes | $00643C-$00675F
; ============================================================================
DrawCharInfoPanel:                                                  ; $00643C
    link    a6,#-$34
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0010(a6),d4
    move.l  $0008(a6),d5
    move.l  $0018(a6),d6
    movea.l #$0d64,a3
    lea     -$0030(a6),a4
    movea.l #$0004743c,a5
    tst.w   $0022(a6)
    beq.b   .l646a
    moveq   #$19,d0
    bra.b   .l646c
.l646a:                                                 ; $00646A
    moveq   #$2,d0
.l646c:                                                 ; $00646C
    move.w  d0,-$0032(a6)
    tst.w   $0022(a6)
    beq.b   .l647a
    moveq   #$2,d3
    bra.b   .l647c
.l647a:                                                 ; $00647A
    moveq   #$7,d3
.l647c:                                                 ; $00647C
    tst.w   $001e(a6)
    beq.b   .l6486
    moveq   #$13,d2
    bra.b   .l6488
.l6486:                                                 ; $006486
    moveq   #$2,d2
.l6488:                                                 ; $006488
    moveq   #$0,d0
    move.w  d5,d0
    moveq   #$36,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d4
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d6
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    moveq   #$0,d0
    move.w  d2,d0
    subq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    pea     ($0006).w
    pea     ($0017).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    pea     ($077E).w
    pea     ($0006).w
    pea     ($0017).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  -$0032(a6),d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5f00                           ; jsr $005F00
    moveq   #$0,d0
    move.w  d5,d0
    lsl.l   #$2,d0
    movea.l #$000ae19c,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $002c(sp),sp
    pea     ($0018).w
    pea     ($07E8).w
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    pea     ($0018).w
    move.w  d4,d0
    moveq   #$d,d1
    lsl.w   d1,d0
    ori.w   #$07e8,d0
    move.l  d0,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$5ede                           ; jsr $005EDE
    lea     $0018(sp),sp
    move.w  -$0032(a6),d3
    move.w  d2,d7
    addq.w  #$2,d7
    moveq   #$0,d0
    move.w  ($00FF88D6).l,d0
    movea.l d0,a2
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    add.l   d0,d0
    adda.l  d0,a2
    move.l  a2,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$3,d0
    pea     (a5,d0.l)
    move.l  a4,-(sp)
    pea     ($0005).w
    pea     ($0004).w
    pea     ($000C).w
    clr.l   -(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    move.w  -$0032(a6),d3
    addq.w  #$1,d3
    move.w  d2,d7
    addq.w  #$4,d7
    moveq   #$0,d0
    move.w  ($00FF88D6).l,d0
    movea.l d0,a2
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    add.l   d0,d0
    adda.l  d0,a2
    move.l  a2,-(sp)
    move.l  a5,d0
    moveq   #$18,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.l  a4,d0
    moveq   #$1e,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    pea     ($0004).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    move.l  $0024(a6),-(sp)
    pea     ($0003E182).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $0028(sp),sp
    move.l  a2,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$3,d0
    pea     (a5,d0.l)
    move.l  a4,-(sp)
    pea     ($0005).w
    pea     ($0004).w
    pea     ($0010).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    move.l  a2,-(sp)
    move.l  a5,d0
    moveq   #$18,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.l  a4,d0
    moveq   #$1e,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    pea     ($0004).w
    pea     ($000A).w
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    tst.w   $0022(a6)
    beq.b   .l6748
    moveq   #$19,d0
    bra.b   .l674a
.l6748:                                                 ; $006748
    moveq   #$2,d0
.l674a:                                                 ; $00674A
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5f00                           ; jsr $005F00
    movem.l -$005c(a6),d2-d7/a2-a5
    unlk    a6
    rts
