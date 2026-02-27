; ============================================================================
; CmdWaitFrames -- Busy-wait for N V-blank intervals by polling a V-INT frame counter
; 38 bytes | $000724-$000749
; ============================================================================
CmdWaitFrames:
    move.b  $1(a5), d0
    btst    #$5, d0
    beq.b   l_00748
    move.l  $e(a6), d0
    moveq   #$1,d1
    bra.w   l_00744
l_00738:
    move.b  d1, $36(a5)
l_0073c:
    btst    #$0, $36(a5)
    bne.b   l_0073c
l_00744:
    dbra    d0, $738
l_00748:
    rts
