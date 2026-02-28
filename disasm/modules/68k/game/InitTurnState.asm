; ============================================================================
; InitTurnState -- Selects a random route and character for the current turn via bitfield search, looks up city and char compatibility, and fills the turn-state record with route/char/speed data
; 710 bytes | $01A792-$01AA57
; ============================================================================
; --- Phase: Setup -- Player and Route Selection ---
InitTurnState:
    movem.l d2-d7/a2-a5, -(a7)
    ; d5 = player index (arg 1 from $2C(a7), adjusted for 9 saved regs + lr)
    move.l  $2c(a7), d5
    ; a3 = pointer to turn-state record to fill in (arg 2 from $30(a7))
    movea.l $30(a7), a3
    ; a5 = RandRange function pointer ($1D6A4) -- called repeatedly to pick random indices
    movea.l  #$0001D6A4,a5
    ; --- Branch 1: Player Mode or AI Mode ---
    ; Roll RandRange(0, 3): returns 0-3. Non-zero = AI/alliance path
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    tst.l   d0
    bne.w   l_1a8dc
    ; --- Player Path: Pick route category (d4) and route city (d7) ---
    ; Roll RandRange(0, 3): selects which of the 4 route categories to use
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    ; d4 = random route category (0-3)
    move.w  d0, d4
    ; Index into alliance table $FFA7BC: player*7 + category
    ; $FFA7BC stores alliance flags: nonzero = player has alliances in this category
    mulu.w  #$7, d0
    add.w   d5, d0
    movea.l  #$00FFA7BC,a0
    ; If no alliance exists for this player/category pair: abort (no valid routes)
    tst.b   (a0,d0.w)
    beq.w   l_1aa52
    ; --- Find a valid char/route bit in the bitfield ---
    ; BitFieldSearch: finds the first set bit in alliance bitfield for (player=d5, category=d4)
    ; Returns the char index, or $FF if none found
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    ; d7 = selected char/route index from bitfield search
    move.w  d0, d7
    cmpi.w  #$ff, d7
    bne.b   l_1a806
    ; BitFieldSearch returned $FF: fall back to FindBitInField (broader search)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; FindBitInField scans $FFA6A0 bitfield table for any set bit
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d7
l_1a806:
    ; If still $FF: no valid route found for this player+category -- return early
    cmpi.w  #$ff, d7
    beq.w   l_1aa52
; --- Phase: Select Second Route Entity (d6) ---
l_1a80e:
    ; Roll RandRange(0, 6): selects an index within the category's 7 slots
    pea     ($0006).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    ; d6 = second entity index candidate
    move.w  d0, d6
    ; Verify this candidate bit is actually set in $FFA7BC for (player, category)
    ; i.e., there really is an alliance at this position
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    mulu.w  #$7, d1
    add.w   d5, d1
    movea.l  #$00FFA7BC,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    ; If the chosen bit isn't set in the alliance byte: retry with another random index
    and.l   d1, d0
    beq.b   l_1a80e
    ; Found a valid second entity: search for its slot index via BitFieldSearch
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    ; d2 = slot/char index for second entity
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.b   l_1a870
    ; Fall back to FindBitInField if BitFieldSearch returned $FF
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d2
; --- Phase: Fill Turn-State Record ---
l_1a870:
    ; Write route category (d4) into turn-state record byte 0
    move.b  d4, (a3)
    ; Roll RandRange(0, 1): determines which entity is "active" (A or B role)
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    ; d3 = role selector: 0 = d7 is primary (char A), 1 = d7 is secondary (char B)
    move.w  d0, d3
    tst.w   d3
    bne.b   l_1a8b6
    ; --- d7 is primary (char A), d2 is secondary (char B) ---
    ; Look up city info for d7: $5E9FA table, entry d7*2 (word pointer per city)
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    ; a2 = city info entry for the primary city (d7)
    movea.l a0, a2
    ; Look up speed/route data for (player=d5, category=d6) in $5E234 table
    ; Stride: player*$E + category*2
    move.w  d5, d0
    mulu.w  #$e, d0
    move.w  d6, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
l_1a8a4:
    ; a4 = pointer to route speed/data entry
    lea     (a0,d0.w), a0
    movea.l a0, a4
    ; turn_state+$01 = primary char index (d7)
    move.b  d7, $1(a3)
    ; turn_state+$02 = secondary char index (d2)
    move.b  d2, $2(a3)
    bra.w   l_1aa42
l_1a8b6:
    ; --- d7 is secondary (char B role), d2 is primary ---
    ; Look up city info for d7 (now secondary)
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    ; a4 = city info for secondary city
    movea.l a0, a4
    ; Look up speed data for (player=d5, category=d6)
    move.w  d5, d0
    mulu.w  #$e, d0
    move.w  d6, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
    bra.w   l_1aa34
; --- Phase: AI/Alliance Path ---
l_1a8dc:
    ; Look up the player's category range descriptor from $5ECBC (ROM table, stride 4)
    ; This gives the base city and range for this player's alliance category
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    ; a2 = category range descriptor for player d5
    movea.l a0, a2
    ; d6 = range size: descriptor[1] + descriptor[3] - 1
    ; This spans all valid char indices in this player's alliance range
    moveq   #$0,d6
    move.b  $1(a2), d6
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d6
    ; Subtract 1 to get max valid index (for RandRange upper bound)
    addi.w  #$ffff, d6
    ; Roll RandRange(0, 3): selects a route category for the AI player
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    ; d4 = AI-chosen route category (0-3)
    move.w  d0, d4
    ; Check bitfield_tab ($FFA6A0) for this category: is there any alliance active?
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    ; Mask with player's valid city bitmask from $5ECDC (ROM table, stride 4)
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    ; If any bits set: at least one active alliance city -- proceed
    bne.b   l_1a940
    ; No active alliance in bitfield: check $FFBD6C word table as fallback
    ; $FFBD6C: indexed [category * $E + player * 2]; nonzero = relation exists
    move.w  d4, d0
    mulu.w  #$e, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    tst.w   (a0,d0.w)
    ; If zero: no relations for this player+category -- abort
    beq.w   l_1aa52
l_1a940:
    ; Search for a set bit in the alliance bitfield for (player=d5, category=d4)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    ; d7 = primary char/city index found; $FF = none
    move.w  d0, d7
    cmpi.w  #$ff, d0
    beq.w   l_1aa52
    ; d3 = retry counter for finding a valid secondary char (max $10 = 16 attempts)
    clr.w   d3
; --- Phase: AI Secondary Char Search (up to 16 attempts) ---
l_1a960:
    ; Roll RandRange(0, d6): pick a random secondary index within the alliance range
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    ; d2 = candidate secondary index
    move.w  d0, d2
    ; Check: is d2 below the descriptor's threshold (byte 1 = domestic range upper bound)?
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d2, d0
    ble.b   l_1a99a
    ; d2 is in the first range band: convert to absolute index by adding base (byte 0)
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d2
    ; Test the absolute index bit in bitfield_tab for category d4
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    ; If bit is set: this secondary char is available
    and.l   (a0,d1.w), d0
    beq.b   l_1a9da
    bra.b   l_1a9e4
l_1a99a:
    ; d2 >= threshold: in the second range band (international range)
    ; Convert: d2 -= byte[1] (international base offset)
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ; Test via $FFBD6C relation word table instead
    ; index = category * $E + (d7 as player) * 2 (complex formula using exg)
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d5, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    ; Read the relation word for this player+category combination
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    ; If relation word has the bit set: valid secondary
    and.l   d1, d0
    beq.b   l_1a9da
    ; Valid: adjust index by adding descriptor byte 2 (secondary base)
    moveq   #$0,d0
    move.b  $2(a2), d0
    add.w   d0, d2
    bra.b   l_1a9e4
l_1a9da:
    ; This candidate failed: increment retry count and try again
    addq.w  #$1, d3
    ; Max 16 attempts ($10) before giving up
    cmpi.w  #$10, d3
    blt.w   l_1a960
l_1a9e4:
    ; If we exhausted all retries: abort (no valid secondary found)
    cmpi.w  #$10, d3
    bge.b   l_1aa52
    ; --- Fill AI Turn-State Record ---
    ; Write route category (d4) to turn_state[0]
    move.b  d4, (a3)
    ; Roll RandRange(0, 1): determines primary/secondary assignment for AI
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_1aa1a
    ; d7 is primary city, d2 is secondary city
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    ; a2 = city info for d7 (primary)
    movea.l a0, a2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    bra.w   l_1a8a4
l_1aa1a:
    ; d7 is secondary city, d2 is primary city (roles swapped)
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    ; a4 = city info for d7 (now secondary)
    movea.l a0, a4
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
l_1aa34:
    lea     (a0,d0.w), a0
    ; a2 = city info for d2 (primary in swapped case)
    movea.l a0, a2
    ; turn_state+$02 = d7's index (secondary city)
    move.b  d7, $2(a3)
    ; turn_state+$01 = d2's index (primary city)
    move.b  d2, $1(a3)
; --- Phase: Advance Game Phase ---
l_1aa42:
    ; ProgressGamePhase: advance the game's turn/phase state using the filled record
    ; Args: turn_state record ptr, city_a ptr (a2), city_b ptr (a4)
    move.l  a4, -(a7)
    move.l  a2, -(a7)
    move.l  a3, -(a7)
    jsr (ProgressGamePhase,PC)
    nop
    lea     $c(a7), a7
; --- Phase: Return ---
l_1aa52:
    movem.l (a7)+, d2-d7/a2-a5
    rts


; === Translated block $01AA58-$01ABB0 ===
; 1 functions, 344 bytes
