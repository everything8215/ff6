
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
        jsr     DisableWindow1PosHDMA
        lda     #$03
        sta     hBG1SC
        lda     #$c0
        trb     $43
        lda     #$02
        sta     $46
        stz     $4a
        jsr     LoadShopOptionCursor
        jsr     InitShopOptionCursor
        jsr     CreateCursorTask
        jsr     DrawShopMenu
        jsr     InitItemBGScrollHDMA
        jsr     InitShopScrollHDMA
        lda     #$25
        sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $25: shop options (buy, sell, exit) ]

MenuState_25:
@b49b:  jsr     UpdateShopOptionCursor
        lda     $08
        bit     #$80
        beq     @b4aa
        jsr     PlaySelectSfx
        jmp     _c3b792
@b4aa:  lda     $09
        bit     #$80
        beq     _b4bc
        jsr     PlayCancelSfx

_c3b4b3:
@b4b3:  stz     $0205
        lda     #$ff
        sta     $27
        stz     $26
_b4bc:  rts

; ------------------------------------------------------------------------------

; [ menu state $26: buy (item select) ]

MenuState_26:
@b4bd:  lda     #$10
        tsb     $45
        jsr     InitDMA1BG3ScreenA
        jsr     UpdateShopBuyMenuCursor
        jsr     _c3bc84
        jsr     _c3bca8
        lda     $09
        bit     #$80
        beq     @b4d9
        jsr     PlayCancelSfx
        jmp     _c3b760
@b4d9:  lda     $08
        bit     #$80
        beq     @b4e5
        jsr     _c3b82f
        jsr     _c3b7e6
@b4e5:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b4e6:
@b4e6:  lda     #$10
        trb     $45
        lda     #$20
        tsb     $45
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
        lda     $0b
        bit     #$01
        beq     @b539
        jsr     PlayMoveSfx
        lda     $28
        cmp     $6a
        beq     @b57c
        inc     $28
        jsr     _c3bb53
        lda     $1860
        cmp     $f1
        lda     $1861
        sbc     $f2
        lda     $1862
        sbc     $f3
        bcs     @b538
        dec     $28
@b538:  rts
@b539:  lda     $0b
        bit     #$02
        beq     @b54a
        jsr     PlayMoveSfx
        lda     $28
        cmp     #$01
        beq     @b59e
        dec     $28
@b54a:  lda     $0b
        bit     #$08
        beq     @b583
        jsr     PlayMoveSfx
        lda     #$0a
        clc
        adc     $28
        cmp     $6a
        beq     @b55e
        bcs     @b57f
@b55e:  sta     $28
        jsr     _c3bb53
        lda     $1860
        cmp     $f1
        lda     $1861
        sbc     $f2
        lda     $1862
        sbc     $f3
        bcs     @b57b
        lda     $28
        sec
        sbc     #$0a
        sta     $28
@b57b:  rts
@b57c:  jmp     @b59e
@b57f:  lda     $28
        bra     @b55e
@b583:  lda     $0b
        bit     #$04
        beq     @b59e
        jsr     PlayMoveSfx
        lda     $28
        sec
        sbc     #$0a
        bmi     @b59a
        cmp     #$01
        bcc     @b59e
        sta     $28
        rts
@b59a:  lda     #$01
        sta     $28
@b59e:  lda     $09
        bit     #$80
        beq     @b5aa
        jsr     PlayCancelSfx
        jmp     _c3b7b3
@b5aa:  lda     $08
        bit     #$80
        beq     @b5b6
        jsr     PlayShopSfx
        jsr     _c3b5b7
@b5b6:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b5b7:
@b5b7:  jsr     _c3bfc2
        ldy     $00
@b5bc:  cmp     $1869,y
        beq     @b5e1
        iny
        cpy     #$0100
        bne     @b5bc
        ldy     $00
@b5c9:  lda     $1869,y
        cmp     #$ff
        beq     @b5d3
        iny
        bra     @b5c9
@b5d3:  lda     $28
        sta     $1969,y
        lda     $7e9d89,x
        sta     $1869,y
        bra     @b5ea
@b5e1:  lda     $28
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
        ldy     #.loword(ShopByeMsgText)
        jsr     DrawPosText
        jmp     _c3b87d

; ------------------------------------------------------------------------------

; [ menu state $28: buy (return to state item select) ]

MenuState_28:
@b60e:  lda     $20
        bne     @b615
        jsr     _c3b7b3
@b615:  rts

; ------------------------------------------------------------------------------

; [ menu state $29: sell (item select) ]

MenuState_29:
@b616:  lda     #$10
        tsb     $45
        clr_a
        sta     $2a
        jsr     InitDMA1BG1ScreenA
        jsr     ScrollListPage
        bcs     @b675
        jsr     UpdateItemListCursor
        lda     $09
        bit     #$80
        beq     @b634       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        jmp     _c3b760
@b634:  lda     $08
        bit     #$80
        beq     @b675       ; return if a button is not pressed
        jsr     _c3bfcb
        cmp     #$ff
        beq     @b66f       ; branch if no item
        jsr     PlaySelectSfx
        lda     #$c0
        trb     $46
        jsr     ClearBG1ScreenA
        jsr     InitDMA1BG1ScreenA
        jsr     WaitVblank
        lda     #$2a
        sta     $26
        ldx     #$0008
        stx     $55
        ldx     #$0034
        stx     $57
        jsr     _c3baa5
        jsr     _c3bad3
        ldy     #.loword(ShopSellQtyMsgText)
        jsr     DrawPosText
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
        lda     $0b
        bit     #$01
        beq     @b695
        jsr     PlayMoveSfx
        lda     $28
        cmp     $64
        beq     @b6e0
        inc     $28
        bra     @b6e0
@b695:  lda     $0b
        bit     #$02
        beq     @b6a6
        jsr     PlayMoveSfx
        lda     $28
        cmp     #$01
        beq     @b6e0
        dec     $28
@b6a6:  lda     $0b
        bit     #$08
        beq     @b6c4
        jsr     PlayMoveSfx
        lda     #$0a
        clc
        adc     $28
        cmp     $64
        beq     @b6be
        bcs     @b6be
        sta     $28
        bra     @b6e0
@b6be:  lda     $64
        sta     $28
        bra     @b6e0
@b6c4:  lda     $0b
        bit     #$04
        beq     @b6e0
        jsr     PlayMoveSfx
        lda     $28
        sec
        sbc     #$0a
        bmi     @b6dc
        cmp     #$01
        bcc     @b6e0
        sta     $28
        bra     @b6e0
@b6dc:  lda     #$01
        sta     $28
@b6e0:  lda     $09
        bit     #$80
        beq     @b6fb
        jsr     PlayCancelSfx
        ldx     $00
        stx     $39
        stx     $3b
        jsr     _c3b95a
        ldy     #.loword(ShopOptionsText)
        jsr     DrawPosText
        jmp     _c3b7cf
@b6fb:  lda     $08
        bit     #$80
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
        cmp     $28
        beq     @b734
        jsr     _c3bfcb
        lda     $1969,y
        sec
        sbc     $28
        sta     $1969,y
        bra     @b740
@b734:  jsr     _c3bfcb
        lda     #$ff
        sta     $1869,y
        clr_a
        sta     $1969,y
@b740:  jsr     ValidateMaxGil
        ldy     #.loword(ShopByeMsgText)
        jsr     DrawPosText
        lda     #$2b
        sta     $26
        lda     #$20
        sta     $20
        rts

; ------------------------------------------------------------------------------

; [ menu state $2b: sell (thank you) ]

MenuState_2b:
@b752:  lda     $20
        bne     @b75f
        ldx     $00
        stx     $39
        stx     $3b
        jsr     _c3b7cf
@b75f:  rts

; ------------------------------------------------------------------------------

; [ reload menu state $25 ]

_c3b760:
@b760:  lda     #$c0
        trb     $46
        stz     $47
        jsr     LoadShopOptionCursor
        jsr     InitShopOptionCursor
        jsr     InitDMA1BG1ScreenA
        jsr     _c3b94e
        jsr     WaitVblank
        jsr     InitDMA1BG3ScreenA
        jsr     _c3b95a
        ldy     #.loword(ShopOptionsText)
        jsr     DrawPosText
        ldy     #.loword(ShopGreetingMsgText)
        jsr     DrawPosText
        ldy     $00
        sty     $39
        sty     $3b
        lda     #$25
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ select shop option (buy, sell, exit) ]

SelectShopOption:
_c3b792:
@b792:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectShopOptionTbl),x)

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
        sty     $39         ; bg2 h-scroll
        ldy     $00
        sty     $3b         ; bg2 v-scroll
        jsr     _c3b986
        jsr     _c3bcfd
        lda     #$26
        sta     $26
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
        ldy     #.loword(ShopOptionsText)
        jsr     DrawPosText
        ldy     #.loword(ShopSellMsgText)
        jsr     DrawPosText
        lda     #$29
        sta     $26
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
        ldy     #.loword(ShopOnlyOneMsgText)
        jsr     DrawPosText
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
        ldy     #.loword(ShopNotEnoughGilMsgText)
        jsr     DrawPosText
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
        ldy     #.loword(ShopTooManyMsgText)
        jsr     DrawPosText
        jmp     _c3b87d
@b850:  jsr     PlaySelectSfx
        ldx     #$0008
        stx     $55
        ldx     #$0034
        stx     $57
        lda     #$27        ; go to menu state $27
        sta     $26
        jsr     _c3baa5
        jsr     _c3baba
        ldy     #.loword(ShopBuyQtyMsgText)
        jsr     DrawPosText

_c3b86d:
@b86d:  ldy     #$0100
        sty     $3b
        ldy     $00
        sty     $39
        jsr     ClearBigTextBuf
        jsr     _c3a6f4
        rts

; ------------------------------------------------------------------------------

_c3b87d:
@b87d:  lda     #$28
        sta     $26
        lda     #$20
        sta     $20
        rts

; ------------------------------------------------------------------------------

; [ init cursor for shop options menu ]

LoadShopOptionCursor:
@b886:  ldy     #.loword(ShopOptionCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for menu state $25 ]

UpdateShopOptionCursor:
@b88c:  jsr     MoveCursor

InitShopOptionCursor:
@b88f:  ldy     #.loword(ShopOptionCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; cursor properties for menu state $25
ShopOptionCursorProp:
@b895:  .byte   $01,$00,$00,$03,$01

; cursor positions for menu state $25
ShopOptionCursorPos:
@b89a:  .byte   $08,$34
        .byte   $30,$34
        .byte   $60,$34

; ------------------------------------------------------------------------------

; [ init cursor for shop buy menu ]

LoadShopBuyMenuCursor:
@b8a0:  ldy     #.loword(ShopBuyMenuCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for shop buy menu ]

UpdateShopBuyMenuCursor:
@b8a6:  jsr     MoveCursor

InitShopBuyMenuCursor:
@b8a9:  ldy     #.loword(ShopBuyMenuCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; cursor properties for menu state $26
ShopBuyMenuCursorProp:
@b8af:  .byte   $80,$00,$00,$01,$08

; cursor positions for menu state $26
ShopBuyMenuCursorPos:
@b8b4:  .byte   $00,$34
        .byte   $00,$40
        .byte   $00,$4c
        .byte   $00,$58
        .byte   $00,$64
        .byte   $00,$70
        .byte   $00,$7c
        .byte   $00,$88

; ------------------------------------------------------------------------------

; [ draw shop menu ]

DrawShopMenu:
@b8c4:  jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        jsr     ClearBG2ScreenC
        ldy     #.loword(ShopSellTitleWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopSellMsgWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopSellOptionsWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopSellGilWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopSellListWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopBuyTitleWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopBuyMsgWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopBuyCharWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopBuyListWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopQtyTitleWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopQtyGilWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopQtyDescWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopQtyMsgWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopQtyCharWindow)
        jsr     DrawWindow
        ldy     #.loword(ShopQtyItemWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     TfrBG2ScreenCD
        jsr     _c3b94e
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenCD
        jsr     _c3b95a
        ldy     #.loword(ShopOptionsText)
        jsr     DrawPosText
        ldy     #.loword(ShopGreetingMsgText)
        jsr     DrawPosText
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
        ldy     #.loword(ShopGilText1)
        jsr     DrawPosText
        jsr     _c3c2f2
        ldy     $1860
        sty     $f1
        lda     $1862
        sta     $f3
        jsr     HexToDec8
        ldx     #$7a33
        jsr     DrawNum7
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b986:
@b986:  jsr     _c3b95a
        ldy     #.loword(ShopBuyMsgText)
        jsr     DrawPosText
        jsr     _c3c2e1
        ldy     $00
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
        adc     $67
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
        adc     #$001a
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
@b9fc:  .word   $7a0d,$7a8d,$7b0d,$7b8d,$7c0d,$7c8d,$7d0d,$7d8d

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
        ldx     $67
        clr_a
        shorta
        lda     f:ShopProp,x            ; shop price adjustment
        and     #$38
        longa
        lsr2
        tax
        pla
        jmp     (.loword(AdjustShopPriceTbl),x)

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
        lda     $0202
        cmp     #$06
        beq     @ba71
        cmp     #$08
        beq     @ba71
        cmp     #$00
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
        lda     $0202
        cmp     #CHAR::CELES
        beq     @ba8d
        cmp     #CHAR::RELM
        beq     @ba8d
        cmp     #CHAR::TERRA
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
        lda     $0202
        cmp     #$04
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
        lda     #$7a0f
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
        sta     $28
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
        sta     $28
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
        ldx     #$7ba9
        jsr     DrawNum3
        jsr     _c3c2f7
        ldy     #.loword(ShopDefenseText)
        jsr     DrawPosText
        ldy     #.loword(ShopDotsText)
        jsr     DrawPosText
        jmp     _c3c2f2

; weapon
@bb30:  jsr     _c3c2f2
        lda     f:ItemProp+20,x
        jsr     HexToDec3
        ldx     #$7ba9
        jsr     DrawNum3
        jsr     _c3c2f7
        ldy     #.loword(ShopPowerText)
        jsr     DrawPosText
        ldy     #.loword(ShopDotsText)
        jsr     DrawPosText
        jsr     _c3c2f2
@bb52:  rts

; ------------------------------------------------------------------------------

; [  ]

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

; [  ]

_c3bb65:
@bb65:  jsr     _c3bfcb
        jsr     GetItemPropPtr
        longa
        lda     hMPYL
        clc
        adc     #$001c
        tax
        lda     f:ItemProp,x
        lsr
        sta     $f1
        shorta
        jmp     _c3bb81

; ------------------------------------------------------------------------------

; [  ]

_c3bb81:
@bb81:  lda     $f1
        sta     hWRMPYA
        lda     $28
        sta     hWRMPYB
        stz     $ef
        nop2
        ldx     hRDMPYL
        stx     $ed
        lda     $f2
        sta     hWRMPYA
        lda     $28
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
        ldy     #.loword(ShopGilText2)
        jsr     DrawPosText
        jsr     _c3c2f2
        lda     $28
        jsr     HexToDec3
        ldx     #$7a2b
        jmp     DrawNum2

; ------------------------------------------------------------------------------

; [  ]

_c3bbd7:
@bbd7:  jsr     HexToDec8
        ldx     #$7aa1
        jmp     DrawNum7

; ------------------------------------------------------------------------------

; [  ]

_c3bbe0:
@bbe0:  lda     #$01
        sta     hBG1SC
        lda     #$f5
        sta     $5c
        lda     #$0a
        sta     $5a
        lda     #$01
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
        lda     #$0070
        sta     $7e354a,x
        lda     #$0058
        sta     $7e34ca,x
        shorta
        rts

; ------------------------------------------------------------------------------

ShopSellTitleWindow:
@bc1b:  .byte   $8b,$58,$07,$02

ShopSellMsgWindow:
@bc1f:  .byte   $9d,$58,$13,$02

ShopSellOptionsWindow:
@bc23:  .byte   $8b,$59,$10,$02

ShopSellGilWindow:
@bc27:  .byte   $af,$59,$0a,$02

ShopSellListWindow:
@bc2b:  .byte   $8b,$5a,$1c,$10

ShopBuyTitleWindow:
@bc2f:  .byte   $8b,$60,$07,$02

ShopBuyMsgWindow:
@bc33:  .byte   $9d,$60,$13,$02

ShopBuyListWindow:
@bc37:  .byte   $8b,$61,$1c,$0c

ShopBuyCharWindow:
@bc3b:  .byte   $0b,$65,$1c,$06

ShopQtyTitleWindow:
@bc3f:  .byte   $8b,$68,$07,$02

ShopQtyMsgWindow:
@bc43:  .byte   $9d,$68,$13,$02

ShopQtyItemWindow:
@bc47:  .byte   $8b,$69,$11,$07

ShopQtyDescWindow:
@bc4b:  .byte   $cb,$6b,$1c,$03

ShopQtyCharWindow:
@bc4f:  .byte   $0b,$6d,$1c,$06

ShopQtyGilWindow:
@bc53:  .byte   $b1,$69,$09,$07

; ------------------------------------------------------------------------------

; [  ]

_c3bc57:
@bc57:  ldx     #$9dc9
        stx     hWMADDL
        clr_ax
@bc5f:  phx
        ldy     $00
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
_bc87:  lda     $64
        jsr     HexToDec3
        ldx     #$7b3f
        jmp     DrawNum2

; ------------------------------------------------------------------------------

; [  ]

_c3bc92:
@bc92:  clr_a
        lda     $4b
        tax
        lda     $7e9dc9,x
        sta     $64
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3bc9d:
@bc9d:  clr_a
        lda     $4b
        tay
        lda     $1969,y
        sta     $64
        bra     _bc87

; ------------------------------------------------------------------------------

; [  ]

_c3bca8:
@bca8:  jsr     _c3bfc2
        jmp     _c3bf69

; ------------------------------------------------------------------------------

; [ check item equip status ]

; a (out): 0 = can't equip, 1 = already equipped, 2 = up arrow, 3 = down arrow, 4 = equals sign

_c3bcae:
@bcae:  jsr     _c3bcc9
        bcc     @bcc7       ; return 0 if not
        clr_a
        lda     $4b
        longa
        asl4
        shorta
        clc
        adc     $e0
        tax
        lda     $7eaa8d,x
        rts
@bcc7:  clr_a
        rts

; ------------------------------------------------------------------------------

; [  ]

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

; [  ]

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
        ldx     $00
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
        lda     a:$0000,x
        cmp     #$0e
        bcs     @bfa5
        ldy     $00
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
        ldx     #$7c3f
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
        lda     $0201
        sta     hM7A
        stz     hM7A
        lda     #9
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        stx     $67
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
        jmp     DrawPosTextFar

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
        sta     $4350
        lda     #<hBG3VOFS
        sta     $4351
        ldy     #.loword(ShopScrollHDMATbl)
        sty     $4352
        lda     #^ShopScrollHDMATbl
        sta     $4354
        lda     #^ShopScrollHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

ShopScrollHDMATbl:
@c037:  .byte   $2f,$04,$00
        .byte   $0c,$04,$00
        .byte   $0c,$08,$00
        .byte   $0c,$0c,$00
        .byte   $0c,$10,$00
        .byte   $0c,$14,$00
        .byte   $0c,$18,$00
        .byte   $0c,$1c,$00
        .byte   $0c,$20,$00
        .byte   $0c,$24,$00
        .byte   $0c,$28,$00
        .byte   $0c,$2c,$00
        .byte   $0c,$30,$00
        .byte   $0c,$34,$00
        .byte   $0c,$38,$00
        .byte   $0c,$3c,$00
        .byte   $00

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
        lda     #ITEM_NAME_SIZE
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #ITEM_NAME_SIZE
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
        ldy     #.loword(ShopCharSpriteTask)
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
        sta     $32c9,y
        shorta
        plx
        lda     f:ShopCharSpriteXTbl,x
        sta     $33ca,y
        lda     f:ShopCharSpriteYTbl,x
        sta     $344a,y
        clr_a
        sta     $33cb,y
        sta     $344b,y
        lda     #^PartyCharAnimTbl
        sta     $35ca,y
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
        ldx     $00
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
        lda     $0000,y
        cmp     #$0e
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
        jmp     (.loword(ShopCharSpriteTaskTbl),x)

ShopCharSpriteTaskTbl:
@c145:  .addr   ShopCharSpriteTask_00
        .addr   ShopCharSpriteTask_01

; ------------------------------------------------------------------------------

; [ 0: init ]

ShopCharSpriteTask_00:
@c149:  lda     #$01
        tsb     $47
        ldx     $2d
        inc     $3649,x
        longa
        lda     $32c9,x     ; sprite data pointer
        sta     $34ca,x
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
        ldx     $2d
        lda     $47
        and     #$08
        bne     @c189
        jsr     _c3c19c
        bcc     @c189
        ldx     $2d
        longa_clc
        lda     $34ca,x
        adc     #9                      ; add 9 to sprite data pointer to get the jumping animation
        bra     @c190
@c189:  ldx     $2d
        longa
        lda     $34ca,x
@c190:  sta     $32c9,x
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
        ldx     $00
@c1d4:  longa
        lda     a:$006d,x
        shorta
        beq     @c1e3
        tay
        lda     $0000,y
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
@c1f0:  ldy     $00
        ldx     $2d
@c1f4:  lda     $35c9,x
        cmp     $9e01,y
        bne     @c234
        phx
        phy
        lda     #$00
        pha
        plb
        lda     #0
        ldy     #.loword(CharIconTask)
        jsr     CreateTask
        lda     #$7e
        pha
        plb
        clr_a
        sta     $35c9,x
        ldy     $374a,x
        longa
        lda     $33ca,y
        sta     $33ca,x
        lda     $344a,y
        dec2
        sta     $344a,x
        lda     #.loword(PartyArrowAnim)
        sta     $32c9,x
        shorta
        lda     #^PartyArrowAnim
        sta     $35ca,x
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
        ldy     #.loword(ShopCharIconTask)
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
        jmp     (.loword(ShopCharIconTaskTbl),x)

ShopCharIconTaskTbl:
@c257:  .addr   ShopCharIconTask_00
        .addr   ShopCharIconTask_01

; ------------------------------------------------------------------------------

; [  ]

ShopCharIconTask_00:
@c25a:  ldx     $2d
        longa
        lda     #.loword(ShopEquipIconAnim)
        sta     $32c9,x
        sta     $34ca,x
        shorta
        inc     $3649,x
        lda     #^ShopEquipIconAnim
        sta     $35ca,x
        clr_a
        lda     $35c9,x
        txy
        tax
        lda     f:ShopCharXTbl,x
        sta     $33ca,y                 ; x position (character icon)
        lda     f:ShopCharYTbl,x
        sta     $344a,y                 ; y position
        ldx     $2d
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

ShopCharIconTask_01:
@c28b:  lda     $47
        and     #$01
        beq     @c2df
        ldx     $2d
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
        ldx     $2d
        longa_clc
        lda     $34ca,x
        adc     #ShopEquipIconAnim3 - ShopEquipIconAnim
        bra     @c2d5

; already equipped
@c2b6:  ldx     $2d
        longa
        lda     $34ca,x
        bra     @c2d5

; equals sign
@c2bf:  ldx     $2d
        longa_clc
        lda     $34ca,x
        adc     #ShopEquipIconAnim4 - ShopEquipIconAnim
        bra     @c2d5

; up arrow
@c2cb:  ldx     $2d
        longa_clc
        lda     $34ca,x
        adc     #ShopEquipIconAnim2 - ShopEquipIconAnim
@c2d5:  sta     $32c9,x
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
        ldy     #.loword(ShopOwnedText)
        jsr     DrawPosText
        ldy     #.loword(ShopEquippedText)
        jsr     DrawPosText
        bra     _c3c2f2

; ------------------------------------------------------------------------------

; [  ]

_c3c2f2:
@c2f2:  lda     #$20
        sta     $29
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3c2f7:
@c2f7:  lda     #$2c
        sta     $29
        rts

; ------------------------------------------------------------------------------

; c3/c2fc: ( 2, 3) "weapon"
ShopTypeText_01:
@c2fc:  .word   $790d
        .byte   $96,$9e,$9a,$a9,$a8,$a7,$00

; c3/c305: ( 3, 3) "armor"
ShopTypeText_02:
@c305:  .word   $790f
        .byte   $80,$ab,$a6,$a8,$ab,$00

; c3/c30d: ( 3, 3) "item"
ShopTypeText_03:
@c30d:  .word   $790f
        .byte   $88,$ad,$9e,$a6,$00

; c3/c314: ( 2, 3) "relics"
ShopTypeText_04:
@c314:  .word   $790d
        .byte   $91,$9e,$a5,$a2,$9c,$ac,$00

; c3/c31d: ( 2, 3) "vendor"
ShopTypeText_05:
@c31d:  .word   $790d
        .byte   $95,$9e,$a7,$9d,$a8,$ab,$00

; c3/c326: ( 3, 7) "buy  sell  exit"
ShopOptionsText:
@c326:  .word   $7a0f
        .byte   $81,$94,$98,$ff,$ff,$92,$84,$8b,$8b,$ff,$ff,$84,$97,$88,$93,$00

; c3/c338: (28, 7) "gp"
ShopGilText1:
@c338:  .word   $7a41
        .byte   $86,$8f,$00

; c3/c33d: (17,11) "gp"
ShopGilText2:
@c33d:  .word   $7b2b
        .byte   $86,$8f,$00

; c3/c342: (21, 9) "owned:"
ShopOwnedText:
@c342:  .word   $7ab3
        .byte   $8e,$b0,$a7,$9e,$9d,$c1,$00

; c3/c34b: (21,13) "equipped:"
ShopEquippedText:
@c34b:  .word   $7bb3
        .byte   $84,$aa,$ae,$a2,$a9,$a9,$9e,$9d,$c1,$00

; c3/c357: ( 3,13) "bat pwr"
ShopPowerText:
@c357:  .word   $7b8f
        .byte   $81,$9a,$ad,$ff,$8f,$b0,$ab,$00

; c3/c361: ( 3,13) "defense"
ShopDefenseText:
@c361:  .word   $7b8f
        .byte   $83,$9e,$9f,$9e,$a7,$ac,$9e,$00

; c3/c36b: (14,13) "_"
ShopDotsText:
@c36b:  .word   $7ba5
        .byte   $c7,$00

; c3/c36f: (11, 3) "hi! can i help you?"
ShopGreetingMsgText:
@c36f:  .word   $791f
        .byte   $87,$a2,$be,$ff,$82,$9a,$a7,$ff,$88,$ff,$a1,$9e,$a5,$a9,$ff,$b2,$a8,$ae,$bf,$00

; c3/c385: (11, 3) "help youself!"
ShopBuyMsgText:
@c385:  .word   $791f
        .byte   $87,$9e,$a5,$a9,$ff,$b2,$a8,$ae,$ab,$ac,$9e,$a5,$9f,$be,$00

; c3/c396: (11, 3) "how many?"
ShopBuyQtyMsgText:
@c396:  .word   $791f
        .byte   $87,$a8,$b0,$ff,$a6,$9a,$a7,$b2,$bf,$00

; c3/c3a2: (11, 3) "whatcha got?"
ShopSellMsgText:
@c3a2:  .word   $791f
        .byte   $96,$a1,$9a,$ad,$9c,$a1,$9a,$ff,$a0,$a8,$ad,$bf,$00

; c3/c3b1: (11, 3) "how many?"
ShopSellQtyMsgText:
@c3b1:  .word   $791f
        .byte   $87,$a8,$b0,$ff,$a6,$9a,$a7,$b2,$bf,$00

; c3/c3bd: (11, 3) "bye!          "
ShopByeMsgText:
@c3bd:  .word   $791f
        .byte   $81,$b2,$9e,$be,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

; c3/c3ce: (11, 3) "you need more gp!"
ShopNotEnoughGilMsgText:
@c3ce:  .word   $791f
        .byte   $98,$a8,$ae,$ff,$a7,$9e,$9e,$9d,$ff,$a6,$a8,$ab,$9e,$ff,$86,$8f,$be,$00

; c3/c3e2: (11, 3) "too many!       "
ShopTooManyMsgText:
@c3e2:  .word   $791f
        .byte   $93,$a8,$a8,$ff,$a6,$9a,$a7,$b2,$be,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

; c3/c3f5: (11, 3) "one's plenty!"
ShopOnlyOneMsgText:
@c3f5:  .word   $791f
        .byte   $8e,$a7,$9e,$c3,$ac,$ff,$a9,$a5,$9e,$a7,$ad,$b2,$be,$ff,$00

; ------------------------------------------------------------------------------

.pushseg
.segment "shop_prop"

; c4/7ac0
ShopProp:
        .incbin "shop_prop.dat"

.popseg

; ------------------------------------------------------------------------------
