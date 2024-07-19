
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: opening.asm                                                          |
; |                                                                            |
; | description: opening credits                                               |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ magitek march ]

OpeningMain:
@57f3:  php
        longai
        pha
        phx
        phy
        phb
        phd
        jsr     InitCutscene
        jsr     InitOpening
        jsr     OpeningLoop
        jsr     SoundOff
        jsr     DisableInterrupts
        longai
        pld
        plb
        ply
        plx
        pla
        plp
        rtl

.a8

; ------------------------------------------------------------------------------

; [ magitek march init ]

InitOpening:
@5813:  jsr     InitHWRegs
        jsr     InitOpeningPPU
        lda     #$ff                    ; master volume = max
        sta     f:$001302
        lda     #$10                    ; spc command $10 (play song)
        sta     f:$001300
        lda     #$04                    ; song $04 (opening theme 3)
        sta     f:$001301
        jsl     ExecSound_ext
        jsr     InitRAM
        jsr     ClearVRAM
        jsr     ResetTasks
        jsr     InitOpeningGfx
        rts

; ------------------------------------------------------------------------------

; [ init hardware registers (magitek march) ]

InitOpeningPPU:
@583c:  phb
        lda     #$00
        pha
        plb
        lda     #$03
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$07
        sta     hBGMODE
        lda     #$78
        sta     hBG1SC
        lda     #$7c
        sta     hBG2SC
        lda     #$74
        sta     hBG3SC
        sta     hBG4SC
        lda     #$22
        sta     hBG12NBA
        lda     #$77
        sta     hBG34NBA
        clr_a
        sta     hM7SEL
        plb
        rts

; ------------------------------------------------------------------------------

; [ magitek march main loop ]

OpeningLoop:
@5872:  clr_a
        lda     $19
        bmi     @588f
        asl
        tax
        jsr     (.loword(OpeningStateTbl),x)
        lda     $06
        bit     #$80
        bne     @588a
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @5872
@588a:  lda     #$ff
        sta     $0200
@588f:  ldy     #15
        sty     $15
        lda     #0
        ldy     #.loword(_7e55a0)
        jsr     CreateTask
@589c:  ldy     $15
        beq     @58a8
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @589c
@58a8:  jsl     PopMode7Vars_ext
        rts

; magitek march jump table
OpeningStateTbl:
@58ad:  .addr   OpeningState_00
        .addr   OpeningState_01
        .addr   OpeningState_02
        .addr   OpeningState_03

; ------------------------------------------------------------------------------

; [ magitek march $00: init ]

OpeningState_00:
@58b5:  jsr     InitOpeningMode7Vars
        jsr     InitOpeningHDMA
        phb
        lda     #$00
        pha
        plb
        jsl     PushMode7Vars_ext
        jsl     UpdateMode7Vars_ext
        plb
        jsr     _7e5c45
        jsr     ResetTasks
        ldx     #$3100
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3120
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3160
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3180
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$31a0
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3000
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3020
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3040
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3060
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$30e0
        ldy     #.loword(BlackPal)
        jsr     LoadPal

; set magitek armor x positions
        lda     #$68
        sta     $39
        lda     #$48
        sta     $3a
        lda     #$78
        sta     $3b
        lda     #$c0

; set magitek armor y positions
        sta     $3c
        lda     #$80
        sta     $3d
        lda     #$90
        sta     $3e
        stz     $29
        stz     $2a
        ldy     #$0038
        sty     $2b
        stz     $37
        stz     $38
        lda     #0
        ldy     #.loword(ArmorOffsetTask)
        jsr     CreateTask
        clr_a
        jsr     CreateArmorTask
        lda     #1
        jsr     CreateArmorTask
        lda     #2
        jsr     CreateArmorTask
        ldx     #$3120
        ldy     #.loword(OpeningSnowSpritePal)
        lda     #$01
        jsr     CreateFadePalTask
        ldx     #$3160
        ldy     #.loword(OpeningSnowSpritePal)
        lda     #$02
        jsr     CreateFadePalTask
        ldx     #$3180
        ldy     #.loword(OpeningSnowSpritePal)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$31a0
        ldy     #.loword(OpeningSnowSpritePal)
        lda     #$06
        jsr     CreateFadePalTask
        ldx     #$3100
        ldy     #.loword(OpeningArmorPal)
        lda     #$03
        jsr     CreateFadePalTask
        ldx     #$3020
        ldy     #.loword(OpeningBGPal1)
        lda     #$02
        jsr     CreateFadePalTask
        ldx     #$3040
        ldy     #.loword(OpeningBGPal2)
        lda     #$02
        jsr     CreateFadePalTask
        ldx     #$3060
        ldy     #.loword(OpeningBGPal3)
        lda     #$02
        jsr     CreateFadePalTask
        ldx     #$30e0
        ldy     #.loword(TownPal1)
        lda     #$04
        jsr     CreateFadePalTask
        lda     #0
        ldy     #.loword(OpeningSnowTask)
        jsr     CreateTask
        lda     #0
        ldy     #.loword(_7e5aed)
        jsr     CreateTask
        lda     #0
        ldy     #.loword(ArmorMoveTask)
        jsr     CreateTask
        clr_a
        sta     $3901,x
        lda     #$01
        sta     $3600,x
        lda     #$5a
        sta     $3900,x
        longa
        lda     #$ffa0
        sta     $3800,x
        shorta
        lda     #0
        ldy     #.loword(ArmorMoveTask)
        jsr     CreateTask
        lda     #$01
        sta     $3901,x
        lda     #$0a
        sta     $3600,x
        lda     #$28
        sta     $3900,x
        longa
        lda     #$ff60
        sta     $3800,x
        shorta
        lda     #0
        ldy     #.loword(ArmorMoveTask)
        jsr     CreateTask
        lda     #$02
        sta     $3901,x
        lda     #$07
        sta     $3600,x
        lda     #$2d
        sta     $3900,x
        longa
        lda     #$ff80
        sta     $3800,x
        shorta
        inc     $19
        lda     #$01
        sta     $32
        jsr     WaitVBlank
.if LANG_EN
        ldy     #202
.else
        ldy     #322
.endif
        sty     $15
        lda     #$0f
        sta     $32
        rts

; ------------------------------------------------------------------------------

; [ magitek march $01:  ]

OpeningState_01:
@5a4c:  ldy     $15
        bne     @5a62
        inc     $19
.if LANG_EN
        ldy     #3300
.else
        ldy     #3060
.endif
        sty     $15
        lda     #0
        ldy     #.loword(CreditsTextTask)
        jsr     CreateTask
        jsr     CreateTownLightsThread
@5a62:  jsr     UpdateMode7Pos
        rts

; ------------------------------------------------------------------------------

; [ magitek march $02:  ]

OpeningState_02:
@5a66:  ldy     $15
        bne     @5a6c
        inc     $19
@5a6c:  jsr     UpdateMode7Pos
        rts

; ------------------------------------------------------------------------------

; [ magitek march $03:  ]

OpeningState_03:
@5a70:  lda     #$ff
        sta     $19
        clr_a
        sta     $0200
        rts

; ------------------------------------------------------------------------------

; [ update mode 7 XY registers ]

UpdateMode7Pos:
@5a79:  lda     $3f
        sta     f:hM7X
        lda     $40
        sta     f:hM7X
        lda     $41
        sta     f:hM7Y
        lda     $42
        sta     f:hM7Y
        rts

; ------------------------------------------------------------------------------

; [ task to move magitek armor up ]

ArmorMoveTask:
@5a92:  tax
        jmp     (.loword(ArmorMoveTaskTbl),x)

ArmorMoveTaskTbl:
@5a96:  .addr   ArmorMoveTask_00
        .addr   ArmorMoveTask_01
        .addr   ArmorMoveTask_02

; ------------------------------------------------------------------------------

; [  ]

ArmorMoveTask_00:
@5a9c:  ldx     $1d
        inc     $3a00,x
        clr_a
        lda     $3901,x
        tay
        lda     $003c,y
        sta     $3401,x
        stz     $3400,x

ArmorMoveTask_01:
@5aaf:  ldx     $1d
        lda     $3600,x
        bne     @5ac1
        inc     $3a00,x
        lda     $3900,x
        sta     $3600,x
        sec
        rts
@5ac1:  dec     $3600,x
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

ArmorMoveTask_02:
@5ac6:  ldx     $1d
        lda     $3600,x
        beq     @5aeb
        longa
        lda     $3400,x
        clc
        adc     $3800,x
        sta     $3400,x
        shorta
        clr_a
        lda     $3901,x
        tay
        lda     $3401,x
        sta     $003c,y
        dec     $3600,x
        sec
        rts

; terminate task
@5aeb:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e5aed:
scroll_task_open:
@5aed:  lda     $18
        and     #$03
        bne     @5afb
        longa
        dec     $41
        dec     $27
        shorta
@5afb:  lda     $18
        and     #$3f
        bne     @5b06
        ldy     $2b
        iny
        sty     $2b
@5b06:  sec
        rts

; ------------------------------------------------------------------------------

; [ create magitek armor task ]

; A: magitek armor index

CreateArmorTask:
@5b08:  sta     $f4
        asl3
        sta     $f3
        ldy     $00
@5b11:  phy
        lda     #2
        ldy     #.loword(ArmorTask)
        jsr     CreateTask
        lda     $f4
        sta     $3900,x
        lda     $f3
        sta     $3901,x
        ply
        longa
        lda     ArmorAnimTbl,y          ; animation pointer
        sta     $3500,x
        shorta
        iny2
        lda     ArmorAnimTbl,y          ; x offset
        sta     $3701,x
        iny
        lda     ArmorAnimTbl,y          ; y offset
        sta     $3801,x
        iny                             ; next sprite
        cpy     #$0018
        bne     @5b11
        rts

; ------------------------------------------------------------------------------

; pointer to each animated sprite of magitek armor
ArmorAnimTbl:
@5b45:  .addr   ArmorPelvisAnim
        .byte   $04,$f8
        .addr   ArmorBodyAnim
        .byte   $00,$00
        .addr   ArmorRightLegAnim
        .byte   $fd,$e0
        .addr   ArmorLeftLegAnim
        .byte   $fb,$e0
        .addr   ArmorRightArmAnim
        .byte   $04,$08
        .addr   ArmorLeftArmAnim
        .byte   $04,$08

; ------------------------------------------------------------------------------

; [ init opening credits hdma ]

InitOpeningHDMA:
@5b5d:  phb
        lda     #$00
        pha
        plb
        lda     #$17
        sta     hTM
        lda     #$02
        sta     hTS

; fixed color
        lda     #$e0
        sta     hCOLDATA
        stz     $4320
        lda     #<hCOLDATA
        sta     $4321
        ldy     #.loword(OpeningFixedColorHDMATbl)
        sty     $4322
        lda     #^OpeningFixedColorHDMATbl
        sta     $4324
        sta     $4327

; bg mode
        stz     $4330
        lda     #<hBGMODE
        sta     $4331
        ldy     #.loword(OpeningBGModeHDMATbl)
        sty     $4332
        lda     #^OpeningBGModeHDMATbl
        sta     $4334
        sta     $4337

; color math
        lda     #$01
        sta     $4340
        lda     #<hCGSWSEL
        sta     $4341
        ldy     #.loword(OpeningColorMathHDMATbl)
        sty     $4342
        lda     #^OpeningColorMathHDMATbl
        sta     $4344
        sta     $4347

; bg3 scroll
        sta     $4354
        sta     $4357
        lda     #$02
        sta     $4350
        lda     #<hBG3HOFS
        sta     $4351
        ldy     #.loword(OpeningBG3ScrollHDMATbl)
        sty     $4352

; mode7 A & B
        lda     #$43
        sta     $4360
        lda     #<hM7A
        sta     $4361
        ldy     #.loword(OpeningM7ABHDMATbl)
        sty     $4362
        lda     #^OpeningM7ABHDMATbl
        sta     $4364
        sta     $4367

; mode7 C & D
        lda     #$43
        sta     $4370
        lda     #<hM7C
        sta     $4371
        ldy     #.loword(OpeningM7CDHDMATbl)
        sty     $4372
        lda     #^OpeningM7CDHDMATbl
        sta     $4374
        sta     $4377

; enable hdma channels 2-7
        lda     #$fc
        tsb     $31
        plb
        rts

; ------------------------------------------------------------------------------

; bg3 scroll
OpeningBG3ScrollHDMATbl:
.if LANG_EN
@5c01:  .byte   $27,$00,$00
        .byte   $10,$00,$00
        .byte   $10,$00,$00
        .byte   $10,$00,$00
        .byte   $00
.else
@5bb5:  .byte   $27,$ff,$00
        .byte   $10,$ff,$00
        .byte   $10,$ff,$00
        .byte   $10,$ff,$00
        .byte   $00
.endif

; color math
OpeningColorMathHDMATbl:
@5c0e:  .byte   $54,$82,$04
        .byte   $01,$80,$81
        .byte   $00

; mode 7 A & B
OpeningM7ABHDMATbl:
@5c15:  .byte   $e4,$a0,$3c
        .byte   $fb,$30,$3e
        .byte   $00

; mode 7 C & D
OpeningM7CDHDMATbl:
@5c1c:  .byte   $e4,$20,$40
        .byte   $fb,$b0,$41
        .byte   $00

; fixed color
OpeningFixedColorHDMATbl:
@5c23:  .byte   $54,$e0
        .byte   $01,$ed
        .byte   $01,$eb
        .byte   $01,$ea
        .byte   $02,$e9
        .byte   $03,$e8
        .byte   $04,$e7
        .byte   $05,$e6
        .byte   $06,$e5
        .byte   $07,$e4
        .byte   $08,$e3
        .byte   $0c,$e2
        .byte   $0f,$e1
        .byte   $1e,$e0
        .byte   $00

; bg mode
OpeningBGModeHDMATbl:
@5c40:  .byte   $54,$09
        .byte   $01,$07
        .byte   $00

; ------------------------------------------------------------------------------

; [  ]

_7e5c45:
m7data_marge:
@5c45:  clr_axy
        longa
@5c4a:  lda     $0300,x
        sta     $3d00,y
        lda     $0680,x
        sta     $4080,y
        iny2
        lda     $04c0,x
        sta     $3d00,y
        lda     $0840,x
        sta     $4080,y
        iny2
        inx2
        cpx     #$01c0
        bne     @5c4a
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init mode 7 variables for opening credits ]

InitOpeningMode7Vars:
@5c70:  ldy     #$0100
        sty     $3f
        ldy     #$0080
        sty     $41
        sty     $25
        clr_ay
        sty     $27
        stz     $72
        stz     $73
        stz     $74
        ldy     #$00e0
        sty     $87
        ldy     #$4000
        sty     $8b
        ldy     #$0000
        sty     $8d
        ldy     #$ffff
        sty     $8f
        jsr     _7e5cb1
        ldy     #$7440
        sty     $10
        ldy     #$4400
        sty     $12
        lda     #$7e
        sta     $14
        ldy     #$0280
        sty     $0e
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e5cb1:
@5cb1:  clr_ax
@5cb3:  stz     $4400,x
        inx
        cpx     #$0280
        bne     @5cb3
        rts

; ------------------------------------------------------------------------------

; [ create narshe blinking lights thread ]

CreateTownLightsThread:
@5cbd:  lda     #0
        ldy     #.loword(TownLightsThread)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ narshe blinking lights thread ]

TownLightsThread:
@5cc6:  lda     $18         ; frame counter
        and     #$01
        bne     @5cd7
        ldx     #$30e0
        ldy     #.loword(TownPal1)
        jsr     LoadPal
        bra     @5ce0
@5cd7:  ldx     #$30e0
        ldy     #.loword(TownPal2)
        jsr     LoadPal
@5ce0:  sec
        rts

; ------------------------------------------------------------------------------

; [  ]

CreditsTextTask:
@5ce2:  tax
        jmp     (.loword(CreditsTextTaskTbl),x)

CreditsTextTaskTbl:
@5ce6:  .addr   CreditsTextTask_00
        .addr   CreditsTextTask_01

; ------------------------------------------------------------------------------

; [  ]

CreditsTextTask_00:
@5cea:  ldx     $1d
        inc     $3a00,x
        longa
        lda     #.loword(CreditsTextTbl)
        sta     $3500,x
        shorta
        jsr     InitAnimTask

; ------------------------------------------------------------------------------

; [  ]

CreditsTextTask_01:
@5cfc:  ldx     $1d
        lda     $3b01,x
        cmp     #$01
        bne     @5d10
        ldx     #$3000
        ldy     #.loword(OpeningFontPal)
        lda     #$01
        jsr     CreateFadePalTask
@5d10:  ldx     $1d
        lda     $3b01,x
        cmp     #$20
        bne     @5d24
        ldx     #$3000
        ldy     #.loword(BlackPal)
        lda     #$01
        jsr     CreateFadePalTask
@5d24:  ldx     $1d
        lda     $3b01,x
        cmp     #$fe
        beq     @5d45
        jsr     UpdateAnimData
        shorti
        lda     $3b00,x
        tay
        longa
        lda     ($eb),y
        sta     $e7
        longi
        shorta
        jsr     DrawCreditsText
        sec
        rts
@5d45:  clc
        rts

; ------------------------------------------------------------------------------

; pointers to opening credits text data
CreditsTextTbl:
@5d47:  .addr   CreditsText_00
        .byte   $01
        .addr   CreditsText_01
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_02
        .byte   $01
        .addr   CreditsText_03
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_04
        .byte   $01
        .addr   CreditsText_05
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_06
        .byte   $01
        .addr   CreditsText_07
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_06
        .byte   $01
        .addr   CreditsText_08
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_09
        .byte   $01
        .addr   CreditsText_0a
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_0b
        .byte   $01
        .addr   CreditsText_0c
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_0d
        .byte   $01
        .addr   CreditsText_0e
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_0f
        .byte   $01
        .addr   CreditsText_10
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_0f
        .byte   $01
        .addr   CreditsText_11
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_12
        .byte   $01
        .addr   CreditsText_13
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_14
        .byte   $01
        .addr   CreditsText_15
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_16
        .byte   $01
        .addr   CreditsText_17
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_18
        .byte   $01
        .addr   CreditsText_19
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_1a
        .byte   $01
        .addr   CreditsText_1b
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_1c
        .byte   $01
        .addr   CreditsText_1d
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_1c
        .byte   $01
        .addr   CreditsText_1e
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_1c
        .byte   $01
        .addr   CreditsText_1f
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_20
        .byte   $01
        .addr   CreditsText_21
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_22
        .byte   $01
        .addr   CreditsText_23
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_24
        .byte   $01
        .addr   CreditsText_25
        .byte   $8b
        .addr   CreditsBlankText
        .byte   $01
        .addr   CreditsText_26
        .byte   $01
        .addr   CreditsText_27
        .byte   $8b
        .addr   CreditsBlankText
.if LANG_EN
        .byte   $01
        .addr   CreditsText_28
        .byte   $01
        .addr   CreditsText_29
        .byte   $8b
        .addr   CreditsBlankText
.endif
        .byte   $01
        .addr   CreditsBlankText
        .byte   $fe

; empty lines for opening credits text (clears tile data before loading the next string)
CreditsBlankText:
@5e19:  .word   $4446
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$fe
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$fe
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$fe
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00

; ------------------------------------------------------------------------------

; [ draw opening credits text ]

DrawCreditsText:
@5e8b:  ldx     $00
        txy
        longa
        lda     ($e7)                   ; destination address (2 bytes)
        sta     $eb
        inc     $e7
        inc     $e7
        shorta
        lda     ($e7),y                 ; tile flags
        sta     $43
        iny
        clr_a
        lda     ($e7),y                 ; scroll position
        iny
        jsr     UpdateOpeningBG3ScrollHDMA
@5ea6:  lda     ($e7),y
        beq     @5ec1
        cmp     #$fe
        beq     @5ec2
        cmp     #$ff
        beq     @5ecb
        phy
        txy
        sta     ($eb),y
        inx
        txy
        lda     $43
        sta     ($eb),y
        inx
        ply
        iny
        bra     @5ea6
@5ec1:  rts
@5ec2:  longa_clc
        lda     #$0080
        sta     $e0
        bra     @5ed2
@5ecb:  longa_clc
        lda     #$0040
        sta     $e0
@5ed2:  lda     $eb
        adc     $e0
        sta     $eb
        shorta
        clr_ax
        iny
        bra     @5ea6

; ------------------------------------------------------------------------------

; [ update BG3 scroll HDMA table data for opening credits ]

UpdateOpeningBG3ScrollHDMA:
@5edf:  phx
        phy
        asl2
        tax
        lda     _7e5f07,x
        not_a
        sta     OpeningBG3ScrollHDMATbl+1
        lda     _7e5f07+1,x
        not_a
        sta     OpeningBG3ScrollHDMATbl+4
        lda     _7e5f07+2,x
        not_a
        sta     OpeningBG3ScrollHDMATbl+7
        lda     _7e5f07+3,x
        not_a
        sta     OpeningBG3ScrollHDMATbl+10
        ply
        plx
        rts

; ------------------------------------------------------------------------------

_7e5f07:
@5f07:  .byte   $00,$00,$00,$00
        .byte   $00,$00,$04,$00
        .byte   $04,$00,$00,$00
        .byte   $00,$04,$00,$00
        .byte   $00,$04,$04,$00
        .byte   $04,$04,$00,$00
        .byte   $04,$00,$04,$00
        .byte   $00,$04,$00,$04

; ------------------------------------------------------------------------------

; [ snowflake animation task for opening credits ]

OpeningSnowTask:
@5f27:  lda     $1f
        cmp     #$77
        bcs     @5f6c
        lda     #$40
        trb     $33
        lda     #0
        ldy     #.loword(DefaultAnimTask)
        jsr     CreateTask
        clr_a
        lda     $18
        and     #$07
        asl
        tay
        longa
        lda     OpeningSnowAnimTbl,y
        sta     $3500,x
        shorta
        phx
        jsr     Rand
        plx
        sta     $3301,x
        and     #$0f
        inc
        sta     $3801,x
        phx
        jsr     Rand
        plx
        sta     $3401,x
        sta     $3800,x
        and     #$03
        inc
        sta     $3701,x
        sta     $3700,x
@5f6c:  sec
        rts

; ------------------------------------------------------------------------------

; snowflake animation pointers
OpeningSnowAnimTbl:
@5f6e:  .addr   OpeningSnowAnim1
        .addr   OpeningSnowAnim2
        .addr   OpeningSnowAnim3
        .addr   OpeningSnowAnim4
        .addr   OpeningSnowAnim5
        .addr   OpeningSnowAnim6
        .addr   OpeningSnowAnim7
        .addr   OpeningSnowAnim3

; ------------------------------------------------------------------------------

; [ magitek armor task ]

ArmorTask:
@5f7e:  tax
        jmp     (.loword(ArmorTaskTbl),x)

ArmorTaskTbl:
@5f82:  .addr   ArmorTask_00
        .addr   ArmorTask_01

; ------------------------------------------------------------------------------

; [ magitek armor task 0: init ]

ArmorTask_00:
@5f86:  ldx     $1d
        inc     $3a00,x                 ; increment thread state
        jsr     InitAnimTask
        lda     $3901,x                 ; armor index * 8 (animation delay ???)
        clc
        adc     $3b01,x
        sta     $3b01,x
; fallthrough

; ------------------------------------------------------------------------------

; [ magitek armor task 1: update ]

ArmorTask_01:
@5f98:  ldx     $1d
        clr_a
        lda     $3900,x                 ; armor index
        tay
        lda     $37                     ; global x-offset (always zero)
        clc
        adc     $3701,x
        tyx
        adc     $39,x                   ; armor x-position
        ldx     $1d
        sta     $3301,x                 ; set x-position
        lda     $38                     ; global y-offset
        clc
        adc     $3801,x                 ; y-velocity
        tyx
        adc     $3c,x                   ; armor y-position
        ldx     $1d
        sta     $3401,x                 ; set y-position
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ magitek armor vertical offset thread ]

ArmorOffsetTask:
@5fc0:  tax
        jmp     (.loword(ArmorOffsetTaskTbl),x)

ArmorOffsetTaskTbl:
@5fc4:  .addr   ArmorOffsetTask_00
        .addr   ArmorOffsetTask_01

; ------------------------------------------------------------------------------

; [ magitek armor vertical offset state 0: init ]

ArmorOffsetTask_00:
@5fc8:  ldx     $1d
        inc     $3a00,x                 ; increment thread state
        longa
        lda     #.loword(ArmorOffsetTbl)
        sta     $3500,x                 ; pointer to data below
        shorta
        lda     #$08
        sta     $3b01,x
        stz     $3b00,x
; fallthrough

; ------------------------------------------------------------------------------

; [ magitek armor vertical offset state 0: update ]

ArmorOffsetTask_01:
@5fdf:  ldx     $1d
        jsr     UpdateArmorOffset
        clr_a
        lda     $3b00,x
        tay
        lda     ($eb),y
        sta     $38                     ; set global y-offset
        sec
        rts

; ------------------------------------------------------------------------------

; [ update magitek armor vertical offset ]

UpdateArmorOffset:
@5fef:  longa
        lda     $3500,x
        sta     $eb
        shorta
@5ff8:  lda     $3b01,x
        cmp     #$ff
        bne     @6007
        stz     $3b00,x                 ; reset pointer
        jsr     GetArmorOffsetDur
        bra     @5ff8
@6007:  lda     $3b01,x
        bne     @6017
        inc     $3b00,x
        inc     $3b00,x
        jsr     GetArmorOffsetDur
        bra     @5ff8
@6017:  dec     $3b01,x
        rts

; ------------------------------------------------------------------------------

; [ get duration for armor y-offset (2nd byte) ]

GetArmorOffsetDur:
@601b:  clr_a
        lda     $3b00,x
        tay
        iny
        lda     ($eb),y
        sta     $3b01,x
        rts

; ------------------------------------------------------------------------------

; vertical offsets for magitek armor animation
;   2 bytes each, offset then duration
ArmorOffsetTbl:
@6027:  .byte   $01,$04
        .byte   $02,$08
        .byte   $01,$04
        .byte   $00,$04
        .byte   $00,$ff  ; loop

; ------------------------------------------------------------------------------

; pointers to magitek armor sprite animation data (pelvis)
ArmorPelvisAnim:
@6031:  .addr   ArmorPelvisSprite_00
        .byte   $04
        .addr   ArmorPelvisSprite_01
        .byte   $10
        .addr   ArmorPelvisSprite_02
        .byte   $04
        .addr   ArmorPelvisSprite_03
        .byte   $10
        .addr   ArmorPelvisSprite_02
        .byte   $ff

; pointers to magitek armor sprite animation data (pelvis)
ArmorPelvisSprite_00:
@6040:  .byte   1
        .byte   $90,$27,$84,$30

ArmorPelvisSprite_01:
@6045:  .byte   1
        .byte   $90,$26,$84,$30

ArmorPelvisSprite_02:
@604a:  .byte   1
        .byte   $90,$27,$84,$70

ArmorPelvisSprite_03:
@604f:  .byte   1
        .byte   $90,$26,$84,$70

; ------------------------------------------------------------------------------

; pointers to magitek armor sprite animation data (body)
ArmorBodyAnim:
@6054:  .addr   ArmorBpdySprite_00
        .byte   $14
        .addr   ArmorBpdySprite_01
        .byte   $14
        .addr   ArmorBpdySprite_01
        .byte   $ff

; magitek armor sprite animation data (body)
ArmorBpdySprite_00:
@605d:  .byte   4
        .byte   $90,$08,$6c,$30
        .byte   $a0,$08,$6e,$30
        .byte   $90,$18,$80,$30
        .byte   $a0,$18,$82,$30

ArmorBpdySprite_01:
@606e:  .byte   4
        .byte   $98,$08,$6c,$70
        .byte   $88,$08,$6e,$70
        .byte   $98,$18,$80,$70
        .byte   $88,$18,$82,$70

; ------------------------------------------------------------------------------

; pointers to magitek armor sprite animation data (right arm)
ArmorRightArmAnim:
@607f:  .addr   ArmorRightArmSprite_00
        .byte   $08
        .addr   ArmorRightArmSprite_01
        .byte   $04
        .addr   ArmorRightArmSprite_02
        .byte   $04
        .addr   ArmorRightArmSprite_03
        .byte   $04
        .addr   ArmorRightArmSprite_04
        .byte   $08
        .addr   ArmorRightArmSprite_05
        .byte   $04
        .addr   ArmorRightArmSprite_02
        .byte   $04
        .addr   ArmorRightArmSprite_03
        .byte   $04
        .addr   ArmorRightArmSprite_03
        .byte   $ff

; magitek armor sprite animation data (right arm)
ArmorRightArmSprite_00:
@609a:  .byte   2
        .byte   $80,$08,$60,$30
        .byte   $80,$18,$62,$30

ArmorRightArmSprite_01:
@60a3:  .byte   $02
        .byte   $80,$09,$60,$30
        .byte   $80,$19,$62,$30

ArmorRightArmSprite_02:
@60ac:  .byte   $02
        .byte   $80,$09,$64,$30
        .byte   $80,$19,$66,$30

ArmorRightArmSprite_03:
@60b5:  .byte   $02
        .byte   $80,$08,$64,$30
        .byte   $80,$18,$66,$30

ArmorRightArmSprite_04:
@60be:  .byte   $02
        .byte   $80,$08,$68,$30
        .byte   $80,$18,$6a,$30

ArmorRightArmSprite_05:
@60c7:  .byte   $02
        .byte   $80,$09,$68,$30
        .byte   $80,$19,$6a,$30

; ------------------------------------------------------------------------------

; pointers to magitek armor sprite animation data (left arm)
ArmorLeftArmAnim:
@60d0:  .addr   ArmorLeftArmSprite_04
        .byte   $08
        .addr   ArmorLeftArmSprite_05
        .byte   $04
        .addr   ArmorLeftArmSprite_02
        .byte   $04
        .addr   ArmorLeftArmSprite_03
        .byte   $04
        .addr   ArmorLeftArmSprite_00
        .byte   $08
        .addr   ArmorLeftArmSprite_01
        .byte   $04
        .addr   ArmorLeftArmSprite_02
        .byte   $04
        .addr   ArmorLeftArmSprite_03
        .byte   $04
        .addr   ArmorLeftArmSprite_03
        .byte   $ff

; magitek armor sprite animation data (left arm)
ArmorLeftArmSprite_00:
@60eb:  .byte   2
        .byte   $a0,$08,$60,$70
        .byte   $a0,$18,$62,$70

ArmorLeftArmSprite_01:
@60f4:  .byte   2
        .byte   $a0,$09,$60,$70
        .byte   $a0,$19,$62,$70

ArmorLeftArmSprite_02:
@60fd:  .byte   2
        .byte   $a0,$09,$64,$70
        .byte   $a0,$19,$66,$70

ArmorLeftArmSprite_03:
@6106:  .byte   2
        .byte   $a0,$08,$64,$70
        .byte   $a0,$18,$66,$70

ArmorLeftArmSprite_04:
@610f:  .byte   2
        .byte   $a0,$08,$68,$70
        .byte   $a0,$18,$6a,$70

ArmorLeftArmSprite_05:
@6118:  .byte   2
        .byte   $a0,$09,$68,$70
        .byte   $a0,$19,$6a,$70

; ------------------------------------------------------------------------------

; pointers to magitek armor sprite animation data (right leg)
ArmorRightLegAnim:
@6121:  .addr   ArmorRightLegSprite_00
        .byte   $04
        .addr   ArmorRightLegSprite_01
        .byte   $04
        .addr   ArmorRightLegSprite_02
        .byte   $04
        .addr   ArmorRightLegSprite_03
        .byte   $04
        .addr   ArmorRightLegSprite_04
        .byte   $04
        .addr   ArmorRightLegSprite_05
        .byte   $08
        .addr   ArmorRightLegSprite_06
        .byte   $04
        .addr   ArmorRightLegSprite_07
        .byte   $04
        .addr   ArmorRightLegSprite_08
        .byte   $04
        .addr   ArmorRightLegSprite_08
        .byte   $ff

; magitek armor sprite animation data (right leg)
ArmorRightLegSprite_00:
@613f:  .byte   2
        .byte   $90,$3f,$40,$30
        .byte   $90,$4f,$42,$30

ArmorRightLegSprite_01:
@6148:  .byte   2
        .byte   $90,$3d,$40,$30
        .byte   $90,$4d,$42,$30

ArmorRightLegSprite_02:
@6151:  .byte   2
        .byte   $90,$3f,$44,$30
        .byte   $90,$4f,$46,$30

ArmorRightLegSprite_03:
@615a:  .byte   2
        .byte   $90,$3e,$44,$30
        .byte   $90,$4e,$46,$30

ArmorRightLegSprite_04:
@6163:  .byte   2
        .byte   $90,$3d,$48,$30
        .byte   $90,$4d,$4a,$30

ArmorRightLegSprite_05:
@616c:  .byte   2
        .byte   $90,$3e,$48,$30
        .byte   $90,$4e,$4a,$30

ArmorRightLegSprite_06:
@6175:  .byte   2
        .byte   $90,$3d,$4c,$30
        .byte   $90,$4d,$4e,$30

ArmorRightLegSprite_07:
@617e:  .byte   2
        .byte   $90,$3f,$4c,$30
        .byte   $90,$4f,$4e,$30

ArmorRightLegSprite_08:
@6187:  .byte   2
        .byte   $90,$41,$4c,$30
        .byte   $90,$51,$4e,$30

; ------------------------------------------------------------------------------

; pointers to magitek armor sprite animation data (left leg)
ArmorLeftLegAnim:
@6190:  .addr   ArmorLeftLegSprite_00
        .byte   $08
        .addr   ArmorLeftLegSprite_01
        .byte   $04
        .addr   ArmorLeftLegSprite_02
        .byte   $04
        .addr   ArmorLeftLegSprite_03
        .byte   $04
        .addr   ArmorLeftLegSprite_04
        .byte   $04
        .addr   ArmorLeftLegSprite_05
        .byte   $04
        .addr   ArmorLeftLegSprite_06
        .byte   $04
        .addr   ArmorLeftLegSprite_07
        .byte   $04
        .addr   ArmorLeftLegSprite_08
        .byte   $04
        .addr   ArmorLeftLegSprite_08
        .byte   $ff

; magitek armor sprite animation data (left leg)
ArmorLeftLegSprite_00:
@61ae:  .byte   2
        .byte   $a0,$3e,$48,$70
        .byte   $a0,$4e,$4a,$70

ArmorLeftLegSprite_01:
@61b7:  .byte   2
        .byte   $a0,$3d,$4c,$70
        .byte   $a0,$4d,$4e,$70

ArmorLeftLegSprite_02:
@61c0:  .byte   2
        .byte   $a0,$3f,$4c,$70
        .byte   $a0,$4f,$4e,$70

ArmorLeftLegSprite_03:
@61c9:  .byte   2
        .byte   $a0,$41,$4c,$70
        .byte   $a0,$51,$4e,$70

ArmorLeftLegSprite_04:
@61d2:  .byte   2
        .byte   $a0,$3f,$40,$70
        .byte   $a0,$4f,$42,$70

ArmorLeftLegSprite_05:
@61db:  .byte   2
        .byte   $a0,$3d,$40,$70
        .byte   $a0,$4d,$42,$70

ArmorLeftLegSprite_06:
@61e4:  .byte   2
        .byte   $a0,$3f,$44,$70
        .byte   $a0,$4f,$46,$70

ArmorLeftLegSprite_07:
@61ed:  .byte   2
        .byte   $a0,$3e,$44,$70
        .byte   $a0,$4e,$46,$70

ArmorLeftLegSprite_08:
@61f6:  .byte   2
        .byte   $a0,$3d,$48,$70
        .byte   $a0,$4d,$4a,$70

; ------------------------------------------------------------------------------

; [ load magitek march graphics ]

InitOpeningGfx:
@61ff:  jsr     LoadOpeningGfx

; load map graphics 34
        longa_clc
        lda     f:MapGfxPtrs+MAP_GFX_NARSHE_EXT_4*3
        adc     #.loword(MapGfx)
        sta     $e7
        shorta
        lda     f:MapGfxPtrs+MAP_GFX_NARSHE_EXT_4*3+2
        adc     #^MapGfx
        sta     $e9
        ldy     #$9800
        sty     $eb
        lda     #$7f
        sta     $ed
        ldy     #$0800
        sty     $ef
        jsr     CopyData

; load map graphics 31 (skip the first $0800 bytes)
        longa_clc
        lda     f:MapGfxPtrs+MAP_GFX_NARSHE_EXT_2*3
        adc     #.loword(MapGfx+$0800)
        sta     $e7
        shorta
        lda     f:MapGfxPtrs+MAP_GFX_NARSHE_EXT_2*3+2
        adc     #^(MapGfx+$0800)
        sta     $e9
        ldy     #$a000
        sty     $eb
        lda     #$7f
        sta     $ed
        ldy     #$0800
        sty     $ef
        jsr     CopyData

; load map graphics 32
        longa_clc
        lda     f:MapGfxPtrs+MAP_GFX_NARSHE_EXT_3*3
        adc     #.loword(MapGfx)
        sta     $e7
        shorta
        lda     f:MapGfxPtrs+MAP_GFX_NARSHE_EXT_3*3+2
        adc     #^MapGfx
        sta     $e9
        ldy     #$a800
        sty     $eb
        lda     #$7f
        sta     $ed
        ldy     #$0800
        sty     $ef
        jsr     CopyData

;
        stz     $e4         ;
        stz     $e5
        lda     #$80        ; 128 tiles
        sta     $ed
        ldx     #$9800
        lda     #$7f
        jsr     DrawOpeningBGTiles
        jsr     _7e62dd
        ldy     #$b800
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$4000
        sty     $eb
        ldy     #$0000
        jsr     TfrVRAM

;
        ldx     #$0080
        stx     $e4
        lda     #$80
        sta     $ed
        ldx     #$a800
        lda     #$7f
        jsr     DrawOpeningBGTiles
        jsr     _7e62dd
        ldy     #$b800
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$4000
        sty     $eb
        ldy     #$2000
        jsr     TfrVRAM
        rts

; ------------------------------------------------------------------------------

; [ copy data ]

; ++$e7: source
; ++$eb: destination
;  +$ef: size

CopyData:
@62cc:  longa
        ldy     $00
@62d0:  lda     [$e7],y
        sta     [$eb],y
        iny2
        cpy     $ef
        bne     @62d0
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e62dd:
m7scr1_set:
@62dd:  clr_ax
@62df:  longa
        lda     _7e62fb,x
        tay
        inx2
        lda     _7e62fb,x
        sta     $e7
        inx2
        shorta
        phx
        jsr     _7e631b
        plx
        cpx     #$0020
        bne     @62df
        rts

; ------------------------------------------------------------------------------

_7e62fb:
scrdata1:
@62fb:  .word   $0000,$0000,$0400,$0040,$0000,$0080,$0400,$00c0
        .word   $0800,$2000,$0c00,$2040,$0800,$2080,$0c00,$20c0

; ------------------------------------------------------------------------------

; [  ]

_7e631b:
boxscr_set:
@631b:  phb
        lda     #$7f
        pha
        plb
        lda     #$20
        sta     $e0
@6324:  lda     #$20
        sta     $e1
        ldx     $e7
@632a:  lda     $0bc0,y
        sta     $b800,x
        iny
        inx2
        dec     $e1
        bne     @632a
        longa_clc
        lda     $e7
        adc     #$0100
        sta     $e7
        shorta
        dec     $e0
        bne     @6324
        plb
        rts

; ------------------------------------------------------------------------------

; [ draw mode 7 bg tilemap for opening credits ]

DrawOpeningBGTiles:
@6348:  sta     $e9
        stx     $e7
        phb
        lda     #$7f
        pha
        plb
        clr_ax
@6353:  lda     #$08
        sta     $e6
@6357:  longa
        ldy     #$0010
        lda     [$e7]
        sta     $f1
        lda     [$e7],y
        sta     $ef
        clr_a
        shorta
        ldy     #$0008
@636a:  clr_a
        asl     $f0
        rol
        asl     $ef
        rol
        asl     $f2
        rol
        asl     $f1
        rol
        and     #$0f
        beq     @638d
        sta     $e0
        phx
        ldx     $e4
        lda     f:OpeningTilePal,x      ; bg tile palette assignment
        plx
        asl4
        and     #$30
        ora     $e0
@638d:  sta     $b801,x
        inx2
        dey
        bne     @636a
        ldy     $e7
        iny2
        sty     $e7
        dec     $e6
        bne     @6357
        longa
        inc     $e4
        lda     $e7
        clc
        adc     #$0010
        sta     $e7
        clr_a
        shorta
        dec     $ed
        bne     @6353
        plb
        rts

; ------------------------------------------------------------------------------

; pointers to snowflake sprite animation data
OpeningSnowAnim1:
@63b4:  .addr   OpeningSnowSprite1
        .byte   $fe

OpeningSnowAnim2:
@63b7:  .addr   OpeningSnowSprite2
        .byte   $fe

OpeningSnowAnim3:
@63ba:  .addr   OpeningSnowSprite3
        .byte   $fe

OpeningSnowAnim4:
@63bd:  .addr   OpeningSnowSprite4
        .byte   $fe

OpeningSnowAnim5:
@63c0:  .addr   OpeningSnowSprite5
        .byte   $fe

OpeningSnowAnim6:
@63c3:  .addr   OpeningSnowSprite6
        .byte   $fe

OpeningSnowAnim7:
@63c6:  .addr   OpeningSnowSprite7
        .byte   $fe

; snowflake sprite animation data
OpeningSnowSprite1:
@63c9:  .byte   1
        .byte   $00,$00,$86,$72

OpeningSnowSprite2:
@63ce:  .byte   1
        .byte   $00,$00,$87,$76

OpeningSnowSprite3:
@63d3:  .byte   1
        .byte   $00,$00,$88,$78

OpeningSnowSprite4:
@63d8:  .byte   1
        .byte   $00,$00,$89,$7a

OpeningSnowSprite5:
@63dd:  .byte   4
        .byte   $08,$08,$87,$72
        .byte   $00,$00,$86,$36
        .byte   $00,$10,$86,$78
        .byte   $20,$00,$86,$32

OpeningSnowSprite6:
@63ee:  .byte   2
        .byte   $00,$00,$89,$76
        .byte   $10,$08,$89,$76

OpeningSnowSprite7:
@63f7:  .byte   2
        .byte   $00,$00,$86,$7a
        .byte   $30,$08,$86,$38

; ------------------------------------------------------------------------------

; magitek march font palette
OpeningFontPal:
@6400:  .word   $0000,$7fff,$62f6,$20e6,$0000,$739c,$4e51,$1483

; magitek march background palettes (snow)
OpeningBGPal1:
@6410:  .word   $0000,$460b,$3dca,$2948,$2d69,$2949,$356a,$2008
        .word   $2008,$2008,$2008,$35cd,$31ab,$5670,$566f,$524e

OpeningBGPal2:
@6430:  .word   $0000,$460b,$3dca,$2527,$14c6,$4a0d,$1ce7,$5670
        .word   $566f,$524e,$39ac,$2d69,$2527,$5670,$566f,$524e

OpeningBGPal3:
@6450:  .word   $0000,$358a,$316a,$2d69,$2948,$2949,$2d69,$4a0d
        .word   $2008,$2008,$2008,$2008,$2008,$2008,$566f,$566f

; magitek march sprite palette (magitek armor)
OpeningArmorPal:
@6470:  .word   $0000,$41ef,$318c,$2d28,$2507,$1ce7,$18c6,$418b
        .word   $3969,$2d06,$24c5,$3d8a,$3126,$2008,$2008,$2008

; magitek march sprite palette (snow)
OpeningSnowSpritePal:
@6490:  .word   $0000,$62d2,$5a90,$524e

; narshe palette (lights off)
TownPal2:
@6498:  .word   $0000,$1576,$002e,$0c42,$0841,$45cd,$3d6a,$3528
        .word   $2528,$2ce7,$24e6,$20c5,$18c5,$18a3,$1483,$1063

; palettes for each snow tile
OpeningTilePal:
@64b8:  .byte   0,1,2,1,1,1,1,1,1,2,2,2,2,2,2,3
        .byte   2,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1
        .byte   2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1
        .byte   2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1
        .byte   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        .byte   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        .byte   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        .byte   2,2,2,2,2,2,2,2,5,5,5,5,5,5,5,5
        .byte   3,3,3,5,5,3,3,3,3,3,3,3,3,3,3,3
        .byte   2,2,5,5,5,5,3,3,3,3,3,3,3,3,3,3
        .byte   2,2,3,2,2,2,3,3,3,3,3,3,3,3,3,2
        .byte   2,3,2,2,2,3,3,2,3,3,3,3,3,4,2,2
        .byte   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        .byte   2,2,2,2,2,2,2,2,2,2,2,2,0,2,2,2

; ------------------------------------------------------------------------------

.charmap ' ',$01

.charmap 'A',$02
.charmap 'B',$03
.charmap 'C',$04
.charmap 'D',$05
.charmap 'E',$06
.charmap 'F',$07
.charmap 'G',$08
.charmap 'H',$09
.charmap 'I',$0a
.charmap 'J',$0b
.charmap 'K',$0c
.charmap 'L',$0d
.charmap 'M',$0e
.charmap 'N',$0f
.charmap 'O',$10
.charmap 'P',$11
.charmap 'Q',$12
.charmap 'R',$13
.charmap 'S',$14
.charmap 'T',$15
.charmap 'U',$16
.charmap 'V',$17
.charmap 'W',$18
.charmap 'X',$19
.charmap 'Y',$1a
.charmap 'Z',$1b

.charmap 'a',$1d
.charmap 'b',$1e
.charmap 'c',$1f
.charmap 'd',$20
.charmap 'e',$21
.charmap 'f',$22
.charmap 'g',$23
.charmap 'h',$24
.charmap 'i',$25
.charmap 'j',$26
.charmap 'k',$27
.charmap 'l',$28
.charmap 'm',$29
.charmap 'n',$2a
.charmap 'o',$2b
.charmap 'p',$2c
.charmap 'q',$2d
.charmap 'r',$2e
.charmap 's',$2f
.charmap 't',$30
.charmap 'u',$31
.charmap 'v',$32
.charmap 'w',$33
.charmap 'x',$34
.charmap 'y',$35
.charmap 'z',$36

; opening credits text
CreditsText_00:
@6598:  .word   $4458
        .byte   $24,$00
        .byte   "producer",$00

CreditsText_01:
@65a5:  .word   $44ce
        .byte   $20,$00
        .byte   "HIRONOBU SAKAGUCHI",$00

CreditsText_02:
@65bc:  .word   $4458
        .byte   $24,$01
        .byte   "director",$00

CreditsText_03:
@65c9:  .word   $44d0
        .byte   $20,$01
        .byte   "YOSHINORI KITASE",$fe
        .byte   " HIROYUKI ITOU",$00

CreditsText_04:
@65ed:  .word   $4450
        .byte   $24,$02
        .byte   "main programmer",$00

CreditsText_05:
@6601:  .word   $44d2
        .byte   $20,$02
        .byte   "  KEN NARITA",$fe
        .byte   "KIYOSHI YOSHII",$00

CreditsText_06:
@6621:  .word   $4450
        .byte   $24,$03
        .byte   "graphic director",$00

CreditsText_07:
@6636:  .word   $44ce
        .byte   $20,$03
        .byte   "TETSUYA TAKAHASHI",$fe
        .byte   "  KAZUKO SHIBUYA",$00

CreditsText_08:
@665d:  .word   $44d2
        .byte   $20,$00
        .byte   " HIDEO MINABA",$fe
        .byte   "TETSUYA NOMURA",$00

CreditsText_09:
@667e:  .word   $445a
        .byte   $24,$00
        .byte   "music",$00

CreditsText_0a:
@6688:  .word   $44d2
        .byte   $20,$00
        .byte   "NOBUO UEMATSU",$00

CreditsText_0b:
@669a:  .word   $4452
        .byte   $24,$03
        .byte   "image designer",$00

CreditsText_0c:
@66ad:  .word   $44d0
        .byte   $20,$03
        .byte   "YOSHITAKA AMANO",$00

CreditsText_0d:
@66c1:  .word   $4452
        .byte   $24,$04
        .byte   "battle planner",$00

CreditsText_0e:
@66d4:  .word   $44d0
        .byte   $20,$04
        .byte   "YASUYUKI HASEBE",$fe
        .byte   " AKIYOSHI OOTA",$00

CreditsText_0f:
@66f7:  .word   $4452
        .byte   $24,$05
        .byte   "field planner",$00

CreditsText_10:
@6709:  .word   $44ce
        .byte   $20,$05
        .byte   "YOSHIHIKO MAEKAWA",$fe
        .byte   "    KEITA ETOH",$00

CreditsText_11:
@672e:  .word   $44ce
        .byte   $20,$02
        .byte   "   SATORU TSUJI",$fe
        .byte   " HIDETOSHI KEZUKA",$00

CreditsText_12:
@6754:  .word   $4452
        .byte   $24,$06
        .byte   "event planner",$00

CreditsText_13:
@6766:  .word   $44ce
        .byte   $20,$06
        .byte   "  TSUKASA FUJITA",$fe
        .byte   "KEISUKE MATSUHARA",$00

CreditsText_14:
@678d:  .word   $444e
        .byte   $24,$06
        .byte   "effect programmer",$00

CreditsText_15:
@67a3:  .word   $44d2
        .byte   $20,$06
        .byte   "HIROSHI HARATA",$fe
        .byte   "SATOSHI OGATA",$00

CreditsText_16:
@67c4:  .word   $444e
        .byte   $24,$05
        .byte   "battle programmer",$00

CreditsText_17:
@67da:  .word   $44ce
        .byte   $20,$05
        .byte   "AKIHIRO YAMAGUCHI",$00

CreditsText_18:
@67f0:  .word   $4450
        .byte   $24,$03
        .byte   "sound programmer",$00

CreditsText_19:
@6805:  .word   $44d4
        .byte   $20,$03
        .byte   "MINORU AKAO",$00

CreditsText_1a:
@6815:  .word   $4448
        .byte   $24,$02
        .byte   "effect graphic designer",$00

CreditsText_1b:
@6831:  .word   $44d0
        .byte   $20,$02
        .byte   "HIROKATSU SASAKI",$00

CreditsText_1c:
@6846:  .word   $444a
        .byte   $24,$04
        .byte   "field graphic designer",$00

CreditsText_1d:
@6861:  .word   $44d0
        .byte   $20,$03
        .byte   "TAKAHARU MATSUO",$fe
        .byte   "  YUSUKE NAORA",$fe
        .byte   " NOBUYUKI IKEDA",$00

CreditsText_1e:
@6894:  .word   $44ce
        .byte   $20,$07
        .byte   "  TOMOE INAZAWA",$fe
        .byte   "   KAORI TANAKA",$fe
        .byte   "TAKAMICHI SHIBUYA",$00

CreditsText_1f:
@68ca:  .word   $44cc
        .byte   $20,$01
        .byte   "SHINICHIROU HAMASAKA",$fe
        .byte   "  AKIYOSHI MASUDA",$00

CreditsText_20:
@68f5:  .word   $4448
        .byte   $24,$00
        .byte   "monster graphic designer",$00

CreditsText_21:
@6912:  .word   $44d2
        .byte   $20,$00
        .byte   "HITOSHI SASAKI",$00

CreditsText_22:
@6925:  .word   $4446
        .byte   $24,$05
        .byte   "object graphic designer",$00

CreditsText_23:
@6941:  .word   $44ce
        .byte   $20,$05
        .byte   "KAZUHIRO OHKAWA",$00

CreditsText_24:
@6955:  .word   $4452
        .byte   $24,$03
        .byte   "sound engineer",$00

CreditsText_25:
@6968:  .word   $44d2
        .byte   $20,$03
        .byte   "EIJI NAKAMURA",$00

CreditsText_26:
@697a:  .word   $4452
        .byte   $24,$03
        .byte   "remake planner",$00

CreditsText_27:
@698d:  .word   $44d6
        .byte   $20,$03
        .byte   "WEIMIN LI",$fe
        .byte   " AIKO ITO",$00

.if LANG_EN

CreditsText_28:
@69a5:  .word   $4458
        .byte   $24,$03
        .byte   "translator",$00

CreditsText_29:
@69b4:  .word   $44d6
        .byte   $20,$03
        .byte   "TED WOOLSEY",$00

.endif

; ------------------------------------------------------------------------------
