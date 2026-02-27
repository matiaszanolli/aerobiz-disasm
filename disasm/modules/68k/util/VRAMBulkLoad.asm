; ============================================================================
; VRAMBulkLoad -- Transfer tile data to VRAM in chunks via GameCommand (46 calls)
; Chunks large transfers into $80-unit pieces, each $800 bytes via DMA command.
; Args: $A(a6).w = tile base, $C(a6).l = count, $10(a6).l = source ptr
; ============================================================================
VRAMBulkLoad:                                                ; $01D568
    link    a6,#$0000
    movem.l d2-d3/a2-a3,-(sp)
    move.l  $000C(a6),d2                                     ; d2 = transfer count
    movea.l $0010(a6),a2                                     ; a2 = source pointer
    movea.l #$00000D64,a3                                    ; a3 = GameCommand
    move.w  $000A(a6),d3                                     ; d3 = tile base
    lsl.w   #5,d3                                            ; tile# -> VRAM offset (*32)
    cmpi.w  #$0200,d2                                        ; count >= $200?
    blt.s   .small                                           ; no, single transfer
    bra.s   .chunk_test                                      ; enter chunked loop
.chunk_loop:                                                 ; $01D58C
    clr.l   -(sp)                                            ; flags = 0
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)                                         ; VRAM offset
    move.l  a2,-(sp)                                         ; source address
    pea     ($0800).w                                        ; chunk size ($800 bytes)
    pea     ($0002).w                                        ; sub: VRAM
    pea     ($0005).w                                        ; cmd: DMA transfer
    jsr     (a3)                                             ; GameCommand(5,2,$800,src,ofs,0)
    pea     ($0004).w                                        ; wait count
    pea     ($000E).w                                        ; cmd: wait/sync
    jsr     (a3)                                             ; GameCommand($E,4)
    lea     $20(sp),sp                                       ; clean 32 bytes
    addi.w  #$1000,d3                                        ; next VRAM chunk offset
    lea     $1000(a2),a2                                     ; next source chunk
    subi.w  #$0080,d2                                        ; count -= $80
.chunk_test:                                                 ; $01D5BE
    cmpi.w  #$0080,d2                                        ; count > $80?
    bgt.s   .chunk_loop                                      ; yes, keep chunking
    tst.w   d2                                               ; any remainder?
    ble.s   .done                                            ; no, finished
    clr.l   -(sp)                                            ; flags = 0
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)                                         ; VRAM offset
    move.l  a2,-(sp)                                         ; source address
    move.w  d2,d0
    ext.l   d0
    lsl.l   #4,d0                                            ; remainder * 16
    move.l  d0,-(sp)                                         ; byte count
    pea     ($0002).w                                        ; sub: VRAM
    pea     ($0005).w                                        ; cmd: DMA transfer
    jsr     (a3)                                             ; GameCommand(5,2,rem*16,src,ofs,0)
    lea     $18(sp),sp                                       ; clean 24 bytes
    pea     ($0002).w                                        ; wait count
    bra.s   .tail                                            ; -> common tail
.small:                                                      ; $01D5EE
    clr.l   -(sp)                                            ; flags = 0
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)                                         ; VRAM offset
    move.l  a2,-(sp)                                         ; source address
    move.w  d2,d0
    ext.l   d0
    lsl.l   #4,d0                                            ; count * 16
    move.l  d0,-(sp)                                         ; byte count
    pea     ($0002).w                                        ; sub: VRAM
    pea     ($0005).w                                        ; cmd: DMA transfer
    jsr     (a3)                                             ; GameCommand(5,2,cnt*16,src,ofs,0)
    lea     $18(sp),sp                                       ; clean 24 bytes
    move.w  d2,d0
    ext.l   d0
    moveq   #$64,d1                                          ; divisor = 100
    jsr SignedDiv
    move.l  d0,-(sp)                                         ; push count/100
.tail:                                                       ; $01D61C
    pea     ($000E).w                                        ; cmd: wait/sync
    jsr     (a3)                                             ; GameCommand($E,<n>)
.done:                                                       ; $01D622
    movem.l -$10(a6),d2-d3/a2-a3
    unlk    a6
    rts
