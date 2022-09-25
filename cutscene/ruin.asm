
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: ruin.asm                                                             |
; |                                                                            |
; | description: world of ruin cutscene                                        |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

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
        lda     _7e6f7b,y
        sta     $3301,x
        lda     _7e6f7b+1,y
        sta     $3401,x
@6f7a:  rts

_7e6f7b:
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
@6ffb:  ldy     #.loword(RuinCutsceneGfx)
        sty     $f3
        lda     #^RuinCutsceneGfx
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
