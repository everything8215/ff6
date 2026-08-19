; ------------------------------------------------------------------------------

_c2bb70:
x_image_offset:
@bb70:  .word   $0000,$0000,$0000,$0000,$0000,$0020,$0020,$0040
        .word   $0040,$0060,$0060,$0080,$0080,$00a0,$00a0,$00c0
        .word   $00c0

_c2bb92:
y_image_offset:
@bb92:  .word   $0000,$0000,$0000,$0000,$0000,$0200,$0200,$0400
        .word   $0400,$0600,$0600,$0800,$0800,$0a00,$0a00,$0c00
        .word   $0c00

; ------------------------------------------------------------------------------

; [ battle animation command $80/$68: load extra esper graphics ]

; used by purifier (crusader)

AnimCmd_00_68_far:
        ldx     near wAnimThreadPtr
        phx
        jsl     _c22469     ; load crusader graphics (bg1)
        clr_ax
@bbbe:  lda     near w7e7e00::_3,x     ; copy bg1 animation palette to character 3 sprite palette
        sta     near w7e7e00::_14,x
        inx
        cpx     #$0020
        bne     @bbbe
        inc     near w7e62b0
        plx
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$67: load extra esper palette ]

; used by purifier (crusader)

AnimCmd_00_67_far:
        ldx     near w7e6169
        clr_ay
@bbd4:  lda     f:MonsterPal+$20,x
        sta     near w7e7e00::_15,y
        sta     near w7e7c00::_15,y
        inx
        iny
        cpy     #$0020      ; 16 colors
        bne     @bbd4
        rtl

; ------------------------------------------------------------------------------

; [ update random number ]

; A: (0..255) (out)

Rand_near:
@bbe6:  phx
        lda     z72
        tax
        inc     z72
        lda     f:RNGTbl,x
        plx
        rts

; ------------------------------------------------------------------------------

; rainbow palette indexes (orange, purple, blue, green, gray, red, purple, green)
RainbowPalTbl:
@bbf2:  .byte   $c0,$c1,$c2,$c3,$c4,$c5,$c1,$c3

; ------------------------------------------------------------------------------

; [ battle animation command $80/$66: clear thread offset ]

AnimCmd_00_66_far:
        ldx     near wAnimThreadPtr
        longa
        stz     near wAnimThread::ThreadOffsetX,x
        stz     near wAnimThread::ThreadOffsetY,x
        shorta
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$65: change rainbow palette ]

AnimCmd_00_65_far:
        lda     z0e         ; frame counter
        and     #%111
        bne     @bc37       ; pick a random palette every 8 frames
        jsr     Rand_near
        and     #%111
        tax
        lda     f:RainbowPalTbl,x
        longa
        asl4
        tax
        clr_ay
@bc21:  lda     f:AttackPal,x
        sta     near w7e7e00::_11,y     ; sprite animation palette
        sta     near w7e7e00::_11+16,y
        inx2
        iny2
        cpy     #$0010
        bne     @bc21
        shorta0
@bc37:  rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5f: update wide blue gradient lines ]

; used by overcast (similar to 80/3a used by odin, raiden, carbunkl, s. cross)
; this version has a single wide gradient that fills the entire screen
; b1: increase/decrease amount

AnimCmd_00_5f_far:
        ldy     #1
        lda     near w7e62ae
        clc
        adc     [zAnimScriptPtr],y
        sta     near w7e62ae
        sta     $12
        lda     #FIXED_CLR::WHITE
        sta     near w7e8993+3
        ldx     #151 * 4
        ldy     #4
        stz     $10
@bc53:  lda     $10
        lsr2
        sec
        sbc     $12
        bpl     @bc5d
        clr_a
@bc5d:  ora     #FIXED_CLR::BLUE
        sta     near w7e8993+3,y     ; -> $2132
        sta     near w7e8993+3,x
        dex4
        iny4
        inc     $10
        lda     $10
        cmp     #76
        bne     @bc53
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        inc     near w7e62ad                 ; this causes the gradient to scroll
        ldx     near wAnimThreadPtr
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5c: reset randomized bg1 scroll hdma data ]

; mind blast

AnimCmd_00_5c_far:
        longa
        clr_ax
@bc85:  sta     near wBG1ScrollData::_64,x           ; clear bg1 scroll hdma data (partial)
        sta     near wBG1ScrollData::_32,x
        sta     near w7e63b0,x               ; clear buffer (partial)
        inx2
        cpx     #$0080
        bne     @bc85
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5b: randomize bg1 h-scroll hdma data ]

; mind blast

AnimCmd_00_5b_far:
        clr_ax
@bc9b:  lda     f:RNGTbl,x
        and     #%11111                 ; (0..31)
        sta     near wBG1ScrollData::_64::Horz_L,x
        stz     near wBG1ScrollData::_64::Horz_H,x
        stz     near wBG1ScrollData::_32::Horz_L,x
        stz     near wBG1ScrollData::_32::Horz_H,x
        inx4
        cpx     #$0080
        bne     @bc9b
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5a:  ]

; mind blast

AnimCmd_00_5a_far:
        longa
        clr_ax
@bcbb:  lda     near wBG1ScrollData::_64::Horz,x
        beq     @bcc5
        dec     near wBG1ScrollData::_64::Horz,x
        bra     @bcd6
@bcc5:  lda     near wBG1ScrollData::_32::Horz,x
        sec
        sbc     #8
        sta     near wBG1ScrollData::_32::Horz,x
        clc
        adc     near w7e63b0::Horz,x
        sta     near w7e63b0::Horz,x
@bcd6:  inx4
        cpx     #$0080
        bne     @bcbb
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$59: make window 2 partially open ]

; used by flare star and goner
; the parameter determines how far window 2 is open (vertically)

AnimCmd_00_59_far:
        ldy     #1
        lda     [zAnimScriptPtr],y
        bne     @bcff

; window 2 fully open if parameter is zero
        clr_ax
        longa
        lda     #$f708
@bcf1:  sta     near w7e9a1f+2,x
        inx4
        cpx     #$025c
        bne     @bcf1
        bra     @bd3a
@bcff:  longa
        asl2
        sta     $10
        clr_ax
        ldy     #$025c
        lda     #$00ff                  ; no window
@bd0d:  sta     near w7e9a1f+2,x
        sta     near w7e9a1f+2,y
        inx4
        dey4
        cpx     $10
        bne     @bd0d
        cpx     #$0130
        beq     @bd3a
        lda     #$f708                  ; full window
@bd27:  sta     near w7e9a1f+2,x
        sta     near w7e9a1f+2,y
        inx4
        dey4
        cpx     #$0130
        bne     @bd27
@bd3a:  inc     zAnimScriptPtr
        shorta0
        inc     near w7e6197                 ; enable window hdma data update
        rtl

; ------------------------------------------------------------------------------
