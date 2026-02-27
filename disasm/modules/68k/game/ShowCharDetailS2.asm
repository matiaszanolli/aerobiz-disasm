; ============================================================================
; ShowCharDetailS2 -- Draws a character detail overlay for a player's character: dispatches via jump table on the character status byte to render appropriate text panels (name, year label, or sprite/score lines), then awaits menu selection
; 412 bytes | $02B888-$02BA23
; ============================================================================
ShowCharDetailS2:
    link    a6,#-$50
    movem.l d2/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0001183A,a3
    movea.l  #$00047C40,a4
    lea     -$50(a6), a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.b  #$64, $22(a2)
    bcc.b   l_2b8fa
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0011).w
    jsr MenuSelectEntry
    lea     $30(a7), a7
l_2b8fa:
    moveq   #$0,d0
    move.b  $22(a2), d0
    moveq   #$60,d1
    sub.l   d1, d0
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.w   l_2ba08
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0080
    dc.w    $0036
    dc.w    $0020
    dc.w    $0008
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  ($00047C40).l, -(a7)
    bra.w   l_2b9fc
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $4(a4), -(a7)
    bra.w   l_2b9fc
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $8(a4), -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a5, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $c(a4), -(a7)
    bra.b   l_2b9fc
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  $10(a4), -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a5, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $14(a4), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $18(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.l  $18(a4), -(a7)
l_2b9fc:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $18(a7), a7
l_2ba08:
    cmpi.b  #$64, $22(a2)
    bcc.b   l_2ba1a
    pea     ($0007).w
    jsr SelectMenuItem
l_2ba1a:
    movem.l -$64(a6), d2/a2-a5
    unlk    a6
    rts
