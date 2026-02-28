; ============================================================================
; PostTurnCleanup -- Scans end-of-turn event list, matches char types, formats and displays event result messages
; 390 bytes | $031EC4-$032049
; ============================================================================
; --- Phase: Setup -- allocate frame, save registers, load event list and char codes ---
; Args:
;   $8(a6) = display row/mode argument passed to ShowText (d7)
;   $c(a6) = pointer to char-info record (source for city_a and city_b char codes)
;
; Purpose: walks up to 2 end-of-turn event records at $FF09C2 (route_field_c, 8 bytes,
; 4 bytes per record), matches each record's char code against the active character pair
; (d5/d4), formats a result message, and calls ShowText to display it.
; A separate check at $FF09CA (route_field_b, 4 bytes) handles a follow-up event.
PostTurnCleanup:
    link    a6,#-$A0
    movem.l d2-d7/a2-a5, -(a7)
    ; d7 = display row argument (passed through to ShowText calls)
    move.l  $8(a6), d7
    ; a2 = char-info record pointer from caller
    movea.l $c(a6), a2
    ; a3 = local text formatting buffer in frame (160 bytes, used by sprintf)
    lea     -$a0(a6), a3
    ; a4 = ShowText function pointer ($2FBD6): displays formatted string at given row
    movea.l  #$0002FBD6,a4
    ; a5 = sprintf function pointer ($3B22C): formats string into buffer a3
    movea.l  #$0003B22C,a5
    ; d5 = char code A (byte 0 of caller's char record): the primary character this turn
    move.b  (a2), d5
    ; d4 = char code B (byte 1 of caller's char record): the secondary character
    move.b  $1(a2), d4
    ; switch a2 to route_field_c ($FF09C2): 2 event sub-records, 4 bytes each
    ; layout: byte[0]=type (0=multi-match, 1=single-match), byte[1]=char_index, byte[2..3]=TBD
    movea.l  #$00FF09C2,a2
    ; d3 = event record index (0 or 1)
    clr.w   d3
; --- Phase: Event record loop -- scan 2 event slots in route_field_c ---
.l31ef2:
    ; $FF sentinel in byte[0] = this slot is empty, end of valid events
    cmpi.b  #$ff, (a2)
    beq.w   .l31fd8
    ; d6 = match flag: will be set to 1 if char code matches d5 or d4
    clr.w   d6
    ; byte[0] of record = event type: 0 = multi-match (check 5 entries), 1 = single-match
    moveq   #$0,d0
    move.b  (a2), d0
    beq.b   .l31f0c
    ; type == 1: single-match path
    moveq   #$1,d1
    cmp.b   d1, d0
    beq.b   .l31f6c
    ; type > 1: unknown type, skip this record entirely
    bra.w   .l31fd8
; --- sub-path: type == 0 -- multi-entry match (up to 5 entries in $5F9E1 table) ---
.l31f0c:
    ; d2 = entry index within the $5F9E1 event-char table (0-4)
    clr.w   d2
.l31f0e:
    ; $5F9E1 = ROM event-char type table; 8 bytes per char_index entry
    ; look up entry at: char_index*8 + column_d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    add.w   d2, d0
    movea.l  #$0005F9E1,a0
    move.b  (a0,d0.w), d0
    ; check if table entry matches char code A (d5): event involves the primary char
    cmp.b   d5, d0
    beq.b   .l31f3e
    ; re-read same table entry to check against char code B (d4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    add.w   d2, d0
    movea.l  #$0005F9E1,a0
    move.b  (a0,d0.w), d0
    cmp.b   d4, d0
    bne.b   .l31f42
.l31f3e:
    ; match found: set d6 = 1 (char was involved in this event)
    moveq   #$1,d6
    bra.b   .l31f4a
.l31f42:
    ; no match on this entry; try next entry (up to 5 entries per char)
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   .l31f0e
.l31f4a:
    ; if no match found (d6 != 1), skip message display for this event record
    cmpi.w  #$1, d6
    bne.w   .l31fd8
    ; match confirmed: look up result message for this char_index from event table $47D7C
    ; $47D7C = ROM event-result message pointer table (index * 4 -> message string ptr)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    ; $47CD4 = indirected pointer to the generic event format string for type-0 events
    move.l  ($00047CD4).l, -(a7)
    bra.b   .l31fc2
; --- sub-path: type == 1 -- single char-code match against $5FA11 table ---
.l31f6c:
    ; $5FA11 = ROM single-match event char-code table (index * 4 -> byte)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    ; if table entry matches char code A (d5), this event applies
    cmp.b   d5, d0
    beq.b   .l31f98
    ; re-check against char code B (d4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    cmp.b   d4, d0
    ; neither char matches this type-1 event, skip it
    bne.b   .l31fd8
.l31f98:
    ; match found for type-1 event: look up char-category string for this char_index
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ; use char code as index into $5E680 char-name string table (* 4 for longword pointer)
    lsl.w   #$2, d0
    ; $5E680 = ROM char-name string pointer table (index * 4)
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; $47CD8 = indirected pointer to the format string for type-1 single-match events
    move.l  ($00047CD8).l, -(a7)
; --- common tail: format and display the matched event message ---
.l31fc2:
    ; sprintf(a3, format, char_name): format event result text into local buffer a3
    move.l  a3, -(a7)
    ; a5 = sprintf ($3B22C): writes formatted string to a3 buffer
    jsr     (a5)
    ; ShowText(row=d7, str=a3, mode=2, 0): display the formatted event message
    ; mode 2 = text overlay with normal display priority
    pea     ($0002).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    ; a4 = ShowText ($2FBD6): renders text string on screen at row d7
    jsr     (a4)
    lea     $1c(a7), a7
.l31fd8:
    ; advance to next event record (4 bytes per record in route_field_c)
    addq.l  #$4, a2
    addq.w  #$1, d3
    ; process at most 2 records from route_field_c
    cmpi.w  #$2, d3
    blt.w   .l31ef2
    ; --- Phase: Follow-up event check -- route_field_b ($FF09CA, 4 bytes) ---
    ; route_field_b: byte[0]=guard (nonzero=skip), byte[1]=char_index, byte[2..3]=TBD
    movea.l  #$00FF09CA,a2
    ; if guard byte is nonzero, no follow-up event to process
    tst.b   (a2)
    bne.b   .l32040
    ; check whether the follow-up event's char (byte[1]) matches either active char
    move.b  $1(a2), d3
    cmp.b   d5, d3
    beq.b   .l31ffa
    cmp.b   d4, d3
    ; char code does not match either participant, skip follow-up
    bne.b   .l32040
.l31ffa:
    ; char code matches: classify this event to determine message category
    ; ClassifyEvent maps char code d3 to event category 1-5
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    ; ClassifyEvent: returns category (1-5) based on char code -- drives message table lookup
    jsr ClassifyEvent
    ; d2 = event category (1-5)
    move.w  d0, d2
    ; look up char name string for this char code from $5E680 table
    moveq   #$0,d0
    move.b  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; look up category-specific message format pointer from $47D94 table
    ; $47D94 = ROM follow-up event message pointer table, indexed by category (1-5)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047D94,a0
    move.l  (a0,d0.w), -(a7)
    ; $47CDC = indirected pointer to format string for follow-up event
    move.l  ($00047CDC).l, -(a7)
    move.l  a3, -(a7)
    ; sprintf: format the follow-up event message into local buffer a3
    jsr     (a5)
    ; ShowText with mode=1 (foreground priority display for follow-up message)
    pea     ($0002).w
    move.l  a3, -(a7)
    pea     ($0001).w
    move.w  d7, d0
    move.l  d0, -(a7)
    ; ShowText: display follow-up event result on screen
    jsr     (a4)
.l32040:
    movem.l -$c8(a6), d2-d7/a2-a5
    unlk    a6
    rts

RunAIStrategy:                                                  ; $03204A
    movem.l d2/a2,-(sp)
    move.w  #$3,($00FFA7DA).l
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0154                                 ; jsr $0321DC
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0304                                 ; jsr $032398
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0772                                 ; jsr $032812
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0682                                 ; jsr $03272E
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1554                                 ; jsr $03360C
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$32fc                                 ; jsr $0353C0
    nop
    moveq   #$0,d0
    move.b  $0004(a2),d0
    moveq   #$0,d1
    move.b  $0005(a2),d1
    add.l   d1,d0
    moveq   #$28,d1
    cmp.l   d0,d1
    ble.b   .l320ea
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$1f4a                                 ; jsr $03402E
    nop
    bra.b   .l320f6
.l320ea:                                                ; $0320EA
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$29ce                                 ; jsr $034AC0
    nop
.l320f6:                                                ; $0320F6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$150e                                 ; jsr $03360C
    nop
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$3674                                 ; jsr $035782
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$32a6                                 ; jsr $0353C0
    nop
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$2e60                                 ; jsr $034F8A
    nop
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$344e                                 ; jsr $035584
    nop
    addq.l  #$8,sp
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  #$01f4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$01f4,d0
    cmp.l   $0006(a2),d0
    ble.b   .l3216a
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$3718                                 ; jsr $03587C
    nop
    addq.l  #$4,sp
.l3216a:                                                ; $03216A
    move.w  ($00FF0002).l,d0
    ext.l   d0
    move.l  #$1f40,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addi.l  #$3e80,d0
    cmp.l   $0006(a2),d0
    bge.b   .l32198
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$405e                                 ; jsr $0361F0
    nop
    addq.l  #$4,sp
.l32198:                                                ; $032198
    dc.w    $4eba,$4040                                 ; jsr $0361DA
    nop
    cmpi.w  #$14,d0
    bls.b   .l321c8
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    moveq   #$1,d1
    cmp.l   d0,d1
    bne.b   .l321c8
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$46d2                                 ; jsr $036894
    nop
    addq.l  #$4,sp
.l321c8:                                                ; $0321C8
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$388e                                 ; jsr $035A5E
    nop
    addq.l  #$4,sp
    movem.l (sp)+,d2/a2
    rts
    dc.w    $48E7,$303C; $0321DC
; === Translated block $0321E0-$032D7A ===
; 11 functions, 2970 bytes
