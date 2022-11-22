
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: colosseum.asm                                                        |
; |                                                                            |
; | description: colosseum menus                                               |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

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
        jsr     InitDMA1BG1ScreenA
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
        jsr     LoadWindowGfx
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
        jsr     InitDMA1BG1ScreenA
        jsr     EnableInterrupts
        jmp     InitDMA1BG3ScreenA

; ------------------------------------------------------------------------------

; [ create task for "VS" sprite in colosseum ]

CreateColosseumVSTask:
@ae07:  lda     #1
        ldy     #.loword(ColosseumVSTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ menu state $76: colosseum character select ]

MenuState_76:
@ae0f:  jsr     InitDMA1BG3ScreenA
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
        jne     _b286                   ; branch if prize name is not shown
        lda     $0207
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
        jsr     GetMonsterNamePtr
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
        jsl     Decompress_ext
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
