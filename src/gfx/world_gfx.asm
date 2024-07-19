; ------------------------------------------------------------------------------

.include "gfx/world_gfx.inc"

; ------------------------------------------------------------------------------

.segment "world_pal"

; d2/ec00
World1BGPal:
        .incbin "world_1_bg.pal"

; d2/ed00
World2BGPal:
        .incbin "world_2_bg.pal"

; d2/ee00
World1SpritePal:
        .incbin "world_1_sprite.pal"

; d2/ef00
World2SpritePal:
        .incbin "world_2_sprite.pal"

; ------------------------------------------------------------------------------

.segment "vector_approach_gfx"

; d8/dfb8
VectorApproachGfx:
        .incbin "vector_approach.4bpp.lz"

; d8/e5bf
VectorApproachTiles:
        .incbin "vector_approach.scr.lz"

; ------------------------------------------------------------------------------

.segment "world_3_pal"

; d8/e6ba
World3Pal:
        .incbin "world_3.pal.lz"

; ------------------------------------------------------------------------------

.segment "world_gfx_ptrs"

begin_block WorldDataPtrs1, $60

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

end_block WorldDataPtrs1

; ------------------------------------------------------------------------------

.segment "world_gfx"

; ee/b290
WorldBackdropGfx:
        .incbin "world_backdrop.4bpp.lz"

; ee/c295
WorldBackdropTiles:
        .incbin "world_backdrop.scr.lz"

; ee/c702
AirshipGfx1:
        .incbin "airship1.4bpp.lz"

; ee/d434
WorldTilemap1:
        .incbin "src/world/world_1_tilemap.dat.lz"

; ef/114f
WorldGfx1:
        .incbin "world_1_bg.4bpp.lz"

; ef/3250
MagitekTrainGfx:
        .incbin "magitek_train.cgx.lz"

; ef/4846
MagitekTrainPal:
        .incbin "magitek_train.pal"

; ef/4a46
WorldGfx2:
        .incbin "world_2_bg.4bpp.lz"

; ef/6a56
WorldTilemap2:
        .incbin "src/world/world_2_tilemap.dat.lz"

; ef/9d17
WorldTilemap3:
        .incbin "src/world/world_3_tilemap.dat.lz"

; ef/b631
WorldGfx3:
        .incbin "world_3_bg.4bpp.lz"

; ef/c624
WorldChocoGfx1:
        .incbin "world_choco_1.4bpp.lz"

; ef/ce77
VectorApproachPal:
        .incbin "vector_approach.pal"

; ef/ce97
WorldEsperTerraPal:
        .incbin "world_esper_terra.pal"

; ef/ceb7
WorldAnimSpriteGfx:
        .incbin "world_anim_sprite.4bpp.lz"

; ef/cfb9
WorldMiscSpriteGfx:
        .incbin "world_misc_sprite.4bpp.lz"

; ef/dc4c
WorldChocoGfx2:
        .incbin "world_choco_2.4bpp.lz"

; ef/e49b
MinimapGfx1:
        .incbin "minimap_1.4bpp.lz"

; ef/e8b3
MinimapGfx2:
        .incbin "minimap_2.4bpp.lz"

; ef/ed26
AirshipGfx2:
        .incbin "airship2.4bpp.lz"

; ef/fac8
EndingAirshipPal:
        .incbin "ending_airship.pal"

; ------------------------------------------------------------------------------
