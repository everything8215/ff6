
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

.include "menu_data.asm"
.include "ending_anim.asm"

.import DecTimersMenuBattle_ext
.import UpdateEquip_ext, CalcMagicEffect_ext
.import ExecSound_ext

.import ItemName, FontGfxSmall, CharProp, LevelUpExp

.export OpenMenu_ext, UpdateCtrlBattle_ext, InitCtrl_ext, UpdateCtrlField_ext
.export IncGameTime_ext, LoadSavedGame_ext, EndingCutscene_ext
.export OptimizeCharEquip_ext, EndingAirshipScene_ext

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
        jsl     OpenMenu
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
        jsl     OpenMenu
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
        jmp     _c33a87

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

; [  ]

_c30326:
@0326:  sty     $e7
        ldx     $00
        longa
@032c:  lda     f:_c3044e,x
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

_c3044e:
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
        longac
        adc     $34ca,x
        sta     $344a,x                 ; set vertical offset
        shorta
        bra     @09bd
@09aa:  clr_a
        lda     f:hMPYM
        longac
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

; [ copy bg1 data to vram (top screens) ]

TfrBG1ScreenAB:
@0e28:  ldy     #$0000
        sty     hVMADDL
        ldy     #$3849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (top right/bottom left) ]

TfrBG1ScreenBC:
@0e36:  ldy     #$0400
        sty     hVMADDL
        ldy     #$4049
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (bottom screens) ]

TfrBG1ScreenCD:
@0e44:  ldy     #$0800
        sty     hVMADDL
        ldy     #$4849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (top screens) ]

TfrBG2ScreenAB:
@0e52:  ldy     #$1000
        sty     hVMADDL
        ldy     #$5849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (bottom screens) ]

TfrBG2ScreenCD:
@0e60:  ldy     #$1800
        sty     hVMADDL
        ldy     #$6849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (top screens) ]

TfrBG3ScreenAB:
@0e6e:  ldy     #$4000
        sty     hVMADDL
        ldy     #$7849
        sty     $4302
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (bottom screens) ]

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

; [ init dma 1 (bg1 data, left & right screens) ]

InitBG1TilesDMA1:
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

; [ init dma 1 (bg1 data, left screen) ]

InitBG1TilesLeftDMA1:
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

; [ init dma 1 (bg1 data, right screen) ]

InitBG1TilesRightDMA1:
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

; [ init dma 1 (bg3 data, left & right screens) ]

InitBG3TilesDMA1:
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

; [ init dma 1 (bg3 data, left screen) ]

InitBG3TilesLeftDMA1:
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

; [ init dma 1 (bg3 data, right screen) ]

InitBG3TilesRightDMA1:
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

; [ init dma 2 (bg3 data, left screen) ]

InitBG3TilesLeftDMA2:
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

; [ init dma 2 (bg3 data, right screen) ]

InitBG3TilesRightDMA2:
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

;  a = source bank
; +x = source address
; +y = destination address (+$7e0000)

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

;   a = speed (frames per update)
;  +x = source address
;  +y = destination address (+$7e0000)
; $ed = source bank

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
        ldx     a:$002d                   ; task data pointer
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
        stx     $2d         ; clear task pointer and number of active tasks
        stx     $2f
        longa
        jsr     ResetSprites
        shorti
        ldx     #$7e
        phx
        plb
        ldx     #0
@1127:  stz     $3249,x     ; clear task data
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
        sta     $0300,x     ; move all sprites offscreen
        inx2
        lda     #$0001
        sta     $0300,x
        inx2
        cpx     #$0200
        bne     @1150
        ldy     $00         ; clear high sprite data
        tya
@1168:  sta     $0500,y
        iny2
        cpy     #$0020
        bne     @1168
        rts

.a8

; ------------------------------------------------------------------------------

; [ create task ]

; a = priority
; y = address

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
        sta     $7e374a,x   ; set task data pointer
        inc     $2f         ; increment the number of active tasks
        rts

; ------------------------------------------------------------------------------

; [ init task code pointer ]

; a = priority

InitTask:
@118b:  xba
        lda     #$00
        xba
        asl4
        longa
        tax
@1196:  lda     $3249,x     ; find the first available task in this priority level
        bne     @11a0
        tya
        sta     $3249,x     ; set task code pointer
        rts
@11a0:  inx2
        cpx     #$0080
        bne     @1196
        dex2                ; no empty task found, use the second to last one
        tya
        sta     $3249,x     ; set task data pointer
@11ad:  bra     @11ad       ; infinite loop
        rts

.a8

; ------------------------------------------------------------------------------

; [ execute tasks ]

ExecTasks:
@11b0:  phb
        lda     #$7e
        pha
        plb
        ldx     #$0300      ; set starting pointers to sprite data
        stx     $0e
        ldx     #$0500
        stx     $10
        lda     #$03        ;
        sta     $33
        stz     $34
        ldx     #$0080      ; start with $80 unused sprites
        stx     $31
        ldx     $00
        longa
@11ce:  lda     $3249,x     ; task code pointer
        beq     @11f5       ; branch if task is not active
        stx     $2d         ; +$2d = task data pointer
        phx
        sta     $2b         ; +$2b = task code pointer
        shorta
        clr_a
        lda     $3649,x     ; task state
        asl
        jsr     @1203       ; execute task (carry clear = terminate, carry set = don't terminate)
        longa
        plx
        bcs     @11f5       ; branch if task didn't terminate
        stz     $3249,x     ; clear task data
        stz     $3649,x
        stz     $35c9,x
        stz     $3749,x
        dec     $2f         ; decrement number of active tasks
@11f5:  inx2                ; next task
        cpx     #$0080
        bne     @11ce
        jsr     HideUnusedSprites
        shorta
        plb
        rts

; execute task
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
@1227:  ldx     $2d         ; task data pointer
        ldy     $00
        longa
        lda     $32c9,x     ; ++$eb = animation data pointer
        sta     $eb
        shorta
        lda     $35ca,x
        sta     $ed
@1239:  lda     $36ca,x     ; next animation data byte
        cmp     #$fe
        beq     @1262       ; return if $fe (stop animation)
        cmp     #$ff
        bne     @124c       ; branch if not $ff (repeat)
        stz     $36c9,x     ; reset animation data offset
        jsr     SetAnimDur
        bra     @1239
@124c:  lda     $36ca,x     ; frame counter
        bne     @125f       ; decrement and return if not zero
        lda     $36c9,x     ; increment animation data offset
        clc
        adc     #3
        sta     $36c9,x
        jsr     SetAnimDur
        bra     @1239
@125f:  dec     $36ca,x     ; decrement frame counter
@1262:  rts

; ------------------------------------------------------------------------------

; [ set animation frame counter ]

SetAnimDur:
@1263:  shorti
        lda     $36c9,x     ; animation data offset + 2
        tay
        iny2
        lda     [$eb],y
        sta     $36ca,x     ; set frame counter
        longi
        rts

; ------------------------------------------------------------------------------

; [ update animation sprites ]

UpdateAnimSprites:
@1273:  shorti
        lda     $36c9,x     ; animation data offset
        tay
        longa
        lda     [$eb],y     ; ++$e7 = pointer to sprite data
        sta     $e7
        iny2
        shorta
        lda     $35ca,x
        sta     $e9
        longi
        ldy     $00
        lda     $31         ; return if there are no unused sprites remaining
        beq     @12fb
        lda     [$e7],y
        sta     $e6         ; $e6 = number of sprites
        beq     @12fb       ; return if there are no sprites
        iny
@1297:  lda     [$e7],y     ; $e0 = x position
        sta     $e0
        bpl     @12b0       ; branch if not a 32x32 sprite
        clr_a
        lda     $33
        tax
        lda     f:LargeSpriteTbl,x   ; high sprite mask
        clc
        adc     $34
        sta     $34
        sta     ($10)       ; set sprite high data
        ldx     $2d
        bra     @12b4
@12b0:  lda     $34
        sta     ($10)       ; set sprite high data
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
        sbc     $35         ; subtract bg1 horizontal scroll
        sta     $e0
        shorta
@12ce:  jsr     DrawAnimSprite
        dec     $33         ; decrement pointer to high sprite data masks
        bpl     @12df       ; branch if positive
        lda     #$03        ; reset to 3
        sta     $33
        stz     $34         ; clear current high sprite data byte
        longa
        inc     $10         ; increment pointer to high sprite data
@12df:  longa
        lda     $e0
        sta     ($0e)       ; set sprite data (position)
        inc     $0e
        inc     $0e
        lda     $e2
        sta     ($0e)       ; set sprite data (other bytes)
        inc     $0e
        inc     $0e
        shorta
        dec     $31         ; decrement number of unused sprites
        beq     @12fb
        dec     $e6         ; next sprite
        bne     @1297
@12fb:  rts

; ------------------------------------------------------------------------------

; [ update animation sprite data ]

DrawAnimSprite:
@12fc:  lda     $e0         ; $e0 = x position
        clc
        adc     $33ca,x     ; add horizontal offset
        sta     $e0
        iny
        lda     [$e7],y     ; $e1 = y position
        clc
        adc     $344a,x     ; add vertical offset
        sta     $e1
        iny
        lda     [$e7],y     ; $e2 = graphics offset
        sta     $e2
        iny
        lda     $364a,x     ; branch if not flipped horizontal
        bit     #$02
        beq     @1320
        lda     [$e7],y
        ora     #$40
        bra     @1322
@1320:  lda     [$e7],y
@1322:  sta     $e3         ; $e3 = vhoopppm
        lda     $3749,x     ; special palette
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
        lda     $46         ; branch if not scrolling text
        bit     #$20
        beq     @1359
        jsr     UpdateTextScroll
@1359:  jsl     UpdateCtrlMenu
        lda     $20
        beq     @1367       ; return if not waiting for menu state counter
        clr_ay
        sty     $08         ; clear controller buttons
        sty     $0a
@1367:  rts

; ------------------------------------------------------------------------------

; [ wait for vblank ]

WaitVblank:
@1368:  lda     #$81        ; enable interrupts
        sta     hNMITIMEN
        sta     $24
        cli
@1370:  lda     $24         ; wait for nmi
        bne     @1370
        sei                 ; disable interrupts
        lda     $44         ; set screen display register
        sta     hINIDISP
        lda     $43         ; enable hdma
        sta     hHDMAEN
        lda     $b5         ; set mosaic register
        sta     hMOSAIC
        stz     $ae         ; clear current sound effect
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

LoadSavedGame:
@14fe:  lda     $021f                   ; branch if not loading a saved game
        beq     @1514
        jsr     LoadSaveSlot
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        beq     @1514                   ; branch if checksum invalid
        jsr     PopTimers
        clr_a                           ; return $00
        bra     @1518
@1514:  shorta
        lda     #$ff                    ; return $ff
@1518:  sta     $0205
        clr_a
        rtl

; ------------------------------------------------------------------------------

; [ save game ]

; a = game slot

CopyGameDataToSRAM:
@151d:  and     #$03        ; set game slot
        sta     $307ff0
        sta     $0224
        pha
        ldy     $021b       ; save game time
        sty     $1863
        lda     $021d
        sta     $1865
        jsr     PushTimers
        jsr     CalcSaveSlotChecksum
        ldy     $e7
        sty     $1ffe       ; save checksum
        clr_a
        pla
        asl
        tax
        longa
        lda     f:SRAMSlotPtrs,x
        tax
        shorta
        ldy     $00
@154d:  lda     $1600,y     ; copy saved game data to sram
        sta     $306000,x
        inx
        iny
        cpy     #$0a00
        bne     @154d
        jmp     ValidateSRAM

; pointers to saved game data in sram
SRAMSlotPtrs:
@155e:  .word   $0000,$0000,$0a00,$1400

; ------------------------------------------------------------------------------

; [ load saved game data ]

LoadSaveSlot:
@1566:  xba
        lda     $00
        xba
        asl
        tax
        longa
        lda     f:SRAMSlotPtrs,x   ; pointer to saved game data
        tax
        shorta
        ldy     $00
@1577:  lda     $306000,x
        sta     $1600,y
        inx
        iny
        cpy     #$0a00
        bne     @1577
        rts

; ------------------------------------------------------------------------------

; [ save timer data ]

PushTimers:
@1586:  clr_ax
@1588:  lda     $1188,x
        sta     $1fa8,x
        inx
        cpx     #$0018
        bne     @1588
        rts

; ------------------------------------------------------------------------------

; [ restore timer data ]

PopTimers:
@1595:  clr_ax
@1597:  lda     $1fa8,x
        sta     $1188,x
        inx
        cpx     #$0018
        bne     @1597
        rts

; ------------------------------------------------------------------------------

; [ init cursor (save select) ]

LoadGameSaveCursor:
@15a4:  ldy     #.loword(GameSaveCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (save select) ]

UpdateGameSaveCursor:
@15aa:  jsr     MoveCursor

InitGameSaveCursor:
@15ad:  ldy     #.loword(GameLoadCursorPos+2)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GameSaveCursorProp:
@15b3:  .byte   $80,$00,$00,$01,$03

; ------------------------------------------------------------------------------

; [ init cursor (restore game) ]

LoadGameLoadCursor:
@15b8:  ldy     #.loword(GameLoadCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (restore game) ]

UpdateGameLoadCursor:
@15be:  jsr     MoveCursor

InitGameLoadCursor:
@15c1:  ldy     #.loword(GameLoadCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GameLoadCursorProp:
@15c7:  .byte   $80,$00,$00,$01,$04

GameLoadCursorPos:
@15cc:  .byte   $08,$1c
        .byte   $08,$3c
        .byte   $08,$74
        .byte   $08,$ac

; ------------------------------------------------------------------------------

; [ init cursor (save/restore confirm) ]

LoadSaveConfirmCursor:
@15d4:  ldy     #.loword(SaveConfirmCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (save/restore confirm) ]

UpdateSaveConfirmCursor:
@15da:  jsr     MoveCursor

InitSaveConfirmCursor:
@15dd:  ldy     #.loword(SaveConfirmCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

SaveConfirmCursorProp:
@15e3:  .byte   $80,$00,$00,$01,$02

SaveConfirmCursorPos:
@15e8:  .byte   $bf,$44
        .byte   $bf,$54

; ------------------------------------------------------------------------------

; [ draw save select menu ]

DrawGameSaveMenu:
@15ec:  jsr     ClearBG2ScreenA
        jsr     DrawSaveSlotWindows
        jsr     _c33a87
        ldy     #.loword(SaveTitleWindow)
        jsr     DrawWindow
        lda     #$20                    ; white text
        sta     $29
        ldy     #.loword(SaveTitleText)
        jsr     DrawPosText
        jmp     TfrSaveSlotWindows

; ------------------------------------------------------------------------------

; [ draw restore game menu ]

DrawGameLoadMenu:
@1608:  jsr     ClearBG2ScreenA
        stz     $1d4e
        jsr     InitWindowPal
        jsr     _c33a87
        ldy     #.loword(SaveTitleWindow)
        jsr     DrawWindow
        lda     $1d4e
        and     #$70
        sta     $1d4e
        jsr     DrawSaveSlotWindows
        lda     #$20                    ; white text
        sta     $29
        ldy     #.loword(NewGameText)
        jsr     DrawPosText
        jmp     TfrSaveSlotWindows

; ------------------------------------------------------------------------------

; [ draw save slot windows ]

DrawSaveSlotWindows:
@1632:  jsr     LoadGrayCharPal
        lda     #$20
        trb     $43                     ; enable hdma #5
        ldy     #$0002
        sty     $37                     ; bg1 vscroll
        ldy     $1d55                   ; save font color
        sty     $e7
        ldy     #$7fff                  ; set font color to white
        sty     $1d55
        jsr     InitFontColor
        ldy     $e7
        sty     $1d55                   ; restore font color
        lda     #1
        jsl     InitGradientHDMA
        jsr     ClearBG1ScreenA
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenC

; slot 1
        jsr     PushSRAM
        lda     #$01
        sta     $66                     ; current save slot = 1
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        sty     $91
        beq     @1682                   ; branch if checksum invalid
        jsr     MakeSaveSlot1PalList
        jsr     DrawSave1GameText
        jsr     LoadSaveSlot1WindowPal
        bra     @1695
@1682:  jsr     PopSRAM
        jsr     MakeSaveSlot1PalList
        lda     #$20                    ; white text
        sta     $29
        ldy     #.loword(SaveSlot1EmptyText)
        jsr     DrawPosText
        jsr     LoadSaveSlot1WindowPal

; slot 2
@1695:  lda     #$02
        sta     $66                     ; current save slot = 2
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        sty     $93
        beq     @16b4
        jsr     MakeSaveSlot2PalList
        jsr     DrawSave2GameText
        jsr     LoadSaveSlot2WindowPal
        bra     @16c7
@16b4:  jsr     PopSRAM
        jsr     MakeSaveSlot2PalList
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot2EmptyText)
        jsr     DrawPosText
        jsr     LoadSaveSlot2WindowPal

; slot 3
@16c7:  lda     #$03
        sta     $66
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     CalcSaveSlotChecksum
        jsr     CheckSaveSlotChecksum
        sty     $95
        beq     @16e6
        jsr     MakeSaveSlot3PalList
        jsr     DrawSave3GameText
        jsr     LoadSaveSlot3WindowPal
        bra     @16f9
@16e6:  jsr     PopSRAM
        jsr     MakeSaveSlot3PalList
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot3EmptyText)
        jsr     DrawPosText
        jsr     LoadSaveSlot3WindowPal
@16f9:  jsr     PopSRAM
        jsr     LoadSaveSlot1WindowGfx
        ldy     #.loword(SaveSlot1Window)
        jsr     DrawWindow
        jsr     LoadSaveSlot2WindowGfx
        ldy     #.loword(SaveSlot2Window)
        jsr     DrawWindow
        jsr     LoadSaveSlot3WindowGfx
        ldy     #.loword(SaveSlot3Window)
        jsr     DrawWindow
        ldy     #$1c00
        jmp     _c30326

; ------------------------------------------------------------------------------

; [ draw text for save slot 1 ]

DrawSave1GameText:
@171d:  lda     #$20        ; white text
        sta     $29
        ldy     #.loword(SaveSlot1TimeColonText)
        jsr     DrawPosText
        lda     $1863
        jsr     HexToDec3
        ldx     #$7b0d
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7b13
        jsr     DrawNum2
        jsr     DrawSave1CharText
        lda     #$2c        ; teal text
        sta     $29
        ldy     #.loword(SaveSlot1TimeText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 1 ]

DrawSave1CharText:
@174d:  clr_ax
@174f:  lda     $69,x
        bmi     @177c       ; branch if character slot is empty
        jsr     GetCharPtr
        lda     #$2c        ; teal text
        sta     $29
        ldy     #.loword(SaveSlot1LevelText)
        jsr     DrawPosText
        lda     #$20
        sta     $29         ; white text
        ldy     #.loword(SaveSlot1HPSlashText)
        jsr     DrawPosText
        ldy     #$3a4f
        phy
        ldx     #$7afd
        phx
        ldx     #$7af3
        phx
        ldx     #$7a81
        phx
        bra     DrawSaveSlotCharText
@177c:  inx                 ; next character slot
        bra     @174f

; ------------------------------------------------------------------------------

; [ draw character text for save slot ]

DrawSaveSlotCharText:
@177f:  ldx     $67
        lda     a:$0008,x     ; character's level
        jsr     HexToDec3
        plx
        jsr     DrawNum2
        ldy     $67
        jsr     CheckMaxHP
        lda     $0009,y     ; current hp
        sta     $f3
        lda     $000a,y
        sta     $f4
        jsr     HexToDec5
        plx
        jsr     DrawNum4
        ldx     $67
        lda     a:$000b,x     ; max hp
        sta     $f3
        lda     a:$000c,x
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        jsr     HexToDec5
        plx
        jsr     DrawNum4
        ply
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; [ update pointer to current character data ]

GetCharPtr:
@17be:  longa
        txa
        asl
        tax
        lda     $6d,x
        sta     $67
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw text for save slot 2 ]

DrawSave2GameText:
@17ca:  lda     #$20        ; white text
        sta     $29
        ldy     #.loword(SaveSlot2TimeColonText)
        jsr     DrawPosText
        lda     $1863       ; game time
        jsr     HexToDec3
        ldx     #$7ccd
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7cd3
        jsr     DrawNum2
        jsr     DrawSave2CharText
        lda     #$2c        ; teal text
        sta     $29
        ldy     #.loword(SaveSlot2TimeText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 2 ]

DrawSave2CharText:
@17fa:  clr_ax
@17fc:  lda     $69,x
        bmi     @182a
        jsr     GetCharPtr
        lda     #$2c
        sta     $29
        ldy     #.loword(SaveSlot2LevelText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot2HPSlashText)
        jsr     DrawPosText
        ldy     #$3c0f
        phy
        ldx     #$7cbd
        phx
        ldx     #$7cb3
        phx
        ldx     #$7c41
        phx
        jmp     DrawSaveSlotCharText
@182a:  inx
        bra     @17fc

; ------------------------------------------------------------------------------

; [ draw text for save slot 3 ]

DrawSave3GameText:
@182d:  lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot3TimeColonText)
        jsr     DrawPosText
        lda     $1863
        jsr     HexToDec3
        ldx     #$7e8d
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7e93
        jsr     DrawNum2
        jsr     DrawSave3CharText
        lda     #$2c
        sta     $29
        ldy     #.loword(SaveSlot3TimeText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw character text for save slot 3 ]

DrawSave3CharText:
@185d:  clr_ax
@185f:  lda     $69,x
        bmi     @188d
        jsr     GetCharPtr
        lda     #$2c
        sta     $29
        ldy     #.loword(SaveSlot3LevelText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        ldy     #.loword(SaveSlot3HPSlashText)
        jsr     DrawPosText
        ldy     #$3dcf
        phy
        ldx     #$7e7d
        phx
        ldx     #$7e73
        phx
        ldx     #$7e01
        phx
        jmp     DrawSaveSlotCharText
@188d:  inx
        bra     @185f

; ------------------------------------------------------------------------------

; [ transfer save slot windows to vram ]

TfrSaveSlotWindows:
@1890:  jsr     TfrBG1ScreenAB
        jsr     TfrBG2ScreenAB
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

SaveTitleWindow:
@189c:  .byte   $cb,$58,$1c,$02

SaveSlot1Window:
@18a0:  .byte   $cb,$59,$1c,$05

SaveSlot2Window:
@18a4:  .byte   $8b,$5b,$1c,$05

SaveSlot3Window:
@18a8:  .byte   $4b,$5d,$1c,$05

; ------------------------------------------------------------------------------

; [ save sram at 7e/ac8d ]

PushSRAM:
@18ac:  ldy     #$ac8d
        sty     hWMADDL
        ldx     $00
@18b4:  lda     $1600,x
        sta     hWMDATA
        inx
        cpx     #$0a00
        bne     @18b4
        rts

; ------------------------------------------------------------------------------

; [ restore sram from 7e/ac8d ]

PopSRAM:
@18c1:  ldx     $00
@18c3:  lda     $7eac8d,x
        sta     $1600,x
        inx
        cpx     #$0a00
        bne     @18c3
        rts

; ------------------------------------------------------------------------------

_c318d1:
@18d1:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(_c318f0)
        sty     $4352
        lda     #^_c318f0
        sta     $4354
        lda     #^_c318f0
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

_c318f0:
@18f0:  .byte   $20,$00,$00,$0c,$04,$00,$0c,$08,$00,$08,$c8,$ff,$50,$00,$00,$58
        .byte   $00,$00,$00

; ------------------------------------------------------------------------------

; [ update character sprites (save menu) ]

DrawSaveMenuChars:
@1903:  ldx     $00
@1905:  lda     $7eaa71,x               ; branch if no character in this slot
        bmi     @1977
        phx
        phx
        lda     #3
        ldy     #.loword(SaveMenuCharTask)
        jsr     CreateTask
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        lda     $66                     ; selected save slot
        beq     @1931
        cmp     #$01
        beq     @1943
        cmp     #$02
        beq     @193a

; slot 3
        lda     f:SaveMenuCharPalTbl+36,x
        sta     $3749,y                 ; palette
        bra     @194a

; new game
@1931:  lda     f:SaveMenuCharPalTbl,x
        sta     $3749,y
        bra     @194a

; slot 2
@193a:  lda     f:SaveMenuCharPalTbl+24,x
        sta     $3749,y
        bra     @194a

; slot 1
@1943:  lda     f:SaveMenuCharPalTbl+12,x
        sta     $3749,y
@194a:  lda     #^PartyCharAnimTbl
        sta     $35ca,y
        clr_a
        sta     $33cb,y
        sta     $344b,y
        lda     f:SaveMenuCharXTbl,x
        sta     $33ca,y                 ; x position
        lda     f:SaveMenuCharYTbl,x
        sta     $344a,y                 ; y position
        lda     $7eaa71,x
        longa
        asl
        tax
        lda     f:PartyCharAnimTbl,x
        sta     $32c9,y                 ; pointer to animation data
        shorta
        plb
        plx
@1977:  inx
        cpx     #12
        bne     @1905
        sec
        rts

; ------------------------------------------------------------------------------

; x positions for character sprites
SaveMenuCharXTbl:
@197f:  .byte   $50,$68,$80,$98
        .byte   $50,$68,$80,$98
        .byte   $50,$68,$80,$98

; y positions for character sprites
SaveMenuCharYTbl:
@198b:  .byte   $40,$40,$40,$40
        .byte   $78,$78,$78,$78
        .byte   $b0,$b0,$b0,$b0

; palette assignments for character sprites
SaveMenuCharPalTbl:
@1997:  .byte   $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
@19a3:  .byte   $00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
@19af:  .byte   $02,$02,$02,$02,$00,$00,$00,$00,$02,$02,$02,$02
@19bb:  .byte   $02,$02,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; [ character sprite task (save menu) ]

SaveMenuCharTask:
@19c7:  ldx     $2d
        jsr     InitAnimTask
        jsr     UpdateAnimTask
        clc
        rts

; ------------------------------------------------------------------------------

; [ calculate saved game data checksum ]

CalcSaveSlotChecksum:
@19d1:  stz     $e7                     ; +$e7 = sram checksum
        stz     $e8
        ldx     $00
        clc
@19d8:  lda     $1600,x                 ; sum all bytes of saved game data
        adc     $e7
        sta     $e7
        clr_a
        adc     $e8
        sta     $e8
        inx
        cpx     #$09fe
        bne     @19d8
        rts

; ------------------------------------------------------------------------------

; [ check saved game data checksum ]

; +$e7 = calculated checksum

CheckSaveSlotChecksum:
@19eb:  longa
        lda     $e7
        cmp     $1ffe
        bne     @19f6                   ; return 0 if invalid
        bra     @19f7                   ; return checksum value if valid
@19f6:  clr_a
@19f7:  tay
        shorta
        rts

; ------------------------------------------------------------------------------

; [ menu state $53: fade out (save menu) ]

MenuState_53:
@19fb:  jsr     CreateFadeOutTask
        ldy     #$0008
        sty     $20
        lda     #$54
        sta     $26
        jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; [ menu state $52: fade in (save menu) ]

MenuState_52:
@1a0a:  jsr     CreateFadeInTask
        ldy     #$0008
        sty     $20
        lda     #$54
        sta     $26
        jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; [ menu state $54: wait for fade (save menu) ]

MenuState_54:
@1a19:  ldy     $20
        bne     @1a21
        lda     $27                     ; go to next menu state
        sta     $26
@1a21:  jmp     DrawSaveMenuChars

; ------------------------------------------------------------------------------

; c3/1a24: ( 3, 8) "Empty"
SaveSlot1EmptyText:
@1a24:  .word   $7a4f
        .byte   $84,$a6,$a9,$ad,$b2,$00

; c3/1a2c: ( 3,15) "Empty"
SaveSlot2EmptyText:
@1a2c:  .word   $7c0f
        .byte   $84,$a6,$a9,$ad,$b2,$00

; c3/1a34: ( 3,22) "Empty"
SaveSlot3EmptyText:
@1a34:  .word   $7dcf
        .byte   $84,$a6,$a9,$ad,$b2,$00

; c3/1a3c: ( 3,10) "Time"
SaveSlot1TimeText:
@1a3c:  .word   $7acf
        .byte   $93,$a2,$a6,$9e,$00

; c3/1a43: ( 3,17) "Time"
SaveSlot2TimeText:
@1a43:  .word   $7c8f
        .byte   $93,$a2,$a6,$9e,$00

; c3/1a4a: ( 3,24) "Time"
SaveSlot3TimeText:
@1a4a:  .word   $7e4f
        .byte   $93,$a2,$a6,$9e,$00

; c3/1a51: ( 4,11) ":"
SaveSlot1TimeColonText:
@1a51:  .word   $7b11
        .byte   $c1,$00

; c3/1a55: ( 4,18) ":"
SaveSlot2TimeColonText:
@1a55:  .word   $7cd1
        .byte   $c1,$00

; c3/1a59: ( 4,25) ":"
SaveSlot3TimeColonText:
@1a59:  .word   $7e91
        .byte   $c1,$00

; c3/1a5d: (25, 8) "LV"
SaveSlot1LevelText:
@1a5d:  .word   $7a7b
        .byte   $8b,$95,$00

; c3/1a62: (25,15) "LV"
SaveSlot2LevelText:
@1a62:  .word   $7c3b
        .byte   $8b,$95,$00

; c3/1a67: (25,22) "LV"
SaveSlot3LevelText:
@1a67:  .word   $7dfb
        .byte   $8b,$95,$00

; c3/1a6c: (25,10) "/"
SaveSlot1HPSlashText:
@1a6c:  .word   $7afb
        .byte   $c0,$00

; c3/1a70: (25,17) "/"
SaveSlot2HPSlashText:
@1a70:  .word   $7cbb
        .byte   $c0,$00

; c3/1a74: (25,24) "/"
SaveSlot3HPSlashText:
@1a74:  .word   $7e7b
        .byte   $c0,$00

; c3/1a78: (15, 4) "Save"
SaveTitleText:
@1a78:  .word   $7967
        .byte   $92,$9a,$af,$9e,$00

; c3/1a7f: (13, 4) "New Game"
NewGameText:
@1a7f:  .word   $7963
        .byte   $8d,$9e,$b0,$ff,$86,$9a,$a6,$9e,$00

; ------------------------------------------------------------------------------

; [ menu state $04: main menu (init) ]

MenuState_04:
@1a8a:  jsr     DisableInterrupts
        jsr     InitPortraits
        jsr     DisableDMA2
        jsr     DisableWindow2PosHDMA
        lda     #$04        ; enable hdma channel #2 (window 1 position)
        tsb     $43
        jsr     DisableDMA2
        jsr     ClearBGScroll
        lda     #$03        ; set bg1 data address and screen size (4 screens)
        sta     hBG1SC
        lda     #$43        ; set bg3 data address and screen size (4 screens)
        sta     hBG3SC
        lda     #$c0        ; disable hdma channel #6 and #7 (bg1 horizontal & vertical scroll)
        trb     $43
        lda     #$02        ; cursor 1 is active
        sta     $46
        jsr     DrawMainMenu
        lda     #0
        ldy     #.loword(MainMenuCursorTask)
        jsr     CreateTask
        jsr     CreateCursorTask
        jsr     _c3354e
        ldy     #$0002      ; bg1 vertical scroll = 2
        sty     $37
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #$05        ; set next menu state
        sta     $27
        lda     #$01        ; fade in
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $07: item (init) ]

MenuState_07:
@1ad6:  jsr     _c31ae2
        jsr     _c31afe
        jsr     _c31b0e
        jmp     _c31b2e

; ------------------------------------------------------------------------------

; [  ]

_c31ae2:
@1ae2:  jsr     DisableInterrupts
        jsr     InitBigText
        jsr     ClearBGScroll
        stz     $4a         ; scroll position = 0
        stz     $49         ; cursor position = 0
        lda     #$f5        ; max scroll position = 245
        sta     $5c
        lda     #$0a        ; page height = 10
        sta     $5a
        lda     #$01        ; page width = 1
        sta     $5b
        jmp     LoadItemListCursor

; ------------------------------------------------------------------------------

; [  ]

_c31afe:
@1afe:  lda     $1d4e       ; branch if cursor is not memory
        and     #$40
        beq     @1b08
        jsr     RestoreItemCursorPos
@1b08:  jsr     InitItemListCursor
        jmp     DrawItemListMenu

; ------------------------------------------------------------------------------

; [  ]

_c31b0e:
@1b0e:  jsr     InitItemBGScrollHDMA
        jsr     CreateCursorTask
        jsr     CreateScrollArrowTask1
        longa
        lda     #$0070
        sta     $7e354a,x
        lda     #$0058
        sta     $7e34ca,x
        shorta
        lda     #$01
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c31b2e:
@1b2e:  lda     #$08        ; set next menu state
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $77: item select (init, return from character select) ]

MenuState_77:
@1b35:  jsr     _c31ae2
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
        jsr     InitItemListCursor
        jsr     DrawItemListMenu
        jsr     _c31b0e
        jmp     _c31b2e

; ------------------------------------------------------------------------------

; [ menu state $09: skills (init) ]

MenuState_09:
@1b5b:  jsr     DisableInterrupts
        clr_a
        lda     $28         ; selected character slot
        tax
        lda     $69,x       ; selected character number
        jsl     UpdateEquip_ext
        jsr     InitPortraits
        jsr     DisableWindow1PosHDMA
        stz     $4a         ; clear scroll positions
        stz     $49
        jsr     InitSkillsBGScrollHDMA
        jsr     _c34c80
        jsr     LoadSkillsCursor
        lda     $1d4e       ; branch if cursor setting is not memory
        and     #$40
        beq     @1b85
        jsr     RestoreSkillsCursorPos
@1b85:  jsr     InitSkillsCursor
        jsr     CreateCursorTask
        jsr     InitBigText
        lda     #$01        ; fade in
        sta     $26
        lda     #$0a        ; set next menu state
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ init description text ]

InitBigText:
@1b99:  jsr     ClearBigTextBuf
        jsr     TfrBigTextGfx
        lda     #0
        ldy     #.loword(BigTextTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ init character portraits ]

InitPortraits:
@1ba8:  jsr     InitCharProp
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        lda     #$05                    ; enable ??? & color palette dma
        tsb     $45
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ menu state $35: equip menu (init) ]

MenuState_35:
@1bb8:  jsr     _c31bbd
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [  ]

_c31bbd:
@1bbd:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        lda     #$06
        tsb     $46
        stz     $4a
        stz     $49
        jsr     InitEquipScrollHDMA
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        jmp     CreateCursorTask

; ------------------------------------------------------------------------------

; [  ]

_c31bd7:
@1bd7:  jsr     DrawEquipMenu
        lda     #$01
        sta     $26
        lda     #$36
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $7e:  ]

MenuState_7e:
@1be5:  jsr     _c31c01
        jsr     DrawEquipTitleEquip
        jsr     _c31c0a
        lda     #$55
        jmp     _c31c15

; ------------------------------------------------------------------------------

; [ menu state $7f:  ]

MenuState_7f:
@1bf3:  jsr     _c31c01
        jsr     DrawEquipTitleRemove
        jsr     _c31c0a
        lda     #$56
        jmp     _c31c15

; ------------------------------------------------------------------------------

; [  ]

_c31c01:
@1c01:  jsr     _c31bbd
        jsr     DrawEquipMenu
        jmp     _c39614

; ------------------------------------------------------------------------------

; [  ]

_c31c0a:
@1c0a:  jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #$01
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c31c15:
@1c15:  sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $6d: equip menu after optimize ]

MenuState_6d:
@1c1a:  jsr     _c31bbd
        jsr     EquipOptimum
        lda     #$02
        sta     $25
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [ menu state $6e: equip menu after remove all ]

MenuState_6e:
@1c26:  jsr     _c31bbd
        jsr     EquipRemoveAll
        lda     #$02
        sta     $25
        bra     _c31bd7

; ------------------------------------------------------------------------------

; [ menu state $38: party equipment overview (init) ]

MenuState_38:
@1c32:  jsr     DisableInterrupts
        jsr     InitPartyEquipScrollHDMA
        jsr     DrawPartyEquipMenu
        lda     #$01
        sta     $26
        lda     #$39
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $0b: status (init) ]

MenuState_0b:
@1c46:  jsr     DisableInterrupts
        jsr     InitStatusBG3ScrollHDMA
        jsr     DrawStatusMenu
        jsr     InitStatusCursor
        lda     #$01
        sta     $26
        lda     #$0c
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ init cursor for status menu ]

InitStatusCursor:
@1c5d:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        lda     $0000,y
        cmp     #$0c
        bne     @1c78                   ; branch if not Gogo
        jsr     LoadGogoStatusCursor
        jsr     InitGogoStatusCursor
        lda     #$06
        tsb     $46
        jmp     CreateCursorTask

; not Gogo
@1c78:  lda     #$06                    ; no cursor
        trb     $46
        rts

; ------------------------------------------------------------------------------

; [ menu state $0d: config (init) ]

MenuState_0d:
@1c7d:  jsr     DisableInterrupts
        stz     $4a         ; set page to 0
        jsr     InitWindow2PosHDMA
        jsr     DrawConfigMenu
        jsr     LoadConfigPage1Cursor
        lda     $5f         ; restore cursor position
        sta     $4e
        jsr     InitConfigPage1Cursor
        jsr     CreateCursorTask
        lda     #$01
        sta     $26         ; fade in
        lda     #$0e
        sta     $27         ; config menu state
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $13: save select (init) ]

MenuState_13:
@1ca0:  jsr     DisableInterrupts
        ldy     #$0002
        sty     $37         ; bg1 vscroll
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #$e3
        trb     $43         ; disable hdma 2, 3, 4
        jsr     DrawGameSaveMenu
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadGameSaveCursor
        ldy     $91
        bne     @1cc7
        ldy     $93
        bne     @1cc7
        ldy     $95
        beq     @1ccd
@1cc7:  lda     $0224       ; current save slot
        dec
        sta     $4e         ; set cursor position
@1ccd:  jsr     InitGameSaveCursor
        jsr     CreateCursorTask
        lda     $4b
        inc
        sta     $66         ; save slot
        lda     #$52        ; menu state $52 (fade in, save menu)
        sta     $26
        lda     #$14        ; next menu state $14 (save select)
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $15: save confirm (init) ]

MenuState_15:
@1ce3:  jsr     DisableInterrupts
        jsr     InitCharProp
        jsr     DrawGameSaveConfirmMenu
        jsr     LoadSaveConfirmCursor
        jsr     InitSaveConfirmCursor
        jsr     CreateCursorTask
        jsr     _c318d1
        lda     #$16        ; next menu state $16 (save confirm)
        sta     $27
        lda     #$01        ; menu state $01 (fade in)
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $20: restore game (init) ]

MenuState_20:
@1d03:  jsr     DisableInterrupts
        ldy     #$0002
        sty     $37
        jsr     InitMainMenuBG3VScrollHDMA
        lda     #$e3
        trb     $43
        ldy     $00
        sty     $35
        sty     $39
        sty     $3d
        lda     #$02
        sta     $46
        jsr     DrawGameLoadMenu
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadGameLoadCursor
        ldy     $91
        bne     @1d36       ; branch if slot 1 is valid
        ldy     $93
        bne     @1d36       ; branch if slot 2 is valid
        ldy     $95
        beq     @1d3c       ; branch if slot 3 is not valid
@1d36:  lda     $307ff0     ; most recently saved slot
        sta     $4e         ; set current position
@1d3c:  jsr     InitGameLoadCursor
        jsr     CreateCursorTask
        lda     $4b
        sta     $66
        lda     #$21        ; next menu state $21 (restore game)
        sta     $27
        lda     #$52        ; current menu state $52 (fade in, save menu)
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $22: restore confirm (init) ]

MenuState_22:
@1d51:  jsr     DisableInterrupts
        jsr     InitCharProp
        jsr     DrawGameLoadConfirmMenu
        jsr     LoadSaveConfirmCursor
        jsr     InitSaveConfirmCursor
        jsr     CreateCursorTask
        jsr     _c318d1
        lda     #$23
        sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $00: fade out (init) ]

MenuState_00:
@1d71:  jsr     CreateFadeOutTask
        ldy     #$0008      ; set wait counter
        sty     $20
        lda     #$02        ; set next menu state
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $01: fade in (init) ]

MenuState_01:
@1d7e:  jsr     CreateFadeInTask
        ldy     #$0008      ; set wait counter
        sty     $20
        lda     #$02        ; set next menu state
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $02: wait for fade ]

MenuState_02:
@1d8b:  ldy     $20         ; return if frame counter is not 0
        bne     @1d93
        lda     $27         ; go to next menu state
        sta     $26
@1d93:  rts

; ------------------------------------------------------------------------------

; [ menu state $03: main menu re-init (from char select) ]

MenuState_03:
@1d94:  lda     #0                      ; priority 0
        ldy     #.loword(MainMenuCursorTask)
        jsr     CreateTask
        jsr     CreateCursorTask
        lda     #$05                    ; main menu state
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $05: main menu ]

MenuState_05:
@1da4:  jsr     UpdateTimeText

; A button
        lda     $08
        bit     #$80
        beq     @1db0       ; branch if a button is not pressed
        jmp     SelectMainMenuOption

; left button
@1db0:  lda     $09
        bit     #$02
        beq     @1dbc       ; branch if left button is not pressed
        jsr     PlayMoveSfx
        jmp     MainMenuLeftBtn

; B button
@1dbc:  lda     $09
        bit     #$80
        beq     @1dd1       ; return if b button is not pressed
        stz     $0205
        jsr     PlayCancelSfx
        jsr     UpdateEquipAfterMenu
        lda     #$ff
        sta     $27         ; terminate menu
        stz     $26         ; fade out
@1dd1:  rts

; ------------------------------------------------------------------------------

; [ update field equipment effects ]

UpdateEquipAfterMenu:
@1dd2:  stz     $11df       ; clear all field equipment effects
        ldx     $00
@1dd7:  lda     $69,x       ; character in each party slot
        bmi     @1de1
        phx
        jsl     UpdateEquip_ext
        plx
@1de1:  inx                 ; next character slot
        cpx     #4
        bne     @1dd7
        rts

; ------------------------------------------------------------------------------

; [ menu state $06: main menu (select character) ]

MenuState_06:
@1de8:  jsr     UpdateTimeText

; B button
        lda     $09
        bit     #$80
        beq     @1dfd       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        lda     #$05
        trb     $46         ; disable cursor 2 and flashing cursor
        lda     #$03
        sta     $26         ; main menu (re-init)
        rts

; left button
@1dfd:  lda     $09         ; branch if left button is not pressed
        bit     #$02
        beq     @1e1f
        lda     $25         ; branch if not equip or relic
        cmp     #$02
        beq     @1e0d
        cmp     #$03
        bne     @1e1f
@1e0d:  jsr     PlayMoveSfx
        lda     #$06
        trb     $46         ; disable cursor 1 and 2
        lda     #$37
        sta     $26         ; set menu state to $37 (select all)
        lda     $4e         ; save cursor position
        sta     $5e
        jmp     CreateMultiCursorTask

; A button
@1e1f:  lda     $08         ; return if a button is not pressed
        bit     #$80
        beq     @1e2c
        lda     $4b         ; cursor selection
        sta     $28         ; set selected character slot
        jmp     _c31e2d
@1e2c:  rts

; ------------------------------------------------------------------------------

; [  ]

_c31e2d:
@1e2d:  jsr     CheckSkillValid
        bcs     @1e42       ; branch if not
        clr_a
        lda     $25         ; main menu selection
        tax
        lda     f:_c31e49,x   ; init menu state
        sta     $27
        stz     $26         ; fade out
        jsr     PlaySelectSfx
        rts
@1e42:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; init menu states for main menu commands
_c31e49:
@1e49:  .byte   $ff,$09,$35,$58,$0b

; ------------------------------------------------------------------------------

; [ check if character slot is valid (skills/equip/relic/status) ]

; carry clear = valid
; carry set = invalid

CheckSkillValid:
@1e4e:  clr_a
        lda     $25         ; main menu selection
        cmp     #$01
        beq     @1e89       ; branch if skills
        cmp     #$02
        beq     @1e5f       ; branch if equip
        cmp     #$03
        beq     @1e74       ; branch if relic
        bra     @1eb3       ; branch if status (always valid)

; equip
@1e5f:  clr_a
        lda     $28
        asl
        tax
        longa
        lda     $6d,x
        shorta
        tax
        lda     a:$0000,x     ; not valid for characters $0d (umaro) and higher
        cmp     #$0d
        bcs     @1eb1
        bra     @1e9c

; relic
@1e74:  clr_a
        lda     $28
        asl
        tax
        longa
        lda     $6d,x
        shorta
        tax
        lda     a:$0000,x     ; not valid for characters $0e and higher
        cmp     #$0e
        bcs     @1eb1
        bra     @1e9c

; skills
@1e89:  jsr     _c34d3d
        lda     #$24
        ldx     $00
@1e90:  cmp     $79,x       ; branch if at least one is not disabled
        bne     @1e9c
        inx
        cpx     #$0007
        bne     @1e90
        bra     @1eb1

; check status
@1e9c:  clr_a
        lda     $28
        asl
        tax
        longa
        lda     $6d,x
        shorta
        tax
        lda     a:$0014,x     ; not valid if wound, petrify, or zombie status
        and     #$c2
        bne     @1eb1
        bra     @1eb3

; invalid
@1eb1:  sec
        rts

; valid
@1eb3:  clc
        rts

; ------------------------------------------------------------------------------

; [ menu state $37: main menu (select all for equip/relic) ]

MenuState_37:
@1eb5:  jsr     UpdateTimeText
        lda     $09
        bit     #$80
        bne     @1ec4       ; branch if b button is down
        lda     $09
        bit     #$01
        beq     @1ee5       ; branch if right button is not down
@1ec4:  jsr     PlayCancelSfx
        jsr     InitCharSelectCursor
        jsr     CreateCursorTask
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        jsr     ExecTasks
        lda     $5e         ; restore cursor position
        sta     $4e
        lda     #$06        ; menu state $06 (char select)
        sta     $26
        lda     #$08        ; disable multi-cursor
        trb     $46
        rts
@1ee5:  lda     $08         ; return if a button is not down
        bit     #$80
        beq     @1ef5
        jsr     PlaySelectSfx
        stz     $26
        lda     #$38        ; menu state $38 (equip all, init)
        sta     $27
        rts
@1ef5:  rts

; ------------------------------------------------------------------------------

; [ menu state $08: item (select) ]

_1ef6:  rts

MenuState_08:
@1ef7:  lda     #$10
        trb     $45
        clr_a
        sta     $2a
        jsr     InitBG1TilesLeftDMA1
        jsr     ScrollListPage
        bcs     _1ef6
        jsr     UpdateItemListCursor
        jsr     InitItemDesc
        lda     $09
        bit     #$80
        beq     _1f3b
        jsr     PlayCancelSfx
        ldy     $4f
        sty     $022f
        lda     $4a
        sta     $0231
        jsr     LoadItemOptionCursor
        lda     $1d4e
        and     #$40
        beq     _c31f2e
        ldy     $0234
        sty     $4d

_c31f2e:
@1f2e:  jsr     InitItemOptionCursor
        lda     #$17
        sta     $26
        jsr     ClearItemCount
        jmp     InitBG3TilesLeftDMA1
_1f3b:  lda     $08
        bit     #$80
        beq     @1f4f
        jsr     PlaySelectSfx
        lda     $4b
        sta     $28
        lda     #$19
        sta     $26
        jmp     _c32f21
@1f4f:  rts

; ------------------------------------------------------------------------------

; (branch from c3/1f9b)
_1f50:  stz     $50
        stz     $4e
        sec
        rts

; (branch from c3/1f72)
_1f56:  lda     $54
        dec
        sta     $4e
        clc
        adc     $4a
        sta     $50
        sec
        rts

; waiting (branch from c3/1f66)
_1f62:  clc
        rts

; [ scroll list text up/down one page ]

ScrollListPage:
@1f64:  lda     $20
        bne     _1f62       ; branch if wait frame counter not zero

; R button
        lda     $0a
        bit     #$10
        beq     @1f93       ; branch if R button is not pressed
        lda     $4a
        cmp     $5c
        beq     _1f56
        lda     $5c
        sec
        sbc     $4a
        cmp     $5a
        bcs     @1f7f
        bra     @1f81
@1f7f:  lda     $5a
@1f81:  sta     $e0
        lda     $4a
        clc
        adc     $e0
        sta     $4a
        lda     $50
        clc
        adc     $e0
        sta     $50
        bra     @1fb7

; L button
@1f93:  lda     $0a
        bit     #$20
        beq     _1f62       ; branch if L button is not pressed
        lda     $4a
        beq     _1f50       ; branch if at the top of the list
        cmp     $5a
        bcs     @1fa5
        lda     $4a
        bra     @1fa7
@1fa5:  lda     $5a
@1fa7:  sta     $e0
        lda     $4a
        sec
        sbc     $e0
        sta     $4a
        lda     $50
        sec
        sbc     $e0
        sta     $50
@1fb7:  jsr     PlayMoveSfx
        clr_a
        lda     $2a         ; list type
        asl
        tax
        jsr     (.loword(ScrollListPageTbl),x)
        sec
        rts

; ------------------------------------------------------------------------------

; jump table for list type
ScrollListPageTbl:
@1fc4:  .addr   ScrollListPage_00
        .addr   ScrollListPage_01
        .addr   ScrollListPage_02
        .addr   ScrollListPage_03
        .addr   ScrollListPage_04
        .addr   ScrollListPage_05

; ------------------------------------------------------------------------------

; 0: item list
ScrollListPage_00:
@1fd0:  jsr     LoadItemBG1VScrollHDMATbl
        jmp     DrawItemList

; ------------------------------------------------------------------------------

; 1: magic
ScrollListPage_01:
@1fd6:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawMagicList

; ------------------------------------------------------------------------------

; 2: lore
ScrollListPage_02:
@1fdc:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawLoreList

; ------------------------------------------------------------------------------

; 3: rage
ScrollListPage_03:
@1fe2:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawRiotList

; ------------------------------------------------------------------------------

; 4: esper
ScrollListPage_04:
@1fe8:  jsr     LoadSkillsBG1VScrollHDMATbl
        jmp     DrawGenjuList

; ------------------------------------------------------------------------------

; 5: equip/relic item list
ScrollListPage_05:
@1fee:  jsr     LoadEquipBG1VScrollHDMATbl
        jmp     DrawEquipItemList

; ------------------------------------------------------------------------------

; [ menu state $0a: skills (select option) ]

MenuState_0a:
@1ff4:  lda     #$10        ;
        tsb     $45
        lda     #$c0        ; page can't scroll up or down
        trb     $46
        jsr     UpdateSkillsCursor

; return to main menu (b button)
        lda     $09
        bit     #$80
        beq     @200f       ; branch if b button is not pressed
        jsr     PlayCancelSfx
        lda     #$04        ; fade out and init main menu
        sta     $27
        stz     $26
        rts

; open selected skills menu (a button)
@200f:  lda     $08         ; branch if a button is not pressed
        bit     #$80
        beq     @201c
        lda     $4e
        sta     $5e
        jmp     SelectSkillsOption

; go to next character (top r button)
@201c:  lda     #$09        ; next menu state (init another character's skills menu)
        sta     $e0
        bra     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ check r & l shoulder buttons ]

; $e0: menu state to go to if user pressed top R or L

CheckShoulderBtns:
@2022:  lda     $b5         ; screen mosaic
        and     #$f0
        bne     @2089       ; return if mosaic'ing

; go to next character (top R button)
        lda     $08
        bit     #$10
        beq     @2059
        lda     $25
        cmp     #$03
        bne     @203f
        jsr     _c39eeb
        lda     $99
        beq     @203f
        jsr     PlayMoveSfx
        rts
@203f:  clr_a
        lda     $28                     ; increment selected character slot
        inc
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @203f
        jsr     CheckSkillValid
        bcs     @203f
        lda     $e0
        sta     $26
        jsr     PlayMoveSfx
        rts

; go to previous character (top L button)
@2059:  lda     $08
        bit     #$20
        beq     @2089
        lda     $25
        cmp     #$03
        bne     @2070
        jsr     _c39eeb
        lda     $99
        beq     @2070
        jsr     PlayMoveSfx
        rts
@2070:  clr_a
        lda     $28                     ; decrement selected character slot
        dec
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @2070
        jsr     CheckSkillValid
        bcs     @2070
        lda     $e0
        sta     $26
        jsr     PlayMoveSfx
@2089:  rts

; ------------------------------------------------------------------------------

; [ open selected skills menu (A button) ]

SelectSkillsOption:
@208a:  clr_a
        lda     $4b                     ; current selection
        tax
        lda     $79,x                   ; branch if not enabled
        cmp     #$20
        bne     @209e
        jsr     PlaySelectSfx
        lda     $4b
        asl
        tax
        jmp     (.loword(SkillsOptionTbl),x)

; invalid selection
@209e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; skills menu jump table (espers, magic, swdtech, blitz, lore, rage, dance)
SkillsOptionTbl:
@20a5:  .addr   SkillsOption_00
        .addr   SkillsOption_01
        .addr   SkillsOption_02
        .addr   SkillsOption_03
        .addr   SkillsOption_04
        .addr   SkillsOption_05
        .addr   SkillsOption_06

; ------------------------------------------------------------------------------

; [ skills menu $00: espers (init) ]

SkillsOption_00:
@20b3:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$1000
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
        shorta
        jsr     LoadGenjuCursor
        jsr     InitGenjuCursor
        lda     #$06
        sta     $5c                     ; max page scroll position = 6
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        ldy     #$0100
        sty     $39                     ; bg2 horizontal scroll = $0100
        sty     $3d                     ; bg3 horizontal scroll = $0100
        jsr     DrawGenjuMenu
        lda     #$1e
        sta     $26
        jsr     _c32eeb
        rts

; ------------------------------------------------------------------------------

; [ skills menu $02: swdtech (init) ]

SkillsOption_02:
@20ee:  stz     $4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     _c352d7
        lda     #$3e
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $03: blitz (init) ]

SkillsOption_03:
@2105:  stz     $4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     DrawBlitzMenu
        lda     #$33
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $01: magic (init) ]

SkillsOption_01:
@211c:  jsr     _c32130
        jsr     _c32148
        jsr     _c32158
        jsr     _c351c6
        jsr     InitBG3TilesRightDMA1
        lda     #$1a
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32130:
@2130:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$050d
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32148:
@2148:  jsr     LoadMagicCursor
        lda     $1d4e
        and     #$40
        beq     @2155
        jsr     RestoreMagicCursorPos
@2155:  jmp     InitMagicCursor

; ------------------------------------------------------------------------------

; [  ]

_c32158:
@2158:  lda     #$13
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        ldy     #$0100
        sty     $39
        sty     $3d
        jmp     _c34d7f

; ------------------------------------------------------------------------------

; [ skills menu $04: lore (init) ]

SkillsOption_04:
@216e:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$0600
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
        shorta
        jsr     LoadLoreCursor
        jsr     InitLoreCursor
        lda     #$10
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$01
        sta     $5b
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     _c351f9
        lda     #$1b
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $05: rage (init) ]

SkillsOption_05:
@21a6:  stz     $4a
        jsr     CreateScrollArrowTask1
        longa
        lda     #$00cc
        sta     $7e354a,x
        lda     #$0068
        sta     $7e34ca,x
        shorta
        jsr     LoadRiotCursor
        jsr     InitRiotCursor
        lda     #$78
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     _c35391
        lda     #$1d
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ skills menu $06: dance (init) ]

SkillsOption_06:
@21de:  stz     $4a
        jsr     LoadAbilityCursor
        jsr     InitAbilityCursor
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     DrawDanceMenu
        lda     #$1c
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $0c: status ]

MenuState_0c:
@21f5:  jsr     InitBG3TilesLeftDMA1

; shoulder R button
        lda     $08
        bit     #$10
        beq     @221e
        lda     $28
        sta     $79
@2202:  clr_a
        lda     $28
        inc
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @2202
        lda     $28
        cmp     $79
        beq     @2218
        jsr     PlayMoveSfx
@2218:  jsr     InitStatusCursor
        jmp     _c35d83

; shoulder L button
@221e:  lda     $08
        bit     #$20
        beq     @2244
        lda     $28
        sta     $79
@2228:  clr_a
        lda     $28
        dec
        and     #$03
        sta     $28
        tax
        lda     $69,x
        bmi     @2228
        lda     $28
        cmp     $79
        beq     @223e
        jsr     PlayMoveSfx
@223e:  jsr     InitStatusCursor
        jmp     _c35d83

; B button
@2244:  lda     $09
        bit     #$80
        beq     @2254
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts
@2254:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        lda     $0000,y
        cmp     #$0c
        bne     @22b3                   ; return if not Gogo
        jsr     UpdateGogoStatusCursor

; A button
        lda     $08
        bit     #$80
        beq     @22b3
        jsr     PlaySelectSfx
        lda     $4b
        sta     $e7
        stz     $e8
        clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        longa
        tya
        clc
        adc     $e7
        tay
        shorta
        lda     $0016,y
        cmp     #$12
        beq     @22b3
        jsr     _c32f06
        lda     $4e
        sta     $5e
        lda     $4b
        sta     $64
        lda     #$06
        sta     $20
        ldy     #$000c
        sty     $9c
        lda     #$6a
        sta     $27
        lda     #$65
        sta     $26
        jsr     LoadGogoCmdListCursor
        lda     $7e9d89
        sta     $54
        jmp     InitGogoCmdListCursor
@22b3:  rts

; ------------------------------------------------------------------------------

; [ menu state $6b: unused ]

MenuState_6b:
@22b4:  lda     $09
        bit     #$80
        beq     @22c4
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts
@22c4:  rts

; ------------------------------------------------------------------------------

; [ menu state $0e: config ]

MenuState_0e:
@22c5:  jsr     InitBG1TilesDMA1
        lda     $0b
        bit     #$04
        beq     @22e0
        lda     $4e
        cmp     #$08
        bne     @22e0
        lda     #$50
        sta     $26
        lda     #$11
        sta     $20
        jsr     PlayMoveSfx
        rts
@22e0:  lda     $0b
        bit     #$08
        beq     @22fa
        lda     $4e
        bne     @22fa
        lda     $4a
        beq     @22fa
        lda     #$51
        sta     $26
        lda     #$11
        sta     $20
        jsr     PlayMoveSfx
        rts
@22fa:  lda     $4a
        beq     @2303
        jsr     UpdateConfigPage2Cursor
        bra     @2306
@2303:  jsr     UpdateConfigPage1Cursor

; B button
@2306:  lda     $09
        bit     #$80
        beq     @2316
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts

; left or right button
@2316:  lda     $0b
        bit     #$01
        bne     @2322
        lda     $0b
        bit     #$02
        beq     @2325
@2322:  jmp     ChangeConfigOption

; A button
@2325:  lda     $08
        bit     #$80
        beq     @232e
        jmp     SelectConfigOption
@232e:  jmp     ScrollConfigPage

; ------------------------------------------------------------------------------

; [ select config option ]

SelectConfigOption:
@2331:  lda     $4e
        sta     $5f
        lda     $4a
        bne     SelectConfigOptionPage2

; page 1
        clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectConfigOptionTbl),x)

; ------------------------------------------------------------------------------

; config options that can't be selected
SelectConfigOptionReturn:
@2341:  rts

; ------------------------------------------------------------------------------

SelectConfigOptionPage2:
@2342:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectConfigOptionTbl+18),x)

; ------------------------------------------------------------------------------

; config option jump table (page 1)
SelectConfigOptionTbl:
@234a:  .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOption_03
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOption_08

; config option jump table (page 2)
@235c:  .addr   SelectConfigOptionReturn
        .addr   SelectConfigOptionReturn
        .addr   SelectConfigOption_0b
        .addr   SelectConfigOption_0c
        .addr   SelectConfigOption_0d
        .addr   SelectConfigOption_0e

; ------------------------------------------------------------------------------

; [ open custom battle command menu ]

SelectConfigOption_03:
@2368:  lda     $1d4d
        bit     #$80
        beq     SelectConfigOptionReturn
        jsr     PlaySelectSfx
        lda     #$47
        sta     $27
        stz     $26
        rts

; ------------------------------------------------------------------------------

; [ open character controller select menu ]

SelectConfigOption_08:
@2379:  lda     $1d54
        bpl     SelectConfigOptionReturn
        jsr     PlaySelectSfx
        lda     #$4b
        sta     $27
        stz     $26
        rts

; ------------------------------------------------------------------------------

; [ revert font color or window color component to default ]

SelectConfigOption_0b:
SelectConfigOption_0c:
SelectConfigOption_0d:
SelectConfigOption_0e:
@2388:  jsr     PlaySelectSfx
        lda     $1d54
        and     #$38
        beq     @239b

; window color
        jsr     _c323a7
        jsr     _c33a87
        jmp     _c341c3

; font color
@239b:  ldy     #$7fff                  ; revert font color to default
        sty     $1d55
        jsr     InitFontColor
        jmp     _c341c3

; ------------------------------------------------------------------------------

; [  ]

_c323a7:
@23a7:  clr_a
        lda     $1d4e
        and     #$0f
        longa
        tay
        stz     $eb
        stz     $ed
@23b4:  dey
        bmi     @23c9
        lda     #$000e
        clc
        adc     $eb
        sta     $eb
        lda     #$0020
        clc
        adc     $ed
        sta     $ed
        bra     @23b4
@23c9:  ldx     #$312b
        stx     hWMADDL
        lda     $eb
        tay
        lda     $ed
        tax
        shorta
        lda     #$0e
        sta     $e9
@23db:  lda     $ed1c02,x
        sta     $1d57,y
        sta     hWMDATA
        inx
        iny
        dec     $e9
        bne     @23db
        rts

; ------------------------------------------------------------------------------

; [ config menu page scroll ]

ScrollConfigPage:
@23ec:  lda     $08                     ; check L and R buttons
        bit     #$10
        bne     @23f6
        bit     #$20
        beq     @240b
@23f6:  jsr     PlayMoveSfx
        stz     $5f
        lda     $4a
        bne     @2406
        lda     #1
        sta     $4a
        jmp     ShowConfigPage2
@2406:  stz     $4a
        jsr     ShowConfigPage1
@240b:  rts

; ------------------------------------------------------------------------------

; [ menu state $0f: order (select character) ]

MenuState_0f:
@240c:  jsr     UpdateTimeText
        jsr     _c36989
        lda     $09
        bit     #$80
        bne     @241e
        lda     $09
        bit     #$01
        beq     @2437
@241e:  jsr     PlayCancelSfx
        lda     #$06
        sta     $20
        ldy     #$000c
        sty     $9c
        lda     #$05
        trb     $46
        lda     #$03
        sta     $27
        lda     #$65
        sta     $26
        rts
@2437:  lda     $08
        bit     #$80
        beq     @2452
        jsr     PlaySelectSfx
        lda     $4b
        sta     $28
        lda     #$10
        sta     $26
        jsr     _c32f21
        jsr     LoadCharSelectCursorProp
        lda     $4e
        sta     $5e
@2452:  rts

; ------------------------------------------------------------------------------

; [ menu state $10: order (move/row) ]

MenuState_10:
@2453:  jsr     UpdateTimeText
        lda     $09
        bit     #$80
        beq     @246f       ; branch if b button is not pressed

; cancel
        jsr     PlayCancelSfx
        lda     #$01
        trb     $46         ; disable flashing cursor task
        lda     #$0f
        sta     $26         ; menu state $0f (order, select character)
        jsr     InitCharSelectCursor
        lda     $5e
        sta     $4e         ; restore cursor position
        rts

; no cancel
@246f:  lda     $08
        bit     #$80
        beq     @24a8       ; return if a button is not pressed
        jsr     PlaySelectSfx
        lda     $28
        cmp     $4b
        bne     @2491       ; branch if order changed

; character row changed
        lda     #$01
        trb     $46         ; disable flashing cursor task
        lda     #$12        ; menu state $12 (order, wait for portrait slide)
        sta     $26
        jsr     _c32e10
        ldy     #12
        sty     $20         ; wait 12 frames
        jmp     InitCharSelectCursor

; party order changed
@2491:  lda     #$10
        trb     $46
        lda     #$0c
        trb     $45
        jsr     CreateCharSwapTask
        lda     #$18        ; set frame counter to 24 (12 frames to hide, 12 frames to show)
        sta     $22
        lda     #$01
        trb     $46
        lda     #$11        ; menu state $11 (change party order)
        sta     $26
@24a8:  rts

; ------------------------------------------------------------------------------

; [ menu state $11: change party order ]

MenuState_11:
@24a9:  jsr     UpdateTimeText
        lda     $22
        beq     @24e0
        cmp     #$0c
        bne     @24ed
        jsr     UpdatePlayer2Chars
        jsr     _c32dd1
        jsr     _c324ee
        jsr     ClearBG1ScreenA
        jsr     DrawCharBlock1
        jsr     DrawCharBlock2
        jsr     DrawCharBlock3
        jsr     DrawCharBlock4
        jsr     SwapSavedCharCursorPos
        jsr     InitBG1TilesLeftDMA1
        jsr     InitCharSelectCursor
        jsr     ExecTasks
        jsr     WaitVblank
        lda     #$08
        tsb     $45
        rts
@24e0:  lda     #$0f        ; menu state $0f (order, select character)
        sta     $26
        lda     #$10
        tsb     $46
        lda     #$04
        tsb     $45
        rts
@24ed:  rts

; ------------------------------------------------------------------------------

; [  ]

_c324ee:
@24ee:  jsr     _c32e3c
        lda     #$01
        trb     $47
        jmp     ExecTasks

; ------------------------------------------------------------------------------

; [ update characters controlled by player 2 ]

UpdatePlayer2Chars:
@24f8:  clr_ax
        stx     $e0
        stx     $e2
        lda     $1d4f
        clc
@2502:  ror
        bcc     @2507
        inc     $e0,x
@2507:  inx
        cpx     #$0004
        bne     @2502
        clr_a
        lda     $4b
        tax
        lda     $e0,x
        sta     $e5
        lda     $28
        tax
        lda     $e0,x
        sta     $e6
        lda     $e5
        sta     $e0,x
        lda     $4b
        tax
        lda     $e6
        sta     $e0,x
        clc
        lda     $e3
        asl
        adc     $e2
        asl
        adc     $e1
        asl
        adc     $e0
        sta     $1d4f
        rts

; ------------------------------------------------------------------------------

; [ menu state $12: order (wait for portrait slide) ]

MenuState_12:
@2537:  ldy     $20
        bne     @253f
        lda     #$0f        ; menu state $0f (order, select character)
        sta     $26
@253f:  rts

; ------------------------------------------------------------------------------

; [ menu state $14: save select ]

MenuState_14:
@2540:  lda     $4b
        inc
        sta     $66
        jsr     DrawSaveMenuChars
        jsr     UpdateGameSaveCursor

; B button
        lda     $09
        bit     #$80
        beq     @255d                   ; branch if B button is not pressed
        jsr     PlayCancelSfx
        lda     $9f
        sta     $27
        lda     #$53
        sta     $26
        rts

; A button
@255d:  lda     $08
        bit     #$80
        beq     @259c                   ; return if A button is not pressed
        clr_a
        lda     $4b
        asl
        tax
        ldy     $91,x                   ; sram checksum
        bne     @2580                   ; branch if sram is valid

; slot is empty, save instantly
        lda     $66
        sta     $021f                   ; save slot to load
        jsr     PlaySuccessSfx
        jsr     SaveGame
        lda     $9e                     ; previous menu state
        sta     $27
        lda     #$53                    ; menu state $53 (fade out, save menu)
        sta     $26
        rts

; sram valid, prompt before overwriting
@2580:  jsr     PlaySelectSfx
        jsr     PushSRAM
        lda     $4b
        inc
        sta     $66
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     _c36989
        lda     #$15                    ; next menu state $15 (save confirm, init)
        sta     $27
        lda     #$53                    ; menu state $53 (fade out, save menu)
        sta     $26
@259c:  rts

; ------------------------------------------------------------------------------

; [ menu state $16 & $1f: save confirm ]

MenuState_16:
MenuState_1f:
@259d:  jsr     UpdateSaveConfirmCursor
        lda     $09
        bit     #$80
        bne     @25c2       ; branch if b button is down
        lda     $08
        bit     #$80
        beq     @25de       ; return if a button is not pressed
        lda     $4b
        bne     @25c7
        lda     $66
        sta     $021f
        jsr     PlaySuccessSfx
        jsr     SaveGame
        lda     $9e         ; previous menu state
        sta     $27
        stz     $26         ; menu state $00 (fade out)
        rts
@25c2:  jsr     PlayCancelSfx
        bra     @25ca
@25c7:  jsr     PlaySelectSfx
@25ca:  jsr     PopSRAM
        jsr     InitCharProp
        jsr     _c36989
        lda     #$13        ; menu state $13 (save select, init)
        sta     $27
        stz     $26
        lda     $66
        sta     $0224
@25de:  rts

; ------------------------------------------------------------------------------

; [ save game ]

SaveGame:
@25df:  jsr     PopSRAM
        jsr     InitCharProp
        jsr     _c36989
        longa
        inc     $1dc7       ; increment the number of times the game has been saved
        shorta
        lda     $66
        jmp     CopyGameDataToSRAM

; ------------------------------------------------------------------------------

; [ menu state $17: item options (use, arrange, rare) ]

MenuState_17:
@25f4:  lda     #$c0
        trb     $46
        lda     #$10
        tsb     $45
        jsr     InitBG1TilesLeftDMA1
        jsr     UpdateItemOptionCursor

; B button
        lda     $09
        bit     #$80
        beq     @2611
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26

; A button
@2611:  lda     $08
        bit     #$80
        beq     @261d
        jsr     PlaySelectSfx
        jsr     SelectItemOption
@261d:  rts

; ------------------------------------------------------------------------------

; [ select an item option (use, arrange, rare) ]

SelectItemOption:
@261e:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectItemOptionTbl),x)

; ------------------------------------------------------------------------------

SelectItemOptionTbl:
@2626:  .addr   SelectItemOption_00
        .addr   SelectItemOption_01
        .addr   SelectItemOption_02

; ------------------------------------------------------------------------------

; [ select use items ]

SelectItemOption_00:
@262c:  jsr     LoadItemListCursor
        lda     $1d4e
        and     #$40
        beq     @263b
        jsr     RestoreItemCursorPos
        bra     @264b
@263b:  lda     $0231
        sta     $4a
        ldy     $4d
        sty     $4f
        lda     $4a
        clc
        adc     $50
        sta     $50
@264b:  jsr     InitItemListCursor
        jsr     InitItemListText
        jsr     InitItemDesc
        jsr     InitBG3TilesLeftDMA1
        jsr     WaitVblank
        jsr     CreateScrollArrowTask1
        longa
        lda     #$0070
        sta     $7e354a,x
        lda     #$0058
        sta     $7e34ca,x
        shorta
        lda     #$08
        sta     $26
        lda     #0
        ldy     #.loword(BigTextTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ arrange items ]

SelectItemOption_01:
@267c:  jsr     ClearBG1ScreenA
        jsr     _c326b8
        jsr     SortItemsByIcon
        jsr     DrawItemList
        jsr     LoadItemOptionCursor
        jmp     _c31f2e

; ------------------------------------------------------------------------------

; [ select rare items ]

SelectItemOption_02:
@268e:  jsr     LoadRareItemCursor
        lda     $1d4e
        and     #$40
        beq     @269d
        ldy     $0232
        sty     $4d
@269d:  jsr     InitRareItemCursor
        jsr     InitRareItemList
        jsr     InitBigText
        jsr     InitRareItemDesc
        jsr     InitBG3TilesLeftDMA1
        jsr     WaitVblank
        lda     #$c0
        trb     $46
        lda     #$18
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c326b8:
@26b8:  clr_ax
@26ba:  lda     $1869,x
        sta     $7eaa8d,x
        lda     #$ff
        sta     $1869,x
        inx
        cpx     #$0100
        bne     @26ba
        clr_ax
@26ce:  lda     $1969,x
        sta     $7eab8d,x
        clr_a
        sta     $1969,x
        inx
        cpx     #$0100
        bne     @26ce
        rts

; ------------------------------------------------------------------------------

; [ sort items by their icon ]

SortItemsByIcon:
@26e0:  clr_ayx
@26e3:  lda     f:ItemIconTbl,x
        phx
        sta     $e0
        jsr     FindItemsWithIcon
        plx
        inx
        cpx     #$0011
        bne     @26e3
        rts

; ------------------------------------------------------------------------------

ItemIconTbl:
@26f5:  .byte   $ff,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7

; ------------------------------------------------------------------------------

; [ find all items with this icon ]

; $e0: icon to find

FindItemsWithIcon:
@2706:  clr_ax
@2708:  phx
        lda     $7eaa8d,x
        cmp     #$ff
        beq     @2739
        sta     hWRMPYA
        lda     #13
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     f:ItemName,x
        cmp     $e0
        bne     @2739
        plx
        lda     $7eaa8d,x
        sta     $1869,y
        lda     $7eab8d,x
        sta     $1969,y
        iny
        bra     @273a
@2739:  plx
@273a:  inx
        cpx     #$0100
        bne     @2708
        rts

; ------------------------------------------------------------------------------

; [ menu state $18: item (rare item select) ]

MenuState_18:
@2741:  lda     #$10
        trb     $45
        jsr     InitBG1TilesLeftDMA1
        jsr     UpdateRareItemCursor
        jsr     InitRareItemDesc
        lda     $09
        bit     #$80
        beq     @2778
        jsr     PlayCancelSfx
        lda     #$17
        sta     $26
        ldy     $4d
        sty     $0232
        jsr     LoadItemOptionCursor
        lda     $1d4e
        and     #$40
        beq     @276f
        ldy     $0234
        sty     $4d
@276f:  jsr     InitItemOptionCursor
        jsr     ClearItemCount
        jmp     InitBG3TilesLeftDMA1
@2778:  rts

; ------------------------------------------------------------------------------

; [ menu state $19: item (move) ]

MenuState_19:
@2779:  jsr     InitBG1TilesLeftDMA1
        jsr     UpdateItemListCursor
        jsr     InitItemDesc
        lda     $09
        bit     #$80
        beq     @2794
        jsr     PlayCancelSfx
        lda     #$01
        trb     $46
        lda     #$08
        sta     $26
        rts
@2794:  lda     $08
        bit     #$80
        beq     @27e1       ; branch if a button is not pressed
        jsr     PlaySelectSfx
        lda     $28
        cmp     $4b
        bne     @27aa
        lda     #$01
        trb     $46
        jmp     UseItem
@27aa:  lda     #$10
        tsb     $45
        lda     #$01
        trb     $46
        lda     #$08
        sta     $26
        clr_a
        lda     $28
        tay
        lda     $1869,y     ; swap item slots
        sta     $e0
        lda     $1969,y
        sta     $e1
        clr_a
        lda     $4b
        tax
        lda     $1869,x
        sta     $1869,y
        lda     $e0
        sta     $1869,x
        lda     $1969,x
        sta     $1969,y
        lda     $e1
        sta     $1969,x
        jmp     DrawItemList
@27e1:  rts

; ------------------------------------------------------------------------------

; [ menu state $1a: magic (select) ]

MenuState_1a:
@27e2:  lda     #$10
        trb     $45
        lda     #$01
        sta     $2a
        jsr     InitBG1TilesLeftDMA1
        lda     $021e
        ror
        bcc     @27f8
        jsr     InitBG3TilesRightDMA2
        bra     @27fb
@27f8:  jsr     TfrBigTextGfx
@27fb:  jsr     ScrollListPage
        bcs     @2861
        jsr     UpdateMagicCursor
        jsr     LoadMagicDesc
        jsr     _c351c6
        lda     $09
        bit     #$40
        beq     @2822
        jsr     PlaySelectSfx
        lda     $9e
        eor     #$ff
        sta     $9e
        lda     #$10
        tsb     $45
        jsr     _c34f1c
        jmp     DrawMagicList
@2822:  lda     $08
        bit     #$80
        beq     @2855
        clr_a
        lda     $4b
        tax
        lda     $7e9e09,x
        cmp     #$20
        bne     @2862
        jsr     PlaySelectSfx
        ldy     $4f
        sty     $8e
        lda     $4a
        sta     $90
        lda     $4b
        sta     $99
        jsr     GetSelMagic
        cmp     #$12
        beq     @2869       ; branch if x-zone
        cmp     #$2a
        beq     @2874       ; branch if warp
        lda     #$3a
        sta     $27
        stz     $26
        rts
@2855:  lda     $09
        bit     #$80
        beq     @2861
        jsr     InitBG1TilesLeftDMA1
        jsr     ReloadSkillsMenu
@2861:  rts
@2862:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; x-zone
@2869:  lda     $0201
        bit     #$01
        beq     @2862       ; branch if x-zone is disabled
        lda     #$04        ; return code $04
        bra     @287d

; warp
@2874:  lda     $0201
        bit     #$02
        beq     @2862       ; branch if warp is disabled
        lda     #$03        ; return code $03
@287d:  sta     $0205
        jsr     _c32cea
        lda     #$ff        ; exit menu
        sta     $27
        stz     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $1b: lore (select) ]

MenuState_1b:
@288a:  lda     #$10
        trb     $45
        lda     #$02
        sta     $2a
        jsr     InitBG1TilesLeftDMA1
        jsr     ScrollListPage
        bcs     @28a9
        jsr     UpdateLoreCursor
        jsr     LoadLoreDesc
        lda     $09
        bit     #$80
        beq     @28a9
        jsr     ReloadSkillsMenu
@28a9:  rts

; ------------------------------------------------------------------------------

; [ menu state $1c: dance (select) ]

MenuState_1c:
@28aa:  jsr     InitBG1TilesLeftDMA1
        jsr     UpdateAbilityCursor
        lda     $09
        bit     #$80
        beq     @28b9
        jsr     ReloadSkillsMenu
@28b9:  rts

; ------------------------------------------------------------------------------

; [ menu state $1d: rage (select) ]

MenuState_1d:
@28ba:  lda     #$03
        sta     $2a
        jsr     InitBG1TilesLeftDMA1
        jsr     ScrollListPage
        bcs     @28d2
        jsr     UpdateRiotCursor
        lda     $09
        bit     #$80
        beq     @28d2
        jsr     ReloadSkillsMenu
@28d2:  rts

; ------------------------------------------------------------------------------

; [ menu state $1e: espers (select) ]

MenuState_1e:
@28d3:  lda     #$10
        trb     $45
        lda     #$04
        sta     $2a
        jsr     InitBG1TilesLeftDMA1
        jsr     ScrollListPage
        bcs     @2928
        jsr     UpdateGenjuCursor
        jsr     LoadGenjuAttackDesc

; A button
        lda     $08
        bit     #$80
        beq     @291b
        jsr     PlaySelectSfx
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @2908

; open esper detail menu
        sta     $99
        jsr     InitEsperDetailMenu
        lda     #$4d
        sta     $26
        rts

; unequip esper
@2908:  lda     #$ff
        sta     $e0
        jsr     _c32929
        jsr     DrawGenjuList
        jsr     InitBG1TilesRightDMA1
        jsr     WaitVblank
        jmp     InitBG1TilesLeftDMA1

; B button
@291b:  lda     $09
        bit     #$80
        beq     @2928
        lda     #$08
        trb     $46
        jsr     ReloadSkillsMenu
@2928:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32929:
@2929:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        lda     $e0
        sta     $001e,y
        lda     $e0
        jmp     _c34f08

; ------------------------------------------------------------------------------

; [ menu state $34: wait for esper equip error message ]

MenuState_34:
@293a:  ldy     $20
        bne     @2947
        ldy     #.loword(GenjuBlankMsg)
        jsr     DrawPosText
        jmp     _c35913
@2947:  rts

; ------------------------------------------------------------------------------

; blank text to clear esper equip error
GenjuBlankMsg:
@2948:  .byte   $cd,$40,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        .byte   $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

; ------------------------------------------------------------------------------

; [ menu state $39: party equipment overview ]

MenuState_39:
@2966:  lda     $09                     ; wait for B button
        bit     #$80
        beq     @2976
        jsr     PlayCancelSfx
        lda     #$04
        sta     $27
        stz     $26
        rts
@2976:  rts

; ------------------------------------------------------------------------------

; [ menu state $33: blitz menu ]

MenuState_33:
@2977:  lda     #$10
        trb     $45
        jsr     InitBG1TilesLeftDMA1
        jsr     UpdateAbilityCursor
        jsr     LoadBlitzDesc
        lda     $09
        bit     #$80
        beq     @298d
        jsr     ReloadSkillsMenu
@298d:  rts

; ------------------------------------------------------------------------------

; [ menu state $3e: swdtech menu ]

MenuState_3e:
@298e:  lda     #$10
        trb     $45
        jsr     InitBG1TilesLeftDMA1
        jsr     UpdateAbilityCursor
        jsr     LoadBushidoDesc
        lda     $09
        bit     #$80
        beq     @29a4
        jsr     ReloadSkillsMenu
@29a4:  rts

; ------------------------------------------------------------------------------

; [ reload to skills menu ]

ReloadSkillsMenu:
@29a5:  jsr     PlayCancelSfx
        ldy     $00
        sty     $39
        sty     $3d
        lda     #$0a
        sta     $26
        jsr     _c34d27
        jsr     LoadSkillsCursor
        lda     $5e
        sta     $4e
        jsr     InitSkillsCursor
        jmp     _c35807

; ------------------------------------------------------------------------------

; [ menu state $21: restore game ]

MenuState_21:
@29c2:  lda     $4b
        sta     $66
        jsr     DrawSaveMenuChars
        jsr     UpdateGameLoadCursor
        lda     $08
        bit     #$80
        beq     @2a06
        clr_a
        lda     $4b
        beq     @2a07
        sta     $66
        dec
        asl
        tax
        ldy     $91,x
        beq     @2a00
        jsr     PushSRAM
        jsr     PlaySelectSfx
        lda     $66
        sta     $0224
        jsr     LoadSaveSlot
        jsr     InitCharProp
        jsr     _c36989
        jsr     PopTimers
        lda     #$22
        sta     $27
        lda     #$53
        sta     $26
        rts
@2a00:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@2a06:  rts
@2a07:  jsr     PlaySelectSfx
        jsr     ResetGameTime
        lda     #$01
        sta     $0224
        stz     $021f
        stz     $0205
        lda     #$ff
        sta     $27
        lda     #$53
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ clear game time ]

ResetGameTime:
@2a21:  clr_ay
        sty     $021b
        sty     $021d
        rts

; ------------------------------------------------------------------------------

; [ menu state $23:  ]

MenuState_23:
@2a2a:  jsr     UpdateSaveConfirmCursor
        lda     $09
        bit     #$80
        bne     @2a58
        lda     $08
        bit     #$80
        beq     @2a64
        jsr     PlaySelectSfx
        lda     $4b
        bne     @2a5b
        ldy     $1863
        sty     $021b
        lda     $1865
        sta     $021d
        lda     $66
        sta     $021f
        lda     #$ff
        sta     $27
        stz     $26
        rts
@2a58:  jsr     PlayCancelSfx
@2a5b:  jsr     PopSRAM
        lda     #$20
        sta     $27
        stz     $26
@2a64:  rts

; ------------------------------------------------------------------------------

; [ menu state $3a:  ]

MenuState_3a:
@2a65:  lda     #$40
        tsb     $45
        jsr     _c32a76
        jsr     _c35812
        jsr     CreateCursorTask
        lda     #$3b
        bra     _c32aa5

_c32a76:
@2a76:  jsr     DisableInterrupts
        lda     #$01
        tsb     $45
        lda     #$04
        tsb     $43
        stz     $1b
        stz     $1c
        jsr     ClearBGScroll
        jsr     InitPortraits
        lda     #$03
        sta     hBG1SC
        lda     #$c0
        trb     $43
        ldy     #$0002
        sty     $37
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        rts

_c32aa5:
@2aa5:  sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $3b:  ]

MenuState_3b:
@2aae:  lda     $08
        bit     #$10
        bne     @2ac6
        lda     $08
        bit     #$20
        bne     @2ac6
        lda     $09
        bit     #$01
        bne     @2ac6
        lda     $09
        bit     #$02
        beq     @2af3
@2ac6:  jsr     PlayMoveSfx
        jsr     GetSelMagic
        jsr     _c350f5
        longac
        lda     hMPYL
        adc     #0
        tax
        clr_a
        shorta
        lda     $c46ac0,x   ; spell data
        and     #$20
        beq     @2af3
        lda     $4e
        sta     $5f
        lda     #$06
        trb     $46
        jsr     CreateMultiCursorTask
        lda     #$3d
        sta     $26
        rts
@2af3:  lda     $08
        bit     #$80
        beq     @2afc
        jmp     @2b0c
@2afc:  lda     $09
        bit     #$80
        beq     @2b0b
        jsr     PlayCancelSfx
        lda     #$3c
        sta     $27
        stz     $26
@2b0b:  rts
@2b0c:  stz     $9c
        jsr     _c32ccc
        jsr     GetTargetCharPtr
        jsr     _c32c14
        bcc     @2b32
        jsr     _c32cea
        jsr     PlayCureSfx
        jsr     GetTargetCharPtr
        lda     $0014,y
        sta     $f8
        lda     $0015,y
        sta     $fb
        jsr     _c32b39
        jmp     _c32bde
@2b32:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32b39:
_magic_exec_call_c:
@2b39:  lda     $000b,y     ; max hp
        sta     $11b2
        lda     $000c,y
        sta     $11b3
        phy
        jsr     GetSelMagic
        ldx     $00         ; 0: spell effect
        jsl     CalcMagicEffect_ext
        ply
        lda     $9c
        beq     @2b5c
        longac
        lda     ExecTasks
        lsr
        bra     @2b61
@2b5c:  longac
        lda     ExecTasks
@2b61:  adc     $0009,y
        sta     $0009,y
        shorta
        jsr     CheckMaxHP
        lda     $fc
        sta     $0014,y
        lda     $ff
        sta     $0015,y
        lda     $9c
        bne     @2b99
        clr_a
        lda     $4b
        tax
        lda     $69,x
        jsl     UpdateEquip_ext
        clr_a
        lda     $4b
        asl
        tax
        ldy     $6d,x
        sty     $67
        lda     $11d2
        jsr     _c391ec
        lda     $11d4
        jmp     _c391fb
@2b99:  rts

; ------------------------------------------------------------------------------

; [ check current hp vs max ]

CheckMaxHP:
@2b9a:  lda     $000b,y     ; max hp
        sta     $f3
        lda     $000c,y
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        longa
        lda     $0009,y     ; current hp
        cmp     $f3
        bcc     @2bb9       ; return if not greater than max (return clear carry)
        lda     $f3
        sta     $0009,y     ; set current hp (return set carry)
        sec
@2bb9:  shorta
        rts

; ------------------------------------------------------------------------------

; [ check current mp vs max ]

CheckMaxMP:
@2bbc:  lda     $000f,y
        sta     $f3
        lda     $0010,y
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        longa
        lda     $000d,y
        cmp     $f3
        bcc     @2bdb
        lda     $f3
        sta     $000d,y
        sec
@2bdb:  shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32bde:
@2bde:  jsr     _c32c01
        jsr     _c32cdf
        jsr     GetCasterCharPtr
        jsr     GetSelMagic
        jsr     _c3510d
        stx     $e7
        ldx     a:$000d,y
        cpx     $e7
        bcs     @2c00
        lda     #$02
        sta     $46
        lda     #$3c
        sta     $27
        stz     $26
@2c00:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32c01:
@2c01:  lda     $4b
        sta     $9c
        jsr     _c324ee
        jsr     ClearBG1ScreenA
        jsr     _c33193
        jsr     LoadPortraitPal
        jmp     GetPortraitGfxPtr

; ------------------------------------------------------------------------------

; [  ]

_c32c14:
@2c14:  lda     $0014,y
        and     #$80
        bne     @2c40
        jsr     GetSelMagic
        cmp     #$2d
        beq     @2c76
        cmp     #$2e
        beq     @2c76
        cmp     #$2f
        beq     @2c76
        cmp     #$32
        beq     @2c6d
        cmp     #$33
        beq     @2c64
        cmp     #$22
        beq     @2c4d
        cmp     #$23
        beq     @2c84
        cmp     #$2c
        beq     @2c56
        bra     @2c82
@2c40:  jsr     GetSelMagic
        cmp     #$30
        beq     @2c84
        cmp     #$31
        beq     @2c84
        bra     @2c82
@2c4d:  lda     $0015,y
        and     #$80
        bne     @2c82
        bra     @2c84
@2c56:  lda     $0014,y
        and     #$7f
        ora     $0015,y
        and     #$90
        beq     @2c82
        bra     @2c84
@2c64:  lda     $0014,y
        and     #$45
        beq     @2c82
        bra     @2c84
@2c6d:  lda     $0014,y
        and     #$04
        beq     @2c82
        bra     @2c84
@2c76:  lda     $0014,y
        and     #$c2
        bne     @2c82
        jsr     CheckMaxHP
        bcc     @2c84
@2c82:  clc
        rts
@2c84:  sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32c86:
@2c86:  stz     $af
        lda     #$01
        sta     $9c
        jsr     _c32ccc
        clr_a
@2c90:  pha
        asl
        tax
        ldy     $6d,x
        beq     @2cb8
        jsr     _c32c14
        bcc     @2cb8
        lda     $0014,y
        sta     $f8
        lda     $0015,y
        sta     $fb
        jsr     _c32b39
        jsr     _c32ccc
        lda     $af
        bne     @2cb8
        jsr     PlayCureSfx
        jsr     _c32cea
        inc     $af
@2cb8:  clr_a
        pla
        inc
        cmp     #$04
        bne     @2c90
        lda     $af
        bne     @2cc9
        jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@2cc9:  jmp     _c32bde

; ------------------------------------------------------------------------------

; [  ]

_c32ccc:
@2ccc:  jsr     _c32cdf
        lda     $11a0       ; mag.pwr
        sta     $11ae       ; hit rate
        jsr     GetCasterCharPtr
        lda     $0008,y
        sta     $11af       ; level
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32cdf:
@2cdf:  clr_a
        lda     $28
        tax
        lda     $69,x
        jsl     UpdateEquip_ext
        rts

; ------------------------------------------------------------------------------

; [ subtract spell's mp cost ]

_c32cea:
@2cea:  jsr     GetSelMagic
        jsr     _c3510d
        stx     $e7
        jsr     GetCasterCharPtr
        longa
        lda     $000d,y
        sec
        sbc     $e7
        sta     $000d,y
        shorta
        rts

; ------------------------------------------------------------------------------

; [ get pointer to spell caster's character data ]

GetCasterCharPtr:
@2d03:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        rts

; ------------------------------------------------------------------------------

; [ get pointer to target character data ]

GetTargetCharPtr:
@2d0b:  clr_a
        lda     $4b         ; cursor position
        asl
        tax
        ldy     $6d,x       ; pointer to character data
        rts

; ------------------------------------------------------------------------------

; [ get selected spell index ]

GetSelMagic:
@2d13:  clr_a
        lda     $99
        tax
        lda     $7e9d89,x
        rts

; ------------------------------------------------------------------------------

; [ menu state $3c: return to magic menu after casting a spell ]

MenuState_3c:
@2d1c:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        lda     #$42
        trb     $45
        stz     $4a
        stz     $49
        jsr     InitSkillsBGScrollHDMA
        jsr     _c34c80
        jsr     CreateCursorTask
        jsr     _c32130
        jsr     LoadMagicCursor
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
        jsr     InitMagicCursor
        jsr     _c32158
        jsr     _c351c6
        jsr     TfrBG3ScreenAB
        jsr     WaitVblank
        ldy     $00
        sty     $35
        jsr     InitBigText
        lda     #$10
        tsb     $45
        jsr     InitBG1TilesLeftDMA1
        lda     #$1a
        sta     $27
        lda     #$01
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $3d:  ]

MenuState_3d:
@2d78:  lda     $08
        bit     #$10
        bne     @2d90
        lda     $08
        bit     #$20
        bne     @2d90
        lda     $09
        bit     #$01
        bne     @2d90
        lda     $09
        bit     #$02
        beq     @2d9b
@2d90:  jsr     PlayMoveSfx
        jsr     _c32db7
        lda     #$3b
        sta     $26
        rts
@2d9b:  lda     $08
        bit     #$80
        beq     @2da4
        jmp     _c32c86
@2da4:  lda     $09
        bit     #$80
        beq     @2db6
        jsr     PlayCancelSfx
        jsr     _c32db7
        lda     #$3c
        sta     $27
        stz     $26
@2db6:  rts

; ------------------------------------------------------------------------------

; [  ]

_c32db7:
@2db7:  jsr     InitCharSelectCursor
        jsr     CreateCursorTask
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        jsr     ExecTasks
        lda     $5f
        sta     $4e
        lda     #$08
        trb     $46
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32dd1:
@2dd1:  clr_a
        lda     $28
        tax
        lda     $4b
        tay
        lda     $75,x
        sta     $e0
        lda     $0075,y
        sta     $75,x
        lda     $e0
        sta     $0075,y
        lda     $69,x
        sta     $e0
        lda     $0069,y
        sta     $69,x
        lda     $e0
        sta     $0069,y
        clr_a
        lda     $28
        asl
        tax
        lda     $4b
        asl
        tay
        longa
        lda     $6d,x
        sta     $e7
        lda     $006d,y
        sta     $6d,x
        lda     $e7
        sta     $006d,y
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32e10:
@2e10:  clr_a
        lda     $28
        tax
        lda     $75,x
        sta     $e0
        lda     $60,x
        tax
        lda     $e0
        bit     #$20
        beq     @2e29
        lda     #$20
        trb     $e0
        lda     #$03
        bra     @2e2f
@2e29:  lda     #$20
        tsb     $e0
        lda     #$02
@2e2f:  sta     $7e3649,x
        clr_a
        lda     $28
        tax
        lda     $e0
        sta     $75,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32e3c:
@2e3c:  clr_a
        lda     $60
        tax
        lda     #$ff
        sta     $7e35c9,x
        lda     $61
        tax
        lda     #$ff
        sta     $7e35c9,x
        lda     $62
        tax
        lda     #$ff
        sta     $7e35c9,x
        lda     $63
        tax
        lda     #$ff
        sta     $7e35c9,x
        rts

; ------------------------------------------------------------------------------

; [ main menu: a button pressed ]

SelectMainMenuOption:
@2e62:  clr_a
        lda     $4b
        sta     $25         ; set main menu cursor position
        asl
        tax
        jmp     (.loword(SelectMainMenuOptionTbl),x)

; ------------------------------------------------------------------------------

; main menu jump table
SelectMainMenuOptionTbl:
@2e6c:  .addr   SelectMainMenuOption_00
        .addr   SelectMainMenuOption_01
        .addr   SelectMainMenuOption_02
        .addr   SelectMainMenuOption_03
        .addr   SelectMainMenuOption_04
        .addr   SelectMainMenuOption_05
        .addr   SelectMainMenuOption_06

; ------------------------------------------------------------------------------

; config
SelectMainMenuOption_05:
@2e7a:  jsr     PlaySelectSfx
        stz     $5f
        stz     $26                     ; fade out
        lda     #$0d
        sta     $27                     ; config (init)
        rts

; ------------------------------------------------------------------------------

; item
SelectMainMenuOption_00:
@2e86:  jsr     PlaySelectSfx
        stz     $26                     ; fade out
        lda     #$07
        sta     $27                     ; item (init)
        rts

; ------------------------------------------------------------------------------

; skills, equip, relic, status
SelectMainMenuOption_01:
SelectMainMenuOption_02:
SelectMainMenuOption_03:
SelectMainMenuOption_04:
@2e90:  jsr     PlaySelectSfx
        lda     #$02
        trb     $46                     ; disable cursor 1
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        jsr     _c32f06
        lda     #$06
        sta     $26                     ; character select menu state
        rts

; ------------------------------------------------------------------------------

; save
SelectMainMenuOption_06:
@2eaa:  lda     $0201                   ; branch if save is not enabled
        bpl     @2ebf
        jsr     PlaySelectSfx
        stz     $26                     ; fade out
        lda     #$13
        sta     $27                     ; save select (init) menu state
        sta     $9e                     ;
        lda     #$04
        sta     $9f                     ;
        rts
@2ebf:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [ main menu: left button pressed ]

MainMenuLeftBtn:
@2ec6:  lda     #$02                    ; disable cursor 1
        trb     $46
        jsr     InitCharSelectCursor
        lda     #0
        ldy     #.loword(CharSelectCursorTask)
        jsr     CreateTask
        lda     #$06
        sta     $20                     ; wait 6 frames
        ldy     #$fff4                  ; set menu scroll speed to -12
        sty     $9c
        lda     #$05                    ; disable cursor 2 and flashing cursor
        trb     $46
        lda     #$0f                    ; order (char select)
        sta     $27
        lda     #$65                    ; scroll menu
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32eeb:
@2eeb:  lda     #2
        ldy     #.loword(MultiCursorTask)
        jsr     CreateTask
        longa
        lda     #$0038
        sta     $7e33ca,x
        lda     #$0036
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create flashing cursor (2 pixels to the right) ]

_c32f06:
@2f06:  lda     #2
        ldy     #.loword(FlashingCursorTask)
        jsr     CreateTask
        longa
        lda     $55                     ; cursor x position
        inc2
        sta     $7e33ca,x               ; set task x position
        lda     $57                     ; cursor y position
        sta     $7e344a,x               ; set task y position
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create flashing cursor (4 pixels right/up) ]

_c32f21:
@2f21:  lda     #1
        ldy     #.loword(FlashingCursorTask)
        jsr     CreateTask
        longa
        lda     $55
        clc
        adc     #4
        sta     $7e33ca,x
        lda     $57
        sec
        sbc     #4
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ main menu cursor task ]

MainMenuCursorTask:
@2f42:  tax
        jmp     (.loword(MainMenuCursorTaskTbl),x)

; ------------------------------------------------------------------------------

; main menu cursor task jump table
MainMenuCursorTaskTbl:
@2f46:  .addr   MainMenuCursorTask_00
        .addr   MainMenuCursorTask_01

; ------------------------------------------------------------------------------

; state 0: init
MainMenuCursorTask_00:
@2f4a:  ldx     $2d                     ; task pointer
        lda     #$02
        tsb     $46                     ; enable cursor 1
        inc     $3649,x                 ; increment task counter
        ldy     #.loword(MainMenuCursorProp)
        jsr     LoadCursor
        lda     $1d4e                   ; branch if cursor is on memory
        and     #$40
        beq     @2f65
        ldy     $022b                   ; load saved cursor position
        sty     $4d
@2f65:  ldy     #$2f8a
        jsr     UpdateCursorPos
; fallthrough

; ------------------------------------------------------------------------------

; state 1: update
MainMenuCursorTask_01:
@2f6b:  lda     $46
        bit     #$02
        beq     @2f83                   ; terminate if cursor 1 is not active
        ldx     $2d
        jsr     MoveCursor
        ldy     #.loword(MainMenuCursorPos)
        jsr     UpdateCursorPos
        ldy     $4d
        sty     $022b                   ; save cursor position
        sec
        rts
@2f83:  clc
        rts

; ------------------------------------------------------------------------------

; main menu cursor data
MainMenuCursorProp:
@2f85:  .byte   $80,$00,$00,$01,$07

; ------------------------------------------------------------------------------

; main menu cursor positions
MainMenuCursorPos:
@2f8a:  .byte   $af,$12
        .byte   $af,$21
        .byte   $af,$30
        .byte   $af,$3f
        .byte   $af,$4e
        .byte   $af,$5d
        .byte   $af,$6c

; ------------------------------------------------------------------------------

; [ init character select cursor ]

InitCharSelectCursor:
@2f98:  jsr     LoadCharSelectCursorProp
        clr_axy
@2f9e:  lda     a:$0069,x               ; character number
        bpl     @2faa                   ; branch if slot is not empty
        phx
        txa
        asl
        tax
        stz     $85,x                   ; disable cursor position
        plx
@2faa:  inx
        cpx     #4
        bne     @2f9e
        rts

; ------------------------------------------------------------------------------

; [ load character select cursor data ]

LoadCharSelectCursorProp:
@2fb1:  ldx     $00
@2fb3:  lda     f:CharSelectCursorProp,x
        sta     $80,x
        inx
        cpx     #13
        bne     @2fb3
        rts

; ------------------------------------------------------------------------------

; [ character select cursor task ]

CharSelectCursorTask:
@2fc0:  tax
        jmp     (.loword(CharSelectCursorTaskTbl),x)

CharSelectCursorTaskTbl:
@2fc4:  .addr   CharSelectCursorTask_00
        .addr   CharSelectCursorTask_01

; ------------------------------------------------------------------------------

; [  ]

CharSelectCursorTask_00:
@2fc8:  ldx     $2d
        lda     #$14
        tsb     $46
        inc     $3649,x
        jsr     _c32ff5
        lda     $45
        bit     #$40
        bne     @2fe6
        lda     $1d4e
        and     #$40
        beq     @2fe6
        ldy     $022d
        sty     $4d
@2fe6:  jsr     _c33008
        lda     $55
        bne     @2ff3
        jsr     _c32ff5
        jsr     _c33008
@2ff3:  sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_c32ff5:
@2ff5:  ldy     #$0080
        jsr     LoadCursor
        ldy     #$0080
        lda     #$00
        sta     $ed
        jsr     LoadCursorFar
        jmp     SelectFirstChar

; ------------------------------------------------------------------------------

; [  ]

_c33008:
@3008:  ldy     #$0085
        sty     $e7
        lda     #$00
        sta     $e9
        jmp     UpdateCursorPosFar

; ------------------------------------------------------------------------------

; [  ]

CharSelectCursorTask_01:
@3014:  lda     $45
        bit     #$40
        bne     @301f
        ldy     $4d
        sty     $022d
@301f:  lda     $46
        bit     #$04
        beq     @3040
        bit     #$10
        beq     @303e
        ldx     $2d
@302b:  jsr     MoveCursor
        ldy     #$0085      ; cursor data pointer = $000085
        sty     $e7
        lda     #$00
        sta     $e9
        jsr     UpdateCursorPosFar
        lda     $55
        beq     @302b
@303e:  sec
        rts
@3040:  clc
        rts

; ------------------------------------------------------------------------------

; character select cursor data
CharSelectCursorProp:
@3042:  .byte   $80,$00,$00,$01,$04

; ------------------------------------------------------------------------------

; character select cursor positions
CharSelectCursorPos:
@3047:  .byte   $08,$28
        .byte   $08,$58
        .byte   $08,$88
        .byte   $08,$b8

; ------------------------------------------------------------------------------

; [ create fade out task ]

CreateFadeOutTask:
@304f:  clr_a                           ; priority 0
        ldy     #.loword(FadeOutTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ create fade in task ]

CreateFadeInTask:
@3056:  clr_a                           ; priority 0
        ldy     #.loword(FadeInTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ create mosaic task ]

CreateMosaicTask:
@305d:  clr_a                           ; priority 0
        ldy     #.loword(MosaicTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ mosaic task ]

MosaicTask:
@3064:  tax
        jmp     (.loword(MosaicTaskTbl),x)

MosaicTaskTbl:
@3068:  .addr   MosaicTask_00
        .addr   MosaicTask_01

; ------------------------------------------------------------------------------

; [ init mosaic ]

MosaicTask_00:
@306c:  ldx     $2d
        inc     $3649,x
        stz     $33ca,x
        lda     #$08
        sta     $3349,x
; fallthrough

; ------------------------------------------------------------------------------

; [ update mosaic ]

MosaicTask_01:
@3079:  ldx     $2d
        lda     $3349,x
        beq     @3095
        clr_a
        lda     $33ca,x
        tax
        lda     f:MosaicTbl,x
        sta     $b5                     ; set mosaic register
        ldx     $2d
        inc     $33ca,x
        dec     $3349,x
        sec
        rts
@3095:  clc
        rts

; ------------------------------------------------------------------------------

; mosaic data
MosaicTbl:
@3097:  .byte   $17,$27,$37,$47,$37,$27,$17,$07

; ------------------------------------------------------------------------------

; [ fade out task ]

FadeOutTask:
@309f:  tax
        jmp     (.loword(FadeOutTaskTbl),x)

FadeOutTaskTbl:
@30a3:  .addr   FadeOutTask_00
        .addr   FadeOutTask_01

; ------------------------------------------------------------------------------

; [ init fade out ]

FadeOutTask_00:
@30a7:  ldx     $2d
        inc     $3649,x
        lda     #$0f
        sta     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ update fade out ]

FadeOutTask_01:
@30b1:  ldy     $20
        beq     _30c4
        ldx     $2d
        lda     $33ca,x
        sta     $44
        dec     $33ca,x
        dec     $33ca,x
        sec
        rts
_30c4:  lda     #$01
        sta     $44
        clc
        rts

; ------------------------------------------------------------------------------

; [ fade in task ]

FadeInTask:
@30ca:  tax
        jmp     (.loword(FadeInTaskTbl),x)

FadeInTaskTbl:
@30ce:  .addr   FadeInTask_00
        .addr   FadeInTask_01

; ------------------------------------------------------------------------------

; [ init fade in ]

FadeInTask_00:
@30d2:  ldx     $2d
        inc     $3649,x
        lda     #$01
        sta     $344a,x
; fallthrough

; ------------------------------------------------------------------------------

; [ update fade in ]

FadeInTask_01:
@30dc:  ldy     $20
        beq     _30ef
        ldx     $2d
        lda     $344a,x
        sta     $44
        inc     $344a,x
        inc     $344a,x
        sec
        rts
_30ef:  lda     #$0f
        sta     $44
        clc
        rts

; ------------------------------------------------------------------------------

; [ init bg (main menu) ]

DrawMainMenu:
@30f5:  jsr     InitFontColor
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenB
        ldy     #.loword(MainMenuOrderWindow1)
        jsr     DrawWindow
        ldy     #.loword(MainMenuOrderWindow2)
        jsr     DrawWindow
        ldy     #.loword(MainMenuCharWindow)
        jsr     DrawWindow
        ldy     #.loword(MainMenuOptionsWindow)
        jsr     DrawWindow
        jsr     _c33170
        jsr     DrawTime
        jsr     DrawMainMenuListText
        jmp     _c3319f

; ------------------------------------------------------------------------------

; [ draw menu for confirming a save slot to save ]

DrawGameSaveConfirmMenu:
@3128:  jsr     InitFontColor
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        jsr     _c331a8
        ldy     #.loword(MainMenuCharWindow)
        jsr     DrawWindow
        ldy     #.loword(SaveChoiceWindow)
        jsr     DrawWindow
        jsr     _c33170
        jsr     _c33295
        jsr     DrawGameSaveChoiceText
        jmp     _c3319f

; ------------------------------------------------------------------------------

; [ draw menu for confirming a save slot to load ]

DrawGameLoadConfirmMenu:
@314c:  jsr     InitFontColor
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        jsr     _c331a8
        ldy     #.loword(MainMenuCharWindow)
        jsr     DrawWindow
        ldy     #.loword(SaveChoiceWindow)
        jsr     DrawWindow
        jsr     _c33170
        jsr     _c33295
        jsr     DrawGameLoadChoiceText
        jmp     _c3319f

; ------------------------------------------------------------------------------

; [  ]

_c33170:
@3170:  clr_a
        jsl     InitGradientHDMA
        ldy     #.loword(MainMenuTimeWindow)
        jsr     DrawWindow
        ldy     #.loword(MainMenuStepsWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     _c3318a
        jmp     DrawGilStepsText

; ------------------------------------------------------------------------------

; [  ]

_c3318a:
@318a:  jsr     ClearBG1ScreenA
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenC

_c33193:
@3193:  jsr     DrawCharBlock1
        jsr     DrawCharBlock2
        jsr     DrawCharBlock3
        jmp     DrawCharBlock4

; ------------------------------------------------------------------------------

; [  ]

_c3319f:
@319f:  jsr     TfrBG1ScreenAB
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

; [  ]

_c331a8:
@31a8:  lda     $66
        cmp     #$01
        beq     @31b5
        cmp     #$02
        beq     @31b8
        jmp     LoadSaveSlot3WindowGfx
@31b5:  jmp     LoadSaveSlot1WindowGfx
@31b8:  jmp     LoadSaveSlot2WindowGfx

; ------------------------------------------------------------------------------

; main menu window data

; c3/31bb: bg2_0(23, 1) [ 6x13]
MainMenuOptionsWindow:
@31bb:  .byte   $b7,$58,$06,$0d

; c3/31bf: bg2_0(23,16) [ 6x 2]
MainMenuTimeWindow:
@31bf:  .byte   $77,$5c,$06,$02

; c3/31c3: bg2_0(22,20) [ 7x 5]
MainMenuStepsWindow:
@31c3:  .byte   $75,$5d,$07,$05

; c3/31c7: bg2_0( 1, 1) [28x24]
MainMenuCharWindow:
@31c7:  .byte   $8b,$58,$1c,$18

; c3/31cb: bg2_0(22, 1) [ 7x10]
SaveChoiceWindow:
@31cb:  .byte   $b5,$58,$07,$0a

; c3/31cf: bg2_1(24, 1) [ 7x 2]
MainMenuOrderWindow1:
@31cf:  .byte   $b9,$60,$07,$02

; c3/31d3: bg2_0(30, 0) [ 1x 2]
MainMenuOrderWindow2:
@31d3:  .byte   $85,$58,$01,$02

; ------------------------------------------------------------------------------

; [ draw "yes/no/erasing data, okay?" text ]

DrawGameSaveChoiceText:
@31d7:  lda     #$20        ; white text
        sta     $29
        ldx     #.loword(GameSaveChoiceTextList)
        ldy     #$000a
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw "yes/no/this data?" text ]

DrawGameLoadChoiceText:
@31e5:  lda     #$20        ; white text
        sta     $29
        ldx     #.loword(GameLoadChoiceTextList)
        ldy     #$0008
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw "item/skills/equip/relic/status/config/save" text ]

DrawMainMenuListText:
@31f3:  lda     #$20        ; white text
        sta     $29
        ldx     #.loword(MainMenuOptionsTextList1)
        ldy     #$0008
        jsr     DrawPosList
        lda     #$20
        sta     $29
        ldx     #.loword(MainMenuOptionsTextList2)
        ldy     #$0004
        jsr     DrawPosList
        lda     $0201
        bpl     @3216       ; branch if save is disabled
        lda     #$20        ; white text
        bra     @3218
@3216:  lda     #$24        ; gray text
@3218:  sta     $29
        ldy     #.loword(MainMenuSaveText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw gp and steps ]

DrawGilStepsText:
@3221:  lda     #$20        ; white text
        sta     $29
        ldy     #.loword(MainMenuColonText)
        jsr     DrawPosText
        lda     #$2c        ; teal text
        sta     $29
        ldx     #.loword(MainMenuLabelTextList)
        ldy     #$0006
        jsr     DrawPosList
        ldy     #.loword(MainMenuGilText)
        jsr     DrawPosText
        jsr     ValidateMaxGil
        lda     #$20        ; white text
        sta     $29
        ldy     $1866       ; gp
        sty     $f1
        lda     $1868
        sta     $f3
        jsr     HexToDec8
        ldx     #$7df7
        jsr     DrawNum7
        ldy     $1860       ; steps
        sty     $f1
        lda     $1862
        sta     $f3
        jsr     HexToDec8
        ldx     #$7eb7
        jsr     DrawNum7
        rts

; ------------------------------------------------------------------------------

; [ draw game time or timer ]

DrawTime:
@326c:  lda     $1188       ; branch if timer 0 is not active
        bit     #$10
        beq     @3289
        ldy     $1189
        jsr     Div60
        jsr     Div60
        lda     $e7
        sta     $1863
        lda     hRDMPYL
        sta     $1864
        bra     _c33295
@3289:  ldy     $021b
        sty     $1863
        lda     $021d
        sta     $1865

_c33295:
@3295:  lda     #$20        ; white text
        sta     $29
        lda     $1863
        jsr     HexToDec3
        ldx     #$7cfb
        jsr     DrawNum2
        lda     $1864
        jsr     HexToDecZeroes3
        ldx     #$7d01
        jsr     DrawNum2
        rts

; ------------------------------------------------------------------------------

; [ divide by 60 ]

; convert frames to seconds, seconds to minutes, or minutes to hours

Div60:
@32b2:  sty     hWRDIVL
        lda     #60
        sta     hWRDIVB
        nop8
        nop6
        ldy     hRDDIVL
        sty     $e7
        rts

; ------------------------------------------------------------------------------

; [ check max gil ]

ValidateMaxGil:
@32ce:  lda     #$7f        ; 9999999 max
        cmp     $1860
        lda     #$96
        sbc     $1861
        lda     #$98
        sbc     $1862
        bcs     @32ea
        ldy     #$967f
        sty     $1860
        lda     #$98
        sta     $1862
@32ea:  rts

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 1) ]

_32eb:  jsr     CreatePortraitTask1
        jmp     HidePortrait

DrawCharBlock1:
@32f1:  lda     $69
        bmi     _32eb
        ldx     $6d
        stx     $67
        lda     #$24        ; teal text
        sta     $29
        ldx     #.loword(CharBlock1LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3927
        ldx     #$1578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock1SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3919
        jsr     DrawCharName
        ldx     #.loword(_c3332d)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask1

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (slot 1)
; c3/332d: bg1_0(15, 5) lv
;          bg1_0(13, 6) current hp
;          bg1_0(18, 6) max hp
;          bg1_0(13, 7) current mp
;          bg1_0(18, 7) max mp
_c3332d:
@332d:  .word   $39a7,$39e3,$39ed,$3a23,$3a2d

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 2) ]

_3337:  jsr     CreatePortraitTask2
        jmp     HidePortrait

DrawCharBlock2:
@333d:  lda     $6a
        bmi     _3337
        ldx     $6f
        stx     $67
        lda     #$24
        sta     $29
        ldx     #.loword(CharBlock2LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3aa7
        ldx     #$4578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock2SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3a99
        jsr     DrawCharName
        ldx     #.loword(_c33379)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask2

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (slot 2)
_c33379:
@3379:  .word   $3b27,$3b63,$3b6d,$3ba3,$3bad

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 3) ]

_3383:  jsr     CreatePortraitTask3
        jmp     HidePortrait

DrawCharBlock3:
@3389:  lda     $6b
        bmi     _3383
        ldx     $71
        stx     $67
        lda     #$24
        sta     $29
        ldx     #.loword(CharBlock3LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3c27
        ldx     #$7578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock3SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3c19
        jsr     DrawCharName
        ldx     #.loword(_c333c5)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask3

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (slot 3)
_c333c5:
@33c5:  .word   $3ca7,$3ce3,$3ced,$3d23,$3d2d

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text (slot 4) ]

_33cf:  jsr     CreatePortraitTask4
        jmp     HidePortrait

DrawCharBlock4:
@33d5:  lda     $6c
        bmi     _33cf       ; branch if slot is empty
        ldx     $73
        stx     $67
        lda     #$24
        sta     $29
        ldx     #.loword(CharBlock4LabelTextList)
        ldy     #6
        jsr     DrawPosList
        ldy     #$3da7
        ldx     #$a578
        stz     $48
        jsr     DrawStatusIcons
        ldx     #.loword(CharBlock4SlashTextList)
        stx     $f1
        ldy     #4
        sty     $ef
        jsr     DrawPosList
        ldy     #$3d99
        jsr     DrawCharName
        ldx     #.loword(_c33411)
        jsr     DrawCharBlock
        jmp     CreatePortraitTask4

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (character slot 4)
_c33411:
@3411:  .word   $3e27,$3e63,$3e6d,$3ea3,$3ead

; ------------------------------------------------------------------------------

; [ hide portrait ]

HidePortrait:
@341b:  longa
        lda     #$00d8      ; set y position to 216 (off-screen)
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw status icons ]

; also sets text color for hp/mp/level

DrawStatusIcons:
@3427:  stx     $e7
        jsr     InitTextBuf
        lda     $0014,y               ; status 1
        bmi     @34b0                   ; branch if character has wound status
        and     #$70                    ; isolate clear, imp, and petrify status
        sta     $e1
        lda     $0014,y
        and     #$07                    ; isolate dark, zombie, and poison status
        asl
        sta     $e2
        lda     $0015,y               ; status 4
        and     #$80                    ; isolate float status
        ora     $e1
        ora     $e2
        sta     $e1                     ; feicpzd-
        beq     @34a9                   ; branch if character has no status icons
        stz     $f1                     ; clear icon index
        stz     $f2
        ldx     #$0007                  ; loop through each status
@3451:  phx
        asl
        bcc     @349c                   ; continue if character doesn't have this status
        pha
        lda     #3
        ldy     #.loword(CharIconTask)
        jsr     CreateTask
        lda     #$01
        sta     $7e364a,x               ; task doesn't scroll with bg
        lda     $48
        sta     $7e3649,x               ; task state
        txy
        ldx     $f1                     ; icon index
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:StatusIconAnimPtrs,x
        sta     $32c9,y
        shorta
        lda     $e7
        sta     $33ca,y                 ; x position
        lda     $e8
        sta     $344a,y                 ; y position
        clr_a
        sta     $33cb,y                 ; clear high bytes
        sta     $344b,y
        lda     #^StatusIconAnimPtrs
        sta     $35ca,y                 ; animation data in bank $d8
        plb
        clc
        lda     #$0a
        adc     $e7                     ; increment positioned text pointer ???
        sta     $e7
        pla
@349c:  inc     $f1                     ; increment icon index
        inc     $f1
        plx
        dex                             ; next status
        bne     @3451
        lda     #$20                    ; white text
        sta     $29
        rts

; character has no status icons
@34a9:  lda     #$20
        sta     $29                     ; white text
        jmp     DrawCharTitle

; character has wound status
@34b0:  ldx     #$9e8b
        stx     hWMADDL
        ldx     $00
@34b8:  lda     f:MainMenuWoundedText,x               ; text: "wounded"
        sta     hWMDATA
        inx
        cpx     #$0008
        bne     @34b8
        stz     hWMDATA
        lda     #$28                    ; gray text
        sta     $29
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw character name ]

DrawCharName:
@34cf:  jsr     InitTextBuf

_c334d2:
@34d2:  ldx     #6
@34d5:  lda     $0002,y               ; character name
        sta     hWMDATA
        iny
        dex
        bne     @34d5
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw character title (dummy) ]

DrawCharTitle:
@34e5:  rts

; ------------------------------------------------------------------------------

; [ draw equipped esper name ]

DrawEquipGenju:
@34e6:  jsr     InitTextBuf
        lda     $001e,y               ; equipped esper
        cmp     #$ff
        beq     @3508                   ; branch if no esper is equipped
        asl3
        tax
        ldy     #8
@34f7:  lda     $e6f6e1,x               ; esper names
        sta     hWMDATA
        inx
        dey
        bne     @34f7
        stz     hWMDATA
        jmp     DrawPosTextBuf
@3508:  ldy     #8
        lda     #$ff
@350d:  sta     hWMDATA                 ; clear equipped esper name
        dey
        bne     @350d
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ init positioned text buffer ]

; +y: text position

InitTextBuf:
@3519:  ldx     #$9e89                  ; set pointer to text buffer
        stx     hWMADDL
        longa
        tya
        shorta
        sta     hWMDATA
        xba
        sta     hWMDATA
        clr_a
        ldy     $67
        rts

; ------------------------------------------------------------------------------

; [ disable interrupts ]

DisableInterrupts:
@352f:  lda     #$80        ; screen off
        sta     hINIDISP
        jsr     ResetTasks
        stz     hNMITIMEN
        stz     hMDMAEN
        stz     hHDMAEN
        rts

; ------------------------------------------------------------------------------

; [ enable interrupts ]

EnableInterrupts:
@3541:  lda     #$01        ; screen register (screen on, brightness 1)
        sta     $44
        jmp     WaitVblank

; ------------------------------------------------------------------------------

; [ draw time text ]

UpdateTimeText:
@3548:  jsr     InitBG3TilesLeftDMA1
        jmp     DrawTime

; ------------------------------------------------------------------------------

; [ init main screen designation hdma (main menu) ]

_c3354e:
@354e:  ldx     $00
        lda     #$17        ; main screen designation (-> $212c)
@3552:  sta     $7e9a09,x
        inx
        cpx     #$00df
        bne     @3552
        lda     #$40        ; hdma channel #3 - indirect addressing
        sta     $4360
        lda     #$2c
        sta     $4361
        ldy     #.loword(_c3357b)
        sty     $4362
        lda     #^_c3357b
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$40
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; main screen designation hdma table (main menu)
_c3357b:
@357b:  .byte   $f0
        .word   $9a09
        .byte   $f0
        .word   $9a79
        .byte   $00

; ------------------------------------------------------------------------------

; [ init character swap tasks ]

CreateCharSwapTask:
@3582:  lda     $28
        cmp     $4b
        bcc     @359d
        lda     #3
        ldy     #.loword(CharSwapTopTask)
        jsr     CreateTask
        jsr     @35c1
        lda     #3
        ldy     #.loword(CharSwapBtmTask)
        jsr     CreateTask
        bra     @35b2
@359d:  lda     #3
        ldy     #.loword(CharSwapTopTask)
        jsr     CreateTask
        jsr     @35b2
        lda     #3
        ldy     #.loword(CharSwapBtmTask)
        jsr     CreateTask
        bra     @35c1

@35b2:  txy
        clr_a
        lda     $28
        tax
        lda     f:_c335d0,x
        tyx
        sta     $7e33ca,x
        rts

@35c1:  txy
        clr_a
        lda     $4b
        tax
        lda     f:_c335d0,x
        tyx
        sta     $7e33ca,x   ; x position
        rts

; ------------------------------------------------------------------------------

_c335d0:
@35d0:  .byte   $0d,$3d,$6d,$9d

; ------------------------------------------------------------------------------

; [ character swap task (top character) ]

CharSwapTopTask:
@35d4:  tax
        jmp     (.loword(CharSwapTopTaskTbl),x)

CharSwapTopTaskTbl:
@35d8:  .addr   CharSwapTopTask_00
        .addr   CharSwapTopTask_01
        .addr   CharSwapTopTask_02

; ------------------------------------------------------------------------------

; [ state 0: init ]

CharSwapTopTask_00:
@35de:  ldx     $2d
        inc     $3649,x
; fallthrough

; ------------------------------------------------------------------------------

; [ state 1: hide character in old slot ]

CharSwapTopTask_01:
@35e3:  ldy     $2d
        lda     $22
        cmp     #$0c
        beq     @35fa
        clr_a
        lda     $33ca,y     ; x position
        tax
        lda     #$06
        jsr     UpdateCharSwapHDMA1
        sta     $33ca,y
        sec
        rts
@35fa:  ldx     $2d
        inc     $3649,x
        dec     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ state 2: show character in new slot ]

CharSwapTopTask_02:
@3602:  lda     $45
        bit     #$08
        beq     @361b
        ldy     $2d
        lda     $22
        beq     @361d
        clr_a
        lda     $33ca,y     ; x position
        tax
        lda     #$17
        jsr     UpdateCharSwapHDMA2
        sta     $33ca,y
@361b:  sec
        rts
@361d:  clc
        rts

; ------------------------------------------------------------------------------

; [ character swap task (bottom character) ]

CharSwapBtmTask:
@361f:  tax
        jmp     (.loword(CharSwapBtmTaskTbl),x)

CharSwapBtmTaskTbl:
@3623:  .addr   CharSwapBtmTask_00
        .addr   CharSwapBtmTask_01
        .addr   CharSwapBtmTask_02

; ------------------------------------------------------------------------------

; [ init ]

CharSwapBtmTask_00:
@3629:  ldx     $2d
        inc     $3649,x
        lda     $33ca,x
        clc
        adc     #$2f
        sta     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ hide character in old slot ]

CharSwapBtmTask_01:
@3637:  ldy     $2d
        lda     $22
        cmp     #$0c
        beq     @3650
        clr_a
        lda     $33ca,y
        tax
        lda     #$06
        jsr     UpdateCharSwapHDMA2
        sta     $33ca,y
        dec     $22
        sec
        rts
@3650:  ldx     $2d
        inc     $3649,x
        inc     $33ca,x
; fallthrough

; ------------------------------------------------------------------------------

; [ show character in new slot ]

CharSwapBtmTask_02:
@3658:  lda     $45
        bit     #$08
        beq     @3673
        ldy     $2d
        lda     $22
        beq     @3675
        clr_a
        lda     $33ca,y
        tax
        lda     #$17
        jsr     UpdateCharSwapHDMA1
        sta     $33ca,y
        dec     $22
@3673:  sec
        rts
@3675:  clc
        rts

; ------------------------------------------------------------------------------

; [ update bg1 hscroll dma table (character swap, hide top/show bottom) ]

UpdateCharSwapHDMA1:
@3677:  sta     $7e9a09,x
        inx
        sta     $7e9a09,x
        inx
        sta     $7e9a09,x
        inx
        sta     $7e9a09,x
        inx
        txa
        rts

; ------------------------------------------------------------------------------

; [ update bg1 hscroll dma table (character swap, show top/hide bottom) ]

UpdateCharSwapHDMA2:
@368d:  sta     $7e9a09,x
        dex
        sta     $7e9a09,x
        dex
        sta     $7e9a09,x
        dex
        sta     $7e9a09,x
        dex
        txa
        rts

; ------------------------------------------------------------------------------

; [ init bg3 vscroll hdma (main menu) ]

InitMainMenuBG3VScrollHDMA:
@36a3:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(MainMenuBG3VScrollHDMATbl)
        sty     $4352
        lda     #^MainMenuBG3VScrollHDMATbl
        sta     $4354
        lda     #^MainMenuBG3VScrollHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (main menu)
MainMenuBG3VScrollHDMATbl:
@36c2:  .byte   $0f
        .word   $0000
        .byte   $0f
        .word   $0003
        .byte   $0f
        .word   $0004
        .byte   $0f
        .word   $0005
        .byte   $0f
        .word   $0006
        .byte   $0f
        .word   $0007
        .byte   $0f
        .word   $0008
        .byte   $0f
        .word   $0009
        .byte   $07
        .word   $0008
        .byte   $08
        .word   $0000
        .byte   $08
        .word   $0000
        .byte   $18
        .word   $0000
        .byte   $00

; ------------------------------------------------------------------------------

; [ menu state $65: scroll menu horizontal ]

MenuState_65:
@36e7:  lda     $20         ; branch if wait counter is not clear
        bne     @36ef
        lda     $27         ; go to next menu state
        sta     $26
@36ef:  longa
        lda     $35         ; bg1 horizontal scroll position
        clc
        adc     $9c         ; add scroll speed
        sta     $35         ; set bg1, bg2, bg3 scroll positions
        sta     $39
        sta     $3d
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init cursor for gogo's status menu ]

LoadGogoStatusCursor:
@36ff:  ldy     #.loword(GogoStatusCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for gogo's status menu ]

UpdateGogoStatusCursor:
@3705:  jsr     MoveCursor
InitGogoStatusCursor:
@3708:  ldy     #.loword(GogoStatusCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GogoStatusCursorProp:
@370e:  .byte   $80,$00,$00,$01,$04

GogoStatusCursorPos:
@3713:  .byte   $90,$59
        .byte   $90,$65
        .byte   $90,$71
        .byte   $90,$7d

; ------------------------------------------------------------------------------

; "wounded"
MainMenuWoundedText:
@371b:  .byte   $96,$a8,$ae,$a7,$9d,$9e,$9d,$ff

; "time", "steps", "order"
MainMenuLabelTextList:
@3723:  .addr   MainMenuTimeText
        .addr   MainMenuStepsText
        .addr   MainMenuOrderText

; "item", "skills", "relic", "status"
MainMenuOptionsTextList1:
@3729:  .addr   MainMenuItemText
        .addr   MainMenuSkillsText
        .addr   MainMenuRelicText
        .addr   MainMenuStatusText

; slashes for character hp/mp
CharBlock1SlashTextList:
@3731:  .addr   CharBlock1HPSlashText
        .addr   CharBlock1MPSlashText

CharBlock2SlashTextList:
@3735:  .addr   CharBlock2HPSlashText
        .addr   CharBlock2MPSlashText

CharBlock3SlashTextList:
@3739:  .addr   CharBlock3HPSlashText
        .addr   CharBlock3MPSlashText

CharBlock4SlashTextList:
@373d:  .addr   CharBlock4HPSlashText
        .addr   CharBlock4MPSlashText

CharBlock1LabelTextList:
@3741:  .addr   CharBlock1LevelText
        .addr   CharBlock1HPText
        .addr   CharBlock1MPText

CharBlock2LabelTextList:
@3747:  .addr   CharBlock2LevelText
        .addr   CharBlock2HPText
        .addr   CharBlock2MPText

CharBlock3LabelTextList:
@374d:  .addr   CharBlock3LevelText
        .addr   CharBlock3HPText
        .addr   CharBlock3MPText

CharBlock4LabelTextList:
@3753:  .addr   CharBlock4LevelText
        .addr   CharBlock4HPText
        .addr   CharBlock4MPText

; "equip", "config"
MainMenuOptionsTextList2:
@3759:  .addr   MainMenuEquipText
        .addr   MainMenuConfigText

; "yes", "no", "this", "data?"
GameLoadChoiceTextList:
@375d:  .addr   GameLoadYesText
        .addr   GameLoadNoText
        .addr   GameLoadMsgText1
        .addr   GameLoadMsgText2

; "yes", "no", "erasing", "data.", "okay?"
GameSaveChoiceTextList:
@3765:  .addr   GameLoadYesText
        .addr   GameLoadNoText
        .addr   GameSaveMsgText1
        .addr   GameSaveMsgText2
        .addr   GameSaveMsgText3

; c3/376f: "LV"
CharBlock1LevelText:
@376f:  .byte   $9d,$39,$8b,$95,$00

; c3/3774: "HP"
CharBlock1HPText:
@3774:  .byte   $dd,$39,$87,$8f,$00

; c3/3779: "MP"
CharBlock1MPText:
@3779:  .byte   $1d,$3a,$8c,$8f,$00

; c3/377e: "/"
CharBlock1HPSlashText:
@377e:  .byte   $eb,$39,$c0,$00

; c3/3782: "/"
CharBlock1MPSlashText:
@3782:  .byte   $2b,$3a,$c0,$00

; c3/3786: "LV"
CharBlock2LevelText:
@3786:  .byte   $1d,$3b,$8b,$95,$00

; c3/378b: "HP"
CharBlock2HPText:
@378b:  .byte   $5d,$3b,$87,$8f,$00

; c3/3790: "MP"
CharBlock2MPText:
@3790:  .byte   $9d,$3b,$8c,$8f,$00

; c3/3795: "/"
CharBlock2HPSlashText:
@3795:  .byte   $6b,$3b,$c0,$00

; c3/3799: "/"
CharBlock2MPSlashText:
@3799:  .byte   $ab,$3b,$c0,$00

; c3/379d: "LV"
CharBlock3LevelText:
@379d:  .byte   $9d,$3c,$8b,$95,$00

; c3/37a2: "HP"
CharBlock3HPText:
@37a2:  .byte   $dd,$3c,$87,$8f,$00

; c3/37a7: "MP"
CharBlock3MPText:
@37a7:  .byte   $1d,$3d,$8c,$8f,$00

; c3/37ac: "/"
CharBlock3HPSlashText:
@37ac:  .byte   $eb,$3c,$c0,$00

; c3/37b0: "/"
CharBlock3MPSlashText:
@37b0:  .byte   $2b,$3d,$c0,$00

; c3/37b4: "LV"
CharBlock4LevelText:
@37b4:  .byte   $1d,$3e,$8b,$95,$00

; c3/37b9: "HP"
CharBlock4HPText:
@37b9:  .byte   $5d,$3e,$87,$8f,$00

; c3/37be: "MP"
CharBlock4MPText:
@37be:  .byte   $9d,$3e,$8c,$8f,$00

; c3/37c3: "/"
CharBlock4HPSlashText:
@37c3:  .byte   $6b,$3e,$c0,$00

; c3/37c7: "/"
CharBlock4MPSlashText:
@37c7:  .byte   $ab,$3e,$c0,$00

; c3/37cb: "Item"
MainMenuItemText:
@37cb:  .byte   $39,$79,$88,$ad,$9e,$a6,$00

; c3/37d2: "Skills"
MainMenuSkillsText:
@37d2:  .byte   $b9,$79,$92,$a4,$a2,$a5,$a5,$ac,$00

; c3/37db: "Equip"
MainMenuEquipText:
@37db:  .byte   $39,$7a,$84,$aa,$ae,$a2,$a9,$00

; c3/37e3: "Relic"
MainMenuRelicText:
@37e3:  .byte   $b9,$7a,$91,$9e,$a5,$a2,$9c,$00

; c3/37eb: "Status"
MainMenuStatusText:
@37eb:  .byte   $39,$7b,$92,$ad,$9a,$ad,$ae,$ac,$00

; c3/37f4: "Config"
MainMenuConfigText:
@37f4:  .byte   $b9,$7b,$82,$a8,$a7,$9f,$a2,$a0,$00

; c3/37fd: "Save"
MainMenuSaveText:
@37fd:  .byte   $39,$7c,$92,$9a,$af,$9e,$00

; c3/3804: "Time"
MainMenuTimeText:
@3804:  .byte   $bb,$7c,$93,$a2,$a6,$9e,$00

; c3/380b: ":"
MainMenuColonText:
@380b:  .byte   $ff,$7c,$c1,$00

; c3/380f: "Steps"
MainMenuStepsText:
@380f:  .byte   $b7,$7d,$92,$ad,$9e,$a9,$ac,$00

; c3/3817: "GP"
MainMenuGilText:
@3817:  .byte   $77,$7e,$86,$a9,$00

; c3/381c: "Yes"
GameLoadYesText:
@381c:  .byte   $bd,$7a,$98,$9e,$ac,$00

; c3/3822: "No"
GameLoadNoText:
@3822:  .byte   $3d,$7b,$8d,$a8,$00

; c3/3827: "This"
GameLoadMsgText1:
@3827:  .byte   $37,$79,$93,$a1,$a2,$ac,$00

; c3/382e: "data?"
GameLoadMsgText2:
@382e:  .byte   $b7,$79,$9d,$9a,$ad,$9a,$bf,$00

; c3/3836: "Erasing"
GameSaveMsgText1:
@3836:  .byte   $37,$79,$84,$ab,$9a,$ac,$a2,$a7,$a0,$00

; c3/3840: "data."
GameSaveMsgText2:
@3840:  .byte   $b7,$79,$9d,$9a,$ad,$9a,$c5,$00

; c3/3848: "Okay?"
GameSaveMsgText3:
@3848:  .byte   $37,$7a,$8e,$a4,$9a,$b2,$bf,$00

; c3/3850: "Order"
MainMenuOrderText:
@3850:  .byte   $3d,$81,$8e,$ab,$9d,$9e,$ab,$00

; ------------------------------------------------------------------------------

; [ init cursor (config page 1) ]

LoadConfigPage1Cursor:
@3858:  ldy     #.loword(ConfigPage1CursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (config page 1) ]

UpdateConfigPage1Cursor:
@385e:  jsr     MoveCursor

InitConfigPage1Cursor:
@3861:  ldy     #.loword(ConfigPage1CursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

ConfigPage1CursorProp:
@3867:  .byte   $81,$00,$00,$01,$09

ConfigPage1CursorPos:
@386c:  .byte   $60,$29
        .byte   $60,$39
        .byte   $60,$49
        .byte   $60,$59
        .byte   $60,$69
        .byte   $60,$79
        .byte   $60,$89
        .byte   $60,$99
        .byte   $60,$a9

; ------------------------------------------------------------------------------

; [ init cursor (config page 2) ]

LoadConfigPage2Cursor:
@387e:  ldy     #.loword(ConfigPage2CursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (config page 2) ]

UpdateConfigPage2Cursor:
@3884:  jsr     MoveCursor

InitConfigPage2Cursor:
@3887:  ldy     #.loword(ConfigPage2CursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

ConfigPage2CursorProp:
@388d:  .byte   $81,$00,$00,$01,$06

ConfigPage2CursorPos:
@3892:  .byte   $60,$29
        .byte   $60,$69
        .byte   $60,$79
        .byte   $60,$99
        .byte   $60,$a9
        .byte   $60,$b9

; ------------------------------------------------------------------------------

; [ init config bg ]

DrawConfigMenu:
@389e:  lda     #$02
        sta     hBG1SC
        ldy     #$fffb
        sty     $3f
        jsr     ClearBG2ScreenA
        ldy     #.loword(ConfigMainWindow)
        jsr     DrawWindow
        ldy     #.loword(ConfigLabelWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     _c3395e
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #$2c
        sta     $29
        ldy     #.loword(ConfigTitleText)
        jsr     DrawPosText
        lda     #$24
        sta     $29
        ldx     #.loword(ConfigLabelTextList2)
        ldy     #$000e
        jsr     DrawPosList
        lda     #$24
        sta     $29
        ldx     #.loword(ConfigLabelTextList1)
        ldy     #$0004
        jsr     DrawPosList
        lda     #$20
        sta     $29
        ldx     #.loword(ConfigSpeedTextList)
        ldy     #$0004
        jsr     DrawPosList
        jsr     DrawActiveWaitText
        jsr     DrawBattleSpeedText
        jsr     DrawMsgSpeedText
        jsr     DrawCmdConfigText
        jsr     DrawGaugeConfigText
        jsr     DrawStereoMonoText
        jsr     DrawCursorConfigText
        jsr     DrawReequipConfigText
        jsr     DrawCtrlConfigText
        lda     #$24
        sta     $29
        ldx     #.loword(ConfigLabelTextList3)
        ldy     #$0006
        jsr     DrawPosList
        jsr     _c33950
        lda     #$20
        sta     $29
        ldx     #.loword(ConfigLabelTextList4)
        ldy     #$000c
        jsr     DrawPosList
        jsr     _c33ffd
        jsr     _c340ea
        jsr     DrawConfigColors
        jsr     _c341c3
        jsr     ShowConfigPage1
        jsr     TfrBG1ScreenAB
        jsr     TfrBG3ScreenAB
        lda     #1
        ldy     #.loword(ConfigScrollArrowTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ draw color selector bars ]

_c33950:
@3950:  lda     #$30        ; use palette 8
        sta     $29
        ldx     #.loword(ConfigColorBarTextList)
        ldy     #$0006
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3395e:
@395e:  ldx     $00
        lda     #$40
        sta     hCGADD
@3965:  longa
        lda     f:MenuPal+$80,x
        sta     $7e30c9,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #$0020
        bne     @3965
        rts

; ------------------------------------------------------------------------------

; [ page indicator task (config) ]

ConfigScrollArrowTask:
@3980:  tax
        jmp     (.loword(ConfigScrollArrowTaskTbl),x)

ConfigScrollArrowTaskTbl:
@3984:  .addr   ConfigScrollArrowTask_00
        .addr   ConfigScrollArrowTask_01

; ------------------------------------------------------------------------------

; state 0: init

ConfigScrollArrowTask_00:
@3988:  ldx     $2d
        longa
        lda     #.loword(ConfigScrollArrowAnim_00)
        sta     $32c9,x
        lda     #$0078
        sta     $33ca,x
        lda     #$0018
        sta     $344a,x
        shorta
        lda     #^ConfigScrollArrowAnim_00
        sta     $35ca,x
        inc     $3649,x
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; state 1: update

ConfigScrollArrowTask_01:
@39ab:  ldy     $2d
        lda     $4a                     ; page number
        beq     @39b5
        lda     #2                      ; page 2
        bra     @39b6
@39b5:  clr_a                             ; page 1
@39b6:  tax
        longa
        lda     f:ConfigScrollArrowAnimTbl,x
        sta     $32c9,y                 ; set pointer to animation data
        shorta
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; pointers to page indicator animation data
ConfigScrollArrowAnimTbl:
@39c7:  .addr   ConfigScrollArrowAnim_00
        .addr   ConfigScrollArrowAnim_01

; page indicator animation data (pointing down)
ConfigScrollArrowAnim_00:
@39cb:  .addr   HiddenArrowSprite
        .byte   $10
        .addr   ConfigDownArrowSprite
        .byte   $10
        .addr   HiddenArrowSprite
        .byte   $ff

; page indicator animation data (pointing up)
ConfigScrollArrowAnim_01:
@39d4:  .addr   HiddenArrowSprite
        .byte   $10
        .addr   UpArrowSprite
        .byte   $10
        .addr   HiddenArrowSprite
        .byte   $ff

; page indicator sprite data (pointing down)
ConfigDownArrowSprite:
@39dd:  .byte   1
        .byte   $80,$b0,$03,$3e

; config window data
ConfigMainWindow:
@39e2:  .byte   $0b,$59,$1c,$16

ConfigLabelWindow:
@39e6:  .byte   $b7,$58,$06,$02

; ------------------------------------------------------------------------------

; [ switch to config page 2 ]

ShowConfigPage2:
@39ea:  ldy     #$00fb
        sty     $37
        jsr     LoadConfigPage2Cursor
        jmp     InitConfigPage2Cursor

; ------------------------------------------------------------------------------

; [ switch to config page 1 ]

ShowConfigPage1:
@39f5:  ldy     #$fffb
        sty     $37
        jsr     LoadConfigPage1Cursor
        jmp     InitConfigPage1Cursor

; ------------------------------------------------------------------------------

; [ menu state $50: scroll to config page 2 ]

MenuState_50:
@3a00:  lda     $20
        beq     @3a15
        lda     $4a
        bne     @3a1c
        longa
        lda     $37
        clc
        adc     #$0010
        sta     $37
        shorta
        rts
@3a15:  lda     #$01
        sta     $4a
        jsr     ShowConfigPage2
@3a1c:  lda     #$0e
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $51: scroll to config page 1 ]

MenuState_51:
@3a21:  lda     $20
        beq     @3a36
        lda     $4a
        beq     @3a47
        longa
        lda     $37
        sec
        sbc     #$0010
        sta     $37
        shorta
        rts
@3a36:  stz     $4a
        ldy     #$fffb
        sty     $37
        jsr     LoadConfigPage1Cursor
        lda     #$08
        sta     $4e
        jsr     InitConfigPage1Cursor
@3a47:  lda     #$0e
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ init window 2 position hdma ]

InitWindow2PosHDMA:
@3a4c:  lda     #$01
        sta     $4350
        lda     #$28
        sta     $4351
        ldy     #.loword(Window2PosHDMATbl)
        sty     $4352
        lda     #^Window2PosHDMATbl
        sta     $4354
        lda     #^Window2PosHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ disable window 2 position hdma ]

DisableWindow2PosHDMA:
@3a6b:  lda     #$20        ; disable hdma channel #5
        trb     $43
        lda     #$08
        sta     hWH2
        lda     #$f7
        sta     hWH3
        rts

; ------------------------------------------------------------------------------

Window2PosHDMATbl:
@3a7a:  .byte   $27,$ff,$ff
        .byte   $50,$08,$f7
        .byte   $50,$08,$f7
        .byte   $10,$ff,$ff
        .byte   $00

; ------------------------------------------------------------------------------

; [ init custom menu window ]

_c33a87:
@3a87:  ldy     #$7800                  ; vram $7800 (menu window graphics)
        sty     $14
        lda     $1d4e                   ; window index
        jsr     GetWindowGfxPtr
        lda     $1d4e
        ldx     #$0060
        jsr     LoadWindowPal
        ldy     #$1c00
        jmp     _c30326

; ------------------------------------------------------------------------------

; [ load window graphics for save slot 1 ]

LoadSaveSlot1WindowGfx:
@3aa1:  ldy     #$7a00
        sty     $14
        ldy     $91
        beq     @3ab0
        lda     $30674e
        bra     @3ab1
@3ab0:  clr_a
@3ab1:  jsr     GetWindowGfxPtr
        jsr     TfrVRAM1
        ldy     #$1820
        jmp     _c30326

; ------------------------------------------------------------------------------

; [ load window graphics for save slot 2 ]

LoadSaveSlot2WindowGfx:
@3abd:  ldy     #$7c00
        sty     $14
        ldy     $93
        beq     @3acc
        lda     $30714e
        bra     @3acd
@3acc:  clr_a
@3acd:  jsr     GetWindowGfxPtr
        jsr     TfrVRAM1
        ldy     #$1440
        jmp     _c30326

; ------------------------------------------------------------------------------

; [ load window graphics for save slot 3 ]

LoadSaveSlot3WindowGfx:
@3ad9:  ldy     #$7e00
        sty     $14
        ldy     $95
        beq     @3ae8
        lda     $307b4e
        bra     @3ae9
@3ae8:  clr_a
@3ae9:  jsr     GetWindowGfxPtr
        jsr     TfrVRAM1
        ldy     #$1060
        jmp     _c30326

; ------------------------------------------------------------------------------

; [ load save slot 1 window palette ]

LoadSaveSlot1WindowPal:
@3af5:  ldy     $91
        beq     @3aff
        lda     $30674e
        bra     @3b00
@3aff:  clr_a
@3b00:  ldx     #$0040
        jsr     LoadWindowPal
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ load save slot 2 window palette ]

LoadSaveSlot2WindowPal:
@3b09:  ldy     $93
        beq     @3b13
        lda     $30714e
        bra     @3b14
@3b13:  clr_a
@3b14:  ldx     #$0020
        jsr     LoadWindowPal
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ load save slot 3 window palette ]

LoadSaveSlot3WindowPal:
@3b1d:  ldy     $95
        beq     @3b27
        lda     $307b4e
        bra     @3b28
@3b27:  clr_a
@3b28:  ldx     $00
        jsr     LoadWindowPal
        jmp     TfrPal

; ------------------------------------------------------------------------------

; [ get pointer to menu window graphics ]

; ++$16: pointer (out)

GetWindowGfxPtr:
@3b30:  and     #$0f
        sta     $e0
        stz     $e1
        ldy     #.loword(WindowGfx)
        sty     $16
        lda     #^WindowGfx
        sta     $18
        longa
        clr_a
@3b42:  ldy     $e0
        beq     @3b4e
        clc
        adc     #$0380
        dec     $e0
        bra     @3b42
@3b4e:  clc
        adc     $16
        sta     $16
        shorta
        ldy     #$0400
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ load menu window palette ]

LoadWindowPal:
@3b5b:  and     #$0f
        sta     $e0
        phx
        lda     #$00
        sta     $e9
        stz     $e1
        longa
        lda     #$1d57      ; window palette
@3b6b:  ldy     $e0
        beq     @3b77
        clc
        adc     #$000e
        dec     $e0
        bra     @3b6b
@3b77:  sta     $e7
        shorta
        ldy     $00
        plx
@3b7e:  lda     [$e7],y
        sta     $7e30cb,x
        iny
        inx
        cpy     #$000e
        bne     @3b7e
        rts

; ------------------------------------------------------------------------------

; [ draw active/wait config text ]

DrawActiveWaitText:
@3b8c:  lda     $1d4d       ; active/wait
        and     #$08
        beq     @3b9c       ; branch if active
        lda     #$28
        jsr     @3ba5
        lda     #$20
        bra     @3bae
@3b9c:  lda     #$20
        jsr     @3ba5
        lda     #$28
        bra     @3bae
@3ba5:  sta     $29
        ldy     #.loword(ConfigActiveText)
        jsr     DrawPosText
        rts
@3bae:  sta     $29
        ldy     #.loword(ConfigWaitText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

DrawBattleSpeedText:
@3bb7:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigBattleSpeedNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d4d
        and     #$07
        asl
        tax
        longa
        lda     f:BattleSpeedTextPos,x
        sta     $f7
        shorta
        lda     $1d4d
        and     #$07
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
        jmp     _c34116

; ------------------------------------------------------------------------------

BattleSpeedTextPos:
@3be6:  .byte   $25,$3a,$29,$3a,$2d,$3a,$31,$3a,$35,$3a,$39,$3a

; ------------------------------------------------------------------------------

; [ draw message speed text ]

DrawMsgSpeedText:
@3bf2:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigMsgSpeedNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d4d
        and     #$70
        lsr3
        tax
        longa
        lda     f:MsgSpeedTextPos,x
        sta     $f7
        shorta
        lda     $1d4d
        and     #$70
        lsr4
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
        jmp     _c34116

; ------------------------------------------------------------------------------

MsgSpeedTextPos:
@3c27:  .byte   $a5,$3a,$a9,$3a,$ad,$3a,$b1,$3a,$b5,$3a,$b9,$3a

; ------------------------------------------------------------------------------

; [ draw command setting text ]

DrawCmdConfigText:
@3c33:  lda     $1d4d
        bmi     @3c41
        lda     #$28
        jsr     @3c4a
        lda     #$20
        bra     @3c53
@3c41:  lda     #$20
        jsr     @3c4a
        lda     #$28
        bra     @3c53
@3c4a:  sta     $29
        ldy     #.loword(ConfigCmdShortText)
        jsr     DrawPosText
        rts
@3c53:  sta     $29
        ldy     #.loword(ConfigCmdWindowText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

DrawGaugeConfigText:
@3c5c:  lda     $1d4e
        bpl     @3c6a
        lda     #$28
        jsr     @3c73
        lda     #$20
        bra     @3c7c
@3c6a:  lda     #$20
        jsr     @3c73
        lda     #$28
        bra     @3c7c
@3c73:  sta     $29
        ldy     #.loword(ConfigGaugeOnText)
        jsr     DrawPosText
        rts
@3c7c:  sta     $29
        ldy     #.loword(ConfigGaugeOffText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw stereo/mono text ]

DrawStereoMonoText:
@3c85:  lda     $1d4e
        and     #$20
        beq     @3c95
        lda     #$28
        jsr     @3c9e
        lda     #$20
        bra     @3ca7
@3c95:  lda     #$20
        jsr     @3c9e
        lda     #$28
        bra     @3ca7
@3c9e:  sta     $29
        ldy     #.loword(ConfigStereoText)
        jsr     DrawPosText
        rts
@3ca7:  sta     $29
        ldy     #.loword(ConfigMonoText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw cursor setting text ]

DrawCursorConfigText:
@3cb0:  lda     $1d4e
        and     #$40
        beq     @3cc0
        lda     #$28
        jsr     @3cc9
        lda     #$20
        bra     @3cd2
@3cc0:  lda     #$20
        jsr     @3cc9
        lda     #$28
        bra     @3cd2
@3cc9:  sta     $29
        ldy     #.loword(ConfigResetText)
        jsr     DrawPosText
        rts
@3cd2:  sta     $29
        ldy     #.loword(ConfigMemoryText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

DrawReequipConfigText:
@3cdb:  lda     $1d4e
        and     #$10
        beq     @3ceb
        lda     #$28
        jsr     @3cf4
        lda     #$20
        bra     @3cfd
@3ceb:  lda     #$20
        jsr     @3cf4
        lda     #$28
        bra     @3cfd
@3cf4:  sta     $29
        ldy     #.loword(ConfigOptimumText)
        jsr     DrawPosText
        rts
@3cfd:  sta     $29
        ldy     #.loword(ConfigEmptyText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

DrawCtrlConfigText:
@3d06:  lda     $1d54
        bpl     @3d14
        lda     #$28
        jsr     @3d1d
        lda     #$20
        bra     @3d26
@3d14:  lda     #$20
        jsr     @3d1d
        lda     #$28
        bra     @3d26
@3d1d:  sta     $29
        ldy     #.loword(ConfigCtrlSingleText)
        jsr     DrawPosText
        rts
@3d26:  sta     $29
        ldy     #.loword(ConfigCtrlMultiText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ change config setting (pressed left or right) ]

ChangeConfigOption:
@3d2f:  clr_a
        lda     $4b
        asl
        tax
        lda     $4a
        beq     @3d40
        phx
        jsr     PlayMoveSfx
        plx
        jmp     (.loword(ChangeConfigOptionTbl+18),x)
@3d40:  jmp     (.loword(ChangeConfigOptionTbl),x)

; ------------------------------------------------------------------------------

; page 1
ChangeConfigOptionTbl:
@3d43:  .addr   ChangeConfigOption_00
        .addr   ChangeConfigOption_01
        .addr   ChangeConfigOption_02
        .addr   ChangeConfigOption_03
        .addr   ChangeConfigOption_04
        .addr   ChangeConfigOption_05
        .addr   ChangeConfigOption_06
        .addr   ChangeConfigOption_07
        .addr   ChangeConfigOption_08

; page 2
@3d55:  .addr   ChangeConfigOption_09
        .addr   ChangeConfigOption_0a
        .addr   ChangeConfigOption_0b
        .addr   ChangeConfigOption_0c
        .addr   ChangeConfigOption_0d
        .addr   ChangeConfigOption_0e

; ------------------------------------------------------------------------------

; [ change active/wait setting ]

ChangeConfigOption_00:
@3d61:  jsr     PlayMoveSfx
        lda     $0b
        bit     #$01
        bne     @3d72
        lda     #$08
        trb     $1d4d
        jmp     DrawActiveWaitText
@3d72:  lda     #$08
        tsb     $1d4d
        jmp     DrawActiveWaitText

; ------------------------------------------------------------------------------

; [ change battle speed ]

ChangeConfigOption_01:
@3d7a:  jsr     PlayMoveSfx
        lda     $1d4d
        and     #$07
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3d95
        lda     $e0
        cmp     #$05
        beq     @3d94
        inc     $e0
        bra     @3d9e
@3d94:  rts
@3d95:  lda     $e0
        beq     @3d9d
        dec     $e0
        bra     @3d9e
@3d9d:  rts
@3d9e:  lda     $1d4d
        and     #$f8
        ora     $e0
        sta     $1d4d
        jmp     DrawBattleSpeedText

; ------------------------------------------------------------------------------

; [ change message speed ]

ChangeConfigOption_02:
@3dab:  jsr     PlayMoveSfx
        lda     $1d4d
        and     #$70
        lsr4
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3dca
        lda     $e0
        cmp     #$05
        beq     @3dc9
        inc     $e0
        bra     @3dd3
@3dc9:  rts
@3dca:  lda     $e0
        beq     @3dd2
        dec     $e0
        bra     @3dd3
@3dd2:  rts
@3dd3:  lda     $e0
        asl4
        sta     $e0
        lda     $1d4d
        and     #$8f
        ora     $e0
        sta     $1d4d
        jmp     DrawMsgSpeedText

; ------------------------------------------------------------------------------

; [ change command setting ]

ChangeConfigOption_03:
@3de8:  jsr     PlayMoveSfx
        lda     $0b
        bit     #$01
        bne     @3df9
        lda     #$80
        trb     $1d4d
        jmp     DrawCmdConfigText
@3df9:  lda     #$80
        tsb     $1d4d
        jmp     DrawCmdConfigText

; ------------------------------------------------------------------------------

; [ change gauge setting ]

ChangeConfigOption_04:
@3e01:  jsr     PlayMoveSfx
        lda     $0b
        bit     #$01
        bne     @3e12
        lda     #$80
        trb     $1d4e
        jmp     DrawGaugeConfigText
@3e12:  lda     #$80
        tsb     $1d4e
        jmp     DrawGaugeConfigText

; ------------------------------------------------------------------------------

; [ change stereo/mono setting ]

ChangeConfigOption_05:
@3e1a:  lda     $0b
        bit     #$01
        bne     @3e2f
        clr_a
        jsr     SetStereoMono
        lda     #$20
        trb     $1d4e
        jsr     PlayMoveSfx
        jmp     DrawStereoMonoText
@3e2f:  lda     #$ff
        jsr     SetStereoMono
        lda     #$20
        tsb     $1d4e
        jsr     PlayMoveSfx
        jmp     DrawStereoMonoText

; ------------------------------------------------------------------------------

; [ set mono/stereo mode ]

SetStereoMono:
@3e3f:  sta     f:$001301
        lda     #$f3        ; spc command $f3 (set mono/stereo mode)
        sta     f:$001300
        jsl     ExecSound_ext
        rts

; ------------------------------------------------------------------------------

; [ change cursor setting ]

ChangeConfigOption_06:
@3e4e:  jsr     PlayMoveSfx
        lda     $0b
        bit     #$01
        bne     @3e62
        jsr     _c348f7
        lda     #$40
        trb     $1d4e
        jmp     DrawCursorConfigText
@3e62:  lda     #$40
        tsb     $1d4e
        jsr     ResetMenuCursorMemory
        jmp     DrawCursorConfigText

; ------------------------------------------------------------------------------

; [ change reequip setting ]

ChangeConfigOption_07:
@3e6d:  jsr     PlayMoveSfx
        lda     $0b
        bit     #$01
        bne     @3e7e
        lda     #$10
        trb     $1d4e
        jmp     DrawReequipConfigText
@3e7e:  lda     #$10
        tsb     $1d4e
        jmp     DrawReequipConfigText

; ------------------------------------------------------------------------------

; [ change controller setting ]

ChangeConfigOption_08:
@3e86:  jsr     PlayMoveSfx
        lda     $0b
        bit     #$01
        bne     @3e97
        lda     #$80
        trb     $1d54
        jmp     DrawCtrlConfigText
@3e97:  lda     #$80
        tsb     $1d54
        jmp     DrawCtrlConfigText

; ------------------------------------------------------------------------------

; [ change magic order ]

ChangeConfigOption_09:
@3e9f:  lda     $1d54
        and     #$07
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3eb7
        lda     $e0
        cmp     #$05
        beq     @3eb6
        inc     $e0
        bra     @3ec0
@3eb6:  rts
@3eb7:  lda     $e0
        beq     @3ebf
        dec     $e0
        bra     @3ec0
@3ebf:  rts
@3ec0:  lda     $1d54
        and     #$f8
        ora     $e0
        sta     $1d54
        jmp     _c33ffd

; ------------------------------------------------------------------------------

; [ change window pattern ]

ChangeConfigOption_0a:
@3ecd:  lda     $1d4e
        and     #$0f
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3ee5
        lda     $e0
        cmp     #$07
        beq     @3ee4
        inc     $e0
        bra     @3eee
@3ee4:  rts
@3ee5:  lda     $e0
        beq     @3eed
        dec     $e0
        bra     @3eee
@3eed:  rts
@3eee:  lda     $1d4e
        and     #$f0
        ora     $e0
        sta     $1d4e
        jsr     _c340ea
        jsr     _c33a87
        jmp     _c341c3

; ------------------------------------------------------------------------------

; [ select font/window color ]

ChangeConfigOption_0b:
@3f01:  lda     $1d54
        and     #$38
        lsr3
        sta     $e0
        lda     $0b
        bit     #$01
        beq     @3f1c
        lda     $e0
        cmp     #$07
        beq     @3f1b
        inc     $e0
        bra     @3f25
@3f1b:  rts
@3f1c:  lda     $e0
        beq     @3f24
        dec     $e0
        bra     @3f25
@3f24:  rts
@3f25:  lda     $e0
        asl3
        sta     $e0
        lda     $1d54
        and     #$c7
        ora     $e0
        sta     $1d54
        jsr     DrawConfigColors
        jmp     _c341c3

; ------------------------------------------------------------------------------

; [ change red component ]

ChangeConfigOption_0c:
@3f3c:  jsr     _c341fe
        lda     $0b
        bit     #$01
        beq     @3f4f
        lda     $e2
        cmp     #$1f
        beq     @3f55
        inc     $e2
        bra     @3f55
@3f4f:  lda     $e2
        beq     @3f55
        dec     $e2
@3f55:  jsr     _c34221
        jmp     _c33fc4

; ------------------------------------------------------------------------------

; [ change green component ]

ChangeConfigOption_0d:
@3f5b:  jsr     _c341fe
        lda     $0b
        bit     #$01
        beq     @3f6e
        lda     $e1
        cmp     #$1f
        beq     @3f74
        inc     $e1
        bra     @3f74
@3f6e:  lda     $e1
        beq     @3f74
        dec     $e1
@3f74:  jsr     _c34221
        jmp     _c33fc4

; ------------------------------------------------------------------------------

; [ change blue component ]

ChangeConfigOption_0e:
@3f7a:  jsr     _c341fe
        lda     $0b
        bit     #$01
        beq     @3f8d
        lda     $e0
        cmp     #$1f
        beq     @3f93
        inc     $e0
        bra     @3f93
@3f8d:  lda     $e0
        beq     @3f93
        dec     $e0
@3f93:  jsr     _c34221
        jmp     _c33fc4

; ------------------------------------------------------------------------------

; [ init font color ]

InitFontColor:
@3f99:  longa
        lda     $1d55
        sta     $7e304f
        sta     $7e3073
        sta     $7e3077
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c33fad:
@3fad:  ldx     $00
        longa
@3fb1:  lda     $1d57,y
        sta     $7e312b,x
        iny2
        inx2
        cpx     #$000e
        bne     @3fb1
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c33fc4:
@3fc4:  clr_a
        lda     $1d4e
        and     #$0f
        sta     hWRMPYA
        lda     #14
        sta     hWRMPYB
        lda     $1d54
        and     #$38
        beq     @3ff2
        lsr2
        clc
        adc     hRDMPYL
        tax
        lda     $9a
        sta     $1d55,x
        lda     $9b
        sta     $1d56,x
        ldy     hRDMPYL
        jsr     _c33fad
        bra     @3ffa
@3ff2:  ldy     $9a
        sty     $1d55
        jsr     InitFontColor
@3ffa:  jmp     _c341c3

; ------------------------------------------------------------------------------

; [  ]

_c33ffd:
@3ffd:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigMagicOrderNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d54
        and     #$07
        asl
        tax
        longa
        lda     f:_c3402f,x
        sta     $f7
        shorta
        lda     $1d54
        and     #$07
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
        jsr     _c34116
        jmp     DrawConfigMagicTypeList

; ------------------------------------------------------------------------------

_c3402f:
@402f:  .word   $41a5,$41a9,$41ad,$41b1,$41b5,$41b9

; ------------------------------------------------------------------------------

; [ draw magic type list for config menu ]

DrawConfigMagicTypeList:
@403b:  clr_a
        sta     $7e9e95
        clr_a
        lda     $1d54
        and     #$07
        asl2
        tax
        ldy     #3
@404c:  phy
        phx
        jsr     DrawConfigMagicTypeName
        plx
        ply
        inx
        dey
        bne     @404c
        rts

; ------------------------------------------------------------------------------

; [ draw magic type name for config menu ]

DrawConfigMagicTypeName:
@4058:  clr_a
        lda     f:ConfigMagicTypeTextPtrs,x
        tax
.repeat 10, i
        lda     f:ConfigMagicTypeText+i,x
        sta     $7e9e8b+i
.endrep
        clr_a
        dey
        tya
        asl
        tax
        longa
        lda     f:ConfigMagicTypeTextPos,x
        sta     $7e9e89
        shorta
        ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

ConfigMagicTypeTextPos:
@40cc:  .word   $4329,$42a9,$4229

ConfigMagicTypeTextPtrs:
@40d2:  .byte   $00,$0a,$14,$00
        .byte   $00,$14,$0a,$00
        .byte   $0a,$14,$00,$00
        .byte   $0a,$00,$14,$00
        .byte   $14,$00,$0a,$00
        .byte   $14,$0a,$00,$00

; ------------------------------------------------------------------------------

; [  ]

_c340ea:
@40ea:  lda     #$28
        sta     $29
        ldy     #.loword(ConfigColorNumText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        clr_a
        lda     $1d4e
        and     #$0f
        asl
        tax
        longa
        lda     f:_c34123,x
        sta     $f7
        shorta
        lda     $1d4e
        and     #$0f
        clc
        adc     #$b5
        sta     $f9
        stz     $fa
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_c34116:
@4116:  ldy     #$00f7
        sty     $e7
        lda     #$00
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

_c34123:
@4123:  .word   $43a5,$43a9,$43ad,$43b1,$43b5,$43b9,$43bd,$43c1

; ------------------------------------------------------------------------------

; [ draw window color boxes for config menu ]

DrawConfigColors:
@4133:  lda     #$3c
        sta     $29
        ldy     #.loword(ConfigColorBoxText)
        jsr     DrawPosText
        ldy     #.loword(ConfigColorArrowBlankText)
        jsr     DrawPosText
        clr_a
        lda     $1d54
        and     #$38
        beq     @4171

; window color selected
        lsr2
        tax
        lda     #$20
        sta     $29
        longa
        lda     f:ConfigColorArrowTbl,x
        sta     $e7
        shorta
        lda     #^ConfigColorArrowTbl
        sta     $e9
        jsr     DrawPosTextFar
        lda     #$28
        sta     $29
        jsr     @417f
        lda     #$20
        sta     $29
        jmp     @4186

; font color selected
@4171:  lda     #$20
        sta     $29
        jsr     @417f
        lda     #$28
        sta     $29
        jmp     @4186

; draw "Font"
@417f:  ldy     #.loword(ConfigFontText)
        jsr     DrawPosText
        rts

; draw "Window"
@4186:  ldy     #.loword(ConfigWindowText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

ConfigColorArrowTbl:
@418d:  .addr   ConfigColorArrowBlankText
        .addr   ConfigColorArrowText1
        .addr   ConfigColorArrowText2
        .addr   ConfigColorArrowText3
        .addr   ConfigColorArrowText4
        .addr   ConfigColorArrowText5
        .addr   ConfigColorArrowText6
        .addr   ConfigColorArrowText7

; blank text for clearing arrow area and if font color is selected
ConfigColorArrowBlankText:
@419d:  .byte   $f5,$44,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

ConfigColorArrowText1:
@41a7:  .byte   $f5,$44,$d4,$00

ConfigColorArrowText2:
@41ab:  .byte   $f7,$44,$d4,$00

ConfigColorArrowText3:
@41af:  .byte   $f9,$44,$d4,$00

ConfigColorArrowText4:
@41b3:  .byte   $fb,$44,$d4,$00

ConfigColorArrowText5:
@41b7:  .byte   $fd,$44,$d4,$00

ConfigColorArrowText6:
@41bb:  .byte   $ff,$44,$d4,$00

ConfigColorArrowText7:
@41bf:  .byte   $01,$45,$d4,$00

; ------------------------------------------------------------------------------

; [  ]

_c341c3:
@41c3:  jsr     _c33950
        clr_a
        lda     $1d4e
        and     #$0f
        sta     hWRMPYA
        lda     #14
        sta     hWRMPYB
        lda     $1d54
        and     #$38
        beq     @41e7
        lsr2
        clc
        adc     hRDMPYL
        tax
        ldy     $1d55,x
        bra     @41ea
@41e7:  ldy     $1d55
@41ea:  sty     $9a
        jsr     _c341fe
        jsr     _c34263
        jsr     _c341fe
        jsr     _c34250
        jsr     _c341fe
        jmp     _c3423d

; ------------------------------------------------------------------------------

; [  ]

_c341fe:
@41fe:  ldy     $9a
        sty     $e7
        lda     $e7
        and     #$1f
        sta     $e2
        lda     $e8
        and     #$7c
        lsr2
        sta     $e0
        longa
        lda     $e7
        and     #$03e0
        lsr5
        shorta
        sta     $e1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34221:
@4221:  lda     $e0
        asl2
        sta     $e8
        lda     $e2
        sta     $e7
        clr_a
        lda     $e1
        longa
        asl5
        ora     $e7
        sta     a:$009a
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3423d:
@423d:  longa
        lda     #$452f
        sta     $7e9e89
        shorta
        lda     $e2
        ldx     #$4529
        jmp     _c34276

; ------------------------------------------------------------------------------

; [  ]

_c34250:
@4250:  longa
        lda     #$45af
        sta     $7e9e89
        shorta
        lda     $e1
        ldx     #$45a9
        jmp     _c34276

; ------------------------------------------------------------------------------

; [  ]

_c34263:
@4263:  longa
        lda     #$462f
        sta     $7e9e89
        shorta
        lda     $e0
        ldx     #$4629
        jmp     _c34276

; ------------------------------------------------------------------------------

; [  ]

_c34276:
@4276:  pha
        pha
        phx
        jsr     HexToDec3
        plx
        lda     #$20
        sta     $29
        jsr     DrawNum2
        ldx     #$9e8b
        stx     hWMADDL
        pla
        xba
        lda     $00
        xba
        lsr2
        tax
        beq     @429c
@4294:  lda     #$f8
        sta     hWMDATA
        dex
        bne     @4294
@429c:  pla
        and     #$03
        tax
        lda     f:_c342be,x
        sta     hWMDATA
        stz     hWMDATA
        lda     #$30
        sta     $29
        jmp     @42b1
@42b1:  ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

_c342be:
@42be:  .byte   $f0,$f2,$f4,$f6

; ------------------------------------------------------------------------------

; [ menu state $47:  ]

MenuState_47:
@42c2:  jsr     DisableInterrupts
        jsr     _c3442c
        jsr     InitCmdArrangeScrollHDMA
        jsr     LoadCmdArrangeCharCursor
        jsr     InitCmdArrangeCharCursor
        jsr     CreateCursorTask
        lda     #$01
        sta     $26
        lda     #$48
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $48:  ]

MenuState_48:
@42df:  jsr     UpdateCmdArrangeCharCursor
        lda     $08
        bit     #$80
        beq     @4310
        clr_a
        lda     $4b
        cmp     #$04
        beq     @4326
        tax
        lda     $69,x
        bmi     @430a
        jsr     PlaySelectSfx
        lda     $4e
        sta     $5e
        lda     $4b
        sta     $64
        jsr     LoadCmdArrangeCursor
        jsr     InitCmdArrangeCursor
        lda     #$62
        sta     $26
        rts
@430a:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@4310:  lda     $09
        bit     #$10
        bne     @431c
        lda     $09
        bit     #$80
        beq     @4325
@431c:  jsr     PlayCancelSfx
        lda     #$0d
        sta     $27
        stz     $26
@4325:  rts
@4326:  jsr     PlaySelectSfx
        jsr     InitBG3TilesLeftDMA1
        jsr     _c343d0
        jsr     _c343d8
        jsr     _c343e1
        jmp     _c343ea

; ------------------------------------------------------------------------------

; [ menu state $62:  ]

MenuState_62:
@4338:  jsr     UpdateCmdArrangeCursor
        lda     $08
        bit     #$80
        beq     @4359
        jsr     PlaySelectSfx
        lda     $4b
        sta     $28
        jsr     _c32f06
        lda     #$63
        sta     $26
        clr_a
        lda     $64
        asl
        tax
        ldy     $6d,x
        sty     $67
        rts
@4359:  lda     $09
        bit     #$80
        beq     @4375
        jsr     PlayCancelSfx
        jsr     LoadCmdArrangeCharCursor
        lda     $5e
        sta     $4e
        jsr     InitCmdArrangeCharCursor
        lda     $4e
        sta     $5e
        lda     #$48
        sta     $26
        rts
@4375:  rts

; ------------------------------------------------------------------------------

; [ menu state $63:  ]

MenuState_63:
@4376:  jsr     UpdateCmdArrangeCursor

; A button
        lda     $08
        bit     #$80
        beq     @43bd
        jsr     PlaySelectSfx
        clr_a
        lda     $4b
        longac
        adc     $67
        tay
        phy
        shorta
        lda     $0016,y
        sta     $e0
        clr_a
        lda     $28
        longac
        adc     $67
        tay
        shorta
        lda     $0016,y
        sta     $e1
        lda     $e0
        sta     $0016,y
        ply
        lda     $e1
        sta     $0016,y
        jsr     _c344b4
        jsr     _c344ed
        jsr     _c34526
        jsr     _c3455f
        jsr     InitBG3TilesLeftDMA1
        bra     @43c6

; B button
@43bd:  lda     $09
        bit     #$80
        beq     @43cf
        jsr     PlayCancelSfx
@43c6:  lda     #$05
        trb     $46
        lda     #$62
        sta     $26
        rts
@43cf:  rts

; ------------------------------------------------------------------------------

; [  ]

_c343d0:
@43d0:  ldx     $00
        jsr     _c343f3
        jmp     _c344b4

; ------------------------------------------------------------------------------

; [  ]

_c343d8:
@43d8:  ldx     #$0002
        jsr     _c343f3
        jmp     _c344ed

; ------------------------------------------------------------------------------

; [  ]

_c343e1:
@43e1:  ldx     #$0004
        jsr     _c343f3
        jmp     _c34526

; ------------------------------------------------------------------------------

; [  ]

_c343ea:
@43ea:  ldx     #$0006
        jsr     _c343f3
        jmp     _c3455f

; ------------------------------------------------------------------------------

; [  ]

_c343f3:
@43f3:  ldy     $6d,x
        beq     @442a
        clr_a
        lda     $0000,y
        cmp     #$0c
        beq     @442b
        sta     hWRMPYA
        lda     #22
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        lda     f:CharProp+2,x   ; character properties (battle commands)
        sta     $0016,y
        lda     f:CharProp+3,x
        sta     $0017,y
        lda     f:CharProp+4,x
        sta     $0018,y
        lda     f:CharProp+5,x
        sta     $0019,y
@442a:  rts
@442b:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3442c:
@442c:  jsr     ClearBG2ScreenA
        ldy     #.loword(_c34490)
        jsr     DrawWindow
        ldy     #.loword(_c34494)
        jsr     DrawWindow
        ldy     #.loword(_c34498)
        jsr     DrawWindow
        ldy     #.loword(_c3449c)
        jsr     DrawWindow
        ldy     #.loword(_c344a0)
        jsr     DrawWindow
        ldy     #.loword(_c344a4)
        jsr     DrawWindow
        ldy     #.loword(_c344a8)
        jsr     DrawWindow
        ldy     #.loword(_c344ac)
        jsr     DrawWindow
        ldy     #.loword(_c344b0)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        lda     #$30
        sta     $29
        ldy     #$4af1
        jsr     DrawPosText
        jsr     _c344b4
        jsr     _c344ed
        jsr     _c34526
        jsr     _c3455f
        jsr     TfrBG1ScreenAB
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

_c34490:
@4490:  .byte   $1f,$59,$12,$04

_c34494:
@4494:  .byte   $9f,$5a,$12,$04

_c34498:
@4498:  .byte   $1f,$5c,$12,$04

_c3449c:
@449c:  .byte   $9f,$5d,$12,$04

_c344a0:
@44a0:  .byte   $0b,$59,$08,$04

_c344a4:
@44a4:  .byte   $8b,$5a,$08,$04

_c344a8:
@44a8:  .byte   $0b,$5c,$08,$04

_c344ac:
@44ac:  .byte   $8b,$5d,$08,$04

_c344b0:
@44b0:  .byte   $8b,$58,$08,$01

; ------------------------------------------------------------------------------

; [  ]

_c344b4:
@44b4:  lda     $69
        bmi     @44ec
        jsl     UpdateEquip_ext
        ldx     $6d
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$798f
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7a0f
        jsr     DrawCharTitle
        ldy     #$79ad
        jsr     _c34598
        ldy     #$7a23
        jsr     _c3459e
        ldy     #$7a37
        jsr     _c345a5
        ldy     #$7aad
        jsr     _c345ad
@44ec:  rts

; ------------------------------------------------------------------------------

; [  ]

_c344ed:
@44ed:  lda     $6a
        bmi     @4525
        jsl     UpdateEquip_ext
        ldx     $6f
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$7b4f
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7bcf
        jsr     DrawCharTitle
        ldy     #$7b6d
        jsr     _c34598
        ldy     #$7be3
        jsr     _c3459e
        ldy     #$7bf7
        jsr     _c345a5
        ldy     #$7c6d
        jsr     _c345ad
@4525:  rts

; ------------------------------------------------------------------------------

; [  ]

_c34526:
@4526:  lda     $6b
        bmi     @455e
        jsl     UpdateEquip_ext
        ldx     $71
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$7d0f
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7d8f
        jsr     DrawCharTitle
        ldy     #$7d2d
        jsr     _c34598
        ldy     #$7da3
        jsr     _c3459e
        ldy     #$7db7
        jsr     _c345a5
        ldy     #$7e2d
        jsr     _c345ad
@455e:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3455f:
@455f:  lda     $6c
        bmi     @4597
        jsl     UpdateEquip_ext
        ldx     $73
        stx     $67
        lda     #$30
        sta     $29
        ldy     #$7ecf
        jsr     DrawCharName
        lda     #$20
        sta     $29
        ldy     #$7f4f
        jsr     DrawCharTitle
        ldy     #$7eed
        jsr     _c34598
        ldy     #$7f63
        jsr     _c3459e
        ldy     #$7f77
        jsr     _c345a5
        ldy     #$7fed
        jsr     _c345ad
@4597:  rts

; ------------------------------------------------------------------------------

; [  ]

_c34598:
@4598:  jsr     InitTextBuf
        jmp     _c35ee1

; ------------------------------------------------------------------------------

; [  ]

_c3459e:
@459e:  jsr     InitTextBuf
        iny
        jmp     _c35ee1

; ------------------------------------------------------------------------------

; [  ]

_c345a5:
@45a5:  jsr     InitTextBuf
        iny2
        jmp     _c35ee1

; ------------------------------------------------------------------------------

; [  ]

_c345ad:
@45ad:  jsr     InitTextBuf
        iny3
        jmp     _c35ee1

; ------------------------------------------------------------------------------

; [ init cursor (battle command arrange, char select) ]

LoadCmdArrangeCharCursor:
@45b6:  ldy     #.loword(CmdArrangeCharCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, char select) ]

UpdateCmdArrangeCharCursor:
@45bc:  jsr     MoveCursor

InitCmdArrangeCharCursor:
@45bf:  ldy     #.loword(CmdArrangeCharCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; cursor data (battle command arrange, char select)
CmdArrangeCharCursorProp:
@45c5:  .byte   $80,$00,$00,$01,$05

; cursor positions (battle command arrange, char select)
CmdArrangeCharCursorPos:
@45ca:  .byte   $08,$20
        .byte   $08,$50
        .byte   $08,$80
        .byte   $08,$b0
        .byte   $08,$0c

; ------------------------------------------------------------------------------

; [ init cursor (battle command arrange, command select/move) ]

LoadCmdArrangeCursor:
@45d4:  ldy     #.loword(CmdArrangeCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, command select/move) ]

; initial update only, doesn't update cursor movement

InitCmdArrangeCursor:
@45da:  clr_a
        lda     $64         ; character slot
        asl
        tax
        jmp     (.loword(InitCmdArrangeCursorTbl),x)

InitCmdArrangeCursorTbl:
@45e2:  .addr   InitChar1CmdArrangeCursorPos
        .addr   InitChar2CmdArrangeCursorPos
        .addr   InitChar3CmdArrangeCursorPos
        .addr   InitChar4CmdArrangeCursorPos

; ------------------------------------------------------------------------------

; character slot 1
InitChar1CmdArrangeCursorPos:
UpdateChar1CmdArrangeCursorPos:
@45ea:  ldy     #.loword(Char1CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 2
InitChar2CmdArrangeCursorPos:
UpdateChar2CmdArrangeCursorPos:
@45f0:  ldy     #.loword(Char2CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 3
InitChar3CmdArrangeCursorPos:
UpdateChar3CmdArrangeCursorPos:
@45f6:  ldy     #.loword(Char3CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; character slot 4
InitChar4CmdArrangeCursorPos:
UpdateChar4CmdArrangeCursorPos:
@45fc:  ldy     #.loword(Char4CmdArrangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; [ update cursor (battle command arrange, command select/move) ]

UpdateCmdArrangeCursor:
@4602:  jsr     GetCmdArrangeCursorInput
        clr_a
        lda     $64         ; character slot
        asl
        tax
        jmp     (.loword(UpdateCmdArrangeCursorTbl),x)

UpdateCmdArrangeCursorTbl:
@460d:  .addr   UpdateChar1CmdArrangeCursorPos
        .addr   UpdateChar2CmdArrangeCursorPos
        .addr   UpdateChar3CmdArrangeCursorPos
        .addr   UpdateChar4CmdArrangeCursorPos

; ------------------------------------------------------------------------------

; [ update cursor movement (battle command arrange, command select/move) ]

GetCmdArrangeCursorInput:
@4615:  stz     $4d

; up
        lda     $0b
        bit     #$08
        beq     @4622
        stz     $4e
        jsr     PlayMoveSfx

; down
@4622:  lda     $0b
        bit     #$04
        beq     @462f
        lda     #$03
        sta     $4e
        jsr     PlayMoveSfx

; left
@462f:  lda     $0b
        bit     #$02
        beq     @463c
        lda     #$01
        sta     $4e
        jsr     PlayMoveSfx

; right
@463c:  lda     $0b
        bit     #$01
        beq     @4649
        lda     #$02
        sta     $4e
        jsr     PlayMoveSfx
@4649:  rts

; ------------------------------------------------------------------------------

; cursor data (battle command arrange, command select/move)
CmdArrangeCursorProp:
@464a:  .byte   $81,$00,$00,$01,$04

; cursor positions (battle command arrange, 4 positions per character slot)
Char1CmdArrangeCursorPos:
@464f:  .byte   $80,$20
        .byte   $58,$2c
        .byte   $a8,$2c
        .byte   $80,$38

Char2CmdArrangeCursorPos:
@4657:  .byte   $80,$50
        .byte   $58,$5c
        .byte   $a8,$5c
        .byte   $80,$68

Char3CmdArrangeCursorPos:
@465f:  .byte   $80,$80
        .byte   $58,$8c
        .byte   $a8,$8c
        .byte   $80,$98

Char4CmdArrangeCursorPos:
@4667:  .byte   $80,$b0
        .byte   $58,$bc
        .byte   $a8,$bc
        .byte   $80,$c8

; ------------------------------------------------------------------------------

; [ init bg3 horizontal scroll hdma (battle command arrange) ]

InitCmdArrangeScrollHDMA:
@466f:  lda     #$02                    ; one address, write twice
        sta     $4350
        lda     #<hBG3VOFS              ; bg3 vertical scroll
        sta     $4351
        ldy     #.loword(CmdArrangeScrollHDMATbl)
        sty     $4352
        lda     #^CmdArrangeScrollHDMATbl
        sta     $4354
        lda     #^CmdArrangeScrollHDMATbl
        sta     $4357
        lda     #$20                    ; enable hdma #5
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (battle command arrange)
CmdArrangeScrollHDMATbl:
@468e:  .byte   $1f
        .word   $0000
        .byte   $0c
        .word   $0004
        .byte   $0c
        .word   $0008
        .byte   $24
        .word   $000c
        .byte   $0c
        .word   $0010
        .byte   $24
        .word   $0014
        .byte   $0c
        .word   $0018
        .byte   $24
        .word   $001c
        .byte   $0c
        .word   $0020
        .byte   $24
        .word   $0024
        .byte   $00

; ------------------------------------------------------------------------------

; controller config menu
MenuState_49:
MenuState_4a:
.if !LANG_EN

.endif

; ------------------------------------------------------------------------------

; [ menu state $4b: init character controller select ]

MenuState_4b:
@46ad:  jsr     DisableInterrupts
        jsr     DrawCharCtrlMenu
        jsr     InitCharCtrlWindowHDMA
        jsr     LoadCharCtrlCursor
        jsr     InitCharCtrlCursor
        jsr     CreateCursorTask
        lda     #$01
        sta     $26
        lda     #$4c
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $4c: update character controller select ]

MenuState_4c:
@46ca:  jsr     InitBG3TilesLeftDMA1
        jsr     UpdateCharCtrlCursor
        lda     $09
        bit     #$10
        bne     @46dc
        lda     $09
        bit     #$80
        beq     @46e6
@46dc:  jsr     PlayCancelSfx
        lda     #$0d
        sta     $27
        stz     $26
        rts
@46e6:  lda     $0b
        bit     #$01
        bne     @46f2
        lda     $0b
        bit     #$02
        beq     @46f4
@46f2:  bra     ChangeCharCtrl
@46f4:  rts

; ------------------------------------------------------------------------------

; [ draw character controller select menu ]

DrawCharCtrlMenu:
@46f5:  ldy     #.loword(CharCtrlWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        lda     #$30
        sta     $29
        ldy     #$4afb
        jsr     DrawPosText
        jsr     DrawChar1CtrlText
        jsr     DrawChar2CtrlText
        jsr     DrawChar3CtrlText
        jsr     DrawChar4CtrlText
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ change controller for character ]

ChangeCharCtrl:
@4717:  clr_a
        lda     $4b
        tax
        lda     $69,x
        bmi     @4729
        jsr     PlayMoveSfx
        lda     $4b
        asl
        tax
        jmp     (.loword(ChangeCharCtrlTbl),x)
@4729:  rts

ChangeCharCtrlTbl:
@472a:  .addr   ChangeChar1Ctrl
        .addr   ChangeChar2Ctrl
        .addr   ChangeChar3Ctrl
        .addr   ChangeChar4Ctrl

; ------------------------------------------------------------------------------

; [ change controller for character 1 ]

ChangeChar1Ctrl:
@4732:  lda     $1d4f
        and     #$01
        lda     $0b
        bit     #$01
        beq     @4747
        lda     #$01
        ora     $1d4f
        sta     $1d4f
        bra     DrawChar1CtrlText
@4747:  lda     $1d4f
        and     #$fe
        sta     $1d4f
        bra     DrawChar1CtrlText

; ------------------------------------------------------------------------------

; [ change controller for character 2 ]

ChangeChar2Ctrl:
@4751:  lda     $1d4f
        and     #$02
        lda     $0b
        bit     #$01
        beq     @4767
        lda     #$02
        ora     $1d4f
        sta     $1d4f
        jmp     DrawChar2CtrlText
@4767:  lda     $1d4f
        and     #$fd
        sta     $1d4f
        jmp     DrawChar2CtrlText

; ------------------------------------------------------------------------------

; [ change controller for character 3 ]

ChangeChar3Ctrl:
@4772:  lda     $1d4f
        and     #$04
        lda     $0b
        bit     #$01
        beq     @4788
        lda     #$04
        ora     $1d4f
        sta     $1d4f
        jmp     DrawChar3CtrlText
@4788:  lda     $1d4f
        and     #$fb
        sta     $1d4f
        jmp     DrawChar3CtrlText

; ------------------------------------------------------------------------------

; [ change controller for character 4 ]

ChangeChar4Ctrl:
@4793:  lda     $1d4f
        and     #$08
        lda     $0b
        bit     #$01
        beq     @47a9
        lda     #$08
        ora     $1d4f
        sta     $1d4f
        jmp     DrawChar4CtrlText
@47a9:  lda     $1d4f
        and     #$f7
        sta     $1d4f
        jmp     DrawChar4CtrlText

; ------------------------------------------------------------------------------

; [ draw text for character 1 controller select ]

DrawChar1CtrlText:
@47b4:  lda     $69
        bmi     @47f0
        ldx     $6d
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7bcf
        jsr     DrawCharName
        lda     $1d4f
        and     #$01
        beq     @47d6
        lda     #$24
        jsr     @47df
        lda     #$20
        bra     @47e8
@47d6:  lda     #$20
        jsr     @47df
        lda     #$24
        bra     @47e8

@47df:  sta     $29
        ldy     #$4b08
        jsr     DrawPosText
        rts

@47e8:  sta     $29
        ldy     #$4b11
        jsr     DrawPosText
@47f0:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 2 controller select ]

DrawChar2CtrlText:
@47f1:  lda     $6a
        bmi     @482d
        ldx     $6f
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7c4f
        jsr     DrawCharName
        lda     $1d4f
        and     #$02
        beq     @4813
        lda     #$24
        jsr     @481c
        lda     #$20
        bra     @4825
@4813:  lda     #$20
        jsr     @481c
        lda     #$24
        bra     @4825

@481c:  sta     $29
        ldy     #$4b1a
        jsr     DrawPosText
        rts

@4825:  sta     $29
        ldy     #$4b23
        jsr     DrawPosText
@482d:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 3 controller select ]

DrawChar3CtrlText:
@482e:  lda     $6b
        bmi     @486a
        ldx     $71
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7ccf
        jsr     DrawCharName
        lda     $1d4f
        and     #$04
        beq     @4850
        lda     #$24
        jsr     @4859
        lda     #$20
        bra     @4862
@4850:  lda     #$20
        jsr     @4859
        lda     #$24
        bra     @4862

@4859:  sta     $29
        ldy     #$4b2c
        jsr     DrawPosText
        rts

@4862:  sta     $29
        ldy     #$4b35
        jsr     DrawPosText
@486a:  rts

; ------------------------------------------------------------------------------

; [ draw text for character 4 controller select ]

DrawChar4CtrlText:
@486b:  lda     $6c
        bmi     @48a7
        ldx     $73
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$7d4f
        jsr     DrawCharName
        lda     $1d4f
        and     #$08
        beq     @488d
        lda     #$24
        jsr     @4896
        lda     #$20
        bra     @489f
@488d:  lda     #$20
        jsr     @4896
        lda     #$24
        bra     @489f

@4896:  sta     $29
        ldy     #$4b3e
        jsr     DrawPosText
        rts

@489f:  sta     $29
        ldy     #$4b47
        jsr     DrawPosText
@48a7:  rts

; ------------------------------------------------------------------------------

; [ init window 2 HDMA for character controller select ]

InitCharCtrlWindowHDMA:
@48a8:  lda     #$01
        sta     $4350
        lda     #<hWH2
        sta     $4351
        ldy     #.loword(CharCtrlWindowHDMATbl)
        sty     $4352
        lda     #^CharCtrlWindowHDMATbl
        sta     $4354
        lda     #^CharCtrlWindowHDMATbl
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; window 2 position HDMA table (character controller select)
CharCtrlWindowHDMATbl:
@48c7:  .byte   $27,$ff,$ff
        .byte   $30,$08,$f7
        .byte   $68,$ff,$ff
        .byte   $10,$08,$f7
        .byte   $10,$ff,$ff
        .byte   $00

; ------------------------------------------------------------------------------

; [ init cursor for character controller select ]

LoadCharCtrlCursor:
@48d7:  ldy     #.loword(CharCtrlCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for character controller select ]

UpdateCharCtrlCursor:
@48dd:  jsr     MoveCursor

InitCharCtrlCursor:
@48e0:  ldy     #.loword(CharCtrlCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

CharCtrlCursorProp:
@48e6:  .byte   $80,$00,$00,$01,$04

CharCtrlCursorPos:
@48eb:  .byte   $50,$7b
        .byte   $50,$8b
        .byte   $50,$9b
        .byte   $50,$ab

; ------------------------------------------------------------------------------

; window for character controller select
CharCtrlWindow:
@48f3:  .byte   $0b,$5b,$1c,$0b

; ------------------------------------------------------------------------------

; [ clear saved cursor positions ]

_c348f7:
@48f7:  clr_ax
@48f9:  sta     $022b,x     ; clear saved cursor positions
        inx
        cpx     #$001f
        bne     @48f9
        rts

; ------------------------------------------------------------------------------

ConfigLabelTextList1:
@4903:  .addr   ConfigControllerText
        .addr   ConfigCursorText

ConfigSpeedTextList:
@4907:  .addr   ConfigFastText
        .addr   ConfigSlowText

ConfigControllerText:
@490b:  .byte   $8f,$3d,$82,$a8,$a7,$ad,$ab,$a8,$a5,$a5,$9e,$ab,$00

ConfigWaitText:
@4918:  .byte   $b5,$39,$96,$9a,$a2,$ad,$00

ConfigFastText:
@491f:  .byte   $65,$3a,$85,$9a,$ac,$ad,$00

ConfigSlowText:
@4926:  .byte   $75,$3a,$92,$a5,$a8,$b0,$00

ConfigCmdShortText:
@492d:  .byte   $35,$3b,$92,$a1,$a8,$ab,$ad,$00

ConfigGaugeOnText:
@4935:  .byte   $a5,$3b,$8e,$a7,$00

ConfigGaugeOffText:
@493a:  .byte   $b5,$3b,$8e,$9f,$9f,$00

ConfigStereoText:
@4940:  .byte   $25,$3c,$92,$ad,$9e,$ab,$9e,$a8,$00

ConfigMonoText:
@4949:  .byte   $35,$3c,$8c,$a8,$a7,$a8,$00

ConfigMemoryText:
@4950:  .byte   $b5,$3c,$8c,$9e,$a6,$a8,$ab,$b2,$00

ConfigOptimumText:
@4959:  .byte   $25,$3d,$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00

ConfigCtrlMultiText:
@4963:  .byte   $b5,$3d,$8c,$ae,$a5,$ad,$a2,$a9,$a5,$9e,$00

ConfigBattleSpeedNumText:
@496e:  .byte   $25,$3a,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$00

ConfigMsgSpeedNumText:
@497c:  .byte   $a5,$3a,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$00

ConfigCursorText:
@498a:  .byte   $8f,$3c,$82,$ae,$ab,$ac,$a8,$ab,$00

ConfigLabelTextList2:
@4993:  .addr   ConfigBattleModeText
        .addr   ConfigBattleSpeedText
        .addr   ConfigMsgSpeedText
        .addr   ConfigCmdSetText
        .addr   ConfigGaugeText
        .addr   ConfigSoundText
        .addr   ConfigReequipText

ConfigTitleText:
@49a1:  .byte   $f9,$78,$82,$a8,$a7,$9f,$a2,$a0,$00

ConfigBattleModeText:
@49aa:  .byte   $8f,$39,$81,$9a,$ad,$c5,$8c,$a8,$9d,$9e,$00

ConfigBattleSpeedText:
@49b5:  .byte   $0f,$3a,$81,$9a,$ad,$c5,$92,$a9,$9e,$9e,$9d,$00

ConfigMsgSpeedText:
@49c1:  .byte   $8f,$3a,$8c,$ac,$a0,$c5,$92,$a9,$9e,$9e,$9d,$00

ConfigCmdSetText:
@49cd:  .byte   $0f,$3b,$82,$a6,$9d,$c5,$92,$9e,$ad,$00

ConfigGaugeText:
@49d7:  .byte   $8f,$3b,$86,$9a,$ae,$a0,$9e,$00

ConfigSoundText:
@49df:  .byte   $0f,$3c,$92,$a8,$ae,$a7,$9d,$00

ConfigReequipText:
@49e7:  .byte   $0f,$3d,$91,$9e,$9e,$aa,$ae,$a2,$a9,$00

ConfigActiveText:
@49f1:  .byte   $a5,$39,$80,$9c,$ad,$a2,$af,$9e,$00

ConfigCmdWindowText:
@49fa:  .byte   $25,$3b,$96,$a2,$a7,$9d,$a8,$b0,$00

ConfigResetText:
@4a03:  .byte   $a5,$3c,$91,$9e,$ac,$9e,$ad,$00

ConfigEmptyText:
@4a0b:  .byte   $35,$3d,$84,$a6,$a9,$ad,$b2,$00

ConfigCtrlSingleText:
@4a13:  .byte   $a5,$3d,$92,$a2,$a7,$a0,$a5,$9e,$00

ConfigLabelTextList3:
@4a1c:  .addr   ConfigMagicOrderText
        .addr   ConfigWindowLabelText
        .addr   ConfigColorText

; color selector bars
ConfigColorBarTextList:
@4a22:  .addr   ConfigColorBarRText
        .addr   ConfigColorBarGText
        .addr   ConfigColorBarBText

ConfigLabelTextList4:
@4a28:  .addr   ConfigColorRText
        .addr   ConfigColorGText
        .addr   ConfigColorBText
        .addr   ConfigMagicOrderAText
        .addr   ConfigMagicOrderBText
        .addr   ConfigMagicOrderCText

ConfigMagicOrderText:
@4a34:  .byte   $8f,$41,$8c,$9a,$a0,$c5,$8e,$ab,$9d,$9e,$ab,$00

ConfigWindowLabelText:
@4a40:  .byte   $8f,$43,$96,$a2,$a7,$9d,$a8,$b0,$00

ConfigColorText:
@4a49:  .byte   $0f,$44,$82,$a8,$a5,$a8,$ab,$00

ConfigMagicOrderAText:
@4a51:  .byte   $25,$42,$80,$d3,$00

ConfigMagicOrderBText:
@4a56:  .byte   $a5,$42,$81,$d3,$00

ConfigMagicOrderCText:
@4a5b:  .byte   $25,$43,$82,$d3,$00

ConfigColorBarRText:
@4a60:  .byte   $2d,$45,$f9,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$fa,$00

ConfigColorBarGText:
@4a6d:  .byte   $ad,$45,$f9,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$fa,$00

ConfigColorBarBText:
@4a7a:  .byte   $2d,$46,$f9,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$fa,$00

ConfigColorRText:
@4a87:  .byte   $25,$45,$91,$00

ConfigColorGText:
@4a8b:  .byte   $a5,$45,$86,$00

ConfigColorBText:
@4a8f:  .byte   $25,$46,$81,$00

ConfigColorNumText:
@4a93:  .byte   $a5,$43,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$ff,$bb,$ff,$bc,$00

ConfigMagicOrderNumText:
@4aa5:  .byte   $a5,$41,$b5,$ff,$b6,$ff,$b7,$ff,$b8,$ff,$b9,$ff,$ba,$00

ConfigFontText:
@4ab3:  .byte   $25,$44,$85,$a8,$a7,$ad,$00

ConfigWindowText:
@4aba:  .byte   $35,$44,$96,$a2,$a7,$9d,$a8,$b0,$00

; unused
@4ac3:  .byte   $fb,$43,$a5,$47,$79,$00

ConfigColorBoxText:
@4ac9:  .byte   $b5,$44,$01,$02,$03,$04,$05,$06,$07,$00

ConfigMagicTypeText:
@4ad3:  .byte   $e8,$87,$9e,$9a,$a5,$a2,$a7,$a0,$ff,$ff
@4ade:  .byte   $e9,$80,$ad,$ad,$9a,$9c,$a4,$ff,$ff,$ff
@4ae8:  .byte   $ea,$84,$9f,$9f,$9e,$9c,$ad,$ff,$ff,$ff

; ------------------------------------------------------------------------------

@4af1:  .byte   $cf,$78,$80,$ab,$ab,$9a,$a7,$a0,$9e,$00
@4afb:  .byte   $4d,$7b,$82,$a8,$a7,$ad,$ab,$a8,$a5,$a5,$9e,$ab,$00
@4b08:  .byte   $21,$7c,$82,$a7,$ad,$a5,$ab,$b5,$00
@4b11:  .byte   $33,$7c,$82,$a7,$ad,$a5,$ab,$b6,$00
@4b1a:  .byte   $a1,$7c,$82,$a7,$ad,$a5,$ab,$b5,$00
@4b23:  .byte   $b3,$7c,$82,$a7,$ad,$a5,$ab,$b6,$00
@4b2c:  .byte   $21,$7d,$82,$a7,$ad,$a5,$ab,$b5,$00
@4b35:  .byte   $33,$7d,$82,$a7,$ad,$a5,$ab,$b6,$00
@4b3e:  .byte   $a1,$7d,$82,$a7,$ad,$a5,$ab,$b5,$00
@4b47:  .byte   $b3,$7d,$82,$a7,$ad,$a5,$ab,$b6,$00

; ------------------------------------------------------------------------------

; [ init cursor (skills) ]

LoadSkillsCursor:
@4b50:  ldy     #.loword(SkillsCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (skills) ]

UpdateSkillsCursor:
@4b56:  jsr     MoveCursor

InitSkillsCursor:
@4b59:  ldy     #.loword(SkillsCursorPos)
        jsr     UpdateCursorPos
        clr_a
        lda     $28         ; selected character
        asl
        tax
        lda     $4d
        sta     $0236,x     ; save cursor position
        lda     $4e
        sta     $0237,x
        rts

; ------------------------------------------------------------------------------

; skills cursor data
SkillsCursorProp:
@4b6f:  .byte   $80,$00,$01,$01,$07

; skills cursor positions
SkillsCursorPos:
@4b74:  .byte   $00,$14
        .byte   $00,$24
        .byte   $00,$44
        .byte   $00,$54
        .byte   $00,$64
        .byte   $00,$74
        .byte   $00,$84

; ------------------------------------------------------------------------------

; [ init cursor (magic) ]

LoadMagicCursor:
@4b82:  ldy     #.loword(MagicCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (magic) ]

UpdateMagicCursor:
@4b88:  jsr     MoveListCursor

InitMagicCursor:
@4b8b:  ldy     #.loword(MagicCursorPos)
        jsr     UpdateListCursorPos
        clr_a
        lda     $28         ; character slot
        asl
        tax
        lda     $4f
        sta     $023e,x     ; save cursor position
        lda     $50
        sta     $023f,x
        lda     $28
        tax
        lda     $4a
        sta     $0246,x
        rts

; ------------------------------------------------------------------------------

; magic cursor data
MagicCursorProp:
@4ba9:  .byte   $01,$00,$00,$02,$08

; magic cursor positions
MagicCursorPos:
@4bae:  .byte   $08,$74,$70,$74
        .byte   $08,$80,$70,$80
        .byte   $08,$8c,$70,$8c
        .byte   $08,$98,$70,$98
        .byte   $08,$a4,$70,$a4
        .byte   $08,$b0,$70,$b0
        .byte   $08,$bc,$70,$bc
        .byte   $08,$c8,$70,$c8

; ------------------------------------------------------------------------------

; [ init cursor (blitz/swdtech/dance) ]

LoadAbilityCursor:
@4bce:  ldy     #.loword(AbilityCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (blitz/swdtech/dance) ]

UpdateAbilityCursor:
@4bd4:  jsr     MoveCursor

InitAbilityCursor:
@4bd7:  ldy     #.loword(AbilityCursorPos)
        sty     $e7
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; blitz/swdtech/dance cursor data
AbilityCursorProp:
@4bdf:  .byte   $00,$00,$00,$02,$04

; blitz/swdtech/dance cursor positions
AbilityCursorPos:
@4be4:  .byte   $08,$74,$78,$74
        .byte   $08,$8c,$78,$8c
        .byte   $08,$a4,$78,$a4
        .byte   $08,$bc,$78,$bc

; ------------------------------------------------------------------------------

; [ init cursor (lore) ]

LoadLoreCursor:
@4bf4:  ldy     #.loword(LoreCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (lore) ]

UpdateLoreCursor:
@4bfa:  jsr     MoveListCursor

InitLoreCursor:
@4bfd:  ldy     #.loword(LoreCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; lore cursor data
LoreCursorProp:
@4c03:  .byte   $01,$00,$00,$01,$08

; lore cursor positions
LoreCursorPos:
@4c08:  .byte   $08,$74
        .byte   $08,$80
        .byte   $08,$8c
        .byte   $08,$98
        .byte   $08,$a4
        .byte   $08,$b0
        .byte   $08,$bc
        .byte   $08,$c8

; ------------------------------------------------------------------------------

; [ init cursor (espers select) ]

LoadGenjuCursor:
@4c18:  ldy     #.loword(GenjuCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (espers select) ]

UpdateGenjuCursor:
@4c1e:  jsr     MoveListCursor

InitGenjuCursor:
@4c21:  ldy     #.loword(GenjuCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; espers select cursor data
GenjuCursorProp:
@4c27:  .byte   $01,$00,$00,$02,$08

; espers select cursor positions
GenjuCursorPos:
@4c2c:  .byte   $08,$74,$78,$74
        .byte   $08,$80,$78,$80
        .byte   $08,$8c,$78,$8c
        .byte   $08,$98,$78,$98
        .byte   $08,$a4,$78,$a4
        .byte   $08,$b0,$78,$b0
        .byte   $08,$bc,$78,$bc
        .byte   $08,$c8,$78,$c8

; ------------------------------------------------------------------------------

; [ init cursor (rage) ]

LoadRiotCursor:
@4c4c:  ldy     #.loword(RiotCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (rage) ]

UpdateRiotCursor:
@4c52:  jsr     MoveListCursor

InitRiotCursor:
@4c55:  ldy     #.loword(RiotCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; rage cursor data
RiotCursorProp:
@4c5b:  .byte   $01,$00,$00,$02,$08

; rage cursor positions
RiotCursorPos:
@4c60:  .byte   $18,$74,$88,$74
        .byte   $18,$80,$88,$80
        .byte   $18,$8c,$88,$8c
        .byte   $18,$98,$88,$98
        .byte   $18,$a4,$88,$a4
        .byte   $18,$b0,$88,$b0
        .byte   $18,$bc,$88,$bc
        .byte   $18,$c8,$88,$c8

; ------------------------------------------------------------------------------

; [ init bg (skills) ]

_c34c80:
@4c80:  stz     $9e                     ;
        jsr     DisableDMA2
        lda     #$01
        sta     hBG1SC
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        ldy     #.loword(SkillsMagicWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsCharWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsDescWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsOptionsWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsOptionsWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsMagicWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsCharWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsDescWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsMPWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     _c34d27
        jsr     TfrBG1ScreenAB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     _c3a662
        jsr     _c34d3d
        lda     $79
        sta     $29
        ldy     #.loword(SkillsGenjuText)
        jsr     DrawPosText
        lda     $7a
        sta     $29
        ldy     #.loword(SkillsMagicText)
        jsr     DrawPosText
        lda     $7b
        sta     $29
        ldy     #.loword(SkillsBushidoText)
        jsr     DrawPosText
        lda     $7c
        sta     $29
        ldy     #.loword(SkillsBlitzText)
        jsr     DrawPosText
        lda     $7d
        sta     $29
        ldy     #.loword(SkillsLoreText)
        jsr     DrawPosText
        lda     $7e
        sta     $29
        ldy     #.loword(SkillsRiotText)
        jsr     DrawPosText
        lda     $7f
        sta     $29
        ldy     #.loword(SkillsDanceText)
        jsr     DrawPosText
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c34d27:
@4d27:  jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        lda     #$24
        sta     $29
        ldx     #.loword(SkillsCharLabelTextList)
        ldy     #$0006
        jsr     DrawPosList
        jmp     _c34ee5

; ------------------------------------------------------------------------------

; [ update skills text colors ]

_c34d3d:
@4d3d:  lda     #$24        ; init all skills to gray (disabled)
        ldx     $00
@4d41:  sta     $79,x
        inx
        cpx     #$0007
        bne     @4d41
        jsr     _c34edd
        phy
        ldx     #$0004
@4d50:  phx
        ldx     $00
@4d53:  lda     $0016,y     ; battle command
        cmp     f:_c34d78,x
        bne     @4d60
        lda     #$20
        sta     $79,x
@4d60:  inx
        cpx     #$0007
        bne     @4d53
        iny
        plx
        dex
        bne     @4d50
        ply
        lda     $0000,y     ; espers always disabled for character $0c (gogo)
        cmp     #$0c
        bne     @4d77
        lda     #$24
        sta     $79
@4d77:  rts

; ------------------------------------------------------------------------------

; battle commands for enabling skills (esper, magic, swdtech, blitz, lore, rage, dance)
_c34d78:
@4d78:  .byte   $02,$02,$07,$0a,$0c,$10,$13

; ------------------------------------------------------------------------------

; [  ]

_c34d7f:
@4d7f:  jsr     ClearBG1ScreenA
        jsr     _c34f1c
        jsr     DrawMagicList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsMPCostText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitBG3TilesRightDMA1

; ------------------------------------------------------------------------------

; window data for skills menu
; c3/4d98: bg2_0( 1, 1) [ 7x 4]
; c3/4d9c: bg2_0( 1, 7) [ 7x10]
; c3/4da0: bg2_0( 1, 6) [28x 5]
; c3/4da4: bg2_0( 1,13) [28x12]
; c3/4da8: bg2_0( 1, 1) [28x 3]
; c3/4dac: bg2_1( 1, 6) [28x 5]
; c3/4db0: bg2_1( 1,13) [28x12]
; c3/4db4: bg2_1(22, 4) [ 7x 1]
; c3/4db8: bg2_1( 1, 1) [28x 3]

; espers/magic window
SkillsOptionsWindow1:
@4d98:  .word   $588b
        .byte   $07,$04

; character skills list window
SkillsOptionsWindow2:
@4d9c:  .word   $5a0b
        .byte   $07,$0a

; character info window
SkillsCharWindow1:
@4da0:  .word   $59cb
        .byte   $1c,$05

; spell list window
SkillsMagicWindow1:
@4da4:  .word   $5b8b
        .byte   $1c,$0c

; description window
SkillsDescWindow1:
@4da8:  .word   $588b
        .byte   $1c,$03

; character window, top right screen
SkillsCharWindow2:
@4dac:  .word   $61cb
        .byte   $1c,$05

; spell list window, top right screen
SkillsMagicWindow2:
@4db0:  .word   $638b
        .byte   $1c,$0c

; mp cost window, top right screen
SkillsMPWindow:
@4db4:  .word   $6175
        .byte   $07,$01

; description window, top right screen
SkillsDescWindow2:
@4db8:  .word   $608b
        .byte   $1c,$03

; ------------------------------------------------------------------------------

; [ init bg scrolling hdma (skills) ]

InitSkillsBGScrollHDMA:
@4dbc:  lda     #$02        ; hdma #5 - one address, write twice, absolue addressing
        sta     $4350
        lda     #$12        ; destination = $2112 (bg3 vertical scroll)
        sta     $4351
        ldy     #.loword(SkillsBG3VScrollHDMATbl)
        sty     $4352
        lda     #^SkillsBG3VScrollHDMATbl
        sta     $4354
        lda     #^SkillsBG3VScrollHDMATbl
        sta     $4357
        lda     #$20        ; enable hdma channel #5
        tsb     $43
        jsr     LoadSkillsBG1VScrollHDMATbl
        ldx     $00
@4ddf:  lda     f:SkillsBG1HScrollHDMATbl,x   ; load bg1 horizontal scroll hdma table
        sta     $7e9a09,x
        inx
        cpx     #$000d
        bne     @4ddf
        lda     #$02        ; hdma #6 - one address, write twice, absolue addressing
        sta     $4360
        lda     #$0d        ; destination = $210d (bg1 horizontal scroll)
        sta     $4361
        ldy     #$9a09      ; source = $7e9a09
        sty     $4362
        lda     #$7e
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$02        ; hdma #6 - one address, write twice, absolue addressing
        sta     $4370
        lda     #$0e        ; destination = $210e (bg1 vertical scroll)
        sta     $4371
        ldy     #$9849      ; source = $7e9849
        sty     $4372
        lda     #$7e
        sta     $4374
        lda     #$7e
        sta     $4377
        lda     #$c0        ; enable hdma channel #6 and #7
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (skills)
SkillsBG3VScrollHDMATbl:
@4e26:  .byte   $4f
        .word   $0002
        .byte   $40
        .word   $0002
        .byte   $00

; ------------------------------------------------------------------------------

; [ load bg1 vertical scroll hdma table (skills) ]

LoadSkillsBG1VScrollHDMATbl:
@4e2d:  ldx     $00
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
        cpx     #$005a
        bne     @4e3d
@4e63:  lda     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        cpx     #$005e
        bne     @4e63
        rts

; ------------------------------------------------------------------------------

; bg1 horizontal scroll hdma table (skills)
SkillsBG1HScrollHDMATbl:
@4e72:  .byte   $27
        .word   $0100
        .byte   $48
        .word   $0100
        .byte   $60
        .word   $0000
        .byte   $1e
        .word   $0100
        .byte   $00

; bg1 vertical scroll hdma table (skills)
SkillsBG1VScrollHDMATbl:
@4e7f:  .byte   $3f
        .word   $0000
        .byte   $0c
        .word   $0004
        .byte   $0c
        .word   $0008
        .byte   $0a
        .word   $000c
        .byte   $01
        .word   $000c
        .byte   $0d
        .word   $0008
        .byte   $04
        .word   $ff94
        .byte   $04
        .word   $ff94
        .byte   $04
        .word   $ff94
        .byte   $04
        .word   $ff98
        .byte   $04
        .word   $ff98
        .byte   $04
        .word   $ff98
        .byte   $04
        .word   $ff9c
        .byte   $04
        .word   $ff9c
        .byte   $04
        .word   $ff9c
        .byte   $04
        .word   $ffa0
        .byte   $04
        .word   $ffa0
        .byte   $04
        .word   $ffa0
        .byte   $04
        .word   $ffa4
        .byte   $04
        .word   $ffa4
        .byte   $04
        .word   $ffa4
        .byte   $04
        .word   $ffa8
        .byte   $04
        .word   $ffa8
        .byte   $04
        .word   $ffa8
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
        .byte   $1e
        .word   $ff20
        .byte   $00

; ------------------------------------------------------------------------------

; [  ]

_c34edd:
@4edd:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34ee5:
@4ee5:  jsr     _c34edd
        sty     $67
        jmp     @4eed

; ???
@4eed:  ldy     #$42dd
        ldx     #$4f50
        jsr     DrawStatusIcons
        ldy     #.loword(SkillsCharHPSlashText)
        jsr     DrawPosText
        ldy     #.loword(SkillsCharMPSlashText)
        jsr     DrawPosText
        ldx     #.loword(_c34f12)
        jsr     DrawCharBlock

_c34f08:
@4f08:  lda     #$20
        sta     $29
        ldy     #$421d
        jmp     DrawEquipGenju

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (skills)
_c34f12:
@4f12:  .word   $4237,$42b3,$42bd,$4333,$433d

; ------------------------------------------------------------------------------

; [  ]

_c34f1c:
@4f1c:  ldx     #$9d89
        stx     hWMADDL
        ldx     #$0036
        lda     #$ff
@4f27:  sta     hWMDATA
        dex
        bne     @4f27
        clr_ay
        lda     $1d54
        and     #$07
        asl2
        tax
@4f37:  phx
        lda     f:_c34f49,x
        cmp     #$ff
        beq     @4f47
        jsr     _c34f61
        plx
        inx
        bra     @4f37
@4f47:  plx
        rts

; ------------------------------------------------------------------------------

_c34f49:
@4f49:  .byte   $2d,$00,$18,$ff
        .byte   $2d,$18,$00,$ff
        .byte   $00,$18,$2d,$ff
        .byte   $00,$2d,$18,$ff
        .byte   $18,$2d,$00,$ff
        .byte   $18,$00,$2d,$ff

; ------------------------------------------------------------------------------

; [  ]

_c34f61:
@4f61:  cmp     #$00
        beq     @4f6e
        cmp     #$2d
        beq     @4f73
        ldx     #$0015
        bra     @4f78
@4f6e:  ldx     #$0018
        bra     @4f78
@4f73:  ldx     #$0009
        bra     @4f78
@4f78:  stx     $e0
        tax
@4f7b:  tyx
        sta     $7e9d89,x
        inc
        iny
        dec     $e0
        bne     @4f7b
        rts

; ------------------------------------------------------------------------------

; [ draw entire magic list ]

DrawMagicList:
@4f87:  jsr     GetListTextPos
        ldy     #8
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

DrawMagicListRow:
@4f9e:  jsr     _c34fb5
        ldx     #$0003
        jsr     _c34fc4
        inc     $e5
        jsr     _c34fb5
        ldx     #$0010
        jsr     _c34fc4
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34fb5:
@4fb5:  ldy     #$0007
        sty     $eb
        ldy     #$f567      ; $e6f567 (spell names)
        sty     $ef
        lda     #$e6
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34fc4:
@4fc4:  lda     $e6
        inc
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
        ldx     #$9e92
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
        lda     #$ff
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf
@501a:  clr_a
        lda     $e5
        tax
        lda     #$ff
        sta     $7e9d89,x
        jsr     _c351b9
        ldy     #$000b
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
        ldx     #$9e92
        stx     hWMADDL
        jsr     _c350ec
        jsr     _c350a2
        cmp     #$ff
        beq     @5088
        pha
        jsr     _c351b9
        lda     #$2c
        sta     $29
        lda     #$c7
        sta     hWMDATA
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
        sta     $29
        jsr     _c350ec
        jsr     _c3514d
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        bra     @5082

; ------------------------------------------------------------------------------

; [  ]

_c350a2:
@50a2:  sta     $e0
        jsr     _c34edd
        lda     $0000,y
        cmp     #$0c
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
        cmp     $28
        beq     @50e2
        asl
        tax
        ldy     $6d,x
        beq     @50e2
        lda     $0000,y
        cmp     #$0c
        bcs     @50e2
        jsr     _c350ae
        cmp     #$ff
        beq     @50eb
@50e2:  inc     $e1
        lda     $e1
        cmp     #$04
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
        lda     $c46ac5,x   ; spell data
        sta     $e0
        pla
        cmp     #$99
        bne     @512e
        lda     $021b
        asl
        sta     $e0
        lda     $021c
        cmp     #$1e
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

; [  ]

_c3514d:
@514d:  cmp     #$2a
        beq     @517b
        cmp     #$12
        beq     @516e
@5155:  jsr     _c350f5
        ldx     hMPYL
        lda     $c46ac3,x
        and     #$01
        beq     @516c
        jsr     _c350ec
        jsr     _c3510d
        jmp     @5188
@516c:  bra     _51b9
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
        bne     _51b9
@519b:  longa
        lda     $000d,y
        sta     $e0
        shorta
        ldx     $e2
        cpx     $e0
        beq     @51ac
        bcs     _51b9
@51ac:  clr_a
        lda     $e5
        tax
        lda     #$20
        sta     $29
        sta     $7e9e09,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c351b9:
_51b9:  clr_a
        lda     $e5
        tax
        lda     #$28
        sta     $29
        sta     $7e9e09,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c351c6:
@51c6:  lda     #$20
        sta     $29
        longa
        lda     #$81bf
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
        sta     $29
        ldy     #.loword(SkillsLoreTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitBG3TilesRightDMA1

; ------------------------------------------------------------------------------

; [  ]

_c3520f:
@520f:  ldx     #$9d89
        stx     hWMADDL
        ldx     $00
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
        ldy     #8
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

DrawLoreListRow:
@5256:  lda     #$20
        sta     $29
        jsr     _c35266
        ldx     #$0003
        jsr     _c35275
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35266:
@5266:  ldy     #$000a
        sty     $eb
        ldy     #$f9fd      ; $e6f9fd (lore names)
        sty     $ef
        lda     #$e6
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35275:
@5275:  lda     $e6
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
        beq     @52c0
        lda     $e5
        jsr     LoadArrayItem
        ldx     #$9e95
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
@52c0:  ldy     #$000e
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
        lda     #$20
        sta     $29
        jsr     _c352f4
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsBushidoTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitBG3TilesRightDMA1

; ------------------------------------------------------------------------------

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
@5328:  ldy     #$000c
        sty     $eb
        ldy     #$3c40
        sty     $ef
        lda     #$cf
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

; [  ]

_c35391:
@5391:  jsr     ClearBG1ScreenA
        jsr     DrawRiotList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsRiotTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitBG3TilesRightDMA1

; ------------------------------------------------------------------------------

; [ draw entire rage list ]

DrawRiotList:
@53a7:  jsr     GetRiotList
        jsr     GetListTextPos
        ldy     #9
@53b0:  phy
        jsr     GetRiotListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @53b0
        rts

; ------------------------------------------------------------------------------

; [  ]

GetRiotList:
@53c1:  ldx     #$9d89
        stx     hWMADDL
        ldx     $00
        stz     $e0
@53cb:  ldy     #$0008
        lda     $1d2c,x     ; known rages
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

GetRiotListRow:
@53ee:  lda     #$20
        sta     $29
        jsr     _c35409
        ldx     #$0005
        jsr     _c35418
        inc     $e5
        jsr     _c35409
        ldx     #$0013
        jsr     _c35418
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35409:
@5409:  ldy     #$000a
        sty     $eb
        ldy     #$c050
        sty     $ef
        lda     #$cf
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35418:
@5418:  lda     $e6
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
        beq     @543b
        lda     $e5
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@543b:  ldy     #$000a
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
        sta     $29
        jsr     DrawGenjuList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsGenjuTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitBG3TilesRightDMA1

; ------------------------------------------------------------------------------

; [ draw entire esper list ]

DrawGenjuList:
@546c:  jsr     GetGenjuList
        jsr     GetListTextPos
        ldy     #8
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
        ldx     $00
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
        lda     $d1f9b5,x   ; esper order for menu
        dec
        tax
        pla
        sta     $7e9d89,x
@54df:  dey
        bne     @54cd
        rts

; ------------------------------------------------------------------------------

; [ draw one row of esper list ]

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
@54fa:  ldy     #$0008
        sty     $eb
        ldy     #$f6e1      ; $e6f6e1 (esper names)
        sty     $ef
        lda     #$e6
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35509:
@5509:  lda     $e6
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
        ldx     $00
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
@5595:  sta     $29
        lda     $e0
        rts

; ------------------------------------------------------------------------------

; [ show error message if esper is already equipped ]

_c3559a:
@559a:  lda     #$20
        sta     $29
        longa
        lda     #$40cd                  ; position
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
@55c0:  ldx     $00
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
        sta     $29
        ldy     #.loword(SkillsBlitzTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitBG3TilesRightDMA1

; ------------------------------------------------------------------------------

; [ draw entire list of blitz inputs ]

DrawBlitzList:
@55ea:  jsr     GetBlitzList
        jsr     GetListTextPos
        stz     $e5
        inc     $e6
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
@560a:  ldx     #$0004
        jsr     DrawBlitzInput
        inc     $e5
        ldx     #$0012
        jsr     DrawBlitzInput
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
        ldx     $00
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
        ldy     #$000a
@5699:  phx
        lda     $c47a40,x   ; blitz codes
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
@56bc:  ldy     $00
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
@56eb:  ldx     #.loword(LoreDescPtrs)
        stx     $e7
        ldx     #.loword(LoreDesc)
        stx     $eb
        lda     #^LoreDescPtrs
        sta     $e9
        lda     #^LoreDesc
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load swdtech description ]

LoadBushidoDesc:
@5700:  ldx     #$ffae      ; $cfffae (pointers to swdtech descriptions)
        stx     $e7
        ldx     #$fd00      ; $cffd00 (swdtech descriptions)
        stx     $eb
        lda     #$cf
        sta     $e9
        lda     #$cf
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load blitz description ]

LoadBlitzDesc:
@5715:  ldx     #$ff9e      ; $cfff9e (pointers to blitz descriptions)
        stx     $e7
        ldx     #$fc00      ; $cffc00 (blitz descriptions)
        stx     $eb
        lda     #$cf
        sta     $e9
        lda     #$cf
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load description text ]

LoadBigText:
@572a:  ldx     #$9ec9
        stx     hWMADDL
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x

LoadItemDesc:
@5738:  cmp     #$ff
        beq     @576d
        longa
        asl
        tay
        lda     [$e7],y
        tay
        shorta
@5745:  lda     [$eb],y
        beq     @574f
        sta     hWMDATA
        iny
        bra     @5745
@574f:  dey
        lda     [$eb],y
        iny
        cmp     #$1c
        beq     @5767
        cmp     #$1d
        beq     @5767
        cmp     #$1e
        beq     @5767
        cmp     #$1f
        beq     @5767
@5763:  stz     hWMDATA
        rts
@5767:  stz     hWMDATA
        iny
        bra     @5745
@576d:  lda     #$ff
        sta     hWMDATA
        bra     @5763

; ------------------------------------------------------------------------------

; [ draw dance menu ]

DrawDanceMenu:
@5774:  jsr     ClearBG1ScreenA
        jsr     DrawDanceList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsDanceTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitBG3TilesRightDMA1

; ------------------------------------------------------------------------------

; [ draw dance list text ]

DrawDanceList:
@578a:  jsr     GetDanceList
        jsr     GetListTextPos
        inc     $e6
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
        ldx     #$0003
        jsr     DrawDanceName
        inc     $e5
        jsr     GetDanceNamePtr
        ldx     #$0011
        jsr     DrawDanceName
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get pointer to dance name ]

GetDanceNamePtr:
@57c1:  ldy     #12
        sty     $eb
        ldy     #$ff9d      ; $e6ff9d (dance names)
        sty     $ef
        lda     #$e6
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
@57f0:  ldy     #$000c
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
        ldy     #.loword(_c3583f)
        jsr     DrawWindow
        ldy     #.loword(_c35843)
        jsr     DrawWindow
        ldy     #.loword(_c35847)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenB
        ldy     #$ffc0
        sty     $35
        lda     #$02
        tsb     $45
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
        sta     $29
        ldy     #.loword(_c35889)
        jsr     DrawPosText
        ldy     #.loword(_c3588e)
        jsr     DrawPosText
        clr_a
        lda     $4b
        sta     $e5
        jsr     _c34fb5
        longa
        lda     #$790d
        sta     $7e9e89
        shorta
        jsr     _c350ec
        jsr     LoadArrayItem
        jsr     DrawPosTextBuf
        jsr     _c350ec
        jsr     _c3510d
        jsr     HexToDec3
        ldx     #$7a0f
        jsr     DrawNum2
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

_c35889:
@5889:  .byte   $15,$7a,$8c,$8f,$00

_c3588e:
@588e:  .byte   $4d,$7a,$8d,$9e,$9e,$9d,$9e,$9d,$00

; ------------------------------------------------------------------------------

; [ init esper detail menu ]

InitEsperDetailMenu:
@5897:  ldy     $4f
        sty     $8e
        lda     $4a
        sta     $90
        jsr     LoadGenjuProp
        jsr     DrawEsperDetailMenu
        jsr     InitBG1TilesRightDMA1
        jsr     WaitVblank
        jsr     InitBG1TilesLeftDMA1
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
        trb     $46
        jsr     LoadGenjuDetailCursor
        jmp     InitGenjuDetailCursor

; ------------------------------------------------------------------------------

; [ menu state $4d: esper detail ]

MenuState_4d:
@58ce:  jsr     UpdateGenjuDetailCursor
        jsr     _c35b93

; A button
        lda     $08
        bit     #$80
        beq     @590a
        clr_a
        lda     $4b
        bne     @590a
        lda     $99
        jsr     _c35574
        sta     $e0
        lda     $29
        cmp     #$28
        bne     @5902
        jsr     PlayInvalidSfx
        lda     #$10
        tsb     $45
        jsr     _c3559a
        ldy     #$0020
        sty     $20
        lda     #$34
        sta     $26
        jmp     InitBG1TilesRightDMA1

; equip esper
@5902:  jsr     PlaySelectSfx
        jsr     _c32929
        bra     _c35913

; B button
@590a:  lda     $09
        bit     #$80
        beq     _597c
        jsr     PlayCancelSfx

_c35913:
@5913:  lda     #$10
        tsb     $45
        lda     $5f
        sta     $49
        jsr     DrawGenjuList
        jsr     CreateScrollArrowTask1
        longa
        lda     #$1000
        sta     $7e354a,x
        lda     #$0060
        sta     $7e34ca,x
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
        lda     #$06
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        jsr     InitBG1TilesLeftDMA1
        jsr     WaitVblank
        longa
        clr_a
        sta     $7e9a10
        shorta
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     LoadSkillsBG1VScrollHDMATbl
        jsr     InitBG1TilesRightDMA1
        lda     #$1e
        sta     $26
_597c:  rts

; ------------------------------------------------------------------------------

; [ load cursor for esper details ]

LoadGenjuDetailCursor:
@597d:  ldy     #.loword(GenjuDetailCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor positions for esper details ]

UpdateGenjuDetailCursor:
@5983:  jsr     MoveCursor

InitGenjuDetailCursor:
@5986:  ldy     #.loword(GenjuDetailCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GenjuDetailCursorProp:
@598c:  .byte   $80,$00,$00,$01,$07

GenjuDetailCursorPos:
@5991:  .byte   $10,$70
        .byte   $18,$7c
        .byte   $18,$88
        .byte   $18,$94
        .byte   $18,$a0
        .byte   $18,$ac
        .byte   $18,$b8

; ------------------------------------------------------------------------------

; [ draw esper detail menu ]

DrawEsperDetailMenu:
@599f:  lda     #$20
        sta     $29
        ldy     #.loword(GenjuLearnRateText)
        jsr     DrawPosText
        ldy     #.loword(GenjuLearnPctText)
        jsr     DrawPosText
        lda     $99
        jsr     _c35574
        ldy     #$4411
        jsr     InitTextBuf
        clr_a
        lda     $99
        asl3
        tax
        ldy     #8
@59c4:  lda     $e6f6e1,x   ; esper names
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
        sta     $29
        ldy     #$0011
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
        cmp     #$001b
        bne     @59f4
        shorta
        lda     f:GenjuProp,x               ; level up bonus
        cmp     #$ff
        beq     @5a67
        sta     hWRMPYA
        lda     #9
        sta     hWRMPYB
        ldy     #$4713
        jsr     InitTextBuf
        ldx     $00
@5a43:  lda     f:GenjuAtLevelUpText,x
        sta     hWMDATA
        inx
        cpx     #$000e
        bne     @5a43
        ldx     hRDMPYL
        ldy     #$0009
@5a56:  lda     $cffeae,x               ; esper bonus names
        sta     hWMDATA
        inx
        dey
        bne     @5a56
        stz     hWMDATA
        jmp     DrawPosTextBuf
@5a67:  ldy     #$4713
        jsr     InitTextBuf
        ldy     #$0017
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
@5a84:  jsr     _c35b3d
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
@5ac2:  lda     #$b5
        sta     hWMDATA
        lda     #$b4
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
@5ae1:  jsr     _c35b3d
        longa
        txa
        sta     $7e9e89
        shorta

DrawItemMagicName:
@5aed:  jsr     _c34fb5
        lda     $e1
        cmp     #$ff
        beq     @5b26
        jsr     LoadArrayItem
        ldx     #$9e92
        stx     hWMADDL
        lda     #$c1                    ; colon
        sta     hWMDATA
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
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
@5b26:  ldy     #$000f
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5b31:  sta     hWMDATA
        dey
        bne     @5b31
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35b3d:
@5b3d:  longa
        tya
        asl6
        sta     $e7
        txa
        asl
        clc
        adc     $e7
        adc     #$4049
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
@5be3:  ldx     #$cf80      ; $d8cf80 (pointers to spell descriptions)
        stx     $e7
        ldx     #$c9a0      ; $d8c9a0 (spell descriptions)
        stx     $eb
        lda     #$d8
        sta     $e9
        lda     #$d8
        sta     $ed
        rts

GetGenjuBonusDescPtr:
@5bf6:  ldx     #$ffd0      ; $edffd0 (pointers to esper bonus descriptions)
        stx     $e7
        ldx     #$fe00      ; $edfe00 (esper bonus descriptions)
        stx     $eb
        lda     #$ed
        sta     $e9
        lda     #$ed
        sta     $ed
        rts

GetLoadGenjuAttackDescPtr:
@5c09:  ldx     #$fe40      ; $cffe40 (pointers to esper attack descriptions)
        stx     $e7
        ldx     #$3940      ; $cf3940 (esper attack descriptions)
        stx     $eb
        lda     #$cf
        sta     $e9
        lda     #$cf
        sta     $ed
        rts

; ------------------------------------------------------------------------------

BlitzInputTileTbl:
@5c1c:  .word   $0000,$0000,$0000,$2097,$2098,$208b,$2091,$20d6
@5c2c:  .word   $a0d4,$60d6,$20d5,$c0d6,$20d4,$a0d6,$60d5

; unused
SkillsListTextPtrs:
@5c3a:  .addr   SkillsGenjuText
        .addr   SkillsMagicText
        .addr   SkillsBushidoText
        .addr   SkillsBlitzText
        .addr   SkillsLoreText
        .addr   SkillsRiotText
        .addr   SkillsDanceText

SkillsGenjuText:
@5c48:  .byte   $0d,$79,$84,$ac,$a9,$9e,$ab,$ac,$00

SkillsMagicText:
@5c51:  .byte   $8d,$79,$8c,$9a,$a0,$a2,$9c,$00

SkillsBushidoText:
@5c59:  .byte   $8d,$7a,$92,$b0,$9d,$93,$9e,$9c,$a1,$00

SkillsBlitzText:
@5c63:  .byte   $0d,$7b,$81,$a5,$a2,$ad,$b3,$00

SkillsLoreText:
@5c6b:  .byte   $8d,$7b,$8b,$a8,$ab,$9e,$00

SkillsRiotText:
@5c72:  .byte   $0d,$7c,$91,$9a,$a0,$9e,$00

SkillsDanceText:
@5c79:  .byte   $8d,$7c,$83,$9a,$a7,$9c,$9e,$00

SkillsCharLabelTextList:
@5c81:  .addr   SkillsCharLevelText
        .addr   SkillsCharHPText
        .addr   SkillsCharMPText

; text for small skills window

; there's a bug here: if you first select "espers" and then select "rage" for example, the last two
; characters of espers don't get erased and it instead displays "ragers"

; c3/5c87: bg3_1(23,5) "MP_    "
SkillsMPCostText:
@5c87:  .word   $81b7
        .byte   $8c,$8f,$c7,$ff,$ff,$ff,$ff,$00

; c3/5c91: bg3_1(23,5) "Lore"
SkillsLoreTitleText:
@5c91:  .word   $81b7
        .byte   $8b,$a8,$ab,$9e,$00

; c3/5c98: bg3_1(23,5) "Rage"
SkillsRiotTitleText:
@5c98:  .word   $81b7
        .byte   $91,$9a,$a0,$9e,$00

; c3/5c9f: bg3_1(23,5) "Dance"
SkillsDanceTitleText:
@5c9f:  .word   $81b7
        .byte   $83,$9a,$a7,$9c,$9e,$00

; c3/5ca7: bg3_1(23,5) "Espers"
SkillsGenjuTitleText:
@5ca7:  .word   $81b7
        .byte   $84,$ac,$a9,$9e,$ab,$ac,$00

; c3/5cb0: bg3_1(23,5) "Blitz"
SkillsBlitzTitleText:
@5cb0:  .word   $81b7
        .byte   $81,$a5,$a2,$ad,$b3,$00

; c3/5cb8: bg3_1(23,5) "SwdTech"
SkillsBushidoTitleText:
@5cb8:  .word   $81b7
        .byte   $92,$b0,$9d,$93,$9e,$9c,$a1,$00

; "LV"
SkillsCharLevelText:
@5cc2:  .word   $422d
        .byte   $8b,$95,$00

; "HP"
SkillsCharHPText:
@5cc7:  .word   $42ad
        .byte   $87,$8f,$00

; "MP"
SkillsCharMPText:
@5ccc:  .word   $432d
        .byte   $8c,$8f,$00

; "/"
SkillsCharHPSlashText:
@5cd1:  .word   $42bb
        .byte   $c0,$00

; "/"
SkillsCharMPSlashText:
@5cd5:  .word   $433b
        .byte   $c0,$00

; " has it!"
GenjuEquipErrorMsgText:
@5cd9:  .byte   $ff,$a1,$9a,$ac,$ff,$a2,$ad,$be,$00

; "Skill"
GenjuLearnPctText:
@5ce2:  .word   $4439
        .byte   $92,$a4,$a2,$a5,$a5,$00

; "Learn.Rate"
GenjuLearnRateText:
@5cea:  .word   $4423
        .byte   $8b,$9e,$9a,$ab,$a7,$c5,$91,$9a,$ad,$9e,$00

; "At level up..."
GenjuAtLevelUpText:
@5cf7:  .byte   $80,$ad,$ff,$a5,$9e,$af,$9e,$a5,$ff,$ae,$a9,$c5,$c5,$c5

; ------------------------------------------------------------------------------

; [ draw status menu ]

DrawStatusMenu:
@5d05:  jsr     DrawStatusMainWindow
        jsr     DrawStatusGogoWindow
        jsr     DrawStatusLabelText
        jsr     DrawStatusCharInfo
        jsr     TfrStatusMenu
        jmp     CreateSubPortraitTask

; ------------------------------------------------------------------------------

; [  ]

DrawStatusMainWindow:
@5d17:  jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenD
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     ClearBG3ScreenD
        ldy     #.loword(_c35f81)
        jsr     DrawWindow
        ldy     #.loword(_c35f79)
        jsr     DrawWindow
        ldy     #.loword(_c35f7d)
        jsr     DrawWindow
        rts

; ------------------------------------------------------------------------------

; [ draw labels on status menu (blue text) ]

DrawStatusLabelText:
@5d3c:  jsr     DrawStatusTopLabelText
        bra     DrawStatusBtmLabelText

DrawStatusTopLabelText:
@5d41:  lda     #$20                    ; white font
        sta     $29
        ldx     #.loword(StatusTopLabelTextList1)
        ldy     #$0008
        jsr     DrawPosList
        lda     #$24                    ; teal font
        sta     $29
        ldx     #.loword(StatusTopLabelTextList2)
        ldy     #$0006
        jsr     DrawPosList
        rts

DrawStatusBtmLabelText:
@5d5c:  lda     #$2c                    ; teal font
        sta     $29
        ldx     #.loword(StatusBtmLabelTextList1)
        ldy     #$001e
        jsr     DrawPosList
        lda     #$2c                    ; teal font
        sta     $29
        ldx     #.loword(StatusBtmLabelTextList2)
        ldy     #$000c
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ transfer status menu tiles to vram ]

TfrStatusMenu:
@5d77:  jsr     TfrBG2ScreenAB
        jsr     TfrBG1ScreenAB
        jsr     TfrBG3ScreenAB
        jmp     TfrBG3ScreenCD

; ------------------------------------------------------------------------------

; [  ]

_c35d83:
@5d83:  jsr     DrawStatusTopLabelText
        jsr     DrawStatusCharInfo
        jsr     ChangeStatusPortraitTask
        ldy     #$0000
        sty     $14
        ldy     #$3849
        sty     $16
        ldy     #$0800
        sty     $12
        ldy     #$4000
        sty     $1b
        ldy     #$7849
        sty     $1d
        ldy     #$0800
        sty     $19
        jsr     ExecTasks
        jsr     WaitVblank
        ldy     $00
        sty     $1b
        ldy     #$4800
        sty     $14
        ldy     #$8849
        sty     $16
        jmp     WaitVblank

; ------------------------------------------------------------------------------

; [  ]

DrawStatusGogoWindow:
@5dc1:  ldx     #$9e09
        stx     hWMADDL
        clr_ax
@5dc9:  phx
        longa
        txa
        asl
        tax
        lda     $1edc
        and     f:CharEquipMaskTbl,x
        beq     @5dfb
        longa
        lda     f:CharPropPtrs,x   ; pointers to character data
        tax
        shorta
        lda     a:$0016,x
        sta     hWMDATA
        lda     a:$0017,x
        sta     hWMDATA
        lda     a:$0018,x
        sta     hWMDATA
        lda     a:$0019,x
        sta     hWMDATA
        bra     @5e0b
@5dfb:  shorta
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
@5e0b:  plx
        inx
        cpx     #$0010
        bne     @5dc9

; remove duplicate battle commands
        clr_ax
@5e14:  phx
        lda     $7e9e09,x
@5e19:  cmp     $7e9e0a,x
        bne     @5e27
        pha
        lda     #$ff
        sta     $7e9e0a,x
        pla
@5e27:  inx
        cpx     #$0040
        bne     @5e19
        plx
        inx
        cpx     #$0040
        bne     @5e14
        ldx     #$9d8a
        stx     hWMADDL
        lda     #$ff
        sta     hWMDATA
        clr_axy
@5e42:  clr_a
        phx
        lda     $7e9e09,x
        bmi     @5e60
        cmp     #$12
        beq     @5e60
        sta     $e0
        asl
        tax
        lda     $cffe00,x   ; battle command data
        and     #$01
        beq     @5e60       ; branch if command can't be used by gogo
        lda     $e0
        sta     hWMDATA
        iny
@5e60:  plx
        inx
        cpx     #$0040
        bne     @5e42
        iny
        tya
        sta     $7e9d89
        ldx     #$aa8d
        stx     hWMADDL
        clr_ax
@5e75:  lda     f:_c35f85,x
        sta     hWMDATA
        inx
        cpx     #$0008
        bne     @5e75
        tya
        sta     $e2
        clc
        adc     $e2
        adc     $e2
        and     #$fe
        beq     @5e90
        inc2
@5e90:  lsr
        sta     $7eaa90
        sta     $7eaa94
        ldy     #$aa8d
        lda     #$7e
        sta     $e9
        jsr     DrawWindowFar
        ldy     #$aa91
        lda     #$7e
        sta     $e9
        jsr     DrawWindowFar
        lda     $7e9d89
        sta     $e5
        stz     $e6
        clr_ax
        ldy     #$80c9
@5eba:  phx
        phy
        lda     $7e9d8a,x
        jsr     _c35ed7
        ply
        longa
        tya
        clc
        adc     #$0080
        tay
        shorta
        plx
        inx
        cpx     $e5
        bne     @5eba
        jmp     _5f50

; ------------------------------------------------------------------------------

; [  ]

_c35ed7:
@5ed7:  pha
        jsr     InitTextBuf
        pla
        bmi     _5f0c
        jmp     _5ee6

; ------------------------------------------------------------------------------

; [ draw battle command names ]

_c35ee1:
@5ee1:  jsr     _c3612c
        bmi     _5f0c

_5ee6:
@5ee6:  jsr     _c35f25
        sta     $e2
        pha
        asl2
        sta     $e0
        pla
        asl
        clc
        adc     $e0
        adc     $e2
        tax
        ldy     #$0007
@5efb:  lda     $d8cea0,x   ; battle command names
        sta     hWMDATA
        inx
        dey
        bne     @5efb
_5f06:  stz     hWMDATA
        jmp     DrawPosTextBuf

_5f0c:  lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        bra     _5f06

; ------------------------------------------------------------------------------

; [  ]

_c35f25:
@5f25:  pha
        cmp     #$0b
        beq     @5f3a
        cmp     #$07
        beq     @5f44
@5f2e:  lda     #$20
        sta     $29
        pla
        rts
@5f34:  lda     #$24
        sta     $29
        pla
        rts
@5f3a:  lda     $11da
        ora     $11db
        bpl     @5f34
        bra     @5f2e
@5f44:  lda     $11da
        ora     $11db
        bit     #$02
        beq     @5f34
        bra     @5f2e
_5f50:  ldx     #$61ca
        stx     $e7
        lda     #$7e
        sta     $e9
        ldx     #$0006
@5f5c:  clr_ay
        lda     #$3d
@5f60:  sta     [$e7],y
        iny2
        cpy     #$0012
        bne     @5f60
        longa
        lda     $e7
        clc
        adc     #$0040
        sta     $e7
        shorta
        dex
        bne     @5f5c
        rts

; ------------------------------------------------------------------------------

; status menu windows
_c35f79:
@5f79:  .byte   $8b,$58,$06,$01

_c35f7d:
@5f7d:  .byte   $eb,$5a,$09,$06

_c35f81:
@5f81:  .byte   $8b,$58,$1c,$18

_c35f85:
@5f85:  .byte   $c7,$58,$00,$12

_c35f89:
@5f89:  .byte   $87,$60,$07,$12

; ------------------------------------------------------------------------------

; [ draw character info on status menu (white text) ]

DrawStatusCharInfo:
@5f8d:  clr_a
        lda     $28
        asl
        tax
        jmp     (.loword(DrawStatusCharInfoTbl),x)

DrawStatusCharInfoTbl:
@5f95:  .addr   DrawStatusCharInfo1
        .addr   DrawStatusCharInfo2
        .addr   DrawStatusCharInfo3
        .addr   DrawStatusCharInfo4

; ------------------------------------------------------------------------------

; [ draw status info for character slot 1 ]

DrawStatusCharInfo1:
@5f9d:  ldx     $6d
        stx     $67
        clr_a
        lda     $69
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 2 ]

DrawStatusCharInfo2:
@5fa7:  ldx     $6f
        stx     $67
        clr_a
        lda     $6a
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 3 ]

DrawStatusCharInfo3:
@5fb1:  ldx     $71
        stx     $67
        clr_a
        lda     $6b
        jmp     DrawStatusCharInfoAll

; ------------------------------------------------------------------------------

; [ draw status info for character slot 4 ]

DrawStatusCharInfo4:
@5fbb:  ldx     $73
        stx     $67
        clr_a
        lda     $6c
; fallthrough

DrawStatusCharInfoAll:
@5fc2:  jsl     UpdateEquip_ext
        ldy     $67
        jsr     CheckHandEffects
        lda     #$20
        sta     $29
        lda     $11a6
        jsr     HexToDec3
        ldx     #$7ee1
        jsr     DrawNum3
        lda     $11a4
        jsr     HexToDec3
        ldx     #$7f61
        jsr     DrawNum3
        lda     $11a2
        jsr     HexToDec3
        ldx     #$7fe1
        jsr     DrawNum3
        lda     $11a0
        jsr     HexToDec3
        ldx     #$8861
        jsr     DrawNum3
        jsr     _c39371
        lda     $11ac
        clc
        adc     $11ad
        sta     $f3
        clr_a
        adc     #0
        sta     $f4
        jsr     HexToDec5
        ldx     #$7e7d
        jsr     Draw16BitNum
        lda     $11ba
        jsr     HexToDec3
        ldx     #$7efd
        jsr     DrawNum3
        lda     $11a8
        jsr     HexToDec3
        ldx     #$7f7d
        jsr     DrawNum3
        lda     $11bb
        jsr     HexToDec3
        ldx     #$7ffd
        jsr     DrawNum3
        lda     $11aa
        jsr     HexToDec3
        ldx     #$887d
        jsr     DrawNum3
        ldy     #$398f
        jsr     DrawCharName
        ldy     #$399d
        jsr     DrawCharTitle
        ldy     #$39b1
        jsr     DrawEquipGenju
        jsr     _c36102
        lda     #$20
        sta     $29
        ldx     #.loword(_c36096)
        jsr     DrawCharBlock
        ldx     $67
        lda     a:$0011,x
        sta     $f1
        lda     a:$0012,x
        sta     $f2
        lda     a:$0013,x
        sta     $f3
        jsr     HexToDec8
        ldx     #$7cd7
        jsr     DrawNum8
        jsr     _c360a0
        jsr     HexToDec8
        ldx     #$7dd7
        jsr     DrawNum8
        stz     $47
        jsr     ExecTasks
        jmp     _c3625b

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (status)
_c36096:
@6096:  .word   $3a27,$3a63,$3a6d,$3aa3,$3aad

; ------------------------------------------------------------------------------

; [  ]

_c360a0:
@60a0:  ldx     $67
        clr_a
        lda     a:$0008,x
        cmp     #$63
        beq     @60c3
        jsr     _c360ca
        ldx     $67
        sec
        lda     $f1
        sbc     a:$0011,x
        sta     $f1
        longa
        lda     $f2
        sbc     a:$0012,x
        sta     $f2
        shorta
        rts
@60c3:  clr_ax
        stx     $f1
        stz     $f3
        rts

; ------------------------------------------------------------------------------

; [  ]

_c360ca:
@60ca:  asl
        sta     $eb
        clr_ax
        stx     $f1
        stx     $f3
        stz     $ec
@60d5:  clc
        lda     f:LevelUpExp,x   ; experience progression data
        adc     $f1
        sta     $f1
        inx
        lda     f:LevelUpExp,x
        adc     $f2
        sta     $f2
        clr_a
        adc     $f3
        sta     $f3
        inx
        cpx     $eb
        bne     @60d5
        longa
        asl     $f1
        rol     $f3
        asl     $f1
        rol     $f3
        asl     $f1
        rol     $f3
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c36102:
@6102:  ldy     #$7bf1
        jsr     InitTextBuf
        jsr     _c35ee1
        ldy     #$7c71
        jsr     InitTextBuf
        iny
        jsr     _c35ee1
        ldy     #$7cf1
        jsr     InitTextBuf
        iny2
        jsr     _c35ee1
        ldy     #$7d71
        jsr     InitTextBuf
        iny3
        jmp     _c35ee1

; ------------------------------------------------------------------------------

; [  ]

_c3612c:
@612c:  lda     $0016,y     ; battle command
        cmp     #$02        ; command $02 (magic)
        bne     @613e
        phy
        jsr     CheckMPVisible
        bcs     @613d
        ply
        lda     #$ff
        rts
@613d:  ply
@613e:  lda     $0016,y
        cmp     #$03        ; command $03 (morph)
        bne     @614f
        lda     $1dd1
        bit     #$04
        bne     @614f
        lda     #$ff
        rts
@614f:  lda     $0016,y
        cmp     #$11        ; command $11 (leap)
        bne     @6160
        lda     $11e4
        bit     #$04
        bne     @6160
        lda     #$ff
        rts
@6160:  lda     $0016,y
        cmp     #$13        ; command $13 (dance)
        bne     @616f
        lda     $1d4c
        bne     @616f
        lda     #$ff
        rts
@616f:  lda     $0016,y
        sta     $e0
        clr_ax
        lda     $11d6       ; relic effects 2 (modified commands)
        and     #$7c
        asl
@617c:  asl
        bcc     @6189
        pha
        lda     f:RelicCmdTbl1,x
        cmp     $e0
        beq     @6192
        pla
@6189:  inx
        cpx     #5
        bne     @617c
        lda     $e0
        rts
@6192:  pla
        lda     f:RelicCmdTbl2,x
        rts

; ------------------------------------------------------------------------------

; base commands (steal, slot, sketch, magic, fight)
RelicCmdTbl1:
@6198:  .byte   $05,$0f,$0d,$02,$00

; relic-modified commands (capture, gp rain, control, x-magic, jump)
RelicCmdTbl2:
@619d:  .byte   $06,$18,$0e,$17,$16

; ------------------------------------------------------------------------------

; [ create portrait task for sub-menus ]

ChangeStatusPortraitTask:
@61a2:  clr_a
        lda     $60
        tax
        lda     #$ff
        sta     $7e35c9,x

CreateSubPortraitTask:
@61ac:  jsr     CreateOnePortraitTask
        jmp     InitSubPortraitTask

; ------------------------------------------------------------------------------

; [ create portrait task for equip/relic menu ]

CreateEquipPortraitTask:
@61b2:  jsr     CreateOnePortraitTask
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     #$00c8                  ; x position
        sta     $33ca,x
        shorta
        clr_a
        lda     $28
        tay
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0030                  ; y position
        sta     $344a,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create single portrait task ]

CreateOnePortraitTask:
@61da:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        txa
        sta     $60
        rts

; ------------------------------------------------------------------------------

; [ init sub-menu portrait task ]

InitSubPortraitTask:
@61e6:  phb
        lda     #$7e
        pha
        plb
        clr_a
        lda     $28
        tay
        jsr     InitPortraitRowPos
        clr_a
        lda     $28
        tay
        jsr     SetSubPortraitPos
        plb
        rts

; ------------------------------------------------------------------------------

; [ set sub-menu portrait position ]

SetSubPortraitPos:
@61fb:  jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0038                  ; y position
        sta     $344a,x
        shorta
        jmp     InitAnimTask

; ------------------------------------------------------------------------------

; [ init bg3 scroll hdma data for status menu ]

InitStatusBG3ScrollHDMA:
@620b:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(StatusBG3ScrollHDMA)
        sty     $4352
        lda     #^StatusBG3ScrollHDMA
        sta     $4354
        lda     #^StatusBG3ScrollHDMA
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; hdma data for status menu
StatusBG3ScrollHDMA:
@622a:  .byte   $27,$00,$00
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

; [  ]

_c3625b:
@625b:  ldy     #$399d
        ldx     #$2050
        stx     $e7
        jsr     InitTextBuf
        lda     $0014,y
        bmi     @62e7
        and     #$70
        sta     $e1
        lda     $0014,y
        and     #$07
        asl
        sta     $e2
        lda     $0015,y
        and     #$80
        ora     $e1
        ora     $e2
        sta     $e1
        beq     @62e1
        stz     $f1
        stz     $f2
        ldx     #$0007
@628b:  phx
        asl
        bcc     @62d5
        pha
        lda     #3
        ldy     #.loword(CharIconTask)
        jsr     CreateTask
        lda     #$01
        sta     $7e364a,x
        clr_a
        sta     $7e3649,x
        txy
        ldx     $f1
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:StatusIconAnimPtrs,x   ; pointers to status icon sprite data
        sta     $32c9,y
        shorta
        lda     $e7
        sta     $33ca,y
        lda     $e8
        sta     $344a,y
        clr_a
        sta     $33cb,y
        sta     $344b,y
        lda     #^StatusIconAnimPtrs
        sta     $35ca,y
        plb
        clc
        lda     #$0a
        adc     $e7
        sta     $e7
        pla
@62d5:  inc     $f1
        inc     $f1
        plx
        dex
        bne     @628b
        lda     #$20
        sta     $29
@62e1:  jsr     _c36306
        jmp     DrawPosTextBuf
@62e7:  ldx     #$9e8b
        stx     hWMADDL
        ldx     $00
@62ef:  lda     f:MainMenuWoundedText,x
        sta     hWMDATA
        inx
        cpx     #$0008
        bne     @62ef
        stz     hWMDATA
        lda     #$28
        sta     $29
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c36306:
@6306:  ldx     #$9e8b
        stx     hWMADDL
        ldx     $00
        lda     #$ff
@6310:  sta     hWMDATA
        inx
        cpx     #$0008
        bne     @6310
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ menu state $42:  ]

MenuState_42:
@631d:  jsr     DisableInterrupts
        lda     $0200
        sta     $22
        stz     $0200
        stz     $25
        lda     #$40
        trb     $43
        jsr     InitStatusBG3ScrollHDMA
        jsr     _c36354
        lda     #$01
        sta     $26
        lda     #$43
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $43:  ]

MenuState_43:
@633f:  lda     $09
        bit     #$80
        beq     @6353
        jsr     PlayCancelSfx
        lda     $4c
        sta     $27
        stz     $26
        lda     $22
        sta     $0200
@6353:  rts

; ------------------------------------------------------------------------------

; [  ]

_c36354:
@6354:  jsr     DrawStatusMainWindow
        jsr     DrawStatusLabelText
        jsr     _c36379
        jsr     DrawStatusCharInfoAll
        jsr     TfrStatusMenu
        jsr     CreateOnePortraitTask
        phb
        lda     #$7e
        pha
        plb
        clr_a
        lda     $28
        tay
        jsr     _c3638e
        clr_ay
        jsr     SetSubPortraitPos
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c36379:
@6379:  clr_a
        lda     $c9
        sta     $28
        asl
        tax
        longa
        lda     f:CharPropPtrs,x   ; pointers to character data
        sta     $67
        shorta
        clr_a
        lda     $c9
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3638e:
@638e:  lda     $1850,y
        bit     #$20
        beq     @639c
        longa
        lda     #$001a
        bra     @63a1
@639c:  longa
        lda     #$000e
@63a1:  sta     $33ca,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ menu state $6a:  ]

MenuState_6a:
@63a7:  jsr     UpdateGogoCmdListCursor
        lda     $08
        bit     #$80
        beq     @63da
        jsr     PlaySelectSfx
        stz     a:$0065
        clr_a
        lda     $4b
        tax
        lda     $7e9d8a,x
        sta     $e0
        clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        longa
        tya
        clc
        adc     $64
        tay
        shorta
        lda     $e0
        sta     $0016,y
        jsr     _c36102
        bra     @63e3
@63da:  lda     $09
        bit     #$80
        beq     @6402
        jsr     PlayCancelSfx
@63e3:  lda     #$01
        trb     $46
        lda     #$06
        sta     $20
        ldy     #$fff4
        sty     $9c
        lda     #$0c
        sta     $27
        lda     #$65
        sta     $26
        jsr     LoadGogoStatusCursor
        lda     $5e
        sta     $4e
        jsr     InitGogoStatusCursor
@6402:  rts

; ------------------------------------------------------------------------------

; [ load cursor for gogo command list select ]

LoadGogoCmdListCursor:
@6403:  ldy     #.loword(GogoCmdListProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor positions for gogo command list select ]

UpdateGogoCmdListCursor:
@6409:  jsr     MoveCursor

InitGogoCmdListCursor:
@640c:  ldy     #.loword(GogoCmdListPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GogoCmdListProp:
@6412:  .byte   $80,$00,$00,$01,$10

GogoCmdListPos:
@6417:  .word   $10f0,$1cf0,$28f0,$34f0,$40f0,$4cf0,$58f0,$64f0
        .word   $70f0,$7cf0,$88f0,$94f0,$a0f0,$acf0,$b8f0,$c4f0

; ------------------------------------------------------------------------------

StatusBtmLabelTextList1:
@6437:  .addr   StatusStrengthText
        .addr   StatusStaminaText
        .addr   StatusMagPwrText
        .addr   StatusEvadeText
        .addr   StatusMagEvadeText
        .addr   StatusStrengthSepText
        .addr   StatusSpeedSepText
        .addr   StatusStaminaSepText
        .addr   StatusMagPwrSepText
        .addr   StatusDefenseSepText
        .addr   StatusEvadeSepText
        .addr   StatusAttackPwrSepText
        .addr   StatusMagDefSepText
        .addr   StatusMagEvadeSepText
        .addr   StatusTitleText

StatusTopLabelTextList2:
@6455:  .addr   StatusLevelText
        .addr   StatusHPText
        .addr   StatusMPText

StatusTopLabelTextList1:
@645b:  .addr   StatusHPSlashText
        .addr   StatusMPSlashText
        .addr   StatusEvadePercentText
        .addr   StatusMagEvadePercentText

StatusBtmLabelTextList2:
@6463:  .addr   StatusSpeedText
        .addr   StatusAttackPwrText
        .addr   StatusDefenseText
        .addr   StatusMagDefText
        .addr   StatusYourExpText
        .addr   StatusLevelUpExpText

; "Status"
StatusTitleText:
@646f:  .byte   $cd,$78,$92,$ad,$9a,$ad,$ae,$ac,$00

; "/"
StatusHPSlashText:
@6478:  .byte   $6b,$3a,$c0,$00

; "/"
StatusMPSlashText:
@647c:  .byte   $ab,$3a,$c0,$00

; "%"
StatusEvadePercentText:
@6480:  .byte   $83,$7f,$cd,$00

; "%"
StatusMagEvadePercentText:
@6484:  .byte   $83,$88,$cd,$00

; "LV"
StatusLevelText:
@6488:  .byte   $1d,$3a,$8b,$95,$00

; "HP"
StatusHPText:
@648d:  .byte   $5d,$3a,$87,$8f,$00

; "MP"
StatusMPText:
@6492:  .byte   $9d,$3a,$8c,$8f,$00

; "Vigor"
StatusStrengthText:
@6497:  .byte   $cf,$7e,$95,$a2,$a0,$a8,$ab,$00

; "Stamina"
StatusStaminaText:
@649f:  .byte   $cf,$7f,$92,$ad,$9a,$a6,$a2,$a7,$9a,$00

; "Mag.Pwr"
StatusMagPwrText:
@64a9:  .byte   $4f,$88,$8c,$9a,$a0,$c5,$8f,$b0,$ab,$00

; "Evade %"
StatusEvadeText:
@64b3:  .byte   $69,$7f,$84,$af,$9a,$9d,$9e,$ff,$cd,$00

; "MBlock%"
StatusMagEvadeText:
@64bd:  .byte   $69,$88,$8c,$81,$a5,$a8,$9c,$a4,$cd,$00

; ".."
StatusStrengthSepText:
@64c7:  .byte   $dd,$7e,$d3,$00

StatusSpeedSepText:
@64cb:  .byte   $5d,$7f,$d3,$00

StatusStaminaSepText:
@64cf:  .byte   $dd,$7f,$d3,$00

StatusMagPwrSepText:
@64d3:  .byte   $5d,$88,$d3,$00

StatusDefenseSepText:
@64d7:  .byte   $fb,$7e,$d3,$00

StatusEvadeSepText:
@64db:  .byte   $7b,$7f,$d3,$00

StatusAttackPwrSepText:
@64df:  .byte   $7b,$7e,$d3,$00

StatusMagDefSepText:
@64e3:  .byte   $fb,$7f,$d3,$00

StatusMagEvadeSepText:
@64e7:  .byte   $7b,$88,$d3,$00

StatusSpeedText:
@64eb:  .byte   $4f,$7f,$92,$a9,$9e,$9e,$9d,$00

StatusAttackPwrText:
@64f3:  .byte   $69,$7e,$81,$9a,$ad,$c5,$8f,$b0,$ab,$00

StatusDefenseText:
@64fd:  .byte   $e9,$7e,$83,$9e,$9f,$9e,$a7,$ac,$9e,$00

StatusMagDefText:
@6507:  .byte   $e9,$7f,$8c,$9a,$a0,$c5,$83,$9e,$9f,$00

StatusYourExpText:
@6511:  .byte   $4d,$7c,$98,$a8,$ae,$ab,$ff,$84,$b1,$a9,$c1,$00

StatusLevelUpExpText:
@651d:  .byte   $4d,$7d,$85,$a8,$ab,$ff,$a5,$9e,$af,$9e,$a5,$ff,$ae,$a9,$c1,$00

; ------------------------------------------------------------------------------

; [ menu state $5d: name change (init) ]

MenuState_5d:
@652d:  jsr     DisableInterrupts
        ldy     $0201                   ; character id
        sty     $67
        jsr     ClearBGScroll
        lda     #$02
        sta     $46
        stz     $4a
        jsr     LoadNameChangeCursor
        jsr     InitNameChangeCursor
        jsr     CreateCursorTask
        jsr     DrawNameChangeMenu
        jsr     InitNameChangeArrowPos
        jsr     InitNameChangeScrollHDMA
        jsr     LoadNameChangePortraitPal
        jsr     LoadNameChangePortraitGfx
        jsr     CreateNameChangePortraitTask
        lda     #2
        ldy     #.loword(NameChangeArrowTask)
        jsr     CreateTask
        lda     #$5f                    ; go to menu state $5f after fade in
        sta     $27
        lda     #$01                    ; fade in
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $5f: name change menu ]

MenuState_5f:
@656c:  jsr     InitBG1TilesDMA1
        jsr     UpdateNameChangeCursor
        jsr     DrawNameChangeName
        lda     $09
        bit     #$10
        beq     @657e
        jmp     @65c2                   ; jump if start button is pressed

; A button
@657e:  lda     $08
        bit     #$80
        beq     @6595                   ; branch if A button is not pressed
        jsr     PlaySelectSfx
        clr_a
        jsr     ChangeNameLetter
        lda     $28
        cmp     #5
        beq     @6592
        inc
@6592:  sta     $28
        rts

; B button
@6595:  lda     $09
        bit     #$80
        beq     @65c1                   ; return if B button is not pressed
        jsr     PlayEraseSfx
        lda     $28
        beq     @65c1
        cmp     #5
        bne     @65b5
        jsr     _c3660f
        lda     $0002,y
        cmp     #$ff
        beq     @65b5
        lda     #$ff
        jmp     ChangeNameLetter
@65b5:  lda     #$01
        jsr     ChangeNameLetter
        lda     $28
        beq     @65bf
        dec
@65bf:  sta     $28
@65c1:  rts

; start
@65c2:  ldy     $67
        ldx     $00
@65c6:  lda     $0002,y               ; make sure name is not blank
        cmp     #$ff
        bne     @65db
        iny
        inx
        cpx     #6
        bne     @65c6
        jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; exit menu
@65db:  jsr     PlaySelectSfx
        stz     $0205
        lda     #$ff
        sta     $27
        stz     $26
        rts

; ------------------------------------------------------------------------------

MenuState_60:
MenuState_61:
.if !LANG_EN

.endif

; ------------------------------------------------------------------------------

; [ add/remove letter from character name ]

ChangeNameLetter:
@65e8:  pha
        jsr     _c3660f
        pla
        bmi     @65fa
        beq     @6600
        lda     #$ff
        sta     $0002,y
        sta     $0001,y
        rts
@65fa:  lda     #$ff
        sta     $0002,y
        rts
@6600:  clr_a
        lda     $4b
        clc
        adc     $4a
        tax
        lda     f:NameChangeLetters,x   ; letters for name change menu
        sta     $0002,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3660f:
@660f:  ldy     $67
        lda     $28
        sta     $e7
        stz     $e8
        longa
        tya
        clc
        adc     $e7
        tay
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init arrow position for name change menu ]

InitNameChangeArrowPos:
@6621:  ldy     $67
        ldx     $00
@6625:  lda     $0002,y
        cmp     #$ff
        beq     @6634
        iny
        inx
        cpx     #6
        bne     @6625
        dex
@6634:  txa
        sta     $28
        rts

; ------------------------------------------------------------------------------

; [ init name change cursor ]

LoadNameChangeCursor:
@6638:  ldy     #.loword(NameChangeCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update name change cursor ]

UpdateNameChangeCursor:
@663e:  jsr     MoveCursor

InitNameChangeCursor:
@6641:  ldy     #.loword(NameChangeCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

NameChangeCursorProp:
@6647:  .byte   $01,$00,$00,$0a,$07

NameChangeCursorPos:
@664c:  .byte   $38,$58,$48,$58,$58,$58,$68,$58,$78,$58
        .byte   $90,$58,$a0,$58,$b0,$58,$c0,$58,$d0,$58
        .byte   $38,$68,$48,$68,$58,$68,$68,$68,$78,$68
        .byte   $90,$68,$a0,$68,$b0,$68,$c0,$68,$d0,$68
        .byte   $38,$78,$48,$78,$58,$78,$68,$78,$78,$78
        .byte   $90,$78,$a0,$78,$b0,$78,$c0,$78,$d0,$78
        .byte   $38,$88,$48,$88,$58,$88,$68,$88,$78,$88
        .byte   $90,$88,$a0,$88,$b0,$88,$c0,$88,$d0,$88
        .byte   $38,$98,$48,$98,$58,$98,$68,$98,$78,$98
        .byte   $90,$98,$a0,$98,$b0,$98,$c0,$98,$d0,$98
        .byte   $38,$a8,$48,$a8,$58,$a8,$68,$a8,$78,$a8
        .byte   $90,$a8,$a0,$a8,$b0,$a8,$c0,$a8,$d0,$a8
        .byte   $38,$b8,$48,$b8,$58,$b8,$68,$b8,$78,$b8
        .byte   $90,$b8,$a0,$b8,$b0,$b8,$c0,$b8,$d0,$b8

; ------------------------------------------------------------------------------

; [ create portrait task for name change menu ]

CreateNameChangePortraitTask:
@66d8:  lda     #3
        ldy     #.loword(PortraitTask)
        jsr     CreateTask
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     #.loword(Portrait1AnimData)
        sta     $32c9,x
        lda     #$0010
        sta     $33ca,x
        lda     #$0010
        sta     $344a,x
        shorta
        lda     #^Portrait1AnimData
        sta     $35ca,x
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ draw menu for name change ]

DrawNameChangeMenu:
@6705:  jsr     ClearBG2ScreenA
        ldy     #.loword(NameChangeAlphabetWindow)
        jsr     DrawWindow
        ldy     #.loword(NameChangePortraitWindow)
        jsr     DrawWindow
        ldy     #.loword(NameChangeMsgWindow)
        jsr     DrawWindow
        ldy     #.loword(NameChangeNameWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     ClearBG1ScreenC
        lda     #$20                    ; white text
        sta     $29
        ldx     #$395b
        ldy     #.loword(NameChangeLetters)
        sty     $e7
        lda     #^NameChangeLetters
        sta     $e9
        lda     #7                      ; 7 rows
        sta     $e5
        jsr     DrawNameChangeAlphabet
        jsr     DrawNameChangeName
        ldy     #.loword(NameChangeMsgText)
        jsr     DrawPosText
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     TfrBG1ScreenCD
        jsr     ClearBG3ScreenA
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ draw character name for name change menu ]

DrawNameChangeName:
@675b:  ldy     #$4229
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; name change menu windows
NameChangeNameWindow:
@6761:  .byte   $9b,$59,$12,$02

NameChangeAlphabetWindow:
@6765:  .byte   $57,$5a,$16,$11

NameChangePortraitWindow:
@6769:  .byte   $8b,$58,$05,$05

NameChangeMsgWindow:
@676d:  .byte   $99,$58,$14,$02

; ------------------------------------------------------------------------------

; [ load portrait graphics for name change menu ]

LoadNameChangePortraitGfx:
@6771:  ldy     $67
        clr_a
        lda     $0001,y
        longa
        asl
        tax
        lda     #$2600
        sta     hVMADDL
        lda     f:PortraitGfxPtrs,x
        tax
        jsr     TfrPortraitGfx
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load portrait palette for name change menu ]

LoadNameChangePortraitPal:
@678c:  lda     #$10
        sta     $e3
        ldy     $67
        clr_a
        lda     $0001,y
        tax
        lda     f:CharPortraitPalTbl,x
        longa
        asl5
        tax
        ldy     $00
@67a5:  longa
        phx
        lda     f:PortraitPal,x
        tyx
        sta     $7e3149,x
        shorta
        plx
        inx2
        iny2
        dec     $e3
        bne     @67a5
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw alphabet for name change menu ]

DrawNameChangeAlphabet:
@67bf:  stx     $eb
        lda     #$7e
        sta     $ed
        ldy     $00
@67c7:  lda     #10                     ; 10 columns
        sta     $e6
        ldx     $00
@67cd:  lda     [$e7],y
        sta     $e0
        phy
        cmp     #$53
        bcc     @67dc
        lda     #$ff
        sta     $e1
        bra     @67fc
@67dc:  cmp     #$49
        bcc     @67ed
        lda     #$52
        sta     $e1
        lda     $e0
        clc
        adc     #$17
        sta     $e0
        bra     @67fc
@67ed:  cmp     #$20
        bcc     @67fc
        lda     #$51
        sta     $e1
        lda     $e0
        clc
        adc     #$40
        sta     $e0
@67fc:  txy
        lda     $e1
        sta     [$eb],y
        iny
        lda     $29
        sta     [$eb],y
        longa
        txa
        clc
        adc     #$0040
        tay
        shorta
        lda     $e0
        sta     [$eb],y
        iny
        lda     $29
        sta     [$eb],y
        inx4
        ply
        iny
        lda     $e6
        cmp     #$06
        bne     @6827
        inx2
@6827:  dec     $e6
        bne     @67cd
        longa
        lda     $eb
        clc
        adc     #$0080
        sta     $eb
        shorta
        dec     $e5
        bne     @67c7
        rts

; ------------------------------------------------------------------------------

; [ in bg1 scroll hdma data tables for name change menu ]

InitNameChangeScrollHDMA:
@683c:  ldx     $00

; init vertical scroll HDMA
@683e:  lda     f:NameChangeVScrollHDMATbl,x
        sta     $7e9bc9,x               ; copy HDMA table to RAM
        inx
        cpx     #$000d
        bne     @683e
        lda     #$02
        sta     $4350
        lda     #<hBG1VOFS
        sta     $4351
        ldy     #$9bc9
        sty     $4352
        lda     #$7e
        sta     $4354
        lda     #$7e
        sta     $4357
        lda     #$20
        tsb     $43

; init horizontal scroll HDMA
        lda     #$02
        sta     $4360
        lda     #<hBG1HOFS
        sta     $4361
        ldy     #.loword(NameChangeHScrollHDMATbl)
        sty     $4362
        lda     #^NameChangeHScrollHDMATbl
        sta     $4364
        lda     #^NameChangeHScrollHDMATbl
        sta     $4367
        lda     #$40
        tsb     $43
        rts

; ------------------------------------------------------------------------------

NameChangeHScrollHDMATbl:
@6889:  .byte   $47,$00,$01
        .byte   $50,$00,$00
        .byte   $50,$00,$00
        .byte   $10,$00,$01
        .byte   $00

NameChangeVScrollHDMATbl:
@6896:  .byte   $47,$00,$00
        .byte   $50,$d0,$ff
        .byte   $50,$d0,$ff
        .byte   $10,$00,$00
        .byte   $00

; ------------------------------------------------------------------------------

; [ task for name change position indicator ]

NameChangeArrowTask:
@68a3:  tax
        jmp     (.loword(NameChangeArrowTaskTbl),x)

NameChangeArrowTaskTbl:
@68a7:  .addr   NameChangeArrowTask_00
        .addr   NameChangeArrowTask_01

; ------------------------------------------------------------------------------

; [ init name change flashing arrow ]

NameChangeArrowTask_00:
@68ab:  ldx     $2d
        longa
        lda     #.loword(NameChangeArrowAnim)
        sta     $32c9,x
        lda     #$0040
        sta     $344a,x
        shorta
        stz     $33cb,x
        lda     #^NameChangeArrowAnim
        sta     $35ca,x
        jsr     InitAnimTask
        inc     $3649,x
; fallthrough

; [ update name change flashing arrow ]

NameChangeArrowTask_01:
@68cb:  ldy     $2d
        clr_a
        lda     $28
        tax
        lda     f:NameChangeArrowXTbl,x
        sta     $33ca,y
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

NameChangeArrowXTbl:
@68dd:  .byte   $78,$80,$88,$90,$98,$a0

; "Please enter a name…"
NameChangeMsgText:
@68e3:  .word   $411b
        .byte   $8f,$a5,$9e,$9a,$ac,$9e,$ff,$9e,$a7,$ad,$9e,$ab,$ff,$9a,$ff,$a7
        .byte   $9a,$a6,$9e,$c5,$00

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
@6b1d:  lda     f:FontGfxSmall,x   ; small font graphics
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
@6b5a:  lda     f:FontGfxSmall+$80,x
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
        longac
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

; [ menu state $2c: party select init ]

MenuState_2c:
@70e7:  jsr     _c370fc
        stz     $4a
        stz     $5a
        stz     $99
        jsr     _c3762a
        jsr     LoadPartyCharCursor
        jsr     InitPartyCharCursor
        jmp     _c37114

; ------------------------------------------------------------------------------

; [  ]

_c370fc:
@70fc:  jsr     DisableInterrupts
        jsr     ClearBGScroll
        lda     #$03
        sta     hBG1SC
        lda     #$c0
        trb     $43
        lda     #$02
        sta     $46
        lda     #$06
        tsb     $47
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37114:
@7114:  jsr     CreateCursorTask
        jsr     _c375c5
        jsr     DrawPartyMenu
        jsr     _c3793f
        jsr     _c37953
        jsr     InitBG1TilesLeftDMA1
        lda     #$2d
        sta     $27
        lda     #$66
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $7d:  ]

MenuState_7d:
@7131:  jsr     _c370fc
        lda     $5d
        sta     $99
        jsr     _c37677
        lda     $90
        bne     @714b
        jsr     LoadPartyCharCursor
        ldy     $8e
        sty     $4d
        jsr     InitPartyCharCursor
        bra     @7165
@714b:  lda     $90
        sta     $4a
        lda     $8d
        sta     $5a
        jsr     _c373db
        ldy     $8e
        sty     $4d
        lda     $79
        sta     $59
        ldy     $7a
        sty     $53
        jsr     UpdatePartyCursor
@7165:  jmp     _c37114

; ------------------------------------------------------------------------------

; [ menu state $2d:  ]

MenuState_2d:
@7168:  jsr     _c371b9
        bcc     @71b8
        lda     $08
        bit     #$80
        beq     @71a9
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7eac8d,x
        bmi     @71a2
        jsr     PlaySelectSfx
        lda     $4b
        sta     $28
        lda     $4a
        sta     $49
        lda     $5a
        sta     $5b
        lda     #$2e
        sta     $26
        jsr     _c32f21
        lda     $4a
        beq     @71a1
        lda     #$02
        sta     $7e3649,x
@71a1:  rts
@71a2:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts
@71a9:  lda     $09
        bit     #$10
        bne     @71b5
        lda     $09
        bit     #$80
        beq     @71b8
@71b5:  jsr     _c37296
@71b8:  rts

; ------------------------------------------------------------------------------

; [  ]

_c371b9:
@71b9:  jsr     _c375b8
        lda     $0b
        bit     #$04
        beq     @71de
        lda     $4e
        cmp     #$01
        bne     @71de
        lda     $4a
        bne     @71de
        lda     #$10
        sta     $4a
        lda     $99
        asl2
        sta     $5a
        jsr     _c373db
        jsr     PlayMoveSfx
        clc
        rts
@71de:  lda     $0b
        bit     #$08
        beq     @7206
        lda     $4e
        bne     @7206
        lda     $4a
        beq     @7206
        lda     $4d
        sta     $5e
        stz     $4a
        stz     $5a
        jsr     LoadPartyCharCursor
        lda     #$01
        sta     $4e
        jsr     _c3744c
        jsr     InitPartyCharCursor
        jsr     PlayMoveSfx
        clc
        rts
@7206:  jsr     UpdatePartyCursor
        sec
        rts

; ------------------------------------------------------------------------------

; [ menu state $2e: party select (move) ]

_720b:  rts

MenuState_2e:
@720c:  jsr     _c371b9
        bcc     _720b
        lda     $08
        bit     #$80
        beq     @727d
        clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        sta     $e0
        tax
        lda     $7eac8d,x
        bmi     @728f
        clr_a
        lda     $28
        clc
        adc     $49
        adc     $5b
        cmp     $e0
        bne     @7265
        lda     $e0
        tax
        lda     $7e9d89,x
        bmi     @7277
        jsr     PlaySelectSfx
        lda     $59
        sta     $79
        ldy     $53
        sty     $7a
        ldy     $4d
        sty     $8e
        lda     $4a
        sta     $90
        lda     $5a
        sta     $8d
        lda     $99
        sta     $5d
        lda     #$42
        sta     $27
        lda     #$67
        sta     $26
        lda     #$7d
        sta     $4c
        rts
@7265:  jsr     PlaySelectSfx
        lda     #$07
        trb     $47
        jsr     _c372f8
        jsr     ExecTasks
        jsr     _c37613
        bra     @7286
@7277:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@727d:  lda     $09
        bit     #$80
        beq     @728e
        jsr     PlayCancelSfx
@7286:  lda     #$2d
        sta     $26
        lda     #$05
        trb     $46
@728e:  rts
@728f:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37296:
@7296:  clr_ax
        lda     $0201       ; number of parties
        and     #$7f
        asl2
        sta     $f3
        stz     $f4
@72a3:  stz     $e0
        ldy     #$0004
@72a8:  lda     $7e9d99,x
        bmi     @72b0
        inc     $e0
@72b0:  inx
        dey
        bne     @72a8
        lda     $e0
        beq     @72cb
        cpx     $f3
        bne     @72a3
        jsr     PlayCancelSfx
        stz     $0205
        lda     #$ff
        sta     $27
        lda     #$67
        sta     $26
        rts
@72cb:  jsr     PlayInvalidSfx
        lda     #$20
        sta     $29
        lda     $0201
        and     #$07
        cmp     #1
        beq     @72e9                   ; branch if one party

; "You need # group(s)!"
        ldy     #.loword(PartyErrorMsg1)
        jsr     DrawPosText
        ldx     #$392f
        jsr     DrawNumParties
        bra     @72ef

; "No one there!"
@72e9:  ldy     #.loword(PartyErrorMsg2)
        jsr     DrawPosText
@72ef:  lda     #$20
        sta     $20
        lda     #$69
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c372f8:
@72f8:  clr_a
        lda     $28
        clc
        adc     $49
        adc     $5b
        tax
        lda     $7e9d89,x
        sta     $e5
        bpl     @7317
        lda     $7e9e51,x
        ora     f:_c373af,x
        sta     $e0
        stz     $e1
        bra     @7326
@7317:  tay
        lda     $1850,y
        and     #$df
        sta     $e0
        lda     $1850,y
        and     #$20
        sta     $e1
@7326:  lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7e9d89,x
        sta     $e6
        bpl     @7344
        lda     $7e9e51,x
        ora     f:_c373af,x
        sta     $e2
        stz     $e3
        bra     @7353
@7344:  tay
        lda     $1850,y
        and     #$df
        sta     $e2
        lda     $1850,y
        and     #$20
        sta     $e3
@7353:  lda     $e0
        and     #$40
        bne     @7361
@7359:  lda     $e2
        and     #$40
        bne     @737a
        bra     @7391
@7361:  clr_a
        lda     $28
        clc
        adc     $49
        adc     $5b
        tax
        lda     $7e9d89,x
        bmi     @7359
        tax
        lda     $e2
        ora     $e1
        sta     $1850,x
        bra     @7359
@737a:  clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7e9d89,x
        bmi     @7391
        tax
        lda     $e0
        ora     $e3
        sta     $1850,x
@7391:  clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $e5
        sta     $7e9d89,x
        lda     $28
        clc
        adc     $49
        adc     $5b
        tax
        lda     $e6
        sta     $7e9d89,x
        rts

; ------------------------------------------------------------------------------

_c373af:
@73af:  .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$48,$50,$58,$40,$48,$50,$58,$40,$48,$50,$58,$40,$48,$50,$58
        .byte   $40,$48,$50,$58,$40,$48,$50,$58,$40,$48,$50,$58

; ------------------------------------------------------------------------------

; [  ]

_c373db:
@73db:  lda     $4d
        sta     $5e
        lda     $0201       ; number of parties
        and     #$7f
        cmp     #1
        beq     @73f5
        cmp     #2
        beq     @7405

; three parties
        jsr     LoadThreePartyCursor
        jsr     _c37432
        jmp     InitThreePartyCursor

; one party
@73f5:  jsr     LoadOnePartyCursor
        lda     $5e
        cmp     #$01
        bcc     @7400
        lda     #$01
@7400:  sta     $4d
        jmp     InitOnePartyCursor

; two parties
@7405:  jsr     LoadTwoPartyCursor
        lda     $5e
        cmp     #$03
        bcc     @7410
        lda     #$03
@7410:  sta     $4d
        jmp     InitTwoPartyCursor

; ------------------------------------------------------------------------------

; [ update party menu cursor ]

UpdatePartyCursor:
@7415:  lda     $4a
        beq     @742f
        lda     $0201       ; number of parties
        and     #$7f
        cmp     #$01
        beq     @742c       ; branch if one
        cmp     #$02
        beq     @7429       ; branch if two
        jmp     UpdateThreePartyCursor
@7429:  jmp     UpdateTwoPartyCursor
@742c:  jmp     UpdateOnePartyCursor
@742f:  jmp     UpdatePartyCharCursor

; ------------------------------------------------------------------------------

; [  ]

_c37432:
@7432:  lda     $5e
        ldx     $00
@7436:  cmp     f:_c37466,x
        beq     @7444
        inx2
        cpx     #$0010
        bne     @7436
        rts
@7444:  inx
        lda     f:_c37466,x
        sta     $4d
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3744c:
@744c:  lda     $5e
        ldx     $00
@7450:  cmp     f:_c37476,x
        beq     @745e
        inx2
        cpx     #$000c
        bne     @7450
        rts
@745e:  inx
        lda     f:_c37476,x
        sta     $4d
        rts

; ------------------------------------------------------------------------------

_c37466:
@7466:  .byte   $00,$00,$01,$01,$02,$01,$03,$02,$04,$03,$05,$04,$06,$04,$07,$05

_c37476:
@7476:  .byte   $00,$00,$01,$01,$02,$03,$03,$04,$04,$06,$05,$07

; ------------------------------------------------------------------------------

; [ load character cursor for party select (lower area) ]

LoadPartyCharCursor:
@7482:  ldy     #.loword(PartyCharCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update character cursor for party select (lower area) ]

UpdatePartyCharCursor:
@7488:  jsr     MoveCursor

InitPartyCharCursor:
@748b:  ldy     #.loword(PartyCharCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; [ load cursor for party 1 area ]

LoadOnePartyCursor:
@7491:  ldy     #.loword(OnePartyCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for party 1 area ]

UpdateOnePartyCursor:
@7497:  jsr     MoveCursor

InitOnePartyCursor:
@749a:  ldy     #.loword(OnePartyCursorPos)
        jmp     UpdateHorzCursorPos

; ------------------------------------------------------------------------------

; [ load cursor for party 2 area ]

LoadTwoPartyCursor:
@74a0:  ldy     #.loword(TwoPartyCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for party 2 area ]

UpdateTwoPartyCursor:
@74a6:  jsr     MoveCursor

InitTwoPartyCursor:
@74a9:  ldy     #.loword(TwoPartyCursorPos)
        jmp     UpdateHorzCursorPos

; ------------------------------------------------------------------------------

; [ load cursor for party 3 area ]

LoadThreePartyCursor:
@74af:  ldy     #.loword(ThreePartyCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for party 3 area ]

UpdateThreePartyCursor:
@74b5:  jsr     MoveCursor

InitThreePartyCursor:
@74b8:  ldy     #.loword(ThreePartyCursorPos)
        jmp     UpdateHorzCursorPos

; ------------------------------------------------------------------------------

PartyCharCursorProp:
@74be:  .byte   $81,$00,$00,$08,$02

PartyCharCursorPos:
@74c3:  .byte   $08,$64,$24,$64,$40,$64,$5c,$64,$78,$64,$94,$64,$b0,$64,$cc,$64
        .byte   $08,$80,$24,$80,$40,$80,$5c,$80,$78,$80,$94,$80,$b0,$80,$cc,$80

; ------------------------------------------------------------------------------

OnePartyCursorProp:
@74e3:  .byte   $81,$00,$00,$02,$02

OnePartyCursorPos:
@74e8:  .byte   $08,$a4,$28,$a4
        .byte   $08,$c0,$28,$c0

; ------------------------------------------------------------------------------

TwoPartyCursorProp:
@74f0:  .byte   $81,$00,$00,$04,$02

TwoPartyCursorPos:
@74f5:  .byte   $08,$a4,$28,$a4,$58,$a4,$78,$a4
        .byte   $08,$c0,$28,$c0,$58,$c0,$78,$c0

; ------------------------------------------------------------------------------

ThreePartyCursorProp:
@7505:  .byte   $81,$00,$00,$06,$02

ThreePartyCursorPos:
@750a:  .byte   $08,$a4,$28,$a4,$58,$a4,$78,$a4
        .byte   $a8,$a4,$c8,$a4,$08,$c0,$28,$c0
        .byte   $58,$c0,$78,$c0,$a8,$c0,$c8,$c0

; ------------------------------------------------------------------------------

; [ draw menu for party character select ]

DrawPartyMenu:
@7522:  ldy     #.loword(PartyTopWindow)
        jsr     DrawWindow
        ldy     #.loword(PartyBtmWindow)
        jsr     DrawWindow
        ldy     #.loword(PartyMidWindow)
        jsr     DrawWindow
        ldy     #.loword(PartyMsgWindow)
        jsr     DrawWindow
        ldy     #.loword(PartyTitleWindow)
        jsr     DrawWindow
        jsr     DrawPartyWindows
        jsr     TfrBG2ScreenAB
        jsr     _c3755f
        jsr     TfrBG3ScreenAB
        jsr     ClearBG1ScreenA
        lda     #$24
        sta     $29
        ldy     #.loword(PartyTitleText)
        jsr     DrawPosText
        jsr     DrawPartyMsg
        jmp     TfrBG1ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c3755f:
@755f:  jmp     ClearBG3ScreenA

; ------------------------------------------------------------------------------

; [  ]

DrawPartyMsg:
@7562:  lda     #$20
        sta     $29
        ldy     #.loword(PartyMsgText)
        jsr     DrawPosText
        ldx     #$3927
        jmp     DrawNumParties

; ------------------------------------------------------------------------------

; [ draw party windows ]

DrawPartyWindows:
@7572:  clr_a
        lda     $0201                   ; number of parties
        and     #$7f
        asl
        tax
        jmp     (.loword(DrawPartyWindowsTbl),x)

DrawPartyWindowsTbl:
@757d:  .addr   0
        .addr   DrawOnePartyWindows
        .addr   DrawTwoPartyWindows
        .addr   DrawThreePartyWindows

; ------------------------------------------------------------------------------

; [ draw one, two, and three party windows ]

DrawThreePartyWindows:
@7585:  ldy     #.loword(Party3Window)
        jsr     DrawWindow

DrawTwoPartyWindows:
@758b:  ldy     #.loword(Party2Window)
        jsr     DrawWindow

DrawOnePartyWindows:
@7591:  ldy     #.loword(Party1Window)
        jsr     DrawWindow
        rts

; ------------------------------------------------------------------------------

; window data for party select menu
PartyTitleWindow:
@7598:  .byte   $8b,$58,$06,$02

PartyBtmWindow:
@759c:  .byte   $cb,$5c,$1c,$07

PartyTopWindow:
@75a0:  .byte   $8b,$59,$1c,$05

PartyMidWindow:
@75a4:  .byte   $0b,$5b,$1c,$06

PartyMsgWindow:
@75a8:  .byte   $9b,$58,$14,$02

Party1Window:
@75ac:  .byte   $0b,$5d,$08,$06

Party2Window:
@75b0:  .byte   $1f,$5d,$08,$06

Party3Window:
@75b4:  .byte   $33,$5d,$08,$06

; ------------------------------------------------------------------------------

; [  ]

_c375b8:
@75b8:  lda     #$06
        tsb     $47
        jsr     _c37c2f
        jsr     _c37cae
        jmp     _c37953

; ------------------------------------------------------------------------------

; [  ]

_c375c5:
@75c5:  lda     #$02
        sta     $4350
        lda     #$0e
        sta     $4351
        ldy     #.loword(_c375e4)
        sty     $4352
        lda     #^_c375e4
        sta     $4354
        lda     #^_c375e4
        sta     $4357
        lda     #$20
        tsb     $43
        rts

_c375e4:
@75e4:  .byte   $20,$02,$00
        .byte   $08,$00,$00
        .byte   $0b,$04,$00
        .byte   $0c,$08,$00
        .byte   $0c,$0c,$00
        .byte   $0c,$10,$00
        .byte   $00

; ------------------------------------------------------------------------------

; [ draw number of parties for party menu message ]

DrawNumParties:
@75f7:  clr_a
        lda     $0201                   ; number of parties
        and     #$07
        clc
        adc     #$b4
        sta     $f9
        stz     $fa
        stx     $f7
        ldy     #$00f7
        sty     $e7
        lda     #$00
        sta     $e9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37613:
@7613:  lda     #$ff
        ldx     $00
@7617:  sta     $7e9d99,x
        inx
        cpx     #$0090
        bne     @7617
        jsr     _c376ea
        jsr     _c37853
        jmp     _c37683

; ------------------------------------------------------------------------------

; [  ]

_c3762a:
@762a:  lda     #$ff
        ldx     $00
@762e:  sta     $7e9d89,x
        inx
        cpx     #$00a0
        bne     @762e
        ldx     #$9d89
        stx     hWMADDL
        lda     $0201       ; number of parties
        bmi     @7665       ; branch if clearing parties
@7643:  ldx     $00
@7645:  lda     $1850,x
        and     #$40
        beq     @7657
        lda     $1850,x
        and     #$07
        bne     @7657
        txa
        sta     hWMDATA
@7657:  inx
        cpx     #$0010
        bne     @7645
        lda     #$ff
        sta     hWMDATA
        jmp     _c37677
@7665:  ldx     $00
@7667:  lda     $1850,x
        and     #$f8
        sta     $1850,x
        inx
        cpx     #$0010
        bne     @7667
        bra     @7643

; ------------------------------------------------------------------------------

; [  ]

_c37677:
@7677:  jsr     _c376ea
        jsr     _c37853
        jsr     _c37683
        jmp     _c3790c

; ------------------------------------------------------------------------------

; [  ]

_c37683:
@7683:  ldx     $00
@7685:  clr_a
        lda     $7e9d89,x
        bmi     @76bf
        phx
        pha
        lda     #$00
        pha
        plb
        lda     #2
        ldy     #.loword(_c37a5f)
        jsr     CreateTask
        txy
        clr_a
        pla
        sta     $7e35c9,x
        jsr     _c378eb
        plx
        lda     f:_c376ca,x
        sta     $33ca,y
        lda     f:_c376da,x
        sta     $344a,y
        clr_a
        sta     $33cb,y
        sta     $344b,y
        lda     #^PartyCharAnimTbl
        sta     $35ca,y
@76bf:  inx
        cpx     #$0010
        bne     @7685
        lda     #$00
        pha
        plb
        rts

; ------------------------------------------------------------------------------

_c376ca:
@76ca:  .byte   $18,$34,$50,$6c,$88,$a4,$c0,$dc,$18,$34,$50,$6c,$88,$a4,$c0,$dc

_c376da:
@76da:  .byte   $5c,$5c,$5c,$5c,$5c,$5c,$5c,$5c,$78,$78,$78,$78,$78,$78,$78,$78

; ------------------------------------------------------------------------------

; [  ]

_c376ea:
@76ea:  ldx     #$9db9
        stx     $e7
        lda     $0201
        and     #$07
        sta     $e6
        lda     #$01
        sta     $e0
@76fa:  ldx     $e7
        stx     hWMADDL
        ldx     $00
@7701:  lda     $1850,x
        and     #$40
        beq     @7715
        lda     $1850,x
        and     #$07
        cmp     $e0
        bne     @7715
        txa
        sta     hWMDATA
@7715:  inx
        cpx     #$0010
        bne     @7701
        lda     #$ff
        sta     hWMDATA
        longa
        lda     $e7
        clc
        adc     #$0010
        sta     $e7
        shorta
        inc     $e0
        dec     $e6
        bne     @76fa
        jsr     _c37738
        jmp     _c37802

; ------------------------------------------------------------------------------

; [  ]

_c37738:
@7738:  lda     $0201
        and     #$07
        sta     $e6
        ldx     $00
@7741:  lda     #$7e
        sta     $e9
        longa
        lda     f:_c377e6,x
        sta     $e7
        lda     f:_c377e6+2,x
        phx
        tax
        shorta
        jsr     _c37b25
        plx
        inx4
        dec     $e6
        bne     @7741
        ldx     #$9d99
        stx     hWMADDL
        lda     $0201
        and     #$7f
        cmp     #$01
        beq     @77d6
        cmp     #$02
        beq     @77c3
        jsr     @77c3
        ldx     $00
@7779:  lda     $7e9de1,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @7779
        ldx     $00
@7788:  lda     $7e9df1,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @7788
        ldx     $00
@7797:  lda     $7e9e01,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @7797
        ldx     $00
@77a6:  lda     $7e9e11,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @77a6
        ldx     $00
@77b5:  lda     $7e9e21,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @77b5
        rts

@77c3:  jsr     @77d6
        ldx     $00
@77c8:  lda     $7e9dd1,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @77c8
        rts

@77d6:  ldx     $00
@77d8:  lda     $7e9dc1,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @77d8
        rts

; ------------------------------------------------------------------------------

_c377e6:
@77e6:  .word   $9dc1,$0030
        .word   $9dd1,$0040
        .word   $9de1,$0050
        .word   $9df1,$0060
        .word   $9e01,$0070
        .word   $9e11,$0080
        .word   $9e21,$0090

; ------------------------------------------------------------------------------

; [  ]

_c37802:
@7802:  ldx     #$9e51
        stx     hWMADDL
        lda     #$10
@780a:  stz     hWMDATA
        dec
        bne     @780a
        lda     $0201
        and     #$07
        cmp     #$01
        beq     @7839
        cmp     #$02
        beq     @783e
        jsr     @783e
        lda     #$03
        jsr     @7846
        lda     #$04
        jsr     @7846
        lda     #$05
        jsr     @7846
        lda     #$06
        jsr     @7846
        lda     #$07
        jmp     @7846

@7839:  lda     #$01
        jmp     @7846

@783e:  jsr     @7839
        lda     #$02
        jmp     @7846

@7846:  sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37853:
@7853:  lda     $0201
        and     #$07
        sta     $e6
        ldx     #$9dc1
        stx     $f3
        lda     #$7e
        sta     $f5
@7863:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @7863
        lda     $99
        sta     hM7A
        stz     hM7A
        lda     #$b0
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        stx     $e4
@787f:  ldx     $00
@7881:  clr_a
        txy
        lda     [$f3],y
        sta     $f6
        bmi     @78c0
        phx
        pha
        lda     #$00
        pha
        plb
        lda     #2
        ldy     #.loword(CharIconTask)
        jsr     CreateTask
        txy
        clr_a
        pla
        sta     $7e35c9,x
        jsr     _c378eb
        plx
        clr_a
        lda     f:_c378e3,x
        longac
        adc     $e4
        sta     $33ca,y
        shorta
        lda     f:_c378e7,x
        sta     $344a,y
        clr_a
        sta     $344b,y
        lda     #^PartyCharAnimTbl
        sta     $35ca,y
@78c0:  inx
        cpx     #4
        bne     @7881
        longa
        lda     $f3
        clc
        adc     #$0010
        sta     $f3
        lda     $e4
        clc
        adc     #$0050
        sta     $e4
        shorta
        dec     $e6
        bne     @787f
        lda     #$00
        pha
        plb
        rts

; ------------------------------------------------------------------------------

_c378e3:
@78e3:  .byte   $18,$18,$38,$38

_c378e7:
@78e7:  .byte   $9c,$b8,$9c,$b8

; ------------------------------------------------------------------------------

; [  ]

_c378eb:
@78eb:  asl
        tax
        longa
        lda     f:CharPropPtrs,x
        tax
        shorta
        clr_a
        lda     a:$0001,x     ; actor number

_c378fa:
@78fa:  asl
        tax
        lda     #$7e
        pha
        plb
        longa
        lda     f:PartyCharAnimTbl,x
        sta     $32c9,y
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3790c:
@790c:  ldx     #$ac8d
        stx     hWMADDL
        clr_ax
@7914:  phx
        clr_a
        lda     $7e9d89,x
        bmi     @7933
        longa
        asl
        tax
        lda     f:_c37c0f,x
        sta     $e7
        lda     $0202
        and     $e7
        shorta
        beq     @7933
        lda     #$ff
        bra     @7934
@7933:  clr_a
@7934:  sta     hWMDATA
        plx
        inx
        cpx     #$002c
        bne     @7914
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3793f:
@793f:  stz     $28
        jsr     _c37ae5
        lda     #$2f
        sta     $7e344a,x
        jsr     TfrVRAM2
        jsr     _c37c2f
        jmp     _c37cae

; ------------------------------------------------------------------------------

; [  ]

_c37953:
@7953:  jsr     _c379ac
        clr_a
        lda     $4b
        clc
        adc     $4a
        adc     $5a
        tax
        lda     $7e9d89,x
        bmi     @79ab
        sta     $c9
        asl
        tax
        longa
        lda     f:CharPropPtrs,x
        sta     $67
        shorta
        lda     #$24
        sta     $29
        ldx     #.loword(_c379c9)
        ldy     #$0006
        jsr     DrawPosList
        ldy     #$3a5b
        ldx     #$3048
        lda     #$01
        sta     $48
        jsr     DrawStatusIcons
        ldy     #$3adb
        jsr     DrawCharName
        ldy     #$3b5b
        jsr     DrawEquipGenju
        ldy     #.loword(_c379de)
        jsr     DrawPosText
        ldy     #.loword(_c379e2)
        jsr     DrawPosText
        ldx     #.loword(_c379e6)
        jsr     DrawCharBlock
@79ab:  rts

; ------------------------------------------------------------------------------

; [  ]

_c379ac:
@79ac:  ldx     #$01c0
        longa
        clr_a
        lda     $00
        ldy     #$0060
@79b7:  sta     $7e3849,x
        inx2
        sta     $7e3849,x
        inx2
        dey
        bne     @79b7
        shorta
        rts

; ------------------------------------------------------------------------------

_c379c9:
@79c9:  .addr   _c379cf
        .addr   _c379d4
        .addr   _c379d9

_c379cf:
@79cf:  .byte   $6d,$3a,$8b,$95,$00

_c379d4:
@79d4:  .byte   $ed,$3a,$87,$8f,$00

_c379d9:
@79d9:  .byte   $6d,$3b,$8c,$8f,$00

_c379de:
@79de:  .byte   $fb,$3a,$c0,$00

_c379e2:
@79e2:  .byte   $7b,$3b,$c0,$00

; ram addresses for lv/hp/mp text (party select)
_c379e6:
@79e6:  .word   $3a77,$3af3,$3afd,$3b73,$3b7d

; ------------------------------------------------------------------------------

; [ menu state $67:  ]

MenuState_67:
@79f0:  jsr     CreateFadeOutTask
        ldy     #$0008
        sty     $20
        lda     #$68
        sta     $26
        jmp     _c375b8

; ------------------------------------------------------------------------------

; [ menu state $66:  ]

MenuState_66:
@79ff:  jsr     CreateFadeInTask
        ldy     #$0008
        sty     $20
        lda     #$68
        sta     $26
        jmp     _c375b8

; ------------------------------------------------------------------------------

; [ menu state $68:  ]

MenuState_68:
@7a0e:  ldy     $20
        bne     @7a16
        lda     $27
        sta     $26
@7a16:  jmp     _c375b8

; ------------------------------------------------------------------------------

; [ flashing left cursor thread (item details) ]

ItemDetailsArrowTask:
@7a19:  tax
        jmp     (.loword(ItemDetailsArrowTaskTbl),x)

ItemDetailsArrowTaskTbl:
@7a1d:  .addr   ItemDetailsArrowTask_00
        .addr   ItemDetailsArrowTask_01

; ------------------------------------------------------------------------------

; state 0: init

ItemDetailsArrowTask_00:
@7a21:  ldx     $2d
        longa
        lda     #.loword(ItemDetailArrowAnimShown)
        sta     $32c9,x
        lda     #$0008
        sta     $33ca,x
        shorta
        lda     #^ItemDetailArrowAnimShown
        sta     $35ca,x
        inc     $3649,x
        jsr     InitAnimTask
; fall through

; ------------------------------------------------------------------------------

; state 1: normal

ItemDetailsArrowTask_01:
@7a3e:  ldy     $2d
        lda     $99
        beq     @7a4b
        bmi     @7a5d
        clr_a
        lda     #$02
        bra     @7a4c
@7a4b:  clr_a
@7a4c:  tax
        longa
        lda     f:ItemDetailArrowAnimPtrs,x
        sta     $32c9,y
        shorta
        jsr     UpdateAnimTask
        sec
        rts
@7a5d:  clc
        rts

; ------------------------------------------------------------------------------

; [ party/colosseum character sprite task ]

_c37a5f:
@7a5f:  tax
        jmp     (.loword(_c37a63),x)

_c37a63:
@7a63:  .addr   _c37a67
        .addr   _c37a78

; ------------------------------------------------------------------------------

; [  ]

_c37a67:
@7a67:  lda     #$01
        tsb     $47
        ldx     $2d
        inc     $3649,x
        lda     #$01
        jsr     InitAnimTask
        jsr     _c37bae

_c37a78:
@7a78:  lda     $47
        and     #$01
        beq     @7a85
        ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts
@7a85:  clc
        rts

; ------------------------------------------------------------------------------

; [ menu state $69:  ]

MenuState_69:
@7a87:  lda     $20
        bne     @7a92
        lda     #$2d
        sta     $26
        jsr     DrawPartyMsg
@7a92:  jmp     _c375b8

; ------------------------------------------------------------------------------

; "Form   group(s)."
PartyMsgText:
@7a95:  .byte   $1d,$39,$85,$a8,$ab,$a6,$ff,$ff,$ff,$a0,$ab,$a8,$ae,$a9,$cb,$ac
        .byte   $cc,$c5,$ff,$ff,$ff,$ff,$ff,$ff,$00

; "Lineup"
PartyTitleText:
@7aae:  .byte   $0d,$39,$8b,$a2,$a7,$9e,$ae,$a9,$00

; "You need   group(s)!"
PartyErrorMsg1:
@7ab7:  .byte   $1d,$39,$98,$a8,$ae,$ff,$a7,$9e,$9e,$9d,$ff,$ff,$ff,$a0,$ab,$a8
        .byte   $ae,$a9,$cb,$ac,$cc,$be,$00

; "No one there!"
PartyErrorMsg2:
@7ace:  .byte   $1d,$39,$8d,$a8,$ff,$a8,$a7,$9e,$ff,$ad,$a1,$9e,$ab,$9e,$be,$ff
        .byte   $ff,$ff,$ff,$ff,$ff,$ff,$00

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

; [ character icon thread ]

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
@801a:  lda     $d26f00,x               ; item type name
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
        jsr     InitBG3TilesDMA1
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
        jsr     InitBG3TilesLeftDMA1
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
@8a96:  jsr     InitBG1TilesLeftDMA1
        jsr     InitBG3TilesLeftDMA2

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

; [ init cursor (equip, optimum, rmove, empty) ]

LoadEquipOptionCursor:
@8e50:  ldy     #.loword(EquipOptionCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip, optimum, rmove, empty) ]

UpdateEquipOptionCursor:
@8e56:  jsr     MoveCursor

InitEquipOptionCursor:
@8e59:  ldy     #.loword(EquipOptionCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipOptionCursorProp:
@8e5f:  .byte   $01,$00,$00,$04,$01

EquipOptionCursorPos:
@8e64:  .byte   $00,$10
        .byte   $38,$10
        .byte   $80,$10
        .byte   $b8,$10

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic slot select) ]

LoadEquipSlotCursor:
@8e6c:  ldy     #.loword(EquipSlotCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic slot select) ]

UpdateEquipSlotCursor:
@8e72:  jsr     MoveCursor

InitEquipSlotCursor:
@8e75:  ldy     #.loword(EquipSlotCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipSlotCursorProp:
@8e7b:  .byte   $80,$00,$00,$01,$04

EquipSlotCursorPos:
@8e80:  .byte   $00,$2c
        .byte   $00,$38
        .byte   $00,$44
        .byte   $00,$50

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic item select, scrolling page) ]

LoadEquipLongListCursor:
@8e88:  ldy     #.loword(EquipListCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic item select, scrolling page) ]

UpdateEquipLongListCursor:
@8e8e:  jsr     MoveListCursor

InitEquipLongListCursor:
@8e91:  ldy     #.loword(EquipListCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic item select, single page) ]

LoadEquipShortListCursor:
@8e97:  ldy     #.loword(EquipListCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic item select, single page) ]

UpdateEquipShortListCursor:
@8e9d:  jsr     MoveCursor

InitEquipShortListCursor:
@8ea0:  ldy     #.loword(EquipListCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipListCursorProp:
@8ea6:  .byte   $81,$00,$00,$01,$09

EquipListCursorPos:
@8eab:  .byte   $00,$68
        .byte   $00,$74
        .byte   $00,$80
        .byte   $00,$8c
        .byte   $00,$98
        .byte   $00,$a4
        .byte   $00,$b0
        .byte   $00,$bc
        .byte   $00,$c8

; ------------------------------------------------------------------------------

; [ load cursor for relic options (equip/remove) ]

LoadRelicOptionCursor:
@8ebd:  ldy     #.loword(RelicOptionCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for relic options (equip/remove) ]

UpdateRelicOptionCursor:
@8ec3:  jsr     MoveCursor

InitRelicOptionCursor:
@8ec6:  ldy     #.loword(RelicOptionCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

RelicOptionCursorProp:
@8ecc:  .byte   $01,$00,$00,$02,$01

RelicOptionCursorPos:
@8ed1:  .byte   $10,$10
        .byte   $48,$10

; ------------------------------------------------------------------------------

; [ load cursor for relic slot select ]

LoadRelicSlotCursor:
@8ed5:  ldy     #.loword(RelicSlotCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for relic slot select ]

UpdateRelicSlotCursor:
@8edb:  jsr     MoveCursor

InitRelicSlotCursor:
@8ede:  ldy     #.loword(RelicSlotCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

RelicSlotCursorProp:
@8ee4:  .byte   $80,$00,$00,$01,$02

RelicSlotCursorPos:
@8ee9:  .byte   $00,$44
        .byte   $00,$50

; ------------------------------------------------------------------------------

; [ draw party equipment overview menu ]

DrawPartyEquipMenu:
@8eed:  lda     #$02
        sta     hBG1SC
        jsr     ClearBG2ScreenA
        ldy     #.loword(PartyEquipWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     _c38f1c
        jsr     _c38f36
        jsr     _c38f52
        jsr     _c38f6e
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     ClearBG3ScreenA
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c38f1c:
@8f1c:  lda     $69
        bmi     @8f35
        ldx     $6d
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$390d
        jsr     DrawCharName
        stz     $28
        lda     #$04
        jsr     _c38f8a
@8f35:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f36:
@8f36:  lda     $6a
        bmi     @8f51
        ldx     $6f
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$3b0d
        jsr     DrawCharName
        lda     #$01
        sta     $28
        lda     #$0c
        jsr     _c38f8a
@8f51:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f52:
@8f52:  lda     $6b
        bmi     @8f6d
        ldx     $71
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$3d0d
        jsr     DrawCharName
        lda     #$02
        sta     $28
        lda     #$14
        jsr     _c38f8a
@8f6d:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f6e:
@8f6e:  lda     $6c
        bmi     @8f89
        ldx     $73
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$3f0d
        jsr     DrawCharName
        lda     #$03
        sta     $28
        lda     #$1c
        jsr     _c38f8a
@8f89:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f8a:
@8f8a:  sta     $e2
        stz     $e0
        ldy     $67
        clr_ax
@8f92:  phx
        phy
        phy
        phx
        stz     $e5
        lda     f:_c38fd5,x
        sta     $e4
        lda     f:_c38fdb,x
        clc
        adc     $e2
        ldx     $e4
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        plx
        cpx     #$0002
        bcs     @8fbe
        jsr     _c3941d
        bra     @8fc0
@8fbe:  stz     $e0
@8fc0:  ply
        clr_a
        lda     $001f,y
        jsr     _c38fe1
        jsr     DrawPosTextBuf
        ply
        iny
        plx
        inx
        cpx     #6
        bne     @8f92
        rts

; ------------------------------------------------------------------------------

_c38fd5:
@8fd5:  .byte   $02,$11,$02,$11,$02,$11

_c38fdb:
@8fdb:  .byte   $01,$01,$03,$03,$05,$05

; ------------------------------------------------------------------------------

; [  ]

_c38fe1:
@8fe1:  pha
        ldx     #$9e8b
        stx     hWMADDL
@8fe8:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @8fe8
        clr_a
        lda     $e0
        beq     @8ff7
        pla
        bra     @8ffc
@8ff7:  pla
        cmp     #$ff
        beq     @901f
@8ffc:  sta     hM7A
        stz     hM7A
        lda     #13
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #13
@9010:  lda     f:ItemName,x
        sta     hWMDATA
        inx
        dey
        bne     @9010
        stz     hWMDATA
        rts
@901f:  ldy     #$000d
        lda     #$ff
@9024:  sta     hWMDATA
        dey
        bne     @9024
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

PartyEquipWindow:
@902e:  .byte   $8b,$58,$1c,$18

; ------------------------------------------------------------------------------

; [ draw equip menu ]

DrawEquipMenu:
@9032:  jsr     DrawEquipRelicCommon
        jsr     _c3911b
        lda     #$2c
        sta     $29
        ldx     #.loword(EquipSlotTextList)
        ldy     #$0004
        jsr     DrawPosList
        jsr     DrawEquipOptions
        jsr     TfrBG3ScreenAB
        jmp     _c39e0f

; ------------------------------------------------------------------------------

; [ draw equip options (equip, optimum, remove, empty) ]

DrawEquipOptions:
@904e:  lda     #$20
        sta     $29
        ldx     #.loword(EquipOptionTextList)
        ldy     #$0008
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw relic options (equip, remove) ]

DrawRelicOptions:
@905c:  lda     #$20
        sta     $29
        ldx     #.loword(RelicOptionTextList)
        ldy     #$0004
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw relic menu ]

DrawRelicMenu:
@906a:  jsr     DrawEquipRelicCommon
        jsr     GetSelCharPropPtr
        lda     $0023,y
        sta     $b0
        lda     $0024,y
        sta     $b1
        jsr     _c39131
        lda     #$2c
        sta     $29
        ldx     #.loword(RelicSlotTextList)
        ldy     #$0004
        jsr     DrawPosList
        jsr     DrawRelicOptions
        jsr     _c3a6ab
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ draw common parts of equip/relic menu ]

DrawEquipRelicCommon:
@9093:  jsr     UpdateEquipStats
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$01
        sta     hBG1SC
        lda     #$42
        sta     hBG3SC
        jsr     _c3960c
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        ldy     #.loword(EquipBtmWindow1)
        jsr     DrawWindow
        ldy     #.loword(EquipTopWindow1)
        jsr     DrawWindow
        ldy     #.loword(EquipOptionsWindow)
        jsr     DrawWindow
        ldy     #.loword(EquipBtmWindow2)
        jsr     DrawWindow
        ldy     #.loword(EquipTopWindow2)
        jsr     DrawWindow
        ldy     #.loword(EquipTitleWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     _c393e5
        jsr     CreateEquipPortraitTask
        lda     #$2c
        sta     $29
        ldx     #.loword(EquipStatTextList1)
        ldy     #$001c
        jsr     DrawPosList
        lda     #$2c
        sta     $29
        ldx     #.loword(EquipStatTextList2)
        ldy     #$0008
        jsr     DrawPosList
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ update character battle stats ]

UpdateEquipStats:
@9110:  clr_a
        lda     $28                     ; character slot
        tax
        lda     $69,x                   ; character number
        jsl     UpdateEquip_ext
        rts

; ------------------------------------------------------------------------------

; [ redraw items in equip menu ]

_c3911b:
@911b:  jsr     _c39975
        lda     #$20
        sta     $29
        jsr     _c3913e
        jsr     _c3922d
        jsr     _c393fc
        jsr     _c39435
        jmp     _c39443

; ------------------------------------------------------------------------------

; [  ]

_c39131:
@9131:  lda     #$20
        sta     $29
        jsr     _c3913e
        jsr     _c39451
        jmp     _c3945f

; ------------------------------------------------------------------------------

; [  ]

_c3913e:
@913e:  jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        jsr     CheckHandEffects
        jsr     _c39207
        phb
        lda     #$7e
        pha
        plb
        jsr     _c391c4
        lda     $3006
        jsr     HexToDec3
        ldx     #$7cb7
        jsr     DrawNum3
        lda     $3004
        jsr     HexToDec3
        ldx     #$7d37
        jsr     DrawNum3
        lda     $3002
        jsr     HexToDec3
        ldx     #$7db7
        jsr     DrawNum3
        lda     $3000
        jsr     HexToDec3
        ldx     #$7e37
        jsr     DrawNum3
        jsr     _c393ab
        ldx     $f1
        stx     $f3
        jsr     HexToDec5
        ldx     #$7eb7
        jsr     Draw16BitNum
        lda     $301a
        jsr     HexToDec3
        ldx     #$7f37
        jsr     DrawNum3
        lda     $3008
        jsr     HexToDec3
        ldx     #$7fb7
        jsr     DrawNum3
        lda     $301b
        jsr     HexToDec3
        ldx     #$8037
        jsr     DrawNum3
        lda     $300a
        jsr     HexToDec3
        ldx     #$80b7
        jsr     DrawNum3
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c391c4:
@91c4:  jsr     GetSelCharPropPtr
        lda     $7e3032
        jsr     _c391ec
        lda     $3034
        and     #$01
        bne     @91dc
        lda     $0015,y
        and     #$01
        beq     @91eb
@91dc:  lda     $3034
        clc
        and     #$01
        sta     $e0
        ror2
        ora     $e0
        sta     $0015,y
@91eb:  rts

; ------------------------------------------------------------------------------

; [  ]

_c391ec:
@91ec:  and     #$25
        eor     #$ff
        sta     $e1
        lda     $0014,y
        and     $e1
        sta     $0014,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c391fb:
@91fb:  clc
        and     #$01
        ror2
        ora     $0015,y
        sta     $0015,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39207:
@9207:  ldx     $00
        longa
@920b:  lda     $11a0,x
        sta     $7e3000,x
        inx2
        lda     $11a0,x
        sta     $7e3000,x
        inx2
        cpx     #$0040
        bne     @920b
        shorta
        lda     $a1
        sta     $a0
        lda     $cd
        sta     $ce
        rts

; ------------------------------------------------------------------------------

; [ no effect ]

_c3922d:
@922d:  rts

; ------------------------------------------------------------------------------

; [ unused ??? ]

_c3922e:
@922e:  lda     #$2c
        sta     $29
        rts

; ------------------------------------------------------------------------------

; [ update modified stats text ]

_c39233:
@9233:  lda     $7e9d89     ; length of item list
        beq     @923e       ; branch if list is empty
        jsr     CheckCanEquipSelItem
        bcs     @9241       ; branch if item can be equipped
@923e:  jmp     _c39c87
@9241:  jsr     GetSelCharPropPtr
        lda     $25         ; main menu position
        cmp     #$02
        beq     @924e       ; branch if equip
        iny4                ; add 4 to character data pointer (relic)
@924e:  longac
        tya
        shorta
        adc     $5f         ; add item slot
        tay
        clr_a
        lda     $4b         ; selected item
        tax
        lda     $7e9d8a,x   ; item number
        tax
        lda     $001f,y     ; $64 = character's equipped item
        sta     $64
        lda     $1869,x     ; selected item
        sta     $001f,y     ; equip on character
        phy
        jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        jsr     CheckHandEffects
        jsr     _c39320
        lda     $11a6       ; vigor
        jsr     HexToDec3
        ldx     #$7cbf      ; (27,17)
        lda     $7e3040     ; vigor text color
        sta     $29
        jsr     DrawNum3
        lda     $11a4
        jsr     HexToDec3
        ldx     #$7d3f      ; (27,19)
        lda     $7e3041
        sta     $29
        jsr     DrawNum3
        lda     $11a2
        jsr     HexToDec3
        ldx     #$7dbf      ; (27,21)
        lda     $7e3042
        sta     $29
        jsr     DrawNum3
        lda     $11a0
        jsr     HexToDec3
        ldx     #$7e3f      ; (27,23)
        lda     $7e3043
        sta     $29
        jsr     DrawNum3
        jsr     _c39371
        jsr     HexToDec5
        ldx     #$7ebf      ; (27,25)
        lda     $7e3048
        sta     $29
        jsr     Draw16BitNum
        lda     $11ba
        jsr     HexToDec3
        ldx     #$7f3f      ; (27,27)
        lda     $7e3044
        sta     $29
        jsr     DrawNum3
        lda     $11a8
        jsr     HexToDec3
        ldx     #$7fbf      ; (27,29)
        lda     $7e3045
        sta     $29
        jsr     DrawNum3
        lda     $11bb
        jsr     HexToDec3
        ldx     #$803f      ; (27,31)
        lda     $7e3046
        sta     $29
        jsr     DrawNum3
        lda     $11aa
        jsr     HexToDec3
        ldx     #$80bf      ; (27,33)
        lda     $7e3047
        sta     $29
        jsr     DrawNum3
        ply
        lda     $64         ; restore equipped item
        sta     $001f,y
        rts

; ------------------------------------------------------------------------------

; [ update stat text colors ]

_c39320:
@9320:  phb
        lda     #$7e
        pha
        plb
        clr_ax
@9327:  lda     f:_c39369,x   ; pointer to battle stat
        phx
        tax
        lda     f:$0011a0,x   ; stat with item equipped
        cmp     $3000,x     ; compare with saved stat
        beq     @933c       ; branch if no change
        bcc     @9340       ; branch if less
        lda     #$28        ; yellow text
        bra     @9342
@933c:  lda     #$20        ; white text
        bra     @9342
@9340:  lda     #$24        ; gray text
@9342:  plx
        sta     $3040,x     ; set high byte of bg data
        inx                 ; next stat
        cpx     #8
        bne     @9327
        jsr     _c39371
        jsr     _c393ab
        ldy     $f3
        cpy     $f1
        beq     @935e
        bcc     @9362
        lda     #$28        ; yellow text
        bra     @9364
@935e:  lda     #$20        ; white text
        bra     @9364
@9362:  lda     #$24        ; gray text
@9364:  sta     $3048       ; set high byte of bg data for bat.pwr
        plb
        rts

; ------------------------------------------------------------------------------

; pointers to battle stats (+$11a0) vigor, speed, stamina, mag.pwr, defense, evade, magic defense, mblock
_c39369:
@9369:  .byte   $06,$04,$02,$00,$1a,$08,$1b,$0a

; ------------------------------------------------------------------------------

; [ calculate battle power (equipped weapons) ]

; +$f3 = battle power (out)

_c39371:
@9371:  lda     $a1         ; branch if no gauntlet bonus
        beq     @938b
        lda     f:$0011ac     ; right hand battle power
        beq     @9381       ; branch if right hand empty
        sta     f:$0011ad     ; save as left hand battle power
        bra     @939a
@9381:  lda     f:$0011ad     ; copy left hand battle power to right hand (double battle power)
        sta     f:$0011ac
        bra     @939a
@938b:  lda     $cd         ; branch if wearing genji glove
        bne     @939a
        lda     f:$0011ac
        beq     @939a
        clr_a
        sta     f:$0011ad
@939a:  lda     f:$0011ac
        clc
        adc     f:$0011ad
        sta     $f3
        clr_a
        adc     #$00
        sta     $f4
        rts

; ------------------------------------------------------------------------------

; [ calculate battle power (saved weapons) ]

; +$f1 = battle power (out)

_c393ab:
@93ab:  lda     $a0
        beq     @93c5
        lda     $7e300c
        beq     @93bb
        sta     $7e300d
        bra     @93d4
@93bb:  lda     $7e300d
        sta     $7e300c
        bra     @93d4
@93c5:  lda     $ce
        bne     @93d4
        lda     $7e300c
        beq     @93d4
        clr_a
        sta     $7e300d
@93d4:  lda     $7e300c
        clc
        adc     $7e300d
        sta     $f1
        clr_a
        adc     #$00
        sta     $f2
        rts

; ------------------------------------------------------------------------------

; [  ]

_c393e5:
@93e5:  jsr     GetSelCharPropPtr
        lda     #$20
        sta     $29
        ldy     #$7bb7
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; [ update pointer to current character data ]

GetSelCharPropPtr:
@93f2:  clr_a
        lda     $28         ; character slot
        asl
        tax
        ldy     $6d,x       ; pointer to character data
        sty     $67
        rts

; ------------------------------------------------------------------------------

; [  ]

_c393fc:
@93fc:  jsr     _c3941d
        ldx     #$7a1b
        jsr     _c3946d
        lda     $001f,y
        jsr     _c38fe1
        jsr     DrawPosTextBuf
        jsr     _c3941d
        ldx     #$7a9b
        jsr     _c3946d
        lda     $0020,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3941d:
@941d:  jsr     GetSelCharPropPtr
        lda     $001f,y
        cmp     #$ff
        bne     @9432
        lda     $0020,y
        cmp     #$ff
        bne     @9432
        sta     $e0
        bra     @9434
@9432:  stz     $e0
@9434:  rts

; ------------------------------------------------------------------------------

; [  ]

_c39435:
@9435:  ldx     #$7b1b
        jsr     _c3946d
        stz     $e0
        lda     $0021,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c39443:
@9443:  ldx     #$7b9b
        jsr     _c3946d
        stz     $e0
        lda     $0022,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c39451:
@9451:  ldx     #$7b1b
        jsr     _c3946d
        stz     $e0
        lda     $0023,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3945f:
@945f:  ldx     #$7b9b
        jsr     _c3946d
        stz     $e0
        lda     $0024,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3946d:
@946d:  longa
        txa
        sta     $7e9e89
        shorta
        jmp     GetSelCharPropPtr

; ------------------------------------------------------------------------------

; [  ]

_c39479:
@9479:  jsr     _c38fe1
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; inventory/stats window
EquipBtmWindow1:
@947f:  .byte   $4b,$5b,$1c,$0d

; current equipped items window
EquipTopWindow1:
@9483:  .byte   $0b,$59,$1c,$07

; equip options window (equip, optimum, remove, empty)
EquipOptionsWindow:
@9487:  .byte   $8b,$58,$1c,$02

; inventory/stats window
EquipBtmWindow2:
@948b:  .byte   $4b,$63,$1c,$0d

; current equipped items window
EquipTopWindow2:
@948f:  .byte   $0b,$61,$1c,$07

; equip title window
EquipTitleWindow:
@9493:  .byte   $b7,$60,$06,$02

; ------------------------------------------------------------------------------

; [ init BG scroll HDMA for party equipment overview ]

; also used for final battle order

InitPartyEquipScrollHDMA:
@9497:  lda     #$02
        sta     $4350
        lda     #$0e
        sta     $4351
        ldy     #.loword(_c395d8)
        sty     $4352
        lda     #^_c395d8
        sta     $4354
        lda     #^_c395d8
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ init BG scroll HDMA for equip/relic menu ]

InitEquipScrollHDMA:
@94b6:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(_c395d8)
        sty     $4352
        lda     #^_c395d8
        sta     $4354
        lda     #^_c395d8
        sta     $4357
        lda     #$20
        tsb     $43
        jsr     LoadEquipBG1VScrollHDMATbl
        ldx     $00
@94d9:  lda     f:_c39564,x
        sta     $7e9bc9,x
        inx
        cpx     #$000d
        bne     @94d9
        lda     #$02
        sta     $4360
        lda     #$0d
        sta     $4361
        ldy     #$9bc9
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

; [ load bg1 vertical scroll HDMA table for equip/relic item list ]

LoadEquipBG1VScrollHDMATbl:
@9520:  ldx     $00
@9522:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        cpx     #$0012
        bne     @9522
@9530:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        clr_a
        lda     $49
        asl4
        and     #$ff
        longac
        adc     f:_c39571,x
        sta     $7e9849,x
        shorta
        inx2
        cpx     #$0063
        bne     @9530
@9555:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        cpx     #$0067
        bne     @9555
        rts

; ------------------------------------------------------------------------------

_c39564:
@9564:  .byte   $27,$00,$01
        .byte   $3c,$00,$01
        .byte   $6c,$00,$00
        .byte   $1e,$00,$01
        .byte   $00

; ------------------------------------------------------------------------------

_c39571:
@9571:  .byte   $3f,$00,$00
        .byte   $0c,$04,$00
        .byte   $0c,$08,$00
        .byte   $0a,$0c,$00
        .byte   $01,$0c,$00
        .byte   $01,$0c,$00
        .byte   $04,$a0,$ff
        .byte   $04,$a0,$ff
        .byte   $04,$a0,$ff
        .byte   $04,$a4,$ff
        .byte   $04,$a4,$ff
        .byte   $04,$a4,$ff
        .byte   $04,$a8,$ff
        .byte   $04,$a8,$ff
        .byte   $04,$a8,$ff
        .byte   $04,$ac,$ff
        .byte   $04,$ac,$ff
        .byte   $04,$ac,$ff
        .byte   $04,$b0,$ff
        .byte   $04,$b0,$ff
        .byte   $04,$b0,$ff
        .byte   $04,$b4,$ff
        .byte   $04,$b4,$ff
        .byte   $04,$b4,$ff
        .byte   $04,$b8,$ff
        .byte   $04,$b8,$ff
        .byte   $04,$b8,$ff
        .byte   $04,$bc,$ff
        .byte   $04,$bc,$ff
        .byte   $04,$bc,$ff
        .byte   $04,$c0,$ff
        .byte   $04,$c0,$ff
        .byte   $04,$c0,$ff
        .byte   $1e,$10,$00
        .byte   $00

; ------------------------------------------------------------------------------

_c395d8:
@95d8:  .byte   $0f,$00,$00
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
        .byte   $0c,$40,$00
        .byte   $00

; ------------------------------------------------------------------------------

; [  ]

_c3960c:
@960c:  jsr     ClearEquipOptionText
        ldy     $00
        sty     $39
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39614:
@9614:  jsr     ClearEquipOptionText
        ldy     #$0100
        sty     $39
        lda     #$2c
        sta     $29
        rts

; ------------------------------------------------------------------------------

; [ menu state $36: equip menu options (equip, optimum, remove, empty) ]

MenuState_36:
@9621:  jsr     _c3960c
        jsr     DrawEquipOptions
        jsr     UpdateEquipOptionCursor
        lda     $08
        bit     #$80
        beq     @9635
        jsr     PlaySelectSfx
        bra     SelectEquipOption
@9635:  lda     $09
        bit     #$80
        beq     @9648
        jsr     PlayCancelSfx
        jsr     UpdateEquipStats
        lda     #$04
        sta     $27
        stz     $26
        rts
@9648:  lda     #$35
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ draw "EQUIP" title in equip/relic menu ]

DrawEquipTitleEquip:
@964f:  ldy     #.loword(EquipTitleEquipText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw "REMOVE" title in equip/relic menu ]

DrawEquipTitleRemove:
@9656:  ldy     #.loword(EquipTitleRemoveText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ clear equip options ]

ClearEquipOptionText:
@965d:  ldy     #.loword(EquipBlankOptionsText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ select equip option (equip, optimum, remove, empty) ]

SelectEquipOption:
@9664:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectEquipOptionTbl),x)

SelectEquipOptionTbl:
@966c:  .addr   SelectEquipOption_00
        .addr   SelectEquipOption_01
        .addr   SelectEquipOption_02
        .addr   SelectEquipOption_03

; ------------------------------------------------------------------------------

; [ 0: equip ]

SelectEquipOption_00:
@9674:  jsr     _c39614
        jsr     DrawEquipTitleEquip
        jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #$55
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ 1: optimum ]

SelectEquipOption_01:
@9685:  jsr     EquipOptimum
        jsr     _c3911b
        stz     $4d
        rts

; ------------------------------------------------------------------------------

; [ 2: remove ]

SelectEquipOption_02:
@968e:  jsr     _c39614
        jsr     DrawEquipTitleRemove
        jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #$56
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ 3: empty ]

SelectEquipOption_03:
@969f:  jsr     EquipRemoveAll
        jsr     _c3911b
        stz     $4d
        rts

; ------------------------------------------------------------------------------

; [ remove character's equipment ]

EquipRemoveAll:
@96a8:  jsr     GetSelCharPropPtr
        lda     $001f,y                 ; add weapon to inventory
        jsr     IncItemQty
        lda     $0020,y                 ; add shield to inventory
        jsr     IncItemQty
        lda     $0021,y                 ; add helmet to inventory
        jsr     IncItemQty
        lda     $0022,y                 ; add armor to inventory
        jsr     IncItemQty
        lda     #$ff
        sta     $001f,y                 ; remove weapon
        sta     $0020,y                 ; remove shield
        sta     $0021,y                 ; remove helmet
        sta     $0022,y                 ; remove armor
        rts

; ------------------------------------------------------------------------------

; [ optimize a character's equipment (from field) ]

; $0201 = character number

OptimizeCharEquip:
@96d2:  jsr     InitCharProp
        clr_ax
        lda     $0201                   ; character number
@96da:  cmp     $69,x                   ; look for character in party
        beq     @96e6
        inx
        cpx     #4
        bne     @96da
@96e4:  bra     @96e4                   ; infinite loop
@96e6:  txa
        sta     $28                     ; $28 = character slot
        jsr     UpdateEquipStats
        jsr     EquipOptimum
        rtl

; ------------------------------------------------------------------------------

; [ set optimum equipment ]

EquipOptimum:
@96f0:  jsr     UpdateEquipStats
        jsr     EquipRemoveAll
        jsr     GetSelCharPropPtr
        sty     $f3                     ; +$f3 = pointer to character data
        lda     $11d8                   ; gauntlet effect
        and     #$08
        beq     @971a                   ; branch if not set

; select optimum 2-handed weapon
        stz     $4b
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        jsr     GetBest2Hand
        ldy     $f3
        sta     $001f,y                 ; set main-hand
        jsr     DecItemQty
        bra     @976b

; select optimum one-handed weapon
@971a:  stz     $4b                     ; cursor position = 0 (main hand)
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $001f,y                 ; set main hand
        jsr     DecItemQty
        lda     $11d8                   ; genji glove effect
        and     #$10
        bne     @9751                   ; branch if second hand can use a weapon

; select optimum shield
        lda     #$01                    ; cursor position = 1 (off-hand)
        sta     $4b
        jsr     GetValidEquip
        jsr     GetValidShields
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0020,y                 ; set off-hand
        jsr     DecItemQty
        bra     @976b

; genji glove (equip a weapon in off-hand)
@9751:  lda     #$01                    ; cursor position = 1 (off-hand)
        sta     $4b
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0020,y                 ; set off-hand
        jsr     DecItemQty
        bra     @976b

; select optimum helmet & armor
@976b:  lda     #$02                    ; cursor position = 2 (helmet)
        sta     $4b
        jsr     GetValidEquip
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0021,y                 ; set helmet
        jsr     DecItemQty
        lda     #$03                    ; cursor position = 3 (armor)
        sta     $4b
        jsr     GetValidEquip
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0022,y                 ; set armor
        jmp     DecItemQty

; ------------------------------------------------------------------------------

; [ update list of equippable weapons ]

GetValidWeapons:
@9795:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        ldx     $00
        txy
@979e:  clr_a
        lda     $1869,y     ; item in inventory
        cmp     #$ff
        beq     @97c8       ; branch if slot is empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$01
        bne     @97c8       ; branch if not a weapon
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @97c8       ; branch if not equippable
        shorta
        tya
        sta     hWMDATA       ; add to list of weapons
        inc     $e0
@97c8:  shorta        ; next item
        iny
        cpy     #$00ff
        bne     @979e
        lda     $e0         ; set length of list
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ update list of equippable shields ]

GetValidShields:
@97d7:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        ldx     $00
        txy
@97e0:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @980a
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$03
        bne     @980a
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @980a
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@980a:  shorta
        iny
        cpy     #$00ff
        bne     @97e0
        lda     $e0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ select the best item in the list ]

GetBestEquip:
@9819:  phy
        phb
        lda     #$7e
        pha
        plb
        clr_ay
@9821:  clr_ax
@9823:  phx
        clr_a
        lda     $9d8a,y     ; position in inventory
        tax
        lda     $1869,x     ; item number
        plx
        cmp     $ed82e4,x   ; check imp items
        beq     @983c       ; branch if this is an imp item
        inx
        cpx     #$000a
        bne     @9823
        plb
        ply
        rts

; imp item
@983c:  iny
        bra     @9821

; ------------------------------------------------------------------------------

; [ select the best 2-handed weapon in the list ]

GetBest2Hand:
@983f:  lda     $7e9d89     ; branch if there are items in the list
        beq     @9881
        sta     $cb         ; +$cb = number of items in list
        stz     $cc
        clr_ay
@984b:  clr_ax
@984d:  phx
        clr_a
        tyx
        lda     $7e9d8a,x   ; position in inventory
        tax
        lda     $1869,x     ; item number
        plx
        cmp     $ed82e4,x   ; check imp items
        beq     @9878       ; branch if this is an imp item
        inx
        cpx     #$000a      ; number of imp items
        bne     @984d
        sta     $c9         ; $c9 = item number
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; 2-handed weapon
        and     #$40
        beq     @9878       ; branch if not 2-handed
        lda     $c9
        rts

; imp item
@9878:  iny
        cpy     $cb
        bne     @984b       ; branch if this is not the last item in the list
        jsr     GetBestEquip
        rts

; no suitable items
@9881:  lda     #$ff        ; empty
        rts

; ------------------------------------------------------------------------------

; [ menu state $55: equip (slot select, equip) ]

MenuState_55:
@9884:  jsr     UpdateEquipSlotCursor
        jsr     _c39975

; A button
        lda     $08
        bit     #$80
        beq     @98b4
        jsr     PlaySelectSfx
        lda     $4e                     ; save cursor position
        sta     $5f
        lda     #$57                    ; go to menu state $57
        sta     $26
        jsr     GetValidEquip
        jsr     SortValidEquip
        jsr     InitEquipListCursor
        lda     #$55                    ; return to menu state $55 afterwards
        sta     $27
        jsr     _c39233
        jsr     ClearBG1ScreenA
        jsr     WaitVblank
        jmp     DrawEquipItemList

; B button
@98b4:  lda     $09
        bit     #$80
        beq     @98c8
        jsr     PlayCancelSfx
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        lda     #$36                    ; go to menu state $36
        sta     $26
        rts
@98c8:  lda     #$7e                    ; go to menu state $7e if user presses top r or l button
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ menu state $56: equip (slot select, remove) ]

MenuState_56:
@98cf:  jsr     UpdateEquipSlotCursor
        lda     $08
        bit     #$80
        beq     @98f4
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $4b
        tay
        lda     $001f,y
        jsr     IncItemQty
        lda     #$ff
        sta     $001f,y
        jsr     _c3911b
@98f4:  lda     $09
        bit     #$80
        beq     @9908
        jsr     PlayCancelSfx
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        lda     #$36
        sta     $26
        rts
@9908:  lda     #$7f
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ menu state $57: equip (item select) ]

MenuState_57:
@990f:  jsr     _c39ad3
        jsr     _c39233
        lda     $08
        bit     #$80
        beq     @9944
        jsr     CheckCanEquipSelItem
        bcc     @996e
        jsr     PlaySelectSfx
        lda     $001f,y
        cmp     #$ff
        beq     @992d
        jsr     IncItemQty
@992d:  clr_a
        lda     $4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        sta     $001f,y
        jsr     DecItemQty
        jsr     _c3911b
        bra     @994d
@9944:  lda     $09
        bit     #$80
        beq     @996d
        jsr     PlayCancelSfx
@994d:  jsr     _c39c87
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$c1
        trb     $46
        jsr     LoadEquipSlotCursor
        lda     $5f
        sta     $4e
        jsr     InitEquipSlotCursor
        lda     #$55
        sta     $26
@996d:  rts
@996e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [ draw "r-hand" & "l-hand" text ]

_c39975:
@9975:  lda     $11d8       ; gauntlet effect
        and     #$08
        beq     @998f       ; branch if no gauntlet
        jsr     GetSelCharPropPtr
        lda     $001f,y     ; right hand (main hand)
        cmp     #$ff
        beq     @99a6       ; branch if empty
        lda     $0020,y     ; left hand (off-hand)
        cmp     #$ff
        beq     @99ca       ; branch if empty
        bra     @998f

; draw both hands with teal text
@998f:  lda     #$2c        ; teal text
        sta     $29
        jsr     @9998
        bra     @999f

; draw "R-Hand" text
@9998:  ldy     #.loword(EquipRHandText)
        jsr     DrawPosText
        rts

; draw "L-Hand" text
@999f:  ldy     #.loword(EquipLHandText)
        jsr     DrawPosText
        rts

; gauntlet, main hand empty
@99a6:  lda     $0020,y     ; left hand (off-hand)
        cmp     #$ff
        bne     @99af       ; branch if not empty
        bra     @998f       ; both hands empty, draw both with teal text

; gauntlet, right hand empty
@99af:  jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon effects
        and     #$40
        beq     @998f       ; branch if not 2-handed
        lda     #$24        ; gray text
        sta     $29
        jsr     @9998       ; draw "r-hand" text
        lda     #$2c        ; teal text
        sta     $29
        bra     @999f       ; draw "l-hand" text

; gauntlet, left hand empty
@99ca:  lda     $001f,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #$40
        beq     @998f
        lda     #$2c        ; teal text
        sta     $29
        jsr     @9998       ; draw "r-hand" text
        lda     #$24        ; gray text
        sta     $29
        bra     @999f       ; draw "l-hand" text

; ------------------------------------------------------------------------------

; [ update gauntlet & genji glove effects ]

; $cd = 1 for genji glove
; $a1 = 1 for gauntlet bonus
; carry set = no gauntlet bonus
; carry clear = gauntlet w/ 2-handed weapon & no shield

CheckHandEffects:
@99e8:  stz     $cd         ; $cd = 0
        lda     $11d8       ; branch if character doesn't have genji glove
        and     #$10
        beq     @99f3
        inc     $cd         ; $cd++
@99f3:  stz     $a1         ;
        lda     $11d8       ; branch if character doesn't have gauntlet
        and     #$08
        beq     @9a0c
        lda     $001f,y     ; branch if right hand is empty
        cmp     #$ff
        beq     @9a0e
        lda     $0020,y     ; branch if left hand is empty
        cmp     #$ff
        beq     @9a2b
        bra     @9a0c       ; set carry and return
@9a0c:  sec
        rts
@9a0e:  lda     $0020,y     ; branch if left hand is not empty
        cmp     #$ff
        bne     @9a17
        bra     @9a0c       ; set carry and return
@9a17:  jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon properties
        and     #$40
        beq     @9a0c       ; set carry and return if not a 2-handed weapon
        clc
        lda     #$01
        sta     $a1
        rts
@9a2b:  lda     $001f,y     ; right hand
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon properties
        and     #$40
        beq     @9a0c       ; set carry and return if not a 2-handed weapon
        clc
        lda     #$01
        sta     $a1
        rts

; ------------------------------------------------------------------------------

; [ check if selected item can be equipped ]

CheckCanEquipSelItem:
@9a42:  jsr     GetEquipSlotPtr
        clr_a
        lda     $4b                     ; cursor position
        bra     CheckCanEquipItem

; ------------------------------------------------------------------------------

; [ get pointer to current item slot ]

GetEquipSlotPtr:
@9a4a:  jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $5f                     ; add item slot number
        tay
        rts

; ------------------------------------------------------------------------------

; [ check if item can be equipped ]

;  a = position in list
; +y = pointer to current item slot
; carry set = item can be equipped, carry clear = item can't be equipped

CheckCanEquipItem:
@9a56:  phy
        tax
        lda     $7e9d8a,x               ; selected item
        tax
        lda     $1869,x                 ; item number
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; $f6 = item type
        and     #$07
        sta     $f6
        ply
        lda     $5f                     ; selected item slot
        cmp     #$02
        bcs     @9acf                   ; set carry and return if helmet or armor
        cmp     #$01
        beq     @9aa5

; right hand is selected
        lda     $0020,y                 ; left hand item
        cmp     #$ff
        beq     @9a97                   ; set carry and return if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     #$03
        beq     @9a99                   ; branch if shield
        lda     $11d8
        and     #$10
        beq     @9a99                   ; branch if character has genji glove effect
@9a97:  sec
        rts
@9a99:  lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     $f6                     ; clear carry and return if same as selected item
        beq     @9ad1
        sec
        rts

; left hand is selected
@9aa5:  lda     $001e,y                 ; right hand item
        cmp     #$ff
        beq     @9ac3                   ; set carry and return if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     #$03
        beq     @9ac5                   ; branch if shield
        lda     $11d8
        and     #$10
        beq     @9ac5                   ; branch if character has genji glove effect
@9ac3:  sec
        rts
@9ac5:  lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     $f6                     ; clear carry and return if same as selected item
        beq     @9ad1
@9acf:  sec
        rts
@9ad1:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39ad3:
@9ad3:  lda     $7e9d89
        cmp     #$0a
        bcs     @9ade
        jmp     UpdateEquipShortListCursor
@9ade:  lda     #$05
        sta     $2a
        jsr     ScrollListPage
        bcs     @9aea
        jmp     UpdateEquipLongListCursor
@9aea:  rts

; ------------------------------------------------------------------------------

; [ init item list cursor (equip/relic) ]

InitEquipListCursor:
@9aeb:  lda     $7e9d89
        beq     @9b0c
        cmp     #10
        bcs     @9b06

; short list (less than 10 items)
        jsr     CreateEquipSlotCursorTask
        stz     $4a
        jsr     LoadEquipShortListCursor
        lda     $7e9d89
        sta     $54
        jmp     InitEquipShortListCursor

; long list (10 or more items)
@9b06:  jsr     CreateEquipSlotCursorTask
        jsr     _c39b0d
@9b0c:  rts

; ------------------------------------------------------------------------------

; [  ]

_c39b0d:
@9b0d:  stz     $4a
        jsr     CreateScrollArrowTask2
        longa
        lda     #$0060
        sta     $7e34ca,x
        lda     #$6000
        sta     hWRDIVL
        shorta
        lda     $7e9d89
        sec
        sbc     #9
        sta     hWRDIVB
        nop5
        longa
        lda     hRDDIVL
        sta     $7e354a,x
        shorta
        ldy     $00
        sty     $4f
        jsr     LoadEquipLongListCursor
        jsr     InitEquipLongListCursor
        lda     $7e9d89
        sec
        sbc     #$09
        sta     $5c
        lda     #$09
        sta     $5a
        lda     #$01
        sta     $5b
        rts

; ------------------------------------------------------------------------------

; [ update list of equippable items ]

; $4b = cursor position (0 = weapon, 1 = shield, 2 = helmet, 3 = armor)

GetValidEquip:
@9b59:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        lda     #$20
        sta     $29
        lda     $4b         ; cursor position
        cmp     #$02
        beq     @9bb2       ; branch if helmet
        cmp     #$03
        beq     @9b6f       ; branch if armor
        bra     @9b72       ; branch if weapon or shield
@9b6f:  jmp     @9bee

; weapon or shield
@9b72:  ldx     $00
        txy
@9b75:  clr_a
        lda     $1869,y     ; item number
        cmp     #$ff
        beq     @9ba3       ; branch if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$01
        beq     @9b91       ; branch if weapon
        cmp     #$03
        bne     @9ba3       ; skip if not shield
@9b91:  longa
        lda     f:ItemProp+1,x   ; equippable characters
        bit     $e7
        beq     @9ba3       ; branch if not equippable
        shorta
        tya
        sta     hWMDATA       ; add to list of possible items
        inc     $e0         ; increment number of possible items
@9ba3:  shorta        ; next item
        iny
        cpy     #$00ff
        bne     @9b75
        lda     $e0         ; set length of list
        sta     $7e9d89
        rts

; helmet
@9bb2:  ldx     $00
        txy
@9bb5:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @9bdf
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$04
        bne     @9bdf
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @9bdf
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@9bdf:  shorta
        iny
        cpy     #$00ff
        bne     @9bb5
        lda     $e0
        sta     $7e9d89
        rts

; armor
@9bee:  ldx     $00
        txy
@9bf1:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @9c1b
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$02
        bne     @9c1b
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @9c1b
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@9c1b:  shorta
        iny
        cpy     #$00ff
        bne     @9bf1
        lda     $e0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ clear list of optimum items ]

ClearValidItemList:
@9c2a:  ldx     $00
        lda     #$ff
@9c2e:  sta     $7e9d8a,x
        inx
        cpx     #9
        bne     @9c2e
        ldx     #$9d8a
        stx     hWMADDL
        stz     $e0         ; $e0 = number of possible items
        rts

; ------------------------------------------------------------------------------

; [ get character equippability mask ]

; +$e7 = mask

GetCharEquipMask:
@9c41:  jsr     GetSelCharPropPtr
        clr_a
        lda     $0000,y                 ; actor number

chrequinf_get1:
_c39c48:
@9c48:  asl
        tax
        longa
        lda     f:CharEquipMaskTbl,x
        sta     $e7
        shorta
        lda     $11d8
        and     #$20
        beq     @9c66
        longa
        lda     $e7
        ora     #$8000
        sta     $e7
        shorta
@9c66:  rts

; ------------------------------------------------------------------------------

; character equippability masks
CharEquipMaskTbl:
@9c67:  .word   $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        .word   $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

; ------------------------------------------------------------------------------

; [ clear modified stats text ]

_c39c87:
@9c87:  clr_ax
        ldy     #$0009      ; clear 9 lines
        longa
@9c8e:  sta     $7e7cbf,x   ; clear 100's digit
        inx2
        sta     $7e7cbf,x   ; clear 10's digit
        inx2
        sta     $7e7cbf,x   ; clear 1's digit
        inx2
        txa
        clc
        adc     #$007a      ; next line
        tax
        dey
        bne     @9c8e
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw item list text (equip/relic) ]

DrawEquipItemList:
@9cac:  lda     $7e9d89
        beq     @9cdd
        jsr     GetListTextPos
        clr_a
        lda     $7e9d89
        cmp     #$09
        bcc     @9cc0
        lda     #$09
@9cc0:  tay
@9cc1:  phy
        jsr     DrawEquipItemListRow
        inc     $e5
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @9cc1
        longa
        clr_a
        sta     $7e9bd0
        shorta
        rts
@9cdd:  lda     $27
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ draw one row of equip item list ]

DrawEquipItemListRow:
@9ce2:  jsr     GetEquipSlotPtr
        clr_a
        lda     $e5
        jsr     CheckCanEquipItem
        bcs     @9cf1
        lda     #$28
        bra     @9cf3
@9cf1:  lda     #$20
@9cf3:  sta     $29
        lda     $e6
        inc
        ldx     #$0002
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tay
        jsr     LoadEquipListItemName
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ load item name for equip item list ]

LoadEquipListItemName:
@9d11:  ldx     #$9e8b
        stx     hWMADDL
@9d17:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @9d17
        tyx
        clr_a
        lda     $7e9d8a,x
        tay
        lda     $1869,y
        cmp     #$ff
        beq     @9d4f
        sta     hM7A
        stz     hM7A
        lda     #13
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #13
@9d40:  lda     f:ItemName,x
        sta     hWMDATA
        inx
        dey
        bne     @9d40
        stz     hWMDATA
        rts
@9d4f:  ldy     #13
        lda     #$ff
@9d54:  sta     hWMDATA
        dey
        bne     @9d54
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ add item to inventory ]

; A: item id

IncItemQty:
@9d5e:  phy
        sta     $e0
        ldy     $00
@9d63:  cmp     $1869,y
        beq     @9d8a
        cmp     #$ff
        beq     @9d95
        iny
        cpy     #$0100
        bne     @9d63
        ldy     $00
@9d74:  lda     $1869,y
        cmp     #$ff
        beq     @9d7e
        iny
        bra     @9d74
@9d7e:  lda     #1
        sta     $1969,y
        lda     $e0
        sta     $1869,y
        bra     @9d95
@9d8a:  lda     $1969,y
        cmp     #99
        beq     @9d95
        inc
        sta     $1969,y
@9d95:  ply
        rts

; ------------------------------------------------------------------------------

; [ remove item from inventory ]

; A: item id

DecItemQty:
@9d97:  phy
        sta     $e0
        ldy     $00
@9d9c:  cmp     $1869,y
        beq     @9da9
        iny
        cpy     #$0100
        bne     @9d9c
        ply
        rts
@9da9:  lda     $1969,y
        cmp     #1
        beq     @9db9
        lda     $1969,y
        dec
        sta     $1969,y
        bra     @9dc2
@9db9:  clr_a
        sta     $1969,y
        lda     #$ff
        sta     $1869,y
@9dc2:  ply
        rts

; ------------------------------------------------------------------------------

; [ create cursor task for equip menu slot cursor ]

CreateEquipSlotCursorTask:
@9dc4:  lda     #2
        ldy     #.loword(EquipSlotCursorTask)
        jsr     CreateTask
        longa
        lda     $55
        sta     $7e33ca,x
        lda     $57
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask:
@9ddd:  tax
        jmp     (.loword(EquipSlotCursorTaskTbl),x)

EquipSlotCursorTaskTbl:
@9de1:  .addr   EquipSlotCursorTask_00
        .addr   EquipSlotCursorTask_01

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask_00:
@9de5:  ldx     $2d
        lda     #$01
        tsb     $46
        longa
        lda     #.loword(CursorAnimData)
        sta     $32c9,x
        shorta
        lda     #^CursorAnimData
        sta     $35ca,x
        jsr     InitAnimTask
        inc     $3649,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask_01:
@9e00:  lda     $46
        bit     #$01
        beq     @9e0d
        ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts
@9e0d:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39e0f:
@9e0f:  jsr     _c39e23
        bra     _c39e37

; ------------------------------------------------------------------------------

; [  ]

_c39e14:
@9e14:  jsr     _c39e37
        lda     $021e
        and     #$01
        beq     @9e20
        bra     _c39e23
@9e20:  jmp     TfrBigTextGfx

; ------------------------------------------------------------------------------

; [  ]

_c39e23:
@9e23:  ldy     #$4000
        sty     $1b
        ldy     #$7849
        sty     $1d
        lda     #$7e
        sta     $1f
        ldy     #$0880
        sty     $19
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39e37:
@9e37:  ldy     #$0000
        sty     $14
        ldy     #$3849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$0800
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ menu state $58:  ]

MenuState_58:
@9e4b:  jsr     _c39e50
        bra     _c39e6f

; ------------------------------------------------------------------------------

; [  ]

_c39e50:
@9e50:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        stz     $4a
        stz     $49
        lda     #$10
        tsb     $45
        stz     $99
        jsr     InitBigText
        jsr     InitEquipScrollHDMA
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        jmp     CreateCursorTask

; ------------------------------------------------------------------------------

; [  ]

_c39e6f:
@9e6f:  jsr     DrawRelicMenu
        lda     #$01
        sta     $26
        lda     #$59
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $79:  ]

MenuState_79:
@9e7d:  jsr     _c39e99
        jsr     DrawEquipTitleEquip
        jsr     _c39ea8
        lda     #$5a
        jmp     _c39eb3

; ------------------------------------------------------------------------------

; [ menu state $7a:  ]

MenuState_7a:
@9e8b:  jsr     _c39e99
        jsr     DrawEquipTitleRemove
        jsr     _c39ea8
        lda     #$5c
        jmp     _c39eb3

; ------------------------------------------------------------------------------

; [  ]

_c39e99:
@9e99:  jsr     _c39e50
        jsr     DrawRelicMenu
        jsr     _c39e37
        jsr     _c39e23
        jmp     _c39614

; ------------------------------------------------------------------------------

; [  ]

_c39ea8:
@9ea8:  jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$01
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39eb3:
@9eb3:  sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $59: relic options (equip/remove) ]

MenuState_59:
@9eb8:  jsr     _c39e23
        jsr     _c3960c
        jsr     DrawRelicOptions
        jsr     UpdateRelicOptionCursor
        lda     $08
        bit     #$80
        beq     @9ed0
        jsr     PlaySelectSfx
        jmp     SelectRelicOption
@9ed0:  lda     $09
        bit     #$80
        beq     @9edc
        jsr     PlayCancelSfx
        jsr     _c39eeb
@9edc:  jsr     _c39ee6
        lda     #$58
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [  ]

_c39ee6:
@9ee6:  lda     $26
        sta     $d1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39eeb:
@9eeb:  jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        lda     $0000,y
        cmp     #$0d
        beq     @9eff
        jsr     _c39f5c
        lda     $99
        bne     @9f06
@9eff:  lda     #$04
        sta     $27
        stz     $26
        rts
@9f06:  lda     #$06
        trb     $46
        jsr     _c39e37
        jsr     _c39e23
        jsr     _c39f1c
        lda     #$f0
        sta     $22
        lda     #$6c
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39f1c:
@9f1c:  jsr     ClearEquipOptionText
        ldy     #.loword(_c3a40f)
        jsr     DrawPosText
        lda     $1d4e
        and     #$10
        beq     @9f44
        lda     #$6e
        sta     $27
        lda     $d1
        cmp     #$59
        beq     @9f3d
        ldy     #.loword(_c3a3fd)
        jsr     DrawPosText
        rts
@9f3d:  ldy     #.loword(_c3a3eb)
        jsr     DrawPosText
        rts
@9f44:  lda     #$6d
        sta     $27
        lda     $d1
        cmp     #$59
        beq     @9f55
        ldy     #.loword(_c3a405)
        jsr     DrawPosText
        rts
@9f55:  ldy     #.loword(_c3a3f3)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39f5c:
@9f5c:  jsr     GetSelCharPropPtr
        lda     $0023,y
        cmp     $b0
        bne     @9f6f
        lda     $0024,y
        cmp     $b1
        bne     @9f6f
        bra     @9fa9
@9f6f:  lda     $b0
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
        lda     $b1
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
        lda     $0023,y
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
        lda     $0024,y
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
@9fa9:  stz     $99
        rts
@9fac:  lda     #$01
        sta     $99
        rts

; ------------------------------------------------------------------------------

; [ menu state $6c:  ]

MenuState_6c:
@9fb1:  lda     $22
        bne     @9fb8
        stz     $26
        rts
@9fb8:  dec     $22
        lda     $08
        bit     #$10
        bne     @9fcc
        lda     $08
        bit     #$20
        bne     @9fcc
        lda     $09
        bit     #$80
        beq     @9fce
@9fcc:  stz     $26
@9fce:  rts

; ------------------------------------------------------------------------------

; [ select relic option (equip, remove) ]

SelectRelicOption:
@9fcf:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectRelicOptionTbl),x)

SelectRelicOptionTbl:
@9fd7:  .addr   SelectRelicOption_00
        .addr   SelectRelicOption_01

; ------------------------------------------------------------------------------

; [ 0: equip ]

SelectRelicOption_00:
@9fdb:  jsr     _c39614
        jsr     DrawEquipTitleEquip
        jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$5a
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ 1: remove ]

SelectRelicOption_01:
@9fec:  jsr     _c39614
        jsr     DrawEquipTitleRemove
        jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$5c
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $5a: relic slot select ]

MenuState_5a:
@9ffd:  jsr     _c39e14
        jsr     UpdateRelicSlotCursor
        lda     $08
        bit     #$80
        beq     @a033
        jsr     PlaySelectSfx
        lda     $4e
        sta     $5f
        lda     #$5b
        sta     $26
        jsr     _c3a051
        jsr     SortValidEquip
        jsr     InitEquipListCursor
        lda     #$5a
        sta     $27
        jsr     ClearBG1ScreenA
        jsr     WaitVblank
        jsr     DrawEquipItemList
        jsr     _c39233
        jsr     _c39e23
        jmp     WaitVblank
@a033:  lda     $09
        bit     #$80
        beq     @a047
        jsr     PlayCancelSfx
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        lda     #$59
        sta     $26
        rts
@a047:  jsr     _c39ee6
        lda     #$79
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [  ]

_c3a051:
@a051:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        lda     #$20
        sta     $29
        ldx     $00
        txy
@a05e:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @a088
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$05
        bne     @a088
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @a088
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@a088:  shorta
        iny
        cpy     #$0100
        bne     @a05e
        lda     $e0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ menu state $5b:  ]

MenuState_5b:
@a097:  lda     #$10
        trb     $45
        jsr     _c39e14
        jsr     _c39ad3
        jsr     _c39233
        jsr     _c3a1d8
        lda     $08
        bit     #$80
        beq     @a0dc
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $5f
        tay
        lda     $0023,y
        cmp     #$ff
        beq     @a0c5
        jsr     IncItemQty
@a0c5:  clr_a
        lda     $4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        sta     $0023,y
        jsr     DecItemQty
        jsr     _c39131
        bra     @a0e5
@a0dc:  lda     $09
        bit     #$80
        beq     @a109
        jsr     PlayCancelSfx
@a0e5:  lda     #$10
        tsb     $45
        jsr     _c39c87
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$c1
        trb     $46
        jsr     LoadRelicSlotCursor
        lda     $5f
        sta     $4e
        jsr     InitRelicSlotCursor
        lda     #$5a
        sta     $26
@a109:  rts

; ------------------------------------------------------------------------------

; [ menu state $5c:  ]

MenuState_5c:
@a10a:  jsr     _c39e23
        jsr     UpdateRelicSlotCursor
        lda     $08
        bit     #$80
        beq     @a132
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $4b
        tay
        lda     $0023,y
        jsr     IncItemQty
        lda     #$ff
        sta     $0023,y
        jsr     _c39131
@a132:  lda     $09
        bit     #$80
        beq     @a146
        jsr     PlayCancelSfx
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        lda     #$59
        sta     $26
        rts
@a146:  jsr     _c39ee6
        lda     #$7a
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ sort items by attack/defense power ]

SortValidEquip:
@a150:  ldx     #$ac8d
        stx     hWMADDL
        lda     $7e9d89
        beq     @a186
        cmp     #$01
        beq     @a186
        sta     $e7
        stz     $e8
        clr_axy
@a167:  lda     $7e9d8a,x
        phx
        tay
        lda     $1869,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x   ; attack/defense power
        sta     hWMDATA
        plx
        inx
        cpx     $e7
        bne     @a167
        jsr     _c3a187
@a186:  rts

; ------------------------------------------------------------------------------

; [ put item list in order of decreasing attack/defense power ]

_c3a187:
@a187:  dec     $e7
        phb
        lda     #$7e
        pha
        plb
        clr_ay
@a190:  clr_ax
@a192:  lda     $ac8d,x     ; item number
        cmp     $ac8e,x
        bcs     @a1b7
        sta     $e0
        lda     $9d8a,x
        sta     $e1
        lda     $ac8e,x
        sta     $ac8d,x
        lda     $9d8b,x
        sta     $9d8a,x
        lda     $e0
        sta     $ac8e,x
        lda     $e1
        sta     $9d8b,x
@a1b7:  inx                 ;
        cpx     $e7
        bne     @a192
        iny                 ;
        cpy     $e7
        bne     @a190
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

@a1c3:  jsr     GetItemDescPtr
        jsr     GetSelCharPropPtr
        lda     $4b
        bne     @a1d2
        lda     $0023,y
        bra     @a1d5
@a1d2:  lda     $0024,y
@a1d5:  jmp     LoadItemDesc

; ------------------------------------------------------------------------------

; [  ]

_c3a1d8:
@a1d8:  jsr     GetItemDescPtr
        clr_a
        lda     $4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        jmp     LoadItemDesc

; ------------------------------------------------------------------------------

; pointers to party equip screen slot names
@a1ea:  .word   $a21a,$a21f,$a225,$a22b,$a231,$a237,$a23d,$a242
        .word   $a248,$a24e,$a254,$a25a,$a260,$a265,$a26b,$a271
        .word   $a277,$a27d,$a283,$a288,$a28e,$a294,$a29a,$a2a0

; party equip screen slot names (used in Japanese version only)
@a21a:  .byte   $4f,$39,$9f,$2d,$00
@a21f:  .byte   $6b,$39,$63,$3f,$a9,$00
@a225:  .byte   $cf,$39,$8b,$7f,$9d,$00
@a22b:  .byte   $eb,$39,$6b,$a7,$3f,$00
@a231:  .byte   $4f,$3a,$8a,$6e,$54,$00
@a237:  .byte   $6b,$3a,$8a,$6e,$55,$00
@a23d:  .byte   $4f,$3b,$9f,$2d,$00
@a242:  .byte   $6b,$3b,$63,$3f,$a9,$00
@a248:  .byte   $cf,$3b,$8b,$7f,$9d,$00
@a24e:  .byte   $eb,$3b,$6b,$a7,$3f,$00
@a254:  .byte   $4f,$3c,$8a,$6e,$54,$00
@a25a:  .byte   $6b,$3c,$8a,$6e,$55,$00
@a260:  .byte   $4f,$3d,$9f,$2d,$00
@a265:  .byte   $6b,$3d,$63,$3f,$a9,$00
@a26b:  .byte   $cf,$3d,$8b,$7f,$9d,$00
@a271:  .byte   $eb,$3d,$6b,$a7,$3f,$00
@a277:  .byte   $4f,$3e,$8a,$6e,$54,$00
@a27d:  .byte   $6b,$3e,$8a,$6e,$55,$00
@a283:  .byte   $4f,$3f,$9f,$2d,$00
@a288:  .byte   $6b,$3f,$63,$3f,$a9,$00
@a28e:  .byte   $cf,$3f,$8b,$7f,$9d,$00
@a294:  .byte   $eb,$3f,$6b,$a7,$3f,$00
@a29a:  .byte   $4f,$40,$8a,$6e,$54,$00
@a2a0:  .byte   $6b,$40,$8a,$6e,$55,$00

; ------------------------------------------------------------------------------

EquipOptionTextList:
@a2a6:  .addr   EquipOptionEquipText
        .addr   EquipOptionOptimumText
        .addr   EquipOptionRemoveText
        .addr   EquipOptionEmptyText

EquipSlotTextList:
@a2ae:  .addr   EquipHeadText
        .addr   EquipBodyText

RelicOptionTextList:
@a2b2:  .addr   RelicOptionEquipText
        .addr   RelicOptionRemoveText

RelicSlotTextList:
@a2b6:  .addr   EquipRelic1Text
        .addr   EquipRelic2Text

; c3/a2ba: "R-Hand"
EquipRHandText:
@a2ba:  .byte   $0d,$7a,$91,$c4,$a1,$9a,$a7,$9d,$00

; c3/a2c3: "L-Hand"
EquipLHandText:
@a2c3:  .byte   $8d,$7a,$8b,$c4,$a1,$9a,$a7,$9d,$00

; c3/a2cc: "Head"
EquipHeadText:
@a2cc:  .byte   $0d,$7b,$87,$9e,$9a,$9d,$00

; c3/a2d3: "Body"
EquipBodyText:
@a2d3:  .byte   $8d,$7b,$81,$a8,$9d,$b2,$00

; c3/a2da: "Relic"
EquipRelic1Text:
@a2da:  .byte   $0d,$7b,$91,$9e,$a5,$a2,$9c,$00

; c3/a2e2: "Relic"
EquipRelic2Text:
@a2e2:  .byte   $8d,$7b,$91,$9e,$a5,$a2,$9c,$00

; blank text for equip options and title
EquipBlankOptionsText:
@a2ea:  .byte   $0d,$79,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        .byte   $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

; c3/a309: "EQUIP"
EquipTitleEquipText:
@a309:  .byte   $39,$79,$84,$90,$94,$88,$8f,$00

; c3/a311: "REMOVE"
EquipTitleRemoveText:
@a311:  .byte   $39,$79,$91,$84,$8c,$8e,$95,$84,$00

; c3/a31a: "EQUIP"
EquipOptionEquipText:
@a31a:  .byte   $0d,$79,$84,$90,$94,$88,$8f,$00

; c3/a322: "OPTIMUM"
EquipOptionOptimumText:
@a322:  .byte   $1b,$79,$8e,$8f,$93,$88,$8c,$94,$8c,$00

; c3/a32c: "RMOVE"
EquipOptionRemoveText:
@a32c:  .byte   $2d,$79,$91,$8c,$8e,$95,$84,$00

; c3/a334: "EMPTY"
EquipOptionEmptyText:
@a334:  .byte   $3b,$79,$84,$8c,$8f,$93,$98,$00

; c3/a33c: "EQUIP"
RelicOptionEquipText:
@a33c:  .byte   $11,$79,$84,$90,$94,$88,$8f,$00

; c3/a344: "REMOVE"
RelicOptionRemoveText:
@a344:  .byte   $1f,$79,$91,$84,$8c,$8e,$95,$84,$00

; ------------------------------------------------------------------------------

EquipStatTextList1:
@a34d:  .addr   EquipStrengthText
        .addr   EquipStaminaText
        .addr   EquipMagPwrText
        .addr   EquipEvadeText
        .addr   EquipMagEvadeText
        .addr   EquipArrow1Text
        .addr   EquipArrow2Text
        .addr   EquipArrow3Text
        .addr   EquipArrow4Text
        .addr   EquipArrow5Text
        .addr   EquipArrow6Text
        .addr   EquipArrow7Text
        .addr   EquipArrow8Text
        .addr   EquipArrow9Text

EquipStatTextList2:
@a369:  .addr   EquipSpeedText
        .addr   EquipAttackPwrText
        .addr   EquipDefenseText
        .addr   EquipMagDefText

; "Vigor"
EquipStrengthText:
@a371:  .byte   $a9,$7c,$95,$a2,$a0,$a8,$ab,$00

; "Stamina"
EquipStaminaText:
@a379:  .byte   $a9,$7d,$92,$ad,$9a,$a6,$a2,$a7,$9a,$00

; "Mag.Pwr"
EquipMagPwrText:
@a383:  .byte   $29,$7e,$8c,$9a,$a0,$c5,$8f,$b0,$ab,$00

; "Evade %"
EquipEvadeText:
@a38d:  .byte   $a9,$7f,$84,$af,$9a,$9d,$9e,$ff,$cd,$00

; MBlock%
EquipMagEvadeText:
@a397:  .byte   $a9,$80,$8c,$81,$a5,$a8,$9c,$a4,$cd,$00

; right arrows
EquipArrow1Text:
@a3a1:  .byte   $bd,$7c,$d5,$00

EquipArrow2Text:
@a3a5:  .byte   $3d,$7d,$d5,$00

EquipArrow3Text:
@a3a9:  .byte   $bd,$7d,$d5,$00

EquipArrow4Text:
@a3ad:  .byte   $3d,$7e,$d5,$00

EquipArrow5Text:
@a3b1:  .byte   $3d,$7f,$d5,$00

EquipArrow6Text:
@a3b5:  .byte   $bd,$7f,$d5,$00

EquipArrow7Text:
@a3b9:  .byte   $bd,$7e,$d5,$00

EquipArrow8Text:
@a3bd:  .byte   $3d,$80,$d5,$00

EquipArrow9Text:
@a3c1:  .byte   $bd,$80,$d5,$00

; "Speed"
EquipSpeedText:
@a3c5:  .byte   $29,$7d,$92,$a9,$9e,$9e,$9d,$00

; "Bat.Pwr"
EquipAttackPwrText:
@a3cd:  .byte   $a9,$7e,$81,$9a,$ad,$c5,$8f,$b0,$ab,$00

; "Defense"
EquipDefenseText:
@a3d7:  .byte   $29,$7f,$83,$9e,$9f,$9e,$a7,$ac,$9e,$00

; "Mag.Def"
EquipMagDefText:
@a3e1:  .byte   $29,$80,$8c,$9a,$a0,$c5,$83,$9e,$9f,$00

; ------------------------------------------------------------------------------

; "Empty"
_c3a3eb:
@a3eb:  .byte   $23,$79,$84,$a6,$a9,$ad,$b2,$00

; "Optimum"
_c3a3f3:
@a3f3:  .byte   $21,$79,$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00

; "Empty"
_c3a3fd:
@a3fd:  .byte   $a3,$79,$84,$a6,$a9,$ad,$b2,$00

; "Optimum"
_c3a405:
@a405:  .byte   $a1,$79,$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00

; "Equipment changed."
_c3a40f:
@a40f:  .byte   $15,$7a,$84,$aa,$ae,$a2,$a9,$a6,$9e,$a7,$ad,$ff,$9c,$a1,$9a,$a7
        .byte   $a0,$9e,$9d,$c5,$00

; ------------------------------------------------------------------------------

; [ init controller ]

InitCtrl:
@a424:  lda     #$08                    ; set direction button repeat delay (8 frames)
        sta     $0229
        lda     #$03                    ; set button repeat rate (3 frames/repeat)
        sta     $022a
        sta     $0226
        lda     #$20                    ; set a button repeat delay (32 frames)
        sta     $0225
        lda     $1d54                   ; branch if no special button configuration
        and     #$40
        beq     @a441
        jsr     SetCustomBtnMap
        rtl
@a441:  jsr     SetDefaultBtnMap
        rtl

; ------------------------------------------------------------------------------

; [ update controller (battle) ]

UpdateCtrlBattle:
@a445:  lda     $1d54
        bpl     @a458
        clr_a
        lda     $0201
        tax
        lda     $1d4f
        and     f:_c3a53d,x
        bne     @a45d
@a458:  ldx     hSTDCNTRL1L
        bra     @a462
@a45d:  ldx     hSTDCNTRL2L
        bra     @a462
@a462:  jsr     _c3a483
        jsr     _c3a4bd
        jsr     _c3a4f6
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [ update controller (menu) ]

UpdateCtrlMenu:
@a46e:  ldx     hSTDCNTRL1L
        jsr     _c3a483
        jsr     _c3a4bd
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [ update controller (field/world) ]

UpdateCtrlField:
@a47a:  ldx     hSTDCNTRL1L
        jsr     _c3a483
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [  ]

joy_getsub:
_c3a483:
@a483:  ldy     $e0                     ; push dp variables
        sty     $0213
        ldy     $e7
        sty     $0215
        ldy     $e9
        sty     $0217
        ldy     $eb
        sty     $0219
        stx     $eb
        longa
        lda     $0c
        and     #$fff0
        sta     $e0
        jsr     _c3a541
        lda     $0c
        eor     #$ffff
        and     $06
        sta     $08
        ldy     $06
        sty     $0c
        lda     hSTDCNTRL1L
        ora     hSTDCNTRL2L
        sta     $04
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4bd:
@a4bd:  longa
        lda     $06
        and     #$fff0
        cmp     $e0
        shorta
        bne     @a4e5
        lda     $0227
        beq     @a4d4
        dec     $0227
        bne     @a4f1
@a4d4:  dec     $0228
        bne     @a4f1
        lda     $022a
        sta     $0228
        ldy     $06
        sty     $0a
        bra     @a4f5
@a4e5:  lda     $0229
        sta     $0227
        lda     $022a
        sta     $0228
@a4f1:  ldy     $08
        sty     $0a
@a4f5:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4f6:
@a4f6:  lda     $06
        bit     #$80
        beq     @a517
        lda     $0225
        beq     @a506
        dec     $0225
        bne     @a522
@a506:  dec     $0226
        bne     @a522
        lda     $022a
        sta     $0226
        lda     #$80
        tsb     $0a
        bra     @a526
@a517:  lda     #$20
        sta     $0225
        lda     $022a
        sta     $0226
@a522:  lda     $08
        sta     $0a
@a526:  rts

; ------------------------------------------------------------------------------

; [ pop dp variables used for joypad ]

joy_sub3:
_c3a527:
@a527:  ldy     $0213
        sty     $e0
        ldy     $0215
        sty     $e7
        ldy     $0217
        sty     $e9
        ldy     $0219
        sty     $eb
        clr_a
        rtl

; ------------------------------------------------------------------------------

_c3a53d:
@a53d:  .byte   $01,$02,$04,$08

; ------------------------------------------------------------------------------

; [  ]

.a16

_c3a541:
@a541:  lda     $eb
        and     #$0f00
        sta     $06
        lda     #$0080
        sta     $e7
        lda     #$8000
        sta     $e9
        ldy     $00
        jsr     _c3a581
        lda     #$0040
        sta     $e7
        lda     #$4000
        sta     $e9
        iny
        jsr     _c3a581
        lda     #$0020
        sta     $e7
        lda     #$0010
        sta     $e9
        iny
        jsr     _c3a581
        lda     #$1000
        sta     $e7
        lda     #$2000
        sta     $e9
        iny
        jmp     _c3a581

.a8

; ------------------------------------------------------------------------------

; [  ]

_c3a581:
@a581:  lda     $eb
        bit     $e7
        beq     @a59b
        clr_a
        shorta
        lda     $0220,y
        and     #$f0
        longa
        lsr3
        tax
        lda     f:_c3a5b4,x
        tsb     $06
@a59b:  lda     $eb
        bit     $e9
        beq     @a5b3
        clr_a
        shorta
        lda     $0220,y
        and     #$0f
        longa
        asl
        tax
        lda     f:_c3a5b4,x
        tsb     $06
@a5b3:  rts

; ------------------------------------------------------------------------------

_c3a5b4:
@a5b4:  .word   $1000,$0080,$8000,$0040,$4000,$0020,$0010,$2000

; ------------------------------------------------------------------------------

; [ set custom button mapping ]

SetCustomBtnMap:
@a5c4:  ldy     $1d50
        sty     $0220
        ldy     $1d52
        sty     $0222
        rts

; ------------------------------------------------------------------------------

; [ set default button mapping ]

SetDefaultBtnMap:
@a5d1:  ldy     #$3412
        sty     $0220
        ldy     #$0656
        sty     $0222
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a5de:
@a5de:  clr_ax
        longa
@a5e2:  sta     $7ea271,x
        inx2
        sta     $7ea271,x
        inx2
        cpx     #$0240
        bne     @a5e2
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a5f6:
@a5f6:  jsr     _c3a600
        lda     #$01
        trb     $45
        jmp     TfrVRAM2

; ------------------------------------------------------------------------------

; [  ]

_c3a600:
@a600:  sty     $1b
        ldy     #$a271
        sty     $1d
        ldy     #$0120
        sty     $19
        lda     #$7e
        sta     $1f
        rts

; ------------------------------------------------------------------------------

; [  ]

@a611:  ldx     #$7849
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$0598
        sty     $e7
        ldy     #$0580
        ldx     #$2410
        stx     $e0
        jsr     _c3a783
        ldy     #$05d8
        sty     $e7
        ldy     #$05c0
        ldx     #$2411
        stx     $e0
        jsr     _c3a783
        rts

; ------------------------------------------------------------------------------

; [  ]

@a63b:  jsr     _c3a5de
        stz     $8d
        stz     $ed
        stz     $ee
        lda     #$06
        sta     $f1
        ldx     $00
@a64a:  lda     $7e9e89,x
        jsr     GetLetter
        phx
        jsr     CopyLetterGfx
        plx
        inx
        dec     $f1
        bne     @a64a
        ldy     #$2080
        jsr     _c3a600
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a662:
@a662:  ldx     #$8049
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$00bc
        sty     $e7
        ldy     #$0084
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$00fc
        sty     $e7
        ldy     #$00c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$013c
        sty     $e7
        ldy     #$0104
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$017c
        sty     $e7
        ldy     #$0144
        ldx     #$3539
        stx     $e0
        jmp     _c3a783

; ------------------------------------------------------------------------------

; [  ]

_c3a6ab:
@a6ab:  ldx     #$7849
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$01bc
        sty     $e7
        ldy     #$0184
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$01fc
        sty     $e7
        ldy     #$01c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$023c
        sty     $e7
        ldy     #$0204
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$027c
        sty     $e7
        ldy     #$0244
        ldx     #$3539
        stx     $e0
        jmp     _c3a783

; ------------------------------------------------------------------------------

; [  ]

_c3a6f4:
@a6f4:  ldx     #$7849
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$04bc
        sty     $e7
        ldy     #$0484
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$04fc
        sty     $e7
        ldy     #$04c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$053c
        sty     $e7
        ldy     #$0504
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$057c
        sty     $e7
        ldy     #$0544
        ldx     #$3539
        stx     $e0
        jmp     _c3a783

; ------------------------------------------------------------------------------

; [  ]

_c3a73d:
@a73d:  ldx     #$7849
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$01bc
        sty     $e7
        ldy     #$0184
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$01fc
        sty     $e7
        ldy     #$01c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$023c
        sty     $e7
        ldy     #$0204
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$027c
        sty     $e7
        ldy     #$0244
        ldx     #$3539
        stx     $e0
; fall through

; ------------------------------------------------------------------------------

; [  ]

_c3a783:
@a783:  longa
@a785:  lda     $e0
        sta     [$eb],y
        inc     $e0
        inc     $e0
        iny2
        cpy     $e7
        bne     @a785
        shorta
        rts

; ------------------------------------------------------------------------------

; [ clear description text graphics buffer ]

ClearBigTextBuf:
@a796:  phb
        lda     #$7e
        pha
        plb
        clr_ax
        longa
@a79f:  stz     $a271,x     ; clear $7ea271-$7ea970
        stz     $a273,x
        stz     $a275,x
        stz     $a277,x
        stz     $a279,x
        stz     $a27b,x
        stz     $a27d,x
        stz     $a27f,x
        stz     $a281,x
        stz     $a283,x
        stz     $a285,x
        stz     $a287,x
        stz     $a289,x
        stz     $a28b,x
        stz     $a28d,x
        stz     $a28f,x
        stz     $a291,x
        stz     $a293,x
        stz     $a295,x
        stz     $a297,x
        stz     $a299,x
        stz     $a29b,x
        stz     $a29d,x
        stz     $a29f,x
        stz     $a2a1,x
        stz     $a2a3,x
        stz     $a2a5,x
        stz     $a2a7,x
        stz     $a2a9,x
        stz     $a2ab,x
        stz     $a2ad,x
        stz     $a2af,x
        txa
        clc
        adc     #$0040
        tax
        cpx     #$0700
        bne     @a79f
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [ description text task ]

; +$33ca = current text string position (+$7e9ec9)
; +$344a = pointer to text graphics buffer (+$7ea271)

BigTextTask:
@a80e:  tax
        jmp     (.loword(BigTextTaskTbl),x)

; task jump table
BigTextTaskTbl:
@a812:  .addr   BigTextTask_00
        .addr   BigTextTask_01
        .addr   BigTextTask_02

; ------------------------------------------------------------------------------

; [ task state $00: init/reset ]

BigTextTask_00:
@a818:  jsr     ClearBigTextBuf
; fall through

; ------------------------------------------------------------------------------

; [ task state $02: wait ]

BigTextTask_02:
@a81b:  stz     $8d                     ;
        ldx     $2d                     ; task data pointer
        lda     #$01
        sta     $3649,x                 ; set task state to 1
        clr_a
        longa
        sta     $33ca,x                 ;
        sta     $344a,x                 ;
        shorta
; fall through

; ------------------------------------------------------------------------------

; [ task state $01: write letters (one per frame) ]

BigTextTask_01:
@a82f:  lda     $26                     ; menu state
        cmp     #$17
        beq     @a88d                   ; branch if (item, sort, rare)
        lda     $46
        and     #$c0                    ; branch if page can't scroll up or down
        beq     @a841
        lda     $06                     ; branch if top l or r buttons is down
        and     #$30
        bne     @a895
@a841:  lda     $45                     ;
        bit     #$20
        bne     @a84d
        lda     $07                     ; branch if a direction button is down
        and     #$0f
        bne     @a895
@a84d:  lda     $45                     ;
        bit     #$10
        bne     @a895
        ldy     $2d                     ; task data pointer
        ldx     $344a,y                 ; +$ed = pointer to text graphics buffer
        stx     $ed
        ldx     $33ca,y                 ; pointer to text buffer
        lda     $7e9ec9,x               ; get next letter
        beq     @a89c                   ; branch if end of string
        cmp     #$01
        bne     @a875                   ; branch if not new line
        stz     $8d
        longa
        lda     #$0380                  ; set graphics buffer pointer to beginning of second line
        sta     $344a,y
        shorta
        bra     @a87d

; write letter
@a875:  jsr     GetLetter
        phx
        jsr     CopyLetterGfx
        plx
@a87d:  inx                 ; increment text string position
        ldy     $2d
        longa
        txa
        sta     $33ca,y
        shorta
        jsr     TfrBigTextGfx
        sec
        rts

; item, sort, rare (terminate task)
@a88d:  jsr     ClearBigTextBuf
        jsr     TfrBigTextGfx
        clc                 ; terminate task
        rts

; direction button or l or r button pressed (reset text)
@a895:  ldx     $2d
        stz     $3649,x     ; set task state to 0
        sec
        rts

; end of string
@a89c:  lda     #$01        ; enable color palette dma at vblank
        tsb     $45
        ldx     $2d         ; set task state to 2
        lda     #$02
        sta     $3649,x
        sec
        rts

; ------------------------------------------------------------------------------

; [ get text letter ]

GetLetter:
@a8a9:  sec
        sbc     #$80
        stz     $eb
        stz     $ec
        rts

; ------------------------------------------------------------------------------

; [ copy letter graphics to vram buffer ]

CopyLetterGfx:
@a8b1:  pha
        sta     f:hWRMPYA
        lda     #$16
        sta     f:hWRMPYB
        lda     #11
        sta     $e5
        longa
        lda     f:hRDMPYL
        clc
        adc     $eb
        tay
        shorta
        clr_a
        lda     $8d
        and     #$f8
        longa
        asl2
        clc
        adc     $ed
        tax
@a8d9:  phx
        longa
        tyx
        lda     $c490c0,x   ; variable width font graphics
        stz     $e7
        stz     $e9
        sta     $e8
        jsr     _c3a94f
        plx
        lda     $e7
        shorta
        ora     $7ea2b9,x
        sta     $7ea2b9,x
        longa
        lsr
        shorta
        ora     $7ea2bc,x
        sta     $7ea2bc,x
        longa
        lda     $e8
        shorta
        ora     $7ea299,x
        sta     $7ea299,x
        longa
        lsr
        shorta
        ora     $7ea29c,x
        sta     $7ea29c,x
        longa
        lda     $e8
        shorta
        xba
        ora     $7ea279,x
        sta     $7ea279,x
        lsr
        ora     $7ea27c,x
        sta     $7ea27c,x
        inx2
        iny2
        dec     $e5
        bne     @a8d9
        clr_a
        pla
        clc
        adc     #$20
        tax
        lda     $8d
        clc
        adc     $c48fc0,x
        sta     $8d
        rts

; ------------------------------------------------------------------------------

; [ shift big text graphics ]

ShiftBigTextGfx:
_c3a94f:
@a94f:  shorta
        clr_a
        lda     $8d
        and     #$07
        asl
        tax
        longa
        jmp     (.loword(ShiftBigTextGfxTbl),x)

ShiftBigTextGfxTbl:
@a95d:  .addr   ShiftBigTextGfx_00
        .addr   ShiftBigTextGfx_01
        .addr   ShiftBigTextGfx_02
        .addr   ShiftBigTextGfx_03
        .addr   ShiftBigTextGfx_04
        .addr   ShiftBigTextGfx_05
        .addr   ShiftBigTextGfx_06
        .addr   ShiftBigTextGfx_07
        .addr   ShiftBigTextGfx_08

; ------------------------------------------------------------------------------

; [  ]

; shift left 4 pixels
ShiftBigTextGfx_00:
@a96f:  asl     $e7
        rol     $e9

; shift left 3 pixels
ShiftBigTextGfx_01:
@a973:  asl     $e7
        rol     $e9

; shift left 2 pixels
ShiftBigTextGfx_02:
@a977:  asl     $e7
        rol     $e9

; shift left 1 pixels
ShiftBigTextGfx_03:
@a97b:  asl     $e7
        rol     $e9

; no shift
ShiftBigTextGfx_04:
@a97f:  rts

; shift right 4 pixels (unused)
ShiftBigTextGfx_08:
@a980:  lsr     $e9
        ror     $e7

; shift right 3 pixels
ShiftBigTextGfx_07:
@a984:  lsr     $e9
        ror     $e7

; shift right 2 pixels
ShiftBigTextGfx_06:
@a988:  lsr     $e9
        ror     $e7

; shift right 1 pixels
ShiftBigTextGfx_05:
@a98c:  lsr     $e9
        ror     $e7
        rts

.a8

; ------------------------------------------------------------------------------

; [ copy description text graphics to vram ]

TfrBigTextGfx:
@a991:  ldy     #$6800
        sty     $1b
        ldy     #$a271
        sty     $1d
        ldy     #$0700
        sty     $19
        lda     #$7e
        sta     $1f
        lda     #$01
        trb     $45
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a9a9:
@a9a9:  ldx     $00
@a9ab:  lda     f:ElementSymbols,x
        sta     $7e9ec9,x
        inx
        cpx     #9
        bne     @a9ab
        ldy     #$6c00
        sty     $f1
        clr_ax
@a9c0:  lda     $7e9ec9,x
        beq     @a9e2
        jsr     GetLetter
        phx
        jsr     _c3a9e5
        plx
        inx
        ldy     $f1
        jsr     _c3a5f6
        longa
        lda     $f1
        clc
        adc     #$0020
        sta     $f1
        shorta
        bra     @a9c0
@a9e2:  jmp     DisableDMA2

; ------------------------------------------------------------------------------

; [  ]

_c3a9e5:
@a9e5:  pha
        ldy     #$0040
        sty     $f3
        jsr     _c3b437
        stz     $8d
        stz     $ed
        stz     $ee
        pla
        jmp     CopyLetterGfx

; ------------------------------------------------------------------------------

; [ menu state $73: final battle order (init) ]

MenuState_73:
@a9f8:  jsr     DisableInterrupts
        jsr     ClearBGScroll
        lda     #$02
        sta     $46
        jsr     LoadFinalOrderCursor
        jsr     InitFinalOrderCursor
        jsr     CreateCursorTask
        jsr     InitFinalOrderList
        jsr     ResetFinalOrderList
        jsr     DrawFinalOrderMenu
        jsr     InitPartyEquipScrollHDMA
        lda     #$74
        sta     $27
        lda     #$01
        sta     $26
        jsr     InitBG1TilesLeftDMA1
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $74: final battle order ]

MenuState_74:
@aa25:  jsr     DrawFinalOrderListLeft
        jsr     DrawFinalOrderListRight
        jsr     UpdateFinalOrderCursor
        jsr     InitBG1TilesLeftDMA1

; B button
        lda     $09
        bit     #$80
        beq     @aa63
        jsr     PlayCancelSfx
        lda     $4a
        beq     @aaa6
        dec     $4a
        clr_a
        lda     $4a
        tax
        lda     $0205,x
        pha
        lda     #$ff
        sta     $0205,x
        ldx     $00
        pla
@aa50:  cmp     $7e9d8a,x
        beq     @aa5c
        inx
        cpx     #12
        bne     @aa50
@aa5c:  lda     #$20
        sta     $7eaa8d,x
        rts

; check start button
@aa63:  lda     $09
        bit     #$10
        bne     @aa99

; A button
        lda     $08
        bit     #$80
        beq     @aaa6
        jsr     PlaySelectSfx
        clr_a
        lda     $4b
        beq     @aaa7
        cmp     #13
        beq     @aa99
        tax
        lda     $7e9d89,x
        bmi     @aaa6
        clr_a
        lda     $4b
        dec
        tax
        lda     $7eaa8d,x
        cmp     #$20
        bne     @aaa6                   ; do nothing if not white text
        jsr     SelectFinalOrderChar
        lda     $4a
        cmp     #12
        beq     @aaad
        rts

; start button, or selected "end"
@aa99:  jsr     PlaySelectSfx
        jsr     FillFinalOrder
        lda     #$ff
        sta     $27
        stz     $26
        rts
@aaa6:  rts

; selected "reset"
@aaa7:  jsr     ResetFinalOrderList
        inc     $4e
        rts

; list full, move cursor to "end"
@aaad:  lda     #13
        sta     $4e
        rts

; ------------------------------------------------------------------------------

; [ select character for final battle order ]

SelectFinalOrderChar:
@aab2:  clr_a
        lda     $4a
        tay
        lda     $4b
        tax
        lda     #$28
        sta     $7eaa8c,x
        lda     $7e9d89,x
        tyx
        sta     $0205,x
        inc     $4a
        rts

; ------------------------------------------------------------------------------

; [ automatically fill final battle order with remaining characters ]

FillFinalOrder:
@aaca:  lda     $4a
        cmp     #12
        beq     @aaed
        clr_ax
@aad2:  lda     $7eaa8d,x
        cmp     #$20
        bne     @aae7
        clr_a
        lda     $4a
        tay
        lda     $7e9d8a,x
        sta     $0205,y
        inc     $4a
@aae7:  inx
        cpx     #12
        bne     @aad2
@aaed:  rts

; ------------------------------------------------------------------------------

; [  ]

InitFinalOrderList:
@aaee:  clr_ax
@aaf0:  lda     #$ff
        sta     $7e9d89,x
        inx
        cpx     #16
        bne     @aaf0
        rts

; ------------------------------------------------------------------------------

; [ reset final battle character list ]

ResetFinalOrderList:
@aafd:  clr_ax
@aaff:  lda     #$ff
        sta     $0205,x
        lda     #$20
        sta     $7eaa8d,x
        inx
        cpx     #12
        bne     @aaff
        stz     $4a
        rts

; ------------------------------------------------------------------------------

; [ draw menu for final battle order ]

DrawFinalOrderMenu:
@ab13:  lda     #$02
        sta     hBG1SC
        ldy     #.loword(FinalOrderWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG3ScreenA
        jsr     TfrBG3ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        lda     #$20                    ; use white text
        sta     $29
        ldx     #.loword(FinalOrderTextList)
        ldy     #6
        jsr     DrawPosList
        jsr     DrawFinalOrderNum
        jsr     MakeFinalOrderCharList
        jsr     DrawFinalOrderListLeft
        jsr     TfrBG1ScreenAB
        jmp     TfrBG1ScreenBC

; ------------------------------------------------------------------------------

FinalOrderWindow:
@ab49:  .byte   $8b,$58,$1c,$18

; ------------------------------------------------------------------------------

; [ make list of available characters for final battle order ]

MakeFinalOrderCharList:
@ab4d:  stz     $e6
        clr_ax
@ab51:  phx
        lda     $1850,x
        and     #$40
        beq     @ab81
        lda     $1850,x
        and     #$07
        beq     @ab81                   ; skip characters not in a party
        stx     $e7
        longa
        txa
        asl
        tax
        lda     f:CharPropPtrs,x        ; pointers to character data
        tay
        shorta
        lda     $0000,y
        cmp     #$0e
        bcs     @ab81
        clr_a
        lda     $e6
        tax
        lda     $e7
        sta     $7e9d8a,x
        inc     $e6
@ab81:  plx
        inx
        cpx     #$0010
        bne     @ab51
        rts

; ------------------------------------------------------------------------------

; [ draw final battle order list (left side) ]

DrawFinalOrderListLeft:
@ab89:  ldy     #$3a15
        sty     $f5
        clr_ax
@ab90:  jsr     InitFinalOrderTextBuf
        phx
        clr_a
        lda     $7eaa8d,x
        sta     $29
        lda     $7e9d8a,x
        bmi     @aba6
        jsr     DrawFinalOrderCharName
        bra     @aba9
@aba6:  jsr     DrawFinalOrderEmptyChar
@aba9:  jsr     FinalOrderNextLine
        plx
        inx
        cpx     #12
        bne     @ab90
        rts

; ------------------------------------------------------------------------------

; [ draw final battle order list (right side) ]

DrawFinalOrderListRight:
@abb4:  lda     #$20
        sta     $29
        ldy     #$3a31
        sty     $f5
        clr_ax
@abbf:  jsr     InitFinalOrderTextBuf
        phx
        clr_a
        lda     $0205,x
        bmi     @abce
        jsr     DrawFinalOrderCharName
        bra     @abd1
@abce:  jsr     DrawFinalOrderEmptyChar
@abd1:  jsr     FinalOrderNextLine
        plx
        inx
        cpx     #12
        bne     @abbf
        rts

; ------------------------------------------------------------------------------

; [ init buffer for drawing final battle order text ]

InitFinalOrderTextBuf:
@abdc:  ldy     #$9e89
        sty     hWMADDL
        longa
        lda     $f5
        shorta
        sta     hWMDATA
        xba
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ draw character name for final battle order ]

DrawFinalOrderCharName:
@abf0:  asl
        longa
        tax
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        shorta
        jmp     _c334d2

; ------------------------------------------------------------------------------

; [ go to next line ]

FinalOrderNextLine:
@abfe:  longa
        lda     $f5
        clc
        adc     #$0080
        sta     $f5
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw empty character slot ]

DrawFinalOrderEmptyChar:
@ac0b:  ldx     #6
        lda     #$ff
@ac10:  sta     hWMDATA
        dex
        bne     @ac10
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw final battle order numbers ]

DrawFinalOrderNum:
@ac19:  lda     #1
        sta     $e6
        ldy     #$3a0f                  ; left side
        sty     $f5
        ldx     #12
        stx     $f1
        jsr     @ac3b
        lda     #1
        sta     $e6
        ldy     #$3a2b                  ; right side
        sty     $f5
        ldx     #12
        stx     $f1
        jmp     @ac3b

; draw numbers on one side
@ac3b:  clr_ax
@ac3d:  phx
        lda     $e6
        jsr     HexToDec3
        ldx     $f5
        jsr     DrawNum2
        inc     $e6
        jsr     FinalOrderNextLine
        plx
        inx
        cpx     $f1
        bne     @ac3d
        rts

; ------------------------------------------------------------------------------

; [  ]

LoadFinalOrderCursor:
@ac54:  ldy     #.loword(FinalOrderCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [  ]

UpdateFinalOrderCursor:
@ac5a:  jsr     MoveCursor

InitFinalOrderCursor:
@ac5d:  ldy     #.loword(FinalOrderCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

FinalOrderCursorProp:
@ac63:  .byte   $80,$00,$00,$01,$0e

FinalOrderCursorPos:
@ac68:  .byte   $10,$20
        .byte   $20,$2c
        .byte   $20,$38
        .byte   $20,$44
        .byte   $20,$50
        .byte   $20,$5c
        .byte   $20,$68
        .byte   $20,$74
        .byte   $20,$80
        .byte   $20,$8c
        .byte   $20,$98
        .byte   $20,$a4
        .byte   $20,$b0
        .byte   $10,$bc

; ------------------------------------------------------------------------------

; pointers to text for final battle order menu
FinalOrderTextList:
@ac84:  .addr   FinalOrderEndText
        .addr   FinalOrderResetText
        .addr   FinalOrderMsgText

; c3/ac8a: ( 4,31) "end"
FinalOrderEndText:
@ac8a:  .word   $4011
        .byte   $84,$a7,$9d,$00

; c3/ac90: ( 4, 5) "reset"
FinalOrderResetText:
@ac90:  .word   $3991
        .byte   $91,$9e,$ac,$9e,$ad,$00

; c3/ac98: (10, 3) "determine order"
FinalOrderMsgText:
@ac98:  .word   $391d
        .byte   $83,$9e,$ad,$9e,$ab,$a6,$a2,$a7,$9e,$ff,$a8,$ab,$9d,$9e,$ab,$00

; ------------------------------------------------------------------------------

; [ menu state $71: colosseum item select (init) ]

MenuState_71:
@acaa:  stz     $0201
        lda     $0205
        jsr     IncItemQty
        jsr     _c31ae2
        jsr     InitItemListCursor
        jsr     _c3ad27
        clr_a
        jsl     InitGradientHDMA
        jsr     _c31b0e
        jsr     InitFontColor
        lda     #$01
        tsb     $45
        jsr     WaitVblank
        lda     #$72
        sta     $27
        lda     #$02
        sta     $46
        jsr     CreateCursorTask
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $72: colosseum item select ]

MenuState_72:
@acdc:  lda     #$10
        trb     $45
        stz     $2a
        jsr     InitBG1TilesLeftDMA1
        jsr     ScrollListPage
        bcs     @ad26
        jsr     UpdateItemListCursor
        jsr     InitItemDesc
        lda     $08
        bit     #$80
        beq     @ad14
        clr_a
        lda     $4b
        tax
        lda     $1869,x
        cmp     #$ff
        beq     @ad0e
        sta     $0205
        jsr     PlaySelectSfx
        lda     #$75
        sta     $27
        stz     $26
        rts
@ad0e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@ad14:  lda     $09
        bit     #$80
        beq     @ad26
        jsr     PlayCancelSfx
        lda     #$ff
        sta     $0205
        sta     $27
        stz     $26
@ad26:  rts

; ------------------------------------------------------------------------------

; [ draw menu for colosseum item select ]

DrawColosseumItemMenu:
_c3ad27:
@ad27:  lda     #$01
        sta     hBG1SC
        ldy     #.loword(ColosseumItemMsgWindow)
        jsr     DrawWindow
        ldy     #.loword(ColosseumItemTitleWindow)
        jsr     DrawWindow
        ldy     #.loword(ColosseumItemDescWindow)
        jsr     DrawWindow
        ldy     #.loword(ColosseumItemListWindow)
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
        lda     #$2c
        sta     $29
        ldy     #.loword(ColosseumItemTitleText)
        jsr     DrawPosText
        lda     #$20
        sta     $29
        rts

; ------------------------------------------------------------------------------

; [ draw message for colosseum item select menu ]

DrawColosseumItemMsg:
@ad80:  jsr     _c3a73d
        ldy     #.loword(ColosseumItemMsgText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; unused menu state
MenuState_78:

; ------------------------------------------------------------------------------

ColosseumItemTitleWindow:
@ad8a:  .byte   $8b,$58,$09,$02

ColosseumItemMsgWindow:
@ad8e:  .byte   $a1,$58,$11,$02

ColosseumItemDescWindow:
@ad92:  .byte   $8b,$59,$1c,$03

ColosseumItemListWindow:
@ad96:  .byte   $cb,$5a,$1c,$0f

ColosseumItemTitleText:
@ad9a:  .word   $790d
        .byte   $82,$a8,$a5,$a8,$ac,$ac,$9e,$ae,$a6,$00

ColosseumItemMsgText:
@ada6:  .word   $7923
        .byte   $92,$9e,$a5,$9e,$9c,$ad,$ff,$9a,$a7,$ff,$88,$ad,$9e,$a6,$00

; ------------------------------------------------------------------------------

; [ menu state $75: colosseum character select (init) ]

MenuState_75:
@adb7:  jsr     DisableInterrupts
        stz     $43
        jsr     _c33a87
        jsr     InitCharProp
        lda     #$02
        jsl     InitGradientHDMA
        jsr     InitWindow1PosHDMA
        jsr     LoadColosseumGfx
        lda     #$02
        sta     $46
        jsr     LoadColosseumCharCursor
        jsr     InitColosseumCharCursor
        jsr     CreateCursorTask
        jsr     CreateColosseumVSTask
        jsr     _c318d1
        jsr     _c3ae34
        lda     #$01
        tsb     $45
        jsr     InitFontColor
        lda     #1
        ldy     #.loword(ColosseumCharTask)
        jsr     CreateTask
        lda     #$76
        sta     $27
        lda     #$01
        sta     $26
        jsr     ClearBGScroll
        jsr     InitBG1TilesLeftDMA1
        jsr     EnableInterrupts
        jmp     InitBG3TilesLeftDMA1

; ------------------------------------------------------------------------------

; [ create task for "VS" sprite in colosseum ]

CreateColosseumVSTask:
@ae07:  lda     #1
        ldy     #.loword(ColosseumVSTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ menu state $76: colosseum character select ]

MenuState_76:
@ae0f:  jsr     InitBG3TilesLeftDMA1
        jsr     UpdateColosseumCharCursor
        lda     $08
        bit     #$80
        beq     @ae33
        jsr     _c3b2ec
        bmi     @ae2d
        sta     $0208
        jsr     PlaySelectSfx
        lda     #$ff
        sta     $27
        stz     $26
        rts
@ae2d:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
@ae33:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3ae34:
@ae34:  lda     #$01
        sta     hBG1SC
        ldy     #.loword(ColosseumPrizeWindow)
        jsr     DrawWindow
        ldy     #.loword(ColosseumWagerWindow)
        jsr     DrawWindow
        ldy     #.loword(ColosseumCharWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG3ScreenA
        lda     #$20
        sta     $29
        jsr     _c3b17d
        jsr     _c3b197
        jsr     _c3b1b1
        jsr     _c3b1cb
        ldy     #.loword(ColosseumCharMsgText)
        jsr     DrawPosText
        jsr     _c3b28d
        jsr     DrawWagerName
        jsr     DrawPrizeName
        jsr     TfrBG3ScreenAB
        ldy     #$5000
        sty     hVMADDL
        jsr     _c3b10a
        jsr     ClearBG1ScreenA
        jsr     _c3ae93
        lda     $0201
        bne     @ae8d
        jsr     _c3af00
        jmp     TfrBG1ScreenAB
@ae8d:  jsr     _c3aea7
        jmp     TfrBG1ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c3ae93:
@ae93:  lda     $0205
        cmp     #$29
        bne     @aea6       ; branch if not item $29 (striker)
        lda     $1ebd
        and     #$80
        beq     @aea6
        lda     #$01
        sta     $0201
@aea6:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3aea7:
@aea7:  jsr     _c3aed9
        lda     #$02
        tsb     $47
        lda     #2
        ldy     #.loword(_c37a5f)
        jsr     CreateTask
        lda     #$01
        sta     $7e3649,x
        lda     $7e364a,x
        ora     #$02
        sta     $7e364a,x
        txy
        lda     #$38
        sta     $e1
        lda     #$68
        sta     $e2
        clr_a
        lda     #$03
        jsr     _c378fa
        jsr     _c3b211
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3aed9:
@aed9:  clr_ax
@aedb:  stx     $e7
        longa
        lda     f:CharPropPtrs,x
        tax
        shorta
        lda     a:$0000,x
        cmp     #$03
        beq     @aef8
        ldx     $e7
        inx2
        cpx     #$0020
        bne     @aedb
@aef6:  bra     @aef6
@aef8:  stx     $67
        ldy     #$7c11
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; [  ]

_c3af00:
@af00:  ldx     $91
        stx     $ed
        lda     $99
        cmp     #$08
        beq     @af16
        ldx     #$0010
        stx     $f1
        ldx     #$0010
        stx     $e0
        bra     @af1d
@af16:  ldx     #$0008
        stx     $f1
        stx     $e0
@af1d:  lda     #$7e
        sta     $ef
        longa
        lda     #$2c01
        sta     $e7
@af28:  ldx     $e0
        ldy     $00
@af2c:  lda     $e7
        sta     [$ed],y
        iny2
        inc     $e7
        dex
        bne     @af2c
        lda     $ed
        clc
        adc     #$0040
        sta     $ed
        dec     $f1
        bne     @af28
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load monster graphics (colosseum) ]

LoadMonsterGfx:
@af46:  jsr     _c3b22c
        lda     $0206       ; monster index
        sta     hWRMPYA
        lda     #$05        ; calculate pointer to monster graphics data
        sta     hWRMPYB
        ldy     #$5010
        sty     hVMADDL
        nop2
        ldx     hRDMPYL
        lda     $d27000,x   ; monster graphics data
        sta     $e7
        lda     $d27001,x
        sta     $e8
        lda     $d27002,x
        sta     $f2
        lda     $d27003,x
        sta     $f1
        lda     $d27004,x
        sta     $e9
        lda     $e8
        bmi     @af85
        stz     $ff
        bra     @af8d
@af85:  lda     #$01
        sta     $ff
        lda     #$80
        trb     $e8
@af8d:  lda     #$e9
        sta     $f7
        longa
        lda     #$7000
        sta     $f5
        lda     $e7
        sta     $f9
        stz     $fb
        asl     $f9
        rol     $fb
        asl     $f9
        rol     $fb
        asl     $f9
        rol     $fb
        clc
        lda     $f9
        adc     $f5
        sta     $f5
        lda     $fb
        adc     $f7
        sta     $f7
        ldx     $00
        shorta
        lda     $f2
        bmi     @afc8
        ldy     #$a820      ; pointer to small monster graphics maps
        sty     $e3
        lda     #$08
        bra     @afcf
@afc8:  ldy     #$a822      ; pointer to large monster graphics maps
        sty     $e3
        lda     #$20
@afcf:  sta     $e6
        sta     $99
        lda     #$d2
        sta     $e5
        lda     $f2
        and     #$40
        rol3
        sta     $ea
        lda     $f2
        bmi     @afed
        longa
        lda     $e9
        asl3
        bra     @aff6
@afed:  longa
        lda     $e9
        asl5
@aff6:  clc
        adc     [$e3]
        sta     $e0
        shorta
        lda     #$d2
        sta     $e2
@b001:  ldy     #$0008
        phx
        clr_a
        lda     $e6
        tax
        lda     [$e0]
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
        inc     $e0
        shorta
        dec     $e6
        bne     @b001
        jsr     _c3b033
        jmp     _c3b15a

; ------------------------------------------------------------------------------

; [  ]

_c3b033:
@b033:  stz     $e0
        stz     $e4
        stz     $e5
        stz     $e3
        ldx     $00
        lda     $99
        cmp     #$08
        bne     @b079
@b043:  lda     $7e9d89,x
        bne     @b050
        inc     $e0
        inx
        cmp     #$08
        bne     @b043
@b050:  ldx     $00
@b052:  lda     $7e9d89,x
        ora     $e3
        sta     $e3
        inx
        cpx     #$0008
        bne     @b052
@b060:  ror     $e3
        bcs     @b068
        inc     $e4
        bra     @b060
@b068:  lsr     $e4
        asl     $e4
        longac
        lda     $e4
        adc     #$3a51
        sta     $e7
        shorta
        bra     @b0b4
@b079:  lda     $7e9d89,x
        ora     $7e9d8a,x
        bne     @b08c
        inc     $e0
        inx2
        cpx     #$0020
        bne     @b079
@b08c:  ldx     $00
@b08e:  lda     $7e9d89,x
        ora     $e3
        sta     $e3
        inx2
        cpx     #$0020
        bne     @b08e
@b09d:  ror     $e3
        bcs     @b0a5
        inc     $e4
        bra     @b09d
@b0a5:  lsr     $e4
        asl     $e4
        longac
        lda     $e4
        adc     #$3849
        sta     $e7
        shorta
@b0b4:  jmp     _c3b0b7

; ------------------------------------------------------------------------------

; [ set vertical alignment for monster in colosseum menu ]

AlignColosseumMonster:
_c3b0b7:
@b0b7:  clr_a
        lda     $0206       ; colosseum monster number
        tax
        lda     $ece800,x   ; monster vertical alignment
        longa
        asl
        tax
        shorta
        jmp     (.loword(AlignColosseumMonsterPtrs),x)

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
@b0d3:  stz     $e0
        longa
        lda     $e7
        sec
        sbc     #$00c0
        sta     $91
        shorta
        rts

; ------------------------------------------------------------------------------

; [ 2: buried (shift up 8) ]

AlignColosseumMonster_02:
@b0e2:  dec     $e0
        bpl     @b0e8
        stz     $e0
@b0e8:  bra     _b0f8

; ------------------------------------------------------------------------------

; [ 3: floating (shift down 8) ]

AlignColosseumMonster_03:
@b0ea:  inc     $e0
        bra     _b0f8

; ------------------------------------------------------------------------------

; [ 4: flying (shift up 24) ]

AlignColosseumMonster_04:
@b0ee:  dec     $e0
        dec     $e0
        dec     $e0
        bpl     _b0f8
        stz     $e0
; fallthrough

; ------------------------------------------------------------------------------

; [ 1: ground (no effect) ]

AlignColosseumMonster_01:
_b0f8:  clr_a
        lda     $e0
        longac
        asl6
        adc     $e7
        sta     $91
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b10a:
@b10a:  ldy     #$0010
        sty     $e3
        longa
        ldy     $00
@b113:  stz     hVMDATAL
        iny
        cpy     $e3
        bne     @b113
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b11e:
@b11e:  lda     $ff
        bne     @b129
        ldy     #$0010
        sty     $e3
        bra     @b145
@b129:  ldy     #$0008
        sty     $e3
        jsr     @b145
        txy
        ldx     #$0008
        clr_a
@b136:  lda     [$f5],y
        longa
        sta     hVMDATAL
        shorta
        iny
        dex
        bne     @b136
        tyx
        rts

@b145:  txy
        ldx     $00
        longa
@b14a:  lda     [$f5],y
        sta     hVMDATAL
        iny2
        inx
        cpx     $e3
        bne     @b14a
        shorta
        tyx
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b15a:
@b15a:  longa
        lda     $f1
        and     #$03ff
        asl4
        tax
        shorta
        ldy     #$30a9
        sty     hWMADDL
        ldy     #$0020
@b171:  lda     $d27820,x
        sta     hWMDATA
        inx
        dey
        bne     @b171
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b17d:
@b17d:  ldy     $6d
        beq     @b196
        sty     $67
        ldy     #$7e4f
        jsr     _c3b1e5
        lda     #$20
        sta     $e1
        lda     #$a8
        sta     $e2
        lda     $69
        jsr     _c3b1f3
@b196:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b197:
@b197:  ldy     $6f
        beq     @b1b0
        sty     $67
        ldy     #$7e5d
        jsr     _c3b1e5
        lda     #$58
        sta     $e1
        lda     #$a8
        sta     $e2
        lda     $6a
        jsr     _c3b1f3
@b1b0:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b1b1:
@b1b1:  ldy     $71
        beq     @b1ca
        sty     $67
        ldy     #$7e6b
        jsr     _c3b1e5
        lda     #$90
        sta     $e1
        lda     #$a8
        sta     $e2
        lda     $6b
        jsr     _c3b1f3
@b1ca:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b1cb:
@b1cb:  ldy     $73
        beq     @b1e4
        sty     $67
        ldy     #$7e79
        jsr     _c3b1e5
        lda     #$c8
        sta     $e1
        lda     #$a8
        sta     $e2
        lda     $6c
        jsr     _c3b1f3
@b1e4:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3b1e5:
@b1e5:  jsr     DrawCharName
        lda     #2
        ldy     #.loword(_c37a5f)
        jsr     CreateTask
        txy
        clr_a
        rts

; ------------------------------------------------------------------------------

; [  ]

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
        sta     $35ca,y
        lda     $e1
        sta     $33ca,y
        lda     $e2
        sta     $344a,y
        clr_a
        sta     $33cb,y
        sta     $344b,y
        lda     #$00
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load colosseum item data ]

_c3b22c:
@b22c:  clr_a
        lda     $0205                   ; item wagered
        longa
        asl2
        tax
        shorta
        lda     $dfb600,x               ; colosseum monster
        sta     $0206
        lda     $dfb602,x               ; prize
        sta     $0207
        lda     $dfb603,x               ; hide prize name
        sta     $0209
        rts

; ------------------------------------------------------------------------------

; [ draw wagered item name ]

DrawWagerName:
@b24d:  lda     $0205                   ; wagered item
        ldx     #$792b
        bra     _b263

; [ draw prize item name ]

DrawPrizeName:
@b255:  lda     $0209                   ; prize item
        beq     _b25d                   ; branch if colosseum item name is shown
        jmp     _b286
_b25d:  lda     $0207
        ldx     #$790d
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
        sta     $7e9e98
        jmp     DrawPosTextBuf
_b286:  ldy     #.loword(ColosseumUnknownPrizeText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b28d:
@b28d:  longa
        lda     #$7c4f
        sta     $7e9e89
        shorta
        jsr     _c35409
        clr_a
        lda     $0206
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ colosseum challender sprite task ]

ColosseumCharTask:
@b2a5:  phb
        lda     #$00
        pha
        plb
        clr_a
        lda     $4b
        asl
        tax
        ldy     $6d,x
        beq     @b2df
        sty     $67
        ldy     #$7c75
        jsr     DrawCharName
        lda     #$02
        tsb     $47
        lda     #2
        ldy     #.loword(CharIconTask)
        jsr     CreateTask
        lda     #$01
        sta     $7e3649,x
        txy
        clr_a
        lda     #$b8
        sta     $e1
        lda     #$68
        sta     $e2
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
@b2e5:  ldy     #.loword(ColosseumCharBlankNameText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b2ec:
@b2ec:  clr_a
        lda     $4b
        tax
        lda     $69,x
        rts

; ------------------------------------------------------------------------------

; [ task for "VS" sprite in colosseum ]

ColosseumVSTask:
@b2f3:  tax
        jmp     (.loword(ColosseumVSTaskTbl),x)

ColosseumVSTaskTbl:
@b2f7:  .addr   ColosseumVSTask_00
        .addr   ColosseumVSTask_01

; ------------------------------------------------------------------------------

; [  ]

ColosseumVSTask_00:
@b2fb:  ldx     $2d
        longa
        lda     #.loword(ColosseumVSAnim)
        sta     $32c9,x
        lda     #$0070
        sta     $33ca,x
        lda     #$0060
        sta     $344a,x
        shorta
        inc     $3649,x
        lda     #^ColosseumVSAnim
        sta     $35ca,x
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
@b323:  ldy     #.loword(ColosseumCharCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update colosseum character cursor ]

UpdateColosseumCharCursor:
@b329:  jsr     MoveCursor

InitColosseumCharCursor:
@b32c:  ldy     #.loword(ColosseumCharCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

ColosseumCharCursorProp:
@b332:  .byte   $01,$00,$00,$04,$01

ColosseumCharCursorPos:
@b337:  .byte   $10,$b0
        .byte   $48,$b0
        .byte   $80,$b0
        .byte   $b8,$b0

; colosseum menu windows
ColosseumPrizeWindow:
@b33f:  .byte   $8b,$58,$0d,$02

ColosseumWagerWindow:
@b343:  .byte   $a9,$58,$0d,$02

ColosseumCharWindow:
@b347:  .byte   $cb,$5c,$1c,$07

; ------------------------------------------------------------------------------

; [ load colosseum battle bg graphics ]

LoadColosseumBGGfx:
@b34b:  longa
        lda     $e7168c
        sta     $f3
        shorta
        lda     $e7168e
        sta     $f5
        jsr     _c3b3f2
        ldy     #$6800
        sty     hVMADDL
        ldy     #$1000
        sty     $e7
        ldx     $00
        jsr     _c3b3c6
        longa
        lda     $e71692
        sta     $f3
        shorta
        lda     $e71694
        sta     $f5
        jsr     _c3b3f2
        ldy     #$7000
        sty     hVMADDL
        ldy     #$1000
        sty     $e7
        ldx     $00
        jsr     _c3b3c6
        longa
        lda     $e7187a
        sta     $f3
        shorta
        lda     #$e7
        sta     $f5
        jsr     _c3b3f2
        jsr     _c3b3d8
        longa
        lda     #$0ab0
        sta     $e7
        shorta
        lda     #$e7
        sta     $e9
        ldx     #$30c9
        stx     hWMADDL
        ldy     $00
@b3ba:  lda     [$e7],y
        sta     hWMDATA
        iny
        cpy     #$0060
        bne     @b3ba
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b3c6:
@b3c6:  longa
@b3c8:  lda     $7eb68d,x
        sta     hVMDATAL
        inx2
        cpx     $e7
        bne     @b3c8
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b3d8:
@b3d8:  ldx     $00
        longa
@b3dc:  lda     $7eb68d,x
        sec
        sbc     #$0380
        sta     $7e5949,x
        inx2
        cpx     #$0580
        bne     @b3dc
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3b3f2:
@b3f2:  ldy     #$b68d
        sty     $f6
        lda     #$7e
        sta     $f8
        phb
        lda     #$7e
        pha
        plb
        jsl     $c2ff6d     ; decompress
        plb
        rts

; ------------------------------------------------------------------------------

; c3/b406: (22,16) "      "
; c3/b40f: ( 6,19) "select the challenger"
; c3/b427: ( 2, 3) "?????????????"

ColosseumCharBlankNameText:
@b406:  .word   $7c75
        .byte   $ff,$ff,$ff,$ff,$ff,$ff,$00

ColosseumCharMsgText:
@b40f:  .word   $7d15
        .byte   $92,$9e,$a5,$9e,$9c,$ad,$ff,$ad,$a1,$9e,$ff,$9c,$a1,$9a
        .byte   $a5,$a5,$9e,$a7,$a0,$9e,$ab,$00

ColosseumUnknownPrizeText:
@b427:  .word   $790d
        .byte   $bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$bf,$00

; ------------------------------------------------------------------------------

; [ menu state $3f/$40/$41/$4e/$4f: unused ]
MenuState_3f:
MenuState_40:
MenuState_41:
MenuState_4e:
MenuState_4f:

; ------------------------------------------------------------------------------

_c3b437:
@b437:  clr_ax
        longa
@b43b:  sta     $7ea271,x
        inx2
        cpx     $f3
        bne     @b43b
        shorta
        rts

; ------------------------------------------------------------------------------

; frame data for flashing up indicator
NameChangeArrowSprite_00:
@b448:  .byte   1
        .byte   $09,$00,$02,$3e

NameChangeArrowSprite_01:
@b44d:  .byte   1
        .byte   $09,$00,$12,$3e

; flashing up indicator (name change menu)
NameChangeArrowAnim:
@b452:  .addr   NameChangeArrowSprite_00
        .byte   $02
        .addr   NameChangeArrowSprite_01
        .byte   $02
        .addr   NameChangeArrowSprite_00
        .byte   $ff

; page up and page down frame data
HiddenArrowSprite:
@b45b:  .byte   0

DownArrowSprite:
@b45c:  .byte   1
        .byte   $80,$82,$03,$3e

UpArrowSprite:
@b461:  .byte   1
        .byte   $80,$00,$03,$be

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
        jsr     InitBG3TilesLeftDMA1
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
        jsr     InitBG1TilesLeftDMA1
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
        jsr     InitBG1TilesLeftDMA1
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
        jsr     InitBG1TilesLeftDMA1
        jsr     _c3b94e
        jsr     WaitVblank
        jsr     InitBG3TilesLeftDMA1
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
@b7c7:  jsr     InitBG3TilesLeftDMA1
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
        lda     f:ShopProp,x
        ldx     $f1
        sta     $7e9d89,x
        cmp     #$ff
        beq     @b9e4
        jsr     LoadItemName
        jsr     DrawPosTextBuf
        ldx     $f1
        lda     $7e9d89,x
        jsr     GetItemPropPtr
        jsr     _c3ba0c
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

; [  ]

_c3ba0c:
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
        cmp     #$06        ; celes
        beq     @ba8d
        cmp     #$08        ; relm
        beq     @ba8d
        cmp     #$00        ; terra
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
@baa5:  jsr     InitBG3TilesLeftDMA1
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
        longac
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
        beq     @bd3c
        jmp     @bf0a
@bd3c:  jmp     @bf18
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
@bd8f:  longac
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
        bne     @be32
        jmp     @bd8f
@be32:  jmp     @bda7
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
        bne     @beba
        jmp     @bd8f
@beba:  jmp     @be37
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
@bfa5:  longac
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
        lda     #13
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #13
@c08b:  lda     $d2b300,x
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
        longac
        lda     $34ca,x
        adc     #$0009      ; add 9 to sprite data pointer to get the jumping animation
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
        lda     #.loword(ShopEquipIconAnim_00)
        sta     $32c9,x
        sta     $34ca,x
        shorta
        inc     $3649,x
        lda     #^ShopEquipIconAnim_00
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
        longac
        lda     $34ca,x     ; d8/ebe5
        adc     #$0018
        bra     @c2d5

; already equipped
@c2b6:  ldx     $2d
        longa
        lda     $34ca,x     ; d8/ebcd
        bra     @c2d5

; equals sign
@c2bf:  ldx     $2d
        longac
        lda     $34ca,x     ; d8/ebf1
        adc     #$0024
        bra     @c2d5

; up arrow
@c2cb:  ldx     $2d
        longac
        lda     $34ca,x     ; d8/ebd9
        adc     #$000c
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

EndingCutscene:
@c51c:  rtl

; ------------------------------------------------------------------------------

EndingAirshipScene:
@c51c:  rtl

; ------------------------------------------------------------------------------

; [ update mode 7 registers ]

UpdateMode7Regs:
@d263:  lda     $bb
        sta     hM7A
        lda     $bc
        sta     hM7A
        lda     $bd
        sta     hM7B
        lda     $be
        sta     hM7B
        lda     $bf
        sta     hM7C
        lda     $c0
        sta     hM7C
        lda     $c1
        sta     hM7D
        lda     $c2
        sta     hM7D
        lda     $b7
        sta     hM7X
        lda     $b8
        sta     hM7X
        lda     $b9
        sta     hM7Y
        lda     $ba
        sta     hM7Y
        rts

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
        lda     #<hCOLDATA              ; channel #3 destination = $2130, $2131, $2132, $2133 (fixed color)
        sta     $4331
        ldy     #$cc98                  ; channel #3 source = $d4cc98
        sty     $4332
        lda     #$d4
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
