; ------------------------------------------------------------------------------

; convert (x,y) position to vram address for two horizontal screens
.mac _menu_vram_ptr vram_addr, x_pos, y_pos
        .if x_pos < 32
        .addr vram_addr + x_pos + y_pos * 32
        .else
        .addr vram_addr + (x_pos - 32) + (y_pos + 32) * 32
        .endif
.endmac

.mac menu_vram_ptr_bg1 xy_pos
        _menu_vram_ptr $6800, xy_pos
.endmac

.mac menu_vram_ptr_bg2 xy_pos
        _menu_vram_ptr $7000, xy_pos
.endmac

; menu window tile data vram pointers (WINDOW_VRAM enum)
MenuWindowVRAMPtrs:
        menu_vram_ptr_bg2 {0, 0}  ; $00: closed menu
        menu_vram_ptr_bg2 {0, 10}  ; $01: command select
        menu_vram_ptr_bg2 {32, 16}  ; $02: slot
        menu_vram_ptr_bg2 {0, 24}  ; $03: item/dialog/etc.
        menu_vram_ptr_bg2 {32, 0}  ; $04: magic/lore select
        menu_vram_ptr_bg2 {32, 8}  ; $05: weapon select
        menu_vram_ptr_bg2 {32, 24}  ; $06: esper
        menu_vram_ptr_bg1 {0, 0}  ; $07: row/def. (bg1)
        menu_vram_ptr_bg1 {0, 8}  ; $08: swdtech (bg1)

; ------------------------------------------------------------------------------

; menu window buffer size & position data (WINDOW_BUF enum)

; these are positions within the window tilemap buffer in wram, to be
; added to the vram positions in MenuWindowVRAMPtrs

.macro _menu_window bufptr, x_pos, y_pos, width, height
        .byte   width, height
        .addr   bufptr + (x_pos + y_pos * 32) * 2
.endmac

.macro menu_window_bg1 xy_pos, size
        _menu_window w7ea97f, xy_pos, size
.endmac

.macro menu_window_bg2 xy_pos, size
        _menu_window w7e8d13, xy_pos, size
.endmac

WindowBufTbl:
@dd9e:  menu_window_bg2 {1, 0}, {12, 8}  ; $00: monster name
        menu_window_bg2 {13, 0}, {18, 8}  ; $01: character name/hp/gauge
.if LANG_EN
        menu_window_bg2 {2, 0}, {10, 8}  ; $02: command (window mode)
.else
        menu_window_bg2 {3, 0}, {9, 8}  ; $02: command (window mode)
.endif
        menu_window_bg2 {1, 0}, {30, 8}  ; $03: slot window
        menu_window_bg2 {1, 0}, {30, 8}  ; $04: item/dialog/etc.
        menu_window_bg2 {22, 0}, {9, 8}  ; $05: magic/lore mp required
        menu_window_bg2 {1, 0}, {30, 5}  ; $06: weapon select
        menu_window_bg2 {1, 0}, {21, 8}  ; $07: magic/lore select
        menu_window_bg2 {1, 0}, {30, 4}  ; $08: esper
        menu_window_bg2 {0, 0}, {7, 4}  ; $09: row/def. (all positions)
        menu_window_bg2 {0, 0}, {12, 5}  ; $0a: swdtech
.if LANG_EN
        menu_window_bg1 {1, 1}, {30, 4}  ; $0b: wide message (top of screen)
        menu_window_bg1 {7, 1}, {18, 4}  ; $0c: narrow message (top of screen)
        menu_window_bg2 {2, 0}, {19, 7}  ; $0d: command (short mode)
        menu_window_bg2 {2, 0}, {12, 8}  ; $0e: command (relm's "control" ability)
.else
        menu_window_bg1 {2, 1}, {28, 4}  ; $0b: wide message (top of screen)
        menu_window_bg1 {7, 1}, {18, 4}  ; $0c: narrow message (top of screen)
        menu_window_bg2 {3, 0}, {17, 7}  ; $0d: command (short mode)
        menu_window_bg2 {3, 0}, {11, 8}  ; $0e: command (relm's "control" ability)
.endif

; ------------------------------------------------------------------------------

; menu text position data (MENU_TEXT_SCROLL enum)
;   +$00: source address
;   +$02: destination address (top scanline in bg3 scroll hdma data)
;   +$04: number of rows
;   +$06: unused

MenuTextScrollTbl:
@ddda:  .addr   wCmdTextScrollData,         wBG3ScrollData::_151, 8, 0  ; MENU_TEXT_SCROLL::CMD
        .addr   wRowDefTextScrollData,      wBG3ScrollData::_151, 8, 0  ; MENU_TEXT_SCROLL::ROW_DEF_CLOSE
        .addr   wListTextScrollData,        wBG3ScrollData::_155, 8, 0  ; MENU_TEXT_SCROLL::LIST
        .addr   wGenjuTextScrollData,       wBG3ScrollData::_155, 5, 0  ; MENU_TEXT_SCROLL::GENJU
        .addr   wEquipTextScrollData,       wBG3ScrollData::_155, 6, 0  ; MENU_TEXT_SCROLL::EQUIP
        .addr   wRowDefTextScrollData,      wBG3ScrollData::_151, 5, 0  ; MENU_TEXT_SCROLL::ROW_DEF_1
        .addr   wRowDefTextScrollData::_8,  wBG3ScrollData::_159, 5, 0  ; MENU_TEXT_SCROLL::ROW_DEF_2
        .addr   wRowDefTextScrollData::_20, wBG3ScrollData::_171, 5, 0  ; MENU_TEXT_SCROLL::ROW_DEF_3
        .addr   wRowDefTextScrollData::_32, wBG3ScrollData::_183, 5, 0  ; MENU_TEXT_SCROLL::ROW_DEF_4
        .addr   wRowDefTextScrollData,      wBG3ScrollData::_151, 6, 0  ; MENU_TEXT_SCROLL::BUSHIDO
        .addr   wCharStatusTextScrollData,  wBG3ScrollData::_159, 8, 0  ; MENU_TEXT_SCROLL::CHAR_STATUS

; ------------------------------------------------------------------------------

; menu text vertical offset and height (in tiles, WINDOW_POS enum)
MenuWindowSizeTbl:
@de32:  .word   $025c, 8  ; NONE  ; $00
        .word   $025c, 8  ; CMD_OPEN  ; $01
        .word   $026c, 8  ; SLOT_OPEN  ; $02
        .word   $026c, 8  ; LIST_OPEN  ; $03
        .word   $026c, 8  ; MAGIC_OPEN  ; $04
        .word   $027c, 5  ; EQUIP_OPEN  ; $05
        .word   $026c, 8  ; LIST_CLOSE  ; $06
        .word   $027c, 5  ; EQUIP_CLOSE  ; $07
        .word   $027c, 4  ; SUMMON_OPEN  ; $08
        .word   $027c, 4  ; SUMMON_CLOSE  ; $09
        .word   $025c, 4  ; ROW_DEF_OPEN  ; $0a
        .word   $028c, 4  ; ROW_DEF_OPEN_2  ; $0b
        .word   $02bc, 4  ; ROW_DEF_OPEN_3  ; $0c
        .word   $02ec, 4  ; ROW_DEF_OPEN_4  ; $0d
        .word   $025c, 4  ; ROW_DEF_CLOSE  ; $0e
        .word   $028c, 4  ; ROW_DEF_CLOSE_2  ; $0f
        .word   $02bc, 4  ; ROW_DEF_CLOSE_3  ; $10
        .word   $02ec, 4  ; ROW_DEF_CLOSE_4  ; $11
        .word   $026c, 5  ; BUSHIDO_OPEN  ; $12
        .word   $026c, 5  ; BUSHIDO_CLOSE  ; $13
        .word   $026c, 8  ; DLG_OPEN  ; $14
        .word   $026c, 8  ; DLG_CLOSE_NONE  ; $15
        .word   $025c, 7  ; DLG_CLOSE_CMD  ; $16
        .word   $025c, 4  ; ROW_DEF_OPEN_SHORT  ; $17
        .word   $025c, 4  ; ROW_DEF_CLOSE_SHORT  ; $18
        .word   $027c, 8  ; CHAR_STATUS_OPEN  ; $19
        .word   $027c, 8  ; CHAR_STATUS_CLOSE  ; $1a
        .word   $027c, 8  ; CHAR_STATUS_CLOSE_MAGIC  ; $1b

; ------------------------------------------------------------------------------

; battle menu window scroll positions (WINDOW_POS enum)
MenuWindowPosTbl:
@dea2:  .addr   0, 104  ; NONE  ; $00
        .addr   0, 184  ; CMD_OPEN  ; $01
        .addr   256, 228  ; SLOT_OPEN  ; $02
        .addr   0, 292  ; LIST_OPEN  ; $03
        .addr   256, 100  ; MAGIC_OPEN  ; $04
        .addr   256, 160  ; EQUIP_OPEN  ; $05
        .addr   0, 184  ; LIST_CLOSE  ; $06
        .addr   0, 292  ; EQUIP_CLOSE  ; $07
        .addr   256, 288  ; SUMMON_OPEN  ; $08
        .addr   256, 100  ; SUMMON_CLOSE  ; $09
        .addr   -8, -152  ; ROW_DEF_OPEN  ; $0a
        .addr   -8, -164  ; ROW_DEF_OPEN_2  ; $0b
        .addr   -8, -176  ; ROW_DEF_OPEN_3  ; $0c
        .addr   -8, -188  ; ROW_DEF_OPEN_4  ; $0d
        .addr   0, 0  ; ROW_DEF_CLOSE  ; $0e
        .addr   0, 0  ; ROW_DEF_CLOSE_2  ; $0f
        .addr   0, 0  ; ROW_DEF_CLOSE_3  ; $10
        .addr   0, 0  ; ROW_DEF_CLOSE_4  ; $11
        .addr   -16, -92  ; BUSHIDO_OPEN  ; $12
        .addr   0, 0  ; BUSHIDO_CLOSE  ; $13
        .addr   0, 292  ; DLG_OPEN  ; $14
        .addr   0, 104  ; DLG_CLOSE_NONE  ; $15
        .addr   0, 184  ; DLG_CLOSE_CMD  ; $16
        .addr   -16, -152  ; ROW_DEF_OPEN_SHORT  ; $17
        .addr   0, 0  ; ROW_DEF_CLOSE_SHORT  ; $18
        .addr   0, 96  ; CHAR_STATUS_OPEN  ; $19
        .addr   0, 292  ; CHAR_STATUS_CLOSE  ; $1a
        .addr   256, 100  ; CHAR_STATUS_CLOSE_MAGIC  ; $1b

; ------------------------------------------------------------------------------

; menu text buffer data (MENU_TEXT enum)
; raw text from MenuText gets decoded to the tile buffers specified here

.macro menu_text_buf bufptr, width
        .addr   bufptr
        .byte   width, 0
.endmac

MenuTextBufTbl:
@df12:  menu_text_buf w7e5ad5,      12  ; $00: monster names
        menu_text_buf w7e5b95,       7  ; $01: character names
        menu_text_buf w7e5c05,       4  ; $02: character current hp
        menu_text_buf w7e5c45,       6  ; $03: character atb gauges or max hp
.if LANG_EN
        menu_text_buf w7e5855 +  4, 32  ; $04: battle command names (window mode)
.else
        menu_text_buf w7e5855 +  6, 32  ; $04: battle command names (window mode)
.endif
        menu_text_buf w7e8d13 + 78, 32  ; $05: unknown/unused
        menu_text_buf w7e5e4d,      32  ; $06: equip menu text
        menu_text_buf w7e5ca5,       7  ; $07: current/max mp
        menu_text_buf w7e5d31 + 14,  7  ; $08: row command
        menu_text_buf w7e5d77 + 14,  7  ; $09: def. command
        menu_text_buf w7e5ca5,       7  ; $0a: character 1 mp
        menu_text_buf w7e5ca5 + 28,  7  ; $0b: character 2 mp
        menu_text_buf w7e5ca5 + 56,  7  ; $0c: character 3 mp
        menu_text_buf w7e5ca5 + 84,  7  ; $0d: character 4 mp
        menu_text_buf w7e5c05,       4  ; $0e: character 1 hp
        menu_text_buf w7e5c05 + 16,  4  ; $0f: character 2 hp
        menu_text_buf w7e5c05 + 32,  4  ; $10: character 3 hp
        menu_text_buf w7e5c05 + 48,  4  ; $11: character 4 hp
        menu_text_buf w7e5c45,       6  ; $12: character 1 atb gauge
        menu_text_buf w7e5c45 + 24,  6  ; $13: character 2 atb gauge
        menu_text_buf w7e5c45 + 48,  6  ; $14: character 3 atb gauge
        menu_text_buf w7e5c45 + 72,  6  ; $15: character 4 atb gauge
        menu_text_buf w7e5c45,       6  ; $16: character 1 morph gauge
        menu_text_buf w7e5c45 + 24,  6  ; $17: character 2 morph gauge
        menu_text_buf w7e5c45 + 48,  6  ; $18: character 3 morph gauge
        menu_text_buf w7e5c45 + 72,  6  ; $19: character 4 morph gauge
        menu_text_buf w7e5c45,       6  ; $1a: character 1 condemned gauge
        menu_text_buf w7e5c45 + 24,  6  ; $1b: character 2 condemned gauge
        menu_text_buf w7e5c45 + 48,  6  ; $1c: character 3 condemned gauge
        menu_text_buf w7e5c45 + 72,  6  ; $1d: character 4 condemned gauge
        menu_text_buf w7e5dbd,      12  ; $1e: swdtech window text
.if LANG_EN
        menu_text_buf w7e5855 +  4, 32  ; $1f: battle command names (short mode)
        menu_text_buf w7e5855 +  4, 32  ; $20: battle command names (control)
        menu_text_buf w7e5ecd,      10  ; $21: clear status names
.else
        menu_text_buf w7e5855 +  6, 32  ; $1f: battle command names (short mode)
        menu_text_buf w7e5855 +  6, 32  ; $20: battle command names (control)
        menu_text_buf w7e5ecd,       7  ; $21: clear status names
.endif
        menu_text_buf w7e8d13 + 68, 32  ; $22: character status window (item/magic target select)

; ------------------------------------------------------------------------------

; menu text tile buffer display data (MENU_TEXT_BUF enum)

; decoded text gets copied from buffers (src) to the screen tilemap
; buffers (dest) before they get copied to vram

.mac _menu_text_pos src, dest, xx, yy, ww, hh
        .addr src
        .addr dest + xx * 2 + yy * 64
        .word ww * 2, hh
.endmac

; copies text tiles to closed-menu buffer
.mac menu_text_pos_1 src, xy_pos, size
        _menu_text_pos src, w7e5855, xy_pos, size
.endmac

; copies text tiles to open-menu buffer
.mac menu_text_pos_2 src, xy_pos, size
        _menu_text_pos src, w7e8d13, xy_pos, size
.endmac

MenuTextPosTbl:
@df9e:  menu_text_pos_1 w7e5ad5, {2, 0}, {12, 8}  ; $00: monster names
        menu_text_pos_1 w7e5b95, {14, 0}, {7, 8}  ; $01: character names
        menu_text_pos_1 w7e5c05, {21, 0}, {4, 8}  ; $02: hp
        menu_text_pos_1 w7e5c45, {25, 0}, {6, 8}  ; $03: ATB gauge

        menu_text_pos_2 w7e5d31, {1, 0}, {7, 5}  ; $04: row (top)
        menu_text_pos_2 w7e5d31, {1, 2}, {7, 5}  ; $05: row
        menu_text_pos_2 w7e5d31, {1, 4}, {7, 5}  ; $06: row
        menu_text_pos_2 w7e5d31, {1, 6}, {7, 5}  ; $07: row (bottom)
        menu_text_pos_2 w7e5d77, {7, 0}, {7, 5}  ; $08: def. (top)
        menu_text_pos_2 w7e5d77, {7, 2}, {7, 5}  ; $09: def.
        menu_text_pos_2 w7e5d77, {7, 4}, {7, 5}  ; $0a: def.
        menu_text_pos_2 w7e5d77, {7, 6}, {7, 5}  ; $0b: def. (bottom)
        menu_text_pos_2 w7e5c05, {21, 1}, {4, 8}  ; $0c: hp
        menu_text_pos_2 w7e5c45, {25, 1}, {6, 8}  ; $0d: ATB gauge
        menu_text_pos_2 w7e5dbd, {2, 1}, {12, 6}  ; $0e: swdtech gauge
        menu_text_pos_2 w7e5d31, {2, 0}, {7, 5}  ; $0f: row (short)
        menu_text_pos_2 w7e5d77, {14, 0}, {7, 5}  ; $10: def. (short)
.if LANG_EN
        menu_text_pos_2 w7e5ecd, {2, 1}, {10, 8}  ; $11: blank status names
.else
        menu_text_pos_2 w7e5ecd, {2, 1}, {7, 8}  ; $11: blank status names
.endif
        menu_text_pos_2 w7e5b95, {14, 1}, {7, 8}  ; $12:

; ------------------------------------------------------------------------------

; menu list text data (draws one line of each list)

.if LANG_EN

MagicListText:
; "{tab:3}{color:0x21}{attack:0}  {color:0x21}{attack:0}{tab:10}{0}"
@e036:  .byte   $05,$03,$04,$21,$0f,$00,$ff,$ff,$04,$21,$0f,$00,$05,$0a,$00
        sizeof_MagicListText = * - MagicListText + 1

LoreListText:
; "   {color:0x21}{attack:0}{0}"
@e045:  .byte   $ff,$ff,$ff,$04,$21,$19,$00,$00
        sizeof_LoreListText = * - LoreListText + 6

; "{tab:4}{color:0x21}{magitek:0}{tab:3}{color:0x21}{magitek:0}{0}"
MagitekListText:
@e04d:  .byte   $05,$04,$04,$21,$06,$00,$05,$03,$04,$21,$06,$00,$00
        sizeof_MagitekListText = * - MagitekListText

DanceListText:
@e05a:  .byte   $05,$04,$04,$21,$17,$00,$05,$02,$04,$21,$17,$00,$00
        sizeof_DanceListText = * - DanceListText

RageListText:
@e067:  .byte   $05,$04,$04,$21,$18,$00,$05,$02,$04,$21,$18,$00,$00
        sizeof_RageListText = * - RageListText

ItemListText:
@e074:  .byte   $05,$04,$04,$21,$0e,$00,$c1,$02,$00,$ff,$ff,$12,$00,$ff,$00
        sizeof_ItemListText = * - ItemListText + 4

; this draws the magic list below the summon window, and not the
; text in the summon window itself
SummonMagicListText:
@e083:  .byte   $ff,$ff,$84,$ac,$a9,$9e,$ab,$ff,$ff,$04,$21,$1a,$00,$05,$04,$03
        .byte   $2c,$03,$2f,$ff,$16,$00,$00
        sizeof_SummonMagicListText = * - SummonMagicListText

.else

MagicListText:
        .byte   $ff,$ff,$04,$21,$0f,$00,$ff,$ff,$04,$21,$0f,$00,$ff,$ff,$04,$21
        .byte   $0f,$00,$05,$09,$00
        sizeof_MagicListText = * - MagicListText

LoreListText:
        .byte   $ff,$ff,$ff,$04,$21,$19,$00,$ff,$ff,$04,$21,$19,$00,$00
        sizeof_LoreListText = * - LoreListText

MagitekListText:
        .byte   $05,$06,$04,$21,$06,$00,$05,$04,$04,$21,$06,$00,$00
        sizeof_MagitekListText = * - MagitekListText

DanceListText:
        .byte   $05,$06,$04,$21,$17,$00,$05,$04,$04,$21,$17,$00,$00
        sizeof_DanceListText = * - DanceListText

RageListText:
        .byte   $05,$06,$04,$21,$18,$00,$05,$04,$04,$21,$18,$00,$00
        sizeof_RageListText = * - RageListText

ItemListText:
        .byte   $05,$04,$04,$21,$0e,$00,$cf,$02,$00,$ff,$ff,$04,$21,$0e,$00,$cf
        .byte   $02,$00,$00
        sizeof_ItemListText = * - ItemListText

SummonMagicListText:
        .byte   $ff,$ff,$31,$b9,$37,$c1,$89,$ff,$ff,$04,$21,$1a,$00,$05,$06,$03
        .byte   $2c,$03,$2f,$ff,$16,$00,$00
        sizeof_SummonMagicListText = * - SummonMagicListText

.endif

; ------------------------------------------------------------------------------

; pointers to menu text (MENU_TEXT enum)
MenuTextPtrs:
        ptr_tbl MENU_TEXT

; menu text region $22: blank character status window text
; "{tab:18}{n}{tab:18}{n}{tab:18}{n}{tab:18}"
        array_label MENU_TEXT, MENU_TEXT::CHAR_STATUS
        .byte   $05,$12,$01,$05,$12,$01,$05,$12,$01,$05,$12,$00

; menu text region $1e: swdtech numbers and gauge
; "  "
; "{color:0x21}1"
; "{color:0x21}2"
; "{color:0x21}3"
; "{color:0x21}4"
; "{color:0x21}5"
; "{color:0x21}6"
; "{color:0x21}7"
; "{color:0x21}8"
; "  {n}{color:0x35} "
        array_label MENU_TEXT, MENU_TEXT::BUSHIDO
        .byte   $ff,$ff
        .byte   $04,$21,ZERO_CHAR+1
        .byte   $04,$21,ZERO_CHAR+2
        .byte   $04,$21,ZERO_CHAR+3
        .byte   $04,$21,ZERO_CHAR+4
        .byte   $04,$21,ZERO_CHAR+5
        .byte   $04,$21,ZERO_CHAR+6
        .byte   $04,$21,ZERO_CHAR+7
        .byte   $04,$21,ZERO_CHAR+8

        .byte   $ff,$ff,$01,$04,$35,$ff
        .byte   $03,GAUGE_LEFT_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_EMPTY_CHAR
        .byte   $03,GAUGE_RIGHT_CHAR
        .byte   $ff,$01,$05,$0c,$00

; menu text region $0e-$11: current hp (one character)
        array_label MENU_TEXT, MENU_TEXT::CHAR1_HP
        .byte   $07,$01,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR2_HP
        .byte   $08,$01,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR3_HP
        .byte   $09,$01,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR4_HP
        .byte   $0a,$01,$00

; menu text region $12-$15: atb gauge or max hp (one character)
        array_label MENU_TEXT, MENU_TEXT::CHAR1_ATB
        .byte   $07,$02,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR2_ATB
        .byte   $08,$02,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR3_ATB
        .byte   $09,$02,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR4_ATB
        .byte   $0a,$02,$00

; menu text region $16-$19: morph gauge
        array_label MENU_TEXT, MENU_TEXT::CHAR1_MORPH
        .byte   $04,$39,$07,$05,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR2_MORPH
        .byte   $04,$39,$08,$05,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR3_MORPH
        .byte   $04,$39,$09,$05,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR4_MORPH
        .byte   $04,$39,$0a,$05,$00

; menu text region $1a-$1d: condemned gauge
        array_label MENU_TEXT, MENU_TEXT::CHAR1_CONDEMNED
        .byte   $04,$3d,$07,$06,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR2_CONDEMNED
        .byte   $04,$3d,$08,$06,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR3_CONDEMNED
        .byte   $04,$3d,$09,$06,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR4_CONDEMNED
        .byte   $04,$3d,$0a,$06,$00

.if ::LANG_EN

        array_label MENU_TEXT, MENU_TEXT::ROW
        .byte   $ff,$ff,$91,$a8,$b0,$00  ; "Row"
        array_label MENU_TEXT, MENU_TEXT::DEF
        .byte   $ff,$ff,$83,$9e,$9f,$c5,$00  ; "Def."

; "{tab:3}R-Hand{tab:9}L-Hand{tab:7}"
        array_label MENU_TEXT, MENU_TEXT::EQUIP
        .byte   $05,$03,$91,$c4,$87,$9a,$a7,$9d,$05,$09,$8b,$c4,$87,$9a,$a7,$9d
        .byte   $05,$07,$00

.else
        array_label MENU_TEXT, MENU_TEXT::ROW
        .byte   $ff,$ff,$80,$ca,$b8,$36,$ff,$00  ; "　　チェンジ　"
        array_label MENU_TEXT, MENU_TEXT::DEF
        .byte   $ff,$ff,$29,$89,$2d,$c3,$ff,$00  ; "　　ぼうぎょ　"
        array_label MENU_TEXT, MENU_TEXT::EQUIP
        .byte   $05,$04,$9f,$2d,$85,$05,$0b,$63,$3f,$a9,$85,$00  ; "{tab:4}みぎて{tab:11}ひだりて"
.endif

; menu text region $07: current mp/max mp (for all characters)
        array_label MENU_TEXT, MENU_TEXT::CHAR_MP
        .byte   $07,$03,$03,$15,$07,$04,$01
        .byte   $08,$03,$03,$15,$08,$04,$01
        .byte   $09,$03,$03,$15,$09,$04,$01
        .byte   $0a,$03,$03,$15,$0a,$04,$00

; menu text region $0a-$0d: current mp/max mp (for one character)
        array_label MENU_TEXT, MENU_TEXT::CHAR1_MP
        .byte   $07,$03,$03,$15,$07,$04,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR2_MP
        .byte   $08,$03,$03,$15,$08,$04,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR3_MP
        .byte   $09,$03,$03,$15,$09,$04,$00
        array_label MENU_TEXT, MENU_TEXT::CHAR4_MP
        .byte   $0a,$03,$03,$15,$0a,$04,$00

.if ::LANG_EN

; menu text region $21: blank status names
        array_label MENU_TEXT, MENU_TEXT::BLANK_STATUS
        .byte   $10,$1f,$01,$10,$1f,$01,$10,$1f,$01,$10,$1f,$00

; menu text region $00: monster names
        array_label MENU_TEXT, MENU_TEXT::MONSTER_NAMES
        .byte   $0b,$00,$ff,$01,$0b,$01,$ff,$01,$0b,$02,$ff,$01,$0b,$03,$ff,$00

.else

        array_label MENU_TEXT, MENU_TEXT::BLANK_STATUS
        .byte   $10,$00,$01,$10,$01,$01,$10,$02,$01,$10,$03,$00

        array_label MENU_TEXT, MENU_TEXT::MONSTER_NAMES
        .byte   $0b,$00,$ff,$0c,$00,$ff,$ff,$01,$0b,$01,$ff,$0c,$01,$ff,$ff,$01
        .byte   $0b,$02,$ff,$0c,$02,$ff,$ff,$01,$0b,$03,$ff,$0c,$03,$ff,$ff,$00

.endif

; menu text region $01: character names
        array_label MENU_TEXT, MENU_TEXT::CHAR_NAMES
        .byte   $07,$00,$ff,$01,$08,$00,$ff,$01,$09,$00,$ff,$01,$0a,$00,$ff,$00

; menu text region $02: current hp (all characters)
        array_label MENU_TEXT, MENU_TEXT::CHAR_CURR_HP
        .byte   $07,$01,$01,$08,$01,$01,$09,$01,$01,$0a,$01,$00

; menu text region $03: atb gauge or max hp (all characters)
        array_label MENU_TEXT, MENU_TEXT::CHAR_MAX_HP
        .byte   $07,$02,$01,$08,$02,$01,$09,$02,$01,$0a,$02,$00

.if ::LANG_EN

; menu text region $1f: clear battle commands
        array_label MENU_TEXT, MENU_TEXT::CMD_SHORT
        .byte   $05,$06,$04,$21,$0d,$00,$05,$05,$01,$ff,$ff,$04,$21,$0d,$00,$16
        .byte   $16,$16,$ff,$ff,$04,$21,$0d,$00,$ff,$01,$16,$05,$06,$04,$21,$0d
        .byte   $00,$05,$05,$01,$05,$13,$00

; menu text region $20:
        array_label MENU_TEXT, MENU_TEXT::CONTROL
        .byte   $ff,$04,$21,$11,$00,$ff,$16,$01
        .byte   $ff,$04,$21,$11,$00,$ff,$16,$01
        .byte   $ff,$04,$21,$11,$00,$ff,$16,$01
        .byte   $ff,$04,$21,$11,$00,$ff,$16,$00

.else

; menu text region $1f: blank battle commands
        array_label MENU_TEXT, MENU_TEXT::CMD_SHORT
        .byte   $05,$06,$04,$21,$0d,$00,$05,$05,$01,$ff,$ff,$04,$21,$0d,$00,$16
        .byte   $16,$16,$ff,$ff,$04,$21,$0d,$00,$ff,$01,$16,$05,$06,$04,$21,$0d
        .byte   $00,$05,$05,$01,$05,$11,$00

        array_label MENU_TEXT, MENU_TEXT::CONTROL
        .byte   $ff,$ff,$04,$21,$0f,$00,$ff,$ff,$01
        .byte   $ff,$ff,$04,$21,$0f,$00,$ff,$ff,$01
        .byte   $ff,$ff,$04,$21,$0f,$00,$ff,$ff,$01
        .byte   $ff,$ff,$04,$21,$0f,$00,$ff,$ff,$00

.endif

; menu text region $04: battle command names
        array_label MENU_TEXT, MENU_TEXT::CMD_WINDOW
        .byte   $ff,$ff,$04,$21,$0d,$00,$ff,$01
        .byte   $ff,$ff,$04,$21,$0d,$00,$ff,$01
        .byte   $ff,$ff,$04,$21,$0d,$00,$ff,$01
        .byte   $ff,$ff,$04,$21,$0d,$00,$ff,$00

; menu text region $05: unknown/unused
        array_label MENU_TEXT, MENU_TEXT::MENU_TEXT_5
        .byte   $ff,$ff,$04,$21,$1b,$00,$ff,$01
        .byte   $ff,$ff,$04,$21,$1b,$00,$ff,$01
        .byte   $ff,$ff,$04,$21,$1b,$00,$ff,$01
        .byte   $ff,$ff,$04,$21,$1b,$00,$ff,$00

; ------------------------------------------------------------------------------

; color palettes (used for chadarnook battle)
ChadarnookBGPalLightsOn:
@e288:  .word   $0000,$31ad,$190a,$1d2b,$296b,$2129,$1d08,$1ce7
        .word   $18e7,$18a5,$0823,$0c64,$294a,$18c6,$0ca9,$0866
        .word   $3800,$4af8,$3a96,$2a34,$1dd2,$112e,$0ca9,$0866
        .word   $0823,$25d4,$14ed,$10a8,$0865,$0443,$2946,$2107
        .word   $3800,$09d3,$0cb2,$11cb,$1d70,$14ec,$10a8,$0c84
        .word   $0823,$420e,$296a,$1d70,$5273,$09d3,$0cb2,$11cb

ChadarnookBGPalLightsOff:
@e2e8:  .word   $0000,$0c84,$0c44,$0c64,$1084,$0c43,$0c62,$0c42
        .word   $0c42,$0c43,$0823,$0823,$0c63,$0c43,$0823,$0823
        .word   $3800,$112e,$0ca9,$18a7,$1485,$1444,$1443,$1023
        .word   $0823,$0823,$1046,$0845,$0824,$0823,$7fd4,$0823
        .word   $3800,$5230,$4914,$3deb,$0c64,$0845,$0824,$0823
        .word   $0823,$0c64,$0c44,$65b0,$1065,$0863,$0844,$0c62

; ------------------------------------------------------------------------------

; menu input state queue for each window

.mac menu_input_queue s1, s2, s3

        .byte MENU_INPUT::WAIT

        .ifnblank s1
        .byte MENU_INPUT::s1
        .else
        .byte MENU_INPUT::NONE
        .endif

        .ifnblank s2
        .byte MENU_INPUT::s2
        .else
        .byte MENU_INPUT::NONE
        .endif

        .ifnblank s3
        .byte MENU_INPUT::s3
        .else
        .byte MENU_INPUT::NONE
        .endif
.endmac

MenuInputQueue:
        menu_input_queue CMD_SELECT  ; $00: battle command
        menu_input_queue SLOT_INIT_HDMA, SLOT_FADE_IN, SLOT_SELECT  ; $01: slot
        menu_input_queue ITEM_SELECT  ; $02: item
        menu_input_queue EQUIP_SELECT  ; $03: equip
        menu_input_queue MAGIC_SELECT  ; $04: magic
        menu_input_queue CHAR_SELECT  ; $05: select next/previous character
        menu_input_queue SUMMON_SELECT  ; $06: summon
        menu_input_queue LORE_SELECT  ; $07: lore
        menu_input_queue ITEM_SELECT  ; $08: return to item window
        menu_input_queue RAGE_SELECT  ; $09: rage
        menu_input_queue DANCE_SELECT  ; $0a: dance
        menu_input_queue ROW_SELECT  ; $0b: row
        menu_input_queue DEF_SELECT  ; $0c: def
        menu_input_queue MAGITEK_SELECT  ; $0d: magitek
        menu_input_queue THROW_SELECT  ; $0e: throw
        menu_input_queue TOOLS_SELECT  ; $0f: tools
        menu_input_queue BUSHIDO_SELECT  ; $10: bushido
        menu_input_queue ; $11:
        menu_input_queue CHAR_STATUS_SELECT  ; $12: character status

; ------------------------------------------------------------------------------
