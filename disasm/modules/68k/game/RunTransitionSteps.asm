; ============================================================================
; RunTransitionSteps -- Run a multi-step transition animation sequence when flight_active is set: two display step calls plus two init calls with a 6-frame wait.
; Called: ?? times.
; 54 bytes | $023D80-$023DB5
; ============================================================================
RunTransitionSteps:                                                  ; $023D80
    move.l  a2,-(sp)
    movea.l #$00023dc6,a2
    tst.w   ($00FF000A).l
    beq.b   .l23db2
    jsr     (a2)
    dc.w    $4eba,$0070                                 ; jsr $023E04
    nop
    jsr     (a2)
    dc.w    $4eba,$0068                                 ; jsr $023E04
    nop
    pea     ($0006).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    jsr     (a2)
.l23db2:                                                ; $023DB2
    movea.l (sp)+,a2
    rts
