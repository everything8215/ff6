
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: status.asm                                                           |
; |                                                                            |
; | description: status menu                                                   |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import BattleCmdName, BattleCmdProp, LevelUpExp

.segment "menu_code"

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
        ldy     #.loword(StatusMainWindow)
        jsr     DrawWindow
        ldy     #.loword(StatusTitleWindow)
        jsr     DrawWindow
        ldy     #.loword(StatusCmdWindow)
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
        lda     f:BattleCmdProp,x
        and     #BATTLE_CMD_FLAG::GOGO
        beq     @5e60                   ; branch can't be used by gogo
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
@5e75:  lda     f:StatusGogoWindow,x
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
        jsr     DrawCmdNameGogo
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
        jmp     _c35f50

; ------------------------------------------------------------------------------

; [ draw battle command name (Gogo's status menu) ]

DrawCmdNameGogo:
@5ed7:  pha
        jsr     InitTextBuf
        pla
        bmi     _5f0c
        jmp     _5ee6

; ------------------------------------------------------------------------------

; [ draw battle command name (status menu and command arrange) ]

DrawCmdName:
@5ee1:  jsr     CheckRelicCmd
        bmi     _5f0c
_5ee6:  jsr     CheckCmdEnabled
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
        ldy     #7
@5efb:  lda     f:BattleCmdName,x   ; battle command names
        sta     hWMDATA
        inx
        dey
        bne     @5efb
_5f06:  stz     hWMDATA
        jmp     DrawPosTextBuf

; clear command name
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

; [ check if a battle command is enabled (for font color) ]

CheckCmdEnabled:
@5f25:  pha
        cmp     #$0b
        beq     @5f3a
        cmp     #$07
        beq     @5f44

; use white text
@5f2e:  lda     #$20
        sta     $29
        pla
        rts

; use gray text
@5f34:  lda     #$24
        sta     $29
        pla
        rts

; runic
@5f3a:  lda     $11da
        ora     $11db
        bpl     @5f34
        bra     @5f2e

; swdtech
@5f44:  lda     $11da
        ora     $11db
        bit     #$02
        beq     @5f34
        bra     @5f2e

; ------------------------------------------------------------------------------

; [  ]

_c35f50:
@5f50:  ldx     #$61ca
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
StatusTitleWindow:
@5f79:  .byte   $8b,$58,$06,$01

StatusCmdWindow:
@5f7d:  .byte   $eb,$5a,$09,$06

StatusMainWindow:
@5f81:  .byte   $8b,$58,$1c,$18

; gogo window is in 2 parts
StatusGogoWindow:
@5f85:  .byte   $c7,$58,$00,$12
        .byte   $87,$60,$07,$12

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
        jsr     CalcNextLevelExp
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

; [ calculate experience needed to reach next level ]

.proc CalcNextLevelExp
        ldx     $67
        clr_a
        lda     a:$0008,x
        cmp     #99
        beq     max_level
        jsr     CalcLevelExpTotal
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

max_level:
        clr_ax
        stx     $f1
        stz     $f3
        rts
.endproc  ; CalcNextLevelExp

; ------------------------------------------------------------------------------

; [ calculate total experience for level -> ++$f3 ]

; A: level

.proc CalcLevelExpTotal
        asl
        sta     $eb
        clr_ax
        stx     $f1
        stx     $f3
        stz     $ec
loop:   clc
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
        bne     loop
        longa
.repeat 3
        asl     $f1
        rol     $f3
.endrep
        shorta
        rts
.endproc  ; CalcLevelExpTotal

; ------------------------------------------------------------------------------

; [  ]

_c36102:
@6102:  ldy     #$7bf1
        jsr     InitTextBuf
        jsr     DrawCmdName
        ldy     #$7c71
        jsr     InitTextBuf
        iny
        jsr     DrawCmdName
        ldy     #$7cf1
        jsr     InitTextBuf
        iny2
        jsr     DrawCmdName
        ldy     #$7d71
        jsr     InitTextBuf
        iny3
        jmp     DrawCmdName

; ------------------------------------------------------------------------------

; [ check relic-upgraded battle commands ]

CheckRelicCmd:
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

; [ menu state $42: party select status menu (init) ]

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

; [ menu state $43: party select status menu ]

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

; [ menu state $6a: gogo command list ]

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
