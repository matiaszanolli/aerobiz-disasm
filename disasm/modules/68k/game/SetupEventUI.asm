; ============================================================================
; SetupEventUI -- Set up the event UI layout by conditionally enabling a display mode and running multiple initialization phases via dedicated UI setup functions.
; Called: ?? times.
; 84 bytes | $0225B8-$02260B
; ============================================================================
SetupEventUI:                                                  ; $0225B8
    move.l  a2,-(sp)
    movea.l #$0002260c,a2
    dc.w    $4eba,$1166                                 ; jsr $023728
    nop
    cmpi.w  #$1,d0
    bne.b   .l225dc
    pea     ($0001).w
    pea     ($0010).w
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    addq.l  #$8,sp
.l225dc:                                                ; $0225DC
    clr.l   -(sp)
    jsr     (a2)
    pea     ($0001).w
    jsr     (a2)
    dc.w    $4eba,$0722                                 ; jsr $022D0A
    nop
    dc.w    $4eba,$09da                                 ; jsr $022FC8
    nop
    pea     ($0004).w
    jsr     (a2)
    pea     ($0002).w
    jsr     (a2)
    pea     ($0003).w
    jsr     (a2)
    lea     $0014(sp),sp
    movea.l (sp)+,a2
    rts
    dc.w    $48E7,$3020                                      ; $02260C

; === Translated block $022610-$0232B6 ===
; 8 functions, 3238 bytes
