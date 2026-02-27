; ============================================================================
; HandleEventCallback -- Copies per-player event stat bytes from one of two ROM tables into work-RAM at $FF1298 for all 89 slots, selecting or blending tables based on player-count flag
; 220 bytes | $017E70-$017F4B
; ============================================================================
HandleEventCallback:
    movem.l d2/a2-a5, -(a7)
    movea.l  #$0000C860,a5
    movea.l  #$0005F26A,a4
    movea.l  #$0005F3CE,a3
    movea.l  #$00FF1298,a2
    tst.w   ($00FF0002).l
    bne.b   l_17eb8
    clr.w   d2
l_17e96:
    move.b  $1(a4), $1(a2)
    move.b  $2(a4), $2(a2)
    move.b  $3(a4), $3(a2)
    addq.l  #$4, a4
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_17e96
    bra.w   l_17f46
l_17eb8:
    cmpi.w  #$3, ($00FF0002).l
    bne.b   l_17ee4
    clr.w   d2
l_17ec4:
    move.b  $1(a3), $1(a2)
    move.b  $2(a3), $2(a2)
    move.b  $3(a3), $3(a2)
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_17ec4
    bra.b   l_17f46
l_17ee4:
    clr.w   d2
l_17ee6:
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.b  d0, $1(a2)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.b  d0, $2(a2)
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $18(a7), a7
    move.b  d0, $3(a2)
    addq.l  #$4, a4
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_17ee6
l_17f46:
    movem.l (a7)+, d2/a2-a5
    rts
