
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: cutscene.asm                                                         |
; |                                                                            |
; | description: cutscene program                                              |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.include "cutscene_data.asm"

.import Decompress_ext
.import ExecSound_ext
.import UpdateMode7Vars_ext, PushMode7Vars_ext, PopMode7Vars_ext

.import RNGTbl
.import MapGfxPtrs, MapGfx

.export OpeningCredits_ext, TitleScreen_ext
.export FloatingContScene_ext, WorldOfRuinScene_ext

; ------------------------------------------------------------------------------

.segment "cutscene_code"
.a8
.i16

; ------------------------------------------------------------------------------

OpeningCredits_ext:
@6800:  jmp     OpeningCredits

TitleScreen_ext:
@6803:  jmp     TitleScreen

FloatingContScene_ext:
@6806:  jmp     FloatingContScene

WorldOfRuinScene_ext:
@6809:  jmp     WorldOfRuinScene

; ------------------------------------------------------------------------------

TitleScreen:
@680c:  jsr   DecompCutsceneProg
        jml   TitleScreen_ext2

; ------------------------------------------------------------------------------

OpeningCredits:
@6813:  jsr   DecompCutsceneProg
        jml   OpeningCredits_ext2

; ------------------------------------------------------------------------------

FloatingContScene:
@681a:  jsr   DecompCutsceneProg
        jml   FloatingContScene_ext2

; ------------------------------------------------------------------------------

WorldOfRuinScene:
@6821:  jsr   DecompCutsceneProg
        jml   WorldOfRuinScene_ext2

; ------------------------------------------------------------------------------

; [ decompress cutscene program ]

DecompCutsceneProg:
@6828:  php
        longai
        pha
        phx
        phy
        phb
        phd
        longi
        shorta
        lda     #$00
        pha
        plb
        ldx     #$0000
        phx
        pld
        ldx     #$0000
        stx     $00
        lda     #$7e
        sta     hWMADDH
        ldy     #.loword(CutsceneProg)
        sty     $f3
        lda     #^CutsceneProg
        sta     $f5
        ldy     #$5000                  ; destination: $7e5000
        sty     $f6
        lda     #$7e
        sta     $f8
        phb
        lda     #$7e
        pha
        plb
        jsl     Decompress_ext
        plb
        longai
        pld
        plb
        ply
        plx
        pla
        plp
        rts

; ------------------------------------------------------------------------------

; c2/686c
CutsceneProg:
        .incbin "data/cutscene_en.lz"

; ------------------------------------------------------------------------------

.segment "cutscene_code_wram"

TitleScreen_ext2:
@5000:  jmp     TitleMain

OpeningCredits_ext2:
@5003:  jmp     OpeningMain

FloatingContScene_ext2:
@5006:  jmp     FloatingContMain

WorldOfRuinScene_ext2:
@5009:  jmp     WorldOfRuinMain

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
        jsr     SplashLoop
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
        ldx     #.loword(CinematicNMI)
        stx     $1501
        ldx     #.loword(CinematicIRQ)
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
        lda     #$02        ; song $02 (opening theme 1)
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
@50df:  .word   $51ae,$5280,$5297,$52a6,$52e0,$52ec,$533f,$5377
        .word   $538a,$539c,$53b5,$53bc

; ------------------------------------------------------------------------------

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

; ------------------------------------------------------------------------------

; [ title screen $00: init ]

TitleState_00:
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
@52eb:  rts

; ------------------------------------------------------------------------------

; [  ]

TitleState_05:
@52ec:  ldy     $15
        bne     @5305
        inc     $19
        ldy     #960
        sty     $15
        jsr     _7e5306
        ldx     #$3120
        ldy     #.loword(_7e7b43)
        lda     #$04
        jsr     CreateFadePalTask
@5305:  rts

; ------------------------------------------------------------------------------

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
        lda     f:$c2fe6d,x   ; sin/cos table
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
        cmp     #$40
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
@54da:  lda     #$40
        sta     f:hWRDIVH
        clr_a
        sta     f:hWRDIVL
        lda     $3900,x
        sta     f:hWRDIVB
        nop5
        stz     $f2
        ldy     #$00fc
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
        ldy     #202
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
        ldy     #3300
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
@5c01:  .byte   $27,$00,$00
        .byte   $10,$00,$00
        .byte   $10,$00,$00
        .byte   $10,$00,$00
        .byte   $00

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
        .byte   $01
        .addr   CreditsText_28
        .byte   $01
        .addr   CreditsText_29
        .byte   $8b
        .addr   CreditsBlankText
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
@5ec2:  longac
        lda     #$0080
        sta     $e0
        bra     @5ed2
@5ecb:  longac
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
        lda     $5f07,x
        eor     #$ff
        sta     OpeningBG3ScrollHDMATbl+1
        lda     $5f08,x
        eor     #$ff
        sta     OpeningBG3ScrollHDMATbl+4
        lda     $5f09,x
        eor     #$ff
        sta     OpeningBG3ScrollHDMATbl+7
        lda     $5f0a,x
        eor     #$ff
        sta     OpeningBG3ScrollHDMATbl+10
        ply
        plx
        rts

; ------------------------------------------------------------------------------

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
        longac
        lda     f:MapGfxPtrs+34*3
        adc     #.loword(MapGfx)
        sta     $e7
        shorta
        lda     f:MapGfxPtrs+34*3+2
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
        longac
        lda     f:MapGfxPtrs+31*3
        adc     #.loword(MapGfx+$0800)
        sta     $e7
        shorta
        lda     f:MapGfxPtrs+31*3+2
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
        longac
        lda     f:MapGfxPtrs+32*3
        adc     #.loword(MapGfx)
        sta     $e7
        shorta
        lda     f:MapGfxPtrs+32*3+2
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
        longac
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

.charmap $20,$01

.charmap $41,$02
.charmap $42,$03
.charmap $43,$04
.charmap $44,$05
.charmap $45,$06
.charmap $46,$07
.charmap $47,$08
.charmap $48,$09
.charmap $49,$0a
.charmap $4a,$0b
.charmap $4b,$0c
.charmap $4c,$0d
.charmap $4d,$0e
.charmap $4e,$0f
.charmap $4f,$10
.charmap $50,$11
.charmap $51,$12
.charmap $52,$13
.charmap $53,$14
.charmap $54,$15
.charmap $55,$16
.charmap $56,$17
.charmap $57,$18
.charmap $58,$19
.charmap $59,$1a
.charmap $5a,$1b

.charmap $61,$1d
.charmap $62,$1e
.charmap $63,$1f
.charmap $64,$20
.charmap $65,$21
.charmap $66,$22
.charmap $67,$23
.charmap $68,$24
.charmap $69,$25
.charmap $6a,$26
.charmap $6b,$27
.charmap $6c,$28
.charmap $6d,$29
.charmap $6e,$2a
.charmap $6f,$2b
.charmap $70,$2c
.charmap $71,$2d
.charmap $72,$2e
.charmap $73,$2f
.charmap $74,$30
.charmap $75,$31
.charmap $76,$32
.charmap $77,$33
.charmap $78,$34
.charmap $79,$35
.charmap $7a,$36

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

CreditsText_28:
@69a5:  .word   $4458
        .byte   $24,$03
        .byte   "translator",$00

CreditsText_29:
@69b4:  .word   $44d6
        .byte   $20,$03
        .byte   "TED WOOLSEY",$00

; ------------------------------------------------------------------------------

; [ floating island ]

FloatingContMain:
@69c4:  php
        longai
        pha
        phx
        phy
        phb
        phd
        jsr     InitCutscene
        jsr     InitFloatingCont
        jsr     FloatingContLoop
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

; [ init floating continent cutscene ]

InitFloatingCont:
@69e1:  jsr     InitHWRegs
        jsr     InitFloatingContPPU
        jsr     InitRAM
        jsr     ClearVRAM
        jsr     ResetTasks
        jsr     LoadFloatingContGfx
        rts

; ------------------------------------------------------------------------------

; [  ]

InitFloatingContPPU:
@69f4:  phb
        lda     #$00
        pha
        plb
        lda     #$03
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$07
        sta     hBGMODE
        clr_a
        lda     #$80
        sta     hM7SEL
        plb
        rts

; ------------------------------------------------------------------------------

; [ floating island cutscene main loop ]

FloatingContLoop:
@6a10:  clr_a
        lda     $19
        bmi     @6a22
        asl
        tax
        jsr     (.loword(FloatingContStateTbl),x)
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @6a10
@6a22:  ldy     #15
        sty     $15
        lda     #0
        ldy     #.loword(_7e55a0)
        jsr     CreateTask
@6a2f:  ldy     $15
        beq     @6a3b
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @6a2f
@6a3b:  rts

FloatingContStateTbl:
@6a3c:  .addr   FloatingContState_00
        .addr   FloatingContState_01
        .addr   FloatingContState_02
        .addr   FloatingContState_03
        .addr   FloatingContState_04
        .addr   FloatingContState_05

; ------------------------------------------------------------------------------

; [ floating island state 0: init ]

FloatingContState_00:
@6a48:  jsr     _7e6bc3
        ldx     #$3100
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3000
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3100
        ldy     #.loword(FloatingContPal)
        lda     #$02
        jsr     CreateFadePalTask
        ldx     #$3000
        ldy     #.loword(FloatingContPal)
        lda     #$02
        jsr     CreateFadePalTask
        lda     #0
        ldy     #.loword(_7e6b8c)
        jsr     CreateTask
        inc     $19
        lda     #$0f
        sta     $32
        ldy     #16
        sty     $15
        rts

; ------------------------------------------------------------------------------

; [ floating island state 1:  ]

FloatingContState_01:
@6a87:  ldy     $15
        bne     @6a9a
        inc     $19
        ldy     #600
        sty     $15
        lda     #0
        ldy     #.loword(_7e6b18)
        jsr     CreateTask
@6a9a:  jsr     _7e6acf
        rts

; ------------------------------------------------------------------------------

; [ floating island state 2:  ]

FloatingContState_02:
@6a9e:  ldy     $15
        bne     @6aa9
        inc     $19
        ldy     #60
        sty     $15
@6aa9:  jsr     _7e6acf
        rts

; ------------------------------------------------------------------------------

; [ floating island state 3:  ]

FloatingContState_03:
@6aad:  ldy     $15
        bne     @6ab8
        inc     $19
        ldy     #1
        sty     $15
@6ab8:  jsr     _7e6acf
        rts

; ------------------------------------------------------------------------------

; [ floating island state 4:  ]

FloatingContState_04:
@6abc:  ldy     $15
        bne     @6ac2
        inc     $19
@6ac2:  jsr     _7e6acf
        rts

; ------------------------------------------------------------------------------

; [ floating island state 5: terminate ]

FloatingContState_05:
@6ac6:  lda     #$ff
        sta     $19
        clr_a
        sta     $0200
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6acf:
@6acf:  lda     $3f
        sta     f:hM7X
        lda     $40
        sta     f:hM7X
        lda     $41
        sta     f:hM7Y
        lda     $42
        sta     f:hM7Y
        lda     $44
        sta     f:hM7A
        lda     $45
        sta     f:hM7A
        lda     $46
        sta     f:hM7B
        lda     $47
        sta     f:hM7B
        lda     $48
        sta     f:hM7C
        lda     $49
        sta     f:hM7C
        lda     $4a
        sta     f:hM7D
        lda     $4b
        sta     f:hM7D
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6b18:
@6b18:  tax
        jmp     (.loword(_7e6b1c),x)

_7e6b1c:
@6b1c:  .addr   _7e6b20
        .addr   _7e6b51

; ------------------------------------------------------------------------------

; [  ]

_7e6b20:
@6b20:  ldx     $1d
        inc     $3a00,x
        lda     #$80
        sta     f:hCGSWSEL
        lda     #$57
        sta     f:hCGADSUB
        lda     #$17
        sta     f:hTM
        lda     #$17
        sta     f:hTS
        lda     #$88
        sta     $3301,x
        lda     #$20
        sta     $3302,x
        lda     #$42
        sta     $3401,x
        lda     #$20
        sta     $3600,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e6b51:
@6b51:  ldx     $1d
        lda     $3600,x
        bne     @6b87
        lda     $3301,x
        cmp     #$97
        bcs     @6b66
        sta     f:hCOLDATA
        inc     $3301,x
@6b66:  lda     $3302,x
        cmp     #$8f
        bcs     @6b74
        sta     f:hCOLDATA
        inc     $3302,x
@6b74:  lda     $3401,x
        cmp     #$91
        bcs     @6b82
        sta     f:hCOLDATA
        inc     $3401,x
@6b82:  lda     #$20
        sta     $3600,x
@6b87:  dec     $3600,x
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6b8c:
@6b8c:  jsr     _7e6b9d
        lda     $18
        and     #$07
        bne     @6b9b
        longa
        inc     $27
        shorta
@6b9b:  sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6b9d:
@6b9d:  lda     $19
        cmp     #$03
        beq     @6bad
        cmp     #$04
        beq     @6bb6
        lda     $18
        and     #$01
        bne     @6bb5
@6bad:  longa
        inc     $44
        inc     $4a
        shorta
@6bb5:  rts
@6bb6:  longa
        inc     $44
        inc     $44
        inc     $4a
        inc     $4a
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6bc3:
@6bc3:  ldy     #$0040
        sty     $3f
        ldy     #$0020
        sty     $41
        ldy     #$ffa0
        sty     $25
        ldy     #$ffc0
        sty     $27
        clr_ay
        sty     $46
        sty     $48
        ldy     #$0001
        sty     $44
        sty     $4a
        rts

; ------------------------------------------------------------------------------

; [ load graphic for floating island cutscene ]

LoadFloatingContGfx:
@6be5:  ldy     #$4e96
        sty     $f3
        lda     #$d9
        sta     $f5
        ldy     #$0000
        sty     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress_ext
        ldy     #$0000
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$9800
        sty     $eb
        lda     #$7f
        sta     $ed
        ldy     #$07c0
        sty     $ef
        jsr     CopyData
        lda     #$40
        sta     $ed
        ldx     #$9800
        lda     #$7f
        jsr     _7e6c7a
        jsr     _7e6c3d
        ldy     #$b800
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$2000
        sty     $eb
        ldy     #$0000
        jsr     TfrVRAM
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6c3d:
@6c3d:  phb
        lda     #$7f
        pha
        plb
        clr_ax
@6c44:  sta     $b800,x
        inx2
        cpx     #$2000
        bne     @6c44
        clr_ay
        sty     $e7
        lda     #$0a
        sta     $e0
@6c56:  lda     #$20
        sta     $e1
        ldx     $e7
@6c5c:  lda     $07c0,y
        sta     $b800,x
        iny
        inx2
        dec     $e1
        bne     @6c5c
        longac
        lda     $e7
        adc     #$0100
        sta     $e7
        shorta
        dec     $e0
        bne     @6c56
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6c7a:
@6c7a:  sta     $e9
        stx     $e7
        phb
        lda     #$7f
        pha
        plb
        clr_ax
@6c85:  lda     #$08
        sta     $e6
@6c89:  longa
        ldy     #$0010
        lda     [$e7]
        sta     $f1
        lda     [$e7],y
        sta     $ef
        clr_a
        shorta
        ldy     #$0008
@6c9c:  clr_a
        asl     $f0
        rol
        asl     $ef
        rol
        asl     $f2
        rol
        asl     $f1
        rol
        and     #$0f
        beq     @6cad
@6cad:  sta     $b801,x
        inx2
        dey
        bne     @6c9c
        ldy     $e7
        iny2
        sty     $e7
        dec     $e6
        bne     @6c89
        longa
        lda     $e7
        clc
        adc     #$0010
        sta     $e7
        clr_a
        shorta
        dec     $ed
        bne     @6c85
        plb
        rts

; ------------------------------------------------------------------------------

; palette for floating island cinematic
FloatingContPal:
@6cd2:  .word   $5e2f,$3e76,$298e,$210a,$1cc8,$1486,$1464,$1043
        .word   $0c23,$0422,$0000,$0000,$0000,$0000,$0000,$18a4

; ------------------------------------------------------------------------------

; [ world of ruin ]

WorldOfRuinMain:
@6cf2:  php
        longai
        pha
        phx
        phy
        phb
        phd
        jsr     InitCutscene
        jsr     InitWorldOfRuin
        jsr     WorldOfRuinLoop
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

; [ init world of ruin cutscene ]

InitWorldOfRuin:
@6d0f:  jsr     InitHWRegs
        jsr     InitWorldOfRuinPPU
        jsr     InitRAM
        jsr     ClearVRAM
        jsr     ResetTasks
        jsr     LoadWorldOfRuinGfx
        rts

; ------------------------------------------------------------------------------

; [ init ppu registers for world of ruin cutscene ]

InitWorldOfRuinPPU:
@6d22:  phb
        lda     #$00
        pha
        plb
        lda     #$03
        sta     hOBJSEL
        lda     #$82
        sta     hCGSWSEL
        lda     #$50
        sta     hCGADSUB
        lda     #$17
        sta     hTM
        lda     #$01
        sta     hTS
        lda     #$e0
        sta     hCOLDATA
        plb
        rts

; ------------------------------------------------------------------------------

; [ world of ruin cutscene main loop ]

WorldOfRuinLoop:
@6d47:  clr_a
        lda     $19
        bmi     @6d59
        asl
        tax
        jsr     (.loword(WorldOfRuinStateTbl),x)
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @6d47
@6d59:  ldy     #15
        sty     $15
        lda     #0
        ldy     #.loword(_7e55a0)
        jsr     CreateTask
@6d66:  ldy     $15
        beq     @6d72
        jsr     ExecTasks
        jsr     WaitVBlank
        bra     @6d66
@6d72:  rts

WorldOfRuinStateTbl:
@6d73:  .addr   WorldOfRuinState_00
        .addr   WorldOfRuinState_01
        .addr   WorldOfRuinState_02
        .addr   WorldOfRuinState_03
        .addr   WorldOfRuinState_04

; ------------------------------------------------------------------------------

; [ world of ruin state 0: init ]

WorldOfRuinState_00:
@6d7d:  stz     $34
        lda     #$80
        sta     $35
        ldx     #$3000
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3180
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$31a0
        ldy     #.loword(BlackPal)
        jsr     LoadPal
        ldx     #$3000
        ldy     #.loword(_7e717d)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$3180
        ldy     #.loword(_7e71bd)
        lda     #$04
        jsr     CreateFadePalTask
        ldx     #$31a0
        ldy     #.loword(_7e71dd)
        lda     #$04
        jsr     CreateFadePalTask
        lda     #2
        ldy     #.loword(_7e6efd)
        jsr     CreateTask
        longa
        lda     #.loword(WorldOfRuinLandAnim1)
        sta     $3500,x
        lda     #$fffc
        sta     $3800,x
        lda     #$0004
        sta     $3700,x
        lda     #$0168
        sta     $3600,x
        shorta
        lda     #$72
        sta     $3301,x
        lda     #$80
        sta     $3401,x
        lda     #2
        ldy     #.loword(_7e6efd)
        jsr     CreateTask
        longa
        lda     #.loword(WorldOfRuinLandAnim2)
        sta     $3500,x
        lda     #$0004
        sta     $3800,x
        lda     #$fffe
        sta     $3700,x
        lda     #$0168
        sta     $3600,x
        shorta
        lda     #$50
        sta     $3301,x
        lda     #$a0
        sta     $3401,x
        inc     $19
        lda     #$0f
        sta     $32
        ldy     #180
        sty     $15
        rts

; ------------------------------------------------------------------------------

; [ world of ruin state 1:  ]

WorldOfRuinState_01:
@6e27:  ldy     $15
        bne     @6e3a
        inc     $19
        ldy     #1080
        sty     $15
        lda     #0
        ldy     #.loword(_7e6e8a)
        jsr     CreateTask
@6e3a:  jsr     _7e6f97
        jsr     _7e6f4c
        rts

; ------------------------------------------------------------------------------

; [ world of ruin state 2:  ]

WorldOfRuinState_02:
@6e41:  ldy     $15
        bne     @6e6d
        inc     $19
        ldy     #180
        sty     $15
        ldx     #$3000
        ldy     #.loword(BlackPal)
        lda     #$08
        jsr     CreateFadePalTask
        ldx     #$3180
        ldy     #.loword(BlackPal)
        lda     #$08
        jsr     CreateFadePalTask
        ldx     #$31a0
        ldy     #.loword(BlackPal)
        lda     #$08
        jsr     CreateFadePalTask
@6e6d:  jsr     _7e6f97
        jsr     _7e6f4c
        rts

; ------------------------------------------------------------------------------

; [ world of ruin state 3:  ]

WorldOfRuinState_03:
@6e74:  ldy     $15
        bne     @6e7a
        inc     $19
@6e7a:  jsr     _7e6f97
        jsr     _7e6f4c
        rts

; ------------------------------------------------------------------------------

; [ world of ruin state 4: terminate ]

WorldOfRuinState_04:
@6e81:  lda     #$ff
        sta     $19
        clr_a
        sta     $0200
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6e8a:
@6e8a:  tax
        jmp     (.loword(_7e6e8e),x)

_7e6e8e:
@6e8e:  .addr   _7e6e92
        .addr   _7e6e97

; ------------------------------------------------------------------------------

; [  ]

_7e6e92:
@6e92:  ldx     $1d
        inc     $3a00,x

_7e6e97:
@6e97:  ldx     $1d
        lda     $3600,x
        bne     @6ed7
        ldy     $3900,x
        phy
        lda     #0
        ldy     #.loword(DefaultAnimTask)
        jsr     CreateTask
        ply
        longa
        lda     #.loword(_7e7119)
        sta     $3500,x
        shorta
        lda     _7e6ee9,y
        sta     $3301,x
        iny
        lda     _7e6ee9,y
        sta     $3401,x
        iny
        cpy     #$0014
        beq     @6ede
        ldx     $1d
        longa
        tya
        sta     $3900,x
        shorta
        lda     #$10
        sta     $3600,x
@6ed7:  ldx     $1d
        dec     $3600,x
        sec
        rts
@6ede:  ldx     #$3180
        ldy     #.loword(_7e719d)
        jsr     LoadPal
        clc
        rts

_7e6ee9:
@6ee9:  .byte   $70,$9d,$74,$a0,$78,$9e,$7c,$9d,$80,$9c
        .byte   $84,$9f,$88,$a0,$8c,$9f,$90,$a4,$94,$a5

; ------------------------------------------------------------------------------

; [  ]

_7e6efd:
@6efd:  tax
        jmp     (.loword(_7e6f01),x)

_7e6f01:
@6f01:  .addr   _7e6f05
        .addr   _7e6f15

; ------------------------------------------------------------------------------

; [  ]

_7e6f05:
@6f05:  ldx     $1d
        inc     $3a00,x
        jsr     InitAnimTask
        longa
        lda     #$0294
        sta     $3900,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_7e6f15:
@6f15:  ldx     $1d
        ldy     $3900,x
        beq     @6f47
        ldy     $3600,x
        bne     @6f38
        longac
        lda     $3300,x
        adc     $3700,x
        sta     $3300,x
        lda     $3400,x
        clc
        adc     $3800,x
        sta     $3400,x
        shorta
@6f38:  longa
        dec     $3900,x
        lda     $3600,x
        beq     @6f45
        dec     $3600,x
@6f45:  shorta
@6f47:  jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6f4c:
@6f4c:  jsr     _7e6f83
        and     #$1f
        bne     @6f7a
        lda     #0
        ldy     #.loword(_7e705a)
        jsr     CreateTask
        longa
        lda     #.loword(_7e70f6)
        sta     $3500,x
        shorta
        phx
        jsr     _7e6f83
        and     #$03
        asl
        tay
        plx
        lda     $6f7b,y
        sta     $3301,x
        lda     $6f7c,y
        sta     $3401,x
@6f7a:  rts

@6f7b:  .byte   $72,$9a,$7a,$92,$62,$aa,$52,$ba

; ------------------------------------------------------------------------------

; [  ]

_7e6f83:
@6f83:  clr_a
        inc     $34
        lda     $34
        tax
        lda     f:RNGTbl,x
        sta     $35
        tax
        lda     f:RNGTbl,x
        adc     $35
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e6f97:
@6f97:  jsr     _7e6f83
        and     #$07
        bne     @6fc8
        lda     #0
        ldy     #.loword(_7e705a)
        jsr     CreateTask
        longa
        lda     #.loword(_7e70da)
        sta     $3500,x
        shorta
        phx
        jsr     _7e6f83
        plx
        and     #$3f
        adc     #$68
        sta     $3301,x
        phx
        jsr     _7e6f83
        plx
        and     #$3f
        adc     #$98
        sta     $3401,x
@6fc8:  rts

; ------------------------------------------------------------------------------

; [  ]

@6fc9:  jsr     _7e6f83
        and     #$0f
        bne     @6ffa
        lda     #0
        ldy     #.loword(_7e705a)
        jsr     CreateTask
        longa
        lda     #.loword(_7e7142)
        sta     $3500,x
        shorta
        phx
        jsr     _7e6f83
        plx
        and     #$1f
        adc     #$68
        sta     $3301,x
        phx
        jsr     _7e6f83
        plx
        and     #$1f
        adc     #$98
        sta     $3401,x
@6ffa:  rts

; ------------------------------------------------------------------------------

; [ load graphics for world of ruin cutscene ]

LoadWorldOfRuinGfx:
@6ffb:  ldy     #$e900      ; source = $ece900 (world getting torn apart graphics)
        sty     $f3
        lda     #$ec
        sta     $f5
        ldy     #$0000      ; destination = $7f0000
        sty     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress_ext
        ldy     #$0000
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$0fe0
        sty     $eb
        ldy     #$3000
        jsr     TfrVRAM
        ldy     #$0fe0
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$0700
        sty     $eb
        ldy     #$0000
        jsr     TfrVRAM
        ldy     #$16e0
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$0de0
        sty     $eb
        ldy     #$6000
        jsr     TfrVRAM
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e705a:
@705a:  tax
        jmp     (.loword(_7e705e),x)

_7e705e:
@705e:  .addr   _7e7062
        .addr   _7e706a

; ------------------------------------------------------------------------------

; [  ]

_7e7062:
@7062:  ldx     $1d
        inc     $3a00,x
        jsr     InitAnimTask


_7e706a:
@706a:  ldx     $1d
        lda     $3b01,x
        cmp     #$fe
        beq     @7078
        jsr     UpdateAnimTask
        sec
        rts
@7078:  clc
        rts

; ------------------------------------------------------------------------------

WorldOfRuinLandAnim1:
@707a:  .addr   WorldOfRuinLandSprite1
        .byte   $fe

WorldOfRuinLandSprite1:
@707d:  .byte   10
        .byte   $90,$00,$12,$38
        .byte   $a0,$00,$14,$38
        .byte   $b0,$00,$16,$38
        .byte   $80,$10,$30,$38
        .byte   $90,$10,$32,$38
        .byte   $a0,$10,$34,$38
        .byte   $b0,$10,$36,$38
        .byte   $80,$20,$50,$38
        .byte   $90,$20,$52,$38
        .byte   $a0,$20,$54,$38

; ------------------------------------------------------------------------------

WorldOfRuinLandAnim2:
@70a6:  .addr   WorldOfRuinLandSprite2
        .byte   $fe

WorldOfRuinLandSprite2:
@70a9:  .byte   12
        .byte   $80,$18,$10,$38
        .byte   $90,$00,$18,$38
        .byte   $a0,$00,$1a,$38
        .byte   $b0,$00,$1c,$38
        .byte   $c0,$00,$1e,$38
        .byte   $90,$10,$38,$38
        .byte   $a0,$10,$3a,$38
        .byte   $b0,$10,$3c,$38
        .byte   $c0,$10,$3e,$38
        .byte   $a0,$20,$5a,$38
        .byte   $b0,$20,$5c,$38
        .byte   $c0,$20,$5e,$38

; ------------------------------------------------------------------------------

_7e70da:
@70da:  .addr   _7e70e7
        .byte   $08
        .addr   _7e70ec
        .byte   $08
        .addr   _7e70f1
        .byte   $08
        .addr   _7e70e6
        .byte   $fe

_7e70e6:
@70e6:  .byte   0

_7e70e7:
@70e7:  .byte   1
        .byte   $00,$00,$00,$3a

_7e70ec:
@70ec:  .byte   1
        .byte   $00,$00,$01,$3a

_7e70f1:
@70f1:  .byte   1
        .byte   $00,$00,$02,$3a

; ------------------------------------------------------------------------------

_7e70f6:
@70f6:  .addr   _7e7102
        .byte   $08
        .addr   _7e7107
        .byte   $08
        .addr   _7e710c
        .byte   $08
        .addr   _7e710c
        .byte   $fe

_7e7102:
@7102:  .byte   1
        .byte   $04,$04,$03,$3a

_7e7107:
@7107:  .byte   1
        .byte   $02,$02,$04,$3a

_7e710c:
@710c:  .byte   3
        .byte   $00,$00,$05,$3a
        .byte   $08,$00,$06,$3a
        .byte   $00,$08,$07,$3a

; ------------------------------------------------------------------------------

_7e7119:
@7119:  .addr   _7e712e
        .byte   $08
        .addr   _7e7133
        .byte   $08
        .addr   _7e7138
        .byte   $08
        .addr   _7e713d
        .byte   $08
        .addr   _7e7138
        .byte   $08
        .addr   _7e7133
        .byte   $08
        .addr   _7e712e
        .byte   $ff

_7e712e:
@712e:  .byte   1
        .byte   $00,$00,$08,$3a

_7e7133:
@7133:  .byte   1
        .byte   $00,$00,$09,$3a

_7e7138:
@7138:  .byte   1
        .byte   $00,$00,$0a,$3a

_7e713d:
@713d:  .byte   1
        .byte   $00,$00,$0b,$3a

; ------------------------------------------------------------------------------

_7e7142:
@7142:  .addr   _7e7151
        .byte   $08
        .addr   _7e7156
        .byte   $08
        .addr   _7e715f
        .byte   $08
        .addr   _7e716c
        .byte   $08
        .addr   _7e716c
        .byte   $fe

_7e7151:
@7151:  .byte   1
        .byte   $00,$00,$0c,$3a

_7e7156:
@7156:  .byte   2
        .byte   $00,$00,$0c,$3a
        .byte   $08,$00,$0d,$3a

_7e715f:
@715f:  .byte   3
        .byte   $00,$00,$0c,$3a
        .byte   $08,$00,$0d,$3a
        .byte   $10,$00,$0e,$3a

_7e716c:
@716c:  .byte   3                       ; *** bug: should be 4 ***
        .byte   $00,$00,$0c,$3a
        .byte   $08,$00,$0d,$3a
        .byte   $10,$00,$0e,$3a
        .byte   $18,$00,$0f,$3a

; ------------------------------------------------------------------------------

; planet palette (blue)
_7e717d:
@717d:  .word   $1ce7,$7bbd,$777a,$7758,$7317,$6ed4,$668f,$624d
        .word   $59e8,$4d86,$3d25,$30e3,$24a3,$1c82,$1862,$1042

; land palette (green with red edges)
_7e719d:
@719d:  .word   $0000,$26bf,$01ff,$4295,$3632,$3211,$2df0,$29cf
        .word   $21ae,$1d8d,$194b,$1509,$10c8,$0ca6,$0159,$00b2

; land palette (green)
_7e71bd:
@71bd:  .word   $0000,$29cf,$21ae,$4295,$3632,$3211,$2df0,$29cf
        .word   $21ae,$1d8d,$194b,$1509,$10c8,$0ca6,$29cf,$21ae

; explosion palette (red)
_7e71dd:
@71dd:  .word   $0000,$477f,$26bf,$01ff,$0159,$00b2,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; [ wait for vblank ]

WaitVBlank:
@71fd:  lda     #$81
        sta     f:hNMITIMEN
        sta     $17
        cli
@7206:  lda     $17
        bne     @7206
        sei
        lda     $32
        sta     f:hINIDISP
        lda     $31
        sta     f:hHDMAEN
        jsr     UpdateCtrl
        rts

; ------------------------------------------------------------------------------

; [ update controller ]

UpdateCtrl:
@721b:  longa
        lda     $08
        eor     #$ffff
        and     $04
        sta     $06
        ldy     $04
        sty     $08
        lda     f:hSTDCNTRL1L
        sta     $04
        shorta
        rts

; ------------------------------------------------------------------------------

; [ cinematic nmi ]

CinematicNMI:
@7233:  php
        longai
        pha
        phx
        phy
        phb
        phd
        shorta
        lda     hRDNMI
        lda     #$00
        pha
        plb
        ldx     #$0000
        phx
        pld
        lda     $17
        beq     @7259
        jsr     UpdatePPU
        ldy     $15
        beq     @7257
        dey
        sty     $15
@7257:  inc     $18
@7259:  stz     $17
        longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ cinematic irq ]

CinematicIRQ:
@7264:  rti

.a8
.i16

; ------------------------------------------------------------------------------

; [ update ppu registers and transfer data to vram ]

UpdatePPU:
@7265:  stz     hHDMAEN
        stz     hMDMAEN
        lda     $25
        sta     hBG1HOFS
        lda     $26
        sta     hBG1HOFS
        lda     $27
        sta     hBG1VOFS
        lda     $28
        sta     hBG1VOFS
        lda     $29
        sta     hBG2HOFS
        lda     $2a
        sta     hBG2HOFS
        lda     $2b
        sta     hBG2VOFS
        lda     $2c
        sta     hBG2VOFS
        lda     $2d
        sta     hBG3HOFS
        lda     $2e
        sta     hBG3HOFS
        lda     $2f
        sta     hBG3VOFS
        lda     $30
        sta     hBG3VOFS
        jsr     TfrSprites
        jsr     TfrPal
        jmp     ExecDMA

; ------------------------------------------------------------------------------

; [ transfer sprite data to ppu ]

TfrSprites:
@72b0:  ldx     $00
        stx     hOAMADDL
        txa
        sta     $4304
        lda     #$02
        sta     $4300
        lda     #$04
        sta     $4301
        ldy     #$0300
        sty     $4302
        ldy     #$0220
        sty     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ execute dma to vram ]

ExecDMA:
@72d5:  ldy     $10
        cpy     #$ffff
        beq     @72fd
        sty     hVMADDL
        lda     #$01
        sta     $4300
        lda     #$18
        sta     $4301
        ldy     $12
        sty     $4302
        lda     $14
        sta     $4304
        ldy     $0e
        sty     $4305
        lda     #$01
        sta     hMDMAEN
@72fd:  rts

; ------------------------------------------------------------------------------

; [ copy color palettes to ppu ]

TfrPal:
@72fe:  lda     $00
        sta     hCGADD
        lda     #$02
        sta     $4300
        lda     #$22
        sta     $4301
        ldy     #$3000
        sty     $4302
        lda     #$7e
        sta     $4304
        ldy     #$0200
        sty     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ load color palette ]

LoadPal:
@7324:  stx     $e7
        sty     $eb
        ldy     $00
        longa
@732c:  lda     ($eb),y
        sta     ($e7),y
        iny2
        cpy     #$0020
        bne     @732c
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create color palette thread ]

;  A: speed (frames per update)
; +X: source address
; +Y: destination address

CreateFadePalTask:
@733a:  pha
        stx     $e7
        sty     $eb
        lda     #0
        ldy     #.loword(FadePalTask)
        jsr     CreateTask
        pla
        sta     $3901,x
        longa
        lda     $e7
        sta     $3300,x
        lda     $eb
        sta     $3400,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ palette fade in task ]

FadePalTask:
@735a:  tax
        jmp     ($735e,x)

FadePalTaskTbl:
@735e:  .addr   FadePalTask_00
        .addr   FadePalTask_01

; ------------------------------------------------------------------------------

; [ init palette fade in ]

FadePalTask_00:
@7362:  ldx     $1d
        lda     #$1f
        sta     $3600,x
        stz     $3601,x
        inc     $3a00,x
        sec
        rts

; ------------------------------------------------------------------------------

; [ update palette fade in ]

FadePalTask_01:
@7371:  ldx     $1d
        lda     $3900,x
        bne     @73a3
        lda     $3901,x
        sta     $3900,x
        longa
        lda     $3300,x
        sta     $e0
        lda     $3400,x
        sta     $e3
        lda     $3600,x
        sta     $f1
        jsr     UpdateFadePal
        shorta
        ldx     a:$001d
        lda     $3600,x
        beq     @73a1
        dec     $3600,x
        bne     @73a3
@73a1:  clc
        rts
@73a3:  dec     $3900,x
        sec
        rts

; ------------------------------------------------------------------------------

; [ update palette fade in ]

UpdateFadePal:
        .a16
@73a8:  ldx     #$0010
        ldy     $00
@73ad:  lda     ($e0),y
        sta     $e7
        lda     ($e3),y
        sta     $e9
        jsr     UpdateFadeColor
        lda     $e7
        sta     ($e0),y
        iny2
        dex
        bne     @73ad
        rts

; ------------------------------------------------------------------------------

; [ update fade in color ]

UpdateFadeColor:
@73c2:  lda     $e7
        and     #$001f
        sta     $eb
        lda     $e9
        and     #$001f
        sec
        sbc     $eb
        beq     @73df
        bcc     @73dd
        cmp     $f1
        bcc     @73df
        inc     $eb
        bra     @73df
@73dd:  dec     $eb
@73df:  lda     $e7
        and     #$03e0
        sta     $ed
        lda     $e9
        and     #$03e0
        sec
        sbc     $ed
        beq     @740c
        bcc     @7404
        asl3
        xba
        cmp     $f1
        bcc     @740c
        clc
        lda     $ed
        adc     #$0020
        sta     $ed
        bra     @740c
@7404:  lda     $ed
        sec
        sbc     #$0020
        sta     $ed
@740c:  lda     $e7
        and     #$7c00
        sta     $ef
        lda     $e9
        and     #$7c00
        sec
        sbc     $ef
        beq     @743c
        bcc     @7434
        shorta
        xba
        lsr2
        longa
        cmp     $f1
        bcc     @743c
        clc
        lda     $ef
        adc     #$0400
        sta     $ef
        bra     @743c
@7434:  lda     $ef
        sec
        sbc     #$0400
        sta     $ef
@743c:  lda     $eb
        ora     $ed
        ora     $ef
        sta     $e7
        rts

.a8

; ------------------------------------------------------------------------------

; white color palette
WhitePal:
@7445:  .word   $0000,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff
        .word   $7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff

        ; black color palette
BlackPal:
@7465:  .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; [ reset threads ]

ResetTasks:
@7485:  ldx     $00
        stx     $1d
        stx     $1f
        longa
        jsr     ResetSprites
        shorti
        clr_ax
@7494:  stz     $3200,x
        stz     $3a00,x
        stz     $3c00,x
        stz     $3300,x
        stz     $3400,x
        stz     $3700,x
        stz     $3800,x
        stz     $3900,x
        inx2
        cpx     #$00
        bne     @7494
        shorta
        longi
        rts

; ------------------------------------------------------------------------------

; [ reset sprite data ]

ResetSprites:
        .a16
@74b7:  clr_ax
@74b9:  lda     #$e001
        sta     $0300,x
        inx2
        lda     #$0001
        sta     $0300,x
        inx2
        cpx     #$0200
        bne     @74b9
        ldy     $00
        tya
@74d1:  sta     $0500,y
        iny2
        cpy     #$0020
        bne     @74d1
        rts
        .a8

; ------------------------------------------------------------------------------

; [ create task ]

CreateTask:
@74dc:  jsr     InitTask
        shorta
        lda     $1d
        sta     $3c01,x
        inc     $1f
        rts

; ------------------------------------------------------------------------------

; [ init task ]

InitTask:
@74e9:  xba
        lda     #$00
        xba
        asl5
        longa
        tax
@74f5:  lda     $3200,x
        bne     @74ff
        tya
        sta     $3200,x
        rts
@74ff:  inx2
        cpx     #$0100
        bne     @74f5
        dex2
        tya
        sta     $3200,x
@750c:  bra     @750c
        rts

.a8

; ------------------------------------------------------------------------------

; [ execute tasks ]

ExecTasks:
@750f:  ldx     #$0300
        stx     $0a
        ldx     #$0500
        stx     $0c
        lda     #$03
        sta     $23
        stz     $24
        ldx     #$0080
        stx     $21
        ldx     $00
        longa
@7528:  lda     $3200,x
        beq     @754f
        stx     $1d
        phx
        sta     $1b
        shorta
        clr_a
        lda     $3a00,x
        asl
        jsr     @755c
        longa
        plx
        bcs     @754f
        stz     $3200,x
        stz     $3a00,x
        stz     $3c00,x
        stz     $3900,x
        dec     $1f
@754f:  inx2
        cpx     #$0100
        bne     @7528
        jsr     HideUnusedSprites
        shorta
        rts

; execute task (carry clear: terminate, carry set: don't terminate)
@755c:  jmp     ($001b)

; ------------------------------------------------------------------------------

; [ init animation task ]

InitAnimTask:
@755f:  clr_a
        sta     $3b00,x
        longa
        lda     $3500,x
        sta     $eb
        shorta
        ldy     #$0002
        lda     ($eb),y
        sta     $3b01,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e7575:
@7575:  phx
        jsr     UpdateAnimData
        shorti
        lda     $3b00,x
        tay
        longa
        lda     ($eb),y
        longi
        tay
        shorta
        plx
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ update animation task ]

UpdateAnimTask:
@758d:  jsr     UpdateAnimData
        jmp     UpdateAnimSprites

; ------------------------------------------------------------------------------

; [ update animation data ]

UpdateAnimData:
@7593:  ldx     $1d
        ldy     $00
        longa
        lda     $3500,x
        sta     $eb
        shorta
@75a0:  lda     $3b01,x
        cmp     #$fe
        beq     @75c9
        cmp     #$ff
        bne     @75b3
        stz     $3b00,x
        jsr     SetAnimDur
        bra     @75a0
@75b3:  lda     $3b01,x
        bne     @75c6
        lda     $3b00,x
        clc
        adc     #$03
        sta     $3b00,x
        jsr     SetAnimDur
        bra     @75a0
@75c6:  dec     $3b01,x
@75c9:  rts

; ------------------------------------------------------------------------------

; [ set animation frame counter ]

SetAnimDur:
@75ca:  shorti
        lda     $3b00,x
        tay
        iny2
        lda     ($eb),y
        sta     $3b01,x
        longi
        rts

; ------------------------------------------------------------------------------

; [ update animation sprites ]

UpdateAnimSprites:
@75da:  shorti
        lda     $3b00,x
        tay
        longa
        lda     ($eb),y
        sta     $e7
        iny2
        shorta
        longi
        ldy     $00
        lda     $21
        beq     @765c
        lda     ($e7),y
        sta     $e6
        beq     @765c
        iny
@75f9:  lda     ($e7),y
        sta     $e0
        bpl     @7611
        clr_a
        lda     $23
        tax
        lda     .loword(LargeSpriteTbl),x
        clc
        adc     $24
        sta     $24
        sta     ($0c)
        ldx     $1d
        bra     @7615
@7611:  lda     $24
        sta     ($0c)
@7615:  lda     $e0
        and     #$7f
        sta     $e0
        lda     $3a01,x
        bit     #$01
        beq     @762f
        stz     $e1
        longa
        lda     $e0
        sec
        sbc     $25
        sta     $e0
        shorta
@762f:  jsr     DrawAnimSprite
        dec     $23
        bpl     @7640
        lda     #$03
        sta     $23
        stz     $24
        longa
        inc     $0c
@7640:  longa
        lda     $e0
        sta     ($0a)
        inc     $0a
        inc     $0a
        lda     $e2
        sta     ($0a)
        inc     $0a
        inc     $0a
        shorta
        dec     $21
        beq     @765c
        dec     $e6
        bne     @75f9
@765c:  rts

; ------------------------------------------------------------------------------

; [ update animation sprite data ]

DrawAnimSprite:
@765d:  lda     $e0
        clc
        adc     $3301,x
        sta     $e0
        iny
        lda     ($e7),y
        clc
        adc     $3401,x
        sta     $e1
        iny
        lda     ($e7),y
        sta     $e2
        iny
        lda     $3a01,x
        bit     #$02
        beq     @7681
        lda     ($e7),y
        ora     #$40
        bra     @7683
@7681:  lda     ($e7),y
@7683:  clc
        adc     $3c00,x
        sta     $e3
        iny
        rts

; ------------------------------------------------------------------------------

; large sprite flags for high sprite data
LargeSpriteTbl:
@768b:  .byte   $80,$20,$08,$02

; ------------------------------------------------------------------------------

; [ hide unused sprites ]

.a16

HideUnusedSprites:
@768f:  ldy     $21
        beq     @76a3
        ldx     #$01fc
        lda     #$e001
@7699:  sta     $0300,x
        dex4
        dey
        bne     @7699
@76a3:  rts

.a8

; ------------------------------------------------------------------------------

; [  ]

@76a4:  ldx     $1d
        ldy     $00
        longa
        lda     $3500,x
        sta     $eb
        shorta
@76b1:  lda     $3b01,x
        cmp     #$fe
        beq     @76da
        cmp     #$ff
        bne     @76c4
        stz     $3b00,x
        jsr     SetAnimDur
        bra     @76b1
@76c4:  lda     $3b01,x
        bne     @76d7
        lda     $3b00,x
        clc
        adc     #$03
        sta     $3b00,x
        jsr     SetAnimDur
        bra     @76b1
@76d7:  dec     $3b01,x
@76da:  rts

; ------------------------------------------------------------------------------

; [ default animated sprite task ]

DefaultAnimTask:
@76db:  tax
        jmp     ($76df,x)

DefaultAnimTaskTbl:
@76df:  .addr   DefaultAnimTask_00
        .addr   DefaultAnimTask_01

; ------------------------------------------------------------------------------

; [ default animated sprite task 0: init ]

DefaultAnimTask_00:
@76e3:  ldx     $1d
        inc     $3a00,x
        jsr     InitAnimTask
; fallthrough

; ------------------------------------------------------------------------------

; [ default animated sprite task 1: update ]

DefaultAnimTask_01:
@76eb:  lda     $33
        bit     #$40
        bne     @770f
        ldx     $1d
        longac
        lda     $3300,x
        adc     $3700,x
        sta     $3300,x
        lda     $3400,x
        clc
        adc     $3800,x
        sta     $3400,x
        shorta
        jsr     UpdateAnimTask
        sec
        rts
@770f:  clc
        rts

; ------------------------------------------------------------------------------

; [ init hardware registers ]

InitHWRegs:
@7711:  phb
        lda     #$00
        pha
        plb
        clr_ay
        sty     hWMADDL
        sty     hOAMADDL
        sta     hOAMDATA
        sta     hOAMDATA
        sta     hMOSAIC
        sta     hHDMAEN
        sta     hMDMAEN
        sta     hBG1HOFS
        sta     hBG1HOFS
        sta     hBG1VOFS
        sta     hBG1VOFS
        sta     hBG2HOFS
        sta     hBG2HOFS
        sta     hBG2VOFS
        sta     hBG2VOFS
        sta     hBG3HOFS
        sta     hBG3HOFS
        sta     hBG3VOFS
        sta     hBG3VOFS
        sta     hBG4HOFS
        sta     hBG4HOFS
        sta     hBG4VOFS
        sta     hBG4VOFS
        sty     hVMADDL
        sty     hVMDATAL
        sta     hM7SEL
        sta     hCGADD
        sta     hCGDATA
        sta     hCGDATA
        sta     hW12SEL
        sta     hW34SEL
        sta     hWOBJSEL
        sta     hWH0
        sta     hWH2
        sta     hWH1
        sta     hWH3
        sta     hWBGLOG
        sta     hWOBJLOG
        sta     hTMW
        sta     hTSW
        sta     hSETINI
        sta     hNMITIMEN
        sta     hWRMPYA
        sta     hWRMPYB
        sta     hWRDIVL
        sta     hWRDIVL
        sta     hWRDIVH
        sta     hWRDIVB
        sta     hHTIMEL
        sta     hHTIMEL
        sta     hHTIMEH
        sta     hVTIMEL
        sta     hVTIMEL
        sta     hVTIMEH
        sta     hMDMAEN
        sta     hHDMAEN
        lda     #$63
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$01
        sta     hBGMODE
        lda     #$03
        sta     hBG1SC
        lda     #$11
        sta     hBG2SC
        lda     #$19
        sta     hBG3SC
        sta     hBG4SC
        lda     #$23
        sta     hBG12NBA
        lda     #$22
        sta     hBG34NBA
        lda     #$80
        sta     hVMAINC
        lda     #$ff
        sta     hWRIO
        lda     #$7e
        sta     hWMADDH
        lda     #$1f
        sta     hTM
        lda     #$04
        sta     hTS
        lda     #$02
        sta     hCGSWSEL
        lda     #$42
        sta     hCGADSUB
        lda     #$e0
        sta     hCOLDATA
        plb
        rts

; ------------------------------------------------------------------------------

; [ init RAM ]

InitRAM:
@7815:  clr_ay
        sty     $25
        sty     $27
        sty     $29
        sty     $2b
        sty     $2d
        sty     $2f
        sty     $15
        sty     $04
        sty     $06
        sty     $08
        sta     $33
        sta     $18
        sta     $19
        sta     $1a
        sta     $17
        sta     $31
        sta     $32
        sta     $36
        sty     $12
        sty     $0e
        lda     #$7e
        sta     $14
        ldy     #$ffff
        sty     $10
        jsr     _7e7864
        jsr     _7e7870
        rts

; ------------------------------------------------------------------------------

; [ clear vram ]

ClearVRAM:
@784f:  longa
        clr_a
        sta     f:hVMADDL
        tay
@7857:  sta     f:hVMDATAL
        iny
        cpy     #$8000
        bne     @7857
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e7864:
@7864:  clr_ax
@7866:  stz     $3d00,x
        inx
        cpx     #$0a80
        bne     @7866
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e7870:
@7870:  longa
        clr_ax
        lda     #$011f
@7877:  sta     $3d02,x
        inx4
        cpx     #$0380
        bne     @7877
        clr_ax
        lda     #$0100
@7888:  sta     $3dfc,x
        inx4
        cpx     #$0104
        bne     @7888
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e7897:
@7897:  phb
        lda     #$00
        pha
        plb
        lda     #$43
        sta     $4320
        sta     $4330
        sta     $4340
        lda     #^*
        sta     $4324
        sta     $4334
        sta     $4344
        lda     #^*
        sta     $4327
        sta     $4337
        sta     $4347
        lda     #<hBG1HOFS
        sta     $4321
        ldy     #.loword(_7e78e4)
        sty     $4322
        lda     #<hBG2HOFS
        sta     $4331
        ldy     #.loword(_7e78eb)
        sty     $4332
        lda     #<hBG3HOFS
        sta     $4341
        ldy     #.loword(_7e78f2)
        sty     $4342
        lda     #$1c
        tsb     $31
        plb
        rts

; ------------------------------------------------------------------------------

_7e78e4:
@78e4:  .byte   $e4,$00,$3d
        .byte   $fb,$90,$3e
        .byte   $00

_7e78eb:
@78eb:  .byte   $e4,$80,$40
        .byte   $fb,$10,$42
        .byte   $00

_7e78f2:
@78f2:  .byte   $e4,$00,$44
        .byte   $fb,$90,$45
        .byte   $00

; ???
@78f9:  .byte   $68

; ------------------------------------------------------------------------------

; [ load splash/title graphics ]

; decompress title/opening graphics and transfer appropriate parts to vram

LoadTitleGfx:
@78fa:  jsr     DecodeTitleOpeningGfx
        ldy     #$7930      ; source = $7f7930 (flames tile layout, bg3)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0200      ; size = $0200
        sty     $eb
        ldy     #$1400      ; set palette 5
        sty     $ed
        ldy     #$1900
        jsr     TfrVRAM
        ldy     #$7b30      ; source = $7f7b30 (flames graphics, bg3)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$06b0      ; size = $06b0
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$2000
        jsr     TfrVRAM
        ldy     #$81e0      ; source = $7f81e0 (flames tile layout, bg2)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0200      ; size = $0200
        sty     $eb
        ldy     #$0080
        sty     $ed
        ldy     #$1100
        jsr     TfrVRAM
        ldy     #$1bc0      ; source = $7f1bc0 (intro tile layout, bg1)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$1800      ; size = $1800
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$0000
        jsr     TfrVRAM
        ldy     #$33c0      ; source $7f33c0 (intro graphics)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$4200      ; size = $4200
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$4000
        jsr     TfrVRAM
        clr_ax
        longa
        lda     $dfdae1,x   ; pointer to map graphics 75 (clouds from sealed gate)
        clc
        adc     #$db00
        sta     $e7
        inx2
        shorta
        lda     $dfdae1,x
        adc     #$df
        sta     $e9
        ldy     #$2000      ; size = $2000
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$3000      ; destination = $3000 (vram)
        jsr     TfrVRAM
        ldy     #$83e0      ; source = $7f83e0 (flames graphics, 4bpp)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0800      ; size = $0800
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$2800
        jsr     TfrVRAM
        jsr     _7e7a33
        ldy     #$8be0      ; source = $7f8be0
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0200      ; size = $0200
        sty     $eb
        ldy     #$0777
        sty     $ed
        ldy     #$0500
        jsr     TfrVRAM
        ldy     #$8de0      ; source = $7f8de0
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$1110      ; size = $1110
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$6770
        jsr     TfrVRAM
        ldy     #$9ef0      ; source = $7f9ef0
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0fb8      ; size = $0fb8
        sty     $eb
        ldy     #$7000
        jsr     TfrVRAM
        rts

; ------------------------------------------------------------------------------

; [ decompress title/opening graphics ]

DecodeTitleOpeningGfx:
@7a01:  ldy     #.loword(TitleOpeningGfx)
        sty     $f3
        lda     #^TitleOpeningGfx
        sta     $f5
        ldy     #$0000
        sty     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress_ext
        rts

; ------------------------------------------------------------------------------

; [ copy to vram ]

;    +Y: destination
; ++$e7: source
;  +$eb: size
;  +$ed: constant added to each word

TfrVRAM:
@7a18:  longa
        tya
        sta     f:hVMADDL
        clr_ay
@7a21:  lda     [$e7],y
        clc
        adc     $ed
        sta     f:hVMDATAL
        iny2
        cpy     $eb
        bne     @7a21
        shorta
        rts

; ------------------------------------------------------------------------------

; [ clear $0400-$0800 and $0c00-$1000 (vram) ]

_7e7a33:
@7a33:  longa
        lda     #$0400
        sta     f:hVMADDL
        jsr     _7e7a4c
        lda     #$0c00
        sta     f:hVMADDL
        jsr     _7e7a4c
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

.a16

_7e7a4c:
@7a4c:  clr_ay
        lda     #$0777
@7a51:  sta     f:hVMDATAL
        iny
        cpy     #$0400
        bne     @7a51
        rts

.a8

; ------------------------------------------------------------------------------

TitleTextAnim1:
@7a5c:  .addr   TitleTextSprite1
        .byte   $fe

TitleTextAnim2:
@7a5f:  .addr   TitleTextSprite2
        .byte   $fe

; "(c)1994 Square"
; "Co.,Ltd"
; "Licensed by"
TitleTextSprite1:
@7a62:  .byte   13
        .byte   $00,$00,$00,$33
        .byte   $10,$00,$02,$33
        .byte   $20,$00,$04,$33
        .byte   $30,$00,$06,$33
        .byte   $40,$00,$08,$33
        .byte   $58,$00,$2a,$33
        .byte   $68,$00,$2c,$33
        .byte   $78,$00,$2e,$33
        .byte   $00,$10,$20,$33
        .byte   $10,$10,$22,$33
        .byte   $20,$10,$24,$33
        .byte   $30,$10,$26,$33
        .byte   $40,$10,$28,$33

; "Nintendo"
TitleTextSprite2:
@7a97:  .byte   4
        .byte   $00,$10,$40,$33
        .byte   $10,$10,$42,$33
        .byte   $20,$10,$44,$33
        .byte   $30,$10,$46,$33

; ------------------------------------------------------------------------------

; [ load magitek march graphics ]

; decompress title/opening graphics and transfer appropriate parts to vram

LoadOpeningGfx:
@7aa8:  jsr     DecodeTitleOpeningGfx
        ldy     #$0940      ; source = $7f0940 (snow graphics)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$b000      ; destination = $7fb000
        sty     $eb
        lda     #$7f
        sta     $ed
        ldy     #$0400      ; size $0400
        sty     $ef
        jsr     CopyData
        ldy     #$0000      ; source = $7f0000 (magitek sprite graphics)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0940      ; size = $0940
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$6400      ; destination = $6400 (vram)
        jsr     TfrVRAM
        ldy     #$53c0      ; source = $7f53c0
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$2200      ; size = $2200
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$4000      ; destination = $4000 (vram)
        jsr     TfrVRAM
        ldy     #$23c0      ; source = $7f23c0
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0800      ; size = $0800
        sty     $eb
        ldy     #$2000      ; set priority bit
        sty     $ed
        ldy     #$7c00      ; destination = $7c00 (vram)
        jsr     TfrVRAM
        jsr     _7e7b2a
        ldy     #$75c0      ; source = $7f75c0
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0370      ; size = $0370
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$7000      ; destination = $7000
        jsr     TfrVRAM
        rts

; ------------------------------------------------------------------------------

; [  ]

_7e7b2a:
boxfull:
@7b2a:  longa
        lda     #$7c00      ; destination = $7c00 (vram)
        sta     f:hVMADDL
        ldx     #$0220
        lda     #$3e87
@7b39:  sta     f:hVMDATAL
        dex
        bne     @7b39
        shorta
        rts

; ------------------------------------------------------------------------------

; intro/splash color palettes
_7e7b43:
@7b43:  .word   $0000,$0000,$24e8,$2086,$1063,$77bd,$4b5c,$2afa
        .word   $0000,$2676,$21d4,$15b2,$0000,$0ceb,$1088,$1063

; dark palette
_7e7b63:
@7b63:  .word   $1063,$1063,$1063,$1063,$1063,$1063,$1063,$1063
        .word   $1063,$1063,$1063,$1063,$1063,$1063,$1063,$1063

; flames palette
FlamesPal:
@7b83:  .word   $1063,$6f9f,$575f,$46ff,$367e,$261e,$3219,$21bb
        .word   $159b,$1d76,$1136,$10f1,$08b0,$08ad,$088b,$0050

_7e7ba3:
@7ba3:  .word   $0000,$1063,$77bd,$0000,$0000,$261e,$159b,$10f1
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

_7e7bc3:
@7bc3:  .word   $2108,$1063,$1063,$1063,$0000,$261e,$159b,$10f1
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

_7e7be3:
@7be3:  .word   $0000,$1cc6,$1ca5,$1c85,$1884,$1464,$1063,$0000
        .word   $1063,$0000,$261e,$159b,$10f1,$565b,$45b4,$352e

_7e7c03:
@7c03:  .word   $0000,$66de,$565b,$45b4,$352e,$3108,$2ce8,$28c7
        .word   $24a6,$1ca5,$1884,$1464,$1063,$21bb,$1136,$737f

_7e7c23:
@7c23:  .word   $0000,$66de,$565b,$45b4,$352e,$3108,$2ce8,$28c7
        .word   $24a6,$1ca5,$1884,$1464,$1063,$737f,$737f,$737f

; narshe palette (lights on)
TownPal1:
@7c43:  .word   $0000,$367e,$1136,$0c42,$0841,$45cd,$3d6a,$3528
        .word   $2528,$2ce7,$24e6,$20c5,$18c5,$18a3,$1483,$1063

; ------------------------------------------------------------------------------
