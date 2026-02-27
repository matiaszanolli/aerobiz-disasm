; ============================================================================
; CalcRelationValue -- Looks up compatibility score between two chars, scales by relation-type factor (attacker-only/defender-only/combined), and applies a seasonal modifier from $FF0006
; Called: 7 times.
; 264 bytes | $01A506-$01A60D
; ============================================================================
CalcRelationValue:                                                  ; $01A506
    movem.l d2-d6/a2,-(sp)
    move.l  $001c(sp),d3
    move.l  $0024(sp),d5
    move.l  $0020(sp),d6
    movea.l #$00ff1298,a2
    moveq   #$0,d0
    move.w  d6,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7610                           ; jsr $007610
    addq.l  #$8,sp
    move.w  d0,d2
    moveq   #$0,d4
    move.w  d2,d4
    move.l  d4,d0
    lsl.l   #$2,d4
    add.l   d0,d4
    add.l   d4,d4
    move.l  d4,d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d4
    addi.l  #$2710,d4
    moveq   #$0,d2
    cmpi.w  #$1,d5
    bne.b   .l1a57c
    moveq   #$0,d0
    move.w  d3,d0
.l1a55c:                                                ; $01A55C
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a2,a0.l),d0
    andi.l  #$ff,d0
    move.l  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    bra.b   .l1a5da
.l1a57c:                                                ; $01A57C
    cmpi.w  #$2,d5
    bne.b   .l1a588
    moveq   #$0,d0
    move.w  d6,d0
    bra.b   .l1a55c
.l1a588:                                                ; $01A588
    cmpi.w  #$3,d5
    bne.b   .l1a5dc
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a2,a0.l),d0
    andi.l  #$ff,d0
    move.l  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a2,a0.l),d0
    andi.l  #$ff,d0
    move.l  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d2
    move.l  d3,d0
    add.l   d2,d0
.l1a5da:                                                ; $01A5DA
    move.l  d0,d2
.l1a5dc:                                                ; $01A5DC
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d0,d3
    move.l  d2,d0
    move.l  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d2
    movem.l (sp)+,d2-d6/a2
    rts
