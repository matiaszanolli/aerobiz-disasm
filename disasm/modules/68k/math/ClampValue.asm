; ============================================================================
; ClampValue -- Initialises the route-scoring buffer ($FFB4E4, 0x500 bytes): for each of 4 players iterates their active routes, resolves city coordinates via RangeLookup, fills the per-player/per-route score entries, then calls CompareElements to rank all routes.
; 230 bytes | $01E4EC-$01E5D1
; ============================================================================
ClampValue:
    movem.l d2-d4/a2-a5, -(a7)
    movea.l  #$0000D648,a5
    pea     ($0500).w
    clr.l   -(a7)
    pea     ($00FFB4E4).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF0018,a4
    clr.w   d3
l_1e514:
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_1e56c
l_1e53c:
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, (a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, $2(a2)
    clr.w   $4(a2)
    move.w  #$64, $6(a2)
    moveq   #$14,d0
    adda.l  d0, a3
    addq.l  #$8, a2
    addq.w  #$1, d2
l_1e56c:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a4), d1
    cmp.l   d1, d0
    blt.b   l_1e53c
    moveq   #$0,d4
    move.b  $4(a4), d4
    moveq   #$0,d0
    move.b  $5(a4), d0
    add.w   d0, d4
    moveq   #$0,d2
    move.b  $4(a4), d2
    bra.b   l_1e5b4
l_1e590:
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$4, a7
    move.w  d0, $2(a2)
    move.w  d0, (a2)
    clr.w   $4(a2)
    move.w  #$64, $6(a2)
    moveq   #$14,d0
    adda.l  d0, a3
    addq.l  #$8, a2
    addq.w  #$1, d2
l_1e5b4:
    cmp.w   d4, d2
    bcs.b   l_1e590
    moveq   #$24,d0
    adda.l  d0, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_1e514
    jsr (CompareElements,PC)
    nop
    movem.l (a7)+, d2-d4/a2-a5
    rts
