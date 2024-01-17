
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: menu_anim.asm                                                        |
; |                                                                            |
; | description: animation data for menu program                               |
; |                                                                            |
; | created: 9/5/2022                                                          |
; +----------------------------------------------------------------------------+

.segment "menu_data"

; ------------------------------------------------------------------------------

; d8/e800

; bg/font palettes
FontPal:
        .incbin "src/gfx/menu_pal/pal_0000.pal"
        .incbin "src/gfx/menu_pal/pal_0001.pal"
        .incbin "src/gfx/menu_pal/pal_0002.pal"
        .incbin "src/gfx/menu_pal/pal_0003.pal"
        .incbin "src/gfx/menu_pal/pal_0004.pal"
        .incbin "src/gfx/menu_pal/pal_0005.pal"
        .incbin "src/gfx/menu_pal/pal_0006.pal"
        .incbin "src/gfx/menu_pal/pal_0007.pal"
        .incbin "src/gfx/menu_pal/pal_0008.pal"
        .incbin "src/gfx/menu_pal/pal_0009.pal"
        .incbin "src/gfx/menu_pal/pal_000a.pal"
        .incbin "src/gfx/menu_pal/pal_000b.pal"
        .incbin "src/gfx/menu_pal/pal_000c.pal"
        .incbin "src/gfx/menu_pal/pal_000d.pal"
        .incbin "src/gfx/menu_pal/pal_000e.pal"
        .incbin "src/gfx/menu_pal/pal_000f.pal"

; config color bar palette
ColorBarPal:
        .incbin "src/gfx/menu_pal/pal_0010.pal"
        .incbin "src/gfx/menu_pal/pal_0011.pal"
        .incbin "src/gfx/menu_pal/pal_0012.pal"
        .incbin "src/gfx/menu_pal/pal_0013.pal"

; grayscale sprite palette
GrayscalePal:
        .incbin "src/gfx/menu_pal/pal_0014.pal"
        .incbin "src/gfx/menu_pal/pal_0015.pal"
        .incbin "src/gfx/menu_pal/pal_0016.pal"
        .incbin "src/gfx/menu_pal/pal_0017.pal"  ; cursor palette

; status icon palette
StatusIconPal:
        .incbin "src/gfx/menu_pal/pal_0018.pal"

; ------------------------------------------------------------------------------

; name change letters
NameChangeLetters:
@e8c8:  .byte   $80,$81,$82,$83,$84,$9a,$9b,$9c,$9d,$9e
        .byte   $85,$86,$87,$88,$89,$9f,$a0,$a1,$a2,$a3
        .byte   $8a,$8b,$8c,$8d,$8e,$a4,$a5,$a6,$a7,$a8
        .byte   $8f,$90,$91,$92,$93,$a9,$aa,$ab,$ac,$ad
        .byte   $94,$95,$96,$97,$98,$ae,$af,$b0,$b1,$b2
        .byte   $99,$be,$bf,$c0,$c1,$b3,$c2,$c3,$c4,$c5
        .byte   $b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd

; ------------------------------------------------------------------------------

; element symbols
ElementSymbols:
@e90e:  .byte   $dd,$da,$d6,$d9,$de,$d8,$db,$dc,0

; ------------------------------------------------------------------------------

; pointers to character animation data (save menu and party menu)
PartyCharAnimTbl:
@e917:  .addr   PartyCharAnim_00
        .addr   PartyCharAnim_01
        .addr   PartyCharAnim_02
        .addr   PartyCharAnim_03
        .addr   PartyCharAnim_04
        .addr   PartyCharAnim_05
        .addr   PartyCharAnim_06
        .addr   PartyCharAnim_07
        .addr   PartyCharAnim_08
        .addr   PartyCharAnim_09
        .addr   PartyCharAnim_0a
        .addr   PartyCharAnim_0b
        .addr   PartyCharAnim_0c
        .addr   PartyCharAnim_0d
        .addr   PartyCharAnim_0e
        .addr   PartyCharAnim_0f
        .addr   PartyCharAnim_10
        .addr   PartyCharAnim_11
        .addr   PartyCharAnim_12
        .addr   PartyCharAnim_13
        .addr   PartyCharAnim_14
        .addr   PartyCharAnim_15
        .addr   PartyCharAnim_16

; ------------------------------------------------------------------------------

; save/party menu character animation data
PartyCharAnim_00:
@e945:  .addr   PartyCharSprite_00
        .byte   $10
        .addr   PartyCharSprite_00
        .byte   $10
        .addr   PartyCharSprite_00
        .byte   $ff

PartyCharAltAnim_00:
@e94e:  .addr   PartyCharSprite_00
        .byte   $10
        .addr   PartyCharAltSprite_00
        .byte   $10
        .addr   PartyCharSprite_00
        .byte   $ff

PartyCharAnim_01:
@e957:  .addr   PartyCharSprite_01
        .byte   $10
        .addr   PartyCharSprite_01
        .byte   $10
        .addr   PartyCharSprite_01
        .byte   $ff

@e960:  .addr   PartyCharSprite_01
        .byte   $10
        .addr   PartyCharAltSprite_01
        .byte   $10
        .addr   PartyCharSprite_01
        .byte   $ff

PartyCharAnim_02:
@e969:  .addr   PartyCharSprite_02
        .byte   $10
        .addr   PartyCharSprite_02
        .byte   $10
        .addr   PartyCharSprite_02
        .byte   $ff

@e972:  .addr   PartyCharSprite_02
        .byte   $10
        .word   $ea89
        .byte   $10
        .addr   PartyCharSprite_02
        .byte   $ff

PartyCharAnim_03:
@e97b:  .word   $ea92
        .byte   $10
        .word   $ea92
        .byte   $10
        .word   $ea92
        .byte   $ff

@e984:  .word   $ea92
        .byte   $10
        .word   $ea9b
        .byte   $10
        .word   $ea92
        .byte   $ff

PartyCharAnim_04:
@e98d:  .word   $eaa4
        .byte   $10
        .word   $eaa4
        .byte   $10
        .word   $eaa4
        .byte   $ff

@e996:  .word   $eaa4
        .byte   $10
        .word   $eaad
        .byte   $10
        .word   $eaa4
        .byte   $ff

PartyCharAnim_05:
@e99f:  .word   $eab6
        .byte   $10
        .word   $eab6
        .byte   $10
        .word   $eab6
        .byte   $ff

@e9a8:  .word   $eab6
        .byte   $10
        .word   $eabf
        .byte   $10
        .word   $eab6
        .byte   $ff

PartyCharAnim_06:
@e9b1:  .word   $eac8
        .byte   $10
        .word   $eac8
        .byte   $10
        .word   $eac8
        .byte   $ff

@e9ba:  .word   $eac8
        .byte   $10
        .word   $ead1
        .byte   $10
        .word   $eac8
        .byte   $ff

PartyCharAnim_07:
@e9c3:  .word   $eada
        .byte   $10
        .word   $eada
        .byte   $10
        .word   $eada
        .byte   $ff

@e9cc:  .word   $eada
        .byte   $10
        .word   $eae3
        .byte   $10
        .word   $eada
        .byte   $ff

PartyCharAnim_08:
@e9d5:  .word   $eaec
        .byte   $10
        .word   $eaec
        .byte   $10
        .word   $eaec
        .byte   $ff

@e9de:  .word   $eaec
        .byte   $10
        .word   $eaf5
        .byte   $10
        .word   $eaec
        .byte   $ff

PartyCharAnim_09:
@e9e7:  .word   $eafe
        .byte   $10
        .word   $eafe
        .byte   $10
        .word   $eafe
        .byte   $ff

@e9f0:  .word   $eafe
        .byte   $10
        .word   $eb07
        .byte   $10
        .word   $eafe
        .byte   $ff

PartyCharAnim_0a:
@e9f9:  .word   $eb10
        .byte   $10
        .word   $eb10
        .byte   $10
        .word   $eb10
        .byte   $ff

@ea02:  .word   $eb10
        .byte   $10
        .word   $eb19
        .byte   $10
        .word   $eb10
        .byte   $ff

PartyCharAnim_0b:
@ea0b:  .word   $eb22
        .byte   $10
        .word   $eb22
        .byte   $10
        .word   $eb22
        .byte   $ff

@ea14:  .word   $eb22
        .byte   $10
        .word   $eb2b
        .byte   $10
        .word   $eb22
        .byte   $ff

PartyCharAnim_0c:
@ea1d:  .word   $eb34
        .byte   $10
        .word   $eb34
        .byte   $10
        .word   $eb34
        .byte   $ff

@ea26:  .word   $eb34
        .byte   $10
        .word   $eb3d
        .byte   $10
        .word   $eb34
        .byte   $ff

PartyCharAnim_0d:
@ea2f:  .word   $eb46
        .byte   $10
        .word   $eb46
        .byte   $10
        .word   $eb46
        .byte   $ff

@ea38:  .word   $eb46
        .byte   $10
        .word   $eb4f
        .byte   $10
        .word   $eb46
        .byte   $ff

PartyCharAnim_0e:
@ea41:  .word   $eb58
        .byte   $fe

PartyCharAnim_0f:
@ea44:  .word   $eb61
        .byte   $fe

PartyCharAnim_10:
@ea47:  .word   $eb6a
        .byte   $fe

PartyCharAnim_11:
@ea4a:  .word   $eb73
        .byte   $fe

PartyCharAnim_12:
@ea4d:  .word   $eb7c
        .byte   $fe

PartyCharAnim_13:
@ea50:  .word   $eb85
        .byte   $fe

PartyCharAnim_14:
@ea53:  .word   $eb8e
        .byte   $fe

PartyCharAnim_15:
@ea56:  .word   $eb97
        .byte   $fe

PartyCharAnim_16:
@ea59:  .word   $eba0
        .byte   $fe

; ------------------------------------------------------------------------------

; save/party menu character sprite data
PartyCharSprite_00:
@ea5c:  .byte   2
        .byte   $80,$01,$00,$39
        .byte   $80,$11,$02,$39

PartyCharAltSprite_00:
@ea65:  .byte   2
        .byte   $80,$00,$04,$39
        .byte   $80,$10,$06,$39

PartyCharSprite_01:
@ea6e:  .byte   2
        .byte   $80,$01,$08,$37
        .byte   $80,$11,$0a,$37

PartyCharAltSprite_01:
@ea77:  .byte   2
        .byte   $80,$00,$0c,$37
        .byte   $80,$10,$0e,$37

PartyCharSprite_02:
@ea80:  .byte   2
        .byte   $80,$01,$20,$3d
        .byte   $80,$11,$22,$3d

        .byte   2
        .byte   $80,$00,$24,$3d
        .byte   $80,$10,$26,$3d

PartyCharSprite_03:
        .byte   2
        .byte   $80,$01,$28,$3d
        .byte   $80,$11,$2a,$3d

        .byte   2
        .byte   $80,$00,$2c,$3d
        .byte   $80,$10,$2e,$3d

PartyCharSprite_04:
        .byte   2
        .byte   $80,$01,$40,$35
        .byte   $80,$11,$42,$35

        .byte   2
        .byte   $80,$00,$44,$35
        .byte   $80,$10,$46,$35

PartyCharSprite_05:
        .byte   2
        .byte   $80,$01,$48,$35
        .byte   $80,$11,$4a,$35

        .byte   2
        .byte   $80,$00,$4c,$35
        .byte   $80,$10,$4e,$35

PartyCharSprite_06:
        .byte   2
        .byte   $80,$01,$60,$35
        .byte   $80,$11,$62,$35

        .byte   2
        .byte   $80,$00,$64,$35
        .byte   $80,$10,$66,$35

PartyCharSprite_07:
        .byte   2
        .byte   $80,$01,$68,$3b
        .byte   $80,$11,$6a,$3b

        .byte   2
        .byte   $80,$00,$6c,$3b
        .byte   $80,$10,$6e,$3b

PartyCharSprite_08:
        .byte   2
        .byte   $80,$01,$80,$3b
        .byte   $80,$11,$82,$3b

        .byte   2
        .byte   $80,$00,$84,$3b
        .byte   $80,$10,$86,$3b

PartyCharSprite_09:
        .byte   2
        .byte   $80,$01,$88,$3d
        .byte   $80,$11,$8a,$3d

        .byte   2
        .byte   $80,$00,$8c,$3d
        .byte   $80,$10,$8e,$3d

PartyCharSprite_0a:
        .byte   2
        .byte   $80,$01,$a0,$3f
        .byte   $80,$11,$a2,$3f

        .byte   2
        .byte   $80,$00,$a4,$3f
        .byte   $80,$10,$a6,$3f

PartyCharSprite_0b:
        .byte   2
        .byte   $80,$01,$a8,$3b
        .byte   $80,$11,$aa,$3b

        .byte   2
        .byte   $80,$00,$ac,$3b
        .byte   $80,$10,$ae,$3b

PartyCharSprite_0c:
        .byte   2
        .byte   $80,$01,$c0,$3b
        .byte   $80,$11,$c2,$3b

        .byte   2
        .byte   $80,$00,$c4,$3b
        .byte   $80,$10,$c6,$3b

PartyCharSprite_0d:
        .byte   2
        .byte   $80,$01,$c8,$3f
        .byte   $80,$11,$ca,$3f

        .byte   2
        .byte   $80,$00,$cc,$3f
        .byte   $80,$10,$ce,$3f

PartyCharSprite_0e:
        .byte   2
        .byte   $80,$01,$e0,$37
        .byte   $80,$11,$e2,$37

PartyCharSprite_0f:
        .byte   2
        .byte   $80,$01,$e8,$35
        .byte   $80,$11,$ea,$35

PartyCharSprite_10:
        .byte   2
        .byte   $80,$01,$04,$35
        .byte   $80,$11,$06,$35

PartyCharSprite_11:
        .byte   2
        .byte   $80,$01,$0c,$3b
        .byte   $80,$11,$0e,$3b

PartyCharSprite_12:
        .byte   2
        .byte   $80,$01,$24,$39
        .byte   $80,$11,$26,$39

PartyCharSprite_13:
        .byte   2
        .byte   $80,$01,$2c,$37
        .byte   $80,$11,$2e,$37

PartyCharSprite_14:
        .byte   2
        .byte   $80,$01,$44,$35
        .byte   $80,$11,$46,$35

PartyCharSprite_15:
        .byte   2
        .byte   $80,$01,$4c,$39
        .byte   $80,$11,$4e,$39

PartyCharSprite_16:
        .byte   2
        .byte   $80,$01,$e0,$35
        .byte   $80,$11,$e2,$35

; ------------------------------------------------------------------------------

; animation data for arrow under characters forced to be in the party
PartyArrowAnim:
@eba9:  .addr   PartyArrowSprite
        .byte   $fe

PartyArrowSprite:
@ebac:  .byte   1
        .byte   $80,$14,$03,$be

; ------------------------------------------------------------------------------

; shop character sprite x positions
ShopCharXTbl:
@ebb1:  .byte   $10,$30,$50,$70,$90,$b0,$d0
        .byte   $10,$30,$50,$70,$90,$b0,$d0

; shop character sprite y positions
ShopCharYTbl:
@ebbf:  .byte   $ac,$ac,$ac,$ac,$ac,$ac,$ac
        .byte   $c8,$c8,$c8,$c8,$c8,$c8,$c8

; ------------------------------------------------------------------------------

; shop equip symbol animation data

; "E" (already equipped)
ShopEquipIconAnim_00:
@ebcd:  .addr   ShopEquipIconSprite_00
        .byte   $08
        .addr   ShopEquipIconSprite_00
        .byte   $08
        .addr   ShopEquipIconSprite_00
        .byte   $08
        .addr   ShopEquipIconSprite_00
        .byte   $ff

; up arrow (better)
ShopEquipIconAnim_01:
@ebd9:  .addr   ShopEquipIconSprite_04
        .byte   $08
        .addr   ShopEquipIconSprite_03
        .byte   $08
        .addr   ShopEquipIconSprite_02
        .byte   $08
        .addr   ShopEquipIconSprite_02
        .byte   $ff

; down arrow (worse)
ShopEquipIconAnim_02:
@ebe5:  .addr   ShopEquipIconSprite_07
        .byte   $08
        .addr   ShopEquipIconSprite_06
        .byte   $08
        .addr   ShopEquipIconSprite_05
        .byte   $08
        .addr   ShopEquipIconSprite_05
        .byte   $ff

; equals sign (same)
ShopEquipIconAnim_03:
@ebf1:  .addr   ShopEquipIconSprite_01
        .byte   $08
        .addr   ShopEquipIconSprite_01
        .byte   $08
        .addr   ShopEquipIconSprite_01
        .byte   $08
        .addr   ShopEquipIconSprite_01
        .byte   $ff

ShopEquipIconSprite_00:
@ebfd:  .byte   1
        .byte   $00,$00,$07,$3e

ShopEquipIconSprite_01:
@ec02:  .byte   1
        .byte   $00,$00,$0f,$3e

ShopEquipIconSprite_02:
@ec07:  .byte   1
        .byte   $00,$00,$0c,$3e

ShopEquipIconSprite_03:
@ec0c:  .byte   1
        .byte   $00,$00,$0d,$3e

ShopEquipIconSprite_04:
@ec11:  .byte   1
        .byte   $00,$00,$0e,$3e

ShopEquipIconSprite_05:
@ec16:  .byte   1
        .byte   $00,$00,$0c,$be

ShopEquipIconSprite_06:
@ec1b:  .byte   1
        .byte   $00,$00,$0d,$be

ShopEquipIconSprite_07:
@ec20:  .byte   1
        .byte   $00,$00,$0e,$be

; ------------------------------------------------------------------------------

; pointers to status menu icon animation data
StatusIconAnimPtrs:
@ec25:  .addr   StatusIconAnim_00
        .addr   StatusIconAnim_01
        .addr   StatusIconAnim_02
        .addr   StatusIconAnim_03
        .addr   StatusIconAnim_04
        .addr   StatusIconAnim_05
        .addr   StatusIconAnim_06

; status menu icon animation data
StatusIconAnim_00:
@ec33:  .addr   StatusIconSprite_00
        .byte   $fe

StatusIconAnim_01:
@ec36:  .addr   StatusIconSprite_01
        .byte   $fe

StatusIconAnim_02:
@ec39:  .addr   StatusIconSprite_02
        .byte   $fe

StatusIconAnim_03:
@ec3c:  .addr   StatusIconSprite_03
        .byte   $fe

StatusIconAnim_04:
        .addr   StatusIconSprite_04
        .byte   $fe

StatusIconAnim_05:
        .addr   StatusIconSprite_05
        .byte   $fe

StatusIconAnim_06:
        .addr   StatusIconSprite_06
        .byte   $fe

; status menu icon sprite data
StatusIconSprite_00:
        .byte   1
        .byte   $80,$00,$20,$3c

StatusIconSprite_01:
        .byte   1
        .byte   $80,$00,$22,$3c

StatusIconSprite_02:
        .byte   1
        .byte   $80,$00,$24,$3c

StatusIconSprite_03:
        .byte   1
        .byte   $80,$00,$26,$3c

StatusIconSprite_04:
        .byte   1
        .byte   $80,$00,$28,$3c

StatusIconSprite_05:
        .byte   1
        .byte   $80,$00,$2a,$3c

StatusIconSprite_06:
@ec66:  .byte   1
        .byte   $80,$00,$2c,$3c

; ------------------------------------------------------------------------------

; pointers to arrow animation data for item details
ItemDetailArrowAnimPtrs:
@ec6b:  .addr   ItemDetailArrowAnimHidden
        .addr   ItemDetailArrowAnimShown

ItemDetailArrowAnimShown:
@ec6f:  .addr   ItemDetailArrowHidden
        .byte   $10
        .addr   ItemDetailArrowShown
        .byte   $10
        .addr   ItemDetailArrowHidden
        .byte   $ff

ItemDetailArrowAnimHidden:
@ec78:  .addr   ItemDetailArrowHidden
        .byte   $10
        .addr   ItemDetailArrowHidden
        .byte   $10
        .addr   ItemDetailArrowHidden
        .byte   $ff

ItemDetailArrowHidden:
@ec81:  .byte   0

ItemDetailArrowShown:
@ec82:  .byte   1
        .byte   $80,$00,$05,$7e

; ------------------------------------------------------------------------------

; colosseum "VS" animation data
ColosseumVSAnim:
@ec87:  .word   $ec8a
        .byte   $fe

; colosseum "VS" sprite data
ColosseumVSSprite:
@ec8a:  .byte   2
        .byte   $80,$00,$08,$3e
        .byte   $90,$00,$0a,$3e

; ------------------------------------------------------------------------------

; double-headed coin animation data (Edgar's ending scene)
@ec93:  .word   $ed71
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ed71
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ed71
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ed71
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ed71
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ed71
        .byte   $b4
        .word   $ed71
        .byte   $b4
        .word   $ed71
        .byte   $46
        .word   $ed71
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ed71
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $04
        .word   $ed96
        .byte   $04
        .word   $edbb
        .byte   $04
        .word   $ede0
        .byte   $04
        .word   $ee05
        .byte   $04
        .word   $ee22
        .byte   $fe

        .byte   9
        .byte   $01,$00,$0c,$38
        .byte   $09,$00,$0d,$38
        .byte   $11,$00,$0e,$38
        .byte   $01,$08,$0f,$38
        .byte   $09,$08,$10,$38
        .byte   $11,$08,$11,$38
        .byte   $01,$10,$12,$38
        .byte   $09,$10,$13,$38
        .byte   $11,$10,$14,$38

        .byte   9
        .byte   $00,$00,$15,$38
        .byte   $08,$00,$16,$38
        .byte   $10,$00,$17,$38
        .byte   $00,$08,$18,$38
        .byte   $08,$08,$19,$38
        .byte   $10,$08,$1a,$38
        .byte   $00,$10,$1b,$38
        .byte   $08,$10,$1c,$38
        .byte   $10,$10,$1d,$38

        .byte   9
        .byte   $02,$00,$1e,$38
        .byte   $0a,$00,$1f,$38
        .byte   $12,$00,$20,$38
        .byte   $02,$08,$21,$38
        .byte   $0a,$08,$22,$38
        .byte   $12,$08,$23,$38
        .byte   $01,$10,$24,$38
        .byte   $09,$10,$25,$38
        .byte   $11,$10,$26,$38

        .byte   9
        .byte   $05,$00,$27,$38
        .byte   $0d,$00,$28,$38
        .byte   $15,$00,$29,$38
        .byte   $05,$08,$2a,$38
        .byte   $0d,$08,$2b,$38
        .byte   $15,$08,$2c,$38
        .byte   $01,$10,$2d,$38
        .byte   $09,$10,$2e,$38
        .byte   $11,$10,$2f,$38

        .byte   7
        .byte   $05,$00,$30,$38
        .byte   $0d,$00,$31,$38
        .byte   $05,$08,$32,$38
        .byte   $0d,$08,$33,$38
        .byte   $01,$10,$34,$38
        .byte   $09,$10,$35,$38
        .byte   $11,$10,$36,$38

        .byte   9
        .byte   $01,$00,$37,$38
        .byte   $09,$00,$38,$38
        .byte   $11,$00,$39,$38
        .byte   $01,$08,$3a,$38
        .byte   $09,$08,$3b,$38
        .byte   $11,$08,$3c,$38
        .byte   $01,$10,$3d,$38
        .byte   $09,$10,$3e,$38
        .byte   $11,$10,$3f,$38

; ------------------------------------------------------------------------------
