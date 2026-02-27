; ============================================================================
; CheckAlliancePermission -- Looks up range indices for two player IDs, checks alliance permission bit in $FFA7BC table; returns 1 if the alliance is permitted, 0 if blocked
; 86 bytes | $039E52-$039EA7
; ============================================================================
CheckAlliancePermission:
    movem.l d2-d5, -(a7)
    move.l  $1c(a7), d2
    move.l  $18(a7), d3
    move.l  $14(a7), d5
    moveq   #$1,d4
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$8, a7
    move.w  d0, d2
    cmp.w   d2, d3
    beq.b   l_39ea0
    moveq   #$1,d0
    lsl.b   d2, d0
    move.w  d5, d1
    mulu.w  #$7, d1
    add.w   d3, d1
    movea.l  #$00FFA7BC,a0
    and.b   (a0,d1.w), d0
    beq.b   l_39ea0
    clr.w   d4
l_39ea0:
    move.w  d4, d0
    movem.l (a7)+, d2-d5
    rts
