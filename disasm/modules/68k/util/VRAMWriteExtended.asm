; ============================================================================
; VRAMWriteExtended -- Set VDP address via control port, merge D0 byte into existing word and write back
; 82 bytes | $0042F0-$004341
; ============================================================================
VRAMWriteExtended:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  a0, d6
    move.l  d6, d7
    andi.l  #$fffe, d6
    move.l  d6, d5
    lsl.l   #$2, d5
    swap    d5
    andi.l  #$3, d5
    andi.l  #$3fff, d6
    swap    d6
    or.l    d5, d6
    move.l  d6, (a6)
    move.w  (a5), d5
    btst    #$0, d7
    bne.b   l_0432a
    lsl.w   #$8, d0
    andi.w  #$ff, d5
    bra.w   l_04332
l_0432a:
    andi.w  #$ff, d0
    andi.w  #$ff00, d5
l_04332:
    or.w    d0, d5
    ori.l   #$40000000, d6
    move.l  d6, (a6)
    move.w  d5, (a5)
    move.w  (a7)+, sr
    rts
