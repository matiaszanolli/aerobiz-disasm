; ============================================================================
; UnpackPixelData -- Unpack 2-bit packed pixel data from ROM source into byte-per-pixel array at  (57 bytes per player)
; Called: ?? times.
; 64 bytes | $00EFC8-$00F007
; ============================================================================
UnpackPixelData:                                                  ; $00EFC8
    movem.l d2-d4,-(sp)
    movea.l $0010(sp),a0
    movea.l #$00ff05c4,a1
    clr.w   d3
.lefd8:                                                 ; $00EFD8
    move.b  (a0),d4
    clr.w   d2
.lefdc:                                                 ; $00EFDC
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$0,d1
    move.b  d4,d1
    asr.l   d0,d1
    move.l  d1,d0
    andi.b  #$03,d0
    move.b  d0,(a1)+
    addq.w  #$2,d2
    cmpi.w  #$8,d2
    bcs.b   .lefdc
    addq.l  #$1,a0
    addq.w  #$1,d3
    cmpi.w  #$39,d3
    bcs.b   .lefd8
    move.l  a0,d0
    movem.l (sp)+,d2-d4
    rts
; === Translated block $00F008-$00F086 ===
; 1 functions, 126 bytes
