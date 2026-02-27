; ============================================================================
; PlacePlayerNameLabels -- Place name tile labels for each active player at their hub city position on the map
; 276 bytes | $00AF2E-$00B041
; ============================================================================
PlacePlayerNameLabels:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $14(a7), d3
    movea.l  #$00FF0018,a2
    cmpi.w  #$7, d3
    bge.w   .l0afd2
    clr.w   d2
.l0af46:
    cmpi.b  #$ff, $1(a2)
    beq.b   .l0afc2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmp.w   d3, d0
    bne.b   .l0afc2
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    move.b  (a0,d0.w), d1
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0760).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
.l0afc2:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0af46
    bra.b   .l0b03c
.l0afd2:
    clr.w   d2
.l0afd4:
    cmpi.b  #$ff, $1(a2)
    beq.b   .l0b030
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0760).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
.l0b030:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0afd4
.l0b03c:
    movem.l (a7)+, d2-d3/a2-a3
    rts
