; ------------------------------------------------------------------------------

; [ transfer character menu text tiles to ppu ]

TfrCharText:
_c2ab8a:
@ab8a:  phb
        clr_a
        pha
        plb

; curr/max mp text
        lda     #$7e
        sta     hDMA7::ADDR_B
        ldx     #$6ab7
        stx     hVMADDL
        ldy     #7*2
        sty     hDMA7::SIZE
        ldx     #near w7e5d15
        stx     hDMA7::ADDR
        lda     #BIT_7
        sta     hMDMAEN

; mp cost
.if LANG_EN
        ldx     #$6af7
.else
        ldx     #$6b37
.endif
        stx     hVMADDL
        sty     hDMA7::SIZE
        ldx     #near w7e5d23
        stx     hDMA7::ADDR
        sta     hMDMAEN

; swdtech numerals
        lda     w7e7b81
        jeq     @ac4a
        longa
        lda     #$7a24
        sta     hVMADDL
        .repeat 8,i
        lda     w7e5dbd+i*2+$1c
        sta     hVMDATAL
        .endrep

; swdtech gauge
        lda     #$7a64
        sta     hVMADDL
        .repeat 8,i
        lda     w7e7a73+i*2
        sta     hVMDATAL
        .endrep
        shorta0
        sta     w7e7b81

; character ATB gauge
@ac4a:  lda     #$01
        sta     hDMA7::CTRL
        lda     #$18
        sta     hDMA7::HREG
        lda     #$7e
        sta     hDMA7::ADDR_B
        ldy     #$000c
        lda     w7e629b
        beq     @ac6e
        clr_a
        sta     w7e629b
        lda     z98
        lsr
        and     #%11
        bra     @ac75
@ac6e:  lda     w7e7b9a
        dec
        and     #%11
@ac75:  asl
        tax
        lda     #$80
        jmp     (near TfrCharGaugeTbl,x)

.enum TFR_CHAR_GAUGE
        COUNT = 4
.endenum

TfrCharGaugeTbl:
        ptr_tbl TFR_CHAR_GAUGE

; ------------------------------------------------------------------------------

; [ draw character 1 gauge ]

        array_label TFR_CHAR_GAUGE, 0
@ac84:  ldx     #$7839                  ; char 1 gauge (menu closed)
        stx     hVMADDL
        ldx     #$5c51
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$7939                  ; char 1 gauge (menu open)
        stx     hVMADDL
        ldx     #$5c51
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$7a39                  ; char 1 gauge (char select)
        stx     hVMADDL
        ldx     #$5c51
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        jmp     TfrCharHPText

; ------------------------------------------------------------------------------

; [  ]

        array_label TFR_CHAR_GAUGE, 1
@acbd:  ldx     #$7879
        stx     hVMADDL
        ldx     #$5c69
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$7979
        stx     hVMADDL
        ldx     #$5c69
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$7a79
        stx     hVMADDL
        ldx     #$5c69
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        jmp     TfrCharHPText

; ------------------------------------------------------------------------------

; [  ]

        array_label TFR_CHAR_GAUGE, 2
@acf6:  ldx     #$78b9
        stx     hVMADDL
        ldx     #$5c81
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$79b9
        stx     hVMADDL
        ldx     #$5c81
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$7ab9
        stx     hVMADDL
        ldx     #$5c81
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        jmp     TfrCharHPText

; ------------------------------------------------------------------------------

; [  ]

        array_label TFR_CHAR_GAUGE, 3
@ad2f:  ldx     #$78f9
        stx     hVMADDL
        ldx     #$5c99
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$79f9
        stx     hVMADDL
        ldx     #$5c99
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
        ldx     #$7af9
        stx     hVMADDL
        ldx     #$5c99
        stx     hDMA7::ADDR
        sty     hDMA7::SIZE
        sta     hMDMAEN
; fallthrough

; ------------------------------------------------------------------------------

; [ transfer character hp text tiles to vram ]

TfrCharHPText:
@ad65:  plb
        shorti
        lda     near w7e7b9c
        beq     @adb6
        stz     near w7e7b9c
        lda     near w7e7b9d
        cmp     #$ff
        beq     @adb6
        asl
        tax
        longa
        lda     f:CharHPTextBufOffsetTbl,x
        tay
        txa
        asl2
        tax
        lda     #3
        sta     $36
@ad89:  lda     f:CharHPTextVRAMTbl,x
        sta     f:hVMADDL
        .repeat 4, i
        lda     near w7e5c05+ 2 * i + 8,y
        sta     f:hVMDATAL
        .endrep
        inx2
        dec     $36
        bne     @ad89
        shorta0
@adb6:  longi
        rtl

; ------------------------------------------------------------------------------

; vram address for character hp text (menu close, menu open, char select)
CharHPTextVRAMTbl:
@adb9:  .word   $7835,$7935,$7a35,$0000
        .word   $7875,$7975,$7a75,$0000
        .word   $78b5,$79b5,$7ab5,$0000
        .word   $78f5,$79f5,$7af5,$0000

; text buffer offset for each character's hp text
CharHPTextBufOffsetTbl:
@add9:  .word   $0000,$0010,$0020,$0030

; ------------------------------------------------------------------------------

; status names (32 items, 10 bytes each)
StatusName:
        .incbin "assets/text/status_name.bin"

; ------------------------------------------------------------------------------
