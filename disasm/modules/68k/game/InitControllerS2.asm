; ============================================================================
; InitControllerS2 -- Sets up the player-select UI control bounds in the $FF1480 array only for player counts > 2: writes fixed range ($15/$17) and step ($1/$3) values used by the selection cursor
; 54 bytes | $02CC9A-$02CCCF
; ============================================================================
InitControllerS2:
    movea.l  #$00FF1480,a1
    movea.l  #$00FF0002,a0
    tst.w   (a0)
    beq.b   .l2ccce
    cmpi.w  #$1, (a0)
    beq.b   .l2ccce
    cmpi.w  #$2, (a0)
    beq.b   .l2ccce
    move.w  #$15, $10(a1)
    move.w  #$1, $12(a1)
    move.w  #$17, $14(a1)
    move.w  #$3, $16(a1)
.l2ccce:
    rts
