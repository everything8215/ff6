
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: floating_cont.asm                                                    |
; |                                                                            |
; | description: floating continent cutscene                                   |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

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
@6be5:  ldy     #.loword(FloatingContGfx)
        sty     $f3
        lda     #^FloatingContGfx
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
