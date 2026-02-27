; ============================================================================
; EarlyInit -- TMSS boot screen: detect region, load font tiles, render license text to VDP
; 302 bytes | $003BE8-$003D15
; ============================================================================
; --- Phase: Region Detection ---
; Read the hardware version register to detect the console's region and TV system.
; The version register lives at $A10001 (I/O area). Bits [7:6] encode the region:
;   00 = Japan (NTSC), 01 = (unused), 10 = USA (NTSC), 11 = Europe (PAL).
; This determines which license string to display on the TMSS boot screen.
EarlyInit:
    clr.l   d0
    move.b  ($00A10001).l, d0     ; read hardware version register (I/O port 1 control)
    lsr.b   #$6, d0               ; shift region bits [7:6] down to [1:0]
    andi.b  #$3, d0               ; mask to 2-bit region index (0-3)
    lea     $3d16(pc), a0         ; a0 -> TMSSRegionTable (4-byte table: J, \0, U, E)
    move.b  (a0,d0.w), d0         ; d0 = region character ('J', 'U', 'E', or $00)
    tst.b   d0                    ; is the region code null (no match)?
    beq.w   l_03cde               ; yes: skip TMSS screen, jump to infinite halt
; --- Phase: TMSS Security Check ---
; The console's ROM at $01F0-$01FF holds the "SEGA" security string (16 bytes).
; The TMSS hardware only unlocks cartridge access if this matches. Here the code
; additionally confirms the region character is present in those bytes. If found,
; the beq jumps to the real game entry point ($003F70), skipping the TMSS screen.
; If not found after 16 comparisons, execution falls through to render the TMSS text.
    lea     ($01F0).w, a0         ; a0 -> ROM security string at $01F0 (16 bytes, "SEGA MEGA DRIVE...")
    move.w  #$f, d1               ; d1 = 15 (loop counter for 16 bytes)
l_03c0c:
    cmp.b   (a0), d0              ; does this byte match the region character?
    dc.w    $6700,$0360           ; beq $003F70 -- match found: jump to game start
    addq.l  #$1, a0               ; advance to next byte
    dbra    d1, $3C0C             ; loop for all 16 bytes of security string
; --- Phase: VDP Minimal Init for TMSS Screen ---
; The VDP is initialized just enough to write tile graphics and name-table cells
; for the TMSS license text. A4 = VDP data port, A5 = VDP control port.
; The VDP command word format for register writes: $8NVV where N = reg#, VV = value.
    lea     ($00C00000).l, a4     ; a4 = VDP data port ($C00000)
    lea     ($00C00004).l, a5     ; a5 = VDP control port ($C00004) -- also VDP status (read)
    move.w  #$8164, (a5)          ; VDP reg $01 = $64: display enable, V28 (224 lines), Genesis mode bit2=1
    move.w  #$8230, (a5)          ; VDP reg $02 = $30: Plane A name table at VRAM $C000 ($30 << 10)
    move.w  #$8c81, (a5)          ; VDP reg $0C = $81: H40 mode (320px wide), no interlace, no shadow/highlight
    move.w  #$8f02, (a5)          ; VDP reg $0F = $02: auto-increment = 2 (advance by 2 bytes after each VRAM write)
    move.w  #$9001, (a5)          ; VDP reg $10 = $01: scroll size = 64 cols x 32 rows (H=64, V=32)
; Set VDP VRAM write address to $0200 (tile data start for TMSS font).
; VDP command word for VRAM write: upper long = $C0000000 | (addr & $3FFF)<<16 | (addr>>14)
; $C0020000 = VRAM write to address $0200 ($02 in bits[17:16] of the long)
    move.l  #$c0020000, (a5)      ; set VRAM write address = $0200 (start of font tile VRAM slot)
; Write a single word to VRAM at $0200 -- initializes the first word of tile 0 (blank tile header).
; Value $0EEE = 4 pixels of palette index 14 (used as background color).
    move.w  #$eee, (a4)           ; write $0EEE to VRAM data port (first word of blank tile, 4 pixels = color 14)
; After the font tiles we need to write name-table cells (BAT entries) into Plane A.
; Reset VRAM write address to $4000 = Plane A name table base (reg$02=$30 -> $C000? -- TBC).
; $40000000 = VRAM write address command for address $0000 with CD[5:4]=01 (VRAM write).
    move.l  #$40000000, (a5)      ; set VRAM write address = $0000 (Plane A BAT base for name-table cells)
; --- Phase: Font Tile Upload (1bpp -> 4bpp Expansion) ---
; Upload 59 font tiles (TMSSFontTiles at $3D98) to VRAM.
; Each tile is 8 bytes of 1bpp data (1 bit per pixel, 8x8 = 64 pixels).
; The VDP wants 4bpp tiles: 32 bytes per tile (8 rows x 4 bytes, 2 pixels per nibble).
; The expansion loop converts each bit to a 4-pixel run in d2 using a rotating palette index,
; OR-ing the run into d4 to build each output long, then writing d4 to the VDP data port.
; Result: each 0-bit pixel gets color 0 (transparent), each 1-bit pixel gets a cycling palette index.
    lea     $3d98(pc), a0         ; a0 -> TMSSFontTiles (59 tiles x 8 bytes = 472 bytes of 1bpp data)
    move.w  #$3a, d0              ; d0 = $3A = 58 (loop count for 59 tiles, dbra counts down to -1)
    move.l  #$10000000, d2        ; d2 = rotating color index register, starts with palette index 1 in bits[31:28]
l_03c56:
; Outer tile loop: 8 source bytes per tile = 8 VDP long writes (one per tile row)
    move.w  #$7, d6               ; d6 = 7 (inner row counter, 8 rows per tile)
l_03c5a:
; Per-row loop: convert one byte of 1bpp data into one VDP long (4bpp, 8 pixels)
    move.b  (a0)+, d1             ; d1 = next source byte (8 pixels, MSB = leftmost pixel)
    moveq   #$0,d4                ; d4 = output accumulator (will hold 8 expanded pixels as 4bpp nibbles)
    move.w  #$7, d5               ; d5 = 7 (bit counter, 8 bits per byte)
l_03c62:
; Per-pixel loop: expand each 1bpp pixel to a 4-bit palette index
    rol.l   #$4, d2               ; rotate color register left 4 bits (cycle through palette indices 1,2,...,F,0,1,...)
    ror.b   #$1, d1               ; shift next source bit into carry (LSB first after first ROR makes MSB go last -- MSB first because we start at bit7)
    bcc.b   l_03c6a               ; if bit was 0: skip OR (pixel stays transparent, color 0)
    or.l    d2, d4                ; bit was 1: OR the current color nibble position into output accumulator
l_03c6a:
    dbra    d5, $3C62             ; loop for all 8 bits of source byte
    move.l  d4, (a4)              ; write 8 expanded pixels (one tile row) to VDP data port (auto-increment +2 advances by word, but we write long)
    dbra    d6, $3C5A             ; loop for all 8 rows of tile
    dbra    d0, $3C56             ; loop for all 59 tiles
; --- Phase: Render "DEVELOPED FOR USE ONLY WITH" Header Row ---
; WriteVDPTileRow takes d1 = tile row (Y position in name table), d0 = tile column (X),
; and (a0) = null-terminated string of ASCII chars to write as BAT name-table entries.
; Each character is mapped to a tile index by subtracting $20 (ASCII space = tile 0).
    move.b  #$8, d1               ; d1 = 8 (tile row for the top license text line)
    lea     $3d2e(pc), a0         ; a0 -> TMSSTopStr: [col_byte] "DEVELOPED FOR USE ONLY WITH\0"
    move.b  (a0)+, d0             ; d0 = tile column (first byte of string: $06 = column 6); a0 now -> text
    bsr.w WriteVDPTileRow         ; write "DEVELOPED FOR USE ONLY WITH" to Plane A at row 8, col 6
; --- Phase: Render Region-Specific License Text ---
; Scan the ROM security string at $01F0-$01FF to find the region char ('J','U','E').
; For each char in the security string, look it up in TMSSCharTable ($3D1A), which
; maps region chars to draw-string offsets from TMSSRegionTable ($3D16).
; When matched: optionally write the separator string "&", then write the region
; system name string (e.g. "NTSC MEGA DRIVE", "NTSC GENESIS", "PAL AND FRENCH...").
; When the security string ends (space char), write "SYSTEMS." on the final row.
    lea     ($01F0).w, a1         ; a1 -> ROM security string at $01F0 (e.g. "SEGA MEGA DRIVE  J")
l_03c8a:
    cmpi.b  #$20, (a1)            ; is current byte a space (end of meaningful content)?
    beq.b   l_03cd2               ; yes: fall through to write final "SYSTEMS." row
    lea     $3d1a(pc), a2         ; a2 -> TMSSCharTable: 3 entries of (word char, long offset), terminated by $0000
l_03c94:
    move.w  (a2)+, d4             ; d4 = table entry char code (word, e.g. $004A = 'J')
    tst.b   d4                    ; is this the end-of-table sentinel ($0000)?
    beq.b   l_03cce               ; yes: no match found for this char, advance to next security byte
    cmp.b   (a1), d4              ; does this table entry match the current security string byte?
    bne.b   l_03cca               ; no: try next table entry
; Found a match: check if next byte is a space (word boundary) to avoid matching mid-word
    cmpi.b  #$20, $1(a1)         ; is the following byte a space (end of a word token)?
    bne.b   l_03cba               ; no: skip the separator "&" -- match is part of a longer word
    cmpa.l  #$1f0, a1             ; are we at the very start of the security string ($01F0)?
    beq.b   l_03cba               ; yes: skip separator (no preceding word to separate)
; Write the "&" separator on a new tile row (between first and second lines of license text)
    lea     $3d4b(pc), a0         ; a0 -> TMSSSpaceStr: [col=$12] "&\0"
    move.b  (a0)+, d0             ; d0 = column byte ($12 = col 18); a0 -> "&\0"
    addq.w  #$1, d1               ; advance to next tile row (d1++)
    bsr.w WriteVDPTileRow         ; write "&" at row d1, col 18
l_03cba:
; Write the region system string (e.g. "NTSC MEGA DRIVE" / "NTSC GENESIS" / "PAL AND...")
    lea     $3d16(pc), a0         ; a0 -> TMSSRegionTable base ($3D16)
    adda.l  (a2)+, a0             ; add offset from table entry: a0 -> region-specific draw string
    move.b  (a0)+, d0             ; d0 = tile column for this string; a0 -> null-terminated text
    addq.w  #$1, d1               ; advance to next tile row
    bsr.w WriteVDPTileRow         ; write region system name (e.g. "NTSC MEGA DRIVE")
    bra.b   l_03cce               ; done with this table scan, continue scanning security string
l_03cca:
    addq.l  #$4, a2               ; skip past this non-matching table entry (word char + long offset = 6 bytes, but a2 already ate 2 for the word, so +4 = skip the long)
    bra.b   l_03c94               ; try next table entry
l_03cce:
    addq.l  #$1, a1               ; advance to next byte in ROM security string
    bra.b   l_03c8a               ; loop until we find a space (end of string)
l_03cd2:
; Write the final row: "SYSTEMS." to close the license text
    lea     $3d4e(pc), a0         ; a0 -> TMSSSystemsStr: [col=$0F] "SYSTEMS.\0"
    move.b  (a0)+, d0             ; d0 = column byte ($0F = col 15); a0 -> "SYSTEMS.\0"
    addq.w  #$1, d1               ; advance to next tile row
    bsr.w WriteVDPTileRow         ; write "SYSTEMS." at row d1, col 15
; --- Phase: TMSS Boot Screen Complete -- Infinite Halt ---
; All license text has been written to VRAM. The screen is now visible.
; The code halts here in an infinite loop; the console must be reset or the
; game cart must match the TMSS check to escape (via the beq to $3F70 above).
l_03cde:
    bra.b   l_03cde               ; infinite loop -- TMSS screen displayed, wait for reset

; --- Subroutine: WriteVDPTileRow ---
; Write a null-terminated string of ASCII chars as VDP name-table (BAT) entries.
; Inputs: d1 = tile row (Y, 0-based), d0 = tile column (X, 0-based), (a0) = string.
; Uses: a4 = VDP data port ($C00000), a5 = VDP control port ($C00004).
; Each character is converted to a tile index by subtracting $20 (ASCII ' ' -> tile 0).
; The VDP VRAM write address for the name table cell at (col, row) is computed as:
;   addr = row * $80 + col * 2   (H40 mode: 64 cols * 2 bytes = $80 bytes per row)
; The VDP command word (long) for VRAM write = $40000003 | (addr & $3FFF)<<16 | addr>>14
WriteVDPTileRow:                                        ; $003CE0
; Build VDP VRAM write address command for cell (d0 col, d1 row) in the name table
    move.b  d1, d2                ; d2 = row index (byte)
    andi.l  #$ff, d2              ; zero-extend row to long
    swap    d2                    ; move row to high word of d2 for address calculation
    lsl.l   #$7, d2               ; row * $80 (H40 name table: 64 cols * 2 bytes = $80 per row) -- now in high word position
    move.b  d0, d3                ; d3 = column index (byte)
    andi.l  #$ff, d3              ; zero-extend column to long
    swap    d3                    ; move col to high word
    asl.l   #$1, d3               ; col * 2 (2 bytes per name-table cell)
    add.l   d3, d2                ; d2 = combined VRAM address (row*$80 + col*2) in high word
    addi.l  #$40000003, d2        ; add VDP VRAM-write command prefix: $4000 (CD=01 VRAM write) and low-word address bits
    move.l  d2, (a5)              ; write command word to VDP control port -- sets VRAM write address
; Write each character of the string as a name-table tile index word
l_03d02:
    tst.b   (a0)                  ; is this the null terminator?
    beq.b   l_03d14               ; yes: done writing this row
    move.b  (a0)+, d2             ; d2 = next ASCII character from string
    subi.b  #$20, d2              ; convert ASCII to tile index (space=$20 -> tile 0, 'A'=$41 -> tile $21)
    andi.w  #$ff, d2              ; zero-extend byte to word (VDP name-table entry is a word)
    move.w  d2, (a4)              ; write tile index to VDP data port (auto-increment advances VRAM by 2)
    bra.b   l_03d02               ; loop to next character
l_03d14:
    rts


; TMSS boot-screen data block ($003D16-$003F6F, 858 bytes)
; EarlyInit ($003BE8) reads region code then renders Sega license text to VDP
; using WriteVDPTileRow ($003CE0). Data layout: region table, char->offset table,
; null-terminated draw strings (each prefixed by a VDP tile-column byte), then
; 59 tiles of 1bpp glyph bitmaps for the character rendering engine.

; 4-byte region code table indexed by version register bits[7:6] (0-3).
; EarlyInit: clr.l d0 / move.b ($A10001),d0 / lsr.b #6,d0 / andi.b #3,d0 /
;   lea TMSSRegionTable(pc),a0 / move.b (a0,d0.w),d0 -> system identifier char
; Byte values: [0]='J' (Japan), [1]=$00 (none), [2]='U' (USA), [3]='E' (Europe)
TMSSRegionTable:                                                ; $003D16
    dc.w    $4A00,$5545                                         ; $003D16 | J\0UE

; 6-byte entry lookup table: word(match_char) | long(byte offset from TMSSRegionTable)
; EarlyInit scans this for the system char, then uses the offset to find the
; region-specific draw string. Terminated by $0000.
; Entry 0: 'J' ($004A) -> offset $42 -> $3D58 (TMSSNTSCMegaDriveStr)
; Entry 1: 'U' ($0055) -> offset $53 -> $3D69 (TMSSNTSCGenesisStr)
; Entry 2: 'E' ($0045) -> offset $61 -> $3D77 (TMSSPALStr)
; Entry 3: $0000 -> end of table
TMSSCharTable:                                                  ; $003D1A
    dc.w    $004A,$0000,$0042; $003D1A | 'J', offset=$42
    dc.w    $0055,$0000,$0053,$0045,$0000,$0061,$0000          ; $003D20 | 'U'->$53, 'E'->$61

; Draw string: [byte col=6] "DEVELOPED FOR USE ONLY WITH\0"
; EarlyInit: lea TMSSTopStr(pc),a0 / move.b (a0)+,d0 / bsr WriteVDPTileRow
; WriteVDPTileRow uses d0=tile_column, d1=tile_row, then (a0)+... until null.
TMSSTopStr:                                                     ; $003D2E
    dc.w    $0644,$4556,$454C,$4F50,$4544,$2046,$4F52,$2055    ; $003D2E | col=6,"DEVELOPED FOR U"
    dc.w    $5345,$204F,$4E4C,$5920,$5749,$5448,$0012          ; $003D3E | "SE ONLY WITH\0"

; $003D4A: word $0012 -- high byte=$00 (end-of-string), low byte=$12=18 (col for TMSSSpaceStr)
; TMSSSpaceStr is at odd address $003D4B (the low byte of word $0012).
; EarlyInit: lea $3D4B(pc),a0 / move.b (a0)+,d0 (reads col $12) / bsr WriteVDPTileRow
; Draw string: [byte col=18] "&\0"  (separator character)
;   $003D4C: $2600 = '&'(high),$00(low) -- '&' is printed, then null terminates
    dc.w    $2600                                               ; $003D4C | '&'\0

; Draw string: [byte col=15] "SYSTEMS.\0"
; EarlyInit: lea $3D4E(pc),a0 / move.b (a0)+,d0 (reads col $0F) / bsr WriteVDPTileRow
; $003D4E is the high byte of this word: col=$0F
TMSSSystemsStr:                                                 ; $003D4E (word-aligned)
    dc.w    $0F53,$5953,$5445,$4D53,$2E00                      ; $003D4E | col=15,"SYSTEMS\0"

; Draw string: [byte col=12] "NTSC MEGA DRIVE\0"
; Pointed to by TMSSCharTable entry 0 (Japan system 'J').
; $003D58 is the high byte of word $0C4E: col=$0C
TMSSNTSCMegaDriveStr:                                          ; $003D58 (word-aligned)
    dc.w    $0C4E,$5453,$4320,$4D45,$4741,$2044,$5249,$5645    ; $003D58 | col=12,"NTSC MEGA DRIVE"
    dc.w    $000D                                               ; $003D68 | \0 (end), then $0D=col for next

; Draw string: [byte col=13] "NTSC GENESIS\0"
; Pointed to by TMSSCharTable entry 1 (USA system 'U').
; $003D69 is the low byte of word $000D at $003D68: col=$0D
; (Note: the \0 terminator of NTSCMegaDrive and the column byte share word $000D)
TMSSNTSCGenesisStr:                                            ; $003D69 (odd-byte, within word at $3D68)
    dc.w    $4E54,$5343,$2047,$454E,$4553,$4953,$0004          ; $003D6A | "NTSC GENESIS\0"

; Draw string: [byte col=4] "PAL AND FRENCH SECAM MEGA DRIVE\0"
; Pointed to by TMSSCharTable entry 2 (Europe system 'E').
; $003D77 is the low byte of word $0004 at $003D76: col=$04
; (Note: the \0 terminator of NTSCGenesis and the column byte share word $0004)
TMSSPALStr:                                                    ; $003D77 (odd-byte, within word at $3D76)
    dc.w    $5041,$4C20,$414E,$4420,$4652,$454E,$4348,$2053    ; $003D78 | "PAL AND FRENCH S"
    dc.w    $4543,$414D,$204D,$4547                            ; $003D88 | "ECAM MEG"
    dc.w    $4120,$4452,$4956,$4500                            ; $003D90 | "A DRIVE\0"

; 1bpp 8x8 glyph bitmaps for the TMSS text rendering engine (59 tiles x 8 bytes = 472 bytes)
; EarlyInit loads all 59 tiles via the WriteVDPTileRow bitstream loop:
;   lea TMSSFontTiles(pc),a0 / move.w #$3A,d0 / outer dbra d0 (59 tiles)
;   Inner: 8 bytes per tile, each bit expanded to a 4-pixel VDP run via
;   ROL.L #4 + ROR.B #1 + BCC + OR.L pattern.
; Tile coverage: '!'=0x00 (#0), '"'=0x01, ASCII punct, digits 0-9, uppercase A-Z,
;   plus misc glyphs. Tiles read MSB-first; each byte = 1 row of 8 pixels.
TMSSFontTiles:                                                  ; $003D98
    dc.w    $0000,$0000,$0000,$0000; $003D98 | blank tile (8 zeros)
    dc.w    $1818,$1818,$0018,$1800,$3636,$4800,$0000,$0000; $003DA0
    dc.w    $1212,$7F12,$7F24,$2400,$083F,$483E,$097E,$0800; $003DB0
    dc.w    $7152,$7408,$1725,$4700,$1824,$1829,$4546,$3900; $003DC0
    dc.w    $3030,$4000,$0000,$0000,$0C10,$2020,$2010,$0C00; $003DD0
    dc.w    $3008,$0404,$0408,$3000,$0008,$2A1C,$2A08,$0000; $003DE0
    dc.w    $0808,$087F,$0808,$0800,$0000,$0000,$0030,$3040; $003DF0
    dc.w    $0000,$007F,$0000,$0000,$0000,$0000,$0030,$3000; $003E00
    dc.w    $0102,$0408,$1020,$4000,$1E33,$3333,$3333,$1E00; $003E10
    dc.w    $1838,$1818,$1818,$3C00,$3E63,$630E,$3860,$7F00; $003E20
    dc.w    $3E63,$031E,$0363,$3E00,$060E,$1E36,$667F,$0600; $003E30
    dc.w    $7E60,$7E63,$0363,$3E00,$3E63,$607E,$6363,$3E00; $003E40
    dc.w    $3F63,$0606,$0C0C,$1800,$3E63,$633E,$6363,$3E00; $003E50
    dc.w    $3E63,$633F,$0363,$3E00,$0018,$1800,$0018,$1800; $003E60
    dc.w    $0018,$1800,$0018,$1820,$030C,$3040,$300C,$0300; $003E70
    dc.w    $0000,$7F00,$7F00,$0000,$6018,$0601,$0618,$6000; $003E80
    dc.w    $3E63,$031E,$1800,$1800,$3C42,$3949,$4949,$3600; $003E90
    dc.w    $1C1C,$3636,$7F63,$6300,$7E63,$637E,$6363,$7E00; $003EA0
    dc.w    $3E73,$6060,$6073,$3E00,$7E63,$6363,$6363,$7E00; $003EB0
    dc.w    $3F30,$303E,$3030,$3F00,$3F30,$303E,$3030,$3000; $003EC0
    dc.w    $3E73,$6067,$6373,$3E00,$6666,$667E,$6666,$6600; $003ED0
    dc.w    $1818,$1818,$1818,$1800,$0C0C,$0C0C,$CCCC,$7800; $003EE0
    dc.w    $6366,$6C78,$6C66,$6300,$6060,$6060,$6060,$7F00; $003EF0
    dc.w    $6377,$7F6B,$6B63,$6300,$6373,$7B7F,$6F67,$6300; $003F00
    dc.w    $3E63,$6363,$6363,$3E00,$7E63,$637E,$6060,$6000; $003F10
    dc.w    $3E63,$6363,$6F63,$3F00,$7E63,$637E,$6866,$6700; $003F20
    dc.w    $3E63,$703E,$0763,$3E00,$7E18,$1818,$1818,$1800; $003F30
    dc.w    $6666,$6666,$6666,$3C00,$6363,$6336,$361C,$1C00; $003F40
    dc.w    $6B6B,$6B6B,$6B7F,$3600,$6363,$361C,$3663,$6300; $003F50
    dc.w    $6666,$663C,$1818,$1800,$7F07,$0E1C,$3870,$7F00; $003F60
    dc.w    $4E75,$48E7,$303C,$242F,$001C,$267C,$00FF,$1802; $003F70
    dc.w    $287C,$00FF,$BD56,$2A7C,$00FF,$BD54,$3014,$E568; $003F80
    dc.w    $3880,$B453,$6332,$9453,$3013,$D040,$247C,$0004; $003F90
    dc.w    $684C,$3632,$0000,$C655,$0283,$0000,$FFFF,$3003; $003FA0
    dc.w    $E568,$8154,$1029,$0001,$E148,$1011,$3A80,$5489; $003FB0
    dc.w    $7010,$9042,$3680,$6002,$9553,$7000,$3013,$7200; $003FC0
    dc.w    $3215,$E0A1,$2001,$3202,$D241,$247C,$0004,$684C; $003FD0
    dc.w    $C072,$1000,$8154,$4CDF,$3C0C,$4E75             ; $003FE0 | prev fn tail
; ---------------------------------------------------------------------------
; LZ_Decompress - LZSS/LZ77 variant decompression
; Inputs: dest buffer ($1C,SP), compressed source ($20,SP)
; Output: D0.L = bytes written
; Uses A4 = helper at $003F72 for bitstream consumption (JSR (A4))
; RAM: $FFBD56 bitstream window (via A3), $FFA78C control byte, $FF1802 init
; 123 calls | 596 bytes | $003FEC-$00423F
; ---------------------------------------------------------------------------
LZ_Decompress:
    movem.l d2-d4/a2-a4,-(sp)                             ; $003FEC
    movea.l $1C(sp),a0                                     ; $003FF0 | dest buffer
    movea.l $20(sp),a1                                     ; $003FF4 | compressed source
    movea.l #$00FFBD56,a3                                  ; $003FF8 | -> bitstream window
    movea.l #$00003F72,a4                                  ; $003FFE | -> helper function
    clr.w   ($FF1802).l                                    ; $004004 | clear init flag
    pea     ($0010).w                                      ; $00400A | push 16 (read 16 bits)
    jsr     (a4)                                           ; $00400E | fill bitstream window
    addq.l  #4,sp                                          ; $004010
.fetch_control:
    move.b  (a1)+,($FFA78C).l                              ; $004012 | read control byte
    clr.w   d4                                             ; $004018 | bit counter = 0
.process_bit:
    move.b  ($FFA78C).l,d0                                 ; $00401A | load control byte
    btst    #7,d0                                          ; $004020 | test MSB
    beq.s   .bit_zero                                      ; $004024 | 0 = back-reference
    move.b  (a1)+,(a0)+                                    ; $004026 | 1 = literal copy
    bra.w   .advance_bit                                   ; $004028
; --- Decode match length from bitstream window ---
.bit_zero:
    move.w  (a3),d0                                        ; $00402C
    andi.w  #$8000,d0                                      ; $00402E | test bit 15
    beq.s   .len_not_b15                                   ; $004032
    moveq   #1,d3                                          ; $004034 | length = 1
    bra.w   .decode_dist                                   ; $004036
.len_not_b15:
    move.w  (a3),d0                                        ; $00403A
    andi.w  #$4000,d0                                      ; $00403C | test bit 14
    beq.s   .len_not_b14                                   ; $004040
    move.w  (a3),d3                                        ; $004042
    andi.l  #$00006000,d3                                  ; $004044 | bits 14-13
    moveq   #13,d0                                         ; $00404A
    asr.l   d0,d3                                          ; $00404C
    pea     ($0002).w                                      ; $00404E | consume 2 bits
    bra.w   .call_helper                                   ; $004052
.len_not_b14:
    move.w  (a3),d0                                        ; $004056
    andi.w  #$2000,d0                                      ; $004058 | test bit 13
    beq.s   .len_not_b13                                   ; $00405C
    move.w  (a3),d3                                        ; $00405E
    andi.l  #$00003800,d3                                  ; $004060 | bits 13-11
    moveq   #11,d0                                         ; $004066
    asr.l   d0,d3                                          ; $004068
    pea     ($0004).w                                      ; $00406A | consume 4 bits
    bra.s   .call_helper                                   ; $00406E
.len_not_b13:
    move.w  (a3),d0                                        ; $004070
    andi.w  #$1000,d0                                      ; $004072 | test bit 12
    beq.s   .len_not_b12                                   ; $004076
    move.w  (a3),d3                                        ; $004078
    andi.l  #$00001E00,d3                                  ; $00407A | bits 12-9
    moveq   #9,d0                                          ; $004080
    asr.l   d0,d3                                          ; $004082
    pea     ($0006).w                                      ; $004084 | consume 6 bits
    bra.s   .call_helper                                   ; $004088
.len_not_b12:
    move.w  (a3),d0                                        ; $00408A
    andi.w  #$0800,d0                                      ; $00408C | test bit 11
    beq.s   .len_not_b11                                   ; $004090
    move.w  (a3),d3                                        ; $004092
    andi.l  #$00000F80,d3                                  ; $004094 | bits 10-7
    asr.l   #7,d3                                          ; $00409A
    pea     ($0008).w                                      ; $00409C | consume 8 bits
    bra.s   .call_helper                                   ; $0040A0
.len_not_b11:
    move.w  (a3),d0                                        ; $0040A2
    andi.w  #$0400,d0                                      ; $0040A4 | test bit 10
    beq.s   .len_not_b10                                   ; $0040A8
    move.w  (a3),d3                                        ; $0040AA
    andi.l  #$000007E0,d3                                  ; $0040AC | bits 9-5
    asr.l   #5,d3                                          ; $0040B2
    pea     ($000A).w                                      ; $0040B4 | consume 10 bits
    bra.s   .call_helper                                   ; $0040B8
.len_not_b10:
    move.w  (a3),d0                                        ; $0040BA
    andi.w  #$0200,d0                                      ; $0040BC | test bit 9
    beq.s   .len_default                                   ; $0040C0
    move.w  (a3),d3                                        ; $0040C2
    andi.l  #$000003F8,d3                                  ; $0040C4 | bits 8-3
    asr.l   #3,d3                                          ; $0040CA
    pea     ($000C).w                                      ; $0040CC | consume 12 bits
    bra.s   .call_helper                                   ; $0040D0
.len_default:
    move.w  (a3),d3                                        ; $0040D2
    andi.l  #$000001FC,d3                                  ; $0040D4 | bits 8-2
    asr.l   #2,d3                                          ; $0040DA
    addi.w  #$0080,d3                                      ; $0040DC | +128 bias
    cmpi.w  #$00FF,d3                                      ; $0040E0 | 255 = end marker
    beq.w   .done                                          ; $0040E4
    pea     ($000D).w                                      ; $0040E8 | consume 13 bits
.call_helper:
    jsr     (a4)                                           ; $0040EC | call bitstream helper
    addq.l  #4,sp                                          ; $0040EE
; --- Decode match distance from bitstream window ---
.decode_dist:
    andi.w  #$7FFF,(a3)                                    ; $0040F0 | clear bit 15
    cmpi.w  #$0800,(a3)                                    ; $0040F4
    bcc.s   .dist_ge_0800                                  ; $0040F8
    move.w  (a3),d2                                        ; $0040FA
    andi.l  #$00000600,d2                                  ; $0040FC | bits 10-9
    moveq   #9,d0                                          ; $004102
    asr.l   d0,d2                                          ; $004104
    pea     ($0007).w                                      ; $004106 | consume 7 bits
    bra.w   .do_copy                                       ; $00410A
.dist_ge_0800:
    cmpi.w  #$0C00,(a3)                                    ; $00410E
    bcc.s   .dist_ge_0C00                                  ; $004112
    move.w  (a3),d2                                        ; $004114
    andi.l  #$00000300,d2                                  ; $004116 | bits 9-8
    asr.l   #8,d2                                          ; $00411C
    addq.w  #4,d2                                          ; $00411E | +4 bias
    pea     ($0008).w                                      ; $004120 | consume 8 bits
    bra.w   .do_copy                                       ; $004124
.dist_ge_0C00:
    cmpi.w  #$1800,(a3)                                    ; $004128
    bcc.s   .dist_ge_1800                                  ; $00412C
    moveq   #0,d2                                          ; $00412E
    move.w  (a3),d2                                        ; $004130
    subi.l  #$00000C00,d2                                  ; $004132
    andi.l  #$00000F80,d2                                  ; $004138 | bits 10-7
    asr.l   #7,d2                                          ; $00413E
    addq.w  #8,d2                                          ; $004140 | +8 bias
    pea     ($0009).w                                      ; $004142 | consume 9 bits
    bra.w   .do_copy                                       ; $004146
.dist_ge_1800:
    cmpi.w  #$3000,(a3)                                    ; $00414A
    bcc.s   .dist_ge_3000                                  ; $00414E
    moveq   #0,d2                                          ; $004150
    move.w  (a3),d2                                        ; $004152
    subi.l  #$00001800,d2                                  ; $004154
    andi.l  #$00001FC0,d2                                  ; $00415A | bits 12-6
    asr.l   #6,d2                                          ; $004160
    addi.w  #$0020,d2                                      ; $004162 | +$20 bias
    pea     ($000A).w                                      ; $004166 | consume 10 bits
    bra.w   .do_copy                                       ; $00416A
.dist_ge_3000:
    cmpi.w  #$4000,(a3)                                    ; $00416E
    bcc.s   .dist_ge_4000                                  ; $004172
    move.w  (a3),d2                                        ; $004174
    andi.l  #$00001FFF,d2                                  ; $004176 | bits 12-0
    ori.l   #$00001000,d2                                  ; $00417C | set bit 12
    asr.l   #5,d2                                          ; $004182
    pea     ($000B).w                                      ; $004184 | consume 11 bits
    bra.s   .do_copy                                       ; $004188
.dist_ge_4000:
    cmpi.w  #$5000,(a3)                                    ; $00418A
    bcc.s   .dist_ge_5000                                  ; $00418E
    move.w  (a3),d2                                        ; $004190
    andi.l  #$00001FFF,d2                                  ; $004192
    ori.l   #$00001000,d2                                  ; $004198
    asr.l   #4,d2                                          ; $00419E
    pea     ($000C).w                                      ; $0041A0 | consume 12 bits
    bra.s   .do_copy                                       ; $0041A4
.dist_ge_5000:
    cmpi.w  #$6000,(a3)                                    ; $0041A6
    bcc.s   .dist_ge_6000                                  ; $0041AA
    move.w  (a3),d2                                        ; $0041AC
    andi.l  #$00001FFF,d2                                  ; $0041AE
    ori.l   #$00001000,d2                                  ; $0041B4
    asr.l   #3,d2                                          ; $0041BA
    pea     ($000D).w                                      ; $0041BC | consume 13 bits
    bra.s   .do_copy                                       ; $0041C0
.dist_ge_6000:
    cmpi.w  #$7000,(a3)                                    ; $0041C2
    bcc.s   .dist_ge_7000                                  ; $0041C6
    move.w  (a3),d2                                        ; $0041C8
    andi.l  #$00001FFF,d2                                  ; $0041CA
    ori.l   #$00001000,d2                                  ; $0041D0
    asr.l   #2,d2                                          ; $0041D6
    pea     ($000E).w                                      ; $0041D8 | consume 14 bits
    bra.s   .do_copy                                       ; $0041DC
.dist_ge_7000:
    move.w  (a3),d2                                        ; $0041DE
    andi.l  #$00001FFF,d2                                  ; $0041E0
    ori.l   #$00001000,d2                                  ; $0041E6
    asr.l   #1,d2                                          ; $0041EC
    pea     ($000F).w                                      ; $0041EE | consume 15 bits
; --- Copy match: D3+1 bytes from (A0 - D2 - 1) ---
.do_copy:
    jsr     (a4)                                           ; $0041F2 | call helper
    addq.l  #4,sp                                          ; $0041F4
    moveq   #0,d0                                          ; $0041F6
    move.w  d2,d0                                          ; $0041F8 | D0 = distance
    move.l  a0,d1                                          ; $0041FA
    sub.l   d0,d1                                          ; $0041FC | dest - distance
    subq.l  #1,d1                                          ; $0041FE | - 1
    movea.l d1,a2                                          ; $004200 | A2 = copy source
    clr.w   d2                                             ; $004202 | counter = 0
    bra.s   .copy_test                                     ; $004204
.copy_loop:
    move.b  (a2)+,(a0)+                                    ; $004206 | copy byte
    addq.w  #1,d2                                          ; $004208
.copy_test:
    moveq   #0,d0                                          ; $00420A
    move.w  d2,d0                                          ; $00420C | D0 = counter
    moveq   #0,d1                                          ; $00420E
    move.w  d3,d1                                          ; $004210 | D1 = length
    addq.l  #1,d1                                          ; $004212 | +1 (copy length+1 bytes)
    cmp.l   d1,d0                                          ; $004214
    blt.s   .copy_loop                                     ; $004216
; --- Advance control bit ---
.advance_bit:
    move.b  ($FFA78C).l,d0                                 ; $004218 | load control byte
    add.b   d0,($FFA78C).l                                 ; $00421E | double it (shift left 1)
    addq.w  #1,d4                                          ; $004224 | bit counter++
    cmpi.w  #$0008,d4                                      ; $004226 | 8 bits done?
    bcs.w   .process_bit                                   ; $00422A | no: next bit
    bra.w   .fetch_control                                 ; $00422E | yes: next control byte
; --- Return bytes written ---
.done:
    move.l  $1C(sp),d1                                     ; $004232 | original dest ptr
    move.l  a0,d0                                          ; $004236 | final dest ptr
    sub.l   d1,d0                                          ; $004238 | D0 = bytes written
    movem.l (sp)+,d2-d4/a2-a4                              ; $00423A
    rts                                                    ; $00423E
; === Translated block $004240-$004342 ===
; 3 functions, 258 bytes
