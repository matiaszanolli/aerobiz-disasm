; ============================================================================
; ProcessCrewSalary -- Checks whether the current player can afford crew: shows a bankruptcy dialog if funds are negative; if all 5 route salary entries are maxed shows an over-budget dialog; returns 1 if OK to proceed, 0 if blocked
; 138 bytes | $02D2EC-$02D375
; ============================================================================
ProcessCrewSalary:
    movem.l d2-d3/a2, -(a7)
    move.l  $10(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.l   $6(a2)
    bge.b   .l2d32e
    clr.w   d2
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004847A).l, -(a7)
.l2d31c:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    bra.b   .l2d36e
.l2d32e:
    move.w  d3, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l2d342:
    cmpi.b  #$a, $1(a2)
    bcs.b   .l2d354
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   .l2d342
.l2d354:
    cmpi.w  #$5, d2
    bne.b   .l2d36c
    clr.w   d2
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004847E).l, -(a7)
    bra.b   .l2d31c
.l2d36c:
    moveq   #$1,d2
.l2d36e:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2
    rts
