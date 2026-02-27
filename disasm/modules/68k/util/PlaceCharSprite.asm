; ============================================================================
; PlaceCharSprite -- Look up character sprite index from stat table, decompress portrait, and place sprite on screen
; Called: ?? times.
; 176 bytes | $00883A-$0088E9
; ============================================================================
PlaceCharSprite:                                                  ; $00883A
    link    a6,#-$c0
    movem.l d2-d3/a2,-(sp)
    move.l  $0018(a6),d3
    move.w  $000a(a6),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a2),d0
    movea.l #$0005ec4a,a0
    move.b  (a0,d0.w),d2
    andi.l  #$ff,d2
    cmpi.w  #$ff,d2
    beq.b   .l88e0
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$00095a22,a0
    move.l  (a0,d0.l),-(sp)
    pea     -$00c0(a6)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     -$00c0(a6)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    lea     $0030(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
.l88e0:                                                 ; $0088E0
    movem.l -$00cc(a6),d2-d3/a2
    unlk    a6
    rts
