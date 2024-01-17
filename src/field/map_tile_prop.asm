; ------------------------------------------------------------------------------

.include "field/map_tile_prop.inc"

; ------------------------------------------------------------------------------

.macro inc_map_tile_prop _id, _file
        .ident(.sprintf("MapTileProp_%04x", _id)) := *
        .incbin .sprintf("map_tile_prop/%s.dat.lz", _file)
.endmac

; ------------------------------------------------------------------------------

.segment "map_tile_prop"

; d9/a800
begin_fixed_block MapTileProp, $2510
        inc_map_tile_prop MAP_TILE_PROP_NONE, "none"
        inc_map_tile_prop MAP_TILE_PROP_FIGARO_CASTLE, "figaro_castle"
        inc_map_tile_prop MAP_TILE_PROP_DOMA_CASTLE, "doma_castle"
        inc_map_tile_prop MAP_TILE_PROP_VILLAGE_EXT_1, "village_ext_1"
        inc_map_tile_prop MAP_TILE_PROP_TOWN_EXT, "town_ext"
        inc_map_tile_prop MAP_TILE_PROP_CASTLE_INT, "castle_int"
        inc_map_tile_prop MAP_TILE_PROP_CAVES, "caves"
        inc_map_tile_prop MAP_TILE_PROP_TOWN_INT, "town_int"
        inc_map_tile_prop MAP_TILE_PROP_NARSHE_EXT, "narshe_ext"
        inc_map_tile_prop MAP_TILE_PROP_CAVES_FURNITURE, "caves_furniture"
        inc_map_tile_prop MAP_TILE_PROP_CASTLE_BASEMENT, "castle_basement"
        inc_map_tile_prop MAP_TILE_PROP_VILLAGE_EXT_2, "village_ext_2"
        inc_map_tile_prop MAP_TILE_PROP_MOUNTAINS_EXT, "mountains_ext"
        inc_map_tile_prop MAP_TILE_PROP_TRAIN_EXT, "train_ext"
        inc_map_tile_prop MAP_TILE_PROP_ZOZO, "zozo"
        inc_map_tile_prop MAP_TILE_PROP_FLOATING_ISLAND, "floating_island"
        inc_map_tile_prop MAP_TILE_PROP_MOUNTAINS_INT, "mountains_int"
        inc_map_tile_prop MAP_TILE_PROP_DOCKS, "docks"
        inc_map_tile_prop MAP_TILE_PROP_NARSHE_INTRO, "narshe_intro"
        inc_map_tile_prop MAP_TILE_PROP_TRAIN_INT, "train_int"
        inc_map_tile_prop MAP_TILE_PROP_IMP_CAMP, "imp_camp"
        inc_map_tile_prop MAP_TILE_PROP_IMP_CASTLE_EXT, "imp_castle_ext"
        inc_map_tile_prop MAP_TILE_PROP_AIRSHIP_EXT, "airship_ext"
        inc_map_tile_prop MAP_TILE_PROP_AIRSHIP_INT, "airship_int"
        inc_map_tile_prop MAP_TILE_PROP_IMP_CASTLE_INT, "imp_castle_int"
        inc_map_tile_prop MAP_TILE_PROP_SNOWFIELDS, "snowfields"
        inc_map_tile_prop MAP_TILE_PROP_FOREST, "forest"
        inc_map_tile_prop MAP_TILE_PROP_VECTOR, "vector"
        inc_map_tile_prop MAP_TILE_PROP_RIVER, "river"
        inc_map_tile_prop MAP_TILE_PROP_OPERA_HOUSE, "opera_house"
        inc_map_tile_prop MAP_TILE_PROP_DESTROYED_TOWN, "destroyed_town"
        inc_map_tile_prop MAP_TILE_PROP_MAGITEK_FACTORY, "magitek_factory"
        inc_map_tile_prop MAP_TILE_PROP_DARILLS_TOMB, "darills_tomb"
        inc_map_tile_prop MAP_TILE_PROP_OPERA_LOBBY, "opera_lobby"
        inc_map_tile_prop MAP_TILE_PROP_BURNING_BUILDING, "burning_building"
        inc_map_tile_prop MAP_TILE_PROP_SEALED_GATE, "sealed_gate"
        inc_map_tile_prop MAP_TILE_PROP_MAGITEK_LAB_1, "magitek_lab_1"
        inc_map_tile_prop MAP_TILE_PROP_MAGITEK_LAB_2, "magitek_lab_2"
        inc_map_tile_prop MAP_TILE_PROP_BEACH, "beach"
        inc_map_tile_prop MAP_TILE_PROP_CYANS_DREAM, "cyans_dream"
        inc_map_tile_prop MAP_TILE_PROP_KEFKAS_TOWER_1, "kefkas_tower_1"
        inc_map_tile_prop MAP_TILE_PROP_KEFKAS_TOWER_2, "kefkas_tower_2"

MapTilePropEnd := *

end_fixed_block MapTileProp

; ------------------------------------------------------------------------------

; d9/cd10
begin_fixed_block MapTilePropPtrs, $80
        make_ptr_tbl_rel MapTileProp, MAP_TILE_PROP_ARRAY_LENGTH
        .addr MapTilePropEnd - MapTileProp
end_fixed_block MapTilePropPtrs

; ------------------------------------------------------------------------------
