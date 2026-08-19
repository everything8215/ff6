.segment "menu_code"

; ------------------------------------------------------------------------------

; [ init ram (menu and ending cutscenes) ]

InitRAM:
@68fa:  jsl     InitMenuRAM
        jsr     ClearBGScroll
        jmp     ClearBigTextBuf

; ------------------------------------------------------------------------------

; [ clear bg scrolling registers ]

ClearBGScroll:
@6904:  ldy     zZero
        sty     zBG1HScroll
        sty     zBG2HScroll
        sty     zBG3HScroll
        sty     zBG1VScroll
        sty     zBG2VScroll
        sty     zBG3VScroll
        sty     zTextScrollRate
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
        and     #%111
        cmp     $1a6d
        bne     @6941
        lda     $1850,x     ; battle order
        pha
        and     #$18
        sta     ze0
        lsr3
        tay
        pla
        sta     zCharRowOrder,y     ; set battle slot
        txa
        sta     zCharID,y
@6941:  inx                 ; next character
        cpx     #16
        bne     @691c
        ldy     zZero
@6949:  clr_a
        lda     zCharID,y
        cmp     #$ff
        beq     @6962     ; branch if there's no character in this slot
        asl
        tax
        longa
        lda     f:CharPropPtrs,x   ; pointer to character data
        pha
        tya
        asl
        tax
        pla
        sta     zCharPropPtr,x       ; set pointer for character slot
        shorta
@6962:  iny
        cpy     #4
        bne     @6949
        rts

; ------------------------------------------------------------------------------

; pointers to character data
CharPropPtrs:
        .repeat 16, i
        .word $1600 + i * 37
        .endrep

; ------------------------------------------------------------------------------

; [  ]

_c36989:
@6989:  clr_axy
@698c:  lda     zCharID,x
        bmi     @69a2
        tay
        lda     zCharRowOrder,x
        and     #%11100111
        sta     ze0
        clr_a
        txa
        asl3
        clc
        adc     ze0
        sta     $1850,y
@69a2:  inx
        cpx     #4
        bne     @698c
        rts

; ------------------------------------------------------------------------------

; [  ]

_c369a9:
@69a9:  longa
        lda     zCharID::_0          ; characters in slots 1-2
        sta     $7eaa89
        lda     zCharID::_2          ; characters in slots 3-4
        sta     $7eaa8b
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw positioned text, latin alphabet with no dakuten (list) ]

; +x: pointer to list (2-byte pointers, +$c30000)
; +y: length of list

DrawPosList:
@69ba:  stx     zf1
        sty     zef
        lda     #^*
        sta     zf3
        ldy     zZero
@69c4:  longa
        lda     [zf1],y
        sta     ze7
        phy
        shorta
        lda     #^*
        sta     ze9
        jsr     DrawPosTextFar
        ply
        iny2
        cpy     zef
        bne     @69c4
        rts

; ------------------------------------------------------------------------------

; [ draw positioned text, kana with dakuten (list) ]

; +x: pointer to list (2-byte pointers, +$c30000)
; +y: length of list

.if LANG_EN

DrawPosKanaList := DrawPosList

.else

.proc DrawPosKanaList
        stx     zf1
        sty     zef
        lda     #^*
        sta     zf3
        ldy     zZero
loop:   longa
        lda     [zf1],y
        sta     ze7
        phy
        shorta
        lda     #^*
        sta     ze9
        jsr     DrawPosKanaFar
        ply
        iny2
        cpy     zef
        bne     loop
        rts
.endproc  ; DrawPosKanaList

.endif

; ------------------------------------------------------------------------------

; [ init window 1 position hdma ]

InitWindow1PosHDMA:
@69dc:  lda     #$01                    ; hdma channel #2 (2 address)
        sta     hDMA2::CTRL
        lda     #<hWH0                  ; destination = $2126, $2127
        sta     hDMA2::HREG
        ldy     #near Window1PosHDMATbl
        sty     hDMA2::ADDR
        lda     #^Window1PosHDMATbl
        sta     hDMA2::ADDR_B
        lda     #^Window1PosHDMATbl
        sta     hDMA2::HDMA_B
        lda     #BIT_2
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; window 1 position hdma table
Window1PosHDMATbl:
        hdma_2byte 7, {$ff, $00}
        hdma_2byte 120, {$08, $f7}
        hdma_2byte 88, {$08, $f7}
        hdma_2byte 8, {$ff, $00}
        hdma_end

; ------------------------------------------------------------------------------

; [ disable window 1 position hdma ]

DisableWindow1PosHDMA:
@6a08:  lda     #BIT_2
        trb     zEnableHDMA
        stz     hWH0        ; window 1 position = [$00,$ff]
        lda     #$ff
        sta     hWH1
        rts

; ------------------------------------------------------------------------------

; [ clear bg tiles ]

ClearBG1ScreenA:
@6a15:  ldx     zZero                      ; clear bg1 data (top left screen)
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
; fallthrough

.proc ClearBGTiles
        longa
        clr_a
        ldy     #$0200
:       .repeat 2
        sta     wBG1Tiles,x
        inx2
        .endrep
        dey
        bne     :-
        shorta
        rts
.endproc  ; ClearBGTiles

; ------------------------------------------------------------------------------
