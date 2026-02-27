; ============================================================================
; InitInfoPanel -- Initialize the info panel by calling HandleScenarioMenuSelect and ValidateMenuOption, then placing a fixed 12x10 window at (10,6) via GameCommand $1B.
; Called: 9 times.
; 64 bytes | $0238F0-$02392F
; ============================================================================
InitInfoPanel:                                                  ; $0238F0
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    move.w  d2,d0
    move.l  d0,-(sp)
    bsr.w HandleScenarioMenuSelect
    move.w  d2,d0
    move.l  d0,-(sp)
    bsr.w ValidateMenuOption
    pea     ($000700A8).l
    pea     ($000A).w
    pea     ($000C).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    move.l  (sp)+,d2
    rts
