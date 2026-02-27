; ============================================================================
; ValidateCharSlot -- Checks whether a character (by city index) is available for hire by a given player: scans character records for a matching hire-eligibility window and verifies the stat is not grade 3 (retired); returns 1 if valid, 0 otherwise
; 156 bytes | $02B580-$02B61B
; ============================================================================
ValidateCharSlot:
    movem.l d2-d6/a2, -(a7)
    move.l  $20(a7), d4
    move.l  $1c(a7), d6
    clr.w   d5
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   .l2b59a
    addq.l  #$3, d0
.l2b59a:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d3
    movea.l  #$00FFA6B8,a2
    clr.w   d2
.l2b5aa:
    moveq   #$0,d0
    move.b  $6(a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   .l2b5da
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  $7(a2), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l2b5da
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   .l2b5da
    moveq   #$1,d5
    bra.b   .l2b5e6
.l2b5da:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   .l2b5aa
.l2b5e6:
    cmpi.w  #$1, d5
    bne.b   .l2b614
    movea.l  #$0005F07C,a0
    move.b  (a0,d4.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    cmpi.w  #$3, d0
    bne.b   .l2b614
    clr.w   d5
.l2b614:
    move.w  d5, d0
    movem.l (a7)+, d2-d6/a2
    rts
