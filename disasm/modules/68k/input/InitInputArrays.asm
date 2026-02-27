; ============================================================================
; InitInputArrays -- Dead stub (infinite loop) immediately preceding ControllerPoll entry point
; 52 bytes | $001928-$00195B
; ============================================================================
InitInputArrays:
    move.l  $42(a7), d0
l_0192c:
    bra.b   l_0192c
ControllerPoll:                                             ; $00192E
    jsr (VDPWriteZ80Path,PC)
    lea     $a(a1), a2
    moveq   #$7,d0
l_01938:
    move.w  #$ffff, (a2)
    lea     $a(a2), a2
    dbra    d0, $1938
    moveq   #$0,d0
    bsr.w ReadPortByte
    move.b  d0, (a1)
    moveq   #$1,d0
    bsr.w ReadPortByte
    move.b  d0, $1(a1)
    jsr (ReleaseZ80BusDirect,PC)
    rts
