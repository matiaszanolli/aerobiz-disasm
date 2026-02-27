; ============================================================================
; FinalizeScenarioScreen -- Place scenario screen tile elements from a $FF-terminated position list by calling TilePlacement and GameCommand $E per entry for end-state display.
; 116 bytes | $0239C0-$023A33
; ============================================================================
FinalizeScenarioScreen:
    dc.w    $0018,$246F                     ; ori.b #$6f,(a0)+ - high byte $24 is compiler junk
    dc.w    $0014,$4242                     ; ori.b #$42,(a4) - high byte $42 is compiler junk
    bra.b   l_23a24
l_239ca:
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($076D).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.l  #$1, a2
    addq.w  #$1, d2
l_23a24:
    cmp.w   d3, d2
    bcc.b   l_23a2e
    cmpi.b  #$ff, (a2)
    bne.b   l_239ca
l_23a2e:
    movem.l (a7)+, d2-d3/a2-a3
    rts
