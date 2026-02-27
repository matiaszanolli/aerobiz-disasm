; ============================================================================
; PostTurnCleanup -- Scans end-of-turn event list, matches char types, formats and displays event result messages
; 390 bytes | $031EC4-$032049
; ============================================================================
PostTurnCleanup:
    link    a6,#-$A0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l $c(a6), a2
    lea     -$a0(a6), a3
    movea.l  #$0002FBD6,a4
    movea.l  #$0003B22C,a5
    move.b  (a2), d5
    move.b  $1(a2), d4
    movea.l  #$00FF09C2,a2
    clr.w   d3
.l31ef2:
    cmpi.b  #$ff, (a2)
    beq.w   .l31fd8
    clr.w   d6
    moveq   #$0,d0
    move.b  (a2), d0
    beq.b   .l31f0c
    moveq   #$1,d1
    cmp.b   d1, d0
    beq.b   .l31f6c
    bra.w   .l31fd8
.l31f0c:
    clr.w   d2
.l31f0e:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    add.w   d2, d0
    movea.l  #$0005F9E1,a0
    move.b  (a0,d0.w), d0
    cmp.b   d5, d0
    beq.b   .l31f3e
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    add.w   d2, d0
    movea.l  #$0005F9E1,a0
    move.b  (a0,d0.w), d0
    cmp.b   d4, d0
    bne.b   .l31f42
.l31f3e:
    moveq   #$1,d6
    bra.b   .l31f4a
.l31f42:
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   .l31f0e
.l31f4a:
    cmpi.w  #$1, d6
    bne.w   .l31fd8
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047CD4).l, -(a7)
    bra.b   .l31fc2
.l31f6c:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    cmp.b   d5, d0
    beq.b   .l31f98
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    cmp.b   d4, d0
    bne.b   .l31fd8
.l31f98:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047CD8).l, -(a7)
.l31fc2:
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $1c(a7), a7
.l31fd8:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$2, d3
    blt.w   .l31ef2
    movea.l  #$00FF09CA,a2
    tst.b   (a2)
    bne.b   .l32040
    move.b  $1(a2), d3
    cmp.b   d5, d3
    beq.b   .l31ffa
    cmp.b   d4, d3
    bne.b   .l32040
.l31ffa:
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr ClassifyEvent
    move.w  d0, d2
    moveq   #$0,d0
    move.b  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047D94,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047CDC).l, -(a7)
    move.l  a3, -(a7)
    jsr     (a5)
    pea     ($0002).w
    move.l  a3, -(a7)
    pea     ($0001).w
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr     (a4)
.l32040:
    movem.l -$c8(a6), d2-d7/a2-a5
    unlk    a6
    rts

RunAIStrategy:                                                  ; $03204A
    movem.l d2/a2,-(sp)
    move.w  #$3,($00FFA7DA).l
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0154                                 ; jsr $0321DC
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0304                                 ; jsr $032398
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0772                                 ; jsr $032812
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0682                                 ; jsr $03272E
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1554                                 ; jsr $03360C
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$32fc                                 ; jsr $0353C0
    nop
    moveq   #$0,d0
    move.b  $0004(a2),d0
    moveq   #$0,d1
    move.b  $0005(a2),d1
    add.l   d1,d0
    moveq   #$28,d1
    cmp.l   d0,d1
    ble.b   .l320ea
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1f4a                                 ; jsr $03402E
    nop
    bra.b   .l320f6
.l320ea:                                                ; $0320EA
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$29ce                                 ; jsr $034AC0
    nop
.l320f6:                                                ; $0320F6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$150e                                 ; jsr $03360C
    nop
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$3674                                 ; jsr $035782
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$32a6                                 ; jsr $0353C0
    nop
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$2e60                                 ; jsr $034F8A
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$344e                                 ; jsr $035584
    nop
    addq.l  #$8,sp
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  #$01f4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$01f4,d0
    cmp.l   $0006(a2),d0
    ble.b   .l3216a
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$3718                                 ; jsr $03587C
    nop
    addq.l  #$4,sp
.l3216a:                                                ; $03216A
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  #$1f40,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$3e80,d0
    cmp.l   $0006(a2),d0
    bge.b   .l32198
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$405e                                 ; jsr $0361F0
    nop
    addq.l  #$4,sp
.l32198:                                                ; $032198
    dc.w    $4eba,$4040                                 ; jsr $0361DA
    nop
    cmpi.w  #$14,d0
    bls.b   .l321c8
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    moveq   #$1,d1
    cmp.l   d0,d1
    bne.b   .l321c8
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$46d2                                 ; jsr $036894
    nop
    addq.l  #$4,sp
.l321c8:                                                ; $0321C8
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$388e                                 ; jsr $035A5E
    nop
    addq.l  #$4,sp
    movem.l (sp)+,d2/a2
    rts
    dc.w    $48E7,$303C; $0321DC
; === Translated block $0321E0-$032D7A ===
; 11 functions, 2970 bytes
