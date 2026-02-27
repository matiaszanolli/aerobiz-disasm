; ============================================================================
; EarlyInit -- TMSS boot screen: detect region, load font tiles, render license text to VDP
; 302 bytes | $003BE8-$003D15
; ============================================================================
EarlyInit:
    clr.l   d0
    move.b  ($00A10001).l, d0
    lsr.b   #$6, d0
    andi.b  #$3, d0
    lea     $3d16(pc), a0
    move.b  (a0,d0.w), d0
    tst.b   d0
    beq.w   l_03cde
    lea     ($01F0).w, a0
    move.w  #$f, d1
l_03c0c:
    cmp.b   (a0), d0
    dc.w    $6700,$0360                                         ; beq $003F70
    addq.l  #$1, a0
    dbra    d1, $3C0C
    lea     ($00C00000).l, a4
    lea     ($00C00004).l, a5
    move.w  #$8164, (a5)
    move.w  #$8230, (a5)
    move.w  #$8c81, (a5)
    move.w  #$8f02, (a5)
    move.w  #$9001, (a5)
    move.l  #$c0020000, (a5)
    move.w  #$eee, (a4)
    move.l  #$40000000, (a5)
    lea     $3d98(pc), a0
    move.w  #$3a, d0
    move.l  #$10000000, d2
l_03c56:
    move.w  #$7, d6
l_03c5a:
    move.b  (a0)+, d1
    moveq   #$0,d4
    move.w  #$7, d5
l_03c62:
    rol.l   #$4, d2
    ror.b   #$1, d1
    bcc.b   l_03c6a
    or.l    d2, d4
l_03c6a:
    dbra    d5, $3C62
    move.l  d4, (a4)
    dbra    d6, $3C5A
    dbra    d0, $3C56
    move.b  #$8, d1
    lea     $3d2e(pc), a0
    move.b  (a0)+, d0
    bsr.w WriteVDPTileRow
    lea     ($01F0).w, a1
l_03c8a:
    cmpi.b  #$20, (a1)
    beq.b   l_03cd2
    lea     $3d1a(pc), a2
l_03c94:
    move.w  (a2)+, d4
    tst.b   d4
    beq.b   l_03cce
    cmp.b   (a1), d4
    bne.b   l_03cca
    cmpi.b  #$20, $1(a1)
    bne.b   l_03cba
    cmpa.l  #$1f0, a1
    beq.b   l_03cba
    lea     $3d4b(pc), a0
    move.b  (a0)+, d0
    addq.w  #$1, d1
    bsr.w WriteVDPTileRow
l_03cba:
    lea     $3d16(pc), a0
    adda.l  (a2)+, a0
    move.b  (a0)+, d0
    addq.w  #$1, d1
    bsr.w WriteVDPTileRow
    bra.b   l_03cce
l_03cca:
    addq.l  #$4, a2
    bra.b   l_03c94
l_03cce:
    addq.l  #$1, a1
    bra.b   l_03c8a
l_03cd2:
    lea     $3d4e(pc), a0
    move.b  (a0)+, d0
    addq.w  #$1, d1
    bsr.w WriteVDPTileRow
l_03cde:
    bra.b   l_03cde
WriteVDPTileRow:                                        ; $003CE0
    move.b  d1, d2
    andi.l  #$ff, d2
    swap    d2
    lsl.l   #$7, d2
    move.b  d0, d3
    andi.l  #$ff, d3
    swap    d3
    asl.l   #$1, d3
    add.l   d3, d2
    addi.l  #$40000003, d2
    move.l  d2, (a5)
l_03d02:
    tst.b   (a0)
    beq.b   l_03d14
    move.b  (a0)+, d2
    subi.b  #$20, d2
    andi.w  #$ff, d2
    move.w  d2, (a4)
    bra.b   l_03d02
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
