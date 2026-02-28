; ============================================================================
; SortWordPairs -- sorts an array of word pairs in-place by descending value using bubble sort
; Called: ?? times.
; 188 bytes | $0109FA-$010AB5
; ============================================================================
; --- Algorithm Overview ---
; Bubble sort on an array of (word, word) pairs, sorting descending by the second word
; (the "score" field). Uses a working copy on the stack to avoid corrupting the caller's
; array during comparison passes, then writes the sorted result back.
;
; Args: a4=array_base (caller's input/output), d5=count (number of pairs)
; Each pair: word[0]=city_index, word[1]=score
; --- Phase: Setup ---
SortWordPairs:                                                  ; $0109FA
    link    a6,#-$1c
    movem.l d2-d6/a2-a4,-(sp)
    ; d5 = count of word pairs to sort (arg from $C(a6))
    move.l  $000c(a6),d5
    ; a4 = pointer to caller's input/output array (arg from $8(a6))
    movea.l $0008(a6),a4
    ; a1 = base of working copy on stack frame (-$1C(a6) = 28 bytes of scratch)
    lea     -$001c(a6),a1
    ; --- Phase: Copy Input to Working Buffer ---
    ; Copy all d5 pairs from a4 (caller array) to a1 (stack working copy)
    movea.l a4,a2
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    ; a3 = current write position in the working copy
    movea.l a0,a3
    bra.b   .l10a2a
.l10a20:                                                ; $010A20
    ; Copy one pair: first word (city_index) then second word (score)
    move.w  (a2)+,(a3)
    move.w  (a2)+,$0002(a3)
    addq.l  #$4,a3
    addq.w  #$1,d2
.l10a2a:                                                ; $010A2A
    cmp.w   d5,d2
    blt.b   .l10a20
    ; --- Phase: Bubble Sort (descending by score) ---
    ; d1 = count - 1 (number of adjacent comparisons per pass)
    move.w  d5,d1
    addi.w  #$ffff,d1
    ; d6 = pass counter (outer loop)
    clr.w   d6
    bra.b   .l10a88
; Outer loop: repeat up to d5 passes (worst case O(n^2))
.l10a38:                                                ; $010A38
    ; d3 = swap flag for this pass (0 = no swaps, means array is already sorted)
    clr.w   d3
    ; Reset inner loop counter d2 to 0 for each new pass
    clr.w   d2
    ; a2 = pointer to pair[1] (second element, the "right" of first comparison)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    addq.l  #$4,a0
    movea.l a0,a2
    ; a3 = pointer to pair[0] (first element, the "left" of first comparison)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    movea.l a0,a3
    bra.b   .l10a7e
; Inner loop: compare adjacent pairs and swap if left score < right score (sort descending)
.l10a58:                                                ; $010A58
    ; Compare score words (second word of each pair)
    move.w  $0002(a3),d0
    cmp.w   $0002(a2),d0
    ; If left score >= right score: already in order, no swap needed
    bge.b   .l10a78
    ; Left score < right score: swap the entire pair (both words)
    move.w  (a3),d3
    move.w  $0002(a3),d4
    move.w  (a2),(a3)
    move.w  $0002(a2),$0002(a3)
    move.w  d3,(a2)
    move.w  d4,$0002(a2)
    ; Mark that at least one swap occurred this pass
    moveq   #$1,d3
.l10a78:                                                ; $010A78
    ; Advance both pointers to next adjacent pair
    addq.l  #$4,a3
    addq.l  #$4,a2
    addq.w  #$1,d2
.l10a7e:                                                ; $010A7E
    ; Inner loop runs d5-1 times (compare all adjacent pairs in one pass)
    cmp.w   d1,d2
    blt.b   .l10a58
    ; If no swaps occurred: array is fully sorted -- early exit
    tst.w   d3
    beq.b   .l10a8c
    addq.w  #$1,d6
.l10a88:                                                ; $010A88
    ; Outer loop: at most d5 passes (worst case = fully reversed input)
    cmp.w   d5,d6
    blt.b   .l10a38
; --- Phase: Write Sorted Result Back to Caller's Array ---
.l10a8c:                                                ; $010A8C
    ; Copy sorted working copy back to a4 (caller's original array)
    movea.l a4,a2
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    movea.l a0,a3
    bra.b   .l10aa8
.l10a9e:                                                ; $010A9E
    ; Copy each sorted pair back to the caller array
    move.w  (a3),(a2)+
    move.w  $0002(a3),(a2)+
    addq.l  #$4,a3
    addq.w  #$1,d2
.l10aa8:                                                ; $010AA8
    cmp.w   d5,d2
    blt.b   .l10a9e
    movem.l -$003c(a6),d2-d6/a2-a4
    unlk    a6
    rts
RunPlayerSelectUI:                                                  ; $010AB6
    link    a6,#-$10
    movem.l d2-d5/a2-a5,-(sp)
    lea     -$0010(a6),a4
    movea.l #$0d64,a5
    move.w  $000e(a6),d2
    move.w  d2,d5
    pea     ($0008).w
    move.l  a4,-(sp)
    pea     ($00076AC0).l
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    pea     ($0008).w
    move.l  a4,d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    pea     ($00076AC0).l
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    lea     $0018(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$0aaa,(a4,a0.l)
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$88,$8(a4,a0.l)
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    pea     ($0001).w
    pea     ($0023).w
    jsr     (a5)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0020(sp),sp
    tst.w   d0
    beq.b   .l10b46
    moveq   #$1,d4
    bra.b   .l10b48
.l10b46:                                                ; $010B46
    moveq   #$0,d4
.l10b48:                                                ; $010B48
    clr.w   d3
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    movea.l #$00076ac0,a3
    movea.l a4,a2
    addq.l  #$8,a2
.l10b60:                                                ; $010B60
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8,sp
    tst.w   d4
    beq.b   .l10b80
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    bne.w   .l10c9c
.l10b80:                                                ; $010B80
    clr.w   d4
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$33,d0
    move.w  d0,d3
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.b   .l10bb6
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l10bd2
    moveq   #$20,d1
    cmp.w   d1,d0
    beq.b   .l10bea
    moveq   #$10,d1
    cmp.w   d1,d0
    beq.b   .l10c0e
    bra.b   .l10c30
.l10bb6:                                                ; $010BB6
    move.w  #$1,($00FF13FC).l
    cmpi.w  #$3,d2
    bcc.b   .l10bcc
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    bra.b   .l10bce
.l10bcc:                                                ; $010BCC
    moveq   #$0,d0
.l10bce:                                                ; $010BCE
    move.w  d0,d2
    bra.b   .l10c3c
.l10bd2:                                                ; $010BD2
    move.w  #$1,($00FF13FC).l
    tst.w   d2
    beq.b   .l10be6
    moveq   #$0,d0
    move.w  d2,d0
    subq.l  #$1,d0
    bra.b   .l10bce
.l10be6:                                                ; $010BE6
    moveq   #$3,d0
    bra.b   .l10bce
.l10bea:                                                ; $010BEA
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    clr.l   -(sp)
    pea     ($0023).w
    jsr     (a5)
    lea     $001c(sp),sp
    move.w  d2,d0
    bra.w   .l10ca2
.l10c0e:                                                ; $010C0E
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    clr.l   -(sp)
    pea     ($0023).w
    jsr     (a5)
    lea     $001c(sp),sp
    moveq   #-$1,d0
    bra.b   .l10ca2
.l10c30:                                                ; $010C30
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l10c3c:                                                ; $010C3C
    cmp.w   d5,d2
    beq.b   .l10c9c
    pea     ($0008).w
    move.l  a4,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    pea     ($0008).w
    move.l  a2,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    lea     $0018(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$0aaa,(a4,a0.l)
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$88,(a2,a0.l)
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    pea     ($0001).w
    pea     ($0023).w
    jsr     (a5)
    lea     $001c(sp),sp
.l10c9c:                                                ; $010C9C
    move.w  d2,d5
    bra.w   .l10b60
.l10ca2:                                                ; $010CA2
    movem.l -$0030(a6),d2-d5/a2-a5
    unlk    a6
    rts
CalcCharDisplayIndex_Prelude:                                ; $010CAC
    dc.w    $48E7,$3C00                                      ; movem.l d2-d5/a2-a3,-(sp) [falls through]
; === Translated block $010CB0-$0112EE ===
; 3 functions, 1598 bytes
