; ============================================================================
; CheckMatchSlots -- Returns 1 if all 4 player match slots at $FF8804 are filled (none equal $FF), else 0
; Called: ?? times.
; 58 bytes | $038544-$03857D
; ============================================================================
CheckMatchSlots:                                                  ; $038544
    movem.l d2-d3,-(sp)
    move.l  $000c(sp),d3
    moveq   #$1,d1
    clr.w   d2
.l38550:                                                ; $038550
    cmp.w   d3,d2
    beq.b   .l38566
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$00ff8804,a0
    cmpi.w  #$ff,(a0,d0.w)
    bne.b   .l3856e
.l38566:                                                ; $038566
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l38550
.l3856e:                                                ; $03856E
    cmpi.w  #$4,d2
    blt.b   .l38576
    clr.w   d1
.l38576:                                                ; $038576
    move.w  d1,d0
    movem.l (sp)+,d2-d3
    rts
; === Translated block $03857E-$03A5A8 ===
; 8 functions, 8234 bytes
