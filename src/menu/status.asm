
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

.include "src/text/battle_cmd_name.inc"

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

; [ redraw status menu after changing characters ]

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
        ldy     zZero
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
        cmp     #BATTLE_CMD::MIMIC
        beq     @5e60
        sta     ze0
        asl
        tax
        lda     f:BattleCmdProp,x
        and     #BATTLE_CMD_FLAG::GOGO
        beq     @5e60                   ; branch if can't be used by gogo
        lda     ze0
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
        sta     ze2                     ; number of available commands
        clc
        adc     ze2
        adc     ze2
        and     #$fe
        beq     @5e90
        inc2
@5e90:  lsr
        sta     $7eaa90                 ; set window height
        sta     $7eaa94
        ldy     #$aa8d
        lda     #$7e
        sta     ze9
        jsr     DrawWindowFar
        ldy     #$aa91
        lda     #$7e
        sta     ze9
        jsr     DrawWindowFar
        lda     $7e9d89
        sta     ze5
        stz     ze6
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
        cpx     ze5
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
        sta     ze2
.endif
        pha
        asl2
        sta     ze0
        pla
        asl
        clc
        adc     ze0
.if LANG_EN
        adc     ze2
.endif
        tax
        ldy     #BATTLE_CMD_NAME::ITEM_SIZE
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
@5f50:  op_pos  ldx #1+, BG2B, {0, 6}
        stx     ze7
        lda     #$7e
        sta     ze9
        ldx     #6                      ; *** bug *** should be 7 for english version
@5f5c:  clr_ay
        lda     #$3d                    ; high priority tile flags
@5f60:  sta     [ze7],y
        iny2
        cpy     #9*2
        bne     @5f60
        longa
        lda     ze7
        clc
        adc     #$0040
        sta     ze7
        shorta
        dex
        bne     @5f5c
        rts

; ------------------------------------------------------------------------------

; status menu windows
.if LANG_EN
StatusTitleWindow:                      window_pos BG2A, {1, 1}, {6, 1}
.else
StatusTitleWindow:                      window_pos BG2A, {1, 1}, {5, 1}
.endif
StatusCmdWindow:                        window_pos BG2A, {17, 10}, {9, 6}
StatusMainWindow:                       window_pos BG2A, {1, 1}, {28, 24}

; gogo window is in 2 parts, height gets changed dynamically
StatusGogoWindow:                       window_pos BG2A, {31, 1}, {0, 18}
                                        window_pos BG2B, {31, 0}, {7, 18}

; ------------------------------------------------------------------------------

; [ draw character info on status menu (white text) ]

.proc DrawStatusCharInfo

@5f8d:  clr_a
        lda     zSelIndex
        asl
        tax
        jmp     (near DrawStatusCharInfoTbl,x)

.endproc  ; DrawStatusCharInfo

.enum DRAW_STATUS_CHAR_INFO
        COUNT = 4
.endenum

DrawStatusCharInfoTbl:
        ptr_tbl DRAW_STATUS_CHAR_INFO

; ------------------------------------------------------------------------------

; [ draw status info for character slot 1 ]

        array_label DRAW_STATUS_CHAR_INFO, 0
@5f9d:  ldx     zCharPropPtr::_0
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::_0
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 2 ]

        array_label DRAW_STATUS_CHAR_INFO, 1
@5fa7:  ldx     zCharPropPtr::_1
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::_1
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 3 ]

        array_label DRAW_STATUS_CHAR_INFO, 2
@5fb1:  ldx     zCharPropPtr::_2
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::_2
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 4 ]

        array_label DRAW_STATUS_CHAR_INFO, 3
@5fbb:  ldx     zCharPropPtr::_3
        stx     zSelCharPropPtr
        clr_a
        lda     zCharID::_3
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
        jsr     CalcNewAttackPower
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
.if ::LANG_EN
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
        jsr     DrawCharGenjuName
        jsr     _c36102
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near StatusCharBlockTextPosTbl
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
        stz     z47                     ; terminate group 1 sprite tasks
        jsr     ExecTasks
        jmp     _c3625b

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (status)
StatusCharBlockTextPosTbl:
        bg_pos BG1A, {15, 7}
        bg_pos BG1A, {13, 8}
        bg_pos BG1A, {18, 8}
        bg_pos BG1A, {13, 9}
        bg_pos BG1A, {18, 9}

; ------------------------------------------------------------------------------

; [ calculate experience needed to reach next level ]

.proc CalcNextLevelExp
        ldx     zSelCharPropPtr
        clr_a
        lda     a:$0008,x
        cmp     #MAX_LEVEL
        beq     max_level
        jsr     CalcLevelExpTotal
        ldx     zSelCharPropPtr
        sec
        lda     zf1
        sbc     a:$0011,x
        sta     zf1
        longa
        lda     zf2
        sbc     a:$0012,x
        sta     zf2
        shorta
        rts

max_level:
        clr_ax
        stx     zf1
        stz     zf3
        rts
.endproc  ; CalcNextLevelExp

; ------------------------------------------------------------------------------

; [ calculate total experience for level -> ++$f3 ]

; A: level

.proc CalcLevelExpTotal
        asl
        sta     zeb
        clr_ax
        stx     zf1
        stx     zf3
        stz     zec
loop:   clc
        lda     f:LevelUpExp,x   ; experience progression data
        adc     zf1
        sta     zf1
        inx
        lda     f:LevelUpExp,x
        adc     zf2
        sta     zf2
        clr_a
        adc     zf3
        sta     zf3
        inx
        cpx     zeb
        bne     loop
        longa
        .repeat 3
        asl     zf1
        rol     zf3
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
        cmp     #BATTLE_CMD::MAGIC
        bne     @613e
        phy
        jsr     CheckMPVisible
        bcs     @613d
        ply
        lda     #$ff
        rts
@613d:  ply
@613e:  lda     $0016,y
        cmp     #BATTLE_CMD::MORPH
        bne     @614f
        lda     $1dd1
        bit     #$04
        bne     @614f
        lda     #$ff
        rts
@614f:  lda     $0016,y
        cmp     #BATTLE_CMD::LEAP
        bne     @6160
        lda     $11e4
        bit     #$04
        bne     @6160
        lda     #$ff
        rts
@6160:  lda     $0016,y
        cmp     #BATTLE_CMD::DANCE
        bne     @616f
        lda     $1d4c
        bne     @616f
        lda     #$ff
        rts
@616f:  lda     $0016,y
        sta     ze0
        clr_ax
        lda     $11d6       ; relic effects 2 (modified commands)
        and     #$7c
        asl
@617c:  asl
        bcc     @6189
        pha
        lda     f:RelicCmdTbl1,x
        cmp     ze0
        beq     @6192
        pla
@6189:  inx
        cpx     #5
        bne     @617c
        lda     ze0
        rts
@6192:  pla
        lda     f:RelicCmdTbl2,x
        rts

; ------------------------------------------------------------------------------

; base commands
RelicCmdTbl1:
        .byte   BATTLE_CMD::STEAL
        .byte   BATTLE_CMD::SLOT
        .byte   BATTLE_CMD::SKETCH
        .byte   BATTLE_CMD::MAGIC
        .byte   BATTLE_CMD::FIGHT

; relic-modified commands
RelicCmdTbl2:
        .byte   BATTLE_CMD::CAPTURE
        .byte   BATTLE_CMD::GP_RAIN
        .byte   BATTLE_CMD::CONTROL
        .byte   BATTLE_CMD::X_MAGIC
        .byte   BATTLE_CMD::JUMP

; ------------------------------------------------------------------------------

; [ create portrait task for sub-menus ]

ChangeStatusPortraitTask:
@61a2:  clr_a
        lda     z60
        tax
        lda     #$ff
        sta     wTaskProp::w7e35c9,x

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
        sta     near wTaskProp::PosX_H,x
        shorta
        clr_a
        lda     zSelIndex
        tay
.if LANG_EN
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0030                  ; y position
        sta     near wTaskProp::PosY_H,x
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
        sta     z60
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
        sta     near wTaskProp::PosY_H,x
        shorta
        jmp     InitAnimTask

; ------------------------------------------------------------------------------

; [ init bg3 scroll hdma data for status menu ]

InitStatusBG3ScrollHDMA:
@620b:  lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near StatusBG3ScrollHDMATbl
        sty     hDMA5::ADDR
        lda     #^StatusBG3ScrollHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^StatusBG3ScrollHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; hdma data for status menu
StatusBG3ScrollHDMATbl:
        hdma_word 39, 0
        hdma_word 12, 4
        hdma_word 12, 8
        hdma_word 12, 12
        hdma_word 12, 16
        hdma_word 12, 20
        hdma_word 12, 24
        hdma_word 12, 28
        hdma_word 12, 32
        hdma_word 12, 36
        hdma_word 12, 40
        hdma_word 12, 44
        hdma_word 12, 48
        hdma_word 12, 52
        hdma_word 12, 56
        hdma_word 12, 60
        hdma_end

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
        stx     ze7
        jsr     InitTextBuf
        lda     $0014,y
        bmi     @62e7
        andflg  STATUS1, {PETRIFY, IMP, VANISH}
        sta     ze1
        lda     $0014,y
        andflg  STATUS1, {POISON, ZOMBIE, BLIND}
        asl
        sta     ze2
        lda     $0015,y
        and     #STATUS4::FLOAT
        ora     ze1
        ora     ze2
        sta     ze1
        beq     @62e1
        stz     zf1
        stz     zf2
        ldx     #7
@628b:  phx
        asl
        bcc     @62d5
        pha
        lda     #3
        ldy     #near CharIconTask
        jsr     CreateTask
        lda     #$01
        sta     wTaskProp::Flags,x
        clr_a
        sta     wTaskProp::State,x
        txy
        ldx     zf1
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:StatusIconAnimPtrs,x   ; pointers to status icon sprite data
        sta     near wTaskProp::AnimPtr,y
        shorta
        lda     ze7
        sta     near wTaskProp::PosX_H,y
        lda     ze8
        sta     near wTaskProp::PosY_H,y
        clr_a
        sta     near wTaskProp::PosX + 2,y
        sta     near wTaskProp::PosY + 2,y
        lda     #^StatusIconAnimPtrs
        sta     near wTaskProp::AnimBank,y
        plb
        clc
        lda     #10
        adc     ze7
        sta     ze7
        pla
@62d5:  inc     zf1
        inc     zf1
        plx
        dex
        bne     @628b
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
@62e1:  jsr     _c36306
        jmp     DrawPosTextBuf
@62e7:  ldx     #$9e8b
        stx     hWMADDL
        ldx     zZero
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
        ldx     zZero
        lda     #$ff
@6310:  sta     hWMDATA
        inx
        cpx     #$0008
        bne     @6310
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ menu state $42: party select status menu (init) ]

        array_label MENU_STATE, MENU_STATE::PARTY_STATUS_INIT
@631d:  jsr     DisableInterrupts
        lda     r0200
        sta     z22
        stz     r0200
        stz     z25
        lda     #BIT_6
        trb     zEnableHDMA
        jsr     InitStatusBG3ScrollHDMA
        jsr     _c36354
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #MENU_STATE::PARTY_STATUS_WAIT
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $43: party select status menu ]

        array_label MENU_STATE, MENU_STATE::PARTY_STATUS_WAIT
@633f:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @6353
        jsr     PlayCancelSfx
        lda     z4c
        sta     zNextMenuState
        stz     zMenuState
        lda     z22
        sta     r0200
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
@63a1:  sta     near wTaskProp::PosX_H,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ menu state $6a: gogo command list ]

        array_label MENU_STATE, MENU_STATE::STATUS_GOGO
@63a7:  jsr     UpdateGogoCmdListCursor
        lda     zNewCtrlState_L
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
@63da:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @6402
        jsr     PlayCancelSfx
@63e3:  lda     #$01
        trb     z46
        lda     #6
        sta     zWaitCounter
        ldy     #near -12
        sty     zMenuScrollRate
        lda     #MENU_STATE::STATUS_WAIT
        sta     zNextMenuState
        lda     #MENU_STATE::H_SCROLL
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
        cursor_prop {0, 0}, {1, 16}, NO_X_WRAP

GogoCmdListPos:
.if LANG_EN
        @X_OFFSET = 240
.else
        @X_OFFSET = 248
.endif
        .repeat 16, i
        cursor_pos {@X_OFFSET, 16 + i * 12}
        .endrep

; ------------------------------------------------------------------------------

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

StatusTitleText:                pos_text STATUS_TITLE
StatusHPSlashText:              pos_text STATUS_HP_SLASH
StatusMPSlashText:              pos_text STATUS_MP_SLASH
StatusEvadePercentText:         pos_text STATUS_EVADE_PERCENT
StatusMagEvadePercentText:      pos_text STATUS_MAG_EVADE_PERCENT
StatusLevelText:                pos_text STATUS_LEVEL
StatusHPText:                   pos_text STATUS_HP
StatusMPText:                   pos_text STATUS_MP
StatusStrengthText:             pos_text STATUS_STRENGTH
StatusStaminaText:              pos_text STATUS_STAMINA
StatusMagPwrText:               pos_text STATUS_MAG_PWR
StatusEvadeText:                pos_text STATUS_EVADE
StatusMagEvadeText:             pos_text STATUS_MAG_EVADE
StatusStrengthSepText:          pos_text STATUS_STRENGTH_SEP
StatusSpeedSepText:             pos_text STATUS_SPEED_SEP
StatusStaminaSepText:           pos_text STATUS_STAMINA_SEP
StatusMagPwrSepText:            pos_text STATUS_MAG_PWR_SEP
StatusDefenseSepText:           pos_text STATUS_DEFENSE_SEP
StatusEvadeSepText:             pos_text STATUS_EVADE_SEP
.if LANG_EN
StatusAttackPwrSepText:         pos_text STATUS_ATTACK_PWR_SEP
StatusMagDefSepText:            pos_text STATUS_MAG_DEF_SEP
StatusMagEvadeSepText:          pos_text STATUS_MAG_EVADE_SEP
.endif
StatusSpeedText:                pos_text STATUS_SPEED
StatusAttackPwrText:            pos_text STATUS_ATTACK_PWR
StatusDefenseText:              pos_text STATUS_DEFENSE
StatusMagDefText:               pos_text STATUS_MAG_DEF
StatusYourExpText:              pos_text STATUS_YOUR_EXP
StatusLevelUpExpText:           pos_text STATUS_LEVEL_UP_EXP

; ------------------------------------------------------------------------------
