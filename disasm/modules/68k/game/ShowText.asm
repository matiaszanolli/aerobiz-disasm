; ============================================================================
; ShowText -- Thin wrapper around ShowTextDialog with simplified params
; Called: 37 times.
; 62 bytes | $02FBD6-$02FC13
; ============================================================================
ShowText:                                                  ; $02FBD6
    movem.l d2-d3,-(sp)
    move.l  $0018(sp),d2
    move.l  $0010(sp),d3
    move.l  $000c(sp),d1
    movea.l $0014(sp),a0
    pea     ($0001).w
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a0,-(sp)
    move.w  d1,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0018(sp),sp
    movem.l (sp)+,d2-d3
    rts
; === Translated block $02FC14-$030000 ===
; 3 functions, 1004 bytes
