; ------------------------------------------------------------------------------

.include "world_gfx.inc"

; ------------------------------------------------------------------------------

.segment "world_pal"

; d2/ec00
World1BGPal:
        .incbin "assets/gfx/world_1_bg.pal"

; d2/ed00
World2BGPal:
        .incbin "assets/gfx/world_2_bg.pal"

; d2/ee00
World1SpritePal:
        .incbin "assets/gfx/world_1_sprite.pal"

; d2/ef00
World2SpritePal:
        .incbin "assets/gfx/world_2_sprite.pal"

; ------------------------------------------------------------------------------

.segment "vector_approach_gfx"

; d8/dfb8
VectorApproachGfx:
        .incbin "assets/gfx/vector_approach/vector_approach.4bpp.lz"

; d8/e5bf
VectorApproachTiles:
        .incbin "assets/gfx/vector_approach/vector_approach.scr.lz"

; ------------------------------------------------------------------------------

.segment "world_3_pal"

; d8/e6ba
World3Pal:
        .incbin "assets/gfx/world_3.pal.lz"

; ------------------------------------------------------------------------------

.segment "world_gfx_ptrs"

        fixed_block $60

; unused
@b200:  .faraddr WorldBackdropGfx
@b203:  .faraddr WorldBackdropGfx

WorldBackdropGfxPtr:
@b206:  .faraddr WorldBackdropGfx

WorldBackdropTilesPtr:
@b209:  .faraddr WorldBackdropTiles

AirshipGfx1Ptr:
@b20c:  .faraddr AirshipGfx1

WorldTilemap1Ptr:
@b20f:  .faraddr WorldTilemap1

WorldGfx1Ptr:
@b212:  .faraddr WorldGfx1

MagitekTrainGfxPtr:
@b215:  .faraddr MagitekTrainGfx

; unused
@b218:  .faraddr MagitekTrainPal

MagitekTrainPalPtr:
@b21b:  .faraddr MagitekTrainPal

WorldGfx2Ptr:
@b21e:  .faraddr WorldGfx2

; unused
@b221:  .faraddr WorldTilemap2

WorldTilemap2Ptr:
@b224:  .faraddr WorldTilemap2

WorldTilemap3Ptr:
@b227:  .faraddr WorldTilemap3

WorldGfx3Ptr:
@b22a:  .faraddr WorldGfx3

; unused
@b22d:  .faraddr WorldChocoGfx1

WorldChocoGfx1Ptr:
@b230:  .faraddr WorldChocoGfx1

; unused
@b233:  .faraddr VectorApproachPal

VectorApproachPalPtr:
@b236:  .faraddr VectorApproachPal

; unused
@b239:  .faraddr WorldEsperTerraPal

WorldEsperTerraPalPtr:
@b23c:  .faraddr WorldEsperTerraPal

; unused
@b23f:  .faraddr WorldAnimSpriteGfx

WorldAnimSpriteGfxPtr:
@b242:  .faraddr WorldAnimSpriteGfx

WorldMiscSpriteGfxPtr:
@b245:  .faraddr WorldMiscSpriteGfx

WorldChocoGfx2Ptr:
@b248:  .faraddr WorldChocoGfx2

MinimapGfx1Ptr:
@b24b:  .faraddr MinimapGfx1

MinimapGfx2Ptr:
@b24e:  .faraddr MinimapGfx2

AirshipGfx2Ptr:
@b251:  .faraddr AirshipGfx2

EndingAirshipPalPtr:
@b254:  .faraddr EndingAirshipPal

        end_fixed_block

; ------------------------------------------------------------------------------

.segment "world_gfx"

; ee/b290
WorldBackdropGfx:
        .incbin "assets/gfx/world_backdrop/world_backdrop.4bpp.lz"

; ee/c295
WorldBackdropTiles:
        .incbin "assets/gfx/world_backdrop/world_backdrop.scr.lz"

; ee/c702
AirshipGfx1:
        .incbin "assets/gfx/airship1.4bpp.lz"

; ee/d434
WorldTilemap1:
        .incbin "assets/data/world/world_1_tilemap.bin.lz"

; ef/114f
WorldGfx1:
        .incbin "assets/gfx/world_1_bg.4bpp.lz"

; ef/3250
MagitekTrainGfx:
        .incbin "assets/gfx/magitek_train.cgx.lz"

; ef/4846
MagitekTrainPal:
        .incbin "assets/gfx/magitek_train.pal"

; ef/4a46
WorldGfx2:
        .incbin "assets/gfx/world_2_bg.4bpp.lz"

; ef/6a56
WorldTilemap2:
        .incbin "assets/data/world/world_2_tilemap.bin.lz"

; ef/9d17
WorldTilemap3:
        .incbin "assets/data/world/world_3_tilemap.bin.lz"

; ef/b631
WorldGfx3:
        .incbin "assets/gfx/world_3_bg.4bpp.lz"

; ef/c624
WorldChocoGfx1:
        .incbin "assets/gfx/world_choco_1.4bpp.lz"

; ef/ce77
VectorApproachPal:
        .incbin "assets/gfx/vector_approach/vector_approach.pal"

; ef/ce97
WorldEsperTerraPal:
        .incbin "assets/gfx/world_esper_terra.pal"

; ef/ceb7
WorldAnimSpriteGfx:
        .incbin "assets/gfx/world_anim_sprite.4bpp.lz"

; ef/cfb9
WorldMiscSpriteGfx:
        .incbin "assets/gfx/world_misc_sprite.4bpp.lz"

; ef/dc4c
WorldChocoGfx2:
        .incbin "assets/gfx/world_choco_2.4bpp.lz"

; ef/e49b
MinimapGfx1:
        .incbin "assets/gfx/minimap_1.4bpp.lz"

; ef/e8b3
MinimapGfx2:
        .incbin "assets/gfx/minimap_2.4bpp.lz"

; ef/ed26
AirshipGfx2:
        .incbin "assets/gfx/airship2.4bpp.lz"

; ef/fac8
EndingAirshipPal:
        .incbin "assets/gfx/ending_airship.pal"

; ------------------------------------------------------------------------------
