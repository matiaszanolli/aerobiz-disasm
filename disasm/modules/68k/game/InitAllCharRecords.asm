; ============================================================================
; InitAllCharRecords -- Optionally calls HandleEventCallback to copy event stats, then iterates all 89 character slots calling InitCharRecord on each
; 42 bytes | $01819C-$0181C5
; ============================================================================
InitAllCharRecords:                                                  ; $01819C
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    tst.w   d2
    beq.b   .l181aa
    bsr.w HandleEventCallback
.l181aa:                                                ; $0181AA
    clr.w   d2
.l181ac:                                                ; $0181AC
    clr.l   -(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0012                                 ; jsr $0181C6
    nop
    addq.l  #$8,sp
    addq.w  #$1,d2
    cmpi.w  #$59,d2
    bcs.b   .l181ac
    move.l  (sp)+,d2
    rts
