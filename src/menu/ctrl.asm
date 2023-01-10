
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: ctrl.asm                                                             |
; |                                                                            |
; | description: controller routines                                           |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ init controller ]

InitCtrl:
@a424:  lda     #$08                    ; set direction button repeat delay (8 frames)
        sta     $0229
        lda     #$03                    ; set button repeat rate (3 frames/repeat)
        sta     $022a
        sta     $0226
        lda     #$20                    ; set a button repeat delay (32 frames)
        sta     $0225
        lda     $1d54                   ; branch if no special button configuration
        and     #$40
        beq     @a441
        jsr     SetCustomBtnMap
        rtl
@a441:  jsr     SetDefaultBtnMap
        rtl

; ------------------------------------------------------------------------------

; [ update controller (battle) ]

UpdateCtrlBattle:
@a445:  lda     $1d54
        bpl     @a458
        clr_a
        lda     $0201
        tax
        lda     $1d4f
        and     f:_c3a53d,x
        bne     @a45d
@a458:  ldx     hSTDCNTRL1L
        bra     @a462
@a45d:  ldx     hSTDCNTRL2L
        bra     @a462
@a462:  jsr     _c3a483
        jsr     _c3a4bd
        jsr     _c3a4f6
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [ update controller (menu) ]

UpdateCtrlMenu:
@a46e:  ldx     hSTDCNTRL1L
        jsr     _c3a483
        jsr     _c3a4bd
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [ update controller (field/world) ]

UpdateCtrlField:
@a47a:  ldx     hSTDCNTRL1L
        jsr     _c3a483
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [  ]

joy_getsub:
_c3a483:
@a483:  ldy     $e0                     ; push dp variables
        sty     $0213
        ldy     $e7
        sty     $0215
        ldy     $e9
        sty     $0217
        ldy     $eb
        sty     $0219
        stx     $eb
        longa
        lda     $0c
        and     #$fff0
        sta     $e0
        jsr     _c3a541
        lda     $0c
        eor     #$ffff
        and     $06
        sta     $08
        ldy     $06
        sty     $0c
        lda     hSTDCNTRL1L
        ora     hSTDCNTRL2L
        sta     $04
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4bd:
@a4bd:  longa
        lda     $06
        and     #$fff0
        cmp     $e0
        shorta
        bne     @a4e5
        lda     $0227
        beq     @a4d4
        dec     $0227
        bne     @a4f1
@a4d4:  dec     $0228
        bne     @a4f1
        lda     $022a
        sta     $0228
        ldy     $06
        sty     $0a
        bra     @a4f5
@a4e5:  lda     $0229
        sta     $0227
        lda     $022a
        sta     $0228
@a4f1:  ldy     $08
        sty     $0a
@a4f5:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4f6:
@a4f6:  lda     $06
        bit     #$80
        beq     @a517
        lda     $0225
        beq     @a506
        dec     $0225
        bne     @a522
@a506:  dec     $0226
        bne     @a522
        lda     $022a
        sta     $0226
        lda     #$80
        tsb     $0a
        bra     @a526
@a517:  lda     #$20
        sta     $0225
        lda     $022a
        sta     $0226
@a522:  lda     $08
        sta     $0a
@a526:  rts

; ------------------------------------------------------------------------------

; [ pop dp variables used for joypad ]

joy_sub3:
_c3a527:
@a527:  ldy     $0213
        sty     $e0
        ldy     $0215
        sty     $e7
        ldy     $0217
        sty     $e9
        ldy     $0219
        sty     $eb
        clr_a
        rtl

; ------------------------------------------------------------------------------

_c3a53d:
@a53d:  .byte   $01,$02,$04,$08

; ------------------------------------------------------------------------------

; [  ]

.a16

_c3a541:
@a541:  lda     $eb
        and     #$0f00
        sta     $06
        lda     #$0080
        sta     $e7
        lda     #$8000
        sta     $e9
        ldy     $00
        jsr     _c3a581
        lda     #$0040
        sta     $e7
        lda     #$4000
        sta     $e9
        iny
        jsr     _c3a581
        lda     #$0020
        sta     $e7
        lda     #$0010
        sta     $e9
        iny
        jsr     _c3a581
        lda     #$1000
        sta     $e7
        lda     #$2000
        sta     $e9
        iny
        jmp     _c3a581

.a8

; ------------------------------------------------------------------------------

; [  ]

_c3a581:
@a581:  lda     $eb
        bit     $e7
        beq     @a59b
        clr_a
        shorta
        lda     $0220,y
        and     #$f0
        longa
        lsr3
        tax
        lda     f:_c3a5b4,x
        tsb     $06
@a59b:  lda     $eb
        bit     $e9
        beq     @a5b3
        clr_a
        shorta
        lda     $0220,y
        and     #$0f
        longa
        asl
        tax
        lda     f:_c3a5b4,x
        tsb     $06
@a5b3:  rts

; ------------------------------------------------------------------------------

_c3a5b4:
@a5b4:  .word   $1000,$0080,$8000,$0040,$4000,$0020,$0010,$2000

; ------------------------------------------------------------------------------

; [ set custom button mapping ]

SetCustomBtnMap:
@a5c4:  ldy     $1d50
        sty     $0220
        ldy     $1d52
        sty     $0222
        rts

; ------------------------------------------------------------------------------

; [ set default button mapping ]

SetDefaultBtnMap:
@a5d1:  ldy     #$3412
        sty     $0220
        ldy     #$0656
        sty     $0222
        rts

; ------------------------------------------------------------------------------
