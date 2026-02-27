; ============================================================================
; HandleScenarioMenuSelect -- Set up tile display for a scenario menu selection by computing index mod 20, looking up display address from $0004825C, and calling DisplaySetup.
; 58 bytes | $02385C-$023895
; ============================================================================
HandleScenarioMenuSelect:
    link    a6,#$0
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    moveq   #$14,d1
    jsr SignedMod
    move.w  d0, d2
    pea     ($0010).w
    pea     ($0030).w
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0004825C,a0
    move.l  (a0,d0.w), -(a7)
    jsr DisplaySetup
    move.l  -$4(a6), d2
    unlk    a6
    rts
