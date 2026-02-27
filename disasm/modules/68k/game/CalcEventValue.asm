; ============================================================================
; CalcEventValue -- Compute an event's numeric value from $0005FA2A: return byte $2 directly if set, otherwise calculate from aggregate player route data.
; Called: ?? times.
; 100 bytes | $022554-$0225B7
; ============================================================================
CalcEventValue:                                                  ; $022554
    movem.l d2-d4/a2,-(sp)
    move.l  $0014(sp),d4
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005fa2a,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    cmpi.b  #$ff,$0002(a2)
    beq.b   .l2257c
    moveq   #$0,d0
    move.b  $0002(a2),d0
    bra.b   .l225b2
.l2257c:                                                ; $02257C
    movea.l #$00ff0018,a2
    clr.w   d3
    clr.w   d2
.l22586:                                                ; $022586
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d3
    moveq   #$24,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l22586
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,d1
    lsl.l   #$3,d0
    sub.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    moveq   #$20,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
.l225b2:                                                ; $0225B2
    movem.l (sp)+,d2-d4/a2
    rts
