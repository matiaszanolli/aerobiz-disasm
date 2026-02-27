; ============================================================================
; AnimateInfoPanel -- Animate the info panel with a 3-step slide-in effect, alternating between init and step calls with GameCommand $E between each step.
; Called: 7 times.
; 98 bytes | $023958-$0239B9
; ============================================================================
AnimateInfoPanel:                                                  ; $023958
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d3
    movea.l $0010(sp),a2
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$004e                                 ; jsr $0239BA
    nop
    addq.l  #$8,sp
    clr.w   d2
.l23974:                                                ; $023974
    pea     ($0006).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$00aa                                 ; jsr $023A34
    nop
    pea     ($0006).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$0016                                 ; jsr $0239BA
    nop
    lea     $0020(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    bcs.b   .l23974
    movem.l (sp)+,d2-d3/a2
    rts
    dc.w    $48E7,$3030,$262F                                ; $0239BA
; === Translated block $0239C0-$023A34 ===
; 1 functions, 116 bytes
