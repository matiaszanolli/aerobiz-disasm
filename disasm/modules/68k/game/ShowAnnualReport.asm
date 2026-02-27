; ============================================================================
; ShowAnnualReport -- Displays the annual financial report for a player: determines best rival airline, most profitable route, and special conditions (bankruptcy, competition), then formats and shows the corresponding summary dialog
; Called: ?? times.
; 1298 bytes | $02BDB8-$02C2C9
; ============================================================================
ShowAnnualReport:                                                  ; $02BDB8
    link    a6,#-$b0
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d4
    lea     -$00a6(a6),a3
    movea.l #$0001183a,a4
    movea.l #$0004843c,a5
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$4,d0
    sub.l   d1,d0
    lsl.l   #$2,d0
    addq.l  #$1,d0
    move.w  ($00FF0006).l,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.w   .l2c2c0
    clr.w   -$00ac(a6)
    clr.w   -$00aa(a6)
    clr.w   d7
    move.w  d4,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,-$0002(a6)
    clr.w   d2
.l2be28:                                                ; $02BE28
    cmp.w   d4,d2
    beq.b   .l2be6c
    move.w  d2,d0
    lsl.w   #$3,d0
    add.w   -$0002(a6),d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.b   .l2be6c
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  -$0002(a6),d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)
    beq.b   .l2be6c
    move.w  #$1,-$00aa(a6)
    move.w  d2,-$00a8(a6)
.l2be6c:                                                ; $02BE6C
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2be28
    move.w  ($00FF0004).l,d0
    addq.w  #$4,d0
    move.w  d0,-$0004(a6)
    cmpi.w  #$7,-$0004(a6)
    bge.b   .l2be90
    move.w  -$0004(a6),d0
    ext.l   d0
    bra.b   .l2be92
.l2be90:                                                ; $02BE90
    moveq   #$7,d0
.l2be92:                                                ; $02BE92
    move.w  d0,-$0004(a6)
    moveq   #-$1,d5
    clr.w   d3
.l2be9a:                                                ; $02BE9A
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    cmpi.w  #$ff,d0
    bne.b   .l2beba
    move.w  #$1,-$00ac(a6)
.l2beba:                                                ; $02BEBA
    move.w  d4,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.b   .l2bef0
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)
    beq.b   .l2bef0
    addq.w  #$1,d7
    bra.b   .l2bf38
.l2bef0:                                                ; $02BEF0
    move.w  d3,-$0006(a6)
    clr.w   d2
.l2bef6:                                                ; $02BEF6
    cmp.w   d4,d2
    beq.b   .l2bf30
    move.w  d2,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.b   .l2bf30
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)
    beq.b   .l2bf30
    move.w  d2,d5
    bra.b   .l2bf38
.l2bf30:                                                ; $02BF30
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2bef6
.l2bf38:                                                ; $02BF38
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    blt.w   .l2be9a
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$74f8                           ; jsr $0074F8
    addq.l  #$8,sp
    move.w  d0,d2
    tst.w   d2
    bgt.b   .l2bfae
    dc.w    $4eba,$0368                                 ; jsr $02C2CA
    nop
    move.w  -$0002(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  $0024(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    move.l  $0028(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $002c(sp),sp
    bra.w   .l2c2aa
.l2bfae:                                                ; $02BFAE
    cmpi.w  #$1,-$00aa(a6)
    bne.w   .l2c048
    move.w  d7,d0
    ext.l   d0
    move.w  -$0004(a6),d1
    ext.l   d1
    subq.l  #$1,d1
    cmp.l   d1,d0
    blt.w   .l2c2c0
    dc.w    $4eba,$02fe                                 ; jsr $02C2CA
    nop
    move.w  -$0002(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.w  -$00a8(a6),d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.l  ($0004843C).l,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0028(sp),sp
    move.w  -$00a8(a6),d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.l  $0004(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $000c(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    bra.w   .l2c2b2
.l2c048:                                                ; $02C048
    move.w  d7,d0
    ext.l   d0
    move.w  -$0004(a6),d1
    ext.l   d1
    subq.l  #$1,d1
    cmp.l   d1,d0
    bne.w   .l2c114
    dc.w    $4eba,$026e                                 ; jsr $02C2CA
    nop
    cmpi.w  #$3,($00FF0004).l
    bge.b   .l2c0ac
    pea     ($00042ECE).l
    move.l  $0008(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0024(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $000c(a5),-(sp)
    bra.w   .l2c2b8
.l2c0ac:                                                ; $02C0AC
    move.w  -$0006(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  $0008(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0024(sp),sp
    move.w  d5,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l2c2c0
    move.w  -$0006(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.l  $0010(a5),-(sp)
    bra.w   .l2c29e
.l2c114:                                                ; $02C114
    cmp.w   -$0004(a6),d7
    bne.w   .l2c2c0
    cmpi.w  #$1,-$00ac(a6)
    bne.b   .l2c140
    dc.w    $4eba,$01a4                                 ; jsr $02C2CA
    nop
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $0014(a5),-(sp)
    bra.w   .l2c2b8
.l2c140:                                                ; $02C140
    dc.w    $4eba,$0188                                 ; jsr $02C2CA
    nop
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    tst.w   d2
    bne.b   .l2c170
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $001c(a5),-(sp)
    bra.b   .l2c1a0
.l2c170:                                                ; $02C170
    move.w  d2,d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0,d1
    move.l  d1,d0
    add.l   d0,d0
    add.l   d1,d0
    move.l  d0,-(sp)
    move.l  $0018(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $000c(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  a3,-(sp)
.l2c1a0:                                                ; $02C1A0
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0018(sp),sp
    clr.l   -$00b0(a6)
    moveq   #-$1,d7
    clr.w   d3
.l2c1b4:                                                ; $02C1B4
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    move.l  (a0,d0.w),d5
    tst.l   d5
    beq.w   .l2c26a
    move.w  d4,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0
    bne.w   .l2c26a
    moveq   #-$1,d6
    clr.w   d2
.l2c1f0:                                                ; $02C1F0
    move.w  d2,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$2,d0
    bne.b   .l2c210
    move.w  d2,d6
    bra.b   .l2c218
.l2c210:                                                ; $02C210
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2c1f0
.l2c218:                                                ; $02C218
    move.w  d6,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l2c238
    move.w  d6,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    move.l  (a0,d0.w),d2
    bra.b   .l2c23a
.l2c238:                                                ; $02C238
    moveq   #$0,d2
.l2c23a:                                                ; $02C23A
    move.l  d2,d0
    moveq   #$b,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    move.l  d5,d0
    lsl.l   #$2,d0
    add.l   d5,d0
    add.l   d0,d0
    move.l  (sp)+,d1
    cmp.l   d1,d0
    bcc.b   .l2c26a
    cmp.w   -$0002(a6),d3
    bne.b   .l2c25e
    move.w  d3,d7
    bra.b   .l2c274
.l2c25e:                                                ; $02C25E
    cmp.l   -$00b0(a6),d5
    bls.b   .l2c26a
    move.l  d5,-$00b0(a6)
    move.w  d3,d7
.l2c26a:                                                ; $02C26A
    addq.w  #$1,d3
    cmpi.w  #$7,d3
    blt.w   .l2c1b4
.l2c274:                                                ; $02C274
    move.w  d7,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l2c2c0
    move.w  d6,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.w  d7,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  $0020(a5),-(sp)
.l2c29e:                                                ; $02C29E
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $0010(sp),sp
.l2c2aa:                                                ; $02C2AA
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
.l2c2b2:                                                ; $02C2B2
    pea     ($0004).w
    move.l  a3,-(sp)
.l2c2b8:                                                ; $02C2B8
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
.l2c2c0:                                                ; $02C2C0
    movem.l -$00d8(a6),d2-d7/a2-a5
    unlk    a6
    rts
    dc.w    $42A7,$4878,$0020; $02C2CA
; === Translated block $02C2D0-$02C2FA ===
; 1 functions, 42 bytes
