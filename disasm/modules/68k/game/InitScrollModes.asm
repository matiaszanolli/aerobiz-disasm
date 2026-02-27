; ============================================================================
; InitScrollModes -- Initialize VDP scroll registers and RAM scroll variables to default layer layout
; 226 bytes | $005654-$005735
; ============================================================================
InitScrollModes:
    movem.l a2-a3, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FFA6B4,a3
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$9030, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.w  #$c000, ($00FF88D6).l
    move.w  #$fc00, ($00FFA78A).l
    move.w  #$f800, ($00FFA778).l
    move.w  #$e000, (a3)
    move.w  #$fc00, ($00FF161C).l
    clr.w   ($00FFA780).l
    move.l  #$c000, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    jsr     (a2)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  ($00FF161C).l, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  ($00FFA778).l, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  ($00FF88D6).l, d0
    move.l  d0, -(a7)
    pea     ($001D).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0003).w
    clr.l   -(a7)
    bsr.w SetScrollQuadrant
    addq.l  #$8, a7
    movem.l (a7)+, a2-a3
    rts
