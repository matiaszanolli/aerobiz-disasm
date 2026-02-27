; ============================================================================
; PackScrollControlBlock -- Writes a scroll-control block at the address in A0: sets the command word to $0080, encodes two 2-bit row/col indices into a packed position word, stores the tile-attribute word with the $8000 flag, and writes a trailing $0080 pad word.
; 64 bytes | $01DE52-$01DE91
; ============================================================================
PackScrollControlBlock:
    movea.l $4(a7), a0
    move.w  #$80, (a0)
    move.w  $a(a7), d0
    addi.w  #$ffff, d0
    andi.w  #$3, d0
    moveq   #$A,d1
    lsl.w   d1, d0
    move.w  $e(a7), d1
    addi.w  #$ffff, d1
    andi.w  #$3, d1
    lsl.w   #$8, d1
    or.l    d1, d0
    move.w  d0, $2(a0)
    move.w  $16(a7), d0
    ori.w   #$8000, d0
    move.w  d0, $4(a0)
    move.w  #$80, $6(a0)
    rts

; ---------------------------------------------------------------------------
LoadMapTiles:                                                  ; $01DE92
    movem.l a2-a4,-(sp)
    movea.l #$00ff1804,a2
    movea.l #$3fec,a3
    movea.l #$0001d568,a4
    pea     ($0004943A).l
    move.l  a2,-(sp)
    jsr     (a3)
    move.l  a2,-(sp)
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0740).w
    bsr.w DrawTileGrid
    pea     ($0004959E).l
    move.l  a2,-(sp)
    jsr     (a3)
    move.l  a2,-(sp)
    pea     ($0014).w
    pea     ($0760).w
    bsr.w ProcessTextControl
    lea     $002c(sp),sp
    pea     ($0004E1D8).l
    move.l  a2,-(sp)
    jsr     (a3)
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0001).w
    pea     ($077D).w
    jsr     (a4)
    clr.l   -(sp)
    pea     ($0004E1EC).l
    pea     ($0001).w
    pea     ($077F).w
    jsr     (a4)
    pea     ($0004E230).l
    move.l  a2,-(sp)
    jsr     (a3)
    lea     $0030(sp),sp
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0001).w
    pea     ($077E).w
    jsr     (a4)
    lea     $0010(sp),sp
    movem.l (sp)+,a2-a4
    rts
; === Translated block $01DF30-$01DFBE ===
; 1 functions, 142 bytes
