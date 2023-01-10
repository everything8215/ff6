
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

; ------------------------------------------------------------------------------

; [ init cursor (config page 1) ]

LoadConfigPage1Cursor:
@3858:  ldy     #.loword(ConfigPage1CursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (config page 1) ]

UpdateConfigPage1Cursor:
@385e:  jsr     MoveCursor

InitConfigPage1Cursor:
@3861:  ldy     #.loword(ConfigPage1CursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

ConfigPage1CursorProp:
@3867:  .byte   $81,$00,$00,$01,$09

ConfigPage1CursorPos:
@386c:  .byte   $60,$29
        .byte   $60,$39
        .byte   $60,$49
        .byte   $60,$59
        .byte   $60,$69
        .byte   $60,$79
        .byte   $60,$89
        .byte   $60,$99
        .byte   $60,$a9

; ------------------------------------------------------------------------------

; [ init cursor (config page 2) ]

LoadConfigPage2Cursor:
@387e:  ldy     #.loword(ConfigPage2CursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (config page 2) ]

UpdateConfigPage2Cursor:
@3884:  jsr     MoveCursor

InitConfigPage2Cursor:
@3887:  ldy     #.loword(ConfigPage2CursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

ConfigPage2CursorProp:
@388d:  .byte   $81,$00,$00,$01,$06

ConfigPage2CursorPos:
@3892:  .byte   $60,$29
        .byte   $60,$69
        .byte   $60,$79
        .byte   $60,$99
        .byte   $60,$a9
        .byte   $60,$b9

; ------------------------------------------------------------------------------

; [ init config bg ]

DrawConfigMenu:
@389e:  lda     #$02
        sta     hBG1SC
        ldy     #$fffb
        sty     $3f
        jsr     ClearBG2ScreenA
        ldy     #.loword(ConfigMainWindow)
        jsr     DrawWindow
        ldy     #.loword(ConfigLabelWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     _c3395e
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #$2c
        sta     $29
        ldy     #.loword(ConfigTitleText)
        jsr     DrawPosText
        lda     #$24
        sta     $29
        ldx     #.loword(ConfigLabelTextList2)
        ldy     #$000e
        jsr     DrawPosList
        lda     #$24
        sta     $29
        ldx     #.loword(ConfigLabelTextList1)
        ldy     #$0004
        jsr     DrawPosList
        lda     #$20
        sta     $29
        ldx     #.loword(ConfigSpeedTextList)
        ldy     #$0004
        jsr     DrawPosList
        jsr     DrawActiveWaitText
        jsr     DrawBattleSpeedText
        jsr     DrawMsgSpeedText
        jsr     DrawCmdConfigText
        jsr     DrawGaugeConfigText
        jsr     DrawStereoMonoText
        jsr     DrawCursorConfigText
        jsr     DrawReequipConfigText
        jsr     DrawCtrlConfigText
        lda     #$24
        sta     $29
        ldx     #.loword(ConfigLabelTextList3)
        ldy     #$0006
        jsr     DrawPosList
        jsr     _c33950
        lda     #$20
        sta     $29
        ldx     #.loword(ConfigLabelTextList4)
        ldy     #$000c
        jsr     DrawPosList
        jsr     DrawConfigMagicOrder
        jsr     DrawConfigWindowNumList
        jsr     DrawConfigColors
        jsr     UpdateConfigColorBars
        jsr     ShowConfigPage1
        jsr     TfrBG1ScreenAB
        jsr     TfrBG3ScreenAB
        lda     #1
        ldy     #.loword(ConfigScrollArrowTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ draw color selector bars ]

_c33950:
@3950:  lda     #$30        ; use palette 8
        sta     $29
        ldx     #.loword(ConfigColorBarTextList)
        ldy     #$0006
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3395e:
@395e:  ldx     $00
        lda     #$40
        sta     hCGADD
@3965:  longa
        lda     f:MenuPal+$80,x
        sta     $7e30c9,x
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
        jmp     (.loword(ConfigScrollArrowTaskTbl),x)

ConfigScrollArrowTaskTbl:
@3984:  .addr   ConfigScrollArrowTask_00
        .addr   ConfigScrollArrowTask_01

; ------------------------------------------------------------------------------

; state 0: init

ConfigScrollArrowTask_00:
@3988:  ldx     $2d
        longa
        lda     #.loword(ConfigScrollArrowAnim_00)
        sta     $32c9,x
        lda     #$0078
        sta     $33ca,x
        lda     #$0018
        sta     $344a,x
        shorta
        lda     #^ConfigScrollArrowAnim_00
        sta     $35ca,x
        inc     $3649,x
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; state 1: update

ConfigScrollArrowTask_01:
@39ab:  ldy     $2d
        lda     $4a                     ; page number
        beq     @39b5
        lda     #2                      ; page 2
        bra     @39b6
@39b5:  clr_a                           ; page 1
@39b6:  tax
        longa
        lda     f:ConfigScrollArrowAnimTbl,x
        sta     $32c9,y                 ; set pointer to animation data
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
ConfigMainWindow:
@39e2:  .byte   $0b,$59,$1c,$16

ConfigLabelWindow:
@39e6:  .byte   $b7,$58,$06,$02

; ------------------------------------------------------------------------------

; [ switch to config page 2 ]

ShowConfigPage2:
@39ea:  ldy     #$00fb
        sty     $37
        jsr     LoadConfigPage2Cursor
        jmp     InitConfigPage2Cursor

; ------------------------------------------------------------------------------

; [ switch to config page 1 ]

ShowConfigPage1:
@39f5:  ldy     #$fffb
        sty     $37
        jsr     LoadConfigPage1Cursor
        jmp     InitConfigPage1Cursor

; ------------------------------------------------------------------------------

; [ menu state $50: scroll to config page 2 ]

MenuState_50:
@3a00:  lda     $20
        beq     @3a15
        lda     $4a
        bne     @3a1c
        longa
        lda     $37
        clc
        adc     #$0010
        sta     $37
        shorta
        rts
@3a15:  lda     #$01
        sta     $4a
        jsr     ShowConfigPage2
@3a1c:  lda     #$0e
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $51: scroll to config page 1 ]

MenuState_51:
@3a21:  lda     $20
        beq     @3a36
        lda     $4a
        beq     @3a47
        longa
        lda     $37
        sec
        sbc     #$0010
        sta     $37
        shorta
        rts
@3a36:  stz     $4a
        ldy     #$fffb
        sty     $37
        jsr     LoadConfigPage1Cursor
        lda     #$08
        sta     $4e
        jsr     InitConfigPage1Cursor
@3a47:  lda     #$0e
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ init window 2 position hdma ]

InitWindow2PosHDMA:
@3a4c:  lda     #$01
        sta     $4350
        lda     #$28
        sta     $4351
        ldy     #.loword(Window2PosHDMATbl)
        sty     $4352
        lda     #^Window2PosHDMATbl
        sta     $4354
        lda     #^Window2PosHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ disable window 2 position hdma ]

DisableWindow2PosHDMA:
@3a6b:  lda     #$20        ; disable hdma channel #5
        trb     $43
        lda     #$08
        sta     hWH2
        lda     #$f7
        sta     hWH3
        rts

; ------------------------------------------------------------------------------

Window2PosHDMATbl:
@3a7a:  .byte   $27,$ff,$ff
        .byte   $50,$08,$f7
        .byte   $50,$08,$f7
        .byte   $10,$ff,$ff
        .byte   $00

; ------------------------------------------------------------------------------

; [ load window graphics ]

LoadWindowGfx:
@3a87:  ldy     #$7800                  ; vram $7800 (menu window graphics)
        sty     $14
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
        sty     $14
        ldy     $91
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
        sty     $14
        ldy     $93
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
        sty     $14
        ldy     $95
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
@3af5:  ldy     $91
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
@3b09:  ldy     $93
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
@3b1d:  ldy     $95
        beq     @3b27
        lda     $307b4e
        bra     @3b28
@3b27:  clr_a
@3b28:  ldx     $00
        jsr     LoadWindowPal
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ init menu window graphics transfer to VRAM in DMA 1 ]

InitTfrWindowGfx:
@3b30:  and     #$0f
        sta     $e0
        stz     $e1
        ldy     #.loword(WindowGfx)
        sty     $16
        lda     #^WindowGfx
        sta     $18
        longa
        clr_a
@3b42:  ldy     $e0
        beq     @3b4e
        clc
        adc     #$0380
        dec     $e0
        bra     @3b42
@3b4e:  clc
        adc     $16
        sta     $16
        shorta
        ldy     #$0400
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ load menu window palette ]

LoadWindowPal:
@3b5b:  and     #$0f
        sta     $e0
        phx
        lda     #$00
        sta     $e9
        stz     $e1
        longa
        lda     #$1d57                  ; window palette
@3b6b:  ldy     $e0
        beq     @3b77
        clc
        adc     #$000e
        dec     $e0
        bra     @3b6b
@3b77:  sta     $e7
        shorta
        ldy     $00
        plx
@3b7e:  lda     [$e7],y
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
        lda     #$28
        jsr     @3ba5
        lda     #$20
        bra     @3bae
@3b9c:  lda     #$20
        jsr     @3ba5
        lda     #$28
        bra     @3bae
@3ba5:  sta     $29
        ldy     #.loword(ConfigActiveText)
        jsr     DrawPosText
        rts
@3bae:  sta     $29
        ldy     #.loword(ConfigWaitText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw battle speed numerals ]

DrawBattleSpeedText:
@3bb7:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigBattleSpeedNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d4d
        and     #$07
        asl
        tax
        longa
        lda     f:BattleSpeedTextPos,x
        sta     $f7
        shorta
        lda     $1d4d
        and     #$07
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
        jmp     DrawConfigNum

; ------------------------------------------------------------------------------

BattleSpeedTextPos:
@3be6:  .byte   $25,$3a,$29,$3a,$2d,$3a,$31,$3a,$35,$3a,$39,$3a

; ------------------------------------------------------------------------------

; [ draw message speed numerals ]

DrawMsgSpeedText:
@3bf2:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigMsgSpeedNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d4d
        and     #$70
        lsr3
        tax
        longa
        lda     f:MsgSpeedTextPos,x
        sta     $f7
        shorta
        lda     $1d4d
        and     #$70
        lsr4
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
        jmp     DrawConfigNum

; ------------------------------------------------------------------------------

MsgSpeedTextPos:
@3c27:  .byte   $a5,$3a,$a9,$3a,$ad,$3a,$b1,$3a,$b5,$3a,$b9,$3a

; ------------------------------------------------------------------------------

; [ draw command setting text ]

DrawCmdConfigText:
@3c33:  lda     $1d4d
        bmi     @3c41
        lda     #$28
        jsr     @3c4a
        lda     #$20
        bra     @3c53
@3c41:  lda     #$20
        jsr     @3c4a
        lda     #$28
        bra     @3c53
@3c4a:  sta     $29
        ldy     #.loword(ConfigCmdShortText)
        jsr     DrawPosText
        rts
@3c53:  sta     $29
        ldy     #.loword(ConfigCmdWindowText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw gauge on/off text ]

DrawGaugeConfigText:
@3c5c:  lda     $1d4e
        bpl     @3c6a
        lda     #$28
        jsr     @3c73
        lda     #$20
        bra     @3c7c
@3c6a:  lda     #$20
        jsr     @3c73
        lda     #$28
        bra     @3c7c
@3c73:  sta     $29
        ldy     #.loword(ConfigGaugeOnText)
        jsr     DrawPosText
        rts
@3c7c:  sta     $29
        ldy     #.loword(ConfigGaugeOffText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw stereo/mono text ]

DrawStereoMonoText:
@3c85:  lda     $1d4e
        and     #$20
        beq     @3c95
        lda     #$28
        jsr     @3c9e
        lda     #$20
        bra     @3ca7
@3c95:  lda     #$20
        jsr     @3c9e
        lda     #$28
        bra     @3ca7
@3c9e:  sta     $29
        ldy     #.loword(ConfigStereoText)
        jsr     DrawPosText
        rts
@3ca7:  sta     $29
        ldy     #.loword(ConfigMonoText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw cursor setting text ]

DrawCursorConfigText:
@3cb0:  lda     $1d4e
        and     #$40
        beq     @3cc0
        lda     #$28
        jsr     @3cc9
        lda     #$20
        bra     @3cd2
@3cc0:  lda     #$20
        jsr     @3cc9
        lda     #$28
        bra     @3cd2
@3cc9:  sta     $29
        ldy     #.loword(ConfigResetText)
        jsr     DrawPosText
        rts
@3cd2:  sta     $29
        ldy     #.loword(ConfigMemoryText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw optimum/remove text ]

DrawReequipConfigText:
@3cdb:  lda     $1d4e
        and     #$10
        beq     @3ceb
        lda     #$28
        jsr     @3cf4
        lda     #$20
        bra     @3cfd
@3ceb:  lda     #$20
        jsr     @3cf4
        lda     #$28
        bra     @3cfd
@3cf4:  sta     $29
        ldy     #.loword(ConfigOptimumText)
        jsr     DrawPosText
        rts
@3cfd:  sta     $29
        ldy     #.loword(ConfigEmptyText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw single/multiple controller text ]

DrawCtrlConfigText:
@3d06:  lda     $1d54
        bpl     @3d14
        lda     #$28
        jsr     @3d1d
        lda     #$20
        bra     @3d26
@3d14:  lda     #$20
        jsr     @3d1d
        lda     #$28
        bra     @3d26
@3d1d:  sta     $29
        ldy     #.loword(ConfigCtrlSingleText)
        jsr     DrawPosText
        rts
@3d26:  sta     $29
        ldy     #.loword(ConfigCtrlMultiText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ change config setting (pressed left or right) ]

ChangeConfigOption:
@3d2f:  clr_a
        lda     $4b
        asl
        tax
        lda     $4a
        beq     @3d40
        phx
        jsr     PlayMoveSfx
        plx
        jmp     (.loword(ChangeConfigOptionTbl+18),x)
@3d40:  jmp     (.loword(ChangeConfigOptionTbl),x)

; ------------------------------------------------------------------------------

; page 1
ChangeConfigOptionTbl:
@3d43:  .addr   ChangeConfigOption_00
        .addr   ChangeConfigOption_01
        .addr   ChangeConfigOption_02
        .addr   ChangeConfigOption_03
        .addr   ChangeConfigOption_04
        .addr   ChangeConfigOption_05
        .addr   ChangeConfigOption_06
        .addr   ChangeConfigOption_07
        .addr   ChangeConfigOption_08

; page 2
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
        lda     $0b
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
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3d95
        lda     $e0
        cmp     #$05
        beq     @3d94
        inc     $e0
        bra     @3d9e
@3d94:  rts
@3d95:  lda     $e0
        beq     @3d9d
        dec     $e0
        bra     @3d9e
@3d9d:  rts
@3d9e:  lda     $1d4d
        and     #$f8
        ora     $e0
        sta     $1d4d
        jmp     DrawBattleSpeedText

; ------------------------------------------------------------------------------

; [ change message speed ]

ChangeConfigOption_02:
@3dab:  jsr     PlayMoveSfx
        lda     $1d4d
        and     #$70
        lsr4
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3dca
        lda     $e0
        cmp     #$05
        beq     @3dc9
        inc     $e0
        bra     @3dd3
@3dc9:  rts
@3dca:  lda     $e0
        beq     @3dd2
        dec     $e0
        bra     @3dd3
@3dd2:  rts
@3dd3:  lda     $e0
        asl4
        sta     $e0
        lda     $1d4d
        and     #$8f
        ora     $e0
        sta     $1d4d
        jmp     DrawMsgSpeedText

; ------------------------------------------------------------------------------

; [ change command setting ]

ChangeConfigOption_03:
@3de8:  jsr     PlayMoveSfx
        lda     $0b
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
        lda     $0b
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
@3e1a:  lda     $0b
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
        lda     $0b
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
        lda     $0b
        bit     #$01
        bne     @3e7e
        lda     #$10
        trb     $1d4e
        jmp     DrawReequipConfigText
@3e7e:  lda     #$10
        tsb     $1d4e
        jmp     DrawReequipConfigText

; ------------------------------------------------------------------------------

; [ change controller setting ]

ChangeConfigOption_08:
@3e86:  jsr     PlayMoveSfx
        lda     $0b
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
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3eb7
        lda     $e0
        cmp     #$05
        beq     @3eb6
        inc     $e0
        bra     @3ec0
@3eb6:  rts
@3eb7:  lda     $e0
        beq     @3ebf
        dec     $e0
        bra     @3ec0
@3ebf:  rts
@3ec0:  lda     $1d54
        and     #$f8
        ora     $e0
        sta     $1d54
        jmp     DrawConfigMagicOrder

; ------------------------------------------------------------------------------

; [ change window pattern ]

ChangeConfigOption_0a:
@3ecd:  lda     $1d4e
        and     #$0f
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3ee5
        lda     $e0
        cmp     #$07
        beq     @3ee4
        inc     $e0
        bra     @3eee
@3ee4:  rts
@3ee5:  lda     $e0
        beq     @3eed
        dec     $e0
        bra     @3eee
@3eed:  rts
@3eee:  lda     $1d4e
        and     #$f0
        ora     $e0
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
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3f1c
        lda     $e0
        cmp     #$07
        beq     @3f1b
        inc     $e0
        bra     @3f25
@3f1b:  rts
@3f1c:  lda     $e0
        beq     @3f24
        dec     $e0
        bra     @3f25
@3f24:  rts
@3f25:  lda     $e0
        asl3
        sta     $e0
        lda     $1d54
        and     #$c7
        ora     $e0
        sta     $1d54
        jsr     DrawConfigColors
        jmp     UpdateConfigColorBars

; ------------------------------------------------------------------------------

; [ change red component ]

ChangeConfigOption_0c:
@3f3c:  jsr     GetColorComponents
        lda     $0b
        bit     #$01
        beq     @3f4f
        lda     $e2
        cmp     #$1f
        beq     @3f55
        inc     $e2
        bra     @3f55
@3f4f:  lda     $e2
        beq     @3f55
        dec     $e2
@3f55:  jsr     CombineColorComponents
        jmp     SetModifiedColor

; ------------------------------------------------------------------------------

; [ change green component ]

ChangeConfigOption_0d:
@3f5b:  jsr     GetColorComponents
        lda     $0b
        bit     #$01
        beq     @3f6e
        lda     $e1
        cmp     #$1f
        beq     @3f74
        inc     $e1
        bra     @3f74
@3f6e:  lda     $e1
        beq     @3f74
        dec     $e1
@3f74:  jsr     CombineColorComponents
        jmp     SetModifiedColor

; ------------------------------------------------------------------------------

; [ change blue component ]

ChangeConfigOption_0e:
@3f7a:  jsr     GetColorComponents
        lda     $0b
        bit     #$01
        beq     @3f8d
        lda     $e0
        cmp     #$1f
        beq     @3f93
        inc     $e0
        bra     @3f93
@3f8d:  lda     $e0
        beq     @3f93
        dec     $e0
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
@3fad:  ldx     $00
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
        lda     $9a
        sta     $1d55,x                 ; set the new color value in SRAM
        lda     $9b
        sta     $1d56,x
        ldy     hRDMPYL
        jsr     UpdateWindowPal
        bra     @3ffa

; font color
@3ff2:  ldy     $9a
        sty     $1d55                   ; set the new color value in SRAM
        jsr     InitFontColor
@3ffa:  jmp     UpdateConfigColorBars

; ------------------------------------------------------------------------------

; [ draw magic order numerals and text ]

DrawConfigMagicOrder:
@3ffd:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigMagicOrderNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d54
        and     #$07
        asl
        tax
        longa
        lda     f:ConfigMagicOrderNumPos,x
        sta     $f7
        shorta
        lda     $1d54
        and     #$07
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
        jsr     DrawConfigNum
        jmp     DrawConfigMagicTypeList

; ------------------------------------------------------------------------------

; positions for highlighted numeral for magic order
ConfigMagicOrderNumPos:
@402f:  .word   $41a5,$41a9,$41ad,$41b1,$41b5,$41b9

; ------------------------------------------------------------------------------

; [ draw magic type list for config menu ]

DrawConfigMagicTypeList:
@403b:  clr_a
        sta     $7e9e95
        clr_a
        lda     $1d54
        and     #$07
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
        ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

ConfigMagicTypeTextPos:
@40cc:  .word   $4329,$42a9,$4229

ConfigMagicTypeTextPtrs:
@40d2:  .byte   $00,$0a,$14,$00
        .byte   $00,$14,$0a,$00
        .byte   $0a,$14,$00,$00
        .byte   $0a,$00,$14,$00
        .byte   $14,$00,$0a,$00
        .byte   $14,$0a,$00,$00

; ------------------------------------------------------------------------------

; [ draw window pattern numerals ]

DrawConfigWindowNumList:
@40ea:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigWindowNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d4e
        and     #$0f
        asl
        tax
        longa
        lda     f:ConfigWindowNumPos,x
        sta     $f7
        shorta
        lda     $1d4e
        and     #$0f
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
; fallthrough

; ------------------------------------------------------------------------------

; [ draw selected numeral for config list ]

; battle speed, battle message speed, magic order, and window pattern

DrawConfigNum:
@4116:  ldy     #$00f7
        sty     $e7
        lda     #$00
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

; positions for highlighted numeral for window graphics indes
ConfigWindowNumPos:
@4123:  .word   $43a5,$43a9,$43ad,$43b1,$43b5,$43b9,$43bd,$43c1

; ------------------------------------------------------------------------------

; [ draw window color boxes for config menu ]

DrawConfigColors:
@4133:  lda     #$3c
        sta     $29
        ldy     #.loword(ConfigColorBoxText)
        jsr     DrawPosText
        ldy     #.loword(ConfigColorArrowBlankText)
        jsr     DrawPosText
        clr_a
        lda     $1d54
        and     #$38
        beq     @4171

; window color selected
        lsr2
        tax
        lda     #$20
        sta     $29
        longa
        lda     f:ConfigColorArrowTbl,x
        sta     $e7
        shorta
        lda     #^ConfigColorArrowTbl
        sta     $e9
        jsr     DrawPosTextFar
        lda     #$28
        sta     $29
        jsr     @417f
        lda     #$20
        sta     $29
        jmp     @4186

; font color selected
@4171:  lda     #$20
        sta     $29
        jsr     @417f
        lda     #$28
        sta     $29
        jmp     @4186

; draw "Font"
@417f:  ldy     #.loword(ConfigFontText)
        jsr     DrawPosText
        rts

; draw "Window"
@4186:  ldy     #.loword(ConfigWindowText)
        jsr     DrawPosText
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
ConfigColorArrowBlankText:
@419d:  .byte   $f5,$44,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

ConfigColorArrowText1:
@41a7:  .byte   $f5,$44,$d4,$00

ConfigColorArrowText2:
@41ab:  .byte   $f7,$44,$d4,$00

ConfigColorArrowText3:
@41af:  .byte   $f9,$44,$d4,$00

ConfigColorArrowText4:
@41b3:  .byte   $fb,$44,$d4,$00

ConfigColorArrowText5:
@41b7:  .byte   $fd,$44,$d4,$00

ConfigColorArrowText6:
@41bb:  .byte   $ff,$44,$d4,$00

ConfigColorArrowText7:
@41bf:  .byte   $01,$45,$d4,$00

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
@41ea:  sty     $9a
        jsr     GetColorComponents
        jsr     DrawBlueColorBar
        jsr     GetColorComponents
        jsr     DrawGreenColorBar
        jsr     GetColorComponents
        jmp     DrawRedColorBar

; ------------------------------------------------------------------------------

; [ separate color components for color bars ]

GetColorComponents:
@41fe:  ldy     $9a
        sty     $e7
        lda     $e7
        and     #$1f
        sta     $e2
        lda     $e8
        and     #$7c
        lsr2
        sta     $e0
        longa
        lda     $e7
        and     #$03e0
        lsr5
        shorta
        sta     $e1
        rts

; ------------------------------------------------------------------------------

; [ combine RGB color components ]

CombineColorComponents:
@4221:  lda     $e0
        asl2
        sta     $e8
        lda     $e2
        sta     $e7
        clr_a
        lda     $e1
        longa
        asl5
        ora     $e7
        sta     a:$009a
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw red color bar ]

DrawRedColorBar:
@423d:  longa
        lda     #$452f
        sta     $7e9e89
        shorta
        lda     $e2
        ldx     #$4529
        jmp     DrawConfigColorBar

; ------------------------------------------------------------------------------

; [ draw green color bar ]

DrawGreenColorBar:
@4250:  longa
        lda     #$45af
        sta     $7e9e89
        shorta
        lda     $e1
        ldx     #$45a9
        jmp     DrawConfigColorBar

; ------------------------------------------------------------------------------

; [ draw blue color ]

DrawBlueColorBar:
@4263:  longa
        lda     #$462f
        sta     $7e9e89
        shorta
        lda     $e0
        ldx     #$4629
        jmp     DrawConfigColorBar

; ------------------------------------------------------------------------------

; [ draw one color bar and numerals ]

DrawConfigColorBar:
@4276:  pha
        pha
        phx
        jsr     HexToDec3
        plx
        lda     #$20
        sta     $29
        jsr     DrawNum2
        ldx     #$9e8b
        stx     hWMADDL
        pla
        xba
        lda     $00
        xba
        lsr2
        tax
        beq     @429c
@4294:  lda     #$f8
        sta     hWMDATA
        dex
        bne     @4294
@429c:  pla
        and     #$03
        tax
        lda     f:ColorBarTiles,x
        sta     hWMDATA
        stz     hWMDATA
        lda     #$30
        sta     $29
        jmp     @42b1                   ; this does nothing
@42b1:  ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

ColorBarTiles:
@42be:  .byte   $f0,$f2,$f4,$f6

; ------------------------------------------------------------------------------

; [ menu state $47: battle command arrange (init) ]

MenuState_47:
@42c2:  jsr     DisableInterrupts
        jsr     DrawCtrlConfigMenu
        jsr     InitCmdArrangeScrollHDMA
        jsr     LoadCmdArrangeCharCursor
        jsr     InitCmdArrangeCharCursor
        jsr     CreateCursorTask
        lda     #$01
        sta     $26
        lda     #$48
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $48: battle command arrange ]

MenuState_48:
@42df:  jsr     UpdateCmdArrangeCharCursor
        lda     $08
        bit     #$80
        beq     @4310
        clr_a
        lda     $4b
        cmp     #$04
        beq     @4326
        tax
        lda     $69,x
        bmi     @430a
        jsr     PlaySelectSfx
        lda     $4e
        sta     $5e
        lda     $4b
        sta     $64
        jsr     LoadCmdArrangeCursor
        jsr     InitCmdArrangeCursor
        lda     #$62
        sta     $26
        rts
@430a:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@4310:  lda     $09
        bit     #$10
        bne     @431c
        lda     $09
        bit     #$80
        beq     @4325
@431c:  jsr     PlayCancelSfx
        lda     #$0d
        sta     $27
        stz     $26
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
        lda     $08
        bit     #$80
        beq     @4359
        jsr     PlaySelectSfx
        lda     $4b
        sta     $28
        jsr     _c32f06
        lda     #$63
        sta     $26
        clr_a
        lda     $64
        asl
        tax
        ldy     $6d,x
        sty     $67
        rts
@4359:  lda     $09
        bit     #$80
        beq     @4375
        jsr     PlayCancelSfx
        jsr     LoadCmdArrangeCharCursor
        lda     $5e
        sta     $4e
        jsr     InitCmdArrangeCharCursor
        lda     $4e
        sta     $5e
        lda     #$48
        sta     $26
        rts
@4375:  rts

; ------------------------------------------------------------------------------

; [ menu state $63: command arrange ]

MenuState_63:
@4376:  jsr     UpdateCmdArrangeCursor

; A button
        lda     $08
        bit     #$80
        beq     @43bd
        jsr     PlaySelectSfx
        clr_a
        lda     $4b
        longa_clc
        adc     $67
        tay
        phy
        shorta
        lda     $0016,y
        sta     $e0
        clr_a
        lda     $28
        longa_clc
        adc     $67
        tay
        shorta
        lda     $0016,y
        sta     $e1
        lda     $e0
        sta     $0016,y
        ply
        lda     $e1
        sta     $0016,y
        jsr     DrawCmdArrangeChar1
        jsr     DrawCmdArrangeChar2
        jsr     DrawCmdArrangeChar3
        jsr     DrawCmdArrangeChar4
        jsr     InitDMA1BG3ScreenA
        bra     @43c6

; B button
@43bd:  lda     $09
        bit     #$80
        beq     @43cf
        jsr     PlayCancelSfx
@43c6:  lda     #$05
        trb     $46
        lda     #$62
        sta     $26
        rts
@43cf:  rts

; ------------------------------------------------------------------------------

; [  ]

_c343d0:
@43d0:  ldx     $00
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
@43f3:  ldy     $6d,x
        beq     @442a
        clr_a
        lda     $0000,y
        cmp     #$0c
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

; [ draw controller config menu ]

DrawCtrlConfigMenu:
@442c:  jsr     ClearBG2ScreenA
        ldy     #.loword(_c34490)
        jsr     DrawWindow
        ldy     #.loword(_c34494)
        jsr     DrawWindow
        ldy     #.loword(_c34498)
        jsr     DrawWindow
        ldy     #.loword(_c3449c)
        jsr     DrawWindow
        ldy     #.loword(_c344a0)
        jsr     DrawWindow
        ldy     #.loword(_c344a4)
        jsr     DrawWindow
        ldy     #.loword(_c344a8)
        jsr     DrawWindow
        ldy     #.loword(_c344ac)
        jsr     DrawWindow
        ldy     #.loword(_c344b0)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #$30
        sta     $29
        ldy     #.loword(CmdArrangeTitleText)
        jsr     DrawPosText
        jsr     DrawCmdArrangeChar1
        jsr     DrawCmdArrangeChar2
        jsr     DrawCmdArrangeChar3
        jsr     DrawCmdArrangeChar4
        jsr     TfrBG1ScreenAB
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; controller config menu windows

_c34490:
@4490:  .byte   $1f,$59,$12,$04

_c34494:
@4494:  .byte   $9f,$5a,$12,$04

_c34498:
@4498:  .byte   $1f,$5c,$12,$04

_c3449c:
@449c:  .byte   $9f,$5d,$12,$04

_c344a0:
@44a0:  .byte   $0b,$59,$08,$04

_c344a4:
@44a4:  .byte   $8b,$5a,$08,$04

_c344a8:
@44a8:  .byte   $0b,$5c,$08,$04

_c344ac:
@44ac:  .byte   $8b,$5d,$08,$04

_c344b0:
@44b0:  .byte   $8b,$58,$08,$01

; ------------------------------------------------------------------------------

; [ draw controller config text for character slot 1 ]

DrawCmdArrangeChar1:
@44b4:  lda     $69
        bmi     @44ec
        jsl     UpdateEquip_ext
        ldx     $6d
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$798f
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7a0f
        jsr     DrawCharTitle
        ldy     #$79ad
        jsr     DrawCmdArrangeTop
        ldy     #$7a23
        jsr     DrawCmdArrangeLeft
        ldy     #$7a37
        jsr     DrawCmdArrangeRight
        ldy     #$7aad
        jsr     DrawCmdArrangeBtm
@44ec:  rts

; ------------------------------------------------------------------------------

; [ draw controller config text for character slot 2 ]

DrawCmdArrangeChar2:
@44ed:  lda     $6a
        bmi     @4525
        jsl     UpdateEquip_ext
        ldx     $6f
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$7b4f
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7bcf
        jsr     DrawCharTitle
        ldy     #$7b6d
        jsr     DrawCmdArrangeTop
        ldy     #$7be3
        jsr     DrawCmdArrangeLeft
        ldy     #$7bf7
        jsr     DrawCmdArrangeRight
        ldy     #$7c6d
        jsr     DrawCmdArrangeBtm
@4525:  rts

; ------------------------------------------------------------------------------

; [ draw controller config text for character slot 3 ]

DrawCmdArrangeChar3:
@4526:  lda     $6b
        bmi     @455e
        jsl     UpdateEquip_ext
        ldx     $71
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$7d0f
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7d8f
        jsr     DrawCharTitle
        ldy     #$7d2d
        jsr     DrawCmdArrangeTop
        ldy     #$7da3
        jsr     DrawCmdArrangeLeft
        ldy     #$7db7
        jsr     DrawCmdArrangeRight
        ldy     #$7e2d
        jsr     DrawCmdArrangeBtm
@455e:  rts

; ------------------------------------------------------------------------------

; [ draw controller config text for character slot 4 ]

DrawCmdArrangeChar4:
@455f:  lda     $6c
        bmi     @4597
        jsl     UpdateEquip_ext
        ldx     $73
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$7ecf
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7f4f
        jsr     DrawCharTitle
        ldy     #$7eed
        jsr     DrawCmdArrangeTop
        ldy     #$7f63
        jsr     DrawCmdArrangeLeft
        ldy     #$7f77
        jsr     DrawCmdArrangeRight
        ldy     #$7fed
        jsr     DrawCmdArrangeBtm
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
@45b6:  ldy     #.loword(CmdArrangeCharCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, char select) ]

UpdateCmdArrangeCharCursor:
@45bc:  jsr     MoveCursor

InitCmdArrangeCharCursor:
@45bf:  ldy     #.loword(CmdArrangeCharCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; cursor data (battle command arrange, char select)
CmdArrangeCharCursorProp:
@45c5:  .byte   $80,$00,$00,$01,$05

; cursor positions (battle command arrange, char select)
CmdArrangeCharCursorPos:
@45ca:  .byte   $08,$20
        .byte   $08,$50
        .byte   $08,$80
        .byte   $08,$b0
        .byte   $08,$0c

; ------------------------------------------------------------------------------

; [ init cursor (battle command arrange, command select/move) ]

LoadCmdArrangeCursor:
@45d4:  ldy     #.loword(CmdArrangeCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, command select/move) ]

; initial update only, doesn't update cursor movement

InitCmdArrangeCursor:
@45da:  clr_a
        lda     $64         ; character slot
        asl
        tax
        jmp     (.loword(InitCmdArrangeCursorTbl),x)

InitCmdArrangeCursorTbl:
@45e2:  .addr   InitChar1CmdArrangeCursorPos
        .addr   InitChar2CmdArrangeCursorPos
        .addr   InitChar3CmdArrangeCursorPos
        .addr   InitChar4CmdArrangeCursorPos

; ------------------------------------------------------------------------------

; character slot 1
InitChar1CmdArrangeCursorPos:
UpdateChar1CmdArrangeCursorPos:
@45ea:  ldy     #.loword(Char1CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 2
InitChar2CmdArrangeCursorPos:
UpdateChar2CmdArrangeCursorPos:
@45f0:  ldy     #.loword(Char2CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 3
InitChar3CmdArrangeCursorPos:
UpdateChar3CmdArrangeCursorPos:
@45f6:  ldy     #.loword(Char3CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 4
InitChar4CmdArrangeCursorPos:
UpdateChar4CmdArrangeCursorPos:
@45fc:  ldy     #.loword(Char4CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, command select/move) ]

UpdateCmdArrangeCursor:
@4602:  jsr     GetCmdArrangeCursorInput
        clr_a
        lda     $64         ; character slot
        asl
        tax
        jmp     (.loword(UpdateCmdArrangeCursorTbl),x)

UpdateCmdArrangeCursorTbl:
@460d:  .addr   UpdateChar1CmdArrangeCursorPos
        .addr   UpdateChar2CmdArrangeCursorPos
        .addr   UpdateChar3CmdArrangeCursorPos
        .addr   UpdateChar4CmdArrangeCursorPos

; ------------------------------------------------------------------------------

; [ update cursor movement (battle command arrange, command select/move) ]

GetCmdArrangeCursorInput:
@4615:  stz     $4d

; up
        lda     $0b
        bit     #$08
        beq     @4622
        stz     $4e
        jsr     PlayMoveSfx

; down
@4622:  lda     $0b
        bit     #$04
        beq     @462f
        lda     #$03
        sta     $4e
        jsr     PlayMoveSfx

; left
@462f:  lda     $0b
        bit     #$02
        beq     @463c
        lda     #$01
        sta     $4e
        jsr     PlayMoveSfx

; right
@463c:  lda     $0b
        bit     #$01
        beq     @4649
        lda     #$02
        sta     $4e
        jsr     PlayMoveSfx
@4649:  rts

; ------------------------------------------------------------------------------

; cursor data (battle command arrange, command select/move)
CmdArrangeCursorProp:
@464a:  .byte   $81,$00,$00,$01,$04

; cursor positions (battle command arrange, 4 positions per character slot)
Char1CmdArrangeCursorPos:
@464f:  .byte   $80,$20
        .byte   $58,$2c
        .byte   $a8,$2c
        .byte   $80,$38

Char2CmdArrangeCursorPos:
@4657:  .byte   $80,$50
        .byte   $58,$5c
        .byte   $a8,$5c
        .byte   $80,$68

Char3CmdArrangeCursorPos:
@465f:  .byte   $80,$80
        .byte   $58,$8c
        .byte   $a8,$8c
        .byte   $80,$98

Char4CmdArrangeCursorPos:
@4667:  .byte   $80,$b0
        .byte   $58,$bc
        .byte   $a8,$bc
        .byte   $80,$c8

; ------------------------------------------------------------------------------

; [ init bg3 horizontal scroll hdma (battle command arrange) ]

InitCmdArrangeScrollHDMA:
@466f:  lda     #$02                    ; one address, write twice
        sta     $4350
        lda     #<hBG3VOFS              ; bg3 vertical scroll
        sta     $4351
        ldy     #.loword(CmdArrangeScrollHDMATbl)
        sty     $4352
        lda     #^CmdArrangeScrollHDMATbl
        sta     $4354
        lda     #^CmdArrangeScrollHDMATbl
        sta     $4357
        lda     #$20                    ; enable hdma #5
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (battle command arrange)
CmdArrangeScrollHDMATbl:
@468e:  .byte   $1f
        .word   $0000
        .byte   $0c
        .word   $0004
        .byte   $0c
        .word   $0008
        .byte   $24
        .word   $000c
        .byte   $0c
        .word   $0010
        .byte   $24
        .word   $0014
        .byte   $0c
        .word   $0018
        .byte   $24
        .word   $001c
        .byte   $0c
        .word   $0020
        .byte   $24
        .word   $0024
        .byte   $00

; ------------------------------------------------------------------------------

; controller config menu
MenuState_49:
MenuState_4a:
.if !LANG_EN

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
        lda     #$01
        sta     $26
        lda     #$4c
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $4c: update character controller select ]

MenuState_4c:
@46ca:  jsr     InitDMA1BG3ScreenA
        jsr     UpdateCharCtrlCursor
        lda     $09
        bit     #$10
        bne     @46dc
        lda     $09
        bit     #$80
        beq     @46e6
@46dc:  jsr     PlayCancelSfx
        lda     #$0d
        sta     $27
        stz     $26
        rts
@46e6:  lda     $0b
        bit     #$01
        bne     @46f2
        lda     $0b
        bit     #$02
        beq     @46f4
@46f2:  bra     ChangeCharCtrl
@46f4:  rts

; ------------------------------------------------------------------------------

; [ draw character controller select menu ]

DrawCharCtrlMenu:
@46f5:  ldy     #.loword(CharCtrlWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        lda     #$30
        sta     $29
        ldy     #.loword(CharCtrlTitleText)
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
        lda     $4b
        tax
        lda     $69,x
        bmi     @4729
        jsr     PlayMoveSfx
        lda     $4b
        asl
        tax
        jmp     (.loword(ChangeCharCtrlTbl),x)
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
        lda     $0b
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
        lda     $0b
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
        lda     $0b
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
        lda     $0b
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
@47b4:  lda     $69
        bmi     @47f0
        ldx     $6d
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7bcf
        jsr     DrawCharName
        lda     $1d4f
        and     #$01
        beq     @47d6
        lda     #$24
        jsr     @47df
        lda     #$20
        bra     @47e8
@47d6:  lda     #$20
        jsr     @47df
        lda     #$24
        bra     @47e8

@47df:  sta     $29
        ldy     #$4b08
        jsr     DrawPosText
        rts

@47e8:  sta     $29
        ldy     #$4b11
        jsr     DrawPosText
@47f0:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 2 controller select ]

DrawChar2CtrlText:
@47f1:  lda     $6a
        bmi     @482d
        ldx     $6f
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7c4f
        jsr     DrawCharName
        lda     $1d4f
        and     #$02
        beq     @4813
        lda     #$24
        jsr     @481c
        lda     #$20
        bra     @4825
@4813:  lda     #$20
        jsr     @481c
        lda     #$24
        bra     @4825

@481c:  sta     $29
        ldy     #$4b1a
        jsr     DrawPosText
        rts

@4825:  sta     $29
        ldy     #$4b23
        jsr     DrawPosText
@482d:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 3 controller select ]

DrawChar3CtrlText:
@482e:  lda     $6b
        bmi     @486a
        ldx     $71
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7ccf
        jsr     DrawCharName
        lda     $1d4f
        and     #$04
        beq     @4850
        lda     #$24
        jsr     @4859
        lda     #$20
        bra     @4862
@4850:  lda     #$20
        jsr     @4859
        lda     #$24
        bra     @4862

@4859:  sta     $29
        ldy     #$4b2c
        jsr     DrawPosText
        rts

@4862:  sta     $29
        ldy     #$4b35
        jsr     DrawPosText
@486a:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 4 controller select ]

DrawChar4CtrlText:
@486b:  lda     $6c
        bmi     @48a7
        ldx     $73
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7d4f
        jsr     DrawCharName
        lda     $1d4f
        and     #$08
        beq     @488d
        lda     #$24
        jsr     @4896
        lda     #$20
        bra     @489f
@488d:  lda     #$20
        jsr     @4896
        lda     #$24
        bra     @489f

@4896:  sta     $29
        ldy     #$4b3e
        jsr     DrawPosText
        rts

@489f:  sta     $29
        ldy     #$4b47
        jsr     DrawPosText
@48a7:  rts

; ------------------------------------------------------------------------------

; [ init window 2 HDMA for character controller select ]

InitCharCtrlWindowHDMA:
@48a8:  lda     #$01
        sta     $4350
        lda     #<hWH2
        sta     $4351
        ldy     #.loword(CharCtrlWindowHDMATbl)
        sty     $4352
        lda     #^CharCtrlWindowHDMATbl
        sta     $4354
        lda     #^CharCtrlWindowHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; window 2 position HDMA table (character controller select)
CharCtrlWindowHDMATbl:
@48c7:  .byte   $27,$ff,$ff
        .byte   $30,$08,$f7
        .byte   $68,$ff,$ff
        .byte   $10,$08,$f7
        .byte   $10,$ff,$ff
        .byte   $00

; ------------------------------------------------------------------------------

; [ init cursor for character controller select ]

LoadCharCtrlCursor:
@48d7:  ldy     #.loword(CharCtrlCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for character controller select ]

UpdateCharCtrlCursor:
@48dd:  jsr     MoveCursor

InitCharCtrlCursor:
@48e0:  ldy     #.loword(CharCtrlCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

CharCtrlCursorProp:
@48e6:  .byte   $80,$00,$00,$01,$04

CharCtrlCursorPos:
@48eb:  .byte   $50,$7b
        .byte   $50,$8b
        .byte   $50,$9b
        .byte   $50,$ab

; ------------------------------------------------------------------------------

; window for character controller select
CharCtrlWindow:
@48f3:  .byte   $0b,$5b,$1c,$0b

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
@4903:  .addr   ConfigControllerText
        .addr   ConfigCursorText

ConfigSpeedTextList:
@4907:  .addr   ConfigFastText
        .addr   ConfigSlowText

ConfigControllerText:
@490b:  .byte   $8f,$3d,$82,$a8,$a7,$ad,$ab,$a8,$a5,$a5,$9e,$ab,$00

ConfigWaitText:
@4918:  .byte   $b5,$39,$96,$9a,$a2,$ad,$00

ConfigFastText:
@491f:  .byte   $65,$3a,$85,$9a,$ac,$ad,$00

ConfigSlowText:
@4926:  .byte   $75,$3a,$92,$a5,$a8,$b0,$00

ConfigCmdShortText:
@492d:  .byte   $35,$3b,$92,$a1,$a8,$ab,$ad,$00

ConfigGaugeOnText:
@4935:  .byte   $a5,$3b,$8e,$a7,$00

ConfigGaugeOffText:
@493a:  .byte   $b5,$3b,$8e,$9f,$9f,$00

ConfigStereoText:
@4940:  .byte   $25,$3c,$92,$ad,$9e,$ab,$9e,$a8,$00

ConfigMonoText:
@4949:  .byte   $35,$3c,$8c,$a8,$a7,$a8,$00

ConfigMemoryText:
@4950:  .byte   $b5,$3c,$8c,$9e,$a6,$a8,$ab,$b2,$00

ConfigOptimumText:
@4959:  .byte   $25,$3d,$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00

ConfigCtrlMultiText:
@4963:  .byte   $b5,$3d,$8c,$ae,$a5,$ad,$a2,$a9,$a5,$9e,$00

ConfigBattleSpeedNumText:
@496e:  .byte   $25,$3a,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$00

ConfigMsgSpeedNumText:
@497c:  .byte   $a5,$3a,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$00

ConfigCursorText:
@498a:  .byte   $8f,$3c,$82,$ae,$ab,$ac,$a8,$ab,$00

ConfigLabelTextList2:
@4993:  .addr   ConfigBattleModeText
        .addr   ConfigBattleSpeedText
        .addr   ConfigMsgSpeedText
        .addr   ConfigCmdSetText
        .addr   ConfigGaugeText
        .addr   ConfigSoundText
        .addr   ConfigReequipText

ConfigTitleText:
@49a1:  .byte   $f9,$78,$82,$a8,$a7,$9f,$a2,$a0,$00

ConfigBattleModeText:
@49aa:  .byte   $8f,$39,$81,$9a,$ad,$c5,$8c,$a8,$9d,$9e,$00

ConfigBattleSpeedText:
@49b5:  .byte   $0f,$3a,$81,$9a,$ad,$c5,$92,$a9,$9e,$9e,$9d,$00

ConfigMsgSpeedText:
@49c1:  .byte   $8f,$3a,$8c,$ac,$a0,$c5,$92,$a9,$9e,$9e,$9d,$00

ConfigCmdSetText:
@49cd:  .byte   $0f,$3b,$82,$a6,$9d,$c5,$92,$9e,$ad,$00

ConfigGaugeText:
@49d7:  .byte   $8f,$3b,$86,$9a,$ae,$a0,$9e,$00

ConfigSoundText:
@49df:  .byte   $0f,$3c,$92,$a8,$ae,$a7,$9d,$00

ConfigReequipText:
@49e7:  .byte   $0f,$3d,$91,$9e,$9e,$aa,$ae,$a2,$a9,$00

ConfigActiveText:
@49f1:  .byte   $a5,$39,$80,$9c,$ad,$a2,$af,$9e,$00

ConfigCmdWindowText:
@49fa:  .byte   $25,$3b,$96,$a2,$a7,$9d,$a8,$b0,$00

ConfigResetText:
@4a03:  .byte   $a5,$3c,$91,$9e,$ac,$9e,$ad,$00

ConfigEmptyText:
@4a0b:  .byte   $35,$3d,$84,$a6,$a9,$ad,$b2,$00

ConfigCtrlSingleText:
@4a13:  .byte   $a5,$3d,$92,$a2,$a7,$a0,$a5,$9e,$00

ConfigLabelTextList3:
@4a1c:  .addr   ConfigMagicOrderText
        .addr   ConfigWindowLabelText
        .addr   ConfigColorText

; color selector bars
ConfigColorBarTextList:
@4a22:  .addr   ConfigColorBarRText
        .addr   ConfigColorBarGText
        .addr   ConfigColorBarBText

ConfigLabelTextList4:
@4a28:  .addr   ConfigColorRText
        .addr   ConfigColorGText
        .addr   ConfigColorBText
        .addr   ConfigMagicOrderAText
        .addr   ConfigMagicOrderBText
        .addr   ConfigMagicOrderCText

ConfigMagicOrderText:
@4a34:  .byte   $8f,$41,$8c,$9a,$a0,$c5,$8e,$ab,$9d,$9e,$ab,$00

ConfigWindowLabelText:
@4a40:  .byte   $8f,$43,$96,$a2,$a7,$9d,$a8,$b0,$00

ConfigColorText:
@4a49:  .byte   $0f,$44,$82,$a8,$a5,$a8,$ab,$00

ConfigMagicOrderAText:
@4a51:  .byte   $25,$42,$80,$d3,$00

ConfigMagicOrderBText:
@4a56:  .byte   $a5,$42,$81,$d3,$00

ConfigMagicOrderCText:
@4a5b:  .byte   $25,$43,$82,$d3,$00

ConfigColorBarRText:
@4a60:  .byte   $2d,$45,$f9,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$fa,$00

ConfigColorBarGText:
@4a6d:  .byte   $ad,$45,$f9,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$fa,$00

ConfigColorBarBText:
@4a7a:  .byte   $2d,$46,$f9,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$fa,$00

ConfigColorRText:
@4a87:  .byte   $25,$45,$91,$00

ConfigColorGText:
@4a8b:  .byte   $a5,$45,$86,$00

ConfigColorBText:
@4a8f:  .byte   $25,$46,$81,$00

ConfigWindowNumText:
@4a93:  .byte   $a5,$43,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$ff,$bb,$ff
        .byte   $bc,$00

ConfigMagicOrderNumText:
@4aa5:  .byte   $a5,$41,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$00

ConfigFontText:
@4ab3:  .byte   $25,$44,$85,$a8,$a7,$ad,$00

ConfigWindowText:
@4aba:  .byte   $35,$44,$96,$a2,$a7,$9d,$a8,$b0,$00

; unused
@4ac3:  .byte   $fb,$43,$a5,$47,$79,$00

ConfigColorBoxText:
@4ac9:  .byte   $b5,$44,$01,$02,$03,$04,$05,$06,$07,$00

ConfigMagicTypeText:
@4ad3:  .byte   $e8,$87,$9e,$9a,$a5,$a2,$a7,$a0,$ff,$ff
@4ade:  .byte   $e9,$80,$ad,$ad,$9a,$9c,$a4,$ff,$ff,$ff
@4ae8:  .byte   $ea,$84,$9f,$9f,$9e,$9c,$ad,$ff,$ff,$ff

; ------------------------------------------------------------------------------

; "Arrange"
CmdArrangeTitleText:
@4af1:  .byte   $cf,$78,$80,$ab,$ab,$9a,$a7,$a0,$9e,$00

; "Controller"
CharCtrlTitleText:
@4afb:  .byte   $4d,$7b,$82,$a8,$a7,$ad,$ab,$a8,$a5,$a5,$9e,$ab,$00

; "Cntlr1" (char 1)
@4b08:  .byte   $21,$7c,$82,$a7,$ad,$a5,$ab,$b5,$00

; "Cntlr2" (char 1)
@4b11:  .byte   $33,$7c,$82,$a7,$ad,$a5,$ab,$b6,$00

; "Cntlr1" (char 2)
@4b1a:  .byte   $a1,$7c,$82,$a7,$ad,$a5,$ab,$b5,$00

; "Cntlr2" (char 2)
@4b23:  .byte   $b3,$7c,$82,$a7,$ad,$a5,$ab,$b6,$00

; "Cntlr1" (char 3)
@4b2c:  .byte   $21,$7d,$82,$a7,$ad,$a5,$ab,$b5,$00

; "Cntlr2" (char 3)
@4b35:  .byte   $33,$7d,$82,$a7,$ad,$a5,$ab,$b6,$00

; "Cntlr1" (char 4)
@4b3e:  .byte   $a1,$7d,$82,$a7,$ad,$a5,$ab,$b5,$00

; "Cntlr2" (char 4)
@4b47:  .byte   $b3,$7d,$82,$a7,$ad,$a5,$ab,$b6,$00

; ------------------------------------------------------------------------------
