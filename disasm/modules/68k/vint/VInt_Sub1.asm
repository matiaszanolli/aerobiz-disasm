; ============================================================================
; VInt_Sub1 -- V-INT animation tick: DMA next animation frame to CRAM and advance frame/delay counters
; 164 bytes | $000C38-$000CDB
; ============================================================================
VInt_Sub1:
    moveq   #$0,d0
    move.w  $be2(a5), d0
    bne.w   l_00cc6
    moveq   #$0,d0
    move.b  $bd6(a5), d0
    moveq   #$0,d1
    move.l  $bdc(a5), d1
    move.l  d0, d2
    lsl.w   #$1, d2
    moveq   #$0,d3
    move.w  $be0(a5), d3
    mulu.w  d3, d2
    add.l   d2, d1
    moveq   #$0,d2
    move.b  $bd5(a5), d2
    lsl.l   #$1, d2
    move.l  d2, d3
    move.l  d2, d4
    lsl.l   #$2, d3
    andi.l  #$30000, d3
    swap    d3
    swap    d4
    andi.l  #$3fff0000, d4
    or.l    d4, d3
    ori.l   #$c0000080, d3
    move.b  #$2, $1d(a5)
    move.w  d0, $1e(a5)
    move.b  #$1, $37(a5)
    move.l  d1, $20(a5)
    move.l  d2, $24(a5)
    move.l  d3, $42(a5)
    moveq   #$0,d0
    movea.l  #$00C00004,a0
    move.w  (a0), d0
    btst    #$3, d0
    beq.b   l_00cda
    bsr.w TriggerVDPDMA
    moveq   #$0,d0
    move.w  $be0(a5), d0
    addq.w  #$1, d0
    cmp.w   $bd8(a5), d0
    bne.b   l_00cc2
    moveq   #$0,d0
l_00cc2:
    move.w  d0, $be0(a5)
l_00cc6:
    moveq   #$0,d0
    move.w  $be2(a5), d0
    addq.w  #$1, d0
    cmp.w   $bda(a5), d0
    bne.b   l_00cd6
    moveq   #$0,d0
l_00cd6:
    move.w  d0, $be2(a5)
l_00cda:
    rts
