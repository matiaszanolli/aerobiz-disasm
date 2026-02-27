; ============================================================================
; PlaceCursor -- Place cursor tile at (x,y), optionally placing a second cursor tile for two-player mode
; Called: ?? times.
; 166 bytes | $009CEC-$009D91
; ============================================================================
PlaceCursor:                                                  ; $009CEC
    movem.l d2-d4/a2,-(sp)
    move.l  $0018(sp),d2
    move.l  $0014(sp),d3
    move.l  $001c(sp),d4
    movea.l #$0d64,a2
    pea     ($0006).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0744).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0028(sp),sp
    cmpi.w  #$1,d4
    bne.b   .l9d84
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $002c(sp),sp
.l9d84:                                                 ; $009D84
    pea     ($0018).w
    jsr     (a2)
    addq.l  #$4,sp
    movem.l (sp)+,d2-d4/a2
    rts
