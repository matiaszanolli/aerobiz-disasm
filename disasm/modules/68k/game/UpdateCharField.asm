; ============================================================================
; UpdateCharField -- Write low nibble to struct byte[2], compute compat score, clamp to byte[3] max
; Called: 8 times.
; 92 bytes | $0073A6-$007401
; ============================================================================
UpdateCharField:                                                  ; $0073A6
    movem.l d2/a2,-(sp)
    move.l  $0010(sp),d2
    movea.l $000c(sp),a2
    andi.b  #$f0,$0002(a2)
    move.b  d2,d0
    or.b    d0,$0002(a2)
    move.l  a2,-(sp)
    dc.w    $4eba,$0050                                 ; jsr $007412
    nop
    addq.l  #$4,sp
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.b  d0,$000b(a2)
    move.b  $0003(a2),d0
    cmp.b   $000b(a2),d0
    bcc.b   .l73f2
    moveq   #$0,d0
    move.b  $0003(a2),d0
    bra.b   .l73f8
.l73f2:                                                 ; $0073F2
    moveq   #$0,d0
    move.b  $000b(a2),d0
.l73f8:                                                 ; $0073F8
    move.b  d0,$0003(a2)
    movem.l (sp)+,d2/a2
    rts
; === GetLowNibble ($007402, 16B) ===
GetLowNibble:                                                         ; $007402
    MOVEA.L $4(SP),A0
    MOVE.B  $2(A0),D1
    ANDI.W  #$000F,D1
    MOVE.W  D1,D0
    RTS
