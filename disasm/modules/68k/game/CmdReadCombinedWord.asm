; ============================================================================
; CmdReadCombinedWord -- Pack two adjacent work RAM bytes into a 16-bit value (high byte | low byte)
; 16 bytes | $000EAA-$000EB9
; ============================================================================
CmdReadCombinedWord:
    moveq   #$0,d0
    move.b  $c61(a5), d0
    asl.l   #$8, d0
    asl.l   #$8, d0
    or.b    $c60(a5), d0
    rts
