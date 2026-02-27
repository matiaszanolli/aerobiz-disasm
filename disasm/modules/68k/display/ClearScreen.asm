; ============================================================================
; ClearScreen -- Clear display mode, fill tile buffer, blank both BG layers via GameCommand sequence
; Called: ?? times.
; 98 bytes | $0053BA-$00541B
; ============================================================================
ClearScreen:                                                  ; $0053BA
    move.l  a2,-(sp)
    movea.l #$0d64,a2
    pea     ($000D).w
    jsr     (a2)
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a2)
    move.l  #$8000,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $002c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    lea     $0020(sp),sp
    movea.l (sp)+,a2
    rts
    dc.w    $4E56,$FFFC; $00541C
; === Translated block $005420-$005518 ===
; 4 functions, 248 bytes
