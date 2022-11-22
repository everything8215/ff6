
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: main_menu.asm                                                        |
; |                                                                            |
; | description: main menu                                                     |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import MagicProp

; ------------------------------------------------------------------------------

; [ menu state $04: main menu (init) ]

MenuState_04:
@1a8a:  jsr     DisableInterrupts
        jsr     InitPortraits
        jsr     DisableDMA2
        jsr     DisableWindow2PosHDMA
        lda     #$04        ; enable hdma channel #2 (window 1 position)
        tsb     $43
        jsr     DisableDMA2
        jsr     ClearBGScroll
        lda     #$03        ; set bg1 data address and screen size (4 screens)
        sta     hBG1SC
        lda     #$43        ; set bg3 data address and screen size (4 screens)
        sta     hBG3SC
        lda     #$c0        ; disable hdma channel #6 and #7 (bg1 horizontal & vertical scroll)
        trb     $43
        lda     #$02        ; cursor 1 is active
        sta     $46
        jsr     DrawMainMenu
        lda     #0
        ldy     #.loword(MainMenuCursorTask)
        jsr     CreateTask
        jsr     CreateCursorTask
        jsr     _c3354e
        ldy     #$0002      ; bg1 vertical scroll = 2
        sty     $37
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #$05        ; set next menu state
        sta     $27
        lda     #$01        ; fade in
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $07: item (init) ]

MenuState_07:
@1ad6:  jsr     _c31ae2
        jsr     _c31afe
        jsr     _c31b0e
        jmp     _c31b2e

; ------------------------------------------------------------------------------

; [  ]

_c31ae2:
@1ae2:  jsr     DisableInterrupts
        jsr     InitBigText
        jsr     ClearBGScroll
        stz     $4a         ; scroll position = 0
        stz     $49         ; cursor position = 0
        lda     #$f5        ; max scroll position = 245
        sta     $5c
        lda     #$0a        ; page height = 10
        sta     $5a
        lda     #$01        ; page width = 1
        sta     $5b
        jmp     LoadItemListCursor

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
        lda     #$0070
        sta     $7e354a,x
        lda     #$0058
        sta     $7e34ca,x
        shorta
        lda     #$01
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c31b2e:
@1b2e:  lda     #$08        ; set next menu state
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $77: item select (init, return from character select) ]

MenuState_77:
@1b35:  jsr     _c31ae2
        lda     $8e
        sta     $4d
        ldy     $8e
        sty     $4f
        lda     $90
        sta     $4a
        lda     $4a
        sta     $e0
        lda     $50
        sec
        sbc     $e0
        sta     $4e
        jsr     InitItemListCursor
        jsr     DrawItemListMenu
        jsr     _c31b0e
        jmp     _c31b2e

; ------------------------------------------------------------------------------

; [ menu state $09: skills (init) ]

MenuState_09:
@1b5b:  jsr     DisableInterrupts
        clr_a
        lda     $28         ; selected character slot
        tax
        lda     $69,x       ; selected character number
        jsl     UpdateEquip_ext
        jsr     InitPortraits
        jsr     DisableWindow1PosHDMA
        stz     $4a         ; clear scroll positions
        stz     $49
        jsr     InitSkillsBGScrollHDMA
        jsr     _c34c80
        jsr     LoadSkillsCursor
        lda     $1d4e       ; branch if cursor setting is not memory
        and     #$40
        beq     @1b85
        jsr     RestoreSkillsCursorPos
@1b85:  jsr     InitSkillsCursor
        jsr     CreateCursorTask
        jsr     InitBigText
        lda     #$01        ; fade in
        sta     $26
        lda     #$0a        ; set next menu state
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ init description text ]

InitBigText:
@1b99:  jsr     ClearBigTextBuf
        jsr     TfrBigTextGfx
        lda     #0
        ldy     #.loword(BigTextTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ init character portraits ]

InitPortraits:
@1ba8:  jsr     InitCharProp
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        lda     #$05                    ; enable ??? & color palette dma
        tsb     $45
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ menu state $35: equip menu (init) ]

MenuState_35:
@1bb8:  jsr     _c31bbd
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [  ]

_c31bbd:
@1bbd:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        lda     #$06
        tsb     $46
        stz     $4a
        stz     $49
        jsr     InitEquipScrollHDMA
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        jmp     CreateCursorTask

; ------------------------------------------------------------------------------

; [  ]

_c31bd7:
@1bd7:  jsr     DrawEquipMenu
        lda     #$01
        sta     $26
        lda     #$36
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $7e: switch character (equip) ]

MenuState_7e:
@1be5:  jsr     _c31c01
        jsr     DrawEquipTitleEquip
        jsr     _c31c0a
        lda     #$55
        jmp     _c31c15

; ------------------------------------------------------------------------------

; [ menu state $7f: switch character (equip remove) ]

MenuState_7f:
@1bf3:  jsr     _c31c01
        jsr     DrawEquipTitleRemove
        jsr     _c31c0a
        lda     #$56
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
        lda     #$01
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c31c15:
@1c15:  sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $6d: equip menu after optimize ]

MenuState_6d:
@1c1a:  jsr     _c31bbd
        jsr     EquipOptimum
        lda     #$02
        sta     $25
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [ menu state $6e: equip menu after remove all ]

MenuState_6e:
@1c26:  jsr     _c31bbd
        jsr     EquipRemoveAll
        lda     #$02
        sta     $25
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [ menu state $38: party equipment overview (init) ]

MenuState_38:
@1c32:  jsr     DisableInterrupts
        jsr     InitPartyEquipScrollHDMA
        jsr     DrawPartyEquipMenu
        lda     #$01
        sta     $26
        lda     #$39
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $0b: status (init) ]

MenuState_0b:
@1c46:  jsr     DisableInterrupts
        jsr     InitStatusBG3ScrollHDMA
        jsr     DrawStatusMenu
        jsr     InitStatusCursor
        lda     #$01
        sta     $26
        lda     #$0c
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ init cursor for status menu ]

InitStatusCursor:
@1c5d:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        lda     $0000,y
        cmp     #$0c
        bne     @1c78                   ; branch if not Gogo
        jsr     LoadGogoStatusCursor
        jsr     InitGogoStatusCursor
        lda     #$06
        tsb     $46
        jmp     CreateCursorTask

; not Gogo
@1c78:  lda     #$06                    ; no cursor
        trb     $46
        rts

; ------------------------------------------------------------------------------

; [ menu state $0d: config (init) ]

MenuState_0d:
@1c7d:  jsr     DisableInterrupts
        stz     $4a         ; set page to 0
        jsr     InitWindow2PosHDMA
        jsr     DrawConfigMenu
        jsr     LoadConfigPage1Cursor
        lda     $5f         ; restore cursor position
        sta     $4e
        jsr     InitConfigPage1Cursor
        jsr     CreateCursorTask
        lda     #$01
        sta     $26         ; fade in
        lda     #$0e
        sta     $27         ; config menu state
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $13: save select (init) ]

MenuState_13:
@1ca0:  jsr     DisableInterrupts
        ldy     #$0002
        sty     $37         ; bg1 vscroll
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #$e3
        trb     $43         ; disable hdma 2, 3, 4
        jsr     DrawGameSaveMenu
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadGameSaveCursor
        ldy     $91
        bne     @1cc7
        ldy     $93
        bne     @1cc7
        ldy     $95
        beq     @1ccd
@1cc7:  lda     $0224       ; current save slot
        dec
        sta     $4e         ; set cursor position
@1ccd:  jsr     InitGameSaveCursor
        jsr     CreateCursorTask
        lda     $4b
        inc
        sta     $66         ; save slot
        lda     #$52        ; menu state $52 (fade in, save menu)
        sta     $26
        lda     #$14        ; next menu state $14 (save select)
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $15: save confirm (init) ]

MenuState_15:
@1ce3:  jsr     DisableInterrupts
        jsr     InitCharProp
        jsr     DrawGameSaveConfirmMenu
        jsr     LoadSaveConfirmCursor
        jsr     InitSaveConfirmCursor
        jsr     CreateCursorTask
        jsr     _c318d1
        lda     #$16        ; next menu state $16 (save confirm)
        sta     $27
        lda     #$01        ; menu state $01 (fade in)
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $20: restore game (init) ]

MenuState_20:
@1d03:  jsr     DisableInterrupts
        ldy     #$0002
        sty     $37
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #$e3
        trb     $43
        ldy     $00
        sty     $35
        sty     $39
        sty     $3d
        lda     #$02
        sta     $46
        jsr     DrawGameLoadMenu
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadGameLoadCursor
        ldy     $91
        bne     @1d36       ; branch if slot 1 is valid
        ldy     $93
        bne     @1d36       ; branch if slot 2 is valid
        ldy     $95
        beq     @1d3c       ; branch if slot 3 is not valid
@1d36:  lda     $307ff0     ; most recently saved slot
        sta     $4e         ; set current position
@1d3c:  jsr     InitGameLoadCursor
        jsr     CreateCursorTask
        lda     $4b
        sta     $66
        lda     #$21        ; next menu state $21 (restore game)
        sta     $27
        lda     #$52        ; current menu state $52 (fade in, save menu)
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $22: restore confirm (init) ]

MenuState_22:
@1d51:  jsr     DisableInterrupts
        jsr     InitCharProp
        jsr     DrawGameLoadConfirmMenu
        jsr     LoadSaveConfirmCursor
        jsr     InitSaveConfirmCursor
        jsr     CreateCursorTask
        jsr     _c318d1
        lda     #$23
        sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $00: fade out (init) ]

MenuState_00:
@1d71:  jsr     CreateFadeOutTask
        ldy     #$0008      ; set wait counter
        sty     $20
        lda     #$02        ; set next menu state
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $01: fade in (init) ]

MenuState_01:
@1d7e:  jsr     CreateFadeInTask
        ldy     #$0008      ; set wait counter
        sty     $20
        lda     #$02        ; set next menu state
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $02: wait for fade ]

MenuState_02:
@1d8b:  ldy     $20         ; return if frame counter is not 0
        bne     @1d93
        lda     $27         ; go to next menu state
        sta     $26
@1d93:  rts

; ------------------------------------------------------------------------------

; [ menu state $03: main menu re-init (from char select) ]

MenuState_03:
@1d94:  lda     #0                      ; priority 0
        ldy     #.loword(MainMenuCursorTask)
        jsr     CreateTask
        jsr     CreateCursorTask
        lda     #$05                    ; main menu state
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $05: main menu ]

MenuState_05:
@1da4:  jsr     UpdateTimeText

; A button
        lda     $08
        bit     #$80
        jne     SelectMainMenuOption

; left button
        lda     $09
        bit     #$02
        beq     @1dbc       ; branch if left button is not pressed
        jsr     PlayMoveSfx
        jmp     MainMenuLeftBtn

; B button
@1dbc:  lda     $09
        bit     #$80
        beq     @1dd1       ; return if b button is not pressed
        stz     $0205
        jsr     PlayCancelSfx
        jsr     UpdateEquipAfterMenu
        lda     #$ff
        sta     $27         ; terminate menu
        stz     $26         ; fade out
@1dd1:  rts

; ------------------------------------------------------------------------------

; [ update field equipment effects ]

UpdateEquipAfterMenu:
@1dd2:  stz     $11df       ; clear all field equipment effects
        ldx     $00
@1dd7:  lda     $69,x       ; character in each party slot
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

MenuState_06:
@1de8:  jsr     UpdateTimeText

; B button
        lda     $09
        bit     #$80
        beq     @1dfd       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        lda     #$05
        trb     $46         ; disable cursor 2 and flashing cursor
        lda     #$03
        sta     $26         ; main menu (re-init)
        rts

; left button
@1dfd:  lda     $09         ; branch if left button is not pressed
        bit     #$02
        beq     @1e1f
        lda     $25         ; branch if not equip or relic
        cmp     #$02
        beq     @1e0d
        cmp     #$03
        bne     @1e1f
@1e0d:  jsr     PlayMoveSfx
        lda     #$06
        trb     $46         ; disable cursor 1 and 2
        lda     #$37
        sta     $26         ; set menu state to $37 (select all)
        lda     $4e         ; save cursor position
        sta     $5e
        jmp     CreateMultiCursorTask

; A button
@1e1f:  lda     $08         ; return if a button is not pressed
        bit     #$80
        beq     @1e2c
        lda     $4b         ; cursor selection
        sta     $28         ; set selected character slot
        jmp     _c31e2d
@1e2c:  rts

; ------------------------------------------------------------------------------

; [  ]

_c31e2d:
@1e2d:  jsr     CheckSkillValid
        bcs     @1e42       ; branch if not
        clr_a
        lda     $25         ; main menu selection
        tax
        lda     f:_c31e49,x   ; init menu state
        sta     $27
        stz     $26         ; fade out
        jsr     PlaySelectSfx
        rts
@1e42:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; init menu states for main menu commands
_c31e49:
@1e49:  .byte   $ff,$09,$35,$58,$0b

; ------------------------------------------------------------------------------

; [ check if character slot is valid (skills/equip/relic/status) ]

; carry clear = valid
; carry set = invalid

CheckSkillValid:
@1e4e:  clr_a
        lda     $25         ; main menu selection
        cmp     #$01
        beq     @1e89       ; branch if skills
        cmp     #$02
        beq     @1e5f       ; branch if equip
        cmp     #$03
        beq     @1e74       ; branch if relic
        bra     @1eb3       ; branch if status (always valid)

; equip
@1e5f:  clr_a
        lda     $28
        asl
        tax
        longa
        lda     $6d,x
        shorta
        tax
        lda     a:$0000,x     ; not valid for characters $0d (umaro) and higher
        cmp     #$0d
        bcs     @1eb1
        bra     @1e9c

; relic
@1e74:  clr_a
        lda     $28
        asl
        tax
        longa
        lda     $6d,x
        shorta
        tax
        lda     a:$0000,x     ; not valid for characters $0e and higher
        cmp     #$0e
        bcs     @1eb1
        bra     @1e9c

; skills
@1e89:  jsr     _c34d3d
        lda     #$24
        ldx     $00
@1e90:  cmp     $79,x       ; branch if at least one is not disabled
        bne     @1e9c
        inx
        cpx     #$0007
        bne     @1e90
        bra     @1eb1

; check status
@1e9c:  clr_a
        lda     $28
        asl
        tax
        longa
        lda     $6d,x
        shorta
        tax
        lda     a:$0014,x     ; not valid if wound, petrify, or zombie status
        and     #$c2
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

MenuState_37:
@1eb5:  jsr     UpdateTimeText
        lda     $09
        bit     #$80
        bne     @1ec4       ; branch if b button is down
        lda     $09
        bit     #$01
        beq     @1ee5       ; branch if right button is not down

; B button or right button
@1ec4:  jsr     PlayCancelSfx
        jsr     InitCharSelectCursor
        jsr     CreateCursorTask
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        jsr     ExecTasks
        lda     $5e         ; restore cursor position
        sta     $4e
        lda     #$06        ; menu state $06 (char select)
        sta     $26
        lda     #$08        ; disable multi-cursor
        trb     $46
        rts

; A button
@1ee5:  lda     $08         ; return if a button is not down
        bit     #$80
        beq     @1ef5
        jsr     PlaySelectSfx
        stz     $26
        lda     #$38        ; menu state $38 (equip all, init)
        sta     $27
        rts
@1ef5:  rts

; ------------------------------------------------------------------------------

; [ menu state $08: item (select) ]

.proc MenuState_08_proc

_1ef6:  rts

start:
_1ef7:  lda     #$10
        trb     $45
        clr_a
        sta     $2a
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     _1ef6
        jsr     UpdateItemListCursor
        jsr     InitItemDesc

; B button
        lda     $09
        bit     #$80
        beq     _1f3b
        jsr     PlayCancelSfx
        ldy     $4f
        sty     $022f
        lda     $4a
        sta     $0231
        jsr     LoadItemOptionCursor
        lda     $1d4e
        and     #$40
        beq     _1f2c
        ldy     $0234
        sty     $4d

goto_item_option:
_1f2c:  jsr     InitItemOptionCursor
        lda     #$17
        sta     $26
        jsr     ClearItemCount
        jmp     InitDMA1BG3ScreenA

; A button
_1f3b:  lda     $08
        bit     #$80
        beq     _1f4f
        jsr     PlaySelectSfx
        lda     $4b
        sta     $28
        lda     #$19
        sta     $26
        jmp     _c32f21

_1f4f:  rts

.endproc

        MenuState_08 := MenuState_08_proc::start
        GotoItemOption := MenuState_08_proc::goto_item_option

; ------------------------------------------------------------------------------

; [ scroll list text up/down one page ]

.proc ScrollListPage_proc

; (branch from c3/1f9b)
_1f50:  stz     $50
        stz     $4e
        sec
        rts

; (branch from c3/1f72)
_1f56:  lda     $54
        dec
        sta     $4e
        clc
        adc     $4a
        sta     $50
        sec
        rts

; waiting (branch from c3/1f66)
_1f62:  clc
        rts

start:
_1f64:  lda     $20
        bne     _1f62                   ; branch if wait frame counter not zero

; R button
        lda     $0a
        bit     #$10
        beq     _1f93                   ; branch if R button is not pressed
        lda     $4a
        cmp     $5c
        beq     _1f56
        lda     $5c
        sec
        sbc     $4a
        cmp     $5a
        bcs     _1f7f
        bra     _1f81
_1f7f:  lda     $5a
_1f81:  sta     $e0
        lda     $4a
        clc
        adc     $e0
        sta     $4a
        lda     $50
        clc
        adc     $e0
        sta     $50
        bra     _1fb7

; L button
_1f93:  lda     $0a
        bit     #$20
        beq     _1f62                   ; branch if L button is not pressed
        lda     $4a
        beq     _1f50                   ; branch if at the top of the list
        cmp     $5a
        bcs     _1fa5
        lda     $4a
        bra     _1fa7
_1fa5:  lda     $5a
_1fa7:  sta     $e0
        lda     $4a
        sec
        sbc     $e0
        sta     $4a
        lda     $50
        sec
        sbc     $e0
        sta     $50
_1fb7:  jsr     PlayMoveSfx
        clr_a
        lda     $2a                     ; list type
        asl
        tax
        jsr     (jmp_tbl,x)
        sec
        rts

; ------------------------------------------------------------------------------

; jump table for list type
jmp_tbl := .loword(*)
@1fc4:  .addr   jmp_00
        .addr   jmp_01
        .addr   jmp_02
        .addr   jmp_03
        .addr   jmp_04
        .addr   jmp_05

; ------------------------------------------------------------------------------

; 0: item list
jmp_00:
@1fd0:  jsr     LoadItemBG1VScrollHDMATbl
        jmp     DrawItemList

; ------------------------------------------------------------------------------

; 1: magic
jmp_01:
@1fd6:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawMagicList

; ------------------------------------------------------------------------------

; 2: lore
jmp_02:
@1fdc:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawLoreList

; ------------------------------------------------------------------------------

; 3: rage
jmp_03:
@1fe2:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawRiotList

; ------------------------------------------------------------------------------

; 4: esper
jmp_04:
@1fe8:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawGenjuList

; ------------------------------------------------------------------------------

; 5: equip/relic item list
jmp_05:
@1fee:  jsr     LoadEquipBG1VScrollHDMATbl
        jmp     DrawEquipItemList

.endproc

        ScrollListPage := ScrollListPage_proc::start

; ------------------------------------------------------------------------------

; [ menu state $0a: skills (select option) ]

MenuState_0a:
@1ff4:  lda     #$10        ;
        tsb     $45
        lda     #$c0        ; page can't scroll up or down
        trb     $46
        jsr     UpdateSkillsCursor

; return to main menu (b button)
        lda     $09
        bit     #$80
        beq     @200f       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        lda     #$04        ; fade out and init main menu
        sta     $27
        stz     $26
        rts

; open selected skills menu (a button)
@200f:  lda     $08         ; branch if a button is not pressed
        bit     #$80
        beq     @201c
        lda     $4e
        sta     $5e
        jmp     SelectSkillsOption

; go to next character (top r button)
@201c:  lda     #$09        ; next menu state (init another character's skills menu)
        sta     $e0
        bra     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ check r & l shoulder buttons ]

; $e0: menu state to go to if user pressed top R or L

CheckShoulderBtns:
@2022:  lda     $b5         ; screen mosaic
        and     #$f0
        bne     @2089       ; return if mosaic'ing

; go to next character (top R button)
        lda     $08
        bit     #$10
        beq     @2059
        lda     $25
        cmp     #$03
        bne     @203f
        jsr     _c39eeb
        lda     $99
        beq     @203f
        jsr     PlayMoveSfx
        rts
@203f:  clr_a
        lda     $28                     ; increment selected character slot
        inc
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @203f
        jsr     CheckSkillValid
        bcs     @203f
        lda     $e0
        sta     $26
        jsr     PlayMoveSfx
        rts

; go to previous character (top L button)
@2059:  lda     $08
        bit     #$20
        beq     @2089
        lda     $25
        cmp     #$03
        bne     @2070
        jsr     _c39eeb
        lda     $99
        beq     @2070
        jsr     PlayMoveSfx
        rts
@2070:  clr_a
        lda     $28                     ; decrement selected character slot
        dec
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @2070
        jsr     CheckSkillValid
        bcs     @2070
        lda     $e0
        sta     $26
        jsr     PlayMoveSfx
@2089:  rts

; ------------------------------------------------------------------------------

; [ open selected skills menu (A button) ]

SelectSkillsOption:
@208a:  clr_a
        lda     $4b                     ; current selection
        tax
        lda     $79,x                   ; branch if not enabled
        cmp     #$20
        bne     @209e
        jsr     PlaySelectSfx
        lda     $4b
        asl
        tax
        jmp     (.loword(SkillsOptionTbl),x)

; invalid selection
@209e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; skills menu jump table (espers, magic, swdtech, blitz, lore, rage, dance)
SkillsOptionTbl:
@20a5:  .addr   SkillsOption_00
        .addr   SkillsOption_01
        .addr   SkillsOption_02
        .addr   SkillsOption_03
        .addr   SkillsOption_04
        .addr   SkillsOption_05
        .addr   SkillsOption_06

; ------------------------------------------------------------------------------

; [ skills menu $00: espers (init) ]

SkillsOption_00:
@20b3:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$1000
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
        shorta
        jsr     LoadGenjuCursor
        jsr     InitGenjuCursor
        lda     #$06
        sta     $5c                     ; max page scroll position = 6
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        ldy     #$0100
        sty     $39                     ; bg2 horizontal scroll = $0100
        sty     $3d                     ; bg3 horizontal scroll = $0100
        jsr     DrawGenjuMenu
        lda     #$1e
        sta     $26
        jsr     _c32eeb
        rts

; ------------------------------------------------------------------------------

; [ skills menu $02: swdtech (init) ]

SkillsOption_02:
@20ee:  stz     $4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     _c352d7
        lda     #$3e
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $03: blitz (init) ]

SkillsOption_03:
@2105:  stz     $4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     DrawBlitzMenu
        lda     #$33
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $01: magic (init) ]

SkillsOption_01:
@211c:  jsr     _c32130
        jsr     _c32148
        jsr     _c32158
        jsr     _c351c6
        jsr     InitDMA1BG3ScreenB
        lda     #$1a
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32130:
@2130:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$050d
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
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

; [  ]

_c32158:
@2158:  lda     #$13
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        ldy     #$0100
        sty     $39
        sty     $3d
        jmp     _c34d7f

; ------------------------------------------------------------------------------

; [ skills menu $04: lore (init) ]

SkillsOption_04:
@216e:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$0600
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
        shorta
        jsr     LoadLoreCursor
        jsr     InitLoreCursor
        lda     #$10
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$01
        sta     $5b
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     _c351f9
        lda     #$1b
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $05: rage (init) ]

SkillsOption_05:
@21a6:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$00cc
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
        shorta
        jsr     LoadRiotCursor
        jsr     InitRiotCursor
        lda     #$78
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     _c35391
        lda     #$1d
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $06: dance (init) ]

SkillsOption_06:
@21de:  stz     $4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     DrawDanceMenu
        lda     #$1c
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $0c: status ]

MenuState_0c:
@21f5:  jsr     InitDMA1BG3ScreenA

; shoulder R button
        lda     $08
        bit     #$10
        beq     @221e
        lda     $28
        sta     $79
@2202:  clr_a
        lda     $28
        inc
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @2202
        lda     $28
        cmp     $79
        beq     @2218
        jsr     PlayMoveSfx
@2218:  jsr     InitStatusCursor
        jmp     _c35d83

; shoulder L button
@221e:  lda     $08
        bit     #$20
        beq     @2244
        lda     $28
        sta     $79
@2228:  clr_a
        lda     $28
        dec
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @2228
        lda     $28
        cmp     $79
        beq     @223e
        jsr     PlayMoveSfx
@223e:  jsr     InitStatusCursor
        jmp     _c35d83

; B button
@2244:  lda     $09
        bit     #$80
        beq     @2254
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts
@2254:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        lda     $0000,y
        cmp     #$0c
        bne     @22b3                   ; return if not Gogo
        jsr     UpdateGogoStatusCursor

; A button
        lda     $08
        bit     #$80
        beq     @22b3
        jsr     PlaySelectSfx
        lda     $4b
        sta     $e7
        stz     $e8
        clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        longa
        tya
        clc
        adc     $e7
        tay
        shorta
        lda     $0016,y
        cmp     #$12
        beq     @22b3
        jsr     _c32f06
        lda     $4e
        sta     $5e
        lda     $4b
        sta     $64
        lda     #$06
        sta     $20
        ldy     #$000c
        sty     $9c
        lda     #$6a
        sta     $27
        lda     #$65
        sta     $26
        jsr     LoadGogoCmdListCursor
        lda     $7e9d89
        sta     $54
        jmp     InitGogoCmdListCursor
@22b3:  rts

; ------------------------------------------------------------------------------

; [ menu state $6b: unused ]

MenuState_6b:
@22b4:  lda     $09
        bit     #$80
        beq     @22c4
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts
@22c4:  rts

; ------------------------------------------------------------------------------

; [ menu state $0e: config ]

MenuState_0e:
@22c5:  jsr     InitDMA1BG1ScreenAB
        lda     $0b
        bit     #$04
        beq     @22e0
        lda     $4e
        cmp     #$08
        bne     @22e0
        lda     #$50
        sta     $26
        lda     #$11
        sta     $20
        jsr     PlayMoveSfx
        rts
@22e0:  lda     $0b
        bit     #$08
        beq     @22fa
        lda     $4e
        bne     @22fa
        lda     $4a
        beq     @22fa
        lda     #$51
        sta     $26
        lda     #$11
        sta     $20
        jsr     PlayMoveSfx
        rts
@22fa:  lda     $4a
        beq     @2303
        jsr     UpdateConfigPage2Cursor
        bra     @2306
@2303:  jsr     UpdateConfigPage1Cursor

; B button
@2306:  lda     $09
        bit     #$80
        beq     @2316
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts

; left or right button
@2316:  lda     $0b
        bit     #$01
        bne     @2322
        lda     $0b
        bit     #$02
        beq     @2325
@2322:  jmp     ChangeConfigOption

; A button
@2325:  lda     $08
        bit     #$80
        jne     SelectConfigOption
        jmp     ScrollConfigPage

; ------------------------------------------------------------------------------

; [ select config option ]

SelectConfigOption:
@2331:  lda     $4e
        sta     $5f
        lda     $4a
        bne     SelectConfigOptionPage2

; page 1
        clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectConfigOptionTbl),x)

; ------------------------------------------------------------------------------

; config options that can't be selected
SelectConfigOptionReturn:
@2341:  rts

; ------------------------------------------------------------------------------

SelectConfigOptionPage2:
@2342:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectConfigOptionTbl+18),x)

; ------------------------------------------------------------------------------

; config option jump table (page 1)
SelectConfigOptionTbl:
@234a:  .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOption_03
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOption_08

; config option jump table (page 2)
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
        lda     #$47
        sta     $27
        stz     $26
        rts

; ------------------------------------------------------------------------------

; [ open character controller select menu ]

SelectConfigOption_08:
@2379:  lda     $1d54
        bpl     SelectConfigOptionReturn
        jsr     PlaySelectSfx
        lda     #$4b
        sta     $27
        stz     $26
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
        jsr     _c323a7
        jsr     LoadWindowGfx
        jmp     UpdateConfigColorBars

; font color
@239b:  ldy     #$7fff                  ; revert font color to default
        sty     $1d55
        jsr     InitFontColor
        jmp     UpdateConfigColorBars

; ------------------------------------------------------------------------------

; [  ]

_c323a7:
@23a7:  clr_a
        lda     $1d4e
        and     #$0f
        longa
        tay
        stz     $eb
        stz     $ed
@23b4:  dey
        bmi     @23c9
        lda     #$000e
        clc
        adc     $eb
        sta     $eb
        lda     #$0020
        clc
        adc     $ed
        sta     $ed
        bra     @23b4
@23c9:  ldx     #$312b
        stx     hWMADDL
        lda     $eb
        tay
        lda     $ed
        tax
        shorta
        lda     #$0e
        sta     $e9
@23db:  lda     f:WindowPal+2,x
        sta     $1d57,y
        sta     hWMDATA
        inx
        iny
        dec     $e9
        bne     @23db
        rts

; ------------------------------------------------------------------------------

; [ config menu page scroll ]

ScrollConfigPage:
@23ec:  lda     $08                     ; check L and R buttons
        bit     #$10
        bne     @23f6
        bit     #$20
        beq     @240b
@23f6:  jsr     PlayMoveSfx
        stz     $5f
        lda     $4a
        bne     @2406
        lda     #1
        sta     $4a
        jmp     ShowConfigPage2
@2406:  stz     $4a
        jsr     ShowConfigPage1
@240b:  rts

; ------------------------------------------------------------------------------

; [ menu state $0f: order (select character) ]

MenuState_0f:
@240c:  jsr     UpdateTimeText
        jsr     _c36989
        lda     $09
        bit     #$80
        bne     @241e
        lda     $09
        bit     #$01
        beq     @2437
@241e:  jsr     PlayCancelSfx
        lda     #$06
        sta     $20
        ldy     #$000c
        sty     $9c
        lda     #$05
        trb     $46
        lda     #$03
        sta     $27
        lda     #$65
        sta     $26
        rts
@2437:  lda     $08
        bit     #$80
        beq     @2452
        jsr     PlaySelectSfx
        lda     $4b
        sta     $28
        lda     #$10
        sta     $26
        jsr     _c32f21
        jsr     LoadCharSelectCursorProp
        lda     $4e
        sta     $5e
@2452:  rts

; ------------------------------------------------------------------------------

; [ menu state $10: order (move/row) ]

MenuState_10:
@2453:  jsr     UpdateTimeText
        lda     $09
        bit     #$80
        beq     @246f       ; branch if b button is not pressed

; cancel
        jsr     PlayCancelSfx
        lda     #$01
        trb     $46         ; disable flashing cursor task
        lda     #$0f
        sta     $26         ; menu state $0f (order, select character)
        jsr     InitCharSelectCursor
        lda     $5e
        sta     $4e         ; restore cursor position
        rts

; no cancel
@246f:  lda     $08
        bit     #$80
        beq     @24a8       ; return if a button is not pressed
        jsr     PlaySelectSfx
        lda     $28
        cmp     $4b
        bne     @2491       ; branch if order changed

; character row changed
        lda     #$01
        trb     $46         ; disable flashing cursor task
        lda     #$12        ; menu state $12 (order, wait for portrait slide)
        sta     $26
        jsr     _c32e10
        ldy     #12
        sty     $20         ; wait 12 frames
        jmp     InitCharSelectCursor

; party order changed
@2491:  lda     #$10
        trb     $46
        lda     #$0c
        trb     $45
        jsr     CreateCharSwapTask
        lda     #$18        ; set frame counter to 24 (12 frames to hide, 12 frames to show)
        sta     $22
        lda     #$01
        trb     $46
        lda     #$11        ; menu state $11 (change party order)
        sta     $26
@24a8:  rts

; ------------------------------------------------------------------------------

; [ menu state $11: change party order ]

MenuState_11:
@24a9:  jsr     UpdateTimeText
        lda     $22
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
        tsb     $45
        rts
@24e0:  lda     #$0f        ; menu state $0f (order, select character)
        sta     $26
        lda     #$10
        tsb     $46
        lda     #$04
        tsb     $45
        rts
@24ed:  rts

; ------------------------------------------------------------------------------

; [  ]

_c324ee:
@24ee:  jsr     _c32e3c
        lda     #$01
        trb     $47
        jmp     ExecTasks

; ------------------------------------------------------------------------------

; [ update characters controlled by player 2 ]

UpdatePlayer2Chars:
@24f8:  clr_ax
        stx     $e0
        stx     $e2
        lda     $1d4f
        clc
@2502:  ror
        bcc     @2507
        inc     $e0,x
@2507:  inx
        cpx     #$0004
        bne     @2502
        clr_a
        lda     $4b
        tax
        lda     $e0,x
        sta     $e5
        lda     $28
        tax
        lda     $e0,x
        sta     $e6
        lda     $e5
        sta     $e0,x
        lda     $4b
        tax
        lda     $e6
        sta     $e0,x
        clc
        lda     $e3
        asl
        adc     $e2
        asl
        adc     $e1
        asl
        adc     $e0
        sta     $1d4f
        rts

; ------------------------------------------------------------------------------

; [ menu state $12: order (wait for portrait slide) ]

MenuState_12:
@2537:  ldy     $20
        bne     @253f
        lda     #$0f        ; menu state $0f (order, select character)
        sta     $26
@253f:  rts

; ------------------------------------------------------------------------------

; [ menu state $14: save select ]

MenuState_14:
@2540:  lda     $4b
        inc
        sta     $66
        jsr     DrawSaveMenuChars
        jsr     UpdateGameSaveCursor

; B button
        lda     $09
        bit     #$80
        beq     @255d                   ; branch if B button is not pressed
        jsr     PlayCancelSfx
        lda     $9f
        sta     $27
        lda     #$53
        sta     $26
        rts

; A button
@255d:  lda     $08
        bit     #$80
        beq     @259c                   ; return if A button is not pressed
        clr_a
        lda     $4b
        asl
        tax
        ldy     $91,x                   ; sram checksum
        bne     @2580                   ; branch if sram is valid

; slot is empty, save instantly
        lda     $66
        sta     $021f                   ; save slot to load
        jsr     PlaySuccessSfx
        jsr     SaveGame
        lda     $9e                     ; previous menu state
        sta     $27
        lda     #$53                    ; menu state $53 (fade out, save menu)
        sta     $26
        rts

; sram valid, prompt before overwriting
@2580:  jsr     PlaySelectSfx
        jsr     PushSRAM
        lda     $4b
        inc
        sta     $66
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     _c36989
        lda     #$15                    ; next menu state $15 (save confirm, init)
        sta     $27
        lda     #$53                    ; menu state $53 (fade out, save menu)
        sta     $26
@259c:  rts

; ------------------------------------------------------------------------------

; [ menu state $16 & $1f: save confirm ]

MenuState_16:
MenuState_1f:
@259d:  jsr     UpdateSaveConfirmCursor
        lda     $09
        bit     #$80
        bne     @25c2       ; branch if b button is down
        lda     $08
        bit     #$80
        beq     @25de       ; return if a button is not pressed
        lda     $4b
        bne     @25c7
        lda     $66
        sta     $021f
        jsr     PlaySuccessSfx
        jsr     SaveGame
        lda     $9e         ; previous menu state
        sta     $27
        stz     $26         ; menu state $00 (fade out)
        rts
@25c2:  jsr     PlayCancelSfx
        bra     @25ca
@25c7:  jsr     PlaySelectSfx
@25ca:  jsr     PopSRAM
        jsr     InitCharProp
        jsr     _c36989
        lda     #$13        ; menu state $13 (save select, init)
        sta     $27
        stz     $26
        lda     $66
        sta     $0224
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
        lda     $66
        jmp     CopyGameDataToSRAM

; ------------------------------------------------------------------------------

; [ menu state $17: item options (use, arrange, rare) ]

MenuState_17:
@25f4:  lda     #$c0
        trb     $46
        lda     #$10
        tsb     $45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateItemOptionCursor

; B button
        lda     $09
        bit     #$80
        beq     @2611
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26

; A button
@2611:  lda     $08
        bit     #$80
        beq     @261d
        jsr     PlaySelectSfx
        jsr     SelectItemOption
@261d:  rts

; ------------------------------------------------------------------------------

; [ select an item option (use, arrange, rare) ]

SelectItemOption:
@261e:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectItemOptionTbl),x)

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
@263b:  lda     $0231
        sta     $4a
        ldy     $4d
        sty     $4f
        lda     $4a
        clc
        adc     $50
        sta     $50
@264b:  jsr     InitItemListCursor
        jsr     InitItemListText
        jsr     InitItemDesc
        jsr     InitDMA1BG3ScreenA
        jsr     WaitVblank
        jsr     CreateScrollArrowTask1
        longa
        lda     #$0070
        sta     $7e354a,x
        lda     #$0058
        sta     $7e34ca,x
        shorta
        lda     #$08
        sta     $26
        lda     #0
        ldy     #.loword(BigTextTask)
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
        ldy     $0232
        sty     $4d
@269d:  jsr     InitRareItemCursor
        jsr     InitRareItemList
        jsr     InitBigText
        jsr     InitRareItemDesc
        jsr     InitDMA1BG3ScreenA
        jsr     WaitVblank
        lda     #$c0
        trb     $46
        lda     #$18
        sta     $26
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
        sta     $e0
        jsr     FindItemsWithIcon
        plx
        inx
        cpx     #$0011
        bne     @26e3
        rts

; ------------------------------------------------------------------------------

ItemIconTbl:
@26f5:  .byte   $ff,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7

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
        lda     #13
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     f:ItemName,x
        cmp     $e0
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

MenuState_18:
@2741:  lda     #$10
        trb     $45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateRareItemCursor
        jsr     InitRareItemDesc
        lda     $09
        bit     #$80
        beq     @2778
        jsr     PlayCancelSfx
        lda     #$17
        sta     $26
        ldy     $4d
        sty     $0232
        jsr     LoadItemOptionCursor
        lda     $1d4e
        and     #$40
        beq     @276f
        ldy     $0234
        sty     $4d
@276f:  jsr     InitItemOptionCursor
        jsr     ClearItemCount
        jmp     InitDMA1BG3ScreenA
@2778:  rts

; ------------------------------------------------------------------------------

; [ menu state $19: item (move) ]

MenuState_19:
@2779:  jsr     InitDMA1BG1ScreenA
        jsr     UpdateItemListCursor
        jsr     InitItemDesc
        lda     $09
        bit     #$80
        beq     @2794
        jsr     PlayCancelSfx
        lda     #$01
        trb     $46
        lda     #$08
        sta     $26
        rts
@2794:  lda     $08
        bit     #$80
        beq     @27e1       ; branch if a button is not pressed
        jsr     PlaySelectSfx
        lda     $28
        cmp     $4b
        bne     @27aa
        lda     #$01
        trb     $46
        jmp     UseItem
@27aa:  lda     #$10
        tsb     $45
        lda     #$01
        trb     $46
        lda     #$08
        sta     $26
        clr_a
        lda     $28
        tay
        lda     $1869,y     ; swap item slots
        sta     $e0
        lda     $1969,y
        sta     $e1
        clr_a
        lda     $4b
        tax
        lda     $1869,x
        sta     $1869,y
        lda     $e0
        sta     $1869,x
        lda     $1969,x
        sta     $1969,y
        lda     $e1
        sta     $1969,x
        jmp     DrawItemList
@27e1:  rts

; ------------------------------------------------------------------------------

; [ menu state $1a: magic (select) ]

MenuState_1a:
@27e2:  lda     #$10
        trb     $45
        lda     #$01
        sta     $2a
        jsr     InitDMA1BG1ScreenA
        lda     $021e
        ror
        bcc     @27f8
        jsr     InitDMA2BG3ScreenB
        bra     @27fb
@27f8:  jsr     TfrBigTextGfx
@27fb:  jsr     ScrollListPage
        bcs     @2861
        jsr     UpdateMagicCursor
        jsr     LoadMagicDesc
        jsr     _c351c6
        lda     $09
        bit     #$40
        beq     @2822
        jsr     PlaySelectSfx
        lda     $9e
        eor     #$ff
        sta     $9e
        lda     #$10
        tsb     $45
        jsr     _c34f1c
        jmp     DrawMagicList
@2822:  lda     $08
        bit     #$80
        beq     @2855
        clr_a
        lda     $4b
        tax
        lda     $7e9e09,x
        cmp     #$20
        bne     @2862
        jsr     PlaySelectSfx
        ldy     $4f
        sty     $8e
        lda     $4a
        sta     $90
        lda     $4b
        sta     $99
        jsr     GetSelMagic
        cmp     #$12
        beq     @2869       ; branch if x-zone
        cmp     #$2a
        beq     @2874       ; branch if warp
        lda     #$3a
        sta     $27
        stz     $26
        rts
@2855:  lda     $09
        bit     #$80
        beq     @2861
        jsr     InitDMA1BG1ScreenA
        jsr     ReloadSkillsMenu
@2861:  rts
@2862:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; x-zone
@2869:  lda     $0201
        bit     #$01
        beq     @2862       ; branch if x-zone is disabled
        lda     #$04        ; return code $04
        bra     @287d

; warp
@2874:  lda     $0201
        bit     #$02
        beq     @2862       ; branch if warp is disabled
        lda     #$03        ; return code $03
@287d:  sta     $0205
        jsr     _c32cea
        lda     #$ff        ; exit menu
        sta     $27
        stz     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $1b: lore (select) ]

MenuState_1b:
@288a:  lda     #$10
        trb     $45
        lda     #$02
        sta     $2a
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @28a9
        jsr     UpdateLoreCursor
        jsr     LoadLoreDesc
        lda     $09
        bit     #$80
        beq     @28a9
        jsr     ReloadSkillsMenu
@28a9:  rts

; ------------------------------------------------------------------------------

; [ menu state $1c: dance (select) ]

MenuState_1c:
@28aa:  jsr     InitDMA1BG1ScreenA
        jsr     UpdateAbilityCursor
        lda     $09
        bit     #$80
        beq     @28b9
        jsr     ReloadSkillsMenu
@28b9:  rts

; ------------------------------------------------------------------------------

; [ menu state $1d: rage (select) ]

MenuState_1d:
@28ba:  lda     #$03
        sta     $2a
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @28d2
        jsr     UpdateRiotCursor
        lda     $09
        bit     #$80
        beq     @28d2
        jsr     ReloadSkillsMenu
@28d2:  rts

; ------------------------------------------------------------------------------

; [ menu state $1e: espers (select) ]

MenuState_1e:
@28d3:  lda     #$10
        trb     $45
        lda     #$04
        sta     $2a
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @2928
        jsr     UpdateGenjuCursor
        jsr     LoadGenjuAttackDesc

; A button
        lda     $08
        bit     #$80
        beq     @291b
        jsr     PlaySelectSfx
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @2908

; open esper detail menu
        sta     $99
        jsr     InitEsperDetailMenu
        lda     #$4d
        sta     $26
        rts

; unequip esper
@2908:  lda     #$ff
        sta     $e0
        jsr     _c32929
        jsr     DrawGenjuList
        jsr     InitDMA1BG1ScreenB
        jsr     WaitVblank
        jmp     InitDMA1BG1ScreenA

; B button
@291b:  lda     $09
        bit     #$80
        beq     @2928
        lda     #$08
        trb     $46
        jsr     ReloadSkillsMenu
@2928:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32929:
@2929:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        lda     $e0
        sta     $001e,y
        lda     $e0
        jmp     _c34f08

; ------------------------------------------------------------------------------

; [ menu state $34: wait for esper equip error message ]

MenuState_34:
@293a:  ldy     $20
        bne     @2947
        ldy     #.loword(GenjuBlankMsg)
        jsr     DrawPosText
        jmp     _c35913
@2947:  rts

; ------------------------------------------------------------------------------

; blank text to clear esper equip error
GenjuBlankMsg:
@2948:  .byte   $cd,$40,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        .byte   $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

; ------------------------------------------------------------------------------

; [ menu state $39: party equipment overview ]

MenuState_39:
@2966:  lda     $09                     ; wait for B button
        bit     #$80
        beq     @2976
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts
@2976:  rts

; ------------------------------------------------------------------------------

; [ menu state $33: blitz menu ]

MenuState_33:
@2977:  lda     #$10
        trb     $45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateAbilityCursor
        jsr     LoadBlitzDesc
        lda     $09
        bit     #$80
        beq     @298d
        jsr     ReloadSkillsMenu
@298d:  rts

; ------------------------------------------------------------------------------

; [ menu state $3e: swdtech menu ]

MenuState_3e:
@298e:  lda     #$10
        trb     $45
        jsr     InitDMA1BG1ScreenA
        jsr     UpdateAbilityCursor
        jsr     LoadBushidoDesc
        lda     $09
        bit     #$80
        beq     @29a4
        jsr     ReloadSkillsMenu
@29a4:  rts

; ------------------------------------------------------------------------------

; [ reload to skills menu ]

ReloadSkillsMenu:
@29a5:  jsr     PlayCancelSfx
        ldy     $00
        sty     $39
        sty     $3d
        lda     #$0a
        sta     $26
        jsr     _c34d27
        jsr     LoadSkillsCursor
        lda     $5e
        sta     $4e
        jsr     InitSkillsCursor
        jmp     _c35807

; ------------------------------------------------------------------------------

; [ menu state $21: restore saved game (init) ]

MenuState_21:
@29c2:  lda     $4b
        sta     $66
        jsr     DrawSaveMenuChars
        jsr     UpdateGameLoadCursor
        lda     $08
        bit     #$80
        beq     @2a06
        clr_a
        lda     $4b
        beq     @2a07
        sta     $66
        dec
        asl
        tax
        ldy     $91,x
        beq     @2a00
        jsr     PushSRAM
        jsr     PlaySelectSfx
        lda     $66
        sta     $0224
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     _c36989
        jsr     PopTimers
        lda     #$22
        sta     $27
        lda     #$53
        sta     $26
        rts
@2a00:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@2a06:  rts
@2a07:  jsr     PlaySelectSfx
        jsr     ResetGameTime
        lda     #$01
        sta     $0224
        stz     $021f
        stz     $0205
        lda     #$ff
        sta     $27
        lda     #$53
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ clear game time ]

ResetGameTime:
@2a21:  clr_ay
        sty     $021b
        sty     $021d
        rts

; ------------------------------------------------------------------------------

; [ menu state $23: restore saved game ]

MenuState_23:
@2a2a:  jsr     UpdateSaveConfirmCursor
        lda     $09
        bit     #$80
        bne     @2a58
        lda     $08
        bit     #$80
        beq     @2a64
        jsr     PlaySelectSfx
        lda     $4b
        bne     @2a5b
        ldy     $1863
        sty     $021b
        lda     $1865
        sta     $021d
        lda     $66
        sta     $021f
        lda     #$ff
        sta     $27
        stz     $26
        rts
@2a58:  jsr     PlayCancelSfx
@2a5b:  jsr     PopSRAM
        lda     #$20
        sta     $27
        stz     $26
@2a64:  rts

; ------------------------------------------------------------------------------

; [ menu state $3a: magic target (init) ]

MenuState_3a:
@2a65:  lda     #$40
        tsb     $45
        jsr     _c32a76
        jsr     _c35812
        jsr     CreateCursorTask
        lda     #$3b
        bra     _c32aa5

_c32a76:
@2a76:  jsr     DisableInterrupts
        lda     #$01
        tsb     $45
        lda     #$04
        tsb     $43
        stz     $1b
        stz     $1c
        jsr     ClearBGScroll
        jsr     InitPortraits
        lda     #$03
        sta     hBG1SC
        lda     #$c0
        trb     $43
        ldy     #$0002
        sty     $37
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        rts

_c32aa5:
@2aa5:  sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $3b: magic target (single target) ]

MenuState_3b:
@2aae:  lda     $08
        bit     #$10
        bne     @2ac6
        lda     $08
        bit     #$20
        bne     @2ac6
        lda     $09
        bit     #$01
        bne     @2ac6
        lda     $09
        bit     #$02
        beq     @2af3
@2ac6:  jsr     PlayMoveSfx
        jsr     GetSelMagic
        jsr     _c350f5
        longac
        lda     hMPYL
        adc     #0
        tax
        clr_a
        shorta
        lda     f:MagicProp,x   ; spell data
        and     #$20
        beq     @2af3
        lda     $4e
        sta     $5f
        lda     #$06
        trb     $46
        jsr     CreateMultiCursorTask
        lda     #$3d
        sta     $26
        rts
@2af3:  lda     $08
        bit     #$80
        jne     @2b0c
        lda     $09
        bit     #$80
        beq     @2b0b
        jsr     PlayCancelSfx
        lda     #$3c
        sta     $27
        stz     $26
@2b0b:  rts
@2b0c:  stz     $9c
        jsr     _c32ccc
        jsr     GetTargetCharPtr
        jsr     _c32c14
        bcc     @2b32
        jsr     _c32cea
        jsr     PlayCureSfx
        jsr     GetTargetCharPtr
        lda     $0014,y
        sta     $f8
        lda     $0015,y
        sta     $fb
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
        ldx     $00         ; 0: spell effect
        jsl     CalcMagicEffect_ext
        ply
        lda     $9c
        beq     @2b5c
        longac
        lda     ExecTasks
        lsr
        bra     @2b61
@2b5c:  longac
        lda     ExecTasks
@2b61:  adc     $0009,y
        sta     $0009,y
        shorta
        jsr     CheckMaxHP
        lda     $fc
        sta     $0014,y
        lda     $ff
        sta     $0015,y
        lda     $9c
        bne     @2b99
        clr_a
        lda     $4b
        tax
        lda     $69,x
        jsl     UpdateEquip_ext
        clr_a
        lda     $4b
        asl
        tax
        ldy     $6d,x
        sty     $67
        lda     $11d2
        jsr     _c391ec
        lda     $11d4
        jmp     _c391fb
@2b99:  rts

; ------------------------------------------------------------------------------

; [ check current hp vs max ]

CheckMaxHP:
@2b9a:  lda     $000b,y     ; max hp
        sta     $f3
        lda     $000c,y
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        longa
        lda     $0009,y     ; current hp
        cmp     $f3
        bcc     @2bb9       ; return if not greater than max (return clear carry)
        lda     $f3
        sta     $0009,y     ; set current hp (return set carry)
        sec
@2bb9:  shorta
        rts

; ------------------------------------------------------------------------------

; [ check current mp vs max ]

CheckMaxMP:
@2bbc:  lda     $000f,y
        sta     $f3
        lda     $0010,y
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        longa
        lda     $000d,y
        cmp     $f3
        bcc     @2bdb
        lda     $f3
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
        jsr     _c3510d
        stx     $e7
        ldx     a:$000d,y
        cpx     $e7
        bcs     @2c00
        lda     #$02
        sta     $46
        lda     #$3c
        sta     $27
        stz     $26
@2c00:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32c01:
@2c01:  lda     $4b
        sta     $9c
        jsr     _c324ee
        jsr     ClearBG1ScreenA
        jsr     _c33193
        jsr     LoadPortraitPal
        jmp     GetPortraitGfxPtr

; ------------------------------------------------------------------------------

; [  ]

_c32c14:
@2c14:  lda     $0014,y
        and     #$80
        bne     @2c40
        jsr     GetSelMagic
        cmp     #$2d
        beq     @2c76
        cmp     #$2e
        beq     @2c76
        cmp     #$2f
        beq     @2c76
        cmp     #$32
        beq     @2c6d
        cmp     #$33
        beq     @2c64
        cmp     #$22
        beq     @2c4d
        cmp     #$23
        beq     @2c84
        cmp     #$2c
        beq     @2c56
        bra     @2c82
@2c40:  jsr     GetSelMagic
        cmp     #$30
        beq     @2c84
        cmp     #$31
        beq     @2c84
        bra     @2c82
@2c4d:  lda     $0015,y
        and     #$80
        bne     @2c82
        bra     @2c84
@2c56:  lda     $0014,y
        and     #$7f
        ora     $0015,y
        and     #$90
        beq     @2c82
        bra     @2c84
@2c64:  lda     $0014,y
        and     #$45
        beq     @2c82
        bra     @2c84
@2c6d:  lda     $0014,y
        and     #$04
        beq     @2c82
        bra     @2c84
@2c76:  lda     $0014,y
        and     #$c2
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
@2c86:  stz     $af
        lda     #$01
        sta     $9c
        jsr     _c32ccc
        clr_a
@2c90:  pha
        asl
        tax
        ldy     $6d,x
        beq     @2cb8
        jsr     _c32c14
        bcc     @2cb8
        lda     $0014,y
        sta     $f8
        lda     $0015,y
        sta     $fb
        jsr     _c32b39
        jsr     _c32ccc
        lda     $af
        bne     @2cb8
        jsr     PlayCureSfx
        jsr     _c32cea
        inc     $af
@2cb8:  clr_a
        pla
        inc
        cmp     #$04
        bne     @2c90
        lda     $af
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
        lda     $28
        tax
        lda     $69,x
        jsl     UpdateEquip_ext
        rts

; ------------------------------------------------------------------------------

; [ subtract spell's mp cost ]

_c32cea:
@2cea:  jsr     GetSelMagic
        jsr     _c3510d
        stx     $e7
        jsr     GetCasterCharPtr
        longa
        lda     $000d,y
        sec
        sbc     $e7
        sta     $000d,y
        shorta
        rts

; ------------------------------------------------------------------------------

; [ get pointer to spell caster's character data ]

GetCasterCharPtr:
@2d03:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        rts

; ------------------------------------------------------------------------------

; [ get pointer to target character data ]

GetTargetCharPtr:
@2d0b:  clr_a
        lda     $4b         ; cursor position
        asl
        tax
        ldy     $6d,x       ; pointer to character data
        rts

; ------------------------------------------------------------------------------

; [ get selected spell index ]

GetSelMagic:
@2d13:  clr_a
        lda     $99
        tax
        lda     $7e9d89,x
        rts

; ------------------------------------------------------------------------------

; [ menu state $3c: return to magic menu after casting a spell ]

MenuState_3c:
@2d1c:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        lda     #$42
        trb     $45
        stz     $4a
        stz     $49
        jsr     InitSkillsBGScrollHDMA
        jsr     _c34c80
        jsr     CreateCursorTask
        jsr     _c32130
        jsr     LoadMagicCursor
        lda     $8e
        sta     $4d
        ldy     $8e
        sty     $4f
        lda     $90
        sta     $4a
        lda     $4a
        sta     $e0
        lda     $50
        sec
        sbc     $e0
        sta     $4e
        jsr     InitMagicCursor
        jsr     _c32158
        jsr     _c351c6
        jsr     TfrBG3ScreenAB
        jsr     WaitVblank
        ldy     $00
        sty     $35
        jsr     InitBigText
        lda     #$10
        tsb     $45
        jsr     InitDMA1BG1ScreenA
        lda     #$1a
        sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $3d: magic target (multi-target) ]

MenuState_3d:
@2d78:  lda     $08
        bit     #$10
        bne     @2d90
        lda     $08
        bit     #$20
        bne     @2d90
        lda     $09
        bit     #$01
        bne     @2d90
        lda     $09
        bit     #$02
        beq     @2d9b
@2d90:  jsr     PlayMoveSfx
        jsr     _c32db7
        lda     #$3b
        sta     $26
        rts
@2d9b:  lda     $08
        bit     #$80
        jne     _c32c86
        lda     $09
        bit     #$80
        beq     @2db6
        jsr     PlayCancelSfx
        jsr     _c32db7
        lda     #$3c
        sta     $27
        stz     $26
@2db6:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32db7:
@2db7:  jsr     InitCharSelectCursor
        jsr     CreateCursorTask
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        jsr     ExecTasks
        lda     $5f
        sta     $4e
        lda     #$08
        trb     $46
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32dd1:
@2dd1:  clr_a
        lda     $28
        tax
        lda     $4b
        tay
        lda     $75,x
        sta     $e0
        lda     $0075,y
        sta     $75,x
        lda     $e0
        sta     $0075,y
        lda     $69,x
        sta     $e0
        lda     $0069,y
        sta     $69,x
        lda     $e0
        sta     $0069,y
        clr_a
        lda     $28
        asl
        tax
        lda     $4b
        asl
        tay
        longa
        lda     $6d,x
        sta     $e7
        lda     $006d,y
        sta     $6d,x
        lda     $e7
        sta     $006d,y
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32e10:
@2e10:  clr_a
        lda     $28
        tax
        lda     $75,x
        sta     $e0
        lda     $60,x
        tax
        lda     $e0
        bit     #$20
        beq     @2e29
        lda     #$20
        trb     $e0
        lda     #$03
        bra     @2e2f
@2e29:  lda     #$20
        tsb     $e0
        lda     #$02
@2e2f:  sta     $7e3649,x
        clr_a
        lda     $28
        tax
        lda     $e0
        sta     $75,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32e3c:
@2e3c:  clr_a
        lda     $60
        tax
        lda     #$ff
        sta     $7e35c9,x
        lda     $61
        tax
        lda     #$ff
        sta     $7e35c9,x
        lda     $62
        tax
        lda     #$ff
        sta     $7e35c9,x
        lda     $63
        tax
        lda     #$ff
        sta     $7e35c9,x
        rts

; ------------------------------------------------------------------------------

; [ main menu: a button pressed ]

SelectMainMenuOption:
@2e62:  clr_a
        lda     $4b
        sta     $25         ; set main menu cursor position
        asl
        tax
        jmp     (.loword(SelectMainMenuOptionTbl),x)

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
        stz     $5f
        stz     $26                     ; fade out
        lda     #$0d
        sta     $27                     ; config (init)
        rts

; ------------------------------------------------------------------------------

; item
SelectMainMenuOption_00:
@2e86:  jsr     PlaySelectSfx
        stz     $26                     ; fade out
        lda     #$07
        sta     $27                     ; item (init)
        rts

; ------------------------------------------------------------------------------

; skills, equip, relic, status
SelectMainMenuOption_01:
SelectMainMenuOption_02:
SelectMainMenuOption_03:
SelectMainMenuOption_04:
@2e90:  jsr     PlaySelectSfx
        lda     #$02
        trb     $46                     ; disable cursor 1
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        jsr     _c32f06
        lda     #$06
        sta     $26                     ; character select menu state
        rts

; ------------------------------------------------------------------------------

; save
SelectMainMenuOption_06:
@2eaa:  lda     $0201                   ; branch if save is not enabled
        bpl     @2ebf
        jsr     PlaySelectSfx
        stz     $26                     ; fade out
        lda     #$13
        sta     $27                     ; save select (init) menu state
        sta     $9e                     ;
        lda     #$04
        sta     $9f                     ;
        rts
@2ebf:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [ main menu: left button pressed ]

MainMenuLeftBtn:
@2ec6:  lda     #$02                    ; disable cursor 1
        trb     $46
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        lda     #$06
        sta     $20                     ; wait 6 frames
        ldy     #$fff4                  ; set menu scroll speed to -12
        sty     $9c
        lda     #$05                    ; disable cursor 2 and flashing cursor
        trb     $46
        lda     #$0f                    ; order (char select)
        sta     $27
        lda     #$65                    ; scroll menu
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32eeb:
@2eeb:  lda     #2
        ldy     #.loword(MultiCursorTask)
        jsr     CreateTask
        longa
        lda     #$0038
        sta     $7e33ca,x
        lda     #$0036
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create flashing cursor (2 pixels to the right) ]

_c32f06:
@2f06:  lda     #2
        ldy     #.loword(FlashingCursorTask)
        jsr     CreateTask
        longa
        lda     $55                     ; cursor x position
        inc2
        sta     $7e33ca,x               ; set task x position
        lda     $57                     ; cursor y position
        sta     $7e344a,x               ; set task y position
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create flashing cursor (4 pixels right/up) ]

_c32f21:
@2f21:  lda     #1
        ldy     #.loword(FlashingCursorTask)
        jsr     CreateTask
        longa
        lda     $55
        clc
        adc     #4
        sta     $7e33ca,x
        lda     $57
        sec
        sbc     #4
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ main menu cursor task ]

MainMenuCursorTask:
@2f42:  tax
        jmp     (.loword(MainMenuCursorTaskTbl),x)

; ------------------------------------------------------------------------------

; main menu cursor task jump table
MainMenuCursorTaskTbl:
@2f46:  .addr   MainMenuCursorTask_00
        .addr   MainMenuCursorTask_01

; ------------------------------------------------------------------------------

; state 0: init
MainMenuCursorTask_00:
@2f4a:  ldx     $2d                     ; task pointer
        lda     #$02
        tsb     $46                     ; enable cursor 1
        inc     $3649,x                 ; increment task counter
        ldy     #.loword(MainMenuCursorProp)
        jsr     LoadCursor
        lda     $1d4e                   ; branch if cursor is on memory
        and     #$40
        beq     @2f65
        ldy     $022b                   ; load saved cursor position
        sty     $4d
@2f65:  ldy     #$2f8a
        jsr     UpdateCursorPos
; fallthrough

; ------------------------------------------------------------------------------

; state 1: update
MainMenuCursorTask_01:
@2f6b:  lda     $46
        bit     #$02
        beq     @2f83                   ; terminate if cursor 1 is not active
        ldx     $2d
        jsr     MoveCursor
        ldy     #.loword(MainMenuCursorPos)
        jsr     UpdateCursorPos
        ldy     $4d
        sty     $022b                   ; save cursor position
        sec
        rts
@2f83:  clc
        rts

; ------------------------------------------------------------------------------

; main menu cursor data
MainMenuCursorProp:
@2f85:  .byte   $80,$00,$00,$01,$07

; ------------------------------------------------------------------------------

; main menu cursor positions
MainMenuCursorPos:
@2f8a:  .byte   $af,$12
        .byte   $af,$21
        .byte   $af,$30
        .byte   $af,$3f
        .byte   $af,$4e
        .byte   $af,$5d
        .byte   $af,$6c

; ------------------------------------------------------------------------------

; [ init character select cursor ]

InitCharSelectCursor:
@2f98:  jsr     LoadCharSelectCursorProp
        clr_axy
@2f9e:  lda     a:$0069,x               ; character number
        bpl     @2faa                   ; branch if slot is not empty
        phx
        txa
        asl
        tax
        stz     $85,x                   ; disable cursor position
        plx
@2faa:  inx
        cpx     #4
        bne     @2f9e
        rts

; ------------------------------------------------------------------------------

; [ load character select cursor data ]

LoadCharSelectCursorProp:
@2fb1:  ldx     $00
@2fb3:  lda     f:CharSelectCursorProp,x
        sta     $80,x
        inx
        cpx     #13
        bne     @2fb3
        rts

; ------------------------------------------------------------------------------

; [ character select cursor task ]

CharSelectCursorTask:
@2fc0:  tax
        jmp     (.loword(CharSelectCursorTaskTbl),x)

CharSelectCursorTaskTbl:
@2fc4:  .addr   CharSelectCursorTask_00
        .addr   CharSelectCursorTask_01

; ------------------------------------------------------------------------------

; [  ]

CharSelectCursorTask_00:
@2fc8:  ldx     $2d
        lda     #$14
        tsb     $46
        inc     $3649,x
        jsr     _c32ff5
        lda     $45
        bit     #$40
        bne     @2fe6
        lda     $1d4e
        and     #$40
        beq     @2fe6
        ldy     $022d
        sty     $4d
@2fe6:  jsr     _c33008
        lda     $55
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
        sta     $ed
        jsr     LoadCursorFar
        jmp     SelectFirstChar

; ------------------------------------------------------------------------------

; [  ]

_c33008:
@3008:  ldy     #$0085
        sty     $e7
        lda     #$00
        sta     $e9
        jmp     UpdateCursorPosFar

; ------------------------------------------------------------------------------

; [  ]

CharSelectCursorTask_01:
@3014:  lda     $45
        bit     #$40
        bne     @301f
        ldy     $4d
        sty     $022d
@301f:  lda     $46
        bit     #$04
        beq     @3040
        bit     #$10
        beq     @303e
        ldx     $2d
@302b:  jsr     MoveCursor
        ldy     #$0085      ; cursor data pointer = $000085
        sty     $e7
        lda     #$00
        sta     $e9
        jsr     UpdateCursorPosFar
        lda     $55
        beq     @302b
@303e:  sec
        rts
@3040:  clc
        rts

; ------------------------------------------------------------------------------

; character select cursor data
CharSelectCursorProp:
@3042:  .byte   $80,$00,$00,$01,$04

; ------------------------------------------------------------------------------

; character select cursor positions
CharSelectCursorPos:
@3047:  .byte   $08,$28
        .byte   $08,$58
        .byte   $08,$88
        .byte   $08,$b8

; ------------------------------------------------------------------------------

; [ create fade out task ]

CreateFadeOutTask:
@304f:  clr_a                           ; priority 0
        ldy     #.loword(FadeOutTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ create fade in task ]

CreateFadeInTask:
@3056:  clr_a                           ; priority 0
        ldy     #.loword(FadeInTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ create mosaic task ]

CreateMosaicTask:
@305d:  clr_a                           ; priority 0
        ldy     #.loword(MosaicTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ mosaic task ]

MosaicTask:
@3064:  tax
        jmp     (.loword(MosaicTaskTbl),x)

MosaicTaskTbl:
@3068:  .addr   MosaicTask_00
        .addr   MosaicTask_01

; ------------------------------------------------------------------------------

; [ init mosaic ]

MosaicTask_00:
@306c:  ldx     $2d
        inc     $3649,x
        stz     $33ca,x
        lda     #$08
        sta     $3349,x
; fallthrough

; ------------------------------------------------------------------------------

; [ update mosaic ]

MosaicTask_01:
@3079:  ldx     $2d
        lda     $3349,x
        beq     @3095
        clr_a
        lda     $33ca,x
        tax
        lda     f:MosaicTbl,x
        sta     $b5                     ; set mosaic register
        ldx     $2d
        inc     $33ca,x
        dec     $3349,x
        sec
        rts
@3095:  clc
        rts

; ------------------------------------------------------------------------------

; mosaic data
MosaicTbl:
@3097:  .byte   $17,$27,$37,$47,$37,$27,$17,$07

; ------------------------------------------------------------------------------

; [ fade out task ]

FadeOutTask:
@309f:  tax
        jmp     (.loword(FadeOutTaskTbl),x)

FadeOutTaskTbl:
@30a3:  .addr   FadeOutTask_00
        .addr   FadeOutTask_01

; ------------------------------------------------------------------------------

; [ init fade out ]

FadeOutTask_00:
@30a7:  ldx     $2d
        inc     $3649,x
        lda     #$0f
        sta     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ update fade out ]

FadeOutTask_01:
@30b1:  ldy     $20
        beq     _30c4
        ldx     $2d
        lda     $33ca,x
        sta     $44
        dec     $33ca,x
        dec     $33ca,x
        sec
        rts
_30c4:  lda     #$01
        sta     $44
        clc
        rts

; ------------------------------------------------------------------------------

; [ fade in task ]

FadeInTask:
@30ca:  tax
        jmp     (.loword(FadeInTaskTbl),x)

FadeInTaskTbl:
@30ce:  .addr   FadeInTask_00
        .addr   FadeInTask_01

; ------------------------------------------------------------------------------

; [ init fade in ]

FadeInTask_00:
@30d2:  ldx     $2d
        inc     $3649,x
        lda     #$01
        sta     $344a,x
; fallthrough

; ------------------------------------------------------------------------------

; [ update fade in ]

FadeInTask_01:
@30dc:  ldy     $20
        beq     _30ef
        ldx     $2d
        lda     $344a,x
        sta     $44
        inc     $344a,x
        inc     $344a,x
        sec
        rts
_30ef:  lda     #$0f
        sta     $44
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
        ldy     #.loword(MainMenuOrderWindow1)
        jsr     DrawWindow
        ldy     #.loword(MainMenuOrderWindow2)
        jsr     DrawWindow
        ldy     #.loword(MainMenuCharWindow)
        jsr     DrawWindow
        ldy     #.loword(MainMenuOptionsWindow)
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
        ldy     #.loword(MainMenuCharWindow)
        jsr     DrawWindow
        ldy     #.loword(SaveChoiceWindow)
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
        ldy     #.loword(MainMenuCharWindow)
        jsr     DrawWindow
        ldy     #.loword(SaveChoiceWindow)
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
        ldy     #.loword(MainMenuTimeWindow)
        jsr     DrawWindow
        ldy     #.loword(MainMenuStepsWindow)
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
@31a8:  lda     $66
        cmp     #$01
        beq     @31b5
        cmp     #$02
        beq     @31b8
        jmp     LoadSaveSlot3WindowGfx
@31b5:  jmp     LoadSaveSlot1WindowGfx
@31b8:  jmp     LoadSaveSlot2WindowGfx

; ------------------------------------------------------------------------------

; main menu window data

; c3/31bb: bg2_0(23, 1) [ 6x13]
MainMenuOptionsWindow:
@31bb:  .byte   $b7,$58,$06,$0d

; c3/31bf: bg2_0(23,16) [ 6x 2]
MainMenuTimeWindow:
@31bf:  .byte   $77,$5c,$06,$02

; c3/31c3: bg2_0(22,20) [ 7x 5]
MainMenuStepsWindow:
@31c3:  .byte   $75,$5d,$07,$05

; c3/31c7: bg2_0( 1, 1) [28x24]
MainMenuCharWindow:
@31c7:  .byte   $8b,$58,$1c,$18

; c3/31cb: bg2_0(22, 1) [ 7x10]
SaveChoiceWindow:
@31cb:  .byte   $b5,$58,$07,$0a

; c3/31cf: bg2_1(24, 1) [ 7x 2]
MainMenuOrderWindow1:
@31cf:  .byte   $b9,$60,$07,$02

; c3/31d3: bg2_0(30, 0) [ 1x 2]
MainMenuOrderWindow2:
@31d3:  .byte   $85,$58,$01,$02

; ------------------------------------------------------------------------------

; [ draw "yes/no/erasing data, okay?" text ]

DrawGameSaveChoiceText:
@31d7:  lda     #$20        ; white text
        sta     $29
        ldx     #.loword(GameSaveChoiceTextList)
        ldy     #$000a
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw "yes/no/this data?" text ]

DrawGameLoadChoiceText:
@31e5:  lda     #$20        ; white text
        sta     $29
        ldx     #.loword(GameLoadChoiceTextList)
        ldy     #$0008
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw "item/skills/equip/relic/status/config/save" text ]

DrawMainMenuListText:
@31f3:  lda     #$20        ; white text
        sta     $29
        ldx     #.loword(MainMenuOptionsTextList1)
        ldy     #$0008
        jsr     DrawPosList
        lda     #$20
        sta     $29
        ldx     #.loword(MainMenuOptionsTextList2)
        ldy     #$0004
        jsr     DrawPosList
        lda     $0201
        bpl     @3216       ; branch if save is disabled
        lda     #$20        ; white text
        bra     @3218
@3216:  lda     #$24        ; gray text
@3218:  sta     $29
        ldy     #.loword(MainMenuSaveText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw gp and steps ]

DrawGilStepsText:
@3221:  lda     #$20        ; white text
        sta     $29
        ldy     #.loword(MainMenuColonText)
        jsr     DrawPosText
        lda     #$2c        ; teal text
        sta     $29
        ldx     #.loword(MainMenuLabelTextList)
        ldy     #$0006
        jsr     DrawPosList
        ldy     #.loword(MainMenuGilText)
        jsr     DrawPosText
        jsr     ValidateMaxGil
        lda     #$20        ; white text
        sta     $29
        ldy     $1866       ; gp
        sty     $f1
        lda     $1868
        sta     $f3
        jsr     HexToDec8
        ldx     #$7df7
        jsr     DrawNum7
        ldy     $1860       ; steps
        sty     $f1
        lda     $1862
        sta     $f3
        jsr     HexToDec8
        ldx     #$7eb7
        jsr     DrawNum7
        rts

; ------------------------------------------------------------------------------

; [ draw game time or timer ]

DrawTime:
@326c:  lda     $1188       ; branch if timer 0 is not active
        bit     #$10
        beq     @3289
        ldy     $1189
        jsr     Div60
        jsr     Div60
        lda     $e7
        sta     $1863
        lda     hRDMPYL
        sta     $1864
        bra     _c33295
@3289:  ldy     $021b
        sty     $1863
        lda     $021d
        sta     $1865

_c33295:
@3295:  lda     #$20        ; white text
        sta     $29
        lda     $1863
        jsr     HexToDec3
        ldx     #$7cfb
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7d01
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
        sty     $e7
        rts

; ------------------------------------------------------------------------------

; [ check max gil ]

ValidateMaxGil:
@32ce:  lda     #$7f        ; 9999999 max
        cmp     $1860
        lda     #$96
        sbc     $1861
        lda     #$98
        sbc     $1862
        bcs     @32ea
        ldy     #$967f
        sty     $1860
        lda     #$98
        sta     $1862
@32ea:  rts

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 1) ]

_32eb:  jsr     CreatePortraitTask1
        jmp     HidePortrait

DrawCharBlock1:
@32f1:  lda     $69
        bmi     _32eb
        ldx     $6d
        stx     $67
        lda     #$24        ; teal text
        sta     $29
        ldx     #.loword(CharBlock1LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3927
        ldx     #$1578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock1SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3919
        jsr     DrawCharName
        ldx     #.loword(_c3332d)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask1

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (slot 1)
; c3/332d: bg1_0(15, 5) lv
;          bg1_0(13, 6) current hp
;          bg1_0(18, 6) max hp
;          bg1_0(13, 7) current mp
;          bg1_0(18, 7) max mp
_c3332d:
@332d:  .word   $39a7,$39e3,$39ed,$3a23,$3a2d

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 2) ]

_3337:  jsr     CreatePortraitTask2
        jmp     HidePortrait

DrawCharBlock2:
@333d:  lda     $6a
        bmi     _3337
        ldx     $6f
        stx     $67
        lda     #$24
        sta     $29
        ldx     #.loword(CharBlock2LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3aa7
        ldx     #$4578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock2SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3a99
        jsr     DrawCharName
        ldx     #.loword(_c33379)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask2

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (slot 2)
_c33379:
@3379:  .word   $3b27,$3b63,$3b6d,$3ba3,$3bad

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 3) ]

_3383:  jsr     CreatePortraitTask3
        jmp     HidePortrait

DrawCharBlock3:
@3389:  lda     $6b
        bmi     _3383
        ldx     $71
        stx     $67
        lda     #$24
        sta     $29
        ldx     #.loword(CharBlock3LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3c27
        ldx     #$7578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock3SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3c19
        jsr     DrawCharName
        ldx     #.loword(_c333c5)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask3

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (slot 3)
_c333c5:
@33c5:  .word   $3ca7,$3ce3,$3ced,$3d23,$3d2d

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 4) ]

_33cf:  jsr     CreatePortraitTask4
        jmp     HidePortrait

DrawCharBlock4:
@33d5:  lda     $6c
        bmi     _33cf       ; branch if slot is empty
        ldx     $73
        stx     $67
        lda     #$24
        sta     $29
        ldx     #.loword(CharBlock4LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3da7
        ldx     #$a578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock4SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3d99
        jsr     DrawCharName
        ldx     #.loword(_c33411)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask4

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (character slot 4)
_c33411:
@3411:  .word   $3e27,$3e63,$3e6d,$3ea3,$3ead

; ------------------------------------------------------------------------------

; [ hide portrait ]

HidePortrait:
@341b:  longa
        lda     #$00d8      ; set y position to 216 (off-screen)
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw status icons ]

; also sets text color for hp/mp/level

DrawStatusIcons:
@3427:  stx     $e7
        jsr     InitTextBuf
        lda     $0014,y               ; status 1
        bmi     @34b0                   ; branch if character has wound status
        and     #$70                    ; isolate clear, imp, and petrify status
        sta     $e1
        lda     $0014,y
        and     #$07                    ; isolate dark, zombie, and poison status
        asl
        sta     $e2
        lda     $0015,y               ; status 4
        and     #$80                    ; isolate float status
        ora     $e1
        ora     $e2
        sta     $e1                     ; feicpzd-
        beq     @34a9                   ; branch if character has no status icons
        stz     $f1                     ; clear icon index
        stz     $f2
        ldx     #$0007                  ; loop through each status
@3451:  phx
        asl
        bcc     @349c                   ; continue if character doesn't have this status
        pha
        lda     #3
        ldy     #.loword(CharIconTask)
        jsr     CreateTask
        lda     #$01
        sta     $7e364a,x               ; task doesn't scroll with bg
        lda     $48
        sta     $7e3649,x               ; task state
        txy
        ldx     $f1                     ; icon index
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:StatusIconAnimPtrs,x
        sta     $32c9,y
        shorta
        lda     $e7
        sta     $33ca,y                 ; x position
        lda     $e8
        sta     $344a,y                 ; y position
        clr_a
        sta     $33cb,y                 ; clear high bytes
        sta     $344b,y
        lda     #^StatusIconAnimPtrs
        sta     $35ca,y                 ; animation data in bank $d8
        plb
        clc
        lda     #$0a
        adc     $e7                     ; increment positioned text pointer ???
        sta     $e7
        pla
@349c:  inc     $f1                     ; increment icon index
        inc     $f1
        plx
        dex                             ; next status
        bne     @3451
        lda     #$20                    ; white text
        sta     $29
        rts

; character has no status icons
@34a9:  lda     #$20
        sta     $29                     ; white text
        jmp     DrawCharTitle

; character has wound status
@34b0:  ldx     #$9e8b
        stx     hWMADDL
        ldx     $00
@34b8:  lda     f:MainMenuWoundedText,x               ; text: "wounded"
        sta     hWMDATA
        inx
        cpx     #$0008
        bne     @34b8
        stz     hWMDATA
        lda     #$28                    ; gray text
        sta     $29
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw character name ]

DrawCharName:
@34cf:  jsr     InitTextBuf

_c334d2:
@34d2:  ldx     #6
@34d5:  lda     $0002,y               ; character name
        sta     hWMDATA
        iny
        dex
        bne     @34d5
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw character title (dummy) ]

DrawCharTitle:
@34e5:  rts

; ------------------------------------------------------------------------------

; [ draw equipped esper name ]

DrawEquipGenju:
@34e6:  jsr     InitTextBuf
        lda     $001e,y               ; equipped esper
        cmp     #$ff
        beq     @3508                   ; branch if no esper is equipped
        asl3
        tax
        ldy     #8
@34f7:  lda     $e6f6e1,x               ; esper names
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

; +y: text position

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
        ldy     $67
        rts

; ------------------------------------------------------------------------------

; [ disable interrupts ]

DisableInterrupts:
@352f:  lda     #$80        ; screen off
        sta     hINIDISP
        jsr     ResetTasks
        stz     hNMITIMEN
        stz     hMDMAEN
        stz     hHDMAEN
        rts

; ------------------------------------------------------------------------------

; [ enable interrupts ]

EnableInterrupts:
@3541:  lda     #$01        ; screen register (screen on, brightness 1)
        sta     $44
        jmp     WaitVblank

; ------------------------------------------------------------------------------

; [ draw time text ]

UpdateTimeText:
@3548:  jsr     InitDMA1BG3ScreenA
        jmp     DrawTime

; ------------------------------------------------------------------------------

; [ init main screen designation hdma (main menu) ]

_c3354e:
@354e:  ldx     $00
        lda     #$17        ; main screen designation (-> $212c)
@3552:  sta     $7e9a09,x
        inx
        cpx     #$00df
        bne     @3552
        lda     #$40        ; hdma channel #3 - indirect addressing
        sta     $4360
        lda     #$2c
        sta     $4361
        ldy     #.loword(_c3357b)
        sty     $4362
        lda     #^_c3357b
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$40
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; main screen designation hdma table (main menu)
_c3357b:
@357b:  .byte   $f0
        .word   $9a09
        .byte   $f0
        .word   $9a79
        .byte   $00

; ------------------------------------------------------------------------------

; [ init character swap tasks ]

CreateCharSwapTask:
@3582:  lda     $28
        cmp     $4b
        bcc     @359d
        lda     #3
        ldy     #.loword(CharSwapTopTask)
        jsr     CreateTask
        jsr     @35c1
        lda     #3
        ldy     #.loword(CharSwapBtmTask)
        jsr     CreateTask
        bra     @35b2
@359d:  lda     #3
        ldy     #.loword(CharSwapTopTask)
        jsr     CreateTask
        jsr     @35b2
        lda     #3
        ldy     #.loword(CharSwapBtmTask)
        jsr     CreateTask
        bra     @35c1

@35b2:  txy
        clr_a
        lda     $28
        tax
        lda     f:_c335d0,x
        tyx
        sta     $7e33ca,x
        rts

@35c1:  txy
        clr_a
        lda     $4b
        tax
        lda     f:_c335d0,x
        tyx
        sta     $7e33ca,x   ; x position
        rts

; ------------------------------------------------------------------------------

_c335d0:
@35d0:  .byte   $0d,$3d,$6d,$9d

; ------------------------------------------------------------------------------

; [ character swap task (top character) ]

CharSwapTopTask:
@35d4:  tax
        jmp     (.loword(CharSwapTopTaskTbl),x)

CharSwapTopTaskTbl:
@35d8:  .addr   CharSwapTopTask_00
        .addr   CharSwapTopTask_01
        .addr   CharSwapTopTask_02

; ------------------------------------------------------------------------------

; [ state 0: init ]

CharSwapTopTask_00:
@35de:  ldx     $2d
        inc     $3649,x
; fallthrough

; ------------------------------------------------------------------------------

; [ state 1: hide character in old slot ]

CharSwapTopTask_01:
@35e3:  ldy     $2d
        lda     $22
        cmp     #$0c
        beq     @35fa
        clr_a
        lda     $33ca,y     ; x position
        tax
        lda     #$06
        jsr     UpdateCharSwapHDMA1
        sta     $33ca,y
        sec
        rts
@35fa:  ldx     $2d
        inc     $3649,x
        dec     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ state 2: show character in new slot ]

CharSwapTopTask_02:
@3602:  lda     $45
        bit     #$08
        beq     @361b
        ldy     $2d
        lda     $22
        beq     @361d
        clr_a
        lda     $33ca,y     ; x position
        tax
        lda     #$17
        jsr     UpdateCharSwapHDMA2
        sta     $33ca,y
@361b:  sec
        rts
@361d:  clc
        rts

; ------------------------------------------------------------------------------

; [ character swap task (bottom character) ]

CharSwapBtmTask:
@361f:  tax
        jmp     (.loword(CharSwapBtmTaskTbl),x)

CharSwapBtmTaskTbl:
@3623:  .addr   CharSwapBtmTask_00
        .addr   CharSwapBtmTask_01
        .addr   CharSwapBtmTask_02

; ------------------------------------------------------------------------------

; [ init ]

CharSwapBtmTask_00:
@3629:  ldx     $2d
        inc     $3649,x
        lda     $33ca,x
        clc
        adc     #$2f
        sta     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ hide character in old slot ]

CharSwapBtmTask_01:
@3637:  ldy     $2d
        lda     $22
        cmp     #$0c
        beq     @3650
        clr_a
        lda     $33ca,y
        tax
        lda     #$06
        jsr     UpdateCharSwapHDMA2
        sta     $33ca,y
        dec     $22
        sec
        rts
@3650:  ldx     $2d
        inc     $3649,x
        inc     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ show character in new slot ]

CharSwapBtmTask_02:
@3658:  lda     $45
        bit     #$08
        beq     @3673
        ldy     $2d
        lda     $22
        beq     @3675
        clr_a
        lda     $33ca,y
        tax
        lda     #$17
        jsr     UpdateCharSwapHDMA1
        sta     $33ca,y
        dec     $22
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
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(MainMenuBG3VScrollHDMATbl)
        sty     $4352
        lda     #^MainMenuBG3VScrollHDMATbl
        sta     $4354
        lda     #^MainMenuBG3VScrollHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (main menu)
MainMenuBG3VScrollHDMATbl:
@36c2:  .byte   $0f
        .word   $0000
        .byte   $0f
        .word   $0003
        .byte   $0f
        .word   $0004
        .byte   $0f
        .word   $0005
        .byte   $0f
        .word   $0006
        .byte   $0f
        .word   $0007
        .byte   $0f
        .word   $0008
        .byte   $0f
        .word   $0009
        .byte   $07
        .word   $0008
        .byte   $08
        .word   $0000
        .byte   $08
        .word   $0000
        .byte   $18
        .word   $0000
        .byte   $00

; ------------------------------------------------------------------------------

; [ menu state $65: scroll menu horizontal ]

MenuState_65:
@36e7:  lda     $20         ; branch if wait counter is not clear
        bne     @36ef
        lda     $27         ; go to next menu state
        sta     $26
@36ef:  longa
        lda     $35         ; bg1 horizontal scroll position
        clc
        adc     $9c         ; add scroll speed
        sta     $35         ; set bg1, bg2, bg3 scroll positions
        sta     $39
        sta     $3d
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init cursor for gogo's status menu ]

LoadGogoStatusCursor:
@36ff:  ldy     #.loword(GogoStatusCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for gogo's status menu ]

UpdateGogoStatusCursor:
@3705:  jsr     MoveCursor

InitGogoStatusCursor:
@3708:  ldy     #.loword(GogoStatusCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GogoStatusCursorProp:
@370e:  .byte   $80,$00,$00,$01,$04

GogoStatusCursorPos:
@3713:  .byte   $90,$59
        .byte   $90,$65
        .byte   $90,$71
        .byte   $90,$7d

; ------------------------------------------------------------------------------

; "wounded"
MainMenuWoundedText:
@371b:  .byte   $96,$a8,$ae,$a7,$9d,$9e,$9d,$ff

; "time", "steps", "order"
MainMenuLabelTextList:
@3723:  .addr   MainMenuTimeText
        .addr   MainMenuStepsText
        .addr   MainMenuOrderText

; "item", "skills", "relic", "status"
MainMenuOptionsTextList1:
@3729:  .addr   MainMenuItemText
        .addr   MainMenuSkillsText
        .addr   MainMenuRelicText
        .addr   MainMenuStatusText

; slashes for character hp/mp
CharBlock1SlashTextList:
@3731:  .addr   CharBlock1HPSlashText
        .addr   CharBlock1MPSlashText

CharBlock2SlashTextList:
@3735:  .addr   CharBlock2HPSlashText
        .addr   CharBlock2MPSlashText

CharBlock3SlashTextList:
@3739:  .addr   CharBlock3HPSlashText
        .addr   CharBlock3MPSlashText

CharBlock4SlashTextList:
@373d:  .addr   CharBlock4HPSlashText
        .addr   CharBlock4MPSlashText

CharBlock1LabelTextList:
@3741:  .addr   CharBlock1LevelText
        .addr   CharBlock1HPText
        .addr   CharBlock1MPText

CharBlock2LabelTextList:
@3747:  .addr   CharBlock2LevelText
        .addr   CharBlock2HPText
        .addr   CharBlock2MPText

CharBlock3LabelTextList:
@374d:  .addr   CharBlock3LevelText
        .addr   CharBlock3HPText
        .addr   CharBlock3MPText

CharBlock4LabelTextList:
@3753:  .addr   CharBlock4LevelText
        .addr   CharBlock4HPText
        .addr   CharBlock4MPText

; "Equip", "Config"
MainMenuOptionsTextList2:
@3759:  .addr   MainMenuEquipText
        .addr   MainMenuConfigText

; "Yes", "No", "This", "data?"
GameLoadChoiceTextList:
@375d:  .addr   GameLoadYesText
        .addr   GameLoadNoText
        .addr   GameLoadMsgText1
        .addr   GameLoadMsgText2

; "Yes", "No", "Erasing", "data.", "Okay?"
GameSaveChoiceTextList:
@3765:  .addr   GameLoadYesText
        .addr   GameLoadNoText
        .addr   GameSaveMsgText1
        .addr   GameSaveMsgText2
        .addr   GameSaveMsgText3

; c3/376f: "LV"
CharBlock1LevelText:
@376f:  .byte   $9d,$39,$8b,$95,$00

; c3/3774: "HP"
CharBlock1HPText:
@3774:  .byte   $dd,$39,$87,$8f,$00

; c3/3779: "MP"
CharBlock1MPText:
@3779:  .byte   $1d,$3a,$8c,$8f,$00

; c3/377e: "/"
CharBlock1HPSlashText:
@377e:  .byte   $eb,$39,$c0,$00

; c3/3782: "/"
CharBlock1MPSlashText:
@3782:  .byte   $2b,$3a,$c0,$00

; c3/3786: "LV"
CharBlock2LevelText:
@3786:  .byte   $1d,$3b,$8b,$95,$00

; c3/378b: "HP"
CharBlock2HPText:
@378b:  .byte   $5d,$3b,$87,$8f,$00

; c3/3790: "MP"
CharBlock2MPText:
@3790:  .byte   $9d,$3b,$8c,$8f,$00

; c3/3795: "/"
CharBlock2HPSlashText:
@3795:  .byte   $6b,$3b,$c0,$00

; c3/3799: "/"
CharBlock2MPSlashText:
@3799:  .byte   $ab,$3b,$c0,$00

; c3/379d: "LV"
CharBlock3LevelText:
@379d:  .byte   $9d,$3c,$8b,$95,$00

; c3/37a2: "HP"
CharBlock3HPText:
@37a2:  .byte   $dd,$3c,$87,$8f,$00

; c3/37a7: "MP"
CharBlock3MPText:
@37a7:  .byte   $1d,$3d,$8c,$8f,$00

; c3/37ac: "/"
CharBlock3HPSlashText:
@37ac:  .byte   $eb,$3c,$c0,$00

; c3/37b0: "/"
CharBlock3MPSlashText:
@37b0:  .byte   $2b,$3d,$c0,$00

; c3/37b4: "LV"
CharBlock4LevelText:
@37b4:  .byte   $1d,$3e,$8b,$95,$00

; c3/37b9: "HP"
CharBlock4HPText:
@37b9:  .byte   $5d,$3e,$87,$8f,$00

; c3/37be: "MP"
CharBlock4MPText:
@37be:  .byte   $9d,$3e,$8c,$8f,$00

; c3/37c3: "/"
CharBlock4HPSlashText:
@37c3:  .byte   $6b,$3e,$c0,$00

; c3/37c7: "/"
CharBlock4MPSlashText:
@37c7:  .byte   $ab,$3e,$c0,$00

; c3/37cb: "Item"
MainMenuItemText:
@37cb:  .byte   $39,$79,$88,$ad,$9e,$a6,$00

; c3/37d2: "Skills"
MainMenuSkillsText:
@37d2:  .byte   $b9,$79,$92,$a4,$a2,$a5,$a5,$ac,$00

; c3/37db: "Equip"
MainMenuEquipText:
@37db:  .byte   $39,$7a,$84,$aa,$ae,$a2,$a9,$00

; c3/37e3: "Relic"
MainMenuRelicText:
@37e3:  .byte   $b9,$7a,$91,$9e,$a5,$a2,$9c,$00

; c3/37eb: "Status"
MainMenuStatusText:
@37eb:  .byte   $39,$7b,$92,$ad,$9a,$ad,$ae,$ac,$00

; c3/37f4: "Config"
MainMenuConfigText:
@37f4:  .byte   $b9,$7b,$82,$a8,$a7,$9f,$a2,$a0,$00

; c3/37fd: "Save"
MainMenuSaveText:
@37fd:  .byte   $39,$7c,$92,$9a,$af,$9e,$00

; c3/3804: "Time"
MainMenuTimeText:
@3804:  .byte   $bb,$7c,$93,$a2,$a6,$9e,$00

; c3/380b: ":"
MainMenuColonText:
@380b:  .byte   $ff,$7c,$c1,$00

; c3/380f: "Steps"
MainMenuStepsText:
@380f:  .byte   $b7,$7d,$92,$ad,$9e,$a9,$ac,$00

; c3/3817: "GP"
MainMenuGilText:
@3817:  .byte   $77,$7e,$86,$a9,$00

; c3/381c: "Yes"
GameLoadYesText:
@381c:  .byte   $bd,$7a,$98,$9e,$ac,$00

; c3/3822: "No"
GameLoadNoText:
@3822:  .byte   $3d,$7b,$8d,$a8,$00

; c3/3827: "This"
GameLoadMsgText1:
@3827:  .byte   $37,$79,$93,$a1,$a2,$ac,$00

; c3/382e: "data?"
GameLoadMsgText2:
@382e:  .byte   $b7,$79,$9d,$9a,$ad,$9a,$bf,$00

; c3/3836: "Erasing"
GameSaveMsgText1:
@3836:  .byte   $37,$79,$84,$ab,$9a,$ac,$a2,$a7,$a0,$00

; c3/3840: "data."
GameSaveMsgText2:
@3840:  .byte   $b7,$79,$9d,$9a,$ad,$9a,$c5,$00

; c3/3848: "Okay?"
GameSaveMsgText3:
@3848:  .byte   $37,$7a,$8e,$a4,$9a,$b2,$bf,$00

; c3/3850: "Order"
MainMenuOrderText:
@3850:  .byte   $3d,$81,$8e,$ab,$9d,$9e,$ab,$00

; ------------------------------------------------------------------------------
