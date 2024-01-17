
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/world_anim.asm                                                 |
; |                                                                            |
; | description: world map animation data                                      |
; |                                                                            |
; | created: 5/16/2023                                                         |
; +----------------------------------------------------------------------------+

; animation data format is 1 byte for the number of sprites in a frame,
; followed by 4 bytes per sprite in the standard sprite format:
;   $00: x position
;   $01: y position
;   $02: tile index
;   $03: vhoopppm
;          v: vertical flip
;          h: horizontal flip
;          o: layer priority
;          p: palette index
;          m: MSB of tile index

; ------------------------------------------------------------------------------

; pointers to animation sprite data
WorldAnimSpritePtrs:
@573e:
.repeat $6c, i
        .addr   .ident(.sprintf("WorldAnimSprite_%02x", i)) - WorldAnimSprites
.endrep

; ------------------------------------------------------------------------------

; animation sprite data
WorldAnimSprites:

; ------------------------------------------------------------------------------

; $00: no animation
WorldAnimSprite_00:

; ------------------------------------------------------------------------------

; $01-$12: airship
WorldAnimSprite_01:
@5816:  .byte   12
        .byte   $f4,$f0,$40,$10
        .byte   $fc,$f0,$41,$10
        .byte   $04,$f0,$40,$50
        .byte   $f4,$f8,$50,$10
        .byte   $fc,$f8,$51,$10
        .byte   $04,$f8,$50,$50
        .byte   $f4,$00,$42,$10
        .byte   $fc,$00,$43,$10
        .byte   $04,$00,$42,$50
        .byte   $f4,$08,$52,$10
        .byte   $fc,$08,$53,$10
        .byte   $04,$08,$52,$50

WorldAnimSprite_02:
@5847:  .byte   12
        .byte   $f4,$f0,$44,$10
        .byte   $fc,$f0,$45,$10
        .byte   $04,$f0,$44,$50
        .byte   $f4,$f8,$54,$10
        .byte   $fc,$f8,$55,$10
        .byte   $04,$f8,$54,$50
        .byte   $f4,$00,$46,$10
        .byte   $fc,$00,$47,$10
        .byte   $04,$00,$46,$50
        .byte   $f4,$08,$56,$10
        .byte   $fc,$08,$57,$10
        .byte   $04,$08,$56,$50

WorldAnimSprite_03:
@5878:  .byte   12
        .byte   $f4,$f0,$48,$10
        .byte   $fc,$f0,$49,$10
        .byte   $04,$f0,$4c,$10
        .byte   $f4,$f8,$58,$10
        .byte   $fc,$f8,$59,$10
        .byte   $04,$f8,$5c,$10
        .byte   $f4,$00,$4a,$10
        .byte   $fc,$00,$4b,$10
        .byte   $04,$00,$4d,$10
        .byte   $f4,$08,$5a,$10
        .byte   $fc,$08,$5b,$10
        .byte   $04,$08,$5d,$10

WorldAnimSprite_04:
@58a9:  .byte   12
        .byte   $f4,$f0,$4e,$10
        .byte   $fc,$f0,$4f,$10
        .byte   $04,$f0,$62,$10
        .byte   $f4,$f8,$5e,$10
        .byte   $fc,$f8,$5f,$10
        .byte   $04,$f8,$72,$10
        .byte   $f4,$00,$60,$10
        .byte   $fc,$00,$61,$10
        .byte   $04,$00,$63,$10
        .byte   $f4,$08,$70,$10
        .byte   $fc,$08,$71,$10
        .byte   $04,$08,$73,$10

WorldAnimSprite_05:
@58da:  .byte   12
        .byte   $f4,$f0,$4c,$50
        .byte   $fc,$f0,$49,$50
        .byte   $04,$f0,$48,$50
        .byte   $f4,$f8,$5c,$50
        .byte   $fc,$f8,$59,$50
        .byte   $04,$f8,$58,$50
        .byte   $f4,$00,$4d,$50
        .byte   $fc,$00,$4b,$50
        .byte   $04,$00,$4a,$50
        .byte   $f4,$08,$5d,$50
        .byte   $fc,$08,$5b,$50
        .byte   $04,$08,$5a,$50

WorldAnimSprite_06:
@590b:  .byte   12
        .byte   $f4,$f0,$62,$50
        .byte   $fc,$f0,$4f,$50
        .byte   $04,$f0,$4e,$50
        .byte   $f4,$f8,$72,$50
        .byte   $fc,$f8,$5f,$50
        .byte   $04,$f8,$5e,$50
        .byte   $f4,$00,$63,$50
        .byte   $fc,$00,$61,$50
        .byte   $04,$00,$60,$50
        .byte   $f4,$08,$73,$50
        .byte   $fc,$08,$71,$50
        .byte   $04,$08,$70,$50

WorldAnimSprite_07:
@593c:  .byte   12
        .byte   $f4,$f0,$64,$10
        .byte   $fc,$f0,$65,$10
        .byte   $04,$f0,$64,$50
        .byte   $f4,$f8,$74,$10
        .byte   $fc,$f8,$75,$10
        .byte   $04,$f8,$74,$50
        .byte   $f4,$00,$66,$10
        .byte   $fc,$00,$67,$10
        .byte   $04,$00,$66,$50
        .byte   $f4,$08,$76,$10
        .byte   $fc,$08,$77,$10
        .byte   $04,$08,$76,$50

WorldAnimSprite_08:
@596d:  .byte   12
        .byte   $f4,$f0,$68,$10
        .byte   $fc,$f0,$69,$10
        .byte   $04,$f0,$68,$50
        .byte   $f4,$f8,$78,$10
        .byte   $fc,$f8,$79,$10
        .byte   $04,$f8,$78,$50
        .byte   $f4,$00,$6a,$10
        .byte   $fc,$00,$6b,$10
        .byte   $04,$00,$6a,$50
        .byte   $f4,$08,$7a,$10
        .byte   $fc,$08,$7b,$10
        .byte   $04,$08,$7a,$50

WorldAnimSprite_09:
@599e:  .byte   12
        .byte   $f4,$f0,$6c,$10
        .byte   $fc,$f0,$6d,$10
        .byte   $04,$f0,$80,$10
        .byte   $f4,$f8,$7c,$10
        .byte   $fc,$f8,$7d,$10
        .byte   $04,$f8,$90,$10
        .byte   $f4,$00,$6e,$10
        .byte   $fc,$00,$6f,$10
        .byte   $04,$00,$81,$10
        .byte   $f4,$08,$7e,$10
        .byte   $fc,$08,$7f,$10
        .byte   $04,$08,$91,$10

WorldAnimSprite_0a:
@59cf:  .byte   12
        .byte   $f4,$f0,$82,$10
        .byte   $fc,$f0,$83,$10
        .byte   $04,$f0,$86,$10
        .byte   $f4,$f8,$92,$10
        .byte   $fc,$f8,$93,$10
        .byte   $04,$f8,$96,$10
        .byte   $f4,$00,$84,$10
        .byte   $fc,$00,$85,$10
        .byte   $04,$00,$87,$10
        .byte   $f4,$08,$94,$10
        .byte   $fc,$08,$95,$10
        .byte   $04,$08,$97,$10

WorldAnimSprite_0b:
@5a00:  .byte   12
        .byte   $f4,$f0,$80,$50
        .byte   $fc,$f0,$6d,$50
        .byte   $04,$f0,$6c,$50
        .byte   $f4,$f8,$90,$50
        .byte   $fc,$f8,$7d,$50
        .byte   $04,$f8,$7c,$50
        .byte   $f4,$00,$81,$50
        .byte   $fc,$00,$6f,$50
        .byte   $04,$00,$6e,$50
        .byte   $f4,$08,$91,$50
        .byte   $fc,$08,$7f,$50
        .byte   $04,$08,$7e,$50

WorldAnimSprite_0c:
@5a31:  .byte   12
        .byte   $f4,$f0,$86,$50
        .byte   $fc,$f0,$83,$50
        .byte   $04,$f0,$82,$50
        .byte   $f4,$f8,$96,$50
        .byte   $fc,$f8,$93,$50
        .byte   $04,$f8,$92,$50
        .byte   $f4,$00,$87,$50
        .byte   $fc,$00,$85,$50
        .byte   $04,$00,$84,$50
        .byte   $f4,$08,$97,$50
        .byte   $fc,$08,$95,$50
        .byte   $04,$08,$94,$50

WorldAnimSprite_0d:
@5a62:  .byte   12
        .byte   $f4,$f0,$88,$10
        .byte   $fc,$f0,$89,$10
        .byte   $04,$f0,$88,$50
        .byte   $f4,$f8,$98,$10
        .byte   $fc,$f8,$99,$10
        .byte   $04,$f8,$98,$50
        .byte   $f4,$00,$8a,$10
        .byte   $fc,$00,$8b,$10
        .byte   $04,$00,$8a,$50
        .byte   $f4,$08,$9a,$10
        .byte   $fc,$08,$9b,$10
        .byte   $04,$08,$9a,$50

WorldAnimSprite_0e:
@5a93:  .byte   12
        .byte   $f4,$f0,$8c,$10
        .byte   $fc,$f0,$8d,$10
        .byte   $04,$f0,$8c,$50
        .byte   $f4,$f8,$9c,$10
        .byte   $fc,$f8,$9d,$10
        .byte   $04,$f8,$9c,$50
        .byte   $f4,$00,$8e,$10
        .byte   $fc,$00,$8f,$10
        .byte   $04,$00,$8e,$50
        .byte   $f4,$08,$9e,$10
        .byte   $fc,$08,$9f,$10
        .byte   $04,$08,$9e,$50

WorldAnimSprite_0f:
@5ac4:  .byte   12
        .byte   $f4,$f0,$a0,$10
        .byte   $fc,$f0,$a1,$10
        .byte   $04,$f0,$a4,$10
        .byte   $f4,$f8,$b0,$10
        .byte   $fc,$f8,$b1,$10
        .byte   $04,$f8,$b4,$10
        .byte   $f4,$00,$a2,$10
        .byte   $fc,$00,$a3,$10
        .byte   $04,$00,$a5,$10
        .byte   $f4,$08,$b2,$10
        .byte   $fc,$08,$b3,$10
        .byte   $04,$08,$b5,$10

WorldAnimSprite_10:
@5af5:  .byte   12
        .byte   $f4,$f0,$a6,$10
        .byte   $fc,$f0,$a7,$10
        .byte   $04,$f0,$aa,$10
        .byte   $f4,$f8,$b6,$10
        .byte   $fc,$f8,$b7,$10
        .byte   $04,$f8,$ba,$10
        .byte   $f4,$00,$a8,$10
        .byte   $fc,$00,$a9,$10
        .byte   $04,$00,$ab,$10
        .byte   $f4,$08,$b8,$10
        .byte   $fc,$08,$b9,$10
        .byte   $04,$08,$bb,$10

WorldAnimSprite_11:
@5b26:  .byte   12
        .byte   $f4,$f0,$a4,$50
        .byte   $fc,$f0,$a1,$50
        .byte   $04,$f0,$a0,$50
        .byte   $f4,$f8,$b4,$50
        .byte   $fc,$f8,$b1,$50
        .byte   $04,$f8,$b0,$50
        .byte   $f4,$00,$a5,$50
        .byte   $fc,$00,$a3,$50
        .byte   $04,$00,$a2,$50
        .byte   $f4,$08,$b5,$50
        .byte   $fc,$08,$b3,$50
        .byte   $04,$08,$b2,$50

WorldAnimSprite_12:
@5b57:  .byte   12
        .byte   $f4,$f0,$aa,$50
        .byte   $fc,$f0,$a7,$50
        .byte   $04,$f0,$a6,$50
        .byte   $f4,$f8,$ba,$50
        .byte   $fc,$f8,$b7,$50
        .byte   $04,$f8,$b6,$50
        .byte   $f4,$00,$ab,$50
        .byte   $fc,$00,$a9,$50
        .byte   $04,$00,$a8,$50
        .byte   $f4,$08,$bb,$50
        .byte   $fc,$08,$b9,$50
        .byte   $04,$08,$b8,$50

; ------------------------------------------------------------------------------

; $13-$25: chocobo
WorldAnimSprite_13:
@5b88:  .byte   22
        .byte   $f8,$00,$bc,$13
        .byte   $00,$00,$bd,$13
        .byte   $f8,$08,$cc,$13
        .byte   $00,$08,$cd,$13
        .byte   $f8,$f3,$ac,$14
        .byte   $00,$f3,$ad,$14
        .byte   $f8,$fb,$bc,$14
        .byte   $00,$fb,$bd,$14
        .byte   $f8,$ec,$c0,$12
        .byte   $00,$ec,$c1,$12
        .byte   $f8,$f4,$d0,$12
        .byte   $00,$f4,$d1,$12
        .byte   $f8,$fc,$e0,$12
        .byte   $00,$fc,$e1,$12
        .byte   $f8,$04,$d2,$12
        .byte   $00,$04,$d3,$12
        .byte   $f8,$0c,$e2,$12
        .byte   $00,$0c,$e3,$12
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_14:
@5be1:  .byte   22
        .byte   $f8,$01,$dc,$13
        .byte   $00,$01,$dd,$13
        .byte   $f8,$09,$ec,$13
        .byte   $00,$09,$ed,$13
        .byte   $f8,$f1,$ac,$14
        .byte   $00,$f1,$ad,$14
        .byte   $f8,$f9,$bc,$14
        .byte   $00,$f9,$bd,$14
        .byte   $f8,$ec,$d4,$12
        .byte   $00,$ec,$d5,$12
        .byte   $f8,$f4,$e4,$12
        .byte   $00,$f4,$e5,$12
        .byte   $f8,$fc,$84,$13
        .byte   $00,$fc,$85,$13
        .byte   $f8,$04,$94,$13
        .byte   $00,$04,$95,$13
        .byte   $f8,$0c,$a4,$13
        .byte   $00,$0c,$a5,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_15:
@5c3a:  .byte   22
        .byte   $f8,$01,$de,$13
        .byte   $00,$01,$df,$13
        .byte   $f8,$09,$ee,$13
        .byte   $00,$09,$ef,$13
        .byte   $f8,$f2,$ac,$14
        .byte   $00,$f2,$ad,$14
        .byte   $f8,$fa,$bc,$14
        .byte   $00,$fa,$bd,$14
        .byte   $f8,$ec,$d6,$12
        .byte   $00,$ec,$d7,$12
        .byte   $f8,$f4,$e6,$12
        .byte   $00,$f4,$e7,$12
        .byte   $f8,$fc,$86,$13
        .byte   $00,$fc,$87,$13
        .byte   $f8,$04,$96,$13
        .byte   $00,$04,$97,$13
        .byte   $f8,$0c,$a6,$13
        .byte   $00,$0c,$a7,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_16:
@5c93:  .byte   22
        .byte   $f8,$00,$be,$13
        .byte   $00,$00,$bf,$13
        .byte   $f8,$08,$ce,$13
        .byte   $00,$08,$cf,$13
        .byte   $f8,$f3,$ac,$14
        .byte   $00,$f3,$ad,$14
        .byte   $f8,$fb,$bc,$14
        .byte   $00,$fb,$bd,$14
        .byte   $f8,$ec,$d8,$12
        .byte   $00,$ec,$d9,$12
        .byte   $f8,$f4,$e8,$12
        .byte   $00,$f4,$e9,$12
        .byte   $f8,$fc,$88,$13
        .byte   $00,$fc,$89,$13
        .byte   $f8,$04,$98,$13
        .byte   $00,$04,$99,$13
        .byte   $f8,$0c,$a8,$13
        .byte   $00,$0c,$a9,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_17:
@5cec:  .byte   22
        .byte   $00,$01,$dc,$53
        .byte   $f8,$01,$dd,$53
        .byte   $00,$09,$ec,$53
        .byte   $f8,$09,$ed,$53
        .byte   $f8,$f1,$ac,$14
        .byte   $00,$f1,$ad,$14
        .byte   $f8,$f9,$bc,$14
        .byte   $00,$f9,$bd,$14
        .byte   $00,$ec,$d4,$52
        .byte   $f8,$ec,$d5,$52
        .byte   $00,$f4,$e4,$52
        .byte   $f8,$f4,$e5,$52
        .byte   $00,$fc,$84,$53
        .byte   $f8,$fc,$85,$53
        .byte   $00,$04,$94,$53
        .byte   $f8,$04,$95,$53
        .byte   $00,$0c,$a4,$53
        .byte   $f8,$0c,$a5,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_18:
@5d45:  .byte   22
        .byte   $00,$01,$de,$53
        .byte   $f8,$01,$df,$53
        .byte   $00,$09,$ee,$53
        .byte   $f8,$09,$ef,$53
        .byte   $f8,$f2,$ac,$14
        .byte   $00,$f2,$ad,$14
        .byte   $f8,$fa,$bc,$14
        .byte   $00,$fa,$bd,$14
        .byte   $00,$ec,$d6,$52
        .byte   $f8,$ec,$d7,$52
        .byte   $00,$f4,$e6,$52
        .byte   $f8,$f4,$e7,$52
        .byte   $00,$fc,$86,$53
        .byte   $f8,$fc,$87,$53
        .byte   $00,$04,$96,$53
        .byte   $f8,$04,$97,$53
        .byte   $00,$0c,$a6,$53
        .byte   $f8,$0c,$a7,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

; $19: chocobo (turning right)
WorldAnimSprite_19:
@5d9e:  .byte   27
        .byte   $fc,$fe,$bc,$13
        .byte   $04,$fe,$bd,$13
        .byte   $fc,$06,$cc,$13
        .byte   $04,$06,$cd,$13
        .byte   $fa,$f3,$ac,$14
        .byte   $02,$f3,$ad,$14
        .byte   $fa,$fb,$bc,$14
        .byte   $02,$fb,$bd,$14
        .byte   $f4,$ec,$da,$12
        .byte   $fc,$ec,$db,$12
        .byte   $04,$ec,$dc,$12
        .byte   $f4,$f4,$ea,$12
        .byte   $fc,$f4,$eb,$12
        .byte   $04,$f4,$ec,$12
        .byte   $f4,$fc,$8a,$13
        .byte   $fc,$fc,$8b,$13
        .byte   $04,$fc,$8c,$13
        .byte   $f4,$04,$9a,$13
        .byte   $fc,$04,$9b,$13
        .byte   $04,$04,$9c,$13
        .byte   $f4,$0c,$aa,$13
        .byte   $fc,$0c,$ab,$13
        .byte   $04,$0c,$ac,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_1a:
@5e0b:  .byte   27
        .byte   $fc,$ff,$dc,$13
        .byte   $04,$ff,$dd,$13
        .byte   $fc,$07,$ec,$13
        .byte   $04,$07,$ed,$13
        .byte   $fa,$f1,$ac,$14
        .byte   $02,$f1,$ad,$14
        .byte   $fa,$f9,$bc,$14
        .byte   $02,$f9,$bd,$14
        .byte   $f4,$ec,$dd,$12
        .byte   $fc,$ec,$de,$12
        .byte   $04,$ec,$df,$12
        .byte   $f4,$f4,$ed,$12
        .byte   $fc,$f4,$ee,$12
        .byte   $04,$f4,$ef,$12
        .byte   $f4,$fc,$8d,$13
        .byte   $fc,$fc,$8e,$13
        .byte   $04,$fc,$8f,$13
        .byte   $f4,$04,$9d,$13
        .byte   $fc,$04,$9e,$13
        .byte   $04,$04,$9f,$13
        .byte   $f4,$0c,$ad,$13
        .byte   $fc,$0c,$ae,$13
        .byte   $04,$0c,$af,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_1b:
@5e78:  .byte   27
        .byte   $fc,$ff,$de,$13
        .byte   $04,$ff,$df,$13
        .byte   $fc,$07,$ee,$13
        .byte   $04,$07,$ef,$13
        .byte   $fa,$f2,$ac,$14
        .byte   $02,$f2,$ad,$14
        .byte   $fa,$fa,$bc,$14
        .byte   $02,$fa,$bd,$14
        .byte   $f4,$ec,$b0,$13
        .byte   $fc,$ec,$b1,$13
        .byte   $04,$ec,$b2,$13
        .byte   $f4,$f4,$c0,$13
        .byte   $fc,$f4,$c1,$13
        .byte   $04,$f4,$c2,$13
        .byte   $f4,$fc,$d0,$13
        .byte   $fc,$fc,$d1,$13
        .byte   $04,$fc,$d2,$13
        .byte   $f4,$04,$e0,$13
        .byte   $fc,$04,$e1,$13
        .byte   $04,$04,$e2,$13
        .byte   $f4,$0c,$f0,$13
        .byte   $fc,$0c,$f1,$13
        .byte   $04,$0c,$f2,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_1c:
@5ee5:  .byte   27
        .byte   $fc,$fe,$be,$13
        .byte   $04,$fe,$bf,$13
        .byte   $fc,$06,$ce,$13
        .byte   $04,$06,$cf,$13
        .byte   $fa,$f3,$ac,$14
        .byte   $02,$f3,$ad,$14
        .byte   $fa,$fb,$bc,$14
        .byte   $02,$fb,$bd,$14
        .byte   $f4,$ec,$b3,$13
        .byte   $fc,$ec,$b4,$13
        .byte   $04,$ec,$b5,$13
        .byte   $f4,$f4,$c3,$13
        .byte   $fc,$f4,$c4,$13
        .byte   $04,$f4,$c5,$13
        .byte   $f4,$fc,$d3,$13
        .byte   $fc,$fc,$d4,$13
        .byte   $04,$fc,$d5,$13
        .byte   $f4,$04,$e3,$13
        .byte   $fc,$04,$e4,$13
        .byte   $04,$04,$e5,$13
        .byte   $f4,$0c,$f3,$13
        .byte   $fc,$0c,$f4,$13
        .byte   $04,$0c,$f5,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_1d:
@5f52:  .byte   27
        .byte   $04,$ff,$dc,$53
        .byte   $fc,$ff,$dd,$53
        .byte   $04,$07,$ec,$53
        .byte   $fc,$07,$ed,$53
        .byte   $fa,$f1,$ac,$14
        .byte   $02,$f1,$ad,$14
        .byte   $fa,$f9,$bc,$14
        .byte   $02,$f9,$bd,$14
        .byte   $f4,$ec,$b6,$13
        .byte   $fc,$ec,$b7,$13
        .byte   $04,$ec,$b8,$13
        .byte   $f4,$f4,$c6,$13
        .byte   $fc,$f4,$c7,$13
        .byte   $04,$f4,$c8,$13
        .byte   $f4,$fc,$d6,$13
        .byte   $fc,$fc,$d7,$13
        .byte   $04,$fc,$d8,$13
        .byte   $f4,$04,$e6,$13
        .byte   $fc,$04,$e7,$13
        .byte   $04,$04,$e8,$13
        .byte   $f4,$0c,$f6,$13
        .byte   $fc,$0c,$f7,$13
        .byte   $04,$0c,$f8,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_1e:
@5fbf:  .byte   27
        .byte   $04,$ff,$de,$53
        .byte   $fc,$ff,$df,$53
        .byte   $04,$07,$ee,$53
        .byte   $fc,$07,$ef,$53
        .byte   $fa,$f2,$ac,$14
        .byte   $02,$f2,$ad,$14
        .byte   $fa,$fa,$bc,$14
        .byte   $02,$fa,$bd,$14
        .byte   $f4,$ec,$b9,$13
        .byte   $fc,$ec,$ba,$13
        .byte   $04,$ec,$bb,$13
        .byte   $f4,$f4,$c9,$13
        .byte   $fc,$f4,$ca,$13
        .byte   $04,$f4,$cb,$13
        .byte   $f4,$fc,$d9,$13
        .byte   $fc,$fc,$da,$13
        .byte   $04,$fc,$db,$13
        .byte   $f4,$04,$e9,$13
        .byte   $fc,$04,$ea,$13
        .byte   $04,$04,$eb,$13
        .byte   $f4,$0c,$f9,$13
        .byte   $fc,$0c,$fa,$13
        .byte   $04,$0c,$fb,$13
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

; $1f: chocobo (turning left)
WorldAnimSprite_1f:
@602c:  .byte   27
        .byte   $fc,$fe,$bc,$53
        .byte   $f4,$fe,$bd,$53
        .byte   $fc,$06,$cc,$53
        .byte   $f4,$06,$cd,$53
        .byte   $f6,$f3,$ac,$14
        .byte   $fe,$f3,$ad,$14
        .byte   $f6,$fb,$bc,$14
        .byte   $fe,$fb,$bd,$14
        .byte   $04,$ec,$da,$52
        .byte   $fc,$ec,$db,$52
        .byte   $f4,$ec,$dc,$52
        .byte   $04,$f4,$ea,$52
        .byte   $fc,$f4,$eb,$52
        .byte   $f4,$f4,$ec,$52
        .byte   $04,$fc,$8a,$53
        .byte   $fc,$fc,$8b,$53
        .byte   $f4,$fc,$8c,$53
        .byte   $04,$04,$9a,$53
        .byte   $fc,$04,$9b,$53
        .byte   $f4,$04,$9c,$53
        .byte   $04,$0c,$aa,$53
        .byte   $fc,$0c,$ab,$53
        .byte   $f4,$0c,$ac,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_20:
@6099:  .byte   27
        .byte   $fc,$ff,$dc,$53
        .byte   $f4,$ff,$dd,$53
        .byte   $fc,$07,$ec,$53
        .byte   $f4,$07,$ed,$53
        .byte   $f6,$f1,$ac,$14
        .byte   $fe,$f1,$ad,$14
        .byte   $f6,$f9,$bc,$14
        .byte   $fe,$f9,$bd,$14
        .byte   $04,$ec,$dd,$52
        .byte   $fc,$ec,$de,$52
        .byte   $f4,$ec,$df,$52
        .byte   $04,$f4,$ed,$52
        .byte   $fc,$f4,$ee,$52
        .byte   $f4,$f4,$ef,$52
        .byte   $04,$fc,$8d,$53
        .byte   $fc,$fc,$8e,$53
        .byte   $f4,$fc,$8f,$53
        .byte   $04,$04,$9d,$53
        .byte   $fc,$04,$9e,$53
        .byte   $f4,$04,$9f,$53
        .byte   $04,$0c,$ad,$53
        .byte   $fc,$0c,$ae,$53
        .byte   $f4,$0c,$af,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_21:
@6106:  .byte   27
        .byte   $fc,$ff,$de,$53
        .byte   $f4,$ff,$df,$53
        .byte   $fc,$07,$ee,$53
        .byte   $f4,$07,$ef,$53
        .byte   $f6,$f2,$ac,$14
        .byte   $fe,$f2,$ad,$14
        .byte   $f6,$fa,$bc,$14
        .byte   $fe,$fa,$bd,$14
        .byte   $04,$ec,$b0,$53
        .byte   $fc,$ec,$b1,$53
        .byte   $f4,$ec,$b2,$53
        .byte   $04,$f4,$c0,$53
        .byte   $fc,$f4,$c1,$53
        .byte   $f4,$f4,$c2,$53
        .byte   $04,$fc,$d0,$53
        .byte   $fc,$fc,$d1,$53
        .byte   $f4,$fc,$d2,$53
        .byte   $04,$04,$e0,$53
        .byte   $fc,$04,$e1,$53
        .byte   $f4,$04,$e2,$53
        .byte   $04,$0c,$f0,$53
        .byte   $fc,$0c,$f1,$53
        .byte   $f4,$0c,$f2,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_22:
@6173:  .byte   27
        .byte   $fc,$fe,$be,$53
        .byte   $f4,$fe,$bf,$53
        .byte   $fc,$06,$ce,$53
        .byte   $f4,$06,$cf,$53
        .byte   $f6,$f3,$ac,$14
        .byte   $fe,$f3,$ad,$14
        .byte   $f6,$fb,$bc,$14
        .byte   $fe,$fb,$bd,$14
        .byte   $04,$ec,$b3,$53
        .byte   $fc,$ec,$b4,$53
        .byte   $f4,$ec,$b5,$53
        .byte   $04,$f4,$c3,$53
        .byte   $fc,$f4,$c4,$53
        .byte   $f4,$f4,$c5,$53
        .byte   $04,$fc,$d3,$53
        .byte   $fc,$fc,$d4,$53
        .byte   $f4,$fc,$d5,$53
        .byte   $04,$04,$e3,$53
        .byte   $fc,$04,$e4,$53
        .byte   $f4,$04,$e5,$53
        .byte   $04,$0c,$f3,$53
        .byte   $fc,$0c,$f4,$53
        .byte   $f4,$0c,$f5,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_23:
@61e0:  .byte   27
        .byte   $f4,$ff,$dc,$13
        .byte   $fc,$ff,$dd,$13
        .byte   $f4,$07,$ec,$13
        .byte   $fc,$07,$ed,$13
        .byte   $f6,$f1,$ac,$14
        .byte   $fe,$f1,$ad,$14
        .byte   $f6,$f9,$bc,$14
        .byte   $fe,$f9,$bd,$14
        .byte   $04,$ec,$b6,$53
        .byte   $fc,$ec,$b7,$53
        .byte   $f4,$ec,$b8,$53
        .byte   $04,$f4,$c6,$53
        .byte   $fc,$f4,$c7,$53
        .byte   $f4,$f4,$c8,$53
        .byte   $04,$fc,$d6,$53
        .byte   $fc,$fc,$d7,$53
        .byte   $f4,$fc,$d8,$53
        .byte   $04,$04,$e6,$53
        .byte   $fc,$04,$e7,$53
        .byte   $f4,$04,$e8,$53
        .byte   $04,$0c,$f6,$53
        .byte   $fc,$0c,$f7,$53
        .byte   $f4,$0c,$f8,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

WorldAnimSprite_24:
@624d:  .byte   27
        .byte   $f4,$ff,$de,$13
        .byte   $fc,$ff,$df,$13
        .byte   $f4,$07,$ee,$13
        .byte   $fc,$07,$ef,$13
        .byte   $f6,$f2,$ac,$14
        .byte   $fe,$f2,$ad,$14
        .byte   $f6,$fa,$bc,$14
        .byte   $fe,$fa,$bd,$14
        .byte   $04,$ec,$b9,$53
        .byte   $fc,$ec,$ba,$53
        .byte   $f4,$ec,$bb,$53
        .byte   $04,$f4,$c9,$53
        .byte   $fc,$f4,$ca,$53
        .byte   $f4,$f4,$cb,$53
        .byte   $04,$fc,$d9,$53
        .byte   $fc,$fc,$da,$53
        .byte   $f4,$fc,$db,$53
        .byte   $04,$04,$e9,$53
        .byte   $fc,$04,$ea,$53
        .byte   $f4,$04,$eb,$53
        .byte   $04,$0c,$f9,$53
        .byte   $fc,$0c,$fa,$53
        .byte   $f4,$0c,$fb,$53
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

; $25: chocobo (not moving)
WorldAnimSprite_25:
@62ba:  .byte   22
        .byte   $f8,$00,$cc,$12
        .byte   $00,$00,$cd,$12
        .byte   $f8,$08,$ce,$12
        .byte   $00,$08,$cf,$12
        .byte   $f8,$f3,$ac,$14
        .byte   $00,$f3,$ad,$14
        .byte   $f8,$fb,$bc,$14
        .byte   $00,$fb,$bd,$14
        .byte   $f8,$ec,$c2,$12
        .byte   $00,$ec,$c3,$12
        .byte   $f8,$f4,$c4,$12
        .byte   $00,$f4,$c5,$12
        .byte   $f8,$fc,$c6,$12
        .byte   $00,$fc,$c7,$12
        .byte   $f8,$04,$c8,$12
        .byte   $00,$04,$c9,$12
        .byte   $f8,$0c,$ca,$12
        .byte   $00,$0c,$cb,$12
        .byte   $f8,$0a,$a0,$13
        .byte   $00,$0a,$a0,$53
        .byte   $f8,$12,$a0,$93
        .byte   $00,$12,$a0,$d3

; ------------------------------------------------------------------------------

; $26-$29: character
WorldAnimSprite_26:
@6313:  .byte   6
        .byte   $f8,$e8,$f0,$10
        .byte   $00,$e8,$f1,$10
        .byte   $f8,$f0,$f2,$10
        .byte   $00,$f0,$f3,$10
        .byte   $f8,$f8,$f4,$10
        .byte   $00,$f8,$f5,$10

WorldAnimSprite_27:
@632c:  .byte   6
        .byte   $f8,$e8,$f0,$10
        .byte   $00,$e8,$f1,$10
        .byte   $f8,$f0,$f2,$10
        .byte   $00,$f0,$f3,$10
        .byte   $00,$f8,$f4,$50
        .byte   $f8,$f8,$f5,$50

WorldAnimSprite_28:
@6345:  .byte   6
        .byte   $00,$e8,$f0,$50
        .byte   $f8,$e8,$f1,$50
        .byte   $00,$f0,$f2,$50
        .byte   $f8,$f0,$f3,$50
        .byte   $f8,$f8,$f4,$10
        .byte   $00,$f8,$f5,$10

WorldAnimSprite_29:
@635e:  .byte   6
        .byte   $00,$e8,$f0,$50
        .byte   $f8,$e8,$f1,$50
        .byte   $00,$f0,$f2,$50
        .byte   $f8,$f0,$f3,$50
        .byte   $00,$f8,$f4,$50
        .byte   $f8,$f8,$f5,$50

; $2a-$2d: character (bottom sprites transparent)
WorldAnimSprite_2a:
@6377:  .byte   6
        .byte   $f8,$e8,$f0,$10
        .byte   $00,$e8,$f1,$10
        .byte   $f8,$f0,$f2,$10
        .byte   $00,$f0,$f3,$10
        .byte   $f8,$f8,$f4,$08
        .byte   $00,$f8,$f5,$08

WorldAnimSprite_2b:
@6390:  .byte   6
        .byte   $f8,$e8,$f0,$10
        .byte   $00,$e8,$f1,$10
        .byte   $f8,$f0,$f2,$10
        .byte   $00,$f0,$f3,$10
        .byte   $00,$f8,$f4,$48
        .byte   $f8,$f8,$f5,$48

WorldAnimSprite_2c:
@63a9:  .byte   6
        .byte   $00,$e8,$f0,$50
        .byte   $f8,$e8,$f1,$50
        .byte   $00,$f0,$f2,$50
        .byte   $f8,$f0,$f3,$50
        .byte   $f8,$f8,$f4,$08
        .byte   $00,$f8,$f5,$08

WorldAnimSprite_2d:
@63c2:  .byte   6
        .byte   $00,$e8,$f0,$50
        .byte   $f8,$e8,$f1,$50
        .byte   $00,$f0,$f2,$50
        .byte   $f8,$f0,$f3,$50
        .byte   $00,$f8,$f4,$48
        .byte   $f8,$f8,$f5,$48

; ------------------------------------------------------------------------------

WorldAnimSprite_2e:
@63db:  .byte   23
        .byte   $08,$00,$41,$15
        .byte   $10,$00,$42,$15
        .byte   $18,$00,$43,$15
        .byte   $00,$08,$50,$15
        .byte   $08,$08,$51,$15
        .byte   $10,$08,$52,$15
        .byte   $18,$08,$53,$15
        .byte   $20,$08,$54,$15
        .byte   $00,$10,$60,$15
        .byte   $08,$10,$61,$15
        .byte   $10,$10,$62,$15
        .byte   $18,$10,$63,$15
        .byte   $20,$10,$64,$15
        .byte   $00,$18,$70,$15
        .byte   $08,$18,$71,$15
        .byte   $10,$18,$72,$15
        .byte   $18,$18,$73,$15
        .byte   $20,$18,$74,$15
        .byte   $00,$20,$48,$15
        .byte   $08,$20,$49,$15
        .byte   $10,$20,$4a,$15
        .byte   $18,$20,$4b,$15
        .byte   $20,$20,$4c,$15

WorldAnimSprite_2f:
@6438:  .byte   18
        .byte   $08,$00,$41,$15
        .byte   $10,$00,$42,$15
        .byte   $18,$00,$43,$15
        .byte   $00,$08,$50,$15
        .byte   $08,$08,$51,$15
        .byte   $10,$08,$52,$15
        .byte   $18,$08,$53,$15
        .byte   $20,$08,$54,$15
        .byte   $00,$10,$60,$15
        .byte   $08,$10,$61,$15
        .byte   $10,$10,$62,$15
        .byte   $18,$10,$63,$15
        .byte   $20,$10,$64,$15
        .byte   $00,$18,$70,$15
        .byte   $08,$18,$71,$15
        .byte   $10,$18,$72,$15
        .byte   $18,$18,$73,$15
        .byte   $20,$18,$74,$15

WorldAnimSprite_30:
@6481:  .byte   13
        .byte   $08,$00,$41,$15
        .byte   $10,$00,$42,$15
        .byte   $18,$00,$43,$15
        .byte   $00,$08,$50,$15
        .byte   $08,$08,$51,$15
        .byte   $10,$08,$52,$15
        .byte   $18,$08,$53,$15
        .byte   $20,$08,$54,$15
        .byte   $00,$10,$60,$15
        .byte   $08,$10,$61,$15
        .byte   $10,$10,$62,$15
        .byte   $18,$10,$63,$15
        .byte   $20,$10,$64,$15

WorldAnimSprite_31:
@64b6:  .byte   8
        .byte   $08,$00,$41,$15
        .byte   $10,$00,$42,$15
        .byte   $18,$00,$43,$15
        .byte   $00,$08,$50,$15
        .byte   $08,$08,$51,$15
        .byte   $10,$08,$52,$15
        .byte   $18,$08,$53,$15
        .byte   $20,$08,$54,$15

WorldAnimSprite_32:
@64d7:  .byte   3
        .byte   $08,$00,$41,$15
        .byte   $10,$00,$42,$15
        .byte   $18,$00,$43,$15

; ------------------------------------------------------------------------------

WorldAnimSprite_33:
@64e4:  .byte   4
        .byte   $00,$00,$65,$15
        .byte   $08,$00,$66,$15
        .byte   $00,$08,$75,$15
        .byte   $08,$08,$76,$15

WorldAnimSprite_34:
@64f5:  .byte   4
        .byte   $08,$08,$65,$d5
        .byte   $00,$08,$66,$d5
        .byte   $08,$00,$75,$d5
        .byte   $00,$00,$76,$d5

WorldAnimSprite_35:
@6506:  .byte   4
        .byte   $00,$00,$45,$15
        .byte   $08,$00,$46,$15
        .byte   $00,$08,$55,$15
        .byte   $08,$08,$56,$15

WorldAnimSprite_36:
@6517:  .byte   4
        .byte   $08,$08,$45,$d5
        .byte   $00,$08,$46,$d5
        .byte   $08,$00,$55,$d5
        .byte   $00,$00,$56,$d5

; ------------------------------------------------------------------------------

; $37-$3e: ship
WorldAnimSprite_37:
@6528:  .byte   4
        .byte   $f8,$f0,$5c,$11
        .byte   $00,$f0,$5d,$11
        .byte   $f8,$f8,$6c,$11
        .byte   $00,$f8,$6d,$11

WorldAnimSprite_38:
@6539:  .byte   4
        .byte   $f9,$f0,$78,$11
        .byte   $01,$f0,$79,$11
        .byte   $f9,$f8,$7a,$11
        .byte   $01,$f8,$7b,$11

WorldAnimSprite_39:
@654a:  .byte   4
        .byte   $f8,$f0,$59,$51
        .byte   $00,$f0,$58,$51
        .byte   $f8,$f8,$69,$51
        .byte   $00,$f8,$68,$51

WorldAnimSprite_3a:
@655b:  .byte   4
        .byte   $f8,$f1,$4f,$51
        .byte   $00,$f1,$4e,$51
        .byte   $f8,$f9,$5f,$51
        .byte   $00,$f9,$5e,$51

WorldAnimSprite_3b:
@656c:  .byte   4
        .byte   $f8,$f0,$5a,$11
        .byte   $00,$f0,$5b,$11
        .byte   $f8,$f8,$6a,$11
        .byte   $00,$f8,$6b,$11

WorldAnimSprite_3c:
@657d:  .byte   4
        .byte   $f9,$f0,$6e,$11
        .byte   $01,$f0,$6f,$11
        .byte   $f9,$f8,$7e,$11
        .byte   $01,$f8,$7f,$11

WorldAnimSprite_3d:
@658e:  .byte   4
        .byte   $f8,$f0,$58,$11
        .byte   $00,$f0,$59,$11
        .byte   $f8,$f8,$68,$11
        .byte   $00,$f8,$69,$11

WorldAnimSprite_3e:
@659f:  .byte   4
        .byte   $f8,$f1,$4e,$11
        .byte   $00,$f1,$4f,$11
        .byte   $f8,$f9,$5e,$11
        .byte   $00,$f9,$5f,$11

; ------------------------------------------------------------------------------

; $3f-$44: flashing arrows for serpent trench

WorldAnimSprite_3f:
@65b0:  .byte   2
        .byte   $00,$f8,$7c,$13
        .byte   $00,$00,$7c,$93

        .byte   $0a,$f8,$7c,$13
        .byte   $0a,$00,$7c,$93

WorldAnimSprite_40:
@65c1:  .byte   2
        .byte   $0a,$f8,$7c,$13
        .byte   $0a,$00,$7c,$93

        .byte   $14,$f8,$7c,$13
        .byte   $14,$00,$7c,$93

WorldAnimSprite_41:
@65d2:  .byte   2
        .byte   $14,$f8,$7c,$13
        .byte   $14,$00,$7c,$93

        .byte   $00,$f8,$7c,$13
        .byte   $00,$00,$7c,$93

WorldAnimSprite_42:
@65e3:  .byte   2
        .byte   $00,$f8,$7c,$53
        .byte   $00,$00,$7c,$d3

        .byte   $f6,$f8,$7c,$53
        .byte   $f6,$00,$7c,$d3

WorldAnimSprite_43:
@65f4:  .byte   2
        .byte   $f6,$f8,$7c,$53
        .byte   $f6,$00,$7c,$d3

        .byte   $ec,$f8,$7c,$53
        .byte   $ec,$00,$7c,$d3

WorldAnimSprite_44:
@6605:  .byte   2
        .byte   $ec,$f8,$7c,$53
        .byte   $ec,$00,$7c,$d3

        .byte   $00,$f8,$7c,$53
        .byte   $00,$00,$7c,$d3

; ------------------------------------------------------------------------------

; $45-$48: blackjack (grounded)
WorldAnimSprite_45:
@6616:  .byte   7
        .byte   $f7,$f4,$ea,$12
        .byte   $ff,$f4,$eb,$12
        .byte   $07,$f4,$ec,$12
        .byte   $0f,$f4,$ed,$12
        .byte   $ff,$fc,$ee,$12
        .byte   $07,$fc,$ef,$12
        .byte   $0f,$fc,$bf,$12

WorldAnimSprite_46:
@6633:  .byte   12
        .byte   $f8,$f0,$e0,$12
        .byte   $00,$f0,$e1,$12
        .byte   $08,$f0,$e2,$12
        .byte   $10,$f0,$e3,$12
        .byte   $18,$f0,$ae,$12
        .byte   $f8,$f8,$e4,$12
        .byte   $00,$f8,$e5,$12
        .byte   $08,$f8,$e6,$12
        .byte   $10,$f8,$e7,$12
        .byte   $18,$f8,$be,$12
        .byte   $00,$00,$e8,$12
        .byte   $08,$00,$e9,$12

WorldAnimSprite_47:
@6664:  .byte   14
        .byte   $f6,$ed,$d2,$12
        .byte   $fe,$ed,$d3,$12
        .byte   $06,$ed,$d4,$12
        .byte   $0e,$ed,$d5,$12
        .byte   $16,$ed,$d6,$12
        .byte   $f6,$f5,$d7,$12
        .byte   $fe,$f5,$d8,$12
        .byte   $06,$f5,$d9,$12
        .byte   $0e,$f5,$da,$12
        .byte   $16,$f5,$db,$12
        .byte   $fe,$fd,$dc,$12
        .byte   $06,$fd,$dd,$12
        .byte   $0e,$fd,$de,$12
        .byte   $16,$fd,$df,$12

WorldAnimSprite_48:
@669d:  .byte   18
        .byte   $f8,$e8,$c0,$12
        .byte   $00,$e8,$c1,$12
        .byte   $08,$e8,$c2,$12
        .byte   $10,$e8,$c3,$12
        .byte   $18,$e8,$c4,$12
        .byte   $f0,$f0,$c5,$12
        .byte   $f8,$f0,$c6,$12
        .byte   $00,$f0,$c7,$12
        .byte   $08,$f0,$c8,$12
        .byte   $10,$f0,$c9,$12
        .byte   $18,$f0,$ca,$12
        .byte   $f8,$f8,$cb,$12
        .byte   $00,$f8,$cc,$12
        .byte   $08,$f8,$cd,$12
        .byte   $10,$f8,$ce,$12
        .byte   $18,$f8,$cf,$12
        .byte   $00,$00,$d0,$12
        .byte   $08,$00,$d1,$12

; ------------------------------------------------------------------------------

; $49-$4c: dismounting chocobo
WorldAnimSprite_49:
@66e6:  .byte   16
        .byte   $f8,$f8,$a0,$12
        .byte   $00,$f8,$a1,$12
        .byte   $f8,$00,$b0,$12
        .byte   $00,$00,$b1,$12
        .byte   $f8,$f0,$a2,$12
        .byte   $00,$f0,$a3,$12
        .byte   $f8,$f8,$b2,$12
        .byte   $00,$f8,$b3,$12
        .byte   $f8,$00,$a4,$12
        .byte   $00,$00,$a5,$12
        .byte   $f8,$08,$b4,$12
        .byte   $00,$08,$b5,$12
        .byte   $f8,$04,$a0,$13
        .byte   $00,$04,$a0,$53
        .byte   $f8,$0c,$a0,$93
        .byte   $00,$0c,$a0,$d3

WorldAnimSprite_4a:
@6727:  .byte   16
        .byte   $f9,$f8,$a0,$12
        .byte   $01,$f8,$a1,$12
        .byte   $f9,$00,$b0,$12
        .byte   $01,$00,$b1,$12
        .byte   $f8,$f0,$a6,$12
        .byte   $00,$f0,$a7,$12
        .byte   $f8,$f8,$b6,$12
        .byte   $00,$f8,$b7,$12
        .byte   $f8,$00,$a8,$12
        .byte   $00,$00,$a9,$12
        .byte   $f8,$08,$b8,$12
        .byte   $00,$08,$b9,$12
        .byte   $f8,$04,$a0,$13
        .byte   $00,$04,$a0,$53
        .byte   $f8,$0c,$a0,$93
        .byte   $00,$0c,$a0,$d3

WorldAnimSprite_4b:
@6768:  .byte   16
        .byte   $f7,$f8,$a0,$12
        .byte   $ff,$f8,$a1,$12
        .byte   $f7,$00,$b0,$12
        .byte   $ff,$00,$b1,$12
        .byte   $f8,$f0,$a7,$52
        .byte   $00,$f0,$a6,$52
        .byte   $f8,$f8,$b7,$52
        .byte   $00,$f8,$b6,$52
        .byte   $f8,$00,$a9,$52
        .byte   $00,$00,$a8,$52
        .byte   $f8,$08,$b9,$52
        .byte   $00,$08,$b8,$52
        .byte   $f8,$04,$a0,$13
        .byte   $00,$04,$a0,$53
        .byte   $f8,$0c,$a0,$93
        .byte   $00,$0c,$a0,$d3

WorldAnimSprite_4c:
@67a9:  .byte   16
        .byte   $f8,$f8,$98,$12
        .byte   $00,$f8,$99,$12
        .byte   $f8,$00,$9a,$12
        .byte   $00,$00,$9b,$12
        .byte   $f8,$f0,$a2,$12
        .byte   $00,$f0,$a3,$12
        .byte   $f8,$f8,$b2,$12
        .byte   $00,$f8,$b3,$12
        .byte   $f8,$00,$a4,$12
        .byte   $00,$00,$a5,$12
        .byte   $f8,$08,$b4,$12
        .byte   $00,$08,$b5,$12
        .byte   $f8,$04,$a0,$13
        .byte   $00,$04,$a0,$53
        .byte   $f8,$0c,$a0,$93
        .byte   $00,$0c,$a0,$d3

; ------------------------------------------------------------------------------

; $4d: blackjack lifting off (2nd frame with $47)
WorldAnimSprite_4d:
@67ea:  .byte   14
        .byte   $f6,$ed,$d2,$12
        .byte   $fe,$ed,$d3,$12
        .byte   $06,$ed,$d4,$12
        .byte   $0e,$ed,$ac,$12
        .byte   $16,$ed,$ad,$12
        .byte   $f6,$f5,$d7,$12
        .byte   $fe,$f5,$d8,$12
        .byte   $06,$f5,$d9,$12
        .byte   $0e,$f5,$bc,$12
        .byte   $16,$f5,$bd,$12
        .byte   $fe,$fd,$dc,$12
        .byte   $06,$fd,$dd,$12
        .byte   $0e,$fd,$de,$12
        .byte   $16,$fd,$df,$12

; ------------------------------------------------------------------------------

; $4e-$53: esper terra
WorldAnimSprite_4e:
@6823:  .byte   6
        .byte   $f8,$f4,$84,$15
        .byte   $00,$f4,$85,$15
        .byte   $f8,$fc,$94,$15
        .byte   $00,$fc,$95,$15
        .byte   $f8,$04,$a4,$15
        .byte   $00,$04,$a5,$15

WorldAnimSprite_4f:
@683c:  .byte   6
        .byte   $f8,$f4,$86,$15
        .byte   $00,$f4,$87,$15
        .byte   $f8,$fc,$96,$15
        .byte   $00,$fc,$97,$15
        .byte   $f8,$04,$a6,$15
        .byte   $00,$04,$a7,$15

WorldAnimSprite_50:
@6855:  .byte   6
        .byte   $f8,$f4,$88,$15
        .byte   $00,$f4,$89,$15
        .byte   $f8,$fc,$98,$15
        .byte   $00,$fc,$99,$15
        .byte   $f8,$04,$a8,$15
        .byte   $00,$04,$a9,$15

WorldAnimSprite_51:
@686e:  .byte   6
        .byte   $f8,$f4,$8a,$15
        .byte   $00,$f4,$8b,$15
        .byte   $f8,$fc,$9a,$15
        .byte   $00,$fc,$9b,$15
        .byte   $f8,$04,$aa,$15
        .byte   $00,$04,$ab,$15

WorldAnimSprite_52:
@6887:  .byte   6
        .byte   $f8,$f4,$89,$55
        .byte   $00,$f4,$88,$55
        .byte   $f8,$fc,$99,$55
        .byte   $00,$fc,$98,$55
        .byte   $f8,$04,$a9,$55
        .byte   $00,$04,$a8,$55

WorldAnimSprite_53:
@68a0:  .byte   6
        .byte   $f8,$f4,$8b,$55
        .byte   $00,$f4,$8a,$55
        .byte   $f8,$fc,$9b,$55
        .byte   $00,$fc,$9a,$55
        .byte   $f8,$04,$ab,$55
        .byte   $00,$04,$aa,$55

; ------------------------------------------------------------------------------

WorldAnimSprite_54:
@68b9:  .byte   2
        .byte   $fb,$fb,$0f,$07
        .byte   $04,$04,$1f,$07

WorldAnimSprite_55:
@68c2:  .byte   2
        .byte   $fb,$fb,$1f,$07
        .byte   $04,$04,$0f,$07

; ------------------------------------------------------------------------------

; $56-$59: smoking airship
WorldAnimSprite_56:
@68cb:  .byte   6
        .byte   $f8,$f8,$b1,$15
        .byte   $00,$f8,$b1,$55
        .byte   $f0,$00,$c0,$15
        .byte   $f8,$00,$c1,$15
        .byte   $00,$00,$c1,$55
        .byte   $08,$00,$c0,$55

WorldAnimSprite_57:
@68e4:  .byte   12
        .byte   $f0,$f0,$d0,$15
        .byte   $f8,$f0,$d1,$15
        .byte   $00,$f0,$d1,$55
        .byte   $08,$f0,$d0,$55
        .byte   $f0,$f8,$b2,$15
        .byte   $f8,$f8,$b3,$15
        .byte   $00,$f8,$b3,$55
        .byte   $08,$f8,$b2,$55
        .byte   $f0,$00,$c2,$15
        .byte   $f8,$00,$c3,$15
        .byte   $00,$00,$c3,$55
        .byte   $08,$00,$c2,$55

WorldAnimSprite_58:
@6915:  .byte   18
        .byte   $f8,$e0,$d3,$15
        .byte   $00,$e0,$d3,$55
        .byte   $f0,$e8,$b4,$15
        .byte   $f8,$e8,$b5,$15
        .byte   $00,$e8,$b5,$55
        .byte   $08,$e8,$b4,$55
        .byte   $f0,$f0,$c4,$15
        .byte   $f8,$f0,$c5,$15
        .byte   $00,$f0,$c5,$55
        .byte   $08,$f0,$c4,$55
        .byte   $f0,$f8,$d4,$15
        .byte   $f8,$f8,$d5,$15
        .byte   $00,$f8,$d5,$55
        .byte   $08,$f8,$d4,$55
        .byte   $f0,$00,$b6,$15
        .byte   $f8,$00,$b7,$15
        .byte   $00,$00,$b7,$55
        .byte   $08,$00,$b6,$55

WorldAnimSprite_59:
@695e:  .byte   20
        .byte   $f8,$d8,$c7,$15
        .byte   $00,$d8,$c7,$55
        .byte   $f8,$e0,$d7,$15
        .byte   $00,$e0,$d7,$55
        .byte   $f0,$e8,$b8,$15
        .byte   $f8,$e8,$b9,$15
        .byte   $00,$e8,$b9,$55
        .byte   $08,$e8,$b8,$55
        .byte   $f0,$f0,$c8,$15
        .byte   $f8,$f0,$c9,$15
        .byte   $00,$f0,$c9,$55
        .byte   $08,$f0,$c8,$55
        .byte   $f0,$f8,$d8,$15
        .byte   $f8,$f8,$d9,$15
        .byte   $00,$f8,$d9,$55
        .byte   $08,$f8,$d8,$55
        .byte   $f0,$00,$ba,$15
        .byte   $f8,$00,$bb,$15
        .byte   $00,$00,$bb,$55
        .byte   $08,$00,$ba,$55

; ------------------------------------------------------------------------------

WorldAnimSprite_5a:
WorldAnimSprite_5b:
@69af:  .byte   1
        .byte   $00,$00,$9f,$15

WorldAnimSprite_5c:
@69b4:  .byte   3
        .byte   $fb,$fb,$8e,$15
        .byte   $03,$fb,$8f,$15
        .byte   $fb,$03,$9e,$15

WorldAnimSprite_5d:
@69c1:  .byte   4
        .byte   $f9,$f9,$8c,$15
        .byte   $01,$f9,$8d,$15
        .byte   $f9,$01,$9c,$15
        .byte   $01,$01,$9d,$15

WorldAnimSprite_5e:
@69d2:  .byte   4
        .byte   $f8,$f8,$ac,$15
        .byte   $00,$f8,$ad,$15
        .byte   $f8,$00,$ae,$15
        .byte   $00,$00,$af,$15

; ------------------------------------------------------------------------------

; $5f-61: bird
WorldAnimSprite_5f:
@69e3:  .byte   4
        .byte   $f8,$f8,$ca,$15
        .byte   $00,$f8,$ca,$55
        .byte   $f8,$00,$da,$15
        .byte   $00,$00,$da,$55

WorldAnimSprite_60:
@69f4:  .byte   2
        .byte   $f8,$00,$cb,$15
        .byte   $00,$00,$cb,$55

WorldAnimSprite_61:
@69fd:  .byte   2
        .byte   $f8,$00,$db,$15
        .byte   $00,$00,$db,$55

; ------------------------------------------------------------------------------

; $62-$65: falcon (grounded)
WorldAnimSprite_62:
@6a06:  .byte   11
        .byte   $fa,$f0,$f9,$12
        .byte   $02,$f0,$fa,$12
        .byte   $0a,$f0,$fb,$12
        .byte   $12,$f0,$fc,$12
        .byte   $fa,$f8,$fd,$12
        .byte   $02,$f8,$fe,$12
        .byte   $0a,$f8,$ff,$12
        .byte   $12,$f8,$ae,$12
        .byte   $02,$00,$bc,$12
        .byte   $0a,$00,$bd,$12
        .byte   $12,$00,$be,$12

WorldAnimSprite_63:
@6a33:  .byte   14
        .byte   $f6,$ef,$e5,$12
        .byte   $fe,$ef,$e6,$12
        .byte   $06,$ef,$e7,$12
        .byte   $0e,$ef,$e8,$12
        .byte   $16,$ef,$e9,$12
        .byte   $f6,$f7,$ea,$12
        .byte   $fe,$f7,$eb,$12
        .byte   $06,$f7,$ec,$12
        .byte   $0e,$f7,$ed,$12
        .byte   $16,$f7,$ee,$12
        .byte   $fe,$ff,$ef,$12
        .byte   $06,$ff,$f6,$12
        .byte   $0e,$ff,$f7,$12
        .byte   $16,$ff,$f8,$12

WorldAnimSprite_64:
@6a6c:  .byte   15
        .byte   $f4,$ea,$d6,$12
        .byte   $fc,$ea,$d7,$12
        .byte   $04,$ea,$d8,$12
        .byte   $0c,$ea,$d9,$12
        .byte   $14,$ea,$da,$12
        .byte   $f4,$f2,$db,$12
        .byte   $fc,$f2,$dc,$12
        .byte   $04,$f2,$dd,$12
        .byte   $0c,$f2,$de,$12
        .byte   $14,$f2,$df,$12
        .byte   $f4,$fa,$e0,$12
        .byte   $fc,$fa,$e1,$12
        .byte   $04,$fa,$e2,$12
        .byte   $0c,$fa,$e3,$12
        .byte   $14,$fa,$e4,$12

WorldAnimSprite_65:
@6aa9:  .byte   22
        .byte   $f6,$e8,$c0,$12
        .byte   $fe,$e8,$c1,$12
        .byte   $06,$e8,$c2,$12
        .byte   $0e,$e8,$c3,$12
        .byte   $16,$e8,$c4,$12
        .byte   $ee,$f0,$c5,$12
        .byte   $f6,$f0,$c6,$12
        .byte   $fe,$f0,$c7,$12
        .byte   $06,$f0,$c8,$12
        .byte   $0e,$f0,$c9,$12
        .byte   $16,$f0,$ca,$12
        .byte   $ee,$f8,$cb,$12
        .byte   $f6,$f8,$cc,$12
        .byte   $fe,$f8,$cd,$12
        .byte   $06,$f8,$ce,$12
        .byte   $0e,$f8,$cf,$12
        .byte   $16,$f8,$d0,$12
        .byte   $f6,$00,$d1,$12
        .byte   $fe,$00,$d2,$12
        .byte   $06,$00,$d3,$12
        .byte   $0e,$00,$d4,$12
        .byte   $16,$00,$d5,$12

; ------------------------------------------------------------------------------

; $66: falcon lifting off (2nd frame with $64)
WorldAnimSprite_66:
@6b02:  .byte   15
        .byte   $f4,$ea,$d6,$12
        .byte   $fc,$ea,$d7,$12
        .byte   $04,$ea,$d8,$12
        .byte   $0c,$ea,$d9,$12
        .byte   $14,$ea,$da,$12
        .byte   $f4,$f2,$db,$12
        .byte   $fc,$f2,$dc,$12
        .byte   $04,$f2,$dd,$12
        .byte   $0c,$f2,$de,$12
        .byte   $14,$f2,$af,$12
        .byte   $f4,$fa,$e0,$12
        .byte   $fc,$fa,$e1,$12
        .byte   $04,$fa,$e2,$12
        .byte   $0c,$fa,$e3,$12
        .byte   $14,$fa,$bf,$12

; ------------------------------------------------------------------------------

WorldAnimSprite_67:
@6b3f:  .byte   5
        .byte   $f4,$02,$04,$00
        .byte   $fc,$02,$04,$00
        .byte   $04,$02,$04,$00
        .byte   $0c,$02,$04,$00
        .byte   $14,$02,$04,$00

WorldAnimSprite_68:
@6b54:  .byte   10
        .byte   $f4,$02,$04,$00
        .byte   $fc,$02,$04,$00
        .byte   $04,$02,$04,$00
        .byte   $0c,$02,$04,$00
        .byte   $14,$02,$04,$00
        .byte   $f4,$0a,$04,$00
        .byte   $fc,$0a,$04,$00
        .byte   $04,$0a,$04,$00
        .byte   $0c,$0a,$04,$00
        .byte   $14,$0a,$04,$00

WorldAnimSprite_69:
@6b7d:  .byte   15
        .byte   $f4,$02,$04,$00
        .byte   $fc,$02,$04,$00
        .byte   $04,$02,$04,$00
        .byte   $0c,$02,$04,$00
        .byte   $14,$02,$04,$00
        .byte   $f4,$0a,$04,$00
        .byte   $fc,$0a,$04,$00
        .byte   $04,$0a,$04,$00
        .byte   $0c,$0a,$04,$00
        .byte   $14,$0a,$04,$00
        .byte   $f4,$12,$04,$00
        .byte   $fc,$12,$04,$00
        .byte   $04,$12,$04,$00
        .byte   $0c,$12,$04,$00
        .byte   $14,$12,$04,$00

WorldAnimSprite_6a:
@6bba:  .byte   4
        .byte   $00,$f8,$7c,$15
        .byte   $00,$00,$7c,$95
        .byte   $0a,$f8,$7c,$15
        .byte   $0a,$00,$7c,$95

        .byte   $14,$f8,$7c,$15
        .byte   $14,$00,$7c,$95

WorldAnimSprite_6b:
@6bd3:  .byte   4
        .byte   $00,$f8,$7c,$55
        .byte   $00,$00,$7c,$d5
        .byte   $f6,$f8,$7c,$55
        .byte   $f6,$00,$7c,$d5

        .byte   $ec,$f8,$7c,$55
        .byte   $ec,$00,$7c,$d5

; ------------------------------------------------------------------------------
