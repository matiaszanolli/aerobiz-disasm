; ============================================================================
; PrintfDirect -- Formats a string via Vsprintf into a local 152-byte buffer, then renders the result to screen via RenderTextBlock
; 32 bytes | $03B20C-$03B22B
; ============================================================================
PrintfDirect:
    link    a6,#-$98
    pea     -$96(a6)
    move.l  $c(a6), -(a7)
    move.l  $8(a6), -(a7)
    bsr.w Vsprintf
    pea     -$96(a6)
    bsr.w RenderTextBlock
    unlk    a6
    rts

; ---------------------------------------------------------------------------
; sprintf - Format string to buffer (C-style varargs)
; Params via LINK: dest (8,A6), format ($C,A6), varargs ($10,A6+)
; 171 calls | 26 bytes | $03B22C-$03B245
; ---------------------------------------------------------------------------
sprintf:
    link    a6,#0                                          ; $03B22C
    lea     $10(a6),a0                                     ; $03B230 | varargs ptr
    move.l  $08(a6),-(sp)                                  ; $03B234 | push dest
    move.l  a0,-(sp)                                       ; $03B238 | push varargs
    move.l  $0C(a6),-(sp)                                  ; $03B23A | push format
    bsr.w Vsprintf
    unlk    a6                                             ; $03B242
    rts                                                    ; $03B244
; ---------------------------------------------------------------------------
; PrintfNarrow - Format and display string (1-tile narrow font)
; Params: format (8,A6), varargs ($C,A6+)
; 65 calls | 42 bytes | $03B246-$03B26F
; ---------------------------------------------------------------------------
PrintfNarrow:
    link    a6,#0                                          ; $03B246
    lea     $0C(a6),a0                                     ; $03B24A | varargs ptr
    clr.w   ($FF1800).l                                    ; $03B24E | font_mode = 0 (narrow)
    moveq   #1,d0                                          ; $03B254
    move.w  d0,($FFA77A).l                                 ; $03B256 | cursor_advance = 1
    move.w  d0,($FF99DE).l                                 ; $03B25C | char_width = 1
    move.l  a0,-(sp)                                       ; $03B262 | push varargs
    move.l  $08(a6),-(sp)                                  ; $03B264 | push format
    bsr.w PrintfDirect
    unlk    a6                                             ; $03B26C
    rts                                                    ; $03B26E
; ---------------------------------------------------------------------------
; PrintfWide - Format and display string (2-tile wide font)
; Params: format (8,A6), varargs ($C,A6+)
; 97 calls | 44 bytes | $03B270-$03B29B
; ---------------------------------------------------------------------------
PrintfWide:
    link    a6,#0                                          ; $03B270
    lea     $0C(a6),a0                                     ; $03B274 | varargs ptr
    move.w  #1,($FF1800).l                                 ; $03B278 | font_mode = 1 (wide)
    moveq   #2,d0                                          ; $03B280
    move.w  d0,($FFA77A).l                                 ; $03B282 | cursor_advance = 2
    move.w  d0,($FF99DE).l                                 ; $03B288 | char_width = 2
    move.l  a0,-(sp)                                       ; $03B28E | push varargs
    move.l  $08(a6),-(sp)                                  ; $03B290 | push format
    bsr.w PrintfDirect
    unlk    a6                                             ; $03B298
    rts                                                    ; $03B29A
; === Translated block $03B29C-$03CB36 ===
; 19 functions, 6298 bytes
