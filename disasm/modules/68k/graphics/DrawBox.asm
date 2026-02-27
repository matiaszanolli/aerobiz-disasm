; ============================================================================
; DrawBox -- Draw a bordered dialog box with corner, edge, and fill tiles
; Called: 42 times.
; Args (stack, link -4): $08(A6)=x (l), $0C(A6)=y (l), $10(A6)=width (l), $14(A6)=height (l)
; Sets win_left/top/right/bottom. A2=GameCommand, A3/A4=&local_tile, A5=&win_bottom
; Tile sequence: $8527=TL, $8528=BL, $8529=TR, $852A=BR, $852B/C=L/R edge, $852D/E=T/B edge
; ============================================================================
DrawBox:                                                     ; $005A04
    link    a6,#-4
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0008(a6),d2                    ; D2 = x (col)
    move.l  $0010(a6),d3                    ; D3 = width
    move.l  $000C(a6),d4                    ; D4 = y (row)
    move.l  $0014(a6),d5                    ; D5 = height
    movea.l #$00000D64,a2                   ; A2 = GameCommand
    lea     -$2(a6),a3                      ; A3 = &local_tile word (A6-2)
    lea     -$2(a6),a4                      ; A4 = same (tile ptr arg to GameCommand)
    movea.l #$00FFBD48,a5                   ; A5 = &win_bottom
    ; Set text window boundary variables
    move.w  d2,d0
    addq.w  #1,d0
    move.w  d0,($00FFBD68).l               ; win_left = x+1
    move.w  d4,d0
    addq.w  #1,d0
    move.w  d0,($00FFB9E4).l               ; win_top = y+1
    move.w  d2,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    subq.l  #2,d0                          ; D0 = x+width-2 = win_right
    move.l  d0,d6                          ; D6 = win_right (save)
    move.w  d0,($00FFBDA8).l              ; win_right = x+width-2
    move.w  d4,d0
    add.w   d5,d0
    addi.w  #$FFFE,d0                      ; D0 = y+height-2 = win_bottom
    move.w  d0,(a5)                        ; win_bottom
    move.w  d2,d0
    addq.w  #1,d0
    move.w  d0,($00FF1290).l
    move.w  d6,($00FF1000).l
    ; Cursor setup helpers: x+1 and y+1
    move.w  d2,d0
    ext.l   d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    jsr SetCursorX
    move.w  d4,d0
    ext.l   d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    jsr SetCursorY
    addq.l  #8,a7                         ; clean 2 args
    ; Bounds check: exit if window is degenerate
    move.w  ($00FFBD68).l,d0
    cmp.w   ($00FFBDA8).l,d0
    bcc.w   .exit                         ; win_left >= win_right
    move.w  ($00FFB9E4).l,d0
    cmp.w   (a5),d0
    bcc.w   .exit                         ; win_top >= win_bottom
    ; Fill interior: GameCommand(#$1A, 0, win_left, win_top, width-2, height-2, $8000)
    move.l  #$00008000,-(sp)
    move.w  d5,d0
    ext.l   d0
    subq.l  #2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    subq.l  #2,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFB9E4).l,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBD68).l,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; --- Draw 4 corners ---
    move.w  #$8527,(a3)                   ; local_tile = $8527 (TL corner)
    ; Top-left corner at (x, y)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,(a3)                       ; tile = $8528 (BL corner)
    ; Bottom-left corner at (x, win_bottom+1)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  (a5),d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,(a3)                       ; tile = $8529 (TR corner)
    ; Top-right corner at (win_right+1, y)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBDA8).l,d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,(a3)                       ; tile = $852A (BR corner)
    ; Bottom-right corner at (win_right+1, win_bottom+1)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  (a5),d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBDA8).l,d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; --- Row loop: draw left/right edges (tile $852B/$852C) ---
    move.w  d4,d3                          ; D3 = y (row counter)
    addq.w  #1,d3                          ; D3 = y+1 (first interior row)
    addq.w  #1,(a3)                        ; tile = $852B (left edge)
    bra.s   .row_check
.row_body:                                 ; $005B8C
    ; Left edge at (x, D3)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; Right edge at (win_right+1, D3) with tile+1 in -4(a6)
    move.w  (a3),d0
    addq.w  #1,d0
    move.w  d0,-$4(a6)
    pea     -$4(a6)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  ($00FFBDA8).l,d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,d3
.row_check:                                ; $005BE2
    moveq   #0,d0
    move.w  d3,d0
    moveq   #0,d1
    move.w  (a5),d1
    addq.l  #1,d1
    cmp.l   d1,d0
    blt.s   .row_body
    ; --- Column loop: draw top/bottom edges (tile $852D/$852E) ---
    addq.w  #1,d2
    addq.w  #2,(a3)                        ; tile = $852D (top edge)
    bra.s   .col_check
.col_body:                                 ; $005BF6
    ; Top edge at (D2, y)
    move.l  a4,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    ; Bottom edge at (D2, win_bottom+1) with tile+1 in -4(a6)
    move.w  (a3),d0
    addq.w  #1,d0
    move.w  d0,-$4(a6)
    pea     -$4(a6)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #0,d0
    move.w  (a5),d0
    addq.l  #1,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    lea     $001C(sp),sp
    addq.w  #1,d2
.col_check:                                ; $005C48
    moveq   #0,d0
    move.w  d2,d0
    moveq   #0,d1
    move.w  ($00FFBDA8).l,d1
    addq.l  #1,d1
    cmp.l   d1,d0
    blt.s   .col_body
.exit:                                     ; $005C5A
    movem.l -$28(a6),d2-d6/a2-a5
    unlk    a6
    rts
