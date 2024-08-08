; ------------------------------------------------------------------------------

.include "field/map_tileset.inc"

; ------------------------------------------------------------------------------

.macro inc_map_tileset id, file
        array_item MapTileset, {MAP_TILESET::id} := *
        .incbin .sprintf("map_tileset/%s.dat.lz", file)
.endmac

; ------------------------------------------------------------------------------

.segment "map_tileset"

; de/0000
MapTileset:

.if LANG_EN
        fixed_block $01b400
.else
        fixed_block $01ba00
.endif
        inc_map_tileset FIGARO_CASTLE, "figaro_castle"
        inc_map_tileset VILLAGE_EXT_1_BG1, "village_ext_1_bg1"
        inc_map_tileset VILLAGE_EXT_1_BG2, "village_ext_1_bg2"
        inc_map_tileset DOMA_CASTLE_BG1, "doma_castle_bg1"
        inc_map_tileset DOMA_CASTLE_BG2, "doma_castle_bg2"
        inc_map_tileset TOWN_EXT_BG1, .concat("town_ext_bg1_", LANG_SUFFIX)
        inc_map_tileset TOWN_EXT_BG2, .concat("town_ext_bg2_", LANG_SUFFIX)
        inc_map_tileset DOCKS_BG1, "docks_bg1"
        inc_map_tileset DOCKS_BG2, "docks_bg2"
        inc_map_tileset CAVES_BG1, "caves_bg1"
        inc_map_tileset CASTLE_INT_BG1, "castle_int_bg1"
        inc_map_tileset CASTLE_INT_BG2, "castle_int_bg2"
        inc_map_tileset RIVER, "river"
        inc_map_tileset IMP_CAMP_BG1, "imp_camp_bg1"
        inc_map_tileset IMP_CAMP_BG2, "imp_camp_bg2"
        inc_map_tileset MOUNTAINS_INT, "mountains_int"
        inc_map_tileset TOWN_INT_BG1, "town_int_bg1"
        inc_map_tileset TOWN_INT_BG2, "town_int_bg2"
        inc_map_tileset MOUNTAINS_EXT_BG1, "mountains_ext_bg1"
        inc_map_tileset NARSHE_EXT_BG1, .concat("narshe_ext_bg1_", LANG_SUFFIX)
        inc_map_tileset NARSHE_EXT_BG2, .concat("narshe_ext_bg2_", LANG_SUFFIX)
        inc_map_tileset DESTROYED_TOWN_BG1, .concat("destroyed_town_bg1_", LANG_SUFFIX)
        inc_map_tileset DESTROYED_TOWN_BG2, .concat("destroyed_town_bg2_", LANG_SUFFIX)
        inc_map_tileset SNOWFIELDS, "snowfields"
        inc_map_tileset TRAIN_EXT_BG1, "train_ext_bg1"
        inc_map_tileset TRAIN_INT_BG1, "train_int_bg1"
        inc_map_tileset TRAIN_INT_BG2, "train_int_bg2"
        inc_map_tileset ZOZO_BG1, "zozo_bg1"
        inc_map_tileset ZOZO_BG2, "zozo_bg2"
        inc_map_tileset VECTOR_BG1, "vector_bg1"
        inc_map_tileset VECTOR_BG2, "vector_bg2"
        inc_map_tileset CASTLE_BASEMENT_BG1, "castle_basement_bg1"
        inc_map_tileset CASTLE_BASEMENT_BG2, "castle_basement_bg2"
        inc_map_tileset CAVES_FURNITURE, "caves_furniture"
        inc_map_tileset MAGITEK_LAB_1_BG1, "magitek_lab_1_bg1"
        inc_map_tileset FLOATING_ISLAND_BG1, "floating_island_bg1"
        inc_map_tileset FLOATING_ISLAND_BG2, "floating_island_bg2"
        inc_map_tileset MOUNTAINS_PARALLAX, "mountains_parallax"
        inc_map_tileset NARSHE_CAVES_BG2, "narshe_caves_bg2"
        inc_map_tileset VILLAGE_EXT_2_BG1, "village_ext_2_bg1"
        inc_map_tileset VILLAGE_EXT_2_BG2, "village_ext_2_bg2"
        inc_map_tileset KEFKAS_TOWER_BG2, "kefkas_tower_bg2"
        inc_map_tileset WATERFALL_SKY_PARALLAX, "waterfall_sky_parallax"
        inc_map_tileset KEFKAS_TOWER_BG1, "kefkas_tower_bg1"
        inc_map_tileset MOUNTAINS_EXT_BG2, "mountains_ext_bg2"
        inc_map_tileset TRAIN_EXT_BG2, "train_ext_bg2"
        inc_map_tileset CAVES_BG2, "caves_bg2"
        inc_map_tileset MAGITEK_FACTORY_BG1, "magitek_factory_bg1"
        inc_map_tileset MAGITEK_FACTORY_BG2, "magitek_factory_bg2"
        inc_map_tileset NARSHE_CLIFFS_PARALLAX, "narshe_cliffs_parallax"
        inc_map_tileset AIRSHIP_EXT_BG1, "airship_ext_bg1"
        inc_map_tileset AIRSHIP_EXT_BG2, "airship_ext_bg2"
        inc_map_tileset AIRSHIP_INT, "airship_int"
        inc_map_tileset NARSHE_INTRO_BG1, .concat("narshe_intro_bg1_", LANG_SUFFIX)
        inc_map_tileset CYANS_DREAM, "cyans_dream"
        inc_map_tileset FOREST_BG1, "forest_bg1"
        inc_map_tileset FOREST_BG2, "forest_bg2"
        inc_map_tileset IMP_CASTLE_EXT_BG1, "imp_castle_ext_bg1"
        inc_map_tileset IMP_CASTLE_EXT_1_BG2, "imp_castle_ext_1_bg2"
        inc_map_tileset IMP_CASTLE_EXT_2_BG2, "imp_castle_ext_2_bg2"
        inc_map_tileset BEACH, "beach"
        inc_map_tileset IMP_CASTLE_INT_BG1, "imp_castle_int_bg1"
        inc_map_tileset IMP_CASTLE_INT_BG2, "imp_castle_int_bg2"
        inc_map_tileset MAGITEK_LAB_2_BG1, "magitek_lab_2_bg1"
        inc_map_tileset CAVES_LAVA_BG2, "caves_lava_bg2"
        inc_map_tileset SEALED_GATE_BG1, "sealed_gate_bg1"
        inc_map_tileset SEALED_GATE_BG2, "sealed_gate_bg2"
        inc_map_tileset MAGITEK_LAB_BG2, "magitek_lab_bg2"
        inc_map_tileset KEFKAS_TOWER_PARALLAX, "kefkas_tower_parallax"
        inc_map_tileset MAP_TILESET_69, "map_tileset_69"
        inc_map_tileset BURNING_BUILDING, "burning_building"
        inc_map_tileset OPERA_HOUSE_BG1, "opera_house_bg1"
        inc_map_tileset OPERA_HOUSE_BG2, "opera_house_bg2"
        inc_map_tileset DARILLS_TOMB_BG1, "darills_tomb_bg1"
        inc_map_tileset DARILLS_TOMB_BG2, .concat("darills_tomb_bg2_", LANG_SUFFIX)

MapTileset::End:
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "map_tileset_ptrs"

; df/ba00
MapTilesetPtrs:
        fixed_block $0100
        ptr_tbl_far MapTileset
        end_ptr_far MapTileset
        end_fixed_block

; ------------------------------------------------------------------------------
