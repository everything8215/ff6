
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: config.asm                                                           |
; |                                                                            |
; | description: config menu                                                   |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import CharProp, WindowGfx

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ init cursor (config page 1) ]

LoadConfigPage1Cursor:
@3858:  ldy     #near ConfigPage1CursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (config page 1) ]

UpdateConfigPage1Cursor:
@385e:  jsr     MoveCursor

InitConfigPage1Cursor:
@3861:  ldy     #near ConfigPage1CursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

.if LANG_EN
        CONFIG_PAGE_1_NUM_ROWS = 9
.else
        CONFIG_PAGE_1_NUM_ROWS = 10
.endif

ConfigPage1CursorProp:
        cursor_prop {0, 0}, {1, CONFIG_PAGE_1_NUM_ROWS}, NO_XY_WRAP

ConfigPage1CursorPos:
        .repeat CONFIG_PAGE_1_NUM_ROWS, i
        cursor_pos {96, 41 + i * 16}
        .endrep

; ------------------------------------------------------------------------------

; [ init cursor (config page 2) ]

LoadConfigPage2Cursor:
@387e:  ldy     #near ConfigPage2CursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (config page 2) ]

UpdateConfigPage2Cursor:
@3884:  jsr     MoveCursor

InitConfigPage2Cursor:
@3887:  ldy     #near ConfigPage2CursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

ConfigPage2CursorProp:
        cursor_prop {0, 0}, {1, 6}, NO_XY_WRAP

ConfigPage2CursorPos:
@3892:  cursor_pos {96, 41}
        cursor_pos {96, 105}
        cursor_pos {96, 121}
        cursor_pos {96, 153}
        cursor_pos {96, 169}
        cursor_pos {96, 185}

; ------------------------------------------------------------------------------

; [ init config bg ]

DrawConfigMenu:
@389e:  lda     #$02
        sta     hBG1SC
        ldy     #$fffb
        sty     zBG3VScroll
        jsr     ClearBG2ScreenA
        ldy     #near ConfigMainWindow
        jsr     DrawWindow
        ldy     #near ConfigLabelWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     LoadColorBarPal
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near ConfigTitleText
        jsr     DrawPosKana
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near ConfigLabelTextList2
        ldy     #sizeof_ConfigLabelTextList2
        jsr     DrawPosKanaList
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near ConfigLabelTextList1
        ldy     #sizeof_ConfigLabelTextList1
        jsr     DrawPosList
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near ConfigSpeedTextList
        ldy     #sizeof_ConfigSpeedTextList
        jsr     DrawPosList
        jsr     DrawActiveWaitText
        jsr     DrawBattleSpeedText
        jsr     DrawMsgSpeedText
        jsr     DrawCmdConfigText
        jsr     DrawGaugeConfigText
        jsr     DrawStereoMonoText
        jsr     DrawCursorConfigText
        jsr     DrawReequipConfigText
.if !LANG_EN
        jsr     _c33dda
.endif
        jsr     DrawCtrlConfigText
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near ConfigLabelTextList3
        ldy     #sizeof_ConfigLabelTextList3
        jsr     DrawPosKanaList
        jsr     _c33950
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near ConfigLabelTextList4
        ldy     #sizeof_ConfigLabelTextList4
        jsr     DrawPosList
        jsr     DrawConfigMagicOrder
        jsr     DrawConfigWindowNumList
        jsr     DrawConfigColors
        jsr     UpdateConfigColorBars
        jsr     ShowConfigPage1
        jsr     TfrBG1ScreenAB
        jsr     TfrBG3ScreenAB
        lda     #1
        ldy     #near ConfigScrollArrowTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ draw color selector bars ]

_c33950:
@3950:  lda     #BG1_TEXT_COLOR::COLOR_BAR
        sta     zTextColor
        ldx     #near ConfigColorBarTextList
        ldy     #sizeof_ConfigColorBarTextList
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ load color bar palette ]

LoadColorBarPal:
@395e:  ldx     z0
        lda     #$40
        sta     hCGADD
@3965:  longa
        lda     f:ColorBarPal,x
        sta     wPalBuf::BGPal4,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #$0020
        bne     @3965
        rts

; ------------------------------------------------------------------------------

; [ page indicator task (config) ]

ConfigScrollArrowTask:
@3980:  tax
        jmp     (near ConfigScrollArrowTaskTbl,x)

ConfigScrollArrowTaskTbl:
@3984:  .addr   ConfigScrollArrowTask_00
        .addr   ConfigScrollArrowTask_01

; ------------------------------------------------------------------------------

; state 0: init

ConfigScrollArrowTask_00:
@3988:  ldx     zTaskOffset
        longa
        lda     #near ConfigScrollArrowAnim_00
        sta     near wTaskAnimPtr,x
        lda     #$0078
        sta     near wTaskPosX,x
        lda     #$0018
        sta     near wTaskPosY,x
        shorta
        lda     #^ConfigScrollArrowAnim_00
        sta     near wTaskAnimBank,x
        inc     near wTaskState,x
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; state 1: update

ConfigScrollArrowTask_01:
@39ab:  ldy     zTaskOffset
        lda     z4a                     ; page number
        beq     @39b5
        lda     #2                      ; page 2
        bra     @39b6
@39b5:  clr_a                           ; page 1
@39b6:  tax
        longa
        lda     f:ConfigScrollArrowAnimTbl,x
        sta     near wTaskAnimPtr,y
        shorta
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; pointers to page indicator animation data
ConfigScrollArrowAnimTbl:
@39c7:  .addr   ConfigScrollArrowAnim_00
        .addr   ConfigScrollArrowAnim_01

; page indicator animation data (pointing down)
ConfigScrollArrowAnim_00:
@39cb:  .addr   HiddenArrowSprite
        .byte   $10
        .addr   ConfigDownArrowSprite
        .byte   $10
        .addr   HiddenArrowSprite
        .byte   $ff

; page indicator animation data (pointing up)
ConfigScrollArrowAnim_01:
@39d4:  .addr   HiddenArrowSprite
        .byte   $10
        .addr   UpArrowSprite
        .byte   $10
        .addr   HiddenArrowSprite
        .byte   $ff

; page indicator sprite data (pointing down)
ConfigDownArrowSprite:
@39dd:  .byte   1
        .byte   $80,$b0,$03,$3e

; config window data
ConfigMainWindow:                       make_window BG2A, {1, 3}, {28, 22}
.if LANG_EN
ConfigLabelWindow:                      make_window BG2A, {23, 1}, {6, 2}
.else
ConfigLabelWindow:                      make_window BG2A, {24, 1}, {5, 2}
.endif

; ------------------------------------------------------------------------------

; [ switch to config page 2 ]

ShowConfigPage2:
@39ea:  ldy     #$00fb
        sty     zBG1VScroll
        jsr     LoadConfigPage2Cursor
        jmp     InitConfigPage2Cursor

; ------------------------------------------------------------------------------

; [ switch to config page 1 ]

ShowConfigPage1:
@39f5:  ldy     #$fffb
        sty     zBG1VScroll
        jsr     LoadConfigPage1Cursor
        jmp     InitConfigPage1Cursor

; ------------------------------------------------------------------------------

; [ menu state $50: scroll to config page 2 ]

MenuState_50:
@3a00:  lda     zWaitCounter
        beq     @3a15
        lda     z4a
        bne     @3a1c
        longa
        lda     zBG1VScroll
        clc
        adc     #$0010
        sta     zBG1VScroll
        shorta
        rts
@3a15:  lda     #$01
        sta     z4a
        jsr     ShowConfigPage2
@3a1c:  lda     #MENU_STATE::CONFIG_SELECT
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ menu state $51: scroll to config page 1 ]

MenuState_51:
@3a21:  lda     zWaitCounter
        beq     @3a36
        lda     z4a
        beq     @3a47
        longa
        lda     zBG1VScroll
        sec
        sbc     #$0010
        sta     zBG1VScroll
        shorta
        rts
@3a36:  stz     z4a
        ldy     #$fffb
        sty     zBG1VScroll
        jsr     LoadConfigPage1Cursor
.if LANG_EN
        lda     #$08
.else
        lda     #$09
.endif
        sta     z4e
        jsr     InitConfigPage1Cursor
@3a47:  lda     #MENU_STATE::CONFIG_SELECT
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ init window 2 position hdma ]

InitWindow2PosHDMA:
@3a4c:  lda     #$01
        sta     hDMA5::CTRL
        lda     #<hWH2
        sta     hDMA5::HREG
        ldy     #near Window2PosHDMATbl
        sty     hDMA5::ADDR
        lda     #^Window2PosHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^Window2PosHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; [ disable window 2 position hdma ]

DisableWindow2PosHDMA:
@3a6b:  lda     #$20        ; disable hdma channel #5
        trb     zEnableHDMA
        lda     #$08
        sta     hWH2
        lda     #$f7
        sta     hWH3
        rts

; ------------------------------------------------------------------------------

Window2PosHDMATbl:
        hdma_2byte 39, {$ff, $ff}
        hdma_2byte 80, {$08, $f7}
        hdma_2byte 80, {$08, $f7}
        hdma_2byte 16, {$ff, $ff}
        hdma_end

; ------------------------------------------------------------------------------

; [ load window graphics ]

LoadWindowGfx:
@3a87:  ldy     #$7800                  ; vram $7800 (menu window graphics)
        sty     zDMA1Dest
        lda     $1d4e                   ; window index
        jsr     InitTfrWindowGfx
        lda     $1d4e
        ldx     #$0060
        jsr     LoadWindowPal
        ldy     #$1c00
        jmp     SetWindowTileFlags

; ------------------------------------------------------------------------------

; [ load window graphics for save slot 1 ]

LoadSaveSlot1WindowGfx:
@3aa1:  ldy     #$7a00
        sty     zDMA1Dest
        ldy     z91
        beq     @3ab0
        lda     $30674e
        bra     @3ab1
@3ab0:  clr_a
@3ab1:  jsr     InitTfrWindowGfx
        jsr     TfrVRAM1
        ldy     #$1820
        jmp     SetWindowTileFlags

; ------------------------------------------------------------------------------

; [ load window graphics for save slot 2 ]

LoadSaveSlot2WindowGfx:
@3abd:  ldy     #$7c00
        sty     zDMA1Dest
        ldy     z93
        beq     @3acc
        lda     $30714e
        bra     @3acd
@3acc:  clr_a
@3acd:  jsr     InitTfrWindowGfx
        jsr     TfrVRAM1
        ldy     #$1440
        jmp     SetWindowTileFlags

; ------------------------------------------------------------------------------

; [ load window graphics for save slot 3 ]

LoadSaveSlot3WindowGfx:
@3ad9:  ldy     #$7e00
        sty     zDMA1Dest
        ldy     z95
        beq     @3ae8
        lda     $307b4e
        bra     @3ae9
@3ae8:  clr_a
@3ae9:  jsr     InitTfrWindowGfx
        jsr     TfrVRAM1
        ldy     #$1060
        jmp     SetWindowTileFlags

; ------------------------------------------------------------------------------

; [ load save slot 1 window palette ]

LoadSaveSlot1WindowPal:
@3af5:  ldy     z91
        beq     @3aff
        lda     $30674e
        bra     @3b00
@3aff:  clr_a
@3b00:  ldx     #$0040
        jsr     LoadWindowPal
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ load save slot 2 window palette ]

LoadSaveSlot2WindowPal:
@3b09:  ldy     z93
        beq     @3b13
        lda     $30714e
        bra     @3b14
@3b13:  clr_a
@3b14:  ldx     #$0020
        jsr     LoadWindowPal
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ load save slot 3 window palette ]

LoadSaveSlot3WindowPal:
@3b1d:  ldy     z95
        beq     @3b27
        lda     $307b4e
        bra     @3b28
@3b27:  clr_a
@3b28:  ldx     z0
        jsr     LoadWindowPal
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ init menu window graphics transfer to VRAM in DMA 1 ]

InitTfrWindowGfx:
@3b30:  and     #$0f
        sta     ze0
        stz     ze1
        ldy     #near WindowGfx
        sty     zDMA1Src
        lda     #^WindowGfx
        sta     zDMA1Src+2
        longa
        clr_a
@3b42:  ldy     ze0
        beq     @3b4e
        clc
        adc     #$0380
        dec     ze0
        bra     @3b42
@3b4e:  clc
        adc     zDMA1Src
        sta     zDMA1Src
        shorta
        ldy     #$0400
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ load menu window palette ]

LoadWindowPal:
@3b5b:  and     #$0f
        sta     ze0
        phx
        lda     #$00
        sta     ze9
        stz     ze1
        longa
        lda     #$1d57                  ; window palette
@3b6b:  ldy     ze0
        beq     @3b77
        clc
        adc     #$000e
        dec     ze0
        bra     @3b6b
@3b77:  sta     ze7
        shorta
        ldy     z0
        plx
@3b7e:  lda     [ze7],y
        sta     $7e30cb,x
        iny
        inx
        cpy     #$000e
        bne     @3b7e
        rts

; ------------------------------------------------------------------------------

; [ draw active/wait config text ]

DrawActiveWaitText:
@3b8c:  lda     $1d4d                   ; active/wait
        and     #$08
        beq     @3b9c                   ; branch if active
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3ba5
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3bae
@3b9c:  lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3ba5
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3bae
@3ba5:  sta     zTextColor
        ldy     #near ConfigActiveText
        jsr     DrawPosKana
        rts
@3bae:  sta     zTextColor
        ldy     #near ConfigWaitText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw battle speed numerals ]

DrawBattleSpeedText:
@3bb7:  lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        ldy     #near ConfigBattleSpeedNumText
        jsr     DrawPosText
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        clr_a
        lda     $1d4d
        and     #%111
        asl
        tax
        longa
        lda     f:BattleSpeedTextPos,x
        sta     zf7
        shorta
        lda     $1d4d
        and     #%111
        clc
        adc     #ZERO_CHAR+1
        sta     zf9
        stz     zfa
        jmp     DrawConfigNum

; ------------------------------------------------------------------------------

BattleSpeedTextPos:
        make_pos BG1A, {14, 7}
        make_pos BG1A, {16, 7}
        make_pos BG1A, {18, 7}
        make_pos BG1A, {20, 7}
        make_pos BG1A, {22, 7}
        make_pos BG1A, {24, 7}

; ------------------------------------------------------------------------------

; [ draw message speed numerals ]

DrawMsgSpeedText:
@3bf2:  lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        ldy     #near ConfigMsgSpeedNumText
        jsr     DrawPosText
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        clr_a
        lda     $1d4d
        and     #$70
        lsr3
        tax
        longa
        lda     f:MsgSpeedTextPos,x
        sta     zf7
        shorta
        lda     $1d4d
        and     #%1110000
        lsr4
        clc
        adc     #ZERO_CHAR+1
        sta     zf9
        stz     zfa
        jmp     DrawConfigNum

; ------------------------------------------------------------------------------

MsgSpeedTextPos:
        make_pos BG1A, {14, 9}
        make_pos BG1A, {16, 9}
        make_pos BG1A, {18, 9}
        make_pos BG1A, {20, 9}
        make_pos BG1A, {22, 9}
        make_pos BG1A, {24, 9}

; ------------------------------------------------------------------------------

; [ draw command setting text ]

DrawCmdConfigText:
@3c33:  lda     $1d4d
        bmi     @3c41
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3c4a
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3c53
@3c41:  lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3c4a
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3c53
@3c4a:  sta     zTextColor
        ldy     #near ConfigCmdShortText
        jsr     DrawPosText
        rts
@3c53:  sta     zTextColor
        ldy     #near ConfigCmdWindowText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [ draw gauge on/off text ]

DrawGaugeConfigText:
@3c5c:  lda     $1d4e
        bpl     @3c6a
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3c73
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3c7c
@3c6a:  lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3c73
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3c7c
@3c73:  sta     zTextColor
        ldy     #near ConfigGaugeOnText
        jsr     DrawPosText
        rts
@3c7c:  sta     zTextColor
        ldy     #near ConfigGaugeOffText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw stereo/mono text ]

DrawStereoMonoText:
@3c85:  lda     $1d4e
        and     #$20
        beq     @3c95
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3c9e
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3ca7
@3c95:  lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3c9e
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3ca7
@3c9e:  sta     zTextColor
        ldy     #near ConfigStereoText
        jsr     DrawPosText
        rts
@3ca7:  sta     zTextColor
        ldy     #near ConfigMonoText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw cursor setting text ]

DrawCursorConfigText:
@3cb0:  lda     $1d4e
        and     #$40
        beq     @3cc0
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3cc9
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3cd2
@3cc0:  lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3cc9
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3cd2
@3cc9:  sta     zTextColor
        ldy     #near ConfigResetText
        jsr     DrawPosKana
        rts
@3cd2:  sta     zTextColor
        ldy     #near ConfigMemoryText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw optimum/remove text ]

DrawReequipConfigText:
@3cdb:  lda     $1d4e
        and     #$10
        beq     @3ceb
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3cf4
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3cfd
@3ceb:  lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3cf4
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3cfd
@3cf4:  sta     zTextColor
        ldy     #near ConfigOptimumText
        jsr     DrawPosText
        rts
@3cfd:  sta     zTextColor
        ldy     #near ConfigEmptyText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

.if !LANG_EN

_c33dda:
@3dda:  lda     $1d54
        and     #$40
        beq     @3ded
        jsr     SetCustomBtnMap
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3df9
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3e02
@3ded:  jsr     SetDefaultBtnMap
        lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3df9
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3e02
@3df9:  sta     zTextColor
        ldy     #near ConfigCtrlNormalText
        jsr     DrawPosText
        rts
@3e02:  sta     zTextColor
        ldy     #near ConfigCtrlCustomText
        jsr     DrawPosText
        rts

.endif

; ------------------------------------------------------------------------------

; [ draw single/multiple controller text ]

DrawCtrlConfigText:
@3d06:  lda     $1d54
        bpl     @3d14
        lda     #BG1_TEXT_COLOR::GRAY
        jsr     @3d1d
        lda     #BG1_TEXT_COLOR::DEFAULT
        bra     @3d26
@3d14:  lda     #BG1_TEXT_COLOR::DEFAULT
        jsr     @3d1d
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @3d26
@3d1d:  sta     zTextColor
        ldy     #near ConfigCtrlSingleText
        jsr     DrawPosKana
        rts
@3d26:  sta     zTextColor
        ldy     #near ConfigCtrlMultiText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ change config setting (pressed left or right) ]

ChangeConfigOption:
@3d2f:  clr_a
        lda     z4b
        asl
        tax
        lda     z4a
        beq     @3d40
        phx
        jsr     PlayMoveSfx
        plx
        jmp     (near ChangeConfigOptionTbl2,x)
@3d40:  jmp     (near ChangeConfigOptionTbl1,x)

; ------------------------------------------------------------------------------

; page 1
ChangeConfigOptionTbl1:
@3d43:  .addr   ChangeConfigOption_00
        .addr   ChangeConfigOption_01
        .addr   ChangeConfigOption_02
        .addr   ChangeConfigOption_03
        .addr   ChangeConfigOption_04
        .addr   ChangeConfigOption_05
        .addr   ChangeConfigOption_06
        .addr   ChangeConfigOption_07
.if !LANG_EN
        .addr   ChangeConfigOption_08j
.endif
        .addr   ChangeConfigOption_08

; page 2
ChangeConfigOptionTbl2:
@3d55:  .addr   ChangeConfigOption_09
        .addr   ChangeConfigOption_0a
        .addr   ChangeConfigOption_0b
        .addr   ChangeConfigOption_0c
        .addr   ChangeConfigOption_0d
        .addr   ChangeConfigOption_0e

; ------------------------------------------------------------------------------

; [ change active/wait setting ]

ChangeConfigOption_00:
@3d61:  jsr     PlayMoveSfx
        lda     z0a+1
        bit     #$01
        bne     @3d72
        lda     #$08
        trb     $1d4d
        jmp     DrawActiveWaitText
@3d72:  lda     #$08
        tsb     $1d4d
        jmp     DrawActiveWaitText

; ------------------------------------------------------------------------------

; [ change battle speed ]

ChangeConfigOption_01:
@3d7a:  jsr     PlayMoveSfx
        lda     $1d4d
        and     #$07
        sta     ze0
        lda     z0a+1
        bit     #$01
        beq     @3d95
        lda     ze0
        cmp     #$05
        beq     @3d94
        inc     ze0
        bra     @3d9e
@3d94:  rts
@3d95:  lda     ze0
        beq     @3d9d
        dec     ze0
        bra     @3d9e
@3d9d:  rts
@3d9e:  lda     $1d4d
        and     #$f8
        ora     ze0
        sta     $1d4d
        jmp     DrawBattleSpeedText

; ------------------------------------------------------------------------------

; [ change message speed ]

ChangeConfigOption_02:
@3dab:  jsr     PlayMoveSfx
        lda     $1d4d
        and     #$70
        lsr4
        sta     ze0
        lda     z0a+1
        bit     #$01
        beq     @3dca
        lda     ze0
        cmp     #$05
        beq     @3dc9
        inc     ze0
        bra     @3dd3
@3dc9:  rts
@3dca:  lda     ze0
        beq     @3dd2
        dec     ze0
        bra     @3dd3
@3dd2:  rts
@3dd3:  lda     ze0
        asl4
        sta     ze0
        lda     $1d4d
        and     #$8f
        ora     ze0
        sta     $1d4d
        jmp     DrawMsgSpeedText

; ------------------------------------------------------------------------------

; [ change command setting ]

ChangeConfigOption_03:
@3de8:  jsr     PlayMoveSfx
        lda     z0a+1
        bit     #$01
        bne     @3df9
        lda     #$80
        trb     $1d4d
        jmp     DrawCmdConfigText
@3df9:  lda     #$80
        tsb     $1d4d
        jmp     DrawCmdConfigText

; ------------------------------------------------------------------------------

; [ change gauge setting ]

ChangeConfigOption_04:
@3e01:  jsr     PlayMoveSfx
        lda     z0a+1
        bit     #$01
        bne     @3e12
        lda     #$80
        trb     $1d4e
        jmp     DrawGaugeConfigText
@3e12:  lda     #$80
        tsb     $1d4e
        jmp     DrawGaugeConfigText

; ------------------------------------------------------------------------------

; [ change stereo/mono setting ]

ChangeConfigOption_05:
@3e1a:  lda     z0a+1
        bit     #$01
        bne     @3e2f
        clr_a
        jsr     SetStereoMono
        lda     #$20
        trb     $1d4e
        jsr     PlayMoveSfx
        jmp     DrawStereoMonoText
@3e2f:  lda     #$ff
        jsr     SetStereoMono
        lda     #$20
        tsb     $1d4e
        jsr     PlayMoveSfx
        jmp     DrawStereoMonoText

; ------------------------------------------------------------------------------

; [ set mono/stereo mode ]

SetStereoMono:
@3e3f:  sta     f:$001301
        lda     #$f3        ; spc command $f3 (set mono/stereo mode)
        sta     f:$001300
        jsl     ExecSound_ext
        rts

; ------------------------------------------------------------------------------

; [ change cursor setting ]

ChangeConfigOption_06:
@3e4e:  jsr     PlayMoveSfx
        lda     z0a+1
        bit     #$01
        bne     @3e62
        jsr     _c348f7
        lda     #$40
        trb     $1d4e
        jmp     DrawCursorConfigText
@3e62:  lda     #$40
        tsb     $1d4e
        jsr     ResetMenuCursorMemory
        jmp     DrawCursorConfigText

; ------------------------------------------------------------------------------

; [ change reequip setting ]

ChangeConfigOption_07:
@3e6d:  jsr     PlayMoveSfx
        lda     z0a+1
        bit     #$01
        bne     @3e7e
        lda     #$10
        trb     $1d4e
        jmp     DrawReequipConfigText
@3e7e:  lda     #$10
        tsb     $1d4e
        jmp     DrawReequipConfigText

; ------------------------------------------------------------------------------

.if !LANG_EN

; [ change custom controller mapping setting ]

ChangeConfigOption_08j:
@3f8d:  jsr     PlayMoveSfx
        lda     z0a+1
        bit     #$01
        bne     @3f9e
        lda     #$40
        trb     $1d54
        jmp     _c33dda
@3f9e:  lda     #$40
        tsb     $1d54
        jmp     _c33dda

.endif

; ------------------------------------------------------------------------------

; [ change controller setting ]

ChangeConfigOption_08:
@3e86:  jsr     PlayMoveSfx
        lda     z0a+1
        bit     #$01
        bne     @3e97
        lda     #$80
        trb     $1d54
        jmp     DrawCtrlConfigText
@3e97:  lda     #$80
        tsb     $1d54
        jmp     DrawCtrlConfigText

; ------------------------------------------------------------------------------

; [ change magic order ]

ChangeConfigOption_09:
@3e9f:  lda     $1d54
        and     #$07
        sta     ze0
        lda     z0a+1
        bit     #$01
        beq     @3eb7
        lda     ze0
        cmp     #$05
        beq     @3eb6
        inc     ze0
        bra     @3ec0
@3eb6:  rts
@3eb7:  lda     ze0
        beq     @3ebf
        dec     ze0
        bra     @3ec0
@3ebf:  rts
@3ec0:  lda     $1d54
        and     #$f8
        ora     ze0
        sta     $1d54
        jmp     DrawConfigMagicOrder

; ------------------------------------------------------------------------------

; [ change window pattern ]

ChangeConfigOption_0a:
@3ecd:  lda     $1d4e
        and     #$0f
        sta     ze0
        lda     z0a+1
        bit     #$01
        beq     @3ee5
        lda     ze0
        cmp     #$07
        beq     @3ee4
        inc     ze0
        bra     @3eee
@3ee4:  rts
@3ee5:  lda     ze0
        beq     @3eed
        dec     ze0
        bra     @3eee
@3eed:  rts
@3eee:  lda     $1d4e
        and     #$f0
        ora     ze0
        sta     $1d4e
        jsr     DrawConfigWindowNumList
        jsr     LoadWindowGfx
        jmp     UpdateConfigColorBars

; ------------------------------------------------------------------------------

; [ select font/window color ]

ChangeConfigOption_0b:
@3f01:  lda     $1d54
        and     #$38
        lsr3
        sta     ze0
        lda     z0a+1
        bit     #$01
        beq     @3f1c
        lda     ze0
        cmp     #$07
        beq     @3f1b
        inc     ze0
        bra     @3f25
@3f1b:  rts
@3f1c:  lda     ze0
        beq     @3f24
        dec     ze0
        bra     @3f25
@3f24:  rts
@3f25:  lda     ze0
        asl3
        sta     ze0
        lda     $1d54
        and     #$c7
        ora     ze0
        sta     $1d54
        jsr     DrawConfigColors
        jmp     UpdateConfigColorBars

; ------------------------------------------------------------------------------

; [ change red component ]

ChangeConfigOption_0c:
@3f3c:  jsr     GetColorComponents
        lda     z0a+1
        bit     #$01
        beq     @3f4f
        lda     ze2
        cmp     #$1f
        beq     @3f55
        inc     ze2
        bra     @3f55
@3f4f:  lda     ze2
        beq     @3f55
        dec     ze2
@3f55:  jsr     CombineColorComponents
        jmp     SetModifiedColor

; ------------------------------------------------------------------------------

; [ change green component ]

ChangeConfigOption_0d:
@3f5b:  jsr     GetColorComponents
        lda     z0a+1
        bit     #$01
        beq     @3f6e
        lda     ze1
        cmp     #$1f
        beq     @3f74
        inc     ze1
        bra     @3f74
@3f6e:  lda     ze1
        beq     @3f74
        dec     ze1
@3f74:  jsr     CombineColorComponents
        jmp     SetModifiedColor

; ------------------------------------------------------------------------------

; [ change blue component ]

ChangeConfigOption_0e:
@3f7a:  jsr     GetColorComponents
        lda     z0a+1
        bit     #$01
        beq     @3f8d
        lda     ze0
        cmp     #$1f
        beq     @3f93
        inc     ze0
        bra     @3f93
@3f8d:  lda     ze0
        beq     @3f93
        dec     ze0
@3f93:  jsr     CombineColorComponents
        jmp     SetModifiedColor

; ------------------------------------------------------------------------------

; [ init font color ]

InitFontColor:
@3f99:  longa
        lda     $1d55                   ; copy font color to all text palettes
        sta     $7e304f
        sta     $7e3073
        sta     $7e3077
        shorta
        rts

; ------------------------------------------------------------------------------

; [ update window palette in CGRAM buffer ]

UpdateWindowPal:
@3fad:  ldx     z0
        longa
@3fb1:  lda     $1d57,y
        sta     $7e312b,x
        iny2
        inx2
        cpx     #$000e
        bne     @3fb1
        shorta
        rts

; ------------------------------------------------------------------------------

; [ set a modified color value ]

SetModifiedColor:
@3fc4:  clr_a
        lda     $1d4e                   ; get a pointer to the color in RAM
        and     #$0f
        sta     hWRMPYA
        lda     #14
        sta     hWRMPYB
        lda     $1d54
        and     #$38
        beq     @3ff2

; window color
        lsr2
        clc
        adc     hRDMPYL
        tax
        lda     z9a
        sta     $1d55,x                 ; set the new color value in SRAM
        lda     z9a+1
        sta     $1d55+1,x
        ldy     hRDMPYL
        jsr     UpdateWindowPal
        bra     @3ffa

; font color
@3ff2:  ldy     z9a
        sty     $1d55                   ; set the new color value in SRAM
        jsr     InitFontColor
@3ffa:  jmp     UpdateConfigColorBars

; ------------------------------------------------------------------------------

; [ draw magic order numerals and text ]

DrawConfigMagicOrder:
@3ffd:  lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        ldy     #near ConfigMagicOrderNumText
        jsr     DrawPosText
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        clr_a
        lda     $1d54
        and     #%111
        asl
        tax
        longa
        lda     f:ConfigMagicOrderNumPos,x
        sta     zf7
        shorta
        lda     $1d54
        and     #%111
        clc
        adc     #ZERO_CHAR+1
        sta     zf9
        stz     zfa
        jsr     DrawConfigNum
        jmp     DrawConfigMagicTypeList

; ------------------------------------------------------------------------------

; positions for highlighted numeral for magic order
ConfigMagicOrderNumPos:
        make_pos BG1B, {14, 5}
        make_pos BG1B, {16, 5}
        make_pos BG1B, {18, 5}
        make_pos BG1B, {20, 5}
        make_pos BG1B, {22, 5}
        make_pos BG1B, {24, 5}

; ------------------------------------------------------------------------------

; [ draw magic type list for config menu ]

DrawConfigMagicTypeList:
.if LANG_EN
@403b:  clr_a
        sta     $7e9e95
.else
        stz     zfd
.endif
        clr_a
        lda     $1d54
        and     #%111
        asl2
        tax
        ldy     #3
@404c:  phy
        phx
        jsr     DrawConfigMagicTypeName
        plx
        ply
        inx
        dey
        bne     @404c
        rts

; ------------------------------------------------------------------------------

; [ draw magic type name for config menu ]

DrawConfigMagicTypeName:

.if LANG_EN

@4058:  clr_a
        lda     f:ConfigMagicTypeTextPtrs,x
        tax
        .repeat 10, i
        lda     f:ConfigMagicTypeText+i,x
        sta     $7e9e8b+i
        .endrep
        clr_a
        dey
        tya
        asl
        tax
        longa
        lda     f:ConfigMagicTypeTextPos,x
        sta     $7e9e89
        shorta
        ldy     #near $7e9e89
        sty     ze7
        lda     #^$7e9e89
        sta     ze9
        jsr     DrawPosTextFar
        rts

.else

@4175:  lda     f:ConfigMagicTypeTextPtrs,x
        tax
        .repeat 4, i
        lda     f:ConfigMagicTypeText+i,x
        sta     zf9+i
        .endrep
        dey
        tya
        asl
        tax
        longa
        lda     f:ConfigMagicTypeTextPos,x
        sta     zf7
        shorta
        ldy     #near zf7
        sty     ze7
        lda     #^zf7
        sta     ze9
        jsr     DrawPosKanaFar
        rts

.endif

; ------------------------------------------------------------------------------

.if LANG_EN

ConfigMagicTypeTextPos:
        make_pos BG1B, {16, 11}
        make_pos BG1B, {16, 9}
        make_pos BG1B, {16, 7}

ConfigMagicTypeTextPtrs:
@40d2:  .byte   $00,$0a,$14,$00
        .byte   $00,$14,$0a,$00
        .byte   $0a,$14,$00,$00
        .byte   $0a,$00,$14,$00
        .byte   $14,$00,$0a,$00
        .byte   $14,$0a,$00,$00

.else

ConfigMagicTypeTextPos:
        make_pos BG1B, {16, 10}
        make_pos BG1B, {16, 8}
        make_pos BG1B, {16, 6}

ConfigMagicTypeTextPtrs:
        .byte   0,4,8,0
        .byte   0,8,4,0
        .byte   4,8,0,0
        .byte   4,0,8,0
        .byte   8,0,4,0
        .byte   8,4,0,0

.endif

; ------------------------------------------------------------------------------

; [ draw window pattern numerals ]

DrawConfigWindowNumList:
@40ea:  lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        ldy     #near ConfigWindowNumText
        jsr     DrawPosText
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        clr_a
        lda     $1d4e
        and     #$0f
        asl
        tax
        longa
        lda     f:ConfigWindowNumPos,x
        sta     zf7
        shorta
        lda     $1d4e
        and     #$0f
        clc
        adc     #ZERO_CHAR+1
        sta     zf9
        stz     zfa
; fallthrough

; ------------------------------------------------------------------------------

; [ draw selected numeral for config list ]

; battle speed, battle message speed, magic order, and window pattern

DrawConfigNum:
@4116:  ldy     #near zf7
        sty     ze7
        lda     #^zf7
        sta     ze9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

; positions for highlighted numeral for window graphics indes
ConfigWindowNumPos:
        make_pos BG1B, {14, 13}
        make_pos BG1B, {16, 13}
        make_pos BG1B, {18, 13}
        make_pos BG1B, {20, 13}
        make_pos BG1B, {22, 13}
        make_pos BG1B, {24, 13}
        make_pos BG1B, {26, 13}
        make_pos BG1B, {28, 13}

; ------------------------------------------------------------------------------

; [ draw window color boxes for config menu ]

DrawConfigColors:
@4133:  lda     #BG1_TEXT_COLOR::WINDOW
        sta     zTextColor
        ldy     #near ConfigColorBoxText
        jsr     DrawPosText
        ldy     #near ConfigColorArrowBlankText
        jsr     DrawPosText
        clr_a
        lda     $1d54
        and     #$38
        beq     @4171

; window color selected
        lsr2
        tax
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        longa
        lda     f:ConfigColorArrowTbl,x
        sta     ze7
        shorta
        lda     #^ConfigColorArrowTbl
        sta     ze9
        jsr     DrawPosTextFar
        lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        jsr     @417f
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jmp     @4186

; font color selected
@4171:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jsr     @417f
        lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        jmp     @4186

; draw "Font"
@417f:  ldy     #near ConfigFontText
        jsr     DrawPosText
        rts

; draw "Window"
@4186:  ldy     #near ConfigWindowText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

ConfigColorArrowTbl:
@418d:  .addr   ConfigColorArrowBlankText
        .addr   ConfigColorArrowText1
        .addr   ConfigColorArrowText2
        .addr   ConfigColorArrowText3
        .addr   ConfigColorArrowText4
        .addr   ConfigColorArrowText5
        .addr   ConfigColorArrowText6
        .addr   ConfigColorArrowText7

; blank text for clearing arrow area and if font color is selected
ConfigColorArrowBlankText:      pos_text CONFIG_COLOR_ARROW_BLANK
ConfigColorArrowText1:          pos_text CONFIG_COLOR_ARROW 22
ConfigColorArrowText2:          pos_text CONFIG_COLOR_ARROW 23
ConfigColorArrowText3:          pos_text CONFIG_COLOR_ARROW 24
ConfigColorArrowText4:          pos_text CONFIG_COLOR_ARROW 25
ConfigColorArrowText5:          pos_text CONFIG_COLOR_ARROW 26
ConfigColorArrowText6:          pos_text CONFIG_COLOR_ARROW 27
ConfigColorArrowText7:          pos_text CONFIG_COLOR_ARROW 28

; ------------------------------------------------------------------------------

; [ draw config color bars and values ]

UpdateConfigColorBars:
@41c3:  jsr     _c33950
        clr_a
        lda     $1d4e                   ; window pattern
        and     #$0f
        sta     hWRMPYA
        lda     #14
        sta     hWRMPYB
        lda     $1d54                   ; selected color
        and     #$38
        beq     @41e7

; window color
        lsr2
        clc
        adc     hRDMPYL
        tax
        ldy     $1d55,x
        bra     @41ea

; font color
@41e7:  ldy     $1d55
@41ea:  sty     z9a
        jsr     GetColorComponents
        jsr     DrawBlueColorBar
        jsr     GetColorComponents
        jsr     DrawGreenColorBar
        jsr     GetColorComponents
        jmp     DrawRedColorBar

; ------------------------------------------------------------------------------

; [ separate color components for color bars ]

GetColorComponents:
@41fe:  ldy     z9a
        sty     ze7
        lda     ze7
        and     #$1f
        sta     ze2
        lda     ze8
        and     #$7c
        lsr2
        sta     ze0
        longa
        lda     ze7
        and     #$03e0
        lsr5
        shorta
        sta     ze1
        rts

; ------------------------------------------------------------------------------

; [ combine RGB color components ]

CombineColorComponents:
@4221:  lda     ze0
        asl2
        sta     ze8
        lda     ze2
        sta     ze7
        clr_a
        lda     ze1
        longa
        asl5
        ora     ze7
        sta     a:$009a
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw red color bar ]

DrawRedColorBar:
@423d:  longa
        lda_pos BG1B, {19, 19}
        sta     $7e9e89
        shorta
        lda     ze2
        ldx_pos BG1B, {16, 19}
        jmp     DrawConfigColorBar

; ------------------------------------------------------------------------------

; [ draw green color bar ]

DrawGreenColorBar:
@4250:  longa
        lda_pos BG1B, {19, 21}
        sta     $7e9e89
        shorta
        lda     ze1
        ldx_pos BG1B, {16, 21}
        jmp     DrawConfigColorBar

; ------------------------------------------------------------------------------

; [ draw blue color ]

DrawBlueColorBar:
@4263:  longa
        lda_pos BG1B, {19, 23}
        sta     $7e9e89
        shorta
        lda     ze0
        ldx_pos BG1B, {16, 23}
        jmp     DrawConfigColorBar

; ------------------------------------------------------------------------------

; [ draw one color bar and numerals ]

DrawConfigColorBar:
@4276:  pha
        pha
        phx
        jsr     HexToDec3
        plx
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jsr     DrawNum2
        ldx     #$9e8b
        stx     hWMADDL
        pla
        xba
        lda     z0
        xba
        lsr2
        tax
        beq     @429c
@4294:  lda     #GAUGE_FULL_CHAR
        sta     hWMDATA
        dex
        bne     @4294
@429c:  pla
        and     #%11
        tax
        lda     f:ColorBarTiles,x
        sta     hWMDATA
        stz     hWMDATA
        lda     #BG1_TEXT_COLOR::COLOR_BAR
        sta     zTextColor
        jmp     @42b1                   ; this does nothing
@42b1:  ldy     #$9e89
        sty     ze7
        lda     #$7e
        sta     ze9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

ColorBarTiles:
@42be:  .byte   GAUGE_EMPTY_CHAR
        .byte   GAUGE_EMPTY_CHAR+2
        .byte   GAUGE_EMPTY_CHAR+4
        .byte   GAUGE_EMPTY_CHAR+6

; ------------------------------------------------------------------------------

; [ menu state $47: battle command arrange (init) ]

MenuState_47:
@42c2:  jsr     DisableInterrupts
        jsr     DrawCmdArrangeMenu
        jsr     InitCmdArrangeScrollHDMA
        jsr     LoadCmdArrangeCharCursor
        jsr     InitCmdArrangeCharCursor
        jsr     CreateCursorTask
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #$48
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $48: battle command arrange ]

MenuState_48:
@42df:  jsr     UpdateCmdArrangeCharCursor
        lda     z08
        bit     #JOY_A
        beq     @4310
        clr_a
        lda     z4b
        cmp     #$04
        beq     @4326
        tax
        lda     zCharID,x
        bmi     @430a
        jsr     PlaySelectSfx
        lda     z4e
        sta     z5e
        lda     z4b
        sta     z64
        jsr     LoadCmdArrangeCursor
        jsr     InitCmdArrangeCursor
        lda     #$62
        sta     zMenuState
        rts
@430a:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@4310:  lda     z08+1
        bit     #>JOY_START
        bne     @431c
        lda     z08+1
        bit     #>JOY_B
        beq     @4325
@431c:  jsr     PlayCancelSfx
        lda     #MENU_STATE::CONFIG_INIT
        sta     zNextMenuState
        stz     zMenuState
@4325:  rts
@4326:  jsr     PlaySelectSfx
        jsr     InitDMA1BG3ScreenA
        jsr     _c343d0
        jsr     _c343d8
        jsr     _c343e1
        jmp     _c343ea

; ------------------------------------------------------------------------------

; [ menu state $62: command arrange (init) ]

MenuState_62:
@4338:  jsr     UpdateCmdArrangeCursor
        lda     z08
        bit     #JOY_A
        beq     @4359
        jsr     PlaySelectSfx
        lda     z4b
        sta     zSelIndex
        jsr     _c32f06
        lda     #$63
        sta     zMenuState
        clr_a
        lda     z64
        asl
        tax
        ldy     zCharPropPtr,x
        sty     zSelCharPropPtr
        rts
@4359:  lda     z08+1
        bit     #>JOY_B
        beq     @4375
        jsr     PlayCancelSfx
        jsr     LoadCmdArrangeCharCursor
        lda     z5e
        sta     z4e
        jsr     InitCmdArrangeCharCursor
        lda     z4e
        sta     z5e
        lda     #$48
        sta     zMenuState
        rts
@4375:  rts

; ------------------------------------------------------------------------------

; [ menu state $63: command arrange ]

MenuState_63:
@4376:  jsr     UpdateCmdArrangeCursor

; A button
        lda     z08
        bit     #JOY_A
        beq     @43bd
        jsr     PlaySelectSfx
        clr_a
        lda     z4b
        longa_clc
        adc     zSelCharPropPtr
        tay
        phy
        shorta
        lda     $0016,y
        sta     ze0
        clr_a
        lda     zSelIndex
        longa_clc
        adc     zSelCharPropPtr
        tay
        shorta
        lda     $0016,y
        sta     ze1
        lda     ze0
        sta     $0016,y
        ply
        lda     ze1
        sta     $0016,y
        jsr     DrawCmdArrangeChar1
        jsr     DrawCmdArrangeChar2
        jsr     DrawCmdArrangeChar3
        jsr     DrawCmdArrangeChar4
        jsr     InitDMA1BG3ScreenA
        bra     @43c6

; B button
@43bd:  lda     z08+1
        bit     #>JOY_B
        beq     @43cf
        jsr     PlayCancelSfx
@43c6:  lda     #$05
        trb     z46
        lda     #$62
        sta     zMenuState
        rts
@43cf:  rts

; ------------------------------------------------------------------------------

; [  ]

_c343d0:
@43d0:  ldx     z0
        jsr     _c343f3
        jmp     DrawCmdArrangeChar1

; ------------------------------------------------------------------------------

; [  ]

_c343d8:
@43d8:  ldx     #$0002
        jsr     _c343f3
        jmp     DrawCmdArrangeChar2

; ------------------------------------------------------------------------------

; [  ]

_c343e1:
@43e1:  ldx     #$0004
        jsr     _c343f3
        jmp     DrawCmdArrangeChar3

; ------------------------------------------------------------------------------

; [  ]

_c343ea:
@43ea:  ldx     #$0006
        jsr     _c343f3
        jmp     DrawCmdArrangeChar4

; ------------------------------------------------------------------------------

; [  ]

_c343f3:
@43f3:  ldy     zCharPropPtr,x
        beq     @442a
        clr_a
        lda     0,y
        cmp     #CHAR_PROP::GOGO
        beq     @442b
        sta     hWRMPYA
        lda     #22
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        lda     f:CharProp+2,x   ; character properties (battle commands)
        sta     $0016,y
        lda     f:CharProp+3,x
        sta     $0017,y
        lda     f:CharProp+4,x
        sta     $0018,y
        lda     f:CharProp+5,x
        sta     $0019,y
@442a:  rts
@442b:  rts

; ------------------------------------------------------------------------------

; [ draw command arrange menu ]

DrawCmdArrangeMenu:
@442c:  jsr     ClearBG2ScreenA
        ldy     #near CmdArrangeChar1RightWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeChar2RightWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeChar3RightWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeChar4RightWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeChar1LeftWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeChar2LeftWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeChar3LeftWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeChar4LeftWindow
        jsr     DrawWindow
        ldy     #near CmdArrangeTitleWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #BG3_TEXT_COLOR::TEAL_ALT
        sta     zTextColor
        ldy     #near CmdArrangeTitleText
        jsr     DrawPosKana
        jsr     DrawCmdArrangeChar1
        jsr     DrawCmdArrangeChar2
        jsr     DrawCmdArrangeChar3
        jsr     DrawCmdArrangeChar4
        jsr     TfrBG1ScreenAB
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; command arrange menu windows

CmdArrangeChar1RightWindow:             make_window BG2A, {11, 3}, {18, 4}
CmdArrangeChar2RightWindow:             make_window BG2A, {11, 9}, {18, 4}
CmdArrangeChar3RightWindow:             make_window BG2A, {11, 15}, {18, 4}
CmdArrangeChar4RightWindow:             make_window BG2A, {11, 21}, {18, 4}
CmdArrangeChar1LeftWindow:              make_window BG2A, {1, 3}, {8, 4}
CmdArrangeChar2LeftWindow:              make_window BG2A, {1, 9}, {8, 4}
CmdArrangeChar3LeftWindow:              make_window BG2A, {1, 15}, {8, 4}
CmdArrangeChar4LeftWindow:              make_window BG2A, {1, 21}, {8, 4}
CmdArrangeTitleWindow:                  make_window BG2A, {1, 1}, {8, 1}

; ------------------------------------------------------------------------------

; [ draw command arrange text for character slot 1 ]

DrawCmdArrangeChar1:
@44b4:  lda     zCharID::Slot1
        bmi     @44ec
        jsl     UpdateEquip_ext
        ldx     zCharPropPtr::Slot1
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::TEAL_ALT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG3A, {3, 5}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 7}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 5}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 7}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 7}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 9}
        jsr     DrawCmdArrangeBtm
.else
        ldy_pos BG3A, {3, 4}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 6}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 4}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 6}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 6}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 8}
        jsr     DrawCmdArrangeBtm
.endif
@44ec:  rts

; ------------------------------------------------------------------------------

; [ draw command arrange text for character slot 2 ]

DrawCmdArrangeChar2:
@44ed:  lda     zCharID::Slot2
        bmi     @4525
        jsl     UpdateEquip_ext
        ldx     zCharPropPtr::Slot2
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::TEAL_ALT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG3A, {3, 12}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 14}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 12}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 14}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 14}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 16}
        jsr     DrawCmdArrangeBtm
.else
        ldy_pos BG3A, {3, 11}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 13}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 11}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 13}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 13}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 15}
        jsr     DrawCmdArrangeBtm
.endif
@4525:  rts

; ------------------------------------------------------------------------------

; [ draw command arrange text for character slot 3 ]

DrawCmdArrangeChar3:
@4526:  lda     zCharID::Slot3
        bmi     @455e
        jsl     UpdateEquip_ext
        ldx     zCharPropPtr::Slot3
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::TEAL_ALT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG3A, {3, 19}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 21}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 19}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 21}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 21}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 23}
        jsr     DrawCmdArrangeBtm
.else
        ldy_pos BG3A, {3, 18}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 20}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 18}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 20}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 20}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 22}
        jsr     DrawCmdArrangeBtm
.endif
@455e:  rts

; ------------------------------------------------------------------------------

; [ draw command arrange text for character slot 4 ]

DrawCmdArrangeChar4:
@455f:  lda     zCharID::Slot4
        bmi     @4597
        jsl     UpdateEquip_ext
        ldx     zCharPropPtr::Slot4
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::TEAL_ALT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG3A, {3, 26}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 28}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 26}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 28}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 28}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 30}
        jsr     DrawCmdArrangeBtm
.else
        ldy_pos BG3A, {3, 25}
        jsr     DrawCharName
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 27}
        jsr     DrawCharTitle
        ldy_pos BG3A, {18, 25}
        jsr     DrawCmdArrangeTop
        ldy_pos BG3A, {13, 27}
        jsr     DrawCmdArrangeLeft
        ldy_pos BG3A, {23, 27}
        jsr     DrawCmdArrangeRight
        ldy_pos BG3A, {18, 29}
        jsr     DrawCmdArrangeBtm
.endif
@4597:  rts

; ------------------------------------------------------------------------------

; [ draw top command ]

DrawCmdArrangeTop:
@4598:  jsr     InitTextBuf
        jmp     DrawCmdName

; ------------------------------------------------------------------------------

; [ draw left command ]

DrawCmdArrangeLeft:
@459e:  jsr     InitTextBuf
        iny
        jmp     DrawCmdName

; ------------------------------------------------------------------------------

; [ draw right command ]

DrawCmdArrangeRight:
@45a5:  jsr     InitTextBuf
        iny2
        jmp     DrawCmdName

; ------------------------------------------------------------------------------

; [ draw bottom command ]

DrawCmdArrangeBtm:
@45ad:  jsr     InitTextBuf
        iny3
        jmp     DrawCmdName

; ------------------------------------------------------------------------------

; [ init cursor (battle command arrange, char select) ]

LoadCmdArrangeCharCursor:
@45b6:  ldy     #near CmdArrangeCharCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, char select) ]

UpdateCmdArrangeCharCursor:
@45bc:  jsr     MoveCursor

InitCmdArrangeCharCursor:
@45bf:  ldy     #near CmdArrangeCharCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; cursor data (battle command arrange, char select)
CmdArrangeCharCursorProp:
        cursor_prop {0, 0}, {1, 5}, NO_X_WRAP

; cursor positions (battle command arrange, char select)
CmdArrangeCharCursorPos:
@45ca:  cursor_pos {8, 32}
        cursor_pos {8, 80}
        cursor_pos {8, 128}
        cursor_pos {8, 176}
        cursor_pos {8, 12}

; ------------------------------------------------------------------------------

; [ init cursor (battle command arrange, command select/move) ]

LoadCmdArrangeCursor:
@45d4:  ldy     #near CmdArrangeCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, command select/move) ]

; initial update only, doesn't update cursor movement

InitCmdArrangeCursor:
@45da:  clr_a
        lda     z64         ; character slot
        asl
        tax
        jmp     (near InitCmdArrangeCursorTbl,x)

InitCmdArrangeCursorTbl:
@45e2:  .addr   InitChar1CmdArrangeCursorPos
        .addr   InitChar2CmdArrangeCursorPos
        .addr   InitChar3CmdArrangeCursorPos
        .addr   InitChar4CmdArrangeCursorPos

; ------------------------------------------------------------------------------

; character slot 1
InitChar1CmdArrangeCursorPos:
UpdateChar1CmdArrangeCursorPos:
@45ea:  ldy     #near Char1CmdArrangeCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 2
InitChar2CmdArrangeCursorPos:
UpdateChar2CmdArrangeCursorPos:
@45f0:  ldy     #near Char2CmdArrangeCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 3
InitChar3CmdArrangeCursorPos:
UpdateChar3CmdArrangeCursorPos:
@45f6:  ldy     #near Char3CmdArrangeCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 4
InitChar4CmdArrangeCursorPos:
UpdateChar4CmdArrangeCursorPos:
@45fc:  ldy     #near Char4CmdArrangeCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, command select/move) ]

UpdateCmdArrangeCursor:
@4602:  jsr     GetCmdArrangeCursorInput
        clr_a
        lda     z64         ; character slot
        asl
        tax
        jmp     (near UpdateCmdArrangeCursorTbl,x)

UpdateCmdArrangeCursorTbl:
@460d:  .addr   UpdateChar1CmdArrangeCursorPos
        .addr   UpdateChar2CmdArrangeCursorPos
        .addr   UpdateChar3CmdArrangeCursorPos
        .addr   UpdateChar4CmdArrangeCursorPos

; ------------------------------------------------------------------------------

; [ update cursor movement (battle command arrange, command select/move) ]

GetCmdArrangeCursorInput:
@4615:  stz     z4d

; up
        lda     z0a+1
        bit     #$08
        beq     @4622
        stz     z4e
        jsr     PlayMoveSfx

; down
@4622:  lda     z0a+1
        bit     #$04
        beq     @462f
        lda     #$03
        sta     z4e
        jsr     PlayMoveSfx

; left
@462f:  lda     z0a+1
        bit     #$02
        beq     @463c
        lda     #$01
        sta     z4e
        jsr     PlayMoveSfx

; right
@463c:  lda     z0a+1
        bit     #$01
        beq     @4649
        lda     #$02
        sta     z4e
        jsr     PlayMoveSfx
@4649:  rts

; ------------------------------------------------------------------------------

; cursor data (battle command arrange, command select/move)
CmdArrangeCursorProp:
        cursor_prop {0, 0}, {1, 4}, NO_XY_WRAP

; cursor positions (battle command arrange, 4 positions per character slot)
Char1CmdArrangeCursorPos:
@464f:  cursor_pos {128, 32}
        cursor_pos {88, 44}
        cursor_pos {168, 44}
        cursor_pos {128, 56}

Char2CmdArrangeCursorPos:
@4657:  cursor_pos {128, 80}
        cursor_pos {88, 92}
        cursor_pos {168, 92}
        cursor_pos {128, 104}

Char3CmdArrangeCursorPos:
@465f:  cursor_pos {128, 128}
        cursor_pos {88, 140}
        cursor_pos {168, 140}
        cursor_pos {128, 152}

Char4CmdArrangeCursorPos:
@4667:  cursor_pos {128, 176}
        cursor_pos {88, 188}
        cursor_pos {168, 188}
        cursor_pos {128, 200}

; ------------------------------------------------------------------------------

; [ init bg3 horizontal scroll hdma (battle command arrange) ]

InitCmdArrangeScrollHDMA:
@466f:  lda     #$02                    ; one address, write twice
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS              ; bg3 vertical scroll
        sta     hDMA5::HREG
        ldy     #near CmdArrangeScrollHDMATbl
        sty     hDMA5::ADDR
        lda     #^CmdArrangeScrollHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^CmdArrangeScrollHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (battle command arrange)
CmdArrangeScrollHDMATbl:
        hdma_word 31, 0
        hdma_word 12, 4
        hdma_word 12, 8
        hdma_word 36, 12
        hdma_word 12, 16
        hdma_word 36, 20
        hdma_word 12, 24
        hdma_word 36, 28
        hdma_word 12, 32
        hdma_word 36, 36
        hdma_end

; ------------------------------------------------------------------------------

; controller config menu
MenuState_49:
.if !LANG_EN
@478e:  jsr     DisableInterrupts
        jsr     DrawCtrlConfigMenu
        jsr     InitCtrlConfigWindowHDMA
        jsr     LoadCtrlConfigCursor
        jsr     InitCtrlConfigCursor
        jsr     CreateCursorTask
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #$4a
        sta     zNextMenuState
        jmp     EnableInterrupts
.endif

MenuState_4a:
.if !LANG_EN
@47ab:  jsr     InitDMA1BG3ScreenA
        jsr     UpdateCtrlConfigCursor
        lda     z08+1
        bit     #>JOY_START
        beq     @47cb
        jsr     ValidateCtrlConfig
        sta     ze0
        bne     @47db
        jsr     PlaySelectSfx
        jsr     SetCustomBtnMap
        lda     #MENU_STATE::CONFIG_INIT
        sta     zNextMenuState
        stz     zMenuState
        rts
@47cb:  lda     z0a+1
        bit     #>JOY_RIGHT
        bne     @47d7
        lda     z0a+1
        bit     #>JOY_LEFT
        beq     @47da
@47d7:  jmp     _c24bf2
@47da:  rts
@47db:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

.endif

; ------------------------------------------------------------------------------

; [ menu state $4b: init character controller select ]

MenuState_4b:
@46ad:  jsr     DisableInterrupts
        jsr     DrawCharCtrlMenu
        jsr     InitCharCtrlWindowHDMA
        jsr     LoadCharCtrlCursor
        jsr     InitCharCtrlCursor
        jsr     CreateCursorTask
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #$4c
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $4c: update character controller select ]

.proc MenuState_4c
        jsr     InitDMA1BG3ScreenA
        jsr     UpdateCharCtrlCursor
        lda     z08+1
        bit     #>JOY_START
        bne     cancel
        lda     z08+1
        bit     #>JOY_B
        beq     :+
cancel: jsr     PlayCancelSfx
        lda     #MENU_STATE::CONFIG_INIT
        sta     zNextMenuState
        stz     zMenuState
        rts

:       lda     z0a+1
        bit     #>JOY_RIGHT
        bne     :+
        lda     z0a+1
        bit     #>JOY_LEFT
        beq     done
:       bra     ChangeCharCtrl
done:   rts
.endproc  ; MenuState_4c

; ------------------------------------------------------------------------------

; [ draw character controller select menu ]

DrawCharCtrlMenu:
@46f5:  ldy     #near CharCtrlWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        lda     #BG3_TEXT_COLOR::TEAL_ALT
        sta     zTextColor
        ldy     #near CharCtrlTitleText
        jsr     DrawPosText
        jsr     DrawChar1CtrlText
        jsr     DrawChar2CtrlText
        jsr     DrawChar3CtrlText
        jsr     DrawChar4CtrlText
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ change controller for character ]

ChangeCharCtrl:
@4717:  clr_a
        lda     z4b
        tax
        lda     zCharID,x
        bmi     @4729
        jsr     PlayMoveSfx
        lda     z4b
        asl
        tax
        jmp     (near ChangeCharCtrlTbl,x)
@4729:  rts

ChangeCharCtrlTbl:
@472a:  .addr   ChangeChar1Ctrl
        .addr   ChangeChar2Ctrl
        .addr   ChangeChar3Ctrl
        .addr   ChangeChar4Ctrl

; ------------------------------------------------------------------------------

; [ change controller for character 1 ]

ChangeChar1Ctrl:
@4732:  lda     $1d4f
        and     #$01
        lda     z0a+1
        bit     #$01
        beq     @4747
        lda     #$01
        ora     $1d4f
        sta     $1d4f
        bra     DrawChar1CtrlText
@4747:  lda     $1d4f
        and     #$fe
        sta     $1d4f
        bra     DrawChar1CtrlText

; ------------------------------------------------------------------------------

; [ change controller for character 2 ]

ChangeChar2Ctrl:
@4751:  lda     $1d4f
        and     #$02
        lda     z0a+1
        bit     #$01
        beq     @4767
        lda     #$02
        ora     $1d4f
        sta     $1d4f
        jmp     DrawChar2CtrlText
@4767:  lda     $1d4f
        and     #$fd
        sta     $1d4f
        jmp     DrawChar2CtrlText

; ------------------------------------------------------------------------------

; [ change controller for character 3 ]

ChangeChar3Ctrl:
@4772:  lda     $1d4f
        and     #$04
        lda     z0a+1
        bit     #$01
        beq     @4788
        lda     #$04
        ora     $1d4f
        sta     $1d4f
        jmp     DrawChar3CtrlText
@4788:  lda     $1d4f
        and     #$fb
        sta     $1d4f
        jmp     DrawChar3CtrlText

; ------------------------------------------------------------------------------

; [ change controller for character 4 ]

ChangeChar4Ctrl:
@4793:  lda     $1d4f
        and     #$08
        lda     z0a+1
        bit     #$01
        beq     @47a9
        lda     #$08
        ora     $1d4f
        sta     $1d4f
        jmp     DrawChar4CtrlText
@47a9:  lda     $1d4f
        and     #$f7
        sta     $1d4f
        jmp     DrawChar4CtrlText

; ------------------------------------------------------------------------------

; [ draw text for character 1 controller select ]

DrawChar1CtrlText:
@47b4:  lda     zCharID::Slot1
        bmi     @47f0
        ldx     zCharPropPtr::Slot1
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 14}
        jsr     DrawCharName
        lda     $1d4f
        and     #$01
        beq     @47d6
        lda     #BG3_TEXT_COLOR::GRAY
        jsr     @47df
        lda     #BG3_TEXT_COLOR::DEFAULT
        bra     @47e8
@47d6:  lda     #BG3_TEXT_COLOR::DEFAULT
        jsr     @47df
        lda     #BG3_TEXT_COLOR::GRAY
        bra     @47e8

@47df:  sta     zTextColor
        ldy     #near Char1Ctrl1Text
        jsr     DrawPosText
        rts

@47e8:  sta     zTextColor
        ldy     #near Char1Ctrl2Text
        jsr     DrawPosText
@47f0:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 2 controller select ]

DrawChar2CtrlText:
@47f1:  lda     zCharID::Slot2
        bmi     @482d
        ldx     zCharPropPtr::Slot2
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 16}
        jsr     DrawCharName
        lda     $1d4f
        and     #$02
        beq     @4813
        lda     #BG3_TEXT_COLOR::GRAY
        jsr     @481c
        lda     #BG3_TEXT_COLOR::DEFAULT
        bra     @4825
@4813:  lda     #BG3_TEXT_COLOR::DEFAULT
        jsr     @481c
        lda     #BG3_TEXT_COLOR::GRAY
        bra     @4825

@481c:  sta     zTextColor
        ldy     #near Char2Ctrl1Text
        jsr     DrawPosText
        rts

@4825:  sta     zTextColor
        ldy     #near Char2Ctrl2Text
        jsr     DrawPosText
@482d:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 3 controller select ]

DrawChar3CtrlText:
@482e:  lda     zCharID::Slot3
        bmi     @486a
        ldx     zCharPropPtr::Slot3
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 18}
        jsr     DrawCharName
        lda     $1d4f
        and     #$04
        beq     @4850
        lda     #BG3_TEXT_COLOR::GRAY
        jsr     @4859
        lda     #BG3_TEXT_COLOR::DEFAULT
        bra     @4862
@4850:  lda     #BG3_TEXT_COLOR::DEFAULT
        jsr     @4859
        lda     #BG3_TEXT_COLOR::GRAY
        bra     @4862

@4859:  sta     zTextColor
        ldy     #near Char3Ctrl1Text
        jsr     DrawPosText
        rts

@4862:  sta     zTextColor
        ldy     #near Char3Ctrl2Text
        jsr     DrawPosText
@486a:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 4 controller select ]

DrawChar4CtrlText:
@486b:  lda     zCharID::Slot4
        bmi     @48a7
        ldx     zCharPropPtr::Slot4
        stx     zSelCharPropPtr
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy_pos BG3A, {3, 20}
        jsr     DrawCharName
        lda     $1d4f
        and     #$08
        beq     @488d
        lda     #BG3_TEXT_COLOR::GRAY
        jsr     @4896
        lda     #BG3_TEXT_COLOR::DEFAULT
        bra     @489f
@488d:  lda     #BG3_TEXT_COLOR::DEFAULT
        jsr     @4896
        lda     #BG3_TEXT_COLOR::GRAY
        bra     @489f

@4896:  sta     zTextColor
        ldy     #near Char4Ctrl1Text
        jsr     DrawPosText
        rts

@489f:  sta     zTextColor
        ldy     #near Char4Ctrl2Text
        jsr     DrawPosText
@48a7:  rts

; ------------------------------------------------------------------------------

; [ init window 2 HDMA for character controller select ]

InitCharCtrlWindowHDMA:
@48a8:  lda     #$01
        sta     hDMA5::CTRL
        lda     #<hWH2
        sta     hDMA5::HREG
        ldy     #near CharCtrlWindowHDMATbl
        sty     hDMA5::ADDR
        lda     #^CharCtrlWindowHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^CharCtrlWindowHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; window 2 position HDMA table (character controller select)
CharCtrlWindowHDMATbl:
        hdma_2byte 39, {$ff, $ff}
        hdma_2byte 48, {$08, $f7}
        hdma_2byte 104, {$ff, $ff}
        hdma_2byte 16, {$08, $f7}
        hdma_2byte 16, {$ff, $ff}
        hdma_end

; ------------------------------------------------------------------------------

; [ init cursor for character controller select ]

LoadCharCtrlCursor:
@48d7:  ldy     #near CharCtrlCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for character controller select ]

UpdateCharCtrlCursor:
@48dd:  jsr     MoveCursor

InitCharCtrlCursor:
@48e0:  ldy     #near CharCtrlCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

CharCtrlCursorProp:
        cursor_prop {0, 0}, {1, 4}, NO_X_WRAP

CharCtrlCursorPos:
@48eb:  cursor_pos {80, 123}
        cursor_pos {80, 139}
        cursor_pos {80, 155}
        cursor_pos {80, 171}

; ------------------------------------------------------------------------------

; window for character controller select
CharCtrlWindow:                         make_window BG2A, {1, 11}, {28, 11}

; ------------------------------------------------------------------------------

.if !LANG_EN

DrawCtrlConfigMenu:
@4a2c:  ldy     #near CtrlConfigMainWindow
        jsr     DrawWindow
        ldy     #near CtrlConfigTitleWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #$2c
        sta     zTextColor
        ldx     #near CtrlConfigTitleTextList
        ldy     #$0010
        jsr     DrawPosKanaList
        lda     #$2c
        sta     zTextColor
        ldx     #near CtrlConfigButtonTextList
        ldy     #$000e
        jsr     DrawPosList
        jsr     _c34af6
        jsr     _c34b22
        jsr     _c34b44
        jsr     _c34b68
        jsr     _c34b8a
        jsr     _c34bae
        jsr     _c34bd0
        jsr     TfrBG1ScreenAB
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

CtrlConfigMainWindow:                   make_window BG2A, {1, 3}, {28, 22}
CtrlConfigTitleWindow:                  make_window BG2A, {21, 1}, {8, 2}

; ------------------------------------------------------------------------------

InitCtrlConfigWindowHDMA:
@4a84:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #near CtrlConfigScrollHDMATbl
        sty     $4352
        lda     #^CtrlConfigScrollHDMATbl
        sta     $4354
        lda     #^CtrlConfigScrollHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

CtrlConfigScrollHDMATbl:
@4aa3:  hdma_word 47, 0
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

LoadCtrlConfigCursor:
@4ad4:  ldy     #near _c34ae3
        jmp     LoadCursor

; ------------------------------------------------------------------------------

UpdateCtrlConfigCursor:
@4ada:  jsr     MoveCursor

InitCtrlConfigCursor:
@4add:  ldy     #near _c34ae8
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

_c34ae3:
@4ae3:  cursor_prop {0, 0}, {1, 7}

_c34ae8:
@4ae8:  cursor_pos {16, 35}
        cursor_pos {16, 59}
        cursor_pos {16, 83}
        cursor_pos {16, 107}
        cursor_pos {16, 131}
        cursor_pos {16, 155}
        cursor_pos {16, 179}

; ------------------------------------------------------------------------------

_c34af6:
@4af6:  lda     #$24
        sta     zTextColor
        ldx     #near CtrlConfigActionTextList1
        ldy     #sizeof_CtrlConfigActionTextList1
        jsr     DrawPosKanaList
        clr_a
        lda     $1d50
        and     #$f0
        lsr3
        tax
        longa
        lda     f:CtrlConfigActionTextList1-2,x
        sta     $e7
        shorta

_c34b17:
@4b17:  lda     #$c3
        sta     $e9
        lda     #$20
        sta     zTextColor
        jmp     DrawPosKanaFar

; ------------------------------------------------------------------------------

_c34b22:
@4b22:  lda     #$24
        sta     zTextColor
        ldx     #near CtrlConfigActionTextList2
        ldy     #sizeof_CtrlConfigActionTextList2
        jsr     DrawPosKanaList
        clr_a
        lda     $1d50
        and     #$0f
        asl
        tax
        longa
        lda     f:CtrlConfigActionTextList2-2,x
        sta     $e7
        shorta
        jmp     _c34b17

; ------------------------------------------------------------------------------

_c34b44:
@4b44:  lda     #$24
        sta     zTextColor
        ldx     #near CtrlConfigActionTextList3
        ldy     #sizeof_CtrlConfigActionTextList3
        jsr     DrawPosKanaList
        clr_a
        lda     $1d51
        and     #$f0
        lsr3
        tax
        longa
        lda     f:CtrlConfigActionTextList3-2,x
        sta     $e7
        shorta
        jmp     _c34b17

; ------------------------------------------------------------------------------

_c34b68:
@4b68:  lda     #$24
        sta     zTextColor
        ldx     #near CtrlConfigActionTextList4
        ldy     #sizeof_CtrlConfigActionTextList4
        jsr     DrawPosKanaList
        clr_a
        lda     $1d51
        and     #$0f
        asl
        tax
        longa
        lda     f:CtrlConfigActionTextList4-2,x
        sta     $e7
        shorta
        jmp     _c34b17

; ------------------------------------------------------------------------------

_c34b8a:
@4b8a:  lda     #$24
        sta     zTextColor
        ldx     #near CtrlConfigActionTextList5
        ldy     #sizeof_CtrlConfigActionTextList5
        jsr     DrawPosKanaList
        clr_a
        lda     $1d52
        and     #$f0
        lsr3
        tax
        longa
        lda     f:CtrlConfigActionTextList5-2,x
        sta     $e7
        shorta
        jmp     _c34b17

; ------------------------------------------------------------------------------

_c34bae:
@4bae:  lda     #$24
        sta     zTextColor
        ldx     #near CtrlConfigActionTextList6
        ldy     #sizeof_CtrlConfigActionTextList6
        jsr     DrawPosKanaList
        clr_a
        lda     $1d52
        and     #$0f
        asl
        tax
        longa
        lda     f:CtrlConfigActionTextList6-2,x
        sta     $e7
        shorta
        jmp     _c34b17

; ------------------------------------------------------------------------------

_c34bd0:
@4bd0:  lda     #$24
        sta     zTextColor
        ldx     #near CtrlConfigActionTextList7
        ldy     #sizeof_CtrlConfigActionTextList7
        jsr     DrawPosKanaList
        clr_a
        lda     $1d53
        and     #$0f
        asl
        tax
        longa
        lda     f:CtrlConfigActionTextList7-2,x
        sta     $e7
        shorta
        jmp     _c34b17

; ------------------------------------------------------------------------------

_c24bf2:
@4bf2:  clr_a
        lda     $4b
        asl
        tax
        jmp     (near @4bfa,x)

@4bfa:  .addr   @4c08,@4c44,@4c74,@4cb0,@4ce0,@4d1c,@4d4c

; ------------------------------------------------------------------------------

@4c08:  lda     $1d50
        and     #$f0
        lsr4
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @4c24
        lda     $e0
        cmp     #$06
        beq     @4c23
        inc     $e0
        bra     @4c2f
@4c23:  rts
@4c24:  lda     $e0
        cmp     #$01
        beq     @4c2e
        dec     $e0
        bra     @4c2f
@4c2e:  rts
@4c2f:  lda     $e0
        asl4
        sta     $e0
        lda     $1d50
        and     #$0f
        ora     $e0
        sta     $1d50
        jmp     _c34af6

; ------------------------------------------------------------------------------

@4c44:  lda     $1d50
        and     #$0f
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @4c5c
        lda     $e0
        cmp     #$06
        beq     @4c5b
        inc     $e0
        bra     @4c67
@4c5b:  rts
@4c5c:  lda     $e0
        cmp     #$01
        beq     @4c66
        dec     $e0
        bra     @4c67
@4c66:  rts
@4c67:  lda     $1d50
        and     #$f0
        ora     $e0
        sta     $1d50
        jmp     _c34b22

; ------------------------------------------------------------------------------

@4c74:  lda     $1d51
        and     #$f0
        lsr4
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @4c90
        lda     $e0
        cmp     #$06
        beq     @4c8f
        inc     $e0
        bra     @4c9b
@4c8f:  rts
@4c90:  lda     $e0
        cmp     #$01
        beq     @4c9a
        dec     $e0
        bra     @4c9b
@4c9a:  rts
@4c9b:  lda     $e0
        asl4
        sta     $e0
        lda     $1d51
        and     #$0f
        ora     $e0
        sta     $1d51
        jmp     _c34b44

; ------------------------------------------------------------------------------

@4cb0:  lda     $1d51
        and     #$0f
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @4cc8
        lda     $e0
        cmp     #$06
        beq     @4cc7
        inc     $e0
        bra     @4cd3
@4cc7:  rts
@4cc8:  lda     $e0
        cmp     #$01
        beq     @4cd2
        dec     $e0
        bra     @4cd3
@4cd2:  rts
@4cd3:  lda     $1d51
        and     #$f0
        ora     $e0
        sta     $1d51
        jmp     _c34b68

; ------------------------------------------------------------------------------

@4ce0:  lda     $1d52
        and     #$f0
        lsr4
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @4cfc
        lda     $e0
        cmp     #$06
        beq     @4cfb
        inc     $e0
        bra     @4d07
@4cfb:  rts
@4cfc:  lda     $e0
        cmp     #$01
        beq     @4d06
        dec     $e0
        bra     @4d07
@4d06:  rts
@4d07:  lda     $e0
        asl4
        sta     $e0
        lda     $1d52
        and     #$0f
        ora     $e0
        sta     $1d52
        jmp     _c34b8a

; ------------------------------------------------------------------------------

@4d1c:  lda     $1d52
        and     #$0f
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @4d34
        lda     $e0
        cmp     #$06
        beq     @4d33
        inc     $e0
        bra     @4d3f
@4d33:  rts
@4d34:  lda     $e0
        cmp     #$01
        beq     @4d3e
        dec     $e0
        bra     @4d3f
@4d3e:  rts
@4d3f:  lda     $1d52
        and     #$f0
        ora     $e0
        sta     $1d52
        jmp     _c34bae

; ------------------------------------------------------------------------------

@4d4c:  lda     $1d53
        and     #$0f
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @4d64
        lda     $e0
        cmp     #$06
        beq     @4d63
        inc     $e0
        bra     @4d6f
@4d63:  rts
@4d64:  lda     $e0
        cmp     #$01
        beq     @4d6e
        dec     $e0
        bra     @4d6f
@4d6e:  rts
@4d6f:  lda     $1d53
        and     #$f0
        ora     $e0
        sta     $1d53
        jmp     _c34bd0

; ------------------------------------------------------------------------------

ValidateCtrlConfig:
@4d7c:  lda     $1d50
        and     #$0f
        sta     $7e9d89
        lda     $1d50
        and     #$f0
        lsr4
        sta     $7e9d8a
        lda     $1d51
        and     #$0f
        sta     $7e9d8b
        lda     $1d51
        and     #$f0
        lsr4
        sta     $7e9d8c
        lda     $1d52
        and     #$0f
        sta     $7e9d8d
        lda     $1d52
        and     #$f0
        lsr4
        sta     $7e9d8e
        lda     $1d53
        and     #$0f
        sta     $7e9d8f
        lda     #$01
        sta     $e0
        ldy     z0
@4dcd:  ldx     z0
@4dcf:  lda     $7e9d89,x
        cmp     $e0
        beq     @4ddf
        inx
        cpx     #7
        bne     @4dcf
        txa
        rts
@4ddf:  inc     $e0
        iny
        cpy     #6
        bne     @4dcd
        clr_a
        rts

.endif

; ------------------------------------------------------------------------------

; [ clear saved cursor positions ]

_c348f7:
@48f7:  clr_ax
@48f9:  sta     $022b,x     ; clear saved cursor positions
        inx
        cpx     #$001f
        bne     @48f9
        rts

; ------------------------------------------------------------------------------

ConfigLabelTextList1:
        .addr   ConfigControllerText
        .addr   ConfigCursorText
        calc_size ConfigLabelTextList1

ConfigSpeedTextList:
        .addr   ConfigFastText
        .addr   ConfigSlowText
        calc_size ConfigSpeedTextList

ConfigControllerText:           pos_text CONFIG_CONTROLLER
ConfigWaitText:                 pos_text CONFIG_WAIT
ConfigFastText:                 pos_text CONFIG_FAST
ConfigSlowText:                 pos_text CONFIG_SLOW
ConfigCmdShortText:             pos_text CONFIG_CMD_SHORT
ConfigGaugeOnText:              pos_text CONFIG_GAUGE_ON
ConfigGaugeOffText:             pos_text CONFIG_GAUGE_OFF
ConfigStereoText:               pos_text CONFIG_STEREO
ConfigMonoText:                 pos_text CONFIG_MONO
ConfigMemoryText:               pos_text CONFIG_MEMORY
ConfigOptimumText:              pos_text CONFIG_OPTIMUM
.if !LANG_EN
ConfigCtrlNormalText:           pos_text CONFIG_CTRL_NORMAL
ConfigCtrlCustomText:           pos_text CONFIG_CTRL_CUSTOM
.endif
ConfigCtrlMultiText:            pos_text CONFIG_CTRL_MULTI
ConfigBattleSpeedNumText:       pos_text CONFIG_BATTLE_SPEED_NUM
ConfigMsgSpeedNumText:          pos_text CONFIG_MSG_SPEED_NUM
ConfigCursorText:               pos_text CONFIG_CURSOR

ConfigLabelTextList2:
        .addr   ConfigBattleModeText
        .addr   ConfigBattleSpeedText
        .addr   ConfigMsgSpeedText
        .addr   ConfigCmdSetText
        .addr   ConfigGaugeText
        .addr   ConfigSoundText
        .addr   ConfigReequipText
        calc_size ConfigLabelTextList2

ConfigTitleText:                pos_text CONFIG_TITLE
ConfigBattleModeText:           pos_text CONFIG_BATTLE_MODE
ConfigBattleSpeedText:          pos_text CONFIG_BATTLE_SPEED
ConfigMsgSpeedText:             pos_text CONFIG_MSG_SPEED
ConfigCmdSetText:               pos_text CONFIG_CMD_SET
ConfigGaugeText:                pos_text CONFIG_GAUGE
ConfigSoundText:                pos_text CONFIG_SOUND
ConfigReequipText:              pos_text CONFIG_REEQUIP
ConfigActiveText:               pos_text CONFIG_ACTIVE
ConfigCmdWindowText:            pos_text CONFIG_CMD_WINDOW
ConfigResetText:                pos_text CONFIG_RESET
ConfigEmptyText:                pos_text CONFIG_EMPTY
ConfigCtrlSingleText:           pos_text CONFIG_CTRL_SINGLE

ConfigLabelTextList3:
        .addr   ConfigMagicOrderText
        .addr   ConfigWindowLabelText
        .addr   ConfigColorText
        calc_size ConfigLabelTextList3

; color selector bars
ConfigColorBarTextList:
        .addr   ConfigColorBarRText
        .addr   ConfigColorBarGText
        .addr   ConfigColorBarBText
        calc_size ConfigColorBarTextList

ConfigLabelTextList4:
        .addr   ConfigColorRText
        .addr   ConfigColorGText
        .addr   ConfigColorBText
        .addr   ConfigMagicOrderAText
        .addr   ConfigMagicOrderBText
        .addr   ConfigMagicOrderCText
        calc_size ConfigLabelTextList4

ConfigMagicOrderText:           pos_text CONFIG_MAGIC_ORDER
ConfigWindowLabelText:          pos_text CONFIG_WINDOW_LABEL
ConfigColorText:                pos_text CONFIG_COLOR
ConfigMagicOrderAText:          pos_text CONFIG_MAGIC_ORDER_A
ConfigMagicOrderBText:          pos_text CONFIG_MAGIC_ORDER_B
ConfigMagicOrderCText:          pos_text CONFIG_MAGIC_ORDER_C
ConfigColorBarRText:            pos_text CONFIG_COLOR_BAR_R
ConfigColorBarGText:            pos_text CONFIG_COLOR_BAR_G
ConfigColorBarBText:            pos_text CONFIG_COLOR_BAR_B
ConfigColorRText:               pos_text CONFIG_COLOR_R
ConfigColorGText:               pos_text CONFIG_COLOR_G
ConfigColorBText:               pos_text CONFIG_COLOR_B
ConfigWindowNumText:            pos_text CONFIG_WINDOW_NUM
ConfigMagicOrderNumText:        pos_text CONFIG_MAGIC_ORDER_NUM
ConfigFontText:                 pos_text CONFIG_FONT
ConfigWindowText:               pos_text CONFIG_WINDOW

ConfigReturnText:               pos_text CONFIG_RETURN
ConfigColorBoxText:             pos_text CONFIG_COLOR_BOX
ConfigMagicTypeText:            raw_text CONFIG_MAGIC_TYPE_1
                                raw_text CONFIG_MAGIC_TYPE_2
                                raw_text CONFIG_MAGIC_TYPE_3

; ------------------------------------------------------------------------------

CmdArrangeTitleText:            pos_text CMD_ARRANGE_TITLE

CharCtrlTitleText:              pos_text CHAR_CTRL_TITLE
Char1Ctrl1Text:                 pos_text CHAR_1_CTRL_1
Char1Ctrl2Text:                 pos_text CHAR_1_CTRL_2
Char2Ctrl1Text:                 pos_text CHAR_2_CTRL_1
Char2Ctrl2Text:                 pos_text CHAR_2_CTRL_2
Char3Ctrl1Text:                 pos_text CHAR_3_CTRL_1
Char3Ctrl2Text:                 pos_text CHAR_3_CTRL_2
Char4Ctrl1Text:                 pos_text CHAR_4_CTRL_1
Char4Ctrl2Text:                 pos_text CHAR_4_CTRL_2

; ------------------------------------------------------------------------------

.if !LANG_EN

CtrlConfigTitleTextList:
        .addr   CtrlConfigTitleText
        .addr   CtrlConfigButtonText1
        .addr   CtrlConfigButtonText2
        .addr   CtrlConfigButtonText3
        .addr   CtrlConfigButtonText4
        .addr   CtrlConfigButtonText5
        .addr   CtrlConfigButtonText6
        .addr   CtrlConfigButtonText7
        calc_size CtrlConfigTitleTextList

CtrlConfigButtonTextList:
        .addr   CtrlConfigAText
        .addr   CtrlConfigBText
        .addr   CtrlConfigXText
        .addr   CtrlConfigYText
        .addr   CtrlConfigLText
        .addr   CtrlConfigRText
        .addr   CtrlConfigSelectText
        calc_size CtrlConfigButtonTextList

CtrlConfigActionTextList1:
        .addr   CtrlConfigConfirmText1
        .addr   CtrlConfigCancelText1
        .addr   CtrlConfigMenuText1
        .addr   CtrlConfigPartyText1
        .addr   CtrlConfigRowText1
        .addr   CtrlConfigDefText1
        calc_size CtrlConfigActionTextList1

CtrlConfigActionTextList2:
        .addr   CtrlConfigConfirmText2
        .addr   CtrlConfigCancelText2
        .addr   CtrlConfigMenuText2
        .addr   CtrlConfigPartyText2
        .addr   CtrlConfigRowText2
        .addr   CtrlConfigDefText2
        calc_size CtrlConfigActionTextList2

CtrlConfigActionTextList3:
        .addr   CtrlConfigConfirmText3
        .addr   CtrlConfigCancelText3
        .addr   CtrlConfigMenuText3
        .addr   CtrlConfigPartyText3
        .addr   CtrlConfigRowText3
        .addr   CtrlConfigDefText3
        calc_size CtrlConfigActionTextList3

CtrlConfigActionTextList4:
        .addr   CtrlConfigConfirmText4
        .addr   CtrlConfigCancelText4
        .addr   CtrlConfigMenuText4
        .addr   CtrlConfigPartyText4
        .addr   CtrlConfigRowText4
        .addr   CtrlConfigDefText4
        calc_size CtrlConfigActionTextList4

CtrlConfigActionTextList5:
        .addr   CtrlConfigConfirmText5
        .addr   CtrlConfigCancelText5
        .addr   CtrlConfigMenuText5
        .addr   CtrlConfigPartyText5
        .addr   CtrlConfigRowText5
        .addr   CtrlConfigDefText5
        calc_size CtrlConfigActionTextList5

CtrlConfigActionTextList6:
        .addr   CtrlConfigConfirmText6
        .addr   CtrlConfigCancelText6
        .addr   CtrlConfigMenuText6
        .addr   CtrlConfigPartyText6
        .addr   CtrlConfigRowText6
        .addr   CtrlConfigDefText6
        calc_size CtrlConfigActionTextList6

CtrlConfigActionTextList7:
        .addr   CtrlConfigConfirmText7
        .addr   CtrlConfigCancelText7
        .addr   CtrlConfigMenuText7
        .addr   CtrlConfigPartyText7
        .addr   CtrlConfigRowText7
        .addr   CtrlConfigDefText7
        calc_size CtrlConfigActionTextList7

CtrlConfigTitleText:            pos_text CTRL_CONFIG_TITLE

CtrlConfigConfirmText1:         pos_text CTRL_CONFIG_CONFIRM_1
CtrlConfigCancelText1:          pos_text CTRL_CONFIG_CANCEL_1
CtrlConfigMenuText1:            pos_text CTRL_CONFIG_MENU_1
CtrlConfigPartyText1:           pos_text CTRL_CONFIG_PARTY_1
CtrlConfigRowText1:             pos_text CTRL_CONFIG_ROW_1
CtrlConfigDefText1:             pos_text CTRL_CONFIG_DEF_1

CtrlConfigConfirmText2:         pos_text CTRL_CONFIG_CONFIRM_2
CtrlConfigCancelText2:          pos_text CTRL_CONFIG_CANCEL_2
CtrlConfigMenuText2:            pos_text CTRL_CONFIG_MENU_2
CtrlConfigPartyText2:           pos_text CTRL_CONFIG_PARTY_2
CtrlConfigRowText2:             pos_text CTRL_CONFIG_ROW_2
CtrlConfigDefText2:             pos_text CTRL_CONFIG_DEF_2

CtrlConfigConfirmText3:         pos_text CTRL_CONFIG_CONFIRM_3
CtrlConfigCancelText3:          pos_text CTRL_CONFIG_CANCEL_3
CtrlConfigMenuText3:            pos_text CTRL_CONFIG_MENU_3
CtrlConfigPartyText3:           pos_text CTRL_CONFIG_PARTY_3
CtrlConfigRowText3:             pos_text CTRL_CONFIG_ROW_3
CtrlConfigDefText3:             pos_text CTRL_CONFIG_DEF_3

CtrlConfigConfirmText4:         pos_text CTRL_CONFIG_CONFIRM_4
CtrlConfigCancelText4:          pos_text CTRL_CONFIG_CANCEL_4
CtrlConfigMenuText4:            pos_text CTRL_CONFIG_MENU_4
CtrlConfigPartyText4:           pos_text CTRL_CONFIG_PARTY_4
CtrlConfigRowText4:             pos_text CTRL_CONFIG_ROW_4
CtrlConfigDefText4:             pos_text CTRL_CONFIG_DEF_4

CtrlConfigConfirmText5:         pos_text CTRL_CONFIG_CONFIRM_5
CtrlConfigCancelText5:          pos_text CTRL_CONFIG_CANCEL_5
CtrlConfigMenuText5:            pos_text CTRL_CONFIG_MENU_5
CtrlConfigPartyText5:           pos_text CTRL_CONFIG_PARTY_5
CtrlConfigRowText5:             pos_text CTRL_CONFIG_ROW_5
CtrlConfigDefText5:             pos_text CTRL_CONFIG_DEF_5

CtrlConfigConfirmText6:         pos_text CTRL_CONFIG_CONFIRM_6
CtrlConfigCancelText6:          pos_text CTRL_CONFIG_CANCEL_6
CtrlConfigMenuText6:            pos_text CTRL_CONFIG_MENU_6
CtrlConfigPartyText6:           pos_text CTRL_CONFIG_PARTY_6
CtrlConfigRowText6:             pos_text CTRL_CONFIG_ROW_6
CtrlConfigDefText6:             pos_text CTRL_CONFIG_DEF_6

CtrlConfigConfirmText7:         pos_text CTRL_CONFIG_CONFIRM_7
CtrlConfigCancelText7:          pos_text CTRL_CONFIG_CANCEL_7
CtrlConfigMenuText7:            pos_text CTRL_CONFIG_MENU_7
CtrlConfigPartyText7:           pos_text CTRL_CONFIG_PARTY_7
CtrlConfigRowText7:             pos_text CTRL_CONFIG_ROW_7
CtrlConfigDefText7:             pos_text CTRL_CONFIG_DEF_7

CtrlConfigButtonText1:          pos_text CTRL_CONFIG_BUTTON_1
CtrlConfigButtonText2:          pos_text CTRL_CONFIG_BUTTON_2
CtrlConfigButtonText3:          pos_text CTRL_CONFIG_BUTTON_3
CtrlConfigButtonText4:          pos_text CTRL_CONFIG_BUTTON_4
CtrlConfigButtonText5:          pos_text CTRL_CONFIG_BUTTON_5
CtrlConfigButtonText6:          pos_text CTRL_CONFIG_BUTTON_6
CtrlConfigButtonText7:          pos_text CTRL_CONFIG_BUTTON_7

CtrlConfigAText:                pos_text CTRL_CONFIG_A
CtrlConfigBText:                pos_text CTRL_CONFIG_B
CtrlConfigXText:                pos_text CTRL_CONFIG_X
CtrlConfigYText:                pos_text CTRL_CONFIG_Y
CtrlConfigLText:                pos_text CTRL_CONFIG_L
CtrlConfigRText:                pos_text CTRL_CONFIG_R
CtrlConfigSelectText:           pos_text CTRL_CONFIG_SELECT

.endif

; ------------------------------------------------------------------------------
