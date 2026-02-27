; ============================================================================
; InitRouteFieldC -- Zero all $FF09CE route field C slot entries and reset the $FF09D6 active route selection word to $FFFF.
; 74 bytes | $02148C-$0214D5
; ============================================================================
InitRouteFieldC:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09CE,a2
    clr.w   d2
l_21498:
    cmpi.b  #$ff, (a2)
    beq.b   l_214b4
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.b  #$ff, (a2)
l_214b4:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_21498
    cmpi.w  #$ff, ($00FF09D6).l
    beq.b   l_214d0
    move.w  #$ff, ($00FF09D6).l
l_214d0:
    movem.l (a7)+, d2/a2
    rts
