; ------------------------------------------------------------------------------

; [ clear leading zeroes (4 digit number) ]

TrimZeroes4:
@1a8f:  ldx     zZero
@1a91:  lda     z69,x
        sec
        sbc     z68
        bne     @1aa2
        lda     #$ff
        sta     z69,x
        inx
        cpx     #3
        bne     @1a91
@1aa2:  rts

; ------------------------------------------------------------------------------

; hex->dec conversion constants
HexToDecTbl:
@1aa3:  .dword  10000000
        .dword  1000000
        .dword  100000
        .dword  10000
        .dword  1000
        .dword  100
        .dword  10

; ------------------------------------------------------------------------------

; [ convert variable to decimal (24-bit) ]

;  +++$10: value to convert
;     $68: fixed value to add to each digit (e.g. tile offset)
; $69-$6f: result digits

HexToDec24:
@1abf:  clr_ax
@1ac1:  sta     z69,x
        inx
        cpx     #8
        bne     @1ac1
        ldx     #0
@1acc:  phx
        txa
        asl2
        tax
        lda     f:HexToDecTbl,x
        sta     $14
        lda     f:HexToDecTbl+1,x
        sta     $15
        lda     f:HexToDecTbl+2,x
        sta     $16
        jsr     HexToDec24Div
        plx
        lda     $18
        clc
        adc     z68
        sta     z69,x
        inx
        cpx     #7
        bne     @1acc
        lda     $10
        clc
        adc     z68
        sta     z69 + 7
        rts

; ------------------------------------------------------------------------------

; [ divide by power of 10 ]

HexToDec24Div:
@1afc:  stz     $18
@1afe:  lda     $10
        sec
        sbc     $14
        sta     $10
        lda     $11
        sbc     $15
        sta     $11
        lda     $12
        sbc     $16
        sta     $12
        inc     $18
        bcs     @1afe
        dec     $18
        lda     $10
        clc
        adc     $14
        sta     $10
        lda     $11
        adc     $15
        sta     $11
        lda     $12
        adc     $16
        sta     $12
        rts

; ------------------------------------------------------------------------------

; [ convert hex to decimal (16-bit) ]

;  +X: hex value to convert
; $68: fixed value to add to each digit (e.g. tile offset)

HexToDec16:
@1b2b:  longa
        stz     $22
        stz     $24
        stz     $26
        stz     $28
        txa
@1b36:  sec
        sbc     #1000
        bcc     @1b41
        inc     $22         ; +$22 = thousands digit
        jmp     @1b36
@1b41:  clc
        adc     #1000
@1b45:  sec
        sbc     #100
        bcc     @1b50
        inc     $24         ; +$24 = hundreds digit
        jmp     @1b45
@1b50:  clc
        adc     #100
@1b54:  sec
        sbc     #10
        bcc     @1b5f
        inc     $26         ; +$26 = tens digit
        jmp     @1b54
@1b5f:  clc
        adc     #10
        sta     $28         ; +$28 = ones digit
        shorta0
        lda     $22
        clc
        adc     z68
        sta     z69
        lda     $24
        clc
        adc     z68
        sta     z69 + 1
        lda     $26
        clc
        adc     z68
        sta     z69 + 2
        lda     $28
        clc
        adc     z68
        sta     z69 + 3
        rts

; ------------------------------------------------------------------------------
