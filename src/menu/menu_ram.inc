; ------------------------------------------------------------------------------

.if LANG_EN
        ZERO_CHAR                       = $b4
        COLON_CHAR                      = $c1
        GAUGE_EMPTY_CHAR                = $f0
        GAUGE_FULL_CHAR                 = $f8
.else
        GAUGE_EMPTY_CHAR                = $10
        GAUGE_FULL_CHAR                 = $18
        ZERO_CHAR                       = $53
        COLON_CHAR                      = $cf
.endif

; ------------------------------------------------------------------------------

.enum MENU_STATE
      FADE_OUT                          ; = $00 // 0
      FADE_IN                           ; = $01 // 1
      WAIT_FADE                         ; = $02 // 2
      FIELD_MENU_REINIT                 ; = $03 // 3
      FIELD_MENU_INIT                   ; = $04 // 4
      FIELD_MENU_SELECT                 ; = $05 // 5
      FIELD_MENU_CHAR                   ; = $06 // 6
      ITEM_INIT                         ; = $07 // 7
      ITEM_SELECT                       ; = $08 // 8
      SKILLS_INIT                       ; = $09 // 9
      SKILLS_SELECT                     ; = $0a // 10
      STATUS_INIT                       ; = $0b // 11
      STATUS_SELECT                     ; = $0c // 12
      CONFIG_INIT                       ; = $0d // 13
      CONFIG_SELECT                     ; = $0e // 14
      ORDER_SELECT                      ; = $0f // 15
      ORDER_MOVE                        ; = $10 // 16
      ORDER_CHANGE                      ; = $11 // 17
      ORDER_WAIT                        ; = $12 // 18
      SAVE_INIT                         ; = $13 // 19
      SAVE_SELECT                       ; = $14 // 20
      SAVE_CONFIRM_INIT                 ; = $15 // 21
      SAVE_CONFIRM                      ; = $16 // 22
      ITEM_OPTIONS                      ; = $17 // 23
      ITEM_RARE                         ; = $18 // 24
      ITEM_MOVE                         ; = $19 // 25
      SKILLS_MAGIC                      ; = $1a // 26
      SKILLS_LORE                       ; = $1b // 27
      SKILLS_DANCE                      ; = $1c // 28
      SKILLS_RAGE                       ; = $1d // 29
      SKILLS_GENJU                      ; = $1e // 30
      UNUSED_1F                         ; = $1f // 31
      LOAD_INIT                         ; = $20 // 32
      LOAD_SELECT                       ; = $21 // 33

      TERMINATE                         = $ff
.endenum

.enum LIST_TYPE
      ITEM
      MAGIC
      LORE
      RAGE
      GENJU
      EQUIP
.endenum

.enum BG1_TEXT_COLOR
        DEFAULT = $20
        TEAL = $24
        GRAY = $28
        BLUE = $2c
        COLOR_BAR = $30
        WINDOW = $3c
.endenum

.enum BG3_TEXT_COLOR
        DEFAULT = $20
        GRAY = $24
        YELLOW = $28
        TEAL = $2c
        TEAL_ALT = $30
        BLUE = $38
.endenum

; ------------------------------------------------------------------------------

ram_verbose 0
ram_org $00
ram_addr_size ZP

; always zero (for quickly clearing 16-bit registers)
ram_word z00
.define z0 z00
.define zZero z00

; unused
ram_word z02

; controller state, ignores custom key mapping (for ending credits scenes)
ram_word z04

; current controller state
ram_word z06

; controller state with newly pressed buttons
ram_word z08

; controller state with repeating buttons
ram_word z0a

; previous controller state
ram_word z0c

; pointer to next available sprite
ram_word zSpritePtr
ram_word zSpriteHiPtr
ram_word zDMA1Size
ram_word zDMA1Dest
ram_faraddr zDMA1Src
ram_word zDMA2Size
ram_word zDMA2Dest
ram_faraddr zDMA2Src
ram_word zWaitCounter
ram_byte z22
ram_byte zFrameCounter
ram_byte zInterruptEnable
ram_byte z25
ram_byte zMenuState
ram_byte zNextMenuState
ram_byte zSelIndex
ram_byte zTextColor
ram_byte zListType
ram_word zTaskCodePtr
ram_word zTaskOffset
ram_word zNumTasks
ram_word z31
ram_byte z33
ram_byte z34
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
ram_byte z4c
ram_byte z4d
ram_byte z4e
ram_byte z4f
ram_byte z50
ram_byte z51
ram_byte z52
ram_byte z53
ram_byte z54
ram_byte z55
ram_byte z56
ram_byte z57
ram_byte z58
ram_byte z59
ram_byte z5a
ram_byte z5b
ram_byte z5c
ram_byte z5d
ram_byte z5e
ram_byte z5f
ram_byte z60
ram_byte z61
ram_byte z62
ram_byte z63
ram_byte z64
ram_byte z65
ram_byte zSelSaveSlot
ram_word zSelCharPropPtr

ram_scope zCharID
        ram_byte Slot1
        ram_byte Slot2
        ram_byte Slot3
        ram_byte Slot4
end_ram_scope

ram_scope zCharPropPtr
        ram_word Slot1
        ram_word Slot2
        ram_word Slot3
        ram_word Slot4
end_ram_scope

ram_scope zCharRowOrder
        ram_byte Slot1
        ram_byte Slot2
        ram_byte Slot3
        ram_byte Slot4
end_ram_scope

ram_scope zSkillsTextColor
        ram_byte Genju
        ram_byte Magic
        ram_byte Bushido
        ram_byte Blitz
        ram_byte Lore
        ram_byte Rage
        ram_byte Dance
end_ram_scope

ram_byte z80
ram_byte z81
ram_byte z82
ram_byte z83
ram_byte z84
ram_byte z85
ram_byte z86
ram_byte z87
ram_byte z88
ram_byte z89
ram_byte z8a
ram_byte z8b
ram_byte z8c
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
ram_addr_size NEAR

ram_byte w0200
ram_byte w0201
ram_byte w0202
ram_byte w0203
ram_byte w0204
ram_byte w0205
ram_byte w0206
ram_byte w0207
ram_byte w0208
ram_byte w0209
ram_byte w020a
ram_byte w020b
ram_byte w020c
ram_byte w020d
ram_byte w020e
ram_byte w020f

ram_byte w0210
ram_byte w0211
ram_byte w0212
ram_byte w0213
ram_byte w0214
ram_byte w0215
ram_byte w0216
ram_byte w0217
ram_byte w0218
ram_byte w0219
ram_byte w021a
ram_byte wGameTimeHours
ram_byte wGameTimeMinutes
ram_byte wGameTimeSeconds
ram_byte wGameTimeFrames
ram_byte wSaveSlotToLoad
ram_byte w0220
ram_byte w0221
ram_byte w0222
ram_byte w0223
ram_byte wSelSaveSlot
ram_byte w0225
ram_byte w0226
ram_byte w0227
ram_byte w0228
ram_byte w0229
ram_byte w022a
ram_byte w022b
ram_byte w022c
ram_byte w022d
ram_byte w022e
ram_byte w022f
ram_byte w0230
ram_byte w0231
ram_byte w0232
ram_byte w0233
ram_byte w0234
ram_byte w0235
ram_byte w0236
ram_byte w0237
ram_byte w0238
ram_byte w0239
ram_byte w023a
ram_byte w023b
ram_byte w023c
ram_byte w023d
ram_byte w023e
ram_byte w023f
ram_byte w0240
ram_byte w0241
ram_byte w0242
ram_byte w0243
ram_byte w0244
ram_byte w0245
ram_byte w0246
ram_byte w0247
ram_byte w0248
ram_byte w0249
ram_byte w024a
ram_byte w024b
ram_byte w024c
ram_byte w024d

.assert _ram_offset <= $0300, error, "Menu global parameters overfilled"

; ------------------------------------------------------------------------------

ram_org $0300

ram_res wSprites, $0200
ram_res wSpritesHi, $20

; ------------------------------------------------------------------------------

ram_org $7e3040
ram_addr_size FAR

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
        ram_res BGPal0, $20
        ram_res BGPal1, $20
        ram_res BGPal2, $20
        ram_res BGPal3, $20
        ram_res BGPal4, $20
        ram_res BGPal5, $20
        ram_res BGPal6, $20
        ram_res BGPal7, $20

        ram_res SpritePal0, $20
        ram_res SpritePal1, $20
        ram_res SpritePal2, $20
        ram_res SpritePal3, $20
        ram_res SpritePal4, $20
        ram_res SpritePal5, $20
        ram_res SpritePal6, $20
        ram_res SpritePal7, $20
end_ram_scope

ram_res wTaskCodePtr, $80
ram_res wTaskAnimPtr, $80
ram_res w7e3349, $80
ram_byte wTaskPosLongX
ram_res wTaskPosX, $7f
ram_byte wTaskPosLongY
ram_res wTaskPosY, $7f
ram_byte wTaskSpeedLongX
ram_res wTaskSpeedX, $7f
ram_byte wTaskSpeedLongY
ram_res wTaskSpeedY, $7f
ram_byte w7e35c9
ram_res wTaskAnimBank, $7f
ram_byte wTaskState
ram_res wTaskFlags, $7f                 ; $7e364a
ram_byte w7e36c9
ram_res wAnimCounter, $7f               ; $7e36ca
ram_res wTaskPal, $80                   ; $7e3749
ram_res w7e37c9, $80                    ; $7e37c9

ram_scope wBG1Tiles
        ram_res ScreenA, $0800
        ram_res ScreenB, $0800
        ram_res ScreenC, $0800
        ram_res ScreenD, $0800
end_ram_scope

ram_scope wBG2Tiles
        ram_res ScreenA, $0800
        ram_res ScreenB, $0800
        ram_res ScreenC, $0800
        ram_res ScreenD, $0800
end_ram_scope

ram_scope wBG3Tiles
        ram_res ScreenA, $0800
        ram_res ScreenB, $0800
        ram_res ScreenC, $0800
        ram_res ScreenD, $0800
end_ram_scope

.enum BG_SCREEN
        BG1A = near wBG1Tiles::ScreenA
        BG1B = near wBG1Tiles::ScreenB
        BG1C = near wBG1Tiles::ScreenC
        BG1D = near wBG1Tiles::ScreenD
        BG2A = near wBG2Tiles::ScreenA
        BG2B = near wBG2Tiles::ScreenB
        BG2C = near wBG2Tiles::ScreenC
        BG2D = near wBG2Tiles::ScreenD
        BG3A = near wBG3Tiles::ScreenA
        BG3B = near wBG3Tiles::ScreenB
        BG3C = near wBG3Tiles::ScreenC
        BG3D = near wBG3Tiles::ScreenD
.endenum

.mac _op_pos op, screen, xx, yy
        op (BG_SCREEN::screen + (xx) * 2 + (yy) * 64)
.endmac

.mac op_pos op, screen, xy_pos
        _op_pos op, screen, xy_pos
.endmac

.define lda_pos op_pos lda #,
.define ldx_pos op_pos ldx #,
.define ldy_pos op_pos ldy #,
.define adc_pos op_pos adc #,
.define make_pos op_pos .addr,

.mac _make_window screen, xy, ww, hh
        _op_pos .addr, screen, xy
        .byte ww, hh
.endmac

.mac make_window screen, xy, wh
        _make_window screen, {xy}, wh
.endmac

.mac raw_text text
        .byte text
.endmac

.mac pos_text layer, xy_pos, text
        make_pos layer, {xy_pos}
        .byte text
.endmac

.mac hdma_byte lines, value
        .byte lines
        .byte value
.endmac

.mac hdma_word lines, value
        .byte lines
        .if value < 0
                .word .loword(value)
        .else
                .word value
        .endif
.endmac

.mac _hdma_2byte lines, value1, value2
        .byte lines
        .byte value1, value2
.endmac

.mac hdma_2byte lines, values
        _hdma_2byte lines, values
.endmac

.mac _hdma_4byte lines, value1, value2, value3, value4
        .byte lines
        .byte value1, value2, value3, value4
.endmac

.mac hdma_4byte lines, values
        _hdma_4byte lines, values
.endmac

.mac hdma_addr lines, value
        .byte lines
        .addr value
.endmac

.mac hdma_end
        .byte 0
.endmac

.enum CURSOR_PROP_FLAGS
        NO_Y_WRAP = BIT_0
        NO_X_WRAP = BIT_7
        NO_XY_WRAP = BIT_0 | BIT_7
.endenum

.mac make_cursor_prop init_xy, max_xy, flags
        .ifnblank flags
                opflg .byte, CURSOR_PROP_FLAGS, {flags}
        .else
                .byte 0
        .endif
        .byte init_xy, max_xy
.endmac

; ------------------------------------------------------------------------------
