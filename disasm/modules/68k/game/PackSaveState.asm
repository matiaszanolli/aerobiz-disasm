; ============================================================================
; PackSaveState -- Serialize all game state regions (player records, routes, chars, city data) into a packed buffer for SRAM save
; Called: ?? times.
; 1130 bytes | $00EB28-$00EF91
;
; Save buffer layout (written sequentially starting at $FF180A):
;   $FF180A  header bytes + game flags ($FF0003, $FF0005, frame_counter, etc.)
;   ...      player records (4 × $24 = $90 bytes from $FF0018)
;   ...      unknown blocks ($FF00A8, $FF00E8, player_word_tab, etc.)
;   ...      char stat array, event_records (stride-2 loop), city_data (nested loop)
;   ...      route slots (4 players × 40 slots × $0C bytes saved per slot)
;   ...      session fields, char_session_blk, ui_active_flag
;
; Copy helper convention (jsr (a5) = $01D538):
;   push: count, dest=a3, $00200003 (flags), src, 0  (5 longs = $14 bytes)
;   After call: advance a3 by count to next write position.
; ============================================================================
PackSaveState:                                                  ; $00EB28
    movem.l d2-d4/a2-a5,-(sp)
    move.l  $0020(sp),d4                               ; d4 = caller arg (save slot index / flags)
    movea.l #$0001d538,a5                              ; a5 = copy helper ($01D538): bulk memcpy to save buffer
    movea.l #$00ff1804,a3                              ; a3 = write pointer (starts at save_buf_base)
    movea.l a3,a4                                      ; a4 = save_buf_base ($FF1804, fixed anchor for header)
    addq.l  #$6,a3                                     ; skip 6-byte header: a3 = $FF180A (first data byte)

; --- Phase: Header -- individual game flag bytes ---
    move.b  ($00FF0003).l,(a3)+                        ; save_byte_03 (purpose TBD)
    move.b  ($00FF0005).l,(a3)+                        ; save_byte_05 (purpose TBD)
    pea     ($0002).w                                  ; count: 2 bytes
    move.l  a3,-(sp)                                   ; dest: current write position
    move.l  #$00200003,-(sp)                           ; flags word for copy helper
    pea     ($00FF0006).l                              ; src: frame_counter (2 bytes)
    clr.l   -(sp)
    jsr     (a5)                                       ; copy frame_counter
    addq.l  #$2,a3                                     ; advance write ptr by 2
    move.b  ($00FF0009).l,(a3)+                        ; unknown byte $FF0009
    move.b  ($00FF000B).l,(a3)+                        ; flight_active high byte ($FF000B)
    move.b  ($00FF000D).l,(a3)+                        ; save_byte_0d (purpose TBD)
    move.b  ($00FF000F).l,(a3)+                        ; save_byte_0f (purpose TBD)
    move.b  ($00FF0011).l,(a3)+                        ; save_byte_11 (purpose TBD)
    pea     ($0004).w                                  ; count: 4 bytes
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0012).l                              ; src: save_block_12 (4 bytes, purpose TBD)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp                               ; clean up 5 × 4 = $14 bytes × 2 calls = $28
    addq.l  #$4,a3                                     ; advance write ptr by 4
    move.b  ($00FF0016).l,(a3)+                        ; current_player (player turn index 0-3)

; --- Phase: Player records -- 4 × $24 bytes from $FF0018 ---
    pea     ($0090).w                                  ; count: $90 = 144 bytes (4 × $24 byte player records)
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0018).l                              ; src: player_records base (4 players × 36 bytes)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0090(a3),a3                               ; advance write ptr by $90

; --- Phase: Unknown block $FF00A8 -- $40 bytes ---
    pea     ($0040).w                                  ; count: $40 bytes
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF00A8).l                              ; src: unknown block ($FF00A8, purpose TBD)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$40,d0
    adda.l  d0,a3                                      ; advance write ptr by $40

; --- Phase: Unknown block $FF00E8 -- $30 bytes ---
    pea     ($0030).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF00E8).l                              ; src: unknown block ($FF00E8, $30 bytes)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$30,d0
    adda.l  d0,a3

; --- Phase: player_word_tab ($FF0118, $08 bytes) and char_stat_subtab ($FF0120, $10 bytes) ---
    pea     ($0008).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0118).l                              ; src: player_word_tab (4 words, one per player)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    addq.l  #$8,a3                                     ; advance by $8
    pea     ($0010).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0120).l                              ; src: char_stat_subtab (16 bytes, player × 4 indexed)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$10,d0
    adda.l  d0,a3

; --- Phase: Unknown blocks $FF0130-$FF026F ($80+$80+$40+$20 bytes) ---
    pea     ($0080).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0130).l                              ; src: unknown block ($80 bytes -- franchise/licensing?)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    lea     $0080(a3),a3

    pea     ($0080).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF01B0).l                              ; src: unknown block ($80 bytes -- route pool?)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0080(a3),a3

    pea     ($0040).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0230).l                              ; src: unknown block ($40 bytes)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$40,d0
    adda.l  d0,a3

    pea     ($0020).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0270).l                              ; src: unknown block ($20 bytes)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$20,d0
    adda.l  d0,a3

; --- Phase: Expense table A ($FF0290, $18 bytes = 4 players × 6 bytes) ---
    pea     ($0018).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0290).l                              ; src: expense_table_a (4 × 6 bytes: expense components A/B/C)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$18,d0
    adda.l  d0,a3
; --- Phase: event_records -- stride-2 loop, 4 players × 16 entries = 64 bytes saved ---
; event_records at $FFB9E8: 4 × $20 (32) byte records.
; Only every other byte is saved (stride 2 = only the first byte of each word-aligned pair).
; Outer loop: d3 = player index (0-3).  Inner loop: d2 = entry index (0-$F = 16 entries/player).
    clr.w   d3                                         ; d3 = player index, outer loop counter
.lecbc:                                                 ; $00ECBC
    move.w  d3,d0
    lsl.w   #$5,d0                                     ; player_offset = player * $20 (32 bytes/record)
    movea.l #$00ffb9e8,a0                              ; event_records base ($FFB9E8)
    lea     (a0,d0.w),a0                               ; a0 -> event_record[player]
    movea.l a0,a2                                      ; a2 = src pointer into this player's event_record
    clr.w   d2                                         ; d2 = entry index, inner loop counter
.lecce:                                                 ; $00ECCE
    pea     ($0001).w                                  ; count: 1 byte per entry
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)                                   ; src: current event record byte
    clr.l   -(sp)
    jsr     (a5)                                       ; copy 1 byte to save buffer
    lea     $0014(sp),sp
    addq.l  #$1,a3                                     ; advance write ptr by 1
    addq.l  #$2,a2                                     ; advance src ptr by 2 (skip odd byte = stride-2)
    addq.w  #$1,d2
    cmpi.w  #$10,d2                                    ; 16 entries per player
    blt.b   .lecce                                     ; inner loop: 16 iterations
    addq.w  #$1,d3
    cmpi.w  #$4,d3                                     ; 4 players
    blt.b   .lecbc                                     ; outer loop: 4 iterations

; --- Phase: Blocks $FF02E8-$FF04FF (mixed purpose, $50+$80 bytes) ---
    pea     ($0050).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF02E8).l                              ; src: unknown block ($50 bytes -- TBD)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$50,d0
    adda.l  d0,a3

    pea     ($0080).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0338).l                              ; src: unknown block ($80 bytes -- quarter snapshot?)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    lea     $0080(a3),a3

; --- Phase: char_display_tab ($FF03B8, $28 bytes) and unknown $FF03E0 ($10 bytes) ---
    pea     ($0028).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF03B8).l                              ; src: char_display_tab ($28 bytes = 40 bytes; char display lookup)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$28,d0
    adda.l  d0,a3

    pea     ($0010).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF03E0).l                              ; src: unknown block ($10 bytes)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    moveq   #$10,d0
    adda.l  d0,a3

; --- Phase: Expense table B ($FF03F0, $30 bytes = 4 players × $C bytes) ---
    pea     ($0030).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF03F0).l                              ; src: expense_table_b (4 × 12 bytes: expense D/E/F + flags)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$30,d0
    adda.l  d0,a3

; --- Phase: Unknown blocks $FF0420 ($C0 bytes) and $FF04E0 ($E4 bytes) ---
    pea     ($00C0).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0420).l                              ; src: unknown block ($C0 = 192 bytes -- route_slot_tab_low?)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    lea     $00c0(a3),a3

    pea     ($00E4).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF04E0).l                              ; src: unknown block ($E4 = 228 bytes -- possibly char_stat_array copy?)
    clr.l   -(sp)
    jsr     (a5)
    lea     $00e4(a3),a3

; --- Phase: Sub-function $00EF92 -- advances a3 past char stat section ---
; Calls a local helper that handles the char_stat_array / char_stat_subtab save pass.
    move.l  a3,-(sp)                                   ; pass current write ptr as arg
    dc.w    $4eba,$01d4                                 ; jsr $00EF92  ; returns updated write ptr in d0
    nop
    movea.l d0,a3                                      ; a3 = updated write ptr from helper

; --- Phase: Unknown block $FF0728 ($40 bytes) ---
    pea     ($0040).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0728).l                              ; src: unknown block ($40 bytes, follows char stat data)
    clr.l   -(sp)
    jsr     (a5)
    lea     $002c(sp),sp
    moveq   #$40,d0
    adda.l  d0,a3

; --- Phase: tab32_8824 -- stride-2 loop, 32 entries ($40 raw bytes -> 32 saved bytes) ---
; tab32_8824 at $FF8824: 32 entries at raw stride 2 (1 effective byte per slot).
; Save only odd bytes: inner loop reads every other byte.
    movea.l #$00ff8824,a2                              ; tab32_8824 ($FF8824): 32 entries, stride 2
    clr.w   d2                                         ; d2 = entry counter
.ledea:                                                 ; $00EDEA
    pea     ($0001).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)                                   ; src: tab32_8824[d2] (even byte only)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    addq.l  #$1,a3                                     ; write ptr +1
    addq.l  #$2,a2                                     ; src ptr +2 (stride-2 skip)
    addq.w  #$1,d2
    cmpi.w  #$20,d2                                    ; 32 ($20) entries
    blt.b   .ledea

; --- Phase: city_data -- nested loop, 89 cities × 4 entries, stride 2 ---
; city_data at $FFBA80: 89 cities × 4 entries × 2 bytes (stride-2 storage).
; Outer loop: d2 = city index (0-88=$58).  Inner loop: d3 = entry index (0-3).
; Only the first byte of each 2-byte word entry is saved.
    movea.l #$00ffba80,a2                              ; city_data base ($FFBA80)
    clr.w   d2                                         ; d2 = city index (outer loop)
.lee14:                                                 ; $00EE14
    clr.w   d3                                         ; d3 = entry index (inner loop, 0-3)
.lee16:                                                 ; $00EE16
    pea     ($0001).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)                                   ; src: city_data[city][entry] (even byte)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    addq.l  #$1,a3                                     ; write ptr +1
    addq.l  #$2,a2                                     ; src ptr +2 (stride-2)
    addq.w  #$1,d3
    cmpi.w  #$4,d3                                     ; 4 entries per city
    blt.b   .lee16                                     ; inner loop
    addq.w  #$1,d2
    cmpi.w  #$59,d2                                    ; $59 = 89 cities
    blt.b   .lee14                                     ; outer loop

; --- Phase: entity_bits ($FF08EC, $10 bytes = 4 longword bitfields) ---
    pea     ($0010).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF08EC).l                              ; src: entity_bits (4 longwords, indexed entity * 4)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    moveq   #$10,d0
    adda.l  d0,a3

; --- Phase: route_slots -- outer loop 4 players, inner loop 40 slots, $0C bytes saved per slot ---
; route_slots at $FF9A20: 4 players × 40 slots × $14 (20) bytes.
; Only the first $0C (12) bytes are saved per slot -- fields +$0C..+$13 are runtime-only.
    clr.w   d3                                         ; d3 = player index (outer loop)
.lee60:                                                 ; $00EE60
    move.w  d3,d0
    mulu.w  #$0320,d0                                  ; player_offset = player * $320 (40 slots × $14 bytes = 800)
    movea.l #$00ff9a20,a0                              ; route_slots base ($FF9A20)
    lea     (a0,d0.w),a0                               ; a0 -> route_slots[player][0]
    movea.l a0,a2                                      ; a2 = src slot pointer
    clr.w   d2                                         ; d2 = slot index (inner loop)
.lee74:                                                 ; $00EE74
    pea     ($000C).w                                  ; count: $0C bytes per slot (city_a..status_flags)
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    move.l  a2,-(sp)                                   ; src: current route slot (first $0C bytes only)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    moveq   #$c,d0
    adda.l  d0,a3                                      ; write ptr += $0C
    moveq   #$14,d0
    adda.l  d0,a2                                      ; src ptr += $14 (full slot stride, skip +$0C..+$13)
    addq.w  #$1,d2
    cmpi.w  #$28,d2                                    ; $28 = 40 slots per player
    blt.b   .lee74                                     ; inner loop
    addq.w  #$1,d3
    cmpi.w  #$4,d3                                     ; 4 players
    blt.b   .lee60                                     ; outer loop

; --- Phase: Session/route sub-records ($FF099C + $FF09A0 + $FF09A2) ---
    pea     ($0004).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF099C).l                              ; src: session_block_9c (4 bytes)
    clr.l   -(sp)
    jsr     (a5)
    addq.l  #$4,a3

    pea     ($0001).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF09A0).l                              ; src: session_byte_a0 (1 byte)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0028(sp),sp
    addq.l  #$1,a3

; --- Phase: Income/expense table ($FF09A2, $20 bytes = 4 players × 8 bytes) ---
    pea     ($0020).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF09A2).l                              ; src: income/expense table (4 × 8 bytes: income+expense longs)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$20,d0
    adda.l  d0,a3

; --- Phase: Sub-function $00F008 -- CopyRouteFields helper ---
; Copies route_field_a/b/c/d sub-records to save buffer.
    move.l  a3,-(sp)
    dc.w    $4eba,$0114                                 ; jsr $00F008  ; CopyRouteFields(a3) -> d0 = updated write ptr
    nop
    movea.l d0,a3                                      ; a3 = updated write ptr

; --- Phase: char_session_blk ($FF09D8, $59 bytes = 89 char-session bytes) ---
    pea     ($0059).w                                  ; count: $59 = 89 bytes (1 byte per character slot)
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF09D8).l                              ; src: char_session_blk (89 bytes, 1 per char)
    clr.l   -(sp)
    jsr     (a5)
    lea     $002c(sp),sp
    moveq   #$59,d0
    adda.l  d0,a3
; --- Phase: session_word_a32 and ui_active_flag -- final 2 word-sized fields ---
    pea     ($0002).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0A32).l                              ; src: session_word_a32 (2 bytes, purpose TBD)
    clr.l   -(sp)
    jsr     (a5)
    addq.l  #$2,a3

    pea     ($0002).w
    move.l  a3,-(sp)
    move.l  #$00200003,-(sp)
    pea     ($00FF0A34).l                              ; src: ui_active_flag (word: nonzero = UI active)
    clr.l   -(sp)
    jsr     (a5)
    addq.l  #$2,a3                                     ; a3 now points past last saved byte

; --- Phase: Finalize -- compute record size, write header, commit to SRAM ---
; Compute total save record size = current write ptr - save_buf_base (a4)
    move.l  a3,d0
    sub.l   a4,d0                                      ; d0 = total bytes written (from $FF1804)
    move.l  d0,d2                                      ; d2 = save record size (saved for WriteHeader call)
; subtract 6 for the fixed header area (a4+0 to a4+5 not included in counted payload)
    addi.w  #$fffa,d0                                  ; d0 -= 6 (= +$FFFA = -6 signed)
    move.l  d0,-(sp)                                   ; arg: payload size
    move.w  d4,d0                                      ; d4 = save slot index (from caller arg)
    move.l  d0,-(sp)
    dc.w    $4eba,$05c8                                 ; jsr $00F522  ; WriteHeader(slot, payload_size)
    nop
    lea     $0030(sp),sp

; compute SRAM destination address: slot * $2000 + $200003 (odd-byte SRAM base)
; Genesis SRAM: $200001-$203FFF (odd bytes), $2000 = 8KB per slot
    move.l  d2,-(sp)                                   ; arg: total record size
    move.w  d4,d0
    ext.l   d0
    moveq   #$d,d1
    lsl.l   d1,d0                                      ; d0 = slot * $2000 (13-bit shift)
    addi.l  #$00200003,d0                              ; d0 = SRAM dest address (odd byte, slot offset)
    move.l  d0,-(sp)                                   ; arg: SRAM dest
    move.l  a4,-(sp)                                   ; arg: save_buf_base (src)
    dc.w    $4eb9,$0001,$e0e0                           ; jsr $01E0E0  ; DMA or byte-copy to SRAM
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0180                                 ; jsr $00F104  ; WriteSRAMFooter(slot) -- write checksum/magic
    nop
    lea     $0010(sp),sp
    movem.l (sp)+,d2-d4/a2-a5
    rts
; === Translated block $00EF92-$00EFC8 ===
; 1 functions, 54 bytes
