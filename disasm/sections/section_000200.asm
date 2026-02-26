; ===========================================================================
; ROM Data: $000200-$00FFFF
; 65024 bytes (32512 words)
; ===========================================================================


; --- Reset vector -- program entry point ---
EntryPoint:
    dc.w    $4AB9,$00A1,$0008,$6606,$4A79,$00A1,$000C,$667C; $000200
    dc.w    $4BFA,$007C,$4C9D,$00E0,$4CDD,$1F00,$1029,$EF01; $000210
    dc.w    $0200,$000F,$6708,$237C,$5345,$4741,$2F00,$3014; $000220
    dc.w    $7000,$2C40,$4E66,$7217,$1A1D,$3885,$DA47,$51C9; $000230
    dc.w    $FFF8,$289D,$3680,$3287,$3487,$0111,$66FC,$7425; $000240
    dc.w    $10DD,$51CA,$FFFC,$3480,$3280,$3487,$2D00,$51CE; $000250
    dc.w    $FFFC,$289D,$289D,$761F,$2680,$51CB,$FFFC,$289D; $000260
    dc.w    $7813,$2680,$51CC,$FFFC,$7A03,$175D,$0011,$51CD; $000270
    dc.w    $FFFA,$3480,$4CD6,$7FFF,$46FC,$2700,$606C,$8000; $000280
    dc.w    $3FFF,$0100,$00A0,$0000,$00A1,$1100,$00A1,$1200; $000290
    dc.w    $00C0,$0000,$00C0,$0004,$0414,$303C,$076C,$0000; $0002A0
    dc.w    $0000,$FF00,$8137,$0001,$0100,$00FF,$FF00,$0080; $0002B0
    dc.w    $4000,$0080,$AF01,$D91F,$1127,$0021,$2600,$F977; $0002C0
    dc.w    $EDB0,$DDE1,$FDE1,$ED47,$ED4F,$D1E1,$F108,$D9C1; $0002D0
    dc.w    $D1E1,$F1F9,$F3ED,$5636,$E9E9,$8104,$8F02,$C000; $0002E0
    dc.w    $0000,$4000,$0010,$9FBF,$DFFF                   ; $0002F0 (end of data table)

; ===========================================================================
; Post-Boot Initialization ($0002FA-$0003A0)
; Wait for V-Blank, init work RAM, call init subroutines, enter game
; ===========================================================================

    tst.w   VDP_CTRL                                        ; $0002FA: read/clear VDP status
.vblank_wait:                                               ; $000300
    dc.w    $6100,$09DA                                     ; bsr.w WaitVBlank ($000CDC)
    andi.w  #$0002,d0                                       ; check status bit 1
    bne.s   .vblank_wait                                    ; loop while set
; --- Early init (RAM/VDP setup) ---
    dc.w    $6100,$38DC                                     ; bsr.w EarlyInit ($003BE8)
; --- Set up work RAM base and clear game state flags ---
    moveq   #0,d0                                           ; D0 = 0 (clear value)
    movea.l #$00FFF010,a5                                   ; A5 = work RAM base pointer
    move.b  d0,$02FB(a5)                                    ; clear input enable flag
    move.b  d0,$0B2A(a5)                                    ; clear display update flag
    move.b  d0,$001C(a5)                                    ; clear flag
    move.b  d0,$002B(a5)                                    ; clear V-INT dispatch flags
    move.b  d0,$004B(a5)                                    ; clear DMA pending flag
    move.w  d0,$0BCE(a5)                                    ; clear word flag
    move.l  d0,$0BD0(a5)                                    ; clear long
    move.b  d0,$0BD4(a5)                                    ; clear V-INT sub1 flag
    move.w  d0,$0C70(a5)                                    ; clear word
; --- Hardware init subroutine ---
    dc.w    $4EBA,$03CE                                     ; jsr HardwareInit(pc) ($00070A)
    nop
; --- Test expansion controller ---
    btst    #6,IO_CTRL3                                     ; expansion controller present?
    bne.w   .copy_ram_sub                                   ; skip nop if yes
    nop
; --- Copy 10-byte subroutine from ROM to Work RAM ---
.copy_ram_sub:                                              ; $00034E
    movea.l #$00FFF000,a0                                   ; A0 = RAM target ($FFF000)
    movea.l #$00000362,a1                                   ; A1 = ROM source (inline below)
    move.l  (a1)+,(a0)+                                     ; copy bytes 0-3
    move.l  (a1)+,(a0)+                                     ; copy bytes 4-7
    move.w  (a1),(a0)                                       ; copy bytes 8-9
    bra.s   .init_subs                                      ; skip over inline data
; --- Inline RAM subroutine data (copied to $FFF000, 10 bytes) ---
    dc.w    $38AD,$0042                                     ; move.w $0042(a5),(a4)
    dc.w    $38AD,$0044                                     ; move.w $0044(a5),(a4)
    rts                                                     ; $00036A
; --- Init subroutine calls ---
.init_subs:                                                 ; $00036C
    dc.w    $4EBA,$0CC8                                     ; jsr VDP_Init1(pc) ($001036)
    nop
    dc.w    $4EBA,$0CA8                                     ; jsr VDP_Init2(pc) ($00101C)
    nop
    dc.w    $4EBA,$0D00                                     ; jsr VDP_Init3(pc) ($00107A)
    nop
    dc.w    $4EBA,$0D7E                                     ; jsr VDP_Init4(pc) ($0010FE)
    nop
    dc.w    $4EB9,$0000,$260A                               ; jsr Z80_SoundInit ($00260A)
    dc.w    $4EBA,$0D4E                                     ; jsr Init5(pc) ($0010DA)
    nop
    dc.w    $4EBA,$0CFE                                     ; jsr Init6(pc) ($001090)
    nop
; --- Enable interrupts and enter main game ---
    move    #$2000,sr                                       ; enable interrupts (supervisor mode)
    movea.l #$0000D5B6,a0                                   ; A0 = GameEntry address
    jmp     (a0)                                            ; ENTER MAIN GAME

; ---------------------------------------------------------------------------
; === Translated block $0003A2-$000D64 ===
; 18 functions, 2498 bytes

; ============================================================================
; CmdSetVDPReg -- (TODO: name)
; 26 bytes | $0003A2-$0003BB
; ============================================================================
CmdSetVDPReg:
    move.l  $e(a6), d0
    movea.l  #$00C00004,a4
    move.w  d0, (a4)
    move.w  d0, d1
    lsr.w   #$8, d1
    andi.b  #$7f, d1
    move.b  d0, (a5,d1.w)
    rts

; ============================================================================
; CmdSetScrollMode -- (TODO: name)
; 158 bytes | $0003BC-$000459
; ============================================================================
CmdSetScrollMode:
    move.l  $12(a6), d0
    move.l  $e(a6), d1
    bne.b   l_003e0
    move.w  d0, $38(a5)
    lsr.w   #$8, d0
    lsr.w   #$2, d0
    ori.w   #$8200, d0
    andi.b  #$38, d0
    move.w  d0, ($00C00004).l
    bra.w   l_00458
l_003e0:
    cmpi.b  #$1, d1
    bne.b   l_00400
    move.w  d0, $3a(a5)
    lsr.w   #$8, d0
    lsr.w   #$5, d0
    ori.w   #$8400, d0
    andi.b  #$7, d0
    move.w  d0, ($00C00004).l
    bra.w   l_00458
l_00400:
    cmpi.b  #$2, d1
    bne.b   l_0041e
    move.w  d0, $3c(a5)
    lsr.w   #$8, d0
    lsr.w   #$2, d0
    ori.w   #$8300, d0
    andi.b  #$3e, d0
    move.w  d0, ($00C00004).l
    bra.b   l_00458
l_0041e:
    cmpi.b  #$3, d1
    bne.b   l_0043c
    move.w  d0, $3e(a5)
    lsr.w   #$8, d0
    lsr.w   #$1, d0
    ori.w   #$8500, d0
    andi.b  #$7f, d0
    move.w  d0, ($00C00004).l
    bra.b   l_00458
l_0043c:
    cmpi.b  #$4, d1
    bne.b   l_00458
    move.w  d0, $40(a5)
    lsr.w   #$8, d0
    lsr.w   #$2, d0
    ori.w   #$8d00, d0
    andi.b  #$3f, d0
    move.w  d0, ($00C00004).l
l_00458:
    rts

; ============================================================================
; CmdGetVDPReg -- (TODO: name)
; 16 bytes | $00045A-$000469
; ============================================================================
CmdGetVDPReg:
    move.l  $e(a6), d1
    move.b  (a5,d1.w), d0
    andi.l  #$ff, d0
    rts

; ============================================================================
; CmdGetVDPStatus -- (TODO: name)
; 10 bytes | $00046A-$000473
; ============================================================================
CmdGetVDPStatus:
    movea.l  #$00C00008,a4
    move.w  (a4), d0
    rts

; ============================================================================
; CmdRunSubroutine -- (TODO: name)
; 8 bytes | $000474-$00047B
; ============================================================================
CmdRunSubroutine:
    dc.w    $4EBA,$182A                                 ; jsr $001CA0(pc)
    nop
    rts

; ============================================================================
; CmdSetupDMA -- (TODO: name)
; 116 bytes | $00047C-$0004EF
; ============================================================================
CmdSetupDMA:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  $e(a6), d0
    move.b  d0, $1d(a5)
    move.l  $12(a6), d0
    move.w  d0, $1e(a5)
    move.l  $16(a6), d0
    move.l  d0, $20(a5)
    move.l  $1a(a6), d0
    move.l  d0, $24(a5)
    move.l  d0, d1
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    swap    d1
    andi.l  #$3fff0000, d1
    or.l    d1, d0
    move.l  $1e(a6), d1
    move.b  d1, $37(a5)
    bne.b   l_004ca
    ori.l   #$40000080, d0
    bra.b   l_004e4
l_004ca:
    btst    #$0, d1
    beq.b   l_004d8
    ori.l   #$c0000080, d0
    bra.b   l_004e4
l_004d8:
    btst    #$1, d1
    beq.b   l_004ec
    ori.l   #$40000090, d0
l_004e4:
    move.l  d0, $42(a5)
    dc.w    $6100,$0C34                                 ; bsr.w $00111E
l_004ec:
    move.w  (a7)+, sr
    rts

; ============================================================================
; CmdTransferPlane -- (TODO: name)
; 48 bytes | $0004F0-$00051F
; ============================================================================
CmdTransferPlane:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  $e(a6), d0
    move.b  d0, $1d(a5)
    move.l  $12(a6), d0
    move.w  d0, $1e(a5)
    move.l  $16(a6), d0
    move.l  d0, $20(a5)
    move.l  $1a(a6), d0
    move.l  d0, $24(a5)
    dc.w    $4EBA,$0C0E                                 ; jsr $001126(pc)
    nop
    move.w  (a7)+, sr
    rts

; ============================================================================
; CmdLoadTiles -- (TODO: name)
; 48 bytes | $000520-$00054F
; ============================================================================
CmdLoadTiles:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  $e(a6), d0
    move.b  d0, $1d(a5)
    move.l  $12(a6), d0
    move.w  d0, $1e(a5)
    move.l  $16(a6), d0
    move.l  d0, $24(a5)
    move.l  $1a(a6), d0
    move.w  d0, $28(a5)
    dc.w    $4EBA,$0BF0                                 ; jsr $001138(pc)
    nop
    move.w  (a7)+, sr
    rts

; ============================================================================
; CmdSetupSprite -- (TODO: name)
; 168 bytes | $000550-$0005F7
; ============================================================================
CmdSetupSprite:
    move.l  $e(a6), d0
    move.b  d0, $2a(a5)
    move.l  $12(a6), d0
    move.l  d0, $30(a5)
    move.l  $1a(a6), d0
    move.w  d0, $34(a5)
    move.l  $22(a6), d2
    move.l  $16(a6), d1
    move.l  $1e(a6), d0
    bne.b   l_00598
    move.l  d1, d0
    lsl.l   #$2, d0
    swap    d0
    andi.l  #$3, d0
    andi.l  #$3fff, d1
    swap    d1
    or.l    d0, d1
    btst    #$0, d2
    bne.b   l_005d6
    bset    #$1e, d1
    bra.b   l_005d6
l_00598:
    btst    #$0, d0
    beq.b   l_005ba
    swap    d1
    andi.l  #$7f0000, d1
    btst    #$0, d2
    bne.b   l_005b4
    ori.l   #$c0000000, d1
    bra.b   l_005d6
l_005b4:
    bset    #$5, d1
    bra.b   l_005d6
l_005ba:
    btst    #$1, d0
    beq.b   l_005f6
    swap    d1
    andi.l  #$7f0000, d1
    bset    #$4, d1
    btst    #$0, d2
    bne.b   l_005d6
    bset    #$1e, d1
l_005d6:
    move.l  d1, $2c(a5)
    move.b  $1(a5), d0
    btst    #$5, d0
    bne.b   l_005e8
    bra.w   l_01346
l_005e8:
    move.b  #$1, d0
    move.b  d0, $2b(a5)
l_005f0:
    move.b  $2b(a5), d0
    bne.b   l_005f0
l_005f6:
    rts

; ============================================================================
; CmdCopyMemory -- (TODO: name)
; 20 bytes | $0005F8-$00060B
; ============================================================================
CmdCopyMemory:
    movea.l $e(a6), a4
    movea.l $12(a6), a3
    move.l  $16(a6), d0
l_00604:
    move.b  (a4)+, (a3)+
    subq.w  #$1, d0
    bne.b   l_00604
    rts

; ============================================================================
; CmdReadInput -- (TODO: name)
; 76 bytes | $00060C-$000657
; ============================================================================
CmdReadInput:
    move.l  $e(a6), d2
    andi.l  #$1, d2
    moveq   #$0,d0
    movea.l  #$00FFFC06,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_00634
    move.b  $4(a0, d2.w), d0
    asl.l   #$8, d0
    andi.l  #$ff00, d0
    move.b  $2(a0, d2.w), d0
l_00634:
    moveq   #$0,d1
    movea.l  #$00FFFC2E,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_00652
    move.b  $4(a0, d2.w), d1
    asl.l   #$8, d1
    andi.l  #$ff00, d1
    move.b  $2(a0, d2.w), d1
l_00652:
    swap    d1
    or.l    d1, d0
    rts

; ============================================================================
; CmdSetupObject -- (TODO: name)
; 152 bytes | $000658-$0006EF
; ============================================================================
CmdSetupObject:
    move.l  $26(a6), d0
    beq.w   l_006e2
    move.l  $16(a6), d0
    move.w  d0, $b26(a5)
    move.w  #$1, $b28(a5)
    move.l  $e(a6), d0
    move.b  d0, $b2b(a5)
    move.l  d0, d2
    move.l  d0, d4
    movea.l $1a(a6), a0
    move.l  $1e(a6), d7
    move.l  $22(a6), d6
    move.l  $12(a6), d1
    move.b  d1, $b2c(a5)
    subq.w  #$1, d1
    lsl.l   #$3, d0
    lsl.l   #$1, d2
    addi.w  #$7a, d0
    addi.w  #$b2e, d2
    addq.w  #$1, d4
l_0069e:
    move.w  (a0), d5
    add.w   d6, d5
    move.w  d5, (a5,d2.w)
    addq.w  #$2, d2
    move.w  (a0)+, d5
    add.w   d6, d5
    move.w  d5, (a5,d0.w)
    addq.w  #$2, d0
    move.w  (a0)+, d5
    andi.w  #$ff00, d5
    add.b   d4, d5
    move.w  d5, (a5,d0.w)
    addq.w  #$2, d0
    addq.w  #$1, d4
    move.w  (a0)+, (a5,d0.w)
    addq.w  #$2, d0
    move.w  (a0)+, d5
    add.w   d7, d5
    move.w  d5, (a5,d0.w)
    addq.w  #$2, d0
    dbra    d1, $69E
    moveq   #$1,d0
    move.b  d0, $b2a(a5)
    move.b  d0, $b2d(a5)
    bra.b   l_006ee
l_006e2:
    move.b  #$0, $b2a(a5)
    jmp     $7a4(pc)
    nop
l_006ee:
    rts

; ============================================================================
; CmdEnableDisplay -- (TODO: name)
; 26 bytes | $0006F0-$000709
; ============================================================================
CmdEnableDisplay:
    move.b  $1(a5), d0
    andi.w  #$ff, d0
    ori.w   #$8164, d0
    movea.l  #$00C00004,a4
    move.b  d0, $1(a5)
    move.w  d0, (a4)
    rts

; ============================================================================
; HardwareInit -- (TODO: name)
; 26 bytes | $00070A-$000723
; ============================================================================
HardwareInit:
    move.b  $1(a5), d0
    andi.w  #$9f, d0
    ori.w   #$8104, d0
    movea.l  #$00C00004,a4
    move.b  d0, $1(a5)
    move.w  d0, (a4)
    rts

; ============================================================================
; CmdWaitFrames -- (TODO: name)
; 38 bytes | $000724-$000749
; ============================================================================
CmdWaitFrames:
    move.b  $1(a5), d0
    btst    #$5, d0
    beq.b   l_00748
    move.l  $e(a6), d0
    moveq   #$1,d1
    bra.w   l_00744
l_00738:
    move.b  d1, $36(a5)
l_0073c:
    btst    #$0, $36(a5)
    bne.b   l_0073c
l_00744:
    dbra    d0, $738
l_00748:
    rts

; ============================================================================
; CmdUpdateSprites -- (TODO: name)
; 90 bytes | $00074A-$0007A3
; ============================================================================
CmdUpdateSprites:
    move.l  $e(a6), d0
    move.l  $12(a6), d1
    movea.l $16(a6), a0
    move.l  $1a(a6), d2
    move.l  $1e(a6), d3
    andi.l  #$ffff, d2
    swap    d3
    andi.l  #$ffff0000, d3
    movea.l  #$00FFF08A,a1
    lsl.l   #$3, d0
    bra.b   l_0078a
l_00776:
    move.l  (a0)+, d4
    add.l   d3, d4
    move.l  d4, (a1,d0.w)
    addq.w  #$4, d0
    move.l  (a0)+, d4
    add.w   d2, d4
    move.l  d4, (a1,d0.w)
    addq.w  #$4, d0
l_0078a:
    dbra    d1, $776
    dc.w    $4EBA,$0852                                 ; jsr $000FE2(pc)
    nop
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $4EBA,$0E3A                                 ; jsr $0015D6(pc)
    nop
    move.w  (a7)+, sr
    rts

; ============================================================================
; CmdClearSprites -- (TODO: name)
; 52 bytes | $0007A4-$0007D7
; ============================================================================
CmdClearSprites:
    move.l  $e(a6), d0
    move.l  $12(a6), d1
    moveq   #$0,d2
    lsl.l   #$3, d0
    movea.l  #$00FFF08A,a4
    bra.b   l_007be
l_007b8:
    move.w  d2, (a4,d0.w)
    addq.w  #$8, d0
l_007be:
    dbra    d1, $7B8
    dc.w    $4EBA,$081E                                 ; jsr $000FE2(pc)
    nop
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $4EBA,$0E06                                 ; jsr $0015D6(pc)
    nop
    move.w  (a7)+, sr
    rts

; ============================================================================
; CmdTestVRAM -- (TODO: name)
; 54 bytes | $0007D8-$00080D
; ============================================================================
CmdTestVRAM:
    movea.l $e(a6), a3
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $6100,$0966                                 ; bsr.w $00114A
    lea     $80e(pc), a4
    move.b  (a4), $6(a3)
    moveq   #$0,d0
    moveq   #$8,d1
l_007f2:
    move.b  (a4)+, (a3)
    nop
    nop
    move.b  (a3), d2
    and.b   (a4)+, d2
    beq.b   l_00800
    or.b    d1, d0
l_00800:
    lsr.b   #$1, d1
    bne.b   l_007f2
    dc.w    $4EBA,$0958                                 ; jsr $00115E(pc)
    nop
    move.w  (a7)+, sr
    rts

    dc.w    $400C; $00080E
    dc.w    $4003,$000C,$0003; $000810

; === Translated block $000816-$000D64 ===
; 16 functions, 1358 bytes

; ============================================================================
; func_000816 -- (TODO: name)
; 96 bytes | $000816-$000875
; ============================================================================
func_000816:
    move.l  $e(a6), d0
    andi.b  #$3, d0
    beq.b   l_00832
    cmpi.b  #$1, d0
    beq.b   l_0082c
    move.w  $3c(a5), d0
    bra.b   l_00836
l_0082c:
    move.w  $3a(a5), d0
    bra.b   l_00836
l_00832:
    move.w  $38(a5), d0
l_00836:
    move.l  $12(a6), d2
    andi.w  #$ff, d2
    lsl.l   #$1, d2
    add.w   d2, d0
    moveq   #$40,d1
    move.b  $10(a5), d6
    andi.l  #$3, d6
    beq.b   l_00862
    cmpi.b  #$1, d6
    beq.b   l_00860
    cmpi.b  #$3, d6
    beq.b   l_0085e
l_0085c:
    bra.b   l_0085c
l_0085e:
    lsl.l   #$1, d1
l_00860:
    lsl.l   #$1, d1
l_00862:
    move.l  $16(a6), d3
    andi.w  #$ff, d3
    muls.w  d3, d1
    add.w   d1, d0
    andi.l  #$ffff, d0
    rts

; ============================================================================
; CmdDMABatchWrite -- (TODO: name)
; 206 bytes | $000876-$000943
; ============================================================================
CmdDMABatchWrite:
    dc.w    $4EBA,$FF9E                                 ; jsr $000816(pc)
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  a7, d3
    move.l  $1a(a6), d2
    lsl.l   #$1, d2
    sub.l   d2, d3
    movea.l d3, a0
    movea.l a0, a7
    move.l  $22(a6), d2
    move.l  $1a(a6), d1
    subq.l  #$1, d1
l_00898:
    move.w  d2, (a0)+
    dbra    d1, $898
    move.l  $1a(a6), d1
    move.l  $1e(a6), d2
    move.b  #$2, $1d(a5)
    move.b  #$0, $37(a5)
    move.w  d1, $1e(a5)
    move.l  d3, $20(a5)
    move.l  d0, $24(a5)
    move.l  d0, d4
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    swap    d4
    andi.l  #$3fff0000, d4
    or.l    d4, d0
    ori.l   #$40000080, d0
    move.l  d0, $42(a5)
    andi.w  #$ff, d2
    subq.w  #$1, d2
    lsl.l   #$1, d1
    move.l  #$400000, d5
    move.b  $10(a5), d6
    andi.b  #$3, d6
    beq.b   l_00908
    cmpi.b  #$1, d6
    bne.b   l_00900
    lsl.l   #$1, d5
    bra.b   l_00908
l_00900:
    cmpi.b  #$3, d6
    bne.b   l_00908
    lsl.l   #$2, d5
l_00908:
    movem.l d0-d2, -(a7)
    dc.w    $6100,$0810                                 ; bsr.w $00111E
    movem.l (a7)+, d0-d2
    move.l  $42(a5), d0
    move.l  $24(a5), d0
    addi.l  #$40, d0
    move.l  d0, $24(a5)
    move.l  $42(a5), d0
    add.l   d5, d0
    move.l  d0, $42(a5)
    dbra    d2, $908
    move.l  a7, d3
    move.l  $1a(a6), d2
    lsl.l   #$1, d2
    add.l   d2, d3
    movea.l d3, a7
    move.w  (a7)+, sr
    rts

; ============================================================================
; CmdDMARowWrite -- (TODO: name)
; 178 bytes | $000944-$0009F5
; ============================================================================
CmdDMARowWrite:
    dc.w    $4EBA,$FED0                                 ; jsr $000816(pc)
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  $1a(a6), d1
    move.l  $1e(a6), d2
    move.l  $22(a6), d3
    move.b  #$2, $1d(a5)
    move.b  #$0, $37(a5)
    move.w  d1, $1e(a5)
    move.l  d3, $20(a5)
    move.l  d0, $24(a5)
    move.l  d0, d4
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    swap    d4
    andi.l  #$3fff0000, d4
    or.l    d4, d0
    ori.l   #$40000080, d0
    move.l  d0, $42(a5)
    andi.w  #$ff, d2
    subq.w  #$1, d2
    lsl.l   #$1, d1
    move.l  #$400000, d5
    move.b  $10(a5), d6
    andi.b  #$3, d6
    beq.b   l_009bc
    cmpi.b  #$1, d6
    bne.b   l_009b4
    lsl.l   #$1, d5
    bra.b   l_009bc
l_009b4:
    cmpi.b  #$3, d6
    bne.b   l_009bc
    lsl.l   #$2, d5
l_009bc:
    movem.l d0-d2, -(a7)
    dc.w    $6100,$075C                                 ; bsr.w $00111E
    movem.l (a7)+, d0-d2
    move.l  $42(a5), d0
    move.l  $24(a5), d0
    addi.l  #$40, d0
    move.l  d0, $24(a5)
    move.l  $42(a5), d0
    add.l   d5, d0
    move.l  d0, $42(a5)
    move.l  $20(a5), d0
    add.l   d1, d0
    move.l  d0, $20(a5)
    dbra    d2, $9BC
    move.w  (a7)+, sr
    rts

; ============================================================================
; CmdWaitDMA -- (TODO: name)
; 90 bytes | $0009F6-$000A4F
; ============================================================================
CmdWaitDMA:
    dc.w    $4EBA,$FE1E                                 ; jsr $000816(pc)
    move.l  d0, d1
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    andi.l  #$3fff, d1
    swap    d1
    or.l    d1, d0
    move.l  d0, $4e(a5)
    move.l  $1a(a6), d0
    move.b  d0, $4c(a5)
    move.l  $1e(a6), d0
    move.b  d0, $4d(a5)
    move.l  $22(a6), d0
    move.l  d0, $54(a5)
    move.b  #$4, d0
    move.b  d0, $2b(a5)
    move.b  $1(a5), d0
    btst    #$5, d0
    bne.b   l_00a48
l_00a3e:
    dc.w    $6100,$09C4                                 ; bsr.w $001404
    move.b  $2b(a5), d0
    bne.b   l_00a3e
l_00a48:
    move.b  $2b(a5), d0
    bne.b   l_00a48
    rts

; ============================================================================
; CmdSetWorkFlags -- (TODO: name)
; 18 bytes | $000A50-$000A61
; ============================================================================
CmdSetWorkFlags:
    move.l  $e(a6), d0
    move.w  d0, $38(a5)
    move.l  $12(a6), d0
    move.w  d0, $3a(a5)
    rts

; ============================================================================
; CmdSystemReset -- GameCommand 30: reset SP and restart
; 10 bytes | $000A62-$000A6B
; ============================================================================
CmdSystemReset:
    movea.l  #$00FFF000,a7
    dc.w    $6000,$F796                                         ; bra $000200
; ============================================================================
; CmdInitCharTable -- GameCommand 31: init character table
; 124 bytes | $000A6C-$000AE7
; ============================================================================
CmdInitCharTable:
    moveq   #$0,d0
    move.b  d0, $2fb(a5)
    move.w  $2fc(a5), d5
    bne.b   l_00a92
    move.l  $16(a6), d2
    subq.w  #$1, d2
    move.b  d2, $2fe(a5)
    move.b  d0, $2ff(a5)
    move.l  $1a(a6), d2
    move.w  d2, $300(a5)
    move.w  d2, $302(a5)
l_00a92:
    move.l  $e(a6), d1
    move.l  d1, d3
    move.l  d1, d4
    lsl.l   #$7, d1
    movea.l  #$00FFF336,a0
    moveq   #$0,d2
    move.b  $2fe(a5), d2
    addq.w  #$1, d2
    lsl.l   #$5, d2
    subq.w  #$1, d2
    movea.l $22(a6), a1
l_00ab2:
    move.b  (a1)+, (a0,d1.w)
    addq.w  #$1, d1
    dbra    d2, $AB2
    lsl.l   #$1, d3
    move.l  $12(a6), d0
    lsl.l   #$5, d0
    movea.l  #$00FFF316,a0
    move.w  d0, (a0,d3.w)
    moveq   #$0,d0
    bset    d4, d0
    or.w    d0, d5
    move.w  d5, $2fc(a5)
    move.l  $1e(a6), d0
    move.w  d0, $304(a5)
    bset    #$0, $2fb(a5)
    rts

; ============================================================================
; CmdClearCharTable -- (TODO: name)
; 64 bytes | $000AE8-$000B27
; ============================================================================
CmdClearCharTable:
    movea.l  #$00FFF336,a0
    move.l  #$1ff, d0
    moveq   #$0,d1
l_00af6:
    move.l  d1, (a0)+
    dbra    d0, $AF6
    moveq   #$7,d0
    movea.l  #$00FFF316,a0
l_00b04:
    move.l  d1, (a0)+
    dbra    d0, $B04
    move.b  d1, $2fb(a5)
    move.w  d1, $2fc(a5)
    move.w  d1, $304(a5)
    move.w  d1, $300(a5)
    move.w  d1, $302(a5)
    move.b  d1, $2fe(a5)
    move.b  d1, $2ff(a5)
    rts

; ============================================================================
; CmdSetCharState -- (TODO: name)
; 26 bytes | $000B28-$000B41
; ============================================================================
CmdSetCharState:
    move.l  $e(a6), d0
    move.b  d0, $2fb(a5)
    move.l  $12(a6), d0
    move.w  d0, $304(a5)
    move.l  $16(a6), d0
    move.w  d0, $300(a5)
    rts

; ============================================================================
; ControllerRead -- (TODO: name)
; 174 bytes | $000B42-$000BEF
; ============================================================================
ControllerRead:
    moveq   #$0,d0
    move.w  $302(a5), d0
    subq.w  #$1, d0
    bne.w   l_00bea
    bmi.w   l_00bea
    moveq   #$0,d1
    move.b  $2ff(a5), d1
    move.l  d1, d3
    cmp.b   $2fe(a5), d3
    bne.b   l_00b64
    moveq   #$0,d3
    bra.b   l_00b66
l_00b64:
    addq.w  #$1, d3
l_00b66:
    move.b  d3, $2ff(a5)
    lsl.l   #$5, d1
    moveq   #$0,d3
    move.w  $304(a5), d0
    move.w  $2fc(a5), d2
    and.w   d0, d2
    beq.b   l_00be6
    move.l  #$fff336, d4
    add.l   d1, d4
    movea.l  #$00FFF316,a2
    moveq   #$F,d0
l_00b8a:
    lsr.w   #$1, d2
    bcc.b   l_00bda
    move.b  #$2, $1d(a5)
    move.w  #$10, $1e(a5)
    move.b  #$0, $37(a5)
    move.l  d4, $20(a5)
    moveq   #$0,d5
    move.w  (a2,d3.w), d5
    move.l  d5, $24(a5)
    move.l  d5, d6
    lsl.l   #$2, d5
    andi.l  #$30000, d5
    swap    d5
    swap    d6
    andi.l  #$3fff0000, d6
    or.l    d6, d5
    ori.l   #$40000080, d5
    move.l  d5, $42(a5)
    movem.l d0-d6/a2, -(a7)
    dc.w    $6100,$054A                                 ; bsr.w $00111E
    movem.l (a7)+, d0-d6/a2
l_00bda:
    addq.w  #$2, d3
    addi.l  #$80, d4
    dbra    d0, $B8A
l_00be6:
    move.w  $300(a5), d0
l_00bea:
    move.w  d0, $302(a5)
    rts

; ============================================================================
; CmdInitAnimation -- (TODO: name)
; 72 bytes | $000BF0-$000C37
; ============================================================================
CmdInitAnimation:
    moveq   #$0,d0
    move.b  d0, $bd4(a5)
    move.l  $e(a6), d0
    beq.b   l_00c36
    move.l  $16(a6), d0
    beq.b   l_00c26
    move.b  d0, $bd6(a5)
    move.l  $12(a6), d0
    move.b  d0, $bd5(a5)
    move.l  $1a(a6), d0
    move.w  d0, $bd8(a5)
    move.l  $1e(a6), d0
    move.w  d0, $bda(a5)
    move.l  $22(a6), d0
    move.l  d0, $bdc(a5)
l_00c26:
    moveq   #$0,d0
    move.w  d0, $be0(a5)
    move.w  d0, $be2(a5)
    bset    #$0, $bd4(a5)
l_00c36:
    rts

; ============================================================================
; VInt_Sub1 -- (TODO: name)
; 164 bytes | $000C38-$000CDB
; ============================================================================
VInt_Sub1:
    moveq   #$0,d0
    move.w  $be2(a5), d0
    bne.w   l_00cc6
    moveq   #$0,d0
    move.b  $bd6(a5), d0
    moveq   #$0,d1
    move.l  $bdc(a5), d1
    move.l  d0, d2
    lsl.w   #$1, d2
    moveq   #$0,d3
    move.w  $be0(a5), d3
    mulu.w  d3, d2
    add.l   d2, d1
    moveq   #$0,d2
    move.b  $bd5(a5), d2
    lsl.l   #$1, d2
    move.l  d2, d3
    move.l  d2, d4
    lsl.l   #$2, d3
    andi.l  #$30000, d3
    swap    d3
    swap    d4
    andi.l  #$3fff0000, d4
    or.l    d4, d3
    ori.l   #$c0000080, d3
    move.b  #$2, $1d(a5)
    move.w  d0, $1e(a5)
    move.b  #$1, $37(a5)
    move.l  d1, $20(a5)
    move.l  d2, $24(a5)
    move.l  d3, $42(a5)
    moveq   #$0,d0
    movea.l  #$00C00004,a0
    move.w  (a0), d0
    btst    #$3, d0
    beq.b   l_00cda
    dc.w    $6100,$046E                                 ; bsr.w $00111E
    moveq   #$0,d0
    move.w  $be0(a5), d0
    addq.w  #$1, d0
    cmp.w   $bd8(a5), d0
    bne.b   l_00cc2
    moveq   #$0,d0
l_00cc2:
    move.w  d0, $be0(a5)
l_00cc6:
    moveq   #$0,d0
    move.w  $be2(a5), d0
    addq.w  #$1, d0
    cmp.w   $bda(a5), d0
    bne.b   l_00cd6
    moveq   #$0,d0
l_00cd6:
    move.w  d0, $be2(a5)
l_00cda:
    rts

; ============================================================================
; WaitVBlank -- (TODO: name)
; 16 bytes | $000CDC-$000CEB
; ============================================================================
WaitVBlank:
    movea.l  #$00C00004,a4
    move.w  (a4), d0
    andi.l  #$ffff, d0
    rts

; ============================================================================
; CmdSetAnimState -- (TODO: name)
; 24 bytes | $000CEC-$000D03
; ============================================================================
CmdSetAnimState:
    moveq   #$0,d0
    move.w  d0, $bce(a5)
    move.l  $12(a6), d0
    move.l  d0, $bd0(a5)
    move.l  $e(a6), d0
    move.w  d0, $bce(a5)
    rts

; ============================================================================
; CmdSetTimer -- (TODO: name)
; 32 bytes | $000D04-$000D23
; ============================================================================
CmdSetTimer:
    move.l  $e(a6), d0
    beq.b   l_00d1e
    move.l  $16(a6), d0
    swap    d0
    or.l    $12(a6), d0
    move.l  d0, $be4(a5)
    moveq   #$0,d0
    move.l  d0, $be8(a5)
l_00d1e:
    move.l  $be8(a5), d0
    rts

; ============================================================================
; CmdConditionalWrite -- (TODO: name)
; 24 bytes | $000D24-$000D3B
; ============================================================================
CmdConditionalWrite:
    move.l  $e(a6), d0
    cmpi.l  #$2, d0
    beq.b   l_00d34
    move.w  d0, $c70(a5)
l_00d34:
    moveq   #$0,d0
    move.w  $c70(a5), d0
    rts

; ============================================================================
; CmdInitGameVars -- (TODO: name)
; 40 bytes | $000D3C-$000D63
; ============================================================================
CmdInitGameVars:
    moveq   #$0,d0
    move.b  d0, $c46(a5)
    move.l  d0, $c48(a5)
    move.l  d0, $c4c(a5)
    move.l  $12(a6), d0
    move.l  d0, $c48(a5)
    move.l  $16(a6), d0
    move.l  d0, $c4c(a5)
    move.l  $e(a6), d0
    move.b  d0, $c46(a5)
    rts


; ============================================================================
; GameCommand -- Central command dispatcher (most-called function, 306 calls)
; ============================================================================
; Takes a command number (0-46) as the first longword stack argument.
; Dispatches to one of 47 handler functions via jump table.
; Sets A5 = work RAM base ($FFF010) before calling the handler.
;
; Stack frame (move sr BEFORE link creates unusual layout):
;   0(a6) = saved A6          4(a6) = saved SR (word)
;   6(a6) = return address    A(a6) = command number (longword)
;   E(a6) = additional args (vary per command)
; ============================================================================
GameCommand:                                                 ; $000D64
    move    sr,-(sp)                                         ; Save SR (before link frame!)
    link    a6,#$0000                                        ; Create stack frame
    movem.l d2-d7/a2-a5,-(sp)                               ; Save working registers
    move.l  $A(a6),d7                                        ; D7 = command number (first arg)
    cmpi.l  #$0000002F,d7                                    ; Valid range: 0-46
    bcc.s   .error                                           ; Branch if >= 47 (invalid)
    movea.l #$00FFF010,a5                                    ; A5 = work RAM base
    lsl.w   #2,d7                                            ; D7 *= 4 (longword table offset)
    movea.l #GameCommandTable,a4                             ; A4 = jump table base
    movea.l 0(a4,d7.w),a4                                   ; A4 = handler address
    jsr     (a4)                                             ; Call handler
    movem.l (sp)+,d2-d7/a2-a5                               ; Restore registers
    unlk    a6                                               ; Destroy stack frame
    rtr                                                      ; Restore CCR + return
.error:                                                      ; $000D96
    bra.s   .error                                           ; Infinite loop (invalid cmd)
; -- Jump table: 47 command handlers (indexed 0-46) --
GameCommandTable:                                            ; $000D98
    dc.l    $000003A2,$000003BC,$0000045A,$0000046A          ; 0=SetVDPReg, 1=SetScrollMode, 2=GetVDPReg, 3=GetVDPStatus
    dc.l    $00000474,$0000047C,$000004F0,$00000520          ; 4=RunSubroutine, 5=SetupDMA, 6=TransferPlane, 7=LoadTiles
    dc.l    $00000550,$000005F8,$0000060C,$00000658          ; 8=SetupSprite, 9=CopyMemory, 10=ReadInput, 11=SetupObject
    dc.l    $000006F0,$0000070A,$00000724,$0000074A          ; 12=EnableDisplay, 13=HardwareInit, 14=WaitFrames, 15=UpdateSprites
    dc.l    $000007A4,$000007D8,$000024B8,$000024DE          ; 16=ClearSprites, 17=TestVRAM, 18=SendZ80Param, 19=SendZ80Byte
    dc.l    $000024FA,$000024DE,$0000250A,$00002568          ; 20=TriggerZ80, 21=SendZ80Byte, 22=LoadZ80Tables, 23=LoadZ80Encoded
    dc.l    $000024FA,$000024FA,$00000876,$00000944          ; 24=TriggerZ80, 25=TriggerZ80, 26=DMABatchWrite, 27=DMARowWrite
    dc.l    $000009F6,$00000A50,$00000A62,$00000A6C          ; 28=WaitDMA, 29=SetWorkFlags, 30=SystemReset, 31=InitCharTable
    dc.l    $00000AE8,$00000B28,$00000CEC,$00000BF0          ; 32=ClearCharTable, 33=SetCharState, 34=SetAnimState, 35=InitAnimation
    dc.l    $00000D04,$00000D3C,$00000E54,$00000E92          ; 36=SetTimer, 37=InitGameVars, 38=ClampCoords, 39=GetCoords
    dc.l    $00000EAA,$00000EBA,$00000F18,$00000F22          ; 40=ReadCombinedWord, 41=SetBoundsAndClamp, 42=SetScrollParam, 43=ScanStatusArray
    dc.l    $00000F42,$00000F7A,$00000D24                    ; 44=SaveBuffer, 45=StoreWorkByte, 46=ConditionalWrite
; ---
; === Translated block $000E54-$000F82 ===
; 7 functions, 302 bytes

; ============================================================================
; CmdClampCoords -- (TODO: name)
; 62 bytes | $000E54-$000E91
; ============================================================================
CmdClampCoords:
    move.l  $e(a6), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_00e64
    move.w  $c52(a5), d0
    bra.b   l_00e6e
l_00e64:
    cmp.w   $c56(a5), d0
    ble.b   l_00e6e
    move.w  $c56(a5), d0
l_00e6e:
    move.w  d0, $c5c(a5)
    move.l  $12(a6), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_00e82
    move.w  $c54(a5), d1
    bra.b   l_00e8c
l_00e82:
    cmp.w   $c58(a5), d1
    ble.b   l_00e8c
    move.w  $c58(a5), d1
l_00e8c:
    move.w  d1, $c5e(a5)
    rts

; ============================================================================
; CmdGetCoords -- (TODO: name)
; 24 bytes | $000E92-$000EA9
; ============================================================================
CmdGetCoords:
    moveq   #$0,d2
    movea.l $e(a6), a2
    move.w  $c5c(a5), d2
    move.l  d2, (a2)
    movea.l $12(a6), a2
    move.w  $c5e(a5), d2
    move.l  d2, (a2)
    rts

; ============================================================================
; CmdReadCombinedWord -- (TODO: name)
; 16 bytes | $000EAA-$000EB9
; ============================================================================
CmdReadCombinedWord:
    moveq   #$0,d0
    move.b  $c61(a5), d0
    asl.l   #$8, d0
    asl.l   #$8, d0
    or.b    $c60(a5), d0
    rts

; ============================================================================
; CmdSetBoundsAndClamp -- (TODO: name)
; 94 bytes | $000EBA-$000F17
; ============================================================================
CmdSetBoundsAndClamp:
    move.l  $e(a6), d2
    move.w  d2, $c52(a5)
    move.l  $12(a6), d2
    move.w  d2, $c54(a5)
    move.l  $16(a6), d2
    move.w  d2, $c56(a5)
    move.l  $1a(a6), d2
    move.w  d2, $c58(a5)
    move.w  $c5c(a5), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_00eea
    move.w  $c52(a5), d0
    bra.b   l_00ef4
l_00eea:
    cmp.w   $c56(a5), d0
    ble.b   l_00ef4
    move.w  $c56(a5), d0
l_00ef4:
    move.w  d0, $c5c(a5)
    move.w  $c5e(a5), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_00f08
    move.w  $c54(a5), d1
    bra.b   l_00f12
l_00f08:
    cmp.w   $c58(a5), d1
    ble.b   l_00f12
    move.w  $c58(a5), d1
l_00f12:
    move.w  d1, $c5e(a5)
    rts

; ============================================================================
; CmdSetScrollParam -- (TODO: name)
; 10 bytes | $000F18-$000F21
; ============================================================================
CmdSetScrollParam:
    move.l  $e(a6), d2
    move.w  d2, $c5a(a5)
    rts

; ============================================================================
; CmdScanStatusArray -- (TODO: name)
; 32 bytes | $000F22-$000F41
; ============================================================================
CmdScanStatusArray:
    moveq   #$0,d0
    movea.l  #$00FFFC06,a2
    moveq   #$7,d5
l_00f2c:
    cmpi.w  #$2, (a2)
    bne.b   l_00f36
    bset    #$0, d0
l_00f36:
    adda.l  #$a, a2
    dbra    d5, $F2C
    rts

; ============================================================================
; CmdSaveBuffer -- (TODO: name)
; 56 bytes | $000F42-$000F79
; ============================================================================
CmdSaveBuffer:
    bclr    #$0, $c62(a5)
    move.l  $e(a6), d2
    beq.b   l_00f64
    movea.l  #$00FFFC74,a2
    movea.l $12(a6), a3
    move.l  (a3)+, (a2)+
    move.l  (a3), (a2)
    bset    #$0, $c62(a5)
    bra.b   l_00f78
l_00f64:
    move.l  #$0, $7a(a5)
    dc.w    $4EBA,$0074                                 ; jsr $000FE2(pc)
    nop
    dc.w    $4EBA,$0662                                 ; jsr $0015D6(pc)
    nop
l_00f78:
    rts

; -- GameCommand 45: store byte to work RAM --
CmdStoreWorkByte:                                               ; $000F7A
    move.l  $e(a6), d0                                          ; D0 = arg1
    move.b  d0, $c6c(a5)                                        ; Store to $FFFC7C
    rts

; ===========================================================================
; Exception Handlers ($000F84-$000FE1)
; Pattern: moveq #exception_id,d0 -> bra.w ExceptionCommon
; ExceptionCommon: push SP and ID, call ErrorDisplay, halt
; ===========================================================================

BusError:                                                   ; $000F84
    moveq   #2,d0
    bra.w   ExceptionCommon
AddressError:                                               ; $000F8A
    moveq   #3,d0
    bra.w   ExceptionCommon
IllegalInstr:                                               ; $000F90
    moveq   #4,d0
    bra.w   ExceptionCommon
ZeroDivide:                                                 ; $000F96
    moveq   #5,d0
    bra.w   ExceptionCommon
ChkInstr:                                                   ; $000F9C
    moveq   #6,d0
    bra.w   ExceptionCommon
TrapvInstr:                                                 ; $000FA2
    moveq   #7,d0
    bra.w   ExceptionCommon
PrivilegeViol:                                              ; $000FA8
    moveq   #8,d0
    bra.w   ExceptionCommon
Trace:                                                      ; $000FAE
    moveq   #9,d0
    bra.w   ExceptionCommon
LineAEmulator:                                              ; $000FB4
    moveq   #10,d0
    bra.w   ExceptionCommon
LineFEmulator:                                              ; $000FBA
    moveq   #11,d0
    bra.w   ExceptionCommon
Reserved_0C:                                                ; $000FC0
    moveq   #12,d0
    bra.w   ExceptionCommon
Reserved_0D:                                                ; $000FC6
    moveq   #13,d0
    bra.w   ExceptionCommon
Reserved_0E:                                                ; $000FCC
    moveq   #14,d0
    bra.w   ExceptionCommon
Reserved_0F:                                                ; $000FD2
    moveq   #15,d0
                                                            ; falls through
ExceptionCommon:                                            ; $000FD4
    movea.l sp,a0
    move.l  a0,-(sp)
    move.l  d0,-(sp)
    dc.w    $4EB9,$0000,$58EE                               ; jsr ErrorDisplay ($0058EE)
ExceptionHalt:                                              ; $000FE0
    bra.s   ExceptionHalt

; ---------------------------------------------------------------------------
; === Translated block $000FE2-$001480 ===
; 19 functions, 1182 bytes

; ============================================================================
; func_000FE2 -- (TODO: name)
; 58 bytes | $000FE2-$00101B
; ============================================================================
func_000FE2:
    movem.l d0-d2/a0, -(a7)
    movea.l  #$00FFF01C,a0
    btst    #$0, (a0)
    bne.b   l_00ff6
    moveq   #$3F,d1
    bra.b   l_00ff8
l_00ff6:
    moveq   #$4F,d1
l_00ff8:
    moveq   #$1,d0
    movea.l  #$00FFF08A,a0
    moveq   #$3,d2
l_01002:
    move.b  d0, (a0,d2.w)
    addq.l  #$1, d0
    addq.l  #$8, d2
    dbra    d1, $1002
    moveq   #$0,d0
    subq.l  #$8, d2
    move.b  d0, (a0,d2.w)
    movem.l (a7)+, d0-d2/a0
    rts

; ============================================================================
; VDP_Init2 -- (TODO: name)
; 26 bytes | $00101C-$001035
; ============================================================================
VDP_Init2:
    movea.l  #$00FFF08A,a6
    movea.l a6, a5
    moveq   #$0,d0
    moveq   #$4F,d1
l_01028:
    move.l  d0, (a6)+
    move.l  d0, (a6)+
    dbra    d1, $1028
    dc.w    $4EBA,$FFB0                                 ; jsr $000FE2(pc)
    rts

; ============================================================================
; VDP_Init1 -- (TODO: name)
; 68 bytes | $001036-$001079
; ============================================================================
VDP_Init1:
    move.w  #$8f02, d0
    movea.l  #$00C00004,a6
    movea.l  #$00C00000,a5
    move.w  d0, (a6)
    moveq   #$0,d0
    move.l  #$7fff, d1
    move.l  #$40000000, (a6)
l_01056:
    move.w  d0, (a5)
    dbra    d1, $1056
    moveq   #$3F,d1
    move.l  #$c0000000, (a6)
l_01064:
    move.w  d0, (a5)
    dbra    d1, $1064
    moveq   #$27,d1
    move.l  #$40000010, (a6)
l_01072:
    move.w  d0, (a5)
    dbra    d1, $1072
    rts

; ============================================================================
; VDP_Init3 -- (TODO: name)
; 22 bytes | $00107A-$00108F
; ============================================================================
VDP_Init3:
    moveq   #$40,d7
    move.b  d7, ($00A10009).l
    move.b  d7, ($00A1000B).l
    move.b  d7, ($00A1000D).l
    rts

; ============================================================================
; Init6 -- (TODO: name)
; 74 bytes | $001090-$0010D9
; ============================================================================
Init6:
    movea.l  #$00FFF010,a0
    move.w  #$0, $c52(a0)
    move.w  #$0, $c54(a0)
    move.w  #$ff, $c56(a0)
    move.w  #$df, $c58(a0)
    move.w  #$0, $c5a(a0)
    move.w  #$80, $c5c(a0)
    move.w  #$70, $c5e(a0)
    move.w  #$0, $c60(a0)
    move.b  #$0, $c62(a0)
    move.b  #$0, $c6c(a0)
    move.w  #$20, $c6e(a0)
    rts

; ============================================================================
; Init5 -- (TODO: name)
; 36 bytes | $0010DA-$0010FD
; ============================================================================
Init5:
    movea.l  #$00001D88,a6
    move.l  #$31f, d1
    movea.l  #$00C00000,a5
    move.l  #$40000000, ($00C00004).l
l_010f6:
    move.w  (a6)+, (a5)
    dbra    d1, $10F6
    rts

; ============================================================================
; VDP_Init4 -- (TODO: name)
; 32 bytes | $0010FE-$00111D
; ============================================================================
VDP_Init4:
    lea     ($00A11100).l, a4
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.w  #$100, (a4)
    move.w  #$100, $100(a4)
l_01114:
    btst    #$0, (a4)
    bne.b   l_01114
    move.w  (a7)+, sr
    rts

; ============================================================================
; func_00111E -- (TODO: name)
; 8 bytes | $00111E-$001125
; ============================================================================
func_00111E:
    dc.w    $4EBA,$0078                                 ; jsr $001198(pc)
    nop
    rts

; ============================================================================
; func_001126 -- (TODO: name)
; 56 bytes | $001126-$00115D
; ============================================================================
func_001126:
    dc.w    $4EBA,$012E                                 ; jsr $001256(pc)
    nop
l_0112c:
    move.w  (a4), d1
    btst    #$1, d1
    bne.b   l_0112c
    bra.w   l_0116a
    dc.w    $4EBA,$01A0                                 ; jsr $0012DA(pc)
    nop
l_0113e:
    move.w  (a4), d1
    btst    #$1, d1
    bne.b   l_0113e
    bra.w   l_0116a
    movea.l  #$00A11100,a2
    move.w  #$100, (a2)
l_01154:
    move.w  (a2), d0
    andi.w  #$100, d0
    bne.b   l_01154
    rts

; ============================================================================
; func_00115E -- (TODO: name)
; 12 bytes | $00115E-$001169
; ============================================================================
func_00115E:
    movea.l  #$00A11100,a2
    move.w  #$0, (a2)
    rts

; ============================================================================
; func_00116A -- (TODO: name)
; 16 bytes | $00116A-$001179
; ============================================================================
func_00116A:
l_0116a:
    move.b  $1(a5), d0
    andi.w  #$ef, d0
    ori.w   #$8100, d0
    move.w  d0, (a4)
    rts

; ============================================================================
; func_00117A -- (TODO: name)
; 30 bytes | $00117A-$001197
; ============================================================================
func_00117A:
l_0117a:
    dc.w    $6100,$FB60                                 ; bsr.w $000CDC
    andi.w  #$2, d0
    bne.b   l_0117a
    move.b  $1d(a5), d0
    andi.w  #$ff, d0
    ori.w   #$8f00, d0
    move.w  d0, (a4)
    move.b  d0, $f(a5)
    rts

; ============================================================================
; func_001198 -- (TODO: name)
; 190 bytes | $001198-$001255
; ============================================================================
func_001198:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.w  $c70(a5), d0
    bne.b   l_011a8
    dc.w    $4EBA,$FFA4                                 ; jsr $00114A(pc)
l_011a8:
    dc.w    $4EBA,$FFD0                                 ; jsr $00117A(pc)
    move.w  #$8100, d0
    move.b  $1(a5), d0
    bclr    #$5, d0
    bset    #$4, d0
    move.w  d0, (a4)
    moveq   #$0,d0
    move.w  $1e(a5), d0
    move.l  d0, d2
    move.w  #$9300, d1
    andi.w  #$ff, d0
    or.w    d1, d0
    move.w  d0, (a4)
    exg     d0, d2
    lsr.w   #$8, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.l  $20(a5), d0
    lsr.l   #$1, d0
    move.l  d0, d2
    andi.l  #$ff, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.l  d2, d0
    lsr.w   #$8, d0
    andi.l  #$ff, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    addi.w  #$100, d1
    move.l  d2, d0
    swap    d0
    andi.w  #$7f, d0
    or.w    d1, d0
    move.w  d0, (a4)
    dc.w    $4EB9,$00FF,$F000                           ; jsr $FFF000
l_0121c:
    move.w  (a4), d1
    btst    #$1, d1
    bne.b   l_0121c
    move.l  $20(a5), d0
    btst    #$16, d0
    beq.b   l_01244
    movea.l d0, a0
    move.l  $42(a5), d0
    bclr    #$7, d0
    movea.l  #$00C00000,a3
    moveq   #$1,d1
    dc.w    $6100,$0144                                 ; bsr.w $001386
l_01244:
    dc.w    $6100,$FF24                                 ; bsr.w $00116A
    move.w  $c70(a5), d0
    bne.b   l_01252
    dc.w    $6100,$FF0E                                 ; bsr.w $00115E
l_01252:
    move.w  (a7)+, sr
    rts

; ============================================================================
; func_001256 -- (TODO: name)
; 132 bytes | $001256-$0012D9
; ============================================================================
func_001256:
    movea.l  #$00C00004,a4
    move.w  #$8100, d0
    move.b  $1(a5), d0
    bclr    #$5, d0
    bset    #$4, d0
    move.w  d0, (a4)
    dc.w    $4EBA,$FF0A                                 ; jsr $00117A(pc)
    moveq   #$0,d0
    move.w  $1e(a5), d0
    move.l  d0, d2
    move.w  #$9300, d1
    andi.w  #$ff, d0
    or.w    d1, d0
    move.w  d0, (a4)
    exg     d0, d2
    lsr.w   #$8, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.l  $20(a5), d0
    move.l  d0, d2
    andi.l  #$ff, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.l  d2, d0
    lsr.w   #$8, d0
    andi.l  #$ff, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.w  #$97c0, d0
    move.w  d0, (a4)
    move.l  $24(a5), d0
    move.l  d0, d2
    lsl.l   #$2, d0
    swap    d0
    andi.w  #$3, d0
    ori.w   #$c0, d0
    andi.w  #$3fff, d2
    move.w  d2, (a4)
    move.w  d0, (a4)
    rts

; ============================================================================
; func_0012DA -- (TODO: name)
; 108 bytes | $0012DA-$001345
; ============================================================================
func_0012DA:
    movea.l  #$00C00004,a4
    move.w  #$8100, d0
    move.b  $1(a5), d0
    bclr    #$5, d0
    bset    #$4, d0
    move.w  d0, (a4)
    dc.w    $4EBA,$FE86                                 ; jsr $00117A(pc)
    moveq   #$0,d0
    move.w  $1e(a5), d0
    move.l  d0, d2
    move.w  #$9300, d1
    andi.w  #$ff, d0
    or.w    d1, d0
    move.w  d0, (a4)
    exg     d0, d2
    lsr.w   #$8, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.w  #$9780, d0
    move.w  d0, (a4)
    move.l  $24(a5), d0
    move.l  d0, d2
    lsl.l   #$2, d0
    swap    d0
    andi.w  #$3, d0
    ori.w   #$80, d0
    andi.w  #$3fff, d2
    bset    #$e, d2
    move.w  d2, (a4)
    move.w  d0, (a4)
    move.w  $28(a5), d0
    move.w  d0, ($00C00000).l
    rts

; ============================================================================
; VInt_Handler1 -- (TODO: name)
; 64 bytes | $001346-$001385
; ============================================================================
VInt_Handler1:
l_01346:
    movea.l  #$00C00000,a3
    movea.l  #$00C00004,a4
    moveq   #$0,d0
    move.b  $2a(a5), d0
    ori.w   #$8f00, d0
    move.b  d0, $f(a5)
    move.w  d0, (a4)
    move.w  $34(a5), d1
    move.l  $2c(a5), d0
    btst    #$1e, d0
    bne.b   l_01376
    movea.l $30(a5), a0
    bra.b   l_0137c
l_01376:
    movea.l $30(a5), a0
    bra.b   l_01386
l_0137c:
    move.l  d0, (a4)
l_0137e:
    move.w  (a3), (a0)+
    subq.w  #$1, d1
    bne.b   l_0137e
    rts

; ============================================================================
; func_001386 -- (TODO: name)
; 10 bytes | $001386-$00138F
; ============================================================================
func_001386:
l_01386:
    move.l  d0, (a4)
l_01388:
    move.w  (a0)+, (a3)
    subq.w  #$1, d1
    bne.b   l_01388
    rts

; ============================================================================
; VInt_Handler2 -- (TODO: name)
; 116 bytes | $001390-$001403
; ============================================================================
VInt_Handler2:
    movea.l  #$00C00000,a3
    movea.l  #$00C00004,a4
    moveq   #$0,d2
    move.l  d2, d3
    moveq   #$3,d7
    move.b  $4c(a5), d2
    move.b  $4d(a5), d3
    move.w  $52(a5), d4
    move.l  $4e(a5), d0
    move.l  #$400000, d5
    move.b  $10(a5), d6
    andi.b  #$3, d6
    beq.b   l_013d4
    cmpi.b  #$1, d6
    bne.b   l_013cc
    lsl.l   #$1, d5
    bra.b   l_013d4
l_013cc:
    cmpi.b  #$3, d6
    bne.b   l_013d4
    lsl.l   #$2, d5
l_013d4:
    subq.w  #$1, d2
    move.w  #$8f02, (a4)
    move.l  d0, (a4)
l_013dc:
    move.w  d4, (a3)
    dbra    d2, $13DC
    add.l   d5, d0
    move.l  d0, $4e(a5)
    moveq   #$0,d2
    move.b  $4c(a5), d2
    subq.w  #$1, d3
    beq.b   l_013fc
    dbra    d7, $13D4
    move.b  d3, $4d(a5)
    bne.b   l_01402
l_013fc:
    move.b  #$0, $2b(a5)
l_01402:
    rts

; ============================================================================
; VInt_Handler3 -- (TODO: name)
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
    dc.w    $6100,$012C                                     ; bsr.w DMA_Transfer ($00163E)
    bclr    #0,$004B(a5)                                    ; clear DMA flag
; --- Display update ---
.no_dma:                                                    ; $00151A
    moveq   #0,d0
    move.b  $0B2A(a5),d0                                    ; display update flag
    beq.s   .no_display
    dc.w    $6100,$013C                                     ; bsr.w DisplayUpdate ($001660)
; --- Subsystem 1 ---
.no_display:                                                ; $001526
    moveq   #0,d0
    move.b  $0BD4(a5),d0
    beq.s   .no_sub1
    dc.w    $6100,$F708                                     ; bsr.w VInt_Sub1 ($000C38)
; --- Subsystem 2 ---
.no_sub1:                                                   ; $001532
    move.w  $0BCE(a5),d0                                    ; word flag
    beq.w   .no_sub2
    dc.w    $6100,$0190                                     ; bsr.w VInt_Sub2 ($0016CC)
; --- Controller/input read ---
.no_sub2:                                                   ; $00153E
    moveq   #0,d0
    move.b  $02FB(a5),d0                                    ; input enable flag
    beq.s   .no_input
    dc.w    $6100,$F5FA                                     ; bsr.w ControllerRead ($000B42)
; --- Multi-dispatch on $002B(A5) bits 0/1/2 ---
.no_input:                                                  ; $00154A
    moveq   #0,d0
    move.b  $002B(a5),d0                                    ; dispatch flags
    beq.w   .poll                                           ; skip if no bits set
    btst    #0,$002B(a5)                                    ; bit 0 set?
    beq.s   .try_bit1
    dc.w    $6100,$FDE8                                     ; bsr.w VInt_Handler1 ($001346)
    moveq   #0,d0
    move.b  d0,$002B(a5)                                    ; clear all dispatch flags
    bra.s   .poll
.try_bit1:                                                  ; $001568
    btst    #1,$002B(a5)                                    ; bit 1 set?
    beq.s   .try_bit2
    dc.w    $6100,$FE1E                                     ; bsr.w VInt_Handler2 ($001390)
    bra.s   .poll
.try_bit2:                                                  ; $001576
    btst    #2,$002B(a5)                                    ; bit 2 set?
    beq.s   .poll
    dc.w    $6100,$FE84                                     ; bsr.w VInt_Handler3 ($001404)
; --- Controller poll + 4 subsystem updates (always run) ---
.poll:                                                      ; $001582
    dc.w    $43F9,$00FF,$FBFC                               ; lea $00FFFBFC,a1
    dc.w    $6100,$03A4                                     ; bsr.w ControllerPoll ($00192E)
    dc.w    $4EBA,$0146                                     ; jsr SubsysUpdate1(pc) ($0016D4)
    nop
    dc.w    $4EBA,$01C8                                     ; jsr SubsysUpdate2(pc) ($00175C)
    nop
    dc.w    $4EBA,$02CA                                     ; jsr SubsysUpdate3(pc) ($001864)
    nop
    dc.w    $4EBA,$0330                                     ; jsr SubsysUpdate4(pc) ($0018D0)
    nop
    move.b  #0,$0036(a5)                                    ; clear V-INT processed flag
    movem.l (sp)+,d0-d7/a0-a7                              ; restore ALL registers
    rte
; === Translated block $0015B0-$00260A ===
; 29 functions, 4186 bytes

; ============================================================================
; func_0015B0 -- (TODO: name)
; 38 bytes | $0015B0-$0015D5
; ============================================================================
func_0015B0:
    btst    #$0, d0
    bne.b   l_015ca
    btst    #$1, d0
    bne.b   l_015d0
    btst    #$2, d0
    beq.w   l_015d4
    dc.w    $6100,$FB72                                 ; bsr.w $001138
    bra.b   l_015d4
l_015ca:
    dc.w    $6100,$FB52                                 ; bsr.w $00111E
    bra.b   l_015d4
l_015d0:
    dc.w    $6100,$FB54                                 ; bsr.w $001126
l_015d4:
    rts

; ============================================================================
; func_0015D6 -- (TODO: name)
; 104 bytes | $0015D6-$00163D
; ============================================================================
func_0015D6:
    movem.l a0, -(a7)
    movea.l  #$00FFF01C,a0
    moveq   #$0,d3
    move.b  #$2, $1d(a5)
    btst    #$0, (a0)
    bne.b   l_015f6
    move.w  #$100, $1e(a5)
    bra.b   l_015fc
l_015f6:
    move.w  #$140, $1e(a5)
l_015fc:
    move.b  d3, $37(a5)
    move.l  #$fff08a, d0
    move.l  d0, $20(a5)
    moveq   #$0,d0
    move.w  $3e(a5), d0
    move.l  d0, $24(a5)
    move.l  d0, d1
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    swap    d1
    andi.l  #$3fff0000, d1
    or.l    d1, d0
    ori.l   #$40000080, d0
    move.l  d0, $42(a5)
    dc.w    $6100,$FAE8                                 ; bsr.w $00111E
    movem.l (a7)+, a0
    rts

; ============================================================================
; DMA_Transfer -- (TODO: name)
; 34 bytes | $00163E-$00165F
; ============================================================================
DMA_Transfer:
    movea.l  #$00C00004,a4
    movea.l  #$00C00000,a3
    movea.l  #$00FFF06A,a0
    moveq   #$A,d0
    move.l  #$c0040000, (a4)
l_01658:
    move.w  (a0)+, (a3)
    dbra    d0, $1658
    rts

; ============================================================================
; DisplayUpdate -- (TODO: name)
; 108 bytes | $001660-$0016CB
; ============================================================================
DisplayUpdate:
    moveq   #$0,d0
    move.w  $b28(a5), d0
    subq.w  #$1, d0
    bne.b   l_016c6
    moveq   #$0,d0
    move.l  d0, d1
    move.l  d0, d2
    move.b  $b2b(a5), d0
    move.b  $b2c(a5), d2
    move.l  d0, d1
    lsl.l   #$3, d1
    lsl.l   #$1, d0
    subq.w  #$1, d2
    movea.l  #$00FFFB3E,a0
    movea.l  #$00FFF08A,a1
    move.b  $b2d(a5), d3
    beq.b   l_016a8
l_01692:
    move.w  (a0,d0.w), (a1,d1.w)
    addq.w  #$2, d0
    addq.w  #$8, d1
    dbra    d2, $1692
    move.b  #$0, $b2d(a5)
    bra.b   l_016ba
l_016a8:
    move.w  #$0, (a1,d1.w)
    addq.w  #$8, d1
    dbra    d2, $16A8
    move.b  #$1, $b2d(a5)
l_016ba:
    dc.w    $4EBA,$F926                                 ; jsr $000FE2(pc)
    dc.w    $6100,$FF16                                 ; bsr.w $0015D6
    move.w  $b26(a5), d0
l_016c6:
    move.w  d0, $b28(a5)
    rts

; ============================================================================
; VInt_Sub2 -- (TODO: name)
; 8 bytes | $0016CC-$0016D3
; ============================================================================
VInt_Sub2:
    movea.l $bd0(a5), a0
    jsr     (a0)
    rts

; ============================================================================
; SubsysUpdate1 -- (TODO: name)
; 136 bytes | $0016D4-$00175B
; ============================================================================
SubsysUpdate1:
    movea.l  #$00FFF010,a5
    move.w  $c5a(a5), d4
    eori.w  #$3, d4
    move.w  #$0, $c60(a5)
    movea.l  #$00FFFC06,a0
    moveq   #$7,d5
l_016f0:
    cmpi.w  #$2, (a0)
    bne.b   l_01750
    move.w  $6(a0), d0
    ext.l   d0
    divs.w  d4, d0
    add.w   $c5c(a5), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_0170e
    move.w  $c52(a5), d0
    bra.b   l_01718
l_0170e:
    cmp.w   $c56(a5), d0
    ble.b   l_01718
    move.w  $c56(a5), d0
l_01718:
    move.w  d0, $c5c(a5)
    move.w  $8(a0), d1
    ext.l   d1
    divs.w  d4, d1
    add.w   $c5e(a5), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_01734
    move.w  $c54(a5), d1
    bra.b   l_0173e
l_01734:
    cmp.w   $c58(a5), d1
    ble.b   l_0173e
    move.w  $c58(a5), d1
l_0173e:
    move.w  d1, $c5e(a5)
    move.w  $2(a0), d2
    asr.w   #$4, d2
    andi.w  #$f0f, d2
    or.w    d2, $c60(a5)
l_01750:
    adda.l  #$a, a0
    dbra    d5, $16F0
    rts

; ============================================================================
; SubsysUpdate2 -- (TODO: name)
; 264 bytes | $00175C-$001863
; ============================================================================
SubsysUpdate2:
    btst    #$0, $c6c(a5)
    beq.w   l_01862
    moveq   #$0,d2
    movea.l  #$00FFFC06,a0
    moveq   #$7,d5
l_01770:
    cmpi.w  #$2, (a0)
    bcc.b   l_0177c
    move.w  $2(a0), d0
    or.w    d0, d2
l_0177c:
    adda.l  #$a, a0
    dbra    d5, $1770
    move.w  d2, d0
    andi.w  #$f00, d0
    bne.b   l_01794
    move.w  #$20, $c6e(a5)
l_01794:
    cmpi.w  #$0, $c6e(a5)
    beq.b   l_017bc
    subq.w  #$1, $c6e(a5)
    cmpi.w  #$10, $c6e(a5)
    bcs.b   l_017ae
    moveq   #-$1,d3
    moveq   #$1,d4
    bra.b   l_017c8
l_017ae:
    moveq   #-$2,d3
    moveq   #$2,d4
    sub.w   $c5a(a5), d3
    add.w   $c5a(a5), d4
    bra.b   l_017c8
l_017bc:
    moveq   #-$3,d3
    moveq   #$3,d4
    sub.w   $c5a(a5), d3
    add.w   $c5a(a5), d4
l_017c8:
    btst    #$8, d2
    beq.b   l_017e2
    move.w  d3, d1
    add.w   $c5e(a5), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_017de
    move.w  $c54(a5), d1
l_017de:
    move.w  d1, $c5e(a5)
l_017e2:
    btst    #$9, d2
    beq.b   l_017fc
    move.w  d4, d1
    add.w   $c5e(a5), d1
    cmp.w   $c58(a5), d1
    ble.b   l_017f8
    move.w  $c58(a5), d1
l_017f8:
    move.w  d1, $c5e(a5)
l_017fc:
    btst    #$a, d2
    beq.b   l_01816
    move.w  d3, d0
    add.w   $c5c(a5), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_01812
    move.w  $c52(a5), d0
l_01812:
    move.w  d0, $c5c(a5)
l_01816:
    btst    #$b, d2
    beq.b   l_01830
    move.w  d4, d0
    add.w   $c5c(a5), d0
    cmp.w   $c56(a5), d0
    ble.b   l_0182c
    move.w  $c56(a5), d0
l_0182c:
    move.w  d0, $c5c(a5)
l_01830:
    btst    #$c, d2
    beq.b   l_0183c
    bset    #$1, $c60(a5)
l_0183c:
    move.w  d2, d0
    andi.w  #$6000, d0
    beq.b   l_0184a
    bset    #$0, $c60(a5)
l_0184a:
    btst    #$4, d2
    beq.b   l_01856
    bset    #$1, $c61(a5)
l_01856:
    andi.w  #$60, d2
    beq.b   l_01862
    bset    #$0, $c61(a5)
l_01862:
    rts

; ============================================================================
; SubsysUpdate3 -- (TODO: name)
; 108 bytes | $001864-$0018CF
; ============================================================================
SubsysUpdate3:
    btst    #$0, $c62(a5)
    beq.b   l_018ce
    movea.l  #$00FFF08A,a0
    movea.l  #$00FFFC74,a1
    move.w  (a1)+, d0
    add.w   $c5e(a5), d0
    move.w  d0, (a0)+
    move.l  (a1)+, (a0)+
    move.w  (a1), d0
    add.w   $c5c(a5), d0
    move.w  d0, (a0)
    dc.w    $4EBA,$F756                                 ; jsr $000FE2(pc)
    movea.l  #$00C00000,a0
    movea.l  #$00C00004,a1
    move.w  #$8f02, (a1)
    moveq   #$0,d0
    move.w  $3e(a5), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    swap    d0
    andi.l  #$3, d0
    andi.l  #$3fff, d1
    swap    d1
    or.l    d0, d1
    bset    #$1e, d1
    move.l  d1, (a1)
    movea.l  #$00FFF08A,a2
    move.w  (a2)+, (a0)
    move.w  (a2)+, (a0)
    move.w  (a2)+, (a0)
    move.w  (a2)+, (a0)
l_018ce:
    rts

; ============================================================================
; SubsysUpdate4 -- (TODO: name)
; 88 bytes | $0018D0-$001927
; ============================================================================
SubsysUpdate4:
    movea.l  #$00FFF010,a5
    move.l  $be8(a5), d3
    moveq   #$0,d0
    movea.l  #$00FFFC06,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_018f8
    move.b  $4(a0), d0
    asl.l   #$8, d0
    andi.l  #$ff00, d0
    move.b  $2(a0), d0
l_018f8:
    moveq   #$0,d1
    movea.l  #$00FFFC2E,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_01916
    move.b  $4(a0), d1
    asl.l   #$8, d1
    andi.l  #$ff00, d1
    move.b  $2(a0), d1
l_01916:
    swap    d1
    or.l    d1, d0
    move.l  $be4(a5), d2
    and.l   d2, d0
    or.l    d0, d3
    move.l  d3, $be8(a5)
    rts

; ============================================================================
; func_001928 -- (TODO: name)
; 52 bytes | $001928-$00195B
; ============================================================================
func_001928:
    move.l  $42(a7), d0
l_0192c:
    bra.b   l_0192c
    dc.w    $4EBA,$F81A                                 ; jsr $00114A(pc)
    lea     $a(a1), a2
    moveq   #$7,d0
l_01938:
    move.w  #$ffff, (a2)
    lea     $a(a2), a2
    dbra    d0, $1938
    moveq   #$0,d0
    dc.w    $6100,$0014                                 ; bsr.w $00195C
    move.b  d0, (a1)
    moveq   #$1,d0
    dc.w    $6100,$000C                                 ; bsr.w $00195C
    move.b  d0, $1(a1)
    dc.w    $4EBA,$F806                                 ; jsr $00115E(pc)
    rts

; ============================================================================
; func_00195C -- (TODO: name)
; 50 bytes | $00195C-$00198D
; ============================================================================
func_00195C:
    movem.l d1-d7/a1-a3, -(a7)
    lea     ($00A10003).l, a0
    add.w   d0, d0
    adda.w  d0, a0
    add.w   d0, d0
    lea     $2(a1, d0.w), a2
    mulu.w  #$a, d0
    lea     $a(a1, d0.w), a1
    bsr.b   $19AE
    move.w  d0, -(a7)
    andi.w  #$e, d0
    add.w   d0, d0
    jsr     $198e(pc, d0.w)
    move.w  (a7)+, d0
    movem.l (a7)+, d1-d7/a1-a3
    rts

; ============================================================================
; func_00198E -- (TODO: name)
; 60 bytes | $00198E-$0019C9
; ============================================================================
func_00198E:
    bra.w   l_019e4
    bra.w   l_01aa2
    bra.w   l_019e4
    bra.w   l_01b70
    bra.w   l_019e4
    bra.w   l_019e4
    bra.w   l_01a20
    bra.w   l_019e8
    movem.l d2-d3, -(a7)
    moveq   #$0,d0
    move.b  #$70, (a0)
    bsr.b   $19CA
    swap    d1
    move.b  #$30, (a0)
    add.w   d0, d0
    bsr.b   $19CA
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_0019CA -- (TODO: name)
; 26 bytes | $0019CA-$0019E3
; ============================================================================
func_0019CA:
    move.b  (a0), d1
    move.b  d1, d2
    andi.b  #$c, d2
    beq.b   l_019d6
    addq.w  #$1, d0
l_019d6:
    add.w   d0, d0
    move.b  d1, d3
    andi.w  #$3, d3
    beq.b   l_019e2
    addq.w  #$1, d0
l_019e2:
    rts

; ============================================================================
; func_0019E4 -- (TODO: name)
; 4 bytes | $0019E4-$0019E7
; ============================================================================
func_0019E4:
l_019e4:
    nop
    rts

; ============================================================================
; func_0019E8 -- (TODO: name)
; 44 bytes | $0019E8-$001A13
; ============================================================================
func_0019E8:
l_019e8:
    move.w  #$f, (a1)+
    bra.b   l_019f0
l_019ee:
    clr.w   (a1)+
l_019f0:
    move.b  #$40, $6(a0)
    move.w  d1, d0
    swap    d1
    move.b  #$40, (a0)
    asl.b   #$2, d0
    andi.w  #$c0, d0
    andi.w  #$3f, d1
    or.b    d1, d0
    not.b   d0
    bsr.b   $1A14
    lea     $6(a1), a1
    rts

; ============================================================================
; func_001A14 -- (TODO: name)
; 12 bytes | $001A14-$001A1F
; ============================================================================
func_001A14:
    move.b  (a1), d1
    eor.b   d0, d1
    move.b  d0, (a1)+
    and.b   d0, d1
    move.b  d1, (a1)+
    rts

; ============================================================================
; func_001A20 -- (TODO: name)
; 130 bytes | $001A20-$001AA1
; ============================================================================
func_001A20:
l_01a20:
    move.b  #$40, $6(a0)
    moveq   #$2,d3
l_01a28:
    move.l  d1, d0
    andi.b  #$f, d0
    beq.b   l_01a56
    move.b  #$40, (a0)
    nop
    nop
    nop
    nop
    moveq   #$0,d1
    move.b  (a0), d1
    move.b  #$0, (a0)
    nop
    nop
    nop
    nop
    swap    d1
    move.b  (a0), d1
    dbra    d3, $1A28
    bra.b   l_019ee
l_01a56:
    move.b  #$40, (a0)
    nop
    nop
    nop
    nop
    moveq   #$0,d2
    move.b  (a0), d2
    move.b  #$0, (a0)
    nop
    nop
    nop
    nop
    swap    d2
    move.b  (a0), d2
    move.w  #$1, (a1)+
    move.w  d1, d0
    swap    d1
    asl.b   #$2, d0
    andi.w  #$c0, d0
    andi.w  #$3f, d1
    or.b    d1, d0
    not.b   d0
    bsr.b   $1A14
    swap    d2
    move.w  d2, d0
    not.b   d0
    andi.w  #$f, d0
    dc.w    $6100,$FF7A                                 ; bsr.w $001A14
    lea     $4(a1), a1
    rts

; ============================================================================
; func_001AA2 -- (TODO: name)
; 50 bytes | $001AA2-$001AD3
; ============================================================================
func_001AA2:
l_01aa2:
    move.b  #$20, (a0)
    move.b  #$60, $6(a0)
    btst    #$4, (a0)
    beq.w   l_01ace
    move.w  #$ff, d7
    dc.w    $6100,$01CC                                 ; bsr.w $001C86
    bcs.w   l_01ace
    moveq   #$0,d6
    dc.w    $6100,$01A8                                 ; bsr.w $001C6C
    bcs.w   l_01ace
    dc.w    $6100,$0008                                 ; bsr.w $001AD4
l_01ace:
    move.b  #$60, (a0)
    rts

; ============================================================================
; func_001AD4 -- (TODO: name)
; 78 bytes | $001AD4-$001B21
; ============================================================================
func_001AD4:
l_01ad4:
    moveq   #$0,d2
    dc.w    $6100,$0194                                 ; bsr.w $001C6C
    bcs.w   l_01c9a
    andi.w  #$f, d0
    move.b  d0, d2
    dc.w    $6100,$0186                                 ; bsr.w $001C6C
    bcs.w   l_01c9a
    asl.b   #$4, d0
    or.b    d0, d2
    swap    d2
    bsr.b   $1B02
    bcs.w   l_01c9a
    asl.w   #$4, d2
    bsr.b   $1B02
    bcs.w   l_01c9a
    bra.b   l_01b22
    dc.w    $6100,$0168                                 ; bsr.w $001C6C
    bcs.w   l_01c9a
    andi.b  #$f, d0
    or.b    d0, d2
    dc.w    $6100,$015A                                 ; bsr.w $001C6C
    bcs.w   l_01c9a
    asl.w   #$4, d2
    andi.w  #$f, d0
    or.b    d0, d2
    rts

; ============================================================================
; func_001B22 -- (TODO: name)
; 78 bytes | $001B22-$001B6F
; ============================================================================
func_001B22:
l_01b22:
    move.w  #$2, (a1)+
    move.w  d2, d3
    swap    d2
    move.b  d2, d0
    dc.w    $6100,$FEE6                                 ; bsr.w $001A14
    move.w  d3, (a1)+
    andi.w  #$ff, d3
    moveq   #$0,d0
    move.b  -$2(a1), d0
    btst    #$0, -$4(a1)
    beq.b   l_01b48
    subi.w  #$100, d0
l_01b48:
    btst    #$2, -$4(a1)
    beq.b   l_01b52
    clr.b   d0
l_01b52:
    btst    #$1, -$4(a1)
    beq.b   l_01b5e
    subi.w  #$100, d3
l_01b5e:
    btst    #$3, -$4(a1)
    beq.b   l_01b68
    clr.b   d3
l_01b68:
    neg.w   d3
    move.w  d0, (a1)+
    move.w  d3, (a1)+
    rts

; ============================================================================
; func_001B70 -- (TODO: name)
; 124 bytes | $001B70-$001BEB
; ============================================================================
func_001B70:
l_01b70:
    move.b  #$20, (a0)
    move.b  #$60, $6(a0)
    move.w  #$ff, d7
    btst    #$4, (a0)
    beq.w   l_01be6
    dc.w    $6100,$00FE                                 ; bsr.w $001C86
    bcs.w   l_01be6
    andi.b  #$f, d0
    dc.w    $6100,$00DE                                 ; bsr.w $001C72
    bcs.w   l_01be6
    andi.b  #$f, d0
    dc.w    $6100,$00E6                                 ; bsr.w $001C86
    bcs.w   l_01be6
    move.b  d0, (a2)+
    dc.w    $6100,$00C8                                 ; bsr.w $001C72
    bcs.w   l_01be6
    move.b  d0, (a2)+
    dc.w    $6100,$00D2                                 ; bsr.w $001C86
    bcs.w   l_01be6
    move.b  d0, (a2)+
    moveq   #$0,d6
    dc.w    $6100,$00AC                                 ; bsr.w $001C6C
    bcs.w   l_01be6
    move.b  d0, (a2)+
    andi.l  #$f0f0f0f, -(a2)
    bsr.b   $1BEC
    bcs.w   l_01be6
    bsr.b   $1BEC
    bcs.w   l_01be6
    bsr.b   $1BEC
    bcs.w   l_01be6
    bsr.b   $1BEC
    bcs.w   l_01be6
l_01be6:
    move.b  #$60, (a0)
    rts

; ============================================================================
; func_001BEC -- (TODO: name)
; 36 bytes | $001BEC-$001C0F
; ============================================================================
func_001BEC:
    moveq   #$0,d0
    move.b  (a2)+, d0
    cmpi.b  #$2, d0
    bhi.b   l_01c0a
    add.w   d0, d0
    add.w   d0, d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    bra.w   l_01c3a
    bra.w   l_01c10
    bra.w   l_01ad4
l_01c0a:
    lea     $a(a1), a1
    rts

; ============================================================================
; func_001C10 -- (TODO: name)
; 42 bytes | $001C10-$001C39
; ============================================================================
func_001C10:
l_01c10:
    dc.w    $6100,$003C                                 ; bsr.w $001C4E
    dc.w    $6100,$0056                                 ; bsr.w $001C6C
    bcs.w   l_01c9a
    not.b   d0
    andi.w  #$f, d0
    move.b  d0, d2
    move.w  #$1, (a1)+
    move.b  d1, d0
    dc.w    $6100,$FDE8                                 ; bsr.w $001A14
    move.b  d2, d0
    dc.w    $6100,$FDE2                                 ; bsr.w $001A14
    lea     $4(a1), a1
    rts

; ============================================================================
; func_001C3A -- (TODO: name)
; 20 bytes | $001C3A-$001C4D
; ============================================================================
func_001C3A:
l_01c3a:
    bsr.b   $1C4E
    bcs.w   l_01c9a
    clr.w   (a1)+
    move.b  d1, d0
    dc.w    $6100,$FDCE                                 ; bsr.w $001A14
    lea     $6(a1), a1
    rts

; ============================================================================
; func_001C4E -- (TODO: name)
; 30 bytes | $001C4E-$001C6B
; ============================================================================
func_001C4E:
    dc.w    $6100,$001C                                 ; bsr.w $001C6C
    bcs.w   l_01c9a
    andi.w  #$f, d0
    move.w  d0, d1
    dc.w    $6100,$000E                                 ; bsr.w $001C6C
    bcs.w   l_01c9a
    asl.w   #$4, d0
    or.b    d0, d1
    not.b   d1
    rts

; ============================================================================
; func_001C6C -- (TODO: name)
; 26 bytes | $001C6C-$001C85
; ============================================================================
func_001C6C:
    bchg    #$0, d6
    bne.b   l_01c86
    move.b  #$20, (a0)
l_01c76:
    move.b  (a0), d0
    btst    #$4, d0
    dbne    d7, $1C76
    beq.b   l_01c9a
    move.b  (a0), d0
    rts

; ============================================================================
; func_001C86 -- (TODO: name)
; 20 bytes | $001C86-$001C99
; ============================================================================
func_001C86:
l_01c86:
    move.b  #$0, (a0)
l_01c8a:
    move.b  (a0), d0
    btst    #$4, d0
    dbeq    d7, $1C8A
    bne.b   l_01c9a
    move.b  (a0), d0
    rts

; ============================================================================
; func_001C9A -- (TODO: name)
; 6 bytes | $001C9A-$001C9F
; ============================================================================
func_001C9A:
l_01c9a:
    ori.b   #$1, ccr
    rts

; ============================================================================
; func_001CA0 -- (TODO: name)
; 122 bytes | $001CA0-$001D19
; ============================================================================
func_001CA0:
    move.w  #$28, $46(a5)
    move.w  #$12c, $48(a5)
    move.b  #$a, $4a(a5)
    moveq   #$0,d0
    lea     $1d1a(pc, d0.w), a0
    movea.l  #$00FFF06A,a1
    moveq   #$A,d0
l_01cc0:
    move.w  (a0)+, (a1)+
    dbra    d0, $1CC0
l_01cc6:
    dc.w    $6100,$0090                                 ; bsr.w $001D58
    move.b  #$1, $36(a5)
l_01cd0:
    move.b  $36(a5), d0
    bne.b   l_01cd0
    movea.l  #$00A10003,a3
    dc.w    $4EBA,$EAFE                                 ; jsr $0007DC(pc)
    cmpi.b  #$f, d0
    beq.b   l_01d08
    movea.l  #$00FFFC06,a0
    moveq   #$7,d1
l_01cee:
    cmpi.w  #$2, (a0)
    bne.b   l_01d00
    move.b  $3(a0), d2
    andi.b  #$f0, d2
    bne.b   l_01d18
    bra.b   l_01d08
l_01d00:
    btst    #$7, $3(a0)
    bne.b   l_01d18
l_01d08:
    adda.l  #$a, a0
    dbra    d1, $1CEE
    subq.w  #$1, $48(a5)
    bne.b   l_01cc6
l_01d18:
    rts

    dc.w    $0EC0,$0EA0,$0E80; $001D1A
    dc.w    $0E60,$0E40,$0E20,$0E00,$0C00,$0A00,$0800,$0600; $001D20
    dc.w    $0800,$0A00,$0C00,$0E00,$0E20,$0E40,$0E60,$0E80; $001D30
    dc.w    $0EA0,$0EC0,$0EA0,$0E80,$0E60,$0E40,$0E20,$0E00; $001D40
    dc.w    $0C00,$0A00,$0800,$0600; $001D50

; === Translated block $001D58-$001D88 ===
; 1 functions, 48 bytes

; ============================================================================
; func_001D58 -- (TODO: name)
; 48 bytes | $001D58-$001D87
; ============================================================================
func_001D58:
    bset    #$0, $4b(a5)
    subq.b  #$1, $4a(a5)
    bpl.b   l_01d86
    move.b  #$1, $4a(a5)
    move.w  $46(a5), d0
    bmi.b   l_01d86
    subq.w  #$2, $46(a5)
    lea     $1d1a(pc, d0.w), a0
    movea.l  #$00FFF06A,a1
    moveq   #$A,d0
l_01d80:
    move.w  (a0)+, (a1)+
    dbra    d0, $1D80
l_01d86:
    rts


    dc.w    $0000,$0000,$0000,$0000; $001D88
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $001D90
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0111; $001DA0
    dc.w    $0001,$1667,$0015,$6666,$0155,$6666,$0155,$5666; $001DB0
    dc.w    $1555,$5661,$1455,$5516,$0000,$0000,$1111,$1111; $001DC0
    dc.w    $7778,$8889,$7777,$8888,$7777,$8888,$6777,$7888; $001DD0
    dc.w    $1111,$1111,$6677,$7788,$0000,$0000,$1111,$1100; $001DE0
    dc.w    $999A,$A100,$9999,$A101,$9999,$A115,$8999,$9115; $001DF0
    dc.w    $1111,$1155,$8899,$9155,$0000,$0000,$0011,$1111; $001E00
    dc.w    $1166,$7777,$6666,$7777,$5666,$6777,$5666,$6777; $001E10
    dc.w    $5566,$6111,$5566,$1677,$0000,$0000,$1111,$1111; $001E20
    dc.w    $8888,$9999,$8888,$9999,$7888,$8999,$7888,$8999; $001E30
    dc.w    $1111,$1111,$7788,$8899,$0000,$0000,$1111,$0000; $001E40
    dc.w    $AAA1,$0011,$AAA1,$0166,$9AA1,$1566,$9AA1,$1566; $001E50
    dc.w    $1111,$5556,$99A1,$5556,$0000,$0000,$1111,$1111; $001E60
    dc.w    $6777,$7888,$6777,$7888,$6677,$7788,$6677,$7788; $001E70
    dc.w    $6661,$1111,$6117,$7778,$0000,$0000,$1111,$1111; $001E80
    dc.w    $8999,$9AAA,$8999,$9AAA,$8899,$99AA,$8899,$99AA; $001E90
    dc.w    $1111,$1111,$8889,$999A,$0000,$0000,$1100,$0000; $001EA0
    dc.w    $A100,$0000,$A100,$0000,$A100,$0000,$A100,$0000; $001EB0
    dc.w    $1100,$0000,$A100,$0001,$0000,$0000,$0000,$0111; $001EC0
    dc.w    $0001,$1888,$0017,$7888,$0177,$7888,$1677,$7788; $001ED0
    dc.w    $1677,$7788,$6667,$7711,$0000,$0000,$1000,$0000; $001EE0
    dc.w    $9110,$0000,$8991,$0000,$8999,$1000,$8899,$9100; $001EF0
    dc.w    $8899,$9100,$8889,$9910,$1455,$5166,$1445,$5156; $001F00
    dc.w    $1445,$5156,$1444,$5155,$1444,$5155,$1444,$4155; $001F10
    dc.w    $1444,$4155,$1344,$4415,$6677,$7788,$6667,$7778; $001F20
    dc.w    $6667,$7778,$6611,$1111,$6666,$7777,$5666,$6777; $001F30
    dc.w    $5666,$6777,$5566,$6677,$8899,$9145,$8889,$9145; $001F40
    dc.w    $8889,$9144,$1111,$1144,$1111,$1144,$7811,$1144; $001F50
    dc.w    $7881,$1144,$7788,$1144,$5551,$6667,$5551,$6667; $001F60
    dc.w    $5551,$6666,$5551,$6661,$4551,$5666,$4551,$5666; $001F70
    dc.w    $4451,$5566,$4451,$5566,$7778,$8889,$7778,$8889; $001F80
    dc.w    $7777,$8888,$1111,$1111,$6777,$7888,$6777,$7888; $001F90
    dc.w    $6677,$7788,$6677,$7788,$9991,$5555,$9991,$4555; $001FA0
    dc.w    $9991,$4555,$1111,$4455,$8111,$4455,$8111,$4445; $001FB0
    dc.w    $8111,$4445,$8111,$4444,$1666,$7777,$1666,$6777; $001FC0
    dc.w    $1666,$6777,$1566,$6111,$1566,$6177,$1556,$6167; $001FD0
    dc.w    $1556,$6167,$1555,$6166,$8888,$9999,$7888,$9999; $001FE0
    dc.w    $7888,$8999,$1111,$1111,$7788,$8899,$7778,$8899; $001FF0
    dc.w    $7778,$8889,$7777,$8889,$A100,$0001,$A100,$0001; $002000
    dc.w    $9100,$0015,$1100,$0015,$9100,$0015,$9100,$0155; $002010
    dc.w    $9100,$0155,$9100,$0145,$6667,$7711,$6666,$7177; $002020
    dc.w    $6666,$7177,$5666,$6177,$5666,$1777,$5566,$1677; $002030
    dc.w    $5566,$1677,$5551,$6667,$8889,$9910,$1888,$9910; $002040
    dc.w    $1888,$9991,$1888,$8991,$7188,$8991,$7188,$8899; $002050
    dc.w    $7188,$8899,$7718,$8889,$0000,$0000,$0000,$0000; $002060
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$1000,$0000; $002070
    dc.w    $1000,$0000,$1000,$0000,$0144,$4451,$0134,$4445; $002080
    dc.w    $0014,$4445,$0013,$4444,$0001,$1144,$1111,$1111; $002090
    dc.w    $1333,$3444,$1333,$3344,$1111,$1117,$5556,$6661; $0020A0
    dc.w    $5556,$6667,$5555,$6666,$5555,$6666,$1111,$5666; $0020B0
    dc.w    $4555,$5666,$4455,$5566,$7788,$1134,$7778,$8134; $0020C0
    dc.w    $1778,$8133,$1777,$8133,$1777,$8133,$1777,$7133; $0020D0
    dc.w    $1777,$7133,$1677,$7133,$4441,$1111,$4441,$5556; $0020E0
    dc.w    $4441,$5555,$4441,$5555,$3441,$4555,$3441,$4551; $0020F0
    dc.w    $3341,$4455,$3341,$4455,$1111,$1111,$6667,$7778; $002100
    dc.w    $6666,$7777,$6666,$7777,$5666,$6777,$1111,$1111; $002110
    dc.w    $5566,$6677,$5566,$6677,$1111,$4444,$8111,$3444; $002120
    dc.w    $8111,$3444,$8111,$3344,$7111,$3344,$1111,$3334; $002130
    dc.w    $7781,$3334,$7781,$3333,$1555,$6111,$1555,$5166; $002140
    dc.w    $1555,$5166,$1455,$5166,$1455,$5166,$1445,$5111; $002150
    dc.w    $1445,$5556,$1444,$5555,$1111,$1888,$6777,$1888; $002160
    dc.w    $6777,$1888,$6677,$1788,$6677,$1788,$6667,$1778; $002170
    dc.w    $6667,$1778,$6666,$1777,$9100,$1445,$9100,$1444; $002180
    dc.w    $8100,$1444,$8101,$3444,$8101,$3444,$8101,$3344; $002190
    dc.w    $8113,$3344,$8113,$3334,$5551,$6667,$5551,$6666; $0021A0
    dc.w    $5515,$6666,$4515,$5666,$4515,$5611,$4155,$5511; $0021B0
    dc.w    $4155,$5566,$4145,$5556,$7718,$8889,$7717,$8888; $0021C0
    dc.w    $7771,$8888,$6771,$7888,$6771,$7888,$6677,$1788; $0021D0
    dc.w    $6677,$1788,$6667,$1778,$9100,$0000,$9100,$0000; $0021E0
    dc.w    $9100,$0000,$8910,$0000,$8910,$0000,$8810,$0000; $0021F0
    dc.w    $8891,$0000,$8881,$0000,$1233,$3344,$1223,$3334; $002200
    dc.w    $1111,$1111,$1222,$3333,$1222,$3333,$1222,$2333; $002210
    dc.w    $1222,$2333,$1111,$1111,$4455,$5566,$4445,$5551; $002220
    dc.w    $1111,$1116,$4444,$5555,$4444,$5555,$3444,$4555; $002230
    dc.w    $3444,$4555,$1111,$1111,$1677,$7123,$6667,$7123; $002240
    dc.w    $6667,$7122,$6666,$1012,$6666,$1012,$5661,$0001; $002250
    dc.w    $5110,$0000,$1000,$0000,$3331,$4445,$3334,$1445; $002260
    dc.w    $3333,$4111,$3333,$4444,$2333,$3444,$2333,$3444; $002270
    dc.w    $1133,$3344,$0011,$1111,$5556,$6667,$5556,$6667; $002280
    dc.w    $1111,$1111,$5555,$6666,$4555,$5666,$4555,$5666; $002290
    dc.w    $4455,$5566,$1111,$1111,$7771,$2333,$7771,$2333; $0022A0
    dc.w    $1111,$1233,$7771,$1233,$6771,$1223,$6771,$0123; $0022B0
    dc.w    $6671,$0011,$1111,$0000,$1444,$5555,$3114,$4555; $0022C0
    dc.w    $3341,$1111,$3344,$4455,$3334,$4445,$3334,$4445; $0022D0
    dc.w    $3333,$4444,$1111,$1111,$6666,$1777,$5666,$1777; $0022E0
    dc.w    $1111,$1677,$5566,$6677,$5556,$6667,$5556,$6667; $0022F0
    dc.w    $5555,$6666,$1111,$1111,$8123,$3334,$7122,$3333; $002300
    dc.w    $7722,$3333,$7722,$2331,$7722,$2331,$7722,$2231; $002310
    dc.w    $7722,$2231,$1111,$1111,$1445,$5556,$1444,$5555; $002320
    dc.w    $1444,$1111,$3444,$1555,$3441,$1555,$3341,$1455; $002330
    dc.w    $3311,$1455,$1111,$1111,$6667,$7178,$6666,$7177; $002340
    dc.w    $1111,$1177,$5666,$6777,$5666,$6777,$5566,$6677; $002350
    dc.w    $5566,$6677,$1111,$1111,$8881,$0000,$8888,$1000; $002360
    dc.w    $8888,$1000,$7888,$1000,$7888,$8100,$7788,$8100; $002370
    dc.w    $7788,$8100,$1111,$1100,$0000,$1111,$1000,$0010; $002380
    dc.w    $9110,$0010,$8991,$0010,$8999,$1010,$8899,$9100; $002390
    dc.w    $8899,$9100,$8889,$9910,$1010,$0001,$0011,$0011; $0023A0
    dc.w    $0010,$1101,$0010,$0001,$0010,$0001,$0000,$0000; $0023B0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0023C0
    dc.w    $0000,$0000,$0000,$0000,$0001,$0002,$0003,$0004; $0023D0
    dc.w    $0005,$0006,$0007,$0008,$0009,$000A,$000B,$0000; $0023E0
    dc.w    $000C,$000D,$000E,$000F,$0010,$0011,$0012,$0013; $0023F0
    dc.w    $0014,$0015,$0016,$0017,$0018,$0019,$001A,$001B; $002400
    dc.w    $001C,$001D,$001E,$001F,$0020,$0021,$0022,$0023; $002410
    dc.w    $0024,$0025,$0026,$0027,$0028,$0029,$002A,$002B; $002420
    dc.w    $002C,$002D,$002E,$002F,$0001,$0002,$0003,$0004; $002430
    dc.w    $0005,$0006,$0007,$0008,$0009,$000A,$0030,$0031; $002440
    dc.w    $000C,$000D,$000E,$000F,$0010,$0011,$0012,$0013; $002450
    dc.w    $0014,$0015,$0016,$0017,$0018,$0019,$001A,$001B; $002460
    dc.w    $001C,$001D,$001E,$001F,$0020,$0021,$0022,$0023; $002470
    dc.w    $0024,$0025,$0026,$0027,$0028,$0029,$002A,$002B; $002480
    dc.w    $002C,$002D,$002E,$002F,$0000,$0EEE,$0EC0,$0EA0; $002490
    dc.w    $0E80,$0E60,$0E40,$0E20,$0E00,$0C00,$0A00,$0800; $0024A0
    dc.w    $0600,$0800,$0A00,$0C00; $0024B0

; === Translated block $0024B8-$00260A ===
; 1 functions, 338 bytes

; ============================================================================
; CmdSendZ80Param -- (TODO: name)
; 338 bytes | $0024B8-$002609
; ============================================================================
CmdSendZ80Param:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $4EBA,$01A2                                 ; jsr $002662(pc)
    nop
    movea.l  #$00A00007,a1
    moveq   #$2,d1
    addq.l  #$6, a1
    move.l  $e(a6), d0
l_024d2:
    move.b  d0, -(a1)
    ror.l   #$8, d0
    dbra    d1, $24D2
    bra.w   l_025c2
; -- GameCommand 19/21: send single byte to Z80 --
CmdSendZ80Byte:                                                 ; $0024DE
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $4EBA,$017C                                 ; jsr $002662(pc)
    nop
    movea.l  #$00A00008,a1
    move.l  $e(a6), d0
    move.b  d0, (a1)
    bra.w   l_025c2
; -- GameCommand 20/24/25: trigger Z80 operation --
CmdTriggerZ80:                                                  ; $0024FA
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $4EBA,$0160                                 ; jsr $002662(pc)
    nop
    bra.w   l_025c2
; -- GameCommand 22: load data tables to Z80 RAM --
CmdLoadZ80Tables:                                               ; $00250A
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $4EBA,$0150                                 ; jsr $002662(pc)
    nop
    move.l  a6, -(a7)
    adda.l  #$e, a6
    movea.l  #$00A0003B,a1
    moveq   #$2,d1
    move.w  #$0, d2
l_0252a:
    asl.w   #$1, d2
    move.l  (a6), d0
    cmpi.l  #$0, d0
    beq.w   l_02560
    addi.w  #$1, d2
    movea.l d0, a0
    moveq   #$26,d0
l_02540:
    move.b  (a0)+, d3
    move.b  d3, (a1)+
    dbra    d0, $2540
l_02548:
    adda.l  #$4, a6
    dbra    d1, $252A
    movea.l  #$00A00008,a1
    move.b  d2, (a1)
    movea.l (a7)+, a6
    bra.w   l_025c2
l_02560:
    adda.l  #$27, a1
    bra.b   l_02548
; -- GameCommand 23: load encoded data to Z80 RAM --
CmdLoadZ80Encoded:                                              ; $002568
    move.w  sr, -(a7)
    ori.w   #$700, sr
    dc.w    $4EBA,$00F2                                 ; jsr $002662(pc)
    nop
    movea.l  #$00A000B0,a1
    movea.l $e(a6), a0
    moveq   #$2,d2
l_02580:
    move.b  #$0, d1
l_02584:
    move.b  (a0), d0
    cmpi.b  #$fc, d0
    bcc.w   l_025a2
l_0258e:
    cmpi.b  #$d, d1
    bcc.w   l_025ac
    move.b  (a0)+, (a1)+
    move.b  (a0)+, (a1)+
    move.b  (a0)+, (a1)+
    addi.b  #$3, d1
    bra.b   l_02584
l_025a2:
    cmpi.b  #$ff, d0
    beq.b   l_0258e
    bra.w   l_025b4
l_025ac:
    move.b  #$fe, (a1)
    bra.w   l_025b6
l_025b4:
    move.b  (a0)+, (a1)
l_025b6:
    adda.l  #$10, a1
    suba.l  d1, a1
    dbra    d2, $2580
l_025c2:
    movea.l  #$00A00007,a1
    move.l  $a(a6), d1
    subi.l  #$12, d1
    move.b  d1, (a1)
    move.b  #$2, $6(a1)
l_025da:
    dc.w    $4EBA,$009C                                 ; jsr $002678(pc)
    nop
    dc.w    $4EBA,$00A6                                 ; jsr $002688(pc)
    nop
    dc.w    $4EBA,$007A                                 ; jsr $002662(pc)
    nop
    move.b  $6(a1), d1
    cmpi.b  #$0, d1
    bne.b   l_025da
    move.b  $7(a1), d0
    dc.w    $4EBA,$007C                                 ; jsr $002678(pc)
    nop
    andi.l  #$ff, d0
    move.w  (a7)+, sr
    rts


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
    dc.w    $4EBA,$0024                                      ; jsr Z80_RequestBus(pc) [$2662]
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
; ============================================================================
; Z80_ReleaseBus -- Release Z80 bus
; ============================================================================
Z80_ReleaseBus:                                              ; $002678
    move.l  a1,-(sp)                                         ; Save A1
    movea.l #Z80_BUSREQ,a1                                   ; A1 -> Z80 bus req port
    move.w  #$0000,(a1)                                      ; Release bus
    movea.l (sp)+,a1                                         ; Restore A1
    rts
; ============================================================================
; Z80_Delay -- Busy-wait delay (~5ms at 7.67 MHz)
; ============================================================================
Z80_Delay:                                                   ; $002688
    move.l  d0,-(sp)                                         ; Save D0
    move.w  #$18CE,d0                                        ; Loop counter (6350 iterations)
.wait:                                                       ; $00268E
    dbra    d0,.wait                                         ; Spin
    move.l  (sp)+,d0                                         ; Restore D0
    rts
; --- Z80 sound driver binary begins at $002696 ---
    dc.w    $F331,$0020,$C3E0,$0000,$0000                    ; $002696
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0026A0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0026B0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$C36B; $0026C0
    dc.w    $0900,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0026D0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0026E0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0026F0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $002700
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $002710
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $002720
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $002730
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $002740
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $002750
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $002760
    dc.w    $0000,$0000,$0000,$ED56,$CD0B,$03CD,$B602,$CDF7; $002770
    dc.w    $02FB,$3A1A,$10A7,$C4BF,$0106,$033A,$1910,$4FDD; $002780
    dc.w    $2160,$0FCB,$01C5,$DC0E,$01C1,$112C,$00DD,$1910; $002790
    dc.w    $F2C3,$EC00,$DD7E,$0917,$D0DD,$7E28,$DDB6,$2920; $0027A0
    dc.w    $0B21,$F60F,$34CD,$E301,$21F6,$0F35,$DDCB,$2B4E; $0027B0
    dc.w    $C8DD,$7E00,$FE07,$C03A,$0040,$E602,$C8F3,$3A07; $0027C0
    dc.w    $10E6,$15CD,$D405,$3A07,$10F6,$2ACD,$D405,$FB21; $0027D0
    dc.w    $FD0F,$35C0,$3AFE,$0F77,$21F6,$0F34,$DD7E,$2A4F; $0027E0
    dc.w    $3A08,$103C,$E60F,$3208,$1020,$15CB,$5928,$41CB; $0027F0
    dc.w    $4120,$32CB,$4928,$09F5,$3E80,$A9DD,$772A,$4FF1; $002800
    dc.w    $CB79,$2002,$EE0F,$5FDD,$7E0D,$DDB6,$0C7B,$2805; $002810
    dc.w    $F6B0,$3211,$7FDD,$CB09,$6628,$05F6,$F032,$117F; $002820
    dc.w    $21F6,$0F35,$C979,$07A9,$CB57,$2804,$AFC3,$AC01; $002830
    dc.w    $3E0F,$DDCB,$2B8E,$FE00,$28CC,$3A06,$10F6,$1232; $002840
    dc.w    $0610,$C380,$0106,$033A,$1910,$4FDD,$2160,$0FCB; $002850
    dc.w    $01C5,$DC86,$06DD,$CB2B,$8EC1,$112C,$00DD,$1910; $002860
    dc.w    $EEAF,$321A,$1032,$1910,$C9DD,$6E02,$DD66,$037E; $002870
    dc.w    $FEFE,$C823,$2323,$7EFE,$F938,$1CFE,$FC28,$0F30; $002880
    dc.w    $16DD,$7502,$DD74,$03CD,$9408,$CDA4,$05C9,$3EFF; $002890
    dc.w    $DD77,$28DD,$7729,$C9F5,$E5DD,$CB2B,$8ECD,$8606; $0028A0
    dc.w    $E1F1,$FEFD,$2807,$FEFE,$28E4,$C32D,$02DD,$6E04; $0028B0
    dc.w    $DD66,$05DD,$7502,$DD74,$037E,$F5CD,$A405,$DDCB; $0028C0
    dc.w    $2B8E,$DD7E,$00FE,$0720,$2EDD,$7E0E,$CB67,$2820; $0028D0
    dc.w    $F33A,$0710,$E615,$CDD4,$053A,$0710,$F62A,$CDD4; $0028E0
    dc.w    $05FB,$3AFE,$0F32,$FD0F,$AF32,$0810,$DDCB,$2BCE; $0028F0
    dc.w    $F1FE,$1538,$1A18,$04F1,$A728,$22FE,$6038,$37FE; $002900
    dc.w    $F938,$23FE,$FC30,$1FCD,$9408,$DDCB,$09FE,$C93E; $002910
    dc.w    $FF32,$117F,$3EBF,$3211,$7FDD,$CB2B,$8EDD,$CB0A; $002920
    dc.w    $B6DD,$CB09,$FEC9,$DD36,$0D00,$DD36,$0C00,$CD1B; $002930
    dc.w    $06DD,$CB0A,$B6C9,$1601,$CDA3,$0DC9,$3E30,$CDD4; $002940
    dc.w    $053E,$221E,$00CD,$DC05,$DD21,$840E,$CDD8,$02DD; $002950
    dc.w    $2160,$0FCD,$D802,$3E2B,$1E00,$CDDC,$05C9,$3EB4; $002960
    dc.w    $1EC0,$CDDC,$053C,$CDDC,$053C,$CDDC,$053E,$901E; $002970
    dc.w    $00CD,$DC05,$3CCD,$DC05,$3CCD,$DC05,$C906,$0478; $002980
    dc.w    $3D0F,$0F0F,$C69F,$3211,$7F10,$F43E,$E732,$117F; $002990
    dc.w    $C9DD,$2184,$0E06,$08CD,$CA06,$2100,$00DD,$7502; $0029A0
    dc.w    $DD74,$03DD,$750C,$DD74,$0DCD,$FE06,$112C,$00DD; $0029B0
    dc.w    $1910,$E41E,$0021,$B000,$0110,$00E5,$CDCA,$03E1; $0029C0
    dc.w    $DD75,$04DD,$7405,$1C7B,$09FE,$0338,$EE3E,$78CD; $0029D0
    dc.w    $6F07,$C9C5,$D5E5,$0603,$2E00,$3EB4,$1EC0,$CDFE; $0029E0
    dc.w    $053C,$2C10,$F93E,$B4CD,$FE05,$E1D1,$C1C9,$E52E; $0029F0
    dc.w    $043E,$B51E,$C0CD,$FE05,$3C2C,$CDFE,$05E1,$C9D5; $002A00
    dc.w    $1415,$2804,$07C3,$7B03,$D1C9,$D514,$1528,$040F; $002A10
    dc.w    $C386,$03D1,$C9C5,$0604,$0010,$FDC1,$C93A,$0710; $002A20
    dc.w    $E6FA,$C3D4,$0521,$0700,$C3B3,$03F0,$0375,$0481; $002A30
    dc.w    $048E,$049C,$04EF,$04B7,$057E,$FE07,$D087,$5F16; $002A40
    dc.w    $0021,$A503,$195E,$2356,$EBF5,$E321,$0700,$23C9; $002A50
    dc.w    $7BFE,$033F,$D8D5,$C605,$2E2C,$CDA8,$0711,$840E; $002A60
    dc.w    $19E5,$DDE1,$B7D1,$C921,$0000,$DD75,$0CDD,$740D; $002A70
    dc.w    $CDFE,$06C3,$CA06,$E5CD,$8A07,$CD4D,$0321,$EC0F; $002A80
    dc.w    $CBC6,$2184,$0E11,$850E,$01DB,$00AF,$77ED,$B032; $002A90
    dc.w    $E80F,$32EA,$0F32,$EB0F,$E123,$237E,$2346,$CB20; $002AA0
    dc.w    $CDBF,$0546,$CBF8,$234E,$6960,$DD21,$840E,$AFDD; $002AB0
    dc.w    $7700,$DD77,$01DD,$3609,$01DD,$3619,$01DD,$3617; $002AC0
    dc.w    $30DD,$3618,$2DDD,$3616,$FFFE,$0438,$04DD,$360B; $002AD0
    dc.w    $0FF5,$5E23,$5623,$7BB2,$2803,$EB09,$EBDD,$7304; $002AE0
    dc.w    $DD72,$05DD,$7302,$DD72,$03F1,$112C,$00DD,$193C; $002AF0
    dc.w    $FE05,$38BB,$3E78,$CD6F,$0718,$0C7E,$B720,$05CD; $002B00
    dc.w    $8A07,$1803,$32E8,$0F21,$0700,$3AEC,$0FE5,$FDE1; $002B10
    dc.w    $FD77,$07C9,$5E21,$EC0F,$CBBE,$1C1D,$28E9,$CBFE; $002B20
    dc.w    $18E5,$CD68,$031E,$FF56,$0603,$CB0A,$10FC,$7A32; $002B30
    dc.w    $1910,$1C7B,$FE03,$3034,$CB02,$30F6,$D5CD,$CA03; $002B40
    dc.w    $CDE1,$03DD,$7E00,$FE07,$2806,$DD36,$0B00,$1804; $002B50
    dc.w    $DD36,$0B0F,$DDCB,$09DE,$7B3C,$1127,$0021,$3B00; $002B60
    dc.w    $1801,$193D,$20FC,$CD73,$0BD1,$18C6,$AFFD,$2107; $002B70
    dc.w    $00FD,$7707,$C91E,$FF3A,$1910,$571C,$7BFE,$03D2; $002B80
    dc.w    $E604,$CB02,$30F5,$D5CD,$CA03,$DD6E,$04DD,$7502; $002B90
    dc.w    $DD66,$05DD,$7403,$7EFE,$F938,$15FE,$FF28,$11FE; $002BA0
    dc.w    $FC30,$79CD,$9408,$CDA4,$05DD,$CB09,$FED1,$18CB; $002BB0
    dc.w    $F5CD,$A405,$DD7E,$00FE,$0720,$30DD,$CB2B,$8EDD; $002BC0
    dc.w    $7E0E,$CB67,$281E,$AF32,$0810,$3A07,$10E6,$15CD; $002BD0
    dc.w    $D405,$3A07,$10F6,$2ACD,$D405,$3AFE,$0F32,$FD0F; $002BE0
    dc.w    $DDCB,$2BCE,$F1FE,$1538,$1B18,$04F1,$A728,$23FE; $002BF0
    dc.w    $6038,$2EDD,$360D,$00DD,$360C,$00CD,$1B06,$DDCB; $002C00
    dc.w    $0AB6,$1822,$3EFF,$3211,$7F3E,$BF32,$117F,$DDCB; $002C10
    dc.w    $2B8E,$DDCB,$09FE,$DDCB,$0AB6,$180A,$CD86,$0618; $002C20
    dc.w    $0516,$01CD,$A30D,$D1C3,$F504,$234E,$2346,$DD71; $002C30
    dc.w    $28DD,$7029,$DD7E,$09E6,$9DDD,$7709,$C93E,$0132; $002C40
    dc.w    $1A10,$C3E6,$04E5,$C521,$0060,$0609,$F317,$F5E6; $002C50
    dc.w    $0177,$F11F,$10F8,$FBC1,$E1C9,$5FE6,$CF32,$0710; $002C60
    dc.w    $3E27,$E5C5,$4721,$0040,$7E17,$38FC,$78FE,$3038; $002C70
    dc.w    $0ADD,$7E00,$FE03,$7838,$022E,$0277,$2CF5,$F173; $002C80
    dc.w    $78C1,$E1C9,$F5C5,$E547,$4D21,$0040,$7E17,$38FC; $002C90
    dc.w    $79FE,$0338,$022E,$0278,$772C,$F5F1,$73E1,$C1F1; $002CA0
    dc.w    $C9F5,$D5DD,$7E00,$FE04,$2804,$FE07,$2043,$D604; $002CB0
    dc.w    $E602,$57DD,$5E0E,$A728,$25CB,$6328,$0A1E,$00DD; $002CC0
    dc.w    $CB2A,$5620,$021E,$0FDD,$CB09,$6628,$077B,$2FF6; $002CD0
    dc.w    $F032,$117F,$DD7E,$0DDD,$B60C,$2002,$1E00,$7A07; $002CE0
    dc.w    $0707,$07C6,$9057,$7B2F,$E60F,$B232,$117F,$C373; $002CF0
    dc.w    $06DD,$5E01,$3E28,$CDDC,$05DD,$7E09,$F6C0,$DD77; $002D00
    dc.w    $09DD,$7E0A,$F603,$DD77,$0AD1,$F1C9,$F5D5,$DD7E; $002D10
    dc.w    $00FE,$0428,$0BFE,$0720,$1957,$3EFF,$3211,$7F7A; $002D20
    dc.w    $D604,$E602,$0707,$0707,$C690,$F60F,$3211,$7FC3; $002D30
    dc.w    $BB06,$FE03,$3805,$FE05,$3001,$3C5F,$3E28,$CDDC; $002D40
    dc.w    $05DD,$7E09,$E65F,$DD77,$09DD,$CB0A,$B6D1,$F1C9; $002D50
    dc.w    $CD86,$06DD,$CB09,$B6DD,$7E00,$FE07,$C8FE,$04C8; $002D60
    dc.w    $D5E5,$FE03,$3808,$D603,$FE01,$3802,$D601,$2100; $002D70
    dc.w    $00CD,$FE06,$C680,$110F,$04CD,$DC05,$C604,$1520; $002D80
    dc.w    $F8E1,$D1C9,$F5D5,$E5DD,$7E00,$EB21,$0910,$CB27; $002D90
    dc.w    $856F,$7CCE,$0067,$7BBE,$2006,$7A23,$BE28,$322B; $002DA0
    dc.w    $7323,$72EB,$DD7E,$00FE,$0428,$1FFE,$0728,$1BFE; $002DB0
    dc.w    $0338,$08D6,$03FE,$0138,$02D6,$01C6,$A45C,$CDDC; $002DC0
    dc.w    $05D6,$045D,$CDDC,$05C3,$4B07,$D604,$E602,$CD4F; $002DD0
    dc.w    $07E1,$D1F1,$C9E5,$F57D,$E60F,$CB3C,$CB1D,$CB3C; $002DE0
    dc.w    $CB1D,$CB3C,$CB1D,$CB3C,$CB1D,$677D,$E63F,$6FF1; $002DF0
    dc.w    $CD4D,$08E1,$C9B7,$C8C5,$D5E5,$2106,$F916,$005F; $002E00
    dc.w    $CD2F,$0822,$EF0F,$2100,$0022,$ED0F,$E1D1,$C1C9; $002E10
    dc.w    $21EC,$0FCB,$86DD,$2184,$0E06,$05CD,$CA06,$DD36; $002E20
    dc.w    $0200,$DD36,$0300,$112C,$00DD,$1910,$EEC9,$F5C5; $002E30
    dc.w    $D5EB,$672E,$0055,$0608,$2930,$0119,$10FA,$D1C1; $002E40
    dc.w    $F1C9,$C5D5,$EB21,$0000,$4F44,$3E10,$CB23,$CB12; $002E50
    dc.w    $ED6A,$B7ED,$421C,$3002,$091D,$3DC2,$C607,$656B; $002E60
    dc.w    $D1C1,$7DC9,$C5D5,$D9C1,$2100,$005D,$54D9,$0610; $002E70
    dc.w    $D929,$CB13,$CB12,$D9ED,$6AD9,$3004,$0930,$0113; $002E80
    dc.w    $D910,$EDD9,$C1C9,$C5D9,$C121,$0000,$5D54,$D906; $002E90
    dc.w    $2029,$CB13,$CB12,$D9ED,$6ACB,$13CB,$12B7,$ED42; $002EA0
    dc.w    $300A,$7BB2,$1B20,$0513,$09D9,$2BD9,$D923,$10E1; $002EB0
    dc.w    $E5D9,$D1EB,$C9C5,$4B42,$EB21,$0000,$3E10,$CB23; $002EC0
    dc.w    $CB12,$ED6A,$B7ED,$421C,$3002,$091D,$3DC2,$3808; $002ED0
    dc.w    $EBC1,$C9C5,$4FCB,$09CB,$09CB,$09CB,$09CB,$F97C; $002EE0
    dc.w    $B132,$117F,$7D32,$117F,$C1C9,$F5D5,$E57B,$E61F; $002EF0
    dc.w    $CD7E,$087A,$3211,$7F7B,$3211,$7F3E,$E732,$117F; $002F00
    dc.w    $E1D1,$F1C9,$2135,$11CB,$2785,$6F7C,$CE00,$6756; $002F10
    dc.w    $235E,$7AE6,$0FF6,$C057,$C9C9,$E567,$DD7E,$00FE; $002F20
    dc.w    $0728,$10D6,$042E,$B485,$6F7C,$D6F8,$0F0F,$5F7D; $002F30
    dc.w    $CDDC,$057C,$E1C9,$DD7E,$00FE,$07C0,$E57B,$B220; $002F40
    dc.w    $0113,$7A0F,$0F0F,$0FE6,$0F6F,$2600,$7AE6,$0FB3; $002F50
    dc.w    $2801,$237D,$32FD,$0F32,$FE0F,$EBCD,$2F08,$11FF; $002F60
    dc.w    $02CD,$DE07,$0180,$70CD,$0008,$7DED,$445F,$3E26; $002F70
    dc.w    $CDDC,$05E1,$C97B,$E60F,$CB57,$2002,$F680,$DD77; $002F80
    dc.w    $2AC9,$F5D5,$3A07,$10E6,$C3F6,$0CCD,$D405,$D1F1; $002F90
    dc.w    $C9F5,$D53A,$0710,$E6F3,$CDD4,$05D1,$F1C9,$F5D5; $002FA0
    dc.w    $3A07,$10E6,$CFF6,$10CD,$D405,$D1F1,$C92A,$F10F; $002FB0
    dc.w    $7DB4,$280B,$2B22,$F10F,$FBCD,$550E,$F318,$EE2A; $002FC0
    dc.w    $F30F,$7DB4,$2809,$2B22,$F30F,$FBCD,$9F14,$F33A; $002FD0
    dc.w    $0D00,$FE02,$380C,$3E01,$320D,$00CD,$9F03,$AF32; $002FE0
    dc.w    $0D00,$2AF1,$0F7D,$B420,$CB2A,$F30F,$7DB4,$20D6; $002FF0
    dc.w    $C9F3,$F5C5,$D5E5,$DDE5,$DD21,$600F,$112C,$0006; $003000
    dc.w    $03DD,$6E28,$DD66,$297D,$B428,$072B,$DD75,$28DD; $003010
    dc.w    $7429,$DD19,$10EB,$2AED,$0F11,$5203,$19ED,$5BEF; $003020
    dc.w    $0F7B,$B228,$19AF,$ED52,$3804,$3CC3,$A009,$1922; $003030
    dc.w    $ED0F,$2AF1,$0F85,$6F7C,$CE00,$6722,$F10F,$2AF3; $003040
    dc.w    $0F23,$22F3,$0F3A,$F60F,$B720,$213C,$32F6,$0FC5; $003050
    dc.w    $08F5,$D9C5,$D5E5,$DDE5,$FDE5,$CD27,$09FD,$E1DD; $003060
    dc.w    $E1E1,$D1C1,$D9F1,$08C1,$21F6,$0F35,$DDE1,$E1D1; $003070
    dc.w    $C1F1,$FBED,$4DDD,$6E1C,$DD66,$1DE6,$0F20,$0A7D; $003080
    dc.w    $B4C0,$DD71,$1CDD,$701D,$C95F,$7DB4,$C8DD,$7E1B; $003090
    dc.w    $B720,$0A1C,$DD73,$1BDD,$711E,$DD70,$1FDD,$351B; $0030A0
    dc.w    $2803,$4D44,$C9DD,$361C,$00DD,$361D,$00C9,$03C9; $0030B0
    dc.w    $0A03,$57DD,$7E00,$FE04,$C8FE,$07C8,$5F7A,$1601; $0030C0
    dc.w    $A728,$0914,$FE7F,$2804,$14FE,$40C0,$7BFE,$0338; $0030D0
    dc.w    $08D6,$03FE,$0138,$02D6,$011E,$B483,$CB0A,$CB0A; $0030E0
    dc.w    $5ACD,$DC05,$C90A,$036F,$DD7E,$0057,$FE04,$2804; $0030F0
    dc.w    $FE07,$2048,$7DE6,$0F6F,$DD77,$0B7A,$FE05,$300D; $003100
    dc.w    $3AEB,$0F2F,$CDA8,$075C,$1600,$1319,$6CDD,$7E0F; $003110
    dc.w    $57E6,$0FCD,$A807,$7D0F,$0F0F,$0FE6,$0F3C,$850F; $003120
    dc.w    $0F0F,$0FE6,$0FCB,$6228,$02F6,$10DD,$770E,$DDCB; $003130
    dc.w    $097E,$C82F,$E60F,$F690,$3211,$7FC9,$CBBD,$DD75; $003140
    dc.w    $0B1E,$007A,$FE05,$300A,$3AEB,$0FA7,$7DC4,$370B; $003150
    dc.w    $835F,$C5DD,$4E06,$DD46,$0779,$B028,$13C5,$FDE1; $003160
    dc.w    $FD7E,$00E6,$074F,$0600,$2155,$1009,$4ECD,$EC0A; $003170
    dc.w    $C1C9,$C5D5,$E5DD,$E5FD,$E57A,$6AFE,$0338,$08D6; $003180
    dc.w    $03FE,$0138,$02D6,$0116,$4082,$5706,$04FD,$7E06; $003190
    dc.w    $CB39,$3008,$E67F,$83F2,$160B,$3E7F,$DD77,$0ED5; $0031A0
    dc.w    $5F7A,$CDFE,$05D1,$C604,$57DD,$23FD,$2310,$DEFD; $0031B0
    dc.w    $E1DD,$E1E1,$D1C1,$C9DD,$7E0B,$C361,$0AD9,$2F6F; $0031C0
    dc.w    $3AEB,$0F0F,$0FE6,$3F2F,$CDA8,$075C,$1600,$1319; $0031D0
    dc.w    $7C2F,$FE80,$3802,$3E7F,$D9C9,$0A03,$C36F,$070A; $0031E0
    dc.w    $032F,$5F16,$0013,$21F4,$10CD,$2F08,$7DC3,$6F07; $0031F0
    dc.w    $0A6F,$030A,$6709,$032B,$2BDD,$7506,$DD74,$07E5; $003200
    dc.w    $DD7E,$00FE,$0428,$52FE,$0728,$4E16,$00FE,$0338; $003210
    dc.w    $0ACB,$D2D6,$03FE,$0138,$02D6,$01C5,$4782,$57CD; $003220
    dc.w    $CA06,$5E23,$3EB0,$80CD,$DC05,$7E23,$0707,$0707; $003230
    dc.w    $E6F0,$B2DD,$7701,$3E30,$8006,$045E,$23CD,$DC05; $003240
    dc.w    $C604,$10F7,$C610,$2323,$2323,$0610,$5E23,$CDDC; $003250
    dc.w    $05C6,$0410,$F7C1,$C305,$0C5E,$237E,$2307,$0707; $003260
    dc.w    $07E6,$10DD,$5609,$CBA2,$B2DD,$7709,$E610,$C464; $003270
    dc.w    $087E,$23DD,$770E,$DD77,$0FE6,$1028,$0E5E,$2356; $003280
    dc.w    $23CD,$B008,$5EDD,$732A,$CDEF,$08FD,$E1FD,$7E26; $003290
    dc.w    $DD77,$08DD,$CB0A,$BEDD,$CB09,$96FD,$7E25,$B728; $0032A0
    dc.w    $0EDD,$CB09,$D6DD,$CB09,$5E28,$04DD,$CB0A,$FEC3; $0032B0
    dc.w    $310B,$0A03,$DDCB,$0A9E,$B7F2,$3C0C,$DDCB,$0ADE; $0032C0
    dc.w    $ED44,$FE0D,$3801,$AF6F,$2600,$2911,$1B10,$195E; $0032D0
    dc.w    $2356,$DD73,$22DD,$7223,$0A03,$5F16,$0013,$2100; $0032E0
    dc.w    $80CD,$2F08,$DD75,$20DD,$7421,$AFDD,$7724,$DD77; $0032F0
    dc.w    $25DD,$7726,$DD77,$27DD,$CB0A,$AEDD,$CB0A,$A6DD; $003300
    dc.w    $CB09,$CEC3,$AA0C,$DDCB,$0A7E,$C0DD,$CB09,$DEDD; $003310
    dc.w    $CB09,$56C8,$DD7E,$0AF6,$83DD,$770A,$C9DD,$CB0A; $003320
    dc.w    $7EC8,$DDCB,$099E,$DDCB,$0ABE,$DD7E,$09E6,$C0C8; $003330
    dc.w    $DD6E,$0CDD,$660D,$C3FE,$06DD,$7E1B,$3DC0,$DD77; $003340
    dc.w    $1BDD,$771C,$DD77,$1DDD,$4E1E,$DD46,$1FC9,$DD71; $003350
    dc.w    $04DD,$7005,$C9CD,$8606,$0100,$003A,$EC0F,$07D0; $003360
    dc.w    $DDCB,$0946,$C0DD,$3617,$30DD,$3618,$2DDD,$3619; $003370
    dc.w    $01AF,$DD77,$1ADD,$771B,$DD77,$1CDD,$771D,$DD4E; $003380
    dc.w    $04DD,$4605,$C903,$03C9,$010D,$2A0A,$EF09,$280A; $003390
    dc.w    $5F0A,$590B,$540B,$000D,$6A0B,$FF0C,$FF0C,$2C0C; $0033A0
    dc.w    $800C,$970C,$010D,$010D,$010D,$B30C,$C80C,$CF0C; $0033B0
    dc.w    $DD4E,$02DD,$4603,$79B0,$C8DD,$3519,$280C,$DD7E; $0033C0
    dc.w    $1AB7,$C8DD,$351A,$C0C3,$8606,$CD52,$0DDD,$7102; $0033D0
    dc.w    $DD70,$03DD,$CB09,$86C9,$0A03,$FE60,$383E,$FEC0; $0033E0
    dc.w    $3832,$2E00,$FECF,$3816,$2CFE,$D038,$112C,$FEE0; $0033F0
    dc.w    $380C,$2CFE,$F038,$072C,$67D6,$F085,$6F7C,$2600; $003400
    dc.w    $2911,$020D,$195E,$2356,$EB11,$880D,$D5E9,$79B0; $003410
    dc.w    $C252,$0DC9,$D660,$DD56,$18C3,$A30D,$5F0A,$03DD; $003420
    dc.w    $7717,$0A03,$DD77,$1857,$7B14,$1520,$0ACD,$8606; $003430
    dc.w    $DD36,$16FF,$C33A,$0EDD,$8608,$F5F2,$BA0D,$ED44; $003440
    dc.w    $1E00,$D60C,$3804,$1CC3,$BC0D,$C60C,$57F1,$FAD8; $003450
    dc.w    $0DFE,$60DA,$DB0D,$1E07,$7AC6,$54C3,$DB0D,$1E00; $003460
    dc.w    $7ADD,$CB09,$6E28,$08DD,$BE16,$2006,$C330,$0ECD; $003470
    dc.w    $8606,$DD77,$16DD,$7E00,$FE04,$2804,$FE07,$2010; $003480
    dc.w    $DD6E,$1626,$0029,$1175,$1019,$5E23,$56C3,$1B0E; $003490
    dc.w    $7B6A,$2600,$2911,$5D10,$195E,$2356,$0707,$07B2; $0034A0
    dc.w    $57EB,$CDFE,$06DD,$750C,$DD74,$0DDD,$CB09,$6ECC; $0034B0
    dc.w    $1B06,$DDCB,$0AB6,$DDCB,$094E,$2804,$DDCB,$0AF6; $0034C0
    dc.w    $DD7E,$17DD,$7719,$DD5E,$18DD,$731A,$DDCB,$098E; $0034D0
    dc.w    $DDCB,$09EE,$BBD8,$DDCB,$09AE,$C9DD,$2184,$0E06; $0034E0
    dc.w    $053A,$EC0F,$0F30,$1CAF,$F5C5,$CD2A,$0DC1,$F1DD; $0034F0
    dc.w    $B602,$DDB6,$0311,$2C00,$DD19,$10EC,$B7C0,$21EC; $003500
    dc.w    $0FCB,$8621,$0000,$22ED,$0FC9,$0000,$0000,$0000; $003510
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $003520
    dc.w    $FF30,$2D01,$0000,$0000,$0000,$0000,$0000,$0000; $003530
    dc.w    $0000,$0000,$0000,$0101,$0000,$0000,$0000,$0000; $003540
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$FF30,$2D01; $003550
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $003560
    dc.w    $0000,$0202,$0000,$0000,$0000,$0000,$0000,$0000; $003570
    dc.w    $0000,$0000,$0000,$0000,$FF30,$2D01,$0000,$0000; $003580
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0303; $003590
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0035A0
    dc.w    $0000,$0000,$FF30,$2D01,$0000,$0000,$0000,$0000; $0035B0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0404,$0000,$0000; $0035C0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $0035D0
    dc.w    $FF30,$2D01,$0000,$0000,$0000,$0000,$0000,$0000; $0035E0
    dc.w    $0000,$0000,$0000,$0505,$0000,$0000,$0000,$0000; $0035F0
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$FF30,$2D01; $003600
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $003610
    dc.w    $0000,$0606,$0000,$0000,$0000,$0000,$0000,$0000; $003620
    dc.w    $0000,$0000,$0000,$0000,$FF30,$2D01,$0000,$0000; $003630
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0707; $003640
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $003650
    dc.w    $0000,$0000,$FF30,$2D01,$0000,$0000,$0000,$0000; $003660
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$7D03,$0088; $003670
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $003680
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$3F00,$00FF; $003690
    dc.w    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FF00; $0036A0
    dc.w    $0000,$009C,$07AD,$0F38,$1845,$21DC,$2A05,$35C9; $0036B0
    dc.w    $3F30,$4B45,$5712,$64A2,$7100,$804C,$0072,$00BE; $0036C0
    dc.w    $000A,$017D,$01FE,$029C,$07AD,$0F45,$21DC,$2AC9; $0036D0
    dc.w    $3F30,$4B45,$5700,$8059,$9F0A,$EA08,$0808,$080C; $0036E0
    dc.w    $0E0E,$0F84,$02AA,$02D3,$02FE,$022B,$035B,$038E; $0036F0
    dc.w    $03C5,$03FE,$033B,$047B,$04BF,$0400,$0000,$0000; $003700
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $003710
    dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000; $003720
    dc.w    $0000,$0000,$00F9,$03C0,$038A,$0357,$0327,$03FA; $003730
    dc.w    $02CF,$02A7,$0281,$025D,$023B,$021B,$02FC,$01E0; $003740
    dc.w    $01C5,$01AC,$0194,$017D,$0168,$0153,$0140,$012E; $003750
    dc.w    $011D,$010D,$01FE,$00F0,$00E2,$00D6,$00CA,$00BE; $003760
    dc.w    $00B4,$00AA,$00A0,$0097,$008F,$0087,$007F,$0078; $003770
    dc.w    $0071,$006B,$0065,$005F,$005A,$0055,$0050,$004C; $003780
    dc.w    $0047,$0043,$0040,$003C,$0039,$0035,$0032,$002F; $003790
    dc.w    $002C,$002A,$0028,$0025,$0023,$0021,$001F,$001E; $0037A0
    dc.w    $001C,$001A,$0019,$0017,$0016,$0015,$0014,$0012; $0037B0
    dc.w    $0010,$000F,$000E,$000D,$000C,$0001,$0005,$0009; $0037C0
    dc.w    $000D,$0001,$0105,$0109,$010D,$0101,$0205,$0209; $0037D0
    dc.w    $020D,$0201,$0305,$0309,$030D,$0301,$0405,$0409; $0037E0
    dc.w    $040D,$0401,$0505,$0509,$050D,$0501,$0605,$0609; $0037F0
    dc.w    $060D,$0601,$0705,$0709,$070D,$0701,$0805,$08FD; $003800
    dc.w    $7E1C,$3D28,$483D,$286D,$3DCA,$3012,$3DCA,$7312; $003810
    dc.w    $DD6E,$20DD,$6621,$DDCB,$0A6E,$2807,$2B7C,$2F67; $003820
    dc.w    $7D2F,$6FDD,$5E26,$DD56,$2719,$2B7C,$2307,$300D; $003830
    dc.w    $EBDD,$7E0A,$EE20,$DD77,$0A37,$C3BD,$11DD,$7526; $003840
    dc.w    $DD74,$27D0,$DD7E,$0AEE,$10DD,$770A,$C9DD,$5E20; $003850
    dc.w    $DD56,$2121,$0080,$CD2F,$08EB,$DD6E,$24DD,$6625; $003860
    dc.w    $CD2F,$08DD,$7E0A,$E6EF,$CB45,$2802,$F610,$DD77; $003870
    dc.w    $0A21,$0080,$C9DD,$6E20,$DD66,$2129,$DDCB,$0A6E; $003880
    dc.w    $2807,$2B7C,$2F67,$7D2F,$6FDD,$5E26,$DD56,$2719; $003890
    dc.w    $2B7C,$2307,$300D,$EBDD,$7E0A,$EE20,$DD77,$0A37; $0038A0
    dc.w    $C323,$12DD,$7526,$DD74,$27D0,$DD7E,$0ACB,$6FC0; $0038B0
    dc.w    $EE10,$DD77,$0AC9,$DD5E,$20DD,$5621,$21FF,$7FCD; $0038C0
    dc.w    $2F08,$EBCB,$C3DD,$6E24,$DD66,$25CB,$7C28,$072B; $0038D0
    dc.w    $7C2F,$677D,$2F6F,$CD2F,$082A,$E60F,$7AB3,$C011; $0038E0
    dc.w    $8303,$CDDE,$07CB,$24DD,$CB0A,$A6CB,$7C28,$06DD; $0038F0
    dc.w    $CB0A,$E6CB,$BC22,$E60F,$C9DD,$6E26,$DD66,$277C; $003900
    dc.w    $D680,$B5C8,$DD6E,$20DD,$6621,$DDCB,$0A6E,$2807; $003910
    dc.w    $2B7C,$2F67,$7D2F,$6FDD,$5E26,$DD56,$2719,$2B7C; $003920
    dc.w    $2307,$300D,$EBDD,$7E0A,$EE20,$DD77,$0A37,$C3B1; $003930
    dc.w    $12DD,$7526,$DD74,$27D0,$2100,$80DD,$7526,$DD74; $003940
    dc.w    $27C9,$DD5E,$0CDD,$7E0D,$E607,$5704,$0520,$38D5; $003950
    dc.w    $CDDE,$07EB,$CB22,$ED6A,$DD5E,$22DD,$5623,$CDDE; $003960
    dc.w    $07EB,$29D1,$19DD,$7E0D,$E638,$477C,$FE08,$3841; $003970
    dc.w    $78FE,$3830,$0AC6,$0847,$CB3C,$CB1D,$C3E5,$1206; $003980
    dc.w    $3821,$FF07,$C32B,$13D5,$DD5E,$22DD,$5623,$CDDE; $003990
    dc.w    $07EB,$0100,$4009,$4D44,$D121,$0000,$CB3A,$CB1B; $0039A0
    dc.w    $CB1C,$CB3A,$CB1B,$CB1C,$CD00,$08DD,$7E0D,$E638; $0039B0
    dc.w    $477C,$B067,$C3FE,$0604,$0528,$28DD,$5E0C,$DD56; $0039C0
    dc.w    $0DD5,$CDDE,$07EB,$CB22,$ED6A,$DD5E,$22DD,$5623; $0039D0
    dc.w    $CDDE,$07EB,$29D1,$197C,$FE04,$DAFE,$0621,$FF03; $0039E0
    dc.w    $C3FE,$06DD,$5E22,$DD56,$23CD,$DE07,$EB01,$0040; $0039F0
    dc.w    $094D,$44DD,$5E0C,$DD56,$0D21,$0000,$CB3A,$CB1B; $003A00
    dc.w    $CB1C,$CB3A,$CB1B,$CB1C,$CD00,$08C3,$FE06,$DDCB; $003A10
    dc.w    $0A9E,$FD7E,$1DB7,$F29B,$13DD,$CB0A,$DEED,$44E6; $003A20
    dc.w    $7FC8,$3C5F,$1600,$EB29,$CDDE,$076C,$63DD,$7E0A; $003A30
    dc.w    $4707,$A8E6,$1047,$DD7E,$00FE,$04CA,$3113,$FE07; $003A40
    dc.w    $CA31,$13C3,$BC12,$DDCB,$0A7E,$CA97,$14DD,$7E09; $003A50
    dc.w    $E6C0,$282F,$FD7E,$1EE6,$0F87,$5F16,$0021,$3510; $003A60
    dc.w    $195E,$2356,$DD73,$22DD,$7223,$FD6E,$1AFD,$661B; $003A70
    dc.w    $7CFE,$40DA,$F313,$2100,$40DD,$7520,$DD74,$217C; $003A80
    dc.w    $B520,$0BDD,$7E0A,$F603,$DD77,$0AC3,$9714,$DD7E; $003A90
    dc.w    $0AE6,$03CA,$9714,$3D28,$4F3D,$287B,$DDCB,$0AC6; $003AA0
    dc.w    $DDCB,$0A8E,$FD7E,$24B7,$2811,$3D28,$4B6F,$2600; $003AB0
    dc.w    $2929,$DD75,$24DD,$7425,$C397,$14FD,$7E1C,$FE04; $003AC0
    dc.w    $2836,$2AE4,$0FDD,$7524,$DD74,$25DD,$CB0A,$AEDD; $003AD0
    dc.w    $CB0A,$A6CB,$7C28,$32DD,$CB0A,$EEDD,$CB0A,$E62B; $003AE0
    dc.w    $7C2F,$677D,$2F6F,$1821,$DD6E,$24DD,$6625,$2BDD; $003AF0
    dc.w    $7524,$DD74,$257D,$B4C0,$2100,$00DD,$7524,$DD74; $003B00
    dc.w    $25DD,$CB0A,$AEDD,$CB0A,$A6DD,$7526,$DD74,$27DD; $003B10
    dc.w    $CB0A,$86DD,$CB0A,$CECD,$7911,$CD88,$13DD,$3424; $003B20
    dc.w    $C0DD,$3425,$C9DD,$2184,$0E06,$053A,$E80F,$B728; $003B30
    dc.w    $6121,$E90F,$CB0E,$305A,$6F3A,$EA0F,$BD38,$0ACD; $003B40
    dc.w    $8A07,$AF32,$E80F,$C34A,$155F,$7DCD,$A807,$EB2C; $003B50
    dc.w    $7D32,$EA0F,$CDA8,$07D5,$AF4D,$446F,$6158,$57ED; $003B60
    dc.w    $427B,$DE00,$5F7A,$DE00,$57C1,$CD00,$087D,$2425; $003B70
    dc.w    $2802,$3EFF,$6F3A,$EB0F,$BD28,$177D,$32EB,$0FDD; $003B80
    dc.w    $E506,$05DD,$7E0B,$CD61,$0A11,$2C00,$DD19,$10F3; $003B90
    dc.w    $DDE1,$0608,$C5DD,$CB0A,$7620,$13DD,$6E06,$DD66; $003BA0
    dc.w    $077C,$B528,$23E5,$FDE1,$CDC0,$13C3,$4215,$CD73; $003BB0
    dc.w    $12CD,$A713,$DD7E,$27D6,$80DD,$B626,$200A,$DD75; $003BC0
    dc.w    $0CDD,$740D,$DDCB,$0AB6,$C111,$2C00,$DD19,$10C4; $003BD0
    dc.w    $2AE4,$0F23,$22E4,$0FC9; $003BE0

; === Translated block $003BE8-$003D16 ===
; 1 functions, 302 bytes

; ============================================================================
; EarlyInit -- (TODO: name)
; 302 bytes | $003BE8-$003D15
; ============================================================================
EarlyInit:
    clr.l   d0
    move.b  ($00A10001).l, d0
    lsr.b   #$6, d0
    andi.b  #$3, d0
    lea     $3d16(pc), a0
    move.b  (a0,d0.w), d0
    tst.b   d0
    beq.w   l_03cde
    lea     ($01F0).w, a0
    move.w  #$f, d1
l_03c0c:
    cmp.b   (a0), d0
    dc.w    $6700,$0360                                         ; beq $003F70
    addq.l  #$1, a0
    dbra    d1, $3C0C
    lea     ($00C00000).l, a4
    lea     ($00C00004).l, a5
    move.w  #$8164, (a5)
    move.w  #$8230, (a5)
    move.w  #$8c81, (a5)
    move.w  #$8f02, (a5)
    move.w  #$9001, (a5)
    move.l  #$c0020000, (a5)
    move.w  #$eee, (a4)
    move.l  #$40000000, (a5)
    lea     $3d98(pc), a0
    move.w  #$3a, d0
    move.l  #$10000000, d2
l_03c56:
    move.w  #$7, d6
l_03c5a:
    move.b  (a0)+, d1
    moveq   #$0,d4
    move.w  #$7, d5
l_03c62:
    rol.l   #$4, d2
    ror.b   #$1, d1
    bcc.b   l_03c6a
    or.l    d2, d4
l_03c6a:
    dbra    d5, $3C62
    move.l  d4, (a4)
    dbra    d6, $3C5A
    dbra    d0, $3C56
    move.b  #$8, d1
    lea     $3d2e(pc), a0
    move.b  (a0)+, d0
    dc.w    $6100,$005C                                 ; bsr.w $003CE0
    lea     ($01F0).w, a1
l_03c8a:
    cmpi.b  #$20, (a1)
    beq.b   l_03cd2
    lea     $3d1a(pc), a2
l_03c94:
    move.w  (a2)+, d4
    tst.b   d4
    beq.b   l_03cce
    cmp.b   (a1), d4
    bne.b   l_03cca
    cmpi.b  #$20, $1(a1)
    bne.b   l_03cba
    cmpa.l  #$1f0, a1
    beq.b   l_03cba
    lea     $3d4b(pc), a0
    move.b  (a0)+, d0
    addq.w  #$1, d1
    dc.w    $6100,$0028                                 ; bsr.w $003CE0
l_03cba:
    lea     $3d16(pc), a0
    adda.l  (a2)+, a0
    move.b  (a0)+, d0
    addq.w  #$1, d1
    dc.w    $6100,$001A                                 ; bsr.w $003CE0
    bra.b   l_03cce
l_03cca:
    addq.l  #$4, a2
    bra.b   l_03c94
l_03cce:
    addq.l  #$1, a1
    bra.b   l_03c8a
l_03cd2:
    lea     $3d4e(pc), a0
    move.b  (a0)+, d0
    addq.w  #$1, d1
    dc.w    $6100,$0004                                 ; bsr.w $003CE0
l_03cde:
    bra.b   l_03cde
    move.b  d1, d2
    andi.l  #$ff, d2
    swap    d2
    lsl.l   #$7, d2
    move.b  d0, d3
    andi.l  #$ff, d3
    swap    d3
    asl.l   #$1, d3
    add.l   d3, d2
    addi.l  #$40000003, d2
    move.l  d2, (a5)
l_03d02:
    tst.b   (a0)
    beq.b   l_03d14
    move.b  (a0)+, d2
    subi.b  #$20, d2
    andi.w  #$ff, d2
    move.w  d2, (a4)
    bra.b   l_03d02
l_03d14:
    rts


    dc.w    $4A00,$5545,$004A,$0000,$0042; $003D16
    dc.w    $0055,$0000,$0053,$0045,$0000,$0061,$0000,$0644; $003D20
    dc.w    $4556,$454C,$4F50,$4544,$2046,$4F52,$2055,$5345; $003D30
    dc.w    $204F,$4E4C,$5920,$5749,$5448,$0012,$2600,$0F53; $003D40
    dc.w    $5953,$5445,$4D53,$2E00,$0C4E,$5453,$4320,$4D45; $003D50
    dc.w    $4741,$2044,$5249,$5645,$000D,$4E54,$5343,$2047; $003D60
    dc.w    $454E,$4553,$4953,$0004,$5041,$4C20,$414E,$4420; $003D70
    dc.w    $4652,$454E,$4348,$2053,$4543,$414D,$204D,$4547; $003D80
    dc.w    $4120,$4452,$4956,$4500,$0000,$0000,$0000,$0000; $003D90
    dc.w    $1818,$1818,$0018,$1800,$3636,$4800,$0000,$0000; $003DA0
    dc.w    $1212,$7F12,$7F24,$2400,$083F,$483E,$097E,$0800; $003DB0
    dc.w    $7152,$7408,$1725,$4700,$1824,$1829,$4546,$3900; $003DC0
    dc.w    $3030,$4000,$0000,$0000,$0C10,$2020,$2010,$0C00; $003DD0
    dc.w    $3008,$0404,$0408,$3000,$0008,$2A1C,$2A08,$0000; $003DE0
    dc.w    $0808,$087F,$0808,$0800,$0000,$0000,$0030,$3040; $003DF0
    dc.w    $0000,$007F,$0000,$0000,$0000,$0000,$0030,$3000; $003E00
    dc.w    $0102,$0408,$1020,$4000,$1E33,$3333,$3333,$1E00; $003E10
    dc.w    $1838,$1818,$1818,$3C00,$3E63,$630E,$3860,$7F00; $003E20
    dc.w    $3E63,$031E,$0363,$3E00,$060E,$1E36,$667F,$0600; $003E30
    dc.w    $7E60,$7E63,$0363,$3E00,$3E63,$607E,$6363,$3E00; $003E40
    dc.w    $3F63,$0606,$0C0C,$1800,$3E63,$633E,$6363,$3E00; $003E50
    dc.w    $3E63,$633F,$0363,$3E00,$0018,$1800,$0018,$1800; $003E60
    dc.w    $0018,$1800,$0018,$1820,$030C,$3040,$300C,$0300; $003E70
    dc.w    $0000,$7F00,$7F00,$0000,$6018,$0601,$0618,$6000; $003E80
    dc.w    $3E63,$031E,$1800,$1800,$3C42,$3949,$4949,$3600; $003E90
    dc.w    $1C1C,$3636,$7F63,$6300,$7E63,$637E,$6363,$7E00; $003EA0
    dc.w    $3E73,$6060,$6073,$3E00,$7E63,$6363,$6363,$7E00; $003EB0
    dc.w    $3F30,$303E,$3030,$3F00,$3F30,$303E,$3030,$3000; $003EC0
    dc.w    $3E73,$6067,$6373,$3E00,$6666,$667E,$6666,$6600; $003ED0
    dc.w    $1818,$1818,$1818,$1800,$0C0C,$0C0C,$CCCC,$7800; $003EE0
    dc.w    $6366,$6C78,$6C66,$6300,$6060,$6060,$6060,$7F00; $003EF0
    dc.w    $6377,$7F6B,$6B63,$6300,$6373,$7B7F,$6F67,$6300; $003F00
    dc.w    $3E63,$6363,$6363,$3E00,$7E63,$637E,$6060,$6000; $003F10
    dc.w    $3E63,$6363,$6F63,$3F00,$7E63,$637E,$6866,$6700; $003F20
    dc.w    $3E63,$703E,$0763,$3E00,$7E18,$1818,$1818,$1800; $003F30
    dc.w    $6666,$6666,$6666,$3C00,$6363,$6336,$361C,$1C00; $003F40
    dc.w    $6B6B,$6B6B,$6B7F,$3600,$6363,$361C,$3663,$6300; $003F50
    dc.w    $6666,$663C,$1818,$1800,$7F07,$0E1C,$3870,$7F00; $003F60
    dc.w    $4E75,$48E7,$303C,$242F,$001C,$267C,$00FF,$1802; $003F70
    dc.w    $287C,$00FF,$BD56,$2A7C,$00FF,$BD54,$3014,$E568; $003F80
    dc.w    $3880,$B453,$6332,$9453,$3013,$D040,$247C,$0004; $003F90
    dc.w    $684C,$3632,$0000,$C655,$0283,$0000,$FFFF,$3003; $003FA0
    dc.w    $E568,$8154,$1029,$0001,$E148,$1011,$3A80,$5489; $003FB0
    dc.w    $7010,$9042,$3680,$6002,$9553,$7000,$3013,$7200; $003FC0
    dc.w    $3215,$E0A1,$2001,$3202,$D241,$247C,$0004,$684C; $003FD0
    dc.w    $C072,$1000,$8154,$4CDF,$3C0C,$4E75             ; $003FE0 | prev fn tail
; ---------------------------------------------------------------------------
; LZ_Decompress - LZSS/LZ77 variant decompression
; Inputs: dest buffer ($1C,SP), compressed source ($20,SP)
; Output: D0.L = bytes written
; Uses A4 = helper at $003F72 for bitstream consumption (JSR (A4))
; RAM: $FFBD56 bitstream window (via A3), $FFA78C control byte, $FF1802 init
; 123 calls | 596 bytes | $003FEC-$00423F
; ---------------------------------------------------------------------------
LZ_Decompress:
    movem.l d2-d4/a2-a4,-(sp)                             ; $003FEC
    movea.l $1C(sp),a0                                     ; $003FF0 | dest buffer
    movea.l $20(sp),a1                                     ; $003FF4 | compressed source
    movea.l #$00FFBD56,a3                                  ; $003FF8 | -> bitstream window
    movea.l #$00003F72,a4                                  ; $003FFE | -> helper function
    clr.w   ($FF1802).l                                    ; $004004 | clear init flag
    pea     ($0010).w                                      ; $00400A | push 16 (read 16 bits)
    jsr     (a4)                                           ; $00400E | fill bitstream window
    addq.l  #4,sp                                          ; $004010
.fetch_control:
    move.b  (a1)+,($FFA78C).l                              ; $004012 | read control byte
    clr.w   d4                                             ; $004018 | bit counter = 0
.process_bit:
    move.b  ($FFA78C).l,d0                                 ; $00401A | load control byte
    btst    #7,d0                                          ; $004020 | test MSB
    beq.s   .bit_zero                                      ; $004024 | 0 = back-reference
    move.b  (a1)+,(a0)+                                    ; $004026 | 1 = literal copy
    bra.w   .advance_bit                                   ; $004028
; --- Decode match length from bitstream window ---
.bit_zero:
    move.w  (a3),d0                                        ; $00402C
    andi.w  #$8000,d0                                      ; $00402E | test bit 15
    beq.s   .len_not_b15                                   ; $004032
    moveq   #1,d3                                          ; $004034 | length = 1
    bra.w   .decode_dist                                   ; $004036
.len_not_b15:
    move.w  (a3),d0                                        ; $00403A
    andi.w  #$4000,d0                                      ; $00403C | test bit 14
    beq.s   .len_not_b14                                   ; $004040
    move.w  (a3),d3                                        ; $004042
    andi.l  #$00006000,d3                                  ; $004044 | bits 14-13
    moveq   #13,d0                                         ; $00404A
    asr.l   d0,d3                                          ; $00404C
    pea     ($0002).w                                      ; $00404E | consume 2 bits
    bra.w   .call_helper                                   ; $004052
.len_not_b14:
    move.w  (a3),d0                                        ; $004056
    andi.w  #$2000,d0                                      ; $004058 | test bit 13
    beq.s   .len_not_b13                                   ; $00405C
    move.w  (a3),d3                                        ; $00405E
    andi.l  #$00003800,d3                                  ; $004060 | bits 13-11
    moveq   #11,d0                                         ; $004066
    asr.l   d0,d3                                          ; $004068
    pea     ($0004).w                                      ; $00406A | consume 4 bits
    bra.s   .call_helper                                   ; $00406E
.len_not_b13:
    move.w  (a3),d0                                        ; $004070
    andi.w  #$1000,d0                                      ; $004072 | test bit 12
    beq.s   .len_not_b12                                   ; $004076
    move.w  (a3),d3                                        ; $004078
    andi.l  #$00001E00,d3                                  ; $00407A | bits 12-9
    moveq   #9,d0                                          ; $004080
    asr.l   d0,d3                                          ; $004082
    pea     ($0006).w                                      ; $004084 | consume 6 bits
    bra.s   .call_helper                                   ; $004088
.len_not_b12:
    move.w  (a3),d0                                        ; $00408A
    andi.w  #$0800,d0                                      ; $00408C | test bit 11
    beq.s   .len_not_b11                                   ; $004090
    move.w  (a3),d3                                        ; $004092
    andi.l  #$00000F80,d3                                  ; $004094 | bits 10-7
    asr.l   #7,d3                                          ; $00409A
    pea     ($0008).w                                      ; $00409C | consume 8 bits
    bra.s   .call_helper                                   ; $0040A0
.len_not_b11:
    move.w  (a3),d0                                        ; $0040A2
    andi.w  #$0400,d0                                      ; $0040A4 | test bit 10
    beq.s   .len_not_b10                                   ; $0040A8
    move.w  (a3),d3                                        ; $0040AA
    andi.l  #$000007E0,d3                                  ; $0040AC | bits 9-5
    asr.l   #5,d3                                          ; $0040B2
    pea     ($000A).w                                      ; $0040B4 | consume 10 bits
    bra.s   .call_helper                                   ; $0040B8
.len_not_b10:
    move.w  (a3),d0                                        ; $0040BA
    andi.w  #$0200,d0                                      ; $0040BC | test bit 9
    beq.s   .len_default                                   ; $0040C0
    move.w  (a3),d3                                        ; $0040C2
    andi.l  #$000003F8,d3                                  ; $0040C4 | bits 8-3
    asr.l   #3,d3                                          ; $0040CA
    pea     ($000C).w                                      ; $0040CC | consume 12 bits
    bra.s   .call_helper                                   ; $0040D0
.len_default:
    move.w  (a3),d3                                        ; $0040D2
    andi.l  #$000001FC,d3                                  ; $0040D4 | bits 8-2
    asr.l   #2,d3                                          ; $0040DA
    addi.w  #$0080,d3                                      ; $0040DC | +128 bias
    cmpi.w  #$00FF,d3                                      ; $0040E0 | 255 = end marker
    beq.w   .done                                          ; $0040E4
    pea     ($000D).w                                      ; $0040E8 | consume 13 bits
.call_helper:
    jsr     (a4)                                           ; $0040EC | call bitstream helper
    addq.l  #4,sp                                          ; $0040EE
; --- Decode match distance from bitstream window ---
.decode_dist:
    andi.w  #$7FFF,(a3)                                    ; $0040F0 | clear bit 15
    cmpi.w  #$0800,(a3)                                    ; $0040F4
    bcc.s   .dist_ge_0800                                  ; $0040F8
    move.w  (a3),d2                                        ; $0040FA
    andi.l  #$00000600,d2                                  ; $0040FC | bits 10-9
    moveq   #9,d0                                          ; $004102
    asr.l   d0,d2                                          ; $004104
    pea     ($0007).w                                      ; $004106 | consume 7 bits
    bra.w   .do_copy                                       ; $00410A
.dist_ge_0800:
    cmpi.w  #$0C00,(a3)                                    ; $00410E
    bcc.s   .dist_ge_0C00                                  ; $004112
    move.w  (a3),d2                                        ; $004114
    andi.l  #$00000300,d2                                  ; $004116 | bits 9-8
    asr.l   #8,d2                                          ; $00411C
    addq.w  #4,d2                                          ; $00411E | +4 bias
    pea     ($0008).w                                      ; $004120 | consume 8 bits
    bra.w   .do_copy                                       ; $004124
.dist_ge_0C00:
    cmpi.w  #$1800,(a3)                                    ; $004128
    bcc.s   .dist_ge_1800                                  ; $00412C
    moveq   #0,d2                                          ; $00412E
    move.w  (a3),d2                                        ; $004130
    subi.l  #$00000C00,d2                                  ; $004132
    andi.l  #$00000F80,d2                                  ; $004138 | bits 10-7
    asr.l   #7,d2                                          ; $00413E
    addq.w  #8,d2                                          ; $004140 | +8 bias
    pea     ($0009).w                                      ; $004142 | consume 9 bits
    bra.w   .do_copy                                       ; $004146
.dist_ge_1800:
    cmpi.w  #$3000,(a3)                                    ; $00414A
    bcc.s   .dist_ge_3000                                  ; $00414E
    moveq   #0,d2                                          ; $004150
    move.w  (a3),d2                                        ; $004152
    subi.l  #$00001800,d2                                  ; $004154
    andi.l  #$00001FC0,d2                                  ; $00415A | bits 12-6
    asr.l   #6,d2                                          ; $004160
    addi.w  #$0020,d2                                      ; $004162 | +$20 bias
    pea     ($000A).w                                      ; $004166 | consume 10 bits
    bra.w   .do_copy                                       ; $00416A
.dist_ge_3000:
    cmpi.w  #$4000,(a3)                                    ; $00416E
    bcc.s   .dist_ge_4000                                  ; $004172
    move.w  (a3),d2                                        ; $004174
    andi.l  #$00001FFF,d2                                  ; $004176 | bits 12-0
    ori.l   #$00001000,d2                                  ; $00417C | set bit 12
    asr.l   #5,d2                                          ; $004182
    pea     ($000B).w                                      ; $004184 | consume 11 bits
    bra.s   .do_copy                                       ; $004188
.dist_ge_4000:
    cmpi.w  #$5000,(a3)                                    ; $00418A
    bcc.s   .dist_ge_5000                                  ; $00418E
    move.w  (a3),d2                                        ; $004190
    andi.l  #$00001FFF,d2                                  ; $004192
    ori.l   #$00001000,d2                                  ; $004198
    asr.l   #4,d2                                          ; $00419E
    pea     ($000C).w                                      ; $0041A0 | consume 12 bits
    bra.s   .do_copy                                       ; $0041A4
.dist_ge_5000:
    cmpi.w  #$6000,(a3)                                    ; $0041A6
    bcc.s   .dist_ge_6000                                  ; $0041AA
    move.w  (a3),d2                                        ; $0041AC
    andi.l  #$00001FFF,d2                                  ; $0041AE
    ori.l   #$00001000,d2                                  ; $0041B4
    asr.l   #3,d2                                          ; $0041BA
    pea     ($000D).w                                      ; $0041BC | consume 13 bits
    bra.s   .do_copy                                       ; $0041C0
.dist_ge_6000:
    cmpi.w  #$7000,(a3)                                    ; $0041C2
    bcc.s   .dist_ge_7000                                  ; $0041C6
    move.w  (a3),d2                                        ; $0041C8
    andi.l  #$00001FFF,d2                                  ; $0041CA
    ori.l   #$00001000,d2                                  ; $0041D0
    asr.l   #2,d2                                          ; $0041D6
    pea     ($000E).w                                      ; $0041D8 | consume 14 bits
    bra.s   .do_copy                                       ; $0041DC
.dist_ge_7000:
    move.w  (a3),d2                                        ; $0041DE
    andi.l  #$00001FFF,d2                                  ; $0041E0
    ori.l   #$00001000,d2                                  ; $0041E6
    asr.l   #1,d2                                          ; $0041EC
    pea     ($000F).w                                      ; $0041EE | consume 15 bits
; --- Copy match: D3+1 bytes from (A0 - D2 - 1) ---
.do_copy:
    jsr     (a4)                                           ; $0041F2 | call helper
    addq.l  #4,sp                                          ; $0041F4
    moveq   #0,d0                                          ; $0041F6
    move.w  d2,d0                                          ; $0041F8 | D0 = distance
    move.l  a0,d1                                          ; $0041FA
    sub.l   d0,d1                                          ; $0041FC | dest - distance
    subq.l  #1,d1                                          ; $0041FE | - 1
    movea.l d1,a2                                          ; $004200 | A2 = copy source
    clr.w   d2                                             ; $004202 | counter = 0
    bra.s   .copy_test                                     ; $004204
.copy_loop:
    move.b  (a2)+,(a0)+                                    ; $004206 | copy byte
    addq.w  #1,d2                                          ; $004208
.copy_test:
    moveq   #0,d0                                          ; $00420A
    move.w  d2,d0                                          ; $00420C | D0 = counter
    moveq   #0,d1                                          ; $00420E
    move.w  d3,d1                                          ; $004210 | D1 = length
    addq.l  #1,d1                                          ; $004212 | +1 (copy length+1 bytes)
    cmp.l   d1,d0                                          ; $004214
    blt.s   .copy_loop                                     ; $004216
; --- Advance control bit ---
.advance_bit:
    move.b  ($FFA78C).l,d0                                 ; $004218 | load control byte
    add.b   d0,($FFA78C).l                                 ; $00421E | double it (shift left 1)
    addq.w  #1,d4                                          ; $004224 | bit counter++
    cmpi.w  #$0008,d4                                      ; $004226 | 8 bits done?
    bcs.w   .process_bit                                   ; $00422A | no: next bit
    bra.w   .fetch_control                                 ; $00422E | yes: next control byte
; --- Return bytes written ---
.done:
    move.l  $1C(sp),d1                                     ; $004232 | original dest ptr
    move.l  a0,d0                                          ; $004236 | final dest ptr
    sub.l   d1,d0                                          ; $004238 | D0 = bytes written
    movem.l (sp)+,d2-d4/a2-a4                              ; $00423A
    rts                                                    ; $00423E
; === Translated block $004240-$004342 ===
; 3 functions, 258 bytes

; ============================================================================
; func_004240 -- (TODO: name)
; 122 bytes | $004240-$0042B9
; ============================================================================
func_004240:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    movea.l  #$00FFBD50,a3
    movea.l  #$00FF88DA,a4
    movea.l  #$00FF88D8,a5
    move.w  (a4), d0
    lsl.w   d2, d0
    move.w  d0, (a4)
    cmp.w   (a3), d2
    bls.b   l_04296
    sub.w   (a3), d2
    move.w  (a3), d0
    add.w   d0, d0
    movea.l  #$0004686E,a2
    move.w  (a2,d0.w), d3
    and.w   (a5), d3
    andi.l  #$ffff, d3
    move.w  d3, d0
    lsl.w   d2, d0
    or.w    d0, (a4)
    move.b  $1(a1), d0
    lsl.w   #$8, d0
    move.b  (a1), d0
    move.w  d0, (a5)
    addq.l  #$2, a1
    moveq   #$10,d0
    sub.w   d2, d0
    move.w  d0, (a3)
    bra.b   l_04298
l_04296:
    sub.w   d2, (a3)
l_04298:
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  (a5), d1
    asr.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    add.w   d1, d1
    movea.l  #$0004686E,a2
    and.w   (a2,d1.w), d0
    or.w    d0, (a4)
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; func_0042BA -- (TODO: name)
; 54 bytes | $0042BA-$0042EF
; ============================================================================
func_0042BA:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  a2, d6
    move.l  d6, d7
    andi.l  #$fffe, d6
    move.l  d6, d5
    lsl.l   #$2, d5
    swap    d5
    andi.l  #$3, d5
    andi.l  #$3fff, d6
    swap    d6
    or.l    d5, d6
    move.l  d6, (a6)
    move.w  (a5), d0
    btst    #$0, d7
    bne.b   l_042ec
    lsr.w   #$8, d0
l_042ec:
    move.w  (a7)+, sr
    rts

; ============================================================================
; func_0042F0 -- (TODO: name)
; 82 bytes | $0042F0-$004341
; ============================================================================
func_0042F0:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  a0, d6
    move.l  d6, d7
    andi.l  #$fffe, d6
    move.l  d6, d5
    lsl.l   #$2, d5
    swap    d5
    andi.l  #$3, d5
    andi.l  #$3fff, d6
    swap    d6
    or.l    d5, d6
    move.l  d6, (a6)
    move.w  (a5), d5
    btst    #$0, d7
    bne.b   l_0432a
    lsl.w   #$8, d0
    andi.w  #$ff, d5
    bra.w   l_04332
l_0432a:
    andi.w  #$ff, d0
    andi.w  #$ff00, d5
l_04332:
    or.w    d0, d5
    ori.l   #$40000000, d6
    move.l  d6, (a6)
    move.w  d5, (a5)
    move.w  (a7)+, sr
    rts

; ============================================================================
; DecompressVDPTiles -- (TODO: describe)
; Called: ?? times.
; 624 bytes | $004342-$0045B1
; ============================================================================
DecompressVDPTiles:                                                  ; $004342
    movem.l d2-d7/a2-a6,-(sp)
    movea.l $0030(sp),a0
    movea.l $0034(sp),a1
    movea.l #$00ff88da,a3
    movea.l #$4240,a4
    movea.l #$00c00000,a5
    movea.l #$00c00004,a6
    clr.w   ($00FFBD50).l
    pea     ($0010).w
    jsr     (a4)
    addq.l  #$4,sp
.l4374:                                                 ; $004374
    move.b  (a1)+,($00FF128E).l
    clr.w   d4
.l437c:                                                 ; $00437C
    move.b  ($00FF128E).l,d0
    btst    #$07,d0
    beq.b   .l4394
    move.b  (a1)+,d0
    dc.w    $4eba,$ff64                                 ; jsr $0042F0
    addq.l  #$1,a0
    bra.w   .l458a
.l4394:                                                 ; $004394
    move.w  (a3),d0
    andi.w  #$8000,d0
    beq.b   .l43a2
    moveq   #$1,d3
    bra.w   .l4458
.l43a2:                                                 ; $0043A2
    move.w  (a3),d0
    andi.w  #$4000,d0
    beq.b   .l43be
    move.w  (a3),d3
    andi.l  #$6000,d3
    moveq   #$d,d0
    asr.l   d0,d3
    pea     ($0002).w
    bra.w   .l4454
.l43be:                                                 ; $0043BE
    move.w  (a3),d0
    andi.w  #$2000,d0
    beq.b   .l43d8
    move.w  (a3),d3
    andi.l  #$3800,d3
    moveq   #$b,d0
    asr.l   d0,d3
    pea     ($0004).w
    bra.b   .l4454
.l43d8:                                                 ; $0043D8
    move.w  (a3),d0
    andi.w  #$1000,d0
    beq.b   .l43f2
    move.w  (a3),d3
    andi.l  #$1e00,d3
    moveq   #$9,d0
    asr.l   d0,d3
    pea     ($0006).w
    bra.b   .l4454
.l43f2:                                                 ; $0043F2
    move.w  (a3),d0
    andi.w  #$0800,d0
    beq.b   .l440a
    move.w  (a3),d3
    andi.l  #$0f80,d3
    asr.l   #$7,d3
    pea     ($0008).w
    bra.b   .l4454
.l440a:                                                 ; $00440A
    move.w  (a3),d0
    andi.w  #$0400,d0
    beq.b   .l4422
    move.w  (a3),d3
    andi.l  #$07e0,d3
    asr.l   #$5,d3
    pea     ($000A).w
    bra.b   .l4454
.l4422:                                                 ; $004422
    move.w  (a3),d0
    andi.w  #$0200,d0
    beq.b   .l443a
    move.w  (a3),d3
    andi.l  #$03f8,d3
    asr.l   #$3,d3
    pea     ($000C).w
    bra.b   .l4454
.l443a:                                                 ; $00443A
    move.w  (a3),d3
    andi.l  #$01fc,d3
    asr.l   #$2,d3
    addi.w  #$80,d3
    cmpi.w  #$ff,d3
    beq.w   .l45a4
    pea     ($000D).w
.l4454:                                                 ; $004454
    jsr     (a4)
    addq.l  #$4,sp
.l4458:                                                 ; $004458
    andi.w  #$7fff,(a3)
    cmpi.w  #$0800,(a3)
    bcc.b   .l4476
    move.w  (a3),d2
    andi.l  #$0600,d2
    moveq   #$9,d0
    asr.l   d0,d2
    pea     ($0007).w
    bra.w   .l455a
.l4476:                                                 ; $004476
    cmpi.w  #$0c00,(a3)
    bcc.b   .l4490
    move.w  (a3),d2
    andi.l  #$0300,d2
    asr.l   #$8,d2
    addq.w  #$4,d2
    pea     ($0008).w
    bra.w   .l455a
.l4490:                                                 ; $004490
    cmpi.w  #$1800,(a3)
    bcc.b   .l44b2
    moveq   #$0,d2
    move.w  (a3),d2
    subi.l  #$0c00,d2
    andi.l  #$0f80,d2
    asr.l   #$7,d2
    addq.w  #$8,d2
    pea     ($0009).w
    bra.w   .l455a
.l44b2:                                                 ; $0044B2
    cmpi.w  #$3000,(a3)
    bcc.b   .l44d6
    moveq   #$0,d2
    move.w  (a3),d2
    subi.l  #$1800,d2
    andi.l  #$1fc0,d2
    asr.l   #$6,d2
    addi.w  #$20,d2
    pea     ($000A).w
    bra.w   .l455a
.l44d6:                                                 ; $0044D6
    cmpi.w  #$4000,(a3)
    bcc.b   .l44f2
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$5,d2
    pea     ($000B).w
    bra.b   .l455a
.l44f2:                                                 ; $0044F2
    cmpi.w  #$5000,(a3)
    bcc.b   .l450e
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$4,d2
    pea     ($000C).w
    bra.b   .l455a
.l450e:                                                 ; $00450E
    cmpi.w  #$6000,(a3)
    bcc.b   .l452a
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$3,d2
    pea     ($000D).w
    bra.b   .l455a
.l452a:                                                 ; $00452A
    cmpi.w  #$7000,(a3)
    bcc.b   .l4546
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$2,d2
    pea     ($000E).w
    bra.b   .l455a
.l4546:                                                 ; $004546
    move.w  (a3),d2
    andi.l  #$1fff,d2
    ori.l   #$1000,d2
    asr.l   #$1,d2
    pea     ($000F).w
.l455a:                                                 ; $00455A
    jsr     (a4)
    addq.l  #$4,sp
    moveq   #$0,d0
    move.w  d2,d0
    move.l  a0,d1
    sub.l   d0,d1
    subq.l  #$1,d1
    movea.l d1,a2
    clr.w   d2
    bra.b   .l457c
.l456e:                                                 ; $00456E
    dc.w    $4eba,$fd4a                                 ; jsr $0042BA
    dc.w    $4eba,$fd7c                                 ; jsr $0042F0
    addq.l  #$1,a0
    addq.l  #$1,a2
    addq.w  #$1,d2
.l457c:                                                 ; $00457C
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$0,d1
    move.w  d3,d1
    addq.l  #$1,d1
    cmp.l   d1,d0
    blt.b   .l456e
.l458a:                                                 ; $00458A
    move.b  ($00FF128E).l,d0
    add.b   d0,($00FF128E).l
    addq.w  #$1,d4
    cmpi.w  #$8,d4
    bcs.w   .l437c
    bra.w   .l4374
.l45a4:                                                 ; $0045A4
    move.l  $0030(sp),d1
    move.l  a0,d0
    sub.l   d1,d0
    movem.l (sp)+,d2-d7/a2-a6
    rts
; === MemMove ($0045B2, 52B) ===
MemMove:                                                              ; $0045B2
    MOVE.L  $C(SP),D1                                                 ; count
    MOVEA.L $8(SP),A1                                                 ; dest
    MOVEA.L $4(SP),A0                                                 ; src
    CMPA.W  A1,A0                                                     ; compare src vs dest
    BLS.S   .mm_backward                                              ; if src <= dest, copy backward
    BRA.S   .mm_fwd_check
.mm_fwd_loop:                                                         ; $0045C4
    MOVE.B  (A0)+,(A1)+                                               ; copy forward
    SUBQ.W  #1,D1
.mm_fwd_check:                                                        ; $0045C8
    TST.W   D1
    BNE.S   .mm_fwd_loop
    BRA.S   .mm_done
.mm_backward:                                                         ; $0045CE
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    ADDA.L  D0,A1                                                     ; dest += count
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    ADDA.L  D0,A0                                                     ; src += count
    BRA.S   .mm_bwd_check
.mm_bwd_loop:                                                         ; $0045DC
    MOVE.B  -(A0),-(A1)                                               ; copy backward
    SUBQ.W  #1,D1
.mm_bwd_check:                                                        ; $0045E0
    TST.W   D1
    BNE.S   .mm_bwd_loop
.mm_done:                                                             ; $0045E4
    RTS
; === CmdPlaceTile2 ($0045E6, 64B) ===
CmdPlaceTile2:                                                        ; $0045E6
    MOVE.L  D2,-(SP)
    MOVE.L  $10(SP),D2                                                ; arg3 (count)
    MOVE.L  $C(SP),D1                                                 ; arg2 (tile address)
    MOVEA.L $8(SP),A0                                                 ; arg1 (src)
    MOVE.W  D1,D0
    ANDI.L  #$000007FF,D0
    LSL.L   #5,D0                                                     ; * 32
    MOVEA.L D0,A1
    CLR.L   -(SP)                                                     ; push 0
    CLR.L   -(SP)                                                     ; push 0
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    LSL.L   #4,D0                                                     ; count * 16
    MOVE.L  D0,-(SP)
    MOVE.L  A1,-(SP)
    MOVE.L  A0,-(SP)
    PEA     ($0002).W                                                 ; sub-command 2
    PEA     ($0008).W                                                 ; command 8
    dc.w    $4EB9,$0000,$0D64                                         ; jsr GameCommand
    LEA     $1C(SP),SP                                                ; pop 7 args
    MOVE.L  (SP)+,D2
    RTS
; === Translated block $004626-$004668 ===
; 1 functions, 66 bytes

; ============================================================================
; func_004626 -- (TODO: name)
; 66 bytes | $004626-$004667
; ============================================================================
func_004626:
    move.l  d2, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d1
    movea.l $8(a7), a0
    move.w  d1, d0
    andi.l  #$7ff, d0
    lsl.l   #$5, d0
    movea.l d0, a1
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    move.l  d0, -(a7)
    move.l  a1, -(a7)
    move.l  a0, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    move.l  (a7)+, d2
    rts

; ---------------------------------------------------------------------------
; CmdPlaceTile -- Place tile block via GameCommand(5, 2, ...)
; Args: $8(SP) = src pointer, $C(SP) = tile address, $10(SP) = count
; Called 46 times
; ---------------------------------------------------------------------------
CmdPlaceTile:                                                  ; $004668
    MOVE.L  D2,-(SP)                                           ; save D2
    MOVE.L  $10(SP),D2                                         ; arg3 (count)
    MOVE.L  $C(SP),D1                                          ; arg2 (tile address)
    MOVEA.L $8(SP),A0                                          ; arg1 (src pointer)
    MOVE.W  D1,D0
    ANDI.L  #$000007FF,D0                                      ; lower 11 bits
    LSL.L   #5,D0                                              ; * 32
    MOVEA.L D0,A1                                              ; A1 = tile offset
    CLR.L   -(SP)                                              ; push 0
    MOVE.L  A1,-(SP)                                           ; push tile*32
    MOVE.L  A0,-(SP)                                           ; push src
    MOVEQ   #0,D0
    MOVE.W  D2,D0                                              ; zero-extend count
    LSL.L   #4,D0                                              ; count * 16
    MOVE.L  D0,-(SP)                                           ; push count*16
    PEA     ($0002).W                                          ; sub-command 2
    PEA     ($0005).W                                          ; command 5
    dc.w    $4EB9,$0000,$0D64                                  ; jsr GameCommand [$D64]
    LEA     $18(SP),SP                                         ; pop 6 args
    MOVE.L  (SP)+,D2                                           ; restore D2
    RTS
; === Translated block $0046A6-$004BC6 ===
; 13 functions, 1312 bytes

; ============================================================================
; func_0046A6 -- (TODO: name)
; 76 bytes | $0046A6-$0046F1
; ============================================================================
func_0046A6:
    movem.l d2-d6, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.l  $24(a7), d4
    move.l  $20(a7), d5
    movea.l $28(a7), a0
    andi.w  #$3, d5
    andi.w  #$1, d4
    andi.w  #$7ff, d2
    move.w  d5, d0
    moveq   #$D,d1
    lsl.w   d1, d0
    add.w   d2, d0
    move.w  d4, d1
    moveq   #$F,d6
    lsl.w   d6, d1
    add.w   d1, d0
    move.w  d0, d2
    bra.b   l_046e4
l_046de:
    move.l  d2, d0
    addq.w  #$1, d2
    move.w  d0, (a0)+
l_046e4:
    move.l  d3, d0
    subq.w  #$1, d3
    tst.w   d0
    bne.b   l_046de
    movem.l (a7)+, d2-d6
    rts

; ============================================================================
; func_0046F2 -- (TODO: name)
; 30 bytes | $0046F2-$00470F
; ============================================================================
func_0046F2:
    move.l  d2, -(a7)
    move.l  $c(a7), d2
    move.l  $8(a7), d1
    movea.l $10(a7), a0
    bra.b   l_04704
l_04702:
    add.w   d1, (a0)+
l_04704:
    move.l  d2, d0
    subq.w  #$1, d2
    tst.w   d0
    bne.b   l_04702
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_004710 -- (TODO: name)
; 74 bytes | $004710-$004759
; ============================================================================
func_004710:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $24(a7), d2
    move.l  $20(a7), d3
    move.l  $2c(a7), d4
    move.l  $28(a7), d5
    movea.l $30(a7), a2
    movea.l $1c(a7), a3
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    dc.w    $6100,$FEAE                                 ; bsr.w $0045E6
    move.l  a2, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FF58                                 ; bsr.w $0046A6
    lea     $20(a7), a7
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; func_00475A -- (TODO: name)
; 74 bytes | $00475A-$0047A3
; ============================================================================
func_00475A:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $24(a7), d2
    move.l  $20(a7), d3
    move.l  $2c(a7), d4
    move.l  $28(a7), d5
    movea.l $30(a7), a2
    movea.l $1c(a7), a3
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    dc.w    $6100,$FEE6                                 ; bsr.w $004668
    move.l  a2, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FF0E                                 ; bsr.w $0046A6
    lea     $20(a7), a7
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; func_0047A4 -- (TODO: name)
; 132 bytes | $0047A4-$004827
; ============================================================================
func_0047A4:
    link    a6,#-$200
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $10(a6), d5
    move.l  $14(a6), d6
    movea.l $8(a6), a3
    clr.w   d4
    clr.w   d3
    bra.b   l_04802
l_047be:
    clr.w   d2
    bra.b   l_047fc
l_047c2:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d5, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d0
    lsl.l   #$5, d0
    lea     (a3,d0.l), a0
    movea.l a0, a2
    pea     ($0020).w
    move.l  d4, d0
    addq.w  #$1, d4
    lsl.w   #$5, d0
    lea     -$200(a6), a0
    pea     (a0, d0.w)
    move.l  a2, -(a7)
    dc.w    $6100,$FDBE                                 ; bsr.w $0045B2
    lea     $c(a7), a7
    addq.w  #$1, d2
l_047fc:
    cmp.w   d6, d2
    bcs.b   l_047c2
    addq.w  #$1, d3
l_04802:
    cmp.w   d5, d3
    bcs.b   l_047be
    move.w  d5, d0
    mulu.w  d6, d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    andi.w  #$7ff, d0
    move.l  d0, -(a7)
    pea     -$200(a6)
    dc.w    $6100,$FE4C                                 ; bsr.w $004668
    movem.l -$21c(a6), d2-d6/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_004828 -- (TODO: name)
; 96 bytes | $004828-$004887
; ============================================================================
func_004828:
    link    a6,#$0
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a6), d2
    move.l  $10(a6), d3
    move.l  $c(a6), d4
    movea.l $1c(a6), a2
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.l  $8(a6), -(a7)
    dc.w    $6100,$FF52                                 ; bsr.w $0047A4
    clr.w   (a2)+
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0004734C,a0
    move.w  (a0,d0.w), d0
    move.w  d2, d1
    add.w   d1, d1
    movea.l  #$00047354,a0
    or.w    (a0,d1.w), d0
    andi.l  #$ffff, d0
    move.w  d0, (a2)+
    move.w  d4, (a2)+
    clr.w   (a2)
    movem.l -$10(a6), d2-d4/a2
    unlk    a6
    rts

; ============================================================================
; func_004888 -- (TODO: name)
; 74 bytes | $004888-$0048D1
; ============================================================================
func_004888:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    movea.l $14(a7), a0
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    moveq   #$0,d1
    move.w  ($00FFA778).l, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.l  a0, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_0048D2 -- (TODO: name)
; 118 bytes | $0048D2-$004947
; ============================================================================
func_0048D2:
    movem.l d2-d7/a2, -(a7)
    move.l  $2c(a7), d7
    clr.w   d6
    movea.l $20(a7), a1
    bra.b   l_04932
l_048e2:
    move.w  (a1), d2
    move.w  $2a(a7), d5
    moveq   #$C,d0
    lsl.w   d0, d5
    move.w  d7, d4
    moveq   #$C,d0
    lsl.w   d0, d4
    clr.w   d3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0004735E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_04904:
    move.w  d2, d0
    and.w   (a2), d0
    cmp.w   d5, d0
    bne.b   l_04916
    move.w  (a2), d0
    not.w   d0
    and.w   d0, d2
    move.w  d4, d0
    or.w    d0, d2
l_04916:
    addq.l  #$2, a2
    addq.w  #$1, d3
    move.w  d5, d0
    lsr.w   #$4, d0
    move.w  d0, d5
    move.w  d4, d0
    lsr.w   #$4, d0
    move.w  d0, d4
    cmpi.w  #$4, d3
    bcs.b   l_04904
    move.w  d2, (a1)
    addq.w  #$1, d6
    addq.l  #$2, a1
l_04932:
    moveq   #$0,d0
    move.w  $26(a7), d0
    lsl.l   #$4, d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bgt.b   l_048e2
    movem.l (a7)+, d2-d7/a2
    rts

; ============================================================================
; func_004948 -- (TODO: name)
; 150 bytes | $004948-$0049DD
; ============================================================================
func_004948:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $28(a7), d6
    movea.l $2c(a7), a1
    clr.w   d5
    movea.l $24(a7), a4
    bra.b   l_049ca
l_0495c:
    move.w  (a4), d4
    clr.w   d3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0004736E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00047366,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_04980:
    move.w  d4, d2
    and.w   (a2), d2
    andi.l  #$ffff, d2
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  d2, d1
    asr.l   d0, d1
    move.w  d1, d2
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a1,a0.l), d2
    move.w  (a3), d0
    move.w  d2, d1
    lsl.w   d0, d1
    move.w  d1, d2
    move.w  (a2), d0
    move.w  #$ffff, d1
    eor.w   d1, d0
    and.w   d4, d0
    or.w    d2, d0
    move.w  d0, d4
    addq.l  #$2, a2
    addq.l  #$2, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_04980
    move.w  d4, (a4)
    addq.w  #$1, d5
    addq.l  #$2, a4
l_049ca:
    moveq   #$0,d0
    move.w  d6, d0
    lsl.l   #$4, d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bgt.b   l_0495c
    movem.l (a7)+, d2-d6/a2-a4
    rts

; ============================================================================
; func_0049DE -- (TODO: name)
; 136 bytes | $0049DE-$004A65
; ============================================================================
func_0049DE:
    movem.l d2-d7/a2, -(a7)
    move.l  $2c(a7), d7
    clr.w   d6
    movea.l $20(a7), a1
    bra.b   l_04a50
l_049ee:
    move.w  (a1), d2
    move.w  $2a(a7), d4
    moveq   #$C,d0
    lsl.w   d0, d4
    move.w  d7, d3
    moveq   #$C,d0
    lsl.w   d0, d3
    clr.w   d5
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00047376,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_04a10:
    move.w  d2, d0
    and.w   (a2), d0
    cmp.w   d4, d0
    bne.b   l_04a22
    move.w  (a2), d0
    not.w   d0
    and.w   d0, d2
    move.w  d3, d0
    bra.b   l_04a32
l_04a22:
    move.w  d2, d0
    and.w   (a2), d0
    cmp.w   d3, d0
    bne.b   l_04a34
    move.w  (a2), d0
    not.w   d0
    and.w   d0, d2
    move.w  d4, d0
l_04a32:
    or.w    d0, d2
l_04a34:
    move.w  d4, d0
    lsr.w   #$4, d0
    move.w  d0, d4
    move.w  d3, d0
    lsr.w   #$4, d0
    move.w  d0, d3
    addq.l  #$2, a2
    addq.w  #$1, d5
    cmpi.w  #$4, d5
    bcs.b   l_04a10
    move.w  d2, (a1)
    addq.w  #$1, d6
    addq.l  #$2, a1
l_04a50:
    moveq   #$0,d0
    move.w  $26(a7), d0
    lsl.l   #$4, d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bgt.b   l_049ee
    movem.l (a7)+, d2-d7/a2
    rts

; ============================================================================
; func_004A66 -- (TODO: name)
; 182 bytes | $004A66-$004B1B
; ============================================================================
func_004A66:
    link    a6,#-$800
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $1c(a6), d3
    move.l  $18(a6), d4
    move.l  $14(a6), d5
    move.l  $10(a6), d6
    move.l  $c(a6), d7
    lea     -$800(a6), a3
    andi.w  #$3, d3
    moveq   #$D,d0
    lsl.w   d0, d3
    movea.l a3, a2
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    pea     ($001C).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    clr.w   d2
    bra.b   l_04ad0
l_04ac4:
    move.w  (a2), d0
    andi.w  #$9fff, d0
    add.w   d3, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
l_04ad0:
    moveq   #$0,d0
    move.w  d5, d0
    moveq   #$0,d1
    move.w  d4, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_04ac4
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    pea     ($001B).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$820(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_004B1C -- (TODO: name)
; 80 bytes | $004B1C-$004B6B
; ============================================================================
func_004B1C:
    movem.l d2-d5, -(a7)
    move.l  $18(a7), d1
    move.l  $1c(a7), d0
    movea.l $20(a7), a1
    movea.l $14(a7), a0
    clr.w   d4
    bra.b   l_04b62
l_04b34:
    clr.w   d2
    moveq   #$0,d5
    move.w  d4, d5
    lsl.l   #$3, d5
    addi.l  #$80, d5
    moveq   #$0,d3
    move.w  d2, d3
    lsl.l   #$3, d3
    addi.l  #$80, d3
    bra.b   l_04b5c
l_04b50:
    move.w  d5, (a1)+
    clr.w   (a1)+
    move.w  (a0)+, (a1)+
    move.w  d3, (a1)+
    addq.l  #$8, d3
    addq.w  #$1, d2
l_04b5c:
    cmp.w   d1, d2
    bcs.b   l_04b50
    addq.w  #$1, d4
l_04b62:
    cmp.w   d0, d4
    bcs.b   l_04b34
    movem.l (a7)+, d2-d5
    rts

; ============================================================================
; func_004B6C -- (TODO: name)
; 90 bytes | $004B6C-$004BC5
; ============================================================================
func_004B6C:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $1c(a7), d2
    move.l  $18(a7), d3
    movea.l $14(a7), a2
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    movea.l d0, a3
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    move.w  d2, d0
    add.w   d0, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00FF1400,a0
    pea     (a0, d0.w)
    move.l  a2, -(a7)
    dc.w    $6100,$F9F8                                 ; bsr.w $0045B2
    lea     $28(a7), a7
    movem.l (a7)+, d2-d3/a2-a3
    rts

; ============================================================================
; FadePalette -- (TODO: describe)
; Called: ?? times.
; 240 bytes | $004BC6-$004CB5
; ============================================================================
FadePalette:                                                  ; $004BC6
    link    a6,#-$80
    movem.l d2-d7,-(sp)
    move.l  $0014(a6),d2
    move.l  $000c(a6),d7
    cmpi.w  #$7,d2
    bhi.w   .l4cac
    moveq   #$7,d0
    sub.w   d2,d0
    move.w  d0,d2
    move.w  d7,d6
    movea.l $0008(a6),a1
    bra.w   .l4c80
.l4bee:                                                 ; $004BEE
    move.w  (a1),d5
    andi.l  #$0e00,d5
    moveq   #$9,d0
    asr.l   d0,d5
    move.w  (a1),d4
    andi.l  #$e0,d4
    asr.l   #$5,d4
    move.w  (a1),d3
    andi.l  #$e,d3
    asr.l   #$1,d3
    moveq   #$0,d0
    move.w  d5,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    ble.b   .l4c26
    moveq   #$0,d0
    move.w  d5,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    bra.b   .l4c28
.l4c26:                                                 ; $004C26
    moveq   #$0,d0
.l4c28:                                                 ; $004C28
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    ble.b   .l4c42
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    bra.b   .l4c44
.l4c42:                                                 ; $004C42
    moveq   #$0,d0
.l4c44:                                                 ; $004C44
    move.w  d0,d4
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    ble.b   .l4c5e
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    bra.b   .l4c60
.l4c5e:                                                 ; $004C5E
    moveq   #$0,d0
.l4c60:                                                 ; $004C60
    move.w  d0,d3
    move.w  d5,d0
    moveq   #$9,d1
    lsl.w   d1,d0
    move.w  d4,d1
    lsl.w   #$5,d1
    add.w   d1,d0
    move.w  d3,d1
    add.w   d1,d1
    add.w   d1,d0
    move.w  d6,d1
    add.w   d1,d1
    move.w  d0,-$80(a6,d1.w)
    addq.w  #$1,d6
    addq.l  #$2,a1
.l4c80:                                                 ; $004C80
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  $0012(a6),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d6,d1
    cmp.l   d1,d0
    bgt.w   .l4bee
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    add.w   d0,d0
    pea     -$80(a6,d0.w)
    dc.w    $6100,$fec2                                 ; bsr.w $004B6C
.l4cac:                                                 ; $004CAC
    movem.l -$0098(a6),d2-d7
    unlk    a6
    rts
; ============================================================================
; DrawLayersReverse -- (TODO: describe)
; Called: ?? times.
; 78 bytes | $004CB6-$004D03
; ============================================================================
DrawLayersReverse:                                                  ; $004CB6
    movem.l d2-d5/a2,-(sp)
    move.l  $0024(sp),d3
    move.l  $0020(sp),d4
    move.l  $001c(sp),d5
    movea.l $0018(sp),a2
    moveq   #$7,d2
.l4ccc:                                                 ; $004CCC
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $6100,$feea                                 ; bsr.w $004BC6
    lea     $0010(sp),sp
    tst.w   d3
    beq.b   .l4cf8
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
.l4cf8:                                                 ; $004CF8
    subq.w  #$1,d2
    tst.w   d2
    bge.b   .l4ccc
    movem.l (sp)+,d2-d5/a2
    rts
; ============================================================================
; DrawLayersForward -- (TODO: describe)
; Called: ?? times.
; 80 bytes | $004D04-$004D53
; ============================================================================
DrawLayersForward:                                                  ; $004D04
    movem.l d2-d5/a2,-(sp)
    move.l  $0024(sp),d3
    move.l  $0020(sp),d4
    move.l  $001c(sp),d5
    movea.l $0018(sp),a2
    clr.w   d2
.l4d1a:                                                 ; $004D1A
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $6100,$fe9c                                 ; bsr.w $004BC6
    lea     $0010(sp),sp
    tst.w   d3
    beq.b   .l4d46
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
.l4d46:                                                 ; $004D46
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    blt.b   .l4d1a
    movem.l (sp)+,d2-d5/a2
    rts
; === Translated block $004D54-$005060 ===
; 3 functions, 780 bytes

; ============================================================================
; func_004D54 -- (TODO: name)
; 212 bytes | $004D54-$004E27
; ============================================================================
func_004D54:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d7
    movea.l $8(a6), a3
    lea     -$6(a6), a4
    lea     -$4(a6), a5
    clr.w   d6
l_04d6e:
    move.w  d6, d0
    moveq   #$9,d1
    lsl.w   d1, d0
    move.w  d0, -$2(a6)
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d0, (a5)
    move.w  d6, d0
    add.w   d0, d0
    move.w  d0, (a4)
    move.w  d7, d2
    movea.l a3, a2
    bra.b   l_04dc8
l_04d8a:
    move.w  (a2), d5
    andi.w  #$e00, d5
    move.w  (a2), d4
    andi.w  #$e0, d4
    move.w  (a2), d3
    andi.w  #$e, d3
    cmp.w   -$2(a6), d5
    bcc.b   l_04da6
    move.w  -$2(a6), d5
l_04da6:
    cmp.w   (a5), d4
    bcc.b   l_04dac
    move.w  (a5), d4
l_04dac:
    cmp.w   (a4), d3
    bcc.b   l_04db2
    move.w  (a4), d3
l_04db2:
    move.w  d5, d0
    add.w   d4, d0
    add.w   d3, d0
    move.w  d2, d1
    add.w   d1, d1
    lea     -$86(a6), a0
    move.w  d0, (a0,d1.w)
    addq.w  #$1, d2
    addq.l  #$2, a2
l_04dc8:
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$0,d1
    move.w  $12(a6), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_04d8a
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    pea     (a0, d0.w)
    dc.w    $6100,$FD78                                 ; bsr.w $004B6C
    lea     $c(a7), a7
    tst.w   $16(a6)
    beq.b   l_04e14
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
l_04e14:
    addq.w  #$1, d6
    cmpi.w  #$8, d6
    blt.w   l_04d6e
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_004E28 -- (TODO: name)
; 210 bytes | $004E28-$004EF9
; ============================================================================
func_004E28:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d7
    movea.l $8(a6), a3
    lea     -$6(a6), a4
    lea     -$4(a6), a5
    moveq   #$7,d6
l_04e42:
    move.w  d6, d0
    moveq   #$9,d1
    lsl.w   d1, d0
    move.w  d0, -$2(a6)
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d0, (a5)
    move.w  d6, d0
    add.w   d0, d0
    move.w  d0, (a4)
    move.w  d7, d2
    movea.l a3, a2
    bra.b   l_04e9c
l_04e5e:
    move.w  (a2), d5
    andi.w  #$e00, d5
    move.w  (a2), d4
    andi.w  #$e0, d4
    move.w  (a2), d3
    andi.w  #$e, d3
    cmp.w   -$2(a6), d5
    bcc.b   l_04e7a
    move.w  -$2(a6), d5
l_04e7a:
    cmp.w   (a5), d4
    bcc.b   l_04e80
    move.w  (a5), d4
l_04e80:
    cmp.w   (a4), d3
    bcc.b   l_04e86
    move.w  (a4), d3
l_04e86:
    move.w  d5, d0
    add.w   d4, d0
    add.w   d3, d0
    move.w  d2, d1
    add.w   d1, d1
    lea     -$86(a6), a0
    move.w  d0, (a0,d1.w)
    addq.w  #$1, d2
    addq.l  #$2, a2
l_04e9c:
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$0,d1
    move.w  $12(a6), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_04e5e
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    pea     (a0, d0.w)
    dc.w    $6100,$FCA4                                 ; bsr.w $004B6C
    lea     $c(a7), a7
    tst.w   $16(a6)
    beq.b   l_04ee8
    moveq   #$0,d0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
l_04ee8:
    subq.w  #$1, d6
    tst.w   d6
    bge.w   l_04e42
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_004EFA -- (TODO: name)
; 358 bytes | $004EFA-$00505F
; ============================================================================
func_004EFA:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    lea     -$6(a6), a5
    move.w  $16(a6), d0
    add.w   d0, d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    move.l  $8(a6), -(a7)
    dc.w    $6100,$F696                                 ; bsr.w $0045B2
    lea     $c(a7), a7
    clr.w   -$4(a6)
l_04f26:
    moveq   #$7,d0
    sub.w   -$4(a6), d0
    move.w  d0, -$2(a6)
    clr.w   d5
    move.w  d5, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    lea     (a0,d0.w), a1
    movea.l a1, a2
    moveq   #$0,d0
    move.w  d5, d0
    add.l   d0, d0
    lea     (a4,d0.l), a0
    movea.l a0, a3
    bra.w   l_0500e
l_04f50:
    move.w  (a3), d0
    andi.l  #$e00, d0
    moveq   #$9,d1
    asr.l   d1, d0
    move.w  d0, (a5)
    move.w  (a3), d7
    andi.l  #$e0, d7
    asr.l   #$5, d7
    move.w  (a3), d6
    andi.l  #$e, d6
    asr.l   #$1, d6
    move.w  (a2), d4
    andi.l  #$e00, d4
    moveq   #$9,d0
    asr.l   d0, d4
    move.w  (a2), d3
    andi.l  #$e0, d3
    asr.l   #$5, d3
    move.w  (a2), d2
    andi.l  #$e, d2
    asr.l   #$1, d2
    cmp.w   (a5), d4
    bls.b   l_04f9a
    subq.w  #$1, d4
    bra.b   l_04fb4
l_04f9a:
    cmp.w   (a5), d4
    bcc.b   l_04fb4
    move.w  -$2(a6), d0
    cmp.w   (a5), d0
    bcc.b   l_04fae
    moveq   #$0,d0
    move.w  d4, d0
    addq.l  #$1, d0
    bra.b   l_04fb2
l_04fae:
    moveq   #$0,d0
    move.w  d4, d0
l_04fb2:
    move.w  d0, d4
l_04fb4:
    cmp.w   d7, d3
    bls.b   l_04fbc
    subq.w  #$1, d3
    bra.b   l_04fd4
l_04fbc:
    cmp.w   d7, d3
    bcc.b   l_04fd4
    cmp.w   -$2(a6), d7
    bls.b   l_04fce
    moveq   #$0,d0
    move.w  d3, d0
    addq.l  #$1, d0
    bra.b   l_04fd2
l_04fce:
    moveq   #$0,d0
    move.w  d3, d0
l_04fd2:
    move.w  d0, d3
l_04fd4:
    cmp.w   d6, d2
    bls.b   l_04fdc
    subq.w  #$1, d2
    bra.b   l_04ff4
l_04fdc:
    cmp.w   d6, d2
    bcc.b   l_04ff4
    cmp.w   -$2(a6), d6
    bls.b   l_04fee
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    bra.b   l_04ff2
l_04fee:
    moveq   #$0,d0
    move.w  d2, d0
l_04ff2:
    move.w  d0, d2
l_04ff4:
    move.w  d4, d0
    moveq   #$9,d1
    lsl.w   d1, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.w   d1, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    move.w  d0, (a2)
    addq.l  #$2, a3
    addq.l  #$2, a2
    addq.w  #$1, d5
l_0500e:
    cmp.w   $16(a6), d5
    bcs.w   l_04f50
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    dc.w    $6100,$FB44                                 ; bsr.w $004B6C
    lea     $c(a7), a7
    tst.w   $1a(a6)
    beq.b   l_05048
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.l  d0, -(a7)
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
l_05048:
    addq.w  #$1, -$4(a6)
    cmpi.w  #$8, -$4(a6)
    bcs.w   l_04f26
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ---------------------------------------------------------------------------
; InitTileBuffer -- (TODO: describe)
; 50 bytes | $005060-$005091
; ---------------------------------------------------------------------------
InitTileBuffer:                                                  ; $005060
    pea     ($0040).w
    pea     ($00FF14BC).l
    pea     ($000472CE).l
    dc.w    $4eb9,$0001,$e16c                           ; jsr $01E16C
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($00FF14BC).l
    dc.w    $6100,$fae8                                 ; bsr.w $004B6C
    lea     $0018(sp),sp
    clr.w   ($00FFA7DC).l
    rts
; ---------------------------------------------------------------------------
; DisplaySetup -- Load resource into dest buffer, optionally call init
; Args: $10(SP)=dest ptr, $14(SP)=resource index, $18(SP)=size
; Called 101 times
; ---------------------------------------------------------------------------
DisplaySetup:                                                  ; $005092
    MOVEM.L D2-D3/A2,-(SP)
    MOVE.L  $18(SP),D2                                         ; arg3 (size)
    MOVE.L  $14(SP),D3                                         ; arg2 (resource index)
    MOVEA.L $10(SP),A2                                         ; arg1 (dest pointer)
    MOVEQ   #0,D0
    MOVE.W  D2,D0                                              ; zero-extend size
    MOVE.L  D0,-(SP)
    MOVE.W  D3,D0
    ADD.W   D0,D0                                              ; index * 2
    MOVEA.L #$00FF14BC,A0                                      ; resource table base
    PEA     0(A0,D0.W)                                         ; push table[index]
    MOVE.L  A2,-(SP)                                           ; push dest
    dc.w    $4EB9,$0001,$E16C                                  ; jsr ResourceLoad [$1E16C]
    LEA     $C(SP),SP                                          ; pop 3 args
    TST.W   ($FFA7DC).L                                        ; display init flag
    BNE.S   .ds_done                                           ; if set, skip init
    MOVE.W  D2,D0
    MOVE.L  D0,-(SP)                                           ; push size
    MOVE.W  D3,D0
    MOVE.L  D0,-(SP)                                           ; push index
    MOVE.L  A2,-(SP)                                           ; push dest
    dc.w    $6100,$FA96                                        ; bsr.w $004B6C
    LEA     $C(SP),SP
.ds_done:                                                      ; $0050DC
    MOVEM.L (SP)+,D2-D3/A2
    RTS
; ---------------------------------------------------------------------------
; DisplayInitRows -- Set display row configuration and init flag
; Args: $C(SP)=row count
; ---------------------------------------------------------------------------
DisplayInitRows:                                               ; $0050E2
    MOVEM.L D2-D3,-(SP)
    MOVE.L  $C(SP),D2                                          ; arg (row count)
    MOVEQ   #0,D0
    MOVE.W  D2,D0                                              ; zero-extend
    BGE.S   .dir_noadj                                         ; if >= 0, skip adjustment
    ADDQ.L  #1,D0                                              ; signed round toward zero
.dir_noadj:                                                    ; $0050F2
    ASR.L   #1,D0                                              ; rows / 2
    MOVE.W  D0,D3                                              ; D3 = half rows
    MOVE.L  D0,-(SP)                                           ; push half rows
    PEA     ($0040).W                                          ; push 64 (width)
    CLR.L   -(SP)                                              ; push 0 (index)
    PEA     ($00FF14BC).L                                      ; push table address
    dc.w    $6100,$FAC0                                        ; bsr.w $004BC6
    LEA     $10(SP),SP                                         ; pop 4 args
    TST.W   D2
    BEQ.S   .dir_setzero                                       ; if row count == 0
    CLR.W   ($FFA7DC).L                                        ; clear flag (initialized)
    BRA.S   .dir_exit
.dir_setzero:                                                  ; $005118
    MOVE.W  #1,($FFA7DC).L                                     ; set flag (not initialized)
.dir_exit:                                                     ; $005120
    MOVEM.L (SP)+,D2-D3
    RTS
; ---------------------------------------------------------------------------
; DisplayInit15 -- Initialize display with 15 rows
; ---------------------------------------------------------------------------
DisplayInit15:                                                 ; $005126
    PEA     ($000F).W                                          ; push 15
    dc.w    $6100,$FFB6                                        ; bsr.w DisplayInitRows
    ADDQ.L  #4,SP
    RTS
; ---------------------------------------------------------------------------
; DisplayInit0 -- Initialize display with 0 rows (sets flag)
; ---------------------------------------------------------------------------
DisplayInit0:                                                  ; $005132
    CLR.L   -(SP)                                              ; push 0
    dc.w    $6100,$FFAC                                        ; bsr.w DisplayInitRows
    ADDQ.L  #4,SP
    RTS
; ---------------------------------------------------------------------------
; DisplaySetupScaled -- Load resource with size/4, scaled index
; Args: $C(SP)=dest ptr, $10(SP)=size
; ---------------------------------------------------------------------------
DisplaySetupScaled:                                            ; $00513C
    MOVEM.L D2/A2,-(SP)
    MOVE.L  $10(SP),D2                                         ; arg2 (size)
    MOVEA.L $C(SP),A2                                          ; arg1 (dest ptr)
    MOVEQ   #0,D0
    MOVE.W  D2,D0                                              ; zero-extend
    MOVEQ   #4,D1
    dc.w    $4EB9,$0003,$E146                                  ; jsr SignedDiv [$3E146]
    MOVE.W  D0,D2                                              ; D2 = size / 4
    PEA     ($0010).W                                          ; push 16
    MOVE.W  D2,D0
    LSL.W   #4,D0                                              ; D0 = (size/4) * 16
    MOVE.L  D0,-(SP)                                           ; push scaled index
    MOVE.L  A2,-(SP)                                           ; push dest
    dc.w    $6100,$FF2E                                        ; bsr.w DisplaySetup
    LEA     $C(SP),SP
    MOVEM.L (SP)+,D2/A2
    RTS
; ---------------------------------------------------------------------------
; DisplayTileSetup -- Set up tile map via GameCommand #6
; Args: $C(SP)=src1, $10(SP)=count, $14(SP)=src2 (all scaled by *32)
; ---------------------------------------------------------------------------
DisplayTileSetup:                                              ; $005170
    MOVEM.L D2-D3,-(SP)
    MOVE.L  $C(SP),D2                                          ; arg1
    MOVE.L  $14(SP),D3                                         ; arg3
    MOVE.L  $10(SP),D1                                         ; arg2 (count)
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    LSL.L   #5,D0                                              ; arg1 * 32
    MOVEA.L D0,A0
    MOVEQ   #0,D0
    MOVE.W  D3,D0
    LSL.L   #5,D0                                              ; arg3 * 32
    MOVEA.L D0,A1
    MOVE.W  D1,D2
    LSL.W   #5,D2                                              ; arg2 * 32
    MOVE.L  A1,-(SP)                                           ; push src2*32
    MOVE.L  A0,-(SP)                                           ; push src1*32
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    MOVE.L  D0,-(SP)                                           ; push count*32
    PEA     ($0001).W                                          ; push sub-command 1
    PEA     ($0006).W                                          ; push command 6
    dc.w    $4EB9,$0000,$0D64                                  ; jsr GameCommand [$D64]
    LEA     $14(SP),SP                                         ; pop 5 args
    MOVEM.L (SP)+,D2-D3
    RTS
; === Translated block $0051B6-$00538E ===
; 3 functions, 472 bytes

; ============================================================================
; func_0051B6 -- (TODO: name)
; 206 bytes | $0051B6-$005283
; ============================================================================
func_0051B6:
    link    a6,#$0
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    move.l  $18(a6), d4
    move.l  $24(a6), d5
    move.l  $20(a6), d6
    move.l  $1c(a6), d7
    movea.l  #$00FFA77E,a4
    tst.w   d3
    bne.b   l_051ea
    moveq   #$0,d0
    move.w  ($00FF88D6).l, d0
    bra.b   l_051f2
l_051ea:
    moveq   #$0,d0
    move.w  ($00FFA6B4).l, d0
l_051f2:
    movea.l d0, a3
    moveq   #$0,d0
    move.w  $12(a6), d0
    moveq   #$0,d1
    move.w  (a4), d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2, d1
    add.l   d1, d0
    add.l   d0, d0
    adda.l  d0, a3
    tst.w   d7
    bne.b   l_0521c
    moveq   #$0,d0
    move.w  ($00FF88D6).l, d0
    bra.b   l_05224
l_0521c:
    moveq   #$0,d0
    move.w  ($00FFA6B4).l, d0
l_05224:
    movea.l d0, a2
    moveq   #$0,d0
    move.w  d5, d0
    moveq   #$0,d1
    move.w  (a4), d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d6, d1
    add.l   d1, d0
    add.l   d0, d0
    adda.l  d0, a2
    move.w  $16(a6), d3
    add.w   d3, d3
    clr.w   d2
    bra.b   l_05276
l_05248:
    move.l  a2, -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0006).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $14(a7), a7
    moveq   #$0,d0
    move.w  (a4), d0
    add.l   d0, d0
    adda.l  d0, a3
    moveq   #$0,d0
    move.w  (a4), d0
    add.l   d0, d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_05276:
    cmp.w   d4, d2
    bcs.b   l_05248
    movem.l -$24(a6), d2-d7/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_005284 -- (TODO: name)
; 110 bytes | $005284-$0052F1
; ============================================================================
func_005284:
    movem.l d2-d7, -(a7)
    move.l  $30(a7), d2
    move.l  $2c(a7), d3
    move.l  $28(a7), d4
    move.l  $24(a7), d5
    move.l  $20(a7), d6
    move.l  $1c(a7), d7
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    dc.w    $6100,$FEF8                                 ; bsr.w $0051B6
    lea     $20(a7), a7
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    dc.w    $6100,$FED0                                 ; bsr.w $0051B6
    lea     $20(a7), a7
    movem.l (a7)+, d2-d7
    rts

; ============================================================================
; func_0052F2 -- (TODO: name)
; 156 bytes | $0052F2-$00538D
; ============================================================================
func_0052F2:
    link    a6,#-$200
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d7
    movea.l $1c(a6), a3
    clr.w   d3
    clr.w   d5
    bra.b   l_05354
l_05308:
    clr.w   d2
    move.w  d3, d0
    lsl.w   #$3, d0
    lea     -$200(a6), a0
    lea     (a0,d0.w), a1
    movea.l a1, a2
    moveq   #$0,d6
    move.w  d5, d6
    lsl.l   #$3, d6
    moveq   #$0,d4
    move.w  d2, d4
    lsl.l   #$3, d4
    bra.b   l_0534c
l_05326:
    move.w  d6, (a2)
    clr.w   $2(a2)
    move.w  (a3)+, $4(a2)
    move.w  d4, $6(a2)
    addq.l  #$8, a2
    moveq   #$0,d0
    addq.w  #$1, d3
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d7, d1
    add.l   d1, d0
    moveq   #$40,d1
    cmp.l   d0, d1
    ble.b   l_0535a
    addq.l  #$8, d4
    addq.w  #$1, d2
l_0534c:
    cmp.w   $16(a6), d2
    bcs.b   l_05326
    addq.w  #$1, d5
l_05354:
    cmp.w   $1a(a6), d5
    bcs.b   l_05308
l_0535a:
    moveq   #$0,d0
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    pea     -$200(a6)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$220(a6), d2-d7/a2-a3
    unlk    a6
    rts

; ---------------------------------------------------------------------------
; CmdSetBackground -- Set background display via GameCommand #26
; Args: $4(SP) = layer/mode parameter
; Called 46 times
; ---------------------------------------------------------------------------
CmdSetBackground:                                              ; $00538E
    MOVE.L  $4(SP),D1                                          ; arg (layer/mode)
    MOVE.L  #$00008000,-(SP)                                   ; push VRAM base
    PEA     ($0020).W                                          ; push 32 (height)
    PEA     ($0020).W                                          ; push 32 (width)
    CLR.L   -(SP)                                              ; push 0
    CLR.L   -(SP)                                              ; push 0
    MOVEQ   #0,D0
    MOVE.W  D1,D0                                              ; zero-extend arg
    MOVE.L  D0,-(SP)                                           ; push arg
    PEA     ($001A).W                                          ; command 26
    dc.w    $4EB9,$0000,$0D64                                  ; jsr GameCommand [$D64]
    LEA     $1C(SP),SP                                         ; pop 7 args
    RTS
; ============================================================================
; ClearScreen -- (TODO: describe)
; Called: ?? times.
; 98 bytes | $0053BA-$00541B
; ============================================================================
ClearScreen:                                                  ; $0053BA
    move.l  a2,-(sp)
    movea.l #$0d64,a2
    pea     ($000D).w
    jsr     (a2)
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a2)
    move.l  #$8000,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $002c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    lea     $0020(sp),sp
    movea.l (sp)+,a2
    rts
    dc.w    $4E56,$FFFC; $00541C
; === Translated block $005420-$005518 ===
; 4 functions, 248 bytes

; ============================================================================
; func_005420 -- (TODO: name)
; 64 bytes | $005420-$00545F
; ============================================================================
func_005420:
    move.l  $8(a6), d1
    move.w  d1, ($00FFA784).l
    move.w  d1, d0
    neg.w   d0
    andi.w  #$3ff, d0
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    unlk    a6
    rts

; ============================================================================
; func_005460 -- (TODO: name)
; 66 bytes | $005460-$0054A1
; ============================================================================
func_005460:
    link    a6,#-$4
    move.l  $8(a6), d1
    move.w  d1, ($00FFA788).l
    move.w  d1, d0
    neg.w   d0
    andi.w  #$3ff, d0
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    unlk    a6
    rts

; ============================================================================
; func_0054A2 -- (TODO: name)
; 60 bytes | $0054A2-$0054DD
; ============================================================================
func_0054A2:
    link    a6,#-$4
    move.l  $8(a6), d1
    move.w  d1, ($00FFA782).l
    move.w  d1, d0
    andi.w  #$3ff, d0
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0002).w
    pea     -$2(a6)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    unlk    a6
    rts

; ============================================================================
; func_0054DE -- (TODO: name)
; 58 bytes | $0054DE-$005517
; ============================================================================
func_0054DE:
    link    a6,#-$4
    move.l  $8(a6), d1
    move.w  d1, ($00FFA786).l
    move.w  d1, d0
    andi.w  #$3ff, d0
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$2(a6)
    pea     ($0002).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    unlk    a6
    rts

; ============================================================================
; SetScrollQuadrant -- (TODO: describe)
; Called: ?? times.
; 114 bytes | $005518-$005589
; ============================================================================
SetScrollQuadrant:                                                  ; $005518
    movem.l d2-d4,-(sp)
    move.l  $0014(sp),d2
    move.l  $0010(sp),d3
    cmpi.w  #$3,d3
    bhi.b   .l5530
    cmpi.w  #$3,d2
    bls.b   .l5534
.l5530:                                                 ; $005530
    clr.w   d3
    clr.w   d2
.l5534:                                                 ; $005534
    move.w  d2,d0
    lsl.w   #$2,d0
    add.w   d3,d0
    movea.l #$0004737e,a0
    move.b  (a0,d0.w),d4
    andi.l  #$ff,d4
    tst.w   d4
    bne.b   .l5552
    clr.w   d3
    clr.w   d2
.l5552:                                                 ; $005552
    moveq   #$0,d0
    move.w  d4,d0
    ori.l   #$9000,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    move.w  d3,d0
    lsl.w   #$5,d0
    addi.w  #$20,d0
    move.w  d0,($00FFA77E).l
    move.w  d2,d0
    lsl.w   #$5,d0
    addi.w  #$20,d0
    move.w  d0,($00FFA77C).l
    movem.l (sp)+,d2-d4
    rts
    dc.w    $2F02,$242F,$0008; $00558A
; === Translated block $005590-$0058FC ===
; 13 functions, 876 bytes

; ============================================================================
; func_005590 -- (TODO: name)
; 32 bytes | $005590-$0055AF
; ============================================================================
func_005590:
    tst.w   d2
    beq.b   l_0559c
    move.l  #$8c08, -(a7)
    bra.b   l_055a2
l_0559c:
    move.l  #$8c00, -(a7)
l_055a2:
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_0055B0 -- (TODO: name)
; 164 bytes | $0055B0-$005653
; ============================================================================
func_0055B0:
    move.l  a2, -(a7)
    movea.l  #$00000D64,a2
    move.l  #$8004, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8104, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8600, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8700, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8800, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8900, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    move.l  #$8a3f, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8e00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8f02, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$9030, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    move.l  #$9100, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$9200, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $10(a7), a7
    movea.l (a7)+, a2
    rts

; ============================================================================
; func_005654 -- (TODO: name)
; 226 bytes | $005654-$005735
; ============================================================================
func_005654:
    movem.l a2-a3, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FFA6B4,a3
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$9030, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.w  #$c000, ($00FF88D6).l
    move.w  #$fc00, ($00FFA78A).l
    move.w  #$f800, ($00FFA778).l
    move.w  #$e000, (a3)
    move.w  #$fc00, ($00FF161C).l
    clr.w   ($00FFA780).l
    move.l  #$c000, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    jsr     (a2)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.w  ($00FF161C).l, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  ($00FFA778).l, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    pea     ($0001).w
    jsr     (a2)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  ($00FF88D6).l, d0
    move.l  d0, -(a7)
    pea     ($001D).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $6100,$FDEC                                 ; bsr.w $005518
    addq.l  #$8, a7
    movem.l (a7)+, a2-a3
    rts

; ============================================================================
; PreGameInit -- (TODO: name)
; 74 bytes | $005736-$00577F
; ============================================================================
PreGameInit:
    move.l  a2, -(a7)
    movea.l  #$00000D64,a2
    pea     ($000D).w
    jsr     (a2)
    clr.l   -(a7)
    pea     ($7000).w
    move.l  #$ff0000, -(a7)
    dc.w    $4EB9,$0001,$D550                           ; jsr $01D550
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$10000, -(a7)
    pea     ($0001).w
    pea     ($0007).w
    jsr     (a2)
    dc.w    $6100,$FE44                                 ; bsr.w $0055B0
    dc.w    $6100,$FEE4                                 ; bsr.w $005654
    pea     ($000C).w
    jsr     (a2)
    lea     $28(a7), a7
    movea.l (a7)+, a2
    rts

; ============================================================================
; func_005780 -- (TODO: name)
; 32 bytes | $005780-$00579F
; ============================================================================
func_005780:
    pea     ($000D).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    dc.w    $6100,$FE24                                 ; bsr.w $0055B0
    dc.w    $6100,$FEC4                                 ; bsr.w $005654
    pea     ($000C).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
    rts

; ============================================================================
; func_0057A0 -- (TODO: name)
; 82 bytes | $0057A0-$0057F1
; ============================================================================
func_0057A0:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    cmpi.w  #$20, ($00FFA77E).l
    bne.b   l_057ec
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$B,d1
    lsl.l   d1, d0
    moveq   #$0,d1
    move.w  ($00FFA6B4).l, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$B,d1
    lsl.l   d1, d0
    moveq   #$0,d1
    move.w  ($00FF88D6).l, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001D).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $c(a7), a7
l_057ec:
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_0057F2 -- (TODO: name)
; 38 bytes | $0057F2-$005817
; ============================================================================
func_0057F2:
    move.l  d2, -(a7)
    move.l  $c(a7), d1
    move.l  $8(a7), d0
    add.l   d0, d0
    addi.l  #$200003, d0
    movea.l d0, a0
    moveq   #$0,d2
    bra.b   l_05810
l_0580a:
    clr.b   (a0)
    addq.l  #$2, a0
    addq.l  #$1, d2
l_05810:
    cmp.l   d1, d2
    bcs.b   l_0580a
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_005818 -- (TODO: name)
; 60 bytes | $005818-$005853
; ============================================================================
func_005818:
    movem.l d2-d4, -(a7)
    move.l  $18(a7), d1
    movea.l $10(a7), a1
    move.l  $14(a7), d0
    add.l   d0, d0
    addi.l  #$200003, d0
    movea.l d0, a0
    moveq   #$0,d2
    moveq   #$0,d4
    bra.b   l_05848
l_05838:
    move.b  (a1), d3
    move.b  d3, (a0)
    moveq   #$0,d0
    move.b  d3, d0
    add.l   d0, d4
    addq.l  #$2, a0
    addq.l  #$1, a1
    addq.l  #$1, d2
l_05848:
    cmp.l   d1, d2
    bcs.b   l_05838
    move.l  d4, d0
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_005854 -- (TODO: name)
; 60 bytes | $005854-$00588F
; ============================================================================
func_005854:
    movem.l d2-d4, -(a7)
    move.l  $18(a7), d1
    movea.l $10(a7), a1
    move.l  $14(a7), d0
    add.l   d0, d0
    addi.l  #$200003, d0
    movea.l d0, a0
    moveq   #$0,d2
    moveq   #$0,d4
    bra.b   l_05884
l_05874:
    move.b  (a0), d3
    move.b  d3, (a1)
    moveq   #$0,d0
    move.b  d3, d0
    add.l   d0, d4
    addq.l  #$2, a0
    addq.l  #$1, a1
    addq.l  #$1, d2
l_05884:
    cmp.l   d1, d2
    bcs.b   l_05874
    move.l  d4, d0
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_005890 -- (TODO: name)
; 52 bytes | $005890-$0058C3
; ============================================================================
func_005890:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d1
    move.l  $10(a7), d0
    add.l   d0, d0
    addi.l  #$200003, d0
    movea.l d0, a0
    moveq   #$0,d2
    moveq   #$0,d3
    bra.b   l_058b8
l_058ac:
    move.b  (a0), d4
    moveq   #$0,d0
    move.b  d4, d0
    add.l   d0, d3
    addq.l  #$2, a0
    addq.l  #$1, d2
l_058b8:
    cmp.l   d1, d2
    bcs.b   l_058ac
    move.l  d3, d0
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_0058C4 -- (TODO: name)
; 40 bytes | $0058C4-$0058EB
; ============================================================================
func_0058C4:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d1
    movea.l $10(a7), a0
    moveq   #$0,d2
    moveq   #$0,d3
    bra.b   l_058e0
l_058d6:
    move.b  (a0)+, d4
    moveq   #$0,d0
    move.b  d4, d0
    add.l   d0, d3
    addq.l  #$1, d2
l_058e0:
    cmp.l   d1, d2
    bcs.b   l_058d6
    move.l  d3, d0
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_0058EC -- (TODO: name)
; 2 bytes | $0058EC-$0058ED
; ============================================================================
func_0058EC:
    rts

; ============================================================================
; ErrorDisplay -- (TODO: name)
; 14 bytes | $0058EE-$0058FB
; ============================================================================
ErrorDisplay:
    pea     ($001E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$4, a7
    rts

; ============================================================================
; PlaceIconPair -- (TODO: describe)
; Called: 8 times.
; 98 bytes | $0058FC-$00595D
; ============================================================================
PlaceIconPair:                                                  ; $0058FC
    link    a6,#-$4
    lea     -$0004(a6),a0
    move.w  #$8404,d1
    tst.w   $000a(a6)
    bne.b   .l5920
    move.w  d1,d0
    addi.w  #$011d,d0
    move.w  d0,-$0004(a6)
    move.w  d1,d0
    addi.w  #$011e,d0
    bra.b   .l5930
.l5920:                                                 ; $005920
    move.w  d1,d0
    addi.w  #$011f,d0
    move.w  d0,-$0004(a6)
    move.w  d1,d0
    addi.w  #$0120,d0
.l5930:                                                 ; $005930
    move.w  d0,$0002(a0)
    move.l  a0,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    unlk    a6
    rts
; ============================================================================
; PlaceIconTiles -- Place tile icons by game element type (switch on type 1-4)
; Called: 13 times.
; 166 bytes | $00595E-$005A03
; ============================================================================
PlaceIconTiles:                                                  ; $00595E
    link    a6,#-$4
    movem.l d2-d7,-(sp)
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    move.w  #$8404,d3
    move.w  d7,d0
    ext.l   d0
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l598a
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.b   .l5990
    moveq   #$3,d1
    cmp.w   d1,d0
    beq.b   .l5996
    bra.b   .l599a
.l598a:                                                 ; $00598A
    move.w  #$010f,d2
    bra.b   .l599a
.l5990:                                                 ; $005990
    move.w  #$0117,d2
    bra.b   .l599a
.l5996:                                                 ; $005996
    move.w  #$0113,d2
.l599a:                                                 ; $00599A
    move.w  d2,d5
    addq.w  #$2,d5
    move.w  d2,d4
    addq.w  #$3,d4
    cmpi.w  #$4,d7
    bne.b   .l59b0
    move.w  #$011b,d5
    move.w  #$011c,d4
.l59b0:                                                 ; $0059B0
    cmpi.w  #$1,d6
    bne.b   .l59c0
    move.w  d2,d0
    add.w   d3,d0
    move.w  d0,-$0004(a6)
    bra.b   .l59d0
.l59c0:                                                 ; $0059C0
    move.w  d5,d0
    add.w   d3,d0
    move.w  d0,-$0004(a6)
    move.w  d4,d0
    add.w   d3,d0
    move.w  d0,-$0002(a6)
.l59d0:                                                 ; $0059D0
    pea     -$0004(a6)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  $0016(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$001c(a6),d2-d7
    unlk    a6
    rts
; ============================================================================
; DrawBox -- Draw a bordered dialog box with corner, edge, and fill tiles
; Called: 42 times.
; Args (stack, link -4): $08(A6)=x (l), $0C(A6)=y (l), $10(A6)=width (l), $14(A6)=height (l)
; Sets win_left/top/right/bottom. A2=GameCommand, A3/A4=&local_tile, A5=&win_bottom
; Tile sequence: $8527=TL, $8528=BL, $8529=TR, $852A=BR, $852B/C=L/R edge, $852D/E=T/B edge
; ============================================================================
DrawBox:                                                     ; $005A04
    link    a6,#-4
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0008(a6),d2                    ; D2 = x (col)
    move.l  $0010(a6),d3                    ; D3 = width
    move.l  $000C(a6),d4                    ; D4 = y (row)
    move.l  $0014(a6),d5                    ; D5 = height
    movea.l #$00000D64,a2                   ; A2 = GameCommand
    lea     -$2(a6),a3                      ; A3 = &local_tile word (A6-2)
    lea     -$2(a6),a4                      ; A4 = same (tile ptr arg to GameCommand)
    movea.l #$00FFBD48,a5                   ; A5 = &win_bottom
    ; Set text window boundary variables
    move.w  d2,d0
    addq.w  #1,d0
    move.w  d0,($00FFBD68).l               ; win_left = x+1
    move.w  d4,d0
    addq.w  #1,d0
    move.w  d0,($00FFB9E4).l               ; win_top = y+1
    move.w  d2,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    subq.l  #2,d0                          ; D0 = x+width-2 = win_right
    move.l  d0,d6                          ; D6 = win_right (save)
    move.w  d0,($00FFBDA8).l              ; win_right = x+width-2
    move.w  d4,d0
    add.w   d5,d0
    addi.w  #$FFFE,d0                      ; D0 = y+height-2 = win_bottom
    move.w  d0,(a5)                        ; win_bottom
    move.w  d2,d0
    addq.w  #1,d0
    move.w  d0,($00FF1290).l
    move.w  d6,($00FF1000).l
    ; Cursor setup helpers: x+1 and y+1
    move.w  d2,d0
    ext.l   d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    dc.w    $4EB9,$0003,$AAFE             ; jsr $3AAFE (cursor width setup)
    move.w  d4,d0
    ext.l   d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    dc.w    $4EB9,$0003,$AAF4             ; jsr $3AAF4 (cursor height setup)
    addq.l  #8,a7                         ; clean 2 args
    ; Bounds check: exit if window is degenerate
    move.w  ($00FFBD68).l,d0
    cmp.w   ($00FFBDA8).l,d0
    bcc.w   .exit                         ; win_left >= win_right
    move.w  ($00FFB9E4).l,d0
    cmp.w   (a5),d0
    bcc.w   .exit                         ; win_top >= win_bottom
    ; Fill interior: GameCommand(#$1A, 0, win_left, win_top, width-2, height-2, $8000)
    move.l  #$00008000,-(sp)
    move.w  d5,d0
    ext.l   d0
    subq.l  #2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    subq.l  #2,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFB9E4).l,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBD68).l,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; --- Draw 4 corners ---
    move.w  #$8527,(a3)                   ; local_tile = $8527 (TL corner)
    ; Top-left corner at (x, y)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,(a3)                       ; tile = $8528 (BL corner)
    ; Bottom-left corner at (x, win_bottom+1)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  (a5),d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,(a3)                       ; tile = $8529 (TR corner)
    ; Top-right corner at (win_right+1, y)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBDA8).l,d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,(a3)                       ; tile = $852A (BR corner)
    ; Bottom-right corner at (win_right+1, win_bottom+1)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  (a5),d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBDA8).l,d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; --- Row loop: draw left/right edges (tile $852B/$852C) ---
    move.w  d4,d3                          ; D3 = y (row counter)
    addq.w  #1,d3                          ; D3 = y+1 (first interior row)
    addq.w  #1,(a3)                        ; tile = $852B (left edge)
    bra.s   .row_check
.row_body:                                 ; $005B8C
    ; Left edge at (x, D3)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; Right edge at (win_right+1, D3) with tile+1 in -4(a6)
    move.w  (a3),d0
    addq.w  #1,d0
    move.w  d0,-$4(a6)
    pea     -$4(a6)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBDA8).l,d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,d3
.row_check:                                ; $005BE2
    moveq   #0,d0
    move.w  d3,d0
    moveq   #0,d1
    move.w  (a5),d1
    addq.l  #1,d1
    cmp.l   d1,d0
    blt.s   .row_body
    ; --- Column loop: draw top/bottom edges (tile $852D/$852E) ---
    addq.w  #1,d2
    addq.w  #2,(a3)                        ; tile = $852D (top edge)
    bra.s   .col_check
.col_body:                                 ; $005BF6
    ; Top edge at (D2, y)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; Bottom edge at (D2, win_bottom+1) with tile+1 in -4(a6)
    move.w  (a3),d0
    addq.w  #1,d0
    move.w  d0,-$4(a6)
    pea     -$4(a6)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  (a5),d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,d2
.col_check:                                ; $005C48
    moveq   #0,d0
    move.w  d2,d0
    moveq   #0,d1
    move.w  ($00FFBDA8).l,d1
    addq.l  #1,d1
    cmp.l   d1,d0
    blt.s   .col_body
.exit:                                     ; $005C5A
    movem.l -$28(a6),d2-d6/a2-a5
    unlk    a6
    rts
; ============================================================================
; DrawTileStrip -- (TODO: describe)
; Called: ?? times.
; 154 bytes | $005C64-$005CFD
; ============================================================================
DrawTileStrip:                                                  ; $005C64
    link    a6,#-$2c
    movem.l d2-d6/a2,-(sp)
    move.l  $0010(a6),d4
    move.l  $000c(a6),d5
    move.l  $0008(a6),d6
    lea     -$002a(a6),a2
    move.w  d4,d0
    ext.l   d0
    bge.b   .l5c84
    addq.l  #$1,d0
.l5c84:                                                 ; $005C84
    asr.l   #$1,d0
    move.l  d0,d3
    moveq   #$0,d2
    bra.b   .l5c9a
.l5c8c:                                                 ; $005C8C
    move.l  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$852f,(a2,a0.l)
    addq.l  #$1,d2
.l5c9a:                                                 ; $005C9A
    cmp.l   d3,d2
    blt.b   .l5c8c
    move.w  d4,d0
    ext.l   d0
    moveq   #$2,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    tst.l   d0
    beq.b   .l5cba
    move.l  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$8530,(a2,a0.l)
.l5cba:                                                 ; $005CBA
    move.l  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    clr.w   (a2,a0.l)
    tst.l   d3
    ble.b   .l5cd2
    move.l  a2,-(sp)
    pea     ($0001).w
    move.l  d3,-(sp)
    bra.b   .l5cdc
.l5cd2:                                                 ; $005CD2
    move.l  a2,-(sp)
    pea     ($0001).w
    pea     ($0001).w
.l5cdc:                                                 ; $005CDC
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$0044(a6),d2-d6/a2
    unlk    a6
    rts
; ============================================================================
; RenderTileStrip -- (TODO: describe)
; Called: ?? times.
; 480 bytes | $005CFE-$005EDD
; ============================================================================
RenderTileStrip:                                                  ; $005CFE
    link    a6,#-$24
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0010(a6),d2
    move.l  $000c(a6),d4
    move.l  $0008(a6),d5
    move.l  $0014(a6),d6
    move.l  $0018(a6),d7
    lea     -$0002(a6),a3
    movea.l #$0d64,a4
    move.w  d2,d3
    ext.l   d3
    asr.l   #$3,d3
    move.w  d6,d0
    ext.l   d0
    cmp.l   d0,d3
    bge.b   .l5d3a
    move.w  d2,d3
    ext.l   d3
    asr.l   #$3,d3
    bra.b   .l5d3e
.l5d3a:                                                 ; $005D3A
    move.w  d6,d3
    ext.l   d3
.l5d3e:                                                 ; $005D3E
    cmpi.w  #$2,d7
    bgt.b   .l5dba
    cmpi.w  #$1,d7
    bne.b   .l5d50
    move.w  #$8531,(a3)
    bra.b   .l5d54
.l5d50:                                                 ; $005D50
    move.w  #$8539,(a3)
.l5d54:                                                 ; $005D54
    tst.w   d3
    ble.b   .l5d80
    moveq   #$0,d0
    move.w  (a3),d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    lea     $001c(sp),sp
.l5d80:                                                 ; $005D80
    move.w  d2,d0
    andi.w  #$7,d0
    beq.w   .l5ed4
    move.w  d2,d0
    andi.w  #$7,d0
    add.w   d0,(a3)
    pea     -$0002(a6)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    bra.w   .l5ed2
.l5dba:                                                 ; $005DBA
    tst.w   d3
    ble.b   .l5dea
    move.w  #$8531,(a3)
    moveq   #$0,d0
    move.w  (a3),d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    lea     $001c(sp),sp
.l5dea:                                                 ; $005DEA
    move.w  d2,d0
    andi.w  #$7,d0
    beq.w   .l5e9c
    lea     -$0022(a6),a2
    move.w  d2,d0
    andi.w  #$7,d0
    move.w  d0,(a3)
    pea     ($0020).w
    move.l  a2,-(sp)
    clr.l   -(sp)
    move.w  (a3),d0
    lsl.w   #$5,d0
    movea.l #$00048a7c,a0
    pea     (a0,d0.w)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    addq.w  #$8,(a3)
    clr.w   d2
.l5e22:                                                 ; $005E22
    move.w  (a3),d0
    lsl.w   #$5,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00048a7c,a0
    move.w  (a0,d0.w),d0
    move.w  #$6666,d1
    eor.w   d1,d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    or.w    d0,(a2,a0.l)
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l5e22
    move.w  #$8531,(a3)
    clr.l   -(sp)
    move.l  #$a820,-(sp)
    move.l  a2,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a4)
    lea     $002c(sp),sp
    pea     -$0002(a6)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)
    lea     $001c(sp),sp
    addq.w  #$1,d3
.l5e9c:                                                 ; $005E9C
    cmp.w   d6,d3
    bge.b   .l5ed4
    move.w  #$8539,(a3)
    moveq   #$0,d0
    move.w  (a3),d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
.l5ed2:                                                 ; $005ED2
    jsr     (a4)
.l5ed4:                                                 ; $005ED4
    movem.l -$0048(a6),d2-d7/a2-a4
    unlk    a6
    rts
; ============================================================================
; FillSequentialWords -- (TODO: describe)
; Called: ?? times.
; 34 bytes | $005EDE-$005EFF
; ============================================================================
FillSequentialWords:                                                  ; $005EDE
    move.l  d2,-(sp)
    move.l  $000c(sp),d1
    move.l  $0010(sp),d0
    movea.l $0008(sp),a0
    clr.w   d2
    bra.b   .l5ef8
.l5ef0:                                                 ; $005EF0
    move.w  d1,(a0)
    addq.w  #$1,d2
    addq.l  #$2,a0
    addq.w  #$1,d1
.l5ef8:                                                 ; $005EF8
    cmp.w   d0,d2
    bcs.b   .l5ef0
    move.l  (sp)+,d2
    rts
LoadTileGraphics:                                                  ; $005F00
    link    a6,#-$3c
    movem.l d2-d5,-(sp)
    move.l  $0008(a6),d2
    move.l  $0014(a6),d3
    move.l  $0018(a6),d4
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l #$000ae0c4,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    move.w  d3,d5
    moveq   #$d,d0
    lsl.w   d0,d5
    or.w    d4,d5
    pea     ($001E).w
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$003c(a6)
    dc.w    $6100,$ff98                                 ; bsr.w $005EDE
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$000473d0,a0
    move.w  (a0,d0.w),d2
    cmpi.w  #$10,d2
    beq.b   .l5f74
    pea     ($0010).w
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00047390,a0
    bra.b   .l5f8c
.l5f74:                                                 ; $005F74
    pea     ($0010).w
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$4,d0
    move.l  d0,-(sp)
    move.w  $0022(a6),d0
    lsl.w   #$2,d0
    movea.l #$00ff03e0,a0
.l5f8c:                                                 ; $005F8C
    move.l  (a0,d0.w),-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($001E).w
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $002c(sp),sp
    pea     -$003c(a6)
    pea     ($0006).w
    pea     ($0005).w
    moveq   #$0,d0
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $001e(a6),d0
    move.l  d0,-(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$004c(a6),d2-d5
    unlk    a6
    rts
; ============================================================================
; LoadCompressedGfx -- (TODO: describe)
; Called: 7 times.
; 174 bytes | $005FF6-$0060A3
; ============================================================================
LoadCompressedGfx:                                                  ; $005FF6
    movem.l d2-d4,-(sp)
    move.l  $0010(sp),d2
    move.l  $0018(sp),d3
    move.l  $0014(sp),d4
    cmpi.w  #$12,d2
    bcs.w   .l609e
    cmpi.w  #$19,d2
    bhi.w   .l609e
    cmpi.w  #$18,d2
    bne.b   .l602c
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007675E).l
    bra.b   .l603a
.l602c:                                                 ; $00602C
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007673E).l
.l603a:                                                 ; $00603A
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l #$00088c90,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0078).w
    pea     ($0640).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0020(sp),sp
    pea     ($000700A8).l
    pea     ($000A).w
    pea     ($000C).w
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
.l609e:                                                 ; $00609E
    movem.l (sp)+,d2-d4
    rts
; === Translated block $0060A4-$006298 ===
; 6 functions, 500 bytes

; ============================================================================
; func_0060A4 -- (TODO: name)
; 116 bytes | $0060A4-$006117
; ============================================================================
func_0060A4:
    movem.l d2/a2, -(a7)
    movea.l  #$00FFBDAE,a2
    addq.w  #$1, (a2)
    move.w  (a2), d0
    cmp.w   $2(a2), d0
    bcs.b   l_06112
    moveq   #$0,d0
    move.w  $4(a2), d0
    add.l   d0, d0
    add.l   $e(a2), d0
    movea.l d0, a0
    move.w  $8(a2), d2
    mulu.w  (a0), d2
    clr.l   -(a7)
    move.l  $12(a2), -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    add.l   $a(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $8(a2), d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $18(a7), a7
    clr.w   (a2)
    moveq   #$0,d0
    move.w  $4(a2), d0
    addq.l  #$1, d0
    moveq   #$0,d1
    move.w  $6(a2), d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, $4(a2)
l_06112:
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; func_006118 -- (TODO: name)
; 116 bytes | $006118-$00618B
; ============================================================================
func_006118:
    movem.l d2/a2, -(a7)
    movea.l  #$00FFBDC4,a2
    addq.w  #$1, (a2)
    move.w  (a2), d0
    cmp.w   $2(a2), d0
    bcs.b   l_06186
    moveq   #$0,d0
    move.w  $4(a2), d0
    add.l   d0, d0
    add.l   $e(a2), d0
    movea.l d0, a0
    move.w  $8(a2), d2
    mulu.w  (a0), d2
    clr.l   -(a7)
    move.l  $12(a2), -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    add.l   $a(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $8(a2), d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $18(a7), a7
    clr.w   (a2)
    moveq   #$0,d0
    move.w  $4(a2), d0
    addq.l  #$1, d0
    moveq   #$0,d1
    move.w  $6(a2), d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, $4(a2)
l_06186:
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; func_00618C -- (TODO: name)
; 106 bytes | $00618C-$0061F5
; ============================================================================
func_00618C:
    link    a6,#-$4
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l, d1
    lsl.l   #$3, d1
    move.l  d1, d2
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, ($00FFA788).l
    move.w  d0, -$4(a6)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d2, d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, ($00FFA784).l
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    pea     -$4(a6)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    move.l  -$8(a6), d2
    unlk    a6
    rts

; ============================================================================
; func_0061F6 -- (TODO: name)
; 92 bytes | $0061F6-$006251
; ============================================================================
func_0061F6:
    move.l  a2, -(a7)
    movea.l  #$00FFBDDA,a2
    addq.w  #$1, $4(a2)
    move.w  $4(a2), d0
    cmp.w   (a2), d0
    bcs.b   l_06214
    addq.w  #$1, ($00FFA788).l
    clr.w   $4(a2)
l_06214:
    addq.w  #$1, $6(a2)
    move.w  $6(a2), d0
    cmp.w   $2(a2), d0
    bcs.b   l_0622c
    addq.w  #$1, ($00FFA784).l
    clr.w   $6(a2)
l_0622c:
    tst.w   $4(a2)
    beq.b   l_06238
    tst.w   $6(a2)
    bne.b   l_0624e
l_06238:
    move.w  ($00FFA784).l, d0
    move.l  d0, -(a7)
    move.w  ($00FFA788).l, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FF42                                 ; bsr.w $00618C
    addq.l  #$8, a7
l_0624e:
    movea.l (a7)+, a2
    rts

; ============================================================================
; func_006252 -- (TODO: name)
; 10 bytes | $006252-$00625B
; ============================================================================
func_006252:
    movea.l  #$00FFBDE2,a0
    addq.w  #$1, (a0)
    rts

; ============================================================================
; func_00625C -- (TODO: name)
; 60 bytes | $00625C-$006297
; ============================================================================
func_00625C:
    move.l  a2, -(a7)
    movea.l  #$00FFBDAC,a2
    move.w  (a2), d0
    andi.w  #$1, d0
    beq.b   l_06270
    dc.w    $6100,$FE36                                 ; bsr.w $0060A4
l_06270:
    move.w  (a2), d0
    andi.w  #$2, d0
    beq.b   l_0627c
    dc.w    $6100,$FE9E                                 ; bsr.w $006118
l_0627c:
    move.w  (a2), d0
    andi.w  #$4, d0
    beq.b   l_06288
    dc.w    $6100,$FF70                                 ; bsr.w $0061F6
l_06288:
    move.w  (a2), d0
    andi.w  #$8, d0
    beq.b   l_06294
    dc.w    $6100,$FFC0                                 ; bsr.w $006252
l_06294:
    movea.l (a7)+, a2
    rts

; ============================================================================
; ConfigScrollBar -- (TODO: describe)
; Called: ?? times.
; 178 bytes | $006298-$006349
; ============================================================================
ConfigScrollBar:                                                  ; $006298
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0030(sp),d3
    move.l  $003c(sp),d4
    move.l  $0038(sp),d5
    move.l  $0034(sp),d6
    move.l  $002c(sp),d7
    movea.l $0048(sp),a3
    movea.l $0044(sp),a4
    movea.l $0040(sp),a5
    tst.w   d3
    beq.b   .l62c4
    moveq   #$2,d2
    bra.b   .l62c6
.l62c4:                                                 ; $0062C4
    moveq   #$1,d2
.l62c6:                                                 ; $0062C6
    tst.w   d3
    beq.b   .l62d2
    move.l  #$00ffbdc4,d0
    bra.b   .l62d8
.l62d2:                                                 ; $0062D2
    move.l  #$00ffbdae,d0
.l62d8:                                                 ; $0062D8
    movea.l d0,a2
    moveq   #$0,d0
    move.w  d7,d0
    beq.b   .l62e8
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l6304
    bra.b   .l6344
.l62e8:                                                 ; $0062E8
    move.w  d2,d0
    not.w   d0
    and.w   d0,($00FFBDAC).l
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    bra.b   .l6344
.l6304:                                                 ; $006304
    move.w  d2,d0
    not.w   d0
    and.w   d0,($00FFBDAC).l
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    clr.w   (a2)
    move.w  d6,$0002(a2)
    clr.w   $0004(a2)
    move.w  d5,$0006(a2)
    move.w  d4,$0008(a2)
    move.l  a5,$000a(a2)
    move.l  a4,$000e(a2)
    move.l  a3,$0012(a2)
    move.w  d2,d0
    or.w    d0,($00FFBDAC).l
.l6344:                                                 ; $006344
    movem.l (sp)+,d2-d7/a2-a5
    rts
; ---------------------------------------------------------------------------
; SetScrollBarMode -- (TODO: describe)
; 124 bytes | $00634A-$0063C5
; ---------------------------------------------------------------------------
SetScrollBarMode:                                                  ; $00634A
    link    a6,#$0
    movem.l a2-a3,-(sp)
    movea.l #$00ffbdac,a3
    movea.l #$00ffbdda,a2
    moveq   #$0,d0
    move.w  $000a(a6),d0
    beq.b   .l636e
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l6384
    bra.b   .l63bc
.l636e:                                                 ; $00636E
    andi.w  #$fffb,(a3)
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    bra.b   .l63bc
.l6384:                                                 ; $006384
    andi.w  #$fffb,(a3)
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    dc.w    $6100,$fde8                                 ; bsr.w $00618C
    move.w  $0016(a6),(a2)
    move.w  $001a(a6),$0002(a2)
    clr.w   $0004(a2)
    clr.w   $0006(a2)
    ori.w   #$4,(a3)
.l63bc:                                                 ; $0063BC
    movem.l -$0008(a6),a2-a3
    unlk    a6
    rts
; === Translated block $0063C6-$00643C ===
; 1 functions, 118 bytes

; ============================================================================
; func_0063C6 -- (TODO: name)
; 118 bytes | $0063C6-$00643B
; ============================================================================
func_0063C6:
    movem.l d2-d3/a2-a4, -(a7)
    move.l  $18(a7), d3
    movea.l  #$00FFBDAC,a3
    movea.l  #$00000D64,a4
    movea.l  #$00FFBDE2,a2
    moveq   #$1,d2
    moveq   #$0,d0
    move.w  d3, d0
    beq.b   l_063f0
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_06402
    bra.b   l_06416
l_063f0:
    andi.w  #$fff7, (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   l_06434
l_06402:
    andi.w  #$fff7, (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    clr.w   (a2)
    bra.b   l_06430
l_06416:
    move.w  (a3), d0
    andi.w  #$8, d0
    beq.b   l_06434
    andi.w  #$fff7, (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    move.w  (a2), d2
l_06430:
    ori.w   #$8, (a3)
l_06434:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2-a4
    rts

; ============================================================================
; DrawCharInfoPanel -- (TODO: describe)
; Called: ?? times.
; 804 bytes | $00643C-$00675F
; ============================================================================
DrawCharInfoPanel:                                                  ; $00643C
    link    a6,#-$34
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0010(a6),d4
    move.l  $0008(a6),d5
    move.l  $0018(a6),d6
    movea.l #$0d64,a3
    lea     -$0030(a6),a4
    movea.l #$0004743c,a5
    tst.w   $0022(a6)
    beq.b   .l646a
    moveq   #$19,d0
    bra.b   .l646c
.l646a:                                                 ; $00646A
    moveq   #$2,d0
.l646c:                                                 ; $00646C
    move.w  d0,-$0032(a6)
    tst.w   $0022(a6)
    beq.b   .l647a
    moveq   #$2,d3
    bra.b   .l647c
.l647a:                                                 ; $00647A
    moveq   #$7,d3
.l647c:                                                 ; $00647C
    tst.w   $001e(a6)
    beq.b   .l6486
    moveq   #$13,d2
    bra.b   .l6488
.l6486:                                                 ; $006486
    moveq   #$2,d2
.l6488:                                                 ; $006488
    moveq   #$0,d0
    move.w  d5,d0
    moveq   #$36,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d4
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d6
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    moveq   #$0,d0
    move.w  d2,d0
    subq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    pea     ($0006).w
    pea     ($0017).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    pea     ($077E).w
    pea     ($0006).w
    pea     ($0017).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  -$0032(a6),d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5f00                           ; jsr $005F00
    moveq   #$0,d0
    move.w  d5,d0
    lsl.l   #$2,d0
    movea.l #$000ae19c,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $002c(sp),sp
    pea     ($0018).w
    pea     ($07E8).w
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    pea     ($0018).w
    move.w  d4,d0
    moveq   #$d,d1
    lsl.w   d1,d0
    ori.w   #$07e8,d0
    move.l  d0,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0000,$5ede                           ; jsr $005EDE
    lea     $0018(sp),sp
    move.w  -$0032(a6),d3
    move.w  d2,d7
    addq.w  #$2,d7
    moveq   #$0,d0
    move.w  ($00FF88D6).l,d0
    movea.l d0,a2
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    add.l   d0,d0
    adda.l  d0,a2
    move.l  a2,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$3,d0
    pea     (a5,d0.l)
    move.l  a4,-(sp)
    pea     ($0005).w
    pea     ($0004).w
    pea     ($000C).w
    clr.l   -(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    move.w  -$0032(a6),d3
    addq.w  #$1,d3
    move.w  d2,d7
    addq.w  #$4,d7
    moveq   #$0,d0
    move.w  ($00FF88D6).l,d0
    movea.l d0,a2
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    add.l   d0,d0
    adda.l  d0,a2
    move.l  a2,-(sp)
    move.l  a5,d0
    moveq   #$18,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.l  a4,d0
    moveq   #$1e,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    pea     ($0004).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    move.l  $0024(a6),-(sp)
    pea     ($0003E182).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $0028(sp),sp
    move.l  a2,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$3,d0
    pea     (a5,d0.l)
    move.l  a4,-(sp)
    pea     ($0005).w
    pea     ($0004).w
    pea     ($0010).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    move.l  a2,-(sp)
    move.l  a5,d0
    moveq   #$18,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.l  a4,d0
    moveq   #$1e,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    pea     ($0004).w
    pea     ($000A).w
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    tst.w   $0022(a6)
    beq.b   .l6748
    moveq   #$19,d0
    bra.b   .l674a
.l6748:                                                 ; $006748
    moveq   #$2,d0
.l674a:                                                 ; $00674A
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5f00                           ; jsr $005F00
    movem.l -$005c(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ============================================================================
; FillTileRect -- Fill rectangular VRAM area with repeating tile pattern
; Called: 17 times.
; 362 bytes | $006760-$0068C9
; ============================================================================
FillTileRect:                                                  ; $006760
    link    a6,#-$24
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0020(a6),d2
    move.l  $0014(a6),d4
    move.l  $000c(a6),d5
    move.l  $0008(a6),d6
    move.l  $0024(a6),d7
    lea     -$0020(a6),a2
    lea     -$0022(a6),a3
    lea     $001a(a6),a4
    tst.w   d4
    ble.w   .l68c0
    tst.w   (a4)
    ble.w   .l68c0
    move.w  d5,d0
    ext.l   d0
    move.w  d4,d1
    ext.l   d1
    add.l   d1,d0
    moveq   #$20,d1
    cmp.l   d0,d1
    bge.w   .l6846
    moveq   #$20,d0
    sub.w   d5,d0
    move.w  d0,(a3)
    move.w  d2,d3
    moveq   #$c,d0
    lsl.w   d0,d3
    move.w  d2,d0
    lsl.w   #$8,d0
    or.l    d0,d3
    move.w  d2,d0
    lsl.w   #$4,d0
    or.l    d0,d3
    or.w    d2,d3
    pea     ($0020).w
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    pea     ($0001).w
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
    move.w  d6,d0
    add.w   d0,d0
    movea.l #$0005f92e,a0
    move.w  (a0,d0.w),d3
    andi.l  #$ffff,d3
    asr.l   #$5,d3
    add.w   d7,d3
    move.w  $001e(a6),d0
    moveq   #$d,d1
    lsl.w   d1,d0
    or.l    d0,d3
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    sub.w   (a3),d4
    clr.w   d5
.l6846:                                                 ; $006846
    move.w  d2,d3
    moveq   #$c,d0
    lsl.w   d0,d3
    move.w  d2,d0
    lsl.w   #$8,d0
    or.l    d0,d3
    move.w  d2,d0
    lsl.w   #$4,d0
    or.l    d0,d3
    or.w    d2,d3
    pea     ($0020).w
    move.w  d3,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    pea     ($0001).w
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
    move.w  $001e(a6),d3
    moveq   #$d,d0
    lsl.w   d0,d3
    or.w    d7,d3
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
.l68c0:                                                 ; $0068C0
    movem.l -$0048(a6),d2-d7/a2-a4
    unlk    a6
    rts
; ============================================================================
; LoadScreenGfx -- Load and display compressed screen graphics
; Called: 21 times.
; 356 bytes | $0068CA-$006A2D
; ============================================================================
LoadScreenGfx:                                                  ; $0068CA
    link    a6,#$0
    movem.l d2/a2-a3,-(sp)
    move.l  $0008(a6),d2
    movea.l #$0d64,a2
    movea.l #$00ff1804,a3
    move.w  #$7,($00FF9A1C).l
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  ($00095118).l,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0014(sp),sp
    cmpi.w  #$4,d2
    bge.b   .l6924
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$98d2                           ; jsr $0098D2
    addq.l  #$4,sp
.l6924:                                                 ; $006924
    pea     ($02C0).w
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    pea     ($00070198).l
    pea     ($0016).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0030(sp),sp
    cmpi.w  #$1,$0012(a6)
    bne.b   .l69a2
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0017).w
    bra.b   .l69b2
.l69a2:                                                 ; $0069A2
    pea     ($21E1).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0016).w
.l69b2:                                                 ; $0069B2
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    cmpi.w  #$1,$000e(a6)
    bne.b   .l6a24
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007679E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($00070758).l
    pea     ($0016).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    move.l  ($00095138).l,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($00C0).w
    pea     ($0640).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
.l6a24:                                                 ; $006A24
    movem.l -$000c(a6),d2/a2-a3
    unlk    a6
    rts
; ============================================================================
; LoadScreen -- Load and initialize a game screen
; Called: 38 times. Args (stack, no link): $10(sp)=screen_type, $14(sp)=screen_id
; ============================================================================
LoadScreen:                                                  ; $006A2E
    movem.l d2-d3/a2,-(sp)
    move.l  $0014(sp),d2                                 ; D2 = screen_id
    move.l  $0010(sp),d3                                 ; D3 = screen_type
    movea.l #$00000D64,a2                                ; A2 = GameCommand
    move.w  d2,($00FF9A1C).l                             ; store screen_id
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a2)                                         ; GameCommand($10,0,$40)
    clr.l   -(sp)
    dc.w    $4EB9,$0000,$538E                            ; jsr CmdSetBackground
    clr.l   -(sp)
    pea     ($0004E1EC).l
    pea     ($0001).w
    pea     ($077F).w
    dc.w    $4EB9,$0001,$D568                            ; jsr VRAMBulkLoad
    lea     $20(sp),sp
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    lea     $1C(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0017).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    dc.w    $4EB9,$0000,$5092                            ; jsr $5092
    lea     $28(sp),sp
    pea     ($00070198).l
    pea     ($0016).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)                                         ; GameCommand($1B,...)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #2,d0                                        ; D0 = screen_id * 4
    movea.l #$0009511C,a0                                ; A0 = screen table base
    move.l  (a0,d0.l),-(sp)                              ; push table[screen_id]
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                            ; jsr $3FEC
    lea     $24(sp),sp
    cmpi.w  #$0004,d3                                    ; screen_type >= 4?
    bge.s   .skip_calc
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push screen_id
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push screen_type
    dc.w    $4EB9,$0000,$9C9E                            ; jsr $9C9E
    addq.l  #8,sp
.skip_calc:                                              ; $006B1E
    pea     ($02C0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$45E6                            ; jsr $45E6
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    lea     $28(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0017).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)                                         ; GameCommand($1A,...)
    lea     $1C(sp),sp
    movem.l (sp)+,d2-d3/a2
    rts
; ============================================================================
; ShowRelPanel -- Display character relationship/affinity panel
; Called: 40 times.
; Args: $0a(a6)=player_index (l), $0e(a6)=char_index (l)
; Regs: D2-D5/A0-A5 saved. A2=result buf (A6-$C4). A5=player rec ($FF0018+p*36).
; char<7: 2 loops over char record data; char>=7: 32-entry acquaintance scan.
; ============================================================================
ShowRelPanel:                                                ; $006B78
    link    a6,#-$c4
    movem.l d2-d7/a2-a5,-(sp)
    move.w  $000a(a6),d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$1f,d7
    move.w  #$0660,d6
    pea     ($0030).w
    pea     ($0007).w
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
    lea     $000c(sp),sp
    lea     -$c4(a6),a2
    cmpi.w  #$7,$000e(a6)
    bge.w   .alt_path
    move.w  $000e(a6),d0
    lsl.w   #2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    move.l  a0,-$4(a6)
    move.b  (a0),d3
    andi.l  #$ff,d3
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02fe                  ; jsr BitFieldSearch (PC-rel)
    nop
    addq.l  #8,sp
    move.w  d0,d4
    movea.l -$4(a6),a0
    move.b  (a0),d0
    andi.l  #$ff,d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    movea.l -$4(a6),a0
    move.b  $1(a0),d5
    andi.l  #$ff,d5
    bra.w   .loop1_check
.loop1_body:                             ; $006C20
    move.w  d3,d0
    ext.l   d0
    moveq   #0,d1
    move.b  $1(a5),d1
    cmp.l   d1,d0
    bne.b   .l1_b
    move.w  #$0760,d2
    bra.b   .l1_commit
.l1_b:                                   ; $006C34
    cmp.w   d4,d3
    bne.b   .l1_c
    move.w  #$0761,d2
    bra.b   .l1_commit
.l1_c:                                   ; $006C3E
    move.w  d3,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  $000a(a6),d1
    lsl.w   #2,d1
    movea.l #$00ffa6a0,a0
    and.l   (a0,d1.w),d0
    beq.b   .l1_d
    move.w  #$0762,d2
    bra.b   .l1_commit
.l1_d:                                   ; $006C60
    move.w  #$0763,d2
.l1_commit:                              ; $006C64
    moveq   #0,d0
    move.b  $1(a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    clr.w   (a2)+
    move.w  d2,(a2)+
    moveq   #0,d0
    move.b  (a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    move.w  d3,d0
    lsl.w   #3,d0
    move.w  $000a(a6),d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba80,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #0,d0
    move.b  (a4),d0
    moveq   #0,d1
    move.b  $1(a4),d1
    sub.w   d1,d0
    move.w  d0,d2
    ble.b   .l1_nobar
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  $1(a3),d0
    addq.l  #8,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  (a3),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dfbe            ; jsr $1DFBE
    lea     $0014(sp),sp
    addq.w  #1,d6
.l1_nobar:                               ; $006CD4
    addq.w  #1,d7
    addq.l  #2,a3
    subq.w  #1,d5
    addq.w  #1,d3
.loop1_check:                            ; $006CDC
    tst.w   d5
    bgt.w   .loop1_body
    movea.l -$4(a6),a0
    move.b  $2(a0),d0
    andi.l  #$ff,d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    movea.l -$4(a6),a0
    move.b  $2(a0),d3
    andi.l  #$ff,d3
    movea.l -$4(a6),a0
    move.b  $3(a0),d5
    andi.l  #$ff,d5
    clr.w   d4
    bra.w   .loop2_check
.loop2_body:                             ; $006D20
    move.w  d4,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  $000a(a6),d1
    mulu.w  #$000e,d1
    movea.l d7,a0
    move.w  $000e(a6),d7
    add.w   d7,d7
    exg     d7,a0
    add.w   a0,d1
    movea.l #$00ffbd6c,a0
    move.w  (a0,d1.w),d1
    andi.l  #$ffff,d1
    and.l   d1,d0
    beq.b   .l2_b
    move.w  #$0764,d2
    bra.b   .l2_commit
.l2_b:                                   ; $006D58
    move.w  #$0765,d2
.l2_commit:                              ; $006D5C
    moveq   #0,d0
    move.b  $1(a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    clr.w   (a2)+
    move.w  d2,(a2)+
    moveq   #0,d0
    move.b  (a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    move.w  d3,d0
    lsl.w   #3,d0
    move.w  $000a(a6),d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba80,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #0,d0
    move.b  (a4),d0
    moveq   #0,d1
    move.b  $1(a4),d1
    sub.w   d1,d0
    move.w  d0,d2
    ble.b   .l2_nobar
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  $1(a3),d0
    addq.l  #8,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  (a3),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dfbe            ; jsr $1DFBE
    pea     ($0002).w
    pea     ($000e).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
    lea     $001c(sp),sp
    addq.w  #1,d6
.l2_nobar:                               ; $006DDA
    addq.w  #1,d7
    addq.l  #2,a3
    subq.w  #1,d5
    addq.w  #1,d3
    addq.w  #1,d4
.loop2_check:                            ; $006DE4
    tst.w   d5
    bgt.w   .loop2_body
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$c4(a6)
    movea.l -$4(a6),a0
    move.b  $1(a0),d0
    andi.l  #$ff,d0
    movea.l -$4(a6),a0
    move.b  $3(a0),d1
    andi.l  #$ff,d1
    add.w   d1,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    pea     ($000f).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9e1c            ; jsr $9E1C
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$03e0                  ; jsr $722A (PC-rel)
    nop
    lea     $0028(sp),sp
    bra.w   .exit
.alt_path:                               ; $006E56
    movea.l #$0005e948,a3
    clr.w   d4
    clr.w   d3
    bra.b   .alt_check
.alt_body:                               ; $006E62
    moveq   #0,d0
    move.b  $1(a5),d0
    cmp.w   d4,d0
    bne.b   .alt_b
    move.w  #$0760,d2
    bra.b   .alt_commit
.alt_b:                                  ; $006E72
    move.w  d4,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  $000a(a6),d1
    lsl.w   #2,d1
    movea.l #$00ff08ec,a0
    and.l   (a0,d1.w),d0
    beq.b   .alt_c
    move.w  #$0761,d2
    bra.b   .alt_commit
.alt_c:                                  ; $006E94
    clr.w   d2
.alt_commit:                             ; $006E96
    tst.w   d2
    beq.b   .alt_skip
    moveq   #0,d0
    move.b  $1(a3),d0
    addi.w  #$007c,d0
    move.w  d0,(a2)+
    clr.w   (a2)+
    moveq   #0,d0
    move.w  d2,d0
    move.w  d0,(a2)+
    moveq   #0,d0
    move.b  (a3),d0
    addi.w  #$007c,d0
    move.w  d0,(a2)+
    addq.w  #1,d3
.alt_skip:                               ; $006EBA
    addq.l  #2,a3
    addq.w  #1,d4
.alt_check:                              ; $006EBE
    cmpi.w  #$20,d4
    blt.b   .alt_body
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$c4(a6)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    pea     ($000f).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
.exit:                                   ; $006EE0
    movem.l -$ec(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ---------------------------------------------------------------------------
; BitFieldSearch -- Search bitfield in RAM for a set bit
; Args: $C(SP) = entity index (long), $12(SP) = table index (word)
; Returns: D0 = bit position if found, $FF if not
; Uses ROM table at $5ECBC (byte[0]=start bit, byte[1]=count)
; and RAM table at $FF08EC (longwords indexed by entity)
; Called 47 times
; ---------------------------------------------------------------------------
BitFieldSearch:                                                ; $006EEA
    MOVEM.L D2-D3,-(SP)
    MOVE.L  $C(SP),D1                                          ; entity index
    MOVE.W  $12(SP),D0                                         ; table index
    LSL.W   #2,D0                                              ; * 4 (entry size)
    MOVEA.L #$0005ECBC,A0                                      ; ROM lookup table
    LEA     0(A0,D0.W),A0                                      ; point to entry
    MOVEA.L A0,A1                                              ; A1 = entry pointer
    MOVEQ   #0,D0
    MOVE.B  (A1),D0                                            ; start bit position
    MOVEQ   #1,D3
    LSL.L   D0,D3                                              ; D3 = 1 << start_bit (mask)
    CLR.W   D2                                                 ; counter = 0
    BRA.S   .bfs_check
.bfs_loop:                                                     ; $006F10
    MOVE.W  D1,D0
    LSL.W   #2,D0                                              ; entity * 4
    MOVEA.L #$00FF08EC,A0                                      ; RAM bitfield table
    MOVE.L  0(A0,D0.W),D0                                      ; load entity bits
    AND.L   D3,D0                                              ; test current bit
    BEQ.S   .bfs_next                                          ; not set, continue
    MOVEQ   #0,D0
    MOVE.B  (A1),D0                                            ; start bit
    ADD.W   D2,D0                                              ; + offset = actual position
    BRA.S   .bfs_exit                                          ; found
.bfs_next:                                                     ; $006F2A
    ADD.L   D3,D3                                              ; shift mask left by 1
    ADDQ.W  #1,D2                                              ; counter++
.bfs_check:                                                    ; $006F2E
    MOVEQ   #0,D0
    MOVE.B  $1(A1),D0                                          ; bit count limit
    CMP.W   D2,D0                                              ; limit > counter?
    BGT.S   .bfs_loop                                          ; continue searching
    MOVE.W  #$00FF,D0                                          ; not found sentinel
.bfs_exit:                                                     ; $006F3C
    MOVEM.L (SP)+,D2-D3
    RTS
; ============================================================================
; CharCodeCompare -- Compare two character codes, compute compatibility index
; Called: 22 times. Args (stack, no link): $18(SP)=code1 (l), $1C(SP)=code2 (l)
; Returns: D0.W = compatibility index, $FFFF if incompatible, 0 if equal
; Uses tables at $5E356, $5ECBC, $5E546/$5E5BE/$5E5C8/$5E5D8/$5E61E/$5E630/$5E670
; ============================================================================
CharCodeCompare:                                             ; $006F42
    movem.l d2-d5/a2,-(sp)
    move.l  $0018(sp),d2                                 ; D2 = code1
    move.l  $001C(sp),d3                                 ; D3 = code2
    ; Sort so D2 <= D3
    cmp.w   d3,d2
    bls.s   .sorted
    move.w  d2,d4
    move.w  d3,d2
    move.w  d4,d3
.sorted:                                                 ; $006F58
    cmp.w   d3,d2
    bne.s   .not_equal
    clr.w   d2                                           ; equal → return 0
    bra.w   .exit
.not_equal:                                              ; $006F62
    cmpi.w  #$0020,d2
    bcc.s   .check_high                                  ; D2 >= 32 → high path
    cmpi.w  #$0020,d3
    bcc.s   .check_high                                  ; D3 >= 32 → high path
    ; Both < 32: call CharPairIndex(code2, code1, #$20)
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0020).w
    dc.w    $4EBA,$025E                                  ; jsr (d16,pc) → CharPairIndex ($0071DE)
    nop
    lea     $000C(sp),sp                                 ; clean 3 args
    move.w  d0,d2                                        ; D2 = pair index result
    movea.l #$0005E356,a0                                ; A0 = char range score table
    move.b  (a0,d2.w),d0                                 ; D0 = table[D2]
.exit_mask:                                              ; $006F94
    andi.l  #$000000FF,d0                                ; zero-extend
    move.w  d0,d2                                        ; D2 = score byte
    bra.w   .exit
.check_high:                                             ; $006FA0
    cmpi.w  #$0059,d2
    bcc.w   .fail                                        ; D2 >= 89 → fail
    cmpi.w  #$0059,d3
    bcc.w   .fail                                        ; D3 >= 89 → fail
    ; [32..88]: RangeLookup both codes, compare categories
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4EB9,$0000,$D648                            ; jsr RangeLookup(D2) → D0=cat(D2)
    move.w  d0,d4                                        ; D4 = category(D2)
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4EB9,$0000,$D648                            ; jsr RangeLookup(D3) → D0=cat(D3)
    addq.l  #8,sp                                        ; clean 2 args
    move.w  d0,d5                                        ; D5 = category(D3)
    cmp.w   d5,d4
    bne.w   .fail                                        ; different categories → fail
    cmpi.w  #$0020,d2
    bcc.w   .fail                                        ; mixed-class → fail
    ; Same category, D2 < 32: look up range entry at $5ECBC[D4*4]
    move.w  d4,d0
    lsl.w   #2,d0                                        ; D0 = D4 * 4
    movea.l #$0005ECBC,a0                                ; A0 = range entries
    lea     (a0,d0.w),a0                                 ; A0 = &RangeEntry[D4]
    movea.l a0,a2                                        ; A2 = save entry pointer
    move.b  (a0),d0                                      ; D0 = entry base byte [+0]
    andi.l  #$000000FF,d0
    move.w  d2,d1
    sub.w   d0,d1                                        ; D1 = code1 - base
    move.w  d1,d2                                        ; D2 = adjusted code1
    moveq   #0,d0
    move.b  $0002(a2),d0                                 ; D0 = entry byte [+2]
    move.w  d3,d1
    sub.w   d0,d1                                        ; D1 = code2 - base
    move.w  d1,d3                                        ; D3 = adjusted code2
    ; Dispatch via 7-entry jump table (category D4, 0-6)
    moveq   #0,d0
    move.w  d4,d0
    moveq   #6,d1
    cmp.l   d1,d0
    bhi.w   .fail                                        ; category > 6 → fail
    add.l   d0,d0                                        ; D0 *= 2 (word index)
    dc.w    $303B,$0806                                  ; move.w ($06,pc,d0.w),d0
    dc.w    $4EFB,$0002                                  ; jmp ($02,pc,d0.w)
.jtab:
    dc.w    .case0-.jtab
    dc.w    .case1-.jtab
    dc.w    .case2-.jtab
    dc.w    .case3-.jtab
    dc.w    .case4-.jtab
    dc.w    .case5-.jtab
    dc.w    .case6-.jtab
.case0:                                                  ; $00702A
    move.w  d2,d0
    dc.w    $C0FC,$0011                                  ; and.w #$0011,d0
    add.w   d3,d0
    movea.l #$0005E546,a0
.shared_lookup:                                          ; $007038 (shared by all cases)
    move.b  (a0,d0.w),d0                                 ; look up score in category table
    bra.w   .exit_mask                                   ; → mask + assign + exit
.case1:                                                  ; $007040
    move.w  d2,d0
    dc.w    $C0FC,$0005                                  ; and.w #$0005,d0
    add.w   d3,d0
    movea.l #$0005E5BE,a0
    bra.s   .shared_lookup
.case2:                                                  ; $007050
    move.w  d2,d0
    dc.w    $C0FC,$0005                                  ; and.w #$0005,d0
    add.w   d3,d0
    movea.l #$0005E5C8,a0
    bra.s   .shared_lookup
.case3:                                                  ; $007060
    move.w  d2,d0
    dc.w    $C0FC,$000A                                  ; and.w #$000A,d0
    add.w   d3,d0
    movea.l #$0005E5D8,a0
    bra.s   .shared_lookup
.case4:                                                  ; $007070
    move.w  d2,d0
    dc.w    $C0FC,$0006                                  ; and.w #$0006,d0
    add.w   d3,d0
    movea.l #$0005E61E,a0
    bra.s   .shared_lookup
.case5:                                                  ; $007080
    move.w  d2,d0
    dc.w    $C0FC,$0009                                  ; and.w #$0009,d0
    add.w   d3,d0
    movea.l #$0005E630,a0
    bra.s   .shared_lookup
.case6:                                                  ; $007090
    move.w  d2,d0
    dc.w    $C0FC,$0005                                  ; and.w #$0005,d0
    add.w   d3,d0
    movea.l #$0005E670,a0
    bra.s   .shared_lookup
.fail:                                                   ; $0070A0
    move.w  #$FFFF,d2
.exit:                                                   ; $0070A4
    cmpi.w  #$FFFF,d2
    beq.s   .final                                       ; fail → skip scaling, return $FFFF
    move.w  d2,d0
    dc.w    $C0FC,$0064                                  ; and.w #$0064,d0 (mask to 0-100)
    move.w  d0,d2
    moveq   #0,d0
    move.w  d2,d0                                        ; zero-extend D2
    bge.s   .no_round                                    ; non-negative → no adjustment
    moveq   #$0F,d1
    add.l   d1,d0                                        ; round toward zero
.no_round:                                               ; $0070BC
    asr.l   #4,d0                                        ; D0 /= 16 (arithmetic)
    move.l  d0,d1
    lsl.l   #2,d0                                        ; D0 *= 4
    add.l   d1,d0                                        ; D0 = D0*4 + D0 = D0*5
    add.l   d0,d0                                        ; D0 *= 2 = D0*10
    moveq   #$0A,d1
    dc.w    $4EB9,$0003,$E08A                            ; jsr SignedDiv (D0/10)
    dc.w    $C0FC,$000A                                  ; and.w #$000A,d0
    move.w  d0,d2                                        ; D2 = scaled result
.final:                                                  ; $0070D4
    move.w  d2,d0                                        ; D0 = return value
    movem.l (sp)+,d2-d5/a2
    rts
; ============================================================================
; CharCodeScore -- Compute percentage match score for two character codes
; Called: 12 times. Args (stack, no link): $C(SP)=code1 (w), $10(SP)=code2 (w)
; Returns: D0.W = percentage score, or $FFFF if no match
; ============================================================================
CharCodeScore:                                               ; $0070DC
    movem.l d2-d3,-(sp)
    move.l  $000C(sp),d2                                 ; D2 = code1
    move.l  $0010(sp),d3                                 ; D3 = code2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push D3 sign-extended
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                                     ; push D2 sign-extended
    dc.w    $6100,$FE4C                                  ; bsr.w $006F42 (CharCodeCompare)
    addq.l  #8,sp                                        ; clean 2 args
    move.w  d0,d2                                        ; D2 = compare result
    tst.w   d2                                           ; result == 0?
    beq.s   .no_match
    cmpi.w  #$FFFF,d2
    bne.s   .has_result
.no_match:                                               ; $007106
    move.w  #$FFFF,d2
    bra.s   .scale
.has_result:                                             ; $00710C
    moveq   #0,d0
    move.w  d2,d0
    asr.l   #2,d0
    addi.l  #$78,d0
    moveq   #$0A,d1
    dc.w    $4EB9,$0003,$E08A                             ; jsr $03E08A
    dc.w    $C0FC,$000A                                  ; and.w #$000A,d0
    move.w  d0,d2
.scale:                                                  ; $007126
    move.w  ($00FF0002).l,d0
    ext.l   d0
    moveq   #3,d1
    sub.l   d0,d1
    move.l  d1,d0
    add.l   d0,d0
    add.l   d1,d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #0,d1
    move.w  d2,d1
    dc.w    $4EB9,$0003,$E05C                             ; jsr Multiply32
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                             ; jsr $03E08A
    move.w  d0,d2                                        ; D2 = final result
    movem.l (sp)+,d2-d3
    rts
; ============================================================================
; RangeMatch -- Check if two char codes map to the same range category
; Called: 10 times. Args (stack, no link): $14(SP)=code1 (w), $18(SP)=code2 (w)
; Returns: D0.W = 1 (same range), 0 (different range), $FF (out of range)
; Uses A2 = RangeLookup ($0000D648)
; ============================================================================
RangeMatch:                                              ; $007158
    movem.l d2-d4/a2,-(sp)
    move.l  $0014(sp),d2                                 ; D2 = code1
    move.l  $0018(sp),d3                                 ; D3 = code2
    movea.l #$0000D648,a2                                ; A2 = RangeLookup
    cmp.w   d3,d2                                        ; D2 <= D3?
    ble.s   .sorted
    move.w  d2,d4                                        ; swap D2, D3 to ensure D2 <= D3
    move.w  d3,d2
    move.w  d4,d3
.sorted:                                                 ; $007174
    cmp.w   d3,d2                                        ; D2 == D3?
    beq.s   .return_ff                                   ; equal → not comparable
    cmpi.w  #$0020,d2
    bge.s   .check_high                                  ; D2 >= 32 → check upper range
    cmpi.w  #$0020,d3
    bge.s   .check_high                                  ; D3 >= 32 → check upper range
    ; both codes < 32: compare via RangeLookup
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D2)
    move.w  d0,d4                                        ; D4 = RangeLookup(D2)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D3)
    addq.l  #8,sp
    move.w  d0,d3                                        ; D3 = RangeLookup(D3)
    cmp.w   d3,d4                                        ; same range?
    bne.s   .return_zero
.return_one:                                             ; $00719E
    moveq   #1,d2
    bra.s   .return_d2
.return_zero:                                            ; $0071A2
    clr.w   d2
    bra.s   .return_d2
.check_high:                                             ; $0071A6
    cmpi.w  #$0059,d2
    bge.s   .return_ff
    cmpi.w  #$0059,d3
    bge.s   .return_ff
    ; 32 <= code < 89: compare via RangeLookup
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D2)
    move.w  d0,d4
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a2)                                         ; RangeLookup(D3)
    addq.l  #8,sp
    move.w  d0,d3
    cmp.w   d3,d4
    bne.s   .return_ff
    cmpi.w  #$0020,d2
    blt.s   .return_one                                  ; D2 < 32 → return 1
.return_ff:                                              ; $0071D2
    move.w  #$00FF,d2
.return_d2:                                              ; $0071D6
    move.w  d2,d0
    movem.l (sp)+,d2-d4/a2
    rts
; ============================================================================
; CharPairIndex -- Compute triangular index for a pair of character codes
; Called: 1 time (from CharCodeCompare low path).
; Args (stack, no link): $14(SP)=limit (l), $18(SP)=code1 (l), $1C(SP)=code2 (l)
; Returns: D0.W = triangular/pair index, or $FFFF if out of range
; ============================================================================
CharPairIndex:                                               ; $0071DE
    movem.l d2-d5,-(sp)
    move.l  $0014(sp),d2                                 ; D2 = limit ($0020)
    move.l  $0018(sp),d4                                 ; D4 = code1 (arg2)
    move.l  $001C(sp),d5                                 ; D5 = code2 (arg3)
    clr.w   d3                                           ; D3 = 0 (result accumulator)
    cmp.w   d4,d2                                        ; limit vs code1
    ble.s   .fail                                        ; if limit <= code1, fail
    cmp.w   d5,d2                                        ; limit vs code2
    ble.s   .fail                                        ; if limit <= code2, fail
    cmp.w   d5,d4                                        ; code1 vs code2
    bne.s   .compare                                     ; if code1 != code2, compare
.fail:                                                   ; $0071FC
    move.w  #$FFFF,d3
    bra.s   .return
.compare:                                                ; $007202
    cmp.w   d5,d4                                        ; re-check code1 vs code2
    bge.s   .sorted                                      ; if code1 >= code2 (signed), sorted
    move.w  d4,d2                                        ; swap step 1: D2 = code1 (min)
    move.w  d5,d4                                        ; swap step 2: D4 = code2 (max)
    move.w  d2,d5                                        ; swap step 3: D5 = code1 (min saved)
.sorted:                                                 ; $00720A
    clr.w   d2                                           ; D2 = 0 (loop counter)
    bra.s   .check                                       ; enter loop at check
.loop:                                                   ; $007210
    add.w   d2,d3                                        ; D3 += D2
    addq.w  #1,d2                                        ; D2++
.check:                                                  ; $007214
    moveq   #0,d0
    move.w  d2,d0                                        ; D0 = counter
    move.w  d4,d1                                        ; D1 = loop bound (D4)
    ext.l   d1
    cmp.l   d1,d0
    blt.s   .loop                                        ; if D0 < D4, continue
    add.w   d5,d3                                        ; D3 += loop start offset
.return:                                                 ; $007222
    move.w  d3,d0                                        ; D0 = result
    movem.l (sp)+,d2-d5
    rts

; === Translated block $00722A-$007390 ===
; 1 functions, 358 bytes

; ============================================================================
; func_00722A -- (TODO: name)
; 358 bytes | $00722A-$00738F
; ============================================================================
func_00722A:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $c(a6), d7
    lea     $a(a6), a3
    move.w  (a3), d0
    mulu.w  #$7, d0
    add.w   d7, d0
    movea.l  #$00FFA7BC,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$2(a6)
    clr.w   d2
    moveq   #$2,d3
    bra.w   l_0737e
l_0725e:
    cmp.w   d7, d2
    beq.w   l_0737c
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    and.l   d1, d0
    beq.w   l_0737c
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FC62                                 ; bsr.w $006EEA
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d0
    bne.b   l_072aa
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9DC4                           ; jsr $009DC4
    addq.l  #$8, a7
    move.w  d0, d4
l_072aa:
    move.w  d7, d0
    mulu.w  #$e, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d5
    add.w   d5, d5
    addi.w  #$670, d5
    move.w  d4, d0
    lsl.w   #$6, d0
    movea.l  #$00051942,a0
    pea     (a0, d0.w)
    pea     ($0001).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$D7BE                           ; jsr $01D7BE
    lea     $10(a7), a7
    cmpi.b  #$f0, (a2)
    bcc.b   l_072fc
    moveq   #$0,d4
    move.b  (a2), d4
    bra.b   l_07302
l_072fc:
    move.l  #$f0, d4
l_07302:
    cmpi.b  #$9f, $1(a2)
    bcc.b   l_07312
    moveq   #$0,d6
    move.b  $1(a2), d6
    bra.b   l_07318
l_07312:
    move.l  #$9f, d6
l_07318:
    cmpi.w  #$6, d3
    bgt.b   l_0733c
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bra.b   l_0735c
l_0733c:
    cmpi.w  #$7, d3
    bne.b   l_0737a
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($003F).w
l_0735c:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
l_0737a:
    addq.w  #$1, d3
l_0737c:
    addq.w  #$1, d2
l_0737e:
    cmpi.w  #$7, d2
    blt.w   l_0725e
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts


; ============================================================================
; SetHighNibble -- (TODO: describe)
; Called: ?? times.
; 22 bytes | $007390-$0073A5
; ============================================================================
SetHighNibble:                                                  ; $007390
    movea.l $0004(sp),a0
    andi.b  #$0f,$0002(a0)
    move.b  $000b(sp),d0
    lsl.b   #$04,d0
    or.b    d0,$0002(a0)
    rts
; ============================================================================
; UpdateCharField -- (TODO: describe)
; Called: 8 times.
; 92 bytes | $0073A6-$007401
; ============================================================================
UpdateCharField:                                                  ; $0073A6
    movem.l d2/a2,-(sp)
    move.l  $0010(sp),d2
    movea.l $000c(sp),a2
    andi.b  #$f0,$0002(a2)
    move.b  d2,d0
    or.b    d0,$0002(a2)
    move.l  a2,-(sp)
    dc.w    $4eba,$0050                                 ; jsr $007412
    nop
    addq.l  #$4,sp
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.b  d0,$000b(a2)
    move.b  $0003(a2),d0
    cmp.b   $000b(a2),d0
    bcc.b   .l73f2
    moveq   #$0,d0
    move.b  $0003(a2),d0
    bra.b   .l73f8
.l73f2:                                                 ; $0073F2
    moveq   #$0,d0
    move.b  $000b(a2),d0
.l73f8:                                                 ; $0073F8
    move.b  d0,$0003(a2)
    movem.l (sp)+,d2/a2
    rts
; === GetLowNibble ($007402, 16B) ===
GetLowNibble:                                                         ; $007402
    MOVEA.L $4(SP),A0
    MOVE.B  $2(A0),D1
    ANDI.W  #$000F,D1
    MOVE.W  D1,D0
    RTS
; ============================================================================
; CalcCompatScore -- (TODO: describe)
; Called: 8 times.
; 206 bytes | $007412-$0074DF
; ============================================================================
CalcCompatScore:                                                  ; $007412
    movem.l d2-d3/a2,-(sp)
    movea.l $0010(sp),a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $6100,$fb18                                 ; bsr.w $006F42
    move.w  d0,d2
    cmpi.w  #$3200,d2
    bls.b   .l7438
    moveq   #$1e,d3
    bra.b   .l7466
.l7438:                                                 ; $007438
    cmpi.w  #$1900,d2
    bls.b   .l7442
    moveq   #$23,d3
    bra.b   .l7466
.l7442:                                                 ; $007442
    cmpi.w  #$0c80,d2
    bls.b   .l744c
    moveq   #$32,d3
    bra.b   .l7466
.l744c:                                                 ; $00744C
    cmpi.w  #$0640,d2
    bls.b   .l7456
    moveq   #$64,d3
    bra.b   .l7466
.l7456:                                                 ; $007456
    cmpi.w  #$0320,d2
    bls.b   .l7462
    move.w  #$96,d3
    bra.b   .l7466
.l7462:                                                 ; $007462
    move.w  #$c8,d3
.l7466:                                                 ; $007466
    move.l  a2,-(sp)
    dc.w    $4eba,$0076                                 ; jsr $0074E0
    nop
    lea     $000c(sp),sp
    movea.l #$00ff1278,a0
    move.b  (a0,d0.w),d2
    andi.l  #$ff,d2
    cmpi.w  #$3,d2
    bcc.b   .l7492
    move.w  d3,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$3,d0
    bra.b   .l74be
.l7492:                                                 ; $007492
    cmpi.w  #$18,d2
    beq.b   .l74b6
    cmpi.w  #$19,d2
    beq.b   .l74b6
    cmpi.w  #$2f,d2
    beq.b   .l74b6
    cmpi.w  #$32,d2
    beq.b   .l74b6
    cmpi.w  #$33,d2
    beq.b   .l74b6
    cmpi.w  #$34,d2
    bne.b   .l74ca
.l74b6:                                                 ; $0074B6
    move.w  d3,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$4,d0
.l74be:                                                 ; $0074BE
    sub.l   d1,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
.l74ca:                                                 ; $0074CA
    cmpi.w  #$1e,d3
    ble.b   .l74d6
    move.w  d3,d0
    ext.l   d0
    bra.b   .l74d8
.l74d6:                                                 ; $0074D6
    moveq   #$1e,d0
.l74d8:                                                 ; $0074D8
    move.w  d0,d3
    movem.l (sp)+,d2-d3/a2
    rts
; ---------------------------------------------------------------------------
; GetByteField4 -- Extract high nibble from byte[2] of structure
; Args: $4(SP) = pointer to structure
; Returns: D0 = high nibble (bits 7-4) of byte at offset 2
; Called 36 times
; ---------------------------------------------------------------------------
GetByteField4:                                                 ; $0074E0
    MOVEA.L $4(SP),A0                                          ; load structure pointer
    MOVE.B  $2(A0),D1                                          ; get byte at offset 2
    ANDI.L  #$000000FF,D1                                      ; mask to unsigned byte
    ASR.L   #4,D1                                              ; shift right 4 (high nibble)
    ANDI.W  #$000F,D1                                          ; mask to 4 bits
    MOVE.W  D1,D0                                              ; return in D0
    RTS
; ============================================================================
; CountMatchingChars -- (TODO: describe)
; Called: ?? times.
; 166 bytes | $0074F8-$00759D
; ============================================================================
CountMatchingChars:                                                  ; $0074F8
    movem.l d2-d5/a2-a3,-(sp)
    move.l  $001c(sp),d3
    move.l  $0020(sp),d4
    clr.w   d2
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $6100,$f9c8                                 ; bsr.w $006EEA
    lea     $000c(sp),sp
    move.w  d0,d5
    cmpi.w  #$ff,d5
    bne.b   .l7534
    clr.w   d2
    bra.b   .l7596
.l7534:                                                 ; $007534
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0004(a3),d0
    mulu.w  #$14,d0
    move.w  d3,d1
    mulu.w  #$0320,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d3
    bra.b   .l758c
.l7568:                                                 ; $007568
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d4,d0
    bne.b   .l7574
.l7570:                                                 ; $007570
    addq.w  #$1,d2
    bra.b   .l7586
.l7574:                                                 ; $007574
    moveq   #$0,d0
    move.b  $0001(a2),d0
    cmp.w   d4,d0
    beq.b   .l7570
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d5,d0
    bhi.b   .l7596
.l7586:                                                 ; $007586
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
.l758c:                                                 ; $00758C
    moveq   #$0,d0
    move.b  $0005(a3),d0
    cmp.w   d3,d0
    bhi.b   .l7568
.l7596:                                                 ; $007596
    move.w  d2,d0
    movem.l (sp)+,d2-d5/a2-a3
    rts
; ============================================================================
; FindCharSlot -- (TODO: describe)
; Called: ?? times.
; 114 bytes | $00759E-$00760F
; ============================================================================
FindCharSlot:                                                  ; $00759E
    movem.l d2-d6/a2,-(sp)
    move.l  $001c(sp),d2
    move.l  $0020(sp),d4
    clr.w   d5
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d3
    move.b  $0004(a1),d3
    move.w  d3,d6
    move.w  d2,d0
    mulu.w  #$0320,d0
    move.w  d6,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l75f8
.l75e4:                                                 ; $0075E4
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d4,d0
    bne.b   .l75f0
    moveq   #$1,d5
    bra.b   .l7602
.l75f0:                                                 ; $0075F0
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
    addq.w  #$1,d2
.l75f8:                                                 ; $0075F8
    moveq   #$0,d0
    move.b  $0005(a1),d0
    cmp.w   d2,d0
    bhi.b   .l75e4
.l7602:                                                 ; $007602
    tst.w   d5
    bne.b   .l7608
    moveq   #-$1,d3
.l7608:                                                 ; $007608
    move.w  d3,d0
    movem.l (sp)+,d2-d6/a2
    rts
; ============================================================================
; CalcTypeDistance -- (TODO: describe)
; Called: 10 times.
; 140 bytes | $007610-$00769B
; ============================================================================
CalcTypeDistance:                                                  ; $007610
    movem.l d2-d3,-(sp)
    move.w  $000e(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    move.b  (a0,d0.w),d2
    andi.l  #$ff,d2
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    move.b  (a0,d0.w),d1
    andi.l  #$ff,d1
    cmp.w   d1,d2
    bne.b   .l7648
    clr.w   d2
    bra.b   .l7694
.l7648:                                                 ; $007648
    movea.l #$00ff99a4,a0
    move.b  (a0,d2.w),d3
    andi.l  #$ff,d3
    movea.l #$00ff99a4,a0
    move.b  (a0,d1.w),d2
    andi.l  #$ff,d2
    cmpi.w  #$4,d3
    beq.b   .l7692
    cmpi.w  #$4,d2
    beq.b   .l7692
    move.w  d3,d0
    sub.w   d2,d0
    move.w  d0,d2
    tst.w   d2
    bge.b   .l7682
    neg.w   d2
    bra.b   .l7694
.l7682:                                                 ; $007682
    tst.w   d2
    bne.b   .l7694
    cmpi.w  #$1,d3
    beq.b   .l7692
    cmpi.w  #$2,d3
    bne.b   .l7694
.l7692:                                                 ; $007692
    moveq   #$1,d2
.l7694:                                                 ; $007694
    move.w  d2,d0
    movem.l (sp)+,d2-d3
    rts
CalcCharRating:                                                  ; $00769C
    link    a6,#-$4
    movem.l d2-d6,-(sp)
    move.l  $000c(a6),d2
    move.l  $0008(a6),d4
    clr.w   d3
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$26d6                                 ; jsr $009D92
    nop
    move.w  d0,d6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    lea     $0014(sp),sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    beq.b   .l7708
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$002a                                 ; jsr $007728
    nop
    cmpi.w  #$1,d0
    bne.b   .l770a
.l7708:                                                 ; $007708
    moveq   #$1,d3
.l770a:                                                 ; $00770A
    move.w  d6,d2
    mulu.w  #$19,d2
    move.w  d3,d0
    mulu.w  #$19,d0
    sub.w   d0,d2
    addi.w  #$32,d2
    move.w  d2,d0
    movem.l -$0018(a6),d2-d6
    unlk    a6
    rts
; ============================================================================
; FindSlotByChar -- (TODO: describe)
; Called: ?? times.
; 92 bytes | $007728-$007783
; ============================================================================
FindSlotByChar:                                                  ; $007728
    movem.l d2-d4,-(sp)
    move.l  $0014(sp),d2
    move.l  $0010(sp),d4
    cmpi.w  #$20,d2
    bcc.b   .l7750
    move.w  d2,d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$6,d3
    bra.b   .l7762
.l7750:                                                 ; $007750
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$4,d3
.l7762:                                                 ; $007762
    clr.w   d1
    clr.w   d2
    bra.b   .l7778
.l7768:                                                 ; $007768
    moveq   #$0,d0
    move.b  (a1),d0
    cmp.w   d4,d0
    bne.b   .l7774
    moveq   #$1,d1
    bra.b   .l777c
.l7774:                                                 ; $007774
    addq.l  #$1,a1
    addq.w  #$1,d2
.l7778:                                                 ; $007778
    cmp.w   d3,d2
    bcs.b   .l7768
.l777c:                                                 ; $00777C
    move.w  d1,d0
    movem.l (sp)+,d2-d4
    rts
; ============================================================================
; SelectPreviewPage -- (TODO: describe)
; Called: ?? times.
; 398 bytes | $007784-$007911
; ============================================================================
SelectPreviewPage:                                                  ; $007784
    link    a6,#-$c
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    movea.l #$0004745c,a2
    movea.l #$0001d568,a3
    movea.l #$0d64,a4
    moveq   #$1,d3
    move.w  #$0754,d5
    clr.w   d2
    moveq   #$0,d4
    move.w  d5,d4
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d4
.l77b8:                                                 ; $0077B8
    move.w  d2,d0
    add.w   d0,d0
    move.w  d4,-$c(a6,d0.w)
    addq.l  #$1,d4
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .l77b8
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     -$000c(a6)
    pea     ($0001).w
    pea     ($0006).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)
    lea     $0030(sp),sp
.l7800:                                                 ; $007800
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    andi.w  #$0fff,d0
    bne.b   .l7800
.l7810:                                                 ; $007810
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
    addq.l  #$8,sp
    move.w  d0,d2
    andi.l  #$3c,d0
    beq.b   .l7810
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8,sp
    move.w  d2,d0
    andi.w  #$c,d0
    beq.b   .l788a
    move.w  d2,d0
    andi.w  #$4,d0
    beq.b   .l7866
    cmpi.w  #$1,d3
    beq.b   .l7862
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    lea     $0014(sp),sp
.l7862:                                                 ; $007862
    moveq   #$1,d3
    bra.b   .l788a
.l7866:                                                 ; $007866
    tst.w   d3
    beq.b   .l7888
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$c0,d0
    move.l  d0,-(sp)
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    lea     $0014(sp),sp
.l7888:                                                 ; $007888
    clr.w   d3
.l788a:                                                 ; $00788A
    move.w  d2,d0
    andi.w  #$30,d0
    beq.w   .l7810
    cmpi.w  #$1,d3
    bne.b   .l78a6
    move.w  d2,d0
    andi.w  #$20,d0
    beq.b   .l78a6
    moveq   #$1,d3
    bra.b   .l78b0
.l78a6:                                                 ; $0078A6
    move.w  d2,d0
    andi.w  #$10,d0
    beq.b   .l78b0
    clr.w   d3
.l78b0:                                                 ; $0078B0
    cmpi.w  #$1,d3
    bne.b   .l78be
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    bra.b   .l78cc
.l78be:                                                 ; $0078BE
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$c0,d0
    move.l  d0,-(sp)
.l78cc:                                                 ; $0078CC
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $001c(sp),sp
    pea     ($02EC).w
    pea     ($0001).w
    pea     ($0006).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    move.w  d3,d0
    movem.l -$0030(a6),d2-d7/a2-a4
    unlk    a6
    rts
; ============================================================================
; ShowDialog -- Display dialog with table lookup and optional input (38 calls)
; No link frame. Args via sp: d2=index, a2=data ptr, d6=row, d5=flag1, d4=flag2
; Returns result in d0 (from $7784 if flag1, else d3 default).
; ============================================================================
ShowDialog:                                                  ; $007912
    movem.l d2-d6/a2,-(sp)
    move.l  $001C(sp),d2                                     ; arg1: index
    move.l  $002C(sp),d4                                     ; arg5: flag2
    move.l  $0028(sp),d5                                     ; arg4: flag1
    move.l  $0024(sp),d6                                     ; arg3: row
    movea.l $0020(sp),a2                                     ; arg2: data pointer
    pea     ($0020).w                                        ; width = 32
    pea     ($0020).w                                        ; height = 32
    clr.l   -(sp)                                            ; left = 0
    clr.l   -(sp)                                            ; top = 0
    dc.w    $4EB9,$0003,$A942                                ; jsr SetTextWindow
    move.l  a2,-(sp)                                         ; data pointer
    pea     ($0001).w
    pea     ($0001).w
    move.w  d6,d0
    move.l  d0,-(sp)                                         ; row (extended)
    move.w  d2,d0
    move.l  d0,-(sp)                                         ; index (extended)
    pea     ($0002).w
    pea     ($0780).w
    move.w  d2,d0
    mulu.w  #$000A,d0                                        ; index * 10
    movea.l #$00FF03C0,a0                                    ; lookup table base
    move.w  (a0,d0.w),d1                                     ; table[index*10]
    move.l  d1,-(sp)
    dc.w    $4EB9,$0000,$643C                                ; jsr $643C (display fn)
    lea     $30(sp),sp                                       ; clean 48 bytes
    cmpi.w  #$0001,d5                                        ; flag1 == 1?
    bne.s   .check_f2                                        ; no, check flag2
    pea     ($001A).w
    pea     ($0008).w
    dc.w    $6100,$FE02                                      ; bsr.w $007784 (input fn)
    addq.l  #8,sp                                            ; clean args
    move.w  d0,d3                                            ; d3 = result
    bra.s   .epilogue
.check_f2:                                                   ; $00798A
    cmpi.w  #$0001,d4                                        ; flag2 == 1?
    bne.s   .epilogue                                        ; no, skip
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                                ; jsr PollAction
    addq.l  #8,sp                                            ; clean args
.epilogue:                                                   ; $0079A0
    move.w  d3,d0                                            ; return value
    movem.l (sp)+,d2-d6/a2
    rts
; === Translated block $0079A8-$007A24 ===
; 1 functions, 124 bytes

; ============================================================================
; func_0079A8 -- (TODO: name)
; 124 bytes | $0079A8-$007A23
; ============================================================================
func_0079A8:
    movem.l d2-d6, -(a7)
    move.l  $20(a7), d2
    move.l  $1c(a7), d4
    move.l  $18(a7), d5
    clr.w   d3
    cmpi.w  #$20, d2
    bge.b   l_079da
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    bra.b   l_07a18
l_079da:
    cmpi.w  #$ff, d4
    bne.b   l_079f0
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d4
l_079f0:
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    mulu.w  #$e, d1
    move.w  d4, d6
    add.w   d6, d6
    add.w   d6, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
l_07a18:
    beq.b   l_07a1c
    moveq   #$1,d3
l_07a1c:
    move.w  d3, d0
    movem.l (a7)+, d2-d6
    rts

; ============================================================================
; CheckBitField -- (TODO: describe)
; Called: ?? times.
; 80 bytes | $007A24-$007A73
; ============================================================================
CheckBitField:                                                  ; $007A24
    movem.l d2-d5,-(sp)
    move.l  $0018(sp),d2
    move.l  $001c(sp),d4
    move.l  $0014(sp),d5
    clr.w   d3
    cmpi.w  #$ff,d2
    bne.b   .l7a4c
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d2
.l7a4c:                                                 ; $007A4C
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$0005ecdc,a0
    and.l   (a0,d1.w),d0
    beq.b   .l7a6c
    moveq   #$1,d3
.l7a6c:                                                 ; $007A6C
    move.w  d3,d0
    movem.l (sp)+,d2-d5
    rts
AdjustScrollPos:                                                  ; $007A74
    movem.l d2/a2,-(sp)
    move.l  $0010(sp),d2
    movea.l $000c(sp),a2
    move.w  d2,d0
    andi.w  #$f,d0
    beq.w   .l7b18
    move.w  d2,d0
    andi.w  #$1,d0
    beq.b   .l7ab0
    moveq   #$0,d0
    move.w  $0002(a2),d0
    subq.l  #$2,d0
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l7aaa
    moveq   #$0,d0
    move.w  $0002(a2),d0
    subq.l  #$2,d0
    bra.b   .l7aac
.l7aaa:                                                 ; $007AAA
    moveq   #$1,d0
.l7aac:                                                 ; $007AAC
    move.w  d0,$0002(a2)
.l7ab0:                                                 ; $007AB0
    move.w  d2,d0
    andi.w  #$2,d0
    beq.b   .l7adc
    moveq   #$0,d0
    move.w  $0002(a2),d0
    addq.l  #$2,d0
    cmpi.l  #$90,d0
    bge.b   .l7ad2
    moveq   #$0,d0
    move.w  $0002(a2),d0
    addq.l  #$2,d0
    bra.b   .l7ad8
.l7ad2:                                                 ; $007AD2
    move.l  #$90,d0
.l7ad8:                                                 ; $007AD8
    move.w  d0,$0002(a2)
.l7adc:                                                 ; $007ADC
    move.w  d2,d0
    andi.w  #$8,d0
    beq.b   .l7af8
    moveq   #$0,d0
    move.w  (a2),d0
    addq.l  #$2,d0
    move.l  #$0100,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,(a2)
.l7af8:                                                 ; $007AF8
    move.w  d2,d0
    andi.w  #$4,d0
    beq.b   .l7b18
    moveq   #$0,d0
    move.w  (a2),d0
    addi.l  #$fe,d0
    move.l  #$0100,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,(a2)
.l7b18:                                                 ; $007B18
    movem.l (sp)+,d2/a2
    rts
; ============================================================================
; HitTestMapTile -- (TODO: describe)
; Called: ?? times.
; 286 bytes | $007B1E-$007C3B
; ============================================================================
HitTestMapTile:                                                  ; $007B1E
    movem.l d2-d4/a2-a3,-(sp)
    movea.l $0018(sp),a1
    move.w  $001e(sp),d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  (a3),d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    move.w  $0002(a1),d4
    move.w  (a1),d3
    bra.b   .l7ba6
.l7b54:                                                 ; $007B54
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    blt.b   .l7ba2
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    blt.b   .l7ba2
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7ba2
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7ba2
    moveq   #$0,d0
    move.b  (a3),d0
.l7b9c:                                                 ; $007B9C
    add.w   d2,d0
    bra.w   .l7c36
.l7ba2:                                                 ; $007BA2
    addq.l  #$2,a2
    addq.w  #$1,d2
.l7ba6:                                                 ; $007BA6
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    cmp.l   d1,d0
    blt.b   .l7b54
    moveq   #$0,d0
    move.b  $0002(a3),d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    move.w  $0002(a1),d4
    move.w  (a1),d3
    bra.b   .l7c24
.l7bd2:                                                 ; $007BD2
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    ble.b   .l7c20
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    ble.b   .l7c20
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7c20
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7c20
    moveq   #$0,d0
    move.b  $0002(a3),d0
    bra.w   .l7b9c
.l7c20:                                                 ; $007C20
    addq.l  #$2,a2
    addq.w  #$1,d2
.l7c24:                                                 ; $007C24
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    cmp.l   d1,d0
    blt.b   .l7bd2
    move.w  #$ff,d0
.l7c36:                                                 ; $007C36
    movem.l (sp)+,d2-d4/a2-a3
    rts
; ============================================================================
; ShowCharProfile -- (TODO: describe)
; Called: ?? times.
; 342 bytes | $007C3C-$007D91
; ============================================================================
ShowCharProfile:                                                  ; $007C3C
    link    a6,#$0
    movem.l d2-d7/a2,-(sp)
    move.l  $0018(a6),d3
    move.l  $0014(a6),d4
    move.l  $001c(a6),d5
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    movea.l #$0004978c,a2
    cmpi.w  #$1,d3
    bne.b   .l7cca
    moveq   #$1,d2
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  a2,d0
    moveq   #$22,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0028(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$027a,d0
    move.l  d0,-(sp)
    pea     ($0009).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0014(sp),sp
.l7cca:                                                 ; $007CCA
    cmpi.w  #$1,d3
    bne.b   .l7cee
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l7d06
.l7cee:                                                 ; $007CEE
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
.l7d06:                                                 ; $007D06
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a5a8                           ; jsr $03A5A8
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0028(sp),sp
    cmpi.w  #$1,d3
    bne.b   .l7d50
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addi.l  #$f,d0
    bra.b   .l7d6c
.l7d50:                                                 ; $007D50
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addi.l  #$e,d0
.l7d6c:                                                 ; $007D6C
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$000e                                 ; jsr $007D92
    nop
    movem.l -$001c(a6),d2-d7/a2
    unlk    a6
    rts
; ============================================================================
; ShowCharDetail -- (TODO: describe)
; Called: ?? times.
; 644 bytes | $007D92-$008015
; ============================================================================
ShowCharDetail:                                                  ; $007D92
    link    a6,#-$80
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0018(a6),d2
    move.l  $0014(a6),d3
    move.l  $0020(a6),d4
    move.l  $000c(a6),d5
    move.l  $001c(a6),d6
    move.l  $0008(a6),d7
    lea     -$0080(a6),a4
    movea.l #$0003b270,a5
    move.w  d5,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d7,d0
    lsl.w   #$5,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $000c(sp),sp
    cmpi.w  #$1,d6
    bne.b   .l7e50
    move.l  ($000A1AE8).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0037).w
    pea     ($06B4).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($00070F78).l
    pea     ($0008).w
    pea     ($000E).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
.l7e50:                                                 ; $007E50
    pea     ($0008).w
    pea     ($000F).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  $0002(a2),d0
    move.l  d0,-(sp)
    pea     ($0003E1A2).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$9,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    move.l  d0,-(sp)
    pea     ($0003E19E).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0008(a2),d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    pea     ($0003E19A).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0009(a2),d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    pea     ($0003E196).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    lea     $0010(sp),sp
    cmpi.w  #$1,d6
    bne.b   .l7fca
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a3),d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003E192).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    cmpi.w  #$2,d4
    move.l  a4,-(sp)
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
    moveq   #$0,d0
    move.b  $0001(a3),d0
    move.l  d0,-(sp)
    pea     ($0003E18E).l
    bra.b   .l8000
.l7fca:                                                 ; $007FCA
    move.w  d2,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    addq.l  #$8,sp
    move.w  d5,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$002a                                 ; jsr $008016
    nop
    addq.l  #$8,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($0003E188).l
.l8000:                                                 ; $008000
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    move.l  a4,-(sp)
    jsr     (a5)
    movem.l -$00a8(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ============================================================================
; CalcWeightedStat -- (TODO: describe)
; Called: 8 times.
; 180 bytes | $008016-$0080C9
; ============================================================================
CalcWeightedStat:                                                  ; $008016
    movem.l d2-d4/a2,-(sp)
    move.l  $0018(sp),d3
    move.l  $0014(sp),d4
    moveq   #$64,d2
    move.w  d3,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a2),d0
    movea.l #$0005f07c,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1d3c                                 ; jsr $009D92
    nop
    addq.l  #$8,sp
    move.w  d0,d3
    cmpi.w  #$3,d3
    bne.b   .l806a
    move.w  #$ffff,d4
    bra.b   .l80c2
.l806a:                                                 ; $00806A
    tst.w   d3
    bne.b   .l8072
    moveq   #$5a,d2
    bra.b   .l8084
.l8072:                                                 ; $008072
    cmpi.w  #$1,d3
    bne.b   .l807c
    moveq   #$64,d2
    bra.b   .l8084
.l807c:                                                 ; $00807C
    cmpi.w  #$2,d3
    bne.b   .l8084
    moveq   #$6e,d2
.l8084:                                                 ; $008084
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0032                                 ; jsr $0080CA
    nop
    addq.l  #$8,sp
    cmpi.w  #$1,d0
    bne.b   .l80a8
    subi.w  #$a,d2
.l80a8:                                                 ; $0080A8
    moveq   #$0,d0
    move.w  $0004(a2),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d4
.l80c2:                                                 ; $0080C2
    move.w  d4,d0
    movem.l (sp)+,d2-d4/a2
    rts
    dc.w    $48E7,$3C30,$2A2F                                ; $0080CA
; === Translated block $0080D0-$00814A ===
; 1 functions, 122 bytes

; ============================================================================
; func_0080D0 -- (TODO: name)
; 122 bytes | $0080D0-$008149
; ============================================================================
func_0080D0:
    dc.w    $0020,$4243                     ; ori.b #$43,-(a0) - high byte $42 is compiler junk
    clr.w   d4
    movea.l  #$00FFA6B8,a3
    move.w  $1e(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_080f0:
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_08108
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d4
l_08108:
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   l_080f0
    tst.w   d3
    beq.b   l_08134
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    bra.b   l_08136
l_08134:
    clr.w   d2
l_08136:
    cmpi.w  #$32, d2
    bcs.b   l_08140
    moveq   #$1,d5
    bra.b   l_08142
l_08140:
    clr.w   d5
l_08142:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; ClearBothPlanes -- Clear both scroll planes via GameCommand #$1A
; Called: 15 times.
; 64 bytes | $00814A-$008189
; ============================================================================
ClearBothPlanes:                                                  ; $00814A
    clr.l   -(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    clr.l   -(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
; ============================================================================
; CheckCharCompat -- (TODO: describe)
; Called: ?? times.
; 72 bytes | $00818A-$0081D1
; ============================================================================
CheckCharCompat:                                                  ; $00818A
    movem.l d2-d5/a2,-(sp)
    move.l  $0020(sp),d3
    move.l  $001c(sp),d4
    move.l  $0018(sp),d5
    clr.w   d2
    move.w  d5,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
    cmp.w   $0002(a2),d0
    bhi.b   .l81ca
    moveq   #$1,d2
.l81ca:                                                 ; $0081CA
    move.w  d2,d0
    movem.l (sp)+,d2-d5/a2
    rts
; ============================================================================
; FindRelationRecord -- (TODO: describe)
; Called: ?? times.
; 274 bytes | $0081D2-$0082E3
; ============================================================================
FindRelationRecord:                                                  ; $0081D2
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $0018(sp),d2
    move.l  $0020(sp),d3
    move.l  $001c(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    addq.l  #$8,sp
    tst.w   d0
    bne.b   .l8272
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l8262
.l8222:                                                 ; $008222
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l823c
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l8256
.l823c:                                                 ; $00823C
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l825c
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l825c
.l8256:                                                 ; $008256
    move.l  a2,d0
    bra.w   .l82de
.l825c:                                                 ; $00825C
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l8262:                                                 ; $008262
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    blt.b   .l8222
    bra.b   .l82dc
.l8272:                                                 ; $008272
    moveq   #$0,d0
    move.b  $0004(a3),d0
    mulu.w  #$14,d0
    move.w  d2,d1
    mulu.w  #$0320,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l82ce
.l8294:                                                 ; $008294
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l82ae
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l8256
.l82ae:                                                 ; $0082AE
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l82c8
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l8256
.l82c8:                                                 ; $0082C8
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l82ce:                                                 ; $0082CE
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    cmp.l   d1,d0
    blt.b   .l8294
.l82dc:                                                 ; $0082DC
    moveq   #$0,d0
.l82de:                                                 ; $0082DE
    movem.l (sp)+,d2-d4/a2-a3
    rts
; ============================================================================
; sub_0082E4 -- (TODO: describe)
; Called: ?? times.
; 372 bytes | $0082E4-$008457
; ============================================================================
InsertRelationRecord:                                                  ; $0082E4
    movem.l d2-d3/a2-a5,-(sp)
    move.l  $001c(sp),d2
    movea.l $0020(sp),a2
    movea.l #$0001d538,a5
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$00ff08ec,a0
    and.l   (a0,d1.w),d0
    beq.b   .l834a
    move.b  (a2),d0
    cmp.b   $0001(a2),d0
    bls.b   .l834a
    moveq   #$0,d2
    move.b  $0001(a2),d2
    move.b  (a2),$0001(a2)
    move.b  d2,(a2)
.l834a:                                                 ; $00834A
    pea     ($0320).w
    pea     ($00FF1804).l
    clr.l   -(sp)
    move.l  a3,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    lea     $001c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l83a0
    moveq   #$0,d2
    move.b  $0004(a4),d2
    moveq   #$0,d0
    move.b  $0004(a4),d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    adda.l  d0,a3
    moveq   #$0,d3
    move.b  $0004(a4),d3
    moveq   #$0,d0
    move.b  $0005(a4),d0
    add.w   d0,d3
    bra.b   .l83a8
.l83a0:                                                 ; $0083A0
    clr.w   d2
    moveq   #$0,d3
    move.b  $0004(a4),d3
.l83a8:                                                 ; $0083A8
    addi.w  #$ffff,d3
    tst.w   d3
    ble.b   .l83f0
    bra.b   .l83e8
.l83b2:                                                 ; $0083B2
    move.b  (a2),d0
    cmp.b   (a3),d0
    bne.b   .l83d6
    move.b  $0001(a2),d0
    cmp.b   $0001(a3),d0
    bcc.b   .l83e2
.l83c2:                                                 ; $0083C2
    pea     ($0014).w
    move.l  a3,-(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    bra.b   .l83ec
.l83d6:                                                 ; $0083D6
    move.b  (a2),d0
    cmp.b   (a3),d0
    bcs.b   .l83c2
    cmpi.b  #$ff,(a3)
    beq.b   .l83c2
.l83e2:                                                 ; $0083E2
    moveq   #$14,d0
    adda.l  d0,a3
    addq.w  #$1,d2
.l83e8:                                                 ; $0083E8
    cmp.w   d3,d2
    blt.b   .l83b2
.l83ec:                                                 ; $0083EC
    cmp.w   d3,d2
    bne.b   .l8402
.l83f0:                                                 ; $0083F0
    pea     ($0014).w
    move.l  a3,-(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
.l8402:                                                 ; $008402
    move.w  d2,d0
    ext.l   d0
    moveq   #$28,d1
    sub.l   d0,d1
    subq.l  #$1,d1
    ble.b   .l8452
    move.w  d2,d0
    ext.l   d0
    moveq   #$28,d1
    sub.l   d0,d1
    move.l  d1,d0
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    subi.l  #$14,d0
    move.l  d0,-(sp)
    move.l  a3,d0
    moveq   #$14,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    lsr.l   #$1,d0
    add.w   d0,d0
    movea.l #$00ff1804,a0
    pea     (a0,d0.w)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
.l8452:                                                 ; $008452
    movem.l (sp)+,d2-d3/a2-a5
    rts
; ============================================================================
; CalcCharAdvantage -- (TODO: describe)
; Called: ?? times.
; 518 bytes | $008458-$00865D
; ============================================================================
CalcCharAdvantage:                                                  ; $008458
    link    a6,#-$4
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $000c(a6),d6
    move.l  $0008(a6),d7
    lea     -$0002(a6),a5
    move.w  d7,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    move.w  d6,d0
    add.w   d0,d0
    movea.l #$00ff8824,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d6,d0
    lsl.w   #$3,d0
    move.w  d7,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba80,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  (a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    sub.w   d1,d0
    move.w  d0,(a5)
    moveq   #$4,d3
    cmpi.w  #$20,d6
    bge.b   .l84e8
    move.w  d7,d0
    lsl.w   #$4,d0
    movea.l #$00ff0230,a0
    move.w  (a0,d0.w),d4
    clr.w   d2
.l84ca:                                                 ; $0084CA
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff0230,a0
    move.w  (a0,d0.w),d0
    cmp.w   d4,d0
    bcc.b   .l84de
    subq.w  #$1,d3
.l84de:                                                 ; $0084DE
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.b   .l84ca
    bra.b   .l8530
.l84e8:                                                 ; $0084E8
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d5
    move.w  d7,d0
    lsl.w   #$4,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ff0232,a0
    move.w  (a0,d0.w),d4
    clr.w   d2
.l850e:                                                 ; $00850E
    move.w  d2,d0
    lsl.w   #$4,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ff0232,a0
    move.w  (a0,d0.w),d0
    cmp.w   d4,d0
    bcc.b   .l8528
    subq.w  #$1,d3
.l8528:                                                 ; $008528
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.b   .l850e
.l8530:                                                 ; $008530
    moveq   #$0,d0
    move.b  $0001(a4),d0
    move.w  d6,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l8542
    moveq   #$e,d2
    bra.b   .l854e
.l8542:                                                 ; $008542
    move.w  d3,d0
    mulu.w  #$3,d0
    moveq   #$e,d2
    sub.w   d0,d2
    addq.w  #$3,d2
.l854e:                                                 ; $00854E
    moveq   #$0,d0
    move.w  (a5),d0
    add.l   d0,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    ble.b   .l856a
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l8578
.l856a:                                                 ; $00856A
    moveq   #$0,d0
    move.w  (a5),d0
    add.l   d0,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l8578:                                                 ; $008578
    move.w  d0,d2
    cmpi.w  #$1,d2
    bls.b   .l8586
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l8588
.l8586:                                                 ; $008586
    moveq   #$1,d0
.l8588:                                                 ; $008588
    move.w  d0,d2
    cmpi.w  #$20,d6
    bge.b   .l85f0
    moveq   #$0,d0
    move.b  $0001(a4),d0
    cmp.w   d6,d0
    bne.b   .l85b4
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
.l85aa:                                                 ; $0085AA
    bge.b   .l85ae
    addq.l  #$3,d0
.l85ae:                                                 ; $0085AE
    asr.l   #$2,d0
.l85b0:                                                 ; $0085B0
    move.w  d0,d6
    bra.b   .l85f2
.l85b4:                                                 ; $0085B4
    move.w  d6,d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d7,d1
    lsl.w   #$2,d1
    movea.l #$00ff08ec,a0
    and.l   (a0,d1.w),d0
    beq.b   .l85e2
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    tst.l   d0
    bge.b   .l85de
    addq.l  #$1,d0
.l85de:                                                 ; $0085DE
    asr.l   #$1,d0
    bra.b   .l85b0
.l85e2:                                                 ; $0085E2
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    tst.l   d0
    bra.b   .l85aa
.l85f0:                                                 ; $0085F0
    moveq   #$e,d6
.l85f2:                                                 ; $0085F2
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    cmp.l   d1,d0
    ble.b   .l8650
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    andi.l  #$ffff,d1
    sub.l   d1,d0
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    ble.b   .l861c
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l862c
.l861c:                                                 ; $00861C
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    andi.l  #$ffff,d1
    sub.l   d1,d0
.l862c:                                                 ; $00862C
    move.w  d0,d2
    cmpi.w  #$e,d2
    bcc.b   .l863a
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l863c
.l863a:                                                 ; $00863A
    moveq   #$e,d0
.l863c:                                                 ; $00863C
    move.w  d0,d2
    cmp.w   (a5),d2
    bcc.b   .l8648
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l864c
.l8648:                                                 ; $008648
    moveq   #$0,d0
    move.w  (a5),d0
.l864c:                                                 ; $00864C
    move.w  d0,d2
    bra.b   .l8652
.l8650:                                                 ; $008650
    clr.w   d2
.l8652:                                                 ; $008652
    move.w  d2,d0
    movem.l -$002c(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ============================================================================
; CalcNegotiationPower -- (TODO: describe)
; Called: ?? times.
; 476 bytes | $00865E-$008839
; ============================================================================
CalcNegotiationPower:                                                  ; $00865E
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0030(sp),d4
    move.l  $002c(sp),d5
    movea.l #$00ffbd4c,a4
    movea.l #$00ff0002,a5
    moveq   #$a,d6
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  (a4),d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0002(a2),d0
    ext.l   d0
    move.w  (a4),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$5a,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.w  #$a,d0
    move.w  d0,d3
    moveq   #$0,d0
    move.b  $0001(a3),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$50,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.w  d0,d7
    move.w  (a4),d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0002(a3),d0
    ext.l   d0
    move.w  (a4),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0003(a2),d0
    andi.l  #$ffff,d0
    moveq   #$5a,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.w  #$a,d0
    move.w  d0,d3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$50,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.w  d0,d2
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  d2,d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d6,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7610                           ; jsr $007610
    addq.l  #$8,sp
    move.w  d0,d3
    cmpi.w  #$3,d3
    bne.b   .l87d4
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l87ce
    addq.l  #$3,d0
.l87ce:                                                 ; $0087CE
    asr.l   #$2,d0
.l87d0:                                                 ; $0087D0
    move.w  d0,d2
    bra.b   .l87fa
.l87d4:                                                 ; $0087D4
    cmpi.w  #$2,d3
    bne.b   .l87e6
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l87e2
    addq.l  #$1,d0
.l87e2:                                                 ; $0087E2
    asr.l   #$1,d0
    bra.b   .l87d0
.l87e6:                                                 ; $0087E6
    cmpi.w  #$1,d3
    bne.b   .l87fa
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$5,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    sub.w   d0,d2
.l87fa:                                                 ; $0087FA
    tst.w   (a5)
    bne.b   .l880c
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l8806
    addq.l  #$1,d0
.l8806:                                                 ; $008806
    asr.l   #$1,d0
.l8808:                                                 ; $008808
    add.w   d0,d2
    bra.b   .l8832
.l880c:                                                 ; $00880C
    cmpi.w  #$1,(a5)
    bne.b   .l881e
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l881a
    addq.l  #$3,d0
.l881a:                                                 ; $00881A
    asr.l   #$2,d0
    bra.b   .l8808
.l881e:                                                 ; $00881E
    cmpi.w  #$3,(a5)
    bne.b   .l8832
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    sub.w   d0,d2
.l8832:                                                 ; $008832
    move.w  d2,d0
    movem.l (sp)+,d2-d7/a2-a5
    rts
; ============================================================================
; PlaceCharSprite -- (TODO: describe)
; Called: ?? times.
; 176 bytes | $00883A-$0088E9
; ============================================================================
PlaceCharSprite:                                                  ; $00883A
    link    a6,#-$c0
    movem.l d2-d3/a2,-(sp)
    move.l  $0018(a6),d3
    move.w  $000a(a6),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a2),d0
    movea.l #$0005ec4a,a0
    move.b  (a0,d0.w),d2
    andi.l  #$ff,d2
    cmpi.w  #$ff,d2
    beq.b   .l88e0
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$00095a22,a0
    move.l  (a0,d0.l),-(sp)
    pea     -$00c0(a6)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0006).w
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     -$00c0(a6)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    lea     $0030(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
.l88e0:                                                 ; $0088E0
    movem.l -$00cc(a6),d2-d3/a2
    unlk    a6
    rts
; ============================================================================
; DrawStatDisplay -- Draw statistic bar display with text labels
; Called: 11 times.
; 352 bytes | $0088EA-$008A49
; ============================================================================
DrawStatDisplay:                                                  ; $0088EA
    link    a6,#$0
    movem.l d2-d6/a2,-(sp)
    move.l  $0014(a6),d2
    move.l  $0010(a6),d3
    move.l  $0008(a6),d4
    movea.l #$0d64,a2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
    cmpi.w  #$ff,d4
    bne.w   .l89a6
    pea     ($077E).w
    pea     ($0002).w
    pea     ($0003).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0012).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    tst.w   d3
    bne.b   .l896e
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
.l895e:                                                 ; $00895E
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    bra.w   .l8a40
.l896e:                                                 ; $00896E
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0012).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    pea     ($077E).w
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0015).w
    pea     ($0002).w
    bra.b   .l895e
.l89a6:                                                 ; $0089A6
    tst.w   d3
    beq.b   .l89b2
    cmpi.w  #$1,d3
    bne.w   .l8a40
.l89b2:                                                 ; $0089B2
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000E).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d6
    ext.l   d6
    move.l  d6,d0
    lsl.l   #$3,d6
    sub.l   d0,d6
    add.l   d6,d6
    move.l  d6,d5
    addq.l  #$2,d6
    move.l  d6,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  d5,d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0024(sp),sp
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$0690,d0
    move.l  d0,-(sp)
    move.w  $001a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    move.l  d6,d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $6100,$fe16                                 ; bsr.w $00883A
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003E1A6).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
.l8a40:                                                 ; $008A40
    movem.l -$0018(a6),d2-d6/a2
    unlk    a6
    rts
; ============================================================================
; CharacterBrowser -- (TODO: describe)
; Called: ?? times.
; 962 bytes | $008A4A-$008E0B
; ============================================================================
CharacterBrowser:                                                  ; $008A4A
    link    a6,#-$8
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $000c(a6),d5
    movea.l #$0d64,a3
    lea     -$0004(a6),a4
    movea.l #$00ff1804,a5
    move.w  #$1,-$0006(a6)
    clr.w   d4
    moveq   #$1,d7
    clr.w   d3
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005f6d6,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
.l8a82:                                                 ; $008A82
    clr.w   d2
    movea.w d2,a0
    move.b  (a2,a0.w),d0
    cmp.b   d5,d0
    beq.b   .l8aa0
    moveq   #$1,d2
    movea.w d2,a0
    move.b  (a2,a0.w),d0
    cmp.b   d5,d0
    beq.b   .l8aa0
    addq.l  #$2,a2
    addq.w  #$1,d3
    bra.b   .l8a82
.l8aa0:                                                 ; $008AA0
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($0004DFB8).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($0010).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767BE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  ($0009513C).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0060).w
    pea     ($0640).w
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0030(sp),sp
    pea     ($00070E58).l
    pea     ($0008).w
    pea     ($000C).w
    pea     ($0005).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    move.w  d5,d6
    pea     ($0003E1AA).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0024(sp),sp
    tst.w   d0
    beq.b   .l8bb6
    moveq   #$1,d0
    bra.b   .l8bb8
.l8bb6:                                                 ; $008BB6
    moveq   #$0,d0
.l8bb8:                                                 ; $008BB8
    move.w  d0,-$0002(a6)
    clr.w   (a4)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l8bca:                                                 ; $008BCA
    cmpi.w  #$1,d7
    bne.b   .l8c00
    move.w  -$0006(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000E).w
    pea     ($000C).w
    dc.w    $4eba,$13a0                                 ; jsr $009F88
    nop
    clr.w   -$0006(a6)
    clr.w   d7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0018(sp),sp
.l8c00:                                                 ; $008C00
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    cmpi.w  #$1,d4
    bne.b   .l8c2e
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767BE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    clr.w   d4
    bra.b   .l8c50
.l8c2e:                                                 ; $008C2E
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    addi.l  #$28,d0
    move.l  d0,-(sp)
    pea     ($000767DC).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    moveq   #$1,d4
.l8c50:                                                 ; $008C50
    tst.w   -$0002(a6)
    beq.b   .l8c74
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l8c74
    pea     ($0003).w
.l8c68:                                                 ; $008C68
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    bra.w   .l8bca
.l8c74:                                                 ; $008C74
    clr.w   -$0002(a6)
    move.w  -$0004(a6),d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$3f,d0
    move.w  d0,(a4)
    andi.w  #$30,d0
    beq.b   .l8ca4
    move.w  (a4),d0
    andi.w  #$10,d0
    beq.b   .l8cfc
    move.w  #$ff,d6
    bra.b   .l8cfc
.l8ca4:                                                 ; $008CA4
    move.w  (a4),d0
    andi.w  #$f,d0
    beq.b   .l8cf4
    move.w  (a4),d0
    andi.w  #$8,d0
    beq.b   .l8cba
    addq.w  #$1,d3
    andi.w  #$3,d3
.l8cba:                                                 ; $008CBA
    move.w  (a4),d0
    andi.w  #$4,d0
    beq.b   .l8cc8
    addq.w  #$3,d3
    andi.w  #$3,d3
.l8cc8:                                                 ; $008CC8
    move.w  (a4),d0
    andi.w  #$1,d0
    beq.b   .l8cd2
    clr.w   d2
.l8cd2:                                                 ; $008CD2
    move.w  (a4),d0
    andi.w  #$2,d0
    beq.b   .l8cdc
    moveq   #$1,d2
.l8cdc:                                                 ; $008CDC
    move.w  d3,d0
    add.w   d0,d0
    add.w   d2,d0
    movea.l #$0005f6d6,a0
    move.b  (a0,d0.w),d6
    andi.l  #$ff,d6
    moveq   #$1,d7
.l8cf4:                                                 ; $008CF4
    pea     ($0002).w
    bra.w   .l8c68
.l8cfc:                                                 ; $008CFC
    move.l  #$8000,-(sp)
    pea     ($0010).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    cmpi.w  #$ff,d6
    beq.w   .l8dde
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    pea     ($0010).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d6,d5
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$11ec                                 ; jsr $009F4A
    nop
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    lea     $002c(sp),sp
    pea     ($0002).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $0028(sp),sp
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    bra.b   .l8dfa
.l8dde:                                                 ; $008DDE
    pea     ($0002).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $000c(sp),sp
.l8dfa:                                                 ; $008DFA
    pea     ($0018).w
    jsr     (a3)
    move.w  d5,d0
    movem.l -$0030(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ============================================================================
; BrowseCharList -- (TODO: describe)
; Called: ?? times.
; 744 bytes | $008E0C-$0090F3
; ============================================================================
BrowseCharList:                                                  ; $008E0C
    link    a6,#$0
    movem.l d2-d6/a2-a5,-(sp)
    movea.l $000c(a6),a3
    movea.l #$0d64,a4
    movea.l #$00ff13fc,a5
    move.w  #$ff,d4
    movea.l #$00ffbd64,a2
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    tst.w   d0
    beq.b   .l8e3e
    moveq   #$1,d2
    bra.b   .l8e40
.l8e3e:                                                 ; $008E3E
    moveq   #$0,d2
.l8e40:                                                 ; $008E40
    clr.w   d5
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $6100,$ecca                                 ; bsr.w $007B1E
    lea     $000c(sp),sp
    move.w  d0,d3
    cmpi.w  #$ff,d0
    beq.b   .l8e86
    cmp.w   d3,d4
    beq.b   .l8e82
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $6100,$fa6e                                 ; bsr.w $0088EA
    lea     $0014(sp),sp
.l8e82:                                                 ; $008E82
    move.w  d3,d4
    bra.b   .l8ebe
.l8e86:                                                 ; $008E86
    cmpi.w  #$ff,d4
    beq.b   .l8ebe
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    lea     $0024(sp),sp
    move.w  #$ff,d4
.l8ebe:                                                 ; $008EBE
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $0002(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  (a2),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $0024(sp),sp
    tst.w   d2
    beq.b   .l8f14
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l8f14
    pea     ($0003).w
.l8f0a:                                                 ; $008F0A
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8,sp
    bra.b   .l8ebe
.l8f14:                                                 ; $008F14
    clr.w   d2
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$bf,d0
    move.w  d0,d5
    andi.w  #$20,d0
    beq.b   .l8f60
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    clr.l   -(sp)
    move.w  $0002(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0da0                                 ; jsr $009CEC
    nop
    lea     $000c(sp),sp
    cmpi.w  #$ff,d3
    beq.w   .l8ebe
    bra.w   .l90e8
.l8f60:                                                 ; $008F60
    move.w  d5,d0
    andi.w  #$10,d0
    beq.b   .l8f78
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  #$ff,d3
    bra.w   .l90e8
.l8f78:                                                 ; $008F78
    move.w  d5,d0
    andi.w  #$80,d0
    beq.w   .l9052
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d5,d0
    andi.w  #$80,d0
    beq.w   .l901a
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $6100,$faa6                                 ; bsr.w $008A4A
    move.w  d0,d6
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $0024(sp),sp
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0014(sp),sp
.l901a:                                                 ; $00901A
    cmpi.w  #$ff,d6
    beq.b   .l904a
    cmp.w   (a3),d6
    beq.b   .l904a
    move.w  d6,(a3)
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    lea     $001c(sp),sp
    move.w  #$ff,d3
.l904a:                                                 ; $00904A
    pea     ($0002).w
    bra.w   .l8f0a
.l9052:                                                 ; $009052
    move.w  d5,d0
    andi.w  #$f,d0
    beq.w   .l8ebe
    move.w  #$1,(a5)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $6100,$ea0a                                 ; bsr.w $007A74
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $6100,$eaa8                                 ; bsr.w $007B1E
    lea     $0010(sp),sp
    move.w  d0,d3
    cmpi.w  #$ff,d0
    beq.b   .l90a8
    cmp.w   d3,d4
    beq.b   .l90a4
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $6100,$f84c                                 ; bsr.w $0088EA
    lea     $0014(sp),sp
.l90a4:                                                 ; $0090A4
    move.w  d3,d4
    bra.b   .l90e0
.l90a8:                                                 ; $0090A8
    cmpi.w  #$ff,d4
    beq.b   .l90e0
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    lea     $0024(sp),sp
    move.w  #$ff,d4
.l90e0:                                                 ; $0090E0
    pea     ($0001).w
    bra.w   .l8f0a
.l90e8:                                                 ; $0090E8
    move.w  d3,d0
    movem.l -$0024(a6),d2-d6/a2-a5
    unlk    a6
    rts
; ============================================================================
; CalcStatChange -- (TODO: describe)
; Called: ?? times.
; 456 bytes | $0090F4-$0092BB
; ============================================================================
CalcStatChange:                                                  ; $0090F4
    movem.l d2-d3/a2,-(sp)
    move.l  $0018(sp),d2
    move.l  $0014(sp),d3
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff0120,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    tst.w   d3
    bne.w   .l91a0
    moveq   #$0,d3
    move.b  $0001(a2),d3
    tst.w   d2
    bne.b   .l9156
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$5,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$5,d1
.l9146:                                                 ; $009146
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    bra.b   .l9150
.l914e:                                                 ; $00914E
    moveq   #$1,d0
.l9150:                                                 ; $009150
    move.w  d0,d2
    bra.w   .l926e
.l9156:                                                 ; $009156
    cmpi.w  #$1,d2
    bne.b   .l9182
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$a,d1
    bra.b   .l9146
.l9182:                                                 ; $009182
    cmpi.w  #$2,d2
    bne.b   .l918e
.l9188:                                                 ; $009188
    clr.w   d2
    bra.w   .l926e
.l918e:                                                 ; $00918E
    cmpi.w  #$3,d2
    bne.b   .l919a
    moveq   #-$5,d2
    bra.w   .l926e
.l919a:                                                 ; $00919A
    moveq   #-$14,d2
    bra.w   .l926e
.l91a0:                                                 ; $0091A0
    cmpi.w  #$1,d3
    bne.b   .l9220
    moveq   #$0,d3
    move.b  $0002(a2),d3
    tst.w   d2
    bne.b   .l91da
.l91b0:                                                 ; $0091B0
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    bge.b   .l91be
    addq.l  #$3,d0
.l91be:                                                 ; $0091BE
    asr.l   #$2,d0
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    bge.b   .l91d4
    addq.l  #$3,d0
.l91d4:                                                 ; $0091D4
    asr.l   #$2,d0
    bra.w   .l9150
.l91da:                                                 ; $0091DA
    cmpi.w  #$1,d2
    bne.b   .l920a
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$9,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.w   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$9,d1
    bra.w   .l9146
.l920a:                                                 ; $00920A
    cmpi.w  #$2,d2
    beq.w   .l9188
    cmpi.w  #$3,d2
    bne.b   .l921c
    moveq   #-$A,d2
    bra.b   .l926e
.l921c:                                                 ; $00921C
    moveq   #-$1E,d2
    bra.b   .l926e
.l9220:                                                 ; $009220
    moveq   #$0,d3
    move.b  $0003(a2),d3
    tst.w   d2
    bne.b   .l9254
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.w   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$3,d1
    bra.w   .l9146
.l9254:                                                 ; $009254
    cmpi.w  #$1,d2
    beq.w   .l91b0
    cmpi.w  #$2,d2
    beq.w   .l9188
    cmpi.w  #$3,d2
    beq.w   .l919a
    moveq   #-$32,d2
.l926e:                                                 ; $00926E
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    ble.b   .l9286
    move.w  d2,d0
    ext.l   d0
    bra.b   .l9290
.l9286:                                                 ; $009286
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
.l9290:                                                 ; $009290
    move.w  d0,d2
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    sub.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    bge.b   .l92aa
    move.w  d2,d0
    ext.l   d0
    bra.b   .l92b4
.l92aa:                                                 ; $0092AA
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    sub.l   d0,d1
    move.l  d1,d0
.l92b4:                                                 ; $0092B4
    move.w  d0,d2
    movem.l (sp)+,d2-d3/a2
    rts
; ============================================================================
; CalcRevenue -- (TODO: describe)
; Called: ?? times.
; 704 bytes | $0092BC-$00957B
; ============================================================================
CalcRevenue:                                                  ; $0092BC
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0024(sp),d2
    move.l  $0020(sp),d3
    move.l  $0028(sp),d5
    movea.l #$00ff1298,a4
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d4
    tst.w   d2
    bne.w   .l93c6
    clr.w   d3
    bra.b   .l9378
.l9302:                                                 ; $009302
    move.b  $000a(a2),d0
    andi.l  #$2,d0
    bne.b   .l9372
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    move.w  d0,d2
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    lea     $000c(sp),sp
    mulu.w  #$c,d0
    movea.l #$00ffa6c1,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.l  #$4,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  (sp)+,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   d0,d4
.l9372:                                                 ; $009372
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
.l9378:                                                 ; $009378
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    bgt.w   .l9302
    move.l  d4,d0
    moveq   #$32,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d4
    moveq   #$a,d0
    cmp.l   d4,d0
    bcc.b   .l93a6
    move.l  d4,d0
    bra.b   .l93a8
.l93a6:                                                 ; $0093A6
    moveq   #$a,d0
.l93a8:                                                 ; $0093A8
    move.l  d0,d4
    move.l  #$1388,d1
.l93b0:                                                 ; $0093B0
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    move.l  #$2710,d1
    bra.w   .l9530
.l93c6:                                                 ; $0093C6
    cmpi.w  #$1,d2
    bne.w   .l9490
    clr.w   d3
    bra.w   .l9454
.l93d4:                                                 ; $0093D4
    move.b  $000a(a2),d0
    andi.l  #$2,d0
    bne.b   .l944e
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    move.w  d0,d2
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    lea     $000c(sp),sp
    mulu.w  #$c,d0
    movea.l #$00ffa6b9,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.l  #$4,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  (sp)+,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    lsr.l   #$5,d0
    add.l   d0,d4
.l944e:                                                 ; $00944E
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
.l9454:                                                 ; $009454
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    bgt.w   .l93d4
    move.l  d4,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d4
    moveq   #$a,d0
    cmp.l   d4,d0
    bcc.b   .l9482
    move.l  d4,d0
    bra.b   .l9484
.l9482:                                                 ; $009482
    moveq   #$a,d0
.l9484:                                                 ; $009484
    move.l  d0,d4
    move.l  #$1d4c,d1
    bra.w   .l93b0
.l9490:                                                 ; $009490
    movea.l a4,a2
    clr.w   d2
.l9494:                                                 ; $009494
    move.w  d2,d0
    lsl.w   #$3,d0
    move.w  d3,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba81,a0
    tst.b   (a0,d0.w)
    beq.b   .l94be
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   d0,d4
.l94be:                                                 ; $0094BE
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$59,d2
    bcs.b   .l9494
    moveq   #$0,d0
    move.b  $0001(a3),d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a4,a0.l),d0
    andi.l  #$ff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    lsl.l   #$2,d1
    movea.l d1,a0
    move.b  $3(a4,a0.l),d1
    andi.l  #$ff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    cmp.l   d4,d0
    bcc.b   .l94fe
    move.l  d4,d0
    bra.b   .l952c
.l94fe:                                                 ; $0094FE
    moveq   #$0,d0
    move.b  $0001(a3),d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a4,a0.l),d0
    andi.l  #$ff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    lsl.l   #$2,d1
    movea.l d1,a0
    move.b  $3(a4,a0.l),d1
    andi.l  #$ff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
.l952c:                                                 ; $00952C
    move.l  d0,d4
    moveq   #$32,d1
.l9530:                                                 ; $009530
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    movem.l (sp)+,d2-d5/a2-a4
    rts
; ============================================================================
; sub_00957C -- (TODO: describe)
; Called: ?? times.
; 286 bytes | $00957C-$009699
; ============================================================================
FindRelationIndex:                                                  ; $00957C
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $0018(sp),d2
    move.l  $0020(sp),d3
    move.l  $001c(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    addq.l  #$8,sp
    tst.w   d0
    bne.b   .l961c
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l960c
.l95cc:                                                 ; $0095CC
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l95e6
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l9600
.l95e6:                                                 ; $0095E6
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l9606
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l9606
.l9600:                                                 ; $009600
    move.w  d2,d0
    bra.w   .l9694
.l9606:                                                 ; $009606
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l960c:                                                 ; $00960C
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    blt.b   .l95cc
    bra.b   .l9690
.l961c:                                                 ; $00961C
    moveq   #$0,d0
    move.b  $0004(a3),d0
    mulu.w  #$14,d0
    move.w  d2,d1
    mulu.w  #$0320,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l9682
.l963e:                                                 ; $00963E
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l9658
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l9672
.l9658:                                                 ; $009658
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l967c
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l967c
.l9672:                                                 ; $009672
    moveq   #$0,d0
    move.b  $0004(a3),d0
    add.w   d2,d0
    bra.b   .l9694
.l967c:                                                 ; $00967C
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l9682:                                                 ; $009682
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    cmp.l   d1,d0
    blt.b   .l963e
.l9690:                                                 ; $009690
    move.w  #$ff,d0
.l9694:                                                 ; $009694
    movem.l (sp)+,d2-d4/a2-a3
    rts
; ============================================================================
; CalcCharOutput -- (TODO: describe)
; Called: ?? times.
; 568 bytes | $00969A-$0098D1
; ============================================================================
CalcCharOutput:                                                  ; $00969A
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0028(sp),d2
    move.l  $002c(sp),d3
    move.l  $0030(sp),d4
    movea.l $0034(sp),a2
    cmpi.w  #$20,d3
    bcc.b   .l96c4
    move.w  d3,d0
    mulu.w  #$6,d0
    add.w   d4,d0
    movea.l #$00ff1704,a0
    bra.b   .l96d0
.l96c4:                                                 ; $0096C4
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d4,d0
    movea.l #$00ff15a0,a0
.l96d0:                                                 ; $0096D0
    move.b  (a0,d0.w),d5
    andi.l  #$ff,d5
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    tst.b   $0003(a4)
    bne.b   .l9724
    moveq   #$0,d0
    move.b  $0002(a3),d0
.l9706:                                                 ; $009706
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    andi.l  #$ffff,d1
.l9718:                                                 ; $009718
    add.l   d1,d0
    bge.b   .l971e
    addq.l  #$1,d0
.l971e:                                                 ; $00971E
    asr.l   #$1,d0
    bra.w   .l97b0
.l9724:                                                 ; $009724
    cmpi.b  #$01,$0003(a4)
    bne.b   .l9742
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff0120,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    bra.b   .l9706
.l9742:                                                 ; $009742
    cmpi.b  #$02,$0003(a4)
    bne.b   .l9760
    moveq   #$0,d0
    move.b  $0002(a3),d0
.l9750:                                                 ; $009750
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  ($00FFBA68).l,d1
    bra.b   .l9718
.l9760:                                                 ; $009760
    cmpi.b  #$03,$0003(a4)
    bne.b   .l9770
    moveq   #$0,d0
    move.b  $0003(a3),d0
    bra.b   .l9750
.l9770:                                                 ; $009770
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff0120,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0003(a5),d1
    andi.l  #$ffff,d1
    add.l   d1,d0
    moveq   #$0,d1
    move.b  $0002(a5),d1
    andi.l  #$ffff,d1
    add.l   d1,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l97b0:                                                 ; $0097B0
    move.w  d0,d2
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  $0026(sp),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d4,d1
    add.l   d1,d0
    moveq   #$8,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d3
    cmpi.w  #$5,d3
    blt.b   .l97da
    moveq   #$8,d0
    sub.w   d3,d0
    move.w  d0,d3
.l97da:                                                 ; $0097DA
    addq.w  #$8,d3
    moveq   #$0,d0
    move.b  (a4),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.b  $0001(a3),d1
    addi.l  #$32,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.w  d3,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,(a2)
    moveq   #$1,d0
    cmp.l   (a2),d0
    bge.b   .l981a
    move.l  (a2),d0
    bra.b   .l981c
.l981a:                                                 ; $00981A
    moveq   #$1,d0
.l981c:                                                 ; $00981C
    move.l  d0,(a2)
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$6,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$46,d0
    move.l  (a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$5,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,(a2)
    moveq   #$0,d0
    move.b  $0001(a4),d0
    move.l  (a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  ($00FF1294).l,d1
    ext.l   d1
    move.l  #$82,d2
    sub.l   d1,d2
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,d2
    move.w  d3,d0
    ext.l   d0
    subi.l  #$9,d0
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    tst.l   d0
    bge.b   .l989e
    addq.l  #$1,d0
.l989e:                                                 ; $00989E
    asr.l   #$1,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    move.l  d0,d2
    move.l  (a2),d0
    bge.b   .l98ae
    addq.l  #$1,d0
.l98ae:                                                 ; $0098AE
    asr.l   #$1,d0
    cmp.l   d2,d0
    ble.b   .l98b8
    move.l  d2,d0
    bra.b   .l98c0
.l98b8:                                                 ; $0098B8
    move.l  (a2),d0
    bge.b   .l98be
    addq.l  #$1,d0
.l98be:                                                 ; $0098BE
    asr.l   #$1,d0
.l98c0:                                                 ; $0098C0
    move.l  d0,d2
    move.l  (a2),d0
    sub.l   d2,d0
    movea.l $0038(sp),a0
    move.l  d0,(a0)
    movem.l (sp)+,d2-d5/a2-a5
    rts
; ============================================================================
; DrawRouteLines -- (TODO: describe)
; Called: ?? times.
; 194 bytes | $0098D2-$009993
; ============================================================================
DrawRouteLines:                                                  ; $0098D2
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0028(sp),d2
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
.l98ee:                                                 ; $0098EE
    cmpi.b  #$ff,(a2)
    beq.w   .l9980
    moveq   #$0,d0
    move.b  (a2),d0
    add.w   d0,d0
    movea.l #$0005e948,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d0
    movea.l #$0005e948,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.b  (a4),d0
    cmp.b   (a3),d0
    bcc.b   .l9938
    moveq   #$0,d7
    move.b  (a4),d7
    moveq   #$0,d6
    move.b  $0001(a4),d6
    moveq   #$0,d5
    move.b  (a3),d5
    moveq   #$0,d4
    move.b  $0001(a3),d4
    bra.b   .l994c
.l9938:                                                 ; $009938
    moveq   #$0,d5
    move.b  (a4),d5
    moveq   #$0,d4
    move.b  $0001(a4),d4
    moveq   #$0,d7
    move.b  (a3),d7
    moveq   #$0,d6
    move.b  $0001(a3),d6
.l994c:                                                 ; $00994C
    move.w  $000e(a2),d0
    cmp.w   $0006(a2),d0
    bcs.b   .l995a
    moveq   #$1,d3
    bra.b   .l995c
.l995a:                                                 ; $00995A
    moveq   #$2,d3
.l995c:                                                 ; $00995C
    pea     ($00FF1804).l
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dc26                           ; jsr $01DC26
    lea     $0018(sp),sp
.l9980:                                                 ; $009980
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$28,d2
    blt.w   .l98ee
    movem.l (sp)+,d2-d7/a2-a4
    rts
; ============================================================================
; DrawRoutePair -- (TODO: describe)
; Called: ?? times.
; 244 bytes | $009994-$009A87
; ============================================================================
DrawRoutePair:                                                  ; $009994
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0038(sp),d6
    move.l  $0034(sp),d7
    movea.l $0030(sp),a2
    movea.l $002c(sp),a3
    movea.l #$00ff1804,a4
    movea.l #$0001da34,a5
    move.b  (a3),d0
    cmp.b   (a2),d0
    bcc.b   .l99d0
    moveq   #$0,d5
    move.b  (a3),d5
    moveq   #$0,d4
    move.b  $0001(a3),d4
    moveq   #$0,d3
    move.b  (a2),d3
    moveq   #$0,d2
    move.b  $0001(a2),d2
    bra.b   .l99e4
.l99d0:                                                 ; $0099D0
    moveq   #$0,d3
    move.b  (a3),d3
    moveq   #$0,d2
    move.b  $0001(a3),d2
    moveq   #$0,d5
    move.b  (a2),d5
    moveq   #$0,d4
    move.b  $0001(a2),d4
.l99e4:                                                 ; $0099E4
    move.l  a4,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    jsr     (a5)
    lea     $0018(sp),sp
    cmpi.w  #$1,d7
    ble.b   .l9a82
    move.w  d3,d0
    ext.l   d0
    move.w  d5,d1
    ext.l   d1
    sub.l   d1,d0
    move.w  d2,d1
    ext.l   d1
    movea.l d7,a0
    move.w  d4,d7
    ext.l   d7
    exg     d7,a0
    sub.l   a0,d1
    cmp.l   d1,d0
    ble.b   .l9a54
    move.l  a4,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$5,d0
    bra.b   .l9a72
.l9a54:                                                 ; $009A54
    move.l  a4,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
.l9a72:                                                 ; $009A72
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    jsr     (a5)
    lea     $0018(sp),sp
.l9a82:                                                 ; $009A82
    movem.l (sp)+,d2-d7/a2-a5
    rts
; === Translated block $009A88-$009C9E ===
; 1 functions, 534 bytes

; ============================================================================
; func_009A88 -- (TODO: name)
; 534 bytes | $009A88-$009C9D
; ============================================================================
func_009A88:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d5
    move.l  $10(a6), d6
    move.l  $8(a6), d7
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d4
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    and.l   (a0,d0.w), d4
    move.w  d7, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    move.w  d5, d0
    mulu.w  #$e, d0
    movea.l  #$0005E234,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    bra.w   l_09bc0
l_09af6:
    cmpi.b  #$ff, (a2)
    beq.w   l_09bba
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.b   l_09b1e
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    beq.w   l_09bba
l_09b1e:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d2
    cmp.w   d5, d0
    beq.b   l_09b56
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    bra.b   l_09b8c
l_09b56:
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d2
    cmp.w   d5, d0
    beq.b   l_09b8c
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a3
l_09b8c:
    tst.w   d6
    bne.b   l_09ba2
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   l_09b9e
    moveq   #$1,d2
    bra.b   l_09ba4
l_09b9e:
    moveq   #$2,d2
    bra.b   l_09ba4
l_09ba2:
    moveq   #$3,d2
l_09ba4:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    dc.w    $6100,$FDE0                                 ; bsr.w $009994
    lea     $10(a7), a7
l_09bba:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d3
l_09bc0:
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $4(a5), d1
    cmp.l   d1, d0
    blt.w   l_09af6
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d4
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    and.l   (a0,d0.w), d4
    moveq   #$0,d0
    move.b  $4(a5), d0
    mulu.w  #$14, d0
    move.w  d7, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.b   l_09c7c
l_09c0e:
    cmpi.b  #$ff, (a2)
    beq.b   l_09c76
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    beq.b   l_09c76
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.w   d6
    bne.b   l_09c5e
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   l_09c5a
    moveq   #$1,d2
    bra.b   l_09c60
l_09c5a:
    moveq   #$2,d2
    bra.b   l_09c60
l_09c5e:
    moveq   #$3,d2
l_09c60:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    dc.w    $6100,$FD24                                 ; bsr.w $009994
    lea     $10(a7), a7
l_09c76:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d3
l_09c7c:
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $5(a5), d1
    cmp.l   d1, d0
    blt.b   l_09c0e
    pea     ($000C).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; UpdateSlotDisplays -- (TODO: describe)
; Called: ?? times.
; 78 bytes | $009C9E-$009CEB
; ============================================================================
UpdateSlotDisplays:                                                  ; $009C9E
    movem.l d2-d4,-(sp)
    move.l  $0014(sp),d3
    move.l  $0010(sp),d4
    clr.w   d2
.l9cac:                                                 ; $009CAC
    cmp.w   d4,d2
    beq.b   .l9cc8
    pea     ($0003).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $6100,$fdc6                                 ; bsr.w $009A88
    lea     $000c(sp),sp
.l9cc8:                                                 ; $009CC8
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l9cac
    clr.l   -(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $6100,$fda8                                 ; bsr.w $009A88
    lea     $000c(sp),sp
    movem.l (sp)+,d2-d4
    rts
; ============================================================================
; PlaceCursor -- (TODO: describe)
; Called: ?? times.
; 166 bytes | $009CEC-$009D91
; ============================================================================
PlaceCursor:                                                  ; $009CEC
    movem.l d2-d4/a2,-(sp)
    move.l  $0018(sp),d2
    move.l  $0014(sp),d3
    move.l  $001c(sp),d4
    movea.l #$0d64,a2
    pea     ($0006).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0744).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0028(sp),sp
    cmpi.w  #$1,d4
    bne.b   .l9d84
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $002c(sp),sp
.l9d84:                                                 ; $009D84
    pea     ($0018).w
    jsr     (a2)
    addq.l  #$4,sp
    movem.l (sp)+,d2-d4/a2
    rts
; ============================================================================
; GetCharStat -- Look up character attribute from stat table
; Called: 14 times.
; 50 bytes | $009D92-$009DC3
; ============================================================================
GetCharStat:                                                  ; $009D92
    move.w  $000a(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d1
    move.b  (a1),d1
    move.w  $0006(sp),d0
    mulu.w  #$39,d0
    add.w   d1,d0
    movea.l #$00ff05c4,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    rts
; ============================================================================
; FindBitInField -- (TODO: describe)
; Called: 7 times.
; 88 bytes | $009DC4-$009E1B
; ============================================================================
FindBitInField:                                                  ; $009DC4
    movem.l d2-d3,-(sp)
    move.l  $000c(sp),d1
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d0
    move.b  (a1),d0
    moveq   #$1,d3
    lsl.l   d0,d3
    clr.w   d2
    bra.b   .l9e08
.l9dea:                                                 ; $009DEA
    move.w  d1,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d0
    and.l   d3,d0
    beq.b   .l9e04
    moveq   #$0,d0
    move.b  (a1),d0
    add.w   d2,d0
    bra.b   .l9e16
.l9e04:                                                 ; $009E04
    add.l   d3,d3
    addq.w  #$1,d2
.l9e08:                                                 ; $009E08
    moveq   #$0,d0
    move.b  $0001(a1),d0
    cmp.w   d2,d0
    bgt.b   .l9dea
    move.w  #$ff,d0
.l9e16:                                                 ; $009E16
    movem.l (sp)+,d2-d3
    rts
; ============================================================================
; DrawPlayerRoutes -- (TODO: describe)
; Called: ?? times.
; 300 bytes | $009E1C-$009F47
; ============================================================================
DrawPlayerRoutes:                                                  ; $009E1C
    link    a6,#-$20
    movem.l d2-d6/a2-a3,-(sp)
    move.l  $000c(a6),d5
    move.l  $0008(a6),d6
    move.w  d6,d0
    add.w   d0,d0
    movea.l #$00ff0118,a0
    move.w  (a0,d0.w),-$0002(a6)
    pea     ($0001).w
    pea     ($000F).w
    pea     -$0002(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    move.w  d6,d0
    lsl.w   #$5,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
.l9e64:                                                 ; $009E64
    tst.b   $0001(a2)
    beq.w   .l9f32
    cmpi.b  #$06,$0001(a2)
    beq.b   .l9e8a
    moveq   #$0,d3
    move.b  (a2),d3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d4
    bra.b   .l9ea4
.l9e8a:                                                 ; $009E8A
    moveq   #$0,d4
    move.b  (a2),d4
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    move.w  d0,d3
.l9ea4:                                                 ; $009EA4
    cmp.w   d5,d4
    bne.b   .l9ed4
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $0001(a3),d0
    subq.l  #$8,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    addq.l  #$8,d0
    bra.b   .l9f08
.l9ed4:                                                 ; $009ED4
    cmpi.w  #$7,d5
    bne.b   .l9f32
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005e948,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $0001(a3),d0
    subi.l  #$c,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    addq.l  #$4,d0
.l9f08:                                                 ; $009F08
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addi.l  #$3b,d0
    move.l  d0,-(sp)
    pea     ($0544).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
.l9f32:                                                 ; $009F32
    addq.l  #$8,a2
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.w   .l9e64
    movem.l -$003c(a6),d2-d6/a2-a3
    unlk    a6
    rts
; ============================================================================
; NopStub -- (TODO: describe)
; Called: ?? times.
; 2 bytes | $009F48-$009F49
; ============================================================================
NopStub:                                                  ; $009F48
    rts
; ============================================================================
; SelectMenuItem -- Map selection index to menu entry, dispatch via MenuSelectEntry
; Called: 14 times.
; 62 bytes | $009F4A-$009F87
; ============================================================================
SelectMenuItem:                                                  ; $009F4A
    move.l  $0004(sp),d1
    cmpi.w  #$7,d1
    bge.b   .l9f58
    addq.w  #$2,d1
    bra.b   .l9f76
.l9f58:                                                 ; $009F58
    cmpi.w  #$2,($00FF0002).l
    bge.b   .l9f66
    moveq   #$a,d1
    bra.b   .l9f76
.l9f66:                                                 ; $009F66
    cmpi.w  #$3,($00FF0002).l
    bge.b   .l9f74
    moveq   #$b,d1
    bra.b   .l9f76
.l9f74:                                                 ; $009F74
    moveq   #$c,d1
.l9f76:                                                 ; $009F76
    pea     ($0001).w
    move.w  d1,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    addq.l  #$8,sp
    rts
LoadSlotGraphics:                                                  ; $009F88
    movem.l d2-d5,-(sp)
    move.l  $0020(sp),d2
    move.l  $001c(sp),d3
    move.l  $0018(sp),d4
    move.l  $0014(sp),d5
    cmpi.w  #$1,d2
    bne.b   .l9fcc
    pea     ($00070F18).l
    pea     ($0002).w
    pea     ($0008).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
.l9fcc:                                                 ; $009FCC
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000a1ac8,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0010).w
    pea     ($03A4).w
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0014(sp),sp
    movem.l (sp)+,d2-d5
    rts
; ============================================================================
; sub_00A006 -- (TODO: describe)
; Called: ?? times.
; 336 bytes | $00A006-$00A155
; ============================================================================
RunScreenLoop:                                                  ; $00A006
    movem.l d2-d3/a2,-(sp)
    movea.l #$0004c974,a2
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d340                           ; jsr $01D340
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    lea     $000c(sp),sp
    dc.w    $4eba,$04f8                                 ; jsr $00A526
    nop
    dc.w    $4eba,$1718                                 ; jsr $00B74C
    nop
    dc.w    $4eb9,$0003,$a8d6                           ; jsr $03A8D6
    clr.w   d2
    clr.w   ($00FF17C4).l
    bra.w   .la12a
.la04a:                                                 ; $00A04A
    dc.w    $4eba,$010a                                 ; jsr $00A156
    nop
    tst.w   d0
    bne.b   .la068
    dc.w    $4eba,$027e                                 ; jsr $00A2D4
    nop
    cmpi.w  #$1,d0
    bne.w   .la12a
    moveq   #$1,d2
    bra.w   .la12a
.la068:                                                 ; $00A068
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  a2,d0
    moveq   #$22,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    move.l  a2,d0
    addi.l  #$0722,d0
    move.l  d0,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    dc.w    $4eb9,$0001,$77c4                           ; jsr $0177C4
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$7566                           ; jsr $017566
    lea     $0018(sp),sp
    move.w  d0,d3
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    move.w  d3,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .la12a
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$2940                                 ; jsr $00CA3E
    nop
    dc.w    $4eba,$310a                                 ; jsr $00D20E
    nop
    dc.w    $4eb9,$0002,$949a                           ; jsr $02949A
    pea     ($0001).w
    dc.w    $4eb9,$0001,$819c                           ; jsr $01819C
    addq.l  #$8,sp
    move.w  #$1,($00FF17C4).l
    moveq   #$1,d2
    dc.w    $4eba,$1918                                 ; jsr $00BA3E
    nop
.la12a:                                                 ; $00A12A
    tst.w   d2
    beq.w   .la04a
    clr.w   d2
.la132:                                                 ; $00A132
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e98e                           ; jsr $01E98E
    addq.l  #$4,sp
    addq.w  #$1,d2
    cmpi.w  #$7,d2
    bcs.b   .la132
    andi.w  #$7fff,($00FF0A34).l
    movem.l (sp)+,d2-d3/a2
    rts
; === Translated block $00A156-$00D5B6 ===
; 32 functions, 13408 bytes

; ============================================================================
; func_00A156 -- (TODO: name)
; 382 bytes | $00A156-$00A2D3
; ============================================================================
func_00A156:
    link    a6,#-$24
    movem.l d2-d4/a2-a4, -(a7)
    lea     -$24(a6), a3
    movea.l  #$00048F60,a4
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    move.w  #$56b5, -$4(a6)
    move.w  #$6f7b, -$2(a6)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    dc.w    $4EB9,$0000,$68CA                           ; jsr $0068CA
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $2c(a7), a7
    pea     ($0010).w
    pea     ($0030).w
    move.l  a4, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  a4, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    pea     ($0018).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001B).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    move.l  a4, d0
    addi.l  #$142, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $30(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($004A).w
    pea     ($0301).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    lea     $14(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    clr.w   d2
    moveq   #$1,d4
    movea.l a3, a2
    moveq   #$12,d0
    adda.l  d0, a2
.l0a234:
    cmp.w   d4, d2
    beq.b   .l0a266
    move.w  #$40, (a2)
    move.w  #$40, $14(a3)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$60, $12(a3, a0.l)
    pea     ($0002).w
    pea     ($0039).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $c(a7), a7
    move.w  d2, d4
.l0a266:
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
    addq.l  #$8, a7
    move.w  d0, d3
    andi.l  #$33, d0
    beq.b   .l0a266
    move.w  d3, d0
    andi.w  #$30, d0
    beq.b   .l0a292
    move.w  d3, d0
    andi.w  #$20, d0
    beq.b   .l0a234
    bra.b   .l0a2bc
.l0a292:
    move.w  d3, d0
    andi.w  #$1, d0
    beq.b   .l0a2a6
    cmpi.w  #$1, d2
    bne.b   .l0a234
    moveq   #$1,d4
    clr.w   d2
    bra.b   .l0a234
.l0a2a6:
    move.w  d3, d0
    andi.w  #$2, d0
    beq.b   .l0a234
    tst.w   d2
    bne.w   .l0a234
    clr.w   d4
    moveq   #$1,d2
    bra.w   .l0a234
.l0a2bc:
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    move.w  d2, d0
    movem.l -$3c(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_00A2D4 -- (TODO: name)
; 594 bytes | $00A2D4-$00A525
; ============================================================================
func_00A2D4:
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$0004C974,a2
    movea.l  #$00000D64,a3
    movea.l  #$00FF1804,a4
    movea.l  #$00005092,a5
    clr.w   d2
    pea     ($0001).w
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.l  a2, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  a2, d0
    addi.l  #$722, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    pea     ($000D).w
    jsr     (a3)
    pea     ($000C).w
    jsr     (a3)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a5)
    lea     $30(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
.l0a37a:
    cmpi.w  #$1, d2
    bne.w   .l0a408
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0001).w
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a2, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    move.l  a2, d0
    addi.l  #$722, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    lea     $14(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    clr.w   d2
.l0a408:
    dc.w    $4EBA,$01DA                                 ; jsr $00A5E4(pc)
    nop
    tst.w   d0
    bne.b   .l0a418
    clr.w   d2
    bra.w   .l0a51e
.l0a418:
    dc.w    $4EBA,$2270                                 ; jsr $00C68A(pc)
    nop
    move.w  ($00FF0002).l, d0
    mulu.w  #$3c, d0
    addq.w  #$1, d0
    move.w  d0, ($00FF0006).l
    dc.w    $4EBA,$2DDC                                 ; jsr $00D20E(pc)
    nop
    dc.w    $4EBA,$08CA                                 ; jsr $00AD02(pc)
    nop
    tst.w   d0
    beq.w   .l0a37a
    dc.w    $4EBA,$05D8                                 ; jsr $00AA1C(pc)
    nop
    tst.w   d0
    beq.w   .l0a37a
    dc.w    $4EBA,$0BF2                                 ; jsr $00B042(pc)
    nop
    tst.w   d0
    bne.b   .l0a45e
.l0a458:
    moveq   #$1,d2
    bra.w   .l0a37a
.l0a45e:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0001).w
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a2, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    move.l  a2, d0
    addi.l  #$722, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
    lea     $14(a7), a7
    dc.w    $4EBA,$1CD4                                 ; jsr $00C1AC(pc)
    nop
    move.w  d0, d2
    cmpi.w  #$1, d0
    bne.w   .l0a458
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d3
    addq.w  #$1, d0
    move.w  d0, ($00FF0006).l
    move.w  d3, d0
    addi.w  #$50, d0
    move.w  d0, ($00FFA6B2).l
    dc.w    $4EBA,$1570                                 ; jsr $00BA7E(pc)
    nop
    dc.w    $4EB9,$0002,$62E4                           ; jsr $0262E4
    dc.w    $4EBA,$1E9A                                 ; jsr $00C3B4(pc)
    nop
.l0a51e:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; func_00A526 -- (TODO: name)
; 190 bytes | $00A526-$00A5E3
; ============================================================================
func_00A526:
    move.l  a2, -(a7)
    movea.l  #$00FF0118,a2
    move.l  #$ff0a3c, d0
    subi.l  #$ff0000, d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    pea     ($00FF0000).l
    pea     ($00046890).l
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    move.w  #$22, ($00FF999C).l
    move.w  #$21, ($00FFBA68).l
    move.w  #$21, ($00FF1288).l
    move.w  #$42, ($00FFBD4C).l
    move.w  #$32, ($00FF1294).l
    move.w  #$a, ($00FF0118).l
    move.w  #$e42, $2(a2)
    move.w  #$2ac, $4(a2)
    move.w  #$480, $6(a2)
    move.w  #$ffff, ($00FF0A32).l
    move.w  #$1, ($00FF0008).l
    move.w  #$1, ($00FF000A).l
    move.w  #$1, ($00FF000C).l
    move.w  #$1, ($00FF000E).l
    move.w  #$1, ($00FF0010).l
    pea     ($0030).w
    pea     ($00FF1480).l
    pea     ($00047600).l
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    lea     $18(a7), a7
    movea.l (a7)+, a2
    rts

; ============================================================================
; func_00A5E4 -- (TODO: name)
; 1080 bytes | $00A5E4-$00AA1B
; ============================================================================
func_00A5E4:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0002,a2
    movea.l  #$0003B246,a3
    movea.l  #$00000D64,a4
    movea.l  #$00047630,a5
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    moveq   #$5,d3
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0004).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $24(a7), a7
    clr.w   d2
.l0a63a:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E570).l
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    addq.w  #$3, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0a63a
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000475DC).l, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$1F74                                 ; jsr $00C61E(pc)
    nop
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0a6c2
    moveq   #$1,d4
    bra.b   .l0a6c4
.l0a6c2:
    moveq   #$0,d4
.l0a6c4:
    clr.w   d5
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   (a2)
.l0a6d4:
    move.w  (a2), d3
    add.w   d3, d3
    add.w   (a2), d3
    addq.w  #$4, d3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$9, d0
    move.l  d0, -(a7)
    pea     ($0011).w
    pea     ($0002).w
    pea     ($0544).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    tst.w   d4
    beq.b   .l0a734
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0a734
    pea     ($0002).w
.l0a72a:
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l0a6d4
.l0a734:
    clr.w   d4
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.w   .l0a99c
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d2
    ext.l   d2
    lsl.l   #$3, d2
    addi.l  #$9, d2
    move.l  d2, -(a7)
    pea     ($0011).w
    pea     ($0002).w
    pea     ($0546).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2, -(a7)
    pea     ($0011).w
    pea     ($0002).w
    pea     ($0548).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($0002).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0004).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    lea     $2c(a7), a7
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E562).l
    jsr     (a3)
    move.w  (a2), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    pea     ($0003E55E).l
    jsr     (a3)
    move.w  (a2), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)
    pea     ($0003E55A).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($001B).w
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     ($0007).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $30(a7), a7
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047650,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E556).l
    jsr     (a3)
    pea     ($000D).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047660,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E538).l
    jsr     (a3)
    pea     ($0003E52A).l
    move.l  ($000475F0).l, -(a7)
    pea     -$80(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$80(a6)
    clr.l   -(a7)
    dc.w    $4EBA,$1D52                                 ; jsr $00C61E(pc)
    nop
    lea     $14(a7), a7
    tst.w   d0
    bne.w   .l0aa0e
    clr.l   -(a7)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    moveq   #$5,d3
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0004).w
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    lea     $2c(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $10(a7), a7
    clr.w   d2
.l0a926:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E522).l
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    addq.w  #$3, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0a926
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000475DC).l, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$1C8E                                 ; jsr $00C61E(pc)
    nop
    lea     $14(a7), a7
    bra.w   .l0a6d4
.l0a99c:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l0a9ba
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    bra.b   .l0aa10
.l0a9ba:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l0a9e2
    move.w  #$1, ($00FF13FC).l
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$3,d1
    cmp.l   d0, d1
    ble.b   .l0a9de
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0a9e0
.l0a9de:
    moveq   #$3,d0
.l0a9e0:
    move.w  d0, (a2)
.l0a9e2:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0aa06
    move.w  #$1, ($00FF13FC).l
    move.w  (a2), d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0aa02
    move.w  (a2), d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0aa04
.l0aa02:
    moveq   #$0,d0
.l0aa04:
    move.w  d0, (a2)
.l0aa06:
    pea     ($0005).w
    bra.w   .l0a72a
.l0aa0e:
    moveq   #$1,d2
.l0aa10:
    move.w  d2, d0
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00AA1C -- (TODO: name)
; 742 bytes | $00AA1C-$00AD01
; ============================================================================
func_00AA1C:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00000D64,a3
    lea     -$20(a6), a4
    movea.l  #$00FF13FC,a5
    movea.l  #$00FF0018,a2
    clr.w   d2
.l0aa3c:
    clr.b   (a2)
    move.b  #$ff, $1(a2)
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0aa3c
    move.l  #$8000, -(a7)
    pea     ($0011).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A5E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  ($000A1B0C).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $30(a7), a7
    pea     ($0055).w
    pea     ($010F).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($00071D24).l
    pea     ($000F).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003E578).l
    clr.l   -(a7)
    dc.w    $4EBA,$1B44                                 ; jsr $00C61E(pc)
    nop
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0aaf2
    moveq   #$1,d2
    bra.b   .l0aaf4
.l0aaf2:
    moveq   #$0,d2
.l0aaf4:
    clr.w   d5
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d3
    clr.w   d4
.l0ab02:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$30, d0
    move.l  d0, -(a7)
    pea     ($0048).w
    pea     ($0002).w
    pea     ($0544).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    tst.w   d4
    bne.b   .l0ab44
    cmpi.w  #$4, d4
    beq.b   .l0ab9a
.l0ab44:
    cmp.w   d3, d4
    beq.b   .l0ab9a
    move.w  #$40, $12(a4)
    move.w  #$40, $14(a4)
    move.w  #$40, $16(a4)
    move.w  #$40, $18(a4)
    move.w  #$40, $1a(a4)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$60, $12(a4, a0.l)
    pea     ($0005).w
    pea     ($0039).w
    move.l  a4, d0
    moveq   #$12,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.w  d3, d4
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a3)
    lea     $14(a7), a7
.l0ab9a:
    tst.w   d2
    beq.b   .l0abbc
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0abbc
    pea     ($0002).w
.l0abb0:
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l0ab02
.l0abbc:
    clr.w   d2
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$30, d0
    beq.w   .l0ac68
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    andi.w  #$20, d0
    beq.b   .l0ac64
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d2
    ext.l   d2
    lsl.l   #$4, d2
    addi.l  #$30, d2
    move.l  d2, -(a7)
    pea     ($0048).w
    pea     ($0002).w
    pea     ($0546).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2, -(a7)
    pea     ($0048).w
    pea     ($0002).w
    pea     ($0548).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    moveq   #$1,d4
.l0ac52:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $c(a7), a7
    bra.b   .l0acb4
.l0ac64:
    clr.w   d4
    bra.b   .l0ac52
.l0ac68:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0ac88
    move.w  #$1, (a5)
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0ac84
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0acaa
.l0ac84:
    moveq   #$0,d0
    bra.b   .l0acaa
.l0ac88:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l0acac
    move.w  #$1, (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   .l0aca8
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0acaa
.l0aca8:
    moveq   #$4,d0
.l0acaa:
    move.w  d0, d3
.l0acac:
    pea     ($0004).w
    bra.w   .l0abb0
.l0acb4:
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    movea.l  #$00FF0018,a2
    clr.w   d2
    bra.b   .l0ace6
.l0acdc:
    move.b  #$1, (a2)
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l0ace6:
    cmp.w   d3, d2
    blt.b   .l0acdc
    move.w  d3, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FF0A34).l
    move.w  d4, d0
    movem.l -$40(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00AD02 -- (TODO: name)
; 556 bytes | $00AD02-$00AF2D
; ============================================================================
func_00AD02:
    movem.l d2-d5/a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    movea.l  #$00FF13FC,a4
    clr.l   -(a7)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($000C).w
    pea     ($0017).w
    pea     ($0003).w
    pea     ($0004).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    lea     $2c(a7), a7
    moveq   #$7,d4
    moveq   #$4,d3
    clr.w   d2
.l0ad52:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047670,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E5C8).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0012).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5BE).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $20(a7), a7
    addq.w  #$2, d3
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   .l0ad52
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000475E4).l, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$185E                                 ; jsr $00C61E(pc)
    nop
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0add8
    moveq   #$1,d4
    bra.b   .l0adda
.l0add8:
    moveq   #$0,d4
.l0adda:
    clr.w   d5
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    clr.w   d2
.l0ade6:
    move.w  d2, d3
    add.w   d3, d3
    addq.w  #$4, d3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0030).w
    pea     ($0002).w
    pea     ($0544).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    tst.w   d4
    beq.b   .l0ae3a
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0ae3a
    pea     ($0002).w
.l0ae30:
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   .l0ade6
.l0ae3a:
    clr.w   d4
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$30, d0
    beq.b   .l0aecc
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    andi.w  #$20, d0
    beq.w   .l0af14
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, d3
    move.l  d0, -(a7)
    pea     ($0030).w
    pea     ($0002).w
    pea     ($0546).w
    jsr     (a3)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d3, -(a7)
    pea     ($0030).w
    pea     ($0002).w
    pea     ($0548).w
    jsr     (a3)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.w  d2, ($00FF0004).l
    moveq   #$1,d2
    bra.b   .l0af16
.l0aecc:
    move.w  d5, d0
    andi.w  #$3, d0
    beq.b   .l0af0c
    move.w  #$1, (a4)
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0aef4
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0aef0
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0af0a
.l0aef0:
    moveq   #$0,d0
    bra.b   .l0af0a
.l0aef4:
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   .l0af08
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0af0a
.l0af08:
    moveq   #$4,d0
.l0af0a:
    move.w  d0, d2
.l0af0c:
    pea     ($0005).w
    bra.w   .l0ae30
.l0af14:
    clr.w   d2
.l0af16:
    pea     ($0001).w
    pea     ($0002).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    move.w  d2, d0
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; func_00AF2E -- (TODO: name)
; 276 bytes | $00AF2E-$00B041
; ============================================================================
func_00AF2E:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $14(a7), d3
    movea.l  #$00FF0018,a2
    cmpi.w  #$7, d3
    bge.w   .l0afd2
    clr.w   d2
.l0af46:
    cmpi.b  #$ff, $1(a2)
    beq.b   .l0afc2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    cmp.w   d3, d0
    bne.b   .l0afc2
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    move.b  (a0,d0.w), d1
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0760).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
.l0afc2:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0af46
    bra.b   .l0b03c
.l0afd2:
    clr.w   d2
.l0afd4:
    cmpi.b  #$ff, $1(a2)
    beq.b   .l0b030
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0760).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
.l0b030:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0afd4
.l0b03c:
    movem.l (a7)+, d2-d3/a2-a3
    rts

; ============================================================================
; func_00B042 -- (TODO: name)
; 420 bytes | $00B042-$00B1E5
; ============================================================================
func_00B042:
    movem.l d2-d5/a2-a4, -(a7)
    movea.l  #$00000D64,a3
    movea.l  #$0001D520,a4
    move.l  #$22889011, d5
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FF08EC).l
    jsr     (a4)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FFA6A0).l
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF00A8).l
    jsr     (a4)
    lea     $24(a7), a7
    moveq   #$0,d4
    movea.l  #$00FF0018,a2
    clr.w   d3
.l0b090:
    cmpi.b  #$1, (a2)
    bne.b   .l0b0d6
    move.l  d4, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0354                                 ; jsr $00B3F4(pc)
    nop
    move.w  d0, d2
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    dc.w    $4EB9,$0000,$68CA                           ; jsr $0068CA
    lea     $24(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    bra.w   .l0b15a
.l0b0d6:
    tst.w   d3
    bne.b   .l0b112
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0000,$814A                           ; jsr $00814A
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    dc.w    $4EB9,$0000,$68CA                           ; jsr $0068CA
    lea     $1c(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
.l0b112:
    pea     ($001F).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.w  d0, d2
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.b   .l0b112
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d5, d0
    beq.b   .l0b112
    move.b  d2, $1(a2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$009E                                 ; jsr $00B1E6(pc)
    nop
    addq.l  #$4, a7
    move.b  d0, $1(a2)
    move.l  d0, d2
    andi.l  #$ff, d2
.l0b15a:
    pea     ($0007).w
    dc.w    $6100,$FDCE                                 ; bsr.w $00AF2E
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  d1, (a0,d0.w)
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  d1, (a0,d0.w)
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    or.l    d0, d4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EAAC,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    dc.w    $4EB9,$0001,$E3EE                           ; jsr $01E3EE
    lea     $14(a7), a7
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   .l0b090
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    moveq   #$1,d0
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; func_00B1E6 -- (TODO: name)
; 276 bytes | $00B1E6-$00B2F9
; ============================================================================
func_00B1E6:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d5
    movea.l  #$00FF0002,a3
.l0b1f4:
    cmpi.w  #$3, ($00FF0004).l
    ble.b   .l0b212
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$00F4                                 ; jsr $00B2FA(pc)
    nop
    addq.l  #$4, a7
    move.w  d0, d2
    bra.w   .l0b29a
.l0b212:
    pea     ($001F).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$2, d2
    beq.b   .l0b1f4
    cmpi.w  #$3, d2
    beq.b   .l0b1f4
    cmpi.w  #$7, d2
    bne.b   .l0b238
    tst.w   (a3)
    beq.b   .l0b1f4
.l0b238:
    cmpi.w  #$8, d2
    beq.b   .l0b1f4
    cmpi.w  #$b, d2
    bne.b   .l0b248
    tst.w   (a3)
    beq.b   .l0b1f4
.l0b248:
    cmpi.w  #$9, d2
    bne.b   .l0b254
    cmpi.w  #$1, (a3)
    beq.b   .l0b1f4
.l0b254:
    cmpi.w  #$a, d2
    bne.b   .l0b260
    cmpi.w  #$1, (a3)
    beq.b   .l0b1f4
.l0b260:
    cmpi.w  #$a, d2
    bne.b   .l0b26c
    cmpi.w  #$2, (a3)
    beq.b   .l0b1f4
.l0b26c:
    cmpi.w  #$12, d2
    beq.b   .l0b1f4
    cmpi.w  #$14, d2
    beq.w   .l0b1f4
    cmpi.w  #$15, d2
    beq.w   .l0b1f4
    cmpi.w  #$16, d2
    beq.w   .l0b1f4
    cmpi.w  #$1b, d2
    beq.w   .l0b1f4
    cmpi.w  #$1f, d2
    beq.w   .l0b1f4
.l0b29a:
    moveq   #$1,d4
    movea.l  #$00FF0018,a2
    clr.w   d3
    bra.b   .l0b2e6
.l0b2a6:
    tst.b   (a2)
    bne.b   .l0b2d6
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.l  (a7)+, d1
    cmp.w   d1, d0
.l0b2d0:
    bne.b   .l0b2e0
    clr.w   d4
    bra.b   .l0b2ea
.l0b2d6:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d2, d0
    bra.b   .l0b2d0
.l0b2e0:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d3
.l0b2e6:
    cmp.w   d5, d3
    bcs.b   .l0b2a6
.l0b2ea:
    cmpi.w  #$1, d4
    bne.w   .l0b1f4
    move.w  d2, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; func_00B2FA -- (TODO: name)
; 250 bytes | $00B2FA-$00B3F3
; ============================================================================
func_00B2FA:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    movea.l  #$00FF0002,a2
    move.w  #$ff, d2
    dc.w    $4EB9,$0002,$7AA4                           ; jsr $027AA4
    move.w  d0, d4
    cmpi.w  #$1, d4
    bne.w   .l0b3b0
    cmpi.w  #$1, d3
    bne.w   .l0b3b0
    moveq   #$0,d3
    move.b  ($00FF0019).l, d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d4
    tst.w   d4
    bne.b   .l0b348
    tst.w   d3
    beq.b   .l0b3b0
    clr.w   d2
    bra.b   .l0b3b0
.l0b348:
    cmpi.w  #$3, d4
    bne.b   .l0b358
    cmpi.w  #$c, d3
    beq.b   .l0b3b0
    moveq   #$C,d2
    bra.b   .l0b3b0
.l0b358:
    cmpi.w  #$4, d4
    bne.b   .l0b368
    cmpi.w  #$13, d3
    beq.b   .l0b3b0
    moveq   #$13,d2
    bra.b   .l0b3b0
.l0b368:
    cmpi.w  #$5, d4
    bne.b   .l0b3a2
    cmpi.w  #$17, d3
    beq.b   .l0b3b0
    cmpi.w  #$19, d3
    beq.b   .l0b3b0
    tst.w   (a2)
    bne.b   .l0b382
.l0b37e:
    moveq   #$17,d2
    bra.b   .l0b3b0
.l0b382:
    pea     ($0064).w
    pea     ($0001).w
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    moveq   #$2,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    tst.l   d0
    beq.b   .l0b37e
    moveq   #$19,d2
    bra.b   .l0b3b0
.l0b3a2:
    cmpi.w  #$6, d4
    bne.b   .l0b3b0
    cmpi.w  #$1d, d3
    beq.b   .l0b3b0
    moveq   #$1D,d2
.l0b3b0:
    cmpi.w  #$ff, d2
    bne.b   .l0b3ec
    clr.w   d2
    moveq   #$8,d3
    cmpi.w  #$2, (a2)
    bge.b   .l0b3c4
    moveq   #$7,d3
    bra.b   .l0b3cc
.l0b3c4:
    cmpi.w  #$3, (a2)
    bne.b   .l0b3cc
    moveq   #$1,d2
.l0b3cc:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    add.w   d0, d0
    movea.l  #$0005FD24,a0
    move.w  (a0,d0.w), d2
.l0b3ec:
    move.w  d2, d0
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; func_00B3F4 -- (TODO: name)
; 856 bytes | $00B3F4-$00B74B
; ============================================================================
func_00B3F4:
    link    a6,#-$54
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d4
    lea     -$52(a6), a4
    movea.l  #$00000D64,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$80, ($00FFBD64).l
    move.w  #$80, ($00FFBD66).l
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0004).w
    dc.w    $4EB9,$0000,$68CA                           ; jsr $0068CA
    pea     ($0007).w
    dc.w    $6100,$FAC6                                 ; bsr.w $00AF2E
    lea     $20(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    movea.l  #$000475E8,a2
.l0b47a:
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5D2).l
    move.l  (a2), -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$1180                                 ; jsr $00C61E(pc)
    nop
.l0b4a2:
    dc.w    $4EBA,$140E                                 ; jsr $00C8B2(pc)
    nop
    move.w  d0, -$2(a6)
    cmpi.w  #$ff, d0
    beq.b   .l0b4a2
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0001).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6A2E                           ; jsr $006A2E
    lea     $30(a7), a7
    pea     ($0003).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6B78                           ; jsr $006B78
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FA32                                 ; bsr.w $00AF2E
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5CC).l
    move.l  (a2), -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$10F0                                 ; jsr $00C61E(pc)
    nop
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
.l0b550:
    pea     -$2(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$8E0C                           ; jsr $008E0C
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$20, d2
    bge.w   .l0b670
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.w   .l0b60c
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475F0).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$1068                                 ; jsr $00C61E(pc)
    nop
    lea     $20(a7), a7
    cmpi.w  #$1, d0
    beq.b   .l0b5dc
    move.w  #$ff, d2
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    addq.l  #$8, a7
    bra.w   .l0b6c0
.l0b5dc:
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $24(a7), a7
    bra.w   .l0b6e6
.l0b60c:
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475FC).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$0FDA                                 ; jsr $00C61E(pc)
    nop
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  #$ff, d2
    bra.b   .l0b6de
.l0b670:
    cmpi.w  #$20, d2
    blt.b   .l0b6de
    cmpi.w  #$ff, d2
    beq.b   .l0b6de
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475EC).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$0F6A                                 ; jsr $00C61E(pc)
    nop
    lea     $28(a7), a7
    move.w  #$ff, d2
.l0b6c0:
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
.l0b6de:
    cmpi.w  #$ff, d2
    bne.w   .l0b550
.l0b6e6:
    cmpi.w  #$ff, d2
    bne.b   .l0b72e
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0004).w
    dc.w    $4EB9,$0000,$68CA                           ; jsr $0068CA
    pea     ($0007).w
    dc.w    $6100,$F80C                                 ; bsr.w $00AF2E
    lea     $20(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
.l0b72e:
    cmpi.w  #$ff, d2
    beq.w   .l0b47a
    move.b  d2, $1(a3)
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    move.w  d2, d0
    movem.l -$70(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00B74C -- (TODO: name)
; 754 bytes | $00B74C-$00BA3D
; ============================================================================
func_00B74C:
    movem.l d2/a2-a5, -(a7)
    movea.l  #$0001D520,a2
    movea.l  #$00FF88DC,a3
    movea.l  #$00FF9A20,a4
    movea.l  #$0001D538,a5
    pea     ($0090).w
    clr.l   -(a7)
    pea     ($00FF0018).l
    jsr     (a2)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF00A8).l
    jsr     (a2)
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF00E8).l
    jsr     (a2)
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF0130).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF01B0).l
    jsr     (a2)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF0230).l
    jsr     (a2)
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF0270).l
    jsr     (a2)
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($00FF0290).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FFB9E8).l
    jsr     (a2)
    pea     ($0050).w
    clr.l   -(a7)
    pea     ($00FF02E8).l
    jsr     (a2)
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF0338).l
    jsr     (a2)
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF03F0).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FF08EC).l
    jsr     (a2)
    pea     ($00C0).w
    pea     ($00FF).w
    pea     ($00FF0420).l
    jsr     (a2)
    pea     ($00E4).w
    pea     ($00FF).w
    pea     ($00FF04E0).l
    jsr     (a2)
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF09A2).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0059).w
    clr.l   -(a7)
    pea     ($00FF09D8).l
    jsr     (a2)
    pea     ($001C).w
    clr.l   -(a7)
    pea     ($00FFBDE4).l
    jsr     (a2)
    pea     ($001C).w
    clr.l   -(a7)
    pea     ($00FFA7BC).l
    jsr     (a2)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FFA6A0).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0038).w
    clr.l   -(a7)
    pea     ($00FFBD6C).l
    jsr     (a2)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FF1278).l
    jsr     (a2)
    pea     ($02C8).w
    clr.l   -(a7)
    pea     ($00FFBA80).l
    jsr     (a2)
    pea     ($00E4).w
    clr.l   -(a7)
    pea     ($00FF05C4).l
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0C80).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr     (a2)
    lea     $c(a7), a7
    move.b  #$ff, ($00FF9A20).l
    move.b  #$ff, $1(a4)
    moveq   #$1,d2
.l0b8f2:
    pea     ($0014).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    pea     (a4, d0.l)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$28, d2
    blt.b   .l0b8f2
    moveq   #$1,d2
.l0b91c:
    pea     ($0320).w
    move.w  d2, d0
    ext.l   d0
    move.l  #$320, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    pea     (a4, d0.l)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0b91c
    pea     ($00C0).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr     (a2)
    lea     $c(a7), a7
    move.w  #$ff, ($00FF88DC).l
    move.w  #$ff, $2(a3)
    moveq   #$1,d2
.l0b966:
    pea     ($000C).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    pea     (a3, d0.l)
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0b966
    moveq   #$1,d2
.l0b990:
    pea     ($0030).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$4, d0
    pea     (a3, d0.l)
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0b990
    pea     ($0070).w
    clr.l   -(a7)
    pea     ($00FF1004).l
    jsr     (a2)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF09C2).l
    jsr     (a2)
    clr.w   d2
.l0b9d6:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09C2,a0
    move.b  #$ff, (a0,d0.w)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   .l0b9d6
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($00FF09CA).l
    jsr     (a2)
    move.b  #$ff, ($00FF09CA).l
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF09CE).l
    jsr     (a2)
    lea     $30(a7), a7
    clr.w   d2
.l0ba18:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09CE,a0
    move.b  #$ff, (a0,d0.w)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   .l0ba18
    move.w  #$ff, ($00FF09D6).l
    movem.l (a7)+, d2/a2-a5
    rts

; ============================================================================
; func_00BA3E -- (TODO: name)
; 64 bytes | $00BA3E-$00BA7D
; ============================================================================
func_00BA3E:
    movem.l d2/a2, -(a7)
    moveq   #$0,d2
    movea.l  #$00FFA6BA,a2
.l0ba4a:
    moveq   #$0,d0
    move.w  (a2), d0
    bge.b   .l0ba54
    moveq   #$F,d1
    add.l   d1, d0
.l0ba54:
    asr.l   #$4, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    mulu.w  #$a, d0
    move.w  d0, (a2)
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$1, d2
    moveq   #$10,d0
    cmp.l   d2, d0
    bgt.b   .l0ba4a
    movem.l (a7)+, d2/a2
    rts

; ============================================================================
; func_00BA7E -- (TODO: name)
; 518 bytes | $00BA7E-$00BC83
; ============================================================================
func_00BA7E:
    movem.l d2-d6/a2-a5, -(a7)
    movea.l  #$00FF0120,a4
    movea.l  #$00FF0018,a2
    movea.l  #$00FF03F0,a5
    dc.w    $4EB9,$0002,$7AA4                           ; jsr $027AA4
    move.w  d0, d5
    move.l  #$5f5e0ff, d4
    clr.w   d3
.l0baa4:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.b  #$1, $2(a2)
    clr.b   $3(a2)
    clr.b   $4(a2)
    clr.b   $5(a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    addi.l  #$64, d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    addi.l  #$32, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.w  ($00FF0002).l, d1
    ext.l   d1
    addi.l  #$a, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.w  ($00FF0004).l, d1
    ext.l   d1
    moveq   #$A,d6
    sub.l   d1, d6
    move.l  d6, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  #$2710, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.l  #$3e8, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, $6(a2)
    cmpi.w  #$4, ($00FF0004).l
    bne.b   .l0bb64
    tst.w   d5
    beq.b   .l0bb64
    cmpi.b  #$1, (a2)
    bne.b   .l0bb52
    cmp.l   $6(a2), d4
    bge.b   .l0bb4a
    move.l  d4, d0
    bra.b   .l0bb4e
.l0bb4a:
    move.l  $6(a2), d0
.l0bb4e:
    move.l  d0, d4
    bra.b   .l0bb64
.l0bb52:
    cmp.l   $6(a2), d4
    ble.b   .l0bb5c
    move.l  d4, d0
    bra.b   .l0bb60
.l0bb5c:
    move.l  $6(a2), d0
.l0bb60:
    move.l  d0, $6(a2)
.l0bb64:
    clr.l   $a(a2)
    clr.l   $e(a2)
    clr.l   $12(a2)
    clr.l   $16(a2)
    clr.l   $1a(a2)
    clr.l   $1e(a2)
    move.b  #$64, $22(a2)
    moveq   #$24,d0
    adda.l  d0, a2
    move.b  $3(a3), $1(a4)
    move.b  $2(a3), $2(a4)
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   .l0bb9c
    addq.l  #$1, d0
.l0bb9c:
    asr.l   #$1, d0
    moveq   #$64,d1
    cmp.l   d0, d1
    ble.b   .l0bbb2
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   .l0bbae
    addq.l  #$1, d0
.l0bbae:
    asr.l   #$1, d0
    bra.b   .l0bbb4
.l0bbb2:
    moveq   #$64,d0
.l0bbb4:
    move.b  d0, $3(a4)
    moveq   #$0,d2
    move.b  $1(a4), d2
    mulu.w  ($00FF999C).l, d2
    moveq   #$0,d0
    move.b  $2(a4), d0
    mulu.w  ($00FFBA68).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.b  $3(a4), d0
    mulu.w  ($00FF1288).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d2
    move.b  d2, (a4)
    addq.l  #$4, a4
    clr.b   $9(a5)
    clr.b   $a(a5)
    clr.b   $b(a5)
    moveq   #$C,d0
    adda.l  d0, a5
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0464                                 ; jsr $00C06E(pc)
    nop
    addq.l  #$4, a7
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   .l0baa4
    dc.w    $4EBA,$0924                                 ; jsr $00C540(pc)
    nop
    dc.w    $4EBA,$0062                                 ; jsr $00BC84(pc)
    nop
    movea.l  #$00FF0018,a2
    clr.w   d3
.l0bc2e:
    movea.l  #$00FF1298,a3
    clr.w   d2
.l0bc36:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7610                           ; jsr $007610
    addq.l  #$8, a7
    move.w  d3, d1
    mulu.w  #$39, d1
    moveq   #$0,d6
    move.b  (a3), d6
    add.w   d6, d1
    movea.l  #$00FF05C4,a0
    move.b  d0, (a0,d1.w)
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    blt.b   .l0bc36
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0bc2e
    dc.w    $6100,$FDC2                                 ; bsr.w $00BA3E
    movem.l (a7)+, d2-d6/a2-a5
    rts

; ============================================================================
; func_00BC84 -- (TODO: name)
; 1002 bytes | $00BC84-$00C06D
; ============================================================================
func_00BC84:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF0018,a5
    clr.w   d7
    clr.w   -$2(a6)
.l0bc98:
    moveq   #$0,d0
    move.b  $1(a5), d0
    add.w   d0, d7
    addq.w  #$1, -$2(a6)
    cmpi.w  #$4, -$2(a6)
    blt.b   .l0bc98
    move.w  d7, d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, d7
    movea.l  #$00FF0018,a5
    clr.w   -$2(a6)
.l0bcc4:
    moveq   #$0,d0
    move.b  $1(a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$4(a6)
    moveq   #$0,d0
    move.b  $1(a5), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a5), d0
    lsl.w   #$3, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)
    moveq   #$0,d0
    move.b  (a2), d0
    bge.b   .l0bd1a
    addq.l  #$1, d0
.l0bd1a:
    asr.l   #$1, d0
    move.l  d0, d4
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.l   d1, d0
    cmp.l   d0, d4
    bge.b   .l0bd3a
    moveq   #$0,d0
    move.b  (a2), d0
    bge.b   .l0bd36
    addq.l  #$1, d0
.l0bd36:
    asr.l   #$1, d0
    bra.b   .l0bd46
.l0bd3a:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.l   d1, d0
.l0bd46:
    move.w  d0, d4
    move.w  ($00FF0004).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d4
    move.w  ($00FF0004).l, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    moveq   #$32,d1
    sub.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    ext.l   d1
    cmp.l   d1, d0
    ble.b   .l0bd94
    move.w  d4, d0
    ext.l   d0
    bra.b   .l0bda8
.l0bd94:
    move.w  ($00FF0004).l, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    moveq   #$32,d1
    sub.l   d0, d1
    move.l  d1, d0
.l0bda8:
    move.w  d0, d4
    add.b   d4, $1(a2)
    movea.l -$a(a6), a0
    move.b  d4, (a0)
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    move.w  d0, d3
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d6
.l0bdd8:
    addq.w  #$1, d7
    cmpi.w  #$4, d7
    blt.b   .l0bde2
    clr.w   d7
.l0bde2:
    moveq   #$0,d0
    move.b  $2(a4), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $2(a4), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $2(a4), d0
    moveq   #$0,d1
    move.b  $3(a4), d1
    add.w   d1, d0
    move.w  d0, -$6(a6)
    moveq   #$0,d3
    move.b  $2(a4), d3
    bra.w   .l0bf06
.l0be26:
    tst.w   d4
    ble.w   .l0bf0e
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7610                           ; jsr $007610
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.w   .l0bf00
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)
    clr.w   d5
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmpi.w  #$e, d2
    ble.b   .l0be7e
    moveq   #$E,d2
    bra.b   .l0be8c
.l0be7e:
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ext.l   d2
.l0be8c:
    cmp.w   d2, d4
    bge.b   .l0be94
    move.w  d4, d0
    bra.b   .l0be96
.l0be94:
    move.w  d2, d0
.l0be96:
    ext.l   d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  -$4(a6), d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0bec2
    tst.w   d6
    bne.b   .l0beee
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    bge.b   .l0bebc
    addq.l  #$1, d0
.l0bebc:
    asr.l   #$1, d0
    move.l  d0, -(a7)
    bra.b   .l0bee4
.l0bec2:
    tst.w   d6
    ble.b   .l0beee
    move.w  d3, d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0beee
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
.l0bee4:
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.w  d0, d2
.l0beee:
    cmpi.w  #$1, d5
    bne.b   .l0bf00
    add.b   d2, $1(a2)
    movea.l -$a(a6), a0
    move.b  d2, (a0)
    sub.w   d2, d4
.l0bf00:
    addq.l  #$4, a3
    addq.l  #$2, a2
    addq.w  #$1, d3
.l0bf06:
    cmp.w   -$6(a6), d3
    blt.w   .l0be26
.l0bf0e:
    tst.w   d4
    ble.w   .l0c048
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a4), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  (a4), d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    add.w   d1, d0
    move.w  d0, -$6(a6)
    moveq   #$0,d3
    move.b  (a4), d3
    bra.w   .l0c040
.l0bf50:
    tst.w   d4
    ble.w   .l0c048
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a5), d1
    cmp.l   d1, d0
    beq.w   .l0c03a
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7610                           ; jsr $007610
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.w   .l0c03a
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  -$2(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)
    clr.w   d5
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmpi.w  #$e, d2
    ble.b   .l0bfb8
    moveq   #$E,d2
    bra.b   .l0bfc6
.l0bfb8:
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ext.l   d2
.l0bfc6:
    cmp.w   d2, d4
    bge.b   .l0bfce
    move.w  d4, d0
    bra.b   .l0bfd0
.l0bfce:
    move.w  d2, d0
.l0bfd0:
    ext.l   d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  -$4(a6), d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0bffc
    tst.w   d6
    bne.b   .l0c028
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    bge.b   .l0bff6
    addq.l  #$1, d0
.l0bff6:
    asr.l   #$1, d0
    move.l  d0, -(a7)
    bra.b   .l0c01e
.l0bffc:
    tst.w   d6
    ble.b   .l0c028
    move.w  d3, d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0c028
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
.l0c01e:
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.w  d0, d2
.l0c028:
    cmpi.w  #$1, d5
    bne.b   .l0c03a
    add.b   d2, $1(a2)
    movea.l -$a(a6), a0
    move.b  d2, (a0)
    sub.w   d2, d4
.l0c03a:
    addq.l  #$4, a3
    addq.l  #$2, a2
    addq.w  #$1, d3
.l0c040:
    cmp.w   -$6(a6), d3
    blt.w   .l0bf50
.l0c048:
    addq.w  #$1, d6
    cmpi.w  #$5, d6
    blt.w   .l0bdd8
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, -$2(a6)
    cmpi.w  #$4, -$2(a6)
    blt.w   .l0bcc4
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00C06E -- (TODO: name)
; 318 bytes | $00C06E-$00C1AB
; ============================================================================
func_00C06E:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$00FFB9E8,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a3), d0
    movea.l  #$00FF99A4,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    cmpi.w  #$2, d2
    beq.b   .l0c0c2
    cmpi.w  #$3, d2
    bne.b   .l0c0c6
.l0c0c2:
    moveq   #$2,d2
    bra.b   .l0c0dc
.l0c0c6:
    cmpi.w  #$4, d2
    bcs.b   .l0c0dc
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.w  d0, d2
.l0c0dc:
    move.w  ($00FF0002).l, d0
    mulu.w  #$12, d0
    move.w  d2, d1
    mulu.w  #$6, d1
    add.w   d1, d0
    movea.l  #$0005F96E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    move.l  d0, d2
    lea     (a5,d0.l), a0
    moveq   #$0,d1
    move.w  (a4), d1
    add.l   d1, d1
    adda.l  d1, a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    addi.l  #$a, d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.b  d0, (a2)
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  ($00FF0002).l, d1
    ext.l   d1
    addq.l  #$3, d1
    cmp.l   d1, d0
    bge.b   .l0c144
    moveq   #$0,d0
    move.b  (a2), d0
    bra.b   .l0c14e
.l0c144:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    addq.l  #$3, d0
.l0c14e:
    move.b  d0, (a2)
    move.b  (a2), $1(a2)
    lea     (a5,d2.l), a0
    moveq   #$0,d0
    move.w  $2(a4), d0
    add.l   d0, d0
    adda.l  d0, a0
    movea.l a0, a2
    move.w  ($00FF0004).l, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    add.b   d0, (a2)
    move.b  (a2), $1(a2)
    lea     (a5,d2.l), a0
    moveq   #$0,d0
    move.w  $4(a4), d0
    add.l   d0, d0
    adda.l  d0, a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$28,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    add.b   d0, (a2)
    move.b  (a2), $1(a2)
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ============================================================================
; func_00C1AC -- (TODO: name)
; 486 bytes | $00C1AC-$00C391
; ============================================================================
func_00C1AC:
    link    a6,#$0
    movem.l d2/a2-a4, -(a7)
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
.l0c1c6:
    pea     ($001E).w
    pea     ($001D).w
    pea     ($0001).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     ($000A).w
    pea     ($001F).w
    pea     ($0002).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    lea     $20(a7), a7
    movea.l  #$00FF0018,a2
    clr.w   d2
.l0c1fe:
    move.w  d2, d0
    ext.l   d0
    addi.l  #$774, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0007).w
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$6760                           ; jsr $006760
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($0003E5F2).l
    jsr     (a3)
    lea     $30(a7), a7
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($000B).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F926,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E5EE).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E5EA).l
    jsr     (a3)
    lea     $20(a7), a7
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0c1fe
    pea     ($0003).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0003E5E4).l
    jsr     (a3)
    pea     ($0005).w
    pea     ($001C).w
    jsr     (a4)
    move.w  ($00FF0002).l, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5E0).l
    jsr     (a3)
    pea     ($0008).w
    pea     ($001A).w
    jsr     (a4)
    move.w  ($00FF0004).l, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5DA).l
    jsr     (a3)
    lea     $2c(a7), a7
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    dc.w    $4EBA,$0074                                 ; jsr $00C392(pc)
    nop
    move.w  d0, d2
    cmpi.w  #$1, d2
    bne.b   .l0c33c
    pea     ($0001).w
    dc.w    $4EBA,$0F1C                                 ; jsr $00D24C(pc)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bra.b   .l0c33e
.l0c33c:
    tst.w   d2
.l0c33e:
    bne.w   .l0c1c6
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000475F8).l, -(a7)
    clr.l   -(a7)
    dc.w    $4EBA,$02CA                                 ; jsr $00C61E(pc)
    nop
    move.w  d0, d2
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    clr.l   -(a7)
    pea     ($0008).w
    pea     ($0007).w
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    dc.w    $4EB9,$0003,$A9AC                           ; jsr $03A9AC
    move.w  d2, d0
    movem.l -$10(a6), d2/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_00C392 -- (TODO: name)
; 34 bytes | $00C392-$00C3B3
; ============================================================================
func_00C392:
    move.l  d2, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0003E5F6).l
    clr.l   -(a7)
    dc.w    $4EBA,$0278                                 ; jsr $00C61E(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_00C3B4 -- (TODO: name)
; 396 bytes | $00C3B4-$00C53F
; ============================================================================
func_00C3B4:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF0018,a5
    clr.w   d6
    move.w  d6, d0
    mulu.w  #$a, d0
    movea.l  #$00FF03B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$00FF03E0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
.l0c3e6:
    moveq   #$0,d0
    move.b  $1(a5), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    ext.l   d0
    moveq   #$7,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    move.w  d0, d5
    pea     ($000E).w
    pea     -$e(a6)
    move.w  d5, d0
    mulu.w  #$e, d0
    movea.l  #$00047692,a0
    pea     (a0, d0.w)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    lea     $10(a7), a7
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00047684,a0
    move.w  (a0,d0.w), d2
    clr.w   d3
    move.w  d2, d0
    sub.w   d3, d0
    add.w   d0, d0
    lea     -$10(a6, d0.w), a0
    movea.l a0, a2
    bra.b   .l0c46e
.l0c440:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d3, d1
    sub.l   d1, d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.w  d0, d4
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d7
    move.w  d4, d0
    add.w   d0, d0
    move.w  (a2), -$e(a6, d0.w)
    move.w  d7, (a2)
    subq.l  #$2, a2
    addq.w  #$1, d3
.l0c46e:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d2, d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    blt.b   .l0c440
    pea     ($000A).w
    move.l  a4, -(a7)
    pea     -$e(a6)
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    lea     $c(a7), a7
    cmpi.w  #$5, d5
    bne.w   .l0c51c
    pea     ($0003).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D6A4                           ; jsr $01D6A4
    addq.l  #$8, a7
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l  #$000473A0,a0
    move.l  (a0,d0.l), (a3)
    clr.w   d4
    clr.w   d2
    moveq   #$0,d0
    move.w  d4, d0
    add.l   d0, d0
    lea     (a4,d0.l), a0
    movea.l a0, a2
    bra.b   .l0c514
.l0c4ca:
    move.w  (a2), d5
    cmpi.w  #$1b, d5
    bcs.b   .l0c4ee
    cmpi.w  #$1d, d5
    bhi.b   .l0c4ee
    move.w  d2, d0
    andi.w  #$1, d0
    bne.b   .l0c4ee
    move.w  d3, d0
    add.w   d0, d0
    addi.w  #$21, d0
    move.w  d0, (a2)
    ori.w   #$1, d2
.l0c4ee:
    cmpi.w  #$1e, d5
    bcs.b   .l0c510
    cmpi.w  #$20, d5
    bhi.b   .l0c510
    move.w  d2, d0
    andi.w  #$2, d0
    bne.b   .l0c510
    move.w  d3, d0
    add.w   d0, d0
    addi.w  #$22, d0
    move.w  d0, (a2)
    ori.w   #$2, d2
.l0c510:
    addq.l  #$2, a2
    addq.w  #$1, d4
.l0c514:
    cmpi.w  #$5, d4
    bcs.b   .l0c4ca
    bra.b   .l0c522
.l0c51c:
    move.l  ($00047390).l, (a3)
.l0c522:
    addq.l  #$4, a3
    moveq   #$A,d0
    adda.l  d0, a4
    addq.w  #$1, d6
    moveq   #$24,d0
    adda.l  d0, a5
    cmpi.w  #$4, d6
    bcs.w   .l0c3e6
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00C540 -- (TODO: name)
; 222 bytes | $00C540-$00C61D
; ============================================================================
func_00C540:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    pea     ($0020).w
    clr.l   -(a7)
    pea     -$20(a6)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    move.w  ($00FF0002).l, d0
    movea.l  #$0005ECF8,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    pea     ($00C0).w
    pea     ($00FF).w
    pea     ($00FFA6B8).l
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    lea     $18(a7), a7
    movea.l  #$00FFA6B8,a3
    movea.l  #$00FF1278,a4
    clr.w   d4
.l0c594:
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$0005EDD0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    lea     -$20(a6), a5
    clr.w   d3
    moveq   #$0,d2
    move.w  d5, d2
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d2
.l0c5b6:
    tst.w   (a5)
    bne.b   .l0c5e8
    move.b  (a3), d0
    cmp.b   (a2), d0
    bhi.b   .l0c5d0
    move.b  (a3), d0
    cmp.b   (a2), d0
    bne.b   .l0c5e8
    move.b  $6(a3), d0
    cmp.b   $6(a2), d0
    bls.b   .l0c5e8
.l0c5d0:
    pea     ($000C).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    lea     $14(a7), a7
    move.b  d2, (a4)
.l0c5e8:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a5
    addq.l  #$1, d2
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.b   .l0c5b6
    moveq   #$0,d0
    move.b  (a4), d0
    sub.w   d5, d0
    add.w   d0, d0
    move.w  #$1, -$20(a6, d0.w)
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$1, a4
    addq.w  #$1, d4
    cmpi.w  #$10, d4
    bcs.b   .l0c594
    movem.l -$40(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00C61E -- (TODO: name)
; 108 bytes | $00C61E-$00C689
; ============================================================================
func_00C61E:
    link    a6,#$0
    move.l  d2, -(a7)
    move.l  $c(a6), -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $12(a6), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0780).w
    pea     ($0035).w
    dc.w    $4EB9,$0000,$643C                           ; jsr $00643C
    lea     $20(a7), a7
    cmpi.w  #$1, $16(a6)
    bne.b   .l0c66a
    pea     ($001A).w
    pea     ($0008).w
    dc.w    $4EB9,$0000,$7784                           ; jsr $007784
    addq.l  #$8, a7
    move.w  d0, d2
    bra.b   .l0c680
.l0c66a:
    cmpi.w  #$1, $1a(a6)
    bne.b   .l0c680
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
.l0c680:
    move.w  d2, d0
    move.l  -$4(a6), d2
    unlk    a6
    rts

; ============================================================================
; func_00C68A -- (TODO: name)
; 470 bytes | $00C68A-$00C85F
; ============================================================================
func_00C68A:
    link    a6,#-$8
    movem.l d2/a2-a5, -(a7)
    pea     ($0039).w
    pea     ($00FF99A4).l
    clr.l   -(a7)
    pea     ($0005EC10).l
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    pea     ($00C0).w
    pea     ($00FF1704).l
    clr.l   -(a7)
    pea     ($0005F0C6).l
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    lea     $28(a7), a7
    pea     ($00E4).w
    pea     ($00FF1620).l
    clr.l   -(a7)
    pea     ($0005F186).l
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    pea     ($0040).w
    pea     ($00FF0728).l
    clr.l   -(a7)
    pea     ($0005F532).l
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    lea     $28(a7), a7
    tst.w   ($00FF0002).l
    bne.b   .l0c74a
    pea     ($0164).w
    pea     ($00FF1298).l
    clr.l   -(a7)
    pea     ($0005F26A).l
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    lea     $14(a7), a7
    pea     ($00B2).w
    pea     ($00FF8824).l
    clr.l   -(a7)
    pea     ($0005F572).l
.l0c73a:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    lea     $14(a7), a7
    bra.w   .l0c856
.l0c74a:
    cmpi.w  #$3, ($00FF0002).l
    bne.b   .l0c786
    pea     ($0164).w
    pea     ($00FF1298).l
    clr.l   -(a7)
    pea     ($0005F3CE).l
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    lea     $14(a7), a7
    pea     ($00B2).w
    pea     ($00FF8824).l
    clr.l   -(a7)
    pea     ($0005F624).l
    bra.b   .l0c73a
.l0c786:
    movea.l  #$0005F26A,a4
    movea.l  #$0005F3CE,a3
    movea.l  #$00FF1298,a2
    move.l  #$5f572, -$4(a6)
    move.l  #$5f624, -$8(a6)
    movea.l  #$00FF8824,a5
    clr.w   d2
.l0c7b0:
    move.b  (a3), (a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0098                                 ; jsr $00C860(pc)
    nop
    move.b  d0, $1(a2)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$007A                                 ; jsr $00C860(pc)
    nop
    move.b  d0, $2(a2)
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$005C                                 ; jsr $00C860(pc)
    nop
    move.b  d0, $3(a2)
    movea.l -$8(a6), a0
    move.b  (a0), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    movea.l -$4(a6), a0
    move.b  (a0), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0032                                 ; jsr $00C860(pc)
    nop
    lea     $20(a7), a7
    move.b  d0, (a5)
    clr.b   $1(a5)
    addq.l  #$4, a4
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.l  #$2, -$4(a6)
    addq.l  #$2, -$8(a6)
    addq.l  #$2, a5
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.w   .l0c7b0
.l0c856:
    movem.l -$1c(a6), d2/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00C860 -- (TODO: name)
; 82 bytes | $00C860-$00C8B1
; ============================================================================
func_00C860:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    move.w  $e(a7), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.w  ($00FF0002).l, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$3,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    add.w   d2, d0
    move.w  d0, d2
    tst.w   d2
    ble.b   .l0c896
    move.w  d2, d0
    ext.l   d0
    bra.b   .l0c898
.l0c896:
    moveq   #$0,d0
.l0c898:
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bge.b   .l0c8a6
    move.w  d2, d0
    ext.l   d0
    bra.b   .l0c8ac
.l0c8a6:
    move.l  #$ff, d0
.l0c8ac:
    move.w  d0, d2
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_00C8B2 -- (TODO: name)
; 396 bytes | $00C8B2-$00CA3D
; ============================================================================
func_00C8B2:
    link    a6,#-$14
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF13FC,a2
    lea     -$12(a6), a3
    movea.l  #$00000D64,a4
    movea.l  #$00FFA7D8,a5
    move.w  #$ff, d3
    clr.w   d6
    clr.w   d7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    clr.w   d2
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l0c900
    moveq   #$1,d4
    bra.b   .l0c902
.l0c900:
    moveq   #$0,d4
.l0c902:
    clr.w   d5
    clr.w   (a2)
    clr.w   (a5)
.l0c908:
    cmpi.w  #$ff, d2
    beq.b   .l0c912
    cmp.w   d3, d2
    beq.b   .l0c96e
.l0c912:
    pea     ($000E).w
    move.l  a3, -(a7)
    pea     ($000767AE).l
    dc.w    $4EB9,$0000,$45B2                           ; jsr $0045B2
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  ($000767BC).l, (a3,a0.l)
    pea     ($0007).w
    pea     ($0038).w
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    lea     $18(a7), a7
    cmpi.w  #$ff, d2
    beq.b   .l0c97a
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0004).w
    dc.w    $4EB9,$0000,$9F88                           ; jsr $009F88
    lea     $10(a7), a7
    move.w  d2, d3
    bra.b   .l0c97a
.l0c96e:
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
.l0c97a:
    tst.w   d4
    beq.b   .l0c99c
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0c99c
    pea     ($0002).w
.l0c990:
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   .l0c908
.l0c99c:
    clr.w   d4
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    andi.w  #$3f, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.b   .l0c9c6
    clr.w   (a2)
    clr.w   (a5)
    cmpi.w  #$ff, d2
    beq.b   .l0ca2a
    bra.b   .l0ca32
.l0c9c6:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l0c9d8
    clr.w   (a2)
    clr.w   (a5)
    move.w  #$ff, d2
    bra.b   .l0ca32
.l0c9d8:
    move.w  d5, d0
    andi.w  #$f, d0
    beq.b   .l0ca2a
    move.w  #$1, (a2)
    move.w  d5, d0
    andi.w  #$8, d0
    beq.b   .l0c9f2
    addq.w  #$1, d6
    andi.w  #$3, d6
.l0c9f2:
    move.w  d5, d0
    andi.w  #$4, d0
    beq.b   .l0ca00
    addq.w  #$3, d6
    andi.w  #$3, d6
.l0ca00:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0ca0a
    clr.w   d7
.l0ca0a:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l0ca14
    moveq   #$1,d7
.l0ca14:
    move.w  d6, d0
    add.w   d0, d0
    add.w   d7, d0
    movea.l  #$0005F6D6,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
.l0ca2a:
    pea     ($0003).w
    bra.w   .l0c990
.l0ca32:
    move.w  d2, d0
    movem.l -$3c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00CA3E -- (TODO: name)
; 1196 bytes | $00CA3E-$00CEE9
; ============================================================================
func_00CA3E:
    movem.l d2-d3/a2-a4, -(a7)
    move.l  $18(a7), d3
    movea.l  #$0001D538,a4
    movea.l  #$00FF1804,a3
    pea     ($2000).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$D,d1
    lsl.l   d1, d0
    addi.l  #$200003, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0001,$E0FE                           ; jsr $01E0FE
    addq.l  #$6, a3
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0002).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0004).l
    pea     ($0002).w
    pea     ($00FF0006).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    addq.l  #$2, a3
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0008).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000A).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000C).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000E).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0010).l
    move.w  ($00FF0002).l, d0
    mulu.w  #$3c, d0
    addi.w  #$50, d0
    move.w  d0, ($00FFA6B2).l
    dc.w    $6100,$FB9E                                 ; bsr.w $00C68A
    dc.w    $6100,$FA50                                 ; bsr.w $00C540
    pea     ($0004).w
    pea     ($00FF0012).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$4, a3
    move.b  (a3)+, ($00FF0016).l
    pea     ($0090).w
    pea     ($00FF0018).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $90(a3), a3
    pea     ($0040).w
    pea     ($00FF00A8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$40,d0
    adda.l  d0, a3
    pea     ($0030).w
    pea     ($00FF00E8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$30,d0
    adda.l  d0, a3
    pea     ($0008).w
    pea     ($00FF0118).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$8, a3
    pea     ($0010).w
    pea     ($00FF0120).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
    pea     ($0080).w
    pea     ($00FF0130).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $80(a3), a3
    pea     ($0080).w
    pea     ($00FF01B0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $80(a3), a3
    pea     ($0040).w
    pea     ($00FF0230).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$40,d0
    adda.l  d0, a3
    pea     ($0020).w
    pea     ($00FF0270).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$20,d0
    adda.l  d0, a3
    pea     ($0018).w
    pea     ($00FF0290).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$18,d0
    adda.l  d0, a3
    clr.w   d3
.l0cc2c:
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l0cc3e:
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    move.b  (a2), $1(a2)
    addq.l  #$1, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   .l0cc3e
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0cc2c
    pea     ($0050).w
    pea     ($00FF02E8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$50,d0
    adda.l  d0, a3
    pea     ($0080).w
    pea     ($00FF0338).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $80(a3), a3
    pea     ($0028).w
    pea     ($00FF03B8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$28,d0
    adda.l  d0, a3
    pea     ($0010).w
    pea     ($00FF03E0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
    pea     ($0030).w
    pea     ($00FF03F0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$30,d0
    adda.l  d0, a3
    pea     ($00C0).w
    pea     ($00FF0420).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $c0(a3), a3
    pea     ($00E4).w
    pea     ($00FF04E0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $e4(a3), a3
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$EFC8                           ; jsr $00EFC8
    movea.l d0, a3
    pea     ($0040).w
    pea     ($00FF0728).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$40,d0
    adda.l  d0, a3
    movea.l  #$00FF8824,a2
    clr.w   d2
.l0cd5e:
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    addq.l  #$1, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    blt.b   .l0cd5e
    movea.l  #$00FFBA80,a2
    clr.w   d2
.l0cd88:
    clr.w   d3
.l0cd8a:
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    addq.l  #$1, a3
    addq.l  #$2, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0cd8a
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    blt.b   .l0cd88
    pea     ($0010).w
    pea     ($00FF08EC).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
    clr.w   d3
.l0cdd4:
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l0cde8:
    pea     ($000C).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$C,d0
    adda.l  d0, a3
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$28, d2
    blt.b   .l0cde8
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0cdd4
    pea     ($0004).w
    pea     ($00FF099C).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$4, a3
    pea     ($0001).w
    pea     ($00FF09A0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    addq.l  #$1, a3
    pea     ($0020).w
    pea     ($00FF09A2).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$20,d0
    adda.l  d0, a3
    move.l  a3, -(a7)
    dc.w    $4EB9,$0000,$F086                           ; jsr $00F086
    movea.l d0, a3
    pea     ($0059).w
    pea     ($00FF09D8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$59,d0
    adda.l  d0, a3
    pea     ($0002).w
    pea     ($00FF0A32).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$2, a3
    pea     ($0002).w
    pea     ($00FF0A34).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    dc.w    $4EBA,$002E                                 ; jsr $00CEEA(pc)
    nop
    move.w  ($00FF000C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$D340                           ; jsr $01D340
    move.w  ($00FF000E).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$D37A                           ; jsr $01D37A
    lea     $30(a7), a7
    movem.l (a7)+, d2-d3/a2-a4
    rts

; ============================================================================
; func_00CEEA -- (TODO: name)
; 804 bytes | $00CEEA-$00D20D
; ============================================================================
func_00CEEA:
    link    a6,#-$8
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0018,a4
    clr.w   d2
.l0cefa:
    moveq   #$0,d0
    move.b  $1(a4), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  d1, (a0,d0.w)
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    move.w  d2, d0
    mulu.w  #$7, d0
    movea.l  #$00FFA7BC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d2, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
.l0cf4c:
    cmpi.b  #$ff, (a2)
    beq.w   .l0d110
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d3
    cmpi.b  #$20, (a2)
    bcc.b   .l0cf84
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   .l0cfb2
.l0cf84:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECBE,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    sub.w   d1, d0
    moveq   #$1,d1
    lsl.w   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    add.l   -$4(a6), d1
    movea.l d1, a0
    or.w    d0, (a0)
.l0cfb2:
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d5
    cmpi.b  #$20, $1(a2)
    bcc.b   .l0cfe8
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   .l0d018
.l0cfe8:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECBE,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    sub.w   d1, d0
    moveq   #$1,d1
    lsl.w   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    add.l   -$4(a6), d1
    movea.l d1, a0
    or.w    d0, (a0)
.l0d018:
    cmp.w   d5, d3
    beq.b   .l0d030
    moveq   #$1,d0
    lsl.b   d5, d0
    movea.w d3, a0
    or.b    d0, (a5,a0.w)
    moveq   #$1,d0
    lsl.b   d3, d0
    movea.w d5, a0
    or.b    d0, (a5,a0.w)
.l0d030:
    moveq   #$0,d0
    move.w  $8(a2), d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, $10(a2)
    moveq   #$0,d0
    move.w  $8(a2), d0
    moveq   #$0,d1
    move.w  $4(a2), d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  #$2710, d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, $e(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$8(a6)
    move.b  $3(a2), d0
    add.b   d0, $1(a3)
    movea.l -$8(a6), a0
    move.b  $3(a2), d0
    add.b   d0, $1(a0)
    move.b  $2(a2), d3
    andi.w  #$f, d3
    moveq   #$0,d5
    move.b  $2(a2), d5
    asr.l   #$4, d5
    andi.w  #$f, d5
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    sub.b   d3, $1(a3)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7412                           ; jsr $007412
    lea     $c(a7), a7
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.b  d0, $b(a2)
.l0d110:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d4
    cmpi.w  #$28, d4
    blt.w   .l0cf4c
    moveq   #$24,d0
    adda.l  d0, a4
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0cefa
    movea.l  #$00FFBA80,a3
    movea.l  #$00FF8824,a4
    movea.l  #$00FF1298,a2
    clr.w   d3
.l0d140:
    clr.w   d2
.l0d142:
    move.b  (a3), d0
    add.b   d0, $1(a4)
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0d142
    addq.l  #$4, a2
    addq.l  #$2, a4
    addq.w  #$1, d3
    cmpi.w  #$59, d3
    blt.b   .l0d140
    movea.l  #$00FF0018,a4
    clr.w   d2
.l0d166:
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    bra.b   .l0d1e8
.l0d18e:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  $8(a2), d0
    bge.b   .l0d1b2
    moveq   #$7F,d1
    add.l   d1, d0
.l0d1b2:
    asr.l   #$7, d0
    add.l   d0, (a3)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$8, a7
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  $8(a2), d0
    bge.b   .l0d1de
    moveq   #$7F,d1
    add.l   d1, d0
.l0d1de:
    asr.l   #$7, d0
    add.l   d0, (a3)
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d4
.l0d1e8:
    move.w  d4, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $4(a4), d1
    cmp.l   d1, d0
    blt.b   .l0d18e
    moveq   #$24,d0
    adda.l  d0, a4
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0d166
    movem.l -$28(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00D20E -- (TODO: name)
; 62 bytes | $00D20E-$00D24B
; ============================================================================
func_00D20E:
    movem.l d2-d3/a2, -(a7)
    movea.l  #$0005FAB6,a2
    clr.w   d2
.l0d21a:
    move.w  (a2), d3
    lsl.w   #$2, d3
    add.w   $2(a2), d3
    addi.w  #$e174, d3
    cmp.w   ($00FF0006).l, d3
    bgt.b   .l0d23c
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0002,$8EBE                           ; jsr $028EBE
    addq.l  #$4, a7
.l0d23c:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$37, d2
    bcs.b   .l0d21a
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; func_00D24C -- (TODO: name)
; 64 bytes | $00D24C-$00D28B
; ============================================================================
func_00D24C:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
.l0d254:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0030                                 ; jsr $00D28C(pc)
    nop
    addq.l  #$4, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   .l0d270
    moveq   #$1,d0
    bra.b   .l0d286
.l0d270:
    cmpi.w  #$1, d2
    bne.b   .l0d254
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$6958                           ; jsr $016958
    addq.l  #$4, a7
    bra.b   .l0d254
.l0d286:
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; func_00D28C -- (TODO: name)
; 394 bytes | $00D28C-$00D415
; ============================================================================
func_00D28C:
    link    a6,#-$80
    movem.l d2-d3/a2, -(a7)
    movea.l  #$00000D64,a2
    move.w  $a(a6), d0
    lsl.w   #$2, d0
    movea.l  #$000476F4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E628).l
    pea     -$80(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    pea     ($000C).w
    pea     ($0003).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    pea     ($0003E622).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$80(a6)
    clr.l   -(a7)
    dc.w    $6100,$F326                                 ; bsr.w $00C61E
    lea     $14(a7), a7
    clr.w   d3
.l0d300:
    move.w  d3, d2
    add.w   d2, d2
    addq.w  #$3, d2
    cmpi.w  #$4, d3
    bne.b   .l0d30e
    addq.w  #$1, d2
.l0d30e:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0544).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
.l0d33e:
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
    addq.l  #$8, a7
    move.w  d0, d2
    andi.l  #$33, d0
    beq.b   .l0d33e
    move.w  d2, d0
    andi.w  #$20, d0
    beq.b   .l0d390
    cmpi.w  #$4, d3
    bne.b   .l0d3d2
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    moveq   #-$1,d3
    bra.b   .l0d3d2
.l0d390:
    move.w  d2, d0
    andi.w  #$3, d0
    beq.w   .l0d300
    move.w  d2, d0
    andi.w  #$1, d0
    beq.b   .l0d3ba
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0d3b2
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0d3b4
.l0d3b2:
    moveq   #$0,d0
.l0d3b4:
    move.w  d0, d3
    bra.w   .l0d300
.l0d3ba:
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   .l0d3ce
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0d3b4
.l0d3ce:
    moveq   #$4,d0
    bra.b   .l0d3b4
.l0d3d2:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($000C).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0013).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    move.w  d3, d0
    movem.l -$8c(a6), d2-d3/a2
    unlk    a6
    rts

; ============================================================================
; func_00D416 -- (TODO: name)
; 234 bytes | $00D416-$00D4FF
; ============================================================================
func_00D416:
    link    a6,#-$60
    movem.l d2/a2, -(a7)
    movea.l  #$00000D64,a2
    clr.w   ($00FFA790).l
    move.l  #$8c81, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    pea     ($000C).w
    jsr     (a2)
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    pea     ($0001).w
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D8F4                           ; jsr $01D8F4
    pea     ($0033).w
    pea     ($0200).w
    pea     ($00001D88).l
    dc.w    $4EB9,$0000,$45E6                           ; jsr $0045E6
    lea     $28(a7), a7
    clr.w   d2
.l0d470:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0004771C,a0
    move.w  (a0,d0.w), d0
    addi.w  #$200, d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$60(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$30, d2
    bcs.b   .l0d470
    pea     -$60(a6)
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000C).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($000476FC).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    pea     ($0004).w
    jsr     (a2)
    lea     $2c(a7), a7
    andi.l  #$f, d0
    moveq   #$F,d1
    cmp.l   d0, d1
    bne.b   .l0d4da
    moveq   #$0,d0
    bra.b   .l0d4e0
.l0d4da:
    move.l  #$ffff, d0
.l0d4e0:
    move.w  d0, ($00FFA790).l
    dc.w    $4EB9,$0000,$5060                           ; jsr $005060
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    movem.l -$68(a6), d2/a2
    unlk    a6
    rts

; ============================================================================
; func_00D500 -- (TODO: name)
; 88 bytes | $00D500-$00D557
; ============================================================================
func_00D500:
    pea     ($0040).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    dc.w    $4EB9,$0001,$DE92                           ; jsr $01DE92
    dc.w    $4EB9,$0003,$A7A0                           ; jsr $03A7A0
    rts

; ============================================================================
; func_00D558 -- (TODO: name)
; 94 bytes | $00D558-$00D5B5
; ============================================================================
func_00D558:
    move.w  #$101, ($00FF1274).l
    move.w  #$ffff, ($00FFBD52).l
    moveq   #$21,d0
    move.l  d0, ($00FFA7E0).l
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF159C).l
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    move.w  #$8001, ($00FF0A34).l
    pea     ($0038).w
    clr.l   -(a7)
    pea     ($00FFBDAC).l
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    pea     ($0000625C).l
    pea     ($0001).w
    pea     ($0022).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
    rts

; ============================================================================
; GameEntry -- Main game entry point (called after boot initialization)
; ============================================================================
; Sets up game state, initializes subsystems, configures display, then enters
; the main loop. Called once from boot code via jmp.
; ============================================================================
GameEntry:                                                   ; $00D5B6
    dc.w    $4EB9,$0000,$5736                                ; jsr PreGameInit [$5736]
    dc.w    $6100,$FE58                                      ; bsr.w GameInit1 [$D416]
    dc.w    $6100,$FF96                                      ; bsr.w GameInit2 [$D558]
    pea     ($0001).w                                        ; Push argument 1
    dc.w    $4EB9,$0003,$B428                                ; jsr GameSetup1 [$3B428]
    dc.w    $4EB9,$0003,$CA4E                                ; jsr GameSetup2 [$3CA4E]
    dc.w    $6100,$FF2A                                      ; bsr.w GameInit5 [$D500]
    pea     ($0010).w                                        ; Push display mode $10
    clr.l   -(sp)                                            ; Push zero (default param)
    pea     $0007651E                                        ; Push display config ptr
    dc.w    $4EB9,$0000,$5092                                ; jsr DisplaySetup [$5092]
    lea     $10(sp),sp                                       ; Clean 16 bytes of stack args
    dc.w    $4EB9,$0000,$A006                                ; jsr PostDisplayInit [$A006]
    dc.w    $4EBA,$000C                                      ; jsr GameLoopSetup(pc) [$D602]
    nop
    clr.w   $00FF0006                                        ; Clear per-frame update flag
    rts
; ============================================================================
; GameLoopSetup -- One-time loop init (falls through to MainLoop)
; ============================================================================
GameLoopSetup:                                               ; $00D602
    dc.w    $4EB9,$0001,$E398                                ; jsr PreLoopInit [$1E398]
; ============================================================================
; MainLoop -- Main game loop (runs every frame, iterates forever)
; ============================================================================
MainLoop:                                                    ; $00D608
    dc.w    $4EB9,$0002,$F5A6                                ; jsr GameUpdate1 [$2F5A6]
    dc.w    $4EB9,$0001,$B49A                                ; jsr GameUpdate2 [$1B49A]
    clr.w   $00FF17C4                                        ; Clear per-frame work flag
    dc.w    $4EB9,$0002,$13B6                                ; jsr GameLogic1 [$213B6]
    dc.w    $4EB9,$0002,$947A                                ; jsr GameLogic2 [$2947A]
    pea     ($0001).w                                        ; Push argument 1
    dc.w    $4EB9,$0001,$819C                                ; jsr GameCall [$1819C]
    addq.l  #4,sp                                            ; Clean up pea argument
    dc.w    $4EB9,$0001,$E402                                ; jsr GameUpdate3 [$1E402]
    dc.w    $4EB9,$0002,$6128                                ; jsr GameUpdate4 [$26128]
    addq.w  #1,$00FF0006                                     ; Increment frame counter
    bra.s   MainLoop                                         ; Loop forever
; ---
    rts                                                      ; $00D646 (dead code after MainLoop bra.s)
; ===========================================================================
; RangeLookup -- Map a value to a table index (0-7)
;   In:  4(sp) = value to look up (longword on stack)
;   Out: D0.w = index (0-7), or $FF if out of range
;   Table: 8 entries x 4 bytes at $5ECBC, cumulative thresholds
;   Value < 32: search bytes [0]+[1]; 32-88: search bytes [2]+[3]
;   Value 89: returns 7; Value >= 90: returns $FF
;   114 calls
; ===========================================================================
RangeLookup:                                                ; $00D648
    movem.l d2-d3,-(sp)               ; save D2-D3
    move.l  $000C(sp),d3              ; D3 = argument (past saved regs + return addr)
    movea.l #$0005ECBC,a0             ; A0 = range table in ROM
    cmpi.w  #$0020,d3                 ; value < 32?
    bge.s   .range2                    ; no, try second range
; --- Range 1: value 0-31, search using table bytes [0]+[1] ---
    clr.w   d2                         ; D2 = index counter
.loop1:                                                     ; $00D65E
    moveq   #0,d0
    move.b  (a0),d0                    ; D0 = entry byte 0
    moveq   #0,d1
    move.b  1(a0),d1                   ; D1 = entry byte 1
    add.l   d1,d0                      ; D0 = threshold sum
    move.w  d3,d1
    ext.l   d1                         ; D1 = value (sign-extended)
    cmp.l   d1,d0
    bgt.s   .found                     ; threshold > value, match
    addq.l  #4,a0                      ; next table entry
    addq.w  #1,d2                      ; index++
    cmpi.w  #$0007,d2
    bcs.s   .loop1                     ; loop while index < 7
    bra.s   .found                     ; not found, D2 = 7
; --- Range 2: value 32-88, search using table bytes [2]+[3] ---
.range2:                                                    ; $00D67E
    cmpi.w  #$0059,d3                  ; value < 89?
    bge.s   .range3                    ; no, check special cases
    clr.w   d2                         ; D2 = index counter
.loop2:                                                     ; $00D686
    moveq   #0,d0
    move.b  2(a0),d0                   ; D0 = entry byte 2
    moveq   #0,d1
    move.b  3(a0),d1                   ; D1 = entry byte 3
    add.l   d1,d0                      ; D0 = threshold sum
    move.w  d3,d1
    ext.l   d1                         ; D1 = value (sign-extended)
    cmp.l   d1,d0
    bgt.s   .found                     ; threshold > value, match
    addq.l  #4,a0                      ; next table entry
    addq.w  #1,d2                      ; index++
    cmpi.w  #$0007,d2
    bcs.s   .loop2                     ; loop while index < 7
    bra.s   .found                     ; not found, D2 = 7
; --- Range 3: special values ---
.range3:                                                    ; $00D6A8
    cmpi.w  #$005A,d3                  ; value < 90?
    bge.s   .invalid                   ; no, out of range
    moveq   #7,d2                      ; value == 89 -> index 7
    bra.s   .found
.invalid:                                                   ; $00D6B2
    move.w  #$00FF,d2                  ; out of range marker
.found:                                                     ; $00D6B6
    move.w  d2,d0                      ; D0 = result
    movem.l (sp)+,d2-d3               ; restore D2-D3
    rts
; ============================================================================
; RunPlayerTurn -- (TODO: describe)
; Called: ?? times.
; 166 bytes | $00D6BE-$00D763
; ============================================================================
RunPlayerTurn:                                                  ; $00D6BE
    link    a6,#-$4
    movem.l d2-d4,-(sp)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
.ld6ce:                                                 ; $00D6CE
    move.w  ($00FF9A1C).l,d3
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$ff,d0
    beq.b   .ld728
    cmpi.w  #$4,d4
    bge.b   .ld712
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$005c                                 ; jsr $00D764
    nop
    lea     $000c(sp),sp
    bra.b   .ld6ce
.ld712:                                                 ; $00D712
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$118a                                 ; jsr $00E8AA
    nop
    addq.l  #$8,sp
    bra.b   .ld6ce
.ld728:                                                 ; $00D728
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0010(a6),d2-d4
    unlk    a6
    rts
; === Translated block $00D764-$00E08E ===
; 3 functions, 2346 bytes

; ============================================================================
; func_00D764 -- (TODO: name)
; 808 bytes | $00D764-$00DA8B
; ============================================================================
func_00D764:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d5
    lea     $12(a6), a5
    clr.w   -$88(a6)
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6A2E                           ; jsr $006A2E
    lea     $28(a7), a7
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6B78                           ; jsr $006B78
    lea     $c(a7), a7
    bra.w   l_0da52
l_0d804:
    moveq   #$1,d7
    clr.w   d3
    bra.w   l_0d9d2
l_0d80c:
    clr.w   d7
    cmpi.w  #$20, d2
    bge.b   l_0d83c
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d3, d0
    movea.l  #$00FF1704,a0
    move.b  (a0,d0.w), d6
    andi.l  #$ff, d6
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d3, d0
    movea.l  #$00FF0420,a0
    bra.b   l_0d85e
l_0d83c:
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d3, d0
    movea.l  #$00FF15A0,a0
    move.b  (a0,d0.w), d6
    andi.l  #$ff, d6
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d3, d0
    movea.l  #$00FF0460,a0
l_0d85e:
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0816                                 ; jsr $00E08E(pc)
    nop
    lea     $c(a7), a7
    move.l  d0, -$4(a6)
    move.l  $6(a4), d0
    cmp.l   -$4(a6), d0
    blt.w   l_0d9ae
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047798).l, -(a7)
    pea     -$86(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $24(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_0d9d2
    move.l  -$4(a6), d0
    sub.l   d0, $6(a4)
    move.b  #$5, $1(a3)
    move.b  d2, (a3)
    move.b  d3, $2(a3)
    move.b  #$1, $3(a3)
    move.b  d4, d0
    ori.b   #$80, d0
    move.b  d0, (a2)
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    pea     ($000A).w
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    pea     ($000A).w
    pea     ($0028).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0015).w
    dc.w    $4EB9,$0000,$5FF6                           ; jsr $005FF6
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004779C).l, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
    move.w  #$1, -$88(a6)
    bra.b   l_0da04
l_0d9ae:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047794).l, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
l_0d9d2:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0180                                 ; jsr $00DB72(pc)
    nop
    lea     $14(a7), a7
    move.w  d0, d3
    cmpi.w  #$ff, d0
    bne.w   l_0d80c
l_0da04:
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6A2E                           ; jsr $006A2E
    lea     $c(a7), a7
    tst.w   -$88(a6)
    bne.b   l_0da4a
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6B78                           ; jsr $006B78
    lea     $c(a7), a7
l_0da4a:
    cmpi.w  #$1, -$88(a6)
    beq.b   l_0da78
l_0da52:
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     $12(a6)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0026                                 ; jsr $00DA8C(pc)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.w   l_0d804
l_0da78:
    move.w  (a5), ($00FF9A1C).l
    move.w  -$88(a6), d0
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00DA8C -- (TODO: name)
; 230 bytes | $00DA8C-$00DB71
; ============================================================================
func_00DA8C:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    move.l  $18(a7), d4
    movea.l $1c(a7), a2
l_0da9c:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047784).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$8E0C                           ; jsr $008E0C
    lea     $24(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.b   l_0db62
    movea.l  #$00FF09D8,a0
    move.b  (a0,d2.w), d0
    andi.b  #$3, d0
    beq.b   l_0db6a
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477AC).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $20(a7), a7
l_0db62:
    cmpi.w  #$ff, d2
    bne.w   l_0da9c
l_0db6a:
    move.w  d2, d0
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; func_00DB72 -- (TODO: name)
; 1308 bytes | $00DB72-$00E08D
; ============================================================================
func_00DB72:
    link    a6,#-$60
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d7
    movea.l  #$00000D64,a5
    cmpi.w  #$20, d7
    bge.b   l_0dbc4
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d2
l_0dbb0:
    movea.w d2, a0
    cmpi.b  #$f, (a2,a0.w)
    bcc.b   l_0dbf8
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_0dbb0
    bra.b   l_0dbf8
l_0dbc4:
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d2
l_0dbe6:
    movea.w d2, a0
    cmpi.b  #$f, (a2,a0.w)
    bcc.b   l_0dbf8
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_0dbe6
l_0dbf8:
    cmpi.w  #$1, $16(a6)
    bne.b   l_0dc12
    move.w  d7, ($00FFA6B0).l
    dc.w    $4EB9,$0002,$0A64                           ; jsr $020A64
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
l_0dc12:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004778C).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$D,d6
    moveq   #$5,d5
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    lea     $20(a7), a7
    tst.w   d0
    beq.b   l_0dc6c
    moveq   #$1,d0
    bra.b   l_0dc6e
l_0dc6c:
    moveq   #$0,d0
l_0dc6e:
    move.w  d0, -$2(a6)
    clr.w   -$4(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  $1a(a6), d3
    move.w  #$ff, d4
l_0dc8a:
    cmp.w   d3, d4
    beq.w   l_0de02
    move.l  #$8000, -(a7)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000F).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000F).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  d3, d6
    ext.l   d6
    asr.l   #$1, d6
    mulu.w  #$6, d6
    addi.w  #$d, d6
    move.w  d3, d5
    andi.w  #$1, d5
    mulu.w  #$5, d5
    addq.w  #$5, d5
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0544).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    lea     (a2,d3.w), a0
    movea.l a0, a3
    cmpi.b  #$f, (a0)
    bcc.w   l_0de00
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0304                                 ; jsr $00E08E(pc)
    nop
    lea     $1c(a7), a7
    move.l  d0, d4
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($001F).w
    pea     ($0010).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0010).w
    pea     ($0001).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E8CC).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $2c(a7), a7
    pea     ($0010).w
    pea     ($0014).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.l  d4, -(a7)
    pea     ($0003E8C6).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $10(a7), a7
l_0de00:
    move.w  d3, d4
l_0de02:
    tst.w   -$2(a6)
    beq.b   l_0de26
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_0de26
    pea     ($0002).w
l_0de1a:
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   l_0dc8a
l_0de26:
    clr.w   -$2(a6)
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    move.w  d0, -$4(a6)
    andi.w  #$20, d0
    beq.w   l_0df84
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0546).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    movea.w d3, a0
    cmpi.b  #$f, (a2,a0.w)
    bcc.w   l_0df84
    movea.w d3, a0
    cmpi.b  #$ff, (a4,a0.w)
    bne.b   l_0deb6
    movea.w d3, a0
    cmpi.b  #$f, (a2,a0.w)
    bcs.w   l_0e05e
l_0deb6:
    lea     (a4,d3.w), a0
    movea.l a0, a3
    move.b  (a0), d0
    andi.l  #$7f, d0
    move.w  $a(a6), d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_0defc
    movea.w d3, a0
    move.b  (a2,a0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477A0).l, -(a7)
    pea     -$5e(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
    bra.b   l_0df3a
l_0defc:
    move.b  (a3), d0
    andi.w  #$7f, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    movea.w d3, a0
    move.b  (a2,a0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047790).l, -(a7)
    pea     -$5e(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $10(a7), a7
l_0df3a:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$5e(a6)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004778C).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $30(a7), a7
l_0df84:
    move.w  -$4(a6), d0
    andi.w  #$10, d0
    beq.b   l_0dfa2
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d3
    bra.w   l_0e05e
l_0dfa2:
    move.w  -$4(a6), d0
    andi.w  #$f, d0
    beq.w   l_0e056
    move.w  -$4(a6), d0
    andi.w  #$8, d0
    beq.b   l_0dfd0
    move.w  #$1, ($00FF13FC).l
    move.w  d3, d0
    ext.l   d0
    addq.l  #$2, d0
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_0dfd0
    addq.w  #$2, d3
l_0dfd0:
    move.w  -$4(a6), d0
    andi.w  #$4, d0
    beq.b   l_0e006
    move.w  #$1, ($00FF13FC).l
    move.w  d3, d0
    ext.l   d0
    subq.l  #$2, d0
    move.w  d3, d1
    andi.l  #$1, d1
    cmp.l   d1, d0
    ble.b   l_0dffc
    move.w  d3, d0
    ext.l   d0
    subq.l  #$2, d0
    bra.b   l_0e004
l_0dffc:
    move.w  d3, d0
    andi.l  #$1, d0
l_0e004:
    move.w  d0, d3
l_0e006:
    move.w  -$4(a6), d0
    andi.w  #$2, d0
    beq.b   l_0e040
    move.w  #$1, ($00FF13FC).l
    move.w  d3, d0
    ext.l   d0
    ori.l   #$1, d0
    move.w  d2, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    bge.b   l_0e038
    move.w  d3, d0
    ext.l   d0
    ori.l   #$1, d0
    bra.b   l_0e03e
l_0e038:
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
l_0e03e:
    move.w  d0, d3
l_0e040:
    move.w  -$4(a6), d0
    andi.w  #$1, d0
    beq.b   l_0e056
    move.w  #$1, ($00FF13FC).l
    andi.w  #$fe, d3
l_0e056:
    pea     ($0004).w
    bra.w   l_0de1a
l_0e05e:
    move.l  #$8000, -(a7)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    move.w  d3, d0
    movem.l -$88(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; CalcCharValue -- Calculate character effectiveness from stats and game phase
; Called: 18 times.
; 196 bytes | $00E08E-$00E151
; ============================================================================
CalcCharValue:                                                  ; $00E08E
    movem.l d2-d4/a2,-(sp)
    move.l  $001c(sp),d2
    move.l  $0018(sp),d3
    move.l  $0014(sp),d4
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  #$01f4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9d92                           ; jsr $009D92
    addq.l  #$8,sp
    move.w  d0,d3
    moveq   #$0,d0
    move.b  $0003(a2),d0
    addi.w  #$32,d0
    andi.l  #$ffff,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.w  d3,d1
    addq.l  #$2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    tst.l   d0
    bge.b   .le110
    addq.l  #$3,d0
.le110:                                                 ; $00E110
    asr.l   #$2,d0
    addq.w  #$1,d0
    move.w  d0,d3
    moveq   #$0,d1
    move.w  d3,d1
    move.l  d2,d0
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d2
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d2
    movem.l (sp)+,d2-d4/a2
    rts
; ============================================================================
; CollectPlayerChars -- (TODO: describe)
; Called: ?? times.
; 498 bytes | $00E152-$00E343
; ============================================================================
CollectPlayerChars:                                                  ; $00E152
    link    a6,#-$10
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0010(a6),d3
    move.l  $0008(a6),d7
    move.w  $000e(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    cmpi.w  #$5,d3
    bge.b   .le1ac
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005f908,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,-$000c(a6)
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005f909,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,-$000e(a6)
    bra.b   .le1b6
.le1ac:                                                 ; $00E1AC
    clr.w   -$000c(a6)
    move.w  #$e,-$000e(a6)
.le1b6:                                                 ; $00E1B6
    lea     -$000a(a6),a3
    clr.w   d5
    clr.w   d4
    moveq   #$0,d3
    move.b  (a5),d3
    moveq   #$0,d6
    move.b  $0001(a5),d6
    bra.w   .le276
.le1cc:                                                 ; $00E1CC
    move.w  d3,d0
    mulu.w  #$6,d0
    movea.l #$00ff1704,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d2
.le1f2:                                                 ; $00E1F2
    moveq   #$0,d0
    move.b  (a4),d0
    move.w  d7,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .le266
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000c(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    blt.b   .le266
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000e(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    bgt.b   .le266
    move.w  d3,(a3)
    move.w  d2,$0002(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d0,$0004(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $6100,$fe56                                 ; bsr.w $00E08E
    move.l  d0,$0006(a3)
    pea     ($000A).w
    move.w  d5,d0
    add.w   d0,d0
    movea.l #$00ff1a04,a0
    pea     (a0,d0.w)
    clr.l   -(sp)
    move.l  a3,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    lea     $0020(sp),sp
    addi.w  #$a,d5
    addq.w  #$1,d4
.le266:                                                 ; $00E266
    addq.l  #$1,a2
    addq.l  #$1,a4
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .le1f2
    subq.w  #$1,d6
    addq.w  #$1,d3
.le276:                                                 ; $00E276
    tst.w   d6
    bgt.w   .le1cc
    moveq   #$0,d3
    move.b  $0002(a5),d3
    moveq   #$0,d6
    move.b  $0003(a5),d6
    bra.w   .le332
.le28c:                                                 ; $00E28C
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff15a0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d2
.le2ae:                                                 ; $00E2AE
    moveq   #$0,d0
    move.b  (a4),d0
    move.w  d7,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .le322
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000c(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    blt.b   .le322
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000e(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    bgt.b   .le322
    move.w  d3,(a3)
    move.w  d2,$0002(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d0,$0004(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $6100,$fd9a                                 ; bsr.w $00E08E
    move.l  d0,$0006(a3)
    pea     ($000A).w
    move.w  d5,d0
    add.w   d0,d0
    movea.l #$00ff1a04,a0
    pea     (a0,d0.w)
    clr.l   -(sp)
    move.l  a3,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    lea     $0020(sp),sp
    addi.w  #$a,d5
    addq.w  #$1,d4
.le322:                                                 ; $00E322
    addq.l  #$1,a2
    addq.l  #$1,a4
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .le2ae
    subq.w  #$1,d6
    addq.w  #$1,d3
.le332:                                                 ; $00E332
    tst.w   d6
    bgt.w   .le28c
    move.w  d4,d0
    movem.l -$0038(a6),d2-d7/a2-a5
    unlk    a6
    rts
; === Translated block $00E344-$00E6B2 ===
; 2 functions, 878 bytes

; ============================================================================
; func_00E344 -- (TODO: name)
; 358 bytes | $00E344-$00E4A9
; ============================================================================
func_00E344:
    link    a6,#-$C
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d6
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    lea     -$a(a6), a2
    move.w  d4, d5
    mulu.w  #$a, d5
    move.w  d6, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$5,d1
    cmp.l   d0, d1
    ble.b   l_0e386
    move.w  d6, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    bra.b   l_0e388
l_0e386:
    moveq   #$5,d0
l_0e388:
    move.w  d0, d6
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $2c(a7), a7
    pea     ($0003).w
    pea     ($0001).w
    jsr     (a4)
    pea     ($0003E8EE).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($000C).w
    jsr     (a4)
    pea     ($0003E8E4).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($0018).w
    jsr     (a4)
    pea     ($0003E8DE).l
    jsr     (a3)
    lea     $24(a7), a7
    clr.w   d3
    moveq   #$5,d2
    bra.w   l_0e49a
l_0e402:
    pea     ($000A).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00FF1A04,a0
    pea     (a0, d0.w)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    addi.w  #$a, d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a4)
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E8DA).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    jsr     (a4)
    lea     $2c(a7), a7
    move.w  $4(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E2DE,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E8D6).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0016).w
    jsr     (a4)
    move.l  $6(a2), d0
    lsr.l   #$2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003E8D0).l
    jsr     (a3)
    lea     $18(a7), a7
    addq.w  #$1, d4
    addq.w  #$1, d3
    addq.w  #$2, d2
l_0e49a:
    cmp.w   d6, d3
    blt.w   l_0e402
    movem.l -$2c(a6), d2-d6/a2-a4
    unlk    a6
    rts

; ============================================================================
; func_00E4AA -- (TODO: name)
; 520 bytes | $00E4AA-$00E6B1
; ============================================================================
func_00E4AA:
    link    a6,#$0
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $c(a6), d6
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00FFBD58,a4
    moveq   #$1,d4
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($000477A4).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $2c(a7), a7
    clr.w   d2
    clr.w   d3
    clr.w   (a4)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FE10                                 ; bsr.w $00E344
    addq.l  #$8, a7
l_0e538:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   l_0e538
    clr.w   d5
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d3
l_0e554:
    tst.w   (a4)
    beq.b   l_0e576
    cmpi.w  #$1, d4
    bne.b   l_0e57c
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FDD8                                 ; bsr.w $00E344
    addq.l  #$8, a7
    clr.w   d2
    clr.w   d4
    bra.b   l_0e57c
l_0e576:
    clr.w   d4
    move.w  #$1, (a4)
l_0e57c:
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0544).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $2c(a7), a7
l_0e5c0:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($0014).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
    addq.l  #$8, a7
    move.w  d0, d5
    andi.l  #$33, d0
    beq.b   l_0e5c0
    move.w  d5, d0
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_0e5fc
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   l_0e652
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   l_0e65a
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_0e67e
    bra.w   l_0e698
l_0e5fc:
    clr.w   (a3)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0546).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.w  d3, d0
    add.w   d2, d0
    move.w  d0, d2
l_0e63e:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $c(a7), a7
    move.w  d2, d0
    bra.b   l_0e6a8
l_0e652:
    clr.w   (a3)
    move.w  #$ff, d2
    bra.b   l_0e63e
l_0e65a:
    move.w  #$1, (a3)
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    move.w  d6, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_0e698
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   l_0e698
    addq.w  #$5, d3
    bra.b   l_0e696
l_0e67e:
    move.w  #$1, (a3)
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    subq.l  #$1, d0
    blt.b   l_0e698
    subq.w  #$1, d2
    bge.b   l_0e698
    subq.w  #$5, d3
l_0e696:
    moveq   #$1,d4
l_0e698:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.w   l_0e554
l_0e6a8:
    movem.l -$20(a6), d2-d6/a2-a4
    unlk    a6
    rts

; ============================================================================
; ShowCharCompare -- (TODO: describe)
; Called: ?? times.
; 504 bytes | $00E6B2-$00E8A9
; ============================================================================
ShowCharCompare:                                                  ; $00E6B2
    link    a6,#-$8
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0008(a6),d2
    move.l  $000c(a6),d3
    move.l  $0014(a6),d4
    movea.l #$0003ab2c,a2
    movea.l #$0003b246,a3
    lea     -$0008(a6),a4
    lea     -$0004(a6),a5
    clr.w   d5
    move.w  ($00FF0006).l,d6
    ext.l   d6
    subq.l  #$1,d6
    ble.b   .le6f4
    move.w  ($00FF0006).l,d6
    ext.l   d6
    subq.l  #$1,d6
    bra.b   .le6f6
.le6f4:                                                 ; $00E6F4
    moveq   #$0,d6
.le6f6:                                                 ; $00E6F6
    pea     -$0008(a6)
    pea     -$0004(a6)
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$969a                           ; jsr $00969A
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $6100,$f96a                                 ; bsr.w $00E08E
    lea     $0024(sp),sp
    move.l  d0,d2
    move.l  #$8000,-(sp)
    pea     ($0011).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0028(sp),sp
    pea     ($0010).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     ($0010).w
    pea     ($001F).w
    pea     ($0002).w
    pea     ($0001).w
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0020(sp),sp
    pea     ($0001).w
    pea     ($06A0).w
    pea     ($0037).w
    pea     ($0018).w
    pea     ($0010).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$883a                           ; jsr $00883A
    pea     ($0003).w
    pea     ($0005).w
    jsr     (a2)
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003E93C).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0006).w
    pea     ($0002).w
    jsr     (a2)
    lea     $0030(sp),sp
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003E938).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0640).w
    pea     ($000A).w
    pea     ($0003).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0278                                 ; jsr $00EA86
    nop
    pea     ($0008).w
    pea     ($000B).w
    jsr     (a2)
    move.l  (a5),-(sp)
    pea     ($0003E92A).l
    jsr     (a3)
    pea     ($000A).w
    pea     ($000B).w
    jsr     (a2)
    lea     $0030(sp),sp
    move.l  (a4),-(sp)
    pea     ($0003E91A).l
    jsr     (a3)
    pea     ($000C).w
    pea     ($000B).w
    jsr     (a2)
    move.w  $0002(a5),d0
    sub.w   $0002(a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003E90E).l
    jsr     (a3)
    pea     ($000E).w
    pea     ($000B).w
    jsr     (a2)
    move.l  d2,-(sp)
    pea     ($0003E902).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($000B).w
    jsr     (a2)
    lea     $0030(sp),sp
    move.l  d2,d0
    bge.b   .le884
    addq.l  #$3,d0
.le884:                                                 ; $00E884
    asr.l   #$2,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0003E8F4).l
    jsr     (a3)
    move.l  (a5),d0
    cmp.l   (a4),d0
    ble.b   .le89e
    moveq   #$1,d5
.le89e:                                                 ; $00E89E
    move.w  d5,d0
    movem.l -$002c(a6),d2-d6/a2-a5
    unlk    a6
    rts

; === Translated block $00E8AA-$00EB28 ===
; 2 functions, 638 bytes

; ============================================================================
; func_00E8AA -- (TODO: name)
; 476 bytes | $00E8AA-$00EA85
; ============================================================================
func_00E8AA:
    link    a6,#-$70
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.l  $c(a6), d3
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6A2E                           ; jsr $006A2E
    pea     ($0005).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$F84A                                 ; bsr.w $00E152
    lea     $24(a7), a7
    move.w  d0, d4
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    tst.w   d4
    bgt.w   l_0ea3e
    bra.w   l_0ea5c
l_0e920:
    lea     -$a(a6), a2
    pea     ($000A).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    mulu.w  #$a, d0
    add.w   d0, d0
    movea.l  #$00FF1A04,a0
    pea     (a0, d0.w)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$FD56                                 ; bsr.w $00E6B2
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_0e96a
    moveq   #$1,d3
    bra.b   l_0e96c
l_0e96a:
    moveq   #$2,d3
l_0e96c:
    move.w  $4(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$000477B0,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$6e(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    pea     -$6e(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_0ea22
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    dc.w    $6100,$F6C0                                 ; bsr.w $00E08E
    move.l  d0, d2
    add.l   d0, d0
    add.l   d2, d0
    bge.b   l_0e9da
    addq.l  #$3, d0
l_0e9da:
    asr.l   #$2, d0
    move.l  d0, d2
    add.l   d2, $6(a3)
    cmpi.w  #$20, (a2)
    bge.b   l_0e9fa
    move.w  (a2), d0
    mulu.w  #$6, d0
    add.w   $2(a2), d0
    movea.l  #$00FF0420,a0
    bra.b   l_0ea08
l_0e9fa:
    move.w  (a2), d0
    lsl.w   #$2, d0
    add.w   $2(a2), d0
    movea.l  #$00FF0460,a0
l_0ea08:
    move.b  #$ff, (a0,d0.w)
    pea     ($0001).w
    move.w  (a2), d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$81C6                           ; jsr $0181C6
    lea     $14(a7), a7
    bra.b   l_0ea7a
l_0ea22:
    clr.l   -(a7)
    dc.w    $4EB9,$0000,$538E                           ; jsr $00538E
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $10(a7), a7
l_0ea3e:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $6100,$FA5E                                 ; bsr.w $00E4AA
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$ff, d0
    bne.w   l_0e920
    bra.b   l_0ea7a
l_0ea5c:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($000477A8).l, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
l_0ea7a:
    moveq   #$1,d0
    movem.l -$84(a6), d2-d4/a2-a3
    unlk    a6
    rts

; ============================================================================
; func_00EA86 -- (TODO: name)
; 162 bytes | $00EA86-$00EB27
; ============================================================================
func_00EA86:
    link    a6,#-$3C
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a6), d3
    pea     ($0010).w
    pea     ($0030).w
    pea     ($000767DE).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.w  $a(a6), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    pea     ($001E).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    lea     $20(a7), a7
    lea     -$3c(a6), a2
    clr.w   d2
l_0eae4:
    move.w  d3, d0
    add.w   d2, d0
    ori.w   #$6000, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   l_0eae4
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$48(a6), d2-d3/a2
    unlk    a6
    rts


; ============================================================================
; PackSaveState -- (TODO: describe)
; Called: ?? times.
; 1130 bytes | $00EB28-$00EF91
; ============================================================================
PackSaveState:                                                  ; $00EB28
    movem.l d2-d4/a2-a5,-(sp)
    move.l  $0020(sp),d4
    movea.l #$0001d538,a5
    movea.l #$00ff1804,a3
    movea.l a3,a4
    addq.l  #$6,a3
    move.b  ($00FF0003).l,(a3)+
    move.b  ($00FF0005).l,(a3)+
    pea     ($0002).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0006).l
    clr.l   -(sp)
    jsr     (a5)
    addq.l  #$2,a3
    move.b  ($00FF0009).l,(a3)+
    move.b  ($00FF000B).l,(a3)+
    move.b  ($00FF000D).l,(a3)+
    move.b  ($00FF000F).l,(a3)+
    move.b  ($00FF0011).l,(a3)+
    pea     ($0004).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0012).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    addq.l  #$4,a3
    move.b  ($00FF0016).l,(a3)+
    pea     ($0090).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0018).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0090(a3),a3
    pea     ($0040).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF00A8).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$40,d0
    adda.l  d0,a3
    pea     ($0030).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF00E8).l
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$30,d0
    adda.l  d0,a3
    pea     ($0008).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0118).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    addq.l  #$8,a3
    pea     ($0010).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0120).l
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$10,d0
    adda.l  d0,a3
    pea     ($0080).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0130).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    lea     $0080(a3),a3
    pea     ($0080).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF01B0).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0080(a3),a3
    pea     ($0040).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0230).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$40,d0
    adda.l  d0,a3
    pea     ($0020).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0270).l
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$20,d0
    adda.l  d0,a3
    pea     ($0018).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0290).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$18,d0
    adda.l  d0,a3
    clr.w   d3
.lecbc:                                                 ; $00ECBC
    move.w  d3,d0
    lsl.w   #$5,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
.lecce:                                                 ; $00ECCE
    pea     ($0001).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    addq.l  #$1,a3
    addq.l  #$2,a2
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .lecce
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .lecbc
    pea     ($0050).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF02E8).l
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$50,d0
    adda.l  d0,a3
    pea     ($0080).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0338).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    lea     $0080(a3),a3
    pea     ($0028).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF03B8).l
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$28,d0
    adda.l  d0,a3
    pea     ($0010).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF03E0).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$10,d0
    adda.l  d0,a3
    pea     ($0030).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF03F0).l
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$30,d0
    adda.l  d0,a3
    pea     ($00C0).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0420).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    lea     $00c0(a3),a3
    pea     ($00E4).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF04E0).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $00e4(a3),a3
    move.l  a3,-(sp)
    dc.w    $4eba,$01d4                                 ; jsr $00EF92
    nop
    movea.l d0,a3
    pea     ($0040).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0728).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $002c(sp),sp
    moveq   #$40,d0
    adda.l  d0,a3
    movea.l #$00ff8824,a2
    clr.w   d2
.ledea:                                                 ; $00EDEA
    pea     ($0001).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    addq.l  #$1,a3
    addq.l  #$2,a2
    addq.w  #$1,d2
    cmpi.w  #$20,d2
    blt.b   .ledea
    movea.l #$00ffba80,a2
    clr.w   d2
.lee14:                                                 ; $00EE14
    clr.w   d3
.lee16:                                                 ; $00EE16
    pea     ($0001).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    addq.l  #$1,a3
    addq.l  #$2,a2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .lee16
    addq.w  #$1,d2
    cmpi.w  #$59,d2
    blt.b   .lee14
    pea     ($0010).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF08EC).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    moveq   #$10,d0
    adda.l  d0,a3
    clr.w   d3
.lee60:                                                 ; $00EE60
    move.w  d3,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
.lee74:                                                 ; $00EE74
    pea     ($000C).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    moveq   #$c,d0
    adda.l  d0,a3
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$28,d2
    blt.b   .lee74
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .lee60
    pea     ($0004).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF099C).l
    clr.l   -(sp)
    jsr     (a5)
    addq.l  #$4,a3
    pea     ($0001).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF09A0).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    addq.l  #$1,a3
    pea     ($0020).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF09A2).l
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$20,d0
    adda.l  d0,a3
    move.l  a3,-(sp)
    dc.w    $4eba,$0114                                 ; jsr $00F008
    nop
    movea.l d0,a3
    pea     ($0059).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF09D8).l
    clr.l   -(sp)
    jsr     (a5)
    lea     $002c(sp),sp
    moveq   #$59,d0
    adda.l  d0,a3
    pea     ($0002).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0A32).l
    clr.l   -(sp)
    jsr     (a5)
    addq.l  #$2,a3
    pea     ($0002).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0A34).l
    clr.l   -(sp)
    jsr     (a5)
    addq.l  #$2,a3
    move.l  a3,d0
    sub.l   a4,d0
    move.l  d0,d2
    addi.w  #$fffa,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05c8                                 ; jsr $00F522
    nop
    lea     $0030(sp),sp
    move.l  d2,-(sp)
    move.w  d4,d0
    ext.l   d0
    moveq   #$d,d1
    lsl.l   d1,d0
    addi.l  #$00200003,d0
    move.l  d0,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0001,$e0e0                           ; jsr $01E0E0
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0180                                 ; jsr $00F104
    nop
    lea     $0010(sp),sp
    movem.l (sp)+,d2-d4/a2-a5
    rts
; === Translated block $00EF92-$00EFC8 ===
; 1 functions, 54 bytes

; ============================================================================
; func_00EF92 -- (TODO: name)
; 54 bytes | $00EF92-$00EFC7
; ============================================================================
func_00EF92:
    movem.l d2-d3, -(a7)
    movea.l $c(a7), a0
    movea.l  #$00FF05C4,a1
    clr.w   d1
l_0efa2:
    clr.b   d3
    clr.w   d2
l_0efa6:
    move.b  (a1), d0
    lsl.b   d2, d0
    or.b    d0, d3
    addq.l  #$1, a1
    addq.w  #$2, d2
    cmpi.w  #$8, d2
    bcs.b   l_0efa6
    move.b  d3, (a0)+
    addq.w  #$1, d1
    cmpi.w  #$39, d1
    bcs.b   l_0efa2
    move.l  a0, d0
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; UnpackPixelData -- (TODO: describe)
; Called: ?? times.
; 64 bytes | $00EFC8-$00F007
; ============================================================================
UnpackPixelData:                                                  ; $00EFC8
    movem.l d2-d4,-(sp)
    movea.l $0010(sp),a0
    movea.l #$00ff05c4,a1
    clr.w   d3
.lefd8:                                                 ; $00EFD8
    move.b  (a0),d4
    clr.w   d2
.lefdc:                                                 ; $00EFDC
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$0,d1
    move.b  d4,d1
    asr.l   d0,d1
    move.l  d1,d0
    andi.b  #$03,d0
    move.b  d0,(a1)+
    addq.w  #$2,d2
    cmpi.w  #$8,d2
    bcs.b   .lefdc
    addq.l  #$1,a0
    addq.w  #$1,d3
    cmpi.w  #$39,d3
    bcs.b   .lefd8
    move.l  a0,d0
    movem.l (sp)+,d2-d4
    rts
; === Translated block $00F008-$00F086 ===
; 1 functions, 126 bytes

; ============================================================================
; func_00F008 -- (TODO: name)
; 126 bytes | $00F008-$00F085
; ============================================================================
func_00F008:
    movem.l a2-a3, -(a7)
    movea.l $c(a7), a2
    movea.l  #$0001D538,a3
    pea     ($0008).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09C2).l
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a2
    pea     ($0004).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09CA).l
    clr.l   -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    addq.l  #$4, a2
    pea     ($0008).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09CE).l
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a2
    pea     ($0002).w
    move.l  a2, -(a7)
    move.l  #$200003, -(a7)
    pea     ($00FF09D6).l
    clr.l   -(a7)
    jsr     (a3)
    lea     $28(a7), a7
    addq.l  #$2, a2
    move.l  a2, d0
    movem.l (a7)+, a2-a3
    rts

; ============================================================================
; CopyRouteFields -- (TODO: describe)
; Called: ?? times.
; 126 bytes | $00F086-$00F103
; ============================================================================
CopyRouteFields:                                                  ; $00F086
    movem.l a2-a3,-(sp)
    movea.l $000c(sp),a2
    movea.l #$0001d538,a3
    pea     ($0008).w
    pea     ($00FF09C2).l
    clr.l   -(sp)
    move.l  a2,-(sp)
    move.l  #$00200003,-(sp)
    jsr     (a3)
    addq.l  #$8,a2
    pea     ($0004).w
    pea     ($00FF09CA).l
    clr.l   -(sp)
    move.l  a2,-(sp)
    move.l  #$00200003,-(sp)
    jsr     (a3)
    lea     $0028(sp),sp
    addq.l  #$4,a2
    pea     ($0008).w
    pea     ($00FF09CE).l
    clr.l   -(sp)
    move.l  a2,-(sp)
    move.l  #$00200003,-(sp)
    jsr     (a3)
    addq.l  #$8,a2
    pea     ($0002).w
    pea     ($00FF09D6).l
    clr.l   -(sp)
    move.l  a2,-(sp)
    move.l  #$00200003,-(sp)
    jsr     (a3)
    lea     $0028(sp),sp
    addq.l  #$2,a2
    move.l  a2,d0
    movem.l (sp)+,a2-a3
    rts
; ============================================================================
; ShowRouteInfo -- (TODO: describe)
; Called: ?? times.
; 1046 bytes | $00F104-$00F519
; ============================================================================
ShowRouteInfo:                                                  ; $00F104
    link    a6,#$0
    movem.l d2-d4/a2-a5,-(sp)
    move.l  $0008(a6),d4
    movea.l #$0003b270,a5
    moveq   #$1,d3
    move.w  d4,d2
    mulu.w  #$b,d2
    addq.w  #$2,d2
    tst.w   d4
    bne.w   .lf322
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0426                                 ; jsr $00F552
    nop
    addq.l  #$4,sp
    tst.w   d0
    bne.b   .lf170
    pea     ($000A).w
    pea     ($001E).w
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0018(sp),sp
    pea     ($0003EA6C).l
.lf168:                                                 ; $00F168
    jsr     (a5)
    addq.l  #$4,sp
    bra.w   .lf518
.lf170:                                                 ; $00F170
    movea.l #$00ff1804,a4
    movea.l a4,a2
    moveq   #$14,d0
    adda.l  d0,a2
    movea.l a4,a3
    lea     $00a4(a3),a3
    addq.w  #$1,d2
    clr.w   d3
.lf186:                                                 ; $00F186
    cmpi.b  #$20,$0001(a2)
    bcc.b   .lf1fe
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  a3,-(sp)
    pea     ($0003EA66).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000B).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005f926,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA62).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA5C).l
    jsr     (a5)
    lea     $0030(sp),sp
.lf1fe:                                                 ; $00F1FE
    moveq   #$24,d0
    adda.l  d0,a2
    moveq   #$10,d0
    adda.l  d0,a3
    addq.w  #$2,d2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.w   .lf186
    tst.w   d4
    bne.b   .lf21a
    moveq   #$2,d2
    bra.b   .lf21c
.lf21a:                                                 ; $00F21A
    moveq   #$d,d2
.lf21c:                                                 ; $00F21C
    addq.w  #$1,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA58).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0006(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA54).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA50).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0007(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA4C).l
    jsr     (a5)
    move.w  $0008(a4),d3
    move.w  d3,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.l  d0,d4
    mulu.w  #$3,d4
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d4
    move.w  d3,d0
    ext.l   d0
    bge.b   .lf2cc
    addq.l  #$3,d0
.lf2cc:                                                 ; $00F2CC
    asr.l   #$2,d0
    addi.w  #$07a3,d0
    move.w  d0,d3
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0019).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003EA48).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005f096,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA44).l
    bra.w   .lf516
.lf322:                                                 ; $00F322
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$022a                                 ; jsr $00F552
    nop
    addq.l  #$4,sp
    tst.w   d0
    bne.b   .lf368
    pea     ($000A).w
    pea     ($001E).w
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0018(sp),sp
    pea     ($0003EA36).l
    bra.w   .lf168
.lf368:                                                 ; $00F368
    movea.l #$00ff1804,a4
    movea.l a4,a2
    moveq   #$14,d0
    adda.l  d0,a2
    movea.l a4,a3
    lea     $00a4(a3),a3
    addq.w  #$1,d2
    clr.w   d3
.lf37e:                                                 ; $00F37E
    cmpi.b  #$20,$0001(a2)
    bcc.b   .lf3f6
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  a3,-(sp)
    pea     ($0003EA30).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000B).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005f926,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA2C).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA26).l
    jsr     (a5)
    lea     $0030(sp),sp
.lf3f6:                                                 ; $00F3F6
    moveq   #$24,d0
    adda.l  d0,a2
    moveq   #$10,d0
    adda.l  d0,a3
    addq.w  #$2,d2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.w   .lf37e
    tst.w   d4
    bne.b   .lf412
    moveq   #$2,d2
    bra.b   .lf414
.lf412:                                                 ; $00F412
    moveq   #$d,d2
.lf414:                                                 ; $00F414
    addq.w  #$1,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA22).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0006(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA1E).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA1A).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0007(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA16).l
    jsr     (a5)
    move.w  $0008(a4),d3
    move.w  d3,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.l  d0,d4
    mulu.w  #$3,d4
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d4
    move.w  d3,d0
    ext.l   d0
    bge.b   .lf4c4
    addq.l  #$3,d0
.lf4c4:                                                 ; $00F4C4
    asr.l   #$2,d0
    addi.w  #$07a3,d0
    move.w  d0,d3
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0019).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003EA12).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005f096,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA0E).l
.lf516:                                                 ; $00F516
    jsr     (a5)
.lf518:                                                 ; $00F518
    movem.l -$1C(a6),d2-d4/a2-a5
    unlk    a6
    rts
; === Translated block $00F522-$00F552 ===
; 1 functions, 48 bytes

; ============================================================================
; func_00F522 -- (TODO: name)
; 48 bytes | $00F522-$00F551
; ============================================================================
func_00F522:
    movem.l d2/a2-a3, -(a7)
    move.l  $14(a7), d2
    movea.l  #$00FF1804,a3
    movea.l a3, a2
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$D6FC                           ; jsr $01D6FC
    addq.l  #$8, a7
    move.w  d0, $2(a2)
    move.w  d2, $4(a2)
    movem.l (a7)+, d2/a2-a3
    rts

; ============================================================================
; VerifyChecksum -- (TODO: describe)
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
; ============================================================================
; sub_00F5AA -- (TODO: describe)
; Called: ?? times.
; 376 bytes | $00F5AA-$00F721
; ============================================================================
ProcessRouteAction:                                                  ; $00F5AA
    link    a6,#-$54
    movem.l d2-d5,-(sp)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  ($00FF9A1C).l,d3
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $002c(sp),sp
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0566                                 ; jsr $00FB74
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.w   .lf6e6
.lf61e:                                                 ; $00F61E
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$4,d4
    bge.w   .lf6be
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    move.w  d0,d5
    cmpi.w  #$ff,d0
    bne.b   .lf67a
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00f4                                 ; jsr $00F75E
    nop
    lea     $000c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .lf6de
    bra.b   .lf6e6
.lf67a:                                                 ; $00F67A
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA7A).l
    pea     -$0054(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     -$0054(a6)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0024(sp),sp
    bra.b   .lf6e6
.lf6be:                                                 ; $00F6BE
    cmpi.w  #$4,d4
    bne.b   .lf6de
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$05da                                 ; jsr $00FCAC
    nop
    addq.l  #$8,sp
    cmpi.w  #$1,d0
    beq.b   .lf6e6
.lf6de:                                                 ; $00F6DE
    cmpi.w  #$ff,d4
    bne.w   .lf61e
.lf6e6:                                                 ; $00F6E6
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0064(a6),d2-d5
    unlk    a6
    rts
; === Translated block $00F722-$00FDC4 ===
; 4 functions, 1698 bytes

; ============================================================================
; func_00F722 -- (TODO: name)
; 60 bytes | $00F722-$00F75D
; ============================================================================
func_00F722:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    move.w  $e(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    move.l  (a0,d0.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    move.l  (a0,d1.w), d1
    not.l   d1
    and.l   d1, d0
    move.l  d0, d2
    move.l  (a7)+, d2
    rts

; ============================================================================
; func_00F75E -- (TODO: name)
; 1046 bytes | $00F75E-$00FB73
; ============================================================================
func_00F75E:
    link    a6,#-$84
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d5
    move.l  $c(a6), d6
    lea     -$40(a6), a4
    movea.l  #$0003B270,a5
    clr.w   -$82(a6)
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9DC4                           ; jsr $009DC4
    move.w  d0, d3
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$9D92                           ; jsr $009D92
    move.w  d0, d4
    moveq   #$0,d7
    move.b  $3(a3), d7
    addi.w  #$14, d7
    move.w  d4, d0
    addq.w  #$1, d0
    mulu.w  d0, d7
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    addi.l  #$1e, d0
    moveq   #$0,d1
    move.w  d7, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d7
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$258, d0
    move.w  d4, d1
    ext.l   d1
    addq.l  #$1, d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    tst.l   d0
    bge.b   l_0f82a
    addq.l  #$1, d0
l_0f82a:
    asr.l   #$1, d0
    move.w  d0, d4
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6A2E                           ; jsr $006A2E
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0640).w
    pea     ($0037).w
    pea     ($0070).w
    pea     ($0018).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$883A                           ; jsr $00883A
    pea     ($0003).w
    pea     ($000B).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    pea     ($0003EBB4).l
    jsr     (a5)
    pea     ($000E).w
    pea     ($0006).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003EBB0).l
    jsr     (a5)
    pea     ($0006).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    pea     ($0003EB9C).l
    jsr     (a5)
    pea     ($0006).w
    pea     ($0017).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($0003EB96).l
    jsr     (a5)
    pea     ($0009).w
    pea     ($0002).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    pea     ($0003EB82).l
    jsr     (a5)
    lea     $30(a7), a7
    pea     ($0009).w
    pea     ($0017).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($0003EB7C).l
    jsr     (a5)
    pea     ($0040).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    move.l  ($000477BC).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477C0).l, -(a7)
    pea     -$80(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $30(a7), a7
    pea     -$80(a6)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0001,$E1BA                           ; jsr $01E1BA
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $20(a7), a7
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.l  #$3, d0
    bne.w   l_0fb44
    moveq   #$0,d0
    move.w  d4, d0
    cmp.l   $6(a2), d0
    bgt.w   l_0fb2c
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    move.w  d3, d0
    ext.l   d0
    move.w  d0, ($00FFA6B0).l
    dc.w    $4EB9,$0002,$0A64                           ; jsr $020A64
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477C8).l, -(a7)
    move.l  a4, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $24(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_0faee
    move.w  #$1, -$82(a6)
    moveq   #$0,d0
    move.w  d4, d0
    sub.l   d0, $6(a2)
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d3, (a2)
    move.b  #$3, $1(a2)
    pea     ($0001).w
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    pea     ($000A).w
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    pea     ($000A).w
    pea     ($0028).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0016).w
    dc.w    $4EB9,$0000,$5FF6                           ; jsr $005FF6
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477D0).l, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
    lea     $18(a7), a7
l_0faee:
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    pea     ($0001).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6A2E                           ; jsr $006A2E
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6B78                           ; jsr $006B78
    lea     $18(a7), a7
    bra.b   l_0fb66
l_0fb2c:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477C4).l, -(a7)
    bra.b   l_0fb5a
l_0fb44:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477CC).l, -(a7)
l_0fb5a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$183A                           ; jsr $01183A
l_0fb66:
    move.w  -$82(a6), d0
    movem.l -$ac(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00FB74 -- (TODO: name)
; 312 bytes | $00FB74-$00FCAB
; ============================================================================
func_00FB74:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d5
    lea     -$80(a6), a3
    movea.l  #$0005EC84,a4
    movea.l  #$0003B22C,a5
    moveq   #$1,d4
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    cmp.w   d3, d0
    beq.w   l_0fc68
    pea     ($00FF).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7A24                           ; jsr $007A24
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_0fc54
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_0fbf2:
    cmpi.b  #$3, $1(a2)
    beq.b   l_0fc02
    cmpi.b  #$4, $1(a2)
    bne.b   l_0fc48
l_0fc02:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    addq.l  #$4, a7
    cmp.w   d3, d0
    bne.b   l_0fc48
    cmpi.b  #$3, $1(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    move.l  ($000477D4).l, -(a7)
    move.l  a3, -(a7)
    jsr     (a5)
    lea     $10(a7), a7
    bra.b   l_0fc82
l_0fc48:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_0fbf2
    bra.b   l_0fc84
l_0fc54:
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    move.l  ($000477DC).l, -(a7)
    bra.b   l_0fc7a
l_0fc68:
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    move.l  ($000477D8).l, -(a7)
l_0fc7a:
    move.l  a3, -(a7)
    jsr     (a5)
    lea     $c(a7), a7
l_0fc82:
    clr.w   d4
l_0fc84:
    tst.w   d4
    bne.b   l_0fca0
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
l_0fca0:
    move.w  d4, d0
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_00FCAC -- (TODO: name)
; 280 bytes | $00FCAC-$00FDC3
; ============================================================================
func_00FCAC:
    link    a6,#-$194
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.l  $c(a6), d3
    lea     -$194(a6), a2
    movea.l  #$00006A2E,a3
    clr.w   d5
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    beq.w   l_0fd68
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477E4).l, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $2c(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_0fdb8
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$1BB2                           ; jsr $011BB2
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $14(a7), a7
    moveq   #$1,d5
    bra.b   l_0fdb8
l_0fd68:
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477E0).l, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
l_0fdb8:
    move.w  d5, d0
    movem.l -$1ac(a6), d2-d5/a2-a3
    unlk    a6
    rts

; ============================================================================
; FindOpenSlot -- (TODO: describe)
; Called: ?? times.
; 278 bytes | $00FDC4-$00FED9
; ============================================================================
FindOpenSlot:                                                  ; $00FDC4
    link    a6,#-$4
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $000c(a6),d6
    movea.l $0008(a6),a3
    move.w  d6,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a3),d0
    move.w  d0,-$0002(a6)
    moveq   #$0,d7
    move.b  $0001(a3),d7
    clr.w   d5
.lfdf6:                                                 ; $00FDF6
    tst.w   d5
    bne.b   .lfe00
    move.w  -$0002(a6),d4
    bra.b   .lfe02
.lfe00:                                                 ; $00FE00
    move.w  d7,d4
.lfe02:                                                 ; $00FE02
    ext.l   d4
    cmpi.w  #$20,d4
    blt.b   .lfe68
    clr.w   d2
.lfe0c:                                                 ; $00FE0C
    move.w  d4,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff0460,a0
    cmpi.b  #$ff,(a0,d0.w)
    bne.b   .lfe5e
    move.w  d4,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff15a0,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    cmpi.w  #$f,d3
    beq.b   .lfe5e
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d3
    cmp.l   $0006(a2),d3
    bgt.b   .lfe5e
.lfe5a:                                                 ; $00FE5A
    moveq   #$1,d0
    bra.b   .lfed0
.lfe5e:                                                 ; $00FE5E
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .lfe0c
    bra.b   .lfec4
.lfe68:                                                 ; $00FE68
    clr.w   d2
.lfe6a:                                                 ; $00FE6A
    move.w  d4,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff0420,a0
    cmpi.b  #$ff,(a0,d0.w)
    bne.b   .lfebc
    move.w  d4,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff1704,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    cmpi.w  #$f,d3
    beq.b   .lfebc
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d3
    cmp.l   $0006(a2),d3
    ble.b   .lfe5a
.lfebc:                                                 ; $00FEBC
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .lfe6a
.lfec4:                                                 ; $00FEC4
    addq.w  #$1,d5
    cmpi.w  #$2,d5
    blt.w   .lfdf6
    moveq   #$0,d0
.lfed0:                                                 ; $00FED0
    movem.l -$0024(a6),d2-d7/a2-a3
    unlk    a6
    rts
; ============================================================================
; CheckCharEligible -- (TODO: describe)
; Called: ?? times.
; 156 bytes | $00FEDA-$00FF75
; ============================================================================
CheckCharEligible:                                                  ; $00FEDA
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $0018(sp),d2
    move.l  $001c(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .lff04
    addq.l  #$3,d0
.lff04:                                                 ; $00FF04
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d2
    clr.w   d3
    move.w  d4,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0006(a2),d0
    cmp.w   d2,d0
    bgt.b   .lff6e
    moveq   #$0,d0
    move.b  $0007(a2),d0
    cmp.w   d2,d0
    ble.b   .lff6e
    moveq   #$0,d0
    move.b  (a2),d0
    movea.l #$0005f07c,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a3),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7610                           ; jsr $007610
    addq.l  #$8,sp
    cmpi.w  #$3,d0
    beq.b   .lff6e
    moveq   #$1,d3
.lff6e:                                                 ; $00FF6E
    move.w  d3,d0
    movem.l (sp)+,d2-d4/a2-a3
    rts
; ============================================================================
; CountUnprofitableRoutes -- (TODO: describe)
; Called: ?? times.
; 130 bytes | $00FF76-$00FFF7
; ============================================================================
CountUnprofitableRoutes:                                                  ; $00FF76
    movem.l d2-d5/a2,-(sp)
    move.l  $0018(sp),d2
    clr.w   d5
    clr.w   d4
    clr.w   d3
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d1
    move.b  $0004(a1),d1
    moveq   #$0,d0
    move.b  $0005(a1),d0
    add.w   d0,d1
    clr.w   d2
    bra.b   .lffdc
.lffba:                                                 ; $00FFBA
    move.w  $000e(a2),d0
    cmp.w   $0006(a2),d0
    bcc.b   .lffc6
    addq.w  #$1,d4
.lffc6:                                                 ; $00FFC6
    move.b  $000a(a2),d0
    andi.l  #$4,d0
    bne.b   .lffd4
    moveq   #$1,d5
.lffd4:                                                 ; $00FFD4
    addq.w  #$1,d3
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.lffdc:                                                 ; $00FFDC
    cmp.w   d1,d2
    blt.b   .lffba
    tst.w   d3
    bne.b   .lffe8
    moveq   #-$1,d0
    bra.b   .lfff2
.lffe8:                                                 ; $00FFE8
    tst.w   d5
    bne.b   .lfff0
    moveq   #-$2,d0
    bra.b   .lfff2
.lfff0:                                                 ; $00FFF0
    move.w  d4,d0
.lfff2:                                                 ; $00FFF2
    movem.l (sp)+,d2-d5/a2
    rts
; ============================================================================
; CountCharPerformance -- (TODO: describe)
; Called: ?? times.
; 250 bytes | $00FFF8-$0100F1
; ============================================================================
CountCharPerformance:                                                  ; $00FFF8
    link    a6,#-$8
    movem.l d2-d7,-(sp)

