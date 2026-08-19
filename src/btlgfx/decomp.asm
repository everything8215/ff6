; ------------------------------------------------------------------------------

; [ decompress ]

Decompress_ext:
@ff6d:  phb
        phd
        ldx     #BTLGFX_ZP_START
        phx
        pld
        longa
        lda     [$f3]
        sta     $fc
        lda     $f6
        sta     f:hWMADDL
        shorta
        lda     $f8
        and     #%1
        sta     f:hWMADDH
        lda     #1
        sta     $fe
        ldy     #2
        lda     #$7f
        pha
        plb
        ldx     #$f800
        clr_a
@ff99:  sta     a:$0000,x
        inx
        bne     @ff99
        ldx     #$ffde
@ffa2:  dec     $fe
        bne     @ffaf
        lda     #8
        sta     $fe
        lda     [$f3],y
        sta     $ff
        iny
@ffaf:  lsr     $ff
        bcc     @ffc4
        lda     [$f3],y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @fff6
        ldx     #$f800
        bra     @fff6
@ffc4:  lda     [$f3],y
        xba
        iny
        sty     $f9
        lda     [$f3],y
        lsr3
        clc
        adc     #3
        sta     $fb
        lda     [$f3],y
        ora     #$f8
        xba
        tay
@ffda:  lda     $0000,y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @ffea
        ldx     #$f800
@ffea:  iny
        bne     @fff0
        ldy     #$f800
@fff0:  dec     $fb
        bne     @ffda
        ldy     $f9
@fff6:  iny
        cpy     $fc
        bne     @ffa2
        clr_a
        xba
        pld
        plb
        rtl

; ------------------------------------------------------------------------------
