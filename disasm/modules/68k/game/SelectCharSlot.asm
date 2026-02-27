; ============================================================================
; SelectCharSlot -- Selects and adds a character to the team: finds the first valid free slot via FindAvailableSlot, then repeatedly calls AddCharToTeam, UpdateCharDisplayS2, and CheckCharLimit until no more slots are available or the limit is hit
; 160 bytes | $02E2D4-$02E373
; ============================================================================
SelectCharSlot:
    movem.l d2-d5, -(a7)
    move.l  $14(a7), d4
    moveq   #$1,d3
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (FindAvailableSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$10, d5
    bcc.b   .l2e36e
.l2e2fe:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (FindAvailableSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.b   .l2e36e
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (AddCharToTeam,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    move.w  d2, d5
    clr.w   d3
    cmpi.w  #$10, d2
    bcc.b   .l2e36e
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateCharDisplayS2,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d2
    beq.b   .l2e2fe
    jsr (CheckCharLimit,PC)
    nop
    cmpi.w  #$1, d0
    beq.b   .l2e2fe
.l2e36e:
    movem.l (a7)+, d2-d5
    rts
