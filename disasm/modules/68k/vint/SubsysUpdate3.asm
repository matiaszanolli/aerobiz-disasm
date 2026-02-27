; ============================================================================
; SubsysUpdate3 -- Update cursor sprite position by scroll offsets and write to VRAM sprite table
; 108 bytes | $001864-$0018CF
; ============================================================================
SubsysUpdate3:
    btst    #$0, $c62(a5)
    beq.b   l_018ce
    movea.l  #$00FFF08A,a0
    movea.l  #$00FFFC74,a1
    move.w  (a1)+, d0
    add.w   $c5e(a5), d0
    move.w  d0, (a0)+
    move.l  (a1)+, (a0)+
    move.w  (a1), d0
    add.w   $c5c(a5), d0
    move.w  d0, (a0)
    jsr (InitSpriteLinks,PC)
    movea.l  #$00C00000,a0
    movea.l  #$00C00004,a1
    move.w  #$8f02, (a1)
    moveq   #$0,d0
    move.w  $3e(a5), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    swap    d0
    andi.l  #$3, d0
    andi.l  #$3fff, d1
    swap    d1
    or.l    d0, d1
    bset    #$1e, d1
    move.l  d1, (a1)
    movea.l  #$00FFF08A,a2
    move.w  (a2)+, (a0)
    move.w  (a2)+, (a0)
    move.w  (a2)+, (a0)
    move.w  (a2)+, (a0)
l_018ce:
    rts
