.include "src/text/attack_name.inc"
.include "src/text/battle_cmd_name.inc"
.include "src/text/dance_name.inc"
.include "src/text/genju_name.inc"
.include "src/text/item_name.inc"
.if LANG_EN
.include "src/text/item_symbol_name.inc"
.endif
.include "src/text/magic_name.inc"
.include "src/text/monster_name.inc"
.include "src/text/status_name.inc"

.import BattleFontPal
.import FontWidth
.import SlotGfx, WindowGfx, LargeFontGfx, SmallFontGfx


.enum MENU_INPUT
        NONE                            ; = $00 // 0
        WAIT                            ; = $01 // 1
        NEXT_STATE                      ; = $02 // 2
        MENU_INPUT_3                    ; = $03 // 3  ; unused
        CMD_OPEN                        ; = $04 // 4
        CMD_SELECT                      ; = $05 // 5
        SLOT_OPEN                       ; = $06 // 6
        SLOT_STOP                       ; = $07 // 7
        SLOT_SELECT                     ; = $08 // 8
        ITEM_OPEN                       ; = $09 // 9
        ITEM_SELECT                     ; = $0a // 10
        EQUIP_OPEN                      ; = $0b // 11
        EQUIP_SELECT                    ; = $0c // 12
        MAGIC_OPEN                      ; = $0d // 13
        MAGIC_SELECT                    ; = $0e // 14
        CMD_CLOSE                       ; = $0f // 15
        CHAR_SELECT                     ; = $10 // 16
        MENU_INPUT_17                   ; = $11 // 17  ; unused
        ITEM_CLOSE                      ; = $12 // 18
        EQUIP_CLOSE                     ; = $13 // 19
        MAGIC_CLOSE                     ; = $14 // 20
        SUMMON_CLOSE                    ; = $15 // 21
        SUMMON_SELECT                   ; = $16 // 22
        SCROLL_DOWN                     ; = $17 // 23
        SCROLL_UP                       ; = $18 // 24
        LORE_OPEN                       ; = $19 // 25
        LORE_CLOSE                      ; = $1a // 26
        LORE_SELECT                     ; = $1b // 27
        RAGE_OPEN                       ; = $1c // 28
        RAGE_CLOSE                      ; = $1d // 29
        RAGE_SELECT                     ; = $1e // 30
        DANCE_OPEN                      ; = $1f // 31
        DANCE_CLOSE                     ; = $20 // 32
        DANCE_SELECT                    ; = $21 // 33
        ROW_OPEN                        ; = $22 // 34
        ROW_CLOSE                       ; = $23 // 35
        ROW_SELECT                      ; = $24 // 36
        DEF_OPEN                        ; = $25 // 37
        DEF_CLOSE                       ; = $26 // 38
        DEF_SELECT                      ; = $27 // 39
        MAGITEK_OPEN                    ; = $28 // 40
        MAGITEK_CLOSE                   ; = $29 // 41
        MAGITEK_SELECT                  ; = $2a // 42
        THROW_OPEN                      ; = $2b // 43
        THROW_CLOSE                     ; = $2c // 44
        THROW_SELECT                    ; = $2d // 45
        TOOLS_OPEN                      ; = $2e // 46
        TOOLS_CLOSE                     ; = $2f // 47
        TOOLS_SELECT                    ; = $30 // 48
        ITEM_REOPEN                     ; = $31 // 49
        SLOT_INIT_HDMA                  ; = $32 // 50
        SLOT_CLOSE                      ; = $33 // 51
        SLOT_RESTORE_HDMA               ; = $34 // 52
        BUSHIDO_OPEN                    ; = $35 // 53
        BUSHIDO_CLOSE                   ; = $36 // 54
        BUSHIDO_SELECT                  ; = $37 // 55
        TARGET_SELECT                   ; = $38 // 56
        SLOT_FADE_IN                    ; = $39 // 57
        SLOT_FADE_OUT                   ; = $3a // 58
        DLG_OPEN                        ; = $3b // 59
        DLG_CLOSE                       ; = $3c // 60
        BLITZ_INPUT                     ; = $3d // 61
        DLG_SCROLL                      ; = $3e // 62
        CHAR_STATUS_OPEN                ; = $3f // 63
        CHAR_STATUS_CLOSE               ; = $40 // 64
        CHAR_STATUS_SELECT              ; = $41 // 65

        COUNT
.endenum

.enum MENU_INPUT_QUEUE
        CMD                             ; $00
        SLOT                            ; $01
        ITEM                            ; $02
        EQUIP                           ; $03
        MAGIC                           ; $04
        CHAR_SELECT                     ; $05
        SUMMON                          ; $06
        LORE                            ; $07
        EQUIP_CLOSE                     ; $08
        RAGE                            ; $09
        DANCE                           ; $0a
        ROW                             ; $0b
        DEF                             ; $0c
        MAGITEK                         ; $0d
        THROW                           ; $0e
        TOOLS                           ; $0f
        BUSHIDO                         ; $10
        DLG                             ; $11
        CHAR_STATUS                     ; $12
.endenum

.enum MENU_WINDOW_STATE
        NONE                            ; = $00 // 0
        WAIT_OPEN                       ; = $01 // 1
        WAIT_CLOSE                      ; = $02 // 2
        CMD_OPEN                        ; = $03 // 3
        SLOT_OPEN                       ; = $04 // 4
        CMD_CLOSE                       ; = $05 // 5
        SLOT_CLOSE                      ; = $06 // 6
        ITEM_OPEN                       ; = $07 // 7
        ITEM_CLOSE                      ; = $08 // 8
        EQUIP_OPEN                      ; = $09 // 9
        EQUIP_CLOSE                     ; = $0a // 10
        MAGIC_OPEN                      ; = $0b // 11
        MAGIC_CLOSE                     ; = $0c // 12
        SUMMON_OPEN                     ; = $0d // 13
        SUMMON_CLOSE                    ; = $0e // 14
        MENU_WINDOW_STATE_15            ; = $0f // 15  ; no effect
        GOTO_NEXT                       ; = $10 // 16
        LORE_OPEN                       ; = $11 // 17
        LORE_CLOSE                      ; = $12 // 18
        RAGE_OPEN                       ; = $13 // 19
        RAGE_CLOSE                      ; = $14 // 20
        DANCE_OPEN                      ; = $15 // 21
        DANCE_CLOSE                     ; = $16 // 22
        ROW_OPEN                        ; = $17 // 23
        ROW_CLOSE                       ; = $18 // 24
        DEF_OPEN                        ; = $19 // 25
        DEF_CLOSE                       ; = $1a // 26
        MAGITEK_OPEN                    ; = $1b // 27
        MAGITEK_CLOSE                   ; = $1c // 28
        THROW_OPEN                      ; = $1d // 29
        THROW_CLOSE                     ; = $1e // 30
        MENU_WINDOW_STATE_31            ; = $1f // 31
        TOOLS_OPEN                      ; = $20 // 32
        TOOLS_CLOSE                     ; = $21 // 33
        CHAR_SELECT                     ; = $22 // 34
        MENU_WINDOW_STATE_35            ; = $23 // 35  ; no effect
        MENU_WINDOW_STATE_36            ; = $24 // 36  ; no effect
        BUSHIDO_OPEN                    ; = $25 // 37
        BUSHIDO_CLOSE                   ; = $26 // 38
        DLG_OPEN                        ; = $27 // 39
        DLG_CLOSE                       ; = $28 // 40
        GET_CMD_SETTING                 ; = $29 // 41
        RESET_CMD_SETTING               ; = $2a // 42
        CHAR_STATUS_OPEN                ; = $2b // 43
        CHAR_STATUS_CLOSE               ; = $2c // 44

        COUNT
.endenum

.enum WINDOW_POS
        NONE                            ; $00
        CMD_OPEN                        ; $01
        SLOT_OPEN                       ; $02
        LIST_OPEN                       ; $03
        MAGIC_OPEN                      ; $04
        EQUIP_OPEN                      ; $05
        LIST_CLOSE                      ; $06
        EQUIP_CLOSE                     ; $07
        SUMMON_OPEN                     ; $08
        SUMMON_CLOSE                    ; $09
        ROW_DEF_OPEN                    ; $0a
        ROW_DEF_OPEN_2                  ; $0b
        ROW_DEF_OPEN_3                  ; $0c
        ROW_DEF_OPEN_4                  ; $0d
        ROW_DEF_CLOSE                   ; $0e
        ROW_DEF_CLOSE_2                 ; $0f
        ROW_DEF_CLOSE_3                 ; $10
        ROW_DEF_CLOSE_4                 ; $11
        BUSHIDO_OPEN                    ; $12
        BUSHIDO_CLOSE                   ; $13
        DLG_OPEN                        ; $14
        DLG_CLOSE_NONE                  ; $15
        DLG_CLOSE_CMD                   ; $16
        ROW_DEF_OPEN_SHORT              ; $17
        ROW_DEF_CLOSE_SHORT             ; $18
        CHAR_STATUS_OPEN                ; $19
        CHAR_STATUS_CLOSE               ; $1a
        CHAR_STATUS_CLOSE_MAGIC         ; $1b
.endenum

.enum WINDOW_BUF
        MONSTER_NAMES
        CHAR_INFO
        CMD_WINDOW
        SLOT
        LIST
        MP_REQD
        EQUIP
        MAGIC
        GENJU
        ROW_DEF
        BUSHIDO
        WIDE_MSG
        NARROW_MSG
        CMD_SHORT
        CONTROL
.endenum

.enum WINDOW_VRAM
        TOP_MENU                        ; = 0
        CMD                             ; = 1
        SLOT                            ; = 2
        LIST                            ; = 3
        MAGIC                           ; = 4
        EQUIP                           ; = 5
        GENJU                           ; = 6
        ROW_DEF                         ; = 7
        BUSHIDO                         ; = 8
.endenum

.enum MENU_TEXT
        MONSTER_NAMES                   ; = $00
        CHAR_NAMES                      ; = $01
        CHAR_CURR_HP                    ; = $02
        CHAR_MAX_HP                     ; = $03
        CMD_WINDOW                      ; = $04
        MENU_TEXT_5                     ; = $05 (unused)
        EQUIP                           ; = $06
        CHAR_MP                         ; = $07
        ROW                             ; = $08
        DEF                             ; = $09
        CHAR1_MP                        ; = $0a
        CHAR2_MP                        ; = $0b
        CHAR3_MP                        ; = $0c
        CHAR4_MP                        ; = $0d
        CHAR1_HP                        ; = $0e
        CHAR2_HP                        ; = $0f
        CHAR3_HP                        ; = $10
        CHAR4_HP                        ; = $11
        CHAR1_ATB                       ; = $12
        CHAR2_ATB                       ; = $13
        CHAR3_ATB                       ; = $14
        CHAR4_ATB                       ; = $15
        CHAR1_MORPH                     ; = $16
        CHAR2_MORPH                     ; = $17
        CHAR3_MORPH                     ; = $18
        CHAR4_MORPH                     ; = $19
        CHAR1_CONDEMNED                 ; = $1a (unused)
        CHAR2_CONDEMNED                 ; = $1b (unused)
        CHAR3_CONDEMNED                 ; = $1c (unused)
        CHAR4_CONDEMNED                 ; = $1d (unused)
        BUSHIDO                         ; = $1e
        CMD_SHORT                       ; = $1f
        CONTROL                         ; = $20
        BLANK_STATUS                    ; = $21
        CHAR_STATUS                     ; = $22

        COUNT
.endenum

.enum MENU_TEXT_SCROLL
        CMD
        ROW_DEF_CLOSE
        LIST
        GENJU
        EQUIP
        ROW_DEF_1
        ROW_DEF_2
        ROW_DEF_3
        ROW_DEF_4
        BUSHIDO
        CHAR_STATUS
.endenum

.enum MENU_TEXT_POS
        MONSTER_NAMES                   = 0
        CHAR_NAMES                      = 1
        CHAR_HP                         = 2
        CHAR_GAUGE                      = 3
        ROW_1                           = 4
        ROW_2                           = 5
        ROW_3                           = 6
        ROW_4                           = 7
        DEF_1                           = 8
        DEF_2                           = 9
        DEF_3                           = 10
        DEF_4                           = 11
        CHAR_HP_BACK                    = 12
        CHAR_GAUGE_BACK                 = 13
        BUSHIDO_GAUGE                   = 14
        ROW_SHORT                       = 15
        DEF_SHORT                       = 16
        BLANK_STATUS                    = 17
        MENU_TEXT_POS_18                = 18
.endenum

; ------------------------------------------------------------------------------

.if LANG_EN
; text tiles to load for bg1 graphics "0123456789MHP/NedMP  "
BG1TextTiles:
@3fcb:  .byte   $b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$8c,$87,$8f,$c0,$8d,$9e
        .byte   $9d,$8c,$8f,$ff,$ff
        calc_size BG1TextTiles
.endif

; ------------------------------------------------------------------------------

; pointers to menu window graphics
WindowGfxPtrs:
@3fe0:  .repeat 8, i
        .faraddr WindowGfx + i * $0380
        .endrep

; ------------------------------------------------------------------------------

; pointers to menu window palettes (in RAM)
WindowPalPtrs:
@3ff8:  .faraddr $1d57,$1d65,$1d73,$1d81,$1d8f,$1d9d,$1dab,$1db9

; ------------------------------------------------------------------------------

; [ get pointer to menu window graphics ]

;  +X: pointer to menu window graphics (out)
; $12: menu window graphics bank (out)

GetWindowGfxPtr:
@4010:  lda     near w7e2f34       ; menu window graphics index
        and     #$07
        sta     near w7e2f34
        asl
        clc
        adc     near w7e2f34
        tax
        lda     f:WindowGfxPtrs+2,x
        sta     $12
        longa
        lda     f:WindowGfxPtrs,x
        tax
        shorta0
        ldy     #$0380      ; size = $0380
        sty     $10
        rts

; ------------------------------------------------------------------------------

; [ copy message window graphics to vram ]

; for messages at the top of the screen only, not used for menu windows

TfrMsgWindowGfx:
@4034:  jsr     GetWindowGfxPtr
        ldy     #$0a00      ; destination address = $0a00
        lda     $12
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ load menu window and text graphics ]

LoadMenuGfx:

; window graphics
@403f:  jsr     GetWindowGfxPtr
        ldy     $10
        sty     $36                     ; size = $0380
        lda     $12
        ldy     #$4200                  ; destination address = $4200
        jsr     TfrVRAM

; slot graphics
        ldx     #$0800
        stx     $36                     ; size = $0800
        ldx     #near SlotGfx
        ldy     #$4400                  ; destination address = $4400
        lda     #^SlotGfx
        jsr     TfrVRAM

; small font graphics (bg3)
        ldx     #$1000
        stx     $36                     ; size = $1000
        ldx     #near SmallFontGfx
        ldy     #$5800                  ; destination address = $5800
        lda     #^SmallFontGfx
        jsr     TfrVRAM

; menu window palette
        lda     near w7e2f34                   ; menu window graphics index
        and     #$07
        sta     near w7e2f34
        asl
        clc
        adc     near w7e2f34
        tax
        lda     f:WindowPalPtrs+2,x
        sta     $38
        longa
        lda     f:WindowPalPtrs,x
        sta     $36
        clr_axy
        lda     #$0008
        sta     $2c
        jsr     _c141e4
@4095:  lda     [$36],y
        jsr     _c1417e
        sta     near w7e7e00::_2::Color1,x
        iny2
        inx2
        cpx     #$000e
        bne     @4095

;
        clr_ax
@40a8:  lda     f:BattleFontPal,x
        sta     near w7e7e00::_0::Color0,x
        lda     f:BattleFontPal+$10,x
        sta     near w7e7e00::_0::Color8,x
        inx2
        cpx     #$0010
        bne     @40a8

; font color
        lda     $1d55
        sta     near w7e7e00::Color3

; bg1 text graphics
        shorta0
        ldy     #$4080
        clr_ax
@40cb:  lda     f:BG1TextTiles,x
        phx
        longa
        asl4
        clc
        adc     #near SmallFontGfx
        tax
        lda     #$0010
        sta     $36
        shorta0
        lda     #^SmallFontGfx
        jsr     TfrVRAM
        plx
        longa
        tya
        clc
        adc     #$0010
        tay
        shorta0
        inx
        cpx     #sizeof_BG1TextTiles
        bne     @40cb

; battle font palette
        jsr     LoadBattleFontPal
        rts

; ------------------------------------------------------------------------------

; [ load slot menu palette ]

; replaced by slot icon palette when the slot menu is open

LoadBattleFontPal:
@40fe:  clr_ax
@4100:  lda     f:BattleFontPal+$28,x
        sta     near w7e7e00::_1::Color4,x
        inx
        cpx     #$0018
        bne     @4100
        rts

; ------------------------------------------------------------------------------

; [ load slot gradient color palette ]

; unused

@410e:  clr_ax
@4110:  lda     f:SlotGradientPal,x
        sta     near w7e7e00::_2::Color8,x
        inx
        cpx     #$0010
        bne     @4110
        rts

; ------------------------------------------------------------------------------

; [ clear slot gradient palette ]

ClearSlotGradientPal:
@411e:  clr_ax
@4120:  sta     near w7e7e00::_2::Color8,x
        inx
        cpx     #$0010
        bne     @4120
        rts

; ------------------------------------------------------------------------------

; [ load slot icon color palette ]

; unused

@412a:  clr_ax
        longa
@412e:  lda     f:SlotIconPal,x
        not_a
        sta     near w7e7e00::_1::Color4,x
        inx2
        cpx     #$0018
        bne     @412e
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

; unused

@4143:  clr_a
@4144:  stz     near w7e7e00::_1::Color4,x
        inx
        cpx     #$0018
        bne     @4144
        rts

; ------------------------------------------------------------------------------

; slot gradient color palette (8 colors)
SlotGradientPal:
@414e:  .word   $739c,$6318,$5294,$4210,$318c,$2108,$1084,$0000

; unused (4 colors)
        .word   $0000,$7fe0,$7fe0,$7fe0

; slot icon palette (12 colors)
SlotIconPal:
@4166:  .word   $6f18,$4a10,$2928,$037f,$0254,$018e,$001f,$0016
        .word   $7cc1,$6ce3,$7fff,$0000

.if !LANG_EN
; text tiles to load for bg1 graphics "0123456789MHP/うひMP "
BG1TextTiles:
        .byte   $53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$ce,$77,$c3
        .byte   $89,$63,$2c,$2f,$ff
        calc_size BG1TextTiles
.endif
; ------------------------------------------------------------------------------

; [  ]

_c1417e:
one_upcolor_set:
        .a16
@417e:  sta     $32
        and     #$001f
        clc
        adc     $2c
        sta     $34
        and     #$7fe0
        bne     @4198
        lda     $32
        and     #$7fe0
        ora     $34
        sta     $32
        bra     @419f
@4198:  lda     $32
        ora     #$001f
        sta     $32
@419f:  lda     $32
        and     #$03e0
        clc
        adc     $2e
        sta     $34
        and     #$7c1f
        bne     @41b9
        lda     $32
        and     #$7c1f
        ora     $34
        sta     $32
        bra     @41c0
@41b9:  lda     $32
        ora     #$03e0
        sta     $32
@41c0:  lda     $32
        and     #$7c00
        clc
        adc     $30
        sta     $34
        and     #$83ff
        bne     @41da
        lda     $32
        and     #$03ff
        ora     $34
        sta     $32
        bra     @41e1
@41da:  lda     $32
        ora     #$7c00
        sta     $32
@41e1:  lda     $32
        rts
        .a8

; ------------------------------------------------------------------------------

; [  ]

_c141e4:
nmi_onecolor_init:
        .a16
@41e4:  lda     $2c
        asl5
        and     #$03e0
        sta     $2e
        asl5
        and     #$7c00
        sta     $30
        lda     $2c
        and     #$001f
        sta     $2c
        rts
        .a8

; ------------------------------------------------------------------------------

; [  ]

_c14202:
one_downcolor_set:
@4202:  .a16
        sta     $32
        and     #$001f
        sec
        sbc     $2c
        sta     $34
        and     #$7fe0
        bne     @421c
        lda     $32
        and     #$7fe0
        ora     $34
        sta     $32
        bra     @4223
@421c:  lda     $32
        and     #$7fe0
        sta     $32
@4223:  lda     $32
        and     #$03e0
        sec
        sbc     $2e
        sta     $34
        and     #$7c1f
        bne     @423d
        lda     $32
        and     #$7c1f
        ora     $34
        sta     $32
        bra     @4244
@423d:  lda     $32
        and     #$7c1f
        sta     $32
@4244:  lda     $32
        and     #$7c00
        sec
        sbc     $30
        sta     $34
        and     #$83ff
        bne     @425e
        lda     $32
        and     #$03ff
        ora     $34
        sta     $32
        bra     @4265
@425e:  lda     $32
        and     #$03ff
        sta     $32
@4265:  lda     $32
        rts
        .a8

; ------------------------------------------------------------------------------

; [ update menu state $39: fade in slot palettes ]

        array_label MENU_INPUT, MENU_INPUT::SLOT_FADE_IN
@4268:  lda     near w7e7b83
        bpl     @4272
        lda     #$1c
        sta     near w7e7b83
@4272:  jsr     UpdateSlotMenuPal
        lda     near w7e7b83
        sec
        sbc     #$04
        sta     near w7e7b83
        cmp     #$fc
        jeq     GoToNextMenuState
        rts

; ------------------------------------------------------------------------------

; [ update slot menu palettes ]

; $2c: amount to subtract from each color component for fade in/out

UpdateSlotMenuPal:
@4286:  clr_ax
        longa
        lda     near w7e7b83
        sta     $2c
        jsr     _c141e4

; fade in slot icon palette
@4292:  lda     f:SlotIconPal,x
        not_a
        jsr     _c14202
        sta     near w7e7e00::_1::Color4,x
        inx2
        cpx     #$0018
        bne     @4292
        clr_ax
        lda     near w7e7b83
        sta     $2c
        jsr     _c141e4

; fade in slot gradient palette
@42b0:  lda     f:SlotGradientPal,x
        not_a
        jsr     _c14202
        sta     near w7e7e00::_2::Color8,x
        inx2
        cpx     #$0010
        bne     @42b0
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update menu state $3a: fade out slot palettes ]

        array_label MENU_INPUT, MENU_INPUT::SLOT_FADE_OUT
@42c8:  lda     near w7e7b83
        bpl     @42d0
        stz     near w7e7b83
@42d0:  jsr     UpdateSlotMenuPal
        lda     near w7e7b83
        clc
        adc     #$04
        sta     near w7e7b83
        cmp     #$20
        jeq     GoToNextMenuState
        rts

; ------------------------------------------------------------------------------

; [ clear dialogue text graphics in vram ]

InitDlgTextGfx:
@42e4:  jsr     ClearLargeTextGfxBuf
        ldx     #$5800
        stx     near wLargeTextGfxVRAMAddr
        jsr     TfrLargeTextGfx
        ldx     #$5a00
        stx     near wLargeTextGfxVRAMAddr
        jsr     TfrLargeTextGfx
        ldx     #$5c00
        stx     near wLargeTextGfxVRAMAddr
        jsr     TfrLargeTextGfx
        ldx     #$5e00
        stx     near wLargeTextGfxVRAMAddr
        jsr     TfrLargeTextGfx
        jsr     InitDlgTextTiles
        jsr     LoadDlgFontPal
        rts

; ------------------------------------------------------------------------------

; [ open battle dialogue window ]

OpenDlgWindow:
@4312:  ldx     #$ffff                  ; clear battle menu order
        stx     near wMenuQueue
        stx     near wMenuQueue + 2
        lda     near wMenuIsOpen               ; wait for menus to close
        beq     @4325
        jsr     WaitFrame
        bra     @4312
@4325:  lda     near w7e64d5
        bne     @434a
        jsr     ClearDlgTextTiles
        inc     near w7e64d5
        lda     #MENU_INPUT::DLG_OPEN
        sta     near wMenuInput+1
        lda     #MENU_INPUT::WAIT
        sta     near wMenuInput
@433a:  lda     near wMenuWindowState
        ora     near wMenuInput
        beq     @4347
        jsr     WaitFrame
        bra     @433a
@4347:  jsr     InitDlgTextGfx
@434a:  rts

; ------------------------------------------------------------------------------

; [ clear dialogue text tilemap ]

.proc ClearDlgTextTiles
        jsr     ClearLargeTextTileBuf
        ldy     #$7c00
        jsr     TfrDlgTextTiles
        ldy     #$7c40
        jsr     TfrDlgTextTiles
        ldy     #$7c80
        jsr     TfrDlgTextTiles
        ldy     #$7cc0
        jsr     TfrDlgTextTiles
        ldy     #$7d00
        jsr     TfrDlgTextTiles
        rts
.endproc  ; ClearDlgTextTiles

; ------------------------------------------------------------------------------

; [ transfer dialogue text tiles to vram ]

.proc InitDlgTextTiles
        jsr     ClearLargeTextTileBuf
        ldx     #$3100
        ldy     #$7c00
        jsr     InitDlgTextTileRow
        ldx     #$3140
        ldy     #$7c40
        jsr     InitDlgTextTileRow
        ldx     #$3180
        ldy     #$7c80
        jsr     InitDlgTextTileRow
        ldx     #$31c0
        ldy     #$7cc0
        jsr     InitDlgTextTileRow
        rts
.endproc  ; InitDlgTextTiles

; ------------------------------------------------------------------------------

; [ draw transfer dialogue text tiles to vram ]

.proc InitDlgTextTileRow
        longa
        txa
        ldx     zZero
:       sta     near wLargeTextTileBuf + $06,x
        inc
        sta     near wLargeTextTileBuf + $46,x
        inc
        inx2
        cpx     #52
        bne     :-
        shorta0

::TfrDlgTextTiles:
        ldx     #$0080
        stx     $10
        ldx     #near wLargeTextTileBuf
        lda     #^wLargeTextTileBuf
        jmp     WaitTfrVRAM
.endproc  ; InitDlgTextTileRow

; ------------------------------------------------------------------------------

; [ reload small font graphics (after dialogue) ]

ReloadSmallFontGfx:
        jsr     ClearDlgTextTiles
        ldx     #$1000
        stx     $10
        ldx     #near SmallFontGfx
        ldy     #$5800
        lda     #^SmallFontGfx
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [  ]

_c143cc:
@43cc:  lda     near w7e64d5
        beq     @43e1
        jsr     ReloadSmallFontGfx
        lda     #MENU_INPUT::DLG_CLOSE
        sta     near wMenuInput+1
        lda     #MENU_INPUT::NEXT_STATE
        sta     near wMenuInput
        stz     near w7e64d5
@43e1:  rts

; ------------------------------------------------------------------------------

; [ update menu window $22: cycle characters after closing command window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::CHAR_SELECT
@43e2:  ldx     near w7e62ca
        lda     near w7e7bcc
        bne     @43ee                   ; next/previous character with X/Y
        lda     #$ff
        bra     @4426

; go to previous character in menu order (Y button)
@43ee:  cmp     #$02
        bne     @4424
        clr_ax
@43f4:  lda     near wMenuQueue,x
        cmp     #$ff
        beq     @43fe
        inc     near wMenuQueue,x
@43fe:  inx
        cpx     #4
        bne     @43f4
        clr_ax
        stz     $10
        stx     $12
@440a:  lda     near wMenuQueue,x
        cmp     #$ff
        beq     @4419
        cmp     $10
        bcc     @4419
        sta     $10
        stx     $12
@4419:  inx
        cpx     #4
        bne     @440a
        ldx     $12
        clr_a
        bra     @4426

; put current character at back of queue (go to next character in menu order)
@4424:  lda     #4
@4426:  sta     $14
        lda     near wMenuQueue,x
        cmp     #$ff
        beq     @4434
        lda     $14
        sta     near wMenuQueue,x
@4434:  stz     near w7e2f41                   ; start battle time
        stz     near wMenuIsOpen
        stz     near w7e7bcc                 ; done switching characters
        jsr     GoToNextWindowState
        jsl     UpdateMonsterNames
        rts

; ------------------------------------------------------------------------------

; [ update inventory with obtained items ]

_c14445:
set_item_add_data:
@4445:  lda     near w7e64db
        and     #$0f
        sta     $10
        asl2
        clc
        adc     $10
        tay
        sty     $12
        lda     near w7e602d,y     ; item index
        cmp     #ITEM::EMPTY
        beq     @44a1       ; return if not valid
        ldx     #$0000
@445e:  cmp     near wItemList::ItemID,x     ; find the item in the inventory
        beq     @4484
        inx5
        cpx     #$0500
        bne     @445e

; new item
        jsr     CheckInventoryFull
        bcs     @44a1
        lda     #wItemList::ITEM_SIZE
        sta     $10
@4476:  lda     near w7e602d,y     ; copy obtained item to inventory
        sta     near wItemList,x
        iny
        inx
        dec     $10
        bne     @4476
        bra     @4494

; existing item
@4484:  lda     near w7e602d+3,y     ; item quantity
        clc
        adc     near wItemList::Qty,x     ; add quantity to existing item slot (max 99)
        cmp     #MAX_ITEM_QTY + 1
        bcc     @4491
        lda     #MAX_ITEM_QTY
@4491:  sta     near wItemList::Qty,x
@4494:  ldy     $12         ; pointer to obtained items list
        lda     #ITEM::EMPTY
        sta     near w7e602d,y     ; clear obtained item
        inc     near w7e64db       ; increment number of items added to inventory
        jmp     @4445       ; next item
@44a1:  rts

; ------------------------------------------------------------------------------

; [  ]

OpenMenu:
_c144a2:
window_open:
@44a2:  lda     #1                      ; enable character hp/mp text update
        sta     near w7e7b98
        jsr     _c14445                 ; update inventory with obtained items
        jsr     TfrTopMenuTiles
        lda     #MENU_INPUT::CMD_OPEN
        sta     near wMenuInput+1
        lda     #MENU_INPUT::WAIT
        sta     near wMenuInput
        inc     near wEnableUpdateMenuWindowTiles                 ; enable menu window update
        inc     near wMenuIsOpen             ; indicate that menu is open
        rts

; ------------------------------------------------------------------------------

; [ update hp/gauge graphics ]

UpdateCharText:
@44be:  lda     near w7e7b98       ;
        ora     near w7e7b9c
        bne     @44d7
        lda     near w7e7b99       ;
        asl
        tax
        jsr     (near DrawCharHPMPTbl,x)
        lda     near w7e7b99
        inc
        and     #$07
        sta     near w7e7b99
@44d7:  lda     near w7e7b9a       ;
        inc
        and     #%11
        sta     near w7e7b9a
        asl
        tax
        jmp     (near DrawCharGaugeTbl,x)

; ------------------------------------------------------------------------------

.enum DRAW_CHAR_GAUGE
        COUNT = 4
.endenum

; jump table for gauge updates (each character)
DrawCharGaugeTbl:
        ptr_tbl DRAW_CHAR_GAUGE

; ------------------------------------------------------------------------------

.enum DRAW_CHAR_HP_MP
        COUNT = 8
.endenum

; jump table for hp/mp updates
DrawCharHPMPTbl:
        ptr_tbl DRAW_CHAR_HP_MP

; ------------------------------------------------------------------------------

; [ draw character mp ]

        array_label DRAW_CHAR_HP_MP, 7
@44fd:  jsr     DrawCharMP

        array_label DRAW_CHAR_HP_MP, 1
        array_label DRAW_CHAR_HP_MP, 3
        array_label DRAW_CHAR_HP_MP, 5
@4500:  inc     near w7e7b9c
        rts

; ------------------------------------------------------------------------------

; [ update menu window ]

; called every frame after NMI

UpdateMenuWindow:
@4504:  lda     near wEnableUpdateMenuWindowTiles       ; branch if battle menu update is disabled
        bne     @4515
        ldx     zZero
        stx     $10
        lda     near wMenuWindowState       ; update menu window
        asl
        tax
        jmp     (near UpdateMenuWindowTbl,x)
@4515:  rts

; ------------------------------------------------------------------------------

; [ update menu window: no effect ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::NONE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MENU_WINDOW_STATE_15
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MENU_WINDOW_STATE_35
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MENU_WINDOW_STATE_36
@4516:  rts

; ------------------------------------------------------------------------------

; update menu window jump table
UpdateMenuWindowTbl:
        ptr_tbl MENU_WINDOW_STATE

; ------------------------------------------------------------------------------

; [ update menu window $2c: close character status window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::CHAR_STATUS_CLOSE
@4571:  inc     $10
        lda     #WINDOW_POS::CHAR_STATUS_CLOSE
        clc
        adc     near w7eecba                   ; status window type (item or magic)
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::CHAR_STATUS
        jsr     LoadMenuTextScrollData
        jsr     _c14f8c                 ; close menu window
        jmp     _c148f2

; ------------------------------------------------------------------------------

; [ find first status ailment for status window ]

GetFirstStatus:
@4587:  longa
        lda     near wCharGfxDataBuf::ActiveStatus12,x
        beq     @459f
        xba
        ldx     #0
@4592:  asl
        bcs     @459b
        inx
        cpx     #16
        bne     @4592
@459b:  txa
        shorta
        rts
@459f:  lda     near wCharGfxDataBuf::ActiveStatus34,x
        ldx     #16
        xba
@45a6:  asl
        bcs     @45af
        inx
        cpx     #31
        bne     @45a6
@45af:  txa
        shorta
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

; [ check if character menu slot is valid (for status menu) ]

CheckStatusMenuCharValid:
@45b3:  tax
        lda     near w7e64d6,x
        bmi     @45c1
        asl5
        tax
        sec
        rts
@45c1:  clc
        rts

.endif

; ------------------------------------------------------------------------------

; [ draw status name for status window (character target select) ]

DrawStatusMenuText:
@45c3:  lda     #MENU_TEXT::BLANK_STATUS
        jsr     LoadMenuText

.if LANG_EN

; character slot 1
        clr_a
        jsr     CheckStatusMenuCharValid
        bcc     @45fb
        jsr     GetFirstStatus
        sta     near w7e56d5+1

; character slot 2
        lda     #$01
        jsr     CheckStatusMenuCharValid
        bcc     @45fb
        jsr     GetFirstStatus
        sta     near w7e56d5 + 4

; character slot 3
        lda     #$02
        jsr     CheckStatusMenuCharValid
        bcc     @45fb
        jsr     GetFirstStatus
        sta     near w7e56d5 + 7

; character slot 4
        lda     #$03
        jsr     CheckStatusMenuCharValid
        bcc     @45fb
        jsr     GetFirstStatus
        sta     near w7e56d5+10

.else

; character slot 1
        clr_ax
        jsr     GetFirstStatus
        sta     near w7e56d5+1

; character slot 2
        ldx     #$0020
        jsr     GetFirstStatus
        sta     near w7e56d5 + 4

; character slot 3
        ldx     #$0040
        jsr     GetFirstStatus
        sta     near w7e56d5 + 7

; character slot 4
        ldx     #$0060
        jsr     GetFirstStatus
        sta     near w7e56d5+10

.endif

@45fb:  jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ update menu window $2b: open character status window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::CHAR_STATUS_OPEN
@45fe:  lda     #MENU_TEXT::CHAR_STATUS
        jsr     LoadMenuText
        jsr     DrawMenuText
        jsr     DrawStatusMenuText
        lda     #MENU_TEXT_POS::BLANK_STATUS
        jsr     CopyMenuTextToScreenBuf
        inc     ; #MENU_TEXT_POS::MENU_TEXT_POS_18
        jsr     CopyMenuTextToScreenBuf
        lda     #MENU_TEXT_POS::CHAR_HP
        jsr     CopyMenuTextToScreenBuf
        inc     ; #MENU_TEXT_POS::CHAR_GAUGE
        jsr     CopyMenuTextToScreenBuf
        lda     #2
        ldy     #near w7e8d13 + 64
        jsr     _c14721       ; update battle menu tile data (-> $7a00 vram)
        lda     #$01
        sta     near w7e7b85
        stz     $10
        lda     #WINDOW_POS::CHAR_STATUS_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::CHAR_STATUS
        jsr     LoadMenuTextScrollData
        jmp     _c14f77

; ------------------------------------------------------------------------------

; [ update menu window $03: open command window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::CMD_OPEN
@4637:  ldx     near w7e62ca
        lda     near w7e62cc,x
        bne     @4648                   ; branch if controlling a monster
        lda     near w7e2f2e
        beq     @4648
        lda     #$16
        bra     @464a
@4648:  lda     #WINDOW_POS::CMD_OPEN
@464a:  jsr     LoadWindowPos
        clr_a   ; #MENU_TEXT_SCROLL::CMD
        jsr     LoadMenuTextScrollData
        jsr     _c147ac
        jsr     _c14f77
        inc     near wEnableUpdateMenuWindowTiles
        lda     #MENU_WINDOW_STATE::WAIT_OPEN
        sta     near wMenuWindowState
        sta     near w7e7b85
        inc     near w7e7bdd
        inc     near w7e7bd1
        inc     z93
        rts

; ------------------------------------------------------------------------------

; [ update menu window $05: close command window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::CMD_CLOSE
@466b:  inc     $10
        clr_a   ; #WINDOW_POS::NONE
        jsr     LoadWindowPos
        jsr     GetCharMenuOrder
        lda     #$21                    ; white text
        jsr     _c14780
        clr_a   ; #MENU_TEXT_SCROLL::CMD
        jsr     LoadMenuTextScrollData
        inc     near w7e7bee
        lda     #MENU_WINDOW_STATE::WAIT_CLOSE
        sta     near wMenuWindowState
        stz     near w7e7b85
        inc     near w7e7bdd
        inc     near w7e7bd1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1468f:
window_tfr_buf_clr:
@468f:  ldy     #$01ee

_c14692:
window_tfr_buf_clr2:
@4692:  longa
        ldx     zZero
        tya
@4697:  sta     near w7e5855,x
        inx2
        cpx     #$0280
        bne     @4697
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c146a5:
scr_tmp_line_set:
@46a5:  lda     #$04
        sta     near w7e7afd
        shorti
        longa
        phd
        lda     #$0100      ; nonzero dp
        pha
        pld
        ldx     #0
@46b6:  lda     near wBufferTextScrollData::Vert,x
        sta     <$0102,x
        sta     near wListTextScrollData::_8::Vert,x
        inx4
        cpx     #$c0
        bne     @46b6
@46c6:  lda     near wBufferTextScrollData::Vert,x
        sta     <$0102,x
        inx4
        cpx     #$f0
        bne     @46c6
        pld
        shorta0
        longi
        rts

; ------------------------------------------------------------------------------

; [ copy menu text ]

; +$10: source address
; +$12: destination address
; +$14: width (bytes per line)
; +$16: number of lines

CopyMenuTextBuf:
@46da:  shorti
        longa
        ldx     $16
@46e0:  ldy     zZero
@46e2:  lda     ($10),y
        sta     ($12),y
        iny2
        cpy     $14
        bne     @46e2
        lda     $10
        clc
        adc     $14
        sta     $10
        lda     $12
        clc
        adc     #$0040
        sta     $12
        dex
        bne     @46e0
        clr_a
        longi
        shorta
        rts

; ------------------------------------------------------------------------------

; [ update menu text ]

; copies decoded menu text from a tile buffer to one of the screen tilemap
; buffers that can be transferred to vram

; A: MENU_TEXT_BUF enum value

CopyMenuTextToScreenBuf:
@4704:  pha
        asl3
        tax
        ldy     zZero
@470b:  lda     f:MenuTextPosTbl,x
        sta     $0010,y
        inx
        iny
        cpy     #8
        bne     @470b
        jsr     CopyMenuTextBuf
        pla
        rts

; ------------------------------------------------------------------------------

; [ transfer battle menu text tiles to vram ]

;  A: vram destination
;       0: $7800 (top menu text)
;       1: $7900 (command window text)
;       2: $7a00 (swdtech, row, def, char status)
;       3: $7c00 (text list, unused ???)
; +Y: source address

_c1471e:
tfr_poi_set:
@471e:  ldy     #near w7e5855      ; tile data pointer

_c14721:
tfr_poi_set2:
@4721:  phy
        pha
@4723:  lda     near wEnableUpdateMenuWindowTiles
        beq     @472d       ; branch if battle menu update is not pending
        jsr     WaitVblank
        bra     @4723
@472d:  pla
        asl2
        tax
        longa
        lda     f:_c14749,x   ; size ??? (unused)
        sta     near w7e7bbc
        lda     f:_c14749+2,x   ; bg2 tile data destination (vram)
        sta     near w7e7bbe
        ply
        sty     near w7e7bc0       ; source address
        shorta0
        rts

; ------------------------------------------------------------------------------

tfr_poi_tbl:
_c14749:
@4749:  .word   $0200,$7800
        .word   $0200,$7900
        .word   $0200,$7a00
        .word   $0280,$7c00

; ------------------------------------------------------------------------------

; [ transfer top menu tiles to vram ]

TfrTopMenuTiles:
        clr_a   ; #MENU_TEXT_POS::MONSTER_NAMES
        jsr     CopyMenuTextToScreenBuf
        inc     ; #MENU_TEXT_POS::CHAR_NAMES
        jsr     CopyMenuTextToScreenBuf
        inc     ; #MENU_TEXT_POS::CHAR_HP
        jsr     CopyMenuTextToScreenBuf
        inc     ; #MENU_TEXT_POS::CHAR_GAUGE
        jsr     CopyMenuTextToScreenBuf
        clr_a
        jmp     _c1471e       ; update battle menu tile data (-> $7800 vram)

; ------------------------------------------------------------------------------

; offsets of character name buffers (28 bytes each)
_c1476d:
        .repeat 4, i
        .byte   28 * i
        .endrep

; ------------------------------------------------------------------------------

; [  ]

; unused

@4771:  clr_ax
        lda     #$21
@4775:  sta     near w7e5b95+1,x
        inx2
        cpx     #w7e5b95::SIZE
        bne     @4775
        rts

; ------------------------------------------------------------------------------

; [ set text color for selected character name ]

; A: tile flags for selected character name
; X: selected character slot (use GetCharMenuOrder)

_c14780:
player_name_buf_attr_set:
@4780:  pha
        phx
        clr_ax

; first, use white text for all 4 characters
@4784:  lda     #$21                    ; white text
        jsr     @4791
        inx
        cpx     #4
        bne     @4784

; then, use the text color provided for the selected character
        plx
        pla
@4791:  phx
        pha
        txa
        and     #$03
        tax
        lda     f:_c1476d,x
        tax
        lda     #14
        sta     $12
        pla
@47a1:  sta     near w7e5b95+1,x
        inx2
        dec     $12
        bne     @47a1
        plx
        rts

; ------------------------------------------------------------------------------

; [ draw character battle commands ]

_c147ac:
command_window_data_set:
@47ac:  ldx     near w7e62ca       ; active character
        lda     near w7e62cc,x
        bne     @47ee       ; branch if controlling a monster
        lda     near w7e2f2e
        beq     @4830       ; branch if window mode

; short mode
        lda     #MENU_TEXT::CMD_SHORT
        jsr     LoadMenuText
        ldx     near w7e62ca
        lda     f:CharCmdPtrs,x
        tax
        clr_ay
@47c8:  lda     near wCmdList::CmdID,x
        sta     near w7e56d5 + 5,y
        lda     near wCmdList::Disabled,x
        jsr     GetTextColor
        ora     near w7e56d5 + 3,y
        sta     near w7e56d5 + 3,y
        inx3
        tya
        clc
        adc     #$09
        tay
        cmp     #$24
        bne     @47c8
        jsr     DrawMenuText
        lda     #1
        jmp     _c1471e       ; update battle menu tile data (-> $7900 vram)

; controlling a monster
@47ee:  jsr     GetCharMenuOrder
        lda     #$29                    ; yellow text
        jsr     _c14780
        lda     #MENU_TEXT_POS::CHAR_NAMES
        jsr     CopyMenuTextToScreenBuf
        lda     #MENU_TEXT::CONTROL
        jsr     LoadMenuText
        ldx     near w7e62ca
        lda     f:CharCmdPtrs,x
        tax
        clr_ay
@480a:  lda     near wControlCmdList::CmdID,x
.if LANG_EN
        sta     near w7e56d5 + 4,y
        lda     near wControlCmdList::Disabled,x
        jsr     GetTextColor
        ora     near w7e56d5 + 2,y
        sta     near w7e56d5 + 2,y
        inx3
        tya
        clc
        adc     #$08
        tay
        cmp     #$20
.else
        sta     near w7e56d5 + 5,y
        lda     near wControlCmdList::Disabled,x
        jsr     GetTextColor
        ora     near w7e56d5 + 3,y
        sta     near w7e56d5 + 3,y
        inx3
        tya
        clc
        adc     #$09
        tay
        cmp     #$24
.endif
        bne     @480a
        jsr     DrawMenuText
        lda     #1
        jmp     _c1471e       ; update battle menu tile data (-> $7900 vram)

; window mode
@4830:  jsr     GetCharMenuOrder
        lda     #$29                    ; yellow text
        jsr     _c14780
        lda     #MENU_TEXT_POS::CHAR_NAMES
        jsr     CopyMenuTextToScreenBuf
        lda     #MENU_TEXT::CMD_WINDOW
        jsr     LoadMenuText
        ldx     near w7e62ca
        lda     f:CharCmdPtrs,x
        tax
        clr_ay
@484c:  lda     near wCmdList::CmdID,x     ; command
        sta     near w7e56d5 + 5,y
        lda     near wCmdList::Disabled,x
        jsr     GetTextColor
        ora     near w7e56d5 + 3,y
        sta     near w7e56d5 + 3,y
        inx3
        tya
        clc
        adc     #$08
        tay
        cmp     #$20
        bne     @484c
        jsr     DrawMenuText
        lda     #1
        jmp     _c1471e       ; update battle menu tile data (-> $7900 vram)

; ------------------------------------------------------------------------------

; [ init bg tile data for swdtech numerals ]

_c24872:
ken_window_data_set:
@4872:  ldx     near w7e62ca       ; active character
        lda     #7
        sec
        sbc     near w7e2020       ; number of known swdtechs
        tax
        clr_ay
@487e:  lda     f:BushidoTextPalTbl,x
        sta     near w7e5dbd + $1d,y
        inx
        iny2
        cpy     #$0010
        bne     @487e
        lda     #MENU_TEXT_POS::CHAR_HP_BACK
        jsr     CopyMenuTextToScreenBuf
        lda     #MENU_TEXT_POS::CHAR_GAUGE_BACK
        jsr     CopyMenuTextToScreenBuf
        lda     #MENU_TEXT_POS::BUSHIDO_GAUGE
        jsr     CopyMenuTextToScreenBuf
        lda     #2
        ldy     #near w7e8d13 + 64
        jmp     _c14721       ; update battle menu tile data (-> $7a00 vram)

; ------------------------------------------------------------------------------

; [ draw "def" text ]

_c148a4:
def_window_data_set:
@48a4:  lda     #MENU_TEXT_POS::CHAR_HP_BACK
        jsr     CopyMenuTextToScreenBuf
        lda     #MENU_TEXT_POS::CHAR_GAUGE_BACK
        jsr     CopyMenuTextToScreenBuf
        lda     near w7e2f2e
        beq     @48b7

; short mode
        lda     #MENU_TEXT_POS::DEF_SHORT
        bra     @48c0

; window mode
@48b7:  ldx     near w7e62ca
        lda     near w7e890f,x
        clc
        adc     #MENU_TEXT_POS::DEF_1
@48c0:  jsr     CopyMenuTextToScreenBuf
        lda     #2
        ldy     #near w7e8d13 + 64
        jmp     _c14721       ; update battle menu tile data (-> $7a00 vram)

; ------------------------------------------------------------------------------

; [ draw "row" text ]

_c148cb:
@48cb:  lda     #MENU_TEXT_POS::CHAR_HP_BACK
        jsr     CopyMenuTextToScreenBuf
        lda     #MENU_TEXT_POS::CHAR_GAUGE_BACK
        jsr     CopyMenuTextToScreenBuf
        lda     near w7e2f2e
        beq     @48de
        lda     #MENU_TEXT_POS::ROW_SHORT
        bra     @48e7
@48de:  ldx     near w7e62ca
        lda     near w7e890f,x
        clc
        adc     #MENU_TEXT_POS::ROW_1
@48e7:  jsr     CopyMenuTextToScreenBuf
        lda     #2
        ldy     #near w7e8d13 + 64
        jmp     _c14721       ; update battle menu tile data (-> $7a00 vram)

; ------------------------------------------------------------------------------

; [ copy menu window tile buffer ]

; copy 32x8 tiles from w7e5855 buffer to w7e8d13 buffer

_c148f2:
tmp_buffer_copy:
@48f2:  phb
        longa
        ldx     #near w7e5855
        ldy     #near w7e8d13 + 64
        lda     #$01ff
        mvn     w7e5855,(w7e8d13 + 64)
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [ draw icons for one slot machine slot ]

DrawSlotReel:
@4906:  sty     $10
        longa
        lda     #$0010
        sta     $18
@490f:  lda     f:SlotReel1Tbl,x
        asl
        phx
        tax
        lda     f:_c1495b,x
        sta     $16
        plx
        lda     #$0002
        sta     $14
@4922:  lda     $10
        sta     f:hVMADDL
        lda     $16
        sta     f:hVMDATAL
        inc
        sta     f:hVMDATAL
        inc
        sta     f:hVMDATAL
        inc
        sta     f:hVMDATAL
        lda     $10
        clc
        adc     #$0020
        sta     $10
        lda     $16
        clc
        adc     #$0010
        sta     $16
        dec     $14
        bne     @4922
        inx2
        dec     $18
        bne     @490f
        shorta0
        rts

; ------------------------------------------------------------------------------

_c1495b:
@495b:  .word   $0640,$0644,$0648,$064c,$0660,$0664,$0668,$066c

; ------------------------------------------------------------------------------

; [  ]

_c1496b:
bg1_window_init:
@496b:  ldy     #$6c09
        ldx     #$0000
        jsr     DrawSlotReel
        ldy     #$6c0e
        ldx     #$0020
        jsr     DrawSlotReel
        ldy     #$6c13
        ldx     #$0040
        jsr     DrawSlotReel
        ldy     #$00ee
        jsr     _c14692
        clr_axy
@498f:
.if LANG_EN
        lda     f:_c14a37,x
        sta     near w7e5855+$2e,y
        lda     f:_c14a37+21,x
        sta     near w7e5855+$2f,y
        lda     f:_c14a37+7,x
        sta     near w7e5855+$ae,y
        lda     f:_c14a37+28,x
        sta     near w7e5855+$af,y
        lda     f:_c14a37+14,x
        sta     near w7e5855+$012e,y
        lda     f:_c14a37+35,x
        sta     near w7e5855+$012f,y
        iny2
        inx
        cpx     #7
        bne     @498f
        ldx     #$0180
.else
        lda     f:_c14a37,x
        sta     near w7e5855+$2e,y
        lda     f:_c14a37+14,x
        sta     near w7e5855+$2f,y
        lda     f:_c14a37+7,x
        sta     near w7e5855+$ae,y
        lda     f:_c14a37+21,x
        sta     near w7e5855+$af,y
        iny2
        inx
        cpx     #7
        bne     @498f
        ldx     #$0100
.endif
        stx     $36
        ldx     #near w7e5855
        ldy     #$6aa0
        lda     #^w7e5855
        jsr     TfrVRAM
        clr_ay
@49d3:  lda     near w7e5855+$2e,y
        sta     near w7e5d15,y
.if LANG_EN
        lda     near w7e5855+$ae,y
.else
        lda     near w7e5855,y
.endif
        sta     near w7e5d23,y
        iny
        cpy     #14
        bne     @49d3
        jsr     _c15a17
        lda     #MENU_TEXT::EQUIP
        jsr     LoadMenuText
        jsr     DrawMenuText
        ldx     #$0080
        stx     $36
        ldx     #near w7e5e4d
        lda     #^w7e5e4d
        ldy     #$7e00
        jsr     TfrVRAM
        rts

; ------------------------------------------------------------------------------

; [ init menu text ]

InitMenuText:
@4a01:  jsr     DrawMonsterNames
        jsr     DrawCharNames
        jsr     DrawCharHPInit
        jsr     DrawCharMPInit
        jsr     DrawRowDefText
        lda     #MENU_TEXT::BUSHIDO
        jsr     LoadMenuText
        ldx     near w7e62ca
        lda     #7
        sec
        sbc     near w7e2020
        tax
        clr_ay
@4a21:  lda     f:BushidoTextPalTbl,x
        sta     near w7e56d5+3,y
        inx
        iny3
        cpy     #$0018
        bne     @4a21
        jsr     DrawMenuText
        jmp     DrawCharGaugeInit

; ------------------------------------------------------------------------------

_c14a37:

.if LANG_EN

@4a37:  .byte   $08,$08,$08,$15,$08,$08,$08
        .byte   $08,$08,$08,$ff,$19,$1a,$ff
        .byte   $ff,$16,$17,$17,$18,$17,$18
        .byte   $02,$02,$02,$02,$02,$02,$02
        .byte   $02,$02,$02,$00,$02,$02,$00
        .byte   $00,$02,$02,$02,$02,$02,$02

.else

        .byte   $08,$08,$08,$15,$08,$08,$08
        .byte   $16,$17,$18,$19,$ff,$1a,$1b
        .byte   $02,$02,$02,$02,$02,$02,$02
        .byte   $02,$02,$02,$02,$00,$02,$02

.endif

; ------------------------------------------------------------------------------

; [ update monster names ]

DrawMonsterNames:
@4a61:  clr_a   ; #MENU_TEXT::MONSTER_NAMES
        jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ draw row/def window text ]

DrawRowDefText:
@4a68:  clr_ax
        longa
        lda     #$01ff
@4a6f:  sta     near w7e5d31,x
        sta     near w7e5d77,x
        inx2
        cpx     #$0046
        bne     @4a6f
        shorta0
        lda     #MENU_TEXT::ROW
        jsr     LoadMenuText
        jsr     DrawMenuText
        lda     #MENU_TEXT::DEF
        jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ draw all character names ]

; called at start of battle and again if characters are added or removed
; by a battle event

DrawCharNames:
@4a8f:  lda     #MENU_TEXT::CHAR_NAMES
        jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ update gauge/condemned buffers ]

; A: character number
; A: 0 if not morphed, 4 if morphed (out)

UpdateCharGaugeBuf:
@4a97:  tax
        lda     near w7e64d6,x
        bmi     @4aba                   ; return if character slot is empty
        and     #%11
        tax
        lda     near wATBGaugeBuf,x          ; atb gauge
        sta     near w7e619e,x
        lda     near wMorphGaugeBuf,x        ; morph gauge
        sta     near w7e61a2,x
        lda     near wCondemnNumBuf,x        ; condemned number
        sta     near w7e61a6,x
        lda     near wMorphGaugeBuf,x        ; branch if not morphed
        beq     @4aba
        lda     #4                      ; MENU_TEXT::CHAR1_MORPH
        rts
@4aba:  clr_a                           ; MENU_TEXT::CHAR1_ATB
        rts

; ------------------------------------------------------------------------------

; [ draw gauge for character slot 1 ]

        array_label DRAW_CHAR_GAUGE, 0
@4abc:  clr_a
        jsr     UpdateCharGaugeBuf
        clc
        adc     #MENU_TEXT::CHAR1_ATB   ; add 4 if morphed
        jsr     DrawCharText
        stz     near w7e7b9b
        rts

; ------------------------------------------------------------------------------

; [ draw gauge for character slot 2 ]

        array_label DRAW_CHAR_GAUGE, 1
@4aca:  lda     #1
        jsr     UpdateCharGaugeBuf
        clc
        adc     #MENU_TEXT::CHAR2_ATB   ; add 4 if morphed
        jsr     DrawCharText
        lda     #$01
        sta     near w7e7b9b
        rts

; ------------------------------------------------------------------------------

; [ draw gauge for character slot 3 ]

        array_label DRAW_CHAR_GAUGE, 2
@4adb:  lda     #2
        jsr     UpdateCharGaugeBuf
        clc
        adc     #MENU_TEXT::CHAR3_ATB   ; add 4 if morphed
        jsr     DrawCharText
        lda     #$02
        sta     near w7e7b9b
        rts

; ------------------------------------------------------------------------------

; [ draw gauge for character slot 4 ]

        array_label DRAW_CHAR_GAUGE, 3
@4aec:  lda     #3
        jsr     UpdateCharGaugeBuf
        clc
        adc     #MENU_TEXT::CHAR4_ATB   ; add 4 if morphed
        jsr     DrawCharText
        lda     #$03
        sta     near w7e7b9b
        rts

; ------------------------------------------------------------------------------

; [ draw a single character's current hp ]

        array_label DRAW_CHAR_HP_MP, 0
@4afd:  stz     near w7e7b9d
        lda     #MENU_TEXT::CHAR1_HP
        bra     DrawCharText

        array_label DRAW_CHAR_HP_MP, 2
@4b04:  lda     #$01
        sta     near w7e7b9d
        lda     #MENU_TEXT::CHAR2_HP
        bra     DrawCharText

        array_label DRAW_CHAR_HP_MP, 4
@4b0d:  lda     #$02
        sta     near w7e7b9d
        lda     #MENU_TEXT::CHAR3_HP
        bra     DrawCharText

        array_label DRAW_CHAR_HP_MP, 6
@4b16:  lda     #$03
        sta     near w7e7b9d
        lda     #MENU_TEXT::CHAR4_HP
; fall through

; ------------------------------------------------------------------------------

; [ draw character text ]

DrawCharText:
@4b1d:  jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ draw all characters' current hp ]

DrawCharHPInit:
@4b23:  lda     #MENU_TEXT::CHAR_CURR_HP
        jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ get active character's battle menu position ]

; empty character slots are pushed to the bottom of the battle menu order
; for example, if slot 1 is empty, the battle menu order would be 2, 3, 4, empty

GetCharMenuOrder:
@4b2b:  clr_ax
        lda     near w7e62ca                   ; character slot
@4b30:  cmp     near w7e64d6,x
        beq     @4b3d                   ; return if slot is valid
        inx
        cpx     #4
        bne     @4b30
        clr_ax
@4b3d:  rts

; ------------------------------------------------------------------------------

; [ draw character mp ]

; A: character slot

DrawCharMP:
@4b3e:  jsr     GetCharMenuOrder
        txa
        clc
        adc     #MENU_TEXT::CHAR1_MP
        jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ draw all characters' min/max MP ]

DrawCharMPInit:
@4b4b:  lda     #MENU_TEXT::CHAR_MP
        jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; [ draw all characters' ATB gauges (or max HP) ]

DrawCharGaugeInit:
@4b53:  lda     #MENU_TEXT::CHAR_MAX_HP
        jsr     LoadMenuText
        jmp     DrawMenuText

; ------------------------------------------------------------------------------

; pointers to character battle commands (+$202e)
CharCmdPtrs:
        .byte   array_offset wCmdList, 0
        .byte   array_offset wCmdList, 1
        .byte   array_offset wCmdList, 2
        .byte   array_offset wCmdList, 3

; pointers to character spell/lore lists (+$208e)
CharSpellListPtrs:
        .word   array_offset wSpellList, 0
        .word   array_offset wSpellList, 1
        .word   array_offset wSpellList, 2
        .word   array_offset wSpellList, 3

; pointers to character equipped weapon/shield data (+$7e2b86)
CharEquipPtrs:
        .byte   array_offset wItemList, 0
        .byte   array_offset wItemList, 1
        .byte   array_offset wItemList, 2
        .byte   array_offset wItemList, 3

; ------------------------------------------------------------------------------

; [ get enabled/disabled text color ]

; A: msb set = gray, msb clear = white

GetTextColor:
@4b6b:  and     #$80        ; "disabled" flag >> 5
        lsr5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c14b73:
get_attr_info2:
@4b73:  and     $40
        beq     @4b7a
@4b77:  lda     #$04
        rts
@4b7a:  lda     near w7e890d
        cmp     #$ff
        beq     @4ba9
        lda     $2c
        cmp     #$ff
        beq     @4ba9
        ldx     near w7e62ca
        lda     near w7e2e6e,x
        beq     @4b9e                   ; branch if no genji glove
        lda     near w7e890e
        and     #$08
        beq     @4ba9
        lda     $2d
        and     #$08
        bne     @4b77
        bra     @4ba9
@4b9e:  lda     $2d
        ora     near w7e890e
        and     #$18
        cmp     #$18
        bne     @4b77
@4ba9:  lda     #$08
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

EquipListText:
@4bac:  .byte   $05,$02,$04,$21,$0e,$00,$ff,$ff,$04,$21,$0e,$00,$ff,$00

.else

        EquipListText := ItemListText

.endif

; ------------------------------------------------------------------------------

; [  ]

DrawEquipListText:
@4bba:  clr_ax
@4bbc:  lda     f:EquipListText,x
        sta     near w7e5755,x
        inx
        cpx     #$0013
        bne     @4bbc
        ldx     near w7e62ca
        lda     f:CharEquipPtrs,x
        tay
        lda     f:BitOrTbl,x
        sta     $40

.if LANG_EN

        lda     near wRHandItemList::ItemID,y
        sta     near w7e5755+5
        lda     near wLHandItemList::ItemID,y
        sta     near w7e5755+11
        jsr     InitListTextTfr
        jmp     DrawListText

.else

        clr_a
        sta     near w7e5755+8
        sta     near w7e5755+17
        lda     #$ff
        sta     near w7e5755+6
        sta     near w7e5755+15
        lda     near wRHandItemList::ItemID,y
        sta     near w7e5755+5
        lda     near wLHandItemList::ItemID,y
        sta     near w7e5755+14
        jsr     InitListTextTfr
        jsr     DrawListText
        rts

.endif

; ------------------------------------------------------------------------------

.if !LANG_EN

        ToolsListText := ItemListText
        DrawToolsListText := DrawThrowListText

.else

ToolsListText:
@4be9:  .byte   $05,$02                 ; 2 spaces
        .byte   $04,$21                 ; white font
        .byte   $0e,$00                 ; item name
        .byte   $ff                     ; space
        .byte   $ff                     ; space
        .byte   $04,$21                 ; white font
        .byte   $0e,$00                 ; item name
        .byte   $ff                     ; space
        .byte   $00                     ; terminator

; ------------------------------------------------------------------------------

; [ draw one line of tools menu ]

DrawToolsListText:
@4bf7:  phy
        longa
        asl
        sta     $40
        asl
        clc
        adc     $40
        tay
        shorta0
        tax
@4c06:  lda     f:ToolsListText,x
        sta     near w7e5755,x
        inx
        cpx     #$0013
        bne     @4c06
        lda     near wToolsThrowItemList::_0::ItemID,y
        sta     near w7e5755+5       ; set 1st item id
        lda     near wToolsThrowItemList::_1::ItemID,y
        sta     near w7e5755+11       ; set 2nd item id
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.endif

; ------------------------------------------------------------------------------

; [ draw one line of throw menu text ]

DrawThrowListText:

.if LANG_EN

@4c27:  phy
        longa
        sta     $40
        asl
        clc
        adc     $40
        tay
        shorta0
        tax
@4c35:  lda     f:ItemListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_ItemListText
        bne     @4c35
        lda     near wToolsThrowItemList::ItemID,y
        cmp     #ITEM::EMPTY
        beq     @4c51
        lda     near wToolsThrowItemList::Qty,y
        sta     near w7e5755+8
        bne     @4c5a
@4c51:  clr_a
        sta     near w7e5755+8
        lda     #$ff
        sta     near w7e5755+6
@4c5a:  lda     near wToolsThrowItemList::ItemID,y
        sta     near w7e5755+5
        sta     near w7e5755+12
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.else

@4b87:  phy
        longa
        asl
        sta     $40
        asl
        clc
        adc     $40
        tay
        shorta0
        tax
@4b96:  lda     f:ItemListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_ItemListText
        bne     @4b96
        lda     near wToolsThrowItemList::_0::ItemID,y
        cmp     #ITEM::EMPTY
        beq     @4bb2
        lda     near wToolsThrowItemList::_0::Qty,y
        sta     near w7e5755+8
        bne     @4bbb
@4bb2:  clr_a
        sta     near w7e5755+8
        lda     #$ff
        sta     near w7e5755+6
@4bbb:  lda     near wToolsThrowItemList::_1::ItemID,y
        cmp     #$ff
        beq     @4bca
        lda     near wToolsThrowItemList::_1::Qty,y
        sta     near w7e5755+17
        bne     @4bd3
@4bca:  clr_a
        sta     near w7e5755+17
        lda     #$ff
        sta     near w7e5755+15
@4bd3:  lda     near wToolsThrowItemList::_0::ItemID,y
        sta     near w7e5755+5
        lda     near wToolsThrowItemList::_1::ItemID,y
        sta     near w7e5755+14
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.endif

; ------------------------------------------------------------------------------

; [ draw one row of inventory ]

DrawItemListText:

.if LANG_EN

@4c6b:  phy
        longa
        sta     $40
        asl2
        clc
        adc     $40
        tay
        shorta0
        tax
@4c7a:  lda     f:ItemListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_ItemListText
        bne     @4c7a
        ldx     near w7e62ca
        lda     f:BitOrTbl,x
        sta     $40
        lda     near wItemList::ItemID,y
        cmp     #ITEM::EMPTY
        beq     @4c9f
        lda     near wItemList::Qty,y
        sta     near w7e5755+8
        bne     @4ca8
@4c9f:  clr_a
        sta     near w7e5755+8
        lda     #$ff
        sta     near w7e5755+6
@4ca8:  lda     near wItemList::ItemID,y
        sta     near w7e5755+5
        sta     near w7e5755+12
        lda     near w7e890c
        beq     @4cce
        lda     near wItemList::ItemID,y
        sta     $2c
        lda     near wItemList::UsageFlags,y
        sta     $2d
        lda     near wItemList::EquipFlags,y
        jsr     _c14b73
        ora     near w7e5755+3
        sta     near w7e5755+3
        bra     @4cda
@4cce:  lda     near wItemList::UsageFlags,y
        jsr     GetTextColor
        ora     near w7e5755+3
        sta     near w7e5755+3
@4cda:  jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.else

@4be7:  phy
        longa
        asl
        sta     $40
        asl2
        clc
        adc     $40
        tay
        shorta0
        tax
@4bf7:  lda     f:ItemListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_ItemListText
        bne     @4bf7
        ldx     near w7e62ca
        lda     f:BitOrTbl,x
        sta     $40
        lda     near wItemList::_0::ItemID,y
        cmp     #ITEM::EMPTY
        beq     @4c1c
        lda     near wItemList::_0::Qty,y
        sta     near w7e5755+8
        bne     @4c25
@4c1c:  clr_a
        sta     near w7e5755+8
        lda     #$ff
        sta     near w7e5755+6
@4c25:  lda     near wItemList::_1::ItemID,y
        cmp     #ITEM::EMPTY
        beq     @4c34
        lda     near wItemList::_1::Qty,y
        sta     near w7e5755+17
        bne     @4c3d
@4c34:  clr_a
        sta     near w7e5755+17
        lda     #$ff
        sta     near w7e5755+15
@4c3d:  lda     near wItemList::_0::ItemID,y
        sta     near w7e5755+5
        lda     near wItemList::_1::ItemID,y
        sta     near w7e5755+14
        lda     near w7e890c
        beq     @4c7c
        lda     near wItemList::_0::ItemID,y
        sta     $2c
        lda     near wItemList::_0::UsageFlags,y
        sta     $2d
        lda     near wItemList::_0::EquipFlags,y
        jsr     _c14b73
        ora     near w7e5755+3
        sta     near w7e5755+3
        lda     near wItemList::_1::ItemID,y
        sta     $2c
        lda     near wItemList::_1::UsageFlags,y
        sta     $2d
        lda     near wItemList::_1::EquipFlags,y
        jsr     _c14b73
        ora     near w7e5755+12
        sta     near w7e5755+12
        bra     @4c94
@4c7c:  lda     near wItemList::_0::UsageFlags,y
        jsr     GetTextColor
        ora     near w7e5755+3
        sta     near w7e5755+3
        lda     near wItemList::_1::UsageFlags,y
        jsr     GetTextColor
        ora     near w7e5755+12
        sta     near w7e5755+12
@4c94:  jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.endif

; ------------------------------------------------------------------------------

; [ draw one row of rage menu list ]

DrawRageListText:
@4ce2:  phy
        asl
        tay
        clr_ax
@4ce7:  lda     f:RageListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_RageListText
        bne     @4ce7
        lda     near wRageList,y
        sta     near w7e5755+5
        lda     near wRageList+1,y
        sta     near w7e5755+11
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

; ------------------------------------------------------------------------------

; [ draw one row of dance menu text ]

DrawDanceListText:
@4d08:  phy
        asl
        tay
        clr_ax
@4d0d:  lda     f:DanceListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_DanceListText
        bne     @4d0d
        lda     near wDanceList,y
        sta     near w7e5755+5
        lda     near wDanceList+1,y
        sta     near w7e5755+11
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

; ------------------------------------------------------------------------------

; [ draw magitek list text (one row) ]

DrawMagitekListText:
@4d2e:  phy
        asl
        tay
        clr_ax
@4d33:  lda     f:MagitekListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_MagitekListText
        bne     @4d33
        tya
        tax
        lda     near w7e62ca
        asl5
        tay
        lda     near wCharGfxDataBuf::GfxID,y
        bne     @4d60
        lda     f:TerraMagitekAttackTbl,x
        sta     near w7e5755+5
        lda     f:TerraMagitekAttackTbl+1,x
        sta     near w7e5755+11
        bra     @4d6e
@4d60:  lda     f:DefaultMagitekAttackTbl,x
        sta     near w7e5755+5
        lda     f:DefaultMagitekAttackTbl+1,x
        sta     near w7e5755+11
@4d6e:  jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

; ------------------------------------------------------------------------------

; [ draw lore list text (one row) ]

DrawLoreListText:

.if LANG_EN

@4d76:  phy
        sta     $40
        lda     near w7e62ca
        asl
        tax
        lda     $40
        longa
        asl2
        clc
        adc     f:CharSpellListPtrs,x
        tay
        shorta0
        tax
@4d8e:  lda     f:LoreListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_LoreListText
        bne     @4d8e
        lda     near wSpellListLore::AttackID,y
        sta     near w7e5755+6               ; attack index
        lda     near wSpellListLore::Disabled,y
        jsr     GetTextColor
        ora     near w7e5755+4               ; text color
        sta     near w7e5755+4
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.else

@4d30:  phy
        asl
        sta     $40
        lda     near w7e62ca
        asl
        tax
        lda     $40
        longa
        asl2
        clc
        adc     f:CharSpellListPtrs,x
        tay
        shorta0
        tax
@4d49:  lda     f:LoreListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_LoreListText
        bne     @4d49
        lda     near wSpellListLore::AttackID,y
        sta     near w7e5755+6
        lda     near wSpellListLore::AttackID + 4,y
        sta     near w7e5755+12
        lda     near wSpellListLore::Disabled,y
        jsr     GetTextColor
        ora     near w7e5755+4
        sta     near w7e5755+4
        lda     near wSpellListLore::Disabled + 4,y
        jsr     GetTextColor
        ora     near w7e5755+10
        sta     near w7e5755+10
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.endif

; ------------------------------------------------------------------------------

; [ draw magic list text (one row) ]

DrawMagicListText:

.if LANG_EN

@4db5:  phy
        asl
        sta     $40
        lda     near w7e62ca
        asl
        tax
        lda     $40
        longa
        asl2
        clc
        adc     f:CharSpellListPtrs,x
        tay
        shorta0
        tax
@4dce:  lda     f:MagicListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_MagicListText
        bne     @4dce
        lda     near wSpellListMagic::AttackID,y
        sta     near w7e5755+5               ; attack index (left spell this row)
        lda     near wSpellListMagic::AttackID + 4,y
        sta     near w7e5755+11              ; attack index (right spell this row)
        lda     near wSpellListMagic::Disabled,y
        jsr     GetTextColor
        ora     near w7e5755+3               ; text color (left)
        sta     near w7e5755+3
        lda     near wSpellListMagic::Disabled + 4,y
        jsr     GetTextColor
        ora     near w7e5755+9               ; text color (right)
        sta     near w7e5755+9
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.else

@4d82:  phy
        sta     $40
        asl
        clc
        adc     $40
        sta     $40
        lda     near w7e62ca
        asl
        tax
        lda     $40
        longa
        asl2
        clc
        adc     f:CharSpellListPtrs,x
        tay
        shorta0
        tax
@4da0:  lda     f:MagicListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_MagicListText
        bne     @4da0
        lda     near wSpellListMagic::AttackID,y
        sta     near w7e5755+5
        lda     near wSpellListMagic::AttackID + 4,y
        sta     near w7e5755+11
        lda     near wSpellListMagic::AttackID + 8,y
        sta     near w7e5755+17
        lda     near wSpellListMagic::Disabled,y
        jsr     GetTextColor
        ora     near w7e5755+3
        sta     near w7e5755+3
        lda     near wSpellListMagic::Disabled + 4,y
        jsr     GetTextColor
        ora     near w7e5755+9
        sta     near w7e5755+9
        lda     near wSpellListMagic::Disabled + 8,y
        jsr     GetTextColor
        ora     near w7e5755+15
        sta     near w7e5755+15
        jsr     InitListTextTfr
        jsr     DrawListText
        ply
        rts

.endif

; ------------------------------------------------------------------------------

; [ init list text transfer to VRAM ]

InitListTextTfr:
@4e07:  ldx     #near w7e5755
        stx     near w7e88dd
        ldx     #near w7e5e4d
        stx     near w7e88df
        lda     #$20
        sta     near w7e88e1
        lda     #$21
        sta     near w7e88e2
        rts

; ------------------------------------------------------------------------------

; [ draw magic list when summon window is open ]

DrawSummonMagicListText:
@4e1e:  clr_ax
@4e20:  lda     f:SummonMagicListText,x
        sta     near w7e5755,x
        inx
        cpx     #sizeof_SummonMagicListText
        bne     @4e20
        lda     near w7e62ca
        asl
        tax
        longa
        lda     f:CharSpellListPtrs,x
        tax
        shorta0
        lda     near wSpellListGenju::AttackID,x
        sta     near w7e5755+12
        lda     near wSpellListGenju::MPCost,x
        sta     near w7e5755+21
        lda     near wSpellListGenju::Disabled,x
        jsr     GetTextColor
        ora     near w7e5755+10
        sta     near w7e5755+10
        jsr     InitListTextTfr
        jmp     DrawListText

; ------------------------------------------------------------------------------

; [ load menu text (bg3) ]

; loads raw menu text from ROM to a WRAM buffer, along with the appropriate
; decoded text buffer info

; A: MENU_TEXT enum value

LoadMenuText:

; copy raw text to buffer
@4e5a:  pha
        asl
        tax
        lda     #^MenuTextPtrs
        sta     $12
        longa
        lda     f:MenuTextPtrs,x
        sta     $10
        ldy     zZero
@4e6b:  lda     [$10],y
        sta     near w7e56d5,y
        iny2
        cpy     #$0040
        bne     @4e6b

; load decoded text buffer info
        shorta0
        pla
        asl2
        tax
        lda     f:MenuTextBufTbl,x     ; text buffer pointer (2 bytes)
        sta     near w7e88d9
        lda     f:MenuTextBufTbl+1,x
        sta     near w7e88da
        lda     f:MenuTextBufTbl+2,x   ; buffer width (in tiles)
        sta     near w7e88db

; init tile flags and raw text buffer pointer
        lda     #$21                    ; tile flags
        sta     near w7e88dc
        ldx     #near w7e56d5
        stx     near w7e88d7
        rts

; ------------------------------------------------------------------------------

; [  ]

_c14e9f:
get_chg_def_para:
@4e9f:  lda     near w7e2f2e
        beq     @4eae
        lda     #WINDOW_POS::ROW_DEF_OPEN_SHORT
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::ROW_DEF_1
        jmp     LoadMenuTextScrollData
@4eae:  ldx     near w7e62ca
        lda     near w7e890f,x     ; cursor position
        pha
        clc
        adc     #WINDOW_POS::ROW_DEF_OPEN
        jsr     LoadWindowPos
        pla
        clc
        adc     #MENU_TEXT_SCROLL::ROW_DEF_1
        jmp     LoadMenuTextScrollData

; ------------------------------------------------------------------------------

; [  ]

_c14ec2:
set_cgadd_sub:
@4ec2:  ldx     zZero
@4ec4:  sta     near w7e8993 + 151 * 4 + 2,x
        sta     near w7e8993 + (151 + 18) * 4 + 2,x
        sta     near w7e8993 + (151 + 36) * 4 + 2,x
        sta     near w7e8993 + (151 + 54) * 4 + 2,x
        inx4
        cpx     #18 * 4
        bne     @4ec4
        rts

; ------------------------------------------------------------------------------

; [ update menu window $25: open swdtech window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::BUSHIDO_OPEN
@4eda:  lda     #$83
        jsr     _c14ec2
        lda     #WINDOW_POS::BUSHIDO_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::BUSHIDO
        jsr     LoadMenuTextScrollData
        inc     near wIsBG1MenuWindowUpdate
        jsr     _c24872       ; init bg tile data for swdtech numerals
        jmp     _c14f77

; ------------------------------------------------------------------------------

; [ update menu window $26: close swdtech window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::BUSHIDO_CLOSE
@4ef2:  inc     $10
        lda     #WINDOW_POS::BUSHIDO_CLOSE
        jsr     LoadWindowPos
        inc     near wIsBG1MenuWindowUpdate
        lda     #MENU_TEXT_SCROLL::BUSHIDO
        jsr     LoadMenuTextScrollData
        jsr     _c14f8c       ; close menu window
        jmp     _c148f2

; ------------------------------------------------------------------------------

; [ update menu window $17: open row window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::ROW_OPEN
@4f07:  lda     #$83
        jsr     _c14ec2
        jsr     _c14e9f
        jsr     _c148cb
        inc     near wIsBG1MenuWindowUpdate
        jmp     _c14f77

; ------------------------------------------------------------------------------

; [ update menu window $19: open def. window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::DEF_OPEN
@4f18:  lda     #$83
        jsr     _c14ec2
        jsr     _c14e9f
        jsr     _c148a4
        lda     near w7e2f2e
        beq     @4f2c
        lda     #$60                    ; short mode
        bra     @4f2e
@4f2c:  lda     #$30                    ; window mode
@4f2e:  sta     $10
        stz     $11
        longa
        lda     near w7e7bd2
        sec
        sbc     $10
        sta     near w7e7bd2
        shorta0
        inc     near wIsBG1MenuWindowUpdate
        jmp     _c14f77

; ------------------------------------------------------------------------------

; [ update menu window $18/$1a: close row/def. window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::ROW_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::DEF_CLOSE
@4f46:  inc     $10
        lda     #MENU_TEXT_SCROLL::ROW_DEF_CLOSE
        jsr     LoadMenuTextScrollData
        lda     near w7e2f2e
        beq     @4f5a
        lda     #WINDOW_POS::ROW_DEF_CLOSE_SHORT
        jsr     LoadWindowPos
        clr_a
        bra     @4f68
@4f5a:  ldx     near w7e62ca
        lda     near w7e890f,x
        pha
        clc
        adc     #WINDOW_POS::ROW_DEF_CLOSE
        jsr     LoadWindowPos
        pla
@4f68:  clc
        adc     #MENU_TEXT_SCROLL::ROW_DEF_1
        jsr     LoadMenuTextScrollData
        inc     near wIsBG1MenuWindowUpdate
        jsr     _c14f8c       ; close menu window
        jmp     _c148f2

; ------------------------------------------------------------------------------

; [ open menu window ]

_c14f77:
set_open_flag:
@4f77:  inc     near wEnableUpdateMenuWindowTiles

_c14f7a:
@4f7a:  lda     #MENU_WINDOW_STATE::WAIT_OPEN
        sta     near wMenuWindowState
        stz     near w7e7b85
        inc     near w7e7bdd
        inc     near w7e7bd1
        rts

; ------------------------------------------------------------------------------

; [ close menu window ]

set_close_flag:
@4f89:  inc     near wEnableUpdateMenuWindowTiles

_c14f8c:
set_close_flag2:
@4f8c:  lda     #MENU_WINDOW_STATE::WAIT_CLOSE
        sta     near wMenuWindowState
        stz     near w7e7b85
        inc     near w7e7bdd
        inc     near w7e7bd1
        rts

; ------------------------------------------------------------------------------

; [ update menu window $0d: open esper window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::SUMMON_OPEN
@4f9b:  lda     #WINDOW_POS::SUMMON_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::GENJU
        jsr     LoadMenuTextScrollData
        jmp     _c14f7a       ; open menu window

; ------------------------------------------------------------------------------

; [ update menu window $0e: close esper window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::SUMMON_CLOSE
@4fa8:  inc     $10
        lda     #WINDOW_POS::SUMMON_CLOSE
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::GENJU
        jsr     LoadMenuTextScrollData
        jmp     _c14f8c       ; close menu window

; ------------------------------------------------------------------------------

; [ update menu window $09: open equip window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::EQUIP_OPEN
@4fb7:  lda     #WINDOW_POS::EQUIP_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::EQUIP
        jsr     LoadMenuTextScrollData
        jmp     _c14f7a       ; open menu window

; ------------------------------------------------------------------------------

; [ update menu window $0a: close equip window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::EQUIP_CLOSE
@4fc4:  inc     $10
        lda     #WINDOW_POS::EQUIP_CLOSE
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::EQUIP
        jsr     LoadMenuTextScrollData
        jmp     _c14f8c       ; close menu window

; ------------------------------------------------------------------------------

; [ set bg1 scroll hdma data for slot window ]

; +X: horizontal scroll position
; +Y: vertical scroll position

_c14fd3:
throt_line_set:
@4fd3:  longa
        stx     $22
        sty     $24
        ldx     #$028c
@4fdc:  lda     $22
        sta     near wBG1ScrollData::Horz,x
        lda     $24
        sta     near wBG1ScrollData::Vert,x
        inx4
        cpx     #$034c      ; copy for 211 scanlines
        bne     @4fdc
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update menu window $04: open slot window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::SLOT_OPEN
@4ff3:  jsr     _c146a5
        ldy     #$004c
        ldx     #$0100
        jsr     _c14fd3
        lda     #WINDOW_POS::SLOT_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::LIST
        jsr     LoadMenuTextScrollData
        jmp     _c14f7a       ; open menu window

; ------------------------------------------------------------------------------

; [ clear dialogue text tilemap buffer ]

ClearDlgTextTileBuf:
        lda     #$04
        sta     near w7e7afd
        shorti
        longa
        phd
        lda     #$0100      ; nonzero dp
        pha
        pld
        ldx     #$00
        lda     #$0060
@5020:  sta     <$0102,x
        sta     near wListTextScrollData::_8::Vert,x
        inx4
        cpx     #$c0
        bne     @5020
@502d:  sta     <$0102,x
        inx4
        cpx     #$00
        bne     @502d
        pld
        shorta0
        longi
        rts

; ------------------------------------------------------------------------------

; [ update menu window $27: open dialog window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::DLG_OPEN
@503e:  clr_ax
        longa
@5042:  lda     near wBG3ScrollData::_155,x
        sta     near wListTextScrollData::_64,x
        inx2
        cpx     #$0100
        bne     @5042
        shorta0
        jsr     ClearDlgTextTileBuf
        lda     #WINDOW_POS::DLG_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::LIST
        jsr     LoadMenuTextScrollData
        jmp     _c14f7a       ; open menu window

; ------------------------------------------------------------------------------

; [ update menu window $28: close dialog window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::DLG_CLOSE
@5062:  inc     $10
        lda     #WINDOW_POS::DLG_CLOSE_NONE
        jsr     LoadWindowPos
        clr_ax
        longa
@506d:  lda     near wListTextScrollData::_64,x
        sta     near wListTextScrollData::_0,x
        inx2
        cpx     #$0100
        bne     @506d
        shorta0
        lda     #MENU_TEXT_SCROLL::LIST
        jsr     LoadMenuTextScrollData
        inc     near w7e7bee
        jmp     _c14f8c       ; close menu window

; ------------------------------------------------------------------------------

; [ update menu window $07/$13/$15/$1b/$1d/$20: open item/rage/dance/magitek/throw/tools window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::ITEM_OPEN
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::RAGE_OPEN
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::DANCE_OPEN
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MAGITEK_OPEN
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::THROW_OPEN
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::TOOLS_OPEN
@5088:  jsr     _c146a5
        lda     #WINDOW_POS::LIST_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::LIST
        jsr     LoadMenuTextScrollData
        jmp     _c14f7a       ; open menu window

; ------------------------------------------------------------------------------

; [ update menu window $0b/$11: open magic/lore window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MAGIC_OPEN
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::LORE_OPEN
@5098:  lda     #$82
        jsr     _c14ec2
        jsr     _c146a5
        lda     #WINDOW_POS::MAGIC_OPEN
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::LIST
        jsr     LoadMenuTextScrollData
        jmp     _c14f7a       ; open menu window

; ------------------------------------------------------------------------------

; [ update menu window $06: close slot window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::SLOT_CLOSE
@50ad:  clr_axy
        jsr     _c14fd3
        stz     near w7e8992
; fall through

; ------------------------------------------------------------------------------

; [ update menu window: close item/magic/lore/rage/dance/magitek/throw/tools window ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::ITEM_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MAGIC_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::LORE_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::RAGE_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::DANCE_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MAGITEK_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::THROW_CLOSE
        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::TOOLS_CLOSE
@50b6:  inc     $10
        lda     #WINDOW_POS::LIST_CLOSE
        jsr     LoadWindowPos
        lda     #MENU_TEXT_SCROLL::LIST
        jsr     LoadMenuTextScrollData
        inc     near w7e7bee
        jmp     _c14f8c       ; close menu window

; ------------------------------------------------------------------------------

; [ update menu window $1f:  ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::MENU_WINDOW_STATE_31
@50c8:  jsr     _c148f2
        jmp     GoToNextWindowState

; ------------------------------------------------------------------------------

; [ update menu window $01: window opening ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::WAIT_OPEN
@50ce:  lda     near w7e7bd1
        ora     near w7e7bdd
        bne     @50dc
        stz     near w7e7b98
        jsr     GoToNextWindowState
@50dc:  rts

; ------------------------------------------------------------------------------

; [ update menu window $02: window closing ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::WAIT_CLOSE
@50dd:  lda     near w7e7bd1
        ora     near w7e7bdd
        bne     @50e8
        jsr     GoToNextWindowState
@50e8:  rts

; ------------------------------------------------------------------------------

; [ go to next menu window state ]

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::GOTO_NEXT
GoToNextWindowState:
@50e9:  clr_ax
        sta     near wMenuWindowState+15              ; add state 0 to end of queue
@50ee:  lda     near wMenuWindowState+1,x             ; move all items in queue up one slot
        sta     near wMenuWindowState,x
        inx
        cpx     #15
        bne     @50ee
        rts

; ------------------------------------------------------------------------------

; [ load menu window position data ]

; $10: 0 = window opening, 1 = window closing
;   A: window type
;        $00: no menu (open)
;        $01: command select (open)
;        $02: slot (open)
;        $03: item/rage/dance/magitek/throw/tools (open)
;        $04: magic/lore (open)
;        $05: weapon change (open)
;        $06: item/rage/dance/magitek/throw/tools/magic/lore/slot (close)
;        $07: weapon change (close)
;        $08: esper (open)
;        $09: esper (close)
;        $0a: row/def, slot 1 (open)
;        $0b: row/def, slot 2 (open)
;        $0c: row/def, slot 3 (open)
;        $0d: row/def, slot 4 (open)
;        $0e: row/def, slot 1 (close)
;        $0f: row/def, slot 2 (close)
;        $10: row/def, slot 3 (close)
;        $11: row/def, slot 4 (close)
;        $12: swdtech (open)
;        $13: swdtech (close)
;        $14: dialog (open)
;        $15: dialog (close)
;        $16: dialog (close, go to command select)
;        $17: row/def, short (open)
;        $18: row/def, short (close)
;        $19: character status select (open)
;        $1a: character status select (close, go to item select)
;        $1b: character status select (open, go to magic select)

LoadWindowPos:
@50fb:  asl2
        tax
        lda     $10
        beq     @5133       ; branch if menu is opening
        longa
        lda     f:MenuWindowPosTbl,x
        sta     near w7e7bd2       ; menu window horizontal scroll position (pixels)
        lda     f:MenuWindowPosTbl+2,x
        sta     near w7e7bd4       ; menu window vertical scroll position (pixels)
        lda     f:MenuWindowSizeTbl+2,x
        sta     near w7e7bd6       ; menu window height (tiles)
        asl5
        clc
        adc     f:MenuWindowSizeTbl,x
        sec
        sbc     #$0010
        sta     near w7e7bd7       ; menu window bottom (pixels)
        lda     f:MenuWindowSizeTbl,x
        sta     near w7e7bd9       ; menu window top (pixels)
        bra     @515e
@5133:  longa
        lda     f:MenuWindowPosTbl,x
        sta     near w7e7bd2       ; menu window horizontal scroll position (pixels)
        lda     f:MenuWindowPosTbl+2,x
        sta     near w7e7bd4       ; menu window vertical scroll position (pixels)
        lda     f:MenuWindowSizeTbl+2,x
        sta     near w7e7bd6       ; menu window height (tiles)
        dec
        asl4
        clc
        adc     f:MenuWindowSizeTbl,x
        sta     near w7e7bd7       ; menu window bottom (pixels)
        clc
        adc     #$0010
        sta     near w7e7bd9       ; menu window top (pixels)
@515e:  stz     near wIsBG1MenuWindowUpdate  ; bg2 update by default
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load menu text hdma scroll data ]

; $10: 0 = window opening, 1 = window closing
;   A: text type
;        $00: command select
;        $01:
;        $02: magic/tools/dance/rage/lore/item/slot/dialog
;        $03: esper
;        $04: weapon change
;        $05: row/def, slot 1
;        $06: row/def, slot 2
;        $07: row/def, slot 3
;        $08: row/def, slot 4
;        $09: swdtech
;        $0a: character select (item/magic)

LoadMenuTextScrollData:
@5165:  asl3
        tax
        stz     near w7e7beb
        lda     $10
        beq     @51ad       ; branch if menu is opening
        longa
        lda     f:MenuTextScrollTbl,x
        clc
        adc     #$0010
        sta     near w7e7be2
        lda     f:MenuTextScrollTbl+2,x
        clc
        adc     #$0010
        sta     near w7e7be4
        lda     f:MenuTextScrollTbl+4,x
        asl5
        pha
        clc
        adc     f:MenuTextScrollTbl,x
        sec
        sbc     #$0020
        sta     near w7e7bde
        pla
        clc
        adc     f:MenuTextScrollTbl+2,x
        sec
        sbc     #$0020
        sta     near w7e7be0
        bra     @51d8
@51ad:  longa
        lda     f:MenuTextScrollTbl+4,x   ; text height (tiles)
        dec                 ; convert to pixels
        asl4
        pha
        clc
        adc     f:MenuTextScrollTbl,x   ; add source address
        sta     near w7e7bde       ;
        clc
        adc     #$0010
        sta     near w7e7be2
        pla
        clc
        adc     f:MenuTextScrollTbl+2,x
        sta     near w7e7be0
        clc
        adc     #$0010
        sta     near w7e7be4
@51d8:  lda     f:MenuTextScrollTbl,x
        clc
        adc     #$0010
        sta     near w7e7be7
        lda     f:MenuTextScrollTbl+2,x
        clc
        adc     #$0010
        sta     near w7e7be9
        lda     f:MenuTextScrollTbl+4,x
        dec
        asl5
        dec
        sta     near w7e7bec
        shorta0
        lda     f:MenuTextScrollTbl+4,x
        dec
        sta     near w7e7be6
        stz     near w7e7bee
        rts

; ------------------------------------------------------------------------------

; [ clear menu window tile data buffer ]

ResetMenuTileBuf:
@520b:  longa
        ldx     zZero
@520f:  lda     #$00ff
        sta     near w7e8d13,x
        inx2
        cpx     #$0300
        bne     @520f
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update menu window $29: get command window setting ]

; called when command window is opened

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::GET_CMD_SETTING
@5220:  ldx     near w7e62ca       ; active character
        lda     near w7e62cc,x     ; branch if character is controlling a monster
        bne     _523d
        lda     near w7e2f2e       ; command setting
        beq     _5235       ; branch if window
        lda     #$01
        sta     near w7e64b8       ; use short window
        jmp     GoToNextWindowState

; ------------------------------------------------------------------------------

; [ update menu window $2a: use normal command window ]

; called when command window is closed

        array_label MENU_WINDOW_STATE, MENU_WINDOW_STATE::RESET_CMD_SETTING
_5235:  lda     #$02
        sta     near w7e64b8       ; use normal window
        jmp     GoToNextWindowState

_523d:  lda     #$03
        sta     near w7e64b8       ; use control window
        jmp     GoToNextWindowState

; ------------------------------------------------------------------------------

; [ init command select menu window tile data ]

_c15245:
set_short_frame:
@5245:  clr_ax
        longa
@5249:  lda     near w7e8d13,x     ; copy buffer to window mode tile data
        sta     near w7e9213,x
        inx2
        cpx     #$0200
        bne     @5249
        shorta
        clr_a   ; #WINDOW_BUF::MONSTER_NAMES
        jsr     DrawMenuWindow
        lda     #WINDOW_BUF::CHAR_INFO
        jsr     DrawMenuWindow
        lda     #WINDOW_BUF::CONTROL
        jsr     DrawMenuWindow
        clr_ax
        longa
@526a:  lda     near w7e8d13,x     ; copy buffer to relm's "control" mode tile data
        sta     near w7e9413,x
        inx2
        cpx     #$0200
        bne     @526a
        shorta
        clr_a   ; #WINDOW_BUF::MONSTER_NAMES
        jsr     DrawMenuWindow
        lda     #WINDOW_BUF::CHAR_INFO
        jsr     DrawMenuWindow
        lda     #WINDOW_BUF::CMD_SHORT
        jsr     DrawMenuWindow
        clr_ax
        longa
@528b:  lda     near w7e8d13,x     ; copy buffer to short mode tile data
        sta     near w7e9013,x
        inx2
        cpx     #$0200
        bne     @528b
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init menu window tile data ]

InitMenuWindows:
@529c:  jsr     ResetMenuTileBuf

; transfer top menu window tiles (monster names and character info)
        clr_a   ; #WINDOW_BUF::MONSTER_NAMES
        jsr     DrawMenuWindow
        lda     #WINDOW_BUF::CHAR_INFO
        jsr     DrawMenuWindow
        clr_a   ; #WINDOW_VRAM::TOP_MENU
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (closed menu)

; transfer command window tiles
        lda     #WINDOW_BUF::CMD_WINDOW
        jsr     DrawMenuWindow
        jsr     _c15245       ; init command select menu window tile data
        lda     #WINDOW_VRAM::CMD
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (command select)

; transfer slot window tiles
        lda     #WINDOW_BUF::SLOT
        jsr     DrawMenuWindow
        jsr     _c15335       ; init slot window tile data
        lda     #WINDOW_VRAM::SLOT
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (slot)

; transfer list/dialog/etc. window tiles
        lda     #WINDOW_BUF::LIST
        jsr     DrawMenuWindow
        lda     #WINDOW_VRAM::LIST
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (item/dialog/etc.)

; transfer magic list window tiles
        lda     #WINDOW_BUF::MAGIC
        jsr     DrawMenuWindow
        lda     #WINDOW_BUF::MP_REQD
        jsr     DrawMPWindow
        lda     #WINDOW_VRAM::MAGIC
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (magic/lore select)

; transfer equip window tiles
        lda     #WINDOW_BUF::EQUIP
        jsr     DrawMenuWindow
        lda     #WINDOW_VRAM::EQUIP
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (weapon select)

; transfer genju window tiles
        lda     #WINDOW_BUF::GENJU
        jsr     DrawMenuWindow
        lda     #WINDOW_VRAM::GENJU
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (esper)

; transfer row/def window tiles
        jsr     ResetMenuTileBuf
        lda     #WINDOW_BUF::ROW_DEF
        jsr     DrawMenuWindow
        lda     #WINDOW_VRAM::ROW_DEF
        jsr     TfrMenuWindowTiles       ; copy menu window tile data to vram (row/def.)

; transfer bushido window tiles
        jsr     ResetMenuTileBuf
        lda     #WINDOW_BUF::BUSHIDO
        jsr     DrawMenuWindow
        lda     #WINDOW_VRAM::BUSHIDO
        jmp     TfrMenuWindowTiles       ; copy menu window tile data to vram (swdtech)

; ------------------------------------------------------------------------------

; [ init slot window tile data (one row) ]

; +X: tile data offset
; +A: tile data

_c1530d:
one_sp_frame_set:
@530d:  sta     near w7e8d13+$52,x     ; first slot
        sta     near w7e8d13+$5c,x     ; second slot
        sta     near w7e8d13+$66,x     ; third slot
        inc
        sta     near w7e8d13+$54,x     ; second tile
        sta     near w7e8d13+$5e,x
        sta     near w7e8d13+$68,x
        inc
        sta     near w7e8d13+$56,x     ; third tile
        sta     near w7e8d13+$60,x
        sta     near w7e8d13+$6a,x
        inc
        sta     near w7e8d13+$58,x     ; fourth tile
        sta     near w7e8d13+$62,x
        sta     near w7e8d13+$6c,x
        rts

; ------------------------------------------------------------------------------

; [ init slot window tile data ]

_c15335:
sp_window_frame_set:
@5335:  clr_ax
        longa
        ldx     #$0000
        lda     #$2a68
        jsr     _c1530d       ; set slot window tile data (1st row)
        ldx     #$0040
        lda     #$2a78
        jsr     _c1530d       ; set slot window tile data (2nd row)
        ldx     #$0080
        lda     #$2a6c
        jsr     _c1530d       ; set slot window tile data (3rd row)
        ldx     #$00c0
        lda     #$2a7c
        jsr     _c1530d       ; set slot window tile data (4th row)
        ldx     #$0100
        lda     #$aa78
        jsr     _c1530d       ; set slot window tile data (5th row)
        ldx     #$0140
        lda     #$aa68
        jsr     _c1530d       ; set slot window tile data (6th row)
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ copy menu window tile data to vram ]

; A: window location in vram (WINDOW_VRAM enum)

TfrMenuWindowTiles:
@5373:  asl
        tax
        longa
        lda     f:MenuWindowVRAMPtrs,x
        tay
        shorta0
        ldx     #$0200      ; size = $0200 (32 x 8)
        stx     $36
        ldx     #near w7e8d13
        lda     #^w7e8d13
        jmp     TfrVRAM

; ------------------------------------------------------------------------------

; [ load menu window tile data (messages at top of screen) ]

; A: window number (WINDOW_BUF enum)

DrawMsgWindow:
@538c:  asl2
        tax
        lda     #$80            ; add $80 to each tile index
        sta     z7c
        lda     #$28            ; tiles are priority 1, palette 2, tile index +#$0000
        bra     DrawWindowMain

; ------------------------------------------------------------------------------

; [ load menu window tile data (mp needed) ]

; priority 0 allows bg1 text to be shown above bg2
; A: window number (WINDOW_BUF enum)

DrawMPWindow:
@5397:  stz     z7c
        asl2
        tax
        lda     #$0a        ; tiles are priority 0, palette 2, tile index +#$0200
        bra     DrawWindowMain

; ------------------------------------------------------------------------------

; [ load menu window tile data ]

; A: window number (WINDOW_BUF enum)

DrawMenuWindow:
@53a0:  stz     z7c
        asl2
        tax
        lda     #$2a        ; tiles are priority 1, palette 2, tile index +#$0200
; fallthrough

DrawWindowMain:
@53a7:  sta     near w7e7bae
        ldy     zZero
@53ac:  lda     f:WindowBufTbl,x
        sta     near w7e88d3,y
        inx
        iny
        cpy     #4
        bne     @53ac
        ldx     near w7e88d5
        stx     $10
        stz     $14
        lda     near w7e88d4
        dec2
        sta     $13
        longa
        lda     f:WindowBorderTileTbl                 ; top border
        sta     $22
        lda     f:WindowBorderTileTbl+2
        sta     $24
        shorta0
        lda     near w7e88d3
        sta     $12
        jsr     DrawWindowRow
        lda     #$40
        jsr     IncWindowTilePtr
@53e6:  lda     $14
        and     #$0f
        tax
        longa
        lda     f:WindowTileTbl,x
        sta     $22
        lda     f:WindowTileTbl+2,x
        sta     $24
        shorta0
        lda     near w7e88d3
        sta     $12
        jsr     DrawWindowRow
        lda     $14
        clc
        adc     #$04
        sta     $14
        lda     #$40
        jsr     IncWindowTilePtr
        dec     $13
        bne     @53e6
        longa
        lda     f:WindowBorderTileTbl+4                 ; bottom border
        sta     $22
        lda     f:WindowBorderTileTbl+6
        sta     $24
        shorta0
        lda     near w7e88d3
        sta     $12
        jsr     DrawWindowRow
        ldx     near w7e88d5
        stx     $10
        lda     near w7e88d4
        sta     $12
        lda     f:WindowBorderTileTbl+12                 ; left border
        sta     $22
        lda     f:WindowBorderTileTbl+13
        sta     $23
        ldy     zZero
        jsr     DrawWindowCol
        ldx     near w7e88d5
        stx     $10
        lda     near w7e88d4
        sta     $12
        lda     f:WindowBorderTileTbl+16                 ; right border
        sta     $22
        lda     f:WindowBorderTileTbl+17
        sta     $23
        lda     near w7e88d3
        dec
        asl
        tay
        jsr     DrawWindowCol
        ldx     near w7e88d5
        stx     $10
        ldy     zZero
        lda     f:WindowBorderTileTbl+8                 ; top left corner
        jsr     DrawWindowTile
        lda     near w7e88d3
        dec
        asl
        tay
        lda     f:WindowBorderTileTbl+9                 ; top right corner
        jsr     DrawWindowTile
        lda     near w7e88d4
        dec
        longa
        asl6
        clc
        adc     near w7e88d5
        sta     $10
        clr_ay
        shorta
        lda     f:WindowBorderTileTbl+10                 ; bottom left corner
        jsr     DrawWindowTile
        lda     near w7e88d3
        dec
        asl
        tay
        lda     f:WindowBorderTileTbl+11                 ; bottom right corner
        jsr     DrawWindowTile
        rts

; ------------------------------------------------------------------------------

; [ add to window tile pointer ]

IncWindowTilePtr:
@54ad:  longa
        clc
        adc     $10
        sta     $10
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ draw a row of window tiles ]

; $12: row width

DrawWindowRow:
@54b8:  clr_axy
        shorti
@54bd:  lda     $22,x
        jsr     DrawWindowTile
        txa
        inc
        and     #$03
        tax
        dec     $12
        bne     @54bd
        longi
        rts

; ------------------------------------------------------------------------------

; [ draw a column of window tiles ]

DrawWindowCol:
@54ce:  clr_ax
@54d0:  lda     $22,x
        clc
        adc     z7c
        sta     ($10),y
        iny
        lda     near w7e7bae
        sta     ($10),y
        iny
        longa
        tya
        clc
        adc     #$003e
        tay
        shorta0
        txa
        inc
        and     #$01
        tax
        dec     $12
        bne     @54d0
        rts

; ------------------------------------------------------------------------------

; [ draw one window tile ]

DrawWindowTile:
@54f3:  clc
        adc     z7c
        sta     ($10),y
        iny
        lda     near w7e7bae
        sta     ($10),y
        iny
        rts

; ------------------------------------------------------------------------------

; menu window tile numbers
WindowTileTbl:
@5500:  .byte   $23,$20,$21,$22
        .byte   $27,$24,$25,$26
        .byte   $2b,$28,$29,$2a
        .byte   $2f,$2c,$2d,$2e

; menu border tile numbers (top, bottom, corners, left side, right side)
WindowBorderTileTbl:
@5510:  .byte   $32,$31,$32,$31
        .byte   $3a,$39,$3a,$39
        .byte   $30,$33,$38,$3b
        .byte   $36,$34,$36,$34
        .byte   $37,$35,$37,$35

; ------------------------------------------------------------------------------

; [ update menu cursor state ]

; called during NMI (unless battle is paused)

UpdateMenuInput:
@5524:  lda     near wMenuInput                 ; menu cursor state
        asl
        tax
        jmp     (near UpdateMenuInputTbl,x)

; ------------------------------------------------------------------------------

; update menu cursor state jump table
UpdateMenuInputTbl:
        ptr_tbl MENU_INPUT

; ------------------------------------------------------------------------------

; [ update menu state $3f: open character status window ]

        array_label MENU_INPUT, MENU_INPUT::CHAR_STATUS_OPEN
@55b0:  lda     #MENU_WINDOW_STATE::CHAR_STATUS_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::CHAR_STATUS
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $40: close character status window ]

        array_label MENU_INPUT, MENU_INPUT::CHAR_STATUS_CLOSE
@55ba:  lda     #MENU_WINDOW_STATE::CHAR_STATUS_CLOSE
        sta     near wMenuWindowState
        lda     near w7eecba                   ; status menu type (item or magic)
        asl
        clc
        adc     #MENU_INPUT_QUEUE::ITEM
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $32: init slot hdma ]

        array_label MENU_INPUT, MENU_INPUT::SLOT_INIT_HDMA

; init vertical offset-per-tile data for all 3 reels
@55c9:  clr_ax
        lda     #76
@55cd:  sta     near wOffsetPerTile::V + 8 * 2,x
        sta     near wOffsetPerTile::V + 13 * 2,x
        sta     near wOffsetPerTile::V + 18 * 2,x
        inx2
        cpx     #8
        bne     @55cd

        lda     #1
        sta     near w7e7b95
        sta     near w7e7b97
        sta     near wSlotHDMAActive
        sta     near w7e8992
        lda     #$80
        sta     near w7e7b83
        lda     near w7e800e
        and     #$7f
        sta     near w7e800e
        lda     #12
        sta     near w7e7b8a
        stz     near w7e7b8f
        stz     near w7e7b90
        stz     near w7e7b91
        stz     near wSlotReelPos1
        stz     near wSlotReelPos2
        stz     near wSlotReelPos3
        stz     near w7e7b92
        stz     near w7e7b93
        stz     near w7e7b94
        jmp     GoToNextMenuState

; ------------------------------------------------------------------------------

; [ update menu state $35: open bushido menu ]

InitBushidoInput:
        array_label MENU_INPUT, MENU_INPUT::BUSHIDO_OPEN
@561b:  stz     near w7e7b82
        lda     #MENU_WINDOW_STATE::BUSHIDO_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::BUSHIDO
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $36: close bushido menu ]

CloseBushidoWindow:
        array_label MENU_INPUT, MENU_INPUT::BUSHIDO_CLOSE
@5628:  lda     #MENU_WINDOW_STATE::BUSHIDO_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $22: open row window ]

InitRowSelect:
        array_label MENU_INPUT, MENU_INPUT::ROW_OPEN
@5631:  lda     #MENU_WINDOW_STATE::ROW_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::ROW
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $25: open def. window ]

InitDefSelect:
        array_label MENU_INPUT, MENU_INPUT::DEF_OPEN
@563b:  lda     #MENU_WINDOW_STATE::DEF_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::DEF
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $0b: open equip window ]

OpenEquipWindow:
        array_label MENU_INPUT, MENU_INPUT::EQUIP_OPEN
@5645:  jsr     DrawEquipListText
        ldx     #$7e40
        stx     near w7e7baa
        inc     near wEnableUpdateMenuTextTiles
        lda     #MENU_WINDOW_STATE::EQUIP_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::EQUIP
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $10:  ]

        array_label MENU_INPUT, MENU_INPUT::CHAR_SELECT
@565b:  stz     near wCloseMenu
        lda     #MENU_WINDOW_STATE::CHAR_SELECT
        sta     near wMenuWindowState
        lda     #MENU_INPUT::WAIT
        sta     near wMenuInput
        rts

; ------------------------------------------------------------------------------

; [ update menu state $13: close equip window ]

CloseEquipWindow:
        array_label MENU_INPUT, MENU_INPUT::EQUIP_CLOSE
@5669:  lda     #MENU_WINDOW_STATE::EQUIP_CLOSE
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::EQUIP_CLOSE
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $26: close defend window ]

CloseDefendWindow:
        array_label MENU_INPUT, MENU_INPUT::DEF_CLOSE
@5673:  lda     #MENU_WINDOW_STATE::DEF_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $23: close row window ]

CloseRowWindow:
        array_label MENU_INPUT, MENU_INPUT::ROW_CLOSE
@567c:  lda     #MENU_WINDOW_STATE::ROW_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $0f: close command menu ]

CloseCmdWindow:
        array_label MENU_INPUT, MENU_INPUT::CMD_CLOSE
@5685:  stz     near w7e632f
        lda     #MENU_WINDOW_STATE::CMD_CLOSE
        sta     near wMenuWindowState
        lda     #MENU_WINDOW_STATE::RESET_CMD_SETTING
        sta     near wMenuWindowState+1
        lda     #MENU_INPUT_QUEUE::CHAR_SELECT
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $2f: close tools menu ]

CloseToolsWindow:
        array_label MENU_INPUT, MENU_INPUT::TOOLS_CLOSE
@5697:  lda     #MENU_WINDOW_STATE::TOOLS_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $07: stop slot window ]

        array_label MENU_INPUT, MENU_INPUT::SLOT_STOP
@56a0:  lda     #$80
        sta     near w7e7b83
        lda     #MENU_INPUT::SLOT_FADE_OUT
        sta     near wMenuInput
        lda     #MENU_INPUT::WAIT
        sta     near wMenuInput+1
        lda     #MENU_INPUT::SLOT_RESTORE_HDMA
        sta     near wMenuInput+2
        rts

; ------------------------------------------------------------------------------

; [ update menu state $34: reset hdma after closing slot ]

        array_label MENU_INPUT, MENU_INPUT::SLOT_RESTORE_HDMA
@56b5:  jsr     LoadBattleFontPal
        jsr     ClearSlotGradientPal
        lda     #MENU_INPUT::SLOT_CLOSE
        sta     near wMenuInput

; set hdma tables back to normal
        lda     #2
        sta     near w7e7b95                 ; need to update hdma #3
        sta     near w7e7b97                 ; need to update hdma #6
        stz     near wSlotHDMAActive
        lda     near w7e800e
        and     #$7f
        sta     near w7e800e
        stz     near w7e7b8a
        rts

; ------------------------------------------------------------------------------

; [ update menu state $33: close slot window ]

        array_label MENU_INPUT, MENU_INPUT::SLOT_CLOSE
@56d7:  lda     #MENU_WINDOW_STATE::SLOT_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $2c: close throw window ]

CloseThrowWindow:
        array_label MENU_INPUT, MENU_INPUT::THROW_CLOSE
@56e0:  lda     #MENU_WINDOW_STATE::THROW_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $14: close magic window ]

CloseMagicWindow:
        array_label MENU_INPUT, MENU_INPUT::MAGIC_CLOSE
@56e9:  lda     #MENU_WINDOW_STATE::MAGIC_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $12: close item window ]

CloseItemWindow:
        array_label MENU_INPUT, MENU_INPUT::ITEM_CLOSE
@56f2:  lda     #MENU_WINDOW_STATE::ITEM_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $1a: close lore window ]

CloseLoreWindow:
        array_label MENU_INPUT, MENU_INPUT::LORE_CLOSE
@56fb:  lda     #MENU_WINDOW_STATE::LORE_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $1d: close rage window ]

CloseRageWindow:
        array_label MENU_INPUT, MENU_INPUT::RAGE_CLOSE
@5704:  lda     #MENU_WINDOW_STATE::RAGE_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $20: close dance window ]

CloseDanceWindow:
        array_label MENU_INPUT, MENU_INPUT::DANCE_CLOSE
@570d:  lda     #MENU_WINDOW_STATE::DANCE_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $29: close magitek window ]

CloseMagitekWindow:
        array_label MENU_INPUT, MENU_INPUT::MAGITEK_CLOSE
@5716:  lda     #MENU_WINDOW_STATE::MAGITEK_CLOSE
        sta     near wMenuWindowState
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $15: close summon window ]

CloseSummonWindow:
        array_label MENU_INPUT, MENU_INPUT::SUMMON_CLOSE
@571f:  lda     #MENU_WINDOW_STATE::SUMMON_CLOSE
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::MAGIC
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [  ]

_c15729:
set_scr_vram_poi:
@5729:  lda     near w7e7ba5
        and     #$03
        asl
        tax
        lda     f:_c18291,x
        sta     near w7e7baa
        lda     f:_c18291+1,x
        sta     near w7e7baa+1
        inc     near wEnableUpdateMenuTextTiles
        inc     near w7e7ba6
        inc     near w7e7ba5
        lda     near w7e7ba5
        cmp     #$84
        bne     @5753
        stz     near w7e7ba5
        sec
        rts
@5753:  clc
        rts

; ------------------------------------------------------------------------------

; [ update menu state $3b: open dialogue window ]

        array_label MENU_INPUT, MENU_INPUT::DLG_OPEN
@5755:  lda     #MENU_WINDOW_STATE::DLG_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::DLG
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $3c:  ]

        array_label MENU_INPUT, MENU_INPUT::DLG_CLOSE
@575f:  lda     #MENU_WINDOW_STATE::DLG_CLOSE
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::DLG
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ update menu state $09: open item window ]

InitItemSelect:
        array_label MENU_INPUT, MENU_INPUT::ITEM_OPEN
@5769:  stz     near w7e7b02
        stz     near w7e890c
        lda     #MENU_INPUT::ITEM_OPEN
        sta     near wMenuInput
        lda     near w7e7ba5
        bmi     @578a
        jsr     _c15a17
        ldx     near w7e62ca
        lda     near w7e8947,x
        sta     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@578a:  lda     near w7e7ba6
        jsr     DrawItemListText
        jsr     _c15729
        bcc     @579f
        lda     #MENU_WINDOW_STATE::ITEM_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::ITEM
        jmp     LoadMenuInputQueue
@579f:  rts

; ------------------------------------------------------------------------------

; [ update menu state $0d: open magic window ]

InitMagicSelect:
        array_label MENU_INPUT, MENU_INPUT::MAGIC_OPEN
@57a0:  lda     #MENU_INPUT::MAGIC_OPEN
        sta     near wMenuInput
        lda     near w7e7ba5
        bmi     @57c4
        jsr     _c18414
        lda     near wSpellListMagic::MPCost,x
        sta     near w7e6178
        jsr     _c15a17
        ldx     near w7e62ca
        lda     near w7e8913,x
        sta     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@57c4:  lda     near w7e7ba6
        jsr     DrawMagicListText
        jsr     _c15729
        bcc     @57d9
        lda     #MENU_WINDOW_STATE::MAGIC_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::MAGIC
        jmp     LoadMenuInputQueue
@57d9:  rts

; ------------------------------------------------------------------------------

.enum MAKE_THROW_LIST
        COUNT = 5
.endenum

MakeThrowListTbl:
        ptr_tbl MAKE_THROW_LIST

.enum MAKE_TOOLS_LIST
        COUNT = 5
.endenum

MakeToolsListTbl:
        ptr_tbl MAKE_TOOLS_LIST

; ------------------------------------------------------------------------------

; [ generate item buffer by filtering inventory ]

_c157ee:
set_buf_item:
@57ee:  stx     $36
        lda     near w7e7ba4
        sta     $38
        lda     near w7e7ba3
        sta     $39
        ldx     near w7e7b9f
        ldy     near w7e7ba1
@5800:  lda     near wItemList::UsageFlags,y
        and     $38
        beq     @581c
        lda     near wItemList::ItemID,y
        sta     near wToolsThrowItemList::ItemID,x
        lda     near wItemList::Qty,y
        sta     near wToolsThrowItemList::Qty,x
        lda     near wItemList::Targeting,y
        sta     near wToolsThrowItemList::Targeting,x
        inx3
@581c:  inc     $39         ; next item
        iny5
        cpy     $36
        bne     @5800
        stx     near w7e7b9f
        sty     near w7e7ba1
        inc     near w7e7b9e
        lda     $39
        sta     near w7e7ba3
        rts

; ------------------------------------------------------------------------------

; [ generate item list for tools and throw ]

; check items 0-63
        array_label MAKE_TOOLS_LIST, 0
@5836:  lda     #$40        ; tools flag
        bra     _583c

        array_label MAKE_THROW_LIST, 0
@583a:  lda     #$20        ; throw flag
_583c:  sta     near w7e7ba4
        clr_ax
        stx     near w7e7b9f       ; reset item buffer
        stx     near w7e7ba1
        stz     near w7e7ba3
        ldx     #$0140
        jmp     _c157ee

; check items 64-127
        array_label MAKE_TOOLS_LIST, 1
        array_label MAKE_THROW_LIST, 1
@5850:  ldx     #$0280
        jmp     _c157ee

; check items 128-191
        array_label MAKE_TOOLS_LIST, 2
        array_label MAKE_THROW_LIST, 2
@5856:  ldx     #$03c0
        jmp     _c157ee

; check items 192-255
        array_label MAKE_TOOLS_LIST, 3
        array_label MAKE_THROW_LIST, 3
@585c:  ldx     #$0500
        jsr     _c157ee
        lda     #ITEM::EMPTY
@5864:  cpx     #$0300      ; trim item buffer to 256 items
        beq     @5874
        sta     near wToolsThrowItemList::ItemID,x
        stz     near wToolsThrowItemList::Qty,x
        inx3
        bra     @5864
@5874:  rts

; ------------------------------------------------------------------------------

; [ update menu state $2b: open throw window ]

InitThrowSelect:
        array_label MENU_INPUT, MENU_INPUT::THROW_OPEN
@5875:  lda     #MENU_INPUT::THROW_OPEN
        sta     near wMenuInput
        lda     near w7e7b9e
        asl
        tax
        jmp     (near MakeThrowListTbl,x)

; ------------------------------------------------------------------------------

; [  ]

        array_label MAKE_THROW_LIST, 4
@5882:  lda     near w7e7ba5
        bmi     @5898
        jsr     _c15a17
        ldx     near w7e62ca
        lda     near w7e8953,x
        sta     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@5898:  lda     near w7e7ba6
        jsr     DrawThrowListText
        jsr     _c15729
        bcc     @58b0
        stz     near w7e7b9e
        lda     #MENU_WINDOW_STATE::THROW_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::THROW
        jmp     LoadMenuInputQueue
@58b0:  rts

; ------------------------------------------------------------------------------

; [ update menu state $2e: open tools window ]

InitToolsSelect:
        array_label MENU_INPUT, MENU_INPUT::TOOLS_OPEN
@58b1:  lda     #MENU_INPUT::TOOLS_OPEN
        sta     near wMenuInput
        lda     near w7e7b9e
        asl
        tax
        jmp     (near MakeToolsListTbl,x)

; ------------------------------------------------------------------------------

; [  ]

        array_label MAKE_TOOLS_LIST, 4
@58be:  lda     near w7e7ba5
        bmi     @58d4
        jsr     _c15a17
        ldx     near w7e62ca
        lda     near w7e895f,x
        sta     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@58d4:  lda     near w7e7ba6
        jsr     DrawToolsListText
        jsr     _c15729
        bcc     @58ec
        stz     near w7e7b9e
        lda     #MENU_WINDOW_STATE::TOOLS_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::TOOLS
        jmp     LoadMenuInputQueue
@58ec:  rts

; ------------------------------------------------------------------------------

; [ update menu state $19: open lore window ]

InitLoreSelect:
        array_label MENU_INPUT, MENU_INPUT::LORE_OPEN
@58ed:  lda     #MENU_INPUT::LORE_OPEN
        sta     near wMenuInput
        lda     near w7e7ba5
        bmi     @5911
        jsr     _c183f7
        lda     $216d,x
        sta     near w7e6178
        jsr     _c15a17
        ldx     near w7e62ca
        lda     near w7e891f,x
        sta     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@5911:  lda     near w7e7ba6
        jsr     DrawLoreListText
        jsr     _c15729
        bcc     @5926
        lda     #MENU_WINDOW_STATE::LORE_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::LORE
        jmp     LoadMenuInputQueue
@5926:  rts

; ------------------------------------------------------------------------------

; [ update menu state $1c: open rage window ]

InitRageSelect:
        array_label MENU_INPUT, MENU_INPUT::RAGE_OPEN
@5927:  lda     #MENU_INPUT::RAGE_OPEN
        sta     near wMenuInput
        lda     near w7e7ba5
        bmi     @5942
        jsr     _c15a17
        ldx     near w7e62ca
        lda     near w7e892b,x
        sta     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@5942:  lda     near w7e7ba6
        jsr     DrawRageListText
        jsr     _c15729
        bcc     @5957
        lda     #MENU_WINDOW_STATE::RAGE_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::RAGE
        jmp     LoadMenuInputQueue
@5957:  rts

; ------------------------------------------------------------------------------

; [ update menu state $1f: open dance window ]

InitDanceSelect:
        array_label MENU_INPUT, MENU_INPUT::DANCE_OPEN
@5958:  lda     #MENU_INPUT::DANCE_OPEN
        sta     near wMenuInput
        lda     near w7e7ba5
        bmi     @596d
        jsr     _c15a17
        stz     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@596d:  lda     near w7e7ba6
        jsr     DrawDanceListText
        jsr     _c15729
        bcc     @5982
        lda     #MENU_WINDOW_STATE::DANCE_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::DANCE
        jmp     LoadMenuInputQueue
@5982:  rts

; ------------------------------------------------------------------------------

; [ update menu state $28: open magitek window ]

InitMagitekSelect:
        array_label MENU_INPUT, MENU_INPUT::MAGITEK_OPEN
@5983:  lda     #MENU_INPUT::MAGITEK_OPEN
        sta     near wMenuInput
        lda     near w7e7ba5
        bmi     @5998
        jsr     _c15a17
        stz     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@5998:  lda     near w7e7ba6
        jsr     DrawMagitekListText
        jsr     _c15729
        bcc     @59ad
        lda     #MENU_WINDOW_STATE::MAGITEK_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::MAGITEK
        jmp     LoadMenuInputQueue
@59ad:  rts

; ------------------------------------------------------------------------------

; [ update menu state $06: init slot window ]

InitSlotInput:
        array_label MENU_INPUT, MENU_INPUT::SLOT_OPEN
@59ae:  jsr     ClearSlotGradientPal
        lda     #MENU_INPUT::SLOT_OPEN
        sta     near wMenuInput
        lda     near w7e7ba5
        bmi     @59c6
        jsr     _c15a17
        stz     near w7e7ba6
        lda     #$80
        sta     near w7e7ba5
@59c6:  jsr     _c15729
        bcc     @59d5
        lda     #MENU_WINDOW_STATE::SLOT_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::SLOT
        jmp     LoadMenuInputQueue
@59d5:  rts

; ------------------------------------------------------------------------------

; [ update menu state $04: open command window ]

        array_label MENU_INPUT, MENU_INPUT::CMD_OPEN
@59d6:  lda     f:$001d4e               ; cursor setting
        and     #$40
        bne     @59e9
        clr_ax
@59e0:  stz     near w7e890f,x                 ; clear saved cursor settings
        inx
        cpx     #$005c
        bne     @59e0
@59e9:  lda     #$01
        sta     near w7e632f
        lda     #MENU_WINDOW_STATE::GET_CMD_SETTING
        sta     near wMenuWindowState
        lda     #MENU_WINDOW_STATE::CMD_OPEN
        sta     near wMenuWindowState+1
        lda     #MENU_WINDOW_STATE::MENU_WINDOW_STATE_31
        sta     near wMenuWindowState+2
        clr_a   ; #MENU_INPUT_QUEUE::CMD
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [ open summon window ]

OpenSummonWindow:
@5a01:  jsr     DrawSummonMagicListText
        ldx     #$7b80
        stx     near w7e7baa
        inc     near wEnableUpdateMenuTextTiles
        lda     #MENU_WINDOW_STATE::SUMMON_OPEN
        sta     near wMenuWindowState
        lda     #MENU_INPUT_QUEUE::SUMMON
        jmp     LoadMenuInputQueue

; ------------------------------------------------------------------------------

; [  ]

_c15a17:
scr_line_tfr_buf_clr:
@5a17:  longa
        ldx     zZero
        lda     #$01ff
@5a1e:  sta     near w7e5e4d,x
        inx2
        cpx     #$0080
        bne     @5a1e
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load menu state queue data for opened window ]

LoadMenuInputQueue:
        asl2
        tax
        ldy     zZero
@5a31:  lda     f:MenuInputQueue,x
        sta     near wMenuInput,y
        inx
        iny
        cpy     #4
        bne     @5a31
        rts

; ------------------------------------------------------------------------------

; [ unused battle cursor menu state ]

        array_label MENU_INPUT, MENU_INPUT::NONE
        array_label MENU_INPUT, MENU_INPUT::MENU_INPUT_3
        array_label MENU_INPUT, MENU_INPUT::MENU_INPUT_17
@5a40:  rts

; ------------------------------------------------------------------------------

; [ update menu state $01: wait for menu window ]

        array_label MENU_INPUT, MENU_INPUT::WAIT
@5a41:  lda     near wMenuWindowState
        jeq     GoToNextMenuState
        rts

; ------------------------------------------------------------------------------

; [ update menu state $02: go to next menu state ]

GoToNextMenuState:
        array_label MENU_INPUT, MENU_INPUT::NEXT_STATE
@5a4a:  clr_ax
        sta     near wMenuInput+7
@5a4f:  lda     near wMenuInput+1,x
        sta     near wMenuInput,x
        inx
        cpx     #7
        bne     @5a4f
        rts

; ------------------------------------------------------------------------------

; [ update menu text ]

_c15a5c:
main_window_open:
@5a5c:  lda     near w7e7bdd
        beq     @5ad0
        lda     near wEnableUpdateMenuWindowTiles
        bne     @5ad0
        lda     near w7e7bee
        bne     @5acd
        lda     near w7e7beb
        bne     @5a81
        inc     near w7e7beb
        longa
        ldx     near w7e7be9
        ldy     #near w7e55d5
        lda     near w7e7bec
        mvn     #$7e,#$7e
@5a81:  longa
        lda     near w7e7bde
        tax
        sec
        sbc     #$0010
        sta     near w7e7bde
        lda     near w7e7be0
        tay
        sec
        sbc     #$0010
        sta     near w7e7be0
        lda     #$000f
        mvn     #$7e,#$7e
        ldx     near w7e7be2
        ldy     near w7e7be4
        lda     #$000f
        mvn     #$7e,#$7e
        stx     near w7e7be2
        sty     near w7e7be4
        shorta0
        dec     near w7e7be6
        bne     @5acd
        stz     near w7e7bdd
        longa
        ldx     #near w7e55d5
        ldy     near w7e7be7
        lda     near w7e7bec
        mvn     #$7e,#$7e
        shorta0
@5acd:  stz     near w7e7bee
@5ad0:  rts

; ------------------------------------------------------------------------------

; [  ]

; copies bg scroll values from buffer to 4 successive scanlines at top and
; bottom of window, so we get 8 new scanlines per frame

_c15ad1:
one_back_buffer_set:
@5ad1:  lda     near wIsBG1MenuWindowUpdate
        bne     @5af5

; bg2
        lda     near w7e7bd2
        sta     near wBG2ScrollData::_0::Horz,x
        sta     near wBG2ScrollData::_1::Horz,x
        sta     near wBG2ScrollData::_2::Horz,x
        sta     near wBG2ScrollData::_3::Horz,x
        lda     near w7e7bd4
        sta     near wBG2ScrollData::_0::Vert,x
        sta     near wBG2ScrollData::_1::Vert,x
        sta     near wBG2ScrollData::_2::Vert,x
        sta     near wBG2ScrollData::_3::Vert,x
        rts

; bg1
@5af5:  lda     near w7e7bd2
        sta     near wBG1ScrollData::_0::Horz,x
        sta     near wBG1ScrollData::_1::Horz,x
        sta     near wBG1ScrollData::_2::Horz,x
        sta     near wBG1ScrollData::_3::Horz,x
        lda     near w7e7bd4
        sta     near wBG1ScrollData::_0::Vert,x
        sta     near wBG1ScrollData::_1::Vert,x
        sta     near wBG1ScrollData::_2::Vert,x
        sta     near wBG1ScrollData::_3::Vert,x
        rts

; ------------------------------------------------------------------------------

; [ update menu window opening ]

_c15b14:
back_window_open:
@5b14:  lda     near w7e7bd1
        beq     @5b4b
        lda     near wEnableUpdateMenuWindowTiles
        bne     @5b4b
        longa
        ldx     near w7e7bd7
        jsr     _c15ad1
        ldx     near w7e7bd9
        jsr     _c15ad1
        lda     near w7e7bd7
        sec
        sbc     #$0010
        sta     near w7e7bd7
        lda     near w7e7bd9
        clc
        adc     #$0010
        sta     near w7e7bd9
        shorta0
        dec     near w7e7bd6
        bne     @5b4b
        stz     near w7e7bd1
@5b4b:  rts

; ------------------------------------------------------------------------------

; [ update menu state $3e: scroll dialogue window ]

        array_label MENU_INPUT, MENU_INPUT::DLG_SCROLL
@5b4c:  lda     near w7e7baf
        beq     @5b62
        lda     near w7e7ba8
        cmp     #$01
        beq     @5b62
        ldx     near w7e7bb1
        dex4
        stx     near w7e7bb1
@5b62:  shorti
        clr_ax
        longa
        lda     #$0100      ; nonzero dp
        pha
        pld
        lda     <$0102,x
        sta     near w7e7afe
@5b72:  lda     $12,x
        clc
        adc     #$0004
        sta     <$0102,x
        sta     <$0106,x
        sta     <$010a,x
        sta     <$010e,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$f0
        bne     @5b72
        lda     near w7e7afe
        sec
        sbc     #$003c
        jmp     _5d5c

; ------------------------------------------------------------------------------

; [ fast scroll up (holding R) ]

_c15b94:
@5b94:  dec     near w7e7ba8
        dec     near w7e7ba8
        dec     near w7e7ba8
        lda     near w7e7baf
        beq     @5bae
        longa
        lda     near w7e7bb1
        clc
        adc     #8
        sta     near w7e7bb1
@5bae:  shorti
        ldx     #$90
        longa
        lda     #$0100      ; nonzero dp
        pha
        pld
        lda     <$0132,x
        sta     near w7e7afe
@5bbe:  lda     <$0102,x
        sec
        sbc     #$000c
        sta     <$015e,x
        sta     <$015a,x
        sta     <$0156,x
        sta     <$0152,x
        sta     <$014e,x
        sta     <$014a,x
        sta     <$0146,x
        sta     <$0142,x
        sta     <$013e,x
        sta     <$013a,x
        sta     <$0136,x
        sta     <$0132,x
        txa
        sec
        sbc     #$0030
        tax
        cpx     #$d0
        bne     @5bbe
        ldx     #$00
        lda     near w7e7afe
        clc
        adc     #$0030
        bra     _5c4a

; ------------------------------------------------------------------------------

; [ fast scroll down (holding R) ]

_c15bf1:
@5bf1:  dec     near w7e7ba8
        dec     near w7e7ba8
        dec     near w7e7ba8
        lda     near w7e7baf
        beq     @5c0b
        longa
        lda     near w7e7bb1
        sec
        sbc     #8
        sta     near w7e7bb1
@5c0b:  shorti
        clr_ax
        longa
        lda     #$0100      ; nonzero dp
        pha
        pld
        lda     <$0102,x
        sta     near w7e7afe
@5c1b:  lda     <$0132,x
        clc
        adc     #$000c
        sta     <$0102,x
        sta     <$0106,x
        sta     <$010a,x
        sta     <$010e,x
        sta     <$0112,x
        sta     <$0116,x
        sta     <$011a,x
        sta     <$011e,x
        sta     <$0122,x
        sta     <$0126,x
        sta     <$012a,x
        sta     <$012e,x
        txa
        clc
        adc     #$0030
        tax
        cpx     #$c0
        bne     @5c1b
        lda     near w7e7afe
        sec
        sbc     #$0030
_5c4a:  sta     <$0102,x
        sta     <$0106,x
        sta     <$010a,x
        sta     <$010e,x
        sta     <$0112,x
        sta     <$0116,x
        sta     <$011a,x
        sta     <$011e,x
        sta     <$0122,x
        sta     <$0126,x
        sta     <$012a,x
        sta     <$012e,x
        ldx     #$00
@5c64:  lda     <$0102,x
        sta     near wBG3ScrollData::_163::Vert,x
        lda     <$0106,x
        sta     near wBG3ScrollData::_164::Vert,x
        lda     <$010a,x
        sta     near wBG3ScrollData::_165::Vert,x
        lda     <$010e,x
        sta     near wBG3ScrollData::_166::Vert,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$c0
        bne     @5c64
        lda     #BTLGFX_ZP_START
        pha
        pld
        shorta
        longi
        jsr     GoToNextMenuState
        jmp     UpdateMenuInput

; ------------------------------------------------------------------------------

; [ update menu state $17: scroll menu down ]

        array_label MENU_INPUT, MENU_INPUT::SCROLL_DOWN
@5c91:  lda     z06
        and     #JOY_R
        beq     @5caf
        lda     near w7e7ba8
        cmp     #$03
        bne     @5caf
        lda     z0a + 1
        and     #>JOY_DIR_MASK
        sta     $36
        lda     z04 + 1
        and     #>~JOY_DIR_MASK
        ora     $36
        sta     z04 + 1
        jmp     _c15bf1
@5caf:  lda     near w7e7baf
        beq     @5cc5
        lda     near w7e7ba8
        cmp     #$01
        beq     @5cc5
        ldx     near w7e7bb1
        dex4
        stx     near w7e7bb1
@5cc5:  shorti
        clr_ax
        longa
        lda     #$0100      ; nonzero dp
        pha
        pld
        lda     <$0102,x
        sta     near w7e7afe
@5cd5:  lda     <$0112,x
        clc
        adc     #$0004
        sta     <$0102,x
        sta     <$0106,x
        sta     <$010a,x
        sta     <$010e,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$e0
        bne     @5cd5
        lda     near w7e7afe
        sec
        sbc     #$0038
        jmp     _5d5c
        .a8
        .i16

; ------------------------------------------------------------------------------

; [ update menu state $18: scroll menu up ]

        array_label MENU_INPUT, MENU_INPUT::SCROLL_UP
@5cf7:  lda     z06
        and     #JOY_R
        beq     @5d15
        lda     near w7e7ba8
        cmp     #$03
        bne     @5d15
        lda     z0a + 1
        and     #>JOY_DIR_MASK
        sta     $36
        lda     z04 + 1
        and     #>~JOY_DIR_MASK
        ora     $36
        sta     z04 + 1
        jmp     _c15b94
@5d15:  lda     near w7e7baf
        beq     @5d2b
        lda     near w7e7ba8
        cmp     #$01
        beq     @5d2b
        ldx     near w7e7bb1
        inx4
        stx     near w7e7bb1
@5d2b:  shorti
        ldx     #$dc
        longa
        lda     #$0100      ; nonzero dp
        pha
        pld
        lda     <$0106,x
        sta     near w7e7afe
@5d3b:  lda     <$0102,x
        sec
        sbc     #$0004
        sta     <$0112,x
        sta     <$010e,x
        sta     <$010a,x
        sta     <$0106,x
        txa
        sec
        sbc     #$0010
        tax
        cpx     #$fc
        bne     @5d3b
        ldx     #$00
        lda     near w7e7afe
        clc
        adc     #$0038
_5d5c:  sta     <$010e,x
        sta     <$010a,x
        sta     <$0106,x
        sta     <$0102,x
        ldx     #$00
@5d66:  lda     <$0102,x
        sta     near wBG3ScrollData::_163::Vert,x
        lda     <$0106,x
        sta     near wBG3ScrollData::_164::Vert,x
        lda     <$010a,x
        sta     near wBG3ScrollData::_165::Vert,x
        lda     <$010e,x
        sta     near wBG3ScrollData::_166::Vert,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$c0
        bne     @5d66
        lda     #BTLGFX_ZP_START
        pha
        pld
        shorta
        longi
        dec     near w7e7ba8
        bne     @5d98
        jsr     GoToNextMenuState
        jmp     UpdateMenuInput
@5d98:  rts

; ------------------------------------------------------------------------------

; [ copy menu text tile data to vram ]

UpdateMenuTextTiles:
@5d99:  lda     near wEnableUpdateMenuTextTiles       ;
        beq     @5db1
        ldx     #$0080      ; size = #$80
        stx     $36
        ldy     near w7e7baa       ; vram destination
        ldx     #near w7e5e4d
        lda     #^w7e5e4d
        jsr     TfrVRAM
        stz     near wEnableUpdateMenuTextTiles
@5db1:  lda     near w7e6285       ;
        bmi     @5dba
        jsl     TfrCharText
@5dba:  rts

; ------------------------------------------------------------------------------

; [ clear large font graphics buffer ]

ClearLargeTextGfxBuf:
@5dbb:  longa
        clr_ax
@5dbf:  sta     near wLargeTextGfxBuf,x
        sta     near wLargeTextGfxBuf+$0100,x
        sta     near wLargeTextGfxBuf+$0200,x
        sta     near wLargeTextGfxBuf+$0300,x
        inx2
        cpx     #$0100
        bne     @5dbf
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw large font text ]

DrawLargeText:
@5dd5:  stz     near w7ee9f5
        stz     z7a
        ldx     near w7e88d7
        stx     zDlgTextPtr
        lda     near w7e88d9
        sta     zDlgTextPtr_B
        stz     zUseAltDlgColor
@5de6:  lda     [zDlgTextPtr]
        beq     @5dfe
        cmp     #$20
        bcc     @5df6
        jsr     DrawLargeTextLetter
        jsr     IncTextPtr
        bra     @5de6
@5df6:  jsr     DlgTextCmd
        jsr     IncTextPtr
        bra     @5de6
@5dfe:  jsr     WaitLargeTextTfr
        rts

; ------------------------------------------------------------------------------

; [ wait for dialogue transfer to VRAM ]

WaitLargeTextTfr:
@5e02:  ldx     zDlgTextPtr
        phx
        ldx     zDlgTextPtr_B
        phx
        lda     z7a
        pha
        clr_a
        jsr     WaitA       ; wait 0 frames
        jsr     TfrLargeTextGfx
        pla
        sta     z7a
        plx
        stx     zDlgTextPtr_B
        plx
        stx     zDlgTextPtr
        rts

; ------------------------------------------------------------------------------

; [ wait for dialogue text to scroll ]

WaitDlgScroll:
@5e1c:  ldx     zDlgTextPtr
        phx
        ldx     zDlgTextPtr_B
        phx
        lda     z7a
        pha
        jsr     WaitFrame
        pla
        sta     z7a
        plx
        stx     zDlgTextPtr_B
        plx
        stx     zDlgTextPtr
        rts

; ------------------------------------------------------------------------------

; [ pause during dialogue display ]

WaitDlg:
@5e32:  sta     $22
        ldx     zDlgTextPtr
        phx
        ldx     zDlgTextPtr_B
        phx
        lda     z7a
        pha
        lda     $22
        jsr     WaitA
        jsr     TfrLargeTextGfx
        pla
        sta     z7a
        plx
        stx     zDlgTextPtr_B
        plx
        stx     zDlgTextPtr
        rts

; ------------------------------------------------------------------------------

; [ write message text special string ]

DlgTextCmd:
@5e4f:  asl
        tax
        jmp     (near DlgTextCmdTbl,x)

; ------------------------------------------------------------------------------

; dialog text special string jump table
DlgTextCmdTbl:
@5e54:  .addr   TextCmdUnused
        .addr   DlgTextCmd_01
        .addr   DlgTextCmd_02
        .addr   TextCmdUnused
        .addr   DlgTextCmd_04
        .addr   DlgTextCmd_05
        .addr   DlgTextCmd_06
        .addr   DlgTextCmd_07
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   DlgTextCmd_0c
        .addr   TextCmdUnused
        .addr   DlgTextCmd_0e
        .addr   DlgTextCmd_0f
        .addr   DlgTextCmd_10
        .addr   DlgTextCmd_11
        .addr   DlgTextCmd_12
        .addr   DlgTextCmd_13
        .addr   DlgTextCmd_14
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   DlgTextCmd_1c
        .addr   DlgTextCmd_1d
        .addr   DlgTextCmd_1e
        .addr   DlgTextCmd_1f

; ------------------------------------------------------------------------------

; [ dialog special string $07: wait for keypress ]

DlgTextCmd_07:
@5e94:  inc     near w7ee9f5
        jsr     WaitLargeTextTfr
        lda     z04
        bpl     @5e94
        rts

; ------------------------------------------------------------------------------

; [ dialog special string $06: wait ]

; b0: number of frames to wait

DlgTextCmd_06:
@5e9f:  jsr     IncTextPtr
        lda     [zDlgTextPtr]
        jmp     WaitDlg

; ------------------------------------------------------------------------------

; [ dialog special string $05: wait 60 frames ]

DlgTextCmd_05:
@5ea7:  lda     #60
        jmp     WaitDlg

; ------------------------------------------------------------------------------

; [ dialog special string $02: character name ]

; b0: character name

DlgTextCmd_02:
@5eac:  jsr     IncTextPtr
        lda     [zDlgTextPtr]
        sta     $22
        clr_ax
@5eb5:  lda     f:$001600,x
        cmp     $22
        beq     @5ecf
        longa
        txa
        clc
        adc     #$0025
        tax
        shorta0
        cpx     #$0250
        beq     @5ee5
        bra     @5eb5
@5ecf:  lda     #$06
        sta     near w7e616d       ; 6 letter string length
@5ed4:  lda     f:$001602,x
        cmp     #$ff
        beq     @5ee5
        jsr     DrawLargeTextLetter
        inx
        dec     near w7e616d
        bne     @5ed4
@5ee5:  rts

; ------------------------------------------------------------------------------

; [ dialog special string $12: string from variable ]

; b0: string type

DlgTextCmd_12:
@5ee6:  jsr     IncTextPtr
        lda     [zDlgTextPtr]
        asl
        tax
        jmp     (near _c15ef0,x)

; ------------------------------------------------------------------------------

; jump table for string type
_c15ef0:
@5ef0:  .addr   _c15f40,_c15f06,_c15f00,_c15f13

; ------------------------------------------------------------------------------

; pointers to character names
CharNamePtrs:
        .addr   wCharGfxDataBuf::_0
        .addr   wCharGfxDataBuf::_1
        .addr   wCharGfxDataBuf::_2
        .addr   wCharGfxDataBuf::_3

; ------------------------------------------------------------------------------

; $02: attack name

_c15f00:
@5f00:  lda     near w7e2f35       ; variable 0
        jmp     _c15fb8       ; write attack name

; ------------------------------------------------------------------------------

; $01: item name

_c15f06:
@5f06:  lda     near w7e2f35       ; variable 0
        jmp     _c16048       ; write item name

; ------------------------------------------------------------------------------

; [ dialog special string $0c: battle command name ]

DlgTextCmd_0c:
@5f0c:  jsr     IncTextPtr
        lda     [zDlgTextPtr]
        bra     _5f16

; ------------------------------------------------------------------------------

; $03: battle command name

_c15f13:
@5f13:  lda     near w7e2f35       ; variable 0
_5f16:  cmp     #$ff
        bne     @5f1b
        rts
@5f1b:  xba
        lda     #BATTLE_CMD_NAME::ITEM_SIZE
        sta     near w7e616d
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@5f2e:  lda     f:BattleCmdName,x
        cmp     #$ff
        beq     @5f3f
        jsr     DrawLargeTextLetter
        inx
        dec     near w7e616d
        bne     @5f2e
@5f3f:  rts

; ------------------------------------------------------------------------------

; $00: character name

_c15f40:
@5f40:  lda     near w7e2f38       ; variable 1
        asl
        tax
        longa
        lda     f:CharNamePtrs,x
        tax
        shorta0
        lda     #$06
        sta     near w7e616d
@5f54:  lda     a:$0001,x
        cmp     #$ff
        beq     @5f64
        jsr     DrawLargeTextLetter
        inx
        dec     near w7e616d
        bne     @5f54
@5f64:  rts

; ------------------------------------------------------------------------------

; [ dialog special string $14: variable 3 ]

DlgTextCmd_14:
@5f65:  ldx     near w7e2f3e       ; variable 3
        lda     near w7e2f3e_B
        bra     _5f83

; ------------------------------------------------------------------------------

; [ dialog special string $13: variable 2 ]

DlgTextCmd_13:
@5f6d:  ldx     near w7e2f3b       ; variable 2
        lda     near w7e2f3b_B
        bra     _5f83

; ------------------------------------------------------------------------------

; [ dialog special string $10: variable 0 ]

DlgTextCmd_10:
@5f75:  ldx     near w7e2f35       ; variable 0
        lda     near w7e2f35_B
        bra     _5f83

; ------------------------------------------------------------------------------

; [ dialog special string $11: variable 1 ]

DlgTextCmd_11:
@5f7d:  ldx     near w7e2f38       ; variable 1
        lda     near w7e2f38_B
_5f83:  stx     $10
        sta     $12
        lda     #ZERO_CHAR
        sta     z68
        jsr     HexToDec24
        clr_ax
@5f90:  lda     z69,x
        cmp     #ZERO_CHAR
        bne     @5f9c
        inx
        cpx     #7
        bne     @5f90
@5f9c:  lda     z69,x
        jsr     DrawLargeTextLetter
        inx
        cpx     #8
        bne     @5f9c
        rts

; ------------------------------------------------------------------------------

; [  ]

_c15fa8:
@5fa8:  pha
        lda     #$ff
        jsr     DrawLargeTextLetter
        pla
        dec
        bne     @5fa8
        rts

; ------------------------------------------------------------------------------

; [ dialog special string $0f: attack name ]

DlgTextCmd_0f:
@5fb3:  jsr     IncTextPtr
        lda     [zDlgTextPtr]

_c15fb8:
@5fb8:  cmp     #$ff
        bne     @5fbd
        rts
@5fbd:  cmp     #$36
        bcc     @6019       ; branch if a spell

.if LANG_EN
        cmp     #$51
        bcc     @5fef       ; branch if an esper attack

; attack name
        sec
        sbc     #$51
        xba
        lda     #ATTACK_NAME::ITEM_SIZE
        sta     $10
        sta     near w7e616d
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@5fdd:  lda     f:AttackName,x
        cmp     #$ff
        beq     @5fee
        jsr     DrawLargeTextLetter
        inx
        dec     near w7e616d
        bne     @5fdd
@5fee:  rts

.endif

; esper name
@5fef:  sec
        sbc     #$36
        xba
        lda     #GENJU_NAME::ITEM_SIZE
        sta     $10
        sta     near w7e616d
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@6007:  lda     f:GenjuName,x
        cmp     #$ff
        beq     @6018
        jsr     DrawLargeTextLetter
        inx
        dec     near w7e616d
        bne     @6007
@6018:  rts

; spell name
@6019:  xba
        lda     #MAGIC_NAME::ITEM_SIZE
        sta     $10
        sta     near w7e616d
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
        dec     near w7e616d       ; skip symbol byte
@6031:  lda     f:MagicName+1,x   ; spell name (skips symbol byte)
        cmp     #$ff
        beq     @6042
        jsr     DrawLargeTextLetter
        inx
        dec     near w7e616d
        bne     @6031
@6042:  rts

; ------------------------------------------------------------------------------

; [ dialog special string $0e: item name ]

DlgTextCmd_0e:
@6043:  jsr     IncTextPtr
        lda     [zDlgTextPtr]

_c16048:
@6048:  cmp     #$ff
        bne     @6051
        lda     #ITEM_NAME::ITEM_SIZE
        jmp     _c15fa8
@6051:  xba
        lda     #ITEM_NAME::ITEM_SIZE
        sta     $10
        sta     near w7e616d
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
        dec     near w7e616d
@6069:  lda     f:ItemName+1,x   ; item name
        cmp     #$ff
        beq     @607a
        jsr     DrawLargeTextLetter
        inx
        dec     near w7e616d
        bne     @6069
@607a:  rts

; ------------------------------------------------------------------------------

; [ dialog special string $04: toggle text color ]

DlgTextCmd_04:
@607b:  lda     zUseAltDlgColor
        eor     #1
        sta     zUseAltDlgColor
        rts

; ------------------------------------------------------------------------------

; vram address for each line of dialogue text graphics
DlgTextGfxVRAMAddrTbl:
        .word   $5a00,$5c00,$5e00,$5800,$5800

; ------------------------------------------------------------------------------

; [ dialog special string $01: new line ]

DlgTextCmd_01:
@608c:  stz     z7a
        lda     near w7ee9c3
        bpl     @60d8

; dialogue window (bottom of screen)
        jsr     ClearLargeTextGfxBuf
        lda     near w7ee9c1
        cmp     #$04
        bne     @60a0
        stz     near w7ee9c1
@60a0:  lda     near w7ee9c1
        and     #$03
        asl
        tax
        longa
        lda     f:DlgTextGfxVRAMAddrTbl,x
        sta     near wLargeTextGfxVRAMAddr
        shorta0
        inc     near w7ee9c1
        jsr     WaitLargeTextTfr
        lda     near w7ee9c2
        cmp     #2                      ; 3 lines per page
        bne     @60d4
        lda     #$04
        sta     near w7e7ba8
        lda     #MENU_INPUT::DLG_SCROLL
        sta     near wMenuInput
@60ca:  lda     near wMenuInput
        beq     @60d7
        jsr     WaitDlgScroll
        bra     @60ca
@60d4:  inc     near w7ee9c2
@60d7:  rts

; message window (top of screen)
@60d8:  lda     #$10
@60da:  pha
        clr_ax
        longa
        lda     #$0020
        sta     $24
@60e4:  lda     #$000f
        sta     $22
@60e9:  lda     near wLargeTextGfxBuf+2,x
        sta     near wLargeTextGfxBuf,x
        inx2
        dec     $22
        bne     @60e9
        stz     near wLargeTextGfxBuf,x
        inx2
        dec     $24
        bne     @60e4
        shorta0
        jsr     WaitLargeTextTfr
        pla
        dec
        bne     @60da
        rts

; ------------------------------------------------------------------------------

_c16109:
@6109:  .word   4,3,2,1

; ------------------------------------------------------------------------------

.if !LANG_EN

DlgTextCmd_1c:
@60c7:  phy
        phx
        ldx     #$1340
        bra     _60e1

DlgTextCmd_1d:
@60ce:  phy
        phx
        ldx     #$2940
        bra     _60e1

DlgTextCmd_1e:
@60d5:  phy
        phx
        ldx     #$3f40
        bra     _60e1

DlgTextCmd_1f:
@60dc:  phy
        phx
        ldx     #$5540
_60e1:  stx     $1c
        jsr     IncTextPtr
        lda     [zDlgTextPtr]
        sta     $22
        lda     #$16
        sta     $24
        jsr     Mult8
        longa
        lda     $26
        clc
        adc     $1c
        sta     $26
        shorta0
        bra     _6122

.endif

; ------------------------------------------------------------------------------

; [ draw dialogue text letter (large font) ]

DrawLargeTextLetter:

.if LANG_EN
DlgTextCmd_1c:
DlgTextCmd_1d:
DlgTextCmd_1e:
DlgTextCmd_1f:
@6111:  sta     near w7eecf0
        sec
        sbc     #$80
.else
        sec
        sbc     #$20
.endif
        phy
        phx
        sta     $22
        lda     #$16
        sta     $24
        jsr     Mult8
_6122:  lda     zUseAltDlgColor
        jne     _c16256                 ; alt. text color
        lda     z7a
        and     #$f8
        longa
        asl2
        tay
        lda     #$000b
        sta     $1c
        lda     z7a
        and     #$0004
        jeq     @61c4
        lda     z7a
        and     #$0003
        sta     $1a
        ldx     $26
@614a:  stz     $12
        lda     $1a
        sta     $18
        bne     @6158
        lda     f:LargeFontGfx,x
        bra     @6163
@6158:  lda     f:LargeFontGfx,x
@615c:  lsr
        ror     $12
        dec     $18
        bne     @615c
@6163:  sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$28,y
        sta     near wLargeTextGfxBuf+$28,y
        lda     $22
        ora     near wLargeTextGfxBuf+$29,y
        sta     near wLargeTextGfxBuf+$29,y
        xba
        ora     near wLargeTextGfxBuf+$08,y
        sta     near wLargeTextGfxBuf+$08,y
        lda     $23
        ora     near wLargeTextGfxBuf+$09,y
        sta     near wLargeTextGfxBuf+$09,y
        lda     $13
        ora     near wLargeTextGfxBuf+$48,y
        sta     near wLargeTextGfxBuf+$48,y
        lda     $13
        ora     near wLargeTextGfxBuf+$49,y
        sta     near wLargeTextGfxBuf+$49,y
        longa
        lda     $22
        lsr
        ror     $12
        sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$2a,y
        sta     near wLargeTextGfxBuf+$2a,y
        xba
        ora     near wLargeTextGfxBuf+$0a,y
        sta     near wLargeTextGfxBuf+$0a,y
        lda     $13
        ora     near wLargeTextGfxBuf+$4a,y
        sta     near wLargeTextGfxBuf+$4a,y
        longa
        iny2
        inx2
        dec     $1c
        jne     @614a
        jmp     @622e

@61c4:  lda     z7a
        and     #$0003
        asl
        tax
        lda     f:_c16109,x
        sta     $1a
        ldx     $26
@61d3:  lda     $1a
        sta     $18
        stz     $12
        lda     f:LargeFontGfx,x
@61dd:  asl
        dec     $18
        bne     @61dd
        sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$28,y
        sta     near wLargeTextGfxBuf+$28,y
        lda     $22
        ora     near wLargeTextGfxBuf+$29,y
        sta     near wLargeTextGfxBuf+$29,y
        lda     $23
        ora     near wLargeTextGfxBuf+$08,y
        sta     near wLargeTextGfxBuf+$08,y
        lda     $23
        ora     near wLargeTextGfxBuf+$09,y
        sta     near wLargeTextGfxBuf+$09,y
        longa
        lda     $22
        lsr
        ror     $12
        sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$2a,y
        sta     near wLargeTextGfxBuf+$2a,y
        xba
        ora     near wLargeTextGfxBuf+$0a,y
        sta     near wLargeTextGfxBuf+$0a,y
        lda     $12
        ora     near wLargeTextGfxBuf+$4a,y
        sta     near wLargeTextGfxBuf+$4a,y
        longa
        iny2
        inx2
        dec     $1c
        bne     @61d3
@622e:  shorta0

.if LANG_EN
        phx
        lda     near w7eecf0
        sec
        sbc     #$60
        tax
        lda     f:FontWidth,x
        plx
        clc
        adc     z7a
.else
        lda     z7a
        clc
        adc     #13
.endif
        sta     z7a
        lda     near w7e62ac
        bne     @624b
        jsr     WaitLargeTextTfr
@624b:  plx
        ply
        rts

; ------------------------------------------------------------------------------

_c1624e:
@624e:  .byte   $00,$80,$c0,$e0,$f0,$f8,$fc,$fe

; ------------------------------------------------------------------------------

; [ draw text with alt. text color ]

_c16256:
@6256:  lda     z7a
        and     #$07
        tax
        lda     f:_c1624e,x
        sta     $28
        lda     z7a
        and     #$f8
        longa
        asl2
        tay
        lda     #$000b
        sta     $1c
        lda     z7a
        and     #$0004
        jeq     @6307
        lda     z7a
        and     #$0003
        sta     $1a
        ldx     $26
@6282:  stz     $12
        lda     $1a
        sta     $18
        bne     @6290
        lda     f:LargeFontGfx,x
        bra     @629b
@6290:  lda     f:LargeFontGfx,x
@6294:  lsr
        ror     $12
        dec     $18
        bne     @6294
@629b:  sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$29,y
        sta     near wLargeTextGfxBuf+$29,y
        and     near wLargeTextGfxBuf+$28,y
        not_a
        and     near wLargeTextGfxBuf+$28,y
        sta     near wLargeTextGfxBuf+$28,y
        xba
        ora     near wLargeTextGfxBuf+$09,y
        sta     near wLargeTextGfxBuf+$09,y
        and     near wLargeTextGfxBuf+$08,y
        not_a
        ora     $28
        and     near wLargeTextGfxBuf+$08,y
        sta     near wLargeTextGfxBuf+$08,y
        lda     $13
        ora     near wLargeTextGfxBuf+$49,y
        sta     near wLargeTextGfxBuf+$49,y
        and     near wLargeTextGfxBuf+$48,y
        not_a
        and     near wLargeTextGfxBuf+$48,y
        sta     near wLargeTextGfxBuf+$48,y
        longa
        lda     $22
        lsr
        ror     $12
        sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$2a,y
        sta     near wLargeTextGfxBuf+$2a,y
        xba
        ora     near wLargeTextGfxBuf+$0a,y
        sta     near wLargeTextGfxBuf+$0a,y
        lda     $13
        ora     near wLargeTextGfxBuf+$4a,y
        sta     near wLargeTextGfxBuf+$4a,y
        longa
        iny2
        inx2
        dec     $1c
        jne     @6282
        jmp     @637b

@6307:  lda     z7a
        and     #$0003
        asl
        tax
        lda     f:_c16109,x
        sta     $1a
        ldx     $26
@6316:  lda     $1a
        sta     $18
        stz     $12
        lda     f:LargeFontGfx,x
@6320:  asl
        dec     $18
        bne     @6320
        sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$29,y
        sta     near wLargeTextGfxBuf+$29,y
        and     near wLargeTextGfxBuf+$28,y
        not_a
        and     near wLargeTextGfxBuf+$28,y
        sta     near wLargeTextGfxBuf+$28,y
        xba
        ora     near wLargeTextGfxBuf+$09,y
        sta     near wLargeTextGfxBuf+$09,y
        and     near wLargeTextGfxBuf+$08,y
        not_a
        ora     $28
        and     near wLargeTextGfxBuf+$08,y
        sta     near wLargeTextGfxBuf+$08,y
        longa
        lda     $22
        lsr
        ror     $12
        sta     $22
        shorta
        ora     near wLargeTextGfxBuf+$2a,y
        sta     near wLargeTextGfxBuf+$2a,y
        xba
        ora     near wLargeTextGfxBuf+$0a,y
        sta     near wLargeTextGfxBuf+$0a,y
        lda     $13
        ora     near wLargeTextGfxBuf+$4a,y
        sta     near wLargeTextGfxBuf+$4a,y
        longa
        iny2
        inx2
        dec     $1c
        jne     @6316
@637b:  shorta0
.if LANG_EN
        phx
        lda     near w7eecf0
        sec
        sbc     #$60
        tax
        lda     f:FontWidth,x
        plx
        clc
        adc     z7a
.else
        lda     z7a
        clc
        adc     #13
.endif
        sta     z7a
        lda     near w7e62ac
        bne     @6398
        jsr     WaitLargeTextTfr
@6398:  plx
        ply
        rts

; ------------------------------------------------------------------------------

; [ transfer large font graphics to vram ]

TfrLargeTextGfx:
@639b:  ldx     #wLargeTextGfxBuf::SIZE
        stx     $10
        ldx     #near wLargeTextGfxBuf
        lda     #^wLargeTextGfxBuf
        ldy     near wLargeTextGfxVRAMAddr       ; destination (vram)
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ write menu list text ]

DrawListText:
@63ab:  lda     near w7e88e2
        sta     z55 + 1
        sta     z57 + 1
        sta     z59 + 1
        xba
        asl     near w7e88e1
        stz     $2d
        ldx     near w7e88dd
        stx     z4f
        ldx     near w7e88df
        stx     z51
        lda     z51
        clc
        adc     near w7e88e1
        sta     z53
        lda     z51 + 1
        adc     #0
        sta     z53 + 1
        ldy     zZero
@63d4:  lda     (z4f)
        beq     @63f4
        cmp     #$20
        bcc     @63e8
        jsr     DrawListLetter
        inc     z4f
        bne     @63d4
        inc     z4f + 1
        jmp     @63d4
@63e8:  jsr     ListTextCmd
        inc     z4f
        bne     @63d4
        inc     z4f + 1
        jmp     @63d4
@63f4:  clr_a
        xba
        rts

; ------------------------------------------------------------------------------

; [ increment pointer to list text ]

IncListTextPtr:
@63f7:  inc     z4f
        bne     @63fd
        inc     z4f + 1
@63fd:  rts

; ------------------------------------------------------------------------------

; [ draw one letter (menu list) ]

.if LANG_EN

DrawListLetter:
DrawListKana:

@63fe:  longa
        sta     (z53),y     ; tile id
        lda     z55
        sta     (z51),y
        shorta
        iny2
        rts

.else

DrawListLetter:
@63d3:  cmp     #$53
        bcc     _63e4

DrawListKana:
@63d7:  longa
        sta     (z53),y
        lda     z55
        sta     (z51),y
        shorta
        iny2
        rts
_63e4:  cmp     #$49
        bcc     @63f8
        clc
        adc     #$17
        longa
        sta     (z53),y
        lda     z59
        sta     (z51),y
        shorta
        iny2
        rts
@63f8:  clc
        adc     #$40
        longa
        sta     (z53),y
        lda     z57
        sta     (z51),y
        shorta
        iny
        iny
        rts

.endif

; ------------------------------------------------------------------------------

; [ write menu list text special string ]

ListTextCmd:
@640b:  sta     $2c
        asl     $2c
        ldx     $2c
        jmp     (near ListTextCmdTbl,x)

; ------------------------------------------------------------------------------

; menu list text special string jump table
ListTextCmdTbl:
@6414:  .addr   TextCmdUnused
        .addr   ListTextCmd_01
        .addr   ListTextCmd_02
        .addr   ListTextCmd_03
        .addr   ListTextCmd_04
        .addr   ListTextCmd_05
        .addr   ListTextCmd_06
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   ListTextCmd_0e
        .addr   ListTextCmd_0f
        .addr   TextCmdUnused
        .addr   ListTextCmd_11
        .addr   ListTextCmd_12
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   ListTextCmd_16
        .addr   ListTextCmd_17
        .addr   ListTextCmd_18
        .addr   ListTextCmd_19
        .addr   ListTextCmd_1a

; ------------------------------------------------------------------------------

; [ list text command $16: draw number ]

ListTextCmd_16:
@644a:  jsr     IncListTextPtr
        stz     $40
        stz     $41
        lda     (z4f)
@6453:  sec
        sbc     #100
        bcc     @645c
        inc     $40
        bra     @6453
@645c:  clc
        adc     #100
@645f:  sec
        sbc     #10
        bcc     @6468
        inc     $41
        bra     @645f
@6468:  clc
        adc     #10
        pha
        lda     $40
        bne     @6472
        lda     #$ff^ZERO_CHAR
@6472:  clc
        adc     #ZERO_CHAR
        jsr     DrawListKana
        lda     $41
        ora     $40
        bne     @6485
        lda     #$ff
        jsr     DrawListKana
        bra     @648d
@6485:  lda     $41
        clc
        adc     #ZERO_CHAR
        jsr     DrawListKana
@648d:  pla
        clc
        adc     #ZERO_CHAR
        jmp     DrawListKana

; ------------------------------------------------------------------------------

; [ menu list text special string $02: number ]

ListTextCmd_02:
@6494:  jsr     IncListTextPtr
        stz     $40                     ; tens digit
        lda     (z4f)
@649b:  sec
        sbc     #$0a
        bcc     @64a5
        inc     $40
        jmp     @649b
@64a5:  clc
        adc     #$0a
        sta     $41                     ; ones digit
        lda     $40
        bne     @64b0
        lda     #$ff^ZERO_CHAR
@64b0:  clc
        adc     #ZERO_CHAR
        jsr     DrawListKana
        lda     $41
        ora     $40
        bne     @64c1
        lda     #$ff
        jmp     DrawListKana
@64c1:  lda     $41
        clc
        adc     #ZERO_CHAR
        jmp     DrawListKana

; ------------------------------------------------------------------------------

ListTextCmd_03:
@64c9:  jsr     IncListTextPtr
        lda     (z4f)
        jmp     DrawListKana

; ------------------------------------------------------------------------------

; [ list text command $04: change text color ]

ListTextCmd_04:
@64d1:  jsr     IncListTextPtr
        lda     (z4f)
        sta     z55 + 1
        sta     z57 + 1
        sta     z59 + 1
        xba
        rts

; ------------------------------------------------------------------------------

; [ list text command $05: draw spaces ]

ListTextCmd_05:
@64de:  jsr     IncListTextPtr
        lda     (z4f)
        sta     $40
@64e5:  lda     #$ff
        jsr     DrawListKana
        dec     $40
        bne     @64e5
        rts

; ------------------------------------------------------------------------------

; [ menu list text special string $06: magitek attack name ]

ListTextCmd_06:
@64ef:  jsr     IncListTextPtr
        lda     (z4f)
        cmp     #$ff
        bne     @64fd
        lda     #ATTACK_NAME::ITEM_SIZE
        jmp     DrawBlankListItem
@64fd:  sta     $2c
        lda     #ATTACK_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@650a:  lda     f:AttackName + array_item ATTACK_NAME, 50,x   ; magitek attack name
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @650a
        rts

; ------------------------------------------------------------------------------

; [ menu list text special string $12: item symbol name ]

.ifndef ITEM_SYMBOL_NAME_INC

ListTextCmd_12 := TextCmdUnused

.else

ListTextCmd_12:
@6517:  jsr     IncListTextPtr
        lda     (z4f)
        cmp     #$ff
        bne     @6525
@6520:
.if LANG_EN
        lda     #7  ; *** bug ***
.else
        lda     #ITEM_NAME::ITEM_SIZE
.endif
        jmp     DrawBlankListItem
@6525:  sta     $2c
        lda     #ITEM_NAME::ITEM_SIZE
        sta     $2e
        jsr     Mult8NoHW
        ldx     $30
        lda     f:ItemName,x   ; item name
        cmp     #$ff
        beq     @6520
        sec
        sbc     #$d8
        sta     $2c
        lda     #ITEM_SYMBOL_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
        lda     z55 + 1
        xba
@654b:  lda     f:ItemSymbolName,x
        jsr     DrawListKana
        inx
        dec     $40
        bne     @654b
        rts

.endif

; ------------------------------------------------------------------------------

; [ menu list text special string $0e: item name ]

ListTextCmd_0e:
@6558:  jsr     IncListTextPtr
        lda     (z4f)
        cmp     #$ff
        bne     @6566
        lda     #ITEM_NAME::ITEM_SIZE
        jmp     DrawBlankListItem
@6566:

.if LANG_EN
        sta     $2c
        lda     #ITEM_NAME::ITEM_SIZE
        sta     $2e
        jsr     Mult8NoHW
        ldx     $30
.else
        sta     $2c
        longa
        lda     $2c
        asl3
        clc
        adc     $2c
        tax
        shorta
.endif
        lda     z55 + 1
        xba
        lda     #ITEM_NAME::ITEM_SIZE
        sta     $40
@6578:  lda     f:ItemName,x   ; item name
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @6578
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

ListTextCmd_11:
@6585:  jsr     ListTextCmd_0f          ; attack name
        lda     (z4f)
        cmp     #$ff
        beq     @6593
        cmp     #ATTACK::FIRST_GENJU
        bcc     @6593
        rts
@6593:  lda     #3
        jmp     DrawBlankListItem

.else

        ListTextCmd_11 := TextCmdUnused

; inaccessible code
@6545:  jsr     IncListTextPtr
        lda     (z4f)
        cmp     #$ff
        bne     @6553
        lda     #9
        jmp     DrawBlankListItem
@6553:  cmp     #ATTACK::FIRST_GENJU
        bcc     @6582
        sec
        sbc     #ATTACK::FIRST_GENJU
        sta     $2c
        longa
        lda     $2c
        and     #$00ff
        asl3
        tax
        shorta
        lda     z55 + 1
        xba
        lda     #GENJU_NAME::ITEM_SIZE
        sta     $40
@6570:  lda     f:GenjuName,x
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @6570
        lda     #$ff
        jsr     DrawListLetter
        rts
@6582:  longa
        and     #$00ff
        sta     $2e
        asl2
        clc
        adc     $2e
        tax
        shorta0
        lda     z55 + 1
        xba
        lda     #MAGIC_NAME::ITEM_SIZE
        sta     $40
@6599:  lda     f:MagicName,x
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @6599
        lda     #$ff
        jsr     DrawListLetter
        lda     #$ff
        jsr     DrawListLetter
        lda     #$ff
        jsr     DrawListLetter
        lda     #$ff
        jmp     DrawListLetter

.endif

; ------------------------------------------------------------------------------

; [ menu list text special string $0f: attack name ]

ListTextCmd_0f:
@6598:  jsr     IncListTextPtr
        lda     (z4f)
        sta     $2c
        cmp     #$ff
        bne     @65a8
        lda     #MAGIC_NAME::ITEM_SIZE
        jmp     DrawBlankListItem
@65a8:  cmp     #ATTACK::FIRST_GENJU
        bcc     @65e8
.if LANG_EN

; draw attack name
        cmp     #ATTACK::FIRST_NINJA
        bcc     @65cc
        sec
        sbc     #ATTACK::FIRST_NINJA
        xba
        lda     #ATTACK_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@65bf:  lda     f:AttackName,x
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @65bf
        rts
.endif

; draw genju name
@65cc:  sec
        sbc     #$36
        xba
        lda     #GENJU_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@65db:  lda     f:GenjuName,x
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @65db
        rts

; draw magic name
@65e8:  lda     #MAGIC_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@65f3:  lda     f:MagicName,x   ; spell name
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @65f3
        rts

; ------------------------------------------------------------------------------

; [ list text command $17: dance name ]

ListTextCmd_17:
@6600:  jsr     IncListTextPtr
        lda     (z4f)
        sta     $2c
        cmp     #$ff
        bne     @6610
        lda     #DANCE_NAME::ITEM_SIZE
        jmp     DrawBlankListItem
@6610:  lda     #DANCE_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@661b:  lda     f:DanceName,x
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @661b
        rts

; ------------------------------------------------------------------------------

; [ list text command $18: monster name ]

ListTextCmd_18:
@6628:  jsr     IncListTextPtr
        lda     (z4f)
        sta     $2c
        cmp     #$ff
        bne     @6638
.if LANG_EN
        lda     #MONSTER_NAME::ITEM_SIZE + 1
.else
        lda     #MONSTER_NAME::ITEM_SIZE
.endif
        jmp     DrawBlankListItem
@6638:  lda     #MONSTER_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@6643:  lda     f:MonsterName,x
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @6643
.if LANG_EN
        lda     #$ff
        jsr     DrawListLetter
.endif
        rts

; ------------------------------------------------------------------------------

; [ list text command $19: attack name ]

ListTextCmd_19:
@6655:  jsr     IncListTextPtr
        lda     (z4f)
        sta     $2c
        cmp     #$ff
        bne     @6665
        lda     #ATTACK_NAME::ITEM_SIZE
        jmp     DrawBlankListItem
@6665:  lda     #ATTACK_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@6670:  lda     f:AttackName + array_item ATTACK_NAME, 58,x  ; lore name
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @6670
        rts

; ------------------------------------------------------------------------------

; [ list text command $1a: esper name ]

ListTextCmd_1a:
@667d:  jsr     IncListTextPtr
        lda     (z4f)
        sta     $2c
        cmp     #$ff
        bne     @668d
        lda     #GENJU_NAME::ITEM_SIZE
        jmp     DrawBlankListItem
@668d:  lda     #GENJU_NAME::ITEM_SIZE
        sta     $2e
        sta     $40
        jsr     Mult8NoHW
        ldx     $30
@6698:  lda     f:GenjuName,x
        jsr     DrawListLetter
        inx
        dec     $40
        bne     @6698
        rts

; ------------------------------------------------------------------------------

; [ draw blank list text item ]

; A: number of empty spaces

DrawBlankListItem:
@66a5:  sta     $40
@66a7:  lda     #$ff
        jsr     DrawListKana
        dec     $40
        bne     @66a7
        rts

; ------------------------------------------------------------------------------

; [ draw menu text ]

; decodes raw menu text to a tile buffer

DrawMenuText:
@66b1:  lda     near w7e88dc
        sta     z4e
        asl     near w7e88db
        ldx     near w7e88d7
        stx     z48
        ldx     near w7e88d9
        stx     z4a
        lda     z4a
        clc
        adc     near w7e88db
        sta     z4c
        lda     z4a + 1
        adc     #0
        sta     z4c + 1
        ldy     zZero
@66d3:  lda     (z48)       ; get next letter
        beq     @66eb       ; return if end of string
        cmp     #$20
        bcc     @66e3       ; branch if special string
        jsr     DrawMenuLetter
        jsr     IncTextPtr
        bra     @66d3
@66e3:  jsr     MenuTextCmd
        jsr     IncTextPtr
        bra     @66d3
@66eb:  rts

; ------------------------------------------------------------------------------

; [ increment text pointer ]

IncTextPtr:
@66ec:  inc     z48
        bne     @66f2
        inc     z48 + 1
@66f2:  rts

; ------------------------------------------------------------------------------

; [ write letter (menu text) ]

;    A: letter
; +$4a:
; +$4c:
;  $4e:

.if LANG_EN

DrawMenuLetter:
DrawMenuKana:
@66f3:  sta     (z4c),y
        lda     #$ff
        sta     (z4a),y
        iny
        lda     z4e
        sta     (z4c),y
        sta     (z4a),y
        iny
        rts

.else

DrawMenuLetter:
@66ef:  cmp     #$53
        bcc     _6702

DrawMenuKana:
        sta     (z4c),y
        lda     #$ff
_66f7:  sta     (z4a),y
        iny
        lda     z4e
        sta     (z4c),y
        sta     (z4a),y
        iny
        rts
_6702:  cmp     #$49
        bcc     @6710
        clc
        adc     #$17
        sta     (z4c),y
        lda     #$52                    ; handakuten (circle)
        jmp     _66f7
@6710:  clc
        adc     #$40
        sta     (z4c),y
        lda     #$51                    ; dakuten (dots)
        jmp     _66f7
.endif

; ------------------------------------------------------------------------------

; [ write special string (menu text) ]

MenuTextCmd:
print_code_chg:
@6702:  asl
        tax
        jmp     (near MenuTextCmdTbl,x)

; ------------------------------------------------------------------------------

; menu text special string jump table
MenuTextCmdTbl:
@6707:  .addr   TextCmdUnused
        .addr   MenuTextCmd_01
        .addr   MenuTextCmd_02
        .addr   MenuTextCmd_03
        .addr   MenuTextCmd_04
        .addr   MenuTextCmd_05
        .addr   TextCmdUnused
        .addr   MenuTextCmd_07
        .addr   MenuTextCmd_08
        .addr   MenuTextCmd_09
        .addr   MenuTextCmd_0a
        .addr   MenuTextCmd_0b
        .addr   MenuTextCmd_0c
        .addr   MenuTextCmd_0d
        .addr   MenuTextCmd_0e
        .addr   MenuTextCmd_0f
        .addr   MenuTextCmd_10
        .addr   MenuTextCmd_11
        .addr   MenuTextCmd_12
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused
        .addr   TextCmdUnused

; ------------------------------------------------------------------------------

; [ unused menu text special string ]

TextCmdUnused:
@6747:  rts

; ------------------------------------------------------------------------------

; [ menu text special string $01: next line ]

ListTextCmd_01:
MenuTextCmd_01:
mess_ret:
@6748:  lda     near w7e88db
        longa
        pha
        asl
        clc
        adc     z4a
        sta     z4a
        pla
        clc
        adc     z4a
        sta     z4c
        clr_ay
        shorta
        rts

; ------------------------------------------------------------------------------

; [ menu text special string $02: character name ]

MenuTextCmd_02:

@675f:  jsr     IncTextPtr
        stz     $10
        lda     (z48)
@6766:  sec
        sbc     #$0a
        bcc     @6770
        inc     $10
        jmp     @6766
@6770:  clc
        adc     #$0a
        sta     $11
        lda     $10
        bne     @677b
        lda     #$ff^ZERO_CHAR
@677b:  clc
        adc     #ZERO_CHAR
        jsr     DrawMenuKana
        lda     $11
        ora     $10
        bne     @678c
        lda     #$ff
        jmp     DrawMenuKana
@678c:  lda     $11
        clc
        adc     #ZERO_CHAR
        jmp     DrawMenuKana

; ------------------------------------------------------------------------------

; [ menu text special string $03: normal letter ]

MenuTextCmd_03:
@6794:  jsr     IncTextPtr
        lda     (z48)
        jmp     DrawMenuKana

; ------------------------------------------------------------------------------

; [ menu text special string $04: set tile data (usually for font color) ]

MenuTextCmd_04:
@679c:  jsr     IncTextPtr
        lda     (z48)
        sta     z4e
        rts

; ------------------------------------------------------------------------------

; [ menu text special string $05: spaces ]

; b1: number of spaces

MenuTextCmd_05:
@67a4:  jsr     IncTextPtr
        lda     (z48)
        sta     $10
@67ab:  lda     #$ff
        jsr     DrawMenuKana
        dec     $10
        bne     @67ab
        rts

; ------------------------------------------------------------------------------

; [ menu text special string $07: character 1 info text ]

MenuTextCmd_07:
@67b5:  clr_a
        bra     DrawCharSlotInfo

; ------------------------------------------------------------------------------

; [ menu text special string $08: character 2 info text ]

MenuTextCmd_08:
@67b8:  lda     #1
        bra     DrawCharSlotInfo

; ------------------------------------------------------------------------------

; [ menu text special string $09: character 3 info text ]

MenuTextCmd_09:
@67bc:  lda     #2
        bra     DrawCharSlotInfo

; ------------------------------------------------------------------------------

; [ menu text special string $0a: character 4 info text ]

MenuTextCmd_0a:
@67c0:  lda     #3
; fall through

DrawCharSlotInfo:
        tax
        lda     near w7e64d6,x               ; get party slot in this menu slot
        cmp     #$ff
        beq     @67cf       ; branch if character slot is empty
        asl
        tax
        jmp     (near DrawCharSlotInfoTbl,x)

; empty character slot
@67cf:  jsr     IncTextPtr
        lda     (z48)       ; info type
        tax
        lda     f:CharInfoTextWidthTbl,x
        jmp     _c16825       ; clear text

; ------------------------------------------------------------------------------

; character info text length (for clearing)
CharInfoTextWidthTbl:
@67dc:  .byte   6,4,6,3,3,6,6

; character info text jump table (for each character)
DrawCharSlotInfoTbl:
@67e3:  .addr   DrawCharSlot1Info
        .addr   DrawCharSlot2Info
        .addr   DrawCharSlot3Info
        .addr   DrawCharSlot4Info

; ------------------------------------------------------------------------------

; character 1

DrawCharSlot1Info:
@67eb:  ldx     #near wCharGfxDataBuf
        lda     #0
        bra     _6805

; ------------------------------------------------------------------------------

; character 2

DrawCharSlot2Info:
@67f2:  ldx     #$2ece
        lda     #1
        bra     _6805

; ------------------------------------------------------------------------------

; character 3

DrawCharSlot3Info:
@67f9:  ldx     #$2eee
        lda     #2
        bra     _6805

; ------------------------------------------------------------------------------

; character 4

DrawCharSlot4Info:
@6800:  ldx     #$2f0e
        lda     #3
; fall through

_6805:  sta     $18
        stx     $10         ; ++$10 = pointer to character graphics data
        lda     #$7e
        sta     $12
        jsr     IncTextPtr
        lda     (z48)       ; info type
        asl
        tax
        jmp     (near DrawCharInfoTbl,x)

; ------------------------------------------------------------------------------

.enum DRAW_CHAR_INFO
        NAME
        CURR_HP
        MAX_HP
        CURR_MP
        MAX_MP
        MORPH
        CONDEMNED

        COUNT
.endenum

; character info text jump table (for each info type)
DrawCharInfoTbl:
        ptr_tbl DRAW_CHAR_INFO

; ------------------------------------------------------------------------------

; clear text
_c16825:
@6825:  tax
@6826:  lda     #$ff
        jsr     DrawMenuLetter
        dex
        bne     @6826
        rts

; ------------------------------------------------------------------------------

; character info text $00: name
        array_label DRAW_CHAR_INFO, DRAW_CHAR_INFO::NAME
@682f:  ldx     $10
        lda     #6                      ; 6 letters
        sta     $14
@6835:  lda     a:$0001,x               ; character name
        jsr     DrawMenuLetter
        inx
        dec     $14
        bne     @6835
        rts

; ------------------------------------------------------------------------------

; character info text $01: current hp
        array_label DRAW_CHAR_INFO, DRAW_CHAR_INFO::CURR_HP
@6841:  lda     #$07        ; $2eb5 (current hp)
        jmp     DrawNum4

; ------------------------------------------------------------------------------

; character info text $06: condemned gauge (unused)
        array_label DRAW_CHAR_INFO, DRAW_CHAR_INFO::CONDEMNED
@6846:  lda     $18
        tax
        lda     near w7e61a6,x     ; condemned number
        bra     DrawGaugeText

; ------------------------------------------------------------------------------

; character info text $05: morph gauge
        array_label DRAW_CHAR_INFO, DRAW_CHAR_INFO::MORPH
@684e:  lda     $18
        tax
        lda     near w7e61a2,x     ; morph gauge value
; fall through

; ------------------------------------------------------------------------------

; [ write gauge text ]

DrawGaugeText:
@6854:  lsr
        and     #%11111100              ; get pointer to appropriate gauge text
        tax
        lda     #GAUGE_LEFT_CHAR
        jsr     DrawMenuKana
        lda     #4                      ; 4 bytes of text
        sta     $1a
@6861:  lda     f:GaugeTextTbl,x
        jsr     DrawMenuKana
        inx
        dec     $1a
        bne     @6861
        lda     #GAUGE_RIGHT_CHAR
        jmp     DrawMenuKana

; ------------------------------------------------------------------------------

; character info text $02: atb gauge or max hp
        array_label DRAW_CHAR_INFO, DRAW_CHAR_INFO::MAX_HP
@6872:  lda     near wGaugeSetting       ; atb gauge setting
        and     #$01
        beq     @6898       ; branch if off

; draw ATB gauge
        lda     z4e
        pha
        lda     $18
        tax
        lda     near w7e619e,x     ; atb gauge
        cmp     #$ff
        bne     @688a       ; branch if not full

; ATB gauge full
        lda     #$29        ; palette 2
        bra     @688c

; ATB gauge filling
@688a:  lda     #$35        ; palette 7
@688c:  sta     z4e
        lda     near w7e619e,x     ; atb gauge
        jsr     DrawGaugeText
        pla
        sta     z4e
        rts

; draw max hp (gauge off)
@6898:  lda     #TILDE_CHAR
        jsr     DrawMenuLetter
        lda     #$09        ; $2eb7 (max hp)
        jsr     DrawNum4
        lda     #$ff
        jmp     DrawMenuKana

; ------------------------------------------------------------------------------

; character info text $03: current mp
        array_label DRAW_CHAR_INFO, DRAW_CHAR_INFO::CURR_MP
@68a7:  lda     #$0b        ; $2eb9 (current mp)
        jmp     DrawNum3

; ------------------------------------------------------------------------------

; atb/morph/swdtech gauge text

GaugeTextTbl:
        .repeat 32, i
        .byte GAUGE_EMPTY_CHAR + .max(0, .min(i + 1, 8))
        .byte GAUGE_EMPTY_CHAR + .max(0, .min(i - 7, 8))
        .byte GAUGE_EMPTY_CHAR + .max(0, .min(i - 15, 8))
        .byte GAUGE_EMPTY_CHAR + .max(0, .min(i - 23, 8))
        .endrep

; ------------------------------------------------------------------------------

; character info text $04: max mp
        array_label DRAW_CHAR_INFO, DRAW_CHAR_INFO::MAX_MP
@692c:  lda     #$0d        ; $2ebb (max mp)
        jmp     DrawNum3

; ------------------------------------------------------------------------------

; [ convert 4 digit number to text ]

HexToDec4:
@6931:  phy
        tay
        longa
        lda     [$10],y
        tax
        shorta0
        lda     #ZERO_CHAR
        sta     z68
        jsr     HexToDec16
        jsr     TrimZeroes4
        ldx     zZero
        ply
        rts

; ------------------------------------------------------------------------------

; [ convert 3 digit number to text ]

HexToDec3:
@6949:  phy
        tay
        longa
        lda     [$10],y
        tax
        shorta0
        lda     #ZERO_CHAR
        sta     z68
        jsr     HexToDec16
        jsr     TrimZeroes3
        ldx     zZero
        ply
        rts

; ------------------------------------------------------------------------------

; [ clear leading zeroes (3 digit number) ]

TrimZeroes3:
@6961:  ldx     zZero
@6963:  lda     z69,x       ; digit text
        sec
        sbc     z68
        bne     @6974       ; return if digit is not zero
        lda     #BG1_BLANK_CHAR
        sta     z69,x
        inx                 ; next digit
        cpx     #3
        bne     @6963
@6974:  rts

; ------------------------------------------------------------------------------

; [ write 4 digit number text ]

DrawNum4:
@6975:  jsr     HexToDec4
@6978:  lda     z69,x
        jsr     DrawMenuLetter
        inx
        cpx     #4
        bne     @6978
        rts

; ------------------------------------------------------------------------------

; [ write 3 digit number text ]

DrawNum3:
@6984:  jsr     HexToDec3
@6987:  lda     z69 + 1,x
        jsr     DrawMenuLetter
        inx
        cpx     #3
        bne     @6987
        rts

; ------------------------------------------------------------------------------

; [ menu text special string $0b: monster name ]

MenuTextCmd_0b:
@6993:  jsr     IncTextPtr
        lda     #MONSTER_NAME::ITEM_SIZE
        sta     $10
        lda     (z48)
        asl
        tax
        longa
        lda     near w7e200d,x     ; monster name (bank c2 manages this data)
        cmp     #$ffff
        bne     @69b8
        shorta0
.if LANG_EN
        inc     $10
.endif
@69ad:  lda     #$ff
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @69ad
        rts
@69b8:
.if LANG_EN
        longa
        sta     $24
        lda     #MONSTER_NAME::ITEM_SIZE
        sta     $22
        jsr     Mult816
        shorta0
        ldx     $26
@69c9:  lda     f:MonsterName,x
        jsr     DrawMenuLetter
        inx                 ; next letter
        dec     $10
        bne     @69c9
        lda     #$ff        ; space
        jmp     DrawMenuLetter

.else
        asl3
        tax
        shorta0
@69c9:  lda     f:MonsterName,x
        jsr     DrawMenuLetter
        inx                 ; next letter
        dec     $10
        bne     @69c9
        rts

.endif

; ------------------------------------------------------------------------------

; [ menu text special string $0c: number of monster type remaining ]

MenuTextCmd_0c:
.if LANG_EN
@69da:  jsr     IncTextPtr
        rts
.else
@69e2:  jsr     IncTextPtr
        ldx     $11e0
        cpx     #$01c8                  ; blank if chadarnook
        beq     @69fa
        lda     (z48)
        asl
        tax
        lda     near w7e2015,x
        bmi     @69fa
        cmp     #2
        bcs     @69fc
@69fa:  lda     #$ff^ZERO_CHAR
@69fc:  clc
        adc     #ZERO_CHAR
        jmp     DrawMenuLetter
.endif

; ------------------------------------------------------------------------------

; [ menu text special string $0d: battle command name ]

MenuTextCmd_0d:
@69de:  jsr     IncTextPtr
        lda     (z48)
        cmp     #$ff
        bne     @69ec       ; branch if command slot is empty
        lda     #BATTLE_CMD_NAME::ITEM_SIZE
        jmp     DrawSpaces
@69ec:  xba
        lda     #BATTLE_CMD_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@69fe:  lda     f:BattleCmdName,x   ; battle command name
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @69fe
        rts

; ------------------------------------------------------------------------------

; [ menu text special string $10: status name ]

MenuTextCmd_10:
@6a0b:  jsr     IncTextPtr
        lda     (z48)
        cmp     #$ff
        bne     @6a19
        lda     #STATUS_NAME::ITEM_SIZE
        jmp     DrawSpaces
@6a19:  xba
        lda     #STATUS_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@6a2b:  lda     f:StatusName,x
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @6a2b
        rts

; ------------------------------------------------------------------------------

.ifndef ITEM_SYMBOL_NAME_INC

MenuTextCmd_12 := TextCmdUnused

.else

; [ menu text special string $12: item symbol name ]

MenuTextCmd_12:
@6a38:  jsr     IncTextPtr
        lda     (z48)
        cmp     #$ff
        bne     @6a46
@6a41:  lda     #7
        jmp     DrawSpaces
@6a46:  xba
        lda     #ITEM_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
        lda     f:ItemName,x   ; item name (first character)
        cmp     #$ff
        beq     @6a41       ; branch if no symbol
        sec
        sbc     #$d8
        xba
        lda     #ITEM_SYMBOL_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@6a75:  lda     f:ItemSymbolName,x
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @6a75
        rts
.endif

; ------------------------------------------------------------------------------

; [ menu text special string $0e: item name ]

MenuTextCmd_0e:
@6a82:  jsr     IncTextPtr
        lda     (z48)
        cmp     #$ff
        bne     @6a90
        lda     #ITEM_NAME::ITEM_SIZE
        jmp     DrawSpaces
@6a90:  xba
        lda     #ITEM_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@6aa2:  lda     f:ItemName,x
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @6aa2
        rts

; ------------------------------------------------------------------------------

.if !LANG_EN

        MenuTextCmd_11 := TextCmdUnused

.else

; [ menu text special string $11:  ]

MenuTextCmd_11:
@6aaf:  jsr     MenuTextCmd_0f
        lda     (z48)
        cmp     #$ff
        beq     @6abd
        cmp     #ATTACK::FIRST_GENJU
        bcc     @6abd
        rts
@6abd:  lda     #3
        jmp     DrawSpaces

.endif

; ------------------------------------------------------------------------------

; [ menu text special string $0f: attack name ]

MenuTextCmd_0f:
@6ac2:  jsr     IncTextPtr
        lda     (z48)
        cmp     #$ff
        bne     @6ad0
        lda     #MAGIC_NAME::ITEM_SIZE
        jmp     DrawSpaces
@6ad0:  cmp     #ATTACK::FIRST_GENJU
        bcc     @6b1c       ; branch if a spell
.if LANG_EN
        cmp     #ATTACK::FIRST_NINJA
        bcc     @6afa       ; branch if an esper attack

; normal attack
        sec
        sbc     #ATTACK::FIRST_NINJA
        xba
        lda     #ATTACK_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@6aed:  lda     f:AttackName,x
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @6aed
        rts
.endif
; esper attack
@6afa:  sec
        sbc     #ATTACK::FIRST_GENJU
        xba
        lda     #GENJU_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@6b0f:
.if LANG_EN
        lda     f:GenjuName - $6c,x   ; *** bug *** bad pointer
.else
        lda     f:GenjuName,x
.endif
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @6b0f
        rts

; spell
@6b1c:  xba
        lda     #MAGIC_NAME::ITEM_SIZE
        sta     $10
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        tax
        shorta0
@6b2e:  lda     f:MagicName,x
        jsr     DrawMenuLetter
        inx
        dec     $10
        bne     @6b2e
        rts

; ------------------------------------------------------------------------------

; [ draw spaces (tab) ]

; A: number of spaces

DrawSpaces:
@6b3b:  sta     $1a
@6b3d:  lda     #$ff
        jsr     DrawMenuKana
        dec     $1a
        bne     @6b3d
        rts

; ------------------------------------------------------------------------------
