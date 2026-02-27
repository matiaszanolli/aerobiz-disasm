; ============================================================================
; DecrementAffinity -- Shows affinity-lost dialog, adds $186A0 to player wealth, and resets affinity byte to $64
; 180 bytes | $035910-$0359C3
; ============================================================================
DecrementAffinity:
    movem.l d2/a2, -(a7)
    move.l  $c(a7), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    jsr DrawBox
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044970).l
    jsr PrintfWide
    pea     ($003C).w
    jsr PollInputChange
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    jsr DrawBox
    pea     ($0004494E).l
    jsr PrintfWide
    lea     $30(a7), a7
    pea     ($003C).w
    jsr PollInputChange
    addq.l  #$4, a7
    addi.l  #$186a0, $6(a2)
    cmpi.l  #$186a0, $6(a2)
    ble.b   l_359ae
    move.l  $6(a2), d0
    bra.b   l_359b4
l_359ae:
    move.l  #$186a0, d0
l_359b4:
    move.l  d0, $6(a2)
    move.b  #$64, $22(a2)
    movem.l (a7)+, d2/a2
    rts
