; ============================================================================
; DisplayRouteEvent -- Display the event graphic for a character's active route event in a 2x2 tile arrangement if the character has an associated event.
; 276 bytes | $0212A2-$0213B5
; ============================================================================
DisplayRouteEvent:
    movem.l d2/a2-a3, -(a7)
    move.l  $10(a7), d2
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    movea.l  #$0005F9BE,a0
    move.b  (a0,d2.w), d0
    andi.l  #$ff, d0
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.w   l_213b0
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0009C808,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($0030).w
    pea     ($01AB).w
    pea     ($00FF899C).l
    jsr CmdPlaceTile2
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0028).w
    pea     ($0038).w
    pea     ($000A).w
    pea     ($01AB).w
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0028).w
    pea     ($0050).w
    pea     ($000C).w
    pea     ($01B7).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $2c(a7), a7
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0048).w
    pea     ($0038).w
    pea     ($000E).w
    pea     ($01C3).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($6000).w
    pea     ($0004).w
    pea     ($0003).w
    pea     ($0048).w
    pea     ($0050).w
    pea     ($0010).w
    pea     ($01CF).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
l_213b0:
    movem.l (a7)+, d2/a2-a3
    rts
