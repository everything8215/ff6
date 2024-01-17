; ------------------------------------------------------------------------------

; [ decompress ]

; ++$d2 = source
; ++$d5 = destination

Decompress:
@a476:  phb
        phd
        ldx     #$0000
        phx
        pld
        longa
        lda     [$d2]
        sta     $db
        lda     $d5
        sta     f:hWMADDL
        shorta
        lda     $d7
        and     #$01
        sta     f:hWMADDH
        lda     #1
        sta     $dd
        ldy     #2
        lda     #$7e
        pha
        plb
        ldx     #$f800
        tdc
@a4a2:  sta     a:0,x
        inx
        bne     @a4a2
        ldx     #$ffde
@a4ab:  dec     $dd
        bne     @a4b8
        lda     #8
        sta     $dd
        lda     [$d2],y
        sta     $de
        iny
@a4b8:  lsr     $de
        bcc     @a4cd
        lda     [$d2],y
        sta     f:hWMDATA
        sta     a:0,x
        inx
        bne     @a4ff
        ldx     #$f800
        bra     @a4ff
@a4cd:  lda     [$d2],y
        xba
        iny
        sty     $d8
        lda     [$d2],y
        lsr3
        clc
        adc     #$03
        sta     $da
        lda     [$d2],y
        ora     #$f8
        xba
        tay
@a4e3:  lda     a:0,y
        sta     f:hWMDATA
        sta     a:0,x
        inx
        bne     @a4f3
        ldx     #$f800
@a4f3:  iny
        bne     @a4f9
        ldy     #$f800
@a4f9:  dec     $da
        bne     @a4e3
        ldy     $d8
@a4ff:  iny
        cpy     $db
        bne     @a4ab
        tdc
        xba
        pld
        plb
        rts

; ------------------------------------------------------------------------------
