; ============================================================================
; RenderCharInfoPanel -- Renders the char info/relationship status panel for a given player char pair
; 610 bytes | $0377DA-$037A3B
;
; Args (pushed right-to-left before jsr):
;   $8(a6)  = d4: char slot index (which slot/position within roster)
;   $c(a6)  = d2: entity index / char type index
;   $10(a6) = d3: player/roster index
;   $14(a6) = d5: mode flag (1 = show relation panel even if already occupied)
;
; Registers set up in prologue:
;   a4 = $7912  (ShowDialog function pointer)
;   a5 = $48616 (ROM string/format table base -- offsets used: +$4,+$c,+$10,+$14,+$18,+$1c,+$34,+$38)
;   a3 = local $50-byte string work buffer (on stack frame)
;
; Key RAM / ROM:
;   $FF09D8 = char_session_blk: 1 byte per char slot; low 2 bits = active char count.
;   $FF0338 = player event/slot table, stride $20 per player, $8 per slot.
;   $FFBA80 = city_data: 89 cities x 4 entries x 2 bytes (stride-2 storage).
;             Index for (player, slot): player*8 + slot*2.
;   $5E680  = ROM table: char name/string pointers, indexed char_type * 4.
;   $5EC84  = ROM table: region name string pointers, indexed region * 4.
; ============================================================================
RenderCharInfoPanel:
    link    a6,#-$50
    movem.l d2-d5/a2-a5, -(a7)
    ; --- Phase: Load arguments into working registers ---
    move.l  $c(a6), d2                              ; d2 = entity/char type index
    move.l  $10(a6), d3                             ; d3 = player/roster index
    move.l  $8(a6), d4                              ; d4 = char slot index
    move.l  $14(a6), d5                             ; d5 = mode flag
    lea     -$50(a6), a3                            ; a3 = local 80-byte string work buffer
    movea.l  #$00007912,a4                          ; a4 = ShowDialog ($7912) function pointer
    movea.l  #$00048616,a5                          ; a5 = format/string table base ($48616)
    ; --- Phase: Check whether this char slot is already occupied ---
    movea.l  #$00FF09D8,a0                          ; char_session_blk base
    move.b  (a0,d3.w), d0                           ; byte for player d3's char slot
    andi.b  #$3, d0                                 ; low 2 bits = active char count for this slot
    beq.b   l_37836                                 ; count == 0 -> slot empty, check bitfield
    ; --- Slot occupied: show existing character dialog and exit ---
    bsr.w ClearCharSprites                          ; clear stale sprite overlays
    pea     ($0001).w                               ; ShowDialog mode 1
    clr.l   -(a7)
    pea     ($0002).w                               ; dialog index 2
    move.l  $34(a5), -(a7)                          ; string ptr at table+$34 (occupied message)
l_37824:
    ; --- Common ShowDialog dispatch: called from multiple paths above ---
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; char slot index argument
    jsr     (a4)                                    ; ShowDialog ($7912)
    lea     $14(a7), a7                             ; pop 5 longwords
    moveq   #$0,d0                                  ; return 0 = panel rendered
    bra.w   l_37a32
l_37836:
    ; --- Phase: BitFieldSearch for existing (entity, slot) relation entry ---
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; entity index
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; char slot index
    jsr BitFieldSearch                              ; scan $FFA6A0 for (entity, slot) pair
    addq.l  #$8, a7
    cmp.w   d3, d0                                  ; result == this player index?
    bne.b   l_37884                                 ; no -> check city_data path
    ; --- BitFieldSearch matched this player: relation already held by us ---
    cmpi.w  #$1, d5                                 ; mode == 1 (force panel display)?
    bne.b   l_37884                                 ; no -> fall through to city_data path
    bsr.w ClearCharSprites
    ; --- Format "already your partner" dialog ---
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0                          ; char name string pointer table
    move.l  (a0,d0.w), -(a7)                        ; char name for this player's type
    move.l  $4(a5), -(a7)                           ; format string at table+$4
l_3786a:
    move.l  a3, -(a7)                               ; output buffer for sprintf
    jsr sprintf
    lea     $c(a7), a7
l_37876:
    ; --- Show the sprintf-formatted string as a dialog ---
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)                               ; formatted string buffer
    bra.b   l_37824
l_37884:
    ; --- Phase: Inspect city_data entry for (player, slot) pair ---
    ; city_data[$FFBA80]: stride-2, player's city block = player*8, slot entry = +slot*2
    move.w  d3, d0
    lsl.w   #$3, d0                                 ; player * 8
    move.w  d4, d1
    add.w   d1, d1                                  ; slot * 2
    add.w   d1, d0
    movea.l  #$00FFBA80,a0                          ; city_data base
    lea     (a0,d0.w), a0
    movea.l a0, a2                                  ; a2 = city_data entry for (player, slot)
    tst.b   (a2)                                    ; byte 0 zero = no city assigned
    beq.w   l_37948                                 ; yes -> "not yet known" path
    ; --- Byte 0 non-zero: compare popularity scores A vs B ---
    move.b  (a2), d0                                ; city_data[0] = popularity score A
    cmp.b   $1(a2), d0                              ; vs city_data[1] = score B
    bhi.w   l_37994                                 ; A > B -> char leads rival -> rivalry panel
    ; --- A <= B: char is behind or equal -> show "behind" dialog ---
    bsr.w ClearCharSprites
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)                        ; char name string
    move.l  $10(a5), -(a7)                          ; format string at table+$10 ("behind" msg)
    move.l  a3, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)                                    ; ShowDialog
    lea     $20(a7), a7
    ; --- Scan $FF0338 roster (4 slots, stride 8) for a match against player index ---
    move.w  d4, d0
    lsl.w   #$5, d0                                 ; slot * $20 (player stride in $FF0338)
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2                                  ; a2 = player's 4-slot block start
    clr.w   d2                                      ; d2 = loop counter (0..3)
    clr.w   d5                                      ; d5 = found flag
    bra.b   l_37910
l_378f6:
    ; --- Roster scan loop body ---
    tst.b   $1(a2)                                  ; slot +$1 = state byte (0 = empty slot)
    beq.b   l_3790c
    moveq   #$0,d0
    move.b  (a2), d0                                ; slot +$0 = city/entity code
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0                                  ; matches player index?
    bne.b   l_3790c
    moveq   #$1,d5                                  ; found = 1
    bra.b   l_37916                                 ; exit loop
l_3790c:
    addq.l  #$8, a2                                 ; next 8-byte slot
    addq.w  #$1, d2
l_37910:
    cmpi.w  #$4, d2                                 ; all 4 slots checked?
    blt.b   l_378f6
l_37916:
    ; --- Choose dialog based on roster scan result ---
    cmpi.w  #$1, d5                                 ; found a match?
    bne.b   l_37932
    bsr.w ClearCharSprites
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $18(a5), -(a7)                          ; string at table+$18 (match-found message)
    bra.w   l_37824
l_37932:
    bsr.w ClearCharSprites
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $1c(a5), -(a7)                          ; string at table+$1c (no-match message)
    bra.w   l_37824
l_37948:
    ; --- city_data byte was 0: char not yet known to this player ---
    bsr.w ClearCharSprites
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)                        ; char name string
    move.l  $c(a5), -(a7)                           ; format string at table+$c ("not known" msg)
    move.l  a3, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)                                    ; ShowDialog
    lea     $20(a7), a7
    ; --- Also format and show an introduction panel (reuses same char name) ---
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)                        ; char name string (second reference)
    move.l  $14(a5), -(a7)                          ; format string at table+$14 (intro message)
    bra.w   l_3786a                                 ; -> sprintf + ShowDialog
l_37994:
    ; --- char leads rival (A > B): show rivalry panel if mode == 1 ---
    cmpi.w  #$1, d5
    bne.w   l_37a30                                 ; mode != 1 -> return 1 (no panel)
    ; --- Map player index to region via RangeLookup ---
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                                 ; d0 = region index (0-7) for player's hub city
    addq.l  #$4, a7
    move.w  d0, d5                                  ; d5 = region index
    cmp.w   d2, d0                                  ; region == entity index? (trivially same area)
    beq.w   l_37a30                                 ; yes -> no useful rivalry info, return 1
    ; --- BitFieldSearch for (region, slot) pair ---
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; region index
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; char slot
    jsr BitFieldSearch                              ; search $FFA6A0 bitfield
    addq.l  #$8, a7
    move.w  d0, d2                                  ; d2 = result
    cmpi.w  #$ff, d0                                ; not found?
    bne.b   l_379ea                                 ; found -> use result
    ; --- Fallback: FindBitInField for the region ---
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; region index
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; char slot
    jsr FindBitInField                              ; scan for first set bit in region's longword
    addq.l  #$8, a7
    move.w  d0, d2                                  ; d2 = rival char index
    cmpi.w  #$ff, d0                                ; still not found?
    beq.b   l_37a30                                 ; yes -> nothing to show, return 1
l_379ea:
    ; --- We have a rival index in d2: display the rivalry comparison panel ---
    cmp.w   d3, d2                                  ; rival == this player? (sanity)
    beq.b   l_37a30                                 ; same -> skip
    bsr.w ClearCharSprites
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)                        ; rival's char name string
    ; --- Select format string: region 2 uses a special hardcoded string ---
    cmpi.w  #$2, d5                                 ; region == 2?
    bne.b   l_37a0e
    pea     ($00044F86).l                           ; hardcoded format string for region 2
    bra.b   l_37a1c
l_37a0e:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0                          ; region name string pointer table
    move.l  (a0,d0.w), -(a7)                        ; region name string
l_37a1c:
    move.l  $38(a5), -(a7)                          ; format string at table+$38 (rivalry panel fmt)
    move.l  a3, -(a7)                               ; output buffer
    jsr sprintf                                     ; format rivalry message with rival name + region
    lea     $10(a7), a7
    bra.w   l_37876                                 ; -> show formatted dialog
l_37a30:
    moveq   #$1,d0                                  ; return 1 = no panel rendered
l_37a32:
    movem.l -$70(a6), d2-d5/a2-a5
    unlk    a6
    rts
