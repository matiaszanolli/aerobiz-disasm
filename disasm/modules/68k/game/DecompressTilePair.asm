; ============================================================================
; DecompressTilePair -- Decompress two scenario tile images by index (mod 20 lookup in $000482AC) into the two tile buffers at $FF1804 and $FF3804 respectively.
; Called: ?? times.
; 134 bytes | $023A8A-$023B0F
; ============================================================================
DecompressTilePair:                                                  ; $023A8A
    movem.l d2-d3,-(sp)
    move.l  $000c(sp),d2
    move.l  $0010(sp),d3
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    add.w   d0,d0
    movea.l #$000482ac,a0
    move.w  (a0,d0.w),d0
    andi.l  #$ffff,d0
    lsl.l   #$2,d0
    movea.l #$00088c90,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    add.w   d0,d0
    movea.l #$000482ac,a0
    move.w  (a0,d0.w),d0
    andi.l  #$ffff,d0
    lsl.l   #$2,d0
    movea.l #$00088c90,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF3804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0010(sp),sp
    movem.l (sp)+,d2-d3
    rts
