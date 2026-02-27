; ============================================================================
; ConfigScrollBar -- Configure or clear a scroll bar slot: set frame rate, data pointer, and enable flag
; Called: ?? times.
; 178 bytes | $006298-$006349
; ============================================================================
ConfigScrollBar:                                                  ; $006298
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0030(sp),d3
    move.l  $003c(sp),d4
    move.l  $0038(sp),d5
    move.l  $0034(sp),d6
    move.l  $002c(sp),d7
    movea.l $0048(sp),a3
    movea.l $0044(sp),a4
    movea.l $0040(sp),a5
    tst.w   d3
    beq.b   .l62c4
    moveq   #$2,d2
    bra.b   .l62c6
.l62c4:                                                 ; $0062C4
    moveq   #$1,d2
.l62c6:                                                 ; $0062C6
    tst.w   d3
    beq.b   .l62d2
    move.l  #$00ffbdc4,d0
    bra.b   .l62d8
.l62d2:                                                 ; $0062D2
    move.l  #$00ffbdae,d0
.l62d8:                                                 ; $0062D8
    movea.l d0,a2
    moveq   #$0,d0
    move.w  d7,d0
    beq.b   .l62e8
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l6304
    bra.b   .l6344
.l62e8:                                                 ; $0062E8
    move.w  d2,d0
    not.w   d0
    and.w   d0,($00FFBDAC).l
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    bra.b   .l6344
.l6304:                                                 ; $006304
    move.w  d2,d0
    not.w   d0
    and.w   d0,($00FFBDAC).l
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    clr.w   (a2)
    move.w  d6,$0002(a2)
    clr.w   $0004(a2)
    move.w  d5,$0006(a2)
    move.w  d4,$0008(a2)
    move.l  a5,$000a(a2)
    move.l  a4,$000e(a2)
    move.l  a3,$0012(a2)
    move.w  d2,d0
    or.w    d0,($00FFBDAC).l
.l6344:                                                 ; $006344
    movem.l (sp)+,d2-d7/a2-a5
    rts
; ---------------------------------------------------------------------------
; SetScrollBarMode -- Switch scroll counter mode: disable, enable with current pos, or toggle
; 124 bytes | $00634A-$0063C5
; ---------------------------------------------------------------------------
SetScrollBarMode:                                                  ; $00634A
    link    a6,#$0
    movem.l a2-a3,-(sp)
    movea.l #$00ffbdac,a3
    movea.l #$00ffbdda,a2
    moveq   #$0,d0
    move.w  $000a(a6),d0
    beq.b   .l636e
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l6384
    bra.b   .l63bc
.l636e:                                                 ; $00636E
    andi.w  #$fffb,(a3)
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    bra.b   .l63bc
.l6384:                                                 ; $006384
    andi.w  #$fffb,(a3)
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    bsr.w CalcScrollBarPos
    move.w  $0016(a6),(a2)
    move.w  $001a(a6),$0002(a2)
    clr.w   $0004(a2)
    clr.w   $0006(a2)
    ori.w   #$4,(a3)
.l63bc:                                                 ; $0063BC
    movem.l -$0008(a6),a2-a3
    unlk    a6
    rts
; === Translated block $0063C6-$00643C ===
; 1 functions, 118 bytes
