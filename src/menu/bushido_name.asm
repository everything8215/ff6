; ------------------------------------------------------------------------------

; [ menu state $3f/$40/$41/$4e/$4f: bushido renaming (jp version only) ]

.if LANG_EN

MenuState_3f:
MenuState_40:
MenuState_41:
MenuState_4e:
MenuState_4f:

.else

; ------------------------------------------------------------------------------

_c3bd99:
@bd99:  ldx     z0
@bd9b:  lda     f:_c3bdf3,x
        sta     $7e9bc9,x
        inx
        cpx     #sizeof__c3bdf3
        bne     @bd9b
        lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #$9bc9
        sty     hDMA5::ADDR
        lda     #$7e
        sta     hDMA5::ADDR_B
        lda     #$7e
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        lda     #$02
        sta     hDMA6::CTRL
        lda     #<hBG3HOFS
        sta     hDMA6::HREG
        ldy     #near _c3bde6
        sty     hDMA6::ADDR
        lda     #^_c3bde6
        sta     hDMA6::ADDR_B
        lda     #^_c3bde6
        sta     hDMA6::HDMA_B
        lda     #BIT_6
        tsb     zEnableHDMA
        rts

_c3bde6:
        hdma_word 79, $0100
        hdma_word 80, $0000
        hdma_word 48, $0000
        hdma_word 16, $0100
        hdma_end

begin_block _c3bdf3
        hdma_word 79, 2
        hdma_word 80, -80
        hdma_word 48, -80
        hdma_word 16, 0
        hdma_end
end_block _c3bdf3

; ------------------------------------------------------------------------------

MenuState_3f:
_c3be00:
@be00:  jsr     DisableInterrupts
        jsr     ClearBGScroll
        lda     #$41
        sta     $2109
        lda     #$02
        sta     $46
        stz     $4a
        stz     $5d
        stz     $5f
        jsr     _c3c07f
        jsr     _c3c088
        jsr     CreateCursorTask
        jsr     _c3c123
        lda     #1
        ldy     #near _c3c357
        jsr     CreateTask
        jsr     _c3bd99
        lda     #$40
        sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

MenuState_40:
@be37:  jsr     _c3c033
        jsr     _c3c085
        jsr     _c3bf53
        lda     $08
        bit     #$80
        beq     @be67
        jsr     PlaySelectSfx
        jsr     _c3c2f9
        lda     $4d
        sta     $5e
        lda     $4b
        sta     $28
        jsr     _c3c09f
        lda     $5d
        sta     $4d
        lda     $5f
        sta     $4e
        jsr     _c3c0a8
        lda     #$41
        sta     $26
        rts
@be67:  lda     $09
        bit     #$10
        beq     _be79
_be6d:  jsr     PlaySelectSfx
        stz     $0205
        lda     #$ff
        sta     $27
        stz     $26
_be79:  rts

; ------------------------------------------------------------------------------

MenuState_41:
_c3be7a:
@be7a:  jsr     _c3c033
        lda     $0b
        bit     #$04
        beq     @be91
        lda     $4e
        cmp     #$07
        bne     @be91
        lda     #$4e
        sta     $26
        lda     #$11
        sta     $20
@be91:  lda     $0b
        bit     #$08
        beq     @bea3
        lda     $4e
        bne     @bea3
        lda     #$4f
        sta     $26
        lda     #$11
        sta     $20
@bea3:  jsr     _c3bf53
        jsr     _c3c0a5
        lda     $09
        bit     #$10
        beq     @beb1
        bra     _be6d
@beb1:  lda     $08
        bit     #$80
        beq     @becb
        jsr     PlaySelectSfx
        jsr     _c3bf3f
        lda     $5e
        cmp     #$05
        beq     @bec6
        inc
        bra     @bec7
@bec6:  tdc
@bec7:  sta     $5e
        bra     @bed4
@becb:  lda     $09
        bit     #$80
        beq     @beee
        jsr     PlayCancelSfx
@bed4:  lda     $4d
        sta     $5d
        lda     $4e
        sta     $5f
        jsr     _c3c07f
        lda     $5e
        sta     $4d
        jsr     _c3c088
        lda     #$01
        trb     $46
        lda     #$40
        sta     $26
@beee:  rts

; ------------------------------------------------------------------------------

MenuState_4e:
@beef:  lda     $20
        beq     @bf0c
        lda     $4a
        bne     @bf12
        longa
        lda     $7e9bcd
        clc
        adc     #$0008
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts
@bf0c:  lda     #$38
        sta     $4a
        stz     $4e
@bf12:  lda     #$41
        sta     $26
        rts

; ------------------------------------------------------------------------------

MenuState_4f:
@bf17:  lda     $20
        beq     @bf34
        lda     $4a
        beq     @bf3a
        longa
        lda     $7e9bcd
        sec
        sbc     #$0008
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts
@bf34:  stz     $4a
        lda     #$07
        sta     $4e
@bf3a:  lda     #$41
        sta     $26
        rts

; ------------------------------------------------------------------------------

_c3bf3f:
@bf3f:  jsr     _c3c06e
        txa
        clc
        adc     $28
        tax
        lda     $4b
        clc
        adc     #$80
        clc
        adc     $4a
        sta     $1cf8,x
        rts

; ------------------------------------------------------------------------------

_c3bf53:
@bf53:  lda     $08
        bit     #$10
        bne     @bf5d
        bit     #$20
        beq     @bf77
@bf5d:  jsr     PlayMoveSfx
        lda     $4a
        bne     @bf78
        lda     #$38
        sta     $4a
        longa
        lda     #$0030
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
@bf77:  rts
@bf78:  stz     $4a
        longa
        lda     #$ffb0
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts

; ------------------------------------------------------------------------------

_c3bf8a:
@bf8a:  ldx     #$8049
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$01b0
        sty     $e7
        ldy     #$0186
        ldx     #$3680
        stx     $e0
        jsr     _c3a783
        ldy     #$01f0
        sty     $e7
        ldy     #$01c6
        ldx     #$3681
        stx     $e0
        jmp     _c3a783

; ------------------------------------------------------------------------------

_c3bfb3:
@bfb3:  ldy     #$0280
        sty     $f3
        jsr     _c3b437
        ldx     #near BushidoDescPtrs
        stx     $e7
        ldx     #near BushidoDesc
        stx     $eb
        lda     #^BushidoDescPtrs
        sta     $e9
        lda     #^BushidoDesc
        sta     $ed
        ldx     #$9ec9
        stx     $2181
        tdc
        lda     $0201
        jsr     _c35d99
        stz     $8d
        stz     $ed
        stz     $ee
        ldx     $00
@bfe2:  lda     $7e9ec9,x
        beq     @bff3
        jsr     GetLetter
        phx
        jsr     CopyLetterGfx
        plx
        inx
        bra     @bfe2
@bff3:  ldy     #$7400
        sty     $1b
        ldy     #$a271
        sty     $1d
        ldy     #$0700
        sty     $19
        jsr     TfrVRAM2
        stz     $1b
        stz     $1c
        rts

; ------------------------------------------------------------------------------

_c3c00a:
@c00a:  ldx     #$8049
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$00b0
        sty     $e7
        ldy     #$009e
        ldx     #$3600
        stx     $e0
        jsr     _c3a783
        ldy     #$00f0
        sty     $e7
        ldy     #$00de
        ldx     #$3601
        stx     $e0
        jmp     _c3a783

; ------------------------------------------------------------------------------

_c3c033:
@c033:  ldy     #$0120
        sty     $f3
        jsr     _c3b437
        stz     $8d
        stz     $ed
        stz     $ee
        lda     #$06
        sta     $f1
        jsr     _c3c06e
@c048:  lda     $1cf8,x
        ldy     #$3f40
        sty     $eb
        phx
        jsr     CopyLetterGfx
        plx
        inx
        dec     $f1
        bne     @c048
        ldy     #$7000
        sty     $1b
        ldy     #$a271
        sty     $1d
        ldy     #$0120
        sty     $19
        lda     #$01
        trb     $45
        rts

; ------------------------------------------------------------------------------

_c3c06e:
@c06e:  tdc
        lda     $0201
        asl
        asl
        sta     $e0
        lda     $0201
        asl
        clc
        adc     $e0
        tax
        rts

; ------------------------------------------------------------------------------

_c3c07f:
@c07f:  ldy     #near _c3c08e
        jmp     LoadCursor

; ------------------------------------------------------------------------------

_c3c085:
@c085:  jsr     MoveCursor

_c3c088:
@c088:  ldy     #near _c3c093
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

_c3c08e:
        make_cursor_prop {0, 0}, {6, 1}, NO_Y_WRAP

_c3c093:
        .byte   $70,$1c
        .byte   $7c,$1c
        .byte   $88,$1c
        .byte   $94,$1c
        .byte   $a0,$1c
        .byte   $ac,$1c

; ------------------------------------------------------------------------------

_c3c09f:
@c09f:  ldy     #near _c3c0ae
        jmp     LoadCursor

_c3c0a5:
@c0a5:  jsr     MoveCursor

_c3c0a8:
        ldy     #near _c3c0b3
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

_c3c0ae:
        make_cursor_prop {0, 0}, {7, 8}, NO_Y_WRAP

_c3c0b3:
        .byte   $10,$50
        .byte   $30,$50
        .byte   $50,$50
        .byte   $70,$50
        .byte   $90,$50
        .byte   $b0,$50
        .byte   $d0,$50
        .byte   $10,$60
        .byte   $30,$60
        .byte   $50,$60
        .byte   $70,$60
        .byte   $90,$60
        .byte   $b0,$60
        .byte   $d0,$60
        .byte   $10,$70
        .byte   $30,$70
        .byte   $50,$70
        .byte   $70,$70
        .byte   $90,$70
        .byte   $b0,$70
        .byte   $d0,$70
        .byte   $10,$80
        .byte   $30,$80
        .byte   $50,$80
        .byte   $70,$80
        .byte   $90,$80
        .byte   $b0,$80
        .byte   $d0,$80
        .byte   $10,$90
        .byte   $30,$90
        .byte   $50,$90
        .byte   $70,$90
        .byte   $90,$90
        .byte   $b0,$90
        .byte   $d0,$90
        .byte   $10,$a0
        .byte   $30,$a0
        .byte   $50,$a0
        .byte   $70,$a0
        .byte   $90,$a0
        .byte   $b0,$a0
        .byte   $d0,$a0
        .byte   $10,$b0
        .byte   $30,$b0
        .byte   $50,$b0
        .byte   $70,$b0
        .byte   $90,$b0
        .byte   $b0,$b0
        .byte   $d0,$b0
        .byte   $10,$c0
        .byte   $30,$c0
        .byte   $50,$c0
        .byte   $70,$c0
        .byte   $90,$c0
        .byte   $b0,$c0
        .byte   $d0,$c0

; ------------------------------------------------------------------------------

_c3c123:
@c123:  ldy     #near _c3c238
        jsr     DrawWindow
        ldy     #near _c3c23c
        jsr     DrawWindow
        ldy     #near _c3c240
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     _c3c1f2
        jsr     _c3c1c9
        jsr     TfrBG1ScreenAB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #$20
        sta     $29
        ldx     #$7849
        stx     $eb
        lda     #$7e
        sta     $ed
        ldx     $00
@c15c:  longa
        lda     f:_c3c18a,x
        tay
        inx2
        lda     f:_c3c18a,x
        inx2
        phx
        tax
        jsr     _c3c25a
        plx
        cpx     #$0040
        bne     @c15c
        shorta
        jsr     _c3c2a5
        jsr     _c3bf8a
        jsr     _c3bfb3
        jsr     _c3c00a
        jsr     _c3c033
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

_c3c18a:
        .byte   $08,$00,$00,$34
        .byte   $88,$00,$1c,$34
        .byte   $08,$01,$38,$34
        .byte   $88,$01,$54,$34
        .byte   $08,$02,$70,$34
        .byte   $88,$02,$8c,$34
        .byte   $08,$03,$a8,$34
        .byte   $88,$03,$c4,$34
        .byte   $08,$04,$e0,$34
        .byte   $88,$04,$fc,$34
        .byte   $08,$05,$18,$35
        .byte   $88,$05,$34,$35
        .byte   $08,$06,$50,$35
        .byte   $88,$06,$6c,$35
        .byte   $08,$07,$88,$35
        .byte   $88,$07,$a4,$35

; ------------------------------------------------------------------------------

_c3c1c9:
@c1c9:  lda     #$20
        sta     zTextColor
        ldy     #near _c3c251
        jsr     DrawPosKana
        tdc
        lda     $0201
        inc
        clc
        adc     #ZERO_CHAR
        sta     $f9
        stz     $fa
        ldx     #$38dd
        stx     zf7
        ldy     #near zf7
        sty     $e7
        lda     #^zf7
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

_c3c1f2:
@c1f2:  lda     #$30
        sta     $29
        ldy     #near _c3c244
        jsr     DrawPosText
        tdc
        lda     $0201
        beq     @c230
        tay
        longa
        lda     #$3911
        sta     $7e9e89
        shorta
        ldx     #$9e8b
        stx     $2181
        ldx     z0
@c216:  lda     f:_c3c231,x
        sta     $2180
        inx
        dey
        bne     @c216
        stz     $2180
        ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
@c230:  rts

; ------------------------------------------------------------------------------

_c3c231:
        .byte   $18,$18,$18,$18,$18,$18,$18

; ------------------------------------------------------------------------------

_c3c238:
        .byte   $8b,$58,$1c,$02
_c3c23c:
        .byte   $8b,$59,$1c,$02
_c3c240:
        .byte   $8b,$5a,$1c,$10

; ------------------------------------------------------------------------------

_c3c244:
        .byte   $0d,$39,$19,$18,$10,$10,$10,$10,$10,$10,$10,$1a,$00
_c3c251:
        .byte   $8f,$38,$63,$bd,$75,$83,$71,$b9,$00

; ------------------------------------------------------------------------------

_c3c25a:
@c25a:  shorta
        lda     #7
        sta     $e2
@c260:  longa
        phy
        phx
        jsr     _c3c27c
        plx
        txa
        clc
        adc     #$0004
        tax
        ply
        tya
        clc
        adc     #$0008
        tay
        shorta
        dec     $e2
        bne     @c260
        rts

; ------------------------------------------------------------------------------

_c3c27c:
        .a16
@c27c:  stx     $e0
        lda     $e0
        sta     [$eb],y
        inc     $e0
        inc     $e0
        iny2
        lda     $e0
        sta     [$eb],y
        dec     $e0
        dey2
        tya
        clc
        adc     #$0040
        tay
        lda     $e0
        sta     [$eb],y
        iny2
        inc     $e0
        inc     $e0
        lda     $e0
        sta     [$eb],y
        rts
        .a8

; ------------------------------------------------------------------------------

_c3c2a5:
@c2a5:  stz     $e4
        ldy     #$6000
        sty     $f1
@c2ac:  jsr     _c3c2de
        ldy     $f1
        jsr     _c3a5f6
        longa
        lda     $f1
        clc
        adc     #$0020
        sta     $f1
        shorta
        inc     $e4
        lda     $e4
        cmp     #$70
        bne     @c2ac
        stz     $1b
        stz     $1c
        rts

.endif

; ------------------------------------------------------------------------------

_c3b437:
@b437:  clr_ax
        longa
@b43b:  sta     $7ea271,x
        inx2
        cpx     zf3
        bne     @b43b
        shorta
        rts

; ------------------------------------------------------------------------------

.if !LANG_EN

_c3c2de:
@c2de:  ldy     #$0040
        sty     $f3
        jsr     _c3b437
        stz     $8d
        stz     $ed
        stz     $ee
        lda     $e4
        clc
        adc     #$80
        ldy     #$3f40
        sty     $eb
        jmp     CopyLetterGfx

; ------------------------------------------------------------------------------

_c3c2f9:
@c2f9:  lda     #$02
        ldy     #near _c3c312
        jsr     CreateTask
        longa
        lda     $55
        sta     $7e33ca,x
        lda     $57
        sta     $7e344a,x
        shorta
        rts

_c3c312:
@c312:  tax
        jmp     (near _c3c316,x)

_c3c316:
@c316:  .addr   _c3c31a,_c3c335

_c3c31a:
@c31a:  ldx     $2d
        lda     #$01
        tsb     $46
        longa
        lda     #near NameChangeArrowAnim
        sta     $32c9,x
        shorta
        lda     #^NameChangeArrowAnim
        sta     $35ca,x
        jsr     InitAnimTask
        inc     $3649,x

_c3c335:
@c335:  lda     $46
        bit     #$01
        beq     @c342
        ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts
@c342:
        clc
        rts

.endif

; ------------------------------------------------------------------------------

; frame data for flashing up indicator
NameChangeArrowSprite_00:
@b448:  .byte   1
        .byte   $09,$00,$02,$3e

NameChangeArrowSprite_01:
@b44d:  .byte   1
        .byte   $09,$00,$12,$3e

; flashing up indicator (name change menu)
NameChangeArrowAnim:
@b452:  .addr   NameChangeArrowSprite_00
        .byte   $02
        .addr   NameChangeArrowSprite_01
        .byte   $02
        .addr   NameChangeArrowSprite_00
        .byte   $ff

; ------------------------------------------------------------------------------

.if !LANG_EN

_c3c357:
@c357:  tax
        jmp     (near _c3c35b,x)

_c3c35b:
@c35b:  .addr   _c3c35f,_c3c382

_c3c35f:
@c35f:  ldx     $2d
        longa
        lda     #near _c3c3a3
        sta     $32c9,x
        lda     #$0078
        sta     $33ca,x
        lda     #$0048
        sta     $344a,x
        shorta
        lda     #^_c3c3a3
        sta     $35ca,x
        inc     $3649,x
        jsr     InitAnimTask

_c3c382:
@c382:  ldx     $2d
        lda     $4a
        beq     @c38c
        lda     #$02
        bra     @c38d
@c38c:  tdc
@c38d:  txy
        tax
        longa
        lda     f:_c3c39f,x
        sta     $32c9,y
        shorta
        jsr     UpdateAnimTask
        sec
        rts

_c3c39f:
@c39f:  .addr   _c3c3a3
        .addr   _c3c3ac

_c3c3a3:
@c3a3:  .addr   HiddenArrowSprite
        .byte   $10
        .addr   DownArrowSprite
        .byte   $10
        .addr   HiddenArrowSprite
        .byte   $ff

_c3c3ac:
@c3ac:  .addr   HiddenArrowSprite
        .byte   $10
        .addr   UpArrowSprite
        .byte   $10
        .addr   HiddenArrowSprite
        .byte   $ff

.endif

; ------------------------------------------------------------------------------

; page up and page down frame data
HiddenArrowSprite:
@b45b:  .byte   0

DownArrowSprite:
@b45c:  .byte   1
        .byte   $80,$82,$03,$3e

UpArrowSprite:
@b461:  .byte   1
        .byte   $80,$00,$03,$be

; ------------------------------------------------------------------------------
