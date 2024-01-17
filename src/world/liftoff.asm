
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/liftoff.asm                                                    |
; |                                                                            |
; | description: world map vehicle liftoff and landing routines                |
; |                                                                            |
; | created: 5/18/2023                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ airship lifting off animation (1st part) ]

AirshipLiftOffAnim1:
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
@9504:  jsr     UpdateSpriteAnim
        jsr     DrawWorldSprites
        jsr     UpdateWaterAnim
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

; [ airship lifting off animation (2nd part) ]

AirshipLiftOffAnim2:
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
        lda     #$02                    ; bg mode 2
        bra     @95a3
@959c:  lda     #$01
        sta     hVTIMEL
        lda     #$07                    ; bg mode 7
@95a3:  sta     hBGMODE
        lda     #$23
        sta     hCGADSUB
        jsr     TfrBG3Tilemap
        jsr     UpdateBG2HScrollHDMA
        longa
        lda     $85
        sta     $87
        jsr     UpdateGradientSprites
        jsr     UpdateMode7Rot
        jsr     UpdateSpriteAnim
        jsr     DrawVehicleSprites
        jsr     UpdateWaterAnim
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
        jne     @9587
        lda     $11f6
        and     #$ef
        sta     $11f6
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ airship landing animation (1st part) ]

AirshipLandingAnim1:
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
        jsr     TfrBG3Tilemap
        jsr     UpdateBG2HScrollHDMA
        longa
        lda     $85
        sta     $87
        jsr     UpdateGradientSprites
        jsr     UpdateMode7Rot
        jsr     UpdateSpriteAnim
        jsr     DrawVehicleSprites
        jsr     UpdateWaterAnim
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
        jne     @96a6
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ airship landing animation (2nd part) ]

AirshipLandingAnim2:
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
        jsr     UpdateSpriteAnim
        jsr     DrawWorldSprites
        jsr     UpdateWaterAnim
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

; [ dismounting chocobo animation ]

DismountChocoAnim:
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

; start of loop
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
        jsr     TfrBG3Tilemap
        jsr     UpdateBG2HScrollHDMA
        longa
        lda     $85
        sta     $87
        jsr     UpdateGradientSprites
        jsr     UpdateMode7Rot
        jsr     UpdateSpriteAnim
        jsr     DrawVehicleSprites
        jsr     UpdateWaterAnim
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
@98dd:  lda     $ca                     ; wait for end of 1st part
        cmp     #$0b
        jne     @9872
        lda     $11f6
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
