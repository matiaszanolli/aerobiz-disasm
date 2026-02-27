; ============================================================================
; DispatchVDPWrite -- Write scroll data to VDP then wait for FIFO idle before continuing
; 56 bytes | $001126-$00115D
; ============================================================================
DispatchVDPWrite:
    jsr (ConfigVDPScroll,PC)
    nop
l_0112c:
    move.w  (a4), d1
    btst    #$1, d1
    bne.b   l_0112c
    bra.w   l_0116a
VDPWriteColorsPath:                                          ; $001138
    jsr (ConfigVDPColors,PC)
    nop
l_0113e:
    move.w  (a4), d1
    btst    #$1, d1
    bne.b   l_0113e
    bra.w   l_0116a
VDPWriteZ80Path:                                             ; $00114A
    movea.l  #$00A11100,a2
    move.w  #$100, (a2)
l_01154:
    move.w  (a2), d0
    andi.w  #$100, d0
    bne.b   l_01154
    rts
