.import RNGTbl

; ------------------------------------------------------------------------------

; [ random number (carry) ]

RandCarry:
@4b53:  pha
        jsr     Rand
        lsr
        pla
        rts

; ------------------------------------------------------------------------------

; [ random number (0..255) ]

Rand:
@4b5a:  phx
        inc     zbe
        ldx     zbe
        lda     f:RNGTbl,x
        plx
        rts

; ------------------------------------------------------------------------------

; [ random number (0..A-1) ]

RandA:
@4b65:  phx
        php
        shortai
        xba
        pha
        inc     zbe
        ldx     zbe
        lda     f:RNGTbl,x
        jsr     MultAB
        pla
        xba
        plp
        plx
        rts

; ------------------------------------------------------------------------------
