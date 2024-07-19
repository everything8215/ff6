
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: cutscene/cutscene_main.asm                                           |
; |                                                                            |
; | description: cutscene program                                              |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"
.include "code_ext.inc"

; ------------------------------------------------------------------------------

.include "gfx/map_gfx.inc"

; ------------------------------------------------------------------------------

.import MapGfxPtrs, RuinCutsceneGfx, TitleOpeningGfx, RNGTbl

; ------------------------------------------------------------------------------

.include "the_end.asm"

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
@680c:  jsr     DecompCutsceneProg
        jml     TitleScreen_ext2

; ------------------------------------------------------------------------------

OpeningCredits:
@6813:  jsr     DecompCutsceneProg
        jml     OpeningCredits_ext2

; ------------------------------------------------------------------------------

FloatingContScene:
@681a:  jsr     DecompCutsceneProg
        jml     FloatingContScene_ext2

; ------------------------------------------------------------------------------

WorldOfRuinScene:
@6821:  jsr     DecompCutsceneProg
        jml     WorldOfRuinScene_ext2

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
        ldx     #0
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

.segment "cutscene_lz"

; c2/686c
CutsceneProg:

; ------------------------------------------------------------------------------

.segment "cutscene_wram"

TitleScreen_ext2:
@5000:  jmp     TitleMain

OpeningCredits_ext2:
@5003:  jmp     OpeningMain

FloatingContScene_ext2:
@5006:  jmp     FloatingContMain

WorldOfRuinScene_ext2:
@5009:  jmp     WorldOfRuinMain

; ------------------------------------------------------------------------------

        .include "title.asm"
        .include "opening.asm"
        .include "floating_cont.asm"
        .include "ruin.asm"

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
        not_a
        and     $04
        sta     $06
        ldy     $04
        sty     $08
        lda     f:hSTDCNTRL1L
        sta     $04
        shorta
        rts

; ------------------------------------------------------------------------------

; [ cutscene nmi ]

CutsceneNMI:
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

; [ cutscene irq ]

CutsceneIRQ:
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
        sta     hDMA0::ADDR_B
        lda     #$02
        sta     hDMA0::CTRL
        lda     #<hOAMDATA
        sta     hDMA0::HREG
        ldy     #$0300
        sty     hDMA0::ADDR
        ldy     #$0220
        sty     hDMA0::SIZE
        lda     #BIT_0
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
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldy     $12
        sty     hDMA0::ADDR
        lda     $14
        sta     hDMA0::ADDR_B
        ldy     $0e
        sty     hDMA0::SIZE
        lda     #BIT_0
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
        jmp     (.loword(FadePalTaskTbl),x)

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
        cpx     #0
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
        jmp     (.loword(DefaultAnimTaskTbl),x)

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
        longa_clc
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
.if !LANG_EN
        clr_ax
@7811:  sta     $3ea2,x
        inx4
        cpx     #$0020
        bne     @7811
.endif
        clr_ax
        lda     #$0100
@7888:  sta     $3dfc,x
        inx4
.if LANG_EN
        cpx     #$0104
.else
        cpx     #$00c4
.endif
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
        ldy     #$7930                  ; source = $7f7930 (flames tile layout, bg3)
        sty     $e7
        lda     #$7f
        sta     $e9
.if LANG_EN
        ldy     #$0200                  ; size = $0200
.else
        ldy     #$01c0                  ; size = $01c0
.endif
        sty     $eb
        ldy     #$1400                  ; set palette 5
        sty     $ed
        ldy     #$1900
        jsr     TfrVRAM
.if LANG_EN
        ldy     #$7b30                  ; source = $7f7b30 (flames graphics, bg3)
.else
        ldy     #$7af0
.endif
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$06b0                  ; size = $06b0
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$2000
        jsr     TfrVRAM
.if LANG_EN
        ldy     #$81e0                  ; source = $7f81e0 (flames tile layout, bg2)
.else
        ldy     #$81a0
.endif
        sty     $e7
        lda     #$7f
        sta     $e9
.if LANG_EN
        ldy     #$0200                  ; size = $0200
.else
        ldy     #$01c0                  ; size = $01c0
.endif
        sty     $eb
        ldy     #$0080
        sty     $ed
        ldy     #$1100
        jsr     TfrVRAM
        ldy     #$1bc0                  ; source = $7f1bc0 (intro tile layout, bg1)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$1800                  ; size = $1800
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$0000
        jsr     TfrVRAM
        ldy     #$33c0                  ; source $7f33c0 (intro graphics)
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$4200                  ; size = $4200
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$4000
        jsr     TfrVRAM
        clr_ax
        longa
        lda     f:MapGfxPtrs+MAP_GFX_SEALED_GATE_1*3,x
        clc
        adc     #.loword(MapGfx)
        sta     $e7
        inx2
        shorta
        lda     f:MapGfxPtrs+MAP_GFX_SEALED_GATE_1*3,x
        adc     #^MapGfx
        sta     $e9
        ldy     #$2000                  ; size = $2000
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$3000                  ; destination = $3000 (vram)
        jsr     TfrVRAM
.if LANG_EN
        ldy     #$83e0                  ; source = $7f83e0 (flames graphics, 4bpp)
.else
        ldy     #$8360
.endif
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0800                  ; size = $0800
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$2800
        jsr     TfrVRAM
        jsr     _7e7a33
.if LANG_EN
        ldy     #$8be0                  ; source = $7f8be0
.else
        ldy     #$8b60
.endif
        sty     $e7
        lda     #$7f
        sta     $e9
.if LANG_EN
        ldy     #$0200                  ; size = $0200
        sty     $eb
        ldy     #$0777
.else
        ldy     #$0140                  ; size = $0140
        sty     $eb
        ldy     #$0780
.endif
        sty     $ed
        ldy     #$0500
        jsr     TfrVRAM
.if LANG_EN
        ldy     #$8de0                  ; source = $7f8de0
.else
        ldy     #$8ce0
.endif
        sty     $e7
        lda     #$7f
        sta     $e9
.if LANG_EN
        ldy     #$1110                  ; size = $1110
.else
        ldy     #$0c00
.endif
        sty     $eb
        stz     $ed
        stz     $ee
.if LANG_EN
        ldy     #$6770
.else
        ldy     #$6800
.endif
        jsr     TfrVRAM
.if LANG_EN
        ldy     #$9ef0                  ; source = $7f9ef0
.else
        ldy     #$98e0
.endif
        sty     $e7
        lda     #$7f
        sta     $e9
.if LANG_EN
        ldy     #$0fb8                  ; size = $0fb8
.else
        ldy     #$1160
.endif
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
.if LANG_EN
        lda     #$0777
.else
        lda     #$0787
.endif
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

.if LANG_EN

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

.else

TitleTextSprite1:
@79fc:  .byte   13
        .byte   $a8,$00,$00,$31
        .byte   $88,$20,$04,$31
        .byte   $a8,$20,$08,$31
        .byte   $48,$00,$0c,$31
        .byte   $58,$00,$0e,$31
        .byte   $48,$20,$2c,$31
        .byte   $48,$10,$2e,$31
        .byte   $00,$40,$40,$31
        .byte   $10,$40,$42,$31
        .byte   $20,$40,$44,$31
        .byte   $30,$40,$46,$31
        .byte   $40,$40,$48,$31
        .byte   $18,$10,$4a,$31

TitleTextSprite2:
@7a31:  .byte   6
        .byte   $00,$00,$80,$33
        .byte   $10,$00,$82,$33
        .byte   $28,$00,$84,$33
        .byte   $38,$00,$86,$33
        .byte   $48,$00,$88,$33
        .byte   $58,$00,$8a,$33

.endif

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

.if !LANG_EN

@7ae5:  .word   $294A,$1448,$104A,$106A,$106C,$084E,$0451,$0453
        .word   $0056,$0078,$009A,$7C1F,$7C1F,$7C1F,$7C1F,$0821

.endif

_7e7b43:
.if LANG_EN

; intro/splash color palettes
@7b43:  .word   $0000,$0000,$24e8,$2086,$1063,$77bd,$4b5c,$2afa
        .word   $0000,$2676,$21d4,$15b2,$0000,$0ceb,$1088,$1063

.else

@7b05:  .word   $0000,$6F5A,$5AB5,$4610,$39CD,$1CE7,$0453,$66DE
        .word   $565B,$45B4,$352E,$0000,$0000,$0000,$0000,$0000

.endif

; dark palette
_7e7b63:
@7b63:  .word   $1063,$1063,$1063,$1063,$1063,$1063,$1063,$1063
        .word   $1063,$1063,$1063,$1063,$1063,$1063,$1063,$1063

; flames palette
FlamesPal:
@7b83:  .word   $1063,$6f9f,$575f,$46ff,$367e,$261e,$3219,$21bb
        .word   $159b,$1d76,$1136,$10f1,$08b0,$08ad,$088b,$0050

_7e7ba3:
.if LANG_EN
@7ba3:  .word   $0000,$1063,$77bd,$0000,$0000,$261e,$159b,$10f1
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
.else
        .word   $2108,$1063,$1063,$1063,$0000,$261e,$159b,$10f1
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
.endif

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
