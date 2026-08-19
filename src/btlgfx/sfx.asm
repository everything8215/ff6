; ------------------------------------------------------------------------------

; [ play error sound effect ]

ErrorSfx:
sound_beep_set:
@17bd:  lda     #$22
        sta     f:hAPUIO0
        stz     z95
        rts

; ------------------------------------------------------------------------------

; [ play cursor sound effect (move/cancel) ]

MoveSfx:
sound_key_set:
@17c6:  lda     #$21
        sta     f:hAPUIO0
        stz     z94
        rts

; ------------------------------------------------------------------------------

; [ play cursor sound effect (select) ]

ConfirmSfx:
sound_key_a_set:
@17cf:  lda     #$20
        sta     f:hAPUIO0
        stz     z96
        rts

; ------------------------------------------------------------------------------

; [ play character active sound effect ]

PlayerSfx:
sound_window_set:
@17d8:  lda     near w7e62ca       ; active character
        and     #$03
        tax
        lda     near w7e6198,x     ; player controlling this character
        clc
        adc     #$28        ; sound effect $28 for player 1, $29 for player 2
        sta     f:hAPUIO0
        stz     z93
        rts

; ------------------------------------------------------------------------------

; [ play animation sound effect (long access) ]

PlayAnimSfx_far:
@17eb:  jsr     PlayAnimSfx
        rtl

; ------------------------------------------------------------------------------

; [ play animation sound effect ]

;   A: sound effect number
; $10: pan value

PlayAnimSfx:
@17ef:  sta     near w7ee9e9       ; sound effect number
        lda     $10
        sta     near w7ee9ea       ; pan value
        lda     #$18
        sta     near w7ee9e8       ; spc command $18
        inc     near w7ee9ec       ; enable animation sound effect
        rts

; ------------------------------------------------------------------------------

; [ update sound effects ]

UpdateSfx:
nmi_effect_set:
@1800:  lda     near wSfxDisabled       ; return if all sound effects are disabled
        bne     @185a
        lda     near w7ee9ec       ; branch if animation sound effect is not enabled
        beq     @1823
        lda     near w7ee9ea       ; play animation sound sound effect
        sta     f:hAPUIO2
        lda     near w7ee9e9
        sta     f:hAPUIO1
        lda     near w7ee9e8
        sta     f:hAPUIO0
        stz     near w7ee9ec       ; disable animation sound effect
        rts
@1823:  lda     near w7e6281       ; do spc command $2c (ching sound effect ???)
        beq     @1832
        lda     #$2c
        sta     f:hAPUIO0
        stz     near w7e6281
        rts
@1832:  lda     z93         ; character active sound effect
        jne     PlayerSfx
        lda     z94         ; cursor sound effect (move/cancel)
        jne     MoveSfx
        lda     z95         ; error sound effect
        jne     ErrorSfx
        lda     z96         ; cursor sound effect (select)
        jne     ConfirmSfx
        lda     z97         ; go to next part of song (dancing mad)
        beq     @185a
        lda     #$89
        sta     f:hAPUIO0
        stz     z97
@185a:  rts

; ------------------------------------------------------------------------------
