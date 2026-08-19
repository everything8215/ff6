
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: big_text.asm                                                         |
; |                                                                            |
; | description: variable-width font routines                                  |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import LargeFontGfx, FontWidth

.segment "menu_code"

; ------------------------------------------------------------------------------

.if !LANG_EN

_c3ae09:
@ae09:  ldx     #$8049
        stx     zeb
        lda     #$7e
        sta     zed
        ldx     zZero
@ae14:  longa
        lda     f:_c3ae3a,x
        inx2
        sta     ze7
        lda     f:_c3ae3a,x
        inx2
        tay
        lda     f:_c3ae3a,x
        inx2
        sta     ze0
        shorta
        phx
        jsr     _c3a783
        plx
        cpx     #$0060
        bne     @ae14
        rts

_c3ae3a:
        .word   $039c,$038a,$3580
        .word   $03dc,$03ca,$3581
        .word   $03b8,$03a6,$3592
        .word   $03f8,$03e6,$3593
        .word   $045c,$044a,$35a4
        .word   $049c,$048a,$35a5
        .word   $0478,$0466,$35b6
        .word   $04b8,$04a6,$35b7
        .word   $051c,$050a,$35c8
        .word   $055c,$054a,$35c9
        .word   $0538,$0526,$35da
        .word   $0578,$0566,$35db
        .word   $05dc,$05ca,$35ec
        .word   $061c,$060a,$35ed
        .word   $05f8,$05e6,$35fe
        .word   $0638,$0626,$35ff

; ------------------------------------------------------------------------------

; [ draw bushido names ]

_c3ae9a:
@ae9a:  ldx     zZero
        lda     #$01
        jsr     _c3af24
        ldy     #$6c00
        jsr     TfrBigLetterGfx
        ldx     #$0006
        lda     #$02
        jsr     _c3af24
        ldy     #$6c90
        jsr     TfrBigLetterGfx
        ldx     #$000c
        lda     #$04
        jsr     _c3af24
        ldy     #$6d20
        jsr     TfrBigLetterGfx
        ldx     #$0012
        lda     #$08
        jsr     _c3af24
        ldy     #$6db0
        jsr     TfrBigLetterGfx
        ldx     #$0018
        lda     #$10
        jsr     _c3af24
        ldy     #$6e40
        jsr     TfrBigLetterGfx
        ldx     #$001e
        lda     #$20
        jsr     _c3af24
        ldy     #$6ed0
        jsr     TfrBigLetterGfx
        ldx     #$0024
        lda     #$40
        jsr     _c3af24
        ldy     #$6f60
        jsr     TfrBigLetterGfx
        ldx     #$002a
        lda     #$80
        jsr     _c3af24
        ldy     #$6ff0
        jsr     TfrBigLetterGfx
        jmp     DisableDMA2

.endif

; ------------------------------------------------------------------------------

; [  ]

_c3a5de:
@a5de:  clr_ax
        longa
@a5e2:  sta     $7ea271,x
        inx2
        sta     $7ea271,x
        inx2
        cpx     #$0240
        bne     @a5e2
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load bushido name ]

.if !LANG_EN

_c3af24:
@af24:  sta     ze0
        phx
        jsr     _c3a5de
        plx
        lda     $1cf7
        and     ze0
        beq     @af4e
        stz     z8d
        stz     zed
        stz     zee
        lda     #$06
        sta     zf1
@af3c:  lda     $1cf8,x
        ldy     #$3f40
        sty     zeb
        phx
        jsr     CopyBigLetterGfx
        plx
        inx
        dec     zf1
        bne     @af3c
@af4e:  lda     #$01
        tsb     z45
        rts

.endif

; ------------------------------------------------------------------------------

; [ transfer letter graphics to vram ]

TfrBigLetterGfx:
@a5f6:  jsr     _c3a600
        lda     #$01
        trb     z45
        jmp     TfrVRAM2

; ------------------------------------------------------------------------------

; [  ]

_c3a600:
@a600:  sty     zDMA2Dest
        ldy     #$a271
        sty     zDMA2Src
        ldy     #$0120
        sty     zDMA2Size
        lda     #$7e
        sta     zDMA2Src_B
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a611:

.if LANG_EN
        @X_START = 0
        @X_END = 12
.else
        @X_START = 13
        @X_END = 19
.endif

@a611:  ldx     #near wBG3Tiles::ScreenA
        stx     zeb
        lda     #^wBG3Tiles::ScreenA
        sta     zed
        ldy     #(@X_END+22*32)*2
        sty     ze7
        ldy     #(@X_START+22*32)*2
        ldx     #$2410
        stx     ze0
        jsr     _c3a783
        ldy     #(@X_END+23*32)*2
        sty     ze7
        ldy     #(@X_START+23*32)*2
        ldx     #$2411
        stx     ze0
        jsr     _c3a783
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a63b:
@a63b:  jsr     _c3a5de
.if !LANG_EN
        lda     #8
        sta     zb6
.endif
        stz     z8d
        stz     zed
        stz     zee
        lda     #$06
        sta     zf1
        ldx     zZero
@a64a:  lda     $7e9e89,x
.if LANG_EN
        jsr     GetLetter
.else
        ldy     #$5540
        sty     zeb
.endif
        phx
        jsr     CopyBigLetterGfx
        plx
        inx
        dec     zf1
        bne     @a64a
        ldy     #$2080
        jsr     _c3a600
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

_c3a662:
@a662:  ldx     #near wBG3Tiles::ScreenB
        stx     zeb
        lda     #^wBG3Tiles::ScreenB
        sta     zed
        ldy     #$00bc
        sty     ze7
        ldy     #$0084
        ldx     #$3500
        stx     ze0
        jsr     _c3a783
        ldy     #$00fc
        sty     ze7
        ldy     #$00c4
        ldx     #$3501
        stx     ze0
        jsr     _c3a783
        ldy     #$013c
        sty     ze7
        ldy     #$0104
        ldx     #$3538
        stx     ze0
        jsr     _c3a783
        ldy     #$017c
        sty     ze7
        ldy     #$0144
        ldx     #$3539
        stx     ze0
        jmp     _c3a783

.else

_c3a662:
@afc5:  ldx     #near wBG3Tiles::ScreenB
        stx     zeb
        lda     #^wBG3Tiles::ScreenB
        sta     zed
        ldy     #$00bc
        sty     ze7
        ldy     #$0094
        ldx     #$3500
        stx     ze0
        jsr     _c3a783
        ldy     #$00fc
        sty     ze7
        ldy     #$00d4
        ldx     #$3501
        stx     ze0
        jmp     _c3a783

.endif

; ------------------------------------------------------------------------------

; [  ]

_c3a6ab:
@a6ab:  ldx     #near wBG3Tiles::ScreenA
        stx     zeb
        lda     #^wBG3Tiles::ScreenA
        sta     zed
        ldy     #$01bc
        sty     ze7
        ldy     #$0184
        ldx     #$3500
        stx     ze0
        jsr     _c3a783
        ldy     #$01fc
        sty     ze7
        ldy     #$01c4
        ldx     #$3501
        stx     ze0
        jsr     _c3a783
        ldy     #$023c
        sty     ze7
        ldy     #$0204
        ldx     #$3538
        stx     ze0
        jsr     _c3a783
        ldy     #$027c
        sty     ze7
        ldy     #$0244
        ldx     #$3539
        stx     ze0
        jmp     _c3a783

; ------------------------------------------------------------------------------

; [  ]

_c3a6f4:
@a6f4:  ldx     #near wBG3Tiles::ScreenA
        stx     zeb
        lda     #^wBG3Tiles::ScreenA
        sta     zed
        ldy     #$04bc
        sty     ze7
        ldy     #$0484
        ldx     #$3500
        stx     ze0
        jsr     _c3a783
        ldy     #$04fc
        sty     ze7
        ldy     #$04c4
        ldx     #$3501
        stx     ze0
        jsr     _c3a783
        ldy     #$053c
        sty     ze7
        ldy     #$0504
        ldx     #$3538
        stx     ze0
        jsr     _c3a783
        ldy     #$057c
        sty     ze7
        ldy     #$0544
        ldx     #$3539
        stx     ze0
        jmp     _c3a783

; ------------------------------------------------------------------------------

; [  ]

_c3a73d:
@a73d:  ldx     #near wBG3Tiles::ScreenA
        stx     zeb
        lda     #^wBG3Tiles::ScreenA
        sta     zed
        ldy     #$01bc
        sty     ze7
        ldy     #$0184
        ldx     #$3500
        stx     ze0
        jsr     _c3a783
        ldy     #$01fc
        sty     ze7
        ldy     #$01c4
        ldx     #$3501
        stx     ze0
        jsr     _c3a783
        ldy     #$023c
        sty     ze7
        ldy     #$0204
        ldx     #$3538
        stx     ze0
        jsr     _c3a783
        ldy     #$027c
        sty     ze7
        ldy     #$0244
        ldx     #$3539
        stx     ze0
; fall through

; ------------------------------------------------------------------------------

; [  ]

_c3a783:
@a783:  longa
@a785:  lda     ze0
        sta     [zeb],y
        inc     ze0
        inc     ze0
        iny2
        cpy     ze7
        bne     @a785
        shorta
        rts

; ------------------------------------------------------------------------------

; [ clear description text graphics buffer ]

.proc ClearBigTextBuf
        phb
        lda     #$7e
        pha
        plb
        clr_ax
        longa

; clear $7ea271-$7ea970
Loop:   .repeat 32, i
        stz     near {$a271 + i * 2},x
        .endrep
        txa
        clc
        adc     #$0040
        tax
        cpx     #$0700
        bne     Loop
        shorta
        plb
        rts
.endproc  ; ClearBigTextBuf

; ------------------------------------------------------------------------------

; [ description text task ]

; +$33ca = current text string position (+$7e9ec9) wTaskProp::PosX_H
; +$344a = pointer to text graphics buffer (+$7ea271) wTaskProp::PosY_H

.proc BigTextTask

@a80e:  tax
        jmp     (near BigTextTaskTbl,x)

.endproc ; BigTextTask

.enum BIG_TEXT_TASK
        INIT
        WRITE_TEXT
        WAIT
        COUNT
.endenum

; task jump table
BigTextTaskTbl:
        ptr_tbl BIG_TEXT_TASK

; ------------------------------------------------------------------------------

; [ task state $00: init/reset ]

        array_label BIG_TEXT_TASK, 0
@a818:  jsr     ClearBigTextBuf
; fall through

; ------------------------------------------------------------------------------

; [ task state $02: wait ]

        array_label BIG_TEXT_TASK, 2
@a81b:  stz     z8d                     ;
        ldx     zTaskOffset                     ; task data pointer
        lda     #BIG_TEXT_TASK::WRITE_TEXT
        sta     near wTaskProp::State,x                 ; set task state to 1
        clr_a
        longa
        sta     near wTaskProp::PosX_H,x
        sta     near wTaskProp::PosY_H,x
        shorta
; fall through

; ------------------------------------------------------------------------------

; [ task state $01: write letters (one per frame) ]

        array_label BIG_TEXT_TASK, 1
@a82f:  lda     zMenuState
        cmp     #MENU_STATE::ITEM_OPTIONS
        beq     @a88d                   ; branch if (item, sort, rare)
        lda     z46
        and     #$c0                    ; branch if page can't scroll up or down
        beq     @a841
        lda     zCurrCtrlState_L                     ; branch if top l or r buttons is down
        and     #(JOY_L | JOY_R)
        bne     @a895
@a841:  lda     z45                     ;
        bit     #$20
        bne     @a84d
        lda     zCurrCtrlState_H                     ; branch if a direction button is down
        and     #>JOY_DIR_MASK
        bne     @a895
@a84d:  lda     z45                     ;
        bit     #$10
        bne     @a895
        ldy     zTaskOffset
        ldx     near wTaskProp::PosY_H,y                 ; +$ed = pointer to text graphics buffer
        stx     zed
        ldx     near wTaskProp::PosX_H,y                 ; pointer to text buffer
        lda     $7e9ec9,x               ; get next letter
        beq     @a89c                   ; branch if end of string
        cmp     #$01
        bne     @a875                   ; branch if not new line
        stz     z8d
        longa
        lda     #$0380                  ; set graphics buffer pointer to beginning of second line
        sta     near wTaskProp::PosY_H,y
        shorta
        bra     @a87d

; write letter
@a875:  jsr     GetLetter
        phx
        jsr     CopyBigLetterGfx
        plx
@a87d:  inx                 ; increment text string position
        ldy     zTaskOffset
        longa
        txa
        sta     near wTaskProp::PosX_H,y
        shorta
        jsr     TfrBigTextGfx
        sec
        rts

; item, sort, rare (terminate task)
@a88d:  jsr     ClearBigTextBuf
        jsr     TfrBigTextGfx
        clc                 ; terminate task
        rts

; direction button or l or r button pressed (reset text)
@a895:  ldx     zTaskOffset
        stz     near wTaskProp::State,x     ; set task state to 0
        sec
        rts

; end of string
@a89c:  lda     #$01        ; enable color palette dma at vblank
        tsb     z45
        ldx     zTaskOffset
        lda     #BIG_TEXT_TASK::WAIT
        sta     near wTaskProp::State,x
        sec
        rts

; ------------------------------------------------------------------------------

; [ get text letter ]

GetLetter:

.if LANG_EN

@a8a9:  sec
        sbc     #$80
        stz     zeb
        stz     zec
        rts

.else

@b1ec:  cmp     #$1c
        beq     @b205
        cmp     #$1d
        beq     @b20c
        cmp     #$1e
        beq     @b213
        cmp     #$1f
        beq     @b21a
        sec
        sbc     #$20
        stz     zeb
        stz     zec
        bra     @b226
@b205:  ldy     #$1340
        sty     zeb
        bra     @b221
@b20c:  ldy     #$2940
        sty     zeb
        bra     @b221
@b213:  ldy     #$3f40
        sty     zeb
        bra     @b221
@b21a:  ldy     #$5540
        sty     zeb
        bra     @b221
@b221:  inx
        lda     $7e9ec9,x
@b226:  rts

.endif

; ------------------------------------------------------------------------------

; [ copy letter graphics to vram buffer ]

CopyBigLetterGfx:
@a8b1:  pha
        sta     f:hWRMPYA
        lda     #$16
        sta     f:hWRMPYB
        lda     #11
        sta     ze5
        longa
        lda     f:hRDMPYL
        clc
        adc     zeb
        tay
        shorta
        clr_a
        lda     z8d
        and     #$f8
        longa
        asl2
        clc
        adc     zed
        tax
@a8d9:  phx
        longa
        tyx
        lda     f:LargeFontGfx,x   ; variable width font graphics
        stz     ze7
        stz     ze9
        sta     ze8
        jsr     ShiftBigTextGfx
        plx
        lda     ze7
        shorta
        ora     $7ea2b9,x
        sta     $7ea2b9,x
        longa
        lsr
        shorta
        ora     $7ea2bc,x
        sta     $7ea2bc,x
        longa
        lda     ze8
        shorta
        ora     $7ea299,x
        sta     $7ea299,x
        longa
        lsr
        shorta
        ora     $7ea29c,x
        sta     $7ea29c,x
        longa
        lda     ze8
        shorta
        xba
        ora     $7ea279,x
        sta     $7ea279,x
        lsr
        ora     $7ea27c,x
        sta     $7ea27c,x
        inx2
        iny2
        dec     ze5
        bne     @a8d9
        clr_a
        pla
.if LANG_EN
        clc
        adc     #$20
        tax
        lda     z8d
        clc
        adc     f:FontWidth,x
.else
        lda     z8d
        clc
        adc     zb6
.endif
        sta     z8d
        rts

; ------------------------------------------------------------------------------

; [ shift big text graphics ]

.proc ShiftBigTextGfx

@a94f:  shorta
        clr_a
        lda     z8d
        and     #%111
        asl
        tax
        longa
        jmp     (near ShiftBigTextGfxTbl,x)

.endproc  ; ShiftBigTextGfx

.enum SHIFT_BIG_TEXT_GFX
        COUNT = 9
.endenum

ShiftBigTextGfxTbl:
        ptr_tbl SHIFT_BIG_TEXT_GFX

; shift text left
        .repeat 4, i
        array_label SHIFT_BIG_TEXT_GFX, i
        asl     ze7
        rol     ze9
        .endrep

; no shift
        array_label SHIFT_BIG_TEXT_GFX, 4
        rts

; shift text right
        .repeat 4, i
        array_label SHIFT_BIG_TEXT_GFX, 8 - i
        lsr     ze9
        ror     ze7
        .endrep
        rts
        .a8

; ------------------------------------------------------------------------------

; [ copy description text graphics to vram ]

TfrBigTextGfx:
@a991:  ldy     #$6800
        sty     zDMA2Dest
        ldy     #$a271
        sty     zDMA2Src
        ldy     #$0700
        sty     zDMA2Size
        lda     #$7e
        sta     zDMA2Src_B
        lda     #$01
        trb     z45
        rts

; ------------------------------------------------------------------------------

; [ init element symbol graphics ]

.proc InitElementSymbolGfx
        ldx     zZero
:       lda     f:ElementSymbols,x
        sta     $7e9ec9,x
        inx
        cpx     #sizeof_ElementSymbols
        bne     :-
        ldy     #$6c00
        sty     zf1
        clr_ax
Loop:   lda     $7e9ec9,x
        beq     Done
        jsr     GetLetter
        phx
        jsr     LoadElementSymbolGfx
        plx
        inx
        ldy     zf1
        jsr     TfrBigLetterGfx
        longa
        lda     zf1
        clc
        adc     #$0020
        sta     zf1
        shorta
        bra     Loop

Done:   jmp     DisableDMA2
.endproc

; ------------------------------------------------------------------------------

; [ load graphics for one element symbol ]

.proc LoadElementSymbolGfx
        pha
        ldy     #$0040
        sty     zf3
        jsr     _c3b437
        stz     z8d
        stz     zed
        stz     zee
        pla
        jmp     CopyBigLetterGfx
.endproc

; ------------------------------------------------------------------------------
