; ============================================================================
; HandleRouteEventType0 -- Handle a type-0 route event (character group transfer): run transition animation, display group dialog, reinitialize chars, and optionally set $FF1294.
; 676 bytes | $022682-$022925
; ============================================================================
HandleRouteEventType0:
    ; --- Phase: Setup ---
    ; Stack frame: $C0 bytes of locals (-$C0(a6) .. -$1(a6))
    link    a6,#-$C0
    movem.l d2/a2-a5, -(a7)
    movea.l $8(a6), a2              ; a2 = event record pointer (first arg)
    lea     -$80(a6), a4            ; a4 = text-format scratch buffer in frame (128 bytes)
    movea.l  #$0003B22C,a5          ; a5 = sprintf (cached for repeated calls)
    ; --- Phase: Build transition table pointer from event group index ---
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = event_record[+1] = group/category index
    lsl.w   #$3, d0                 ; x8: 8 bytes per entry in $5F9DE table
    movea.l  #$0005F9DE,a0          ; ROM table: transition step descriptors (by group)
    lea     (a0,d0.w), a0           ; a0 = pointer to entry for this group
    movea.l a0, a3                  ; a3 = retained descriptor pointer throughout function
    ; --- Phase: Play transition animation and init info panel ---
    jsr RunTransitionSteps          ; run the 3-step panel slide-in animation
    pea     ($0005).w               ; count = 5 items to animate
    move.l  a3, d0
    addq.l  #$3, d0                 ; d0 = a3+3: pointer to character slot list in descriptor
    move.l  d0, -(a7)
    jsr AnimateInfoPanel            ; animate 5 character info tiles
    pea     ($0002).w               ; mode 2 = clear + init
    jsr InitInfoPanel               ; initialize the info panel subsystem
    lea     $c(a7), a7              ; clean up: 3 args x4 = $C
    ; --- Phase: Check if this event matches the current frame counter ---
    moveq   #$0,d0
    move.b  $2(a2), d0              ; d0 = event_record[+2] = target frame/turn value
    cmp.w   ($00FF0006).l, d0       ; compare with frame_counter ($FF0006)
    bne.w   l_2285c                 ; branch if frame counter does not match -> alternate dialog path
    ; --- Phase: Frame-match path -- show group announcement dialog ---
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = group index again
    lsl.w   #$2, d0                 ; x4: longword-indexed table
    movea.l  #$00047D7C,a0          ; ROM table: group name strings (longword pointers)
    move.l  (a0,d0.w), -(a7)        ; push group name string pointer
    pea     ($00047E22).l           ; push format string (e.g. "%s has arrived!")
    move.l  a4, -(a7)               ; push output buffer
    jsr     (a5)                    ; sprintf(buf, fmt, group_name)
    move.l  a4, -(a7)               ; push formatted string to display
    jsr (DrawLabeledBox,PC)         ; draw dialog box with formatted header
    nop
    pea     ($0001).w               ; wait_for_input = 1
    pea     ($0003).w               ; mode 3 = confirm button set
    jsr PollAction                  ; wait for player to press confirm
    lea     $18(a7), a7             ; clean up 6 args ($18)
    ; --- Phase: Determine character list branch (solo vs paired transfer) ---
    movea.l a3, a0
    addq.l  #$4, a0                 ; a0 = a3+4: second character slot in descriptor
    movea.l a0, a2                  ; a2 = pointer to second character slot
    cmpi.b  #$ff, (a0)              ; is second slot empty ($FF = no second character)?
    bne.b   l_22750                 ; branch if there is a second character -> paired dialog
    ; --- Phase: Solo character -- format single char type string ---
    moveq   #$0,d0
    move.b  $3(a3), d0              ; d0 = char type code from descriptor[+3]
    lsl.w   #$2, d0                 ; x4 to index char_stat_tab ($FF1298)
    movea.l  #$00FF1298,a0          ; char_stat_tab: 89 stat descriptors x4 bytes each
    move.b  (a0,d0.w), d0           ; d0 = field offset (byte 0 of descriptor = field in 57B record)
    andi.l  #$ff, d0                ; zero-extend
    lsl.w   #$2, d0                 ; x4 to index $5EB2C string pointer table
    movea.l  #$0005EB2C,a0          ; ROM table: character type name string pointers
    move.l  (a0,d0.w), -(a7)        ; push character type name string
    pea     -$c0(a6)                ; push output buffer (full frame local area)
    jsr     (a5)                    ; sprintf(buf, char_type_name)
    addq.l  #$8, a7                 ; clean up 2 args
    bra.b   l_227a6                 ; jump to common second dialog
l_22750:
    ; --- Phase: Paired characters -- format "char A and char B" string ---
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = second character slot value
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0          ; char_stat_tab
    move.b  (a0,d0.w), d0           ; get field offset for second char type
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0          ; char type name string table
    move.l  (a0,d0.w), -(a7)        ; push second char type name
    moveq   #$0,d0
    move.b  $3(a3), d0              ; d0 = first char type code from descriptor[+3]
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0          ; char_stat_tab
    move.b  (a0,d0.w), d0           ; get field offset for first char type
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0          ; char type name string table
    move.l  (a0,d0.w), -(a7)        ; push first char type name
    pea     ($0004130C).l           ; format string: "%s and %s" (or equivalent)
    pea     -$c0(a6)                ; output buffer
    jsr     (a5)                    ; sprintf(buf, fmt, first_name, second_name)
    lea     $10(a7), a7             ; clean up 4 args
l_227a6:
    ; --- Phase: Show second dialog (character description) ---
    pea     -$c0(a6)                ; push formatted character description string
    pea     ($00047E3E).l           ; push dialog format/template string
    move.l  a4, -(a7)               ; push header buffer
    jsr     (a5)                    ; sprintf(header, template, description)
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)         ; draw second dialog box
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction                  ; wait for player confirmation
    lea     $18(a7), a7
    ; --- Phase: Reinitialize transferred characters ---
    movea.l a3, a2
    addq.l  #$3, a2                 ; a2 = a3+3: start of character slot list in descriptor
    clr.w   d2                      ; d2 = character count / loop index
    bra.b   l_227fc                 ; jump to loop condition
l_227d6:
    ; Loop body: reinitialize one character record and mark session entry
    pea     ($0001).w               ; mode 1 = full reinit
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = char slot index from list
    move.l  d0, -(a7)
    jsr InitCharRecord              ; reinitialize character stat record for this slot
    addq.l  #$8, a7
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = char slot index again
    movea.l  #$00FF09D8,a0          ; char_session_blk: 89-byte per-char session state array
    ori.b   #$1, (a0,d0.w)          ; set bit 0: mark character as newly arrived in session
    addq.l  #$1, a2                 ; advance to next slot in list
    addq.w  #$1, d2                 ; increment count
l_227fc:
    ; Loop condition: up to 5 chars or until $FF sentinel
    cmpi.w  #$5, d2                 ; processed 5 characters?
    bge.b   l_22808                 ; yes -> done
    cmpi.b  #$ff, (a2)              ; hit end-of-list sentinel?
    bne.b   l_227d6                 ; no -> reinit next character
l_22808:
    ; --- Phase: Random character relationship setup ---
    moveq   #$0,d0
    move.b  $3(a3), d0              ; d0 = primary char type from descriptor
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup                 ; map char type to region category (0-7)
    addq.l  #$4, a7
    move.l  d0, -(a7)               ; push region category
    clr.l   -(a7)                   ; push 0 (char_index base)
    jsr (GetCharStatsS2,PC)         ; get character stats for this type/region
    nop
    ; Pick a random character slot from the group for the relation
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0                 ; max = count-1
    move.l  d0, -(a7)
    clr.l   -(a7)                   ; min = 0
    jsr RandRange                   ; random index in [0, count-1]
    lea     $10(a7), a7
    move.w  d0, d2                  ; d2 = random slot index
    moveq   #$0,d0
    move.b  $2(a3), d0              ; d0 = event param from descriptor[+2]
    move.l  d0, -(a7)
    movea.w d2, a0
    move.b  $3(a3, a0.w), d0        ; d0 = char code at random slot in descriptor
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    jsr (GetCharRelationS2,PC)      ; set up character relation record
    nop
    bra.b   l_228da
l_2285c:
    ; --- Phase: No frame-match path -- show "group not available yet" dialog ---
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = group index
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0          ; group name string pointer table
    move.l  (a0,d0.w), -(a7)        ; push group name
    pea     ($00047E5C).l           ; alternate format string (not-yet-arrived message)
    move.l  a4, -(a7)
    jsr     (a5)                    ; sprintf(buf, fmt, group_name)
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)         ; draw "not yet" dialog
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction                  ; wait for confirm
    ; Check if a matching event is already active
    clr.l   -(a7)                   ; event_type = 0
    pea     ($0002).w               ; match_mode = 2
    jsr CheckEventMatch             ; check $5FAB6 event records for mode-2 match
    lea     $20(a7), a7
    cmpi.w  #$1, d0                 ; event found?
    bne.b   l_228dc                 ; no -> skip follow-up dialog
    ; --- Phase: Existing event found -- show outcome dialog ---
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = group index
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)        ; push group name
    pea     ($00047E98).l           ; outcome format string
    move.l  a4, -(a7)
    jsr     (a5)                    ; sprintf(buf, fmt, group_name)
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)         ; draw outcome dialog
    nop
    lea     $10(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction                  ; wait for player
l_228da:
    addq.l  #$8, a7                 ; balance stack from PollAction arg pair
l_228dc:
    ; --- Phase: Teardown -- clear UI elements and check for stat_scale update ---
    jsr (ClearListArea,PC)          ; clear the text list area (10x29 region)
    nop
    jsr ClearInfoPanel              ; clear the animated info panel
    pea     ($0005).w               ; count = 5 tiles
    move.l  a3, d0
    addq.l  #$3, d0                 ; pointer to character list in descriptor
    move.l  d0, -(a7)
    jsr PlaceItemTiles              ; place the 5 character item tiles back
    jsr UpdateIfActive              ; trigger flight update if flight_active ($FF000A) is set
    ; Final event check: if mode-2 event still active, set stat_scale
    clr.l   -(a7)                   ; event_type = 0
    pea     ($0002).w               ; match_mode = 2
    jsr CheckEventMatch
    lea     $10(a7), a7
    cmpi.w  #$1, d0                 ; active event?
    bne.b   l_2291c                 ; no -> return without setting scale
    move.w  #$64, ($00FF1294).l     ; stat_scale = 100 ($64): apply 100% stat scaling for event duration
l_2291c:
    movem.l -$d4(a6), d2/a2-a5
    unlk    a6
    rts
