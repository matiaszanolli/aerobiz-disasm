; ============================================================================
; SelectMenuItem -- Map selection index to menu entry, dispatch via MenuSelectEntry
; Called: 14 times.
; 62 bytes | $009F4A-$009F87
; ============================================================================
SelectMenuItem:                                                  ; $009F4A
    move.l  $0004(sp),d1
    cmpi.w  #$7,d1
    bge.b   .l9f58
    addq.w  #$2,d1
    bra.b   .l9f76
.l9f58:                                                 ; $009F58
    cmpi.w  #$2,($00FF0002).l
    bge.b   .l9f66
    moveq   #$a,d1
    bra.b   .l9f76
.l9f66:                                                 ; $009F66
    cmpi.w  #$3,($00FF0002).l
    bge.b   .l9f74
    moveq   #$b,d1
    bra.b   .l9f76
.l9f74:                                                 ; $009F74
    moveq   #$c,d1
.l9f76:                                                 ; $009F76
    pea     ($0001).w
    move.w  d1,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    addq.l  #$8,sp
    rts
LoadSlotGraphics:                                                  ; $009F88
    movem.l d2-d5,-(sp)
    move.l  $0020(sp),d2
    move.l  $001c(sp),d3
    move.l  $0018(sp),d4
    move.l  $0014(sp),d5
    cmpi.w  #$1,d2
    bne.b   .l9fcc
    pea     ($00070F18).l
    pea     ($0002).w
    pea     ($0008).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
.l9fcc:                                                 ; $009FCC
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000a1ac8,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0010).w
    pea     ($03A4).w
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0014(sp),sp
    movem.l (sp)+,d2-d5
    rts
