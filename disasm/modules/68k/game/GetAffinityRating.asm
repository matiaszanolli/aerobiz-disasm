; ============================================================================
; GetAffinityRating -- Sets affinity-quality bytes (9/A/B) based on player wealth vs target thresholds
; 178 bytes | $035A5E-$035B0F
; ============================================================================
GetAffinityRating:
    movem.l d2/a2-a4, -(a7)
    move.l  $14(a7), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03F0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    cmpi.l  #$3e8, $6(a3)
    ble.b   l_35ade
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr CalcPlayerWealth
    addq.l  #$4, a7
    add.l   $e(a3), d0
    cmp.l   $a(a3), d0
    bcc.b   l_35aca
    clr.b   $9(a2)
    clr.b   $a(a2)
    clr.b   $b(a2)
    bra.b   l_35b0a
l_35aca:
    move.b  #$1, $9(a2)
    move.b  #$1, $a(a2)
    move.b  #$1, $b(a2)
    bra.b   l_35b0a
l_35ade:
    cmpi.b  #$5a, (a4)
    bls.b   l_35af8
    move.b  #$3, $9(a2)
    move.b  #$3, $a(a2)
    move.b  #$3, $b(a2)
    bra.b   l_35b0a
l_35af8:
    move.b  #$2, $9(a2)
    move.b  #$2, $a(a2)
    move.b  #$2, $b(a2)
l_35b0a:
    movem.l (a7)+, d2/a2-a4
    rts
