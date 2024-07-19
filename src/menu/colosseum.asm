
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

.include "gfx/battle_bg.inc"
.include "gfx/monster_gfx.inc"

.import MonsterAlign

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ menu state $71: colosseum item select (init) ]

MenuState_71:
@acaa:  stz     w0201
        lda     w0205
        jsr     IncItemQty
        jsr     _c31ae2
        jsr     InitItemListCursor
        jsr     DrawColosseumItemMenu
        clr_a
        jsl     InitGradientHDMA
        jsr     _c31b0e
        jsr     InitFontColor
        lda     #$01
        tsb     z45
        jsr     WaitVblank
        lda     #$72
        sta     zNextMenuState
        lda     #$02
        sta     z46
        jsr     CreateCursorTask
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $72: colosseum item select ]

MenuState_72:
@acdc:  lda     #$10
        trb     z45
        stz     zListType
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @ad26
        jsr     UpdateItemListCursor
        jsr     InitItemDesc
        lda     z08
        bit     #JOY_A
        beq     @ad14
        clr_a
        lda     z4b
        tax
        lda     $1869,x
        cmp     #$ff
        beq     @ad0e
        sta     w0205
        jsr     PlaySelectSfx
        lda     #$75
        sta     zNextMenuState
        stz     zMenuState
        rts
@ad0e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@ad14:  lda     z08+1
        bit     #>JOY_B
        beq     @ad26
        jsr     PlayCancelSfx
        lda     #$ff
        sta     w0205
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
        jsr     _c3a9a9
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
MenuState_78:

; ------------------------------------------------------------------------------

.if LANG_EN
ColosseumItemTitleWindow:               make_window BG2A, {1, 1}, {9, 2}
ColosseumItemMsgWindow:                 make_window BG2A, {12, 1}, {17, 2}
.else
ColosseumItemTitleWindow:               make_window BG2A, {1, 1}, {5, 2}
ColosseumItemMsgWindow:                 make_window BG2A, {8, 1}, {21, 2}
.endif
ColosseumItemDescWindow:                make_window BG2A, {1, 5}, {28, 3}
ColosseumItemListWindow:                make_window BG2A, {1, 10}, {28, 15}

.if LANG_EN

        .define ColosseumItemTitleStr   {$82,$a8,$a5,$a8,$ac,$ac,$9e,$ae,$a6,$00}
        .define ColosseumItemMsgStr     {$92,$9e,$a5,$9e,$9c,$ad,$ff,$9a,$a7,$ff,$88,$ad,$9e,$a6,$00}

.else

        .define ColosseumItemTitleStr   {$72,$ae,$76,$8a,$a0,$00}
        .define ColosseumItemMsgStr     {$8a,$8c,$84,$a0,$bb,$54,$83,$ff,$8f,$a7,$b9,$45,$6f,$3f,$75,$8d,$00}

.endif

.if LANG_EN
ColosseumItemTitleText:         pos_text BG3A, {2, 3}, ColosseumItemTitleStr
ColosseumItemMsgText:           pos_text BG3A, {13, 3}, ColosseumItemMsgStr
.else
ColosseumItemTitleText:         pos_text BG3A, {2, 2}, ColosseumItemTitleStr
ColosseumItemMsgText:           pos_text BG3A, {9, 2}, ColosseumItemMsgStr
.endif

; ------------------------------------------------------------------------------

; [ menu state $75: colosseum character select (init) ]

MenuState_75:
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
        ldy     #near ColosseumCharTask
        jsr     CreateTask
        lda     #$76
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

MenuState_76:
@ae0f:  jsr     InitDMA1BG3ScreenA
        jsr     UpdateColosseumCharCursor
        lda     z08
        bit     #JOY_A
        beq     @ae33
        jsr     _c3b2ec
        bmi     @ae2d
        sta     w0208
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
        jsr     _c3b17d
        jsr     _c3b197
        jsr     _c3b1b1
        jsr     _c3b1cb
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
        lda     w0201
        bne     @ae8d
        jsr     _c3af00                 ; draw colosseum monster
        jmp     TfrBG1ScreenAB
@ae8d:  jsr     _c3aea7                 ; draw shadow
        jmp     TfrBG1ScreenAB

; ------------------------------------------------------------------------------

; [ check if shadow appears in the colosseum ]

CheckColosseumShadow:
@ae93:  lda     w0205
        cmp     #ITEM::STRIKER
        bne     @aea6                   ; branch if not betting striker
        lda     $1ebd
        and     #$80
        beq     @aea6
        lda     #$01
        sta     w0201
@aea6:  rts

; ------------------------------------------------------------------------------

; [ draw shadow in colosseum preview ]

_c3aea7:
@aea7:  jsr     _c3aed9
        lda     #$02
        tsb     z47
        lda     #2
        ldy     #near _c37a5f
        jsr     CreateTask
        lda     #$01
        sta     wTaskState,x
        lda     wTaskFlags,x
        ora     #$02
        sta     wTaskFlags,x
        txy
        lda     #$38
        sta     ze1
        lda     #$68
        sta     ze2
        clr_a
        lda     #CHAR::SHADOW
        jsr     _c378fa
        jsr     _c3b211
        rts

; ------------------------------------------------------------------------------

; [ draw shadow's name ]

_c3aed9:
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

_c3af00:
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
        ldy     z0
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
        lda     w0206       ; monster index
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
        ldx     z0
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
        ldx     z0
        lda     z99
        cmp     #$08
        bne     @b079
@b043:  lda     $7e9d89,x
        bne     @b050
        inc     ze0
        inx
        cmp     #$08
        bne     @b043
@b050:  ldx     z0
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
@b08c:  ldx     z0
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

AlignColosseumMonster:
@b0b7:  clr_a
        lda     w0206       ; colosseum monster number
        tax
        lda     f:MonsterAlign,x
        longa
        asl
        tax
        shorta
        jmp     (near AlignColosseumMonsterPtrs,x)

; jump table for monster vertical alignment
AlignColosseumMonsterPtrs:
@b0c9:  .addr   AlignColosseumMonster_00
        .addr   AlignColosseumMonster_01
        .addr   AlignColosseumMonster_02
        .addr   AlignColosseumMonster_03
        .addr   AlignColosseumMonster_04

; ------------------------------------------------------------------------------

; [ 0: ceiling (move to top) ]

AlignColosseumMonster_00:
@b0d3:  stz     ze0
        longa
        lda     ze7
        sec
        sbc     #$00c0
        sta     z91
        shorta
        rts

; ------------------------------------------------------------------------------

; [ 2: buried (shift up 8) ]

AlignColosseumMonster_02:
@b0e2:  dec     ze0
        bpl     @b0e8
        stz     ze0
@b0e8:  bra     _b0f8

; ------------------------------------------------------------------------------

; [ 3: floating (shift down 8) ]

AlignColosseumMonster_03:
@b0ea:  inc     ze0
        bra     _b0f8

; ------------------------------------------------------------------------------

; [ 4: flying (shift up 24) ]

AlignColosseumMonster_04:
@b0ee:  dec     ze0
        dec     ze0
        dec     ze0
        bpl     _b0f8
        stz     ze0
; fallthrough

; ------------------------------------------------------------------------------

; [ 1: ground (no effect) ]

AlignColosseumMonster_01:
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
        ldy     z0
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
        ldx     z0
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

_c3b17d:
@b17d:  ldy     zCharPropPtr::Slot1
        beq     @b196
        sty     zSelCharPropPtr
        ldy_pos BG3A, {3, 24}
        jsr     _c3b1e5
        lda     #$20
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::Slot1
        jsr     _c3b1f3
@b196:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char slot 2 ]

_c3b197:
@b197:  ldy     zCharPropPtr::Slot2
        beq     @b1b0
        sty     zSelCharPropPtr
        ldy_pos BG3A, {10, 24}
        jsr     _c3b1e5
        lda     #$58
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::Slot2
        jsr     _c3b1f3
@b1b0:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char slot 3 ]

_c3b1b1:
@b1b1:  ldy     zCharPropPtr::Slot3
        beq     @b1ca
        sty     zSelCharPropPtr
        ldy_pos BG3A, {17, 24}
        jsr     _c3b1e5
        lda     #$90
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::Slot3
        jsr     _c3b1f3
@b1ca:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char slot 4 ]

_c3b1cb:
@b1cb:  ldy     zCharPropPtr::Slot4
        beq     @b1e4
        sty     zSelCharPropPtr
        ldy_pos BG3A, {24, 24}
        jsr     _c3b1e5
        lda     #$c8
        sta     ze1
        lda     #$a8
        sta     ze2
        lda     zCharID::Slot4
        jsr     _c3b1f3
@b1e4:  rts

; ------------------------------------------------------------------------------

; [ draw colosseum party char name ]

_c3b1e5:
@b1e5:  jsr     DrawCharName
        lda     #2
        ldy     #near _c37a5f
        jsr     CreateTask
        txy
        clr_a
        rts

; ------------------------------------------------------------------------------

; [ draw character sprite ]

_c3b1f3:
@b1f3:  asl
        tax
        longa
        lda     f:CharPropPtrs,x
        tax
        shorta
        lda     a:$0014,x
        and     #$20
        beq     @b20a
        clr_a
        lda     #$0f
        bra     @b20e
@b20a:  clr_a
        lda     a:$0001,x
@b20e:  jsr     _c378fa

_c3b211:
@b211:  lda     #^PartyCharAnimTbl
        sta     near wTaskAnimBank,y
        lda     ze1
        sta     near wTaskPosX,y
        lda     ze2
        sta     near wTaskPosY,y
        clr_a
        sta     near {wTaskPosX + 1},y
        sta     near {wTaskPosY + 1},y
        lda     #$00
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load colosseum item data ]

LoadColosseumProp:
@b22c:  clr_a
        lda     w0205                   ; item wagered
        longa
        asl2
        tax
        shorta
        lda     f:ColosseumProp,x
        sta     w0206
        lda     f:ColosseumProp+2,x     ; prize
        sta     w0207
        lda     f:ColosseumProp+3,x
        sta     w0209
        rts

; ------------------------------------------------------------------------------

; [ draw wagered item name ]

DrawWagerName:
@b24d:  lda     w0205                   ; wagered item
.if LANG_EN
        ldx_pos BG3A, {17, 3}
.else
        ldx_pos BG3A, {19, 2}
.endif
        bra     _b263

; [ draw prize item name ]

DrawPrizeName:
@b255:  lda     w0209                   ; prize item
        jne     _b286                   ; branch if prize name is not shown
        lda     w0207
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
        lda     w0206
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ colosseum challenger sprite task ]

ColosseumCharTask:
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
        lda     #$02
        tsb     z47
        lda     #2
        ldy     #near CharIconTask
        jsr     CreateTask
        lda     #$01
        sta     wTaskState,x
        txy
        clr_a
        lda     #$b8
        sta     ze1
        lda     #$68
        sta     ze2
        jsr     _c3b2ec
        jsr     _c3b1f3
        bra     @b2e2
@b2df:  jsr     _c3b2e5
@b2e2:  plb
        sec
        rts

; ------------------------------------------------------------------------------

; [ clear colosseum character name ]

_c3b2e5:
@b2e5:  ldy     #near ColosseumCharBlankNameText
        jsr     DrawPosKana
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b2ec:
@b2ec:  clr_a
        lda     z4b
        tax
        lda     zCharID,x
        rts

; ------------------------------------------------------------------------------

; [ task for "VS" sprite in colosseum ]

ColosseumVSTask:
@b2f3:  tax
        jmp     (near ColosseumVSTaskTbl,x)

ColosseumVSTaskTbl:
@b2f7:  .addr   ColosseumVSTask_00
        .addr   ColosseumVSTask_01

; ------------------------------------------------------------------------------

; [  ]

ColosseumVSTask_00:
@b2fb:  ldx     zTaskOffset
        longa
        lda     #near ColosseumVSAnim
        sta     near wTaskAnimPtr,x
        lda     #$0070
        sta     near wTaskPosX,x
        lda     #$0060
        sta     near wTaskPosY,x
        shorta
        inc     near wTaskState,x
        lda     #^ColosseumVSAnim
        sta     near wTaskAnimBank,x
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

ColosseumVSTask_01:
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
        make_cursor_prop {0, 0}, {4, 1}, NO_Y_WRAP

ColosseumCharCursorPos:
.repeat 4, i
        .byte   $10 + i * $38, $b0
.endrep

; colosseum menu windows
ColosseumPrizeWindow:                   make_window BG2A, {1, 1}, {13, 2}
ColosseumWagerWindow:                   make_window BG2A, {16, 1}, {13, 2}
ColosseumCharWindow:                    make_window BG2A, {1, 18}, {28, 7}

; ------------------------------------------------------------------------------

; [ load colosseum battle bg graphics ]

.proc LoadColosseumBGGfx

gfx_offset_1 := BattleBGGfxPtrs + BATTLE_BG_GFX::FIELD_3 * 3
gfx_offset_2 := BattleBGGfxPtrs + BATTLE_BG_GFX::COLOSSEUM * 3
tiles_offset := BattleBGTilesPtrs + BATTLE_BG_TILES::COLOSSEUM * 2
pal_offset := BattleBGPal + BATTLE_BG_PAL::COLOSSEUM * $60

; graphics 1
        longa
        lda     f:gfx_offset_1
        sta     zf3
        shorta
        lda     f:gfx_offset_1 + 2
        sta     zf5
        jsr     DecompColosseumGfx
        ldy     #$6800
        sty     hVMADDL
        ldy     #$1000
        sty     ze7
        ldx     z0
        jsr     TfrColosseumBGGfx

; graphics 2
        longa
        lda     f:gfx_offset_2
        sta     zf3
        shorta
        lda     f:gfx_offset_2 + 2
        sta     zf5
        jsr     DecompColosseumGfx
        ldy     #$7000
        sty     hVMADDL
        ldy     #$1000
        sty     ze7
        ldx     z0
        jsr     TfrColosseumBGGfx

; tilemap
        longa
        lda     f:tiles_offset
        sta     zf3
        shorta
        lda     #^tiles_offset
        sta     zf5
        jsr     DecompColosseumGfx
        jsr     FixColosseumBGTiles

; palette
        longa
        lda     #near pal_offset
        sta     ze7
        shorta
        lda     #^pal_offset
        sta     ze9
        ldx     #near wPalBuf::BGPal4
        stx     hWMADDL
        ldy     z0
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
        ldx     z0
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

.if LANG_EN

        .define ColosseumCharBlankNameStr       {$ff,$ff,$ff,$ff,$ff,$ff,$00}
        .define ColosseumCharMsgStr             {$92,$9e,$a5,$9e,$9c,$ad,$ff,$ad,$a1,$9e,$ff,$9c,$a1,$9a,$a5,$a5,$9e,$a7,$a0,$9e,$ab,$00}
        .define ColosseumUnknownPrizeStr        {$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$00}

.else

        .define ColosseumCharBlankNameStr       {$ff,$ff,$ff,$ff,$ff,$ff,$00}
        .define ColosseumCharMsgStr             {$81,$c3,$89,$7b,$b9,$77,$bf,$bb,$6d,$a3,$85,$6f,$3f,$75,$8d,$00}
        .define ColosseumUnknownPrizeStr        {$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$00}

.endif

; c3/b406: (22,16) "      "
; c3/b40f: ( 6,19) "select the challenger"
; c3/b427: ( 2, 3) "?????????????"

.if LANG_EN
ColosseumCharBlankNameText:     pos_text BG3A, {22, 16}, ColosseumCharBlankNameStr
ColosseumCharMsgText:           pos_text BG3A, {6, 19}, ColosseumCharMsgStr
ColosseumUnknownPrizeText:      pos_text BG3A, {2, 3}, ColosseumUnknownPrizeStr
.else
ColosseumCharBlankNameText:     pos_text BG3A, {22, 15}, ColosseumCharBlankNameStr
ColosseumCharMsgText:           pos_text BG3A, {8, 19}, ColosseumCharMsgStr
ColosseumUnknownPrizeText:      pos_text BG3A, {4, 3}, ColosseumUnknownPrizeStr
.endif

; ------------------------------------------------------------------------------

; [ colosseum data format ]

;   0: monster opponent
;   1: unused (always $40)
;   2: prize item
;   3: hide prize name if nonzero

; ------------------------------------------------------------------------------

.macro make_colosseum_prop monster, item, hide_prize
        .ifblank monster
                .byte MONSTER::CHUPON_COLOSSEUM
                .byte $40
                .byte ITEM::ELIXIR
        .else
                .byte MONSTER::monster
                .byte $40
                .byte ITEM::item
        .endif
        .ifnblank hide_prize
                .byte $ff
        .else
                .byte 0
        .endif
.endmac

; ------------------------------------------------------------------------------

.pushseg
.segment "colosseum_prop"

; df/b600
ColosseumProp:

make_colosseum_prop                                     ; DIRK
make_colosseum_prop                                     ; MITHRILKNIFE
make_colosseum_prop                                     ; GUARDIAN
make_colosseum_prop                                     ; AIR_LANCET
make_colosseum_prop WART_PUCK, THIEF_GLOVE              ; THIEFKNIFE
make_colosseum_prop TEST_RIDER, SWORDBREAKER            ; ASSASSIN
make_colosseum_prop                                     ; MAN_EATER
make_colosseum_prop                                     ; SWORDBREAKER
make_colosseum_prop KARKASS, DIRK                       ; GRAEDUS
make_colosseum_prop WOOLLY, ASSASSIN                    ; VALIANTKNIFE
make_colosseum_prop                                     ; MITHRILBLADE
make_colosseum_prop                                     ; REGAL_CUTLASS
make_colosseum_prop                                     ; RUNE_EDGE
make_colosseum_prop EVIL_OSCAR, OGRE_NIX                ; FLAME_SABRE
make_colosseum_prop SCULLION, OGRE_NIX                  ; BLIZZARD
make_colosseum_prop STEROIDITE, OGRE_NIX                ; THUNDERBLADE
make_colosseum_prop                                     ; EPEE
make_colosseum_prop LETHAL_WPN, BREAK_BLADE             ; BREAK_BLADE
make_colosseum_prop ENUO, DRAINER                       ; DRAINER
make_colosseum_prop                                     ; ENHANCER
make_colosseum_prop BORRAS, ENHANCER                    ; CRYSTAL
make_colosseum_prop OUTSIDER, FLAME_SHLD                ; FALCHION
make_colosseum_prop OPINICUS, FALCHION                  ; SOUL_SABRE
make_colosseum_prop SRBEHEMOTH_UNDEAD, SOUL_SABRE       ; OGRE_NIX
make_colosseum_prop                                     ; EXCALIBUR
make_colosseum_prop COVERT, OGRE_NIX                    ; SCIMITAR
make_colosseum_prop SCULLION, SCIMITAR                  ; ILLUMINA
make_colosseum_prop DIDALOS, ILLUMINA, 1                ; RAGNAROK
make_colosseum_prop GTBEHEMOTH, GRAEDUS                 ; ATMA_WEAPON
make_colosseum_prop                                     ; MITHRIL_PIKE
make_colosseum_prop                                     ; TRIDENT
make_colosseum_prop                                     ; STOUT_SPEAR
make_colosseum_prop                                     ; PARTISAN
make_colosseum_prop SKY_BASE, STRATO                    ; PEARL_LANCE
make_colosseum_prop                                     ; GOLD_LANCE
make_colosseum_prop LAND_WORM, SKY_RENDER               ; AURA_LANCE
make_colosseum_prop ALLOSAURUS, CAT_HOOD                ; IMP_HALBERD
make_colosseum_prop                                     ; IMPERIAL
make_colosseum_prop                                     ; KODACHI
make_colosseum_prop                                     ; BLOSSOM
make_colosseum_prop PHASE, MURASAME                     ; HARDENED
make_colosseum_prop CHUPON_COLOSSEUM, STRIKER, 1        ; STRIKER
make_colosseum_prop TEST_RIDER, STRATO                  ; STUNNER
make_colosseum_prop                                     ; ASHURA
make_colosseum_prop                                     ; KOTETSU
make_colosseum_prop                                     ; FORGED
make_colosseum_prop                                     ; TEMPEST
make_colosseum_prop BORRAS, AURA                        ; MURASAME
make_colosseum_prop RHYOS, STRATO                       ; AURA
make_colosseum_prop AQUILA, PEARL_LANCE                 ; STRATO
make_colosseum_prop SCULLION, AURA_LANCE                ; SKY_RENDER
make_colosseum_prop PUG, MAGUS_ROD                      ; HEAL_ROD
make_colosseum_prop                                     ; MITHRIL_ROD
make_colosseum_prop                                     ; FIRE_ROD
make_colosseum_prop                                     ; ICE_ROD
make_colosseum_prop                                     ; THUNDER_ROD
make_colosseum_prop                                     ; POISON_ROD
make_colosseum_prop                                     ; PEARL_ROD
make_colosseum_prop                                     ; GRAVITY_ROD
make_colosseum_prop OPINICUS, GRAVITY_ROD               ; PUNISHER
make_colosseum_prop ALLOSAURUS, STRATO                  ; MAGUS_ROD
make_colosseum_prop                                     ; CHOCOBO_BRSH
make_colosseum_prop                                     ; DAVINCI_BRSH
make_colosseum_prop                                     ; MAGICAL_BRSH
make_colosseum_prop TEST_RIDER, GRAVITY_ROD             ; RAINBOW_BRSH
make_colosseum_prop                                     ; SHURIKEN
make_colosseum_prop CHAOS_DRGN, TACK_STAR               ; NINJA_STAR
make_colosseum_prop OPINICUS, RISING_SUN                ; TACK_STAR
make_colosseum_prop                                     ; FLAIL
make_colosseum_prop                                     ; FULL_MOON
make_colosseum_prop                                     ; MORNING_STAR
make_colosseum_prop                                     ; BOOMERANG
make_colosseum_prop ALLOSAURUS, BONE_CLUB               ; RISING_SUN
make_colosseum_prop                                     ; HAWK_EYE
make_colosseum_prop TEST_RIDER, RED_JACKET              ; BONE_CLUB
make_colosseum_prop BORRAS, BONE_CLUB                   ; SNIPER
make_colosseum_prop RHYOS, SNIPER                       ; WING_EDGE
make_colosseum_prop                                     ; CARDS
make_colosseum_prop                                     ; DARTS
make_colosseum_prop OPINICUS, BONE_CLUB                 ; DOOM_DARTS
make_colosseum_prop ALLOSAURUS, TRUMP                   ; TRUMP
make_colosseum_prop                                     ; DICE
make_colosseum_prop TRIXTER, FIRE_KNUCKLE               ; FIXED_DICE
make_colosseum_prop                                     ; METALKNUCKLE
make_colosseum_prop                                     ; MITHRIL_CLAW
make_colosseum_prop                                     ; KAISER
make_colosseum_prop                                     ; POISON_CLAW
make_colosseum_prop TUMBLEWEED, FIRE_KNUCKLE            ; FIRE_KNUCKLE
make_colosseum_prop TEST_RIDER, SNIPER                  ; DRAGON_CLAW
make_colosseum_prop MANTODEA, FIRE_KNUCKLE              ; TIGER_FANGS
make_colosseum_prop                                     ; BUCKLER
make_colosseum_prop                                     ; HEAVY_SHLD
make_colosseum_prop                                     ; MITHRIL_SHLD
make_colosseum_prop                                     ; GOLD_SHLD
make_colosseum_prop BORRAS, TORTOISESHLD                ; AEGIS_SHLD
make_colosseum_prop                                     ; DIAMOND_SHLD
make_colosseum_prop IRONHITMAN, ICE_SHLD                ; FLAME_SHLD
make_colosseum_prop INNOC, FLAME_SHLD                   ; ICE_SHLD
make_colosseum_prop OUTSIDER, GENJI_SHLD                ; THUNDER_SHLD
make_colosseum_prop                                     ; CRYSTAL_SHLD
make_colosseum_prop RETAINER, THUNDER_SHLD              ; GENJI_SHLD
make_colosseum_prop STEROIDITE, TITANIUM                ; TORTOISESHLD
make_colosseum_prop DIDALOS, CURSED_RING                ; CURSED_SHLD
make_colosseum_prop HEMOPHYTE, FORCE_SHLD               ; PALADIN_SHLD
make_colosseum_prop DARK_FORCE, THORNLET                ; FORCE_SHLD
make_colosseum_prop                                     ; LEATHER_HAT
make_colosseum_prop                                     ; HAIR_BAND
make_colosseum_prop                                     ; PLUMED_HAT
make_colosseum_prop                                     ; BERET
make_colosseum_prop                                     ; MAGUS_HAT
make_colosseum_prop                                     ; BANDANA
make_colosseum_prop                                     ; IRONHELMET
make_colosseum_prop EVIL_OSCAR, REGAL_CROWN             ; CORONET
make_colosseum_prop                                     ; BARDS_HAT
make_colosseum_prop                                     ; GREEN_BERET
make_colosseum_prop                                     ; HEAD_BAND
make_colosseum_prop                                     ; MITHRIL_HELM
make_colosseum_prop                                     ; TIARA
make_colosseum_prop                                     ; GOLD_HELMET
make_colosseum_prop                                     ; TIGER_MASK
make_colosseum_prop RHYOS, CORONET                      ; RED_CAP
make_colosseum_prop                                     ; MYSTERY_VEIL
make_colosseum_prop                                     ; CIRCLET
make_colosseum_prop OPINICUS, GENJI_HELMET              ; REGAL_CROWN
make_colosseum_prop                                     ; DIAMOND_HELM
make_colosseum_prop                                     ; DARK_HOOD
make_colosseum_prop DUELLER, DIAMOND_HELM               ; CRYSTAL_HELM
make_colosseum_prop                                     ; OATH_VEIL
make_colosseum_prop HOOVER,   MERIT_AWARD, 1            ; CAT_HOOD
make_colosseum_prop FORTIS, CRYSTAL_HELM                ; GENJI_HELMET
make_colosseum_prop OPINICUS, MIRAGE_VEST               ; THORNLET
make_colosseum_prop BRACHOSAUR, CAT_HOOD                ; TITANIUM
make_colosseum_prop                                     ; LEATHERARMOR
make_colosseum_prop                                     ; COTTON_ROBE
make_colosseum_prop                                     ; KUNG_FU_SUIT
make_colosseum_prop                                     ; IRON_ARMOR
make_colosseum_prop                                     ; SILK_ROBE
make_colosseum_prop                                     ; MITHRIL_VEST
make_colosseum_prop                                     ; NINJA_GEAR
make_colosseum_prop                                     ; WHITE_DRESS
make_colosseum_prop                                     ; MITHRIL_MAIL
make_colosseum_prop                                     ; GAIA_GEAR
make_colosseum_prop VECTAGOYLE, RED_JACKET              ; MIRAGE_VEST
make_colosseum_prop                                     ; GOLD_ARMOR
make_colosseum_prop                                     ; POWER_SASH
make_colosseum_prop                                     ; LIGHT_ROBE
make_colosseum_prop                                     ; DIAMOND_VEST
make_colosseum_prop VECTAGOYLE, RED_JACKET              ; RED_JACKET
make_colosseum_prop SRBEHEMOTH_UNDEAD, FORCE_ARMOR      ; FORCE_ARMOR
make_colosseum_prop                                     ; DIAMONDARMOR
make_colosseum_prop                                     ; DARK_GEAR
make_colosseum_prop TEST_RIDER, TAO_ROBE                ; TAO_ROBE
make_colosseum_prop COVERT, ICE_SHLD                    ; CRYSTAL_MAIL
make_colosseum_prop SKY_BASE, MINERVA                   ; CZARINA_GOWN
make_colosseum_prop BORRAS, AIR_ANCHOR                  ; GENJI_ARMOR
make_colosseum_prop RHYOS, TORTOISESHLD                 ; IMPS_ARMOR
make_colosseum_prop PUG, CZARINA_GOWN                   ; MINERVA
make_colosseum_prop VECTAUR, CHOCOBO_SUIT               ; TABBY_SUIT
make_colosseum_prop VETERAN, MOOGLE_SUIT                ; CHOCOBO_SUIT
make_colosseum_prop MADAM, NUTKIN_SUIT                  ; MOOGLE_SUIT
make_colosseum_prop OPINICUS, GENJI_ARMOR               ; NUTKIN_SUIT
make_colosseum_prop OUTSIDER, SNOW_MUFFLER              ; BEHEMOTHSUIT
make_colosseum_prop RETAINER, CHARM_BANGLE              ; SNOW_MUFFLER
make_colosseum_prop                                     ; NOISEBLASTER
make_colosseum_prop                                     ; BIO_BLASTER
make_colosseum_prop                                     ; FLASH
make_colosseum_prop                                     ; CHAIN_SAW
make_colosseum_prop                                     ; DEBILITATOR
make_colosseum_prop                                     ; DRILL
make_colosseum_prop BRONTAUR, ZEPHYR_CAPE               ; AIR_ANCHOR
make_colosseum_prop                                     ; AUTOCROSSBOW
make_colosseum_prop                                     ; FIRE_SKEAN
make_colosseum_prop                                     ; WATER_EDGE
make_colosseum_prop                                     ; BOLT_EDGE
make_colosseum_prop                                     ; INVIZ_EDGE
make_colosseum_prop                                     ; SHADOW_EDGE
make_colosseum_prop                                     ; GOGGLES
make_colosseum_prop                                     ; STAR_PENDANT
make_colosseum_prop                                     ; PEACE_RING
make_colosseum_prop                                     ; AMULET
make_colosseum_prop                                     ; WHITE_CAPE
make_colosseum_prop                                     ; JEWEL_RING
make_colosseum_prop                                     ; FAIRY_RING
make_colosseum_prop                                     ; BARRIER_RING
make_colosseum_prop                                     ; MITHRILGLOVE
make_colosseum_prop                                     ; GUARD_RING
make_colosseum_prop                                     ; RUNNINGSHOES
make_colosseum_prop                                     ; WALL_RING
make_colosseum_prop                                     ; CHERUB_DOWN
make_colosseum_prop                                     ; CURE_RING
make_colosseum_prop                                     ; TRUE_KNIGHT
make_colosseum_prop                                     ; DRAGOONBOOTS
make_colosseum_prop                                     ; ZEPHYR_CAPE
make_colosseum_prop                                     ; CZARINA_RING
make_colosseum_prop STEROIDITE, AIR_ANCHOR              ; CURSED_RING
make_colosseum_prop                                     ; EARRINGS
make_colosseum_prop                                     ; ATLAS_ARMLET
make_colosseum_prop ALLOSAURUS, RAGE_RING               ; BLIZZARD_ORB
make_colosseum_prop ALLOSAURUS, BLIZZARD_ORB            ; RAGE_RING
make_colosseum_prop TAP_DANCER, THIEF_GLOVE             ; SNEAK_RING
make_colosseum_prop HEMOPHYTE, HERO_RING                ; POD_BRACELET
make_colosseum_prop RHYOS, POD_BRACELET                 ; HERO_RING
make_colosseum_prop DARK_FORCE, GOLD_HAIRPIN            ; RIBBON
make_colosseum_prop ALLOSAURUS, CRYSTAL_ORB             ; MUSCLE_BELT
make_colosseum_prop BORRAS, GOLD_HAIRPIN                ; CRYSTAL_ORB
make_colosseum_prop EVIL_OSCAR, DRAGON_HORN             ; GOLD_HAIRPIN
make_colosseum_prop VECTAGOYLE, DRAGON_HORN             ; ECONOMIZER
make_colosseum_prop HARPY, DIRK                         ; THIEF_GLOVE
make_colosseum_prop VECTAGOYLE, THUNDER_SHLD            ; GAUNTLET
make_colosseum_prop HEMOPHYTE, THUNDER_SHLD             ; GENJI_GLOVE
make_colosseum_prop                                     ; HYPER_WRIST
make_colosseum_prop                                     ; OFFERING
make_colosseum_prop                                     ; BEADS
make_colosseum_prop                                     ; BLACK_BELT
make_colosseum_prop                                     ; COIN_TOSS
make_colosseum_prop                                     ; FAKEMUSTACHE
make_colosseum_prop SRBEHEMOTH_UNDEAD, ECONOMIZER       ; GEM_BOX
make_colosseum_prop RHYOS, GOLD_HAIRPIN                 ; DRAGON_HORN
make_colosseum_prop COVERT, RENAME_CARD, 1              ; MERIT_AWARD
make_colosseum_prop CHUPON_COLOSSEUM, MEMENTO_RING      ; MEMENTO_RING
make_colosseum_prop PUG, DRAGON_HORN                    ; SAFETY_BIT
make_colosseum_prop SKY_BASE, CHARM_BANGLE              ; RELIC_RING
make_colosseum_prop OUTSIDER, CHARM_BANGLE              ; MOOGLE_CHARM
make_colosseum_prop RETAINER, DRAGON_HORN               ; CHARM_BANGLE
make_colosseum_prop TYRANOSAUR, TINTINABAR              ; MARVEL_SHOES
make_colosseum_prop                                     ; BACK_GUARD
make_colosseum_prop                                     ; GALE_HAIRPIN
make_colosseum_prop                                     ; SNIPER_SIGHT
make_colosseum_prop STEROIDITE, TINTINABAR              ; EXP_EGG
make_colosseum_prop DARK_FORCE, EXP_EGG                 ; TINTINABAR
make_colosseum_prop                                     ; SPRINT_SHOES
make_colosseum_prop DOOM_DRGN, MARVEL_SHOES             ; RENAME_CARD
make_colosseum_prop                                     ; TONIC
make_colosseum_prop                                     ; POTION
make_colosseum_prop                                     ; X_POTION
make_colosseum_prop                                     ; TINCTURE
make_colosseum_prop                                     ; ETHER
make_colosseum_prop                                     ; X_ETHER
make_colosseum_prop CACTROT, RENAME_CARD                ; ELIXIR
make_colosseum_prop SIEGFRIED_1, TINTINABAR             ; MEGALIXIR
make_colosseum_prop CACTROT, MAGICITE                   ; FENIX_DOWN
make_colosseum_prop                                     ; REVIVIFY
make_colosseum_prop                                     ; ANTIDOTE
make_colosseum_prop                                     ; EYEDROP
make_colosseum_prop                                     ; SOFT
make_colosseum_prop                                     ; REMEDY
make_colosseum_prop                                     ; SLEEPING_BAG
make_colosseum_prop                                     ; TENT
make_colosseum_prop                                     ; GREEN_CHERRY
make_colosseum_prop                                     ; MAGICITE
make_colosseum_prop                                     ; SUPER_BALL
make_colosseum_prop                                     ; ECHO_SCREEN
make_colosseum_prop                                     ; SMOKE_BOMB
make_colosseum_prop                                     ; WARP_STONE
make_colosseum_prop                                     ; DRIED_MEAT
make_colosseum_prop                                     ; EMPTY

.popseg

; ------------------------------------------------------------------------------
