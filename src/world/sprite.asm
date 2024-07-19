
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/sprite.asm                                                     |
; |                                                                            |
; | description: world map sprite routines                                     |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

.import RNGTbl

; ------------------------------------------------------------------------------

; [ init sprite data (vehicle) ]

InitVehicleSprites:
        .i16
@3fc4:  phb
        lda     #$7e
        pha
        plb

; init gradient sprites (5 rows)
        ldx     #$0000
        ldy     #$000f                  ; 15 sprites per row
        lda     #$08
@3fd1:  sta     $58
        sta     $6c00,x                 ; set x position
        sta     $6c3c,x
        sta     $6c78,x
        sta     $6cb4,x
        sta     $6cf0,x
        lda     #$16
        sta     $6c03,x
        sta     $6c3f,x
        lda     #$08
        sta     $6c7b,x
        sta     $6cb7,x
        sta     $6cf3,x
        lda     $58
        clc
        adc     #$10
        inx4
        dey
        bne     @3fd1
        ldy     #$0080
        ldx     #$0000
        lda     #$e0
@4009:  sta     $6b31,x                 ; hide all sprites
        inx4
        dey
        bne     @4009
        plb
        rts

; ------------------------------------------------------------------------------

; [ init sprite data (no vehicle) ]

InitWorldSprites:
@4015:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        ldy     #$0080
        ldx     #$0000
        lda     #$e0
@4026:  sta     $6b31,x
        inx4
        dey
        bne     @4026
        plb
        rts

; ------------------------------------------------------------------------------

; [ set sprite data high bits (vehicle) ]

; sprites 0-19 and 52-127 are 16x16 (minimap and gradient sprites)
; sprites 20-51 are 8x8 (player animation sprites)

InitVehicleSpriteMSB:
@4032:  php
        longa
        lda     #$6d30
        sta     hWMADDL
        shorta
        stz     hWMADDH
        lda     #$aa
.repeat 5
        sta     hWMDATA
.endrep
.repeat 8
        stz     hWMDATA
.endrep
        ldx     #$0013
@406c:  sta     hWMDATA
        dex
        bne     @406c
        plp
        rts

; ------------------------------------------------------------------------------

; [ set sprite data high bits (magitek train) ]

; sprites 0-19 and 52-127 are 16x16
; sprites 20-51 are 8x8

InitTrainSpriteMSB:
@4074:  php
        phb
        shorta
        lda     #$00
        pha
        plb
        longa
        lda     #$6d30
        sta     hWMADDL
        shorta
        stz     hWMADDH
        lda     #$aa
.repeat 5
        sta     hWMDATA
.endrep
.repeat 8
        stz     hWMDATA
.endrep
        ldx     #$0013
@40b5:  sta     hWMDATA
        dex
        bne     @40b5
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ set sprite data high bits (no vehicle) ]

; sprites 0-19 are 16x16 (minimap sprites)
; sprites 20-127 are 8x8 (player animation sprites)

InitWorldSpriteMSB:
@40be:  php
        shorta
        phb
        lda     #$00
        pha
        plb
        longa
        lda     #$6d30
        sta     hWMADDL
        shorta
        stz     hWMADDH
        lda     #$aa
.repeat 5
        sta     hWMDATA
.endrep
        ldx     #$001b
@40e7:  stz     hWMDATA
        dex
        bne     @40e7
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ hide gradient sprites ]

HideGradientSprites:
@40f0:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        ldx     #$00d0                  ; hide sprites 52-126
        lda     #$e0
@40fd:  sta     $6b31,x
        sta     $6b6d,x
        sta     $6ba9,x
        sta     $6be5,x
        sta     $6c21,x
        inx4
        cpx     #$010c
        bne     @40fd
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ clear animation data ]

ClearAnimData:
@4118:  php
        phb
        shortai
        lda     #$7e
        pha
        plb
        ldx     #0
@4122:  stz     $b5d0,x
        inx
        cpx     #$80
        bne     @4122
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ show mini-map ]

ShowMinimap:
@412d:  phb
        php
        shorta
        shorti
        lda     #$7e
        pha
        plb
        clc
        ldx     #$00
        ldy     #$00
@413c:  tya
        sta     $6b42,x
        adc     #$12
        and     #$2e
        tay
        lda     #$0b
        sta     $6b43,x
        txa
        adc     #$04
        tax
        cmp     #$40
        bcc     @413c
        clc
        ldx     #$00
        ldy     #$b0
@4157:  tya
        sta     $6b40,x
        sta     $6b50,x
        sta     $6b60,x
        sta     $6b70,x
        adc     #$10
        tay
        txa
        adc     #$04
        tax
        cmp     #$10
        bcc     @4157
        clc
        ldx     #$00
        ldy     #$9c
@4174:  tya
        sta     $6b41,x
        sta     $6b45,x
        sta     $6b49,x
        sta     $6b4d,x
        adc     #$10
        tay
        txa
        adc     #$10
        tax
        cmp     #$40
        bcc     @4174
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ hide mini-map ]

HideMinimap:
@418f:  phb
        php
        shorta
        shorti
        lda     #$7e
        pha
        plb
        clc
        ldx     #$00
@419c:  lda     #$e0
        sta     $6b41,x
        sta     $6b45,x
        sta     $6b49,x
        sta     $6b4d,x
        txa
        adc     #$10
        tax
        cmp     #$40
        bcc     @419c
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ draw mini-map position indicator ]

; sprite 0 is position indicator
; sprite 1 is direction indicator

DrawMinimapPos:
@41b5:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longai
        lda     $34
        lsr6
        clc
        adc     #$00af
        sta     $6a
        sta     $6b30                   ; x position
        lda     $38
        lsr6
        clc
        adc     #$009b
        sta     $6d
        sta     $6b31                   ; y position
        lda     #$1b80                  ; sprite flags and tile index
        sta     $6b32

; draw direction indicator
        shorta
        lda     $20                     ; return if no vehicle
        cmp     #$03
        jeq     @4269
        longa
        lda     $9d                     ; cosine of vehicle direction
        asl2
        xba
        and     #$0003
        sta     $58
        lda     $9b                     ; sine of vehicle direction
        asl2
        xba
        and     #$0003
        sta     $5a
        lda     $73
        cmp     #180
        bcc     @4239
        cmp     #270
        bcc     @4227
        lda     $6a
        sec
        adc     $5a
        sta     $6b34
        lda     $6d
        sec
        sbc     $58
        inc
        sta     $6b35
        bra     @4263
@4227:  lda     $6a
        sec
        adc     $5a
        sta     $6b34
        lda     $6d
        sec
        adc     $58
        sta     $6b35
        bra     @4263
@4239:  cmp     #90
        bcc     @4251
        lda     $6a
        sec
        sbc     $5a
        inc
        sta     $6b34
        lda     $6d
        sec
        adc     $58
        sta     $6b35
        bra     @4263
@4251:  lda     $6a
        sec
        sbc     $5a
        inc
        sta     $6b34
        lda     $6d
        sec
        sbc     $58
        inc
        sta     $6b35
@4263:  lda     #$1b82
        sta     $6b36
@4269:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ hide mini-map position indicator ]

HideMinimapPos:
@426c:  php
        longa
        lda     #$00e0
        sta     $7e6b31
        sta     $7e6b35
        plp
        rts

; ------------------------------------------------------------------------------

; [ draw animation sprites (vehicle) ]

DrawVehicleSprites:
@427c:  shorta
        phb
        lda     #$7e
        pha
        plb
        longa
        longi
        lda     #$0008
        sta     $66
        ldx     #$0050                  ; start at sprite 20 (8x8 sprites)
        stx     $5c
        ldx     #$0000
@4294:  lda     $b5d2,x                 ; x position
        sta     $58
        lda     $b5d4,x                 ; y position
        sta     $5a
        lda     $b5d0,x                 ; frame pointer
        phx
        beq     @42e0                   ; branch if no animation
        asl
        tay
        lda     $93d0,y
        tay
        shorta
        lda     $95d0,y                 ; number of sprites in frame
        iny
        sta     $68
        ldx     $5c
@42b4:  lda     $95d0,y                 ; x offset
        clc
        adc     $58
        sta     $6b30,x
        lda     $95d1,y                 ; y offset
        clc
        adc     $5a
        sta     $6b31,x
        longa_clc
        lda     $95d2,y                 ; sprite flags and tile index
        sta     $6b32,x
        tya
        adc     #$0004                  ; next sprite
        tay
        txa
        adc     #$0004
        tax
        shorta
        dec     $68
        bne     @42b4
        stx     $5c
@42e0:  longa_clc
        pla
        adc     #$0008
        tax
        cmp     #$0040
        bcc     @4294
        lda     $5c
@42ee:  cmp     #$00d0
        bcs     @4300
        tax
        lda     #$e000
        sta     $6b30,x                 ; hide unused animation sprites
        txa
        adc     #$0004
        bra     @42ee
@4300:  plb
        rts

; ------------------------------------------------------------------------------

; [ draw animation sprites (no vehicle) ]

DrawWorldSprites:
@4302:  shorta
        phb
        lda     #$7e
        pha
        plb
        longa
        longi
        ldx     #$0050
        stx     $5c
        ldx     #$0000
@4315:  lda     $b5d2,x
        sta     $58
        lda     $b5d4,x
        sta     $5a
        lda     $b5d0,x
        phx
        beq     @4397
        asl
        tay
        lda     $93d0,y
        tay
        shorta
        lda     $95d0,y
        iny
        sta     $68
        ldx     $5c
@4335:  lda     $59
        beq     @435b
        bmi     @434b
        lda     $95d0,y
        bmi     @4343
        clr_a
        bra     @4370
@4343:  clc
        adc     $58
        bmi     @4370
        clr_a
        bra     @4370
@434b:  lda     $95d0,y
        bpl     @4353
        clr_a
        bra     @4370
@4353:  clc
        adc     $58
        bpl     @4370
        clr_a
        bra     @4370
@435b:  lda     $95d0,y
        bmi     @4368
        clc
        adc     $58
        bcc     @4370
        clr_a
        bra     @4370
@4368:  clc
        adc     $58
        cmp     $58
        bcc     @4370
        clr_a
@4370:  sta     $6b30,x
        lda     $95d1,y
        clc
        adc     $5a
        sta     $6b31,x
        longa
        lda     $95d2,y
        sta     $6b32,x
        tya
        clc
        adc     #$0004
        tay
        txa
        adc     #$0004
        tax
        shorta
        dec     $68
        bne     @4335
        stx     $5c
@4397:  longa
        pla
        clc
        adc     #$0008
        tax
        cmp     #$0050
        jcc     @4315
        lda     $5c
@43a9:  cmp     #$0200
        bcs     @43bb
        tax
        lda     #$e000
        sta     $6b30,x                 ; hide unused sprites
        txa
        adc     #$0004
        bra     @43a9
@43bb:  plb
        rts

; ------------------------------------------------------------------------------

; [ update player sprite animation ]

UpdateSpriteAnim:
@43bd:  php
        phb
        longa
        longi
        ldx     #0
@43c6:  lda     $ca,x                   ; character graphics index
        beq     @43d1
        phx
        asl
        tax
        jsr     (.loword(UpdateSpriteAnimTbl),x)
        plx
@43d1:  inx2                            ; next character
        cpx     #8
        bne     @43c6
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; character graphic jump table
UpdateSpriteAnimTbl:
@43db:  .addr   0
        .addr   UpdateSpriteAnim_01
        .addr   UpdateSpriteAnim_02
        .addr   UpdateSpriteAnim_03
        .addr   UpdateSpriteAnim_04
        .addr   UpdateSpriteAnim_05
        .addr   UpdateSpriteAnim_06
        .addr   UpdateSpriteAnim_07
        .addr   UpdateSpriteAnim_08
        .addr   UpdateSpriteAnim_09
        .addr   UpdateSpriteAnim_0a
        .addr   UpdateSpriteAnim_0b
        .addr   UpdateSpriteAnim_0c
        .addr   UpdateSpriteAnim_0d
        .addr   UpdateSpriteAnim_0e
        .addr   UpdateSpriteAnim_0f
        .addr   UpdateSpriteAnim_10
        .addr   UpdateSpriteAnim_11
        .addr   UpdateSpriteAnim_12
        .addr   UpdateSpriteAnim_13
        .addr   UpdateSpriteAnim_14
        .addr   UpdateSpriteAnim_15
        .addr   UpdateSpriteAnim_16
        .addr   UpdateSpriteAnim_17
        .addr   UpdateSpriteAnim_18
        .addr   UpdateSpriteAnim_19

; ------------------------------------------------------------------------------

; [ draw airship sprite ]

UpdateSpriteAnim_01:
@440f:  php
        phb
        shorta
        lda     #$00
        pha
        plb
        longa
        lda     $29                     ; rotation speed
        cmp     #$00aa
        bpl     @442a
        cmp     #$ff56
        bmi     @442f
        lda     #$0001                  ; not turning
        bra     @4432
@442a:  lda     #$0009                  ; turning left ???
        bra     @4432
@442f:  lda     #$0005                  ; turning right ???
@4432:  sta     $58
        lda     $2d                     ; vertical movement speed
        cmp     #$00aa
        bpl     @4445
        cmp     #$ff56
        bmi     @444a
        lda     #$0000                  ; not going up or down
        bra     @444d
@4445:  lda     #$0001                  ; going up
        bra     @444d
@444a:  lda     #$0002                  ; going down
@444d:  clc
        adc     $58
        tax
        shorta
        lda     #$08
        sec
        sbc     $27                     ; forward speed sets animation rate
        lsr
        inc
        sta     $7eb654
        lda     $7eb652                 ; decrement animation counter
        dec
        beq     @446b
        sta     $7eb652
        bra     @447c
@446b:  lda     $7eb650                 ; change frame, reset counter
        dec
        sta     $7eb650
        lda     $7eb654
        sta     $7eb652
@447c:  lda     $7eb650
        and     #$01
        clc
        adc     f:AirshipDirAnimOffset,x
        sta     $7eb5d0                 ; set animation frame index
        lda     $30                     ; use altitude to determine y pos
        sta     hWRMPYA
        lda     #$51
        sta     hWRMPYB
        sec
        lda     #$80
        sta     $7eb5d2                 ; x = 128
        sbc     hRDMPYH
        sta     $7eb5d4                 ; y = 128 - 81 * (altitude / 256)
        lda     $e7
        bit     #$20
        beq     @44af
        lda     #$f0
        sta     $7eb5d4                 ; hide airship sprite
@44af:  lda     $30
        sta     hWRMPYA
        lda     #$10
        sta     hWRMPYB
        lda     $c2                     ; airship shadow size
        and     #$0c
        lsr
        sta     $58
        lda     hRDMPYH
        and     #$fe
        clc
        adc     #$28
        sec
        sbc     $58
        sta     $7e6b3a
        sta     $7e6b3e
        lda     #$74
        sta     $7e6b38
        lda     #$7c
        sta     $7e6b3c
        lda     $e7
        bit     #$20
        beq     @44e9
        lda     #$f0
        bra     @44eb
@44e9:  lda     #$c8
@44eb:  sta     $7e6b39
        sta     $7e6b3d
        lda     #$10
        sta     $7e6b3b
        lda     #$50
        sta     $7e6b3f
        lda     $e8
        bit     #$02
        bne     @450d       ; branch if arrows are shown
        lda     #$00
        sta     $7eb5e0
        bra     @4563
@450d:  lda     $7eb661     ; flashing arrows counter ???
        inc
        sta     $7eb661
        cmp     #$04
        bcc     @452f
        lda     #$00
        sta     $7eb661
        lda     $7eb660
        inc
        cmp     #$04
        bcc     @452b
        lda     #$00
@452b:  sta     $7eb660
@452f:  lda     $1eb6
        bit     #$80
        bne     @4547
        lda     #$98
        sta     $7eb5e2
        lda     $7eb660
        beq     @4556
        clc
        adc     #$3e
        bra     @4556
@4547:  lda     #$60
        sta     $7eb5e2
        lda     $7eb660
        beq     @4556
        clc
        adc     #$41
@4556:  sta     $7eb5e0
        lda     #$ff
        sec
        sbc     $85
        sta     $7eb5e4
@4563:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; animation offset for airship directions
; for each row, 0: unused, 1: straight, 2: up, 3: down
AirshipDirAnimOffset:
@4566:  .byte   $00,$01,$07,$0d         ; not turning
        .byte   $00,$05,$0b,$11         ; turning right
        .byte   $00,$03,$09,$0f         ; turning left
        .byte   $00,$00,$00,$00         ; unused

; ------------------------------------------------------------------------------

; [ unused ??? ]

@4576:  php
        phb
        shorta
        lda     #$00
        pha
        plb
        ldx     #$0001
        lda     #$06
        sta     $7eb654
        lda     $7eb652
        dec
        beq     @4594
        sta     $7eb652
        bra     @45a5
@4594:  lda     $7eb650
        dec
        sta     $7eb650
        lda     $7eb654
        sta     $7eb652
@45a5:  lda     $7eb650
        and     #$01
        clc
        adc     f:AirshipDirAnimOffset,x
        sta     $7eb5d0
        lsr2
        clc
        adc     #$80
        sta     $7eb5d4
        lda     $30
        sta     hWRMPYA
        lda     #$10
        sta     hWRMPYB
        lda     $c2         ; airship shadow size
        and     #$0c
        lsr
        sta     $58
        lda     hRDMPYH
        and     #$fe
        clc
        adc     #$28
        sec
        sbc     $58
        sta     $7e6b3a
        sta     $7e6b3e
        lda     #$74
        sta     $7e6b38
        lda     #$7c
        sta     $7e6b3c
        lda     #$c8
        sta     $7e6b39
        sta     $7e6b3d
        lda     #$10
        sta     $7e6b3b
        lda     #$50
        sta     $7e6b3f
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ draw chocobo sprite ]

UpdateSpriteAnim_02:
@4606:  php
        phb
        shorta
        lda     #$00
        pha
        plb
        longa
        lda     $29
        cmp     #$00aa
        bpl     @4621
        cmp     #$ff56
        bmi     @4626
        lda     #$0000                  ; not turning
        bra     @4629
@4621:  lda     #$0006                  ; turning right
        bra     @4629
@4626:  lda     #$000c                  ; turning left
@4629:  sta     $5a
        lda     $29
        bne     @463e                   ; branch if turning
        lda     $26
        bne     @4641                   ; branch if moving forward

; not moving
        lda     #$0025
        sta     $7eb650
        shorta
        bra     @4668
        .a16
@463e:  lda     #0
@4641:  asl2
        sta     $58
        shorta
        lda     #$07
        sec
        sbc     $59
        sta     $7eb654
        lda     $7eb652
        dec
        bmi     @465d
        sta     $7eb652
        bra     @467f
@465d:  lda     $7eb650
        inc
        cmp     #$19
        bcc     @4668
        lda     #$13
@4668:  sta     $7eb650
        lda     $7eb650
        clc
        adc     $5a
        sta     $7eb5d0
        lda     $7eb654
        sta     $7eb652
@467f:  lda     #$b8                    ; y = 184
        sta     $7eb5d4
        lda     #$80                    ; x = 128
        sta     $7eb5d2
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ draw character ]

UpdateSpriteAnim_03:
@468e:  php
        phb
        shortai
        lda     $e7
        bit     #$08
        bne     @469d
        jsr     _ee47f3
        bra     @46c2
@469d:  lda     #$02
        sta     $7eb653
        lda     $7eb652
        clc
        adc     $f3
        cmp     #$80
        bcc     @46bb
        lda     $7eb650
        inc
        and     #$03
        sta     $7eb650
        lda     #$00
@46bb:  sta     $7eb652
        jsr     DrawWorldChar
@46c2:  longai
        lda     $1f64
        and     #$01ff
        beq     @46d3
        lda     #$001d                  ; falcon offset is $62
        sta     $64
        bra     @46d5
@46d3:  stz     $64                     ; falcon offset is $45
@46d5:  lda     $1eb7
        bit     #$0002
        jeq     @47a9                   ; skip if airship is not visible
        lda     $1f63                   ; airship y position
        and     #$00ff
        asl4
        sec
        sbc     $38
        cmp     #$ff86
        jmi     @47a9
        cmp     #$0038
        jpl     @47a9
        clc
        adc     #$007a
        tax
        lda     f:_ee4952,x
        and     #$00ff
        sta     $58
        stz     $60
        lda     $1f62
        and     #$00ff
        asl4
        sec
        sbc     $34
        sbc     #$0008
        bpl     @4725
        dec     $60
        neg_a
@4725:  sta     $5a
        shorta
        sta     hWRMPYA
        lda     #$c7
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        stx     $6a
        lda     $58
        sta     hWRMPYA
        lda     $6a
        sta     hWRMPYB
        nop2
        lda     $6b
        ldx     hRDMPYL
        stx     $6a
        sta     hWRMPYB
        longa_clc
        lda     $6b
        and     #$00ff
        adc     hRDMPYL
        sta     hWRDIVL
        shorta
        lda     #$eb
        sta     hWRDIVB
        nop6
        longa_clc
        lda     hRDDIVL
        and     #$00ff
        adc     $5a
        cmp     #$00a0
        bcs     @47a9
        ldx     $60
        bpl     @4780
        neg_a
@4780:  clc
        adc     #$0080
        sta     $7eb5da
        shorta
        lda     $58
        sec
        sbc     #$08
        sta     $7eb5dc
        lda     $58
        ldy     #$ffff
@4798:  iny
        sec
        sbc     #$3c
        bcs     @4798
        tya
        adc     #$45
        adc     $64
        sta     $7eb5d8
        bra     @47b4
@47a9:  shorta
        clr_a
        sta     $7eb5d8                 ; hide airship sprites
        sta     $7eb5db
@47b4:  shortai
        lda     #$e6
        pha
        plb
        lda     #$00
        xba
        lda     f:$0011fc               ; palette index
        and     #$07
        asl5
        tay
        ldx     #$00
        longa
@47cd:  lda     $8000,y                 ; e6/8000 (character color palettes)
        sta     $7ee100,x
        sta     $7ee180,x
        iny2
        inx2
        cpx     #$20
        bne     @47cd
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ draw character sprite ]

DrawWorldChar:
        .a8
        .i16
@47e3:  lda     $f6                     ; facing direction
        asl2
        clc
        adc     $7eb650
        tax
        lda     f:CharMoveFrameTbl,x
        sta     $f7                     ; set animation frame

_ee47f3:
@47f3:  lda     $f7
        tax
        lda     f:CharTopHFlipTbl,x
        bne     @480a
        lda     f:CharBtmHFlipTbl,x
        bne     @4806
        lda     #$26
        bra     @4816
@4806:  lda     #$27
        bra     @4816
@480a:  lda     f:CharBtmHFlipTbl,x
        bne     @4814
        lda     #$28
        bra     @4816
@4814:  lda     #$29
@4816:  sta     $60
        lda     $e7
        bit     #$10
        bne     @4822                   ; branch if lower sprite is transparent
        lda     $60
        bra     @4827
@4822:  lda     $60
        clc
        adc     #$04
@4827:  sta     $7eb5d0
        lda     #$80
        sta     $7eb5d2
        lda     $e7
        bit     #$20
        bne     @483b
        lda     #$80
        bra     @483d
@483b:  lda     #$f8
@483d:  sta     $7eb5d4
        rts

; ------------------------------------------------------------------------------

; animation frames for character movement
CharMoveFrameTbl:
@4842:  .byte   $04,$05,$04,$03
        .byte   $47,$48,$47,$46
        .byte   $01,$02,$01,$00
        .byte   $07,$08,$07,$06

; ------------------------------------------------------------------------------

; h-flip for top sprites for each character action
CharTopHFlipTbl:
@4852:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

; ------------------------------------------------------------------------------

; h-flip for bottom sprites for each character action
CharBtmHFlipTbl:
@48d2:  .byte   $00,$00,$01,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $01,$01,$01,$00,$01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

; ------------------------------------------------------------------------------

; table to determine size and position of grounded airship
_ee4952:
@4952:  .byte   $00,$01,$02,$03,$04,$04,$05,$06,$06,$07,$08,$09,$0a,$0a,$0b,$0c
        .byte   $0c,$0d,$0e,$0f,$10,$11,$12,$12,$13,$14,$15,$16,$16,$17,$18,$19
        .byte   $1a,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$22,$23,$24,$25,$26,$27
        .byte   $28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34,$35,$36,$37
        .byte   $38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$45,$46,$47,$48
        .byte   $49,$4a,$4b,$4c,$4e,$4f,$50,$51,$52,$54,$55,$56,$57,$58,$5a,$5b
        .byte   $5c,$5e,$5f,$60,$61,$63,$64,$65,$66,$68,$69,$6b,$6c,$6d,$6f,$70
        .byte   $71,$73,$74,$76,$77,$78,$7a,$7c,$7d,$7e,$80,$81,$83,$85,$86,$88
        .byte   $89,$8b,$8c,$8e,$90,$91,$93,$94,$96,$98,$9a,$9b,$9d,$9f,$a0,$a3
        .byte   $a4,$a6,$a8,$a9,$ab,$ad,$af,$b1,$b3,$b5,$b7,$b8,$bb,$bd,$be,$c1
        .byte   $c3,$c4,$c7,$c9,$cb,$cd,$cf,$d1,$d3,$d6,$d8,$da,$dc,$df,$e2,$e5
        .byte   $e8,$eb

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_04:
@4a04:  php
        shorta
        lda     $e8
        bit     #$02
        bne     @4a19
        lda     #$00
        sta     $7eb5e0
        sta     $7eb5e8
        bra     @4a8b
@4a19:  lda     $7eb661
        inc
        sta     $7eb661
        cmp     #$04
        bcc     @4a3b
        lda     #$00
        sta     $7eb661
        lda     $7eb660
        inc
        cmp     #$04
        bcc     @4a37
        lda     #$00
@4a37:  sta     $7eb660
@4a3b:  lda     $1eb6
        bit     #$80
        bne     @4a5f
        lda     #$60
        sta     $7eb5ea
        lda     #$6b
        sta     $7eb5e8
        lda     #$98
        sta     $7eb5e2
        lda     $7eb660
        beq     @4a7a
        clc
        adc     #$3e
        bra     @4a7a
@4a5f:  lda     #$98
        sta     $7eb5ea
        lda     #$6a
        sta     $7eb5e8
        lda     #$60
        sta     $7eb5e2
        lda     $7eb660
        beq     @4a7a
        clc
        adc     #$41
@4a7a:  sta     $7eb5e0
        lda     #$ff
        sec
        sbc     $85
        sta     $7eb5e4
        sta     $7eb5ec
@4a8b:  plp
        rts

; ------------------------------------------------------------------------------

; [ draw esper terra sprite (init) ]

UpdateSpriteAnim_0c:
@4a8d:  php
        phb
        shorta
        longi
        lda     #$7e
        pha
        plb
        lda     f:WorldEsperTerraPalPtr
        sta     $d2
        lda     f:WorldEsperTerraPalPtr+1
        sta     $d3
        lda     f:WorldEsperTerraPalPtr+2
        sta     $d4
        lda     #$01
        sta     $7eb660
        ldy     #$0000
        longa
@4ab4:  lda     [$d2],y
        sta     $e140,y
        iny2
        cpy     #$0020
        bne     @4ab4
        shorta
        lda     #$0d                    ; don't load palette next time
        sta     f:$0000ca
        lda     #$e0
        sta     $7e6b39
        sta     $7e6b3d
        bra     _4ad6

; ------------------------------------------------------------------------------

; [ draw esper terra sprite ]

UpdateSpriteAnim_0d:
@4ad4:  php
        phb
_4ad6:  shorta
        clr_a
        pha
        plb
        longa
        lda     $29
        cmp     #$00aa
        bpl     @4aee
        cmp     #$ff56
        bmi     @4af3
        lda     #$004e
        bra     @4af6
@4aee:  lda     #$0050
        bra     @4af6
@4af3:  lda     #$0052
@4af6:  sta     $58
        shorta
        lda     #$0c
        sec
        sbc     $27
        lsr
        inc
        sta     $7eb654
        lda     $7eb652
        dec
        beq     @4b12
        sta     $7eb652
        bra     @4b23
@4b12:  lda     $7eb650
        dec
        sta     $7eb650
        lda     $7eb654
        sta     $7eb652
@4b23:  lda     $7eb650
        and     #$01
        clc
        adc     $58
        sta     $7eb5d0
        lda     $30
        sta     hWRMPYA
        lda     #$51
        sta     hWRMPYB
        sec
        lda     #$80
        sta     $7eb5d2
        sbc     hRDMPYH
        sta     $7eb5d4
        lda     $e7
        bit     #$20
        beq     @4b54
        lda     #$f0
        sta     $7eb5d4
@4b54:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ draw ship sprite ]

UpdateSpriteAnim_05:
@4b57:  phb
        php
        shortai
        lda     #$02
        sta     $7eb653
        lda     $7eb652
        clc
        adc     $f3
        cmp     #$80
        bcc     @4b79
        lda     $7eb650
        inc
        and     #$01
        sta     $7eb650
        lda     #$00
@4b79:  sta     $7eb652
        lda     $f6                     ; facing direction
        asl
        clc
        adc     $7eb650
        adc     #$37
        sta     $7eb5d0
        lda     #$80
        sta     $7eb5d2
        lda     #$80
        sta     $7eb5d4
        lda     #$e6
        pha
        plb
        lda     #$00
        xba
        ldy     #$80
        ldx     #$00
        longa
@4ba4:  lda     $8000,y
        sta     $7ee100,x
        sta     $7ee180,x
        iny2
        inx2
        cpx     #$20
        bne     @4ba4
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ airship lifting off ]

UpdateSpriteAnim_06:
@4bba:  php
        longa
        lda     $1f64
        and     #$01ff
        beq     @4bd1
        lda     #$0064                  ; falcon ($64 and $66)
        sta     $5a
        lda     #$0002
        sta     $5c
        bra     @4bdb
@4bd1:  lda     #$0047                  ; blackjack ($47 and $4d)
        sta     $5a
        lda     #$0006
        sta     $5c
@4bdb:  lda     $7eb664
        dec
        bne     @4c03
        lda     $7eb666
        beq     @4beb
        clr_a
        bra     @4bed
@4beb:  lda     $5c
@4bed:  sta     $7eb666
        lda     $7eb668
        cmp     #$0002
        bcc     @4bff
        dec
        sta     $7eb668
@4bff:  lda     $7eb668
@4c03:  sta     $7eb664
        lda     $7eb668
        cmp     #$0002
        bcc     @4c16
        lda     $7eb660
        bra     @4c42
@4c16:  lda     $7eb663
        and     #$00ff
        sta     $58
        lda     $7eb662
        clc
        adc     #$0020
        sta     $7eb662
        lda     $7eb660
        sec
        sbc     $58
        sta     $7eb660
        cmp     #$fff8
        bpl     @4c42
        lda     #$fff8
        sta     $7eb660
@4c42:  shorta
        sta     $7eb5d4                 ; set y position
        lda     #$75
        sta     $7eb5d2                 ; set x position
        lda     $5a
        clc
        adc     $7eb666
        sta     $7eb5d0
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_07:
@4c5b:  php
        longa
        lda     $7eb664
        dec
        bne     @4c78
        lda     $7eb666
        beq     @4c6e
        clr_a
        bra     @4c71
@4c6e:  lda     #$0001
@4c71:  sta     $7eb666
        lda     #$0005
@4c78:  sta     $7eb664
        lda     $7eb662
        sec
        sbc     #$0020
        sta     $7eb662
        lda     $7eb663
        and     #$00ff
        sta     $58
        lda     $7eb660
        clc
        adc     $58
        sta     $7eb660
        cmp     #$0080
        bmi     @4ca9
        lda     #$0001
        sta     $ca
        lda     #$0080
@4ca9:  shorta
        sta     $7eb5d4
        lda     #$80
        sta     $7eb5d2
        lda     #$01
        clc
        adc     $7eb666
        sta     $7eb5d0
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_08:
@4cc2:  php
        longa
        lda     $7eb664
        dec
        bne     @4cdf
        lda     $7eb666
        beq     @4cd5
        clr_a
        bra     @4cd8
@4cd5:  lda     #$0001
@4cd8:  sta     $7eb666
        lda     #$0005
@4cdf:  sta     $7eb664
        lda     $7eb663
        and     #$00ff
        sta     $58
        lda     $7eb662
        clc
        adc     #$0020
        sta     $7eb662
        lda     $7eb660
        sec
        sbc     $58
        sta     $7eb660
        cmp     #$fff8
        bpl     @4d1b
        lda     #$fff8
        sta     $7eb660
        lda     #$0009
        sta     $ca
        lda     #$0640
        sta     $7eb662
@4d1b:  shorta
        sta     $7eb5d4
        lda     #$80
        sta     $7eb5d2
        lda     #$01
        clc
        adc     $7eb666
        sta     $7eb5d0
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_09:
@4d34:  php
        longa
        lda     $1f64
        and     #$01ff
        beq     @4d4b
        lda     #$0064
        sta     $5a
        lda     #$0002
        sta     $5c
        bra     @4d55
@4d4b:  lda     #$0047
        sta     $5a
        lda     #$0006
        sta     $5c
@4d55:  lda     $7eb664
        dec
        bne     @4d89
        lda     $7eb666
        beq     @4d65
        clr_a
        bra     @4d73
@4d65:  lda     $7eb668
        cmp     #$000f
        bcs     @4d72
        lda     $5c
        bra     @4d73
@4d72:  clr_a
@4d73:  sta     $7eb666
        lda     $7eb668
        cmp     #$0013
        bcs     @4d85
        inc
        sta     $7eb668
@4d85:  lda     $7eb668
@4d89:  sta     $7eb664
        lda     $7eb662
        cmp     #$0010
        bpl     @4d9c
        lda     $7eb660
        bra     @4dbd
@4d9c:  lda     $7eb662
        sec
        sbc     #$0008
        sta     $7eb662
        lda     $7eb662
        clc
        adc     $7eb660
        sta     $7eb660
        cmp     #$7800
        bmi     @4dbd
        lda     #$7800
@4dbd:  shorta
        xba
        sta     $7eb5d4
        lda     #$75
        sta     $7eb5d2
        lda     $5a
        clc
        adc     $7eb666
        sta     $7eb5d0
        lda     $7eb668
        cmp     #$11
        bne     @4de1
        lda     #$03
        sta     $ca
@4de1:  plp
        rts

; ------------------------------------------------------------------------------

; frames for dismounting chocobo
_ee4de3:
@4de3:  .byte   $49,$4a,$49,$4b,$4c

; ------------------------------------------------------------------------------

; [ dismounting chocobo (1st part) ]

UpdateSpriteAnim_0a:
@4de8:  php
        phb
        shorta
        lda     $7eb66c
        cmp     #$28
        bne     @4e03
        lda     #$80
        sta     hAPUIO2
        lda     #$d9
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
@4e03:  longa
        lda     $7eb66c
        cmp     #$0020
        bcc     @4e48
        cmp     #$0030
        bcs     @4e1c
        lda     #$0004
        sta     $7eb662
        bra     @4e48
@4e1c:  lda     $7eb662
        inc
        and     #$0003
        sta     $7eb662
        lda     $7eb66e
        clc
        adc     #$0060
        sta     $7eb66e
        lda     $7eb660
        inc2
        sta     $7eb660
        cmp     #$00f0
        bmi     @4e48
        lda     #$000b
        sta     $ca
@4e48:  lda     $7eb668
        cmp     #$00b8
        bcs     @4e6c
        clc
        adc     $7eb666
        sta     $7eb668
        lda     $7eb666
        inc
        sta     $7eb666
        lda     $7eb66a
        dec
        sta     $7eb66a
@4e6c:  lda     $7eb66c
        cmp     #$0009
        bcs     @4e7a
        lda     #$000f
        bra     @4e87
@4e7a:  cmp     #$0010
        bcs     @4e84
        lda     #$0009
        bra     @4e87
@4e84:  lda     #$0001
@4e87:  shorta
        sta     $f7
        lda     $7eb660
        sta     $7eb5d4
        lda     $7eb66f
        sta     $7eb5d2
        lda     $7eb662
        tax
        lda     f:_ee4de3,x
        sta     $7eb5d0
        lda     $7eb66a
        sta     $7eb5da
        lda     $7eb668
        sta     $7eb5dc
        clr_a
        lda     $f7
        tax
        lda     f:CharTopHFlipTbl,x
        bne     @4ed0
        lda     f:CharBtmHFlipTbl,x
        bne     @4ecc
        lda     #$26
        bra     @4edc
@4ecc:  lda     #$27
        bra     @4edc
@4ed0:  lda     f:CharBtmHFlipTbl,x
        bne     @4eda
        lda     #$28
        bra     @4edc
@4eda:  lda     #$29
@4edc:  sta     $7eb5d8
        longa
        lda     $7eb66c
        inc
        sta     $7eb66c
        shortai
        lda     #$e6
        pha
        plb
        lda     #$00
        xba
        lda     f:$0011fc
        and     #$07
        asl5
        tay
        ldx     #$00
        longa
@4f04:  lda     $8000,y
        sta     $7ee100,x
        iny2
        inx2
        cpx     #$20
        bne     @4f04
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ dismounting chocobo (2nd part) ]

UpdateSpriteAnim_0b:
@4f16:  php
        longa
        lda     #$0000
        sta     $7eb5d0
        sta     $7eb5d8
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_0e:
@4f26:  php
        phb
        shorta
        longi
        lda     #$7e
        pha
        plb
        lda     #$e0
        sta     $6b39
        sta     $6b3d
        jsr     InitWorldSpriteMSB
        ldx     #$8000
        stx     $b650
        ldx     #$a700
        stx     $b652
        ldx     #$0100
        stx     $b65a
        ldx     #$0000
        stx     $b65c
        ldx     #$0000
@4f56:  clr_a
        sta     $b660,x
        txa
        clc
        adc     #$08
        tax
        cmp     #$80
        bne     @4f56
        lda     #$0f
        sta     $ca
        bra     _4f6b

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_0f:
@4f69:  php
        phb
_4f6b:  shorta
        lda     #$7e
        pha
        plb
        lda     $b65b
        dec
        bne     @4f83
        lda     $b65a
        inc2
        and     #$02
        sta     $b65a
        lda     #$04
@4f83:  sta     $b65b
        lda     $b651
        sta     $b602
        lda     $b653
        sta     $b604
        lda     #$64
        clc
        adc     $b65a
        sta     $b600
        longa_clc
        lda     $b652
        sbc     #$001f
        cmp     #$7800
        bcs     @4fab
        lda     #$7800
@4fab:  sta     $b652
        shorta_sec
        xba
        sbc     #$90
        bcs     @4fb8
        clr_a
        bra     @4fbe
@4fb8:  lsr3
        clc
        adc     #$67
@4fbe:  sta     $b654
        lda     $b653
        sec
        sbc     #$78
        and     #$f8
        lsr
        sta     $58
        lsr
        clc
        adc     $58
        sta     $b656
        lda     #$a7
        sec
        sbc     $b653
        sbc     #$14
        sta     $b658
        lda     $b651
        sta     $b5fa
        lda     #$90
        sta     $b5fc
        lda     $b654
        sta     $b5f8
        ldy     #$0000
        ldx     $b65c
@4ff5:  shorta
        clr_a
        lda     $b660,x
        beq     @5019
        lda     $b662,x
        dec
        bne     @5013
        lda     $b660,x
        inc
        cmp     #$07
        bcc     @500d
        lda     #$00
@500d:  sta     $b660,x
        lda     $b661,x
@5013:  sta     $b662,x
        lda     $b660,x
@5019:  phx
        clc
        adc     $b656
        tax
        lda     f:_ee5196,x
        plx
        sta     $b5d0,y
        lda     $b663,x
        sta     $b5d4,y
        longa_clc
        lda     $b664,x
        adc     $b666
        sta     $b664,x
        sta     $b5d2,y
        txa
        clc
        adc     #$0008
        tax
        tya
        clc
        adc     #$0008
        tay
        cmp     #$0028
        bne     @4ff5
        ldy     $b65c
        shorta
        lda     f:$001f6d
        inc
        sta     f:$001f6d
        tax
        stx     $5a
@505d:  lda     $b660,y
        beq     @506d
        tya
        clc
        adc     #$08
        tay
        cmp     #$28
        bne     @505d
        bra     @50ad
@506d:  inc     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$03
        clc
        adc     #$06
        sta     $b666
        inc     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$01
        inc
        sta     $b661,y
        sta     $b662,y
        inc     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$07
        clc
        adc     #$8c
        sta     $b663,y
        lda     $b651
        clc
        adc     $b658
        sta     $b664,y
        lda     #$01
        sta     $b660,y
@50ad:  lda     #$28
        sec
        sbc     $b65c
        sta     $b65c
        longa
        lda     $b652
        cmp     #$7800
        bne     @50d3
        stz     $b65c
        stz     $b654
        stz     $b656
        stz     $b658
        lda     #$0014
        sta     f:$0000ca
@50d3:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_14:
@50d6:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longa
        clr_a
        lda     $b65c
        cmp     #180
        bcs     @50ee
        inc2
        sta     $b65c
@50ee:  tax
        shorta
        lda     f:WorldSineTbl,x
        sta     f:hWRMPYA
        lda     #$c0
        sta     f:hWRMPYB
        nop3
        lda     f:hRDMPYH
        sta     $58
        stz     $59
        longa_clc
        lda     $b650
        adc     $58
        sta     $b650
        lda     $b658
        adc     #$0000
        sta     $b658
        lda     $b65c
        cmp     #180
        bne     @5156
        longa
        sec
        lda     $b650
        sbc     $b654
        sta     $b650
        lda     $b658
        sbc     #$0000
        sta     $b658
        lda     $b654
        adc     #$0010
        sta     $b654
        lda     $b652
        sec
        sbc     $b656
        sta     $b652
        lda     $b656
        adc     #$0004
        sta     $b656
@5156:  shorta
        lda     $b65b
        dec
        bne     @5175
        lda     $b65a
        inc2
        and     #$02
        sta     $b65a
        lda     $b65c
        cmp     #$b4
        beq     @5173
        lda     #$06
        bra     @5175
@5173:  lda     #$02
@5175:  sta     $b65b
        lda     $b651
        sta     $b602
        lda     $b658
        sta     $b603
        lda     $b653
        sta     $b604
        lda     #$64
        clc
        adc     $b65a
        sta     $b600
        plb
        plp
        rts

; ------------------------------------------------------------------------------

_ee5196:
@5196:  .byte   $00,$00,$00,$00,$00,$00
        .byte   $00,$56,$56,$56,$56,$56
        .byte   $00,$57,$57,$56,$56,$56

_ee51a8:
@51a8:  .byte   $00,$59,$58,$57,$56,$56
        .byte   $00,$58,$57,$57,$56,$56
        .byte   $00,$57,$57,$56,$56,$56
        .byte   $00,$57,$56,$56,$56,$56
        .byte   $00

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_10:
@51c1:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longai
        ldx     #$0000
@51ce:  lda     $e1c0,x
        sta     $e140,x
        inx2
        cpx     #$0020
        bne     @51ce
        clr_a
        sta     $b65c
        shorta
        lda     #$0a
        sta     $b652
        clr_a
        sta     $b658
        sta     $b659
        sta     $b654
        lda     #$02
        sta     $b656
        lda     #$59
        sta     $b65b
        ldx     #$0000
@51fd:  clr_a
        sta     $b660,x
        txa
        clc
        adc     #$08
        tax
        cpx     #$0030
        bne     @51fd
        lda     #$11
        sta     $ca
        bra     _5213

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_11:
@5211:  php
        phb
_5213:  shorta
        lda     #$7e
        pha
        plb
        lda     $b656
        dec
        bne     @5250
        longa
        lda     $b65a
        clc
        adc     #$0020
        sta     $b65a
        lda     $b654
        tax
        inc2
        sta     $b654
        shorta
        lda     f:$c50000,x
        and     #$03
        sec
        sbc     #$01
        sta     $b658
        lda     f:$c50001,x
        and     #$03
        sec
        sbc     #$01
        sta     $b659
        lda     #$03
@5250:  sta     $b656
        lda     $b652
        dec
        beq     @525e
        sta     $b652
        bra     @526a
@525e:  lda     $b650
        dec
        sta     $b650
        lda     #$08
        sta     $b652
@526a:  lda     $b650
        and     #$01
        inc
        sta     $b600
        lda     $b658
        clc
        adc     #$80
        sta     $b602
        lda     $b659
        clc
        adc     $b65b
        sta     $b604
        ldy     #$0000
        clr_a
        lda     $b65c
        tax
@528e:  shorta
        lda     $b660,x
        beq     @52b1
        lda     $b662,x
        dec
        bne     @52ab
        lda     $b660,x
        inc
        cmp     #$5f
        bcc     @52a5
        lda     #$00
@52a5:  sta     $b660,x
        lda     $b661,x
@52ab:  sta     $b662,x
        lda     $b660,x
@52b1:  sta     $b5d0,y
        lda     $b667,x
        clc
        adc     #$03
        sta     $b667,x
        sta     $b5d4,y
        longa_clc
        lda     $b663,x
        adc     $b665,x
        sta     $b665,x
        shorta
        xba
        sta     $b5d2,y
        longa_clc
        txa
        adc     #$0008
        cmp     #$0028
        bcc     @52dd
        clr_a
@52dd:  tax
        tya
        clc
        adc     #$0008
        tay
        cmp     #$0028
        bne     @528e
        lda     $b65c
        clc
        adc     #$0008
        cmp     #$0028
        bcc     @52f6
        clr_a
@52f6:  sta     $b65c
        tax
        txa
        sec
        sbc     #$0010
        bpl     @5304
        lda     #$0020
@5304:  tay
        shorta
        lda     $b660,y
        bne     @534d
        ldx     $b654
        lda     f:$c20000,x
        cmp     #$20
        bcc     @534d
        lda     #$5b
        sta     $b660,y
        lda     f:$ee0000,x
        and     #$03
        inc
        sta     $b661,y
        sta     $b662,y
        ldx     $b654
        longa
        lda     f:$c10000,x
        and     #$01ff
        sta     $58
        lda     #$0100
        sbc     $58
        sta     $b663,y
        lda     #$8400
        sta     $b665,y
        shorta
        lda     $b604
        sta     $b667,y
@534d:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; frames for bird sprite
_ee5350:
@5350:  .byte   $5f,$60,$61,$60

; ------------------------------------------------------------------------------

; [ draw bird sprite ]

UpdateSpriteAnim_12:
@5354:  phb
        php
        shorta
        lda     #$e6
        pha
        plb
        lda     #$13
        sta     f:$0000ca
        lda     #$e0
        sta     $7e6b39
        sta     $7e6b3d
        ldy     #$0080
        ldx     #$0000
        longa
@5374:  lda     $8000,y
        sta     $7ee140,x
        iny2
        inx2
        cpx     #$0020
        bne     @5374
        lda     #$0000
        sta     $7eb660
        lda     #$0001
        sta     $7eb662
        bra     _5396

; ------------------------------------------------------------------------------

; [ draw bird sprite ]

UpdateSpriteAnim_13:
@5394:  phb
        php
_5396:  shorta
        clr_a
        pha
        plb
        lda     $7eb662
        dec
        bne     @53af
        lda     $7eb660
        inc
        and     #$03
        sta     $7eb660
        lda     #$03
@53af:  sta     $7eb662
        clr_a
        lda     $7eb660
        tax
        lda     f:_ee5350,x
        sta     $7eb5d0
        lda     $30
        sta     hWRMPYA
        lda     #$51
        sta     hWRMPYB
        sec
        lda     #$80
        sta     $7eb5d2
        sbc     hRDMPYH
        sta     $7eb5d4
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_15:
@53dc:  php
        phb
        shorta
        longi
        lda     #$7e
        pha
        plb
        lda     #$e0
        sta     $6b39
        sta     $6b3d
        jsr     InitWorldSpriteMSB
        ldx     #$0000
        stx     $b65c
@53f7:  clr_a
        sta     $b660,x
        sta     $b665,x
        txa
        clc
        adc     #$08
        tax
        cmp     #$80
        bne     @53f7
        lda     #$16
        sta     $ca
        bra     _540f

; ------------------------------------------------------------------------------

; [ draw smoking airship ]

UpdateSpriteAnim_16:
@540d:  php
        phb
_540f:  shorta
        lda     #$7e
        pha
        plb
        ldy     #$0000
        ldx     $b65c
@541b:  shorta
        clr_a
        lda     $b660,x
        beq     @543e
        lda     $b662,x
        dec
        bne     @5438
        lda     $b660,x
        inc
        cmp     #$07
        bcc     @5432
        clr_a
@5432:  sta     $b660,x
        lda     $b661,x
@5438:  sta     $b662,x
        lda     $b660,x
@543e:  phx
        tax
        lda     f:_ee51a8,x
        plx
        sta     $b5d0,y
        lda     $e9
        bit     #$08
        bne     @545c
        lda     $b663,x
        clc
        adc     #$06
        sta     $b663,x
        sta     $b5d4,y
        bra     @5468
@545c:  lda     $b663,x
        clc
        adc     #$04
        sta     $b663,x
        sta     $b5d4,y
@5468:  longa
        lda     $e9
        bit     #$0008
        bne     @5480
        lda     $b664,x
        sec
        sbc     $b666
        sta     $b664,x
        sta     $b5d2,y
        bra     @548d
@5480:  clc
        lda     $b664,x
        adc     $b666
        sta     $b664,x
        sta     $b5d2,y
@548d:  txa
        clc
        adc     #$0008
        tax
        tya
        clc
        adc     #$0008
        tay
        cmp     #$0028
        jne     @541b
        ldy     $b65c
        shorta
        lda     f:$001f6d               ; random number
        dec
        sta     f:$001f6d
        tax
        stx     $5a
@54b2:  lda     $b660,y
        beq     @54c2
        tya
        clc
        adc     #$08
        tay
        cmp     #$28
        bne     @54b2
        bra     @5523
@54c2:  dec     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$03
        clc
        adc     #$05
        sta     $b666
        dec     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$01
        inc
        sta     $b661,y
        sta     $b662,y
        dec     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$07
        clc
        adc     #$07
        sta     $5c
        lda     $b653
        sbc     $5c
        sta     $b663,y
        longa
        lda     $e9
        bit     #$0008
        bne     @550f
        lda     $b651
        and     #$00ff
        clc
        adc     #$0008
        bra     @5519
@550f:  lda     $b651
        and     #$00ff
        sec
        sbc     #$0008
@5519:  sta     $b664,y
        shorta
        lda     #$01
        sta     $b660,y
@5523:  lda     #$28
        sec
        sbc     $b65c
        sta     $b65c
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_17:
@552f:  php
        phb
        shorta
        longi
        lda     #$7e
        pha
        plb
        lda     #$e0
        sta     $6b39
        sta     $6b3d
        jsr     InitWorldSpriteMSB
        ldx     #$c000
        stx     $b650
        ldx     #$8000
        stx     $b652
        ldx     #$0060
        stx     $b654
        ldx     #$ff00
        stx     $b656
        ldx     #$0100
        stx     $b65a
        ldx     #$0000
        stx     $b65c
        ldx     #$0000
        stx     $b65e
        ldx     #$0000
@5571:  clr_a
        sta     $b660,x
        txa
        clc
        adc     #$08
        tax
        cmp     #$80
        bne     @5571
        lda     #$18
        sta     $ca
        bra     _5586

; ------------------------------------------------------------------------------

; [  ]

UpdateSpriteAnim_18:
@5584:  php
        phb
_5586:  shorta
        lda     #$7e
        pha
        plb
        longa
        lda     $b65e
        inc
        sta     $b65e
        cmp     #$0098
        bcc     @55ae
        cmp     #$00b8
        bcs     @55ae
        sec
        sbc     #$0098
        asl5
        clc
        adc     #$0400
        sta     $26
@55ae:  shorta
        lda     $b65b
        dec
        bne     @55d4
        lda     $b65a
        inc2
        and     #$02
        sta     $b65a
        longa
        lda     $b65e
        cmp     #$0098
        bcs     @55d0
        shorta
        lda     #$04
        bra     @55d4
@55d0:  shorta
        lda     #$02
@55d4:  sta     $b65b
        lda     $b651
        sta     $b602
        lda     $b653
        sta     $b604
        lda     #$64
        clc
        adc     $b65a
        sta     $b600
        longa_clc
        lda     $b650
        adc     $b654
        sta     $b650
        lda     $b652
        clc
        adc     $b656
        sta     $b652
        lda     $b654
        sec
        sbc     #$0001
        sta     $b654
        lda     $b65e
        cmp     #$0078
        bcs     @562d
        lda     $b652
        cmp     #$8000
        bcs     @5624
        lda     $b656
        clc
        adc     #$0005
        bra     @563e
@5624:  lda     $b656
        sec
        sbc     #$0002
        bra     @563e
@562d:  lda     $b654
        sec
        sbc     #$0003
        sta     $b654
        lda     $b656
        sec
        sbc     #$0006
@563e:  sta     $b656
        ldy     #$0000
        ldx     $b65c
@5647:  shorta
        clr_a
        lda     $b660,x
        beq     @566b
        lda     $b662,x
        dec
        bne     @5665
        lda     $b660,x
        inc
        cmp     #$07
        bcc     @565f
        lda     #$00
@565f:  sta     $b660,x
        lda     $b661,x
@5665:  sta     $b662,x
        lda     $b660,x
@566b:  phx
        tax
        lda     f:_ee5196,x
        plx
        sta     $b5d0,y
        lda     $b663,x
        sta     $b5d4,y
        longa_clc
        lda     $b664,x
        adc     $b666
        sta     $b664,x
        sta     $b5d2,y
        txa
        clc
        adc     #$0008
        tax
        tya
        clc
        adc     #$0008
        tay
        cmp     #$0028
        bne     @5647
        ldy     $b65c
        shorta
        lda     f:$001f6d
        inc
        sta     f:$001f6d
        tax
        stx     $5a
@56ab:  lda     $b660,y
        beq     @56bb
        tya
        clc
        adc     #$08
        tay
        cmp     #$28
        bne     @56ab
        bra     @56fb
@56bb:  inc     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$03
        clc
        adc     #$06
        sta     $b666
        inc     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$01
        inc
        sta     $b661,y
        sta     $b662,y
        inc     $5a
        ldx     $5a
        lda     f:RNGTbl,x
        and     #$07
        clc
        adc     #$8c
        sta     $b663,y
        lda     $b651
        clc
        adc     $b658
        sta     $b664,y
        lda     #$01
        sta     $b660,y
@56fb:  lda     #$28
        sec
        sbc     $b65c
        sta     $b65c
        longa
        lda     $b652
        cmp     #$7800
        bne     @570e
@570e:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ load animation frame data ]

LoadAnimFrames:
UpdateSpriteAnim_19:
@5711:  php
        phb
        phk
        plb
        longi
        longa
        ldx     #0
@571c:  lda     .loword(WorldAnimSpritePtrs),x
        sta     $7e93d0,x
        inx2
        cpx     #$00d8                  ; 108 frames total
        bne     @571c
        ldx     #0
@572d:  lda     .loword(WorldAnimSprites),x
        sta     $7e95d0,x
        inx2
        cpx     #$13d6
        bne     @572d
        plb
        plp
        rts

; ------------------------------------------------------------------------------

