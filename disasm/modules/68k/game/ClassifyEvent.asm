; ============================================================================
; ClassifyEvent -- Classify a character type code into one of 5 event categories ($15->1, $3->2, $1C/$13/$F/$10->3, $7/$18/$1A->4, else->5) for UI dispatch.
; Called: ?? times.
; 82 bytes | $0232B6-$023307
; ============================================================================
ClassifyEvent:                                                  ; $0232B6
    moveq   #$0,d0
    move.w  $0006(sp),d0
    moveq   #$15,d1
    cmp.w   d1,d0
    beq.b   .l232f4
    moveq   #$3,d1
    cmp.w   d1,d0
    beq.b   .l232f8
    moveq   #$1c,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$13,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$f,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$10,d1
    cmp.w   d1,d0
    beq.b   .l232fc
    moveq   #$7,d1
    cmp.w   d1,d0
    beq.b   .l23300
    moveq   #$18,d1
    cmp.w   d1,d0
    beq.b   .l23300
    moveq   #$1a,d1
    cmp.w   d1,d0
    beq.b   .l23300
    bra.b   .l23304
.l232f4:                                                ; $0232F4
    moveq   #$1,d0
    bra.b   .l23306
.l232f8:                                                ; $0232F8
    moveq   #$2,d0
    bra.b   .l23306
.l232fc:                                                ; $0232FC
    moveq   #$3,d0
    bra.b   .l23306
.l23300:                                                ; $023300
    moveq   #$4,d0
    bra.b   .l23306
.l23304:                                                ; $023304
    moveq   #$5,d0
.l23306:                                                ; $023306
    rts

; === Translated block $023308-$02377C ===
; 6 functions, 1140 bytes
