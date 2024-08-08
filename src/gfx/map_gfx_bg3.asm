; ------------------------------------------------------------------------------

.include "gfx/map_gfx_bg3.inc"
.include "gfx/map_anim_gfx_bg3.inc"

; ------------------------------------------------------------------------------

.macro inc_map_gfx_bg3 id, name
        array_item MapGfxBG3, {MAP_GFX_BG3::id} := *
        .incbin .sprintf("map_gfx_bg3/%s.2bpp.lz", name)
.endmac

.macro inc_map_anim_gfx_bg3 id, name
        array_item MapAnimGfxBG3, {MAP_ANIM_GFX_BG3::id} := *
        .incbin .sprintf("map_anim_gfx_bg3/%s.2bpp.lz", name)
.endmac

; ------------------------------------------------------------------------------

.segment "map_gfx_bg3"

; e6/8780
MapGfxBG3:
        fixed_block $45e0
        inc_map_gfx_bg3 MOUNTAINS_INT, "mountains_int"
        inc_map_gfx_bg3 RIVER, "river"
        inc_map_gfx_bg3 UNUSED_TRAIN, "unused_train"
        inc_map_gfx_bg3 NARSHE_STEAM, "narshe_steam"
        inc_map_gfx_bg3 CAVES_TORCH, "caves_torch"
        inc_map_gfx_bg3 CAVES_ICE_WATER, "caves_ice_water"
        inc_map_gfx_bg3 FOREST, "forest"
        inc_map_gfx_bg3 BEACH, "beach"
        inc_map_gfx_bg3 FIRE_WATER, "fire_water"
        inc_map_gfx_bg3 BURNING_BUILDING, "burning_building"
        inc_map_gfx_bg3 RAIN, "rain"
        inc_map_gfx_bg3 CLOUDS, "clouds"
        inc_map_gfx_bg3 DARILLS_TOMB, "darills_tomb"
        inc_map_gfx_bg3 UNUSED_0D, "unused_0d"
        inc_map_gfx_bg3 MAGITEK_TUBES, "magitek_tubes"
        inc_map_gfx_bg3 WATERFALL, "waterfall"
        inc_map_gfx_bg3 TOWN_WATER, "town_water"
        inc_map_gfx_bg3 MAGITEK_FACTORY, "magitek_factory"

MapGfxBG3::End:
        end_fixed_block

; e6/cd60
MapGfxBG3Ptrs:
        fixed_block $40
        ptr_tbl_far MapGfxBG3
        end_ptr_far MapGfxBG3
        end_fixed_block

; ------------------------------------------------------------------------------

; e6/cda0
MapAnimGfxBG3Ptrs:
        fixed_block $20
        ptr_tbl_far MapAnimGfxBG3
        end_ptr_far MapAnimGfxBG3
        end_fixed_block

; ------------------------------------------------------------------------------

; e6/cdc0
MapAnimGfxBG3:
        fixed_block $2440
        inc_map_anim_gfx_bg3 RIVER, "river"
        inc_map_anim_gfx_bg3 FIRE, "fire"
        inc_map_anim_gfx_bg3 RAIN, "rain"
        inc_map_anim_gfx_bg3 CAVES, "caves"
        inc_map_anim_gfx_bg3 BEACH, "beach"
        inc_map_anim_gfx_bg3 NARSHE, "narshe"

MapAnimGfxBG3::End:
        end_fixed_block

; ------------------------------------------------------------------------------
