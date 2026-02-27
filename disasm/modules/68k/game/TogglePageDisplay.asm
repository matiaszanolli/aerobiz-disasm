; ============================================================================
; TogglePageDisplay -- Flip display pages alternately by decompressing tiles from $000482D4 and polling input, exiting when the player provides input (page-flip selection UI).
; Called: ?? times.
; 90 bytes | $023B10-$023B69
; ============================================================================
TogglePageDisplay:                                                  ; $023B10
    movem.l d2-d4,-(sp)
    move.l  $0010(sp),d4
    moveq   #$1,d2
.l23b1a:                                                ; $023B1A
    clr.l   -(sp)
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l #$000482d4,a0
    move.w  (a0,d0.l),d0
    add.w   d0,d0
    movea.l #$00ff1804,a0
    pea     (a0,d0.w)
    pea     ($0078).w
    pea     ($0640).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    moveq   #$1,d0
    eor.w   d0,d2
    clr.l   -(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
    lea     $001c(sp),sp
    move.w  d0,d3
    tst.w   d3
    beq.b   .l23b1a
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
