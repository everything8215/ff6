
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/train.asm                                                      |
; |                                                                            |
; | description: magitek factory train routines                                |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

.include "gfx/battle_bg.inc"

.import RNGTbl

; ------------------------------------------------------------------------------

; [ execute magitek train ride command ]

ExecTrainCmd:
truck_control2:
@2326:  php
        shorta
        longi
        lda     $36
        beq     @2336       ; branch at end of script command
        cmp     #$20
        jne     @234f       ; continue script command
@2336:  longa_clc
        lda     #$0021
        sbc     $36
        sta     $58
        lda     $34         ; script pointer
        sta     $64
        jsr     _ee25f5       ; update magitek train ride script data
        longa_clc
        lda     $34         ; increment script pointer
        adc     #5
        sta     $34
@234f:  longa
        lda     $f0         ; event command
        and     #$00ff
        asl
        tax
        jmp     (.loword(TrainCmdTbl),x)

; ------------------------------------------------------------------------------

; [  ]

_ee235b:
@235b:  shorta
        lda     #$00
        pha
        plb
        stz     $60
        ldx     $36
        stx     $38
        lda     $7f0b78,x   ; pitch data 2
        clc
        adc     #$28
        sta     $58
        lda     #$32
        sec
        sbc     $58
        bpl     @237c
        neg_a
        inc     $60
@237c:  sta     hWRMPYA
        lda     $7f0b38,x   ; pitch data 1
        sta     $5c
        ldy     #$0018
@2388:  tyx
        lda     f:_ee29d2+$27,x
        sta     hWRMPYB
        ldx     $38
        lda     $7f0b38,x   ; pitch data 1
        sec
        sbc     $5c
        sta     $5e
        lda     $60
        beq     @23a7
        lda     #$ff
        eor     hRDMPYH
        inc
        bra     @23aa
@23a7:  lda     hRDMPYH
@23aa:  sec
        sbc     $5e
        clc
        adc     $58
        sta     $7f0af8,x
        txa
        inc
        and     #$3f
        sta     $38
        tax
        beq     @23c1
        cmp     #$20
        bne     @23ca
@23c1:  lda     $7f0b38,x   ; pitch data 1
        sec
        sbc     $5e
        sta     $5c
@23ca:  dey
        bne     @2388
        stz     $60
        ldx     $36
        stx     $38
        lda     $7f0bb8,x   ; yaw data
        bpl     @23de
        neg_a
        inc     $60
@23de:  sta     hWRMPYA
        ldy     #$0000
@23e4:  tyx
        lda     $7f0bf8,x   ; yaw multiplier data ???
        bpl     @23f0
        neg_a
        dec     $60
@23f0:  sta     hWRMPYB
        lda     $38
        tax
        inc
        and     #$3f
        sta     $38
        lda     $60
        beq     @2407
        lda     #$ff
        eor     hRDMPYH
        inc
        bra     @240a
@2407:  lda     hRDMPYH
@240a:  clc
        adc     #$40
        sta     $7f0ab8,x
        iny
        cpy     #$0018
        bne     @23e4
        ldy     #$0016      ; 22 layers
        sty     $66         ; $66 = layer counter
        longa_clc
        lda     $36
        adc     #$0017
        and     #$003f
        sta     $38
        shorta
        ldx     #$01e0      ; $7f01e0 (tile data)
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
@2435:  shortai
        ldx     $38
        lda     $7f0ab8,x
        sta     $58
        lda     $7f0af8,x
        sta     $5a
        ldx     $66
        lda     f:_ee29d2-1,x
        sta     hWRMPYA
        ldx     $38
        longai
        lda     $7f0c18,x   ; background data
        and     #$00ff
        xba
        lsr3
        sta     $6a
        lsr
        clc
        adc     $6a
        tax
        ldy     #$000c      ; 12 tiles
@2467:  longa
        lda     f:_ee2b32,x
        beq     @2475       ; branch if tile is unused
        lda     f:_ee2b32+2,x
        bra     @2486
@2475:  shorta
        stz     hWMDATA       ; clear tile
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        jmp     @24e5
@2486:  shorta_sec
        stz     $5c
        lda     f:_ee2b32,x   ; x position
        sbc     $58
        bpl     @2497
        neg_a
        inc     $5c
@2497:  sta     hWRMPYB
        lda     $5c
        beq     @24a6
        lda     #$ff
        eor     hRDMPYH
        inc
        bra     @24a9
@24a6:  lda     hRDMPYH
@24a9:  clc
        adc     $58
        sta     hWMDATA
        stz     $5c
        lda     f:_ee2b32+1,x   ; y position
        sec
        sbc     $5a
        bpl     @24bf
        neg_a
        inc     $5c
@24bf:  sta     hWRMPYB
        lda     $5c
        beq     @24ce
        lda     #$ff
        eor     hRDMPYH
        inc
        bra     @24d1
@24ce:  lda     hRDMPYH
@24d1:  clc
        adc     $5a
        sta     hWMDATA
        lda     f:_ee2b32+2,x   ; tile index
        sta     hWMDATA
        lda     f:_ee2b32+3,x
        sta     hWMDATA
@24e5:  inx4                 ; next tile
        dey
        jne     @2467
        lda     $38         ; next layer
        dec
        and     #$3f
        sta     $38
        dec     $66
        jne     @2435
        lda     $11f6
        bit     #$80
        beq     @2577       ; branch if not rotating
        lda     $36         ; increment frame counter
        inc
        sta     $36
        lda     $73         ; rotation frame counter
        bne     @252c       ; branch if it hasn't reached zero
        clr_a
        lda     a:$0074       ; random number counter for rotation
        inc     a:$0074
        tax
        lda     f:RNGTbl,x
        bmi     @251f       ; 50% chance to branch
        lda     #$00
        bra     @2521
@251f:  lda     #$ff
@2521:  sta     $2c
        lda     f:RNGTbl,x
        and     #$3f
        inc
        sta     $73         ; rotation frame counter = [1..64]
@252c:  dec     $73         ; decrement rotation frame counter
        lda     $2c
        beq     @2546       ; 50% chance to branch (random)
        longa
        sec
        lda     $29         ; decrease rotation speed
        sbc     #$0002
        sta     $29
        shorta
        lda     $2b
        sbc     #$00
        sta     $2b
        bra     @2557
@2546:  longa_clc
        lda     $29         ; increase rotation speed
        adc     #$0002
        sta     $29
        shorta
        lda     $2b
        adc     #$00
        sta     $2b
@2557:  lda     $3a         ; add to rotation angle
        clc
        adc     $29
        sta     $3a
        longa
        lda     $3b
        adc     $2a
        bmi     @2571       ; branch if negative
        cmp     #360
        bcc     @2575       ; branch if less than 360 degrees
        sec
        sbc     #360      ; subtract 360 degrees
        bra     @2575
@2571:  clc
        adc     #360      ; add 360 degrees
@2575:  sta     $3b
@2577:  longa
        lda     $3b         ; rotation angle
        cmp     #180
        bcc     @2584       ; branch if less than 180 degrees
        sec
        sbc     #180      ; subtract 180 degrees
@2584:  tax
        lda     f:WorldSineTbl,x   ; sine table
        and     #$00ff
        sta     $58
        lda     f:WorldSineTbl+90,x   ; cosine table
        and     #$00ff
        sta     $5a
        lda     $3b
        cmp     #180
        bcs     @25af       ; branch if > 180 degrees
        cmp     #90
        bcs     @25a5       ; branch if > 90 degrees
        bra     @25ce
@25a5:  lda     $5a
        neg_a
        sta     $5a
        bra     @25ce
@25af:  cmp     #270
        bcs     @25c6       ; branch if > 270 degrees
        lda     $58
        neg_a
        sta     $58
        lda     $5a
        neg_a
        sta     $5a
        bra     @25ce
@25c6:  lda     $58
        neg_a
        sta     $58
@25ce:  lda     $5a
        asl
        clc
        adc     $5a
        sta     f:$00003d     ; m7a
        lda     $58
        asl
        clc
        adc     $58
        sta     f:$00003f     ; m7b
        neg_a
        sta     f:$000041     ; m7c
        shorta
        lda     $36
        inc
        and     #$3f
        sta     $36
        plp
        rts

; ------------------------------------------------------------------------------

; [ update magitek train ride script data ]

_ee25f5:
course_set:
@25f5:  php
        longa
        ldx     $64
        lda     f:_ee2ef2,x   ; pitch type
        and     #$00ff
        xba
        lsr3
        sta     $5a
        clc
        adc     #.loword(_ee2692)      ; $ee2692 (pitch data 1)
        tax
        lda     $58
        clc
        adc     #$0b38
        tay
        lda     #$001f      ; size = $0020
        mvn     #^_ee2692,#$7f
        lda     $5a
        clc
        adc     #.loword(_ee2832)      ; $ee2832 (pitch data 2)
        tax
        lda     $58
        clc
        adc     #$0b78
        tay
        lda     #$001f      ; size = $0020
        mvn     #^_ee2832,#$7f
        ldx     $64
        lda     f:_ee2ef2+1,x   ; yaw type
        and     #$00ff
        xba
        lsr3
        clc
        adc     #.loword(_ee2a32)      ; $ee2a32 (yaw data)
        tax
        lda     $58
        clc
        adc     #$0bb8
        tay
        lda     #$001f      ; size = $0020
        mvn     #^_ee2a32,#$7f
        ldx     $64
        lda     f:_ee2ef2+2,x   ; background type
        and     #$00ff
        xba
        lsr3
        clc
        adc     #.loword(_ee2a92)      ; $ee2a92 (background data)
        tax
        lda     $58
        clc
        adc     #$0c18
        tay
        lda     #$001f      ; size = $0020
        mvn     #^_ee2a92,#$7f
        ldx     $64
        lda     f:_ee2ef2+3,x   ; ??? type (always zero)
        and     #$00ff
        xba
        lsr3
        clc
        adc     #.loword(_ee2a12)      ; yaw multiplier data ???
        tax
        ldy     #$0bf8
        lda     #$001f      ; size = $0020
        mvn     #^_ee2a12,#$7f
        shorta
        ldx     $64
        lda     f:_ee2ef2+4,x   ; magitek train ride command
        sta     $f0
        plp
        rts

; ------------------------------------------------------------------------------

; pitch data 1 (13 items, 32 bytes each)
_ee2692:
sindat:
@2692:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $f4,$f4,$f4,$f4,$f4,$f5,$f6,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$09,$0a,$0b,$0b,$0b,$0b
        .byte   $0c,$0b,$0b,$0b,$0b,$0a,$09,$09,$08,$07,$06,$05,$04,$03,$02,$01
        .byte   $ff,$fe,$fd,$fc,$fb,$fa,$f9,$f8,$f7,$f6,$f6,$f5,$f4,$f4,$f4,$f4
        .byte   $f4,$f4,$f4,$f4,$f4,$f5,$f6,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe
        .byte   $00,$01,$03,$04,$06,$07,$09,$0a,$0c,$0e,$0f,$11,$12,$14,$15,$17
        .byte   $17,$15,$14,$12,$11,$0f,$0e,$0c,$0a,$09,$07,$06,$04,$03,$01,$00
        .byte   $fe,$fd,$fc,$fb,$fa,$f9,$f8,$f7,$f6,$f6,$f5,$f4,$f4,$f4,$f4,$f4
        .byte   $e9,$eb,$ec,$ee,$ef,$f1,$f2,$f4,$f5,$f7,$f8,$fa,$fb,$fd,$fe,$00
        .byte   $01,$03,$04,$06,$07,$09,$0a,$0c,$0d,$0f,$10,$12,$13,$15,$16,$18
        .byte   $17,$15,$14,$12,$11,$0f,$0e,$0c,$0b,$09,$08,$06,$05,$03,$02,$00
        .byte   $ff,$fd,$fc,$fa,$f9,$f8,$f7,$f5,$f4,$f2,$f1,$ef,$ee,$ec,$eb,$e9
        .byte   $e9,$eb,$ec,$ee,$ef,$f1,$f2,$f4,$f6,$f7,$f9,$fa,$fc,$fd,$ff,$00
        .byte   $02,$03,$04,$05,$06,$07,$08,$09,$0a,$0a,$0b,$0c,$0c,$0c,$0c,$0c
        .byte   $0c,$0c,$0c,$0c,$0c,$0b,$0a,$0a,$09,$08,$07,$06,$05,$04,$03,$02
        .byte   $00,$ff,$fd,$fc,$fa,$f9,$f7,$f6,$f4,$f2,$f1,$ef,$ee,$ec,$eb,$e9
        .byte   $f4,$f4,$f4,$f4,$f4,$f4,$f4,$f4,$f4,$f5,$f5,$f5,$f6,$f6,$f6,$f7
        .byte   $f7,$f7,$f8,$f8,$f9,$f9,$fa,$fa,$fb,$fb,$fc,$fd,$fd,$fe,$fe,$ff
        .byte   $00,$00,$01,$01,$02,$02,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08
        .byte   $08,$08,$09,$09,$09,$0a,$0a,$0a,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
        .byte   $0c,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$0a,$0a,$09,$09,$09,$08
        .byte   $08,$08,$07,$07,$06,$06,$05,$05,$04,$04,$03,$02,$02,$01,$01,$00
        .byte   $ff,$ff,$fe,$fe,$fd,$fd,$fc,$fb,$fb,$fa,$fa,$f9,$f9,$f8,$f8,$f7
        .byte   $f7,$f7,$f6,$f6,$f6,$f5,$f5,$f5,$f4,$f4,$f4,$f4,$f4,$f4,$f4,$f4

; ------------------------------------------------------------------------------

; pitch data 2 (13 items, 32 bytes each)
_ee2832:
cosdat:
@2832:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $ff,$01,$03,$04,$06,$07,$08,$0a,$0b,$0c,$0d,$0e,$0e,$0f,$0f,$0f
        .byte   $0f,$0f,$0f,$0f,$0e,$0e,$0d,$0c,$0b,$0a,$08,$07,$06,$04,$03,$01
        .byte   $ff,$fe,$fc,$fb,$f9,$f8,$f7,$f5,$f4,$f3,$f2,$f1,$f1,$f0,$f0,$f0
        .byte   $f0,$f0,$f0,$f0,$f1,$f1,$f2,$f3,$f4,$f5,$f7,$f8,$f9,$fb,$fc,$fe
        .byte   $ff,$01,$03,$04,$06,$07,$08,$0a,$0b,$0c,$0d,$0e,$0e,$0f,$0f,$0f
        .byte   $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
        .byte   $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
        .byte   $f1,$f1,$f1,$f2,$f2,$f3,$f4,$f5,$f6,$f8,$f9,$fa,$fc,$fd,$ff,$01
        .byte   $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
        .byte   $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
        .byte   $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
        .byte   $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
        .byte   $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
        .byte   $0f,$0f,$0f,$0e,$0e,$0d,$0c,$0b,$0a,$08,$07,$06,$04,$03,$01,$ff
        .byte   $01,$ff,$fd,$fc,$fa,$f9,$f8,$f6,$f5,$f4,$f3,$f2,$f2,$f1,$f1,$f1
        .byte   $f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1,$f1
        .byte   $ff,$00,$01,$02,$03,$03,$04,$05,$06,$06,$07,$08,$08,$09,$0a,$0a
        .byte   $0b,$0b,$0c,$0c,$0d,$0d,$0e,$0e,$0e,$0f,$0f,$0f,$0f,$0f,$0f,$0f
        .byte   $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0e,$0e,$0e,$0d,$0d,$0c,$0c,$0b
        .byte   $0b,$0a,$0a,$09,$08,$08,$07,$06,$06,$05,$04,$03,$03,$02,$01,$00
        .byte   $ff,$ff,$fe,$fd,$fc,$fc,$fb,$fa,$f9,$f9,$f8,$f7,$f7,$f6,$f5,$f5
        .byte   $f4,$f4,$f3,$f3,$f2,$f2,$f1,$f1,$f1,$f0,$f0,$f0,$f0,$f0,$f0,$f0
        .byte   $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0,$f1,$f1,$f1,$f2,$f2,$f3,$f3,$f4
        .byte   $f4,$f5,$f5,$f6,$f7,$f7,$f8,$f9,$f9,$fa,$fb,$fc,$fc,$fd,$fe,$ff

; ------------------------------------------------------------------------------

; position multipliers (64 items, 1 bytes each)
_ee29d2:
reduce_rate:
@29d2:  .byte   $ff,$e0,$c0,$b0,$a0,$90,$80,$80,$70,$70,$65,$65,$59,$59,$59,$59
        .byte   $45,$45,$45,$45,$45,$45,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38
        .byte   $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$45,$45,$45,$45,$45,$45
        .byte   $59,$59,$59,$59,$65,$65,$70,$70,$80,$80,$90,$a0,$b0,$c0,$e0,$ff

; ------------------------------------------------------------------------------

; yaw multiplier data ??? (1 item, 32 bytes)
_ee2a12:
kyokuritu:
@2a12:  .byte   $fc,$00,$03,$07,$0a,$0d,$11,$14,$17,$1a,$1d,$20,$22,$25,$27,$29
        .byte   $2a,$2c,$2d,$2e,$2f,$2f,$2f,$2f,$2f,$2f,$2e,$2d,$2b,$2a,$28,$26

; ------------------------------------------------------------------------------

; yaw data (3 items, 32 bytes each)
;   0: straight
;   1: left turn
;   2: right turn
_ee2a32:
kyokup:
@2a32:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$0d,$19,$25,$31,$3c,$47,$51,$5b,$63,$6a,$71,$76,$7a,$7e,$7f
        .byte   $7f,$7f,$7e,$7a,$76,$71,$6a,$63,$5a,$51,$47,$3c,$31,$25,$19,$0d
        .byte   $00,$f3,$e7,$db,$cf,$c4,$b9,$af,$a5,$9d,$96,$8f,$8a,$85,$82,$81
        .byte   $80,$81,$82,$86,$8a,$8f,$96,$9d,$a6,$af,$b9,$c4,$cf,$db,$e7,$f4

; ------------------------------------------------------------------------------

; background data (5 items, 32 bytes each)
;   0: pipes w/ more beams
;   1: pipes w/ fewer beams
;   2: no pipes
;   3: split track w/ more walls
;   4: split track w/ fewer walls
_ee2a92:
chrset:
@2a92:  .byte   $03,$01,$02,$03,$05,$01,$02,$03,$04,$01,$02,$04,$03,$01,$02,$05
        .byte   $03,$01,$02,$04,$03,$01,$02,$04,$05,$01,$02,$05,$05,$01,$02,$03
        .byte   $05,$03,$04,$01,$02,$03,$00,$03,$00,$03,$04,$01,$02,$00,$03,$05
        .byte   $05,$05,$05,$03,$02,$02,$02,$03,$03,$04,$05,$01,$02,$03,$00,$03
        .byte   $00,$01,$00,$02,$00,$02,$00,$00,$00,$01,$00,$02,$00,$01,$00,$00
        .byte   $02,$01,$00,$02,$00,$00,$00,$00,$00,$01,$00,$02,$00,$00,$02,$00
        .byte   $06,$06,$07,$07,$08,$08,$09,$09,$0a,$0a,$0b,$0b,$0c,$0c,$0d,$0d
        .byte   $0e,$0e,$0f,$0f,$10,$10,$11,$11,$12,$12,$13,$13,$12,$00,$00,$12
        .byte   $00,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; tile data (20 items, 12x4 bytes each)
; 5 left wall tiles, 5 right wall tiles, 1 ceiling tile, 1 rail tile
_ee2b32:
truck_spset:
@2b32:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$68,$50,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$64,$20,$98,$01,$64,$30,$b0,$01,$64,$40,$c8,$01
        .byte   $64,$50,$e0,$01,$64,$60,$f8,$01,$00,$00,$00,$00,$40,$68,$68,$01
        .byte   $28,$20,$78,$00,$28,$30,$90,$00,$28,$40,$a8,$00,$28,$50,$c0,$00
        .byte   $58,$20,$10,$02,$58,$30,$28,$02,$58,$40,$40,$02,$58,$50,$58,$02
        .byte   $38,$30,$38,$01,$48,$30,$38,$01,$00,$00,$00,$00,$40,$68,$50,$01
        .byte   $2c,$50,$d8,$00,$2c,$60,$f0,$00,$54,$50,$70,$02,$54,$60,$88,$02
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$68,$68,$01
        .byte   $30,$58,$08,$01,$50,$58,$a0,$02,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$68,$50,$01
        .byte   $40,$18,$20,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$44,$68,$50,$01,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$48,$68,$50,$01,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$4c,$68,$50,$01,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$50,$68,$50,$01,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$54,$68,$50,$01,$40,$68,$68,$01
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$58,$68,$50,$01,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$5c,$68,$50,$01,$40,$68,$68,$01
        .byte   $50,$20,$98,$01,$50,$30,$b0,$01,$50,$40,$c8,$01,$50,$50,$e0,$01
        .byte   $50,$60,$f8,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$60,$68,$50,$01,$40,$68,$68,$01
        .byte   $50,$20,$98,$01,$50,$30,$b0,$01,$50,$40,$c8,$01,$50,$50,$e0,$01
        .byte   $50,$60,$f8,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$64,$68,$50,$01,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$68,$68,$50,$01,$40,$68,$68,$01
        .byte   $50,$20,$98,$01,$50,$30,$b0,$01,$50,$40,$c8,$01,$50,$50,$e0,$01
        .byte   $50,$60,$f8,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$6c,$68,$50,$01,$40,$68,$68,$01
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$70,$68,$50,$01,$40,$68,$68,$01
        .byte   $50,$20,$98,$01,$50,$30,$b0,$01,$50,$40,$c8,$01,$50,$50,$e0,$01
        .byte   $50,$60,$f8,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$74,$68,$50,$01,$40,$68,$68,$01
        .byte   $1c,$20,$00,$00,$1c,$30,$18,$00,$1c,$40,$30,$00,$1c,$50,$48,$00
        .byte   $1c,$60,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$68,$68,$01

; ------------------------------------------------------------------------------

; magitek train ride script (52 items, 5 bytes each)
;   $00: pitch
;   $01: yaw
;   $02: background
;   $03: yaw multiplier ??? (always zero)
;   $04: command
_ee2ef2:
trcourse:
@2ef2:  .byte   $01,$00,$00,$00,$00
        .byte   $08,$02,$02,$00,$00
        .byte   $04,$01,$01,$00,$00
        .byte   $00,$00,$01,$00,$e0
        .byte   $02,$00,$01,$00,$00
        .byte   $08,$01,$03,$00,$00
        .byte   $06,$01,$02,$00,$00
        .byte   $04,$02,$00,$00,$00
        .byte   $03,$00,$01,$00,$00
        .byte   $05,$00,$01,$00,$e1
        .byte   $07,$00,$00,$00,$00
        .byte   $01,$00,$00,$00,$00
        .byte   $03,$01,$01,$00,$00
        .byte   $0a,$02,$02,$00,$00
        .byte   $00,$00,$01,$00,$e0
        .byte   $01,$00,$01,$00,$00
        .byte   $00,$01,$03,$00,$00
        .byte   $03,$00,$00,$00,$00
        .byte   $05,$01,$02,$00,$00
        .byte   $07,$00,$03,$00,$00
        .byte   $08,$00,$01,$00,$00
        .byte   $02,$01,$00,$00,$00
        .byte   $01,$00,$00,$00,$00
        .byte   $09,$02,$01,$00,$00
        .byte   $01,$01,$02,$00,$e1
        .byte   $03,$02,$01,$00,$00
        .byte   $04,$00,$03,$00,$00
        .byte   $05,$00,$02,$00,$00
        .byte   $07,$02,$00,$00,$00
        .byte   $05,$01,$02,$00,$00
        .byte   $07,$00,$01,$00,$00
        .byte   $03,$01,$01,$00,$e1
        .byte   $00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00
        .byte   $01,$00,$01,$00,$00
        .byte   $02,$01,$02,$00,$e2
        .byte   $03,$00,$01,$00,$00
        .byte   $04,$01,$01,$00,$ff
        .byte   $05,$02,$01,$00,$00
        .byte   $06,$01,$00,$00,$00
        .byte   $07,$00,$02,$00,$00

trcourse_exit:
        .byte   $00,$00,$00,$00,$00
        .byte   $02,$01,$00,$00,$00
        .byte   $00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00
        .byte   $03,$02,$01,$00,$00
        .byte   $04,$00,$03,$00,$00
        .byte   $05,$00,$02,$00,$00
        .byte   $00,$00,$00,$00,$ff
        .byte   $00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; magitek train ride command jump table
TrainCmdTbl:
@2ff6:  .addr   TrainCmd_00
.repeat 63
        .addr   TrainCmd_01
.endrep
.repeat 64
        .addr   TrainCmd_40
.endrep
.repeat 32
        .addr   TrainCmd_80
.endrep
.repeat 32
        .addr   TrainCmd_a0
.endrep
.repeat 32
        .addr   TrainCmd_00
.endrep
        .addr   TrainCmd_e0
        .addr   TrainCmd_e1
        .addr   TrainCmd_e2
.repeat 13
        .addr   TrainCmd_00
.endrep
        .addr   TrainCmd_f0
        .addr   TrainCmd_f1
        .addr   TrainCmd_f2
        .addr   TrainCmd_f3
.repeat 11
        .addr   TrainCmd_00
.endrep
        .addr   TrainCmd_ff

; ------------------------------------------------------------------------------

; [ magitek train ride command: no effect ]

TrainCmd_00:
@31f6:  jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $01-$3f: conditional branch ]

; b0: number of commands to branch forward (multiply by 5)

TrainCmd_01:
        .a16
@31f9:  lda     $e7         ; change this to $07 to check if the right button is down
        bit     #$0001
        beq     @3210       ; branch if ??? (turning left or right?)
        lda     $f0
        and     #$00ff
        sta     $6a
        asl2
        clc
        adc     $6a
        adc     $34
        sta     $34
@3210:  shorta
        stz     $f0
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $40-$7f: branch ]

; b0: number of commands to branch forward (multiply by 5)

TrainCmd_40:
        .a16
@3217:  lda     $f0
        and     #$00ff
        sec
        sbc     #$003f
        sta     $6a
        asl2
        clc
        adc     $6a
        adc     $34
        sta     $34
        shorta
        stz     $f0
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $80-$9f:  ]

; b0: 100aaabb
;     a: rotation angle (degrees)
;     b: rotation speed (degrees per frame)

TrainCmd_80:
@3232:  clr_a
        shorta_sec
        lda     $f0
        and     #$03
        inc
        sta     $29         ; rotation speed
        stz     $2a
        lda     $f0
        lsr2
        and     #$07
        inc
        asl
        sta     $73         ; rotation frame counter
        shorta
        stz     $f0
        jmp     _ee235b

; ------------------------------------------------------------------------------

; rotation angles
thcntdt:
_ee324f:
@324f:  .byte   $02,$04,$06,$1e,$2d,$3c,$4b,$5a

; ------------------------------------------------------------------------------

; [ magitek train ride command $a0-$bf:  ]

; b0: 101aaabb
;     a: rotation angle (pointer to data above)
;     b: rotation speed (degrees per frame)

TrainCmd_a0:
@3257:  clr_a
        shorta_sec
        lda     $f0
        and     #$03
        not_a
        sta     $29         ; rotation speed
        lda     #$ff
        sta     $2a
        lda     $f0
        lsr2
        and     #$07
        tax
        lda     f:_ee324f,x   ; rotation frame counter
        sta     $73
        shorta
        stz     $f0
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $e0: battle 1 ]

TrainCmd_e0:
        .a16
@327a:  lda     $1f6d       ; update random number
        and     #$00ff
        tax
        lda     f:RNGTbl,x   ; random number table
        sta     $64
        lda     #$0029      ; event battle #$29
        asl2
        tax
        shorta
        inc     $1f6d       ; increment random number
        lda     $64
        cmp     #$c0
        bcc     @329a       ; 75% chance to branch
        inx2                 ; 25% chance to choose next battle
@329a:  lda     f:EventBattleGroup,x
        sta     f:$0011e0
        lda     f:EventBattleGroup+1,x
        sta     f:$0011e1
        lda     #BATTLE_BG::MAGITEK_TRAIN
        sta     f:$0011e2
        clr_a
        sta     f:$0011e3
        lda     #$08        ; continue current music
        sta     f:$0011e4
        lda     f:$0011f6     ; enable battle
        ora     #$02
        sta     f:$0011f6
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $e1: battle 2 ]

TrainCmd_e1:
        .a16
@32c8:  lda     $1f6d
        and     #$00ff
        tax
        lda     f:RNGTbl,x
        sta     $64
        lda     #$0090      ; event battle #$90
        asl2
        tax
        shorta
        inc     $1f6d
        lda     $64
        cmp     #$c0
        bcc     @32e8
        inx2
@32e8:  lda     f:EventBattleGroup,x
        sta     f:$0011e0
        lda     f:EventBattleGroup+1,x
        sta     f:$0011e1
        lda     #BATTLE_BG::MAGITEK_TRAIN
        sta     f:$0011e2
        clr_a
        sta     f:$0011e3
        lda     #$08
        sta     f:$0011e4
        lda     f:$0011f6     ; enable battle
        ora     #$02
        sta     f:$0011f6
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $e2: boss battle ]

TrainCmd_e2:
        .a16
@3316:  lda     #$0049      ; event battle #$49 (number 128)
        asl2
        tax
        shorta
        lda     f:EventBattleGroup,x
        sta     f:$0011e0
        lda     f:EventBattleGroup+1,x
        sta     f:$0011e1
        lda     #$2c
        sta     f:$0011e2
        clr_a
        sta     f:$0011e3
        sta     f:$0011e4
        lda     f:$0011f6     ; enable battle
        ora     #$02
        sta     f:$0011f6
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $f0: unused ]

TrainCmd_f0:
@334a:  jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $f1: unused ]

TrainCmd_f1:
@334d:  jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $f2: unused ]

TrainCmd_f2:
@3350:  jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $f3: unused ]

TrainCmd_f3:
@3353:  jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $ff: end of script ]

TrainCmd_ff:
@3356:  shorta
        stz     $f0         ; clear script command
        stz     $22         ; clear target screen brightness
        longa
        inc     $19         ; enable fade out
        jmp     _ee235b

; ------------------------------------------------------------------------------
