; ============================================================================
; FindCharInSet -- Looks up a byte value in the table at $048978; returns 1 if found, 0 if not found
; 42 bytes | $03ACB2-$03ACDB
; ============================================================================
; --- Phase: Setup ---
FindCharInSet:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d1
    ; d1 = byte value to search for (caller passes on stack, above 2 saved regs = $C offset)
    clr.w   d2
    ; d2 = table index (starts at 0)
    bra.b   l_3acc8
    ; enter loop at the load step (pre-load first table byte before comparing)

; --- Phase: Compare Loop ---
; Walk the null-terminated byte table at $048978, comparing each entry to d1.
l_3acbe:
    cmp.b   d1, d3
    ; compare current table entry (d3) with search target (d1)
    bne.b   l_3acc6
    ; not a match -> advance to next entry
    moveq   #$1,d0
    ; d0 = 1: found
    bra.b   l_3acd6
    ; return 1

l_3acc6:
    addq.w  #$1, d2
    ; advance table index to next byte

l_3acc8:
    movea.l  #$00048978,a0
    move.b  (a0,d2.w), d3
    ; d3 = table[d2]: load next byte from the set table
    ; The table is a null-terminated list of byte values (delimiter characters).
    ; Used by RenderTextBlock to decide whether a character triggers a line flush.
    bne.b   l_3acbe
    ; table byte != 0: valid entry, go compare
    ; table byte == 0: end of table reached, value not found
    moveq   #$0,d0
    ; d0 = 0: not found

; --- Phase: Return ---
l_3acd6:
    movem.l (a7)+, d2-d3
    rts

; RenderTextBlock: walk the text string at a2 byte-by-byte, processing escape codes
; and emitting tile words into a pair of parallel buffers (main + shadow/wide-right).
; Escape sequences start with $1B and are followed by a type byte and optional parameter bytes.
RenderTextBlock:                                                  ; $03ACDC
    link    a6,#-$94
    ; reserve $94 ($148) bytes of local frame for tile buffers, cursors, and working state
    movem.l d2-d7/a2-a5,-(sp)
    movea.l $0008(a6),a2
    ; a2 = source text string pointer (caller argument)
    movea.l #$00ff128a,a3
    ; a3 = cursor_x ($FF128A): current horizontal tile column for text output
    lea     -$0084(a6),a4
    ; a4 = primary tile output buffer (main plane word array in stack frame)
    lea     -$008c(a6),a5
    ; a5 = pointer to the secondary (wide-right / shadow) buffer pointer slot
    move.l  a4,-$0088(a6)
    ; -$88(a6) = running write pointer for primary buffer (starts at a4)
    move.l  a4,d0
    moveq   #$42,d1
    add.l   d1,d0
    move.l  d0,(a5)
    ; secondary buffer write pointer = a4 + $42 (66 bytes past primary, second half of frame)
    moveq   #$0,d0
    move.w  (a3),d0
    ; d0 = current cursor_x value
    moveq   #$20,d1
    ; d1 = $20: SignedMod divisor (wrap cursor within 32-column display width)
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    ; SignedMod: d0 = cursor_x mod 32 (normalise to [0, 31])
    move.w  d0,(a3)
    ; cursor_x = normalised value
    moveq   #$0,d0
    move.w  ($00FFBDA6).l,d0
    ; d0 = cursor_y (FFBDA6: vertical cursor position in tile rows)
    moveq   #$20,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    ; SignedMod: d0 = cursor_y mod 32 (wrap within 32-row tilemap)
    move.w  d0,($00FFBDA6).l
    ; cursor_y = normalised value
    clr.w   -$0090(a6)
    ; local column counter = 0 (tracks how many tiles written on current line)
    move.w  (a3),-$008e(a6)
    ; save initial cursor_x as the line start column (used for word-wrap decisions)
    clr.w   d5
    ; d5 = 0: line-alignment flag (0 = normal, 1 = centered / right-justified)
    clr.w   d4
    ; d4 = 0: "newline already handled" flag (prevents double-flush on \n after wrap)
    clr.w   d7
    ; d7 = 0: word-group tracking flag (set when processing a delimited word group)
    clr.w   d6
    ; d6 = group/word count or ID carried across word boundaries
    bra.w   .l3afc6
    ; jump to the fetch-next-character entry point of the main loop
; --- Phase: Main Character Dispatch Loop ---
; Each iteration: fetch next char from a2 into d3, decide how to handle it.
.l3ad3a:                                                ; $03AD3A
    move.b  $0001(a2),-$0091(a6)
    ; look-ahead: pre-load the *next* byte (a2+1) into local -$91(a6) for escape processing
    move.w  (a3),d0
    ; d0 = current cursor_x
    cmp.w   ($00FF1000).l,d0
    ; compare cursor_x against win_right_dup ($FF1000) — right window edge
    bcs.b   .l3ad50
    ; cursor is still within the window: check for forced line-break escape ($1B)
    cmpi.b  #$1b,d3
    ; d3 = current character byte (loaded at .l3afc6)
    bne.b   .l3ad72
    ; not an escape: cursor is past the right edge -> must flush the current line

; Word-wrap check: will the current word fit on this line?
.l3ad50:                                                ; $03AD50
    move.l  a2,-(sp)
    bsr.w SkipControlChars
    ; count how many more printable bytes remain until the next break/space
    addq.l  #$4,sp
    ; d0 = byte count of current word fragment
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  (a3),d1
    ; d1 = cursor_x
    add.l   d1,d0
    subq.l  #$1,d0
    ; d0 = cursor_x + word_length - 1 (last column the word would occupy)
    moveq   #$0,d1
    move.w  ($00FF1000).l,d1
    ; d1 = win_right_dup (right window boundary column)
    cmp.l   d1,d0
    blt.b   .l3ad9e
    ; word fits within the window -> emit character normally, no wrap needed
; Line flush: word won't fit (or cursor is past right edge) -> emit current line now
.l3ad72:                                                ; $03AD72
    pea     ($0001).w
    ; flush=1: commit the buffered tile words to VRAM/display
    move.w  d5,d0
    move.l  d0,-(sp)
    ; arg: d5 (line-justification flag)
    pea     -$0090(a6)
    ; arg: &local column counter
    pea     -$008e(a6)
    ; arg: &saved line-start cursor_x
    pea     -$008c(a6)
    ; arg: &secondary buffer pointer
    pea     -$0088(a6)
    ; arg: &primary buffer write pointer
    move.l  a4,-(sp)
    ; arg: primary buffer base
    bsr.w RenderTextLine
    ; flush the tile buffer: DMA/write the accumulated tile words to the display
    lea     $001c(sp),sp
    ; clean up 7 args
    moveq   #$1,d4
    ; d4 = 1: mark that a line was just flushed (prevents double-newline on next \n)
    cmpi.b  #$20,d3
    ; d3 = current char: if it is a space ($20), the wrap happened at a word boundary
    beq.w   .l3afc4
    ; space at wrap point: consume it (don't emit a space at start of next line)
; Check for explicit newline character ($0A = LF)
.l3ad9e:                                                ; $03AD9E
    cmpi.b  #$0a,d3
    ; $0A = ASCII line-feed / newline
    bne.b   .l3add0
    ; not a newline -> proceed to normal character dispatch

; Newline: flush the current line (unless one was just flushed by word-wrap)
    tst.w   d4
    ; d4 = "line already flushed" flag
    bne.b   .l3adca
    ; already flushed (wrap happened here): just reset d4, don't double-flush
    pea     ($0001).w
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    ; flush accumulated tile line to display
    lea     $001c(sp),sp
.l3adca:                                                ; $03ADCA
    clr.w   d4
    ; d4 = 0: clear flush flag (newline consumed)
    bra.w   .l3afc4
    ; advance to next character
; Not newline: check if we are inside a word-group (d7 != 0)
.l3add0:                                                ; $03ADD0
    tst.w   d7
    ; d7 != 0 means we are actively building a word group (delimited token)
    beq.b   .l3ae18
    ; d7 == 0: not in a word group, proceed to normal character output

; In a word group: flush the current tile line and then read input
    clr.l   -(sp)
    ; flush=0 (soft flush: do not advance to next tile row, keep cursor)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    ; output accumulated tile line for the word group
    pea     ($0001).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    ; jsr $01E2F4 (unknown function, likely ReadInput variant): d0 = button bits
    lea     $0020(sp),sp
    ; clean up RenderTextLine (7) + the above call (1) args
    move.w  d0,d2
    ; d2 = button input result
    tst.w   d2
    beq.b   .l3ae0a
    ; no button pressed: keep current group tracking state
    cmp.w   d2,d6
    beq.b   .l3ae0a
    ; same button as tracked in d6: still same group boundary, no change
    clr.w   d7
    ; new button detected: close the word group

.l3ae0a:                                                ; $03AE0A
    tst.w   d2
    beq.b   .l3ae14
    ; no button: d6 = 0
    moveq   #$0,d0
    move.w  d6,d0
    ; carry current group ID forward
    bra.b   .l3ae16
.l3ae14:                                                ; $03AE14
    moveq   #$0,d0
    ; d0 = 0 (no group)
.l3ae16:                                                ; $03AE16
    move.w  d0,d6
    ; update word-group tracking register

; --- Phase: Normal Character Output ---
; Determine the base tile attribute word for the current character.
.l3ae18:                                                ; $03AE18
    tst.w   ($00FF128C).l
    ; $FF128C: bold/highlight text mode flag (nonzero = bold/wide rendering)
    beq.b   .l3ae26
    move.w  #$8404,d2
    ; d2 = $8404: bold tile attribute (priority bit $8000 set, palette $04)
    bra.b   .l3ae2a
.l3ae26:                                                ; $03AE26
    move.w  #$0404,d2
    ; d2 = $0404: normal tile attribute (no priority, palette $04)
.l3ae2a:                                                ; $03AE2A
    cmpi.b  #$20,d3
    ; $20 = ASCII space
    bne.b   .l3ae68
    ; not a space -> handle printable non-space character
; Space character: emit a blank tile word into both buffers, advance cursor
    tst.w   ($00FF128C).l
    ; bold/wide mode flag
    beq.b   .l3ae4e
    ; normal mode: emit zero-word (transparent space tile)

; Bold mode: emit $8000 (priority-set transparent tile) for space
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    ; advance primary buffer pointer
    move.w  #$8000,(a0)
    ; write $8000 = priority transparent tile into primary buffer
.l3ae44:                                                ; $03AE44
    movea.l (a5),a0
    addq.l  #$2,(a5)
    ; advance secondary buffer pointer
    move.w  #$8000,(a0)
    ; write $8000 into secondary (wide-right) buffer too
    bra.b   .l3ae5e

.l3ae4e:                                                ; $03AE4E
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    clr.w   (a0)
    ; normal mode: write $0000 (blank tile, no priority) into primary buffer
.l3ae58:                                                ; $03AE58
    movea.l (a5),a0
    addq.l  #$2,(a5)
    clr.w   (a0)
    ; write $0000 into secondary buffer
.l3ae5e:                                                ; $03AE5E
    addq.w  #$1,(a3)
    ; cursor_x++ (advance one tile column)
    addq.w  #$1,-$0090(a6)
    ; local column counter++ (tracks tiles emitted on this line)
    bra.w   .l3adca
    ; clear newline-flush flag and fetch next character
; --- Phase: Printable Character Output ($21-$7E) ---
.l3ae68:                                                ; $03AE68
    cmpi.b  #$21,d3
    ; $21 = '!' (first printable non-space ASCII)
    bcs.b   .l3aec4
    ; d3 < $21: not a printable char -> check for escape ($1B)
    cmpi.b  #$7e,d3
    ; $7E = '~' (last standard printable ASCII)
    bhi.b   .l3aec4
    ; d3 > $7E: outside printable range -> check for escape

; Compute the tile index offset for this character based on font mode
    tst.w   ($00FF1800).l
    ; font_mode: 0 = narrow (single tile per char), 1 = wide (two tiles per char)
    beq.b   .l3ae88
    ; narrow mode: simple offset calculation

; Wide font mode: tile index = char * 2 + $19 (wide tile glyph table layout)
    moveq   #$0,d4
    move.b  d3,d4
    ; d4 = character byte value
    add.w   d4,d4
    ; d4 *= 2 (each wide char occupies 2 consecutive tile entries)
    addi.w  #$19,d4
    ; d4 += $19 (base offset into wide font tile table)
    bra.b   .l3ae90

.l3ae88:                                                ; $03AE88
; Narrow font mode: tile index = char - $20 (subtract space to get 0-based index)
    moveq   #$0,d4
    move.b  d3,d4
    ; d4 = character byte value
    addi.w  #$ffe0,d4
    ; d4 += $FFE0 = d4 - $20 (offset char into narrow font tile table)

.l3ae90:                                                ; $03AE90
    add.w   d4,d2
    ; d2 = base_attr ($0404 or $8404) + tile_index = full tile attribute word

; Emit tile word(s) into buffer(s)
    tst.w   ($00FF1800).l
    ; font_mode again: wide font needs two tile words (left + right halves)
    beq.b   .l3aeb0
    ; narrow: emit one word only

; Wide font: emit left half (d2) and right half (d2+1) into both buffers
    move.l  d2,d0
    ; d0 = left tile word
    addq.w  #$1,d2
    ; d2 = right tile word (next consecutive tile)
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  d0,(a0)
    ; write left tile to primary buffer
    movea.l (a5),a0
    addq.l  #$2,(a5)
    move.w  d2,(a0)
    ; write right tile to secondary buffer (wide-right plane)
    bra.b   .l3ae5e
    ; advance cursor_x and column counter

.l3aeb0:                                                ; $03AEB0
; Narrow font: emit one tile word into primary buffer
    movea.l -$0088(a6),a0
    addq.l  #$2,-$0088(a6)
    move.w  d2,(a0)
    ; write tile attr word to primary buffer
    tst.w   ($00FF128C).l
    ; bold mode: also write to secondary buffer?
    beq.b   .l3ae58
    ; not bold: write $0000 to secondary buffer (transparent)
    bra.b   .l3ae44
    ; bold: write $8000 (priority transparent) to secondary buffer
; --- Phase: Escape Sequence Dispatch ($1B = ESC) ---
.l3aec4:                                                ; $03AEC4
    cmpi.b  #$1b,d3
    ; $1B = ESC: start of an escape sequence
    bne.w   .l3afc4
    ; not ESC and not printable: unknown control character, skip

; Check if current line has buffered content that needs flushing before escape
    tst.w   -$0090(a6)
    ; local column counter: nonzero means tiles were written on this line
    beq.b   .l3af02
    ; nothing buffered: process escape immediately without flushing

; Line has content: check if the next char is a delimiter that requires a pre-flush
    move.b  -$0091(a6),d0
    ; d0 = look-ahead byte (the escape type byte, pre-loaded at loop top)
    move.l  d0,-(sp)
    bsr.w FindCharInSet
    ; check if the escape type is a "line-flush" delimiter (in the table at $048978)
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l3af02
    ; not a flush delimiter: skip pre-flush and process escape directly

; Flush the current tile line before executing the escape command
    clr.l   -(sp)
    ; flush=0 (soft flush)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    ; flush buffered tile line before changing text state
    lea     $001c(sp),sp

; Escape type dispatch: advance past $1B, read type byte, jump to handler
.l3af02:                                                ; $03AF02
    addq.l  #$1,a2
    ; skip past the $1B escape byte
    moveq   #$0,d0
    move.b  -$0091(a6),d0
    ; d0 = escape type byte (already pre-loaded in look-ahead)
    ; Dispatch table:
    ;   '=' ($3D): set cursor position (Y then X)
    ;   'R' ($52): set win_left_dup ($FF1290)
    ;   'E' ($45): set win_right_dup ($FF1000)
    ;   'G' ($47): enter word-group mode (start grouping)
    ;   'W' ($57): issue GameCommand $E (wait/sync)
    ;   'M' ($4D): toggle justification mode (d5)
    ;   'P' ($50): set bold/wide mode ($FF128C)
    moveq   #$3d,d1
    cmp.b   d1,d0
    beq.b   .l3af3a
    ; $3D = '=': set cursor (X, Y)
    moveq   #$52,d1
    cmp.b   d1,d0
    beq.b   .l3af5c
    ; $52 = 'R': set right margin / win_left_dup
    moveq   #$45,d1
    cmp.b   d1,d0
    beq.b   .l3af6e
    ; $45 = 'E': set right window edge / win_right_dup
    moveq   #$47,d1
    cmp.b   d1,d0
    beq.b   .l3af80
    ; $47 = 'G': begin word group mode (read initial button state)
    moveq   #$57,d1
    cmp.b   d1,d0
    beq.b   .l3af90
    ; $57 = 'W': wait (GameCommand $E)
    moveq   #$4d,d1
    cmp.b   d1,d0
    beq.b   .l3afa2
    ; $4D = 'M': toggle mirror/justification flag (d5)
    moveq   #$50,d1
    cmp.b   d1,d0
    beq.w   .l3afb0
    ; $50 = 'P': set bold/proportional mode flag ($FF128C)
    bra.w   .l3afc4
    ; unknown escape type: skip (advance past type byte and continue)
; ESC '=' handler: set cursor Y and X position
; Format: ESC '=' <Y+$20> <X+$20>  (values biased by $20 so they are printable bytes)
.l3af3a:                                                ; $03AF3A
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    ; d0 = encoded Y byte
    addi.w  #$ffe0,d0
    ; d0 -= $20: decode to actual row number
    move.w  d0,($00FFBDA6).l
    ; cursor_y = decoded Y value
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    ; d0 = encoded X byte
    addi.w  #$ffe0,d0
    ; d0 -= $20: decode to actual column number
    move.w  d0,(a3)
    ; cursor_x = decoded X value
    move.w  d0,-$008e(a6)
    ; also update saved line-start cursor (new absolute position resets the line origin)
    bra.b   .l3afc4

; ESC 'R' handler: set win_left_dup ($FF1290) — left margin / right column parameter
; Format: ESC 'R' <value+$20>
.l3af5c:                                                ; $03AF5C
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    ; decode value (subtract $20 bias)
    move.w  d0,($00FF1290).l
    ; win_left_dup = decoded value (adjusts left/right text window boundary)
    bra.b   .l3afc4

; ESC 'E' handler: set win_right_dup ($FF1000) — right window edge for word-wrap
; Format: ESC 'E' <value+$20>
.l3af6e:                                                ; $03AF6E
    moveq   #$0,d0
    addq.l  #$1,a2
    move.b  (a2),d0
    addi.w  #$ffe0,d0
    ; decode value
    move.w  d0,($00FF1000).l
    ; win_right_dup = decoded value (new right edge for word-wrap comparisons)
    bra.b   .l3afc4

; ESC 'G' handler: begin word-group mode — capture current button state as group ID
; Format: ESC 'G'  (no parameter bytes)
.l3af80:                                                ; $03AF80
    moveq   #$1,d7
    ; d7 = 1: enter word-group mode
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    ; ReadInput(0): read current joypad state without waiting
    addq.l  #$4,sp
    move.w  d0,d6
    ; d6 = button state at group entry (used to detect subsequent button changes)
    bra.b   .l3afc4

; ESC 'W' handler: wait one frame (GameCommand $E)
; Format: ESC 'W'  (no parameter bytes)
.l3af90:                                                ; $03AF90
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    ; GameCommand($E, 1): wait for V-blank / one-frame sync
    addq.l  #$8,sp
    bra.b   .l3afc4

; ESC 'M' handler: toggle text justification/mirror flag (d5)
; Format: ESC 'M'  (no parameter bytes)
.l3afa2:                                                ; $03AFA2
    tst.w   d5
    bne.b   .l3afaa
    ; d5 != 0: currently justified -> switch to normal
    moveq   #$1,d0
    ; set to 1 (enable justification)
    bra.b   .l3afac
.l3afaa:                                                ; $03AFAA
    moveq   #$0,d0
    ; set to 0 (disable justification)
.l3afac:                                                ; $03AFAC
    move.w  d0,d5
    ; d5 = new justification flag value
    bra.b   .l3afc4

; ESC 'P' handler: set bold/proportional (wide) mode flag ($FF128C)
; Format: ESC 'P' <mode>  where '1' ($31) = enable, anything else = disable
.l3afb0:                                                ; $03AFB0
    addq.l  #$1,a2
    ; advance to mode parameter byte
    cmpi.b  #$31,(a2)
    ; $31 = '1': enable bold/wide mode
    bne.b   .l3afbc
    moveq   #$1,d0
    ; mode = 1 (bold/wide enabled)
    bra.b   .l3afbe
.l3afbc:                                                ; $03AFBC
    moveq   #$0,d0
    ; mode = 0 (normal rendering)
.l3afbe:                                                ; $03AFBE
    move.w  d0,($00FF128C).l
    ; write bold/wide mode to $FF128C (read by tile-output paths above)

; Advance past the escape sequence byte (type byte or parameter byte)
.l3afc4:                                                ; $03AFC4
    addq.l  #$1,a2
    ; skip one byte (the escape type byte, or final parameter byte for multi-byte escapes)

; --- Phase: Fetch Next Character ---
.l3afc6:                                                ; $03AFC6
    move.b  (a2),d3
    ; d3 = next character from string
    bne.w   .l3ad3a
    ; d3 != 0: valid character, dispatch it; loop back to top

; --- Phase: End of String -- Flush Final Line and Return ---
; d3 == 0: null terminator reached
    clr.l   -(sp)
    ; flush=0 (final soft flush)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$0090(a6)
    pea     -$008e(a6)
    pea     -$008c(a6)
    pea     -$0088(a6)
    move.l  a4,-(sp)
    bsr.w RenderTextLine
    ; flush any remaining tile words in the buffers to the display
    movem.l -$00bc(a6),d2-d7/a2-a5
    ; restore callee-saved registers ($94 locals + $28 saved regs = $BC offset)
    unlk    a6
    rts
; === Translated block $03AFF2-$03B22C ===
; 2 functions, 570 bytes
