; ------------------------------------------------------------------------------

; [ find character in party ]

; set carry if found

FindCharInParty:
        ldy     #1
        lda     [z8f],y
        and     #$7f
        sta     $10                     ; character index
        stz     $12
        clr_ax
@ba34:  lda     $10
        cmp     near wCharGfxDataBuf::CharID,x
        beq     @ba49
        inc     $12
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @ba34
        clc
        rts
@ba49:  sec
        rts

; ------------------------------------------------------------------------------

; [ add/remove character from top menu ]

AddCharToTopMenu:
        jsr     FindCharInParty
        bcc     @ba6d                   ; branch if not in party
        lda     [z8f],y
        bpl     @ba81

; hide gauge/hp
        ldx     near w7e64d6
        stx     $14
        ldx     near w7e64d6+2
        stx     $16
        clr_ax
        lda     $12
@ba62:  cmp     near w7e64d6,x
        beq     @ba70
        inx
        cpx     #4
        bne     @ba62
@ba6d:  jmp     @bac8                   ; not found

;
@ba70:  lda     #$ff
        sta     a:$14,x
        ldx     #$ffff
        stx     near w7e64d6
        stx     near w7e64d6+2
        jmp     @bab6

; show gauge/hp
@ba81:  clr_ax
        lda     $12
@ba85:  cmp     near w7e64d6,x
        beq     @bac8                   ; branch if character already shown
        inx
        cpx     #4
        bne     @ba85
        ldx     #$ffff
        phx
        stx     $14
        stx     $16
        clr_ax
@ba9a:  lda     near w7e64d6,x
        bmi     @baa3
        tay
        sta     $14,y
@baa3:  inx
        cpx     #4
        bne     @ba9a
        lda     $12
        tay
        sta     $14,y
        plx
        stx     near w7e64d6
        stx     near w7e64d6+2
@bab6:  clr_axy
@bab9:  lda     $14,y
        bmi     @bac2
        sta     near w7e64d6,x
        inx
@bac2:  iny
        cpy     #4
        bne     @bab9

; increment battle event script pointer
@bac8:  ldx     z8f
        inx
        stx     z8f

; clear all character names in text buffer
        clr_ax
        longa
        lda     #$21ff
@bad4:  sta     near w7e5b95,x
        inx2
        cpx     #w7e5b95::SIZE
        bne     @bad4
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ add/remove character as a target ]

AddCharTarget:
        jsr     FindCharInParty
        bcc     @bb0b                   ; return if not in party
        lda     $12
        tax
        lda     f:BitOrTbl,x
        sta     $12
        lda     [z8f],y
        bmi     @bafe

; character can be targetted
        lda     near w7e2f4e
        ora     $12
        sta     near w7e2f4e
        bra     @bb0b

; character can't be targetted
@bafe:  lda     near w7e2f4c
        ora     $12
        sta     near w7e2f4c
        lda     #$ff                    ; force character's menu to close
        sta     near wMenuQueue,x
@bb0b:  ldx     z8f
        inx
        stx     z8f
        rtl

; ------------------------------------------------------------------------------
