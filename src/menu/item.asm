
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

inc_lang "text/item_desc_%s.inc"
inc_lang "text/item_name_%s.inc"
.if LANG_EN
inc_lang "text/item_type_name_%s.inc"
.endif
inc_lang "text/rare_item_desc_%s.inc"
inc_lang "text/rare_item_name_%s.inc"

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
        make_cursor_prop {0, 0}, {1, 10}, NO_Y_WRAP

ItemListCursorPos:
.repeat 10, i
        .byte   8, $5c + i * 12
.endrep

.else

ItemListCursorProp:
        make_cursor_prop {0, 0}, {2, 10}, NO_Y_WRAP

ItemListCursorPos:
.repeat 10, i
        .byte   $08, $5c + i * 12
        .byte   $78, $5c + i * 12
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
        make_cursor_prop {0, 0}, {2, 10}

RareItemCursorPos:
.repeat 10, i
        .byte   $08, $5c + i * 12
        .byte   $78, $5c + i * 12
.endrep

.else

RareItemCursorProp:
        make_cursor_prop {0, 0}, {3, 10}

RareItemCursorPos:
.repeat 10, i
        .byte   $08, $5c + i * 12
        .byte   $50, $5c + i * 12
        .byte   $98, $5c + i * 12
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
        sty     w0234
        rts

; ------------------------------------------------------------------------------

; item option cursor (top of item menu)
ItemOptionCursorProp:
        make_cursor_prop {0, 0}, {3, 1}, NO_Y_WRAP

ItemOptionCursorPos:
.if LANG_EN
@7d9d:  .byte   $40,$16,$68,$16,$b0,$16
.else
        .byte   $40,$16,$70,$16,$a8,$16
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
        jsr     _c3a9a9
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

ItemTitleWindow:                        make_window BG2A, {1, 1}, {4, 2}
ItemOptionsWindow:                      make_window BG2A, {7, 1}, {22, 2}
ItemDescWindow:                         make_window BG2A, {1, 5}, {28, 3}
ItemListWindow:                         make_window BG2A, {1, 10}, {28, 15}
ItemDetailsWindow1:                     make_window BG2B, {18, 1}, {13, 24}
ItemDetailsWindow2:                     make_window BG2A, {30, 0}, {1, 24}

; ------------------------------------------------------------------------------

; [ init bg scrolling hdma (item list) ]

InitItemBGScrollHDMA:
@7e2b:  lda     #$02
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near ItemBG1HScrollHDMATbl
        sty     hDMA5::ADDR
        lda     #^ItemBG1HScrollHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^ItemBG1HScrollHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        jsr     LoadItemBG1VScrollHDMATbl
        ldx     z0
@7e4e:  lda     f:ItemBG3VScrollHDMATbl,x
        sta     $7e9a09,x
        inx
        cpx     #sizeof_ItemBG3VScrollHDMATbl
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
@7e95:  ldx     z0
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

; bg3 vertical scroll hdma table (item list)
begin_block ItemBG3VScrollHDMATbl
        hdma_word 40, $0100
        hdma_word 47, $0100
        hdma_word 120, $0000
        hdma_word 30, $0100
        hdma_end
end_block ItemBG3VScrollHDMATbl

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

; bg1 horizontal scroll hdma table (item list)
ItemBG1HScrollHDMATbl:
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

make_jump_label UpdateListText, LIST_TYPE::ITEM
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

        jmp     LoadItemTypeName

.else

        clr_a
        lda     $e5
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

LoadItemTypeName:
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
        ldy     #ITEM_TYPE_NAME_SIZE
@801a:  lda     f:ItemTypeName,x
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
        ldy     #ITEM_TYPE_NAME_SIZE
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
@8045:  lda     w0200       ; menu mode
        cmp     #$03
        beq     @8085       ; branch if shop
        cmp     #$07
        beq     @8085       ; branch if colosseum
        bra     @8056
        clr_a
        lda     $4b
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
@808f:  lda     w0201
        bmi     @8085       ; white text if on a save point
        bra     @808a       ; gray text if not

; warp stone
@8096:  lda     w0201
        bit     #$02
        bne     @8085       ; white text if warp is enabled
        bra     @808a       ; gray text if warp is enabled

; ------------------------------------------------------------------------------

; [ get tilemap offset (bg1, screen A) ]

; A: vertical position
; X: horizontal position

GetBG1TilemapPtr:
@809f:  xba
        lda     z0
        xba
        longa
        asl6
        sta     $e7
        txa
        asl
        clc
        adc     $e7
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
        cmp     #$ff                    ; branch if empty
        beq     _80f6

_c380ce:
@80ce:  sta     hM7A                    ; multiply by 13 to get pointer to item name
        stz     hM7A
        lda     #ITEM_NAME_SIZE
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #ITEM_NAME_SIZE
@80e2:  lda     f:ItemName,x            ; item name
        sta     hWMDATA
        inx
        dey
        bne     @80e2
        lda     #COLON_CHAR
        sta     hWMDATA
        stz     hWMDATA
        rts

_80f6:  ldy     #ITEM_NAME_SIZE+3                     ; store 16 spaces (empty)
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
        lda     #$03        ; set thread state to 3
        sta     near wTaskState,x
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
@81bc:  ldy     z0          ; clear bg1 vscroll speed
        sty     zTextScrollRate
        lda     #$20        ; disable bg1 text scrolling
        trb     z46
        clc                 ; terminate thread
        rts

; ------------------------------------------------------------------------------

; [ update cursor movement (scrolling list) ]

_81c6:  rts

MoveListCursor:
@81c7:  lda     zWaitCounter         ; return if waiting for menu state counter
        bne     _81c6

; up button pressed
        lda     z0a+1         ; branch if up button is not pressed
        bit     #$08
        beq     @81ea
        lda     $4e         ; cursor y position (relative to page)
        bne     @81e2       ; branch if not at top of page
        lda     $4a         ; return if at top of first page
        beq     _81c6
        dec     $50         ; decrement absolute cursor position
        jsr     ScrollListUp
        jsr     PlayMoveSfx
        rts
@81e2:  dec     $50         ; decrement absolute cursor position
        dec     $4e         ; decrement relative cursor position
        jsr     PlayMoveSfx
        rts

; down button pressed
@81ea:  lda     z0a+1
        bit     #$04
        beq     @8210
        lda     $54
        dec
        cmp     $4e
        bne     @8209
        lda     $4a
        cmp     $5c
        beq     @8206
        inc     $50
        jsr     ScrollListDown
        jsr     PlayMoveSfx
        rts
@8206:  jmp     @8285
@8209:  inc     $50
        inc     $4e
        jsr     PlayMoveSfx

; left button pressed
@8210:  lda     z0a+1
        bit     #$02
        beq     @8249
        lda     $4d
        bne     @8241
        lda     $4e
        beq     @822d
        dec     $4e         ; decrement relative cursor position
        dec     $50         ; decrement absolute cursor position
        lda     $53
        dec
        sta     $4d         ; x position = max x position
        sta     $4f
        jsr     PlayMoveSfx
        rts
@822d:  lda     $4a
        beq     _81c6
        jsr     ScrollListUp
        lda     $53
        dec
        sta     $4d
        sta     $4f
        dec     $50
        jsr     PlayMoveSfx
        rts
@8241:  dec     $4d
        dec     $4f
        jsr     PlayMoveSfx
        rts

; right button pressed
@8249:  lda     z0a+1
        bit     #$01
        beq     @8285
        lda     $53
        dec
        cmp     $4d
        bne     @827e
        lda     $54
        dec
        cmp     $4e
        beq     @826a
        clr_a
        sta     $4d
        sta     $4f
        inc     $4e
        inc     $50
        jsr     PlayMoveSfx
        rts
@826a:  lda     $4a
        cmp     $5c
        beq     @8285
        jsr     ScrollListDown
        clr_a
        sta     $4d
        sta     $4f
        inc     $50
        jsr     PlayMoveSfx
        rts
@827e:  inc     $4d
        inc     $4f
        jsr     PlayMoveSfx
@8285:  rts

; ------------------------------------------------------------------------------

; [ scroll list up ]

ScrollListUp:
@8286:  dec     $4a         ; decrement page scroll position
        dec     $49         ; decrement vertical scroll position
        jsr     GetListTextPos
        jsr     UpdateListText
        lda     #0
        ldy     #near TextScrollTask
        jsr     CreateTask
        clr_a
        sta     wTaskState,x   ; set thread state to 0 (scroll up)
        rts

; ------------------------------------------------------------------------------

; [ scroll list down ]

ScrollListDown:
@829e:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @829e
        lda     $5a
        clc
        adc     $4a
        sta     hM7A
        stz     hM7A
        lda     $5b
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        sta     $e5
        lda     $49
        clc
        adc     $5a
        asl
        and     #$1f
        sta     $e6
        inc     $4a
        inc     $49
        jsr     UpdateListText
        lda     #0
        ldy     #near TextScrollTask
        jsr     CreateTask
        lda     #$01
        sta     wTaskState,x               ; thread state 1 (scroll down)
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
        make_jump_tbl UpdateListText, 6

; ------------------------------------------------------------------------------

; [ init item description ]

InitItemDesc:
@82f1:  jsr     GetItemDescPtr
        clr_a
        lda     $4b
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
        stx     $e7
        ldx     #near ItemDesc
        stx     $eb
        lda     #^ItemDescPtrs
        sta     $e9
        lda     #^ItemDesc
        sta     $ed
        ldx     #$9ec9
        stx     hWMADDL
        rts

; ------------------------------------------------------------------------------

; [ calculate pointer to item data ]

;      a = item number
; +$2134 = pointer (+$d85000)

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
        stx     $e7
        ldx     #near RareItemDesc
        stx     $eb
        lda     #^RareItemDescPtrs
        sta     $e9
        sta     $ed
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
        cmp     #$ff
        beq     @8361
        iny
@8361:  inx
        cpx     #$0100
        bne     @8359
        tya
        sta     $64
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
        sta     $64
        rts

; ------------------------------------------------------------------------------

; [ draw item count ]

DrawItemCount:
@837a:  lda     $64
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
        stx     $ef
        lda     $1ebc
        sta     $f1
        lda     $1ebd
.if LANG_EN
        and     #$0f
        stz     $f2
.else
        and     #$3f                    ; 30 bits for japanese version
        sta     $f2
.endif
        clr_a
        sta     $e0
        tax
        lda     #$04
        sta     $e1
@83c4:  ldy     #$0008
        lda     $ef,x
@83c9:  ror
        pha
        bcc     @83d2
        lda     $e0
        sta     hWMDATA
@83d2:  inc     $e0
        pla
        dey
        bne     @83c9
        inx
        dec     $e1
        bne     @83c4
        rts

; ------------------------------------------------------------------------------

; [ draw rare item list ]

DrawRareItemList:
@83de:  jsr     GetListTextPos
        stz     $e5
        ldy     #10
@83e6:  phy
        jsr     DrawRareItemListRow
        lda     $e6
        inc
        inc
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @83e6
        rts

; ------------------------------------------------------------------------------

; [ calculate text position ]

; $e5 = index of selected item in list
; $e6 = vertical position in bg1 data

GetListTextPos:
@83f7:  lda     $49                     ; vertical scroll position
        asl
        and     #$1f
        sta     $e6
@83fe:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @83fe
        lda     $4a                     ; page scroll position * page width
        sta     hM7A
        stz     hM7A
        lda     $5b
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        sta     $e5
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
        ldx     #RARE_ITEM_NAME_SIZE+4
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
@8436:  ldy     #RARE_ITEM_NAME_SIZE
        sty     $eb
        ldy     #near RareItemName
        sty     $ef
        lda     #^RareItemName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [ draw rare item name ]

; X: text x position

DrawRareItemName:
@8445:  lda     $e6
.if LANG_EN
        inc
.endif
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
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
        lda     $eb
        sta     hM7B
        sta     hM7B
        ldy     hMPYL
        ldx     $eb
@848a:  lda     [$ef],y
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
        lda     $4b
        sta     zSelIndex
        tay
        lda     $1869,y                 ; item
        cmp     #$ff
        beq     @8510                   ; branch if slot is empty
        cmp     #$ef
        beq     @8510                   ; branch if ???
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
        cmp     #$f7
        beq     @84f8                   ; branch if a tent was used
        cmp     #$f6
        beq     @84e2                   ; branch if a sleeping bag was used
        cmp     #$fd
        beq     @84eb                   ; branch if a warp stone was used
@84d3:  ldy     $4f
        sty     $8e
        lda     $4a
        sta     $90
        lda     #$6f                    ; menu state $6f (select item target)
        sta     zNextMenuState
        stz     zMenuState
        rts

; sleeping bag
@84e2:  sta     $e6
        lda     w0201
        bpl     @8510                   ; branch if not on a save point
        bra     @84d3                   ; go to character select

; warp stone
@84eb:  sta     $e6
        lda     w0201
        bit     #$02
        beq     @8510                   ; branch if warp is disabled
        lda     #$03                    ; return code $03 (warp/warp stone)
        bra     @8501

; tent
@84f8:  sta     $e6
        lda     w0201
        bpl     @8510                   ; branch if not on a save point
        lda     #$02                    ; return code $02 (tent)
@8501:  sta     w0205
        lda     $e6
        jsr     DecItemQty
        lda     #$ff                    ; terminate menu after fade out
        sta     zNextMenuState
        stz     zMenuState                     ; menu state $00 (fade out)
        rts
@8510:  lda     #$08                    ; menu state $08 (item select)
        sta     zMenuState
        rts

; not a useable item, show item details
@8515:  ldy     #$9d89
        sty     hWMADDL
        cmp     #$00
        beq     @8510                   ; branch if a tool (back to item select)
        stz     $e0
        longa
        lda     f:ItemProp+1,x          ; equippable characters
        ldx     z0
@8529:  lsr
        bcc     @8537                   ; skip characters that can't equip this item
        pha
        shorta
        lda     $e0
        sta     hWMDATA                 ; store character index
        longa
        pla
@8537:  shorta
        inc     $e0                     ; increment character index
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
        lda     $4b                     ; selected item
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
        lda     #$64                    ; menu state $64 (item details)
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
        sta     wTaskPosY,x             ; y position
        clr_a
        sta     wTaskPosY + 1,x
        rts

; ------------------------------------------------------------------------------

; [ load " can be used by:" text to buffer ]

_c385ad:
@85ad:  ldx     #$0001
@85b0:  lda     $7e9e8b,x
        cmp     #$ff
        bne     @85cd
@85b8:  ldy     z0
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
        cpx     #ITEM_NAME_SIZE
        bne     @85b0
        bra     @85b8

; ------------------------------------------------------------------------------

; [ draw equippable character names ]

_c385d5:
@85d5:  ldx     #$9e09
        stx     hWMADDL
        ldx     z0
@85dd:  lda     $7e9d89,x
        bmi     @8623                   ; branch if no character
        sta     $e5
        ldy     z0
        sty     $e7
@85e9:  stx     $f3
        lda     $e5
        cmp     $1600,y
        bne     @860a
        longa
        lda     $e7
        asl
        tax
        lda     $1edc                   ; initialized characters
        and     f:CharEquipMaskTbl,x
        shorta
        beq     @861b                   ; branch if character is not initialized
        lda     $e7
        sta     hWMDATA
        bra     @861b
@860a:  longa_clc                          ; check next character
        tya
        adc     #$0025
        tay
        shorta
        inc     $e7
        lda     $e7
        cmp     #$10
        bne     @85e9
@861b:  ldx     $f3
        inx
        cpx     #$0010
        bne     @85dd
@8623:  lda     #$ff
        sta     hWMDATA
.if LANG_EN
        ldx     z0
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
.repeat 5, yy
.repeat 3, xx
.if LANG_EN
        make_pos BG3A, {3 + xx * 10, 23 + yy * 2}
.else
        make_pos BG3A, {3 + xx * 10, 22 + yy * 2}
.endif
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
        lda     $4b                     ; cursor position
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
        sty     $e7
        jsr     _c38795
@876e:  ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #WEAPON_FLAG::TWO_HAND
        beq     @8781
        ldy     #near Item2HandText
        sty     $e7
        jsr     _c38795
@8781:  ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #WEAPON_FLAG::SWDTECH
        beq     @8794
        ldy     #near ItemBushidoText
        sty     $e7
        jsr     _c38795
@8794:  rts

; ------------------------------------------------------------------------------

; [ draw weapon property name text (runic, 2-hand, swdtech) ]

_c38795:
@8795:  lda     #^*                     ; bank byte of text pointer
        sta     $e9
        jmp     DrawPosTextFar

; ------------------------------------------------------------------------------

; [ draw weapon's battle power ]

DrawWeaponPower:
@879c:  clr_a
        lda     $4b
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
        sta     $e0
        lda     f:ItemProp+4,x   ; spell learned
        sta     $e1
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
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

; c3/8854: "  0", "+10", "+20", "+30", "+40", "+50", "-10", "-20", "-30", "-40", "-50"

EvadeModifierTextTbl:
.if LANG_EN
@8854:  .byte   $ff,$ff,$b4,$00
        .byte   $ca,$b5,$b4,$00
        .byte   $ca,$b6,$b4,$00
        .byte   $ca,$b7,$b4,$00
        .byte   $ca,$b8,$b4,$00
        .byte   $ca,$b9,$b4,$00
        .byte   $c4,$b5,$b4,$00
        .byte   $c4,$b6,$b4,$00
        .byte   $c4,$b7,$b4,$00
        .byte   $c4,$b8,$b4,$00
        .byte   $c4,$b9,$b4,$00
.else
        .byte   $ff,$ff,$53,$00
        .byte   $d3,$54,$53,$00
        .byte   $d3,$55,$53,$00
        .byte   $d3,$56,$53,$00
        .byte   $d3,$57,$53,$00
        .byte   $d3,$58,$53,$00
        .byte   $c5,$54,$53,$00
        .byte   $c5,$55,$53,$00
        .byte   $c5,$56,$53,$00
        .byte   $c5,$57,$53,$00
        .byte   $c5,$58,$53,$00
.endif

; c3/8880: " 0", "+1", "+2", "+3", "+4", "+5", "-1", "-2", "-3", "-4", "-5"

StatModifierTextTable:
.if LANG_EN
@8880:  .byte   $ff,$b4,$ca,$b5,$ca,$b6,$ca,$b7,$ca,$b8,$ca,$b9,$ca,$ba,$ca,$bb
        .byte   $ff,$b4,$c4,$b5,$c4,$b6,$c4,$b7,$c4,$b8,$c4,$b9,$c4,$ba,$c4,$bb
.else
        .byte   $ff,$53,$d3,$54,$d3,$55,$d3,$56,$d3,$57,$d3,$58,$d3,$59,$d3,$5a
        .byte   $ff,$53,$c5,$54,$c5,$55,$c5,$56,$c5,$57,$c5,$58,$c5,$59,$c5,$5a
.endif

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
        stz     $e0
        ldy     #$0008
@88b9:  rol
        bcc     @88c3
        pha
        lda     $e0
        sta     hWMDATA
        pla
@88c3:  inc     $e0
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
        stx     $eb
        lda     #^wBG3Tiles
        sta     $ed
        jmp     _88fe

; absorbed elements
_c388da:
@88da:  ldx_pos BG3A, {16, 14}
        stx     $eb
        lda     #^wBG3Tiles
        sta     $ed
        jmp     _88fe

; no effect elements
_c388e6:
@88e6:  ldx_pos BG3A, {2, 18}
        stx     $eb
        lda     #^wBG3Tiles
        sta     $ed
        jmp     _88fe

; weak point elements
_c388f2:
@88f2:  ldx_pos BG3A, {16, 18}
        stx     $eb
        lda     #^wBG3Tiles
        sta     $ed
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
        sta     $e0
        jsr     _c38937
        lda     $eb
        clc
        adc     #$0004
        sta     $eb
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
        lda     $e0
        sta     [$eb],y
        inc     $e0
        ldy     #$0040
        lda     $e0
        sta     [$eb],y
        inc     $e0
        ldy     #$0002
        lda     $e0
        sta     [$eb],y
        inc     $e0
        ldy     #$0042
        lda     $e0
        sta     [$eb],y
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

MenuState_64:
@8983:  lda     z08
        bit     #JOY_A
        bne     @898f                   ; branch if A button is pressed
        lda     z08+1
        bit     #>JOY_LEFT
        beq     @89a8                   ; branch if left button is not pressed

; left button or A button
@898f:  jsr     PlaySelectSfx
        lda     #$ff
        sta     $99
        lda     #$0a
        sta     zWaitCounter
        ldy     #.loword(-12)
        sty     zMenuScrollRate
        lda     #$5e                    ; next menu state $5e (item stats)
        sta     zNextMenuState
        lda     #$65                    ; menu state $65 (scroll menu horizontal)
        sta     zMenuState
        rts

; B button
@89a8:  lda     z08+1
        bit     #>JOY_B
        beq     @89dd                   ; return if B button is not pressed
        jsr     PlayCancelSfx
        lda     #$ff
        sta     $99
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
        lda     #$08        ; menu state $08 (item, select)
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

MenuState_5e:
@89e6:  lda     z08+1
        bit     #>JOY_B
        bne     @89f2                   ; branch if B button is pressed
        lda     z08+1
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
        lda     #$64                    ; next menu state $64 (item details)
        sta     zNextMenuState
        lda     #$65                    ; menu state $65 (scroll menu horizontal)
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

ItemTargetCharWindow:                   make_window BG2A, {10, 1}, {19, 24}
.if LANG_EN
ItemTargetItemNameWindow:               make_window BG2A, {1, 1}, {13, 2}
.else
ItemTargetItemNameWindow:               make_window BG2A, {1, 1}, {8, 2}
.endif
ItemTargetQtyWindow:                    make_window BG2A, {1, 5}, {7, 3}

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

MenuState_6f:
@8a84:  jsr     _c32a76
        jsr     DrawItemTargetMenu
        jsr     CreateCursorTask
        lda     #$40
        tsb     z45
        lda     #$70
        jmp     _c32aa5

; ------------------------------------------------------------------------------

; [ menu state $70: use item (character select) ]

MenuState_70:
@8a96:  jsr     InitDMA1BG1ScreenA
        jsr     InitDMA2BG3ScreenA

; A button
        lda     z08
        bit     #JOY_A
        beq     @8aac
        jsr     GetInventoryItemID
        cmp     #ITEM::RENAME_CARD
        beq     @8ac0                   ; branch if rename card
        jsr     @8ae7
@8aac:  lda     z08+1
        bit     #>JOY_B
        beq     @8abf                   ; return if B button is not pressed
        jsr     PlayCancelSfx

@8ab5:  lda     #$42
        trb     z45
        lda     #$77                    ; menu state $77 (return to item select)
        sta     zNextMenuState
        stz     zMenuState
@8abf:  rts

; item $e7: rename card
@8ac0:  jsr     GetTargetCharPtr
        lda     0,y                     ; actor index
        cmp     #CHAR_PROP::BANON
        bcs     @8ae0                   ; branch if actor index >= 14
        sty     w0206
        jsr     PlaySelectSfx
        lda     #$fe                    ; return code $fe (rename card)
        sta     w0205
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
        and     #$02
        beq     @8bd0
        bra     @8be3

; eyedrop
@8b97:  lda     $0014,y
        and     #$01
        beq     @8bd0
        bra     @8be3

; soft
@8ba0:  lda     $0014,y
        and     #$40
        beq     @8bd0
        bra     @8be3

; green cherry
@8ba9:  lda     $0014,y
        and     #$20
        beq     @8bd0
        bra     @8be3

; remedy
@8bb2:  lda     $0014,y
        and     #$65        ; isolate petrify, imp, poison, dark
        beq     @8bd0
        bra     @8be3

; antidote
@8bbb:  lda     $0014,y
        and     #$04
        beq     @8bd0
        bra     @8be3

; dried meat, tonic, potion, x-potion
@8bc4:  lda     $0014,y
        and     #$c2
        bne     @8bd0
        jsr     CheckMaxHP
        bcc     @8be3
@8bd0:  clc                 ; item is invalid
        rts

; sleeping bag
@8bd2:  jmp     @8c11

; tincture, ether, x-ether
@8bd5:  lda     $0014,y
        and     #$c2        ; isolate wound, petrify, and zombie
        bne     @8bd0
        jsr     CheckMaxMP
        bcc     @8be3
        bra     @8bd0

; fenix down
@8be3:  sec                 ; item is valid
        rts

; elixir
@8be5:  lda     $0014,y
        and     #$c2        ; isolate wound, petrify, and zombie
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
        clrflg  STATUS1, MAGITEK
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
        sta     zb2
        stz     zb2+1
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

.if LANG_EN
; ##############################################################################
;       .define ItemTitleStr            {"Item\0"}
;       .define ItemOptionUseStr        {"Use\0"}
;       .define ItemOptionArrangeStr    {"Arrange\0"}
;       .define ItemOptionRareStr       {"Rare\0"}
;       .define ItemUsageStr            {" can be used by:\0"}
;       .define ItemUnknownAttackStr    {"???\0"}
; ##############################################################################
        .define ItemTitleStr            {$88,$ad,$9e,$a6,$00}
        .define ItemOptionUseStr        {$94,$92,$84,$00}
        .define ItemOptionArrangeStr    {$80,$91,$91,$80,$8d,$86,$84,$00}
        .define ItemOptionRareStr       {$91,$80,$91,$84,$00}
        .define ItemUsageStr            {$ff,$9c,$9a,$a7,$ff,$9b,$9e,$ff,$ae,$ac,$9e,$9d,$ff,$9b,$b2,$c1,$00}
        .define ItemUnknownAttackStr    {$bf,$bf,$bf,$00}  ; ???
        .define ItemStrengthStr         {$95,$a2,$a0,$a8,$ab,$00}  ; Vigor
        .define ItemStaminaStr          {$92,$ad,$9a,$a6,$a2,$a7,$9a,$00}  ; Stamina
        .define ItemMagPwrStr           {$8c,$9a,$a0,$c5,$8f,$b0,$ab,$00}  ; Mag.Pwr
        .define ItemEvadeStr            {$84,$af,$9a,$9d,$9e,$ff,$cd,$00}  ; Evade %
        .define ItemMBlockStr           {$8c,$81,$a5,$a8,$9c,$a4,$cd,$00}  ; MBlock%
        .define ItemSepStr              {$d3,$00}  ; 2-dot separator
        .define ItemSpeedStr            {$92,$a9,$9e,$9e,$9d,$00}  ; Speed
        .define ItemBatPwrStr           {$81,$9a,$ad,$c5,$8f,$b0,$ab,$00}  ; Bat.Pwr
        .define ItemDefenseStr          {$83,$9e,$9f,$9e,$a7,$ac,$9e,$00}  ; Defense
        .define ItemMagDefStr           {$8c,$9a,$a0,$c5,$83,$9e,$9f,$00}  ; Mag.Def
        .define ItemElementHalfStr      {$b9,$b4,$cd,$ff,$83,$a6,$a0,$00}  ; 50% Dmg
        .define ItemElementAbsorbStr    {$80,$9b,$ac,$a8,$ab,$9b,$ff,$87,$8f,$00}  ; Absorb HP
        .define ItemElementNullStr      {$8d,$a8,$ff,$84,$9f,$9f,$9e,$9c,$ad,$00}  ; No Effect
        .define ItemElementWeakStr      {$96,$9e,$9a,$a4,$ff,$a9,$ad,$00}  ; Weak pt
        .define ItemAttackElementStr    {$80,$ad,$ad,$9a,$9c,$a4,$00}
        .define ItemBushidoStr          {$92,$b0,$9d,$93,$9e,$9c,$a1,$00}
        .define ItemRunicStr            {$91,$ae,$a7,$a2,$9c,$00}
        .define Item2HandStr            {$b6,$c4,$a1,$9a,$a7,$9d,$00}
        .define ItemOwnedStr            {$8e,$b0,$a7,$9e,$9d,$c1,$00}
        .define ItemBlankQtyStr         {$ff,$ff,$ff,$00}

.else

;;;;    .define ItemTitleStr            {"アイテム",0}
        .define ItemTitleStr            {$8a,$8c,$84,$a0,$00}
        .define ItemOptionUseStr        {$83,$6b,$89,$00}
        .define ItemOptionArrangeStr    {$7b,$8d,$87,$b9,$00}
        .define ItemOptionRareStr       {$3f,$8d,$37,$93,$a5,$9b,$00}
        .define ItemUsageStr            {$bb,$ff,$7d,$89,$23,$45,$6d,$ab,$6c,$be,$a6,$6e,$7e,$c5,$00}
        .define ItemUnknownAttackStr    {$cb,$cb,$cb,$00}
        .define ItemStrengthStr         {$81,$6b,$a7,$00}
        .define ItemStaminaStr          {$7f,$8d,$a9,$c3,$6f,$00}
        .define ItemMagPwrStr           {$9d,$a9,$c3,$6f,$00}
        .define ItemEvadeStr            {$6b,$8d,$63,$a9,$83,$00}
        .define ItemMBlockStr           {$9d,$69,$89,$6b,$8d,$63,$a9,$83,$00}
        .define ItemSepStr              {$c7,$00}
        .define ItemSpeedStr            {$79,$21,$b1,$75,$00}
        .define ItemBatPwrStr           {$73,$89,$31,$6d,$a9,$c3,$6f,$00}
        .define ItemDefenseStr          {$29,$89,$2d,$c3,$00}
        .define ItemMagDefStr           {$9d,$69,$89,$29,$89,$2d,$c3,$00}
        .define ItemElementHalfStr      {$61,$b9,$31,$b9,$00}
        .define ItemElementAbsorbStr    {$6d,$c1,$89,$77,$c1,$89,$00}
        .define ItemElementNullStr      {$a1,$73,$89,$00}
        .define ItemElementWeakStr      {$37,$bf,$6f,$85,$b9,$00}
        .define ItemAttackElementStr    {$73,$89,$31,$6d,$00}
        .define ItemBushidoStr          {$63,$bd,$75,$83,$71,$b9,$ff,$2e,$2a,$00}
        .define ItemRunicStr            {$9d,$65,$89,$71,$b9,$ff,$ff,$2e,$2a,$00}
        .define Item2HandStr            {$a9,$c3,$89,$85,$a5,$81,$ff,$2e,$2a,$00}
        .define ItemOwnedStr            {$a5,$bd,$85,$8d,$ab,$6b,$39,$00}
        .define ItemBlankQtyStr         {$ff,$ff,$ff,$00}

.endif

begin_block ItemOptionTextList
        .addr   ItemOptionUseText
        .addr   ItemOptionArrangeText
        .addr   ItemOptionRareText
end_block ItemOptionTextList

.if LANG_EN
ItemTitleText:                  pos_text BG3A, {2, 3}, ItemTitleStr
ItemOptionUseText:              pos_text BG3A, {10, 3}, ItemOptionUseStr
ItemOptionArrangeText:          pos_text BG3A, {15, 3}, ItemOptionArrangeStr
ItemOptionRareText:             pos_text BG3A, {24, 3}, ItemOptionRareStr
.else
ItemTitleText:                  pos_text BG3A, {2, 2}, ItemTitleStr
ItemOptionUseText:              pos_text BG3A, {10, 2}, ItemOptionUseStr
ItemOptionArrangeText:          pos_text BG3A, {16, 2}, ItemOptionArrangeStr
ItemOptionRareText:             pos_text BG3A, {23, 2}, ItemOptionRareStr
.endif

begin_block ItemUsageText
        raw_text ItemUsageStr
end_block ItemUsageText

; stat names
begin_block ItemStatTextList1
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
end_block ItemStatTextList1

begin_block ItemStatTextList2
        .addr   ItemSpeedText
        .addr   ItemBatPwrText
        .addr   ItemDefenseText
        .addr   ItemMagDefText
end_block ItemStatTextList2

; element defense type names
begin_block ItemElementTextList
        .addr   ItemElementHalfText
        .addr   ItemElementAbsorbText
        .addr   ItemElementNullText
        .addr   ItemElementWeakText
end_block ItemElementTextList

ItemUnknownAttackText:          pos_text BG3B, {29, 23}, ItemUnknownAttackStr
ItemStrengthText:               pos_text BG3B, {19, 15}, ItemStrengthStr
ItemStaminaText:                pos_text BG3B, {19, 19}, ItemStaminaStr
ItemMagPwrText:                 pos_text BG3B, {19, 21}, ItemMagPwrStr
ItemEvadeText:                  pos_text BG3B, {19, 27}, ItemEvadeStr
ItemMBlockText:                 pos_text BG3B, {19, 31}, ItemMBlockStr
ItemStrengthSepText:            pos_text BG3B, {27, 15}, ItemSepStr
ItemSpeedSepText:               pos_text BG3B, {27, 17}, ItemSepStr
ItemStaminaSepText:             pos_text BG3B, {27, 19}, ItemSepStr
ItemMagPwrSepText:              pos_text BG3B, {27, 21}, ItemSepStr
ItemBatPwrSepText:              pos_text BG3B, {27, 23}, ItemSepStr
ItemDefenseSepText:             pos_text BG3B, {27, 25}, ItemSepStr
ItemEvadeSepText:               pos_text BG3B, {27, 27}, ItemSepStr
ItemMagDefSepText:              pos_text BG3B, {27, 29}, ItemSepStr
ItemMBlockSepText:              pos_text BG3B, {27, 31}, ItemSepStr
.if LANG_EN
ItemSpeedText:                  pos_text BG3B, {19, 17}, ItemSpeedStr
ItemBatPwrText:                 pos_text BG3B, {19, 23}, ItemBatPwrStr
ItemDefenseText:                pos_text BG3B, {19, 25}, ItemDefenseStr
ItemMagDefText:                 pos_text BG3B, {19, 29}, ItemMagDefStr
ItemElementHalfText:            pos_text BG3A, {2, 13}, ItemElementHalfStr
ItemElementAbsorbText:          pos_text BG3A, {16, 13}, ItemElementAbsorbStr
ItemElementNullText:            pos_text BG3A, {2, 17}, ItemElementNullStr
ItemElementWeakText:            pos_text BG3A, {16, 17}, ItemElementWeakStr
ItemAttackElementText:          pos_text BG3A, {2, 13}, ItemAttackElementStr
.else
ItemSpeedText:                  pos_text BG3B, {19, 16}, ItemSpeedStr
ItemBatPwrText:                 pos_text BG3B, {19, 22}, ItemBatPwrStr
ItemDefenseText:                pos_text BG3B, {19, 24}, ItemDefenseStr
ItemMagDefText:                 pos_text BG3B, {19, 28}, ItemMagDefStr
ItemElementHalfText:            pos_text BG3A, {2, 12}, ItemElementHalfStr
ItemElementAbsorbText:          pos_text BG3A, {16, 12}, ItemElementAbsorbStr
ItemElementNullText:            pos_text BG3A, {2, 16}, ItemElementNullStr
ItemElementWeakText:            pos_text BG3A, {16, 16}, ItemElementWeakStr
ItemAttackElementText:          pos_text BG3A, {2, 12}, ItemAttackElementStr
.endif
ItemBushidoText:                pos_text BG3B, {19, 7}, ItemBushidoStr
ItemRunicText:                  pos_text BG3B, {19, 9}, ItemRunicStr
Item2HandText:                  pos_text BG3B, {19, 11}, Item2HandStr
.if LANG_EN
ItemOwnedText:                  pos_text BG3A, {2, 7}, ItemOwnedStr
.else
ItemOwnedText:                  pos_text BG3A, {2, 6}, ItemOwnedStr
.endif
ItemBlankQtyText:               pos_text BG3A, {27, 9}, ItemBlankQtyStr

; ------------------------------------------------------------------------------

.export ItemProp

.pushseg
.segment "item_prop"

; d8/5000
ItemProp:
        incbin_lang "item_prop_%s.dat"

.popseg

; ------------------------------------------------------------------------------
