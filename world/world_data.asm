
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world_data.asm                                                       |
; |                                                                            |
; | description: data for world module                                         |
; |                                                                            |
; | created: 8/15/2022                                                         |
; +----------------------------------------------------------------------------+

.segment "world_pal"

; d2/ec00
        .include "gfx/world_bg_pal1.asm"
; d2/ed00
        .include "gfx/world_bg_pal2.asm"
; d2/ee00
        .include "gfx/world_sprite_pal1.asm"
; d2/ef00
        .include "gfx/world_sprite_pal2.asm"

; ------------------------------------------------------------------------------

.segment "mode7_cutscene_data"

; d8/dd00 Pointers to Magitek Train Ride Tile Graphics (29 items, 12x2 bytes each, +$7E0000)
        .res $02b8

; d8/dfb8 Vector Panorama Graphics (compressed)
        .res $0607

; d8/e5bf Vector Panorama Tilemap (compressed)
        .res $00fb

; d8/e6ba
        .include "gfx/snake_road_pal.asm"

; ------------------------------------------------------------------------------

.segment "world_data"

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

TrainGfxPtr:
@b215:  .faraddr TrainGfx

; unused
@b218:  .faraddr TrainPal

TrainPalPtr:
@b21b:  .faraddr TrainPal

WorldGfx2Ptr:
@b21e:  .faraddr WorldGfx2
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
@b23f:  .faraddr WorldSpriteGfx1

WorldSpriteGfx1Ptr:
@b242:  .faraddr WorldSpriteGfx1

WorldSpriteGfx2Ptr:
@b245:  .faraddr WorldSpriteGfx2

WorldChocoGfx2Ptr:
@b248:  .faraddr WorldChocoGfx2

MinimapGfx1Ptr:
@b24b:  .faraddr MinimapGfx1

MinimapGfx2Ptr:
@b24e:  .faraddr MinimapGfx2

AirshipGfx2Ptr:
@b251:  .faraddr AirshipGfx2

EndingAirshipScenePalPtr:
@b254:  .faraddr EndingAirshipScenePal

        .res 3*3

; ------------------------------------------------------------------------------

; ee/b260
WorldModDataPtrs:
        .res 3*3

; ee/b269
VehicleEvent_00:
        .faraddr $000068

VehicleEvent_01:
        .faraddr $00004f

VehicleEvent_02:
        .faraddr $000059

VehicleEvent_03:
        .faraddr $000088

VehicleEvent_04:
        .faraddr $00007f

VehicleEvent_05:
        .faraddr $00008f

VehicleEvent_06:
        .faraddr $000096

        .res 6*3

; ------------------------------------------------------------------------------

; ee/b290   World Map Clouds Graphics (compressed)
        .include "gfx/world_backdrop_gfx.asm"

; ee/c295   World Map Clouds Tile Formation (compressed)
        .include "gfx/world_backdrop_tiles.asm"

; ee/c702   Blackjack Graphics (compressed)
        .include "gfx/airship_gfx1.asm"

; ee/d434   World of Balance Map Formation (compressed)
        .include "data/world_tilemap1.asm"

; ef/114f   World of Balance Graphics (compressed)
        .include "gfx/world_gfx1.asm"

; ef/3250   Magitek Train Ride Graphics (variable size tiles, compressed)
        .include "gfx/train_gfx.asm"

; ef/4846   Magitek Train Ride Palettes
        .include "gfx/train_pal.asm"

; ef/4a46   World of Ruin Graphics (compressed)
        .include "gfx/world_gfx2.asm"

; ef/6a56   World of Ruin Map Formation (compressed)
        .include "data/world_tilemap2.asm"

; ef/9d17   Serpent Trench Map Formation (compressed)
        .include "data/world_tilemap3.asm"

; ef/b631   Serpent Trench Graphics (compressed)
        .include "gfx/world_gfx3.asm"

; ef/c624   Some Chocobo Graphics (compressed)
        .include "gfx/world_choco_gfx1.asm"

; ef/ce77   Vector Approach Palette
        .include "gfx/vector_approach_pal.asm"

; ef/ce97   Esper Terra Palette
        .include "gfx/world_esper_terra_pal.asm"

; ef/ceb7   Airship Shadow and Perspective Graphics (compressed)
        .include "gfx/world_sprite_gfx1.asm"

; ef/cfb9   Various Sprites (ship, esper terra, figaro, etc., compressed)
        .include "gfx/world_sprite_gfx2.asm"

; ef/dc4c   More Chocobo Graphics (world map, compressed)
        .include "gfx/world_choco_gfx2.asm"

; ef/e49b   World of Balance Minimap Graphics (compressed)
        .include "gfx/minimap_gfx1.asm"

; ef/e8b3   World of Ruin Minimap Graphics (compressed)
        .include "gfx/minimap_gfx2.asm"

; ef/ed26   Falcon Graphics (compressed)
        .include "gfx/airship_gfx2.asm"

; ef/fac8   Palettes for Ending Airship Scene
        .include "gfx/ending_airship_scene_pal.asm"

; ------------------------------------------------------------------------------

.segment "world_sine"

; ef/fef0
        .include "data/world_sine.asm"

; ------------------------------------------------------------------------------
