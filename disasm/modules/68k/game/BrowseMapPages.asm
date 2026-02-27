; ============================================================================
; BrowseMapPages -- Draws a paginated character/city map list with two tile columns per entry and runs a navigation loop; returns the selected index or -1 for cancel
; ============================================================================
BrowseMapPages:                                                  ; $017566
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0028(sp),d6
    movea.l #$0d64,a2
    movea.l #$00ff13fc,a3
    movea.l #$0001e044,a4
    movea.l #$0004c974,a5
    pea     ($0010).w
    pea     ($0010).w
    move.l  a5,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  a5,d0
    moveq   #$22,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    move.l  a5,d0
    addi.l  #$0722,d0
    move.l  d0,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0028(sp),sp
    tst.w   d0
    beq.b   .l17618
    moveq   #$1,d4
    bra.b   .l1761a
.l17618:                                                ; $017618
    moveq   #$0,d4
.l1761a:                                                ; $01761A
    clr.w   d5
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d3
.l17626:                                                ; $017626
    move.w  d3,d2
    ext.l   d2
    move.l  d2,d0
    moveq   #$b,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d2
    addq.l  #$3,d2
    move.l  d2,-(sp)
    pea     ($0002).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2,d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    clr.l   -(sp)
    pea     ($0544).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $002c(sp),sp
    tst.w   d4
    beq.b   .l17692
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l17692
    pea     ($0003).w
.l17688:                                                ; $017688
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8,sp
    bra.b   .l17626
.l17692:                                                ; $017692
    clr.w   d4
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$33,d0
    move.w  d0,d5
    andi.w  #$30,d0
    beq.w   .l1774a
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d5,d0
    andi.w  #$20,d0
    beq.w   .l17746
    tst.w   d6
    bne.b   .l176da
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$f552                           ; jsr $00F552
    addq.l  #$4,sp
    tst.w   d0
    beq.w   .l177a4
.l176da:                                                ; $0176DA
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    moveq   #$b,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addq.l  #$3,d0
    move.l  d0,d2
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    clr.l   -(sp)
    pea     ($0546).w
    jsr     (a4)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2,d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    clr.l   -(sp)
    pea     ($0548).w
    jsr     (a4)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    bra.b   .l177ac
.l17746:                                                ; $017746
    moveq   #-$1,d0
    bra.b   .l177be
.l1774a:                                                ; $01774A
    move.w  d5,d0
    andi.w  #$1,d0
    beq.b   .l17778
    move.w  #$1,(a3)
    clr.w   d3
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0002).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    bra.b   .l177a4
.l17778:                                                ; $017778
    move.w  d5,d0
    andi.w  #$2,d0
    beq.b   .l177a4
    move.w  #$1,(a3)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    moveq   #$1,d3
.l177a4:                                                ; $0177A4
    pea     ($0005).w
    bra.w   .l17688
.l177ac:                                                ; $0177AC
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a2)
    lea     $000c(sp),sp
    move.w  d3,d0
.l177be:                                                ; $0177BE
    movem.l (sp)+,d2-d6/a2-a5
    rts
