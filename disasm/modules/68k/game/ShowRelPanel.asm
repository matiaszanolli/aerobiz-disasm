; ============================================================================
; ShowRelPanel -- Display character relationship/affinity panel
; Called: 40 times.
; Args: $0a(a6)=player_index (l), $0e(a6)=char_index (l)
; Regs: D2-D5/A0-A5 saved. A2=result buf (A6-$C4). A5=player rec ($FF0018+p*36).
; char<7: 2 loops over char record data; char>=7: 32-entry acquaintance scan.
; ============================================================================
ShowRelPanel:                                                ; $006B78
    link    a6,#-$c4
    movem.l d2-d7/a2-a5,-(sp)
    move.w  $000a(a6),d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$1f,d7
    move.w  #$0660,d6
    pea     ($0030).w
    pea     ($0007).w
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
    lea     $000c(sp),sp
    lea     -$c4(a6),a2
    cmpi.w  #$7,$000e(a6)
    bge.w   .alt_path
    move.w  $000e(a6),d0
    lsl.w   #2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    move.l  a0,-$4(a6)
    move.b  (a0),d3
    andi.l  #$ff,d3
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02fe                  ; jsr BitFieldSearch (PC-rel)
    nop
    addq.l  #8,sp
    move.w  d0,d4
    movea.l -$4(a6),a0
    move.b  (a0),d0
    andi.l  #$ff,d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    movea.l -$4(a6),a0
    move.b  $1(a0),d5
    andi.l  #$ff,d5
    bra.w   .loop1_check
.loop1_body:                             ; $006C20
    move.w  d3,d0
    ext.l   d0
    moveq   #0,d1
    move.b  $1(a5),d1
    cmp.l   d1,d0
    bne.b   .l1_b
    move.w  #$0760,d2
    bra.b   .l1_commit
.l1_b:                                   ; $006C34
    cmp.w   d4,d3
    bne.b   .l1_c
    move.w  #$0761,d2
    bra.b   .l1_commit
.l1_c:                                   ; $006C3E
    move.w  d3,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  $000a(a6),d1
    lsl.w   #2,d1
    movea.l #$00ffa6a0,a0
    and.l   (a0,d1.w),d0
    beq.b   .l1_d
    move.w  #$0762,d2
    bra.b   .l1_commit
.l1_d:                                   ; $006C60
    move.w  #$0763,d2
.l1_commit:                              ; $006C64
    moveq   #0,d0
    move.b  $1(a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    clr.w   (a2)+
    move.w  d2,(a2)+
    moveq   #0,d0
    move.b  (a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    move.w  d3,d0
    lsl.w   #3,d0
    move.w  $000a(a6),d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba80,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #0,d0
    move.b  (a4),d0
    moveq   #0,d1
    move.b  $1(a4),d1
    sub.w   d1,d0
    move.w  d0,d2
    ble.b   .l1_nobar
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  $1(a3),d0
    addq.l  #8,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  (a3),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dfbe            ; jsr $1DFBE
    lea     $0014(sp),sp
    addq.w  #1,d6
.l1_nobar:                               ; $006CD4
    addq.w  #1,d7
    addq.l  #2,a3
    subq.w  #1,d5
    addq.w  #1,d3
.loop1_check:                            ; $006CDC
    tst.w   d5
    bgt.w   .loop1_body
    movea.l -$4(a6),a0
    move.b  $2(a0),d0
    andi.l  #$ff,d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    movea.l -$4(a6),a0
    move.b  $2(a0),d3
    andi.l  #$ff,d3
    movea.l -$4(a6),a0
    move.b  $3(a0),d5
    andi.l  #$ff,d5
    clr.w   d4
    bra.w   .loop2_check
.loop2_body:                             ; $006D20
    move.w  d4,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  $000a(a6),d1
    mulu.w  #$000e,d1
    movea.l d7,a0
    move.w  $000e(a6),d7
    add.w   d7,d7
    exg     d7,a0
    add.w   a0,d1
    movea.l #$00ffbd6c,a0
    move.w  (a0,d1.w),d1
    andi.l  #$ffff,d1
    and.l   d1,d0
    beq.b   .l2_b
    move.w  #$0764,d2
    bra.b   .l2_commit
.l2_b:                                   ; $006D58
    move.w  #$0765,d2
.l2_commit:                              ; $006D5C
    moveq   #0,d0
    move.b  $1(a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    clr.w   (a2)+
    move.w  d2,(a2)+
    moveq   #0,d0
    move.b  (a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    move.w  d3,d0
    lsl.w   #3,d0
    move.w  $000a(a6),d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba80,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #0,d0
    move.b  (a4),d0
    moveq   #0,d1
    move.b  $1(a4),d1
    sub.w   d1,d0
    move.w  d0,d2
    ble.b   .l2_nobar
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  $1(a3),d0
    addq.l  #8,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  (a3),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dfbe            ; jsr $1DFBE
    pea     ($0002).w
    pea     ($000e).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
    lea     $001c(sp),sp
    addq.w  #1,d6
.l2_nobar:                               ; $006DDA
    addq.w  #1,d7
    addq.l  #2,a3
    subq.w  #1,d5
    addq.w  #1,d3
    addq.w  #1,d4
.loop2_check:                            ; $006DE4
    tst.w   d5
    bgt.w   .loop2_body
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$c4(a6)
    movea.l -$4(a6),a0
    move.b  $1(a0),d0
    andi.l  #$ff,d0
    movea.l -$4(a6),a0
    move.b  $3(a0),d1
    andi.l  #$ff,d1
    add.w   d1,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    pea     ($000f).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9e1c            ; jsr $9E1C
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$03e0                  ; jsr $722A (PC-rel)
    nop
    lea     $0028(sp),sp
    bra.w   .exit
.alt_path:                               ; $006E56
    movea.l #$0005e948,a3
    clr.w   d4
    clr.w   d3
    bra.b   .alt_check
.alt_body:                               ; $006E62
    moveq   #0,d0
    move.b  $1(a5),d0
    cmp.w   d4,d0
    bne.b   .alt_b
    move.w  #$0760,d2
    bra.b   .alt_commit
.alt_b:                                  ; $006E72
    move.w  d4,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  $000a(a6),d1
    lsl.w   #2,d1
    movea.l #$00ff08ec,a0
    and.l   (a0,d1.w),d0
    beq.b   .alt_c
    move.w  #$0761,d2
    bra.b   .alt_commit
.alt_c:                                  ; $006E94
    clr.w   d2
.alt_commit:                             ; $006E96
    tst.w   d2
    beq.b   .alt_skip
    moveq   #0,d0
    move.b  $1(a3),d0
    addi.w  #$007c,d0
    move.w  d0,(a2)+
    clr.w   (a2)+
    moveq   #0,d0
    move.w  d2,d0
    move.w  d0,(a2)+
    moveq   #0,d0
    move.b  (a3),d0
    addi.w  #$007c,d0
    move.w  d0,(a2)+
    addq.w  #1,d3
.alt_skip:                               ; $006EBA
    addq.l  #2,a3
    addq.w  #1,d4
.alt_check:                              ; $006EBE
    cmpi.w  #$20,d4
    blt.b   .alt_body
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$c4(a6)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    pea     ($000f).w
    dc.w    $4eb9,$0000,$0d64            ; jsr GameCommand
.exit:                                   ; $006EE0
    movem.l -$ec(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ---------------------------------------------------------------------------
; BitFieldSearch -- Search bitfield in RAM for a set bit
; Args: $C(SP) = entity index (long), $12(SP) = table index (word)
; Returns: D0 = bit position if found, $FF if not
; Uses ROM table at $5ECBC (byte[0]=start bit, byte[1]=count)
; and RAM table at $FF08EC (longwords indexed by entity)
; Called 47 times
; ---------------------------------------------------------------------------
BitFieldSearch:                                                ; $006EEA
    MOVEM.L D2-D3,-(SP)
    MOVE.L  $C(SP),D1                                          ; entity index
    MOVE.W  $12(SP),D0                                         ; table index
    LSL.W   #2,D0                                              ; * 4 (entry size)
    MOVEA.L #$0005ECBC,A0                                      ; ROM lookup table
    LEA     0(A0,D0.W),A0                                      ; point to entry
    MOVEA.L A0,A1                                              ; A1 = entry pointer
    MOVEQ   #0,D0
    MOVE.B  (A1),D0                                            ; start bit position
    MOVEQ   #1,D3
    LSL.L   D0,D3                                              ; D3 = 1 << start_bit (mask)
    CLR.W   D2                                                 ; counter = 0
    BRA.S   .bfs_check
.bfs_loop:                                                     ; $006F10
    MOVE.W  D1,D0
    LSL.W   #2,D0                                              ; entity * 4
    MOVEA.L #$00FF08EC,A0                                      ; RAM bitfield table
    MOVE.L  0(A0,D0.W),D0                                      ; load entity bits
    AND.L   D3,D0                                              ; test current bit
    BEQ.S   .bfs_next                                          ; not set, continue
    MOVEQ   #0,D0
    MOVE.B  (A1),D0                                            ; start bit
    ADD.W   D2,D0                                              ; + offset = actual position
    BRA.S   .bfs_exit                                          ; found
.bfs_next:                                                     ; $006F2A
    ADD.L   D3,D3                                              ; shift mask left by 1
    ADDQ.W  #1,D2                                              ; counter++
.bfs_check:                                                    ; $006F2E
    MOVEQ   #0,D0
    MOVE.B  $1(A1),D0                                          ; bit count limit
    CMP.W   D2,D0                                              ; limit > counter?
    BGT.S   .bfs_loop                                          ; continue searching
    MOVE.W  #$00FF,D0                                          ; not found sentinel
.bfs_exit:                                                     ; $006F3C
    MOVEM.L (SP)+,D2-D3
    RTS
