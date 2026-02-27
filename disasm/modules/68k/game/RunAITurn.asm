; ============================================================================
; RunAITurn -- Executes a full AI turn for the current player: if the player is human calls the human-interaction sub-routine, then calls AI route-update, char-event, char-state, cost, and char-bonus sub-routines in sequence.
; Called: ?? times.
; 144 bytes | $02A738-$02A7C7
; ============================================================================
RunAITurn:                                                  ; $02A738
    movem.l d2/a2,-(sp)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    cmpi.b  #$01,(a2)
    bne.b   .l2a776
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0eb8                                 ; jsr $02B61C
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0058                                 ; jsr $02A7C8
    nop
    addq.l  #$8,sp
.l2a776:                                                ; $02A776
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$01a4                                 ; jsr $02A922
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$04e0                                 ; jsr $02AC6A
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0656                                 ; jsr $02ADEC
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$08ca                                 ; jsr $02B06C
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0c8c                                 ; jsr $02B43A
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$038a                                 ; jsr $02AB44
    nop
    lea     $0018(sp),sp
    movem.l (sp)+,d2/a2
    rts
; === Translated block $02A7C8-$02BDB8 ===
; 10 functions, 5616 bytes
