
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: menu.asm                                                             |
; |                                                                            |
; | description: menu program                                                  |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"
.include "field.inc"
.include "battle.inc"
.include "btlgfx.inc"
.include "menu.inc"
.include "sound.inc"

; ------------------------------------------------------------------------------

inc_lang "assets/attack_name_%s.inc"
inc_lang "assets/battle_bg_gfx_%s.inc"
.include "assets/battle_bg_tiles.inc"
.include "assets/battle_char_pal.inc"
inc_lang "assets/battle_cmd_name_%s.inc"
.include "assets/battle_cmd_prop.inc"
.include "assets/blitz_code.inc"
inc_lang "assets/blitz_desc_%s.inc"
inc_lang "assets/bushido_desc_%s.inc"
inc_lang "assets/bushido_name_%s.inc"
.include "assets/char_prop.inc"
.include "assets/colosseum_prop.inc"
.include "assets/credits_gfx1.inc"
inc_lang "assets/dance_name_%s.inc"
.include "assets/ending_font_gfx.inc"
.include "assets/ending_gfx1.inc"
.include "assets/ending_gfx2.inc"
.include "assets/ending_gfx3.inc"
.include "assets/ending_gfx4.inc"
.include "assets/ending_gfx5.inc"
inc_lang "assets/large_font_gfx_%s.inc"
inc_lang "assets/small_font_gfx_%s.inc"
inc_lang "assets/font_width_%s.inc"
inc_lang "assets/genju_attack_desc_%s.inc"
inc_lang "assets/genju_bonus_desc_%s.inc"
inc_lang "assets/genju_bonus_name_%s.inc"
inc_lang "assets/genju_name_%s.inc"
.include "assets/genju_order.inc"
.include "assets/genju_prop.inc"
.include "assets/imp_item.inc"
inc_lang "assets/item_desc_%s.inc"
inc_lang "assets/item_name_%s.inc"
inc_lang "assets/item_prop_%s.inc"
inc_lang "assets/item_type_name_%s.inc"
.include "assets/level_up_exp.inc"
inc_lang "assets/lore_desc_%s.inc"
inc_lang "assets/magic_desc_%s.inc"
inc_lang "assets/magic_name_%s.inc"
.include "assets/magic_prop.inc"
.include "assets/menu_pal.inc"
.include "assets/menu_sprite_gfx.inc"
.include "assets/monster_align.inc"
inc_lang "assets/monster_gfx_prop_%s.inc"
inc_lang "assets/monster_name_%s.inc"
.include "assets/monster_pal.inc"
.include "assets/portrait_gfx.inc"
.include "assets/portrait_pal.inc"
inc_lang "assets/rare_item_desc_%s.inc"
inc_lang "assets/rare_item_name_%s.inc"
.include "assets/shop_prop.inc"
.include "assets/window_gfx.inc"
.include "assets/window_pal.inc"

; ------------------------------------------------------------------------------

.repeat PortraitGfx_ARRAY_LENGTH, i
        .import .ident(.sprintf("PortraitGfx_%04x", i))
.endrep

.import WorldBackdropGfxPtr, WorldBackdropTilesPtr

; ------------------------------------------------------------------------------

.include "ending_anim.asm"
.include "menu_anim.asm"

; ------------------------------------------------------------------------------

.segment "menu_code"
.a8
.i16

; ------------------------------------------------------------------------------

OpenMenu_ext:
@0000:  jmp     OpenMenu

UpdateCtrlBattle_ext:
@0003:  jmp     UpdateCtrlBattle

InitCtrl_ext:
@0006:  jmp     InitCtrl

UpdateCtrlField_ext:
@0009:  jmp     UpdateCtrlField

IncGameTime_ext:
@000c:  jmp     IncGameTime

LoadSavedGame_ext:
@000f:  jmp     LoadSavedGame

EndingCutscene_ext:
@0012:  jmp     EndingCutscene

OptimizeCharEquip_ext:
@0015:  jmp     OptimizeCharEquip

EndingAirshipScene_ext:
@0018:  jmp     EndingAirshipScene

; ------------------------------------------------------------------------------

; [ open menu ]

OpenMenu:
@001b:  longi
        shorta
        lda     #$00                    ; set data bank
        pha
        plb
        ldx     #$0000                  ; set direct page
        phx
        pld
        ldx     #$0000                  ; set $00
        stx     $00
        lda     #$7e
        sta     hWMADDH                 ; set wram bank
        jsr     InitInterrupts
        lda     $0200
        cmp     #$02
        bne     @003f                   ; branch if not opening game load menu
        jsr     InitSaveSlot
@003f:  jsr     InitMenu
        jsr     OpenMenuType
        jsl     InitCtrl
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hMDMAEN
        stz     hHDMAEN
        lda     $0200
        cmp     #$02
        bne     @006f                   ; branch if not restoring a saved game
        lda     $0205
        bpl     @006f                   ; branch if tent/warp/warp stone was used
        lda     $1d4e
        and     #$20
        beq     @006f                   ; branch if stereo mode
        lda     #$ff
        jsr     SetStereoMono
@006f:  lda     $0200
        bne     @00bf       ; branch if not main menu
        lda     $0205
        bpl     @00bf       ; return if return code is positive
        cmp     #$fe
        bne     @009e       ; branch if not using rename card

; rename card
        lda     #$01
        sta     $0200
        lda     $0201
        sta     $020f
        ldy     $0206
        sty     $0201
        jsl     OpenMenu_ext
        lda     $020f
        sta     $0201
        stz     $0200
        jmp     @001b

; swdtech renaming (ff6j)
@009e:  lda     #$06
        sta     $0200
        lda     $0201
        sta     $020f
        lda     $0206
        sta     $0201
        jsl     OpenMenu_ext
        lda     $020f
        sta     $0201
        stz     $0200
        jmp     @001b

; return from menu
@00bf:  rtl

; ------------------------------------------------------------------------------

; [ set up interrupt jump code ]

InitInterrupts:
@00c0:  lda     #$5c
        sta     $1500
        sta     $1504
        ldx     #.loword(MenuNMI)
        stx     $1501
        ldx     #.loword(MenuIRQ)
        stx     $1505
        lda     #^MenuNMI
        sta     $1503
        sta     $1507
        rts

; ------------------------------------------------------------------------------

; [ open menu (type) ]

OpenMenuType:
@00dd:  clr_a
        lda     $0200
        asl
        tax
        jmp     (.loword(MenuTypeTbl),x)

; menu type jump table
MenuTypeTbl:
        .addr   MainMenu
        .addr   NameChangeMenu
        .addr   GameLoadMenu
        .addr   ShopMenu
        .addr   PartySelectMenu
        .addr   ItemDetailsMenu
        .addr   BushidoNameMenu
        .addr   ColosseumMenu
        .addr   FinalBattleOrderMenu

; ------------------------------------------------------------------------------

; [ init menu ]

InitMenu:
@00f8:  jsr     InitRAM
        jsr     InitCharProp
        jsr     _c369a9
        jsl     InitHWRegsMenu
        jsl     InitCtrl
        clr_a
        jsl     InitGradientHDMA
        jsr     InitWindow1PosHDMA
        jsr     ResetTasks
        jsr     InitMenuGfx
        jmp     LoadWindowGfx

; ------------------------------------------------------------------------------

; [ menu type $00: main menu ]

MainMenu:
@011a:  lda     #$04                    ; menu state $04 (main menu init)
        sta     $26
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $03: shop ]

ShopMenu:
@0121:  jsr     InitFontColor
        lda     #$24                    ; menu state $24 (shop init)
        sta     $26
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $04: party select ]

PartySelectMenu:
@012b:  jsr     InitFontColor
        jsr     ResetCursorPos
        lda     #$2c                    ; menu state $2c (party select init)
        sta     $26
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ clear previous cursor position ]

ResetCursorPos:
@0138:  clr_ay
        sty     $8e
        rts

; ------------------------------------------------------------------------------

; [ menu type $05: item details ??? (unused) ]

ItemDetailsMenu:
@013d:  jsr     InitFontColor
        jsr     ResetCursorPos
        lda     #$2f                    ; menu state $2f (item details)
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $06: swdtech renaming (ff6j) ]

BushidoNameMenu:
@0149:  jsr     InitFontColor
        lda     #$3f                    ; menu state $3f
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $07: colosseum ]

ColosseumMenu:
@0152:  jsr     InitFontColor
        stz     $79
        stz     $7a
        stz     $7b
        lda     #$ff
        sta     $0205
        lda     #$71                    ; menu state $71 (colosseum item select init)
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $08: final battle order ]

FinalBattleOrderMenu:
@0166:  jsr     InitFontColor
        lda     #$73                    ; menu state $73 (final battle order init)
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $02: restore game ]

GameLoadMenu:
@016f:  lda     $307ff1                 ; increment random number seed
        inc
        sta     $307ff1
        jsl     InitCtrl
        jsr     CheckSRAM
        bcc     @019f                   ; branch if sram is invalid
        lda     #$01                    ; song $01 (the prelude)
        sta     $1301
        lda     #$10
        sta     $1300
        lda     #$80
        sta     $1302
        jsl     ExecSound_ext
        lda     #$ff
        sta     $0205
        lda     #$20                    ; menu state $20 (restore game init)
        sta     $26
        bra     MenuLoop

; sram invalid
@019f:  jsr     ResetGameTime
        lda     #1
        sta     $0224                   ; current saved game slot = 1
        stz     $021f                   ; don't load a saved game
        lda     #$ff
        sta     $26                     ; terminate menu
        stz     $0205                   ; clear return code
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $01: name change ]

NameChangeMenu:
@01b3:  jsr     InitFontColor
        lda     #$5d                    ; menu state $5d (name change init)
        sta     $26
; fall through

; ------------------------------------------------------------------------------

; [ menu state loop ]

MenuLoop:
@01ba:  jsr     UpdatePPU
@01bd:  clr_a
        lda     $26                     ; return if menu state is $ff
        cmp     #$ff
        beq     @01d8
        longa
        asl
        tax
        shorta
        jsr     (.loword(MenuStateTbl),x)
        jsr     ExecTasks
        jsr     WaitFrame
        jsr     CheckEventTimer
        bra     @01bd
@01d8:  stz     $43                     ; disable hdma
        rts

; ------------------------------------------------------------------------------

; menu state jump table
MenuStateTbl:
@01db:  .addr   MenuState_00
        .addr   MenuState_01
        .addr   MenuState_02
        .addr   MenuState_03
        .addr   MenuState_04
        .addr   MenuState_05
        .addr   MenuState_06
        .addr   MenuState_07
        .addr   MenuState_08
        .addr   MenuState_09
        .addr   MenuState_0a
        .addr   MenuState_0b
        .addr   MenuState_0c
        .addr   MenuState_0d
        .addr   MenuState_0e
        .addr   MenuState_0f
        .addr   MenuState_10
        .addr   MenuState_11
        .addr   MenuState_12
        .addr   MenuState_13
        .addr   MenuState_14
        .addr   MenuState_15
        .addr   MenuState_16
        .addr   MenuState_17
        .addr   MenuState_18
        .addr   MenuState_19
        .addr   MenuState_1a
        .addr   MenuState_1b
        .addr   MenuState_1c
        .addr   MenuState_1d
        .addr   MenuState_1e
        .addr   MenuState_1f
        .addr   MenuState_20
        .addr   MenuState_21
        .addr   MenuState_22
        .addr   MenuState_23
        .addr   MenuState_24
        .addr   MenuState_25
        .addr   MenuState_26
        .addr   MenuState_27
        .addr   MenuState_28
        .addr   MenuState_29
        .addr   MenuState_2a
        .addr   MenuState_2b
        .addr   MenuState_2c
        .addr   MenuState_2d
        .addr   MenuState_2e
        .addr   MenuState_2f
        .addr   MenuState_30
        .addr   MenuState_31
        .addr   MenuState_32
        .addr   MenuState_33
        .addr   MenuState_34
        .addr   MenuState_35
        .addr   MenuState_36
        .addr   MenuState_37
        .addr   MenuState_38
        .addr   MenuState_39
        .addr   MenuState_3a
        .addr   MenuState_3b
        .addr   MenuState_3c
        .addr   MenuState_3d
        .addr   MenuState_3e
        .addr   MenuState_3f
        .addr   MenuState_40
        .addr   MenuState_41
        .addr   MenuState_42
        .addr   MenuState_43
        .addr   MenuState_44
        .addr   MenuState_45
        .addr   MenuState_46
        .addr   MenuState_47
        .addr   MenuState_48
        .addr   MenuState_49
        .addr   MenuState_4a
        .addr   MenuState_4b
        .addr   MenuState_4c
        .addr   MenuState_4d
        .addr   MenuState_4e
        .addr   MenuState_4f
        .addr   MenuState_50
        .addr   MenuState_51
        .addr   MenuState_52
        .addr   MenuState_53
        .addr   MenuState_54
        .addr   MenuState_55
        .addr   MenuState_56
        .addr   MenuState_57
        .addr   MenuState_58
        .addr   MenuState_59
        .addr   MenuState_5a
        .addr   MenuState_5b
        .addr   MenuState_5c
        .addr   MenuState_5d
        .addr   MenuState_5e
        .addr   MenuState_5f
        .addr   MenuState_60
        .addr   MenuState_61
        .addr   MenuState_62
        .addr   MenuState_63
        .addr   MenuState_64
        .addr   MenuState_65
        .addr   MenuState_66
        .addr   MenuState_67
        .addr   MenuState_68
        .addr   MenuState_69
        .addr   MenuState_6a
        .addr   MenuState_6b
        .addr   MenuState_6c
        .addr   MenuState_6d
        .addr   MenuState_6e
        .addr   MenuState_6f
        .addr   MenuState_70
        .addr   MenuState_71
        .addr   MenuState_72
        .addr   MenuState_73
        .addr   MenuState_74
        .addr   MenuState_75
        .addr   MenuState_76
        .addr   MenuState_77
        .addr   MenuState_78
        .addr   MenuState_79
        .addr   MenuState_7a
        .addr   0
        .addr   0
        .addr   MenuState_7d
        .addr   MenuState_7e
        .addr   MenuState_7f

; ------------------------------------------------------------------------------

; [ check event timer ]

CheckEventTimer:
@02db:  lda     $b4
        bne     @02f8
        lda     $1188       ; return if event timer can cause the menu to close
        bit     #$20
        beq     @02f8
        ldy     $1189       ; return unless event timer ran out
        bne     @02f8
        lda     #$ff
        sta     $27
        stz     $26
        lda     #$05
        sta     $0205
        sta     $b4
@02f8:  rts

; ------------------------------------------------------------------------------

; [ draw positioned text ]

;  +y = source address (+$c30000)
; $29 = flags

DrawPosText:
@02f9:  sty     $e7
        lda     #^*
        sta     $e9

DrawPosTextFar:
@02ff:  ldx     $00
        txy
        longa
        lda     [$e7]
        sta     $eb
        inc     $e7
        inc     $e7
        shorta
        lda     #$7e
        sta     $ed
@0312:  lda     [$e7],y
        beq     @0325
        phy
        txy
        sta     [$eb],y
        inx
        txy
        lda     $29
        sta     [$eb],y
        inx
        ply
        iny
        bra     @0312
@0325:  rts

; ------------------------------------------------------------------------------

; [ init buffer for window tiles ]

; Y: flags applied to each tile

SetWindowTileFlags:
@0326:  sty     $e7
        ldx     $00
        longa
@032c:  lda     f:WindowTileTbl,x
        clc
        adc     $e7
        sta     $7e9f19,x
        inx2
        cpx     #$0038
        bne     @032c
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load and draw window ]

; +y = source address (+$c30000)

DrawWindow:
@0341:  lda     #^*
        sta     $e9

DrawWindowFar:
@0345:  sty     $e7
        ldx     $00
        txy
        longa
        lda     [$e7],y
        sta     $eb
        iny2
        lda     [$e7],y
        sta     $e0
        shorta
        sta     $e2
        lda     #$7e
        sta     $ed
        ldx     $00
        txy
        shorti
        ldx     $e0
        ldy     $e1
        longi
        stx     $ef
        sty     $f1
        longa
        jsr     DrawWindowRows
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw window tile rows ]

.a16

DrawWindowRows:
@0375:  jsr     DrawBorderTop
        ldx     $00
        ldy     #$0040
        sty     $f3
@037f:  phx
        txa
        and     #$0003
        asl
        tax
        jsr     (.loword(DrawWindowRowsTbl),x)
        lda     $f3
        clc
        adc     #$0040
        sta     $f3
        tay
        plx
        inx
        cpx     $f1
        bne     @037f
        jmp     DrawBorderBtm

DrawWindowRowsTbl:
@039b:  .addr   DrawWindowRows_00
        .addr   DrawWindowRows_01
        .addr   DrawWindowRows_02
        .addr   DrawWindowRows_03

; ------------------------------------------------------------------------------

; [ draw border row ]

DrawBorderTop:
@03a3:  ldy     $00
        jsr     SetBorderPatternMask
        lda     $7e9f49
        sta     $e3
        lda     $7e9f4b
        sta     $e5
        ldx     #$0020
        stx     $e0
        bra     DrawWindowRow

DrawBorderBtm:
@03bb:  jsr     SetBorderPatternMask
        lda     $7e9f4d
        sta     $e3
        lda     $7e9f4f
        sta     $e5
        ldx     #$0024
        stx     $e0
        bra     DrawWindowRow

; ------------------------------------------------------------------------------

; [ draw window row ]

DrawWindowRows_00:
@03d1:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder1
        stz     $e0
        bra     DrawWindowRow

DrawWindowRows_01:
@03db:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder2
        ldx     #$0008
        stx     $e0
        bra     DrawWindowRow

DrawWindowRows_02:
@03e8:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder1
        ldx     #$0010
        stx     $e0
        bra     DrawWindowRow

DrawWindowRows_03:
@03f5:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder2
        ldx     #$0018
        stx     $e0
        bra     DrawWindowRow

; ------------------------------------------------------------------------------

; [ set window area pattern mask ]

SetWindowPatternMask:
@0402:  ldx     #3
        stx     $f5
        rts

; ------------------------------------------------------------------------------

; [ set border area pattern mask ]

SetBorderPatternMask:
@0408:  ldx     #1
        stx     $f5
        rts

; ------------------------------------------------------------------------------

; [ get 1st tile of left/right border ]

GetWindowBorder1:
@040e:  lda     $7e9f41
        sta     $e3
        lda     $7e9f43
        sta     $e5
        rts

; ------------------------------------------------------------------------------

; [ get 2nd tile of left/right border ]

GetWindowBorder2:
@041b:  lda     $7e9f45
        sta     $e3
        lda     $7e9f47
        sta     $e5
        rts

; ------------------------------------------------------------------------------

; [ draw one row of window ]

DrawWindowRow:
@0428:  ldx     $00
        lda     $e3
        sta     [$eb],y
        iny2
@0430:  phx
        txa
        and     $f5
        asl
        clc
        adc     $e0
        tax
        lda     $7e9f19,x
        plx
        cpx     $ef
        beq     @0449
        sta     [$eb],y
        iny2
        inx
        bra     @0430
@0449:  lda     $e5
        sta     [$eb],y
        rts

.a8

; ------------------------------------------------------------------------------

WindowTileTbl:
@044e:  .word   $0180,$0181,$0182,$0183  ; window mid 1
        .word   $0184,$0185,$0186,$0187  ; window mid 2
        .word   $0188,$0189,$018a,$018b  ; window mid 3
        .word   $018c,$018d,$018e,$018f  ; window mid 4
        .word   $0191,$0192,$0199,$019a  ; upper/lower border
        .word   $0194,$0195,$0196,$0197  ; left/right border
        .word   $0190,$0193,$0198,$019b  ; border corners

; ------------------------------------------------------------------------------

; [ draw number text (3 digit) ]

Draw16BitNum:
@0486:  ldy     #5
        sty     $e0
        ldy     #2
        bra     DrawNumText

; ------------------------------------------------------------------------------

; [ draw number text (4 digit) ]

; hp/mp

DrawNum4:
@0490:  ldy     #5
        sty     $e0
        ldy     #1
        bra     DrawNumText

; ------------------------------------------------------------------------------

; [ draw number text (5 digit) ]

DrawNum5:
@049a:  ldy     #5
        sty     $e0
        ldy     $00
        bra     DrawNumText

; ------------------------------------------------------------------------------

; [ draw number text (8 digit) ]

; experience

DrawNum8:
@04a3:  ldy     #8
        sty     $e0
        ldy     $00
        bra     DrawNumText

; ------------------------------------------------------------------------------

; [ draw number text (7 digit) ]

; steps, gp

DrawNum7:
@04ac:  ldy     #8
        sty     $e0
        ldy     #1
        bra     DrawNumText

; ------------------------------------------------------------------------------

; [ draw number text (2 digit) ]

DrawNum2:
@04b6:  ldy     #3
        sty     $e0
        ldy     #1
        bra     DrawNumText

; ------------------------------------------------------------------------------

; [ draw number text (3 digit) ]

DrawNum3:
@04c0:  ldy     #3
        sty     $e0
        ldy     $00
; fall through

; ------------------------------------------------------------------------------

; [ draw number text ]

;      +x = source address (+$7e0000)
;      +y = text buffer offset
;     $29 = vhopppmm high byte of bg data
;    +$e0 = text length
; $f7-$ff = text buffer

DrawNumText:
@04c7:  stx     $eb
        lda     #$7e
        sta     $ed
        tyx
        ldy     $00
@04d0:  lda     $f7,x
        sta     [$eb],y
        iny
        lda     $29
        sta     [$eb],y
        iny
        inx
        cpx     $e0
        bne     @04d0
        rts

; ------------------------------------------------------------------------------

; [ convert hex to decimal (3 digits) ]

;    +$f3 = hex number
; $f7-$f9 = decimal digits (battle text)

HexToDec3:
@04e0:  jsr     HexToDecZeroes3
        ldy     $00
        ldx     #2
@04e8:  lda     $00f7,y
        cmp     #$b4
        bne     @04f8
        lda     #$ff
        sta     $00f7,y
        iny
        dex
        bne     @04e8
@04f8:  rts

; ------------------------------------------------------------------------------

; [ convert hex to decimal (3 digits, keep leading zeroes) ]

;    +$f3 = hex number
; $f7-$f9 = decimal digits (battle text)

HexToDecZeroes3:
@04f9:  sta     $e0
        lda     #$03
        sta     $e4
        ldy     $00
        tyx
@0502:  stz     $e1
        lda     f:HexToDec3Tbl,x
        inx
        sta     $e3
@050b:  lda     $e0
        sec
        sbc     $e3
        bcc     @0518
        sta     $e0
        inc     $e1
        bra     @050b
@0518:  clc
        adc     $ed
        sta     $f3
        lda     $e1
        clc
        adc     #$b4
        sta     $00f7,y
        iny
        dec     $e4
        bne     @0502
        rts

; ------------------------------------------------------------------------------

; data for 3 digit hex to dec conversion
HexToDec3Tbl:
@052b:  .byte   100,10,1

; ------------------------------------------------------------------------------

; [ convert hex to decimal (5 digits) ]

;    +$f3 = hex number
; $f7-$fb = decimal digits (battle text)

HexToDec5:
@052e:  lda     #5
        sta     $e0
        ldy     $00
        tyx
@0535:  longa
        lda     f:HexToDec5Tbl,x
        inx2
        sta     $ed
        stz     $eb
@0541:  sec
        lda     $f3
        sbc     $ed
        bcc     @054e
        sta     $f3
        inc     $eb         ; increment digit
        bra     @0541
@054e:  clc
        adc     $ed
        sta     $f3
        shorta
        lda     $eb
        clc
        adc     #$b4
        sta     $00f7,y
        iny
        dec     $e0
        bne     @0535
        ldy     $00
        ldx     #$0004
@0567:  lda     $00f7,y
        cmp     #$b4
        bne     @0577
        lda     #$ff
        sta     $00f7,y
        iny
        dex
        bne     @0567
@0577:  rts

; ------------------------------------------------------------------------------

; data for 5 digit hex to dec conversion
HexToDec5Tbl:
@0578:  .word   10000,1000,100,10,1

; ------------------------------------------------------------------------------

; [ convert hex to decimal (8 digits) ]

;    +$f3 = hex number
; $f7-$fe = decimal digits (battle text)

HexToDec8:
@0582:  stz     $f4
        lda     #$08
        sta     $e0
        ldy     $00
        tyx
@058b:  longa
        stz     $eb
@058f:  sec
        lda     $f1
        sbc     f:HexToDec8TblLo,x
        sta     $f1
        lda     $f3
        sbc     f:HexToDec8TblHi,x
        sta     $f3
        bcc     @05a6
        inc     $eb
        bra     @058f
@05a6:  lda     $f1
        clc
        adc     f:HexToDec8TblLo,x
        sta     $f1
        lda     $f3
        adc     f:HexToDec8TblHi,x
        sta     $f3
        shorta
        lda     $eb
        clc
        adc     #$b4
        sta     $00f7,y
        iny
        inx2
        dec     $e0
        bne     @058b
        ldy     $00
        ldx     #$0007
@05cd:  lda     $00f7,y
        cmp     #$b4
        bne     @05dd
        lda     #$ff
        sta     $00f7,y
        iny
        dex
        bne     @05cd
@05dd:  rts

; ------------------------------------------------------------------------------

; data for 8 digit hex to dec conversion
HexToDec8TblLo:
@05de:  .word   $9680,$4240,$86a0,$2710,$03e8,$0064,$000a,$0001

HexToDec8TblHi:
@05ee:  .word   $0098,$000f,$0001,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; [ init cursor ]

; +y = pointer to cursor data (+$c30000)

; $00 x------y
;     x: disable cursor wrap in x direction
;     y: disable cursor wrap in y direction
; $01 initial x position (0-based)
; $02 initial y position
; $03 maximum x position (1-based)
; $04 maximum y position

LoadCursor:
@05fe:  lda     #^*
        sta     $ed

LoadCursorFar:
@0602:  sty     $eb
        ldy     $00
        lda     [$eb],y
        sta     $59
        iny
        longa
        stz     $51
        lda     [$eb],y
        sta     $4d
        iny2
        lda     [$eb],y
        sta     $53
        stz     $4f
        shorta
        rts

; ------------------------------------------------------------------------------

; [ select first valid character slot ]

SelectFirstChar:
@061e:  clr_ay
@0620:  tya
        asl
        tax
        lda     $85,x       ; character select cursor positions
        bne     @062f
        inc     $4e         ; increment cursor position
        iny
        cpy     #4
        bne     @0620
@062f:  rts

; ------------------------------------------------------------------------------

; [ set pointer to cursor data ]

; y = pointer to cursor data (+$c30000)

SetCursorPtr:
@0630:  sty     $e7
        lda     #^*
        sta     $e9
        rts

; ------------------------------------------------------------------------------

; [ update cursor position (rotated list) ]

; y = pointer to cursor data (+$c30000)

UpdateHorzCursorPos:
@0637:  jsr     SetCursorPtr
        jsr     CalcHorzListIndex
        jmp     SetCursorPos

; ------------------------------------------------------------------------------

; [ update cursor position (single page) ]

; y = pointer to cursor data (+$c30000)

UpdateCursorPos:
@0640:  jsr     SetCursorPtr

UpdateCursorPosFar:
@0643:  jsr     CalcShortListIndex
        bra     SetCursorPos

; ------------------------------------------------------------------------------

; [ update cursor position (scrolling page) ]

; y = pointer to cursor data (+$c30000)

UpdateListCursorPos:
@0648:  jsr     SetCursorPtr
        jsr     CalcLongListIndex
        bra     SetCursorPos

; ------------------------------------------------------------------------------

; [ update selected item (horizontal list) ]

CalcHorzListIndex:
@0650:  phb
        lda     #$00
        pha
        plb
@0655:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @0655
        lda     $54                     ; max y position
        sta     hM7A
        stz     hM7A
        lda     $4d                     ; current x position (relative to page)
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     $4e                     ; current y position (relative to page)
        sta     $4b                     ; $4b = $54 * $4d + $4e
        plb
        rts

; ------------------------------------------------------------------------------

; [ update selected item (vertical list, single page) ]

CalcShortListIndex:
@0677:  phb
        lda     #$00
        pha
        plb
@067c:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @067c
        lda     $53                     ; max x position
        sta     hM7A
        stz     hM7A
        lda     $4e                     ; current y position (relative to page)
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     $4d                     ; current x position (relative to page)
        sta     $4b                     ; $4b = $53 * $4e + $4d
        plb
        rts

; ------------------------------------------------------------------------------

; [ update selected item (vertical list, scrolling page) ]

CalcLongListIndex:
@069e:  phb
        lda     #$00
        pha
        plb
@06a3:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @06a3
        lda     $53                     ; max x position
        sta     hM7A
        stz     hM7A
        lda     $50                     ; current y position (absolute)
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     $4f                     ; current x position (absolute)
        sta     $4b                     ; $4b = $53 * $50 + $4f
        plb
        rts

; ------------------------------------------------------------------------------

; [ update cursor sprite position ]

SetCursorPos:
@06c5:  phb
        lda     #$00
        pha
        plb
        lda     $53
        dec
        cmp     $4d
        bcs     @06dd
        lda     $53
        dec
        sec
        sbc     $51
        sta     $e0
        sta     $e2
        bra     @06e5
@06dd:  lda     $53
        sta     $e0
        lda     $4d
        sta     $e2
@06e5:  lda     $54
        dec
        cmp     $4e
        bcs     @06f6
        lda     $54
        dec
        sec
        sbc     $52
        sta     $e1
        bra     @06fa
@06f6:  lda     $4e
        sta     $e1
@06fa:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @06fa
        lda     $e0
        sta     hM7A
        stz     hM7A
        lda     $e1
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     $e2
        asl
        xba
        lda     $00
        xba
        tay
        lda     [$e7],y
        sta     $55
        stz     $56
        iny
        lda     [$e7],y
        sta     $57
        stz     $58
        plb
        rts

; ------------------------------------------------------------------------------

; [ update cursor movement (single page) ]

MoveCursor:

; up
@072d:  lda     $0b                     ; branch if up button is not pressed
        bit     #$08
        beq     @0750
        lda     $4e
        bne     @0748
        lda     $59
        and     #$01
        bne     @07af
        lda     $54
        dec
        sta     $4e
        jsr     PlayMoveSfx
        jmp     @07af
@0748:  dec     $4e
        jsr     PlayMoveSfx
        jmp     @07af

; down
@0750:  lda     $0b                     ; branch if down button is not pressed
        bit     #$04
        beq     @0773
        lda     $54
        dec
        cmp     $4e
        bne     @076b
        lda     $59
        and     #$01
        bne     @07af
        stz     $4e
        jsr     PlayMoveSfx
        jmp     @07af
@076b:  inc     $4e
        jsr     PlayMoveSfx
        jmp     @07af

; left
@0773:  lda     $0b                     ; branch if left button is not pressed
        bit     #$02
        beq     @0792
        lda     $4d
        bne     @078b
        lda     $59
        bmi     @07af
        lda     $53
        dec
        sta     $4d
        jsr     PlayMoveSfx
        bra     @07af
@078b:  dec     $4d
        jsr     PlayMoveSfx
        bra     @07af

; right
@0792:  lda     $0b                     ; branch if right button is not pressed
        bit     #$01
        beq     @07af
        lda     $53
        dec
        cmp     $4d
        bne     @07aa
        lda     $59
        bmi     @07af
        stz     $4d
        jsr     PlayMoveSfx
        bra     @07af
@07aa:  inc     $4d
        jsr     PlayMoveSfx
@07af:  rts

; ------------------------------------------------------------------------------

; [ create cursor sprite task ]

CreateCursorTask:
@07b0:  lda     #1                      ; priority 1
        ldy     #.loword(CursorTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ cursor sprite task ]

CursorTask:
@07b8:  tax
        jmp     (.loword(CursorTaskTbl),x)

CursorTaskTbl:
@07bc:  .addr   CursorTask_00
        .addr   CursorTask_01

; ------------------------------------------------------------------------------

; state $00: init
CursorTask_00:
@07c0:  ldx     $2d
        longa
        lda     #.loword(CursorAnimData)
        sta     $32c9,x
        shorta
        lda     #^CursorAnimData
        sta     $35ca,x
        jsr     InitAnimTask
        inc     $3649,x                 ; increment task state
        lda     #$01
        sta     $364a,x                 ; sprite doesn't scroll with bg
; fallthrough

; ------------------------------------------------------------------------------

; state $01: update
CursorTask_01:
@07dc:  lda     $46                     ; terminate if cursor 1 & 2 are inactive
        and     #$06
        beq     @07fd
        lda     $45                     ;
        bit     #$04
        beq     @07fb
        ldx     $2d                     ; task data pointer
        longa
        lda     $55                     ; set cursor x position
        sta     $33ca,x
        lda     $57                     ; set cursor y position
        sta     $344a,x
        shorta
        jsr     UpdateAnimTask
@07fb:  sec
        rts
@07fd:  clc
        rts

; ------------------------------------------------------------------------------

; [ flashing cursor task ]

FlashingCursorTask:
@07ff:  tax
        jmp     (.loword(FlashingCursorTaskTbl),x)

FlashingCursorTaskTbl:
@0803:  .addr   FlashingCursorTask_00
        .addr   FlashingCursorTask_01
        .addr   FlashingCursorTask_02
        .addr   FlashingCursorTask_03

; ------------------------------------------------------------------------------

; state $00, $02: init
FlashingCursorTask_00:
FlashingCursorTask_02:
@080b:  ldx     $2d                     ; task data pointer
        lda     #$01
        tsb     $46                     ; flashing cursor task is active
        longa
        lda     #.loword(FlashingCursorAnimData)
        sta     $32c9,x
        shorta
        lda     #^FlashingCursorAnimData
        sta     $35ca,x
        jsr     InitAnimTask
        lda     #$01
        sta     $364a,x                 ; sprite doesn't scroll with bg
        inc     $3649,x                 ; increment task state
; fall through

; ------------------------------------------------------------------------------

; state $01: update (vertical scroll)
FlashingCursorTask_01:
@082b:  lda     $46                     ; terminate if flashing cursor not active
        bit     #$01
        beq     _0865
        ldx     $2d                     ; task data pointer
        longa
        lda     $41
        eor     #$ffff                  ;
        inc
        clc
        adc     $344a,x
        sta     $344a,x                 ; set vertical offset
        shorta
        lda     $46
        and     #$c0
        beq     @0860
        lda     $28                     ; $e1 = current selection
        sta     $e1
        inc
        sta     $e0                     ; $e0 = current selection + 1
        lda     $4a                     ; page scroll position + 9
        clc                             ; note: page must be at least 10 lines
        adc     #9
        cmp     $e1
        bcc     @0863                   ; return if flashing cursor past bottom
        lda     $4a
        cmp     $e0
        bcs     @0863                   ; return if flashing cursor past top
@0860:  jsr     UpdateAnimTask
@0863:  sec
        rts
_0865:  clc
        rts

; ------------------------------------------------------------------------------

; state $03: update (horizontal scroll)
FlashingCursorTask_03:
@0867:  lda     $46                     ; terminate if flashing cursor not active
        bit     #$01
        beq     _0865
        ldx     $2d                     ; task data pointer
        longa
        lda     $97
        eor     #$ffff                  ;
        inc
        clc
        adc     $33ca,x
        sta     $33ca,x                 ; set horizontal offset
        shorta
        ldy     $33ca,x                 ; return if offscreen to the right
        cpy     #$0100
        bcs     @088b
        jsr     UpdateAnimTask
@088b:  sec
        rts

; ------------------------------------------------------------------------------

; animation data (cursor)
CursorAnimData:
@088d:  .addr   CursorSpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

; sprite data (cursor)
CursorSpriteData:
@0890:  .byte   1
        .byte   $80,$00,$00,$3e

; ------------------------------------------------------------------------------

; sprite data (flashing cursor)
HiddenCursorSpriteData:
@0895:  .byte   0

; ------------------------------------------------------------------------------

; animation data (flashing cursor)
FlashingCursorAnimData:
@0896:  .addr   CursorSpriteData
        .byte   2
        .addr   HiddenCursorSpriteData
        .byte   2
        .addr   CursorSpriteData
        .byte   $ff

; ------------------------------------------------------------------------------

; [ create multi-cursor ]

CreateMultiCursorTask:
@089f:  clr_ax
@08a1:  lda     $85,x                   ; cursor position for character slot 1
        beq     @08c9                   ; branch if slot is empty
        phx
        lda     #1
        ldy     #.loword(MultiCursorTask)
        jsr     CreateTask
        txy
        plx
        lda     #$7e
        pha
        plb
        lda     $85,x                   ; set cursor position
        sta     $33ca,y
        lda     $86,x
        sta     $344a,y
        clr_a
        sta     $33cb,y                 ; clear high byte of x and y position
        sta     $344b,y
        lda     #$00
        pha
        plb
@08c9:  inx2                            ; next character slot
        cpx     #8
        bne     @08a1
        rts

; ------------------------------------------------------------------------------

; [ multi-cursor task ]

MultiCursorTask:
@08d1:  tax
        jmp     (.loword(MultiCursorTaskTbl),x)

MultiCursorTaskTbl:
@08d5:  .addr   MultiCursorTask_00
        .addr   MultiCursorTask_01

; ------------------------------------------------------------------------------

; state 0: init
MultiCursorTask_00:
@08d9:  ldx     $2d
        lda     #$08                    ; activate multi-cursor
        tsb     $46
        longa
        lda     #.loword(FlashingCursorAnimData)
        sta     $32c9,x
        shorta
        lda     #^FlashingCursorAnimData
        sta     $35ca,x
        jsr     InitAnimTask
        inc     $3649,x                 ; increment task state
        lda     #$01
        sta     $364a,x                 ; sprite doesn't scroll with bg

; ------------------------------------------------------------------------------

; state 1: update
MultiCursorTask_01:
@08f9:  lda     $46                     ; terminate if multi-cursor is not active
        bit     #$08
        beq     @0906
        ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts
@0906:  clc
        rts

; ------------------------------------------------------------------------------

; [ update top/bottom page scroll flags ]

UpdateScrollArrowFlags:
@0908:  lda     #$c0
        tsb     $46
        lda     $4a                     ; branch if not at page 0
        bne     @0914
        lda     #$40                    ; page can't scroll up
        trb     $46
@0914:  lda     $4a                     ; branch if not at max page scroll position
        cmp     $5c
        bne     @091e
        lda     #$80                    ; page can't scroll down
        trb     $46
@091e:  rts

; ------------------------------------------------------------------------------

; [ init scroll indicator task (item/skills list) ]

CreateScrollArrowTask1:
@091f:  lda     #3                      ; priority 3
        ldy     #.loword(ScrollArrowTask)
        jsr     CreateTask
        longa
        lda     #$00e8                  ; x offset
        sta     $7e33ca,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init scroll indicator task (equip/relic item list) ]

CreateScrollArrowTask2:
@0933:  lda     #3                      ; priority 3
        ldy     #.loword(ScrollArrowTask)
        jsr     CreateTask
        longa
        lda     #$0078                  ; x offset
        sta     $7e33ca,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ scroll indicator arrow task ]

ScrollArrowTask:
@0947:  tax
        jmp     (.loword(ScrollArrowTaskTbl),x)

ScrollArrowTaskTbl:
@094b:  .addr   ScrollArrowTask_00
        .addr   ScrollArrowTask_01

; ------------------------------------------------------------------------------

; state $00: init
ScrollArrowTask_00:
@094f:  ldx     $2d
        longa
        lda     #.loword(ScrollArrowAnimData_00)
        sta     $32c9,x
        shorta
        lda     #^ScrollArrowAnimData_00
        sta     $35ca,x
        inc     $3649,x                 ; increment task state
        jsr     InitAnimTask
        lda     #$c0
        tsb     $46                     ; enable scrolling up and down
; fall through

; ------------------------------------------------------------------------------

; state $01: update
ScrollArrowTask_01:
@096a:  lda     $46                     ; scroll page flags
        and     #$c0
        beq     @09d9                   ; terminate task if page can't scroll up or down
        ldx     $2d                     ; task data pointer
        jsr     UpdateScrollArrowFlags
@0975:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @0975
        lda     $354a,x                 ;
        sta     f:hM7A
        lda     $354b,x
        sta     f:hM7A
        lda     $4a                     ; page scroll position
        sta     f:hM7B
        sta     f:hM7B
        lda     $4a
        bmi     @09aa
        clr_a
        lda     f:hMPYM
        longa_clc
        adc     $34ca,x
        sta     $344a,x                 ; set vertical offset
        shorta
        bra     @09bd
@09aa:  clr_a
        lda     f:hMPYM
        longa_clc
        adc     #$0070
        clc
        adc     $34ca,x
        sta     $344a,x                 ; set vertical offset
        shorta
@09bd:  clr_a
        lda     $46                     ; scroll page flags
        and     #$c0
        lsr5
        txy
        tax
        longa
        lda     f:ScrollArrowAnimDataTbl,x
        sta     $32c9,y
        shorta
        jsr     UpdateAnimTask
        sec
        rts
@09d9:  clc
        rts

; ------------------------------------------------------------------------------

; pointers to animation data
ScrollArrowAnimDataTbl:
@09db:  .addr   ScrollArrowAnimData_00
        .addr   ScrollArrowAnimData_01
        .addr   ScrollArrowAnimData_02
        .addr   ScrollArrowAnimData_03

; ------------------------------------------------------------------------------

; can scroll both up and down
ScrollArrowAnimData_00:
ScrollArrowAnimData_03:
@09e3:  .addr   ScrollArrowSpriteDataNone
        .byte   $10
        .addr   ScrollArrowSpriteDataBoth
        .byte   $10
        .addr   ScrollArrowSpriteDataNone
        .byte   $ff

; can scroll up only
ScrollArrowAnimData_01:
@09ec:  .addr   ScrollArrowSpriteDataNone
        .byte   $10
        .addr   ScrollArrowSpriteDataUp
        .byte   $10
        .addr   ScrollArrowSpriteDataNone
        .byte   $ff

; can scroll down only
ScrollArrowAnimData_02:
@09f5:  .addr   ScrollArrowSpriteDataNone
        .byte   $10
        .addr   ScrollArrowSpriteDataDown
        .byte   $10
        .addr   ScrollArrowSpriteDataNone
        .byte   $ff

; ------------------------------------------------------------------------------

; sprite data
ScrollArrowSpriteDataNone:
@09fe:  .byte   2
        .byte   $00,$00,$02,$3e
        .byte   $00,$08,$02,$be

ScrollArrowSpriteDataBoth:
@0a07:  .byte   2
        .byte   $00,$00,$12,$3e
        .byte   $00,$08,$12,$be

ScrollArrowSpriteDataUp:
@0a10:  .byte   2
        .byte   $00,$00,$12,$3e
        .byte   $00,$08,$02,$be

ScrollArrowSpriteDataDown:
@0a19:  .byte   2
        .byte   $00,$00,$02,$3e
        .byte   $00,$08,$12,$be

; ------------------------------------------------------------------------------

; [ create portrait task (slot 1) ]

CreatePortraitTask1:
@0a22:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        txa
        sta     $60
        phb
        lda     #$7e
        pha
        plb
        ldy     $00
        jsr     InitPortraitRowPos
        ldy     $00
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0015
        sta     $344a,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 2) ]

CreatePortraitTask2:
@0a4b:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        txa
        sta     $61
        phb
        lda     #$7e
        pha
        plb
        ldy     #1
        jsr     InitPortraitRowPos
        ldy     #1
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0045
        sta     $344a,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 3) ]

CreatePortraitTask3:
@0a76:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        txa
        sta     $62
        phb
        lda     #$7e
        pha
        plb
        ldy     #2
        jsr     InitPortraitRowPos
        ldy     #2
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0075
        sta     $344a,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 4) ]

CreatePortraitTask4:
@0aa1:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        txa
        sta     $63
        phb
        lda     #$7e
        pha
        plb
        ldy     #3
        jsr     InitPortraitRowPos
        ldy     #3
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$00a5
        sta     $344a,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ init portrait task animation data pointer ]

; +y = character slot

GetPortraitAnimDataPtr:
@0acc:  phx
        phx
        tyx
        lda     $75,x
        and     #$18
        lsr2
        tax
        longa
        lda     f:PortraitAnimDataTbl,x
        ply
        sta     $32c9,y     ; set pointer to animation data
        shorta
        lda     #^Portrait1AnimData
        sta     $35ca,y
        plx
        rts

; ------------------------------------------------------------------------------

; pointers to portrait animation data
PortraitAnimDataTbl:
@0ae9:  .addr   Portrait1AnimData
        .addr   Portrait2AnimData
        .addr   Portrait3AnimData
        .addr   Portrait4AnimData

; ------------------------------------------------------------------------------

; [ init portrait task x offset ]

; +y = character slot

InitPortraitRowPos:
@0af1:  phx
        tyx
        lda     #$02        ;
        bit     $45
        bne     @0aff
        lda     $75,x       ; character row
        bit     #$20
        beq     @0b06       ; branch if front row
@0aff:  longa
        lda     #$001a      ; x offset = 26
        bra     @0b0b
@0b06:  longa
        lda     #$000e      ; x offset = 14
@0b0b:  plx
        sta     $33ca,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ portrait task ]

PortraitTask:
@0b12:  tax
        jmp     (.loword(PortraitTaskTbl),x)

PortraitTaskTbl:
@0b16:  .addr   PortraitTask_00
        .addr   PortraitTask_01
        .addr   PortraitTask_02
        .addr   PortraitTask_03
        .addr   PortraitTask_04

; ------------------------------------------------------------------------------

; state $00: init
PortraitTask_00:
@0b20:  ldx     $2d
        inc     $3649,x
        lda     #1
        sta     $364a,x
; fall through

; ------------------------------------------------------------------------------

; state $01: update
PortraitTask_01:
@0b2a:  ldx     $2d
        lda     $35c9,x
        bmi     @0b36
        jsr     UpdateAnimTask
        sec
        rts
@0b36:  clc
        rts

; ------------------------------------------------------------------------------

; state $02: slide to the right
PortraitTask_02:
@0b38:  ldx     $2d
        longa
        lda     #$0001
        sta     $34ca,x
        lda     #12
        sta     $3349,x
        shorta
        bra     PortraitTask_04

; ------------------------------------------------------------------------------

; state $03: slide to the left
PortraitTask_03:
@0b4c:  ldx     $2d
        longa
        lda     #$ffff
        sta     $34ca,x
        lda     #12
        sta     $3349,x
        shorta
; fall through

; ------------------------------------------------------------------------------

; state $04: wait for slide
PortraitTask_04:
@0b5e:  ldx     $2d
        lda     #4                      ; state on state 4
        sta     $3649,x
        longa
        lda     $3349,x                 ; branch if slide complete
        beq     @0b80
        lda     $34ca,x                 ; increase horizontal position
        clc
        adc     $33ca,x
        sta     $33ca,x
        dec     $3349,x                 ; decrement movement counter
        shorta
        jsr     UpdateAnimTask
        sec
        rts

; slide complete
@0b80:  shorta
        lda     #1                      ; back to state 1
        sta     $3649,x
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; portrait slot 1 animation data
Portrait1AnimData:
@0b8c:  .addr   Portrait1SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

; portrait slot 1 sprite data
Portrait1SpriteData:
@0b8f:  .byte   13
        .byte   $80,$00,$60,$20
        .byte   $90,$00,$62,$20
        .byte   $80,$10,$64,$20
        .byte   $90,$10,$66,$20
        .byte   $20,$00,$68,$20
        .byte   $20,$08,$69,$20
        .byte   $20,$10,$6a,$20
        .byte   $20,$18,$6b,$20
        .byte   $20,$20,$6c,$20
        .byte   $00,$20,$6d,$20
        .byte   $08,$20,$6e,$20
        .byte   $10,$20,$6f,$20
        .byte   $18,$20,$78,$20

; ------------------------------------------------------------------------------

Portrait2AnimData:
@0bc4:  .addr   Portrait2SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

Portrait2SpriteData:
@0bc7:  .byte   13
        .byte   $80,$00,$80,$22
        .byte   $90,$00,$82,$22
        .byte   $80,$10,$84,$22
        .byte   $90,$10,$86,$22
        .byte   $20,$00,$88,$22
        .byte   $20,$08,$89,$22
        .byte   $20,$10,$8a,$22
        .byte   $20,$18,$8b,$22
        .byte   $20,$20,$8c,$22
        .byte   $00,$20,$8d,$22
        .byte   $08,$20,$8e,$22
        .byte   $10,$20,$8f,$22
        .byte   $18,$20,$98,$22

; ------------------------------------------------------------------------------

Portrait3AnimData:
@0bfc:  .addr   Portrait3SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

Portrait3SpriteData:
@0bff:  .byte   13
        .byte   $80,$00,$a0,$24
        .byte   $90,$00,$a2,$24
        .byte   $80,$10,$a4,$24
        .byte   $90,$10,$a6,$24
        .byte   $20,$00,$a8,$24
        .byte   $20,$08,$a9,$24
        .byte   $20,$10,$aa,$24
        .byte   $20,$18,$ab,$24
        .byte   $20,$20,$ac,$24
        .byte   $00,$20,$ad,$24
        .byte   $08,$20,$ae,$24
        .byte   $10,$20,$af,$24
        .byte   $18,$20,$b8,$24

; ------------------------------------------------------------------------------

Portrait4AnimData:
@0c34:  .addr   Portrait4SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

Portrait4SpriteData:
@0c37:  .byte   13
        .byte   $80,$00,$c0,$26
        .byte   $90,$00,$c2,$26
        .byte   $80,$10,$c4,$26
        .byte   $90,$10,$c6,$26
        .byte   $20,$00,$c8,$26
        .byte   $20,$08,$c9,$26
        .byte   $20,$10,$ca,$26
        .byte   $20,$18,$cb,$26
        .byte   $20,$20,$cc,$26
        .byte   $00,$20,$cd,$26
        .byte   $08,$20,$ce,$26
        .byte   $10,$20,$cf,$26
        .byte   $18,$20,$d8,$26

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text ]

; +x = pointer to destination bg data addresses (+$c30000)
; pointer order is lv, current hp, max hp, current mp, max mp (2 bytes each, +$7e0000)

DrawCharBlock:
@0c6c:  stx     $ef         ; set pointer to bg data address
        lda     #^*
        sta     $f1
        ldx     $67         ; pointer to character data
        lda     a:$0008,x     ; character level
        jsr     HexToDec3
        longa
        lda     [$ef]       ; get bg data address
        tax
        shorta
        jsr     DrawNum2
        ldx     $67
        lda     a:$000b,x     ; max hp
        sta     $f3
        lda     a:$000c,x
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        jsr     HexToDec5
        ldy     #$0004
        jsr     DrawHPMP
        ldy     $67
        jsr     CheckMaxHP
        lda     $0009,y     ; current hp
        sta     $f3
        lda     $000a,y
        sta     $f4
        jsr     HexToDec5
        ldy     #$0002
        jsr     DrawHPMP
        jsr     CheckMPVisible
        bcc     @0cef
        ldx     $67
        lda     a:$000f,x     ; max mp
        sta     $f3
        lda     a:$0010,x
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        jsr     HexToDec5
        ldy     #$0008
        jsr     DrawHPMP
        ldy     $67
        jsr     CheckMaxMP
        lda     $000d,y     ; current mp
        sta     $f3
        lda     $000e,y
        sta     $f4
        jsr     HexToDec5
        ldy     #$0006
        jmp     DrawHPMP
@0cef:  ldx     #$9e8b
        stx     hWMADDL
        longa
        ldy     #$0006
        lda     [$ef],y
        sec
        sbc     #$0006
        sta     $7e9e89
        shorta
        ldx     #$000c
        lda     #$ff
@0d0b:  sta     hWMDATA
        dex
        bne     @0d0b
        stz     hWMDATA
        ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

; [ draw hp/mp text ]

DrawHPMP:
@0d21:  longa
        lda     [$ef],y
        tax
        shorta
        jmp     DrawNum4

; ------------------------------------------------------------------------------

; [ check if character has mp ]

; carry set = has mp, carry cleared = no mp

CheckMPVisible:
@0d2b:  lda     $1a69       ; set carry and return if the party has any espers
        ora     $1a6a
        ora     $1a6b
        ora     $1a6c
        bne     @0d63
        ldx     $67
        clr_a
        lda     a:$0000,x     ; set carry and return if the character is gogo
        cmp     #$0c
        beq     @0d63
        bcs     @0d61       ; clear carry and return if the character is higher than gogo
        sta     hWRMPYA
        lda     #$36        ; get pointer to character's spell list
        sta     hWRMPYB
        nop3
        ldy     #$0036
        ldx     hRDMPYL
@0d56:  lda     $1a6e,x     ; check each spell
        cmp     #$ff
        beq     @0d63       ; set carry and return if any spells are known
        inx
        dey
        bne     @0d56
@0d61:  clc                 ; clear carry (don't show mp)
        rts
@0d63:  sec                 ; set carry (show mp)
        rts

; ------------------------------------------------------------------------------

; [ calculate max hp/mp w/ boost ]

; +$f3 = bbhhhhhh hhhhhhhh
;        b: boost
;        h: max hp/mp

CalcMaxHPMP:
@0d65:  longa
        lda     $f3
        and     #$3fff
        sta     $e7
        lda     $f3
        and     #$c000
        clc
        rol4
        tax
        lda     $e7
        jmp     (.loword(MaxHPMPTbl),x)

; ------------------------------------------------------------------------------

; hp/mp boost jump table
MaxHPMPTbl:
@0d7e:  .addr   MaxHPMP_00
        .addr   MaxHPMP_01
        .addr   MaxHPMP_02
        .addr   MaxHPMP_03

; ------------------------------------------------------------------------------

MaxHPMP_00:
@0d86:  clr_a                             ; 0: no boost

MaxHPMP_03:
@0d87:  lsr                             ; 3: 12.5% boost

MaxHPMP_01:
@0d88:  lsr                             ; 1: 25% boost

MaxHPMP_02:
@0d89:  lsr                             ; 2: 50% boost
        clc
        adc     $e7
        sta     $f3
        shorta
        rts

; ------------------------------------------------------------------------------

; [ check max hp (9999) ]

; +$f3 = number to max out

ValidateMaxHP:
@0d92:  ldx     $f3
        cpx     #10000
        bcc     @0d9e
        ldx     #9999
        stx     $f3
@0d9e:  rts

; ------------------------------------------------------------------------------

; [ check max mp (999) ]

; +$f3 = number to max out

ValidateMaxMP:
@0d9f:  ldx     $f3
        cpx     #1000
        bcc     @0dab
        ldx     #999
        stx     $f3
@0dab:  rts

; ------------------------------------------------------------------------------

; [ restore saved cursor position (item list) ]

RestoreItemCursorPos:
@0dac:  ldy     $022f
        sty     $4f
        lda     $4f
        sta     $4d
        lda     $0231
        bra     _0e1e

; ------------------------------------------------------------------------------

; [ swap two characters' saved cursor positions ]

SwapSavedCharCursorPos:
@0dba:  clr_a
        lda     $4b
        asl
        tax
        lda     $28
        asl
        tay
        longa
        lda     $0236,x     ; saved skills cursor position
        sta     $e7
        lda     $0236,y
        sta     $0236,x
        lda     $e7
        sta     $0236,y
        lda     $023e,x
        sta     $e7
        lda     $023e,y
        sta     $023e,x
        lda     $e7
        sta     $023e,y
        shorta
        clr_a
        lda     $4b
        tax
        lda     $28
        tay
        lda     $0246,x
        sta     $e0
        lda     $0246,y
        sta     $0246,x
        lda     $e0
        sta     $0246,y
        rts

; ------------------------------------------------------------------------------

; [ restore saved cursor position (skills) ]

RestoreSkillsCursorPos:
@0dff:  clr_a
        lda     $28         ; selected character slot
        asl
        tax
        ldy     $0236,x     ; saved skills cursor position
        sty     $4d
        rts

; ------------------------------------------------------------------------------

; [ restore saved cursor position (magic) ]

RestoreMagicCursorPos:
@0e0a:  clr_a
        lda     $28
        asl
        tax
        ldy     $023e,x     ; saved magic cursor position
        sty     $4f
        lda     $4f
        sta     $4d
        lda     $28
        tax
        lda     $0246,x     ; saved magic page scroll position
_0e1e:  sta     $4a
        lda     $50
        sec
        sbc     $4a
        sta     $4e
        rts

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens A & B) ]

TfrBG1ScreenAB:
@0e28:  ldy     #$0000
        sty     hVMADDL
        ldy     #$3849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens B & C) ]

TfrBG1ScreenBC:
@0e36:  ldy     #$0400
        sty     hVMADDL
        ldy     #$4049
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens C & D) ]

TfrBG1ScreenCD:
@0e44:  ldy     #$0800
        sty     hVMADDL
        ldy     #$4849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (screens A & B) ]

TfrBG2ScreenAB:
@0e52:  ldy     #$1000
        sty     hVMADDL
        ldy     #$5849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (screens C & D) ]

TfrBG2ScreenCD:
@0e60:  ldy     #$1800
        sty     hVMADDL
        ldy     #$6849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (screens A & B) ]

TfrBG3ScreenAB:
@0e6e:  ldy     #$4000
        sty     hVMADDL
        ldy     #$7849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (screens C & D) ]

TfrBG3ScreenCD:
@0e7c:  ldy     #$4800
        sty     hVMADDL
        ldy     #$8849
        sty     $4302
; fall through

; copy bg data to vram
TfrBGTiles:
@0e88:  lda     #$01        ; two address - low, high
        sta     $4300
        lda     #$18
        sta     $4301
        lda     #$7e
        sta     $4304
        ldy     #$1000      ; dma size (two screens)
        sty     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ play cursor sound effect (move) ]

PlayMoveSfx:
@0ea3:  lda     $ae         ; return if sound effect is already being played this frame
        cmp     #$21
        beq     _0eb1
; fall through

; ------------------------------------------------------------------------------

; [ play cursor sound effect (cancel) ]

PlayCancelSfx:
@0ea9:  lda     #$21
        sta     $ae
        sta     f:hAPUIO0
_0eb1:  rts

; ------------------------------------------------------------------------------

; [ play cursor sound effect (select) ]

PlaySelectSfx:
@0eb2:  lda     #$20
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play success sound effect ]

PlaySuccessSfx:
@0eb9:  lda     #$23
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play invalid sound effect ]

PlayInvalidSfx:
@0ec0:  lda     #$22
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play delete/erase sound effect ]

PlayEraseSfx:
@0ec7:  lda     #$24
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play cash register sound effect ]

PlayShopSfx:
@0ece:  lda     #$bf
_0ed0:  sta     f:$001301
        lda     #$18
        sta     f:$001300
        lda     #$80
        sta     f:$001302
        jsl     ExecSound_ext
        rts

; ------------------------------------------------------------------------------

; [ play cure/item sound effect ]

PlayCureSfx:
@0ee5:  lda     #$c5
        bra     _0ed0

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screens A & B) ]

InitDMA1BG1ScreenAB:
@0ee9:  ldy     #$0000
        sty     $14
        ldy     #$3849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$1000
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screen A) ]

InitDMA1BG1ScreenA:
@0efd:  ldy     #$0000
        sty     $14
        ldy     #$3849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$0800
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screen B) ]

InitDMA1BG1ScreenB:
@0f11:  ldy     #$0400
        sty     $14
        ldy     #$4049
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$0800
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screens A & B) ]

InitDMA1BG3ScreenAB:
@0f25:  ldy     #$4000
        sty     $14
        ldy     #$7849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$1000
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screen A) ]

InitDMA1BG3ScreenA:
@0f39:  ldy     #$4000
        sty     $14
        ldy     #$7849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$0800
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screen B) ]

InitDMA1BG3ScreenB:
@0f4d:  ldy     #$4400
        sty     $14
        ldy     #$8049
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$0800
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ init dma 2 (bg3 data, screen A) ]

InitDMA2BG3ScreenA:
@0f61:  ldy     #$4000
        sty     $1b
        ldy     #$7849
        sty     $1d
        lda     #$7e
        sta     $1f
        ldy     #$0800
        sty     $19
        rts

; ------------------------------------------------------------------------------

; [ init dma 2 (bg3 data, screen B) ]

InitDMA2BG3ScreenB:
@0f75:  ldy     #$4400
        sty     $1b
        ldy     #$8049
        sty     $1d
        lda     #$7e
        sta     $1f
        ldy     #$0800
        sty     $19
        rts

; ------------------------------------------------------------------------------

; [ disable dma 2 ]

DisableDMA2:
@0f89:  stz     $1b
        stz     $1c
        rts

; ------------------------------------------------------------------------------

; [ load color palette ]

;  A: source bank
; +X: source address
; +Y: destination address (+$7e0000)

LoadPal:
@0f8e:  sta     $ed
        sty     $e7
        stx     $eb
        lda     #$7e
        sta     $e9
        ldy     $00
        longa
@0f9c:  lda     [$eb],y
        sta     [$e7],y
        iny2
        cpy     #$0020
        bne     @0f9c
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create fade in/out palette task ]

;   A: speed (frames per update)
;  +X: source address
;  +Y: destination address (+$7e0000)
; $ed: source bank

CreateFadePalTask:
@0faa:  pha
        sty     $e7
        stx     $eb
        lda     #$7e
        sta     $e9
        lda     #0
        ldy     #.loword(FadePalTask)
        jsr     CreateTask
        pla
        sta     $7e37ca,x
        lda     $e9
        sta     $7e36c9,x
        lda     $ed
        sta     $7e36ca,x
        longa
        lda     $e7
        sta     $7e33c9,x
        lda     $eb
        sta     $7e3449,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ fade in/out palette task ]

; +$3349 = color counter
; +$33c9 = destination address (+$7e0000)
; +$3449 = source address
;  $35c9 = frame counter
;  $36c9 = destination bank (always $7e)
;  $36ca = source bank
;  $37ca = speed (frames per update)

FadePalTask:
@0fdd:  tax
        jmp     (.loword(FadePalTaskTbl),x)

FadePalTaskTbl:
@0fe1:  .addr   FadePalTask_00
        .addr   FadePalTask_01

; ------------------------------------------------------------------------------

; state 0: init
FadePalTask_00:
@0fe5:  ldx     $2d
        lda     #$1f
        sta     $3349,x                 ; set color counter to 31
        lda     $00
        sta     $334a,x
        inc     $3649,x                 ; increment task state
        sec
        rts

; ------------------------------------------------------------------------------

; state 1: update
FadePalTask_01:
@0ff6:  ldx     $2d
        lda     $35c9,x                 ; branch if waiting for frame counter
        bne     @1032
        lda     $37ca,x                 ; set frame counter
        sta     $35c9,x
        lda     $36c9,x                 ; +$e0 = destination address
        sta     $e2
        lda     $36ca,x                 ; +$e3 = source address
        sta     $e5
        longa
        lda     $33c9,x
        sta     $e0
        lda     $3449,x
        sta     $e3
        lda     $3349,x                 ; $f1 = color counter value
        sta     $f1
        jsr     UpdateFadePal
        shorta
        ldx     a:$002d                 ; task data pointer
        lda     $3349,x                 ; decrement color counter
        beq     @1030
        dec     $3349,x
        bne     @1032                   ; terminate task when color counter reaches zero
@1030:  clc
        rts
@1032:  dec     $35c9,x                 ; decrement frame counter
        sec
        rts

; ------------------------------------------------------------------------------

; [ update palette ]

.a16

UpdateFadePal:
@1037:  ldx     #16                     ; 16 colors
        ldy     $00
@103c:  lda     [$e0],y                 ; $e7 = current color value (destination)
        sta     $e7
        lda     [$e3],y                 ; $e9 = target color value (source)
        sta     $e9
        jsr     UpdateFadeColor
        lda     $e7
        sta     [$e0],y                 ; set current color value
        iny2                            ; next color
        dex
        bne     @103c
        rts

; ------------------------------------------------------------------------------

; [ update color ]

UpdateFadeColor:
@1051:  lda     $e7                     ; current color
        and     #$001f                  ; isolate red
        sta     $eb
        lda     $e9                     ; target color
        and     #$001f                  ; isolate red
        sec
        sbc     $eb                     ; subtract current red
        beq     @106e                   ; branch if zero
        bcc     @106c                   ; branch if negative
        cmp     $f1
        bcc     @106e                   ; branch if less than color counter
        inc     $eb                     ; increment current red
        bra     @106e
@106c:  dec     $eb                     ; decrement current red
@106e:  lda     $e7
        and     #$03e0                  ; isolate green
        sta     $ed
        lda     $e9
        and     #$03e0
        sec
        sbc     $ed
        beq     @109b
        bcc     @1093
        asl3
        xba
        cmp     $f1
        bcc     @109b
        clc
        lda     $ed
        adc     #$0020
        sta     $ed
        bra     @109b
@1093:  lda     $ed
        sec
        sbc     #$0020
        sta     $ed
@109b:  lda     $e7
        and     #$7c00                  ; isolate blue
        sta     $ef
        lda     $e9
        and     #$7c00
        sec
        sbc     $ef
        beq     @10cb
        bcc     @10c3
        shorta
        xba
        lsr2
        longa
        cmp     $f1
        bcc     @10cb
        clc
        lda     $ef
        adc     #$0400
        sta     $ef
        bra     @10cb
@10c3:  lda     $ef
        sec
        sbc     #$0400
        sta     $ef
@10cb:  lda     $eb                     ; combine red, green, and blue
        ora     $ed
        ora     $ef
        sta     $e7                     ; set current color
        rts

.a8

; ------------------------------------------------------------------------------

; white color palette
WhitePal:
@10d4:  .word   $0000,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff
        .word   $7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff

; black color palette
BlackPal:
@10f4:  .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; [ reset tasks ]

ResetTasks:
@1114:  ldx     $00
        stx     $2d                     ; clear task pointer and number of active tasks
        stx     $2f
        longa
        jsr     ResetSprites
        shorti
        ldx     #$7e
        phx
        plb
        ldx     #0
@1127:  stz     $3249,x                 ; clear task data
        stz     $3649,x
        stz     $35c9,x
        stz     $3749,x
        stz     $33c9,x
        stz     $3449,x
        stz     $34c9,x
        stz     $3549,x
        inx2
        cpx     #$80
        bne     @1127
        ldx     #$00
        phx
        plb
        shorta
        longi
        rts

; ------------------------------------------------------------------------------

; [ clear sprite data ]

.a16

ResetSprites:
@114e:  ldx     $00
@1150:  lda     #$e001
        sta     $0300,x                 ; move all sprites offscreen
        inx2
        lda     #$0001
        sta     $0300,x
        inx2
        cpx     #$0200
        bne     @1150
        ldy     $00                     ; clear high sprite data
        tya
@1168:  sta     $0500,y
        iny2
        cpy     #$0020
        bne     @1168
        rts

.a8

; ------------------------------------------------------------------------------

; [ create task ]

; A: priority
; Y: address

CreateTask:
@1173:  tax
        lda     #$7e
        pha
        plb
        txa
        jsr     InitTask
        shorta
        lda     #$00
        pha
        plb
        lda     $2d
        sta     $7e374a,x               ; set task data pointer
        inc     $2f                     ; increment the number of active tasks
        rts

; ------------------------------------------------------------------------------

; [ init task code pointer ]

; A: priority

InitTask:
@118b:  xba
        lda     #$00
        xba
        asl4
        longa
        tax
@1196:  lda     $3249,x                 ; find the first available task in this priority level
        bne     @11a0
        tya
        sta     $3249,x                 ; set task code pointer
        rts
@11a0:  inx2
        cpx     #$0080
        bne     @1196
        dex2                            ; no empty task found, use the second to last one
        tya
        sta     $3249,x                 ; set task data pointer
@11ad:  bra     @11ad                   ; infinite loop
        rts

.a8

; ------------------------------------------------------------------------------

; [ execute tasks ]

ExecTasks:
@11b0:  phb
        lda     #$7e
        pha
        plb
        ldx     #$0300                  ; set starting pointers to sprite data
        stx     $0e
        ldx     #$0500
        stx     $10
        lda     #$03                    ;
        sta     $33
        stz     $34
        ldx     #$0080                  ; start with $80 unused sprites
        stx     $31
        ldx     $00
        longa
@11ce:  lda     $3249,x                 ; task code pointer
        beq     @11f5                   ; branch if task is not active
        stx     $2d                     ; +$2d = task data pointer
        phx
        sta     $2b                     ; +$2b = task code pointer
        shorta
        clr_a
        lda     $3649,x                 ; task state
        asl
        jsr     @1203                   ; execute task
        longa
        plx
        bcs     @11f5                   ; branch if task didn't terminate
        stz     $3249,x                 ; clear task data
        stz     $3649,x
        stz     $35c9,x
        stz     $3749,x
        dec     $2f                     ; decrement number of active tasks
@11f5:  inx2                            ; next task
        cpx     #$0080
        bne     @11ce
        jsr     HideUnusedSprites
        shorta
        plb
        rts

; execute task (carry clear: terminate, carry set: don't terminate)
@1203:  jmp     ($002b)

; ------------------------------------------------------------------------------

; [ init animation task ]

InitAnimTask:
@1206:  clr_a
        sta     $36c9,x
        longa
        lda     $32c9,x
        sta     $eb
        shorta
        lda     $35ca,x
        sta     $ed
        ldy     #$0002
        lda     [$eb],y
        sta     $36ca,x
        rts

; ------------------------------------------------------------------------------

; [ update animation task ]

UpdateAnimTask:
@1221:  jsr     UpdateAnimData
        jmp     UpdateAnimSprites

; ------------------------------------------------------------------------------

; [ update animation data ]

UpdateAnimData:
@1227:  ldx     $2d                     ; task data pointer
        ldy     $00
        longa
        lda     $32c9,x                 ; ++$eb = animation data pointer
        sta     $eb
        shorta
        lda     $35ca,x
        sta     $ed
@1239:  lda     $36ca,x                 ; next animation data byte
        cmp     #$fe
        beq     @1262                   ; return if $fe (stop animation)
        cmp     #$ff
        bne     @124c                   ; branch if not $ff (repeat)
        stz     $36c9,x                 ; reset animation data offset
        jsr     SetAnimDur
        bra     @1239
@124c:  lda     $36ca,x                 ; frame counter
        bne     @125f                   ; decrement and return if not zero
        lda     $36c9,x                 ; increment animation data offset
        clc
        adc     #3
        sta     $36c9,x
        jsr     SetAnimDur
        bra     @1239
@125f:  dec     $36ca,x                 ; decrement frame counter
@1262:  rts

; ------------------------------------------------------------------------------

; [ set animation frame counter ]

SetAnimDur:
@1263:  shorti
        lda     $36c9,x                 ; animation data offset + 2
        tay
        iny2
        lda     [$eb],y
        sta     $36ca,x                 ; set frame counter
        longi
        rts

; ------------------------------------------------------------------------------

; [ update animation sprites ]

UpdateAnimSprites:
@1273:  shorti
        lda     $36c9,x                 ; animation data offset
        tay
        longa
        lda     [$eb],y                 ; ++$e7 = pointer to sprite data
        sta     $e7
        iny2
        shorta
        lda     $35ca,x
        sta     $e9
        longi
        ldy     $00
        lda     $31                     ; return if there are no unused sprites remaining
        beq     @12fb
        lda     [$e7],y
        sta     $e6                     ; $e6 = number of sprites
        beq     @12fb                   ; return if there are no sprites
        iny
@1297:  lda     [$e7],y                 ; $e0 = x position
        sta     $e0
        bpl     @12b0                   ; branch if not a 32x32 sprite
        clr_a
        lda     $33
        tax
        lda     f:LargeSpriteTbl,x      ; high sprite mask
        clc
        adc     $34
        sta     $34
        sta     ($10)                   ; set sprite high data
        ldx     $2d
        bra     @12b4
@12b0:  lda     $34
        sta     ($10)                   ; set sprite high data
@12b4:  lda     $e0
        and     #$7f
        sta     $e0
        lda     $364a,x
        bit     #$01
        beq     @12ce
        stz     $e1
        longa
        lda     $e0
        sec
        sbc     $35                     ; subtract bg1 horizontal scroll
        sta     $e0
        shorta
@12ce:  jsr     DrawAnimSprite
        dec     $33                     ; decrement pointer to high sprite data masks
        bpl     @12df                   ; branch if positive
        lda     #$03                    ; reset to 3
        sta     $33
        stz     $34                     ; clear current high sprite data byte
        longa
        inc     $10                     ; increment pointer to high sprite data
@12df:  longa
        lda     $e0
        sta     ($0e)                   ; set sprite data (position)
        inc     $0e
        inc     $0e
        lda     $e2
        sta     ($0e)                   ; set sprite data (other bytes)
        inc     $0e
        inc     $0e
        shorta
        dec     $31                     ; decrement number of unused sprites
        beq     @12fb
        dec     $e6                     ; next sprite
        bne     @1297
@12fb:  rts

; ------------------------------------------------------------------------------

; [ update animation sprite data ]

DrawAnimSprite:
@12fc:  lda     $e0                     ; $e0 = x position
        clc
        adc     $33ca,x                 ; add horizontal offset
        sta     $e0
        iny
        lda     [$e7],y                 ; $e1 = y position
        clc
        adc     $344a,x                 ; add vertical offset
        sta     $e1
        iny
        lda     [$e7],y                 ; $e2 = graphics offset
        sta     $e2
        iny
        lda     $364a,x                 ; branch if not flipped horizontal
        bit     #$02
        beq     @1320
        lda     [$e7],y
        ora     #$40
        bra     @1322
@1320:  lda     [$e7],y
@1322:  sta     $e3                     ; $e3 = vhoopppm
        lda     $3749,x                 ; special palette
        beq     @1332
        lda     $e3
        and     #$f1
        ora     $3749,x
        sta     $e3
@1332:  iny
        rts

; ------------------------------------------------------------------------------

; large sprite flags for high sprite data
LargeSpriteTbl:
@1334:  .byte   $80,$20,$08,$02

; ------------------------------------------------------------------------------

; [ hide unused sprites ]

.a16

HideUnusedSprites:
@1338:  ldy     $31
        beq     @134c
        ldx     #$01fc
        lda     #$e001
@1342:  sta     $0300,x
        dex4
        dey
        bne     @1342
@134c:  rts

.a8

; ------------------------------------------------------------------------------

; [ wait for next frame ]

WaitFrame:
@134d:  jsr     WaitVblank
        lda     $46                     ; branch if not scrolling text
        bit     #$20
        beq     @1359
        jsr     UpdateTextScroll
@1359:  jsl     UpdateCtrlMenu
        lda     $20
        beq     @1367                   ; return if not waiting for menu state counter
        clr_ay
        sty     $08                     ; clear controller buttons
        sty     $0a
@1367:  rts

; ------------------------------------------------------------------------------

; [ wait for vblank ]

WaitVblank:
@1368:  lda     #$81                    ; enable interrupts
        sta     hNMITIMEN
        sta     $24
        cli
@1370:  lda     $24                     ; wait for nmi
        bne     @1370
        sei                             ; disable interrupts
        lda     $44                     ; set screen display register
        sta     hINIDISP
        lda     $43                     ; enable hdma
        sta     hHDMAEN
        lda     $b5                     ; set mosaic register
        sta     hMOSAIC
        stz     $ae                     ; clear current sound effect
        rts

; ------------------------------------------------------------------------------

; [ menu nmi ]

MenuNMI:
@1387:  php
        longai
        pha
        phx
        phy
        phb
        phd
        shorta
        lda     hRDNMI
        lda     #$00
        pha
        plb
        ldx     #$0000
        phx
        pld
        lda     $24                     ; branch if interrupt is disabled
        beq     @13b1
        jsr     UpdatePPU
        longa
        inc     $cf                     ; increment frame counter
        shorta
        ldy     $20                     ; decrement menu state frame counter
        beq     @13b1
        dey
        sty     $20
@13b1:  jsl     DecTimersMenuBattle_ext
        jsl     IncGameTime
        inc     $23                     ; increment frame counter
        clr_a
        sta     $24                     ; disable interrupt
        longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti

.a8

; ------------------------------------------------------------------------------

; [ menu irq ]

MenuIRQ:
@13c7:  rti

; ------------------------------------------------------------------------------

; [ increment game time ]

IncGameTime:
@13c8:  lda     $021e
        cmp     #60
        beq     @13d1
        bra     @13fc
@13d1:  stz     $021e
        lda     $021d
        cmp     #59
        beq     @13e0
        inc     $021d
        bra     @13fc
@13e0:  stz     $021d
        lda     $021c
        cmp     #59
        beq     @13ef
        inc     $021c
        bra     @13fc
@13ef:  stz     $021c
        lda     $021b
        cmp     #99
        beq     @13fc
        inc     $021b
@13fc:  lda     $021b
        cmp     #99
        bne     @140d
        lda     $021c
        cmp     #59
        bne     @140d
        stz     $021d
@140d:  inc     $021e
        clr_a
        rtl

; ------------------------------------------------------------------------------

; [ update ppu registers and transfer data to vram ]

UpdatePPU:
@1412:  stz     hHDMAEN
        stz     hMDMAEN
        lda     $35         ; set bg scrolling registers
        sta     hBG1HOFS
        lda     $36
        sta     hBG1HOFS
        lda     $37
        sta     hBG1VOFS
        lda     $38
        sta     hBG1VOFS
        lda     $39
        sta     hBG2HOFS
        lda     $3a
        sta     hBG2HOFS
        lda     $3b
        sta     hBG2VOFS
        lda     $3c
        sta     hBG2VOFS
        lda     $3d
        sta     hBG3HOFS
        lda     $3e
        sta     hBG3HOFS
        lda     $3f
        sta     hBG3VOFS
        lda     $40
        sta     hBG3VOFS
        jsr     UpdateMode7Regs
        jsr     TfrSprites
        jsr     TfrPal
        jsr     TfrVRAM1
        jmp     TfrVRAM2

; ------------------------------------------------------------------------------

; [ copy sprite data to ppu ]

TfrSprites:
@1463:  ldx     $00         ; clear oam address
        stx     hOAMADDL
        txa
        sta     $4304       ; copy sprite data
        lda     #$02
        sta     $4300
        lda     #$04
        sta     $4301
        ldy     #$0300
        sty     $4302
        ldy     #$0220
        sty     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy data/graphics to vram 1 ]

TfrVRAM1:
@1488:  ldy     $14
        sty     hVMADDL
        lda     #$01
        sta     $4300
        lda     #$18
        sta     $4301
        ldy     $16
        sty     $4302
        lda     $18
        sta     $4304
        ldy     $12
        sty     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy data/graphics to vram 2 ]

TfrVRAM2:
@14ac:  ldy     $1b
        beq     @14d1
        sty     hVMADDL
        lda     #$01
        sta     $4300
        lda     #$18
        sta     $4301
        ldy     $1d
        sty     $4302
        lda     $1f
        sta     $4304
        ldy     $19
        sty     $4305
        lda     #$01
        sta     hMDMAEN
@14d1:  rts

; ------------------------------------------------------------------------------

; [ copy color palettes to ppu ]

TfrPal:
@14d2:  lda     $45
        bit     #$01
        beq     @14fd
        lda     $00
        sta     hCGADD
        lda     #$02
        sta     $4300
        lda     #<hCGDATA
        sta     $4301
        ldy     #$3049
        sty     $4302
        lda     #$7e
        sta     $4304
        ldy     #$0200
        sty     $4305
        lda     #$01
        sta     hMDMAEN
@14fd:  rts

; ------------------------------------------------------------------------------

        .include "save.asm"
        .include "main_menu.asm"
        .include "config.asm"
        .include "skills.asm"
        .include "status.asm"
        .include "name_change.asm"

; ------------------------------------------------------------------------------

; [ init ram (menu and ending cutscenes) ]

InitRAM:
@68fa:  jsl     InitMenuRAM
        jsr     ClearBGScroll
        jmp     ClearBigTextBuf

; ------------------------------------------------------------------------------

; [ clear bg scrolling registers ]

ClearBGScroll:
@6904:  ldy     $00
        sty     $35         ; clear bg scrolling registers
        sty     $39
        sty     $3d
        sty     $37
        sty     $3b
        sty     $3f
        sty     $41
        rts

; ------------------------------------------------------------------------------

; [ init party character data ]

InitCharProp:
@6915:  jsl     ClearCharProp
        clr_ax
        txy
@691c:  lda     $1850,x     ; branch if character is not enabled
        and     #$40
        beq     @6941
        lda     $1850,x     ; branch if character is not in the current party
        and     #$07
        cmp     $1a6d
        bne     @6941
        lda     $1850,x     ; battle order
        pha
        and     #$18
        sta     $e0
        lsr3
        tay
        pla
        sta     $0075,y     ; set battle slot
        txa
        sta     $0069,y     ; set character index
@6941:  inx                 ; next character
        cpx     #$0010
        bne     @691c
        ldy     $00
@6949:  clr_a
        lda     $0069,y     ; branch if there's no character in this slot
        cmp     #$ff
        beq     @6962
        asl
        tax
        longa
        lda     f:CharPropPtrs,x   ; pointer to character data
        pha
        tya
        asl
        tax
        pla
        sta     $6d,x       ; set pointer for character slot
        shorta
@6962:  iny
        cpy     #4
        bne     @6949
        rts

; ------------------------------------------------------------------------------

; pointers to character data
CharPropPtrs:
@6969:  .word   $1600,$1625,$164a,$166f,$1694,$16b9,$16de,$1703
        .word   $1728,$174d,$1772,$1797,$17bc,$17e1,$1806,$182b

; ------------------------------------------------------------------------------

; [  ]

_c36989:
@6989:  clr_axy
@698c:  lda     $69,x
        bmi     @69a2
        tay
        lda     $75,x
        and     #$e7
        sta     $e0
        clr_a
        txa
        asl3
        clc
        adc     $e0
        sta     $1850,y
@69a2:  inx
        cpx     #4
        bne     @698c
        rts

; ------------------------------------------------------------------------------

; [  ]

_c369a9:
@69a9:  longa
        lda     $69         ; characters in slots 1-2
        sta     $7eaa89
        lda     $6b         ; characters in slots 3-4
        sta     $7eaa8b
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw positioned text (list) ]

; +x: pointer to list (2-byte pointers, +$c30000)
; +y: length of list

DrawPosList:
@69ba:  stx     $f1
        sty     $ef
        lda     #^*
        sta     $f3
        ldy     $00
@69c4:  longa
        lda     [$f1],y
        sta     $e7
        phy
        shorta
        lda     #^*
        sta     $e9
        jsr     DrawPosTextFar
        ply
        iny2
        cpy     $ef
        bne     @69c4
        rts

; ------------------------------------------------------------------------------

; [ init window 1 position hdma ]

InitWindow1PosHDMA:
@69dc:  lda     #$01        ; hdma channel #2 (2 address)
        sta     $4320
        lda     #<hWH0        ; destination = $2126, $2127
        sta     $4321
        ldy     #.loword(Window1PosHDMATbl)
        sty     $4322
        lda     #^Window1PosHDMATbl
        sta     $4324
        lda     #^Window1PosHDMATbl
        sta     $4327
        lda     #$04        ; enable hdma channel #2
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; window 1 position hdma table
Window1PosHDMATbl:
@69fb:  .byte   $07,$ff,$00
        .byte   $78,$08,$f7
        .byte   $58,$08,$f7
        .byte   $08,$ff,$00
        .byte   $00

; ------------------------------------------------------------------------------

; [ disable window 1 position hdma ]

DisableWindow1PosHDMA:
@6a08:  lda     #$04        ; disable hdma channel #2
        trb     $43
        stz     hWH0        ; window 1 position = [$00,$ff]
        lda     #$ff
        sta     hWH1
        rts

; ------------------------------------------------------------------------------

; [ clear bg tiles ]

ClearBG1ScreenA:
@6a15:  ldx     $00                     ; clear bg1 data (top left screen)
        bra     ClearBGTiles

ClearBG1ScreenB:
@6a19:  ldx     #$0800                  ; clear bg1 data (top right screen)
        bra     ClearBGTiles

ClearBG1ScreenC:
@6a1e:  ldx     #$1000                  ; clear bg1 data (bottom left screen)
        bra     ClearBGTiles

ClearBG1ScreenD:
@6a23:  ldx     #$1800                  ; clear bg1 data (bottom right screen)
        bra     ClearBGTiles

ClearBG2ScreenA:
@6a28:  ldx     #$2000                  ; clear bg2 data (top left screen)
        bra     ClearBGTiles

ClearBG2ScreenB:
@6a2d:  ldx     #$2800                  ; clear bg2 data (top right screen)
        bra     ClearBGTiles

ClearBG2ScreenC:
@6a32:  ldx     #$3000                  ; clear bg2 data (bottom left screen)
        bra     ClearBGTiles

ClearBG2ScreenD:
@6a37:  ldx     #$3800                  ; clear bg2 data (bottom right screen)
        bra     ClearBGTiles

ClearBG3ScreenA:
@6a3c:  ldx     #$4000                  ; clear bg3 data (top left screen)
        bra     ClearBGTiles

ClearBG3ScreenB:
@6a41:  ldx     #$4800                  ; clear bg3 data (top right screen)
        bra     ClearBGTiles

ClearBG3ScreenC:
@6a46:  ldx     #$5000                  ; clear bg3 data (bottom left screen)
        bra     ClearBGTiles

ClearBG3ScreenD:
@6a4b:  ldx     #$5800                  ; clear bg3 data (bottom right screen)

ClearBGTiles:
@6a4e:  longa
        clr_a
        ldy     #$0200
@6a54:  sta     $7e3849,x
        inx2
        sta     $7e3849,x
        inx2
        dey
        bne     @6a54
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init graphics for colosseum character select ]

LoadColosseumGfx:
@6a66:  jsr     ClearPortraitGfx
        jsr     LoadFontGfx2bpp
        jsr     LoadFontPal
        jsr     LoadPortraitPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadPortraitGfx
        jsr     LoadCharGfx
        jsr     LoadMonsterGfx
        jmp     LoadColosseumBGGfx

; ------------------------------------------------------------------------------

; [ init menu graphics ]

InitMenuGfx:
@6a87:  clr_a
        lda     $0200       ; menu type
        asl
        tax
        jmp     (.loword(InitMenuGfxTbl),x)

InitMenuGfxTbl:
@6a90:  .addr   InitMenuGfx_00
        .addr   InitMenuGfx_01
        .addr   InitMenuGfx_02
        .addr   InitMenuGfx_03
        .addr   InitMenuGfx_04
        .addr   InitMenuGfx_05
        .addr   InitMenuGfx_06
        .addr   InitMenuGfx_07
        .addr   InitMenuGfx_08
        .addr   InitMenuGfx_09

; ------------------------------------------------------------------------------

; type 6: swdtech renaming menu
InitMenuGfx_06:
@6aa4:  jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadMiscMenuSpriteGfx
        jmp     LoadMiscMenuSpritePal

; ------------------------------------------------------------------------------

; type 4/5/8/9: party select/unused/final battle order/unused
InitMenuGfx_04:
InitMenuGfx_05:
InitMenuGfx_08:
InitMenuGfx_09:
@6ab0:  jsr     ClearPortraitGfx
        jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadPortraitPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadPortraitGfx
        jmp     LoadCharGfx

; ------------------------------------------------------------------------------

; type 3: shop
InitMenuGfx_03:
@6ace:  jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadPortraitPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadPortraitGfx
        jmp     LoadShopCharGfx

; ------------------------------------------------------------------------------

; type 0/2/7: main menu/load game/colosseum
InitMenuGfx_00:
InitMenuGfx_02:
InitMenuGfx_07:
@6ae9:  jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        jsr     LoadCharGfx
        jsr     LoadMiscMenuSpritePal
        jmp     LoadGrayCharPal

; ------------------------------------------------------------------------------

; type 1: name change
InitMenuGfx_01:
@6b04:  jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadMiscMenuSpriteGfx
        jmp     LoadMiscMenuSpritePal

; ------------------------------------------------------------------------------

; [ load font graphics (2bpp) ]

LoadFontGfx2bpp:
@6b13:  longa
        ldy     #$6000
        sty     hVMADDL
        ldx     $00
@6b1d:  lda     f:SmallFontGfx,x   ; small font graphics
        sta     hVMDATAL
        inx2
        cpx     #$1000
        bne     @6b1d
@6b2b:  sta     hVMDATAL
        inx
        cpx     #$1400
        bne     @6b2b
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load font/window graphics (4bpp) ]

LoadFontGfx4bpp:
@6b37:  ldy     #$5000
        sty     hVMADDL
        longa
        clr_ax
@6b41:  ldy     #8
@6b44:  lda     f:_c36b9c,x
        sta     hVMDATAL
        dey
        bne     @6b44
        inx2
        cpx     #$0020
        bne     @6b41
        ldx     $00
@6b57:  ldy     #8
@6b5a:  lda     f:SmallFontGfx+$80,x
        sta     hVMDATAL
        inx2
        dey
        bne     @6b5a
.repeat 8
        stz     hVMDATAL
.endrep
        cpx     #$0f80
        bne     @6b57
        ldy     #$7800
        sty     hVMADDL
        ldx     $00
@6b8b:  lda     f:WindowGfx,x           ; menu window graphics
        sta     hVMDATAL
        inx2
        cpx     #$1000
        bne     @6b8b
        shorta
        rts

; ------------------------------------------------------------------------------

_c36b9c:
@6b9c:  .word   $0000,$0000,$00ff,$0000,$ff00,$0000,$ffff,$0000
        .word   $0000,$00ff,$00ff,$00ff,$ff00,$00ff,$ffff,$00ff

; ------------------------------------------------------------------------------

; [ load window palette ]

InitWindowPal:
@6bbc:  ldx     #8
        stx     $e7
        ldx     #0
        txy
        longa
@6bc7:  lda     #7
        sta     $e9
@6bcc:  lda     f:WindowPal+2,x         ; load wallpaper palettes
        sta     $1d57,y
        inx2
        iny2
        dec     $e9
        bne     @6bcc
        txa
        clc
        adc     #$0012
        tax
        dec     $e7
        bne     @6bc7
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load menu text palettes ]

LoadFontPal:
@6be8:  ldx     $00
        txa
        sta     hCGADD
@6bee:  longa
        lda     f:MenuPal,x
        sta     $7e3049,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #$00a0
        bne     @6bee
        rts

; ------------------------------------------------------------------------------

; [ load character portrait color palettes ]

LoadPortraitPal:
@6c09:  ldx     $00
        txy
@6c0c:  longa
        lda     $6d,x       ; pointer to character data
        phx
        phy
        tay
        clr_a
        shorta
        lda     #$10        ; $e3 = counter (16 colors per palette)
        sta     $e3
        lda     $0014,y     ; imp status
        and     #$20
        beq     @6c25
        lda     #$0f        ; use portrait $0f
        bra     @6c30
@6c25:  clr_a
        lda     $0000,y     ; character number
        cmp     #$01        ; if it's locke, use palette $01
        beq     @6c30
        lda     $0001,y     ; otherwise, use the actor number
@6c30:  tax
        lda     f:CharPortraitPalTbl,x   ; get corresponding palette number
        longa
        asl5
        tax
        ply
@6c3e:  longa
        phx
        lda     f:PortraitPal,x
        tyx
        sta     $7e3149,x
        shorta
        plx
        inx2                ; next color
        iny2
        dec     $e3
        bne     @6c3e
        plx
        inx2                ; next palette
        cpx     #8
        bne     @6c0c
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load grayscale character sprite palette ]

LoadGrayCharPal:
@6c60:  lda     #$90
        sta     hCGADD
        ldx     $00
@6c67:  longa
        lda     f:MenuPal+$a0,x
        sta     $7e3169,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        iny2
        inx2
        cpx     #$0020
        bne     @6c67
        rts

; ------------------------------------------------------------------------------

; [ load cursor/icon palettes ]

LoadMiscMenuSpritePal:
@6c84:  ldx     $00
        lda     #$ec
        sta     hCGADD
@6c8b:  longa
        lda     f:MenuPal+$c0,x   ; icon palette
        sta     $7e3221,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #8
        bne     @6c8b
        ldx     $00
        lda     #$fc
        sta     hCGADD
@6cac:  longa
        lda     f:MenuPal+$b8,x   ; cursor palette
        sta     $7e3241,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #8
        bne     @6cac
        rts

; ------------------------------------------------------------------------------

; [ load character sprite palettes ]

LoadCharPal:
@6cc7:  ldx     $00
        lda     #$a0
        sta     hCGADD
@6cce:  longa
        lda     f:BattleCharPal,x
        sta     $7e3189,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #$00c0
        bne     @6cce
        rts

; ------------------------------------------------------------------------------

; [ load character sprite graphics ]

; used for colosseum, party change, and save screen, but not shops

LoadCharGfx:
@6ce9:  clr_ax
@6ceb:  phx
        longa
        lda     f:CharGfxVRAMAddr,x
        sta     $f3
        txa
        asl
        tax
        lda     f:MenuCharGfxPtrs+2,x
        sta     $e7
        lda     f:MenuCharGfxPtrs,x
        sta     $e9
        ldx     $00
@6d05:  lda     f:MenuCharPoseOffsets,x
        sta     $ef
        jsr     _c36d44
        lda     $f3
        clc
        adc     #$0100
        sta     $f3
        inx2                            ; next tile
        cpx     #4
        bne     @6d05
        lda     $f3
        sec
        sbc     #$01e0
        sta     $f3
        lda     f:MenuCharPoseOffsets,x
        sta     $ef
        jsr     _c36d44
        lda     $f3
        clc
        adc     #$0100
        sta     $f3
        jsr     _c36d67
        plx
        inx2                            ; next character (load 22 characters)
        cpx     #$002c
        bne     @6ceb
        shorta
        rts

; ------------------------------------------------------------------------------

; [ copy character sprite tile graphics to vram ]

; copies two adjacent 8x8 tiles

_c36d44:
@6d44:  clc
        lda     $ef
        adc     $e7
        sta     $eb
        clr_a
        adc     $e9
        sta     $ed
        ldy     $f3
        sty     hVMADDL
        jmp     @6d58

; ------------------------------------------------------------------------------

; [  ]

@6d58:  ldy     $00
@6d5a:  lda     [$eb],y
        sta     hVMDATAL
        iny2
        cpy     #$0040
        bne     @6d5a
        rts

; ------------------------------------------------------------------------------

; [ clear two tiles in vram ]

; clears the two tiles below a character's feet

.a16

_c36d67:
@6d67:  ldy     $f3
        sty     hVMADDL
        lda     #$0020
        sta     $e7
@6d71:  stz     hVMDATAL
        dec     $e7
        bne     @6d71
        rts

.a8

; ------------------------------------------------------------------------------

; [  ]

LoadShopCharGfx:
@6d79:  ldy     #$3000
        sty     hVMADDL
        stz     $e3
@6d81:  ldy     $00
@6d83:  shorta
        clr_a
        tyx
        lda     f:_c36e07,x
        asl
        tax
        longa
        lda     f:_c36e27,x
        cmp     #$ffff
        beq     @6dea
        pha
        lda     #$16a0
        shorta
        sta     hM7A
        xba
        sta     hM7A
        lda     $e3
        sta     hM7B
        sta     hM7B
        longa
        pla
        clc
        adc     hMPYL
        sta     $eb
        shorta
        lda     hMPYH
        adc     #$d5
        sta     $ed
        longa_clc
        lda     $eb
        adc     #$0000
        sta     $eb
        shorta
        lda     $ed
        adc     #$00
        sta     $ed
        longa
        phy
        jsr     _c36df8
        ply
@6dd7:  iny
        cpy     #$0020
        bne     @6d83
        shorta
        inc     $e3
        inc     $e3
        lda     $e3
        cmp     #$10
        bne     @6d81
        rts

.a16
@6dea:  lda     #$0010
        sta     $e7
@6def:  stz     hVMDATAL
        dec     $e7
        bne     @6def
        bra     @6dd7

; ------------------------------------------------------------------------------

; [  ]

_c36df8:
@6df8:  ldy     $00
@6dfa:  lda     [$eb],y
        sta     hVMDATAL
        iny2
        cpy     #$0020
        bne     @6dfa
        rts

.a8

; ------------------------------------------------------------------------------

_c36e07:
@6e07:  .byte   $00,$01,$04,$05,$08,$09,$0c,$0d,$10,$11,$14,$15,$18,$19,$1c,$1d
        .byte   $02,$03,$06,$07,$0a,$0b,$0e,$0f,$12,$13,$16,$17,$1a,$1b,$1e,$1f

_c36e27:
@6e27:  .word   $03c0,$03e0,$0500,$0520,$0540,$0560,$ffff,$ffff
        .word   $03c0,$0660,$0680,$06a0,$06c0,$06e0,$ffff,$ffff
        .word   $1a60,$1a80,$1ba0,$1bc0,$1be0,$1c00,$ffff,$ffff
        .word   $1a60,$1d00,$1d20,$1d40,$1d60,$1d80,$ffff,$ffff

; ------------------------------------------------------------------------------

; [ copy standard menu cursor/icon graphics to vram ]

LoadMiscMenuSpriteGfx:
@6e67:  longa
        ldy     #$2000
        sty     hVMADDL
        ldx     $00
@6e71:  lda     f:MenuSpriteGfx,x
        sta     hVMDATAL
        inx2
        cpx     #$1400
        bne     @6e71
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load character portrait graphics ]

LoadPortraitGfx:
@6e82:  ldx     $00
@6e84:  longa
        lda     f:PortraitVRAMTbl,x     ; set vram pointer
        sta     hVMADDL
        ldy     $6d,x                   ; pointer to character data
        phx
        clr_a
        shorta
        lda     $0014,y                 ; imp status
        and     #$20
        beq     @6e9e
        lda     #$0f                    ; use imp portrait
        bra     @6ea8
@6e9e:  lda     $0000,y                 ; character graphics index
        cmp     #$01                    ; if it's $01 (locke), use portrait 1
        beq     @6ea8
        lda     $0001,y                 ; otherwise, use actor number
@6ea8:  longa
        asl
        tax
        lda     f:PortraitGfxPtrs,x     ; pointer to character portrait graphics
        tax
        jsr     TfrPortraitGfx
        plx
        inx2
        cpx     #8
        bne     @6e84
        shorta
        rts

; ------------------------------------------------------------------------------

; [ get pointer to character portrait graphics ]

;   $9c = character slot number

;  +$19 = size (out)
;  +$1b = vram destination pointer (out)
; ++$1d = pointer to graphics (out)

GetPortraitGfxPtr:
@6ebf:  lda     #^PortraitGfx
        sta     $1f
        ldy     #$0320
        sty     $19
        clr_a
        lda     $9c
        asl
        tax
        longa
        lda     f:PortraitVRAMTbl,x
        sta     $1b
        ldy     $6d,x
        clr_a
        shorta
        lda     $0014,y
        and     #$20
        beq     @6ee5
        lda     #$0f
        bra     @6eef
@6ee5:  lda     $0000,y
        cmp     #$01
        beq     @6eef
        lda     $0001,y
@6eef:  longa
        asl
        tax
        lda     f:PortraitGfxPtrs,x
        clc
        adc     #.loword(PortraitGfx)
        sta     $1d
        shorta
        rts

; ------------------------------------------------------------------------------

; corresponding color palettes for each character portrait
CharPortraitPalTbl:
@6f00:  .byte   0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
        .byte   16,17,0,14,18,0,0,0,0,0,6

; pointers to character portrait graphics
PortraitGfxPtrs:
@6f1b:  make_ptr_tbl_rel PortraitGfx, 18  ; first 18 portraits are sequential
        .addr   PortraitGfx_0000-PortraitGfx
        .addr   PortraitGfx_000e-PortraitGfx  ; soldier
        .addr   PortraitGfx_0012-PortraitGfx  ; ghost
        .addr   PortraitGfx_0000-PortraitGfx
        .addr   PortraitGfx_0000-PortraitGfx
        .addr   PortraitGfx_0000-PortraitGfx
        .addr   PortraitGfx_0000-PortraitGfx
        .addr   PortraitGfx_0000-PortraitGfx
        .addr   PortraitGfx_0006-PortraitGfx  ; celes

; vram pointers for character portrait graphics
PortraitVRAMTbl:
@6f51:  .word   $2600,$2800,$2a00,$2c00,$2e00,$3000,$3200,$3400

; ------------------------------------------------------------------------------

; [ make a list of character palettes for save slot 1 ]

MakeSaveSlot1PalList:
@6f61:  ldy     $91
        beq     @6f80
        ldx     $00
@6f67:  lda     $69,x
        bmi     @6f73
        jsr     GetCharGfxID
        jsr     FixSoldierPal
        bra     @6f75
@6f73:  lda     #$ff
@6f75:  sta     $7eaa71,x
        inx
        cpx     #4
        bne     @6f67
        rts
@6f80:  ldx     $00
        bra     _6f84

_6f84:  lda     #$ff
        sta     $7eaa71,x
        sta     $7eaa72,x
        sta     $7eaa73,x
        sta     $7eaa74,x
        rts

; ------------------------------------------------------------------------------

; [ get character graphics index ]

GetCharGfxID:
@6f97:  phx
        longa
        txa
        asl
        tax
        ldy     $6d,x
        shorta
        plx
        lda     $0001,y
        rts

; ------------------------------------------------------------------------------

; [ fix palette id for brown or green soldier ]

FixSoldierPal:
@6fa6:  cmp     #$0e
        bne     @6fb7
        lda     $1ea0
        bit     #$08
        beq     @6fb5
        lda     #$16                    ; brown soldier
        bra     @6fb7
@6fb5:  lda     #$0e                    ; green soldier
@6fb7:  rts

; ------------------------------------------------------------------------------

; [ make a list of character palettes for save slot 2 ]

MakeSaveSlot2PalList:
@6fb8:  ldy     $93
        beq     @6fd7
        ldx     $00
@6fbe:  lda     $69,x
        bmi     @6fca
        jsr     GetCharGfxID
        jsr     FixSoldierPal
        bra     @6fcc
@6fca:  lda     #$ff
@6fcc:  sta     $7eaa75,x
        inx
        cpx     #4
        bne     @6fbe
        rts
@6fd7:  ldx     #4
        bra     _6f84

; ------------------------------------------------------------------------------

; [ make a list of character palettes for save slot 3 ]

MakeSaveSlot3PalList:
@6fdc:  ldy     $95
        beq     @6ffb
        ldx     $00
@6fe2:  lda     $69,x
        bmi     @6fee
        jsr     GetCharGfxID
        jsr     FixSoldierPal
        bra     @6ff0
@6fee:  lda     #$ff
@6ff0:  sta     $7eaa79,x
        inx
        cpx     #4
        bne     @6fe2
        rts
@6ffb:  ldx     #8
        bra     _6f84

; ------------------------------------------------------------------------------

; [ copy character portrait graphics to vram ]

; +x = pointer to portrait graphics (+$ed1d00)

TfrPortraitGfx:
@7000:  ldy     #$0190
@7003:  lda     f:PortraitGfx,x   ; character portrait graphics
        sta     hVMDATAL
        inx2
        dey
        bne     @7003
        rts

; ------------------------------------------------------------------------------

; [ clear blank portrait graphics ]

; for party select menu

ClearPortraitGfx:
@7010:  ldx     #$9f51
        stx     hWMADDL
        ldx     #$0190
@7019:  stz     hWMDATA
        stz     hWMDATA
        dex
        bne     @7019
        rts

; ------------------------------------------------------------------------------

; [ check if sram is valid ]

CheckSRAM:
@7023:  longa
        lda     #$e41b                  ; fixed value
        cmp     $307ff8
        beq     @7047
        cmp     $307ffa
        beq     @7047
        cmp     $307ffc
        beq     @7047
        cmp     $307ffe
        beq     @7047
        shorta
        jsr     ClearSRAM
        clc
        rts
@7047:  shorta
        sec
        rts

; ------------------------------------------------------------------------------

; [ clear sram ]

ClearSRAM:
@704b:  phb
        lda     #$30
        pha
        plb
        ldx     #0
        longa
@7055:  stz     $6000,x                 ; clear 30/6000-30/7fff
        inx2
        stz     $6000,x
        inx2
        cpx     #$2000
        bne     @7055
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [ reset saved menu cursor positions ]

ResetMenuCursorMemory:
@7068:  ldx     #0
@706b:  stz     $022b,x                 ; clear saved menu cursor positions
        inx
        cpx     #$001f
        bne     @706b
        lda     #$01                    ; character skills cursors default to magic
        sta     $0237
        sta     $0239
        sta     $023b
        sta     $023d
        rts

; ------------------------------------------------------------------------------

; [ make sram valid ]

ValidateSRAM:
@7083:  longa
        lda     #$e41b                  ; set fixed value
        sta     $307ff8
        sta     $307ffa
        sta     $307ffc
        sta     $307ffe
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init saved game data ]

InitSaveSlot:
@709b:  jsr     ResetMenuCursorMemory
        ldy     #$7fff                  ; set default font color
        sty     $1d55
        lda     #$12                    ; set default button mappings
        sta     $1d50
        lda     #$34
        sta     $1d51
        lda     #$56
        sta     $1d52
        lda     #$06
        sta     $1d53
        lda     #$2a                    ;
        sta     $1d4d
        clr_ay
        sty     $1dc7                   ;
        stz     $1d54
        stz     $1d4e
        stz     $1d4f
        sty     $1863                   ; clear game time
        stz     $1865
        sty     $1860                   ; clear gp
        stz     $1862
        sty     $1866                   ; clear steps
        stz     $1868
        sty     $021b                   ; clear menu game time
        sty     $021d
        jsr     InitWindowPal
        rts

; ------------------------------------------------------------------------------

        .include "party.asm"

; ------------------------------------------------------------------------------

; unused menu state
MenuState_2f:

; ------------------------------------------------------------------------------

; [  ]

_c37ae5:
@7ae5:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        txa
        sta     $60
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     #$001a
        sta     $33ca,x
        shorta
        clr_a
        lda     $28
        jsr     _c37b0e
        clr_a
        sta     $344b,x
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37b0e:
@7b0e:  phx
        phx
        asl
        tax
        longa
        lda     f:PortraitAnimDataTbl,x
        ply
        sta     $32c9,y
        shorta
        lda     #^Portrait1AnimData
        sta     $35ca,y
        plx
        rts

; ------------------------------------------------------------------------------

; [ menu state $30-$32: unused ]

MenuState_30:
MenuState_31:
MenuState_32:

; ------------------------------------------------------------------------------

_c37b25:
@7b25:  clr_a
        lda     $7e9d89,x
        sta     $e1
        bmi     @7b41
        phx
        tax
        lda     $1850,x
        and     #$18
        lsr3
        tay
        lda     $e1
        sta     [$e7],y
        plx
        inx
        bra     @7b25
@7b41:  rts

; ------------------------------------------------------------------------------

; [ character icon task ]

CharIconTask:
@7b42:  tax
        jmp     (.loword(CharIconTaskTbl),x)

CharIconTaskTbl:
@7b46:  .addr   CharIconTask_00
        .addr   CharIconTask_01
        .addr   CharIconTask_02
        .addr   CharIconTask_03
        .addr   CharIconTask_04
        .addr   CharIconTask_05

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_00:
@7b52:  lda     #$01
        tsb     $47
        ldx     $2d
        lda     #$03
        sta     $3649,x
        jsr     InitAnimTask
        clr_a
        jsr     _c37bae
        bra     _7b7e

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_01:
@7b66:  ldx     $2d
        lda     #$04
        sta     $3649,x
        jsr     InitAnimTask
        bra     _7b8d

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_02:
@7b72:  ldx     $2d
        lda     #$05
        sta     $3649,x
        jsr     InitAnimTask
        bra     _7ba1

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_03:
_7b7e:  lda     $47
        and     #$01
        beq     @7b8b
        ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts
@7b8b:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_04:
_7b8d:  lda     $47
        and     #$02
        beq     _7b9a
        ldx     $2d
        jsr     UpdateAnimTask
        clc
        rts
_7b9a:  ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

CharIconTask_05:
_7ba1:  lda     $47
        and     #$04
        beq     _7b9a
        ldx     $2d
        jsr     UpdateAnimTask
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37bae:
@7bae:  sta     $e6
        lda     $0200
        cmp     #$04
        bne     @7c0e
        ldx     $2d
        clr_a
        lda     $35c9,x
        bmi     @7c0e
        asl
        longa
        tax
        lda     f:_c37c0f,x
        sta     $e7
        lda     $0202
        and     $e7
        shorta
        beq     @7c0e
        lda     #$00
        pha
        plb
        lda     $e6
        bne     @7bdf
        ldy     #.loword(CharIconTask)
        bra     @7be2
@7bdf:  ldy     #.loword(_c37a5f)
@7be2:  lda     #3
        jsr     CreateTask
        lda     #$7e
        pha
        plb
        lda     #$ff
        sta     $35c9,x
        ldy     $374a,x
        longa
        lda     $33ca,y
        sta     $33ca,x
        lda     $344a,y
        sta     $344a,x
        lda     #.loword(PartyArrowAnim)
        sta     $32c9,x
        shorta
        lda     #^PartyArrowAnim
        sta     $35ca,x
@7c0e:  rts

; ------------------------------------------------------------------------------

_c37c0f:
@7c0f:  .word   $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        .word   $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

; ------------------------------------------------------------------------------

; [  ]

_c37c2f:
@7c2f:  ldy     #$2600
        sty     $1b
        ldy     #$0320
        sty     $19
        clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7e9d89,x
        bmi     @7ca4
        bra     @7c6e
        ldy     #$2600
        sty     $1b
        bra     @7c5f
        ldy     #$2800
        sty     $1b
        bra     @7c5f
        ldy     #$2800
        sty     $1b
        bra     @7ca4
@7c5f:  ldy     #$0320
        sty     $19
        clr_a
        lda     $4b
        tax
        lda     $7e9da9,x
        bmi     @7ca4
@7c6e:  asl
        tax
        longa
        lda     f:CharPropPtrs,x
        tay
        clr_a
        shorta
        lda     $0014,y
        and     #$20
        beq     @7c85
        lda     #$0f
        bra     @7c8f
@7c85:  lda     $0000,y
        cmp     #$01
        beq     @7c8f
        lda     $0001,y
@7c8f:  longa
        asl
        tax
        lda     f:PortraitGfxPtrs,x
        clc
        adc     #.loword(PortraitGfx)
        sta     $1d
        shorta
        lda     #^PortraitGfx
        sta     $1f
        rts
@7ca4:  ldy     #$9f51
        sty     $1d
        lda     #$7e
        sta     $1f
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37cae:
@7cae:  ldy     $00
        phy
        clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7e9d89,x
        bpl     @7cd6
        clr_a
        bra     @7cd6
        ldy     $00
        bra     @7cca
        ldy     #$0020
@7cca:  phy
        clr_a
        lda     $4b
        tax
        lda     $7e9da9,x
        bpl     @7cd6
        clr_a
@7cd6:  asl
        tax
        longa
        lda     f:CharPropPtrs,x
        tay
        clr_a
        shorta
        lda     #$10
        sta     $e3
        lda     $0014,y
        and     #$20
        beq     @7cf1
        lda     #$0f
        bra     @7cf4
@7cf1:  lda     $0001,y
@7cf4:  tax
        lda     f:CharPortraitPalTbl,x
        longa
        asl5
        tax
        ply
@7d02:  longa
        phx
        lda     f:PortraitPal,x
        tyx
        sta     $7e3149,x
        shorta
        plx
        inx2
        iny2
        dec     $e3
        bne     @7d02
        shorta
        rts

; ------------------------------------------------------------------------------

; unused menu states
MenuState_44:
MenuState_45:
MenuState_46:

; ------------------------------------------------------------------------------

        .include "item.asm"
        .include "equip.asm"
        .include "ctrl.asm"
        .include "big_text.asm"
        .include "final_order.asm"
        .include "colosseum.asm"
        .include "shop.asm"
        .include "ending.asm"

; ------------------------------------------------------------------------------

.segment "menu_code2"

; ------------------------------------------------------------------------------

; [ clear party character data ]

ClearCharProp:
@ca00:  stz     $75                     ; clear battle order
        stz     $76
        stz     $77
        stz     $78
        ldy     $00
        sty     $6d                     ; clear character data pointers
        sty     $6f
        sty     $71
        sty     $73
        lda     #$ff
        sta     $69                     ; set character numbers to $ff (no character)
        sta     $6a
        sta     $6b
        sta     $6c
        rtl

; ------------------------------------------------------------------------------

; [ init hdma for menu window gradient bars ]

; a: 0 = normal, 1 = save select, 2 = colosseum

InitGradientHDMA:
@ca1d:  xba
        lda     $00
        xba
        asl
        tax
        longa
        lda     f:MenuFixedColorHDMATblPtrs,x
        sta     $4332
        lda     f:MenuAddSubHDMATblPtrs,x
        sta     $4342
        shorta
        stz     $4330
        lda     #$32
        sta     $4331
        lda     #^*
        sta     $4334
        sta     $4337
        sta     $4344
        sta     $4347
        stz     $4340
        lda     #$31
        sta     $4341
        lda     #$18
        tsb     $43
        lda     #$80
        sta     hCGSWSEL
        lda     #$82
        sta     hCGADSUB
        lda     #$17
        sta     hTM
        lda     #$17
        sta     hTS
        lda     #$e0
        sta     hCOLDATA
        rtl

; ------------------------------------------------------------------------------

; pointers to add/sub dma tables
MenuAddSubHDMATblPtrs:
@ca71:  .addr   MenuAddSubHDMATbl_00
        .addr   MenuAddSubHDMATbl_01
        .addr   MenuAddSubHDMATbl_02

; add/sub hdma data for normal menu window
MenuAddSubHDMATbl_00:
@ca77:  .byte   $70,$02
        .byte   $70,$82
        .byte   $00

; pointers to fixed color hdma tables
MenuFixedColorHDMATblPtrs:
@ca7c:  .addr   MenuFixedColorHDMATbl_00
        .addr   MenuFixedColorHDMATbl_01
        .addr   MenuFixedColorHDMATbl_02

; fixed color hdma data for normal menu window
MenuFixedColorHDMATbl_00:
@ca82:  .byte   $0a,$eb
        .byte   $0a,$ea
        .byte   $0a,$e9
        .byte   $0a,$e8
        .byte   $0a,$e7
        .byte   $0a,$e6
        .byte   $0a,$e5
        .byte   $0a,$e4
        .byte   $0a,$e3
        .byte   $0a,$e2
        .byte   $0a,$e1
        .byte   $0a,$e0
        .byte   $0a,$e1
        .byte   $0a,$e2
        .byte   $0a,$e3
        .byte   $0a,$e4
        .byte   $0a,$e5
        .byte   $0a,$e6
        .byte   $0a,$e7
        .byte   $0a,$e8
        .byte   $0a,$e9
        .byte   $0a,$ea
        .byte   $0a,$eb
        .byte   $0a,$ec
        .byte   $00

; add/sub hdma data for save select menu window
MenuAddSubHDMATbl_01:
@cab3:  .byte   $1f,$02
        .byte   $10,$82
        .byte   $1c,$02
        .byte   $1c,$82
        .byte   $1c,$02
        .byte   $1c,$82
        .byte   $1c,$02
        .byte   $1c,$82
        .byte   $00

; add/sub hdma data for colosseum menu window
MenuAddSubHDMATbl_02:
@cac4:  .byte   $17,$02
        .byte   $78,$82
        .byte   $24,$02
        .byte   $24,$82
        .byte   $00

; fixed color hdma data for save select menu window
MenuFixedColorHDMATbl_01:
@cacd:  .byte   $0f,$e0
        .byte   $02,$e7
        .byte   $02,$e6
        .byte   $02,$e5
        .byte   $02,$e4
        .byte   $02,$e3
        .byte   $02,$e2
        .byte   $02,$e1
        .byte   $02,$e0
        .byte   $02,$e1
        .byte   $02,$e2
        .byte   $02,$e3
        .byte   $02,$e4
        .byte   $02,$e5
        .byte   $02,$e6
        .byte   $02,$e7
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $00

; fixed color hdma data for colosseum menu window
MenuFixedColorHDMATbl_02:
@cb42:  .byte   $07,$e0
        .byte   $02,$e7
        .byte   $02,$e6
        .byte   $02,$e5
        .byte   $02,$e4
        .byte   $02,$e3
        .byte   $02,$e2
        .byte   $02,$e1
        .byte   $02,$e0
        .byte   $02,$e1
        .byte   $02,$e2
        .byte   $02,$e3
        .byte   $02,$e4
        .byte   $02,$e5
        .byte   $02,$e6
        .byte   $03,$e7
        .byte   $67,$e0
        .byte   $02,$ea
        .byte   $04,$e9
        .byte   $04,$e8
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $04,$e7
        .byte   $04,$e8
        .byte   $04,$e9
        .byte   $02,$ea
        .byte   $00

; ------------------------------------------------------------------------------

; [ init mode 7 hdma ]

_d4cb8f:
@cb8f:  lda     #$42
        sta     $4340
        sta     $4350
        sta     $4360
        sta     $4370
        lda     #$1b
        sta     $4341
        inc
        sta     $4351
        inc
        sta     $4361
        inc
        sta     $4371
        ldy     #.loword(_d4cbe7)
        sty     $4342
        ldy     #.loword(_d4cbee)
        sty     $4352
        ldy     #.loword(_d4cbf5)
        sty     $4362
        ldy     #.loword(_d4cbe7)
        sty     $4372
        lda     #^*
        sta     $4344
        sta     $4354
        sta     $4364
        sta     $4374
        lda     #$00
        sta     $4347
        sta     $4357
        sta     $4367
        sta     $4377
        lda     #$f0
        tsb     $43
        rtl

; ------------------------------------------------------------------------------

; m7a & m7d hdma table
_d4cbe7:
@cbe7:  .byte   $fb
        .word   $0604
        .byte   $e5
        .word   $06f8
        .byte   $00

; m7b hdma table
_d4cbee:
@cbee:  .byte   $fb
        .word   $07c6
        .byte   $e5
        .word   $08ba
        .byte   $00

; m7c hdma table
_d4cbf5:
@cbf5:  .byte   $fb
        .word   $0988
        .byte   $e5
        .word   $0a7c
        .byte   $00

; ------------------------------------------------------------------------------

; [ init mode 7 hdma (credits, airship above clouds) ]

_d4cbfc:
@cbfc:  lda     #$43
        sta     $4310
        sta     $4320
        lda     #$42
        sta     $4340
        sta     $4350
        sta     $4360
        sta     $4370
        lda     #<hBG1HOFS  ; channel #1 destination = $210d, $210e (bg1 hscroll, vscroll)
        sta     $4311
        lda     #<hM7X      ; channel #2 destination = $211f, $2120 (center x, y)
        sta     $4321
        lda     #<hM7A      ; channel #4 destination = $211b (m7a)
        sta     $4341
        inc                 ; channel #5 destination = $211c (m7b)
        sta     $4351
        inc                 ; channel #6 destination = $211d (m7c)
        sta     $4361
        inc                 ; channel #7 destination = $211e (m7d)
        sta     $4371
        ldy     #.loword(_d4cd3a)
        sty     $4312
        ldy     #.loword(_d4cd41)
        sty     $4322
        ldy     #.loword(_d4cd25)
        sty     $4342
        ldy     #.loword(_d4cd2c)
        sty     $4352
        ldy     #.loword(_d4cd33)
        sty     $4362
        ldy     #.loword(_d4cd25)
        sty     $4372
        lda     #^*
        sta     $4314
        sta     $4324
        sta     $4344
        sta     $4354
        sta     $4364
        sta     $4374
        lda     #$00
        sta     $4347
        sta     $4357
        sta     $4367
        sta     $4377
        lda     #$7e
        sta     $4317
        sta     $4327
        lda     #$04
        sta     $4330
        lda     #<hCGSWSEL
        sta     $4331
        ldy     #.loword(FixedColorHDMATbl)
        sty     $4332
        lda     #^FixedColorHDMATbl
        sta     $4334
        sta     $4337
        lda     #$fe
        tsb     $43
        rtl

; ------------------------------------------------------------------------------

; fixed color hdma table
FixedColorHDMATbl:
@cc98:  .byte   $63,$80,$01,$e0,$00
        .byte   $01,$80,$01,$e1,$00
        .byte   $01,$80,$01,$e2,$00
        .byte   $01,$80,$01,$e3,$00
        .byte   $01,$80,$01,$e4,$00
        .byte   $01,$80,$01,$e5,$00
        .byte   $01,$80,$01,$e6,$00
        .byte   $01,$80,$01,$e7,$00
        .byte   $01,$80,$01,$e8,$00
        .byte   $01,$80,$01,$e9,$00
        .byte   $01,$80,$01,$ea,$00
        .byte   $01,$80,$01,$eb,$00
        .byte   $01,$80,$01,$ec,$00
        .byte   $02,$80,$01,$ee,$00
        .byte   $03,$80,$01,$f0,$00
        .byte   $03,$80,$01,$f3,$00
        .byte   $02,$80,$01,$f6,$00
        .byte   $01,$80,$01,$fa,$00
        .byte   $01,$80,$01,$fb,$00
        .byte   $01,$80,$01,$fc,$00
        .byte   $01,$80,$01,$ef,$00
        .byte   $01,$80,$01,$ec,$00
        .byte   $01,$80,$01,$ea,$00
        .byte   $01,$80,$01,$e6,$00
        .byte   $01,$80,$01,$e3,$00
        .byte   $02,$80,$01,$e2,$00
        .byte   $03,$80,$01,$e1,$00
        .byte   $01,$82,$81,$e0,$00
        .byte   $00

; ------------------------------------------------------------------------------

; m7a & m7d hdma table
_d4cd25:
@cd25:  .byte   $7c
        .word   $0600
        .byte   $e4
        .word   $06f8
        .byte   $00

; m7b hdma table
_d4cd2c:
@cd2c:  .byte   $7c
        .word   $07c2
        .byte   $e4
        .word   $08ba
        .byte   $00

; m7c hdma table
_d4cd33:
@cd33:  .byte   $7c
        .word   $0984
        .byte   $e4
        .word   $0a7c
        .byte   $00

; bg1 scroll hdma table
_d4cd3a:
@cd3a:  .byte   $7c
        .word   $b68d
        .byte   $64
        .word   $b691
        .byte   $00

; center x,y position hdma table
_d4cd41:
@cd41:  .byte   $7c
        .word   $b695
        .byte   $64
        .word   $b699
        .byte   $00

; ------------------------------------------------------------------------------

; [ init menu hardware registers ]

InitHWRegsMenu:
@cd48:  lda     #$01
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$09
        sta     hBGMODE
        lda     #$00
        sta     hMOSAIC
        lda     #$03
        sta     hBG1SC
        lda     #$13
        sta     hBG2SC
        lda     #$43
        sta     hBG3SC
        lda     #$65
        sta     hBG12NBA
        lda     #$66
        sta     hBG34NBA
        clr_a
        sta     hHDMAEN
        sta     hMDMAEN
        sta     hBG1HOFS
        sta     hBG1HOFS
        sta     hBG1VOFS
        sta     hBG1VOFS
        sta     hBG2HOFS
        sta     hBG2HOFS
        sta     hBG2VOFS
        sta     hBG2VOFS
        sta     hBG3HOFS
        sta     hBG3HOFS
        sta     hBG3VOFS
        sta     hBG3VOFS
        sta     hBG4HOFS
        sta     hBG4HOFS
        sta     hBG4VOFS
        sta     hBG4VOFS
        lda     #$80
        sta     hVMAINC
        clr_ax
        stx     hVMADDL
        sta     hCGADD
        lda     #$3f
        sta     hW12SEL
        lda     #$33
        sta     hW34SEL
        sta     hWOBJSEL
        lda     #$08
        sta     hWH0
        sta     hWH2
        lda     #$f7
        sta     hWH1
        sta     hWH3
        clr_a
        sta     hTSW
        sta     hSETINI
        sta     hWBGLOG
        sta     hWOBJLOG
        lda     #$1f
        sta     hTM
        lda     #$0f
        sta     hTS
        lda     #$0f
        sta     hTMW
        rtl

; ------------------------------------------------------------------------------

; [ init menu ram ]

InitMenuRAM:
@cdf3:  clr_ay
        sty     $bb         ; clear mode7 registers
        sty     $bd
        sty     $bf
        sty     $c1
        sty     $b7
        sty     $b9
        sty     $06         ; clear controller buttons
        sty     $08
        sty     $0c
        sty     $0a
        sty     $97         ;
        sty     $2b         ; clear current task code pointer
        sta     $43         ; disable hdma
        sta     $26         ; clear menu/cinematic state
        sta     $25         ; clear main menu selection
        sta     $b4         ; use inverse credits palette
        sta     $b5         ; clear mosaic register
        sta     $28         ; clear current selection
        sta     $29         ; clear high byte of bg data
        sta     $60         ; clear portrait task data pointers
        sta     $61
        sta     $62
        sta     $63
        sta     $46         ; clear cursor/scrolling flags
        sta     $66         ; clear current saved game slot
        sta     $ae         ; clear current sound effect
        lda     #$ff
        sta     $86         ; clear cursor positions
        sta     $88
        sta     $8a
        sta     $8c
        lda     #$05        ;
        sta     $45
        sty     $1b         ; dma 1 destination = $0000 vram
        ldy     #$4000      ; dma 2 destination = $4000 vram
        sty     $14
        ldy     #$7849      ; dma 2 source = $7e7849 (bg3 data)
        sty     $16
        lda     #$7e
        sta     $18
        sta     $1f
        ldy     #$1000      ; dma 1 & 2 size = $1000
        sty     $12
        sty     $19
        lda     #$0c        ;
        sta     $b6
        rtl

; ------------------------------------------------------------------------------

; [  ]

_d4ce55:
@ce55:  lda     #$70
        sta     $7e9d89
        sta     $7e9d8b
        lda     #$11
        sta     $7e9d8a
        sta     $7e9d8c
        stz     $4310
        lda     #$2c
        sta     $4311
        ldy     #$9d89
        sty     $4312
        lda     #$7e
        sta     $4314
        lda     #$7e
        sta     $4317
        lda     #$02
        tsb     $43
        rtl

; ------------------------------------------------------------------------------

@ce86:  .byte   $70,$89,$9d
@ce89:  .byte   $70,$89,$9d

; ------------------------------------------------------------------------------

; [ init hardware registers (ending character roll) ]

InitHWRegsEnding:
@ce8c:  lda     #$03
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$09
        sta     hBGMODE
        lda     #$03
        sta     hBG1SC
        lda     #$11
        sta     hBG2SC
        lda     #$19
        sta     hBG3SC
        sta     hBG4SC
        lda     #$33
        sta     hBG12NBA
        lda     #$22
        sta     hBG34NBA
        jsr     InitEndingWindowMask
        stz     hCGSWSEL
        lda     #$e0
        sta     hCOLDATA
        lda     #$17
        sta     hTM
        lda     #$02
        sta     hTS
        lda     #$82
        sta     hCGSWSEL
        lda     #$d1
        sta     hCGADSUB
        rtl

; ------------------------------------------------------------------------------

; [ init hardware registers (ending credits) ]

InitHWRegsCredits:
@ced7:  lda     #$03
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$07
        sta     hBGMODE
        lda     #$58
        sta     hBG1SC
        lda     #$50
        sta     hBG2SC
        lda     #$7c
        sta     hBG3SC
        sta     hBG4SC
        lda     #$44
        sta     hBG12NBA
        lda     #$77
        sta     hBG34NBA
        jsr     InitEndingWindowMask
        stz     hM7SEL
        lda     #$13
        sta     hTM
        lda     #$10
        sta     hTS
        lda     #$e0
        sta     hCOLDATA
        lda     #$82
        sta     hCGSWSEL
        lda     #$81
        sta     hCGADSUB
        rtl

; ------------------------------------------------------------------------------

; [ init window settings ]

InitEndingWindowMask:
@cf22:  lda     #$33
        sta     hW12SEL
        sta     hW34SEL
        lda     #$08
        sta     hWH0
        sta     hWH2
        lda     #$f7
        sta     hWH1
        sta     hWH3
        rts

; ------------------------------------------------------------------------------

; [ save memory for mode 7 hdma data ]

PushMode7Vars:
@cf3b:  ldx     $00
@cf3d:  lda     $0600,x
        sta     $7f4000,x
        inx
        cpx     #$054c
        bne     @cf3d
        rtl

; ------------------------------------------------------------------------------

; [ restore memory for mode 7 hdma data ]

PopMode7Vars:
@cf4b:  ldx     $00
@cf4d:  lda     $7f4000,x
        sta     $0600,x
        inx
        cpx     #$054c
        bne     @cf4d
        rtl

; ------------------------------------------------------------------------------
