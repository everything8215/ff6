; ------------------------------------------------------------------------------

; [ menu state $3f/$40/$41/$4e/$4f: bushido renaming (jp version only) ]

.if LANG_EN

        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_INIT
        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_2
        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_3
        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_SCROLL_1
        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_SCROLL_2

.else

; ------------------------------------------------------------------------------

InitBushidoNameHDMA:
@bd99:  ldx     zZero
@bd9b:  lda     f:BushidoNameBG3VScrollHDMATbl,x
        sta     $7e9bc9,x
        inx
        cpx     #sizeof_BushidoNameBG3VScrollHDMATbl
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
        ldy     #near BushidoNameBG3HScrollHDMATbl
        sty     hDMA6::ADDR
        lda     #^BushidoNameBG3HScrollHDMATbl
        sta     hDMA6::ADDR_B
        lda     #^BushidoNameBG3HScrollHDMATbl
        sta     hDMA6::HDMA_B
        lda     #BIT_6
        tsb     zEnableHDMA
        rts

BushidoNameBG3HScrollHDMATbl:
        hdma_word 79, 256
        hdma_word 80, 0
        hdma_word 48, 0
        hdma_word 16, 256
        hdma_end

BushidoNameBG3VScrollHDMATbl:
        hdma_word 79, 2
        hdma_word 80, -80
        hdma_word 48, -80
        hdma_word 16, 0
        hdma_end
        calc_size BushidoNameBG3VScrollHDMATbl

; ------------------------------------------------------------------------------

        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_INIT
@be00:  jsr     DisableInterrupts
        jsr     ClearBGScroll
        lda     #$41
        sta     hBG3SC
        lda     #$02
        sta     z46
        stz     z4a
        stz     z5d
        stz     z5f
        jsr     _c3c07f
        jsr     _c3c088
        jsr     CreateCursorTask
        jsr     _c3c123
        lda     #1
        ldy     #near _c3c357
        jsr     CreateTask
        jsr     InitBushidoNameHDMA
        lda     #MENU_STATE::BUSHIDO_NAME_2
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_2
@be37:  jsr     _c3c033
        jsr     _c3c085
        jsr     _c3bf53
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @be67
        jsr     PlaySelectSfx
        jsr     _c3c2f9
        lda     z4d
        sta     z5e
        lda     z4b
        sta     zSelIndex
        jsr     _c3c09f
        lda     z5d
        sta     z4d
        lda     z5f
        sta     z4e
        jsr     _c3c0a8
        lda     #MENU_STATE::BUSHIDO_NAME_3
        sta     zMenuState
        rts
@be67:  lda     zNewCtrlState_H
        bit     #>JOY_START
        beq     _be79
_be6d:  jsr     PlaySelectSfx
        stz     r0205
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState
_be79:  rts

; ------------------------------------------------------------------------------

        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_3
@be7a:  jsr     _c3c033
        lda     zRepCtrlState_H
        bit     #>JOY_DOWN
        beq     @be91
        lda     z4e
        cmp     #$07
        bne     @be91
        lda     #MENU_STATE::BUSHIDO_NAME_SCROLL_1
        sta     zMenuState
        lda     #$11
        sta     zWaitCounter_L
@be91:  lda     zRepCtrlState_H
        bit     #>JOY_UP
        beq     @bea3
        lda     z4e
        bne     @bea3
        lda     #MENU_STATE::BUSHIDO_NAME_SCROLL_2
        sta     zMenuState
        lda     #$11
        sta     zWaitCounter_L
@bea3:  jsr     _c3bf53
        jsr     _c3c0a5
        lda     zNewCtrlState_H
        bit     #>JOY_START
        beq     @beb1
        bra     _be6d
@beb1:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @becb
        jsr     PlaySelectSfx
        jsr     _c3bf3f
        lda     z5e
        cmp     #$05
        beq     @bec6
        inc
        bra     @bec7
@bec6:  tdc
@bec7:  sta     z5e
        bra     @bed4
@becb:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @beee
        jsr     PlayCancelSfx
@bed4:  lda     z4d
        sta     z5d
        lda     z4e
        sta     z5f
        jsr     _c3c07f
        lda     z5e
        sta     z4d
        jsr     _c3c088
        lda     #$01
        trb     z46
        lda     #MENU_STATE::BUSHIDO_NAME_2
        sta     zMenuState
@beee:  rts

; ------------------------------------------------------------------------------

        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_SCROLL_1
@beef:  lda     zWaitCounter_L
        beq     @bf0c
        lda     z4a
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
        sta     z4a
        stz     z4e
@bf12:  lda     #MENU_STATE::BUSHIDO_NAME_3
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

        array_label MENU_STATE, MENU_STATE::BUSHIDO_NAME_SCROLL_2
@bf17:  lda     zWaitCounter_L
        beq     @bf34
        lda     z4a
        beq     @bf3a
        longa
        lda     $7e9bcd
        sec
        sbc     #$0008
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts
@bf34:  stz     z4a
        lda     #$07
        sta     z4e
@bf3a:  lda     #MENU_STATE::BUSHIDO_NAME_3
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

_c3bf3f:
@bf3f:  jsr     _c3c06e
        txa
        clc
        adc     zSelIndex
        tax
        lda     z4b
        clc
        adc     #$80
        clc
        adc     z4a
        sta     $1cf8,x
        rts

; ------------------------------------------------------------------------------

_c3bf53:
@bf53:  lda     zNewCtrlState_L
        bit     #JOY_R
        bne     @bf5d
        bit     #JOY_L
        beq     @bf77
@bf5d:  jsr     PlayMoveSfx
        lda     z4a
        bne     @bf78
        lda     #$38
        sta     z4a
        longa
        lda     #$0030
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
@bf77:  rts
@bf78:  stz     z4a
        longa
        lda     #$ffb0
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts

; ------------------------------------------------------------------------------

_c3bf8a:
@bf8a:  ldx     #$8049
        stx     zeb
        lda     #$7e
        sta     zed
        ldy     #$01b0
        sty     ze7
        ldy     #$0186
        ldx     #$3680
        stx     ze0
        jsr     _c3a783
        ldy     #$01f0
        sty     ze7
        ldy     #$01c6
        ldx     #$3681
        stx     ze0
        jmp     _c3a783

; ------------------------------------------------------------------------------

_c3bfb3:
@bfb3:  ldy     #$0280
        sty     zf3
        jsr     _c3b437
        ldx     #near BushidoDescPtrs
        stx     ze7
        ldx     #near BushidoDesc
        stx     zeb
        lda     #^BushidoDescPtrs
        sta     ze9
        lda     #^BushidoDesc
        sta     zed
        ldx     #$9ec9
        stx     hWMADDL
        tdc
        lda     r0201
        jsr     _c35d99
        stz     z8d
        stz     zed
        stz     zee
        ldx     zZero
@bfe2:  lda     $7e9ec9,x
        beq     @bff3
        jsr     GetLetter
        phx
        jsr     CopyBigLetterGfx
        plx
        inx
        bra     @bfe2
@bff3:  ldy     #$7400
        sty     zDMA2Dest
        ldy     #$a271
        sty     zDMA2Src
        ldy     #$0700
        sty     zDMA2Size
        jsr     TfrVRAM2
        stz     zDMA2Dest_L
        stz     zDMA2Dest_H
        rts

; ------------------------------------------------------------------------------

_c3c00a:
@c00a:  ldx     #$8049
        stx     zeb
        lda     #$7e
        sta     zed
        ldy     #$00b0
        sty     ze7
        ldy     #$009e
        ldx     #$3600
        stx     ze0
        jsr     _c3a783
        ldy     #$00f0
        sty     ze7
        ldy     #$00de
        ldx     #$3601
        stx     ze0
        jmp     _c3a783

; ------------------------------------------------------------------------------

_c3c033:
@c033:  ldy     #$0120
        sty     zf3
        jsr     _c3b437
        stz     z8d
        stz     zed
        stz     zee
        lda     #$06
        sta     zf1
        jsr     _c3c06e
@c048:  lda     $1cf8,x
        ldy     #$3f40
        sty     zeb
        phx
        jsr     CopyBigLetterGfx
        plx
        inx
        dec     zf1
        bne     @c048
        ldy     #$7000
        sty     zDMA2Dest
        ldy     #$a271
        sty     zDMA2Src
        ldy     #$0120
        sty     zDMA2Size
        lda     #$01
        trb     z45
        rts

; ------------------------------------------------------------------------------

_c3c06e:
@c06e:  tdc
        lda     r0201
        asl
        asl
        sta     ze0
        lda     r0201
        asl
        clc
        adc     ze0
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
        cursor_prop {0, 0}, {6, 1}, NO_Y_WRAP

_c3c093:
        .repeat 6, xx
        cursor_pos {xx * 12 + 112, 28}
        .endrep

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
        cursor_prop {0, 0}, {7, 8}, NO_Y_WRAP

_c3c0b3:
        .repeat 8, yy
        .repeat 7, xx
        cursor_pos {xx * 32 + 16, yy * 16 + 80}
        .endrep
        .endrep

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
        sta     zTextColor
        ldx     #$7849
        stx     zeb
        lda     #$7e
        sta     zed
        ldx     zZero
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
        .word   $0008,$3400
        .word   $0088,$341c
        .word   $0108,$3438
        .word   $0188,$3454
        .word   $0208,$3470
        .word   $0288,$348c
        .word   $0308,$34a8
        .word   $0388,$34c4
        .word   $0408,$34e0
        .word   $0488,$34fc
        .word   $0508,$3518
        .word   $0588,$3534
        .word   $0608,$3550
        .word   $0688,$356c
        .word   $0708,$3588
        .word   $0788,$35a4

; ------------------------------------------------------------------------------

_c3c1c9:
@c1c9:  lda     #$20
        sta     zTextColor
        ldy     #near BushidoTitleText
        jsr     DrawPosKana
        tdc
        lda     r0201
        inc
        clc
        adc     #ZERO_CHAR
        sta     zf9
        stz     zfa
        ldx     #$38dd
        stx     zf7
        ldy     #near zf7
        sty     ze7
        lda     #^zf7
        sta     ze9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

_c3c1f2:
@c1f2:  lda     #$30
        sta     zTextColor
        ldy     #near BushidoGaugeText
        jsr     DrawPosText
        tdc
        lda     r0201
        beq     @c230
        tay
        longa
        lda     #$3911
        sta     $7e9e89
        shorta
        ldx     #$9e8b
        stx     hWMADDL
        ldx     zZero
@c216:  lda     f:BushidoFullGaugeText,x
        sta     hWMDATA
        inx
        dey
        bne     @c216
        stz     hWMDATA
        ldy     #$9e89
        sty     ze7
        lda     #$7e
        sta     ze9
        jsr     DrawPosTextFar
@c230:  rts

; ------------------------------------------------------------------------------

; filled gauge text
BushidoFullGaugeText:
        .repeat 7
        .byte   GAUGE_FULL_CHAR
        .endrep

; ------------------------------------------------------------------------------

_c3c238:
        window_pos BG2A, {1, 1}, {28, 2}
_c3c23c:
        window_pos BG2A, {1, 5}, {28, 2}
_c3c240:
        window_pos BG2A, {1, 9}, {28, 16}

; ------------------------------------------------------------------------------

; gauge text
BushidoGaugeText:
        pos_text BUSHIDO_GAUGE

; ひっさつけん (必殺剣)
; "hissatsu ken", or "deadly sword"
BushidoTitleText:
        pos_text BUSHIDO_TITLE

; ------------------------------------------------------------------------------

_c3c25a:
@c25a:  shorta
        lda     #7
        sta     ze2
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
        dec     ze2
        bne     @c260
        rts

; ------------------------------------------------------------------------------

_c3c27c:
        .a16
@c27c:  stx     ze0
        lda     ze0
        sta     [zeb],y
        inc     ze0
        inc     ze0
        iny2
        lda     ze0
        sta     [zeb],y
        dec     ze0
        dey2
        tya
        clc
        adc     #$0040
        tay
        lda     ze0
        sta     [zeb],y
        iny2
        inc     ze0
        inc     ze0
        lda     ze0
        sta     [zeb],y
        rts
        .a8

; ------------------------------------------------------------------------------

_c3c2a5:
@c2a5:  stz     ze4
        ldy     #$6000
        sty     zf1
@c2ac:  jsr     _c3c2de
        ldy     zf1
        jsr     TfrBigLetterGfx
        longa
        lda     zf1
        clc
        adc     #$0020
        sta     zf1
        shorta
        inc     ze4
        lda     ze4
        cmp     #$70
        bne     @c2ac
        stz     zDMA2Dest_L
        stz     zDMA2Dest_H
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
        sty     zf3
        jsr     _c3b437
        stz     z8d
        stz     zed
        stz     zee
        lda     ze4
        clc
        adc     #$80
        ldy     #$3f40
        sty     zeb
        jmp     CopyBigLetterGfx

; ------------------------------------------------------------------------------

_c3c2f9:
@c2f9:  lda     #2
        ldy     #near _c3c312
        jsr     CreateTask
        longa
        lda     z55
        sta     wTaskProp::PosX_H,x
        lda     z57
        sta     wTaskProp::PosY_H,x
        shorta
        rts

_c3c312:
@c312:  tax
        jmp     (near _c3c316,x)

_c3c316:
@c316:  .addr   _c3c31a,_c3c335

_c3c31a:
@c31a:  ldx     zTaskOffset
        lda     #$01
        tsb     z46
        longa
        lda     #near NameChangeArrowAnim
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^NameChangeArrowAnim
        sta     near wTaskProp::AnimBank,x
        jsr     InitAnimTask
        inc     near wTaskProp::State,x

_c3c335:
@c335:  lda     z46
        bit     #$01
        beq     @c342
        ldx     zTaskOffset
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
@c35f:  ldx     zTaskOffset
        longa
        lda     #near _c3c3a3
        sta     near wTaskProp::AnimPtr,x
        lda     #$0078
        sta     near wTaskProp::PosX_H,x
        lda     #$0048
        sta     near wTaskProp::PosY_H,x
        shorta
        lda     #^_c3c3a3
        sta     near wTaskProp::AnimBank,x
        inc     near wTaskProp::State,x
        jsr     InitAnimTask

_c3c382:
@c382:  ldx     zTaskOffset
        lda     z4a
        beq     @c38c
        lda     #$02
        bra     @c38d
@c38c:  tdc
@c38d:  txy
        tax
        longa
        lda     f:_c3c39f,x
        sta     near wTaskProp::AnimPtr,y
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
