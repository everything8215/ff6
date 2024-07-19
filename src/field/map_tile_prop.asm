; ------------------------------------------------------------------------------

.include "field/map_tile_prop.inc"

; ------------------------------------------------------------------------------

.macro inc_map_tile_prop id, file
        .ident(.sprintf("MapTileProp_%04x", MAP_TILE_PROP::id)) := *
        .incbin .sprintf("map_tile_prop/%s.dat.lz", file)
.endmac

; ------------------------------------------------------------------------------

.segment "map_tile_prop"

; d9/a800
begin_block MapTileProp, $2510
        inc_map_tile_prop NONE, "none"
        inc_map_tile_prop FIGARO_CASTLE, "figaro_castle"
        inc_map_tile_prop DOMA_CASTLE, "doma_castle"
        inc_map_tile_prop VILLAGE_EXT_1, "village_ext_1"
        inc_map_tile_prop TOWN_EXT, "town_ext"
        inc_map_tile_prop CASTLE_INT, "castle_int"
        inc_map_tile_prop CAVES, "caves"
        inc_map_tile_prop TOWN_INT, "town_int"
        inc_map_tile_prop NARSHE_EXT, "narshe_ext"
        inc_map_tile_prop CAVES_FURNITURE, "caves_furniture"
        inc_map_tile_prop CASTLE_BASEMENT, "castle_basement"
        inc_map_tile_prop VILLAGE_EXT_2, "village_ext_2"
        inc_map_tile_prop MOUNTAINS_EXT, "mountains_ext"
        inc_map_tile_prop TRAIN_EXT, "train_ext"
        inc_map_tile_prop ZOZO, "zozo"
        inc_map_tile_prop FLOATING_ISLAND, "floating_island"
        inc_map_tile_prop MOUNTAINS_INT, "mountains_int"
        inc_map_tile_prop DOCKS, "docks"
        inc_map_tile_prop NARSHE_INTRO, "narshe_intro"
        inc_map_tile_prop TRAIN_INT, "train_int"
        inc_map_tile_prop IMP_CAMP, "imp_camp"
        inc_map_tile_prop IMP_CASTLE_EXT, "imp_castle_ext"
        inc_map_tile_prop AIRSHIP_EXT, "airship_ext"
        inc_map_tile_prop AIRSHIP_INT, "airship_int"
        inc_map_tile_prop IMP_CASTLE_INT, "imp_castle_int"
        inc_map_tile_prop SNOWFIELDS, "snowfields"
        inc_map_tile_prop FOREST, "forest"
        inc_map_tile_prop VECTOR, "vector"
        inc_map_tile_prop RIVER, "river"
        inc_map_tile_prop OPERA_HOUSE, "opera_house"
        inc_map_tile_prop DESTROYED_TOWN, "destroyed_town"
        inc_map_tile_prop MAGITEK_FACTORY, "magitek_factory"
        inc_map_tile_prop DARILLS_TOMB, "darills_tomb"
        inc_map_tile_prop OPERA_LOBBY, "opera_lobby"
        inc_map_tile_prop BURNING_BUILDING, "burning_building"
        inc_map_tile_prop SEALED_GATE, "sealed_gate"
        inc_map_tile_prop MAGITEK_LAB_1, "magitek_lab_1"
        inc_map_tile_prop MAGITEK_LAB_2, "magitek_lab_2"
        inc_map_tile_prop BEACH, "beach"
        inc_map_tile_prop CYANS_DREAM, "cyans_dream"
        inc_map_tile_prop KEFKAS_TOWER_1, "kefkas_tower_1"
        inc_map_tile_prop KEFKAS_TOWER_2, "kefkas_tower_2"

MapTilePropEnd := *

end_block MapTileProp

; ------------------------------------------------------------------------------

; d9/cd10
begin_block MapTilePropPtrs, $80
        make_ptr_tbl_rel MapTileProp, MAP_TILE_PROP::ARRAY_LENGTH
        .addr MapTilePropEnd - MapTileProp
end_block MapTilePropPtrs

; ------------------------------------------------------------------------------
