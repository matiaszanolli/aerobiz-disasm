; ============================================================================
; DrawCharDetailPanel -- Draws a character detail panel: sets up a fixed layout block, renders stat fields, decompresses a portrait graphic to work RAM, and calls GameCommand to display it.
; Called: ?? times.
; 222 bytes | $01AFF0-$01B0CD
; ============================================================================
DrawCharDetailPanel:                                                  ; $01AFF0
    movem.l d2-d3/a2-a3,-(sp)
    move.l  $001c(sp),d3
    movea.l #$0004978c,a2
    movea.l #$0d64,a3
    moveq   #$1,d2
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $0018(sp),sp
    move.l  a2,d0
    moveq   #$22,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    pea     ($001E).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$027a,d0
    move.l  d0,-(sp)
    pea     ($0009).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0030(sp),sp
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
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $0030(sp),sp
    movem.l (sp)+,d2-d3/a2-a3
    rts
