; ============================================================================
; LoadScreenGfx -- Load and display compressed screen graphics
; Called: 21 times.
; 356 bytes | $0068CA-$006A2D
; ============================================================================
LoadScreenGfx:                                                  ; $0068CA
    link    a6,#$0
    movem.l d2/a2-a3,-(sp)
    move.l  $0008(a6),d2
    movea.l #$0d64,a2
    movea.l #$00ff1804,a3
    move.w  #$7,($00FF9A1C).l
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  ($00095118).l,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0014(sp),sp
    cmpi.w  #$4,d2
    bge.b   .l6924
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$98d2                           ; jsr $0098D2
    addq.l  #$4,sp
.l6924:                                                 ; $006924
    pea     ($02C0).w
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    pea     ($00070198).l
    pea     ($0016).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0030(sp),sp
    cmpi.w  #$1,$0012(a6)
    bne.b   .l69a2
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0017).w
    bra.b   .l69b2
.l69a2:                                                 ; $0069A2
    pea     ($21E1).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0016).w
.l69b2:                                                 ; $0069B2
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    cmpi.w  #$1,$000e(a6)
    bne.b   .l6a24
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007679E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($00070758).l
    pea     ($0016).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    move.l  ($00095138).l,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($00C0).w
    pea     ($0640).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
.l6a24:                                                 ; $006A24
    movem.l -$000c(a6),d2/a2-a3
    unlk    a6
    rts
