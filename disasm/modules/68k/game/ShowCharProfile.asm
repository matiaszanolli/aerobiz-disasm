; ============================================================================
; ShowCharProfile -- Render character profile panel with text window, tile header, and ShowCharDetail display
; Called: ?? times.
; 342 bytes | $007C3C-$007D91
; ============================================================================
ShowCharProfile:                                                  ; $007C3C
    link    a6,#$0
    movem.l d2-d7/a2,-(sp)
    move.l  $0018(a6),d3
    move.l  $0014(a6),d4
    move.l  $001c(a6),d5
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    movea.l #$0004978c,a2
    cmpi.w  #$1,d3
    bne.b   .l7cca
    moveq   #$1,d2
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  a2,d0
    moveq   #$22,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0028(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$027a,d0
    move.l  d0,-(sp)
    pea     ($0009).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0014(sp),sp
.l7cca:                                                 ; $007CCA
    cmpi.w  #$1,d3
    bne.b   .l7cee
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l7d06
.l7cee:                                                 ; $007CEE
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
.l7d06:                                                 ; $007D06
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a5a8                           ; jsr $03A5A8
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0028(sp),sp
    cmpi.w  #$1,d3
    bne.b   .l7d50
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addi.l  #$f,d0
    bra.b   .l7d6c
.l7d50:                                                 ; $007D50
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addi.l  #$e,d0
.l7d6c:                                                 ; $007D6C
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$000e                                 ; jsr $007D92
    nop
    movem.l -$001c(a6),d2-d7/a2
    unlk    a6
    rts
