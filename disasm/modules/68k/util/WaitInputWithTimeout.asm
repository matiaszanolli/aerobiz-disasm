; ============================================================================
; WaitInputWithTimeout -- Polls for any input matching the caller's button mask while looping a GameCommand timeout ticker; once a matching button is pressed or the ticker expires, resets the ticker tile and returns the button state.
; 128 bytes | $02A6B8-$02A737
; ============================================================================
WaitInputWithTimeout:
    link    a6,#-$4
    movem.l d2-d4, -(a7)
    move.l  $10(a6), d3
    move.w  #$88, -$2(a6)
    pea     ($0001).w
    move.w  $a(a6), d4
    ext.l   d4
    lsl.l   #$4, d4
    move.w  $e(a6), d0
    ext.l   d0
    add.l   d0, d4
    move.l  d4, -(a7)
    pea     -$2(a6)
    jsr DisplaySetup
    lea     $c(a7), a7
l_2a6ee:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d2
    and.w   d3, d0
    bne.b   l_2a716
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    tst.w   d2
    beq.b   l_2a6ee
l_2a716:
    move.w  #$666, -$2(a6)
    pea     ($0001).w
    move.l  d4, -(a7)
    pea     -$2(a6)
    jsr DisplaySetup
    move.w  d2, d0
    movem.l -$10(a6), d2-d4
    unlk    a6
    rts
