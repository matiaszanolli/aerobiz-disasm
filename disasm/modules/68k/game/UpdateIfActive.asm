; ============================================================================
; UpdateIfActive -- Conditionally run a single display update step by calling the step function only when flight_active is set.
; Called: ?? times.
; 16 bytes | $023DB6-$023DC5
; ============================================================================
UpdateIfActive:                                                  ; $023DB6
    tst.w   ($00FF000A).l
    beq.b   .l23dc4
    dc.w    $4eba,$0044                                 ; jsr $023E04
    nop
.l23dc4:                                                ; $023DC4
    rts
; === Translated block $023DC6-$023EA8 ===
; 3 functions, 226 bytes
