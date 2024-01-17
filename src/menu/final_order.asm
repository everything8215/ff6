
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: final_order.asm                                                      |
; |                                                                            |
; | description: character order menu for final battle                         |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.segment "menu_code"

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
        jsr     InitDMA1BG1ScreenA
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $74: final battle order ]

MenuState_74:
@aa25:  jsr     DrawFinalOrderListLeft
        jsr     DrawFinalOrderListRight
        jsr     UpdateFinalOrderCursor
        jsr     InitDMA1BG1ScreenA

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
