
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: title.asm                                                            |
; |                                                                            |
; | description: title screen (and splash screen)                              |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ title screen ]

TitleMain:
@500c:  php
        longai
        pha
        phx
        phy
        phb
        phd
        jsr     InitCutscene
        jsr     InitTitle
.if LANG_EN
        jsr     SplashLoop
.endif
        jsr     TitleLoop
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

; ------------------------------------------------------------------------------

; [ cutscene init ]

InitCutscene:
@502f:  shorta
        lda     #$7e        ; set data bank
        pha
        plb
        ldx     #$0000      ; set direct page
        phx
        pld
        ldx     #0
        stx     $00
        jsr     InitInterrupts
        rts

; ------------------------------------------------------------------------------

; [ stop music ]

SoundOff:
@5043:  lda     #$f0
        sta     f:$001300
        jsl     ExecSound_ext
        rts

; ------------------------------------------------------------------------------

; [ disable interrupts ]

DisableInterrupts:
@504e:  lda     #$8f
        sta     f:hINIDISP
        clr_a
        sta     f:hNMITIMEN
        sta     f:hMDMAEN
        sta     f:hHDMAEN
        rts

; ------------------------------------------------------------------------------

; [ set up interrupt jump code ]

InitInterrupts:
@5062:  lda     #$5c
        sta     $1500
        sta     $1504
        ldx     #.loword(CutsceneNMI)
        stx     $1501
        ldx     #.loword(CutsceneIRQ)
        stx     $1505
        lda     #^*
        sta     $1503
        sta     $1507
        rts

; ------------------------------------------------------------------------------

; [ title screen init ]

InitTitle:
@507f:  jsr     InitHWRegs
        clr_a
        jsr     PlayTitleSong
        jsr     InitRAM
        jsr     ClearVRAM
        jsr     ResetTasks
        jsr     LoadTitleGfx
        rts

; ------------------------------------------------------------------------------

; [ play opening theme 1 ]

; A: master volume

PlayTitleSong:
@5093:  sta     f:$001302
        lda     #$10
        sta     f:$001300
        lda     #$02                    ; song $02 (opening theme 1)
        sta     f:$001301
        jsl     ExecSound_ext
        rts

; ------------------------------------------------------------------------------

; [ title screen main loop ]

TitleLoop:
@50a8:  clr_a
        lda     $19
        bmi     @50c5
        asl
        tax
        jsr     (.loword(TitleStateTbl),x)
        lda     $06
        bit     #$80
        bne     @50c0
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @50a8
@50c0:  lda     #$ff
        sta     $0200
@50c5:  ldy     #15
        sty     $15
        lda     #0
        ldy     #.loword(_7e55a0)
        jsr     CreateTask
@50d2:  ldy     $15
        beq     @50de
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @50d2
@50de:  rts

; title screen jump table
TitleStateTbl:
@50df:  .addr   TitleState_00
        .addr   TitleState_01
        .addr   TitleState_02
        .addr   TitleState_03
        .addr   TitleState_04
        .addr   TitleState_05
        .addr   TitleState_06
        .addr   TitleState_07
        .addr   TitleState_08
        .addr   TitleState_09
        .addr   TitleState_0a
        .addr   TitleState_0b

; ------------------------------------------------------------------------------

.if LANG_EN

; [ splash screen main loop ]

SplashLoop:
@50f7:  clr_a
        lda     $19
        bmi     @5109
        asl
        tax
        jsr     (.loword(SplashStateTbl),x)
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @50f7
@5109:  ldy     #15
        sty     $15
        lda     #0
        ldy     #.loword(_7e55a0)
        jsr     CreateTask
@5116:  ldy     $15
        beq     @5122
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @5116
@5122:  clr_ay
        sta     $19
        sty     $25
        sty     $27
        jsr     ResetTasks
        jsr     DisableInterrupts
        rts

; splash screen jump table
SplashStateTbl:
@5131:  .addr   SplashState_00
        .addr   SplashState_01

; ------------------------------------------------------------------------------

; splash screen color palettes
SplashPal:
@5135:  .word   $0000,$1063,$77bd,$0000,$7fff,$7fff,$7fff,$7fff
        .word   $7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff

; ------------------------------------------------------------------------------

; [ splash screen $00: init ]

SplashState_00:
@5155:  jsr     _7e5306
        ldx     #$3000
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3020
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3120
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3120
        ldy     #.loword(_7e7b43)
        lda     #$01
        jsr     CreateFadePalTask
        ldx     #$3000
        ldy     #.loword(WhitePal)
        lda     #$01
        jsr     CreateFadePalTask
        ldx     #$3020
        ldy     #.loword(SplashPal)
        lda     #$01
        jsr     CreateFadePalTask
        ldy     #$0100
        sty     $25
        ldy     #300
        sty     $15
        inc     $19
        lda     #$0f
        sta     $32
        rts

; ------------------------------------------------------------------------------

; [ splash screen $01: wait ]

SplashState_01:
@51a5:  ldy     $15
        bne     @51ad
        lda     #$ff
        sta     $19
@51ad:  rts

.endif

; ------------------------------------------------------------------------------

; [ title screen $00: init ]

TitleState_00:
.if !LANG_EN
        ldx     #$3100
        ldy     #$73D1
        jsr     LoadPal
.endif
@51ae:  ldx     #$3120
        ldy     #.loword(_7e7b63)
        jsr     LoadPal
        ldx     #$3140
        ldy     #.loword(_7e7b43)
        jsr     LoadPal
        ldx     #$3000
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3020
        ldy     #.loword(_7e7bc3)
        jsr     LoadPal
        ldx     #$30c0
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
        ldx     #$30a0
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$30c0
        ldy     #.loword(_7e7c03)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$3040
        ldy     #.loword(_7e7c23)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$3060
        ldy     #.loword(_7e7c23)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$30e0
        ldy     #.loword(TownPal1)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$30a0
        ldy     #.loword(_7e7be3)
        lda     #$04
        jsr     CreateFadePalTask
        lda     #1
        ldy     #.loword(_7e5539)
        jsr     CreateTask
        ldy     #60
        sty     $15
        inc     $19
        lda     #$0f
        sta     $32
        lda     #1
        ldy     #.loword(_7e55c8)
        jsr     CreateTask
        longa
        lda     #$3040
        sta     $3701,x
        shorta
        lda     #1
        ldy     #.loword(_7e55c8)
        jsr     CreateTask
        longa
        lda     #$3060
        sta     $3701,x
        shorta
        lda     #1
        ldy     #.loword(_7e55c8)
        jsr     CreateTask
        longa
        lda     #$30c0
        sta     $3701,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_01:
@5280:  ldy     $15
        bne     @5296
        inc     $19
        ldy     #1091
        sty     $15
        lda     #$ff
        sta     f:$001305
        lda     #$ff
        jsr     PlayTitleSong
@5296:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_02:
@5297:  ldy     $15
        bne     @52a5
        jsr     _7e7897
.if !LANG_EN
        lda     #0
        ldy     #.loword(_7e5323)
        jsr     CreateTask
.endif
        ldy     #30
        sty     $15
        inc     $19
@52a5:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_03:
@52a6:  ldy     $15
        bne     @52df
        lda     #0
        ldy     #.loword(_7e53c5)
        jsr     CreateTask
        lda     #0
        ldy     #.loword(_7e5431)
        jsr     CreateTask
        lda     #0
        ldy     #.loword(_7e54af)
        jsr     CreateTask
        ldx     #$3000
        ldy     #.loword(FlamesPal)
        lda     #$02
        jsr     CreateFadePalTask
        ldx     #$3020
        ldy     #.loword(_7e7ba3)
        lda     #$01
        jsr     CreateFadePalTask
        ldy     #330
        sty     $15
        inc     $19
@52df:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_04:
@52e0:  ldy     $15
        bne     @52eb
        inc     $19
        ldy     #240
        sty     $15
.if !LANG_EN
        lda     #0
        ldy     #.loword(DefaultAnimTask)
        jsr     CreateTask
        longa
        lda     #$79f6
        sta     $3500,x
        shorta
        lda     #$38
        sta     $3301,x
        lda     #$1f
        sta     $3401,x
        ldx     #$3100
        ldy     #$7ae5
        lda     #$08
        jsr     CreateFadePalTask
.endif
@52eb:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_05:
@52ec:  ldy     $15
        bne     @5305
        inc     $19
        ldy     #960
        sty     $15
.if LANG_EN
        jsr     _7e5306
.else
        lda     #0
        ldy     #.loword(DefaultAnimTask)
        jsr     CreateTask
        longa
        lda     #$79f9
        sta     $3500,x
        shorta
        lda     #$48
        sta     $3301,x
        lda     #$a8
        sta     $3401,x
.endif
        ldx     #$3120
        ldy     #.loword(_7e7b43)
        lda     #$04
        jsr     CreateFadePalTask
@5305:  rts

; ------------------------------------------------------------------------------

.if LANG_EN

; [  ]

_7e5306:
@5306:  lda     #0
        ldy     #.loword(DefaultAnimTask)
        jsr     CreateTask
        longa
        lda     #.loword(TitleTextAnim1)
        sta     $3500,x
        shorta
        lda     #$40
        sta     $3301,x
        lda     #$a0
        sta     $3401,x
        lda     #0
        ldy     #.loword(DefaultAnimTask)
        jsr     CreateTask
        longa
        lda     #.loword(TitleTextAnim2)
        sta     $3500,x
        shorta
        lda     #$90
        sta     $3301,x
        lda     #$a0
        sta     $3401,x
        rts

.endif

; ------------------------------------------------------------------------------

; [  ]

TitleState_06:
@533f:  ldy     $15
        bne     @5376
        inc     $19
        ldy     #256
        sty     $15
        ldx     #$3100
        ldy     #.loword(_7e7b63)
        lda     #$02
        jsr     CreateFadePalTask
        ldx     #$3120
        ldy     #.loword(_7e7b63)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$3000
        ldy     #.loword(_7e7b63)
        lda     #$08
        jsr     CreateFadePalTask
        ldx     #$3020
        ldy     #.loword(_7e7b63)
        lda     #$08
        jsr     CreateFadePalTask
@5376:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_07:
@5377:  ldy     $15
        bne     @5389
        lda     #$40
        tsb     $33
        inc     $19
        ldy     #1
        sty     $15
        jsr     CreateTownLightsThread
@5389:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_08:
@538a:  ldy     $15
        bne     @539b
        inc     $19
        stz     $31
        lda     #$80
        sta     $33
        ldy     #928
        sty     $15
@539b:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_09:
@539c:  ldy     $15
        bne     @53a8
        ldy     #480
        sty     $15
        inc     $19
        rts
@53a8:  lda     $18
        and     #$03
        bne     @53b4
        longa
        inc     $27
        shorta
@53b4:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_0a:
@53b5:  ldy     $15
        bne     @53bb
        inc     $19
@53bb:  rts

; ------------------------------------------------------------------------------

; [ title screen $0b: terminate ]

TitleState_0b:
@53bc:  lda     #$ff
        sta     $19
        clr_a
        sta     $0200
        rts

; ------------------------------------------------------------------------------

.if !LANG_EN

_7e5323:
@5323:  tax
        jmp     ($5327,x)

@5327:  .addr   $532b,$535d

@532b:  ldx     $1d
        inc     $3a00,x
        longa
        clr_ax
@5334:  lda     $7f8ca0,x
        adc     #$0780
        sta     $4780,x
        inx2
        cpx     #$0040
        bne     @5334
        ldx     $1d
        lda     #$0002
        sta     $3900,x
        shorta
        ldy     #$05a0
        sty     $10
        lda     #$7e
        sta     $14
        ldy     #$4780
        sty     $12

@535d:  ldx     $1d
        longa
        lda     $3900,x
        cmp     #$0040
        beq     @5375
        sta     $0e
        inc     $3900,x
        inc     $3900,x
        shorta
        sec
        rts
@5375:  shorta
        clc
        rts

.endif

; ------------------------------------------------------------------------------

; [  ]

_7e53c5:
@53c5:  tax
        jmp     (.loword(_7e53c9),x)

_7e53c9:
@53c9:  .addr   _7e53cd
        .addr   _7e53d5

; ------------------------------------------------------------------------------

; [  ]

_7e53cd:
@53cd:  ldx     $1d
        inc     $3a00,x
        stz     $3701,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e53d5:
@53d5:  lda     $33
        bmi     @542f
        ldx     $1d
        clr_ay
        stz     $3801,x
@53e0:  ldx     $1d
        lda     $3701,x
        clc
        adc     $3801,x
        jsr     CalcSine
        pha
@53ed:  lda     f:hHVBJOY
        and     #$40
        beq     @53ed
        lda     #$08
        sta     f:hM7A
        clr_a
        sta     f:hM7A
        pla
        sta     f:hM7B
        sta     f:hM7B
        ldx     $1d
        longa
        lda     f:hMPYM
        sta     $4180,y
        shorta
        ldx     $1d
        lda     $3801,x
        clc
        adc     #$04
        sta     $3801,x
        iny4
        cpy     #$00c0
        bne     @53e0
        inc     $3701,x
        sec
        rts
@542f:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e5431:
@5431:  tax
        jmp     (.loword(_7e5435),x)

_7e5435:
@5435:  .addr   _7e5439
        .addr   _7e5441

; ------------------------------------------------------------------------------


; [  ]

_7e5439:
@5439:  ldx     $1d
        inc     $3a00,x
        stz     $3900,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e5441:
@5441:  lda     $33
        bmi     @54a0
        ldx     $1d
        clr_ay
        lda     #$10
        sta     $3801,x
@544e:  ldx     $1d
        lda     $3701,x
        clc
        adc     $3801,x
        jsr     CalcSine
        pha
@545b:  lda     f:hHVBJOY
        and     #$40
        beq     @545b
        lda     #$0a
        sta     f:hM7A
        clr_a
        sta     f:hM7A
        pla
        sta     f:hM7B
        sta     f:hM7B
        ldx     $1d
        longa
        lda     f:hMPYM
        sta     $4500,y
        sta     $4502,y
        shorta
        ldx     $1d
        lda     $3801,x
        clc
        adc     #$04
        sta     $3801,x
        iny4
        cpy     #$00c0
        bne     @544e
        inc     $3701,x
        sec
        rts
@54a0:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

CalcCosine:
@54a2:  clc
        adc     #$40

CalcSine:
@54a5:  xba
        lda     $00
        xba
        tax
        lda     f:SineTbl8,x   ; sin/cos table
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e54af:
@54af:  tax
        jmp     (.loword(_7e54b3),x)

_7e54b3:
@54b3:  .addr   _7e54b7
        .addr   _7e54c1

; ------------------------------------------------------------------------------

; [  ]

_7e54b7:
@54b7:  ldx     $1d
        inc     $3a00,x
        lda     #$01
        sta     $3900,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e54c1:
@54c1:  lda     $18
        and     #$01
        beq     @54d6
        ldx     $1d
        lda     $3900,x
.if LANG_EN
        cmp     #$40
.else
        cmp     #$2a
.endif
        beq     @54d8
        jsr     _7e54da
        inc     $3900,x
@54d6:  sec
        rts
@54d8:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e54da:
@54da:
.if LANG_EN
        lda     #$40
.else
        lda     #$2a
.endif
        sta     f:hWRDIVH
        clr_a
        sta     f:hWRDIVL
        lda     $3900,x
        sta     f:hWRDIVB
        nop5
        stz     $f2
.if LANG_EN
        ldy     #$00fc
.else
        ldy     #$00a0
.endif
        stz     $e2
        stz     $e9
        stz     $ea
        lda     f:hRDDIVH
        sta     $e8
        lda     f:hRDDIVL
        sta     $e7
@5508:  lda     $3900,x
        cmp     $e2
        bcc     @5511
        bra     @5518
@5511:  longa
        lda     #$0100
        bra     @5524
@5518:  clr_a
        lda     $ea
        sec
        sbc     $e2
        longa
        eor     #$ffff
        inc
@5524:  sta     $3dfa,y
        lda     $e7
        clc
        adc     $e9
        sta     $e9
        shorta
        inc     $e2
        dey4
        bne     @5508
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e5539:
@5539:  tax
        jmp     (.loword(_7e553d),x)

_7e553d:
@553d:  .addr   _7e5541
        .addr   _7e5559

; ------------------------------------------------------------------------------

; [  ]

_7e5541:
@5541:  ldy     #$ffff
        sty     $10
        ldy     #$0040
        sty     $0e
        lda     #$7f
        sta     $14
        ldy     #$0001
        sty     $27
        ldx     $1d
        inc     $3a00,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e5559:
@5559:  lda     $18
        and     #$03
        bne     @5595
        longa
        lda     $27
        cmp     #$011f
        beq     @5597
        cmp     #$0100
        bcs     @5591
        and     #$0007
        bne     @5591
        lda     $27
        sec
        sbc     #$0008
        and     #$fff8
        asl3
        clc
        adc     #$23c0
        sta     $12
        lda     $27
        sec
        sbc     #$0008
        and     #$fff8
        asl2
        sta     $10
@5591:  inc     $27
        shorta
@5595:  sec
        rts
@5597:  shorta
        ldy     #$ffff
        sty     $10
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e55a0:
@55a0:  tax
        jmp     (.loword(_7e55a4),x)

_7e55a4:
@55a4:  .addr   _7e55a8
        .addr   _7e55b2

; ------------------------------------------------------------------------------

; [  ]

_7e55a8:
@55a8:  ldx     $1d
        inc     $3a00,x
        lda     #$0f
        sta     $3301,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e55b2:
@55b2:  ldy     $15
        beq     @55c2
        ldx     $1d
        lda     $3301,x
        sta     $32
        dec     $3301,x
        sec
        rts
@55c2:  lda     #$80
        sta     $32
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e55c8:
@55c8:  tax
        jmp     (.loword(_7e55cc),x)

_7e55cc:
@55cc:  .addr   _7e55d2
        .addr   _7e55eb
        .addr   _7e5620

; ------------------------------------------------------------------------------

; [  ]

_7e55d2:
@55d2:  ldx     $1d
        inc     $3a00,x
        lda     #$80
        sta     $3600,x

_7e55dc:
@55dc:  longa
        lda     #.loword(_7e563e)
        sta     $3500,x
        shorta
        jsr     InitAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e55eb:
@55eb:  ldx     $1d
        lda     $3600,x
        beq     @5609
        cmp     #$01
        beq     @55fd
@55f6:  ldx     $1d
        dec     $3600,x
        sec
        rts
@55fd:  lda     #2
        ldy     #.loword(_7e56f9)
        jsr     CreateTask
        inc     $36
        bra     @55f6
@5609:  lda     $3b01,x
        cmp     #$fe
        bne     @5613
        inc     $3a00,x
@5613:  longa
        lda     $3701,x
        tax
        shorta
        jsr     _7e7575
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e5620:
@5620:  jsr     Rand
        ldx     $1d
        sta     $3600,x
        lda     #$01
        sta     $3a00,x
        jmp     _7e55dc

; ------------------------------------------------------------------------------

; [ generate random number ]

Rand:
@5630:  clr_a
        inc     $34
        lda     $18
        clc
        adc     $34
        tax
        lda     f:RNGTbl,x
        rts

; ------------------------------------------------------------------------------

_7e563e:
@563e:  .addr   _7e7c23
        .byte   $01
        .addr   _7e5659
        .byte   $02
        .addr   _7e56d9
        .byte   $01
        .addr   _7e5659
        .byte   $02
        .addr   _7e56d9
        .byte   $01
        .addr   _7e5679
        .byte   $02
        .addr   _7e5699
        .byte   $03
        .addr   _7e56b9
        .byte   $04
        .addr   _7e56d9
        .byte   $fe

; ------------------------------------------------------------------------------

_7e5659:
@5659:  .word   $1063,$66de,$565b,$45b4,$352e,$3108,$2ce8,$28c7
        .word   $24a6,$1ca5,$1884,$1464,$1063,$21bb,$1136,$737f

_7e5679:
@5679:  .word   $0000,$5239,$45d7,$3951,$2cec,$2ce7,$28c7,$24a6
@5689:  .word   $2085,$1884,$1484,$1464,$1063,$21bb,$1136,$5a7b

_7e5699:
@5699:  .word   $0000,$3d94,$3553,$2cee,$24aa,$24a5,$2085,$1c64
@56a9:  .word   $1464,$1063,$1063,$1063,$1063,$21bb,$1136,$45d6

_7e56b9:
@56b9:  .word   $0000,$20aa,$20a7,$1c85,$1843,$1063,$1063,$1063
@56c9:  .word   $1063,$1063,$1063,$1063,$1063,$21bb,$1136,$24cc

_7e56d9:
@56d9:  .word   $0000,$1063,$1063,$1063,$1063,$1063,$1063,$1063
@56e9:  .word   $1063,$1063,$1063,$1063,$1063,$21bb,$1136,$1063

; ------------------------------------------------------------------------------

; [  ]

_7e56f9:
@56f9:  tax
        jmp     (.loword(_7e56fd),x)

_7e56fd:
@56fd:  .addr   _7e5701,_7e5736

; ------------------------------------------------------------------------------

; [  ]

_7e5701:
@5701:  ldx     $1d
        inc     $3a00,x
        jsr     Rand
        and     #$03
        beq     _5744
        asl
        tax
        longa
        lda     _7e5746,x
        ldx     $1d
        sta     $3500,x
        shorta
        shorta
        phx
        jsr     Rand
        plx
        sta     $3301,x
        phx
        jsr     Rand
        plx
        and     #$7f
        adc     #$10
        sta     $3401,x
        ldx     $1d
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e5736:
@5736:  ldx     $1d
        lda     $3b01,x
        cmp     #$fe
        beq     _5744
        jsr     UpdateAnimTask
        sec
        rts
_5744:  clc
        rts

; ------------------------------------------------------------------------------

_7e5746:
@5746:  .addr   0
        .addr   _7e574e
        .addr   _7e5766
        .addr   _7e574e

_7e574e:
@574e:  .addr   _7e577f
        .byte   $01
        .addr   _7e577e
        .byte   $01
        .addr   _7e5784
        .byte   $01
        .addr   _7e577e
        .byte   $01
        .addr   _7e5791
        .byte   $01
        .addr   _7e577e
        .byte   $01
        .addr   _7e579e
        .byte   $01
        .addr   _7e577e
        .byte   $fe

_7e5766:
@5766:  .addr   _7e57ab
        .byte   $01
        .addr   _7e577e
        .byte   $01
        .addr   _7e57b0
        .byte   $01
        .addr   _7e577e
        .byte   $01
        .addr   _7e57bd
        .byte   $01
        .addr   _7e577e
        .byte   $01
        .addr   _7e57ca
        .byte   $01
        .addr   _7e577e
        .byte   $fe

; ------------------------------------------------------------------------------

_7e577e:
@577e:  .byte   0

_7e577f:
@577f:  .byte   1
        .byte   $08,$00,$4c,$35

_7e5784:
@5784:  .byte   3
        .byte   $00,$00,$4e,$35
        .byte   $10,$00,$60,$35
        .byte   $08,$10,$62,$35

_7e5791:
@5791:  .byte   3
        .byte   $08,$00,$64,$35
        .byte   $08,$10,$66,$35
        .byte   $08,$20,$68,$35

_7e579e:
@579e:  .byte   3
        .byte   $08,$00,$6a,$35
        .byte   $08,$10,$6c,$35
        .byte   $08,$20,$6e,$35

_7e57ab:
@57ab:  .byte   1
        .byte   $08,$00,$4c,$75

_7e57b0:
@57b0:  .byte   3
        .byte   $10,$00,$4e,$75
        .byte   $08,$00,$60,$75
        .byte   $08,$10,$62,$75

_7e57bd:
@57bd:  .byte   3
        .byte   $08,$00,$64,$75
        .byte   $08,$10,$66,$75
        .byte   $08,$20,$68,$75

_7e57ca:
@57ca:  .byte   3
        .byte   $08,$00,$6a,$75
        .byte   $08,$10,$6c,$75
        .byte   $08,$20,$6e,$75

; ------------------------------------------------------------------------------

@57d7:  .byte   $40,$a8,$40,$70,$b0,$48,$68,$a8,$70,$68,$60,$a8,$80,$d0
        .byte   $88,$58,$90,$a8,$98,$88,$50,$58,$70,$60,$90,$60,$10,$78

; ------------------------------------------------------------------------------
