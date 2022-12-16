
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world.asm                                                            |
; |                                                                            |
; | description: world map program                                             |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.include "world_data.asm"

.import LoadMapCharGfx_ext, CheckBattleWorld_ext, DoPoisonDmg_ext
.import OpenMenu_ext, UpdateCtrlField_ext, EndingAirshipScene_ext
.import IncGameTime_ext
.import Battle_ext
.import ExecSound_ext

.import RNGTbl
.import ShortEntrancePtrs, EventTriggerPtrs
.import EventBattleGroup

.export LoadWorld_ext, UpdateMode7Vars_ext, UpdateMode7Rot_ext
.export PushMode7Vars_ext, PopMode7Vars_ext, UpdateMode7Circle_ext
.export MagitekTrain_ext, EndingAirshipScene2_ext

; ------------------------------------------------------------------------------

.segment "world_code"
.a8
.i16

; ------------------------------------------------------------------------------

LoadWorld_ext:
@0000:  jmp     LoadWorld

UpdateMode7Vars_ext:
@0003:  jmp     UpdateMode7Vars_far

UpdateMode7Rot_ext:
@0006:  jmp     UpdateMode7Rot_far

PushMode7Vars_ext:
@0009:  jmp     PushMode7Vars_far

PopMode7Vars_ext:
@000c:  jmp     PopMode7Vars_far

UpdateMode7Circle_ext:
@000f:  jmp     UpdateMode7Circle_far

MagitekTrain_ext:
@0012:  jmp     MagitekTrain

EndingAirshipScene2_ext:
@0015:  jmp     EndingAirshipScene2

; ------------------------------------------------------------------------------

; [ world map (with vehicle) ]

VehicleMain:
@0018:  jsr     _ee0569
        jsr     _ee073d
        jsr     _ee077a
        jsr     _ee3fc4
        jsr     _ee4032
        jsr     _ee079e
        jsr     _ee5711
        jsr     _ee4118
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
        eor     #$ffff
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
@00ec:  lda     $24
        beq     @00ec
        stz     $24
        lda     $11f6
        bit     #$10
        beq     @00fc
        jsr     _ee9543
@00fc:  shorta
        lda     $11f6       ; disable battle
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
        sta     hBGMODE     ; screen mode 2
@011c:  lda     $24
        beq     @011c
        stz     $24
@0122:  shorta
        lda     #$02
        sta     hBGMODE     ; screen mode 2
        lda     $1f64
        cmp     #$02
        beq     @0134
        lda     #$03
        bra     @0136
@0134:  lda     #$83
@0136:  sta     hCGADSUB
        jsl     UpdateCtrlField_ext
        lda     $70
        sta     hBG2HOFS
        lda     $71
        sta     hBG2HOFS
        jsr     _ee39ff
        jsr     _ee37b6
        longa
        lda     #$00e0
        sec
        sbc     $87
        sta     hVTIMEL
        jsr     _ee1998
        lda     $11f6
        bit     #$0002
        beq     @01cb       ; branch if battle is not enabled
        jsr     WorldBattleMosaic
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
        beq     @0195       ; branch if party won the battle
        jmp     GameOver
@0195:  lda     $11f6
        bit     #$20
        beq     @01c8
        lda     $1dd2
        bit     #$01
        beq     @01be
        lda     f:VehicleEvent_06     ; ca/0096 (doom gaze defeated)
        sta     f:$0011fd     ; set world map event pointer
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
@01cb:  longa
        lda     $83
        bpl     @01d4
        eor     #$ffff
@01d4:  lsr
        clc
        adc     $85
        sta     $87
        jsr     _ee3888
        jsr     UpdateMode7Rot
        jsr     _ee43bd
        jsr     _ee427c
        lda     $11f6
        bit     #$0001
        bne     @01f1
        jsr     DrawMinimapPos
@01f1:  lda     $20
        cmp     #$0004
        beq     @0200
        jsr     _ee3363
        jsr     _eeaaad
        bra     @0203
@0200:  jsr     _ee358b
@0203:  shorta
        lda     $19
        cmp     #$ff
        bne     @0211
        jsr     _ee22d7
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
        jsr     _ee9653
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
@0251:  jsr     _ee065f
        jsr     _ee4015
        jsr     _ee40be
        jsr     _ee079e
        jsr     _ee5711
        jsr     _ee4118
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
        eor     #$ffff
        inc
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
        adc     #$ca
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
        jsr     _ee9776
@0389:  lda     $11f6
        bit     #$01
        bne     @0393
        jsr     ShowMinimap
@0393:  longa
@0395:  shorta
        lda     $20
        cmp     #$04
        bne     @03a1
        lda     #$a3
        bra     @03a3
@03a1:  lda     #$63
@03a3:  sta     hCGADSUB
        jsl     UpdateCtrlField_ext
        jsr     _ee1d0e
        lda     $e9
        bit     #$10
        bne     @03f2
        lda     $e8
        bit     #$01
        beq     @03f2
        jsr     _ee2292
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
@03f2:  lda     $e9
        and     #$ef
        sta     $e9
        lda     $e8
        bit     #$40
        beq     @042b
        lda     $11f6
        ora     #$10
        sta     $11f6
        jsr     _ee94d4
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
@042b:  shorta
        lda     $e8
        bit     #$10
        beq     @045f
        lda     $1dd1
        bit     #$01
        beq     @043d
        jmp     GameOver
@043d:  bit     #$80
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
        jsr     _ee43bd
        jsr     _ee4302
        lda     $11f6
        bit     #$0001
        bne     @0481
        jsr     DrawMinimapPos
@0481:  jsr     _ee3363
        jsr     _eeaaad
        shorta
        lda     $19
        beq     @049a
        bmi     @0494
        jsr     _ee2292
        bra     @0497
@0494:  jsr     _ee22b6
@0497:  jmp     ExitWorld
@049a:  lda     $24
        beq     @049a
        stz     $24
        lda     $23
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
        jsr     _ee4015
        jsr     _ee4074
        lda     #$0f
        sta     $22         ; target screen brightness
        stz     $23         ; current screen brightness
        stz     $24         ; clear vblank flag
        lda     $11f6       ; disable battle
        and     #$fd
        sta     $11f6
        lda     #$d0        ; set vertical irq counter to 208
        sta     hVTIMEL
        stz     hVTIMEH
        lda     #$40        ; set horizontal irq counter to 64
        sta     hHTIMEL
        stz     hHTIMEH
        cmp     hTIMEUP       ; clear irq
        lda     #$01
        sta     hTM         ; enable bg1 in main screen
        stz     hTS         ; disable all layers in subscreen
        shorta
@04e8:  cmp     hRDNMI       ; clear nmi
        lda     hHVBJOY
        bit     #$80
        beq     @04e8       ; wait for vblank
        lda     #$00
        sta     hINIDISP    ; clear screen brightness
        lda     #$b1
        sta     hNMITIMEN       ; enable nmi, horizontal irq, vertical irq, and joypad
        cli
@04fd:  shorta
        jsl     UpdateCtrlField_ext
        jsr     ExecTrainCmd
        jsr     _ee9f14       ; update magitek train ride graphics
        lda     $11f6
        bit     #$02
        beq     @0545       ; branch if battle is not enabled
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
        beq     @0542       ; branch if party didn't lose the battle
        jmp     GameOver
@0542:  jmp     MagitekTrain       ; init magitek train ride
@0545:  lda     $19
        beq     @0550       ; branch if fade out is disabled
        lda     $23
        bne     @0550       ; branch if current screen brightness is not zero
        jmp     ExitTrain
@0550:  shorta
@0552:  lda     $fa
        cmp     #$04
        bcc     @0552       ; wait 4 frames
        lda     $23
        cmp     $22
        beq     @0564       ; branch if screen brightness has reached target
        bcs     @0563       ; branch if screen brightness is greater than target
        inc                 ; increment screen brightness
        bra     @0564
@0563:  dec                 ; decrement screen brightness
@0564:  sta     $23
        jmp     @04fd

; ------------------------------------------------------------------------------

; [  ]

_ee0569:
sethdma0:
@0569:  shorta
        lda     #$fc
        sta     $9f
        sta     $a6
        sta     $ad
        sta     $b4
        sta     $7e6000
        sta     $7e6207
        lda     #$e4
        sta     $a2
        sta     $a9
        sta     $b0
        sta     $b7
        sta     $7e6003
        sta     $7e620a
        stz     $a5
        stz     $ac
        stz     $b3
        stz     $ba
        tdc
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
        lda     #$42
        sta     $4340
        sta     $4350
        sta     $4360
        sta     $4370
        lda     #$1b
        sta     $4341
        lda     #$1c
        sta     $4351
        lda     #$1d
        sta     $4361
        lda     #$1e
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
        sta     $4310
        lda     #$0f
        sta     $4311
        stz     $4314
        lda     #$7e
        sta     $4317
        lda     #$42
        sta     $4320
        lda     #$32
        sta     $4321
        lda     #$7e
        sta     $4324
        lda     #$7e
        sta     $4327
        lda     #$44
        sta     $4330
        lda     #$26
        sta     $4331
        lda     #$7e
        sta     $4334
        lda     #$7e
        sta     $4337
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee065f:
sethdma1:
@065f:  shorta
        lda     #$fc
        sta     $9f
        sta     $a6
        sta     $ad
        sta     $b4
        sta     $7e6000
        sta     $7e6207
        lda     #$e4
        sta     $a2
        sta     $a9
        sta     $b0
        sta     $b7
        sta     $7e6003
        sta     $7e620a
        stz     $a5
        stz     $ac
        stz     $b3
        stz     $ba
        tdc
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
        lda     #$1b
        sta     $4341
        lda     #$1c
        sta     $4351
        lda     #$1d
        sta     $4361
        lda     #$1e
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
        lda     #$32
        sta     $4321
        lda     #$7e
        sta     $4324
        lda     #$7e
        sta     $4327
        lda     #$44
        sta     $4330
        lda     #$26
        sta     $4331
        lda     #$7e
        sta     $4334
        lda     #$7e
        sta     $4337
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee073d:
makedda:
@073d:  longa
        longi
        lda     #$0001
        sta     $66
        ldx     #$0000
@0749:  ldy     #$0020
        lda     #$ffe0
        sta     $58
        stz     $5a
@0753:  lda     $66
        asl
        clc
        adc     $58
        cmp     #$0020
        bmi     @0764
        inc     $5a
        sec
        sbc     #$0040
@0764:  sta     $58
        lda     $5a
        sta     $7eb862,x
        inx
        dey
        bne     @0753
        inc     $66
        lda     $66
        cmp     #$0020
        bne     @0749
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee077a:
setbg3sc:
@077a:  shorta
        longi
        lda     #$80
        sta     hVMAINC
        ldx     #$4c00
        stx     hVMADDL
        lda     #$40
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

; [  ]

_ee079e:
bg1sccl:
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

; [ vector approach ]

_ee07c3:
doman:
@07c3:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$7e
        pha
        plb
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
        shorta
        tdc
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
        lda     #$7e
        pha
        plb
        jsr     _ee40f0
        longa
        ldx     #$0000
@0850:  shorta
        tdc
        sta     $7e6007,x
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
        sta     $7e6007,x
        lda     $5b
        ora     #$c0
        sta     $7e6008,x
        longa
        inx2
        cpx     #$01c0
        bne     @086e
        lda     #$0092
        sta     $85
        lda     #$00b4
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
        lda     #$0980
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
        tdc
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
        lda     $e9
        ora     #$03
        sta     $e9
        tdc
        pha
        plb
        stz     hW12SEL
        stz     hW34SEL
        lda     #$a0
        sta     hWOBJSEL
        lda     #$02
        sta     hTS
        stz     hTSW
@09c8:  cmp     hRDNMI
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
@09e3:  lda     $24
        beq     @09e3
        stz     $24
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
        longac
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
        jsr     _ee43bd
        jsr     _ee427c
        jsr     _ee3363
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
        jsr     _ee165f
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
        jsr     _ee165f
        longa
        lda     $31
        asl3
        tax
        stz     $60
        lda     $7eb660,x
        clc
        adc     $7eb664,x
        cmp     #$0168
        bcc     @0aa6
        sbc     #$0168
@0aa6:  sta     $7eb660,x
        cmp     #$00b4
        bcc     @0ab4
        sbc     #$00b4
        dec     $60
@0ab4:  phx
        tax
        shorta
        lda     f:WorldSineTbl+1,x
        plx
        lsr3
        sta     $5c
        lda     $60
        bpl     @0acd
        lda     $5c
        eor     #$ff
        inc
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
@0aeb:  lda     $24
        beq     @0aeb
        stz     $24
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
        lda     $7e6b2e
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

_ee0b30:
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
        tdc
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
        cmp     #$0168
        bcc     @0c0d
        sec
        sbc     #$0168
        bra     @0c0d
@0c09:  clc
        adc     #$0168
@0c0d:  sta     $7eb664
@0c11:  clc
        adc     $58
        cmp     #$0168
        bcc     @0c1c
        sbc     #$0168
@0c1c:  sta     $73
        inx
        txa
        sta     $7eb666
        php
        jsr     UpdateMode7Rot
        jsr     _ee3363
        jsr     _ee174e
        plp
        jsr     _eeaaad
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
        beq     @0c67
        jmp     @0ba4
@0c67:  stz     hHDMAEN
        lda     #$0f
        sta     $22
        stz     $23
        rts

; ------------------------------------------------------------------------------

; [ falcon rising out of water ]

_ee0c71:
falcon:
@0c71:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     _ee40f0
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
        jsr     _ee43bd
        jsr     _ee4302
        jsr     _eeaaad
        jsr     _ee174e
        jsr     _ee3363
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
        beq     @0d55
        jmp     @0d0a
@0d55:  shorta
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
falcon_ending:
@0dbc:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     _ee0569
        jsr     _ee3fc4
        jsr     _ee40be
        jsr     _ee5711
        jsr     _ee4118
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
        jsr     _ee43bd
        jsr     _ee4302
        jsr     _ee174e
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
        beq     @0e99
        jmp     @0e54
@0e99:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     PopMode7Vars
        rtl

; ------------------------------------------------------------------------------

; [  ]

_ee0eab:
sabaki1:
@0eab:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     _ee40f0
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
@0f79:  tdc
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
        jsr     _ee165f
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
        jsr     _ee165f
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

; [  ]

_107a:
@107a:  longa
        ldx     #$0000
@107f:  lda     f:_ee100e,x
        sta     $7eb660,x
        inx2
        cpx     #$006c
        bne     @107f
        tdc
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
        tdc
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

; [  ]

_ee1186:
houkai0:
@1186:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$7e
        pha
        plb
        jsr     _ee40f0
        longai
        lda     #$00ff
        ldx     #$0000
@11a3:  sta     $7e620e,x
        inx2
        cpx     #$0700
        bne     @11a3
        shorta
        tdc
        pha
        plb
        longai
        tdc
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
        tdc
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
@12ec:  tdc
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
        beq     @1371
        jmp     @1235
@1371:  shorta
        stz     hHDMAEN
        sei
        rts

; ------------------------------------------------------------------------------

; [ light of judgement ]

_ee1378:
houkai2:
@1378:  shorta
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$40
        sta     $1f6d
        jsr     _ee40f0
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
@141c:  tdc
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
        tdc
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
@14fb:  tdc
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
        tdc
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
        jsr     _ee165f
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
        jsr     _ee165f
        shorta
        jsr     _ee43bd
        jsr     _ee4302
        jsr     _eeaaad
        jsr     _ee174e
        jsr     _ee3363
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
        beq     @15bb
        jmp     @1496
@15bb:  shorta
        lda     #$80
        sta     hINIDISP
        stz     hHDMAEN
        sei
        rts

; ------------------------------------------------------------------------------

; [  ]

; vehicle event command $f6

_ee15c7:
@15c7:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longa
        ldx     #$0000
        ldy     #$0000
@15d7:  shorta
        lda     $e000,x
        and     #$1f
        sta     $be62,y
        longa
        lda     $e000,x
        lsr5
        and     #$001f
        shorta
        sta     $bee2,y
        lda     $e001,x
        lsr2
        and     #$1f
        sta     $bf62,y
        inx2
        iny
        cpy     #$0080
        bne     @15d7
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee1608:
@1608:  php
        phb
        shortai
        lda     #$7e
        pha
        plb
        ldx     #$fe
        ldy     #$00
@1614:  shorta
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
        bne     @1614
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee165f:
@165f:  shorta
        lda     #$ff
        sta     $5c
        lda     $58
        sec
        sbc     $5a
        bcs     @1673
        inc     $5c
        inc     $5c
        eor     #$ff
        inc
@1673:  sta     $5e
        lda     #$ff
        sta     $5d
        lda     $59
        sec
        sbc     $5b
        bcs     @1687
        inc     $5d
        inc     $5d
        eor     #$ff
        inc
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
        sta     $7e620e,x
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
        sta     $7e620e,x
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
@1711:  tdc
@1712:  cpx     $62
        beq     @1720
        sta     $7e620e,x
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
@1740:  tdc
@1741:  sta     $7e620e,x
        inx4
        cpx     $62
        bcc     @1741
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee174e:
movth:
@174e:  php
        phb
        shorta
        tdc
        pha
        plb
        longa
        shorti
        lda     $1e
        bit     #$0020
        beq     @1764
        lda     $75
        bra     @1766
@1764:  lda     $73
@1766:  cmp     #$00b4
        bcc     @176e
        sbc     #$00b4
@176e:  tax
        lda     f:WorldSineTbl+1,x
        sta     $9b
        lda     f:WorldSineTbl+91,x
        sta     $9d
        lda     $1e
        bit     #$0020
        beq     @1786
        lda     $75
        bra     @1788
@1786:  lda     $73
@1788:  cmp     #$00b4
        bcc     @17a2
        ldx     #$00
        stx     $5b
        cmp     #$010e
        bcc     @179c
@1796:  ldx     #$01
        stx     $5a
        bra     @17ad
@179c:  ldx     #$00
        stx     $5a
        bra     @17ad
@17a2:  ldx     #$01
        stx     $5b
        cmp     #$005a
        bcc     @1796
        bra     @179c
@17ad:  stz     $6b
        ldx     $9d
        stx     hWRMPYA
        ldx     $26
        stx     hWRMPYB
        nop3
        lda     hRDMPYL
        sta     $6a
        ldx     $27
        stx     hWRMPYB
        nop3
        lda     hRDMPYL
        clc
        adc     $6b
        sta     $6a
        ldx     $5a
        bne     @17ea
        clc
        adc     $37
        sta     $37
        lda     $39
        adc     #$0000
        sta     $39
        clc
        lda     $40
        adc     $6a
        sta     $40
        bra     @1801
@17ea:  sta     $6a
        lda     $37
        sec
        sbc     $6a
        sta     $37
        lda     $39
        sbc     #$0000
        sta     $39
        sec
        lda     $40
        sbc     $6a
        sta     $40
@1801:  ldx     $9b
        stx     hWRMPYA
        ldx     $26
        stx     hWRMPYB
        nop3
        lda     hRDMPYL
        sta     $6a
        ldx     $27
        stx     hWRMPYB
        nop3
        lda     hRDMPYL
        clc
        adc     $6b
        sta     $6a
        ldx     $5b
        bne     @183c
        clc
        adc     $33
        sta     $33
        lda     $35
        adc     #$0000
        sta     $35
        clc
        lda     $3c
        adc     $6a
        sta     $3c
        bra     @1853
@183c:  sta     $6a
        lda     $33
        sec
        sbc     $6a
        sta     $33
        lda     $35
        sbc     #$0000
        sta     $35
        sec
        lda     $3c
        sbc     $6a
        sta     $3c
@1853:  lda     $34
        and     #$0fff
        sta     $34
        lda     $38
        and     #$0fff
        sta     $38
        plb
        plp
        rts

.a8

; ------------------------------------------------------------------------------

; [ update poison mosaic effect ]

PoisonMosaic:
@1864:  lda     $ff
        beq     @186d
        sec
        sbc     #$08
        sta     $ff
@186d:  and     #$f0
        ora     #$01
        sta     hMOSAIC
        rts

; ------------------------------------------------------------------------------

; [ world map battle mosaic effect ]

WorldBattleMosaic:
@1875:  php
        shorta
        lda     #$80
        sta     hAPUIO2
        lda     #$c1
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
@1887:  lda     $24
        beq     @1887
        stz     $24
        lda     #$28
        sta     $66
@1891:  shorta
        lda     #$02
        sta     hBGMODE
        lda     $1f64
        cmp     #$02
        beq     @18a3
        lda     #$03
        bra     @18a5
@18a3:  lda     #$83
@18a5:  sta     hCGADSUB
        longa
        lda     #$00e0
        sec
        sbc     $87
        sta     hVTIMEL
        shorta
        lda     $23
        beq     @18ba
        dec
@18ba:  sta     $23
@18bc:  lda     $24
        beq     @18bc
        stz     $24
        dec     $66
        bne     @1891
        lda     $e8
        and     #$7f
        sta     $e8
        plp
        rts

; ------------------------------------------------------------------------------

; [ battle blur and sound effect (magitek train) ]

TrainBattleMosaic:
@18ce:  php
        shorta
        longi
        lda     #$80
        sta     hAPUIO2
        lda     #$c1
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
        ldx     #$0000
        lda     #$01
        sta     $66
@18e9:  dec     $66
        bne     @18f9
        lda     #$01
        sta     $66
        lda     f:TrainBattleMosaicTbl,x
        inx
        sta     hMOSAIC
@18f9:  cmp     #$ff
        beq     @1905
@18fd:  lda     $fa
        beq     @18fd
        stz     $fa
        bra     @18e9
@1905:  plp
        rts

; ------------------------------------------------------------------------------

; battle blur data
TrainBattleMosaicTbl:
@1907:  .byte   $0f,$1f,$2f,$3f,$4f,$5f,$6f,$7f,$8f,$9f,$af,$bf,$cf,$cf,$bf,$af
        .byte   $9f,$8f,$7f,$6f,$5f,$4f,$3f,$2f,$1f,$0f,$1f,$2f,$3f,$4f,$5f,$6f
        .byte   $7f,$8f,$9f,$af,$bf,$cf,$df,$ef,$ff

; ------------------------------------------------------------------------------

; [  ]

_ee1930:
cc_grad:
@1930:  php
        longai
        lda     #$1200
        sta     $58
        lda     #$0900
        sta     $5a
        ldx     #$0000
@1940:  shorta
        lda     $59
        ora     #$80
        sta     $7e6007,x
        lda     $5b
        ora     #$60
        sta     $7e6008,x
        inx2
        longa
        lda     $58
        sec
        sbc     #$0020
        sta     $58
        lda     $5a
        sec
        sbc     #$0010
        sta     $5a
        bne     @1940
        tdc
@1969:  cpx     #$0200
        beq     @1976
        sta     $7e6007,x
        inx2
        bra     @1969
@1976:  plp
        rts

; ------------------------------------------------------------------------------

; [ update mode 7 variables (far) ]

UpdateMode7Vars_far:
@1978:  jsr     UpdateMode7Vars
        shorta
        longi
        rtl

; ------------------------------------------------------------------------------

; [ update mode 7 rotation (far) ]

UpdateMode7Rot_far:
@1980:  jsr     UpdateMode7Rot
        shorta
        longi
        rtl

; ------------------------------------------------------------------------------

; [  ]

UpdateMode7Circle_far:
@1988:  jsr     UpdateMode7Circle
        shorta
        longi
        rtl

; ------------------------------------------------------------------------------

; [ save mode 7 variables (far) ]

PushMode7Vars_far:
@1990:  jsr     PushMode7Vars
        rtl

; ------------------------------------------------------------------------------

; [ restore mode 7 variables (far) ]

PopMode7Vars_far:
@1994:  jsr     PopMode7Vars
        rtl

; ------------------------------------------------------------------------------

; [  ]

_ee1998:
control:
@1998:  longa
        longi
        lda     $1f64
        and     #$01ff
        cmp     #$0001
        beq     @19ab
        stz     $64
        bra     @19b0
@19ab:  lda     #$0200
        sta     $64
@19b0:  lda     $38
        asl4
        and     #$ff00
        sta     $58
        lda     $34
        lsr4
        clc
        adc     $58
        tax
        lda     $7f0000,x
        and     #$00ff
        sta     $c4
        asl
        clc
        adc     $64
        tax
        lda     f:WorldTileProp,x   ; tile properties
        sta     $c2
        lda     $34
        sta     $c6
        lda     $38
        sta     $c8
        lda     $e7
        bit     #$0001
        beq     @19f2
        stz     $60
        jsr     ExecVehicleCmd
        jsr     _ee75d3
        bra     @1a03
@19f2:  lda     $e7
        bit     #$0001
        bne     @1a03
        lda     $1e
        bit     #$0001
        bne     @1a03
        jsr     _ee6bec
@1a03:  shorta
        lda     $e8
        bit     #$04
        beq     @1a27       ; branch if serpent trench arrows are not shown
        lda     $05
        bit     #$01
        beq     @1a1b       ; branch if right direction is not pressed
        lda     $1eb6
        and     #$7f
        sta     $1eb6       ; set serpent trench arrow direction
        bra     @1a27
@1a1b:  bit     #$02
        beq     @1a27       ; branch if left direction is not pressed
        lda     $1eb6
        ora     #$80
        sta     $1eb6       ; set serpent trench arrow direction
@1a27:  longa
        lda     $1e
        bit     #$0002
        bne     @1a52       ;
        shorta
        lda     $72
        clc
        adc     $29
        sta     $72
        longa
        lda     $73
        adc     $2a
        bpl     @1a47
        clc
        adc     #$0168
        bra     @1a50
@1a47:  cmp     #$0168
        bcc     @1a50
        sec
        sbc     #$0168
@1a50:  sta     $73
@1a52:  longa
        lda     $1e
        bit     #$0004
        bne     @1a93
        shorta
        lda     #$6c
        sta     hWRMPYA
        lda     $73
        sta     hWRMPYB
        nop4
        lda     hRDMPYH
        sta     $6a
        stz     $6b
        lda     $74
        sta     hWRMPYB
        nop4
        longa
        lda     hRDMPYL
        clc
        adc     $6a
        adc     $73
        asl
        and     #$01ff
        sta     $58
        lda     #$01ff
        sec
        sbc     $58
        sta     $70
@1a93:  longa
        lda     $1e
        bit     #$0008
        bne     @1ada
        shorti
        lda     $29
        bpl     @1aa5
        eor     #$ffff
@1aa5:  lsr3
        tax
        stx     hWRMPYA
        lda     $26
        lsr4
        tax
        sta     hWRMPYB
        nop3
        ldx     hRDMPYH
        stx     hWRMPYA
        ldx     #$f0
        stx     hWRMPYB
        lda     $29
        bpl     @1ace
        ldx     hRDMPYH
        txa
        bra     @1ad8
@1ace:  ldx     hRDMPYH
        txa
        sta     $58
        tdc
        sec
        sbc     $58
@1ad8:  sta     $83
@1ada:  longa
        shorti
        lda     $1e
        bit     #$0010
        bne     @1b23
        lda     $2d
        bpl     @1aec
        eor     #$ffff
@1aec:  lsr3
        sta     $58
        lda     $26
        lsr4
        shorta
        sta     hWRMPYA
        lda     $58
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        sta     hWRMPYA
        lda     #$f0
        sta     hWRMPYB
        lda     $2e
        bpl     @1b1b
        lda     #$92
        clc
        adc     hRDMPYH
        bra     @1b21
@1b1b:  lda     #$92
        sec
        sbc     hRDMPYH
@1b21:  sta     $85
@1b23:  longa
        lda     $33
        sta     $48
        lda     $35
        sta     $4a
        lda     $37
        sta     $4c
        lda     $39
        sta     $4e
        lda     $3c
        sta     $50
        lda     $3e
        sta     $52
        lda     $40
        sta     $54
        lda     $42
        sta     $56
        jsr     _ee174e
        longa
        lda     $20
        cmp     #$0002
        bne     @1b61
        longi
        jsr     GetTileProp2
        bit     #$0001
        beq     @1b61
        jsr     _ee1cef
        jsr     _ee1b9a
@1b61:  shorti
        lda     $1e
        bit     #$0040
        bne     @1b99
        lda     $2d
        clc
        adc     $2f
        cmp     #$0000
        bmi     @1b7b
        cmp     #$7e01
        bpl     @1b7b
        sta     $2f
@1b7b:  lda     $2f
        clc
        adc     #$3000
        sta     $8b
        ldx     $30
        stx     hWRMPYA
        ldx     #$4f
        stx     hWRMPYB
        nop3
        lda     hRDMPYL
        clc
        adc     #$1800
        sta     $8d
@1b99:  rts

; ------------------------------------------------------------------------------

; [  ]

_ee1b9a:
@1b9a:  php
        longai
        lda     $73
        pha
        beq     @1bb1
        cmp     #$005a
        beq     @1bb1
        cmp     #$00b4
        beq     @1bb1
        cmp     #$010e
        bne     @1bb4
@1bb1:  jmp     @1c4f
@1bb4:  cmp     #$013b
        bcs     @1c14
        cmp     #$010e
        bcs     @1bd7
        cmp     #$00e1
        bcs     @1c14
        cmp     #$00b4
        bcs     @1bd7
        cmp     #$0087
        bcs     @1c14
        cmp     #$005a
        bcs     @1bd7
        cmp     #$002d
        bcs     @1c14
@1bd7:  lda     $73
        clc
        adc     #$005a
        cmp     #$0168
        bcc     @1be6
        sec
        sbc     #$0168
@1be6:  sta     $73
        jsr     _ee174e
        jsr     GetTileProp2
        bit     #$0001
        beq     @1c4f
        jsr     _ee1cef
        pla
        pha
        sec
        sbc     #$005a
        bcs     @1c02
        clc
        adc     #$0168
@1c02:  sta     $73
        jsr     _ee174e
        jsr     GetTileProp2
        bit     #$0001
        beq     @1c4f
        jsr     _ee1cef
        bra     @1c4f
@1c14:  lda     $73
        sec
        sbc     #$005a
        bcs     @1c20
        clc
        adc     #$0168
@1c20:  sta     $73
        jsr     _ee174e
        jsr     GetTileProp2
        bit     #$0001
        beq     @1c4f
        jsr     _ee1cef
        pla
        pha
        clc
        adc     #$005a
        cmp     #$0168
        bcc     @1c3f
        sec
        sbc     #$0168
@1c3f:  sta     $73
        jsr     _ee174e
        jsr     GetTileProp2
        bit     #$0001
        beq     @1c4f
        jsr     _ee1cef
@1c4f:  longa
        pla
        sta     $73
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee1c56:
down:
@1c56:  php
        longa
        lda     $2f
        clc
        adc     $2d
        cmp     #$0000
        bmi     @1c72
        lda     $2d
        sec
        sbc     #$0020
        cmp     #$fe00
        bmi     @1c7e
        sta     $2d
        bra     @1c7e
@1c72:  stz     $2d
        lda     $19
        and     #$00fe
        ora     #$0004
        sta     $19
@1c7e:  plp
        rts

; ------------------------------------------------------------------------------

; [  ]

; unused

_ee1c80:
@1c80:  php
        longa
        lda     $73
        cmp     #$0000
        beq     @1ca9
        cmp     #$00b4
        bcs     @1c98
        dec2
        and     #$0ffe
        sta     $73
        bra     @1cb3
@1c98:  inc2
        and     #$0ffe
        cmp     #$0168
        bne     @1ca5
        lda     #$0000
@1ca5:  sta     $73
        bra     @1cb3
@1ca9:  lda     $19
        and     #$00fd
        ora     #$0008
        sta     $19
@1cb3:  plp
        rts

; ------------------------------------------------------------------------------

; [ get current tile properties ]

GetTileProp2:
@1cb5:  lda     $1f64
        and     #$01ff
        beq     @1cc4
        lda     #$0200
        sta     $64
        bra     @1cc6
@1cc4:  stz     $64
@1cc6:  lda     $38
        asl4
        and     #$ff00
        sta     $58
        lda     $34
        lsr4
        and     #$00ff
        clc
        adc     $58
        tax
        lda     $7f0000,x
        and     #$00ff
        asl
        clc
        adc     $64
        tax
        lda     f:WorldTileProp,x   ; tile properties
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee1cef:
@1cef:  lda     $48
        sta     $33
        lda     $4a
        sta     $35
        lda     $4c
        sta     $37
        lda     $4e
        sta     $39
        lda     $50
        sta     $3c
        lda     $52
        sta     $3e
        lda     $54
        sta     $40
        lda     $56
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee1d0e:
wmmov:
@1d0e:  php
        phb
        longa
        longi
        lda     $38
        asl4
        and     #$ff00
        sta     $58
        lda     $34
        lsr4
        clc
        adc     $58
        tax
        lda     $7f0000,x
        and     #$00ff
        sta     $c4
        asl
        tax
        lda     f:WorldTileProp,x   ; tile properties
        sta     $c2
        lda     $34
        sta     $c6
        lda     $38
        sta     $c8
        shorta
        lda     $df
        bne     @1d4e
        lda     $e1
        bne     @1d4e
        bra     @1d54
@1d4e:  jsr     PoisonMosaic
        jmp     @1e56
@1d54:  longa
        ldx     #0
        ldy     #0
        jsr     GetTileProp
        bit     #$0020
        beq     @1d6b       ; branch if not a forest
        lda     $e7
        ora     #$0010
        sta     $e7
@1d6b:  shorta
        lda     $e7
        bit     #$02
        bne     @1d76
        jmp     @1e1f
@1d76:  lda     $e7
        and     #$fd
        sta     $e7
        lda     $e7
        bit     #$01
        beq     @1d85       ; branch if no event is running
        jmp     @1e1f
@1d85:  jsr     CheckEvent
        jsr     CheckEntrance
        beq     @1d90
        jmp     @1e1f
@1d90:  shorta
        lda     $e8
        bit     #$08
        beq     @1d9b
        jmp     @1e1f
@1d9b:  ora     #$08
        sta     $e8
        lda     $1eb9
        bit     #$20
        bne     @1e1f
        longa
        tdc
        tax
        txy
        jsr     GetTileProp
        shorta
        bit     #$40
        beq     @1e1f       ; branch if battles are disabled
        xba
        sta     $11f9       ; battle bg index
        jsr     PushDP
        jsl     CheckBattleWorld_ext
        cmp     #$00
        beq     @1e1c       ; branch if no random battle
        jsr     PopDP
        stz     $11fd       ; clear event pointer
        stz     $11fe
        stz     $11ff
        lda     f:$000ae0
        sta     $1f60
        lda     f:$000ae2
        sta     $1f61
        lda     $e8
        ora     #$20
        sta     $e8
        jsr     BattleZoom
        jsr     PopMode7Vars
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     $f6
        sta     $1f68       ; facing direction
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
        lda     $e8
        and     #$be
        ora     #$10
        sta     $e8
        stz     $11fa
        jmp     @1eaa
@1e1c:  jsr     PopDP
@1e1f:  lda     $e7
        bit     #$01
        beq     @1e28
        jsr     ExecWorldCmd
@1e28:  lda     $e7
        bit     #$01
        bne     @1e56
        jsr     _ee1ead
        lda     $e7
        bit     #$02
        beq     @1e56
        stz     $11f0
        jsl     DoPoisonDmg_ext
        lda     $11f0
        beq     @1e56
        lda     #$78
        sta     $ff
        lda     #$80
        sta     hAPUIO2
        lda     #$ec
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
@1e56:  longa
        lda     $df
        clc
        adc     $e3
        sta     $df
        lda     $e1
        clc
        adc     $e5
        sta     $e1
        lda     $e3
        bne     @1e77
        lda     $e5
        bne     @1e77
        lda     $e7
        and     #$fff7
        sta     $e7
        bra     @1e7e
@1e77:  lda     $e7
        ora     #$0008
        sta     $e7
@1e7e:  lda     $e3
        asl4
        clc
        adc     $3c
        sta     $3c
        lda     $e5
        asl4
        clc
        adc     $40
        sta     $40
        lda     $df
        lsr4
        and     #$0fff
        sta     $34
        lda     $e1
        lsr4
        and     #$0fff
        sta     $38
@1eaa:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee1ead:
key_mov:
@1ead:  php
        longa
        stz     $e3
        stz     $e5
        lda     $04
        lda     $e7
        and     #$ff7f
        sta     $e7
        lda     $04
        bit     #$0100
        beq     @1f0d
        shortai
        lda     #$01
        sta     $f6
        jsr     _ee47e3
        longai
        lda     $e7
        bit     #$0080
        bne     @1ef9
        ldx     #$0001
        ldy     #$0000
        jsr     GetTileProp
        bit     #$0010
        bne     @1f0a       ; branch if tile is impassable on foot
        bit     #$0020
        beq     @1eeb       ; branch if not a forest
        bra     @1ef2
@1eeb:  lda     $e7
        and     #$ffef
        sta     $e7
@1ef2:  lda     $e7
        ora     #$0002
        sta     $e7
@1ef9:  ldx     #$0010
        stx     $e3
        lda     $e8
        and     #$fff7
        sta     $e8
        jsr     IncSteps
        longa
@1f0a:  jmp     @1ff3
@1f0d:  bit     #$0200
        beq     @1f5b
        shortai
        lda     #$03
        sta     $f6
        jsr     _ee47e3
        longai
        lda     $e7
        bit     #$0080
        bne     @1f47
        ldx     #$ffff
        ldy     #$0000
        jsr     GetTileProp
        bit     #$0010
        bne     @1f58       ; branch if tile is impassable on foot
        bit     #$0020
        beq     @1f39       ; branch if not a forest
        bra     @1f40
@1f39:  lda     $e7
        and     #$ffef
        sta     $e7
@1f40:  lda     $e7
        ora     #$0002
        sta     $e7
@1f47:  ldx     #$fff0
        stx     $e3
        lda     $e8
        and     #$fff7
        sta     $e8
        jsr     IncSteps
        longa
@1f58:  jmp     @1ff3
@1f5b:  bit     #$0400
        beq     @1fa8
        shortai
        lda     #$02
        sta     $f6
        jsr     _ee47e3
        longai
        lda     $e7
        bit     #$0080
        bne     @1f95
        ldx     #$0000
        ldy     #$0001
        jsr     GetTileProp
        bit     #$0010
        bne     @1fa6
        bit     #$0020
        beq     @1f87
        bra     @1f8e
@1f87:  lda     $e7
        and     #$ffef
        sta     $e7
@1f8e:  lda     $e7
        ora     #$0002
        sta     $e7
@1f95:  ldx     #$0010
        stx     $e5
        lda     $e8
        and     #$fff7
        sta     $e8
        jsr     IncSteps
        longa
@1fa6:  bra     @1ff3
@1fa8:  bit     #$0800
        beq     @1ff3
        shortai
        lda     #$00
        sta     $f6
        jsr     _ee47e3
        longai
        lda     $e7
        bit     #$0080
        bne     @1fe2
        ldx     #$0000
        ldy     #$ffff
        jsr     GetTileProp
        bit     #$0010
        bne     @1ff3
        bit     #$0020
        beq     @1fd4
        bra     @1fdb
@1fd4:  lda     $e7
        and     #$ffef
        sta     $e7
@1fdb:  lda     $e7
        ora     #$0002
        sta     $e7
@1fe2:  ldx     #$fff0
        stx     $e5
        lda     $e8
        and     #$fff7
        sta     $e8
        jsr     IncSteps
        longa
@1ff3:  shorta
        lda     #$10
        sta     $f3
        longa
        lda     $e5
        bne     @201f
        lda     $e3
        bne     @201f
        shorta
        lda     $e9
        bit     #$10
        bne     @201f
        lda     $08
        bit     #$40
        beq     @201f
        lda     $e8
        ora     #$01
        sta     $e8
        lda     $11f6
        ora     #$04
        sta     $11f6
@201f:  longa
        lda     $32
        bit     #$0010
        bne     @204e
        lda     $05
        bit     #$0010
        beq     @204e
        lda     $11f6
        bit     #$0001
        bne     @2045
        ora     #$0001
        sta     $11f6
        jsr     HideMinimap
        jsr     HideMinimapPos
        bra     @204e
@2045:  and     #$fffe
        sta     $11f6
        jsr     ShowMinimap
@204e:  lda     $04
        sta     $31
        shorta
        lda     $e8
        bit     #$01
        bne     @20b1
        lda     $e9
        bit     #$04
        beq     @20b1
        lda     $1eb7
        bit     #$02
        beq     @20b1
        lda     $08
        bit     #$80
        beq     @20b1
        lda     $e0
        cmp     $1f62
        bne     @20b1
        lda     $e2
        cmp     $1f63
        bne     @20b1
        lda     $1eb7
        bit     #$04
        bne     @2092
        lda     $e8
        ora     #$40
        sta     $e8
        lda     $11f6
        ora     #$0c
        sta     $11f6
        bra     @20b1
@2092:  lda     f:VehicleEvent_02     ; ca/0059 (enter blackjack, ground entrance)
        sta     $ea
        lda     f:VehicleEvent_02+1
        sta     $eb
        lda     f:VehicleEvent_02+2
        clc
        adc     #$ca
        sta     $ec
        stz     $ed
        stz     $ee
        lda     $e7
        ora     #$41
        sta     $e7
@20b1:  plp
        rts

; ------------------------------------------------------------------------------

; [ increment steps ]

IncSteps:
@20b3:  php
        longa
        lda     $1866       ; increment steps (max 9999999)
        cmp     #$967f
        bne     @20c9
        lda     $1868
        and     #$00ff
        cmp     #$0098
        beq     @20dd
@20c9:  clc
        lda     $1866
        adc     #$0001
        sta     $1866
        shorta
        lda     $1868
        adc     #$00
        sta     $1868
@20dd:  plp
        rts

; ------------------------------------------------------------------------------

; [ check entrance triggers ]

CheckEntrance:
@20df:  php
        longa
        lda     $f4
        and     #$00ff
        asl
        tax
        lda     f:ShortEntrancePtrs,x
        sta     $58
        lda     f:ShortEntrancePtrs+2,x
        sta     $5a
        sec
        sbc     $58
        beq     @216a
        ldx     $58
        shorta
@20fe:  lda     f:ShortEntrancePtrs,x
        cmp     $e0
        bne     @2160
        lda     f:ShortEntrancePtrs+1,x
        cmp     $e2
        bne     @2160
        longa
        lda     f:ShortEntrancePtrs+2,x
        sta     $f4
        bit     #$0200
        beq     @213c
        lda     f:$001f64
        and     #$01ff
        sta     f:$001f69
        shorta
        lda     $e0
        sta     f:$001f6b
        lda     $e2
        sta     f:$001f6c
        lda     $f6
        sta     f:$001fd2
        longa
@213c:  lda     f:ShortEntrancePtrs+4,x
        sta     $1c
        lda     #$0080
        sta     $f1
        stz     $ea
        lda     #$ca00
        sta     $eb
        inc     $19
        lda     $e9
        ora     #$0010
        sta     $e9
        lda     $e8
        ora     #$0008
        sta     $e8
        bra     @216a
@2160:  inx6
        cpx     $5a
        bne     @20fe
@216a:  plp
        rts

; ------------------------------------------------------------------------------

; [ check event triggers ]

CheckEvent:
@216c:  php
        longa
        lda     $f4
        and     #$00ff
        asl
        tax
        lda     f:EventTriggerPtrs,x   ; pointer to event triggers
        sta     $58
        lda     f:EventTriggerPtrs+2,x   ; pointer to next map's event triggers
        sta     $5a
        sec
        sbc     $58
        beq     @21d5       ; branch if there are no event triggers
        ldx     $58
        shorta
@218b:  lda     f:EventTriggerPtrs,x   ; trigger x position
        cmp     $e0
        bne     @21cc
        lda     f:EventTriggerPtrs+1,x   ; trigger y position
        cmp     $e2
        bne     @21cc
        lda     f:EventTriggerPtrs+2,x   ; set event pointer
        clc
        adc     #$00
        sta     $ea
        lda     f:EventTriggerPtrs+3,x
        adc     #$00
        sta     $eb
        lda     f:EventTriggerPtrs+4,x
        adc     #$ca
        sta     $ec
        lda     $e7         ; enable world event script and ???
        ora     #$41
        sta     $e7
        stz     $ed         ; clear event script offset
        stz     $ee
        lda     $e9         ;
        ora     #$10
        sta     $e9
        lda     $e8         ;
        ora     #$08
        sta     $e8
        bra     @21d5
@21cc:  inx5                 ; next trigger
        cpx     $5a
        bne     @218b
@21d5:  plp
        rts

; ------------------------------------------------------------------------------

; [ get tile properties ]

; +x: horizontal offset (signed)
; +y: vertical offset (signed)

.a16

GetTileProp:
readid:
@21d7:  lda     f:$001f64     ; map index
        and     #$00ff
        xba
        asl
        sta     $64
        txa
        clc
        adc     $e0         ; x position
        and     #$00ff
        sta     $58
        tya
        clc
        adc     $e2         ; y position
        and     #$00ff
        xba
        clc
        adc     $58
        tax
        lda     $7f0000,x   ; map formation
        and     #$00ff
        asl
        clc
        adc     $64
        tax
        lda     f:WorldTileProp,x   ; tile properties
        rts

; ------------------------------------------------------------------------------

; [ battle zoom and sound effect ]

BattleZoom:
@2208:  phb
        php
        shorta
        longi
        lda     #$80
        sta     hAPUIO2
        lda     #$c1
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
        lda     #$03
        sta     hTM
        stz     hTS
        ldx     #0
@2228:  lda     f:BattleZoomTbl,x   ; zoom level
        sta     $8c
        lda     f:BattleZoomTbl+1,x   ; screen brightness
        sta     hINIDISP
        phx
        jsr     UpdateMode7Vars
        longi
        plx
        shorta
@223e:  lda     $24
        beq     @223e       ; wait for vblank
        stz     $24
        inx2
        cpx     #$0044
        bne     @2228
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; battle zoom data (2 bytes each, zoom level then screen brightness)
BattleZoomTbl:
@224e:  .word   $0f85,$0f70,$0f5c,$0f3a,$0f2d,$0f23,$0f19,$0f18
        .word   $0f1b,$0f29,$0f32,$0f3d,$0f53,$0f5c,$0f64,$0f6d
        .word   $0f6d,$0f6c,$0f69,$0f68,$0f65,$0f5f,$0f5c,$0f58
        .word   $0d4e,$0c49,$0b44,$0938,$0831,$072b,$051d,$0416
        .word   $030f,$0100

; ------------------------------------------------------------------------------

; [  ]

_ee2292:
fadeoutchr:
@2292:  php
        phb
        shorta
        tdc
        pha
        plb
@2299:  lda     $23
        beq     @22a1
        dec
        beq     @22a1
        dec
@22a1:  sta     $23
@22a3:  lda     $24
        beq     @22a3
        stz     $24
        lda     $23
        bne     @2299
        lda     $e8
        and     #$7f
        sta     $e8
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee22b6:
@22b6:  php
        phb
        shorta
        tdc
        pha
        plb
@22bd:  lda     $23
        beq     @22c2
        dec
@22c2:  sta     $23
@22c4:  lda     $24
        beq     @22c4
        stz     $24
        lda     $23
        bne     @22bd
        lda     $e8
        and     #$7f
        sta     $e8
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee22d7:
fade_out:
@22d7:  php
        phb
        shorta
        lda     #$00
        pha
        plb
@22df:  lda     $24
        beq     @22df
        stz     $24
@22e5:  shorta
        lda     #$02
        sta     hBGMODE                 ; screen mode 2
        lda     $1f64
        cmp     #$02
        beq     @22f7
        lda     #$03
        bra     @22f9
@22f7:  lda     #$83
@22f9:  sta     hCGADSUB
        longa
        lda     #$00e0
        sec
        sbc     $87
        sta     hVTIMEL
        shorta
        lda     $23
        beq     @2311
        dec
        beq     @2311
        dec
@2311:  sta     $23
@2313:  lda     $24
        beq     @2313
        stz     $24
        lda     $23
        bne     @22e5
        lda     $e8
        and     #$7f
        sta     $e8
        plb
        plp
        rts

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
        beq     @2336
        jmp     @234f       ; continue script command
@2336:  longac
        lda     #$0021
        sbc     $36
        sta     $58
        lda     $34         ; script pointer
        sta     $64
        jsr     _ee25f5       ; update magitek train ride script data
        longac
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
        eor     #$ff
        inc
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
        eor     #$ff
        inc
        inc     $60
@23de:  sta     hWRMPYA
        ldy     #$0000
@23e4:  tyx
        lda     $7f0bf8,x   ; yaw multiplier data ???
        bpl     @23f0
        eor     #$ff
        inc
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
        longac
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
@2486:  shortac
        stz     $5c
        lda     f:_ee2b32,x   ; x position
        sbc     $58
        bpl     @2497
        eor     #$ff
        inc
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
        eor     #$ff
        inc
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
        beq     @24ef
        jmp     @2467
@24ef:  lda     $38         ; next layer
        dec
        and     #$3f
        sta     $38
        dec     $66
        beq     @24fd
        jmp     @2435
@24fd:  lda     $11f6
        bit     #$80
        beq     @2577       ; branch if not rotating
        lda     $36         ; increment frame counter
        inc
        sta     $36
        lda     $73         ; rotation frame counter
        bne     @252c       ; branch if it hasn't reached zero
        tdc
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
@2546:  longac
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
        cmp     #$0168
        bcc     @2575       ; branch if less than 360 degrees
        sec
        sbc     #$0168      ; subtract 360 degrees
        bra     @2575
@2571:  clc
        adc     #$0168      ; add 360 degrees
@2575:  sta     $3b
@2577:  longa
        lda     $3b         ; rotation angle
        cmp     #$00b4
        bcc     @2584       ; branch if less than 180 degrees
        sec
        sbc     #$00b4      ; subtract 180 degrees
@2584:  tax
        lda     f:WorldSineTbl+1,x   ; sine table
        and     #$00ff
        sta     $58
        lda     f:WorldSineTbl+91,x   ; cosine table
        and     #$00ff
        sta     $5a
        lda     $3b
        cmp     #$00b4
        bcs     @25af       ; branch if > 180 degrees
        cmp     #$005a
        bcs     @25a5       ; branch if > 90 degrees
        bra     @25ce
@25a5:  lda     $5a
        eor     #$ffff
        inc
        sta     $5a
        bra     @25ce
@25af:  cmp     #$010e
        bcs     @25c6       ; branch if > 270 degrees
        lda     $58
        eor     #$ffff
        inc
        sta     $58
        lda     $5a
        eor     #$ffff
        inc
        sta     $5a
        bra     @25ce
@25c6:  lda     $58
        eor     #$ffff
        inc
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
        eor     #$ffff      ; 2's complement
        inc
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
; 0: straight, 1: left turn, 2: right turn
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
; 0: pipes w/ more beams, 1: pipes w/ fewer beams, 2: no pipes, 3: split track w/ more walls, 4: split track w/ fewer walls
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
; $00: pitch
; $01: yaw
; $02: background
; $03: yaw multiplier ??? (always zero)
; $04: command
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

.a16

TrainCmd_01:
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

.a16

TrainCmd_40:
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
@3232:  tdc
        shortac
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
@3257:  tdc
        shortac
        lda     $f0
        and     #$03
        eor     #$ff
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

.a16

TrainCmd_e0:
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
        lda     #$2c        ; battle bg $2c (magitek train car)
        sta     f:$0011e2
        tdc
        sta     f:$0011e3
        lda     #$08        ; continue current music
        sta     f:$0011e4
        lda     f:$0011f6     ; enable battle
        ora     #$02
        sta     f:$0011f6
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $e1: battle 2 ]

.a16

TrainCmd_e1:
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
        lda     #$2c
        sta     f:$0011e2
        tdc
        sta     f:$0011e3
        lda     #$08
        sta     f:$0011e4
        lda     f:$0011f6     ; enable battle
        ora     #$02
        sta     f:$0011f6
        jmp     _ee235b

; ------------------------------------------------------------------------------

; [ magitek train ride command $e2: boss battle ]

.a16

TrainCmd_e2:
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
        tdc
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

; [  ]

_ee3363:
mapwrt256:
@3363:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $34
        sec
        sbc     #$0200
        and     #$0fff
        sta     $5a
        lda     $38
        sec
        sbc     #$0200
        and     #$0fff
        sta     $5c
        longa
        lda     $5a
        lsr3
        and     #$007e
        tax
        lda     $40
        cmp     #$1000
        bpl     @33a7
        cmp     #$0000
        bmi     @33cf
        lda     #$8000
        sta     $44
        jmp     @342a
@33a7:  lda     $40
        sec
        sbc     #$1000
        sta     $40
        lda     $5c
        asl4
        clc
        adc     #$3f00
        and     #$ff00
        sta     $5e
        lda     $5c
        asl4
        sec
        sbc     #$0100
        and     #$3f00
        sta     $44
        bra     @33ed
@33cf:  lda     $40
        clc
        adc     #$1000
        sta     $40
        lda     $5c
        asl4
        and     #$ff00
        sta     $5e
        lda     $5c
        asl4
        and     #$3f00
        sta     $44
@33ed:  lda     $5a
        lsr4
        and     #$00ff
        tay
        lda     #$0040
        sta     $66
@33fc:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y
        sta     $6d50,x
        lda     $6f52,y
        sta     $6dd0,x
        pla
        inc
        and     #$00ff
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @33fc
        lda     #$8000
        sta     $46
        jmp     @34d3
@342a:  longa
        lda     $5c
        lsr3
        and     #$007e
        tax
        lda     $3c
        cmp     #$1000
        bpl     @3449
        cmp     #$0000
        bmi     @346e
        lda     #$8000
        sta     $46
        jmp     @34d3
@3449:  lda     $3c
        sec
        sbc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        clc
        adc     #$003f
        and     #$00ff
        sta     $5e
        lda     $5a
        lsr3
        dec2
        and     #$007e
        sta     $46
        bra     @348b
@346e:  lda     $3c
        clc
        adc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        and     #$00ff
        sta     $5e
        lda     $5a
        lsr3
        and     #$007e
        sta     $46
@348b:  lda     $5c
        asl4
        and     #$ff00
        tay
        lda     #$0040
        sta     $66
@349a:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        shorta
        lda     $6f50,y
        sta     $6e50,x
        lda     $6f51,y
        sta     $6ed0,x
        lda     $6f52,y
        sta     $6e51,x
        lda     $6f53,y
        sta     $6ed1,x
        longa
        pla
        clc
        adc     #$0100
        and     #$ff00
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @349a
@34d3:  plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee34d5:
mapall256:
@34d5:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $38
        sec
        sbc     #$0200
        sta     $5c
        asl4
        and     #$ff00
        sta     $5e
        and     #$3f00
        sta     $6a
        lda     $34
        sec
        sbc     #$0200
        and     #$0fff
        sta     $5a
        lsr3
        and     #$007e
        ora     $6a
        tax
        lda     $5a
        lsr4
        and     #$00ff
        tay
        lda     #$0040
        sta     $66
@351d:  lda     #$0040
        sta     $68
@3522:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y
        sta     $2000,x
        lda     $6f52,y
        sta     $2080,x
        pla
        inc
        and     #$00ff
        tay
        txa
        inc2
        and     #$3f7f
        tax
        dec     $68
        bne     @3522
        tya
        sec
        sbc     #$0040
        and     #$00ff
        tay
        txa
        clc
        adc     #$0100
        and     #$3f7f
        tax
        lda     $5e
        adc     #$0100
        sta     $5e
        dec     $66
        bne     @351d
        plb
        stz     hVMAINC
        stz     hVMADDL
        lda     #$1800
        sta     $4300
        lda     #$2000
        sta     $4302
        lda     #$007e
        sta     $4304
        lda     #$4000
        sta     $4305
        lda     #$0100
        sta     hVTIMEH
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee358b:
mapwrt128:
@358b:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $34
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5a
        lda     $38
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5c
        longa
        lda     $5a
        lsr3
        and     #$007e
        tax
        lda     $40
        cmp     #$1000
        bpl     @35cf
        cmp     #$0000
        bmi     @35f6
        lda     #$8000
        sta     $44
        jmp     @3650
@35cf:  lda     $40
        sec
        sbc     #$1000
        sta     $40
        lda     $5c
        asl3
        clc
        adc     #$1f80
        and     #$3f80
        sta     $5e
        lda     $5c
        asl4
        sec
        sbc     #$0100
        and     #$3f00
        sta     $44
        bra     @3613
@35f6:  lda     $40
        clc
        adc     #$1000
        sta     $40
        lda     $5c
        asl3
        and     #$3f80
        sta     $5e
        lda     $5c
        asl4
        and     #$3f00
        sta     $44
@3613:  lda     $5a
        lsr4
        and     #$007f
        tay
        lda     #$0040
        sta     $66
@3622:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y
        sta     $6d50,x
        lda     $6f52,y
        sta     $6dd0,x
        pla
        inc
        and     #$007f
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @3622
        lda     #$8000
        sta     $46
        jmp     @36f8
@3650:  longa
        lda     $5c
        lsr3
        and     #$007e
        tax
        lda     $3c
        cmp     #$1000
        bpl     @366f
        cmp     #$0000
        bmi     @3694
        lda     #$8000
        sta     $46
        jmp     @36f8
@366f:  lda     $3c
        sec
        sbc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        clc
        adc     #$003f
        and     #$007f
        sta     $5e
        lda     $5a
        lsr3
        dec2
        and     #$007e
        sta     $46
        bra     @36b1
@3694:  lda     $3c
        clc
        adc     #$1000
        sta     $3c
        lda     $5a
        lsr4
        and     #$007f
        sta     $5e
        lda     $5a
        lsr3
        and     #$007e
        sta     $46
@36b1:  lda     $5c
        asl3
        and     #$3f80
        tay
        lda     #$0040
        sta     $66
@36bf:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        shorta
        lda     $6f50,y
        sta     $6e50,x
        lda     $6f51,y
        sta     $6ed0,x
        lda     $6f52,y
        sta     $6e51,x
        lda     $6f53,y
        sta     $6ed1,x
        longa
        pla
        clc
        adc     #$0080
        and     #$3f80
        tay
        txa
        inc2
        and     #$007f
        tax
        dec     $66
        bne     @36bf
@36f8:  plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee36fa:
@36fa:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        lda     #$7f
        sta     $60
        longa
        lda     $38
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5c
        asl3
        and     #$3f80
        sta     $5e
        asl
        and     #$3f00
        sta     $6a
        lda     $34
        sec
        sbc     #$0200
        and     #$07ff
        sta     $5a
        lsr3
        and     #$007e
        ora     $6a
        tax
        lda     $5a
        lsr4
        and     #$007f
        tay
        lda     #$0040
        sta     $66
@3745:  lda     #$0040
        sta     $68
@374a:  lda     [$5e],y
        phy
        and     #$00ff
        asl2
        tay
        lda     $6f50,y
        sta     $2000,x
        lda     $6f52,y
        sta     $2080,x
        pla
        inc
        and     #$007f
        tay
        txa
        inc2
        and     #$3f7f
        tax
        dec     $68
        bne     @374a
        tya
        sec
        sbc     #$0040
        and     #$007f
        tay
        txa
        clc
        adc     #$0100
        and     #$3f7f
        tax
        lda     $5e
        adc     #$0080
        and     #$3f80
        sta     $5e
        dec     $66
        bne     @3745
        plb
        stz     hVMAINC
        stz     hVMADDL
        lda     #$1800
        sta     $4300
        lda     #$2000
        sta     $4302
        lda     #$007e
        sta     $4304
        lda     #$4000
        sta     $4305
        lda     #$0100
        sta     hVTIMEH
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee37b6:
@37b6:  shorta
        phb
        lda     #$7e
        pha
        plb
        longa
        longi
        lda     $83
        bne     @37c8
        jmp     @385e
@37c8:  bmi     @3814
        xba
        lsr3
        tax
        lda     #$00e0
        sec
        sbc     $87
        clc
        adc     #$0008
        lsr3
        sta     $66
        ldy     #$0000
@37e1:  lda     $7eb862,x
        and     #$00ff
        sta     $58
        lda     $70
        sec
        sbc     $58
        sta     $690e,y
        sta     $6910,y
        sta     $6912,y
        sta     $6914,y
        sta     $6916,y
        sta     $6918,y
        sta     $691a,y
        sta     $691c,y
        tya
        clc
        adc     #$0010
        tay
        inx
        dec     $66
        bne     @37e1
        bra     @3874
@3814:  eor     #$ffff
        inc
        xba
        lsr3
        tax
        lda     #$00e0
        sec
        sbc     $87
        clc
        adc     #$0008
        lsr3
        sta     $66
        ldy     #$0000
@382f:  lda     $7eb862,x
        and     #$00ff
        clc
        adc     $70
        sta     $690e,y
        sta     $6910,y
        sta     $6912,y
        sta     $6914,y
        sta     $6916,y
        sta     $6918,y
        sta     $691a,y
        sta     $691c,y
        tya
        clc
        adc     #$0010
        tay
        inx
        dec     $66
        bne     @382f
        bra     @3874
@385e:  lda     #$00e0
        sec
        sbc     $87
        beq     @3874
        tax
        ldy     #$0000
        lda     $70
@386c:  sta     $690e,y
        iny2
        dex
        bne     @386c
@3874:  lda     #$00e0
        sec
        sbc     $87
        ora     #$0080
        sta     a:$00bb
        lda     #$690e
        sta     a:$00bc
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee3888:
objcvr:
@3888:  shorta
        longi
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     $83
        bne     @389a
        jmp     @39c7
@389a:  bpl     @389f
        jmp     @3933
@389f:  xba
        lsr3
        tax
        lda     #$00c0
        sec
        sbc     $87
        clc
        adc     $83
        sta     $58
        shorta
        lda     #$0f
        sta     $66
        ldy     #$0000
        lda     $7eb862,x
        inx
        sta     $5a
@38bf:  lda     $58
        sta     $6c01,y
        clc
        adc     #$10
        sta     $6c3d,y
        adc     #$10
        sta     $6c79,y
        adc     #$10
        sta     $6cb5,y
        adc     #$10
        sta     $6cf1,y
        lda     $7eb862,x
        cmp     $5a
        beq     @3900
        sta     $5a
        dec     $58
        lda     #$01
        sta     $6c02,y
        lda     #$05
        sta     $6c3e,y
        lda     #$09
        sta     $6c7a,y
        lda     #$0d
        sta     $6cb6,y
        lda     #$21
        sta     $6cf2,y
        bra     @3918
@3900:  tdc
        sta     $6c02,y
        lda     #$04
        sta     $6c3e,y
        lda     #$08
        sta     $6c7a,y
        lda     #$0c
        sta     $6cb6,y
        lda     #$20
        sta     $6cf2,y
@3918:  inx
        lda     $7eb862,x
        cmp     $5a
        beq     @3925
        sta     $5a
        dec     $58
@3925:  dec     $66
        beq     @3930
        iny4
        inx
        bra     @38bf
@3930:  jmp     @39fd

.a16
@3933:  eor     #$ffff
        inc
        xba
        lsr3
        tax
        lda     #$00c0
        sec
        sbc     $87
        sta     $58
        shorta
        lda     #$0f
        sta     $66
        ldy     #$0000
        lda     $7eb862,x
        inx
        sta     $5a
@3954:  lda     $7eb862,x
        cmp     $5a
        beq     @397b
        sta     $5a
        inc     $58
        lda     #$02
        sta     $6c02,y
        lda     #$06
        sta     $6c3e,y
        lda     #$0a
        sta     $6c7a,y
        lda     #$0e
        sta     $6cb6,y
        lda     #$22
        sta     $6cf2,y
        bra     @3993
@397b:  tdc
        sta     $6c02,y
        lda     #$04
        sta     $6c3e,y
        lda     #$08
        sta     $6c7a,y
        lda     #$0c
        sta     $6cb6,y
        lda     #$20
        sta     $6cf2,y
@3993:  lda     $58
        sta     $6c01,y
        clc
        adc     #$10
        sta     $6c3d,y
        adc     #$10
        sta     $6c79,y
        adc     #$10
        sta     $6cb5,y
        adc     #$10
        sta     $6cf1,y
        inx
        lda     $7eb862,x
        cmp     $5a
        beq     @39ba
        sta     $5a
        inc     $58
@39ba:  dec     $66
        beq     @39c5
        iny4
        inx
        bra     @3954
@39c5:  bra     @39fd
.a16
@39c7:  lda     #$00c0
        sec
        sbc     $87
        sta     $58
        shorta
        stz     $5a
        ldy     #$0000
@39d6:  ldx     #$000f
@39d9:  lda     $58
        sta     $6c01,y
        lda     $5a
        sta     $6c02,y
        iny4
        dex
        bne     @39d9
        clc
        adc     #$14
        and     #$2f
        sta     $5a
        lda     $58
        clc
        adc     #$10
        sta     $58
        cpy     #$012c
        bne     @39d6
@39fd:  plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee39ff:
@39ff:  longa
        longi
        stz     hVMAINC
        lda     #$4c20
        sta     hVMADDL
        lda     $83
        beq     @3a69
        bmi     @3a3e
        sta     $5a
        xba
        lsr3
        tax
        lda     $87
        shorta
        sec
        sbc     #$64
        sec
        sbc     $5a
        sta     $58
        sta     hBG2VOFS
        stz     hBG2VOFS
        ldy     #$0020
@3a2e:  lda     $58
        clc
        adc     $7eb862,x
        sta     hVMDATAL
        inx
        dey
        bne     @3a2e
        bra     @3a7f

.a16
@3a3e:  eor     #$ffff
        inc
        xba
        lsr3
        tax
        lda     $87
        shorta
        sec
        sbc     #$64
        sta     $58
        sta     hBG2VOFS
        stz     hBG2VOFS
        ldy     #$0020
@3a59:  lda     $58
        sec
        sbc     $7eb862,x
        sta     hVMDATAL
        inx
        dey
        bne     @3a59
        bra     @3a7f
@3a69:  lda     $87
        shorta
        sec
        sbc     #$64
        sta     hBG2VOFS
        stz     hBG2VOFS
        ldy     #$0020
@3a79:  sta     hVMDATAL
        dey
        bne     @3a79
@3a7f:  rts

; ------------------------------------------------------------------------------

; [ update mode 7 rotation ]

UpdateMode7Rot:
@3a80:  longa
        longi
        stz     $6b
        stz     $6e
        lda     $87
        cmp     #$00e1
        bcc     @3a9c
        lda     #$01c0
        sec
        sbc     $87
        sta     $89
        lda     #$00e0
        bra     @3a9e
@3a9c:  sta     $89
@3a9e:  asl
        tax
        clc
        adc     #$0140
        sta     $a0
        sta     $b5
        adc     #$00f8
        sta     $a3
        sta     $b8
        txa
        adc     #$0300
        sta     $a7
        adc     #$00f8
        sta     $aa
        txa
        adc     #$04c0
        sta     $ae
        adc     #$00f8
        sta     $b1
        longa
        shorti
        ldx     $89
        lda     $8f
        sec
        sbc     $8d
        bcs     @3ad6
        eor     #$ffff
        inc
@3ad6:  php
        sta     hWRDIVL
        stx     hWRDIVB
        lda     a:$0073
        cmp     #$00b4
        bcc     @3ae8
        sbc     #$00b4
@3ae8:  tax
        lda     f:WorldSineTbl+1,x
        sta     $9b
        lda     f:WorldSineTbl+91,x
        sta     $9d
        plp
        lda     hRDDIVL
        bcs     @3aff
        eor     #$ffff
        inc
@3aff:  sta     $95
        lda     $89
        cmp     #$007e
        bcs     @3b0e
        sta     $66
        stz     $68
        bra     @3b19
@3b0e:  stz     $66
        ldx     #$7e
        stx     $66
        sbc     #$007e
        sta     $68
@3b19:  lda     $8b
        sta     $97
        lda     $8d
        sta     $99
        lda     a:$0073
        cmp     #$00b4
        bcc     @3b34
        cmp     #$010e
        bcc     @3b31
        jmp     @3d8f
@3b31:  jmp     @3cc6
@3b34:  cmp     #$005a
        bcc     @3b3c
        jmp     @3bfd
@3b3c:  ldy     #$00
@3b3e:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $04be,y
        eor     #$ffff
        inc
        sta     $067e,y
        dec     $66
        bne     @3b3e
        ldy     #$00
@3b9c:  dec     $68
        bmi     @3bfa
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $05ba,y
        eor     #$ffff
        inc
        sta     $077a,y
        bra     @3b9c
@3bfa:  jmp     @3e50
@3bfd:  ldy     #$00
@3bff:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $04be,y
        eor     #$ffff
        inc
        sta     $067e,y
        dec     $66
        bne     @3bff
        ldy     #$00
@3c61:  dec     $68
        bmi     @3cc3
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $05ba,y
        eor     #$ffff
        inc
        sta     $077a,y
        bra     @3c61
@3cc3:  jmp     @3e50
@3cc6:  ldy     #$00
@3cc8:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $067e,y
        eor     #$ffff
        inc
        sta     $04be,y
        dec     $66
        bne     @3cc8
        ldy     #$00
@3d2a:  dec     $68
        bmi     @3d8c
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        eor     #$ffff
        inc
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $077a,y
        eor     #$ffff
        inc
        sta     $05ba,y
        bra     @3d2a
@3d8c:  jmp     @3e50
@3d8f:  ldy     #$00
@3d91:  lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $02ff,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $067e,y
        eor     #$ffff
        inc
        sta     $04be,y
        dec     $66
        bne     @3d91
        ldy     #$00
@3def:  dec     $68
        bmi     @3e4d
        lda     $97
        sta     hWRDIVL
        ldx     $9a
        stx     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        iny
        ldx     $9d
        stx     hWRMPYA
        lda     hRDDIVL
        sta     $6d
        tax
        stx     hWRMPYB
        xba
        tax
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $03fb,y
        ldx     $9b
        stx     hWRMPYA
        ldx     $6d
        stx     hWRMPYB
        ldx     $6e
        iny
        lda     hRDMPYL
        sta     $6a
        stx     hWRMPYB
        lda     $6b
        clc
        adc     hRDMPYL
        sta     $077a,y
        eor     #$ffff
        inc
        sta     $05ba,y
        bra     @3def
@3e4d:  jmp     @3e50
@3e50:  rts

; ------------------------------------------------------------------------------

; [ update mode 7 variables ]

UpdateMode7Vars:
@3e51:  longa
        longi
        lda     $87
        cmp     #$00e1
        bcc     @3e69
        lda     #$01c0
        sec
        sbc     $87
        sta     $89
        lda     #$00e0
        bra     @3e6b
@3e69:  sta     $89
@3e6b:  asl
        tax
        clc
        adc     #$0140
        sta     $a0
        adc     #$00f8
        sta     $a3
        txa
        adc     #$0300
        sta     $a7
        adc     #$00f8
        sta     $aa
        txa
        adc     #$04c0
        sta     $ae
        adc     #$00f8
        sta     $b1
        txa
        adc     #$0680
        sta     $b5
        adc     #$00f8
        sta     $b8
        shorti
        ldx     $89
        lda     $8f
        sec
        sbc     $8d
        bcs     @3ea8
        eor     #$ffff
        inc
@3ea8:  php
        sta     hWRDIVL
        stx     hWRDIVB
        lda     a:$0073
        cmp     #$00b4
        bcc     @3eba
        sbc     #$00b4
@3eba:  tax
        lda     f:WorldSineTbl+1,x
        sta     $9b
        lda     f:WorldSineTbl+91,x
        sta     $9d
        plp
        lda     hRDDIVL
        bcs     @3ed1
        eor     #$ffff
        inc
@3ed1:  sta     $95
        lda     $89
        cmp     #$007e
        bcs     @3ee0
        sta     $66
        stz     $68
        bra     @3ee9
@3ee0:  ldx     #$7e
        stx     $66
        sbc     #$007e
        sta     $68
@3ee9:  lda     $8b
        sta     $97
        lda     $8d
        sta     $99
        stz     hWRDIVH
        ldy     #$00
        ldx     $66
@3ef8:  lda     $97
        sta     hWRDIVL
        lda     $9a
        sta     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        lda     #$0000
        sta     $04c0,y
        sta     $0680,y
        lda     hRDDIVL
        sta     $0300,y
        sta     $0840,y
        iny2
        dex
        bne     @3ef8
        ldy     #$00
        ldx     $68
@3f24:  dex
        bmi     @3f4e
        lda     $97
        sta     hWRDIVL
        lda     $9a
        sta     hWRDIVB
        lda     $99
        clc
        adc     $95
        sta     $99
        lda     #$0000
        sta     $05bc,y
        sta     $077c,y
        lda     hRDDIVL
        sta     $03fc,y
        sta     $093c,y
        iny2
        bra     @3f24
@3f4e:  rts

; ------------------------------------------------------------------------------

; [  ]

_ee3f4f:
decm7:
@3f4f:  php
        phb
        shorta
        lda     #$00
        pha
        plb
        longa
        lda     #$7350
        sta     hWMADDL
        stz     hVMADDL
        shorta
        stz     hWMADDH
        lda     #$80
        sta     hVMAINC
        shorti
        ldx     #$00
@3f70:  lda     $7e9350,x
        and     #$0f
        asl4
        sta     $58
        phx
        ldx     #$20
@3f7f:  lda     hWMDATA
        tay
        and     #$0f
        ora     $58
        sta     hVMDATAH
        tya
        lsr4
        ora     $58
        sta     hVMDATAH
        dex
        bne     @3f7f
        plx
        lda     $7e9350,x
        and     #$f0
        sta     $58
        phx
        ldx     #$20
@3fa3:  lda     hWMDATA
        tay
        and     #$0f
        ora     $58
        sta     hVMDATAH
        tya
        lsr4
        ora     $58
        sta     hVMDATAH
        dex
        bne     @3fa3
        plx
        inx
        cpx     #$80
        bne     @3f70
        plb
        plp
        rts

.a8
.i16

; ------------------------------------------------------------------------------

; [  ]

_ee3fc4:
setoam:
@3fc4:  phb
        lda     #$7e
        pha
        plb
        ldx     #$0000
        ldy     #$000f
        lda     #$08
@3fd1:  sta     $58
        sta     $6c00,x
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
@4009:  sta     $6b31,x
        inx4
        dey
        bne     @4009
        plb
        rts

; ------------------------------------------------------------------------------

; [ clear sprite data ]

_ee4015:
setoam1:
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

; [  ]

_ee4032:
hikuutei_oamsub:
@4032:  php
        longa
        lda     #$6d30
        sta     hWMADDL
        shorta
        stz     hWMADDH
        lda     #$aa
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        ldx     #$0013
@406c:  sta     hWMDATA
        dex
        bne     @406c
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee4074:
chr_oamsub:
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
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        stz     hWMDATA
        ldx     #$0013
@40b5:  sta     hWMDATA
        dex
        bne     @40b5
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee40be:
chr_oamsub2:
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
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        ldx     #$001b
@40e7:  stz     hWMDATA
        dex
        bne     @40e7
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee40f0:
grad_clear:
@40f0:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        ldx     #$00d0
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

; [  ]

objwk_clear:
_ee4118:
@4118:  php
        phb
        shortai
        lda     #$7e
        pha
        plb
        ldx     #$00
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
        sta     $6b30
        lda     $38
        lsr6
        clc
        adc     #$009b
        sta     $6d
        sta     $6b31
        lda     #$1b80
        sta     $6b32
        shorta
        lda     $20
        cmp     #$03
        bne     @41f2
        jmp     @4269
@41f2:  longa
        lda     $9d
        asl2
        xba
        and     #$0003
        sta     $58
        lda     $9b
        asl2
        xba
        and     #$0003
        sta     $5a
        lda     $73
        cmp     #$00b4
        bcc     @4239
        cmp     #$010e
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
@4239:  cmp     #$005a
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

; [  ]

object2:
_ee427c:
@427c:  shorta
        phb
        lda     #$7e
        pha
        plb
        longa
        longi
        lda     #$0008
        sta     $66
        ldx     #$0050
        stx     $5c
        ldx     #$0000
@4294:  lda     $b5d2,x
        sta     $58
        lda     $b5d4,x
        sta     $5a
        lda     $b5d0,x
        phx
        beq     @42e0
        asl
        tay
        lda     $93d0,y
        tay
        shorta
        lda     $95d0,y
        iny
        sta     $68
        ldx     $5c
@42b4:  lda     $95d0,y
        clc
        adc     $58
        sta     $6b30,x
        lda     $95d1,y
        clc
        adc     $5a
        sta     $6b31,x
        longac
        lda     $95d2,y
        sta     $6b32,x
        tya
        adc     #$0004
        tay
        txa
        adc     #$0004
        tax
        shorta
        dec     $68
        bne     @42b4
        stx     $5c
@42e0:  longac
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
        sta     $6b30,x
        txa
        adc     #$0004
        bra     @42ee
@4300:  plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee4302:
object2_chr:
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
        tdc
        bra     @4370
@4343:  clc
        adc     $58
        bmi     @4370
        tdc
        bra     @4370
@434b:  lda     $95d0,y
        bpl     @4353
        tdc
        bra     @4370
@4353:  clc
        adc     $58
        bpl     @4370
        tdc
        bra     @4370
@435b:  lda     $95d0,y
        bmi     @4368
        clc
        adc     $58
        bcc     @4370
        tdc
        bra     @4370
@4368:  clc
        adc     $58
        cmp     $58
        bcc     @4370
        tdc
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
        bcs     @43a7
        jmp     @4315
@43a7:  lda     $5c
@43a9:  cmp     #$0200
        bcs     @43bb
        tax
        lda     #$e000
        sta     $6b30,x
        txa
        adc     #$0004
        bra     @43a9
@43bb:  plb
        rts

; ------------------------------------------------------------------------------

; [ update character graphics ]

DrawPlayerSprite:
_ee43bd:
objmov:
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
        jsr     (.loword(DrawPlayerSpriteTbl),x)
        plx
@43d1:  inx2                            ; next character
        cpx     #$0008
        bne     @43c6
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; character graphic jump table
DrawPlayerSpriteTbl:
@43db:  .addr   0
        .addr   DrawPlayerSprite_01
        .addr   DrawPlayerSprite_02
        .addr   DrawPlayerSprite_03
        .addr   DrawPlayerSprite_04
        .addr   DrawPlayerSprite_05
        .addr   DrawPlayerSprite_06
        .addr   DrawPlayerSprite_07
        .addr   DrawPlayerSprite_08
        .addr   DrawPlayerSprite_09
        .addr   DrawPlayerSprite_0a
        .addr   DrawPlayerSprite_0b
        .addr   DrawPlayerSprite_0c
        .addr   DrawPlayerSprite_0d
        .addr   DrawPlayerSprite_0e
        .addr   DrawPlayerSprite_0f
        .addr   DrawPlayerSprite_10
        .addr   DrawPlayerSprite_11
        .addr   DrawPlayerSprite_12
        .addr   DrawPlayerSprite_13
        .addr   DrawPlayerSprite_14
        .addr   DrawPlayerSprite_15
        .addr   DrawPlayerSprite_16
        .addr   DrawPlayerSprite_17
        .addr   DrawPlayerSprite_18
        .addr   DrawPlayerSprite_19

; ------------------------------------------------------------------------------

; [  ]

DrawPlayerSprite_01:
@440f:  php
        phb
        shorta
        lda     #$00
        pha
        plb
        longa
        lda     $29
        cmp     #$00aa
        bpl     @442a
        cmp     #$ff56
        bmi     @442f
        lda     #$0001
        bra     @4432
@442a:  lda     #$0009
        bra     @4432
@442f:  lda     #$0005
@4432:  sta     $58
        lda     $2d
        cmp     #$00aa
        bpl     @4445
        cmp     #$ff56
        bmi     @444a
        lda     #$0000
        bra     @444d
@4445:  lda     #$0001
        bra     @444d
@444a:  lda     #$0002
@444d:  clc
        adc     $58
        tax
        shorta
        lda     #$08
        sec
        sbc     $27
        lsr
        inc
        sta     $7eb654
        lda     $7eb652
        dec
        beq     @446b
        sta     $7eb652
        bra     @447c
@446b:  lda     $7eb650
        dec
        sta     $7eb650
        lda     $7eb654
        sta     $7eb652
@447c:  lda     $7eb650
        and     #$01
        clc
        adc     f:_ee4566,x
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
        beq     @44af
        lda     #$f0
        sta     $7eb5d4
@44af:  lda     $30
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

_ee4566:
@4566:  .byte   $00,$01,$07,$0d,$00,$05,$0b,$11,$00,$03,$09,$0f,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; [  ]

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
        adc     f:_ee4566,x
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

; [  ]

DrawPlayerSprite_02:
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
        lda     #$0000
        bra     @4629
@4621:  lda     #$0006
        bra     @4629
@4626:  lda     #$000c
@4629:  sta     $5a
        lda     $29
        bne     @463e
        lda     $26
        bne     @4641
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
@467f:  lda     #$b8
        sta     $7eb5d4
        lda     #$80
        sta     $7eb5d2
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

DrawPlayerSprite_03:
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
        jsr     _ee47e3
@46c2:  longai
        lda     $1f64
        and     #$01ff
        beq     @46d3
        lda     #$001d
        sta     $64
        bra     @46d5
@46d3:  stz     $64
@46d5:  lda     $1eb7
        bit     #$0002
        bne     @46e0
        jmp     @47a9
@46e0:  lda     $1f63
        and     #$00ff
        asl4
        sec
        sbc     $38
        cmp     #$ff86
        bpl     @46f5
        jmp     @47a9
@46f5:  cmp     #$0038
        bmi     @46fd
        jmp     @47a9
@46fd:  clc
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
        eor     #$ffff
        inc
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
        longac
        lda     $6b
        and     #$00ff
        adc     hRDMPYL
        sta     hWRDIVL
        shorta
        lda     #$eb
        sta     hWRDIVB
        nop6
        longac
        lda     hRDDIVL
        and     #$00ff
        adc     $5a
        cmp     #$00a0
        bcs     @47a9
        ldx     $60
        bpl     @4780
        eor     #$ffff
        inc
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
        tdc
        sta     $7eb5d8
        sta     $7eb5db
@47b4:  shortai
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
@47cd:  lda     $8000,y
        sta     $7ee100,x
        sta     $7ee180,x
        iny2
        inx2
        cpx     #$20
        bne     @47cd
        plb
        plp
        rts

.a8
.i16

; ------------------------------------------------------------------------------

; [  ]

_ee47e3:
@47e3:  lda     $f6
        asl2
        clc
        adc     $7eb650
        tax
        lda     f:ObjMoveTileTbl,x
        sta     $f7

_ee47f3:
@47f3:  lda     $f7
        tax
        lda     f:_ee4852,x
        bne     @480a
        lda     f:_ee48d2,x
        bne     @4806
        lda     #$26
        bra     @4816
@4806:  lda     #$27
        bra     @4816
@480a:  lda     f:_ee48d2,x
        bne     @4814
        lda     #$28
        bra     @4816
@4814:  lda     #$29
@4816:  sta     $60
        lda     $e7
        bit     #$10
        bne     @4822
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

ObjMoveTileTbl:
@4842:  .byte   $04,$05,$04,$03,$47,$48,$47,$46,$01,$02,$01,$00,$07,$08,$07,$06

; ------------------------------------------------------------------------------

_ee4852:
obj_upper_shape_tbl:
@4852:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

; ------------------------------------------------------------------------------

_ee48d2:
obj_lower_shape_tbl:
@48d2:  .byte   $00,$00,$01,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $01,$01,$01,$00,$01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

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

DrawPlayerSprite_04:
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

; [ draw esper terra sprite ]

DrawPlayerSprite_0c:
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
        lda     #$0d
        sta     f:$0000ca
        lda     #$e0
        sta     $7e6b39
        sta     $7e6b3d
        bra     _4ad6

; ------------------------------------------------------------------------------

; [  ]

DrawPlayerSprite_0d:
@4ad4:  php
        phb
_4ad6:  shorta
        tdc
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

; [  ]

DrawPlayerSprite_05:
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
        lda     $f6
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

; [  ]

DrawPlayerSprite_06:
@4bba:  php
        longa
        lda     $1f64
        and     #$01ff
        beq     @4bd1
        lda     #$0064
        sta     $5a
        lda     #$0002
        sta     $5c
        bra     @4bdb
@4bd1:  lda     #$0047
        sta     $5a
        lda     #$0006
        sta     $5c
@4bdb:  lda     $7eb664
        dec
        bne     @4c03
        lda     $7eb666
        beq     @4beb
        tdc
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
        sta     $7eb5d4
        lda     #$75
        sta     $7eb5d2
        lda     $5a
        clc
        adc     $7eb666
        sta     $7eb5d0
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

DrawPlayerSprite_07:
@4c5b:  php
        longa
        lda     $7eb664
        dec
        bne     @4c78
        lda     $7eb666
        beq     @4c6e
        tdc
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

DrawPlayerSprite_08:
@4cc2:  php
        longa
        lda     $7eb664
        dec
        bne     @4cdf
        lda     $7eb666
        beq     @4cd5
        tdc
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

DrawPlayerSprite_09:
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
        tdc
        bra     @4d73
@4d65:  lda     $7eb668
        cmp     #$000f
        bcs     @4d72
        lda     $5c
        bra     @4d73
@4d72:  tdc
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

_ee4de3:
@4de3:  .byte   $49,$4a,$49,$4b,$4c

; ------------------------------------------------------------------------------

; [  ]

DrawPlayerSprite_0a:
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
        tdc
        lda     $f7
        tax
        lda     f:_ee4852,x
        bne     @4ed0
        lda     f:_ee48d2,x
        bne     @4ecc
        lda     #$26
        bra     @4edc
@4ecc:  lda     #$27
        bra     @4edc
@4ed0:  lda     f:_ee48d2,x
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

; [  ]

DrawPlayerSprite_0b:
@4f16:  php
        longa
        lda     #$0000
        sta     $7eb5d0
        sta     $7eb5d8
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

DrawPlayerSprite_0e:
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
        jsr     _ee40be
        ldx     #$8000
        stx     $b650
        ldx     #$a700
        stx     $b652
        ldx     #$0100
        stx     $b65a
        ldx     #$0000
        stx     $b65c
        ldx     #$0000
@4f56:  tdc
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

DrawPlayerSprite_0f:
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
        longac
        lda     $b652
        sbc     #$001f
        cmp     #$7800
        bcs     @4fab
        lda     #$7800
@4fab:  sta     $b652
        shortac
        xba
        sbc     #$90
        bcs     @4fb8
        tdc
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
        tdc
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
        longac
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

DrawPlayerSprite_14:
@50d6:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longa
        tdc
        lda     $b65c
        cmp     #$00b4
        bcs     @50ee
        inc2
        sta     $b65c
@50ee:  tax
        shorta
        lda     f:WorldSineTbl+1,x
        sta     f:hWRMPYA
        lda     #$c0
        sta     f:hWRMPYB
        nop3
        lda     f:hRDMPYH
        sta     $58
        stz     $59
        longac
        lda     $b650
        adc     $58
        sta     $b650
        lda     $b658
        adc     #$0000
        sta     $b658
        lda     $b65c
        cmp     #$00b4
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

DrawPlayerSprite_10:
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
        tdc
        sta     $b65c
        shorta
        lda     #$0a
        sta     $b652
        tdc
        sta     $b658
        sta     $b659
        sta     $b654
        lda     #$02
        sta     $b656
        lda     #$59
        sta     $b65b
        ldx     #$0000
@51fd:  tdc
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

DrawPlayerSprite_11:
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
        tdc
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
        longac
        lda     $b663,x
        adc     $b665,x
        sta     $b665,x
        shorta
        xba
        sta     $b5d2,y
        longac
        txa
        adc     #$0008
        cmp     #$0028
        bcc     @52dd
        tdc
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
        tdc
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

_ee5350:
@5350:  .byte   $5f,$60,$61,$60

; ------------------------------------------------------------------------------

; [  ]

DrawPlayerSprite_12:
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

; [  ]

DrawPlayerSprite_13:
@5394:  phb
        php
_5396:  shorta
        tdc
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
        tdc
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

DrawPlayerSprite_15:
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
        jsr     _ee40be
        ldx     #$0000
        stx     $b65c
@53f7:  tdc
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

; [  ]

DrawPlayerSprite_16:
@540d:  php
        phb
_540f:  shorta
        lda     #$7e
        pha
        plb
        ldy     #$0000
        ldx     $b65c
@541b:  shorta
        tdc
        lda     $b660,x
        beq     @543e
        lda     $b662,x
        dec
        bne     @5438
        lda     $b660,x
        inc
        cmp     #$07
        bcc     @5432
        tdc
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
        beq     @54a1
        jmp     @541b
@54a1:  ldy     $b65c
        shorta
        lda     f:$001f6d
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

DrawPlayerSprite_17:
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
        jsr     _ee40be
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
@5571:  tdc
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

DrawPlayerSprite_18:
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
        longac
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
        tdc
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
        longac
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

; [  ]

DrawPlayerSprite_19:
_ee5711:
wmshape_set:
@5711:  php
        phb
        phk
        plb
        longi
        longa
        ldx     #0
@571c:  lda     .loword(_ee573e),x
        sta     $7e93d0,x
        inx2
        cpx     #$00d8
        bne     @571c
        ldx     #0
@572d:  lda     .loword(_ee5816),x
        sta     $7e95d0,x
        inx2
        cpx     #$13d6
        bne     @572d
        plb
        plp
        rts

; ------------------------------------------------------------------------------

_ee573e:
@573e:  .word   $0000,$0000,$0031,$0062,$0093,$00c4,$00f5,$0126
        .word   $0157,$0188,$01b9,$01ea,$021b,$024c,$027d,$02ae
        .word   $02df,$0310,$0341,$0372,$03cb,$0424,$047d,$04d6
        .word   $052f,$0588,$05f5,$0662,$06cf,$073c,$07a9,$0816
        .word   $0883,$08f0,$095d,$09ca,$0a37,$0aa4,$0afd,$0b16
        .word   $0b2f,$0b48,$0b61,$0b7a,$0b93,$0bac,$0bc5,$0c22
        .word   $0c6b,$0ca0,$0cc1,$0cce,$0cdf,$0cf0,$0d01,$0d12
        .word   $0d23,$0d34,$0d45,$0d56,$0d67,$0d78,$0d89,$0d9a
        .word   $0dab,$0dbc,$0dcd,$0dde,$0def,$0e00,$0e1d,$0e4e
        .word   $0e87,$0ed0,$0f11,$0f52,$0f93,$0fd4,$100d,$1026
        .word   $103f,$1058,$1071,$108a,$10a3,$10ac,$10b5,$10ce
        .word   $10ff,$1148,$1199,$1199,$119e,$11ab,$11bc,$11cd
        .word   $11de,$11e7,$11f0,$121d,$1256,$1293,$12ec,$1329
        .word   $133e,$1367,$13a4,$13bd

; ------------------------------------------------------------------------------

_ee5816:
@5816:  .byte   $0c,$f4,$f0,$40,$10,$fc,$f0,$41,$10,$04,$f0,$40,$50,$f4,$f8,$50
        .byte   $10,$fc,$f8,$51,$10,$04,$f8,$50,$50,$f4,$00,$42,$10,$fc,$00,$43
        .byte   $10,$04,$00,$42,$50,$f4,$08,$52,$10,$fc,$08,$53,$10,$04,$08,$52
        .byte   $50,$0c,$f4,$f0,$44,$10,$fc,$f0,$45,$10,$04,$f0,$44,$50,$f4,$f8
        .byte   $54,$10,$fc,$f8,$55,$10,$04,$f8,$54,$50,$f4,$00,$46,$10,$fc,$00
        .byte   $47,$10,$04,$00,$46,$50,$f4,$08,$56,$10,$fc,$08,$57,$10,$04,$08
        .byte   $56,$50,$0c,$f4,$f0,$48,$10,$fc,$f0,$49,$10,$04,$f0,$4c,$10,$f4
        .byte   $f8,$58,$10,$fc,$f8,$59,$10,$04,$f8,$5c,$10,$f4,$00,$4a,$10,$fc
        .byte   $00,$4b,$10,$04,$00,$4d,$10,$f4,$08,$5a,$10,$fc,$08,$5b,$10,$04
        .byte   $08,$5d,$10,$0c,$f4,$f0,$4e,$10,$fc,$f0,$4f,$10,$04,$f0,$62,$10
        .byte   $f4,$f8,$5e,$10,$fc,$f8,$5f,$10,$04,$f8,$72,$10,$f4,$00,$60,$10
        .byte   $fc,$00,$61,$10,$04,$00,$63,$10,$f4,$08,$70,$10,$fc,$08,$71,$10
        .byte   $04,$08,$73,$10,$0c,$f4,$f0,$4c,$50,$fc,$f0,$49,$50,$04,$f0,$48
        .byte   $50,$f4,$f8,$5c,$50,$fc,$f8,$59,$50,$04,$f8,$58,$50,$f4,$00,$4d
        .byte   $50,$fc,$00,$4b,$50,$04,$00,$4a,$50,$f4,$08,$5d,$50,$fc,$08,$5b
        .byte   $50,$04,$08,$5a,$50,$0c,$f4,$f0,$62,$50,$fc,$f0,$4f,$50,$04,$f0
        .byte   $4e,$50,$f4,$f8,$72,$50,$fc,$f8,$5f,$50,$04,$f8,$5e,$50,$f4,$00
        .byte   $63,$50,$fc,$00,$61,$50,$04,$00,$60,$50,$f4,$08,$73,$50,$fc,$08
        .byte   $71,$50,$04,$08,$70,$50,$0c,$f4,$f0,$64,$10,$fc,$f0,$65,$10,$04
        .byte   $f0,$64,$50,$f4,$f8,$74,$10,$fc,$f8,$75,$10,$04,$f8,$74,$50,$f4
        .byte   $00,$66,$10,$fc,$00,$67,$10,$04,$00,$66,$50,$f4,$08,$76,$10,$fc
        .byte   $08,$77,$10,$04,$08,$76,$50,$0c,$f4,$f0,$68,$10,$fc,$f0,$69,$10
        .byte   $04,$f0,$68,$50,$f4,$f8,$78,$10,$fc,$f8,$79,$10,$04,$f8,$78,$50
        .byte   $f4,$00,$6a,$10,$fc,$00,$6b,$10,$04,$00,$6a,$50,$f4,$08,$7a,$10
        .byte   $fc,$08,$7b,$10,$04,$08,$7a,$50,$0c,$f4,$f0,$6c,$10,$fc,$f0,$6d
        .byte   $10,$04,$f0,$80,$10,$f4,$f8,$7c,$10,$fc,$f8,$7d,$10,$04,$f8,$90
        .byte   $10,$f4,$00,$6e,$10,$fc,$00,$6f,$10,$04,$00,$81,$10,$f4,$08,$7e
        .byte   $10,$fc,$08,$7f,$10,$04,$08,$91,$10,$0c,$f4,$f0,$82,$10,$fc,$f0
        .byte   $83,$10,$04,$f0,$86,$10,$f4,$f8,$92,$10,$fc,$f8,$93,$10,$04,$f8
        .byte   $96,$10,$f4,$00,$84,$10,$fc,$00,$85,$10,$04,$00,$87,$10,$f4,$08
        .byte   $94,$10,$fc,$08,$95,$10,$04,$08,$97,$10,$0c,$f4,$f0,$80,$50,$fc
        .byte   $f0,$6d,$50,$04,$f0,$6c,$50,$f4,$f8,$90,$50,$fc,$f8,$7d,$50,$04
        .byte   $f8,$7c,$50,$f4,$00,$81,$50,$fc,$00,$6f,$50,$04,$00,$6e,$50,$f4
        .byte   $08,$91,$50,$fc,$08,$7f,$50,$04,$08,$7e,$50,$0c,$f4,$f0,$86,$50
        .byte   $fc,$f0,$83,$50,$04,$f0,$82,$50,$f4,$f8,$96,$50,$fc,$f8,$93,$50
        .byte   $04,$f8,$92,$50,$f4,$00,$87,$50,$fc,$00,$85,$50,$04,$00,$84,$50
        .byte   $f4,$08,$97,$50,$fc,$08,$95,$50,$04,$08,$94,$50,$0c,$f4,$f0,$88
        .byte   $10,$fc,$f0,$89,$10,$04,$f0,$88,$50,$f4,$f8,$98,$10,$fc,$f8,$99
        .byte   $10,$04,$f8,$98,$50,$f4,$00,$8a,$10,$fc,$00,$8b,$10,$04,$00,$8a
        .byte   $50,$f4,$08,$9a,$10,$fc,$08,$9b,$10,$04,$08,$9a,$50,$0c,$f4,$f0
        .byte   $8c,$10,$fc,$f0,$8d,$10,$04,$f0,$8c,$50,$f4,$f8,$9c,$10,$fc,$f8
        .byte   $9d,$10,$04,$f8,$9c,$50,$f4,$00,$8e,$10,$fc,$00,$8f,$10,$04,$00
        .byte   $8e,$50,$f4,$08,$9e,$10,$fc,$08,$9f,$10,$04,$08,$9e,$50,$0c,$f4
        .byte   $f0,$a0,$10,$fc,$f0,$a1,$10,$04,$f0,$a4,$10,$f4,$f8,$b0,$10,$fc
        .byte   $f8,$b1,$10,$04,$f8,$b4,$10,$f4,$00,$a2,$10,$fc,$00,$a3,$10,$04
        .byte   $00,$a5,$10,$f4,$08,$b2,$10,$fc,$08,$b3,$10,$04,$08,$b5,$10,$0c
        .byte   $f4,$f0,$a6,$10,$fc,$f0,$a7,$10,$04,$f0,$aa,$10,$f4,$f8,$b6,$10
        .byte   $fc,$f8,$b7,$10,$04,$f8,$ba,$10,$f4,$00,$a8,$10,$fc,$00,$a9,$10
        .byte   $04,$00,$ab,$10,$f4,$08,$b8,$10,$fc,$08,$b9,$10,$04,$08,$bb,$10
        .byte   $0c,$f4,$f0,$a4,$50,$fc,$f0,$a1,$50,$04,$f0,$a0,$50,$f4,$f8,$b4
        .byte   $50,$fc,$f8,$b1,$50,$04,$f8,$b0,$50,$f4,$00,$a5,$50,$fc,$00,$a3
        .byte   $50,$04,$00,$a2,$50,$f4,$08,$b5,$50,$fc,$08,$b3,$50,$04,$08,$b2
        .byte   $50,$0c,$f4,$f0,$aa,$50,$fc,$f0,$a7,$50,$04,$f0,$a6,$50,$f4,$f8
        .byte   $ba,$50,$fc,$f8,$b7,$50,$04,$f8,$b6,$50,$f4,$00,$ab,$50,$fc,$00
        .byte   $a9,$50,$04,$00,$a8,$50,$f4,$08,$bb,$50,$fc,$08,$b9,$50,$04,$08
        .byte   $b8,$50,$16,$f8,$00,$bc,$13,$00,$00,$bd,$13,$f8,$08,$cc,$13,$00
        .byte   $08,$cd,$13,$f8,$f3,$ac,$14,$00,$f3,$ad,$14,$f8,$fb,$bc,$14,$00
        .byte   $fb,$bd,$14,$f8,$ec,$c0,$12,$00,$ec,$c1,$12,$f8,$f4,$d0,$12,$00
        .byte   $f4,$d1,$12,$f8,$fc,$e0,$12,$00,$fc,$e1,$12,$f8,$04,$d2,$12,$00
        .byte   $04,$d3,$12,$f8,$0c,$e2,$12,$00,$0c,$e3,$12,$f8,$0a,$a0,$13,$00
        .byte   $0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$16,$f8,$01,$dc,$13
        .byte   $00,$01,$dd,$13,$f8,$09,$ec,$13,$00,$09,$ed,$13,$f8,$f1,$ac,$14
        .byte   $00,$f1,$ad,$14,$f8,$f9,$bc,$14,$00,$f9,$bd,$14,$f8,$ec,$d4,$12
        .byte   $00,$ec,$d5,$12,$f8,$f4,$e4,$12,$00,$f4,$e5,$12,$f8,$fc,$84,$13
        .byte   $00,$fc,$85,$13,$f8,$04,$94,$13,$00,$04,$95,$13,$f8,$0c,$a4,$13
        .byte   $00,$0c,$a5,$13,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3,$16,$f8,$01,$de,$13,$00,$01,$df,$13,$f8,$09,$ee
        .byte   $13,$00,$09,$ef,$13,$f8,$f2,$ac,$14,$00,$f2,$ad,$14,$f8,$fa,$bc
        .byte   $14,$00,$fa,$bd,$14,$f8,$ec,$d6,$12,$00,$ec,$d7,$12,$f8,$f4,$e6
        .byte   $12,$00,$f4,$e7,$12,$f8,$fc,$86,$13,$00,$fc,$87,$13,$f8,$04,$96
        .byte   $13,$00,$04,$97,$13,$f8,$0c,$a6,$13,$00,$0c,$a7,$13,$f8,$0a,$a0
        .byte   $13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$16,$f8,$00
        .byte   $be,$13,$00,$00,$bf,$13,$f8,$08,$ce,$13,$00,$08,$cf,$13,$f8,$f3
        .byte   $ac,$14,$00,$f3,$ad,$14,$f8,$fb,$bc,$14,$00,$fb,$bd,$14,$f8,$ec
        .byte   $d8,$12,$00,$ec,$d9,$12,$f8,$f4,$e8,$12,$00,$f4,$e9,$12,$f8,$fc
        .byte   $88,$13,$00,$fc,$89,$13,$f8,$04,$98,$13,$00,$04,$99,$13,$f8,$0c
        .byte   $a8,$13,$00,$0c,$a9,$13,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12
        .byte   $a0,$93,$00,$12,$a0,$d3,$16,$00,$01,$dc,$53,$f8,$01,$dd,$53,$00
        .byte   $09,$ec,$53,$f8,$09,$ed,$53,$f8,$f1,$ac,$14,$00,$f1,$ad,$14,$f8
        .byte   $f9,$bc,$14,$00,$f9,$bd,$14,$00,$ec,$d4,$52,$f8,$ec,$d5,$52,$00
        .byte   $f4,$e4,$52,$f8,$f4,$e5,$52,$00,$fc,$84,$53,$f8,$fc,$85,$53,$00
        .byte   $04,$94,$53,$f8,$04,$95,$53,$00,$0c,$a4,$53,$f8,$0c,$a5,$53,$f8
        .byte   $0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$16
        .byte   $00,$01,$de,$53,$f8,$01,$df,$53,$00,$09,$ee,$53,$f8,$09,$ef,$53
        .byte   $f8,$f2,$ac,$14,$00,$f2,$ad,$14,$f8,$fa,$bc,$14,$00,$fa,$bd,$14
        .byte   $00,$ec,$d6,$52,$f8,$ec,$d7,$52,$00,$f4,$e6,$52,$f8,$f4,$e7,$52
        .byte   $00,$fc,$86,$53,$f8,$fc,$87,$53,$00,$04,$96,$53,$f8,$04,$97,$53
        .byte   $00,$0c,$a6,$53,$f8,$0c,$a7,$53,$f8,$0a,$a0,$13,$00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93,$00,$12,$a0,$d3,$1b,$fc,$fe,$bc,$13,$04,$fe,$bd
        .byte   $13,$fc,$06,$cc,$13,$04,$06,$cd,$13,$fa,$f3,$ac,$14,$02,$f3,$ad
        .byte   $14,$fa,$fb,$bc,$14,$02,$fb,$bd,$14,$f4,$ec,$da,$12,$fc,$ec,$db
        .byte   $12,$04,$ec,$dc,$12,$f4,$f4,$ea,$12,$fc,$f4,$eb,$12,$04,$f4,$ec
        .byte   $12,$f4,$fc,$8a,$13,$fc,$fc,$8b,$13,$04,$fc,$8c,$13,$f4,$04,$9a
        .byte   $13,$fc,$04,$9b,$13,$04,$04,$9c,$13,$f4,$0c,$aa,$13,$fc,$0c,$ab
        .byte   $13,$04,$0c,$ac,$13,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0
        .byte   $93,$00,$12,$a0,$d3,$1b,$fc,$ff,$dc,$13,$04,$ff,$dd,$13,$fc,$07
        .byte   $ec,$13,$04,$07,$ed,$13,$fa,$f1,$ac,$14,$02,$f1,$ad,$14,$fa,$f9
        .byte   $bc,$14,$02,$f9,$bd,$14,$f4,$ec,$dd,$12,$fc,$ec,$de,$12,$04,$ec
        .byte   $df,$12,$f4,$f4,$ed,$12,$fc,$f4,$ee,$12,$04,$f4,$ef,$12,$f4,$fc
        .byte   $8d,$13,$fc,$fc,$8e,$13,$04,$fc,$8f,$13,$f4,$04,$9d,$13,$fc,$04
        .byte   $9e,$13,$04,$04,$9f,$13,$f4,$0c,$ad,$13,$fc,$0c,$ae,$13,$04,$0c
        .byte   $af,$13,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12
        .byte   $a0,$d3,$1b,$fc,$ff,$de,$13,$04,$ff,$df,$13,$fc,$07,$ee,$13,$04
        .byte   $07,$ef,$13,$fa,$f2,$ac,$14,$02,$f2,$ad,$14,$fa,$fa,$bc,$14,$02
        .byte   $fa,$bd,$14,$f4,$ec,$b0,$13,$fc,$ec,$b1,$13,$04,$ec,$b2,$13,$f4
        .byte   $f4,$c0,$13,$fc,$f4,$c1,$13,$04,$f4,$c2,$13,$f4,$fc,$d0,$13,$fc
        .byte   $fc,$d1,$13,$04,$fc,$d2,$13,$f4,$04,$e0,$13,$fc,$04,$e1,$13,$04
        .byte   $04,$e2,$13,$f4,$0c,$f0,$13,$fc,$0c,$f1,$13,$04,$0c,$f2,$13,$f8
        .byte   $0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$1b
        .byte   $fc,$fe,$be,$13,$04,$fe,$bf,$13,$fc,$06,$ce,$13,$04,$06,$cf,$13
        .byte   $fa,$f3,$ac,$14,$02,$f3,$ad,$14,$fa,$fb,$bc,$14,$02,$fb,$bd,$14
        .byte   $f4,$ec,$b3,$13,$fc,$ec,$b4,$13,$04,$ec,$b5,$13,$f4,$f4,$c3,$13
        .byte   $fc,$f4,$c4,$13,$04,$f4,$c5,$13,$f4,$fc,$d3,$13,$fc,$fc,$d4,$13
        .byte   $04,$fc,$d5,$13,$f4,$04,$e3,$13,$fc,$04,$e4,$13,$04,$04,$e5,$13
        .byte   $f4,$0c,$f3,$13,$fc,$0c,$f4,$13,$04,$0c,$f5,$13,$f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$1b,$04,$ff,$dc
        .byte   $53,$fc,$ff,$dd,$53,$04,$07,$ec,$53,$fc,$07,$ed,$53,$fa,$f1,$ac
        .byte   $14,$02,$f1,$ad,$14,$fa,$f9,$bc,$14,$02,$f9,$bd,$14,$f4,$ec,$b6
        .byte   $13,$fc,$ec,$b7,$13,$04,$ec,$b8,$13,$f4,$f4,$c6,$13,$fc,$f4,$c7
        .byte   $13,$04,$f4,$c8,$13,$f4,$fc,$d6,$13,$fc,$fc,$d7,$13,$04,$fc,$d8
        .byte   $13,$f4,$04,$e6,$13,$fc,$04,$e7,$13,$04,$04,$e8,$13,$f4,$0c,$f6
        .byte   $13,$fc,$0c,$f7,$13,$04,$0c,$f8,$13,$f8,$0a,$a0,$13,$00,$0a,$a0
        .byte   $53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$1b,$04,$ff,$de,$53,$fc,$ff
        .byte   $df,$53,$04,$07,$ee,$53,$fc,$07,$ef,$53,$fa,$f2,$ac,$14,$02,$f2
        .byte   $ad,$14,$fa,$fa,$bc,$14,$02,$fa,$bd,$14,$f4,$ec,$b9,$13,$fc,$ec
        .byte   $ba,$13,$04,$ec,$bb,$13,$f4,$f4,$c9,$13,$fc,$f4,$ca,$13,$04,$f4
        .byte   $cb,$13,$f4,$fc,$d9,$13,$fc,$fc,$da,$13,$04,$fc,$db,$13,$f4,$04
        .byte   $e9,$13,$fc,$04,$ea,$13,$04,$04,$eb,$13,$f4,$0c,$f9,$13,$fc,$0c
        .byte   $fa,$13,$04,$0c,$fb,$13,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12
        .byte   $a0,$93,$00,$12,$a0,$d3,$1b,$fc,$fe,$bc,$53,$f4,$fe,$bd,$53,$fc
        .byte   $06,$cc,$53,$f4,$06,$cd,$53,$f6,$f3,$ac,$14,$fe,$f3,$ad,$14,$f6
        .byte   $fb,$bc,$14,$fe,$fb,$bd,$14,$04,$ec,$da,$52,$fc,$ec,$db,$52,$f4
        .byte   $ec,$dc,$52,$04,$f4,$ea,$52,$fc,$f4,$eb,$52,$f4,$f4,$ec,$52,$04
        .byte   $fc,$8a,$53,$fc,$fc,$8b,$53,$f4,$fc,$8c,$53,$04,$04,$9a,$53,$fc
        .byte   $04,$9b,$53,$f4,$04,$9c,$53,$04,$0c,$aa,$53,$fc,$0c,$ab,$53,$f4
        .byte   $0c,$ac,$53,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00
        .byte   $12,$a0,$d3,$1b,$fc,$ff,$dc,$53,$f4,$ff,$dd,$53,$fc,$07,$ec,$53
        .byte   $f4,$07,$ed,$53,$f6,$f1,$ac,$14,$fe,$f1,$ad,$14,$f6,$f9,$bc,$14
        .byte   $fe,$f9,$bd,$14,$04,$ec,$dd,$52,$fc,$ec,$de,$52,$f4,$ec,$df,$52
        .byte   $04,$f4,$ed,$52,$fc,$f4,$ee,$52,$f4,$f4,$ef,$52,$04,$fc,$8d,$53
        .byte   $fc,$fc,$8e,$53,$f4,$fc,$8f,$53,$04,$04,$9d,$53,$fc,$04,$9e,$53
        .byte   $f4,$04,$9f,$53,$04,$0c,$ad,$53,$fc,$0c,$ae,$53,$f4,$0c,$af,$53
        .byte   $f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3
        .byte   $1b,$fc,$ff,$de,$53,$f4,$ff,$df,$53,$fc,$07,$ee,$53,$f4,$07,$ef
        .byte   $53,$f6,$f2,$ac,$14,$fe,$f2,$ad,$14,$f6,$fa,$bc,$14,$fe,$fa,$bd
        .byte   $14,$04,$ec,$b0,$53,$fc,$ec,$b1,$53,$f4,$ec,$b2,$53,$04,$f4,$c0
        .byte   $53,$fc,$f4,$c1,$53,$f4,$f4,$c2,$53,$04,$fc,$d0,$53,$fc,$fc,$d1
        .byte   $53,$f4,$fc,$d2,$53,$04,$04,$e0,$53,$fc,$04,$e1,$53,$f4,$04,$e2
        .byte   $53,$04,$0c,$f0,$53,$fc,$0c,$f1,$53,$f4,$0c,$f2,$53,$f8,$0a,$a0
        .byte   $13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$1b,$fc,$fe
        .byte   $be,$53,$f4,$fe,$bf,$53,$fc,$06,$ce,$53,$f4,$06,$cf,$53,$f6,$f3
        .byte   $ac,$14,$fe,$f3,$ad,$14,$f6,$fb,$bc,$14,$fe,$fb,$bd,$14,$04,$ec
        .byte   $b3,$53,$fc,$ec,$b4,$53,$f4,$ec,$b5,$53,$04,$f4,$c3,$53,$fc,$f4
        .byte   $c4,$53,$f4,$f4,$c5,$53,$04,$fc,$d3,$53,$fc,$fc,$d4,$53,$f4,$fc
        .byte   $d5,$53,$04,$04,$e3,$53,$fc,$04,$e4,$53,$f4,$04,$e5,$53,$04,$0c
        .byte   $f3,$53,$fc,$0c,$f4,$53,$f4,$0c,$f5,$53,$f8,$0a,$a0,$13,$00,$0a
        .byte   $a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$1b,$f4,$ff,$dc,$13,$fc
        .byte   $ff,$dd,$13,$f4,$07,$ec,$13,$fc,$07,$ed,$13,$f6,$f1,$ac,$14,$fe
        .byte   $f1,$ad,$14,$f6,$f9,$bc,$14,$fe,$f9,$bd,$14,$04,$ec,$b6,$53,$fc
        .byte   $ec,$b7,$53,$f4,$ec,$b8,$53,$04,$f4,$c6,$53,$fc,$f4,$c7,$53,$f4
        .byte   $f4,$c8,$53,$04,$fc,$d6,$53,$fc,$fc,$d7,$53,$f4,$fc,$d8,$53,$04
        .byte   $04,$e6,$53,$fc,$04,$e7,$53,$f4,$04,$e8,$53,$04,$0c,$f6,$53,$fc
        .byte   $0c,$f7,$53,$f4,$0c,$f8,$53,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8
        .byte   $12,$a0,$93,$00,$12,$a0,$d3,$1b,$f4,$ff,$de,$13,$fc,$ff,$df,$13
        .byte   $f4,$07,$ee,$13,$fc,$07,$ef,$13,$f6,$f2,$ac,$14,$fe,$f2,$ad,$14
        .byte   $f6,$fa,$bc,$14,$fe,$fa,$bd,$14,$04,$ec,$b9,$53,$fc,$ec,$ba,$53
        .byte   $f4,$ec,$bb,$53,$04,$f4,$c9,$53,$fc,$f4,$ca,$53,$f4,$f4,$cb,$53
        .byte   $04,$fc,$d9,$53,$fc,$fc,$da,$53,$f4,$fc,$db,$53,$04,$04,$e9,$53
        .byte   $fc,$04,$ea,$53,$f4,$04,$eb,$53,$04,$0c,$f9,$53,$fc,$0c,$fa,$53
        .byte   $f4,$0c,$fb,$53,$f8,$0a,$a0,$13,$00,$0a,$a0,$53,$f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3,$16,$f8,$00,$cc,$12,$00,$00,$cd,$12,$f8,$08,$ce
        .byte   $12,$00,$08,$cf,$12,$f8,$f3,$ac,$14,$00,$f3,$ad,$14,$f8,$fb,$bc
        .byte   $14,$00,$fb,$bd,$14,$f8,$ec,$c2,$12,$00,$ec,$c3,$12,$f8,$f4,$c4
        .byte   $12,$00,$f4,$c5,$12,$f8,$fc,$c6,$12,$00,$fc,$c7,$12,$f8,$04,$c8
        .byte   $12,$00,$04,$c9,$12,$f8,$0c,$ca,$12,$00,$0c,$cb,$12,$f8,$0a,$a0
        .byte   $13,$00,$0a,$a0,$53,$f8,$12,$a0,$93,$00,$12,$a0,$d3,$06,$f8,$e8
        .byte   $f0,$10,$00,$e8,$f1,$10,$f8,$f0,$f2,$10,$00,$f0,$f3,$10,$f8,$f8
        .byte   $f4,$10,$00,$f8,$f5,$10,$06,$f8,$e8,$f0,$10,$00,$e8,$f1,$10,$f8
        .byte   $f0,$f2,$10,$00,$f0,$f3,$10,$00,$f8,$f4,$50,$f8,$f8,$f5,$50,$06
        .byte   $00,$e8,$f0,$50,$f8,$e8,$f1,$50,$00,$f0,$f2,$50,$f8,$f0,$f3,$50
        .byte   $f8,$f8,$f4,$10,$00,$f8,$f5,$10,$06,$00,$e8,$f0,$50,$f8,$e8,$f1
        .byte   $50,$00,$f0,$f2,$50,$f8,$f0,$f3,$50,$00,$f8,$f4,$50,$f8,$f8,$f5
        .byte   $50,$06,$f8,$e8,$f0,$10,$00,$e8,$f1,$10,$f8,$f0,$f2,$10,$00,$f0
        .byte   $f3,$10,$f8,$f8,$f4,$08,$00,$f8,$f5,$08,$06,$f8,$e8,$f0,$10,$00
        .byte   $e8,$f1,$10,$f8,$f0,$f2,$10,$00,$f0,$f3,$10,$00,$f8,$f4,$48,$f8
        .byte   $f8,$f5,$48,$06,$00,$e8,$f0,$50,$f8,$e8,$f1,$50,$00,$f0,$f2,$50
        .byte   $f8,$f0,$f3,$50,$f8,$f8,$f4,$08,$00,$f8,$f5,$08,$06,$00,$e8,$f0
        .byte   $50,$f8,$e8,$f1,$50,$00,$f0,$f2,$50,$f8,$f0,$f3,$50,$00,$f8,$f4
        .byte   $48,$f8,$f8,$f5,$48,$17,$08,$00,$41,$15,$10,$00,$42,$15,$18,$00
        .byte   $43,$15,$00,$08,$50,$15,$08,$08,$51,$15,$10,$08,$52,$15,$18,$08
        .byte   $53,$15,$20,$08,$54,$15,$00,$10,$60,$15,$08,$10,$61,$15,$10,$10
        .byte   $62,$15,$18,$10,$63,$15,$20,$10,$64,$15,$00,$18,$70,$15,$08,$18
        .byte   $71,$15,$10,$18,$72,$15,$18,$18,$73,$15,$20,$18,$74,$15,$00,$20
        .byte   $48,$15,$08,$20,$49,$15,$10,$20,$4a,$15,$18,$20,$4b,$15,$20,$20
        .byte   $4c,$15,$12,$08,$00,$41,$15,$10,$00,$42,$15,$18,$00,$43,$15,$00
        .byte   $08,$50,$15,$08,$08,$51,$15,$10,$08,$52,$15,$18,$08,$53,$15,$20
        .byte   $08,$54,$15,$00,$10,$60,$15,$08,$10,$61,$15,$10,$10,$62,$15,$18
        .byte   $10,$63,$15,$20,$10,$64,$15,$00,$18,$70,$15,$08,$18,$71,$15,$10
        .byte   $18,$72,$15,$18,$18,$73,$15,$20,$18,$74,$15,$0d,$08,$00,$41,$15
        .byte   $10,$00,$42,$15,$18,$00,$43,$15,$00,$08,$50,$15,$08,$08,$51,$15
        .byte   $10,$08,$52,$15,$18,$08,$53,$15,$20,$08,$54,$15,$00,$10,$60,$15
        .byte   $08,$10,$61,$15,$10,$10,$62,$15,$18,$10,$63,$15,$20,$10,$64,$15
        .byte   $08,$08,$00,$41,$15,$10,$00,$42,$15,$18,$00,$43,$15,$00,$08,$50
        .byte   $15,$08,$08,$51,$15,$10,$08,$52,$15,$18,$08,$53,$15,$20,$08,$54
        .byte   $15,$03,$08,$00,$41,$15,$10,$00,$42,$15,$18,$00,$43,$15,$04,$00
        .byte   $00,$65,$15,$08,$00,$66,$15,$00,$08,$75,$15,$08,$08,$76,$15,$04
        .byte   $08,$08,$65,$d5,$00,$08,$66,$d5,$08,$00,$75,$d5,$00,$00,$76,$d5
        .byte   $04,$00,$00,$45,$15,$08,$00,$46,$15,$00,$08,$55,$15,$08,$08,$56
        .byte   $15,$04,$08,$08,$45,$d5,$00,$08,$46,$d5,$08,$00,$55,$d5,$00,$00
        .byte   $56,$d5,$04,$f8,$f0,$5c,$11,$00,$f0,$5d,$11,$f8,$f8,$6c,$11,$00
        .byte   $f8,$6d,$11,$04,$f9,$f0,$78,$11,$01,$f0,$79,$11,$f9,$f8,$7a,$11
        .byte   $01,$f8,$7b,$11,$04,$f8,$f0,$59,$51,$00,$f0,$58,$51,$f8,$f8,$69
        .byte   $51,$00,$f8,$68,$51,$04,$f8,$f1,$4f,$51,$00,$f1,$4e,$51,$f8,$f9
        .byte   $5f,$51,$00,$f9,$5e,$51,$04,$f8,$f0,$5a,$11,$00,$f0,$5b,$11,$f8
        .byte   $f8,$6a,$11,$00,$f8,$6b,$11,$04,$f9,$f0,$6e,$11,$01,$f0,$6f,$11
        .byte   $f9,$f8,$7e,$11,$01,$f8,$7f,$11,$04,$f8,$f0,$58,$11,$00,$f0,$59
        .byte   $11,$f8,$f8,$68,$11,$00,$f8,$69,$11,$04,$f8,$f1,$4e,$11,$00,$f1
        .byte   $4f,$11,$f8,$f9,$5e,$11,$00,$f9,$5f,$11,$02,$00,$f8,$7c,$13,$00
        .byte   $00,$7c,$93,$0a,$f8,$7c,$13,$0a,$00,$7c,$93,$02,$0a,$f8,$7c,$13
        .byte   $0a,$00,$7c,$93,$14,$f8,$7c,$13,$14,$00,$7c,$93,$02,$14,$f8,$7c
        .byte   $13,$14,$00,$7c,$93,$00,$f8,$7c,$13,$00,$00,$7c,$93,$02,$00,$f8
        .byte   $7c,$53,$00,$00,$7c,$d3,$f6,$f8,$7c,$53,$f6,$00,$7c,$d3,$02,$f6
        .byte   $f8,$7c,$53,$f6,$00,$7c,$d3,$ec,$f8,$7c,$53,$ec,$00,$7c,$d3,$02
        .byte   $ec,$f8,$7c,$53,$ec,$00,$7c,$d3,$00,$f8,$7c,$53,$00,$00,$7c,$d3
        .byte   $07,$f7,$f4,$ea,$12,$ff,$f4,$eb,$12,$07,$f4,$ec,$12,$0f,$f4,$ed
        .byte   $12,$ff,$fc,$ee,$12,$07,$fc,$ef,$12,$0f,$fc,$bf,$12,$0c,$f8,$f0
        .byte   $e0,$12,$00,$f0,$e1,$12,$08,$f0,$e2,$12,$10,$f0,$e3,$12,$18,$f0
        .byte   $ae,$12,$f8,$f8,$e4,$12,$00,$f8,$e5,$12,$08,$f8,$e6,$12,$10,$f8
        .byte   $e7,$12,$18,$f8,$be,$12,$00,$00,$e8,$12,$08,$00,$e9,$12,$0e,$f6
        .byte   $ed,$d2,$12,$fe,$ed,$d3,$12,$06,$ed,$d4,$12,$0e,$ed,$d5,$12,$16
        .byte   $ed,$d6,$12,$f6,$f5,$d7,$12,$fe,$f5,$d8,$12,$06,$f5,$d9,$12,$0e
        .byte   $f5,$da,$12,$16,$f5,$db,$12,$fe,$fd,$dc,$12,$06,$fd,$dd,$12,$0e
        .byte   $fd,$de,$12,$16,$fd,$df,$12,$12,$f8,$e8,$c0,$12,$00,$e8,$c1,$12
        .byte   $08,$e8,$c2,$12,$10,$e8,$c3,$12,$18,$e8,$c4,$12,$f0,$f0,$c5,$12
        .byte   $f8,$f0,$c6,$12,$00,$f0,$c7,$12,$08,$f0,$c8,$12,$10,$f0,$c9,$12
        .byte   $18,$f0,$ca,$12,$f8,$f8,$cb,$12,$00,$f8,$cc,$12,$08,$f8,$cd,$12
        .byte   $10,$f8,$ce,$12,$18,$f8,$cf,$12,$00,$00,$d0,$12,$08,$00,$d1,$12
        .byte   $10,$f8,$f8,$a0,$12,$00,$f8,$a1,$12,$f8,$00,$b0,$12,$00,$00,$b1
        .byte   $12,$f8,$f0,$a2,$12,$00,$f0,$a3,$12,$f8,$f8,$b2,$12,$00,$f8,$b3
        .byte   $12,$f8,$00,$a4,$12,$00,$00,$a5,$12,$f8,$08,$b4,$12,$00,$08,$b5
        .byte   $12,$f8,$04,$a0,$13,$00,$04,$a0,$53,$f8,$0c,$a0,$93,$00,$0c,$a0
        .byte   $d3,$10,$f9,$f8,$a0,$12,$01,$f8,$a1,$12,$f9,$00,$b0,$12,$01,$00
        .byte   $b1,$12,$f8,$f0,$a6,$12,$00,$f0,$a7,$12,$f8,$f8,$b6,$12,$00,$f8
        .byte   $b7,$12,$f8,$00,$a8,$12,$00,$00,$a9,$12,$f8,$08,$b8,$12,$00,$08
        .byte   $b9,$12,$f8,$04,$a0,$13,$00,$04,$a0,$53,$f8,$0c,$a0,$93,$00,$0c
        .byte   $a0,$d3,$10,$f7,$f8,$a0,$12,$ff,$f8,$a1,$12,$f7,$00,$b0,$12,$ff
        .byte   $00,$b1,$12,$f8,$f0,$a7,$52,$00,$f0,$a6,$52,$f8,$f8,$b7,$52,$00
        .byte   $f8,$b6,$52,$f8,$00,$a9,$52,$00,$00,$a8,$52,$f8,$08,$b9,$52,$00
        .byte   $08,$b8,$52,$f8,$04,$a0,$13,$00,$04,$a0,$53,$f8,$0c,$a0,$93,$00
        .byte   $0c,$a0,$d3,$10,$f8,$f8,$98,$12,$00,$f8,$99,$12,$f8,$00,$9a,$12
        .byte   $00,$00,$9b,$12,$f8,$f0,$a2,$12,$00,$f0,$a3,$12,$f8,$f8,$b2,$12
        .byte   $00,$f8,$b3,$12,$f8,$00,$a4,$12,$00,$00,$a5,$12,$f8,$08,$b4,$12
        .byte   $00,$08,$b5,$12,$f8,$04,$a0,$13,$00,$04,$a0,$53,$f8,$0c,$a0,$93
        .byte   $00,$0c,$a0,$d3,$0e,$f6,$ed,$d2,$12,$fe,$ed,$d3,$12,$06,$ed,$d4
        .byte   $12,$0e,$ed,$ac,$12,$16,$ed,$ad,$12,$f6,$f5,$d7,$12,$fe,$f5,$d8
        .byte   $12,$06,$f5,$d9,$12,$0e,$f5,$bc,$12,$16,$f5,$bd,$12,$fe,$fd,$dc
        .byte   $12,$06,$fd,$dd,$12,$0e,$fd,$de,$12,$16,$fd,$df,$12,$06,$f8,$f4
        .byte   $84,$15,$00,$f4,$85,$15,$f8,$fc,$94,$15,$00,$fc,$95,$15,$f8,$04
        .byte   $a4,$15,$00,$04,$a5,$15,$06,$f8,$f4,$86,$15,$00,$f4,$87,$15,$f8
        .byte   $fc,$96,$15,$00,$fc,$97,$15,$f8,$04,$a6,$15,$00,$04,$a7,$15,$06
        .byte   $f8,$f4,$88,$15,$00,$f4,$89,$15,$f8,$fc,$98,$15,$00,$fc,$99,$15
        .byte   $f8,$04,$a8,$15,$00,$04,$a9,$15,$06,$f8,$f4,$8a,$15,$00,$f4,$8b
        .byte   $15,$f8,$fc,$9a,$15,$00,$fc,$9b,$15,$f8,$04,$aa,$15,$00,$04,$ab
        .byte   $15,$06,$f8,$f4,$89,$55,$00,$f4,$88,$55,$f8,$fc,$99,$55,$00,$fc
        .byte   $98,$55,$f8,$04,$a9,$55,$00,$04,$a8,$55,$06,$f8,$f4,$8b,$55,$00
        .byte   $f4,$8a,$55,$f8,$fc,$9b,$55,$00,$fc,$9a,$55,$f8,$04,$ab,$55,$00
        .byte   $04,$aa,$55,$02,$fb,$fb,$0f,$07,$04,$04,$1f,$07,$02,$fb,$fb,$1f
        .byte   $07,$04,$04,$0f,$07,$06,$f8,$f8,$b1,$15,$00,$f8,$b1,$55,$f0,$00
        .byte   $c0,$15,$f8,$00,$c1,$15,$00,$00,$c1,$55,$08,$00,$c0,$55,$0c,$f0
        .byte   $f0,$d0,$15,$f8,$f0,$d1,$15,$00,$f0,$d1,$55,$08,$f0,$d0,$55,$f0
        .byte   $f8,$b2,$15,$f8,$f8,$b3,$15,$00,$f8,$b3,$55,$08,$f8,$b2,$55,$f0
        .byte   $00,$c2,$15,$f8,$00,$c3,$15,$00,$00,$c3,$55,$08,$00,$c2,$55,$12
        .byte   $f8,$e0,$d3,$15,$00,$e0,$d3,$55,$f0,$e8,$b4,$15,$f8,$e8,$b5,$15
        .byte   $00,$e8,$b5,$55,$08,$e8,$b4,$55,$f0,$f0,$c4,$15,$f8,$f0,$c5,$15
        .byte   $00,$f0,$c5,$55,$08,$f0,$c4,$55,$f0,$f8,$d4,$15,$f8,$f8,$d5,$15
        .byte   $00,$f8,$d5,$55,$08,$f8,$d4,$55,$f0,$00,$b6,$15,$f8,$00,$b7,$15
        .byte   $00,$00,$b7,$55,$08,$00,$b6,$55,$14,$f8,$d8,$c7,$15,$00,$d8,$c7
        .byte   $55,$f8,$e0,$d7,$15,$00,$e0,$d7,$55,$f0,$e8,$b8,$15,$f8,$e8,$b9
        .byte   $15,$00,$e8,$b9,$55,$08,$e8,$b8,$55,$f0,$f0,$c8,$15,$f8,$f0,$c9
        .byte   $15,$00,$f0,$c9,$55,$08,$f0,$c8,$55,$f0,$f8,$d8,$15,$f8,$f8,$d9
        .byte   $15,$00,$f8,$d9,$55,$08,$f8,$d8,$55,$f0,$00,$ba,$15,$f8,$00,$bb
        .byte   $15,$00,$00,$bb,$55,$08,$00,$ba,$55,$01,$00,$00,$9f,$15,$03,$fb
        .byte   $fb,$8e,$15,$03,$fb,$8f,$15,$fb,$03,$9e,$15,$04,$f9,$f9,$8c,$15
        .byte   $01,$f9,$8d,$15,$f9,$01,$9c,$15,$01,$01,$9d,$15,$04,$f8,$f8,$ac
        .byte   $15,$00,$f8,$ad,$15,$f8,$00,$ae,$15,$00,$00,$af,$15,$04,$f8,$f8
        .byte   $ca,$15,$00,$f8,$ca,$55,$f8,$00,$da,$15,$00,$00,$da,$55,$02,$f8
        .byte   $00,$cb,$15,$00,$00,$cb,$55,$02,$f8,$00,$db,$15,$00,$00,$db,$55
        .byte   $0b,$fa,$f0,$f9,$12,$02,$f0,$fa,$12,$0a,$f0,$fb,$12,$12,$f0,$fc
        .byte   $12,$fa,$f8,$fd,$12,$02,$f8,$fe,$12,$0a,$f8,$ff,$12,$12,$f8,$ae
        .byte   $12,$02,$00,$bc,$12,$0a,$00,$bd,$12,$12,$00,$be,$12,$0e,$f6,$ef
        .byte   $e5,$12,$fe,$ef,$e6,$12,$06,$ef,$e7,$12,$0e,$ef,$e8,$12,$16,$ef
        .byte   $e9,$12,$f6,$f7,$ea,$12,$fe,$f7,$eb,$12,$06,$f7,$ec,$12,$0e,$f7
        .byte   $ed,$12,$16,$f7,$ee,$12,$fe,$ff,$ef,$12,$06,$ff,$f6,$12,$0e,$ff
        .byte   $f7,$12,$16,$ff,$f8,$12,$0f,$f4,$ea,$d6,$12,$fc,$ea,$d7,$12,$04
        .byte   $ea,$d8,$12,$0c,$ea,$d9,$12,$14,$ea,$da,$12,$f4,$f2,$db,$12,$fc
        .byte   $f2,$dc,$12,$04,$f2,$dd,$12,$0c,$f2,$de,$12,$14,$f2,$df,$12,$f4
        .byte   $fa,$e0,$12,$fc,$fa,$e1,$12,$04,$fa,$e2,$12,$0c,$fa,$e3,$12,$14
        .byte   $fa,$e4,$12,$16,$f6,$e8,$c0,$12,$fe,$e8,$c1,$12,$06,$e8,$c2,$12
        .byte   $0e,$e8,$c3,$12,$16,$e8,$c4,$12,$ee,$f0,$c5,$12,$f6,$f0,$c6,$12
        .byte   $fe,$f0,$c7,$12,$06,$f0,$c8,$12,$0e,$f0,$c9,$12,$16,$f0,$ca,$12
        .byte   $ee,$f8,$cb,$12,$f6,$f8,$cc,$12,$fe,$f8,$cd,$12,$06,$f8,$ce,$12
        .byte   $0e,$f8,$cf,$12,$16,$f8,$d0,$12,$f6,$00,$d1,$12,$fe,$00,$d2,$12
        .byte   $06,$00,$d3,$12,$0e,$00,$d4,$12,$16,$00,$d5,$12,$0f,$f4,$ea,$d6
        .byte   $12,$fc,$ea,$d7,$12,$04,$ea,$d8,$12,$0c,$ea,$d9,$12,$14,$ea,$da
        .byte   $12,$f4,$f2,$db,$12,$fc,$f2,$dc,$12,$04,$f2,$dd,$12,$0c,$f2,$de
        .byte   $12,$14,$f2,$af,$12,$f4,$fa,$e0,$12,$fc,$fa,$e1,$12,$04,$fa,$e2
        .byte   $12,$0c,$fa,$e3,$12,$14,$fa,$bf,$12,$05,$f4,$02,$04,$00,$fc,$02
        .byte   $04,$00,$04,$02,$04,$00,$0c,$02,$04,$00,$14,$02,$04,$00,$0a,$f4
        .byte   $02,$04,$00,$fc,$02,$04,$00,$04,$02,$04,$00,$0c,$02,$04,$00,$14
        .byte   $02,$04,$00,$f4,$0a,$04,$00,$fc,$0a,$04,$00,$04,$0a,$04,$00,$0c
        .byte   $0a,$04,$00,$14,$0a,$04,$00,$0f,$f4,$02,$04,$00,$fc,$02,$04,$00
        .byte   $04,$02,$04,$00,$0c,$02,$04,$00,$14,$02,$04,$00,$f4,$0a,$04,$00
        .byte   $fc,$0a,$04,$00,$04,$0a,$04,$00,$0c,$0a,$04,$00,$14,$0a,$04,$00
        .byte   $f4,$12,$04,$00,$fc,$12,$04,$00,$04,$12,$04,$00,$0c,$12,$04,$00
        .byte   $14,$12,$04,$00,$04,$00,$f8,$7c,$15,$00,$00,$7c,$95,$0a,$f8,$7c
        .byte   $15,$0a,$00,$7c,$95,$14,$f8,$7c,$15,$14,$00,$7c,$95,$04,$00,$f8
        .byte   $7c,$55,$00,$00,$7c,$d5,$f6,$f8,$7c,$55,$f6,$00,$7c,$d5,$ec,$f8
        .byte   $7c,$55,$ec,$00,$7c,$d5

; ------------------------------------------------------------------------------

; [  ]

_ee6bec:
keycontrol:
@6bec:  php
        shorta
        lda     $20
        cmp     #$02
        bne     @6bf8
        jmp     _ee6f6d
@6bf8:  shorta
        longi
        lda     $05
        bit     #$40
        beq     @6c05
        jmp     _ee6d45
@6c05:  shorta
        longi
        lda     $05
        bit     #$01
        beq     @6c2e
        longa
        lda     $29
        sec
        sbc     #$0020
        sta     $29
        lda     $2b
        sbc     #$0000
        sta     $2b
        lda     #$fe00
        cmp     $29
        bmi     @6c7a
        lda     #$fe00
        sta     $29
        bra     @6c7a
@6c2e:  shorta
        lda     $05
        bit     #$02
        beq     @6c56
        longa
        longac
        lda     $29
        adc     #$0020
        sta     $29
        lda     $2b
        adc     #$0000
        sta     $2b
        lda     #$0201
        cmp     $29
        bpl     @6c7a
        lda     #$0200
        sta     $29
        bra     @6c7a
@6c56:  longa
        lda     $29
        beq     @6c7a
        bmi     @6c6d
        sec
        sbc     #$0010
        sta     $29
        lda     $2b
        sbc     #$0000
        sta     $2b
        bra     @6c7a
@6c6d:  clc
        adc     #$0010
        sta     $29
        lda     $2b
        adc     #$0000
        sta     $2b
@6c7a:  longa
        lda     $04
        bit     #$0080
        beq     @6c92
        lda     $26
        clc
        adc     #$0040
        cmp     #$0801
        bpl     @6ca2
        sta     $26
        bra     @6ca2
@6c92:  lda     $26
        sec
        sbc     #$0080
        cmp     #$0000
        bpl     @6ca0
        lda     #$0000
@6ca0:  sta     $26
@6ca2:  shorta
        lda     $05
        bit     #$08
        beq     @6cbb
        longa
        lda     $2d
        sec
        sbc     #$0020
        cmp     #$fe00
        bmi     @6cea
        sta     $2d
        bra     @6cea
@6cbb:  shorta
        lda     $05
        bit     #$04
        beq     @6cd4
        longa
        lda     $2d
        clc
        adc     #$0020
        cmp     #$0201
        bpl     @6cea
        sta     $2d
        bra     @6cea
@6cd4:  longa
        lda     $2d
        bmi     @6ce4
        sec
        sbc     #$0010
        bcc     @6cea
        sta     $2d
        bra     @6cea
@6ce4:  clc
        adc     #$0010
        sta     $2d
@6cea:  longa
        lda     $04
        and     #$0220
        cmp     #$0220
        bne     @6d07
        lda     a:$0073
        inc2
        cmp     #$0168
        bmi     @6d04
        sec
        sbc     #$0168
@6d04:  sta     a:$0073
@6d07:  lda     $04
        and     #$0110
        cmp     #$0110
        bne     @6d22
        lda     a:$0073
        dec2
        cmp     #$0000
        bpl     @6d1f
        clc
        adc     #$0168
@6d1f:  sta     a:$0073
@6d22:  lda     $05
        bit     #$0080
        beq     @6d2c       ; branch if b button is not pressed
        jsr     LandAirship
@6d2c:  jmp     _ee6e7e

; ------------------------------------------------------------------------------

_ee6d2f:
@6d2f:  .word   $0000,$010e,$005a,$0000,$00b4,$00e1,$0087,$0000
        .word   $0000,$013b,$002d

; ------------------------------------------------------------------------------

; [  ]

_ee6d45:
@6d45:  longa
        lda     $05
        and     #$000f
        bne     @6d51
        jmp     @6e38
@6d51:  asl
        tax
        lda     f:_ee6d2f,x
        clc
        adc     $73
        cmp     #$0168
        bcc     @6d62
        sbc     #$0168
@6d62:  sta     $58
        cmp     #$00b4
        bcc     @6d6c
        sbc     #$00b4
@6d6c:  tax
        lda     f:WorldSineTbl+1,x
        sta     $5e
        lda     f:WorldSineTbl+91,x
        sta     $60
        longa
        shorti
        lda     $58
        cmp     #$00b4
        bcc     @6d99
        ldx     #$00
        stx     $5b
        cmp     #$010e
        bcc     @6d93
@6d8d:  ldx     #$01
        stx     $5a
        bra     @6da4
@6d93:  ldx     #$00
        stx     $5a
        bra     @6da4
@6d99:  ldx     #$01
        stx     $5b
        cmp     #$005a
        bcc     @6d8d
        bra     @6d93
@6da4:  stz     $6b
        ldx     $60
        stx     hWRMPYA
        ldx     #$02
        stx     hWRMPYB
        nop3
        lda     hRDMPYL
        sta     $6a
        ldx     $5a
        bne     @6dd1
        clc
        adc     $37
        sta     $37
        lda     $39
        adc     #$0000
        sta     $39
        clc
        lda     $40
        adc     $6a
        sta     $40
        bra     @6de8
@6dd1:  sta     $6a
        lda     $37
        sec
        sbc     $6a
        sta     $37
        lda     $39
        sbc     #$0000
        sta     $39
        sec
        lda     $40
        sbc     $6a
        sta     $40
@6de8:  ldx     $5e
        stx     hWRMPYA
        ldx     #$02
        stx     hWRMPYB
        nop3
        lda     hRDMPYL
        sta     $6a
        ldx     $5b
        bne     @6e13
        clc
        adc     $33
        sta     $33
        lda     $35
        adc     #$0000
        sta     $35
        clc
        lda     $3c
        adc     $6a
        sta     $3c
        bra     @6e2a
@6e13:  sta     $6a
        lda     $33
        sec
        sbc     $6a
        sta     $33
        lda     $35
        sbc     #$0000
        sta     $35
        sec
        lda     $3c
        sbc     $6a
        sta     $3c
@6e2a:  lda     $34
        and     #$0fff
        sta     $34
        lda     $38
        and     #$0fff
        sta     $38
@6e38:  lda     $29
        beq     @6e5a
        bmi     @6e4d
        sec
        sbc     #$0010
        sta     $29
        lda     $2b
        sbc     #$0000
        sta     $2b
        bra     @6e5a
@6e4d:  clc
        adc     #$0010
        sta     $29
        lda     $2b
        adc     #$0000
        sta     $2b
@6e5a:  lda     $2d
        bmi     @6e68
        sec
        sbc     #$0010
        bcc     @6e6e
        sta     $2d
        bra     @6e6e
@6e68:  clc
        adc     #$0010
        sta     $2d
@6e6e:  lda     $26
        sec
        sbc     #$0080
        cmp     #$0000
        bpl     @6e7c
        lda     #$0000
@6e7c:  sta     $26

_ee6e7e:
@6e7e:  longa
        lda     $32
        bit     #$0010
        bne     @6ead
        lda     $05
        bit     #$0010
        beq     @6ead
        lda     $11f6
        bit     #$0001
        bne     @6ea4
        ora     #$0001
        sta     $11f6
        jsr     HideMinimap
        jsr     HideMinimapPos
        bra     @6ead
@6ea4:  and     #$fffe
        sta     $11f6
        jsr     ShowMinimap
@6ead:  lda     $04
        sta     $31
        lda     $19
        bne     @6ee8
        lda     $08
        bit     #$0040
        beq     @6ee8
        stz     $ed
        lda     $2f
        sta     $11f4
        lda     $73
        ora     #$8000
        sta     $11f2
        shorta
        lda     f:VehicleEvent_00     ; ca/0068 (blackjack deck)
        sta     $ea
        lda     f:VehicleEvent_00+1
        sta     $eb
        lda     f:VehicleEvent_00+2
        clc
        adc     #$ca
        sta     $ec
        lda     $e7
        ora     #$41
        sta     $e7
@6ee8:  shorta
        lda     $1f64
        cmp     #$01
        bne     @6f6b
        lda     $04
        bit     #$80
        beq     @6f6b
        lda     $1dd2
        bit     #$01
        bne     @6f6b
        longai
        lda     $34
        lsr6
        and     #$00ff
        sta     $58
        lda     $38
        lsr6
        and     #$00ff
        sta     $5a
        ldx     #$0000
@6f1d:  lda     f:$000b00,x
        cmp     $58
        bne     @6f2f
        lda     f:$000b02,x
        cmp     $5a
        bne     @6f2f
        bra     @6f3a
@6f2f:  inx4
        cpx     #$0008
        bne     @6f1d
        bra     @6f6b
@6f3a:  stz     $26
        stz     $28
        stz     $2a
        stz     $2c
        stz     $2d
        longi
        ldx     #$0174
        lda     f:EventBattleGroup,x
        sta     $11e0
        lda     #$0029      ; battle bg $29 (doom gaze)
        sta     $11e2
        shorta
        stz     $11e4
        lda     $11f6       ; enable battle and ???
        ora     #$22
        sta     $11f6
        lda     $11fa
        ora     #$01
        sta     $11fa
@6f6b:  plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee6f6d:
@6f6d:  shorta
        longi
        lda     $05
        bit     #$01
        beq     @6f96
        longa
        lda     $29
        sec
        sbc     #$0020
        sta     $29
        lda     $2b
        sbc     #$0000
        sta     $2b
        lda     #$fe00
        cmp     $29
        bmi     @6fe0
        lda     #$fe00
        sta     $29
        bra     @6fe0
@6f96:  shorta
        lda     $05
        bit     #$02
        beq     @6fbc
        longac
        lda     $29
        adc     #$0020
        sta     $29
        lda     $2b
        adc     #$0000
        sta     $2b
        lda     #$0201
        cmp     $29
        bpl     @6fe0
        lda     #$0200
        sta     $29
        bra     @6fe0
@6fbc:  longa
        lda     $29
        beq     @6fe0
        bmi     @6fd3
        sec
        sbc     #$0020
        sta     $29
        lda     $2b
        sbc     #$0000
        sta     $2b
        bra     @6fe0
@6fd3:  clc
        adc     #$0020
        sta     $29
        lda     $2b
        adc     #$0000
        sta     $2b
@6fe0:  longa
        lda     $04
        bit     #$0800
        bne     @6fee
        bit     #$0080
        beq     @6ffd
@6fee:  lda     $26
        clc
        adc     #$0040
        cmp     #$0101
        bpl     @700d
        sta     $26
        bra     @700d
@6ffd:  lda     $26
        sec
        sbc     #$0080
        cmp     #$0000
        bpl     @700b
        lda     #$0000
@700b:  sta     $26
@700d:  longa
        lda     $04
        and     #$0220
        cmp     #$0220
        bne     @702a
        lda     a:$0073
        inc2
        cmp     #$0168
        bmi     @7027
        sec
        sbc     #$0168
@7027:  sta     a:$0073
@702a:  lda     $04
        and     #$0110
        cmp     #$0110
        bne     @7045
        lda     a:$0073
        dec2
        cmp     #$0000
        bpl     @7042
        clc
        adc     #$0168
@7042:  sta     a:$0073
@7045:  lda     $05
        bit     #$0080
        beq     @704f       ; branch if b button is not pressed
        jsr     LandAirship
@704f:  longa
        lda     $32
        bit     #$0010
        bne     @707e
        lda     $05
        bit     #$0010
        beq     @707e
        lda     $11f6
        bit     #$0001
        bne     @7075
        ora     #$0001
        sta     $11f6
        jsr     HideMinimap
        jsr     HideMinimapPos
        bra     @707e
@7075:  and     #$fffe
        sta     $11f6
        jsr     ShowMinimap
@707e:  lda     $04
        sta     $31
        plp
        rts

; ------------------------------------------------------------------------------

; [ execute vehicle event command ]

ExecVehicleCmd:
@7084:  php
        shorta
        longi
        lda     $e7         ;
        bit     #$04
        beq     NextVehicleCmdContinue
        lda     $f0
        bra     _709c

NextVehicleCmdContinue:
@7093:  ldy     $ed
        lda     [$ea],y     ; event script pointer
        sta     $f0
        iny
        sty     $ed
_709c:  longa
        and     #$00ff
        asl
        tax
        jmp     (.loword(VehicleCmdTbl),x)   ; vehicle event command jump table

NextVehicleCmdReturn:
@70a6:  plp
        rts

; ------------------------------------------------------------------------------

; [ vehicle event command $00-$7f: move vehicle ]

; b0: -dulrfkt
;     d: go down
;     u: go up
;     l: go left
;     r: go right
;     f: go forward
;     k: go backwards
;     t: double speed turn

VehicleCmd_00:
@70a8:  shorta
        longi
        lda     $e7
        bit     #$04
        bne     @70c1       ; branch if vehicle is already moving
        ldy     $ed
        lda     [$ea],y
        sta     $ef         ; movement distance
        iny
        sty     $ed
        lda     $e7
        ora     #$04
        sta     $e7
@70c1:  stz     $60
        stz     $61
        lda     $f0
        bit     #$01
        beq     @70d1       ; branch if not double speed turns
        lda     #$30
        ora     $60
        sta     $60
@70d1:  lda     $f0
        bit     #$02
        beq     @70dd       ; branch if not going backwards
        lda     #$80
        ora     $61
        sta     $61
@70dd:  lda     $f0
        bit     #$04
        beq     @70e9       ; branch if not going forward
        lda     #$80
        ora     $60
        sta     $60
@70e9:  lda     $f0
        lsr3
        and     #$0f
        ora     $61         ; movement direction
        sta     $61
        lda     $ef
        beq     @70fe       ; branch if distance is zero
        dec
        sta     $ef
        jmp     NextVehicleCmdReturn
@70fe:  lda     $e7
        and     #$fb
        sta     $e7
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $80-$b7: conditional jump (or) ]

VehicleCmd_b0:
@7107:  shorta
        lda     $f0
        and     #$07
        inc
        sta     $58
        ldy     $ed
        longa
        lda     $f0
        and     #$0007
        inc
        asl
        clc
        adc     $ed
        sta     $ed
@7120:  longa
        lda     [$ea],y
        iny2
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        and     #$7fff
        lsr3
        tax
        shorta
        lda     $5b
        bmi     @714a
        lda     $1e80,x
        and     $5c
        beq     @715f
        bra     @7151
@714a:  lda     $1e80,x
        and     $5c
        bne     @715f
@7151:  dec     $58
        bne     @7120
        ldy     $ed
        iny3
        sty     $ed
        jmp     NextVehicleCmdContinue
@715f:  ldy     $ed
        lda     [$ea],y
        clc
        adc     #$00
        sta     $6a
        iny
        lda     [$ea],y
        adc     #$00
        sta     $6b
        iny
        lda     [$ea],y
        adc     #$ca
        sta     $ec
        ldy     $6a
        sty     $ea
        stz     $ed
        stz     $ee
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $b8-$bf: conditional jump (and) ]

VehicleCmd_b8:
@7181:  shorta
        lda     $f0
        and     #$07
        inc
        sta     $58
        ldy     $ed
        longa
        lda     $f0
        and     #$0007
        inc
        asl
        clc
        adc     $ed
        sta     $ed
@719a:  longa
        lda     [$ea],y
        iny2
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        and     #$7fff
        lsr3
        tax
        shorta
        lda     $5b
        bmi     @71c4
        lda     $1e80,x
        and     $5c
        bne     @71f1
        bra     @71cb
@71c4:  lda     $1e80,x
        and     $5c
        beq     @71f1
@71cb:  dec     $58
        bne     @719a
        ldy     $ed
        lda     [$ea],y
        clc
        adc     #$00
        sta     $6a
        iny
        lda     [$ea],y
        adc     #$00
        sta     $6b
        iny
        lda     [$ea],y
        adc     #$ca
        sta     $ec
        ldy     $6a
        sty     $ea
        stz     $ed
        stz     $ee
        jmp     NextVehicleCmdContinue
@71f1:  ldy     $ed
        iny3
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c0:  ]

VehicleCmd_c0:
@71fb:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     $1e
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c1: set camera direction ]

VehicleCmd_c1:
@7209:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     $73
        iny
        lda     [$ea],y
        sta     $74
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c2: set movement direction ]

VehicleCmd_c2:
@721c:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     $75
        iny
        lda     [$ea],y
        sta     $76
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c3: set ??? direction ]

VehicleCmd_c3:
@722f:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     $83
        iny
        lda     [$ea],y
        sta     $84
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c4: set ??? direction ]

VehicleCmd_c4:
@7242:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     $85
        iny
        lda     [$ea],y
        sta     $86
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c5: set altitude ]

VehicleCmd_c5:
@7255:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     $2f
        iny
        lda     [$ea],y
        sta     $30
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c6: move forward ]

VehicleCmd_c6:
@7268:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     $26
        iny
        lda     [$ea],y
        sta     $27
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c7: set airship position ]

VehicleCmd_c7:
@727b:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     f:$001f62
        iny
        lda     [$ea],y
        sta     f:$001f63
        iny
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c8: set event bit ]

VehicleCmd_c8:
@7292:  longai
        ldy     $ed
        lda     [$ea],y
        iny2
        sty     $ed
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        lsr3
        tax
        shorta
        lda     $1e80,x
        ora     $5c
        sta     $1e80,x
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $c9: clear event bit ]

VehicleCmd_c9:
@72bb:  longai
        ldy     $ed
        lda     [$ea],y
        iny2
        sty     $ed
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        lsr3
        tax
        shorta
        lda     $5c
        eor     #$ff
        sta     $5c
        lda     $1e80,x
        and     $5c
        sta     $1e80,x
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $ca-$cf: battle ]

; b1: battle group index
; b2: battle background

VehicleCmd_ca:
@72ea:  shorta
        tdc
        ldy     $ed
        lda     [$ea],y
        longa
        asl2
        tax
        shorta
        lda     $021e       ; low byte of game time (frames)
        cmp     #$2d
        bcc     @7301       ; 3/4 chance to branch
        inx2
@7301:  lda     f:EventBattleGroup,x
        sta     f:$0011e0     ; battle index
        lda     f:EventBattleGroup+1,x
        sta     f:$0011e1
        iny
        lda     [$ea],y
        sta     f:$0011e2     ; battle background
        iny
        sty     $ed
        tdc
        sta     f:$0011e3     ;
        sta     f:$0011e4
        lda     $11f6       ; enable battle
        ora     #$02
        sta     $11f6
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $d0: show vehicle ]

VehicleCmd_d0:
@732f:  shorta
        lda     $e7
        and     #$df
        sta     $e7
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $d1: hide vehicle ]

VehicleCmd_d1:
@733a:  shorta
        lda     $e7
        ora     #$20
        sta     $e7
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $d2: load map ]

VehicleCmd_d2:
@7345:  longa
        ldy     $ed
        lda     [$ea],y
        sta     $f4
        bit     #$0200
        beq     @7378
        lda     f:$001f64
        and     #$01ff
        sta     f:$001f69
        lda     $34
        lsr4
        and     #$00ff
        sta     $58
        lda     $38
        asl4
        and     #$ff00
        clc
        adc     $58
        sta     f:$001f6b
@7378:  iny2
        lda     [$ea],y
        sta     $1c
        iny2
        lda     [$ea],y
        sta     $f1
        iny
        sty     $ed
        dec     a:$0019
        shorta
        lda     $ea
        clc
        adc     $ed
        sta     $ea
        lda     $eb
        adc     $ee
        sta     $eb
        lda     $ec
        adc     #$00
        sta     $ec
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $d3: load map (w/ vehicle) ]

VehicleCmd_d3:
@73a2:  longa
        ldy     $ed
        lda     [$ea],y
        sta     $f4
        bit     #$0200
        beq     @73d5
        lda     f:$001f64
        and     #$01ff
        sta     f:$001f69
        lda     $34
        lsr4
        and     #$00ff
        sta     $58
        lda     $38
        asl4
        and     #$ff00
        clc
        adc     $58
        sta     f:$001f6b
@73d5:  iny2
        lda     [$ea],y
        sta     $1c
        iny2
        lda     [$ea],y
        ora     #$0040
        sta     $f1
        iny
        sty     $ed
        dec     a:$0019
        shorta
        lda     $ea
        clc
        adc     $ed
        sta     $ea
        lda     $eb
        adc     $ee
        sta     $eb
        lda     $ec
        adc     #$00
        sta     $ec
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $d4-$d8: fade in ]

VehicleCmd_d4:
@7402:  shorta
        lda     #$0f
        sta     $22         ; target screen brightness
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $d9: fade out ]

VehicleCmd_d9:
@740b:  shorta
        stz     $22         ; target screen brightness
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $da: show arrows ]

VehicleCmd_da:
@7412:  shorta
        lda     $e8
        ora     #$06
        sta     $e8
        lda     #$00
        sta     $7eb660
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $db: lock arrows ]

VehicleCmd_db:
@7423:  shorta
        lda     $e8
        and     #$fb
        sta     $e8
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $dc: hide arrows ]

VehicleCmd_dc:
@742e:  shorta
        lda     $e8
        and     #$fd
        sta     $e8
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $dd: hide mini-map ]

VehicleCmd_dd:
@7439:  shorta
        lda     f:$0011f6
        ora     #$01
        sta     f:$0011f6
        jsr     HideMinimap
        jsr     HideMinimapPos
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $de:  ]

VehicleCmd_de:
@744e:  shorta
        ldy     $ed
        lda     [$ea],y
        iny
        sta     $7b
        lda     [$ea],y
        iny
        sta     $7d
        sty     $ed
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $df: show mini-map ]

VehicleCmd_df:
@7461:  shorta
        lda     f:$0011f6
        and     #$fe
        sta     f:$0011f6
        jsr     ShowMinimap
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $e0: pause ]

; b1: pause duration

VehicleCmd_e0:
@7473:  shorta
        lda     $ef
        bne     @748c
        ldy     $ed
        lda     [$ea],y
        sta     $ef         ; pause duration
        iny
        sty     $ed
        lda     #$0f
        sta     $f1
        lda     $e7
        ora     #$04
        sta     $e7
@748c:  dec     $f1
        bne     @7498
        dec     $ef
        beq     @749b
        lda     #$04
        sta     $f1
@7498:  jmp     NextVehicleCmdReturn
@749b:  lda     $e7
        and     #$fb
        sta     $e7
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $e1-$f2: ending airship scene ]

VehicleCmd_e1:
@74a4:  php
        phb
        jsr     FalconEndingMain
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $f3: light of judgement 1 ]

VehicleCmd_f3:
@74b0:  php
        phb
        shorta
        lda     $e9
        ora     #$08
        sta     $e9
        jsr     _ee1378
        plb
        plp
        shorta
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $f4: change graphic to falcon ]

VehicleCmd_f4:
@74c4:  php
        phb
        shorta
        stz     hNMITIMEN
        stz     hHDMAEN
        lda     #$80
        sta     hINIDISP
        lda     f:AirshipGfx2Ptr
        sta     $d2
        lda     f:AirshipGfx2Ptr+1
        sta     $d3
        lda     f:AirshipGfx2Ptr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     #$80
        sta     hVMAINC
        ldx     #$6400
        stx     hVMADDL
        ldx     #$1801
        stx     $4300
        ldx     #$2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$1800
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$0000
@751b:  lda     f:WorldSpritePal2,x
        sta     $7ee100,x
        inx
        cpx     #$0020
        bne     @751b
        lda     #$b1
        sta     hNMITIMEN
        stz     $24
@7530:  lda     $24
        beq     @7530
        stz     $24
        plb
        plp
        shorta
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $f5: light of judgement 2 ]

VehicleCmd_f5:
@753d:  php
        phb
        shorta
        lda     $e9
        and     #$f7
        sta     $e9
        jsr     _ee1378
        plb
        plp
        shorta
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [ vehicle event command $f6:  ]

VehicleCmd_f6:
@7551:  php
        phb
        jsr     _ee15c7
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $f7: load pigeon graphics ]

VehicleCmd_f7:
@755d:  shorta
        lda     #$12
        sta     f:$0000ca
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $f8:  ]

VehicleCmd_f8:
@7568:  php
        phb
        jsr     _ee1186
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $f9:  ]

VehicleCmd_f9:
@7574:  php
        phb
        jsr     _ee0eab
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $fa: falcon rising out of water ]

VehicleCmd_fa:
@7580:  php
        phb
        jsr     _ee0c71
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $fb: airship smoking ]

VehicleCmd_fb:
@758c:  php
        phb
        shorta
        lda     #$10
        sta     $ca
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $fc: airship crash ]

VehicleCmd_fc:
@759b:  php
        phb
        phd
        shorta
        lda     #$01
        sta     $ca
        jsr     _ee0b30
        pld
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $fd: load esper terra graphics ]

VehicleCmd_fd:
@75af:  shorta
        lda     #$0c
        sta     f:$0000ca
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $fe: vector approach ]

VehicleCmd_fe:
@75ba:  php
        phb
        phd
        jsr     _ee07c3       ; vector approach
        pld
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $ff: end of script ]

VehicleCmd_ff:
@75c8:  shorta
        lda     $e7
        and     #$fc
        sta     $e7
        jmp     NextVehicleCmdReturn

; ------------------------------------------------------------------------------

; [  ]

_ee75d3:
autocontrol2:
@75d3:  shorta
        lda     $61
        bit     #$01
        beq     @75fa
        longa
        lda     $29
        sec
        sbc     #$0020
        sta     $29
        lda     $2b
        sbc     #$0000
        sta     $2b
        lda     #$fe00
        cmp     $29
        bmi     @7646
        lda     #$fe00
        sta     $29
        bra     @7646
@75fa:  shorta
        lda     $61
        bit     #$02
        beq     @7622
        longa
        longac
        lda     $29
        adc     #$0020
        sta     $29
        lda     $2b
        adc     #$0000
        sta     $2b
        lda     #$0201
        cmp     $29
        bpl     @7646
        lda     #$0200
        sta     $29
        bra     @7646
@7622:  longa
        lda     $29
        beq     @7646
        bmi     @7639
        sec
        sbc     #$0010
        sta     $29
        lda     $2b
        sbc     #$0000
        sta     $2b
        bra     @7646
@7639:  clc
        adc     #$0010
        sta     $29
        lda     $2b
        adc     #$0000
        sta     $2b
@7646:  longa
        lda     $60
        bit     #$0080
        beq     @765e
        lda     $26
        clc
        adc     #$0040
        cmp     #$0801
        bpl     @765e
        sta     $26
        bra     @765e
@765e:  shorta
        lda     $61
        bit     #$80
        beq     @7678
        longa
        lda     $26
        sec
        sbc     #$0080
        cmp     #$0000
        bpl     @7676
        lda     #$0000
@7676:  sta     $26
@7678:  shorta
        lda     $61
        bit     #$08
        beq     @7691
        longa
        lda     $2d
        sec
        sbc     #$0020
        cmp     #$fe00
        bmi     @76c0
        sta     $2d
        bra     @76c0
@7691:  shorta
        lda     $61
        bit     #$04
        beq     @76aa
        longa
        lda     $2d
        clc
        adc     #$0020
        cmp     #$0201
        bpl     @76c0
        sta     $2d
        bra     @76c0
@76aa:  longa
        lda     $2d
        bmi     @76ba
        sec
        sbc     #$0010
        bcc     @76c0
        sta     $2d
        bra     @76c0
@76ba:  clc
        adc     #$0010
        sta     $2d
@76c0:  longa
        lda     $60
        and     #$0220
        cmp     #$0220
        bne     @76dd
        lda     a:$0073
        inc2
        cmp     #$0168
        bmi     @76da
        sec
        sbc     #$0168
@76da:  sta     a:$0073
@76dd:  lda     $60
        and     #$0110
        cmp     #$0110
        bne     @76f8
        lda     a:$0073
        dec2
        cmp     #$0000
        bpl     @76f5
        clc
        adc     #$0168
@76f5:  sta     a:$0073
@76f8:  shorta
        rts

; ------------------------------------------------------------------------------

; vehicle event command jump table
VehicleCmdTbl:
@76fb:
.repeat 128
        .addr   VehicleCmd_00
.endrep
.repeat 48
        .addr   VehicleCmd_b0
.endrep
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b0
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_b8
        .addr   VehicleCmd_c0
        .addr   VehicleCmd_c1
        .addr   VehicleCmd_c2
        .addr   VehicleCmd_c3
        .addr   VehicleCmd_c4
        .addr   VehicleCmd_c5
        .addr   VehicleCmd_c6
        .addr   VehicleCmd_c7
        .addr   VehicleCmd_c8
        .addr   VehicleCmd_c9
        .addr   VehicleCmd_ca
        .addr   VehicleCmd_ca
        .addr   VehicleCmd_ca
        .addr   VehicleCmd_ca
        .addr   VehicleCmd_ca
        .addr   VehicleCmd_ca
        .addr   VehicleCmd_d0
        .addr   VehicleCmd_d1
        .addr   VehicleCmd_d2
        .addr   VehicleCmd_d3
        .addr   VehicleCmd_d4
        .addr   VehicleCmd_d4
        .addr   VehicleCmd_d4
        .addr   VehicleCmd_d4
        .addr   VehicleCmd_d4
        .addr   VehicleCmd_d9
        .addr   VehicleCmd_da
        .addr   VehicleCmd_db
        .addr   VehicleCmd_dc
        .addr   VehicleCmd_dd
        .addr   VehicleCmd_de
        .addr   VehicleCmd_df
        .addr   VehicleCmd_e0
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_e1
        .addr   VehicleCmd_f3
        .addr   VehicleCmd_f4
        .addr   VehicleCmd_f5
        .addr   VehicleCmd_f6
        .addr   VehicleCmd_f7
        .addr   VehicleCmd_f8
        .addr   VehicleCmd_f9
        .addr   VehicleCmd_fa
        .addr   VehicleCmd_fb
        .addr   VehicleCmd_fc
        .addr   VehicleCmd_fd
        .addr   VehicleCmd_fe
        .addr   VehicleCmd_ff

; ------------------------------------------------------------------------------

; [ execute world event command ]

ExecWorldCmd:
@78fb:  php
        ldx     #$0000
        stx     $e3
        stx     $e5
        lda     $e7
        bit     #$04
        beq     NextWorldCmdContinue
        lda     $f0
        bra     _7916

NextWorldCmdContinue:
@790d:  ldy     $ed
        lda     [$ea],y
        sta     $f0
        iny
        sty     $ed
_7916:  longa
        and     #$00ff
        asl
        tax
        jmp     (.loword(WorldCmdTbl),x)   ; world event command jump table

NextWorldCmdReturn:
@7920:  plp
        rts

; ------------------------------------------------------------------------------

; [ world event command $00-$7f: graphical action ]

WorldCmd_00:
@7922:  shorta
        lda     $f0
        sta     $f7
        shorti
        jsr     _ee47f3
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $80-$9f: move character ]

WorldCmd_80:
@7932:  shorta
        lda     $ef
        bne     @7947
        lda     $f0
        lsr2
        and     #$07
        inc
        sta     $ef
        lda     $e7
        ora     #$04
        sta     $e7
@7947:  lda     $f0
        and     #$03
        beq     @796b
        cmp     #$03
        beq     @7986
        cmp     #$01
        beq     @79a1
        lda     $f3
        sta     $e5
        stz     $e6
        stz     $e3
        stz     $e4
        lda     #$02
        sta     $f6
        ldx     #$0000
        ldy     #$0001
        bra     @79b5
@796b:  lda     $f3
        eor     #$ff
        inc
        sta     $e5
        lda     #$ff
        sta     $e6
        stz     $e3
        stz     $e4
        lda     #$00
        sta     $f6
        ldx     #$0000
        ldy     #$ffff
        bra     @79b5
@7986:  lda     $f3
        eor     #$ff
        inc
        sta     $e3
        lda     #$ff
        sta     $e4
        stz     $e5
        stz     $e6
        lda     #$03
        sta     $f6
        ldx     #$ffff
        ldy     #$0000
        bra     @79b5
@79a1:  lda     $f3
        sta     $e3
        stz     $e4
        stz     $e5
        stz     $e6
        lda     #$01
        sta     $f6
        ldx     #$0001
        ldy     #$0000
@79b5:  longa
        jsr     GetTileProp
        bit     #$0020
        bne     @79c6       ; branch if a forest
        lda     $e7
        and     #$ffef
        sta     $e7
@79c6:  shorta
        dec     $ef
        bne     @79d2
        lda     $e7
        and     #$fb
        sta     $e7
@79d2:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a0: move character right/up 1x1 ]

WorldCmd_a0:
@79d5:  shorta
        lda     $f3
        sta     $e3
        stz     $e4
        eor     #$ff
        inc
        sta     $e5
        lda     #$ff
        sta     $e6
        lda     #$00
        sta     $f6
        longa
        ldx     #$0001
        ldy     #$ffff
        jsr     GetTileProp
        bit     #$0020
        bne     @7a01       ; branch if a forest
        lda     $e7
        and     #$ffef      ; make character opaque
        sta     $e7
@7a01:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a1: move character right/down 1x1 ]

WorldCmd_a1:
@7a04:  shorta
        lda     $f3
        sta     $e3
        stz     $e4
        sta     $e5
        stz     $e6
        lda     #$02
        sta     $f6
        longa
        ldx     #$0001
        ldy     #$0001
        jsr     GetTileProp
        bit     #$0020
        bne     @7a2b
        lda     $e7
        and     #$ffef
        sta     $e7
@7a2b:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a2: move character left/down 1x1 ]

WorldCmd_a2:
@7a2e:  shorta
        lda     $f3
        sta     $e5
        stz     $e6
        eor     #$ff
        inc
        sta     $e3
        lda     #$ff
        sta     $e4
        lda     #$02
        sta     $f6
        longa
        ldx     #$ffff
        ldy     #$0001
        jsr     GetTileProp
        bit     #$0020
        bne     @7a5a
        lda     $e7
        and     #$ffef
        sta     $e7
@7a5a:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a3: move character left/up 1x1 ]

WorldCmd_a3:
@7a5d:  shorta
        lda     $f3
        eor     #$ff
        inc
        sta     $e3
        sta     $e5
        lda     #$ff
        sta     $e4
        sta     $e6
        lda     #$00
        sta     $f6
        longa
        ldx     #$ffff
        ldy     #$ffff
        jsr     GetTileProp
        bit     #$0020
        bne     @7a89
        lda     $e7
        and     #$ffef
        sta     $e7
@7a89:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a4: move character right/up 1x2 ]

WorldCmd_a4:
@7a8c:  shorta
        lda     $f3
        sta     $e3
        stz     $e4
        asl
        eor     #$ff
        inc
        sta     $e5
        lda     #$ff
        sta     $e6
        lda     #$00
        sta     $f6
        longa
        ldx     #$0001
        ldy     #$fffe
        jsr     GetTileProp
        bit     #$0020
        bne     @7ab9
        lda     $e7
        and     #$ffef
        sta     $e7
@7ab9:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a5: move character right/up 2x1 ]

WorldCmd_a5:
@7abc:  shorta
        lda     $f3
        asl
        sta     $e3
        stz     $e4
        lda     $f3
        eor     #$ff
        inc
        sta     $e5
        lda     #$ff
        sta     $e6
        lda     #$01
        sta     $f6
        longa
        ldx     #$0002
        ldy     #$ffff
        jsr     GetTileProp
        bit     #$0020
        bne     @7aeb
        lda     $e7
        and     #$ffef
        sta     $e7
@7aeb:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a6: move character right/down 2x1 ]

WorldCmd_a6:
@7aee:  shorta
        lda     $f3
        sta     $e5
        stz     $e6
        asl
        sta     $e3
        stz     $e4
        lda     #$01
        sta     $f6
        longa
        ldx     #$0002
        ldy     #$0001
        jsr     GetTileProp
        bit     #$0020
        bne     @7b16
        lda     $e7
        and     #$ffef
        sta     $e7
@7b16:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a7: move character right/down 1x2 ]

WorldCmd_a7:
@7819:  shorta
        lda     $f3
        sta     $e3
        stz     $e4
        asl
        sta     $e5
        stz     $e6
        lda     #$02
        sta     $f6
        longa
        ldx     #$0001
        ldy     #$0002
        jsr     GetTileProp
        bit     #$0020
        bne     @7b41
        lda     $e7
        and     #$ffef
        sta     $e7
@7b41:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a8: move character left/down 1x2 ]

WorldCmd_a8:
@7b44:  shorta
        lda     $f3
        asl
        sta     $e5
        stz     $e6
        lda     $f3
        eor     #$ff
        inc
        sta     $e3
        lda     #$ff
        sta     $e4
        lda     #$02
        sta     $f6
        longa
        ldx     #$ffff
        ldy     #$0002
        jsr     GetTileProp
        bit     #$0020
        bne     @7b73
        lda     $e7
        and     #$ffef
        sta     $e7
@7b73:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $a9: move character left/down 2x1 ]

WorldCmd_a9:
@7b76:  shorta
        lda     $f3
        sta     $e5
        stz     $e6
        asl
        eor     #$ff
        inc
        sta     $e3
        lda     #$ff
        sta     $e4
        lda     #$03
        sta     $f6
        longa
        ldx     #$fffe
        ldy     #$0001
        jsr     GetTileProp
        bit     #$0020
        bne     @7ba3
        lda     $e7
        and     #$ffef
        sta     $e7
@7ba3:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $aa: move character left/up 2x1 ]

WorldCmd_aa:
@7ba6:  shorta
        lda     $f3
        eor     #$ff
        inc
        sta     $e5
        asl
        sta     $e3
        lda     #$ff
        sta     $e4
        sta     $e6
        lda     #$03
        sta     $f6
        longa
        ldx     #$fffe
        ldy     #$ffff
        jsr     GetTileProp
        bit     #$0020
        bne     @7bd3
        lda     $e7
        and     #$ffef
        sta     $e7
@7bd3:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $ab: move character left/up 1x2 ]

WorldCmd_ab:
@7bd6:  shorta
        lda     $f3
        eor     #$ff
        inc
        sta     $e3
        asl
        sta     $e5
        lda     #$ff
        sta     $e4
        sta     $e6
        lda     #$00
        sta     $f6
        longa
        ldx     #$ffff
        ldy     #$fffe
        jsr     GetTileProp
        bit     #$0020
        bne     @7c03
        lda     $e7
        and     #$ffef
        sta     $e7
@7c03:  jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $ac-$b7: conditional jump (or) ]

WorldCmd_b0:
@7c06:  shorta
        lda     $f0
        and     #$07
        inc
        sta     $58
        ldy     $ed
        longa
        lda     $f0
        and     #$0007
        inc
        asl
        clc
        adc     $ed
        sta     $ed
@7c1f:  longa
        lda     [$ea],y
        iny2
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        and     #$7fff
        lsr3
        tax
        shorta
        lda     $5b
        bmi     @7c49
        lda     $1e80,x
        and     $5c
        beq     @7c5e
        bra     @7c50
@7c49:  lda     $1e80,x
        and     $5c
        bne     @7c5e
@7c50:  dec     $58
        bne     @7c1f
        ldy     $ed
        iny3
        sty     $ed
        jmp     NextWorldCmdContinue
@7c5e:  ldy     $ed
        lda     [$ea],y
        clc
        adc     #$00
        sta     $6a
        iny
        lda     [$ea],y
        adc     #$00
        sta     $6b
        iny
        lda     [$ea],y
        adc     #$ca
        sta     $ec
        ldy     $6a
        sty     $ea
        stz     $ed
        stz     $ee
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $b8-$bf: conditional jump (and) ]

WorldCmd_b8:
@7c80:  shorta
        lda     $f0
        and     #$07
        inc
        sta     $58
        ldy     $ed
        longa
        lda     $f0
        and     #$0007
        inc
        asl
        clc
        adc     $ed
        sta     $ed
@7c99:  longa
        lda     [$ea],y
        iny2
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        and     #$7fff
        lsr3
        tax
        shorta
        lda     $5b
        bmi     @7cc3
        lda     $1e80,x
        and     $5c
        bne     @7cf0
        bra     @7cca
@7cc3:  lda     $1e80,x
        and     $5c
        beq     @7cf0
@7cca:  dec     $58
        bne     @7c99
        ldy     $ed
        lda     [$ea],y
        clc
        adc     #$00
        sta     $6a
        iny
        lda     [$ea],y
        adc     #$00
        sta     $6b
        iny
        lda     [$ea],y
        adc     #$ca
        sta     $ec
        ldy     $6a
        sty     $ea
        stz     $ed
        stz     $ee
        jmp     NextWorldCmdContinue
@7cf0:  ldy     $ed
        iny3
        sty     $ed
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; bitmasks
BitOrTbl:
@7cfa:  .byte   $01,$02,$04,$08,$10,$20,$40,$80

; ------------------------------------------------------------------------------

; [ world event command $c0: set speed to slower ]

WorldCmd_c0:
@7d02:  shorta
        lda     #$04
        sta     $f3
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $c1: set speed to slow ]

WorldCmd_c1:
@7d0b:  shorta
        lda     #$08
        sta     $f3
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $c2: set speed to normal ]

WorldCmd_c2:
@7d14:  shorta
        lda     #$10
        sta     $f3
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $c3: set speed to fast ]

WorldCmd_c3:
@7d1d:  shorta
        lda     #$20
        sta     $f3
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $c4: set speed to faster ]

WorldCmd_c4:
@7d26:  shorta
        lda     #$40
        sta     $f3
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $c5-$c7: set airship position ]

WorldCmd_c5:
@7d2f:  shorta
        ldy     $ed
        lda     [$ea],y
        sta     f:$001f62
        iny
        lda     [$ea],y
        sta     f:$001f63
        iny
        sty     $ed
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $c8: set event bit ]

WorldCmd_c8:
@7d46:  longai
        ldy     $ed
        lda     [$ea],y
        iny2
        sty     $ed
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        lsr3
        tax
        shorta
        lda     $1e80,x
        ora     $5c
        sta     $1e80,x
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $c9: clear event bit ]

WorldCmd_c9:
@7d6f:  longai
        ldy     $ed
        lda     [$ea],y
        iny2
        sty     $ed
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x
        sta     $5c
        lda     $5a
        lsr3
        tax
        shorta
        lda     $5c
        eor     #$ff
        sta     $5c
        lda     $1e80,x
        and     $5c
        sta     $1e80,x
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $ca-$cc: turn character up ]

WorldCmd_cc:
@7d9e:  shorta
        lda     #$00
        sta     $f6
        shorti
        jsr     _ee47e3
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $cd: turn character right ]

WorldCmd_cd:
@7dae:  shorta
        lda     #$01
        sta     $f6
        shorti
        jsr     _ee47e3
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $ce: turn character down ]

WorldCmd_ce:
@7dbe:  shorta
        lda     #$02
        sta     $f6
        shorti
        jsr     _ee47e3
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $cf: turn character left ]

WorldCmd_cf:
@7dce:  shorta
        lda     #$03
        sta     $f6
        shorti
        jsr     _ee47e3
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $d0: show character ]

WorldCmd_d0:
@7dde:  shorta
        lda     $e7
        and     #$df
        sta     $e7
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $d1: hide character ]

WorldCmd_d1:
@7de9:  shorta
        lda     $e7
        ora     #$20
        sta     $e7
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $d2: load map ]

; +b1: ??????pm mmmmmmmm
;      p: save parent map
;      m: map index
;  b3: x position
;  b4: y position
;  b5:

WorldCmd_d2:
@7df4:  longa
        ldy     $ed
        lda     [$ea],y
        sta     $f4
        bit     #$0200
        beq     @7e22
        lda     f:$001f64     ; map index
        and     #$01ff
        sta     f:$001f69     ; parent map index
        shorta
        lda     $e0
        sta     f:$001f6b     ; parent x position
        lda     $e2
        sta     f:$001f6c     ; parent y position
        lda     $f6
        sta     f:$001fd2     ; parent facing direction
        longa
@7e22:  iny2
        lda     [$ea],y
        sta     $1c
        iny2
        lda     [$ea],y
        sta     $f1
        iny
        sty     $ed
        dec     a:$0019
        shorta
        lda     $ea         ; add event script offset to event script pointer
        clc
        adc     $ed
        sta     $ea
        lda     $eb
        adc     $ee
        sta     $eb
        lda     $ec
        adc     #$00
        sta     $ec
        jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $d3: load map (w/ vehicle) ]

WorldCmd_d3:
@7e4c:  longa
        ldy     $ed
        lda     [$ea],y
        sta     $f4
        bit     #$0200
        beq     @7e7a
        lda     f:$001f64
        and     #$01ff
        sta     f:$001f69
        shorta
        lda     $e0
        sta     f:$001f6b
        lda     $e2
        sta     f:$001f6c
        lda     $f6
        sta     f:$001fd2
        longa
@7e7a:  iny2
        lda     [$ea],y
        sta     $1c
        iny2
        lda     [$ea],y
        ora     #$0040      ;
        sta     $f1
        iny
        sty     $ed
        dec     a:$0019
        shorta
        lda     $ea
        clc
        adc     $ed
        sta     $ea
        lda     $eb
        adc     $ee
        sta     $eb
        lda     $ec
        adc     #$00
        sta     $ec
        jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $d4: jump if a button is not pressed ]

; the branch is kinda broken

WorldCmd_d4:
@7ea7:  shorta
        lda     $08
        bit     #$80
        bne     @7ed1       ; branch if a button is pressed
        ldy     $ed
        lda     [$ea],y
        clc
        adc     #$00
        sta     $6a
        iny
        lda     [$ea],y
        adc     #$00
        sta     $6b
        iny
        lda     [$ea],y
        adc     #$ca
        sta     $ec
        ldx     $6a
        stx     $ea
        stz     $ed
        stz     $ee
        jmp     NextWorldCmdContinue
@7ed1:  ldy     $ed
        iny3
        sty     $ed
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $d5: jump based on facing direction ]

;   b1: facing direction (jump if current facing direction doesn't match)
; ++b2: jump address (has to be an absolute address)

WorldCmd_d5:
@7edb:  shorta
        ldy     $ed
        lda     [$ea],y
        iny
        sty     $ed
        cmp     $f6
        bne     @7ef0       ; branch if facing direction doesn't match
        iny3
        sty     $ed
        jmp     NextWorldCmdContinue
@7ef0:  lda     [$ea],y     ; set new event pointer
        clc
        adc     #$00
        sta     $6a
        iny
        lda     [$ea],y
        adc     #$00
        sta     $6b
        iny
        lda     [$ea],y
        sta     $ec
        ldy     $6a
        sty     $ea
        stz     $ed         ; clear event script offset
        stz     $ee
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $d6-$d8: fade in ]

WorldCmd_d8:
@7f0e:  shorta
        lda     #$0f
        sta     $22
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $d9: fade out ]

WorldCmd_d9:
@7f17:  shorta
        stz     $22
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $da-$dd: hide mini-map ]

WorldCmd_dd:
@7f1e:  shorta
        lda     f:$0011f6
        ora     #$01
        sta     f:$0011f6
        jsr     HideMinimap
        jsr     HideMinimapPos
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $de-$df: show mini-map ]

WorldCmd_de:
@7f33:  shorta
        lda     f:$0011f6
        and     #$fe
        sta     f:$0011f6
        jsr     ShowMinimap
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $e0: pause ]

; b1: pause duration

WorldCmd_e0:
@7f45:  shorta
        lda     $ef
        bne     @7f5e
        ldy     $ed
        lda     [$ea],y
        sta     $ef
        iny
        sty     $ed
        lda     #$0f
        sta     $f1
        lda     $e7
        ora     #$04
        sta     $e7
@7f5e:  dec     $f1
        bne     @7f6a
        dec     $ef
        beq     @7f6d
        lda     #$04
        sta     $f1
@7f6a:  jmp     NextWorldCmdReturn
@7f6d:  lda     $e7
        and     #$fb
        sta     $e7
        jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $e1-$fc: change graphic to ship ]

WorldCmd_e1:
@7f76:  shorta
        lda     #$05
        sta     $ca
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $fd: show figaro castle submerging ]

WorldCmd_fd:
@7f7f:  shorta
        phb
        lda     #$7e
        pha
        plb
        lda     $e7
        bit     #$04
        bne     @7fb3
        ldx     #$6400
        stx     $f1
        lda     #$00
        sta     $ef
        longa
        ldx     #0
@7f9a:  lda     f:_ee8066,x   ; figaro castle emerging/submerging data
        sta     $b660,x
        inx2
        cpx     #$0024
        bne     @7f9a
        shorta
        lda     $e7
        ora     #$04
        sta     $e7
        jsr     _ee40be
@7fb3:  lda     $f2
        sta     $b61c
        inc     $ef
        longa
        lda     $ef
        and     #$00ff
        tax
        shorta
        lda     f:WorldSineTbl+1,x
        and     #$03
        cmp     #$03
        bne     @7fd0
        lda     #$01
@7fd0:  clc
        adc     #$76
        sta     $b61a
        lda     $f2
        sec
        sbc     #$64
        lsr3
        clc
        adc     #$2e
        sta     $b618
        ldy     #$0000
        ldx     #$0000
@7fea:  lda     $b660,y
        clc
        adc     $b665,y
        sta     $b5da,x
        lda     $b661,y
        sta     $b5dc,x
        lda     $b662,y
        clc
        adc     #$33
        sta     $b5d8,x
        phx
        lda     $b663,y
        clc
        adc     $b664,y
        sta     $b663,y
        bcc     @8025
        lda     $b662,y
        inc
        and     #$03
        sta     $b662,y
        lda     $ef
        tax
        lda     f:WorldSineTbl+1,x
        and     #$01
        sta     $b665,y
@8025:  plx
        txa
        clc
        adc     #$08
        tax
        tya
        clc
        adc     #$06
        tay
        cmp     #$24
        bne     @7fea
        longac
        lda     $f1
        adc     #$0020
        sta     $f1
        cmp     #$8c00
        bcc     @8062
        shorta
        lda     $e7
        and     #$fb
        sta     $e7
        jsr     _ee4074
        jsr     _ee4118
        ldx     #$00d0
        lda     #$e0
@8055:  sta     $7e6b31,x
        inx4
        cpx     #$012c
        bne     @8055
@8062:  plb
        jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; figaro castle emerging/submerging data
_ee8066:
@8066:  .word   $876d,$0000,$0040
        .word   $8974,$0003,$0030
        .word   $8b7c,$0002,$0042
        .word   $8b82,$0000,$0038
        .word   $8b89,$0001,$0048
        .word   $8790,$0000,$0034

; ------------------------------------------------------------------------------

; [ world event command $fe: show figaro castle emerging ]

WorldCmd_fe:
@808a:  shorta
        phb
        lda     #$7e
        pha
        plb
        lda     $e7
        bit     #$04
        bne     @80be
        ldx     #$8b00
        stx     $f1
        lda     #$00
        sta     $ef
        longa
        ldx     #0
@80a5:  lda     f:_ee8066,x   ; figaro castle emerging/submerging data
        sta     $b660,x
        inx2
        cpx     #$0024
        bne     @80a5
        shorta
        lda     $e7
        ora     #$04
        sta     $e7
        jsr     _ee40be
@80be:  lda     $f2
        sta     $b61c
        inc     $ef
        longa
        lda     $ef
        and     #$00ff
        tax
        shorta
        lda     f:WorldSineTbl+1,x
        and     #$03
        cmp     #$03
        bne     @80db
        lda     #$01
@80db:  clc
        adc     #$76
        sta     $b61a
        lda     $f2
        sec
        sbc     #$64
        lsr3
        clc
        adc     #$2e
        sta     $b618
        ldy     #$0000
        ldx     #$0000
@80f5:  lda     $b660,y
        clc
        adc     $b665,y
        sta     $b5da,x
        lda     $b661,y
        sta     $b5dc,x
        lda     $b662,y
        clc
        adc     #$33
        sta     $b5d8,x
        phx
        lda     $b663,y
        clc
        adc     $b664,y
        sta     $b663,y
        bcc     @8130
        lda     $b662,y
        inc
        and     #$03
        sta     $b662,y
        lda     $ef
        tax
        lda     f:WorldSineTbl+1,x
        and     #$01
        sta     $b665,y
@8130:  plx
        txa
        clc
        adc     #$08
        tax
        tya
        clc
        adc     #$06
        tay
        cmp     #$24
        bne     @80f5
        longa
        lda     $f1
        sec
        sbc     #$0020
        sta     $f1
        cmp     #$6400
        bcs     @817a
        ldx     #$0000
@8151:  tdc
        sta     $b5d8,x
        txa
        clc
        adc     #$0008
        tax
        cmp     #$0030
        bne     @8151
        shorta
        lda     $e7
        and     #$fb
        sta     $e7
        ldx     #$00d0
        lda     #$e0
@816d:  sta     $7e6b31,x
        inx4
        cpx     #$012c
        bne     @816d
@817a:  plb
        jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; [ world event command $ff: end of script ]

WorldCmd_ff:
@817e:  shorta
        lda     $e7
        and     #$fc        ; disable event scripts
        sta     $e7
        jmp     NextWorldCmdReturn

; ------------------------------------------------------------------------------

; world event command jump table
WorldCmdTbl:
@8189:
.repeat 128
        .addr   WorldCmd_00
.endrep
.repeat 32
        .addr   WorldCmd_80
.endrep
        .addr   WorldCmd_a0
        .addr   WorldCmd_a1
        .addr   WorldCmd_a2
        .addr   WorldCmd_a3
        .addr   WorldCmd_a4
        .addr   WorldCmd_a5
        .addr   WorldCmd_a6
        .addr   WorldCmd_a7
        .addr   WorldCmd_a8
        .addr   WorldCmd_a9
        .addr   WorldCmd_aa
        .addr   WorldCmd_ab
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b0
        .addr   WorldCmd_b8
        .addr   WorldCmd_b8
        .addr   WorldCmd_b8
        .addr   WorldCmd_b8
        .addr   WorldCmd_b8
        .addr   WorldCmd_b8
        .addr   WorldCmd_b8
        .addr   WorldCmd_b8
        .addr   WorldCmd_c0
        .addr   WorldCmd_c1
        .addr   WorldCmd_c2
        .addr   WorldCmd_c3
        .addr   WorldCmd_c4
        .addr   WorldCmd_c5
        .addr   WorldCmd_c5
        .addr   WorldCmd_c5
        .addr   WorldCmd_c8
        .addr   WorldCmd_c9
        .addr   WorldCmd_cc
        .addr   WorldCmd_cc
        .addr   WorldCmd_cc
        .addr   WorldCmd_cd
        .addr   WorldCmd_ce
        .addr   WorldCmd_cf
        .addr   WorldCmd_d0
        .addr   WorldCmd_d1
        .addr   WorldCmd_d2
        .addr   WorldCmd_d3
        .addr   WorldCmd_d4
        .addr   WorldCmd_d5
        .addr   WorldCmd_d8
        .addr   WorldCmd_d8
        .addr   WorldCmd_d8
        .addr   WorldCmd_d9
        .addr   WorldCmd_dd
        .addr   WorldCmd_dd
        .addr   WorldCmd_dd
        .addr   WorldCmd_dd
        .addr   WorldCmd_de
        .addr   WorldCmd_de
        .addr   WorldCmd_e0
.repeat 28
        .addr   WorldCmd_e1
.endrep
        .addr   WorldCmd_fd
        .addr   WorldCmd_fe
        .addr   WorldCmd_ff

; ------------------------------------------------------------------------------

; airship songs (blackjack, searching for friends)
AirshipSongTbl:
@8389:  .byte   $35,$35,$4c,$4c

; ------------------------------------------------------------------------------

; chocobo songs (techno de chocobo)
ChocoSongTbl:
@838d:  .byte   $13,$13,$13,$13

; ------------------------------------------------------------------------------

; world map songs (terra, veldt, dark world, searching for friends)
WorldSongTbl:
@8391:  .byte   $06,$19,$4f,$4c

; ------------------------------------------------------------------------------

; train ride songs (save them!)
TrainSongTbl:
@8395:  .byte   $1a,$1a

; ------------------------------------------------------------------------------

; serpent trench songs (the serpent trench)
SnakeSongTbl:
@8397:  .byte   $28,$28

; ------------------------------------------------------------------------------

; [ init world map ]

LoadWorld:
@8399:  shorta
        lda     #$00
        pha
        plb
        lda     $11f6       ; disable battle
        and     #$fd
        sta     $11f6
        longa
        stz     $04         ; clear pressed buttons
        stz     $06
        stz     $08
        stz     $0a
        stz     $0c
        stz     $0e
        lda     $1f64       ; map index
        and     #$01ff
        cmp     #$0002
        bne     @83c3       ; branch if not serpent trench
        jmp     InitSnakeRoad
@83c3:  shorta
        lda     $1f68       ; facing direction
        bpl     @83ce
        and     #$7f
        bra     @83d7
@83ce:  lda     $1f65
        lsr4
        and     #$03
@83d7:  sta     $1f68
        lda     $11f3
        bpl     @83e2
        jmp     InitAirship
@83e2:  lda     $11fa       ; vehicle
        and     #$03
        beq     @83f0
        cmp     #$02
        beq     @83f3
        jmp     InitAirship
@83f0:  jmp     InitWorld
@83f3:  jmp     InitChoco

; ------------------------------------------------------------------------------

; [ reload map ]

ReloadMap:
@83f6:  shorta
        lda     #$00
        pha
        plb
        longa
        lda     $1f64
        and     #$01ff
        cmp     #$0002
        bne     @840c       ; branch if not serpent trench
        jmp     InitSnakeRoad
@840c:  shorta
        lda     $11fa       ; vehicle
        and     #$03
        beq     @841c
        cmp     #$02
        beq     @841f
        jmp     InitAirship
@841c:  jmp     InitWorld
@841f:  jmp     InitChoco

; ------------------------------------------------------------------------------

; [ init world map (airship) ]

InitAirship:
@8422:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        lda     $1eb7
        and     #$f7
        sta     $1eb7
        lda     $11f6
        bit     #$02
        beq     @8442       ; branch if battle is not enabled
        jsr     PopDP
        bra     @8469
@8442:  jsr     PushMode7Vars
        longa
        lda     $1f60
        lsr4
        and     #$0ff0
        sta     $38
        lda     $1f60
        asl4
        and     #$0ff0
        sta     $34
        shorta
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
@8469:  lda     #$01
        sta     $ca
        lda     #$01
        sta     $20
        lda     #$01
        sta     $7eb652
        lda     #$10
        sta     $1300
        lda     #$ff
        sta     $1302
        lda     $1eb9
        bit     #$10
        bne     @84b0
        lda     $1eb7
        bit     #$08
        beq     @8493
        lda     #$19
        bra     @84a8
@8493:  tdc
        xba
        lda     $1f64
        and     #$03
        asl
        tax
        lda     $1eb7
        bit     #$01
        beq     @84a4
        inx
@84a4:  lda     f:AirshipSongTbl,x
@84a8:  sta     $1f80
        sta     $1301
        bra     @84b6
@84b0:  lda     $1f80
        sta     $1301
@84b6:  jsl     ExecSound_ext
        shorta
        phb
        lda     #$7e
        pha
        plb
        lda     f:$001f64
        bne     @84cc
        ldx     #$0000
        bra     @84cf
@84cc:  ldx     #$0100
@84cf:  ldy     #$0000
        longa
@84d4:  lda     f:WorldBGPal1,x
        sta     $e000,y
        iny2
        inx2
        cpy     #$0100
        bne     @84d4
        shorta
        lda     f:$001f64
        bne     @84f1
        ldx     #$0200
        bra     @84f4
@84f1:  ldx     #$0300
@84f4:  ldy     #$0000
        longa
@84f9:  lda     f:WorldBGPal1,x
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @84f9
        plb
        shorta
        lda     f:WorldBackdropGfxPtr
        sta     $d2
        lda     f:WorldBackdropGfxPtr+1
        sta     $d3
        lda     f:WorldBackdropGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropGfx
        lda     f:WorldBackdropTilesPtr
        sta     $d2
        lda     f:WorldBackdropTilesPtr+1
        sta     $d3
        lda     f:WorldBackdropTilesPtr+2
        sta     $d4
        ldx     #$2000      ; destination = $7e2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropTiles
        lda     f:WorldSpriteGfx1Ptr
        sta     $d2
        lda     f:WorldSpriteGfx1Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx1Ptr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8586
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        bra     @8598
@8586:  lda     f:AirshipGfx2Ptr
        sta     $d2
        lda     f:AirshipGfx2Ptr+1
        sta     $d3
        lda     f:AirshipGfx2Ptr+2
        sta     $d4
@8598:  ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @85be
        lda     f:MinimapGfx1Ptr
        sta     $d2
        lda     f:MinimapGfx1Ptr+1
        sta     $d3
        lda     f:MinimapGfx1Ptr+2
        sta     $d4
        bra     @85d0
@85be:  lda     f:MinimapGfx2Ptr
        sta     $d2
        lda     f:MinimapGfx2Ptr+1
        sta     $d3
        lda     f:MinimapGfx2Ptr+2
        sta     $d4
@85d0:  ldx     #$4000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     _ee9af1
        lda     f:WorldSpriteGfx2Ptr
        sta     $d2
        lda     f:WorldSpriteGfx2Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx2Ptr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     $11f6
        bit     #$08
        beq     @860e
        and     #$f7
        sta     $11f6
        bra     @864c
@860e:  lda     f:$001f64
        bne     @8628
        lda     f:WorldGfx1Ptr
        sta     $d2
        lda     f:WorldGfx1Ptr+1
        sta     $d3
        lda     f:WorldGfx1Ptr+2
        sta     $d4
        bra     @863a
@8628:  lda     f:WorldGfx2Ptr
        sta     $d2
        lda     f:WorldGfx2Ptr+1
        sta     $d3
        lda     f:WorldGfx2Ptr+2
        sta     $d4
@863a:  ldx     #$6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     _ee3f4f
        jsr     _eeae75
@864c:  lda     $11f6
        bit     #$04
        beq     @865a
        and     #$fb
        sta     $11f6
        bra     @8695
@865a:  lda     f:$001f64
        bne     @8674
        lda     f:WorldTilemap1Ptr
        sta     $d2
        lda     f:WorldTilemap1Ptr+1
        sta     $d3
        lda     f:WorldTilemap1Ptr+2
        sta     $d4
        bra     @8686
@8674:  lda     f:WorldTilemap2Ptr
        sta     $d2
        lda     f:WorldTilemap2Ptr+1
        sta     $d3
        lda     f:WorldTilemap2Ptr+2
        sta     $d4
@8686:  ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     ModifyMap
@8695:  jsr     _ee34d5
        shortai
        lda     $1f6d
        inc3
        sta     $1f6d
        tax
        ldy     #$00
@86a6:  lda     f:RNGTbl,x   ; random number table
        and     #$3f
        sta     $0b00,y
        tdc
        sta     $0b01,y
        inx
        lda     f:RNGTbl,x
        lsr2
        sta     $0b02,y
        tdc
        sta     $0b03,y
        iny4
        cpy     #$10
        bne     @86a6
        jmp     InitInterruptsVehicle

; ------------------------------------------------------------------------------

; [ init world map (chocobo) ]

InitChoco:
@86cc:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     PushMode7Vars
        jsr     InitHWRegs
        lda     #$10
        sta     $1300
        lda     #$ff
        sta     $1302
        lda     $1eb9
        bit     #$10
        bne     @8714
        lda     $1eb7
        bit     #$08
        beq     @86f7
        lda     #$19
        bra     @870c
@86f7:  tdc
        xba
        lda     $1f64
        and     #$03
        asl
        tax
        lda     $1eb7
        bit     #$01
        beq     @8708
        inx
@8708:  lda     f:ChocoSongTbl,x
@870c:  sta     $1f80
        sta     $1301
        bra     @871a
@8714:  lda     $1f80
        sta     $1301
@871a:  jsl     ExecSound_ext
        longa
        lda     $1f64
        and     #$6000
        xba
        lsr4
        shorta
        sta     hWRMPYA
        lda     #$5a
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        ora     #$8000
        sta     $11f2
        stz     $11f4
        lda     f:$001f60
        lsr4
        and     #$0ff0
        clc
        adc     #$0008
        sta     $38
        lda     f:$001f60
        asl4
        and     #$0ff0
        clc
        adc     #$0008
        sta     $34
        shorta
        phb
        lda     #$7e
        pha
        plb
        lda     f:$001f64
        bne     @8779
        ldx     #$0000
        bra     @877c
@8779:  ldx     #$0100
@877c:  ldy     #$0000
        longa
@8781:  lda     f:WorldBGPal1,x
        sta     $e000,y
        iny2
        inx2
        cpy     #$0100
        bne     @8781
        shorta
        lda     f:$001f64
        bne     @879e
        ldx     #$0200
        bra     @87a1
@879e:  ldx     #$0300
@87a1:  ldy     #$0000
        longa
@87a6:  lda     f:WorldBGPal1,x
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @87a6
        plb
        shorta
        lda     f:WorldBackdropGfxPtr
        sta     $d2
        lda     f:WorldBackdropGfxPtr+1
        sta     $d3
        lda     f:WorldBackdropGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropGfx
        lda     f:WorldBackdropTilesPtr
        sta     $d2
        lda     f:WorldBackdropTilesPtr+1
        sta     $d3
        lda     f:WorldBackdropTilesPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropTiles
        lda     f:WorldSpriteGfx1Ptr
        sta     $d2
        lda     f:WorldSpriteGfx1Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx1Ptr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldChocoGfx1Ptr
        sta     $d2
        lda     f:WorldChocoGfx1Ptr+1
        sta     $d3
        lda     f:WorldChocoGfx1Ptr+2
        sta     $d4
        ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8851
        lda     f:MinimapGfx1Ptr
        sta     $d2
        lda     f:MinimapGfx1Ptr+1
        sta     $d3
        lda     f:MinimapGfx1Ptr+2
        sta     $d4
        bra     @8863
@8851:  lda     f:MinimapGfx2Ptr
        sta     $d2
        lda     f:MinimapGfx2Ptr+1
        sta     $d3
        lda     f:MinimapGfx2Ptr+2
        sta     $d4
@8863:  ldx     #$4000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     _ee9af1
        lda     f:WorldChocoGfx2Ptr
        sta     $d2
        lda     f:WorldChocoGfx2Ptr+1
        sta     $d3
        lda     f:WorldChocoGfx2Ptr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     $11f6
        bit     #$08
        beq     @88a1
        and     #$f7
        sta     $11f6
        bra     @88df
@88a1:  lda     f:$001f64
        bne     @88bb
        lda     f:WorldGfx1Ptr
        sta     $d2
        lda     f:WorldGfx1Ptr+1
        sta     $d3
        lda     f:WorldGfx1Ptr+2
        sta     $d4
        bra     @88cd
@88bb:  lda     f:WorldGfx2Ptr
        sta     $d2
        lda     f:WorldGfx2Ptr+1
        sta     $d3
        lda     f:WorldGfx2Ptr+2
        sta     $d4
@88cd:  ldx     #$6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     _ee3f4f
        jsr     _eeae75
@88df:  lda     $11f6
        bit     #$04
        beq     @88ed
        and     #$fb
        sta     $11f6
        bra     @8928
@88ed:  lda     f:$001f64
        bne     @8907
        lda     f:WorldTilemap1Ptr
        sta     $d2
        lda     f:WorldTilemap1Ptr+1
        sta     $d3
        lda     f:WorldTilemap1Ptr+2
        sta     $d4
        bra     @8919
@8907:  lda     f:WorldTilemap2Ptr
        sta     $d2
        lda     f:WorldTilemap2Ptr+1
        sta     $d3
        lda     f:WorldTilemap2Ptr+2
        sta     $d4
@8919:  ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     ModifyMap
@8928:  jsr     _ee34d5
        shorta
        lda     #$02
        sta     $ca
        lda     #$02
        sta     $20
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
        stz     $6a
        stz     $6b
        stz     $6c
        lda     $11fb
        sta     hWRMPYA
        lda     #$a0
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        stx     $6a
        lda     #$16
        sta     hWRMPYB
        nop3
        lda     hRDMPYL
        clc
        adc     $6b
        sta     $6b
        lda     hRDMPYH
        adc     $6c
        sta     $6c
        clc
        lda     $6a
        adc     #$80
        sta     $6a
        lda     $6b
        adc     #$01
        sta     $6b
        lda     $6c
        adc     #$d5
        sta     $6c
        lda     #$80
        sta     hVMAINC
        longa
        lda     #$6ac0
        sta     hVMADDL
        ldy     #$0000
@8990:  lda     [$6a],y
        sta     hVMDATAL
        iny2
        cpy     #$0040
        bne     @8990
        lda     #$6bc0
        sta     hVMADDL
        ldy     #$00c0
@89a5:  lda     [$6a],y
        sta     hVMDATAL
        iny2
        cpy     #$0100
        bne     @89a5

; load character sprite palette
        shorta
        phb
        lda     #$e6
        pha
        plb
        lda     #$00
        xba
        lda     f:$0011fc
        and     #$07
        asl5
        tay
        ldx     #$0000
        longa
@89cc:  lda     $8000,y
        sta     $7ee140,x
        iny2
        inx2
        cpx     #$0020
        bne     @89cc
        plb
        jmp     InitInterruptsVehicle

; ------------------------------------------------------------------------------

; [ init world map (no vehicle) ]

InitWorld:
@89e0:  shorta
        longi
        lda     #$80        ; screen off
        sta     hINIDISP
        jsr     PushMode7Vars
        jsr     InitHWRegs
        lda     #$10        ; song command (play song)
        sta     $1300
        lda     #$ff        ; full volume
        sta     $1302
        lda     $1eb9       ; don't change song when loading map
        bit     #$10
        bne     @8a28
        lda     $1eb7       ; branch if not on the veldt
        bit     #$08
        beq     @8a0b
        lda     #$19        ; veldt music
        bra     @8a20
@8a0b:  tdc
        xba
        lda     $1f64       ; map index
        and     #$03
        asl
        tax
        lda     $1eb7       ; alternative music flag
        bit     #$01
        beq     @8a1c
        inx
@8a1c:  lda     f:WorldSongTbl,x   ; song number
@8a20:  sta     $1f80
        sta     $1301
        bra     @8a2e
@8a28:  lda     $1f80
        sta     $1301
@8a2e:  jsl     ExecSound_ext
        longa
        stz     $08         ;
        lda     f:$001f60     ; map position
        shorta
        sta     $e0
        xba
        sta     $e2
        longa
        lda     $df
        lsr4
        sta     $34
        lda     $e1
        lsr4
        sta     $38
        shorta
        phb
        lda     #$7e
        pha
        plb
        lda     f:$001f64
        bne     @8a65
        ldx     #$0000
        bra     @8a6a
@8a65:  ldx     #$0100
        sta     $d2
@8a6a:  ldy     #$0000
        longa
@8a6f:  lda     f:WorldBGPal1,x   ; map palettes
        sta     $e000,y
        iny2
        inx2
        cpy     #$0100
        bne     @8a6f
        shorta
        lda     f:$001f64
        bne     @8a8c
        ldx     #$0200
        bra     @8a8f
@8a8c:  ldx     #$0300
@8a8f:  ldy     #$0000
        longa
@8a94:  lda     f:WorldBGPal1,x   ; vehicle palettes
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @8a94
        plb
        shorta
        lda     f:WorldSpriteGfx1Ptr
        sta     $d2
        lda     f:WorldSpriteGfx1Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx1Ptr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8adf
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        bra     @8af1
@8adf:  lda     f:AirshipGfx2Ptr
        sta     $d2
        lda     f:AirshipGfx2Ptr+1
        sta     $d3
        lda     f:AirshipGfx2Ptr+2
        sta     $d4
@8af1:  ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8b17
        lda     f:MinimapGfx1Ptr
        sta     $d2
        lda     f:MinimapGfx1Ptr+1
        sta     $d3
        lda     f:MinimapGfx1Ptr+2
        sta     $d4
        bra     @8b29
@8b17:  lda     f:MinimapGfx2Ptr
        sta     $d2
        lda     f:MinimapGfx2Ptr+1
        sta     $d3
        lda     f:MinimapGfx2Ptr+2
        sta     $d4
@8b29:  ldx     #$4000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     _ee9af1
        lda     f:WorldSpriteGfx2Ptr
        sta     $d2
        lda     f:WorldSpriteGfx2Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx2Ptr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     $11f6
        bit     #$08
        beq     @8b67       ; branch if map graphics are not loaded yet
        and     #$f7
        sta     $11f6
        bra     @8ba5
@8b67:  lda     f:$001f64
        bne     @8b81       ; branch if world of ruin
        lda     f:WorldGfx1Ptr
        sta     $d2
        lda     f:WorldGfx1Ptr+1
        sta     $d3
        lda     f:WorldGfx1Ptr+2
        sta     $d4
        bra     @8b93
@8b81:  lda     f:WorldGfx2Ptr
        sta     $d2
        lda     f:WorldGfx2Ptr+1
        sta     $d3
        lda     f:WorldGfx2Ptr+2
        sta     $d4
@8b93:  ldx     #$6f50      ; destination = $7e6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     _ee3f4f
        jsr     _eeae75
@8ba5:  lda     $11f6
        bit     #$04
        beq     @8bb3
        and     #$fb
        sta     $11f6
        bra     @8bee
@8bb3:  lda     f:$001f64
        bne     @8bcd
        lda     f:WorldTilemap1Ptr
        sta     $d2
        lda     f:WorldTilemap1Ptr+1
        sta     $d3
        lda     f:WorldTilemap1Ptr+2
        sta     $d4
        bra     @8bdf
@8bcd:  lda     f:WorldTilemap2Ptr
        sta     $d2
        lda     f:WorldTilemap2Ptr+1
        sta     $d3
        lda     f:WorldTilemap2Ptr+2
        sta     $d4
@8bdf:  ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     ModifyMap
@8bee:  jsr     _ee34d5
        ldx     #$0000
@8bf4:  lda     $7ee100,x
        sta     $7ee120,x
        lda     $7ee101,x
        sta     $7ee121,x
        lda     $7ee102,x
        sta     $7ee122,x
        lda     $7ee103,x
        sta     $7ee123,x
        inx4
        cpx     #$0020
        bne     @8bf4
        lda     f:$001f64
        sta     $f4
        shorta
        tdc
        xba
        lda     $1f68
        sta     $f6
        asl2
        tax
        lda     f:ObjMoveTileTbl,x
        sta     $f7
        lda     #$03
        sta     $ca
        lda     #$03
        sta     $20
        lda     #$80
        sta     $7b
        lda     #$70
        sta     $7d
        jmp     InitInterruptsWorld

; ------------------------------------------------------------------------------

; [ init magitek train ride ]

MagitekTrain:
@8c48:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        stz     $73
        stz     $74
        lda     $11f6
        bit     #$02
        beq     @8c6b       ; branch if battle is not enabled
        jsr     PopDP
        lda     $34
        sec
        sbc     #$05
        sta     $34
        bra     @8c6e
@8c6b:  jsr     PushMode7Vars
@8c6e:  lda     #$10        ; spc command $10 (play song)
        sta     $1300
        lda     f:TrainSongTbl
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
        shorta
        lda     f:MagitekTrainPalPtr
        sta     $6a
        lda     f:MagitekTrainPalPtr+1
        sta     $6b
        lda     f:MagitekTrainPalPtr+2
        sta     $6c
        jsr     TfrPal
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     f:MagitekTrainGfxPtr
        sta     $d2
        lda     f:MagitekTrainGfxPtr+1
        sta     $d3
        lda     f:MagitekTrainGfxPtr+2
        sta     $d4
        ldx     #$a000      ; destination = $7ea000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     InitTrainGfx
        ldx     #.loword(MagitekTrainTiles)
        stx     $6a
        lda     #^MagitekTrainTiles
        sta     $6c
        jsr     _eeae29       ; copy pointers to magitek train ride tiles to vram
        jsr     _eeadf8       ; init magitek train tile map in vram
        ldx     #$1808
        stx     $4300
        ldx     #$0058      ; source = $000058
        stx     $4302
        lda     #$00
        sta     $4304
        ldx     #$4000      ; size = $4000
        stx     $4305
        stz     $58
        stz     hVMAINC
        stz     hVMADDL
        stz     hVMADDH
        lda     #$01
        sta     hMDMAEN
        longai
        lda     $36
        and     #$0020
        pha
        sta     $58
        lda     $34
        sta     $64
        jsr     _ee25f5       ; update magitek train ride script data
        lda     $34
        clc
        adc     #$0005
        sta     $34
        pla
        sta     $58
        lda     #$0020
        sec
        sbc     $58
        sta     $58
        lda     $34
        sta     $64
        jsr     _ee25f5       ; update magitek train ride script data
        lda     $34
        clc
        adc     #$0005
        sta     $34
        jmp     InitInterruptsTrain

; ------------------------------------------------------------------------------

; [ init world map (serpent trench) ]

InitSnakeRoad:
@8d48:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        lda     $11f6
        bit     #$02
        beq     @8d66       ; branch if battle is not enabled
        jsr     PopDP
        stz     $23
        lda     #$0f
        sta     $22
        bra     @8d8d
@8d66:  jsr     PushMode7Vars
        longa
        lda     $1f60
        lsr4
        and     #$0ff0
        sta     $38
        lda     $1f60
        asl4
        and     #$0ff0
        sta     $34
        shorta
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
@8d8d:  lda     #$04
        sta     $ca
        lda     #$04
        sta     $20
        lda     $1eb9
        bit     #$10
        bne     @8dbf
        ldx     #$0000
        lda     #$10
        sta     $1300
        lda     $1eb7       ; alternative world map song
        bit     #$01
        beq     @8dac
        inx
@8dac:  lda     f:SnakeSongTbl,x
        sta     $1f80
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
@8dbf:  lda     #$a3
        sta     hCGADSUB                ; half add, sprites, bg1, bg2
        shorta
        tdc
        sta     $7e2000
        sta     $7e2001
        lda     #$80
        sta     hVMAINC
        ldx     #$5000
        stx     hVMADDL
        ldx     #$1809
        stx     $4300
        ldx     #$2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$4000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$4400
        stx     hVMADDL
        ldx     #$1809
        stx     $4300
        ldx     #$2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$1000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #.loword(SnakeRoadPal)
        stx     $d2
        lda     #^SnakeRoadPal
        sta     $d4
        ldx     #$e000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldSpriteGfx1Ptr
        sta     $d2
        lda     f:WorldSpriteGfx1Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx1Ptr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldSpriteGfx2Ptr
        sta     $d2
        lda     f:WorldSpriteGfx2Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx2Ptr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     f:WorldGfx3Ptr
        sta     $d2
        lda     f:WorldGfx3Ptr+1
        sta     $d3
        lda     f:WorldGfx3Ptr+2
        sta     $d4
        ldx     #$6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     _ee3f4f
        lda     f:WorldTilemap3Ptr
        sta     $d2
        lda     f:WorldTilemap3Ptr+1
        sta     $d3
        lda     f:WorldTilemap3Ptr+2
        sta     $d4
        ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     _ee36fa
        jmp     InitInterruptsVehicle

; ------------------------------------------------------------------------------

; [ init ending airship scene ]

EndingAirshipScene2:
@8ed4:  shorta
        longi
        jsl     EndingAirshipScene_ext
        tdc
        pha
        plb
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        jsr     PushMode7Vars
        shorta
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
        lda     #$7e
        pha
        plb
        longa
        ldx     #$0300
        ldy     #$0000
@8f00:  lda     f:WorldBGPal1,x
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @8f00
        ldx     #$0000
@8f13:  lda     $e1c0,x
        sta     $e140,x
        inx2
        cpx     #$0020
        bne     @8f13
        shorta
        lda     f:EndingAirshipScenePalPtr
        sta     $d2
        lda     f:EndingAirshipScenePalPtr+1
        sta     $d3
        lda     f:EndingAirshipScenePalPtr+2
        sta     $d4
        longa
        ldy     #$0000
@8f39:  lda     [$d2],y
        sta     $e000,y
        iny2
        cpy     #$0100
        bne     @8f39
        stz     $e000
        ldx     #$0000
@8f4b:  lda     $e100,x
        sta     $e120,x
        inx2
        cpx     #$0020
        bne     @8f4b
        shorta
        tdc
        pha
        plb
        lda     f:AirshipGfx2Ptr
        sta     $d2
        lda     f:AirshipGfx2Ptr+1
        sta     $d3
        lda     f:AirshipGfx2Ptr+2
        sta     $d4
        ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldSpriteGfx2Ptr
        sta     $d2
        lda     f:WorldSpriteGfx2Ptr+1
        sta     $d3
        lda     f:WorldSpriteGfx2Ptr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     #$5c
        sta     $1500
        ldx     #.loword(EndingAirshipSceneNMI)
        stx     $1501
        lda     #^EndingAirshipSceneNMI
        sta     $1503
        jmp     FalconEndingMain

; ------------------------------------------------------------------------------

; [ init hardware registers ]

InitHWRegs:
@8faf:  tdc
        pha
        plb
        sta     hHDMAEN       ; disable hdma
        lda     #$03
        sta     hOBJSEL     ; sprite graphics at $6000 (vram)
        stz     hOAMADDL    ; clear sprite data address
        stz     hOAMADDH
        lda     #$07
        sta     hBGMODE     ; screen mode 7
        lda     #$40
        stz     hMOSAIC     ; clear pixelation register
        sta     hBG1SC      ; bg1 tile data at $4000
        lda     #$45
        sta     hBG2SC      ; bg2 tile data at $4400
        lda     #$4c
        sta     hBG3SC      ; bg3 tile data at $4c00
        stz     hBG4SC
        lda     #$55
        sta     hBG12NBA    ; bg1/bg2 graphics at $5000
        stz     hBG34NBA    ; bg3/bg4 graphics at $0000
        stz     hBG3HOFS    ; clear bg3 horizontal/vertical scroll
        stz     hBG3HOFS
        stz     hBG3VOFS
        stz     hBG3VOFS
        lda     #$80
        sta     hVMAINC     ; video port control
        stz     hM7SEL      ; clear mode 7 settings
        lda     #$33
        sta     hW12SEL     ; enable bg1/bg2 in window 1
        stz     hW34SEL     ; disable bg3/bg4
        lda     #$33
        sta     hWOBJSEL    ; enable color/sprites in window 1
        lda     #$08
        sta     hWH0        ; window 1 left position = $08
        lda     #$f7
        sta     hWH1        ; window 1 right position = $f7
        stz     hWH2
        stz     hWH3
        stz     hWBGLOG
        stz     hWOBJLOG
        lda     #$13
        sta     hTM         ; enable sprites, bg1, and bg2 in main screen
        lda     #$10
        sta     hTS         ; enable sprites in subscreen (for transparency in forests)
        lda     #$13
        sta     hTMW        ; enable sprites, bg1, and bg2 masks in main screen
        lda     #$10
        sta     hTSW        ; enable sprites mask in subscreen
        lda     #$02
        sta     hCGSWSEL    ; enable subscreen add/sub
        lda     #$23
        sta     hCGADSUB    ; add/sub affect back-area, bg1, and bg2
        lda     #$e0
        sta     hCOLDATA    ; clear fixed color data
        stz     hSETINI     ; clear screen mode/video select
        stz     hNMITIMEN   ; disable all counters
        lda     #$ff
        sta     hWRIO       ; i/o port
        stz     hWRMPYA
        stz     hWRMPYB
        stz     hWRDIVL
        stz     hWRDIVH
        stz     hWRDIVB
        stz     hHTIMEL     ; clear horizontal irq counter
        stz     hHTIMEH
        stz     hVTIMEL     ; clear vertical irq counter
        stz     hVTIMEH
        stz     hMDMAEN     ; disable dma
        stz     hHDMAEN     ; disable hdma
        phb
        lda     #$7e
        pha
        plb
        longa
        ldx     #0
@9072:  stz     $b5d0,x     ;
        inx2
        cpx     #$0180
        bne     @9072
        plb
        shorta
        ldx     #$0019
@9082:  stz     a:$0000,x     ; clear $0019-$00ff
        inx
        cpx     #$0100
        bne     @9082
        rts

; ------------------------------------------------------------------------------

; [ save mode 7 variables ]

PushMode7Vars:
@908c:  phb
        php
        longai
        ldx     #$0520      ; source = $000520
        ldy     #$f120      ; destination = $7ef120
        lda     #$06df      ; size = $06e0
        mvn     #$00,#$7e
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ restore mode 7 variables ]

PopMode7Vars:
@909f:  phb
        php
        longai
        ldx     #$f120      ; source = $7ef120
        ldy     #$0520      ; destination = $000520
        lda     #$06df      ; size = $06e0
        mvn     #$7e,#$00
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ save direct page ]

PushDP:
@90b2:  php
        phb
        shortai
        lda     #$00
        pha
        plb
        longac
        lda     #$0000
@90bf:  tax
        lda     a:$0000,x
        sta     $0a00,x
        lda     a:$0002,x
        sta     $0a02,x
        lda     a:$0004,x
        sta     $0a04,x
        lda     a:$0006,x
        sta     $0a06,x
        lda     a:$0008,x
        sta     $0a08,x
        lda     a:$000a,x
        sta     $0a0a,x
        lda     a:$000c,x
        sta     $0a0c,x
        lda     a:$000e,x
        sta     $0a0e,x
        txa
        adc     #$0010
        cmp     #$0100
        bne     @90bf
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ restore direct page ]

PopDP:
@90fc:  php
        phb
        shortai
        lda     #$00
        pha
        plb
        longac
        lda     #$0000
@9109:  tax
        lda     $0a00,x
        sta     a:$0000,x
        lda     $0a02,x
        sta     a:$0002,x
        lda     $0a04,x
        sta     a:$0004,x
        lda     $0a06,x
        sta     a:$0006,x
        lda     $0a08,x
        sta     a:$0008,x
        lda     $0a0a,x
        sta     a:$000a,x
        lda     $0a0c,x
        sta     a:$000c,x
        lda     $0a0e,x
        sta     a:$000e,x
        txa
        adc     #$0010
        cmp     #$0100
        bne     @9109
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ set interrupt jump code (w/ vehicle) ]

InitInterruptsVehicle:
@9146:  shorta
        longi
        lda     #$5c
        sta     $1500
        ldx     #.loword(VehicleNMI)
        stx     $1501
        lda     #^VehicleNMI
        sta     $1503
        lda     #$5c
        sta     $1504
        lda     a:$0020
        cmp     #$02
        beq     @9173
        ldx     #.loword(AirshipIRQ)
        stx     $1505
        lda     #^AirshipIRQ
        sta     $1507
        bra     @917e
@9173:  ldx     #.loword(ChocoIRQ)
        stx     $1505
        lda     #^ChocoIRQ
        sta     $1507
@917e:  jmp     VehicleMain

; ------------------------------------------------------------------------------

; [ set interrupt jump code (no vehicle) ]

InitInterruptsWorld:
@9181:  shorta
        longi
        lda     #$5c
        sta     $1500
        ldx     #.loword(WorldNMI)
        stx     $1501
        lda     #^WorldNMI
        sta     $1503
        lda     #$5c
        sta     $1504
        ldx     #.loword(WorldIRQ)
        stx     $1505
        lda     #^WorldIRQ
        sta     $1507
        jmp     WorldMain

; ------------------------------------------------------------------------------

; [ set interrupt jump code (magitek train ride) ]

InitInterruptsTrain:
@91a8:  shorta
        longi
        tdc
        pha
        plb
        lda     #$5c
        sta     $1500
        ldx     #.loword(TrainNMI)
        stx     $1501
        lda     #^TrainNMI
        sta     $1503
        lda     #$5c
        sta     $1504
        ldx     #.loword(TrainIRQ)
        stx     $1505
        lda     #^TrainIRQ
        sta     $1507
        jmp     TrainMain

; ------------------------------------------------------------------------------

; [ terminate world map (w/ vehicle) ]

ExitVehicle:
@91d2:  shorta
        lda     $11f6
        bit     #$10
        beq     @91e6
        lda     $20
        cmp     #$02
        beq     @91e3
        bra     @91e6
@91e3:  jsr     _ee97fe
@91e6:  lda     #$80
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        sta     hHDMAEN
        sei
        lda     $19
        cmp     #$ff
        beq     @920c
        jsr     PopMode7Vars
        stz     $11fa
        stz     $11fd
        stz     $11fe
        stz     $11ff
        jmp     ReloadMap
@920c:  longai
        lda     $f4
        and     #$01ff
        cmp     #$0003
        bcs     @9233
        shorta
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $e7
        bit     #$40
        beq     @922e
        lda     $ec
        sec
        sbc     #$80
        pha
        bra     @924d
@922e:  lda     $ec
        pha
        bra     @924d
@9233:  shorta
        lda     $e7
        bit     #$40
        bne     @9246
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $ec
        pha
        bra     @924d
@9246:  lda     #$00
        pha
        pha
        lda     #$ca
        pha
@924d:  lda     $f1
        pha
        longa
        lda     $1c
        pha
        lda     $f4
        pha
        jsr     PopMode7Vars
        pla
        sta     $1f64
        and     #$01ff
        cmp     #$0002
        bcs     @926d
        pla
        sta     $1f60
        bra     @9271
@926d:  pla
        sta     $1f66
@9271:  shorta
        pla
        sta     $11fa
        pla
        sta     $11ff
        pla
        sta     $11fe
        pla
        sta     $11fd
        rtl

; ------------------------------------------------------------------------------

; [ terminate world map (no vehicle) ]

ExitWorld:
@9284:  shorta
        lda     #$7e
        pha
        plb
        lda     #$80
        sta     f:hINIDISP
        lda     #$00
        sta     f:hNMITIMEN
        sta     f:hHDMAEN
        sei
        longai
        lda     $f4
        and     #$01ff
        cmp     #$0003
        bcs     @92c2
        shorta
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $e7
        bit     #$40
        beq     @92bd
        lda     $ec
        sec
        sbc     #$80
        pha
        bra     @92dc
@92bd:  lda     $ec
        pha
        bra     @92dc
@92c2:  shorta
        lda     $e7
        bit     #$40
        bne     @92d5
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $ec
        pha
        bra     @92dc
@92d5:  lda     #$00
        pha
        pha
        lda     #$ca
        pha
@92dc:  lda     $f1
        pha
        longa
        lda     $1c
        pha
        lda     $f4
        pha
        jsr     PopMode7Vars
        pla
        sta     f:$001f64
        and     #$01ff
        cmp     #$0002
        bcs     @92fe
        pla
        sta     f:$001f60
        bra     @9303
@92fe:  pla
        sta     f:$001f66
@9303:  shorta
        pla
        sta     f:$0011fa
        pla
        sta     f:$0011ff
        pla
        sta     f:$0011fe
        pla
        sta     f:$0011fd
        rtl

; ------------------------------------------------------------------------------

; [ terminate world map (end of magitek train ride) ]

ExitTrain:
@931a:  shorta
        lda     #$00
        pha
        plb
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$7e
        pha
        plb
        sei
        jsr     PopMode7Vars
        rtl

; ------------------------------------------------------------------------------

; [ terminate world map (game over) ]

GameOver:
@9335:  shorta
        tdc
        pha
        plb
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     PopMode7Vars
        lda     #$03        ; load map 3
        sta     f:$001f64
        tdc
        sta     f:$001f65
        lda     #$ca        ; ca/002e (game over)
        sta     f:$0011ff
        tdc
        sta     f:$0011fe
        lda     #$2e
        sta     f:$0011fd
        lda     $11f6       ; disable battle
        and     #$fd
        sta     $11f6
        rtl

; ------------------------------------------------------------------------------

; [ land airship ]

LandAirship:
@936e:  php
        phb
        shorta
        lda     $20
        cmp     #$02
        beq     @93d4       ;
        lda     $c2
        bit     #$02
        beq     @9381       ; branch if airship can't land
        jmp     @942c       ; return
@9381:  lda     $1f64
        cmp     #$01
        bne     @93d4       ; branch if not in wor
        lda     $c3
        bit     #$80
        beq     @93af       ; branch if not kefka's tower
        lda     f:VehicleEvent_04     ; ca/007f (enter kefka's tower)
        sta     $ea
        lda     f:VehicleEvent_04+1
        sta     $eb
        lda     f:VehicleEvent_04+2
        clc
        adc     #$ca
        sta     $ec
        stz     $ed
        stz     $ee
        lda     $e7
        ora     #$41
        sta     $e7
        bra     @942c
@93af:  bit     #$40
        beq     @93d4       ; branch if not phoenix cave
        lda     f:VehicleEvent_03     ; ca/0088 (enter phoenix cave)
        sta     $ea
        lda     f:VehicleEvent_03+1
        sta     $eb
        lda     f:VehicleEvent_03+2
        clc
        adc     #$ca
        sta     $ec
        stz     $ed
        stz     $ee
        lda     $e7
        ora     #$41
        sta     $e7
        bra     @942c
@93d4:  lda     $c3
        bit     #$20
        beq     @93e2       ; branch if not a veldt tile
        lda     $1eb7
        ora     #$08
        sta     $1eb7
@93e2:  lda     #$03
        sta     $19
        lda     $1e
        ora     #$01
        sta     $1e
        ldx     #$0000
        stx     $29
        stx     $2b
        stx     $26
        stz     $28
        stx     $2d
        longa
        lda     $34
        lsr4
        and     #$00ff
        sta     f:$001f60
        lda     $38
        asl4
        and     #$ff00
        clc
        adc     f:$001f60
        sta     f:$001f60
        lda     $20
        and     #$00ff
        cmp     #$0001
        bne     @942c
        lda     f:$001f60
        sta     f:$001f62
@942c:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ apply map layout modifications ]

ModifyMap:
@942f:  phb
        php
        shortai
        lda     f:$001f64               ; map index
        asl
        clc
        adc     f:$001f64
        tax
        lda     f:WorldModDataPtrs,x    ; pointer to modification data
        sta     $6a
        lda     f:WorldModDataPtrs+1,x
        sta     $6b
        lda     f:WorldModDataPtrs+2,x
        sta     $6c
        pha
        plb
        longai
        lda     f:WorldModDataPtrs+3,x  ; pointer to next map's modification data
        sec
        sbc     f:WorldModDataPtrs,x
        sta     $66                     ; length of modification data
        ldy     #0
@9462:  longa
        lda     [$6a],y                 ; event bit index
        iny2
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x            ; bit mask
        sta     $5c
        lda     $5a
        and     #$7fff
        lsr3
        tax
        shorta
        lda     f:$001e80,x             ; event bit
        and     $5c
        beq     @94cb                   ; skip this chunk if not set
        phy
        longac
        lda     [$6a],y                 ; pointer to modified tiles
        adc     f:WorldModDataPtrs
        tay
        lda     a:$0000,y               ; tile offset (x then y)
        tax
        shorta
        lda     a:$0002,y               ; width (high nybble)
        lsr4
        sta     $68
        lda     a:$0002,y               ; height (low nybble)
        and     #$0f
        sta     $69
        shorta
@94a9:  lda     $68
        sta     $5e                     ; x
        stx     $60
@94af:  lda     a:$0003,y
        sta     $7f0000,x
        iny                             ; next column
        inx
        dec     $5e
        bne     @94af
        longac                          ; next row
        lda     $60
        adc     #$0100
        tax
        shorta
        dec     $69
        bne     @94a9
        ply
@94cb:  iny2                            ; next chunk
        cpy     $66
        bne     @9462
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee94d4:
@94d4:  php
        phb
        longai
        lda     #$0006
        sta     f:$0000ca
        lda     #$0078
        sta     $7eb660
        lda     #$0100
        sta     $7eb662
        lda     #$0001
        sta     $7eb664
        lda     #$000a
        sta     $7eb668
        tdc
        sta     $7eb666
        sta     $7eb5d8
@9504:  jsr     _ee43bd
        jsr     _ee4302
        jsr     _eeaaad
        longa
        lda     $7eb662
        cmp     #$03c0
        bne     @951d
        shorta
        tdc
        sta     $22
@951d:  shorta
@951f:  lda     $24
        beq     @951f
        stz     $24
        lda     $23
        cmp     $22
        beq     @9531
        bcs     @9530
        inc
        bra     @9531
@9530:  dec
@9531:  sta     $23
        cmp     #$00
        bne     @9539
        lda     #$80
@9539:  sta     hINIDISP
        lda     $23
        bne     @9504
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

w_h_effect:
_ee9543:
@9543:  php
        phb
        longai
        lda     #$9000
        sta     $8b
        lda     #$8fff
        sta     $8d
        lda     #$ffff
        sta     $8f
        lda     #$00f2
        sta     $62
        lda     #$0070
        sta     $7d
        lda     #$00e0
        sta     $85
        sta     $87
        lda     #$0007
        sta     f:$0000ca
        lda     #$0640
        sta     $7eb662
        lda     #$0001
        sta     $7eb664
        shorta
@957e:  lda     $24
        beq     @957e
        stz     $24
        ldx     #0
@9587:  phx
        shorta
        lda     $62
        cmp     #$e0
        bcs     @959c
        lda     #$e0
        sec
        sbc     $87
        sta     hVTIMEL
        lda     #$02
        bra     @95a3
@959c:  lda     #$01
        sta     hVTIMEL
        lda     #$07
@95a3:  sta     hBGMODE
        lda     #$23
        sta     hCGADSUB
        jsr     _ee39ff
        jsr     _ee37b6
        longa
        lda     $85
        sta     $87
        jsr     _ee3888
        jsr     UpdateMode7Rot
        jsr     _ee43bd
        jsr     _ee427c
        jsr     _eeaaad
        plx
        lda     f:_ee98f1,x
        sta     $58
        lda     $8b
        sec
        sbc     $58
        sta     $8b
        lda     f:_ee98f1+2,x
        sta     $58
        lda     $8d
        sec
        sbc     $58
        sta     $8d
        lda     f:_ee98f1+4,x
        and     #$00ff
        sta     $58
        lda     $8f
        sec
        sbc     $58
        sta     $8f
        lda     f:_ee98f1+5,x
        and     #$00ff
        sta     $58
        lda     $62
        sec
        sbc     $58
        sta     $62
        cmp     #$00e0
        bcc     @9609
        lda     #$00e0
@9609:  sta     $85
        lda     f:_ee98f1+5,x
        and     #$00ff
        sta     $58
        lda     $7d
        clc
        adc     $58
        sta     $7d
        txa
        clc
        adc     #7
        tax
        shorta
@9623:  lda     $24
        beq     @9623
        stz     $24
        lda     $23
        cmp     $22
        beq     @9635
        bcs     @9634
        inc
        bra     @9635
@9634:  dec
@9635:  sta     $23
        cmp     #$00
        bne     @963d
        lda     #$80
@963d:  sta     hINIDISP
        cpx     #$00e0
        beq     @9648
        jmp     @9587
@9648:  lda     $11f6
        and     #$ef
        sta     $11f6
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee9653:
@9653:  php
        phb
        jsr     HideMinimap
        jsr     HideMinimapPos
        longai
        lda     #$3000
        sta     $8b
        lda     #$1800
        sta     $8d
        lda     #$feff
        sta     $8f
        lda     #$0092
        sta     $62
        lda     #$00d0
        sta     $7d
        lda     #$0092
        sta     $85
        sta     $87
        lda     #$0008
        sta     f:$0000ca
        lda     #$0080
        sta     $7eb660
        lda     #$0100
        sta     $7eb662
        lda     #$00e0
        sta     $7e6b39
        sta     $7e6b3d
@969d:  lda     $24
        beq     @969d
        stz     $24
        ldx     #$00d9
@96a6:  phx
        shorta
        lda     $62
        cmp     #$e0
        bcs     @96bb
        lda     #$e0
        sec
        sbc     $87
        sta     hVTIMEL
        lda     #$02
        bra     @96c2
@96bb:  lda     #$01
        sta     hVTIMEL
        lda     #$07
@96c2:  sta     hBGMODE
        lda     #$23
        sta     hCGADSUB
        jsr     _ee39ff
        jsr     _ee37b6
        longa
        lda     $85
        sta     $87
        jsr     _ee3888
        jsr     UpdateMode7Rot
        jsr     _ee43bd
        jsr     _ee427c
        jsr     _eeaaad
        plx
        bmi     @9742
        lda     f:_ee98f1,x
        sta     $58
        lda     $8b
        clc
        adc     $58
        sta     $8b
        lda     f:_ee98f1+2,x
        sta     $58
        lda     $8d
        clc
        adc     $58
        sta     $8d
        lda     f:_ee98f1+4,x
        and     #$00ff
        sta     $58
        lda     $8f
        clc
        adc     $58
        sta     $8f
        lda     f:_ee98f1+5,x
        and     #$00ff
        sta     $58
        lda     $62
        clc
        adc     $58
        sta     $62
        cmp     #$00e0
        bcc     @972a
        lda     #$00e0
@972a:  sta     $85
        lda     f:_ee98f1+6,x
        and     #$00ff
        sta     $58
        lda     $7d
        sec
        sbc     $58
        sta     $7d
        txa
        sec
        sbc     #$0007
        tax
@9742:  shorta
@9744:  lda     $24
        beq     @9744
        stz     $24
        lda     $23
        cmp     $22
        beq     @9756
        bcs     @9755
        inc
        bra     @9756
@9755:  dec
@9756:  sta     $23
        cmp     #$00
        bne     @975e
        lda     #$80
@975e:  sta     hINIDISP
        nop4
        cpx     #$0069
        bne     @976c
        stz     $22
@976c:  lda     $23
        beq     @9773
        jmp     @96a6
@9773:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee9776:
h_w_effect:
@9776:  php
        phb
        longai
        lda     #$9000
        sta     $8b
        lda     #$8fff
        sta     $8d
        lda     #$ffff
        sta     $8f
        lda     #$00f2
        sta     $62
        lda     #$0070
        sta     $7d
        lda     #$00e0
        sta     $85
        sta     $87
        lda     #$0009
        sta     f:$0000ca
        lda     #$fda0
        sta     $7eb660
        lda     #$02c8
        sta     $7eb662
        lda     #$0001
        sta     $7eb664
        shorta
        lda     #$0f
        sta     $22
@97bc:  lda     $24
        beq     @97bc
        stz     $24
@97c2:  jsr     UpdateMode7Vars
        jsr     _ee43bd
        jsr     _ee4302
        jsr     _eeaaad
        shorta
@97d0:  lda     $24
        beq     @97d0
        stz     $24
        lda     $23
        cmp     $22
        beq     @97e2
        bcs     @97e1
        inc
        bra     @97e2
@97e1:  dec
@97e2:  sta     $23
        cmp     #$00
        bne     @97ea
        lda     #$80
@97ea:  sta     hINIDISP
        lda     $ca
        cmp     #$03
        bne     @97c2
        lda     $11f6
        and     #$ef
        sta     $11f6
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_ee97fe:
c_w_effect:
@97fe:  php
        phb
        longai
        lda     #$3000
        sta     $8b
        lda     #$1800
        sta     $8d
        lda     #$feff
        sta     $8f
        lda     #$0092
        sta     $62
        lda     #$00d0
        sta     $7d
        lda     #$0092
        sta     $85
        sta     $87
        lda     #$000a
        sta     f:$0000ca
        lda     #$00b8
        sta     $7eb660
        lda     #$8000
        sta     $7eb66e
        lda     #$0000
        sta     $7eb662
        lda     #$0001
        sta     $7eb664
        lda     #$fffd
        sta     $7eb666
        lda     #$00a8
        sta     $7eb668
        lda     #$0078
        sta     $7eb66a
        lda     #$0000
        sta     $7eb66c
        lda     #$00e0
        sta     $7e6b39
        sta     $7e6b3d
@986c:  lda     $24
        beq     @986c
        stz     $24
@9872:  shorta
        lda     $62
        cmp     #$e0
        bcs     @9886
        lda     #$e0
        sec
        sbc     $87
        sta     hVTIMEL
        lda     #$02
        bra     @988d
@9886:  lda     #$01
        sta     hVTIMEL
        lda     #$07
@988d:  sta     hBGMODE
        lda     #$23
        sta     hCGADSUB
        jsr     _ee39ff
        jsr     _ee37b6
        longa
        lda     $85
        sta     $87
        jsr     _ee3888
        jsr     UpdateMode7Rot
        jsr     _ee43bd
        jsr     _ee427c
        jsr     _eeaaad
        shorta
@98b2:  lda     $24
        beq     @98b2
        stz     $24
        lda     $23
        cmp     $22
        beq     @98c4
        bcs     @98c3
        inc
        bra     @98c4
@98c3:  dec
@98c4:  sta     $23
        cmp     #$00
        bne     @98cc
        lda     #$80
@98cc:  sta     hINIDISP
        nop4
        lda     $7eb66c
        cmp     #$3c
        bne     @98dd
        stz     $22
@98dd:  lda     $ca
        cmp     #$0b
        beq     @98e6
        jmp     @9872
@98e6:  lda     $11f6
        and     #$ef
        sta     $11f6
        plb
        plp
        rts

; ------------------------------------------------------------------------------

_ee98f1:
@98f1:  .byte   $0e,$00,$12,$00,$00,$00,$00
        .byte   $3a,$00,$49,$00,$00,$00,$00
        .byte   $81,$00,$a1,$00,$01,$00,$00
        .byte   $e1,$00,$19,$01,$02,$01,$00
        .byte   $55,$01,$aa,$01,$03,$01,$01
        .byte   $da,$01,$50,$02,$05,$02,$01
        .byte   $6a,$02,$04,$03,$06,$02,$02
        .byte   $00,$03,$bf,$03,$08,$03,$02
        .byte   $96,$03,$7b,$04,$0a,$04,$03
        .byte   $26,$04,$2f,$05,$0b,$04,$04
        .byte   $ab,$04,$d5,$05,$0d,$05,$04
        .byte   $1f,$05,$66,$06,$0e,$05,$05
        .byte   $7f,$05,$de,$06,$0f,$06,$05
        .byte   $c6,$05,$36,$07,$10,$06,$05
        .byte   $f1,$05,$6d,$07,$10,$06,$05
        .byte   $00,$06,$80,$07,$10,$06,$05
        .byte   $f1,$05,$6d,$07,$10,$06,$05
        .byte   $c6,$05,$36,$07,$10,$06,$05
        .byte   $7f,$05,$de,$06,$0f,$06,$05
        .byte   $1f,$05,$66,$06,$0e,$05,$05
        .byte   $ab,$04,$d5,$05,$0d,$05,$04
        .byte   $26,$04,$2f,$05,$0b,$04,$04
        .byte   $96,$03,$7b,$04,$0a,$04,$03
        .byte   $00,$03,$c0,$03,$08,$03,$03
        .byte   $6a,$02,$04,$03,$06,$02,$02
        .byte   $da,$01,$50,$02,$05,$02,$01
        .byte   $55,$01,$aa,$01,$03,$01,$01
        .byte   $e1,$00,$19,$01,$02,$01,$00
        .byte   $81,$00,$a1,$00,$01,$00,$00
        .byte   $3a,$00,$49,$00,$00,$00,$00
        .byte   $0e,$00,$12,$00,$00,$00,$00
        .byte   $02,$00,$0f,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; pixels per tile (height * width)
_ee99d1:
dtsize:
@99d1:  .word   0*0,3*3,4*4,5*5,6*6,7*7,8*8,9*9
        .word   10*10,11*11,12*12,14*14,16*16

; ------------------------------------------------------------------------------

; tile height/width for each layer
_ee99eb:
chr_size:
@99eb:  .word   0,3,4,5,6,7,8,9,10,11,12,14,16

; ------------------------------------------------------------------------------

; [ init magitek train ride graphics ]

InitTrainGfx:
decsp:

@hDP := hWMDATA & $ff00

@9a05:  php
        phb
        phd
        longai
        lda     #@hDP                   ; nonzero dp, don't use clr_a
        tcd
        shorta
        ldx     #$2000      ; $7e2000
        stx     $81
        lda     #$7e
        sta     $83
        lda     #$7e
        pha
        plb
        ldy     #$0000
        lda     #$1d        ; 29 tiles
        sta     a:$0066
@9a25:  ldx     #$0018
        stx     a:$0068       ; 24 layers
@9a2b:  longa
        stz     a:$005a
        ldx     a:$0068       ; layer
        lda     f:_ee99d1,x   ; pixels per tile
        bit     #$0001
        beq     @9a3f       ; branch if an even number of pixels per tile
        inc     a:$005a       ; $5a set if odd number of pixels per tile
@9a3f:  lsr
        tax
        shorta
        lda     $a000,y     ; $58 = high nybble of pixel
        sta     a:$0058
        iny
@9a4a:  lda     $a000,y     ; first pixel
        and     #$f0
        beq     @9a5c
        lsr4
        ora     a:$0058
        sta     $80
        bra     @9a5e
@9a5c:  stz     $80
@9a5e:  lda     $a000,y     ; second pixel
        and     #$0f
        beq     @9a6c       ; branch if pixel is transparent
        ora     a:$0058
        sta     $80
        bra     @9a6e
@9a6c:  stz     $80
@9a6e:  iny                 ; next pair of pixels
        dex
        bne     @9a4a
        lda     a:$005a
        beq     @9a8c       ; branch if an even number of pixels per tile
        lda     $a000,y
        and     #$f0
        beq     @9a89       ; branch if pixel is transparent
        lsr4
        ora     a:$0058
        sta     $80
        bra     @9a8b
@9a89:  stz     $80
@9a8b:  iny                 ; next size/layer
@9a8c:  dec     a:$0068
        dec     a:$0068
        bne     @9a2b
        dec     a:$0066       ; next tile
        bne     @9a25
        longa
        lda     #$68d9      ; $7e68d9
        sta     $81
        shorta
        ldy     #$0000
        ldx     #$000c      ;
        stx     a:$0066
@9aab:  ldx     #$0018      ; 24 layers
        stx     a:$0068
@9ab1:  ldx     a:$0068
        lda     f:_ee99eb,x   ; tile height/width
        sta     a:$0058
@9abb:  longac
        ldx     a:$0068
        lda     f:_ee99eb,x   ; tile height/width
        sta     a:$005a
        tya
        adc     f:_ee99eb,x   ; tile height/width
        tax
        tay
        shorta
@9ad0:  lda     $1fff,x
        sta     $80
        dex
        dec     a:$005a       ; next pixel
        bne     @9ad0
        dec     a:$0058       ; next row
        bne     @9abb
        dec     a:$0068       ; next
        dec     a:$0068
        bne     @9ab1
        dec     a:$0066       ; next
        bne     @9aab
        pld
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ hide floating island in mini-map ]

_ee9af1:
del_daisankaku:
@9af1:  php
        shorta
        lda     $1f64
        bne     @9b12       ; return if not world of balance
        lda     $1e93
        bit     #$40
        beq     @9b12       ; return if floating island has not lifted off
        longa
        lda     $7ee1a2     ; hide floating island
        sta     $7ee1ac
        sta     $7ee1ae
        sta     $7ee1b0
@9b12:  plp
        rts

; ------------------------------------------------------------------------------

; world of balance tile properties
WorldTileProp:
@9b14:  .word   $0004,$0004,$0044,$0004,$0004,$0004,$0053,$0053
        .word   $0042,$0053,$0044,$0044,$0044,$0046,$0246,$0046
        .word   $0004,$0046,$001b,$0046,$0004,$0044,$0044,$0053
        .word   $0044,$0053,$0044,$0044,$0044,$0246,$0246,$0246
        .word   $0046,$001b,$001b,$001b,$0046,$0044,$0044,$0053
        .word   $0042,$0053,$0044,$0044,$0044,$0046,$0246,$0046
        .word   $0004,$0057,$001b,$0057,$0004,$0007,$0007,$0007
        .word   $0007,$0046,$0046,$0046,$0046,$0366,$0366,$0366
        .word   $0004,$0007,$0046,$0007,$0004,$0007,$0007,$0007
        .word   $0007,$0046,$0046,$0044,$0044,$0366,$0366,$0366
        .word   $001b,$001b,$0007,$0007,$0004,$0004,$0046,$0046
        .word   $0017,$0017,$0017,$0046,$0046,$0366,$0366,$0366
        .word   $001b,$001b,$0007,$0007,$0004,$0004,$0046,$0046
        .word   $0017,$0017,$0017,$0246,$0246,$0004,$0004,$0004
        .word   $0004,$0004,$0004,$0004,$0016,$0017,$0016,$0004
        .word   $0017,$0044,$0017,$0246,$0246,$0004,$0004,$0004
        .word   $0004,$0004,$0017,$0004,$0016,$0017,$0016,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0006,$0006,$0006
        .word   $0004,$0017,$0017,$0017,$0016,$0017,$0016,$0007
        .word   $0007,$0004,$0004,$0004,$0004,$0004,$0004,$0642
        .word   $0017,$0017,$0017,$0017,$0017,$0004,$0004,$0007
        .word   $0007,$0004,$0646,$0004,$2644,$0004,$0004,$2644
        .word   $0004,$0017,$0017,$0017,$0004,$0004,$0004,$0004
        .word   $2644,$0004,$0004,$0004,$0004,$0004,$0004,$0642
        .word   $0004,$0004,$0017,$0004,$0004,$0004,$0004,$0646
        .word   $0004,$0646,$0646,$0004,$2646,$0004,$2644,$2644
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0646,$0004
        .word   $0004,$0004,$0646,$2644,$2644,$2644,$2644,$2644
        .word   $0046,$0046,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0004,$0004,$0004,$2644,$2644,$2644,$2644,$2644
        .word   $0046,$0046,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0646,$0004,$0004,$2644,$2644,$2644,$2644,$2644

; ------------------------------------------------------------------------------

; world of ruin tile properties
m7spnid2:
@9d14:  .word   $0004,$0004,$0444,$0004,$0004,$0004,$0753,$0553
        .word   $0544,$0553,$0444,$0544,$0444,$0546,$0246,$0546
        .word   $0004,$0446,$001b,$0446,$0004,$0544,$0544,$0544
        .word   $0544,$0544,$0544,$0544,$0544,$0246,$0246,$0246
        .word   $0446,$001b,$001b,$001b,$0446,$0544,$0544,$0553
        .word   $0544,$0553,$0444,$0544,$0444,$0546,$0246,$0546
        .word   $0004,$0417,$001b,$0417,$0007,$0007,$0007,$0007
        .word   $0007,$0546,$0546,$0546,$0546,$0166,$0166,$0166
        .word   $0004,$0007,$0446,$0007,$0004,$0007,$0007,$0007
        .word   $0007,$0546,$0546,$0544,$0544,$0166,$0166,$0166
        .word   $001b,$001b,$000b,$0007,$0004,$0006,$0546,$0007
        .word   $0007,$0017,$0017,$0546,$0546,$0166,$0166,$0166
        .word   $001b,$001b,$0007,$0007,$0444,$8019,$0546,$0007
        .word   $0007,$0017,$0017,$0246,$0246,$0004,$0004,$0004
        .word   $0553,$2544,$0553,$0004,$0016,$8019,$0016,$0004
        .word   $0017,$0544,$0057,$0246,$0246,$0004,$0004,$0004
        .word   $2544,$2544,$2544,$0004,$0016,$8015,$0016,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0006,$0006,$0006
        .word   $0553,$2544,$0553,$0017,$0016,$0017,$0016,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0444,$0544,$0444,$0017,$0017,$0004,$2644,$2544
        .word   $2644,$0004,$0004,$2644,$0004,$0004,$4444,$4444
        .word   $0544,$0444,$0544,$0017,$0004,$0004,$2544,$2644
        .word   $2544,$0004,$0646,$001b,$0646,$0004,$4515,$4515
        .word   $0444,$0544,$0444,$0004,$0004,$0004,$2644,$2544
        .word   $2644,$0646,$0004,$0646,$0004,$0646,$0004,$4019
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0004,$0004
        .word   $0004,$0004,$0004,$0004,$0004,$0004,$0004,$0004

; ------------------------------------------------------------------------------

; [ update magitek train ride graphics ]

_ee9f14:

@hDP := hWMDATA & $ff00

@9f14:  phb
        php
        phd
        shorta
        lda     #$7f
        pha
        plb
        lda     #$00
        sta     f:hWMADDH
        lda     #$00
        sta     f:$000024     ;
        sta     f:$0000fa     ; clear 4 frame counter
        longai
        lda     #@hDP                   ; nonzero dp, don't use clr_a
        tcd
        ldx     #0
@9f36:  stz     $9618,x     ; clear magitek train ride graphics buffer
        stz     $961a,x
        stz     $961c,x
        stz     $961e,x
        stz     $9620,x
        stz     $9622,x
        stz     $9624,x
        stz     $9626,x
        stz     $9628,x
        stz     $962a,x
        stz     $962c,x
        stz     $962e,x
        stz     $9630,x
        stz     $9632,x
        stz     $9634,x
        stz     $9636,x
        stz     $9638,x
        stz     $963a,x
        stz     $963c,x
        stz     $963e,x
        stz     $9640,x
        stz     $9642,x
        stz     $9644,x
        stz     $9646,x
        stz     $9648,x
        stz     $964a,x
        stz     $964c,x
        stz     $964e,x
        stz     $9650,x
        stz     $9652,x
        stz     $9654,x
        stz     $9656,x
        stz     $9658,x
        stz     $965a,x
        stz     $965c,x
        stz     $965e,x
        stz     $9660,x
        stz     $9662,x
        stz     $9664,x
        stz     $9666,x
        txa                 ; next tile
        clc
        adc     #$0100
        tax
        cmp     #$5000
        beq     @9fbc
        jmp     @9f36
@9fbc:  ldy     #$01e0
@9fbf:  ldx     a:$0002,y     ; tile index
        lda     $0814,x     ; pointer to tile graphics (last layer)
        sta     <hWMADDL         ; $2181
        ldx     a:$0000,y     ; tile position
        beq     @9ffd       ; branch if tile is not shown
        sty     $0c5c
        ldy     #$0004
@9fd2:  shorta
        lda     $80
        beq     @9fdb
        sta     $7fff,x
@9fdb:  lda     $80
        beq     @9fe2
        sta     $8000,x
@9fe2:  lda     $80
        beq     @9fe9
        sta     $8001,x
@9fe9:  lda     $80
        beq     @9ff0
        sta     $8002,x
@9ff0:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @9fd2
        ldy     $0c5c
@9ffd:  iny4                 ; next tile
        cpy     #$0300
        bne     @9fbf
@a006:  ldx     a:$0002,y     ; tile index
        lda     $0812,x     ; pointer to tile graphics (next to last layer)
        sta     $81
        ldx     a:$0000,y
        beq     @a04b
        sty     $0c5c
        ldy     #$0005
@a019:  shorta
        lda     $80
        beq     @a022
        sta     $7ffe,x
@a022:  lda     $80
        beq     @a029
        sta     $7fff,x
@a029:  lda     $80
        beq     @a030
        sta     $8000,x
@a030:  lda     $80
        beq     @a037
        sta     $8001,x
@a037:  lda     $80
        beq     @a03e
        sta     $8002,x
@a03e:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a019
        ldy     $0c5c
@a04b:  iny4
        cpy     #$03c0
        bne     @a006
@a054:  ldx     a:$0002,y
        lda     $0810,x
        sta     $81
        ldx     a:$0000,y
        beq     @a0a0
        sty     $0c5c
        ldy     #$0006
@a067:  shorta
        lda     $80
        beq     @a070
        sta     $7ffe,x
@a070:  lda     $80
        beq     @a077
        sta     $7fff,x
@a077:  lda     $80
        beq     @a07e
        sta     $8000,x
@a07e:  lda     $80
        beq     @a085
        sta     $8001,x
@a085:  lda     $80
        beq     @a08c
        sta     $8002,x
@a08c:  lda     $80
        beq     @a093
        sta     $8003,x
@a093:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a067
        ldy     $0c5c
@a0a0:  iny4
        cpy     #$0420
        bne     @a054
@a0a9:  ldx     a:$0002,y
        lda     $080e,x
        sta     $81
        ldx     a:$0000,y
        beq     @a0fc
        sty     $0c5c
        ldy     #$0007
@a0bc:  shorta
        lda     $80
        beq     @a0c5
        sta     $7ffd,x
@a0c5:  lda     $80
        beq     @a0cc
        sta     $7ffe,x
@a0cc:  lda     $80
        beq     @a0d3
        sta     $7fff,x
@a0d3:  lda     $80
        beq     @a0da
        sta     $8000,x
@a0da:  lda     $80
        beq     @a0e1
        sta     $8001,x
@a0e1:  lda     $80
        beq     @a0e8
        sta     $8002,x
@a0e8:  lda     $80
        beq     @a0ef
        sta     $8003,x
@a0ef:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a0bc
        ldy     $0c5c
@a0fc:  iny4
        cpy     #$0480
        bne     @a0a9
@a105:  ldx     a:$0002,y
        lda     $080c,x
        sta     $81
        ldx     a:$0000,y
        beq     @a15f
        sty     $0c5c
        ldy     #$0008
@a118:  shorta
        lda     $80
        beq     @a121
        sta     $7ffd,x
@a121:  lda     $80
        beq     @a128
        sta     $7ffe,x
@a128:  lda     $80
        beq     @a12f
        sta     $7fff,x
@a12f:  lda     $80
        beq     @a136
        sta     $8000,x
@a136:  lda     $80
        beq     @a13d
        sta     $8001,x
@a13d:  lda     $80
        beq     @a144
        sta     $8002,x
@a144:  lda     $80
        beq     @a14b
        sta     $8003,x
@a14b:  lda     $80
        beq     @a152
        sta     $8004,x
@a152:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a118
        ldy     $0c5c
@a15f:  iny4
        cpy     #$04e0
        bne     @a105
@a168:  ldx     a:$0002,y
        lda     $080a,x
        sta     $81
        ldx     a:$0000,y
        beq     @a1c9
        sty     $0c5c
        ldy     #$0009
@a17b:  shorta
        lda     $80
        beq     @a184
        sta     $7ffc,x
@a184:  lda     $80
        beq     @a18b
        sta     $7ffd,x
@a18b:  lda     $80
        beq     @a192
        sta     $7ffe,x
@a192:  lda     $80
        beq     @a199
        sta     $7fff,x
@a199:  lda     $80
        beq     @a1a0
        sta     $8000,x
@a1a0:  lda     $80
        beq     @a1a7
        sta     $8001,x
@a1a7:  lda     $80
        beq     @a1ae
        sta     $8002,x
@a1ae:  lda     $80
        beq     @a1b5
        sta     $8003,x
@a1b5:  lda     $80
        beq     @a1bc
        sta     $8004,x
@a1bc:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a17b
        ldy     $0c5c
@a1c9:  iny4
        cpy     #$0510
        bne     @a168
@a1d2:  ldx     a:$0002,y
        lda     $0808,x
        sta     $81
        ldx     a:$0000,y
        beq     @a23a
        sty     $0c5c
        ldy     #$000a
@a1e5:  shorta
        lda     $80
        beq     @a1ee
        sta     $7ffc,x
@a1ee:  lda     $80
        beq     @a1f5
        sta     $7ffd,x
@a1f5:  lda     $80
        beq     @a1fc
        sta     $7ffe,x
@a1fc:  lda     $80
        beq     @a203
        sta     $7fff,x
@a203:  lda     $80
        beq     @a20a
        sta     $8000,x
@a20a:  lda     $80
        beq     @a211
        sta     $8001,x
@a211:  lda     $80
        beq     @a218
        sta     $8002,x
@a218:  lda     $80
        beq     @a21f
        sta     $8003,x
@a21f:  lda     $80
        beq     @a226
        sta     $8004,x
@a226:  lda     $80
        beq     @a22d
        sta     $8005,x
@a22d:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a1e5
        ldy     $0c5c
@a23a:  iny4
        cpy     #$0540
        bne     @a1d2
@a243:  ldx     a:$0002,y
        lda     $0806,x
        sta     $81
        ldx     a:$0000,y
        beq     @a2b2
        sty     $0c5c
        ldy     #$000b
@a256:  shorta
        lda     $80
        beq     @a25f
        sta     $7ffb,x
@a25f:  lda     $80
        beq     @a266
        sta     $7ffc,x
@a266:  lda     $80
        beq     @a26d
        sta     $7ffd,x
@a26d:  lda     $80
        beq     @a274
        sta     $7ffe,x
@a274:  lda     $80
        beq     @a27b
        sta     $7fff,x
@a27b:  lda     $80
        beq     @a282
        sta     $8000,x
@a282:  lda     $80
        beq     @a289
        sta     $8001,x
@a289:  lda     $80
        beq     @a290
        sta     $8002,x
@a290:  lda     $80
        beq     @a297
        sta     $8003,x
@a297:  lda     $80
        beq     @a29e
        sta     $8004,x
@a29e:  lda     $80
        beq     @a2a5
        sta     $8005,x
@a2a5:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a256
        ldy     $0c5c
@a2b2:  iny4
        cpy     #$0570
        bne     @a243
@a2bb:  ldx     a:$0002,y
        lda     $0804,x
        sta     $81
        ldx     a:$0000,y
        beq     @a331
        sty     $0c5c
        ldy     #$000c
@a2ce:  shorta
        lda     $80
        beq     @a2d7
        sta     $7ffb,x
@a2d7:  lda     $80
        beq     @a2de
        sta     $7ffc,x
@a2de:  lda     $80
        beq     @a2e5
        sta     $7ffd,x
@a2e5:  lda     $80
        beq     @a2ec
        sta     $7ffe,x
@a2ec:  lda     $80
        beq     @a2f3
        sta     $7fff,x
@a2f3:  lda     $80
        beq     @a2fa
        sta     $8000,x
@a2fa:  lda     $80
        beq     @a301
        sta     $8001,x
@a301:  lda     $80
        beq     @a308
        sta     $8002,x
@a308:  lda     $80
        beq     @a30f
        sta     $8003,x
@a30f:  lda     $80
        beq     @a316
        sta     $8004,x
@a316:  lda     $80
        beq     @a31d
        sta     $8005,x
@a31d:  lda     $80
        beq     @a324
        sta     $8006,x
@a324:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a2ce
        ldy     $0c5c
@a331:  iny4
        cpy     #$05a0
        bne     @a2bb
@a33a:  ldx     a:$0002,y
        lda     $0802,x
        sta     $81
        ldx     a:$0000,y
        beq     @a3be
        sty     $0c5c
        ldy     #$000e
@a34d:  shorta
        lda     $80
        beq     @a356
        sta     $7ffa,x
@a356:  lda     $80
        beq     @a35d
        sta     $7ffb,x
@a35d:  lda     $80
        beq     @a364
        sta     $7ffc,x
@a364:  lda     $80
        beq     @a36b
        sta     $7ffd,x
@a36b:  lda     $80
        beq     @a372
        sta     $7ffe,x
@a372:  lda     $80
        beq     @a379
        sta     $7fff,x
@a379:  lda     $80
        beq     @a380
        sta     $8000,x
@a380:  lda     $80
        beq     @a387
        sta     $8001,x
@a387:  lda     $80
        beq     @a38e
        sta     $8002,x
@a38e:  lda     $80
        beq     @a395
        sta     $8003,x
@a395:  lda     $80
        beq     @a39c
        sta     $8004,x
@a39c:  lda     $80
        beq     @a3a3
        sta     $8005,x
@a3a3:  lda     $80
        beq     @a3aa
        sta     $8006,x
@a3aa:  lda     $80
        beq     @a3b1
        sta     $8007,x
@a3b1:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a34d
        ldy     $0c5c
@a3be:  iny4
        cpy     #$05d0
        beq     @a3ca
        jmp     @a33a
@a3ca:  ldx     a:$0002,y
        lda     $0800,x     ; pointer to tile graphics (first layer)
        sta     $81
        ldx     a:$0000,y
        bne     @a3da
        jmp     @a45f
@a3da:  sty     $0c5c
        ldy     #$0010
@a3e0:  shorta
        lda     $80
        beq     @a3e9
        sta     $7ff9,x
@a3e9:  lda     $80
        beq     @a3f0
        sta     $7ffa,x
@a3f0:  lda     $80
        beq     @a3f7
        sta     $7ffb,x
@a3f7:  lda     $80
        beq     @a3fe
        sta     $7ffc,x
@a3fe:  lda     $80
        beq     @a405
        sta     $7ffd,x
@a405:  lda     $80
        beq     @a40c
        sta     $7ffe,x
@a40c:  lda     $80
        beq     @a413
        sta     $7fff,x
@a413:  lda     $80
        beq     @a41a
        sta     $8000,x
@a41a:  lda     $80
        beq     @a421
        sta     $8001,x
@a421:  lda     $80
        beq     @a428
        sta     $8002,x
@a428:  lda     $80
        beq     @a42f
        sta     $8003,x
@a42f:  lda     $80
        beq     @a436
        sta     $8004,x
@a436:  lda     $80
        beq     @a43d
        sta     $8005,x
@a43d:  lda     $80
        beq     @a444
        sta     $8006,x
@a444:  lda     $80
        beq     @a44b
        sta     $8007,x
@a44b:  lda     $80
        beq     @a452
        sta     $8008,x
@a452:  longac
        txa
        sbc     #$00ff
        tax
        dey
        bne     @a3e0
        ldy     $0c5c
@a45f:  iny4
        cpy     #$0600
        beq     @a46b
        jmp     @a3ca
@a46b:  lda     #$0001
        sta     f:$000024
        pld
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ decompress ]

; ++$d2 = source
; ++$d5 = destination

Decompress:
decode:
@a476:  phb
        phd
        ldx     #$0000
        phx
        pld
        longa
        lda     [$d2]
        sta     $db
        lda     $d5
        sta     f:hWMADDL
        shorta
        lda     $d7
        and     #$01
        sta     f:hWMADDH
        lda     #$01
        sta     $dd
        ldy     #$0002
        lda     #$7e
        pha
        plb
        ldx     #$f800
        tdc
@a4a2:  sta     a:$0000,x
        inx
        bne     @a4a2
        ldx     #$ffde
@a4ab:  dec     $dd
        bne     @a4b8
        lda     #$08
        sta     $dd
        lda     [$d2],y
        sta     $de
        iny
@a4b8:  lsr     $de
        bcc     @a4cd
        lda     [$d2],y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @a4ff
        ldx     #$f800
        bra     @a4ff
@a4cd:  lda     [$d2],y
        xba
        iny
        sty     $d8
        lda     [$d2],y
        lsr3
        clc
        adc     #$03
        sta     $da
        lda     [$d2],y
        ora     #$f8
        xba
        tay
@a4e3:  lda     a:$0000,y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @a4f3
        ldx     #$f800
@a4f3:  iny
        bne     @a4f9
        ldy     #$f800
@a4f9:  dec     $da
        bne     @a4e3
        ldy     $d8
@a4ff:  iny
        cpy     $db
        bne     @a4ab
        tdc
        xba
        pld
        plb
        rts

; ------------------------------------------------------------------------------

; [ world nmi (w/ vehicle) ]

VehicleNMI:
@a509:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        shorta
        tdc
        pha
        plb
        inc     a:$0024
        cmp     hRDNMI
        jsl     IncGameTime_ext
        lda     $f7
        ldx     #$6f00
        jsl     LoadMapCharGfx_ext
        ldx     $44
        bmi     @a555
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6d50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0100
        stx     $4305
        lda     #$00
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        bra     @a5a4
@a555:  ldx     $46
        bmi     @a5a4
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6e50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        ldx     $46
        inx
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6ed0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
@a5a4:  stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longa
        lda     $34
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     $38
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     $34
        sta     hM7X
        lda     $35
        sta     hM7X
        lda     $38
        sta     hM7Y
        lda     $39
        sta     hM7Y
        stz     $4300
        lda     #$04
        sta     $4301
        ldx     #$6b30
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0220
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        lda     f:$001f64
        cmp     #$02
        beq     @a674
        lda     #$80
        sta     hVMAINC
        ldx     #$1100
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b750
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$1500
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b7d0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
@a674:  lda     $e7
        bit     #$01
        bne     @a680
        lda     $20
        cmp     #$01
        bne     @a680
@a680:  shorta
        lda     $23
        bne     @a688
        lda     #$80
@a688:  sta     hINIDISP
        stz     $fa
        lda     $e9
        bit     #$01
        beq     @a699
        lda     $fa
        ora     #$04
        sta     $fa
@a699:  lda     $e9
        bit     #$02
        beq     @a6a5
        lda     $fa
        ora     #$08
        sta     $fa
@a6a5:  lda     #$f2
        ora     $fa
        sta     hHDMAEN
        pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; ------------------------------------------------------------------------------

; [ world irq (airship) ]

AirshipIRQ:
@a6b7:  php
        longa
        pha
        phb
        shorta
        tdc
        pha
        plb
        cmp     hTIMEUP
        lda     #$07
        sta     hBGMODE
        plb
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ world irq (chocobo) ]

ChocoIRQ:
@a6cf:  php
        longa
        pha
        phb
        shorta
        tdc
        pha
        plb
        cmp     hTIMEUP
@a6dc:  lda     hHVBJOY
        bit     #$40
        bne     @a6dc
        cmp     hSLHV
        lda     hOPVCT
        cmp     hOPVCT
        cmp     #$90
        bcs     @a6fc
        lda     #$9c
        sta     hVTIMEL
        lda     #$07
        sta     hBGMODE
        bra     @a701
@a6fc:  lda     #$63
        sta     hCGADSUB
@a701:  plb
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ vector approach irq ]

VectorApproachIRQ:
@a707:  php
        longa
        pha
        shorta
        cmp     f:hTIMEUP
        lda     #$07
        sta     f:hBGMODE
        lda     #$02
        sta     f:hCGSWSEL
        lda     #$a3
        sta     f:hCGADSUB
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ world nmi (no vehicle) ]

WorldNMI:
@a728:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        shorta
        tdc
        pha
        plb
        inc     a:$0024
        cmp     hRDNMI
        jsl     IncGameTime_ext
        lda     $e8
        bit     #$20
        beq     @a74a
        jmp     @a8d2
@a74a:  bit     #$80
        beq     @a751
        jmp     @a8c7
@a751:  lda     $f7
        ldx     #$6f00
        jsl     LoadMapCharGfx_ext
        ldx     $44
        bmi     @a784
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6d50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0100
        stx     $4305
        lda     #$00
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        bra     @a7d3
@a784:  ldx     $46
        bmi     @a7d3
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6e50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        ldx     $46
        inx
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6ed0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
@a7d3:  stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longa
        lda     $34
        clc
        adc     #$0008
        and     #$0fff
        sta     a:$00fa
        lda     $38
        sec
        sbc     #$0002
        and     #$0fff
        sta     a:$00fc
        lda     a:$00fa
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     a:$00fc
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     a:$00fa
        sta     hM7X
        lda     a:$00fb
        sta     hM7X
        lda     a:$00fc
        sta     hM7Y
        lda     a:$00fd
        sta     hM7Y
        stz     $4300
        lda     #$04
        sta     $4301
        ldx     #$6b30
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0220
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$1100
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b750
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$1500
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b7d0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        lda     #$f0
        sta     hHDMAEN
        lda     $23
        bne     @a8c4
        lda     #$80
@a8c4:  sta     hINIDISP
@a8c7:  pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; ------------------------------------------------------------------------------

; [  ]

@a8d2:  longa
        lda     $34
        clc
        adc     #$0008
        and     #$0fff
        sta     a:$00fa
        lda     $38
        sec
        sbc     #$0002
        and     #$0fff
        sta     a:$00fc
        lda     a:$00fa
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     a:$00fc
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     a:$00fa
        sta     hM7X
        lda     a:$00fb
        sta     hM7X
        lda     a:$00fc
        sta     hM7Y
        lda     a:$00fd
        sta     hM7Y
        lda     #$f0
        sta     hHDMAEN
        jmp     @a8c7

; ------------------------------------------------------------------------------

; [ world irq (no vehicle) ]

WorldIRQ:
@a93a:  php
        longa
        pha
        phb
        shorta
        tdc
        pha
        plb
        cmp     hTIMEUP
        plb
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ magitek train ride nmi ]

TrainNMI:
@a94d:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        lda     #$0000
        tcd
        shorta
        tdc
        pha
        plb
        cmp     hRDNMI       ; clear nmi
        inc     a:$00fa       ; increment 4 frame counter
        jsl     IncGameTime_ext
        lda     #$02
        stz     hM7X       ; m7x = $0200
        sta     hM7X
        lda     #$e0
        sta     hM7Y       ; m7y = $01e0
        lda     #$01
        sta     hM7Y
        lda     $3d
        sta     hM7A
        lda     $3e
        sta     hM7A
        lda     $3f
        sta     hM7B
        lda     $40
        sta     hM7B
        lda     $41
        sta     hM7C
        lda     $42
        sta     hM7C
        lda     $3d
        sta     hM7D
        lda     $3e
        sta     hM7D
        lda     $24         ;
        bne     @a9e0
        stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000      ; source = $7ee000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200      ; size = $0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        shorta
        lda     #$80
        sta     hBG1HOFS    ; bg1 horizontal scroll
        lda     #$01
        sta     hBG1HOFS
        lda     #$70
        sta     hBG1VOFS    ; bg1 vertical scroll
        lda     #$01
        sta     hBG1VOFS
        jmp     @aa1c
@a9e0:  stz     hVMAINC
        ldx     #$a618      ; source = $7fa618 (last $3e00 of graphics)
        ldy     #$1318      ; destination = $1318 (vram)
@a9e9:  shorta
        sty     hVMADDL
        stz     $4300
        lda     #$18
        sta     $4301
        stx     $4302
        lda     #$7f
        sta     $4304
        lda     #$50        ; size = $0050
        sta     $4305
        stz     $4306
        lda     #$01
        sta     hMDMAEN
        longac
        tya
        adc     #$0080
        tay
        txa
        adc     #$0100
        tax
        cmp     #$e418
        bne     @a9e9
@aa1c:  shorta
        stz     $fe         ;
        lda     #$10
        sta     hVTIMEL       ; vertical irq counter = 16
        lda     #$b1
        sta     hNMITIMEN      ; enable nmi, vertical irq, horizontal irq, and joypad
        pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; ------------------------------------------------------------------------------

; [ magitek train ride irq ]

TrainIRQ:
@aa35:  php
        longai
        pha
        phx
        phy
        phb
        shorta
        lda     #$00
        pha
        plb
        cmp     hTIMEUP       ; clear irq
        lda     a:$00fe
        bne     @aa5a
        inc     a:$00fe
        lda     #$d0
        sta     hVTIMEL       ; vertical irq counter = 208
        lda     a:$0023
        sta     hINIDISP    ; set screen brightness
        bra     @aaa5
@aa5a:  lda     #$81
        sta     hNMITIMEN       ; disable irq
        lda     #$80
        sta     hINIDISP    ; screen off
        lda     a:$0024
        beq     @aaa5       ; return if not in vblank
        stz     hVMAINC
        ldx     #$9618      ; source = $7f9618 (first $1000 bytes of graphics)
        ldy     #$0b18      ; destination = $0b18 (vram)
@aa72:  shorta
        sty     hVMADDL
        stz     $4300
        lda     #$18
        sta     $4301
        stx     $4302
        lda     #$7f
        sta     $4304
        lda     #$50
        sta     $4305       ; size = $0050
        stz     $4306
        lda     #$01
        sta     hMDMAEN
        longac
        tya
        adc     #$0080
        tay
        txa
        adc     #$0100
        tax
        cmp     #$a618
        bne     @aa72
@aaa5:  plb
        longai
        ply
        plx
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [  ]

_eeaaad:
umianim:
@aaad:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        ldx     #$0000
@aab8:  phx
        lda     #$00
        xba
        lda     $b850,x
        clc
        adc     #$10
        sta     $b850,x
        bcc     @ab18
        txa
        cmp     #$08
        bcc     @aace
        adc     #$07
@aace:  asl3
        tax
        lda     $b750,x
        pha
        longa
        lda     $b751,x
        sta     $b750,x
        lda     $b753,x
        sta     $b752,x
        lda     $b755,x
        sta     $b754,x
        shorta
        lda     $b757,x
        sta     $b756,x
        lda     $b790,x
        sta     $b757,x
        longa
        lda     $b791,x
        sta     $b790,x
        lda     $b793,x
        sta     $b792,x
        lda     $b795,x
        sta     $b794,x
        shorta
        lda     $b797,x
        sta     $b796,x
        pla
        sta     $b797,x
@ab18:  plx
        inx
        cpx     #$0010
        bne     @aab8
        longai
        lda     $1f64
        and     #$0003
        bne     @ab4a
        lda     $b860
        dec
        and     #$000f
        bne     @ab47
        ldx     $e0da
        lda     $e0de
        stx     $e0de
        ldx     $e0dc
        sta     $e0dc
        stx     $e0da
        lda     #$0010
@ab47:  sta     $b860
@ab4a:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ ending airship scene nmi ]

EndingAirshipSceneNMI:
@ab4d:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        shorta
        tdc
        pha
        plb
        inc     a:$0024
        cmp     hRDNMI
        stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longa
        lda     $34
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     $38
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     $34
        sta     hM7X
        lda     $35
        sta     hM7X
        lda     $38
        sta     hM7Y
        lda     $39
        sta     hM7Y
        stz     $4300
        lda     #$04
        sta     $4301
        ldx     #$6b30
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0220
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        shorta
        lda     $23
        bne     @abe9
        lda     #$80
@abe9:  sta     hINIDISP
        stz     $fa
        lda     $e9
        bit     #$01
        beq     @abfa
        lda     $fa
        ora     #$04
        sta     $fa
@abfa:  lda     $e9
        bit     #$02
        beq     @ac06
        lda     $fa
        ora     #$08
        sta     $fa
@ac06:  lda     #$f2
        ora     $fa
        sta     hHDMAEN
        pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; ------------------------------------------------------------------------------

; [  ]

UpdateMode7Circle:
@ac18:  php
        phb
        shortai
        lda     $59
        beq     @ac9e
        lda     #$7e
        pha
        plb
        longa
        stz     $6c
        stz     $6f
        lda     $58
        sta     $6a
        stz     $6d
        cmp     #$8000
        bcs     @ac3c
        cmp     #$4000
        bcs     @ac58
        bra     @ac7a
@ac3c:  longac
        lda     $6d
        adc     $6b
        sta     $6d
        lda     $6a
        sec
        sbc     $6e
        bcc     @ac9e
        sta     $6a
        ldx     $6b
        shortac
        lda     $6e
        sta     $bc62,x
        bra     @ac3c
@ac58:  longac
        lda     $6b
        asl
        adc     $6d
        sta     $6d
        lda     $6e
        asl
        sta     $5a
        lda     $6a
        sec
        sbc     $5a
        bcc     @ac9e
        sta     $6a
        ldx     $6b
        shortac
        lda     $6e
        sta     $bc62,x
        bra     @ac58
@ac7a:  longac
        lda     $6b
        asl2
        adc     $6d
        sta     $6d
        lda     $6e
        asl2
        sta     $5a
        lda     $6a
        sec
        sbc     $5a
        bcc     @ac9e
        sta     $6a
        ldx     $6b
        shortac
        lda     $6e
        sta     $bc62,x
        bra     @ac7a
@ac9e:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [  ]

_eeaca1:
bomb:
@aca1:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        longai
        lda     $5e
        bne     @acb2
        jmp     @ad3f
@acb2:  lda     $5a
        asl2
        clc
        adc     $5c
        tay
        ldx     #$0000
        lda     $5e
        cmp     $5a
        bcs     @acc9
        lda     $5e
        sta     $60
        bra     @accd
@acc9:  lda     $5a
        sta     $60
@accd:  shorta
        lda     $58
        sec
        sbc     $bc62,x
        bcs     @acd9
        lda     #$00
@acd9:  sta     $620e,y
        lda     $58
        clc
        adc     $bc62,x
        bcc     @ace6
        lda     #$ff
@ace6:  sta     $620f,y
        dey4
        inx
        cpx     $60
        bne     @accd
        longa
        lda     $5a
        asl2
        clc
        adc     $5c
        tay
        ldx     #$0000
        lda     #$00e0
        sec
        sbc     $5a
        sta     $62
        lda     $5e
        lsr
        cmp     $62
        bcs     @ad14
        lda     $5e
        sta     $60
        bra     @ad19
@ad14:  lda     $62
        asl
        sta     $60
@ad19:  shorta
        lda     $58
        sec
        sbc     $bc62,x
        bcs     @ad25
        lda     #$00
@ad25:  sta     $620e,y
        lda     $58
        clc
        adc     $bc62,x
        bcc     @ad32
        lda     #$ff
@ad32:  sta     $620f,y
        iny4
        inx2
        cpx     $60
        bcc     @ad19
@ad3f:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ copy color palettes to ppu ]

; only used for magitek train
; ++$6a: source address

TfrPal:
@ad42:  stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     $6a
        stx     $4302
        lda     $6c
        sta     $4304
        ldx     #$0200      ; size = $0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; copy palettes from ppu to wram
        stz     hCGADD
        ldx     #$3b80
        stx     $4300
        ldx     #$e000      ; destination = $7ee000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200      ; size = $0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy backdrop graphics to vram (BG2) ]

TfrBackdropGfx:
@ad80:  lda     #$80
        sta     hVMAINC
        ldx     #$5000      ; destination = $5000 (vram)
        stx     hVMADDL
        ldx     #$1801
        stx     $4300
        ldx     #$2000      ; source = $7e2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$2000      ; size = $2000
        stx     $4305
        lda     #$01
        sta     hMDMAEN       ; enable dma
        rts

; ------------------------------------------------------------------------------

; [ copy backdrop tile formation to vram ]

TfrBackdropTiles:
@ada8:  lda     #$80
        sta     hVMAINC
        ldx     #$4400      ; destination = $4400 (vram)
        stx     hVMADDL
        ldx     #$1801
        stx     $4300
        ldx     #$2000      ; source = $7e2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$1000      ; size = $1000
        stx     $4305
        lda     #$01
        sta     hMDMAEN       ; enable dma
        rts

; ------------------------------------------------------------------------------

; [ copy sprite graphics to vram ]

TfrSpriteGfx:
@add0:  lda     #$80
        sta     hVMAINC
        ldx     #$6000     ; destination = $6000 (vram)
        stx     hVMADDL
        ldx     #$1801
        stx     $4300
        ldx     #$2000     ; source = $7e2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$4000     ; size = $4000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ init magitek train ride tile map in vram ]

_eeadf8:
beta:
@adf8:  lda     #$80
        sta     hVMAINC
        stz     hVMADDL
        stz     hVMADDH
        ldy     #$0000
@ae06:  sty     $58         ; tile index
        ldx     #$1908
        stx     $4300
        ldx     #$0058      ; source = $000058
        stx     $4302
        stz     $4304
        ldx     #$0040      ; size = $0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        iny                 ; next tile
        cpy     #$0100
        bne     @ae06
        rts

; ------------------------------------------------------------------------------

; [ copy pointers to magitek train ride tiles to vram ]

; ++$6a: source address

_eeae29:
vsptblset:
@ae29:  lda     #$80
        sta     hVMAINC
        ldx     #$0000      ; destination = $0000 (vram)
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     $6a
        stx     $4302
        lda     $6c
        sta     $4304
        ldx     #$02b8      ; size = $02b8
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$0000      ; source = $0000 (vram)
        stx     hVMADDL
        cmp     hRVMDATAH
        ldx     #$3a80
        stx     $4300
        ldx     #$0800      ; destination = $7f0800
        stx     $4302
        lda     #$7f
        sta     $4304
        ldx     #$02b8      ; size = $02b8
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [  ]

_eeae75:
umiset:
@ae75:  lda     #$80
        sta     hVMAINC
        ldx     #$1100
        stx     hVMADDL
        cmp     hRVMDATAH
        ldx     #$3a80
        stx     $4300
        ldx     #$b750
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$1500
        stx     hVMADDL
        cmp     hRVMDATAH
        ldx     #$3a80
        stx     $4300
        ldx     #$b7d0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longa
        lda     #$0080
        sta     $7eb850
        lda     #$1040
        sta     $7eb852
        lda     #$60a0
        sta     $7eb854
        lda     #$b030
        sta     $7eb856
        lda     #$20f0
        sta     $7eb858
        lda     #$c070
        sta     $7eb85a
        lda     #$50d0
        sta     $7eb85c
        lda     #$e090
        sta     $7eb85e
        shorta
        rts

; ------------------------------------------------------------------------------
