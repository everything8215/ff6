; ------------------------------------------------------------------------------

.a8
.i16

; ------------------------------------------------------------------------------

; [ world map (with vehicle) ]

VehicleMain:
@0018:  jsr     InitVehicleHDMA
        jsr     InitOffsetPerTileData
        jsr     InitBG3Tilemap
        jsr     InitVehicleSprites
        jsr     InitVehicleSpriteMSB
        jsr     ClearBG1Tilemap
        jsr     LoadAnimFrames
        jsr     ClearAnimData
        longa
        lda     #$8000
        sta     $44
        sta     $46
        lda     $11f6
        bit     #$0040
        bne     @0049
        bit     #$0002
        beq     @004f
        jmp     @00ce
@0049:  and     #$ffbf
        sta     $11f6
@004f:  lda     #$0020
        sta     $93
        lda     $11f2
        bpl     @0068
        and     #$7fff
        sta     $73
        stz     $11f2
        lda     $11f4
        sta     $2f
        bra     @006d
@0068:  lda     #$0000
        sta     $73
@006d:  lda     #$a000
        sta     $8b
        sta     $91
        stz     $8d
        lda     #$ff00
        sta     $8f
        lda     #$000f
        sta     $22
        stz     $23
        lda     $83
        bpl     @0089
        not_a
@0089:  lsr
        clc
        adc     $85
        sta     $87
        shorta
        ldy     #$0000
        lda     f:$0011fd
        beq     @009b
        iny
@009b:  sta     $ea
        lda     f:$0011fe
        beq     @00a4
        iny
@00a4:  sta     $eb
        lda     f:$0011ff
        beq     @00ad
        iny
@00ad:  sta     $ec
        cpy     #$0000
        beq     @00ce
        stz     $ed
        stz     $ee
        bit     #$80
        bne     @00c6
        ora     #$80
        sta     $ec
        lda     $e7
        ora     #$41
        bra     @00cc
@00c6:  lda     $e7
        ora     #$01
        and     #$bf
@00cc:  sta     $e7
@00ce:  shorta
        lda     #$c8
        sta     hHTIMEL
        shorta
        cli
        lda     #$80
        sta     hINIDISP
@00dd:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @00dd
        lda     #$b1
        sta     hNMITIMEN
@00ec:  lda     $24                     ; wait for vblank
        beq     @00ec
        stz     $24
        lda     $11f6
        bit     #$10
        beq     @00fc
        jsr     AirshipLiftOffAnim2
@00fc:  shorta
        lda     $11f6                   ; disable battle
        and     #$fd
        sta     $11f6
        bit     #$01
        bne     @010d
        jsr     ShowMinimap
@010d:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @010d
        lda     #$02
        sta     hBGMODE                 ; bg mode 2
@011c:  lda     $24                     ; wait for vblank
        beq     @011c
        stz     $24

; start of main loop
@0122:  shorta
        lda     #$02
        sta     hBGMODE                 ; bg mode 2
        lda     $1f64
        cmp     #$02
        beq     @0134
        lda     #$03                    ; WoB or WoR
        bra     @0136
@0134:  lda     #$83                    ; serpent trench
@0136:  sta     hCGADSUB
        jsl     UpdateCtrlField_ext
        lda     $70
        sta     hBG2HOFS
        lda     $71
        sta     hBG2HOFS
        jsr     TfrBG3Tilemap
        jsr     UpdateBG2HScrollHDMA
        longa
        lda     #$00e0                  ; set irq scanline for bg mode switch
        sec
        sbc     $87
        sta     hVTIMEL
        jsr     MoveVehicle

; battle
        lda     $11f6
        bit     #$0002
        beq     @01cb                   ; branch if battle is not enabled
        jsr     VehicleBattleEffect
        shorta
        jsr     PushDP
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        php
        phb
        jsl     Battle_ext
        plb
        plp
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     $1dd1
        bit     #$01
        jne     GameOver                ; branch if party lost the battle
        lda     $11f6
        bit     #$20
        beq     @01c8
        lda     $1dd2
        bit     #$01
        beq     @01be
        lda     f:VehicleEvent_06       ; ca/0096 (doom gaze defeated)
        sta     f:$0011fd               ; set world map event pointer
        lda     f:VehicleEvent_06+1
        sta     f:$0011fe
        lda     f:VehicleEvent_06+2
        clc
        adc     #$4a
        sta     f:$0011ff
@01be:  lda     $11f6
        and     #$df
        ora     #$40
        sta     $11f6
@01c8:  jmp     ReloadMap

; no battle
@01cb:  longa
        lda     $83
        bpl     @01d4
        not_a
@01d4:  lsr
        clc
        adc     $85
        sta     $87
        jsr     UpdateGradientSprites
        jsr     UpdateMode7Rot
        jsr     UpdateSpriteAnim
        jsr     DrawVehicleSprites
        lda     $11f6
        bit     #$0001
        bne     @01f1
        jsr     DrawMinimapPos
@01f1:  lda     $20
        cmp     #$0004
        beq     @0200                   ; branch if serpent trench
        jsr     UpdateTilemap256
        jsr     UpdateWaterAnim
        bra     @0203
@0200:  jsr     UpdateTilemap128
@0203:  shorta
        lda     $19
        cmp     #$ff
        bne     @0211
        jsr     FadeOutVehicle
        jmp     ExitVehicle
@0211:  lda     $19
        beq     @0238
        bit     #$01
        beq     @021c
        jsr     _ee1c56
@021c:  lda     $19
        and     #$04
        cmp     #$04
        bne     @0238
        lda     $11f6
        ora     #$1c
        sta     $11f6
        lda     $20
        cmp     #$02
        beq     @0235
        jsr     AirshipLandingAnim1
@0235:  jmp     ExitVehicle
@0238:  lda     a:$0024
        beq     @0238
        stz     a:$0024
        lda     $23
        cmp     $22
        beq     @024c
        bcs     @024b
        inc
        bra     @024c
@024b:  dec
@024c:  sta     $23
        jmp     @0122

; ------------------------------------------------------------------------------

; [ world map (no vehicle) ]

WorldMain:
@0251:  jsr     InitWorldHDMA
        jsr     InitWorldSprites
        jsr     InitWorldSpriteMSB
        jsr     ClearBG1Tilemap
        jsr     LoadAnimFrames
        jsr     ClearAnimData
        longa
        lda     #$8000
        sta     $44
        sta     $46
        lda     #$0020
        sta     $93
        lda     #$0000
        sta     $73
        lda     #$9000
        sta     $8b
        sta     $91
        lda     #$8fff
        sta     $8d
        lda     #$ffff
        sta     $8f
        lda     #$000f
        sta     $22
        stz     $23
        lda     $83
        bpl     @0296
        neg_a
@0296:  lsr
        clc
        adc     $85
        sta     $87
        shorta
        ldy     #$0000
        lda     f:$0011fd
        beq     @02a8
        iny
@02a8:  sta     $ea
        lda     f:$0011fe
        beq     @02b1
        iny
@02b1:  sta     $eb
        lda     f:$0011ff
        beq     @02ba
        iny
@02ba:  sta     $ec
        cpy     #$0000
        beq     @02db
        stz     $ed
        stz     $ee
        bit     #$80
        bne     @02d3
        ora     #$80
        sta     $ec
        lda     $e7
        ora     #$41
        bra     @02d9
@02d3:  lda     $e7
        ora     #$01
        and     #$bf
@02d9:  sta     $e7
@02db:  lda     $0205
        cmp     #$02
        bne     @0304       ; branch if tent was not used
        lda     f:VehicleEvent_01     ; event pointer for tent (world map)
        sta     $ea
        lda     f:VehicleEvent_01+1
        sta     $eb
        lda     f:VehicleEvent_01+2
        clc
        adc     #^EventScript
        sta     $ec
        stz     $ed
        stz     $ee
        lda     $e7
        ora     #$41
        sta     $e7
        stz     $0205
@0304:  lda     #$04
        sta     $58
        ldy     #$0000
@030b:  lda     $1850,y
        bit     #$40
        beq     @0329
        and     #$07
        cmp     $1a6d
        bne     @0329
        lda     $1850,y
        lsr3
        and     #$03
        cmp     $58
        bcs     @0329
        sta     $58
        sty     $5a
@0329:  iny
        cpy     #$0010
        bne     @030b
        lda     $5a
        sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     $1601,x
        sta     $11fb
        ldx     $5a
        lda     $1f70,x
        lsr
        sta     $11fc
        shorta
        lda     #$c8
        sta     hHTIMEL
        stz     hHTIMEH
        lda     #$90
        sta     hVTIMEL
        stz     hVTIMEH
        shorta
@0362:  cmp     hRDNMI
        lda     hHVBJOY
        bit     #$80
        beq     @0362
        cli
        lda     #$80
        sta     hINIDISP
        lda     #$b1
        sta     hNMITIMEN
@0377:  lda     a:$0024
        beq     @0377
        stz     a:$0024
        lda     $11f6
        bit     #$10
        beq     @0389
        jsr     AirshipLandingAnim2
@0389:  lda     $11f6
        bit     #$01
        bne     @0393
        jsr     ShowMinimap
@0393:  longa

; start of main loop
@0395:  shorta
        lda     $20
        cmp     #$04
        bne     @03a1                   ; branch if not serpent trench
        lda     #$a3
        bra     @03a3
@03a1:  lda     #$63
@03a3:  sta     hCGADSUB
        jsl     UpdateCtrlField_ext
        jsr     MovePlayer

; open menu
        lda     $e9
        bit     #$10
        bne     @03f2
        lda     $e8
        bit     #$01
        beq     @03f2
        jsr     FadeOut
        lda     #$8f
        sta     hINIDISP
        sei
        stz     hHDMAEN
        stz     $0200
        lda     #$80
        sta     $0201
        stz     hNMITIMEN
        stz     $11fd
        stz     $11fe
        stz     $11ff
        lda     $e0
        sta     $1f60
        lda     $e2
        sta     $1f61
        lda     $f6
        sta     $1f68
        jsr     PopMode7Vars
        jsl     OpenMenu_ext
        jmp     ReloadMap

; enter airship
@03f2:  lda     $e9
        and     #$ef
        sta     $e9
        lda     $e8
        bit     #$40
        beq     @042b
        lda     $11f6
        ora     #$10
        sta     $11f6
        jsr     AirshipLiftOffAnim1
        lda     #$8f
        sta     hINIDISP
        sei
        stz     hHDMAEN
        stz     $11fd
        stz     $11fe
        stz     $11ff
        lda     $e0
        sta     $1f60
        lda     $e2
        sta     $1f61
        jsr     PopMode7Vars
        jmp     InitAirship

; eaten by zone eater
@042b:  shorta
        lda     $e8
        bit     #$10
        beq     @045f
        lda     $1dd1
        bit     #$01
        jne     GameOver
        bit     #$80
        beq     @045c
        lda     f:VehicleEvent_05     ; ca/008f (enter gogo's lair)
        sta     f:$0011fd
        lda     f:VehicleEvent_05+1
        sta     f:$0011fe
        lda     f:VehicleEvent_05+2
        clc
        adc     #$4a        ; interesting, they use $4a instead of $ca here
        sta     f:$0011ff
@045c:  jmp     ReloadMap

@045f:  longai
        lda     #$00e0
        sta     $87
        jsr     UpdateMode7Vars
        lda     $e9
        ora     #$0004
        sta     $e9
        jsr     UpdateSpriteAnim
        jsr     DrawWorldSprites
        lda     $11f6
        bit     #$0001
        bne     @0481                   ; branch if minimap is hidden
        jsr     DrawMinimapPos
@0481:  jsr     UpdateTilemap256
        jsr     UpdateWaterAnim
        shorta
        lda     $19
        beq     @049a
        bmi     @0494
        jsr     FadeOut
        bra     @0497
@0494:  jsr     FadeOutSlow
@0497:  jmp     ExitWorld
@049a:  lda     $24                     ; wait for vblank
        beq     @049a
        stz     $24
        lda     $23                     ; update screen brightness
        cmp     $22
        beq     @04ac
        bcs     @04ab
        inc
        bra     @04ac
@04ab:  dec
@04ac:  sta     $23
        jmp     @0395

; ------------------------------------------------------------------------------

; [ magitek train ride ]

TrainMain:
@04b1:  shorta
        longi
        jsr     InitWorldSprites
        jsr     InitTrainSpriteMSB
        lda     #$0f
        sta     $22                     ; target screen brightness
        stz     $23                     ; current screen brightness
        stz     $24                     ; clear vblank flag
        lda     $11f6                   ; disable battle
        and     #$fd
        sta     $11f6
        lda     #$d0                    ; set vertical irq counter to 208
        sta     hVTIMEL
        stz     hVTIMEH
        lda     #$40                    ; set horizontal irq counter to 64
        sta     hHTIMEL
        stz     hHTIMEH
        cmp     hTIMEUP                 ; clear irq
        lda     #$01
        sta     hTM                     ; enable bg1 in main screen
        stz     hTS                     ; disable all layers in subscreen
        shorta
@04e8:  cmp     hRDNMI                  ; clear nmi
        lda     hHVBJOY
        bit     #$80
        beq     @04e8                   ; wait for vblank
        lda     #$00
        sta     hINIDISP                ; clear screen brightness
        lda     #$b1
        sta     hNMITIMEN               ; enable interrupts
        cli

; start of main loop (@ 15 Hz, every 4 frames)
@04fd:  shorta
        jsl     UpdateCtrlField_ext
        jsr     ExecTrainCmd
        jsr     UpdateTrainGfx
        lda     $11f6
        bit     #$02
        beq     @0545                   ; branch if battle is not enabled

; battle
        jsr     TrainBattleMosaic
        shorta
        jsr     PushDP
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        php
        phb
        jsl     Battle_ext
        plb
        plp
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     $1dd1
        bit     #$01
        jne     GameOver                ; branch if party lost the battle
        jmp     MagitekTrain            ; re-init magitek train ride

; no battle
@0545:  lda     $19
        beq     @0550                   ; branch if not fading out
        lda     $23
        jeq     ExitTrain               ; exit when fade out is done
@0550:  shorta
@0552:  lda     $fa
        cmp     #4
        bcc     @0552                   ; wait 4 frames

; update screen brightness
        lda     $23
        cmp     $22
        beq     @0564
        bcs     @0563
        inc
        bra     @0564
@0563:  dec
@0564:  sta     $23
        jmp     @04fd

; ------------------------------------------------------------------------------

; [ init hdma tables (vehicle) ]

InitVehicleHDMA:
@0569:  shorta
        lda     #$fc                    ; first 124 scanlines
        sta     $9f
        sta     $a6
        sta     $ad
        sta     $b4
        sta     $7e6000
        sta     $7e6207
        lda     #$e4                    ; remaining 100 scanlines
        sta     $a2
        sta     $a9
        sta     $b0
        sta     $b7
        sta     $7e6003
        sta     $7e620a
        stz     $a5                     ; hdma table terminator
        stz     $ac
        stz     $b3
        stz     $ba
        clr_a
        sta     $7e6006
        sta     $7e620d
        longa
        lda     #$009f
        sta     $4342
        lda     #$00a6
        sta     $4352
        lda     #$00ad
        sta     $4362
        lda     #$00b4
        sta     $4372
        lda     #$00bb
        sta     $4312
        lda     #$6000
        sta     $4322
        lda     #$6207
        sta     $4332
        lda     #$6007
        sta     $7e6001
        lda     #$60ff
        sta     $7e6004
        lda     #$620e
        sta     $7e6208
        lda     #$63fe
        sta     $7e620b
        shorta
        lda     #$42                    ; indirect, write twice
        sta     $4340
        sta     $4350
        sta     $4360
        sta     $4370
        lda     #<hM7A
        sta     $4341
        lda     #<hM7B
        sta     $4351
        lda     #<hM7C
        sta     $4361
        lda     #<hM7D
        sta     $4371
        stz     $4344
        stz     $4354
        stz     $4364
        stz     $4374
        stz     $4347
        stz     $4357
        stz     $4367
        stz     $4377
        lda     #$42                    ; indirect, write twice
        sta     $4310
        lda     #<hBG2HOFS
        sta     $4311
        stz     $4314
        lda     #$7e
        sta     $4317
        lda     #$42                    ; indirect, write twice
        sta     $4320
        lda     #<hCOLDATA
        sta     $4321
        lda     #$7e
        sta     $4324
        lda     #$7e
        sta     $4327
        lda     #$44                    ; indirect, write 4 registers
        sta     $4330
        lda     #<hWH0
        sta     $4331
        lda     #$7e
        sta     $4334
        lda     #$7e
        sta     $4337
        rts

; ------------------------------------------------------------------------------

; [ init hdma tables (no vehicle) ]

InitWorldHDMA:
@065f:  shorta
        lda     #$fc                    ; 124 scanlines
        sta     $9f
        sta     $a6
        sta     $ad
        sta     $b4
        sta     $7e6000
        sta     $7e6207
        lda     #$e4                    ; 100 scanlines
        sta     $a2
        sta     $a9
        sta     $b0
        sta     $b7
        sta     $7e6003
        sta     $7e620a
        stz     $a5                     ; hdma table terminator
        stz     $ac
        stz     $b3
        stz     $ba
        clr_a
        sta     $7e6006
        sta     $7e620d
        longa
        lda     #$009f
        sta     $4342
        lda     #$00a6
        sta     $4352
        lda     #$00ad
        sta     $4362
        lda     #$00b4
        sta     $4372
        lda     #$6000
        sta     $4322
        lda     #$6207
        sta     $4332
        lda     #$6007
        sta     $7e6001
        lda     #$60ff
        sta     $7e6004
        lda     #$620e
        sta     $7e6208
        lda     #$63fe
        sta     $7e620b
        shorta
        lda     #$42
        sta     $4340
        sta     $4350
        sta     $4360
        sta     $4370
        lda     #<hM7A
        sta     $4341
        lda     #<hM7B
        sta     $4351
        lda     #<hM7C
        sta     $4361
        lda     #<hM7D
        sta     $4371
        stz     $4344
        stz     $4354
        stz     $4364
        stz     $4374
        stz     $4347
        stz     $4357
        stz     $4367
        stz     $4377
        lda     #$42
        sta     $4320
        lda     #<hCOLDATA
        sta     $4321
        lda     #$7e
        sta     $4324
        lda     #$7e
        sta     $4327
        lda     #$44
        sta     $4330
        lda     #<hWH0
        sta     $4331
        lda     #$7e
        sta     $4334
        lda     #$7e
        sta     $4337
        rts

; ------------------------------------------------------------------------------

; [ init offset-per-tile data ]

; generates a 32x32 byte array for calculating the rotation of the backdrop
; area when turning in the airship. each row is a linear interpolation from
; zero to N where N is the index of that row.

InitOffsetPerTileData:
@073d:  longa
        longi
        lda     #1
        sta     $66
        ldx     #0
@0749:  ldy     #32
        lda     #.loword(-32)
        sta     $58
        stz     $5a
@0753:  lda     $66
        asl
        clc
        adc     $58
        cmp     #32
        bmi     @0764
        inc     $5a
        sec
        sbc     #32*2
@0764:  sta     $58

; store a 16-bit value, but the high byte gets overwritten by next value
        lda     $5a
        sta     $7eb862,x
        inx                             ; next value
        dey
        bne     @0753
        inc     $66                     ; next row
        lda     $66
        cmp     #32
        bne     @0749
        rts

; ------------------------------------------------------------------------------

; [ set bg3 tilemap in vram ]

; this sets the high byte to set up offset-per-tile scrolling

InitBG3Tilemap:
@077a:  shorta
        longi
        lda     #$80
        sta     hVMAINC
        ldx     #$4c00
        stx     hVMADDL
        lda     #$40                    ; affect bg2
        ldx     #$0020
@078e:  stz     hVMDATAH
        dex
        bne     @078e
        ldx     #$0020
@0797:  sta     hVMDATAH
        dex
        bne     @0797
        rts

; ------------------------------------------------------------------------------

; [ clear bg1 tilemap in vram ]

ClearBG1Tilemap:
@079e:  ldx     #$4000
        stx     hVMADDL
        ldx     #$0000
        ldy     #$0400
@07aa:  stx     hVMDATAL
        dey
        bne     @07aa
        ldx     #$5000
        stx     hVMADDL
        ldx     #$0000
        ldy     #$0020
@07bc:  stx     hVMDATAL
        dey
        bne     @07bc
        rts

; ------------------------------------------------------------------------------
