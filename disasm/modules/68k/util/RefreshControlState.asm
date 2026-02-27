; ============================================================================
; RefreshControlState -- Refreshes the aircraft selection UI state buffers ($FF17E8, $FF1584, $FF880C) from the availability map ($FF17C8): marks available slots in all three arrays, clears entries for retired (grade-3) characters, and forces special slots to available
; 286 bytes | $02CB7C-$02CC99
; ============================================================================
RefreshControlState:
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $20(a7), d4
    movea.l  #$00FF1584,a4
    movea.l  #$00FFBD5A,a5
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($00FF17E8).l
    jsr MemFillByte
    pea     ($0018).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    pea     ($0016).w
    pea     ($00FF).w
    pea     ($00FF880C).l
    jsr MemFillByte
    lea     $24(a7), a7
    move.w  (a5), d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  (a5), d0
    add.w   d0, d0
    movea.l  #$00FF17C8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  (a5), d2
    bra.b   .l2cc40
.l2cbee:
    cmpi.w  #$1, (a3)
    bne.b   .l2cc38
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF17E8,a0
    move.w  #$1, (a0,d0.w)
    moveq   #$0,d0
    move.b  (a2), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$1, (a4,a0.l)
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF880C,a0
    cmpi.w  #$ffff, (a0,d0.w)
    bne.b   .l2cc38
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$00FF880C,a0
    move.w  d2, (a0,d0.w)
.l2cc38:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
.l2cc40:
    cmpi.w  #$10, d2
    bcs.b   .l2cbee
    clr.w   d2
.l2cc48:
    movea.l  #$0005F07C,a0
    move.b  (a0,d2.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$3, d3
    bne.b   .l2cc7e
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a4,a0.l)
.l2cc7e:
    addq.w  #$1, d2
    cmpi.w  #$b, d2
    bcs.b   .l2cc48
    move.w  #$1, ($00FF17FE).l
    move.w  #$1, $16(a4)
    movem.l (a7)+, d2-d4/a2-a5
    rts
