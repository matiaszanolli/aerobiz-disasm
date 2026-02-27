; ============================================================================
; CmdScanStatusArray -- Scan 8 controller status entries at $FFFC06 and return bitmask of active slots
; 32 bytes | $000F22-$000F41
; ============================================================================
CmdScanStatusArray:
    moveq   #$0,d0
    movea.l  #$00FFFC06,a2
    moveq   #$7,d5
l_00f2c:
    cmpi.w  #$2, (a2)
    bne.b   l_00f36
    bset    #$0, d0
l_00f36:
    adda.l  #$a, a2
    dbra    d5, $F2C
    rts
