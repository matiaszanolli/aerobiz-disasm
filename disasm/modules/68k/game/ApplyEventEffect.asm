; ============================================================================
; ApplyEventEffect -- Arms a slot event: if the slot is idle and its type index is below 9, sets the countdown byte to (type*3+3) to schedule the event
; 46 bytes | $017E42-$017E6F
; ============================================================================
ApplyEventEffect:
    link    a6,#$0
    move.w  $a(a6), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.b   $1(a1)
    bne.b   l_17e6c
    cmpi.b  #$9, (a1)
    bcc.b   l_17e6c
    move.b  (a1), d0
    addq.b  #$3, d0
    move.b  d0, $1(a1)
l_17e6c:
    unlk    a6
    rts
