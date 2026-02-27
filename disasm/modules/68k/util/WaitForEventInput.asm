; ============================================================================
; WaitForEventInput -- Loop calling DisplayEventChoice until player confirms; if assignment flag set, also run RunAssignmentUI
; 64 bytes | $00D24C-$00D28B
; ============================================================================
WaitForEventInput:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
.l0d254:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DisplayEventChoice,PC)
    nop
    addq.l  #$4, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   .l0d270
    moveq   #$1,d0
    bra.b   .l0d286
.l0d270:
    cmpi.w  #$1, d2
    bne.b   .l0d254
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RunAssignmentUI
    addq.l  #$4, a7
    bra.b   .l0d254
.l0d286:
    movem.l (a7)+, d2-d3
    rts
