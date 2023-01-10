
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

; ------------------------------------------------------------------------------

LoadSavedGame:
@14fe:  lda     $021f                   ; branch if not loading a saved game
        beq     @1514
        jsr     LoadSaveSlot
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        beq     @1514                   ; branch if checksum invalid
        jsr     PopTimers
        clr_a                           ; return $00
        bra     @1518
@1514:  shorta
        lda     #$ff                    ; return $ff
@1518:  sta     $0205
        clr_a
        rtl

; ------------------------------------------------------------------------------

; [ save game ]

; a = game slot

CopyGameDataToSRAM:
@151d:  and     #$03        ; set game slot
        sta     $307ff0
        sta     $0224
        pha
        ldy     $021b       ; save game time
        sty     $1863
        lda     $021d
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
        ldy     $00
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
        lda     $00
        xba
        asl
        tax
        longa
        lda     f:SRAMSlotPtrs,x   ; pointer to saved game data
        tax
        shorta
        ldy     $00
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
@15a4:  ldy     #.loword(GameSaveCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (save select) ]

UpdateGameSaveCursor:
@15aa:  jsr     MoveCursor

InitGameSaveCursor:
@15ad:  ldy     #.loword(GameLoadCursorPos+2)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GameSaveCursorProp:
@15b3:  .byte   $80,$00,$00,$01,$03

; ------------------------------------------------------------------------------

; [ init cursor (restore game) ]

LoadGameLoadCursor:
@15b8:  ldy     #.loword(GameLoadCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (restore game) ]

UpdateGameLoadCursor:
@15be:  jsr     MoveCursor

InitGameLoadCursor:
@15c1:  ldy     #.loword(GameLoadCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GameLoadCursorProp:
@15c7:  .byte   $80,$00,$00,$01,$04

GameLoadCursorPos:
@15cc:  .byte   $08,$1c
        .byte   $08,$3c
        .byte   $08,$74
        .byte   $08,$ac

; ------------------------------------------------------------------------------

; [ init cursor (save/restore confirm) ]

LoadSaveConfirmCursor:
@15d4:  ldy     #.loword(SaveConfirmCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (save/restore confirm) ]

UpdateSaveConfirmCursor:
@15da:  jsr     MoveCursor

InitSaveConfirmCursor:
@15dd:  ldy     #.loword(SaveConfirmCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

SaveConfirmCursorProp:
@15e3:  .byte   $80,$00,$00,$01,$02

SaveConfirmCursorPos:
@15e8:  .byte   $bf,$44
        .byte   $bf,$54

; ------------------------------------------------------------------------------

; [ draw save select menu ]

DrawGameSaveMenu:
@15ec:  jsr     ClearBG2ScreenA
        jsr     DrawSaveSlotWindows
        jsr     LoadWindowGfx
        ldy     #.loword(SaveTitleWindow)
        jsr     DrawWindow
        lda     #$20                    ; white text
        sta     $29
        ldy     #.loword(SaveTitleText)
        jsr     DrawPosText
        jmp     TfrSaveSlotWindows

; ------------------------------------------------------------------------------

; [ draw restore game menu ]

DrawGameLoadMenu:
@1608:  jsr     ClearBG2ScreenA
        stz     $1d4e
        jsr     InitWindowPal
        jsr     LoadWindowGfx
        ldy     #.loword(SaveTitleWindow)
        jsr     DrawWindow
        lda     $1d4e
        and     #$70
        sta     $1d4e
        jsr     DrawSaveSlotWindows
        lda     #$20                    ; white text
        sta     $29
        ldy     #.loword(NewGameText)
        jsr     DrawPosText
        jmp     TfrSaveSlotWindows

; ------------------------------------------------------------------------------

; [ draw save slot windows ]

DrawSaveSlotWindows:
@1632:  jsr     LoadGrayCharPal
        lda     #$20
        trb     $43                     ; enable hdma #5
        ldy     #$0002
        sty     $37                     ; bg1 vscroll
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
        lda     #$01
        sta     $66                     ; current save slot = 1
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
        lda     #$20                    ; white text
        sta     $29
        ldy     #.loword(SaveSlot1EmptyText)
        jsr     DrawPosText
        jsr     LoadSaveSlot1WindowPal

; slot 2
@1695:  lda     #$02
        sta     $66                     ; current save slot = 2
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
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot2EmptyText)
        jsr     DrawPosText
        jsr     LoadSaveSlot2WindowPal

; slot 3
@16c7:  lda     #$03
        sta     $66
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
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot3EmptyText)
        jsr     DrawPosText
        jsr     LoadSaveSlot3WindowPal
@16f9:  jsr     PopSRAM
        jsr     LoadSaveSlot1WindowGfx
        ldy     #.loword(SaveSlot1Window)
        jsr     DrawWindow
        jsr     LoadSaveSlot2WindowGfx
        ldy     #.loword(SaveSlot2Window)
        jsr     DrawWindow
        jsr     LoadSaveSlot3WindowGfx
        ldy     #.loword(SaveSlot3Window)
        jsr     DrawWindow
        ldy     #$1c00
        jmp     SetWindowTileFlags

; ------------------------------------------------------------------------------

; [ draw text for save slot 1 ]

DrawSave1GameText:
@171d:  lda     #$20        ; white text
        sta     $29
        ldy     #.loword(SaveSlot1TimeColonText)
        jsr     DrawPosText
        lda     $1863
        jsr     HexToDec3
        ldx     #$7b0d
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7b13
        jsr     DrawNum2
        jsr     DrawSave1CharText
        lda     #$2c        ; teal text
        sta     $29
        ldy     #.loword(SaveSlot1TimeText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 1 ]

DrawSave1CharText:
@174d:  clr_ax
@174f:  lda     $69,x
        bmi     @177c       ; branch if character slot is empty
        jsr     GetCharPtr
        lda     #$2c        ; teal text
        sta     $29
        ldy     #.loword(SaveSlot1LevelText)
        jsr     DrawPosText
        lda     #$20
        sta     $29         ; white text
        ldy     #.loword(SaveSlot1HPSlashText)
        jsr     DrawPosText
        ldy     #$3a4f
        phy
        ldx     #$7afd
        phx
        ldx     #$7af3
        phx
        ldx     #$7a81
        phx
        bra     DrawSaveSlotCharText
@177c:  inx                 ; next character slot
        bra     @174f

; ------------------------------------------------------------------------------

; [ draw character text for save slot ]

DrawSaveSlotCharText:
@177f:  ldx     $67
        lda     a:$0008,x     ; character's level
        jsr     HexToDec3
        plx
        jsr     DrawNum2
        ldy     $67
        jsr     CheckMaxHP
        lda     $0009,y     ; current hp
        sta     $f3
        lda     $000a,y
        sta     $f4
        jsr     HexToDec5
        plx
        jsr     DrawNum4
        ldx     $67
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
        lda     $6d,x
        sta     $67
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw text for save slot 2 ]

DrawSave2GameText:
@17ca:  lda     #$20        ; white text
        sta     $29
        ldy     #.loword(SaveSlot2TimeColonText)
        jsr     DrawPosText
        lda     $1863       ; game time
        jsr     HexToDec3
        ldx     #$7ccd
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7cd3
        jsr     DrawNum2
        jsr     DrawSave2CharText
        lda     #$2c        ; teal text
        sta     $29
        ldy     #.loword(SaveSlot2TimeText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 2 ]

DrawSave2CharText:
@17fa:  clr_ax
@17fc:  lda     $69,x
        bmi     @182a
        jsr     GetCharPtr
        lda     #$2c
        sta     $29
        ldy     #.loword(SaveSlot2LevelText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot2HPSlashText)
        jsr     DrawPosText
        ldy     #$3c0f
        phy
        ldx     #$7cbd
        phx
        ldx     #$7cb3
        phx
        ldx     #$7c41
        phx
        jmp     DrawSaveSlotCharText
@182a:  inx
        bra     @17fc

; ------------------------------------------------------------------------------

; [ draw text for save slot 3 ]

DrawSave3GameText:
@182d:  lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot3TimeColonText)
        jsr     DrawPosText
        lda     $1863
        jsr     HexToDec3
        ldx     #$7e8d
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7e93
        jsr     DrawNum2
        jsr     DrawSave3CharText
        lda     #$2c
        sta     $29
        ldy     #.loword(SaveSlot3TimeText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 3 ]

DrawSave3CharText:
@185d:  clr_ax
@185f:  lda     $69,x
        bmi     @188d
        jsr     GetCharPtr
        lda     #$2c
        sta     $29
        ldy     #.loword(SaveSlot3LevelText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot3HPSlashText)
        jsr     DrawPosText
        ldy     #$3dcf
        phy
        ldx     #$7e7d
        phx
        ldx     #$7e73
        phx
        ldx     #$7e01
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

SaveTitleWindow:
@189c:  .byte   $cb,$58,$1c,$02

SaveSlot1Window:
@18a0:  .byte   $cb,$59,$1c,$05

SaveSlot2Window:
@18a4:  .byte   $8b,$5b,$1c,$05

SaveSlot3Window:
@18a8:  .byte   $4b,$5d,$1c,$05

; ------------------------------------------------------------------------------

; [ save sram at 7e/ac8d ]

PushSRAM:
@18ac:  ldy     #$ac8d
        sty     hWMADDL
        ldx     $00
@18b4:  lda     $1600,x
        sta     hWMDATA
        inx
        cpx     #$0a00
        bne     @18b4
        rts

; ------------------------------------------------------------------------------

; [ restore sram from 7e/ac8d ]

PopSRAM:
@18c1:  ldx     $00
@18c3:  lda     $7eac8d,x
        sta     $1600,x
        inx
        cpx     #$0a00
        bne     @18c3
        rts

; ------------------------------------------------------------------------------

_c318d1:
@18d1:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(_c318f0)
        sty     $4352
        lda     #^_c318f0
        sta     $4354
        lda     #^_c318f0
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

_c318f0:
@18f0:  .byte   $20,$00,$00,$0c,$04,$00,$0c,$08,$00,$08,$c8,$ff,$50,$00,$00,$58
        .byte   $00,$00,$00

; ------------------------------------------------------------------------------

; [ update character sprites (save menu) ]

DrawSaveMenuChars:
@1903:  ldx     $00
@1905:  lda     $7eaa71,x               ; branch if no character in this slot
        bmi     @1977
        phx
        phx
        lda     #3
        ldy     #.loword(SaveMenuCharTask)
        jsr     CreateTask
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        lda     $66                     ; selected save slot
        beq     @1931
        cmp     #$01
        beq     @1943
        cmp     #$02
        beq     @193a

; slot 3
        lda     f:SaveMenuCharPalTbl+36,x
        sta     $3749,y                 ; palette
        bra     @194a

; new game
@1931:  lda     f:SaveMenuCharPalTbl,x
        sta     $3749,y
        bra     @194a

; slot 2
@193a:  lda     f:SaveMenuCharPalTbl+24,x
        sta     $3749,y
        bra     @194a

; slot 1
@1943:  lda     f:SaveMenuCharPalTbl+12,x
        sta     $3749,y
@194a:  lda     #^PartyCharAnimTbl
        sta     $35ca,y
        clr_a
        sta     $33cb,y
        sta     $344b,y
        lda     f:SaveMenuCharXTbl,x
        sta     $33ca,y                 ; x position
        lda     f:SaveMenuCharYTbl,x
        sta     $344a,y                 ; y position
        lda     $7eaa71,x
        longa
        asl
        tax
        lda     f:PartyCharAnimTbl,x
        sta     $32c9,y                 ; pointer to animation data
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

; palette assignments for character sprites
SaveMenuCharPalTbl:
@1997:  .byte   $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
@19a3:  .byte   $00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
@19af:  .byte   $02,$02,$02,$02,$00,$00,$00,$00,$02,$02,$02,$02
@19bb:  .byte   $02,$02,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; [ character sprite task (save menu) ]

SaveMenuCharTask:
@19c7:  ldx     $2d
        jsr     InitAnimTask
        jsr     UpdateAnimTask
        clc
        rts

; ------------------------------------------------------------------------------

; [ calculate saved game data checksum ]

CalcSaveSlotChecksum:
@19d1:  stz     $e7                     ; +$e7 = sram checksum
        stz     $e8
        ldx     $00
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
        sty     $20
        lda     #$54
        sta     $26
        jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; [ menu state $52: fade in (save menu) ]

MenuState_52:
@1a0a:  jsr     CreateFadeInTask
        ldy     #$0008
        sty     $20
        lda     #$54
        sta     $26
        jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; [ menu state $54: wait for fade (save menu) ]

MenuState_54:
@1a19:  ldy     $20
        bne     @1a21
        lda     $27                     ; go to next menu state
        sta     $26
@1a21:  jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; c3/1a24: ( 3, 8) "Empty"
SaveSlot1EmptyText:
@1a24:  .word   $7a4f
        .byte   $84,$a6,$a9,$ad,$b2,$00

; c3/1a2c: ( 3,15) "Empty"
SaveSlot2EmptyText:
@1a2c:  .word   $7c0f
        .byte   $84,$a6,$a9,$ad,$b2,$00

; c3/1a34: ( 3,22) "Empty"
SaveSlot3EmptyText:
@1a34:  .word   $7dcf
        .byte   $84,$a6,$a9,$ad,$b2,$00

; c3/1a3c: ( 3,10) "Time"
SaveSlot1TimeText:
@1a3c:  .word   $7acf
        .byte   $93,$a2,$a6,$9e,$00

; c3/1a43: ( 3,17) "Time"
SaveSlot2TimeText:
@1a43:  .word   $7c8f
        .byte   $93,$a2,$a6,$9e,$00

; c3/1a4a: ( 3,24) "Time"
SaveSlot3TimeText:
@1a4a:  .word   $7e4f
        .byte   $93,$a2,$a6,$9e,$00

; c3/1a51: ( 4,11) ":"
SaveSlot1TimeColonText:
@1a51:  .word   $7b11
        .byte   $c1,$00

; c3/1a55: ( 4,18) ":"
SaveSlot2TimeColonText:
@1a55:  .word   $7cd1
        .byte   $c1,$00

; c3/1a59: ( 4,25) ":"
SaveSlot3TimeColonText:
@1a59:  .word   $7e91
        .byte   $c1,$00

; c3/1a5d: (25, 8) "LV"
SaveSlot1LevelText:
@1a5d:  .word   $7a7b
        .byte   $8b,$95,$00

; c3/1a62: (25,15) "LV"
SaveSlot2LevelText:
@1a62:  .word   $7c3b
        .byte   $8b,$95,$00

; c3/1a67: (25,22) "LV"
SaveSlot3LevelText:
@1a67:  .word   $7dfb
        .byte   $8b,$95,$00

; c3/1a6c: (25,10) "/"
SaveSlot1HPSlashText:
@1a6c:  .word   $7afb
        .byte   $c0,$00

; c3/1a70: (25,17) "/"
SaveSlot2HPSlashText:
@1a70:  .word   $7cbb
        .byte   $c0,$00

; c3/1a74: (25,24) "/"
SaveSlot3HPSlashText:
@1a74:  .word   $7e7b
        .byte   $c0,$00

; c3/1a78: (15, 4) "Save"
SaveTitleText:
@1a78:  .word   $7967
        .byte   $92,$9a,$af,$9e,$00

; c3/1a7f: (13, 4) "New Game"
NewGameText:
@1a7f:  .word   $7963
        .byte   $8d,$9e,$b0,$ff,$86,$9a,$a6,$9e,$00

; ------------------------------------------------------------------------------
