; ============================================================================
; RunTurnSequence -- Renders the full turn intro sequence (route maps, banner graphics, city panels) for the current player, loops over three route-panel subviews, then handles end-of-turn input and invokes CalcRouteRevenue on exit.
; Called: ?? times.
; 1490 bytes | $029ABC-$02A08D
; ============================================================================
RunTurnSequence:                                                  ; $029ABC
    link    a6,#-$4
    movem.l d2-d6/a2-a5,-(sp)
    movea.l #$0d64,a3
    movea.l #$00ff1804,a4
    movea.l #$5092,a5
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    moveq   #$0,d4
    move.b  ($00FF0016).l,d4
    move.w  d4,d0
    mulu.w  #$c,d0
    movea.l #$00ff03f0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0004C68E).l
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($0003).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0004C696).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00B2).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($0004C610).l
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($000C).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($0004C618).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00AE).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0018(sp),sp
    pea     ($0004C596).l
    pea     ($0002).w
    pea     ($0002).w
    pea     ($000B).w
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0004C59E).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($00AA).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($00072A6C).l
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($00072A88).l
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($000D).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $001c(sp),sp
    pea     ($00072AA4).l
    pea     ($0002).w
    pea     ($0007).w
    pea     ($0010).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076ADE).l
    jsr     (a5)
    move.l  ($000A1B30).l,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($0048).w
    pea     ($005B).w
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($0007267C).l
    pea     ($0012).w
    pea     ($001C).w
    pea     ($0001).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076B1E).l
    jsr     (a5)
    pea     ($0004BD5A).l
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $0028(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004BD96).l
    pea     ($001E).w
    pea     ($003D).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    move.l  ($000A1B60).l,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($001E).w
    pea     ($0001).w
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    lea     $0028(sp),sp
    pea     ($000732DC).l
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($000D).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $001c(sp),sp
    pea     ($0004C178).l
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0005).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004C1B4).l
    pea     ($001E).w
    pea     ($001F).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0030(sp),sp
    pea     ($0004C734).l
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0640).w
    dc.w    $4eb9,$0001,$d7be                           ; jsr $01D7BE
    pea     ($0004C854).l
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0649).w
    dc.w    $4eb9,$0001,$d7be                           ; jsr $01D7BE
    lea     $0020(sp),sp
    clr.w   d2
.l29d7c:                                                ; $029D7C
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0354                                 ; jsr $02A0DE
    nop
    addq.l  #$8,sp
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l29d7c
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l29db0
    moveq   #$1,d5
    bra.b   .l29db2
.l29db0:                                                ; $029DB0
    moveq   #$0,d5
.l29db2:                                                ; $029DB2
    clr.w   d2
    moveq   #$1,d3
.l29db6:                                                ; $029DB6
    cmpi.w  #$1,d3
    bne.b   .l29dda
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($000420FE).l
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $0014(sp),sp
    clr.w   d3
.l29dda:                                                ; $029DDA
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076ADE).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004C158).l
    jsr     (a5)
    lea     $0018(sp),sp
    tst.w   d5
    beq.b   .l29e1e
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l29e1e
    pea     ($0002).w
.l29e14:                                                ; $029E14
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    bra.b   .l29db6
.l29e1e:                                                ; $029E1E
    clr.w   d5
    pea     ($003C).w
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eba,$0886                                 ; jsr $02A6B8
    nop
    move.w  d0,d6
    pea     ($0008).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0014(sp),sp
    move.w  d6,d0
    andi.w  #$10,d0
    bne.w   .l2a02e
    move.w  d6,d0
    andi.w  #$20,d0
    beq.w   .l2a006
    move.w  #$0ccc,-$0002(a6)
    pea     ($0001).w
    move.w  d2,d6
    ext.l   d6
    addi.l  #$34,d6
    move.l  d6,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    move.w  #$0866,-$0002(a6)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    addi.l  #$37,d0
    move.l  d0,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    lea     $0018(sp),sp
    move.w  d2,d0
    ext.l   d0
    tst.w   d0
    beq.b   .l29eb0
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l29f12
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.w   .l29f6a
    bra.w   .l29fbe
.l29eb0:                                                ; $029EB0
    moveq   #$0,d0
    move.b  $0009(a2),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05b2                                 ; jsr $02A474
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l29fbe
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0009(a2),d1
    cmp.l   d1,d0
    beq.w   .l29fbe
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0184                                 ; jsr $02A07E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.w   .l29fbe
    move.b  d3,$0009(a2)
    bra.w   .l29fbe
.l29f12:                                                ; $029F12
    moveq   #$0,d0
    move.b  $000b(a2),d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$054e                                 ; jsr $02A474
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    blt.w   .l29fbe
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $000b(a2),d1
    cmp.l   d1,d0
    beq.b   .l29fbe
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0128                                 ; jsr $02A07E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l29fbe
    move.b  d3,$000b(a2)
    bra.b   .l29fbe
.l29f6a:                                                ; $029F6A
    moveq   #$0,d0
    move.b  $000a(a2),d0
    move.l  d0,-(sp)
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04f6                                 ; jsr $02A474
    nop
    lea     $000c(sp),sp
    move.w  d0,d3
    blt.b   .l29fbe
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $000a(a2),d1
    cmp.l   d1,d0
    beq.b   .l29fbe
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00d2                                 ; jsr $02A07E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l29fbe
    move.b  d3,$000a(a2)
.l29fbe:                                                ; $029FBE
    move.w  #$0222,-$0002(a6)
    pea     ($0001).w
    move.l  d6,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    move.w  #$0424,-$0002(a6)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    addi.l  #$37,d0
    move.l  d0,-(sp)
    pea     -$0002(a6)
    jsr     (a5)
    moveq   #$1,d3
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00e2                                 ; jsr $02A0DE
    nop
    lea     $0020(sp),sp
    bra.b   .l2a026
.l2a006:                                                ; $02A006
    move.w  d6,d0
    andi.w  #$8,d0
    beq.b   .l2a016
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l2a01c
.l2a016:                                                ; $02A016
    move.w  d2,d0
    ext.l   d0
    addq.l  #$2,d0
.l2a01c:                                                ; $02A01C
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
.l2a026:                                                ; $02A026
    pea     ($0005).w
    bra.w   .l29e14
.l2a02e:                                                ; $02A02E
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0001).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0028(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $02A07E-$02A738 ===
; 5 functions, 1722 bytes
