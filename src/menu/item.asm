
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: item.asm                                                             |
; |                                                                            |
; | description: item menu                                                     |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.include "src/text/item_desc.inc"
.include "src/text/item_name.inc"
.if LANG_EN
.include "src/text/item_symbol_name.inc"
.endif
.include "src/text/rare_item_desc.inc"
.include "src/text/rare_item_name.inc"

.import ItemProp

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ init cursor (item list) ]

LoadItemListCursor:
@7d1c:  ldy     #near ItemListCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (item list) ]

UpdateItemListCursor:
@7d22:  jsr     MoveListCursor

InitItemListCursor:
@7d25:  ldy     #near ItemListCursorPos
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

.if LANG_EN

ItemListCursorProp:
        cursor_prop {0, 0}, {1, 10}, NO_Y_WRAP

ItemListCursorPos:
        .repeat 10, i
        cursor_pos {8, 92 + i * 12}
        .endrep

.else

ItemListCursorProp:
        cursor_prop {0, 0}, {2, 10}, NO_Y_WRAP

ItemListCursorPos:
        .repeat 10, i
        cursor_pos {8, 92 + i * 12}
        cursor_pos {120, 92 + i * 12}
        .endrep

.endif

; ------------------------------------------------------------------------------

; [ load cursor for rare items list ]

LoadRareItemCursor:
@7d44:  ldy     #near RareItemCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for rare items list ]

UpdateRareItemCursor:
@7d4a:  jsr     MoveCursor

InitRareItemCursor:
@7d4d:  ldy     #near RareItemCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

.if LANG_EN

RareItemCursorProp:
        cursor_prop {0, 0}, {2, 10}

RareItemCursorPos:
        .repeat 10, i
        cursor_pos {8, 92 + i * 12}
        cursor_pos {120, 92 + i * 12}
        .endrep

.else

RareItemCursorProp:
        cursor_prop {0, 0}, {3, 10}

RareItemCursorPos:
        .repeat 10, i
        cursor_pos {8, 92 + i * 12}
        cursor_pos {80, 92 + i * 12}
        cursor_pos {152, 92 + i * 12}
        .endrep

.endif

; ------------------------------------------------------------------------------

; [ load cursor for item option (use, arrange, rare) ]

LoadItemOptionCursor:
@7d80:  ldy     #near ItemOptionCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ init item option cursor ]

InitItemOptionCursor:
@7d86:  ldy     #near ItemOptionCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; [ update item option cursor ]

UpdateItemOptionCursor:
@7d8c:  jsr     MoveCursor
        jsr     InitItemOptionCursor
        ldy     z4d
        sty     r0234
        rts

; ------------------------------------------------------------------------------

; item option cursor (top of item menu)
ItemOptionCursorProp:
        cursor_prop {0, 0}, {3, 1}, NO_Y_WRAP

ItemOptionCursorPos:
.if LANG_EN
@7d9d:  cursor_pos {64, 22}
        cursor_pos {104, 22}
        cursor_pos {176, 22}
.else
        cursor_pos {64, 22}
        cursor_pos {112, 22}
        cursor_pos {168, 22}
.endif

; ------------------------------------------------------------------------------

; [ init bg (item list) ]

DrawItemListMenu:
@7da3:  lda     #$01
        sta     hBG1SC
        ldy     #near ItemDetailsWindow1
        jsr     DrawWindow
        ldy     #near ItemDetailsWindow2
        jsr     DrawWindow
        ldy     #near ItemOptionsWindow
        jsr     DrawWindow
        ldy     #near ItemTitleWindow
        jsr     DrawWindow
        ldy     #near ItemDescWindow
        jsr     DrawWindow
        ldy     #near ItemListWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     ClearBG3ScreenD
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near ItemTitleText
        jsr     DrawPosKana
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near ItemOptionTextList
        ldy     #sizeof_ItemOptionTextList
        jsr     DrawPosKanaList
        jsr     _c3a73d
        jsr     InitElementSymbolGfx
        jsr     ClearBG1ScreenB
        jsr     InitItemListText
        jsr     InitItemDesc
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

; [ init item list text ]

InitItemListText:
@7e0d:  jsr     ClearBG1ScreenA
        jmp     DrawItemList

; ------------------------------------------------------------------------------

ItemTitleWindow:                        window_pos BG2A, {1, 1}, {4, 2}
ItemOptionsWindow:                      window_pos BG2A, {7, 1}, {22, 2}
ItemDescWindow:                         window_pos BG2A, {1, 5}, {28, 3}
ItemListWindow:                         window_pos BG2A, {1, 10}, {28, 15}
ItemDetailsWindow1:                     window_pos BG2B, {18, 1}, {13, 24}
ItemDetailsWindow2:                     window_pos BG2A, {30, 0}, {1, 24}

; ------------------------------------------------------------------------------

; [ init bg scrolling hdma (item list) ]

InitItemBGScrollHDMA:

; bg3 vertical scroll
@7e2b:  lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near ItemBG3VScrollHDMATbl
        sty     hDMA5::ADDR
        lda     #^ItemBG3VScrollHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^ItemBG3VScrollHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA

; bg1 horizontal and vertical scroll
        jsr     LoadItemBG1VScrollHDMATbl
        ldx     zZero
@7e4e:  lda     f:ItemBG1HScrollHDMATbl,x
        sta     $7e9a09,x
        inx
        cpx     #sizeof_ItemBG1HScrollHDMATbl
        bne     @7e4e
        lda     #$02
        sta     hDMA6::CTRL
        lda     #<hBG1HOFS
        sta     hDMA6::HREG
        ldy     #$9a09
        sty     hDMA6::ADDR
        lda     #$7e
        sta     hDMA6::ADDR_B
        lda     #$7e
        sta     hDMA6::HDMA_B
        lda     #$02
        sta     hDMA7::CTRL
        lda     #<hBG1VOFS
        sta     hDMA7::HREG
        ldy     #$9849
        sty     hDMA7::ADDR
        lda     #$7e
        sta     hDMA7::ADDR_B
        lda     #$7e
        sta     hDMA7::HDMA_B
        lda     #BIT_6 | BIT_7
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; [ load bg1 vertical scroll hdma table (item list) ]

LoadItemBG1VScrollHDMATbl:
@7e95:  ldx     zZero
@7e97:  lda     f:ItemBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        cpx     #$0012
        bne     @7e97
@7ea5:  lda     f:ItemBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        clr_a
        lda     z49
        asl4
        and     #$ff                    ; this does nothing
        longa
        clc
        adc     f:ItemBG1VScrollHDMATbl,x
        sta     $7e9849,x
        shorta
        inx2
        cpx     #$006c
        bne     @7ea5
@7ecb:  lda     f:ItemBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        cpx     #$0070
        bne     @7ecb
        rts

; ------------------------------------------------------------------------------

; bg1 horizontal scroll hdma table (item list)
ItemBG1HScrollHDMATbl:
        hdma_word 40, $0100
        hdma_word 47, $0100
        hdma_word 120, $0000
        hdma_word 30, $0100
        hdma_end
        calc_size ItemBG1HScrollHDMATbl

; ------------------------------------------------------------------------------

; bg1 vertical scroll hdma table (item list)
ItemBG1VScrollHDMATbl:
        hdma_word 39, 128
        hdma_word 8, 0
        hdma_word 12, 4
        hdma_word 12, 8
        hdma_word 8, 128
        hdma_word 8, 0
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
        hdma_word 4, -60
        hdma_word 4, -60
        hdma_word 4, -60
        hdma_word 4, -56
        hdma_word 4, -56
        hdma_word 4, -56
        hdma_word 4, -52
        hdma_word 4, -52
        hdma_word 4, -52
        hdma_word 4, -48
        hdma_word 4, -48
        hdma_word 4, -48
        hdma_word 30, 0
        hdma_end

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (item list)

ItemBG3VScrollHDMATbl:
        hdma_word 47, 0
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

; [ init item list text (item menu) ]

DrawItemList:
@7f88:  jsr     GetListTextPos
        ldy     #10                     ; 10 lines
@7f8e:  phy
        jsr     DrawItemListRow
        inc     ze5
.if !LANG_EN
        inc     ze5
.endif
        lda     ze6
        inc2
        and     #$1f
        sta     ze6
        ply                             ; next line
        dey
        bne     @7f8e
        rts

; ------------------------------------------------------------------------------

; [ update item list text (item menu) ]

; $e5 = position in inventory
; $e6 = vertical position on screen

        array_label UPDATE_LIST_TEXT, LIST_TYPE::ITEM
        DrawItemListRow:
@7fa1:  clr_a
        lda     ze5                     ; position in inventory
        tay
        jsr     GetItemNameColor
        lda     $1969,y                 ; item quantity
        jsr     HexToDec3
        lda     ze6                     ; vertical position + 1
        inc
.if LANG_EN
        ldx     #17                     ; horizontal position = 17
.else
        ldx     #13
.endif
        jsr     GetBG1TilemapPtr
        jsr     DrawNum2
        lda     ze6                     ; vertical position + 1
.if LANG_EN
        inc
.endif
        ldx     #3                      ; horizontal position = 3
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89                 ; set pointer to item text
        shorta
        clr_a
        lda     ze5                     ; position in inventory
        tay
        jsr     LoadListItemName
        jsr     DrawPosTextBuf

.if LANG_EN

        jmp     LoadItemSymbolName

.else

        clr_a
        lda     ze5
        tay
        iny
        jsr     GetItemNameColor
        lda     $1969,y
        jsr     HexToDec3
        lda     ze6
        inc
        ldx     #27
        jsr     GetBG1TilemapPtr
        jsr     DrawNum2
        lda     ze6
        ldx     #17
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     ze5
        tay
        iny
        jsr     LoadListItemName
; fallthrough

.endif

; ------------------------------------------------------------------------------

; [ draw positioned text (at 7e/9e89) ]

DrawPosTextBuf:
@7fd9:  ldy     #near $7e9e89
        sty     ze7
        lda     #^$7e9e89
        sta     ze9
        jsr     DrawPosKanaFar
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

; [ load item symbol name text ]

LoadItemSymbolName:
@7fe6:  longa
        lda     $7e9e89                 ; skip 18 tiles
        clc
        adc     #$0024
        sta     $7e9e89
        shorta
        clr_a
        lda     $7e9e8b                 ; item symbol
        cmp     #$ff
        beq     @802c                   ; branch if no symbol
        sec
        sbc     #$d8                    ; subtract $d8 to get the symbol number
        sta     ze0                     ; multiply by 7 to get pointer to symbol name
        asl2
        sta     ze2
        lda     ze0
        asl
        clc
        adc     ze2
        adc     ze0
        tax
        ldy     #$9e8b
        sty     hWMADDL
        ldy     #ITEM_SYMBOL_NAME::ITEM_SIZE
@801a:  lda     f:ItemSymbolName,x
        sta     hWMDATA
        inx
        dey
        bne     @801a
        clr_a
        sta     hWMDATA
        jmp     DrawPosTextBuf

; no type, copy 7 spaces
@802c:  ldy     #$9e8b
        sty     hWMADDL
        ldy     #ITEM_SYMBOL_NAME::ITEM_SIZE
        lda     #$ff
@8037:  sta     hWMDATA
        inx
        dey
        bne     @8037
        clr_a
        sta     hWMDATA
        jmp     DrawPosTextBuf

.endif

; ------------------------------------------------------------------------------

; [ update item text color ]

GetItemNameColor:
@8045:  lda     r0200       ; menu mode
        cmp     #MENU_TYPE::SHOP
        beq     @8085       ; branch if shop
        cmp     #MENU_TYPE::COLOSSEUM
        beq     @8085       ; branch if colosseum
        bra     @8056
        clr_a
        lda     z4b
        tay
@8056:  lda     $1869,y     ; item number
        cmp     #ITEM::MEGALIXIR
        beq     @808a
        cmp     #ITEM::EMPTY
        beq     @8085
        cmp     #ITEM::TENT
        beq     @808f
        cmp     #ITEM::SLEEPING_BAG
        beq     @808f
        cmp     #ITEM::WARP_STONE
        beq     @8096
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$06
        bne     @808a       ; branch if not a useable item
        lda     f:ItemProp,x   ; branch if not useable on field
        and     #ITEM_USAGE::MENU
        beq     @808a
@8085:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        rts
@808a:  lda     #BG1_TEXT_COLOR::GRAY
        sta     zTextColor
        rts

; tent/sleeping bag
@808f:  lda     r0201
        bmi     @8085       ; white text if on a save point
        bra     @808a       ; gray text if not

; warp stone
@8096:  lda     r0201
        bit     #$02
        bne     @8085       ; white text if warp is enabled
        bra     @808a       ; gray text if warp is enabled

; ------------------------------------------------------------------------------

; [ get tilemap offset (bg1, screen A) ]

; A: vertical position
; X: horizontal position

GetBG1TilemapPtr:
@809f:  xba
        lda     zZero
        xba
        longa
        asl6
        sta     ze7
        txa
        asl
        clc
        adc     ze7
        adc     #near wBG1Tiles::ScreenA
        tax
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load item name for list (with trailing colon) ]

LoadListItemName:
@80b9:  ldx     #$9e8b                  ; set wram to $7e9e8b
        stx     hWMADDL
@80bf:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @80bf
        clr_a
        lda     $1869,y                 ; item number
        cmp     #ITEM::EMPTY
        beq     _80f6

_c380ce:
@80ce:  sta     hM7A                    ; multiply by 13 to get pointer to item name
        stz     hM7A
        lda     #ITEM_NAME::ITEM_SIZE
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #ITEM_NAME::ITEM_SIZE
@80e2:  lda     f:ItemName,x            ; item name
        sta     hWMDATA
        inx
        dey
        bne     @80e2
        lda     #COLON_CHAR
        sta     hWMDATA
        stz     hWMDATA
        rts

_80f6:  ldy     #ITEM_NAME::ITEM_SIZE+3                     ; store 16 spaces (empty)
        lda     #$ff
@80fb:  sta     hWMDATA
        dey
        bne     @80fb
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ update text scrolling ]

; moves 4 pixels per frame
; takes 3 frames to scroll 1 line

UpdateTextScroll:
@8105:  ldx     #$0012      ; start at line 6 in the hdma table
@8108:  shorta
        lda     $7e9849,x   ; bg1 vscroll hdma table, number of scanlines
        cmp     #$1e
        beq     @815e       ; return if on last line of table (number of scanlines = $1e)
        inx
        phx
        clr_a
        lda     zWaitCounter         ; menu state frame counter
        longa
        ldy     zTextScrollRate
        bmi     @811f       ; branch if negative
        bra     @8123       ; branch if positive
@811f:  clc
        adc     #$0003      ; add to menu state frame counter if negative
@8123:  asl
        tax
        tay
        lda     f:TextScrollPosTbl,x   ; vscroll constant
        plx
        clc
        adc     $7e9849,x   ; add to hdma value
        sta     $7e9849,x
        inx3                ; next line
        phx
        tyx
        lda     f:TextScrollPosTbl+12,x
        plx
        clc
        adc     $7e9849,x
        sta     $7e9849,x
        inx3                ; next line
        phx
        tyx
        lda     f:TextScrollPosTbl+24,x
        plx
        clc
        adc     $7e9849,x
        sta     $7e9849,x
        inx2                ; next line
        bra     @8108
@815e:  rts

; ------------------------------------------------------------------------------

; constants to add to bg1 vscroll each frame (3 values each, positive then negative)

; 3rd frame
TextScrollPosTbl:
@815f:  .word   $0008,$0004,$0004,$fffc,$fffc,$fff8
; 2nd frame
@816b:  .word   $0004,$0008,$0004,$fffc,$fff8,$fffc
; 1st frame
@8177:  .word   $0004,$0004,$0008,$fff8,$fffc,$fffc

; ------------------------------------------------------------------------------

; [ bg1 text scrolling task ]

TextScrollTask:
@8183:  tax
        jmp     (near TextScrollTaskTbl,x)

TextScrollTaskTbl:
@8187:  .addr   TextScrollTask_00
        .addr   TextScrollTask_01
        .addr   TextScrollTask_02
        .addr   TextScrollTask_03

; ------------------------------------------------------------------------------

; state $00: init (scroll up)

TextScrollTask_00:
@818f:  ldx     zTaskOffset
        longa
        lda     #near -4
        sta     zTextScrollRate
        shorta
        bra     TextScrollTask_02

; ------------------------------------------------------------------------------

; state $01: init (scroll down)

TextScrollTask_01:
@819c:  ldx     zTaskOffset
        longa
        lda     #4
        sta     zTextScrollRate
        shorta
; fallthrough

; ------------------------------------------------------------------------------

; state $02: init

TextScrollTask_02:
@81a7:  ldx     zTaskOffset
        lda     #$03        ; set task state to 3
        sta     near wTaskProp::State,x
        sta     zWaitCounter         ; set wait counter to 3

; ------------------------------------------------------------------------------

; state $03: update

TextScrollTask_03:
@81b0:  ldx     zTaskOffset
        lda     zWaitCounter         ; wait counter
        beq     @81bc       ; branch when wait counter reaches zero
        lda     #$20
        tsb     z46         ; enable bg1 text scrolling
        sec
        rts
@81bc:  ldy     zZero          ; clear bg1 vscroll speed
        sty     zTextScrollRate
        lda     #$20        ; disable bg1 text scrolling
        trb     z46
        clc                 ; terminate task
        rts

; ------------------------------------------------------------------------------

; [ update cursor movement (scrolling list) ]

_81c6:  rts

MoveListCursor:
@81c7:  lda     zWaitCounter         ; return if waiting for menu state counter
        bne     _81c6

; up button pressed
        lda     zRepCtrlState_H         ; branch if up button is not pressed
        bit     #>JOY_UP
        beq     @81ea
        lda     z4e         ; cursor y position (relative to page)
        bne     @81e2       ; branch if not at top of page
        lda     z4a         ; return if at top of first page
        beq     _81c6
        dec     z50         ; decrement absolute cursor position
        jsr     ScrollListUp
        jsr     PlayMoveSfx
        rts
@81e2:  dec     z50         ; decrement absolute cursor position
        dec     z4e         ; decrement relative cursor position
        jsr     PlayMoveSfx
        rts

; down button pressed
@81ea:  lda     zRepCtrlState_H
        bit     #>JOY_DOWN
        beq     @8210
        lda     z54
        dec
        cmp     z4e
        bne     @8209
        lda     z4a
        cmp     z5c
        beq     @8206
        inc     z50
        jsr     ScrollListDown
        jsr     PlayMoveSfx
        rts
@8206:  jmp     @8285
@8209:  inc     z50
        inc     z4e
        jsr     PlayMoveSfx

; left button pressed
@8210:  lda     zRepCtrlState_H
        bit     #>JOY_LEFT
        beq     @8249
        lda     z4d
        bne     @8241
        lda     z4e
        beq     @822d
        dec     z4e         ; decrement relative cursor position
        dec     z50         ; decrement absolute cursor position
        lda     z53
        dec
        sta     z4d         ; x position = max x position
        sta     z4f
        jsr     PlayMoveSfx
        rts
@822d:  lda     z4a
        beq     _81c6
        jsr     ScrollListUp
        lda     z53
        dec
        sta     z4d
        sta     z4f
        dec     z50
        jsr     PlayMoveSfx
        rts
@8241:  dec     z4d
        dec     z4f
        jsr     PlayMoveSfx
        rts

; right button pressed
@8249:  lda     zRepCtrlState_H
        bit     #>JOY_RIGHT
        beq     @8285
        lda     z53
        dec
        cmp     z4d
        bne     @827e
        lda     z54
        dec
        cmp     z4e
        beq     @826a
        clr_a
        sta     z4d
        sta     z4f
        inc     z4e
        inc     z50
        jsr     PlayMoveSfx
        rts
@826a:  lda     z4a
        cmp     z5c
        beq     @8285
        jsr     ScrollListDown
        clr_a
        sta     z4d
        sta     z4f
        inc     z50
        jsr     PlayMoveSfx
        rts
@827e:  inc     z4d
        inc     z4f
        jsr     PlayMoveSfx
@8285:  rts

; ------------------------------------------------------------------------------

; [ scroll list up ]

ScrollListUp:
@8286:  dec     z4a         ; decrement page scroll position
        dec     z49         ; decrement vertical scroll position
        jsr     GetListTextPos
        jsr     UpdateListText
        lda     #0
        ldy     #near TextScrollTask
        jsr     CreateTask
        clr_a
        sta     wTaskProp::State,x   ; set task state to 0 (scroll up)
        rts

; ------------------------------------------------------------------------------

; [ scroll list down ]

ScrollListDown:
@829e:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @829e
        lda     z5a
        clc
        adc     z4a
        sta     hM7A
        stz     hM7A
        lda     z5b
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        sta     ze5
        lda     z49
        clc
        adc     z5a
        asl
        and     #$1f
        sta     ze6
        inc     z4a
        inc     z49
        jsr     UpdateListText
        lda     #0
        ldy     #near TextScrollTask
        jsr     CreateTask
        lda     #$01
        sta     wTaskProp::State,x               ; task state 1 (scroll down)
        rts

; ------------------------------------------------------------------------------

; [ update list text ]

UpdateListText:
@82dd:  clr_a
        lda     zListType
        asl
        tax
        jmp     (near UpdateListTextTbl,x)

; jump table for list types
UpdateListTextTbl:
        ptr_tbl UPDATE_LIST_TEXT

; ------------------------------------------------------------------------------

; [ init item description ]

InitItemDesc:
@82f1:  jsr     GetItemDescPtr
        clr_a
        lda     z4b
        tay
        lda     $1869,y
        jsr     LoadItemDesc
        jsr     CountInventoryItems
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jmp     DrawItemCount

; ------------------------------------------------------------------------------

; [ get pointer to item description ]

GetItemDescPtr:
@8308:  ldx     #near ItemDescPtrs
        stx     ze7
        ldx     #near ItemDesc
        stx     zeb
        lda     #^ItemDescPtrs
        sta     ze9
        lda     #^ItemDesc
        sta     zed
        ldx     #$9ec9
        stx     hWMADDL
        rts

; ------------------------------------------------------------------------------

; [ calculate pointer to item data ]

;      A: item number
; +$2134: pointer (+$d85000)

GetItemPropPtr:
@8321:  pha
@8322:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @8322
        pla
        sta     hM7A
        stz     hM7A
        lda     #30                     ; multiply by 30
        sta     hM7B
        sta     hM7B
        rts

; ------------------------------------------------------------------------------

; [ get pointer to rare item description ]

InitRareItemDesc:
@8339:  ldx     #near RareItemDescPtrs
        stx     ze7
        ldx     #near RareItemDesc
        stx     zeb
        lda     #^RareItemDescPtrs
        sta     ze9
        sta     zed
        jsr     LoadBigText
        jsr     CountRareItems
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jmp     DrawItemCount

; ------------------------------------------------------------------------------

; [ count number of items in inventory ]

CountInventoryItems:
@8356:  clr_axy
@8359:  lda     $1869,x                 ; current items
        cmp     #ITEM::EMPTY
        beq     @8361
        iny
@8361:  inx
        cpx     #$0100
        bne     @8359
        tya
        sta     z64
        rts

; ------------------------------------------------------------------------------

; [ count rare items ]

CountRareItems:
@836b:  clr_ax
@836d:  lda     $7e9d89,x
        bmi     @8376
        inx
        bra     @836d
@8376:  txa
        sta     z64
        rts

; ------------------------------------------------------------------------------

; [ draw item count ]

DrawItemCount:
@837a:  lda     z64
        jsr     HexToDec3
        ldx_pos BG3A, {27, 9}
        jmp     DrawNum3

; ------------------------------------------------------------------------------

; [ clear item count ]

ClearItemCount:
@8385:  ldy     #near ItemBlankQtyText
        jmp     DrawPosText

; ------------------------------------------------------------------------------

; [ draw rare item list ]

InitRareItemList:
@838b:  jsr     ClearBG1ScreenA
        jsr     GetRareItemList
        jmp     DrawRareItemList

; ------------------------------------------------------------------------------

; [ make a list of rare items that the player has ]

GetRareItemList:
@8394:  ldx     #$9d89
        stx     hWMADDL
.if LANG_EN
        ldy     #$0014
.else
        ldy     #$0021
.endif
        lda     #$ff
@839f:  sta     hWMDATA
        dey
        bne     @839f
        ldx     #$9d89
        stx     hWMADDL
        ldx     $1eba                   ; rare item event bits (28 total)
        stx     zef
        lda     $1ebc
        sta     zf1
        lda     $1ebd
.if LANG_EN
        and     #$0f
        stz     zf2
.else
        and     #$3f                    ; 30 bits for japanese version
        sta     zf2
.endif
        clr_a
        sta     ze0
        tax
        lda     #$04
        sta     ze1
@83c4:  ldy     #$0008
        lda     zef,x
@83c9:  ror
        pha
        bcc     @83d2
        lda     ze0
        sta     hWMDATA
@83d2:  inc     ze0
        pla
        dey
        bne     @83c9
        inx
        dec     ze1
        bne     @83c4
        rts

; ------------------------------------------------------------------------------

; [ draw rare item list ]

DrawRareItemList:
@83de:  jsr     GetListTextPos
        stz     ze5
        ldy     #10
@83e6:  phy
        jsr     DrawRareItemListRow
        lda     ze6
        inc
        inc
        and     #$1f
        sta     ze6
        ply
        dey
        bne     @83e6
        rts

; ------------------------------------------------------------------------------

; [ calculate text position ]

; $e5 = index of selected item in list
; $e6 = vertical position in bg1 data

GetListTextPos:
@83f7:  lda     z49                     ; vertical scroll position
        asl
        and     #$1f
        sta     ze6
@83fe:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @83fe
        lda     z4a                     ; page scroll position * page width
        sta     hM7A
        stz     hM7A
        lda     z5b
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        sta     ze5
        rts

; ------------------------------------------------------------------------------

; [ draw one row of rare item list ]

DrawRareItemListRow:
@841b:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jsr     GetRareItemNamePtr
        ldx     #3
        jsr     DrawRareItemName
        inc     ze5
        jsr     GetRareItemNamePtr
        ldx     #RARE_ITEM_NAME::ITEM_SIZE+4
        jsr     DrawRareItemName
        inc     ze5
.if !LANG_EN
        jsr     GetRareItemNamePtr
        ldx     #21
        jsr     DrawRareItemName
        inc     ze5
.endif
        rts

; ------------------------------------------------------------------------------

; [ get pointer to rare item names ]

GetRareItemNamePtr:
@8436:  ldy     #RARE_ITEM_NAME::ITEM_SIZE
        sty     zeb
        ldy     #near RareItemName
        sty     zef
        lda     #^RareItemName
        sta     zf1
        rts

; ------------------------------------------------------------------------------

; [ draw rare item name ]

; X: text x position

DrawRareItemName:
@8445:  lda     ze6
.if LANG_EN
        inc
.endif
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     ze5
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @8466
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@8466:  rts

; ------------------------------------------------------------------------------

; [ load fixed-length item from array ]

; $eb: string length
;   A: string id

LoadArrayItem:
@8467:  pha
        ldx     #$9e8b                  ; destination address: 7e/9e8b
        stx     hWMADDL
@846e:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @846e
        pla
        sta     hM7A
        stz     hM7A
        clr_a
        lda     zeb
        sta     hM7B
        sta     hM7B
        ldy     hMPYL
        ldx     zeb
@848a:  lda     [zef],y
        sta     hWMDATA
        iny
        dex
        bne     @848a
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ use item (from inventory) ]

UseItem:
@8497:  clr_a
        lda     z4b
        sta     zSelIndex
        tay
        lda     $1869,y                 ; item
        cmp     #ITEM::EMPTY
        beq     @8510                   ; branch if slot is empty
        cmp     #ITEM::MEGALIXIR
        beq     @8510                   ; branch if megalixir
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$06
        bne     @8515                   ; branch if not a useable item
        lda     f:ItemProp,x
        and     #ITEM_USAGE::MENU
        beq     @8510                   ; branch if not useable on the field
        clr_a
        lda     zSelIndex
        tay
        lda     $1869,y                 ; item index
        cmp     #ITEM::TENT
        beq     @84f8                   ; branch if a tent was used
        cmp     #ITEM::SLEEPING_BAG
        beq     @84e2                   ; branch if a sleeping bag was used
        cmp     #ITEM::WARP_STONE
        beq     @84eb                   ; branch if a warp stone was used
@84d3:  ldy     z4f
        sty     z8e
        lda     z4a
        sta     z90
        lda     #MENU_STATE::ITEM_CHAR_INIT
        sta     zNextMenuState
        stz     zMenuState
        rts

; sleeping bag
@84e2:  sta     ze6
        lda     r0201
        bpl     @8510                   ; branch if not on a save point
        bra     @84d3                   ; go to character select

; warp stone
@84eb:  sta     ze6
        lda     r0201
        bit     #$02
        beq     @8510                   ; branch if warp is disabled
        lda     #$03                    ; return code $03 (warp/warp stone)
        bra     @8501

; tent
@84f8:  sta     ze6
        lda     r0201
        bpl     @8510                   ; branch if not on a save point
        lda     #$02                    ; return code $02 (tent)
@8501:  sta     r0205
        lda     ze6
        jsr     DecItemQty
        lda     #MENU_STATE::TERMINATE  ; terminate menu after fade out
        sta     zNextMenuState
        stz     zMenuState              ; menu state $00 (fade out)
        rts
@8510:  lda     #MENU_STATE::ITEM_SELECT
        sta     zMenuState
        rts

; not a useable item, show item details
@8515:  ldy     #$9d89
        sty     hWMADDL
        cmp     #$00
        beq     @8510                   ; branch if a tool (back to item select)
        stz     ze0
        longa
        lda     f:ItemProp+1,x          ; equippable characters
        ldx     zZero
@8529:  lsr
        bcc     @8537                   ; skip characters that can't equip this item
        pha
        shorta
        lda     ze0
        sta     hWMDATA                 ; store character index
        longa
        pla
@8537:  shorta
        inc     ze0                     ; increment character index
        longa
        inx                             ; next character
        cpx     #$000e
        bne     @8529
        shorta
        lda     #$ff                    ; store end of list
        sta     hWMDATA
        longa
        lda     #$00e0
        sta     $7e9a10                 ;
.if LANG_EN
        lda_pos BG3A, {2, 21}
.else
        lda_pos BG3A, {3, 20}
.endif
        sta     $7e9e89                 ; pointer to positioned text
        shorta
        lda     #$04
        trb     z45
        jsr     _c3858c
        jsr     CreateItemDetailsArrowTask
        clr_a
        lda     z4b                     ; selected item
        tay
        jsr     LoadListItemName
        jsr     _c385ad
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        jsr     DrawPosTextBuf
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        jsr     _c385d5
        jsr     DrawItemDetails
        jsr     InitDMA1BG3ScreenAB
        jsr     DisableDMA2
        lda     #MENU_STATE::ITEM_DETAILS_1
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3858c:
@858c:  lda     #$c0                    ; page can't scroll up or down
        trb     z46
        lda     #$10                    ; force description text redraw ???
        tsb     z45
        rts

; ------------------------------------------------------------------------------

; [ init flashing left cursor (item details) ]

CreateItemDetailsArrowTask:
@8595:  lda     #1                      ; enable flashing left cursor
        sta     z99
        lda     #1
        ldy     #near ItemDetailsArrowTask
        jsr     CreateTask
        lda     #$80
        sta     wTaskProp::PosY_H,x             ; y position
        clr_a
        sta     wTaskProp::PosY_H + 1,x
        rts

; ------------------------------------------------------------------------------

; [ load " can be used by:" text to buffer ]

_c385ad:
@85ad:  ldx     #$0001
@85b0:  lda     $7e9e8b,x
        cmp     #$ff
        bne     @85cd
@85b8:  ldy     zZero
@85ba:  phx
        tyx
        lda     f:ItemUsageText,x       ; " can be used by:"
        plx
        sta     $7e9e8b,x
        inx
        iny
        cpy     #sizeof_ItemUsageText
        bne     @85ba
        rts
@85cd:  inx
        cpx     #ITEM_NAME::ITEM_SIZE
        bne     @85b0
        bra     @85b8

; ------------------------------------------------------------------------------

; [ draw equippable character names ]

_c385d5:
@85d5:  ldx     #$9e09
        stx     hWMADDL
        ldx     zZero
@85dd:  lda     $7e9d89,x
        bmi     @8623                   ; branch if no character
        sta     ze5
        ldy     zZero
        sty     ze7
@85e9:  stx     zf3
        lda     ze5
        cmp     $1600,y
        bne     @860a
        longa
        lda     ze7
        asl
        tax
        lda     $1edc                   ; initialized characters
        and     f:CharEquipMaskTbl,x
        shorta
        beq     @861b                   ; branch if character is not initialized
        lda     ze7
        sta     hWMDATA
        bra     @861b
@860a:  longa_clc                          ; check next character
        tya
        adc     #$0025
        tay
        shorta
        inc     ze7
        lda     ze7
        cmp     #$10
        bne     @85e9
@861b:  ldx     zf3
        inx
        cpx     #$0010
        bne     @85dd
@8623:  lda     #$ff
        sta     hWMDATA
.if LANG_EN
        ldx     zZero
@862a:  clr_a
.else
        clr_ax
@862a:
.endif
        lda     $7e9e09,x
        bmi     @8652
        phx
        phx
        longa
        asl
        tax
        lda     f:CharPropPtrs,x
        sta     zSelCharPropPtr
        plx
        txa
        asl
        tax
        lda     f:_c38653,x
        tay
        shorta
        jsr     DrawCharName
        plx
        inx
        cpx     #$000e
        bne     @862a
@8652:  rts

; ------------------------------------------------------------------------------

; pointers to character names in bg data (item details)
_c38653:

.if LANG_EN
        @Y_POS = 23
.else
        @Y_POS = 22
.endif

        .repeat 5, yy
        .repeat 3, xx
        bg_pos BG3A, {3 + xx * 10, @Y_POS + yy * 2}
        .endrep
        .endrep

; ------------------------------------------------------------------------------

; [ draw item stats ]

DrawItemDetails:
@8671:  jsr     ClearBG3ScreenB
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near ItemStatTextList1
        ldy     #sizeof_ItemStatTextList1
        jsr     DrawPosList
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near ItemStatTextList2
        ldy     #sizeof_ItemStatTextList2
        jsr     DrawPosKanaList
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        clr_a
        lda     z4b                     ; cursor position
        tay
        lda     $1869,y                 ; item index
        jsr     GetItemPropPtr
        ldx     hMPYL
        clr_a
        sta     $7e9e8d
        sta     $7e9e8e
        longa
        lda_pos BG3B, {30, 15}
        sta     $7e9e89
        shorta
        clr_a
        lda     f:ItemProp+16,x         ; vigor/speed
        pha
        and     #$0f
        asl
        jsr     DrawItemStatModifier
        longa
        lda_pos BG3B, {30, 17}
        sta     $7e9e89
        shorta
        clr_a
        pla
        and     #$f0
        lsr3
        jsr     DrawItemStatModifier
        longa
        lda_pos BG3B, {30, 19}
        sta     $7e9e89
        shorta
        ldx     hMPYL
        clr_a
        lda     f:ItemProp+17,x         ; stamina/mag.pwr
        pha
        and     #$0f
        asl
        jsr     DrawItemStatModifier
        longa
        lda_pos BG3B, {30, 21}
        sta     $7e9e89
        shorta
        clr_a
        pla
        and     #$f0
        lsr3
        jsr     DrawItemStatModifier
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$01
        beq     @8746                   ; branch if a weapon

; not a weapon
        lda     f:ItemProp+20,x         ; defense power
        jsr     HexToDec3
        ldx_pos BG3B, {29, 25}
        jsr     DrawNum3
        ldx     hMPYL
        lda     f:ItemProp+21,x         ; magic defense
        jsr     HexToDec3
        ldx_pos BG3B, {29, 29}
        jsr     DrawNum3
        jsr     DrawItemEvadeModifier
        jsr     _c388a0
        jsr     _c38959
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near ItemElementTextList
        ldy     #sizeof_ItemElementTextList
        jsr     DrawPosKanaList
        jmp     DrawWeaponLearnedMagic

; weapon
@8746:  jsr     DrawWeaponPower
        jsr     DrawItemEvadeModifier
        lda     #BG3_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near ItemAttackElementText
        jsr     DrawPosKana
        jsr     _c388a0
        lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     hMPYL
        lda     f:ItemProp+19,x         ; weapon properties
        bpl     @876e
        ldy     #near ItemRunicText
        sty     ze7
        jsr     _c38795
@876e:  ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #WEAPON_FLAG::TWO_HAND
        beq     @8781
        ldy     #near Item2HandText
        sty     ze7
        jsr     _c38795
@8781:  ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #WEAPON_FLAG::BUSHIDO
        beq     @8794
        ldy     #near ItemBushidoText
        sty     ze7
        jsr     _c38795
@8794:  rts

; ------------------------------------------------------------------------------

; [ draw weapon property name text (runic, 2-hand, swdtech) ]

_c38795:
@8795:  lda     #^*                     ; bank byte of text pointer
        sta     ze9
        jmp     DrawPosTextFar

; ------------------------------------------------------------------------------

; [ draw weapon's battle power ]

DrawWeaponPower:
@879c:  clr_a
        lda     z4b
        tay
        lda     $1869,y                 ; current items
        cmp     #ITEM::ATMA_WEAPON
        beq     @87c0                   ; branch if atma weapon
        cmp     #ITEM::SOUL_SABRE
        beq     @87c0                   ; branch if soul sabre
        cmp     #ITEM::DICE
        beq     @87c0                   ; branch if dice
        cmp     #ITEM::FIXED_DICE
        beq     @87c0                   ; branch if fixed dice
        lda     f:ItemProp+20,x         ; battle power
        jsr     HexToDec3
        ldx_pos BG3B, {29, 23}
        jmp     DrawNum3
@87c0:  ldy     #near ItemUnknownAttackText
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw item's spell learned ]

DrawWeaponLearnedMagic:
@87c7:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     hMPYL
        lda     f:ItemProp+3,x   ; spell learn rate
        beq     @87ea
        sta     ze0
        lda     f:ItemProp+4,x   ; spell learned
        sta     ze1
        longa
.if LANG_EN
        lda_pos BG3B, {19, 11}
.else
        lda_pos BG3B, {19, 10}
.endif
        sta     $7e9e89
        shorta
        jsr     DrawItemMagicName
@87ea:  rts

; ------------------------------------------------------------------------------

; [ draw item's evade%/mblock% ]

DrawItemEvadeModifier:
@87eb:  longa
        lda_pos BG3B, {29, 27}
        sta     $7e9e89
        shorta
        ldx     hMPYL
        clr_a
        lda     f:ItemProp+26,x         ; evade%/mblock%
        pha
        and     #$0f
        asl2
        jsr     @881a
        longa
        lda_pos BG3B, {29, 31}
        sta     $7e9e89
        shorta
        ldx     hMPYL
        clr_a
        pla
        and     #$f0
        lsr2

; draw % modifier text
@881a:  tax
        lda     f:EvadeModifierTextTbl,x
        sta     $7e9e8b
        lda     f:EvadeModifierTextTbl+1,x
        sta     $7e9e8c
        lda     f:EvadeModifierTextTbl+2,x
        sta     $7e9e8d
        jmp     _8847

; ------------------------------------------------------------------------------

; [ draw item stat modifier text ]

DrawItemStatModifier:
@8836:  tax
        lda     f:StatModifierTextTable,x
        sta     $7e9e8b
        lda     f:StatModifierTextTable+1,x
        sta     $7e9e8c
_8847:  ldy     #$9e89
        sty     ze7
        lda     #$7e
        sta     ze9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

; must be 4 bytes each
EvadeModifierTextTbl:
        raw_text EVADE_MODIFIER_0
        raw_text EVADE_MODIFIER_PLUS_10
        raw_text EVADE_MODIFIER_PLUS_20
        raw_text EVADE_MODIFIER_PLUS_30
        raw_text EVADE_MODIFIER_PLUS_40
        raw_text EVADE_MODIFIER_PLUS_50
        raw_text EVADE_MODIFIER_MINUS_10
        raw_text EVADE_MODIFIER_MINUS_20
        raw_text EVADE_MODIFIER_MINUS_30
        raw_text EVADE_MODIFIER_MINUS_40
        raw_text EVADE_MODIFIER_MINUS_50

; must be 2 bytes each
StatModifierTextTable:
        raw_text STAT_MODIFIER_0
        raw_text STAT_MODIFIER_PLUS_1
        raw_text STAT_MODIFIER_PLUS_2
        raw_text STAT_MODIFIER_PLUS_3
        raw_text STAT_MODIFIER_PLUS_4
        raw_text STAT_MODIFIER_PLUS_5
        raw_text STAT_MODIFIER_PLUS_6
        raw_text STAT_MODIFIER_PLUS_7
        raw_text STAT_MODIFIER_0
        raw_text STAT_MODIFIER_MINUS_1
        raw_text STAT_MODIFIER_MINUS_2
        raw_text STAT_MODIFIER_MINUS_3
        raw_text STAT_MODIFIER_MINUS_4
        raw_text STAT_MODIFIER_MINUS_5
        raw_text STAT_MODIFIER_MINUS_6
        raw_text STAT_MODIFIER_MINUS_7

; ------------------------------------------------------------------------------

; [ draw weapon elements ]

; also draws 50% elements for defensive items

_c388a0:
@88a0:  ldx     hMPYL
        clr_a
        lda     f:ItemProp+15,x         ; element
        jsr     _c388ae
        jmp     _c388ce

; ------------------------------------------------------------------------------

; [  ]

_c388ae:
@88ae:  ldy     #$aa8d
        sty     hWMADDL
        stz     ze0
        ldy     #$0008
@88b9:  rol
        bcc     @88c3
        pha
        lda     ze0
        sta     hWMDATA
        pla
@88c3:  inc     ze0
        dey
        bne     @88b9
        lda     #$ff
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [  ]

; weapon/50% elements
_c388ce:
@88ce:  ldx_pos BG3A, {2, 14}
        stx     zeb
        lda     #^wBG3Tiles
        sta     zed
        jmp     _88fe

; absorbed elements
_c388da:
@88da:  ldx_pos BG3A, {16, 14}
        stx     zeb
        lda     #^wBG3Tiles
        sta     zed
        jmp     _88fe

; no effect elements
_c388e6:
@88e6:  ldx_pos BG3A, {2, 18}
        stx     zeb
        lda     #^wBG3Tiles
        sta     zed
        jmp     _88fe

; weak point elements
_c388f2:
@88f2:  ldx_pos BG3A, {16, 18}
        stx     zeb
        lda     #^wBG3Tiles
        sta     zed
        jmp     _88fe

_88fe:  clr_ax
@8900:  clr_a
        lda     $7eaa8d,x
        bmi     @8926
        phx
        longa
        asl
        tax
        lda     f:_c38927,x
        sta     ze0
        jsr     _c38937
        lda     zeb
        clc
        adc     #$0004
        sta     zeb
        shorta
        plx
        inx
        cpx     #$0006
        bne     @8900
@8926:  rts

; ------------------------------------------------------------------------------

_c38927:
@8927:  .word   $3580,$3584,$3588,$358c,$3590,$3594,$3598,$359c

; ------------------------------------------------------------------------------

; [  ]

_c38937:
@8937:  clr_ay
        lda     ze0
        sta     [zeb],y
        inc     ze0
        ldy     #$0040
        lda     ze0
        sta     [zeb],y
        inc     ze0
        ldy     #$0002
        lda     ze0
        sta     [zeb],y
        inc     ze0
        ldy     #$0042
        lda     ze0
        sta     [zeb],y
        rts

; ------------------------------------------------------------------------------

; [ draw defensive elements ]

_c38959:
@8959:  ldx     hMPYL
        clr_a
        lda     f:ItemProp+22,x   ; absorbed
        jsr     _c388ae
        jsr     _c388da
        ldx     hMPYL
        clr_a
        lda     f:ItemProp+23,x   ; no effect
        jsr     _c388ae
        jsr     _c388e6
        ldx     hMPYL
        clr_a
        lda     f:ItemProp+24,x   ; weak point
        jsr     _c388ae
        jmp     _c388f2

; ------------------------------------------------------------------------------

; [ menu state $64: item details ]

        array_label MENU_STATE, MENU_STATE::ITEM_DETAILS_1
@8983:  lda     zNewCtrlState_L
        bit     #JOY_A
        bne     @898f                   ; branch if A button is pressed
        lda     zNewCtrlState_H
        bit     #>JOY_LEFT
        beq     @89a8                   ; branch if left button is not pressed

; left button or A button
@898f:  jsr     PlaySelectSfx
        lda     #$ff
        sta     z99
        lda     #10
        sta     zWaitCounter
        ldy     #near -12
        sty     zMenuScrollRate
        lda     #MENU_STATE::ITEM_DETAILS_2
        sta     zNextMenuState
        lda     #MENU_STATE::H_SCROLL
        sta     zMenuState
        rts

; B button
@89a8:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @89dd                   ; return if B button is not pressed
        jsr     PlayCancelSfx
        lda     #$ff
        sta     z99
        ldx_pos BG3A, {0, 12}
        stx     hWMADDL
        ldx     #$0280
@89be:  stz     hWMDATA
        stz     hWMDATA
        dex
        bne     @89be
        lda     #$04
        tsb     z45
        jsr     _c389de
        jsr     InitDMA1BG3ScreenA
        jsr     WaitVblank
        clr_a
        sta     $7e9a10
        lda     #MENU_STATE::ITEM_SELECT
        sta     zMenuState
@89dd:  rts

; ------------------------------------------------------------------------------

; [  ]

_c389de:
@89de:  jsr     CreateScrollArrowTask1
        lda     #$10
        trb     z45
        rts

; ------------------------------------------------------------------------------

; [ menu state $5e: item details ]

        array_label MENU_STATE, MENU_STATE::ITEM_DETAILS_2
@89e6:  lda     zNewCtrlState_H
        bit     #>JOY_B
        bne     @89f2                   ; branch if B button is pressed
        lda     zNewCtrlState_H
        bit     #>JOY_RIGHT
        beq     @8a0d                   ; branch if right button is not pressed

; B button or right button
@89f2:  jsr     PlayCancelSfx
        lda     #10
        sta     zWaitCounter
        ldy     #12
        sty     zMenuScrollRate
        lda     #$05
        trb     z46
        lda     #MENU_STATE::ITEM_DETAILS_1
        sta     zNextMenuState
        lda     #MENU_STATE::H_SCROLL
        sta     zMenuState
        jsr     CreateItemDetailsArrowTask
@8a0d:  rts

; ------------------------------------------------------------------------------

; [ draw item target menu ]

DrawItemTargetMenu:
@8a0e:  jsr     ClearBG2ScreenA
        ldy     #near ItemTargetCharWindow
        jsr     DrawWindow
        ldy     #near ItemTargetItemNameWindow
        jsr     DrawWindow
        ldy     #near ItemTargetQtyWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenB
        ldy     #near -64
        sty     zBG1HScroll
        lda     #$02
        tsb     z45
        jsr     _c3318a
        jsr     _c38a47
        jmp     _c3319f

; ------------------------------------------------------------------------------

ItemTargetCharWindow:                   window_pos BG2A, {10, 1}, {19, 24}
.if LANG_EN
ItemTargetItemNameWindow:               window_pos BG2A, {1, 1}, {13, 2}
.else
ItemTargetItemNameWindow:               window_pos BG2A, {1, 1}, {8, 2}
.endif
ItemTargetQtyWindow:                    window_pos BG2A, {1, 5}, {7, 3}

; ------------------------------------------------------------------------------

; [  ]

_c38a47:
@8a47:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near ItemOwnedText
        jsr     DrawPosKana
        longa
.if LANG_EN
        lda_pos BG3A, {1, 3}
.else
        lda_pos BG3A, {1, 2}
.endif
        sta     $7e9e89
        shorta
        clr_a
        lda     z4b
        tay
        jsr     LoadListItemName
        clr_a
.if LANG_EN
        sta     $7e9e98
.else
        sta     $7e9e94
.endif
        jsr     DrawPosTextBuf
        bra     ItemTargetDrawQty

; ------------------------------------------------------------------------------

; [ draw item quantity (item target select) ]

ItemTargetDrawQty:
@8a6d:  lda     #BG3_TEXT_COLOR::DEFAULT
        sta     zTextColor
        clr_a
        lda     zSelIndex
        tay
        lda     $1969,y     ; item quantity
        jsr     HexToDec3
        ldx_pos BG3A, {5, 9}
        jsr     DrawNum2
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ menu state $6f: use item (character select, init) ]

        array_label MENU_STATE, MENU_STATE::ITEM_CHAR_INIT
@8a84:  jsr     _c32a76
        jsr     DrawItemTargetMenu
        jsr     CreateCursorTask
        lda     #$40
        tsb     z45
        lda     #$70
        jmp     _c32aa5

; ------------------------------------------------------------------------------

; [ menu state $70: use item (character select) ]

        array_label MENU_STATE, MENU_STATE::ITEM_CHAR_SELECT
@8a96:  jsr     InitDMA1BG1ScreenA
        jsr     InitDMA2BG3ScreenA

; A button
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @8aac
        jsr     GetInventoryItemID
        cmp     #ITEM::RENAME_CARD
        beq     @8ac0                   ; branch if rename card
        jsr     @8ae7
@8aac:  lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @8abf                   ; return if B button is not pressed
        jsr     PlayCancelSfx

@8ab5:  lda     #$42
        trb     z45
        lda     #MENU_STATE::ITEM_CHAR_RETURN
        sta     zNextMenuState
        stz     zMenuState
@8abf:  rts

; item $e7: rename card
@8ac0:  jsr     GetTargetCharPtr
        lda     0,y                     ; actor index
        cmp     #CHAR_PROP::BANON
        bcs     @8ae0                   ; branch if actor index >= 14
        sty     r0206
        jsr     PlaySelectSfx
        lda     #$fe                    ; return code $fe (rename card)
        sta     r0205
        lda     #MENU_STATE::TERMINATE  ; terminate menu after fade out
        sta     zNextMenuState
        stz     zMenuState              ; menu state $00 (fade out)
        lda     #ITEM::RENAME_CARD
        jmp     DecItemQty
@8ae0:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; try to use item
@8ae7:  jsr     GetInventoryItemID
        jsr     GetTargetCharPtr
        jsr     CheckCanUseItem
        bcc     @8b0a                   ; branch if not valid
        jsr     PlayCureSfx
        jsr     _c38b11
        jsr     ItemTargetDrawQty
        jsr     _c32c01
        clr_a
        lda     zSelIndex                     ; item index
        tay
        lda     $1969,y                 ; remaining quantity
        bne     @8b10                   ; loop if there are items left
        jmp     @8ab5                   ; otherwise, return to item select
@8b0a:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@8b10:  rts

; ------------------------------------------------------------------------------

; [ use restorative item ]

_c38b11:
@8b11:  jsr     _c38b1a
        jsr     GetInventoryItemID
        jmp     DecItemQty

; ------------------------------------------------------------------------------

; [ restore hp/mp/status (item) ]

_c38b1a:
itemexec:
@8b1a:  lda     $0014,y                 ; copy status 1 & 4
        sta     zf8
        lda     $0015,y
        sta     zfb
        phy
        jsr     GetInventoryItemID
        ldx     #$0002                  ; 2: item effect
        jsl     CalcMagicEffect_ext
        ply
        lda     zfc
        sta     $0014,y                 ; set status 1 & 4
        lda     zff
        sta     $0015,y
        jmp     _c38c33

; ------------------------------------------------------------------------------

; [ check if item can be used ]

; +y: pointer to character data (+$1600)
; carry: clear = invalid, set = valid (out)

CheckCanUseItem:
@8b3d:  lda     $0014,y
        and     #STATUS1::DEAD
        bne     @8b85                   ; could use bmi instead

; selected character does not have wound status
        jsr     GetInventoryItemID
        cmp     #ITEM::DRIED_MEAT
        beq     @8bc4
        cmp     #ITEM::TONIC
        beq     @8bc4
        cmp     #ITEM::POTION
        beq     @8bc4
        cmp     #ITEM::X_POTION
        beq     @8bc4
        cmp     #ITEM::TINCTURE
        beq     @8bd5
        cmp     #ITEM::ETHER
        beq     @8bd5
        cmp     #ITEM::X_ETHER
        beq     @8bd5
        cmp     #ITEM::REVIVIFY
        beq     @8b8e
        cmp     #ITEM::ANTIDOTE
        beq     @8bbb
        cmp     #ITEM::EYEDROP
        beq     @8b97
        cmp     #ITEM::SOFT
        beq     @8ba0
        cmp     #ITEM::REMEDY
        beq     @8bb2
        cmp     #ITEM::ELIXIR
        beq     @8be5
        cmp     #ITEM::GREEN_CHERRY
        beq     @8ba9
        cmp     #ITEM::SLEEPING_BAG
        beq     @8bd2
        bra     @8bd0       ; all other items are invalid

; selected character has wound status
@8b85:  jsr     GetInventoryItemID
        cmp     #ITEM::FENIX_DOWN
        beq     @8be3
        bra     @8bd0

; revivify
@8b8e:  lda     $0014,y
        and     #STATUS1::ZOMBIE
        beq     @8bd0
        bra     @8be3

; eyedrop
@8b97:  lda     $0014,y
        and     #STATUS1::BLIND
        beq     @8bd0
        bra     @8be3

; soft
@8ba0:  lda     $0014,y
        and     #STATUS1::PETRIFY
        beq     @8bd0
        bra     @8be3

; green cherry
@8ba9:  lda     $0014,y
        and     #STATUS1::IMP
        beq     @8bd0
        bra     @8be3

; remedy
@8bb2:  lda     $0014,y
        andflg  STATUS1, {PETRIFY, IMP, POISON, BLIND}
        beq     @8bd0
        bra     @8be3

; antidote
@8bbb:  lda     $0014,y
        and     #STATUS1::POISON
        beq     @8bd0
        bra     @8be3

; dried meat, tonic, potion, x-potion
@8bc4:  lda     $0014,y
        andflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @8bd0
        jsr     CheckMaxHP
        bcc     @8be3
@8bd0:  clc                 ; item is invalid
        rts

; sleeping bag
@8bd2:  jmp     @8c11

; tincture, ether, x-ether
@8bd5:  lda     $0014,y
        andflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @8bd0
        jsr     CheckMaxMP
        bcc     @8be3
        bra     @8bd0

; fenix down
@8be3:  sec                 ; item is valid
        rts

; elixir
@8be5:  lda     $0014,y
        andflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @8bd0
        jsr     CheckMaxHP
        bcc     @8be3
        jsr     CheckMaxMP
        bcc     @8be3
        bra     @8bd0

; tent/megalixir ??? (unused)
        clr_ax
@8bfa:  stx     zed
        ldy     a:zCharPropPtr,x     ; check each character in the party
        beq     @8c06
        jsr     @8be5       ; check if elixir is valid
        bcs     @8be3
@8c06:  ldx     zed
        inx2                ; next character
        cpx     #8
        bne     @8bfa
        bra     @8bd0

; sleeping bag
@8c11:  lda     $0014,y
        andflg  STATUS1, {DEAD, PETRIFY, IMP, VANISH, POISON, ZOMBIE, BLIND}
        bne     @8be3
        lda     $0015,y
        and     #STATUS4::FLOAT
        bne     @8be3
        jsr     CheckMaxHP
        bcc     @8be3
        jsr     CheckMaxMP
        bcc     @8be3
        bra     @8bd0

; ------------------------------------------------------------------------------

; [ get item index ]

; $28: inventory slot (zSelIndex)

GetInventoryItemID:
@8c2b:  clr_a
        lda     zSelIndex
        tax
        lda     $1869,x
        rts

; ------------------------------------------------------------------------------

; [ restore hp/mp (item) ]

lpitem_exec:
_c38c33:
@8c33:  phy
        jsr     GetInventoryItemID
        jsr     GetItemPropPtr
        ply
        ldx     hMPYL
        stx     zb0
        jsr     _c38ccd
        lda     f:ItemProp+19,x         ; item properties
        bmi     @8c76                   ; branch if item affects 16ths of max value

; restore specific value
        and     #$08
        beq     @8c5c                   ; branch if item doesn't restore hp
        longa_clc
        lda     zb2
        adc     $0009,y                 ; add hp
        sta     $0009,y
        shorta
        jsr     CheckMaxHP
@8c5c:  ldx     zb0
        lda     f:ItemProp+19,x
        and     #$10
        beq     @8c75                   ; branch if item doesn't restore mp
        longa_clc
        lda     zb2
        adc     $000d,y                 ; add mp
        sta     $000d,y
        shorta
        jsr     CheckMaxMP
@8c75:  rts

; restore 16ths of max value
@8c76:  lda     f:ItemProp+19,x
        and     #$08
        beq     @8ca0                   ; branch if item doesn't restore hp
        lda     $000b,y
        sta     zf3
        lda     $000c,y
        sta     zf4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        jsr     _c38cd6
        longa_clc
        lda     ze9
        adc     $0009,y                 ; add to hp
        sta     $0009,y
        shorta
        jsr     CheckMaxHP
@8ca0:  ldx     zb0
        lda     f:ItemProp+19,x
        and     #$10
        beq     @8ccc                   ; branch if item doesn't restore mp
        lda     $000f,y
        sta     zf3
        lda     $0010,y
        sta     zf4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        jsr     _c38cd6
        longa_clc
        lda     ze9
        adc     $000d,y                 ; add to mp
        sta     $000d,y
        shorta
        jsr     CheckMaxMP
@8ccc:  rts

; ------------------------------------------------------------------------------

; [ load item hp/mp restored ]

_c38ccd:
lpget:
@8ccd:  lda     f:ItemProp+20,x         ; hp/mp restored
        sta     zb2_L
        stz     zb2_H
        rts

; ------------------------------------------------------------------------------

; [ calculate fraction of max hp/mp restored ]

_c38cd6:
par16:
@8cd6:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @8cd6
        lda     zf3
        sta     hM7A
        lda     zf4
        sta     hM7A
        lda     zb2
        sta     hM7B
        sta     hM7B
        lda     hMPYH
        sta     zeb
        stz     zec
        longa
        lda     hMPYL
        sta     ze9
        .repeat 4
        lsr     zeb
        ror     ze9
        .endrep
        shorta
        rts

; ------------------------------------------------------------------------------

ItemOptionTextList:
        .addr   ItemOptionUseText
        .addr   ItemOptionArrangeText
        .addr   ItemOptionRareText
        calc_size ItemOptionTextList

ItemTitleText:                  pos_text ITEM_TITLE
ItemOptionUseText:              pos_text ITEM_OPTION_USE
ItemOptionArrangeText:          pos_text ITEM_OPTION_ARRANGE
ItemOptionRareText:             pos_text ITEM_OPTION_RARE

ItemUsageText:
        raw_text ITEM_USAGE_MSG
        calc_size ItemUsageText

; stat names
ItemStatTextList1:
        .addr   ItemStrengthText
        .addr   ItemStaminaText
        .addr   ItemMagPwrText
        .addr   ItemEvadeText
        .addr   ItemMBlockText
        .addr   ItemStrengthSepText
        .addr   ItemSpeedSepText
        .addr   ItemStaminaSepText
        .addr   ItemMagPwrSepText
        .addr   ItemBatPwrSepText
        .addr   ItemDefenseSepText
        .addr   ItemEvadeSepText
        .addr   ItemMagDefSepText
        .addr   ItemMBlockSepText
        calc_size ItemStatTextList1

ItemStatTextList2:
        .addr   ItemSpeedText
        .addr   ItemAttackPwrText
        .addr   ItemDefenseText
        .addr   ItemMagDefText
        calc_size ItemStatTextList2

; element defense type names
ItemElementTextList:
        .addr   ItemElementHalfText
        .addr   ItemElementAbsorbText
        .addr   ItemElementNullText
        .addr   ItemElementWeakText
        calc_size ItemElementTextList

ItemUnknownAttackText:          pos_text ITEM_UNKNOWN_ATTACK
ItemStrengthText:               pos_text ITEM_STRENGTH
ItemStaminaText:                pos_text ITEM_STAMINA
ItemMagPwrText:                 pos_text ITEM_MAG_PWR
ItemEvadeText:                  pos_text ITEM_EVADE
ItemMBlockText:                 pos_text ITEM_MAG_EVADE
ItemStrengthSepText:            pos_text ITEM_STAT_SEP 15
ItemSpeedSepText:               pos_text ITEM_STAT_SEP 17
ItemStaminaSepText:             pos_text ITEM_STAT_SEP 19
ItemMagPwrSepText:              pos_text ITEM_STAT_SEP 21
ItemBatPwrSepText:              pos_text ITEM_STAT_SEP 23
ItemDefenseSepText:             pos_text ITEM_STAT_SEP 25
ItemEvadeSepText:               pos_text ITEM_STAT_SEP 27
ItemMagDefSepText:              pos_text ITEM_STAT_SEP 29
ItemMBlockSepText:              pos_text ITEM_STAT_SEP 31
ItemSpeedText:                  pos_text ITEM_SPEED
ItemAttackPwrText:              pos_text ITEM_ATTACK_PWR
ItemDefenseText:                pos_text ITEM_DEFENSE
ItemMagDefText:                 pos_text ITEM_MAG_DEF
ItemElementHalfText:            pos_text ITEM_ELEMENT_HALF
ItemElementAbsorbText:          pos_text ITEM_ELEMENT_ABSORB
ItemElementNullText:            pos_text ITEM_ELEMENT_NULL
ItemElementWeakText:            pos_text ITEM_ELEMENT_WEAK
ItemAttackElementText:          pos_text ITEM_ATTACK_ELEMENT
ItemBushidoText:                pos_text ITEM_BUSHIDO
ItemRunicText:                  pos_text ITEM_RUNIC
Item2HandText:                  pos_text ITEM_2HAND
ItemOwnedText:                  pos_text ITEM_OWNED
ItemBlankQtyText:               pos_text ITEM_BLANK_QTY

; ------------------------------------------------------------------------------
