; ============================================================================
; ShowCharDetail -- Render full character detail panel: clear tiles, draw stat bars, format numeric stat fields
; Called: ?? times.
; 644 bytes | $007D92-$008015
; ============================================================================
ShowCharDetail:                                                  ; $007D92
    link    a6,#-$80
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0018(a6),d2
    move.l  $0014(a6),d3
    move.l  $0020(a6),d4
    move.l  $000c(a6),d5
    move.l  $001c(a6),d6
    move.l  $0008(a6),d7
    lea     -$0080(a6),a4
    movea.l #$0003b270,a5
    move.w  d5,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d7,d0
    lsl.w   #$5,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $000c(sp),sp
    cmpi.w  #$1,d6
    bne.b   .l7e50
    move.l  ($000A1AE8).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0037).w
    pea     ($06B4).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($00070F78).l
    pea     ($0008).w
    pea     ($000E).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
.l7e50:                                                 ; $007E50
    pea     ($0008).w
    pea     ($000F).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  $0002(a2),d0
    move.l  d0,-(sp)
    pea     ($0003E1A2).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$9,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    move.l  d0,-(sp)
    pea     ($0003E19E).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0008(a2),d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    pea     ($0003E19A).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0009(a2),d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    pea     ($0003E196).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    lea     $0010(sp),sp
    cmpi.w  #$1,d6
    bne.b   .l7fca
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a3),d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003E192).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
    moveq   #$0,d0
    move.b  $0001(a3),d0
    move.l  d0,-(sp)
    pea     ($0003E18E).l
    bra.b   .l8000
.l7fca:                                                 ; $007FCA
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    addq.l  #$8,sp
    move.w  d5,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$002a                                 ; jsr $008016
    nop
    addq.l  #$8,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($0003E188).l
.l8000:                                                 ; $008000
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    move.l  a4,-(sp)
    jsr     (a5)
    movem.l -$00a8(a6),d2-d7/a2-a5
    unlk    a6
    rts
