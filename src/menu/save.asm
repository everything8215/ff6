
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: save.asm                                                             |
; |                                                                            |
; | description: game save/load menu                                           |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.segment "menu_code"

; ------------------------------------------------------------------------------

LoadSavedGame:
@14fe:  lda     wSaveSlotToLoad
        beq     @1514                   ; branch if not loading a saved game
        jsr     LoadSaveSlot
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        beq     @1514                   ; branch if checksum invalid
        jsr     PopTimers
        clr_a                           ; return 0
        bra     @1518
@1514:  shorta
        lda     #$ff                    ; return $ff
@1518:  sta     w0205
        clr_a
        rtl

; ------------------------------------------------------------------------------

; [ save game ]

; A: game slot

CopyGameDataToSRAM:
@151d:
.if LANG_EN
        and     #%11
.endif
        sta     $307ff0                 ; set game slot
        sta     wSelSaveSlot
        pha
        ldy     wGameTimeHours
        sty     $1863
        lda     wGameTimeSeconds
        sta     $1865
        jsr     PushTimers
        jsr     CalcSaveSlotChecksum
        ldy     $e7
        sty     $1ffe       ; save checksum
        clr_a
        pla
        asl
        tax
        longa
        lda     f:SRAMSlotPtrs,x
        tax
        shorta
        ldy     z0
@154d:  lda     $1600,y     ; copy saved game data to sram
        sta     $306000,x
        inx
        iny
        cpy     #$0a00
        bne     @154d
        jmp     ValidateSRAM

; pointers to saved game data in sram
SRAMSlotPtrs:
@155e:  .word   $0000,$0000,$0a00,$1400

; ------------------------------------------------------------------------------

; [ load saved game data ]

LoadSaveSlot:
@1566:  xba
        lda     z0
        xba
        asl
        tax
        longa
        lda     f:SRAMSlotPtrs,x   ; pointer to saved game data
        tax
        shorta
        ldy     z0
@1577:  lda     $306000,x
        sta     $1600,y
        inx
        iny
        cpy     #$0a00
        bne     @1577
        rts

; ------------------------------------------------------------------------------

; [ save timer data ]

PushTimers:
@1586:  clr_ax
@1588:  lda     $1188,x
        sta     $1fa8,x
        inx
        cpx     #$0018
        bne     @1588
        rts

; ------------------------------------------------------------------------------

; [ restore timer data ]

PopTimers:
@1595:  clr_ax
@1597:  lda     $1fa8,x
        sta     $1188,x
        inx
        cpx     #$0018
        bne     @1597
        rts

; ------------------------------------------------------------------------------

; [ init cursor (save select) ]

LoadGameSaveCursor:
@15a4:  ldy     #near GameSaveCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (save select) ]

UpdateGameSaveCursor:
@15aa:  jsr     MoveCursor

InitGameSaveCursor:
@15ad:  ldy     #near GameLoadCursorPos+2
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GameSaveCursorProp:
        make_cursor_prop {0, 0}, {1, 3}, NO_X_WRAP

; ------------------------------------------------------------------------------

; [ init cursor (restore game) ]

LoadGameLoadCursor:
@15b8:  ldy     #near GameLoadCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (restore game) ]

UpdateGameLoadCursor:
@15be:  jsr     MoveCursor

InitGameLoadCursor:
@15c1:  ldy     #near GameLoadCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GameLoadCursorProp:
        make_cursor_prop {0, 0}, {1, 4}, NO_X_WRAP

GameLoadCursorPos:
@15cc:  .byte   $08,$1c
        .byte   $08,$3c
        .byte   $08,$74
        .byte   $08,$ac

; ------------------------------------------------------------------------------

; [ init cursor (save/restore confirm) ]

LoadSaveConfirmCursor:
@15d4:  ldy     #near SaveConfirmCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (save/restore confirm) ]

UpdateSaveConfirmCursor:
@15da:  jsr     MoveCursor

InitSaveConfirmCursor:
@15dd:  ldy     #near SaveConfirmCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

SaveConfirmCursorProp:
        make_cursor_prop {0, 0}, {1, 2}, NO_X_WRAP

SaveConfirmCursorPos:
@15e8:  .byte   $bf,$44
        .byte   $bf,$54

; ------------------------------------------------------------------------------

; [ draw save select menu ]

DrawGameSaveMenu:
@15ec:  jsr     ClearBG2ScreenA
        jsr     DrawSaveSlotWindows
        jsr     LoadWindowGfx
        ldy     #near SaveTitleWindow
        jsr     DrawWindow
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveTitleText
        jsr     DrawPosKana
        jmp     TfrSaveSlotWindows

; ------------------------------------------------------------------------------

; [ draw restore game menu ]

DrawGameLoadMenu:
@1608:  jsr     ClearBG2ScreenA
        stz     $1d4e
        jsr     InitWindowPal
        jsr     LoadWindowGfx
        ldy     #near SaveTitleWindow
        jsr     DrawWindow
        lda     $1d4e
        and     #$70
        sta     $1d4e
        jsr     DrawSaveSlotWindows
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near NewGameText
        jsr     DrawPosKana
        jmp     TfrSaveSlotWindows

; ------------------------------------------------------------------------------

; [ draw save slot windows ]

DrawSaveSlotWindows:
@1632:  jsr     LoadGrayCharPal
        lda     #BIT_5
        trb     zEnableHDMA
        ldy     #$0002
        sty     zBG1VScroll
        ldy     $1d55                   ; save font color
        sty     $e7
        ldy     #$7fff                  ; set font color to white
        sty     $1d55
        jsr     InitFontColor
        ldy     $e7
        sty     $1d55                   ; restore font color
        lda     #1
        jsl     InitGradientHDMA
        jsr     ClearBG1ScreenA
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenC

; slot 1
        jsr     PushSRAM
        lda     #1
        sta     zSelSaveSlot
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        sty     $91
        beq     @1682                   ; branch if checksum invalid
        jsr     MakeSaveSlot1PalList
        jsr     DrawSave1GameText
        jsr     LoadSaveSlot1WindowPal
        bra     @1695
@1682:  jsr     PopSRAM
        jsr     MakeSaveSlot1PalList
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot1EmptyText
        jsr     DrawPosText
        jsr     LoadSaveSlot1WindowPal

; slot 2
@1695:  lda     #2
        sta     zSelSaveSlot
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        sty     $93
        beq     @16b4
        jsr     MakeSaveSlot2PalList
        jsr     DrawSave2GameText
        jsr     LoadSaveSlot2WindowPal
        bra     @16c7
@16b4:  jsr     PopSRAM
        jsr     MakeSaveSlot2PalList
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot2EmptyText
        jsr     DrawPosText
        jsr     LoadSaveSlot2WindowPal

; slot 3
@16c7:  lda     #3
        sta     zSelSaveSlot
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        sty     $95
        beq     @16e6
        jsr     MakeSaveSlot3PalList
        jsr     DrawSave3GameText
        jsr     LoadSaveSlot3WindowPal
        bra     @16f9
@16e6:  jsr     PopSRAM
        jsr     MakeSaveSlot3PalList
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot3EmptyText
        jsr     DrawPosText
        jsr     LoadSaveSlot3WindowPal

@16f9:  jsr     PopSRAM
        jsr     LoadSaveSlot1WindowGfx
        ldy     #near SaveSlot1Window
        jsr     DrawWindow
        jsr     LoadSaveSlot2WindowGfx
        ldy     #near SaveSlot2Window
        jsr     DrawWindow
        jsr     LoadSaveSlot3WindowGfx
        ldy     #near SaveSlot3Window
        jsr     DrawWindow
        ldy     #$1c00
        jmp     SetWindowTileFlags

; ------------------------------------------------------------------------------

; [ draw text for save slot 1 ]

DrawSave1GameText:
@171d:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot1TimeColonText
        jsr     DrawPosText
        lda     $1863
        jsr     HexToDec3
        ldx_pos BG3A, {2, 11}
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx_pos BG3A, {5, 11}
        jsr     DrawNum2
        jsr     DrawSave1CharText
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near SaveSlot1TimeText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 1 ]

DrawSave1CharText:
@174d:  clr_ax
@174f:  lda     zCharID,x
        bmi     @177c       ; branch if character slot is empty
        jsr     GetCharPtr
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near SaveSlot1LevelText
        jsr     DrawPosText
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot1HPSlashText
        jsr     DrawPosText
.if LANG_EN
        ldy_pos BG1A, {3, 8}
.else
        ldy_pos BG1A, {3, 7}
.endif
        phy
        ldx_pos BG3A, {26, 10}
        phx
        ldx_pos BG3A, {21, 10}
        phx
        ldx_pos BG3A, {28, 8}
        phx
        bra     DrawSaveSlotCharText
@177c:  inx                 ; next character slot
        bra     @174f

; ------------------------------------------------------------------------------

; [ draw character text for save slot ]

DrawSaveSlotCharText:
@177f:  ldx     zSelCharPropPtr
        lda     a:$0008,x     ; character's level
        jsr     HexToDec3
        plx
        jsr     DrawNum2
        ldy     zSelCharPropPtr
        jsr     CheckMaxHP
        lda     $0009,y     ; current hp
        sta     $f3
        lda     $000a,y
        sta     $f4
        jsr     HexToDec5
        plx
        jsr     DrawNum4
        ldx     zSelCharPropPtr
        lda     a:$000b,x     ; max hp
        sta     $f3
        lda     a:$000c,x
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        jsr     HexToDec5
        plx
        jsr     DrawNum4
        ply
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; [ update pointer to current character data ]

GetCharPtr:
@17be:  longa
        txa
        asl
        tax
        lda     zCharPropPtr,x
        sta     zSelCharPropPtr
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw text for save slot 2 ]

DrawSave2GameText:
@17ca:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot2TimeColonText
        jsr     DrawPosText
        lda     $1863                   ; game time
        jsr     HexToDec3
        ldx_pos BG3A, {2, 18}
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx_pos BG3A, {5, 18}
        jsr     DrawNum2
        jsr     DrawSave2CharText
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near SaveSlot2TimeText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 2 ]

DrawSave2CharText:
@17fa:  clr_ax
@17fc:  lda     zCharID,x
        bmi     @182a
        jsr     GetCharPtr
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near SaveSlot2LevelText
        jsr     DrawPosText
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot2HPSlashText
        jsr     DrawPosText
.if LANG_EN
        ldy_pos BG1A, {3, 15}
.else
        ldy_pos BG1A, {3, 14}
.endif
        phy
        ldx_pos BG3A, {26, 17}
        phx
        ldx_pos BG3A, {21, 17}
        phx
        ldx_pos BG3A, {28, 15}
        phx
        jmp     DrawSaveSlotCharText
@182a:  inx
        bra     @17fc

; ------------------------------------------------------------------------------

; [ draw text for save slot 3 ]

DrawSave3GameText:
@182d:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot3TimeColonText
        jsr     DrawPosText
        lda     $1863
        jsr     HexToDec3
        ldx_pos BG3A, {2, 25}
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx_pos BG3A, {5, 25}
        jsr     DrawNum2
        jsr     DrawSave3CharText
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near SaveSlot3TimeText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 3 ]

DrawSave3CharText:
@185d:  clr_ax
@185f:  lda     zCharID,x
        bmi     @188d
        jsr     GetCharPtr
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near SaveSlot3LevelText
        jsr     DrawPosText
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near SaveSlot3HPSlashText
        jsr     DrawPosText
.if LANG_EN
        ldy_pos BG1A, {3, 22}
.else
        ldy_pos BG1A, {3, 21}
.endif
        phy
        ldx_pos BG3A, {26, 24}
        phx
        ldx_pos BG3A, {21, 24}
        phx
        ldx_pos BG3A, {28, 22}
        phx
        jmp     DrawSaveSlotCharText
@188d:  inx
        bra     @185f

; ------------------------------------------------------------------------------

; [ transfer save slot windows to vram ]

TfrSaveSlotWindows:
@1890:  jsr     TfrBG1ScreenAB
        jsr     TfrBG2ScreenAB
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

SaveTitleWindow:                        make_window BG2A, {1, 2}, {28, 2}
SaveSlot1Window:                        make_window BG2A, {1, 6}, {28, 5}
SaveSlot2Window:                        make_window BG2A, {1, 13}, {28, 5}
SaveSlot3Window:                        make_window BG2A, {1, 20}, {28, 5}

; ------------------------------------------------------------------------------

; [ save sram at 7e/ac8d ]

PushSRAM:
@18ac:  ldy     #$ac8d
        sty     hWMADDL
        ldx     z0
@18b4:  lda     $1600,x
        sta     hWMDATA
        inx
        cpx     #$0a00
        bne     @18b4
        rts

; ------------------------------------------------------------------------------

; [ restore sram from 7e/ac8d ]

PopSRAM:
@18c1:  ldx     z0
@18c3:  lda     $7eac8d,x
        sta     $1600,x
        inx
        cpx     #$0a00
        bne     @18c3
        rts

; ------------------------------------------------------------------------------

_c318d1:
@18d1:  lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near _c318f0
        sty     hDMA5::ADDR
        lda     #^_c318f0
        sta     hDMA5::ADDR_B
        lda     #^_c318f0
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; ??? hdma table
_c318f0:
        hdma_word 32, 0
        hdma_word 12, 4
        hdma_word 12, 8
        hdma_word 8, -56
        hdma_word 80, 0
        hdma_word 88, 0
        hdma_end

; ------------------------------------------------------------------------------

; [ update character sprites (save menu) ]

DrawSaveMenuChars:
@1903:  ldx     z0
@1905:  lda     $7eaa71,x               ; branch if no character in this slot
        bmi     @1977
        phx
        phx
        lda     #3
        ldy     #near SaveMenuCharTask
        jsr     CreateTask
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        lda     zSelSaveSlot
        beq     @1931
        cmp     #1
        beq     @1943
        cmp     #2
        beq     @193a

; slot 3
        lda     f:SaveMenuCharPalTbl+36,x
        sta     near wTaskPal,y                 ; palette
        bra     @194a

; new game
@1931:  lda     f:SaveMenuCharPalTbl,x
        sta     near wTaskPal,y
        bra     @194a

; slot 2
@193a:  lda     f:SaveMenuCharPalTbl+24,x
        sta     near wTaskPal,y
        bra     @194a

; slot 1
@1943:  lda     f:SaveMenuCharPalTbl+12,x
        sta     near wTaskPal,y
@194a:  lda     #^PartyCharAnimTbl
        sta     near wTaskAnimBank,y
        clr_a
        sta     near {wTaskPosX + 1},y
        sta     near {wTaskPosY + 1},y
        lda     f:SaveMenuCharXTbl,x
        sta     near wTaskPosX,y
        lda     f:SaveMenuCharYTbl,x
        sta     near wTaskPosY,y
        lda     $7eaa71,x
        longa
        asl
        tax
        lda     f:PartyCharAnimTbl,x
        sta     near wTaskAnimPtr,y                 ; pointer to animation data
        shorta
        plb
        plx
@1977:  inx
        cpx     #12
        bne     @1905
        sec
        rts

; ------------------------------------------------------------------------------

; x positions for character sprites
SaveMenuCharXTbl:
@197f:  .byte   $50,$68,$80,$98
        .byte   $50,$68,$80,$98
        .byte   $50,$68,$80,$98

; y positions for character sprites
SaveMenuCharYTbl:
@198b:  .byte   $40,$40,$40,$40
        .byte   $78,$78,$78,$78
        .byte   $b0,$b0,$b0,$b0

; palette override for character sprites
;   0 to use a character's real palette, 2 for grayscale
SaveMenuCharPalTbl:
@1997:  .byte   2,2,2,2,2,2,2,2,2,2,2,2
@19a3:  .byte   0,0,0,0,2,2,2,2,2,2,2,2
@19af:  .byte   2,2,2,2,0,0,0,0,2,2,2,2
@19bb:  .byte   2,2,2,2,2,2,2,2,0,0,0,0

; ------------------------------------------------------------------------------

; [ character sprite task (save menu) ]

SaveMenuCharTask:
@19c7:  ldx     zTaskOffset
        jsr     InitAnimTask
        jsr     UpdateAnimTask
        clc
        rts

; ------------------------------------------------------------------------------

; [ calculate saved game data checksum ]

CalcSaveSlotChecksum:
@19d1:  stz     $e7                     ; +$e7 = sram checksum
        stz     $e8
        ldx     z0
        clc
@19d8:  lda     $1600,x                 ; sum all bytes of saved game data
        adc     $e7
        sta     $e7
        clr_a
        adc     $e8
        sta     $e8
        inx
        cpx     #$09fe
        bne     @19d8
        rts

; ------------------------------------------------------------------------------

; [ check saved game data checksum ]

; +$e7 = calculated checksum

CheckSaveSlotChecksum:
@19eb:  longa
        lda     $e7
        cmp     $1ffe
        bne     @19f6                   ; return 0 if invalid
        bra     @19f7                   ; return checksum value if valid
@19f6:  clr_a
@19f7:  tay
        shorta
        rts

; ------------------------------------------------------------------------------

; [ menu state $53: fade out (save menu) ]

MenuState_53:
@19fb:  jsr     CreateFadeOutTask
        ldy     #$0008
        sty     zWaitCounter
        lda     #$54
        sta     zMenuState
        jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; [ menu state $52: fade in (save menu) ]

MenuState_52:
@1a0a:  jsr     CreateFadeInTask
        ldy     #$0008
        sty     zWaitCounter
        lda     #$54
        sta     zMenuState
        jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; [ menu state $54: wait for fade (save menu) ]

MenuState_54:
@1a19:  ldy     zWaitCounter
        bne     @1a21
        lda     zNextMenuState                     ; go to next menu state
        sta     zMenuState
@1a21:  jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

.if LANG_EN
        .define SaveSlotEmptyStr {$84,$a6,$a9,$ad,$b2,$00}
        .define SaveSlotTimeStr {$93,$a2,$a6,$9e,$00}
        .define SaveSlotColonStr {$c1,$00}
        .define SaveSlotLevelStr {$8b,$95,$00}
        .define SaveSlotSlashStr {$c0,$00}
        .define SaveTitleStr {$92,$9a,$af,$9e,$00}
        .define NewGameStr {$8d,$9e,$b0,$ff,$86,$9a,$a6,$9e,$00}
.else
        .define SaveSlotEmptyStr {$24,$2c,$2f,$33,$38,$00}
        .define SaveSlotTimeStr {$33,$28,$2c,$24,$00}
        .define SaveSlotColonStr {$cf,$00}
        .define SaveSlotLevelStr {$2b,$35,$00}
        .define SaveSlotSlashStr {$ce,$00}
        .define SaveTitleStr {$7a,$c5,$24,$00}
        .define NewGameStr {$94,$c0,$c5,$30,$c5,$a0,$00}
.endif

; c3/1a24: ( 3, 8) "Empty"
SaveSlot1EmptyText:
        pos_text BG3A, {3, 8}, SaveSlotEmptyStr

; c3/1a2c: ( 3,15) "Empty"
SaveSlot2EmptyText:
        pos_text BG3A, {3, 15}, SaveSlotEmptyStr

; c3/1a34: ( 3,22) "Empty"
SaveSlot3EmptyText:
        pos_text BG3A, {3, 22}, SaveSlotEmptyStr

; c3/1a3c: ( 3,10) "Time"
SaveSlot1TimeText:
        pos_text BG3A, {3, 10}, SaveSlotTimeStr

; c3/1a43: ( 3,17) "Time"
SaveSlot2TimeText:
        pos_text BG3A, {3, 17}, SaveSlotTimeStr

; c3/1a4a: ( 3,24) "Time"
SaveSlot3TimeText:
        pos_text BG3A, {3, 24}, SaveSlotTimeStr

; c3/1a51: ( 4,11) ":"
SaveSlot1TimeColonText:
        pos_text BG3A, {4, 11}, SaveSlotColonStr

; c3/1a55: ( 4,18) ":"
SaveSlot2TimeColonText:
        pos_text BG3A, {4, 18}, SaveSlotColonStr

; c3/1a59: ( 4,25) ":"
SaveSlot3TimeColonText:
        pos_text BG3A, {4, 25}, SaveSlotColonStr

; c3/1a5d: (25, 8) "LV"
SaveSlot1LevelText:
        pos_text BG3A, {25, 8}, SaveSlotLevelStr

; c3/1a62: (25,15) "LV"
SaveSlot2LevelText:
        pos_text BG3A, {25, 15}, SaveSlotLevelStr

; c3/1a67: (25,22) "LV"
SaveSlot3LevelText:
        pos_text BG3A, {25, 22}, SaveSlotLevelStr

; c3/1a6c: (25,10) "/"
SaveSlot1HPSlashText:
        pos_text BG3A, {25, 10}, SaveSlotSlashStr

; c3/1a70: (25,17) "/"
SaveSlot2HPSlashText:
        pos_text BG3A, {25, 17}, SaveSlotSlashStr

; c3/1a74: (25,24) "/"
SaveSlot3HPSlashText:
        pos_text BG3A, {25, 24}, SaveSlotSlashStr

; c3/1a78: (15, 4) "Save"
SaveTitleText:
.if LANG_EN
        pos_text BG3A, {15, 4}, SaveTitleStr
.else
        pos_text BG3A, {14, 3}, SaveTitleStr
.endif

; c3/1a7f: (13, 4) "New Game"
NewGameText:
.if LANG_EN
        pos_text BG3A, {13, 4}, NewGameStr
.else
        pos_text BG3A, {13, 3}, NewGameStr
.endif

; ------------------------------------------------------------------------------
