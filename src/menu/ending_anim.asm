
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

; credits scene 2 (tiny airship 1)
CreditsScrollScene2:
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

; unused
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

; credits scene 3 (sea with boat 1)
CreditsScrollScene3:
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

; credits scene 6 (land without sprites)
CreditsScrollScene6:
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

; credits scene 4 (sea with airship 1)
CreditsScrollScene4:
@8b36:  .word   $0100
        .byte   $fe

; credits scene 5 (airship/land with birds 1)
CreditsScrollScene5:
@8b39:  .word   $0400
        .byte   $fe

; clouds 1
CreditsScrollClouds1:
@8b3c:  .word   $0800
        .byte   $b4
        .word   $0800
        .byte   $fe

; clouds 2
CreditsScrollClouds2:
@8b42:  .word   $0890
        .byte   $fe

; ------------------------------------------------------------------------------

; book animation 2 ("and you")
BookAnim2:
@8b45:  .addr   BookAnimTiles2
        .byte   $08
        .addr   BookAnimTiles3
        .byte   $08
        .addr   BookAnimTiles4
        .byte   $08
        .addr   BookAnimTiles5
        .byte   $08
        .addr   BookAnimTiles5
        .byte   $ff

; terminate book animation
BookAnimEnd:
@8b54:  .addr   BookAnimTiles2
        .byte   $08
        .addr   BookAnimTiles3
        .byte   $08
        .addr   BookAnimTiles4
        .byte   $08
        .addr   BookAnimTiles6
        .byte   $08
        .addr   BookAnimTiles1
        .byte   $fe

; book animation 1
BookAnim1:
@8b63:  .addr   BookAnimTiles2
        .byte   $08
        .addr   BookAnimTiles3
        .byte   $08
        .addr   BookAnimTiles4
        .byte   $08
        .addr   BookAnimTiles5
        .byte   $08
        .addr   BookAnimTiles5
        .byte   $ff

; book animation (Strago's ending scene)
BookAnimStrago:
@8b72:  .addr   BookAnimTiles2
        .byte   $08
        .addr   BookAnimTiles3
        .byte   $08
        .addr   BookAnimTiles4
        .byte   $08
        .addr   BookAnimTiles5
        .byte   $08
        .addr   BookAnimTiles5
        .byte   $ff

; book animation tile data
BookAnimTiles1:
@8b81:  .byte   $1c,$00,$06,$00,$c8,$0b,$d9,$3a

BookAnimTiles2:
@8b89:  .byte   $1c,$00,$06,$00,$e4,$0b,$d9,$3a

BookAnimTiles3:
@8b91:  .byte   $1c,$00,$06,$00,$48,$0d,$d9,$3a

BookAnimTiles4:
@8b99:  .byte   $1c,$00,$06,$00,$64,$0d,$d9,$3a

BookAnimTiles5:
@8ba1:  .byte   $1c,$00,$06,$00,$c8,$0e,$d9,$3a

BookAnimTiles6:
@8ba9:  .byte   $1c,$00,$06,$00,$e4,$0e,$d9,$3a

; ------------------------------------------------------------------------------

; airship going left
AirshipLeftAnim:
@8bb1:  .addr   AirshipLeftSprite1
        .byte   $02
        .addr   AirshipLeftSprite2
        .byte   $02
        .addr   AirshipLeftSprite2
        .byte   $ff

AirshipLeftSprite1:
@8bba:  .byte   6
        .byte   $80,$00,$0c,$32
        .byte   $90,$00,$0e,$32
        .byte   $80,$10,$20,$32
        .byte   $90,$10,$22,$32
        .byte   $08,$18,$6c,$32
        .byte   $18,$18,$7c,$32

AirshipLeftSprite2:
@8bd3:  .byte   6
        .byte   $80,$00,$0c,$32
        .byte   $90,$00,$0e,$32
        .byte   $80,$10,$20,$32
        .byte   $90,$10,$22,$32
        .byte   $08,$18,$6d,$32
        .byte   $18,$18,$7d,$32

; ------------------------------------------------------------------------------

; shadow under airship
AirshipShadowAnim:
@8bec:  .addr   AirshipShadowSprite_00
        .byte   $2b
        .addr   AirshipShadowSprite_01
        .byte   $2b
        .addr   AirshipShadowSprite_02
        .byte   $2b
        .addr   AirshipShadowSprite_03
        .byte   $2b
        .addr   AirshipShadowSprite_02
        .byte   $2b
        .addr   AirshipShadowSprite_01
        .byte   $2b
        .addr   AirshipShadowSprite_00
        .byte   $ff

AirshipShadowSprite_00:
@8c01:  .byte   2
        .byte   $00,$00,$70,$32
        .byte   $08,$00,$71,$32

AirshipShadowSprite_01:
@8c0a:  .byte   2
        .byte   $00,$00,$72,$32
        .byte   $08,$00,$73,$32

AirshipShadowSprite_02:
@8c13:  .byte   2
        .byte   $00,$00,$74,$32
        .byte   $08,$00,$75,$32

AirshipShadowSprite_03:
@8c1c:  .byte   2
        .byte   $00,$00,$76,$32
        .byte   $08,$00,$77,$32

; ------------------------------------------------------------------------------

; airship going right
AirshipRightAnim:
@8c25:  .addr   AirshipRightSprite1
        .byte   $02
        .addr   AirshipRightSprite2
        .byte   $02
        .addr   AirshipRightSprite2
        .byte   $ff

AirshipRightSprite1:
@8c2e:  .byte   6
        .byte   $90,$00,$0c,$72
        .byte   $80,$00,$0e,$72
        .byte   $90,$10,$20,$72
        .byte   $80,$10,$22,$72
        .byte   $10,$18,$6c,$72
        .byte   $00,$18,$7c,$72

AirshipRightSprite2:
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
AirshipSplashAnim:
@8d0b:  .addr   AirshipSplashSprite1
        .byte   $06
        .addr   AirshipSplashSprite2
        .byte   $06
        .addr   AirshipSplashSprite3
        .byte   $06
        .addr   AirshipSplashSprite4
        .byte   $06
        .addr   CreditsBlankSprite
        .byte   $fe

AirshipSplashSprite1:
@8d1a:  .byte   2
        .byte   $80,$00,$40,$3e
        .byte   $90,$00,$42,$3e

AirshipSplashSprite2:
@8d23:  .byte   2
        .byte   $80,$00,$44,$3e
        .byte   $90,$00,$46,$3e

AirshipSplashSprite3:
@8d2c:  .byte   2
        .byte   $80,$00,$48,$3e
        .byte   $90,$00,$4a,$3e

AirshipSplashSprite4:
@8d35:  .byte   2
        .byte   $80,$00,$4c,$3e
        .byte   $90,$00,$4e,$3e

; ------------------------------------------------------------------------------

; big airship propeller (left side, cw)
AirshipPropellerLeftAnim:
@8d3e:  .addr   AirshipPropellerLeftSprite1
        .byte   $01
        .addr   AirshipPropellerLeftSprite2
        .byte   $01
        .addr   AirshipPropellerLeftSprite3
        .byte   $01
        .addr   AirshipPropellerLeftSprite4
        .byte   $01
        .addr   AirshipPropellerLeftSprite4
        .byte   $ff

AirshipPropellerLeftSprite1:
@8d4d:  .byte   4
        .byte   $80,$00,$80,$30
        .byte   $90,$00,$82,$30
        .byte   $80,$10,$a0,$30
        .byte   $90,$10,$a2,$30

AirshipPropellerLeftSprite2:
@8d5e:  .byte   4
        .byte   $80,$00,$84,$30
        .byte   $90,$00,$86,$30
        .byte   $80,$10,$a4,$30
        .byte   $90,$10,$a6,$30

AirshipPropellerLeftSprite3:
@8d6f:  .byte   4
        .byte   $80,$00,$88,$30
        .byte   $90,$00,$8a,$30
        .byte   $80,$10,$a8,$30
        .byte   $90,$10,$aa,$30

AirshipPropellerLeftSprite4:
@8d80:  .byte   4
        .byte   $80,$00,$8c,$30
        .byte   $90,$00,$8e,$30
        .byte   $80,$10,$ac,$30
        .byte   $90,$10,$ae,$30

; ------------------------------------------------------------------------------

; big airship propeller (right side, ccw)

AirshipPropellerRightAnim:
@8d91:  .addr   AirshipPropellerRightSprite1
        .byte   $01
        .addr   AirshipPropellerRightSprite2
        .byte   $01
        .addr   AirshipPropellerRightSprite3
        .byte   $01
        .addr   AirshipPropellerRightSprite4
        .byte   $01
        .addr   AirshipPropellerRightSprite4
        .byte   $ff

AirshipPropellerRightSprite1:
@8da0:  .byte   4
        .byte   $90,$00,$80,$70
        .byte   $80,$00,$82,$70
        .byte   $90,$10,$a0,$70
        .byte   $80,$10,$a2,$70

AirshipPropellerRightSprite2:
@8db1:  .byte   4
        .byte   $90,$00,$84,$70
        .byte   $80,$00,$86,$70
        .byte   $90,$10,$a4,$70
        .byte   $80,$10,$a6,$70

AirshipPropellerRightSprite3:
@8dc2:  .byte   4
        .byte   $90,$00,$88,$70
        .byte   $80,$00,$8a,$70
        .byte   $90,$10,$a8,$70
        .byte   $80,$10,$aa,$70

AirshipPropellerRightSprite4:
@8dd3:  .byte   4
        .byte   $90,$00,$8c,$70
        .byte   $80,$00,$8e,$70
        .byte   $90,$10,$ac,$70
        .byte   $80,$10,$ae,$70

; ------------------------------------------------------------------------------

.macro make_ending_char_name_anim name, x1, x2
        .addr   .ident(.sprintf("Ending%sNameAnim1", name))
        .byte   x1
        .addr   .ident(.sprintf("Ending%sNameAnim2", name))
        .byte   x2
.endmac

EndingCharNameAnim:
.if LANG_EN
@8de4:  make_ending_char_name_anim "Terra",     $40, $00
        make_ending_char_name_anim "Locke",     $4c, $8c
        make_ending_char_name_anim "Cyan",      $38, $68
        make_ending_char_name_anim "Shadow",    $60, $00
        make_ending_char_name_anim "Edgar",     $30, $98
        make_ending_char_name_anim "Sabin",     $2c, $90
        make_ending_char_name_anim "Celes",     $48, $00
        make_ending_char_name_anim "Strago",    $48, $00
        make_ending_char_name_anim "Relm",      $48, $00
        make_ending_char_name_anim "Setzer",    $38, $78
        make_ending_char_name_anim "Mog",       $6c, $00
        make_ending_char_name_anim "Gau",       $6c, $00
        make_ending_char_name_anim "Gogo",      $68, $00
        make_ending_char_name_anim "Umaro",     $64, $00
.else
        make_ending_char_name_anim "Terra",     $40, $00
        make_ending_char_name_anim "Locke",     $50, $88
        make_ending_char_name_anim "Cyan",      $30, $78
        make_ending_char_name_anim "Shadow",    $60, $00
        make_ending_char_name_anim "Edgar",     $30, $98
        make_ending_char_name_anim "Sabin",     $30, $90
        make_ending_char_name_anim "Celes",     $48, $00
        make_ending_char_name_anim "Strago",    $40, $00
        make_ending_char_name_anim "Relm",      $48, $00
        make_ending_char_name_anim "Setzer",    $38, $78
        make_ending_char_name_anim "Mog",       $6c, $00
        make_ending_char_name_anim "Gau",       $6c, $00
        make_ending_char_name_anim "Gogo",      $68, $00
        make_ending_char_name_anim "Umaro",     $64, $00
.endif

; "as"
EndingCharAsAnim:
@8e38:  .addr   EndingCharAsSprite
        .byte   $fe

EndingTerraNameAnim1:
@8e3b:  .addr   EndingTerraNameSprite
        .byte   $fe

EndingTerraNameAnim2:
@8e3e:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingLockeNameAnim1:
@8e41:  .addr   EndingLockeNameSprite
        .byte   $fe

EndingLockeNameAnim2:
@8e44:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingCyanNameAnim1:
@8e47:  .addr   EndingCyanNameSprite1
        .byte   $fe

EndingCyanNameAnim2:
@8e4a:  .addr   EndingCyanNameSprite2
        .byte   $fe

EndingShadowNameAnim1:
@8e4d:  .addr   EndingShadowNameSprite
        .byte   $fe

EndingShadowNameAnim2:
@8e50:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingEdgarNameAnim1:
@8e53:  .addr   EndingEdgarNameSprite
        .byte   $fe

EndingEdgarNameAnim2:
@8e56:  .addr   EndingFigaroNameSprite
        .byte   $fe

EndingSabinNameAnim1:
@8e59:  .addr   EndingSabinNameSprite
        .byte   $fe

EndingSabinNameAnim2:
@8e5c:  .addr   EndingFigaroNameSprite
        .byte   $fe

EndingCelesNameAnim1:
@8e5f:  .addr   EndingCelesNameSprite
        .byte   $fe

EndingCelesNameAnim2:
@8e62:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingStragoNameAnim1:
@8e65:  .addr   EndingStragoNameSprite
        .byte   $fe

EndingStragoNameAnim2:
@8e68:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingRelmNameAnim1:
@8e6b:  .addr   EndingRelmNameSprite
        .byte   $fe

EndingRelmNameAnim2:
@8e6e:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingSetzerNameAnim1:
@8e71:  .addr   EndingSetzerNameSprite1
        .byte   $fe

EndingSetzerNameAnim2:
@8e74:  .addr   EndingSetzerNameSprite2
        .byte   $fe

EndingMogNameAnim1:
@8e77:  .addr   EndingMogNameSprite
        .byte   $fe

EndingMogNameAnim2:
@8e7a:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingGauNameAnim1:
@8e7d:  .addr   EndingGauNameSprite
        .byte   $fe

EndingGauNameAnim2:
@8e80:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingGogoNameAnim1:
@8e83:  .addr   EndingGogoNameSprite
        .byte   $fe

EndingGogoNameAnim2:
@8e86:  .addr   EndingBlankNameSprite
        .byte   $fe

EndingUmaroNameAnim1:
@8e89:  .addr   EndingUmaroNameSprite
        .byte   $fe

EndingUmaroNameAnim2:
@8e8c:  .addr   EndingBlankNameSprite
        .byte   $fe

; "as"
EndingCharAsSprite:
@8e8f:  .byte   2
        .byte   $00,$00,$2a,$33
        .byte   $08,$00,$2b,$33

EndingTerraNameSprite:
.if LANG_EN
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
.else
        .byte   26
        .byte   $80,$00,$76,$31
        .byte   $00,$10,$2c,$31
        .byte   $08,$10,$2d,$31
        .byte   $10,$08,$08,$31
        .byte   $10,$10,$18,$31
        .byte   $18,$08,$0d,$31
        .byte   $18,$10,$1d,$31
        .byte   $20,$08,$00,$31
        .byte   $20,$10,$10,$31
        .byte   $b0,$00,$42,$31
        .byte   $30,$10,$62,$31
        .byte   $38,$10,$63,$31
        .byte   $40,$08,$21,$31
        .byte   $40,$10,$31,$31
        .byte   $48,$08,$00,$31
        .byte   $48,$10,$10,$31
        .byte   $50,$08,$0d,$31
        .byte   $50,$10,$1d,$31
        .byte   $58,$08,$05,$31
        .byte   $58,$10,$15,$31
        .byte   $60,$08,$0e,$31
        .byte   $60,$10,$1e,$31
        .byte   $68,$08,$21,$31
        .byte   $68,$10,$31,$31
        .byte   $70,$08,$03,$31
        .byte   $70,$10,$13,$31
.endif

EndingLockeNameSprite:
.if LANG_EN
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
.else
        .byte   18
        .byte   $80,$00,$4e,$31
        .byte   $00,$10,$6e,$31
        .byte   $08,$10,$6f,$31
        .byte   $10,$08,$0e,$31
        .byte   $10,$10,$1e,$31
        .byte   $18,$08,$02,$31
        .byte   $18,$10,$12,$31
        .byte   $20,$08,$0a,$31
        .byte   $20,$10,$1a,$31
        .byte   $b0,$00,$44,$31
        .byte   $30,$10,$64,$31
        .byte   $38,$10,$65,$31
        .byte   $40,$08,$0e,$31
        .byte   $40,$10,$1e,$31
        .byte   $48,$08,$0b,$31
        .byte   $48,$10,$1b,$31
        .byte   $50,$08,$04,$31
        .byte   $50,$10,$14,$31
.endif

EndingBlankNameSprite:
@8f5a:  .byte   0

EndingCyanNameSprite1:
.if LANG_EN
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
.else
        .byte   15
        .byte   $80,$00,$44,$31
        .byte   $00,$10,$64,$31
        .byte   $08,$10,$65,$31
        .byte   $10,$08,$00,$31
        .byte   $10,$10,$10,$31
        .byte   $18,$08,$28,$31
        .byte   $18,$10,$38,$31
        .byte   $20,$08,$04,$31
        .byte   $20,$10,$14,$31
        .byte   $28,$08,$0d,$31
        .byte   $28,$10,$1d,$31
        .byte   $30,$08,$0d,$31
        .byte   $30,$10,$1d,$31
        .byte   $38,$08,$04,$31
        .byte   $38,$10,$14,$31
.endif

EndingCyanNameSprite2:
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

EndingShadowNameSprite:
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

EndingEdgarNameSprite:
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

EndingFigaroNameSprite:
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

EndingSabinNameSprite:
.if LANG_EN
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
.else
        .byte   18
        .byte   $80,$00,$70,$31
        .byte   $00,$10,$3a,$31
        .byte   $08,$10,$3b,$31
        .byte   $10,$08,$00,$31
        .byte   $10,$10,$10,$31
        .byte   $18,$08,$22,$31
        .byte   $18,$10,$32,$31
        .byte   $20,$08,$07,$31
        .byte   $20,$10,$17,$31
        .byte   $b0,$00,$72,$31
        .byte   $30,$10,$3c,$31
        .byte   $38,$10,$3d,$31
        .byte   $40,$08,$04,$31
        .byte   $40,$10,$14,$31
        .byte   $48,$08,$0d,$31
        .byte   $48,$10,$1d,$31
        .byte   $50,$08,$04,$31
        .byte   $50,$10,$14,$31
.endif

EndingCelesNameSprite:
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

EndingStragoNameSprite:
.if LANG_EN
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
.else
        .byte   $1a
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
        .byte   $30,$08,$24,$31
        .byte   $30,$10,$34,$31
        .byte   $38,$08,$22,$31
        .byte   $38,$10,$32,$31
        .byte   $c8,$00,$70,$31
        .byte   $48,$10,$3a,$31
        .byte   $50,$10,$3b,$31
        .byte   $58,$08,$00,$31
        .byte   $58,$10,$10,$31
        .byte   $60,$08,$06,$31
        .byte   $60,$10,$16,$31
        .byte   $68,$08,$24,$31
        .byte   $68,$10,$34,$31
        .byte   $70,$08,$22,$31
        .byte   $70,$10,$32,$31
.endif

EndingRelmNameSprite:
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

EndingSetzerNameSprite1:
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

EndingSetzerNameSprite2:
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

EndingMogNameSprite:
@926e:  .byte   7
        .byte   $80,$00,$70,$31
        .byte   $00,$10,$3a,$31
        .byte   $08,$10,$3b,$31
        .byte   $10,$08,$0e,$31
        .byte   $10,$10,$1e,$31
        .byte   $18,$08,$06,$31
        .byte   $18,$10,$16,$31

EndingGauNameSprite:
@928b:  .byte   7
        .byte   $80,$00,$4c,$31
        .byte   $00,$10,$6c,$31
        .byte   $08,$10,$6d,$31
        .byte   $10,$08,$00,$31
        .byte   $10,$10,$10,$31
        .byte   $18,$08,$24,$31
        .byte   $18,$10,$34,$31

EndingGogoNameSprite:
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

EndingUmaroNameSprite:
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
SetzerCardAnim:
@92fa:  .addr   SetzerCardSprite5
        .byte   6
        .addr   SetzerCardSprite8
        .byte   6
        .addr   SetzerCardSprite4
        .byte   6
        .addr   SetzerCardSprite3
        .byte   6
        .addr   SetzerCardSprite2
        .byte   6
        .addr   SetzerCardSprite1
        .byte   6
        .addr   SetzerCardSprite2
        .byte   6
        .addr   SetzerCardSprite3
        .byte   6
        .addr   SetzerCardSprite4
        .byte   6
        .addr   SetzerCardSprite8
        .byte   6
        .addr   SetzerCardSprite5
        .byte   6
        .addr   SetzerCardSprite6
        .byte   6
        .addr   SetzerCardSprite7
        .byte   12
        .addr   SetzerCardSprite6
        .byte   6
        .addr   SetzerCardSprite6
        .byte   $ff                      ; ff means repeat (fe means terminate)

SetzerCardSprite1:
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

SetzerCardSprite2:
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

SetzerCardSprite3:
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

SetzerCardSprite4:
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

SetzerCardSprite5:
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

SetzerCardSprite6:
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

SetzerCardSprite7:
@9461:  .byte   8
        .byte   $98,$00,$0e,$34
        .byte   $98,$10,$2e,$34
        .byte   $28,$08,$43,$34
        .byte   $18,$20,$42,$34
        .byte   $88,$18,$0e,$f4
        .byte   $88,$08,$2e,$f4
        .byte   $00,$18,$43,$f4
        .byte   $10,$00,$42,$f4

SetzerCardSprite8:
@9482:  .byte   5
        .byte   $12,$00,$00,$34
        .byte   $12,$08,$10,$34
        .byte   $12,$10,$10,$34
        .byte   $12,$18,$10,$34
        .byte   $12,$20,$10,$34

; ------------------------------------------------------------------------------

; shadow apple animation data

ShadowAppleAnim:
@9497:  .addr   ShadowAppleSprite1
        .byte   $b4
        .addr   ShadowAppleSprite1
        .byte   $b4
        .addr   ShadowAppleSprite1
        .byte   $b4
        .addr   ShadowAppleSprite2
        .byte   $10
        .addr   ShadowAppleSprite3
        .byte   $40
        .addr   ShadowAppleSprite3
        .byte   $fe

ShadowAppleSprite1:
@94a9:  .byte   8
        .byte   $80,$08,$00,$38
        .byte   $10,$08,$02,$38
        .byte   $10,$10,$12,$38
        .byte   $18,$10,$13,$38
        .byte   $80,$18,$04,$38
        .byte   $10,$18,$06,$38
        .byte   $10,$20,$16,$38
        .byte   $18,$18,$03,$38

ShadowAppleSprite2:
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

ShadowAppleSprite3:
@94f7:  .byte   17
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

; ending/credits bg palettes

; sky
_c2953c:
@953c:  .word   $18c6,$664d,$6a6e,$6a90,$6ab1,$6ed2,$6ef3,$7315
        .word   $7336,$7337,$7758,$777a,$779b,$7bbc,$7bdd,$7fff

; glimmer
_c2955c:
@955c:  .word   $0000,$5f5f,$4d38,$2492,$188e,$0c68,$0c45,$0000
        .word   $0000,$0423,$0423,$0423,$0423,$0423,$0423,$0423

; gogo eye
_c2957c:
@957c:  .word   $0000,$0c45,$0c68,$188e,$2492,$4d38,$5f5f,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; non-sprite airship
_c2959c:
@959c:  .word   $59ea,$7fff,$5f7b,$46b6,$3211,$258d,$2129,$1ce6
        .word   $18a2,$375b,$0e34,$016d,$77bd,$66f7,$5e72,$59ea

;
_c295bc:
@95bc:  .word   $0000,$7fff,$5f7b,$46b6,$3211,$258d,$2129,$1ce6
        .word   $18a2,$375b,$0e34,$016d,$77bd,$66f7,$5e72,$59ea

; sea
_c295dc:
@95dc:  .word   $0000,$0864,$1991,$10eb,$0c87,$3653,$298e,$67ff
        .word   $169c,$6713,$664c,$4941,$30c1,$2482,$1c61,$1861

; clouds
_c295fc:
@95fc:  .word   $0000,$7bde,$77be,$77bd,$739c,$737c,$6f5a,$6b39
        .word   $66f7,$5e93,$5daa,$5d46,$0000,$0000,$0000,$7fff

; trees
_c2961c:
@961c:  .word   $0000,$2e0f,$25cc,$25cb,$21aa,$2189,$1948,$1947
        .word   $10e5,$110c,$3a90,$3a6f,$364f,$324e,$322d,$2e0f

; lake
_c2963c:
@963c:  .word   $0000,$5e8f,$4941,$30c1,$2482,$1c61,$31d2,$296f
        .word   $18ea,$25cc,$21aa,$3a6f,$364f,$324e,$322d,$2e0f

; grass
_c2965c:
@965c:  .word   $0000,$4699,$4257,$3e36,$3a15,$35f4,$31d2,$296f
        .word   $18ea,$25cc,$3a90,$3a6f,$364f,$324e,$322d,$2e0f

; book
_c2967c:
@967c:  .word   $0000,$571c,$3a35,$2590,$150c,$08a8,$0466,$0000
        .word   $3800,$3800,$3800,$3800,$3800,$3800,$3800,$3800

; table
_c2969c:
@969c:  .word   $0000,$571c,$4698,$3614,$2dd2,$216f,$1d4e,$192d
        .word   $10eb,$0cc9,$08a8,$0887,$0866,$0445,$0423,$0000

; table (unused)
_c296bc:
@96bc:  .word   $0000,$571c,$571c,$3614,$3614,$216f,$216f,$192d
        .word   $10eb,$10eb,$0887,$0887,$0445,$0423,$0423,$0000

; table
_c296dc:
@96dc:  .word   $0000,$571c,$4698,$3614,$2dd2,$2590,$150c,$08a8
        .word   $3800,$3800,$3800,$3800,$3800,$3800,$3800,$3800

; fade bars
_c296fc:
@96fc:  .word   $0000,$4a52,$3def,$2d6b,$2529,$18c6,$0863,$0020
        .word   $3800,$3800,$3800,$3800,$3800,$3800,$3800,$3800

; unused
_c2971c:
@971c:  .word   $0000,$571c,$4698,$3614,$2dd2,$2590,$2590,$150c
        .word   $150c,$08a8,$08a8,$08a8,$08a8,$08a8,$08a8,$08a8

; ------------------------------------------------------------------------------

; ending/credits font palettes

; small font
_c2973c:
@973c:  .word   $0000,$18c7,$16fe,$16fe

; big font
_c29744:
@9744:  .word   $0000,$16fe,$225a,$18c7

; small font (inverted)
_c2974c:
@974c:  .word   $0000,$c460,$0000,$7fff

; big font (inverted)
_c29754:
@9754:  .word   $0000,$7fff,$56b4,$4c60,$0000,$7fff,$4c60,$7fff
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; ending/credits sprite palettes

; table sprites
_c29774:
@9774:  .word   $0000,$571c,$4698,$3614,$2dd2,$216f,$1d4e,$150c
        .word   $10eb,$0cc9,$08a8,$0887,$0866,$0445,$0423,$0000

; big airship main
_c29794:
@9794:  .word   $0000,$7fff,$639c,$46b6,$3211,$218d,$1929,$1ce8
        .word   $1cc6,$18a4,$1082,$0000,$0000,$0000,$0422,$6293

; boat
_c297b4:
@97b4:  .word   $0000,$0864,$1991,$10eb,$0c87,$3653,$298e,$67ff
        .word   $169c,$6713,$664c,$4941,$7c1f,$7c1f,$1c61,$7c1f

; big airship cockpit
_c297d4:
@97d4:  .word   $0000,$3631,$31ef,$298c,$1991,$192d,$14ea,$10a7
        .word   $0c85,$0864,$375b,$0e34,$016d,$7c1f,$7c1f,$0843

; big airship balloon
_c297f4:
@97f4:  .word   $0000,$779c,$639b,$46b5,$3631,$31ef,$298c,$1d29
        .word   $18e7,$14a6,$0c65,$0c44,$1991,$10eb,$0c87,$7c1f

; water splash
_c29814:
@9814:  .word   $0000,$7fff,$6718,$4e30,$3549,$1c61,$2926,$2926
        .word   $2926,$2926,$2926,$2926,$2926,$2926,$2926,$2926

; birds
_c29834:
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

.macro def_credits_sprite buf_ptr, xx, yy
        .addr   buf_ptr
        .byte   xx, yy
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
.if ::LANG_EN
        def_credits_sprite $a275,$5c,$94
        def_credits_sprite $a2bb,$94,$94
        def_credits_sprite $a301,$60,$a8
        def_credits_sprite $a347,$88,$a8
; translator Ted Woolsey added in English translation
        def_credits_sprite $a7ed,$58,$bc
        def_credits_sprite $a761,$54,$c8
        def_credits_sprite $a7a7,$74,$c8
.else
        def_credits_sprite $a275,$5c,$98
        def_credits_sprite $a2bb,$94,$98
        def_credits_sprite $a301,$60,$ac
        def_credits_sprite $a347,$88,$ac
.endif
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
.if ::LANG_EN
        def_credits_sprite $aaef,$60,$9c
        def_credits_sprite $ab35,$60,$a8
        def_credits_sprite $ab7b,$60,$b4
.else
        def_credits_sprite $aaa9,$60,$9c
        def_credits_sprite $aaef,$60,$a8
        def_credits_sprite $ab35,$60,$b4
        def_credits_sprite $ab7b,$60,$c0
.endif
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
.if ::LANG_EN
@9bf0:  def_credits_sprite $afdb,$60,$6c
        def_credits_sprite $b021,$60,$78
        def_credits_sprite $b067,$60,$84
.else
        def_credits_sprite $af4f,$60,$6c
        def_credits_sprite $af95,$60,$78
        def_credits_sprite $afdb,$60,$84
.endif
        def_credits_sprite $a71b,$60,$90
        def_credits_sprite $a761,$60,$9c
        def_credits_sprite $a7a7,$60,$a8
.endproc

.proc CreditsSpritesScene7Page3
.if ::LANG_EN
@9c08:  def_credits_sprite $abc1,$54,$6c
        def_credits_sprite $ac07,$5c,$78
        def_credits_sprite $ac4d,$58,$84
        def_credits_sprite $adf1,$60,$90
        def_credits_sprite $acd9,$58,$9c
.else
        def_credits_sprite $abc1,$60,$6c
        def_credits_sprite $ac07,$60,$78
        def_credits_sprite $ac4d,$60,$84
        def_credits_sprite $ac93,$60,$90
        def_credits_sprite $acd9,$60,$9c
        def_credits_sprite $ad1f,$60,$a8
        def_credits_sprite $ad65,$60,$b4
.endif
.endproc

.proc CreditsSpritesScene7Page4
.if ::LANG_EN
@9c1c:  def_credits_sprite $ad1f,$58,$6c
        def_credits_sprite $ad65,$54,$78
        def_credits_sprite $adab,$4c,$84
        def_credits_sprite $ac93,$44,$90
        def_credits_sprite $ae37,$4c,$9c
.else
        def_credits_sprite $adab,$60,$6c
        def_credits_sprite $adf1,$60,$78
        def_credits_sprite $ae37,$60,$84
        def_credits_sprite $b3af,$60,$9c
        def_credits_sprite $b3f5,$60,$a8
        def_credits_sprite $b43b,$60,$b4
        def_credits_sprite $b481,$60,$c0
.endif
.endproc

.if LANG_EN
.proc CreditsSpritesScene7Page5
@9c30:  def_credits_sprite $ae7d,$48,$6c
        def_credits_sprite $aec3,$50,$78
        def_credits_sprite $af09,$58,$84
        def_credits_sprite $af4f,$48,$90
        def_credits_sprite $af95,$58,$9c
.endproc
.endif

; ------------------------------------------------------------------------------

; pointers to credits text
;   each line of text is two 16-bit words
;   +$00: pointer to text (+$c30000)
;   +$02: destination address (+$7e0000)

; credits big text

; scene 1
;   hironobu sakaguchi
BigCreditsTextPtrs1:
@9c44:  .addr   _9fa1,$9dcf,_9faa,$9e15

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
BigCreditsTextPtrs2:
@9c4c:  .addr   _9fbd,$9f2d,_9fc7,$9f73,_9fce,$9fb9,_9fd7,$9fff
        .addr   _9fec,$a045,_9ff0,$a08b,_9ff7,$a0d1,_9fff,$a117
        .addr   _a017,$a15d,_a01f,$a1a3,_a029,$a1e9,_a030,$a22f
        .addr   _a038,$a275,_a03e,$a2bb,_a017,$a301,_a045,$a347
        .addr   _a052,$a38d,_a058,$a3d3,_a06d,$a419,_a077,$a45f
        .addr   _a08c,$a4a5,_a095,$a4eb,_a09c,$a531,_a0a5,$a577

; scene 3
;   yoshihiko maekawa
;   keita etoh
;   satoru tsuji
;   tsukasa fujita
;   keisuke matsuhara
;   hiroshi harata
;   satoshi ogata
;   akihiro yamaguchi
BigCreditsTextPtrs3:
@9cac:  .addr   _a0b0,$9ee7,_a0ba,$9f2d,_a0c2,$9f73,_a0c8,$9fb9
        .addr   _a0cd,$9fff,_a0d4,$a045,_a0e0,$a08b,_a0e8,$a0d1
        .addr   _a0ef,$a117,_a0f7,$a15d,_a108,$a1a3,_a110,$a1e9
        .addr   _a117,$a22f,_a11f,$a275,_a125,$a2bb,_a12d,$a301

; scene 4
BigCreditsTextPtrs4:
@9cec:  .addr   _a13d,$9fb9,_a144,$9fff,_a152,$a045,_a15c,$a08b
        .addr   _a163,$a0d1,_a16c,$a117,_a173,$a15d,_a17b,$a1a3
        .addr   _a181,$a1e9,_a18a,$a22f,_a190,$a275,_a196,$a2bb
        .addr   _a19e,$a301,_a1a4,$a347,_a1ab,$a38d,_a1b5,$a3d3
        .addr   _a1bd,$a531,_a1c7,$a45f,_a1d0,$a4a5,_a1d9,$a4eb
        .addr   _a1e0,$a419,_a1ea,$a5bd,_a1f9,$a603,_a208,$a649
        .addr   _a211,$a68f

; scene 5
BigCreditsTextPtrs5:
@9d50:  .addr   _a221,$9fb9,_a226,$9fff,_a22f,$a045,_a236,$a08b
        .addr   _a23d,$a0d1,_a247,$a117,_a24e,$a15d,_a257,$a1a3
        .addr   _a25f,$a1e9,_a264,$a22f,_a272,$a275,_a279,$a2bb
        .addr   _a27c,$a301,_a281,$a347
.if LANG_EN
        .addr   _a285,$a761,_a289,$a7a7
.endif
        .addr   _a298,$a38d,_a2a1,$a3d3,_a2aa,$a419,_a2b1,$a45f
        .addr   _a2b7,$a4a5,_a2c0,$a4eb,_a2c8,$a531,_a2cf,$a577
        .addr   _a2e1,$a649,_a2e8,$a68f,_a2ef,$a6d5,_a2f7,$a71b

; ------------------------------------------------------------------------------

; credits small text

; scene 1 (mode 7 airship)
; producer
SmallCreditsTextPtrs1:
@9dc0:  .addr   _9f98,$9d89

; scene 2 (tiny airship)
; director
; main programmer
SmallCreditsTextPtrs2:
@9dc4:  .addr   _9fb4,$9d89,_9fdc,$9dcf,_9fe1,$9e15,_a006,$9e5b
        .addr   _a00e,$9ea1,_a04c,$9ee7,_a060,$a5bd,_a066,$a603
        .addr   _a07d,$a649,_a084,$a68f

; scene 3
SmallCreditsTextPtrs3:
@9dec:  .addr   _a0aa,$9ea1,_a0da,$9d89,_a084,$9dcf,_a101,$9e15
        .addr   _9fe1,$9e5b,_a07d,$a68f

; scene 4
SmallCreditsTextPtrs4:
@9e04:  .addr   _a137,$9d89,_9fe1,$9dcf,_a101,$9e15,_a006,$9e5b
        .addr   _a149,$9ea1,_a0aa,$9ee7,_a1f1,$9f2d,_a201,$9f73

; scene 5
SmallCreditsTextPtrs5:
@9e24:  .addr   _a137,$9d89,_a218,$9dcf,_a101,$9e15,_a26b,$9e5b
        .addr   _a084,$9ea1,_a291,$9ee7,_a2d7,$9f2d,_9f98,$9f73
.if LANG_EN
        .addr   _a64f,$a7ed
.endif

; scene 6 (land with no sprites)
SmallCreditsTextPtrs6:
@9e48:  .addr   _a300,$9d89,_a305,$9dcf,_a359,$9e15,_a361,$9e5b
        .addr   _a368,$9ea1,_a311,$9f73,_a31c,$9fb9,_a324,$9fff
        .addr   _a32c,$a045,_a335,$a08b,_a33e,$a0d1,_a346,$a117
        .addr   _a350,$a15d,_a36b,$a1a3,_a376,$a1e9,_a382,$a22f
        .addr   _a38e,$a275,_a397,$a2bb,_a3a0,$a301,_a3a9,$a347
        .addr   _a3b5,$a38d,_a3be,$a3d3,_a3c8,$a419,_a408,$a45f
        .addr   _a40f,$a4a5,_a418,$a4eb,_a421,$a531,_a42d,$a577
        .addr   _a436,$a5bd,_a441,$a603,_a44a,$a649,_a451,$a68f
        .addr   _a459,$a6d5,_a51c,$ae7d,_a527,$aec3,_a530,$af09
        .addr   _a539,$a9d7,_a543,$aa1d,_a54f,$aa63
.if !LANG_EN
        .addr   _a52c,$aaa9
.endif
        .addr   _a558,$aaef
        .addr   _a561,$ab35,_a56b,$ab7b,_a4f5,$a991,_a466,$b021
        .addr   _a46f,$b067,_a47c,$b0ad,_a4fe,$b139,_a508,$b17f
        .addr   _a511,$b1c5,_a3d1,$b20b,_a3dc,$b251,_a3e4,$b297
        .addr   _a3ef,$b2dd,_a3f7,$b323,_a3ff,$b369,_a63c,$b4c7
        .addr   _a648,$b50d

; scene 7 (big airship)
SmallCreditsTextPtrs7:
@9f2c:  .addr   _a4a4,$a71b,_a4ab,$a761,_a4b2,$a7a7
.if LANG_EN
        .addr   _a486,$afdb,_a492,$b021,_a49c,$b067
.else
        .addr   _a486,$af4f,_a492,$af95,_a49c,$afdb
.endif
        .addr   _a4bb,$a7ed,_a4c4,$a833
        .addr   _a4cf,$a879,_a4d6,$a8bf,_a4e1,$a905,_a4ea,$a94b
        .addr   _a575,$abc1,_a583,$ac07,_a58f,$ac4d,_a59c,$ac93
        .addr   _a5ac,$acd9,_a5b9,$ad1f,_a5c4,$ad65,_a5d0,$adab
        .addr   _a5de,$adf1,_a5e9,$ae37
.if LANG_EN
        .addr   _a5f7,$ae7d,_a607,$aec3,_a615,$af09,_a621,$af4f
        .addr   _a631,$af95
.else
        .addr   _a5f7,$b3af,_a607,$b3f5,_a615,$b43b,_a621,$b481
.endif

; ------------------------------------------------------------------------------

; credits text (big and small text are mixed together)
; strings are (roughly) in the order that they are displayed, but
; repeated strings are re-used

.charmap 'A', $40
.charmap 'B', $42
.charmap 'C', $44
.charmap 'D', $46
.charmap 'E', $48
.charmap 'F', $4a
.charmap 'G', $4c
.charmap 'H', $4e
.charmap 'I', $60
.charmap 'J', $62
.charmap 'K', $64
.charmap 'L', $66
.charmap 'M', $68
.charmap 'N', $6a
.charmap 'O', $6c
.charmap 'P', $6e
.charmap 'Q', $80
.charmap 'R', $82
.charmap 'S', $84
.charmap 'T', $86
.charmap 'U', $88
.charmap 'V', $8a
.charmap 'W', $8c
.charmap 'X', $8e
.charmap 'Y', $a0
.charmap 'Z', $a2

.charmap 'a', $e0
.charmap 'b', $e1
.charmap 'c', $e2
.charmap 'd', $e3
.charmap 'e', $e4
.charmap 'f', $e5
.charmap 'g', $e6
.charmap 'h', $e7
.charmap 'i', $e8
.charmap 'j', $e9
.charmap 'k', $ea
.charmap 'l', $eb
.charmap 'm', $ec
.charmap 'n', $ed
.charmap 'o', $ee
.charmap 'p', $ef
.charmap 'q', $f0
.charmap 'r', $f1
.charmap 's', $f2
.charmap 't', $f3
.charmap 'u', $f4
.charmap 'v', $f5
.charmap 'w', $f6
.charmap 'x', $f7
.charmap 'y', $f8
.charmap 'z', $f9
.charmap '.', $fa
.charmap ' ', $fb

CreditsText:
_9f98:  .asciiz "producer"
_9fa1:  .asciiz "HIRONOBU"
_9faa:  .asciiz "SAKAGUCHI"
_9fb4:  .asciiz "director"
_9fbd:  .asciiz "YOSHINORI"
_9fc7:  .asciiz "KITASE"
_9fce:  .asciiz "HIROYUKI"
_9fd7:  .asciiz "ITOU"
_9fdc:  .asciiz "main"
_9fe1:  .asciiz "programmer"
_9fec:  .asciiz "KEN"
_9ff0:  .asciiz "NARITA"
_9ff7:  .asciiz "KIYOSHI"
_9fff:  .asciiz "YOSHII"
_a006:  .asciiz "graphic"
_a00e:  .asciiz "director"
_a017:  .asciiz "TETSUYA"
_a01f:  .asciiz "TAKAHASHI"
_a029:  .asciiz "KAZUKO"
_a030:  .asciiz "SHIBUYA"
_a038:  .asciiz "HIDEO"
_a03e:  .asciiz "MINABA"
_a045:  .asciiz "NOMURA"
_a04c:  .asciiz "music"
_a052:  .asciiz "NOBUO"
_a058:  .asciiz "UEMATSU"
_a060:  .asciiz "image"
_a066:  .asciiz "design"
_a06d:  .asciiz "YOSHITAKA"
_a077:  .asciiz "AMANO"
_a07d:  .asciiz "battle"
_a084:  .asciiz "planner"
_a08c:  .asciiz "YASUYUKI"
_a095:  .asciiz "HASEBE"
_a09c:  .asciiz "AKIYOSHI"
_a0a5:  .asciiz "OOTA"
_a0aa:  .asciiz "field"
_a0b0:  .asciiz "YOSHIHIKO"
_a0ba:  .asciiz "MAEKAWA"
_a0c2:  .asciiz "KEITA"
_a0c8:  .asciiz "ETOH"
_a0cd:  .asciiz "SATORU"
_a0d4:  .asciiz "TSUJI"
_a0da:  .asciiz "event"
_a0e0:  .asciiz "TSUKASA"
_a0e8:  .asciiz "FUJITA"
_a0ef:  .asciiz "KEISUKE"
_a0f7:  .asciiz "MATSUHARA"
_a101:  .asciiz "effect"
_a108:  .asciiz "HIROSHI"
_a110:  .asciiz "HARATA"
_a117:  .asciiz "SATOSHI"
_a11f:  .asciiz "OGATA"
_a125:  .asciiz "AKIHIRO"
_a12d:  .asciiz "YAMAGUCHI"
_a137:  .asciiz "sound"
_a13d:  .asciiz "MINORU"
_a144:  .asciiz "AKAO"
_a149:  .asciiz "designer"
_a152:  .asciiz "HIROKATSU"
_a15c:  .asciiz "SASAKI"
_a163:  .asciiz "TAKAHARU"
_a16c:  .asciiz "MATSUO"
_a173:  .asciiz "YUUSUKE"
_a17b:  .asciiz "NAORA"
_a181:  .asciiz "NOBUYUKI"
_a18a:  .asciiz "IKEDA"
_a190:  .asciiz "TOMOE"
_a196:  .asciiz "INAZAWA"
_a19e:  .asciiz "KAORI"
_a1a4:  .asciiz "TANAKA"
_a1ab:  .asciiz "TAKAMICHI"
_a1b5:  .asciiz "SHIBUYA"
_a1bd:  .asciiz "SINITIROU"
_a1c7:  .asciiz "HAMASAKA"
_a1d0:  .asciiz "AKIYOSHI"
_a1d9:  .asciiz "MASUDA"
_a1e0:  .asciiz "HIDETOSHI"
_a1ea:  .asciiz "KEZUKA"
_a1f1:  .asciiz "monster"
_a1f9:  .asciiz "HITOSHI"
_a201:  .asciiz "object"
_a208:  .asciiz "KAZUHIRO"
_a211:  .asciiz "OHKAWA"
_a218:  .asciiz "engineer"
_a221:  .asciiz "EIJI"
_a226:  .asciiz "NAKAMURA"
_a22f:  .asciiz "KAZUMI"
_a236:  .asciiz "MITOME"
_a23d:  .asciiz "YOSHITAKA"
_a247:  .asciiz "HIROTA"
_a24e:  .asciiz "YASUMASA"
_a257:  .asciiz "OKAMOTO"
_a25f:  .asciiz "SHUN"
_a264:  .asciiz "OHKUBO"
_a26b:  .asciiz "remake"
_a272:  .asciiz "WEIMIN"
_a279:  .asciiz "LI"
_a27c:  .asciiz "AIKO"
_a281:  .asciiz "ITO"
.if LANG_EN
_a285:  .asciiz "TED"
_a289:  .asciiz "WOOLSEY"
.endif
_a291:  .asciiz "system"
_a298:  .asciiz "MASAHIRO"
_a2a1:  .asciiz "NAKAJIMA"
_a2aa:  .asciiz "MITSUO"
_a2b1:  .asciiz "OGURA"
_a2b7:  .asciiz "YASUNORI"
_a2c0:  .asciiz "ORIKASA"
_a2c8:  .asciiz "YUTAKA"
_a2cf:  .asciiz "OHDAIRA"
_a2d7:  .asciiz "executive"
_a2e1:  .asciiz "TETSUO"
_a2e8:  .asciiz "MIZUNO"
_a2ef:  .asciiz "HITOSHI"
_a2f7:  .asciiz "TAKEMURA"
_a300:  .asciiz "test"
.if LANG_EN
_a305:  .asciiz "coordinator"
.else
_a305:  .asciiz "coordinater"           ; typo in the japanese version
.endif
_a311:  .asciiz "s.kajitani"
_a31c:  .asciiz "r.kouda"
_a324:  .asciiz "k.inagi"
_a32c:  .asciiz "n.hanada"
_a335:  .asciiz "h.masuda"
_a33e:  .asciiz "n.kanai"
_a346:  .asciiz "h.sakurai"
_a350:  .asciiz "h.suzuki"
_a359:  .asciiz "special"
_a361:  .asciiz "thanks"
_a368:  .asciiz "to"
_a36b:  .asciiz "m.miyamoto"
_a376:  .asciiz "k.torishima"
_a382:  .asciiz "h.hashimoto"
_a38e:  .asciiz "y.hirata"
_a397:  .asciiz "t.nomura"
_a3a0:  .asciiz "k.sousui"
_a3a9:  .asciiz "t.tsuruzono"
_a3b5:  .asciiz "y.ishida"
_a3be:  .asciiz "m.okamiya"
_a3c8:  .asciiz "k.hirata"
_a3d1:  .asciiz "n.watanabe"
_a3dc:  .asciiz "k.maeda"
_a3e4:  .asciiz "k.tanikawa"
_a3ef:  .asciiz "j.saito"
_a3f7:  .asciiz "m.denno"
_a3ff:  .asciiz "s.hidaki"
_a408:  .asciiz "k.oogo"
_a40f:  .asciiz "h.suzuki"
_a418:  .asciiz "h.yokota"
_a421:  .asciiz "k.yamashita"
_a42d:  .asciiz "m.yumoto"
_a436:  .asciiz "n.ishikawa"
_a441:  .asciiz "h.kizuka"
_a44a:  .asciiz "s.arai"
_a451:  .asciiz "m.kouno"
_a459:  .asciiz "r.tsukakoshi"
_a466:  .asciiz "k.kaneko"
_a46f:  .asciiz "h.shimodaira"
_a47c:  .asciiz "m.noumura"
_a486:  .asciiz "m.kaneshige"
_a492:  .asciiz "h.noguchi"
_a49c:  .asciiz "m.horie"
_a4a4:  .asciiz "m.mori"
_a4ab:  .asciiz "t.ohno"
_a4b2:  .asciiz "m.someno"
_a4bb:  .asciiz "t.morita"
_a4c4:  .asciiz "y.suemitsu"
_a4cf:  .asciiz "w.sato"
_a4d6:  .asciiz "h.nakamura"
_a4e1:  .asciiz "s.aoyama"
_a4ea:  .asciiz "h.nagahara"
_a4f5:  .asciiz "k.adachi"
_a4fe:  .asciiz "y.uenishi"
_a508:  .asciiz "y.ohkawa"
_a511:  .asciiz "y.kuwahara"
_a51c:  .asciiz "k.miyamoto"
_a527:  .asciiz "h.suzuki"
_a530:  .asciiz "a.kawazu"
_a539:  .asciiz "c.fujioka"
_a543:  .asciiz "h.kobayashi"
_a54f:  .asciiz "h.tanaka"
.if !LANG_EN
_a52c:  .asciiz "t.horii"
.endif
_a558:  .asciiz "t.mikasa"
_a561:  .asciiz "h.nishida"
_a56b:  .asciiz "t.takechi"
.if LANG_EN
_a575:  .asciiz "rich silveira"
_a583:  .asciiz "toshi horii"
_a58f:  .asciiz "j.yanagihara"
_a59c:  .asciiz "nathan williams"
_a5ac:  .asciiz "james gillis"
_a5b9:  .asciiz "chris budd"
_a5c4:  .asciiz "mike markey"
_a5d0:  .asciiz "mirko freguia"
_a5de:  .asciiz "doug smith"
_a5e9:  .asciiz "dalen abraham"
_a5f7:  .asciiz "rebecca coffman"
_a607:  .asciiz "brian fehdrau"
_a615:  .asciiz "jeff petkau"
_a621:  .asciiz "george sinfield"
_a631:  .asciiz "alan weiss"
.else
_a575:  .asciiz "t.miyake"
_a583:  .asciiz "m.oohara"
_a58f:  .asciiz "f.nishikawa"
_a59c:  .asciiz "a.takahashi"
_a5ac:  .asciiz "m.nagai"
_a5b9:  .asciiz "y.koyama"
_a5c4:  .asciiz "k.shinoda"

_a5d0:  .asciiz "t.kondo"
_a5de:  .asciiz "h.kasuga"
_a5e9:  .asciiz "t.tsuyuzaki"
_a5f7:  .asciiz "j.chihara"
_a607:  .asciiz "t.yamazaki"
_a615:  .asciiz "r.sakakibara"
_a621:  .asciiz "n.shimamura"

.endif

_a63c:  .asciiz "y.matsumura"
_a648:  .asciiz "a.ueda"

.if LANG_EN
_a64f:  .asciiz "translator"
.endif

; ------------------------------------------------------------------------------

.segment "ending_anim2"

; ------------------------------------------------------------------------------

; helmet eyes animation data (Gogo's ending scene)
GogoGlimmerAnim:
@f450:  .addr   GogoGlimmerSprite
        .byte   $fe

; helmet eyes sprite data
GogoGlimmerSprite:
@f453:  .byte   1
        .byte   $00,$00,$6c,$38

; ------------------------------------------------------------------------------

; mini-moogle animation data (Umaro's ending scene)
UmaroMiniMoogleAnim1:
@f458:  .addr   UmaroMiniMoogleSprite_00
        .byte   $04
        .addr   UmaroMiniMoogleSprite_02
        .byte   $04
        .addr   UmaroMiniMoogleSprite_04
        .byte   $04
        .addr   UmaroMiniMoogleSprite_05
        .byte   $04
        .addr   UmaroMiniMoogleSprite_06
        .byte   $04
        .addr   UmaroMiniMoogleSprite_0e
        .byte   $04
        .addr   UmaroMiniMoogleSprite_0d
        .byte   $04
        .addr   UmaroMiniMoogleSprite_0a
        .byte   $04
        .addr   UmaroMiniMoogleSprite_0a
        .byte   $ff

UmaroMiniMoogleAnim2:
@f473:  .addr   UmaroMiniMoogleSprite_0a
        .byte   $04
        .addr   UmaroMiniMoogleSprite_0b
        .byte   $04
        .addr   UmaroMiniMoogleSprite_0b
        .byte   $ff

UmaroMiniMoogleAnim3:
@f47c:  .addr   UmaroMiniMoogleSprite_04
        .byte   $fe

UmaroMiniMoogleAnim4:
@f47f:  .addr   UmaroMiniMoogleSprite_07
        .byte   $50
        .addr   UmaroMiniMoogleSprite_08
        .byte   $fe

UmaroMiniMoogleAnim5:
@f485:  .addr   UmaroMiniMoogleSprite_06
        .byte   $3c
        .addr   UmaroMiniMoogleSprite_08
        .byte   $fe

UmaroMiniMoogleAnim6:
@f48b:  .addr   UmaroMiniMoogleSprite_06
        .byte   $28
        .addr   UmaroMiniMoogleSprite_08
        .byte   $fe

UmaroMiniMoogleAnim7:
@f491:  .addr   UmaroMiniMoogleSprite_06
        .byte   $14
        .addr   UmaroMiniMoogleSprite_08
        .byte   $fe

UmaroMiniMoogleSprite_00:
@f497:  .byte   2
        .byte   00,$00,$50,$38
        .byte   00,$08,$58,$38

; unused
UmaroMiniMoogleSprite_01:
@f4a0:  .byte   2
        .byte   00,$00,$51,$38
        .byte   00,$08,$59,$38

UmaroMiniMoogleSprite_02:
@f4a9:  .byte   2
        .byte   00,$00,$52,$38
        .byte   00,$08,$5a,$38

; unused
UmaroMiniMoogleSprite_03:
@f4b2:  .byte   2
        .byte   00,$00,$53,$38
        .byte   00,$08,$5b,$38

UmaroMiniMoogleSprite_04:
@f4bb:  .byte   2
        .byte   00,$00,$54,$38
        .byte   00,$08,$5a,$38

UmaroMiniMoogleSprite_05:
@f4c4:  .byte   2
        .byte   00,$00,$55,$38
        .byte   00,$08,$5a,$38

UmaroMiniMoogleSprite_06:
@f4cd:  .byte   2
        .byte   00,$00,$56,$38
        .byte   00,$08,$5e,$38

UmaroMiniMoogleSprite_07:
@f4d6:  .byte   2
        .byte   00,$00,$57,$38
        .byte   00,$08,$58,$38

UmaroMiniMoogleSprite_08:
@f4df:  .byte   2
        .byte   00,$08,$5c,$38
        .byte   08,$08,$5d,$38

; unused
UmaroMiniMoogleSprite_09:
@f4e8:  .byte   2
        .byte   00,$00,$60,$38
        .byte   00,$08,$61,$38

UmaroMiniMoogleSprite_0a:
@f4f1:  .byte   2
        .byte   00,$00,$52,$78
        .byte   00,$08,$5a,$78

UmaroMiniMoogleSprite_0b:
@f4fa:  .byte   2
        .byte   00,$00,$53,$78
        .byte   00,$08,$5b,$78

UmaroMiniMoogleSprite_0d:
@f503:  .byte   2
        .byte   00,$00,$54,$78
        .byte   00,$08,$5a,$78

UmaroMiniMoogleSprite_0e:
@f50c:  .byte   2
        .byte   00,$00,$55,$78
        .byte   00,$08,$5a,$78

; ------------------------------------------------------------------------------

; mini-moogle animation data (Mog's ending scene)
MogMiniMoogleAnim:
@f515:  .addr   MogMiniMoogleSprite1
        .byte   $04
        .addr   MogMiniMoogleSprite2
        .byte   $04
        .addr   MogMiniMoogleSprite3
        .byte   $04
        .addr   MogMiniMoogleSprite4
        .byte   $04
        .addr   MogMiniMoogleSprite3
        .byte   $04
        .addr   MogMiniMoogleSprite2
        .byte   $04
        .addr   MogMiniMoogleSprite1
        .byte   $ff

MogMiniMoogleSprite1:
@f52a:  .byte   4
        .byte   $00,$00,$62,$38
        .byte   $08,$00,$63,$38
        .byte   $00,$08,$64,$38
        .byte   $08,$08,$65,$38

MogMiniMoogleSprite2:
@f53b:  .byte   3
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$67,$38
        .byte   $08,$08,$68,$38

MogMiniMoogleSprite3:
@f548:  .byte   3
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$69,$38
        .byte   $08,$08,$6a,$38

MogMiniMoogleSprite4:
@f555:  .byte   2
        .byte   $00,$00,$66,$38
        .byte   $08,$00,$6b,$38

; ------------------------------------------------------------------------------

; y-offset for jumping mini-moogle
MiniMoogleJumpOffset:
@f55e:  .byte   $fe,$fe,$fe,$ff,$ff,$ff,$00,$00,$01,$01,$02,$02,$03,$03,$04,$04

; ------------------------------------------------------------------------------

; skull animation data (Umaro's ending scene)
UmaroSkullAnim:
@f56e:  .addr   UmaroSkullSprite_00
        .byte   $b4
        .addr   UmaroSkullSprite_00
        .byte   $b4
        .addr   UmaroSkullSprite_00
        .byte   $3c
        .addr   UmaroSkullSprite_01
        .byte   $fe

UmaroSkullSprite_00:
@f57a:  .byte   6
        .byte   $00,$00,$80,$38
        .byte   $08,$00,$81,$38
        .byte   $00,$08,$82,$38
        .byte   $08,$08,$83,$38
        .byte   $00,$10,$86,$38
        .byte   $08,$10,$87,$38

UmaroSkullSprite_01:
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

; pendant/paintbrush glimmer animation data (Terra and Relm's ending scenes)
TerraPendantAnim:
@f5b4:  .addr   EndingBlankSprite
        .byte   $10
        .addr   TerraPendantSprite_00
        .byte   $04
        .addr   TerraPendantSprite_01
        .byte   $04
        .addr   TerraPendantSprite_03
        .byte   $04
        .addr   TerraPendantSprite_04
        .byte   $04
        .addr   TerraPendantSprite_05
        .byte   $04
        .addr   TerraPendantSprite_04
        .byte   $04
        .addr   TerraPendantSprite_03
        .byte   $04
        .addr   TerraPendantSprite_01
        .byte   $04
        .addr   TerraPendantSprite_00
        .byte   $04
        .addr   EndingBlankSprite
        .byte   $fe

TerraPendantSprite_00:
@f5d5:  .byte   1
        .byte   $04,$04,$4c,$38

TerraPendantSprite_01:
@f5da:  .byte   1
        .byte   $04,$04,$4d,$38

TerraPendantSprite_03:
@f5df:  .byte   1
        .byte   $04,$04,$4e,$38

TerraPendantSprite_04:
@f5e4:  .byte   4
        .byte   $00,$00,$4f,$38
        .byte   $08,$00,$6d,$38
        .byte   $00,$08,$6e,$38
        .byte   $08,$08,$6f,$38

TerraPendantSprite_05:
@f5f5:  .byte   1
        .byte   $04,$04,$4e,$78

; ------------------------------------------------------------------------------

; katana animation data (Cyan's ending scene)
CyanKatanaAnim:
@f5fa:  .addr   CyanKatanaSprite_00
        .byte   $04
        .addr   CyanKatanaSprite_01
        .byte   $04
        .addr   CyanKatanaSprite_03
        .byte   $04
        .addr   CyanKatanaSprite_04
        .byte   $04
        .addr   CyanKatanaSprite_03
        .byte   $04
        .addr   CyanKatanaSprite_01
        .byte   $04
        .addr   CyanKatanaSprite_00
        .byte   $04
        .addr   EndingBlankSprite
        .byte   $fe

EndingBlankSprite:
@f612:  .byte   0

CyanKatanaSprite_00:
@f613:  .byte   1
        .byte   $08,$08,$44,$38

CyanKatanaSprite_01:
@f618:  .byte   1
        .byte   $08,$08,$45,$38

CyanKatanaSprite_03:
@f61d:  .byte   5
        .byte   $08,$00,$46,$38
        .byte   $00,$08,$47,$38
        .byte   $08,$08,$48,$38
        .byte   $10,$08,$47,$78
        .byte   $08,$10,$46,$b8

CyanKatanaSprite_04:
@f632:  .byte   5
        .byte   $08,$00,$49,$38
        .byte   $00,$08,$4a,$38
        .byte   $08,$08,$4b,$38
        .byte   $10,$08,$4a,$78
        .byte   $08,$10,$49,$b8

; ------------------------------------------------------------------------------

; helmet eyes animation data (Gau's ending scene)
GauEyesAnim:
@f647:  .addr   EndingBlankSprite
        .byte   $b4
        .addr   GauEyesSprite_03
        .byte   $02
        .addr   GauEyesSprite_02
        .byte   $02
        .addr   GauEyesSprite_01
        .byte   $02
        .addr   GauEyesSprite_00
        .byte   $0a
        .addr   GauEyesSprite_01
        .byte   $02
        .addr   GauEyesSprite_02
        .byte   $02
        .addr   GauEyesSprite_03
        .byte   $01
        .addr   GauEyesSprite_02
        .byte   $01
        .addr   GauEyesSprite_01
        .byte   $01
        .addr   GauEyesSprite_00
        .byte   $1e
        .addr   GauEyesSprite_01
        .byte   $02
        .addr   GauEyesSprite_02
        .byte   $02
        .addr   GauEyesSprite_03
        .byte   $01
        .addr   GauEyesSprite_02
        .byte   $01
        .addr   GauEyesSprite_01
        .byte   $01
        .addr   GauEyesSprite_00
        .byte   $1e
        .addr   GauEyesSprite_01
        .byte   $04
        .addr   GauEyesSprite_02
        .byte   $04
        .addr   GauEyesSprite_03
        .byte   $02
        .addr   GauEyesSprite_04
        .byte   $04
        .addr   GauEyesSprite_05
        .byte   $04
        .addr   GauEyesSprite_06
        .byte   $04
        .addr   GauEyesSprite_07
        .byte   $04
        .addr   GauEyesSprite_06
        .byte   $04
        .addr   GauEyesSprite_05
        .byte   $04
        .addr   GauEyesSprite_04
        .byte   $04
        .addr   GauEyesSprite_03
        .byte   $02
        .addr   GauEyesSprite_03
        .byte   $fe

GauEyesSprite_00:
@f69e:  .byte   2
        .byte   $00,$00,$00,$38
        .byte   $08,$00,$00,$78

GauEyesSprite_01:
@f6a7:  .byte   2
        .byte   $00,$00,$01,$38
        .byte   $08,$00,$01,$78

GauEyesSprite_02:
@f6b0:  .byte   2
        .byte   $00,$00,$02,$38
        .byte   $08,$00,$02,$78

GauEyesSprite_03:
@f6b9:  .byte   2
        .byte   $00,$00,$03,$38
        .byte   $08,$00,$03,$78

GauEyesSprite_04:
@f6c2:  .byte   4
        .byte   $00,$00,$04,$38
        .byte   $08,$00,$04,$78
        .byte   $00,$08,$05,$38
        .byte   $08,$08,$05,$78

GauEyesSprite_05:
@f6d3:  .byte   4
        .byte   $00,$00,$06,$38
        .byte   $08,$00,$06,$78
        .byte   $00,$08,$07,$38
        .byte   $08,$08,$07,$78

GauEyesSprite_06:
@f6e4:  .byte   4
        .byte   $00,$00,$08,$38
        .byte   $08,$00,$08,$78
        .byte   $00,$08,$09,$38
        .byte   $08,$08,$09,$78

GauEyesSprite_07:
@f6f5:  .byte   4
        .byte   $00,$00,$0a,$38
        .byte   $08,$00,$0a,$78
        .byte   $00,$08,$0b,$38
        .byte   $08,$08,$0b,$78

; ------------------------------------------------------------------------------

; bird 1
_cff706:
@f706:  .addr   _cff715
        .byte   $08
        .addr   _cff71a
        .byte   $08
        .addr   _cff71f
        .byte   $08
        .addr   _cff724
        .byte   $08
        .addr   _cff724
        .byte   $ff

_cff715:
@f715:  .byte   1
        .byte   $00,$00,$06,$34

_cff71a:
@f71a:  .byte   1
        .byte   $00,$00,$07,$34

_cff71f:
@f71f:  .byte   1
        .byte   $00,$00,$16,$34

_cff724:
@f724:  .byte   1
        .byte   $00,$00,$17,$34

; ------------------------------------------------------------------------------

; bird 2
_cff729:
@f729:  .addr   _cff738
        .byte   $08
        .addr   _cff73d
        .byte   $08
        .addr   _cff738
        .byte   $08
        .addr   _cff742
        .byte   $08
        .addr   _cff742
        .byte   $ff

_cff738:
@f738:  .byte   1
        .byte   $00,$00,$6a,$34

_cff73d:
@f73d:  .byte   1
        .byte   $00,$00,$6b,$34

_cff742:
@f742:  .byte   1
        .byte   $00,$00,$7a,$34

; ------------------------------------------------------------------------------

; bird 3
_cff747:
@f747:  .addr   _cff74a
        .byte   $fe

_cff74a:
@f74a:  .byte   1
        .byte   $00,$00,$7b,$34

; ------------------------------------------------------------------------------

; bird 4
_cff74f:
@f74f:  .addr   _cff75e
        .byte   $08
        .addr   _cff763
        .byte   $08
        .addr   _cff768
        .byte   $08
        .addr   _cff76d
        .byte   $08
        .addr   _cff76d
        .byte   $ff

_cff75e:
@f75e:  .byte   1
        .byte   $00,$00,$6e,$3c

_cff763:
@f763:  .byte   1
        .byte   $00,$00,$6f,$3c

_cff768:
@f768:  .byte   1
        .byte   $00,$00,$7e,$3c

_cff76d:
@f76d:  .byte   1
        .byte   $00,$00,$7f,$3c

; ------------------------------------------------------------------------------

; bird 5
_cff772:
@f772:  .addr   _cff781
        .byte   $08
        .addr   _cff78a
        .byte   $08
        .addr   _cff793
        .byte   $08
        .addr   _cff7a4
        .byte   $08
        .addr   _cff7a4
        .byte   $ff

_cff781:
@f781:  .byte   2
        .byte   $00,$00,$60,$3c
        .byte   $08,$00,$61,$3c

_cff78a:
@f78a:  .byte   2
        .byte   $00,$00,$62,$3c
        .byte   $08,$00,$63,$3c

_cff793:
@f793:  .byte   4
        .byte   $00,$00,$64,$3c
        .byte   $08,$00,$65,$3c
        .byte   $00,$08,$3c,$3c
        .byte   $08,$08,$3d,$3c

_cff7a4:
@f7a4:  .byte   4
        .byte   $00,$00,$66,$3c
        .byte   $08,$00,$67,$3c
        .byte   $00,$08,$3e,$3c
        .byte   $08,$08,$3f,$3c

; ------------------------------------------------------------------------------

; birds for ending scene with ship
ShipBirdsAnim:
@f7b5:  .addr   _cff706
        .byte   $f0
        .byte   $18
        .addr   _cff729
        .byte   $20
        .byte   $70
        .addr   _cff74f
        .byte   $b0
        .byte   $68
        .addr   _cff74f
        .byte   $c8
        .byte   $50
        .addr   _cff706
        .byte   $28
        .byte   $40
        .addr   _cff772
        .byte   $58
        .byte   $a0

_cff7cd:
@f7cd:  .addr   _cff706
        .byte   $f0
        .byte   $18
        .addr   _cff729
        .byte   $20
        .byte   $70
        .addr   _cff74f
        .byte   $b0
        .byte   $68
        .addr   _cff74f
        .byte   $c8
        .byte   $50
        .addr   _cff706
        .byte   $28
        .byte   $40
        .addr   _cff772
        .byte   $50
        .byte   $50

_cff7e5:
@f7e5:  .addr   _cff729
        .byte   $a0
        .byte   $50
        .addr   _cff74f
        .byte   $20
        .byte   $60
        .addr   _cff74f
        .byte   $c0
        .byte   $78
        .addr   _cff74f
        .byte   $d0
        .byte   $48
        .addr   _cff706
        .byte   $28
        .byte   $70
        .addr   _cff74f
        .byte   $50
        .byte   $60

; ------------------------------------------------------------------------------

; ship animation data
_cff7fd:
@f7fd:  .addr   _cff815
        .byte   $08
        .addr   _cff847
        .byte   $08
        .addr   _cff879
        .byte   $08
        .addr   _cff879
        .byte   $ff

; ship animation data
_cff809:
@f809:  .addr   _cff82e
        .byte   $08
        .addr   _cff860
        .byte   $08
        .addr   _cff892
        .byte   $08
        .addr   _cff892
        .byte   $ff

_cff815:
@f815:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$28,$74
        .byte   $00,$10,$29,$74

_cff82e:
@f82e:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

_cff847:
@f847:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$2c,$74
        .byte   $00,$10,$2d,$74

_cff860:
@f860:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

_cff879:
@f879:  .byte   6
        .byte   $08,$00,$24,$74
        .byte   $00,$00,$25,$74
        .byte   $08,$08,$34,$74
        .byte   $00,$08,$35,$74
        .byte   $08,$10,$2e,$74
        .byte   $00,$10,$2f,$74

_cff892:
@f892:  .byte   6
        .byte   $08,$00,$26,$74
        .byte   $00,$00,$27,$74
        .byte   $08,$08,$36,$74
        .byte   $00,$08,$37,$74
        .byte   $08,$10,$2a,$74
        .byte   $00,$10,$2b,$74

; ------------------------------------------------------------------------------

; "And you" animation data
AndYouAnim:
@f8ab:  .addr   AndYouSprite
        .byte   $fe

AndYouSprite:
@f8ae:  .byte   $18                     ; should be $0c ???
        .byte   $00,$08,$00,$31
        .byte   $00,$10,$10,$31
        .byte   $08,$08,$0d,$31
        .byte   $08,$10,$1d,$31
        .byte   $10,$08,$03,$31
        .byte   $10,$10,$13,$31
        .byte   $20,$08,$28,$31
        .byte   $20,$10,$38,$31
        .byte   $28,$08,$0e,$31
        .byte   $28,$10,$1e,$31
        .byte   $30,$08,$24,$31
        .byte   $30,$10,$34,$31

; ------------------------------------------------------------------------------

; character graphics pose offsets
MenuCharPoseOffsets:
@f8df:  .word   $03c0
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
        .word   $3a00
        .word   $3a80
        .word   $3c00
        .word   $3c80
        .word   $3e00
        .word   $3e80
        .word   $3040
        .word   $30c0
        .word   $3240
        .word   $32c0
        .word   $3440
        .word   $34c0

; ------------------------------------------------------------------------------

.include "gfx/map_sprite_gfx.inc"

; pointers to character graphics
MenuCharGfxPtrs:
.repeat 22, i
        .word   .bankbyte(array_item MapSpriteGfx, i)
        .addr   array_item MapSpriteGfx, i
.endrep

; ------------------------------------------------------------------------------

; airship/clouds palette assignment
_cff969:
@f969:  .byte   3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1
        .byte   3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1
        .byte   3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1
        .byte   1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        .byte   1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        .byte   1,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3
        .byte   3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
        .byte   3,3,3,3,3,3,3,0

; land/sea palette assignment
_cff9e1:
@f9e1:  .byte   7,7,7,7,2,2,2,2,7,7,7,7,4,4,4,4
        .byte   7,7,7,7,2,2,2,2,7,7,7,7,4,4,4,4
        .byte   7,7,7,7,2,2,2,2,7,7,7,7,4,4,4,4
        .byte   7,7,7,7,2,2,2,2,7,7,7,7,4,4,4,4
        .byte   4,4,4,4,4,4,4,4,6,7,7,7,7,6,6,6
        .byte   4,4,4,4,4,4,4,4,7,7,7,7,7,7,6,6
        .byte   4,4,4,4,4,4,4,4,7,7,7,7,7,7,6,6
        .byte   4,4,4,4,4,4,4,4,6,7,7,7,7,6,6,6
        .byte   6,6,6,6,6,6,6,6,6,6,6,6,4,4,6,6
        .byte   6,6,6,6,6,6,6,6,6,6,6,6,4,4,6,6
        .byte   6,6,6,6,6,6,6,4,4,4,4,6,6,4,2,2
        .byte   6,6,6,6,6,6,6,6,6,6,6,6,2,2,2,2
        .byte   2,2,2,2,2,2,2,0

; ------------------------------------------------------------------------------

_cffaa9:
@faa9:  .byte   $00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$80,$00,$00,$00,$c0,$00
        .byte   $00,$00,$00,$20,$00,$00,$40,$20,$00,$00,$80,$20,$00,$00,$c0,$20

_cffac9:
@fac9:  .byte   $00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$80,$00,$00,$00,$c0,$00
        .byte   $00,$00,$00,$20,$00,$04,$40,$20,$00,$00,$80,$20,$00,$00,$c0,$20

_cffae9:
@fae9:  .byte   $00,$00,$00,$00,$00,$04,$40,$00,$00,$00,$80,$00,$00,$04,$c0,$00
        .byte   $00,$08,$00,$20,$00,$0c,$40,$20,$00,$08,$80,$20,$00,$0c,$c0,$20

_cffb09:
@fb09:  .byte   $00,$04,$00,$00,$00,$04,$40,$00,$00,$04,$80,$00,$00,$04,$c0,$00
        .byte   $00,$00,$00,$20,$00,$00,$40,$20,$00,$00,$80,$20,$00,$00,$c0,$20

; ------------------------------------------------------------------------------
