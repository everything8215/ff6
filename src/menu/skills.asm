
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: skills.asm                                                           |
; |                                                                            |
; | description: skills menu                                                   |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.include "btlgfx/blitz_code.inc"

inc_lang "text/attack_name_%s.inc"
inc_lang "text/blitz_desc_%s.inc"
inc_lang "text/bushido_desc_%s.inc"
inc_lang "text/bushido_name_%s.inc"
inc_lang "text/dance_name_%s.inc"
inc_lang "text/genju_attack_desc_%s.inc"
inc_lang "text/genju_bonus_desc_%s.inc"
inc_lang "text/genju_bonus_name_%s.inc"
inc_lang "text/genju_name_%s.inc"
inc_lang "text/lore_desc_%s.inc"
inc_lang "text/magic_desc_%s.inc"
inc_lang "text/magic_name_%s.inc"
inc_lang "text/monster_name_%s.inc"

.import MagicProp

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ init cursor (skills) ]

LoadSkillsCursor:
@4b50:  ldy     #near SkillsCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (skills) ]

UpdateSkillsCursor:
@4b56:  jsr     MoveCursor

InitSkillsCursor:
@4b59:  ldy     #near SkillsCursorPos
        jsr     UpdateCursorPos
        clr_a
        lda     zSelIndex         ; selected character
        asl
        tax
        lda     $4d
        sta     $0236,x     ; save cursor position
        lda     $4e
        sta     $0237,x
        rts

; ------------------------------------------------------------------------------

; skills cursor data
; NOTE: this is the only cursor that doesn't have an initial position of (0,0)
SkillsCursorProp:
        cursor_prop {0, 1}, {1, 7}, NO_X_WRAP

; skills cursor positions
SkillsCursorPos:
@4b74:  cursor_pos {0, 20}
        cursor_pos {0, 36}
        cursor_pos {0, 68}
        cursor_pos {0, 84}
        cursor_pos {0, 100}
        cursor_pos {0, 116}
        cursor_pos {0, 132}

; ------------------------------------------------------------------------------

; [ init cursor (magic) ]

LoadMagicCursor:
@4b82:  ldy     #near MagicCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (magic) ]

UpdateMagicCursor:
@4b88:  jsr     MoveListCursor

InitMagicCursor:
@4b8b:  ldy     #near MagicCursorPos
        jsr     UpdateListCursorPos
        clr_a
        lda     zSelIndex         ; character slot
        asl
        tax
        lda     $4f
        sta     $023e,x     ; save cursor position
        lda     $50
        sta     $023f,x
        lda     zSelIndex
        tax
        lda     $4a
        sta     $0246,x
        rts

; ------------------------------------------------------------------------------

; magic cursor data
MagicCursorProp:
.if LANG_EN
        cursor_prop {0, 0}, {2, 8}, NO_Y_WRAP
.else
        cursor_prop {0, 0}, {3, 9}, NO_Y_WRAP
.endif

; magic cursor positions
MagicCursorPos:
.if LANG_EN
        .repeat 8, yy
        cursor_pos {8, 116 + yy * 12}
        cursor_pos {112, 116 + yy * 12}
        .endrep
.else
        .repeat 9, yy
        cursor_pos {8, 104 + yy * 12}
        cursor_pos {80, 104 + yy * 12}
        cursor_pos {152, 104 + yy * 12}
        .endrep
.endif

; ------------------------------------------------------------------------------

; [ init cursor (blitz/swdtech/dance) ]

LoadAbilityCursor:
@4bce:  ldy     #near AbilityCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (blitz/swdtech/dance) ]

UpdateAbilityCursor:
@4bd4:  jsr     MoveCursor

InitAbilityCursor:
@4bd7:  ldy     #near AbilityCursorPos
        sty     $e7
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; blitz/swdtech/dance cursor data
AbilityCursorProp:
        cursor_prop {0, 0}, {2, 4}

; blitz/swdtech/dance cursor positions
AbilityCursorPos:
.if LANG_EN
        .repeat 4, yy
        cursor_pos {8, 116 + yy * 24}
        cursor_pos {120, 116 + yy * 24}
        .endrep
.else
        .repeat 4, yy
        cursor_pos {24, 116 + yy * 24}
        cursor_pos {136, 116 + yy * 24}
        .endrep
.endif
; ------------------------------------------------------------------------------

.if LANG_EN

; [ init cursor (lore) ]

LoadLoreCursor:
@4bf4:  ldy     #near LoreCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (lore) ]

UpdateLoreCursor:
@4bfa:  jsr     MoveListCursor

InitLoreCursor:
@4bfd:  ldy     #near LoreCursorPos
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; lore cursor data
LoreCursorProp:
        cursor_prop {0, 0}, {1, 8}, NO_Y_WRAP

; lore cursor positions
LoreCursorPos:
        .repeat 8, yy
        cursor_pos {8, 116 + yy * 12}
        .endrep

.else

        LoadLoreCursor := LoadGenjuCursor
        UpdateLoreCursor := UpdateGenjuCursor
        InitLoreCursor := InitGenjuCursor

.endif

; ------------------------------------------------------------------------------

; [ init cursor (espers select) ]

LoadGenjuCursor:
@4c18:  ldy     #near GenjuCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (espers select) ]

UpdateGenjuCursor:
@4c1e:  jsr     MoveListCursor

InitGenjuCursor:
@4c21:  ldy     #near GenjuCursorPos
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; espers select cursor data
GenjuCursorProp:
.if LANG_EN
        cursor_prop {0, 0}, {2, 8}, NO_Y_WRAP
.else
        cursor_prop {0, 0}, {2, 9}, NO_Y_WRAP
.endif

; espers select cursor positions
GenjuCursorPos:
.if LANG_EN
        .repeat 8, yy
        cursor_pos {8, 116 + yy * 12}
        cursor_pos {120, 116 + yy * 12}
        .endrep
.else
        .repeat 9, yy
        cursor_pos {8, 104 + yy * 12}
        cursor_pos {120, 104 + yy * 12}
        .endrep
.endif

; ------------------------------------------------------------------------------

; [ init cursor (rage) ]

LoadRageCursor:
@4c4c:  ldy     #near RageCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (rage) ]

UpdateRageCursor:
@4c52:  jsr     MoveListCursor

InitRageCursor:
@4c55:  ldy     #near RageCursorPos
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; rage cursor data
RageCursorProp:
.if LANG_EN
        cursor_prop {0, 0}, {2, 8}, NO_Y_WRAP
.else
        cursor_prop {0, 0}, {2, 9}, NO_Y_WRAP
.endif

; rage cursor positions
RageCursorPos:
.if LANG_EN
        .repeat 8, yy
        cursor_pos {24, 116 + yy * 12}
        cursor_pos {136, 116 + yy * 12}
        .endrep
.else
        .repeat 9, yy
        cursor_pos {24, 104 + yy * 12}
        cursor_pos {136, 104 + yy * 12}
        .endrep
.endif

; ------------------------------------------------------------------------------

; [ init bg (skills) ]

_c34c80:
@4c80:  stz     $9e                     ;
        jsr     DisableDMA2
        lda     #$01
        sta     hBG1SC
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        ldy     #near SkillsMagicWindow1
        jsr     DrawWindow
        ldy     #near SkillsCharWindow1
        jsr     DrawWindow
        ldy     #near SkillsDescWindow1
        jsr     DrawWindow
        ldy     #near SkillsOptionsWindow2
        jsr     DrawWindow
        ldy     #near SkillsOptionsWindow1
        jsr     DrawWindow
        ldy     #near SkillsMagicWindow2
        jsr     DrawWindow
        ldy     #near SkillsCharWindow2
        jsr     DrawWindow
        ldy     #near SkillsDescWindow2
        jsr     DrawWindow
        ldy     #near SkillsMPWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     _c34d27
        jsr     TfrBG1ScreenAB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     _c3a662
.if !LANG_EN
        jsr     _c3ae9a
.endif
        jsr     _c34d3d
        lda     zSkillsTextColor::Genju
        sta     zTextColor
        ldy     #near SkillsGenjuText
        jsr     DrawPosKana
        lda     zSkillsTextColor::Magic
        sta     zTextColor
        ldy     #near SkillsMagicText
        jsr     DrawPosKana
        lda     zSkillsTextColor::Bushido
        sta     zTextColor
        ldy     #near SkillsBushidoText
        jsr     DrawPosKana
        lda     zSkillsTextColor::Blitz
        sta     zTextColor
        ldy     #near SkillsBlitzText
        jsr     DrawPosKana
        lda     zSkillsTextColor::Lore
        sta     zTextColor
        ldy     #near SkillsLoreText
        jsr     DrawPosKana
        lda     zSkillsTextColor::Rage
        sta     zTextColor
        ldy     #near SkillsRageText
        jsr     DrawPosKana
        lda     zSkillsTextColor::Dance
        sta     zTextColor
        ldy     #near SkillsDanceText
        jsr     DrawPosKana
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c34d27:
@4d27:  jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        lda     #$24
        sta     zTextColor
        ldx     #near SkillsCharLabelTextList
        ldy     #sizeof_SkillsCharLabelTextList
        jsr     DrawPosList
        jmp     _c34ee5

; ------------------------------------------------------------------------------

; [ update skills text colors ]

_c34d3d:
@4d3d:  lda     #$24        ; init all skills to gray (disabled)
        ldx     z0
@4d41:  sta     zSkillsTextColor,x
        inx
        cpx     #$0007
        bne     @4d41
        jsr     _c34edd
        phy
        ldx     #$0004
@4d50:  phx
        ldx     z0
@4d53:  lda     $0016,y     ; battle command
        cmp     f:_c34d78,x
        bne     @4d60
        lda     #$20
        sta     zSkillsTextColor,x
@4d60:  inx
        cpx     #sizeof__c34d78
        bne     @4d53
        iny
        plx
        dex
        bne     @4d50
        ply
        lda     0,y                     ; espers always disabled for gogo
        cmp     #CHAR_PROP::GOGO
        bne     @4d77
        lda     #$24
        sta     zSkillsTextColor::Genju
@4d77:  rts

; ------------------------------------------------------------------------------

; battle commands for enabling skills
_c34d78:
        .byte   BATTLE_CMD::MAGIC  ; <- magic command enables the genju skill
        .byte   BATTLE_CMD::MAGIC
        .byte   BATTLE_CMD::BUSHIDO
        .byte   BATTLE_CMD::BLITZ
        .byte   BATTLE_CMD::LORE
        .byte   BATTLE_CMD::RAGE
        .byte   BATTLE_CMD::DANCE
        calc_size _c34d78

; ------------------------------------------------------------------------------

; [ draw magic menu ]

DrawMagicMenu:
@4d7f:  jsr     ClearBG1ScreenA
        jsr     CalcMagicOrder
        jsr     DrawMagicList
        lda     #$2c
        sta     zTextColor
.if !LANG_EN
        ldy     #near SkillsBlankTitleText
        jsr     DrawPosText
.endif
        ldy     #near SkillsMPCostText
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; window data for skills menu
; c3/4d98: bg2_0( 1, 1) [ 7x 4] espers/magic window
; c3/4d9c: bg2_0( 1, 7) [ 7x10] character skills list window
; c3/4da0: bg2_0( 1, 6) [28x 5] character info window
; c3/4da4: bg2_0( 1,13) [28x12] spell list window
; c3/4da8: bg2_0( 1, 1) [28x 3] description window
; c3/4dac: bg2_1( 1, 6) [28x 5] character window, top right screen
; c3/4db0: bg2_1( 1,13) [28x12] spell list window, top right screen
; c3/4db4: bg2_1(22, 4) [ 7x 1] mp cost window, top right screen
; c3/4db8: bg2_1( 1, 1) [28x 3] description window, top right screen

.if LANG_EN

SkillsOptionsWindow1:                   make_window BG2A, {1, 1}, {7, 4}
SkillsOptionsWindow2:                   make_window BG2A, {1, 7}, {7, 10}
SkillsCharWindow1:                      make_window BG2A, {1, 6}, {28, 5}
SkillsMagicWindow1:                     make_window BG2A, {1, 13}, {28, 12}
SkillsDescWindow1:                      make_window BG2A, {1, 1}, {28, 3}
SkillsCharWindow2:                      make_window BG2B, {1, 6}, {28, 5}
SkillsMagicWindow2:                     make_window BG2B, {1, 13}, {28, 12}
SkillsMPWindow:                         make_window BG2B, {22, 4}, {7, 1}
SkillsDescWindow2:                      make_window BG2B, {1, 1}, {28, 3}

.else

SkillsOptionsWindow1:                   make_window BG2A, {1, 1}, {6, 4}
SkillsOptionsWindow2:                   make_window BG2A, {1, 7}, {6, 10}
SkillsCharWindow1:                      make_window BG2A, {1, 5}, {28, 5}
SkillsMagicWindow1:                     make_window BG2A, {1, 12}, {28, 13}
SkillsDescWindow1:                      make_window BG2A, {9, 1}, {20, 2}
SkillsCharWindow2:                      make_window BG2B, {1, 5}, {28, 5}
SkillsMagicWindow2:                     make_window BG2B, {1, 12}, {28, 13}
SkillsMPWindow:                         make_window BG2B, {1, 1}, {6, 2}
SkillsDescWindow2:                      make_window BG2B, {9, 1}, {20, 2}

.endif

; ------------------------------------------------------------------------------

; [ init bg scrolling hdma (skills) ]

InitSkillsBGScrollHDMA:
@4dbc:  lda     #$02        ; hdma #5 - one address, write twice, absolue addressing
        sta     hDMA5::CTRL
        lda     #<hBG3VOFS
        sta     hDMA5::HREG
        ldy     #near SkillsBG3VScrollHDMATbl
        sty     hDMA5::ADDR
        lda     #^SkillsBG3VScrollHDMATbl
        sta     hDMA5::ADDR_B
        lda     #^SkillsBG3VScrollHDMATbl
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
        jsr     LoadSkillsBG1VScrollHDMATbl
        ldx     z0
@4ddf:  lda     f:SkillsBG1HScrollHDMATbl,x   ; load bg1 horizontal scroll hdma table
        sta     $7e9a09,x
        inx
        cpx     #sizeof_SkillsBG1HScrollHDMATbl
        bne     @4ddf
        lda     #$02        ; hdma #6 - one address, write twice, absolue addressing
        sta     hDMA6::CTRL
        lda     #<hBG1HOFS
        sta     hDMA6::HREG
        ldy     #$9a09      ; source = $7e9a09
        sty     hDMA6::ADDR
        lda     #$7e
        sta     hDMA6::ADDR_B
        lda     #$7e
        sta     hDMA6::HDMA_B
        lda     #$02        ; hdma #6 - one address, write twice, absolue addressing
        sta     hDMA7::CTRL
        lda     #<hBG1VOFS
        sta     hDMA7::HREG
        ldy     #$9849      ; source = $7e9849
        sty     hDMA7::ADDR
        lda     #$7e
        sta     hDMA7::ADDR_B
        lda     #$7e
        sta     hDMA7::HDMA_B
        lda     #BIT_6 | BIT_7
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (skills)
SkillsBG3VScrollHDMATbl:
        hdma_word 79, 2
        hdma_word 64, 2
        hdma_end

; ------------------------------------------------------------------------------

; [ load bg1 vertical scroll hdma table (skills) ]

LoadSkillsBG1VScrollHDMATbl:
@4e2d:  ldx     z0
@4e2f:  lda     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        cpx     #$0012
        bne     @4e2f
@4e3d:  lda     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        clr_a
        lda     $49         ; vertical scroll position
        asl4
        and     #$ff
        longa
        clc
        adc     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        shorta
        inx2
.if LANG_EN
        cpx     #$005a
.else
        cpx     #$0063
.endif
        bne     @4e3d
@4e63:  lda     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
.if LANG_EN
        cpx     #$005e
.else
        cpx     #$0067
.endif
        bne     @4e63
        rts

; ------------------------------------------------------------------------------

; bg1 horizontal scroll hdma table (skills)
SkillsBG1HScrollHDMATbl:
        hdma_word 39, $0100
.if LANG_EN
        hdma_word 72, $0100
        hdma_word 96, $0000
.else
        hdma_word 60, $0100
        hdma_word 108, $0000
.endif
        hdma_word 30, $0100
        hdma_end
        calc_size SkillsBG1HScrollHDMATbl

; bg1 vertical scroll hdma table (skills)
SkillsBG1VScrollHDMATbl:
        hdma_word 63, 0
        hdma_word 12, 4
        hdma_word 12, 8
        hdma_word 10, 12
        hdma_word 1, 12
.if LANG_EN
        hdma_word 13, 8
        hdma_word 4, -108
        hdma_word 4, -108
        hdma_word 4, -108
        hdma_word 4, -104
        hdma_word 4, -104
        hdma_word 4, -104
        hdma_word 4, -100
        hdma_word 4, -100
        hdma_word 4, -100
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
.else
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
.endif
        hdma_word 30, -224
        hdma_end
        calc_size SkillsBG1VScrollHDMATbl

; ------------------------------------------------------------------------------

; [  ]

_c34edd:
@4edd:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     zCharPropPtr,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34ee5:
@4ee5:  jsr     _c34edd
        sty     zSelCharPropPtr
        jmp     @4eed

; ???
.if LANG_EN
@4eed:  ldy_pos BG1B, {10, 10}
        ldx     #$4f50
.else
@4eed:  ldy_pos BG1B, {9, 10}
        ldx     #$4748
.endif
        jsr     DrawStatusIcons
        ldy     #near SkillsCharHPSlashText
        jsr     DrawPosText
        ldy     #near SkillsCharMPSlashText
        jsr     DrawPosText
        ldx     #near _c34f12
        jsr     DrawCharBlock

_c34f08:
@4f08:  lda     #$20
        sta     zTextColor
.if LANG_EN
        ldy_pos BG1B, {10, 7}
.else
        ldy_pos BG1B, {9, 6}
.endif
        jmp     DrawEquipGenju

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (skills)
_c34f12:
        make_pos BG1B, {23, 7}
        make_pos BG1B, {21, 9}
        make_pos BG1B, {26, 9}
        make_pos BG1B, {21, 11}
        make_pos BG1B, {26, 11}

; ------------------------------------------------------------------------------

; [ determine spell list display order ]

CalcMagicOrder:
_c34f1c:
@4f1c:  ldx     #$9d89
        stx     hWMADDL
.if LANG_EN
        ldx     #$0036
.else
        ldx     #$003c
.endif
        lda     #$ff
@4f27:  sta     hWMDATA
        dex
        bne     @4f27
        clr_ay
        lda     $1d54                   ; magic order
        and     #$07
        asl2
        tax
@4f37:  phx
        lda     f:MagicOrderTbl,x
        cmp     #$ff
        beq     @4f47
        jsr     _c34f61
        plx
        inx
        bra     @4f37
@4f47:  plx
        rts

; ------------------------------------------------------------------------------

; magic order offsets
MagicOrderTbl:
@4f49:  .byte   $2d,$00,$18,$ff
        .byte   $2d,$18,$00,$ff
        .byte   $00,$18,$2d,$ff
        .byte   $00,$2d,$18,$ff
        .byte   $18,$2d,$00,$ff
        .byte   $18,$00,$2d,$ff

; ------------------------------------------------------------------------------

; [ add spell type to spell list ]

_c34f61:
@4f61:  cmp     #$00                    ; first black magic spell id
        beq     @4f6e
        cmp     #$2d                    ; first white magic spell id
        beq     @4f73
        ldx     #$0015                  ; number of effect magic spells
        bra     @4f78
@4f6e:  ldx     #$0018                  ; number of black magic spells
        bra     @4f78
@4f73:  ldx     #$0009                  ; number of white magic spells
        bra     @4f78
@4f78:  stx     $e0
        tax
@4f7b:  tyx
        sta     $7e9d89,x
        inc
        iny
        dec     $e0
        bne     @4f7b
.if !LANG_EN
        iny3
.endif
        rts

; ------------------------------------------------------------------------------

; [ draw entire magic list ]

DrawMagicList:
@4f87:  jsr     GetListTextPos
.if LANG_EN
        ldy     #8
.else
        ldy     #9
.endif
@4f8d:  phy
        jsr     DrawMagicListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @4f8d
        rts

; ------------------------------------------------------------------------------

; [ draw one row of magic list ]

make_jump_label UpdateListText, LIST_TYPE::MAGIC
DrawMagicListRow:
@4f9e:  jsr     GetMagicNamePtr
        ldx     #$0003
        jsr     _c34fc4
        inc     $e5
        jsr     GetMagicNamePtr
.if LANG_EN
        ldx     #$0010
        jsr     _c34fc4
        inc     $e5
.else
        ldx     #$000c
        jsr     _c34fc4
        inc     $e5
        jsr     GetMagicNamePtr
        ldx     #$0015
        jsr     _c34fc4
        inc     $e5
.endif
        rts

; ------------------------------------------------------------------------------

; [ get pointer to magic spell name ]

GetMagicNamePtr:
@4fb5:  ldy     #MagicName::ITEM_SIZE
        sty     $eb
        ldy     #near MagicName
        sty     $ef
        lda     #^MagicName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34fc4:
@4fc4:  lda     $e6
.if LANG_EN
        inc
.endif
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        lda     $9e
        beq     @503e
        jsr     _c350ec
        jsr     _c3514d
        jsr     _c350ec
        cmp     #$ff
        beq     @501a
        jsr     _c350a2
        cmp     #$ff
        bne     @501a
        jsr     _c350ec
        jsr     LoadArrayItem
.if LANG_EN
        ldx     #$9e92
.else
        ldx     #$9e90
.endif
        stx     hWMADDL
        lda     #$ff
        sta     hWMDATA
        jsr     _c350ec
        jsr     _c3510d
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
.if LANG_EN
        lda     #$ff
        sta     hWMDATA
.endif
        stz     hWMDATA
        jmp     DrawPosTextBuf
@501a:  clr_a
        lda     $e5
        tax
        lda     #$ff
        sta     $7e9d89,x
        jsr     _c351b9
.if LANG_EN
        ldy     #$000b
.else
        ldy     #$0008
.endif
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5032:  sta     hWMDATA
        dey
        bne     @5032
        stz     hWMDATA
        jmp     DrawPosTextBuf
@503e:  jsr     _c350ec
        cmp     #$ff
        beq     @501a
        jsr     _c350a2
        cmp     #$00
        beq     @501a
        jsr     _c350ec
        jsr     LoadArrayItem
.if LANG_EN
        ldx     #$9e92
.else
        ldx     #$9e90
.endif
        stx     hWMADDL
        jsr     _c350ec
        jsr     _c350a2
        cmp     #$ff
        beq     @5088
        pha
        jsr     _c351b9
        lda     #$2c
        sta     zTextColor
.if LANG_EN
        lda     #$c7
        sta     hWMDATA
.endif
        pla
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        lda     #$cd
        sta     hWMDATA
@5082:  stz     hWMDATA
        jmp     DrawPosTextBuf
@5088:  lda     #$24
        sta     zTextColor
        jsr     _c350ec
        jsr     _c3514d
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
.if LANG_EN
        sta     hWMDATA
.endif
        bra     @5082

; ------------------------------------------------------------------------------

; [  ]

_c350a2:
@50a2:  sta     $e0
        jsr     _c34edd
        lda     0,y
        cmp     #CHAR_PROP::GOGO
        beq     _50c5

_c350ae:
@50ae:  sta     hWRMPYA
        lda     #$36
        sta     hWRMPYB
        clr_a
        lda     $e0
        longa
        adc     hRDMPYL
        tax
        shorta
        lda     $1a6e,x
        rts

_50c5:  stz     $e1
@50c7:  clr_a
        lda     $e1
        cmp     zSelIndex
        beq     @50e2
        asl
        tax
        ldy     zCharPropPtr,x
        beq     @50e2
        lda     0,y
        cmp     #CHAR_PROP::GOGO
        bcs     @50e2
        jsr     _c350ae
        cmp     #$ff
        beq     @50eb
@50e2:  inc     $e1
        lda     $e1
        cmp     #4
        bne     @50c7
        clr_a
@50eb:  rts

; ------------------------------------------------------------------------------

; [  ]

_c350ec:
@50ec:  clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c350f5:
@50f5:  pha
@50f6:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @50f6
        pla
        sta     hM7A
        stz     hM7A
        lda     #14
        sta     hM7B
        sta     hM7B
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3510d:
@510d:  pha
        jsr     _c350f5
        ldx     hMPYL
        lda     f:MagicProp+5,x   ; spell data
        sta     $e0
        pla
        cmp     #ATTACK::STEP_MINE
        bne     @512e
        lda     wGameTimeHours
        asl
        sta     $e0
        lda     wGameTimeMinutes
        cmp     #30
        bcc     @512e
        inc     $e0
@512e:  lda     $11d7
        bit     #$40
        beq     @513a
        clr_a
        lda     #$01
        bra     @514b
@513a:  lda     $11d7
        bit     #$20
        beq     @5148
        clr_a
        lda     $e0
        inc
        lsr
        bra     @514b
@5148:  clr_a
        lda     $e0
@514b:  tax
        rts

; ------------------------------------------------------------------------------

; [ set spell text color ]

.proc _c3514d
@514d:  cmp     #$2a
        beq     @517b
        cmp     #$12
        beq     @516e
@5155:  jsr     _c350f5
        ldx     hMPYL
        lda     f:MagicProp+3,x
        and     #$01
        beq     @516c
        jsr     _c350ec
        jsr     _c3510d
        jmp     @5188
@516c:  bra     _c351b9
@516e:  sta     $e3
        lda     $0201
        bit     #$01
        beq     @516c
        lda     $e3
        bra     @5155
@517b:  sta     $e3
        lda     $0201
        bit     #$02
        beq     @516c
        lda     $e3
        bra     @5155
@5188:  stx     $e2
        jsr     _c34edd
        lda     $0014,y
        and     #$20
        beq     @519b
        jsr     _c350ec
        cmp     #$23
        bne     _c351b9
@519b:  longa
        lda     $000d,y
        sta     $e0
        shorta
        ldx     $e2
        cpx     $e0
        beq     @51ac
        bcs     _c351b9
@51ac:  clr_a
        lda     $e5
        tax
        lda     #$20
        sta     zTextColor
        sta     $7e9e09,x
        rts

; set spell text color to gray

::_c351b9:
        clr_a
        lda     $e5
        tax
        lda     #$28
        sta     zTextColor
        sta     $7e9e09,x
        rts

.endproc  ; _c3514d

; ------------------------------------------------------------------------------

; [  ]

_c351c6:
@51c6:  lda     #$20
        sta     zTextColor
        longa
.if LANG_EN
        lda_pos BG3B, {27, 5}
.else
        lda_pos BG3B, {5, 2}
.endif
        sta     $7e9e89
        shorta
        ldx     #$9e8b
        stx     hWMADDL
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        jsr     _c3510d
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c351f9:
@51f9:  jsr     ClearBG1ScreenA
        jsr     DrawLoreList
        lda     #$2c
        sta     zTextColor
        ldy     #near SkillsLoreTitleText
        jsr     DrawPosKana
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [  ]

_c3520f:
@520f:  ldx     #$9d89
        stx     hWMADDL
        ldx     z0
        stz     $e0
@5219:  ldy     #8
        lda     $1d29,x     ; known lores
@521f:  ror
        pha
        bcc     @522a
        lda     $e0
        sta     hWMDATA
        bra     @522f
@522a:  lda     #$ff
        sta     hWMDATA
@522f:  inc     $e0
        pla
        dey
        bne     @521f
        inx
        cpx     #$0003
        bne     @5219
        rts

; ------------------------------------------------------------------------------

; [ draw entire lore list ]

DrawLoreList:
@523c:  jsr     _c3520f
        jsr     GetListTextPos
.if LANG_EN
        ldy     #8
.else
        ldy     #9
.endif
@5245:  phy
        jsr     DrawLoreListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @5245
        rts

; ------------------------------------------------------------------------------

; [ draw one row of lore list ]

make_jump_label UpdateListText, LIST_TYPE::LORE
DrawLoreListRow:
@5256:  lda     #$20
        sta     zTextColor
        jsr     _c35266
        ldx     #$0003
        jsr     _c35275
        inc     $e5
.if !LANG_EN
        jsr     _c35266
        ldx     #$0011
        jsr     _c35275
        inc     $e5
.endif
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35266:

@LoreName := AttackName+58*AttackName::ITEM_SIZE

@5266:  ldy     #AttackName::ITEM_SIZE
        sty     $eb
        ldy     #near @LoreName
        sty     $ef
        lda     #^@LoreName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35275:
@5275:  lda     $e6
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
        beq     @52c0
        lda     $e5
        jsr     LoadArrayItem
.if LANG_EN
        ldx     #$9e95
.else
        ldx     #$9e93
.endif
        stx     hWMADDL
        lda     #$c7
        sta     hWMDATA
        lda     $e5
        clc
        adc     #$8b
        jsr     _c3510d
        jsr     HexToDec3
        lda     $f7
        sta     hWMDATA
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf
.if LANG_EN
@52c0:  ldy     #$000e
.else
@52c0:  ldy     #$000c
.endif
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@52cb:  sta     hWMDATA
        dey
        bne     @52cb
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c352d7:
@52d7:  jsr     ClearBG1ScreenA
        jsr     _c3536e
.if LANG_EN
        lda     #$20
        sta     zTextColor
        jsr     _c352f4
.else
        jsr     _c3ae09
.endif
        lda     #$2c
        sta     zTextColor
        ldy     #near SkillsBushidoTitleText
        jsr     DrawPosKana
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

.if LANG_EN

; [  ]

_c352f4:
@52f4:  jsr     GetListTextPos
        inc     $e6
        stz     $e5
        ldy     #$0004
@52fe:  phy
        jsr     _c35311
        lda     $e6
        inc4
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @52fe
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35311:
@5311:  jsr     _c35328
        ldx     #$0003
        jsr     _c35337
        inc     $e5
        jsr     _c35328
        ldx     #$0011
        jsr     _c35337
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35328:
@5328:  ldy     #BushidoName::ITEM_SIZE
        sty     $eb
        ldy     #near BushidoName
        sty     $ef
        lda     #^BushidoName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35337:
@5337:  lda     $e6
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
        beq     @5357
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@5357:  ldy     #$000c
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5362:  sta     hWMDATA
        dey
        bne     @5362
        stz     hWMDATA
        jmp     DrawPosTextBuf

.endif

; ------------------------------------------------------------------------------


; [  ]

_c3536e:
@536e:  ldx     #$9d89
        stx     hWMADDL
        ldy     #$0008
        stz     $e0
        clr_a
        lda     $1cf7
@537d:  ror
        pha
        bcc     @5385
        lda     $e0
        bra     @5387
@5385:  lda     #$ff
@5387:  sta     hWMDATA
        inc     $e0
        pla
        dey
        bne     @537d
        rts

; ------------------------------------------------------------------------------

; [ init rage list ]

InitRageList:
@5391:  jsr     ClearBG1ScreenA
        jsr     DrawRageList
        lda     #$2c
        sta     zTextColor
        ldy     #near SkillsRageTitleText
        jsr     DrawPosKana
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw entire rage list ]

.proc DrawRageList
        jsr     ExpandRageList
        jsr     GetListTextPos
        ldy     #9
:       phy
        jsr     DrawRageListRow
        lda     $e6
        inc2
        and     #%11111
        sta     $e6
        ply
        dey
        bne     :-
        rts
.endproc  ; DrawRageList

; ------------------------------------------------------------------------------

; [ expand 1-bit rage list in sram to 1-byte per rage list in wram ]

ExpandRageList:
@53c1:  ldx     #$9d89
        stx     hWMADDL
        ldx     z0
        stz     $e0
@53cb:  ldy     #$0008
        lda     $1d2c,x                 ; known rages
@53d1:  ror
        pha
        bcc     @53dc
        lda     $e0
        sta     hWMDATA
        bra     @53e1
@53dc:  lda     #$ff
        sta     hWMDATA
@53e1:  inc     $e0
        pla
        dey
        bne     @53d1
        inx
        cpx     #$0020
        bne     @53cb
        rts

; ------------------------------------------------------------------------------

; [ draw one row of rage list ]

make_jump_label UpdateListText, LIST_TYPE::RAGE
DrawRageListRow:
@53ee:  lda     #$20
        sta     zTextColor
        jsr     GetMonsterNamePtr
        ldx     #$0005
        jsr     DrawRageName
        inc     $e5
        jsr     GetMonsterNamePtr
        ldx     #$0013
        jsr     DrawRageName
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get pointer to monster name ]

GetMonsterNamePtr:
@5409:  ldy     #MonsterName::ITEM_SIZE
        sty     $eb
        ldy     #near MonsterName
        sty     $ef
        lda     #^MonsterName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [ draw monster name for rage list ]

DrawRageName:
@5418:  lda     $e6
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
        beq     @543b
        lda     $e5
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@543b:  ldy     #MonsterName::ITEM_SIZE
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5446:  sta     hWMDATA
        dey
        bne     @5446
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw esper selection menu ]

DrawGenjuMenu:
@5452:  jsr     ClearBG1ScreenA
        lda     #$20
        sta     zTextColor
        jsr     DrawGenjuList
        lda     #$2c
        sta     zTextColor
        ldy     #near SkillsGenjuTitleText
        jsr     DrawPosKana
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw entire esper list ]

DrawGenjuList:
@546c:  jsr     GetGenjuList
        jsr     GetListTextPos
.if LANG_EN
        ldy     #8
.else
        ldy     #9
.endif
@5475:  phy
        jsr     DrawGenjuListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @5475
        rts

; ------------------------------------------------------------------------------

; [  ]

GetGenjuList:
@5486:  ldx     #$9ded
        stx     hWMADDL
        ldx     z0
        stz     $e0
@5490:  ldy     #8
        lda     $1a69,x     ; current espers
@5496:  ror
        pha
        bcc     @54a1
        lda     $e0
        sta     hWMDATA
        bra     @54a6
@54a1:  lda     #$ff
        sta     hWMDATA
@54a6:  inc     $e0
        pla
        dey
        bne     @5496
        inx
        cpx     #$0004
        bne     @5490
        ldx     #$9d89
        stx     hWMADDL
        lda     #$ff
        ldx     #$001d
@54bd:  sta     hWMDATA
        dex
        bne     @54bd
        ldx     #$9ded
        stx     hWMADDL
        ldy     #$001b
        clr_a
@54cd:  lda     hWMDATA
        bmi     @54df
        pha
        tax
        lda     f:GenjuOrder,x   ; esper order for menu
        dec
        tax
        pla
        sta     $7e9d89,x
@54df:  dey
        bne     @54cd
        rts

; ------------------------------------------------------------------------------

.pushseg

.segment "genju_order"

; d1/f9b5
GenjuOrder:
        .byte   1                       ; RAMUH
        .byte   5                       ; IFRIT
        .byte   6                       ; SHIVA
        .byte   3                       ; SIREN
        .byte   19                      ; TERRATO
        .byte   9                       ; SHOAT
        .byte   8                       ; MADUIN
        .byte   12                      ; BISMARK
        .byte   4                       ; STRAY
        .byte   16                      ; PALIDOR
        .byte   18                      ; TRITOCH
        .byte   23                      ; ODIN
        .byte   27                      ; RAIDEN
        .byte   24                      ; BAHAMUT
        .byte   21                      ; ALEXANDR
        .byte   26                      ; CRUSADER
        .byte   25                      ; RAGNAROK
        .byte   2                       ; KIRIN
        .byte   14                      ; ZONESEEK
        .byte   11                      ; CARBUNKL
        .byte   10                      ; PHANTOM
        .byte   15                      ; SRAPHIM
        .byte   13                      ; GOLEM
        .byte   7                       ; UNICORN
        .byte   17                      ; FENRIR
        .byte   20                      ; STARLET
        .byte   22                      ; PHOENIX

.popseg

; ------------------------------------------------------------------------------

; [ draw one row of esper list ]

make_jump_label UpdateListText, LIST_TYPE::GENJU
DrawGenjuListRow:
@54e3:  jsr     _c354fa
        ldx     #$0003
        jsr     _c35509
        inc     $e5
        jsr     _c354fa
        ldx     #$0011
        jsr     _c35509
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c354fa:
@54fa:  ldy     #GenjuName::ITEM_SIZE
        sty     $eb
        ldy     #near GenjuName
        sty     $ef
        lda     #^GenjuName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35509:
@5509:  lda     $e6
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
        beq     @555d
        jsr     _c35574
        jsr     LoadArrayItem
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        clc
        adc     #$36
        jsr     _c3510d
        pha
        ldx     #$9e93
        stx     hWMADDL
        lda     #$c7
        sta     hWMDATA
        pla
        jsr     HexToDec3
        lda     $f7
        sta     hWMDATA
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf
@555d:  ldy     #$000c
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5568:  sta     hWMDATA
        dey
        bne     @5568
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35574:
@5574:  sta     $e0
        ldx     z0
        ldy     #$0010
@557b:  lda     $161e,x     ; esper
        cmp     $e0
        beq     @5593
        longa
        txa
        clc
        adc     #$0025
        tax
        shorta
        dey
        bne     @557b
        lda     #$20
        bra     @5595
@5593:  lda     #$28
@5595:  sta     zTextColor
        lda     $e0
        rts

; ------------------------------------------------------------------------------

; [ show error message if esper is already equipped ]

_c3559a:
@559a:  lda     #$20
        sta     zTextColor
        longa
.if LANG_EN
        lda_pos BG1B, {2, 2}
.else
        lda_pos BG1B, {10, 2}
.endif
        sta     $7e9e89
        lda     #$9e8b
        sta     hWMADDL
        shorta
        ldy     #6
@55b2:  lda     $1602,x                 ; load character name
        cmp     #$ff
        beq     @55c0
        sta     hWMDATA
        inx
        dey
        bne     @55b2
@55c0:  ldx     z0
@55c2:  lda     f:GenjuEquipErrorMsgText,x
        beq     @55ce
        sta     hWMDATA
        inx
        bra     @55c2
@55ce:  stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw blitz menu ]

DrawBlitzMenu:
@55d4:  jsr     ClearBG1ScreenA
        jsr     DrawBlitzList
        lda     #$2c
        sta     zTextColor
        ldy     #near SkillsBlitzTitleText
        jsr     DrawPosKana
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw entire list of blitz inputs ]

DrawBlitzList:
@55ea:  jsr     GetBlitzList
        jsr     GetListTextPos
        stz     $e5
        inc     $e6
.if !LANG_EN
        inc     $e6
        inc     $e6
.endif
        ldy     #4
@55f7:  phy
        jsr     DrawBlitzListRow
        lda     $e6
        inc4
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @55f7
        rts

; ------------------------------------------------------------------------------

; [ draw one row of blitz inputs ]

DrawBlitzListRow:
.if LANG_EN
@560a:  ldx     #4
        jsr     DrawBlitzInput
        inc     $e5
        ldx     #18
        jsr     DrawBlitzInput
.else
        ldx     #5
        jsr     DrawBlitzInput
        inc     $e5
        ldx     #19
        jsr     DrawBlitzInput
.endif
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get list of known blitzes or dances ]

GetBlitzList:
@561b:  lda     $1d28
        bra     _5623

GetDanceList:
@5620:  lda     $1d4c
_5623:  ldx     #$9d89
        stx     hWMADDL
        ldx     z0
        ldy     #8
@562e:  ror
        pha
        bcc     @5638
        txa
        sta     hWMDATA
        bra     @563d
@5638:  lda     #$ff
        sta     hWMDATA
@563d:  inx
        pla
        dey
        bne     @562e
        rts

; ------------------------------------------------------------------------------

; [ draw blitz button input code ]

DrawBlitzInput:
@5643:  lda     $e6
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
        beq     @566c
        jsr     GetBlitzInputTiles
        ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jmp     _c356bc
@566c:  ldy     #$0008
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5677:  sta     hWMDATA
        dey
        bne     @5677
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ get tiles for blitz button input code ]

GetBlitzInputTiles:
@5683:  pha
        asl3
        sta     $e0
        pla
        asl2
        clc
        adc     $e0
        tax
        ldy     #$9e8b
        sty     hWMADDL
        ldy     #10
@5699:  phx
        lda     f:BlitzCode,x
        asl
        tax
        lda     f:BlitzInputTileTbl,x
        sta     hWMDATA
        inx
        lda     f:BlitzInputTileTbl,x
        sta     hWMDATA
        inx
        plx
        inx
        dey
        bne     @5699
        stz     hWMDATA
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [  ]

_c356bc:
@56bc:  ldy     z0
        longa
        lda     [$e7]
        sta     $eb
        inc     $e7
        inc     $e7
        shorta
        lda     #$7e
        sta     $ed
@56ce:  longa
        lda     [$e7],y
        beq     @56dc
        sta     [$eb],y
        shorta
        iny2
        bra     @56ce
@56dc:  shorta
        rts

; ------------------------------------------------------------------------------

; [ load esper attack description ]

LoadGenjuAttackDesc:
@56df:  jsr     GetLoadGenjuAttackDescPtr
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load magic description ]

LoadMagicDesc:
@56e5:  jsr     GetMagicDescPtr
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load lore description ]

LoadLoreDesc:
@56eb:  ldx     #near LoreDescPtrs
        stx     $e7
        ldx     #near LoreDesc
        stx     $eb
        lda     #^LoreDescPtrs
        sta     $e9
        lda     #^LoreDesc
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load swdtech description ]

LoadBushidoDesc:
@5700:  ldx     #near BushidoDescPtrs
        stx     $e7
        ldx     #near BushidoDesc
        stx     $eb
        lda     #^BushidoDescPtrs
        sta     $e9
        lda     #^BushidoDesc
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load blitz description ]

LoadBlitzDesc:
@5715:  ldx     #near BlitzDescPtrs
        stx     $e7
        ldx     #near BlitzDesc
        stx     $eb
        lda     #^BlitzDescPtrs
        sta     $e9
        lda     #^BlitzDesc
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load description text ]

.proc LoadBigText

_572a:  ldx     #$9ec9
        stx     hWMADDL
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x

::LoadItemDesc:
_5738:  cmp     #$ff
        beq     _576d

::_c35d99:
        longa
        asl
        tay
        lda     [$e7],y
        tay
        shorta
_5745:  lda     [$eb],y
        beq     _574f
        sta     hWMDATA
        iny
        bra     _5745
_574f:  dey
        lda     [$eb],y
        iny
        cmp     #$1c
        beq     _5767
        cmp     #$1d
        beq     _5767
        cmp     #$1e
        beq     _5767
        cmp     #$1f
        beq     _5767
_5763:  stz     hWMDATA
        rts
_5767:  stz     hWMDATA
        iny
        bra     _5745
_576d:  lda     #$ff
        sta     hWMDATA
        bra     _5763
.endproc

; ------------------------------------------------------------------------------

; [ draw dance menu ]

DrawDanceMenu:
@5774:  jsr     ClearBG1ScreenA
        jsr     DrawDanceList
        lda     #$2c
        sta     zTextColor
        ldy     #near SkillsDanceTitleText
        jsr     DrawPosKana
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw dance list text ]

DrawDanceList:
@578a:  jsr     GetDanceList
        jsr     GetListTextPos
        inc     $e6
.if !LANG_EN
        inc     $e6
.endif
        stz     $e5
        ldy     #4
@5797:  phy
        jsr     DrawDanceListRow
        lda     $e6
        inc4
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @5797
        rts

; ------------------------------------------------------------------------------

; [ draw one row of dance list (2 dance names) ]

DrawDanceListRow:
@57aa:  jsr     GetDanceNamePtr
.if LANG_EN
        ldx     #3
        jsr     DrawDanceName
        inc     $e5
        jsr     GetDanceNamePtr
        ldx     #17
        jsr     DrawDanceName
.else
        ldx     #5
        jsr     DrawDanceName
        inc     $e5
        jsr     GetDanceNamePtr
        ldx     #19
        jsr     DrawDanceName
.endif
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get pointer to dance name ]

GetDanceNamePtr:
@57c1:  ldy     #DanceName::ITEM_SIZE
        sty     $eb
        ldy     #near DanceName
        sty     $ef
        lda     #^DanceName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [ draw dance name ]

DrawDanceName:
@57d0:  lda     $e6
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
        beq     @57f0
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@57f0:  ldy     #DanceName::ITEM_SIZE
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@57fb:  sta     hWMDATA
        dey
        bne     @57fb
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35807:
@5807:  clr_a
        lda     $60
        tax
        lda     #$ff
        sta     $7e35c9,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35812:
@5812:  jsr     ClearBG2ScreenA
        ldy     #near _c3583f
        jsr     DrawWindow
        ldy     #near _c35843
        jsr     DrawWindow
        ldy     #near _c35847
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenB
        ldy     #$ffc0
        sty     zBG1HScroll
        lda     #$02
        tsb     z45
        jsr     _c3318a
        jsr     _c3584b
        jmp     _c3319f

; ------------------------------------------------------------------------------

_c3583f:
@583f:  .byte   $9d,$58,$13,$18

_c35843:
@5843:  .byte   $8b,$58,$07,$02

_c35847:
@5847:  .byte   $8b,$59,$07,$03

; ------------------------------------------------------------------------------

; [  ]

_c3584b:
@584b:  lda     #$20
        sta     zTextColor
        ldy     #near _c35889
        jsr     DrawPosKana
.if LANG_EN
        ldy     #near _c3588e
        jsr     DrawPosText
.endif
        clr_a
        lda     $4b
        sta     $e5
        jsr     GetMagicNamePtr
        longa
.if LANG_EN
        lda_pos BG3A, {2, 3}
.else
        lda_pos BG3A, {3, 2}
.endif
        sta     $7e9e89
        shorta
        jsr     _c350ec
        jsr     LoadArrayItem
        jsr     DrawPosTextBuf
        jsr     _c350ec
        jsr     _c3510d
        jsr     HexToDec3
.if LANG_EN
        ldx_pos BG3A, {3, 7}
.else
        ldx_pos BG3A, {5, 8}
.endif
        jsr     DrawNum2
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

_c35889:
.if LANG_EN
@5889:  .byte   $15,$7a,$8c,$8f,$00

_c3588e:
@588e:  .byte   $4d,$7a,$8d,$9e,$9e,$9d,$9e,$9d,$00

.else
        .byte   $cd,$79,$77,$c3,$89,$63,$ff,$5d,$5f,$00
.endif

; ------------------------------------------------------------------------------

; [ init esper detail menu ]

InitEsperDetailMenu:
@5897:  ldy     $4f
        sty     $8e
        lda     $4a
        sta     $90
        jsr     LoadGenjuProp
        jsr     DrawEsperDetailMenu
        jsr     InitDMA1BG1ScreenB
        jsr     WaitVblank
        jsr     InitDMA1BG1ScreenA
        longa
        lda     #$0100
        sta     $7e9a10
        shorta
        lda     $49
        sta     $5f
        lda     #$07
        sta     $49
        jsr     LoadSkillsBG1VScrollHDMATbl
        lda     #$c0
        trb     z46
        jsr     LoadGenjuDetailCursor
        jmp     InitGenjuDetailCursor

; ------------------------------------------------------------------------------

; [ menu state $4d: esper detail ]

MenuState_4d:
@58ce:  jsr     UpdateGenjuDetailCursor
        jsr     _c35b93

; A button
        lda     z08
        bit     #JOY_A
        beq     @590a
        clr_a
        lda     $4b
        bne     @590a
        lda     $99
        jsr     _c35574
        sta     $e0
        lda     zTextColor
        cmp     #$28
        bne     @5902
        jsr     PlayInvalidSfx
        lda     #$10
        tsb     z45
        jsr     _c3559a
        ldy     #$0020
        sty     zWaitCounter
        lda     #$34
        sta     zMenuState
        jmp     InitDMA1BG1ScreenB

; equip esper
@5902:  jsr     PlaySelectSfx
        jsr     _c32929
        bra     _c35913

; B button
@590a:  lda     z08+1
        bit     #>JOY_B
        beq     _597c
        jsr     PlayCancelSfx

_c35913:
@5913:  lda     #$10
        tsb     z45
        lda     $5f
        sta     $49
        jsr     DrawGenjuList
        jsr     CreateScrollArrowTask1
        longa
.if LANG_EN
        lda     #$1000
.else
        lda     #$1333
.endif
        sta     wTaskSpeedY,x
        lda     #$0060
        sta     wTaskSpeedX,x
        shorta
        jsr     LoadGenjuCursor
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
        jsr     InitGenjuCursor
.if LANG_EN
        lda     #$06
        sta     $5c
        lda     #$08
.else
        lda     #$05
        sta     $5c
        lda     #$09
.endif
        sta     $5a
        lda     #$02
        sta     $5b
        jsr     InitDMA1BG1ScreenA
        jsr     WaitVblank
        longa
        clr_a
        sta     $7e9a10
        shorta
        ldy     #$0100
        sty     zBG2HScroll
        sty     zBG3HScroll
        jsr     LoadSkillsBG1VScrollHDMATbl
        jsr     InitDMA1BG1ScreenB
        lda     #$1e
        sta     zMenuState
_597c:  rts

; ------------------------------------------------------------------------------

; [ load cursor for esper details ]

LoadGenjuDetailCursor:
@597d:  ldy     #near GenjuDetailCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor positions for esper details ]

UpdateGenjuDetailCursor:
@5983:  jsr     MoveCursor

InitGenjuDetailCursor:
@5986:  ldy     #near GenjuDetailCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GenjuDetailCursorProp:
        cursor_prop {0, 0}, {1, 7}, NO_X_WRAP

GenjuDetailCursorPos:
@5991:  cursor_pos {16, 112}
        cursor_pos {24, 124}
        cursor_pos {24, 136}
        cursor_pos {24, 148}
        cursor_pos {24, 160}
        cursor_pos {24, 172}
        cursor_pos {24, 184}

; ------------------------------------------------------------------------------

; [ draw esper detail menu ]

DrawEsperDetailMenu:
@599f:  lda     #$20
        sta     zTextColor
        ldy     #near GenjuLearnRateText
        jsr     DrawPosKana
        ldy     #near GenjuLearnPctText
        jsr     DrawPosKana
        lda     z99
        jsr     _c35574
.if LANG_EN
        ldy_pos BG1B, {4, 15}
.else
        ldy_pos BG1B, {4, 16}
.endif
        jsr     InitTextBuf
        clr_a
        lda     z99
        asl3
        tax
        ldy     #8
@59c4:  lda     f:GenjuName,x
        sta     hWMDATA
        inx
        dey
        bne     @59c4
        stz     hWMDATA
        jsr     DrawPosTextBuf
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        sta     hWRMPYA
        lda     #11
        sta     hWRMPYB
        lda     #$20
        sta     zTextColor
.if LANG_EN
        ldy     #$0011
.else
        ldy     #$0012
.endif
        sty     $f5
        longa
        lda     hRDMPYL
        tax
@59f4:  shorta
        lda     f:GenjuProp,x               ; magic learn rate
        sta     $e0
        inx
        lda     f:GenjuProp,x               ; magic spell id
        sta     $e1
        inx
        phx
        ldx     #$0005
        ldy     $f5
        lda     $e1
        pha
        jsr     DrawGenjuMagicName
        ldx     #$0018
        ldy     $f5
        pla
        sta     $e1
        jsr     _c35a84
        plx
        longa
        inc     $f5
        inc     $f5
        lda     $f5
.if LANG_EN
        cmp     #$001b
.else
        cmp     #$001c
.endif
        bne     @59f4
        shorta
        lda     f:GenjuProp,x               ; level up bonus
        cmp     #$ff
        beq     @5a67
        sta     hWRMPYA
        lda     #GenjuBonusName::ITEM_SIZE
        sta     hWRMPYB
.if LANG_EN
        ldy_pos BG1B, {5, 27}
.else
        ldy_pos BG1B, {5, 28}
.endif
        jsr     InitTextBuf
        ldx     z0
@5a43:  lda     f:GenjuAtLevelUpText,x
        sta     hWMDATA
        inx
        cpx     #sizeof_GenjuAtLevelUpText
        bne     @5a43
        ldx     hRDMPYL
        ldy     #GenjuBonusName::ITEM_SIZE
@5a56:  lda     f:GenjuBonusName,x
        sta     hWMDATA
        inx
        dey
        bne     @5a56
        stz     hWMDATA
        jmp     DrawPosTextBuf
.if LANG_EN
@5a67:  ldy_pos BG1B, {5, 27}
.else
@5a67:  ldy_pos BG1B, {5, 28}
.endif
        jsr     InitTextBuf
        ldy     #sizeof_GenjuAtLevelUpText + GenjuBonusName::ITEM_SIZE
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5a78:  sta     hWMDATA
        dey
        bne     @5a78
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35a84:
@5a84:  jsr     GetBG1ScreenBPtr
        longa
        txa
        sta     $7e9e89
        shorta
        ldx     #$9e8b
        stx     hWMADDL
        lda     $e1
        cmp     #$ff
        beq     @5ad1
        jsr     _c350a2
        cmp     #$ff
        beq     @5ac2
        pha
        lda     #$ff
        sta     hWMDATA
        pla
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
@5ab7:  lda     #$cd
        sta     hWMDATA
@5abc:  stz     hWMDATA
        jmp     DrawPosTextBuf
@5ac2:  lda     #ZERO_CHAR+1
        sta     hWMDATA
        lda     #ZERO_CHAR
        sta     hWMDATA
        sta     hWMDATA
        bra     @5ab7
@5ad1:  lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        bra     @5abc

; ------------------------------------------------------------------------------

; [ draw magic name and learn rate in esper/armor detail menu ]

DrawGenjuMagicName:
@5ae1:  jsr     GetBG1ScreenBPtr
        longa
        txa
        sta     $7e9e89
        shorta

DrawItemMagicName:
@5aed:  jsr     GetMagicNamePtr
        lda     $e1
        cmp     #$ff
        beq     @5b26
        jsr     LoadArrayItem
.if LANG_EN
        ldx     #$9e92
.else
        ldx     #$9e90
.endif
        stx     hWMADDL
        lda     #COLON_CHAR
        sta     hWMDATA
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
.if !LANG_EN
        sta     hWMDATA
.endif
        lda     #$d7                    ; multiplication sign
        sta     hWMDATA
        lda     $e0
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf

; empty magic slot
.if LANG_EN
@5b26:  ldy     #15
.else
@5b26:  ldy     #13
.endif
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5b31:  sta     hWMDATA
        dey
        bne     @5b31
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ get tilemap offset (bg1, screen B) ]

; Y: vertical position
; X: horizontal position

GetBG1ScreenBPtr:
@5b3d:  longa
        tya
        asl6
        sta     $e7
        txa
        asl
        clc
        adc     $e7
        adc     #near wBG1Tiles::ScreenB
        tax
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load esper properties ]

LoadGenjuProp:
@5b54:  clr_a
        lda     $99
        sta     $7eab8d
        lda     $4b
        tax
        lda     $7e9d89,x
        sta     hWRMPYA
        lda     #11
        sta     hWRMPYB
        phb
        lda     #$7e
        pha
        plb
        ldy     #$0001
        longa
        lda     f:hRDMPYL
        tax
        shorta
@5b7b:  inx
        lda     f:GenjuProp,x               ; esper properties
        sta     $ab8d,y
        inx
        iny
        cpy     #6
        bne     @5b7b
        lda     f:GenjuProp,x
        sta     $ab93
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35b93:
@5b93:  ldx     #$9ec9
        stx     hWMADDL
        clr_a
        lda     $4b
        tax
        lda     $7eab8d,x
        cmp     #$ff
        beq     @5bd1
        pha
        jsr     GetGenjuDescPtr
        pla
        longa
        asl
        tay
        lda     [$e7],y
        tay
        shorta
@5bb3:  lda     [$eb],y
        beq     @5bbd
        sta     hWMDATA
        iny
        bra     @5bb3
@5bbd:  dey
        lda     [$eb],y
        iny
        cmp     #$1c
        beq     @5bd5
        cmp     #$1d
        beq     @5bd5
        cmp     #$1e
        beq     @5bd5
        cmp     #$1f
        beq     @5bd5
@5bd1:  stz     hWMDATA
        rts
@5bd5:  stz     hWMDATA
        iny
        bra     @5bb3

; ------------------------------------------------------------------------------

; [ load esper or magic description for esper menu ]

GetGenjuDescPtr:
@5bdb:  lda     $4b
        beq     GetLoadGenjuAttackDescPtr
        cmp     #$06
        beq     GetGenjuBonusDescPtr

GetMagicDescPtr:
@5be3:  ldx     #near MagicDescPtrs
        stx     $e7
        ldx     #near MagicDesc
        stx     $eb
        lda     #^MagicDescPtrs
        sta     $e9
        lda     #^MagicDesc
        sta     $ed
        rts

GetGenjuBonusDescPtr:
@5bf6:  ldx     #near GenjuBonusDescPtrs
        stx     $e7
        ldx     #near GenjuBonusDesc
        stx     $eb
        lda     #^GenjuBonusDescPtrs
        sta     $e9
        lda     #^GenjuBonusDesc
        sta     $ed
        rts

GetLoadGenjuAttackDescPtr:
@5c09:  ldx     #near GenjuAttackDescPtrs
        stx     $e7
        ldx     #near GenjuAttackDesc
        stx     $eb
        lda     #^GenjuAttackDescPtrs
        sta     $e9
        lda     #^GenjuAttackDesc
        sta     $ed
        rts

; ------------------------------------------------------------------------------

BlitzInputTileTbl:
.if LANG_EN
@5c1c:  .word   $0000,$0000,$0000,$2097,$2098,$208b,$2091,$20d6
@5c2c:  .word   $a0d4,$60d6,$20d5,$c0d6,$20d4,$a0d6,$60d5
.else
@5c1c:  .word   $0000,$0000,$0000,$2037,$2038,$202b,$2031,$20d6
@5c2c:  .word   $a0d4,$60d6,$20d5,$c0d6,$20d4,$a0d6,$60d5
.endif

; unused
SkillsListTextPtrs:
@5c3a:  .addr   SkillsGenjuText
        .addr   SkillsMagicText
        .addr   SkillsBushidoText
        .addr   SkillsBlitzText
        .addr   SkillsLoreText
        .addr   SkillsRageText
        .addr   SkillsDanceText

SkillsGenjuText:                pos_text SKILLS_LIST_GENJU
SkillsMagicText:                pos_text SKILLS_LIST_MAGIC
SkillsBushidoText:              pos_text SKILLS_LIST_BUSHIDO
SkillsBlitzText:                pos_text SKILLS_LIST_BLITZ
SkillsLoreText:                 pos_text SKILLS_LIST_LORE
SkillsRageText:                 pos_text SKILLS_LIST_RAGE
SkillsDanceText:                pos_text SKILLS_LIST_DANCE

SkillsCharLabelTextList:
        .addr   SkillsCharLevelText
        .addr   SkillsCharHPText
        .addr   SkillsCharMPText
        calc_size SkillsCharLabelTextList

; text for small skills window

; there's a bug here: if you first select "espers" and then select "rage" for example, the last two
; characters of espers don't get erased and it instead displays "ragers"

.if !LANG_EN
SkillsBlankTitleText:           pos_text SKILLS_BLANK_TITLE
.endif
SkillsMPCostText:               pos_text SKILLS_MP_COST
SkillsLoreTitleText:            pos_text SKILLS_LORE_TITLE
SkillsRageTitleText:            pos_text SKILLS_RAGE_TITLE
SkillsDanceTitleText:           pos_text SKILLS_DANCE_TITLE
SkillsGenjuTitleText:           pos_text SKILLS_GENJU_TITLE
SkillsBlitzTitleText:           pos_text SKILLS_BLITZ_TITLE
SkillsBushidoTitleText:         pos_text SKILLS_BUSHIDO_TITLE

SkillsCharLevelText:            pos_text SKILLS_CHAR_LEVEL
SkillsCharHPText:               pos_text SKILLS_CHAR_HP
SkillsCharMPText:               pos_text SKILLS_CHAR_MP
SkillsCharHPSlashText:          pos_text SKILLS_CHAR_HP_SLASH
SkillsCharMPSlashText:          pos_text SKILLS_CHAR_MP_SLASH

GenjuEquipErrorMsgText:         raw_text GENJU_EQUIP_ERROR_MSG
GenjuLearnPctText:              pos_text GENJU_LEARN_PCT
GenjuLearnRateText:             pos_text GENJU_LEARN_RATE
GenjuAtLevelUpText:
        raw_text GENJU_AT_LEVEL_UP
        calc_size GenjuAtLevelUpText

; ------------------------------------------------------------------------------
