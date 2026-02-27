; ============================================================================
; DrawRouteLines -- Draw color-coded route lines between city map positions for all of a player's active routes
; Called: ?? times.
; 194 bytes | $0098D2-$009993
; ============================================================================
DrawRouteLines:                                                  ; $0098D2
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0028(sp),d2
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
.l98ee:                                                 ; $0098EE
    cmpi.b  #$ff,(a2)
    beq.w   .l9980
    moveq   #$0,d0
    move.b  (a2),d0
    add.w   d0,d0
    movea.l #$0005e948,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d0
    movea.l #$0005e948,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.b  (a4),d0
    cmp.b   (a3),d0
    bcc.b   .l9938
    moveq   #$0,d7
    move.b  (a4),d7
    moveq   #$0,d6
    move.b  $0001(a4),d6
    moveq   #$0,d5
    move.b  (a3),d5
    moveq   #$0,d4
    move.b  $0001(a3),d4
    bra.b   .l994c
.l9938:                                                 ; $009938
    moveq   #$0,d5
    move.b  (a4),d5
    moveq   #$0,d4
    move.b  $0001(a4),d4
    moveq   #$0,d7
    move.b  (a3),d7
    moveq   #$0,d6
    move.b  $0001(a3),d6
.l994c:                                                 ; $00994C
    move.w  $000e(a2),d0
    cmp.w   $0006(a2),d0
    bcs.b   .l995a
    moveq   #$1,d3
    bra.b   .l995c
.l995a:                                                 ; $00995A
    moveq   #$2,d3
.l995c:                                                 ; $00995C
    pea     ($00FF1804).l
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dc26                           ; jsr $01DC26
    lea     $0018(sp),sp
.l9980:                                                 ; $009980
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$28,d2
    blt.w   .l98ee
    movem.l (sp)+,d2-d7/a2-a4
    rts
