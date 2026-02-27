; ============================================================================
; ProcessAirportTransact -- Unpack save buffer fields into work RAM regions , , , , return end pointer
; 126 bytes | $00F008-$00F085
; ============================================================================
ProcessAirportTransact:
    movem.l a2-a3, -(a7)
    movea.l $c(a7), a2
    movea.l  #$0001D538,a3
    pea     ($0008).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09C2).l
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a2
    pea     ($0004).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09CA).l
    clr.l   -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    addq.l  #$4, a2
    pea     ($0008).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09CE).l
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a2
    pea     ($0002).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09D6).l
    clr.l   -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    addq.l  #$2, a2
    move.l  a2, d0
    movem.l (a7)+, a2-a3
    rts
