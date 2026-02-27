; ============================================================================
; VDP_Init2 -- Zero sprite table buffer in RAM and reinitialize sprite links
; 26 bytes | $00101C-$001035
; ============================================================================
VDP_Init2:
    movea.l  #$00FFF08A,a6
    movea.l a6, a5
    moveq   #$0,d0
    moveq   #$4F,d1
l_01028:
    move.l  d0, (a6)+
    move.l  d0, (a6)+
    dbra    d1, $1028
    jsr (InitSpriteLinks,PC)
    rts
