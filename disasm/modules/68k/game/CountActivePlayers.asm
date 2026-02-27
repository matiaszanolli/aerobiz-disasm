; ============================================================================
; CountActivePlayers -- Iterates the four player records and returns in D0 the count of players whose active flag (byte 0) is set to 1.
; Called: ?? times.
; 38 bytes | $027AA4-$027AC9
; ============================================================================
CountActivePlayers:                                                  ; $027AA4
    move.l  d2,-(sp)
    clr.w   d1
    movea.l #$00ff0018,a0
    clr.w   d2
.l27ab0:                                                ; $027AB0
    cmpi.b  #$01,(a0)
    bne.b   .l27ab8
    addq.w  #$1,d1
.l27ab8:                                                ; $027AB8
    moveq   #$24,d0
    adda.l  d0,a0
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.b   .l27ab0
    move.w  d1,d0
    move.l  (sp)+,d2
    rts
    dc.w    $48E7,$3E30,$282F                                ; $027ACA
; === Translated block $027AD0-$027F18 ===
; 2 functions, 1096 bytes
