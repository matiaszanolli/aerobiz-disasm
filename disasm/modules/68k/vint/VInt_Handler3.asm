; ============================================================================
; VInt_Handler3 -- V-INT sub-handler: read VRAM rows back into a RAM buffer over multiple passes
; 124 bytes | $001404-$00147F
; ============================================================================
VInt_Handler3:
    movea.l $54(a5), a2
    movea.l  #$00C00000,a3
    movea.l  #$00C00004,a4
    moveq   #$0,d2
    move.l  d2, d3
    moveq   #$3,d7
    move.b  $4c(a5), d2
    move.b  $4d(a5), d3
    move.l  $4e(a5), d0
    move.l  #$400000, d5
    move.b  $10(a5), d4
    andi.b  #$3, d4
    beq.b   l_01448
    cmpi.b  #$1, d4
    bne.b   l_01440
    lsl.l   #$1, d5
    bra.b   l_01448
l_01440:
    cmpi.b  #$3, d4
    bne.b   l_01448
    lsl.l   #$2, d5
l_01448:
    subq.w  #$1, d2
    move.w  #$8f02, (a4)
    move.l  d0, (a4)
l_01450:
    move.w  (a3), d4
    move.w  d4, (a2)+
    dbra    d2, $1450
    add.l   d5, d0
    move.l  d0, $4e(a5)
    moveq   #$0,d2
    move.b  $4c(a5), d2
    subq.w  #$1, d3
    beq.b   l_01478
    dbra    d7, $1448
    move.l  a2, d1
    move.l  d1, $54(a5)
    move.b  d3, $4d(a5)
    bra.b   l_0147e
l_01478:
    move.b  #$0, $2b(a5)
l_0147e:
    rts


; ===========================================================================
; EXT Interrupt Handler ($001480-$001483) -- Level 2 (unused)
; ===========================================================================

ExtInterrupt:                                               ; $001480
    nop
    rte

; ===========================================================================
; H-Blank Interrupt Handler ($001484-$0014E5) -- Level 4
; Raster scroll effect: per-scanline VSRAM updates for scroll A/B
; ===========================================================================

HBlankInt:                                                  ; $001484
    move    sr,-(sp)                                        ; save status register
    ori     #$0700,sr                                       ; disable all interrupts
    movem.l d0-d2/a0/a5,-(sp)                              ; save working registers
    movea.l #$00FFF010,a5                                   ; A5 = work RAM base
    move.w  $0C50(a5),d0                                    ; D0 = H-scroll line counter
    addq.w  #1,d0                                           ; increment counter
    move.w  d0,$0C50(a5)                                    ; store back
    move.w  d0,d1                                           ; D1 = line counter (for offset)
    add.w   d0,d0                                           ; D0 = word index (counter * 2)
    btst    #0,$0C46(a5)                                    ; scroll effect enabled?
    beq.s   .restore                                        ; skip update if disabled
    movea.l $0C48(a5),a0                                    ; A0 = scroll table B pointer
    move.w  0(a0,d0.w),d2                                   ; D2 = scroll B value for this line
    sub.w   d1,d2                                           ; adjust by scanline
    movea.l $0C4C(a5),a0                                    ; A0 = scroll table A pointer
    move.w  0(a0,d0.w),d0                                   ; D0 = scroll A value for this line
    sub.w   d1,d0                                           ; adjust by scanline
    move.l  #$40000010,VDP_CTRL                             ; VSRAM write at address 0
    move.w  d2,VDP_DATA                                     ; write scroll B value
    move.l  #$40020010,VDP_CTRL                             ; VSRAM write at address 2
    move.w  d0,VDP_DATA                                     ; write scroll A value
.restore:                                                   ; $0014DE
    movem.l (sp)+,d0-d2/a0/a5                              ; restore working registers
    move    (sp)+,sr                                        ; restore status register
    rte

; ===========================================================================
; V-Blank Interrupt Handler ($0014E6-$0015AF) -- Level 6
; Main per-frame handler: DMA, display, input, subsystem updates
; ===========================================================================

VBlankInt:                                                  ; $0014E6
    movem.l d0-d7/a0-a7,-(sp)                              ; save ALL registers
    move.l  sp,d0                                           ; D0 = current stack pointer
    cmpi.l  #$00FFE000,d0                                   ; stack overflow guard
    dc.w    $6500,$0434                                     ; bcs.w VInt_Emergency ($001928)
    movea.l #$00FFF010,a5                                   ; A5 = work RAM base
    movea.l #$00C00004,a4                                   ; A4 = VDP control port
    move.w  #0,$0C50(a5)                                    ; reset H-scroll line counter
; --- DMA/VRAM transfer ---
    btst    #0,$004B(a5)                                    ; DMA transfer pending?
    beq.s   .no_dma
    bsr.w DMA_Transfer
    bclr    #0,$004B(a5)                                    ; clear DMA flag
; --- Display update ---
.no_dma:                                                    ; $00151A
    moveq   #0,d0
    move.b  $0B2A(a5),d0                                    ; display update flag
    beq.s   .no_display
    bsr.w DisplayUpdate
; --- Subsystem 1 ---
.no_display:                                                ; $001526
    moveq   #0,d0
    move.b  $0BD4(a5),d0
    beq.s   .no_sub1
    bsr.w VInt_Sub1
; --- Subsystem 2 ---
.no_sub1:                                                   ; $001532
    move.w  $0BCE(a5),d0                                    ; word flag
    beq.w   .no_sub2
    bsr.w VInt_Sub2
; --- Controller/input read ---
.no_sub2:                                                   ; $00153E
    moveq   #0,d0
    move.b  $02FB(a5),d0                                    ; input enable flag
    beq.s   .no_input
    bsr.w ControllerRead
; --- Multi-dispatch on $002B(A5) bits 0/1/2 ---
.no_input:                                                  ; $00154A
    moveq   #0,d0
    move.b  $002B(a5),d0                                    ; dispatch flags
    beq.w   .poll                                           ; skip if no bits set
    btst    #0,$002B(a5)                                    ; bit 0 set?
    beq.s   .try_bit1
    bsr.w VInt_Handler1
    moveq   #0,d0
    move.b  d0,$002B(a5)                                    ; clear all dispatch flags
    bra.s   .poll
.try_bit1:                                                  ; $001568
    btst    #1,$002B(a5)                                    ; bit 1 set?
    beq.s   .try_bit2
    bsr.w VInt_Handler2
    bra.s   .poll
.try_bit2:                                                  ; $001576
    btst    #2,$002B(a5)                                    ; bit 2 set?
    beq.s   .poll
    bsr.w VInt_Handler3
; --- Controller poll + 4 subsystem updates (always run) ---
.poll:                                                      ; $001582
    dc.w    $43F9,$00FF,$FBFC                               ; lea $00FFFBFC,a1
    bsr.w ControllerPoll
    jsr (SubsysUpdate1,PC)
    nop
    jsr (SubsysUpdate2,PC)
    nop
    jsr (SubsysUpdate3,PC)
    nop
    jsr (SubsysUpdate4,PC)
    nop
    move.b  #0,$0036(a5)                                    ; clear V-INT processed flag
    movem.l (sp)+,d0-d7/a0-a7                              ; restore ALL registers
    rte
; === Translated block $0015B0-$00260A ===
; 29 functions, 4186 bytes
