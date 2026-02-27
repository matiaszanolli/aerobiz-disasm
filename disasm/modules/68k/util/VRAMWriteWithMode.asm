; ============================================================================
; VRAMWriteWithMode -- Set VDP VRAM address via control port (A6), read one byte from data port (A5)
; 54 bytes | $0042BA-$0042EF
; ============================================================================
VRAMWriteWithMode:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  a2, d6
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
    move.w  (a5), d0
    btst    #$0, d7
    bne.b   l_042ec
    lsr.w   #$8, d0
l_042ec:
    move.w  (a7)+, sr
    rts
