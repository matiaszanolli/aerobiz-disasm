; ============================================================================
; ShowPlayerChart -- builds and displays a player's chart panel by filtering active route/relation bits and drawing tiles
; Called: ?? times.
; 260 bytes | $0101CA-$0102CD
; ============================================================================
ShowPlayerChart:                                                  ; $0101CA
    link    a6,#-$10
    movem.l d2-d3/a2,-(sp)
    move.l  $0008(a6),d3
    lea     -$0010(a6),a2
    pea     ($0010).w
    move.l  a2,-(sp)
    pea     ($00076ACE).l
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    clr.w   d2
.l101ee:                                                ; $0101EE
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$0005ecdc,a0
    and.l   (a0,d1.w),d0
    beq.b   .l10226
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$00ff0118,a0
    move.w  (a0,d0.w),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a2,a0.l)
.l10226:                                                ; $010226
    addq.w  #$1,d2
    cmpi.w  #$7,d2
    blt.b   .l101ee
    pea     ($0008).w
    pea     ($0030).w
    pea     ($00076ABE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0004A63A).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0020(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0025).w
    pea     ($0330).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($0004A5DA).l
    pea     ($0006).w
    pea     ($0008).w
    clr.l   -(sp)
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
    pea     ($0008).w
    pea     ($0038).w
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($6330).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$001c(a6),d2-d3/a2
    unlk    a6
    rts
