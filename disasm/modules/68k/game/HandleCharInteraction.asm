; ============================================================================
; HandleCharInteraction -- Animates a tile wipe transition on the character panel: two modes (flag=1: left-to-right tile slide, flag=0: symmetric fold-out) using TilePlacement in loops with VBlank waits to produce smooth character-card reveal/hide effects
; 512 bytes | $02EFD2-$02F1D1
;
; Arg (no link frame -- leaf-style prologue with movem):
;   $20(a7) = mode flag (after movem saves d2-d6/a2-a3 = 7 regs = $1C, +$4 return addr = $20)
;             1 = left-to-right slide reveal (3-phase)
;             0 = symmetric fold-out (3-phase)
;
; Registers set up in prologue:
;   a2 = $D64   (GameCommand function pointer)
;   a3 = $1E044 (TilePlacement function pointer)
;   d6 = $750   (tile attribute word passed to TilePlacement on every call)
;   d2 = phase-A column advance counter (starts 0, steps by 6)
;   d3 = phase-B column advance counter (starts 0, steps by 6)
;
; Mode 1 (flag=1) -- left-to-right slide:
;   Calls LoadDisplaySet #4. d4=$30 (tile base), d5=$A8 (fixed Y position).
;   Phase A: d2 steps 0->$28 (step=6, limit=$28). Reveals left half.
;     TilePlacement X = d4+d2 (sweeps right from $30 to $58).
;   Phase B: d2 and d3 both advance 0->$48 simultaneously. Fills remainder.
;     X = d4+d2, secondary X = d5-d3.
;   Phase C: d2 resets to 0, steps 0->$20 (step=6, limit=$20). Final right edge.
;
; Mode 0 (flag!=1) -- symmetric fold-out:
;   Calls LoadDisplaySet #5. d4=$C0 (tile base), d5=$60 (starting Y).
;   Phase A: d2 steps 0->$18 (step=6, limit=$18). Top wing folds in.
;     X = d4-d2 (sweeps left from $C0 toward $A8).
;   Phase B: d2 and d3 both advance 0->$48. Symmetric fill.
;     X = d4-d2, secondary Y = d5+d3.
;   Phase C: d2 resets, steps 0->$30 (step=6, limit=$30). Bottom wing folds.
;
; TilePlacement args (pushed right-to-left):
;   tile_attr, width=2, height=2, X, Y, tile_idx=$F, 0
; After each TilePlacement: GameCommand #$E = WaitVBlank (one frame sync).
; Final call: GameCommand #$18 = display commit/flush.
; ============================================================================
HandleCharInteraction:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d4                             ; d4 = mode flag (1 or 0)
    movea.l  #$00000D64,a2                          ; a2 = GameCommand function pointer
    movea.l  #$0001E044,a3                          ; a3 = TilePlacement function pointer
    clr.w   d2                                      ; d2 = phase-A counter
    clr.w   d3                                      ; d3 = phase-B counter
    move.w  #$750, d6                               ; d6 = tile attribute word ($750)
    cmpi.w  #$1, d4                                 ; mode == 1?
    bne.w   .l2f0dc                                 ; no -> fold-out mode
    ; =========================================================================
    ; MODE 1: Left-to-right slide reveal
    ; =========================================================================
    moveq   #$30,d4                                 ; d4 = tile base X = $30
    move.w  #$a8, d5                                ; d5 = fixed Y = $A8
    pea     ($0004).w                               ; LoadDisplaySet #4
    jsr LoadDisplaySet                              ; load display set 4 (character card tiles)
    addq.l  #$4, a7
    bra.b   .l2f042                                 ; enter phase-A at condition check
.l2f00a:
    ; --- Phase A loop body: reveal left side, X sweeps right ---
    clr.l   -(a7)                                   ; TilePlacement arg: extra = 0
    pea     ($0002).w                               ; height = 2
    pea     ($0002).w                               ; width = 2
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; Y = d5 (fixed $A8)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; X = d4 + d2 (slides right)
    pea     ($000F).w                               ; tile index = $F
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; tile attribute word
    jsr     (a3)                                    ; TilePlacement
    pea     ($0001).w
    pea     ($000E).w                               ; GameCommand #$E = WaitVBlank
    jsr     (a2)
    lea     $24(a7), a7                             ; pop 9 longwords total
    addq.w  #$6, d2                                 ; d2 += 6 (step)
.l2f042:
    cmpi.w  #$28, d2                                ; d2 < $28?
    blt.b   .l2f00a                                 ; yes -> continue phase A
    bra.b   .l2f08a                                 ; phase A done -> phase B condition
.l2f04a:
    ; --- Phase B loop body: both counters advance, fills remaining left+right ---
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)                               ; Y = d5 - d3 (moves up)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; X = d4 + d2
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)                                    ; TilePlacement
    pea     ($0001).w
    pea     ($000E).w                               ; WaitVBlank
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    addq.w  #$6, d3                                 ; d3 also steps in phase B
.l2f08a:
    cmpi.w  #$48, d3                                ; d3 < $48?
    blt.b   .l2f04a                                 ; yes -> continue phase B
    add.w   d2, d4                                  ; advance tile base by d2
    clr.w   d2                                      ; reset d2 for phase C
.l2f094:
    ; --- Phase C loop body: final right-edge sweep ---
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)                               ; Y = d5 - d3 (stays fixed after phase B)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; X = updated d4 + d2
    pea     ($000F).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)                                    ; TilePlacement
    pea     ($0001).w
    pea     ($000E).w                               ; WaitVBlank
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    cmpi.w  #$20, d2                                ; d2 < $20?
    blt.b   .l2f094                                 ; yes -> continue phase C
    bra.w   .l2f1c4                                 ; done -> commit
    ; =========================================================================
    ; MODE 0: Symmetric fold-out
    ; =========================================================================
.l2f0dc:
    move.w  #$c0, d4                                ; d4 = tile base X = $C0
    moveq   #$60,d5                                 ; d5 = starting Y = $60
    pea     ($0005).w                               ; LoadDisplaySet #5
    jsr LoadDisplaySet                              ; load display set 5 (fold-out tiles)
    addq.l  #$4, a7
    bra.b   .l2f12e                                 ; enter phase-A at condition check
.l2f0f0:
    ; --- Phase A loop body: top wing folds inward (X sweeps left) ---
    ; $0800 = palette/priority variant of tile attribute
    pea     ($0800).w                               ; tile attribute variant $0800
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; Y = d5 + d3
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)                               ; X = d4 - d2 (sweeps left from $C0)
    clr.l   -(a7)                                   ; tile index = 0
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; tile attr $750
    jsr     (a3)                                    ; TilePlacement
    pea     ($0001).w
    pea     ($000E).w                               ; WaitVBlank
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
.l2f12e:
    cmpi.w  #$18, d2                                ; d2 < $18?
    blt.b   .l2f0f0                                 ; yes -> continue phase A
    bra.b   .l2f176                                 ; phase A done -> phase B
.l2f136:
    ; --- Phase B loop body: symmetric fill, both X and Y sweep ---
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; Y = d5 + d3 (increases)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)                               ; X = d4 - d2 (decreases)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)                                    ; TilePlacement
    pea     ($0001).w
    pea     ($000E).w                               ; WaitVBlank
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    addq.w  #$6, d3                                 ; d3 advances in phase B
.l2f176:
    cmpi.w  #$48, d3                                ; d3 < $48?
    blt.b   .l2f136                                 ; yes -> continue phase B
    sub.w   d2, d4                                  ; contract tile base by d2
    clr.w   d2                                      ; reset d2 for phase C
.l2f180:
    ; --- Phase C loop body: bottom wing completes fold ---
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)                               ; Y = d5 + d3 (still from phase B state)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)                               ; X = contracted d4 - d2
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)                                    ; TilePlacement
    pea     ($0001).w
    pea     ($000E).w                               ; WaitVBlank
    jsr     (a2)
    lea     $24(a7), a7
    addq.w  #$6, d2
    cmpi.w  #$30, d2                                ; d2 < $30?
    blt.b   .l2f180                                 ; yes -> continue phase C
.l2f1c4:
    ; --- Phase: Commit display changes ---
    pea     ($0018).w                               ; GameCommand #$18 = display flush/commit
    jsr     (a2)
    addq.l  #$4, a7
    movem.l (a7)+, d2-d6/a2-a3
    rts
