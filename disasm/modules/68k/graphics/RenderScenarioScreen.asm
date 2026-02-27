; ============================================================================
; RenderScenarioScreen -- Return 1 if any route/trade/turn pipeline slot ($FF09C2, $FF09CA, $FF09CE, $FF09D6) is active, or 0 if all are empty and all events resolved.
; 84 bytes | $023728-$02377B
; ============================================================================
RenderScenarioScreen:
    clr.w   d1
l_2372a:
    move.w  d1, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09C2,a0
    cmpi.b  #$ff, (a0,d0.w)
    beq.b   l_23740
l_2373c:
    moveq   #$1,d0
    bra.b   l_2377a
l_23740:
    addq.w  #$1, d1
    cmpi.w  #$2, d1
    blt.b   l_2372a
    cmpi.b  #$ff, ($00FF09CA).l
    bne.b   l_2373c
    clr.w   d1
l_23754:
    move.w  d1, d0
    lsl.w   #$2, d0
    movea.l  #$00FF09CE,a0
    cmpi.b  #$ff, (a0,d0.w)
    bne.b   l_2373c
    addq.w  #$1, d1
    cmpi.w  #$2, d1
    blt.b   l_23754
    cmpi.w  #$ff, ($00FF09D6).l
    bne.b   l_2373c
    moveq   #$0,d0
l_2377a:
    rts
