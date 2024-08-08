
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: name_change.asm                                                      |
; |                                                                            |
; | description: name change menu                                              |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ menu state $5d: name change (init) ]

MenuState_5d:
@652d:  jsr     DisableInterrupts
        ldy     w0201                   ; pointer to selected character properties
        sty     zSelCharPropPtr
        jsr     ClearBGScroll
        lda     #$02
        sta     z46
        stz     z4a
        jsr     LoadNameChangeCursor
        jsr     InitNameChangeCursor
        jsr     CreateCursorTask
        jsr     DrawNameChangeMenu
        jsr     InitNameChangeArrowPos
.if !LANG_EN
        lda     #1
        ldy     #near _c36fca
        jsr     CreateTask
.endif
        jsr     InitNameChangeScrollHDMA
        jsr     LoadNameChangePortraitPal
        jsr     LoadNameChangePortraitGfx
        jsr     CreateNameChangePortraitTask
        lda     #2
        ldy     #near NameChangeArrowTask
        jsr     CreateTask
        lda     #$5f                    ; go to menu state $5f after fade in
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $5f: name change menu ]

MenuState_5f:
.if LANG_EN
@656c:  jsr     InitDMA1BG1ScreenAB
.else
@6ba5:  lda     z0a+1
        bit     #$04
        beq     @6bb9
        lda     z4e
        cmp     #$09
        bne     @6bb9
        lda     #$60
        sta     zMenuState
        lda     #$15
        sta     zWaitCounter
@6bb9:  lda     z0a+1
        bit     #$08
        beq     @6bcb
        lda     z4e
        bne     @6bcb
        lda     #$61
        sta     zMenuState
        lda     #$15
        sta     zWaitCounter
@6bcb:  jsr     InitDMA1BG1ScreenAB
        jsr     _c36c99
.endif
        jsr     UpdateNameChangeCursor
        jsr     DrawNameChangeName
        lda     z08+1
        bit     #>JOY_START
        jne     @65c2                   ; jump if start button is pressed

; A button
        lda     z08
        bit     #JOY_A
        beq     @6595                   ; branch if A button is not pressed
        jsr     PlaySelectSfx
        clr_a
        jsr     ChangeNameLetter
        lda     zSelIndex
        cmp     #5
        beq     @6592
        inc
@6592:  sta     zSelIndex
        rts

; B button
@6595:  lda     z08+1
        bit     #>JOY_B
        beq     @65c1                   ; return if B button is not pressed
        jsr     PlayEraseSfx
        lda     zSelIndex
        beq     @65c1
        cmp     #5
        bne     @65b5
        jsr     _c3660f
        lda     $0002,y
        cmp     #$ff
        beq     @65b5
        lda     #$ff
        jmp     ChangeNameLetter
@65b5:  lda     #$01
        jsr     ChangeNameLetter
        lda     zSelIndex
        beq     @65bf
        dec
@65bf:  sta     zSelIndex
@65c1:  rts

; start
@65c2:  ldy     zSelCharPropPtr
        ldx     z0
@65c6:  lda     $0002,y               ; make sure name is not blank
        cmp     #$ff
        bne     @65db
        iny
        inx
        cpx     #6
        bne     @65c6
        jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; exit menu
@65db:  jsr     PlaySelectSfx
        stz     w0205
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

MenuState_60:
MenuState_61:

.else

; ------------------------------------------------------------------------------

; [  ]

MenuState_60:
@6c4a:  lda     zWaitCounter
        beq     @6c66
        lda     z4a
        bne     @6c6c
        longa_clc
        lda     $7e9bcd
        adc     #8
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts
@6c66:  lda     #$64
        sta     z4a
        stz     z4e
@6c6c:  lda     #$5f
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

MenuState_61:
@6c71:  lda     zWaitCounter
        beq     @6c8e
        lda     z4a
        beq     @6c94
        longa
        lda     $7e9bcd
        sec
        sbc     #8
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts
@6c8e:  stz     z4a
        lda     #$09
        sta     z4e
@6c94:  lda     #$5f
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c36c99:
@6c99:  lda     z08
        bit     #$10
        bne     @6ca3
        bit     #$20
        beq     @6cbd
@6ca3:  jsr     PlayMoveSfx
        lda     z4a
        bne     @6cbe
        lda     #$64
        sta     z4a
        longa
.if LANG_EN
        lda     #120
.else
        lda     #112
.endif
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
@6cbd:  rts
@6cbe:  stz     z4a
        longa
.if LANG_EN
        lda     #.loword(-120)
.else
        lda     #.loword(-48)
.endif
        sta     $7e9bcd
        sta     $7e9bd0
        shorta
        rts

.endif

; ------------------------------------------------------------------------------

; [ add/remove letter from character name ]

ChangeNameLetter:
@65e8:  pha
        jsr     _c3660f
        pla
        bmi     @65fa
        beq     @6600
        lda     #$ff
        sta     $0002,y
        sta     $0001,y
        rts
@65fa:  lda     #$ff
        sta     $0002,y
        rts
@6600:  clr_a
        lda     z4b
        clc
        adc     z4a
        tax
        lda     f:NameChangeLetters,x   ; letters for name change menu
        sta     $0002,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3660f:
@660f:  ldy     zSelCharPropPtr
        lda     zSelIndex
        sta     ze7
        stz     ze8
        longa
        tya
        clc
        adc     ze7
        tay
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init arrow position for name change menu ]

InitNameChangeArrowPos:
@6621:  ldy     zSelCharPropPtr
        ldx     z0
@6625:  lda     $0002,y
        cmp     #$ff
        beq     @6634
        iny
        inx
        cpx     #6
        bne     @6625
        dex
@6634:  txa
        sta     zSelIndex
        rts

; ------------------------------------------------------------------------------

; [ init name change cursor ]

LoadNameChangeCursor:
@6638:  ldy     #near NameChangeCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update name change cursor ]

UpdateNameChangeCursor:
@663e:  jsr     MoveCursor

InitNameChangeCursor:
@6641:  ldy     #near NameChangeCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

NameChangeCursorProp:
.if LANG_EN
        make_cursor_prop {0, 0}, {10, 7}, NO_Y_WRAP
.else
        make_cursor_prop {0, 0}, {10, 10}, NO_Y_WRAP
.endif

NameChangeCursorPos:
.if LANG_EN
.repeat 7, yy
        .repeat 5, xx
                .byte $38 + xx * $10, $58 + yy * $10
        .endrep
        .repeat 5, xx
                .byte $90 + xx * $10, $58 + yy * $10
        .endrep
.endrep
.else
.repeat 10, yy
        .repeat 5, xx
                .byte $38 + xx * $10, $38 + yy * $10
        .endrep
        .repeat 5, xx
                .byte $90 + xx * $10, $38 + yy * $10
        .endrep
.endrep
.endif

; ------------------------------------------------------------------------------

; [ create portrait task for name change menu ]

CreateNameChangePortraitTask:
@66d8:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     #near Portrait1AnimData
        sta     near wTaskAnimPtr,x
        lda     #$0010
        sta     near wTaskPosX,x
        lda     #$0010
        sta     near wTaskPosY,x
        shorta
        lda     #^Portrait1AnimData
        sta     near wTaskAnimBank,x
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ draw menu for name change ]

DrawNameChangeMenu:
@6705:  jsr     ClearBG2ScreenA
.if LANG_EN
        ldy     #near NameChangeAlphabetWindow
        jsr     DrawWindow
        ldy     #near NameChangePortraitWindow
        jsr     DrawWindow
        ldy     #near NameChangeMsgWindow
        jsr     DrawWindow
        ldy     #near NameChangeNameWindow
        jsr     DrawWindow
.else
        ldy     #near NameChangeNameWindow
        jsr     DrawWindow
        ldy     #near NameChangeAlphabetWindow
        jsr     DrawWindow
        ldy     #near NameChangePortraitWindow
        jsr     DrawWindow
.endif
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG1ScreenC
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
.if LANG_EN
        ldx_pos BG1A, {9, 4}
.else
        ldx_pos BG1A, {9, 0}
.endif
        ldy     #near NameChangeLetters
        sty     ze7
        lda     #^NameChangeLetters
        sta     ze9
.if LANG_EN
        lda     #7                      ; 7 rows
        sta     ze5
        jsr     DrawNameChangeAlphabet
        jsr     DrawNameChangeName
        ldy     #near NameChangeMsgText
        jsr     DrawPosText
.else
        lda     #16                     ; 16 rows
        sta     ze5
        jsr     DrawNameChangeAlphabet
        ldx_pos BG1C, {9, 0}
        ldy     #near NameChangeLetters2
        sty     ze7
        lda     #^NameChangeLetters2
        sta     ze9
        lda     #4                      ; 4 rows
        sta     ze5
        jsr     DrawNameChangeAlphabet
        jsr     DrawNameChangeName
.endif
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     TfrBG1ScreenCD
        jsr     ClearBG3ScreenA
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ draw character name for name change menu ]

DrawNameChangeName:
.if LANG_EN
@675b:  ldy_pos BG1B, {16, 7}
.else
        ldy_pos BG1B, {16, 2}
.endif
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; name change menu windows
.if LANG_EN
NameChangeNameWindow:                   make_window BG2A, {9, 5}, {18, 2}
NameChangeAlphabetWindow:               make_window BG2A, {7, 8}, {22, 17}
NameChangePortraitWindow:               make_window BG2A, {1, 1}, {5, 5}
NameChangeMsgWindow:                    make_window BG2A, {8, 1}, {20, 2}
.else
NameChangeNameWindow:                   make_window BG2A, {9, 1}, {18, 2}
NameChangeAlphabetWindow:               make_window BG2A, {7, 5}, {22, 20}
NameChangePortraitWindow:               make_window BG2A, {1, 1}, {5, 5}
.endif

; ------------------------------------------------------------------------------

; [ load portrait graphics for name change menu ]

LoadNameChangePortraitGfx:
@6771:  ldy     zSelCharPropPtr
        clr_a
        lda     $0001,y
        longa
        asl
        tax
        lda     #$2600
        sta     hVMADDL
        lda     f:PortraitGfxPtrs,x
        tax
        jsr     TfrPortraitGfx
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load portrait palette for name change menu ]

LoadNameChangePortraitPal:
@678c:  lda     #$10
        sta     ze3
        ldy     zSelCharPropPtr
        clr_a
        lda     $0001,y
        tax
        lda     f:CharPortraitPalTbl,x
        longa
        asl5
        tax
        ldy     z0
@67a5:  longa
        phx
        lda     f:PortraitPal,x
        tyx
        sta     wPalBuf::SpritePal0,x
        shorta
        plx
        inx2
        iny2
        dec     ze3
        bne     @67a5
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw alphabet for name change menu ]

DrawNameChangeAlphabet:
@67bf:  stx     zeb
        lda     #$7e
        sta     zed
        ldy     z0
@67c7:  lda     #10                     ; 10 columns
        sta     ze6
        ldx     z0
@67cd:  lda     [ze7],y
        sta     ze0
        phy
        cmp     #$53
        bcc     @67dc
        lda     #$ff
        sta     ze1
        bra     @67fc
@67dc:  cmp     #$49
        bcc     @67ed
        lda     #$52
        sta     ze1
        lda     ze0
        clc
        adc     #$17
        sta     ze0
        bra     @67fc
@67ed:  cmp     #$20
        bcc     @67fc
        lda     #$51
        sta     ze1
        lda     ze0
        clc
        adc     #$40
        sta     ze0
@67fc:  txy
        lda     ze1
        sta     [zeb],y
        iny
        lda     zTextColor
        sta     [zeb],y
        longa
        txa
        clc
        adc     #$0040
        tay
        shorta
        lda     ze0
        sta     [zeb],y
        iny
        lda     zTextColor
        sta     [zeb],y
        inx4
        ply
        iny
        lda     ze6
        cmp     #$06
        bne     @6827
        inx2
@6827:  dec     ze6
        bne     @67cd
        longa
        lda     zeb
        clc
        adc     #$0080
        sta     zeb
        shorta
        dec     ze5
        bne     @67c7
        rts

; ------------------------------------------------------------------------------

; [ in bg1 scroll hdma data tables for name change menu ]

InitNameChangeScrollHDMA:
@683c:  ldx     z0

; init vertical scroll HDMA
@683e:  lda     f:NameChangeVScrollHDMATbl,x
        sta     $7e9bc9,x               ; copy HDMA table to RAM
        inx
        cpx     #sizeof_NameChangeVScrollHDMATbl
        bne     @683e
        lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG1VOFS
        sta     hDMA5::HREG
        ldy     #$9bc9
        sty     hDMA5::ADDR
        lda     #$7e
        sta     hDMA5::ADDR_B
        lda     #$7e
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA

; init horizontal scroll HDMA
        lda     #$02
        sta     hDMA6::CTRL
        lda     #<hBG1HOFS
        sta     hDMA6::HREG
        ldy     #near NameChangeHScrollHDMATbl
        sty     hDMA6::ADDR
        lda     #^NameChangeHScrollHDMATbl
        sta     hDMA6::ADDR_B
        lda     #^NameChangeHScrollHDMATbl
        sta     hDMA6::HDMA_B
        lda     #BIT_6
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

NameChangeHScrollHDMATbl:
.if LANG_EN
        hdma_word 71, $0100
.else
        hdma_word 47, $0100
.endif
        hdma_word 80, $0000
        hdma_word 80, $0000
        hdma_word 16, $0100
        hdma_end

NameChangeVScrollHDMATbl:
.if LANG_EN
        hdma_word 71, 0
.else
        hdma_word 47, 0
.endif
        hdma_word 80, -48
        hdma_word 80, -48
        hdma_word 16, 0
        hdma_end
        calc_size NameChangeVScrollHDMATbl

; ------------------------------------------------------------------------------

.if !LANG_EN

_c36fca:
@6fca:  tax
        jmp     (near _c36fce,x)

_c36fce:
        .addr   _c36fd2, _c36ff5

_c36fd2:
        ldx     $2d
        longa
        lda     #near _c37015
        sta     $32c9,x
        lda     #$0090
        sta     $33ca,x
        lda     #$0028
        sta     $344a,x
        shorta
        lda     #^_c37015
        sta     $35ca,x
        inc     $3649,x
        jsr     InitAnimTask

_c36ff5:
        ldy     $2d
        lda     $4a
        beq     @6fff
        lda     #$02
        bra     @7000
@6fff:  clr_a
@7000:  tax
        longa
        lda     f:_c37011,x
        sta     $32c9,y
        shorta
        jsr     UpdateAnimTask
        sec
        rts

_c37011:
        .addr   _c37015, _c3701e

_c37015:
        .byte   $b5,$c3,$10,$27,$70,$10,$b5,$c3,$ff
_c3701e:
        .byte   $b5,$c3,$10,$bb,$c3,$10,$b5,$c3,$ff

_c37029:
        .byte   $01,$80,$a0,$03,$3e

.endif

; ------------------------------------------------------------------------------

; [ task for name change position indicator ]

NameChangeArrowTask:
@68a3:  tax
        jmp     (near NameChangeArrowTaskTbl,x)

NameChangeArrowTaskTbl:
@68a7:  .addr   NameChangeArrowTask_00
        .addr   NameChangeArrowTask_01

; ------------------------------------------------------------------------------

; [ init name change flashing arrow ]

NameChangeArrowTask_00:
@68ab:  ldx     zTaskOffset
        longa
        lda     #near NameChangeArrowAnim
        sta     near wTaskAnimPtr,x
.if LANG_EN
        lda     #$0040
.else
        lda     #$0020
.endif
        sta     near wTaskPosY,x
        shorta
        stz     near {wTaskPosX + 1},x
        lda     #^NameChangeArrowAnim
        sta     near wTaskAnimBank,x
        jsr     InitAnimTask
        inc     near wTaskState,x
; fallthrough

; [ update name change flashing arrow ]

NameChangeArrowTask_01:
@68cb:  ldy     zTaskOffset
        clr_a
        lda     zSelIndex
        tax
        lda     f:NameChangeArrowXTbl,x
        sta     near wTaskPosX,y
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

NameChangeArrowXTbl:
@68dd:  .byte   $78,$80,$88,$90,$98,$a0

.if LANG_EN

.define NameChangeMsgStr {$8f,$a5,$9e,$9a,$ac,$9e,$ff,$9e,$a7,$ad,$9e,$ab,$ff,$9a,$ff,$a7,$9a,$a6,$9e,$c5,$00}
; "Please enter a name…"
NameChangeMsgText:      pos_text BG1B, {9, 3}, NameChangeMsgStr

.endif

; ------------------------------------------------------------------------------
