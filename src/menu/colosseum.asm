
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: colosseum.asm                                                        |
; |                                                                            |
; | description: colosseum menus                                               |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.include "src/gfx/battle_bg.inc"
.include "src/gfx/monster_gfx.inc"

.import MonsterAlign, ColosseumProp

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ menu state $71: colosseum item select (init) ]

        array_label MENU_STATE, MENU_STATE::COLOSSEUM_ITEM_INIT
@acaa:  stz     r0201
        lda     r0205
        jsr     IncItemQty
        jsr     InitItemList
        jsr     InitItemListCursor
        jsr     DrawColosseumItemMenu
        clr_a
        jsl     InitGradientHDMA
        jsr     _c31b0e
        jsr     InitFontColor
        lda     #$01
        tsb     z45
        jsr     WaitVblank
        lda     #MENU_STATE::COLOSSEUM_ITEM_SELECT
        sta     zNextMenuState
        lda     #$02
        sta     z46
        jsr     CreateCursorTask
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $72: colosseum item select ]

        array_label MENU_STATE, MENU_STATE::COLOSSEUM_ITEM_SELECT
@acdc:  lda     #$10
        trb     z45
        stz     zListType
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @ad26
        jsr     UpdateItemListCursor
        jsr     InitItemDesc
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @ad14
        clr_a
        lda     z4b
        tax
        lda     $1869,x
        cmp     #$ff
        beq     @ad0e
        sta     r0205
        jsr     PlaySelectSfx
        lda     #MENU_STATE::COLOSSEUM_CHAR_INIT
        sta     zNextMenuState
        stz     zMenuState
        rts
@ad0e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@ad14:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @ad26
        jsr     PlayCancelSfx
        lda     #MENU_STATE::TERMINATE
        sta     r0205
        sta     zNextMenuState
        stz     zMenuState
@ad26:  rts

; ------------------------------------------------------------------------------

; [ draw menu for colosseum item select ]

DrawColosseumItemMenu:
@ad27:  lda     #$01
        sta     hBG1SC
        ldy     #near ColosseumItemMsgWindow
        jsr     DrawWindow
        ldy     #near ColosseumItemTitleWindow
        jsr     DrawWindow
        ldy     #near ColosseumItemDescWindow
        jsr     DrawWindow
        ldy     #near ColosseumItemListWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     ClearBG3ScreenD
        jsr     DrawColosseumItemTitle
        jsr     DrawColosseumItemMsg
        jsr     InitElementSymbolGfx
        jsr     TfrBG3ScreenAB
        jsr     TfrBG3ScreenCD
        jsr     ClearBG1ScreenB
        jsr     InitItemListText
        jsr     InitItemDesc
        jsr     TfrBG1ScreenAB
        jmp     TfrBG1ScreenBC

; ------------------------------------------------------------------------------

; [ draw title text for colosseum item select menu ]

DrawColosseumItemTitle:
@ad6e:  jsr     ClearBG3ScreenA
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near ColosseumItemTitleText
        jsr     DrawPosKana
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        rts

; ------------------------------------------------------------------------------

; [ draw message for colosseum item select menu ]

DrawColosseumItemMsg:
@ad80:  jsr     _c3a73d
        ldy     #near ColosseumItemMsgText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; unused menu state
        array_label MENU_STATE, MENU_STATE::MENU_STATE_78

; ------------------------------------------------------------------------------

.if LANG_EN
ColosseumItemTitleWindow:               window_pos BG2A, {1, 1}, {9, 2}
ColosseumItemMsgWindow:                 window_pos BG2A, {12, 1}, {17, 2}
.else
ColosseumItemTitleWindow:               window_pos BG2A, {1, 1}, {5, 2}
ColosseumItemMsgWindow:                 window_pos BG2A, {8, 1}, {21, 2}
.endif
ColosseumItemDescWindow:                window_pos BG2A, {1, 5}, {28, 3}
ColosseumItemListWindow:                window_pos BG2A, {1, 10}, {28, 15}

ColosseumItemTitleText:                 pos_text COLOSSEUM_ITEM_TITLE
ColosseumItemMsgText:                   pos_text COLOSSEUM_ITEM_MSG

; ------------------------------------------------------------------------------

; [ menu state $75: colosseum character select (init) ]

        array_label MENU_STATE, MENU_STATE::COLOSSEUM_CHAR_INIT
@adb7:  jsr     DisableInterrupts
        stz     zEnableHDMA
        jsr     LoadWindowGfx
        jsr     InitCharProp
        lda     #$02
        jsl     InitGradientHDMA
        jsr     InitWindow1PosHDMA
        jsr     LoadColosseumGfx
        lda     #$02
        sta     z46
        jsr     LoadColosseumCharCursor
        jsr     InitColosseumCharCursor
        jsr     CreateCursorTask
        jsr     CreateColosseumVSTask
        jsr     _c318d1
        jsr     DrawColosseumCharWindow
        lda     #$01
        tsb     z45
        jsr     InitFontColor
        lda     #1
        ldy     #near ColosseumChallengerSpriteTask
        jsr     CreateTask
        lda     #MENU_STATE::COLOSSEUM_CHAR_SELECT
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jsr     ClearBGScroll
        jsr     InitDMA1BG1ScreenA
        jsr     EnableInterrupts
        jmp     InitDMA1BG3ScreenA

; ------------------------------------------------------------------------------

; [ create task for "VS" sprite in colosseum ]

CreateColosseumVSTask:
@ae07:  lda     #1
        ldy     #near ColosseumVSTask
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ menu state $76: colosseum character select ]

        array_label MENU_STATE, MENU_STATE::COLOSSEUM_CHAR_SELECT
@ae0f:  jsr     InitDMA1BG3ScreenA
        jsr     UpdateColosseumCharCursor
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @ae33
        jsr     GetSelColosseumChallenger
        bmi     @ae2d
        sta     r0208
        jsr     PlaySelectSfx
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState
        rts
@ae2d:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@ae33:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum character select window ]

DrawColosseumCharWindow:
@ae34:  lda     #$01
        sta     hBG1SC
        ldy     #near ColosseumPrizeWindow
        jsr     DrawWindow
        ldy     #near ColosseumWagerWindow
        jsr     DrawWindow
        ldy     #near ColosseumCharWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG3ScreenA
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jsr     CreateColosseumPartySlot1Task
        jsr     CreateColosseumPartySlot2Task
        jsr     CreateColosseumPartySlot3Task
        jsr     CreateColosseumPartySlot4Task
        ldy     #near ColosseumCharMsgText
        jsr     DrawPosKana
        jsr     _c3b28d
        jsr     DrawWagerName
        jsr     DrawPrizeName
        jsr     TfrBG3ScreenAB
        ldy     #$5000
        sty     hVMADDL
        jsr     _c3b10a
        jsr     ClearBG1ScreenA
        jsr     CheckColosseumShadow
        lda     r0201
        bne     @ae8d
        jsr     DrawColosseumMonster
        jmp     TfrBG1ScreenAB
@ae8d:  jsr     DrawColosseumShadow
        jmp     TfrBG1ScreenAB

; ------------------------------------------------------------------------------

; [ check if shadow appears in the colosseum ]

CheckColosseumShadow:
@ae93:  lda     r0205
        cmp     #ITEM::STRIKER
        bne     @aea6                   ; branch if not betting striker
        lda     $1ebd
        and     #$80
        beq     @aea6
        lda     #$01
        sta     r0201
@aea6:  rts

; ------------------------------------------------------------------------------

; [ draw shadow in colosseum preview ]

DrawColosseumShadow:
@aea7:  jsr     DrawColosseumShadowName
        lda     #%10                    ; this is not necessary
        tsb     z47
        lda     #2
        ldy     #near PartySpriteTask
        jsr     CreateTask
        lda     #$01
        sta     wTaskProp::State,x
        lda     wTaskProp::Flags,x
        ora     #$02
        sta     wTaskProp::Flags,x
        txy
        lda     #$38
        sta     ze1
        lda     #$68
        sta     ze2
        clr_a
        lda     #CHAR::SHADOW
        jsr     LoadColosseumCharAnimPtr
        jsr     SetColosseumCharPos
        rts

; ------------------------------------------------------------------------------

; [ draw shadow's name ]

DrawColosseumShadowName:
@aed9:  clr_ax
@aedb:  stx     ze7
        longa
        lda     f:CharPropPtrs,x
        tax
        shorta
        lda     a:0,x
        cmp     #CHAR_PROP::SHADOW
        beq     @aef8
        ldx     ze7
        inx2
        cpx     #$0020
        bne     @aedb
@aef6:  bra     @aef6                   ; infinite loop
@aef8:  stx     zSelCharPropPtr
        ldy_pos BG3A, {4, 15}
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; [ make monster tilemap for colosseum preview ]

DrawColosseumMonster:
@af00:  ldx     z91
        stx     zed
        lda     z99
        cmp     #$08
        beq     @af16
        ldx     #$0010
        stx     zf1
        ldx     #$0010
        stx     ze0
        bra     @af1d
@af16:  ldx     #$0008
        stx     zf1
        stx     ze0
@af1d:  lda     #$7e
        sta     zef
        longa
        lda     #$2c01
        sta     ze7
@af28:  ldx     ze0
        ldy     zZero
@af2c:  lda     ze7
        sta     [zed],y
        iny2
        inc     ze7
        dex
        bne     @af2c
        lda     zed
        clc
        adc     #$0040
        sta     zed
        dec     zf1
        bne     @af28
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load monster graphics (colosseum) ]

LoadMonsterGfx:
@af46:  jsr     LoadColosseumProp
        lda     r0206       ; monster index
        sta     hWRMPYA
        lda     #$05        ; calculate pointer to monster graphics data
        sta     hWRMPYB
        ldy     #$5010
        sty     hVMADDL
        nop2
        ldx     hRDMPYL
        lda     f:MonsterGfxProp,x   ; monster graphics data
        sta     ze7
        lda     f:MonsterGfxProp+1,x
        sta     ze8
        lda     f:MonsterGfxProp+2,x
        sta     zf2
        lda     f:MonsterGfxProp+3,x
        sta     zf1
        lda     f:MonsterGfxProp+4,x
        sta     ze9
        lda     ze8
        bmi     @af85
        stz     zff
        bra     @af8d
@af85:  lda     #$01
        sta     zff
        lda     #$80
        trb     ze8
@af8d:  lda     #$e9
        sta     zf7
        longa
        lda     #$7000
        sta     zf5
        lda     ze7
        sta     zf9
        stz     zfb
        asl     zf9
        rol     zfb
        asl     zf9
        rol     zfb
        asl     zf9
        rol     zfb
        clc
        lda     zf9
        adc     zf5
        sta     zf5
        lda     zfb
        adc     zf7
        sta     zf7
        ldx     zZero
        shorta
        lda     zf2
        bmi     @afc8
        ldy     #near MonsterStencil
        sty     ze3
        lda     #$08
        bra     @afcf
@afc8:  ldy     #near MonsterStencil+2
        sty     ze3
        lda     #$20
@afcf:  sta     ze6
        sta     z99
        lda     #^MonsterStencil
        sta     ze5
        lda     zf2
        and     #$40
        rol3
        sta     zea
        lda     zf2
        bmi     @afed
        longa
        lda     ze9
        asl3
        bra     @aff6
@afed:  longa
        lda     ze9
        asl5
@aff6:  clc
        adc     [ze3]
        sta     ze0
        shorta
        lda     #$d2
        sta     ze2
@b001:  ldy     #$0008
        phx
        clr_a
        lda     ze6
        tax
        lda     [ze0]
        sta     $7e9d88,x
        plx
@b010:  clc
        phy
        rol
        pha
        bcc     @b01b
        jsr     _c3b11e
        bra     @b01e
@b01b:  jsr     _c3b10a
@b01e:  pla
        ply
        dey
        bne     @b010
        longa
        inc     ze0
        shorta
        dec     ze6
        bne     @b001
        jsr     _c3b033
        jmp     LoadMonsterPal

; ------------------------------------------------------------------------------

; [  ]

_c3b033:
@b033:  stz     ze0
        stz     ze4
        stz     ze5
        stz     ze3
        ldx     zZero
        lda     z99
        cmp     #$08
        bne     @b079
@b043:  lda     $7e9d89,x
        bne     @b050
        inc     ze0
        inx
        cmp     #$08
        bne     @b043
@b050:  ldx     zZero
@b052:  lda     $7e9d89,x
        ora     ze3
        sta     ze3
        inx
        cpx     #$0008
        bne     @b052
@b060:  ror     ze3
        bcs     @b068
        inc     ze4
        bra     @b060
@b068:  lsr     ze4
        asl     ze4
        longa_clc
        lda     ze4
        adc_pos BG1A, {4, 8}
        sta     ze7
        shorta
        bra     @b0b4
@b079:  lda     $7e9d89,x
        ora     $7e9d8a,x
        bne     @b08c
        inc     ze0
        inx2
        cpx     #$0020
        bne     @b079
@b08c:  ldx     zZero
@b08e:  lda     $7e9d89,x
        ora     ze3
        sta     ze3
        inx2
        cpx     #$0020
        bne     @b08e
@b09d:  ror     ze3
        bcs     @b0a5
        inc     ze4
        bra     @b09d
@b0a5:  lsr     ze4
        asl     ze4
        longa_clc
        lda     ze4
        adc     #near wBG1Tiles::ScreenA
        sta     ze7
        shorta
@b0b4:  jmp     AlignColosseumMonster

; ------------------------------------------------------------------------------

; [ set vertical alignment for monster in colosseum menu ]

.proc AlignColosseumMonster
@b0b7:  clr_a
        lda     r0206       ; colosseum monster number
        tax
        lda     f:MonsterAlign,x
        longa
        asl
        tax
        shorta
        jmp     (near AlignColosseumMonsterPtrs,x)

.endproc  ; AlignColosseumMonster

.enum ALIGN_COLOSSEUM_MONSTER
        COUNT = MONSTER_ALIGN::COUNT
.endenum

; jump table for monster vertical alignment
AlignColosseumMonsterPtrs:
        ptr_tbl ALIGN_COLOSSEUM_MONSTER

; ------------------------------------------------------------------------------

; [ 0: ceiling (move to top) ]

        array_label ALIGN_COLOSSEUM_MONSTER, MONSTER_ALIGN::CEILING
@b0d3:  stz     ze0
        longa
        lda     ze7
        sec
        sbc     #$00c0
        sta     z91
        shorta
        rts

; ------------------------------------------------------------------------------

; [ 2: floating (shift up 8) ]

        array_label ALIGN_COLOSSEUM_MONSTER, MONSTER_ALIGN::FLOATING
@b0e2:  dec     ze0
        bpl     @b0e8
        stz     ze0
@b0e8:  bra     _b0f8

; ------------------------------------------------------------------------------

; [ 3: buried (shift down 8) ]

        array_label ALIGN_COLOSSEUM_MONSTER, MONSTER_ALIGN::BURIED
@b0ea:  inc     ze0
        bra     _b0f8

; ------------------------------------------------------------------------------

; [ 4: flying (shift up 24) ]

        array_label ALIGN_COLOSSEUM_MONSTER, MONSTER_ALIGN::FLYING
@b0ee:  dec     ze0
        dec     ze0
        dec     ze0
        bpl     _b0f8
        stz     ze0
; fallthrough

; ------------------------------------------------------------------------------

; [ 1: ground (no effect) ]

        array_label ALIGN_COLOSSEUM_MONSTER, MONSTER_ALIGN::GROUND
_b0f8:  clr_a
        lda     ze0
        longa_clc
        asl6
        adc     ze7
        sta     z91
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b10a:
@b10a:  ldy     #$0010
        sty     ze3
        longa
        ldy     zZero
@b113:  stz     hVMDATAL
        iny
        cpy     ze3
        bne     @b113
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b11e:
@b11e:  lda     zff
        bne     @b129
        ldy     #$0010
        sty     ze3
        bra     @b145
@b129:  ldy     #$0008
        sty     ze3
        jsr     @b145
        txy
        ldx     #$0008
        clr_a
@b136:  lda     [zf5],y
        longa
        sta     hVMDATAL
        shorta
        iny
        dex
        bne     @b136
        tyx
        rts

@b145:  txy
        ldx     zZero
        longa
@b14a:  lda     [zf5],y
        sta     hVMDATAL
        iny2
        inx
        cpx     ze3
        bne     @b14a
        shorta
        tyx
        rts

; ------------------------------------------------------------------------------

; [ load monster palette ]

LoadMonsterPal:
@b15a:  longa
        lda     zf1
        and     #$03ff
        asl4
        tax
        shorta
        ldy     #near wPalBuf::BGPal3
        sty     hWMADDL
        ldy     #$0020
@b171:  lda     f:MonsterPal,x
        sta     hWMDATA
        inx
        dey
        bne     @b171
        rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char slot 1 ]

CreateColosseumPartySlot1Task:
@b17d:  ldy     zCharPropPtr::_0
        beq     @b196
        sty     zSelCharPropPtr
        ldy_pos BG3A, {3, 24}
        jsr     CreateColosseumPartySpriteTask
        lda     #$20
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::_0
        jsr     InitColosseumCharSprite
@b196:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char slot 2 ]

CreateColosseumPartySlot2Task:
@b197:  ldy     zCharPropPtr::_1
        beq     @b1b0
        sty     zSelCharPropPtr
        ldy_pos BG3A, {10, 24}
        jsr     CreateColosseumPartySpriteTask
        lda     #$58
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::_1
        jsr     InitColosseumCharSprite
@b1b0:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char slot 3 ]

CreateColosseumPartySlot3Task:
@b1b1:  ldy     zCharPropPtr::_2
        beq     @b1ca
        sty     zSelCharPropPtr
        ldy_pos BG3A, {17, 24}
        jsr     CreateColosseumPartySpriteTask
        lda     #$90
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::_2
        jsr     InitColosseumCharSprite
@b1ca:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char slot 4 ]

CreateColosseumPartySlot4Task:
@b1cb:  ldy     zCharPropPtr::_3
        beq     @b1e4
        sty     zSelCharPropPtr
        ldy_pos BG3A, {24, 24}
        jsr     CreateColosseumPartySpriteTask
        lda     #$c8
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::_3
        jsr     InitColosseumCharSprite
@b1e4:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char sprite and name ]

CreateColosseumPartySpriteTask:
@b1e5:  jsr     DrawCharName
        lda     #2
        ldy     #near PartySpriteTask
        jsr     CreateTask
        txy
        clr_a
        rts

; ------------------------------------------------------------------------------

; [ draw character sprite ]

InitColosseumCharSprite:
@b1f3:  asl
        tax
        longa
        lda     f:CharPropPtrs,x
        tax
        shorta
        lda     a:$0014,x
        and     #STATUS1::IMP
        beq     @b20a
        clr_a
        lda     #CHAR_GFX::IMP
        bra     @b20e
@b20a:  clr_a
        lda     a:$0001,x
@b20e:  jsr     LoadColosseumCharAnimPtr

SetColosseumCharPos:
@b211:  lda     #^PartyCharAnimTbl
        sta     near wTaskProp::AnimBank,y
        lda     ze1
        sta     near wTaskProp::PosX_H,y
        lda     ze2
        sta     near wTaskProp::PosY_H,y
        clr_a
        sta     near wTaskProp::PosX + 2,y
        sta     near wTaskProp::PosY + 2,y
        lda     #$00
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load colosseum item data ]

LoadColosseumProp:
@b22c:  clr_a
        lda     r0205                   ; item wagered
        longa
        asl2
        tax
        shorta
        lda     f:ColosseumProp,x
        sta     r0206
        lda     f:ColosseumProp+2,x     ; prize
        sta     r0207
        lda     f:ColosseumProp+3,x
        sta     r0209
        rts

; ------------------------------------------------------------------------------

; [ draw wagered item name ]

DrawWagerName:
@b24d:  lda     r0205                   ; wagered item
.if LANG_EN
        ldx_pos BG3A, {17, 3}
.else
        ldx_pos BG3A, {19, 2}
.endif
        bra     _b263

; [ draw prize item name ]

DrawPrizeName:
@b255:  lda     r0209                   ; prize item
        jne     _b286                   ; branch if prize name is not shown
        lda     r0207
.if LANG_EN
        ldx_pos BG3A, {2, 3}
.else
        ldx_pos BG3A, {4, 2}
.endif
_b263:  pha
        ldy     #$9e8b
        sty     hWMADDL
        longa
        txa
        sta     $7e9e89
        shorta
@b273:  lda     hHVBJOY
        and     #$40
        beq     @b273
        pla
        jsr     _c380ce
        clr_a
.if LANG_EN
        sta     $7e9e98
.else
        sta     $7e9e94
.endif
        jmp     DrawPosTextBuf
_b286:  ldy     #near ColosseumUnknownPrizeText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b28d:
@b28d:  longa
.if LANG_EN
        lda_pos BG3A, {3, 16}
.else
        lda_pos BG3A, {4, 15}
.endif
        sta     $7e9e89
        shorta
        jsr     GetMonsterNamePtr
        clr_a
        lda     r0206
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ colosseum challenger sprite task ]

ColosseumChallengerSpriteTask:
@b2a5:  phb
        lda     #$00
        pha
        plb
        clr_a
        lda     z4b
        asl
        tax
        ldy     zCharPropPtr,x
        beq     @b2df
        sty     zSelCharPropPtr
.if LANG_EN
        ldy_pos BG3A, {22, 16}
.else
        ldy_pos BG3A, {22, 15}
.endif
        jsr     DrawCharName
        lda     #%10                    ; terminate task after 1 frame
        tsb     z47
        lda     #2
        ldy     #near CharIconTask
        jsr     CreateTask
        lda     #$01
        sta     wTaskProp::State,x
        txy
        clr_a
        lda     #$b8                    ; challenger position
        sta     ze1
        lda     #$68
        sta     ze2
        jsr     GetSelColosseumChallenger
        jsr     InitColosseumCharSprite
        bra     @b2e2
@b2df:  jsr     HideColosseumChallengerName
@b2e2:  plb
        sec
        rts

; ------------------------------------------------------------------------------

; [ clear colosseum character name ]

HideColosseumChallengerName:
@b2e5:  ldy     #near ColosseumCharBlankNameText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [ get selected challenger ]

GetSelColosseumChallenger:
@b2ec:  clr_a
        lda     z4b
        tax
        lda     zCharID,x
        rts

; ------------------------------------------------------------------------------

; [ task for "VS" sprite in colosseum ]

.proc ColosseumVSTask

@b2f3:  tax
        jmp     (near ColosseumVSTaskTbl,x)

.endproc  ; ColosseumVSTask

.enum COLOSSEUM_VS_TASK
        INIT
        SUSTAIN

        COUNT
.endenum

ColosseumVSTaskTbl:
        ptr_tbl COLOSSEUM_VS_TASK

; ------------------------------------------------------------------------------

        array_label COLOSSEUM_VS_TASK, COLOSSEUM_VS_TASK::INIT
@b2fb:  ldx     zTaskOffset
        longa
        lda     #near ColosseumVSAnim
        sta     near wTaskProp::AnimPtr,x
        lda     #$0070
        sta     near wTaskProp::PosX_H,x
        lda     #$0060
        sta     near wTaskProp::PosY_H,x
        shorta
        inc     near wTaskProp::State,x
        lda     #^ColosseumVSAnim
        sta     near wTaskProp::AnimBank,x
        jsr     InitAnimTask
; fallthrough

        array_label COLOSSEUM_VS_TASK, COLOSSEUM_VS_TASK::SUSTAIN
@b31e:  jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ load colosseum character cursor ]

LoadColosseumCharCursor:
@b323:  ldy     #near ColosseumCharCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update colosseum character cursor ]

UpdateColosseumCharCursor:
@b329:  jsr     MoveCursor

InitColosseumCharCursor:
@b32c:  ldy     #near ColosseumCharCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

ColosseumCharCursorProp:
        cursor_prop {0, 0}, {4, 1}, NO_Y_WRAP

ColosseumCharCursorPos:
        .repeat 4, i
        cursor_pos {16 + i * 56, 176}
        .endrep

; colosseum menu windows
ColosseumPrizeWindow:                   window_pos BG2A, {1, 1}, {13, 2}
ColosseumWagerWindow:                   window_pos BG2A, {16, 1}, {13, 2}
ColosseumCharWindow:                    window_pos BG2A, {1, 18}, {28, 7}

; ------------------------------------------------------------------------------

; [ load colosseum battle bg graphics ]

.proc LoadColosseumBGGfx

GfxOffset1 := BattleBGGfxPtrs + BATTLE_BG_GFX::FIELD_3 * 3
GfxOffset2 := BattleBGGfxPtrs + BATTLE_BG_GFX::COLOSSEUM * 3
TilesOffset := BattleBGTilesPtrs + BATTLE_BG_TILES::COLOSSEUM * 2
PalOffset := BattleBGPal + BATTLE_BG_PAL::COLOSSEUM * $60

; graphics 1
        longa
        lda     f:GfxOffset1
        sta     zf3
        shorta
        lda     f:GfxOffset1 + 2
        sta     zf5
        jsr     DecompColosseumGfx
        ldy     #$6800
        sty     hVMADDL
        ldy     #$1000
        sty     ze7
        ldx     zZero
        jsr     TfrColosseumBGGfx

; graphics 2
        longa
        lda     f:GfxOffset2
        sta     zf3
        shorta
        lda     f:GfxOffset2 + 2
        sta     zf5
        jsr     DecompColosseumGfx
        ldy     #$7000
        sty     hVMADDL
        ldy     #$1000
        sty     ze7
        ldx     zZero
        jsr     TfrColosseumBGGfx

; tilemap
        longa
        lda     f:TilesOffset
        sta     zf3
        shorta
        lda     #^TilesOffset
        sta     zf5
        jsr     DecompColosseumGfx
        jsr     FixColosseumBGTiles

; palette
        longa
        lda     #near PalOffset
        sta     ze7
        shorta
        lda     #^PalOffset
        sta     ze9
        ldx     #near wPalBuf::BGPal4
        stx     hWMADDL
        ldy     zZero
loop:   lda     [ze7],y
        sta     hWMDATA
        iny
        cpy     #$0060
        bne     loop
        rts
.endproc  ; LoadColosseumBGGfx

; ------------------------------------------------------------------------------

; [ transfer battle bg graphics to vram ]

.proc TfrColosseumBGGfx
        longa
loop:   lda     $7eb68d,x
        sta     hVMDATAL
        inx2
        cpx     ze7
        bne     loop
        shorta
        rts
.endproc  ; TfrColosseumBGGfx

; ------------------------------------------------------------------------------

; [ fix battle bg tilemap tile offset ]

.proc FixColosseumBGTiles
        ldx     zZero
        longa
loop:   lda     $7eb68d,x
        sec
        sbc     #$0380
        sta     $7e5949,x               ; copy to bg2 tilemap
        inx2
        cpx     #$0580
        bne     loop
        shorta
        rts
.endproc  ; FixColosseumBGTiles

; ------------------------------------------------------------------------------

; [ decompress battle bg gfx/tilemap ]

.proc DecompColosseumGfx
        ldy     #$b68d
        sty     zf6
        lda     #$7e
        sta     zf8
        phb
        lda     #$7e
        pha
        plb
        jsl     Decompress_ext
        plb
        rts
.endproc  ; DecompColosseumGfx

; ------------------------------------------------------------------------------

ColosseumCharBlankNameText:             pos_text COLOSSEUM_CHAR_BLANK_NAME
ColosseumCharMsgText:                   pos_text COLOSSEUM_CHAR_MSG
ColosseumUnknownPrizeText:              pos_text COLOSSEUM_UNKNOWN_PRIZE

; ------------------------------------------------------------------------------
