; ============================================================================
; BrowsePartners -- Finds the first valid partner slot, shows the partner list panel, and runs a left/right navigation loop calling FormatRelationStats for the highlighted partner until exit
; Called: ?? times.
; 410 bytes | $01A2CE-$01A467
; ============================================================================
BrowsePartners:                                                  ; $01A2CE
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0020(sp),d3
    movea.l #$0d64,a3
    movea.l #$00ff8804,a4
    clr.w   d2
.l1a2e4:                                                ; $01A2E4
    cmp.w   d3,d2
    beq.b   .l1a2f8
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    cmpi.w  #$ff,(a4,a0.l)
    bne.b   .l1a300
.l1a2f8:                                                ; $01A2F8
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l1a2e4
.l1a300:                                                ; $01A300
    cmpi.w  #$4,d2
    bge.w   .l1a462
    move.l  #$8000,-(sp)
    pea     ($000B).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($000B).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.w  #$ff,d3
    moveq   #$1,d5
    bra.w   .l1a408
.l1a358:                                                ; $01A358
    cmp.w   d2,d3
    beq.b   .l1a3a2
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a4,a0.l),d0
    mulu.w  #$14,d0
    move.w  d2,d1
    mulu.w  #$0320,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.l   -(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0013).w
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    bsr.w FormatRelationStats
    lea     $0018(sp),sp
    clr.w   d5
    move.w  d2,d3
.l1a3a2:                                                ; $01A3A2
    move.w  d4,d0
    andi.w  #$1,d0
    beq.b   .l1a3ca
.l1a3aa:                                                ; $01A3AA
    move.w  d2,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    cmpi.w  #$ff,(a4,a0.l)
    beq.b   .l1a3aa
    bra.b   .l1a3f0
.l1a3ca:                                                ; $01A3CA
    move.w  d4,d0
    andi.w  #$2,d0
    beq.b   .l1a3fc
.l1a3d2:                                                ; $01A3D2
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    cmpi.w  #$ff,(a4,a0.l)
    beq.b   .l1a3d2
.l1a3f0:                                                ; $01A3F0
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
.l1a3fc:                                                ; $01A3FC
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
.l1a408:                                                ; $01A408
    clr.l   -(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$10,d0
    bne.w   .l1a358
    move.l  #$8000,-(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l1a462:                                                ; $01A462
    movem.l (sp)+,d2-d5/a2-a4
    rts
