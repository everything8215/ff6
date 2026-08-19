
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: field_menu.asm                                                       |
; |                                                                            |
; | description: main menu                                                     |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.if !LANG_EN
.include "src/text/char_title.inc"
.endif
.include "src/text/item_name.inc"

.import GenjuName, MagicProp

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ menu state $04: main menu (init) ]

        array_label MENU_STATE, MENU_STATE::FIELD_MENU_INIT
@1a8a:  jsr     DisableInterrupts
        jsr     InitPortraits
        jsr     DisableDMA2
        jsr     DisableWindow2PosHDMA
        lda     #BIT_2                  ; enable hdma channel #2 (window 1 position)
        tsb     zEnableHDMA
        jsr     DisableDMA2
        jsr     ClearBGScroll
        lda     #$03        ; set bg1 data address and screen size (4 screens)
        sta     hBG1SC
        lda     #$43        ; set bg3 data address and screen size (4 screens)
        sta     hBG3SC
        lda     #BIT_6 | BIT_7        ; disable hdma channel #6 and #7 (bg1 horizontal & vertical scroll)
        trb     zEnableHDMA
        lda     #$02        ; cursor 1 is active
        sta     z46
        jsr     DrawMainMenu
        lda     #0
        ldy     #near MainMenuCursorTask
        jsr     CreateTask
        jsr     CreateCursorTask
        jsr     InitMainScreenLayerHDMA
        ldy     #2                      ; bg1 vertical scroll = 2
        sty     zBG1VScroll
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #MENU_STATE::FIELD_MENU_SELECT
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $07: item (init) ]

        array_label MENU_STATE, MENU_STATE::ITEM_INIT
@1ad6:  jsr     InitItemList
        jsr     _c31afe
        jsr     _c31b0e
        jmp     _c31b2e

; ------------------------------------------------------------------------------

; [ init item list ]

; used for item menu and colosseum

.proc InitItemList

        PAGE_HEIGHT = 10
.if ::LANG_EN
        PAGE_WIDTH = 1
        MAX_SCROLL = 245
.else
        PAGE_WIDTH = 2
        MAX_SCROLL = 118
.endif

        jsr     DisableInterrupts
        jsr     InitBigText
        jsr     ClearBGScroll
        stz     z4a                     ; scroll position = 0
        stz     z49                     ; cursor position = 0
        lda     #MAX_SCROLL
        sta     z5c
        lda     #PAGE_HEIGHT
        sta     z5a
        lda     #PAGE_WIDTH
        sta     z5b
        jmp     LoadItemListCursor
.endproc

; ------------------------------------------------------------------------------

; [  ]

_c31afe:
@1afe:  lda     $1d4e       ; branch if cursor is not memory
        and     #$40
        beq     @1b08
        jsr     RestoreItemCursorPos
@1b08:  jsr     InitItemListCursor
        jmp     DrawItemListMenu

; ------------------------------------------------------------------------------

; [  ]

_c31b0e:
@1b0e:  jsr     InitItemBGScrollHDMA
        jsr     CreateCursorTask
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$0070
.else
        lda     #$00ea
.endif
        sta     wTaskProp::SpeedY_H,x
        lda     #$0058
        sta     wTaskProp::SpeedX_H,x
        shorta
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c31b2e:
@1b2e:  lda     #MENU_STATE::ITEM_SELECT
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $77: item select (init, return from character select) ]

        array_label MENU_STATE, MENU_STATE::ITEM_CHAR_RETURN
@1b35:  jsr     InitItemList
        lda     z8e
        sta     z4d
        ldy     z8e
        sty     z4f
        lda     z90
        sta     z4a
        lda     z4a
        sta     ze0
        lda     z50
        sec
        sbc     ze0
        sta     z4e
        jsr     InitItemListCursor
        jsr     DrawItemListMenu
        jsr     _c31b0e
        jmp     _c31b2e

; ------------------------------------------------------------------------------

; [ menu state $09: skills (init) ]

        array_label MENU_STATE, MENU_STATE::SKILLS_INIT
@1b5b:  jsr     DisableInterrupts
        clr_a
        lda     zSelIndex         ; selected character slot
        tax
        lda     zCharID,x       ; selected character number
        jsl     UpdateEquip_ext
        jsr     InitPortraits
        jsr     DisableWindow1PosHDMA
        stz     z4a         ; clear scroll positions
        stz     z49
        jsr     InitSkillsBGScrollHDMA
        jsr     DrawSkillsWindow
        jsr     LoadSkillsCursor
        lda     $1d4e       ; branch if cursor setting is not memory
        and     #$40
        beq     @1b85
        jsr     RestoreSkillsCursorPos
@1b85:  jsr     InitSkillsCursor
        jsr     CreateCursorTask
        jsr     InitBigText
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #MENU_STATE::SKILLS_SELECT
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ init description text ]

InitBigText:
@1b99:  jsr     ClearBigTextBuf
        jsr     TfrBigTextGfx
        lda     #0
        ldy     #near BigTextTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ init character portraits ]

InitPortraits:
@1ba8:  jsr     InitCharProp
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        lda     #$05                    ; enable ??? & color palette dma
        tsb     z45
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ menu state $35: equip menu (init) ]

        array_label MENU_STATE, MENU_STATE::EQUIP_INIT
@1bb8:  jsr     _c31bbd
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [  ]

_c31bbd:
@1bbd:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        lda     #$06
        tsb     z46
        stz     z4a
        stz     z49
        jsr     InitEquipScrollHDMA
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        jmp     CreateCursorTask

; ------------------------------------------------------------------------------

; [  ]

_c31bd7:
@1bd7:  jsr     DrawEquipMenu
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #MENU_STATE::EQUIP_OPTIONS
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $7e: switch character (equip) ]

        array_label MENU_STATE, MENU_STATE::EQUIP_SLOT_CHAR_CHANGE
@1be5:  jsr     _c31c01
        jsr     DrawEquipTitleEquip
        jsr     _c31c0a
        lda     #MENU_STATE::EQUIP_SLOT_SELECT
        jmp     _c31c15

; ------------------------------------------------------------------------------

; [ menu state $7f: switch character (equip remove) ]

        array_label MENU_STATE, MENU_STATE::EQUIP_REMOVE_CHAR_CHANGE
@1bf3:  jsr     _c31c01
        jsr     DrawEquipTitleRemove
        jsr     _c31c0a
        lda     #MENU_STATE::EQUIP_REMOVE_SELECT
        jmp     _c31c15

; ------------------------------------------------------------------------------

; [  ]

_c31c01:
@1c01:  jsr     _c31bbd
        jsr     DrawEquipMenu
        jmp     _c39614

; ------------------------------------------------------------------------------

; [  ]

_c31c0a:
@1c0a:  jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c31c15:
@1c15:  sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $6d: equip menu after optimize ]

        array_label MENU_STATE, MENU_STATE::EQUIP_OPTIMUM_RETURN
@1c1a:  jsr     _c31bbd
        jsr     EquipOptimum
        lda     #$02
        sta     z25
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [ menu state $6e: equip menu after remove all ]

        array_label MENU_STATE, MENU_STATE::EQUIP_EMPTY_RETURN
@1c26:  jsr     _c31bbd
        jsr     EquipRemoveAll
        lda     #$02
        sta     z25
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [ menu state $38: party equipment overview (init) ]

        array_label MENU_STATE, MENU_STATE::PARTY_EQUIP_INIT
@1c32:  jsr     DisableInterrupts
        jsr     InitPartyEquipScrollHDMA
        jsr     DrawPartyEquipMenu
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #MENU_STATE::PARTY_EQUIP
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $0b: status (init) ]

        array_label MENU_STATE, MENU_STATE::STATUS_INIT
@1c46:  jsr     DisableInterrupts
        jsr     InitStatusBG3ScrollHDMA
        jsr     DrawStatusMenu
        jsr     InitStatusCursor
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #MENU_STATE::STATUS_WAIT
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ init cursor for status menu ]

InitStatusCursor:
@1c5d:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x
        lda     0,y
        cmp     #CHAR_PROP::GOGO
        bne     @1c78                   ; branch if not Gogo
        jsr     LoadGogoStatusCursor
        jsr     InitGogoStatusCursor
        lda     #$06
        tsb     z46
        jmp     CreateCursorTask

; not Gogo
@1c78:  lda     #$06                    ; no cursor
        trb     z46
        rts

; ------------------------------------------------------------------------------

; [ menu state $0d: config (init) ]

        array_label MENU_STATE, MENU_STATE::CONFIG_INIT
@1c7d:  jsr     DisableInterrupts
        stz     z4a         ; set page to 0
        jsr     InitWindow2PosHDMA
        jsr     DrawConfigMenu
        jsr     LoadConfigPage1Cursor
        lda     z5f         ; restore cursor position
        sta     z4e
        jsr     InitConfigPage1Cursor
        jsr     CreateCursorTask
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #MENU_STATE::CONFIG_SELECT
        sta     zNextMenuState         ; config menu state
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $13: save select (init) ]

        array_label MENU_STATE, MENU_STATE::SAVE_INIT
@1ca0:  jsr     DisableInterrupts
        ldy     #2
        sty     zBG1VScroll
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #BIT_0 | BIT_1 | BIT_5 | BIT_6 | BIT_7
        trb     zEnableHDMA         ; disable hdma 2, 3, 4
        jsr     DrawGameSaveMenu
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadGameSaveCursor
        ldy     z91
        bne     @1cc7
        ldy     z93
        bne     @1cc7
        ldy     z95
        beq     @1ccd
@1cc7:  lda     rSelSaveSlot
        dec
        sta     z4e         ; set cursor position
@1ccd:  jsr     InitGameSaveCursor
        jsr     CreateCursorTask
        lda     z4b
        inc
        sta     zSelSaveSlot
        lda     #MENU_STATE::SAVE_FADE_IN
        sta     zMenuState
        lda     #MENU_STATE::SAVE_SELECT
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $15: save confirm (init) ]

        array_label MENU_STATE, MENU_STATE::SAVE_CONFIRM_INIT
@1ce3:  jsr     DisableInterrupts
        jsr     InitCharProp
        jsr     DrawGameSaveConfirmMenu
        jsr     LoadSaveConfirmCursor
        jsr     InitSaveConfirmCursor
        jsr     CreateCursorTask
        jsr     _c318d1
        lda     #MENU_STATE::SAVE_CONFIRM_SELECT
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $20: restore game (init) ]

        array_label MENU_STATE, MENU_STATE::LOAD_INIT
@1d03:  jsr     DisableInterrupts
        ldy     #$0002
        sty     zBG1VScroll
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #BIT_0 | BIT_1 | BIT_5 | BIT_6 | BIT_7
        trb     zEnableHDMA
        ldy     zZero
        sty     zBG1HScroll
        sty     zBG2HScroll
        sty     zBG3HScroll
        lda     #$02
        sta     z46
        jsr     DrawGameLoadMenu
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadGameLoadCursor
        ldy     z91
        bne     @1d36       ; branch if slot 1 is valid
        ldy     z93
        bne     @1d36       ; branch if slot 2 is valid
        ldy     z95
        beq     @1d3c       ; branch if slot 3 is not valid
@1d36:  lda     $307ff0     ; most recently saved slot
        sta     z4e         ; set current position
@1d3c:  jsr     InitGameLoadCursor
        jsr     CreateCursorTask
        lda     z4b
        sta     zSelSaveSlot
        lda     #MENU_STATE::LOAD_SELECT
        sta     zNextMenuState
        lda     #MENU_STATE::SAVE_FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $22: restore confirm (init) ]

        array_label MENU_STATE, MENU_STATE::LOAD_CONFIRM_INIT
@1d51:  jsr     DisableInterrupts
        jsr     InitCharProp
        jsr     DrawGameLoadConfirmMenu
        jsr     LoadSaveConfirmCursor
        jsr     InitSaveConfirmCursor
        jsr     CreateCursorTask
        jsr     _c318d1
        lda     #MENU_STATE::LOAD_CONFIRM
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $00: fade out (init) ]

        array_label MENU_STATE, MENU_STATE::FADE_OUT
@1d71:  jsr     CreateFadeOutTask
        ldy     #8                      ; set wait counter
        sty     zWaitCounter
        lda     #MENU_STATE::WAIT_FADE
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ menu state $01: fade in (init) ]

        array_label MENU_STATE, MENU_STATE::FADE_IN
@1d7e:  jsr     CreateFadeInTask
        ldy     #8                      ; set wait counter
        sty     zWaitCounter
        lda     #MENU_STATE::WAIT_FADE
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ menu state $02: wait for fade ]

        array_label MENU_STATE, MENU_STATE::WAIT_FADE
@1d8b:  ldy     zWaitCounter         ; return if frame counter is not 0
        bne     @1d93
        lda     zNextMenuState         ; go to next menu state
        sta     zMenuState
@1d93:  rts

; ------------------------------------------------------------------------------

; [ menu state $03: main menu re-init (from char select) ]

        array_label MENU_STATE, MENU_STATE::FIELD_MENU_RETURN
@1d94:  lda     #0                      ; priority 0
        ldy     #near MainMenuCursorTask
        jsr     CreateTask
        jsr     CreateCursorTask
        lda     #MENU_STATE::FIELD_MENU_SELECT
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ menu state $05: main menu ]

        array_label MENU_STATE, MENU_STATE::FIELD_MENU_SELECT
@1da4:  jsr     UpdateTimeText

; A button
        lda     zNewCtrlState_L
        bit     #JOY_A
        jne     SelectMainMenuOption

; left button
        lda     zNewCtrlState_H
        bit     #>JOY_LEFT
        beq     @1dbc       ; branch if left button is not pressed
        jsr     PlayMoveSfx
        jmp     MainMenuLeftBtn

; B button
@1dbc:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @1dd1       ; return if b button is not pressed
        stz     r0205
        jsr     PlayCancelSfx
        jsr     UpdateEquipAfterMenu
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
@1dd1:  rts

; ------------------------------------------------------------------------------

; [ update field equipment effects ]

UpdateEquipAfterMenu:
@1dd2:  stz     $11df       ; clear all field equipment effects
        ldx     zZero
@1dd7:  lda     zCharID,x       ; character in each party slot
        bmi     @1de1
        phx
        jsl     UpdateEquip_ext
        plx
@1de1:  inx                 ; next character slot
        cpx     #4
        bne     @1dd7
        rts

; ------------------------------------------------------------------------------

; [ menu state $06: main menu (select character) ]

        array_label MENU_STATE, MENU_STATE::FIELD_MENU_CHAR
@1de8:  jsr     UpdateTimeText

; B button
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @1dfd       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        lda     #$05
        trb     z46         ; disable cursor 2 and flashing cursor
        lda     #MENU_STATE::FIELD_MENU_RETURN
        sta     zMenuState
        rts

; left button
@1dfd:  lda     zNewCtrlState_H         ; branch if left button is not pressed
        bit     #>JOY_LEFT
        beq     @1e1f
        lda     z25         ; branch if not equip or relic
        cmp     #$02
        beq     @1e0d
        cmp     #$03
        bne     @1e1f
@1e0d:  jsr     PlayMoveSfx
        lda     #$06
        trb     z46         ; disable cursor 1 and 2
        lda     #MENU_STATE::FIELD_PARTY_SELECT
        sta     zMenuState         ; set menu state to $37 (select all)
        lda     z4e         ; save cursor position
        sta     z5e
        jmp     CreateMultiCursorTask

; A button
@1e1f:  lda     zNewCtrlState_L         ; return if a button is not pressed
        bit     #JOY_A
        beq     @1e2c
        lda     z4b         ; cursor selection
        sta     zSelIndex         ; set selected character slot
        jmp     _c31e2d
@1e2c:  rts

; ------------------------------------------------------------------------------

; [  ]

_c31e2d:
@1e2d:  jsr     CheckSkillValid
        bcs     @1e42       ; branch if not
        clr_a
        lda     z25         ; main menu selection
        tax
        lda     f:_c31e49,x   ; init menu state
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        jsr     PlaySelectSfx
        rts
@1e42:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; init menu states for main menu commands
_c31e49:
        .byte   MENU_STATE::TERMINATE
        .byte   MENU_STATE::SKILLS_INIT
        .byte   MENU_STATE::EQUIP_INIT
        .byte   MENU_STATE::RELIC_INIT
        .byte   MENU_STATE::STATUS_INIT

; ------------------------------------------------------------------------------

; [ check if character slot is valid (skills/equip/relic/status) ]

; carry clear = valid
; carry set = invalid

CheckSkillValid:
@1e4e:  clr_a
        lda     z25         ; main menu selection
        cmp     #$01
        beq     @1e89       ; branch if skills
        cmp     #$02
        beq     @1e5f       ; branch if equip
        cmp     #$03
        beq     @1e74       ; branch if relic
        bra     @1eb3       ; branch if status (always valid)

; equip
@1e5f:  clr_a
        lda     zSelIndex
        asl
        tax
        longa
        lda     zCharPropPtr,x
        shorta
        tax
        lda     a:0,x     ; not valid for characters $0d (umaro) and higher
        cmp     #CHAR_PROP::UMARO
        bcs     @1eb1
        bra     @1e9c

; relic
@1e74:  clr_a
        lda     zSelIndex
        asl
        tax
        longa
        lda     zCharPropPtr,x
        shorta
        tax
        lda     a:0,x     ; not valid for characters $0e and higher
        cmp     #CHAR_PROP::BANON
        bcs     @1eb1
        bra     @1e9c

; skills
@1e89:  jsr     UpdateSkillsTextColor
        lda     #$24
        ldx     zZero
@1e90:  cmp     zSkillsTextColor,x       ; branch if at least one is not disabled
        bne     @1e9c
        inx
        cpx     #$0007
        bne     @1e90
        bra     @1eb1

; check status
@1e9c:  clr_a
        lda     zSelIndex
        asl
        tax
        longa
        lda     zCharPropPtr,x
        shorta
        tax
        lda     a:$0014,x     ; not valid if wound, petrify, or zombie status
        andflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @1eb1
        bra     @1eb3

; invalid
@1eb1:  sec
        rts

; valid
@1eb3:  clc
        rts

; ------------------------------------------------------------------------------

; [ menu state $37: main menu (select all for equip/relic) ]

        array_label MENU_STATE, MENU_STATE::FIELD_PARTY_SELECT
@1eb5:  jsr     UpdateTimeText
        lda     zNewCtrlState_H
        bit     #>JOY_B
        bne     @1ec4       ; branch if b button is down
        lda     zNewCtrlState_H
        bit     #>JOY_RIGHT
        beq     @1ee5       ; branch if right button is not down

; B button or right button
@1ec4:  jsr     PlayCancelSfx
        jsr     InitCharSelectCursor
        jsr     CreateCursorTask
        lda     #0
        ldy     #near CharSelectCursorTask
        jsr     CreateTask
        jsr     ExecTasks
        lda     z5e         ; restore cursor position
        sta     z4e
        lda     #MENU_STATE::FIELD_MENU_CHAR
        sta     zMenuState
        lda     #$08        ; disable multi-cursor
        trb     z46
        rts

; A button
@1ee5:  lda     zNewCtrlState_L         ; return if a button is not down
        bit     #JOY_A
        beq     @1ef5
        jsr     PlaySelectSfx
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        lda     #MENU_STATE::PARTY_EQUIP_INIT
        sta     zNextMenuState
        rts
@1ef5:  rts

; ------------------------------------------------------------------------------

; [ menu state $08: item (select) ]

.proc MenuState_08_proc

_1ef6:  rts

        array_label MENU_STATE, MENU_STATE::ITEM_SELECT
_1ef7:  lda     #$10
        trb     z45
        clr_a
        sta     zListType
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     _1ef6
        jsr     UpdateItemListCursor
        jsr     InitItemDesc

; B button
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     _1f3b
        jsr     PlayCancelSfx
        ldy     z4f
        sty     r022f
        lda     z4a
        sta     r0231
        jsr     LoadItemOptionCursor
        lda     $1d4e
        and     #$40
        beq     _1f2c
        ldy     r0234
        sty     z4d

::GotoItemOption:
_1f2c:  jsr     InitItemOptionCursor
        lda     #MENU_STATE::ITEM_OPTIONS
        sta     zMenuState
        jsr     ClearItemCount
        jmp     InitDMA1BG3ScreenA

; A button
_1f3b:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     _1f4f
        jsr     PlaySelectSfx
        lda     z4b
        sta     zSelIndex
        lda     #MENU_STATE::ITEM_MOVE
        sta     zMenuState
        jmp     _c32f21

_1f4f:  rts

.endproc

; ------------------------------------------------------------------------------

; [ scroll list text up/down one page ]

.scope ScrollListPage

; (branch from c3/1f9b)
_1f50:  stz     z50
        stz     z4e
        sec
        rts

; (branch from c3/1f72)
_1f56:  lda     z54
        dec
        sta     z4e
        clc
        adc     z4a
        sta     z50
        sec
        rts

; waiting (branch from c3/1f66)
_1f62:  clc
        rts

::ScrollListPage:
_1f64:  lda     zWaitCounter
        bne     _1f62                   ; branch if wait frame counter not zero

; R button
        lda     zRepCtrlState_L
        bit     #JOY_R
        beq     _1f93                   ; branch if R button is not pressed
        lda     z4a
        cmp     z5c
        beq     _1f56
        lda     z5c
        sec
        sbc     z4a
        cmp     z5a
        bcs     _1f7f
        bra     _1f81
_1f7f:  lda     z5a
_1f81:  sta     ze0
        lda     z4a
        clc
        adc     ze0
        sta     z4a
        lda     z50
        clc
        adc     ze0
        sta     z50
        bra     _1fb7

; L button
_1f93:  lda     zRepCtrlState_L
        bit     #JOY_L
        beq     _1f62                   ; branch if L button is not pressed
        lda     z4a
        beq     _1f50                   ; branch if at the top of the list
        cmp     z5a
        bcs     _1fa5
        lda     z4a
        bra     _1fa7
_1fa5:  lda     z5a
_1fa7:  sta     ze0
        lda     z4a
        sec
        sbc     ze0
        sta     z4a
        lda     z50
        sec
        sbc     ze0
        sta     z50
_1fb7:  jsr     PlayMoveSfx
        clr_a
        lda     zListType
        asl
        tax
        jsr     (near ScrollListPageTbl,x)
        sec
        rts

.endscope  ; ScrollListPage

; ------------------------------------------------------------------------------

; jump table for list type
ScrollListPageTbl:
        ptr_tbl SCROLL_LIST_PAGE

; ------------------------------------------------------------------------------

; 0: item list
        array_label SCROLL_LIST_PAGE, LIST_TYPE::ITEM
@1fd0:  jsr     LoadItemBG1VScrollHDMATbl
        jmp     DrawItemList

; ------------------------------------------------------------------------------

; 1: magic
        array_label SCROLL_LIST_PAGE, LIST_TYPE::MAGIC
@1fd6:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawMagicList

; ------------------------------------------------------------------------------

; 2: lore
        array_label SCROLL_LIST_PAGE, LIST_TYPE::LORE
@1fdc:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawLoreList

; ------------------------------------------------------------------------------

; 3: rage
        array_label SCROLL_LIST_PAGE, LIST_TYPE::RAGE
@1fe2:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawRageList

; ------------------------------------------------------------------------------

; 4: esper
        array_label SCROLL_LIST_PAGE, LIST_TYPE::GENJU
@1fe8:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawGenjuList

; ------------------------------------------------------------------------------

; 5: equip/relic item list
        array_label SCROLL_LIST_PAGE, LIST_TYPE::EQUIP
@1fee:  jsr     LoadEquipBG1VScrollHDMATbl
        jmp     DrawEquipItemList

; ------------------------------------------------------------------------------

; [ menu state $0a: skills (select option) ]

        array_label MENU_STATE, MENU_STATE::SKILLS_SELECT
@1ff4:  lda     #$10        ;
        tsb     z45
        lda     #$c0        ; page can't scroll up or down
        trb     z46
        jsr     UpdateSkillsCursor

; return to main menu (b button)
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @200f       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts

; open selected skills menu (a button)
@200f:  lda     zNewCtrlState_L         ; branch if a button is not pressed
        bit     #JOY_A
        beq     @201c
        lda     z4e
        sta     z5e
        jmp     SelectSkillsOption

; go to next character (top r button)
@201c:  lda     #MENU_STATE::SKILLS_INIT
        sta     ze0
        bra     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ check r & l shoulder buttons ]

; $e0: menu state to go to if user pressed top R or L

CheckShoulderBtns:
.if LANG_EN
@2022:  lda     zMosaic
        and     #$f0
        bne     @2089       ; return if mosaic'ing
.endif

; go to next character (top R button)
        lda     zNewCtrlState_L
        bit     #JOY_R
        beq     @2059
        lda     z25
        cmp     #$03
        bne     @203f
        jsr     CheckReequip
        lda     z99
        beq     @203f
        jsr     PlayMoveSfx
        rts
@203f:  clr_a
        lda     zSelIndex                     ; increment selected character slot
        inc
        and     #$03
        sta     zSelIndex
        tax
        lda     zCharID,x
        bmi     @203f
        jsr     CheckSkillValid
        bcs     @203f
        lda     ze0
        sta     zMenuState
        jsr     PlayMoveSfx
        rts

; go to previous character (top L button)
@2059:  lda     zNewCtrlState_L
        bit     #JOY_L
        beq     @2089
        lda     z25
        cmp     #$03
        bne     @2070
        jsr     CheckReequip
        lda     z99
        beq     @2070
        jsr     PlayMoveSfx
        rts
@2070:  clr_a
        lda     zSelIndex                     ; decrement selected character slot
        dec
        and     #$03
        sta     zSelIndex
        tax
        lda     zCharID,x
        bmi     @2070
        jsr     CheckSkillValid
        bcs     @2070
        lda     ze0
        sta     zMenuState
        jsr     PlayMoveSfx
@2089:  rts

; ------------------------------------------------------------------------------

; [ open selected skills menu (A button) ]

.proc SelectSkillsOption

@208a:  clr_a
        lda     z4b                     ; current selection
        tax
        lda     zSkillsTextColor,x                   ; branch if not enabled
        cmp     #$20
        bne     @209e
        jsr     PlaySelectSfx
        lda     z4b
        asl
        tax
        jmp     (near SelectSkillsOptionTbl,x)

; invalid selection
@209e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

.endproc  ; SelectSkillsOption

; ------------------------------------------------------------------------------

.enum SELECT_SKILLS_OPTION
        GENJU
        MAGIC
        BUSHIDO
        BLITZ
        LORE
        RAGE
        DANCE

        COUNT
.endenum

; skills menu jump table (espers, magic, swdtech, blitz, lore, rage, dance)
SelectSkillsOptionTbl:
        ptr_tbl SELECT_SKILLS_OPTION

; ------------------------------------------------------------------------------

; [ skills menu $00: espers (init) ]

        array_label SELECT_SKILLS_OPTION, SELECT_SKILLS_OPTION::GENJU
@20b3:  stz     z4a
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$1000
        sta     wTaskProp::SpeedY_H,x
        lda     #$0068
        sta     wTaskProp::SpeedX_H,x
        shorta
        jsr     LoadGenjuCursor
        jsr     InitGenjuCursor
        lda     #$06                    ; max page scroll position = 6
        sta     z5c
        lda     #$08
.else
        lda     #$1333
        sta     wTaskProp::SpeedY_H,x
        lda     #$0060
        sta     wTaskProp::SpeedX_H,x
        shorta
        jsr     LoadGenjuCursor
        jsr     InitGenjuCursor
        lda     #$05                    ; max page scroll position = 5
        sta     z5c
        lda     #$09
.endif
        sta     z5a
        lda     #$02
        sta     z5b
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jsr     DrawGenjuMenu
        lda     #MENU_STATE::SKILLS_GENJU_SELECT
        sta     zMenuState
        jsr     _c32eeb
        rts

; ------------------------------------------------------------------------------

; [ skills menu $02: swdtech (init) ]

        array_label SELECT_SKILLS_OPTION, SELECT_SKILLS_OPTION::BUSHIDO
@20ee:  stz     z4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jsr     _c352d7
        lda     #MENU_STATE::SKILLS_BUSHIDO
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ skills menu $03: blitz (init) ]

        array_label SELECT_SKILLS_OPTION, SELECT_SKILLS_OPTION::BLITZ
@2105:  stz     z4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jsr     DrawBlitzMenu
        lda     #MENU_STATE::SKILLS_BLITZ
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ skills menu $01: magic (init) ]

        array_label SELECT_SKILLS_OPTION, SELECT_SKILLS_OPTION::MAGIC
@211c:  jsr     _c32130
        jsr     _c32148
        jsr     InitMagicMenu
        jsr     DrawListMPCost
        jsr     InitDMA1BG3ScreenB
        lda     #MENU_STATE::SKILLS_MAGIC
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32130:
@2130:  stz     z4a
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$050d
        sta     wTaskProp::SpeedY_H,x
        lda     #$0068
.else
        lda     #$08ba
        sta     wTaskProp::SpeedY_H,x
        lda     #$0060
.endif
        sta     wTaskProp::SpeedX_H,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32148:
@2148:  jsr     LoadMagicCursor
        lda     $1d4e
        and     #$40
        beq     @2155
        jsr     RestoreMagicCursorPos
@2155:  jmp     InitMagicCursor

; ------------------------------------------------------------------------------

; [ init magic menu ]

InitMagicMenu:
.if LANG_EN
@2158:  lda     #$13
        sta     z5c
        lda     #$08
        sta     z5a
        lda     #$02
.else
        lda     #$0b
        sta     z5c
        lda     #$09
        sta     z5a
        lda     #$03
.endif
        sta     z5b
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jmp     DrawMagicMenu

; ------------------------------------------------------------------------------

; [ skills menu $04: lore (init) ]

        array_label SELECT_SKILLS_OPTION, SELECT_SKILLS_OPTION::LORE
@216e:  stz     z4a
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$0600
        sta     wTaskProp::SpeedY_H,x
        lda     #$0068
        sta     wTaskProp::SpeedX_H,x
        shorta
        jsr     LoadLoreCursor
        jsr     InitLoreCursor
        lda     #$10
        sta     z5c
        lda     #$08
        sta     z5a
        lda     #$01
.else
        lda     #$2000
        sta     wTaskProp::SpeedY_H,x
        lda     #$0060
        sta     wTaskProp::SpeedX_H,x
        shorta
        jsr     LoadLoreCursor
        jsr     InitLoreCursor
        lda     #$03
        sta     z5c
        lda     #$09
        sta     z5a
        lda     #$02
.endif
        sta     z5b
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jsr     InitLoreList
        lda     #MENU_STATE::SKILLS_LORE
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ skills menu $05: rage (init) ]

        array_label SELECT_SKILLS_OPTION, SELECT_SKILLS_OPTION::RAGE
@21a6:  stz     z4a
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$00cc
        sta     wTaskProp::SpeedY_H,x
        lda     #$0068
        sta     wTaskProp::SpeedX_H,x
        shorta
        jsr     LoadRageCursor
        jsr     InitRageCursor
        lda     #$78
        sta     z5c
        lda     #$08
.else
        lda     #$00ce
        sta     wTaskProp::SpeedY_H,x
        lda     #$0060
        sta     wTaskProp::SpeedX_H,x
        shorta
        jsr     LoadRageCursor
        jsr     InitRageCursor
        lda     #$77
        sta     z5c
        lda     #$09
.endif
        sta     z5a
        lda     #$02
        sta     z5b
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jsr     InitRageList
        lda     #MENU_STATE::SKILLS_RAGE
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ skills menu $06: dance (init) ]

        array_label SELECT_SKILLS_OPTION, SELECT_SKILLS_OPTION::DANCE
@21de:  stz     z4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jsr     DrawDanceMenu
        lda     #MENU_STATE::SKILLS_DANCE
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ menu state $0c: status ]

        array_label MENU_STATE, MENU_STATE::STATUS_WAIT
@21f5:  jsr     InitDMA1BG3ScreenA

; shoulder R button
        lda     zNewCtrlState_L
        bit     #JOY_R
        beq     @221e
        lda     zSelIndex
        sta     zSkillsTextColor
@2202:  clr_a
        lda     zSelIndex
        inc
        and     #%11
        sta     zSelIndex
        tax
        lda     zCharID,x
        bmi     @2202
        lda     zSelIndex
        cmp     zSkillsTextColor
        beq     @2218
        jsr     PlayMoveSfx
@2218:  jsr     InitStatusCursor
        jmp     _c35d83

; shoulder L button
@221e:  lda     zNewCtrlState_L
        bit     #JOY_L
        beq     @2244
        lda     zSelIndex
        sta     zSkillsTextColor
@2228:  clr_a
        lda     zSelIndex
        dec
        and     #$03
        sta     zSelIndex
        tax
        lda     zCharID,x
        bmi     @2228
        lda     zSelIndex
        cmp     zSkillsTextColor
        beq     @223e
        jsr     PlayMoveSfx
@223e:  jsr     InitStatusCursor
        jmp     _c35d83

; B button
@2244:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2254
        jsr     PlayCancelSfx
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts
@2254:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x
        lda     0,y
        cmp     #CHAR_PROP::GOGO
        bne     @22b3                   ; return if not Gogo
        jsr     UpdateGogoStatusCursor

; A button
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @22b3
        jsr     PlaySelectSfx
        lda     z4b
        sta     ze7
        stz     ze8
        clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x
        longa
        tya
        clc
        adc     ze7
        tay
        shorta
        lda     $0016,y
        cmp     #BATTLE_CMD::MIMIC
        beq     @22b3
        jsr     _c32f06
        lda     z4e
        sta     z5e
        lda     z4b
        sta     z64
        lda     #6
        sta     zWaitCounter
        ldy     #12
        sty     zMenuScrollRate
        lda     #MENU_STATE::STATUS_GOGO
        sta     zNextMenuState
        lda     #MENU_STATE::H_SCROLL
        sta     zMenuState
        jsr     LoadGogoCmdListCursor
        lda     $7e9d89
        sta     z54
        jmp     InitGogoCmdListCursor
@22b3:  rts

; ------------------------------------------------------------------------------

; [ menu state $6b: unused ]

        array_label MENU_STATE, MENU_STATE::MENU_STATE_6B
@22b4:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @22c4
        jsr     PlayCancelSfx
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts
@22c4:  rts

; ------------------------------------------------------------------------------

; [ menu state $0e: config ]

        array_label MENU_STATE, MENU_STATE::CONFIG_SELECT
@22c5:  jsr     InitDMA1BG1ScreenAB
        lda     zRepCtrlState_H
        bit     #>JOY_DOWN
        beq     @22e0
        lda     z4e
.if LANG_EN
        cmp     #$08
.else
        cmp     #$09
.endif
        bne     @22e0
        lda     #MENU_STATE::CONFIG_SCROLL_DOWN
        sta     zMenuState
        lda     #$11
        sta     zWaitCounter
        jsr     PlayMoveSfx
        rts
@22e0:  lda     zRepCtrlState_H
        bit     #>JOY_UP
        beq     @22fa
        lda     z4e
        bne     @22fa
        lda     z4a
        beq     @22fa
        lda     #MENU_STATE::CONFIG_SCROLL_UP
        sta     zMenuState
        lda     #$11
        sta     zWaitCounter
        jsr     PlayMoveSfx
        rts
@22fa:  lda     z4a
        beq     @2303
        jsr     UpdateConfigPage2Cursor
        bra     @2306
@2303:  jsr     UpdateConfigPage1Cursor

; B button
@2306:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2316
        jsr     PlayCancelSfx
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts

; left or right button
@2316:  lda     zRepCtrlState_H
        bit     #>JOY_RIGHT
        bne     @2322
        lda     zRepCtrlState_H
        bit     #>JOY_LEFT
        beq     @2325
@2322:  jmp     ChangeConfigOption

; A button
@2325:  lda     zNewCtrlState_L
        bit     #JOY_A
        jne     SelectConfigOption
        jmp     ScrollConfigPage

; ------------------------------------------------------------------------------

; [ select config option ]

SelectConfigOption:
@2331:  lda     z4e
        sta     z5f
        lda     z4a
        bne     SelectConfigOptionPage2

; page 1
        clr_a
        lda     z4b
        asl
        tax
        jmp     (near SelectConfigOptionTbl1,x)

; ------------------------------------------------------------------------------

; config options that can't be selected
SelectConfigOptionReturn:
@2341:  rts

; ------------------------------------------------------------------------------

SelectConfigOptionPage2:
@2342:  clr_a
        lda     z4b
        asl
        tax
        jmp     (near SelectConfigOptionTbl2,x)

; ------------------------------------------------------------------------------

; config option jump table (page 1)
SelectConfigOptionTbl1:
@234a:  .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOption_03
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
.if !LANG_EN
        .addr   SelectConfigOption_08j
.endif
        .addr   SelectConfigOption_08

; config option jump table (page 2)
SelectConfigOptionTbl2:
@235c:  .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOption_0b
        .addr   SelectConfigOption_0c
        .addr   SelectConfigOption_0d
        .addr   SelectConfigOption_0e

; ------------------------------------------------------------------------------

; [ open custom battle command menu ]

SelectConfigOption_03:
@2368:  lda     $1d4d
        bit     #$80
        beq     SelectConfigOptionReturn
        jsr     PlaySelectSfx
        lda     #MENU_STATE::CMD_ARRANGE_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts

; ------------------------------------------------------------------------------

.if !LANG_EN

; [  ]

SelectConfigOption_08j:
@2379:  lda     $1d54
        bit     #$40
        beq     SelectConfigOptionReturn
        jsr     PlaySelectSfx
        lda     #MENU_STATE::CTRL_CONFIG_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts

.endif

; ------------------------------------------------------------------------------

; [ open character controller select menu ]

SelectConfigOption_08:
@2379:  lda     $1d54
        bpl     SelectConfigOptionReturn
        jsr     PlaySelectSfx
        lda     #MENU_STATE::CHAR_CTRL_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts

; ------------------------------------------------------------------------------

; [ revert font color or window color component to default ]

SelectConfigOption_0b:
SelectConfigOption_0c:
SelectConfigOption_0d:
SelectConfigOption_0e:
@2388:  jsr     PlaySelectSfx
        lda     $1d54
        and     #$38
        beq     @239b

; window color
        jsr     RevertWindowPal
        jsr     LoadWindowGfx
        jmp     UpdateConfigColorBars

; font color
@239b:  ldy     #$7fff                  ; revert font color to default
        sty     $1d55
        jsr     InitFontColor
        jmp     UpdateConfigColorBars

; ------------------------------------------------------------------------------

; [ revert window palette to default ]

RevertWindowPal:
@23a7:  clr_a
        lda     $1d4e                   ; window index
        and     #$0f

; calculate pointers to window palette in rom and sram
        longa
        tay
        stz     zeb
        stz     zed
@23b4:  dey
        bmi     @23c9
        lda     #14                     ; palettes are 7 colors in SRAM
        clc
        adc     zeb
        sta     zeb
        lda     #$0020                  ; palettes are 16 colors in ROM
        clc
        adc     zed
        sta     zed
        bra     @23b4

; copy default palette to SRAM and WRAM
@23c9:  ldx     #$312b
        stx     hWMADDL
        lda     zeb
        tay
        lda     zed
        tax
        shorta
        lda     #14                     ; copy 14 bytes (7 colors)
        sta     ze9
@23db:  lda     f:WindowPal+2,x
        sta     $1d57,y
        sta     hWMDATA
        inx
        iny
        dec     ze9
        bne     @23db
        rts

; ------------------------------------------------------------------------------

; [ config menu page scroll ]

ScrollConfigPage:
@23ec:  lda     zNewCtrlState_L                     ; check L and R buttons
        bit     #JOY_R
        bne     @23f6
        bit     #JOY_L
        beq     @240b
@23f6:  jsr     PlayMoveSfx
        stz     z5f
        lda     z4a
        bne     @2406
        lda     #1
        sta     z4a
        jmp     ShowConfigPage2
@2406:  stz     z4a
        jsr     ShowConfigPage1
@240b:  rts

; ------------------------------------------------------------------------------

; [ menu state $0f: order (select character) ]

        array_label MENU_STATE, MENU_STATE::ORDER_SELECT
@240c:  jsr     UpdateTimeText
        jsr     _c36989
        lda     zNewCtrlState_H
        bit     #>JOY_B
        bne     @241e
        lda     zNewCtrlState_H
        bit     #>JOY_RIGHT
        beq     @2437
@241e:  jsr     PlayCancelSfx
        lda     #6
        sta     zWaitCounter
        ldy     #12
        sty     zMenuScrollRate
        lda     #$05
        trb     z46
        lda     #MENU_STATE::FIELD_MENU_RETURN
        sta     zNextMenuState
        lda     #MENU_STATE::H_SCROLL
        sta     zMenuState
        rts
@2437:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @2452
        jsr     PlaySelectSfx
        lda     z4b
        sta     zSelIndex
        lda     #MENU_STATE::ORDER_MOVE
        sta     zMenuState
        jsr     _c32f21
        jsr     LoadCharSelectCursorProp
        lda     z4e
        sta     z5e
@2452:  rts

; ------------------------------------------------------------------------------

; [ menu state $10: order (move/row) ]

        array_label MENU_STATE, MENU_STATE::ORDER_MOVE
@2453:  jsr     UpdateTimeText
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @246f       ; branch if b button is not pressed

; cancel
        jsr     PlayCancelSfx
        lda     #$01
        trb     z46                     ; disable flashing cursor task
        lda     #MENU_STATE::ORDER_SELECT
        sta     zMenuState
        jsr     InitCharSelectCursor
        lda     z5e
        sta     z4e                     ; restore cursor position
        rts

; no cancel
@246f:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @24a8                   ; return if a button is not pressed
        jsr     PlaySelectSfx
        lda     zSelIndex
        cmp     z4b
        bne     @2491                   ; branch if order changed

; character row changed
        lda     #$01
        trb     z46                     ; disable flashing cursor task
        lda     #MENU_STATE::ORDER_ROW
        sta     zMenuState
        jsr     _c32e10
        ldy     #12
        sty     zWaitCounter            ; wait 12 frames
        jmp     InitCharSelectCursor

; party order changed
@2491:  lda     #$10
        trb     z46
        lda     #$0c
        trb     z45
        jsr     CreateCharSwapTask
        lda     #$18        ; set frame counter to 24 (12 frames to hide, 12 frames to show)
        sta     z22
        lda     #$01
        trb     z46
        lda     #MENU_STATE::ORDER_SWAP
        sta     zMenuState
@24a8:  rts

; ------------------------------------------------------------------------------

; [ menu state $11: change party order ]

        array_label MENU_STATE, MENU_STATE::ORDER_SWAP
@24a9:  jsr     UpdateTimeText
        lda     z22
        beq     @24e0
        cmp     #$0c
        bne     @24ed
        jsr     UpdatePlayer2Chars
        jsr     _c32dd1
        jsr     _c324ee
        jsr     ClearBG1ScreenA
        jsr     DrawCharBlock1
        jsr     DrawCharBlock2
        jsr     DrawCharBlock3
        jsr     DrawCharBlock4
        jsr     SwapSavedCharCursorPos
        jsr     InitDMA1BG1ScreenA
        jsr     InitCharSelectCursor
        jsr     ExecTasks
        jsr     WaitVblank
        lda     #$08
        tsb     z45
        rts
@24e0:  lda     #MENU_STATE::ORDER_SELECT
        sta     zMenuState
        lda     #$10
        tsb     z46
        lda     #$04
        tsb     z45
        rts
@24ed:  rts

; ------------------------------------------------------------------------------

; [ terminate portrait and status icon tasks ]

_c324ee:
@24ee:  jsr     _c32e3c
        lda     #$01                    ; terminate group 1 sprite tasks
        trb     z47
        jmp     ExecTasks

; ------------------------------------------------------------------------------

; [ update characters controlled by player 2 ]

UpdatePlayer2Chars:
@24f8:  clr_ax
        stx     ze0
        stx     ze2
        lda     $1d4f
        clc
@2502:  ror
        bcc     @2507
        inc     ze0,x
@2507:  inx
        cpx     #$0004
        bne     @2502
        clr_a
        lda     z4b
        tax
        lda     ze0,x
        sta     ze5
        lda     zSelIndex
        tax
        lda     ze0,x
        sta     ze6
        lda     ze5
        sta     ze0,x
        lda     z4b
        tax
        lda     ze6
        sta     ze0,x
        clc
        lda     ze3
        asl
        adc     ze2
        asl
        adc     ze1
        asl
        adc     ze0
        sta     $1d4f
        rts

; ------------------------------------------------------------------------------

; [ menu state $12: order (wait for portrait slide) ]

        array_label MENU_STATE, MENU_STATE::ORDER_ROW
@2537:  ldy     zWaitCounter
        bne     @253f
        lda     #MENU_STATE::ORDER_SELECT
        sta     zMenuState
@253f:  rts

; ------------------------------------------------------------------------------

; [ menu state $14: save select ]

        array_label MENU_STATE, MENU_STATE::SAVE_SELECT
@2540:  lda     z4b
        inc
        sta     zSelSaveSlot
        jsr     DrawSaveMenuChars
        jsr     UpdateGameSaveCursor

; B button
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @255d                   ; branch if B button is not pressed
        jsr     PlayCancelSfx
        lda     z9f
        sta     zNextMenuState
        lda     #MENU_STATE::SAVE_FADE_OUT
        sta     zMenuState
        rts

; A button
@255d:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @259c                   ; return if A button is not pressed
        clr_a
        lda     z4b
        asl
        tax
        ldy     z91,x                   ; sram checksum
        bne     @2580                   ; branch if sram is valid

; slot is empty, save instantly
        lda     zSelSaveSlot
        sta     rSaveSlotToLoad
        jsr     PlaySuccessSfx
        jsr     SaveGame
        lda     zPrevMenuState
        sta     zNextMenuState
        lda     #MENU_STATE::SAVE_FADE_OUT
        sta     zMenuState
        rts

; sram valid, prompt before overwriting
@2580:  jsr     PlaySelectSfx
        jsr     PushSRAM
        lda     z4b
        inc
        sta     zSelSaveSlot
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     _c36989
        lda     #MENU_STATE::SAVE_CONFIRM_INIT
        sta     zNextMenuState
        lda     #MENU_STATE::SAVE_FADE_OUT
        sta     zMenuState
@259c:  rts

; ------------------------------------------------------------------------------

; [ menu state $16 & $1f: save confirm ]

        array_label MENU_STATE, MENU_STATE::SAVE_CONFIRM_SELECT
        array_label MENU_STATE, MENU_STATE::UNUSED_1F
@259d:  jsr     UpdateSaveConfirmCursor
        lda     zNewCtrlState_H
        bit     #>JOY_B
        bne     @25c2       ; branch if b button is down
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @25de       ; return if a button is not pressed
        lda     z4b
        bne     @25c7
        lda     zSelSaveSlot
        sta     rSaveSlotToLoad
        jsr     PlaySuccessSfx
        jsr     SaveGame
        lda     zPrevMenuState
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts
@25c2:  jsr     PlayCancelSfx
        bra     @25ca
@25c7:  jsr     PlaySelectSfx
@25ca:  jsr     PopSRAM
        jsr     InitCharProp
        jsr     _c36989
        lda     #MENU_STATE::SAVE_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        lda     zSelSaveSlot
        sta     rSelSaveSlot
@25de:  rts

; ------------------------------------------------------------------------------

; [ save game ]

SaveGame:
@25df:  jsr     PopSRAM
        jsr     InitCharProp
        jsr     _c36989
        longa
        inc     $1dc7       ; increment the number of times the game has been saved
        shorta
        lda     zSelSaveSlot
        jmp     CopyGameDataToSRAM

; ------------------------------------------------------------------------------

; [ menu state $17: item options (use, arrange, rare) ]

        array_label MENU_STATE, MENU_STATE::ITEM_OPTIONS
@25f4:  lda     #$c0
        trb     z46
        lda     #$10
        tsb     z45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateItemOptionCursor

; B button
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2611
        jsr     PlayCancelSfx
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT

; A button
@2611:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @261d
        jsr     PlaySelectSfx
        jsr     SelectItemOption
@261d:  rts

; ------------------------------------------------------------------------------

; [ select an item option (use, arrange, rare) ]

SelectItemOption:
@261e:  clr_a
        lda     z4b
        asl
        tax
        jmp     (near SelectItemOptionTbl,x)

; ------------------------------------------------------------------------------

SelectItemOptionTbl:
@2626:  .addr   SelectItemOption_00
        .addr   SelectItemOption_01
        .addr   SelectItemOption_02

; ------------------------------------------------------------------------------

; [ select use items ]

SelectItemOption_00:
@262c:  jsr     LoadItemListCursor
        lda     $1d4e
        and     #$40
        beq     @263b
        jsr     RestoreItemCursorPos
        bra     @264b
@263b:  lda     r0231
        sta     z4a
        ldy     z4d
        sty     z4f
        lda     z4a
        clc
        adc     z50
        sta     z50
@264b:  jsr     InitItemListCursor
        jsr     InitItemListText
        jsr     InitItemDesc
        jsr     InitDMA1BG3ScreenA
        jsr     WaitVblank
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$0070
.else
        lda     #$00ea
.endif
        sta     wTaskProp::SpeedY_H,x
        lda     #$0058
        sta     wTaskProp::SpeedX_H,x
        shorta
        lda     #MENU_STATE::ITEM_SELECT
        sta     zMenuState
        lda     #0
        ldy     #near BigTextTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ arrange items ]

SelectItemOption_01:
@267c:  jsr     ClearBG1ScreenA
        jsr     _c326b8
        jsr     SortItemsByIcon
        jsr     DrawItemList
        jsr     LoadItemOptionCursor
        jmp     GotoItemOption

; ------------------------------------------------------------------------------

; [ select rare items ]

SelectItemOption_02:
@268e:  jsr     LoadRareItemCursor
        lda     $1d4e
        and     #$40
        beq     @269d
        ldy     r0232
        sty     z4d
@269d:  jsr     InitRareItemCursor
        jsr     InitRareItemList
        jsr     InitBigText
        jsr     InitRareItemDesc
        jsr     InitDMA1BG3ScreenA
        jsr     WaitVblank
        lda     #$c0
        trb     z46
        lda     #MENU_STATE::ITEM_RARE
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c326b8:
@26b8:  clr_ax
@26ba:  lda     $1869,x
        sta     $7eaa8d,x
        lda     #$ff
        sta     $1869,x
        inx
        cpx     #$0100
        bne     @26ba
        clr_ax
@26ce:  lda     $1969,x
        sta     $7eab8d,x
        clr_a
        sta     $1969,x
        inx
        cpx     #$0100
        bne     @26ce
        rts

; ------------------------------------------------------------------------------

; [ sort items by their icon ]

SortItemsByIcon:
@26e0:  clr_ayx
@26e3:  lda     f:ItemIconTbl,x
        phx
        sta     ze0
        jsr     FindItemsWithIcon
        plx
        inx
        cpx     #$0011
        bne     @26e3
        rts

; ------------------------------------------------------------------------------

ItemIconTbl:
.if LANG_EN
@26f5:  .byte   $ff,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7
.else
        .byte   $ff,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$f0,$f1,$f2,$f3,$f4
.endif

; ------------------------------------------------------------------------------

; [ find all items with this icon ]

; $e0: icon to find

FindItemsWithIcon:
@2706:  clr_ax
@2708:  phx
        lda     $7eaa8d,x
        cmp     #$ff
        beq     @2739
        sta     hWRMPYA
        lda     #ITEM_NAME::ITEM_SIZE
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     f:ItemName,x
        cmp     ze0
        bne     @2739
        plx
        lda     $7eaa8d,x
        sta     $1869,y
        lda     $7eab8d,x
        sta     $1969,y
        iny
        bra     @273a
@2739:  plx
@273a:  inx
        cpx     #$0100
        bne     @2708
        rts

; ------------------------------------------------------------------------------

; [ menu state $18: item (rare item select) ]

        array_label MENU_STATE, MENU_STATE::ITEM_RARE
@2741:  lda     #$10
        trb     z45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateRareItemCursor
        jsr     InitRareItemDesc
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2778
        jsr     PlayCancelSfx
        lda     #MENU_STATE::ITEM_OPTIONS
        sta     zMenuState
        ldy     z4d
        sty     r0232
        jsr     LoadItemOptionCursor
        lda     $1d4e
        and     #$40
        beq     @276f
        ldy     r0234
        sty     z4d
@276f:  jsr     InitItemOptionCursor
        jsr     ClearItemCount
        jmp     InitDMA1BG3ScreenA
@2778:  rts

; ------------------------------------------------------------------------------

; [ menu state $19: item (move) ]

        array_label MENU_STATE, MENU_STATE::ITEM_MOVE
@2779:  jsr     InitDMA1BG1ScreenA
        jsr     UpdateItemListCursor
        jsr     InitItemDesc
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2794
        jsr     PlayCancelSfx
        lda     #$01
        trb     z46
        lda     #MENU_STATE::ITEM_SELECT
        sta     zMenuState
        rts
@2794:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @27e1       ; branch if a button is not pressed
        jsr     PlaySelectSfx
        lda     zSelIndex
        cmp     z4b
        bne     @27aa
        lda     #$01
        trb     z46
        jmp     UseItem
@27aa:  lda     #$10
        tsb     z45
        lda     #$01
        trb     z46
        lda     #MENU_STATE::ITEM_SELECT
        sta     zMenuState
        clr_a
        lda     zSelIndex
        tay
        lda     $1869,y     ; swap item slots
        sta     ze0
        lda     $1969,y
        sta     ze1
        clr_a
        lda     z4b
        tax
        lda     $1869,x
        sta     $1869,y
        lda     ze0
        sta     $1869,x
        lda     $1969,x
        sta     $1969,y
        lda     ze1
        sta     $1969,x
        jmp     DrawItemList
@27e1:  rts

; ------------------------------------------------------------------------------

; [ menu state $1a: magic (select) ]

        array_label MENU_STATE, MENU_STATE::SKILLS_MAGIC
@27e2:  lda     #$10
        trb     z45
        lda     #LIST_TYPE::MAGIC
        sta     zListType
        jsr     InitDMA1BG1ScreenA
        lda     rGameTimeFrames
        ror
        bcc     @27f8
        jsr     InitDMA2BG3ScreenB
        bra     @27fb
@27f8:  jsr     TfrBigTextGfx
@27fb:  jsr     ScrollListPage
        bcs     @2861
        jsr     UpdateMagicCursor
        jsr     LoadMagicDesc
        jsr     DrawListMPCost
        lda     zNewCtrlState_H
        bit     #>JOY_Y
        beq     @2822
        jsr     PlaySelectSfx
        lda     zPrevMenuState
        not_a
        sta     zPrevMenuState
        lda     #$10
        tsb     z45
        jsr     CalcMagicOrder
        jmp     DrawMagicList
@2822:  lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @2855
        clr_a
        lda     z4b
        tax
        lda     $7e9e09,x
        cmp     #$20
        bne     @2862
        jsr     PlaySelectSfx
        ldy     z4f
        sty     z8e
        lda     z4a
        sta     z90
        lda     z4b
        sta     z99
        jsr     GetSelMagic
        cmp     #$12
        beq     @2869       ; branch if x-zone
        cmp     #$2a
        beq     @2874       ; branch if warp
        lda     #MENU_STATE::MAGIC_TARGET_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts
@2855:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2861
        jsr     InitDMA1BG1ScreenA
        jsr     ReloadSkillsMenu
@2861:  rts
@2862:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; x-zone
@2869:  lda     r0201
        bit     #$01
        beq     @2862       ; branch if x-zone is disabled
        lda     #$04        ; return code $04
        bra     @287d

; warp
@2874:  lda     r0201
        bit     #$02
        beq     @2862       ; branch if warp is disabled
        lda     #$03        ; return code $03
@287d:  sta     r0205
        jsr     _c32cea
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts

; ------------------------------------------------------------------------------

; [ menu state $1b: lore (select) ]

        array_label MENU_STATE, MENU_STATE::SKILLS_LORE
@288a:  lda     #$10
        trb     z45
        lda     #LIST_TYPE::LORE
        sta     zListType
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @28a9
        jsr     UpdateLoreCursor
        jsr     LoadLoreDesc
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @28a9
        jsr     ReloadSkillsMenu
@28a9:  rts

; ------------------------------------------------------------------------------

; [ menu state $1c: dance (select) ]

        array_label MENU_STATE, MENU_STATE::SKILLS_DANCE
@28aa:  jsr     InitDMA1BG1ScreenA
        jsr     UpdateAbilityCursor
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @28b9
        jsr     ReloadSkillsMenu
@28b9:  rts

; ------------------------------------------------------------------------------

; [ menu state $1d: rage (select) ]

        array_label MENU_STATE, MENU_STATE::SKILLS_RAGE
@28ba:  lda     #LIST_TYPE::RAGE
        sta     zListType
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @28d2
        jsr     UpdateRageCursor
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @28d2
        jsr     ReloadSkillsMenu
@28d2:  rts

; ------------------------------------------------------------------------------

; [ menu state $1e: espers (select) ]

        array_label MENU_STATE, MENU_STATE::SKILLS_GENJU_SELECT
@28d3:  lda     #$10
        trb     z45
        lda     #LIST_TYPE::GENJU
        sta     zListType
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @2928
        jsr     UpdateGenjuCursor
        jsr     LoadGenjuAttackDesc

; A button
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @291b
        jsr     PlaySelectSfx
        clr_a
        lda     z4b
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @2908

; open esper detail menu
        sta     z99
        jsr     InitGenjuDetailMenu
        lda     #MENU_STATE::SKILLS_GENJU_DETAIL
        sta     zMenuState
        rts

; unequip esper
@2908:  lda     #$ff
        sta     ze0
        jsr     _c32929
        jsr     DrawGenjuList
        jsr     InitDMA1BG1ScreenB
        jsr     WaitVblank
        jmp     InitDMA1BG1ScreenA

; B button
@291b:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2928
        lda     #$08
        trb     z46
        jsr     ReloadSkillsMenu
@2928:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32929:
@2929:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x
        lda     ze0
        sta     $001e,y
        lda     ze0
        jmp     _c34f08

; ------------------------------------------------------------------------------

; [ menu state $34: wait for esper equip error message ]

        array_label MENU_STATE, MENU_STATE::SKILLS_GENJU_ERROR
@293a:  ldy     zWaitCounter
        bne     @2947
        ldy     #near GenjuBlankMsg
        jsr     DrawPosKana
        jmp     _c35913
@2947:  rts

; ------------------------------------------------------------------------------

; blank text to clear esper equip error
GenjuBlankMsg:
.if LANG_EN
@2948:  .byte   $cd,$40,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        .byte   $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00
.else
        .byte   $dd,$40,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        .byte   $ff,$ff,$ff,$ff,$00
.endif

; ------------------------------------------------------------------------------

; [ menu state $39: party equipment overview ]

        array_label MENU_STATE, MENU_STATE::PARTY_EQUIP
@2966:  lda     zNewCtrlState_H                     ; wait for B button
        bit     #>JOY_B
        beq     @2976
        jsr     PlayCancelSfx
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts
@2976:  rts

; ------------------------------------------------------------------------------

; [ menu state $33: blitz menu ]

        array_label MENU_STATE, MENU_STATE::SKILLS_BLITZ
@2977:  lda     #$10
        trb     z45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateAbilityCursor
        jsr     LoadBlitzDesc
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @298d
        jsr     ReloadSkillsMenu
@298d:  rts

; ------------------------------------------------------------------------------

; [ menu state $3e: swdtech menu ]

        array_label MENU_STATE, MENU_STATE::SKILLS_BUSHIDO
@298e:  lda     #$10
        trb     z45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateAbilityCursor
        jsr     LoadBushidoDesc
.if !LANG_EN
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @2a2a
        clr_a
        lda     z4b
        tax
        lda     $7e9d89,x
        bmi     @2a24
        sta     r0206
        lda     #$ff
        sta     r0205
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts
@2a24:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
.endif
@2a2a:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2a3f
.if !LANG_EN
        jsr     ClearBG3ScreenB
        jsr     _c3a662
        jsr     InitDMA1BG3ScreenB
        jsr     WaitVblank
.endif
        jsr     ReloadSkillsMenu
@2a3f:  rts

; ------------------------------------------------------------------------------

; [ reload to skills menu ]

ReloadSkillsMenu:
@29a5:  jsr     PlayCancelSfx
        ldy     zZero
        sty     zBG2HScroll
        sty     zBG3HScroll
        lda     #MENU_STATE::SKILLS_SELECT
        sta     zMenuState
        jsr     _c34d27
        jsr     LoadSkillsCursor
        lda     z5e
        sta     z4e
        jsr     InitSkillsCursor
        jmp     _c35807

; ------------------------------------------------------------------------------

; [ menu state $21: restore saved game (init) ]

        array_label MENU_STATE, MENU_STATE::LOAD_SELECT
@29c2:  lda     z4b
        sta     zSelSaveSlot
        jsr     DrawSaveMenuChars
        jsr     UpdateGameLoadCursor
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @2a06
        clr_a
        lda     z4b
        beq     @2a07
        sta     zSelSaveSlot
        dec
        asl
        tax
        ldy     z91,x
        beq     @2a00
        jsr     PushSRAM
        jsr     PlaySelectSfx
        lda     zSelSaveSlot
        sta     rSelSaveSlot
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     _c36989
        jsr     PopTimers
        lda     #MENU_STATE::LOAD_CONFIRM_INIT
        sta     zNextMenuState
        lda     #MENU_STATE::SAVE_FADE_OUT
        sta     zMenuState
        rts
@2a00:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@2a06:  rts
@2a07:  jsr     PlaySelectSfx
        jsr     ResetGameTime
        lda     #1
        sta     rSelSaveSlot
        stz     rSaveSlotToLoad
        stz     r0205
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        lda     #MENU_STATE::SAVE_FADE_OUT
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ clear game time ]

ResetGameTime:
@2a21:  clr_ay
        sty     rGameTimeHours
        sty     rGameTimeSeconds
        rts

; ------------------------------------------------------------------------------

; [ menu state $23: restore saved game ]

        array_label MENU_STATE, MENU_STATE::LOAD_CONFIRM
@2a2a:  jsr     UpdateSaveConfirmCursor
        lda     zNewCtrlState_H
        bit     #>JOY_B
        bne     @2a58
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @2a64
        jsr     PlaySelectSfx
        lda     z4b
        bne     @2a5b
        ldy     $1863
        sty     rGameTimeHours
        lda     $1865
        sta     rGameTimeSeconds
        lda     zSelSaveSlot
        sta     rSaveSlotToLoad
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        rts
@2a58:  jsr     PlayCancelSfx
@2a5b:  jsr     PopSRAM
        lda     #MENU_STATE::LOAD_INIT
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
@2a64:  rts

; ------------------------------------------------------------------------------

; [ menu state $3a: magic target (init) ]

        array_label MENU_STATE, MENU_STATE::MAGIC_TARGET_INIT
@2a65:  lda     #$40
        tsb     z45
        jsr     _c32a76
        jsr     _c35812
        jsr     CreateCursorTask
        lda     #MENU_STATE::MAGIC_TARGET_SINGLE
        bra     _c32aa5

_c32a76:
@2a76:  jsr     DisableInterrupts
        lda     #$01
        tsb     z45
        lda     #BIT_2
        tsb     zEnableHDMA
        stz     zDMA2Dest
        stz     zDMA2Dest+1
        jsr     ClearBGScroll
        jsr     InitPortraits
        lda     #$03
        sta     hBG1SC
        lda     #BIT_6 | BIT_7
        trb     zEnableHDMA
        ldy     #$0002
        sty     zBG1VScroll
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #near CharSelectCursorTask
        jsr     CreateTask
        rts

_c32aa5:
@2aa5:  sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $3b: magic target (single target) ]

        array_label MENU_STATE, MENU_STATE::MAGIC_TARGET_SINGLE
@2aae:  lda     zNewCtrlState_L
        bit     #JOY_R
        bne     @2ac6
        lda     zNewCtrlState_L
        bit     #JOY_L
        bne     @2ac6
        lda     zNewCtrlState_H
        bit     #>JOY_RIGHT
        bne     @2ac6
        lda     zNewCtrlState_H
        bit     #>JOY_LEFT
        beq     @2af3
@2ac6:  jsr     PlayMoveSfx
        jsr     GetSelMagic
        jsr     GetMagicPropPtr
        longa_clc
        lda     hMPYL
        adc     #0
        tax
        clr_a
        shorta
        lda     f:MagicProp,x   ; spell data
        and     #$20
        beq     @2af3
        lda     z4e
        sta     z5f
        lda     #$06
        trb     z46
        jsr     CreateMultiCursorTask
        lda     #MENU_STATE::MAGIC_TARGET_MULTI
        sta     zMenuState
        rts
@2af3:  lda     zNewCtrlState_L
        bit     #JOY_A
        jne     @2b0c
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2b0b
        jsr     PlayCancelSfx
        lda     #MENU_STATE::MAGIC_TARGET_RETURN
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
@2b0b:  rts
@2b0c:  stz     zMenuScrollRate
        jsr     _c32ccc
        jsr     GetTargetCharPtr
        jsr     _c32c14
        bcc     @2b32
        jsr     _c32cea
        jsr     PlayCureSfx
        jsr     GetTargetCharPtr
        lda     $0014,y
        sta     zf8
        lda     $0015,y
        sta     zfb
        jsr     _c32b39
        jmp     _c32bde
@2b32:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32b39:
_magic_exec_call_c:
@2b39:  lda     $000b,y     ; max hp
        sta     $11b2
        lda     $000c,y
        sta     $11b3
        phy
        jsr     GetSelMagic
        ldx     zZero          ; 0: spell effect
        jsl     CalcMagicEffect_ext
        ply
        lda     zMenuScrollRate
        beq     @2b5c
        longa_clc
        lda     $11b0
        lsr
        bra     @2b61
@2b5c:  longa_clc
        lda     $11b0
@2b61:  adc     $0009,y
        sta     $0009,y
        shorta
        jsr     CheckMaxHP
        lda     zfc
        sta     $0014,y
        lda     zff
        sta     $0015,y
        lda     zMenuScrollRate
        bne     @2b99
        clr_a
        lda     z4b
        tax
        lda     zCharID,x
        jsl     UpdateEquip_ext
        clr_a
        lda     z4b
        asl
        tax
        ldy     zCharPropPtr,x
        sty     zSelCharPropPtr
        lda     $11d2
        jsr     _c391ec
        lda     $11d4
        jmp     _c391fb
@2b99:  rts

; ------------------------------------------------------------------------------

; [ check current hp vs max ]

CheckMaxHP:
@2b9a:  lda     $000b,y     ; max hp
        sta     zf3
        lda     $000c,y
        sta     zf4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        longa
        lda     $0009,y     ; current hp
        cmp     zf3
        bcc     @2bb9       ; return if not greater than max (return clear carry)
        lda     zf3
        sta     $0009,y     ; set current hp (return set carry)
        sec
@2bb9:  shorta
        rts

; ------------------------------------------------------------------------------

; [ check current mp vs max ]

CheckMaxMP:
@2bbc:  lda     $000f,y
        sta     zf3
        lda     $0010,y
        sta     zf4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        longa
        lda     $000d,y
        cmp     zf3
        bcc     @2bdb
        lda     zf3
        sta     $000d,y
        sec
@2bdb:  shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32bde:
@2bde:  jsr     _c32c01
        jsr     _c32cdf
        jsr     GetCasterCharPtr
        jsr     GetSelMagic
        jsr     CalcMPCost
        stx     ze7
        ldx     a:$000d,y
        cpx     ze7
        bcs     @2c00
        lda     #$02
        sta     z46
        lda     #MENU_STATE::MAGIC_TARGET_RETURN
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
@2c00:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32c01:
@2c01:  lda     z4b
        sta     zMenuScrollRate
        jsr     _c324ee
        jsr     ClearBG1ScreenA
        jsr     _c33193
        jsr     LoadPortraitPal
        jmp     GetPortraitGfxPtr

; ------------------------------------------------------------------------------

; [  ]

_c32c14:
@2c14:  lda     $0014,y
        andflg  STATUS1, DEAD
        bne     @2c40
        jsr     GetSelMagic
        cmp     #ATTACK::CURE
        beq     @2c76
        cmp     #ATTACK::CURA
        beq     @2c76
        cmp     #ATTACK::CURAGA
        beq     @2c76
        cmp     #ATTACK::POISONA
        beq     @2c6d
        cmp     #ATTACK::REMEDY
        beq     @2c64
        cmp     #ATTACK::FLOAT
        beq     @2c4d
        cmp     #ATTACK::IMP
        beq     @2c84
        cmp     #ATTACK::DISPEL
        beq     @2c56
        bra     @2c82
@2c40:  jsr     GetSelMagic
        cmp     #ATTACK::RAISE
        beq     @2c84
        cmp     #ATTACK::ARISE
        beq     @2c84
        bra     @2c82
@2c4d:  lda     $0015,y
        and     #STATUS4::FLOAT
        bne     @2c82
        bra     @2c84
@2c56:  lda     $0014,y
        clrflg  STATUS1, DEAD
        ora     $0015,y
        andflg  STATUS4, {FLOAT, CONTROL}
        beq     @2c82
        bra     @2c84
@2c64:  lda     $0014,y
        andflg  STATUS1, {PETRIFY, POISON, BLIND}
        beq     @2c82
        bra     @2c84
@2c6d:  lda     $0014,y
        andflg  STATUS1, POISON
        beq     @2c82
        bra     @2c84
@2c76:  lda     $0014,y
        andflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @2c82
        jsr     CheckMaxHP
        bcc     @2c84
@2c82:  clc
        rts
@2c84:  sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32c86:
@2c86:  stz     zaf
        lda     #$01
        sta     zMenuScrollRate
        jsr     _c32ccc
        clr_a
@2c90:  pha
        asl
        tax
        ldy     zCharPropPtr,x
        beq     @2cb8
        jsr     _c32c14
        bcc     @2cb8
        lda     $0014,y
        sta     zf8
        lda     $0015,y
        sta     zfb
        jsr     _c32b39
        jsr     _c32ccc
        lda     zaf
        bne     @2cb8
        jsr     PlayCureSfx
        jsr     _c32cea
        inc     zaf
@2cb8:  clr_a
        pla
        inc
        cmp     #$04
        bne     @2c90
        lda     zaf
        bne     @2cc9
        jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@2cc9:  jmp     _c32bde

; ------------------------------------------------------------------------------

; [  ]

_c32ccc:
@2ccc:  jsr     _c32cdf
        lda     $11a0       ; mag.pwr
        sta     $11ae       ; hit rate
        jsr     GetCasterCharPtr
        lda     $0008,y
        sta     $11af       ; level
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32cdf:
@2cdf:  clr_a
        lda     zSelIndex
        tax
        lda     zCharID,x
        jsl     UpdateEquip_ext
        rts

; ------------------------------------------------------------------------------

; [ subtract spell's mp cost ]

_c32cea:
@2cea:  jsr     GetSelMagic
        jsr     CalcMPCost
        stx     ze7
        jsr     GetCasterCharPtr
        longa
        lda     $000d,y
        sec
        sbc     ze7
        sta     $000d,y
        shorta
        rts

; ------------------------------------------------------------------------------

; [ get pointer to spell caster's character data ]

GetCasterCharPtr:
@2d03:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x
        rts

; ------------------------------------------------------------------------------

; [ get pointer to target character data ]

GetTargetCharPtr:
@2d0b:  clr_a
        lda     z4b         ; cursor position
        asl
        tax
        ldy     zCharPropPtr,x       ; pointer to character data
        rts

; ------------------------------------------------------------------------------

; [ get selected spell index ]

GetSelMagic:
@2d13:  clr_a
        lda     z99
        tax
        lda     $7e9d89,x
        rts

; ------------------------------------------------------------------------------

; [ menu state $3c: return to magic menu after casting a spell ]

        array_label MENU_STATE, MENU_STATE::MAGIC_TARGET_RETURN
@2d1c:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        lda     #$42
        trb     z45
        stz     z4a
        stz     z49
        jsr     InitSkillsBGScrollHDMA
        jsr     DrawSkillsWindow
        jsr     CreateCursorTask
        jsr     _c32130
        jsr     LoadMagicCursor
        lda     z8e
        sta     z4d
        ldy     z8e
        sty     z4f
        lda     z90
        sta     z4a
        lda     z4a
        sta     ze0
        lda     z50
        sec
        sbc     ze0
        sta     z4e
        jsr     InitMagicCursor
        jsr     InitMagicMenu
        jsr     DrawListMPCost
        jsr     TfrBG3ScreenAB
        jsr     WaitVblank
        ldy     zZero
        sty     zBG1HScroll
        jsr     InitBigText
        lda     #$10
        tsb     z45
        jsr     InitDMA1BG1ScreenA
        lda     #MENU_STATE::SKILLS_MAGIC
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $3d: magic target (multi-target) ]

        array_label MENU_STATE, MENU_STATE::MAGIC_TARGET_MULTI
@2d78:  lda     zNewCtrlState_L
        bit     #JOY_R
        bne     @2d90
        lda     zNewCtrlState_L
        bit     #JOY_L
        bne     @2d90
        lda     zNewCtrlState_H
        bit     #>JOY_RIGHT
        bne     @2d90
        lda     zNewCtrlState_H
        bit     #>JOY_LEFT
        beq     @2d9b
@2d90:  jsr     PlayMoveSfx
        jsr     _c32db7
        lda     #MENU_STATE::MAGIC_TARGET_SINGLE
        sta     zMenuState
        rts
@2d9b:  lda     zNewCtrlState_L
        bit     #JOY_A
        jne     _c32c86
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @2db6
        jsr     PlayCancelSfx
        jsr     _c32db7
        lda     #MENU_STATE::MAGIC_TARGET_RETURN
        sta     zNextMenuState
        stz     zMenuState              ; MENU_STATE::FADE_OUT
@2db6:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32db7:
@2db7:  jsr     InitCharSelectCursor
        jsr     CreateCursorTask
        lda     #0
        ldy     #near CharSelectCursorTask
        jsr     CreateTask
        jsr     ExecTasks
        lda     z5f
        sta     z4e
        lda     #$08
        trb     z46
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32dd1:
@2dd1:  clr_a
        lda     zSelIndex
        tax
        lda     z4b
        tay
        lda     zCharRowOrder,x
        sta     ze0
        lda     zCharRowOrder,y
        sta     zCharRowOrder,x
        lda     ze0
        sta     zCharRowOrder,y
        lda     zCharID,x
        sta     ze0
        lda     zCharID,y
        sta     zCharID,x
        lda     ze0
        sta     zCharID,y
        clr_a
        lda     zSelIndex
        asl
        tax
        lda     z4b
        asl
        tay
        longa
        lda     zCharPropPtr,x
        sta     ze7
        lda     zCharPropPtr,y
        sta     zCharPropPtr,x
        lda     ze7
        sta     zCharPropPtr,y
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32e10:
@2e10:  clr_a
        lda     zSelIndex
        tax
        lda     zCharRowOrder,x
        sta     ze0
        lda     z60,x
        tax
        lda     ze0
        bit     #$20
        beq     @2e29
        lda     #$20
        trb     ze0
        lda     #$03
        bra     @2e2f
@2e29:  lda     #$20
        tsb     ze0
        lda     #$02
@2e2f:  sta     wTaskProp::State,x
        clr_a
        lda     zSelIndex
        tax
        lda     ze0
        sta     zCharRowOrder,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32e3c:
@2e3c:  clr_a
        lda     z60::_0
        tax
        lda     #$ff
        sta     wTaskProp::w7e35c9,x
        lda     z60::_1
        tax
        lda     #$ff
        sta     wTaskProp::w7e35c9,x
        lda     z60::_2
        tax
        lda     #$ff
        sta     wTaskProp::w7e35c9,x
        lda     z60::_3
        tax
        lda     #$ff
        sta     wTaskProp::w7e35c9,x
        rts

; ------------------------------------------------------------------------------

; [ main menu: a button pressed ]

SelectMainMenuOption:
@2e62:  clr_a
        lda     z4b
        sta     z25         ; set main menu cursor position
        asl
        tax
        jmp     (near SelectMainMenuOptionTbl,x)

; ------------------------------------------------------------------------------

; main menu jump table
SelectMainMenuOptionTbl:
@2e6c:  .addr   SelectMainMenuOption_00
        .addr   SelectMainMenuOption_01
        .addr   SelectMainMenuOption_02
        .addr   SelectMainMenuOption_03
        .addr   SelectMainMenuOption_04
        .addr   SelectMainMenuOption_05
        .addr   SelectMainMenuOption_06

; ------------------------------------------------------------------------------

; config
SelectMainMenuOption_05:
@2e7a:  jsr     PlaySelectSfx
        stz     z5f
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        lda     #MENU_STATE::CONFIG_INIT
        sta     zNextMenuState
        rts

; ------------------------------------------------------------------------------

; item
SelectMainMenuOption_00:
@2e86:  jsr     PlaySelectSfx
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        lda     #MENU_STATE::ITEM_INIT
        sta     zNextMenuState
        rts

; ------------------------------------------------------------------------------

; skills, equip, relic, status
SelectMainMenuOption_01:
SelectMainMenuOption_02:
SelectMainMenuOption_03:
SelectMainMenuOption_04:
@2e90:  jsr     PlaySelectSfx
        lda     #$02
        trb     z46                     ; disable cursor 1
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #near CharSelectCursorTask
        jsr     CreateTask
        jsr     _c32f06
        lda     #MENU_STATE::FIELD_MENU_CHAR
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; save
SelectMainMenuOption_06:
@2eaa:  lda     r0201                   ; branch if save is not enabled
        bpl     @2ebf
        jsr     PlaySelectSfx
        stz     zMenuState              ; MENU_STATE::FADE_OUT
        lda     #MENU_STATE::SAVE_INIT
        sta     zNextMenuState
        sta     zPrevMenuState
        lda     #$04
        sta     z9f
        rts
@2ebf:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [ main menu: left button pressed ]

MainMenuLeftBtn:
@2ec6:  lda     #$02                    ; disable cursor 1
        trb     z46
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #near CharSelectCursorTask
        jsr     CreateTask
        lda     #6
        sta     zWaitCounter                     ; wait 6 frames
        ldy     #near -12
        sty     zMenuScrollRate
        lda     #$05                    ; disable cursor 2 and flashing cursor
        trb     z46
        lda     #MENU_STATE::ORDER_SELECT
        sta     zNextMenuState
        lda     #MENU_STATE::H_SCROLL
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32eeb:
@2eeb:  lda     #2
        ldy     #near MultiCursorTask
        jsr     CreateTask
        longa
        lda     #$0038
        sta     wTaskProp::PosX_H,x
        lda     #$0036
        sta     wTaskProp::PosY_H,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create flashing cursor (2 pixels to the right) ]

_c32f06:
@2f06:  lda     #2
        ldy     #near FlashingCursorTask
        jsr     CreateTask
        longa
        lda     z55                     ; cursor x position
        inc2
        sta     wTaskProp::PosX_H,x               ; set task x position
        lda     z57                     ; cursor y position
        sta     wTaskProp::PosY_H,x               ; set task y position
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create flashing cursor (4 pixels right/up) ]

_c32f21:
@2f21:  lda     #1
        ldy     #near FlashingCursorTask
        jsr     CreateTask
        longa
        lda     z55
        clc
        adc     #4
        sta     wTaskProp::PosX_H,x
        lda     z57
        sec
        sbc     #4
        sta     wTaskProp::PosY_H,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ main menu cursor task ]

MainMenuCursorTask:
@2f42:  tax
        jmp     (near MainMenuCursorTaskTbl,x)

; ------------------------------------------------------------------------------

; main menu cursor task jump table
MainMenuCursorTaskTbl:
@2f46:  .addr   MainMenuCursorTask_00
        .addr   MainMenuCursorTask_01

; ------------------------------------------------------------------------------

; state 0: init
MainMenuCursorTask_00:
@2f4a:  ldx     zTaskOffset
        lda     #$02
        tsb     z46                     ; enable cursor 1
        inc     near wTaskProp::State,x                 ; increment task counter
        ldy     #near MainMenuCursorProp
        jsr     LoadCursor
        lda     $1d4e                   ; branch if cursor is on memory
        and     #$40
        beq     @2f65
        ldy     r022b                   ; load saved cursor position
        sty     z4d
@2f65:  ldy     #near MainMenuCursorPos
        jsr     UpdateCursorPos
; fallthrough

; ------------------------------------------------------------------------------

; state 1: update
MainMenuCursorTask_01:
@2f6b:  lda     z46
        bit     #$02
        beq     @2f83                   ; terminate if cursor 1 is not active
        ldx     zTaskOffset
        jsr     MoveCursor
        ldy     #near MainMenuCursorPos
        jsr     UpdateCursorPos
        ldy     z4d
        sty     r022b                   ; save cursor position
        sec
        rts
@2f83:  clc
        rts

; ------------------------------------------------------------------------------

; main menu cursor data
MainMenuCursorProp:
        cursor_prop {0, 0}, {1, 7}, NO_X_WRAP

; ------------------------------------------------------------------------------

; main menu cursor positions
MainMenuCursorPos:
.if LANG_EN
        @X_OFFSET = 175
.else
        @X_OFFSET = 183
.endif

        cursor_pos {@X_OFFSET, 18}
        cursor_pos {@X_OFFSET, 33}
        cursor_pos {@X_OFFSET, 48}
        cursor_pos {@X_OFFSET, 63}
        cursor_pos {@X_OFFSET, 78}
        cursor_pos {@X_OFFSET, 93}
        cursor_pos {@X_OFFSET, 108}

; ------------------------------------------------------------------------------

; [ init character select cursor ]

InitCharSelectCursor:
@2f98:  jsr     LoadCharSelectCursorProp
        clr_axy
@2f9e:  lda     a:zCharID,x
        bpl     @2faa                   ; branch if slot is not empty
        phx
        txa
        asl
        tax
        stz     z85,x                   ; disable cursor position
        plx
@2faa:  inx
        cpx     #4
        bne     @2f9e
        rts

; ------------------------------------------------------------------------------

; [ load character select cursor data ]

LoadCharSelectCursorProp:
@2fb1:  ldx     zZero
@2fb3:  lda     f:CharSelectCursorProp,x
        sta     z80,x
        inx
        cpx     #sizeof_CharSelectCursorProp
        bne     @2fb3
        rts

; ------------------------------------------------------------------------------

; [ character select cursor task ]

.enum CHAR_SELECT_CURSOR_TASK
        INIT
        SUSTAIN

        COUNT
.endenum

CharSelectCursorTask:
@2fc0:  tax
        jmp     (near CharSelectCursorTaskTbl,x)

CharSelectCursorTaskTbl:
        ptr_tbl CHAR_SELECT_CURSOR_TASK

; ------------------------------------------------------------------------------

; [  ]

        array_label CHAR_SELECT_CURSOR_TASK, CHAR_SELECT_CURSOR_TASK::INIT
@2fc8:  ldx     zTaskOffset
        lda     #$14
        tsb     z46
        inc     near wTaskProp::State,x
        jsr     _c32ff5
        lda     z45
        bit     #$40
        bne     @2fe6
        lda     $1d4e
        and     #$40
        beq     @2fe6
        ldy     r022d
        sty     z4d
@2fe6:  jsr     _c33008
        lda     z55
        bne     @2ff3
        jsr     _c32ff5
        jsr     _c33008
@2ff3:  sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32ff5:
@2ff5:  ldy     #$0080
        jsr     LoadCursor
        ldy     #$0080
        lda     #$00
        sta     zed
        jsr     LoadCursorFar
        jmp     SelectFirstChar

; ------------------------------------------------------------------------------

; [  ]

_c33008:
@3008:  ldy     #$0085
        sty     ze7
        lda     #$00
        sta     ze9
        jmp     UpdateCursorPosFar

; ------------------------------------------------------------------------------

; [  ]

        array_label CHAR_SELECT_CURSOR_TASK, CHAR_SELECT_CURSOR_TASK::SUSTAIN
@3014:  lda     z45
        bit     #$40
        bne     @301f
        ldy     z4d
        sty     r022d
@301f:  lda     z46
        bit     #$04
        beq     @3040
        bit     #$10
        beq     @303e
        ldx     zTaskOffset
@302b:  jsr     MoveCursor
        ldy     #$0085      ; cursor data pointer = $000085
        sty     ze7
        lda     #$00
        sta     ze9
        jsr     UpdateCursorPosFar
        lda     z55
        beq     @302b
@303e:  sec
        rts
@3040:  clc
        rts

; ------------------------------------------------------------------------------

; character select cursor data
CharSelectCursorProp:
        cursor_prop {0, 0}, {1, 4}, NO_X_WRAP

; ------------------------------------------------------------------------------

; character select cursor positions
CharSelectCursorPos:
@3047:  cursor_pos {8, 40}
        cursor_pos {8, 88}
        cursor_pos {8, 136}
        cursor_pos {8, 184}
        calc_size CharSelectCursorProp

; ------------------------------------------------------------------------------

; [ create fade out task ]

CreateFadeOutTask:
@304f:  clr_a                           ; priority 0
        ldy     #near FadeOutTask
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ create fade in task ]

CreateFadeInTask:
@3056:  clr_a                           ; priority 0
        ldy     #near FadeInTask
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ create mosaic task ]

CreateMosaicTask:
@305d:  clr_a                           ; priority 0
        ldy     #near MosaicTask
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ mosaic task ]

.proc MosaicTask

        tax
        jmp     (near MosaicTaskTbl,x)

.endproc  ; MosaicTask

.enum MOSAIC_TASK
        INIT
        SUSTAIN

        COUNT
.endenum

MosaicTaskTbl:
        ptr_tbl MOSAIC_TASK

; 0: init mosaic
        array_label MOSAIC_TASK, MOSAIC_TASK::INIT
        ldx     zTaskOffset
        inc     near wTaskProp::State,x
        stz     near wTaskProp::PosX_H,x
        lda     #8
        sta     near wTaskProp::w7e3349,x

; 1: update mosaic
        array_label MOSAIC_TASK, MOSAIC_TASK::SUSTAIN
        ldx     zTaskOffset
        lda     near wTaskProp::w7e3349,x
        beq     Terminate
        clr_a
        lda     near wTaskProp::PosX_H,x
        tax
        lda     f:MosaicTbl,x
        sta     zMosaic
        ldx     zTaskOffset
        inc     near wTaskProp::PosX_H,x
        dec     near wTaskProp::w7e3349,x
        sec
        rts

Terminate:
        clc
        rts

; mosaic data
MosaicTbl:
        .byte   $17,$27,$37,$47,$37,$27,$17,$07

; ------------------------------------------------------------------------------

; [ fade out task ]

.proc FadeOutTask

        tax
        jmp     (near FadeOutTaskTbl,x)

.endproc  ; FadeOutTask

.enum FADE_OUT_TASK
        INIT
        SUSTAIN

        COUNT
.endenum

FadeOutTaskTbl:
        ptr_tbl FADE_OUT_TASK

; 0: init fade out
        array_label FADE_OUT_TASK, FADE_OUT_TASK::INIT
        ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     #$0f
        sta     near wTaskProp::PosX_H,x

; 1: update fade out
        array_label FADE_OUT_TASK, FADE_OUT_TASK::SUSTAIN
        ldy     zWaitCounter
        beq     @Terminate
        ldx     zTaskOffset
        lda     near wTaskProp::PosX_H,x
        sta     zScreenBrightness
        dec     near wTaskProp::PosX_H,x
        dec     near wTaskProp::PosX_H,x
        sec
        rts

@Terminate:
        lda     #$01
        sta     zScreenBrightness
        clc
        rts

; ------------------------------------------------------------------------------

; [ fade in task ]

.proc FadeInTask

        tax
        jmp     (near FadeInTaskTbl,x)

.endproc  ; FadeInTask

.enum FADE_IN_TASK
        INIT
        SUSTAIN

        COUNT
.endenum

FadeInTaskTbl:
        ptr_tbl FADE_IN_TASK

; 0: init fade in
        array_label FADE_IN_TASK, FADE_IN_TASK::INIT
        ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     #1
        sta     near wTaskProp::PosY_H,x

; 1: update fade in
        array_label FADE_IN_TASK, FADE_IN_TASK::SUSTAIN
        ldy     zWaitCounter
        beq     @Terminate
        ldx     zTaskOffset
        lda     near wTaskProp::PosY_H,x
        sta     zScreenBrightness
        inc     near wTaskProp::PosY_H,x
        inc     near wTaskProp::PosY_H,x
        sec
        rts

@Terminate:
        lda     #$0f
        sta     zScreenBrightness
        clc
        rts

; ------------------------------------------------------------------------------

; [ init bg (main menu) ]

DrawMainMenu:
@30f5:  jsr     InitFontColor
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenB
        ldy     #near MainMenuOrderWindow1
        jsr     DrawWindow
        ldy     #near MainMenuOrderWindow2
        jsr     DrawWindow
        ldy     #near MainMenuCharWindow
        jsr     DrawWindow
        ldy     #near MainMenuOptionsWindow
        jsr     DrawWindow
        jsr     _c33170
        jsr     DrawTime
        jsr     DrawMainMenuListText
        jmp     _c3319f

; ------------------------------------------------------------------------------

; [ draw menu for confirming a save slot to save ]

DrawGameSaveConfirmMenu:
@3128:  jsr     InitFontColor
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        jsr     _c331a8
        ldy     #near MainMenuCharWindow
        jsr     DrawWindow
        ldy     #near SaveChoiceWindow
        jsr     DrawWindow
        jsr     _c33170
        jsr     _c33295
        jsr     DrawGameSaveChoiceText
        jmp     _c3319f

; ------------------------------------------------------------------------------

; [ draw menu for confirming a save slot to load ]

DrawGameLoadConfirmMenu:
@314c:  jsr     InitFontColor
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        jsr     _c331a8
        ldy     #near MainMenuCharWindow
        jsr     DrawWindow
        ldy     #near SaveChoiceWindow
        jsr     DrawWindow
        jsr     _c33170
        jsr     _c33295
        jsr     DrawGameLoadChoiceText
        jmp     _c3319f

; ------------------------------------------------------------------------------

; [  ]

_c33170:
@3170:  clr_a
        jsl     InitGradientHDMA
        ldy     #near MainMenuTimeWindow
        jsr     DrawWindow
        ldy     #near MainMenuStepsWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     _c3318a
        jmp     DrawGilStepsText

; ------------------------------------------------------------------------------

; [  ]

_c3318a:
@318a:  jsr     ClearBG1ScreenA
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenC

_c33193:
@3193:  jsr     DrawCharBlock1
        jsr     DrawCharBlock2
        jsr     DrawCharBlock3
        jmp     DrawCharBlock4

; ------------------------------------------------------------------------------

; [  ]

_c3319f:
@319f:  jsr     TfrBG1ScreenAB
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

; [  ]

_c331a8:
@31a8:  lda     zSelSaveSlot
        cmp     #1
        beq     @31b5
        cmp     #2
        beq     @31b8
        jmp     LoadSaveSlot3WindowGfx
@31b5:  jmp     LoadSaveSlot1WindowGfx
@31b8:  jmp     LoadSaveSlot2WindowGfx

; ------------------------------------------------------------------------------

; main menu window data

.if LANG_EN
MainMenuOptionsWindow:                  window_pos BG2A, {23, 1}, {6, 13}
MainMenuTimeWindow:                     window_pos BG2A, {23, 16}, {6, 2}
.else
MainMenuOptionsWindow:                  window_pos BG2A, {24, 1}, {5, 13}
MainMenuTimeWindow:                     window_pos BG2A, {24, 16}, {5, 2}
.endif
MainMenuStepsWindow:                    window_pos BG2A, {22, 20}, {7, 5}
MainMenuCharWindow:                     window_pos BG2A, {1, 1}, {28, 24}
SaveChoiceWindow:                       window_pos BG2A, {22, 1}, {7, 10}
MainMenuOrderWindow1:                   window_pos BG2B, {24, 1}, {7, 2}
MainMenuOrderWindow2:                   window_pos BG2A, {30, 0}, {1, 2}

; ------------------------------------------------------------------------------

; [ draw "yes/no/erasing data, okay?" text ]

DrawGameSaveChoiceText:
@31d7:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near GameSaveChoiceTextList
        ldy     #sizeof_GameSaveChoiceTextList
        jsr     DrawPosKanaList
        rts

; ------------------------------------------------------------------------------

; [ draw "yes/no/this data?" text ]

DrawGameLoadChoiceText:
@31e5:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near GameLoadChoiceTextList
        ldy     #sizeof_GameLoadChoiceTextList
        jsr     DrawPosKanaList
        rts

; ------------------------------------------------------------------------------

; [ draw "item/skills/equip/relic/status/config/save" text ]

DrawMainMenuListText:
@31f3:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near MainMenuOptionsTextList1
        ldy     #sizeof_MainMenuOptionsTextList1
        jsr     DrawPosList
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near MainMenuOptionsTextList2
        ldy     #sizeof_MainMenuOptionsTextList2
        jsr     DrawPosKanaList
        lda     r0201
        bpl     @3216       ; branch if save is disabled
        lda     #BG3_TEXT_COLOR::DEFAULT
        bra     @3218
@3216:  lda     #BG3_TEXT_COLOR::GRAY
@3218:  sta     zTextColor
        ldy     #near MainMenuSaveText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [ draw gp and steps ]

DrawGilStepsText:
@3221:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near MainMenuColonText
        jsr     DrawPosText
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near MainMenuLabelTextList
        ldy     #sizeof_MainMenuLabelTextList
        jsr     DrawPosList
        ldy     #near MainMenuGilText
        jsr     DrawPosKana
        jsr     ValidateMaxGil
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     $1866                   ; gp
        sty     zf1
        lda     $1868
        sta     zf3
        jsr     HexToDec8
        ldx_pos BG3A, {23, 22}
        jsr     DrawNum7
        ldy     $1860                   ; steps
        sty     zf1
        lda     $1862
        sta     zf3
        jsr     HexToDec8
        ldx_pos BG3A, {23, 25}
        jsr     DrawNum7
        rts

; ------------------------------------------------------------------------------

; [ draw game time or timer ]

DrawTime:
@326c:  lda     $1188                   ; branch if timer 0 is not active
        bit     #$10
        beq     @3289
        ldy     $1189
        jsr     Div60
        jsr     Div60
        lda     ze7
        sta     $1863
        lda     hRDMPYL
        sta     $1864
        bra     _c33295
@3289:  ldy     rGameTimeHours
        sty     $1863
        lda     rGameTimeSeconds
        sta     $1865

_c33295:
@3295:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        lda     $1863
        jsr     HexToDec3
        ldx_pos BG3A, {25, 18}
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx_pos BG3A, {28, 18}
        jsr     DrawNum2
        rts

; ------------------------------------------------------------------------------

; [ divide by 60 ]

; convert frames to seconds, seconds to minutes, or minutes to hours

Div60:
@32b2:  sty     hWRDIVL
        lda     #60
        sta     hWRDIVB
        nop8
        nop6
        ldy     hRDDIVL
        sty     ze7
        rts

; ------------------------------------------------------------------------------

; [ check max gil ]

ValidateMaxGil:
@32ce:  lda     #<MAX_GIL        ; 9999999 max
        cmp     $1860
        lda     #>MAX_GIL
        sbc     $1861
        lda     #^MAX_GIL
        sbc     $1862
        bcs     @32ea
        ldy     #.loword(MAX_GIL)
        sty     $1860
        lda     #^MAX_GIL
        sta     $1862
@32ea:  rts

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 1) ]

.scope DrawCharBlock1
EmptySlot:
        jsr     CreatePortraitTask1
        jmp     HidePortrait

::DrawCharBlock1:
        lda     zCharID::_0
        bmi     EmptySlot
        ldx     zCharPropPtr::_0
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near CharBlock1LabelTextList
        ldy     #sizeof_CharBlock1LabelTextList
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {15, 3}
.else
        ldy_pos BG1A, {15, 2}
.endif
        ldx     #make_word 120, 21
        stz     z48
        jsr     DrawStatusIcons
        ldx     #near CharBlock1SlashTextList
        stx     zf1
        ldy     #sizeof_CharBlock1SlashTextList
        sty     zef
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {8, 3}
.else
        ldy_pos BG1A, {8, 2}
.endif
        jsr     DrawCharName
        ldx     #near CharBlock1TextPosTbl
        jsr     DrawCharBlock
        jmp     CreatePortraitTask1

; ram addresses for lv/hp/mp text (slot 1)
CharBlock1TextPosTbl:
        bg_pos BG1A, {15, 5}
        bg_pos BG1A, {13, 6}
        bg_pos BG1A, {18, 6}
        bg_pos BG1A, {13, 7}
        bg_pos BG1A, {18, 7}

.endscope  ; DrawCharBlock1

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 2) ]

.scope DrawCharBlock2

EmptySlot:
        jsr     CreatePortraitTask2
        jmp     HidePortrait

::DrawCharBlock2:
        lda     zCharID::_1
        bmi     EmptySlot
        ldx     zCharPropPtr::_1
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near CharBlock2LabelTextList
        ldy     #sizeof_CharBlock2LabelTextList
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {15, 9}
.else
        ldy_pos BG1A, {15, 8}
.endif
        ldx     #make_word 120, 69
        stz     z48
        jsr     DrawStatusIcons
        ldx     #near CharBlock2SlashTextList
        stx     zf1
        ldy     #sizeof_CharBlock2SlashTextList
        sty     zef
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {8, 9}
.else
        ldy_pos BG1A, {8, 8}
.endif
        jsr     DrawCharName
        ldx     #near CharBlock2TextPosTbl
        jsr     DrawCharBlock
        jmp     CreatePortraitTask2

; ram addresses for lv/hp/mp text (slot 2)
CharBlock2TextPosTbl:
        bg_pos BG1A, {15, 11}
        bg_pos BG1A, {13, 12}
        bg_pos BG1A, {18, 12}
        bg_pos BG1A, {13, 13}
        bg_pos BG1A, {18, 13}

.endscope  ; DrawCharBlock2

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 3) ]

.scope DrawCharBlock3

EmptySlot:
        jsr     CreatePortraitTask3
        jmp     HidePortrait

::DrawCharBlock3:
        lda     zCharID::_2
        bmi     EmptySlot
        ldx     zCharPropPtr::_2
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near CharBlock3LabelTextList
        ldy     #sizeof_CharBlock3LabelTextList
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {15, 15}
.else
        ldy_pos BG1A, {15, 14}
.endif
        ldx     #make_word 120, 117
        stz     z48
        jsr     DrawStatusIcons
        ldx     #near CharBlock3SlashTextList
        stx     zf1
        ldy     #sizeof_CharBlock3SlashTextList
        sty     zef
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {8, 15}
.else
        ldy_pos BG1A, {8, 14}
.endif
        jsr     DrawCharName
        ldx     #near CharBlock3TextPosTbl
        jsr     DrawCharBlock
        jmp     CreatePortraitTask3

; ram addresses for lv/hp/mp text (slot 3)
CharBlock3TextPosTbl:
        bg_pos BG1A, {15, 17}
        bg_pos BG1A, {13, 18}
        bg_pos BG1A, {18, 18}
        bg_pos BG1A, {13, 19}
        bg_pos BG1A, {18, 19}

.endscope  ; DrawCharBlock3

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 4) ]

.scope DrawCharBlock4

EmptySlot:
        jsr     CreatePortraitTask4
        jmp     HidePortrait

::DrawCharBlock4:
        lda     zCharID::_3
        bmi     EmptySlot       ; branch if slot is empty
        ldx     zCharPropPtr::_3
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near CharBlock4LabelTextList
        ldy     #sizeof_CharBlock4LabelTextList
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {15, 21}
.else
        ldy_pos BG1A, {15, 20}
.endif
        ldx     #make_word 120, 165
        stz     z48
        jsr     DrawStatusIcons
        ldx     #near CharBlock4SlashTextList
        stx     zf1
        ldy     #sizeof_CharBlock4SlashTextList
        sty     zef
        jsr     DrawPosList
.if ::LANG_EN
        ldy_pos BG1A, {8, 21}
.else
        ldy_pos BG1A, {8, 20}
.endif
        jsr     DrawCharName
        ldx     #near CharBlock4TextPosTbl
        jsr     DrawCharBlock
        jmp     CreatePortraitTask4

; ram addresses for lv/hp/mp text (character slot 4)
CharBlock4TextPosTbl:
        bg_pos BG1A, {15, 23}
        bg_pos BG1A, {13, 24}
        bg_pos BG1A, {18, 24}
        bg_pos BG1A, {13, 25}
        bg_pos BG1A, {18, 25}

.endscope  ; DrawCharBlock4

; ------------------------------------------------------------------------------

; [ hide portrait ]

.proc HidePortrait

        longa
        lda     #216                    ; set y position to 216 (off-screen)
        sta     wTaskProp::PosY_H,x
        shorta
        rts

.endproc  ; HidePortrait

; ------------------------------------------------------------------------------

; [ draw status icons ]

; also sets text color for hp/mp/level
; +X: xy position
; +Y: pointer to bg tilemap

.proc DrawStatusIcons

        stx     ze7
        jsr     InitTextBuf
        lda     $0014,y                 ; status 1
        bmi     CharIsDead              ; branch if character is dead
        andflg  STATUS1, {VANISH, IMP, PETRIFY}
        sta     ze1
        lda     $0014,y
        andflg  STATUS1, {BLIND, ZOMBIE, POISON}
        asl
        sta     ze2
        lda     $0015,y                 ; status 4
        andflg  STATUS4, FLOAT
        ora     ze1
        ora     ze2
        sta     ze1                     ; feicpzd-
        beq     NoIcons                 ; branch if character has no status icons
        stz     zf1                     ; clear icon index
        stz     zf2
        ldx     #7                      ; loop through each status
Loop:   phx
        asl
        bcc     Skip                    ; continue if character doesn't have this status
        pha
        lda     #3
        ldy     #near CharIconTask
        jsr     CreateTask
        lda     #1
        sta     wTaskProp::Flags,x            ; task doesn't scroll with bg
        lda     z48                     ; 1 for party menu, 0 otherwise
        sta     wTaskProp::State,x            ; task state
        txy
        ldx     zf1                     ; icon index
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:StatusIconAnimPtrs,x
        sta     near wTaskProp::AnimPtr,y
        shorta
        lda     ze7
        sta     near wTaskProp::PosX_H,y                 ; x position
        lda     ze8
        sta     near wTaskProp::PosY_H,y                 ; y position
        clr_a
        sta     near wTaskProp::PosX + 2,y                 ; clear high bytes
        sta     near wTaskProp::PosY + 2,y
        lda     #^StatusIconAnimPtrs
        sta     near wTaskProp::AnimBank,y
        plb
        clc
        lda     #10
        adc     ze7                     ; next icon is 10 pixels to the right
        sta     ze7
        pla
Skip:   inc     zf1                     ; increment icon index
        inc     zf1
        plx
        dex                             ; next status
        bne     Loop
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        rts

; character has no status icons
NoIcons:
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor                     ; white text
        jmp     DrawCharTitleNoInit

; character is dead
CharIsDead:
        ldx     #$9e8b
        stx     hWMADDL
        ldx     zZero
:       lda     f:MainMenuWoundedText,X ; text: "wounded"
        sta     hWMDATA
        inx
        cpx     #sizeof_MainMenuWoundedText
        bne     :-
        stz     hWMDATA
        lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        jmp     DrawPosTextBuf

.endproc  ; DrawStatusIcons

; ------------------------------------------------------------------------------

; [ draw character name ]

.proc DrawCharName
        jsr     InitTextBuf

::DrawCharNameNoInit:
        ldx     #6
:       lda     $0002,y               ; character name
        sta     hWMDATA
        iny
        dex
        bne     :-
        stz     hWMDATA
        jmp     DrawPosTextBuf
.endproc  ; DrawCharName

; ------------------------------------------------------------------------------

; [ draw character title ]

.proc DrawCharTitle

.if ::LANG_EN

::DrawCharTitleNoInit:
        rts

.else
        jsr     InitTextBuf

::DrawCharTitleNoInit:
        lda     $0000,y
        sta     hWRMPYA
        lda     #::CHAR_TITLE::ITEM_SIZE
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        ldy     #::CHAR_TITLE::ITEM_SIZE
:       lda     f:CharTitle,x
        sta     hWMDATA
        inx
        dey
        bne     :-
        lda     #$ff
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf
.endif

.endproc  ; DrawCharTitle

; ------------------------------------------------------------------------------

; [ draw equipped esper name ]

DrawCharGenjuName:
@34e6:  jsr     InitTextBuf
        lda     $001e,y                 ; equipped esper
        cmp     #$ff
        beq     @3508                   ; branch if no esper is equipped
        asl3
        tax
        ldy     #8
@34f7:  lda     f:GenjuName,x
        sta     hWMDATA
        inx
        dey
        bne     @34f7
        stz     hWMDATA
        jmp     DrawPosTextBuf
@3508:  ldy     #8
        lda     #$ff
@350d:  sta     hWMDATA                 ; clear equipped esper name
        dey
        bne     @350d
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ init positioned text buffer ]

; +Y: text position

InitTextBuf:
@3519:  ldx     #$9e89                  ; set pointer to text buffer
        stx     hWMADDL
        longa
        tya
        shorta
        sta     hWMDATA
        xba
        sta     hWMDATA
        clr_a
        ldy     zSelCharPropPtr
        rts

; ------------------------------------------------------------------------------

; [ disable interrupts ]

.proc DisableInterrupts

        lda     #$80        ; screen off
        sta     hINIDISP
        jsr     ResetTasks
        stz     hNMITIMEN
        stz     hMDMAEN
        stz     hHDMAEN
        rts

.endproc  ; DisableInterrupts

; ------------------------------------------------------------------------------

; [ enable interrupts ]

.proc EnableInterrupts

        lda     #$01        ; screen register (screen on, brightness 1)
        sta     zScreenBrightness
        jmp     WaitVblank

.endproc  ; EnableInterrupts

; ------------------------------------------------------------------------------

; [ draw time text ]

.proc UpdateTimeText

        jsr     InitDMA1BG3ScreenA
        jmp     DrawTime

.endproc  ; UpdateTimeText

; ------------------------------------------------------------------------------

; [ init main screen designation hdma (main menu) ]

; this is used to hide and show portraits and character stat blocks when
; swapping the order of characters in the party

InitMainScreenLayerHDMA:
        ldx     zZero
        lda     #$17        ; main screen designation (-> $212c)
:       sta     $7e9a09,x
        inx
        cpx     #$00df
        bne     :-
        lda     #$40        ; hdma channel #6 - indirect addressing
        sta     hDMA6::CTRL
        lda     #<hTM
        sta     hDMA6::HREG
        ldy     #near MainScreenLayerHDMATbl
        sty     hDMA6::ADDR
        lda     #^MainScreenLayerHDMATbl
        sta     hDMA6::ADDR_B
        lda     #$7e
        sta     hDMA6::HDMA_B
        lda     #BIT_6
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; main screen designation hdma table (main menu)
MainScreenLayerHDMATbl:
        hdma_addr 112 | BIT_7, $9a09
        hdma_addr 112 | BIT_7, $9a79
        hdma_end

; ------------------------------------------------------------------------------

; [ init character swap tasks ]

CreateCharSwapTask:
@3582:  lda     zSelIndex
        cmp     z4b
        bcc     @359d
        lda     #3
        ldy     #near CharSwapTopTask
        jsr     CreateTask
        jsr     @35c1
        lda     #3
        ldy     #near CharSwapBtmTask
        jsr     CreateTask
        bra     @35b2
@359d:  lda     #3
        ldy     #near CharSwapTopTask
        jsr     CreateTask
        jsr     @35b2
        lda     #3
        ldy     #near CharSwapBtmTask
        jsr     CreateTask
        bra     @35c1

@35b2:  txy
        clr_a
        lda     zSelIndex
        tax
        lda     f:_c335d0,x
        tyx
        sta     wTaskProp::PosX_H,x
        rts

@35c1:  txy
        clr_a
        lda     z4b
        tax
        lda     f:_c335d0,x
        tyx
        sta     wTaskProp::PosX_H,x   ; x position
        rts

; ------------------------------------------------------------------------------

_c335d0:
@35d0:  .byte   $0d,$3d,$6d,$9d

; ------------------------------------------------------------------------------

; [ character swap task (top character) ]

CharSwapTopTask:
@35d4:  tax
        jmp     (near CharSwapTopTaskTbl,x)

CharSwapTopTaskTbl:
@35d8:  .addr   CharSwapTopTask_00
        .addr   CharSwapTopTask_01
        .addr   CharSwapTopTask_02

; ------------------------------------------------------------------------------

; [ state 0: init ]

CharSwapTopTask_00:
@35de:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
; fallthrough

; ------------------------------------------------------------------------------

; [ state 1: hide character in old slot ]

CharSwapTopTask_01:
@35e3:  ldy     zTaskOffset
        lda     z22
        cmp     #12
        beq     @35fa
        clr_a
        lda     near wTaskProp::PosX_H,y     ; x position
        tax
        lda     #$06
        jsr     UpdateCharSwapHDMA1
        sta     near wTaskProp::PosX_H,y
        sec
        rts
@35fa:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        dec     near wTaskProp::PosX_H,x
; fallthrough

; ------------------------------------------------------------------------------

; [ state 2: show character in new slot ]

CharSwapTopTask_02:
@3602:  lda     z45
        bit     #$08
        beq     @361b
        ldy     zTaskOffset
        lda     z22
        beq     @361d
        clr_a
        lda     near wTaskProp::PosX_H,y     ; x position
        tax
        lda     #$17
        jsr     UpdateCharSwapHDMA2
        sta     near wTaskProp::PosX_H,y
@361b:  sec
        rts
@361d:  clc
        rts

; ------------------------------------------------------------------------------

; [ character swap task (bottom character) ]

CharSwapBtmTask:
@361f:  tax
        jmp     (near CharSwapBtmTaskTbl,x)

CharSwapBtmTaskTbl:
@3623:  .addr   CharSwapBtmTask_00
        .addr   CharSwapBtmTask_01
        .addr   CharSwapBtmTask_02

; ------------------------------------------------------------------------------

; [ init ]

CharSwapBtmTask_00:
@3629:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     near wTaskProp::PosX_H,x
        clc
        adc     #$2f
        sta     near wTaskProp::PosX_H,x
; fallthrough

; ------------------------------------------------------------------------------

; [ hide character in old slot ]

CharSwapBtmTask_01:
@3637:  ldy     zTaskOffset
        lda     z22
        cmp     #12
        beq     @3650
        clr_a
        lda     near wTaskProp::PosX_H,y
        tax
        lda     #$06
        jsr     UpdateCharSwapHDMA2
        sta     near wTaskProp::PosX_H,y
        dec     z22
        sec
        rts
@3650:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        inc     near wTaskProp::PosX_H,x
; fallthrough

; ------------------------------------------------------------------------------

; [ show character in new slot ]

CharSwapBtmTask_02:
@3658:  lda     z45
        bit     #$08
        beq     @3673
        ldy     zTaskOffset
        lda     z22
        beq     @3675
        clr_a
        lda     near wTaskProp::PosX_H,y
        tax
        lda     #$17
        jsr     UpdateCharSwapHDMA1
        sta     near wTaskProp::PosX_H,y
        dec     z22
@3673:  sec
        rts
@3675:  clc
        rts

; ------------------------------------------------------------------------------

; [ update bg1 hscroll dma table (character swap, hide top/show bottom) ]

UpdateCharSwapHDMA1:
@3677:  sta     $7e9a09,x
        inx
        sta     $7e9a09,x
        inx
        sta     $7e9a09,x
        inx
        sta     $7e9a09,x
        inx
        txa
        rts

; ------------------------------------------------------------------------------

; [ update bg1 hscroll dma table (character swap, show top/hide bottom) ]

UpdateCharSwapHDMA2:
@368d:  sta     $7e9a09,x
        dex
        sta     $7e9a09,x
        dex
        sta     $7e9a09,x
        dex
        sta     $7e9a09,x
        dex
        txa
        rts

; ------------------------------------------------------------------------------

; [ init bg3 vscroll hdma (main menu) ]

InitMainMenuBG3VScrollHDMA:
@36a3:  lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near MainMenuBG3VScrollHDMATbl
        sty     hDMA5::ADDR
        lda     #^MainMenuBG3VScrollHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^MainMenuBG3VScrollHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (main menu)
MainMenuBG3VScrollHDMATbl:
        hdma_word 15, 0
        hdma_word 15, 3
        hdma_word 15, 4
        hdma_word 15, 5
        hdma_word 15, 6
        hdma_word 15, 7
        hdma_word 15, 8
        hdma_word 15, 9
        hdma_word 7, 8
        hdma_word 8, 0
        hdma_word 8, 0
        hdma_word 24, 0
        hdma_end

; ------------------------------------------------------------------------------

; [ menu state $65: scroll menu horizontal ]

        array_label MENU_STATE, MENU_STATE::H_SCROLL
@36e7:  lda     zWaitCounter            ; branch if wait counter is not clear
        bne     @36ef
        lda     zNextMenuState          ; go to next menu state
        sta     zMenuState
@36ef:  longa
        lda     zBG1HScroll
        clc
        adc     zMenuScrollRate
        sta     zBG1HScroll
        sta     zBG2HScroll
        sta     zBG3HScroll
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init cursor for gogo's status menu ]

LoadGogoStatusCursor:
@36ff:  ldy     #near GogoStatusCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for gogo's status menu ]

UpdateGogoStatusCursor:
@3705:  jsr     MoveCursor

InitGogoStatusCursor:
@3708:  ldy     #near GogoStatusCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GogoStatusCursorProp:
        cursor_prop {0, 0}, {1, 4}, NO_X_WRAP

GogoStatusCursorPos:
@3713:  cursor_pos {144, 89}
        cursor_pos {144, 101}
        cursor_pos {144, 113}
        cursor_pos {144, 125}

; ------------------------------------------------------------------------------

MainMenuWoundedText:
        raw_text MAIN_MENU_WOUNDED
        calc_size MainMenuWoundedText

MainMenuLabelTextList:
@3723:  .addr   MainMenuTimeText
        .addr   MainMenuStepsText
        .addr   MainMenuOrderText
        calc_size MainMenuLabelTextList

MainMenuOptionsTextList1:
@3729:  .addr   MainMenuItemText
        .addr   MainMenuSkillsText
        .addr   MainMenuRelicText
        .addr   MainMenuStatusText
        calc_size MainMenuOptionsTextList1

CharBlock1SlashTextList:
@3731:  .addr   CharBlock1HPSlashText
        .addr   CharBlock1MPSlashText
        calc_size CharBlock1SlashTextList

CharBlock2SlashTextList:
@3735:  .addr   CharBlock2HPSlashText
        .addr   CharBlock2MPSlashText
        calc_size CharBlock2SlashTextList

CharBlock3SlashTextList:
@3739:  .addr   CharBlock3HPSlashText
        .addr   CharBlock3MPSlashText
        calc_size CharBlock3SlashTextList

CharBlock4SlashTextList:
@373d:  .addr   CharBlock4HPSlashText
        .addr   CharBlock4MPSlashText
        calc_size CharBlock4SlashTextList

CharBlock1LabelTextList:
@3741:  .addr   CharBlock1LevelText
        .addr   CharBlock1HPText
        .addr   CharBlock1MPText
        calc_size CharBlock1LabelTextList

CharBlock2LabelTextList:
@3747:  .addr   CharBlock2LevelText
        .addr   CharBlock2HPText
        .addr   CharBlock2MPText
        calc_size CharBlock2LabelTextList

CharBlock3LabelTextList:
@374d:  .addr   CharBlock3LevelText
        .addr   CharBlock3HPText
        .addr   CharBlock3MPText
        calc_size CharBlock3LabelTextList

CharBlock4LabelTextList:
@3753:  .addr   CharBlock4LevelText
        .addr   CharBlock4HPText
        .addr   CharBlock4MPText
        calc_size CharBlock4LabelTextList

MainMenuOptionsTextList2:
@3759:  .addr   MainMenuEquipText
        .addr   MainMenuConfigText
        calc_size MainMenuOptionsTextList2

GameLoadChoiceTextList:
@375d:  .addr   GameLoadYesText
        .addr   GameLoadNoText
        .addr   GameLoadMsgText1
        .addr   GameLoadMsgText2
        calc_size GameLoadChoiceTextList

GameSaveChoiceTextList:
        .addr   GameLoadYesText
        .addr   GameLoadNoText
        .addr   GameSaveMsgText1
        .addr   GameSaveMsgText2
        .addr   GameSaveMsgText3
        calc_size GameSaveChoiceTextList

CharBlock1LevelText:            pos_text CHAR_BLOCK_1_LEVEL
CharBlock1HPText:               pos_text CHAR_BLOCK_1_HP
CharBlock1MPText:               pos_text CHAR_BLOCK_1_MP
CharBlock1HPSlashText:          pos_text CHAR_BLOCK_1_HP_SLASH
CharBlock1MPSlashText:          pos_text CHAR_BLOCK_1_MP_SLASH

CharBlock2LevelText:            pos_text CHAR_BLOCK_2_LEVEL
CharBlock2HPText:               pos_text CHAR_BLOCK_2_HP
CharBlock2MPText:               pos_text CHAR_BLOCK_2_MP
CharBlock2HPSlashText:          pos_text CHAR_BLOCK_2_HP_SLASH
CharBlock2MPSlashText:          pos_text CHAR_BLOCK_2_MP_SLASH

CharBlock3LevelText:            pos_text CHAR_BLOCK_3_LEVEL
CharBlock3HPText:               pos_text CHAR_BLOCK_3_HP
CharBlock3MPText:               pos_text CHAR_BLOCK_3_MP
CharBlock3HPSlashText:          pos_text CHAR_BLOCK_3_HP_SLASH
CharBlock3MPSlashText:          pos_text CHAR_BLOCK_3_MP_SLASH

CharBlock4LevelText:            pos_text CHAR_BLOCK_4_LEVEL
CharBlock4HPText:               pos_text CHAR_BLOCK_4_HP
CharBlock4MPText:               pos_text CHAR_BLOCK_4_MP
CharBlock4HPSlashText:          pos_text CHAR_BLOCK_4_HP_SLASH
CharBlock4MPSlashText:          pos_text CHAR_BLOCK_4_MP_SLASH

MainMenuItemText:               pos_text MAIN_MENU_ITEM
MainMenuSkillsText:             pos_text MAIN_MENU_SKILLS
MainMenuEquipText:              pos_text MAIN_MENU_EQUIP
MainMenuRelicText:              pos_text MAIN_MENU_RELIC
MainMenuStatusText:             pos_text MAIN_MENU_STATUS
MainMenuConfigText:             pos_text MAIN_MENU_CONFIG
MainMenuSaveText:               pos_text MAIN_MENU_SAVE
MainMenuTimeText:               pos_text MAIN_MENU_TIME
MainMenuColonText:              pos_text MAIN_MENU_COLON
MainMenuStepsText:              pos_text MAIN_MENU_STEPS
MainMenuGilText:                pos_text MAIN_MENU_GIL

GameLoadYesText:                pos_text GAME_LOAD_YES
GameLoadNoText:                 pos_text GAME_LOAD_NO
GameLoadMsgText1:               pos_text GAME_LOAD_MSG_1
GameLoadMsgText2:               pos_text GAME_LOAD_MSG_2

GameSaveMsgText1:               pos_text GAME_SAVE_MSG_1
GameSaveMsgText2:               pos_text GAME_SAVE_MSG_2
GameSaveMsgText3:               pos_text GAME_SAVE_MSG_3
.if !LANG_EN
GameSaveUnusedText:             pos_text GAME_SAVE_UNUSED
.endif

MainMenuOrderText:              pos_text MAIN_MENU_ORDER

; ------------------------------------------------------------------------------
