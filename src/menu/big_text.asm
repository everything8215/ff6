
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
        ldx     z0
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

_c3ae9a:
@ae9a:  ldx     z0
        lda     #$01
        jsr     _c3af24
        ldy     #$6c00
        jsr     _c3a5f6
        ldx     #$0006
        lda     #$02
        jsr     _c3af24
        ldy     #$6c90
        jsr     _c3a5f6
        ldx     #$000c
        lda     #$04
        jsr     _c3af24
        ldy     #$6d20
        jsr     _c3a5f6
        ldx     #$0012
        lda     #$08
        jsr     _c3af24
        ldy     #$6db0
        jsr     _c3a5f6
        ldx     #$0018
        lda     #$10
        jsr     _c3af24
        ldy     #$6e40
        jsr     _c3a5f6
        ldx     #$001e
        lda     #$20
        jsr     _c3af24
        ldy     #$6ed0
        jsr     _c3a5f6
        ldx     #$0024
        lda     #$40
        jsr     _c3af24
        ldy     #$6f60
        jsr     _c3a5f6
        ldx     #$002a
        lda     #$80
        jsr     _c3af24
        ldy     #$6ff0
        jsr     _c3a5f6
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

.if !LANG_EN

_c3af24:
@af24:  sta     $e0
        phx
        jsr     _c3a5de
        plx
        lda     $1cf7
        and     $e0
        beq     @af4e
        stz     $8d
        stz     $ed
        stz     $ee
        lda     #$06
        sta     $f1
@af3c:  lda     $1cf8,x
        ldy     #$3f40
        sty     $eb
        phx
        jsr     CopyLetterGfx
        plx
        inx
        dec     $f1
        bne     @af3c
@af4e:  lda     #$01
        tsb     $45
        rts

.endif

; ------------------------------------------------------------------------------

; [  ]

_c3a5f6:
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
        sta     zDMA2Src+2
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
        stx     $eb
        lda     #^wBG3Tiles::ScreenA
        sta     $ed
        ldy     #(@X_END+22*32)*2
        sty     $e7
        ldy     #(@X_START+22*32)*2
        ldx     #$2410
        stx     $e0
        jsr     _c3a783
        ldy     #(@X_END+23*32)*2
        sty     $e7
        ldy     #(@X_START+23*32)*2
        ldx     #$2411
        stx     $e0
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
        stz     $8d
        stz     $ed
        stz     $ee
        lda     #$06
        sta     $f1
        ldx     z0
@a64a:  lda     $7e9e89,x
.if LANG_EN
        jsr     GetLetter
.else
        ldy     #$5540
        sty     $eb
.endif
        phx
        jsr     CopyLetterGfx
        plx
        inx
        dec     $f1
        bne     @a64a
        ldy     #$2080
        jsr     _c3a600
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

_c3a662:
@a662:  ldx     #near wBG3Tiles::ScreenB
        stx     $eb
        lda     #^wBG3Tiles::ScreenB
        sta     $ed
        ldy     #$00bc
        sty     $e7
        ldy     #$0084
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$00fc
        sty     $e7
        ldy     #$00c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$013c
        sty     $e7
        ldy     #$0104
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$017c
        sty     $e7
        ldy     #$0144
        ldx     #$3539
        stx     $e0
        jmp     _c3a783

.else

_c3a662:
@afc5:  ldx     #near wBG3Tiles::ScreenB
        stx     $eb
        lda     #^wBG3Tiles::ScreenB
        sta     $ed
        ldy     #$00bc
        sty     $e7
        ldy     #$0094
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$00fc
        sty     $e7
        ldy     #$00d4
        ldx     #$3501
        stx     $e0
        jmp     _c3a783

.endif

; ------------------------------------------------------------------------------

; [  ]

_c3a6ab:
@a6ab:  ldx     #near wBG3Tiles::ScreenA
        stx     $eb
        lda     #^wBG3Tiles::ScreenA
        sta     $ed
        ldy     #$01bc
        sty     $e7
        ldy     #$0184
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$01fc
        sty     $e7
        ldy     #$01c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$023c
        sty     $e7
        ldy     #$0204
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$027c
        sty     $e7
        ldy     #$0244
        ldx     #$3539
        stx     $e0
        jmp     _c3a783

; ------------------------------------------------------------------------------

; [  ]

_c3a6f4:
@a6f4:  ldx     #near wBG3Tiles::ScreenA
        stx     $eb
        lda     #^wBG3Tiles::ScreenA
        sta     $ed
        ldy     #$04bc
        sty     $e7
        ldy     #$0484
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$04fc
        sty     $e7
        ldy     #$04c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$053c
        sty     $e7
        ldy     #$0504
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$057c
        sty     $e7
        ldy     #$0544
        ldx     #$3539
        stx     $e0
        jmp     _c3a783

; ------------------------------------------------------------------------------

; [  ]

_c3a73d:
@a73d:  ldx     #near wBG3Tiles::ScreenA
        stx     $eb
        lda     #^wBG3Tiles::ScreenA
        sta     $ed
        ldy     #$01bc
        sty     $e7
        ldy     #$0184
        ldx     #$3500
        stx     $e0
        jsr     _c3a783
        ldy     #$01fc
        sty     $e7
        ldy     #$01c4
        ldx     #$3501
        stx     $e0
        jsr     _c3a783
        ldy     #$023c
        sty     $e7
        ldy     #$0204
        ldx     #$3538
        stx     $e0
        jsr     _c3a783
        ldy     #$027c
        sty     $e7
        ldy     #$0244
        ldx     #$3539
        stx     $e0
; fall through

; ------------------------------------------------------------------------------

; [  ]

_c3a783:
@a783:  longa
@a785:  lda     $e0
        sta     [$eb],y
        inc     $e0
        inc     $e0
        iny2
        cpy     $e7
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
loop:
.repeat 32, i
        stz     near {$a271 + i * 2},x
.endrep
        txa
        clc
        adc     #$0040
        tax
        cpx     #$0700
        bne     loop
        shorta
        plb
        rts
.endproc  ; ClearBigTextBuf

; ------------------------------------------------------------------------------

; [ description text task ]

; +$33ca = current text string position (+$7e9ec9) wTaskPosX
; +$344a = pointer to text graphics buffer (+$7ea271) wTaskPosY

BigTextTask:
@a80e:  tax
        jmp     (near BigTextTaskTbl,x)

; task jump table
BigTextTaskTbl:
        make_jump_tbl BigTextTask, 3

; ------------------------------------------------------------------------------

; [ task state $00: init/reset ]

make_jump_label BigTextTask, 0
@a818:  jsr     ClearBigTextBuf
; fall through

; ------------------------------------------------------------------------------

; [ task state $02: wait ]

make_jump_label BigTextTask, 2
@a81b:  stz     $8d                     ;
        ldx     zTaskOffset                     ; task data pointer
        lda     #1
        sta     near wTaskState,x                 ; set task state to 1
        clr_a
        longa
        sta     near wTaskPosX,x
        sta     near wTaskPosY,x
        shorta
; fall through

; ------------------------------------------------------------------------------

; [ task state $01: write letters (one per frame) ]

make_jump_label BigTextTask, 1
@a82f:  lda     zMenuState
        cmp     #MENU_STATE::ITEM_OPTIONS
        beq     @a88d                   ; branch if (item, sort, rare)
        lda     z46
        and     #$c0                    ; branch if page can't scroll up or down
        beq     @a841
        lda     z06                     ; branch if top l or r buttons is down
        and     #$30
        bne     @a895
@a841:  lda     z45                     ;
        bit     #$20
        bne     @a84d
        lda     z06+1                     ; branch if a direction button is down
        and     #$0f
        bne     @a895
@a84d:  lda     z45                     ;
        bit     #$10
        bne     @a895
        ldy     zTaskOffset
        ldx     near wTaskPosY,y                 ; +$ed = pointer to text graphics buffer
        stx     $ed
        ldx     near wTaskPosX,y                 ; pointer to text buffer
        lda     $7e9ec9,x               ; get next letter
        beq     @a89c                   ; branch if end of string
        cmp     #$01
        bne     @a875                   ; branch if not new line
        stz     $8d
        longa
        lda     #$0380                  ; set graphics buffer pointer to beginning of second line
        sta     near wTaskPosY,y
        shorta
        bra     @a87d

; write letter
@a875:  jsr     GetLetter
        phx
        jsr     CopyLetterGfx
        plx
@a87d:  inx                 ; increment text string position
        ldy     zTaskOffset
        longa
        txa
        sta     near wTaskPosX,y
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
        stz     near wTaskState,x     ; set task state to 0
        sec
        rts

; end of string
@a89c:  lda     #$01        ; enable color palette dma at vblank
        tsb     z45
        ldx     zTaskOffset
        lda     #2
        sta     near wTaskState,x
        sec
        rts

; ------------------------------------------------------------------------------

; [ get text letter ]

GetLetter:

.if LANG_EN

@a8a9:  sec
        sbc     #$80
        stz     $eb
        stz     $ec
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
        stz     $eb
        stz     $ec
        bra     @b226
@b205:  ldy     #$1340
        sty     $eb
        bra     @b221
@b20c:  ldy     #$2940
        sty     $eb
        bra     @b221
@b213:  ldy     #$3f40
        sty     $eb
        bra     @b221
@b21a:  ldy     #$5540
        sty     $eb
        bra     @b221
@b221:  inx
        lda     $7e9ec9,x
@b226:  rts

.endif

; ------------------------------------------------------------------------------

; [ copy letter graphics to vram buffer ]

CopyLetterGfx:
@a8b1:  pha
        sta     f:hWRMPYA
        lda     #$16
        sta     f:hWRMPYB
        lda     #11
        sta     $e5
        longa
        lda     f:hRDMPYL
        clc
        adc     $eb
        tay
        shorta
        clr_a
        lda     $8d
        and     #$f8
        longa
        asl2
        clc
        adc     $ed
        tax
@a8d9:  phx
        longa
        tyx
        lda     f:LargeFontGfx,x   ; variable width font graphics
        stz     $e7
        stz     $e9
        sta     $e8
        jsr     ShiftBigTextGfx
        plx
        lda     $e7
        shorta
        ora     $7ea2b9,x
        sta     $7ea2b9,x
        longa
        lsr
        shorta
        ora     $7ea2bc,x
        sta     $7ea2bc,x
        longa
        lda     $e8
        shorta
        ora     $7ea299,x
        sta     $7ea299,x
        longa
        lsr
        shorta
        ora     $7ea29c,x
        sta     $7ea29c,x
        longa
        lda     $e8
        shorta
        xba
        ora     $7ea279,x
        sta     $7ea279,x
        lsr
        ora     $7ea27c,x
        sta     $7ea27c,x
        inx2
        iny2
        dec     $e5
        bne     @a8d9
        clr_a
        pla
.if LANG_EN
        clc
        adc     #$20
        tax
        lda     $8d
        clc
        adc     f:FontWidth,x
.else
        lda     $8d
        clc
        adc     $b6
.endif
        sta     $8d
        rts

; ------------------------------------------------------------------------------

; [ shift big text graphics ]

.proc ShiftBigTextGfx
@a94f:  shorta
        clr_a
        lda     $8d
        and     #%111
        asl
        tax
        longa
        jmp     (near ShiftBigTextGfxTbl,x)
.endproc  ; ShiftBigTextGfx

ShiftBigTextGfxTbl:
        make_jump_tbl ShiftBigTextGfx, 9

; shift text left
.repeat 4, i
make_jump_label ShiftBigTextGfx, i
        asl     $e7
        rol     $e9
.endrep

; no shift
make_jump_label ShiftBigTextGfx, 4
        rts

; shift text right
.repeat 4, i
make_jump_label ShiftBigTextGfx, 8 - i
        lsr     $e9
        ror     $e7
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
        sta     zDMA2Src+2
        lda     #$01
        trb     z45
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a9a9:
@a9a9:  ldx     z0
@a9ab:  lda     f:ElementSymbols,x
        sta     $7e9ec9,x
        inx
        cpx     #sizeof_ElementSymbols
        bne     @a9ab
        ldy     #$6c00
        sty     $f1
        clr_ax
@a9c0:  lda     $7e9ec9,x
        beq     @a9e2
        jsr     GetLetter
        phx
        jsr     _c3a9e5
        plx
        inx
        ldy     $f1
        jsr     _c3a5f6
        longa
        lda     $f1
        clc
        adc     #$0020
        sta     $f1
        shorta
        bra     @a9c0
@a9e2:  jmp     DisableDMA2

; ------------------------------------------------------------------------------

; [  ]

_c3a9e5:
@a9e5:  pha
        ldy     #$0040
        sty     $f3
        jsr     _c3b437
        stz     $8d
        stz     $ed
        stz     $ee
        pla
        jmp     CopyLetterGfx

; ------------------------------------------------------------------------------
