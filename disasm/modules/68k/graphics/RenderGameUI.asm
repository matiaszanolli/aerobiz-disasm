; ============================================================================
; RenderGameUI -- Render main game UI event dialogs: dispatch on event type to trade scroll animations and info display functions, poll input, and update char state.
; 702 bytes | $022D0A-$022FC7
; ============================================================================
RenderGameUI:
    ; --- Phase: Setup ---
    link    a6,#-$80           ; $80 bytes local: a5 = -$80(a6) = sprintf format buffer
    movem.l d2/a2-a5, -(a7)
    movea.l  #$000238F0,a3     ; a3 = InitInfoPanel ($0238F0): info panel init routine
    movea.l  #$00023958,a4     ; a4 = AnimateInfoPanel ($023958): info panel animation routine
    lea     -$80(a6), a5       ; a5 = local sprintf buffer ($80 bytes on stack)
    movea.l  #$00FF09CA,a2     ; a2 = route_field_b ($FF09CA): pending route event record
    ; --- Phase: Dispatch on event state byte 0 ---
    ; route_field_b layout: +$00=type_flag, +$01=event_subtype, +$02=pending_flag
    tst.b   (a2)               ; +$00 = type_flag: 0=new event, 1=trade-in-progress
    bne.w   l_22e92            ; nonzero -> trade-in-progress path
    tst.b   $2(a2)             ; +$02 = pending_flag: nonzero = event already processed
    bne.w   l_22fbe            ; pending flag set -> skip to epilogue (nothing to do)
    ; --- Phase: New event -- classify and dispatch animation ---
    moveq   #$0,d0
    move.b  $1(a2), d0         ; +$01 = event subtype index
    move.l  d0, -(a7)
    jsr (ClassifyEvent,PC)     ; $0232B6: map event code to category 1-5
    nop
    addq.l  #$4, a7
    move.w  d0, d2             ; d2 = event category (1-5)
    ext.l   d0
    subq.l  #$1, d0            ; d0 = category - 1 (0-indexed for jump table)
    moveq   #$4,d1             ; max valid index = 4 (5 categories)
    cmp.l   d1, d0
    bhi.b   l_22dca            ; out of range: skip animation, go to info display
    ; 5-way jump table dispatch on event category
    add.l   d0, d0             ; d0 *= 2 (word offsets)
    dc.w    $303B,$0806        ; move.w (6,pc,d0.l),d0  -- load table offset
    dc.w    $4EFB,$0002        ; jmp (pc,d0.w)           -- dispatch
    dc.w    $000A              ; case 1: offset to case-1 handler
    dc.w    $001E              ; case 2: offset to case-2 handler
    dc.w    $001E              ; case 3: same as case-2 handler
    dc.w    $0032              ; case 4: offset to case-4 handler
    dc.w    $0046              ; case 5: offset to case-5 handler (LoadDisplaySet + AnimateScrollWipe)
    ; --- Case 1: Animate info panel with item index 8 ---
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0            ; d0 = &a2[1] = pointer to event subtype byte
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel($023958): animate info panel item
    addq.l  #$8, a7
    pea     ($0008).w          ; info-panel display index = 8
    bra.b   l_22dc6
    ; --- Cases 2 & 3: Animate info panel with item index 9 ---
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel
    addq.l  #$8, a7
    pea     ($0009).w          ; info-panel display index = 9
    bra.b   l_22dc6
    ; --- Case 4: Animate info panel with item index 10 ---
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel
    addq.l  #$8, a7
    pea     ($000A).w          ; info-panel display index = 10
    bra.b   l_22dc6
    ; --- Case 5: Load display set, run animated scroll wipe, then animate panel ---
    pea     ($0001).w
    jsr LoadDisplaySet         ; $01D444: load display resources for current mode
    jsr AnimateScrollWipe      ; $023C9A: animated scroll wipe transition effect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel
    lea     $c(a7), a7
    pea     ($0007).w          ; info-panel display index = 7
l_22dc6:
    ; Call InitInfoPanel to render the info panel after animation
    jsr     (a3)               ; InitInfoPanel ($0238F0)
    addq.l  #$4, a7
    ; --- Phase: Build and display labeled info box ---
l_22dca:
    ; Fetch char name string pointer: $5E680 is a ROM pointer table indexed by event subtype
    moveq   #$0,d0
    move.b  $1(a2), d0         ; event subtype
    lsl.w   #$2, d0            ; d0 *= 4 (long pointer table index)
    movea.l  #$0005E680,a0     ; a0 = ROM char name pointer table
    move.l  (a0,d0.w), -(a7)  ; push char name string ptr as sprintf arg
    ; Fetch event-type label: $47D94 is a ROM pointer table indexed by event category
    move.w  d2, d0             ; d2 = event category (from ClassifyEvent)
    lsl.w   #$2, d0            ; d0 *= 4
    movea.l  #$00047D94,a0     ; a0 = ROM event-category label pointer table
    move.l  (a0,d0.w), -(a7)  ; push event label string ptr as sprintf arg
    ; Select format string: category 5 uses a different format (two args vs one)
    cmpi.w  #$5, d2
    bne.b   l_22df8
    pea     ($00041328).l      ; ROM format string for category-5 events (2 args)
    bra.b   l_22dfe
l_22df8:
    pea     ($00041326).l      ; ROM format string for categories 1-4 (standard)
l_22dfe:
    pea     ($0004805A).l      ; ROM template string for labeled box header
    move.l  a5, -(a7)          ; destination = local sprintf buffer
    jsr sprintf                ; $03B22C: format string to buffer
    move.l  a5, -(a7)          ; push formatted string for DrawLabeledBox
    jsr (DrawLabeledBox,PC)    ; $02377C: DrawBox + PrintfWide wrapper
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction             ; $01D62C: flush-then-wait input polling
    pea     ($0018).w
    jsr GameCommand            ; GameCommand #$18 = display/page flip
    jsr ClearInfoPanel         ; $023930: clear the info panel tiles
    ; Refresh item tiles and reinitialize char record for next event
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0            ; &a2[1] = event subtype pointer
    move.l  d0, -(a7)
    jsr PlaceItemTiles         ; $023A34: place item tiles for count items
    lea     $2c(a7), a7
    ; Randomize next event timing: RandRange(1,3) * $A -> write to pending_flag
    pea     ($0003).w          ; max = 3
    pea     ($0001).w          ; min = 1
    jsr RandRange              ; $01D6A4: random int in [1,3]
    mulu.w  #$a, d0            ; scale: random * 10
    move.b  d0, $2(a2)         ; store scaled random -> +$02 pending_flag/timer
    ; Re-init character record for the event subtype
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0         ; event subtype = char record index
    move.l  d0, -(a7)
    jsr InitCharRecord         ; $0181C6: initialize character record slot
    ; Look up and update character relationship state
    moveq   #$0,d0
    move.b  $2(a2), d0         ; +$02: now holds scaled random timer value
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0         ; +$01: event subtype
    move.l  d0, -(a7)
    jsr (GetCharRelationS2,PC) ; get updated char relation status (PC-relative call)
    nop
    lea     $18(a7), a7
    jsr (ClearListArea,PC)     ; $0237A8: clear the list display area
    nop
    bra.w   l_22fbe            ; -> epilogue

    ; --- Phase: Trade-in-progress path (type_flag == 1) ---
l_22e92:
    cmpi.b  #$1, (a2)          ; confirm type_flag == 1 (trade in progress)
    bne.w   l_22fbe            ; unexpected value: skip to epilogue
    moveq   #$0,d0
    move.b  $1(a2), d0         ; event subtype = trade partner index
    move.l  d0, -(a7)
    jsr (ProcessTradeS2,PC)    ; execute trade action; returns result code in d0
    nop
    move.w  d0, d2             ; d2 = trade result code (1-4)
    ; Clear full screen tile region after trade processing
    move.l  #$8000, -(a7)      ; priority $8000
    pea     ($0020).w          ; width 32
    pea     ($0020).w          ; height 32
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w          ; GameCommand #$1A = ClearTileArea
    jsr GameCommand
    ; GameCommand #$10: display-page control
    pea     ($0040).w          ; arg $40
    clr.l   -(a7)
    pea     ($0010).w          ; GameCommand #$10
    jsr GameCommand
    lea     $2c(a7), a7
    ; --- Dispatch trade result animation (4-way jump table) ---
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0            ; d0 = result - 1 (0-indexed)
    moveq   #$3,d1             ; max valid index = 3 (4 results)
    cmp.l   d1, d0
    bhi.b   l_22f5e            ; out of range: skip animation
    add.l   d0, d0             ; d0 *= 2 (word offset)
    dc.w    $303B,$0806        ; move.w (6,pc,d0.l),d0  -- load table offset
    dc.w    $4EFB,$0002        ; jmp (pc,d0.w)           -- dispatch
    dc.w    $0008              ; result 1: AnimateScrollEffect, panel index $B
    dc.w    $0022              ; result 2: AnimateScrollEffect, panel index $D
    dc.w    $003C              ; result 3: panel index $E (no scroll animation)
    dc.w    $0050              ; result 4: AnimateScrollEffect, panel index $C
    ; --- Trade result 1 ---
    jsr AnimateScrollEffect    ; $023B6A: 3-phase scroll animation
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel
    addq.l  #$8, a7
    pea     ($000B).w          ; panel index $B
    bra.b   l_22f5a
    ; --- Trade result 2 ---
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel
    addq.l  #$8, a7
    pea     ($000D).w          ; panel index $D
    bra.b   l_22f5a
    ; --- Trade result 3 (no scroll animation) ---
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel
    addq.l  #$8, a7
    pea     ($000E).w          ; panel index $E
    bra.b   l_22f5a
    ; --- Trade result 4 ---
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)               ; AnimateInfoPanel
    addq.l  #$8, a7
    pea     ($000C).w          ; panel index $C
l_22f5a:
    jsr     (a3)               ; InitInfoPanel: render panel after animation
    addq.l  #$4, a7
l_22f5e:
    ; --- Phase: Build and display trade result labeled box ---
    ; Fetch trade result label from ROM table at $47DAC (indexed by result code)
    move.w  d2, d0             ; d2 = trade result code
    lsl.w   #$2, d0
    movea.l  #$00047DAC,a0     ; a0 = ROM trade-result label pointer table
    move.l  (a0,d0.w), -(a7)  ; push trade result label string
    ; Fetch char name from $5E680 table (indexed by event subtype)
    moveq   #$0,d0
    move.b  $1(a2), d0         ; event subtype = char index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0     ; a0 = ROM char name pointer table
    move.l  (a0,d0.w), -(a7)  ; push char name string
    pea     ($0004808E).l      ; ROM format string for trade result display
    move.l  a5, -(a7)          ; destination = local sprintf buffer
    jsr sprintf
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)    ; $02377C: DrawBox + PrintfWide wrapper
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction             ; wait for button press
    jsr (ClearListArea,PC)     ; $0237A8: clear list area
    nop
    jsr ClearInfoPanel         ; $023930: clear info panel
    ; Replace item tiles for the trade partner's slot
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles         ; $023A34: place item tiles
l_22fbe:
    ; --- Phase: Epilogue ---
    movem.l -$94(a6), d2/a2-a5
    unlk    a6
    rts
