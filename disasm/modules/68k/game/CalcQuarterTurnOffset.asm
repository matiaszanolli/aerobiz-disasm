; ============================================================================
; CalcQuarterTurnOffset -- Returns elapsed turns since game start (turn counter minus quarter * 60)
; 22 bytes | $0361DA-$0361EF
; ============================================================================
CalcQuarterTurnOffset:
    move.w  ($00FF0002).l, d0
    mulu.w  #$3c, d0
    move.w  ($00FF0006).l, d1
    sub.w   d0, d1
    move.w  d1, d0
    rts
