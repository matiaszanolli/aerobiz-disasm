; ============================================================================
; CmdSendZ80Param -- GameCommand Z80 dispatch: send 3-byte param, signal Z80, poll for result
; 338 bytes | $0024B8-$002609
; ============================================================================
CmdSendZ80Param:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    jsr (Z80_RequestBus,PC)
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
    jsr (Z80_RequestBus,PC)
    nop
    movea.l  #$00A00008,a1
    move.l  $e(a6), d0
    move.b  d0, (a1)
    bra.w   l_025c2
; -- GameCommand 20/24/25: trigger Z80 operation --
CmdTriggerZ80:                                                  ; $0024FA
    move.w  sr, -(a7)
    ori.w   #$700, sr
    jsr (Z80_RequestBus,PC)
    nop
    bra.w   l_025c2
; -- GameCommand 22: load data tables to Z80 RAM --
CmdLoadZ80Tables:                                               ; $00250A
    move.w  sr, -(a7)
    ori.w   #$700, sr
    jsr (Z80_RequestBus,PC)
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
    jsr (Z80_RequestBus,PC)
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
    jsr (Z80_ReleaseBus,PC)
    nop
    jsr (Z80_Delay,PC)
    nop
    jsr (Z80_RequestBus,PC)
    nop
    move.b  $6(a1), d1
    cmpi.b  #$0, d1
    bne.b   l_025da
    move.b  $7(a1), d0
    jsr (Z80_ReleaseBus,PC)
    nop
    andi.l  #$ff, d0
    move.w  (a7)+, sr
    rts
