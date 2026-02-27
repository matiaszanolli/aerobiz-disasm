; ============================================================================
; BrowseCharList -- Scrollable character list loop with up/down navigation, stat preview on hover, and confirm or cancel
; Called: ?? times.
; 744 bytes | $008E0C-$0090F3
; ============================================================================
BrowseCharList:                                                  ; $008E0C
    link    a6,#$0
    movem.l d2-d6/a2-a5,-(sp)
    movea.l $000c(a6),a3
    movea.l #$0d64,a4
    movea.l #$00ff13fc,a5
    move.w  #$ff,d4
    movea.l #$00ffbd64,a2
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    tst.w   d0
    beq.b   .l8e3e
    moveq   #$1,d2
    bra.b   .l8e40
.l8e3e:                                                 ; $008E3E
    moveq   #$0,d2
.l8e40:                                                 ; $008E40
    clr.w   d5
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    bsr.w HitTestMapTile
    lea     $000c(sp),sp
    move.w  d0,d3
    cmpi.w  #$ff,d0
    beq.b   .l8e86
    cmp.w   d3,d4
    beq.b   .l8e82
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w DrawStatDisplay
    lea     $0014(sp),sp
.l8e82:                                                 ; $008E82
    move.w  d3,d4
    bra.b   .l8ebe
.l8e86:                                                 ; $008E86
    cmpi.w  #$ff,d4
    beq.b   .l8ebe
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    lea     $0024(sp),sp
    move.w  #$ff,d4
.l8ebe:                                                 ; $008EBE
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $0002(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  (a2),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $0024(sp),sp
    tst.w   d2
    beq.b   .l8f14
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l8f14
    pea     ($0003).w
.l8f0a:                                                 ; $008F0A
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8,sp
    bra.b   .l8ebe
.l8f14:                                                 ; $008F14
    clr.w   d2
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$bf,d0
    move.w  d0,d5
    andi.w  #$20,d0
    beq.b   .l8f60
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    clr.l   -(sp)
    move.w  $0002(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0da0                                 ; jsr $009CEC
    nop
    lea     $000c(sp),sp
    cmpi.w  #$ff,d3
    beq.w   .l8ebe
    bra.w   .l90e8
.l8f60:                                                 ; $008F60
    move.w  d5,d0
    andi.w  #$10,d0
    beq.b   .l8f78
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  #$ff,d3
    bra.w   .l90e8
.l8f78:                                                 ; $008F78
    move.w  d5,d0
    andi.w  #$80,d0
    beq.w   .l9052
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d5,d0
    andi.w  #$80,d0
    beq.w   .l901a
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w CharacterBrowser
    move.w  d0,d6
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $0024(sp),sp
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0014(sp),sp
.l901a:                                                 ; $00901A
    cmpi.w  #$ff,d6
    beq.b   .l904a
    cmp.w   (a3),d6
    beq.b   .l904a
    move.w  d6,(a3)
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    lea     $001c(sp),sp
    move.w  #$ff,d3
.l904a:                                                 ; $00904A
    pea     ($0002).w
    bra.w   .l8f0a
.l9052:                                                 ; $009052
    move.w  d5,d0
    andi.w  #$f,d0
    beq.w   .l8ebe
    move.w  #$1,(a5)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    bsr.w AdjustScrollPos
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    bsr.w HitTestMapTile
    lea     $0010(sp),sp
    move.w  d0,d3
    cmpi.w  #$ff,d0
    beq.b   .l90a8
    cmp.w   d3,d4
    beq.b   .l90a4
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w DrawStatDisplay
    lea     $0014(sp),sp
.l90a4:                                                 ; $0090A4
    move.w  d3,d4
    bra.b   .l90e0
.l90a8:                                                 ; $0090A8
    cmpi.w  #$ff,d4
    beq.b   .l90e0
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    lea     $0024(sp),sp
    move.w  #$ff,d4
.l90e0:                                                 ; $0090E0
    pea     ($0001).w
    bra.w   .l8f0a
.l90e8:                                                 ; $0090E8
    move.w  d3,d0
    movem.l -$0024(a6),d2-d6/a2-a5
    unlk    a6
    rts
