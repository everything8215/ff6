
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/move.asm                                                       |
; |                                                                            |
; | description: world map movement routines                                   |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

.include "event/event_trigger.inc"

; ------------------------------------------------------------------------------

; [ update vehicle position ]

UpdateVehiclePos:
@174e:  php
        phb
        shorta
        clr_a
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
@1766:  cmp     #180
        bcc     @176e
        sbc     #180
@176e:  tax
        lda     f:WorldSineTbl,x
        sta     $9b
        lda     f:WorldSineTbl+90,x
        sta     $9d
        lda     $1e
        bit     #$0020
        beq     @1786
        lda     $75
        bra     @1788
@1786:  lda     $73
@1788:  cmp     #180
        bcc     @17a2
        ldx     #0
        stx     $5b
        cmp     #270
        bcc     @179c
@1796:  ldx     #1
        stx     $5a
        bra     @17ad
@179c:  ldx     #0
        stx     $5a
        bra     @17ad
@17a2:  ldx     #1
        stx     $5b
        cmp     #90
        bcc     @1796
        bra     @179c

; calculate movement speed in y-direction
@17ad:  stz     $6b
        ldx     $9d                     ; movement speed * sin(theta)
        stx     hWRMPYA
        ldx     $26                     ; forward movement speed
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
        sta     $6a                     ; distance travelled in y-direction
        ldx     $5a
        bne     @17ea

; moving down (south)
        clc
        adc     $37                     ; add to y position
        sta     $37
        lda     $39
        adc     #0
        sta     $39
        clc
        lda     $40
        adc     $6a
        sta     $40
        bra     @1801

; moving up (north)
@17ea:  sta     $6a
        lda     $37
        sec
        sbc     $6a
        sta     $37
        lda     $39
        sbc     #0
        sta     $39
        sec
        lda     $40
        sbc     $6a
        sta     $40

; calculate movement speed in x-direction
@1801:  ldx     $9b                     ; movement speed * cos(theta)
        stx     hWRMPYA
        ldx     $26                     ; forward movement speed
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
        adc     $33                     ; add to x position
        sta     $33
        lda     $35
        adc     #0
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
        sbc     #0
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

; ------------------------------------------------------------------------------

; [ update poison mosaic effect ]

PoisonMosaic:
        .a8
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

; [ vehicle battle effect ]

VehicleBattleEffect:
@1875:  php
        shorta
        lda     #$80                    ; play battle sound effect
        sta     hAPUIO2
        lda     #$c1
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
@1887:  lda     $24                     ; wait for vblank
        beq     @1887
        stz     $24
        lda     #$28                    ; wait 40 frames
        sta     $66

; start of frame loop
@1891:  shorta
        lda     #$02                    ; set bg mode
        sta     hBGMODE
        lda     $1f64
        cmp     #$02
        beq     @18a3
        lda     #$03                    ; set color math
        bra     @18a5
@18a3:  lda     #$83
@18a5:  sta     hCGADSUB
        longa
        lda     #$00e0                  ; set irq scanline
        sec
        sbc     $87
        sta     hVTIMEL
        shorta
        lda     $23                     ; decrement screen brightness
        beq     @18ba
        dec
@18ba:  sta     $23
@18bc:  lda     $24                     ; wait for vblank
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

; [ init fixed color hdma data (falcon ending cutscene) ]

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
        clr_a
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

; [ update movement (vehicle) ]

MoveVehicle:
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
        lda     f:WorldTileProp,x
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
        jsr     UpdateAutoCtrl
        bra     @1a03
@19f2:  lda     $e7
        bit     #$0001
        bne     @1a03
        lda     $1e
        bit     #$0001
        bne     @1a03                   ; branch if player input is disabled
        jsr     GetVehicleInput
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

; calculate vehicle rotation
@1a27:  longa
        lda     $1e
        bit     #$0002
        bne     @1a52
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
        adc     #360
        bra     @1a50
@1a47:  cmp     #360
        bcc     @1a50
        sec
        sbc     #360
@1a50:  sta     $73

; calculate bg2 h-scroll position
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
        sta     $70                     ; set bg2 h-scroll position

; calculate bg2 offset-per-tile rotation amount
@1a93:  longa
        lda     $1e
        bit     #$0008
        bne     @1ada
        shorti
        lda     $29
        bpl     @1aa5
        not_a
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
        clr_a
        sec
        sbc     $58
@1ad8:  sta     $83

; calculate horizon location
@1ada:  longa
        shorti
        lda     $1e
        bit     #$0010
        bne     @1b23
        lda     $2d
        bpl     @1aec
        not_a
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

; save vehicle position
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
        jsr     UpdateVehiclePos
        longa
        lda     $20
        cmp     #$0002
        bne     @1b61                   ; branch if not on chocobo
        longi
        jsr     GetVehicleTileProp
        bit     #$0001
        beq     @1b61                   ; branch if passable on chocobo
        jsr     RestoreVehiclePos
        jsr     FixChocoboCollision
@1b61:  shorti
        lda     $1e
        bit     #$0040
        bne     @1b99
        lda     $2d                     ; update altitude
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
        sta     $8b                     ; set zoom level
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

; [ fix movement for chocobo colliding with an impassable tile ]

FixChocoboCollision:
@1b9a:  php
        longai
        lda     $73                     ; save vehicle direction
        pha
        beq     @1bb1
        cmp     #90
        beq     @1bb1
        cmp     #180
        beq     @1bb1
        cmp     #270
        bne     @1bb4
@1bb1:  jmp     @1c4f                   ; return if exactly a compass direction
@1bb4:  cmp     #315
        bcs     @1c14
        cmp     #270
        bcs     @1bd7
        cmp     #225
        bcs     @1c14
        cmp     #180
        bcs     @1bd7
        cmp     #135
        bcs     @1c14
        cmp     #90
        bcs     @1bd7
        cmp     #45
        bcs     @1c14
@1bd7:  lda     $73
        clc
        adc     #90
        cmp     #360
        bcc     @1be6
        sec
        sbc     #360
@1be6:  sta     $73
        jsr     UpdateVehiclePos
        jsr     GetVehicleTileProp
        bit     #$0001
        beq     @1c4f
        jsr     RestoreVehiclePos
        pla
        pha
        sec
        sbc     #90
        bcs     @1c02
        clc
        adc     #360
@1c02:  sta     $73
        jsr     UpdateVehiclePos
        jsr     GetVehicleTileProp
        bit     #$0001
        beq     @1c4f
        jsr     RestoreVehiclePos
        bra     @1c4f
@1c14:  lda     $73
        sec
        sbc     #90
        bcs     @1c20
        clc
        adc     #360
@1c20:  sta     $73
        jsr     UpdateVehiclePos
        jsr     GetVehicleTileProp
        bit     #$0001
        beq     @1c4f
        jsr     RestoreVehiclePos
        pla
        pha
        clc
        adc     #90
        cmp     #360
        bcc     @1c3f
        sec
        sbc     #360
@1c3f:  sta     $73
        jsr     UpdateVehiclePos
        jsr     GetVehicleTileProp
        bit     #$0001
        beq     @1c4f
        jsr     RestoreVehiclePos
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
        cmp     #180
        bcs     @1c98
        dec2
        and     #$0ffe
        sta     $73
        bra     @1cb3
@1c98:  inc2
        and     #$0ffe
        cmp     #360
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

; [ get current tile properties (vehicle) ]

GetVehicleTileProp:
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

; [ restore vehicle position and speed ]

RestoreVehiclePos:
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
        ; sta     $42
        rts

; ------------------------------------------------------------------------------

; [ update movement (no vehicle) ]

MovePlayer:
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
        lda     $7f0000,x               ; current tile index
        and     #$00ff
        sta     $c4
        asl
        tax
        lda     f:WorldTileProp,x       ; tile properties
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
        jsr     GetWorldTileProp
        bit     #$0020
        beq     @1d6b                   ; branch if not a forest
        lda     $e7
        ora     #$0010
        sta     $e7
@1d6b:  shorta
        lda     $e7
        bit     #$02
        jeq     @1e1f
        lda     $e7
        and     #$fd
        sta     $e7
        lda     $e7
        bit     #$01
        jne     @1e1f                   ; branch if an event is running
        jsr     CheckEvent
        jsr     CheckEntrance
        jne     @1e1f
        shorta
        lda     $e8
        bit     #$08
        jne     @1e1f
        ora     #$08
        sta     $e8
        lda     $1eb9
        bit     #$20
        bne     @1e1f
        longa
        clr_ax
        txy
        jsr     GetWorldTileProp
        shorta
        bit     #$40
        beq     @1e1f                   ; branch if battles are disabled
        xba
        sta     $11f9                   ; battle bg index
        jsr     PushDP
        jsl     CheckBattleWorld_ext
        cmp     #$00
        beq     @1e1c                   ; branch if no random battle
        jsr     PopDP
        stz     $11fd                   ; clear event pointer
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
        sta     $1f68                   ; facing direction
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
        jsr     GetPlayerInput
        lda     $e7
        bit     #$02
        beq     @1e56
        stz     $11f0
        jsl     DoPoisonDmg_ext
        lda     $11f0
        beq     @1e56
        lda     #$78                    ; set poison mosaic counter
        sta     $ff
        lda     #$80                    ; play poison sound effect
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

; [ get player input (no vehicle) ]

GetPlayerInput:
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
        jsr     DrawWorldChar
        longai
        lda     $e7
        bit     #$0080
        bne     @1ef9
        ldx     #$0001
        ldy     #$0000
        jsr     GetWorldTileProp
        bit     #$0010
        bne     @1f0a                   ; branch if tile is impassable on foot
        bit     #$0020
        beq     @1eeb                   ; branch if not a forest
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
        jsr     DrawWorldChar
        longai
        lda     $e7
        bit     #$0080
        bne     @1f47
        ldx     #$ffff
        ldy     #$0000
        jsr     GetWorldTileProp
        bit     #$0010
        bne     @1f58                   ; branch if tile is impassable on foot
        bit     #$0020
        beq     @1f39                   ; branch if not a forest
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
        jsr     DrawWorldChar
        longai
        lda     $e7
        bit     #$0080
        bne     @1f95
        ldx     #$0000
        ldy     #$0001
        jsr     GetWorldTileProp
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
        jsr     DrawWorldChar
        longai
        lda     $e7
        bit     #$0080
        bne     @1fe2
        ldx     #$0000
        ldy     #$ffff
        jsr     GetWorldTileProp
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
        lda     $08                     ; check X button
        bit     #$40
        beq     @201f
        lda     $e8                     ; open menu
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
.if LANG_EN
        lda     $e8                     ; don't enter airship if menu is opening
        bit     #$01
        bne     @20b1
.endif
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
        adc     #^EventScript
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
        lda     $1866                   ; increment steps (max 9999999)
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
        lda     f:EventTriggerPtrs,x    ; pointer to event triggers
        sta     $58
        lda     f:EventTriggerPtrs+2,x  ; pointer to next map's event triggers
        sta     $5a
        sec
        sbc     $58
        beq     @21d5                   ; branch if there are no event triggers
        ldx     $58
        shorta
@218b:  lda     f:EventTrigger::PosX,x    ; trigger x position
        cmp     $e0
        bne     @21cc
        lda     f:EventTrigger::PosY,x  ; trigger y position
        cmp     $e2
        bne     @21cc
        lda     f:EventTrigger::EventPtr,x  ; set event pointer
        clc
        adc     #<EventScript
        sta     $ea
        lda     f:EventTrigger::EventPtr+1,x
        adc     #>EventScript
        sta     $eb
        lda     f:EventTrigger::EventPtr+2,x
        adc     #^EventScript
        sta     $ec
        lda     $e7                     ; enable world event script and ???
        ora     #$41
        sta     $e7
        stz     $ed                     ; clear event script offset
        stz     $ee
        lda     $e9
        ora     #$10
        sta     $e9
        lda     $e8
        ora     #$08
        sta     $e8
        bra     @21d5
@21cc:  inx5                            ; next trigger
        cpx     $5a
        bne     @218b
@21d5:  plp
        rts

; ------------------------------------------------------------------------------

; [ get tile properties (no vehicle) ]

; +x: horizontal offset (signed)
; +y: vertical offset (signed)

GetWorldTileProp:
        .a16
@21d7:  lda     f:$001f64               ; map index
        and     #$00ff
        xba
        asl
        sta     $64
        txa
        clc
        adc     $e0                     ; x position
        and     #$00ff
        sta     $58
        tya
        clc
        adc     $e2                     ; y position
        and     #$00ff
        xba
        clc
        adc     $58
        tax
        lda     $7f0000,x               ; tilemap
        and     #$00ff
        asl
        clc
        adc     $64
        tax
        lda     f:WorldTileProp,x       ; tile properties
        rts

; ------------------------------------------------------------------------------

; [ battle zoom and sound effect ]

BattleZoom:
@2208:  phb
        php
        shorta
        longi
        lda     #$80                    ; battle sound effect
        sta     hAPUIO2
        lda     #$c1
        sta     hAPUIO1
        lda     #$18
        sta     hAPUIO0
        lda     #$03
        sta     hTM
        stz     hTS
        ldx     #0
@2228:  lda     f:BattleZoomTbl,x       ; zoom level
        sta     $8c
        lda     f:BattleZoomTbl+1,x     ; screen brightness
        sta     hINIDISP
        phx
        jsr     UpdateMode7Vars
        longi
        plx
        shorta
@223e:  lda     $24                     ; wait for vblank
        beq     @223e
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
