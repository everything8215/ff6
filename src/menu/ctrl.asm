
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

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ init controller ]

InitCtrl:
@a424:  lda     #8                      ; set direction button repeat delay (8 frames)
        sta     r0229
        lda     #3                      ; set button repeat rate (3 frames/repeat)
        sta     r022a
        sta     r0226
        lda     #32                     ; set a button repeat delay (32 frames)
        sta     r0225
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
        lda     r0201
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
@a483:  ldy     ze0                     ; push dp variables
        sty     r0213
        ldy     ze7
        sty     r0215
        ldy     ze9
        sty     r0217
        ldy     zeb
        sty     r0219
        stx     zeb
        longa
        lda     zPrevCtrlState
        and     #JOY_MASK
        sta     ze0
        jsr     _c3a541
        lda     zPrevCtrlState
        not_a
        and     zCurrCtrlState
        sta     zNewCtrlState
        ldy     zCurrCtrlState
        sty     zPrevCtrlState
        lda     hSTDCNTRL1L
        ora     hSTDCNTRL2L
        sta     zRawCtrlState
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4bd:
@a4bd:  longa
        lda     zCurrCtrlState
        and     #JOY_MASK
        cmp     ze0
        shorta
        bne     @a4e5
        lda     r0227
        beq     @a4d4
        dec     r0227
        bne     @a4f1
@a4d4:  dec     r0228
        bne     @a4f1
        lda     r022a
        sta     r0228
        ldy     zCurrCtrlState
        sty     zRepCtrlState
        bra     @a4f5
@a4e5:  lda     r0229
        sta     r0227
        lda     r022a
        sta     r0228
@a4f1:  ldy     zNewCtrlState
        sty     zRepCtrlState
@a4f5:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4f6:
@a4f6:  lda     zCurrCtrlState_L
        bit     #JOY_A
        beq     @a517
        lda     r0225
        beq     @a506
        dec     r0225
        bne     @a522
@a506:  dec     r0226
        bne     @a522
        lda     r022a
        sta     r0226
        lda     #JOY_A
        tsb     zRepCtrlState_L
        bra     @a526
@a517:  lda     #$20
        sta     r0225
        lda     r022a
        sta     r0226
@a522:  lda     zNewCtrlState_L
        sta     zRepCtrlState_L
@a526:  rts

; ------------------------------------------------------------------------------

; [ pop dp variables used for joypad ]

joy_sub3:
_c3a527:
@a527:  ldy     r0213
        sty     ze0
        ldy     r0215
        sty     ze7
        ldy     r0217
        sty     ze9
        ldy     r0219
        sty     zeb
        clr_a
        rtl

; ------------------------------------------------------------------------------

_c3a53d:
@a53d:  .byte   $01,$02,$04,$08

; ------------------------------------------------------------------------------

; [  ]

_c3a541:
        .a16
@a541:  lda     zeb
        and     #JOY_DIR_MASK
        sta     zCurrCtrlState
        lda     #JOY_A
        sta     ze7
        lda     #JOY_B
        sta     ze9
        ldy     zZero
        jsr     _c3a581
        lda     #JOY_X
        sta     ze7
        lda     #JOY_Y
        sta     ze9
        iny
        jsr     _c3a581
        lda     #JOY_L
        sta     ze7
        lda     #JOY_R
        sta     ze9
        iny
        jsr     _c3a581
        lda     #JOY_START
        sta     ze7
        lda     #JOY_SELECT
        sta     ze9
        iny
        jmp     _c3a581
        .a8

; ------------------------------------------------------------------------------

; [  ]

_c3a581:
@a581:  lda     zeb
        bit     ze7
        beq     @a59b
        clr_a
        shorta
        lda     r0220,y
        and     #$f0
        longa
        lsr3
        tax
        lda     f:_c3a5b4,x
        tsb     zCurrCtrlState
@a59b:  lda     zeb
        bit     ze9
        beq     @a5b3
        clr_a
        shorta
        lda     r0220,y
        and     #$0f
        longa
        asl
        tax
        lda     f:_c3a5b4,x
        tsb     zCurrCtrlState
@a5b3:  rts
        .a8

; ------------------------------------------------------------------------------

_c3a5b4:
@a5b4:  .word   JOY_START
        .word   JOY_A
        .word   JOY_B
        .word   JOY_X
        .word   JOY_Y
        .word   JOY_L
        .word   JOY_R
        .word   JOY_SELECT

; ------------------------------------------------------------------------------

; [ set custom button mapping ]

SetCustomBtnMap:
@a5c4:  ldy     $1d50
        sty     r0220
        ldy     $1d52
        sty     r0220 + 2
        rts

; ------------------------------------------------------------------------------

; [ set default button mapping ]

SetDefaultBtnMap:
@a5d1:  ldy     #$3412
        sty     r0220
        ldy     #$0656
        sty     r0220 + 2
        rts

; ------------------------------------------------------------------------------
