; ============================================================================
; CmdCopyMemory -- Copy N bytes from source address to destination address (byte loop)
; 20 bytes | $0005F8-$00060B
; ============================================================================
CmdCopyMemory:
    movea.l $e(a6), a4
    movea.l $12(a6), a3
    move.l  $16(a6), d0
l_00604:
    move.b  (a4)+, (a3)+
    subq.w  #$1, d0
    bne.b   l_00604
    rts
