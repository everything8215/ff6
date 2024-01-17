.segment "menu_code_far"
begin_fixed_block MenuCodeFar, $0600

; ------------------------------------------------------------------------------

; [ clear party character data ]

ClearCharProp:
@ca00:  stz     $75                     ; clear battle order
        stz     $76
        stz     $77
        stz     $78
        ldy     $00
        sty     $6d                     ; clear character data pointers
        sty     $6f
        sty     $71
        sty     $73
        lda     #$ff
        sta     $69                     ; set character numbers to $ff (no character)
        sta     $6a
        sta     $6b
        sta     $6c
        rtl

; ------------------------------------------------------------------------------

; [ init hdma for menu window gradient bars ]

; a: 0 = normal, 1 = save select, 2 = colosseum

InitGradientHDMA:
@ca1d:  xba
        lda     $00
        xba
        asl
        tax
        longa
        lda     f:MenuFixedColorHDMATblPtrs,x
        sta     $4332
        lda     f:MenuAddSubHDMATblPtrs,x
        sta     $4342
        shorta
        stz     $4330
        lda     #$32
        sta     $4331
        lda     #^*
        sta     $4334
        sta     $4337
        sta     $4344
        sta     $4347
        stz     $4340
        lda     #$31
        sta     $4341
        lda     #$18
        tsb     $43
        lda     #$80
        sta     hCGSWSEL
        lda     #$82
        sta     hCGADSUB
        lda     #$17
        sta     hTM
        lda     #$17
        sta     hTS
        lda     #$e0
        sta     hCOLDATA
        rtl

; ------------------------------------------------------------------------------

; pointers to add/sub dma tables
MenuAddSubHDMATblPtrs:
@ca71:  .addr   MenuAddSubHDMATbl_00
        .addr   MenuAddSubHDMATbl_01
        .addr   MenuAddSubHDMATbl_02

; add/sub hdma data for normal menu window
MenuAddSubHDMATbl_00:
@ca77:  .byte   $70,$02
        .byte   $70,$82
        .byte   $00

; pointers to fixed color hdma tables
MenuFixedColorHDMATblPtrs:
@ca7c:  .addr   MenuFixedColorHDMATbl_00
        .addr   MenuFixedColorHDMATbl_01
        .addr   MenuFixedColorHDMATbl_02

; fixed color hdma data for normal menu window
MenuFixedColorHDMATbl_00:
@ca82:  .byte   $0a,$eb
        .byte   $0a,$ea
        .byte   $0a,$e9
        .byte   $0a,$e8
        .byte   $0a,$e7
        .byte   $0a,$e6
        .byte   $0a,$e5
        .byte   $0a,$e4
        .byte   $0a,$e3
        .byte   $0a,$e2
        .byte   $0a,$e1
        .byte   $0a,$e0
        .byte   $0a,$e1
        .byte   $0a,$e2
        .byte   $0a,$e3
        .byte   $0a,$e4
        .byte   $0a,$e5
        .byte   $0a,$e6
        .byte   $0a,$e7
        .byte   $0a,$e8
        .byte   $0a,$e9
        .byte   $0a,$ea
        .byte   $0a,$eb
        .byte   $0a,$ec
        .byte   $00

; add/sub hdma data for save select menu window
MenuAddSubHDMATbl_01:
@cab3:  .byte   $1f,$02
        .byte   $10,$82
        .byte   $1c,$02
        .byte   $1c,$82
        .byte   $1c,$02
        .byte   $1c,$82
        .byte   $1c,$02
        .byte   $1c,$82
        .byte   $00

; add/sub hdma data for colosseum menu window
MenuAddSubHDMATbl_02:
@cac4:  .byte   $17,$02
        .byte   $78,$82
        .byte   $24,$02
        .byte   $24,$82
        .byte   $00

; fixed color hdma data for save select menu window
MenuFixedColorHDMATbl_01:
@cacd:  .byte   $0f,$e0
        .byte   $02,$e7
        .byte   $02,$e6
        .byte   $02,$e5
        .byte   $02,$e4
        .byte   $02,$e3
        .byte   $02,$e2
        .byte   $02,$e1
        .byte   $02,$e0
        .byte   $02,$e1
        .byte   $02,$e2
        .byte   $02,$e3
        .byte   $02,$e4
        .byte   $02,$e5
        .byte   $02,$e6
        .byte   $02,$e7
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $00

; fixed color hdma data for colosseum menu window
MenuFixedColorHDMATbl_02:
@cb42:  .byte   $07,$e0
        .byte   $02,$e7
        .byte   $02,$e6
        .byte   $02,$e5
        .byte   $02,$e4
        .byte   $02,$e3
        .byte   $02,$e2
        .byte   $02,$e1
        .byte   $02,$e0
        .byte   $02,$e1
        .byte   $02,$e2
        .byte   $02,$e3
        .byte   $02,$e4
        .byte   $02,$e5
        .byte   $02,$e6
        .byte   $03,$e7
        .byte   $67,$e0
        .byte   $02,$ea
        .byte   $04,$e9
        .byte   $04,$e8
        .byte   $04,$e7
        .byte   $04,$e6
        .byte   $04,$e5
        .byte   $04,$e4
        .byte   $04,$e3
        .byte   $04,$e2
        .byte   $04,$e1
        .byte   $04,$e0
        .byte   $04,$e1
        .byte   $04,$e2
        .byte   $04,$e3
        .byte   $04,$e4
        .byte   $04,$e5
        .byte   $04,$e6
        .byte   $04,$e7
        .byte   $04,$e8
        .byte   $04,$e9
        .byte   $02,$ea
        .byte   $00

; ------------------------------------------------------------------------------

; [ init mode 7 hdma ]

_d4cb8f:
@cb8f:  lda     #$42
        sta     $4340
        sta     $4350
        sta     $4360
        sta     $4370
        lda     #$1b
        sta     $4341
        inc
        sta     $4351
        inc
        sta     $4361
        inc
        sta     $4371
        ldy     #.loword(_d4cbe7)
        sty     $4342
        ldy     #.loword(_d4cbee)
        sty     $4352
        ldy     #.loword(_d4cbf5)
        sty     $4362
        ldy     #.loword(_d4cbe7)
        sty     $4372
        lda     #^*
        sta     $4344
        sta     $4354
        sta     $4364
        sta     $4374
        lda     #$00
        sta     $4347
        sta     $4357
        sta     $4367
        sta     $4377
        lda     #$f0
        tsb     $43
        rtl

; ------------------------------------------------------------------------------

; m7a & m7d hdma table
_d4cbe7:
@cbe7:  .byte   $fb
        .word   $0604
        .byte   $e5
        .word   $06f8
        .byte   $00

; m7b hdma table
_d4cbee:
@cbee:  .byte   $fb
        .word   $07c6
        .byte   $e5
        .word   $08ba
        .byte   $00

; m7c hdma table
_d4cbf5:
@cbf5:  .byte   $fb
        .word   $0988
        .byte   $e5
        .word   $0a7c
        .byte   $00

; ------------------------------------------------------------------------------

; [ init mode 7 hdma (credits, airship above clouds) ]

_d4cbfc:
@cbfc:  lda     #$43
        sta     $4310
        sta     $4320
        lda     #$42
        sta     $4340
        sta     $4350
        sta     $4360
        sta     $4370
        lda     #<hBG1HOFS  ; channel #1 destination = $210d, $210e (bg1 hscroll, vscroll)
        sta     $4311
        lda     #<hM7X      ; channel #2 destination = $211f, $2120 (center x, y)
        sta     $4321
        lda     #<hM7A      ; channel #4 destination = $211b (m7a)
        sta     $4341
        inc                 ; channel #5 destination = $211c (m7b)
        sta     $4351
        inc                 ; channel #6 destination = $211d (m7c)
        sta     $4361
        inc                 ; channel #7 destination = $211e (m7d)
        sta     $4371
        ldy     #.loword(_d4cd3a)
        sty     $4312
        ldy     #.loword(_d4cd41)
        sty     $4322
        ldy     #.loword(_d4cd25)
        sty     $4342
        ldy     #.loword(_d4cd2c)
        sty     $4352
        ldy     #.loword(_d4cd33)
        sty     $4362
        ldy     #.loword(_d4cd25)
        sty     $4372
        lda     #^*
        sta     $4314
        sta     $4324
        sta     $4344
        sta     $4354
        sta     $4364
        sta     $4374
        lda     #$00
        sta     $4347
        sta     $4357
        sta     $4367
        sta     $4377
        lda     #$7e
        sta     $4317
        sta     $4327
        lda     #$04
        sta     $4330
        lda     #<hCGSWSEL
        sta     $4331
        ldy     #.loword(FixedColorHDMATbl)
        sty     $4332
        lda     #^FixedColorHDMATbl
        sta     $4334
        sta     $4337
        lda     #$fe
        tsb     $43
        rtl

; ------------------------------------------------------------------------------

; fixed color hdma table
FixedColorHDMATbl:
@cc98:  .byte   $63,$80,$01,$e0,$00
        .byte   $01,$80,$01,$e1,$00
        .byte   $01,$80,$01,$e2,$00
        .byte   $01,$80,$01,$e3,$00
        .byte   $01,$80,$01,$e4,$00
        .byte   $01,$80,$01,$e5,$00
        .byte   $01,$80,$01,$e6,$00
        .byte   $01,$80,$01,$e7,$00
        .byte   $01,$80,$01,$e8,$00
        .byte   $01,$80,$01,$e9,$00
        .byte   $01,$80,$01,$ea,$00
        .byte   $01,$80,$01,$eb,$00
        .byte   $01,$80,$01,$ec,$00
        .byte   $02,$80,$01,$ee,$00
        .byte   $03,$80,$01,$f0,$00
        .byte   $03,$80,$01,$f3,$00
        .byte   $02,$80,$01,$f6,$00
        .byte   $01,$80,$01,$fa,$00
        .byte   $01,$80,$01,$fb,$00
        .byte   $01,$80,$01,$fc,$00
        .byte   $01,$80,$01,$ef,$00
        .byte   $01,$80,$01,$ec,$00
        .byte   $01,$80,$01,$ea,$00
        .byte   $01,$80,$01,$e6,$00
        .byte   $01,$80,$01,$e3,$00
        .byte   $02,$80,$01,$e2,$00
        .byte   $03,$80,$01,$e1,$00
        .byte   $01,$82,$81,$e0,$00
        .byte   $00

; ------------------------------------------------------------------------------

; m7a & m7d hdma table
_d4cd25:
@cd25:  .byte   $7c
        .word   $0600
        .byte   $e4
        .word   $06f8
        .byte   $00

; m7b hdma table
_d4cd2c:
@cd2c:  .byte   $7c
        .word   $07c2
        .byte   $e4
        .word   $08ba
        .byte   $00

; m7c hdma table
_d4cd33:
@cd33:  .byte   $7c
        .word   $0984
        .byte   $e4
        .word   $0a7c
        .byte   $00

; bg1 scroll hdma table
_d4cd3a:
@cd3a:  .byte   $7c
        .word   $b68d
        .byte   $64
        .word   $b691
        .byte   $00

; center x,y position hdma table
_d4cd41:
@cd41:  .byte   $7c
        .word   $b695
        .byte   $64
        .word   $b699
        .byte   $00

; ------------------------------------------------------------------------------

; [ init menu hardware registers ]

InitHWRegsMenu:
@cd48:  lda     #$01
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$09
        sta     hBGMODE
        lda     #$00
        sta     hMOSAIC
        lda     #$03
        sta     hBG1SC
        lda     #$13
        sta     hBG2SC
        lda     #$43
        sta     hBG3SC
        lda     #$65
        sta     hBG12NBA
        lda     #$66
        sta     hBG34NBA
        clr_a
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
        lda     #$80
        sta     hVMAINC
        clr_ax
        stx     hVMADDL
        sta     hCGADD
        lda     #$3f
        sta     hW12SEL
        lda     #$33
        sta     hW34SEL
        sta     hWOBJSEL
        lda     #$08
        sta     hWH0
        sta     hWH2
        lda     #$f7
        sta     hWH1
        sta     hWH3
        clr_a
        sta     hTSW
        sta     hSETINI
        sta     hWBGLOG
        sta     hWOBJLOG
        lda     #$1f
        sta     hTM
        lda     #$0f
        sta     hTS
        lda     #$0f
        sta     hTMW
        rtl

; ------------------------------------------------------------------------------

; [ init menu ram ]

InitMenuRAM:
@cdf3:  clr_ay
        sty     $bb         ; clear mode7 registers
        sty     $bd
        sty     $bf
        sty     $c1
        sty     $b7
        sty     $b9
        sty     $06         ; clear controller buttons
        sty     $08
        sty     $0c
        sty     $0a
        sty     $97         ;
        sty     $2b         ; clear current task code pointer
        sta     $43         ; disable hdma
        sta     $26         ; clear menu/cinematic state
        sta     $25         ; clear main menu selection
        sta     $b4         ; use inverse credits palette
        sta     $b5         ; clear mosaic register
        sta     $28         ; clear current selection
        sta     $29         ; clear high byte of bg data
        sta     $60         ; clear portrait task data pointers
        sta     $61
        sta     $62
        sta     $63
        sta     $46         ; clear cursor/scrolling flags
        sta     $66         ; clear current saved game slot
        sta     $ae         ; clear current sound effect
        lda     #$ff
        sta     $86         ; clear cursor positions
        sta     $88
        sta     $8a
        sta     $8c
        lda     #$05        ;
        sta     $45
        sty     $1b         ; dma 1 destination = $0000 vram
        ldy     #$4000      ; dma 2 destination = $4000 vram
        sty     $14
        ldy     #$7849      ; dma 2 source = $7e7849 (bg3 data)
        sty     $16
        lda     #$7e
        sta     $18
        sta     $1f
        ldy     #$1000      ; dma 1 & 2 size = $1000
        sty     $12
        sty     $19
        lda     #$0c        ;
        sta     $b6
        rtl

; ------------------------------------------------------------------------------

; [  ]

_d4ce55:
@ce55:  lda     #$70
        sta     $7e9d89
        sta     $7e9d8b
        lda     #$11
        sta     $7e9d8a
        sta     $7e9d8c
        stz     $4310
        lda     #$2c
        sta     $4311
        ldy     #$9d89
        sty     $4312
        lda     #$7e
        sta     $4314
        lda     #$7e
        sta     $4317
        lda     #$02
        tsb     $43
        rtl

; ------------------------------------------------------------------------------

@ce86:  .byte   $70,$89,$9d
@ce89:  .byte   $70,$89,$9d

; ------------------------------------------------------------------------------

; [ init hardware registers (ending character roll) ]

InitHWRegsEnding:
@ce8c:  lda     #$03
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$09
        sta     hBGMODE
        lda     #$03
        sta     hBG1SC
        lda     #$11
        sta     hBG2SC
        lda     #$19
        sta     hBG3SC
        sta     hBG4SC
        lda     #$33
        sta     hBG12NBA
        lda     #$22
        sta     hBG34NBA
        jsr     InitEndingWindowMask
        stz     hCGSWSEL
        lda     #$e0
        sta     hCOLDATA
        lda     #$17
        sta     hTM
        lda     #$02
        sta     hTS
        lda     #$82
        sta     hCGSWSEL
        lda     #$d1
        sta     hCGADSUB
        rtl

; ------------------------------------------------------------------------------

; [ init hardware registers (ending credits) ]

InitHWRegsCredits:
@ced7:  lda     #$03
        sta     hOBJSEL
        ldx     $00
        stx     hOAMADDL
        lda     #$07
        sta     hBGMODE
        lda     #$58
        sta     hBG1SC
        lda     #$50
        sta     hBG2SC
        lda     #$7c
        sta     hBG3SC
        sta     hBG4SC
        lda     #$44
        sta     hBG12NBA
        lda     #$77
        sta     hBG34NBA
        jsr     InitEndingWindowMask
        stz     hM7SEL
        lda     #$13
        sta     hTM
        lda     #$10
        sta     hTS
        lda     #$e0
        sta     hCOLDATA
        lda     #$82
        sta     hCGSWSEL
        lda     #$81
        sta     hCGADSUB
        rtl

; ------------------------------------------------------------------------------

; [ init window settings ]

InitEndingWindowMask:
@cf22:  lda     #$33
        sta     hW12SEL
        sta     hW34SEL
        lda     #$08
        sta     hWH0
        sta     hWH2
        lda     #$f7
        sta     hWH1
        sta     hWH3
        rts

; ------------------------------------------------------------------------------

; [ save memory for mode 7 hdma data ]

PushMode7Vars:
@cf3b:  ldx     $00
@cf3d:  lda     $0600,x
        sta     $7f4000,x
        inx
        cpx     #$054c
        bne     @cf3d
        rtl

; ------------------------------------------------------------------------------

; [ restore memory for mode 7 hdma data ]

PopMode7Vars:
@cf4b:  ldx     $00
@cf4d:  lda     $7f4000,x
        sta     $0600,x
        inx
        cpx     #$054c
        bne     @cf4d
        rtl

; ------------------------------------------------------------------------------

end_fixed_block MenuCodeFar
