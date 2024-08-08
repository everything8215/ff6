
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: status.asm                                                           |
; |                                                                            |
; | description: status menu                                                   |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

inc_lang "text/battle_cmd_name_%s.inc"

.import BattleCmdProp, LevelUpExp

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ draw status menu ]

DrawStatusMenu:
@5d05:  jsr     DrawStatusMainWindow
        jsr     DrawStatusGogoWindow
        jsr     DrawStatusLabelText
        jsr     DrawStatusCharInfo
        jsr     TfrStatusMenu
        jmp     CreateSubPortraitTask

; ------------------------------------------------------------------------------

; [  ]

DrawStatusMainWindow:
@5d17:  jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenD
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     ClearBG3ScreenD
        ldy     #near StatusMainWindow
        jsr     DrawWindow
        ldy     #near StatusTitleWindow
        jsr     DrawWindow
        ldy     #near StatusCmdWindow
        jsr     DrawWindow
        rts

; ------------------------------------------------------------------------------

; [ draw labels on status menu (blue text) ]

DrawStatusLabelText:
@5d3c:  jsr     DrawStatusTopLabelText
        bra     DrawStatusBtmLabelText

DrawStatusTopLabelText:
@5d41:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near StatusTopLabelTextList1
        ldy     #sizeof_StatusTopLabelTextList1
        jsr     DrawPosList
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near StatusTopLabelTextList2
        ldy     #sizeof_StatusTopLabelTextList2
        jsr     DrawPosList
        rts

DrawStatusBtmLabelText:
@5d5c:  lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near StatusBtmLabelTextList1
        ldy     #sizeof_StatusBtmLabelTextList1
        jsr     DrawPosList
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near StatusBtmLabelTextList2
        ldy     #sizeof_StatusBtmLabelTextList2
        jsr     DrawPosKanaList
        rts

; ------------------------------------------------------------------------------

; [ transfer status menu tiles to vram ]

TfrStatusMenu:
@5d77:  jsr     TfrBG2ScreenAB
        jsr     TfrBG1ScreenAB
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

; [  ]

_c35d83:
@5d83:  jsr     DrawStatusTopLabelText
        jsr     DrawStatusCharInfo
        jsr     ChangeStatusPortraitTask
        ldy     #$0000
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenA
        sty     zDMA1Src
        ldy     #$0800
        sty     zDMA1Size
        ldy     #$4000
        sty     zDMA2Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA2Src
        ldy     #$0800
        sty     zDMA2Size
        jsr     ExecTasks
        jsr     WaitVblank
        ldy     z0
        sty     zDMA2Dest
        ldy     #$4800
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenC
        sty     zDMA1Src
        jmp     WaitVblank

; ------------------------------------------------------------------------------

; [  ]

DrawStatusGogoWindow:
@5dc1:  ldx     #$9e09
        stx     hWMADDL
        clr_ax
@5dc9:  phx
        longa
        txa
        asl
        tax
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @5dfb
        longa
        lda     f:CharPropPtrs,x   ; pointers to character data
        tax
        shorta
        lda     a:$0016,x
        sta     hWMDATA
        lda     a:$0017,x
        sta     hWMDATA
        lda     a:$0018,x
        sta     hWMDATA
        lda     a:$0019,x
        sta     hWMDATA
        bra     @5e0b
@5dfb:  shorta
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
@5e0b:  plx
        inx
        cpx     #$0010
        bne     @5dc9

; remove duplicate battle commands
        clr_ax
@5e14:  phx
        lda     $7e9e09,x
@5e19:  cmp     $7e9e0a,x
        bne     @5e27
        pha
        lda     #$ff
        sta     $7e9e0a,x
        pla
@5e27:  inx
        cpx     #$0040
        bne     @5e19
        plx
        inx
        cpx     #$0040
        bne     @5e14
        ldx     #$9d8a
        stx     hWMADDL
        lda     #$ff
        sta     hWMDATA
        clr_axy
@5e42:  clr_a
        phx
        lda     $7e9e09,x
        bmi     @5e60
        cmp     #$12
        beq     @5e60
        sta     $e0
        asl
        tax
        lda     f:BattleCmdProp,x
        and     #BATTLE_CMD_FLAG::GOGO
        beq     @5e60                   ; branch if can't be used by gogo
        lda     $e0
        sta     hWMDATA
        iny
@5e60:  plx
        inx
        cpx     #$0040
        bne     @5e42
        iny
        tya
        sta     $7e9d89
        ldx     #$aa8d
        stx     hWMADDL
        clr_ax
@5e75:  lda     f:StatusGogoWindow,x
        sta     hWMDATA
        inx
        cpx     #8
        bne     @5e75
        tya
        sta     $e2
        clc
        adc     $e2
        adc     $e2
        and     #$fe
        beq     @5e90
        inc2
@5e90:  lsr
        sta     $7eaa90
        sta     $7eaa94
        ldy     #$aa8d
        lda     #$7e
        sta     $e9
        jsr     DrawWindowFar
        ldy     #$aa91
        lda     #$7e
        sta     $e9
        jsr     DrawWindowFar
        lda     $7e9d89
        sta     $e5
        stz     $e6
        clr_ax
.if LANG_EN
        ldy_pos BG3B, {0, 2}
.else
        ldy_pos BG3B, {1, 1}
.endif
@5eba:  phx
        phy
        lda     $7e9d8a,x
        jsr     DrawCmdNameGogo
        ply
        longa
        tya
        clc
        adc     #$0080
        tay
        shorta
        plx
        inx
        cpx     $e5
        bne     @5eba
        jmp     _c35f50

; ------------------------------------------------------------------------------

; [ draw battle command name (Gogo's status menu) ]

DrawCmdNameGogo:
@5ed7:  pha
        jsr     InitTextBuf
        pla
        bmi     _5f0c
        jmp     _5ee6

; ------------------------------------------------------------------------------

; [ draw battle command name (status menu and command arrange) ]

DrawCmdName:
@5ee1:  jsr     CheckRelicCmd
        bmi     _5f0c
_5ee6:  jsr     CheckCmdEnabled
.if LANG_EN
        sta     $e2
.endif
        pha
        asl2
        sta     $e0
        pla
        asl
        clc
        adc     $e0
.if LANG_EN
        adc     $e2
.endif
        tax
        ldy     #BattleCmdName::ITEM_SIZE
@5efb:  lda     f:BattleCmdName,x
        sta     hWMDATA
        inx
        dey
        bne     @5efb
_5f06:  stz     hWMDATA
        jmp     DrawPosTextBuf

; clear command name
_5f0c:  lda     #$ff
.repeat 6
        sta     hWMDATA
.endrep
.if LANG_EN
        sta     hWMDATA
.endif
        bra     _5f06

; ------------------------------------------------------------------------------

; [ check if a battle command is enabled (for font color) ]

CheckCmdEnabled:
@5f25:  pha
        cmp     #BATTLE_CMD::RUNIC
        beq     @5f3a
        cmp     #BATTLE_CMD::BUSHIDO
        beq     @5f44

; use white text
@5f2e:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        pla
        rts

; use gray text
@5f34:  lda     #BG3_TEXT_COLOR::GRAY
        sta     zTextColor
        pla
        rts

; runic
@5f3a:  lda     $11da
        ora     $11db
        bpl     @5f34
        bra     @5f2e

; swdtech
@5f44:  lda     $11da
        ora     $11db
        bit     #$02
        beq     @5f34
        bra     @5f2e

; ------------------------------------------------------------------------------

; [  ]

_c35f50:
@5f50:  ldx     #$61ca
        stx     $e7
        lda     #$7e
        sta     $e9
        ldx     #$0006
@5f5c:  clr_ay
        lda     #$3d
@5f60:  sta     [$e7],y
        iny2
        cpy     #$0012
        bne     @5f60
        longa
        lda     $e7
        clc
        adc     #$0040
        sta     $e7
        shorta
        dex
        bne     @5f5c
        rts

; ------------------------------------------------------------------------------

; status menu windows
.if LANG_EN
StatusTitleWindow:                      make_window BG2A, {1, 1}, {6, 1}
.else
StatusTitleWindow:                      make_window BG2A, {1, 1}, {5, 1}
.endif
StatusCmdWindow:                        make_window BG2A, {17, 10}, {9, 6}
StatusMainWindow:                       make_window BG2A, {1, 1}, {28, 24}

; gogo window is in 2 parts
StatusGogoWindow:                       make_window BG2A, {31, 1}, {0, 18}
                                        make_window BG2B, {31, 0}, {7, 18}

; ------------------------------------------------------------------------------

; [ draw character info on status menu (white text) ]

DrawStatusCharInfo:
@5f8d:  clr_a
        lda     zSelIndex
        asl
        tax
        jmp     (near DrawStatusCharInfoTbl,x)

DrawStatusCharInfoTbl:
        make_jump_tbl DrawStatusCharInfo, 4

; ------------------------------------------------------------------------------

; [ draw status info for character slot 1 ]

make_jump_label DrawStatusCharInfo, 0
@5f9d:  ldx     zCharPropPtr::Slot1
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::Slot1
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 2 ]

make_jump_label DrawStatusCharInfo, 1
@5fa7:  ldx     zCharPropPtr::Slot2
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::Slot2
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 3 ]

make_jump_label DrawStatusCharInfo, 2
@5fb1:  ldx     zCharPropPtr::Slot3
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::Slot3
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 4 ]

make_jump_label DrawStatusCharInfo, 3
@5fbb:  ldx     zCharPropPtr::Slot4
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::Slot4
; fallthrough

DrawStatusCharInfoAll:
@5fc2:  jsl     UpdateEquip_ext
        ldy     zSelCharPropPtr
        jsr     CheckHandEffects
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        lda     $11a6
        jsr     HexToDec3
        ldx_pos BG3A, {12, 26}
        jsr     DrawNum3
        lda     $11a4
        jsr     HexToDec3
        ldx_pos BG3A, {12, 28}
        jsr     DrawNum3
        lda     $11a2
        jsr     HexToDec3
        ldx_pos BG3A, {12, 30}
        jsr     DrawNum3
        lda     $11a0
        jsr     HexToDec3
        ldx_pos BG3C, {12, 0}
        jsr     DrawNum3
        jsr     CalcNewBattlePower
        lda     $11ac
        clc
        adc     $11ad
        sta     zf3
        clr_a
        adc     #0
        sta     zf4
        jsr     HexToDec5
        ldx_pos BG3A, {26, 24}
        jsr     Draw16BitNum
        lda     $11ba
        jsr     HexToDec3
        ldx_pos BG3A, {26, 26}
        jsr     DrawNum3
        lda     $11a8
        jsr     HexToDec3
        ldx_pos BG3A, {26, 28}
        jsr     DrawNum3
        lda     $11bb
        jsr     HexToDec3
        ldx_pos BG3A, {26, 30}
        jsr     DrawNum3
        lda     $11aa
        jsr     HexToDec3
        ldx_pos BG3C, {26, 0}
        jsr     DrawNum3
.if LANG_EN
        ldy_pos BG1A, {3, 5}
        jsr     DrawCharName
        ldy_pos BG1A, {10, 5}
        jsr     DrawCharTitle
        ldy_pos BG1A, {20, 5}
.else
        ldy_pos BG1A, {3, 4}
        jsr     DrawCharName
        ldy_pos BG1A, {10, 4}
        jsr     DrawCharTitle
        ldy_pos BG1A, {20, 4}
.endif
        jsr     DrawEquipGenju
        jsr     _c36102
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near _c36096
        jsr     DrawCharBlock
        ldx     zSelCharPropPtr
        lda     a:$0011,x
        sta     zf1
        lda     a:$0012,x
        sta     zf2
        lda     a:$0013,x
        sta     zf3
        jsr     HexToDec8
        ldx_pos BG3A, {7, 18}
        jsr     DrawNum8
        jsr     CalcNextLevelExp
        jsr     HexToDec8
        ldx_pos BG3A, {7, 22}
        jsr     DrawNum8
        stz     z47
        jsr     ExecTasks
        jmp     _c3625b

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (status)
_c36096:
        make_pos BG1A, {15, 7}
        make_pos BG1A, {13, 8}
        make_pos BG1A, {18, 8}
        make_pos BG1A, {13, 9}
        make_pos BG1A, {18, 9}

; ------------------------------------------------------------------------------

; [ calculate experience needed to reach next level ]

.proc CalcNextLevelExp
        ldx     zSelCharPropPtr
        clr_a
        lda     a:$0008,x
        cmp     #99
        beq     max_level
        jsr     CalcLevelExpTotal
        ldx     zSelCharPropPtr
        sec
        lda     $f1
        sbc     a:$0011,x
        sta     $f1
        longa
        lda     $f2
        sbc     a:$0012,x
        sta     $f2
        shorta
        rts

max_level:
        clr_ax
        stx     $f1
        stz     $f3
        rts
.endproc  ; CalcNextLevelExp

; ------------------------------------------------------------------------------

; [ calculate total experience for level -> ++$f3 ]

; A: level

.proc CalcLevelExpTotal
        asl
        sta     $eb
        clr_ax
        stx     $f1
        stx     $f3
        stz     $ec
loop:   clc
        lda     f:LevelUpExp,x   ; experience progression data
        adc     $f1
        sta     $f1
        inx
        lda     f:LevelUpExp,x
        adc     $f2
        sta     $f2
        clr_a
        adc     $f3
        sta     $f3
        inx
        cpx     $eb
        bne     loop
        longa
.repeat 3
        asl     $f1
        rol     $f3
.endrep
        shorta
        rts
.endproc  ; CalcLevelExpTotal

; ------------------------------------------------------------------------------

; [  ]

_c36102:
.if LANG_EN
        @Y_POS = 14
.else
        @Y_POS = 13
.endif
@6102:  ldy_pos BG3A, {20, @Y_POS}
        jsr     InitTextBuf
        jsr     DrawCmdName
        ldy_pos BG3A, {20, @Y_POS+2}
        jsr     InitTextBuf
        iny
        jsr     DrawCmdName
        ldy_pos BG3A, {20, @Y_POS+4}
        jsr     InitTextBuf
        iny2
        jsr     DrawCmdName
        ldy_pos BG3A, {20, @Y_POS+6}
        jsr     InitTextBuf
        iny3
        jmp     DrawCmdName

; ------------------------------------------------------------------------------

; [ check relic-upgraded battle commands ]

CheckRelicCmd:
@612c:  lda     $0016,y     ; battle command
        cmp     #$02        ; command $02 (magic)
        bne     @613e
        phy
        jsr     CheckMPVisible
        bcs     @613d
        ply
        lda     #$ff
        rts
@613d:  ply
@613e:  lda     $0016,y
        cmp     #$03        ; command $03 (morph)
        bne     @614f
        lda     $1dd1
        bit     #$04
        bne     @614f
        lda     #$ff
        rts
@614f:  lda     $0016,y
        cmp     #$11        ; command $11 (leap)
        bne     @6160
        lda     $11e4
        bit     #$04
        bne     @6160
        lda     #$ff
        rts
@6160:  lda     $0016,y
        cmp     #$13        ; command $13 (dance)
        bne     @616f
        lda     $1d4c
        bne     @616f
        lda     #$ff
        rts
@616f:  lda     $0016,y
        sta     $e0
        clr_ax
        lda     $11d6       ; relic effects 2 (modified commands)
        and     #$7c
        asl
@617c:  asl
        bcc     @6189
        pha
        lda     f:RelicCmdTbl1,x
        cmp     $e0
        beq     @6192
        pla
@6189:  inx
        cpx     #5
        bne     @617c
        lda     $e0
        rts
@6192:  pla
        lda     f:RelicCmdTbl2,x
        rts

; ------------------------------------------------------------------------------

; base commands (steal, slot, sketch, magic, fight)
RelicCmdTbl1:
@6198:  .byte   $05,$0f,$0d,$02,$00

; relic-modified commands (capture, gp rain, control, x-magic, jump)
RelicCmdTbl2:
@619d:  .byte   $06,$18,$0e,$17,$16

; ------------------------------------------------------------------------------

; [ create portrait task for sub-menus ]

ChangeStatusPortraitTask:
@61a2:  clr_a
        lda     $60
        tax
        lda     #$ff
        sta     $7e35c9,x

CreateSubPortraitTask:
@61ac:  jsr     CreateOnePortraitTask
        jmp     InitSubPortraitTask

; ------------------------------------------------------------------------------

; [ create portrait task for equip/relic menu ]

CreateEquipPortraitTask:
@61b2:  jsr     CreateOnePortraitTask
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     #$00c8                  ; x position
        sta     near wTaskPosX,x
        shorta
        clr_a
        lda     zSelIndex
        tay
.if LANG_EN
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0030                  ; y position
        sta     near wTaskPosY,x
        shorta
        jsr     InitAnimTask
.else
        jsr     SetSubPortraitPos
.endif
        plb
        rts

; ------------------------------------------------------------------------------

; [ create single portrait task ]

CreateOnePortraitTask:
@61da:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     $60
        rts

; ------------------------------------------------------------------------------

; [ init sub-menu portrait task ]

InitSubPortraitTask:
@61e6:  phb
        lda     #$7e
        pha
        plb
        clr_a
        lda     zSelIndex
        tay
        jsr     InitPortraitRowPos
        clr_a
        lda     zSelIndex
        tay
        jsr     SetSubPortraitPos
        plb
        rts

; ------------------------------------------------------------------------------

; [ set sub-menu portrait position ]

SetSubPortraitPos:
@61fb:  jsr     GetPortraitAnimDataPtr
        longa
.if LANG_EN
        lda     #$0038                  ; y position
.else
        lda     #$0030                  ; y position
.endif
        sta     near wTaskPosY,x
        shorta
        jmp     InitAnimTask

; ------------------------------------------------------------------------------

; [ init bg3 scroll hdma data for status menu ]

InitStatusBG3ScrollHDMA:
@620b:  lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near StatusBG3ScrollHDMA
        sty     hDMA5::ADDR
        lda     #^StatusBG3ScrollHDMA
        sta     hDMA5::ADDR_B
        lda     #^StatusBG3ScrollHDMA
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; hdma data for status menu
StatusBG3ScrollHDMA:
@622a:  .byte   $27,$00,$00
        .byte   $0c,$04,$00
        .byte   $0c,$08,$00
        .byte   $0c,$0c,$00
        .byte   $0c,$10,$00
        .byte   $0c,$14,$00
        .byte   $0c,$18,$00
        .byte   $0c,$1c,$00
        .byte   $0c,$20,$00
        .byte   $0c,$24,$00
        .byte   $0c,$28,$00
        .byte   $0c,$2c,$00
        .byte   $0c,$30,$00
        .byte   $0c,$34,$00
        .byte   $0c,$38,$00
        .byte   $0c,$3c,$00
        .byte   $00

; ------------------------------------------------------------------------------

; [ draw status icons in status menu ]

_c3625b:
.if LANG_EN
@625b:  ldy_pos BG1A, {10, 5}
        ldx     #$2050
.else
        ldy_pos BG1A, {10, 2}
        ldx     #$1050
.endif
        stx     $e7
        jsr     InitTextBuf
        lda     $0014,y
        bmi     @62e7
        and     #$70
        sta     $e1
        lda     $0014,y
        and     #$07
        asl
        sta     $e2
        lda     $0015,y
        and     #$80
        ora     $e1
        ora     $e2
        sta     $e1
        beq     @62e1
        stz     $f1
        stz     $f2
        ldx     #$0007
@628b:  phx
        asl
        bcc     @62d5
        pha
        lda     #3
        ldy     #near CharIconTask
        jsr     CreateTask
        lda     #$01
        sta     wTaskFlags,x
        clr_a
        sta     wTaskState,x
        txy
        ldx     $f1
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:StatusIconAnimPtrs,x   ; pointers to status icon sprite data
        sta     near wTaskAnimPtr,y
        shorta
        lda     $e7
        sta     near wTaskPosX,y
        lda     $e8
        sta     near wTaskPosY,y
        clr_a
        sta     near {wTaskPosX + 1},y
        sta     near {wTaskPosY + 1},y
        lda     #^StatusIconAnimPtrs
        sta     near wTaskAnimBank,y
        plb
        clc
        lda     #$0a
        adc     $e7
        sta     $e7
        pla
@62d5:  inc     $f1
        inc     $f1
        plx
        dex
        bne     @628b
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
@62e1:  jsr     _c36306
        jmp     DrawPosTextBuf
@62e7:  ldx     #$9e8b
        stx     hWMADDL
        ldx     z0
@62ef:  lda     f:MainMenuWoundedText,x
        sta     hWMDATA
        inx
        cpx     #sizeof_MainMenuWoundedText
        bne     @62ef
        stz     hWMDATA
        lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ hide "wounded" text ]

_c36306:
@6306:  ldx     #$9e8b
        stx     hWMADDL
        ldx     z0
        lda     #$ff
@6310:  sta     hWMDATA
        inx
        cpx     #$0008
        bne     @6310
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ menu state $42: party select status menu (init) ]

MenuState_42:
@631d:  jsr     DisableInterrupts
        lda     w0200
        sta     z22
        stz     w0200
        stz     z25
        lda     #BIT_6
        trb     zEnableHDMA
        jsr     InitStatusBG3ScrollHDMA
        jsr     _c36354
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #$43
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $43: party select status menu ]

MenuState_43:
@633f:  lda     z08+1
        bit     #>JOY_B
        beq     @6353
        jsr     PlayCancelSfx
        lda     z4c
        sta     zNextMenuState
        stz     zMenuState
        lda     z22
        sta     w0200
@6353:  rts

; ------------------------------------------------------------------------------

; [  ]

_c36354:
@6354:  jsr     DrawStatusMainWindow
        jsr     DrawStatusLabelText
        jsr     _c36379
        jsr     DrawStatusCharInfoAll
        jsr     TfrStatusMenu
        jsr     CreateOnePortraitTask
        phb
        lda     #$7e
        pha
        plb
        clr_a
        lda     zSelIndex
        tay
        jsr     _c3638e
        clr_ay
        jsr     SetSubPortraitPos
        plb
        rts

; ------------------------------------------------------------------------------

; [ get char index for status window (party select) ]

_c36379:
@6379:  clr_a
        lda     zc9
        sta     zSelIndex
        asl
        tax
        longa
        lda     f:CharPropPtrs,x   ; pointers to character data
        sta     zSelCharPropPtr
        shorta
        clr_a
        lda     zc9
        rts

; ------------------------------------------------------------------------------

; [ get portrait X position for status window (party select) ]

_c3638e:
@638e:  lda     $1850,y
        bit     #$20
        beq     @639c
        longa
        lda     #$001a
        bra     @63a1
@639c:  longa
        lda     #$000e
@63a1:  sta     near wTaskPosX,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ menu state $6a: gogo command list ]

MenuState_6a:
@63a7:  jsr     UpdateGogoCmdListCursor
        lda     z08
        bit     #JOY_A
        beq     @63da
        jsr     PlaySelectSfx
        stz     a:z65
        clr_a
        lda     z4b
        tax
        lda     $7e9d8a,x
        sta     ze0
        clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x
        longa
        tya
        clc
        adc     z64
        tay
        shorta
        lda     ze0
        sta     $0016,y
        jsr     _c36102
        bra     @63e3
@63da:  lda     z08+1
        bit     #>JOY_B
        beq     @6402
        jsr     PlayCancelSfx
@63e3:  lda     #$01
        trb     z46
        lda     #6
        sta     zWaitCounter
        ldy     #.loword(-12)
        sty     zMenuScrollRate
        lda     #MENU_STATE::STATUS_SELECT
        sta     zNextMenuState
        lda     #$65
        sta     zMenuState
        jsr     LoadGogoStatusCursor
        lda     z5e
        sta     z4e
        jsr     InitGogoStatusCursor
@6402:  rts

; ------------------------------------------------------------------------------

; [ load cursor for gogo command list select ]

LoadGogoCmdListCursor:
@6403:  ldy     #near GogoCmdListProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor positions for gogo command list select ]

UpdateGogoCmdListCursor:
@6409:  jsr     MoveCursor

InitGogoCmdListCursor:
@640c:  ldy     #near GogoCmdListPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GogoCmdListProp:
@6412:  .byte   $80,$00,$00,$01,$10

GogoCmdListPos:
.if LANG_EN
@6417:  .word   $10f0,$1cf0,$28f0,$34f0,$40f0,$4cf0,$58f0,$64f0
        .word   $70f0,$7cf0,$88f0,$94f0,$a0f0,$acf0,$b8f0,$c4f0
.else
        .word   $10f8,$1cf8,$28f8,$34f8,$40f8,$4cf8,$58f8,$64f8
        .word   $70f8,$7cf8,$88f8,$94f8,$a0f8,$acf8,$b8f8,$c4f8
.endif

; ------------------------------------------------------------------------------

.if LANG_EN
        .define StatusTitleStr                  {$92,$ad,$9a,$ad,$ae,$ac,$00}
        .define StatusSlashStr                  {$c0,$00}
        .define StatusPercentStr                {$cd,$00}
        .define StatusLevelStr                  {$8b,$95,$00}
        .define StatusHPStr                     {$87,$8f,$00}
        .define StatusMPStr                     {$8c,$8f,$00}
        .define StatusStrengthStr               {$95,$a2,$a0,$a8,$ab,$00}
        .define StatusStaminaStr                {$92,$ad,$9a,$a6,$a2,$a7,$9a,$00}
        .define StatusMagPwrStr                 {$8c,$9a,$a0,$c5,$8f,$b0,$ab,$00}
        .define StatusEvadeStr                  {$84,$af,$9a,$9d,$9e,$ff,$cd,$00}
        .define StatusMagEvadeStr               {$8c,$81,$a5,$a8,$9c,$a4,$cd,$00}
        .define StatusSepStr                    {$d3,$00}
        .define StatusSpeedStr                  {$92,$a9,$9e,$9e,$9d,$00}
        .define StatusAttackPwrStr              {$81,$9a,$ad,$c5,$8f,$b0,$ab,$00}
        .define StatusDefenseStr                {$83,$9e,$9f,$9e,$a7,$ac,$9e,$00}
        .define StatusMagDefStr                 {$8c,$9a,$a0,$c5,$83,$9e,$9f,$00}
        .define StatusYourExpStr                {$98,$a8,$ae,$ab,$ff,$84,$b1,$a9,$c1,$00}
        .define StatusLevelUpExpStr             {$85,$a8,$ab,$ff,$a5,$9e,$af,$9e,$a5,$ff,$ae,$a9,$c1,$00}
.else
; need to translate to jp
        .define StatusTitleStr                  {$78,$84,$c5,$7e,$78,$00}
        .define StatusSlashStr                  {$ce,$00}
        .define StatusPercentStr                {$cd,$00}
        .define StatusLevelStr                  {$2b,$35,$00}
        .define StatusHPStr                     {$27,$2f,$00}
        .define StatusMPStr                     {$2c,$2f,$00}
        .define StatusStrengthStr               {$81,$6b,$a7,$00}
        .define StatusStaminaStr                {$7f,$8d,$a9,$c3,$6f,$00}
        .define StatusMagPwrStr                 {$9d,$a9,$c3,$6f,$00}
        .define StatusEvadeStr                  {$6b,$8d,$63,$a9,$83,$00}
        .define StatusMagEvadeStr               {$9d,$69,$89,$6b,$8d,$63,$a9,$83,$ff,$c7,$00}
        .define StatusSepStr                    {$c7,$00}
        .define StatusSpeedStr                  {$79,$21,$b1,$75,$00}
        .define StatusAttackPwrStr              {$73,$89,$31,$6d,$a9,$c3,$6f,$ff,$ff,$c7,$00}
        .define StatusDefenseStr                {$29,$89,$2d,$c3,$00}
        .define StatusMagDefStr                 {$9d,$69,$89,$29,$89,$2d,$c3,$ff,$ff,$c7,$00}
        .define StatusYourExpStr                {$31,$b9,$35,$8d,$9b,$71,$8d,$71,$b9,$81,$00}
        .define StatusLevelUpExpStr             {$83,$2d,$9b,$ac,$26,$aa,$9d,$45,$ff,$8b,$87,$00}
.endif

StatusBtmLabelTextList1:
@6437:  .addr   StatusStrengthText
        .addr   StatusStaminaText
        .addr   StatusMagPwrText
        .addr   StatusEvadeText
        .addr   StatusMagEvadeText
        .addr   StatusStrengthSepText
        .addr   StatusSpeedSepText
        .addr   StatusStaminaSepText
        .addr   StatusMagPwrSepText
        .addr   StatusDefenseSepText
        .addr   StatusEvadeSepText
.if LANG_EN
        .addr   StatusAttackPwrSepText
        .addr   StatusMagDefSepText
        .addr   StatusMagEvadeSepText
.endif
        .addr   StatusTitleText
        calc_size StatusBtmLabelTextList1

StatusTopLabelTextList2:
@6455:  .addr   StatusLevelText
        .addr   StatusHPText
        .addr   StatusMPText
        calc_size StatusTopLabelTextList2

StatusTopLabelTextList1:
@645b:  .addr   StatusHPSlashText
        .addr   StatusMPSlashText
        .addr   StatusEvadePercentText
        .addr   StatusMagEvadePercentText
        calc_size StatusTopLabelTextList1

StatusBtmLabelTextList2:
@6463:  .addr   StatusSpeedText
        .addr   StatusAttackPwrText
        .addr   StatusDefenseText
        .addr   StatusMagDefText
        .addr   StatusYourExpText
        .addr   StatusLevelUpExpText
        calc_size StatusBtmLabelTextList2

StatusTitleText:                pos_text BG3A, {2, 2}, StatusTitleStr
StatusHPSlashText:              pos_text BG1A, {17, 8}, StatusSlashStr
StatusMPSlashText:              pos_text BG1A, {17, 9}, StatusSlashStr
StatusEvadePercentText:         pos_text BG3A, {29, 28}, StatusPercentStr
StatusMagEvadePercentText:      pos_text BG3C, {29, 0}, StatusPercentStr
StatusLevelText:                pos_text BG1A, {10, 7}, StatusLevelStr
StatusHPText:                   pos_text BG1A, {10, 8}, StatusHPStr
StatusMPText:                   pos_text BG1A, {10, 9}, StatusMPStr
.if LANG_EN
StatusStrengthText:             pos_text BG3A, {3, 26}, StatusStrengthStr
StatusStaminaText:              pos_text BG3A, {3, 30}, StatusStaminaStr
StatusMagPwrText:               pos_text BG3C, {3, 0}, StatusMagPwrStr
.else
StatusStrengthText:             pos_text BG3A, {4, 26}, StatusStrengthStr
StatusStaminaText:              pos_text BG3A, {4, 30}, StatusStaminaStr
StatusMagPwrText:               pos_text BG3C, {4, 0}, StatusMagPwrStr
.endif
StatusEvadeText:                pos_text BG3A, {16, 28}, StatusEvadeStr
StatusMagEvadeText:             pos_text BG3C, {16, 0}, StatusMagEvadeStr
StatusStrengthSepText:          pos_text BG3A, {10, 26}, StatusSepStr
StatusSpeedSepText:             pos_text BG3A, {10, 28}, StatusSepStr
StatusStaminaSepText:           pos_text BG3A, {10, 30}, StatusSepStr
StatusMagPwrSepText:            pos_text BG3C, {10, 0}, StatusSepStr
StatusDefenseSepText:           pos_text BG3A, {25, 26}, StatusSepStr
StatusEvadeSepText:             pos_text BG3A, {25, 28}, StatusSepStr
.if LANG_EN
StatusAttackPwrSepText:         pos_text BG3A, {25, 24}, StatusSepStr
StatusMagDefSepText:            pos_text BG3A, {25, 30}, StatusSepStr
StatusMagEvadeSepText:          pos_text BG3C, {25, 0}, StatusSepStr
StatusSpeedText:                pos_text BG3A, {3, 28}, StatusSpeedStr
StatusAttackPwrText:            pos_text BG3A, {16, 24}, StatusAttackPwrStr
StatusDefenseText:              pos_text BG3A, {16, 26}, StatusDefenseStr
StatusMagDefText:               pos_text BG3A, {16, 30}, StatusMagDefStr
StatusYourExpText:              pos_text BG3A, {2, 16}, StatusYourExpStr
StatusLevelUpExpText:           pos_text BG3A, {2, 20}, StatusLevelUpExpStr
.else
StatusSpeedText:                pos_text BG3A, {4, 27}, StatusSpeedStr
StatusAttackPwrText:            pos_text BG3A, {16, 23}, StatusAttackPwrStr
StatusDefenseText:              pos_text BG3A, {16, 25}, StatusDefenseStr
StatusMagDefText:               pos_text BG3A, {16, 29}, StatusMagDefStr
StatusYourExpText:              pos_text BG3A, {4, 15}, StatusYourExpStr
StatusLevelUpExpText:           pos_text BG3A, {4, 19}, StatusLevelUpExpStr
.endif

; ------------------------------------------------------------------------------
