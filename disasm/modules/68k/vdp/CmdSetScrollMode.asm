; ============================================================================
; CmdSetScrollMode -- Set one of five VDP scroll/plane registers by index, caching value in work RAM
; 158 bytes | $0003BC-$000459
; ============================================================================
CmdSetScrollMode:
    move.l  $12(a6), d0
    move.l  $e(a6), d1
    bne.b   l_003e0
    move.w  d0, $38(a5)
    lsr.w   #$8, d0
    lsr.w   #$2, d0
    ori.w   #$8200, d0
    andi.b  #$38, d0
    move.w  d0, ($00C00004).l
    bra.w   l_00458
l_003e0:
    cmpi.b  #$1, d1
    bne.b   l_00400
    move.w  d0, $3a(a5)
    lsr.w   #$8, d0
    lsr.w   #$5, d0
    ori.w   #$8400, d0
    andi.b  #$7, d0
    move.w  d0, ($00C00004).l
    bra.w   l_00458
l_00400:
    cmpi.b  #$2, d1
    bne.b   l_0041e
    move.w  d0, $3c(a5)
    lsr.w   #$8, d0
    lsr.w   #$2, d0
    ori.w   #$8300, d0
    andi.b  #$3e, d0
    move.w  d0, ($00C00004).l
    bra.b   l_00458
l_0041e:
    cmpi.b  #$3, d1
    bne.b   l_0043c
    move.w  d0, $3e(a5)
    lsr.w   #$8, d0
    lsr.w   #$1, d0
    ori.w   #$8500, d0
    andi.b  #$7f, d0
    move.w  d0, ($00C00004).l
    bra.b   l_00458
l_0043c:
    cmpi.b  #$4, d1
    bne.b   l_00458
    move.w  d0, $40(a5)
    lsr.w   #$8, d0
    lsr.w   #$2, d0
    ori.w   #$8d00, d0
    andi.b  #$3f, d0
    move.w  d0, ($00C00004).l
l_00458:
    rts
