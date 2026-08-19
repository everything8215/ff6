; ------------------------------------------------------------------------------

; [ save character cursor positions ]

SaveCursorMem:
        ldx     #$0280
        stx     $10
        ldx     #near w7e890f
        stx     $14
@b617:  jsr     SetCursorMemChecksum
        jsr     SaveCharCursorMem
        ldx     $10
        inx
        stx     $10
        ldx     $14
        inx
        stx     $14
        cpx     #near w7e8913
        bne     @b617
        rtl

; ------------------------------------------------------------------------------

; [  ]

SetCursorMemChecksum:
        clr_ay
@b62f:  clc
        adc     ($14),y
        iny4
        cpy     #$0060
        bne     @b62f
        neg_a
        sta     ($10),y
        rts

; ------------------------------------------------------------------------------

; [  ]

SaveCharCursorMem:
        ldy     #$0000
@b644:  lda     ($14),y
        sta     ($10),y
        iny4
        cpy     #$0060
        bne     @b644
        rts

; ------------------------------------------------------------------------------

; [ init saved cursor positions ]

LoadCursorMem:
        lda     near wCharGfxDataBuf::CharID
        sta     near w7e896b
        lda     $2ee6
        sta     near w7e896b+1
        lda     $2f06
        sta     near w7e896b+2
        lda     $2f26
        sta     near w7e896b+3
        ldx     #$0280
        stx     $10
        ldx     #near w7e890f
        stx     $14
@b674:  jsr     CheckCursorMemChecksum
        bcc     @b67c                   ; branch if checksum is valid
        jsr     ClearCharCursorMem
@b67c:  ldx     $10
        inx
        stx     $10
        ldx     $14
        inx
        stx     $14
        cpx     #near w7e890f + 4
        bne     @b674
        clr_ax
@b68d:  lda     near w7e896b,x
        jsr     LoadCharCursorMem
        inx
        cpx     #4
        bne     @b68d
        rtl

; ------------------------------------------------------------------------------

; [  ]

; A: character id

LoadCharCursorMem:
        phx
        sta     $18
        clr_ay
@b69f:  lda     $02dc,y
        cmp     $18
        beq     @b6ae
        iny
        cpy     #4
        bne     @b69f
        bra     @b6c4
@b6ae:  lda     #$17
        sta     $1a
@b6b2:  lda     $0280,y
        sta     near w7e890f,x
        iny4
        inx4
        dec     $1a
        bne     @b6b2
@b6c4:  plx
        rts

; ------------------------------------------------------------------------------

; [ clear saved cursor positions for one character ]

ClearCharCursorMem:
        clr_ay
@b6c8:  sta     ($10),y
        iny4
        cpy     #$005c
        bne     @b6c8
        lda     #$ff
        sta     ($10),y
        iny4
        sta     ($10),y
        rts

; ------------------------------------------------------------------------------

; [ check if saved cursor position data is valid ]

CheckCursorMemChecksum:
        clr_ay
@b6e0:  clc
        adc     ($10),y
        iny4
        cpy     #$0060
        bne     @b6e0
        neg_a
        cmp     ($10),y
        beq     @b6f5
        sec
        rts
@b6f5:  clc
        rts

; ------------------------------------------------------------------------------
