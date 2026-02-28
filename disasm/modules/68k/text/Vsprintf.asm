; ============================================================================
; Vsprintf -- C-style vsprintf implementation: formats a string into a buffer using a format string and va_list; supports %d, %u, %x, %s, %c, %w, width/precision, left-align, zero-pad, $ currency
; 538 bytes | $03AFF2-$03B20B
; ============================================================================
Vsprintf:
; --- Phase: Setup ---
; Args: $8(a6)=dest_ptr (output buffer), $C(a6)=va_list_ptr (pointer to arg list),
;       $10(a6)=format_str_ptr (C-style format string)
; Internal state (stack frame, -$EC bytes):
;   -$e6(a6) = scratch buffer for digit conversion (IntToDecimalStr/IntToHexStr write here)
;   -$e2(a6) = format_ptr_cell (current position in format string -- updated in place)
;   -$eb(a6) = pad_char byte ('0' or ' ')
;   -$e8(a6) = currency_flag (1 = prepend '$' sign)
;   -$ea(a6) = currency_compact_flag (1 = compact currency, omit "0K" suffix)
;   -$de(a6) = converted_str (digit conversion output lands here, read by output loop)
;   -$c8(a6) = output_buf (local working copy of output; copied to dest on exit)
; d2=current_char, d3=field_width(adjusted down as chars are placed), d4=type_flags
; d5=precision, d6=left_align_flag, d7=has_precision_flag
; a2=output_write_ptr, a3=va_arg_ptr (stepped +4 per arg consumed)
; a4=converted_str_write_ptr (-$de(a6) write head), a5=format_ptr_cell_ptr
    link    a6,#-$EC
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a3           ; a3 = va_list base (pointer to first argument)
    lea     -$e6(a6), a4         ; a4 -> converted_str_write_ptr cell (holds write head)
    lea     -$e2(a6), a5         ; a5 -> format_ptr_cell (pointer to current format char)
    lea     -$c8(a6), a2         ; a2 = output_write_ptr (write head into local output_buf)
    move.l  $8(a6), (a5)         ; format_ptr_cell = format_str_ptr (start of format string)
    bra.w   l_3b1ea              ; enter main loop by fetching first char

; --- Phase: Main Format Loop ---
; Each iteration: d2 = current format char; non-% chars go straight to output
l_3b012:
; '%' detected: begin format specifier parsing
    cmpi.b  #$25, d2             ; $25 = '%': start of format specifier?
    bne.w   l_3b1e8              ; not '%': copy char verbatim to output

; Reset per-specifier state
    lea     -$de(a6), a0
    move.l  a0, (a4)             ; reset converted_str_write_ptr to start of scratch buffer
    moveq   #$6,d5               ; d5 = default precision = 6
    clr.w   d7                   ; d7 = has_precision_flag = 0 (no '.' seen yet)
    clr.w   d6                   ; d6 = left_align_flag = 0 (right-align default)
    clr.w   -$e8(a6)             ; currency_flag = 0
    clr.w   -$ea(a6)             ; currency_compact_flag = 0

; Advance past '%', fetch next char
    movea.l (a5), a0
    move.b  (a0), d2

; Check for '-' flag (left-align)
    cmpi.b  #$2d, d2             ; $2D = '-': left-align flag
    bne.b   l_3b040
    moveq   #$1,d6               ; d6 = 1 (left-align enabled)
    addq.l  #$1, (a5)            ; advance format pointer
    movea.l (a5), a0
    move.b  (a0), d2

l_3b040:
; Check for '$' flag (first occurrence = currency mode)
    cmpi.b  #$24, d2             ; $24 = '$': currency format flag
    bne.b   l_3b064
    move.w  #$1, -$e8(a6)        ; currency_flag = 1 (prepend '$' sign to output)
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2
; Second '$' = compact currency (omit "0K" suffix for zero values)
    cmpi.b  #$24, d2             ; second '$'?
    bne.b   l_3b064
    move.w  #$1, -$ea(a6)        ; currency_compact_flag = 1
    addq.l  #$1, (a5)
    movea.l (a5), a0
    move.b  (a0), d2

l_3b064:
; Determine pad character: '0' if next char is '0', else ' '
    cmpi.b  #$30, d2             ; $30 = '0': zero-pad flag
    bne.b   l_3b06e
    moveq   #$30,d0              ; pad_char = '0' (zero padding)
    bra.b   l_3b070
l_3b06e:
    moveq   #$20,d0              ; pad_char = ' ' (space padding, default)
l_3b070:
    move.b  d0, -$eb(a6)         ; store pad character byte

; Parse width field (sequence of decimal digits after flags)
    cmpi.b  #$30, d2             ; d2 >= '0' ?
    bcs.b   l_3b094              ; no: no width specified
    cmpi.b  #$39, d2             ; d2 <= '9' ?
    bhi.b   l_3b094              ; no: not a digit
; ParseDecimalDigit: parse decimal integer from format string, advances format_ptr_cell
    pea     -$e2(a6)             ; pass format_ptr_cell pointer
    bsr.w ParseDecimalDigit      ; returns D0.L = parsed width value
    addq.l  #$4, a7
    move.l  d0, d3
    andi.l  #$ffff, d3           ; d3 = field_width (remaining space to fill with pad)
    bra.b   l_3b096
l_3b094:
    moveq   #$0,d3               ; d3 = 0 (no width specified)

l_3b096:
; Check for '.' (precision separator)
    movea.l (a5), a0
    addq.l  #$1, (a5)            ; consume one char from format string
    move.b  (a0), d0
    move.b  d0, d2               ; d2 = next format char
    cmpi.b  #$2e, d0             ; '.' = precision specifier follows?
    bne.b   l_3b0b8
; Parse precision: ParseDecimalDigit again
    pea     -$e2(a6)
    bsr.w ParseDecimalDigit
    addq.l  #$4, a7
    move.w  d0, d5               ; d5 = precision value
    moveq   #$1,d7               ; d7 = 1 (has_precision_flag: '.N' was present)
    movea.l (a5), a0
    addq.l  #$1, (a5)
    move.b  (a0), d2

l_3b0b8:
; Check for 'l' or 'L' size modifier (treat as long -- ignored, already using 32-bit)
    moveq   #$0,d0
    move.b  d2, d0
    move.l  d0, -(a7)
    jsr ToUpperCase              ; uppercase the char for case-insensitive compare
    moveq   #$4C,d1              ; $4C = 'L' (long modifier)
    cmp.l   d0, d1
    bne.b   l_3b0d0
    movea.l (a5), a0             ; 'L' found: skip it (already treating as long)
    addq.l  #$1, (a5)
    move.b  (a0), d2

l_3b0d0:
    clr.b   d4                   ; d4 = type_flags byte (bit 0=numeric, bit 1=has_str)

; --- Phase: Format Type Dispatch ---
; Uppercase the type character and dispatch to the appropriate handler
    moveq   #$0,d0
    move.b  d2, d0
    move.l  d0, -(a7)
    jsr ToUpperCase              ; uppercase for case-insensitive type match
    addq.l  #$8, a7
    andi.l  #$ff, d0

    moveq   #$44,d1              ; $44 = 'D': signed decimal integer
    cmp.b   d1, d0
    beq.b   l_3b114

    moveq   #$55,d1              ; $55 = 'U': unsigned decimal integer (same path post-sign)
    cmp.b   d1, d0
    beq.b   l_3b124

    moveq   #$58,d1              ; $58 = 'X': hexadecimal integer
    cmp.b   d1, d0
    beq.b   l_3b13a

    moveq   #$53,d1              ; $53 = 'S': string pointer
    cmp.b   d1, d0
    beq.b   l_3b146

    moveq   #$43,d1              ; $43 = 'C': single character
    cmp.b   d1, d0
    beq.b   l_3b15a

    moveq   #$57,d1              ; $57 = 'W': wide integer (word-sized; d3 and d5 doubled)
    cmp.b   d1, d0
    beq.b   l_3b166

    tst.b   d0
    beq.w   l_3b202              ; NUL byte in format = end of string (shouldn't happen mid-spec)
    bra.w   l_3b1e8              ; unknown type: copy character verbatim

; --- Handler: %d (signed decimal) ---
l_3b114:
; If value is negative: negate it, emit '-' into scratch buffer, reduce width by 1
    tst.l   (a3)                 ; check sign of arg (a3 points to current va_list argument)
    bge.b   l_3b124              ; non-negative: skip sign handling
    neg.l   (a3)                 ; negate: make it positive for digit conversion
    movea.l (a4), a0             ; a0 = current converted_str_write_ptr
    addq.l  #$1, (a4)            ; advance write pointer
    move.b  #$2d, (a0)           ; '-' = $2D: write minus sign to scratch buffer
    subq.w  #$1, d3              ; width--: minus sign consumed one width column

; --- Handler: %u (unsigned decimal) / falls through from %d after sign ---
l_3b124:
; IntToDecimalStr: convert the longword arg to decimal ASCII in the scratch buffer
    move.l  (a3), -(a7)          ; push longword arg value
    pea     -$e6(a6)             ; push scratch buffer pointer
    bsr.w IntToDecimalStr        ; convert to decimal digits; D0 = digit count
l_3b12e:
    addq.l  #$8, a7
    sub.w   d0, d3               ; d3 -= digit_count (remaining width = pad needed)
    addq.l  #$4, a3              ; advance va_list by 4 bytes (consume one long arg)
l_3b134:
    ori.b   #$1, d4              ; type_flags |= 1 (numeric: converted string is in scratch)
    bra.b   l_3b16c              ; proceed to padding/output

; --- Handler: %x (hexadecimal) ---
l_3b13a:
    move.l  (a3), -(a7)
    pea     -$e6(a6)
    bsr.w IntToHexStr            ; convert to hex ASCII; D0 = digit count
    bra.b   l_3b12e

; --- Handler: %s (string pointer) ---
l_3b146:
; The arg is a pointer to a null-terminated string
    move.l  (a3), (a4)           ; store string pointer into the write-pointer cell (a4 points there)
    move.l  (a4), -(a7)          ; push the string pointer
    bsr.w CountFormatChars       ; count chars in the string; D0 = length
    addq.l  #$4, a7
    sub.w   d0, d3               ; d3 -= string_length (remaining width)
    addq.l  #$4, a3              ; consume string pointer arg
    ori.b   #$2, d4              ; type_flags |= 2 (string: no extra null-terminate step)
    bra.b   l_3b16c

; --- Handler: %c (single character) ---
l_3b15a:
; Write the single character directly into the scratch buffer
    subq.w  #$1, d3              ; width-- (one char consumed)
    move.l  (a3)+, d0            ; consume arg (long, only low byte used)
    movea.l (a4), a0
    addq.l  #$1, (a4)
    move.b  d0, (a0)             ; write character byte to scratch buffer
    bra.b   l_3b134              ; mark as numeric type (one char in scratch)

; --- Handler: %w (wide: doubled field width and precision) ---
l_3b166:
; Wide format: double d5 (precision) and d3 (width) for 2-tile wide font metrics
    add.w   d5, d5               ; precision *= 2
    add.w   d3, d3               ; field_width *= 2
    bra.b   l_3b124              ; then treat as unsigned decimal

; --- Phase: Padding and Output ---
l_3b16c:
; If type_flags bit 0 (numeric): null-terminate the scratch buffer and reset write pointer
    btst    #$0, d4              ; bit 0 = numeric conversion done?
    beq.b   l_3b182
    movea.l (a4), a0
    clr.b   (a0)                 ; NUL-terminate the converted number string
    lea     -$de(a6), a0
    move.l  a0, (a4)             ; reset write pointer to start of scratch buffer
    clr.w   d7                   ; clear has_precision_flag (not applicable to numbers)
    ori.b   #$2, d4              ; type_flags |= 2 (now treated as string for output)

l_3b182:
; If type_flags bit 1 set: emit padding/content to output buffer
    btst    #$1, d4
    beq.b   l_3b1ea              ; no output to produce: fetch next format char

; d3 = remaining padding width (may be negative if content exceeds width -- no padding)
    move.w  d3, d2               ; d2 = saved width (used for right-pad after content)
    bra.b   l_3b190              ; enter left-padding loop

; Left-pad loop: emit pad_char while d3 > 0 and left_align==0
l_3b18c:
    move.b  -$eb(a6), (a2)+      ; emit pad_char (' ' or '0')
l_3b190:
    move.l  d3, d0
    subq.w  #$1, d3              ; decrement remaining pad count
    tst.w   d0                   ; d0 was the old d3: > 0?
    ble.b   l_3b19c              ; no more pad needed
    tst.w   d6                   ; left_align? (d6==1 means skip left-pad)
    beq.b   l_3b18c              ; not left-align: emit pad char

l_3b19c:
; If currency_flag: emit '$' before the number digits
    tst.w   -$e8(a6)             ; currency_flag set?
    beq.b   l_3b1b8
    move.b  #$24, (a2)+          ; '$' = $24: prepend currency symbol

; Content copy loop: copy converted/string content to output buffer
    bra.b   l_3b1b8

l_3b1a8:
; Inner loop: copy one char from converted string to output
; If has_precision: only copy up to d5 chars (precision limit)
    tst.w   d7                   ; has_precision_flag?
    beq.b   l_3b1b0              ; no precision: copy unconditionally
    tst.w   d5                   ; precision count exhausted?
    ble.b   l_3b1b6              ; yes: skip copy, just advance source ptr
l_3b1b0:
    movea.l (a4), a0             ; a0 = current source read pointer
    move.b  (a0), (a2)+          ; copy one byte to output buffer
    subq.w  #$1, d5              ; decrement precision counter
l_3b1b6:
    addq.l  #$1, (a4)            ; advance source read pointer
l_3b1b8:
    movea.l (a4), a0
    tst.b   (a0)                 ; reached NUL terminator of converted string?
    bne.b   l_3b1a8              ; no: keep copying

; Post-content: append "0K" suffix for currency if compact_flag not set
    tst.w   -$e8(a6)
    beq.b   l_3b1da              ; no currency flag: skip suffix
    cmpi.w  #$1, -$ea(a6)        ; compact currency (second '$')? skip "0K"
    beq.b   l_3b1da
    move.b  #$30, (a2)+          ; '0' ($30): append "0" for thousands abbreviation
    move.b  #$4b, (a2)+          ; 'K' ($4B): append "K" -> renders as "0K" (zero thousands)
    bra.b   l_3b1da

; Right-pad loop (for left-align): emit pad_char while d2 > 0 and left_align==1
l_3b1d6:
    move.b  -$eb(a6), (a2)+      ; emit trailing pad char (right-padding for left-align)
l_3b1da:
    move.l  d2, d0
    subq.w  #$1, d2              ; decrement right-pad counter
    tst.w   d0
    ble.b   l_3b1ea              ; done padding
    tst.w   d6                   ; left_align mode?
    bne.b   l_3b1d6              ; yes: emit trailing pad
    bra.b   l_3b1ea

; Verbatim copy: not a format specifier, write char as-is to output
l_3b1e8:
    move.b  d2, (a2)+            ; copy current char verbatim to output buffer

; --- Phase: Advance Format Pointer and Fetch Next Char ---
l_3b1ea:
    movea.l (a5), a0             ; a0 = format_ptr_cell (pointer to current format string pos)
    addq.l  #$1, (a5)            ; advance format string pointer by 1
    move.b  (a0), d2             ; d2 = next format char
    bne.w   l_3b012              ; not NUL: process next char
; Format string exhausted: NUL-terminate output buffer
    clr.b   (a2)                 ; write NUL terminator at end of output_buf

; --- Phase: Copy Local Buffer to Caller's Destination ---
; Copy the null-terminated local output_buf to the dest_ptr provided by caller
    lea     -$c8(a6), a0         ; a0 = start of local output buffer
    movea.l $10(a6), a1          ; a1 = dest_ptr (caller-provided destination)
l_3b1fe:
    move.b  (a0)+, (a1)+         ; copy one byte from local buf to dest
    bne.b   l_3b1fe              ; repeat until NUL is copied (NUL also transferred)

; --- Phase: Return ---
l_3b202:
    movem.l -$114(a6), d2-d7/a2-a5
    unlk    a6
    rts
