; ============================================================================
; Z80_ReleaseBus -- Release Z80 bus
; ============================================================================
Z80_ReleaseBus:                                              ; $002678
    move.l  a1,-(sp)                                         ; Save A1
    movea.l #Z80_BUSREQ,a1                                   ; A1 -> Z80 bus req port
    move.w  #$0000,(a1)                                      ; Release bus
    movea.l (sp)+,a1                                         ; Restore A1
    rts
