
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/ctrl.asm                                                       |
; |                                                                            |
; | description: world map control routines                                    |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

.include "gfx/battle_bg.inc"

; ------------------------------------------------------------------------------

; [ get controller input (vehicle) ]

GetVehicleInput:
@6bec:  php
        shorta
        lda     $20
        cmp     #$02
        jeq     GetChocoInput

; Y button
        shorta
        longi
        lda     $05
        bit     #$40
        jne     _6d45

; turn right
        shorta
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

; turn left
@6c2e:  shorta
        lda     $05
        bit     #$02
        beq     @6c56
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
        bpl     @6c7a
        lda     #$0200
        sta     $29
        bra     @6c7a

; update rotation angle
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

; A button
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

; decelerate forward motion
@6c92:  lda     $26
        sec
        sbc     #$0080
        cmp     #$0000
        bpl     @6ca0
        lda     #$0000
@6ca0:  sta     $26

; move up
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

; move down
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

; decelerate altitude
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

; sharp left turn
@6cea:  longa
        lda     $04
        and     #$0220
        cmp     #$0220
        bne     @6d07
        lda     a:$0073
        inc2
        cmp     #360
        bmi     @6d04
        sec
        sbc     #360
@6d04:  sta     a:$0073

; sharp right turn
@6d07:  lda     $04
        and     #$0110
        cmp     #$0110
        bne     @6d22
        lda     a:$0073
        dec2
        cmp     #$0000
        bpl     @6d1f
        clc
        adc     #360
@6d1f:  sta     a:$0073

; B button
@6d22:  lda     $05
        bit     #$0080
        beq     @6d2c       ; branch if b button is not pressed
        jsr     LandAirship
@6d2c:  jmp     _6e7e

; ------------------------------------------------------------------------------

; strafe angle if holding Y button (udlr bitmask)
StrafeAngleTbl:
@6d2f:  .word   0,270,90,0,180,225,135,0,0,315,45

; ------------------------------------------------------------------------------

; strafe with Y button
_6d45:  longa
        lda     $05
        and     #$000f
        jeq     @6e38
        asl
        tax
        lda     f:StrafeAngleTbl,x
        clc
        adc     $73
        cmp     #360
        bcc     @6d62
        sbc     #360
@6d62:  sta     $58
        cmp     #180
        bcc     @6d6c
        sbc     #180
@6d6c:  tax
        lda     f:WorldSineTbl,x
        sta     $5e
        lda     f:WorldSineTbl+90,x
        sta     $60
        longa
        shorti
        lda     $58
        cmp     #180
        bcc     @6d99
        ldx     #$00
        stx     $5b
        cmp     #270
        bcc     @6d93
@6d8d:  ldx     #$01
        stx     $5a
        bra     @6da4
@6d93:  ldx     #$00
        stx     $5a
        bra     @6da4
@6d99:  ldx     #$01
        stx     $5b
        cmp     #90
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

; hide/show minimap
_6e7e:  longa
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

; exit to airship deck
@6ead:  lda     $04
        sta     $31
        lda     $19
        bne     @6ee8
        lda     $08                     ; check X button
        bit     #$0040
        beq     @6ee8
        stz     $ed
        lda     $2f
        sta     $11f4
        lda     $73
        ora     #$8000
        sta     $11f2
        shorta
        lda     f:VehicleEvent_00       ; ca/0068 (blackjack deck)
        sta     $ea
        lda     f:VehicleEvent_00+1
        sta     $eb
        lda     f:VehicleEvent_00+2
        clc
        adc     #^EventScript
        sta     $ec
        lda     $e7
        ora     #$41
        sta     $e7

; check for doom gaze
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
        lda     $34                     ; x position (in 4 tile increments)
        lsr6
        and     #$00ff
        sta     $58
        lda     $38                     ; y position (in 4 tile increments)
        lsr6
        and     #$00ff
        sta     $5a
        ldx     #$0000
@6f1d:  lda     f:$000b00,x             ; check doom gaze position
        cmp     $58
        bne     @6f2f
        lda     f:$000b02,x
        cmp     $5a
        bne     @6f2f
        bra     @6f3a
@6f2f:  inx4
        cpx     #$0008                  ; only check the first 2 positions
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
        lda     #BATTLE_BG::AIRSHIP_WOR
        sta     $11e2
        shorta
        stz     $11e4
        lda     $11f6                   ; enable battle and ???
        ora     #$22
        sta     $11f6
        lda     $11fa                   ; return to airship after battle
        ora     #$01
        sta     $11fa
@6f6b:  plp
        rts

; ------------------------------------------------------------------------------

; [ get controller input (chocobo) ]

GetChocoInput:
; right button
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

; left button
@6f96:  shorta
        lda     $05
        bit     #$02
        beq     @6fbc
        longa_clc
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

; decelerate rotation
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

; sharp left turn
@700d:  longa
        lda     $04
        and     #$0220
        cmp     #$0220
        bne     @702a
        lda     a:$0073
        inc2
        cmp     #360
        bmi     @7027
        sec
        sbc     #360
@7027:  sta     a:$0073

; sharp right turn
@702a:  lda     $04
        and     #$0110
        cmp     #$0110
        bne     @7045
        lda     a:$0073
        dec2
        cmp     #$0000
        bpl     @7042
        clc
        adc     #360
@7042:  sta     a:$0073

; B button
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
