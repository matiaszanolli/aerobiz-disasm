; ============================================================================
; CalcCompatScore -- Score character pair compatibility via CharCodeCompare tier table, apply type bonus, clamp to 30
; Called: 8 times.
; 206 bytes | $007412-$0074DF
; ============================================================================
CalcCompatScore:                                                  ; $007412
    movem.l d2-d3/a2,-(sp)
    movea.l $0010(sp),a2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    bsr.w CharCodeCompare
    move.w  d0,d2
    cmpi.w  #$3200,d2
    bls.b   .l7438
    moveq   #$1e,d3
    bra.b   .l7466
.l7438:                                                 ; $007438
    cmpi.w  #$1900,d2
    bls.b   .l7442
    moveq   #$23,d3
    bra.b   .l7466
.l7442:                                                 ; $007442
    cmpi.w  #$0c80,d2
    bls.b   .l744c
    moveq   #$32,d3
    bra.b   .l7466
.l744c:                                                 ; $00744C
    cmpi.w  #$0640,d2
    bls.b   .l7456
    moveq   #$64,d3
    bra.b   .l7466
.l7456:                                                 ; $007456
    cmpi.w  #$0320,d2
    bls.b   .l7462
    move.w  #$96,d3
    bra.b   .l7466
.l7462:                                                 ; $007462
    move.w  #$c8,d3
.l7466:                                                 ; $007466
    move.l  a2,-(sp)
    dc.w    $4eba,$0076                                 ; jsr $0074E0
    nop
    lea     $000c(sp),sp
    movea.l #$00ff1278,a0
    move.b  (a0,d0.w),d2
    andi.l  #$ff,d2
    cmpi.w  #$3,d2
    bcc.b   .l7492
    move.w  d3,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$3,d0
    bra.b   .l74be
.l7492:                                                 ; $007492
    cmpi.w  #$18,d2
    beq.b   .l74b6
    cmpi.w  #$19,d2
    beq.b   .l74b6
    cmpi.w  #$2f,d2
    beq.b   .l74b6
    cmpi.w  #$32,d2
    beq.b   .l74b6
    cmpi.w  #$33,d2
    beq.b   .l74b6
    cmpi.w  #$34,d2
    bne.b   .l74ca
.l74b6:                                                 ; $0074B6
    move.w  d3,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$4,d0
.l74be:                                                 ; $0074BE
    sub.l   d1,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
.l74ca:                                                 ; $0074CA
    cmpi.w  #$1e,d3
    ble.b   .l74d6
    move.w  d3,d0
    ext.l   d0
    bra.b   .l74d8
.l74d6:                                                 ; $0074D6
    moveq   #$1e,d0
.l74d8:                                                 ; $0074D8
    move.w  d0,d3
    movem.l (sp)+,d2-d3/a2
    rts
; ---------------------------------------------------------------------------
; GetByteField4 -- Extract high nibble from byte[2] of structure
; Args: $4(SP) = pointer to structure
; Returns: D0 = high nibble (bits 7-4) of byte at offset 2
; Called 36 times
; ---------------------------------------------------------------------------
GetByteField4:                                                 ; $0074E0
    MOVEA.L $4(SP),A0                                          ; load structure pointer
    MOVE.B  $2(A0),D1                                          ; get byte at offset 2
    ANDI.L  #$000000FF,D1                                      ; mask to unsigned byte
    ASR.L   #4,D1                                              ; shift right 4 (high nibble)
    ANDI.W  #$000F,D1                                          ; mask to 4 bits
    MOVE.W  D1,D0                                              ; return in D0
    RTS
