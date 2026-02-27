; ============================================================================
; SubsysUpdate4 -- Accumulate button state from both controller records into combined input longword
; 88 bytes | $0018D0-$001927
; ============================================================================
SubsysUpdate4:
    movea.l  #$00FFF010,a5
    move.l  $be8(a5), d3
    moveq   #$0,d0
    movea.l  #$00FFFC06,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_018f8
    move.b  $4(a0), d0
    asl.l   #$8, d0
    andi.l  #$ff00, d0
    move.b  $2(a0), d0
l_018f8:
    moveq   #$0,d1
    movea.l  #$00FFFC2E,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_01916
    move.b  $4(a0), d1
    asl.l   #$8, d1
    andi.l  #$ff00, d1
    move.b  $2(a0), d1
l_01916:
    swap    d1
    or.l    d1, d0
    move.l  $be4(a5), d2
    and.l   d2, d0
    or.l    d0, d3
    move.l  d3, $be8(a5)
    rts
