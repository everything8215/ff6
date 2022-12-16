
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: ending_anim.asm                                                      |
; |                                                                            |
; | description: animation data for ending cutscenes                           |
; |                                                                            |
; | created: 9/5/2022                                                          |
; +----------------------------------------------------------------------------+

.segment "ending_anim1"

; ------------------------------------------------------------------------------

; credits mode 7 scrolling data (3 bytes each)
;   +$00: "buttons" pressed
;           axlrudlr by------
;             a: zoom in (move down)
;             x: increase tilt angle (pitch)
;             l: rotate left
;             r: rotate right
;             u: move forward
;             d: move backward
;             l: move left
;             r: move right
;             b: zoom out (move up)
;             y: decrease tilt angle (pitch)
;    $02: duration, $fe to terminate, $ff to repeat

; credits scene 2
@8a70:  .word   $0480
        .byte   $3c
        .word   $0490
        .byte   $3c
        .word   $0490
        .byte   $3c
        .word   $0410
        .byte   $1e
        .word   $0450
        .byte   $1e
        .word   $0440
        .byte   $1e
        .word   $04c0
        .byte   $3c
        .word   $0440
        .byte   $3c
        .word   $0400
        .byte   $3c
        .word   $8400
        .byte   $1e
        .word   $8410
        .byte   $1e
        .word   $0410
        .byte   $78
        .word   $0400
        .byte   $1e
        .word   $8400
        .byte   $3c
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $4400
        .byte   $1e
        .word   $c400
        .byte   $3c
        .word   $4400
        .byte   $3c
        .word   $0400
        .byte   $3c
        .word   $0500
        .byte   $3c
        .word   $0420
        .byte   $78
        .word   $0480
        .byte   $3c
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $fe

; unused ???
@8ac7:  .word   $0090
        .byte   $b4
        .word   $0410
        .byte   $b4
        .word   $0450
        .byte   $1e
        .word   $0440
        .byte   $b4
        .word   $0400
        .byte   $b4
        .word   $0400
        .byte   $fe

; credits scene 3
@8ad9:  .word   $08c0
        .byte   $3c
        .word   $08c0
        .byte   $3c
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0020
        .byte   $1e
        .word   $0440
        .byte   $1e
        .word   $0480
        .byte   $3c
        .word   $0220
        .byte   $61
        .word   $8200
        .byte   $46
        .word   $0200
        .byte   $fe

; credits scene 6
@8afa:  .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $0a
        .word   $0800
        .byte   $78
        .word   $08c0
        .byte   $5a
        .word   $0840
        .byte   $14
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0810
        .byte   $1e
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $b4
        .word   $0820
        .byte   $0a
        .word   $0860
        .byte   $1e
        .word   $0800
        .byte   $fe

; credits scene 4
@8b36:  .word   $0100
        .byte   $fe

; credits scene 5
@8b39:  .word   $0400
        .byte   $fe

; clouds 1
@8b3c:  .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $fe

; clouds 2
@8b42:  .word   $0890
        .byte   $fe

; ------------------------------------------------------------------------------

; book animation 2 ("and you")
@8b45:  .addr   $8b89
        .byte   $08
        .addr   $8b91
        .byte   $08
        .addr   $8b99
        .byte   $08
        .addr   $8ba1
        .byte   $08
        .addr   $8ba1
        .byte   $ff

; terminate book animation
@8b54:  .addr   $8b89
        .byte   $08
        .addr   $8b91
        .byte   $08
        .addr   $8b99
        .byte   $08
        .addr   $8ba9
        .byte   $08
        .addr   $8b81
        .byte   $fe

; book animation 1
@8b63:  .addr   $8b89
        .byte   $08
        .addr   $8b91
        .byte   $08
        .addr   $8b99
        .byte   $08
        .addr   $8ba1
        .byte   $08
        .addr   $8ba1
        .byte   $ff

; book animation (Strago's ending scene)
@8b72:  .addr   $8b89
        .byte   $08
        .addr   $8b91
        .byte   $08
        .addr   $8b99
        .byte   $08
        .addr   $8ba1
        .byte   $08
        .addr   $8ba1
        .byte   $ff

; book animation tile data
@8b81:  .byte   $1c,$00,$06,$00,$c8,$0b,$d9,$3a
@8b89:  .byte   $1c,$00,$06,$00,$e4,$0b,$d9,$3a
@8b91:  .byte   $1c,$00,$06,$00,$48,$0d,$d9,$3a
@8b99:  .byte   $1c,$00,$06,$00,$64,$0d,$d9,$3a
@8ba1:  .byte   $1c,$00,$06,$00,$c8,$0e,$d9,$3a
@8ba9:  .byte   $1c,$00,$06,$00,$e4,$0e,$d9,$3a

; ------------------------------------------------------------------------------

; airship going left
@8bb1:  .addr   $8bba
        .byte   $02
        .addr   $8bd3
        .byte   $02
        .addr   $8bd3
        .byte   $ff

@8bba:  .byte   6
        .byte   $80,$00,$0c,$32
        .byte   $90,$00,$0e,$32
        .byte   $80,$10,$20,$32
        .byte   $90,$10,$22,$32
        .byte   $08,$18,$6c,$32
        .byte   $18,$18,$7c,$32

@8bd3:  .byte   6
        .byte   $80,$00,$0c,$32
        .byte   $90,$00,$0e,$32
        .byte   $80,$10,$20,$32
        .byte   $90,$10,$22,$32
        .byte   $08,$18,$6d,$32
        .byte   $18,$18,$7d,$32

; ------------------------------------------------------------------------------

; water splash under airship
AirshipSplashAnim:
@8bec:  .addr   AirshipSplashSprite_00
        .byte   $2b
        .addr   AirshipSplashSprite_01
        .byte   $2b
        .addr   AirshipSplashSprite_02
        .byte   $2b
        .addr   AirshipSplashSprite_03
        .byte   $2b
        .addr   AirshipSplashSprite_02
        .byte   $2b
        .addr   AirshipSplashSprite_01
        .byte   $2b
        .addr   AirshipSplashSprite_00
        .byte   $ff

AirshipSplashSprite_00:
@8c01:  .byte   2
        .byte   $00,$00,$70,$32
        .byte   $08,$00,$71,$32

AirshipSplashSprite_01:
@8c0a:  .byte   2
        .byte   $00,$00,$72,$32
        .byte   $08,$00,$73,$32

AirshipSplashSprite_02:
@8c13:  .byte   2
        .byte   $00,$00,$74,$32
        .byte   $08,$00,$75,$32

AirshipSplashSprite_03:
@8c1c:  .byte   2
        .byte   $00,$00,$76,$32
        .byte   $08,$00,$77,$32

; ------------------------------------------------------------------------------

; airship going right
@8c25:  .addr   $8c2e
        .byte   $02
        .addr   $8c47
        .byte   $02
        .addr   $8c47
        .byte   $ff

@8c2e:  .byte   6
        .byte   $90,$00,$0c,$72
        .byte   $80,$00,$0e,$72
        .byte   $90,$10,$20,$72
        .byte   $80,$10,$22,$72
        .byte   $10,$18,$6c,$72
        .byte   $00,$18,$7c,$72

@8c47:  .byte   6
        .byte   $90,$00,$0c,$72
        .byte   $80,$00,$0e,$72
        .byte   $90,$10,$20,$72
        .byte   $80,$10,$22,$72
        .byte   $10,$18,$6d,$72
        .byte   $00,$18,$7d,$72

; ------------------------------------------------------------------------------

; big airship
BigAirshipAnim:
@8c60:  .addr   BigAirshipSprite
        .byte   $fe

BigAirshipSprite:
@8c63:  .byte   30
        .byte   $b0,$38,$00,$36
        .byte   $b0,$48,$02,$36
        .byte   $b0,$58,$04,$36
        .byte   $c0,$38,$00,$76
        .byte   $c0,$48,$02,$76
        .byte   $c0,$58,$04,$76
        .byte   $b0,$00,$c0,$70
        .byte   $a0,$00,$c2,$70
        .byte   $90,$00,$c4,$70
        .byte   $b0,$10,$c6,$70
        .byte   $a0,$10,$c8,$70
        .byte   $90,$10,$ca,$70
        .byte   $b0,$20,$cc,$70
        .byte   $a0,$20,$ce,$70
        .byte   $b0,$30,$e0,$70
        .byte   $28,$30,$e2,$70
        .byte   $90,$20,$e3,$70
        .byte   $88,$28,$e6,$70
        .byte   $c0,$00,$c0,$30
        .byte   $d0,$00,$c2,$30
        .byte   $e0,$00,$c4,$30
        .byte   $c0,$10,$c6,$30
        .byte   $d0,$10,$c8,$30
        .byte   $e0,$10,$ca,$30
        .byte   $c0,$20,$cc,$30
        .byte   $d0,$20,$ce,$30
        .byte   $c0,$30,$e0,$30
        .byte   $50,$30,$e2,$30
        .byte   $e0,$20,$e3,$30
        .byte   $e8,$28,$e6,$30

; ------------------------------------------------------------------------------

; tiny airship
TinyAirshipAnim:
@8cdc:  .addr   TinyAirshipSprite
        .byte   $fe

TinyAirshipSprite:
@8cdf:  .byte   4
        .byte   $00,$00,$08,$32
        .byte   $08,$00,$09,$32
        .byte   $00,$08,$18,$32
        .byte   $08,$08,$19,$32

TinyAirshipShadowAnim:
@8cf0:  .addr   TinyAirshipShadowSprite
        .byte   $01
        .addr   CreditsBlankSprite
        .byte   $01
        .addr   CreditsBlankSprite
        .byte   $ff

TinyAirshipShadowSprite:
@8cf9:  .byte   4
        .byte   $00,$00,$0a,$32
        .byte   $08,$00,$0b,$32
        .byte   $00,$08,$1a,$32
        .byte   $08,$08,$1b,$32

CreditsBlankSprite:
@8d0a:  .byte   0

; ------------------------------------------------------------------------------

; airship splash
@8d0b:  .addr   $8d1a
        .byte   $06
        .addr   $8d23
        .byte   $06
        .addr   $8d2c
        .byte   $06
        .addr   $8d35
        .byte   $06
        .addr   CreditsBlankSprite
        .byte   $fe

@8d1a:  .byte   2
        .byte   $80,$00,$40,$3e
        .byte   $90,$00,$42,$3e

@8d23:  .byte   2
        .byte   $80,$00,$44,$3e
        .byte   $90,$00,$46,$3e

@8d2c:  .byte   2
        .byte   $80,$00,$48,$3e
        .byte   $90,$00,$4a,$3e

@8d35:  .byte   2
        .byte   $80,$00,$4c,$3e
        .byte   $90,$00,$4e,$3e

; ------------------------------------------------------------------------------

; big airship propeller (left side, cw)
BigAirshipPropellerAnim1:
@8d3e:  .addr   $8d4d
        .byte   $01
        .addr   $8d5e
        .byte   $01
        .addr   $8d6f
        .byte   $01
        .addr   $8d80
        .byte   $01
        .addr   $8d80
        .byte   $ff

@8d4d:  .byte   4
        .byte   $80,$00,$80,$30
        .byte   $90,$00,$82,$30
        .byte   $80,$10,$a0,$30
        .byte   $90,$10,$a2,$30

@8d5e:  .byte   4
        .byte   $80,$00,$84,$30
        .byte   $90,$00,$86,$30
        .byte   $80,$10,$a4,$30
        .byte   $90,$10,$a6,$30

@8d6f:  .byte   4
        .byte   $80,$00,$88,$30
        .byte   $90,$00,$8a,$30
        .byte   $80,$10,$a8,$30
        .byte   $90,$10,$aa,$30

@8d80:  .byte   4
        .byte   $80,$00,$8c,$30
        .byte   $90,$00,$8e,$30
        .byte   $80,$10,$ac,$30
        .byte   $90,$10,$ae,$30

; ------------------------------------------------------------------------------

; big airship propeller (right side, ccw)

BigAirshipPropellerAnim2:
@8d91:  .addr   $8da0
        .byte   $01
        .addr   $8db1
        .byte   $01
        .addr   $8dc2
        .byte   $01
        .addr   $8dd3
        .byte   $01
        .addr   $8dd3
        .byte   $ff

@8da0:  .byte   4
        .byte   $90,$00,$80,$70
        .byte   $80,$00,$82,$70
        .byte   $90,$10,$a0,$70
        .byte   $80,$10,$a2,$70

@8db1:  .byte   4
        .byte   $90,$00,$84,$70
        .byte   $80,$00,$86,$70
        .byte   $90,$10,$a4,$70
        .byte   $80,$10,$a6,$70

@8dc2:  .byte   4
        .byte   $90,$00,$88,$70
        .byte   $80,$00,$8a,$70
        .byte   $90,$10,$a8,$70
        .byte   $80,$10,$aa,$70

@8dd3:  .byte   4
        .byte   $90,$00,$8c,$70
        .byte   $80,$00,$8e,$70
        .byte   $90,$10,$ac,$70
        .byte   $80,$10,$ae,$70

; ------------------------------------------------------------------------------

.macro def_ending_char_name_prop _anim_ptr1, _x1, _anim_ptr2, _x2,
        .addr   _anim_ptr1
        .byte   _x1
        .addr   _anim_ptr2
        .byte   _x2
.endmac

@8de4:  def_ending_char_name_prop $8e3b,$40,$8e3e,$00
        def_ending_char_name_prop $8e41,$4c,$8e44,$8c
        def_ending_char_name_prop $8e47,$38,$8e4a,$68
        def_ending_char_name_prop $8e4d,$60,$8e50,$00
        def_ending_char_name_prop $8e53,$30,$8e56,$98
        def_ending_char_name_prop $8e59,$2c,$8e5c,$90
        def_ending_char_name_prop $8e5f,$48,$8e62,$00
        def_ending_char_name_prop $8e65,$48,$8e68,$00
        def_ending_char_name_prop $8e6b,$48,$8e6e,$00
        def_ending_char_name_prop $8e71,$38,$8e74,$78
        def_ending_char_name_prop $8e77,$6c,$8e7a,$00
        def_ending_char_name_prop $8e7d,$6c,$8e80,$00
        def_ending_char_name_prop $8e83,$68,$8e86,$00
        def_ending_char_name_prop $8e89,$64,$8e8c,$00

@8e38:  .addr   $8e8f
        .byte   $fe
        .addr   $8e98
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $8f09
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $8f5b
        .byte   $fe
        .addr   $8f80
        .byte   $fe
        .addr   $8fcd
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $9002
        .byte   $fe
        .addr   $9053
        .byte   $fe
        .addr   $9088
        .byte   $fe
        .addr   $9053
        .byte   $fe
        .addr   $90d9
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $9132
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $9193
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $91f4
        .byte   $fe
        .addr   $9229
        .byte   $fe
        .addr   $926e
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $928b
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $92a8
        .byte   $fe
        .addr   $8f5a
        .byte   $fe
        .addr   $92cd
        .byte   $fe
        .addr   $8f5a
        .byte   $fe

@8e8f:  .byte   2
        .byte   $00,$00,$2a,$33
        .byte   $08,$00,$2b,$33

@8e98:  .byte   28
        .byte   $80,$00,$76,$31
        .byte   $00,$10,$2c,$31
        .byte   $08,$10,$2d,$31
        .byte   $10,$08,$04,$31
        .byte   $10,$10,$14,$31
        .byte   $18,$08,$21,$31
        .byte   $18,$10,$31,$31
        .byte   $20,$08,$21,$31
        .byte   $20,$10,$31,$31
        .byte   $28,$08,$00,$31
        .byte   $28,$10,$10,$31
        .byte   $b8,$00,$42,$31
        .byte   $38,$10,$62,$31
        .byte   $40,$10,$63,$31
        .byte   $48,$08,$21,$31
        .byte   $48,$10,$31,$31
        .byte   $50,$08,$00,$31
        .byte   $50,$10,$10,$31
        .byte   $58,$08,$0d,$31
        .byte   $58,$10,$1d,$31
        .byte   $60,$08,$05,$31
        .byte   $60,$10,$15,$31
        .byte   $68,$08,$0e,$31
        .byte   $68,$10,$1e,$31
        .byte   $70,$08,$21,$31
        .byte   $70,$10,$31,$31
        .byte   $78,$08,$03,$31
        .byte   $78,$10,$13,$31

@8f09:  .byte   20
        .byte   $80,$00,$4e,$31
        .byte   $00,$10,$6e,$31
        .byte   $08,$10,$6f,$31
        .byte   $10,$08,$0e,$31
        .byte   $10,$10,$1e,$31
        .byte   $18,$08,$02,$31
        .byte   $18,$10,$12,$31
        .byte   $20,$08,$0a,$31
        .byte   $20,$10,$1a,$31
        .byte   $28,$08,$04,$31
        .byte   $28,$10,$14,$31
        .byte   $b8,$00,$44,$31
        .byte   $38,$10,$64,$31
        .byte   $40,$10,$65,$31
        .byte   $48,$08,$0e,$31
        .byte   $48,$10,$1e,$31
        .byte   $50,$08,$0b,$31
        .byte   $50,$10,$1b,$31
        .byte   $58,$08,$04,$31
        .byte   $58,$10,$14,$31

@8f5a:  .byte   0

@8f5b:  .byte   9
        .byte   $80,$00,$44,$31
        .byte   $00,$10,$64,$31
        .byte   $08,$10,$65,$31
        .byte   $10,$08,$28,$31
        .byte   $10,$10,$38,$31
        .byte   $18,$08,$00,$31
        .byte   $18,$10,$10,$31
        .byte   $20,$08,$0d,$31
        .byte   $20,$10,$1d,$31

@8f80:  .byte   19
        .byte   $80,$00,$4c,$31
        .byte   $00,$10,$6c,$31
        .byte   $08,$10,$6d,$31
        .byte   $10,$08,$00,$31
        .byte   $10,$10,$10,$31
        .byte   $18,$08,$21,$31
        .byte   $18,$10,$31,$31
        .byte   $20,$08,$00,$31
        .byte   $20,$10,$10,$31
        .byte   $28,$08,$0c,$31
        .byte   $28,$10,$1c,$31
        .byte   $30,$08,$0e,$31
        .byte   $30,$10,$1e,$31
        .byte   $38,$08,$0d,$31
        .byte   $38,$10,$1d,$31
        .byte   $40,$08,$03,$31
        .byte   $40,$10,$13,$31
        .byte   $48,$08,$04,$31
        .byte   $48,$10,$14,$31

@8fcd:  .byte   13
        .byte   $80,$00,$74,$31
        .byte   $00,$10,$3e,$31
        .byte   $08,$10,$3f,$31
        .byte   $10,$08,$07,$31
        .byte   $10,$10,$17,$31
        .byte   $18,$08,$00,$31
        .byte   $18,$10,$10,$31
        .byte   $20,$08,$03,$31
        .byte   $20,$10,$13,$31
        .byte   $28,$08,$0e,$31
        .byte   $28,$10,$1e,$31
        .byte   $30,$08,$26,$31
        .byte   $30,$10,$36,$31

@9002:  .byte   20
        .byte   $80,$00,$48,$31
        .byte   $00,$10,$68,$31
        .byte   $08,$10,$69,$31
        .byte   $10,$08,$03,$31
        .byte   $10,$10,$13,$31
        .byte   $18,$08,$06,$31
        .byte   $18,$10,$16,$31
        .byte   $20,$08,$00,$31
        .byte   $20,$10,$10,$31
        .byte   $28,$08,$21,$31
        .byte   $28,$10,$31,$31
        .byte   $b8,$00,$72,$31
        .byte   $38,$10,$3c,$31
        .byte   $40,$10,$3d,$31
        .byte   $48,$08,$0e,$31
        .byte   $48,$10,$1e,$31
        .byte   $50,$08,$0d,$31
        .byte   $50,$10,$1d,$31
        .byte   $58,$08,$08,$31
        .byte   $58,$10,$18,$31

@9053:  .byte   13
        .byte   $80,$00,$4a,$31
        .byte   $00,$10,$6a,$31
        .byte   $08,$10,$6b,$31
        .byte   $10,$08,$08,$31
        .byte   $10,$10,$18,$31
        .byte   $18,$08,$06,$31
        .byte   $18,$10,$16,$31
        .byte   $20,$08,$00,$31
        .byte   $20,$10,$10,$31
        .byte   $28,$08,$21,$31
        .byte   $28,$10,$31,$31
        .byte   $30,$08,$0e,$31
        .byte   $30,$10,$1e,$31

@9088:  .byte   20
        .byte   $80,$00,$74,$31
        .byte   $00,$10,$3e,$31
        .byte   $08,$10,$3f,$31
        .byte   $10,$08,$00,$31
        .byte   $10,$10,$10,$31
        .byte   $18,$08,$01,$31
        .byte   $18,$10,$11,$31
        .byte   $20,$08,$08,$31
        .byte   $20,$10,$18,$31
        .byte   $28,$08,$0d,$31
        .byte   $28,$10,$1d,$31
        .byte   $b8,$00,$72,$31
        .byte   $38,$10,$3c,$31
        .byte   $40,$10,$3d,$31
        .byte   $48,$08,$04,$31
        .byte   $48,$10,$14,$31
        .byte   $50,$08,$0d,$31
        .byte   $50,$10,$1d,$31
        .byte   $58,$08,$04,$31
        .byte   $58,$10,$14,$31

@90d9:  .byte   22
        .byte   $80,$00,$44,$31
        .byte   $00,$10,$64,$31
        .byte   $08,$10,$65,$31
        .byte   $10,$08,$04,$31
        .byte   $10,$10,$14,$31
        .byte   $18,$08,$0b,$31
        .byte   $18,$10,$1b,$31
        .byte   $20,$08,$04,$31
        .byte   $20,$10,$14,$31
        .byte   $28,$08,$22,$31
        .byte   $28,$10,$32,$31
        .byte   $b8,$00,$44,$31
        .byte   $38,$10,$64,$31
        .byte   $40,$10,$65,$31
        .byte   $48,$08,$07,$31
        .byte   $48,$10,$17,$31
        .byte   $50,$08,$04,$31
        .byte   $50,$10,$14,$31
        .byte   $58,$08,$21,$31
        .byte   $58,$10,$31,$31
        .byte   $60,$08,$04,$31
        .byte   $60,$10,$14,$31

@9132:  .byte   24
        .byte   $80,$00,$74,$31
        .byte   $00,$10,$3e,$31
        .byte   $08,$10,$3f,$31
        .byte   $10,$08,$23,$31
        .byte   $10,$10,$33,$31
        .byte   $18,$08,$21,$31
        .byte   $18,$10,$31,$31
        .byte   $20,$08,$00,$31
        .byte   $20,$10,$10,$31
        .byte   $28,$08,$06,$31
        .byte   $28,$10,$16,$31
        .byte   $30,$08,$0e,$31
        .byte   $30,$10,$1e,$31
        .byte   $c0,$00,$70,$31
        .byte   $40,$10,$3a,$31
        .byte   $48,$10,$3b,$31
        .byte   $50,$08,$00,$31
        .byte   $50,$10,$10,$31
        .byte   $58,$08,$06,$31
        .byte   $58,$10,$16,$31
        .byte   $60,$08,$24,$31
        .byte   $60,$10,$34,$31
        .byte   $68,$08,$22,$31
        .byte   $68,$10,$32,$31

@9193:  .byte   24
        .byte   $80,$00,$72,$31
        .byte   $00,$10,$3c,$31
        .byte   $08,$10,$3d,$31
        .byte   $10,$08,$04,$31
        .byte   $10,$10,$14,$31
        .byte   $18,$08,$0b,$31
        .byte   $18,$10,$1b,$31
        .byte   $20,$08,$0c,$31
        .byte   $20,$10,$1c,$31
        .byte   $b0,$00,$40,$31
        .byte   $30,$10,$60,$31
        .byte   $38,$10,$61,$31
        .byte   $40,$08,$21,$31
        .byte   $40,$10,$31,$31
        .byte   $48,$08,$21,$31
        .byte   $48,$10,$31,$31
        .byte   $50,$08,$0e,$31
        .byte   $50,$10,$1e,$31
        .byte   $58,$08,$26,$31
        .byte   $58,$10,$36,$31
        .byte   $60,$08,$0d,$31
        .byte   $60,$10,$1d,$31
        .byte   $68,$08,$28,$31
        .byte   $68,$10,$38,$31

@91f4:  .byte   13
        .byte   $80,$00,$74,$31
        .byte   $00,$10,$3e,$31
        .byte   $08,$10,$3f,$31
        .byte   $10,$08,$04,$31
        .byte   $10,$10,$14,$31
        .byte   $18,$08,$23,$31
        .byte   $18,$10,$33,$31
        .byte   $20,$08,$29,$31
        .byte   $20,$10,$39,$31
        .byte   $28,$08,$04,$31
        .byte   $28,$10,$14,$31
        .byte   $30,$08,$21,$31
        .byte   $30,$10,$31,$31

@9229:  .byte   17
        .byte   $80,$00,$4c,$31
        .byte   $00,$10,$6c,$31
        .byte   $08,$10,$6d,$31
        .byte   $10,$08,$00,$31
        .byte   $10,$10,$10,$31
        .byte   $18,$08,$01,$31
        .byte   $18,$10,$11,$31
        .byte   $20,$08,$01,$31
        .byte   $20,$10,$11,$31
        .byte   $28,$08,$08,$31
        .byte   $28,$10,$18,$31
        .byte   $30,$08,$00,$31
        .byte   $30,$10,$10,$31
        .byte   $38,$08,$0d,$31
        .byte   $38,$10,$1d,$31
        .byte   $40,$08,$08,$31
        .byte   $40,$10,$18,$31

@926e:  .byte   7
        .byte   $80,$00,$70,$31
        .byte   $00,$10,$3a,$31
        .byte   $08,$10,$3b,$31
        .byte   $10,$08,$0e,$31
        .byte   $10,$10,$1e,$31
        .byte   $18,$08,$06,$31
        .byte   $18,$10,$16,$31

@928b:  .byte   7
        .byte   $80,$00,$4c,$31
        .byte   $00,$10,$6c,$31
        .byte   $08,$10,$6d,$31
        .byte   $10,$08,$00,$31
        .byte   $10,$10,$10,$31
        .byte   $18,$08,$24,$31
        .byte   $18,$10,$34,$31

@92a8:  .byte   9
        .byte   $80,$00,$4c,$31
        .byte   $00,$10,$6c,$31
        .byte   $08,$10,$6d,$31
        .byte   $10,$08,$0e,$31
        .byte   $10,$10,$1e,$31
        .byte   $18,$08,$06,$31
        .byte   $18,$10,$16,$31
        .byte   $20,$08,$0e,$31
        .byte   $20,$10,$1e,$31

@92cd:  .byte   11
        .byte   $80,$00,$78,$31
        .byte   $00,$10,$2e,$31
        .byte   $08,$10,$2f,$31
        .byte   $10,$08,$0c,$31
        .byte   $10,$10,$1c,$31
        .byte   $18,$08,$00,$31
        .byte   $18,$10,$10,$31
        .byte   $20,$08,$21,$31
        .byte   $20,$10,$31,$31
        .byte   $28,$08,$0e,$31
        .byte   $28,$10,$1e,$31

; ------------------------------------------------------------------------------

; sprite data at c2/93f7, show for 6 frames (0.1s)
@92fa:  .addr   $93f7
        .byte   6
        .addr   $9482
        .byte   6
        .addr   $93c6
        .byte   6
        .addr   $938d
        .byte   6
        .addr   $9354
        .byte   6
        .addr   $9327
        .byte   6
        .addr   $9354
        .byte   6
        .addr   $938d
        .byte   6
        .addr   $93c6
        .byte   6
        .addr   $9482
        .byte   6
        .addr   $93f7
        .byte   6
        .addr   $9420
        .byte   6
        .addr   $9461
        .byte   12
        .addr   $9420
        .byte   6
        .addr   $9420
        .byte   $ff                      ; ff means repeat (fe means terminate)

@9327:  .byte   11                           ; 11 sprites
        .byte   $10,$00,$02,$34                  ; x=10, y=0, m=2, pal=2, priority=3, no flip
        .byte   $98,$00,$03,$34                  ; msb set means 16x16 sprite
        .byte   $88,$08,$11,$34
        .byte   $98,$10,$23,$34
        .byte   $28,$08,$15,$34
        .byte   $00,$18,$30,$34
        .byte   $08,$18,$31,$34
        .byte   $10,$18,$32,$34
        .byte   $08,$20,$01,$34
        .byte   $10,$20,$05,$34
        .byte   $18,$20,$06,$34

@9354:  .byte   14
        .byte   $10,$00,$07,$34
        .byte   $08,$08,$16,$34
        .byte   $10,$08,$17,$34
        .byte   $88,$10,$26,$34
        .byte   $00,$18,$35,$34
        .byte   $08,$20,$09,$34
        .byte   $10,$20,$0c,$34
        .byte   $18,$20,$07,$f4
        .byte   $20,$18,$16,$f4
        .byte   $18,$18,$17,$f4
        .byte   $98,$08,$26,$f4
        .byte   $28,$08,$35,$f4
        .byte   $20,$00,$09,$f4
        .byte   $18,$00,$0c,$f4

@938d:  .byte   14
        .byte   $18,$00,$08,$34
        .byte   $18,$08,$18,$34
        .byte   $20,$08,$19,$34
        .byte   $18,$10,$28,$34
        .byte   $20,$10,$29,$34
        .byte   $18,$18,$38,$34
        .byte   $18,$20,$20,$34
        .byte   $10,$20,$08,$f4
        .byte   $10,$18,$18,$f4
        .byte   $08,$18,$19,$f4
        .byte   $10,$10,$28,$f4
        .byte   $08,$10,$29,$f4
        .byte   $10,$08,$38,$f4
        .byte   $10,$00,$20,$f4

@93c6:  .byte   12
        .byte   $10,$00,$0a,$34
        .byte   $10,$08,$1a,$34
        .byte   $10,$10,$2a,$34
        .byte   $08,$18,$39,$34
        .byte   $10,$18,$3a,$34
        .byte   $10,$20,$25,$34
        .byte   $18,$20,$0a,$f4
        .byte   $18,$18,$1a,$f4
        .byte   $18,$10,$2a,$f4
        .byte   $20,$08,$39,$f4
        .byte   $18,$08,$3a,$f4
        .byte   $18,$00,$25,$f4

@93f7:  .byte   10
        .byte   $18,$00,$0b,$34
        .byte   $18,$08,$1b,$34
        .byte   $18,$10,$2b,$34
        .byte   $18,$18,$3b,$34
        .byte   $18,$20,$1c,$34
        .byte   $10,$20,$0b,$f4
        .byte   $10,$18,$1b,$f4
        .byte   $10,$10,$2b,$f4
        .byte   $10,$08,$3b,$f4
        .byte   $10,$00,$1c,$f4

@9420:  .byte   16
        .byte   $10,$00,$0d,$34
        .byte   $10,$08,$1d,$34
        .byte   $08,$10,$2c,$34
        .byte   $10,$10,$2d,$34
        .byte   $08,$18,$3c,$34
        .byte   $10,$18,$3d,$34
        .byte   $08,$20,$40,$34
        .byte   $10,$20,$41,$34
        .byte   $18,$20,$0d,$f4
        .byte   $18,$18,$1d,$f4
        .byte   $20,$10,$2c,$f4
        .byte   $18,$10,$2d,$f4
        .byte   $20,$08,$3c,$f4
        .byte   $18,$08,$3d,$f4
        .byte   $20,$00,$40,$f4
        .byte   $18,$00,$41,$f4

@9461:  .byte   8
        .byte   $98,$00,$0e,$34
        .byte   $98,$10,$2e,$34
        .byte   $28,$08,$43,$34
        .byte   $18,$20,$42,$34
        .byte   $88,$18,$0e,$f4
        .byte   $88,$08,$2e,$f4
        .byte   $00,$18,$43,$f4
        .byte   $10,$00,$42,$f4

@9482:  .byte   5
        .byte   $12,$00,$00,$34
        .byte   $12,$08,$10,$34
        .byte   $12,$10,$10,$34
        .byte   $12,$18,$10,$34
        .byte   $12,$20,$10,$34

; ------------------------------------------------------------------------------

; shadow apple animation data

@9497:  .addr   $94a9
        .byte   $b4
        .addr   $94a9
        .byte   $b4
        .addr   $94a9
        .byte   $b4
        .addr   $94ca
        .byte   $10
        .addr   $94f7
        .byte   $40
        .addr   $94f7
        .byte   $fe

@94a9:  .byte   8
        .byte   $80,$08,$00,$38
        .byte   $10,$08,$02,$38
        .byte   $10,$10,$12,$38
        .byte   $18,$10,$13,$38
        .byte   $80,$18,$04,$38
        .byte   $10,$18,$06,$38
        .byte   $10,$20,$16,$38
        .byte   $18,$18,$03,$38

@94ca:  .byte   11
        .byte   $80,$08,$00,$38
        .byte   $90,$00,$07,$38
        .byte   $10,$10,$12,$38
        .byte   $80,$18,$04,$38
        .byte   $10,$18,$06,$38
        .byte   $10,$20,$16,$38
        .byte   $18,$18,$03,$38
        .byte   $20,$00,$09,$38
        .byte   $20,$08,$19,$38
        .byte   $18,$10,$0a,$38
        .byte   $20,$10,$0b,$38

@94f7:
        .byte   17
        .byte   $00,$08,$00,$38
        .byte   $08,$08,$01,$38
        .byte   $00,$10,$10,$38
        .byte   $80,$18,$04,$38
        .byte   $10,$18,$06,$38
        .byte   $10,$20,$16,$38
        .byte   $18,$18,$03,$38
        .byte   $08,$10,$1a,$38
        .byte   $10,$10,$1b,$38
        .byte   $10,$00,$0c,$38
        .byte   $18,$00,$0d,$38
        .byte   $10,$08,$0e,$38
        .byte   $18,$08,$0f,$38
        .byte   $20,$00,$09,$38
        .byte   $20,$08,$19,$38
        .byte   $18,$10,$0a,$38
        .byte   $20,$10,$0b,$38

; ------------------------------------------------------------------------------

; credits palettes

@953c:  .word   $18c6,$664d,$6a6e,$6a90,$6ab1,$6ed2,$6ef3,$7315
        .word   $7336,$7337,$7758,$777a,$779b,$7bbc,$7bdd,$7fff

@955c:  .word   $0000,$5f5f,$4d38,$2492,$188e,$0c68,$0c45,$0000
        .word   $0000,$0423,$0423,$0423,$0423,$0423,$0423,$0423

@957c:  .word   $0000,$0c45,$0c68,$188e,$2492,$4d38,$5f5f,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

@959c:  .word   $59ea,$7fff,$5f7b,$46b6,$3211,$258d,$2129,$1ce6
        .word   $18a2,$375b,$0e34,$016d,$77bd,$66f7,$5e72,$59ea

@95bc:  .word   $0000,$7fff,$5f7b,$46b6,$3211,$258d,$2129,$1ce6
        .word   $18a2,$375b,$0e34,$016d,$77bd,$66f7,$5e72,$59ea

@95dc:  .word   $0000,$0864,$1991,$10eb,$0c87,$3653,$298e,$67ff
        .word   $169c,$6713,$664c,$4941,$30c1,$2482,$1c61,$1861

@95fc:  .word   $0000,$7bde,$77be,$77bd,$739c,$737c,$6f5a,$6b39
        .word   $66f7,$5e93,$5daa,$5d46,$0000,$0000,$0000,$7fff

@961c:  .word   $0000,$2e0f,$25cc,$25cb,$21aa,$2189,$1948,$1947
        .word   $10e5,$110c,$3a90,$3a6f,$364f,$324e,$322d,$2e0f

@963c:  .word   $0000,$5e8f,$4941,$30c1,$2482,$1c61,$31d2,$296f
        .word   $18ea,$25cc,$21aa,$3a6f,$364f,$324e,$322d,$2e0f

@965c:  .word   $0000,$4699,$4257,$3e36,$3a15,$35f4,$31d2,$296f
        .word   $18ea,$25cc,$3a90,$3a6f,$364f,$324e,$322d,$2e0f

@967c:  .word   $0000,$571c,$3a35,$2590,$150c,$08a8,$0466,$0000
        .word   $3800,$3800,$3800,$3800,$3800,$3800,$3800,$3800

@969c:  .word   $0000,$571c,$4698,$3614,$2dd2,$216f,$1d4e,$192d
        .word   $10eb,$0cc9,$08a8,$0887,$0866,$0445,$0423,$0000

@96bc:  .word   $0000,$571c,$571c,$3614,$3614,$216f,$216f,$192d
        .word   $10eb,$10eb,$0887,$0887,$0445,$0423,$0423,$0000

@96dc:  .word   $0000,$571c,$4698,$3614,$2dd2,$2590,$150c,$08a8
        .word   $3800,$3800,$3800,$3800,$3800,$3800,$3800,$3800

@96fc:  .word   $0000,$4a52,$3def,$2d6b,$2529,$18c6,$0863,$0020
        .word   $3800,$3800,$3800,$3800,$3800,$3800,$3800,$3800

@971c:  .word   $0000,$571c,$4698,$3614,$2dd2,$2590,$2590,$150c
        .word   $150c,$08a8,$08a8,$08a8,$08a8,$08a8,$08a8,$08a8

@973c:  .word   $0000,$18c7,$16fe,$16fe

@9744:  .word   $0000,$16fe,$225a,$18c7

@974c:  .word   $0000,$c460,$0000,$7fff

@9754:  .word   $0000,$7fff,$56b4,$4c60,$0000,$7fff,$4c60,$7fff
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

@9774:  .word   $0000,$571c,$4698,$3614,$2dd2,$216f,$1d4e,$150c
        .word   $10eb,$0cc9,$08a8,$0887,$0866,$0445,$0423,$0000

@9794:  .word   $0000,$7fff,$639c,$46b6,$3211,$218d,$1929,$1ce8
        .word   $1cc6,$18a4,$1082,$0000,$0000,$0000,$0422,$6293

@97b4:  .word   $0000,$0864,$1991,$10eb,$0c87,$3653,$298e,$67ff
        .word   $169c,$6713,$664c,$4941,$7c1f,$7c1f,$1c61,$7c1f

@97d4:  .word   $0000,$3631,$31ef,$298c,$1991,$192d,$14ea,$10a7
        .word   $0c85,$0864,$375b,$0e34,$016d,$7c1f,$7c1f,$0843

@97f4:  .word   $0000,$779c,$639b,$46b5,$3631,$31ef,$298c,$1d29
        .word   $18e7,$14a6,$0c65,$0c44,$1991,$10eb,$0c87,$7c1f

@9814:  .word   $0000,$7fff,$6718,$4e30,$3549,$1c61,$2926,$2926
        .word   $2926,$2926,$2926,$2926,$2926,$2926,$2926,$2926

@9834:  .word   $0002,$0864,$1991,$10eb,$0c87,$7fff,$6af6,$460d
        .word   $2d67,$6736,$4e4f,$3548,$14e4,$7c1f,$1c61,$7c1f

; ------------------------------------------------------------------------------

_c29854:
@9854:  .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $10,$11,$12,$13,$14,$15,$16,$17
        .byte   $08,$09,$0a,$0b,$0c,$0d,$0e,$0f
        .byte   $18,$19,$1a,$1b,$1c,$1d,$1e,$1f
        .byte   $20,$21,$22,$23,$24,$25,$26,$27
        .byte   $30,$31,$32,$33,$34,$35,$36,$37
        .byte   $28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        .byte   $38,$39,$3a,$3b,$3c,$3d,$3e,$3f

; ------------------------------------------------------------------------------

; credits text sprite data (4 bytes each)
;   +$00: text location in wram buffer (+$7e0000)
;    $02: x position
;    $03: y position

.macro def_credits_sprite _buf_ptr, _x, _y
        .addr   _buf_ptr
        .byte   _x, _y
.endmac

; scene 1

.proc CreditsSpritesScene1Page1
@9894:  def_credits_sprite $9d89,$60,$88  ; producer
        def_credits_sprite $9dcf,$38,$98  ; hironobu
        def_credits_sprite $9e15,$80,$98  ; sakaguchi
.endproc

; scene 2

.proc CreditsSpritesScene2Page1
@98a0:  def_credits_sprite $9d89,$60,$88
        def_credits_sprite $9f2d,$40,$98
        def_credits_sprite $9f73,$90,$98
        def_credits_sprite $9fb9,$4c,$ac
        def_credits_sprite $9fff,$94,$ac
.endproc

.proc CreditsSpritesScene2Page2
@98b4:  def_credits_sprite $9dcf,$44,$88
        def_credits_sprite $9e15,$6c,$88
        def_credits_sprite $a045,$58,$98
        def_credits_sprite $a08b,$78,$98
        def_credits_sprite $a0d1,$48,$ac
        def_credits_sprite $a117,$88,$ac
.endproc

.proc CreditsSpritesScene2Page3
@98cc:  def_credits_sprite $9e5b,$40,$88
        def_credits_sprite $9ea1,$80,$88
        def_credits_sprite $a15d,$3c,$98
        def_credits_sprite $a1a3,$7c,$98
        def_credits_sprite $a1e9,$48,$ac
        def_credits_sprite $a22f,$80,$ac
.endproc

.proc CreditsSpritesScene2Page4
@98e4:  def_credits_sprite $9e5b,$40,$88
        def_credits_sprite $9ea1,$80,$88
        def_credits_sprite $a275,$50,$98
        def_credits_sprite $a2bb,$80,$98
        def_credits_sprite $a301,$48,$ac
        def_credits_sprite $a347,$88,$ac
.endproc

.proc CreditsSpritesScene2Page5
@98fc:  def_credits_sprite $9ee7,$6c,$88
        def_credits_sprite $a38d,$4c,$98
        def_credits_sprite $a3d3,$7c,$98
.endproc

.proc CreditsSpritesScene2Page6
@9908:  def_credits_sprite $a5bd,$50,$88
        def_credits_sprite $a603,$80,$88
        def_credits_sprite $a419,$44,$98
        def_credits_sprite $a45f,$94,$98
.endproc

.proc CreditsSpritesScene2Page7
@9918:  def_credits_sprite $a649,$48,$88
        def_credits_sprite $a68f,$80,$88
        def_credits_sprite $a4a5,$44,$98
        def_credits_sprite $a4eb,$8c,$98
        def_credits_sprite $a531,$4c,$ac
        def_credits_sprite $a577,$94,$ac
.endproc

; scene 3

.proc CreditsSpritesScene3Page1
@9930:  def_credits_sprite $9ea1,$4c,$88
        def_credits_sprite $9dcf,$7c,$88
        def_credits_sprite $9ee7,$3c,$98
        def_credits_sprite $9f2d,$8c,$98
        def_credits_sprite $9f73,$58,$ac
        def_credits_sprite $9fb9,$88,$ac
        def_credits_sprite $9fff,$50,$c0
        def_credits_sprite $a045,$88,$c0
.endproc

.proc CreditsSpritesScene3Page2
@9950:
        def_credits_sprite $9d89,$4c,$88
        def_credits_sprite $9dcf,$7c,$88
        def_credits_sprite $a08b,$48,$98
        def_credits_sprite $a0d1,$88,$98
        def_credits_sprite $a117,$3c,$ac
        def_credits_sprite $a15d,$7c,$ac
.endproc

.proc CreditsSpritesScene3Page3
@9968:
        def_credits_sprite $9e15,$3c,$88
        def_credits_sprite $9e5b,$74,$88
        def_credits_sprite $a1a3,$48,$98
        def_credits_sprite $a1e9,$88,$98
        def_credits_sprite $a22f,$4c,$ac
        def_credits_sprite $a275,$8c,$ac
.endproc

.proc CreditsSpritesScene3Page4
@9980:
        def_credits_sprite $a68f,$3c,$88
        def_credits_sprite $9e5b,$74,$88
        def_credits_sprite $a2bb,$3c,$98
        def_credits_sprite $a301,$7c,$98
.endproc

; scene 4

.proc CreditsSpritesScene4Page1
@9990:  def_credits_sprite $9d89,$40,$88
        def_credits_sprite $9dcf,$70,$88
        def_credits_sprite $9fb9,$54,$98
        def_credits_sprite $9fff,$8c,$98
.endproc

.proc CreditsSpritesScene4Page2
@99a0:  def_credits_sprite $9e15,$24,$88
        def_credits_sprite $9e5b,$5c,$88
        def_credits_sprite $9ea1,$9c,$88
        def_credits_sprite $a045,$40,$98
        def_credits_sprite $a08b,$90,$98
.endproc

.proc CreditsSpritesScene4Page3
@99b4:  def_credits_sprite $9ee7,$28,$88
        def_credits_sprite $9e5b,$58,$88
        def_credits_sprite $9ea1,$98,$88
        def_credits_sprite $a0d1,$44,$98
        def_credits_sprite $a117,$8c,$98
        def_credits_sprite $a15d,$4c,$ac
        def_credits_sprite $a1a3,$8c,$ac
        def_credits_sprite $a1e9,$48,$c0
        def_credits_sprite $a22f,$90,$c0
.endproc

.proc CreditsSpritesScene4Page4
@99d8:  def_credits_sprite $9ee7,$28,$88
        def_credits_sprite $9e5b,$58,$88
        def_credits_sprite $9ea1,$98,$88
        def_credits_sprite $a275,$4c,$98
        def_credits_sprite $a2bb,$7c,$98
        def_credits_sprite $a301,$50,$ac
        def_credits_sprite $a347,$80,$ac
        def_credits_sprite $a38d,$3c,$c0
        def_credits_sprite $a3d3,$8c,$c0
.endproc

.proc CreditsSpritesScene4Page5
@99fc:  def_credits_sprite $9ee7,$28,$88
        def_credits_sprite $9e5b,$58,$88
        def_credits_sprite $9ea1,$98,$88
        def_credits_sprite $a531,$38,$98
        def_credits_sprite $a45f,$88,$98
        def_credits_sprite $a4a5,$44,$ac
        def_credits_sprite $a4eb,$8c,$ac
        def_credits_sprite $a419,$40,$c0
        def_credits_sprite $a5bd,$90,$c0
.endproc

.proc CreditsSpritesScene4Page6
@9a20:  def_credits_sprite $9f2d,$1c,$88
        def_credits_sprite $9e5b,$5c,$88
        def_credits_sprite $9ea1,$9c,$88
        def_credits_sprite $a603,$48,$98
        def_credits_sprite $a08b,$88,$98
.endproc

.proc CreditsSpritesScene4Page7
@9a34:  def_credits_sprite $9f73,$24,$88
        def_credits_sprite $9e5b,$5c,$88
        def_credits_sprite $9ea1,$9c,$88
        def_credits_sprite $a649,$44,$98
        def_credits_sprite $a68f,$8c,$98
.endproc

; scene 5

.proc CreditsSpritesScene5Page1
@9a48:  def_credits_sprite $9d89,$48,$88
        def_credits_sprite $9dcf,$78,$88
        def_credits_sprite $9fb9,$4c,$98
        def_credits_sprite $9fff,$74,$98
.endproc

.proc CreditsSpritesScene5Page2
@9a58:  def_credits_sprite $9d89,$50,$88
        def_credits_sprite $9e15,$80,$88
        def_credits_sprite $a045,$4c,$98
        def_credits_sprite $a08b,$84,$98
        def_credits_sprite $a0d1,$40,$ac
        def_credits_sprite $a117,$90,$ac
.endproc

.proc CreditsSpritesScene5Page3
@9a70:  def_credits_sprite $9d89,$50,$88
        def_credits_sprite $9e15,$80,$88
        def_credits_sprite $a15d,$40,$98
        def_credits_sprite $a1a3,$88,$98
        def_credits_sprite $a1e9,$54,$ac
        def_credits_sprite $a22f,$7c,$ac
.endproc

.proc CreditsSpritesScene5Page4
@9a88:  def_credits_sprite $9e5b,$48,$88
        def_credits_sprite $9ea1,$80,$88
        def_credits_sprite $a275,$5c,$94
        def_credits_sprite $a2bb,$94,$94
        def_credits_sprite $a301,$60,$a8
        def_credits_sprite $a347,$88,$a8
        def_credits_sprite $a7ed,$58,$bc
        def_credits_sprite $a761,$54,$c8
        def_credits_sprite $a7a7,$74,$c8
.endproc

.proc CreditsSpritesScene5Page5
@9aac:  def_credits_sprite $9ee7,$44,$88
        def_credits_sprite $9dcf,$7c,$88
        def_credits_sprite $a38d,$3c,$98
        def_credits_sprite $a3d3,$84,$98
        def_credits_sprite $a419,$50,$ac
        def_credits_sprite $a45f,$88,$ac
.endproc

.proc CreditsSpritesScene5Page6
@9ac4:  def_credits_sprite $9ee7,$44,$88
        def_credits_sprite $9dcf,$7c,$88
        def_credits_sprite $a4a5,$40,$98
        def_credits_sprite $a4eb,$88,$98
        def_credits_sprite $a531,$48,$ac
        def_credits_sprite $a577,$80,$ac
.endproc

.proc CreditsSpritesScene5Page7
@9adc:  def_credits_sprite $9f2d,$38,$88
        def_credits_sprite $9f73,$88,$88
        def_credits_sprite $a649,$4c,$98
        def_credits_sprite $a68f,$84,$98
        def_credits_sprite $a6d5,$40,$ac
        def_credits_sprite $a71b,$80,$ac
.endproc

; scene 6

.proc CreditsSpritesScene6Page1
@9af4:  def_credits_sprite $9d89,$40,$40
        def_credits_sprite $9dcf,$68,$40
        def_credits_sprite $9f73,$60,$54
        def_credits_sprite $9fb9,$60,$60
        def_credits_sprite $9fff,$60,$6c
        def_credits_sprite $a045,$60,$78
        def_credits_sprite $a08b,$60,$84
        def_credits_sprite $a0d1,$60,$90
        def_credits_sprite $a117,$60,$9c
        def_credits_sprite $a15d,$60,$a8
.endproc

.proc CreditsSpritesScene6Page2
@9b1c:  def_credits_sprite $9e15,$3c,$40
        def_credits_sprite $9e5b,$7c,$40
        def_credits_sprite $9ea1,$b4,$40
        def_credits_sprite $a1a3,$60,$54
        def_credits_sprite $a1e9,$60,$60
        def_credits_sprite $a22f,$60,$6c
        def_credits_sprite $a991,$60,$84
        def_credits_sprite $b139,$60,$90
        def_credits_sprite $b17f,$60,$9c
        def_credits_sprite $b1c5,$60,$a8
.endproc

.proc CreditsSpritesScene6Page3
@9b44:  def_credits_sprite $a275,$60,$54
        def_credits_sprite $a2bb,$60,$60
        def_credits_sprite $a301,$60,$6c
        def_credits_sprite $a347,$60,$78
        def_credits_sprite $a38d,$60,$84
        def_credits_sprite $a3d3,$60,$90
        def_credits_sprite $a419,$60,$9c
        def_credits_sprite $b20b,$60,$a8
        def_credits_sprite $b251,$60,$b4
.endproc

.proc CreditsSpritesScene6Page4
@9b68:  def_credits_sprite $b297,$60,$54
        def_credits_sprite $b2dd,$60,$60
        def_credits_sprite $b323,$60,$6c
        def_credits_sprite $b369,$60,$78
        def_credits_sprite $a45f,$60,$84
        def_credits_sprite $a4a5,$60,$90
        def_credits_sprite $b4c7,$60,$a8
        def_credits_sprite $b50d,$60,$b4
.endproc

.proc CreditsSpritesScene6Page5
@9b88:  def_credits_sprite $a4eb,$60,$54
        def_credits_sprite $a531,$60,$60
        def_credits_sprite $a577,$60,$6c
        def_credits_sprite $a5bd,$60,$78
        def_credits_sprite $a603,$60,$84
        def_credits_sprite $a649,$60,$90
.endproc

.proc CreditsSpritesScene6Page6
@9ba0:  def_credits_sprite $a68f,$60,$54
        def_credits_sprite $a6d5,$60,$60
        def_credits_sprite $b021,$60,$6c
        def_credits_sprite $b067,$60,$78
        def_credits_sprite $b0ad,$60,$84
.endproc

.proc CreditsSpritesScene6Page7
@9bb4:  def_credits_sprite $ae7d,$60,$54
        def_credits_sprite $aec3,$60,$60
        def_credits_sprite $af09,$60,$6c
        def_credits_sprite $a9d7,$60,$78
        def_credits_sprite $aa1d,$60,$84
        def_credits_sprite $aa63,$60,$90
        def_credits_sprite $aaef,$60,$9c
        def_credits_sprite $ab35,$60,$a8
        def_credits_sprite $ab7b,$60,$b4
.endproc

; scene 7

.proc CreditsSpritesScene7Page1
@9bd8:  def_credits_sprite $a7ed,$60,$6c
        def_credits_sprite $a833,$60,$78
        def_credits_sprite $a879,$60,$84
        def_credits_sprite $a8bf,$60,$90
        def_credits_sprite $a905,$60,$9c
        def_credits_sprite $a94b,$60,$a8
.endproc

.proc CreditsSpritesScene7Page2
@9bf0:  def_credits_sprite $afdb,$60,$6c
        def_credits_sprite $b021,$60,$78
        def_credits_sprite $b067,$60,$84
        def_credits_sprite $a71b,$60,$90
        def_credits_sprite $a761,$60,$9c
        def_credits_sprite $a7a7,$60,$a8
.endproc

.proc CreditsSpritesScene7Page3
@9c08:  def_credits_sprite $abc1,$54,$6c
        def_credits_sprite $ac07,$5c,$78
        def_credits_sprite $ac4d,$58,$84
        def_credits_sprite $adf1,$60,$90
        def_credits_sprite $acd9,$58,$9c
.endproc

.proc CreditsSpritesScene7Page4
@9c1c:  def_credits_sprite $ad1f,$58,$6c
        def_credits_sprite $ad65,$54,$78
        def_credits_sprite $adab,$4c,$84
        def_credits_sprite $ac93,$44,$90
        def_credits_sprite $ae37,$4c,$9c
.endproc

.proc CreditsSpritesScene7Page5
@9c30:  def_credits_sprite $ae7d,$48,$6c
        def_credits_sprite $aec3,$50,$78
        def_credits_sprite $af09,$58,$84
        def_credits_sprite $af4f,$48,$90
        def_credits_sprite $af95,$58,$9c
.endproc

; ------------------------------------------------------------------------------

; pointers to credits text
;   each line of text is two 16-bit words
;   +$00: pointer to text (+$c30000)
;   +$02: destination address (+$7e0000)

; credits big text

; scene 1
;   hironobu sakaguchi
@9c44:  .addr   $9fa1,$9dcf,$9faa,$9e15

; scene 2
;   yoshinori kitase
;   hiroyuki itou
;   ken narita
;   kiyoshi yoshii
;   tetsuya takahashi
;   kazuko shibuya
;   hideo minaba
;   tetsuya nomura
;   nobuo uematsu
;   yoshitaka amano
;   yasuyuki hasebe
;   akiyoshi oota
@9c4c:  .addr   $9fbd,$9f2d,$9fc7,$9f73,$9fce,$9fb9,$9fd7,$9fff
        .addr   $9fec,$a045,$9ff0,$a08b,$9ff7,$a0d1,$9fff,$a117
        .addr   $a017,$a15d,$a01f,$a1a3,$a029,$a1e9,$a030,$a22f
        .addr   $a038,$a275,$a03e,$a2bb,$a017,$a301,$a045,$a347
        .addr   $a052,$a38d,$a058,$a3d3,$a06d,$a419,$a077,$a45f
        .addr   $a08c,$a4a5,$a095,$a4eb,$a09c,$a531,$a0a5,$a577

; scene 3
;   yoshihiko maekawa
;   keita etoh
;   satoru tsuji
;   tsukasa fujita
;   keisuke matsuhara
;   hiroshi harata
;   satoshi ogata
;   akihiro yamaguchi
@9cac:  .addr   $a0b0,$9ee7,$a0ba,$9f2d,$a0c2,$9f73,$a0c8,$9fb9
        .addr   $a0cd,$9fff,$a0d4,$a045,$a0e0,$a08b,$a0e8,$a0d1
        .addr   $a0ef,$a117,$a0f7,$a15d,$a108,$a1a3,$a110,$a1e9
        .addr   $a117,$a22f,$a11f,$a275,$a125,$a2bb,$a12d,$a301

; scene 4
@9cec:  .addr   $a13d,$9fb9,$a144,$9fff,$a152,$a045,$a15c,$a08b
        .addr   $a163,$a0d1,$a16c,$a117,$a173,$a15d,$a17b,$a1a3
        .addr   $a181,$a1e9,$a18a,$a22f,$a190,$a275,$a196,$a2bb
        .addr   $a19e,$a301,$a1a4,$a347,$a1ab,$a38d,$a1b5,$a3d3
        .addr   $a1bd,$a531,$a1c7,$a45f,$a1d0,$a4a5,$a1d9,$a4eb
        .addr   $a1e0,$a419,$a1ea,$a5bd,$a1f9,$a603,$a208,$a649
        .addr   $a211,$a68f

; scene 5
@9d50:  .addr   $a221,$9fb9,$a226,$9fff,$a22f,$a045,$a236,$a08b
        .addr   $a23d,$a0d1,$a247,$a117,$a24e,$a15d,$a257,$a1a3
        .addr   $a25f,$a1e9,$a264,$a22f,$a272,$a275,$a279,$a2bb
        .addr   $a27c,$a301,$a281,$a347,$a285,$a761,$a289,$a7a7
        .addr   $a298,$a38d,$a2a1,$a3d3,$a2aa,$a419,$a2b1,$a45f
        .addr   $a2b7,$a4a5,$a2c0,$a4eb,$a2c8,$a531,$a2cf,$a577
        .addr   $a2e1,$a649,$a2e8,$a68f,$a2ef,$a6d5,$a2f7,$a71b

; ------------------------------------------------------------------------------

; credits small text

; scene 1 (mode 7 airship)
; producer
@9dc0:  .addr   $9f98,$9d89

; scene 2 (tiny airship)
; director
; main programmer
@9dc4:  .addr   $9fb4,$9d89,$9fdc,$9dcf,$9fe1,$9e15,$a006,$9e5b
        .addr   $a00e,$9ea1,$a04c,$9ee7,$a060,$a5bd,$a066,$a603
        .addr   $a07d,$a649,$a084,$a68f

; scene 3
@9dec:  .addr   $a0aa,$9ea1,$a0da,$9d89,$a084,$9dcf,$a101,$9e15
        .addr   $9fe1,$9e5b,$a07d,$a68f

; scene 4
@9e04:  .addr   $a137,$9d89,$9fe1,$9dcf,$a101,$9e15,$a006,$9e5b
        .addr   $a149,$9ea1,$a0aa,$9ee7,$a1f1,$9f2d,$a201,$9f73

; scene 5
@9e24:  .addr   $a137,$9d89,$a218,$9dcf,$a101,$9e15,$a26b,$9e5b
        .addr   $a084,$9ea1,$a291,$9ee7,$a2d7,$9f2d,$9f98,$9f73
        .addr   $a64f,$a7ed

; scene 6 (land with no sprites)
@9e48:  .addr   $a300,$9d89,$a305,$9dcf,$a359,$9e15,$a361,$9e5b
        .addr   $a368,$9ea1,$a311,$9f73,$a31c,$9fb9,$a324,$9fff
        .addr   $a32c,$a045,$a335,$a08b,$a33e,$a0d1,$a346,$a117
        .addr   $a350,$a15d,$a36b,$a1a3,$a376,$a1e9,$a382,$a22f
        .addr   $a38e,$a275,$a397,$a2bb,$a3a0,$a301,$a3a9,$a347
        .addr   $a3b5,$a38d,$a3be,$a3d3,$a3c8,$a419,$a408,$a45f
        .addr   $a40f,$a4a5,$a418,$a4eb,$a421,$a531,$a42d,$a577
        .addr   $a436,$a5bd,$a441,$a603,$a44a,$a649,$a451,$a68f
        .addr   $a459,$a6d5,$a51c,$ae7d,$a527,$aec3,$a530,$af09
        .addr   $a539,$a9d7,$a543,$aa1d,$a54f,$aa63,$a558,$aaef
        .addr   $a561,$ab35,$a56b,$ab7b,$a4f5,$a991,$a466,$b021
        .addr   $a46f,$b067,$a47c,$b0ad,$a4fe,$b139,$a508,$b17f
        .addr   $a511,$b1c5,$a3d1,$b20b,$a3dc,$b251,$a3e4,$b297
        .addr   $a3ef,$b2dd,$a3f7,$b323,$a3ff,$b369,$a63c,$b4c7
        .addr   $a648,$b50d

; scene 7 (big airship)
@9f2c:  .addr   $a4a4,$a71b,$a4ab,$a761,$a4b2,$a7a7,$a486,$afdb
        .addr   $a492,$b021,$a49c,$b067

        .addr   $a4bb,$a7ed,$a4c4,$a833,$a4cf,$a879,$a4d6,$a8bf
        .addr   $a4e1,$a905,$a4ea,$a94b

        .addr   $a575,$abc1,$a583,$ac07,$a58f,$ac4d,$a59c,$ac93
        .addr   $a5ac,$acd9

        .addr   $a5b9,$ad1f,$a5c4,$ad65,$a5d0,$adab,$a5de,$adf1
        .addr   $a5e9,$ae37

        .addr   $a5f7,$ae7d,$a607,$aec3,$a615,$af09,$a621,$af4f
        .addr   $a631,$af95

; ------------------------------------------------------------------------------

; credits text (big and small text are mixed together)
; strings are in the order that they are displayed, but
; repeated strings are re-used

@9f98:  .byte   $ef,$f1,$ee,$e3,$f4,$e2,$e4,$f1,$00  ; producer
@9fa1:  .byte   $4e,$60,$82,$6c,$6a,$6c,$42,$88,$00  ; hironobu
@9faa:  .byte   $84,$40,$64,$40,$4c,$88,$44,$4e,$60,$00  ; sakaguchi

@9fb4:  .byte   $e3,$e8,$f1,$e4,$e2,$f3,$ee,$f1,$00  ; director
@9fbd:  .byte   $a0,$6c,$84,$4e,$60,$6a,$6c,$82,$60,$00  ; yoshinori
@9fc7:  .byte   $64,$60,$86,$40,$84,$48,$00  ; kitase
@9fce:  .byte   $4e,$60,$82,$6c,$a0,$88,$64,$60,$00  ; hiroyuki
@9fd7:  .byte   $60,$86,$6c,$88,$00  ; itou

@9fdc:  .byte   $ec,$e0,$e8,$ed,$00  ; main
@9fe1:  .byte   $ef,$f1,$ee,$e6,$f1,$e0,$ec,$ec,$e4,$f1,$00  ; programmer
        .byte   $64,$48,$6a,$00  ; ken
        .byte   $6a,$40,$82,$60,$86,$40,$00  ; narita
        .byte   $64,$60,$a0,$6c,$84,$4e,$60,$00  ; kiyoshi
        .byte   $a0,$6c,$84,$4e,$60,$60,$00  ; yoshii

        .byte   $e6,$f1,$e0,$ef,$e7,$e8,$e2,$00
        .byte   $e3,$e8,$f1,$e4,$e2,$f3,$ee,$f1,$00
        .byte   $86,$48,$86,$84,$88,$a0,$40,$00
        .byte   $86,$40,$64,$40,$4e,$40,$84,$4e,$60,$00
        .byte   $64,$40,$a2,$88,$64,$6c,$00
        .byte   $84,$4e,$60,$42,$88,$a0,$40,$00
        .byte   $4e,$60,$46,$48,$6c,$00
        .byte   $68,$60,$6a,$40,$42,$40,$00
        .byte   $6a,$6c,$68,$88,$82,$40,$00
        .byte   $ec,$f4,$f2,$e8,$e2,$00
        .byte   $6a,$6c,$42,$88,$6c,$00
        .byte   $88,$48,$68,$40,$86,$84,$88,$00
        .byte   $e8,$ec,$e0,$e6,$e4,$00
        .byte   $e3,$e4,$f2,$e8,$e6,$ed,$00
        .byte   $a0,$6c,$84,$4e,$60,$86,$40,$64,$40,$00
        .byte   $40,$68,$40,$6a,$6c,$00
        .byte   $e1,$e0,$f3,$f3,$eb,$e4,$00
        .byte   $ef,$eb,$e0,$ed,$ed,$e4,$f1,$00
        .byte   $a0,$40,$84,$88,$a0,$88,$64,$60,$00
        .byte   $4e,$40,$84,$48,$42,$48,$00
        .byte   $40,$64,$60,$a0,$6c,$84,$4e,$60,$00
        .byte   $6c,$6c,$86,$40,$00
        .byte   $e5,$e8,$e4,$eb,$e3,$00
        .byte   $a0,$6c,$84,$4e,$60,$4e,$60,$64,$6c,$00
        .byte   $68,$40,$48,$64,$40,$8c,$40,$00
        .byte   $64,$48,$60,$86,$40,$00
        .byte   $48,$86,$6c,$4e,$00
        .byte   $84,$40,$86,$6c,$82,$88,$00
        .byte   $86,$84,$88,$62,$60,$00
        .byte   $e4,$f5,$e4,$ed,$f3,$00
        .byte   $86,$84,$88,$64,$40,$84,$40,$00
        .byte   $4a,$88,$62,$60,$86,$40,$00
        .byte   $64,$48,$60,$84,$88,$64,$48,$00
        .byte   $68,$40,$86,$84,$88,$4e,$40,$82,$40,$00
        .byte   $e4,$e5,$e5,$e4,$e2,$f3,$00
        .byte   $4e,$60,$82,$6c,$84,$4e,$60,$00
        .byte   $4e,$40,$82,$40,$86,$40,$00
        .byte   $84,$40,$86,$6c,$84,$4e,$60,$00
        .byte   $6c,$4c,$40,$86,$40,$00
        .byte   $40,$64,$60,$4e,$60,$82,$6c,$00
        .byte   $a0,$40,$68,$40,$4c,$88,$44,$4e,$60,$00
        .byte   $f2,$ee,$f4,$ed,$e3,$00
        .byte   $68,$60,$6a,$6c,$82,$88,$00
        .byte   $40,$64,$40,$6c,$00
        .byte   $e3,$e4,$f2,$e8,$e6,$ed,$e4,$f1,$00
        .byte   $4e,$60,$82,$6c,$64,$40,$86,$84,$88,$00
        .byte   $84,$40,$84,$40,$64,$60,$00
        .byte   $86,$40,$64,$40,$4e,$40,$82,$88,$00
        .byte   $68,$40,$86,$84,$88,$6c,$00
        .byte   $a0,$88,$88,$84,$88,$64,$48,$00
        .byte   $6a,$40,$6c,$82,$40,$00
        .byte   $6a,$6c,$42,$88,$a0,$88,$64,$60,$00
        .byte   $60,$64,$48,$46,$40,$00
        .byte   $86,$6c,$68,$6c,$48,$00
        .byte   $60,$6a,$40,$a2,$40,$8c,$40,$00
        .byte   $64,$40,$6c,$82,$60,$00
        .byte   $86,$40,$6a,$40,$64,$40,$00
        .byte   $86,$40,$64,$40,$68,$60,$44,$4e,$60,$00
        .byte   $84,$4e,$60,$42,$88,$a0,$40,$00
        .byte   $84,$60,$6a,$60,$86,$60,$82,$6c,$88,$00
        .byte   $4e,$40,$68,$40,$84,$40,$64,$40,$00
        .byte   $40,$64,$60,$a0,$6c,$84,$4e,$60,$00
        .byte   $68,$40,$84,$88,$46,$40,$00
        .byte   $4e,$60,$46,$48,$86,$6c,$84,$4e,$60,$00
        .byte   $64,$48,$a2,$88,$64,$40,$00
        .byte   $ec,$ee,$ed,$f2,$f3,$e4,$f1,$00
        .byte   $4e,$60,$86,$6c,$84,$4e,$60,$00
        .byte   $ee,$e1,$e9,$e4,$e2,$f3,$00
        .byte   $64,$40,$a2,$88,$4e,$60,$82,$6c,$00
        .byte   $6c,$4e,$64,$40,$8c,$40,$00
        .byte   $e4,$ed,$e6,$e8,$ed,$e4,$e4,$f1,$00
        .byte   $48,$60,$62,$60,$00
        .byte   $6a,$40,$64,$40,$68,$88,$82,$40,$00
        .byte   $64,$40,$a2,$88,$68,$60,$00
        .byte   $68,$60,$86,$6c,$68,$48,$00
        .byte   $a0,$6c,$84,$4e,$60,$86,$40,$64,$40,$00
        .byte   $4e,$60,$82,$6c,$86,$40,$00
        .byte   $a0,$40,$84,$88,$68,$40,$84,$40,$00
        .byte   $6c,$64,$40,$68,$6c,$86,$6c,$00
        .byte   $84,$4e,$88,$6a,$00
        .byte   $6c,$4e,$64,$88,$42,$6c,$00
        .byte   $f1,$e4,$ec,$e0,$ea,$e4,$00
        .byte   $8c,$48,$60,$68,$60,$6a,$00
        .byte   $66,$60,$00
        .byte   $40,$60,$64,$6c,$00
        .byte   $60,$86,$6c,$00
        .byte   $86,$48,$46,$00
        .byte   $8c,$6c,$6c,$66,$84,$48,$a0,$00
        .byte   $f2,$f8,$f2,$f3,$e4,$ec,$00
        .byte   $68,$40,$84,$40,$4e,$60,$82,$6c,$00
        .byte   $6a,$40,$64,$40,$62,$60,$68,$40,$00
        .byte   $68,$60,$86,$84,$88,$6c,$00
        .byte   $6c,$4c,$88,$82,$40,$00
        .byte   $a0,$40,$84,$88,$6a,$6c,$82,$60,$00
        .byte   $6c,$82,$60,$64,$40,$84,$40,$00
        .byte   $a0,$88,$86,$40,$64,$40,$00
        .byte   $6c,$4e,$46,$40,$60,$82,$40,$00
        .byte   $e4,$f7,$e4,$e2,$f4,$f3,$e8,$f5,$e4,$00
        .byte   $86,$48,$86,$84,$88,$6c,$00
        .byte   $68,$60,$a2,$88,$6a,$6c,$00
        .byte   $4e,$60,$86,$6c,$84,$4e,$60,$00
        .byte   $86,$40,$64,$48,$68,$88,$82,$40,$00
        .byte   $f3,$e4,$f2,$f3,$00
        .byte   $e2,$ee,$ee,$f1,$e3,$e8,$ed,$e0,$f3,$ee,$f1,$00
        .byte   $f2,$fa,$ea,$e0,$e9,$e8,$f3,$e0,$ed,$e8,$00
        .byte   $f1,$fa,$ea,$ee,$f4,$e3,$e0,$00
        .byte   $ea,$fa,$e8,$ed,$e0,$e6,$e8,$00
        .byte   $ed,$fa,$e7,$e0,$ed,$e0,$e3,$e0,$00
        .byte   $e7,$fa,$ec,$e0,$f2,$f4,$e3,$e0,$00
        .byte   $ed,$fa,$ea,$e0,$ed,$e0,$e8,$00
        .byte   $e7,$fa,$f2,$e0,$ea,$f4,$f1,$e0,$e8,$00
        .byte   $e7,$fa,$f2,$f4,$f9,$f4,$ea,$e8,$00
        .byte   $f2,$ef,$e4,$e2,$e8,$e0,$eb,$00
        .byte   $f3,$e7,$e0,$ed,$ea,$f2,$00
        .byte   $f3,$ee,$00
        .byte   $ec,$fa,$ec,$e8,$f8,$e0,$ec,$ee,$f3,$ee,$00
        .byte   $ea,$fa,$f3,$ee,$f1,$e8,$f2,$e7,$e8,$ec,$e0,$00
        .byte   $e7,$fa,$e7,$e0,$f2,$e7,$e8,$ec,$ee,$f3,$ee,$00
        .byte   $f8,$fa,$e7,$e8,$f1,$e0,$f3,$e0,$00
        .byte   $f3,$fa,$ed,$ee,$ec,$f4,$f1,$e0,$00
        .byte   $ea,$fa,$f2,$ee,$f4,$f2,$f4,$e8,$00
        .byte   $f3,$fa,$f3,$f2,$f4,$f1,$f4,$f9,$ee,$ed,$ee,$00
        .byte   $f8,$fa,$e8,$f2,$e7,$e8,$e3,$e0,$00
        .byte   $ec,$fa,$ee,$ea,$e0,$ec,$e8,$f8,$e0,$00
        .byte   $ea,$fa,$e7,$e8,$f1,$e0,$f3,$e0,$00
        .byte   $ed,$fa,$f6,$e0,$f3,$e0,$ed,$e0,$e1,$e4,$00
        .byte   $ea,$fa,$ec,$e0,$e4,$e3,$e0,$00
        .byte   $ea,$fa,$f3,$e0,$ed,$e8,$ea,$e0,$f6,$e0,$00
        .byte   $e9,$fa,$f2,$e0,$e8,$f3,$ee,$00
        .byte   $ec,$fa,$e3,$e4,$ed,$ed,$ee,$00
        .byte   $f2,$fa,$e7,$e8,$e3,$e0,$ea,$e8,$00
        .byte   $ea,$fa,$ee,$ee,$e6,$ee,$00
        .byte   $e7,$fa,$f2,$f4,$f9,$f4,$ea,$e8,$00
        .byte   $e7,$fa,$f8,$ee,$ea,$ee,$f3,$e0,$00
        .byte   $ea,$fa,$f8,$e0,$ec,$e0,$f2,$e7,$e8,$f3,$e0,$00
        .byte   $ec,$fa,$f8,$f4,$ec,$ee,$f3,$ee,$00
        .byte   $ed,$fa,$e8,$f2,$e7,$e8,$ea,$e0,$f6,$e0,$00
        .byte   $e7,$fa,$ea,$e8,$f9,$f4,$ea,$e0,$00
        .byte   $f2,$fa,$e0,$f1,$e0,$e8,$00
        .byte   $ec,$fa,$ea,$ee,$f4,$ed,$ee,$00
        .byte   $f1,$fa,$f3,$f2,$f4,$ea,$e0,$ea,$ee,$f2,$e7,$e8,$00
        .byte   $ea,$fa,$ea,$e0,$ed,$e4,$ea,$ee,$00
        .byte   $e7,$fa,$f2,$e7,$e8,$ec,$ee,$e3,$e0,$e8,$f1,$e0,$00
        .byte   $ec,$fa,$ed,$ee,$f4,$ec,$f4,$f1,$e0,$00
        .byte   $ec,$fa,$ea,$e0,$ed,$e4,$f2,$e7,$e8,$e6,$e4,$00
        .byte   $e7,$fa,$ed,$ee,$e6,$f4,$e2,$e7,$e8,$00
        .byte   $ec,$fa,$e7,$ee,$f1,$e8,$e4,$00
        .byte   $ec,$fa,$ec,$ee,$f1,$e8,$00
        .byte   $f3,$fa,$ee,$e7,$ed,$ee,$00
        .byte   $ec,$fa,$f2,$ee,$ec,$e4,$ed,$ee,$00
        .byte   $f3,$fa,$ec,$ee,$f1,$e8,$f3,$e0,$00
        .byte   $f8,$fa,$f2,$f4,$e4,$ec,$e8,$f3,$f2,$f4,$00
        .byte   $f6,$fa,$f2,$e0,$f3,$ee,$00
        .byte   $e7,$fa,$ed,$e0,$ea,$e0,$ec,$f4,$f1,$e0,$00
        .byte   $f2,$fa,$e0,$ee,$f8,$e0,$ec,$e0,$00
        .byte   $e7,$fa,$ed,$e0,$e6,$e0,$e7,$e0,$f1,$e0,$00
        .byte   $ea,$fa,$e0,$e3,$e0,$e2,$e7,$e8,$00
        .byte   $f8,$fa,$f4,$e4,$ed,$e8,$f2,$e7,$e8,$00
        .byte   $f8,$fa,$ee,$e7,$ea,$e0,$f6,$e0,$00
        .byte   $f8,$fa,$ea,$f4,$f6,$e0,$e7,$e0,$f1,$e0,$00
        .byte   $ea,$fa,$ec,$e8,$f8,$e0,$ec,$ee,$f3,$ee,$00
        .byte   $e7,$fa,$f2,$f4,$f9,$f4,$ea,$e8,$00
        .byte   $e0,$fa,$ea,$e0,$f6,$e0,$f9,$f4,$00
        .byte   $e2,$fa,$e5,$f4,$e9,$e8,$ee,$ea,$e0,$00
        .byte   $e7,$fa,$ea,$ee,$e1,$e0,$f8,$e0,$f2,$e7,$e8,$00
        .byte   $e7,$fa,$f3,$e0,$ed,$e0,$ea,$e0,$00
        .byte   $f3,$fa,$ec,$e8,$ea,$e0,$f2,$e0,$00
        .byte   $e7,$fa,$ed,$e8,$f2,$e7,$e8,$e3,$e0,$00
        .byte   $f3,$fa,$f3,$e0,$ea,$e4,$e2,$e7,$e8,$00
        .byte   $f1,$e8,$e2,$e7,$fb,$f2,$e8,$eb,$f5,$e4,$e8,$f1,$e0,$00
        .byte   $f3,$ee,$f2,$e7,$e8,$fb,$e7,$ee,$f1,$e8,$e8,$00
        .byte   $e9,$fa,$f8,$e0,$ed,$e0,$e6,$e8,$e7,$e0,$f1,$e0,$00
        .byte   $ed,$e0,$f3,$e7,$e0,$ed,$fb,$f6,$e8,$eb,$eb,$e8,$e0,$ec,$f2,$00
        .byte   $e9,$e0,$ec,$e4,$f2,$fb,$e6,$e8,$eb,$eb,$e8,$f2,$00
        .byte   $e2,$e7,$f1,$e8,$f2,$fb,$e1,$f4,$e3,$e3,$00
        .byte   $ec,$e8,$ea,$e4,$fb,$ec,$e0,$f1,$ea,$e4,$f8,$00
        .byte   $ec,$e8,$f1,$ea,$ee,$fb,$e5,$f1,$e4,$e6,$f4,$e8,$e0,$00
        .byte   $e3,$ee,$f4,$e6,$fb,$f2,$ec,$e8,$f3,$e7,$00
        .byte   $e3,$e0,$eb,$e4,$ed,$fb,$e0,$e1,$f1,$e0,$e7,$e0,$ec,$00
        .byte   $f1,$e4,$e1,$e4,$e2,$e2,$e0,$fb,$e2,$ee,$e5,$e5,$ec,$e0,$ed,$00
        .byte   $e1,$f1,$e8,$e0,$ed,$fb,$e5,$e4,$e7,$e3,$f1,$e0,$f4,$00
        .byte   $e9,$e4,$e5,$e5,$fb,$ef,$e4,$f3,$ea,$e0,$f4,$00
        .byte   $e6,$e4,$ee,$f1,$e6,$e4,$fb,$f2,$e8,$ed,$e5,$e8,$e4,$eb,$e3,$00
        .byte   $e0,$eb,$e0,$ed,$fb,$f6,$e4,$e8,$f2,$f2,$00
        .byte   $f8,$fa,$ec,$e0,$f3,$f2,$f4,$ec,$f4,$f1,$e0,$00
        .byte   $e0,$fa,$f4,$e4,$e3,$e0,$00
        .byte   $f3,$f1,$e0,$ed,$f2,$eb,$e0,$f3,$ee,$f1,$00

; ------------------------------------------------------------------------------

.segment "ending_anim2"

; ------------------------------------------------------------------------------

; helmet eyes animation data (Gogo's ending scene)
@f450:  .addr   $f453
        .byte   $fe

; helmet eyes sprite data
@f453:  .byte   1
        .byte   $00,$00,$6c,$38

; ------------------------------------------------------------------------------

; mini-moogle animation data (Umaro's ending scene)
@f458:  .addr   $f497
        .byte   $04
        .addr   $f4a9
        .byte   $04
        .addr   $f4bb
        .byte   $04
        .addr   $f4c4
        .byte   $04
        .addr   $f4cd
        .byte   $04
        .addr   $f50c
        .byte   $04
        .addr   $f503
        .byte   $04
        .addr   $f4f1
        .byte   $04
        .addr   $f4f1
        .byte   $ff

@f473:  .addr   $f4f1
        .byte   $04
        .addr   $f4fa
        .byte   $04
        .addr   $f4fa
        .byte   $ff

@f47c:  .addr   $f4bb
        .byte   $fe

@f47f:  .addr   $f4d6
        .byte   $50
        .addr   $f4df
        .byte   $fe

@f485:  .addr   $f4cd
        .byte   $3c
        .addr   $f4df
        .byte   $fe

@f48b:  .addr   $f4cd
        .byte   $28
        .addr   $f4df
        .byte   $fe

@f491:  .addr   $f4cd
        .byte   $14
        .addr   $f4df
        .byte   $fe

@f497:  .byte   2
        .byte   00,$00,$50,$38
        .byte   00,$08,$58,$38

@f4a0:  .byte   2
        .byte   00,$00,$51,$38
        .byte   00,$08,$59,$38

@f4a9:  .byte   2
        .byte   00,$00,$52,$38
        .byte   00,$08,$5a,$38

@f4b2:  .byte   2
        .byte   00,$00,$53,$38
        .byte   00,$08,$5b,$38

@f4bb:  .byte   2
        .byte   00,$00,$54,$38
        .byte   00,$08,$5a,$38

@f4c4:  .byte   2
        .byte   00,$00,$55,$38
        .byte   00,$08,$5a,$38

@f4cd:  .byte   2
        .byte   00,$00,$56,$38
        .byte   00,$08,$5e,$38

@f4d6:  .byte   2
        .byte   00,$00,$57,$38
        .byte   00,$08,$58,$38

@f4df:  .byte   2
        .byte   00,$08,$5c,$38
        .byte   08,$08,$5d,$38

@f4e8:  .byte   2
        .byte   00,$00,$60,$38
        .byte   00,$08,$61,$38

@f4f1:  .byte   2
        .byte   00,$00,$52,$78
        .byte   00,$08,$5a,$78

@f4fa:  .byte   2
        .byte   00,$00,$53,$78
        .byte   00,$08,$5b,$78

@f503:  .byte   2
        .byte   00,$00,$54,$78
        .byte   00,$08,$5a,$78

@f50c:  .byte   2
        .byte   00,$00,$55,$78
        .byte   00,$08,$5a,$78

; ------------------------------------------------------------------------------

; mini-moogle animation data (Mog's ending scene)
@f515:  .addr   $f52a
        .byte   $04
        .addr   $f53b
        .byte   $04
        .addr   $f548
        .byte   $04
        .addr   $f555
        .byte   $04
        .addr   $f548
        .byte   $04
        .addr   $f53b
        .byte   $04
        .addr   $f52a
        .byte   $ff

@f52a:  .byte   4
        .byte   $00,$00,$62,$38
        .byte   $08,$00,$63,$38
        .byte   $00,$08,$64,$38
        .byte   $08,$08,$65,$38

@f53b:  .byte   3
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$67,$38
        .byte   $08,$08,$68,$38

@f548:  .byte   3
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$69,$38
        .byte   $08,$08,$6a,$38

@f555:  .byte   2
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$6b,$38

; ------------------------------------------------------------------------------

; y-offset for jumping mini-moogle
@f55e:  .byte   $fe,$fe,$fe,$ff,$ff,$ff,$00,$00,$01,$01,$02,$02,$03,$03,$04,$04

; ------------------------------------------------------------------------------

; skull animation data (Umaro's ending scene)
@f56e:  .addr   $f57a
        .byte   $b4
        .addr   $f57a
        .byte   $b4
        .addr   $f57a
        .byte   $3c
        .addr   $f593
        .byte   $fe

@f57a:  .byte   6
        .byte   $00,$00,$80,$38
        .byte   $08,$00,$81,$38
        .byte   $00,$08,$82,$38
        .byte   $08,$08,$83,$38
        .byte   $00,$10,$86,$38
        .byte   $08,$10,$87,$38

@f593:  .byte   8
        .byte   $00,$00,$80,$38
        .byte   $08,$00,$81,$38
        .byte   $00,$08,$84,$38
        .byte   $08,$08,$85,$38
        .byte   $00,$10,$88,$38
        .byte   $08,$10,$89,$38
        .byte   $00,$18,$8a,$38
        .byte   $08,$18,$8b,$38

; ------------------------------------------------------------------------------

; pendant animation data (Terra's ending scene)
@f5b4:  .addr   $f612
        .byte   $10
        .addr   $f5d5
        .byte   $04
        .addr   $f5da
        .byte   $04
        .addr   $f5df
        .byte   $04
        .addr   $f5e4
        .byte   $04
        .addr   $f5f5
        .byte   $04
        .addr   $f5e4
        .byte   $04
        .addr   $f5df
        .byte   $04
        .addr   $f5da
        .byte   $04
        .addr   $f5d5
        .byte   $04
        .addr   $f612
        .byte   $fe

@f5d5:  .byte   1
        .byte   $04,$04,$4c,$38

@f5da:  .byte   1
        .byte   $04,$04,$4d,$38

@f5df:  .byte   1
        .byte   $04,$04,$4e,$38

@f5e4:  .byte   4
        .byte   $00,$00,$4f,$38
        .byte   $08,$00,$6d,$38
        .byte   $00,$08,$6e,$38
        .byte   $08,$08,$6f,$38

@f5f5:  .byte   1
        .byte   $04,$04,$4e,$78

; ------------------------------------------------------------------------------

; katana animation data (Cyan's ending scene)
@f5fa:  .addr   $f613
        .byte   $04
        .addr   $f618
        .byte   $04
        .addr   $f61d
        .byte   $04
        .addr   $f632
        .byte   $04
        .addr   $f61d
        .byte   $04
        .addr   $f618
        .byte   $04
        .addr   $f613
        .byte   $04
        .addr   $f612
        .byte   $fe

@f612:  .byte   0

@f613:  .byte   1
        .byte   $08,$08,$44,$38

@f618:  .byte   1
        .byte   $08,$08,$45,$38

@f61d:  .byte   5
        .byte   $08,$00,$46,$38
        .byte   $00,$08,$47,$38
        .byte   $08,$08,$48,$38
        .byte   $10,$08,$47,$78
        .byte   $08,$10,$46,$b8

@f632:  .byte   5
        .byte   $08,$00,$49,$38
        .byte   $00,$08,$4a,$38
        .byte   $08,$08,$4b,$38
        .byte   $10,$08,$4a,$78
        .byte   $08,$10,$49,$b8

; ------------------------------------------------------------------------------

; helmet eyes animation data (Gau's ending scene)
@f647:  .addr   $f612
        .byte   $b4
        .addr   $f6b9
        .byte   $02
        .addr   $f6b0
        .byte   $02
        .addr   $f6a7
        .byte   $02
        .addr   $f69e
        .byte   $0a
        .addr   $f6a7
        .byte   $02
        .addr   $f6b0
        .byte   $02
        .addr   $f6b9
        .byte   $01
        .addr   $f6b0
        .byte   $01
        .addr   $f6a7
        .byte   $01
        .addr   $f69e
        .byte   $1e
        .addr   $f6a7
        .byte   $02
        .addr   $f6b0
        .byte   $02
        .addr   $f6b9
        .byte   $01
        .addr   $f6b0
        .byte   $01
        .addr   $f6a7
        .byte   $01
        .addr   $f69e
        .byte   $1e
        .addr   $f6a7
        .byte   $04
        .addr   $f6b0
        .byte   $04
        .addr   $f6b9
        .byte   $02
        .addr   $f6c2
        .byte   $04
        .addr   $f6d3
        .byte   $04
        .addr   $f6e4
        .byte   $04
        .addr   $f6f5
        .byte   $04
        .addr   $f6e4
        .byte   $04
        .addr   $f6d3
        .byte   $04
        .addr   $f6c2
        .byte   $04
        .addr   $f6b9
        .byte   $02
        .addr   $f6b9
        .byte   $fe

@f69e:  .byte   2
        .byte   $00,$00,$00,$38
        .byte   $08,$00,$00,$78

@f6a7:  .byte   2
        .byte   $00,$00,$01,$38
        .byte   $08,$00,$01,$78

@f6b0:  .byte   2
        .byte   $00,$00,$02,$38
        .byte   $08,$00,$02,$78

@f6b9:  .byte   2
        .byte   $00,$00,$03,$38
        .byte   $08,$00,$03,$78

@f6c2:  .byte   4
        .byte   $00,$00,$04,$38
        .byte   $08,$00,$04,$78
        .byte   $00,$08,$05,$38
        .byte   $08,$08,$05,$78

@f6d3:  .byte   4
        .byte   $00,$00,$06,$38
        .byte   $08,$00,$06,$78
        .byte   $00,$08,$07,$38
        .byte   $08,$08,$07,$78

@f6e4:  .byte   4
        .byte   $00,$00,$08,$38
        .byte   $08,$00,$08,$78
        .byte   $00,$08,$09,$38
        .byte   $08,$08,$09,$78

@f6f5:  .byte   4
        .byte   $00,$00,$0a,$38
        .byte   $08,$00,$0a,$78
        .byte   $00,$08,$0b,$38
        .byte   $08,$08,$0b,$78

; ------------------------------------------------------------------------------

@f706:  .addr   $f715
        .byte   $08
        .addr   $f71a
        .byte   $08
        .addr   $f71f
        .byte   $08
        .addr   $f724
        .byte   $08
        .addr   $f724
        .byte   $ff

@f715:  .byte   1
        .byte   $00,$00,$06,$34

@f71a:  .byte   1
        .byte   $00,$00,$07,$34

@f71f:  .byte   1
        .byte   $00,$00,$16,$34

@f724:  .byte   1
        .byte   $00,$00,$17,$34

; ------------------------------------------------------------------------------

@f729:  .addr   $f738
        .byte   $08
        .addr   $f73d
        .byte   $08
        .addr   $f738
        .byte   $08
        .addr   $f742
        .byte   $08
        .addr   $f742
        .byte   $ff

@f738:  .byte   1
        .byte   $00,$00,$6a,$34

@f73d:  .byte   1
        .byte   $00,$00,$6b,$34

@f742:  .byte   1
        .byte   $00,$00,$7a,$34

; ------------------------------------------------------------------------------

@f747:  .addr   $f74a
        .byte   $fe

@f74a:  .byte   1
        .byte   $00,$00,$7b,$34

; ------------------------------------------------------------------------------

@f74f:  .addr   $f75e
        .byte   $08
        .addr   $f763
        .byte   $08
        .addr   $f768
        .byte   $08
        .addr   $f76d
        .byte   $08
        .addr   $f76d
        .byte   $ff

@f75e:  .byte   1
        .byte   $00,$00,$6e,$3c

@f763:  .byte   1
        .byte   $00,$00,$6f,$3c

@f768:  .byte   1
        .byte   $00,$00,$7e,$3c

@f76d:  .byte   1
        .byte   $00,$00,$7f,$3c

; ------------------------------------------------------------------------------

@f772:  .addr   $f781
        .byte   $08
        .addr   $f78a
        .byte   $08
        .addr   $f793
        .byte   $08
        .addr   $f7a4
        .byte   $08
        .addr   $f7a4
        .byte   $ff

@f781:  .byte   2
        .byte   $00,$00,$60,$3c
        .byte   $08,$00,$61,$3c

@f78a:  .byte   2
        .byte   $00,$00,$62,$3c
        .byte   $08,$00,$63,$3c

@f793:  .byte   4
        .byte   $00,$00,$64,$3c
        .byte   $08,$00,$65,$3c
        .byte   $00,$08,$3c,$3c
        .byte   $08,$08,$3d,$3c

@f7a4:  .byte   4
        .byte   $00,$00,$66,$3c
        .byte   $08,$00,$67,$3c
        .byte   $00,$08,$3e,$3c
        .byte   $08,$08,$3f,$3c

; ------------------------------------------------------------------------------

; birds for ending scene with ship
@f7b5:  .word   $f706
        .byte   $f0
        .byte   $18
        .word   $f729
        .byte   $20
        .byte   $70
        .word   $f74f
        .byte   $b0
        .byte   $68
        .word   $f74f
        .byte   $c8
        .byte   $50
        .word   $f706
        .byte   $28
        .byte   $40
        .word   $f772
        .byte   $58
        .byte   $a0
        .word   $f706
        .byte   $f0
        .byte   $18
        .word   $f729
        .byte   $20
        .byte   $70
        .word   $f74f
        .byte   $b0
        .byte   $68
        .word   $f74f
        .byte   $c8
        .byte   $50
        .word   $f706
        .byte   $28
        .byte   $40
        .word   $f772
        .byte   $50
        .byte   $50
        .word   $f729
        .byte   $a0
        .byte   $50
        .word   $f74f
        .byte   $20
        .byte   $60
        .word   $f74f
        .byte   $c0
        .byte   $78
        .word   $f74f
        .byte   $d0
        .byte   $48
        .word   $f706
        .byte   $28
        .byte   $70
        .word   $f74f
        .byte   $50
        .byte   $60

; ------------------------------------------------------------------------------

; ship animation data (unused)
@f7fd:  .addr   $f815
        .byte   $08
        .addr   $f847
        .byte   $08
        .addr   $f879
        .byte   $08
        .addr   $f879
        .byte   $ff

; ship animation data (unused)
@f809:  .addr   $f82e
        .byte   $08
        .addr   $f860
        .byte   $08
        .addr   $f892
        .byte   $08
        .addr   $f892
        .byte   $ff

@f815:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$28,$74
        .byte   $00,$10,$29,$74

@f82e:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

@f847:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$2c,$74
        .byte   $00,$10,$2d,$74

@f860:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

@f879:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$2e,$74
        .byte   $00,$10,$2f,$74

@f892:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

; ------------------------------------------------------------------------------

; "And you" animation data
@f8ab:  .addr   $f8ae
        .byte   $fe

@f8ae:  .byte   $18                     ; should be $0c ???
        .byte   $00,$08,$00,$31
        .byte   $00,$10,$10,$31
        .byte   $08,$08,$0D,$31
        .byte   $08,$10,$1D,$31
        .byte   $10,$08,$03,$31
        .byte   $10,$10,$13,$31
        .byte   $20,$08,$28,$31
        .byte   $20,$10,$38,$31
        .byte   $28,$08,$0E,$31
        .byte   $28,$10,$1E,$31
        .byte   $30,$08,$24,$31
        .byte   $30,$10,$34,$31

; ------------------------------------------------------------------------------

; character graphics pose offsets
MenuCharPoseOffsets:
@f8df:  .word   $03C0
        .word   $0500
        .word   $0540

; character graphics VRAM pointers
CharGfxVRAMAddr:
@f8e5:  .word   $3000
        .word   $3080
        .word   $3200
        .word   $3280
        .word   $3400
        .word   $3480
        .word   $3600
        .word   $3680
        .word   $3800
        .word   $3880
        .word   $3A00
        .word   $3A80
        .word   $3C00
        .word   $3C80
        .word   $3E00
        .word   $3E80
        .word   $3040
        .word   $30C0
        .word   $3240
        .word   $32C0
        .word   $3440
        .word   $34C0

; ------------------------------------------------------------------------------

; pointers to character graphics
MenuCharGfxPtrs:
@f911:  .word   $00D5,$0000
        .word   $00D5,$16A0
        .word   $00D5,$2D40
        .word   $00D5,$43E0
        .word   $00D5,$5A80
        .word   $00D5,$7120
        .word   $00D5,$87C0
        .word   $00D5,$9E60
        .word   $00D5,$B500
        .word   $00D5,$CBA0
        .word   $00D5,$E240
        .word   $00D5,$F8E0
        .word   $00D6,$0F80
        .word   $00D6,$2620
        .word   $00D6,$3CC0
        .word   $00D6,$5360
        .word   $00D6,$6A00
        .word   $00D6,$7F60
        .word   $00D6,$94C0
        .word   $00D6,$AA20
        .word   $00D6,$BF80
        .word   $00D6,$D4E0

; ------------------------------------------------------------------------------

@f969:  .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$01,$01,$01,$01
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$01,$01,$01,$01
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$03,$03,$03,$03,$03
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
        .byte   $03,$03,$03,$03,$03,$03,$03,$00

@f9e1:  .byte   $07,$07,$07,$07,$02,$02,$02,$02,$07,$07,$07,$07,$04,$04,$04,$04
        .byte   $07,$07,$07,$07,$02,$02,$02,$02,$07,$07,$07,$07,$04,$04,$04,$04
        .byte   $07,$07,$07,$07,$02,$02,$02,$02,$07,$07,$07,$07,$04,$04,$04,$04
        .byte   $07,$07,$07,$07,$02,$02,$02,$02,$07,$07,$07,$07,$04,$04,$04,$04
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$06,$07,$07,$07,$07,$06,$06,$06
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$07,$07,$07,$07,$07,$07,$06,$06
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$07,$07,$07,$07,$07,$07,$06,$06
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$06,$07,$07,$07,$07,$06,$06,$06
        .byte   $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04,$04,$06,$06
        .byte   $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04,$04,$06,$06
        .byte   $06,$06,$06,$06,$06,$06,$06,$04,$04,$04,$04,$06,$06,$04,$02,$02
        .byte   $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$02,$02,$02,$02
        .byte   $02,$02,$02,$02,$02,$02,$02,$00

@faa9:  .byte   $00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$80,$00,$00,$00,$C0,$00
        .byte   $00,$00,$00,$20,$00,$00,$40,$20,$00,$00,$80,$20,$00,$00,$C0,$20
        .byte   $00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$80,$00,$00,$00,$C0,$00
        .byte   $00,$00,$00,$20,$00,$04,$40,$20,$00,$00,$80,$20,$00,$00,$C0,$20
        .byte   $00,$00,$00,$00,$00,$04,$40,$00,$00,$00,$80,$00,$00,$04,$C0,$00
        .byte   $00,$08,$00,$20,$00,$0C,$40,$20,$00,$08,$80,$20,$00,$0C,$C0,$20
        .byte   $00,$04,$00,$00,$00,$04,$40,$00,$00,$04,$80,$00,$00,$04,$C0,$00
        .byte   $00,$00,$00,$20,$00,$00,$40,$20,$00,$00,$80,$20,$00,$00,$C0,$20

; ------------------------------------------------------------------------------
