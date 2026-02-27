; ============================================================================
; NormalizeDisplayAttrs -- Step RGB display attributes toward a target set over 8 iterations
; 358 bytes | $004EFA-$00505F
; ============================================================================
NormalizeDisplayAttrs:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    lea     -$6(a6), a5
    move.w  $16(a6), d0
    add.w   d0, d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    move.l  $8(a6), -(a7)
    bsr.w MemMove
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
    bsr.w WriteCharUIDisplay
    lea     $c(a7), a7
    tst.w   $1a(a6)
    beq.b   l_05048
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.l  d0, -(a7)
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_05048:
    addq.w  #$1, -$4(a6)
    cmpi.w  #$8, -$4(a6)
    bcs.w   l_04f26
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ---------------------------------------------------------------------------
; InitTileBuffer -- Load tile ROM data into tile buffer at $FF14BC and clear display init flag
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
    bsr.w WriteCharUIDisplay
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
    jsr MemMoveWords
    LEA     $C(SP),SP                                          ; pop 3 args
    TST.W   ($FFA7DC).L                                        ; display init flag
    BNE.S   .ds_done                                           ; if set, skip init
    MOVE.W  D2,D0
    MOVE.L  D0,-(SP)                                           ; push size
    MOVE.W  D3,D0
    MOVE.L  D0,-(SP)                                           ; push index
    MOVE.L  A2,-(SP)                                           ; push dest
    bsr.w WriteCharUIDisplay
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
    bsr.w FadePalette
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
    bsr.w DisplayInitRows
    ADDQ.L  #4,SP
    RTS
; ---------------------------------------------------------------------------
; DisplayInit0 -- Initialize display with 0 rows (sets flag)
; ---------------------------------------------------------------------------
DisplayInit0:                                                  ; $005132
    CLR.L   -(SP)                                              ; push 0
    bsr.w DisplayInitRows
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
    jsr SignedMod
    MOVE.W  D0,D2                                              ; D2 = size / 4
    PEA     ($0010).W                                          ; push 16
    MOVE.W  D2,D0
    LSL.W   #4,D0                                              ; D0 = (size/4) * 16
    MOVE.L  D0,-(SP)                                           ; push scaled index
    MOVE.L  A2,-(SP)                                           ; push dest
    bsr.w DisplaySetup
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
    jsr GameCommand
    LEA     $14(SP),SP                                         ; pop 5 args
    MOVEM.L (SP)+,D2-D3
    RTS
; === Translated block $0051B6-$00538E ===
; 3 functions, 472 bytes
