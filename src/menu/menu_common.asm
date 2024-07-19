.segment "menu_code"

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
        ldx     #0                      ; set z0
        stx     z0
        lda     #$7e
        sta     hWMADDH                 ; set wram bank
        jsr     InitInterrupts
        lda     w0200
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
        lda     w0200
        cmp     #$02
        bne     @006f                   ; branch if not restoring a saved game
        lda     w0205
        bpl     @006f                   ; branch if tent/warp/warp stone was used
        lda     $1d4e
        and     #$20
        beq     @006f                   ; branch if stereo mode
        lda     #$ff
        jsr     SetStereoMono
@006f:  lda     w0200
        bne     @00bf       ; branch if not main menu
        lda     w0205
        bpl     @00bf       ; return if return code is positive
        cmp     #$fe
        bne     @009e       ; branch if not using rename card

; rename card
        lda     #$01
        sta     w0200
        lda     w0201
        sta     w020f
        ldy     w0206
        sty     w0201
        jsl     OpenMenu_ext
        lda     w020f
        sta     w0201
        stz     w0200
        jmp     @001b

; swdtech renaming (ff6j)
@009e:  lda     #$06
        sta     w0200
        lda     w0201
        sta     w020f
        lda     w0206
        sta     w0201
        jsl     OpenMenu_ext
        lda     w020f
        sta     w0201
        stz     w0200
        jmp     @001b

; return from menu
@00bf:  rtl

; ------------------------------------------------------------------------------

; [ set up interrupt jump code ]

InitInterrupts:
@00c0:  lda     #$5c
        sta     $1500
        sta     $1504
        ldx     #near MenuNMI
        stx     $1501
        ldx     #near MenuIRQ
        stx     $1505
        lda     #^MenuNMI
        sta     $1503
        sta     $1507
        rts

; ------------------------------------------------------------------------------

; [ open menu (type) ]

OpenMenuType:
@00dd:  clr_a
        lda     w0200
        asl
        tax
        jmp     (near MenuTypeTbl,x)

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
@011a:  lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zMenuState
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $03: shop ]

ShopMenu:
@0121:  jsr     InitFontColor
        lda     #$24                    ; menu state $24 (shop init)
        sta     zMenuState
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $04: party select ]

PartySelectMenu:
@012b:  jsr     InitFontColor
        jsr     ResetCursorPos
        lda     #$2c                    ; menu state $2c (party select init)
        sta     zMenuState
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
        sta     zMenuState
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $06: swdtech renaming (ff6j) ]

BushidoNameMenu:
@0149:  jsr     InitFontColor
        lda     #$3f                    ; menu state $3f
        sta     zMenuState
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $07: colosseum ]

ColosseumMenu:
@0152:  jsr     InitFontColor
        stz     $79
        stz     $7a
        stz     $7b
        lda     #$ff
        sta     w0205
        lda     #$71                    ; menu state $71 (colosseum item select init)
        sta     zMenuState
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $08: final battle order ]

FinalBattleOrderMenu:
@0166:  jsr     InitFontColor
        lda     #$73                    ; menu state $73 (final battle order init)
        sta     zMenuState
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
        sta     w0205
        lda     #$20                    ; menu state $20 (restore game init)
        sta     zMenuState
        bra     MenuLoop

; sram invalid
@019f:  jsr     ResetGameTime
        lda     #1
        sta     wSelSaveSlot
        stz     wSaveSlotToLoad         ; don't load a saved game
        lda     #MENU_STATE::TERMINATE
        sta     zMenuState              ; terminate menu
        stz     w0205                   ; clear return code
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $01: name change ]

NameChangeMenu:
@01b3:  jsr     InitFontColor
        lda     #$5d                    ; menu state $5d (name change init)
        sta     zMenuState
; fall through

; ------------------------------------------------------------------------------

; [ menu state loop ]

MenuLoop:
@01ba:  jsr     UpdatePPU
@01bd:  clr_a
        lda     zMenuState                     ; return if menu state is $ff
        cmp     #$ff
        beq     @01d8
        longa
        asl
        tax
        shorta
        jsr     (near MenuStateTbl,x)
        jsr     ExecTasks
        jsr     WaitFrame
        jsr     CheckEventTimer
        bra     @01bd
@01d8:  stz     zEnableHDMA
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
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState
        lda     #$05
        sta     w0205
        sta     $b4
@02f8:  rts

; ------------------------------------------------------------------------------

; [ draw positioned text, latin alphabet with no dakuten ]

;  +y = source address (+$c30000)
; $29 = flags (zTextColor)

DrawPosText:
@02f9:  sty     $e7
        lda     #^*
        sta     $e9

DrawPosTextFar:
@02ff:  ldx     z0
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
        lda     zTextColor
        sta     [$eb],y
        inx
        ply
        iny
        bra     @0312
@0325:  rts

; ------------------------------------------------------------------------------

; [ draw positioned text, kana with dakuten ]

.if LANG_EN

DrawPosKana := DrawPosText
DrawPosKanaFar := DrawPosTextFar

.else

DrawPosKana:
@0326:  sty     $e7
        lda     #^*
        sta     $e9

DrawPosKanaFar:
        ldx     z0
        txy
        longa
        lda     [$e7]
        sta     $eb
        inc     $e7
        inc     $e7
        shorta
        lda     #$7e
        sta     $ed
@033f:  lda     [$e7],y
        sta     $e0
        beq     @03a8
        cmp     #$01
        bne     @035a
        longa
        lda     $eb
        clc
        adc     #$0080
        sta     $eb
        ldx     z0
        shorta
        iny
        bra     @033f
@035a:  phy
        cmp     #$53
        bcc     @0365
        lda     #$ff
        sta     $e1
        bra     @0385
@0365:  cmp     #$49
        bcc     @0376
        lda     #$52
        sta     $e1
        lda     $e0
        clc
        adc     #$17
        sta     $e0
        bra     @0385
@0376:  cmp     #$20
        bcc     @0385
        lda     #$51
        sta     $e1
        lda     $e0
        clc
        adc     #$40
        sta     $e0
@0385:  txy
        lda     $e1
        sta     [$eb],y
        iny
        lda     zTextColor
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
        lda     zTextColor
        sta     [$eb],y
        inx2
        ply
        iny
        bra     @033f
@03a8:  rts

.endif

; ------------------------------------------------------------------------------

; [ init buffer for window tiles ]

; Y: flags applied to each tile

SetWindowTileFlags:
@0326:  sty     $e7
        ldx     z0
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
        ldx     z0
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
        ldx     z0
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

DrawWindowRows:
@0375:  .a16
        jsr     DrawBorderTop
        ldx     z0
        ldy     #$0040
        sty     $f3
@037f:  phx
        txa
        and     #%11
        asl
        tax
        jsr     (near DrawWindowRowsTbl,x)
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
        make_jump_tbl DrawWindowRows, 4

; ------------------------------------------------------------------------------

; [ draw border row ]

DrawBorderTop:
@03a3:  ldy     z0
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

make_jump_label DrawWindowRows, 0
@03d1:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder1
        stz     $e0
        bra     DrawWindowRow

make_jump_label DrawWindowRows, 1
@03db:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder2
        ldx     #$0008
        stx     $e0
        bra     DrawWindowRow

make_jump_label DrawWindowRows, 2
@03e8:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder1
        ldx     #$0010
        stx     $e0
        bra     DrawWindowRow

make_jump_label DrawWindowRows, 3
@03f5:  jsr     SetWindowPatternMask
        jsr     GetWindowBorder2
        ldx     #$0018
        stx     $e0
        bra     DrawWindowRow

; ------------------------------------------------------------------------------

; [ set window area pattern mask ]

SetWindowPatternMask:
@0402:  ldx     #%11
        stx     $f5
        rts

; ------------------------------------------------------------------------------

; [ set border area pattern mask ]

SetBorderPatternMask:
@0408:  ldx     #%1
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
@0428:  ldx     z0
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
        ldy     z0
        bra     DrawNumText

; ------------------------------------------------------------------------------

; [ draw number text (8 digit) ]

; experience

DrawNum8:
@04a3:  ldy     #8
        sty     $e0
        ldy     z0
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
        ldy     z0
; fall through

; ------------------------------------------------------------------------------

; [ draw number text ]

;      +X: destination address (+$7e0000)
;      +Y: text buffer offset
;     $29: vhopppmm high byte of bg data (zTextColor)
;    +$e0: text length
; $f7-$ff: text buffer

DrawNumText:
@04c7:  stx     $eb
        lda     #$7e
        sta     $ed
        tyx
        ldy     z0
@04d0:  lda     $f7,x
        sta     [$eb],y
        iny
        lda     zTextColor
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
        ldy     z0
        ldx     #2
@04e8:  lda     $00f7,y
        cmp     #ZERO_CHAR
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
        ldy     z0
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
        adc     #ZERO_CHAR
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
        ldy     z0
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
        adc     #ZERO_CHAR
        sta     $00f7,y
        iny
        dec     $e0
        bne     @0535
        ldy     z0
        ldx     #$0004
@0567:  lda     $00f7,y
        cmp     #ZERO_CHAR
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
        ldy     z0
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
        adc     #ZERO_CHAR
        sta     $00f7,y
        iny
        inx2
        dec     $e0
        bne     @058b
        ldy     z0
        ldx     #$0007
@05cd:  lda     $00f7,y
        cmp     #ZERO_CHAR
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
        ldy     z0
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
        lda     z0
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
@072d:  lda     z0a+1                     ; branch if up button is not pressed
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
@0750:  lda     z0a+1                     ; branch if down button is not pressed
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
@0773:  lda     z0a+1                     ; branch if left button is not pressed
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
@0792:  lda     z0a+1                     ; branch if right button is not pressed
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
        ldy     #near CursorTask
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ cursor sprite task ]

CursorTask:
@07b8:  tax
        jmp     (near CursorTaskTbl,x)

CursorTaskTbl:
@07bc:  .addr   CursorTask_00
        .addr   CursorTask_01

; ------------------------------------------------------------------------------

; state $00: init
CursorTask_00:
@07c0:  ldx     zTaskOffset
        longa
        lda     #near CursorAnimData
        sta     near wTaskAnimPtr,x
        shorta
        lda     #^CursorAnimData
        sta     near wTaskAnimBank,x
        jsr     InitAnimTask
        inc     near wTaskState,x                 ; increment task state
        lda     #$01
        sta     near wTaskFlags,x                 ; sprite doesn't scroll with bg
; fallthrough

; ------------------------------------------------------------------------------

; state $01: update
CursorTask_01:
@07dc:  lda     z46                     ; terminate if cursor 1 & 2 are inactive
        and     #$06
        beq     @07fd
        lda     z45                     ;
        bit     #$04
        beq     @07fb
        ldx     zTaskOffset
        longa
        lda     $55                     ; set cursor x position
        sta     near wTaskPosX,x
        lda     $57                     ; set cursor y position
        sta     near wTaskPosY,x
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
        jmp     (near FlashingCursorTaskTbl,x)

FlashingCursorTaskTbl:
@0803:  .addr   FlashingCursorTask_00
        .addr   FlashingCursorTask_01
        .addr   FlashingCursorTask_02
        .addr   FlashingCursorTask_03

; ------------------------------------------------------------------------------

; state $00, $02: init
FlashingCursorTask_00:
FlashingCursorTask_02:
@080b:  ldx     zTaskOffset
        lda     #$01
        tsb     z46                     ; flashing cursor task is active
        longa
        lda     #near FlashingCursorAnimData
        sta     near wTaskAnimPtr,x
        shorta
        lda     #^FlashingCursorAnimData
        sta     near wTaskAnimBank,x
        jsr     InitAnimTask
        lda     #$01
        sta     near wTaskFlags,x                 ; sprite doesn't scroll with bg
        inc     near wTaskState,x                 ; increment task state
; fall through

; ------------------------------------------------------------------------------

; state $01: update (vertical scroll)
FlashingCursorTask_01:
@082b:  lda     z46                     ; terminate if flashing cursor not active
        bit     #$01
        beq     _0865
        ldx     zTaskOffset
        longa
        lda     zTextScrollRate
        neg_a
        clc
        adc     near wTaskPosY,x
        sta     near wTaskPosY,x                 ; set vertical offset
        shorta
        lda     z46
        and     #$c0
        beq     @0860
        lda     zSelIndex                     ; $e1 = current selection
.if LANG_EN
        sta     $e1
        inc
        sta     $e0                     ; $e0 = current selection + 1
        lda     $4a                     ; page scroll position + 9
        clc                             ; note: page must be at least 10 lines
        adc     #9
        cmp     $e1
        bcc     @0863                   ; return if flashing cursor past bottom
        lda     $4a
.else
        and     #$fe
        inc
        sta     $e0
        lda     $4a
        asl
        clc
        adc     #19
        cmp     $e0
        bcc     @0863
        lda     $4a
        asl
.endif
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
@0867:  lda     z46                     ; terminate if flashing cursor not active
        bit     #$01
        beq     _0865
        ldx     zTaskOffset
        longa
        lda     $97
        neg_a
        clc
        adc     near wTaskPosX,x
        sta     near wTaskPosX,x                 ; set horizontal offset
        shorta
        ldy     near wTaskPosX,x                 ; return if offscreen to the right
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
        ldy     #near MultiCursorTask
        jsr     CreateTask
        txy
        plx
        lda     #$7e
        pha
        plb
        lda     $85,x                   ; set cursor position
        sta     near wTaskPosX,y
        lda     $86,x
        sta     near wTaskPosY,y
        clr_a
        sta     near {wTaskPosX + 1},y                 ; clear high byte of x and y position
        sta     near {wTaskPosY + 1},y
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
        jmp     (near MultiCursorTaskTbl,x)

MultiCursorTaskTbl:
@08d5:  .addr   MultiCursorTask_00
        .addr   MultiCursorTask_01

; ------------------------------------------------------------------------------

; state 0: init
MultiCursorTask_00:
@08d9:  ldx     zTaskOffset
        lda     #$08                    ; activate multi-cursor
        tsb     z46
        longa
        lda     #near FlashingCursorAnimData
        sta     near wTaskAnimPtr,x
        shorta
        lda     #^FlashingCursorAnimData
        sta     near wTaskAnimBank,x
        jsr     InitAnimTask
        inc     near wTaskState,x                 ; increment task state
        lda     #$01
        sta     near wTaskFlags,x                 ; sprite doesn't scroll with bg

; ------------------------------------------------------------------------------

; state 1: update
MultiCursorTask_01:
@08f9:  lda     z46                     ; terminate if multi-cursor is not active
        bit     #$08
        beq     @0906
        ldx     zTaskOffset
        jsr     UpdateAnimTask
        sec
        rts
@0906:  clc
        rts

; ------------------------------------------------------------------------------

; [ update top/bottom page scroll flags ]

UpdateScrollArrowFlags:
@0908:  lda     #$c0
        tsb     z46
        lda     $4a                     ; branch if not at page 0
        bne     @0914
        lda     #$40                    ; page can't scroll up
        trb     z46
@0914:  lda     $4a                     ; branch if not at max page scroll position
        cmp     $5c
        bne     @091e
        lda     #$80                    ; page can't scroll down
        trb     z46
@091e:  rts

; ------------------------------------------------------------------------------

; [ init scroll indicator task (item/skills list) ]

CreateScrollArrowTask1:
@091f:  lda     #3                      ; priority 3
        ldy     #near ScrollArrowTask
        jsr     CreateTask
        longa
        lda     #$00e8                  ; should be #$e800 -> wTaskPosLongX
        sta     wTaskPosX,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init scroll indicator task (equip/relic item list) ]

CreateScrollArrowTask2:
@0933:  lda     #3                      ; priority 3
        ldy     #near ScrollArrowTask
        jsr     CreateTask
        longa
.if LANG_EN
        lda     #$0078                  ; x offset
.else
        lda     #$0070                  ; x offset
.endif
        sta     wTaskPosX,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ scroll indicator arrow task ]

ScrollArrowTask:
@0947:  tax
        jmp     (near ScrollArrowTaskTbl,x)

ScrollArrowTaskTbl:
@094b:  .addr   ScrollArrowTask_00
        .addr   ScrollArrowTask_01

; ------------------------------------------------------------------------------

; state $00: init
ScrollArrowTask_00:
@094f:  ldx     zTaskOffset
        longa
        lda     #near ScrollArrowAnimData_00
        sta     near wTaskAnimPtr,x
        shorta
        lda     #^ScrollArrowAnimData_00
        sta     near wTaskAnimBank,x
        inc     near wTaskState,x                 ; increment task state
        jsr     InitAnimTask
        lda     #$c0
        tsb     z46                     ; enable scrolling up and down
; fall through

; ------------------------------------------------------------------------------

; state $01: update
ScrollArrowTask_01:
@096a:  lda     z46                     ; scroll page flags
        and     #$c0
        beq     @09d9                   ; terminate task if page can't scroll up or down
        ldx     zTaskOffset
        jsr     UpdateScrollArrowFlags
@0975:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @0975
        lda     $354a,x                 ;
        sta     f:hM7A
        lda     $354b,x
        sta     f:hM7A
        lda     z4a                     ; page scroll position
        sta     f:hM7B
        sta     f:hM7B
.if LANG_EN
        lda     z4a
        bmi     @09aa
        clr_a
        lda     f:hMPYM
        longa_clc
        adc     near wTaskSpeedX,x
        sta     near wTaskPosY,x        ; set vertical offset
        shorta
        bra     @09bd
@09aa:  clr_a
        lda     f:hMPYM
        longa_clc
        adc     #$0070
        clc
        adc     near wTaskSpeedX,x
        sta     near wTaskPosY,x        ; set vertical offset
        shorta
@09bd:  clr_a
.else
        clr_a
        lda     f:hMPYM
        longa_clc
        adc     near wTaskSpeedX,x
        sta     near wTaskPosY,x
        shorta
.endif
        lda     z46                     ; scroll page flags
        and     #$c0
        lsr5
        txy
        tax
        longa
        lda     f:ScrollArrowAnimDataTbl,x
        sta     near wTaskAnimPtr,y
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
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z60
        phb
        lda     #$7e
        pha
        plb
        ldy     z0
        jsr     InitPortraitRowPos
        ldy     z0
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0015
        sta     near wTaskPosY,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 2) ]

CreatePortraitTask2:
@0a4b:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z61
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
        sta     near wTaskPosY,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 3) ]

CreatePortraitTask3:
@0a76:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z62
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
        sta     near wTaskPosY,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 4) ]

CreatePortraitTask4:
@0aa1:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z63
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
        sta     near wTaskPosY,x
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
        lda     zCharRowOrder,x
        and     #%00011000
        lsr2
        tax
        longa
        lda     f:PortraitAnimDataTbl,x
        ply
        sta     near wTaskAnimPtr,y
        shorta
        lda     #^Portrait1AnimData
        sta     near wTaskAnimBank,y
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
        bit     z45
        bne     @0aff
        lda     $75,x       ; character row
        bit     #$20
        beq     @0b06       ; branch if front row
@0aff:  longa
        lda     #26
        bra     @0b0b
@0b06:  longa
        lda     #14
@0b0b:  plx
        sta     near wTaskPosX,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ portrait task ]

PortraitTask:
@0b12:  tax
        jmp     (near PortraitTaskTbl,x)

PortraitTaskTbl:
        make_jump_tbl PortraitTask, 5

; ------------------------------------------------------------------------------

; state 0: init
make_jump_label PortraitTask, 0
@0b20:  ldx     zTaskOffset
        inc     near wTaskState,x
        lda     #1
        sta     near wTaskFlags,x
; fall through

; ------------------------------------------------------------------------------

; state 1: update
make_jump_label PortraitTask, 1
@0b2a:  ldx     zTaskOffset
        lda     $35c9,x
        bmi     @0b36
        jsr     UpdateAnimTask
        sec
        rts
@0b36:  clc
        rts

; ------------------------------------------------------------------------------

; state 2: slide to the right
make_jump_label PortraitTask, 2
@0b38:  ldx     zTaskOffset
        longa
        lda     #$0001
        sta     near wTaskSpeedX,x
        lda     #12
        sta     near w7e3349,x
        shorta
        bra     PortraitTask_04

; ------------------------------------------------------------------------------

; state 3: slide to the left
make_jump_label PortraitTask, 3
@0b4c:  ldx     zTaskOffset
        longa
        lda     #$ffff
        sta     near wTaskSpeedX,x
        lda     #12
        sta     near w7e3349,x
        shorta
; fall through

; ------------------------------------------------------------------------------

; state 4: wait for slide
make_jump_label PortraitTask, 4
@0b5e:  ldx     zTaskOffset
        lda     #4                      ; state on state 4
        sta     near wTaskState,x
        longa
        lda     near w7e3349,x                 ; branch if slide complete
        beq     @0b80
        lda     near wTaskSpeedX,x                 ; increase horizontal position
        clc
        adc     near wTaskPosX,x
        sta     near wTaskPosX,x
        dec     near w7e3349,x                 ; decrement movement counter
        shorta
        jsr     UpdateAnimTask
        sec
        rts

; slide complete
@0b80:  shorta
        lda     #1                      ; back to state 1
        sta     near wTaskState,x
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
        ldx     zSelCharPropPtr
        lda     a:$0008,x     ; character level
        jsr     HexToDec3
        longa
        lda     [$ef]       ; get bg data address
        tax
        shorta
        jsr     DrawNum2
        ldx     zSelCharPropPtr
        lda     a:$000b,x     ; max hp
        sta     $f3
        lda     a:$000c,x
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        jsr     HexToDec5
        ldy     #$0004
        jsr     DrawHPMP
        ldy     zSelCharPropPtr
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
        ldx     zSelCharPropPtr
        lda     a:$000f,x     ; max mp
        sta     $f3
        lda     a:$0010,x
        sta     $f4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        jsr     HexToDec5
        ldy     #$0008
        jsr     DrawHPMP
        ldy     zSelCharPropPtr
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
        lda     [zef],y
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
        ldx     zSelCharPropPtr
        clr_a
        lda     a:0,x     ; set carry and return if the character is gogo
        cmp     #CHAR_PROP::GOGO
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
        jmp     (near MaxHPMPTbl,x)

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
@0dac:  ldy     w022f
        sty     $4f
        lda     $4f
        sta     $4d
        lda     w0231
        bra     _0e1e

; ------------------------------------------------------------------------------

; [ swap two characters' saved cursor positions ]

SwapSavedCharCursorPos:
@0dba:  clr_a
        lda     $4b
        asl
        tax
        lda     zSelIndex
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
        lda     zSelIndex
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
        lda     zSelIndex         ; selected character slot
        asl
        tax
        ldy     $0236,x     ; saved skills cursor position
        sty     $4d
        rts

; ------------------------------------------------------------------------------

; [ restore saved cursor position (magic) ]

RestoreMagicCursorPos:
@0e0a:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     $023e,x     ; saved magic cursor position
        sty     $4f
        lda     $4f
        sta     $4d
        lda     zSelIndex
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
        ldy     #near wBG1Tiles::ScreenA
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens B & C) ]

TfrBG1ScreenBC:
@0e36:  ldy     #$0400
        sty     hVMADDL
        ldy     #near wBG1Tiles::ScreenB
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens C & D) ]

TfrBG1ScreenCD:
@0e44:  ldy     #$0800
        sty     hVMADDL
        ldy     #near wBG1Tiles::ScreenC
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (screens A & B) ]

TfrBG2ScreenAB:
@0e52:  ldy     #$1000
        sty     hVMADDL
        ldy     #near wBG2Tiles::ScreenA
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (screens C & D) ]

TfrBG2ScreenCD:
@0e60:  ldy     #$1800
        sty     hVMADDL
        ldy     #near wBG2Tiles::ScreenC
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (screens A & B) ]

TfrBG3ScreenAB:
@0e6e:  ldy     #$4000
        sty     hVMADDL
        ldy     #near wBG3Tiles::ScreenA
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (screens C & D) ]

TfrBG3ScreenCD:
@0e7c:  ldy     #$4800
        sty     hVMADDL
        ldy     #near wBG3Tiles::ScreenC
        sty     hDMA0::ADDR
; fall through

; copy bg data to vram, must already be in vblank
TfrBGTiles:
@0e88:  lda     #$01        ; two address - low, high
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        lda     #$7e
        sta     hDMA0::ADDR_B
        ldy     #$1000      ; dma size (two screens)
        sty     hDMA0::SIZE
        lda     #BIT_0
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

; NOTE: Unlike TfrBGTiles, these routines do not need to be called during vblank

InitDMA1BG1ScreenAB:
@0ee9:  ldy     #$0000
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG1Tiles::ScreenA
        sta     zDMA1Src+2
        ldy     #$1000
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screen A) ]

InitDMA1BG1ScreenA:
@0efd:  ldy     #$0000
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG1Tiles::ScreenA
        sta     zDMA1Src+2
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screen B) ]

InitDMA1BG1ScreenB:
@0f11:  ldy     #$0400
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenB
        sty     zDMA1Src
        lda     #^wBG1Tiles::ScreenB
        sta     zDMA1Src+2
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screens A & B) ]

InitDMA1BG3ScreenAB:
@0f25:  ldy     #$4000
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA1Src+2
        ldy     #$1000
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screen A) ]

InitDMA1BG3ScreenA:
@0f39:  ldy     #$4000
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA1Src+2
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screen B) ]

InitDMA1BG3ScreenB:
@0f4d:  ldy     #$4400
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenB
        sty     zDMA1Src
        lda     #^wBG3Tiles::ScreenB
        sta     zDMA1Src+2
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 2 (bg3 data, screen A) ]

InitDMA2BG3ScreenA:
@0f61:  ldy     #$4000
        sty     zDMA2Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA2Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA2Src+2
        ldy     #$0800
        sty     zDMA2Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 2 (bg3 data, screen B) ]

InitDMA2BG3ScreenB:
@0f75:  ldy     #$4400
        sty     zDMA2Dest
        ldy     #near wBG3Tiles::ScreenB
        sty     zDMA2Src
        lda     #^wBG3Tiles::ScreenB
        sta     zDMA2Src+2
        ldy     #$0800
        sty     zDMA2Size
        rts

; ------------------------------------------------------------------------------

; [ disable dma 2 ]

DisableDMA2:
@0f89:  stz     zDMA2Dest
        stz     zDMA2Dest+1
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
        ldy     z0
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
        ldy     #near FadePalTask
        jsr     CreateTask
        pla
        sta     $7e37ca,x
        lda     $e9
        sta     w7e36c9,x
        lda     $ed
        sta     wAnimCounter,x
        longa
        lda     $e7
        sta     wTaskPosLongX,x
        lda     $eb
        sta     wTaskPosLongY,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ fade in/out palette task ]

; +$3349 = color counter
; +$33c9 = destination address (+$7e0000) wTaskPosLongX
; +$3449 = source address wTaskPosLongY
;  $35c9 = frame counter
;  $36c9 = destination bank (always $7e)
;  $36ca = source bank
;  $37ca = speed (frames per update)

FadePalTask:
@0fdd:  tax
        jmp     (near FadePalTaskTbl,x)

FadePalTaskTbl:
@0fe1:  .addr   FadePalTask_00
        .addr   FadePalTask_01

; ------------------------------------------------------------------------------

; state 0: init
FadePalTask_00:
@0fe5:  ldx     zTaskOffset
        lda     #$1f
        sta     near w7e3349,x                 ; set color counter to 31
        lda     z0
        sta     $334a,x
        inc     near wTaskState,x                 ; increment task state
        sec
        rts

; ------------------------------------------------------------------------------

; state 1: update
FadePalTask_01:
@0ff6:  ldx     zTaskOffset
        lda     $35c9,x                 ; branch if waiting for frame counter
        bne     @1032
        lda     $37ca,x                 ; set frame counter
        sta     $35c9,x
        lda     $36c9,x                 ; +$e0 = destination address
        sta     $e2
        lda     $36ca,x                 ; +$e3 = source address
        sta     $e5
        longa
        lda     near wTaskPosLongX,x
        sta     $e0
        lda     near wTaskPosLongY,x
        sta     $e3
        lda     near w7e3349,x                 ; $f1 = color counter value
        sta     $f1
        jsr     UpdateFadePal
        shorta
        ldx     a:$002d                 ; task data pointer
        lda     near w7e3349,x                 ; decrement color counter
        beq     @1030
        dec     near w7e3349,x
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
        ldy     z0
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
@1114:  ldx     z0
        stx     zTaskOffset
        stx     zNumTasks
        longa
        jsr     ResetSprites
        shorti
        ldx     #$7e
        phx
        plb
        ldx     #0
@1127:  stz     near wTaskCodePtr,x                 ; clear task data
        stz     near wTaskState,x
        stz     $35c9,x
        stz     near wTaskPal,x
        stz     near wTaskPosLongX,x
        stz     near wTaskPosLongY,x
        stz     near wTaskSpeedLongX,x
        stz     near wTaskSpeedLongY,x
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
@114e:  ldx     z0
@1150:  lda     #$e001
        sta     wSprites,x                 ; move all sprites offscreen
        inx2
        lda     #$0001
        sta     wSprites,x
        inx2
        cpx     #$0200
        bne     @1150
        ldy     z0                      ; clear high sprite data
        tya
@1168:  sta     wSpritesHi,y
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
        lda     zTaskOffset
        sta     $7e374a,x               ; set task data pointer
        inc     zNumTasks
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
@1196:  lda     near wTaskCodePtr,x                 ; find the first available task in this priority level
        bne     @11a0
        tya
        sta     near wTaskCodePtr,x                 ; set task code pointer
        rts
@11a0:  inx2
        cpx     #$0080
        bne     @1196
        dex2                            ; no empty task found, use the second to last one
        tya
        sta     near wTaskCodePtr,x                 ; set task data pointer
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
        ldx     #wSprites                  ; set starting pointers to sprite data
        stx     zSpritePtr
        ldx     #wSpritesHi
        stx     zSpriteHiPtr
        lda     #$03                    ; initial mask for hi-sprite data
        sta     $33
        stz     $34
        ldx     #$0080                  ; start with 128 unused sprites
        stx     z31
        ldx     z0
        longa
@11ce:  lda     near wTaskCodePtr,x                 ; task code pointer
        beq     @11f5                   ; branch if task is not active
        stx     zTaskOffset
        phx
        sta     zTaskCodePtr
        shorta
        clr_a
        lda     near wTaskState,x                 ; task state
        asl
        jsr     @1203                   ; execute task
        longa
        plx
        bcs     @11f5                   ; branch if task didn't terminate
        stz     near wTaskCodePtr,x                 ; clear task data
        stz     near wTaskState,x
        stz     $35c9,x
        stz     near wTaskPal,x
        dec     zNumTasks
@11f5:  inx2                            ; next task
        cpx     #$0080
        bne     @11ce
        jsr     HideUnusedSprites
        shorta
        plb
        rts

; execute task (carry clear: terminate, carry set: don't terminate)
@1203:  jmp     (zTaskCodePtr)

; ------------------------------------------------------------------------------

; [ init animation task ]

InitAnimTask:
@1206:  clr_a
        sta     near w7e36c9,x
        longa
        lda     near wTaskAnimPtr,x
        sta     $eb
        shorta
        lda     near wTaskAnimBank,x
        sta     $ed
        ldy     #2
        lda     [$eb],y
        sta     near wAnimCounter,x
        rts

; ------------------------------------------------------------------------------

; [ update animation task ]

UpdateAnimTask:
@1221:  jsr     UpdateAnimData
        jmp     UpdateAnimSprites

; ------------------------------------------------------------------------------

; [ update animation data ]

UpdateAnimData:
@1227:  ldx     zTaskOffset
        ldy     z0
        longa
        lda     near wTaskAnimPtr,x     ; ++$eb = animation data pointer
        sta     $eb
        shorta
        lda     near wTaskAnimBank,x
        sta     $ed
@1239:  lda     near wAnimCounter,x     ; next animation data byte
        cmp     #$fe
        beq     @1262                   ; return if $fe (stop animation)
        cmp     #$ff
        bne     @124c                   ; branch if not $ff (repeat)
        stz     near w7e36c9,x          ; reset animation data offset
        jsr     SetAnimDur
        bra     @1239
@124c:  lda     near wAnimCounter,x     ; frame counter
        bne     @125f                   ; decrement and return if not zero
        lda     near w7e36c9,x          ; increment animation data offset
        clc
        adc     #3
        sta     near w7e36c9,x
        jsr     SetAnimDur
        bra     @1239
@125f:  dec     near wAnimCounter,x     ; decrement frame counter
@1262:  rts

; ------------------------------------------------------------------------------

; [ set animation frame counter ]

SetAnimDur:
@1263:  shorti
        lda     near w7e36c9,x          ; animation data offset + 2
        tay
        iny2
        lda     [$eb],y
        sta     near wAnimCounter,x     ; set frame counter
        longi
        rts

; ------------------------------------------------------------------------------

; [ update animation sprites ]

UpdateAnimSprites:
@1273:  shorti
        lda     near w7e36c9,x          ; animation data offset
        tay
        longa
        lda     [$eb],y                 ; ++$e7 = pointer to sprite data
        sta     $e7
        iny2
        shorta
        lda     near wTaskAnimBank,x
        sta     $e9
        longi
        ldy     z0
        lda     z31                     ; return if there are no unused sprites remaining
        beq     @12fb
        lda     [$e7],y
        sta     $e6                     ; $e6 = number of sprites
        beq     @12fb                   ; return if there are no sprites
        iny
@1297:  lda     [$e7],y                 ; $e0 = x position
        sta     $e0
        bpl     @12b0                   ; branch if not a 32x32 sprite
        clr_a
        lda     z33
        tax
        lda     f:LargeSpriteTbl,x      ; high sprite mask
        clc
        adc     z34
        sta     z34
        sta     (zSpriteHiPtr)                   ; set sprite high data
        ldx     zTaskOffset
        bra     @12b4
@12b0:  lda     z34
        sta     (zSpriteHiPtr)                   ; set sprite high data
@12b4:  lda     $e0
        and     #$7f
        sta     $e0
        lda     near wTaskFlags,x
        bit     #$01
        beq     @12ce
        stz     $e1
        longa
        lda     $e0
        sec
        sbc     zBG1HScroll
        sta     $e0
        shorta
@12ce:  jsr     DrawAnimSprite
        dec     z33                     ; decrement pointer to high sprite data masks
        bpl     @12df                   ; branch if positive
        lda     #%11                    ; reset to 3
        sta     z33
        stz     z34                     ; clear current high sprite data byte
        longa
        inc     zSpriteHiPtr                     ; increment pointer to high sprite data
@12df:  longa
        lda     $e0
        sta     (zSpritePtr)                   ; set sprite data (position)
        inc     zSpritePtr
        inc     zSpritePtr
        lda     $e2
        sta     (zSpritePtr)                   ; set sprite data (other bytes)
        inc     zSpritePtr
        inc     zSpritePtr
        shorta
        dec     z31                     ; decrement number of unused sprites
        beq     @12fb
        dec     $e6                     ; next sprite
        bne     @1297
@12fb:  rts

; ------------------------------------------------------------------------------

; [ update animation sprite data ]

DrawAnimSprite:
@12fc:  lda     $e0                     ; $e0 = x position
        clc
        adc     near wTaskPosX,x                 ; add horizontal offset
        sta     $e0
        iny
        lda     [$e7],y                 ; $e1 = y position
        clc
        adc     near wTaskPosY,x                 ; add vertical offset
        sta     $e1
        iny
        lda     [$e7],y                 ; $e2 = graphics offset
        sta     $e2
        iny
        lda     near wTaskFlags,x                 ; branch if not flipped horizontal
        bit     #$02
        beq     @1320
        lda     [$e7],y
        ora     #$40
        bra     @1322
@1320:  lda     [$e7],y
@1322:  sta     $e3                     ; $e3 = vhoopppm
        lda     near wTaskPal,x                 ; special palette
        beq     @1332
        lda     $e3
        and     #%11110001
        ora     near wTaskPal,x
        sta     $e3
@1332:  iny
        rts

; ------------------------------------------------------------------------------

; large sprite flags for high sprite data
LargeSpriteTbl:
@1334:  .byte   $80,$20,$08,$02

; ------------------------------------------------------------------------------

; [ hide unused sprites ]

HideUnusedSprites:
@1338:  .a16
        ldy     z31
        beq     @134c
        ldx     #$01fc
        lda     #$e001
@1342:  sta     wSprites,x
        dex4
        dey
        bne     @1342
@134c:  rts
        .a8

; ------------------------------------------------------------------------------

; [ wait for next frame ]

WaitFrame:
@134d:  jsr     WaitVblank
        lda     z46                     ; branch if not scrolling text
        bit     #$20
        beq     @1359
        jsr     UpdateTextScroll
@1359:  jsl     UpdateCtrlMenu
        lda     zWaitCounter
        beq     @1367                   ; return if not waiting for menu state counter
        clr_ay
        sty     z08                     ; clear controller buttons
        sty     z0a
@1367:  rts

; ------------------------------------------------------------------------------

; [ wait for vblank ]

WaitVblank:
@1368:  lda     #$81                    ; enable interrupts
        sta     hNMITIMEN
        sta     zInterruptEnable
        cli
@1370:  lda     zInterruptEnable
        bne     @1370
        sei                             ; disable interrupts
        lda     zScreenBrightness
        sta     hINIDISP
        lda     zEnableHDMA
        sta     hHDMAEN
        lda     zMosaic
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
        lda     zInterruptEnable
        beq     @13b1
        jsr     UpdatePPU
        longa
        inc     $cf                     ; increment frame counter
        shorta
        ldy     zWaitCounter                     ; decrement menu state frame counter
        beq     @13b1
        dey
        sty     zWaitCounter
@13b1:  jsl     DecTimersMenuBattle_ext
        jsl     IncGameTime
        inc     zFrameCounter
        clr_a
        sta     zInterruptEnable
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
@13c8:  lda     wGameTimeFrames
        cmp     #60
        beq     @13d1
        bra     @13fc
@13d1:  stz     wGameTimeFrames
        lda     wGameTimeSeconds
        cmp     #59
        beq     @13e0
        inc     wGameTimeSeconds
        bra     @13fc
@13e0:  stz     wGameTimeSeconds
        lda     wGameTimeMinutes
        cmp     #59
        beq     @13ef
        inc     wGameTimeMinutes
        bra     @13fc
@13ef:  stz     wGameTimeMinutes
        lda     wGameTimeHours
        cmp     #99
        beq     @13fc
        inc     wGameTimeHours
@13fc:  lda     wGameTimeHours
        cmp     #99
        bne     @140d
        lda     wGameTimeMinutes
        cmp     #59
        bne     @140d
        stz     wGameTimeSeconds
@140d:  inc     wGameTimeFrames
        clr_a
        rtl

; ------------------------------------------------------------------------------

; [ update ppu registers and transfer data to vram ]

UpdatePPU:

; disable DMA
@1412:  stz     hHDMAEN
        stz     hMDMAEN

; set bg scrolling registers
        lda     zBG1HScroll
        sta     hBG1HOFS
        lda     zBG1HScroll+1
        sta     hBG1HOFS
        lda     zBG1VScroll
        sta     hBG1VOFS
        lda     zBG1VScroll+1
        sta     hBG1VOFS
        lda     zBG2HScroll
        sta     hBG2HOFS
        lda     zBG2HScroll+1
        sta     hBG2HOFS
        lda     zBG2VScroll
        sta     hBG2VOFS
        lda     zBG2VScroll+1
        sta     hBG2VOFS
        lda     zBG3HScroll
        sta     hBG3HOFS
        lda     zBG3HScroll+1
        sta     hBG3HOFS
        lda     zBG3VScroll
        sta     hBG3VOFS
        lda     zBG3VScroll+1
        sta     hBG3VOFS
        jsr     UpdateMode7Regs
        jsr     TfrSprites
        jsr     TfrPal
        jsr     TfrVRAM1
        jmp     TfrVRAM2

; ------------------------------------------------------------------------------

; [ copy sprite data to ppu ]

TfrSprites:
@1463:  ldx     z0          ; clear oam address
        stx     hOAMADDL
        txa
        sta     hDMA0::ADDR_B
        lda     #$02
        sta     hDMA0::CTRL
        lda     #<hOAMDATA
        sta     hDMA0::HREG
        ldy     #wSprites
        sty     hDMA0::ADDR
        ldy     #$0220
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy data/graphics to vram 1 ]

TfrVRAM1:
@1488:  ldy     zDMA1Dest
        sty     hVMADDL
        lda     #$01
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldy     zDMA1Src
        sty     hDMA0::ADDR
        lda     zDMA1Src+2
        sta     hDMA0::ADDR_B
        ldy     zDMA1Size
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy data/graphics to vram 2 ]

TfrVRAM2:
@14ac:  ldy     zDMA2Dest
        beq     @14d1
        sty     hVMADDL
        lda     #$01
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldy     zDMA2Src
        sty     hDMA0::ADDR
        lda     zDMA2Src+2
        sta     hDMA0::ADDR_B
        ldy     zDMA2Size
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
@14d1:  rts

; ------------------------------------------------------------------------------

; [ copy color palettes to ppu ]

TfrPal:
@14d2:  lda     z45
        bit     #$01
        beq     @14fd
        lda     z0
        sta     hCGADD
        lda     #$02
        sta     hDMA0::CTRL
        lda     #<hCGDATA
        sta     hDMA0::HREG
        ldy     #near wPalBuf
        sty     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        ldy     #$0200
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
@14fd:  rts

; ------------------------------------------------------------------------------
