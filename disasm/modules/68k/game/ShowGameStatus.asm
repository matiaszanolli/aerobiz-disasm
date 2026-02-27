; ============================================================================
; ShowGameStatus -- Renders the global game-status screen: builds the background with city-column headers, displays each player's city count and rank tokens, places character portraits with their current rankings, and shows total route counts.
; Called: ?? times.
; 1072 bytes | $0271C6-$0275F5
; ============================================================================
ShowGameStatus:                                                  ; $0271C6
    link    a6,#-$e4
    movem.l d2-d5/a2-a5,-(sp)
    move.w  #$7c00,-$0002(a6)
    clr.w   -$0004(a6)
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    dc.w    $4eb9,$0000,$68ca                           ; jsr $0068CA
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $002c(sp),sp
    pea     ($0004).w
    pea     ($0021).w
    pea     ($00FF0118).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0001).w
    pea     ($0025).w
    pea     -$0002(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0001).w
    pea     ($0026).w
    pea     -$0004(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A9E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $0030(sp),sp
    move.l  ($000A1B68).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0015).w
    pea     ($030F).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($00073378).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l272c4
    addq.l  #$3,d0
.l272c4:                                                ; $0272C4
    asr.l   #$2,d0
    addi.w  #$07a3,d0
    move.w  d0,d2
    pea     ($0001).w
    pea     ($0005).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($00041598).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0010(sp),sp
    movea.l #$0005faa6,a2
    clr.w   d3
    move.w  d3,d0
    lsl.w   #$5,d0
    lea     -$00e4(a6),a0
    lea     (a0,d0.w),a1
    movea.l a1,a3
    moveq   #$0,d5
    move.w  d3,d5
    lsl.l   #$4,d5
    addi.l  #$0640,d5
.l27312:                                                ; $027312
    clr.w   d2
    move.w  d2,d4
    ext.l   d4
    add.l   d5,d4
.l2731a:                                                ; $02731A
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  d4,(a3,a0.l)
    addq.l  #$1,d4
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l2731a
    move.l  a3,-(sp)
    pea     ($0002).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    addi.w  #$fffe,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$2,d0
    movea.l #$000a1ac8,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0010).w
    move.l  d5,-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0030(sp),sp
    addq.l  #$2,a2
    moveq   #$10,d0
    add.l   d0,d5
    moveq   #$20,d0
    adda.l  d0,a3
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    bcs.w   .l27312
    movea.l #$00ff0018,a5
    clr.w   d2
.l273aa:                                                ; $0273AA
    moveq   #$0,d0
    move.b  $0001(a5),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d4
    movea.l #$0005faa6,a2
    move.w  d2,d0
    lsl.w   #$3,d0
    movea.l #$00ff0270,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    lsl.w   #$5,d0
    movea.l #$00ff0130,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d3
.l273e6:                                                ; $0273E6
    tst.l   (a4)
    beq.w   .l27492
    moveq   #$0,d0
    move.w  d2,d0
    addi.l  #$0754,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  (a4),-(sp)
    pea     ($00041592).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    addq.w  #$7,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
    lea     $0010(sp),sp
    bra.b   .l274ce
.l27492:                                                ; $027492
    pea     ($075C).w
    pea     ($0005).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
.l274ce:                                                ; $0274CE
    cmp.w   d4,d3
    bne.b   .l27522
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    lsl.w   #$3,d0
    addi.w  #$fff8,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$3,d0
    addi.w  #$fff8,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0760).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
.l27522:                                                ; $027522
    addq.l  #$2,a2
    addq.l  #$1,a3
    addq.l  #$4,a4
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    bcs.w   .l273e6
    moveq   #$24,d0
    adda.l  d0,a5
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.w   .l273aa
    movea.l #$0005fab4,a2
    clr.w   d2
    move.w  d2,d0
    lsl.w   #$3,d0
    movea.l #$00ff0277,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
.l27558:                                                ; $027558
    moveq   #$0,d0
    move.w  d2,d0
    addi.l  #$0754,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d1
    add.w   d1,d0
    addi.w  #$fffe,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d1
    add.w   d1,d0
    addi.w  #$fffe,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $002c(sp),sp
    addq.l  #$8,a3
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.w   .l27558
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    movem.l -$0104(a6),d2-d5/a2-a5
    unlk    a6
    rts
; === Translated block $0275F6-$027AA4 ===
; 4 functions, 1198 bytes
