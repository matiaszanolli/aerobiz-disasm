; ============================================================================
; DispatchScrollUpdates -- Check active scroll flags and call UpdateScrollBar1/2, UpdateScrollCounters, TickAnimCounter
; 60 bytes | $00625C-$006297
; ============================================================================
DispatchScrollUpdates:
    move.l  a2, -(a7)
    movea.l  #$00FFBDAC,a2
    move.w  (a2), d0
    andi.w  #$1, d0
    beq.b   l_06270
    bsr.w UpdateScrollBar1
l_06270:
    move.w  (a2), d0
    andi.w  #$2, d0
    beq.b   l_0627c
    bsr.w UpdateScrollBar2
l_0627c:
    move.w  (a2), d0
    andi.w  #$4, d0
    beq.b   l_06288
    bsr.w UpdateScrollCounters
l_06288:
    move.w  (a2), d0
    andi.w  #$8, d0
    beq.b   l_06294
    bsr.w TickAnimCounter
l_06294:
    movea.l (a7)+, a2
    rts
