
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: name_change.asm                                                      |
; |                                                                            |
; | description: name change menu                                              |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

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
@656c:  jsr     InitDMA1BG1ScreenAB
        jsr     UpdateNameChangeCursor
        jsr     DrawNameChangeName
        lda     $09
        bit     #$10
        jne     @65c2                   ; jump if start button is pressed

; A button
        lda     $08
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
