
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
        jsr     InitDMA1BG1ScreenA
        lda     #$2d
        sta     $27
        lda     #$66
        sta     $26
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $7d: return to party select (from status) ]

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

; [ menu state $2d: party select (select 1st slot) ]

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

; [ menu state $2e: party select (select 2nd slot) ]

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
        jne     UpdateThreePartyCursor
        jmp     UpdateTwoPartyCursor
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
        longa_clc
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

; [ menu state $67: fade out (party select) ]

MenuState_67:
@79f0:  jsr     CreateFadeOutTask
        ldy     #$0008
        sty     $20
        lda     #$68
        sta     $26
        jmp     _c375b8

; ------------------------------------------------------------------------------

; [ menu state $66: fade in (party select) ]

MenuState_66:
@79ff:  jsr     CreateFadeInTask
        ldy     #$0008
        sty     $20
        lda     #$68
        sta     $26
        jmp     _c375b8

; ------------------------------------------------------------------------------

; [ menu state $68: wait for fade in/out (party select) ]

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

; [ menu state $69: clear party select message ]

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
