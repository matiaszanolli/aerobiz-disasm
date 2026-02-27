; ============================================================================
; ProcessPlayerSelectInput -- Assign hub cities to all 4 player slots (human via UI, AI via random valid selection), build name strings
; 420 bytes | $00B042-$00B1E5
; ============================================================================
ProcessPlayerSelectInput:
    movem.l d2-d5/a2-a4, -(a7)
    movea.l  #$00000D64,a3
    movea.l  #$0001D520,a4
    move.l  #$22889011, d5
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FF08EC).l
    jsr     (a4)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FFA6A0).l
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF00A8).l
    jsr     (a4)
    lea     $24(a7), a7
    moveq   #$0,d4
    movea.l  #$00FF0018,a2
    clr.w   d3
.l0b090:
    cmpi.b  #$1, (a2)
    bne.b   .l0b0d6
    move.l  d4, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunModelSelectUI,PC)
    nop
    move.w  d0, d2
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $24(a7), a7
    jsr ResourceUnload
    bra.w   .l0b15a
.l0b0d6:
    tst.w   d3
    bne.b   .l0b112
    jsr ResourceLoad
    jsr ClearBothPlanes
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $1c(a7), a7
    jsr ResourceUnload
.l0b112:
    pea     ($001F).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d2
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.b   .l0b112
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d5, d0
    beq.b   .l0b112
    move.b  d2, $1(a2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (WaitForKeyPress,PC)
    nop
    addq.l  #$4, a7
    move.b  d0, $1(a2)
    move.l  d0, d2
    andi.l  #$ff, d2
.l0b15a:
    pea     ($0007).w
    bsr.w PlacePlayerNameLabels
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  d1, (a0,d0.w)
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  d1, (a0,d0.w)
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    or.l    d0, d4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EAAC,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    jsr StringConcat
    lea     $14(a7), a7
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   .l0b090
    jsr ResourceLoad
    moveq   #$1,d0
    movem.l (a7)+, d2-d5/a2-a4
    rts
