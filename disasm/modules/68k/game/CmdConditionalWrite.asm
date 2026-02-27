; ============================================================================
; CmdConditionalWrite -- Write arg to work RAM word unless arg == 2; always return stored value
; 24 bytes | $000D24-$000D3B
; ============================================================================
CmdConditionalWrite:
    move.l  $e(a6), d0
    cmpi.l  #$2, d0
    beq.b   l_00d34
    move.w  d0, $c70(a5)
l_00d34:
    moveq   #$0,d0
    move.w  $c70(a5), d0
    rts
