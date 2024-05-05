
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/event.asm                                                      |
; |                                                                            |
; | description: world map event routines                                      |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

.import EventScript, EventBattleGroup

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
        lda     #$30            ; acts like L+R buttons both down
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
        adc     #.bankbyte(EventScript)
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
        adc     #.bankbyte(EventScript)
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

; [ vehicle event command $c0: modify vehicle movement flags ]

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
        clr_a
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
        clr_a
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

; [ vehicle event command $de: set rotation center ]

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
@751b:  lda     f:World2SpritePal,x
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

; [ vehicle event command $f6: unused ??? ]

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

; [ vehicle event command $f8: world of ruin cutscene ]

VehicleCmd_f8:
@7568:  php
        phb
        jsr     RuinScene
        plb
        plp
        shorta
        jmp     NextVehicleCmdContinue

; ------------------------------------------------------------------------------

; [ vehicle event command $f9: unused ??? ]

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
        jsr     FalconRising
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
        jsr     AirshipCrash
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
        jsr     VectorApproach
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

; [ update automatic control of vehicle ]

UpdateAutoCtrl:
@75d3:  shorta
        lda     $61
        bit     #$01
        beq     @75fa                   ; branch if not turning right
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
        beq     @7622                   ; branch if not turning left
        longa
        longa_clc
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
        beq     @765e                   ; branch if not going forward
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
        beq     @7678                   ; branch if not going backward
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
        beq     @7691                   ; branch if not going down
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
        beq     @76aa                   ; branch if not going up
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
        lda     $60                     ; check double speed left turn
        and     #$0220
        cmp     #$0220
        bne     @76dd
        lda     a:$0073
        inc2
        cmp     #360
        bmi     @76da
        sec
        sbc     #360
@76da:  sta     a:$0073
@76dd:  lda     $60                     ; check double speed right turn
        and     #$0110
        cmp     #$0110
        bne     @76f8
        lda     a:$0073
        dec2
        cmp     #$0000
        bpl     @76f5
        clc
        adc     #360
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
.repeat 56
        .addr   VehicleCmd_b0
.endrep
.repeat 8
        .addr   VehicleCmd_b8
.endrep
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
.repeat 6
        .addr   VehicleCmd_ca
.endrep
        .addr   VehicleCmd_d0
        .addr   VehicleCmd_d1
        .addr   VehicleCmd_d2
        .addr   VehicleCmd_d3
.repeat 5
        .addr   VehicleCmd_d4
.endrep
        .addr   VehicleCmd_d9
        .addr   VehicleCmd_da
        .addr   VehicleCmd_db
        .addr   VehicleCmd_dc
        .addr   VehicleCmd_dd
        .addr   VehicleCmd_de
        .addr   VehicleCmd_df
        .addr   VehicleCmd_e0
.repeat 18
        .addr   VehicleCmd_e1
.endrep
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        jsr     GetWorldTileProp
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
        adc     #.bankbyte(EventScript)
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
        adc     #.bankbyte(EventScript)
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
        jsr     DrawWorldChar
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $cd: turn character right ]

WorldCmd_cd:
@7dae:  shorta
        lda     #$01
        sta     $f6
        shorti
        jsr     DrawWorldChar
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $ce: turn character down ]

WorldCmd_ce:
@7dbe:  shorta
        lda     #$02
        sta     $f6
        shorti
        jsr     DrawWorldChar
        longi
        jmp     NextWorldCmdContinue

; ------------------------------------------------------------------------------

; [ world event command $cf: turn character left ]

WorldCmd_cf:
@7dce:  shorta
        lda     #$03
        sta     $f6
        shorti
        jsr     DrawWorldChar
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
        adc     #.bankbyte(EventScript)
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
        jsr     InitWorldSpriteMSB
@7fb3:  lda     $f2
        sta     $b61c
        inc     $ef
        longa
        lda     $ef
        and     #$00ff
        tax
        shorta
        lda     f:WorldSineTbl,x
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
        lda     f:WorldSineTbl,x
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
        longa_clc
        lda     $f1
        adc     #$0020
        sta     $f1
        cmp     #$8c00
        bcc     @8062
        shorta
        lda     $e7
        and     #$fb
        sta     $e7
        jsr     InitTrainSpriteMSB
        jsr     ClearAnimData
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
        jsr     InitWorldSpriteMSB
@80be:  lda     $f2
        sta     $b61c
        inc     $ef
        longa
        lda     $ef
        and     #$00ff
        tax
        shorta
        lda     f:WorldSineTbl,x
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
        lda     f:WorldSineTbl,x
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
@8151:  clr_a
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
.repeat 12
        .addr   WorldCmd_b0
.endrep
.repeat 8
        .addr   WorldCmd_b8
.endrep
        .addr   WorldCmd_c0
        .addr   WorldCmd_c1
        .addr   WorldCmd_c2
        .addr   WorldCmd_c3
        .addr   WorldCmd_c4
.repeat 3
        .addr   WorldCmd_c5
.endrep
        .addr   WorldCmd_c8
        .addr   WorldCmd_c9
.repeat 3
        .addr   WorldCmd_cc
.endrep
        .addr   WorldCmd_cd
        .addr   WorldCmd_ce
        .addr   WorldCmd_cf
        .addr   WorldCmd_d0
        .addr   WorldCmd_d1
        .addr   WorldCmd_d2
        .addr   WorldCmd_d3
        .addr   WorldCmd_d4
        .addr   WorldCmd_d5
.repeat 3
        .addr   WorldCmd_d8
.endrep
        .addr   WorldCmd_d9
.repeat 4
        .addr   WorldCmd_dd
.endrep
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
