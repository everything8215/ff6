; ------------------------------------------------------------------------------

.include "gfx/map_gfx_bg3.inc"
.include "gfx/map_anim_gfx_bg3.inc"

; ------------------------------------------------------------------------------

.macro inc_map_gfx_bg3 _id, _name
        .ident(.sprintf("MapGfxBG3_%04x", _id)) := *
        .incbin .sprintf("map_gfx_bg3/%s.2bpp.lz", _name)
.endmac

.macro inc_map_anim_gfx_bg3 _id, _name
        .ident(.sprintf("MapAnimGfxBG3_%04x", _id)) := *
        .incbin .sprintf("map_anim_gfx_bg3/%s.2bpp.lz", _name)
.endmac

; ------------------------------------------------------------------------------

.segment "map_gfx_bg3"

; e6/8780
begin_fixed_block MapGfxBG3, $45e0
        inc_map_gfx_bg3 MAP_GFX_BG3_MOUNTAINS_INT, "mountains_int"
        inc_map_gfx_bg3 MAP_GFX_BG3_RIVER, "river"
        inc_map_gfx_bg3 MAP_GFX_BG3_UNUSED_TRAIN, "unused_train"
        inc_map_gfx_bg3 MAP_GFX_BG3_NARSHE_STEAM, "narshe_steam"
        inc_map_gfx_bg3 MAP_GFX_BG3_CAVES_TORCH, "caves_torch"
        inc_map_gfx_bg3 MAP_GFX_BG3_CAVES_ICE_WATER, "caves_ice_water"
        inc_map_gfx_bg3 MAP_GFX_BG3_FOREST, "forest"
        inc_map_gfx_bg3 MAP_GFX_BG3_BEACH, "beach"
        inc_map_gfx_bg3 MAP_GFX_BG3_FIRE_WATER, "fire_water"
        inc_map_gfx_bg3 MAP_GFX_BG3_BURNING_BUILDING, "burning_building"
        inc_map_gfx_bg3 MAP_GFX_BG3_RAIN, "rain"
        inc_map_gfx_bg3 MAP_GFX_BG3_CLOUDS, "clouds"
        inc_map_gfx_bg3 MAP_GFX_BG3_DARILLS_TOMB, "darills_tomb"
        inc_map_gfx_bg3 MAP_GFX_BG3_UNUSED_0D, "unused_0d"
        inc_map_gfx_bg3 MAP_GFX_BG3_MAGITEK_TUBES, "magitek_tubes"
        inc_map_gfx_bg3 MAP_GFX_BG3_WATERFALL, "waterfall"
        inc_map_gfx_bg3 MAP_GFX_BG3_TOWN_WATER, "town_water"
        inc_map_gfx_bg3 MAP_GFX_BG3_MAGITEK_FACTORY, "magitek_factory"
        MapGfxBG3End := *

end_fixed_block MapGfxBG3

; e6/cd60
begin_fixed_block MapGfxBG3Ptrs, $40
        make_ptr_tbl_far MapGfxBG3, MAP_GFX_BG3_ARRAY_LENGTH
        .faraddr MapGfxBG3End-MapGfxBG3
end_fixed_block MapGfxBG3Ptrs

; ------------------------------------------------------------------------------

; e6/cda0
begin_fixed_block MapAnimGfxBG3Ptrs, $20
        make_ptr_tbl_far MapAnimGfxBG3, MAP_ANIM_GFX_BG3_ARRAY_LENGTH
        .faraddr MapAnimGfxBG3End-MapAnimGfxBG3
end_fixed_block MapAnimGfxBG3Ptrs

; ------------------------------------------------------------------------------

; e6/cdc0
begin_fixed_block MapAnimGfxBG3, $2440
        inc_map_anim_gfx_bg3 MAP_ANIM_GFX_BG3_RIVER, "river"
        inc_map_anim_gfx_bg3 MAP_ANIM_GFX_BG3_FIRE, "fire"
        inc_map_anim_gfx_bg3 MAP_ANIM_GFX_BG3_RAIN, "rain"
        inc_map_anim_gfx_bg3 MAP_ANIM_GFX_BG3_CAVES, "caves"
        inc_map_anim_gfx_bg3 MAP_ANIM_GFX_BG3_BEACH, "beach"
        inc_map_anim_gfx_bg3 MAP_ANIM_GFX_BG3_NARSHE, "narshe"
        MapAnimGfxBG3End := *
end_fixed_block MapAnimGfxBG3

; ------------------------------------------------------------------------------
