; ============================================================================
; FindBestCharValue -- Returns highest $FFA6B8 cost field among recruitables that are in the current age window
; 122 bytes | $035CCC-$035D45
; ============================================================================
FindBestCharValue:                                                  ; $035CCC
    movem.l d2-d5/a2,-(sp)
    move.l  $0018(sp),d5
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l35ce0
    addq.l  #$3,d0
.l35ce0:                                                ; $035CE0
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d4
    clr.w   d3
    movea.l #$00ffa6b8,a2
    clr.w   d2
.l35cf2:                                                ; $035CF2
    moveq   #$0,d0
    move.b  $0006(a2),d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4,d1
    cmp.l   d1,d0
    bgt.b   .l35d32
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0007(a2),d1
    ext.l   d1
    cmp.l   d1,d0
    bge.b   .l35d32
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$8016                           ; jsr $008016
    addq.l  #$8,sp
    cmpi.w  #$ffff,d0
    beq.b   .l35d32
    cmp.w   $0002(a2),d3
    bcc.b   .l35d32
    move.w  $0002(a2),d3
.l35d32:                                                ; $035D32
    moveq   #$c,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    bcs.b   .l35cf2
    move.w  d3,d0
    movem.l (sp)+,d2-d5/a2
    rts
; === Translated block $035D46-$0366D0 ===
; 10 functions, 2442 bytes
