
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

; [  ]

_c3a5f6:
@a5f6:  jsr     _c3a600
        lda     #$01
        trb     $45
        jmp     TfrVRAM2

; ------------------------------------------------------------------------------

; [  ]

_c3a600:
@a600:  sty     $1b
        ldy     #$a271
        sty     $1d
        ldy     #$0120
        sty     $19
        lda     #$7e
        sta     $1f
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a611:
@a611:  ldx     #$7849
        stx     $eb
        lda     #$7e
        sta     $ed
        ldy     #$0598
        sty     $e7
        ldy     #$0580
        ldx     #$2410
        stx     $e0
        jsr     _c3a783
        ldy     #$05d8
        sty     $e7
        ldy     #$05c0
        ldx     #$2411
        stx     $e0
        jsr     _c3a783
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a63b:
@a63b:  jsr     _c3a5de
        stz     $8d
        stz     $ed
        stz     $ee
        lda     #$06
        sta     $f1
        ldx     $00
@a64a:  lda     $7e9e89,x
        jsr     GetLetter
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

; [  ]

_c3a662:
@a662:  ldx     #$8049
        stx     $eb
        lda     #$7e
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

; ------------------------------------------------------------------------------

; [  ]

_c3a6ab:
@a6ab:  ldx     #$7849
        stx     $eb
        lda     #$7e
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
@a6f4:  ldx     #$7849
        stx     $eb
        lda     #$7e
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
@a73d:  ldx     #$7849
        stx     $eb
        lda     #$7e
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

ClearBigTextBuf:
@a796:  phb
        lda     #$7e
        pha
        plb
        clr_ax
        longa
@a79f:  stz     $a271,x     ; clear $7ea271-$7ea970
        stz     $a273,x
        stz     $a275,x
        stz     $a277,x
        stz     $a279,x
        stz     $a27b,x
        stz     $a27d,x
        stz     $a27f,x
        stz     $a281,x
        stz     $a283,x
        stz     $a285,x
        stz     $a287,x
        stz     $a289,x
        stz     $a28b,x
        stz     $a28d,x
        stz     $a28f,x
        stz     $a291,x
        stz     $a293,x
        stz     $a295,x
        stz     $a297,x
        stz     $a299,x
        stz     $a29b,x
        stz     $a29d,x
        stz     $a29f,x
        stz     $a2a1,x
        stz     $a2a3,x
        stz     $a2a5,x
        stz     $a2a7,x
        stz     $a2a9,x
        stz     $a2ab,x
        stz     $a2ad,x
        stz     $a2af,x
        txa
        clc
        adc     #$0040
        tax
        cpx     #$0700
        bne     @a79f
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [ description text task ]

; +$33ca = current text string position (+$7e9ec9)
; +$344a = pointer to text graphics buffer (+$7ea271)

BigTextTask:
@a80e:  tax
        jmp     (.loword(BigTextTaskTbl),x)

; task jump table
BigTextTaskTbl:
@a812:  .addr   BigTextTask_00
        .addr   BigTextTask_01
        .addr   BigTextTask_02

; ------------------------------------------------------------------------------

; [ task state $00: init/reset ]

BigTextTask_00:
@a818:  jsr     ClearBigTextBuf
; fall through

; ------------------------------------------------------------------------------

; [ task state $02: wait ]

BigTextTask_02:
@a81b:  stz     $8d                     ;
        ldx     $2d                     ; task data pointer
        lda     #$01
        sta     $3649,x                 ; set task state to 1
        clr_a
        longa
        sta     $33ca,x                 ;
        sta     $344a,x                 ;
        shorta
; fall through

; ------------------------------------------------------------------------------

; [ task state $01: write letters (one per frame) ]

BigTextTask_01:
@a82f:  lda     $26                     ; menu state
        cmp     #$17
        beq     @a88d                   ; branch if (item, sort, rare)
        lda     $46
        and     #$c0                    ; branch if page can't scroll up or down
        beq     @a841
        lda     $06                     ; branch if top l or r buttons is down
        and     #$30
        bne     @a895
@a841:  lda     $45                     ;
        bit     #$20
        bne     @a84d
        lda     $07                     ; branch if a direction button is down
        and     #$0f
        bne     @a895
@a84d:  lda     $45                     ;
        bit     #$10
        bne     @a895
        ldy     $2d                     ; task data pointer
        ldx     $344a,y                 ; +$ed = pointer to text graphics buffer
        stx     $ed
        ldx     $33ca,y                 ; pointer to text buffer
        lda     $7e9ec9,x               ; get next letter
        beq     @a89c                   ; branch if end of string
        cmp     #$01
        bne     @a875                   ; branch if not new line
        stz     $8d
        longa
        lda     #$0380                  ; set graphics buffer pointer to beginning of second line
        sta     $344a,y
        shorta
        bra     @a87d

; write letter
@a875:  jsr     GetLetter
        phx
        jsr     CopyLetterGfx
        plx
@a87d:  inx                 ; increment text string position
        ldy     $2d
        longa
        txa
        sta     $33ca,y
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
@a895:  ldx     $2d
        stz     $3649,x     ; set task state to 0
        sec
        rts

; end of string
@a89c:  lda     #$01        ; enable color palette dma at vblank
        tsb     $45
        ldx     $2d         ; set task state to 2
        lda     #$02
        sta     $3649,x
        sec
        rts

; ------------------------------------------------------------------------------

; [ get text letter ]

GetLetter:
@a8a9:  sec
        sbc     #$80
        stz     $eb
        stz     $ec
        rts

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
        jsr     _c3a94f
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
        clc
        adc     #$20
        tax
        lda     $8d
        clc
        adc     f:FontWidth,x
        sta     $8d
        rts

; ------------------------------------------------------------------------------

; [ shift big text graphics ]

ShiftBigTextGfx:
_c3a94f:
@a94f:  shorta
        clr_a
        lda     $8d
        and     #$07
        asl
        tax
        longa
        jmp     (.loword(ShiftBigTextGfxTbl),x)

ShiftBigTextGfxTbl:
@a95d:  .addr   ShiftBigTextGfx_00
        .addr   ShiftBigTextGfx_01
        .addr   ShiftBigTextGfx_02
        .addr   ShiftBigTextGfx_03
        .addr   ShiftBigTextGfx_04
        .addr   ShiftBigTextGfx_05
        .addr   ShiftBigTextGfx_06
        .addr   ShiftBigTextGfx_07
        .addr   ShiftBigTextGfx_08

; ------------------------------------------------------------------------------

; [  ]

; shift left 4 pixels
ShiftBigTextGfx_00:
@a96f:  asl     $e7
        rol     $e9

; shift left 3 pixels
ShiftBigTextGfx_01:
@a973:  asl     $e7
        rol     $e9

; shift left 2 pixels
ShiftBigTextGfx_02:
@a977:  asl     $e7
        rol     $e9

; shift left 1 pixels
ShiftBigTextGfx_03:
@a97b:  asl     $e7
        rol     $e9

; no shift
ShiftBigTextGfx_04:
@a97f:  rts

; shift right 4 pixels (unused)
ShiftBigTextGfx_08:
@a980:  lsr     $e9
        ror     $e7

; shift right 3 pixels
ShiftBigTextGfx_07:
@a984:  lsr     $e9
        ror     $e7

; shift right 2 pixels
ShiftBigTextGfx_06:
@a988:  lsr     $e9
        ror     $e7

; shift right 1 pixels
ShiftBigTextGfx_05:
@a98c:  lsr     $e9
        ror     $e7
        rts

.a8

; ------------------------------------------------------------------------------

; [ copy description text graphics to vram ]

TfrBigTextGfx:
@a991:  ldy     #$6800
        sty     $1b
        ldy     #$a271
        sty     $1d
        ldy     #$0700
        sty     $19
        lda     #$7e
        sta     $1f
        lda     #$01
        trb     $45
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a9a9:
@a9a9:  ldx     $00
@a9ab:  lda     f:ElementSymbols,x
        sta     $7e9ec9,x
        inx
        cpx     #9
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
