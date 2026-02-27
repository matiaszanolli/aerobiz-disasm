; ============================================================================
; CmdTestVRAM -- Write test pattern bytes to a Z80-bus-mapped address and read back to detect errors
; 54 bytes | $0007D8-$00080D
; ============================================================================
CmdTestVRAM:
    movea.l $e(a6), a3
CmdTestVRAM_WithA3:                                          ; $0007DC
    move.w  sr, -(a7)
    ori.w   #$700, sr
    bsr.w VDPWriteZ80Path
    lea     $80e(pc), a4
    move.b  (a4), $6(a3)
    moveq   #$0,d0
    moveq   #$8,d1
l_007f2:
    move.b  (a4)+, (a3)
    nop
    nop
    move.b  (a3), d2
    and.b   (a4)+, d2
    beq.b   l_00800
    or.b    d1, d0
l_00800:
    lsr.b   #$1, d1
    bne.b   l_007f2
    jsr (ReleaseZ80BusDirect,PC)
    nop
    move.w  (a7)+, sr
    rts

    dc.w    $400C; $00080E
    dc.w    $4003,$000C,$0003; $000810

; === Translated block $000816-$000D64 ===
; 16 functions, 1358 bytes
