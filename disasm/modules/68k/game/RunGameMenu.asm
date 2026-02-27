; ============================================================================
; RunGameMenu -- Draws the main menu screen (background, logo, portrait) then dispatches to sub-menus (aircraft, routes, staff, finance, end-turn) via a jump-table loop
; ============================================================================
RunGameMenu:                                                  ; $016F9E
    movem.l d2-d4/a2-a5,-(sp)
    movea.l #$0001725a,a2
    movea.l #$00ffa792,a3
    movea.l #$00017c9e,a4
    movea.l #$0d64,a5
    moveq   #$0,d0
    move.b  ($00FF0016).l,d0
    move.w  d0,(a3)
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004C976).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0004C996).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    pea     ($0004D096).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    lea     $0030(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $0018(sp),sp
    moveq   #$4,d4
    clr.w   d3
    clr.w   ($00FF1296).l
    dc.w    $6000,$00dc                                 ; bra.w $017160
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00047A5E).l
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    pea     ($0005).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02bc                                 ; jsr $017366
    nop
    lea     $001c(sp),sp
    move.w  d0,d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    dc.w    $6700,$00b0                                 ; beq.w $01716C
    cmpi.w  #$ff,d2
    beq.b   .l170ca
    move.w  d2,d4
    add.w   d4,d4
    addq.w  #$4,d4
.l170ca:                                                ; $0170CA
    move.w  d2,d0
    ext.l   d0
    moveq   #$4,d1
    cmp.l   d1,d0
    dc.w    $6200,$0092                                 ; bhi.w $017166
    add.l   d0,d0
    move.w  $170e0(pc,d0.l),d0
    jmp     $170e0(pc,d0.w)
    ; WARNING: 212 undecoded trailing bytes at $0170E0
    dc.w    $000a
    dc.w    $002e
    dc.w    $0036
    dc.w    $0054
    dc.w    $0072
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $d71c
    dc.w    $4878
    dc.w    $0010
    dc.w    $4878
    dc.w    $0018
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0005
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0010
    dc.w    $4eba
    dc.w    $039a
    dc.w    $4e71
    dc.w    $6052
    dc.w    $4eba
    dc.w    $070c
    dc.w    $4e71
    dc.w    $6050
    dc.w    $4878
    dc.w    $0010
    dc.w    $4878
    dc.w    $0018
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0005
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0010
    dc.w    $4eba
    dc.w    $0086
    dc.w    $4e71
    dc.w    $602c
    dc.w    $4878
    dc.w    $0010
    dc.w    $4878
    dc.w    $0018
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0005
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0010
    dc.w    $4eba
    dc.w    $07ba
    dc.w    $4e71
    dc.w    $600e
    dc.w    $4eba
    dc.w    $0a16
    dc.w    $4e71
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6602
    dc.w    $7601
    dc.w    $42a7
    dc.w    $4e92
    dc.w    $588f
    dc.w    $4a43
    dc.w    $6700
    dc.w    $ff1c
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $d71c
    dc.w    $42a7
    dc.w    $3039
    dc.w    $00ff
    dc.w    $9a1c
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3013
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6a2e
    dc.w    $4878
    dc.w    $0002
    dc.w    $3039
    dc.w    $00ff
    dc.w    $9a1c
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3013
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6b78
    dc.w    $4fef
    dc.w    $0018
    dc.w    $3039
    dc.w    $00ff
    dc.w    $1296
    dc.w    $4cdf
    dc.w    $3c1c
    dc.w    $4e75
; === Translated block $0171B4-$017566 ===
; 4 functions, 946 bytes
