; ============================================================================
; UpdateSlotDisplays -- Redraw route map display for all players except one, then redraw the designated player
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
    bsr.w ProcessCharRoster
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
    bsr.w ProcessCharRoster
    lea     $000c(sp),sp
    movem.l (sp)+,d2-d4
    rts
