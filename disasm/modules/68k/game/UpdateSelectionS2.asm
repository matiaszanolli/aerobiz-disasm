; ============================================================================
; UpdateSelectionS2 -- Rebuilds the availability flags at $FF17C8: clears the buffer, scans 16 character records for those within the current year's age window, marks each available slot, and records the first available index in $FFBD5A
; 134 bytes | $02CAF6-$02CB7B
; ============================================================================
UpdateSelectionS2:
    movem.l d2-d3/a2-a4, -(a7)
    movea.l  #$00FFBD5A,a4
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   .l2cb0c
    addq.l  #$3, d0
.l2cb0c:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d3
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF17C8).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FFA6B8,a2
    movea.l  #$00FF17C8,a3
    move.w  #$ff, (a4)
    clr.w   d2
.l2cb3c:
    moveq   #$0,d0
    move.b  $6(a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   .l2cb68
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  $7(a2), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l2cb68
    move.w  #$1, (a3)
    cmpi.w  #$ff, (a4)
    bne.b   .l2cb68
    move.w  d2, (a4)
.l2cb68:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   .l2cb3c
    movem.l (a7)+, d2-d3/a2-a4
    rts
