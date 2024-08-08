; ------------------------------------------------------------------------------

.include "gfx/map_gfx.inc"

; ------------------------------------------------------------------------------

.macro inc_map_gfx id, name
        array_item MapGfx, {MAP_GFX::id} := *
        .incbin .sprintf("map_gfx/%s.4bpp", name)
.endmac

; ------------------------------------------------------------------------------

.segment "map_gfx"

; df/da00
MapGfxPtrs:
        fixed_block $0100
        ptr_tbl_far MapGfx
        end_fixed_block

; ------------------------------------------------------------------------------

; df/db00
MapGfx:
        fixed_block $061900
        inc_map_gfx CASTLE_EXT_1, "castle_ext_1"
        inc_map_gfx CASTLE_EXT_2, "castle_ext_2"
        inc_map_gfx CASTLE_EXT_3, "castle_ext_3"
        inc_map_gfx OPERA_1, "opera_1"
        inc_map_gfx TOWN_EXT_1, "town_ext_1"
        inc_map_gfx TOWN_EXT_2, "town_ext_2"
        inc_map_gfx TOWN_EXT_3, "town_ext_3"
        inc_map_gfx TOWN_EXT_4, .concat("town_ext_4_", LANG_SUFFIX)
        inc_map_gfx TOWN_EXT_5, "town_ext_5"
        inc_map_gfx CASTLE_EXT_4, "castle_ext_4"
        inc_map_gfx TOWN_EXT_6, .concat("town_ext_6_", LANG_SUFFIX)
        inc_map_gfx TOWN_EXT_7, "town_ext_7"
        inc_map_gfx DOCKS_1, "docks_1"
        inc_map_gfx DOCKS_2, "docks_2"
        inc_map_gfx CAVES, "caves"
        inc_map_gfx CASTLE_INT_1, "castle_int_1"
        inc_map_gfx CASTLE_INT_2, "castle_int_2"
        inc_map_gfx CASTLE_INT_3, "castle_int_3"
        inc_map_gfx CASTLE_INT_4, "castle_int_4"
        inc_map_gfx DOCKS_3, "docks_3"
        inc_map_gfx RIVER, "river"
        inc_map_gfx IMP_CAMP_1, "imp_camp_1"
        inc_map_gfx IMP_CAMP_2, "imp_camp_2"
        inc_map_gfx MOUNTAIN_INT_1, "mountain_int_1"
        inc_map_gfx MOUNTAIN_INT_2, "mountain_int_2"
        inc_map_gfx TOWN_INT_1, "town_int_1"
        inc_map_gfx TOWN_INT_2, "town_int_2"
        inc_map_gfx TOWN_INT_3, "town_int_3"
        inc_map_gfx MOUNTAIN_EXT_1, "mountain_ext_1"
        inc_map_gfx MOUNTAIN_EXT_2, "mountain_ext_2"
        inc_map_gfx NARSHE_EXT_1, "narshe_ext_1"
        inc_map_gfx NARSHE_EXT_2, "narshe_ext_2"
        inc_map_gfx NARSHE_EXT_3, "narshe_ext_3"
        inc_map_gfx TOWN_EXT_8, "town_ext_8"
        inc_map_gfx NARSHE_EXT_4, "narshe_ext_4"
        inc_map_gfx KEFKAS_TOWER_1, "kefkas_tower_1"
        inc_map_gfx KEFKAS_TOWER_2, "kefkas_tower_2"
        inc_map_gfx BURNING_BUILDING, "burning_building"
        inc_map_gfx TRAIN_EXT_1, "train_ext_1"
        inc_map_gfx TRAIN_EXT_2, "train_ext_2"
        inc_map_gfx TRAIN_EXT_3, "train_ext_3"
        inc_map_gfx FOREST_1, "forest_1"
        inc_map_gfx TRAIN_INT, "train_int"
        inc_map_gfx ZOZO_EXT_1, .concat("zozo_ext_1_", LANG_SUFFIX)
        inc_map_gfx ZOZO_EXT_2, "zozo_ext_2"
        inc_map_gfx VECTOR_EXT, .concat("vector_ext_", LANG_SUFFIX)
        inc_map_gfx DARILLS_TOMB_1, "darills_tomb_1"
        inc_map_gfx MOUNTAINS_PARALLAX_1, "mountains_parallax_1"
        inc_map_gfx FLOATING_ISLAND_1, "floating_island_1"
        inc_map_gfx FLOATING_ISLAND_2, "floating_island_2"
        inc_map_gfx MOUNTAINS_PARALLAX_2, "mountains_parallax_2"
        inc_map_gfx CASTLE_EXT_5, "castle_ext_5"
        inc_map_gfx TOWN_EXT_9, "town_ext_9"
        inc_map_gfx WATERFALL_PARALLAX_1, "waterfall_parallax_1"
        inc_map_gfx FACTORY_1, "factory_1"
        inc_map_gfx FACTORY_2, "factory_2"
        inc_map_gfx FACTORY_3, "factory_3"
        inc_map_gfx FACTORY_4, "factory_4"
        inc_map_gfx FACTORY_5, "factory_5"
        inc_map_gfx AIRSHIP_1, "airship_1"
        inc_map_gfx AIRSHIP_2, "airship_2"
        inc_map_gfx AIRSHIP_3, "airship_3"
        inc_map_gfx AIRSHIP_4, "airship_4"
        inc_map_gfx CYANS_DREAM, "cyans_dream"
        inc_map_gfx WATERFALL_PARALLAX_2, "waterfall_parallax_2"
        inc_map_gfx FOREST_2, "forest_2"
        inc_map_gfx KEFKAS_TOWER_3, "kefkas_tower_3"
        inc_map_gfx IMP_CASTLE_EXT_1, "imp_castle_ext_1"
        inc_map_gfx IMP_CASTLE_EXT_2, "imp_castle_ext_2"
        inc_map_gfx IMP_CASTLE_PARALLAX_1, "imp_castle_parallax_1"
        inc_map_gfx IMP_CASTLE_PARALLAX_2, "imp_castle_parallax_2"
        inc_map_gfx BEACH, "beach"
        inc_map_gfx IMP_CASTLE_INT, "imp_castle_int"
        inc_map_gfx OPERA_2, "opera_2"
        inc_map_gfx TRAIN_PARALLAX, "train_parallax"
        inc_map_gfx SEALED_GATE_1, "sealed_gate_1"
        inc_map_gfx SEALED_GATE_2, "sealed_gate_2"
        inc_map_gfx SEALED_GATE_3, "sealed_gate_3"
        inc_map_gfx FACTORY_6, "factory_6"
        inc_map_gfx AIRSHIP_5, "airship_5"
        inc_map_gfx BEACH_PARALLAX, "beach_parallax"
        inc_map_gfx DARILLS_TOMB_2, .concat("darills_tomb_2_", LANG_SUFFIX)
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "map_anim_gfx"

; e6/0000
MapAnimGfx:
        .incbin "map_anim.4bpp"

; ------------------------------------------------------------------------------
