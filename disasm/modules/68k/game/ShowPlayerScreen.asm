; ============================================================================
; ShowPlayerScreen -- Displays the appropriate player status screen based on player index (0-3) and airline type; routes to RenderDetailedStats, ShowAlternatePlayerView, or RenderPlayerListUI
; Called: ?? times.
; 182 bytes | $03CB36-$03CBEB
; ============================================================================
ShowPlayerScreen:                                                  ; $03CB36
    movem.l d2/a2-a3,-(sp)
    move.l  $0010(sp),d2
    movea.l #$0001d3ac,a3
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    move.w  #$1,($00FF000C).l
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d340                           ; jsr $01D340
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d37a                           ; jsr $01D37A
    addq.l  #$8,sp
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    cmpi.w  #$4,d2
    blt.b   .l3cb98
    clr.l   -(sp)
    pea     ($0014).w
    jsr     (a3)
    addq.l  #$8,sp
    dc.w    $4eba,$133c                                 ; jsr $03DECE
    nop
    bra.b   .l3cbdc
.l3cb98:                                                ; $03CB98
    cmpi.b  #$01,(a2)
    bne.b   .l3cbc6
    dc.w    $4eba,$004c                                 ; jsr $03CBEC
    nop
    clr.l   -(sp)
    pea     ($0015).w
    jsr     (a3)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$01fa                                 ; jsr $03CDAC
    nop
    lea     $000c(sp),sp
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0894                                 ; jsr $03D454
    nop
    bra.b   .l3cbda
.l3cbc6:                                                ; $03CBC6
    clr.l   -(sp)
    pea     ($0013).w
    jsr     (a3)
    addq.l  #$8,sp
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$100e                                 ; jsr $03DBE4
    nop
.l3cbda:                                                ; $03CBDA
    addq.l  #$4,sp
.l3cbdc:                                                ; $03CBDC
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$b428                           ; jsr $03B428
    addq.l  #$4,sp
    movem.l (sp)+,d2/a2-a3
    rts
; === Translated block $03CBEC-$03E05A ===
; 12 functions, 5230 bytes
