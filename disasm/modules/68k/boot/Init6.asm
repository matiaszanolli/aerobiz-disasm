; ============================================================================
; Init6 -- Initialize scroll/viewport bounds and display limit variables in work RAM
; 74 bytes | $001090-$0010D9
; ============================================================================
Init6:
    movea.l  #$00FFF010,a0
    move.w  #$0, $c52(a0)
    move.w  #$0, $c54(a0)
    move.w  #$ff, $c56(a0)
    move.w  #$df, $c58(a0)
    move.w  #$0, $c5a(a0)
    move.w  #$80, $c5c(a0)
    move.w  #$70, $c5e(a0)
    move.w  #$0, $c60(a0)
    move.b  #$0, $c62(a0)
    move.b  #$0, $c6c(a0)
    move.w  #$20, $c6e(a0)
    rts
