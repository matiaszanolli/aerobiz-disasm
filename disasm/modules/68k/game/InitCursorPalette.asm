; ============================================================================
; InitCursorPalette -- Fills the cursor CRAM area at $FF159C with 64 white ($EEE) entries and uploads them to VDP palette via GameCommand $08/$0E
; 80 bytes | $03D914-$03D963
; ============================================================================
InitCursorPalette:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF159C,a2
    clr.w   d2
l_3d920:
    move.w  #$eee, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$40, d2
    blt.b   l_3d920
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF159C).l
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    pea     ($0050).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    movem.l (a7)+, d2/a2
    rts
