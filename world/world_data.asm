
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

.segment "world_mod"

        .include "data/world_mod_data.asm"                      ; ce/f600
        WorldModData_end := *
        .include "data/world_mod_tiles.asm"                     ; ce/f648
        .res $0500+WorldModData-*

; unused (30 * 3 bytes)
        .faraddr 1,2,3,4,5,6,7,8,9,0,0,0,0,0,0                  ; ce/fb00
        .faraddr 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; ------------------------------------------------------------------------------

.segment "world_pal"

        .include "gfx/world_bg_pal1.asm"                        ; d2/ec00
        .include "gfx/world_bg_pal2.asm"                        ; d2/ed00
        .include "gfx/world_sprite_pal1.asm"                    ; d2/ee00
        .include "gfx/world_sprite_pal2.asm"                    ; d2/ef00

; ------------------------------------------------------------------------------

.segment "cutscene_mode7"

        .include "data/magitek_train_tiles.asm"                 ; d8/dd00
        .include "gfx/vector_approach_gfx.asm"                  ; d8/dfb8
        .include "gfx/vector_approach_tiles.asm"                ; d8/e5bf
        .include "gfx/snake_road_pal.asm"                       ; d8/e6ba

; ------------------------------------------------------------------------------

.export WorldBackdropGfxPtr, WorldBackdropTilesPtr

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

MagitekTrainGfxPtr:
@b215:  .faraddr MagitekTrainGfx

; unused
@b218:  .faraddr MagitekTrainPal

MagitekTrainPalPtr:
@b21b:  .faraddr MagitekTrainPal

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
        make_ptr_tbl_far WorldModData, 2, 0
        .faraddr WorldModData_end

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

        .include "gfx/world_backdrop_gfx.asm"                   ; ee/b290
        .include "gfx/world_backdrop_tiles.asm"                 ; ee/c295
        .include "gfx/airship_gfx1.asm"                         ; ee/c702
        .include "data/world_tilemap1.asm"                      ; ee/d434
        .include "gfx/world_gfx1.asm"                           ; ef/114f
        .include "gfx/magitek_train_gfx.asm"                    ; ef/3250
        .include "gfx/magitek_train_pal.asm"                    ; ef/4846
        .include "gfx/world_gfx2.asm"                           ; ef/4a46
        .include "data/world_tilemap2.asm"                      ; ef/6a56
        .include "data/world_tilemap3.asm"                      ; ef/9d17
        .include "gfx/world_gfx3.asm"                           ; ef/b631
        .include "gfx/world_choco_gfx1.asm"                     ; ef/c624
        .include "gfx/vector_approach_pal.asm"                  ; ef/ce77
        .include "gfx/world_esper_terra_pal.asm"                ; ef/ce97
        .include "gfx/world_sprite_gfx1.asm"                    ; ef/ceb7
        .include "gfx/world_sprite_gfx2.asm"                    ; ef/cfb9
        .include "gfx/world_choco_gfx2.asm"                     ; ef/dc4c
        .include "gfx/minimap_gfx1.asm"                         ; ef/e49b
        .include "gfx/minimap_gfx2.asm"                         ; ef/e8b3
        .include "gfx/airship_gfx2.asm"                         ; ef/ed26
        .include "gfx/ending_airship_scene_pal.asm"             ; ef/fac8

; ------------------------------------------------------------------------------

.segment "world_sine"

        .include "data/world_sine.asm"                          ; ef/fef0

; ------------------------------------------------------------------------------
