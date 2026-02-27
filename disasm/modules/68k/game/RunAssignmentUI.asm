; ============================================================================
; RunAssignmentUI -- Draws the assignment screen with character icon grid and runs a character-code entry loop supporting append and delete, printing the typed name
; Called: ?? times.
; 1524 bytes | $016958-$016F4B
; ============================================================================
RunAssignmentUI:                                                  ; $016958
    link    a6,#-$1c
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d4
    lea     -$0006(a6),a3
    movea.l #$0d64,a4
    lea     -$0008(a6),a5
    move.l  #$8000,-(sp)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004C976).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $0028(sp),sp
    pea     ($0004CD56).l
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000F).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $001c(sp),sp
    clr.w   d2
.l169ca:                                                ; $0169CA
    move.w  d2,d0
    ext.l   d0
    addi.l  #$0774,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0007).w
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l169ca
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A5E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  ($000A1B08).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($006B).w
    pea     ($010F).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    lea     $0020(sp),sp
    pea     ($00071A64).l
    pea     ($000B).w
    pea     ($0020).w
    pea     ($000E).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)
    moveq   #$7,d7
    clr.b   -$001a(a6)
    lea     -$001a(a6),a2
    clr.w   d5
    move.w  #$16,(a3)
    move.w  #$3,(a5)
    moveq   #$17,d3
    moveq   #$12,d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0030(sp),sp
    tst.w   d0
    beq.b   .l16aa6
    moveq   #$1,d0
    bra.b   .l16aa8
.l16aa6:                                                ; $016AA6
    moveq   #$0,d0
.l16aa8:                                                ; $016AA8
    move.w  d0,-$0002(a6)
    clr.w   -$0004(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d6
.l16abe:                                                ; $016ABE
    cmpi.w  #$17,d3
    blt.b   .l16ae2
    cmpi.w  #$12,d2
    bne.b   .l16ae2
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($00B6).w
    pea     ($00CB).w
    bra.b   .l16b16
.l16ae2:                                                ; $016AE2
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    move.w  d2,d1
    ext.l   d1
    lsl.l   #$3,d1
    add.l   d1,d0
    subi.l  #$ae,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
.l16b16:                                                ; $016B16
    clr.l   -(sp)
    pea     ($0740).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $0024(sp),sp
    moveq   #$1,d0
    eor.w   d0,d6
    cmp.w   d7,d5
    bge.b   .l16b62
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0088).w
    move.w  d5,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$b0,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0770).w
    bra.b   .l16b76
.l16b62:                                                ; $016B62
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
.l16b76:                                                ; $016B76
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $0024(sp),sp
    tst.w   -$0002(a6)
    beq.b   .l16bae
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l16bae
    pea     ($0003).w
.l16ba2:                                                ; $016BA2
    pea     ($000E).w
    jsr     (a4)
.l16ba8:                                                ; $016BA8
    addq.l  #$8,sp
    bra.w   .l16abe
.l16bae:                                                ; $016BAE
    clr.w   -$0002(a6)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    move.w  -$0004(a6),d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    lea     $0010(sp),sp
    andi.w  #$3f,d0
    move.w  d0,-$0004(a6)
    andi.w  #$30,d0
    beq.w   .l16cba
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  -$0004(a6),d0
    andi.w  #$20,d0
    beq.b   .l16c6e
    cmpi.w  #$17,d3
    blt.b   .l16c04
    cmpi.w  #$12,d2
    beq.w   .l16e66
.l16c04:                                                ; $016C04
    move.w  (a5),d0
    mulu.w  #$1c,d0
    add.w   (a3),d0
    movea.l #$00047a9c,a0
    move.b  (a0,d0.w),-$0009(a6)
    cmpi.b  #$2d,-$0009(a6)
    bne.b   .l16c26
    move.b  #$20,-$0009(a6)
.l16c26:                                                ; $016C26
    cmp.w   d7,d5
    bge.w   .l16abe
    addq.w  #$1,d5
    move.b  -$0009(a6),(a2)+
    clr.b   (a2)
    pea     ($000F).w
    pea     ($0016).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     -$001a(a6)
    pea     ($0003F948).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0010(sp),sp
    cmp.w   d7,d5
    bne.b   .l16c66
    moveq   #$17,d3
    moveq   #$12,d2
    move.w  #$16,(a3)
    move.w  #$3,(a5)
.l16c66:                                                ; $016C66
    pea     ($0006).w
    bra.w   .l16ba2
.l16c6e:                                                ; $016C6E
    tst.w   d5
    ble.w   .l16abe
    subq.l  #$1,a2
    clr.b   (a2)
    subq.w  #$1,d5
    clr.l   -(sp)
    pea     ($0003).w
    pea     ($0008).w
    pea     ($000F).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($000F).w
    pea     ($0016).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0024(sp),sp
    pea     -$001a(a6)
    pea     ($0003F944).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    bra.w   .l16ba8
.l16cba:                                                ; $016CBA
    move.w  #$1,($00FF13FC).l
    move.w  -$0004(a6),d0
    andi.w  #$2,d0
    beq.b   .l16d14
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$3,d1
    cmp.l   d0,d1
    ble.b   .l16ce0
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16ce2
.l16ce0:                                                ; $016CE0
    moveq   #$3,d0
.l16ce2:                                                ; $016CE2
    move.w  d0,(a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$12,d1
    cmp.l   d0,d1
    ble.b   .l16cf8
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16cfa
.l16cf8:                                                ; $016CF8
    moveq   #$12,d0
.l16cfa:                                                ; $016CFA
    move.w  d0,d2
    cmpi.w  #$12,d2
    bne.b   .l16d14
    cmpi.w  #$18,d3
    beq.b   .l16d0e
    cmpi.w  #$19,d3
    bne.b   .l16d14
.l16d0e:                                                ; $016D0E
    moveq   #$17,d3
    move.w  #$16,(a3)
.l16d14:                                                ; $016D14
    move.w  -$0004(a6),d0
    andi.w  #$1,d0
    beq.b   .l16d56
    cmpi.w  #$15,d3
    blt.b   .l16d2a
    cmpi.w  #$11,d2
    ble.b   .l16d56
.l16d2a:                                                ; $016D2A
    move.w  (a5),d0
    ext.l   d0
    subq.l  #$1,d0
    ble.b   .l16d3a
    move.w  (a5),d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16d3c
.l16d3a:                                                ; $016D3A
    moveq   #$0,d0
.l16d3c:                                                ; $016D3C
    move.w  d0,(a5)
    move.w  d2,d0
    ext.l   d0
    subq.l  #$1,d0
    moveq   #$f,d1
    cmp.l   d0,d1
    bge.b   .l16d52
    move.w  d2,d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16d54
.l16d52:                                                ; $016D52
    moveq   #$f,d0
.l16d54:                                                ; $016D54
    move.w  d0,d2
.l16d56:                                                ; $016D56
    move.w  -$0004(a6),d0
    andi.w  #$8,d0
    beq.w   .l16e10
    cmpi.w  #$11,d2
    bge.b   .l16d70
    cmpi.w  #$14,d3
    bge.w   .l16e10
.l16d70:                                                ; $016D70
    cmpi.w  #$11,d2
    bne.b   .l16da2
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$18,d1
    cmp.l   d0,d1
    ble.b   .l16d8a
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16d8c
.l16d8a:                                                ; $016D8A
    moveq   #$18,d0
.l16d8c:                                                ; $016D8C
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$19,d1
    cmp.l   d0,d1
    ble.b   .l16df4
.l16d9a:                                                ; $016D9A
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16df6
.l16da2:                                                ; $016DA2
    cmpi.w  #$12,d2
    bne.b   .l16dd0
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$16,d1
    cmp.l   d0,d1
    ble.b   .l16dbc
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16dbe
.l16dbc:                                                ; $016DBC
    moveq   #$16,d0
.l16dbe:                                                ; $016DBE
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$17,d1
    cmp.l   d0,d1
    bgt.b   .l16d9a
    moveq   #$17,d0
    bra.b   .l16df6
.l16dd0:                                                ; $016DD0
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$1a,d1
    cmp.l   d0,d1
    ble.b   .l16de4
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16de6
.l16de4:                                                ; $016DE4
    moveq   #$1a,d0
.l16de6:                                                ; $016DE6
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$19,d1
    cmp.l   d0,d1
    bgt.b   .l16d9a
.l16df4:                                                ; $016DF4
    moveq   #$19,d0
.l16df6:                                                ; $016DF6
    move.w  d0,d3
    move.w  (a5),d0
    mulu.w  #$1c,d0
    add.w   (a3),d0
    movea.l #$00047a9c,a0
    cmpi.b  #$20,(a0,d0.w)
    beq.w   .l16d70
.l16e10:                                                ; $016E10
    move.w  -$0004(a6),d0
    andi.w  #$4,d0
    beq.w   .l16abe
.l16e1c:                                                ; $016E1C
    move.w  (a3),d0
    ext.l   d0
    subq.l  #$1,d0
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l16e30
    move.w  (a3),d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16e32
.l16e30:                                                ; $016E30
    moveq   #$1,d0
.l16e32:                                                ; $016E32
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    subq.l  #$1,d0
    moveq   #$2,d1
    cmp.l   d0,d1
    bge.b   .l16e48
    move.w  d3,d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16e4a
.l16e48:                                                ; $016E48
    moveq   #$2,d0
.l16e4a:                                                ; $016E4A
    move.w  d0,d3
    move.w  (a5),d0
    mulu.w  #$1c,d0
    add.w   (a3),d0
    movea.l #$00047a9c,a0
    cmpi.b  #$20,(a0,d0.w)
    beq.b   .l16e1c
    bra.w   .l16abe
.l16e66:                                                ; $016E66
    tst.w   d5
    beq.b   .l16e9e
    clr.w   d2
    clr.w   d3
    bra.b   .l16e7c
.l16e70:                                                ; $016E70
    cmpi.b  #$20,-$1a(a6,d3.w)
    beq.b   .l16e7a
    addq.w  #$1,d2
.l16e7a:                                                ; $016E7A
    addq.w  #$1,d3
.l16e7c:                                                ; $016E7C
    cmp.w   d5,d3
    blt.b   .l16e70
    tst.w   d2
    beq.b   .l16e9e
    pea     -$001a(a6)
    move.w  d4,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    addq.l  #$8,sp
.l16e9e:                                                ; $016E9E
    pea     ($0002).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    clr.l   -(sp)
    pea     ($000B).w
    pea     ($0020).w
    pea     ($000E).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    lea     $0024(sp),sp
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
    clr.w   d4
.l16ede:                                                ; $016EDE
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0007).w
    move.w  d4,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    move.w  d4,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d4,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0028(sp),sp
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    blt.b   .l16ede
    movem.l -$0044(a6),d2-d7/a2-a5
    unlk    a6
    rts
    movem.l d2-d4,-(sp)
    move.l  $0018(sp),d4
    clr.w   d3
    clr.b   d2
    tst.w   $0016(sp)
    dc.w    $6F08,$206F                                          ; $016F4C
; === Translated block $016F50-$016F9E ===
; 1 functions, 78 bytes
