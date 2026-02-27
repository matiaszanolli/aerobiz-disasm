; ============================================================================
; UpdateGameLoopS2 -- Iterates over a 3x2 grid of text lines and a 3-item footer, calling ShowText for each entry from two lookup tables ($47C78 and $47C90); displays a multi-line quarterly summary text report for a player
; 128 bytes | $02FD10-$02FD8F
; ============================================================================
UpdateGameLoopS2:
    link    a6,#-$4
    movem.l d2-d4, -(a7)
    move.l  $8(a6), d4
    clr.w   d2
l_2fd1e:
    clr.w   d3
l_2fd20:
    clr.l   -(a7)
    move.w  d2, d0
    add.w   d0, d0
    add.w   d3, d0
    lsl.w   #$2, d0
    movea.l  #$00047C78,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    addq.w  #$1, d3
    cmpi.w  #$2, d3
    blt.b   l_2fd20
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_2fd1e
    clr.w   d2
l_2fd56:
    clr.l   -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047C90,a0
    move.l  (a0,d0.w), -(a7)
    tst.w   d2
    bne.b   l_2fd6e
    moveq   #$3,d0
    bra.b   l_2fd70
l_2fd6e:
    moveq   #$0,d0
l_2fd70:
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_2fd56
    movem.l -$10(a6), d2-d4
    unlk    a6
    rts
