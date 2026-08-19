; ------------------------------------------------------------------------------

; [ update random number ]

Rand:
@185b:  phx
        lda     z72
        tax
        inc     z72
        lda     f:RNGTbl,x
        plx
        rts

; ------------------------------------------------------------------------------

; [ ++$30 = +$2e * $2c ]

; same as Mult816, but meant to be used during NMI

Mult816NoHW:
@1867:  stz     $30
        stz     $32
        stz     $34
        ldx     #8
@1870:  lsr     $2c
        bcc     @1881
        lda     $30
        clc
        adc     $2e
        sta     $30
        lda     $32
        adc     $34
        sta     $32
@1881:  asl     $2e
        rol     $34
        dex
        bne     @1870
        rts

; ------------------------------------------------------------------------------

; [ +++$30 = +$2e * +$2c ]

; unused, same effect as Mult16 but without using hardware registers

Mult16NoHW:
@1889:  longa
        stz     $30
        stz     $32
        stz     $34
        ldx     #16
@1894:  lsr     $2c
        bcc     @18a5
        lda     $30
        clc
        adc     $2e
        sta     $30
        lda     $32
        adc     $34
        sta     $32
@18a5:  asl     $2e
        rol     $34
        dex
        bne     @1894
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ +$30 = $2e * $2c ]

; same effect as Mult8, but without using hardware registers

Mult8NoHW:
@18b0:  ldx     zZero
        stx     $30
        ldx     #8
@18b7:  ror     $2e
        bcc     @18c2
        lda     $2c
        clc
        adc     $31
        sta     $31
@18c2:  ror     $31
        ror     $30
        dex
        bne     @18b7
        rts

; ------------------------------------------------------------------------------

; [ +$4216 = A * B ]

MultAB:
@18ca:  sta     f:hWRMPYA
        xba
        sta     f:hWRMPYB
        clr_a
        rts

; ------------------------------------------------------------------------------

; [ +$26 = $22 * $24 (long access) ]

Mult8_far:
@18d5:  jsr     Mult8
        rtl

; ------------------------------------------------------------------------------

; [ +$26 = $22 * $24 ]

Mult8:
@18d9:  lda     $22
        sta     f:hWRMPYA
        lda     $24
        sta     f:hWRMPYB
        longa
        longa
        nop
        lda     f:hRDMPYL
        sta     $26         ; +$26 = $22 * $24
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ ++$26 = $22 * +$24 ]

Mult816:
@18f4:  stz     $26
        stz     $28
        stz     $2a
        ldx     #8
@18fd:  lsr     $22
        bcc     @190e
        lda     $26
        clc
        adc     $24
        sta     $26
        lda     $28
        adc     $2a
        sta     $28
@190e:  asl     $24
        rol     $2a
        dex
        bne     @18fd
        rts

; ------------------------------------------------------------------------------
