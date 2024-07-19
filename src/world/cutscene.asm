
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/cutscene.asm                                                   |
; |                                                                            |
; | description: world map cutscene routines                                   |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

.import RNGTbl
.import VectorApproachGfx, VectorApproachTiles

; ------------------------------------------------------------------------------

; [ vector approach ]

VectorApproach:
@07c3:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$7e
        pha
        plb

; load palette
        lda     f:VectorApproachPalPtr
        sta     $d2
        lda     f:VectorApproachPalPtr+1
        sta     $d3
        lda     f:VectorApproachPalPtr+2
        sta     $d4
        ldy     #$0000
        longa
@07ec:  lda     [$d2],y
        sta     $e0e0,y
        iny2
        cpy     #$0020
        bne     @07ec

; load graphics and tilemap
        shorta
        clr_a
        pha
        plb
        ldx     #.loword(VectorApproachGfx)
        stx     $d2
        lda     #^VectorApproachGfx
        sta     $d4
        ldx     #$2000      ; destination = $7e2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropGfx
        ldx     #.loword(VectorApproachTiles)
        stx     $d2
        lda     #^VectorApproachTiles
        sta     $d4
        ldx     #$2000      ; destination = $7e2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropTiles
        lda     #$80
        sta     hVMAINC
        ldx     #$4800
        stx     hVMADDL
        ldy     #$0400
        ldx     #$0000
@083e:  stx     hVMDATAL
        dey
        bne     @083e

; set up gradient
        lda     #$7e
        pha
        plb
        jsr     HideGradientSprites
        longa
        ldx     #$0000
@0850:  shorta
        clr_a
        sta     $7e6007,x               ; clear fixed color hdma data
        sta     $7e6008,x
        longa
        inx2
        cpx     #$009c
        bne     @0850
        lda     #$0700
        sta     $58
        lda     #$0a00
        sta     $5a
@086e:  lda     $58
        sec
        sbc     #$0007
        sta     $58
        lda     $5a
        sec
        sbc     #$000a
        sta     $5a
        shorta
        lda     $59
        ora     #$20
        sta     $7e6007,x               ; fixed color hdma data
        lda     $5b
        ora     #$c0
        sta     $7e6008,x
        longa
        inx2
        cpx     #$01c0
        bne     @086e

; set up vehicle position and speed
        lda     #$0092
        sta     $85
        lda     #180
        sta     $73
        lda     #$3000
        sta     $8b
        sta     $91
        lda     #$1800
        sta     $8d
        lda     #$feff
        sta     $8f
        lda     #$3300
        sta     $2f
        lda     #$0980                  ; set animation counter (2432 frames)
        sta     $7e6b2e
        lda     #$f000
        sta     $64
        stz     $31
        lda     #$0000
        sta     $7eb660
        lda     #$0064
        sta     $7eb662
        lda     #$0003
        sta     $7eb664
        lda     #$0007
        sta     $7eb666
        lda     #$001e
        sta     $7eb668
        lda     #$008c
        sta     $7eb66a
        lda     #$0002
        sta     $7eb66c
        lda     #$0007
        sta     $7eb66e
        lda     #$0028
        sta     $7eb670
        lda     #$00a0
        sta     $7eb672
        lda     #$0004
        sta     $7eb674
        lda     #$0004
        sta     $7eb676
        lda     #$0019
        sta     $7eb678
        lda     #$006e
        sta     $7eb67a
        lda     #$0002
        sta     $7eb67c
        lda     #$0003
        sta     $7eb67e
        shorta
        clr_a
        sta     $7e6b0f
        sta     $7e6b13
        sta     $7e6b17
        sta     $7e6b1b
        sta     $7e6b1f
        sta     $7e6b23
        sta     $7e6b27
        sta     $7e6b2b
        lda     #$4e
        sta     $7e6b11
        sta     $7e6b15
        sta     $7e6b19
        sta     $7e6b1d
        sta     $7e6b21
        sta     $7e6b25
        sta     $7e6b29
        sta     $7e6b2d
        lda     #$65
        sta     $7e6b10
        lda     #$67
        sta     $7e6b14
        lda     #$8a
        sta     $7e6b18
        lda     #$8c
        sta     $7e6b1c
        lda     #$9a
        sta     $7e6b20
        lda     #$9b
        sta     $7e6b24
        lda     #$70
        sta     $7e6b28
        lda     #$71
        sta     $7e6b2c
        lda     $e9                     ; enable window and fixed color hdma
        ora     #$03
        sta     $e9
        clr_a
        pha
        plb
        stz     hW12SEL
        stz     hW34SEL
        lda     #$a0
        sta     hWOBJSEL
        lda     #$02
        sta     hTS
        stz     hTSW
@09c8:  cmp     hRDNMI                  ; init irq
        lda     hHVBJOY
        bit     #$80
        beq     @09c8
        lda     #$b1
        sta     hNMITIMEN
        ldx     #.loword(VectorApproachIRQ)
        stx     $1505
        lda     #^VectorApproachIRQ
        sta     $1507
        cli
@09e3:  lda     $24                     ; wait for vblank
        beq     @09e3
        stz     $24

; start of main loop
@09e9:  shorta
        ldx     #$004e
        stx     hVTIMEL
        ldx     #$00c8
        stx     hHTIMEL
        lda     #$12
        sta     hCGSWSEL
        lda     #$01
        sta     hBGMODE
        lda     #$03
        sta     hCGADSUB
        lda     $65
        sta     hBG2VOFS
        stz     hBG2VOFS
        longa_clc
        lda     $64
        adc     #$0007
        cmp     #$3000
        bpl     @0a1c
        sta     $64
@0a1c:  lda     $85
        sta     $87
        lda     $37
        clc
        adc     #$0060
        sta     $37
        lda     $39
        adc     #$0000
        sta     $39
        lda     $38
        and     #$0fff
        sta     $38
        lda     $40
        clc
        adc     #$0060
        sta     $40
        jsr     UpdateMode7Rot
        jsr     UpdateSpriteAnim
        jsr     DrawVehicleSprites
        jsr     UpdateTilemap256
        longa
        lda     $31
        inc
        and     #$0003
        sta     $31
        asl3
        tax
        lda     $7e6b0e,x
        sta     $58
        lda     $7e6b10,x
        sta     $5a
        lda     $31
        asl
        and     #$0002
        sta     $60
        phx
        jsr     UpdateSpotlightHDMA
        plx
        longa
        lda     $7e6b12,x
        sta     $58
        lda     $7e6b14,x
        sta     $5a
        lda     $31
        asl
        and     #$0002
        inc
        sta     $60
        jsr     UpdateSpotlightHDMA
        longa
        lda     $31
        asl3
        tax
        stz     $60
        lda     $7eb660,x
        clc
        adc     $7eb664,x
        cmp     #360
        bcc     @0aa6
        sbc     #360
@0aa6:  sta     $7eb660,x
        cmp     #180
        bcc     @0ab4
        sbc     #180
        dec     $60
@0ab4:  phx
        tax
        shorta
        lda     f:WorldSineTbl,x
        plx
        lsr3
        sta     $5c
        lda     $60
        bpl     @0acd
        lda     $5c
        neg_a
        sta     $5c
@0acd:  lda     $7eb662,x
        clc
        adc     $5c
        sta     $5d
        clc
        adc     $7eb666,x
        sta     $7e6b12,x
        lda     $5d
        sbc     $7eb666,x
        sta     $7e6b0e,x
        shorta
@0aeb:  lda     $24                     ; wait for vblank
        beq     @0aeb
        stz     $24

; update screen brightness
        lda     $23
        cmp     $22
        beq     @0afd
        bcs     @0afc
        inc
        bra     @0afd
@0afc:  dec
@0afd:  sta     $23
        cmp     #$00
        bne     @0b05
        lda     #$80
@0b05:  sta     hINIDISP
        longa
        lda     $7e6b2e                 ; decrement animation counter
        dec
        sta     $7e6b2e
        beq     @0b25
        cmp     #$0080
        bcs     @0b22
        lsr4
        shorta
        sta     $22
@0b22:  jmp     @09e9
@0b25:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hHDMAEN
        rts

; ------------------------------------------------------------------------------

; [ airship crash ]

AirshipCrash:
@0b30:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$01
        sta     hTM
        sta     hTS
        longa
        lda     #$8000
        sta     $7eb660
        lda     #$5000
        sta     $7eb662
        lda     #$feff
        sta     $8f
        lda     #$00e0
        sta     $87
        lda     #$0000
        sta     $7eb664
        lda     #$0000
        sta     $7eb666
        lda     #$0002
        sta     $7eb668
        lda     #$0100
        sta     $7eb66a
        lda     #$0f00
        sta     $7eb66c
        lda     #$0100
        sta     $7d
        shorta
@0b8a:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @0b8a
        lda     #$b1
        sta     hNMITIMEN
        lda     #$07
        sta     hBGMODE
@0b9e:  lda     $24
        beq     @0b9e
        stz     $24
@0ba4:  longa
        lda     #$0380
        sta     $26
        .a16
        .i16
        rep     #PSW_A|PSW_I|PSW_C
        lda     $7eb660
        sbc     #$0041
        cmp     #$0300
        bcs     @0bc0
        clr_a
        sta     $7eb66c
        bra     @0bc4
@0bc0:  sta     $7eb660
@0bc4:  sta     f:$00008b
        lda     $7eb662
        sta     f:$00008d
        lda     $7eb666
        tax
        and     #$0001
        beq     @0be2
        sta     $58
        lda     $7eb664
        bra     @0c11
@0be2:  stz     $58
        lda     f:$e00000,x
        and     #$0003
        cmp     #$0003
        bne     @0bf3
        lda     #$0002
@0bf3:  sec
        sbc     #$0001
        clc
        adc     $7eb664
        bmi     @0c09
        cmp     #360
        bcc     @0c0d
        sec
        sbc     #360
        bra     @0c0d
@0c09:  clc
        adc     #360
@0c0d:  sta     $7eb664
@0c11:  clc
        adc     $58
        cmp     #360
        bcc     @0c1c
        sbc     #360
@0c1c:  sta     $73
        inx
        txa
        sta     $7eb666
        php
        jsr     UpdateMode7Rot
        jsr     UpdateTilemap256
        jsr     UpdateVehiclePos
        plp
        jsr     UpdateWaterAnim
        shorta
@0c34:  lda     $24
        beq     @0c34
        stz     $24
        longa
        lda     $7eb66a
        cmp     $7eb66c
        beq     @0c50
        bcs     @0c4d
        adc     #$0040
        bra     @0c50
@0c4d:  sbc     #$0040
@0c50:  sta     $7eb66a
        shorta
        xba
        cmp     #$00
        bne     @0c5d
        lda     #$80
@0c5d:  sta     hINIDISP
        cmp     #$80
        jne     @0ba4
        stz     hHDMAEN
        lda     #$0f
        sta     $22
        stz     $23
        rts

; ------------------------------------------------------------------------------

; [ falcon rising out of water ]

FalconRising:
@0c71:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     HideGradientSprites
        longa
        ldx     #$0000
@0c87:  lda     $7ee1c0,x
        sta     $7ee140,x
        inx2
        cpx     #$0020
        bne     @0c87
        ldx     #$0000
@0c99:  lda     $7ee100,x
        sta     $7ee120,x
        lda     $7ee102,x
        sta     $7ee122,x
        inx4
        cpx     #$0020
        bne     @0c99
        lda     #$00e0
        sta     $85
        sta     $87
        lda     #$5370
        sta     $8b
        lda     #$22cd
        sta     $8d
        lda     #$feff
        sta     $8f
        jsr     UpdateMode7Rot
        lda     #$0400
        sta     $26
        shorta
        longi
        stz     hTS
        stz     hTSW
        stz     hCGSWSEL
        lda     #$30
        sta     hBG2VOFS
        stz     hBG2VOFS
        lda     #$0e
        sta     $ca
        lda     #$07
        sta     hBGMODE
        lda     $1e
        ora     #$20
        sta     $1e
@0cf4:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @0cf4
        lda     #$81
        sta     hNMITIMEN
        cli
@0d04:  lda     $24
        beq     @0d04
        stz     $24
@0d0a:  shorta
        ldx     #$0040
        stx     hVTIMEL
        ldx     #$00dc
        stx     hHTIMEL
        jsr     UpdateSpriteAnim
        jsr     DrawWorldSprites
        jsr     UpdateWaterAnim
        jsr     UpdateVehiclePos
        jsr     UpdateTilemap256
        longa
        lda     $7eb650
        cmp     #$6000
        bcs     @0d38
        shorta
        lda     #$00
        sta     $22
@0d38:  shorta
@0d3a:  lda     $24
        beq     @0d3a
        stz     $24
        lda     $23
        cmp     $22
        beq     @0d4c
        bcs     @0d4b
        inc
        bra     @0d4c
@0d4b:  dec
@0d4c:  sta     $23
        lda     $23
        jne     @0d0a
        shorta
        stz     hHDMAEN
        sei
        rts

; ------------------------------------------------------------------------------

; unused ???

_ee0d5c:
@0d5c:  .word   $9c7a,$9d73,$9b71,$9b71,$996f,$996f,$976d,$976d
        .word   $956b,$956b,$9369,$9369,$9369,$9167,$9167,$9167
        .word   $8f65,$8f65,$8f65,$8d63,$8d63,$8d63,$8d63,$8b63
        .word   $8b63,$8b63,$8b63,$8962,$8962,$8962,$8962,$8761
        .word   $8761,$8761,$8761,$8761,$8561,$8561,$8561,$8561
        .word   $8561,$8561,$8360,$8360,$8360,$8360,$8360,$8360

; ------------------------------------------------------------------------------

; [ ending airship scene ]

FalconEndingMain:
@0dbc:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     InitVehicleHDMA
        jsr     InitVehicleSprites
        jsr     InitWorldSpriteMSB
        jsr     LoadAnimFrames
        jsr     ClearAnimData
        longa
        lda     #$8000
        sta     $44
        sta     $46
        stz     $73
        lda     #$00e0
        sta     $85
        sta     $87
        lda     #$5370
        sta     $8b
        lda     #$22cd
        sta     $8d
        lda     #$feff
        sta     $8f
        jsr     UpdateMode7Rot
        longi
        lda     #$0064
        sta     $75
        lda     #$0400
        sta     $26
        jsr     _ee1930
        lda     $e9
        ora     #$0001
        sta     $e9
        shorta
        lda     #$0f
        sta     $22
        stz     $23
        stz     hW12SEL
        stz     hTS
        stz     hTSW
        stz     hCGSWSEL
        lda     #$30
        sta     hBG2VOFS
        stz     hBG2VOFS
        lda     #$17
        sta     $ca
        lda     #$07
        sta     hBGMODE
        lda     $1e
        ora     #$20
        sta     $1e
@0e3e:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @0e3e
        lda     #$81
        sta     hNMITIMEN
        sei
@0e4e:  lda     $24
        beq     @0e4e
        stz     $24
@0e54:  shorta
        ldx     #$0040
        stx     hVTIMEL
        ldx     #$00dc
        stx     hHTIMEL
        jsr     UpdateSpriteAnim
        jsr     DrawWorldSprites
        jsr     UpdateVehiclePos
        longa
        lda     $7eb650
        cmp     #$3800
        bcs     @0e7c
        shorta
        lda     #$00
        sta     $22
@0e7c:  shorta
@0e7e:  lda     $24
        beq     @0e7e
        stz     $24
        lda     $23
        cmp     $22
        beq     @0e90
        bcs     @0e8f
        inc
        bra     @0e90
@0e8f:  dec
@0e90:  sta     $23
        lda     $23
        jne     @0e54
        shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     PopMode7Vars
        rtl

; ------------------------------------------------------------------------------

; [ unused world of ruin cutscene ??? ]

; 崩壊 (houkai): collapse

_ee0eab:
houkai2:
@0eab:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     HideGradientSprites
        longai
        lda     #$0000
        ldx     #$0000
@0ec4:  sta     $7e620e,x
        inx2
        cpx     #$0700
        bne     @0ec4
        lda     #$00e0
        sta     $85
        sta     $87
        lda     #$7000
        sta     $8b
        lda     #$3000
        sta     $8d
        lda     #$ffff
        sta     $8f
        lda     #$ff00
        sta     $7eb660
        lda     #$c000
        sta     $7eb662
        lda     #$f800
        sta     $7eb664
        lda     #$0400
        sta     $7eb666
        lda     #$0000
        sta     $7eb668
        shorta
        longi
        lda     #$07
        sta     hBGMODE
        stz     hW12SEL
        stz     hW34SEL
        lda     #$a0
        sta     hWOBJSEL
        stz     hTS
        stz     hTSW
        lda     #$10
        sta     hCGSWSEL
        lda     #$f0
        sta     hCOLDATA
        lda     $e9
        ora     #$02
        sta     $e9
@0f32:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @0f32
        lda     #$81
        sta     hNMITIMEN
        sei
@0f42:  lda     $24
        beq     @0f42
        stz     $24
        jsr     UpdateMode7Rot
@0f4b:  longai
        lda     $7eb660
        sec
        sbc     #$0ff0
        cmp     #$2000
        bcc     @0f79
        sta     $7eb660
        lda     $7eb662
        sec
        sbc     #$0a00
        cmp     #$2000
        sta     $7eb662
        lda     $7eb664
        sec
        sbc     #$0c80
        sta     $7eb664
@0f79:  clr_a
        sta     $60
        shorta
        lda     $7eb661
        sta     $58
        lda     $7eb663
        sta     $59
        lda     $7eb665
        sta     $5a
        lda     #$df
        sta     $5b
        jsr     UpdateSpotlightHDMA
        shorta
        lda     $7eb661
        sta     $58
        lda     $7eb663
        clc
        adc     $7eb669
        sta     $59
        lda     $7eb665
        clc
        adc     $7eb667
        sta     $5a
        lda     #$df
        sta     $5b
        lda     #$01
        sta     $60
        jsr     UpdateSpotlightHDMA
        shorta
@0fc2:  lda     $24
        beq     @0fc2
        stz     $24
        lda     $23
        cmp     $22
        beq     @0fd4
        bcs     @0fd3
        inc
        bra     @0fd4
@0fd3:  dec
@0fd4:  sta     $23
        cmp     #$00
        bne     @0fdc
        lda     #$80
@0fdc:  sta     hINIDISP
        longa
        lda     $7eb660
        cmp     #$8800
        bcs     @100b
        lda     $7eb666
        bne     @1003
        lda     $7eb668
        clc
        adc     #$0200
        sta     $7eb668
        cmp     #$4000
        beq     _107a
        bra     @100b
@1003:  sec
        sbc     #$0020
        sta     $7eb666
@100b:  jmp     @0f4b

; ------------------------------------------------------------------------------

_ee100e:
@100e:  .word   $00fe,$00c0,$0100,$0200,$2000,$0001,$00d8,$00a0
        .word   $0100,$0200,$1d00,$0006,$00b0,$0090,$0100,$0200
        .word   $1e00,$000a,$0090,$0078,$0100,$0200,$1800,$000e
        .word   $0078,$0060,$0100,$0200,$1600,$0012,$0058,$0048
        .word   $0100,$0200,$1500,$0016,$0042,$003c,$0100,$0200
        .word   $1000,$001a,$002e,$0028,$0100,$0200,$0e00,$001a
        .word   $0020,$0020,$0100,$0200,$0d00,$001e

; ------------------------------------------------------------------------------

_107a:
@107a:  longa
        ldx     #$0000
@107f:  lda     f:_ee100e,x
        sta     $7eb660,x
        inx2
        cpx     #$006c
        bne     @107f
        clr_a
        sta     $7eb650
        shorta
        lda     #$3f
        sta     hCOLDATA
        lda     #$50
        sta     hCOLDATA
        lda     #$80
        sta     hCOLDATA
@10a4:  phb
        shorta
        lda     #$7e
        pha
        plb
        longai
        lda     $7eb650
        inc
        sta     $7eb650
        bit     #$0001
        bne     @10cb
        lda     #$620e
        sta     $7e6208
        lda     #$63fe
        sta     $7e620b
        bra     @10d9
@10cb:  lda     #$658e
        sta     $7e6208
        lda     #$677e
        sta     $7e620b
@10d9:  lda     $7eb650
        bit     #$0001
        beq     @10e7
        ldx     #$0000
        bra     @10ea
@10e7:  ldx     #$0380
@10ea:  stx     $64
        ldy     #$0038
        lda     #$0000
@10f2:  sta     $620e,x
        sta     $627e,x
        sta     $62ee,x
        sta     $635e,x
        sta     $63ce,x
        sta     $643e,x
        sta     $64ae,x
        sta     $651e,x
        inx2
        dey
        bne     @10f2
        clr_a
        sta     $b652
        ldx     #$0000
@1116:  lda     $b66a,x
        beq     @1121
        dec
        sta     $b66a,x
        bra     @1166
@1121:  lda     $b664,x
        clc
        adc     $b666,x
        cmp     $b668,x
        bcs     @1130
        sta     $b664,x
@1130:  lda     $b664,x
        sta     $58
        phx
        jsr     UpdateMode7Circle
        plx
        lda     $b660,x
        sta     $58
        lda     $b662,x
        sta     $5a
        lda     $b652
        bit     #$0001
        bne     @1151
        lda     #$0000
        bra     @1154
@1151:  lda     #$0002
@1154:  clc
        adc     $64
        sta     $5c
        lda     $b665,x
        and     #$00ff
        sta     $5e
        phx
        jsr     _eeaca1
        plx
@1166:  lda     $b652
        inc
        sta     $b652
        txa
        clc
        adc     #$000c
        tax
        cpx     #$006c
        bne     @1116
        plb
        shorta
@117b:  lda     $24
        cmp     #$02
        bcc     @117b
        stz     $24
        jmp     @10a4

; ------------------------------------------------------------------------------

; [ world of ruin cutscene ]

RuinScene:
@1186:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$7e
        pha
        plb
        jsr     HideGradientSprites
        longai
        lda     #$00ff
        ldx     #$0000
@11a3:  sta     $7e620e,x
        inx2
        cpx     #$0700
        bne     @11a3
        shorta
        clr_a
        pha
        plb
        longai
        clr_a
        sta     $7eb650
        sta     $7eb652
        sta     $7eb654
        lda     #$00f0
        sta     $7eb658
        lda     #$0010
        sta     $7eb65a
        lda     #$00e0
        sta     $85
        sta     $87
        lda     #$7000
        sta     $8b
        lda     #$3000
        sta     $8d
        lda     #$ffff
        sta     $8f
        jsr     UpdateMode7Rot
        shorta
        longi
        lda     #$07
        sta     hBGMODE
        stz     hW12SEL
        stz     hW34SEL
        lda     #$a0
        sta     hWOBJSEL
        stz     hTS
        stz     hTSW
        lda     #$10
        sta     hCGSWSEL
        lda     #$3f
        sta     hCOLDATA
        lda     #$d4
        sta     hCOLDATA
        lda     $e9
        ora     #$02
        sta     $e9
        lda     #$03
        sta     $23
        jsr     _ee15c7
@121f:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @121f
        lda     #$81
        sta     hNMITIMEN
        sei
@122f:  lda     $24
        beq     @122f
        stz     $24

; start of main loop
@1235:  shorta
        lda     $7eb65a
        beq     @1257
        dec
        bne     @1250
        lda     #$80
        sta     hAPUIO2
        lda     #$74
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
        clr_a
@1250:  sta     $7eb65a
        jmp     @133a
@1257:  phb
        lda     #$7e
        pha
        plb
        longai
        lda     $7eb658
        sec
        sbc     #$000c
        cmp     #$0080
        bcc     @126f
        sta     $7eb658
@126f:  lda     $7eb658
        cmp     #$0090
        bcc     @127d
        sta     $58
        jsr     _ee1608
@127d:  lda     $7eb654
        inc
        sta     $7eb654
        bit     #$0001
        bne     @129b
        lda     #$620e
        sta     $7e6208
        lda     #$63fe
        sta     $7e620b
        bra     @12a9
@129b:  lda     #$658e
        sta     $7e6208
        lda     #$677e
        sta     $7e620b
@12a9:  lda     $7eb654
        bit     #$0001
        beq     @12b7
        ldx     #$0000
        bra     @12ba
@12b7:  ldx     #$0380
@12ba:  ldy     #$0038
        lda     #$00ff
@12c0:  sta     $620e,x
        sta     $627e,x
        sta     $62ee,x
        sta     $635e,x
        sta     $63ce,x
        sta     $643e,x
        sta     $64ae,x
        sta     $651e,x
        inx2
        dey
        bne     @12c0
        plb
        lda     $7eb654
        bit     #$0001
        bne     @12ec
        lda     #$0380
        bra     @12ed
@12ec:  clr_a
@12ed:  sta     $64
        lda     #$0030
        sta     $58
        lda     #$0090
        sta     $5a
        lda     #$0000
        clc
        adc     $64
        sta     $5c
        lda     $7eb651
        sta     $5e
        jsr     _eeaca1
        lda     #$00a0
        sta     $58
        lda     #$0060
        sta     $5a
        lda     #$0002
        clc
        adc     $64
        sta     $5c
        lda     $7eb651
        sta     $5e
        jsr     _eeaca1
        longa
        lda     $7eb650
        clc
        adc     #$0200
        sta     $7eb650
        sta     $58
        jsr     UpdateMode7Circle
        shorta
@133a:  lda     $24
        cmp     #$02
        bcc     @133a
        stz     $24
        lda     $23
        cmp     $22
        beq     @134e
        bcs     @134d
        inc
        bra     @134e
@134d:  dec
@134e:  sta     $23
        cmp     #$00
        bne     @1356
        lda     #$80
@1356:  sta     hINIDISP
        lda     $7eb651
        cmp     #$e0
        bcc     @136a
        lda     #$ff
        sbc     $7eb651
        lsr
        sta     $22
@136a:  lda     $23
        jne     @1235
        shorta
        stz     hHDMAEN
        sei
        rts

; ------------------------------------------------------------------------------

; [ light of judgement ]

; 裁き (sabaki): judgment

_ee1378:
sabaki1:
@1378:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$40
        sta     $1f6d
        jsr     HideGradientSprites
        longai
        lda     #$0001
        ldx     #$0000
@1396:  sta     $7e620e,x
        inx2
        cpx     #$0700
        bne     @1396
        ldx     #$0000
@13a4:  lda     $7ee1d6,x
        sta     $7ee142,x
        inx2
        cpx     #$000a
        bne     @13a4
        lda     #$00e0
        sta     $85
        sta     $87
        lda     #$7370
        sta     $8b
        lda     #$3000
        sta     $8d
        lda     #$ffff
        sta     $8f
        jsr     UpdateMode7Rot
        lda     #$0400
        sta     $26
        lda     $e9
        bit     #$0008
        bne     @13fb
        lda     #$0136
        sta     $75
        lda     #$2000
        sta     $7eb650
        lda     #$a000
        sta     $7eb652
        lda     #$2000
        sta     $7eb654
        lda     #$e000
        sta     $7eb656
        bra     @141c
@13fb:  lda     #$003c
        sta     $75
        lda     #$d000
        sta     $7eb650
        lda     #$7000
        sta     $7eb652
        lda     #$f000
        sta     $7eb654
        lda     #$e000
        sta     $7eb656
@141c:  clr_a
        sta     $7eb658
        lda     #$0080
        sta     $7eb65a
        shorta
        longi
        stz     hW12SEL
        stz     hW34SEL
        lda     #$30
        sta     hWOBJSEL
        stz     hTS
        stz     hTMW
        stz     hTSW
        lda     #$20
        sta     hCGSWSEL
        lda     #$03
        sta     hCGADSUB
        lda     #$68
        sta     hCOLDATA
        lda     #$8f
        sta     hCOLDATA
        lda     #$30
        sta     hBG2VOFS
        stz     hBG2VOFS
        lda     #$15
        sta     $ca
        lda     #$07
        sta     hBGMODE
        lda     #$80
        sta     hAPUIO2
        lda     #$51
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
        lda     $1e
        ora     #$20
        sta     $1e
        lda     $e9
        ora     #$02
        sta     $e9
@1480:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @1480
        lda     #$81
        sta     hNMITIMEN
        sei
@1490:  lda     $24
        beq     @1490
        stz     $24
@1496:  shorta
        clr_a
        lda     $1f6d
        tax
        lda     f:RNGTbl,x
        and     #$0f
        ora     #$60
        sta     hCOLDATA
        longa
        lda     $e9
        bit     #$0008
        bne     @14d7
        lda     $7eb650
        clc
        adc     #$0180
        sta     $7eb650
        lda     $7eb652
        sec
        sbc     #$0100
        sta     $7eb652
        lda     $7eb654
        clc
        adc     #$00e0
        sta     $7eb654
        bra     @14fb
@14d7:  lda     $7eb650
        sec
        sbc     #$0180
        sta     $7eb650
        lda     $7eb652
        sec
        sbc     #$0060
        sta     $7eb652
        lda     $7eb654
        sec
        sbc     #$0120
        sta     $7eb654
@14fb:  clr_a
        sta     $60
        lda     $7eb658
        inc
        and     #$00ff
        sta     $7eb658
        tax
        shorta
        lda     f:RNGTbl,x
        and     #$03
        cmp     #$03
        bne     @1518
        clr_a
@1518:  sta     $7eb659
        lda     $7eb651
        sec
        sbc     $7eb659
        sta     $58
        lda     $7eb653
        sta     $59
        lda     $7eb655
        clc
        sbc     $7eb659
        sta     $5a
        lda     $7eb657
        sta     $5b
        jsr     UpdateSpotlightHDMA
        shorta
        lda     $7eb651
        clc
        adc     $7eb659
        sta     $58
        lda     $7eb653
        sta     $59
        lda     $7eb655
        sec
        adc     $7eb659
        sta     $5a
        lda     $7eb657
        sta     $5b
        lda     #$01
        sta     $60
        jsr     UpdateSpotlightHDMA
        shorta
        jsr     UpdateSpriteAnim
        jsr     DrawWorldSprites
        jsr     UpdateWaterAnim
        jsr     UpdateVehiclePos
        jsr     UpdateTilemap256
        longa
        lda     $7eb65a
        dec
        sta     $7eb65a
        cmp     #$0008
        bcs     @1592
        shorta
        asl
        sta     $22
@1592:  shorta
@1594:  lda     $24
        beq     @1594
        stz     $24
        lda     $23
        cmp     $22
        beq     @15a6
        bcs     @15a5
        inc
        bra     @15a6
@15a5:  dec
@15a6:  cmp     $22
        beq     @15b0
        bcs     @15af
        inc
        bra     @15b0
@15af:  dec
@15b0:  sta     $23
        lda     $7eb65a
        jne     @1496
        shorta
        lda     #$80
        sta     hINIDISP
        stz     hHDMAEN
        sei
        rts

; ------------------------------------------------------------------------------

; [ extract bg palette color components ]

; vehicle event command $f6

.proc _ee15c7
        php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longa
        ldx     #0
        ldy     #0
loop:   shorta
        lda     $e000,x                 ; red
        and     #$1f
        sta     $be62,y
        longa
        lda     $e000,x                 ; green
        lsr5
        and     #$001f
        shorta
        sta     $bee2,y
        lda     $e001,x                 ; blue
        lsr2
        and     #$1f
        sta     $bf62,y
        inx2
        iny
        cpy     #$0080                  ; 128 colors (all bg palettes)
        bne     loop
        plb
        plp
        rts
.endproc  ; _ee15c7

; ------------------------------------------------------------------------------

; [ multiply bg palettes ]

; $58: brightness multiplier

.proc _ee1608
        php
        phb
        shortai
        lda     #$7e
        pha
        plb
        ldx     #$fe
        ldy     #$00
loop:   shorta
        lda     $58
        sta     f:hWRMPYA
        lda     $be62,y
        sta     f:hWRMPYB
        nop3
        lda     f:hRDMPYH
        sta     $5a
        lda     $bf62,y
        sta     f:hWRMPYB
        inx2
        nop
        lda     f:hRDMPYH
        asl2
        sta     $5b
        lda     $bee2,y
        sta     f:hWRMPYB
        iny
        nop
        longa
        lda     f:hRDMPYL
        and     #$1f00
        lsr3
        ora     $5a
        sta     $e000,x
        cpy     #$80
        bne     loop
        plb
        plp
        rts
.endproc  ; _ee1608

; ------------------------------------------------------------------------------

; [ update window position hdma data ]

; used for light of judgment and spotlights in vector approach

; $58:
; $59:
; $5a:
; $5b:
; $60:

UpdateSpotlightHDMA:
@165f:  shorta
        lda     #$ff
        sta     $5c
        lda     $58
        sec
        sbc     $5a
        bcs     @1673
        inc     $5c
        inc     $5c
        neg_a
@1673:  sta     $5e
        lda     #$ff
        sta     $5d
        lda     $59
        sec
        sbc     $5b
        bcs     @1687
        inc     $5d
        inc     $5d
        neg_a
@1687:  sta     $5f
        cmp     $5e
        bcs     @16c3
        longa
        lda     $5e
        and     #$00ff
        tay
        lda     $59
        and     #$00ff
        asl2
        clc
        adc     $60
        tax
        shorta
        lda     $58
        xba
        lda     $5e
        lsr
@16a8:  sec
        sbc     $5f
        bcs     @16b9
        adc     $5e
        xba
        sta     $7e620e,x               ; window position hdma data
        xba
        inx4
@16b9:  xba
        clc
        adc     $5c
        xba
        dey
        bne     @16a8
        bra     @16f5
@16c3:  longa
        and     #$00ff
        tay
        lda     $59
        and     #$00ff
        asl2
        clc
        adc     $60
        tax
        shorta
        lda     $58
        xba
        lda     $5f
        lsr
@16dc:  sec
        sbc     $5e
        bcs     @16e8
        adc     $5f
        xba
        clc
        adc     $5c
        xba
@16e8:  xba
        sta     $7e620e,x               ; window position hdma data
        xba
        inx4
        dey
        bne     @16dc
@16f5:  longa
        lda     $59
        and     #$00ff
        asl2
        clc
        adc     $60
        sta     $62
        ldx     $60
        shorta
        lda     $60
        bit     #$01
        bne     @1711
        lda     #$ff
        bra     @1712
@1711:  clr_a
@1712:  cpx     $62
        beq     @1720
        sta     $7e620e,x               ; window position hdma data
        inx4
        bra     @1712
@1720:  longa
        lda     $5b
        inc
        and     #$00ff
        asl2
        clc
        adc     $60
        tax
        clc
        adc     #$037f
        sta     $62
        shorta
        lda     $60
        bit     #$01
        bne     @1740
        lda     #$ff
        bra     @1741
@1740:  clr_a
@1741:  sta     $7e620e,x               ; window position hdma data
        inx4
        cpx     $62
        bcc     @1741
        rts

; ------------------------------------------------------------------------------
