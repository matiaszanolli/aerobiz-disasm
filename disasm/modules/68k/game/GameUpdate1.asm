; ============================================================================
; GameUpdate1 -- Displays the seasonal transition screen: loads resources, computes the current season name (game year mod 4) and year display value, prints both in a centered text window, then animates 3 frames of the season label before returning
; 364 bytes | $02F5A6-$02F711
; ============================================================================
GameUpdate1:
    link    a6,#$0
    movem.l d2-d4/a2-a3, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$0003B270,a3
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0007).w
    jsr SelectMenuItem
    move.w  ($00FF0006).l, d0
    ext.l   d0
    addq.l  #$3, d0
    moveq   #$4,d1
    jsr SignedMod
    move.l  d0, d3
    mulu.w  #$3, d3
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    moveq   #$C,d1
    jsr SignedMod
    move.w  d0, d3
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_2f628
    addq.l  #$3, d0
l_2f628:
    asr.l   #$2, d0
    addi.w  #$7a3, d0
    move.w  d0, d4
    pea     ($001E).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $30(a7), a7
    pea     ($000C).w
    pea     ($000C).w
    jsr SetTextCursor
    jsr ResourceUnload
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005F096,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004472A).l
    jsr     (a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044726).l
    jsr     (a3)
    pea     ($000D).w
    jsr LoadDisplaySet
    lea     $1c(a7), a7
    clr.w   d2
l_2f68e:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000C).w
    pea     ($000C).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($000C).w
    pea     ($000C).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005F096,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044722).l
    jsr     (a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004471E).l
    jsr     (a3)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $18(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_2f68e
    pea     ($0018).w
    jsr     (a2)
    movem.l -$14(a6), d2-d4/a2-a3
    unlk    a6
    rts

ShowQuarterReport:                                                  ; $02F712
    link    a6,#-$a0
    movem.l d2-d6/a2-a5,-(sp)
    lea     -$00a0(a6),a3
    movea.l #$0001183a,a4
    movea.l #$0003b22c,a5
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04c4                                 ; jsr $02FC14
    nop
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    clr.w   ($00FF99A0).l
    clr.l   -(sp)
    move.l  ($00047B48).l,-(sp)
    pea     ($0004).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0464                                 ; jsr $02FBD6
    nop
    lea     $0014(sp),sp
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$4,d0
    sub.l   d1,d0
    lsl.l   #$2,d0
    move.w  ($00FF0006).l,d1
    ext.l   d1
    sub.l   d0,d1
    moveq   #$1,d0
    cmp.l   d1,d0
    bne.b   .l2f7ae
    tst.w   ($00FF14B8).l
    bne.b   .l2f7ae
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0568                                 ; jsr $02FD10
    nop
    addq.l  #$4,sp
.l2f7ae:                                                ; $02F7AE
    tst.l   $0006(a2)
    bge.b   .l2f7c8
    cmpi.b  #$64,$0022(a2)
    bcc.b   .l2f7c8
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05ce                                 ; jsr $02FD90
    nop
    addq.l  #$4,sp
.l2f7c8:                                                ; $02F7C8
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$ff76                           ; jsr $00FF76
    move.w  d0,d4
    clr.l   -(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$fff8                           ; jsr $00FFF8
    lea     $000c(sp),sp
    move.w  d0,d6
    cmpi.w  #$46,($00FF1294).l
    blt.b   .l2f818
    pea     ($0002).w
    move.l  ($00047B28).l,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$03c6                                 ; jsr $02FBD6
    nop
    lea     $0010(sp),sp
.l2f818:                                                ; $02F818
    tst.w   d4
    ble.b   .l2f858
    cmpi.w  #$1,d4
    bne.b   .l2f82a
    pea     ($00044754).l
    bra.b   .l2f830
.l2f82a:                                                ; $02F82A
    pea     ($0004474C).l
.l2f830:                                                ; $02F830
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($00047C70).l,-(sp)
    move.l  a3,-(sp)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3,-(sp)
    pea     ($0002).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0386                                 ; jsr $02FBD6
    nop
    lea     $0020(sp),sp
.l2f858:                                                ; $02F858
    tst.w   d6
    ble.b   .l2f898
    cmpi.w  #$1,d6
    bne.b   .l2f86a
    pea     ($00044744).l
    bra.b   .l2f870
.l2f86a:                                                ; $02F86A
    pea     ($0004473A).l
.l2f870:                                                ; $02F870
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($00047C74).l,-(sp)
    move.l  a3,-(sp)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3,-(sp)
    pea     ($0003).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0346                                 ; jsr $02FBD6
    nop
    lea     $0020(sp),sp
.l2f898:                                                ; $02F898
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0004).w
    move.l  ($00047B44).l,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0018(sp),sp
    tst.w   d0
    bne.b   .l2f8dc
    move.w  #$1,($00FF99A0).l
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0158                                 ; jsr $02FA28
    nop
    lea     $000c(sp),sp
    dc.w    $6000,$013a                                 ; bra.w $02FA14
.l2f8dc:                                                ; $02F8DC
    clr.w   d5
    clr.w   d3
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00047b6c,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00047b60,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($00047B40).l,-(sp)
    move.l  a3,-(sp)
    jsr     (a5)
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0028(sp),sp
    cmpi.w  #$1,d0
    dc.w    $6600,$00e2                                 ; bne.w $02FA08
    moveq   #$2,d5
    move.w  d3,d0
    ext.l   d0
    moveq   #$3,d1
    cmp.l   d1,d0
    dc.w    $6200,$00d6                                 ; bhi.w $02FA0A
    add.l   d0,d0
    move.w  $2f940(pc,d0.l),d0
    jmp     $2f940(pc,d0.w)
    ; WARNING: 232 undecoded trailing bytes at $02F940
    dc.w    $0008
    dc.w    $0018
    dc.w    $00aa
    dc.w    $00b8
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0676
    dc.w    $4e71
    dc.w    $588f
    dc.w    $6000
    dc.w    $00b4
    dc.w    $4a44
    dc.w    $6638
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0004
    dc.w    $2f39
    dc.w    $0004
    dc.w    $7b9c
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0018
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6600
    dc.w    $0088
    dc.w    $3004
    dc.w    $2f00
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0e70
    dc.w    $4e71
    dc.w    $508f
    dc.w    $6076
    dc.w    $3004
    dc.w    $48c0
    dc.w    $72fe
    dc.w    $b280
    dc.w    $66e4
    dc.w    $4879
    dc.w    $0004
    dc.w    $472e
    dc.w    $2f39
    dc.w    $0004
    dc.w    $7b98
    dc.w    $2f0b
    dc.w    $4e95
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0004
    dc.w    $2f0b
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0024
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0004
    dc.w    $2f39
    dc.w    $0004
    dc.w    $7be0
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0018
    dc.w    $6020
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $8214
    dc.w    $6000
    dc.w    $ff5c
    dc.w    $3006
    dc.w    $2f00
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $861a
    dc.w    $6088
    dc.w    $7a01
    dc.w    $5243
    dc.w    $0c43
    dc.w    $0004
    dc.w    $6d00
    dc.w    $fece
    dc.w    $3002
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0132
    dc.w    $4e71
    dc.w    $4cee
    dc.w    $3c7c
    dc.w    $ff3c
    dc.w    $4e5e
    dc.w    $4e75

; === Translated block $02FA28-$02FBD6 ===
; 2 functions, 430 bytes
