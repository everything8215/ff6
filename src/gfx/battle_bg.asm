; ------------------------------------------------------------------------------

.include "gfx/battle_bg.inc"

; ------------------------------------------------------------------------------

.macro inc_battle_bg_tiles _id, _name
        .ident(.sprintf("BattleBGTiles_%04x", _id)) := *
        .incbin .sprintf("battle_bg_tiles/%s.scr.lz", _name)
.endmac

.macro inc_battle_bg_gfx _id, _name
        .ident(.sprintf("BattleBGGfx_%04x", _id)) := *
        .incbin .sprintf("battle_bg_gfx/%s.4bpp.lz", _name)
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
; - a graphics block with BATTLE_BG_GFX_NONE ($ff) is not loaded
; - if bit 0.7 is set, graphics 1 is 128 tiles and graphics 2 is not loaded
; - tilemaps are 32x32 (2048 bytes) though only the first 19 rows are
;   visible unless the background scrolls vertically (clouds, waterfall)
; - palettes contain 48 colors (96 bytes)
; - if bit 5.7 is set, a wavy effect is applied to the background using HDMA

; e7/0000
BattleBGProp:

; ------------------------------------------------------------------------------

; 0: field_wob
        .byte BATTLE_BG_GFX_FIELD_1
        .byte BATTLE_BG_GFX_FIELD_2
        .byte BATTLE_BG_GFX_FIELD_3
        .byte BATTLE_BG_TILES_FIELD_WOB
        .byte BATTLE_BG_TILES_FIELD_WOB
        .byte BATTLE_BG_PAL_FIELD_WOB

; ------------------------------------------------------------------------------

; 1: forest_wor
        .byte BATTLE_BG_GFX_FOREST_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_FOREST_1
        .byte BATTLE_BG_TILES_FOREST
        .byte BATTLE_BG_TILES_FOREST
        .byte BATTLE_BG_PAL_FOREST_WOR

; ------------------------------------------------------------------------------

; 2: desert_wob
        .byte BATTLE_BG_GFX_DESERT_1
        .byte BATTLE_BG_GFX_DESERT_2
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_DESERT
        .byte BATTLE_BG_TILES_DESERT
        .byte BATTLE_BG_PAL_DESERT_WOB | $80

; ------------------------------------------------------------------------------

; 3: forest_wob
        .byte BATTLE_BG_GFX_FOREST_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_FOREST_1
        .byte BATTLE_BG_TILES_FOREST
        .byte BATTLE_BG_TILES_FOREST
        .byte BATTLE_BG_PAL_FOREST_WOB

; ------------------------------------------------------------------------------

; 4: zozo_int
        .byte BATTLE_BG_GFX_TOWN_INT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_TOWN_INT_1
        .byte BATTLE_BG_TILES_TOWN_INT
        .byte BATTLE_BG_TILES_TOWN_INT
        .byte BATTLE_BG_PAL_ZOZO_INT

; ------------------------------------------------------------------------------

; 5: field_wor
        .byte BATTLE_BG_GFX_FIELD_1
        .byte BATTLE_BG_GFX_FIELD_3
        .byte BATTLE_BG_GFX_FIELD_WOR
        .byte BATTLE_BG_TILES_FIELD_WOR
        .byte BATTLE_BG_TILES_FIELD_WOR
        .byte BATTLE_BG_PAL_FIELD_WOR

; ------------------------------------------------------------------------------

; 6: veldt
        .byte BATTLE_BG_GFX_FIELD_1
        .byte BATTLE_BG_GFX_FIELD_3
        .byte BATTLE_BG_GFX_VELDT
        .byte BATTLE_BG_TILES_VELDT
        .byte BATTLE_BG_TILES_VELDT
        .byte BATTLE_BG_PAL_VELDT

; ------------------------------------------------------------------------------

; 7: clouds
        .byte BATTLE_BG_GFX_CLOUDS_1
        .byte BATTLE_BG_GFX_CLOUDS_2
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_CLOUDS
        .byte BATTLE_BG_TILES_CLOUDS
        .byte BATTLE_BG_PAL_AIRSHIP_WOB

; ------------------------------------------------------------------------------

; 8: narshe_ext
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_TOWN_EXT_1
        .byte BATTLE_BG_GFX_TOWN_EXT_2
        .byte BATTLE_BG_TILES_NARSHE_EXT
        .byte BATTLE_BG_TILES_NARSHE_EXT
        .byte BATTLE_BG_PAL_NARSHE_EXT

; ------------------------------------------------------------------------------

; 9: narshe_caves_1
        .byte BATTLE_BG_GFX_CAVES_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_CAVES_1
        .byte BATTLE_BG_TILES_NARSHE_CAVES
        .byte BATTLE_BG_TILES_NARSHE_CAVES
        .byte BATTLE_BG_PAL_NARSHE_CAVES

; ------------------------------------------------------------------------------

; 10: caves
        .byte BATTLE_BG_GFX_CAVES_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_CAVES_1
        .byte BATTLE_BG_TILES_CAVES
        .byte BATTLE_BG_TILES_CAVES
        .byte BATTLE_BG_PAL_CAVES

; ------------------------------------------------------------------------------

; 11: mountains_ext
        .byte BATTLE_BG_GFX_MOUNTAINS_EXT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_MOUNTAINS_EXT_1
        .byte BATTLE_BG_TILES_MOUNTAINS_EXT
        .byte BATTLE_BG_TILES_MOUNTAINS_EXT
        .byte BATTLE_BG_PAL_MOUNTAINS_EXT

; ------------------------------------------------------------------------------

; 12: mountains_int
        .byte BATTLE_BG_GFX_MOUNTAINS_INT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_MOUNTAINS_INT_1
        .byte BATTLE_BG_TILES_MOUNTAINS_INT
        .byte BATTLE_BG_TILES_MOUNTAINS_INT
        .byte BATTLE_BG_PAL_MOUNTAINS_INT

; ------------------------------------------------------------------------------

; 13: river
        .byte BATTLE_BG_GFX_RIVER_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_RIVER_1
        .byte BATTLE_BG_TILES_RIVER
        .byte BATTLE_BG_TILES_RIVER
        .byte BATTLE_BG_PAL_RIVER

; ------------------------------------------------------------------------------

; 14: imp_camp
        .byte BATTLE_BG_GFX_IMP_CAMP_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_IMP_CAMP_1
        .byte BATTLE_BG_TILES_IMP_CAMP
        .byte BATTLE_BG_TILES_IMP_CAMP
        .byte BATTLE_BG_PAL_IMP_CAMP

; ------------------------------------------------------------------------------

; 15: train_ext
        .byte BATTLE_BG_GFX_TRAIN_EXT_3
        .byte BATTLE_BG_GFX_TRAIN_EXT_2
        .byte BATTLE_BG_GFX_TRAIN_EXT_1
        .byte BATTLE_BG_TILES_TRAIN_EXT
        .byte BATTLE_BG_TILES_TRAIN_EXT
        .byte BATTLE_BG_PAL_TRAIN_EXT

; ------------------------------------------------------------------------------

; 16: train_int
        .byte BATTLE_BG_GFX_TRAIN_INT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_TRAIN_INT_1
        .byte BATTLE_BG_TILES_TRAIN_INT
        .byte BATTLE_BG_TILES_TRAIN_INT
        .byte BATTLE_BG_PAL_TRAIN_INT

; ------------------------------------------------------------------------------

; 17: narshe_caves_2
        .byte BATTLE_BG_GFX_CAVES_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_CAVES_1
        .byte BATTLE_BG_TILES_CAVES
        .byte BATTLE_BG_TILES_CAVES
        .byte BATTLE_BG_PAL_NARSHE_CAVES

; ------------------------------------------------------------------------------

; 18: snowfields
        .byte BATTLE_BG_GFX_FIELD_1
        .byte BATTLE_BG_GFX_FIELD_2
        .byte BATTLE_BG_GFX_FIELD_3
        .byte BATTLE_BG_TILES_SNOWFIELDS
        .byte BATTLE_BG_TILES_SNOWFIELDS
        .byte BATTLE_BG_PAL_SNOWFIELDS

; ------------------------------------------------------------------------------

; 19: town_ext
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_TOWN_EXT_1
        .byte BATTLE_BG_GFX_TOWN_EXT_2
        .byte BATTLE_BG_TILES_TOWN_EXT
        .byte BATTLE_BG_TILES_TOWN_EXT
        .byte BATTLE_BG_PAL_TOWN_EXT

; ------------------------------------------------------------------------------

; 20: imp_castle
        .byte BATTLE_BG_GFX_IMP_CASTLE_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_IMP_CASTLE_1
        .byte BATTLE_BG_TILES_IMP_CASTLE
        .byte BATTLE_BG_TILES_IMP_CASTLE
        .byte BATTLE_BG_PAL_IMP_CASTLE

; ------------------------------------------------------------------------------

; 21: floating_island
        .byte BATTLE_BG_GFX_FLOATING_ISLAND_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_FLOATING_ISLAND_1
        .byte BATTLE_BG_TILES_FLOATING_ISLAND
        .byte BATTLE_BG_TILES_FLOATING_ISLAND
        .byte BATTLE_BG_PAL_FLOATING_ISLAND

; ------------------------------------------------------------------------------

; 22: kefkas_tower_ext
        .byte BATTLE_BG_GFX_KEFKAS_TOWER_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_KEFKAS_TOWER_1
        .byte BATTLE_BG_TILES_KEFKAS_TOWER_EXT
        .byte BATTLE_BG_TILES_KEFKAS_TOWER_EXT
        .byte BATTLE_BG_PAL_KEFKAS_TOWER_EXT

; ------------------------------------------------------------------------------

; 23: opera_stage
        .byte BATTLE_BG_GFX_OPERA_CURTAIN | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_OPERA_STAGE
        .byte BATTLE_BG_TILES_OPERA_STAGE
        .byte BATTLE_BG_TILES_OPERA_STAGE
        .byte BATTLE_BG_PAL_OPERA_STAGE

; ------------------------------------------------------------------------------

; 24: opera_catwalk
        .byte BATTLE_BG_GFX_OPERA_CURTAIN | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_OPERA_CATWALK
        .byte BATTLE_BG_TILES_OPERA_CATWALK
        .byte BATTLE_BG_TILES_OPERA_CATWALK
        .byte BATTLE_BG_PAL_OPERA_CATWALK

; ------------------------------------------------------------------------------

; 25: burning_building
        .byte BATTLE_BG_GFX_BURNING_BLDG_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_BURNING_BLDG_1
        .byte BATTLE_BG_TILES_BURNING_BUILDING
        .byte BATTLE_BG_TILES_BURNING_BUILDING
        .byte BATTLE_BG_PAL_BURNING_BUILDING | $80

; ------------------------------------------------------------------------------

; 26: castle_int
        .byte BATTLE_BG_GFX_CASTLE_INT
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_CASTLE_INT
        .byte BATTLE_BG_TILES_CASTLE_INT
        .byte BATTLE_BG_PAL_CASTLE_INT

; ------------------------------------------------------------------------------

; 27: magitek_lab
        .byte BATTLE_BG_GFX_MAGITEK_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_MAGITEK_1
        .byte BATTLE_BG_TILES_MAGITEK_LAB
        .byte BATTLE_BG_TILES_MAGITEK_LAB
        .byte BATTLE_BG_PAL_MAGITEK

; ------------------------------------------------------------------------------

; 28: colosseum
        .byte BATTLE_BG_GFX_FIELD_3
        .byte BATTLE_BG_GFX_COLOSSEUM
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_COLOSSEUM
        .byte BATTLE_BG_TILES_COLOSSEUM
        .byte BATTLE_BG_PAL_COLOSSEUM

; ------------------------------------------------------------------------------

; 29: magitek_factory
        .byte BATTLE_BG_GFX_MAGITEK_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_MAGITEK_1
        .byte BATTLE_BG_TILES_MAGITEK_FACTORY
        .byte BATTLE_BG_TILES_MAGITEK_FACTORY
        .byte BATTLE_BG_PAL_MAGITEK

; ------------------------------------------------------------------------------

; 30: village_ext
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_TOWN_EXT_1
        .byte BATTLE_BG_GFX_TOWN_EXT_2
        .byte BATTLE_BG_TILES_VILLAGE_EXT
        .byte BATTLE_BG_TILES_VILLAGE_EXT
        .byte BATTLE_BG_PAL_VILLAGE_EXT

; ------------------------------------------------------------------------------

; 31: waterfall
        .byte BATTLE_BG_GFX_WATERFALL
        .byte 0
        .byte 0
        .byte BATTLE_BG_TILES_WATERFALL
        .byte BATTLE_BG_TILES_WATERFALL
        .byte BATTLE_BG_PAL_WATERFALL

; ------------------------------------------------------------------------------

; 32: owzers_house
        .byte BATTLE_BG_GFX_TOWN_INT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_TOWN_INT_1
        .byte BATTLE_BG_TILES_OWZERS_HOUSE
        .byte BATTLE_BG_TILES_OWZERS_HOUSE
        .byte BATTLE_BG_PAL_OWZERS_HOUSE

; ------------------------------------------------------------------------------

; 33: train_tracks
        .byte BATTLE_BG_GFX_FOREST_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_FOREST_1
        .byte BATTLE_BG_TILES_TRAIN_TRACKS
        .byte BATTLE_BG_TILES_TRAIN_TRACKS
        .byte BATTLE_BG_PAL_TRAIN_TRACKS

; ------------------------------------------------------------------------------

; 34: sealed_gate
        .byte BATTLE_BG_GFX_SEALED_GATE_1 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_SEALED_GATE_2
        .byte BATTLE_BG_TILES_SEALED_GATE
        .byte BATTLE_BG_TILES_SEALED_GATE
        .byte BATTLE_BG_PAL_SEALED_GATE

; ------------------------------------------------------------------------------

; 35: underwater
        .byte BATTLE_BG_GFX_MOUNTAINS_EXT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_UNDERWATER
        .byte BATTLE_BG_TILES_UNDERWATER
        .byte BATTLE_BG_TILES_UNDERWATER
        .byte BATTLE_BG_PAL_UNDERWATER | $80

; ------------------------------------------------------------------------------

; 36: zozo
        .byte BATTLE_BG_GFX_ZOZO_1 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_ZOZO_2
        .byte BATTLE_BG_TILES_ZOZO
        .byte BATTLE_BG_TILES_ZOZO
        .byte BATTLE_BG_PAL_ZOZO_EXT

; ------------------------------------------------------------------------------

; 37: airship_center
        .byte BATTLE_BG_GFX_CLOUDS_1
        .byte BATTLE_BG_GFX_CLOUDS_2
        .byte BATTLE_BG_GFX_AIRSHIP
        .byte BATTLE_BG_TILES_AIRSHIP_CENTER
        .byte BATTLE_BG_TILES_AIRSHIP_CENTER
        .byte BATTLE_BG_PAL_AIRSHIP_WOB

; ------------------------------------------------------------------------------

; 38: darills_tomb
        .byte BATTLE_BG_GFX_DARILLS_TOMB_1
        .byte BATTLE_BG_GFX_DARILLS_TOMB_3
        .byte BATTLE_BG_GFX_DARILLS_TOMB_2
        .byte BATTLE_BG_TILES_DARILLS_TOMB
        .byte BATTLE_BG_TILES_DARILLS_TOMB
        .byte BATTLE_BG_PAL_DARILLS_TOMB

; ------------------------------------------------------------------------------

; 39: doma_castle
        .byte BATTLE_BG_GFX_CASTLE_EXT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_CASTLE_EXT_1
        .byte BATTLE_BG_TILES_CASTLE_EXT
        .byte BATTLE_BG_TILES_CASTLE_EXT
        .byte BATTLE_BG_PAL_CASTLE_EXT

; ------------------------------------------------------------------------------

; 40: kefkas_tower_int
        .byte BATTLE_BG_GFX_KEFKAS_TOWER_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_KEFKAS_TOWER_1
        .byte BATTLE_BG_TILES_KEFKAS_TOWER_INT
        .byte BATTLE_BG_TILES_KEFKAS_TOWER_INT
        .byte BATTLE_BG_PAL_KEFKAS_TOWER_INT

; ------------------------------------------------------------------------------

; 41: airship_wor
        .byte BATTLE_BG_GFX_CLOUDS_1
        .byte BATTLE_BG_GFX_CLOUDS_2
        .byte BATTLE_BG_GFX_AIRSHIP
        .byte BATTLE_BG_TILES_AIRSHIP
        .byte BATTLE_BG_TILES_AIRSHIP
        .byte BATTLE_BG_PAL_AIRSHIP_WOR

; ------------------------------------------------------------------------------

; 42: fire_caves
        .byte BATTLE_BG_GFX_CAVES_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_CAVES_1
        .byte BATTLE_BG_TILES_CAVES
        .byte BATTLE_BG_TILES_CAVES
        .byte BATTLE_BG_PAL_FIRE_CAVES

; ------------------------------------------------------------------------------

; 43: town_int
        .byte BATTLE_BG_GFX_TOWN_INT_2 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_TOWN_INT_1
        .byte BATTLE_BG_TILES_TOWN_INT
        .byte BATTLE_BG_TILES_TOWN_INT
        .byte BATTLE_BG_PAL_TOWN_INT

; ------------------------------------------------------------------------------

; 44: magitek_train
        .byte BATTLE_BG_GFX_MAGITEK_TRAIN_2
        .byte BATTLE_BG_GFX_MAGITEK_TRAIN_1
        .byte 0
        .byte BATTLE_BG_TILES_MAGITEK_TRAIN
        .byte BATTLE_BG_TILES_MAGITEK_TRAIN
        .byte BATTLE_BG_PAL_MAGITEK_TRAIN

; ------------------------------------------------------------------------------

; 45: fanatics_tower
        .byte BATTLE_BG_GFX_ZOZO_1 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_FANATICS_TOWER
        .byte BATTLE_BG_TILES_FANATICS_TOWER
        .byte BATTLE_BG_TILES_FANATICS_TOWER
        .byte BATTLE_BG_PAL_FANATICS_TOWER

; ------------------------------------------------------------------------------

; 46: cyans_dream
        .byte BATTLE_BG_GFX_CYANS_DREAM_1
        .byte BATTLE_BG_GFX_CYANS_DREAM_2
        .byte 0
        .byte BATTLE_BG_TILES_CYANS_DREAM
        .byte BATTLE_BG_TILES_CYANS_DREAM
        .byte BATTLE_BG_PAL_CYANS_DREAM | $80

; ------------------------------------------------------------------------------

; 47: desert_wor
        .byte BATTLE_BG_GFX_DESERT_1
        .byte BATTLE_BG_GFX_DESERT_2
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_DESERT
        .byte BATTLE_BG_TILES_DESERT
        .byte BATTLE_BG_PAL_DESERT_WOR | $80

; ------------------------------------------------------------------------------

; 48: airship_wob
        .byte BATTLE_BG_GFX_CLOUDS_1
        .byte BATTLE_BG_GFX_CLOUDS_2
        .byte BATTLE_BG_GFX_AIRSHIP
        .byte BATTLE_BG_TILES_AIRSHIP
        .byte BATTLE_BG_TILES_AIRSHIP
        .byte BATTLE_BG_PAL_AIRSHIP_WOB

; ------------------------------------------------------------------------------

; 49: unused
        .byte BATTLE_BG_GFX_TOWN_EXT_1
        .byte BATTLE_BG_GFX_TOWN_EXT_2
        .byte BATTLE_BG_GFX_02
        .byte BATTLE_BG_TILES_FIELD_WOB
        .byte BATTLE_BG_TILES_FIELD_WOB
        .byte BATTLE_BG_PAL_FIELD_WOB

; ------------------------------------------------------------------------------

; 50: ghost_train
        .byte BATTLE_BG_GFX_GHOST_TRAIN_1 | $80
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_GFX_GHOST_TRAIN_2
        .byte BATTLE_BG_TILES_GHOST_TRAIN
        .byte BATTLE_BG_TILES_GHOST_TRAIN
        .byte BATTLE_BG_PAL_FIELD_WOB

; ------------------------------------------------------------------------------

; 51: final_battle_1
        .byte BATTLE_BG_GFX_FINAL_BATTLE_1
        .byte BATTLE_BG_GFX_FINAL_BATTLE_2
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_FINAL_BATTLE_1
        .byte BATTLE_BG_TILES_FINAL_BATTLE_1
        .byte BATTLE_BG_PAL_FINAL_BATTLE_1

; ------------------------------------------------------------------------------

; 52: final_battle_2
        .byte BATTLE_BG_GFX_FINAL_BATTLE_3
        .byte BATTLE_BG_GFX_FINAL_BATTLE_4
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_FINAL_BATTLE_2
        .byte BATTLE_BG_TILES_FINAL_BATTLE_2
        .byte BATTLE_BG_PAL_FINAL_BATTLE_2

; ------------------------------------------------------------------------------

; 53: final_battle_3
        .byte BATTLE_BG_GFX_FINAL_BATTLE_5
        .byte BATTLE_BG_GFX_FINAL_BATTLE_6
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_FINAL_BATTLE_3
        .byte BATTLE_BG_TILES_FINAL_BATTLE_3
        .byte BATTLE_BG_PAL_FINAL_BATTLE_3

; ------------------------------------------------------------------------------

; 54: final_battle_4
        .byte BATTLE_BG_GFX_FINAL_BATTLE_7
        .byte BATTLE_BG_GFX_FINAL_BATTLE_8
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_FINAL_BATTLE_4
        .byte BATTLE_BG_TILES_FINAL_BATTLE_4
        .byte BATTLE_BG_PAL_FINAL_BATTLE_4

; ------------------------------------------------------------------------------

; 55: tentacles
        .byte BATTLE_BG_GFX_TENTACLES
        .byte BATTLE_BG_GFX_CASTLE_INT
        .byte BATTLE_BG_GFX_NONE
        .byte BATTLE_BG_TILES_TENTACLES
        .byte BATTLE_BG_TILES_TENTACLES
        .byte BATTLE_BG_PAL_TENTACLES | $80

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
        .res 3*96, 0

; ------------------------------------------------------------------------------

; e7/1650
BattleBGGfxPtrs:
        make_ptr_tbl_far BattleBGGfx, BATTLE_BG_GFX_ARRAY_LENGTH, 0
        .res 93*3, 0

; ------------------------------------------------------------------------------

; e7/1848
BattleBGTilesPtrs:
        make_ptr_tbl_rel BattleBGTiles, BATTLE_BG_TILES_ARRAY_LENGTH, (^*)<<16

.repeat $70-BATTLE_BG_TILES_ARRAY_LENGTH
        .addr BattleBGTiles
.endrep

; ------------------------------------------------------------------------------

; e7/1928
BattleBGTiles:
        inc_battle_bg_tiles BATTLE_BG_TILES_FIELD_WOB, "field_wob"
        inc_battle_bg_tiles BATTLE_BG_TILES_NARSHE_EXT, "narshe_ext"
        inc_battle_bg_tiles BATTLE_BG_TILES_NARSHE_CAVES, "narshe_caves"
        inc_battle_bg_tiles BATTLE_BG_TILES_CAVES, "caves"
        inc_battle_bg_tiles BATTLE_BG_TILES_MOUNTAINS_EXT, "mountains_ext"
        inc_battle_bg_tiles BATTLE_BG_TILES_MOUNTAINS_INT, "mountains_int"
        inc_battle_bg_tiles BATTLE_BG_TILES_RIVER, "river"
        inc_battle_bg_tiles BATTLE_BG_TILES_IMP_CAMP, "imp_camp"
        inc_battle_bg_tiles BATTLE_BG_TILES_TRAIN_EXT, "train_ext"
        inc_battle_bg_tiles BATTLE_BG_TILES_TRAIN_INT, "train_int"
        inc_battle_bg_tiles BATTLE_BG_TILES_FANATICS_TOWER, "fanatics_tower"
        inc_battle_bg_tiles BATTLE_BG_TILES_DESERT, "desert"
        inc_battle_bg_tiles BATTLE_BG_TILES_FOREST, "forest"
        inc_battle_bg_tiles BATTLE_BG_TILES_FIELD_WOR, "field_wor"
        inc_battle_bg_tiles BATTLE_BG_TILES_VELDT, "veldt"
        inc_battle_bg_tiles BATTLE_BG_TILES_SNOWFIELDS, "snowfields"
        inc_battle_bg_tiles BATTLE_BG_TILES_TOWN_EXT, "town_ext"
        inc_battle_bg_tiles BATTLE_BG_TILES_IMP_CASTLE, "imp_castle"
        inc_battle_bg_tiles BATTLE_BG_TILES_FLOATING_ISLAND, "floating_island"
        inc_battle_bg_tiles BATTLE_BG_TILES_KEFKAS_TOWER_EXT, "kefkas_tower_ext"
        inc_battle_bg_tiles BATTLE_BG_TILES_OPERA_STAGE, "opera_stage"
        inc_battle_bg_tiles BATTLE_BG_TILES_OPERA_CATWALK, "opera_catwalk"
        inc_battle_bg_tiles BATTLE_BG_TILES_BURNING_BUILDING, "burning_building"
        inc_battle_bg_tiles BATTLE_BG_TILES_CASTLE_INT, "castle_int"
        inc_battle_bg_tiles BATTLE_BG_TILES_MAGITEK_LAB, "magitek_lab"
        inc_battle_bg_tiles BATTLE_BG_TILES_COLOSSEUM, "colosseum"
        inc_battle_bg_tiles BATTLE_BG_TILES_SEALED_GATE, "sealed_gate"
        inc_battle_bg_tiles BATTLE_BG_TILES_VILLAGE_EXT, "village_ext"
        inc_battle_bg_tiles BATTLE_BG_TILES_WATERFALL, "waterfall"
        inc_battle_bg_tiles BATTLE_BG_TILES_OWZERS_HOUSE, "owzers_house"
        inc_battle_bg_tiles BATTLE_BG_TILES_TRAIN_TRACKS, "train_tracks"
        inc_battle_bg_tiles BATTLE_BG_TILES_CLOUDS, "clouds"
        inc_battle_bg_tiles BATTLE_BG_TILES_TENTACLES, "tentacles"
        inc_battle_bg_tiles BATTLE_BG_TILES_TOWN_INT, "town_int"
        inc_battle_bg_tiles BATTLE_BG_TILES_GHOST_TRAIN, "ghost_train"
        inc_battle_bg_tiles BATTLE_BG_TILES_UNDERWATER, "underwater"
        inc_battle_bg_tiles BATTLE_BG_TILES_MAGITEK_FACTORY, "magitek_factory"
        inc_battle_bg_tiles BATTLE_BG_TILES_ZOZO, "zozo"
        inc_battle_bg_tiles BATTLE_BG_TILES_AIRSHIP_CENTER, "airship_center"
        inc_battle_bg_tiles BATTLE_BG_TILES_DARILLS_TOMB, "darills_tomb"
        inc_battle_bg_tiles BATTLE_BG_TILES_CASTLE_EXT, "castle_ext"
        inc_battle_bg_tiles BATTLE_BG_TILES_KEFKAS_TOWER_INT, "kefkas_tower_int"
        inc_battle_bg_tiles BATTLE_BG_TILES_FINAL_BATTLE_1, "final_battle_1"
        inc_battle_bg_tiles BATTLE_BG_TILES_FINAL_BATTLE_2, "final_battle_2"
        inc_battle_bg_tiles BATTLE_BG_TILES_FINAL_BATTLE_3, "final_battle_3"
        inc_battle_bg_tiles BATTLE_BG_TILES_MAGITEK_TRAIN, "magitek_train"
        inc_battle_bg_tiles BATTLE_BG_TILES_FINAL_BATTLE_4, "final_battle_4"
        inc_battle_bg_tiles BATTLE_BG_TILES_CYANS_DREAM, "cyans_dream"
        inc_battle_bg_tiles BATTLE_BG_TILES_AIRSHIP, "airship"

; ------------------------------------------------------------------------------

; e7/a9e7
BattleBGGfx:
        inc_battle_bg_gfx BATTLE_BG_GFX_TOWN_EXT_1, "town_ext_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_TOWN_EXT_2, "town_ext_2"
        inc_battle_bg_gfx BATTLE_BG_GFX_02, "caves_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_MOUNTAINS_EXT_1, "mountains_ext_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_MOUNTAINS_INT_1, "mountains_int_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_RIVER_1, "river_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_IMP_CAMP_1, "imp_camp_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_TRAIN_EXT_1, "train_ext_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_TRAIN_INT_1, "train_int_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_CAVES_1, "caves_1"
        BattleBGGfx_000a := MapGfx_004a
        BattleBGGfx_000b := MapGfx_001c
        BattleBGGfx_000c := MapGfx_0017
        BattleBGGfx_000d := MapGfx_0014
        BattleBGGfx_000e := MapGfx_0015
        BattleBGGfx_000f := MapGfx_0026
        BattleBGGfx_0010 := MapGfx_002a
        BattleBGGfx_0011 := MapGfx_000e
        inc_battle_bg_gfx BATTLE_BG_GFX_FIELD_1, "field_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_FIELD_2, "field_2"
        inc_battle_bg_gfx BATTLE_BG_GFX_FIELD_3, "field_3"
        BattleBGGfx_0015 := MapGfx_0028
        inc_battle_bg_gfx BATTLE_BG_GFX_COLOSSEUM, "colosseum"
        inc_battle_bg_gfx BATTLE_BG_GFX_17, "unused_17"
        inc_battle_bg_gfx BATTLE_BG_GFX_DESERT_1, "desert_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_FOREST_1, "forest_1"
        BattleBGGfx_001a := MapGfx_0041
        inc_battle_bg_gfx BATTLE_BG_GFX_FIELD_WOR, "field_wor"
        inc_battle_bg_gfx BATTLE_BG_GFX_VELDT, "veldt"
        inc_battle_bg_gfx BATTLE_BG_GFX_DESERT_2, "desert_2"
        inc_battle_bg_gfx BATTLE_BG_GFX_IMP_CASTLE_1, "imp_castle_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_FLOATING_ISLAND_1, "floating_island_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_KEFKAS_TOWER_1, "kefkas_tower_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_OPERA_STAGE, "opera_stage"
        inc_battle_bg_gfx BATTLE_BG_GFX_OPERA_CATWALK, "opera_catwalk"
        inc_battle_bg_gfx BATTLE_BG_GFX_BURNING_BLDG_1, "burning_bldg_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_CASTLE_INT, "castle_int"
        inc_battle_bg_gfx BATTLE_BG_GFX_MAGITEK_1, "magitek_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_CASTLE_EXT_1, "castle_ext_1"
        BattleBGGfx_0027 := MapGfx_0036
        BattleBGGfx_0028 := MapGfx_0048
        BattleBGGfx_0029 := MapGfx_0030
        BattleBGGfx_002a := MapGfx_0023
        BattleBGGfx_002b := MapGfx_0049
        BattleBGGfx_002c := MapGfx_0025
        inc_battle_bg_gfx BATTLE_BG_GFX_TENTACLES, "tentacles"
        BattleBGGfx_002e := MapGfx_0000
        inc_battle_bg_gfx BATTLE_BG_GFX_TOWN_INT_1, "town_int_1"
        BattleBGGfx_0030 := MapGfx_0019
        BattleBGGfx_0031 := MapGfx_0027
        inc_battle_bg_gfx BATTLE_BG_GFX_UNDERWATER, "underwater"
        BattleBGGfx_0033 := MapGfx_004b
        inc_battle_bg_gfx BATTLE_BG_GFX_SEALED_GATE_2, "sealed_gate_2"
        BattleBGGfx_0035 := MapGfx_002b
        inc_battle_bg_gfx BATTLE_BG_GFX_ZOZO_2, "zozo_2"
        BattleBGGfx_0037 := MapGfx_003e
        BattleBGGfx_0038 := MapGfx_004f
        inc_battle_bg_gfx BATTLE_BG_GFX_AIRSHIP, "airship"
        BattleBGGfx_003a := MapGfx_002e
        inc_battle_bg_gfx BATTLE_BG_GFX_DARILLS_TOMB_2, "darills_tomb_2"
        inc_battle_bg_gfx BATTLE_BG_GFX_WATERFALL, "waterfall"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_1, "final_battle_1"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_2, "final_battle_2"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_3, "final_battle_3"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_4, "final_battle_4"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_5, "final_battle_5"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_6, "final_battle_6"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_7, "final_battle_7"
        inc_battle_bg_gfx BATTLE_BG_GFX_FINAL_BATTLE_8, "final_battle_8"
        inc_battle_bg_gfx BATTLE_BG_GFX_FANATICS_TOWER, "fanatics_tower"
        inc_battle_bg_gfx BATTLE_BG_GFX_MAGITEK_TRAIN_1, "magitek_train_1"
        BattleBGGfx_0047 := MapGfx_0039
        BattleBGGfx_0048 := MapGfx_0051
        BattleBGGfx_0049 := MapGfx_0031
        inc_battle_bg_gfx BATTLE_BG_GFX_CYANS_DREAM_2, "cyans_dream_2"

; ------------------------------------------------------------------------------
