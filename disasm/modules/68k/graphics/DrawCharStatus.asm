; ============================================================================
; DrawCharStatus -- Draws the status indicator for a specific character slot: looks up the character's region and player owner, then calls ShowCharInfoPageS2 with the appropriate status-label pointer; returns the dialog result
; 94 bytes | $02DA42-$02DA9F
; ============================================================================
DrawCharStatus:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    movea.l  #$00FF1278,a0
    move.b  (a0,d2.w), d3
    andi.l  #$ff, d3
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$000484EA,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    movem.l (a7)+, d2-d3
    rts
