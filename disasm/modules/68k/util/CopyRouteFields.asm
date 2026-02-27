; ============================================================================
; CopyRouteFields -- Copy work RAM fields , , ,  to output buffer in sequence, return end pointer
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
