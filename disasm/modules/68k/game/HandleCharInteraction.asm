; ============================================================================
; HandleCharInteraction -- Animates a tile wipe transition on the character panel: two modes (flag=1: left-to-right tile slide, flag=0: symmetric fold-out) using TilePlacement in loops with VBlank waits to produce smooth character-card reveal/hide effects
; 512 bytes | $02EFD2-$02F1D1
; ============================================================================
HandleCharInteraction:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d4
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    clr.w   d2
    clr.w   d3
    move.w  #$750, d6
    cmpi.w  #$1, d4
    bne.w   .l2f0dc
    moveq   #$30,d4
    move.w  #$a8, d5
    pea     ($0004).w
    jsr LoadDisplaySet
    addq.l  #$4, a7
    bra.b   .l2f042
.l2f00a:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
.l2f042:
    cmpi.w  #$28, d2
    blt.b   .l2f00a
    bra.b   .l2f08a
.l2f04a:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    addq.w  #$6, d3
.l2f08a:
    cmpi.w  #$48, d3
    blt.b   .l2f04a
    add.w   d2, d4
    clr.w   d2
.l2f094:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    cmpi.w  #$20, d2
    blt.b   .l2f094
    bra.w   .l2f1c4
.l2f0dc:
    move.w  #$c0, d4
    moveq   #$60,d5
    pea     ($0005).w
    jsr LoadDisplaySet
    addq.l  #$4, a7
    bra.b   .l2f12e
.l2f0f0:
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
.l2f12e:
    cmpi.w  #$18, d2
    blt.b   .l2f0f0
    bra.b   .l2f176
.l2f136:
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    addq.w  #$6, d3
.l2f176:
    cmpi.w  #$48, d3
    blt.b   .l2f136
    sub.w   d2, d4
    clr.w   d2
.l2f180:
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    cmpi.w  #$30, d2
    blt.b   .l2f180
.l2f1c4:
    pea     ($0018).w
    jsr     (a2)
    addq.l  #$4, a7
    movem.l (a7)+, d2-d6/a2-a3
    rts
