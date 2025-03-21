
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: party.asm                                                            |
; |                                                                            |
; | description: party select menu                                             |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ menu state $2c: party select init ]

MenuState_2c:
@70e7:  jsr     _c370fc
        stz     z4a
        stz     z5a
        stz     z99
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
        lda     #BIT_6 | BIT_7
        trb     zEnableHDMA
        lda     #$02
        sta     z46
        lda     #$06
        tsb     z47
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37114:
@7114:  jsr     CreateCursorTask
        jsr     _c375c5
        jsr     DrawPartyMenu
        jsr     _c3793f
        jsr     _c37953
        jsr     InitDMA1BG1ScreenA
        lda     #$2d
        sta     zNextMenuState
        lda     #$66
        sta     zMenuState
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $7d: return to party select (from status) ]

MenuState_7d:
@7131:  jsr     _c370fc
        lda     z5d
        sta     z99
        jsr     _c37677
        lda     z90
        bne     @714b
        jsr     LoadPartyCharCursor
        ldy     z8e
        sty     z4d
        jsr     InitPartyCharCursor
        bra     @7165
@714b:  lda     z90
        sta     z4a
        lda     z8d
        sta     z5a
        jsr     _c373db
        ldy     z8e
        sty     z4d
        lda     $79
        sta     z59
        ldy     $7a
        sty     z53
        jsr     UpdatePartyCursor
@7165:  jmp     _c37114

; ------------------------------------------------------------------------------

; [ menu state $2d: party select (select 1st slot) ]

MenuState_2d:
@7168:  jsr     _c371b9
        bcc     @71b8
        lda     z08
        bit     #JOY_A
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
        sta     zSelIndex
        lda     $4a
        sta     $49
        lda     $5a
        sta     $5b
        lda     #$2e
        sta     zMenuState
        jsr     _c32f21
        lda     $4a
        beq     @71a1
        lda     #2
        sta     wTaskState,x
@71a1:  rts
@71a2:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts
@71a9:  lda     z08+1
        bit     #>JOY_START
        bne     @71b5
        lda     z08+1
        bit     #>JOY_B
        beq     @71b8
@71b5:  jsr     _c37296
@71b8:  rts

; ------------------------------------------------------------------------------

; [  ]

_c371b9:
@71b9:  jsr     _c375b8
        lda     z0a+1
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
@71de:  lda     z0a+1
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

; [ menu state $2e: party select (select 2nd slot) ]

_720b:  rts

MenuState_2e:
@720c:  jsr     _c371b9
        bcc     _720b
        lda     z08
        bit     #JOY_A
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
        lda     zSelIndex
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
        lda     z59
        sta     $79
        ldy     z53
        sty     $7a
        ldy     z4d
        sty     z8e
        lda     z4a
        sta     z90
        lda     z5a
        sta     z8d
        lda     z99
        sta     z5d
        lda     #$42
        sta     zNextMenuState
        lda     #$67
        sta     zMenuState
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
@727d:  lda     z08+1
        bit     #>JOY_B
        beq     @728e
        jsr     PlayCancelSfx
@7286:  lda     #$2d
        sta     zMenuState
        lda     #$05
        trb     z46
@728e:  rts
@728f:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c37296:
@7296:  clr_ax
        lda     w0201       ; number of parties
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
        stz     w0205
        lda     #$ff
        sta     zNextMenuState
        lda     #$67
        sta     zMenuState
        rts
@72cb:  jsr     PlayInvalidSfx
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        lda     w0201
        and     #%111
        cmp     #1
        beq     @72e9                   ; branch if one party

; "You need # group(s)!"
        ldy     #near PartyErrorMsg1Text
        jsr     DrawPosKana
        ldx_pos BG1A, {19, 3}
        jsr     DrawNumParties
        bra     @72ef

; "No one there!"
@72e9:  ldy     #near PartyErrorMsg2Text
        jsr     DrawPosKana
@72ef:  lda     #$20
        sta     zWaitCounter
        lda     #$69
        sta     zMenuState
        rts

; ------------------------------------------------------------------------------

; [  ]

_c372f8:
@72f8:  clr_a
        lda     zSelIndex
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
        lda     zSelIndex
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
        lda     zSelIndex
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
        lda     w0201       ; number of parties
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
        lda     w0201       ; number of parties
        and     #$7f
        cmp     #$01
        beq     @742c       ; branch if one
        cmp     #$02
        jne     UpdateThreePartyCursor
        jmp     UpdateTwoPartyCursor
@742c:  jmp     UpdateOnePartyCursor
@742f:  jmp     UpdatePartyCharCursor

; ------------------------------------------------------------------------------

; [  ]

_c37432:
@7432:  lda     $5e
        ldx     z0
@7436:  cmp     f:_c37466,x
        beq     @7444
        inx2
        cpx     #sizeof__c37466
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
        ldx     z0
@7450:  cmp     f:_c37476,x
        beq     @745e
        inx2
        cpx     #sizeof__c37476
        bne     @7450
        rts
@745e:  inx
        lda     f:_c37476,x
        sta     $4d
        rts

; ------------------------------------------------------------------------------

_c37466:
        .byte   0,0,1,1,2,1,3,2,4,3,5,4,6,4,7,5
        calc_size _c37466

_c37476:
        .byte   0,0,1,1,2,3,3,4,4,6,5,7
        calc_size _c37476

; ------------------------------------------------------------------------------

; [ load character cursor for party select (lower area) ]

LoadPartyCharCursor:
@7482:  ldy     #near PartyCharCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update character cursor for party select (lower area) ]

UpdatePartyCharCursor:
@7488:  jsr     MoveCursor

InitPartyCharCursor:
@748b:  ldy     #near PartyCharCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; [ load cursor for party 1 area ]

LoadOnePartyCursor:
@7491:  ldy     #near OnePartyCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for party 1 area ]

UpdateOnePartyCursor:
@7497:  jsr     MoveCursor

InitOnePartyCursor:
@749a:  ldy     #near OnePartyCursorPos
        jmp     UpdateHorzCursorPos

; ------------------------------------------------------------------------------

; [ load cursor for party 2 area ]

LoadTwoPartyCursor:
@74a0:  ldy     #near TwoPartyCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for party 2 area ]

UpdateTwoPartyCursor:
@74a6:  jsr     MoveCursor

InitTwoPartyCursor:
@74a9:  ldy     #near TwoPartyCursorPos
        jmp     UpdateHorzCursorPos

; ------------------------------------------------------------------------------

; [ load cursor for party 3 area ]

LoadThreePartyCursor:
@74af:  ldy     #near ThreePartyCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for party 3 area ]

UpdateThreePartyCursor:
@74b5:  jsr     MoveCursor

InitThreePartyCursor:
@74b8:  ldy     #near ThreePartyCursorPos
        jmp     UpdateHorzCursorPos

; ------------------------------------------------------------------------------

PartyCharCursorProp:
        cursor_prop {0, 0}, {8, 2}, NO_XY_WRAP

PartyCharCursorPos:
        .repeat 2, yy
        .repeat 8, xx
        cursor_pos {8 + xx * 28, 100 + yy * 28}
        .endrep
        .endrep

; ------------------------------------------------------------------------------

OnePartyCursorProp:
        cursor_prop {0, 0}, {2, 2}, NO_XY_WRAP

OnePartyCursorPos:
        .repeat 2, yy
        .repeat 2, xx
        cursor_pos {8 + xx * 32, 164 + yy * 28}
        .endrep
        .endrep

; ------------------------------------------------------------------------------

TwoPartyCursorProp:
        cursor_prop {0, 0}, {4, 2}, NO_XY_WRAP

TwoPartyCursorPos:
        .repeat 2, yy
        .repeat 2, pp
        .repeat 2, xx
        cursor_pos {8 + xx * 32 + pp * 80, 164 + yy * 28}
        .endrep
        .endrep
        .endrep

; ------------------------------------------------------------------------------

ThreePartyCursorProp:
        cursor_prop {0, 0}, {6, 2}, NO_XY_WRAP

ThreePartyCursorPos:
        .repeat 2, yy
        .repeat 3, pp
        .repeat 2, xx
        cursor_pos {8 + xx * 32 + pp * 80, 164 + yy * 28}
        .endrep
        .endrep
        .endrep

; ------------------------------------------------------------------------------

; [ draw menu for party character select ]

DrawPartyMenu:
@7522:  ldy     #near PartyTopWindow
        jsr     DrawWindow
        ldy     #near PartyBtmWindow
        jsr     DrawWindow
        ldy     #near PartyMidWindow
        jsr     DrawWindow
        ldy     #near PartyMsgWindow
        jsr     DrawWindow
        ldy     #near PartyTitleWindow
        jsr     DrawWindow
        jsr     DrawPartyWindows
        jsr     TfrBG2ScreenAB
        jsr     _c3755f
        jsr     TfrBG3ScreenAB
        jsr     ClearBG1ScreenA
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldy     #near PartyTitleText
        jsr     DrawPosKana
        jsr     DrawPartyMsg
        jmp     TfrBG1ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c3755f:
@755f:  jmp     ClearBG3ScreenA

; ------------------------------------------------------------------------------

; [  ]

DrawPartyMsg:
@7562:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldy     #near PartyMsgText
        jsr     DrawPosKana
.if LANG_EN
        ldx_pos BG1A, {15, 3}
.else
        ldx_pos BG1A, {16, 3}
.endif
        jmp     DrawNumParties

; ------------------------------------------------------------------------------

; [ draw party windows ]

DrawPartyWindows:
@7572:  clr_a
        lda     w0201                   ; number of parties
        and     #$7f
        asl
        tax
        jmp     (near DrawPartyWindowsTbl,x)

DrawPartyWindowsTbl:
@757d:  .addr   0
        .addr   DrawOnePartyWindows
        .addr   DrawTwoPartyWindows
        .addr   DrawThreePartyWindows

; ------------------------------------------------------------------------------

; [ draw one, two, and three party windows ]

DrawThreePartyWindows:
@7585:  ldy     #near Party3Window
        jsr     DrawWindow

DrawTwoPartyWindows:
@758b:  ldy     #near Party2Window
        jsr     DrawWindow

DrawOnePartyWindows:
@7591:  ldy     #near Party1Window
        jsr     DrawWindow
        rts

; ------------------------------------------------------------------------------

; window data for party select menu
PartyTitleWindow:                       make_window BG2A, {1, 1}, {6, 2}
PartyBtmWindow:                         make_window BG2A, {1, 18}, {28, 7}
PartyTopWindow:                         make_window BG2A, {1, 5}, {28, 5}
PartyMidWindow:                         make_window BG2A, {1, 11}, {28, 6}
PartyMsgWindow:                         make_window BG2A, {9, 1}, {20, 2}
Party1Window:                           make_window BG2A, {1, 19}, {8, 6}
Party2Window:                           make_window BG2A, {11, 19}, {8, 6}
Party3Window:                           make_window BG2A, {21, 19}, {8, 6}

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
        sta     hDMA5::CTRL
        lda     #<hBG1VOFS
        sta     hDMA5::HREG
        ldy     #near _c375e4
        sty     hDMA5::ADDR
        lda     #^_c375e4
        sta     hDMA5::ADDR_B
        lda     #^_c375e4
        sta     hDMA5::HDMA_B
        lda     #BIT_5
        tsb     zEnableHDMA
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
        lda     w0201                   ; number of parties
        and     #$07
        clc
        adc     #ZERO_CHAR
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
        ldx     z0
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
        ldx     z0
@762e:  sta     $7e9d89,x
        inx
        cpx     #$00a0
        bne     @762e
        ldx     #$9d89
        stx     hWMADDL
        lda     w0201       ; number of parties
        bmi     @7665       ; branch if clearing parties
@7643:  ldx     z0
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
@7665:  ldx     z0
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
@7683:  ldx     z0
@7685:  clr_a
        lda     $7e9d89,x
        bmi     @76bf
        phx
        pha
        lda     #$00
        pha
        plb
        lda     #2
        ldy     #near _c37a5f
        jsr     CreateTask
        txy
        clr_a
        pla
        sta     $7e35c9,x
        jsr     _c378eb
        plx
        lda     f:_c376ca,x
        sta     near wTaskPosX,y
        lda     f:_c376da,x
        sta     near wTaskPosY,y
        clr_a
        sta     near {wTaskPosX + 1},y
        sta     near {wTaskPosY + 1},y
        lda     #^PartyCharAnimTbl
        sta     near wTaskAnimBank,y
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
        lda     w0201
        and     #$07
        sta     $e6
        lda     #$01
        sta     $e0
@76fa:  ldx     $e7
        stx     hWMADDL
        ldx     z0
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
@7738:  lda     w0201
        and     #$07
        sta     $e6
        ldx     z0
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
        lda     w0201
        and     #$7f
        cmp     #$01
        beq     @77d6
        cmp     #$02
        beq     @77c3
        jsr     @77c3
        ldx     z0
@7779:  lda     $7e9de1,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @7779
        ldx     z0
@7788:  lda     $7e9df1,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @7788
        ldx     z0
@7797:  lda     $7e9e01,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @7797
        ldx     z0
@77a6:  lda     $7e9e11,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @77a6
        ldx     z0
@77b5:  lda     $7e9e21,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @77b5
        rts

@77c3:  jsr     @77d6
        ldx     z0
@77c8:  lda     $7e9dd1,x
        sta     hWMDATA
        inx
        cpx     #4
        bne     @77c8
        rts

@77d6:  ldx     z0
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
        lda     w0201
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
@7853:  lda     w0201
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
@787f:  ldx     z0
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
        ldy     #near CharIconTask
        jsr     CreateTask
        txy
        clr_a
        pla
        sta     $7e35c9,x
        jsr     _c378eb
        plx
        clr_a
        lda     f:_c378e3,x
        longa_clc
        adc     $e4
        sta     near wTaskPosX,y
        shorta
        lda     f:_c378e7,x
        sta     near wTaskPosY,y
        clr_a
        sta     near {wTaskPosY + 1},y
        lda     #^PartyCharAnimTbl
        sta     near wTaskAnimBank,y
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
; fallthrough

; ------------------------------------------------------------------------------

; [ draw character sprite ]

; A: character index

_c378fa:
@78fa:  asl
        tax
        lda     #$7e
        pha
        plb
        longa
        lda     f:PartyCharAnimTbl,x
        sta     near wTaskAnimPtr,y
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
        lda     f:ForcedCharMaskTbl,x
        sta     $e7
        lda     w0202
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
@793f:  stz     zSelIndex
        jsr     _c37ae5
        lda     #$2f
        sta     wTaskPosY,x
        jsr     TfrVRAM2
        jsr     _c37c2f
        jmp     _c37cae

; ------------------------------------------------------------------------------

; [  ]

_c37953:
@7953:  jsr     _c379ac
        clr_a
        lda     z4b
        clc
        adc     z4a
        adc     z5a
        tax
        lda     $7e9d89,x
        bmi     @79ab
        sta     zc9
        asl
        tax
        longa
        lda     f:CharPropPtrs,x
        sta     zSelCharPropPtr
        shorta
        lda     #BG1_TEXT_COLOR::TEAL
        sta     zTextColor
        ldx     #near PartyCharTextList
        ldy     #sizeof_PartyCharTextList
        jsr     DrawPosList
.if LANG_EN
        ldy_pos BG1A, {9, 8}
.else
        ldy_pos BG1A, {9, 7}
.endif
        ldx     #$3048
        lda     #$01
        sta     z48
        jsr     DrawStatusIcons
.if LANG_EN
        ldy_pos BG1A, {9, 10}
        jsr     DrawCharName
        ldy_pos BG1A, {9, 12}
.else
        ldy_pos BG1A, {9, 9}
        jsr     DrawCharName
        ldy_pos BG1A, {9, 11}
.endif
        jsr     DrawEquipGenju
        ldy     #near PartyHPSlashText
        jsr     DrawPosText
        ldy     #near PartyMPSlashText
        jsr     DrawPosText
        ldx     #near _c379e6
        jsr     DrawCharBlock
@79ab:  rts

; ------------------------------------------------------------------------------

; [  ]

_c379ac:
@79ac:  ldx     #$01c0
        longa
        clr_a
        lda     z0
        ldy     #$0060
@79b7:  sta     wBG1Tiles::ScreenA,x
        inx2
        sta     wBG1Tiles::ScreenA,x
        inx2
        dey
        bne     @79b7
        shorta
        rts

; ------------------------------------------------------------------------------

PartyCharTextList:
        .addr   PartyLevelText
        .addr   PartyHPText
        .addr   PartyMPText
        calc_size PartyCharTextList

PartyLevelText:                         pos_text PARTY_LEVEL
PartyHPText:                            pos_text PARTY_HP
PartyMPText:                            pos_text PARTY_MP
PartyHPSlashText:                       pos_text PARTY_HP_SLASH
PartyMPSlashText:                       pos_text PARTY_MP_SLASH

; ram addresses for lv/hp/mp text (party select)
_c379e6:
        make_pos BG1A, {23, 8}
        make_pos BG1A, {21, 10}
        make_pos BG1A, {26, 10}
        make_pos BG1A, {21, 12}
        make_pos BG1A, {26, 12}

; ------------------------------------------------------------------------------

; [ menu state $67: fade out (party select) ]

MenuState_67:
@79f0:  jsr     CreateFadeOutTask
        ldy     #8
        sty     zWaitCounter
        lda     #$68
        sta     zMenuState
        jmp     _c375b8

; ------------------------------------------------------------------------------

; [ menu state $66: fade in (party select) ]

MenuState_66:
@79ff:  jsr     CreateFadeInTask
        ldy     #8
        sty     zWaitCounter
        lda     #$68
        sta     zMenuState
        jmp     _c375b8

; ------------------------------------------------------------------------------

; [ menu state $68: wait for fade in/out (party select) ]

MenuState_68:
@7a0e:  ldy     zWaitCounter
        bne     @7a16
        lda     zNextMenuState
        sta     zMenuState
@7a16:  jmp     _c375b8

; ------------------------------------------------------------------------------

; [ flashing left cursor thread (item details) ]

ItemDetailsArrowTask:
@7a19:  tax
        jmp     (near ItemDetailsArrowTaskTbl,x)

ItemDetailsArrowTaskTbl:
@7a1d:  .addr   ItemDetailsArrowTask_00
        .addr   ItemDetailsArrowTask_01

; ------------------------------------------------------------------------------

; state 0: init

ItemDetailsArrowTask_00:
@7a21:  ldx     zTaskOffset
        longa
        lda     #near ItemDetailArrowAnimShown
        sta     near wTaskAnimPtr,x
        lda     #8
        sta     near wTaskPosX,x
        shorta
        lda     #^ItemDetailArrowAnimShown
        sta     near wTaskAnimBank,x
        inc     near wTaskState,x
        jsr     InitAnimTask
; fall through

; ------------------------------------------------------------------------------

; state 1: normal

ItemDetailsArrowTask_01:
@7a3e:  ldy     zTaskOffset
        lda     z99
        beq     @7a4b
        bmi     @7a5d
        clr_a
        lda     #2
        bra     @7a4c
@7a4b:  clr_a
@7a4c:  tax
        longa
        lda     f:ItemDetailArrowAnimPtrs,x
        sta     near wTaskAnimPtr,y
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
        jmp     (near _c37a63,x)

_c37a63:
@7a63:  .addr   _c37a67
        .addr   _c37a78

; ------------------------------------------------------------------------------

; [  ]

_c37a67:
@7a67:  lda     #$01
        tsb     z47
        ldx     zTaskOffset
        inc     near wTaskState,x
        lda     #1
        jsr     InitAnimTask
        jsr     _c37bae

_c37a78:
@7a78:  lda     z47
        and     #$01
        beq     @7a85
        ldx     zTaskOffset
        jsr     UpdateAnimTask
        sec
        rts
@7a85:  clc
        rts

; ------------------------------------------------------------------------------

; [ menu state $69: clear party select message ]

MenuState_69:
@7a87:  lda     zWaitCounter
        bne     @7a92
        lda     #$2d
        sta     zMenuState
        jsr     DrawPartyMsg
@7a92:  jmp     _c375b8

; ------------------------------------------------------------------------------

PartyMsgText:           pos_text PARTY_MSG
PartyTitleText:         pos_text PARTY_TITLE
PartyErrorMsg1Text:     pos_text PARTY_ERROR_MSG1
PartyErrorMsg2Text:     pos_text PARTY_ERROR_MSG2

; ------------------------------------------------------------------------------
