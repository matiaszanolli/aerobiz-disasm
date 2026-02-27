; ============================================================================
; VInt_Handler1 -- V-INT sub-handler: copy a block of words from RAM buffer to VRAM
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
