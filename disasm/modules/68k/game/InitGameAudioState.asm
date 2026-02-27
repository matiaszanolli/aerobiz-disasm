; ============================================================================
; InitGameAudioState -- Initialize sound flags, RNG seed to 33, scrollbar data, ui_active_flag, and send sound driver enable command
; 94 bytes | $00D558-$00D5B5
; ============================================================================
InitGameAudioState:
    move.w  #$101, ($00FF1274).l
    move.w  #$ffff, ($00FFBD52).l
    moveq   #$21,d0
    move.l  d0, ($00FFA7E0).l
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF159C).l
    jsr MemFillByte
    move.w  #$8001, ($00FF0A34).l
    pea     ($0038).w
    clr.l   -(a7)
    pea     ($00FFBDAC).l
    jsr MemFillByte
    pea     ($0000625C).l
    pea     ($0001).w
    pea     ($0022).w
    jsr GameCommand
    lea     $24(a7), a7
    rts
