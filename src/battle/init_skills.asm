; ------------------------------------------------------------------------------

; [ init skills ]

InitSkills:
@580c:  clr_a
        lda     $1cf7       ; known swdtechs
        jsr     CountBits
        dex
        stx     near w7e2020       ; set number of swdtechs known (for swdtech gauge)
        clr_a
        lda     $1d28       ; known blitzes
        jsr     CountBits
        stx     near w7e3a80       ; set number of known blitzes
        lda     $1d4c       ; known dances
        sta     $ee
        ldx     #$07
@5828:  asl     $ee
        lda     #$ff
        bcc     @582f
        txa
@582f:  sta     near wDanceList,x     ; set known dances
        dex
        bpl     @5828
        longa
        lda     #near wRageList      ; pointer to known rages
        sta     f:hWMADDL
        shorta
        clr_ayx
        sta     f:hWMADDH
@5847:  bit     #$07
        bne     @5853
        pha
        lda     $1d2c,x     ; known rages
        sta     $ee
        inx
        pla
@5853:  lsr     $ee
        bcc     @585e
        inc     near wNumKnownRages
        sta     f:hWMDATA
@585e:  inc
        cmp     #$ff
        bne     @5847
        rts

; ------------------------------------------------------------------------------
