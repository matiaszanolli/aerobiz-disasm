; ============================================================================
; SelectPreviewPage -- Display 6-page character preview table and handle left/right/confirm/cancel input
; Called: ?? times.
; 398 bytes | $007784-$007911
; ============================================================================
SelectPreviewPage:                                                  ; $007784
    link    a6,#-$c
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    movea.l #$0004745c,a2
    movea.l #$0001d568,a3
    movea.l #$0d64,a4
    moveq   #$1,d3
    move.w  #$0754,d5
    clr.w   d2
    moveq   #$0,d4
    move.w  d5,d4
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d4
.l77b8:                                                 ; $0077B8
    move.w  d2,d0
    add.w   d0,d0
    move.w  d4,-$c(a6,d0.w)
    addq.l  #$1,d4
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .l77b8
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     -$000c(a6)
    pea     ($0001).w
    pea     ($0006).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)
    lea     $0030(sp),sp
.l7800:                                                 ; $007800
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    andi.w  #$0fff,d0
    bne.b   .l7800
.l7810:                                                 ; $007810
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
    addq.l  #$8,sp
    move.w  d0,d2
    andi.l  #$3c,d0
    beq.b   .l7810
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8,sp
    move.w  d2,d0
    andi.w  #$c,d0
    beq.b   .l788a
    move.w  d2,d0
    andi.w  #$4,d0
    beq.b   .l7866
    cmpi.w  #$1,d3
    beq.b   .l7862
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    lea     $0014(sp),sp
.l7862:                                                 ; $007862
    moveq   #$1,d3
    bra.b   .l788a
.l7866:                                                 ; $007866
    tst.w   d3
    beq.b   .l7888
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$c0,d0
    move.l  d0,-(sp)
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    lea     $0014(sp),sp
.l7888:                                                 ; $007888
    clr.w   d3
.l788a:                                                 ; $00788A
    move.w  d2,d0
    andi.w  #$30,d0
    beq.w   .l7810
    cmpi.w  #$1,d3
    bne.b   .l78a6
    move.w  d2,d0
    andi.w  #$20,d0
    beq.b   .l78a6
    moveq   #$1,d3
    bra.b   .l78b0
.l78a6:                                                 ; $0078A6
    move.w  d2,d0
    andi.w  #$10,d0
    beq.b   .l78b0
    clr.w   d3
.l78b0:                                                 ; $0078B0
    cmpi.w  #$1,d3
    bne.b   .l78be
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    bra.b   .l78cc
.l78be:                                                 ; $0078BE
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$c0,d0
    move.l  d0,-(sp)
.l78cc:                                                 ; $0078CC
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $001c(sp),sp
    pea     ($02EC).w
    pea     ($0001).w
    pea     ($0006).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    move.w  d3,d0
    movem.l -$0030(a6),d2-d7/a2-a4
    unlk    a6
    rts
