
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: equip.asm                                                            |
; |                                                                            |
; | description: equip/relic menu, and party equip menu                        |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

inc_lang "text/item_name_%s.inc"

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ init cursor (equip, optimum, rmove, empty) ]

LoadEquipOptionCursor:
@8e50:  ldy     #near EquipOptionCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip, optimum, rmove, empty) ]

UpdateEquipOptionCursor:
@8e56:  jsr     MoveCursor

InitEquipOptionCursor:
@8e59:  ldy     #near EquipOptionCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipOptionCursorProp:
        make_cursor_prop {0, 0}, {4, 1}, NO_Y_WRAP

EquipOptionCursorPos:
.if LANG_EN
@8e64:  .byte   $00,$10
        .byte   $38,$10
        .byte   $80,$10
        .byte   $b8,$10
.else
        .byte   $10,$10
        .byte   $38,$10
        .byte   $70,$10
        .byte   $a0,$10
.endif

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic slot select) ]

LoadEquipSlotCursor:
@8e6c:  ldy     #near EquipSlotCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic slot select) ]

UpdateEquipSlotCursor:
@8e72:  jsr     MoveCursor

InitEquipSlotCursor:
@8e75:  ldy     #near EquipSlotCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipSlotCursorProp:
        make_cursor_prop {0, 0}, {1, 4}, NO_X_WRAP

EquipSlotCursorPos:
.if LANG_EN
@8e80:  .byte   $00,$2c
        .byte   $00,$38
        .byte   $00,$44
        .byte   $00,$50
.else
        .byte   $38,$2c
        .byte   $38,$38
        .byte   $38,$44
        .byte   $38,$50
.endif

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic item select, scrolling page) ]

LoadEquipLongListCursor:
@8e88:  ldy     #near EquipListCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic item select, scrolling page) ]

UpdateEquipLongListCursor:
@8e8e:  jsr     MoveListCursor

InitEquipLongListCursor:
@8e91:  ldy     #near EquipListCursorPos
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic item select, single page) ]

LoadEquipShortListCursor:
@8e97:  ldy     #near EquipListCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic item select, single page) ]

UpdateEquipShortListCursor:
@8e9d:  jsr     MoveCursor

InitEquipShortListCursor:
@8ea0:  ldy     #near EquipListCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipListCursorProp:
        make_cursor_prop {0, 0}, {1, 9}, {NO_X_WRAP, NO_Y_WRAP}

EquipListCursorPos:
@8eab:  .byte   $00,$68
        .byte   $00,$74
        .byte   $00,$80
        .byte   $00,$8c
        .byte   $00,$98
        .byte   $00,$a4
        .byte   $00,$b0
        .byte   $00,$bc
        .byte   $00,$c8

; ------------------------------------------------------------------------------

; [ load cursor for relic options (equip/remove) ]

LoadRelicOptionCursor:
@8ebd:  ldy     #near RelicOptionCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for relic options (equip/remove) ]

UpdateRelicOptionCursor:
@8ec3:  jsr     MoveCursor

InitRelicOptionCursor:
@8ec6:  ldy     #near RelicOptionCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

RelicOptionCursorProp:
        make_cursor_prop {0, 0}, {2, 1}, NO_Y_WRAP

RelicOptionCursorPos:
.if LANG_EN
@8ed1:  .byte   $10,$10
        .byte   $48,$10
.else
        .byte   $10,$10
        .byte   $38,$10
.endif

; ------------------------------------------------------------------------------

; [ load cursor for relic slot select ]

LoadRelicSlotCursor:
@8ed5:  ldy     #near RelicSlotCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for relic slot select ]

UpdateRelicSlotCursor:
@8edb:  jsr     MoveCursor

InitRelicSlotCursor:
@8ede:  ldy     #near RelicSlotCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

RelicSlotCursorProp:
        make_cursor_prop {0, 0}, {1, 2}, NO_X_WRAP

RelicSlotCursorPos:
.if LANG_EN
@8ee9:  .byte   $00,$44
        .byte   $00,$50
.else
        .byte   $38,$44
        .byte   $38,$50
.endif

; ------------------------------------------------------------------------------

; [ draw party equipment overview menu ]

DrawPartyEquipMenu:
@8eed:  lda     #$02
        sta     hBG1SC
        jsr     ClearBG2ScreenA
        ldy     #near PartyEquipWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     DrawPartyEquipSlot1
        jsr     DrawPartyEquipSlot2
        jsr     DrawPartyEquipSlot3
        jsr     DrawPartyEquipSlot4
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     ClearBG3ScreenA
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ draw text for character slot 1 in party equip menu ]

DrawPartyEquipSlot1:
@8f1c:  lda     zCharID::Slot1
        bmi     @8f35
.if !LANG_EN
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near _c3a9f8
        ldy     #sizeof__c3a9f8
        jsr     DrawPosKanaList
.endif
        ldx     zCharPropPtr::Slot1
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG1A, {2, 3}
.else
        ldy_pos BG1A, {2, 2}
.endif
        jsr     DrawCharName
        stz     zSelIndex
        lda     #$04
        jsr     DrawPartyEquipItems
@8f35:  rts

; ------------------------------------------------------------------------------

; [ draw text for character slot 2 in party equip menu ]

DrawPartyEquipSlot2:
@8f36:  lda     zCharID::Slot2
        bmi     @8f51
.if !LANG_EN
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near _c3aa04
        ldy     #sizeof__c3aa04
        jsr     DrawPosKanaList
.endif
        ldx     zCharPropPtr::Slot2
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG1A, {2, 11}
.else
        ldy_pos BG1A, {2, 10}
.endif
        jsr     DrawCharName
        lda     #1
        sta     zSelIndex
        lda     #$0c
        jsr     DrawPartyEquipItems
@8f51:  rts

; ------------------------------------------------------------------------------

; [ draw text for character slot 3 in party equip menu ]

DrawPartyEquipSlot3:
@8f52:  lda     zCharID::Slot3
        bmi     @8f6d
.if !LANG_EN
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near _c3aa10
        ldy     #sizeof__c3aa10
        jsr     DrawPosKanaList
.endif
        ldx     zCharPropPtr::Slot3
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG1A, {2, 19}
.else
        ldy_pos BG1A, {2, 18}
.endif
        jsr     DrawCharName
        lda     #2
        sta     zSelIndex
        lda     #$14
        jsr     DrawPartyEquipItems
@8f6d:  rts

; ------------------------------------------------------------------------------

; [ draw text for character slot 4 in party equip menu ]

DrawPartyEquipSlot4:
@8f6e:  lda     zCharID::Slot4
        bmi     @8f89
.if !LANG_EN
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near _c3aa1c
        ldy     #sizeof__c3aa1c
        jsr     DrawPosKanaList
.endif
        ldx     zCharPropPtr::Slot4
        stx     zSelCharPropPtr
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG1A, {2, 27}
.else
        ldy_pos BG1A, {2, 26}
.endif
        jsr     DrawCharName
        lda     #3
        sta     zSelIndex
        lda     #$1c
        jsr     DrawPartyEquipItems
@8f89:  rts

; ------------------------------------------------------------------------------

; [ draw one character's equipment in party equipment overview menu ]

DrawPartyEquipItems:
@8f8a:  sta     ze2
        stz     ze0
        ldy     zSelCharPropPtr
        clr_ax
@8f92:  phx
        phy
        phy
        phx
        stz     ze5
        lda     f:PartyEquipItemsXTbl,x
        sta     ze4
        lda     f:PartyEquipItemsYTbl,x
        clc
        adc     ze2
        ldx     ze4
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        plx
        cpx     #$0002
        bcs     @8fbe
        jsr     _c3941d
        bra     @8fc0
@8fbe:  stz     ze0
@8fc0:  ply
        clr_a
        lda     $001f,y
        jsr     _c38fe1
        jsr     DrawPosTextBuf
        ply
        iny
        plx
        inx
        cpx     #6
        bne     @8f92
        rts

; ------------------------------------------------------------------------------

PartyEquipItemsXTbl:
.if LANG_EN
@8fd5:  .byte   $02,$11,$02,$11,$02,$11
.else
        .byte   $07,$15,$07,$15,$07,$15
.endif

PartyEquipItemsYTbl:
.if LANG_EN
@8fdb:  .byte   $01,$01,$03,$03,$05,$05
.else
        .byte   $00,$00,$02,$02,$04,$04
.endif

; ------------------------------------------------------------------------------

; [  ]

_c38fe1:
@8fe1:  pha
        ldx     #$9e8b
        stx     hWMADDL
@8fe8:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @8fe8
        clr_a
        lda     ze0
        beq     @8ff7
        pla
        bra     @8ffc
@8ff7:  pla
        cmp     #$ff
        beq     @901f
@8ffc:  sta     hM7A
        stz     hM7A
        lda     #ITEM_NAME_SIZE
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #ITEM_NAME_SIZE
@9010:  lda     f:ItemName,x
        sta     hWMDATA
        inx
        dey
        bne     @9010
        stz     hWMDATA
        rts
@901f:  ldy     #ITEM_NAME_SIZE
        lda     #$ff
@9024:  sta     hWMDATA
        dey
        bne     @9024
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

PartyEquipWindow:                       make_window BG2A, {1, 1}, {28, 24}

; ------------------------------------------------------------------------------

; [ draw equip menu ]

DrawEquipMenu:
@9032:  jsr     DrawEquipRelicCommon
        jsr     _c3911b
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near EquipSlotTextList
        ldy     #sizeof_EquipSlotTextList
        jsr     DrawPosKanaList
        jsr     DrawEquipOptions
        jsr     TfrBG3ScreenAB
        jmp     _c39e0f

; ------------------------------------------------------------------------------

; [ draw equip options (equip, optimum, remove, empty) ]

DrawEquipOptions:
@904e:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near EquipOptionTextList
        ldy     #sizeof_EquipOptionTextList
        jsr     DrawPosKanaList
        rts

; ------------------------------------------------------------------------------

; [ draw relic options (equip, remove) ]

DrawRelicOptions:
@905c:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near RelicOptionTextList
        ldy     #sizeof_RelicOptionTextList
        jsr     DrawPosKanaList
        rts

; ------------------------------------------------------------------------------

; [ draw relic menu ]

DrawRelicMenu:
@906a:  jsr     DrawEquipRelicCommon
        jsr     GetSelCharPropPtr
        lda     $0023,y
        sta     zb0
        lda     $0024,y
        sta     zb1
        jsr     _c39131
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near RelicSlotTextList
        ldy     #sizeof_RelicSlotTextList
        jsr     DrawPosKanaList
        jsr     DrawRelicOptions
        jsr     _c3a6ab
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ draw common parts of equip/relic menu ]

DrawEquipRelicCommon:
@9093:  jsr     UpdateEquipStats
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$01
        sta     hBG1SC
        lda     #$42
        sta     hBG3SC
        jsr     _c3960c
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        ldy     #near EquipBtmWindow1
        jsr     DrawWindow
        ldy     #near EquipTopWindow1
        jsr     DrawWindow
        ldy     #near EquipOptionsWindow
        jsr     DrawWindow
        ldy     #near EquipBtmWindow2
        jsr     DrawWindow
        ldy     #near EquipTopWindow2
        jsr     DrawWindow
        ldy     #near EquipTitleWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     DrawEquipCharName
        jsr     CreateEquipPortraitTask
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near EquipStatTextList1
        ldy     #sizeof_EquipStatTextList1
        jsr     DrawPosList
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near EquipStatTextList2
        ldy     #sizeof_EquipStatTextList2
        jsr     DrawPosKanaList
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ update character battle stats ]

UpdateEquipStats:
@9110:  clr_a
        lda     zSelIndex
        tax
        lda     zCharID,x                   ; character number
        jsl     UpdateEquip_ext
        rts

; ------------------------------------------------------------------------------

; [ redraw items in equip menu ]

_c3911b:
@911b:  jsr     _c39975
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jsr     _c3913e
        jsr     _c3922d
        jsr     _c393fc
        jsr     _c39435
        jmp     _c39443

; ------------------------------------------------------------------------------

; [  ]

_c39131:
@9131:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jsr     _c3913e
        jsr     _c39451
        jmp     _c3945f

; ------------------------------------------------------------------------------

; [  ]

_c3913e:
@913e:  jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        jsr     CheckHandEffects
        jsr     _c39207
        phb
        lda     #$7e
        pha
        plb
        jsr     _c391c4
        lda     $3006
        jsr     HexToDec3
        ldx_pos BG3A, {23, 17}
        jsr     DrawNum3
        lda     $3004
        jsr     HexToDec3
        ldx_pos BG3A, {23, 19}
        jsr     DrawNum3
        lda     $3002
        jsr     HexToDec3
        ldx_pos BG3A, {23, 21}
        jsr     DrawNum3
        lda     $3000
        jsr     HexToDec3
        ldx_pos BG3A, {23, 23}
        jsr     DrawNum3
        jsr     CalcOldBattlePower
        ldx     zf1
        stx     zf3
        jsr     HexToDec5
        ldx_pos BG3A, {23, 25}
        jsr     Draw16BitNum
        lda     $301a
        jsr     HexToDec3
        ldx_pos BG3A, {23, 27}
        jsr     DrawNum3
        lda     $3008
        jsr     HexToDec3
        ldx_pos BG3A, {23, 29}
        jsr     DrawNum3
        lda     $301b
        jsr     HexToDec3
        ldx_pos BG3A, {23, 31}
        jsr     DrawNum3
        lda     $300a
        jsr     HexToDec3
        ldx_pos BG3B, {23, 1}
        jsr     DrawNum3
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c391c4:
@91c4:  jsr     GetSelCharPropPtr
        lda     $7e3032
        jsr     _c391ec
        lda     $3034
        and     #$01
        bne     @91dc
        lda     $0015,y
        and     #$01
        beq     @91eb
@91dc:  lda     $3034
        clc
        and     #$01
        sta     ze0
        ror2
        ora     ze0
        sta     $0015,y
@91eb:  rts

; ------------------------------------------------------------------------------

; [  ]

_c391ec:
@91ec:  and     #$25
        not_a
        sta     ze1
        lda     $0014,y
        and     ze1
        sta     $0014,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c391fb:
@91fb:  clc
        and     #$01
        ror2
        ora     $0015,y
        sta     $0015,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39207:
@9207:  ldx     z0
        longa
loop:   .repeat 2
        lda     $11a0,x
        sta     $7e3000,x
        inx2
.endrep
        cpx     #$0040
        bne     loop
        shorta
        lda     za1
        sta     za0
        lda     zcd
        sta     zce
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3922d:
.if !LANG_EN
@99d6:  ldy     #$abd6
        jsr     DrawPosKana
        ldy     #$abdf
        jsr     DrawPosKana
        lda     $11d8
        and     #$20
        beq     @99f2
        jsr     _c3922e
        ldy     #$abe8
        jsr     DrawPosKana
@99f2:  lda     $11d8
        and     #$10
        beq     @9a02
        jsr     _c3922e
        ldy     #$abf1
        jsr     DrawPosKana
@9a02:  lda     $11d8
        and     #$08
        beq     @9a12
        jsr     _c3922e
        ldy     #$abfa
        jsr     DrawPosKana
@9a12:  lda     #$20
        sta     zTextColor
.endif
@922d:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3922e:
@922e:  lda     #$2c
        sta     zTextColor
        rts

; ------------------------------------------------------------------------------

; [ update modified stats text ]

_c39233:
@9233:  lda     $7e9d89     ; length of item list
        beq     @923e       ; branch if list is empty
        jsr     CheckCanEquipSelItem
        bcs     @9241       ; branch if item can be equipped
@923e:  jmp     _c39c87
@9241:  jsr     GetSelCharPropPtr
        lda     z25         ; main menu position
        cmp     #$02
        beq     @924e       ; branch if equip
        iny4                ; add 4 to character data pointer (relic)
@924e:  longa_clc
        tya
        shorta
        adc     z5f         ; add item slot
        tay
        clr_a
        lda     z4b         ; selected item
        tax
        lda     $7e9d8a,x   ; item number
        tax
        lda     $001f,y     ; $64 = character's equipped item
        sta     z64
        lda     $1869,x     ; selected item
        sta     $001f,y     ; equip on character
        phy
        jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        jsr     CheckHandEffects
        jsr     UpdateEquipStatColors
        lda     $11a6       ; vigor
        jsr     HexToDec3
        ldx_pos BG3A, {27, 17}
        lda     wStatTextColor::Strength
        sta     zTextColor
        jsr     DrawNum3
        lda     $11a4
        jsr     HexToDec3
        ldx_pos BG3A, {27, 19}
        lda     wStatTextColor::Speed
        sta     zTextColor
        jsr     DrawNum3
        lda     $11a2
        jsr     HexToDec3
        ldx_pos BG3A, {27, 21}
        lda     wStatTextColor::Stamina
        sta     zTextColor
        jsr     DrawNum3
        lda     $11a0
        jsr     HexToDec3
        ldx_pos BG3A, {27, 23}
        lda     wStatTextColor::MagPwr
        sta     zTextColor
        jsr     DrawNum3
        jsr     CalcNewBattlePower
        jsr     HexToDec5
        ldx_pos BG3A, {27, 25}
        lda     wStatTextColor::BatPwr
        sta     zTextColor
        jsr     Draw16BitNum
        lda     $11ba
        jsr     HexToDec3
        ldx_pos BG3A, {27, 27}
        lda     wStatTextColor::Defense
        sta     zTextColor
        jsr     DrawNum3
        lda     $11a8
        jsr     HexToDec3
        ldx_pos BG3A, {27, 29}
        lda     wStatTextColor::Evade
        sta     zTextColor
        jsr     DrawNum3
        lda     $11bb
        jsr     HexToDec3
        ldx_pos BG3A, {27, 31}
        lda     wStatTextColor::MagDef
        sta     zTextColor
        jsr     DrawNum3
        lda     $11aa
        jsr     HexToDec3
        ldx_pos BG3B, {27, 1}
        lda     wStatTextColor::MBlock
        sta     zTextColor
        jsr     DrawNum3
        ply
        lda     z64         ; restore equipped item
        sta     $001f,y
        rts

; ------------------------------------------------------------------------------

; [ update stat text colors ]

UpdateEquipStatColors:
@9320:  phb
        lda     #$7e
        pha
        plb
        clr_ax
@9327:  lda     f:EquipStatOffsets,x    ; pointer to battle stat
        phx
        tax
        lda     f:$0011a0,x             ; stat with item equipped
        cmp     $3000,x                 ; compare with saved stat
        beq     @933c                   ; branch if no change
        bcc     @9340                   ; branch if less
        lda     #$28                    ; yellow text
        bra     @9342
@933c:  lda     #$20                    ; white text
        bra     @9342
@9340:  lda     #$24                    ; gray text
@9342:  plx
        sta     near wStatTextColor,x
        inx                             ; next stat
        cpx     #8
        bne     @9327
        jsr     CalcNewBattlePower
        jsr     CalcOldBattlePower
        ldy     zf3
        cpy     zf1
        beq     @935e
        bcc     @9362
        lda     #BG3_TEXT_COLOR::YELLOW
        bra     @9364
@935e:  lda     #BG3_TEXT_COLOR::DEFAULT
        bra     @9364
@9362:  lda     #BG3_TEXT_COLOR::GRAY
@9364:  sta     near wStatTextColor::BatPwr
        plb
        rts

; ------------------------------------------------------------------------------

; pointers to battle stats (+$11a0) vigor, speed, stamina, mag.pwr, defense, evade, magic defense, mblock
EquipStatOffsets:
@9369:  .byte   $06,$04,$02,$00,$1a,$08,$1b,$0a

; ------------------------------------------------------------------------------

; [ calculate battle power (equipped weapons) ]

; +$f3 = battle power (out)

CalcNewBattlePower:
@9371:  lda     za1         ; branch if no gauntlet bonus
        beq     @938b
        lda     f:$0011ac     ; right hand battle power
        beq     @9381       ; branch if right hand empty
        sta     f:$0011ad     ; save as left hand battle power
        bra     @939a
@9381:  lda     f:$0011ad     ; copy left hand battle power to right hand (double battle power)
        sta     f:$0011ac
        bra     @939a
@938b:  lda     zcd         ; branch if wearing genji glove
        bne     @939a
        lda     f:$0011ac
        beq     @939a
        clr_a
        sta     f:$0011ad
@939a:  lda     f:$0011ac
        clc
        adc     f:$0011ad
        sta     zf3
        clr_a
        adc     #$00
        sta     zf4
        rts

; ------------------------------------------------------------------------------

; [ calculate battle power (saved weapons) ]

; +$f1 = battle power (out)

CalcOldBattlePower:
@93ab:  lda     za0
        beq     @93c5
        lda     $7e300c
        beq     @93bb
        sta     $7e300d
        bra     @93d4
@93bb:  lda     $7e300d
        sta     $7e300c
        bra     @93d4
@93c5:  lda     zce
        bne     @93d4
        lda     $7e300c
        beq     @93d4
        clr_a
        sta     $7e300d
@93d4:  lda     $7e300c
        clc
        adc     $7e300d
        sta     zf1
        clr_a
        adc     #$00
        sta     zf2
        rts

; ------------------------------------------------------------------------------

; [ draw character name for equipment menus ]

DrawEquipCharName:
@93e5:  jsr     GetSelCharPropPtr
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
.if LANG_EN
        ldy_pos BG3A, {23, 13}
        jmp     DrawCharName
.else
        ldy_pos BG3A, {19, 10}
        jsr     DrawCharName
        ldy_pos BG3A, {19, 12}
        jmp     DrawCharTitle
.endif

; ------------------------------------------------------------------------------

; [ update pointer to current character data ]

GetSelCharPropPtr:
@93f2:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x       ; pointer to character data
        sty     zSelCharPropPtr
        rts

; ------------------------------------------------------------------------------

; [  ]

_c393fc:
@93fc:  jsr     _c3941d
.if LANG_EN
        ldx_pos BG3A, {9, 7}
.else
        ldx_pos BG3A, {9, 6}
.endif
        jsr     _c3946d
        lda     $001f,y
        jsr     _c38fe1
        jsr     DrawPosTextBuf
        jsr     _c3941d
.if LANG_EN
        ldx_pos BG3A, {9, 9}
.else
        ldx_pos BG3A, {9, 8}
.endif
        jsr     _c3946d
        lda     $0020,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3941d:
@941d:  jsr     GetSelCharPropPtr
        lda     $001f,y
        cmp     #$ff
        bne     @9432
        lda     $0020,y
        cmp     #$ff
        bne     @9432
        sta     ze0
        bra     @9434
@9432:  stz     ze0
@9434:  rts

; ------------------------------------------------------------------------------

; [  ]

_c39435:
.if LANG_EN
@9435:  ldx_pos BG3A, {9, 11}
.else
        ldx_pos BG3A, {9, 10}
.endif
        jsr     _c3946d
        stz     ze0
        lda     $0021,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c39443:
.if LANG_EN
@9443:  ldx_pos BG3A, {9, 13}
.else
        ldx_pos BG3A, {9, 12}
.endif
        jsr     _c3946d
        stz     ze0
        lda     $0022,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c39451:
.if LANG_EN
@9451:  ldx_pos BG3A, {9, 11}
.else
        ldx_pos BG3A, {9, 10}
.endif
        jsr     _c3946d
        stz     ze0
        lda     $0023,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3945f:
.if LANG_EN
@945f:  ldx_pos BG3A, {9, 13}
.else
        ldx_pos BG3A, {9, 12}
.endif
        jsr     _c3946d
        stz     ze0
        lda     $0024,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3946d:
@946d:  longa
        txa
        sta     $7e9e89
        shorta
        jmp     GetSelCharPropPtr

; ------------------------------------------------------------------------------

; [  ]

_c39479:
@9479:  jsr     _c38fe1
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; inventory/stats window
; current equipped items window
; equip options window (equip, optimum, remove, empty)
; inventory/stats window
; current equipped items window
; equip title window

EquipBtmWindow1:                        make_window BG2A, {1, 12}, {28, 13}
EquipTopWindow1:                        make_window BG2A, {1, 3}, {28, 7}
EquipOptionsWindow:                     make_window BG2A, {1, 1}, {28, 2}
EquipBtmWindow2:                        make_window BG2B, {1, 12}, {28, 13}
EquipTopWindow2:                        make_window BG2B, {1, 3}, {28, 7}
.if LANG_EN
EquipTitleWindow:                       make_window BG2B, {23, 1}, {6, 2}
.else
EquipTitleWindow:                       make_window BG2B, {24, 1}, {5, 2}
.endif

; ------------------------------------------------------------------------------

; [ init BG scroll HDMA for party equipment overview ]

; also used for final battle order

InitPartyEquipScrollHDMA:
@9497:  lda     #$02
        sta     $4350
        lda     #$0e
        sta     $4351
        ldy     #near _c395d8
        sty     $4352
        lda     #^_c395d8
        sta     $4354
        lda     #^_c395d8
        sta     $4357
        lda     #$20
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; [ init BG scroll HDMA for equip/relic menu ]

InitEquipScrollHDMA:
@94b6:  lda     #$02
        sta     $4350
        lda     #<hBG3VOFS
        sta     $4351
        ldy     #near _c395d8
        sty     $4352
        lda     #^_c395d8
        sta     $4354
        lda     #^_c395d8
        sta     $4357
        lda     #$20
        tsb     zEnableHDMA
        jsr     LoadEquipBG1VScrollHDMATbl
        ldx     z0
@94d9:  lda     f:_c39564,x
        sta     $7e9bc9,x
        inx
        cpx     #sizeof__c39564
        bne     @94d9
        lda     #$02
        sta     $4360
        lda     #<hBG1HOFS
        sta     $4361
        ldy     #$9bc9
        sty     $4362
        lda     #$7e
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$02
        sta     $4370
        lda     #<hBG1VOFS
        sta     $4371
        ldy     #$9849
        sty     $4372
        lda     #$7e
        sta     $4374
        lda     #$7e
        sta     $4377
        lda     #$c0
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; [ load bg1 vertical scroll HDMA table for equip/relic item list ]

LoadEquipBG1VScrollHDMATbl:
@9520:  ldx     z0
@9522:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        cpx     #$0012
        bne     @9522
@9530:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        clr_a
        lda     z49
        asl4
        and     #$ff
        longa_clc
        adc     f:_c39571,x
        sta     $7e9849,x
        shorta
        inx2
        cpx     #$0063
        bne     @9530
@9555:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        cpx     #$0067
        bne     @9555
        rts

; ------------------------------------------------------------------------------

begin_block _c39564
        hdma_word 39, $0100
        hdma_word 60, $0100
        hdma_word 108, $0000
        hdma_word 30, $0100
        hdma_end
end_block _c39564

; ------------------------------------------------------------------------------

_c39571:
        hdma_word 63, 0
        hdma_word 12, 4
        hdma_word 12, 8
        hdma_word 10, 12
        hdma_word 1, 12
        hdma_word 1, 12
        hdma_word 4, -96
        hdma_word 4, -96
        hdma_word 4, -96
        hdma_word 4, -92
        hdma_word 4, -92
        hdma_word 4, -92
        hdma_word 4, -88
        hdma_word 4, -88
        hdma_word 4, -88
        hdma_word 4, -84
        hdma_word 4, -84
        hdma_word 4, -84
        hdma_word 4, -80
        hdma_word 4, -80
        hdma_word 4, -80
        hdma_word 4, -76
        hdma_word 4, -76
        hdma_word 4, -76
        hdma_word 4, -72
        hdma_word 4, -72
        hdma_word 4, -72
        hdma_word 4, -68
        hdma_word 4, -68
        hdma_word 4, -68
        hdma_word 4, -64
        hdma_word 4, -64
        hdma_word 4, -64
        hdma_word 30, 16
        hdma_end

; ------------------------------------------------------------------------------

_c395d8:
        hdma_word 15, 0
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
        hdma_word 12, 64
        hdma_end

; ------------------------------------------------------------------------------

; [  ]

_c3960c:
@960c:  jsr     ClearEquipOptionText
        ldy     z0
        sty     zBG2HScroll
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39614:
@9614:  jsr     ClearEquipOptionText
        ldy     #$0100
        sty     zBG2HScroll
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        rts

; ------------------------------------------------------------------------------

; [ menu state $36: equip menu options (equip, optimum, remove, empty) ]

MenuState_36:
@9621:  jsr     _c3960c
        jsr     DrawEquipOptions
        jsr     UpdateEquipOptionCursor
        lda     z08
        bit     #JOY_A
        beq     @9635
        jsr     PlaySelectSfx
        bra     SelectEquipOption
@9635:  lda     z08+1
        bit     #>JOY_B
        beq     @9648
        jsr     PlayCancelSfx
        jsr     UpdateEquipStats
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState
        rts
@9648:  lda     #$35
        sta     ze0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ draw "EQUIP" title in equip/relic menu ]

DrawEquipTitleEquip:
@964f:  ldy     #near EquipTitleEquipText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [ draw "REMOVE" title in equip/relic menu ]

DrawEquipTitleRemove:
@9656:  ldy     #near EquipTitleRemoveText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [ clear equip options ]

ClearEquipOptionText:
@965d:  ldy     #near EquipBlankOptionsText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [ select equip option (equip, optimum, remove, empty) ]

SelectEquipOption:
@9664:  clr_a
        lda     z4b
        asl
        tax
        jmp     (near SelectEquipOptionTbl,x)

SelectEquipOptionTbl:
@966c:  .addr   SelectEquipOption_00
        .addr   SelectEquipOption_01
        .addr   SelectEquipOption_02
        .addr   SelectEquipOption_03

; ------------------------------------------------------------------------------

; [ 0: equip ]

SelectEquipOption_00:
@9674:  jsr     _c39614
        jsr     DrawEquipTitleEquip
        jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #$55
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ 1: optimum ]

SelectEquipOption_01:
@9685:  jsr     EquipOptimum
        jsr     _c3911b
        stz     z4d
        rts

; ------------------------------------------------------------------------------

; [ 2: remove ]

SelectEquipOption_02:
@968e:  jsr     _c39614
        jsr     DrawEquipTitleRemove
        jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #$56
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ 3: empty ]

SelectEquipOption_03:
@969f:  jsr     EquipRemoveAll
        jsr     _c3911b
        stz     z4d
        rts

; ------------------------------------------------------------------------------

; [ remove character's equipment ]

EquipRemoveAll:
@96a8:  jsr     GetSelCharPropPtr
        lda     $001f,y                 ; add weapon to inventory
        jsr     IncItemQty
        lda     $0020,y                 ; add shield to inventory
        jsr     IncItemQty
        lda     $0021,y                 ; add helmet to inventory
        jsr     IncItemQty
        lda     $0022,y                 ; add armor to inventory
        jsr     IncItemQty
        lda     #$ff
        sta     $001f,y                 ; remove weapon
        sta     $0020,y                 ; remove shield
        sta     $0021,y                 ; remove helmet
        sta     $0022,y                 ; remove armor
        rts

; ------------------------------------------------------------------------------

; [ optimize a character's equipment (from field) ]

; $0201 = character number

OptimizeCharEquip:
@96d2:  jsr     InitCharProp
        clr_ax
        lda     w0201                   ; character number
@96da:  cmp     zCharID,x                   ; look for character in party
        beq     @96e6
        inx
        cpx     #4
        bne     @96da
@96e4:  bra     @96e4                   ; infinite loop
@96e6:  txa
        sta     zSelIndex
        jsr     UpdateEquipStats
        jsr     EquipOptimum
        rtl

; ------------------------------------------------------------------------------

; [ set optimum equipment ]

EquipOptimum:
@96f0:  jsr     UpdateEquipStats
        jsr     EquipRemoveAll
        jsr     GetSelCharPropPtr
        sty     zf3                     ; +$f3 = pointer to character data
        lda     $11d8                   ; gauntlet effect
        and     #$08
        beq     @971a                   ; branch if not set

; select optimum 2-handed weapon
        stz     z4b
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        jsr     GetBest2Hand
        ldy     zf3
        sta     $001f,y                 ; set main-hand
        jsr     DecItemQty
        bra     @976b

; select optimum one-handed weapon
@971a:  stz     z4b                     ; cursor position = 0 (main hand)
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        ldy     zf3
        jsr     GetBestEquip
        sta     $001f,y                 ; set main hand
        jsr     DecItemQty
        lda     $11d8                   ; genji glove effect
        and     #$10
        bne     @9751                   ; branch if second hand can use a weapon

; select optimum shield
        lda     #$01                    ; cursor position = 1 (off-hand)
        sta     z4b
        jsr     GetValidEquip
        jsr     GetValidShields
        jsr     SortValidEquip
        ldy     zf3
        jsr     GetBestEquip
        sta     $0020,y                 ; set off-hand
        jsr     DecItemQty
        bra     @976b

; genji glove (equip a weapon in off-hand)
@9751:  lda     #$01                    ; cursor position = 1 (off-hand)
        sta     z4b
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        ldy     zf3
        jsr     GetBestEquip
        sta     $0020,y                 ; set off-hand
        jsr     DecItemQty
        bra     @976b

; select optimum helmet & armor
@976b:  lda     #$02                    ; cursor position = 2 (helmet)
        sta     z4b
        jsr     GetValidEquip
        jsr     SortValidEquip
        ldy     zf3
        jsr     GetBestEquip
        sta     $0021,y                 ; set helmet
        jsr     DecItemQty
        lda     #$03                    ; cursor position = 3 (armor)
        sta     z4b
        jsr     GetValidEquip
        jsr     SortValidEquip
        ldy     zf3
        jsr     GetBestEquip
        sta     $0022,y                 ; set armor
        jmp     DecItemQty

; ------------------------------------------------------------------------------

; [ update list of equippable weapons ]

GetValidWeapons:
@9795:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        ldx     z0
        txy
@979e:  clr_a
        lda     $1869,y     ; item in inventory
        cmp     #$ff
        beq     @97c8       ; branch if slot is empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$01
        bne     @97c8       ; branch if not a weapon
        longa
        lda     f:ItemProp+1,x
        bit     ze7
        beq     @97c8       ; branch if not equippable
        shorta
        tya
        sta     hWMDATA       ; add to list of weapons
        inc     ze0
@97c8:  shorta        ; next item
        iny
        cpy     #$00ff
        bne     @979e
        lda     ze0         ; set length of list
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ update list of equippable shields ]

GetValidShields:
@97d7:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        ldx     z0
        txy
@97e0:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @980a
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$03
        bne     @980a
        longa
        lda     f:ItemProp+1,x
        bit     ze7
        beq     @980a
        shorta
        tya
        sta     hWMDATA
        inc     ze0
@980a:  shorta
        iny
        cpy     #$00ff
        bne     @97e0
        lda     ze0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ select the best item in the list ]

GetBestEquip:
@9819:  phy
        phb
        lda     #$7e
        pha
        plb
        clr_ay
@9821:  clr_ax
@9823:  phx
        clr_a
        lda     $9d8a,y     ; position in inventory
        tax
        lda     $1869,x     ; item number
        plx
        cmp     f:ImpItem,x
        beq     @983c       ; branch if this is an imp item
        inx
        cpx     #$000a
        bne     @9823
        plb
        ply
        rts

; imp item
@983c:  iny
        bra     @9821

.pushseg
.segment "imp_item"

; ed/82e4
ImpItem:
        .byte ITEM::CURSED_SHLD
        .byte ITEM::THORNLET
        .byte ITEM::IMP_HALBERD
        .byte ITEM::TORTOISESHLD
        .byte ITEM::TITANIUM
        .byte ITEM::IMPS_ARMOR
        .byte ITEM::ATMA_WEAPON
        .byte ITEM::DRAINER
        .byte ITEM::SOUL_SABRE
        .byte ITEM::HEAL_ROD
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY

.popseg

; ------------------------------------------------------------------------------

; [ select the best 2-handed weapon in the list ]

GetBest2Hand:
@983f:  lda     $7e9d89     ; branch if there are items in the list
        beq     @9881
        sta     zcb         ; +$cb = number of items in list
        stz     zcb+1
        clr_ay
@984b:  clr_ax
@984d:  phx
        clr_a
        tyx
        lda     $7e9d8a,x   ; position in inventory
        tax
        lda     $1869,x     ; item number
        plx
        cmp     f:ImpItem,x
        beq     @9878       ; branch if this is an imp item
        inx
        cpx     #$000a      ; number of imp items
        bne     @984d
        sta     zc9         ; $c9 = item number
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; 2-handed weapon
        and     #$40
        beq     @9878       ; branch if not 2-handed
        lda     zc9
        rts

; imp item
@9878:  iny
        cpy     zcb
        bne     @984b       ; branch if this is not the last item in the list
        jsr     GetBestEquip
        rts

; no suitable items
@9881:  lda     #$ff        ; empty
        rts

; ------------------------------------------------------------------------------

; [ menu state $55: equip (slot select, equip) ]

MenuState_55:
@9884:  jsr     UpdateEquipSlotCursor
        jsr     _c39975

; A button
        lda     z08
        bit     #JOY_A
        beq     @98b4
        jsr     PlaySelectSfx
        lda     z4e                     ; save cursor position
        sta     z5f
        lda     #$57                    ; go to menu state $57
        sta     zMenuState
        jsr     GetValidEquip
        jsr     SortValidEquip
        jsr     InitEquipListCursor
        lda     #$55                    ; return to menu state $55 afterwards
        sta     zNextMenuState
        jsr     _c39233
        jsr     ClearBG1ScreenA
        jsr     WaitVblank
        jmp     DrawEquipItemList

; B button
@98b4:  lda     z08+1
        bit     #>JOY_B
        beq     @98c8
        jsr     PlayCancelSfx
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        lda     #$36                    ; go to menu state $36
        sta     zMenuState
        rts
@98c8:  lda     #$7e                    ; go to menu state $7e if user presses top r or l button
        sta     ze0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ menu state $56: equip (slot select, remove) ]

MenuState_56:
@98cf:  jsr     UpdateEquipSlotCursor
        lda     z08
        bit     #JOY_A
        beq     @98f4
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longa_clc
        tya
        shorta
        adc     z4b
        tay
        lda     $001f,y
        jsr     IncItemQty
        lda     #$ff
        sta     $001f,y
        jsr     _c3911b
@98f4:  lda     z08+1
        bit     #>JOY_B
        beq     @9908
        jsr     PlayCancelSfx
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        lda     #$36
        sta     zMenuState
        rts
@9908:  lda     #$7f
        sta     ze0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ menu state $57: equip (item select) ]

MenuState_57:
@990f:  jsr     _c39ad3
        jsr     _c39233
        lda     z08
        bit     #JOY_A
        beq     @9944
        jsr     CheckCanEquipSelItem
        bcc     @996e
        jsr     PlaySelectSfx
        lda     $001f,y
        cmp     #$ff
        beq     @992d
        jsr     IncItemQty
@992d:  clr_a
        lda     z4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        sta     $001f,y
        jsr     DecItemQty
        jsr     _c3911b
        bra     @994d
@9944:  lda     z08+1
        bit     #>JOY_B
        beq     @996d
        jsr     PlayCancelSfx
@994d:  jsr     _c39c87
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$c1
        trb     z46
        jsr     LoadEquipSlotCursor
        lda     z5f
        sta     z4e
        jsr     InitEquipSlotCursor
        lda     #$55
        sta     zMenuState
@996d:  rts
@996e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [ draw "r-hand" & "l-hand" text ]

_c39975:
@9975:  lda     $11d8       ; gauntlet effect
        and     #$08
        beq     @998f       ; branch if no gauntlet
        jsr     GetSelCharPropPtr
        lda     $001f,y     ; right hand (main hand)
        cmp     #$ff
        beq     @99a6       ; branch if empty
        lda     $0020,y     ; left hand (off-hand)
        cmp     #$ff
        beq     @99ca       ; branch if empty
        bra     @998f

; draw both hands with teal text
@998f:  lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        jsr     @9998
        bra     @999f

; draw "R-Hand" text
@9998:  ldy     #near EquipRHandText
        jsr     DrawPosKana
        rts

; draw "L-Hand" text
@999f:  ldy     #near EquipLHandText
        jsr     DrawPosKana
        rts

; gauntlet, main hand empty
@99a6:  lda     $0020,y     ; left hand (off-hand)
        cmp     #$ff
        bne     @99af       ; branch if not empty
        bra     @998f       ; both hands empty, draw both with teal text

; gauntlet, right hand empty
@99af:  jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon effects
        and     #$40
        beq     @998f       ; branch if not 2-handed
        lda     #BG3_TEXT_COLOR::GRAY
        sta     zTextColor
        jsr     @9998       ; draw "r-hand" text
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        bra     @999f       ; draw "l-hand" text

; gauntlet, left hand empty
@99ca:  lda     $001f,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #$40
        beq     @998f
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        jsr     @9998       ; draw "r-hand" text
        lda     #BG3_TEXT_COLOR::GRAY
        sta     zTextColor
        bra     @999f       ; draw "l-hand" text

; ------------------------------------------------------------------------------

; [ update gauntlet & genji glove effects ]

; $cd = 1 for genji glove
; $a1 = 1 for gauntlet bonus
; carry set = no gauntlet bonus
; carry clear = gauntlet w/ 2-handed weapon & no shield

CheckHandEffects:
@99e8:  stz     zcd         ; $cd = 0
        lda     $11d8       ; branch if character doesn't have genji glove
        and     #$10
        beq     @99f3
        inc     zcd         ; $cd++
@99f3:  stz     za1         ;
        lda     $11d8       ; branch if character doesn't have gauntlet
        and     #$08
        beq     @9a0c
        lda     $001f,y     ; branch if right hand is empty
        cmp     #$ff
        beq     @9a0e
        lda     $0020,y     ; branch if left hand is empty
        cmp     #$ff
        beq     @9a2b
        bra     @9a0c       ; set carry and return
@9a0c:  sec
        rts
@9a0e:  lda     $0020,y     ; branch if left hand is not empty
        cmp     #$ff
        bne     @9a17
        bra     @9a0c       ; set carry and return
@9a17:  jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon properties
        and     #$40
        beq     @9a0c       ; set carry and return if not a 2-handed weapon
        clc
        lda     #$01
        sta     za1
        rts
@9a2b:  lda     $001f,y     ; right hand
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon properties
        and     #$40
        beq     @9a0c       ; set carry and return if not a 2-handed weapon
        clc
        lda     #$01
        sta     za1
        rts

; ------------------------------------------------------------------------------

; [ check if selected item can be equipped ]

CheckCanEquipSelItem:
@9a42:  jsr     GetEquipSlotPtr
        clr_a
        lda     z4b                     ; cursor position
        bra     CheckCanEquipItem

; ------------------------------------------------------------------------------

; [ get pointer to current item slot ]

GetEquipSlotPtr:
@9a4a:  jsr     GetSelCharPropPtr
        longa_clc
        tya
        shorta
        adc     z5f                     ; add item slot number
        tay
        rts

; ------------------------------------------------------------------------------

; [ check if item can be equipped ]

;  a = position in list
; +y = pointer to current item slot
; carry set = item can be equipped, carry clear = item can't be equipped

CheckCanEquipItem:
@9a56:  phy
        tax
        lda     $7e9d8a,x               ; selected item
        tax
        lda     $1869,x                 ; item number
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; $f6 = item type
        and     #$07
        sta     zf6
        ply
        lda     z5f                     ; selected item slot
        cmp     #$02
        bcs     @9acf                   ; set carry and return if helmet or armor
        cmp     #$01
        beq     @9aa5

; right hand is selected
        lda     $0020,y                 ; left hand item
        cmp     #$ff
        beq     @9a97                   ; set carry and return if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     #$03
        beq     @9a99                   ; branch if shield
        lda     $11d8
        and     #$10
        beq     @9a99                   ; branch if character has genji glove effect
@9a97:  sec
        rts
@9a99:  lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     zf6                     ; clear carry and return if same as selected item
        beq     @9ad1
        sec
        rts

; left hand is selected
@9aa5:  lda     $001e,y                 ; right hand item
        cmp     #$ff
        beq     @9ac3                   ; set carry and return if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     #$03
        beq     @9ac5                   ; branch if shield
        lda     $11d8
        and     #$10
        beq     @9ac5                   ; branch if character has genji glove effect
@9ac3:  sec
        rts
@9ac5:  lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     zf6                     ; clear carry and return if same as selected item
        beq     @9ad1
@9acf:  sec
        rts
@9ad1:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39ad3:
@9ad3:  lda     $7e9d89
        cmp     #$0a
        jcc     UpdateEquipShortListCursor
        lda     #LIST_TYPE::EQUIP
        sta     zListType
        jsr     ScrollListPage
        jcc     UpdateEquipLongListCursor
        rts

; ------------------------------------------------------------------------------

; [ init item list cursor (equip/relic) ]

InitEquipListCursor:
@9aeb:  lda     $7e9d89
        beq     @9b0c
        cmp     #10
        bcs     @9b06

; short list (less than 10 items)
        jsr     CreateEquipSlotCursorTask
        stz     z4a
        jsr     LoadEquipShortListCursor
        lda     $7e9d89
        sta     z54
        jmp     InitEquipShortListCursor

; long list (10 or more items)
@9b06:  jsr     CreateEquipSlotCursorTask
        jsr     _c39b0d
@9b0c:  rts

; ------------------------------------------------------------------------------

; [  ]

_c39b0d:
@9b0d:  stz     z4a
        jsr     CreateScrollArrowTask2
        longa
        lda     #$0060
        sta     wTaskSpeedX,x
        lda     #$6000
        sta     hWRDIVL
        shorta
        lda     $7e9d89
        sec
        sbc     #9
        sta     hWRDIVB
        nop5
        longa
        lda     hRDDIVL
        sta     wTaskSpeedY,x
        shorta
        ldy     z0
        sty     z4f
        jsr     LoadEquipLongListCursor
        jsr     InitEquipLongListCursor
        lda     $7e9d89
        sec
        sbc     #$09
        sta     z5c
        lda     #$09
        sta     z5a
        lda     #$01
        sta     z5b
        rts

; ------------------------------------------------------------------------------

; [ update list of equippable items ]

; $4b = cursor position (0 = weapon, 1 = shield, 2 = helmet, 3 = armor)

GetValidEquip:
@9b59:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        lda     z4b         ; cursor position
        cmp     #$02
        beq     @9bb2       ; branch if helmet
        cmp     #$03
        beq     @9b6f       ; branch if armor
        bra     @9b72       ; branch if weapon or shield
@9b6f:  jmp     @9bee

; weapon or shield
@9b72:  ldx     z0
        txy
@9b75:  clr_a
        lda     $1869,y     ; item number
        cmp     #$ff
        beq     @9ba3       ; branch if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$01
        beq     @9b91       ; branch if weapon
        cmp     #$03
        bne     @9ba3       ; skip if not shield
@9b91:  longa
        lda     f:ItemProp+1,x   ; equippable characters
        bit     ze7
        beq     @9ba3       ; branch if not equippable
        shorta
        tya
        sta     hWMDATA       ; add to list of possible items
        inc     ze0         ; increment number of possible items
@9ba3:  shorta        ; next item
        iny
        cpy     #$00ff
        bne     @9b75
        lda     ze0         ; set length of list
        sta     $7e9d89
        rts

; helmet
@9bb2:  ldx     z0
        txy
@9bb5:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @9bdf
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$04
        bne     @9bdf
        longa
        lda     f:ItemProp+1,x
        bit     ze7
        beq     @9bdf
        shorta
        tya
        sta     hWMDATA
        inc     ze0
@9bdf:  shorta
        iny
        cpy     #$00ff
        bne     @9bb5
        lda     ze0
        sta     $7e9d89
        rts

; armor
@9bee:  ldx     z0
        txy
@9bf1:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @9c1b
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$02
        bne     @9c1b
        longa
        lda     f:ItemProp+1,x
        bit     ze7
        beq     @9c1b
        shorta
        tya
        sta     hWMDATA
        inc     ze0
@9c1b:  shorta
        iny
        cpy     #$00ff
        bne     @9bf1
        lda     ze0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ clear list of optimum items ]

ClearValidItemList:
@9c2a:  ldx     z0
        lda     #$ff
@9c2e:  sta     $7e9d8a,x
        inx
        cpx     #9
        bne     @9c2e
        ldx     #$9d8a
        stx     hWMADDL
        stz     ze0         ; $e0 = number of possible items
        rts

; ------------------------------------------------------------------------------

; [ get character equippability mask ]

; +$e7 = mask

GetCharEquipMask:
@9c41:  jsr     GetSelCharPropPtr
        clr_a
        lda     0,y                 ; actor number

chrequinf_get1:
_c39c48:
@9c48:  asl
        tax
        longa
        lda     f:CharEquipMaskTbl,x
        sta     ze7
        shorta
        lda     $11d8
        and     #$20
        beq     @9c66
        longa
        lda     ze7
        ora     #$8000
        sta     ze7
        shorta
@9c66:  rts

; ------------------------------------------------------------------------------

; character equippability masks

; note: this is exactly the same as ForcedCharMaskTbl
CharEquipMaskTbl:
@9c67:  .word   $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        .word   $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

; ------------------------------------------------------------------------------

; [ clear modified stats text ]

_c39c87:
@9c87:  clr_ax
        ldy     #$0009      ; clear 9 lines
        longa
@9c8e:  sta     $7e7cbf,x   ; clear 100's digit
        inx2
        sta     $7e7cbf,x   ; clear 10's digit
        inx2
        sta     $7e7cbf,x   ; clear 1's digit
        inx2
        txa
        clc
        adc     #$007a      ; next line
        tax
        dey
        bne     @9c8e
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw item list text (equip/relic) ]

DrawEquipItemList:
@9cac:  lda     $7e9d89
        beq     @9cdd
        jsr     GetListTextPos
        clr_a
        lda     $7e9d89
        cmp     #$09
        bcc     @9cc0
        lda     #$09
@9cc0:  tay
@9cc1:  phy
        jsr     DrawEquipItemListRow
        inc     ze5
        lda     ze6
        inc2
        and     #$1f
        sta     ze6
        ply
        dey
        bne     @9cc1
        longa
        clr_a
        sta     $7e9bd0
        shorta
        rts
@9cdd:  lda     zNextMenuState
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ draw one row of equip item list ]

make_jump_label UpdateListText, LIST_TYPE::EQUIP
DrawEquipItemListRow:
@9ce2:  jsr     GetEquipSlotPtr
        clr_a
        lda     ze5
        jsr     CheckCanEquipItem
        bcs     @9cf1
        lda     #BG1_TEXT_COLOR::GRAY
        bra     @9cf3
@9cf1:  lda     #BG1_TEXT_COLOR::DEFAULT
@9cf3:  sta     zTextColor
.if LANG_EN
        lda     ze6
        inc
.else
        clr_a
        lda     ze5
        tax
        lda     $7e9d8a,x
        tay
        lda     $1969,y
        jsr     HexToDec3
        lda     ze6
        inc
        ldx     #12
        jsr     GetBG1TilemapPtr
        jsr     DrawNum2
        lda     ze6
.endif
        ldx     #2
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     ze5
        tay
        jsr     LoadEquipListItemName
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ load item name for equip item list ]

LoadEquipListItemName:
@9d11:  ldx     #$9e8b
        stx     hWMADDL
@9d17:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @9d17
        tyx
        clr_a
        lda     $7e9d8a,x
        tay
        lda     $1869,y
        cmp     #$ff
        beq     @9d4f
        sta     hM7A
        stz     hM7A
        lda     #ITEM_NAME_SIZE
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #ITEM_NAME_SIZE
@9d40:  lda     f:ItemName,x
        sta     hWMDATA
        inx
        dey
        bne     @9d40
.if LANG_EN
        stz     hWMDATA
        rts
@9d4f:  ldy     #ITEM_NAME_SIZE
.else
        lda     #COLON_CHAR
        sta     hWMDATA
        stz     hWMDATA
        rts
@9d4f:  ldy     #ITEM_NAME_SIZE+3
.endif
        lda     #$ff
@9d54:  sta     hWMDATA
        dey
        bne     @9d54
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ add item to inventory ]

; A: item id

IncItemQty:
@9d5e:  phy
        sta     ze0
        ldy     z0
@9d63:  cmp     $1869,y
        beq     @9d8a
        cmp     #$ff
        beq     @9d95
        iny
        cpy     #$0100
        bne     @9d63
        ldy     z0
@9d74:  lda     $1869,y
        cmp     #$ff
        beq     @9d7e
        iny
        bra     @9d74
@9d7e:  lda     #1
        sta     $1969,y
        lda     ze0
        sta     $1869,y
        bra     @9d95
@9d8a:  lda     $1969,y
        cmp     #99
        beq     @9d95
        inc
        sta     $1969,y
@9d95:  ply
        rts

; ------------------------------------------------------------------------------

; [ remove item from inventory ]

; A: item id

DecItemQty:
@9d97:  phy
        sta     ze0
        ldy     z0
@9d9c:  cmp     $1869,y
        beq     @9da9
        iny
        cpy     #$0100
        bne     @9d9c
        ply
        rts
@9da9:  lda     $1969,y
        cmp     #1
        beq     @9db9
        lda     $1969,y
        dec
        sta     $1969,y
        bra     @9dc2
@9db9:  clr_a
        sta     $1969,y
        lda     #$ff
        sta     $1869,y
@9dc2:  ply
        rts

; ------------------------------------------------------------------------------

; [ create cursor task for equip menu slot cursor ]

CreateEquipSlotCursorTask:
@9dc4:  lda     #2
        ldy     #near EquipSlotCursorTask
        jsr     CreateTask
        longa
        lda     z55
        sta     wTaskPosX,x
        lda     z57
        sta     wTaskPosY,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask:
@9ddd:  tax
        jmp     (near EquipSlotCursorTaskTbl,x)

EquipSlotCursorTaskTbl:
@9de1:  .addr   EquipSlotCursorTask_00
        .addr   EquipSlotCursorTask_01

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask_00:
@9de5:  ldx     zTaskOffset
        lda     #$01
        tsb     z46
        longa
        lda     #near CursorAnimData
        sta     near wTaskAnimPtr,x
        shorta
        lda     #^CursorAnimData
        sta     near wTaskAnimBank,x
        jsr     InitAnimTask
        inc     near wTaskState,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask_01:
@9e00:  lda     z46
        bit     #$01
        beq     @9e0d
        ldx     zTaskOffset
        jsr     UpdateAnimTask
        sec
        rts
@9e0d:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39e0f:
@9e0f:  jsr     _c39e23
        bra     _c39e37

; ------------------------------------------------------------------------------

; [  ]

_c39e14:
@9e14:  jsr     _c39e37
        lda     wGameTimeFrames
        and     #1
        beq     @9e20
        bra     _c39e23
@9e20:  jmp     TfrBigTextGfx

; ------------------------------------------------------------------------------

; [  ]

_c39e23:
@9e23:  ldy     #$4000
        sty     zDMA2Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA2Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA2Src+2
        ldy     #$0880
        sty     zDMA2Size
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39e37:
@9e37:  ldy     #$0000
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenA
        sty     zDMA1Src
        lda     #$7e
        sta     zDMA1Src+2
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ menu state $58: relic (init) ]

MenuState_58:
@9e4b:  jsr     _c39e50
        bra     _c39e6f

; ------------------------------------------------------------------------------

; [  ]

_c39e50:
@9e50:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        stz     z4a
        stz     z49
        lda     #$10
        tsb     z45
        stz     z99
        jsr     InitBigText
        jsr     InitEquipScrollHDMA
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        jmp     CreateCursorTask

; ------------------------------------------------------------------------------

; [  ]

_c39e6f:
@9e6f:  jsr     DrawRelicMenu
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        lda     #$59
        sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $79: switch character (relic equip) ]

MenuState_79:
@9e7d:  jsr     _c39e99
        jsr     DrawEquipTitleEquip
        jsr     _c39ea8
        lda     #$5a
        jmp     _c39eb3

; ------------------------------------------------------------------------------

; [ menu state $7a: switch character (relic remove) ]

MenuState_7a:
@9e8b:  jsr     _c39e99
        jsr     DrawEquipTitleRemove
        jsr     _c39ea8
        lda     #$5c
        jmp     _c39eb3

; ------------------------------------------------------------------------------

; [  ]

_c39e99:
@9e99:  jsr     _c39e50
        jsr     DrawRelicMenu
        jsr     _c39e37
        jsr     _c39e23
        jmp     _c39614

; ------------------------------------------------------------------------------

; [  ]

_c39ea8:
@9ea8:  jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39eb3:
@9eb3:  sta     zNextMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $59: relic options (equip/remove) ]

MenuState_59:
@9eb8:  jsr     _c39e23
        jsr     _c3960c
        jsr     DrawRelicOptions
        jsr     UpdateRelicOptionCursor
        lda     z08
        bit     #JOY_A
        beq     @9ed0
        jsr     PlaySelectSfx
        jmp     SelectRelicOption
@9ed0:  lda     z08+1
        bit     #>JOY_B
        beq     @9edc
        jsr     PlayCancelSfx
        jsr     CheckReequip
@9edc:  jsr     _c39ee6
        lda     #$58
        sta     ze0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [  ]

_c39ee6:
@9ee6:  lda     zMenuState
        sta     zd1
        rts

; ------------------------------------------------------------------------------

; [ check reequip ]

CheckReequip:
@9eeb:  jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        lda     0,y
        cmp     #CHAR_PROP::UMARO
        beq     @9eff
        jsr     CheckReequipRelics
        lda     z99
        bne     @9f06
@9eff:  lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zNextMenuState
        stz     zMenuState
        rts
@9f06:  lda     #$06
        trb     z46
        jsr     _c39e37
        jsr     _c39e23
        jsr     DrawReequipMsg
        lda     #4*60                   ; wait 4 seconds
        sta     z22
        lda     #$6c
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ draw reequip message ]

DrawReequipMsg:
@9f1c:  jsr     ClearEquipOptionText
        ldy     #near EquipChangedMsgText
        jsr     DrawPosKana
        lda     $1d4e
        and     #$10
        beq     @9f44
        lda     #$6e
        sta     zNextMenuState
        lda     zd1
        cmp     #$59
        beq     @9f3d
        ldy     #near RelicEmptyMsgText
        jsr     DrawPosKana
        rts
@9f3d:  ldy     #near EquipEmptyMsgText
        jsr     DrawPosKana
        rts
@9f44:  lda     #$6d
        sta     zNextMenuState
        lda     zd1
        cmp     #$59
        beq     @9f55
        ldy     #near RelicOptimumMsgText
        jsr     DrawPosKana
        rts
@9f55:  ldy     #near EquipOptimumMsgText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [ check for relics requiring reequip ]

CheckReequipRelics:
@9f5c:  jsr     GetSelCharPropPtr
        lda     $0023,y
        cmp     zb0
        bne     @9f6f
        lda     $0024,y
        cmp     zb1
        bne     @9f6f
        bra     @9fa9
@9f6f:  lda     zb0
        cmp     #ITEM::GENJI_GLOVE
        beq     @9fac
        cmp     #ITEM::GAUNTLET
        beq     @9fac
        cmp     #ITEM::MERIT_AWARD
        beq     @9fac
        lda     zb1
        cmp     #ITEM::GENJI_GLOVE
        beq     @9fac
        cmp     #ITEM::GAUNTLET
        beq     @9fac
        cmp     #ITEM::MERIT_AWARD
        beq     @9fac
        lda     $0023,y
        cmp     #ITEM::GENJI_GLOVE
        beq     @9fac
        cmp     #ITEM::GAUNTLET
        beq     @9fac
        cmp     #ITEM::MERIT_AWARD
        beq     @9fac
        lda     $0024,y
        cmp     #ITEM::GENJI_GLOVE
        beq     @9fac
        cmp     #ITEM::GAUNTLET
        beq     @9fac
        cmp     #ITEM::MERIT_AWARD
        beq     @9fac
@9fa9:  stz     z99
        rts
@9fac:  lda     #1
        sta     z99
        rts

; ------------------------------------------------------------------------------

; [ menu state $6c: pause for reequip message ]

MenuState_6c:
@9fb1:  lda     z22
        bne     @9fb8
        stz     zMenuState
        rts
@9fb8:  dec     z22
        lda     z08                     ; B button or either shoulder button
        bit     #JOY_R
        bne     @9fcc
        lda     z08
        bit     #JOY_L
        bne     @9fcc
        lda     z08+1
        bit     #>JOY_B
        beq     @9fce
@9fcc:  stz     zMenuState
@9fce:  rts

; ------------------------------------------------------------------------------

; [ select relic option (equip, remove) ]

SelectRelicOption:
@9fcf:  clr_a
        lda     z4b
        asl
        tax
        jmp     (near SelectRelicOptionTbl,x)

SelectRelicOptionTbl:
@9fd7:  .addr   SelectRelicOption_00
        .addr   SelectRelicOption_01

; ------------------------------------------------------------------------------

; [ 0: equip ]

SelectRelicOption_00:
@9fdb:  jsr     _c39614
        jsr     DrawEquipTitleEquip
        jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$5a
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ 1: remove ]

SelectRelicOption_01:
@9fec:  jsr     _c39614
        jsr     DrawEquipTitleRemove
        jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$5c
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ menu state $5a: relic slot select ]

MenuState_5a:
@9ffd:  jsr     _c39e14
        jsr     UpdateRelicSlotCursor
        lda     z08
        bit     #JOY_A
        beq     @a033
        jsr     PlaySelectSfx
        lda     z4e
        sta     z5f
        lda     #$5b
        sta     zMenuState
        jsr     _c3a051
        jsr     SortValidEquip
        jsr     InitEquipListCursor
        lda     #$5a
        sta     zNextMenuState
        jsr     ClearBG1ScreenA
        jsr     WaitVblank
        jsr     DrawEquipItemList
        jsr     _c39233
        jsr     _c39e23
        jmp     WaitVblank
@a033:  lda     z08+1
        bit     #>JOY_B
        beq     @a047
        jsr     PlayCancelSfx
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        lda     #$59
        sta     zMenuState
        rts
@a047:  jsr     _c39ee6
        lda     #$79
        sta     ze0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [  ]

_c3a051:
@a051:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     z0
        txy
@a05e:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @a088
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$05
        bne     @a088
        longa
        lda     f:ItemProp+1,x
        bit     ze7
        beq     @a088
        shorta
        tya
        sta     hWMDATA
        inc     ze0
@a088:  shorta
        iny
.if LANG_EN
        cpy     #$0100
.else
        cpy     #$00ff
.endif
        bne     @a05e
        lda     ze0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ menu state $5b: relic item select ]

MenuState_5b:
@a097:  lda     #$10
        trb     z45
        jsr     _c39e14
        jsr     _c39ad3
        jsr     _c39233
        jsr     _c3a1d8
        lda     z08
        bit     #JOY_A
        beq     @a0dc
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longa_clc
        tya
        shorta
        adc     z5f
        tay
        lda     $0023,y
        cmp     #$ff
        beq     @a0c5
        jsr     IncItemQty
@a0c5:  clr_a
        lda     z4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        sta     $0023,y
        jsr     DecItemQty
        jsr     _c39131
        bra     @a0e5
@a0dc:  lda     z08+1
        bit     #>JOY_B
        beq     @a109
        jsr     PlayCancelSfx
@a0e5:  lda     #$10
        tsb     z45
        jsr     _c39c87
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$c1
        trb     z46
        jsr     LoadRelicSlotCursor
        lda     z5f
        sta     z4e
        jsr     InitRelicSlotCursor
        lda     #$5a
        sta     zMenuState
@a109:  rts

; ------------------------------------------------------------------------------

; [ menu state $5c: remove relic ]

MenuState_5c:
@a10a:  jsr     _c39e23
        jsr     UpdateRelicSlotCursor
        lda     z08
        bit     #JOY_A
        beq     @a132
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longa_clc
        tya
        shorta
        adc     z4b
        tay
        lda     $0023,y
        jsr     IncItemQty
        lda     #$ff
        sta     $0023,y
        jsr     _c39131
@a132:  lda     z08+1
        bit     #>JOY_B
        beq     @a146
        jsr     PlayCancelSfx
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        lda     #$59
        sta     zMenuState
        rts
@a146:  jsr     _c39ee6
        lda     #$7a
        sta     ze0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ sort items by attack/defense power ]

SortValidEquip:
@a150:  ldx     #$ac8d
        stx     hWMADDL
        lda     $7e9d89
        beq     @a186
        cmp     #$01
        beq     @a186
        sta     ze7
        stz     ze8
        clr_axy
@a167:  lda     $7e9d8a,x
        phx
        tay
        lda     $1869,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x   ; attack/defense power
        sta     hWMDATA
        plx
        inx
        cpx     ze7
        bne     @a167
        jsr     _c3a187
@a186:  rts

; ------------------------------------------------------------------------------

; [ put item list in order of decreasing attack/defense power ]

_c3a187:
@a187:  dec     ze7
        phb
        lda     #$7e
        pha
        plb
        clr_ay
@a190:  clr_ax
@a192:  lda     $ac8d,x     ; item number
        cmp     $ac8e,x
        bcs     @a1b7
        sta     ze0
        lda     $9d8a,x
        sta     ze1
        lda     $ac8e,x
        sta     $ac8d,x
        lda     $9d8b,x
        sta     $9d8a,x
        lda     ze0
        sta     $ac8e,x
        lda     ze1
        sta     $9d8b,x
@a1b7:  inx                 ;
        cpx     ze7
        bne     @a192
        iny                 ;
        cpy     ze7
        bne     @a190
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

@a1c3:  jsr     GetItemDescPtr
        jsr     GetSelCharPropPtr
        lda     z4b
        bne     @a1d2
        lda     $0023,y
        bra     @a1d5
@a1d2:  lda     $0024,y
@a1d5:  jmp     LoadItemDesc

; ------------------------------------------------------------------------------

; [  ]

_c3a1d8:
@a1d8:  jsr     GetItemDescPtr
        clr_a
        lda     z4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        jmp     LoadItemDesc

; ------------------------------------------------------------------------------

.if LANG_EN
        .define EquipRHandStr           {$91,$c4,$a1,$9a,$a7,$9d,$00}
        .define EquipLHandStr           {$8b,$c4,$a1,$9a,$a7,$9d,$00}
        .define EquipHeadStr            {$87,$9e,$9a,$9d,$00}
        .define EquipBodyStr            {$81,$a8,$9d,$b2,$00}
        .define EquipRelicStr           {$91,$9e,$a5,$a2,$9c,$00}
        .define EquipBlankOptionsStr    {$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00}
        .define EquipTitleEquipStr      {$84,$90,$94,$88,$8f,$00}
        .define EquipTitleRemoveStr     {$91,$84,$8c,$8e,$95,$84,$00}
        .define EquipOptionEquipStr     {$84,$90,$94,$88,$8f,$00}
        .define EquipOptionOptimumStr   {$8e,$8f,$93,$88,$8c,$94,$8c,$00}
        .define EquipOptionRemoveStr    {$91,$8c,$8e,$95,$84,$00}
        .define EquipOptionEmptyStr     {$84,$8c,$8f,$93,$98,$00}
        .define RelicOptionEquipStr     {$84,$90,$94,$88,$8f,$00}
        .define RelicOptionRemoveStr    {$91,$84,$8c,$8e,$95,$84,$00}

        .define EquipStrengthStr        {$95,$a2,$a0,$a8,$ab,$00}
        .define EquipStaminaStr         {$92,$ad,$9a,$a6,$a2,$a7,$9a,$00}
        .define EquipMagPwrStr          {$8c,$9a,$a0,$c5,$8f,$b0,$ab,$00}
        .define EquipEvadeStr           {$84,$af,$9a,$9d,$9e,$ff,$cd,$00}
        .define EquipMagEvadeStr        {$8c,$81,$a5,$a8,$9c,$a4,$cd,$00}
        .define EquipArrowStr           {$d5,$00}
        .define EquipSpeedStr           {$92,$a9,$9e,$9e,$9d,$00}
        .define EquipAttackPwrStr       {$81,$9a,$ad,$c5,$8f,$b0,$ab,$00}
        .define EquipDefenseStr         {$83,$9e,$9f,$9e,$a7,$ac,$9e,$00}
        .define EquipMagDefStr          {$8c,$9a,$a0,$c5,$83,$9e,$9f,$00}

        .define EquipEmptyMsgStr        {$84,$a6,$a9,$ad,$b2,$00}
        .define EquipOptimumMsgStr      {$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00}
        .define RelicEmptyMsgStr        {$84,$a6,$a9,$ad,$b2,$00}
        .define RelicOptimumMsgStr      {$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00}
        .define EquipChangedMsgStr      {$84,$aa,$ae,$a2,$a9,$a6,$9e,$a7,$ad,$ff,$9c,$a1,$9a,$a7,$a0,$9e,$9d,$c5,$00}

.else

        .define EquipRHandStr           {$9f,$2d,$85,$00}
        .define EquipLHandStr           {$63,$3f,$a9,$85,$00}
        .define EquipHeadStr            {$8b,$7f,$9d,$00}
        .define EquipBodyStr            {$6b,$a7,$3f,$00}
        .define EquipRelicStr           {$8a,$6e,$7a,$74,$a8,$00}
        .define EquipBlankOptionsStr    {$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00}
        .define EquipTitleEquipStr      {$7d,$89,$23,$00}
        .define EquipTitleRemoveStr     {$61,$39,$79,$00}
        .define EquipOptionEquipStr     {$7d,$89,$23,$00}
        .define EquipOptionOptimumStr   {$75,$8d,$6d,$c3,$89,$00}
        .define EquipOptionRemoveStr    {$61,$39,$79,$00}
        .define EquipOptionEmptyStr     {$79,$27,$85,$61,$39,$79,$ff,$00}
        .define RelicOptionEquipStr     {$7d,$89,$23,$00}
        .define RelicOptionRemoveStr    {$61,$39,$79,$00}

        .define EquipStrengthStr        {$81,$6b,$a7,$00}
        .define EquipStaminaStr         {$7f,$8d,$a9,$c3,$6f,$00}
        .define EquipMagPwrStr          {$9d,$a9,$c3,$6f,$00}
        .define EquipEvadeStr           {$6b,$8d,$63,$a9,$83,$00}
        .define EquipMagEvadeStr        {$9d,$69,$89,$6b,$8d,$63,$a9,$83,$00}
        .define EquipArrowStr           {$d5,$00}
        .define EquipSpeedStr           {$79,$21,$b1,$75,$00}
        .define EquipAttackPwrStr       {$73,$89,$31,$6d,$a9,$c3,$6f,$00}
        .define EquipDefenseStr         {$29,$89,$2d,$c3,$00}
        .define EquipMagDefStr          {$9d,$69,$89,$29,$89,$2d,$c3,$00}

        .define EquipEmptyMsgStr        {$d0,$79,$27,$85,$61,$39,$79,$d1,$00}
        .define EquipOptimumMsgStr      {$d0,$75,$8d,$6d,$c3,$89,$7d,$89,$23,$d1,$00}
        .define RelicEmptyMsgStr        {$d0,$79,$27,$85,$61,$39,$79,$d1,$00}
        .define RelicOptimumMsgStr      {$d0,$75,$8d,$6d,$c3,$89,$7d,$89,$23,$d1,$00}
        .define EquipChangedMsgStr      {$7d,$89,$23,$95,$6b,$6b,$b7,$ab,$8a,$6e,$7a,$74,$a8,$c5,$2b,$ff,$67,$b9,$73,$89,$75,$ad,$9d,$77,$7f,$00}

.endif

; pointers to party equip screen slot names
begin_block _c3a9f8
        .addr   _c3a21a
        .addr   _c3a21f
        .addr   _c3a225
        .addr   _c3a22b
        .addr   _c3a231
        .addr   _c3a237
end_block _c3a9f8

begin_block _c3aa04
        .addr   _c3a23d
        .addr   _c3a242
        .addr   _c3a248
        .addr   _c3a24e
        .addr   _c3a254
        .addr   _c3a25a
end_block _c3aa04

begin_block _c3aa10
        .addr   _c3a260
        .addr   _c3a265
        .addr   _c3a26b
        .addr   _c3a271
        .addr   _c3a277
        .addr   _c3a27d
end_block _c3aa10

begin_block _c3aa1c
        .addr   _c3a283
        .addr   _c3a288
        .addr   _c3a28e
        .addr   _c3a294
        .addr   _c3a29a
        .addr   _c3a2a0
end_block _c3aa1c

; party equip screen slot names (used in Japanese version only)
_c3a21a:                        pos_text BG1A, {3, 4}, {$9f,$2d,$00}
_c3a21f:                        pos_text BG1A, {17, 4}, {$63,$3f,$a9,$00}
_c3a225:                        pos_text BG1A, {3, 6}, {$8b,$7f,$9d,$00}
_c3a22b:                        pos_text BG1A, {17, 6}, {$6b,$a7,$3f,$00}
_c3a231:                        pos_text BG1A, {3, 8}, {$8a,$6e,$54,$00}
_c3a237:                        pos_text BG1A, {17, 8}, {$8a,$6e,$55,$00}

_c3a23d:                        pos_text BG1A, {3, 12}, {$9f,$2d,$00}
_c3a242:                        pos_text BG1A, {17, 12}, {$63,$3f,$a9,$00}
_c3a248:                        pos_text BG1A, {3, 14}, {$8b,$7f,$9d,$00}
_c3a24e:                        pos_text BG1A, {17, 14}, {$6b,$a7,$3f,$00}
_c3a254:                        pos_text BG1A, {3, 16}, {$8a,$6e,$54,$00}
_c3a25a:                        pos_text BG1A, {17, 16}, {$8a,$6e,$55,$00}

_c3a260:                        pos_text BG1A, {3, 20}, {$9f,$2d,$00}
_c3a265:                        pos_text BG1A, {17, 20}, {$63,$3f,$a9,$00}
_c3a26b:                        pos_text BG1A, {3, 22}, {$8b,$7f,$9d,$00}
_c3a271:                        pos_text BG1A, {17, 22}, {$6b,$a7,$3f,$00}
_c3a277:                        pos_text BG1A, {3, 24}, {$8a,$6e,$54,$00}
_c3a27d:                        pos_text BG1A, {17, 24}, {$8a,$6e,$55,$00}

_c3a283:                        pos_text BG1A, {3, 28}, {$9f,$2d,$00}
_c3a288:                        pos_text BG1A, {17, 28}, {$63,$3f,$a9,$00}
_c3a28e:                        pos_text BG1A, {3, 30}, {$8b,$7f,$9d,$00}
_c3a294:                        pos_text BG1A, {17, 30}, {$6b,$a7,$3f,$00}
_c3a29a:                        pos_text BG1A, {3, 32}, {$8a,$6e,$54,$00}
_c3a2a0:                        pos_text BG1A, {17, 32}, {$8a,$6e,$55,$00}

; ------------------------------------------------------------------------------

begin_block EquipOptionTextList
        .addr   EquipOptionEquipText
        .addr   EquipOptionOptimumText
        .addr   EquipOptionRemoveText
        .addr   EquipOptionEmptyText
end_block EquipOptionTextList

begin_block EquipSlotTextList
        .addr   EquipHeadText
        .addr   EquipBodyText
end_block EquipSlotTextList

begin_block RelicOptionTextList
        .addr   RelicOptionEquipText
        .addr   RelicOptionRemoveText
end_block RelicOptionTextList

begin_block RelicSlotTextList
        .addr   EquipRelic1Text
        .addr   EquipRelic2Text
end_block RelicSlotTextList

.if LANG_EN
EquipRHandText:                 pos_text BG3A, {2, 7}, EquipRHandStr
EquipLHandText:                 pos_text BG3A, {2, 9}, EquipLHandStr
EquipHeadText:                  pos_text BG3A, {2, 11}, EquipHeadStr
EquipBodyText:                  pos_text BG3A, {2, 13}, EquipBodyStr
EquipRelic1Text:                pos_text BG3A, {2, 11}, EquipRelicStr
EquipRelic2Text:                pos_text BG3A, {2, 13}, EquipRelicStr
EquipBlankOptionsText:          pos_text BG3A, {2, 3}, EquipBlankOptionsStr
EquipTitleEquipText:            pos_text BG3A, {24, 3}, EquipTitleEquipStr
EquipTitleRemoveText:           pos_text BG3A, {24, 3}, EquipTitleRemoveStr
EquipOptionEquipText:           pos_text BG3A, {2, 3}, EquipOptionEquipStr
EquipOptionOptimumText:         pos_text BG3A, {9, 3}, EquipOptionOptimumStr
EquipOptionRemoveText:          pos_text BG3A, {18, 3}, EquipOptionRemoveStr
EquipOptionEmptyText:           pos_text BG3A, {25, 3}, EquipOptionEmptyStr
RelicOptionEquipText:           pos_text BG3A, {4, 3}, RelicOptionEquipStr
RelicOptionRemoveText:          pos_text BG3A, {11, 3}, RelicOptionRemoveStr
.else
EquipRHandText:                 pos_text BG3A, {2, 6}, EquipRHandStr
EquipLHandText:                 pos_text BG3A, {2, 8}, EquipLHandStr
EquipHeadText:                  pos_text BG3A, {2, 10}, EquipHeadStr
EquipBodyText:                  pos_text BG3A, {2, 12}, EquipBodyStr
EquipRelic1Text:                pos_text BG3A, {2, 10}, EquipRelicStr
EquipRelic2Text:                pos_text BG3A, {2, 12}, EquipRelicStr
EquipBlankOptionsText:          pos_text BG3A, {4, 2}, EquipBlankOptionsStr
EquipTitleEquipText:            pos_text BG3A, {26, 2}, EquipTitleEquipStr
EquipTitleRemoveText:           pos_text BG3A, {26, 2}, EquipTitleRemoveStr
EquipOptionEquipText:           pos_text BG3A, {4, 2}, EquipOptionEquipStr
EquipOptionOptimumText:         pos_text BG3A, {9, 2}, EquipOptionOptimumStr
EquipOptionRemoveText:          pos_text BG3A, {16, 2}, EquipOptionRemoveStr
EquipOptionEmptyText:           pos_text BG3A, {22, 2}, EquipOptionEmptyStr
RelicOptionEquipText:           pos_text BG3A, {4, 2}, RelicOptionEquipStr
RelicOptionRemoveText:          pos_text BG3A, {9, 2}, RelicOptionRemoveStr
.endif

; ------------------------------------------------------------------------------

begin_block EquipStatTextList1
        .addr   EquipStrengthText
        .addr   EquipStaminaText
        .addr   EquipMagPwrText
        .addr   EquipEvadeText
        .addr   EquipMagEvadeText
        .addr   EquipArrow1Text
        .addr   EquipArrow2Text
        .addr   EquipArrow3Text
        .addr   EquipArrow4Text
        .addr   EquipArrow5Text
        .addr   EquipArrow6Text
        .addr   EquipArrow7Text
        .addr   EquipArrow8Text
        .addr   EquipArrow9Text
end_block EquipStatTextList1

begin_block EquipStatTextList2
        .addr   EquipSpeedText
        .addr   EquipAttackPwrText
        .addr   EquipDefenseText
        .addr   EquipMagDefText
end_block EquipStatTextList2

.if LANG_EN
EquipStrengthText:              pos_text BG3A, {16, 17}, EquipStrengthStr
EquipStaminaText:               pos_text BG3A, {16, 21}, EquipStaminaStr
EquipMagPwrText:                pos_text BG3A, {16, 23}, EquipMagPwrStr
EquipEvadeText:                 pos_text BG3A, {16, 29}, EquipEvadeStr
EquipMagEvadeText:              pos_text BG3B, {16, 1}, EquipMagEvadeStr

EquipArrow1Text:                pos_text BG3A, {26, 17}, EquipArrowStr
EquipArrow2Text:                pos_text BG3A, {26, 19}, EquipArrowStr
EquipArrow3Text:                pos_text BG3A, {26, 21}, EquipArrowStr
EquipArrow4Text:                pos_text BG3A, {26, 23}, EquipArrowStr
EquipArrow5Text:                pos_text BG3A, {26, 27}, EquipArrowStr
EquipArrow6Text:                pos_text BG3A, {26, 29}, EquipArrowStr
EquipArrow7Text:                pos_text BG3A, {26, 25}, EquipArrowStr
EquipArrow8Text:                pos_text BG3A, {26, 31}, EquipArrowStr
EquipArrow9Text:                pos_text BG3A, {26, 33}, EquipArrowStr

EquipSpeedText:                 pos_text BG3A, {16, 19}, EquipSpeedStr
EquipAttackPwrText:             pos_text BG3A, {16, 25}, EquipAttackPwrStr
EquipDefenseText:               pos_text BG3A, {16, 27}, EquipDefenseStr
EquipMagDefText:                pos_text BG3A, {16, 31}, EquipMagDefStr

.else

EquipStrengthText:              pos_text BG3A, {15, 17}, EquipStrengthStr
EquipStaminaText:               pos_text BG3A, {15, 21}, EquipStaminaStr
EquipMagPwrText:                pos_text BG3A, {15, 23}, EquipMagPwrStr
EquipEvadeText:                 pos_text BG3A, {15, 29}, EquipEvadeStr
EquipMagEvadeText:              pos_text BG3B, {15, 1}, EquipMagEvadeStr

EquipArrow1Text:                pos_text BG3A, {26, 17}, EquipArrowStr
EquipArrow2Text:                pos_text BG3A, {26, 19}, EquipArrowStr
EquipArrow3Text:                pos_text BG3A, {26, 21}, EquipArrowStr
EquipArrow4Text:                pos_text BG3A, {26, 23}, EquipArrowStr
EquipArrow5Text:                pos_text BG3A, {26, 27}, EquipArrowStr
EquipArrow6Text:                pos_text BG3A, {26, 29}, EquipArrowStr
EquipArrow7Text:                pos_text BG3A, {26, 25}, EquipArrowStr
EquipArrow8Text:                pos_text BG3A, {26, 31}, EquipArrowStr
EquipArrow9Text:                pos_text BG3A, {26, 33}, EquipArrowStr

EquipSpeedText:                 pos_text BG3A, {15, 18}, EquipSpeedStr
EquipAttackPwrText:             pos_text BG3A, {15, 24}, EquipAttackPwrStr
EquipDefenseText:               pos_text BG3A, {15, 26}, EquipDefenseStr
EquipMagDefText:                pos_text BG3A, {15, 30}, EquipMagDefStr

_c3abd6:                        pos_text BG3A, {21, 6}, {$ff,$ff,$ff,$ff,$ff,$ff,$00}
_c3abdf:                        pos_text BG3A, {21, 8}, {$ff,$ff,$ff,$ff,$ff,$ff,$00}
_c3abe8:                        pos_text BG3A, {19, 8}, {$37,$c1,$89,$7d,$89,$23,$00}
_c3abf1:                        pos_text BG3A, {19, 6}, {$95,$87,$89,$a9,$c1,$89,$00}
_c3abfa:                        pos_text BG3A, {19, 8}, {$a9,$c3,$89,$85,$a5,$81,$00}
.endif

; ------------------------------------------------------------------------------

.if LANG_EN

EquipEmptyMsgText:              pos_text BG3A, {13, 3}, EquipEmptyMsgStr
EquipOptimumMsgText:            pos_text BG3A, {12, 3}, EquipOptimumMsgStr
RelicEmptyMsgText:              pos_text BG3A, {13, 5}, RelicEmptyMsgStr
RelicOptimumMsgText:            pos_text BG3A, {12, 5}, RelicOptimumMsgStr
EquipChangedMsgText:            pos_text BG3A, {6, 7}, EquipChangedMsgStr

.else

EquipEmptyMsgText:              pos_text BG3A, {12, 2}, EquipEmptyMsgStr
EquipOptimumMsgText:            pos_text BG3A, {12, 2}, EquipOptimumMsgStr
RelicEmptyMsgText:              pos_text BG3A, {12, 4}, RelicEmptyMsgStr
RelicOptimumMsgText:            pos_text BG3A, {12, 4}, RelicOptimumMsgStr
EquipChangedMsgText:            pos_text BG3A, {3, 6}, EquipChangedMsgStr

.endif

; ------------------------------------------------------------------------------
