; ------------------------------------------------------------------------------

        ram_verbose 0
        ram_org $00

; always zero (for quickly clearing 16-bit registers)
        ram_word zZero

; unused
        ram_word z02

; controller state, ignores custom key mapping (for ending credits scenes)
        ram_word zRawCtrlState

; current controller state
        ram_word zCurrCtrlState

; controller state with newly pressed buttons
        ram_word zNewCtrlState

; controller state with repeating buttons
        ram_word zRepCtrlState

; previous controller state
        ram_word zPrevCtrlState

; pointer to next available sprite
        ram_word zSpritePtr             ; $0e
        ram_word zSpriteHiPtr           ; $10
        ram_word zDMA1Size              ; $12
        ram_word zDMA1Dest              ; $14
        ram_faraddr zDMA1Src            ; $16
        ram_word zDMA2Size              ; $19
        ram_word zDMA2Dest              ; $1b
        ram_faraddr zDMA2Src            ; $1d
        ram_word zWaitCounter           ; $20
        ram_byte z22                    ; $22
        ram_byte zFrameCounter          ; $23
        ram_byte zInterruptEnable       ; $24
        ram_byte z25                    ; $25

        push_ram_offset
        ram_byte zMenuState             ; $26
        pop_ram_offset
        ram_byte zEndingState           ; $26

        ram_byte zNextMenuState
        ram_byte zSelIndex
        ram_byte zTextColor
        ram_byte zListType
        ram_word zTaskCodePtr
        ram_word zTaskOffset
        ram_word zNumTasks
        ram_word zNumUnusedSprites
        ram_byte zSpriteHiCounter
        ram_byte zSpriteHiVal
        ram_word zBG1HScroll
        ram_word zBG1VScroll
        ram_word zBG2HScroll
        ram_word zBG2VScroll
        ram_word zBG3HScroll
        ram_word zBG3VScroll
        ram_word zTextScrollRate
        ram_byte zEnableHDMA
        ram_byte zScreenBrightness
        ram_byte z45
        ram_byte z46
        ram_byte z47
        ram_byte z48
        ram_byte z49
        ram_byte z4a
        ram_byte z4b
        ram_byte z4c  ; zReturnMenuState
        ram_byte z4d  ; zRelCursorPosX, zRelCursorPos
        ram_byte z4e  ; zRelCursorPosY
        ram_byte z4f  ; zAbsCursorPosX, zAbsCursorPos
        ram_byte z50  ; zAbsCursorPosY
        ram_byte z51  ; zCursorOffsetX, zCursorOffset
        ram_byte z52  ; zCursorOffsetY
        ram_byte z53  ; zMaxCursorPosX, zMaxCursorPos
        ram_byte z54  ; zMaxCursorPosY
        ram_byte z55
        ram_byte z56
        ram_byte z57
        ram_byte z58
        ram_byte zCursorWrap
        ram_byte z5a
        ram_byte z5b
        ram_byte z5c
        ram_byte z5d
        ram_byte z5e
        ram_byte z5f
        ram_byte_array z60, 4

; some variables here are used for multiple things in different menus

        ram_byte z64
        ram_byte z65
        ram_byte zSelSaveSlot
        ram_word zSelCharPropPtr

        push_ram_offset

        ram_byte zItemQty
        ram_byte z6a

        pop_ram_offset

        ram_byte_array zCharID, 4
        ram_word_array zCharPropPtr, 4
        ram_byte_array zCharRowOrder, 4

        ram_scope zSkillsTextColor
                ram_byte Genju
                ram_byte Magic
                ram_byte Bushido
                ram_byte Blitz
                ram_byte Lore
                ram_byte Rage
                ram_byte Dance
        end_ram_scope

        ram_res 5, z80
        ram_res 8, z85
        ram_byte z8d
        ram_byte z8e
        ram_byte z8f

        ram_byte z90
        ram_word z91
        ram_word z93
        ram_word z95
        ram_word z97
        ram_byte z99
        ram_word z9a
        ram_word zMenuScrollRate
        ram_byte zPrevMenuState
        ram_byte z9f

        ram_byte za0
        ram_byte za1
        ram_byte za2
        ram_byte za3
        ram_byte za4
        ram_byte za5
        ram_byte za6
        ram_byte za7
        ram_byte za8
        ram_byte za9
        ram_byte zaa
        ram_byte zab
        ram_byte zac
        ram_byte zad
        ram_byte zae
        ram_byte zaf

        ram_byte zb0
        ram_byte zb1
        ram_word zb2
        ram_byte zb4
        ram_byte zMosaic
        ram_byte zb6

        ram_word zM7X
        ram_word zM7Y
        ram_word zM7A
        ram_word zM7B
        ram_word zM7C
        ram_word zM7D

        ram_word zc3
        ram_word zc5
        ram_word zc7
        ram_word zc9
        ram_word zcb
        ram_byte zcd
        ram_byte zce
        ram_word zcf
        ram_byte zd1

        .assert _ram_offset <= $e0, error, "Menu zero page RAM overfilled"
        _ram_offset .set $e0

        ram_byte ze0
        ram_byte ze1
        ram_byte ze2
        ram_byte ze3
        ram_byte ze4
        ram_byte ze5
        ram_byte ze6
        ram_byte ze7
        ram_byte ze8
        ram_byte ze9
        ram_byte zea
        ram_byte zeb
        ram_byte zec
        ram_byte zed
        ram_byte zee
        ram_byte zef

        ram_byte zf0
        ram_byte zf1
        ram_byte zf2
        ram_byte zf3
        ram_byte zf4
        ram_byte zf5
        ram_byte zf6
        ram_byte zf7
        ram_byte zf8
        ram_byte zf9
        ram_byte zfa
        ram_byte zfb
        ram_byte zfc
        ram_byte zfd
        ram_byte zfe
        ram_byte zff

        .assert _ram_offset <= $0100, error, "Menu zero page temp RAM overfilled"

; ------------------------------------------------------------------------------

        ram_org $0200

        ram_byte r0200
        ram_byte r0201
        ram_byte r0202
        ram_byte r0203
        ram_byte r0204
        ram_byte r0205
        ram_byte r0206
        ram_byte r0207
        ram_byte r0208
        ram_byte r0209
        ram_byte r020a
        ram_byte r020b
        ram_byte r020c
        ram_byte r020d
        ram_byte r020e
        ram_byte r020f

        ram_byte r0210
        ram_byte r0211
        ram_byte r0212
        ram_byte r0213
        ram_byte r0214
        ram_byte r0215
        ram_byte r0216
        ram_byte r0217
        ram_byte r0218
        ram_byte r0219
        ram_byte r021a
        ram_byte rGameTimeHours
        ram_byte rGameTimeMinutes
        ram_byte rGameTimeSeconds
        ram_byte rGameTimeFrames
        ram_byte rSaveSlotToLoad
        ram_res 4, r0220
        ram_byte rSelSaveSlot
        ram_byte r0225
        ram_byte r0226
        ram_byte r0227
        ram_byte r0228
        ram_byte r0229
        ram_byte r022a
        ram_byte r022b
        ram_byte r022c
        ram_byte r022d
        ram_byte r022e
        ram_byte r022f
        ram_byte r0230
        ram_byte r0231
        ram_byte r0232
        ram_byte r0233
        ram_byte r0234
        ram_byte r0235
        ram_byte r0236
        ram_byte r0237
        ram_byte r0238
        ram_byte r0239
        ram_byte r023a
        ram_byte r023b
        ram_byte r023c
        ram_byte r023d
        ram_byte r023e
        ram_byte r023f
        ram_byte r0240
        ram_byte r0241
        ram_byte r0242
        ram_byte r0243
        ram_byte r0244
        ram_byte r0245
        ram_byte r0246
        ram_byte r0247
        ram_byte r0248
        ram_byte r0249
        ram_byte r024a
        ram_byte r024b
        ram_byte r024c
        ram_byte r024d

        .assert _ram_offset <= $0300, error, "Menu global parameters overfilled"

; ------------------------------------------------------------------------------

        ram_org $0300

        ram_res $0200, rSprites
        ram_res $20, rSpritesHi

; ------------------------------------------------------------------------------

        ram_org $7e3040

        ram_scope wStatTextColor
                ram_byte Strength
                ram_byte Speed
                ram_byte Stamina
                ram_byte MagPwr
                ram_byte Defense
                ram_byte Evade
                ram_byte MagDef
                ram_byte MBlock
                ram_byte BatPwr
        end_ram_scope

        ram_scope wPalBuf
                ram_res $20, BGPal0
                ram_res $20, BGPal1
                ram_res $20, BGPal2
                ram_res $20, BGPal3
                ram_res $20, BGPal4
                ram_res $20, BGPal5
                ram_res $20, BGPal6
                ram_res $20, BGPal7

                ram_res $20, SpritePal0
                ram_res $20, SpritePal1
                ram_res $20, SpritePal2
                ram_res $20, SpritePal3
                ram_res $20, SpritePal4
                ram_res $20, SpritePal5
                ram_res $20, SpritePal6
                ram_res $20, SpritePal7
        end_ram_scope

        ram_array wTaskProp, 64, 24, 2
                ram_word CodePtr
                end_ram_block
                ram_word AnimPtr
                end_ram_block
                ram_word w7e3349
                end_ram_block
                ram_word PosX
                end_ram_block
                ram_word PosY
                end_ram_block
                ram_word SpeedX
                end_ram_block
                ram_word SpeedY
                end_ram_block
                ram_byte w7e35c9
                ram_byte AnimBank
                end_ram_block
                ram_byte State
                ram_byte Flags
                end_ram_block
                ram_byte w7e36c9
                ram_byte AnimCounter
                end_ram_block
                ram_byte Pal
                ram_byte w7e374a
                end_ram_block
                ram_word w7e37c9
                end_ram_block
        end_ram_array

        ram_scope wBG1Tiles
                ram_res $0800, ScreenA
                ram_res $0800, ScreenB
                ram_res $0800, ScreenC
                ram_res $0800, ScreenD
        end_ram_scope

        ram_scope wBG2Tiles
                ram_res $0800, ScreenA
                ram_res $0800, ScreenB
                ram_res $0800, ScreenC
                ram_res $0800, ScreenD
        end_ram_scope

        ram_scope wBG3Tiles
                ram_res $0800, ScreenA
                ram_res $0800, ScreenB
                ram_res $0800, ScreenC
                ram_res $0800, ScreenD
        end_ram_scope

        .scope BG_SCREEN
                BG1A := wBG1Tiles::ScreenA
                BG1B := wBG1Tiles::ScreenB
                BG1C := wBG1Tiles::ScreenC
                BG1D := wBG1Tiles::ScreenD
                BG2A := wBG2Tiles::ScreenA
                BG2B := wBG2Tiles::ScreenB
                BG2C := wBG2Tiles::ScreenC
                BG2D := wBG2Tiles::ScreenD
                BG3A := wBG3Tiles::ScreenA
                BG3B := wBG3Tiles::ScreenB
                BG3C := wBG3Tiles::ScreenC
                BG3D := wBG3Tiles::ScreenD
        .endscope

; ------------------------------------------------------------------------------
