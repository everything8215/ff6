; ------------------------------------------------------------------------------

; [ multiply a * b ]

MultAB:
@4781:  php
        longa
        sta     f:hWRMPYA
        nop4
        lda     f:hRDMPYL
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ divide +a / x ]

; +A: result
;  X: remainder

Div:
@4792:  phy
        php
        longa
        sta     f:hWRDIVL
        shortai
        txa
        sta     f:hWRDIVB
        nop8
        lda     f:hRDMPYL
        tax
        longa
        lda     f:hRDDIVL
        plp
        ply
        rts

; ------------------------------------------------------------------------------

; [ +a *= $e8 / 256 ]

; ++$e8 = +a * $e8

Mult24:
@47b7:  php
        shorta
        stz     $ea
        sta     $e9
        lda     $e8
        jsr     MultAB
        longa_clc
        sta     $ec
        lda     $e8
        jsr     MultAB
        sta     $e8
        lda     $ec
        adc     $e9
        sta     $e9
        plp
        .a8
        rts

; ------------------------------------------------------------------------------

; [ a *= 1.5 ]

AddHalf:
@47d6:  pha
        lsr
        clc
        adc     1,s
        bcc     @47df
        lda     #$ff
@47df:  sta     1,s
        pla
        rts

; ------------------------------------------------------------------------------
