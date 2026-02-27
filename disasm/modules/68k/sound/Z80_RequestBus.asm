; ============================================================================
; Z80_RequestBus -- Request and wait for Z80 bus ownership
; ============================================================================
Z80_RequestBus:                                              ; $002662
    move.l  a0,-(sp)                                         ; Save A0
    movea.l #Z80_BUSREQ,a0                                   ; A0 -> Z80 bus req port
    move.w  #$0100,(a0)                                      ; Request bus
.poll:                                                       ; $00266E
    btst    #0,(a0)                                          ; Check grant bit
    bne.s   .poll                                            ; Wait until granted
    movea.l (sp)+,a0                                         ; Restore A0
    rts
