; ============================================================================
; ControllerRead -- Animate character sprites via DMA by cycling through frames in the char table
; 174 bytes | $000B42-$000BEF
; ============================================================================
ControllerRead:
    moveq   #$0,d0
    move.w  $302(a5), d0
    subq.w  #$1, d0
    bne.w   l_00bea
    bmi.w   l_00bea
    moveq   #$0,d1
    move.b  $2ff(a5), d1
    move.l  d1, d3
    cmp.b   $2fe(a5), d3
    bne.b   l_00b64
    moveq   #$0,d3
    bra.b   l_00b66
l_00b64:
    addq.w  #$1, d3
l_00b66:
    move.b  d3, $2ff(a5)
    lsl.l   #$5, d1
    moveq   #$0,d3
    move.w  $304(a5), d0
    move.w  $2fc(a5), d2
    and.w   d0, d2
    beq.b   l_00be6
    move.l  #$fff336, d4
    add.l   d1, d4
    movea.l  #$00FFF316,a2
    moveq   #$F,d0
l_00b8a:
    lsr.w   #$1, d2
    bcc.b   l_00bda
    move.b  #$2, $1d(a5)
    move.w  #$10, $1e(a5)
    move.b  #$0, $37(a5)
    move.l  d4, $20(a5)
    moveq   #$0,d5
    move.w  (a2,d3.w), d5
    move.l  d5, $24(a5)
    move.l  d5, d6
    lsl.l   #$2, d5
    andi.l  #$30000, d5
    swap    d5
    swap    d6
    andi.l  #$3fff0000, d6
    or.l    d6, d5
    ori.l   #$40000080, d5
    move.l  d5, $42(a5)
    movem.l d0-d6/a2, -(a7)
    bsr.w TriggerVDPDMA
    movem.l (a7)+, d0-d6/a2
l_00bda:
    addq.w  #$2, d3
    addi.l  #$80, d4
    dbra    d0, $B8A
l_00be6:
    move.w  $300(a5), d0
l_00bea:
    move.w  d0, $302(a5)
    rts
