; ------------------------------------------------------------------------------

.include "gfx/battle_bg.inc"
.include "gfx/map_gfx.inc"

; ------------------------------------------------------------------------------

.macro inc_battle_bg_tiles id, name
        array_item BattleBGTiles, {BATTLE_BG_TILES::id} := *
        .incbin .sprintf("battle_bg_tiles/%s.scr.lz", name)
.endmac

.macro inc_battle_bg_gfx id, name
        array_item BattleBGGfx, {BATTLE_BG_GFX::id} := *
        .incbin .sprintf("battle_bg_gfx/%s.4bpp.lz", name)
.endmac

.macro inc_battle_bg_gfx_lang id, name
        array_item BattleBGGfx, {BATTLE_BG_GFX::id} := *
        .incbin .sprintf("battle_bg_gfx/%s_%s.4bpp.lz", name, LANG_SUFFIX)
.endmac

; ------------------------------------------------------------------------------

.segment "battle_bg"

; ------------------------------------------------------------------------------

; [ battle background properties (6 bytes each) ]

;   0: graphics 1 -> VRAM $1000
;   1: graphics 2 -> VRAM $1800
;   2: graphics 3 -> VRAM $4800
;   3: tilemap 1 -> VRAM $6000
;   4: tilemap 2 (unused)
;   5: palette -> BG palettes 5, 6, 7

; [ notes ]

; - each graphics block is 64 tiles (4096 bytes)
; - some battle bg graphics are shared with map background graphics,
;   while others are used for battle bg only
; - a graphics block with BATTLE_BG_GFX::NONE ($ff) is not loaded
; - if bit 0.7 is set, graphics 1 is 128 tiles and graphics 2 is not loaded
; - tilemaps are 32x32 (2048 bytes) though only the first 19 rows are
;   visible unless the background scrolls vertically (clouds, waterfall)
; - palettes contain 48 colors (96 bytes)
; - if bit 5.7 is set, a wavy effect is applied to the background using HDMA

; e7/0000
BattleBGProp:

; ------------------------------------------------------------------------------

; 0: field_wob
        .byte BATTLE_BG_GFX::FIELD_1
        .byte BATTLE_BG_GFX::FIELD_2
        .byte BATTLE_BG_GFX::FIELD_3
        .byte BATTLE_BG_TILES::FIELD_WOB
        .byte BATTLE_BG_TILES::FIELD_WOB
        .byte BATTLE_BG_PAL::FIELD_WOB

; ------------------------------------------------------------------------------

; 1: forest_wor
        .byte BATTLE_BG_GFX::FOREST_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::FOREST_1
        .byte BATTLE_BG_TILES::FOREST
        .byte BATTLE_BG_TILES::FOREST
        .byte BATTLE_BG_PAL::FOREST_WOR

; ------------------------------------------------------------------------------

; 2: desert_wob
        .byte BATTLE_BG_GFX::DESERT_1
        .byte BATTLE_BG_GFX::DESERT_2
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::DESERT
        .byte BATTLE_BG_TILES::DESERT
        .byte BATTLE_BG_PAL::DESERT_WOB | $80

; ------------------------------------------------------------------------------

; 3: forest_wob
        .byte BATTLE_BG_GFX::FOREST_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::FOREST_1
        .byte BATTLE_BG_TILES::FOREST
        .byte BATTLE_BG_TILES::FOREST
        .byte BATTLE_BG_PAL::FOREST_WOB

; ------------------------------------------------------------------------------

; 4: zozo_int
        .byte BATTLE_BG_GFX::TOWN_INT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::TOWN_INT_1
        .byte BATTLE_BG_TILES::TOWN_INT
        .byte BATTLE_BG_TILES::TOWN_INT
        .byte BATTLE_BG_PAL::ZOZO_INT

; ------------------------------------------------------------------------------

; 5: field_wor
        .byte BATTLE_BG_GFX::FIELD_1
        .byte BATTLE_BG_GFX::FIELD_3
        .byte BATTLE_BG_GFX::FIELD_WOR
        .byte BATTLE_BG_TILES::FIELD_WOR
        .byte BATTLE_BG_TILES::FIELD_WOR
        .byte BATTLE_BG_PAL::FIELD_WOR

; ------------------------------------------------------------------------------

; 6: veldt
        .byte BATTLE_BG_GFX::FIELD_1
        .byte BATTLE_BG_GFX::FIELD_3
        .byte BATTLE_BG_GFX::VELDT
        .byte BATTLE_BG_TILES::VELDT
        .byte BATTLE_BG_TILES::VELDT
        .byte BATTLE_BG_PAL::VELDT

; ------------------------------------------------------------------------------

; 7: clouds
        .byte BATTLE_BG_GFX::CLOUDS_1
        .byte BATTLE_BG_GFX::CLOUDS_2
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::CLOUDS
        .byte BATTLE_BG_TILES::CLOUDS
        .byte BATTLE_BG_PAL::AIRSHIP_WOB

; ------------------------------------------------------------------------------

; 8: narshe_ext
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::TOWN_EXT_1
        .byte BATTLE_BG_GFX::TOWN_EXT_2
        .byte BATTLE_BG_TILES::NARSHE_EXT
        .byte BATTLE_BG_TILES::NARSHE_EXT
        .byte BATTLE_BG_PAL::NARSHE_EXT

; ------------------------------------------------------------------------------

; 9: narshe_caves_1
        .byte BATTLE_BG_GFX::CAVES_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::CAVES_1
        .byte BATTLE_BG_TILES::NARSHE_CAVES
        .byte BATTLE_BG_TILES::NARSHE_CAVES
        .byte BATTLE_BG_PAL::NARSHE_CAVES

; ------------------------------------------------------------------------------

; 10: caves
        .byte BATTLE_BG_GFX::CAVES_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::CAVES_1
        .byte BATTLE_BG_TILES::CAVES
        .byte BATTLE_BG_TILES::CAVES
        .byte BATTLE_BG_PAL::CAVES

; ------------------------------------------------------------------------------

; 11: mountains_ext
        .byte BATTLE_BG_GFX::MOUNTAINS_EXT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::MOUNTAINS_EXT_1
        .byte BATTLE_BG_TILES::MOUNTAINS_EXT
        .byte BATTLE_BG_TILES::MOUNTAINS_EXT
        .byte BATTLE_BG_PAL::MOUNTAINS_EXT

; ------------------------------------------------------------------------------

; 12: mountains_int
        .byte BATTLE_BG_GFX::MOUNTAINS_INT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::MOUNTAINS_INT_1
        .byte BATTLE_BG_TILES::MOUNTAINS_INT
        .byte BATTLE_BG_TILES::MOUNTAINS_INT
        .byte BATTLE_BG_PAL::MOUNTAINS_INT

; ------------------------------------------------------------------------------

; 13: river
        .byte BATTLE_BG_GFX::RIVER_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::RIVER_1
        .byte BATTLE_BG_TILES::RIVER
        .byte BATTLE_BG_TILES::RIVER
        .byte BATTLE_BG_PAL::RIVER

; ------------------------------------------------------------------------------

; 14: imp_camp
        .byte BATTLE_BG_GFX::IMP_CAMP_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::IMP_CAMP_1
        .byte BATTLE_BG_TILES::IMP_CAMP
        .byte BATTLE_BG_TILES::IMP_CAMP
        .byte BATTLE_BG_PAL::IMP_CAMP

; ------------------------------------------------------------------------------

; 15: train_ext
        .byte BATTLE_BG_GFX::TRAIN_EXT_3
        .byte BATTLE_BG_GFX::TRAIN_EXT_2
        .byte BATTLE_BG_GFX::TRAIN_EXT_1
        .byte BATTLE_BG_TILES::TRAIN_EXT
        .byte BATTLE_BG_TILES::TRAIN_EXT
        .byte BATTLE_BG_PAL::TRAIN_EXT

; ------------------------------------------------------------------------------

; 16: train_int
        .byte BATTLE_BG_GFX::TRAIN_INT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::TRAIN_INT_1
        .byte BATTLE_BG_TILES::TRAIN_INT
        .byte BATTLE_BG_TILES::TRAIN_INT
        .byte BATTLE_BG_PAL::TRAIN_INT

; ------------------------------------------------------------------------------

; 17: narshe_caves_2
        .byte BATTLE_BG_GFX::CAVES_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::CAVES_1
        .byte BATTLE_BG_TILES::CAVES
        .byte BATTLE_BG_TILES::CAVES
        .byte BATTLE_BG_PAL::NARSHE_CAVES

; ------------------------------------------------------------------------------

; 18: snowfields
        .byte BATTLE_BG_GFX::FIELD_1
        .byte BATTLE_BG_GFX::FIELD_2
        .byte BATTLE_BG_GFX::FIELD_3
        .byte BATTLE_BG_TILES::SNOWFIELDS
        .byte BATTLE_BG_TILES::SNOWFIELDS
        .byte BATTLE_BG_PAL::SNOWFIELDS

; ------------------------------------------------------------------------------

; 19: town_ext
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::TOWN_EXT_1
        .byte BATTLE_BG_GFX::TOWN_EXT_2
        .byte BATTLE_BG_TILES::TOWN_EXT
        .byte BATTLE_BG_TILES::TOWN_EXT
        .byte BATTLE_BG_PAL::TOWN_EXT

; ------------------------------------------------------------------------------

; 20: imp_castle
        .byte BATTLE_BG_GFX::IMP_CASTLE_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::IMP_CASTLE_1
        .byte BATTLE_BG_TILES::IMP_CASTLE
        .byte BATTLE_BG_TILES::IMP_CASTLE
        .byte BATTLE_BG_PAL::IMP_CASTLE

; ------------------------------------------------------------------------------

; 21: floating_island
        .byte BATTLE_BG_GFX::FLOATING_ISLAND_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::FLOATING_ISLAND_1
        .byte BATTLE_BG_TILES::FLOATING_ISLAND
        .byte BATTLE_BG_TILES::FLOATING_ISLAND
        .byte BATTLE_BG_PAL::FLOATING_ISLAND

; ------------------------------------------------------------------------------

; 22: kefkas_tower_ext
        .byte BATTLE_BG_GFX::KEFKAS_TOWER_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::KEFKAS_TOWER_1
        .byte BATTLE_BG_TILES::KEFKAS_TOWER_EXT
        .byte BATTLE_BG_TILES::KEFKAS_TOWER_EXT
        .byte BATTLE_BG_PAL::KEFKAS_TOWER_EXT

; ------------------------------------------------------------------------------

; 23: opera_stage
        .byte BATTLE_BG_GFX::OPERA_CURTAIN | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::OPERA_STAGE
        .byte BATTLE_BG_TILES::OPERA_STAGE
        .byte BATTLE_BG_TILES::OPERA_STAGE
        .byte BATTLE_BG_PAL::OPERA_STAGE

; ------------------------------------------------------------------------------

; 24: opera_catwalk
        .byte BATTLE_BG_GFX::OPERA_CURTAIN | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::OPERA_CATWALK
        .byte BATTLE_BG_TILES::OPERA_CATWALK
        .byte BATTLE_BG_TILES::OPERA_CATWALK
        .byte BATTLE_BG_PAL::OPERA_CATWALK

; ------------------------------------------------------------------------------

; 25: burning_building
        .byte BATTLE_BG_GFX::BURNING_BLDG_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::BURNING_BLDG_1
        .byte BATTLE_BG_TILES::BURNING_BUILDING
        .byte BATTLE_BG_TILES::BURNING_BUILDING
        .byte BATTLE_BG_PAL::BURNING_BUILDING | $80

; ------------------------------------------------------------------------------

; 26: castle_int
        .byte BATTLE_BG_GFX::CASTLE_INT
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::CASTLE_INT
        .byte BATTLE_BG_TILES::CASTLE_INT
        .byte BATTLE_BG_PAL::CASTLE_INT

; ------------------------------------------------------------------------------

; 27: magitek_lab
        .byte BATTLE_BG_GFX::MAGITEK_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::MAGITEK_1
        .byte BATTLE_BG_TILES::MAGITEK_LAB
        .byte BATTLE_BG_TILES::MAGITEK_LAB
        .byte BATTLE_BG_PAL::MAGITEK

; ------------------------------------------------------------------------------

; 28: colosseum
        .byte BATTLE_BG_GFX::FIELD_3
        .byte BATTLE_BG_GFX::COLOSSEUM
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::COLOSSEUM
        .byte BATTLE_BG_TILES::COLOSSEUM
        .byte BATTLE_BG_PAL::COLOSSEUM

; ------------------------------------------------------------------------------

; 29: magitek_factory
        .byte BATTLE_BG_GFX::MAGITEK_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::MAGITEK_1
        .byte BATTLE_BG_TILES::MAGITEK_FACTORY
        .byte BATTLE_BG_TILES::MAGITEK_FACTORY
        .byte BATTLE_BG_PAL::MAGITEK

; ------------------------------------------------------------------------------

; 30: village_ext
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::TOWN_EXT_1
        .byte BATTLE_BG_GFX::TOWN_EXT_2
        .byte BATTLE_BG_TILES::VILLAGE_EXT
        .byte BATTLE_BG_TILES::VILLAGE_EXT
        .byte BATTLE_BG_PAL::VILLAGE_EXT

; ------------------------------------------------------------------------------

; 31: waterfall
        .byte BATTLE_BG_GFX::WATERFALL
        .byte 0
        .byte 0
        .byte BATTLE_BG_TILES::WATERFALL
        .byte BATTLE_BG_TILES::WATERFALL
        .byte BATTLE_BG_PAL::WATERFALL

; ------------------------------------------------------------------------------

; 32: owzers_house
        .byte BATTLE_BG_GFX::TOWN_INT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::TOWN_INT_1
        .byte BATTLE_BG_TILES::OWZERS_HOUSE
        .byte BATTLE_BG_TILES::OWZERS_HOUSE
        .byte BATTLE_BG_PAL::OWZERS_HOUSE

; ------------------------------------------------------------------------------

; 33: train_tracks
        .byte BATTLE_BG_GFX::FOREST_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::FOREST_1
        .byte BATTLE_BG_TILES::TRAIN_TRACKS
        .byte BATTLE_BG_TILES::TRAIN_TRACKS
        .byte BATTLE_BG_PAL::TRAIN_TRACKS

; ------------------------------------------------------------------------------

; 34: sealed_gate
        .byte BATTLE_BG_GFX::SEALED_GATE_1 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::SEALED_GATE_2
        .byte BATTLE_BG_TILES::SEALED_GATE
        .byte BATTLE_BG_TILES::SEALED_GATE
        .byte BATTLE_BG_PAL::SEALED_GATE

; ------------------------------------------------------------------------------

; 35: underwater
        .byte BATTLE_BG_GFX::MOUNTAINS_EXT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::UNDERWATER
        .byte BATTLE_BG_TILES::UNDERWATER
        .byte BATTLE_BG_TILES::UNDERWATER
        .byte BATTLE_BG_PAL::UNDERWATER | $80

; ------------------------------------------------------------------------------

; 36: zozo
        .byte BATTLE_BG_GFX::ZOZO_1 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::ZOZO_2
        .byte BATTLE_BG_TILES::ZOZO
        .byte BATTLE_BG_TILES::ZOZO
        .byte BATTLE_BG_PAL::ZOZO_EXT

; ------------------------------------------------------------------------------

; 37: airship_center
        .byte BATTLE_BG_GFX::CLOUDS_1
        .byte BATTLE_BG_GFX::CLOUDS_2
        .byte BATTLE_BG_GFX::AIRSHIP
        .byte BATTLE_BG_TILES::AIRSHIP_CENTER
        .byte BATTLE_BG_TILES::AIRSHIP_CENTER
        .byte BATTLE_BG_PAL::AIRSHIP_WOB

; ------------------------------------------------------------------------------

; 38: darills_tomb
        .byte BATTLE_BG_GFX::DARILLS_TOMB_1
        .byte BATTLE_BG_GFX::DARILLS_TOMB_3
        .byte BATTLE_BG_GFX::DARILLS_TOMB_2
        .byte BATTLE_BG_TILES::DARILLS_TOMB
        .byte BATTLE_BG_TILES::DARILLS_TOMB
        .byte BATTLE_BG_PAL::DARILLS_TOMB

; ------------------------------------------------------------------------------

; 39: doma_castle
        .byte BATTLE_BG_GFX::CASTLE_EXT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::CASTLE_EXT_1
        .byte BATTLE_BG_TILES::CASTLE_EXT
        .byte BATTLE_BG_TILES::CASTLE_EXT
        .byte BATTLE_BG_PAL::CASTLE_EXT

; ------------------------------------------------------------------------------

; 40: kefkas_tower_int
        .byte BATTLE_BG_GFX::KEFKAS_TOWER_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::KEFKAS_TOWER_1
        .byte BATTLE_BG_TILES::KEFKAS_TOWER_INT
        .byte BATTLE_BG_TILES::KEFKAS_TOWER_INT
        .byte BATTLE_BG_PAL::KEFKAS_TOWER_INT

; ------------------------------------------------------------------------------

; 41: airship_wor
        .byte BATTLE_BG_GFX::CLOUDS_1
        .byte BATTLE_BG_GFX::CLOUDS_2
        .byte BATTLE_BG_GFX::AIRSHIP
        .byte BATTLE_BG_TILES::AIRSHIP
        .byte BATTLE_BG_TILES::AIRSHIP
        .byte BATTLE_BG_PAL::AIRSHIP_WOR

; ------------------------------------------------------------------------------

; 42: fire_caves
        .byte BATTLE_BG_GFX::CAVES_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::CAVES_1
        .byte BATTLE_BG_TILES::CAVES
        .byte BATTLE_BG_TILES::CAVES
        .byte BATTLE_BG_PAL::FIRE_CAVES

; ------------------------------------------------------------------------------

; 43: town_int
        .byte BATTLE_BG_GFX::TOWN_INT_2 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::TOWN_INT_1
        .byte BATTLE_BG_TILES::TOWN_INT
        .byte BATTLE_BG_TILES::TOWN_INT
        .byte BATTLE_BG_PAL::TOWN_INT

; ------------------------------------------------------------------------------

; 44: magitek_train
        .byte BATTLE_BG_GFX::MAGITEK_TRAIN_2
        .byte BATTLE_BG_GFX::MAGITEK_TRAIN_1
        .byte 0
        .byte BATTLE_BG_TILES::MAGITEK_TRAIN
        .byte BATTLE_BG_TILES::MAGITEK_TRAIN
        .byte BATTLE_BG_PAL::MAGITEK_TRAIN

; ------------------------------------------------------------------------------

; 45: fanatics_tower
        .byte BATTLE_BG_GFX::ZOZO_1 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::FANATICS_TOWER
        .byte BATTLE_BG_TILES::FANATICS_TOWER
        .byte BATTLE_BG_TILES::FANATICS_TOWER
        .byte BATTLE_BG_PAL::FANATICS_TOWER

; ------------------------------------------------------------------------------

; 46: cyans_dream
        .byte BATTLE_BG_GFX::CYANS_DREAM_1
        .byte BATTLE_BG_GFX::CYANS_DREAM_2
        .byte 0
        .byte BATTLE_BG_TILES::CYANS_DREAM
        .byte BATTLE_BG_TILES::CYANS_DREAM
        .byte BATTLE_BG_PAL::CYANS_DREAM | $80

; ------------------------------------------------------------------------------

; 47: desert_wor
        .byte BATTLE_BG_GFX::DESERT_1
        .byte BATTLE_BG_GFX::DESERT_2
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::DESERT
        .byte BATTLE_BG_TILES::DESERT
        .byte BATTLE_BG_PAL::DESERT_WOR | $80

; ------------------------------------------------------------------------------

; 48: airship_wob
        .byte BATTLE_BG_GFX::CLOUDS_1
        .byte BATTLE_BG_GFX::CLOUDS_2
        .byte BATTLE_BG_GFX::AIRSHIP
        .byte BATTLE_BG_TILES::AIRSHIP
        .byte BATTLE_BG_TILES::AIRSHIP
        .byte BATTLE_BG_PAL::AIRSHIP_WOB

; ------------------------------------------------------------------------------

; 49: unused
        .byte BATTLE_BG_GFX::TOWN_EXT_1
        .byte BATTLE_BG_GFX::TOWN_EXT_2
        .byte BATTLE_BG_GFX::BATTLE_BG_GFX_2
        .byte BATTLE_BG_TILES::FIELD_WOB
        .byte BATTLE_BG_TILES::FIELD_WOB
        .byte BATTLE_BG_PAL::FIELD_WOB

; ------------------------------------------------------------------------------

; 50: ghost_train
        .byte BATTLE_BG_GFX::GHOST_TRAIN_1 | $80
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_GFX::GHOST_TRAIN_2
        .byte BATTLE_BG_TILES::GHOST_TRAIN
        .byte BATTLE_BG_TILES::GHOST_TRAIN
        .byte BATTLE_BG_PAL::FIELD_WOB

; ------------------------------------------------------------------------------

; 51: final_battle_1
        .byte BATTLE_BG_GFX::FINAL_BATTLE_1
        .byte BATTLE_BG_GFX::FINAL_BATTLE_2
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::FINAL_BATTLE_1
        .byte BATTLE_BG_TILES::FINAL_BATTLE_1
        .byte BATTLE_BG_PAL::FINAL_BATTLE_1

; ------------------------------------------------------------------------------

; 52: final_battle_2
        .byte BATTLE_BG_GFX::FINAL_BATTLE_3
        .byte BATTLE_BG_GFX::FINAL_BATTLE_4
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::FINAL_BATTLE_2
        .byte BATTLE_BG_TILES::FINAL_BATTLE_2
        .byte BATTLE_BG_PAL::FINAL_BATTLE_2

; ------------------------------------------------------------------------------

; 53: final_battle_3
        .byte BATTLE_BG_GFX::FINAL_BATTLE_5
        .byte BATTLE_BG_GFX::FINAL_BATTLE_6
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::FINAL_BATTLE_3
        .byte BATTLE_BG_TILES::FINAL_BATTLE_3
        .byte BATTLE_BG_PAL::FINAL_BATTLE_3

; ------------------------------------------------------------------------------

; 54: final_battle_4
        .byte BATTLE_BG_GFX::FINAL_BATTLE_7
        .byte BATTLE_BG_GFX::FINAL_BATTLE_8
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::FINAL_BATTLE_4
        .byte BATTLE_BG_TILES::FINAL_BATTLE_4
        .byte BATTLE_BG_PAL::FINAL_BATTLE_4

; ------------------------------------------------------------------------------

; 55: tentacles
        .byte BATTLE_BG_GFX::TENTACLES
        .byte BATTLE_BG_GFX::CASTLE_INT
        .byte BATTLE_BG_GFX::NONE
        .byte BATTLE_BG_TILES::TENTACLES
        .byte BATTLE_BG_TILES::TENTACLES
        .byte BATTLE_BG_PAL::TENTACLES | $80

; ------------------------------------------------------------------------------

; e7/0150
BattleBGPal:
        .incbin "battle_bg_pal/field_wob.pal"
        .incbin "battle_bg_pal/narshe_ext.pal"
        .incbin "battle_bg_pal/narshe_caves.pal"
        .incbin "battle_bg_pal/caves.pal"
        .incbin "battle_bg_pal/mountains_ext.pal"
        .incbin "battle_bg_pal/mountains_int.pal"
        .incbin "battle_bg_pal/river.pal"
        .incbin "battle_bg_pal/imp_camp.pal"
        .incbin "battle_bg_pal/train_ext.pal"
        .incbin "battle_bg_pal/train_int.pal"
        .incbin "battle_bg_pal/fanatics_tower.pal"
        .incbin "battle_bg_pal/desert_wob.pal"
        .incbin "battle_bg_pal/forest_wob.pal"
        .incbin "battle_bg_pal/field_wor.pal"
        .incbin "battle_bg_pal/veldt.pal"
        .incbin "battle_bg_pal/snowfields.pal"
        .incbin "battle_bg_pal/town_ext.pal"
        .incbin "battle_bg_pal/imp_castle.pal"
        .incbin "battle_bg_pal/floating_island.pal"
        .incbin "battle_bg_pal/kefkas_tower_ext.pal"
        .incbin "battle_bg_pal/opera_stage.pal"
        .incbin "battle_bg_pal/opera_catwalk.pal"
        .incbin "battle_bg_pal/burning_building.pal"
        .incbin "battle_bg_pal/castle_int.pal"
        .incbin "battle_bg_pal/magitek.pal"
        .incbin "battle_bg_pal/colosseum.pal"
        .incbin "battle_bg_pal/sealed_gate.pal"
        .incbin "battle_bg_pal/village_ext.pal"
        .incbin "battle_bg_pal/waterfall.pal"
        .incbin "battle_bg_pal/unused_1d.pal"
        .incbin "battle_bg_pal/train_tracks.pal"
        .incbin "battle_bg_pal/unused_1f.pal"
        .incbin "battle_bg_pal/tentacles.pal"
        .incbin "battle_bg_pal/fire_caves.pal"
        .incbin "battle_bg_pal/town_int.pal"
        .incbin "battle_bg_pal/zozo_int.pal"
        .incbin "battle_bg_pal/underwater.pal"
        .incbin "battle_bg_pal/zozo_ext.pal"
        .incbin "battle_bg_pal/airship_wob.pal"
        .incbin "battle_bg_pal/darills_tomb.pal"
        .incbin "battle_bg_pal/castle_ext.pal"
        .incbin "battle_bg_pal/kefkas_tower_int.pal"
        .incbin "battle_bg_pal/unused_2a.pal"
        .incbin "battle_bg_pal/owzers_house.pal"
        .incbin "battle_bg_pal/final_battle_1.pal"
        .incbin "battle_bg_pal/final_battle_2.pal"
        .incbin "battle_bg_pal/final_battle_3.pal"
        .incbin "battle_bg_pal/magitek_train.pal"
        .incbin "battle_bg_pal/final_battle_4.pal"
        .incbin "battle_bg_pal/forest_wor.pal"
        .incbin "battle_bg_pal/cyans_dream.pal"
        .incbin "battle_bg_pal/airship_wor.pal"
        .incbin "battle_bg_pal/desert_wor.pal"
        .res 96*3, 0

; ------------------------------------------------------------------------------

; e7/1650
BattleBGGfxPtrs:
        ptr_tbl_far BattleBGGfx
        .res 93*3, 0

; ------------------------------------------------------------------------------

; e7/1848
BattleBGTilesPtrs:
        ptr_tbl BattleBGTiles

.repeat $70 - BattleBGTiles::ARRAY_LENGTH
        .addr BattleBGTiles
.endrep

; ------------------------------------------------------------------------------

; e7/1928
BattleBGTiles:
        inc_battle_bg_tiles FIELD_WOB, "field_wob"
        inc_battle_bg_tiles NARSHE_EXT, "narshe_ext"
        inc_battle_bg_tiles NARSHE_CAVES, "narshe_caves"
        inc_battle_bg_tiles CAVES, "caves"
        inc_battle_bg_tiles MOUNTAINS_EXT, "mountains_ext"
        inc_battle_bg_tiles MOUNTAINS_INT, "mountains_int"
        inc_battle_bg_tiles RIVER, "river"
        inc_battle_bg_tiles IMP_CAMP, "imp_camp"
        inc_battle_bg_tiles TRAIN_EXT, "train_ext"
        inc_battle_bg_tiles TRAIN_INT, "train_int"
        inc_battle_bg_tiles FANATICS_TOWER, "fanatics_tower"
        inc_battle_bg_tiles DESERT, "desert"
        inc_battle_bg_tiles FOREST, "forest"
        inc_battle_bg_tiles FIELD_WOR, "field_wor"
        inc_battle_bg_tiles VELDT, "veldt"
        inc_battle_bg_tiles SNOWFIELDS, "snowfields"
        inc_battle_bg_tiles TOWN_EXT, "town_ext"
        inc_battle_bg_tiles IMP_CASTLE, "imp_castle"
        inc_battle_bg_tiles FLOATING_ISLAND, "floating_island"
        inc_battle_bg_tiles KEFKAS_TOWER_EXT, "kefkas_tower_ext"
        inc_battle_bg_tiles OPERA_STAGE, "opera_stage"
        inc_battle_bg_tiles OPERA_CATWALK, "opera_catwalk"
        inc_battle_bg_tiles BURNING_BUILDING, "burning_building"
        inc_battle_bg_tiles CASTLE_INT, "castle_int"
        inc_battle_bg_tiles MAGITEK_LAB, "magitek_lab"
        inc_battle_bg_tiles COLOSSEUM, "colosseum"
        inc_battle_bg_tiles SEALED_GATE, "sealed_gate"
        inc_battle_bg_tiles VILLAGE_EXT, "village_ext"
        inc_battle_bg_tiles WATERFALL, "waterfall"
        inc_battle_bg_tiles OWZERS_HOUSE, "owzers_house"
        inc_battle_bg_tiles TRAIN_TRACKS, "train_tracks"
        inc_battle_bg_tiles CLOUDS, "clouds"
        inc_battle_bg_tiles TENTACLES, "tentacles"
        inc_battle_bg_tiles TOWN_INT, "town_int"
        inc_battle_bg_tiles GHOST_TRAIN, "ghost_train"
        inc_battle_bg_tiles UNDERWATER, "underwater"
        inc_battle_bg_tiles MAGITEK_FACTORY, "magitek_factory"
        inc_battle_bg_tiles ZOZO, "zozo"
        inc_battle_bg_tiles AIRSHIP_CENTER, "airship_center"
        inc_battle_bg_tiles DARILLS_TOMB, "darills_tomb"
        inc_battle_bg_tiles CASTLE_EXT, "castle_ext"
        inc_battle_bg_tiles KEFKAS_TOWER_INT, "kefkas_tower_int"
        inc_battle_bg_tiles FINAL_BATTLE_1, "final_battle_1"
        inc_battle_bg_tiles FINAL_BATTLE_2, "final_battle_2"
        inc_battle_bg_tiles FINAL_BATTLE_3, "final_battle_3"
        inc_battle_bg_tiles MAGITEK_TRAIN, "magitek_train"
        inc_battle_bg_tiles FINAL_BATTLE_4, "final_battle_4"
        inc_battle_bg_tiles CYANS_DREAM, "cyans_dream"
        inc_battle_bg_tiles AIRSHIP, "airship"

; ------------------------------------------------------------------------------

; e7/a9e7
BattleBGGfx:
        inc_battle_bg_gfx TOWN_EXT_1, "town_ext_1"
        inc_battle_bg_gfx TOWN_EXT_2, "town_ext_2"
        inc_battle_bg_gfx BATTLE_BG_GFX_2, "caves_1"
        inc_battle_bg_gfx MOUNTAINS_EXT_1, "mountains_ext_1"
        inc_battle_bg_gfx MOUNTAINS_INT_1, "mountains_int_1"
        inc_battle_bg_gfx RIVER_1, "river_1"
        inc_battle_bg_gfx IMP_CAMP_1, "imp_camp_1"
        inc_battle_bg_gfx TRAIN_EXT_1, "train_ext_1"
        inc_battle_bg_gfx TRAIN_INT_1, "train_int_1"
        inc_battle_bg_gfx CAVES_1, "caves_1"
        BattleBGGfx::_10 := array_item MapGfx, MAP_GFX::TRAIN_PARALLAX
        BattleBGGfx::_11 := array_item MapGfx, MAP_GFX::MOUNTAIN_EXT_1
        BattleBGGfx::_12 := array_item MapGfx, MAP_GFX::MOUNTAIN_INT_1
        BattleBGGfx::_13 := array_item MapGfx, MAP_GFX::RIVER
        BattleBGGfx::_14 := array_item MapGfx, MAP_GFX::IMP_CAMP_1
        BattleBGGfx::_15 := array_item MapGfx, MAP_GFX::TRAIN_EXT_1
        BattleBGGfx::_16 := array_item MapGfx, MAP_GFX::TRAIN_INT
        BattleBGGfx::_17 := array_item MapGfx, MAP_GFX::CAVES
        inc_battle_bg_gfx FIELD_1, "field_1"
        inc_battle_bg_gfx FIELD_2, "field_2"
        inc_battle_bg_gfx FIELD_3, "field_3"
        BattleBGGfx::_21 := array_item MapGfx, MAP_GFX::TRAIN_EXT_3
        inc_battle_bg_gfx COLOSSEUM, "colosseum"
        inc_battle_bg_gfx BATTLE_BG_GFX_23, "unused_23"
        inc_battle_bg_gfx DESERT_1, "desert_1"
        inc_battle_bg_gfx FOREST_1, "forest_1"
        BattleBGGfx::_26 := array_item MapGfx, MAP_GFX::FOREST_2
        inc_battle_bg_gfx FIELD_WOR, "field_wor"
        inc_battle_bg_gfx VELDT, "veldt"
        inc_battle_bg_gfx DESERT_2, "desert_2"
        inc_battle_bg_gfx IMP_CASTLE_1, "imp_castle_1"
        inc_battle_bg_gfx FLOATING_ISLAND_1, "floating_island_1"
        inc_battle_bg_gfx KEFKAS_TOWER_1, "kefkas_tower_1"
        inc_battle_bg_gfx OPERA_STAGE, "opera_stage"
        inc_battle_bg_gfx OPERA_CATWALK, "opera_catwalk"
        inc_battle_bg_gfx BURNING_BLDG_1, "burning_bldg_1"
        inc_battle_bg_gfx CASTLE_INT, "castle_int"
        inc_battle_bg_gfx MAGITEK_1, "magitek_1"
        inc_battle_bg_gfx CASTLE_EXT_1, "castle_ext_1"
        BattleBGGfx::_39 := array_item MapGfx, MAP_GFX::FACTORY_1
        BattleBGGfx::_40 := array_item MapGfx, MAP_GFX::IMP_CASTLE_INT
        BattleBGGfx::_41 := array_item MapGfx, MAP_GFX::FLOATING_ISLAND_1
        BattleBGGfx::_42 := array_item MapGfx, MAP_GFX::KEFKAS_TOWER_1
        BattleBGGfx::_43 := array_item MapGfx, MAP_GFX::OPERA_2
        BattleBGGfx::_44 := array_item MapGfx, MAP_GFX::BURNING_BUILDING
        inc_battle_bg_gfx TENTACLES, "tentacles"
        BattleBGGfx::_46 := array_item MapGfx, MAP_GFX::CASTLE_EXT_1
        inc_battle_bg_gfx TOWN_INT_1, "town_int_1"
        BattleBGGfx::_48 := array_item MapGfx, MAP_GFX::TOWN_INT_1
        BattleBGGfx::_49 := array_item MapGfx, MAP_GFX::TRAIN_EXT_2
        inc_battle_bg_gfx UNDERWATER, "underwater"
        BattleBGGfx::_51 := array_item MapGfx, MAP_GFX::SEALED_GATE_1
        inc_battle_bg_gfx SEALED_GATE_2, "sealed_gate_2"
        BattleBGGfx::_53 := array_item MapGfx, MAP_GFX::ZOZO_EXT_1
        inc_battle_bg_gfx ZOZO_2, "zozo_2"
        BattleBGGfx::_55 := array_item MapGfx, MAP_GFX::AIRSHIP_4
        BattleBGGfx::_56 := array_item MapGfx, MAP_GFX::AIRSHIP_5
        inc_battle_bg_gfx AIRSHIP, "airship"
        BattleBGGfx::_58 := array_item MapGfx, MAP_GFX::DARILLS_TOMB_1
        inc_battle_bg_gfx DARILLS_TOMB_2, "darills_tomb_2"
        inc_battle_bg_gfx WATERFALL, "waterfall"
        inc_battle_bg_gfx FINAL_BATTLE_1, "final_battle_1"
        inc_battle_bg_gfx FINAL_BATTLE_2, "final_battle_2"
        inc_battle_bg_gfx_lang FINAL_BATTLE_3, "final_battle_3"
        inc_battle_bg_gfx_lang FINAL_BATTLE_4, "final_battle_4"
        inc_battle_bg_gfx FINAL_BATTLE_5, "final_battle_5"
        inc_battle_bg_gfx_lang FINAL_BATTLE_6, "final_battle_6"
        inc_battle_bg_gfx FINAL_BATTLE_7, "final_battle_7"
        inc_battle_bg_gfx FINAL_BATTLE_8, "final_battle_8"
        inc_battle_bg_gfx FANATICS_TOWER, "fanatics_tower"
        inc_battle_bg_gfx MAGITEK_TRAIN_1, "magitek_train_1"
        BattleBGGfx::_71 := array_item MapGfx, MAP_GFX::FACTORY_4
        BattleBGGfx::_72 := array_item MapGfx, MAP_GFX::DARILLS_TOMB_2
        BattleBGGfx::_73 := array_item MapGfx, MAP_GFX::FLOATING_ISLAND_2
        inc_battle_bg_gfx_lang CYANS_DREAM_2, "cyans_dream_2"

; ------------------------------------------------------------------------------
