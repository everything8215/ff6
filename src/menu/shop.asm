
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: shop.asm                                                             |
; |                                                                            |
; | description: shop menu                                                     |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

inc_lang "text/item_name_%s.inc"

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ menu state $24: shop (init) ]

MenuState_24:
@b466:  jsr     DisableInterrupts
        jsr     ClearBGScroll
.if LANG_EN
        jsr     DisableWindow1PosHDMA
.endif
        lda     #$03
        sta     hBG1SC
        lda     #BIT_6 | BIT_7
        trb     zEnableHDMA
        lda     #$02
        sta     z46
        stz     $4a
        jsr     LoadShopOptionCursor
        jsr     InitShopOptionCursor
        jsr     CreateCursorTask
        jsr     DrawShopMenu
        jsr     InitItemBGScrollHDMA
        jsr     InitShopScrollHDMA
        lda     #$25
        sta     zNextMenuState
        lda     #$01
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $25: shop options (buy, sell, exit) ]

MenuState_25:
@b49b:  jsr     UpdateShopOptionCursor
        lda     z08
        bit     #JOY_A
        beq     @b4aa
        jsr     PlaySelectSfx
        jmp     _c3b792
@b4aa:  lda     z08+1
        bit     #>JOY_B
        beq     _b4bc
        jsr     PlayCancelSfx

_c3b4b3:
@b4b3:  stz     w0205
        lda     #$ff
        sta     zNextMenuState
        stz     zMenuState
_b4bc:  rts

; ------------------------------------------------------------------------------

; [ menu state $26: buy (item select) ]

MenuState_26:
@b4bd:  lda     #$10
        tsb     z45
        jsr     InitDMA1BG3ScreenA
        jsr     UpdateShopBuyMenuCursor
        jsr     _c3bc84
        jsr     _c3bca8
        lda     z08+1
        bit     #>JOY_B
        beq     @b4d9
        jsr     PlayCancelSfx
        jmp     _c3b760
@b4d9:  lda     z08
        bit     #JOY_A
        beq     @b4e5
        jsr     _c3b82f
        jsr     _c3b7e6
@b4e5:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b4e6:
@b4e6:  lda     #$10
        trb     z45
        lda     #$20
        tsb     z45
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b4ef:
@b4ef:  jsr     GetItemDescPtr
        jsr     _c3bfc2
        jmp     LoadItemDesc

; ------------------------------------------------------------------------------

; [  ]

_c3b4f8:
@b4f8:  jsr     GetItemDescPtr
        clr_a
        lda     $4b
        tax
        lda     $1869,x
        jmp     LoadItemDesc

; ------------------------------------------------------------------------------

; [ menu state $27: buy (quantity) ]

MenuState_27:
@b505:  jsr     _c3b4e6
        jsr     _c3b4ef
        jsr     _c3bb53
        jsr     _c3bbae
        lda     z0a+1
        bit     #$01
        beq     @b539
        jsr     PlayMoveSfx
        lda     zSelIndex
        cmp     $6a
        beq     @b57c
        inc     zSelIndex
        jsr     _c3bb53
        lda     $1860
        cmp     $f1
        lda     $1861
        sbc     $f2
        lda     $1862
        sbc     $f3
        bcs     @b538
        dec     zSelIndex
@b538:  rts
@b539:  lda     z0a+1
        bit     #$02
        beq     @b54a
        jsr     PlayMoveSfx
        lda     zSelIndex
        cmp     #$01
        beq     @b59e
        dec     zSelIndex
@b54a:  lda     z0a+1
        bit     #$08
        beq     @b583
        jsr     PlayMoveSfx
        lda     #$0a
        clc
        adc     zSelIndex
        cmp     $6a
        beq     @b55e
        bcs     @b57f
@b55e:  sta     zSelIndex
        jsr     _c3bb53
        lda     $1860
        cmp     $f1
        lda     $1861
        sbc     $f2
        lda     $1862
        sbc     $f3
        bcs     @b57b
        lda     zSelIndex
        sec
        sbc     #$0a
        sta     zSelIndex
@b57b:  rts
@b57c:  jmp     @b59e
@b57f:  lda     zSelIndex
        bra     @b55e
@b583:  lda     z0a+1
        bit     #$04
        beq     @b59e
        jsr     PlayMoveSfx
        lda     zSelIndex
        sec
        sbc     #$0a
        bmi     @b59a
        cmp     #$01
        bcc     @b59e
        sta     zSelIndex
        rts
@b59a:  lda     #$01
        sta     zSelIndex
@b59e:  lda     z08+1
        bit     #>JOY_B
        beq     @b5aa
        jsr     PlayCancelSfx
        jmp     _c3b7b3
@b5aa:  lda     z08
        bit     #JOY_A
        beq     @b5b6
        jsr     PlayShopSfx
        jsr     _c3b5b7
@b5b6:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b5b7:
@b5b7:  jsr     _c3bfc2
        ldy     z0
@b5bc:  cmp     $1869,y
        beq     @b5e1
        iny
        cpy     #$0100
        bne     @b5bc
        ldy     z0
@b5c9:  lda     $1869,y
        cmp     #$ff
        beq     @b5d3
        iny
        bra     @b5c9
@b5d3:  lda     zSelIndex
        sta     $1969,y
        lda     $7e9d89,x
        sta     $1869,y
        bra     @b5ea
@b5e1:  lda     zSelIndex
        clc
        adc     $1969,y
        sta     $1969,y
@b5ea:  jsr     _c3bb53
        sec
        lda     $1860
        sbc     $f1
        sta     $1860
        longa
        lda     $1861
        sbc     $f2
        sta     $1861
        shorta
        jsr     ValidateMaxGil
        ldy     #near ShopByeMsgText
        jsr     DrawPosKana
        jmp     _c3b87d

; ------------------------------------------------------------------------------

; [ menu state $28: buy (return to state item select) ]

MenuState_28:
@b60e:  lda     zWaitCounter
        bne     @b615
        jsr     _c3b7b3
@b615:  rts

; ------------------------------------------------------------------------------

; [ menu state $29: sell (item select) ]

MenuState_29:
@b616:  lda     #$10
        tsb     z45
        clr_a
        sta     zListType
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @b675
        jsr     UpdateItemListCursor
        lda     z08+1
        bit     #>JOY_B
        beq     @b634       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        jmp     _c3b760
@b634:  lda     z08
        bit     #JOY_A
        beq     @b675       ; return if a button is not pressed
        jsr     _c3bfcb
        cmp     #$ff
        beq     @b66f       ; branch if no item
        jsr     PlaySelectSfx
        lda     #$c0
        trb     z46
        jsr     ClearBG1ScreenA
        jsr     InitDMA1BG1ScreenA
        jsr     WaitVblank
        lda     #$2a
        sta     zMenuState
        ldx     #$0008
        stx     $55
        ldx     #$0034
        stx     $57
        jsr     _c3baa5
        jsr     _c3bad3
        ldy     #near ShopSellQtyMsgText
        jsr     DrawPosKana
        jsr     _c3b86d
        rts
@b66f:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@b675:  rts

; ------------------------------------------------------------------------------

; [ menu state $2a: sell (quantity) ]

MenuState_2a:
@b676:  jsr     _c3b4e6
        jsr     _c3b4f8
        jsr     _c3bb65
        jsr     _c3bbb7
        lda     z0a+1
        bit     #$01
        beq     @b695
        jsr     PlayMoveSfx
        lda     zSelIndex
        cmp     $64
        beq     @b6e0
        inc     zSelIndex
        bra     @b6e0
@b695:  lda     z0a+1
        bit     #$02
        beq     @b6a6
        jsr     PlayMoveSfx
        lda     zSelIndex
        cmp     #$01
        beq     @b6e0
        dec     zSelIndex
@b6a6:  lda     z0a+1
        bit     #$08
        beq     @b6c4
        jsr     PlayMoveSfx
        lda     #$0a
        clc
        adc     zSelIndex
        cmp     $64
        beq     @b6be
        bcs     @b6be
        sta     zSelIndex
        bra     @b6e0
@b6be:  lda     $64
        sta     zSelIndex
        bra     @b6e0
@b6c4:  lda     z0a+1
        bit     #$04
        beq     @b6e0
        jsr     PlayMoveSfx
        lda     zSelIndex
        sec
        sbc     #$0a
        bmi     @b6dc
        cmp     #$01
        bcc     @b6e0
        sta     zSelIndex
        bra     @b6e0
@b6dc:  lda     #$01
        sta     zSelIndex
@b6e0:  lda     z08+1
        bit     #>JOY_B
        beq     @b6fb
        jsr     PlayCancelSfx
        ldx     z0
        stx     zBG2HScroll
        stx     zBG2VScroll
        jsr     _c3b95a
        ldy     #near ShopOptionsText
        jsr     DrawPosKana
        jmp     _c3b7cf
@b6fb:  lda     z08
        bit     #JOY_A
        beq     @b707
        jsr     PlayShopSfx
        jsr     _c3b708
@b707:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b708:
@b708:  jsr     _c3bb65
        clc
        lda     $1860
        adc     $f1
        sta     $1860
        longa
        lda     $1861
        adc     $f2
        sta     $1861
        shorta
        lda     $64
        cmp     zSelIndex
        beq     @b734
        jsr     _c3bfcb
        lda     $1969,y
        sec
        sbc     zSelIndex
        sta     $1969,y
        bra     @b740
@b734:  jsr     _c3bfcb
        lda     #$ff
        sta     $1869,y
        clr_a
        sta     $1969,y
@b740:  jsr     ValidateMaxGil
        ldy     #near ShopByeMsgText
        jsr     DrawPosKana
        lda     #$2b
        sta     zMenuState
        lda     #$20
        sta     zWaitCounter
        rts

; ------------------------------------------------------------------------------

; [ menu state $2b: sell (thank you) ]

MenuState_2b:
@b752:  lda     zWaitCounter
        bne     @b75f
        ldx     z0
        stx     zBG2HScroll
        stx     zBG2VScroll
        jsr     _c3b7cf
@b75f:  rts

; ------------------------------------------------------------------------------

; [ reload menu state $25 ]

_c3b760:
@b760:  lda     #$c0
        trb     z46
        stz     $47
        jsr     LoadShopOptionCursor
        jsr     InitShopOptionCursor
        jsr     InitDMA1BG1ScreenA
        jsr     _c3b94e
        jsr     WaitVblank
        jsr     InitDMA1BG3ScreenA
        jsr     _c3b95a
        ldy     #near ShopOptionsText
        jsr     DrawPosKana
        ldy     #near ShopGreetingMsgText
        jsr     DrawPosKana
        ldy     z0
        sty     zBG2HScroll
        sty     zBG2VScroll
        lda     #$25
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ select shop option (buy, sell, exit) ]

SelectShopOption:
_c3b792:
@b792:  clr_a
        lda     $4b
        asl
        tax
        jmp     (near SelectShopOptionTbl,x)

SelectShopOptionTbl:
@b79a:  .addr   SelectShopOption_00
        .addr   SelectShopOption_01
        .addr   SelectShopOption_02

; ------------------------------------------------------------------------------

; [ 2: exit ]

SelectShopOption_02:
@b7a0:  jmp     _c3b4b3

; ------------------------------------------------------------------------------

; [ 0: buy ]

SelectShopOption_00:
@b7a3:  jsr     LoadShopBuyMenuCursor
        jsr     InitShopBuyMenuCursor
        lda     #$08
        trb     $47
        jsr     InitShopCharSprites
        jsr     _c3c23b

_c3b7b3:
@b7b3:  ldy     #$0100
        sty     zBG2HScroll
        ldy     z0
        sty     zBG2VScroll
        jsr     _c3b986
        jsr     _c3bcfd
        lda     #$26
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [ 1: sell ]

SelectShopOption_01:
@b7c7:  jsr     InitDMA1BG3ScreenA
        jsr     _c3bbe0
        bra     _b7d2

_c3b7cf:
@b7cf:  jsr     _c3bc02
_b7d2:  jsr     _c3b95a
        ldy     #near ShopOptionsText
        jsr     DrawPosKana
        ldy     #near ShopSellMsgText
        jsr     DrawPosKana
        lda     #$29
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b7e6:
@b7e6:  jsr     _c3bfc2
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        bne     @b80a       ; branch if not a tool
        jsr     _c3bc92
        lda     $64
        beq     @b80a
        jsr     PlayInvalidSfx
        ldy     #near ShopOnlyOneMsgText
        jsr     DrawPosKana
        jmp     _c3b87d
@b80a:  lda     $1862       ; msb of current gp
        bne     _b83e       ; branch if more than 65535 gp
        clr_a
        lda     $4b
        asl
        tax
        longa
        lda     $7e9f09,x   ; item price
        cmp     $1860
        shorta
        beq     _b83e       ; branch if enough gp
        bcc     _b83e
        jsr     PlayInvalidSfx
        ldy     #near ShopNotEnoughGilMsgText
        jsr     DrawPosKana
        jmp     _c3b87d

; ------------------------------------------------------------------------------

; [  ]

_c3b82f:
@b82f:  lda     $64
        clc
        adc     $65
        sta     $69
        lda     #$63
        sec
        sbc     $69
        sta     $6a
        rts

; ------------------------------------------------------------------------------

; buy item (branch from c3/b81f)
_b83e:  lda     $69         ; item quantity
        cmp     #$63
        bcc     @b850
        jsr     PlayInvalidSfx
        ldy     #near ShopTooManyMsgText
        jsr     DrawPosKana
        jmp     _c3b87d
@b850:  jsr     PlaySelectSfx
        ldx     #$0008
        stx     $55
        ldx     #$0034
        stx     $57
        lda     #$27        ; go to menu state $27
        sta     zMenuState
        jsr     _c3baa5
        jsr     _c3baba
        ldy     #near ShopBuyQtyMsgText
        jsr     DrawPosKana

_c3b86d:
@b86d:  ldy     #$0100
        sty     zBG2VScroll
        ldy     z0
        sty     zBG2HScroll
        jsr     ClearBigTextBuf
        jsr     _c3a6f4
        rts

; ------------------------------------------------------------------------------

_c3b87d:
@b87d:  lda     #$28
        sta     zMenuState
        lda     #$20
        sta     zWaitCounter
        rts

; ------------------------------------------------------------------------------

; [ init cursor for shop options menu ]

LoadShopOptionCursor:
@b886:  ldy     #near ShopOptionCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for menu state $25 ]

UpdateShopOptionCursor:
@b88c:  jsr     MoveCursor

InitShopOptionCursor:
@b88f:  ldy     #near ShopOptionCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; cursor properties for menu state $25
ShopOptionCursorProp:
        cursor_prop {0, 0}, {3, 1}, NO_Y_WRAP

; cursor positions for menu state $25
ShopOptionCursorPos:
.if LANG_EN
@b89a:  cursor_pos {8, 52}
        cursor_pos {48, 52}
        cursor_pos {96, 52}
.else
        cursor_pos {8, 52}
        cursor_pos {40, 52}
        cursor_pos {72, 52}
.endif

; ------------------------------------------------------------------------------

; [ init cursor for shop buy menu ]

LoadShopBuyMenuCursor:
@b8a0:  ldy     #near ShopBuyMenuCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for shop buy menu ]

UpdateShopBuyMenuCursor:
@b8a6:  jsr     MoveCursor

InitShopBuyMenuCursor:
@b8a9:  ldy     #near ShopBuyMenuCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; cursor properties for menu state $26
ShopBuyMenuCursorProp:
        cursor_prop {0, 0}, {1, 8}, NO_X_WRAP

; cursor positions for menu state $26
ShopBuyMenuCursorPos:
.if LANG_EN
@b8b4:  cursor_pos {0, 52}
        cursor_pos {0, 64}
        cursor_pos {0, 76}
        cursor_pos {0, 88}
        cursor_pos {0, 100}
        cursor_pos {0, 112}
        cursor_pos {0, 124}
        cursor_pos {0, 136}
.else
        cursor_pos {8, 52}
        cursor_pos {8, 64}
        cursor_pos {8, 76}
        cursor_pos {8, 88}
        cursor_pos {8, 100}
        cursor_pos {8, 112}
        cursor_pos {8, 124}
        cursor_pos {8, 136}
.endif

; ------------------------------------------------------------------------------

; [ draw shop menu ]

DrawShopMenu:
@b8c4:  jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        jsr     ClearBG2ScreenC
        ldy     #near ShopSellTitleWindow
        jsr     DrawWindow
        ldy     #near ShopSellMsgWindow
        jsr     DrawWindow
        ldy     #near ShopSellOptionsWindow
        jsr     DrawWindow
        ldy     #near ShopSellGilWindow
        jsr     DrawWindow
        ldy     #near ShopSellListWindow
        jsr     DrawWindow
        ldy     #near ShopBuyTitleWindow
        jsr     DrawWindow
        ldy     #near ShopBuyMsgWindow
        jsr     DrawWindow
        ldy     #near ShopBuyCharWindow
        jsr     DrawWindow
.if LANG_EN
        ldy     #near ShopBuyListWindow
        jsr     DrawWindow
        ldy     #near ShopQtyTitleWindow
        jsr     DrawWindow
.else
        ldy     #near ShopBuyListWindow1
        jsr     DrawWindow
        ldy     #near ShopBuyListWindow2
        jsr     DrawWindow
        ldy     #near ShopQtyTitleWindow
        jsr     DrawWindow
.endif
        ldy     #near ShopQtyGilWindow
        jsr     DrawWindow
        ldy     #near ShopQtyDescWindow
        jsr     DrawWindow
        ldy     #near ShopQtyMsgWindow
        jsr     DrawWindow
        ldy     #near ShopQtyCharWindow
        jsr     DrawWindow
        ldy     #near ShopQtyItemWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     TfrBG2ScreenCD
        jsr     _c3b94e
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenCD
        jsr     _c3b95a
        ldy     #near ShopOptionsText
        jsr     DrawPosKana
        ldy     #near ShopGreetingMsgText
        jsr     DrawPosKana
        jsr     InitBigText
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

; [  ]

_c3b94e:
@b94e:  jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG1ScreenC
        jmp     ClearBG1ScreenD

; ------------------------------------------------------------------------------

; [  ]

_c3b95a:
@b95a:  jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     DrawShopTypeText
        jsr     _c3c2f7
        ldy     #near ShopGilText1
        jsr     DrawPosKana
        jsr     _c3c2f2
        ldy     $1860
        sty     $f1
        lda     $1862
        sta     $f3
        jsr     HexToDec8
        ldx_pos BG3A, {21, 7}
        jsr     DrawNum7
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b986:
@b986:  jsr     _c3b95a
        ldy     #near ShopBuyMsgText
        jsr     DrawPosKana
        jsr     _c3c2e1
        ldy     z0
        sty     $f1
        stz     $e6
@b998:  longa
        lda     $f1
        asl
        tax
        lda     f:_c3b9fc,x
        sta     $7e9e89
        lda     $f1
        clc
        adc     zSelCharPropPtr
        inc
        tax
        shorta
        lda     f:ShopProp,x            ; item id
        ldx     $f1
        sta     $7e9d89,x
        cmp     #$ff
        beq     @b9e4
        jsr     LoadItemName
        jsr     DrawPosTextBuf
        ldx     $f1
        lda     $7e9d89,x
        jsr     GetItemPropPtr
        jsr     CalcShopPrice
        jsr     HexToDec5
        longa
        lda     $7e9e89
        clc
.if LANG_EN
        adc     #$001a
.else
        adc     #$0056
.endif
        tax
        shorta
        jsr     DrawNum5
        inc     $e6
@b9e4:  ldy     $f1
        iny
        sty     $f1
        cpy     #8
        bne     @b998
        lda     $e6
        sta     $54
        jsr     _c3bc57
        jsr     _c3bc84
        jsr     _c3bca8
        rts

; ------------------------------------------------------------------------------

_c3b9fc:
.if LANG_EN
        @X_POS = 2
        @Y_POS = 7
.else
        @X_POS = 3
        @Y_POS = 6
.endif

        .repeat 8, i
        make_pos BG3A, {@X_POS, @Y_POS + i * 2}
        .endrep

; ------------------------------------------------------------------------------

; [ calculate item price in shop ]

CalcShopPrice:
@ba0c:  longa
        lda     hMPYL
        clc
        adc     #$001c
        tax
        lda     f:ItemProp,x
        jsr     AdjustShopPrice
        sta     $f3
        lda     $f1
        asl
        tax
        lda     $f3
        sta     $7e9f09,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ adjust shop item price ]

AdjustShopPrice:
@ba2c:  pha
        ldx     zSelCharPropPtr
        clr_a
        shorta
        lda     f:ShopProp,x            ; shop price adjustment
        and     #$38
        longa
        lsr2
        tax
        pla
        jmp     (near AdjustShopPriceTbl,x)

; jump table for shop price adjustment
;  0 = none
;  1 = +50%
;  2 = +100%
;  3 = -50%
;  4 = -50% for female showing character (terra, celes, or relm), +50% for male
;  5 = -50% for male showing character, +50% for female
;  6 = -50% if edgar is showing character
AdjustShopPriceTbl:
@ba41:  .addr   AdjustShopPrice_00
        .addr   AdjustShopPrice_01
        .addr   AdjustShopPrice_02
        .addr   AdjustShopPrice_03
        .addr   AdjustShopPrice_04
        .addr   AdjustShopPrice_05
        .addr   AdjustShopPrice_06

; ------------------------------------------------------------------------------

; 1: +50%
AdjustShopPrice_01:
@ba4f:  sta     $e7
        lsr
        clc
        adc     $e7
; fallthrough

; ------------------------------------------------------------------------------

; 0: no price adjustment
AdjustShopPrice_00:
@ba55:  rts

; ------------------------------------------------------------------------------

; +100%
AdjustShopPrice_02:
@ba56:  asl
        rts

; ------------------------------------------------------------------------------

; -50%
AdjustShopPrice_03:
@ba58:  lsr
        rts

; ------------------------------------------------------------------------------

; -50% female, +50% male
AdjustShopPrice_04:
@ba5a:  pha
        shorta
        lda     w0202
        cmp     #MAP_SPRITE_GFX::CELES
        beq     @ba71
        cmp     #MAP_SPRITE_GFX::RELM
        beq     @ba71
        cmp     #MAP_SPRITE_GFX::TERRA
        beq     @ba71
        longa
        pla
        bra     AdjustShopPrice_01
@ba71:  longa
        pla
        bra     AdjustShopPrice_03

; ------------------------------------------------------------------------------

; -50% male, +50% female
AdjustShopPrice_05:
@ba76:  pha
        shorta
        lda     w0202
        cmp     #MAP_SPRITE_GFX::CELES
        beq     @ba8d
        cmp     #MAP_SPRITE_GFX::RELM
        beq     @ba8d
        cmp     #MAP_SPRITE_GFX::TERRA
        beq     @ba8d
        longa
        pla
        bra     AdjustShopPrice_03
@ba8d:  longa
        pla
        bra     AdjustShopPrice_01

; ------------------------------------------------------------------------------

; -50% edgar
AdjustShopPrice_06:
@ba92:  pha
        shorta
        lda     w0202
        cmp     #MAP_SPRITE_GFX::EDGAR
        beq     @baa0
        longa
        pla
        rts
@baa0:  longa
        pla
        bra     AdjustShopPrice_03

; ------------------------------------------------------------------------------

; [  ]

_c3baa5:
@baa5:  jsr     InitDMA1BG3ScreenA
        jsr     _c3b95a
        jsr     _c3c2e1
        longa
.if LANG_EN
        lda_pos BG3A, {3, 7}
.else
        lda_pos BG3A, {3, 6}
.endif
        sta     $7e9e89
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3baba:
@baba:  jsr     DrawBuyItemStat
        jsr     _c3bc84
        jsr     _c3bca8
        jsr     _c3bfc2
        jsr     LoadItemName
        jsr     DrawPosTextBuf
        lda     #$01
        sta     zSelIndex
        jmp     _c3bbae

; ------------------------------------------------------------------------------

; [  ]

_c3bad3:
@bad3:  jsr     _c3bc9d
        jsr     _c3bf66
        jsr     DrawSellItemStat
        jsr     _c3bfcb
        jsr     LoadItemName
        jsr     DrawPosTextBuf
        lda     #$01
        sta     zSelIndex
        jmp     _c3bbb7

; ------------------------------------------------------------------------------

; [ draw attack/defense stat for item to buy ]

DrawBuyItemStat:
@baec:  jsr     _c3bfc2
        jmp     DrawShopItemStat

; ------------------------------------------------------------------------------

; [ draw attack/defense stat for item to sell ]

DrawSellItemStat:
@baf2:  jsr     _c3bfcb
        jmp     DrawShopItemStat

; ------------------------------------------------------------------------------

; [ draw attack or defense of item in shop ]

DrawShopItemStat:
@baf8:  jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        beq     @bb52                   ; return if consumable item
        cmp     #$06
        beq     @bb52
        cmp     #$01
        beq     @bb30

; not weapon
        jsr     _c3c2f2
        lda     f:ItemProp+20,x
        jsr     HexToDec3
        ldx_pos BG3A, {16, 13}
        jsr     DrawNum3
        jsr     _c3c2f7
        ldy     #near ShopDefenseText
        jsr     DrawPosKana
        ldy     #near ShopDotsText
        jsr     DrawPosText
        jmp     _c3c2f2

; weapon
@bb30:  jsr     _c3c2f2
        lda     f:ItemProp+20,x
        jsr     HexToDec3
        ldx_pos BG3A, {16, 13}
        jsr     DrawNum3
        jsr     _c3c2f7
        ldy     #near ShopPowerText
        jsr     DrawPosKana
.if LANG_EN
        ldy     #near ShopDotsText
        jsr     DrawPosText
.endif
        jsr     _c3c2f2
@bb52:  rts

; ------------------------------------------------------------------------------

; [ calculate buy price ]

_c3bb53:
@bb53:  clr_a
        lda     $4b
        asl
        tax
        longa
        lda     $7e9f09,x
        sta     $f1
        shorta
        jmp     _c3bb81

; ------------------------------------------------------------------------------

; [ calculate sell price ]

_c3bb65:
@bb65:  jsr     _c3bfcb
        jsr     GetItemPropPtr
        longa
        lda     hMPYL
        clc
        adc     #$001c
        tax
        lda     f:ItemProp,x            ; item price / 2
        lsr
        sta     $f1
        shorta
        jmp     _c3bb81

; ------------------------------------------------------------------------------

; [ calculate total buy/sell price ]

; result goes to ++$f1

_c3bb81:
@bb81:  lda     $f1                     ; price per item
        sta     hWRMPYA
        lda     zSelIndex                     ; item qty
        sta     hWRMPYB
        stz     $ef
        nop2
        ldx     hRDMPYL
        stx     $ed
        lda     $f2
        sta     hWRMPYA
        lda     zSelIndex
        sta     hWRMPYB
        longa_clc
        lda     $ee
        adc     hRDMPYL
        sta     $f2
        shorta
        lda     $ed
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3bbae:
@bbae:  jsr     _c3bbc0
        jsr     _c3bb53
        jmp     _c3bbd7

; ------------------------------------------------------------------------------

; [  ]

_c3bbb7:
@bbb7:  jsr     _c3bbc0
        jsr     _c3bb65
        jmp     _c3bbd7

; ------------------------------------------------------------------------------

; [  ]

_c3bbc0:
@bbc0:  jsr     _c3c2f7
        ldy     #near ShopGilText2
        jsr     DrawPosKana
        jsr     _c3c2f2
        lda     zSelIndex
        jsr     HexToDec3
        ldx_pos BG3A, {17, 7}
        jmp     DrawNum2

; ------------------------------------------------------------------------------

; [  ]

_c3bbd7:
@bbd7:  jsr     HexToDec8
        ldx_pos BG3A, {12, 9}
        jmp     DrawNum7

; ------------------------------------------------------------------------------

; [  ]

_c3bbe0:
@bbe0:  lda     #$01
        sta     hBG1SC
.if LANG_EN
        lda     #$f5
.else
        lda     #$76
.endif
        sta     $5c
        lda     #$0a
        sta     $5a
.if LANG_EN
        lda     #$01
.else
        lda     #$02
.endif
        sta     $5b
        jsr     LoadItemListCursor
        ldy     $4d
        sty     $4f
        lda     $4a
        clc
        adc     $50
        sta     $50
        jsr     InitItemListCursor

_c3bc02:
@bc02:  jsr     InitItemListText
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$0070
.else
        lda     #$00ea
.endif
        sta     wTaskSpeedY,x
        lda     #$0058
        sta     wTaskSpeedX,x
        shorta
        rts

; ------------------------------------------------------------------------------

ShopSellTitleWindow:                    make_window BG2A, {1, 1}, {7, 2}
ShopSellMsgWindow:                      make_window BG2A, {10, 1}, {19, 2}
.if LANG_EN
ShopSellOptionsWindow:                  make_window BG2A, {1, 5}, {16, 2}
ShopSellGilWindow:                      make_window BG2A, {19, 5}, {10, 2}
.else
ShopSellOptionsWindow:                  make_window BG2A, {1, 5}, {12, 2}
ShopSellGilWindow:                      make_window BG2A, {15, 5}, {14, 2}
.endif
ShopSellListWindow:                     make_window BG2A, {1, 9}, {28, 16}

ShopBuyTitleWindow:                     make_window BG2B, {1, 1}, {7, 2}
ShopBuyMsgWindow:                       make_window BG2B, {10, 1}, {19, 2}
.if LANG_EN
ShopBuyListWindow:                      make_window BG2B, {1, 5}, {28, 12}
.else
ShopBuyListWindow1:                     make_window BG2B, {1, 5}, {17, 12}
ShopBuyListWindow2:                     make_window BG2B, {20, 5}, {9, 12}
.endif
ShopBuyCharWindow:                      make_window BG2B, {1, 19}, {28, 6}

ShopQtyTitleWindow:                     make_window BG2C, {1, 1}, {7, 2}
ShopQtyMsgWindow:                       make_window BG2C, {10, 1}, {19, 2}
ShopQtyItemWindow:                      make_window BG2C, {1, 5}, {17, 7}
ShopQtyDescWindow:                      make_window BG2C, {1, 14}, {28, 3}
ShopQtyCharWindow:                      make_window BG2C, {1, 19}, {28, 6}
ShopQtyGilWindow:                       make_window BG2C, {20, 5}, {9, 7}

; ------------------------------------------------------------------------------

; [  ]

_c3bc57:
@bc57:  ldx     #$9dc9
        stx     hWMADDL
        clr_ax
@bc5f:  phx
        ldy     z0
        lda     $7e9d89,x
@bc66:  cmp     $1869,y
        beq     @bc76
        iny
        cpy     #$0100
        bne     @bc66
        stz     hWMDATA
        bra     @bc7c
@bc76:  lda     $1969,y
        sta     hWMDATA
@bc7c:  plx
        inx
        cpx     #$0008
        bne     @bc5f
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3bc84:
@bc84:  jsr     _c3bc92
_bc87:  lda     z64
        jsr     HexToDec3
        ldx_pos BG3A, {27, 11}
        jmp     DrawNum2

; ------------------------------------------------------------------------------

; [  ]

_c3bc92:
@bc92:  clr_a
        lda     z4b
        tax
        lda     $7e9dc9,x
        sta     z64
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3bc9d:
@bc9d:  clr_a
        lda     z4b
        tay
        lda     $1969,y
        sta     z64
        bra     _bc87

; ------------------------------------------------------------------------------

; [  ]

_c3bca8:
@bca8:  jsr     _c3bfc2
        jmp     _c3bf69

; ------------------------------------------------------------------------------

; [ check item equip status ]

; A: result (out)
;      0: can't equip
;      1: already equipped
;      2: up arrow
;      3: down arrow
;      4: equals sign

_c3bcae:
@bcae:  jsr     _c3bcc9
        bcc     @bcc7       ; return 0 if not
        clr_a
        lda     z4b
        longa
        asl4
        shorta
        clc
        adc     ze0
        tax
        lda     $7eaa8d,x
        rts
@bcc7:  clr_a
        rts

; ------------------------------------------------------------------------------

; [ check if character can equip item ]

_c3bcc9:
@bcc9:  phb
        lda     #$00
        pha
        plb
        clr_a
        sta     $11d8
        clr_a
        lda     $e0
        tax
        lda     $7e9e09,x
        jsr     _c39c48
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        jsr     GetItemPropPtr
        ldx     hMPYL
        longa
        lda     f:ItemProp+1,x   ; equippable characters
        and     $e7
        shorta
        beq     @bcfa
        plb
        sec
        rts
@bcfa:  plb
        clc
        rts

; ------------------------------------------------------------------------------

; [ compare shop items to currently equipped items ]

_c3bcfd:
@bcfd:  jsr     _c3bf4f
        ldy     #$aa8d
        sty     $f3
        clr_ax
@bd07:  ldy     $f3
        sty     hWMADDL
        phx
        lda     $7e9d89,x
        sta     $9f
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x
        sta     $9e
        lda     f:ItemProp,x
        and     #$07
        cmp     #$01
        beq     @bda5
        cmp     #$02
        beq     @bd45
        cmp     #$03
        beq     @bd3f
        cmp     #$04
        beq     @bd42
        cmp     #$05
        jne     @bf0a
        jmp     @bf18
@bd3f:  jmp     @be35
@bd42:  jmp     @bebd

@bd45:  clr_ax
@bd47:  phx
        longa
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @bd87
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        shorta
        clr_a
        lda     $0022,y
        cmp     $9f
        beq     @bd7e
        cmp     #$ff
        beq     @bd76
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x
        cmp     $9e
        beq     @bd82
        bcs     @bd7a
@bd76:  lda     #$02
        bra     @bd84
@bd7a:  lda     #$03
        bra     @bd84
@bd7e:  lda     #$01
        bra     @bd84
@bd82:  lda     #$04
@bd84:  sta     hWMDATA
@bd87:  plx
        inx2
        cpx     #$0020
        bne     @bd47
@bd8f:  longa_clc
        lda     $f3
        adc     #$0010
        sta     $f3
        shorta
        plx
        inx
        cpx     #8
        bne     @bda2
        rts
@bda2:  jmp     @bd07

@bda5:  clr_ax
@bda7:  phx
        longa
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @be27
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        shorta
        lda     $001f,y
        cmp     $9f
        beq     @be1e
        lda     $0020,y
        cmp     $9f
        beq     @be1e
        clr_a
        lda     $001f,y
        cmp     #$ff
        beq     @bde0
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$01
        beq     @bdfe
@bde0:  clr_a
        lda     $0020,y
        cmp     #$ff
        beq     @be16
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$01
        bne     @bdfe
        clr_a
        lda     $0020,y
        bra     @be02
@bdfe:  clr_a
        lda     $001f,y
@be02:  cmp     #$ff
        beq     @be16
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x
        cmp     $9e
        beq     @be22
        bcs     @be1a
@be16:  lda     #$02
        bra     @be24
@be1a:  lda     #$03
        bra     @be24
@be1e:  lda     #$01
        bra     @be24
@be22:  lda     #$04
@be24:  sta     hWMDATA
@be27:  plx
        inx2
        cpx     #$0020
        jeq     @bd8f
        jmp     @bda7

@be35:  clr_ax
@be37:  phx
        longa
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @beaf
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        shorta
        lda     $001f,y
        cmp     $9f
        beq     @bea6
        lda     $0020,y
        cmp     $9f
        beq     @bea6
        clr_a
        lda     $0020,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$03
        beq     @be86
        clr_a
        lda     $001f,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$03
        bne     @be9e
        clr_a
        lda     $001f,y
        bra     @be8a
@be86:  clr_a
        lda     $0020,y
@be8a:  cmp     #$ff
        beq     @be9e
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x
        cmp     $9e
        beq     @beaa
        bcs     @bea2
@be9e:  lda     #$02
        bra     @beac
@bea2:  lda     #$03
        bra     @beac
@bea6:  lda     #$01
        bra     @beac
@beaa:  lda     #$04
@beac:  sta     hWMDATA
@beaf:  plx
        inx2
        cpx     #$0020
        jeq     @bd8f
        jmp     @be37

@bebd:  clr_ax
@bebf:  phx
        longa
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @beff
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        shorta
        clr_a
        lda     $0021,y
        cmp     $9f
        beq     @bef6
        cmp     #$ff
        beq     @beee
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x
        cmp     $9e
        beq     @befa
        bcs     @bef2
@beee:  lda     #$02
        bra     @befc
@bef2:  lda     #$03
        bra     @befc
@bef6:  lda     #$01
        bra     @befc
@befa:  lda     #$04
@befc:  sta     hWMDATA
@beff:  plx
        inx2
        cpx     #$0020
        bne     @bebf
        jmp     @bd8f

@bf0a:  clr_ax
@bf0c:  sta     hWMDATA
        inx
        cpx     #$0010
        bne     @bf0c
        jmp     @bd8f

@bf18:  clr_ax
@bf1a:  phx
        longa
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @bf44
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        shorta
        clr_a
        lda     $0023,y
        cmp     $9f
        beq     @bf3f
        lda     $0024,y
        cmp     $9f
        beq     @bf3f
        clr_a
        bra     @bf41
@bf3f:  lda     #$01
@bf41:  sta     hWMDATA
@bf44:  plx
        inx2
        cpx     #$0020
        bne     @bf1a
        jmp     @bd8f

; ------------------------------------------------------------------------------

; [  ]

_c3bf4f:
@bf4f:  phb
        lda     #$7e
        pha
        plb
        clr_ax
        longa
@bf58:  stz     $aa8d,x
        inx2
        cpx     #$0080
        bne     @bf58
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3bf66:
@bf66:  jsr     _c3bfcb

_c3bf69:
@bf69:  sta     $e0
        stz     $65
        ldx     #$161f
        stx     $e7
        lda     #$00
        sta     $e9
        ldx     z0
@bf78:  phx
        longa
        txa
        asl
        tax
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @bfa5
        lda     f:CharPropPtrs,x   ; pointers to character data
        tax
        shorta
        lda     a:0,x
        cmp     #CHAR_PROP::BANON
        bcs     @bfa5
        ldy     z0
@bf97:  lda     [$e7],y
        cmp     $e0
        bne     @bf9f
        inc     $65
@bf9f:  iny
        cpy     #6
        bne     @bf97
@bfa5:  longa_clc
        lda     #$0025
        adc     $e7
        sta     $e7
        shorta
        plx
        inx
        cpx     #$0010
        bne     @bf78
        lda     $65
        jsr     HexToDec3
        ldx_pos BG3A, {27, 15}
        jmp     DrawNum2

; ------------------------------------------------------------------------------

; [ get currently selected shop item ]

_c3bfc2:
@bfc2:  clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        rts

; ------------------------------------------------------------------------------

; [ get currently selected inventory item ]

_c3bfcb:
@bfcb:  clr_a
        lda     $4b
        tay
        lda     $1869,y
        rts

; ------------------------------------------------------------------------------

; [ draw shop type name ]

DrawShopTypeText:
@bfd3:  jsr     _c3c2f7
@bfd6:  lda     hHVBJOY
        and     #$40
        beq     @bfd6
        lda     w0201
        sta     hM7A
        stz     hM7A
        lda     #9
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        stx     zSelCharPropPtr
        lda     f:ShopProp,x            ; shop type
        and     #$07
        asl
        tax
        longa
        lda     f:ShopTypeTextTbl,x
        sta     $e7
        shorta
        lda     #^ShopTypeText_01
        sta     $e9
        jmp     DrawPosKanaFar

; ------------------------------------------------------------------------------

ShopTypeTextTbl:
@c00c:  .addr   0
        .addr   ShopTypeText_01
        .addr   ShopTypeText_02
        .addr   ShopTypeText_03
        .addr   ShopTypeText_04
        .addr   ShopTypeText_05

; ------------------------------------------------------------------------------

; [ init bg3 vertical scroll HDMA for shop menu ]

InitShopScrollHDMA:
@c018:  lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near ShopScrollHDMATbl
        sty     hDMA5::ADDR
        lda     #^ShopScrollHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^ShopScrollHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

ShopScrollHDMATbl:
        hdma_word 47, 4
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
        hdma_end

; ------------------------------------------------------------------------------

; [ load item name to text buffer ]

LoadItemName:
@c068:  pha
        ldx     #$9e8b
        stx     hWMADDL
@c06f:  lda     hHVBJOY
        and     #$40
        beq     @c06f
        pla
        sta     hM7A
        stz     hM7A
        lda     #ItemName::ITEM_SIZE
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #ItemName::ITEM_SIZE
@c08b:  lda     f:ItemName,x
        sta     hWMDATA
        inx
        dey
        bne     @c08b
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ init shop character sprites ]

InitShopCharSprites:
@c09a:  jsr     _c3c109
        jsr     _c3c1cc
        clr_ax

; start of character loop
@c0a2:  lda     $7e9e09,x
        bmi     @c0ec
        phx
        pha
        lda     #2
        ldy     #near ShopCharSpriteTask
        jsr     CreateTask
        txy
        clr_a
        pla
        sta     $7e35c9,x
        asl
        tax
        lda     #$7e
        pha
        plb
        longa
        lda     f:PartyCharAnimTbl,x
        sta     near wTaskAnimPtr,y
        shorta
        plx
        lda     f:ShopCharSpriteXTbl,x
        sta     near wTaskPosX,y
        lda     f:ShopCharSpriteYTbl,x
        sta     near wTaskPosY,y
        clr_a
        sta     near {wTaskPosX + 1},y
        sta     near {wTaskPosY + 1},y
        lda     #^PartyCharAnimTbl
        sta     near wTaskAnimBank,y
        lda     #$00
        pha
        plb
        inx
        bra     @c0a2
@c0ec:  rts

; ------------------------------------------------------------------------------

ShopCharSpriteXTbl:
@c0ed:  .byte   $18,$38,$58,$78,$98,$b8,$d8
        .byte   $18,$38,$58,$78,$98,$b8,$d8

ShopCharSpriteYTbl:
@c0fb:  .byte   $9c,$9c,$9c,$9c,$9c,$9c,$9c
        .byte   $b8,$b8,$b8,$b8,$b8,$b8,$b8

; ------------------------------------------------------------------------------

; [  ]

_c3c109:
@c109:  ldx     #$9e09
        stx     hWMADDL
        ldx     z0
@c111:  phx
        longa
        txa
        asl
        tax
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @c132
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        clr_a
        shorta
        lda     0,y
        cmp     #CHAR_PROP::BANON
        bcs     @c132
        sta     hWMDATA
@c132:  shorta
        plx
        inx
        cpx     #$0010
        bne     @c111
        lda     #$ff
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ shop character sprite task ]

ShopCharSpriteTask:
@c141:  tax
        jmp     (near ShopCharSpriteTaskTbl,x)

ShopCharSpriteTaskTbl:
@c145:  .addr   ShopCharSpriteTask_00
        .addr   ShopCharSpriteTask_01

; ------------------------------------------------------------------------------

; [ 0: init ]

ShopCharSpriteTask_00:
@c149:  lda     #$01
        tsb     $47
        ldx     zTaskOffset
        inc     near wTaskState,x
        longa
        lda     near wTaskAnimPtr,x
        sta     near wTaskSpeedX,x
        shorta
        jsr     InitAnimTask
        lda     $47
        and     #$08
        bne     @c168
        jsr     _c3c1f0
@c168:  bra     ShopCharSpriteTask_01

; ------------------------------------------------------------------------------

; [ 1: update ]

ShopCharSpriteTask_01:
@c16a:  lda     $47
        and     #$01
        beq     @c19a
        ldx     zTaskOffset
        lda     $47
        and     #$08
        bne     @c189
        jsr     _c3c19c
        bcc     @c189
        ldx     zTaskOffset
        longa_clc
        lda     near wTaskSpeedX,x
        adc     #9                      ; add 9 to sprite data pointer to get the jumping animation
        bra     @c190
@c189:  ldx     zTaskOffset
        longa
        lda     near wTaskSpeedX,x
@c190:  sta     near wTaskAnimPtr,x
        shorta
        jsr     UpdateAnimTask
        sec
        rts
@c19a:  clc
        rts

; ------------------------------------------------------------------------------

; [ check if character can equip item ]

_c3c19c:
@c19c:  phb
        lda     #$00
        pha
        plb
        clr_a
        sta     $11d8
        lda     $7e35c9,x
        jsr     _c39c48
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        jsr     GetItemPropPtr
        ldx     hMPYL
        longa
        lda     f:ItemProp+1,x
        and     $e7
        shorta
        beq     @c1c9
        plb
        sec
        rts
@c1c9:  plb
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3c1cc:
@c1cc:  ldx     #$9e01
        stx     hWMADDL
        ldx     z0
@c1d4:  longa
        lda     a:zCharPropPtr,x
        shorta
        beq     @c1e3
        tay
        lda     0,y
        bra     @c1e5
@c1e3:  lda     #$ff
@c1e5:  sta     hWMDATA
        inx2
        cpx     #$0008
        bne     @c1d4
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3c1f0:
@c1f0:  ldy     z0
        ldx     zTaskOffset
@c1f4:  lda     $35c9,x
        cmp     $9e01,y
        bne     @c234
        phx
        phy
        lda     #$00
        pha
        plb
        lda     #0
        ldy     #near CharIconTask
        jsr     CreateTask
        lda     #$7e
        pha
        plb
        clr_a
        sta     $35c9,x
        ldy     $374a,x
        longa
        lda     near wTaskPosX,y
        sta     near wTaskPosX,x
        lda     near wTaskPosY,y
        dec2
        sta     near wTaskPosY,x
        lda     #near PartyArrowAnim
        sta     near wTaskAnimPtr,x
        shorta
        lda     #^PartyArrowAnim
        sta     near wTaskAnimBank,x
        ply
        plx
@c234:  iny
        cpy     #4
        bne     @c1f4
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3c23b:
@c23b:  clr_ay
@c23d:  phy
        lda     #4
        ldy     #near ShopCharIconTask
        jsr     CreateTask
        ply
        tya
        sta     $7e35c9,x
        iny
        cpy     #$000e
        bne     @c23d
        rts

; ------------------------------------------------------------------------------

; [ shop character icon thread (e/+/-/=) ]

ShopCharIconTask:
@c253:  tax
        jmp     (near ShopCharIconTaskTbl,x)

ShopCharIconTaskTbl:
@c257:  .addr   ShopCharIconTask_00
        .addr   ShopCharIconTask_01

; ------------------------------------------------------------------------------

; [  ]

ShopCharIconTask_00:
@c25a:  ldx     zTaskOffset
        longa
        lda     #near ShopEquipIconAnim
        sta     near wTaskAnimPtr,x
        sta     near wTaskSpeedX,x
        shorta
        inc     near wTaskState,x
        lda     #^ShopEquipIconAnim
        sta     near wTaskAnimBank,x
        clr_a
        lda     $35c9,x
        txy
        tax
        lda     f:ShopCharXTbl,x
        sta     near wTaskPosX,y                 ; x position (character icon)
        lda     f:ShopCharYTbl,x
        sta     near wTaskPosY,y                 ; y position
        ldx     zTaskOffset
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

ShopCharIconTask_01:
@c28b:  lda     $47
        and     #$01
        beq     @c2df
        ldx     zTaskOffset
        clr_a
        lda     $35c9,x
        sta     $e0
        jsr     _c3bcae
        beq     @c2dd       ; branch if this character can't equip this item
        cmp     #$01
        beq     @c2b6
        cmp     #$02
        beq     @c2cb
        cmp     #$04
        beq     @c2bf

; down arrow
        ldx     zTaskOffset
        longa_clc
        lda     near wTaskSpeedX,x
        adc     #ShopEquipIconAnim3 - ShopEquipIconAnim
        bra     @c2d5

; already equipped
@c2b6:  ldx     zTaskOffset
        longa
        lda     near wTaskSpeedX,x
        bra     @c2d5

; equals sign
@c2bf:  ldx     zTaskOffset
        longa_clc
        lda     near wTaskSpeedX,x
        adc     #ShopEquipIconAnim4 - ShopEquipIconAnim
        bra     @c2d5

; up arrow
@c2cb:  ldx     zTaskOffset
        longa_clc
        lda     near wTaskSpeedX,x
        adc     #ShopEquipIconAnim2 - ShopEquipIconAnim
@c2d5:  sta     near wTaskAnimPtr,x
        shorta
        jsr     UpdateAnimTask
@c2dd:  sec
        rts
@c2df:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3c2e1:
@c2e1:  jsr     _c3c2f7
        ldy     #near ShopOwnedText
        jsr     DrawPosKana
        ldy     #near ShopEquippedText
        jsr     DrawPosKana
        bra     _c3c2f2

; ------------------------------------------------------------------------------

; [ use default text color ]

_c3c2f2:
@c2f2:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        rts

; ------------------------------------------------------------------------------

; [ use teal text color ]

_c3c2f7:
@c2f7:  lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        rts

; ------------------------------------------------------------------------------

ShopTypeText_01:                pos_text SHOP_TYPE_1
ShopTypeText_02:                pos_text SHOP_TYPE_2
ShopTypeText_03:                pos_text SHOP_TYPE_3
ShopTypeText_04:                pos_text SHOP_TYPE_4
ShopTypeText_05:                pos_text SHOP_TYPE_5
ShopOptionsText:                pos_text SHOP_OPTIONS
ShopGilText1:                   pos_text SHOP_GIL_1
ShopGilText2:                   pos_text SHOP_GIL_2
ShopOwnedText:                  pos_text SHOP_OWNED
ShopEquippedText:               pos_text SHOP_EQUIPPED
ShopPowerText:                  pos_text SHOP_POWER
ShopDefenseText:                pos_text SHOP_DEFENSE
ShopDotsText:                   pos_text SHOP_DOTS
ShopGreetingMsgText:            pos_text SHOP_GREETING_MSG
ShopBuyMsgText:                 pos_text SHOP_BUY_MSG
ShopBuyQtyMsgText:              pos_text SHOP_BUY_QTY_MSG
ShopSellMsgText:                pos_text SHOP_SELL_MSG
ShopSellQtyMsgText:             pos_text SHOP_SELL_QTY_MSG
ShopByeMsgText:                 pos_text SHOP_BYE_MSG
ShopNotEnoughGilMsgText:        pos_text SHOP_NOT_ENOUGH_GIL_MSG
ShopTooManyMsgText:             pos_text SHOP_TOO_MANY_MSG
ShopOnlyOneMsgText:             pos_text SHOP_ONLY_ONE_MSG

; ------------------------------------------------------------------------------

.pushseg
.segment "shop_prop"

; c4/7ac0
ShopProp:
        .incbin "shop_prop.dat"

.popseg

; ------------------------------------------------------------------------------
