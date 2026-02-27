; ============================================================================
; RenderCharDetails -- Renders the set of character stat slot tiles on the transfer panel: iterates from 0 to the current slot count, computing each tile's screen position in a 2-column layout, and calls TilePlacement to draw each slot indicator tile
; 210 bytes | $02E202-$02E2D3
; ============================================================================
RenderCharDetails:
    movem.l d2-d4/a2, -(a7)
    move.l  $1c(a7), d2
    move.l  $14(a7), d3
    move.w  d3, d0
    mulu.w  #$14, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.w   .l2e2be
.l2e22c:
    addq.w  #$1, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2e254
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2e246
    addq.l  #$1, d0
.l2e246:
    asr.l   #$1, d0
    move.l  d0, d3
    mulu.w  #$18, d3
    addi.w  #$fff8, d3
    bra.b   .l2e266
.l2e254:
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2e25c
    addq.l  #$1, d0
.l2e25c:
    asr.l   #$1, d0
    move.l  d0, d3
    mulu.w  #$18, d3
    addq.w  #$8, d3
.l2e266:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d4
    lsl.w   #$4, d4
    addi.w  #$a8, d4
    subq.w  #$1, d2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d2
.l2e2be:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    cmp.l   d1, d0
    blt.w   .l2e22c
    movem.l (a7)+, d2-d4/a2
    rts
