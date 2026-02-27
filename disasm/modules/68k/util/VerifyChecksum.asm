; ============================================================================
; VerifyChecksum -- Load save buffer from SRAM, compute checksum, compare against stored value, return 1 if valid or 0 if corrupt
; Called: ?? times.
; 88 bytes | $00F552-$00F5A9
; ============================================================================
VerifyChecksum:                                                  ; $00F552
    movem.l d2/a2-a3,-(sp)
    move.l  $0010(sp),d2
    movea.l #$00ff1804,a3
    pea     ($2000).w
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$d,d1
    lsl.l   d1,d0
    addi.l  #$00200003,d0
    move.l  d0,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0001,$e0fe                           ; jsr $01E0FE
    movea.l a3,a2
    move.w  $0004(a2),d0
    move.l  d0,-(sp)
    move.l  a3,d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$d6fc                           ; jsr $01D6FC
    lea     $0014(sp),sp
    cmp.w   $0002(a2),d0
    bne.b   .lf5a2
    moveq   #$1,d0
    bra.b   .lf5a4
.lf5a2:                                                 ; $00F5A2
    moveq   #$0,d0
.lf5a4:                                                 ; $00F5A4
    movem.l (sp)+,d2/a2-a3
    rts
