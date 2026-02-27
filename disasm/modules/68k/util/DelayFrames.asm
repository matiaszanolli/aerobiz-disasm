; ============================================================================
; DelayFrames -- Busy-waits for N video frames by calling GameCommand $0E (wait-frame) in a countdown loop; returns 0
; 36 bytes | $03B36A-$03B38D
; ============================================================================
DelayFrames:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
l_3b370:
    tst.w   d2
    beq.b   l_3b388
    subq.w  #$1, d2
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.b   l_3b370
l_3b388:
    moveq   #$0,d0
    move.l  (a7)+, d2
    rts
