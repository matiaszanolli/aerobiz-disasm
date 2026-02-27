; ============================================================================
; UpdateEventSchedule -- Scan 55 scheduled events from ROM table, call WriteEventField for each whose trigger frame has been reached
; 62 bytes | $00D20E-$00D24B
; ============================================================================
UpdateEventSchedule:
    movem.l d2-d3/a2, -(a7)
    movea.l  #$0005FAB6,a2
    clr.w   d2
.l0d21a:
    move.w  (a2), d3
    lsl.w   #$2, d3
    add.w   $2(a2), d3
    addi.w  #$e174, d3
    cmp.w   ($00FF0006).l, d3
    bgt.b   .l0d23c
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr WriteEventField
    addq.l  #$4, a7
.l0d23c:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$37, d2
    bcs.b   .l0d21a
    movem.l (a7)+, d2-d3/a2
    rts
