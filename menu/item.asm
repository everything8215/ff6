
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

.import ItemTypeName

; ------------------------------------------------------------------------------

; [ init cursor (item list) ]

LoadItemListCursor:
@7d1c:  ldy     #.loword(ItemListCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (item list) ]

UpdateItemListCursor:
@7d22:  jsr     MoveListCursor

InitItemListCursor:
@7d25:  ldy     #.loword(ItemListCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

ItemListCursorProp:
@7d2b:  .byte   $01,$00,$00,$01,$0a

ItemListCursorPos:
@7d30:  .byte   $08,$5c,$08,$68,$08,$74,$08,$80,$08,$8c,$08,$98,$08,$a4,$08,$b0
        .byte   $08,$bc,$08,$c8

; ------------------------------------------------------------------------------

; [ load cursor for rare items list ]

LoadRareItemCursor:
@7d44:  ldy     #.loword(RareItemCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for rare items list ]

UpdateRareItemCursor:
@7d4a:  jsr     MoveCursor

InitRareItemCursor:
@7d4d:  ldy     #.loword(RareItemCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

RareItemCursorProp:
@7d53:  .byte   $00,$00,$00,$02,$0a

RareItemCursorPos:
@7d58:  .byte   $08,$5c,$78,$5c
        .byte   $08,$68,$78,$68
        .byte   $08,$74,$78,$74
        .byte   $08,$80,$78,$80
        .byte   $08,$8c,$78,$8c
        .byte   $08,$98,$78,$98
        .byte   $08,$a4,$78,$a4
        .byte   $08,$b0,$78,$b0
        .byte   $08,$bc,$78,$bc
        .byte   $08,$c8,$78,$c8

; ------------------------------------------------------------------------------

; [ load cursor for item option (use, arrange, rare) ]

LoadItemOptionCursor:
@7d80:  ldy     #.loword(ItemOptionCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ init item option cursor ]

InitItemOptionCursor:
@7d86:  ldy     #.loword(ItemOptionCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; [ update item option cursor ]

UpdateItemOptionCursor:
@7d8c:  jsr     MoveCursor
        jsr     InitItemOptionCursor
        ldy     $4d
        sty     $0234
        rts

; ------------------------------------------------------------------------------

; item option cursor (top of item menu)
ItemOptionCursorProp:
@7d98:  .byte   $01,$00,00,$03,$01

ItemOptionCursorPos:
@7d9d:  .byte   $40,$16,$68,$16,$b0,$16

; ------------------------------------------------------------------------------

; [ init bg (item list) ]

DrawItemListMenu:
@7da3:  lda     #$01
        sta     hBG1SC
        ldy     #.loword(ItemDetailsWindow1)
        jsr     DrawWindow
        ldy     #.loword(ItemDetailsWindow2)
        jsr     DrawWindow
        ldy     #.loword(ItemOptionsWindow)
        jsr     DrawWindow
        ldy     #.loword(ItemTitleWindow)
        jsr     DrawWindow
        ldy     #.loword(ItemDescWindow)
        jsr     DrawWindow
        ldy     #.loword(ItemListWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     ClearBG3ScreenD
        lda     #$2c                    ; use teal font color
        sta     $29
        ldy     #.loword(ItemTitleText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        ldx     #.loword(ItemOptionTextList)
        ldy     #$0006
        jsr     DrawPosList
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

ItemTitleWindow:
@7e13:  .byte   $8b,$58,$04,$02

ItemOptionsWindow:
@7e17:  .byte   $97,$58,$16,$02

ItemDescWindow:
@7e1b:  .byte   $8b,$59,$1c,$03

ItemListWindow:
@7e1f:  .byte   $cb,$5a,$1c,$0f

ItemDetailsWindow1:
@7e23:  .byte   $ad,$60,$0d,$18

ItemDetailsWindow2:
@7e27:  .byte   $85,$58,$01,$18

; ------------------------------------------------------------------------------

; [ init bg scrolling hdma (item list) ]

InitItemBGScrollHDMA:
@7e2b:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(ItemBG1HScrollHDMATbl)
        sty     $4352
        lda     #^ItemBG1HScrollHDMATbl
        sta     $4354
        lda     #^ItemBG1HScrollHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        jsr     LoadItemBG1VScrollHDMATbl
        ldx     $00
@7e4e:  lda     f:ItemBG3VScrollHDMATbl,x
        sta     $7e9a09,x
        inx
        cpx     #$000d
        bne     @7e4e
        lda     #$02
        sta     $4360
        lda     #$0d
        sta     $4361
        ldy     #$9a09
        sty     $4362
        lda     #$7e
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$02
        sta     $4370
        lda     #$0e
        sta     $4371
        ldy     #$9849
        sty     $4372
        lda     #$7e
        sta     $4374
        lda     #$7e
        sta     $4377
        lda     #$c0
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ load bg1 vertical scroll hdma table (item list) ]

LoadItemBG1VScrollHDMATbl:
@7e95:  ldx     $00
@7e97:  lda     f:ItemBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        cpx     #$0012
        bne     @7e97
@7ea5:  lda     f:ItemBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        clr_a
        lda     $49
        asl4
        and     #$ff
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
ItemBG3VScrollHDMATbl:
@7eda:  .byte   $28
        .word   $0100
        .byte   $2f
        .word   $0100
        .byte   $78
        .word   $0000
        .byte   $1e
        .word   $0100
        .byte   $00

; ------------------------------------------------------------------------------

; bg1 vertical scroll hdma table (item list)
ItemBG1VScrollHDMATbl:
@7ee7:  .byte   $27
        .word   $0080
        .byte   $08
        .word   $0000
        .byte   $0c
        .word   $0004
        .byte   $0c
        .word   $0008
        .byte   $08
        .word   $0080
        .byte   $08
        .word   $0000
        .byte   $04
        .word   $ffac
        .byte   $04
        .word   $ffac
        .byte   $04
        .word   $ffac
        .byte   $04
        .word   $ffb0
        .byte   $04
        .word   $ffb0
        .byte   $04
        .word   $ffb0
        .byte   $04
        .word   $ffb4
        .byte   $04
        .word   $ffb4
        .byte   $04
        .word   $ffb4
        .byte   $04
        .word   $ffb8
        .byte   $04
        .word   $ffb8
        .byte   $04
        .word   $ffb8
        .byte   $04
        .word   $ffbc
        .byte   $04
        .word   $ffbc
        .byte   $04
        .word   $ffbc
        .byte   $04
        .word   $ffc0
        .byte   $04
        .word   $ffc0
        .byte   $04
        .word   $ffc0
        .byte   $04
        .word   $ffc4
        .byte   $04
        .word   $ffc4
        .byte   $04
        .word   $ffc4
        .byte   $04
        .word   $ffc8
        .byte   $04
        .word   $ffc8
        .byte   $04
        .word   $ffc8
        .byte   $04
        .word   $ffcc
        .byte   $04
        .word   $ffcc
        .byte   $04
        .word   $ffcc
        .byte   $04
        .word   $ffd0
        .byte   $04
        .word   $ffd0
        .byte   $04
        .word   $ffd0
        .byte   $1e
        .word   $0000
        .byte   $00

; ------------------------------------------------------------------------------

; bg1 horizontal scroll hdma table (item list)
ItemBG1HScrollHDMATbl:
@7f57:  .byte   $2f
        .word   $0000
        .byte   $0c
        .word   $0004
        .byte   $0c
        .word   $0008
        .byte   $0c
        .word   $000c
        .byte   $0c
        .word   $0010
        .byte   $0c
        .word   $0014
        .byte   $0c
        .word   $0018
        .byte   $0c
        .word   $001c
        .byte   $0c
        .word   $0020
        .byte   $0c
        .word   $0024
        .byte   $0c
        .word   $0028
        .byte   $0c
        .word   $002c
        .byte   $0c
        .word   $0030
        .byte   $0c
        .word   $0034
        .byte   $0c
        .word   $0038
        .byte   $0c
        .word   $003c
        .byte   $00

; ------------------------------------------------------------------------------

; [ init item list text (item menu) ]

DrawItemList:
@7f88:  jsr     GetListTextPos
        ldy     #10                     ; 10 lines
@7f8e:  phy
        jsr     DrawItemListRow
        inc     $e5
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply                             ; next line
        dey
        bne     @7f8e
        rts

; ------------------------------------------------------------------------------

; [ update item list text (item menu) ]

; $e5 = position in inventory
; $e6 = vertical position on screen

DrawItemListRow:
@7fa1:  clr_a
        lda     $e5                     ; position in inventory
        tay
        jsr     GetItemNameColor
        lda     $1969,y                 ; item quantity
        jsr     HexToDec3
        lda     $e6                     ; vertical position + 1
        inc
        ldx     #17                     ; horizontal position = 17
        jsr     GetBG1TilemapPtr
        jsr     DrawNum2
        lda     $e6                     ; vertical position + 1
        inc
        ldx     #3                      ; horizontal position = 3
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89                 ; set pointer to item text
        shorta
        clr_a
        lda     $e5                     ; position in inventory
        tay
        jsr     LoadListItemName
        jsr     DrawPosTextBuf
        jmp     LoadItemTypeName

; ------------------------------------------------------------------------------

; [ draw positioned text (at 7e/9e89) ]

DrawPosTextBuf:
@7fd9:  ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

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
        sta     $e0                     ; multiply by 7 to get pointer to symbol name
        asl2
        sta     $e2
        lda     $e0
        asl
        clc
        adc     $e2
        adc     $e0
        tax
        ldy     #$9e8b
        sty     hWMADDL
        ldy     #7                      ; 7 letters
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
        ldy     #7
        lda     #$ff
@8037:  sta     hWMDATA
        inx
        dey
        bne     @8037
        clr_a
        sta     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ update item text color ]

GetItemNameColor:
@8045:  lda     $0200       ; menu mode
        cmp     #$03
        beq     @8085       ; branch if shop
        cmp     #$07
        beq     @8085       ; branch if colosseum
        bra     @8056
        clr_a
        lda     $4b
        tay
@8056:  lda     $1869,y     ; item number
        cmp     #$ef        ; branch if megalixir
        beq     @808a
        cmp     #$ff        ; branch if empty
        beq     @8085
        cmp     #$f7        ; branch if tent
        beq     @808f
        cmp     #$f6        ; branch if sleeping bag
        beq     @808f
        cmp     #$fd        ; branch if warp stone
        beq     @8096
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$06
        bne     @808a       ; branch if not a useable item
        lda     f:ItemProp,x   ; branch if not useable on field
        and     #$40
        beq     @808a
@8085:  lda     #$20        ; white text
        sta     $29
        rts
@808a:  lda     #$28        ; gray text
        sta     $29
        rts

; tent/sleeping bag
@808f:  lda     $0201
        bmi     @8085       ; white text if on a save point
        bra     @808a       ; gray text if not

; warp stone
@8096:  lda     $0201
        bit     #$02
        bne     @8085       ; white text if warp is enabled
        bra     @808a       ; gray text if warp is enabled

; ------------------------------------------------------------------------------

; [ calculate pointer to bg1 tilemap ]

; A: vertical position
; X: horizontal position

GetBG1TilemapPtr:
@809f:  xba
        lda     $00
        xba
        longa
        asl6
        sta     $e7
        txa
        asl
        clc
        adc     $e7
        adc     #$3849
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
        lda     #13
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #13
@80e2:  lda     f:ItemName,x            ; item name
        sta     hWMDATA
        inx
        dey
        bne     @80e2
        lda     #$c1                    ; ":"
        sta     hWMDATA
        stz     hWMDATA
        rts
_80f6:  ldy     #$0010                  ; store 16 spaces (empty)
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
        lda     $20         ; menu state frame counter
        longa
        ldy     $41         ; bg1 vscroll speed
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
        jmp     (.loword(TextScrollTaskTbl),x)

TextScrollTaskTbl:
@8187:  .addr   TextScrollTask_00
        .addr   TextScrollTask_01
        .addr   TextScrollTask_02
        .addr   TextScrollTask_03

; ------------------------------------------------------------------------------

; state $00: init (scroll up)

TextScrollTask_00:
@818f:  ldx     $2d
        longa
        lda     #$fffc      ; set bg1 text scroll speed to -4
        sta     $41
        shorta
        bra     TextScrollTask_02

; ------------------------------------------------------------------------------

; state $01: init (scroll down)

TextScrollTask_01:
@819c:  ldx     $2d
        longa
        lda     #$0004      ; set bg1 text scroll speed to +4
        sta     $41
        shorta
; fallthrough

; ------------------------------------------------------------------------------

; state $02: init

TextScrollTask_02:
@81a7:  ldx     $2d
        lda     #$03        ; set thread state to 3
        sta     $3649,x
        sta     $20         ; set wait counter to 3

; ------------------------------------------------------------------------------

; state $03: update

TextScrollTask_03:
@81b0:  ldx     $2d
        lda     $20         ; wait counter
        beq     @81bc       ; branch when wait counter reaches zero
        lda     #$20
        tsb     $46         ; enable bg1 text scrolling
        sec
        rts
@81bc:  ldy     $00         ; clear bg1 vscroll speed
        sty     $41
        lda     #$20        ; disable bg1 text scrolling
        trb     $46
        clc                 ; terminate thread
        rts

; ------------------------------------------------------------------------------

; [ update cursor movement (scrolling list) ]

_81c6:  rts

MoveListCursor:
@81c7:  lda     $20         ; return if waiting for menu state counter
        bne     _81c6

; up button pressed
        lda     $0b         ; branch if up button is not pressed
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
@81ea:  lda     $0b
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
@8210:  lda     $0b
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
@8249:  lda     $0b
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
        ldy     #.loword(TextScrollTask)
        jsr     CreateTask
        clr_a
        sta     $7e3649,x   ; set thread state to 0 (scroll up)
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
        ldy     #.loword(TextScrollTask)
        jsr     CreateTask
        lda     #$01
        sta     $7e3649,x               ; thread state 1 (scroll down)
        rts

; ------------------------------------------------------------------------------

; [ update list text ]

UpdateListText:
@82dd:  clr_a
        lda     $2a                     ; list type
        asl
        tax
        jmp     (.loword(UpdateListTextTbl),x)

; jump table for list types
;   0: item list
;   1: magic
;   2: lore
;   3: rage
;   4: esper
;   5: equip/relic item list
UpdateListTextTbl:
@82e5:  .addr   DrawItemListRow
        .addr   DrawMagicListRow
        .addr   DrawLoreListRow
        .addr   GetRiotListRow
        .addr   DrawGenjuListRow
        .addr   DrawEquipItemListRow

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
        lda     #$20
        sta     $29
        jmp     DrawItemCount

; ------------------------------------------------------------------------------

; [ get pointer to item description ]

GetItemDescPtr:
@8308:  ldx     #.loword(ItemDescPtrs)
        stx     $e7
        ldx     #.loword(ItemDesc)
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
@8339:  ldx     #.loword(RareItemDescPtrs)
        stx     $e7
        ldx     #.loword(RareItemDesc)
        stx     $eb
        lda     #^RareItemDescPtrs
        sta     $e9
        sta     $ed
        jsr     LoadBigText
        jsr     CountRareItems
        lda     #$20
        sta     $29
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
        ldx     #$7abf
        jmp     DrawNum3

; ------------------------------------------------------------------------------

; [ clear item count ]

ClearItemCount:
@8385:  ldy     #.loword(ItemBlankQtyText)
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
        ldy     #$0014
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
        and     #$0f
        stz     $f2
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
@841b:  lda     #$20
        sta     $29
        jsr     GetRareItemNamePtr
        ldx     #3
        jsr     DrawRareItemName
        inc     $e5
        jsr     GetRareItemNamePtr
        ldx     #17
        jsr     DrawRareItemName
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get pointer to rare item names ]

GetRareItemNamePtr:
@8436:  ldy     #13
        sty     $eb
        ldy     #.loword(RareItemName)
        sty     $ef
        lda     #^RareItemName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [ draw rare item name ]

; X: text x position

DrawRareItemName:
@8445:  lda     $e6
        inc
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
        sta     $28
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
        and     #$40
        beq     @8510                   ; branch if not useable on the field
        clr_a
        lda     $28
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
        sta     $27
        stz     $26
        rts

; sleeping bag
@84e2:  sta     $e6
        lda     $0201
        bpl     @8510                   ; branch if not on a save point
        bra     @84d3                   ; go to character select

; warp stone
@84eb:  sta     $e6
        lda     $0201
        bit     #$02
        beq     @8510                   ; branch if warp is disabled
        lda     #$03                    ; return code $03 (warp/warp stone)
        bra     @8501

; tent
@84f8:  sta     $e6
        lda     $0201
        bpl     @8510                   ; branch if not on a save point
        lda     #$02                    ; return code $02 (tent)
@8501:  sta     $0205
        lda     $e6
        jsr     DecItemQty
        lda     #$ff                    ; terminate menu after fade out
        sta     $27
        stz     $26                     ; menu state $00 (fade out)
        rts
@8510:  lda     #$08                    ; menu state $08 (item select)
        sta     $26
        rts

; not a useable item, show item details
@8515:  ldy     #$9d89
        sty     hWMADDL
        cmp     #$00
        beq     @8510                   ; branch if a tool (back to item select)
        stz     $e0
        longa
        lda     f:ItemProp+1,x          ; equippable characters
        ldx     $00
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
        lda     #$7d8d
        sta     $7e9e89                 ; pointer to positioned text
        shorta
        lda     #$04
        trb     $45
        jsr     _c3858c
        jsr     CreateItemDetailsArrowTask
        clr_a
        lda     $4b                     ; selected item
        tay
        jsr     LoadListItemName
        jsr     _c385ad
        lda     #$2c                    ; teal text
        sta     $29
        jsr     DrawPosTextBuf
        lda     #$20                    ; white text
        sta     $29
        jsr     _c385d5
        jsr     DrawItemDetails
        jsr     InitDMA1BG3ScreenAB
        jsr     DisableDMA2
        lda     #$64                    ; menu state $64 (item details)
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3858c:
@858c:  lda     #$c0                    ; page can't scroll up or down
        trb     $46
        lda     #$10                    ; force description text redraw ???
        tsb     $45
        rts

; ------------------------------------------------------------------------------

; [ init flashing left cursor (item details) ]

CreateItemDetailsArrowTask:
@8595:  lda     #$01                    ; enable flashing left cursor
        sta     $99
        lda     #1
        ldy     #.loword(ItemDetailsArrowTask)
        jsr     CreateTask
        lda     #$80
        sta     $7e344a,x               ; y position
        clr_a
        sta     $7e344b,x
        rts

; ------------------------------------------------------------------------------

; [ load " can be used by:" text to buffer ]

_c385ad:
@85ad:  ldx     #$0001
@85b0:  lda     $7e9e8b,x
        cmp     #$ff
        bne     @85cd
@85b8:  ldy     $00
@85ba:  phx
        tyx
        lda     f:ItemUsageTest,x       ; " can be used by:"
        plx
        sta     $7e9e8b,x
        inx
        iny
        cpy     #$0011
        bne     @85ba
        rts
@85cd:  inx
        cpx     #$000d
        bne     @85b0
        bra     @85b8

; ------------------------------------------------------------------------------

; [ draw equippable character names ]

_c385d5:
@85d5:  ldx     #$9e09
        stx     hWMADDL
        ldx     $00
@85dd:  lda     $7e9d89,x
        bmi     @8623                   ; branch if no character
        sta     $e5
        ldy     $00
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
@860a:  longac                          ; check next character
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
        ldx     $00
@862a:  clr_a
        lda     $7e9e09,x
        bmi     @8652
        phx
        phx
        longa
        asl
        tax
        lda     f:CharPropPtrs,x
        sta     $67
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
@8653:  .word   $7e0f,$7e23,$7e37,$7e8f,$7ea3,$7eb7,$7f0f,$7f23
@8663:  .word   $7f37,$7f8f,$7fa3,$7fb7,$800f,$8023,$8037

; ------------------------------------------------------------------------------

; [ draw item stats ]

DrawItemDetails:
@8671:  jsr     ClearBG3ScreenB
        lda     #$2c                    ; teal text
        sta     $29
        ldx     #.loword(ItemStatTextList1)
        ldy     #$001c
        jsr     DrawPosList
        lda     #$2c                    ; teal text
        sta     $29
        ldx     #.loword(ItemStatTextList2)
        ldy     #$0008
        jsr     DrawPosList
        lda     #$20                    ; white text
        sta     $29
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
        lda     #$8445
        sta     $7e9e89
        shorta
        clr_a
        lda     f:ItemProp+16,x         ; vigor/speed
        pha
        and     #$0f
        asl
        jsr     DrawItemStatModifier
        longa
        lda     #$84c5
        sta     $7e9e89
        shorta
        clr_a
        pla
        and     #$f0
        lsr3
        jsr     DrawItemStatModifier
        longa
        lda     #$8545
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
        lda     #$85c5
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
        ldx     #$86c3
        jsr     DrawNum3
        ldx     hMPYL
        lda     f:ItemProp+21,x         ; magic defense
        jsr     HexToDec3
        ldx     #$87c3
        jsr     DrawNum3
        jsr     DrawItemEvadeModifier
        jsr     _c388a0
        jsr     _c38959
        lda     #$2c                    ; teal text
        sta     $29
        ldx     #.loword(ItemElementTextList)
        ldy     #$0008
        jsr     DrawPosList
        jmp     DrawWeaponLearnedMagic

; weapon
@8746:  jsr     DrawWeaponPower
        jsr     DrawItemEvadeModifier
        lda     #$2c                    ; teal text
        sta     $29
        ldy     #.loword(ItemAttackElementText)
        jsr     DrawPosText
        jsr     _c388a0
        lda     #$20                    ; white text
        sta     $29
        ldx     hMPYL
        lda     f:ItemProp+19,x         ; weapon properties
        bpl     @876e
        ldy     #$8e30                  ; "runic"
        sty     $e7
        jsr     _c38795
@876e:  ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #$40
        beq     @8781
        ldy     #$8e38                  ; "2-hand"
        sty     $e7
        jsr     _c38795
@8781:  ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #$02
        beq     @8794
        ldy     #$8e26                  ; "swdtech"
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
        lda     $1869,y     ; current items
        cmp     #$1c
        beq     @87c0       ; branch if atma weapon
        cmp     #$16
        beq     @87c0       ; branch if soul sabre
        cmp     #$51
        beq     @87c0       ; branch if dice
        cmp     #$52
        beq     @87c0       ; branch if fixed dice
        lda     f:ItemProp+20,x   ; battle power
        jsr     HexToDec3
        ldx     #$8643
        jmp     DrawNum3
@87c0:  ldy     #.loword(ItemUnknownAttackText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw item's spell learned ]

DrawWeaponLearnedMagic:
@87c7:  lda     #$20
        sta     $29
        ldx     hMPYL
        lda     f:ItemProp+3,x   ; spell learn rate
        beq     @87ea
        sta     $e0
        lda     f:ItemProp+4,x   ; spell learned
        sta     $e1
        longa
        lda     #$832f
        sta     $7e9e89
        shorta
        jsr     DrawItemMagicName
@87ea:  rts

; ------------------------------------------------------------------------------

; [ draw item's evade%/mblock% ]

DrawItemEvadeModifier:
@87eb:  longa
        lda     #$8743
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
        lda     #$8843
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
@8854:  .byte   $ff,$ff,$b4,$00
@8858:  .byte   $ca,$b5,$b4,$00
@885c:  .byte   $ca,$b6,$b4,$00
@8860:  .byte   $ca,$b7,$b4,$00
@8864:  .byte   $ca,$b8,$b4,$00
@8868:  .byte   $ca,$b9,$b4,$00
@886c:  .byte   $c4,$b5,$b4,$00
@8870:  .byte   $c4,$b6,$b4,$00
@8874:  .byte   $c4,$b7,$b4,$00
@8878:  .byte   $c4,$b8,$b4,$00
@887c:  .byte   $c4,$b9,$b4,$00

; c3/8880: " 0", "+1", "+2", "+3", "+4", "+5", "-1", "-2", "-3", "-4", "-5"

StatModifierTextTable:
@8880:  .byte   $ff,$b4,$ca,$b5,$ca,$b6,$ca,$b7,$ca,$b8,$ca,$b9,$ca,$ba,$ca,$bb
@8890:  .byte   $ff,$b4,$c4,$b5,$c4,$b6,$c4,$b7,$c4,$b8,$c4,$b9,$c4,$ba,$c4,$bb

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
@88ce:  ldx     #$7bcd
        stx     $eb
        lda     #$7e
        sta     $ed
        jmp     _88fe

; absorbed elements
_c388da:
@88da:  ldx     #$7be9
        stx     $eb
        lda     #$7e
        sta     $ed
        jmp     _88fe

; no effect elements
_c388e6:
@88e6:  ldx     #$7ccd
        stx     $eb
        lda     #$7e
        sta     $ed
        jmp     _88fe

; weak point elements
_c388f2:
@88f2:  ldx     #$7ce9
        stx     $eb
        lda     #$7e
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
@8983:  lda     $08
        bit     #$80
        bne     @898f                   ; branch if A button is pressed
        lda     $09
        bit     #$02
        beq     @89a8                   ; branch if left button is not pressed

; left button or A button
@898f:  jsr     PlaySelectSfx
        lda     #$ff
        sta     $99
        lda     #$0a
        sta     $20
        ldy     #$fff4
        sty     $9c
        lda     #$5e                    ; next menu state $5e (item stats)
        sta     $27
        lda     #$65                    ; menu state $65 (scroll menu horizontal)
        sta     $26
        rts

; B button
@89a8:  lda     $09
        bit     #$80
        beq     @89dd                   ; return if B button is not pressed
        jsr     PlayCancelSfx
        lda     #$ff
        sta     $99
        ldx     #$7b49
        stx     hWMADDL
        ldx     #$0280
@89be:  stz     hWMDATA
        stz     hWMDATA
        dex
        bne     @89be
        lda     #$04
        tsb     $45
        jsr     _c389de
        jsr     InitDMA1BG3ScreenA
        jsr     WaitVblank
        clr_a
        sta     $7e9a10
        lda     #$08        ; menu state $08 (item, select)
        sta     $26
@89dd:  rts

; ------------------------------------------------------------------------------

; [  ]

_c389de:
@89de:  jsr     CreateScrollArrowTask1
        lda     #$10
        trb     $45
        rts

; ------------------------------------------------------------------------------

; [ menu state $5e: item details ]

MenuState_5e:
@89e6:  lda     $09
        bit     #$80
        bne     @89f2                   ; branch if B button is pressed
        lda     $09
        bit     #$01
        beq     @8a0d                   ; branch if right button is not pressed

; B button or right button
@89f2:  jsr     PlayCancelSfx
        lda     #$0a
        sta     $20
        ldy     #$000c
        sty     $9c
        lda     #$05
        trb     $46
        lda     #$64                    ; next menu state $64 (item details)
        sta     $27
        lda     #$65                    ; menu state $65 (scroll menu horizontal)
        sta     $26
        jsr     CreateItemDetailsArrowTask
@8a0d:  rts

; ------------------------------------------------------------------------------

; [ draw item target menu ]

DrawItemTargetMenu:
@8a0e:  jsr     ClearBG2ScreenA
        ldy     #.loword(ItemTargetCharWindow)
        jsr     DrawWindow
        ldy     #.loword(ItemTargetItemNameWindow)
        jsr     DrawWindow
        ldy     #.loword(ItemTargetQtyWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenB
        ldy     #$ffc0
        sty     $35
        lda     #$02
        tsb     $45
        jsr     _c3318a
        jsr     _c38a47
        jmp     _c3319f

; ------------------------------------------------------------------------------

ItemTargetCharWindow:
@8a3b:  .byte   $9d,$58,$13,$18

ItemTargetItemNameWindow:
@8a3f:  .byte   $8b,$58,$0d,$02

ItemTargetQtyWindow:
@8a43:  .byte   $8b,$59,$07,$03

; ------------------------------------------------------------------------------

; [  ]

_c38a47:
@8a47:  lda     #$20
        sta     $29
        ldy     #.loword(ItemOwnedText)
        jsr     DrawPosText
        longa
        lda     #$790b
        sta     $7e9e89
        shorta
        clr_a
        lda     $4b
        tay
        jsr     LoadListItemName
        clr_a
        sta     $7e9e98
        jsr     DrawPosTextBuf
        bra     ItemTargetDrawQty

; ------------------------------------------------------------------------------

; [ draw item quantity (item target select) ]

ItemTargetDrawQty:
@8a6d:  lda     #$20        ; white text
        sta     $29
        clr_a
        lda     $28
        tay
        lda     $1969,y     ; item quantity
        jsr     HexToDec3
        ldx     #$7a93
        jsr     DrawNum2
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ menu state $6f: use item (character select, init) ]

MenuState_6f:
@8a84:  jsr     _c32a76
        jsr     DrawItemTargetMenu
        jsr     CreateCursorTask
        lda     #$40
        tsb     $45
        lda     #$70
        jmp     _c32aa5

; ------------------------------------------------------------------------------

; [ menu state $70: use item (character select) ]

MenuState_70:
@8a96:  jsr     InitDMA1BG1ScreenA
        jsr     InitDMA2BG3ScreenA

; A button
        lda     $08
        bit     #$80
        beq     @8aac
        jsr     GetInventoryItemID
        cmp     #$e7
        beq     @8ac0                   ; branch if rename card
        jsr     @8ae7
@8aac:  lda     $09
        bit     #$80
        beq     @8abf                   ; return if B button is not pressed
        jsr     PlayCancelSfx

@8ab5:  lda     #$42
        trb     $45
        lda     #$77                    ; menu state $77 (return to item select)
        sta     $27
        stz     $26
@8abf:  rts

; item $e7: rename card
@8ac0:  jsr     GetTargetCharPtr
        lda     $0000,y                 ; actor index
        cmp     #$0e
        bcs     @8ae0                   ; branch if actor index >= 14
        sty     $0206
        jsr     PlaySelectSfx
        lda     #$fe                    ; return code $fe (rename card)
        sta     $0205
        lda     #$ff                    ; terminate menu after fade out
        sta     $27
        stz     $26                     ; menu state $00 (fade out)
        lda     #$e7
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
        lda     $28                     ; item index
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
        sta     $f8
        lda     $0015,y
        sta     $fb
        phy
        jsr     GetInventoryItemID
        ldx     #$0002                  ; 2: item effect
        jsl     CalcMagicEffect_ext
        ply
        lda     $fc
        sta     $0014,y                 ; set status 1 & 4
        lda     $ff
        sta     $0015,y
        jmp     _c38c33

; ------------------------------------------------------------------------------

; [ check if item can be used ]

; +y: pointer to character data (+$1600)
; carry: clear = invalid, set = valid (out)

CheckCanUseItem:
@8b3d:  lda     $0014,y     ; status 1
        and     #$80
        bne     @8b85       ; branch if character has wound status

; selected character does not have wound status
        jsr     GetInventoryItemID
        cmp     #$fe        ; dried meat
        beq     @8bc4
        cmp     #$e8        ; tonic
        beq     @8bc4
        cmp     #$e9        ; potion
        beq     @8bc4
        cmp     #$ea        ; x-potion
        beq     @8bc4
        cmp     #$eb        ; tincture
        beq     @8bd5
        cmp     #$ec        ; ether
        beq     @8bd5
        cmp     #$ed        ; x-ether
        beq     @8bd5
        cmp     #$f1        ; revivify
        beq     @8b8e
        cmp     #$f2        ; antidote
        beq     @8bbb
        cmp     #$f3        ; eyedrop
        beq     @8b97
        cmp     #$f4        ; soft
        beq     @8ba0
        cmp     #$f5        ; remedy
        beq     @8bb2
        cmp     #$ee        ; elixir
        beq     @8be5
        cmp     #$f8        ; green cherry
        beq     @8ba9
        cmp     #$f6        ; sleeping bag
        beq     @8bd2
        bra     @8bd0       ; all other items are invalid

; selected character has wound status
@8b85:  jsr     GetInventoryItemID
        cmp     #$f0        ; fenix down
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
@8bfa:  stx     $ed
        ldy     a:$006d,x     ; check each character in the party
        beq     @8c06
        jsr     @8be5       ; check if elixir is valid
        bcs     @8be3
@8c06:  ldx     $ed
        inx2                ; next character
        cpx     #$0008
        bne     @8bfa
        bra     @8bd0

; sleeping bag
@8c11:  lda     $0014,y
        and     #$f7        ; isolate wound, petrify, imp, clear, poison, zombie, dark
        bne     @8be3
        lda     $0015,y
        and     #$80        ; isolate float
        bne     @8be3
        jsr     CheckMaxHP
        bcc     @8be3
        jsr     CheckMaxMP
        bcc     @8be3
        bra     @8bd0

; ------------------------------------------------------------------------------

; [ get item index ]

; $28: inventory slot

GetInventoryItemID:
@8c2b:  clr_a
        lda     $28
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
        stx     $b0
        jsr     _c38ccd
        lda     f:ItemProp+19,x   ; item properties
        bmi     @8c76       ; branch if item affects 16ths of max value

; restore specific value
        and     #$08
        beq     @8c5c       ; branch if item doesn't restore hp
        longac
        lda     $b2
        adc     $0009,y     ; add hp
        sta     $0009,y
        shorta
        jsr     CheckMaxHP
@8c5c:  ldx     $b0
        lda     f:ItemProp+19,x
        and     #$10
        beq     @8c75       ; branch if item doesn't restore mp
        longac
        lda     $b2
        adc     $000d,y     ; add mp
        sta     $000d,y
        shorta
        jsr     CheckMaxMP
@8c75:  rts

; restore 16ths of max value
@8c76:  lda     f:ItemProp+19,x
        and     #$08
        beq     @8ca0       ; branch if item doesn't restore hp
        lda     $000b,y
        sta     $f3
        lda     $000c,y
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        jsr     _c38cd6
        longac
        lda     $e9
        adc     $0009,y     ; add to hp
        sta     $0009,y
        shorta
        jsr     CheckMaxHP
@8ca0:  ldx     $b0
        lda     f:ItemProp+19,x
        and     #$10
        beq     @8ccc       ; branch if item doesn't restore mp
        lda     $000f,y
        sta     $f3
        lda     $0010,y
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        jsr     _c38cd6
        longac
        lda     $e9
        adc     $000d,y     ; add to mp
        sta     $000d,y
        shorta
        jsr     CheckMaxMP
@8ccc:  rts

; ------------------------------------------------------------------------------

; [ load item hp/mp restored ]

_c38ccd:
lpget:
@8ccd:  lda     f:ItemProp+20,x   ; hp/mp restored
        sta     $b2
        stz     $b3
        rts

; ------------------------------------------------------------------------------

; [ calculate fraction of max hp/mp restored ]

_c38cd6:
par16:
@8cd6:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @8cd6
        lda     $f3
        sta     hM7A
        lda     $f4
        sta     hM7A
        lda     $b2
        sta     hM7B
        sta     hM7B
        lda     hMPYH
        sta     $eb
        stz     $ec
        longa
        lda     hMPYL
        sta     $e9
        lsr     $eb
        ror     $e9
        lsr     $eb
        ror     $e9
        lsr     $eb
        ror     $e9
        lsr     $eb
        ror     $e9
        shorta
        rts

; ------------------------------------------------------------------------------

ItemOptionTextList:
@8d10:  .addr   ItemOptionUseText
        .addr   ItemOptionArrangeText
        .addr   ItemOptionRareText

; "Item"
ItemTitleText:
@8d16:  .byte   $0d,$79,$88,$ad,$9e,$a6,$00

; "Use"
ItemOptionUseText:
@8d1d:  .byte   $1d,$79,$94,$92,$84,$00

; "Arrange"
ItemOptionArrangeText:
@8d23:  .byte   $27,$79,$80,$91,$91,$80,$8d,$86,$84,$00

; "Rare"
ItemOptionRareText:
@8d2d:  .byte   $39,$79,$91,$80,$91,$84,$00

; " can be used by:"
ItemUsageTest:
@8d34:  .byte   $ff,$9c,$9a,$a7,$ff,$9b,$9e,$ff,$ae,$ac,$9e,$9d,$ff,$9b,$b2,$c1
        .byte   $00

; stat names
ItemStatTextList1:
@8d45:  .addr   ItemStatText_00
        .addr   ItemStatText_01
        .addr   ItemStatText_02
        .addr   ItemStatText_03
        .addr   ItemStatText_04
        .addr   ItemStatText_05
        .addr   ItemStatText_06
        .addr   ItemStatText_07
        .addr   ItemStatText_08
        .addr   ItemStatText_09
        .addr   ItemStatText_0a
        .addr   ItemStatText_0b
        .addr   ItemStatText_0c
        .addr   ItemStatText_0d

ItemStatTextList2:
@8d61:  .addr   ItemStatText_0e
        .addr   ItemStatText_0f
        .addr   ItemStatText_10
        .addr   ItemStatText_11

; element defense type names
ItemElementTextList:
@8d69:  .addr   ItemElementText_00
        .addr   ItemElementText_01
        .addr   ItemElementText_02
        .addr   ItemElementText_03

; "???"
ItemUnknownAttackText:
@8d71:  .byte   $43,$86,$bf,$bf,$bf,$00

; "Vigor"
ItemStatText_00:
@8d77:  .byte   $2f,$84,$95,$a2,$a0,$a8,$ab,$00

; "Stamina"
ItemStatText_01:
@8d7f:  .byte   $2f,$85,$92,$ad,$9a,$a6,$a2,$a7,$9a,$00

; "Mag.Pwr"
ItemStatText_02:
@8d89:  .byte   $af,$85,$8c,$9a,$a0,$c5,$8f,$b0,$ab,$00

; "Evade %"
ItemStatText_03:
@8d93:  .byte   $2f,$87,$84,$af,$9a,$9d,$9e,$ff,$cd,$00

; "MBlock%"
ItemStatText_04:
@8d9d:  .byte   $2f,$88,$8c,$81,$a5,$a8,$9c,$a4,$cd,$00

ItemStatText_05:
@8da7:  .byte   $3f,$84,$d3,$00

ItemStatText_06:
@8dab:  .byte   $bf,$84,$d3,$00

ItemStatText_07:
@8daf:  .byte   $3f,$85,$d3,$00

ItemStatText_08:
@8db3:  .byte   $bf,$85,$d3,$00

ItemStatText_09:
@8db7:  .byte   $3f,$86,$d3,$00

ItemStatText_0a:
@8dbb:  .byte   $bf,$86,$d3,$00

ItemStatText_0b:
@8dbf:  .byte   $3f,$87,$d3,$00

ItemStatText_0c:
@8dc3:  .byte   $bf,$87,$d3,$00

ItemStatText_0d:
@8dc7:  .byte   $3f,$88,$d3,$00

; "Speed"
ItemStatText_0e:
@8dcb:  .byte   $af,$84,$92,$a9,$9e,$9e,$9d,$00

; "Bat.Pwr"
ItemStatText_0f:
@8dd3:  .byte   $2f,$86,$81,$9a,$ad,$c5,$8f,$b0,$ab,$00

; "Defense"
ItemStatText_10:
@8ddd:  .byte   $af,$86,$83,$9e,$9f,$9e,$a7,$ac,$9e,$00

; "Mag.Def"
ItemStatText_11:
@8de7:  .byte   $af,$87,$8c,$9a,$a0,$c5,$83,$9e,$9f,$00

; "50% Dmg"
ItemElementText_00:
@8df1:  .byte   $8d,$7b,$b9,$b4,$cd,$ff,$83,$a6,$a0,$00

; "Absorb"
ItemElementText_01:
@8dfb:  .byte   $a9,$7b,$80,$9b,$ac,$a8,$ab,$9b,$ff,$87,$8f,$00

; "No Effect"
ItemElementText_02:
@8e07:  .byte   $8d,$7c,$8d,$a8,$ff,$84,$9f,$9f,$9e,$9c,$ad,$00

; "Weak pt"
ItemElementText_03:
@8e13:  .byte   $a9,$7c,$96,$9e,$9a,$a4,$ff,$a9,$ad,$00

; "Attack"
ItemAttackElementText:
@8e1d:  .byte   $8d,$7b,$80,$ad,$ad,$9a,$9c,$a4,$00

; "SwdTech"
ItemBushidoText:
@8e26:  .byte   $2f,$82,$92,$b0,$9d,$93,$9e,$9c,$a1,$00

; "Runic"
ItemRunicText:
@8e30:  .byte   $af,$82,$91,$ae,$a7,$a2,$9c,$00

; "2-hand"
Item2HandText:
@8e38:  .byte   $2f,$83,$b6,$c4,$a1,$9a,$a7,$9d,$00

; "Owned:"
ItemOwnedText:
@8e41:  .byte   $0d,$7a,$8e,$b0,$a7,$9e,$9d,$c1,$00

; "   "
ItemBlankQtyText:
@8e4a:  .byte   $bf,$7a,$ff,$ff,$ff,$00

; ------------------------------------------------------------------------------
