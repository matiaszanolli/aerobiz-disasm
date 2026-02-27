; ============================================================================
; SetScrollOffset -- Sets the scroll registers for both background planes: if both offsets are zero clears the scroll buffer, otherwise writes horizontal and vertical scroll values at $FF5804 and issues GameCommand DMA (cmd 8 and cmd 5) to push the scroll table to VDP.
; Called: ?? times.
; 152 bytes | $01D8F4-$01D98B
; ============================================================================
SetScrollOffset:                                                  ; $01D8F4
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $001c(sp),d2
    move.l  $0020(sp),d3
    move.l  $0018(sp),d4
    movea.l #$0d64,a3
    move.l  #$8b00,-(sp)
    clr.l   -(sp)
    jsr     (a3)
    addq.l  #$8,sp
    movea.l #$00ff5804,a2
    move.w  d2,d0
    or.w    d3,d0
    bne.b   .l1d934
    pea     ($0008).w
    clr.l   -(sp)
    move.l  a2,-(sp)
    bsr.w MemFillByte
    lea     $000c(sp),sp
    bra.b   .l1d94a
.l1d934:                                                ; $01D934
    neg.w   d2
    tst.w   d4
    bne.b   .l1d944
    move.w  d2,$0002(a2)
    move.w  d3,$0006(a2)
    bra.b   .l1d94a
.l1d944:                                                ; $01D944
    move.w  d2,(a2)
    move.w  d3,$0004(a2)
.l1d94a:                                                ; $01D94A
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(sp)
    move.l  a2,d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0008).w
    jsr     (a3)
    lea     $001c(sp),sp
    clr.l   -(sp)
    move.l  #$fc00,-(sp)
    move.l  a2,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $0018(sp),sp
    movem.l (sp)+,d2-d4/a2-a3
    rts
    dc.w    $48E7,$3C38                                      ; $01D98C
; === Translated block $01D990-$01DC26 ===
; 2 functions, 662 bytes
