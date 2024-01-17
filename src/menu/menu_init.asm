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
