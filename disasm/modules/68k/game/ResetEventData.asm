; ============================================================================
; ResetEventData -- Copies the initial event stat bytes for a single slot index from the appropriate ROM table into work-RAM, selecting or blending between two source tables based on player count
; 208 bytes | $017F4C-$01801B
; ============================================================================
ResetEventData:
    movem.l d2/a2-a5, -(a7)
    move.l  $18(a7), d2
    movea.l  #$0000C860,a5
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F26A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F3CE,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.w   ($00FF0002).l
    bne.b   l_17fa6
    move.b  $1(a4), $1(a2)
    move.b  $2(a4), $2(a2)
    move.b  $3(a4), $3(a2)
    bra.b   l_18016
l_17fa6:
    cmpi.w  #$3, ($00FF0002).l
    bne.b   l_17fc4
    move.b  $1(a3), $1(a2)
    move.b  $2(a3), $2(a2)
    move.b  $3(a3), $3(a2)
    bra.b   l_18016
l_17fc4:
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
l_18016:
    movem.l (a7)+, d2/a2-a5
    rts
