; ------------------------------------------------------------------------------

; pointers to condemned numeral graphics for each character (gets copied to $e9d2-$e9d9, +$7f0000)
CondemnNumGfxPtrs:
@bf43:  .word   $c200,$c240,$c280,$c2c0

CondemnNumFlipGfxPtrs:
@bf4b:  .word   $c300,$c340,$c380,$c3c0

; ------------------------------------------------------------------------------

; [ update condemned numeral graphics ]

; updates one character every 4 frames

UpdateCondemnNum:
@bf53:  lda     near w7ee9db       ; counter for condemned numerals
        and     #%11
        bne     @bf8a
        lda     near w7ee9db
        lsr
        lsr
        and     #%11        ; character number
        tax
        lda     near wCondemnNumBuf,x     ; condemned number
        beq     @bf6c       ; branch if zero
        jsr     DrawCondemnNum
        bra     @bf8a
@bf6c:  txa
        asl
        tax
        longa
        lda     f:CondemnNumGfxPtrs,x
        tax
        clr_a
        ldy     #$0020
@bf7a:  sta     $7f0000,x   ; clear condemned numeral graphics (2 tiles, 32 bytes each)
        sta     $7f0100,x   ; clear backwards condemned numeral graphics
        inx2
        dey
        bne     @bf7a
        shorta0
@bf8a:  inc     near w7ee9db       ; increment counter
        rtl

; ------------------------------------------------------------------------------

; [ draw condemned numeral graphics ]

DrawCondemnNum:
@bf8e:  ldy     #0
        lda     near wCondemnNumBuf,x     ; condemned number
        dec
@bf95:  sec
        sbc     #10
        bcc     @bf9d       ; branch if less than 0
        iny
        bra     @bf95
@bf9d:  clc
        adc     #10
        sta     $10         ; $10 = ones digit
        sty     $12         ; $12 = tens digit
        phb
        lda     #$7f
        pha
        plb
        txa
        asl
        tax
        longa
        phx
        lda     f:CondemnNumGfxPtrs,x
        tax
        lda     $12
        jsr     DrawCondemnNumDigitNoFlip
        lda     $10
        jsr     DrawCondemnNumDigitNoFlip
        plx
        lda     f:CondemnNumFlipGfxPtrs,x   ; pointer to condemned numeral graphics (backwards)
        tax
        lda     $10
        jsr     DrawCondemnNumDigitFlip
        lda     $12
        jsr     DrawCondemnNumDigitFlip
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [ draw a flipped condemn digit ]

DrawCondemnNumDigitFlip:
        .a16
@bfd3:  phx
        and     #$00ff
        asl
        tax
        lda     f:CondemnDigitFlipGfxPtrs,x
        bra     DrawCondemnNumDigit
        .a8

; ------------------------------------------------------------------------------

; [ draw a non-flipped condemn digit ]

DrawCondemnNumDigitNoFlip:
        .a16
@bfdf:  phx
        and     #$00ff
        asl
        tax
        lda     f:CondemnDigitGfxPtrs,x
; fallthrough

; ------------------------------------------------------------------------------

; [ common code for drawing a condemn digit ]

DrawCondemnNumDigit:
        .a16
@bfe9:  tay
        plx
        lda     #$0010
        sta     $14
@bff0:  lda     $0000,y     ; copy to condemned numeral
        sta     a:$0000,x
        inx2
        iny2
        dec     $14
        bne     @bff0
        rts
        .a8

; ------------------------------------------------------------------------------

; pointers to numeral graphics for condemned (10 digits, +$7f0000)
CondemnDigitGfxPtrs:
@bfff:  .word   $be00,$be20,$be40,$be60,$be80,$bea0,$bec0,$bee0,$bf00,$bf20

; pointers to backwards numeral graphics for condemned (10 digits, +$7f0000)
CondemnDigitFlipGfxPtrs:
@c013:  .word   $c000,$c020,$c040,$c060,$c080,$c0a0,$c0c0,$c0e0,$c100,$c120

; ------------------------------------------------------------------------------
