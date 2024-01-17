; ------------------------------------------------------------------------------

.include "field/map_tileset.inc"

; ------------------------------------------------------------------------------

.macro inc_map_tileset _id, _file
        .ident(.sprintf("MapTileset_%04x", _id)) := *
        .incbin .sprintf("map_tileset/%s.dat.lz", _file)
.endmac

; ------------------------------------------------------------------------------

.segment "map_tileset"

; de/0000
begin_fixed_block MapTileset, $01b400
        inc_map_tileset MAP_TILESET_FIGARO_CASTLE, "figaro_castle"
        inc_map_tileset MAP_TILESET_VILLAGE_EXT_1_BG1, "village_ext_1_bg1"
        inc_map_tileset MAP_TILESET_VILLAGE_EXT_1_BG2, "village_ext_1_bg2"
        inc_map_tileset MAP_TILESET_DOMA_CASTLE_BG1, "doma_castle_bg1"
        inc_map_tileset MAP_TILESET_DOMA_CASTLE_BG2, "doma_castle_bg2"
        inc_map_tileset MAP_TILESET_TOWN_EXT_BG1, "town_ext_bg1"
        inc_map_tileset MAP_TILESET_TOWN_EXT_BG2, "town_ext_bg2"
        inc_map_tileset MAP_TILESET_DOCKS_BG1, "docks_bg1"
        inc_map_tileset MAP_TILESET_DOCKS_BG2, "docks_bg2"
        inc_map_tileset MAP_TILESET_CAVES_BG1, "caves_bg1"
        inc_map_tileset MAP_TILESET_CASTLE_INT_BG1, "castle_int_bg1"
        inc_map_tileset MAP_TILESET_CASTLE_INT_BG2, "castle_int_bg2"
        inc_map_tileset MAP_TILESET_RIVER, "river"
        inc_map_tileset MAP_TILESET_IMP_CAMP_BG1, "imp_camp_bg1"
        inc_map_tileset MAP_TILESET_IMP_CAMP_BG2, "imp_camp_bg2"
        inc_map_tileset MAP_TILESET_MOUNTAINS_INT, "mountains_int"
        inc_map_tileset MAP_TILESET_TOWN_INT_BG1, "town_int_bg1"
        inc_map_tileset MAP_TILESET_TOWN_INT_BG2, "town_int_bg2"
        inc_map_tileset MAP_TILESET_MOUNTAINS_EXT_BG1, "mountains_ext_bg1"
        inc_map_tileset MAP_TILESET_NARSHE_EXT_BG1, "narshe_ext_bg1"
        inc_map_tileset MAP_TILESET_NARSHE_EXT_BG2, "narshe_ext_bg2"
        inc_map_tileset MAP_TILESET_DESTROYED_TOWN_BG1, "destroyed_town_bg1"
        inc_map_tileset MAP_TILESET_DESTROYED_TOWN_BG2, "destroyed_town_bg2"
        inc_map_tileset MAP_TILESET_SNOWFIELDS, "snowfields"
        inc_map_tileset MAP_TILESET_TRAIN_EXT_BG1, "train_ext_bg1"
        inc_map_tileset MAP_TILESET_TRAIN_INT_BG1, "train_int_bg1"
        inc_map_tileset MAP_TILESET_TRAIN_INT_BG2, "train_int_bg2"
        inc_map_tileset MAP_TILESET_ZOZO_BG1, "zozo_bg1"
        inc_map_tileset MAP_TILESET_ZOZO_BG2, "zozo_bg2"
        inc_map_tileset MAP_TILESET_VECTOR_BG1, "vector_bg1"
        inc_map_tileset MAP_TILESET_VECTOR_BG2, "vector_bg2"
        inc_map_tileset MAP_TILESET_CASTLE_BASEMENT_BG1, "castle_basement_bg1"
        inc_map_tileset MAP_TILESET_CASTLE_BASEMENT_BG2, "castle_basement_bg2"
        inc_map_tileset MAP_TILESET_CAVES_FURNITURE, "caves_furniture"
        inc_map_tileset MAP_TILESET_MAGITEK_LAB_1_BG1, "magitek_lab_1_bg1"
        inc_map_tileset MAP_TILESET_FLOATING_ISLAND_BG1, "floating_island_bg1"
        inc_map_tileset MAP_TILESET_FLOATING_ISLAND_BG2, "floating_island_bg2"
        inc_map_tileset MAP_TILESET_MOUNTAINS_PARALLAX, "mountains_parallax"
        inc_map_tileset MAP_TILESET_NARSHE_CAVES_BG2, "narshe_caves_bg2"
        inc_map_tileset MAP_TILESET_VILLAGE_EXT_2_BG1, "village_ext_2_bg1"
        inc_map_tileset MAP_TILESET_VILLAGE_EXT_2_BG2, "village_ext_2_bg2"
        inc_map_tileset MAP_TILESET_KEFKAS_TOWER_BG2, "kefkas_tower_bg2"
        inc_map_tileset MAP_TILESET_WATERFALL_SKY_PARALLAX, "waterfall_sky_parallax"
        inc_map_tileset MAP_TILESET_KEFKAS_TOWER_BG1, "kefkas_tower_bg1"
        inc_map_tileset MAP_TILESET_MOUNTAINS_EXT_BG2, "mountains_ext_bg2"
        inc_map_tileset MAP_TILESET_TRAIN_EXT_BG2, "train_ext_bg2"
        inc_map_tileset MAP_TILESET_CAVES_BG2, "caves_bg2"
        inc_map_tileset MAP_TILESET_MAGITEK_FACTORY_BG1, "magitek_factory_bg1"
        inc_map_tileset MAP_TILESET_MAGITEK_FACTORY_BG2, "magitek_factory_bg2"
        inc_map_tileset MAP_TILESET_NARSHE_CLIFFS_PARALLAX, "narshe_cliffs_parallax"
        inc_map_tileset MAP_TILESET_AIRSHIP_EXT_BG1, "airship_ext_bg1"
        inc_map_tileset MAP_TILESET_AIRSHIP_EXT_BG2, "airship_ext_bg2"
        inc_map_tileset MAP_TILESET_AIRSHIP_INT, "airship_int"
        inc_map_tileset MAP_TILESET_NARSHE_INTRO_BG1, "narshe_intro_bg1"
        inc_map_tileset MAP_TILESET_CYANS_DREAM, "cyans_dream"
        inc_map_tileset MAP_TILESET_FOREST_BG1, "forest_bg1"
        inc_map_tileset MAP_TILESET_FOREST_BG2, "forest_bg2"
        inc_map_tileset MAP_TILESET_IMP_CASTLE_EXT_BG1, "imp_castle_ext_bg1"
        inc_map_tileset MAP_TILESET_IMP_CASTLE_EXT_1_BG2, "imp_castle_ext_1_bg2"
        inc_map_tileset MAP_TILESET_IMP_CASTLE_EXT_2_BG2, "imp_castle_ext_2_bg2"
        inc_map_tileset MAP_TILESET_BEACH, "beach"
        inc_map_tileset MAP_TILESET_IMP_CASTLE_INT_BG1, "imp_castle_int_bg1"
        inc_map_tileset MAP_TILESET_IMP_CASTLE_INT_BG2, "imp_castle_int_bg2"
        inc_map_tileset MAP_TILESET_MAGITEK_LAB_2_BG1, "magitek_lab_2_bg1"
        inc_map_tileset MAP_TILESET_CAVES_LAVA_BG2, "caves_lava_bg2"
        inc_map_tileset MAP_TILESET_SEALED_GATE_BG1, "sealed_gate_bg1"
        inc_map_tileset MAP_TILESET_SEALED_GATE_BG2, "sealed_gate_bg2"
        inc_map_tileset MAP_TILESET_MAGITEK_LAB_BG2, "magitek_lab_bg2"
        inc_map_tileset MAP_TILESET_KEFKAS_TOWER_PARALLAX, "kefkas_tower_parallax"
        inc_map_tileset MAP_TILESET_MAP_TILESET_69, "map_tileset_69"
        inc_map_tileset MAP_TILESET_BURNING_BUILDING, "burning_building"
        inc_map_tileset MAP_TILESET_OPERA_HOUSE_BG1, "opera_house_bg1"
        inc_map_tileset MAP_TILESET_OPERA_HOUSE_BG2, "opera_house_bg2"
        inc_map_tileset MAP_TILESET_DARILLS_TOMB_BG1, "darills_tomb_bg1"
        inc_map_tileset MAP_TILESET_DARILLS_TOMB_BG2, "darills_tomb_bg2"

MapTilesetEnd := *

end_fixed_block MapTileset

; ------------------------------------------------------------------------------

.segment "map_tileset_ptrs"

; df/ba00
begin_fixed_block MapTilesetPtrs, $0100
        make_ptr_tbl_far MapTileset, MAP_TILESET_ARRAY_LENGTH
        .faraddr MapTilesetEnd - MapTileset
end_fixed_block MapTilesetPtrs

; ------------------------------------------------------------------------------
