; ============================================================================
; ProcessCharSelectInput -- Sets background, draws dual panels, calls BrowseMapPages to pick a city, then calls PackSaveState and SignExtendAndCall on the selection
; 196 bytes | $0174A2-$017565
; ============================================================================
ProcessCharSelectInput:
    movem.l d2/a2, -(a7)
    movea.l  #$00000D64,a2
    clr.l   -(a7)
    jsr CmdSetBackground
    jsr (DrawDualPanels,PC)
    nop
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0001).w
    jsr (BrowseMapPages,PC)
    nop
    lea     $18(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_17548
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PackSaveState
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (SignExtendAndCall,PC)
    nop
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0018).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0018).w
    pea     ($0002).w
    jsr SetTextWindow
    pea     ($0003F950).l
    jsr PrintfWide
    pea     ($003C).w
    pea     ($000E).w
    jsr     (a2)
    lea     $1c(a7), a7
l_17548:
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $10(a7), a7
    movem.l (a7)+, d2/a2
    rts
