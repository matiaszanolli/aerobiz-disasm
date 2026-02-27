; ============================================================================
; PlaceItemTiles -- Place a series of item tiles from a byte list at sequentially computed screen positions, calling TilePlacement and GameCommand $E per entry.
; Called: 9 times.
; 86 bytes | $023A34-$023A89
; ============================================================================
PlaceItemTiles:                                                  ; $023A34
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d3
    movea.l $0010(sp),a2
    clr.w   d2
    bra.b   .l23a7a
.l23a44:                                                ; $023A44
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00F0).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    addq.l  #$1,a2
    addq.w  #$1,d2
.l23a7a:                                                ; $023A7A
    cmp.w   d3,d2
    bcc.b   .l23a84
    cmpi.b  #$ff,(a2)
    bne.b   .l23a44
.l23a84:                                                ; $023A84
    movem.l (sp)+,d2-d3/a2
    rts
