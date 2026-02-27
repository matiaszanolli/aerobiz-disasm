; ============================================================================
; FindCharInSet -- Looks up a byte value in the table at $048978; returns 1 if found, 0 if not found
; 42 bytes | $03ACB2-$03ACDB
; ============================================================================
FindCharInSet:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d1
    clr.w   d2
    bra.b   l_3acc8
l_3acbe:
    cmp.b   d1, d3
    bne.b   l_3acc6
    moveq   #$1,d0
    bra.b   l_3acd6
l_3acc6:
    addq.w  #$1, d2
l_3acc8:
    movea.l  #$00048978,a0
    move.b  (a0,d2.w), d3
    bne.b   l_3acbe
    moveq   #$0,d0
l_3acd6:
    movem.l (a7)+, d2-d3
    rts

RenderTextBlock:                                                  ; $03ACDC
    link    a6,#-$94
    movem.l d2-d7/a2-a5,-(sp)
    movea.l $0008(a6),a2
    movea.l #$00ff128a,a3
    lea     -$0084(a6),a4
    lea     -$008c(a6),a5
    move.l  a4,-$0088(a6)
    move.l  a4,d0
    moveq   #$42,d1
    add.l   d1,d0
    move.l  d0,(a5)
    moveq   #$0,d0
    move.w  (a3),d0
    moveq   #$20,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,(a3)
    moveq   #$0,d0
    move.w  ($00FFBDA6).l,d0
    moveq   #$20,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,($00FFBDA6).l
    clr.w   -$0090(a6)
    move.w  (a3),-$008e(a6)
    clr.w   d5
    clr.w   d4
    clr.w   d7
    clr.w   d6
    bra.w   .l3afc6
.l3ad3a:                                                ; $03AD3A
    move.b  $0001(a2),-$0091(a6)
    move.w  (a3),d0
    cmp.w   ($00FF1000).l,d0
    bcs.b   .l3ad50
    cmpi.b  #$1b,d3
    bne.b   .l3ad72
.l3ad50:                                                ; $03AD50
    move.l  a2,-(sp)
    bsr.w SkipControlChars
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  (a3),d1
    add.l   d1,d0
    subq.l  #$1,d0
    moveq   #$0,d1
    move.w  ($00FF1000).l,d1
    cmp.l   d1,d0
    blt.b   .l3ad9e
.l3ad72:                                                ; $03AD72
    pea     ($0001).w
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    lea     $001c(sp),sp
    moveq   #$1,d4
    cmpi.b  #$20,d3
    beq.w   .l3afc4
.l3ad9e:                                                ; $03AD9E
    cmpi.b  #$0a,d3
    bne.b   .l3add0
    tst.w   d4
    bne.b   .l3adca
    pea     ($0001).w
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    lea     $001c(sp),sp
.l3adca:                                                ; $03ADCA
    clr.w   d4
    bra.w   .l3afc4
.l3add0:                                                ; $03ADD0
    tst.w   d7
    beq.b   .l3ae18
    clr.l   -(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    pea     ($0001).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    lea     $0020(sp),sp
    move.w  d0,d2
    tst.w   d2
    beq.b   .l3ae0a
    cmp.w   d2,d6
    beq.b   .l3ae0a
    clr.w   d7
.l3ae0a:                                                ; $03AE0A
    tst.w   d2
    beq.b   .l3ae14
    moveq   #$0,d0
    move.w  d6,d0
    bra.b   .l3ae16
.l3ae14:                                                ; $03AE14
    moveq   #$0,d0
.l3ae16:                                                ; $03AE16
    move.w  d0,d6
.l3ae18:                                                ; $03AE18
    tst.w   ($00FF128C).l
    beq.b   .l3ae26
    move.w  #$8404,d2
    bra.b   .l3ae2a
.l3ae26:                                                ; $03AE26
    move.w  #$0404,d2
.l3ae2a:                                                ; $03AE2A
    cmpi.b  #$20,d3
    bne.b   .l3ae68
    tst.w   ($00FF128C).l
    beq.b   .l3ae4e
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  #$8000,(a0)
.l3ae44:                                                ; $03AE44
    movea.l (a5),a0
    addq.l  #$2,(a5)
    move.w  #$8000,(a0)
    bra.b   .l3ae5e
.l3ae4e:                                                ; $03AE4E
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    clr.w   (a0)
.l3ae58:                                                ; $03AE58
    movea.l (a5),a0
    addq.l  #$2,(a5)
    clr.w   (a0)
.l3ae5e:                                                ; $03AE5E
    addq.w  #$1,(a3)
    addq.w  #$1,-$0090(a6)
    bra.w   .l3adca
.l3ae68:                                                ; $03AE68
    cmpi.b  #$21,d3
    bcs.b   .l3aec4
    cmpi.b  #$7e,d3
    bhi.b   .l3aec4
    tst.w   ($00FF1800).l
    beq.b   .l3ae88
    moveq   #$0,d4
    move.b  d3,d4
    add.w   d4,d4
    addi.w  #$19,d4
    bra.b   .l3ae90
.l3ae88:                                                ; $03AE88
    moveq   #$0,d4
    move.b  d3,d4
    addi.w  #$ffe0,d4
.l3ae90:                                                ; $03AE90
    add.w   d4,d2
    tst.w   ($00FF1800).l
    beq.b   .l3aeb0
    move.l  d2,d0
    addq.w  #$1,d2
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  d0,(a0)
    movea.l (a5),a0
    addq.l  #$2,(a5)
    move.w  d2,(a0)
    bra.b   .l3ae5e
.l3aeb0:                                                ; $03AEB0
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  d2,(a0)
    tst.w   ($00FF128C).l
    beq.b   .l3ae58
    bra.b   .l3ae44
.l3aec4:                                                ; $03AEC4
    cmpi.b  #$1b,d3
    bne.w   .l3afc4
    tst.w   -$0090(a6)
    beq.b   .l3af02
    move.b  -$0091(a6),d0
    move.l  d0,-(sp)
    bsr.w FindCharInSet
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l3af02
    clr.l   -(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    lea     $001c(sp),sp
.l3af02:                                                ; $03AF02
    addq.l  #$1,a2
    moveq   #$0,d0
    move.b  -$0091(a6),d0
    moveq   #$3d,d1
    cmp.b   d1,d0
    beq.b   .l3af3a
    moveq   #$52,d1
    cmp.b   d1,d0
    beq.b   .l3af5c
    moveq   #$45,d1
    cmp.b   d1,d0
    beq.b   .l3af6e
    moveq   #$47,d1
    cmp.b   d1,d0
    beq.b   .l3af80
    moveq   #$57,d1
    cmp.b   d1,d0
    beq.b   .l3af90
    moveq   #$4d,d1
    cmp.b   d1,d0
    beq.b   .l3afa2
    moveq   #$50,d1
    cmp.b   d1,d0
    beq.w   .l3afb0
    bra.w   .l3afc4
.l3af3a:                                                ; $03AF3A
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,($00FFBDA6).l
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,(a3)
    move.w  d0,-$008e(a6)
    bra.b   .l3afc4
.l3af5c:                                                ; $03AF5C
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,($00FF1290).l
    bra.b   .l3afc4
.l3af6e:                                                ; $03AF6E
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    move.w  d0,($00FF1000).l
    bra.b   .l3afc4
.l3af80:                                                ; $03AF80
    moveq   #$1,d7
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    move.w  d0,d6
    bra.b   .l3afc4
.l3af90:                                                ; $03AF90
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    bra.b   .l3afc4
.l3afa2:                                                ; $03AFA2
    tst.w   d5
    bne.b   .l3afaa
    moveq   #$1,d0
    bra.b   .l3afac
.l3afaa:                                                ; $03AFAA
    moveq   #$0,d0
.l3afac:                                                ; $03AFAC
    move.w  d0,d5
    bra.b   .l3afc4
.l3afb0:                                                ; $03AFB0
    addq.l  #$1,a2
    cmpi.b  #$31,(a2)
    bne.b   .l3afbc
    moveq   #$1,d0
    bra.b   .l3afbe
.l3afbc:                                                ; $03AFBC
    moveq   #$0,d0
.l3afbe:                                                ; $03AFBE
    move.w  d0,($00FF128C).l
.l3afc4:                                                ; $03AFC4
    addq.l  #$1,a2
.l3afc6:                                                ; $03AFC6
    move.b  (a2),d3
    bne.w   .l3ad3a
    clr.l   -(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    movem.l -$00bc(a6),d2-d7/a2-a5
    unlk    a6
    rts
; === Translated block $03AFF2-$03B22C ===
; 2 functions, 570 bytes
