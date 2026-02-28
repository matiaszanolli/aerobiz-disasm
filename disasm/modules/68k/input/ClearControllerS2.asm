; ============================================================================
; ClearControllerS2 -- Runs the aircraft selection/assignment UI: draws route and character panels, handles directional input to cycle valid slots, shows a character name dialog on confirm, calls ProcessCrewSalary/FindAvailableSlot for slot management, and exits on B/cancel
; 640 bytes | $02CCD0-$02CF4F
; ============================================================================
ClearControllerS2:
    ; --- Phase: Setup ---
    ; Despite its name, this function is the aircraft-slot selection/assignment UI.
    ; It shows a route panel and cycles through character/aircraft slots with d-pad input.
    link    a6,#-$80           ; $80 bytes local: -$80(a6) = sprintf buffer
    movem.l d2-d5/a2-a4, -(a7)
    ; Stack args: $8(a6)=player_index(d4), $e(a6)=initial_slot_index(d2)
    move.l  $8(a6), d4         ; d4 = player index (0-3)
    movea.l  #$00000D64,a2     ; a2 = GameCommand ($000D64): central command dispatcher
    movea.l  #$00007912,a3     ; a3 = ShowDialog ($007912): display dialog with table lookup
    movea.l  #$00048476,a4     ; a4 = ROM data pointer (table base for slot display data)
    move.w  $e(a6), d2         ; d2 = current slot index (0-$B=normal slots, $A/$B=special)
    ; --- Phase: Initial screen setup ---
    jsr ClearBothPlanes        ; $00814A: clear both scroll planes (blank screen)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0007).w          ; arg: display mode 7
    clr.l   -(a7)
    jsr (ShowRoutePanel,PC)    ; draw the route/aircraft panel for slot d2
    nop
    lea     $c(a7), a7
    jsr ResourceUnload         ; $01D748: unload previous resource (free slot)
    ; =========================================================
    ; Outer loop: redraws panel header and re-enters input loop.
    ; Re-entered after ShowDialog (confirm) and after FindAvailableSlot/ProcessCrewSalary.
    ; =========================================================
.l2cd14:
    ; Show dialog with empty strings (resets the dialog text area)
    clr.l   -(a7)              ; arg 5 = 0
    clr.l   -(a7)              ; arg 4 = 0
    clr.l   -(a7)              ; arg 3 = 0
    move.l  (a4), -(a7)        ; arg 2 = *a4: ROM data pointer for current slot display
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)          ; arg 1 = player_index
    jsr     (a3)               ; ShowDialog($007912): display panel/dialog for player
    lea     $14(a7), a7
    clr.w   d3                 ; d3 = animation frame counter (cycles 0->1->...$1e then resets)
    ; =========================================================
    ; Inner display loop: draws char panel, advances animation, polls input.
    ; =========================================================
.l2cd2a:
    ; Draw character stat panel for current slot d2
    pea     ($0007).w          ; display mode 7
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)          ; arg: current slot index
    jsr (ShowCharPanelS2,PC)   ; draw char panel for slot d2 (PC-relative call)
    nop
    ; GameCommand #$E: display sync/advance
    pea     ($0004).w          ; arg $04
    pea     ($000E).w          ; GameCommand #$E = display sync
    jsr     (a2)               ; GameCommand
    lea     $14(a7), a7
    addq.w  #$1, d3            ; advance animation frame counter
    ; --- On first frame (d3==1): place two header tile icons ---
    cmpi.w  #$1, d3
    bne.b   .l2cdba
    ; Place first icon tile (route label icon at row $39, col $18)
    move.l  #$8000, -(a7)      ; priority $8000
    pea     ($0001).w          ; count 1
    pea     ($0001).w          ; palette 1
    pea     ($0080).w          ; tile attr $0080
    pea     ($0018).w          ; X position (col $18 = 24)
    pea     ($0039).w          ; Y position (row $39 = 57)
    pea     ($0772).w          ; tile char# $0772
    jsr TilePlacement          ; $01E044: build tile params, call GameCmd #15
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)               ; GameCommand #$E: display sync
    lea     $24(a7), a7
    ; Place second icon tile (route label icon at row $3A, col $A0)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($00A0).w          ; X position (col $A0 = 160)
    pea     ($003A).w          ; Y position (row $3A = 58)
    pea     ($0773).w          ; tile char# $0773
    jsr TilePlacement
    lea     $1c(a7), a7
.l2cdac:
    ; GameCommand #$E: display sync (used after frame 1 icon placement)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)               ; GameCommand #$E
    addq.l  #$8, a7
    bra.b   .l2cdda            ; proceed to input poll
.l2cdba:
    ; --- On frame $F (15): call GameCmd16 to clear/refresh sprite area ---
    cmpi.w  #$f, d3
    bne.b   .l2cdd2
    pea     ($0002).w          ; arg: mode 2
    pea     ($0039).w          ; arg: row $39
    jsr GameCmd16              ; $01E0B8: thin wrapper for GameCommand #16
    addq.l  #$8, a7
    bra.b   .l2cdac
.l2cdd2:
    ; --- On frame $1E (30): reset frame counter (animation loops every 30 frames) ---
    cmpi.w  #$1e, d3
    bne.b   .l2cdda
    clr.w   d3                 ; reset animation counter to 0
    ; --- Phase: Poll input ---
.l2cdda:
    move.w  d5, d0             ; d5 = previous input state (for auto-repeat)
    move.l  d0, -(a7)
    pea     ($000A).w          ; repeat interval = $A = 10 frames
    jsr ProcessInputLoop       ; $01E290: poll with auto-repeat; returns button bits in d0
    addq.l  #$8, a7
    andi.w  #$3c, d0           ; $3C = %00111100: mask to Up($20)|Down($10)|Left($04)|Right($08)
    move.w  d0, d5             ; save filtered input state
    ; --- Dispatch on button ---
    andi.w  #$20, d0           ; $20 = Left d-pad
    beq.b   .l2ce60            ; not Left: check other buttons
    ; --- Left pressed: confirm selection ---
    cmpi.w  #$b, d2            ; slot $B or higher = special exit slots
    bcc.w   .l2cf02            ; >= $B: skip dialog, go to exit dispatch
    ; Check if slot is available: $FF1584 is flight_slots+$48 area; nonzero = slot occupied
    move.w  d2, d0
    add.w   d0, d0             ; d0 = d2 * 2 (word index)
    movea.l  #$00FF1584,a0     ; a0 = flight slot status table ($FF1584 = flight_slots+$48)
    tst.w   (a0,d0.w)          ; is this slot already occupied?
    bne.w   .l2cf02            ; yes: skip confirm, go to exit dispatch
    ; Build character name string via sprintf and show confirm dialog
    move.w  d2, d0
    lsl.w   #$2, d0            ; d0 = d2 * 4 (long pointer index)
    movea.l  #$0005F04C,a0     ; a0 = ROM slot-name pointer table
    move.l  (a0,d0.w), -(a7)  ; push slot name string ptr as sprintf arg
    move.l  ($00048482).l, -(a7) ; push format template string from ROM data ptr
    pea     -$80(a6)           ; destination = local sprintf buffer
    jsr sprintf                ; format char/slot name into buffer
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w          ; dialog mode 2
    pea     -$80(a6)           ; formatted string as dialog text
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)          ; player_index
    jsr     (a3)               ; ShowDialog: show confirm dialog with formatted name
    lea     $20(a7), a7
    ; Reinitialize panel header with blank args before looping
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  (a4), -(a7)        ; ROM data pointer
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)          ; player_index
    jsr     (a3)               ; ShowDialog: redraw panel header
    lea     $14(a7), a7
    bra.w   .l2cd2a            ; loop back to char panel draw
    ; --- Right pressed: set slot to $C (exit-right sentinel) ---
.l2ce60:
    move.w  d5, d0
    andi.w  #$10, d0           ; $10 = Right d-pad
    beq.b   .l2ce6e
    moveq   #$C,d2             ; d2 = $C: right-exit sentinel slot
    bra.w   .l2cf02            ; -> exit dispatch
    ; --- Up pressed: decrement slot index (with wrap, skipping unavailable slots) ---
.l2ce6e:
    move.w  d5, d0
    andi.w  #$4, d0            ; $04 = Up d-pad
    beq.b   .l2cec4            ; not Up: check Down
.l2ce76:
    ; Decrement d2 with wrap-around through the slot circle: 0->$A->$B->0
    tst.w   d2                 ; d2 == 0?
    bne.b   .l2ce7e
    moveq   #$A,d2             ; wrap: 0 -> $A
    bra.b   .l2ce94
.l2ce7e:
    cmpi.w  #$3, d2
    bne.b   .l2ce88
    moveq   #$B,d2             ; 3 -> $B (skip wrap point)
    bra.b   .l2ce94
.l2ce88:
    cmpi.w  #$b, d2
    bne.b   .l2ce92
    moveq   #$2,d2             ; $B -> 2
    bra.b   .l2ce94
.l2ce92:
    subq.w  #$1, d2            ; normal decrement
.l2ce94:
    ; Check if new slot is valid (enabled): $FF17E8 is a slot-enable flag table (word per slot)
    move.w  d2, d0
    add.w   d0, d0             ; d0 = d2 * 2 (word index)
    movea.l  #$00FF17E8,a0     ; a0 = slot availability/enable flag table
    cmpi.w  #$1, (a0,d0.w)    ; slot d2 enabled?
    bne.b   .l2ce76            ; no: keep decrementing to find next enabled slot
.l2cea6:
    ; Refresh display after cursor move: GameCommand #$10 (display page) + #$E (sync)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0010).w          ; GameCommand #$10
    jsr     (a2)
    pea     ($0006).w
    pea     ($000E).w          ; GameCommand #$E
    jsr     (a2)
    lea     $14(a7), a7
    bra.w   .l2cd2a            ; redraw char panel for new slot
    ; --- Down pressed: increment slot index (with wrap, skipping unavailable slots) ---
.l2cec4:
    move.w  d5, d0
    andi.w  #$8, d0            ; $08 = Down d-pad
    beq.w   .l2cd2a            ; not Down: no directional input, just redraw
.l2cece:
    ; Increment d2 with wrap-around: $A->0, 2->$B, $B->3, else +1
    cmpi.w  #$a, d2
    bne.b   .l2ced8
    clr.w   d2                 ; $A -> 0 (wrap)
    bra.b   .l2ceee
.l2ced8:
    cmpi.w  #$2, d2
    bne.b   .l2cee2
    moveq   #$B,d2             ; 2 -> $B
    bra.b   .l2ceee
.l2cee2:
    cmpi.w  #$b, d2
    bne.b   .l2ceec
    moveq   #$3,d2             ; $B -> 3
    bra.b   .l2ceee
.l2ceec:
    addq.w  #$1, d2            ; normal increment
.l2ceee:
    ; Check if new slot is enabled
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF17E8,a0     ; slot availability flag table
    cmpi.w  #$1, (a0,d0.w)    ; slot enabled?
    bne.b   .l2cece            ; no: keep incrementing
    bra.b   .l2cea6            ; yes: refresh display

    ; --- Phase: Exit dispatch -- process slot selection result ---
.l2cf02:
    ; d2 >= $C means exit/cancel; exact value determines which exit action
    cmpi.w  #$c, d2            ; d2 >= $C?
    bcc.b   .l2cf44            ; yes: exit immediately (B-cancel or right-exit)
    ; d2 == $B: "find available slot" action (book next free slot for this player)
    cmpi.w  #$b, d2
    bne.b   .l2cf2e
    clr.l   -(a7)              ; arg: 0
    pea     ($0001).w          ; arg: mode 1
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)          ; arg: player_index
    jsr (FindAvailableSlot,PC) ; search for a free aircraft slot for this player
    nop
    lea     $c(a7), a7
    cmpi.w  #$10, d0           ; d0 < $10 means a slot was found
    bcs.b   .l2cf44            ; slot found: proceed to exit with d2 as result
    bra.w   .l2cd14            ; no slot found: restart outer loop
    ; d2 is a normal slot (0-$A): process crew salary assignment
.l2cf2e:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)          ; arg: player_index
    jsr (ProcessCrewSalary,PC) ; compute/apply crew salary for this player's slot
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0            ; d0 == 1 means "continue/success"
    bne.w   .l2cd14            ; failure: restart outer loop to re-select
    ; Fall through to exit
.l2cf44:
    ; --- Phase: Epilogue -- return selected slot index in d0 ---
    move.w  d2, d0             ; d0 = final slot index (return value)
    movem.l -$9c(a6), d2-d5/a2-a4
    unlk    a6
    rts
