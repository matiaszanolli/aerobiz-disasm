; ============================================================================
; ClearCharSprites -- Clears the char sprite panel by calling GameCommand $0037 with flag 4
; Called: ?? times.
; 18 bytes | $0377C8-$0377D9
; ============================================================================
ClearCharSprites:                                                  ; $0377C8
    pea     ($0004).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    addq.l  #$8,sp
    rts

; === Translated block $0377DA-$038544 ===
; 3 functions, 3434 bytes
