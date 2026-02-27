; ============================================================================
; InitRouteFieldB -- Reset the $FF09CA route field B slot, optionally calling InitCharRecord first if the slot has an active flag.
; 70 bytes | $021446-$02148B
; ============================================================================
InitRouteFieldB:
    move.l  a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21488
    tst.b   $2(a2)
    beq.b   l_21472
    clr.b   $2(a2)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
l_21472:
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.b  #$ff, (a2)
l_21488:
    movea.l (a7)+, a2
    rts
