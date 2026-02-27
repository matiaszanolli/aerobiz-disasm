; ============================================================================
; DrawStatDisplay -- Draw statistic bar display with text labels
; Called: 11 times.
; 352 bytes | $0088EA-$008A49
; ============================================================================
DrawStatDisplay:                                                  ; $0088EA
    link    a6,#$0
    movem.l d2-d6/a2,-(sp)
    move.l  $0014(a6),d2
    move.l  $0010(a6),d3
    move.l  $0008(a6),d4
    movea.l #$0d64,a2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
    cmpi.w  #$ff,d4
    bne.w   .l89a6
    pea     ($077E).w
    pea     ($0002).w
    pea     ($0003).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0012).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    tst.w   d3
    bne.b   .l896e
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
.l895e:                                                 ; $00895E
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    bra.w   .l8a40
.l896e:                                                 ; $00896E
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0012).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    pea     ($077E).w
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0015).w
    pea     ($0002).w
    bra.b   .l895e
.l89a6:                                                 ; $0089A6
    tst.w   d3
    beq.b   .l89b2
    cmpi.w  #$1,d3
    bne.w   .l8a40
.l89b2:                                                 ; $0089B2
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000E).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d6
    ext.l   d6
    move.l  d6,d0
    lsl.l   #$3,d6
    sub.l   d0,d6
    add.l   d6,d6
    move.l  d6,d5
    addq.l  #$2,d6
    move.l  d6,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  d5,d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0024(sp),sp
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$0690,d0
    move.l  d0,-(sp)
    move.w  $001a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    move.l  d6,d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w PlaceCharSprite
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003E1A6).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
.l8a40:                                                 ; $008A40
    movem.l -$0018(a6),d2-d6/a2
    unlk    a6
    rts
