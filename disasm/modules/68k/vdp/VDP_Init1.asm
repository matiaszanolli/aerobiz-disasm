; ============================================================================
; VDP_Init1 -- Clear VRAM, CRAM, and VSRAM by bulk-writing zeros via VDP data port
; 68 bytes | $001036-$001079
; ============================================================================
VDP_Init1:
    move.w  #$8f02, d0
    movea.l  #$00C00004,a6
    movea.l  #$00C00000,a5
    move.w  d0, (a6)
    moveq   #$0,d0
    move.l  #$7fff, d1
    move.l  #$40000000, (a6)
l_01056:
    move.w  d0, (a5)
    dbra    d1, $1056
    moveq   #$3F,d1
    move.l  #$c0000000, (a6)
l_01064:
    move.w  d0, (a5)
    dbra    d1, $1064
    moveq   #$27,d1
    move.l  #$40000010, (a6)
l_01072:
    move.w  d0, (a5)
    dbra    d1, $1072
    rts
