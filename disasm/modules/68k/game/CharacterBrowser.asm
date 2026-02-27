; ============================================================================
; CharacterBrowser -- Full scrollable character browser UI: handles region/category navigation, stat display, and selection confirmation
; Called: ?? times.
; 962 bytes | $008A4A-$008E0B
; ============================================================================
CharacterBrowser:                                                  ; $008A4A
    link    a6,#-$8
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $000c(a6),d5
    movea.l #$0d64,a3
    lea     -$0004(a6),a4
    movea.l #$00ff1804,a5
    move.w  #$1,-$0006(a6)
    clr.w   d4
    moveq   #$1,d7
    clr.w   d3
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005f6d6,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
.l8a82:                                                 ; $008A82
    clr.w   d2
    movea.w d2,a0
    move.b  (a2,a0.w),d0
    cmp.b   d5,d0
    beq.b   .l8aa0
    moveq   #$1,d2
    movea.w d2,a0
    move.b  (a2,a0.w),d0
    cmp.b   d5,d0
    beq.b   .l8aa0
    addq.l  #$2,a2
    addq.w  #$1,d3
    bra.b   .l8a82
.l8aa0:                                                 ; $008AA0
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($0004DFB8).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($0010).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767BE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  ($0009513C).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0060).w
    pea     ($0640).w
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0030(sp),sp
    pea     ($00070E58).l
    pea     ($0008).w
    pea     ($000C).w
    pea     ($0005).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    move.w  d5,d6
    pea     ($0003E1AA).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0024(sp),sp
    tst.w   d0
    beq.b   .l8bb6
    moveq   #$1,d0
    bra.b   .l8bb8
.l8bb6:                                                 ; $008BB6
    moveq   #$0,d0
.l8bb8:                                                 ; $008BB8
    move.w  d0,-$0002(a6)
    clr.w   (a4)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l8bca:                                                 ; $008BCA
    cmpi.w  #$1,d7
    bne.b   .l8c00
    move.w  -$0006(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000E).w
    pea     ($000C).w
    dc.w    $4eba,$13a0                                 ; jsr $009F88
    nop
    clr.w   -$0006(a6)
    clr.w   d7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0018(sp),sp
.l8c00:                                                 ; $008C00
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    cmpi.w  #$1,d4
    bne.b   .l8c2e
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767BE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    clr.w   d4
    bra.b   .l8c50
.l8c2e:                                                 ; $008C2E
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    addi.l  #$28,d0
    move.l  d0,-(sp)
    pea     ($000767DC).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    moveq   #$1,d4
.l8c50:                                                 ; $008C50
    tst.w   -$0002(a6)
    beq.b   .l8c74
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l8c74
    pea     ($0003).w
.l8c68:                                                 ; $008C68
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    bra.w   .l8bca
.l8c74:                                                 ; $008C74
    clr.w   -$0002(a6)
    move.w  -$0004(a6),d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$3f,d0
    move.w  d0,(a4)
    andi.w  #$30,d0
    beq.b   .l8ca4
    move.w  (a4),d0
    andi.w  #$10,d0
    beq.b   .l8cfc
    move.w  #$ff,d6
    bra.b   .l8cfc
.l8ca4:                                                 ; $008CA4
    move.w  (a4),d0
    andi.w  #$f,d0
    beq.b   .l8cf4
    move.w  (a4),d0
    andi.w  #$8,d0
    beq.b   .l8cba
    addq.w  #$1,d3
    andi.w  #$3,d3
.l8cba:                                                 ; $008CBA
    move.w  (a4),d0
    andi.w  #$4,d0
    beq.b   .l8cc8
    addq.w  #$3,d3
    andi.w  #$3,d3
.l8cc8:                                                 ; $008CC8
    move.w  (a4),d0
    andi.w  #$1,d0
    beq.b   .l8cd2
    clr.w   d2
.l8cd2:                                                 ; $008CD2
    move.w  (a4),d0
    andi.w  #$2,d0
    beq.b   .l8cdc
    moveq   #$1,d2
.l8cdc:                                                 ; $008CDC
    move.w  d3,d0
    add.w   d0,d0
    add.w   d2,d0
    movea.l #$0005f6d6,a0
    move.b  (a0,d0.w),d6
    andi.l  #$ff,d6
    moveq   #$1,d7
.l8cf4:                                                 ; $008CF4
    pea     ($0002).w
    bra.w   .l8c68
.l8cfc:                                                 ; $008CFC
    move.l  #$8000,-(sp)
    pea     ($0010).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    cmpi.w  #$ff,d6
    beq.w   .l8dde
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    pea     ($0010).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d6,d5
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$11ec                                 ; jsr $009F4A
    nop
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    lea     $002c(sp),sp
    pea     ($0002).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    bra.b   .l8dfa
.l8dde:                                                 ; $008DDE
    pea     ($0002).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $000c(sp),sp
.l8dfa:                                                 ; $008DFA
    pea     ($0018).w
    jsr     (a3)
    move.w  d5,d0
    movem.l -$0030(a6),d2-d7/a2-a5
    unlk    a6
    rts
