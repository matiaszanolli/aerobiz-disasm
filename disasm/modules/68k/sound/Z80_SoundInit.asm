; ============================================================================
; Z80_SoundInit -- Load Z80 sound driver from ROM into Z80 RAM
; ============================================================================
; Copies Z80 driver from ROM ($2696-$3BE7, 5458 bytes) into Z80 RAM ($A00000).
; Handles bus arbitration and Z80 reset sequencing.
; Called once during boot initialization.
; ============================================================================
Z80_SoundInit:                                               ; $00260A
    move    sr,-(sp)                                         ; Save SR
    ori     #$0700,sr                                        ; Disable all interrupts
    movea.l #Z80_BUSREQ,a0                                   ; A0 -> Z80 bus req port ($A11100)
    move.w  #$0100,(a0)                                      ; Request Z80 bus
    move.w  #$0100,$0100(a0)                                 ; Assert Z80 reset ($A11200)
.poll_bus:                                                   ; $002620
    btst    #0,(a0)                                          ; Check bus grant
    bne.s   .poll_bus                                        ; Poll until granted
    dc.w    $41FA,$15C0                                      ; lea SoundDriverEnd(pc),a0  [$3BE8]
    nop
    dc.w    $43FA,$0068                                      ; lea SoundDriverStart(pc),a1 [$2696]
    nop
    suba.l  a1,a0                                            ; A0 = driver size (end - start)
    move.l  a0,d0                                            ; D0 = byte count for copy loop
    movea.l #Z80_RAM,a0                                      ; A0 -> Z80 RAM destination ($A00000)
    jsr (Z80_RequestBus,PC)
    nop
.copy_loop:                                                  ; $002642
    move.b  (a1)+,(a0)+                                      ; Copy driver byte to Z80 RAM
    dbra    d0,.copy_loop                                    ; Loop until done
    movea.l #Z80_BUSREQ,a0                                   ; A0 -> Z80 bus req port
    move.w  #$0000,$0100(a0)                                 ; Release Z80 reset ($A11200=0)
    move.w  #$0000,(a0)                                      ; Release Z80 bus ($A11100=0)
    move.w  #$0100,$0100(a0)                                 ; Deassert Z80 reset ($A11200=$100)
    move    (sp)+,sr                                         ; Restore SR
    rts
