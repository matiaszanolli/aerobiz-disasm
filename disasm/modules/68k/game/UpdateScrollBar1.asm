; ============================================================================
; UpdateScrollBar1 -- Tick scroll bar 1 frame counter; when ready, draw next animation frame
; 116 bytes | $0060A4-$006117
; ============================================================================
UpdateScrollBar1:
    movem.l d2/a2, -(a7)
    movea.l  #$00FFBDAE,a2
    addq.w  #$1, (a2)
    move.w  (a2), d0
    cmp.w   $2(a2), d0
    bcs.b   l_06112
    moveq   #$0,d0
    move.w  $4(a2), d0
    add.l   d0, d0
    add.l   $e(a2), d0
    movea.l d0, a0
    move.w  $8(a2), d2
    mulu.w  (a0), d2
    clr.l   -(a7)
    move.l  $12(a2), -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    add.l   $a(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $8(a2), d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    clr.w   (a2)
    moveq   #$0,d0
    move.w  $4(a2), d0
    addq.l  #$1, d0
    moveq   #$0,d1
    move.w  $6(a2), d1
    jsr SignedMod
    move.w  d0, $4(a2)
l_06112:
    movem.l (a7)+, d2/a2
    rts
