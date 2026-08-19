
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

        array_label MENU_STATE, MENU_STATE::FINAL_ORDER_INIT
@a9f8:  jsr     DisableInterrupts
        jsr     ClearBGScroll
        lda     #$02
        sta     z46
        jsr     LoadFinalOrderCursor
        jsr     InitFinalOrderCursor
        jsr     CreateCursorTask
        jsr     InitFinalOrderList
        jsr     ResetFinalOrderList
        jsr     DrawFinalOrderMenu
        jsr     InitPartyEquipScrollHDMA
        lda     #MENU_STATE::FINAL_ORDER_SELECT
        sta     zNextMenuState
        lda     #MENU_STATE::FADE_IN
        sta     zMenuState
        jsr     InitDMA1BG1ScreenA
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $74: final battle order ]

        array_label MENU_STATE, MENU_STATE::FINAL_ORDER_SELECT
@aa25:  jsr     DrawFinalOrderListLeft
        jsr     DrawFinalOrderListRight
        jsr     UpdateFinalOrderCursor
        jsr     InitDMA1BG1ScreenA

; B button
        lda     zNewCtrlState_H
        bit     #>JOY_B
        beq     @aa63
        jsr     PlayCancelSfx
        lda     z4a
        beq     @aaa6
        dec     z4a
        clr_a
        lda     z4a
        tax
        lda     $0205,x
        pha
        lda     #$ff
        sta     $0205,x
        ldx     zZero
        pla
@aa50:  cmp     $7e9d8a,x
        beq     @aa5c
        inx
        cpx     #12
        bne     @aa50
@aa5c:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     $7eaa8d,x
        rts

; check start button
@aa63:  lda     zNewCtrlState_H
        bit     #>JOY_START
        bne     @aa99

; A button
        lda     zNewCtrlState_L
        bit     #JOY_A
        beq     @aaa6
        jsr     PlaySelectSfx
        clr_a
        lda     z4b
        beq     @aaa7
        cmp     #13
        beq     @aa99
        tax
        lda     $7e9d89,x
        bmi     @aaa6
        clr_a
        lda     z4b
        dec
        tax
        lda     $7eaa8d,x
        cmp     #BG1_TEXT_COLOR::DEFAULT
        bne     @aaa6                   ; do nothing if not white text
        jsr     SelectFinalOrderChar
        lda     z4a
        cmp     #12
        beq     @aaad
        rts

; start button, or selected "end"
@aa99:  jsr     PlaySelectSfx
        jsr     FillFinalOrder
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState
        rts
@aaa6:  rts

; selected "reset"
@aaa7:  jsr     ResetFinalOrderList
        inc     z4e
        rts

; list full, move cursor to "end"
@aaad:  lda     #13
        sta     z4e
        rts

; ------------------------------------------------------------------------------

; [ select character for final battle order ]

SelectFinalOrderChar:
@aab2:  clr_a
        lda     z4a
        tay
        lda     z4b
        tax
        lda     #BG1_TEXT_COLOR::GRAY
        sta     $7eaa8c,x
        lda     $7e9d89,x
        tyx
        sta     $0205,x
        inc     z4a
        rts

; ------------------------------------------------------------------------------

; [ automatically fill final battle order with remaining characters ]

FillFinalOrder:
@aaca:  lda     z4a
        cmp     #12
        beq     @aaed
        clr_ax
@aad2:  lda     $7eaa8d,x
        cmp     #BG1_TEXT_COLOR::DEFAULT
        bne     @aae7
        clr_a
        lda     z4a
        tay
        lda     $7e9d8a,x
        sta     $0205,y
        inc     z4a
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
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     $7eaa8d,x
        inx
        cpx     #12
        bne     @aaff
        stz     z4a
        rts

; ------------------------------------------------------------------------------

; [ draw menu for final battle order ]

DrawFinalOrderMenu:
@ab13:  lda     #$02
        sta     hBG1SC
        ldy     #near FinalOrderWindow
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG3ScreenA
        jsr     TfrBG3ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
        ldx     #near FinalOrderTextList
        ldy     #sizeof_FinalOrderTextList
        jsr     DrawPosKanaList
        jsr     DrawFinalOrderNum
        jsr     MakeFinalOrderCharList
        jsr     DrawFinalOrderListLeft
        jsr     TfrBG1ScreenAB
        jmp     TfrBG1ScreenBC

; ------------------------------------------------------------------------------

FinalOrderWindow:                       window_pos BG2A, {1, 1}, {28, 24}

; ------------------------------------------------------------------------------

; [ make list of available characters for final battle order ]

MakeFinalOrderCharList:
@ab4d:  stz     ze6
        clr_ax
@ab51:  phx
        lda     $1850,x
        and     #$40
        beq     @ab81
        lda     $1850,x
        and     #$07
        beq     @ab81                   ; skip characters not in a party
        stx     ze7
        longa
        txa
        asl
        tax
        lda     f:CharPropPtrs,x        ; pointers to character data
        tay
        shorta
        lda     0,y
        cmp     #CHAR_PROP::BANON
        bcs     @ab81
        clr_a
        lda     ze6
        tax
        lda     ze7
        sta     $7e9d8a,x
        inc     ze6
@ab81:  plx
        inx
        cpx     #$0010
        bne     @ab51
        rts

; ------------------------------------------------------------------------------

; [ draw final battle order list (left side) ]

DrawFinalOrderListLeft:
.if LANG_EN
@ab89:  ldy_pos BG1A, {6, 7}
.else
        ldy_pos BG1A, {6, 6}
.endif
        sty     zf5
        clr_ax
@ab90:  jsr     InitFinalOrderTextBuf
        phx
        clr_a
        lda     $7eaa8d,x
        sta     zTextColor
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
@abb4:  lda     #BG1_TEXT_COLOR::DEFAULT
        sta     zTextColor
.if LANG_EN
@ab89:  ldy_pos BG1A, {20, 7}
.else
        ldy_pos BG1A, {20, 6}
.endif
        sty     zf5
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
        lda     zf5
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
        jmp     DrawCharNameNoInit

; ------------------------------------------------------------------------------

; [ go to next line ]

FinalOrderNextLine:
@abfe:  longa
        lda     zf5
        clc
        adc     #$0080
        sta     zf5
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
        sta     ze6
        ldy_pos BG1A, {3, 7}            ; left side
        sty     zf5
        ldx     #12
        stx     zf1
        jsr     @ac3b
        lda     #1
        sta     ze6
        ldy_pos BG1A, {17, 7}           ; right side
        sty     zf5
        ldx     #12
        stx     zf1
        jmp     @ac3b

; draw numbers on one side
@ac3b:  clr_ax
@ac3d:  phx
        lda     ze6
        jsr     HexToDec3
        ldx     zf5
        jsr     DrawNum2
        inc     ze6
        jsr     FinalOrderNextLine
        plx
        inx
        cpx     zf1
        bne     @ac3d
        rts

; ------------------------------------------------------------------------------

; [  ]

LoadFinalOrderCursor:
@ac54:  ldy     #near FinalOrderCursorProp
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [  ]

UpdateFinalOrderCursor:
@ac5a:  jsr     MoveCursor

InitFinalOrderCursor:
@ac5d:  ldy     #near FinalOrderCursorPos
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

FinalOrderCursorProp:
        cursor_prop {0, 0}, {1, 14}, NO_X_WRAP

FinalOrderCursorPos:
        cursor_pos {16, 32}
        .repeat 12, i
        cursor_pos {32, 44 + i * 12}
        .endrep
        cursor_pos {16, 188}

; ------------------------------------------------------------------------------

; pointers to text for final battle order menu
FinalOrderTextList:
        .addr   FinalOrderEndText
        .addr   FinalOrderResetText
        .addr   FinalOrderMsgText
        calc_size FinalOrderTextList

FinalOrderEndText:              pos_text FINAL_ORDER_END
FinalOrderResetText:            pos_text FINAL_ORDER_RESET
FinalOrderMsgText:              pos_text FINAL_ORDER_MSG

; ------------------------------------------------------------------------------
