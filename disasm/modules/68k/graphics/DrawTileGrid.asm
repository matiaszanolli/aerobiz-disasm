; ============================================================================
; DrawTileGrid -- Draw grid of tiles from data buffer in nested row/col loop
; Called: 14 times.
; 126 bytes | $01D7BE-$01D83B
; ============================================================================
DrawTileGrid:                                                  ; $01D7BE
    movem.l d2-d6/a2,-(sp)
    move.l  $001c(sp),d3
    move.l  $0020(sp),d5
    move.l  $0024(sp),d6
    movea.l $0028(sp),a2
    move.w  d3,d0
    lsl.w   #$5,d0
    move.w  d0,d3
    clr.w   d4
    bra.b   .l1d822
.l1d7dc:                                                ; $01D7DC
    clr.w   d2
    bra.b   .l1d818
.l1d7e0:                                                ; $01D7E0
    clr.l   -(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    lsl.l   #$5,d0
    move.w  d2,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    pea     (a2,d0.l)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0018(sp),sp
    addi.w  #$20,d3
    addq.w  #$1,d2
.l1d818:                                                ; $01D818
    cmp.w   d6,d2
    blt.b   .l1d7e0
    moveq   #$20,d0
    adda.l  d0,a2
    addq.w  #$1,d4
.l1d822:                                                ; $01D822
    cmp.w   d5,d4
    blt.b   .l1d7dc
    pea     ($0002).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    movem.l (sp)+,d2-d6/a2
    rts
    dc.w    $48E7,$3E20                                      ; $01D83C
; === Translated block $01D840-$01D8F4 ===
; 3 functions, 180 bytes
