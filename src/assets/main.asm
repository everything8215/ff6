
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: assets/main.asm                                                      |
; |                                                                            |
; | description: main asset file                                               |
; |                                                                            |
; | created: 1/8/2023                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "macros.inc"
.include "const.inc"

; ------------------------------------------------------------------------------

.include "assets/ai_script.inc"
.include "assets/ai_script_ptr.inc"
.include "assets/airship_gfx1.inc"
.include "assets/airship_gfx2.inc"
inc_lang "assets/attack_anim_frames_%s.inc"
.include "assets/attack_anim_prop.inc"
.include "assets/attack_anim_script.inc"
.include "assets/attack_anim_script_ptrs.inc"
.include "assets/attack_gfx_2bpp.inc"
inc_lang "assets/attack_gfx_3bpp_%s.inc"
.include "assets/attack_gfx_mode7.inc"
inc_lang "assets/attack_gfx_prop_%s.inc"
inc_lang "assets/attack_msg_%s.inc"
inc_lang "assets/attack_name_%s.inc"
.include "assets/attack_pal.inc"
.include "assets/attack_tiles_2bpp.inc"
inc_lang "assets/attack_tiles_3bpp_%s.inc"
.include "assets/attack_tiles_mode7.inc"
.include "assets/battle_bg_dance.inc"
inc_lang "assets/battle_bg_gfx_%s.inc"
.include "assets/battle_bg_pal.inc"
.include "assets/battle_bg_prop.inc"
.include "assets/battle_bg_tiles.inc"
.include "assets/battle_char_pal.inc"
inc_lang "assets/battle_cmd_name_%s.inc"
.include "assets/battle_cmd_prop.inc"
inc_lang "assets/battle_dlg_%s.inc"
.include "assets/battle_event_script.inc"
.include "assets/battle_event_script_ptrs.inc"
.include "assets/battle_font_pal.inc"
.include "assets/battle_magic_points.inc"
.include "assets/battle_monsters.inc"
.include "assets/battle_prop.inc"
.include "assets/blitz_code.inc"
inc_lang "assets/blitz_desc_%s.inc"
.include "assets/sample_brr.inc"
inc_lang "assets/bushido_desc_%s.inc"
inc_lang "assets/bushido_name_%s.inc"
.include "assets/char_ai.inc"
inc_lang "assets/char_name_%s.inc"
.include "assets/char_prop.inc"
.include "assets/colosseum_prop.inc"
.include "assets/cond_battle.inc"
.include "assets/credits_gfx1.inc"
.include "assets/dance_bg.inc"
inc_lang "assets/dance_name_%s.inc"
.include "assets/dance_prop.inc"
.include "assets/debug_font_gfx.inc"
inc_lang "assets/dlg1_%s.inc"
inc_lang "assets/dlg2_%s.inc"
.include "assets/dte_table.inc"
.include "assets/ending_airship_scene_pal.inc"
.include "assets/ending_font_gfx.inc"
.include "assets/ending_gfx1.inc"
.include "assets/ending_gfx2.inc"
.include "assets/ending_gfx3.inc"
.include "assets/ending_gfx4.inc"
.include "assets/ending_gfx5.inc"
.include "assets/event_battle_group.inc"
inc_lang "assets/event_script_%s.inc"
inc_lang "assets/event_trigger_%s.inc"
.include "assets/floating_cont_gfx.inc"
inc_lang "assets/large_font_gfx_%s.inc"
inc_lang "assets/small_font_gfx_%s.inc"
.include "assets/font_pal.inc"
inc_lang "assets/font_width_%s.inc"
inc_lang "assets/genju_attack_desc_%s.inc"
inc_lang "assets/genju_attack_name_%s.inc"
inc_lang "assets/genju_bonus_desc_%s.inc"
inc_lang "assets/genju_bonus_name_%s.inc"
inc_lang "assets/genju_name_%s.inc"
.include "assets/genju_order.inc"
.include "assets/genju_prop.inc"
.include "assets/imp_item.inc"
.include "assets/init_lore.inc"
.include "assets/init_npc_switch.inc"
.include "assets/init_rage.inc"
inc_lang "assets/item_desc_%s.inc"
.include "assets/item_jump_throw_anim.inc"
inc_lang "assets/item_name_%s.inc"
inc_lang "assets/item_prop_%s.inc"
inc_lang "assets/item_type_name_%s.inc"
.include "assets/level_up_exp.inc"
.include "assets/level_up_hp.inc"
inc_lang "assets/level_up_mp_%s.inc"
.include "assets/long_entrance.inc"
inc_lang "assets/lore_desc_%s.inc"
inc_lang "assets/magic_desc_%s.inc"
inc_lang "assets/magic_name_%s.inc"
.include "assets/magic_prop.inc"
.include "assets/magitek_train_gfx.inc"
.include "assets/magitek_train_pal.inc"
.include "assets/magitek_train_tiles.inc"
.include "assets/map_anim_gfx.inc"
.include "assets/map_anim_gfx_bg3.inc"
.include "assets/map_bg3_anim_prop.inc"
.include "assets/map_bg_anim_prop.inc"
.include "assets/map_color_math.inc"
.include "assets/map_gfx_bg3.inc"
inc_lang "assets/map_gfx_%s.inc"
.include "assets/map_init_event.inc"
.include "assets/map_pal.inc"
.include "assets/map_pal_anim_colors.inc"
.include "assets/map_pal_anim_prop.inc"
.include "assets/map_parallax.inc"
.include "assets/map_prop.inc"
.include "assets/map_sprite_gfx.inc"
.include "assets/map_sprite_pal.inc"
.include "assets/map_tile_prop.inc"
inc_lang "assets/map_tileset_%s.inc"
inc_lang "assets/map_title_%s.inc"
.include "assets/menu_pal.inc"
.include "assets/menu_sprite_gfx.inc"
.include "assets/metamorph_prop.inc"
.include "assets/minimap_gfx1.inc"
.include "assets/minimap_gfx2.inc"
.include "assets/monster_align.inc"
.include "assets/monster_attack_anim_prop.inc"
.include "assets/monster_control.inc"
inc_lang "assets/monster_dlg_%s.inc"
inc_lang "assets/monster_gfx_%s.inc"
inc_lang "assets/monster_gfx_prop_%s.inc"
.include "assets/monster_items.inc"
inc_lang "assets/monster_name_%s.inc"
.include "assets/monster_overlap.inc"
.include "assets/monster_pal.inc"
.include "assets/monster_prop.inc"
.include "assets/monster_rage.inc"
.include "assets/monster_sketch.inc"
.include "assets/monster_special_anim.inc"
inc_lang "assets/monster_special_name_%s.inc"
inc_lang "assets/monster_stencil_large_%s.inc"
inc_lang "assets/monster_stencil_small_%s.inc"
.include "assets/natural_magic.inc"
inc_lang "assets/npc_prop_%s.inc"
.include "assets/overlay_gfx.inc"
.include "assets/overlay_prop.inc"
.include "assets/overlay_tilemap.inc"
.include "assets/portrait_gfx.inc"
.include "assets/portrait_pal.inc"
.include "assets/rand_battle_group.inc"
inc_lang "assets/rare_item_desc_%s.inc"
inc_lang "assets/rare_item_name_%s.inc"
.include "assets/rng_tbl.inc"
.include "assets/ruin_cutscene_gfx.inc"
.include "assets/sample_adsr.inc"
.include "assets/sample_freq_mult.inc"
.include "assets/sample_loop_start.inc"
.include "assets/shop_prop.inc"
.include "assets/short_entrance.inc"
.include "assets/slot_gfx.inc"
.include "assets/world_pal3.inc"
.include "assets/song_samples.inc"
.include "assets/song_script.inc"
.include "assets/spc_data.inc"
.include "assets/status_gfx.inc"
.include "assets/sub_battle_group.inc"
.include "assets/sub_battle_rate.inc"
.include "assets/sub_tilemap.inc"
.include "assets/the_end_gfx1.inc"
.include "assets/the_end_gfx2.inc"
.include "assets/the_end_pal.inc"
inc_lang "assets/title_opening_gfx_%s.inc"
.include "assets/treasure_prop.inc"
.include "assets/vector_approach_gfx.inc"
.include "assets/vector_approach_pal.inc"
.include "assets/vector_approach_tiles.inc"
.include "assets/vehicle_gfx.inc"
.include "assets/weapon_anim_prop.inc"
.include "assets/window_gfx.inc"
.include "assets/window_pal.inc"
.include "assets/world_backdrop_gfx.inc"
.include "assets/world_backdrop_tiles.inc"
.include "assets/world_battle_group.inc"
.include "assets/world_battle_rate.inc"
.include "assets/world_bg_pal1.inc"
.include "assets/world_bg_pal2.inc"
.include "assets/world_choco_gfx1.inc"
.include "assets/world_choco_gfx2.inc"
.include "assets/world_esper_terra_pal.inc"
.include "assets/world_gfx1.inc"
.include "assets/world_gfx2.inc"
.include "assets/world_gfx3.inc"
.include "assets/world_mod_data.inc"
.include "assets/world_mod_tiles.inc"
inc_lang "assets/world_sine_%s.inc"
.include "assets/world_sprite_gfx1.inc"
.include "assets/world_sprite_gfx2.inc"
.include "assets/world_sprite_pal1.inc"
.include "assets/world_sprite_pal2.inc"
.include "assets/world_tilemap1.inc"
.include "assets/world_tilemap2.inc"
.include "assets/world_tilemap3.inc"

; ------------------------------------------------------------------------------

.segment "field_data"

.if LANG_EN
        .include "assets/dte_table.asm"                         ; c0/dfa0
.else
        DTETbl := *
.endif
        .include "assets/init_npc_switch.asm"                   ; c0/e0a0
        .include "assets/debug_font_gfx.asm"                    ; c0/e120
        .include "assets/overlay_gfx.asm"                       ; c0/e2a0
        .res $0c00+OverlayGfx-*
        .include "assets/overlay_tilemap.asm"                   ; c0/eea0
OverlayPropPtrs:                                                ; c0/f4a0
        make_ptr_tbl_rel OverlayProp, OverlayProp_ARRAY_LENGTH
        .res $60+OverlayPropPtrs-*
        .include "assets/overlay_prop.asm"                      ; c0/f500
        .res $0800+OverlayProp-*
        .include "assets/rng_tbl.asm"                           ; c0/fd00
        .include "assets/map_color_math.asm"                    ; c0/fe00
        .res $40+MapColorMath-*
        .include "assets/map_parallax.asm"                      ; c0/fe40

; ------------------------------------------------------------------------------

.segment "event_triggers"

EventTriggerPtrs:                                               ; c4/0000
        make_ptr_tbl_rel EventTrigger, EventTrigger_ARRAY_LENGTH, EventTriggerPtrs
        .addr EventTriggerEnd - EventTriggerPtrs
        inc_lang "assets/event_trigger_%s.asm"                  ; c4/0342
        EventTriggerEnd := *
        .res $1a10+EventTriggerPtrs-*
NPCPropPtrs:                                                    ; c4/1a10
        make_ptr_tbl_rel NPCProp, NPCProp_ARRAY_LENGTH, NPCPropPtrs
        .addr NPCPropEnd - NPCPropPtrs
        inc_lang "assets/npc_prop_%s.asm"                       ; c4/1d52
        NPCPropEnd := *
        .res $50b0+NPCPropPtrs-*
        .include "assets/magic_prop.asm"                        ; c4/6ac0
        inc_lang "assets/char_name_%s.asm"                      ; c4/78c0
        .include "assets/blitz_code.asm"                        ; c4/7a40
        .include "assets/init_rage.asm"                         ; c4/7aa0

; ------------------------------------------------------------------------------

.segment "shop_prop"

        .include "assets/shop_prop.asm"                         ; c4/7ac0
        .include "assets/metamorph_prop.asm"                    ; c4/7f40

; ------------------------------------------------------------------------------

.segment "font_gfx"

        inc_lang "assets/small_font_gfx_%s.asm"                 ; c4/7fc0
        inc_lang "assets/font_width_%s.asm"                     ; c4/8fc0
        inc_lang "assets/large_font_gfx_%s.asm"                 ; c4/90c0

; ------------------------------------------------------------------------------

.segment "ending_gfx"

        .include "assets/ending_font_gfx.asm"                   ; c4/ba00
        .res $0608+EndingFontGfx-*
        .include "assets/ending_gfx1.asm"                       ; c4/c008
        .res $346f+EndingGfx1-*
        .include "assets/ending_gfx2.asm"                       ; c4/f477
        .res $0284+EndingGfx2-*
        .include "assets/ending_gfx3.asm"                       ; c4/f6fb

; ------------------------------------------------------------------------------

.segment "sound_data"

.export NumSongs

        .include "assets/spc_data.asm"                          ; c5/070e

SfxPtrs:                                                        ; c5/205e
        .addr SfxScript_0000_1 - SfxStart + $3000
        .addr SfxScript_0000_2 - SfxStart + $3000
        .addr SfxScript_0001_1 - SfxStart + $3000
        .addr SfxScript_0001_2 - SfxStart + $3000
        .addr SfxScript_0002_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_0003_1 - SfxStart + $3000
        .addr SfxScript_0003_2 - SfxStart + $3000
        .addr SfxScript_0004_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_0005_1 - SfxStart + $3000
        .addr SfxScript_0005_2 - SfxStart + $3000
        .addr SfxScript_0006_1 - SfxStart + $3000
        .addr SfxScript_0006_2 - SfxStart + $3000
        .addr SfxScript_0007_1 - SfxStart + $3000
        .addr SfxScript_0007_2 - SfxStart + $3000
        .addr SfxScript_0008_1 - SfxStart + $3000
        .addr SfxScript_0008_2 - SfxStart + $3000
        .addr SfxScript_0009_1 - SfxStart + $3000
        .addr SfxScript_0009_2 - SfxStart + $3000
        .addr SfxScript_000a_1 - SfxStart + $3000
        .addr SfxScript_000a_2 - SfxStart + $3000
        .addr SfxScript_000b_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_000c_1 - SfxStart + $3000
        .addr SfxScript_000c_2 - SfxStart + $3000
        .addr SfxScript_000d_1 - SfxStart + $3000
        .addr SfxScript_000d_2 - SfxStart + $3000
        .addr SfxScript_000e_1 - SfxStart + $3000
        .addr SfxScript_000e_2 - SfxStart + $3000
        .addr SfxScript_000f_1 - SfxStart + $3000
        .addr SfxScript_000f_2 - SfxStart + $3000
        .addr SfxScript_0010_1 - SfxStart + $3000
        .addr SfxScript_0010_2 - SfxStart + $3000
        .addr SfxScript_0011_1 - SfxStart + $3000
        .addr SfxScript_0011_2 - SfxStart + $3000
        .addr SfxScript_0012_1 - SfxStart + $3000
        .addr SfxScript_0012_2 - SfxStart + $3000
        .addr SfxScript_0013_1 - SfxStart + $3000
        .addr SfxScript_0013_2 - SfxStart + $3000
        .addr SfxScript_0014_1 - SfxStart + $3000
        .addr SfxScript_0014_2 - SfxStart + $3000
        .addr SfxScript_0015_1 - SfxStart + $3000
        .addr SfxScript_0015_2 - SfxStart + $3000
        .addr SfxScript_0016_1 - SfxStart + $3000
        .addr SfxScript_0016_2 - SfxStart + $3000
        .addr SfxScript_0017_1 - SfxStart + $3000
        .addr SfxScript_0017_2 - SfxStart + $3000
        .addr SfxScript_0018_1 - SfxStart + $3000
        .addr SfxScript_0018_2 - SfxStart + $3000
        .addr SfxScript_0019_1 - SfxStart + $3000
        .addr SfxScript_0019_2 - SfxStart + $3000
        .addr SfxScript_001a_1 - SfxStart + $3000
        .addr SfxScript_001a_2 - SfxStart + $3000
        .addr SfxScript_001b_1 - SfxStart + $3000
        .addr SfxScript_001b_2 - SfxStart + $3000
        .addr SfxScript_001c_1 - SfxStart + $3000
        .addr SfxScript_001c_2 - SfxStart + $3000
        .addr SfxScript_001d_1 - SfxStart + $3000
        .addr SfxScript_001d_2 - SfxStart + $3000
        .addr SfxScript_001e_1 - SfxStart + $3000
        .addr SfxScript_001e_2 - SfxStart + $3000
        .addr SfxScript_001f_1 - SfxStart + $3000
        .addr SfxScript_001f_2 - SfxStart + $3000
        .addr SfxScript_0020_1 - SfxStart + $3000
        .addr SfxScript_0020_2 - SfxStart + $3000
        .addr SfxScript_0021_1 - SfxStart + $3000
        .addr SfxScript_0021_2 - SfxStart + $3000
        .addr SfxScript_0022_1 - SfxStart + $3000
        .addr SfxScript_0022_2 - SfxStart + $3000
        .addr SfxScript_0023_1 - SfxStart + $3000
        .addr SfxScript_0023_2 - SfxStart + $3000
        .addr SfxScript_0024_1 - SfxStart + $3000
        .addr SfxScript_0024_2 - SfxStart + $3000
        .addr SfxScript_0025_1 - SfxStart + $3000
        .addr SfxScript_0025_2 - SfxStart + $3000
        .addr SfxScript_0026_1 - SfxStart + $3000
        .addr SfxScript_0026_2 - SfxStart + $3000
        .addr SfxScript_0027_1 - SfxStart + $3000
        .addr SfxScript_0027_2 - SfxStart + $3000
        .addr SfxScript_0028_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_0029_1 - SfxStart + $3000
        .addr SfxScript_0029_2 - SfxStart + $3000
        .addr SfxScript_002a_1 - SfxStart + $3000
        .addr SfxScript_002a_2 - SfxStart + $3000
        .addr SfxScript_002b_1 - SfxStart + $3000
        .addr SfxScript_002b_2 - SfxStart + $3000
        .addr SfxScript_002c_1 - SfxStart + $3000
        .addr SfxScript_002c_2 - SfxStart + $3000
        .addr SfxScript_002d_1 - SfxStart + $3000
        .addr SfxScript_002d_2 - SfxStart + $3000
        .addr SfxScript_002e_1 - SfxStart + $3000
        .addr SfxScript_002e_2 - SfxStart + $3000
        .addr SfxScript_002f_1 - SfxStart + $3000
        .addr SfxScript_002f_2 - SfxStart + $3000
        .addr SfxScript_0030_1 - SfxStart + $3000
        .addr SfxScript_0030_2 - SfxStart + $3000
        .addr SfxScript_0031_1 - SfxStart + $3000
        .addr SfxScript_0031_2 - SfxStart + $3000
        .addr SfxScript_0032_1 - SfxStart + $3000
        .addr SfxScript_0032_2 - SfxStart + $3000
        .addr SfxScript_0033_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_0034_1 - SfxStart + $3000
        .addr SfxScript_0034_2 - SfxStart + $3000
        .addr SfxScript_0035_1 - SfxStart + $3000
        .addr SfxScript_0035_2 - SfxStart + $3000
        .addr SfxScript_0036_1 - SfxStart + $3000
        .addr SfxScript_0036_2 - SfxStart + $3000
        .addr SfxScript_0037_1 - SfxStart + $3000
        .addr SfxScript_0037_2 - SfxStart + $3000
        .addr SfxScript_0038_1 - SfxStart + $3000
        .addr SfxScript_0038_2 - SfxStart + $3000
        .addr SfxScript_0039_1 - SfxStart + $3000
        .addr SfxScript_0039_2 - SfxStart + $3000
        .addr SfxScript_003a_1 - SfxStart + $3000
        .addr SfxScript_003a_2 - SfxStart + $3000
        .addr SfxScript_003b_1 - SfxStart + $3000
        .addr SfxScript_003b_2 - SfxStart + $3000
        .addr SfxScript_003c_1 - SfxStart + $3000
        .addr SfxScript_003c_2 - SfxStart + $3000
        .addr SfxScript_003d_1 - SfxStart + $3000
        .addr SfxScript_003d_2 - SfxStart + $3000
        .addr SfxScript_003e_1 - SfxStart + $3000
        .addr SfxScript_003e_2 - SfxStart + $3000
        .addr SfxScript_003f_1 - SfxStart + $3000
        .addr SfxScript_003f_2 - SfxStart + $3000
        .addr SfxScript_0040_1 - SfxStart + $3000
        .addr SfxScript_0040_2 - SfxStart + $3000
        .addr SfxScript_0041_1 - SfxStart + $3000
        .addr SfxScript_0041_2 - SfxStart + $3000
        .addr SfxScript_0042_1 - SfxStart + $3000
        .addr SfxScript_0042_2 - SfxStart + $3000
        .addr SfxScript_0043_1 - SfxStart + $3000
        .addr SfxScript_0043_2 - SfxStart + $3000
        .addr SfxScript_0044_1 - SfxStart + $3000
        .addr SfxScript_0044_2 - SfxStart + $3000
        .addr SfxScript_0045_1 - SfxStart + $3000
        .addr SfxScript_0045_2 - SfxStart + $3000
        .addr SfxScript_0046_1 - SfxStart + $3000
        .addr SfxScript_0046_2 - SfxStart + $3000
        .addr SfxScript_0047_1 - SfxStart + $3000
        .addr SfxScript_0047_2 - SfxStart + $3000
        .addr SfxScript_0048_1 - SfxStart + $3000
        .addr SfxScript_0048_2 - SfxStart + $3000
        .addr SfxScript_0049_1 - SfxStart + $3000
        .addr SfxScript_0049_2 - SfxStart + $3000
        .addr SfxScript_004a_1 - SfxStart + $3000
        .addr SfxScript_004a_2 - SfxStart + $3000
        .addr SfxScript_004b_1 - SfxStart + $3000
        .addr SfxScript_004b_2 - SfxStart + $3000
        .addr SfxScript_004c_1 - SfxStart + $3000
        .addr SfxScript_004c_2 - SfxStart + $3000
        .addr SfxScript_004d_1 - SfxStart + $3000
        .addr SfxScript_004d_2 - SfxStart + $3000
        .addr SfxScript_004e_1 - SfxStart + $3000
        .addr SfxScript_004e_2 - SfxStart + $3000
        .addr SfxScript_004f_1 - SfxStart + $3000
        .addr SfxScript_004f_2 - SfxStart + $3000
        .addr SfxScript_0050_1 - SfxStart + $3000
        .addr SfxScript_0050_2 - SfxStart + $3000
        .addr SfxScript_0051_1 - SfxStart + $3000
        .addr SfxScript_0051_2 - SfxStart + $3000
        .addr SfxScript_0052_1 - SfxStart + $3000
        .addr SfxScript_0052_2 - SfxStart + $3000
        .addr SfxScript_0053_1 - SfxStart + $3000
        .addr SfxScript_0053_2 - SfxStart + $3000
        .addr SfxScript_0054_1 - SfxStart + $3000
        .addr SfxScript_0054_2 - SfxStart + $3000
        .addr SfxScript_0055_1 - SfxStart + $3000
        .addr SfxScript_0055_2 - SfxStart + $3000
        .addr SfxScript_0056_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_0057_1 - SfxStart + $3000
        .addr SfxScript_0057_2 - SfxStart + $3000
        .addr SfxScript_0058_1 - SfxStart + $3000
        .addr SfxScript_0058_2 - SfxStart + $3000
        .addr SfxScript_0059_1 - SfxStart + $3000
        .addr SfxScript_0059_2 - SfxStart + $3000
        .addr SfxScript_005a_1 - SfxStart + $3000
        .addr SfxScript_005a_2 - SfxStart + $3000
        .addr SfxScript_005b_1 - SfxStart + $3000
        .addr SfxScript_005b_2 - SfxStart + $3000
        .addr SfxScript_005c_1 - SfxStart + $3000
        .addr SfxScript_005c_2 - SfxStart + $3000
        .addr SfxScript_005d_1 - SfxStart + $3000
        .addr SfxScript_005d_2 - SfxStart + $3000
        .addr SfxScript_005e_1 - SfxStart + $3000
        .addr SfxScript_005e_2 - SfxStart + $3000
        .addr SfxScript_005f_1 - SfxStart + $3000
        .addr SfxScript_005f_2 - SfxStart + $3000
        .addr SfxScript_0060_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_0061_1 - SfxStart + $3000
        .addr SfxScript_0061_2 - SfxStart + $3000
        .addr SfxScript_0062_1 - SfxStart + $3000
        .addr SfxScript_0062_2 - SfxStart + $3000
        .addr SfxScript_0063_1 - SfxStart + $3000
        .addr SfxScript_0063_2 - SfxStart + $3000
        .addr SfxScript_0064_1 - SfxStart + $3000
        .addr SfxScript_0064_2 - SfxStart + $3000
        .addr SfxScript_0065_1 - SfxStart + $3000
        .addr SfxScript_0065_2 - SfxStart + $3000
        .addr SfxScript_0066_1 - SfxStart + $3000
        .addr SfxScript_0066_2 - SfxStart + $3000
        .addr SfxScript_0067_1 - SfxStart + $3000
        .addr SfxScript_0067_2 - SfxStart + $3000
        .addr SfxScript_0068_1 - SfxStart + $3000
        .addr SfxScript_0068_2 - SfxStart + $3000
        .addr SfxScript_0069_1 - SfxStart + $3000
        .addr SfxScript_0069_2 - SfxStart + $3000
        .addr SfxScript_006a_1 - SfxStart + $3000
        .addr SfxScript_006a_2 - SfxStart + $3000
        .addr SfxScript_006b_1 - SfxStart + $3000
        .addr SfxScript_006b_2 - SfxStart + $3000
        .addr SfxScript_006c_1 - SfxStart + $3000
        .addr SfxScript_006c_2 - SfxStart + $3000
        .addr SfxScript_006d_1 - SfxStart + $3000
        .addr SfxScript_006d_2 - SfxStart + $3000
        .addr SfxScript_006e_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_006f_1 - SfxStart + $3000
        .addr SfxScript_006f_2 - SfxStart + $3000
        .addr SfxScript_0070_1 - SfxStart + $3000
        .addr SfxScript_0070_2 - SfxStart + $3000
        .addr SfxScript_0071_1 - SfxStart + $3000
        .addr SfxScript_0071_2 - SfxStart + $3000
        .addr SfxScript_0072_1 - SfxStart + $3000
        .addr SfxScript_0072_2 - SfxStart + $3000
        .addr SfxScript_0073_1 - SfxStart + $3000
        .addr SfxScript_0073_2 - SfxStart + $3000
        .addr SfxScript_0074_1 - SfxStart + $3000
        .addr SfxScript_0074_2 - SfxStart + $3000
        .addr SfxScript_0075_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_0076_1 - SfxStart + $3000
        .addr SfxScript_0076_2 - SfxStart + $3000
        .addr SfxScript_0077_1 - SfxStart + $3000
        .addr SfxScript_0077_2 - SfxStart + $3000
        .addr SfxScript_0078_1 - SfxStart + $3000
        .addr SfxScript_0078_2 - SfxStart + $3000
        .addr SfxScript_0079_1 - SfxStart + $3000
        .addr SfxScript_0079_2 - SfxStart + $3000
        .addr SfxScript_007a_1 - SfxStart + $3000
        .addr SfxScript_007a_2 - SfxStart + $3000
        .addr SfxScript_007b_1 - SfxStart + $3000
        .addr SfxScript_007b_2 - SfxStart + $3000
        .addr SfxScript_007c_1 - SfxStart + $3000
        .addr SfxScript_007c_2 - SfxStart + $3000
        .addr SfxScript_007d_1 - SfxStart + $3000
        .addr SfxScript_007d_2 - SfxStart + $3000
        .addr SfxScript_007e_1 - SfxStart + $3000
        .addr SfxScript_007e_2 - SfxStart + $3000
        .addr SfxScript_007f_1 - SfxStart + $3000
        .addr SfxScript_007f_2 - SfxStart + $3000
        .addr SfxScript_0080_1 - SfxStart + $3000
        .addr SfxScript_0080_2 - SfxStart + $3000
        .addr SfxScript_0081_1 - SfxStart + $3000
        .addr SfxScript_0081_2 - SfxStart + $3000
        .addr SfxScript_0082_1 - SfxStart + $3000
        .addr SfxScript_0082_2 - SfxStart + $3000
        .addr SfxScript_0083_1 - SfxStart + $3000
        .addr SfxScript_0083_2 - SfxStart + $3000
        .addr SfxScript_0084_1 - SfxStart + $3000
        .addr SfxScript_0084_2 - SfxStart + $3000
        .addr SfxScript_0085_1 - SfxStart + $3000
        .addr SfxScript_0085_2 - SfxStart + $3000
        .addr SfxScript_0086_1 - SfxStart + $3000
        .addr SfxScript_0086_2 - SfxStart + $3000
        .addr SfxScript_0087_1 - SfxStart + $3000
        .addr SfxScript_0087_2 - SfxStart + $3000
        .addr SfxScript_0088_1 - SfxStart + $3000
        .addr SfxScript_0088_2 - SfxStart + $3000
        .addr SfxScript_0089_1 - SfxStart + $3000
        .addr SfxScript_0089_2 - SfxStart + $3000
        .addr SfxScript_008a_1 - SfxStart + $3000
        .addr SfxScript_008a_2 - SfxStart + $3000
        .addr SfxScript_008b_1 - SfxStart + $3000
        .addr SfxScript_008b_2 - SfxStart + $3000
        .addr SfxScript_008c_1 - SfxStart + $3000
        .addr SfxScript_008c_2 - SfxStart + $3000
        .addr SfxScript_008d_1 - SfxStart + $3000
        .addr SfxScript_008d_2 - SfxStart + $3000
        .addr SfxScript_008e_1 - SfxStart + $3000
        .addr SfxScript_008e_2 - SfxStart + $3000
        .addr SfxScript_008f_1 - SfxStart + $3000
        .addr SfxScript_008f_2 - SfxStart + $3000
        .addr SfxScript_0090_1 - SfxStart + $3000
        .addr SfxScript_0090_2 - SfxStart + $3000
        .addr SfxScript_0091_1 - SfxStart + $3000
        .addr SfxScript_0091_2 - SfxStart + $3000
        .addr SfxScript_0092_1 - SfxStart + $3000
        .addr SfxScript_0092_2 - SfxStart + $3000
        .addr SfxScript_0093_1 - SfxStart + $3000
        .addr SfxScript_0093_2 - SfxStart + $3000
        .addr SfxScript_0094_1 - SfxStart + $3000
        .addr SfxScript_0094_2 - SfxStart + $3000
        .addr SfxScript_0095_1 - SfxStart + $3000
        .addr SfxScript_0095_2 - SfxStart + $3000
        .addr SfxScript_0096_1 - SfxStart + $3000
        .addr SfxScript_0096_2 - SfxStart + $3000
        .addr SfxScript_0097_1 - SfxStart + $3000
        .addr SfxScript_0097_2 - SfxStart + $3000
        .addr SfxScript_0098_1 - SfxStart + $3000
        .addr SfxScript_0098_2 - SfxStart + $3000
        .addr SfxScript_0099_1 - SfxStart + $3000
        .addr SfxScript_0099_2 - SfxStart + $3000
        .addr SfxScript_009a_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_009b_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_009c_1 - SfxStart + $3000
        .addr SfxScript_009c_2 - SfxStart + $3000
        .addr SfxScript_009d_1 - SfxStart + $3000
        .addr SfxScript_009d_2 - SfxStart + $3000
        .addr SfxScript_009e_1 - SfxStart + $3000
        .addr SfxScript_009e_2 - SfxStart + $3000
        .addr SfxScript_009f_1 - SfxStart + $3000
        .addr SfxScript_009f_2 - SfxStart + $3000
        .addr SfxScript_00a0_1 - SfxStart + $3000
        .addr SfxScript_00a0_2 - SfxStart + $3000
        .addr SfxScript_00a1_1 - SfxStart + $3000
        .addr SfxScript_00a1_2 - SfxStart + $3000
        .addr SfxScript_00a2_1 - SfxStart + $3000
        .addr SfxScript_00a2_2 - SfxStart + $3000
        .addr SfxScript_00a3_1 - SfxStart + $3000
        .addr SfxScript_00a3_2 - SfxStart + $3000
        .addr SfxScript_00a4_1 - SfxStart + $3000
        .addr SfxScript_00a4_2 - SfxStart + $3000
        .addr SfxScript_00a5_1 - SfxStart + $3000
        .addr SfxScript_00a5_2 - SfxStart + $3000
        .addr SfxScript_00a6_1 - SfxStart + $3000
        .addr SfxScript_00a6_2 - SfxStart + $3000
        .addr SfxScript_00a7_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00a8_1 - SfxStart + $3000
        .addr SfxScript_00a8_2 - SfxStart + $3000
        .addr SfxScript_00a9_1 - SfxStart + $3000
        .addr SfxScript_00a9_2 - SfxStart + $3000
        .addr SfxScript_00aa_1 - SfxStart + $3000
        .addr SfxScript_00aa_2 - SfxStart + $3000
        .addr SfxScript_00ab_1 - SfxStart + $3000
        .addr SfxScript_00ab_2 - SfxStart + $3000
        .addr SfxScript_00ac_1 - SfxStart + $3000
        .addr SfxScript_00ac_2 - SfxStart + $3000
        .addr SfxScript_00ad_1 - SfxStart + $3000
        .addr SfxScript_00ad_2 - SfxStart + $3000
        .addr SfxScript_00ae_1 - SfxStart + $3000
        .addr SfxScript_00ae_2 - SfxStart + $3000
        .addr SfxScript_00af_1 - SfxStart + $3000
        .addr 0
        .addr 0
        .addr SfxScript_00b0_2 - SfxStart + $3000
        .addr SfxScript_00b1_1 - SfxStart + $3000
        .addr SfxScript_00b1_2 - SfxStart + $3000
        .addr SfxScript_00b2_1 - SfxStart + $3000
        .addr SfxScript_00b2_2 - SfxStart + $3000
        .addr SfxScript_00b3_1 - SfxStart + $3000
        .addr SfxScript_00b3_2 - SfxStart + $3000
        .addr SfxScript_00b4_1 - SfxStart + $3000
        .addr SfxScript_00b4_2 - SfxStart + $3000
        .addr SfxScript_00b5_1 - SfxStart + $3000
        .addr SfxScript_00b5_2 - SfxStart + $3000
        .addr SfxScript_00b6_1 - SfxStart + $3000
        .addr SfxScript_00b6_2 - SfxStart + $3000
        .addr SfxScript_00b7_1 - SfxStart + $3000
        .addr SfxScript_00b7_2 - SfxStart + $3000
        .addr SfxScript_00b8_1 - SfxStart + $3000
        .addr SfxScript_00b8_2 - SfxStart + $3000
        .addr SfxScript_00b9_1 - SfxStart + $3000
        .addr SfxScript_00b9_2 - SfxStart + $3000
        .addr SfxScript_00ba_1 - SfxStart + $3000
        .addr SfxScript_00ba_2 - SfxStart + $3000
        .addr SfxScript_00bb_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00bc_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00bd_1 - SfxStart + $3000
        .addr SfxScript_00bd_2 - SfxStart + $3000
        .addr SfxScript_00be_1 - SfxStart + $3000
        .addr SfxScript_00be_2 - SfxStart + $3000
        .addr SfxScript_00bf_1 - SfxStart + $3000
        .addr SfxScript_00bf_2 - SfxStart + $3000
        .addr SfxScript_00c0_1 - SfxStart + $3000
        .addr SfxScript_00c0_2 - SfxStart + $3000
        .addr SfxScript_00c1_1 - SfxStart + $3000
        .addr SfxScript_00c1_2 - SfxStart + $3000
        .addr SfxScript_00c2_1 - SfxStart + $3000
        .addr SfxScript_00c2_2 - SfxStart + $3000
        .addr SfxScript_00c3_1 - SfxStart + $3000
        .addr SfxScript_00c3_2 - SfxStart + $3000
        .addr SfxScript_00c4_1 - SfxStart + $3000
        .addr SfxScript_00c4_2 - SfxStart + $3000
        .addr SfxScript_00c5_1 - SfxStart + $3000
        .addr SfxScript_00c5_2 - SfxStart + $3000
        .addr SfxScript_00c6_1 - SfxStart + $3000
        .addr SfxScript_00c6_2 - SfxStart + $3000
        .addr SfxScript_00c7_1 - SfxStart + $3000
        .addr SfxScript_00c7_2 - SfxStart + $3000
        .addr SfxScript_00c8_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00c9_1 - SfxStart + $3000
        .addr SfxScript_00c9_2 - SfxStart + $3000
        .addr SfxScript_00ca_1 - SfxStart + $3000
        .addr SfxScript_00ca_2 - SfxStart + $3000
        .addr SfxScript_00cb_1 - SfxStart + $3000
        .addr SfxScript_00cb_2 - SfxStart + $3000
        .addr SfxScript_00cc_1 - SfxStart + $3000
        .addr SfxScript_00cc_2 - SfxStart + $3000
        .addr SfxScript_00cd_1 - SfxStart + $3000
        .addr SfxScript_00cd_2 - SfxStart + $3000
        .addr SfxScript_00ce_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00cf_1 - SfxStart + $3000
        .addr SfxScript_00cf_2 - SfxStart + $3000
        .addr SfxScript_00d0_1 - SfxStart + $3000
        .addr SfxScript_00d0_2 - SfxStart + $3000
        .addr SfxScript_00d1_1 - SfxStart + $3000
        .addr SfxScript_00d1_2 - SfxStart + $3000
        .addr SfxScript_00d2_1 - SfxStart + $3000
        .addr SfxScript_00d2_2 - SfxStart + $3000
        .addr SfxScript_00d3_1 - SfxStart + $3000
        .addr SfxScript_00d3_2 - SfxStart + $3000
        .addr SfxScript_00d4_1 - SfxStart + $3000
        .addr SfxScript_00d4_2 - SfxStart + $3000
        .addr SfxScript_00d5_1 - SfxStart + $3000
        .addr SfxScript_00d5_2 - SfxStart + $3000
        .addr SfxScript_00d6_1 - SfxStart + $3000
        .addr SfxScript_00d6_2 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00d7_2 - SfxStart + $3000
        .addr SfxScript_00d8_1 - SfxStart + $3000
        .addr SfxScript_00d8_2 - SfxStart + $3000
        .addr SfxScript_00d9_1 - SfxStart + $3000
        .addr SfxScript_00d9_2 - SfxStart + $3000
        .addr SfxScript_00da_1 - SfxStart + $3000
        .addr SfxScript_00da_2 - SfxStart + $3000
        .addr SfxScript_00db_1 - SfxStart + $3000
        .addr SfxScript_00db_2 - SfxStart + $3000
        .addr SfxScript_00dc_1 - SfxStart + $3000
        .addr SfxScript_00dc_2 - SfxStart + $3000
        .addr SfxScript_00dd_1 - SfxStart + $3000
        .addr SfxScript_00dd_2 - SfxStart + $3000
        .addr SfxScript_00de_1 - SfxStart + $3000
        .addr SfxScript_00de_2 - SfxStart + $3000
        .addr SfxScript_00df_1 - SfxStart + $3000
        .addr SfxScript_00df_2 - SfxStart + $3000
        .addr SfxScript_00e0_1 - SfxStart + $3000
        .addr SfxScript_00e0_2 - SfxStart + $3000
        .addr SfxScript_00e1_1 - SfxStart + $3000
        .addr SfxScript_00e1_2 - SfxStart + $3000
        .addr SfxScript_00e2_1 - SfxStart + $3000
        .addr SfxScript_00e2_2 - SfxStart + $3000
        .addr SfxScript_00e3_1 - SfxStart + $3000
        .addr SfxScript_00e3_2 - SfxStart + $3000
        .addr SfxScript_00e4_1 - SfxStart + $3000
        .addr SfxScript_00e4_2 - SfxStart + $3000
        .addr SfxScript_00e5_1 - SfxStart + $3000
        .addr SfxScript_00e5_2 - SfxStart + $3000
        .addr SfxScript_00e6_1 - SfxStart + $3000
        .addr SfxScript_00e6_2 - SfxStart + $3000
        .addr SfxScript_00e7_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00e8_1 - SfxStart + $3000
        .addr SfxScript_00e8_2 - SfxStart + $3000
        .addr SfxScript_00e9_1 - SfxStart + $3000
        .addr SfxScript_00e9_2 - SfxStart + $3000
        .addr SfxScript_00ea_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00eb_1 - SfxStart + $3000
        .addr SfxScript_00eb_2 - SfxStart + $3000
        .addr SfxScript_00ec_1 - SfxStart + $3000
        .addr SfxScript_00ec_2 - SfxStart + $3000
        .addr SfxScript_00ed_1 - SfxStart + $3000
        .addr SfxScript_00ed_2 - SfxStart + $3000
        .addr SfxScript_00ee_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00ef_1 - SfxStart + $3000
        .addr SfxScript_00ef_2 - SfxStart + $3000
        .addr SfxScript_00f0_1 - SfxStart + $3000
        .addr SfxScript_00f0_2 - SfxStart + $3000
        .addr SfxScript_00f1_1 - SfxStart + $3000
        .addr SfxScript_00f1_2 - SfxStart + $3000
        .addr SfxScript_00f2_1 - SfxStart + $3000
        .addr SfxScript_00f2_2 - SfxStart + $3000
        .addr SfxScript_00f3_1 - SfxStart + $3000
        .addr SfxScript_00f3_2 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00f4_2 - SfxStart + $3000
        .addr SfxScript_00f5_1 - SfxStart + $3000
        .addr SfxScript_00f5_2 - SfxStart + $3000
        .addr SfxScript_00f6_1 - SfxStart + $3000
        .addr SfxScript_00f6_2 - SfxStart + $3000
        .addr SfxScript_00f7_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00f8_1 - SfxStart + $3000
        .addr SfxScript_00f8_2 - SfxStart + $3000
        .addr SfxScript_00f9_1 - SfxStart + $3000
        .addr SfxScript_00f9_2 - SfxStart + $3000
        .addr SfxScript_00fa_1 - SfxStart + $3000
        .addr 0
        .addr SfxScript_00fb_1 - SfxStart + $3000
        .addr SfxScript_00fb_2 - SfxStart + $3000
        .addr SfxScript_00fc_1 - SfxStart + $3000
        .addr SfxScript_00fc_2 - SfxStart + $3000
        .addr 0
        .addr 0
        .addr 0
        .addr 0
        .addr 0
        .addr 0

SfxStart:                                                       ; c5/245e
        .include "script/sfx_script_0000.asm"
        .include "script/sfx_script_0001.asm"
        .include "script/sfx_script_0002.asm"
        .include "script/sfx_script_0003.asm"
        .include "script/sfx_script_0004.asm"
        .include "script/sfx_script_0005.asm"
        .include "script/sfx_script_0006.asm"
        .include "script/sfx_script_0007.asm"
        .include "script/sfx_script_0008.asm"
        .include "script/sfx_script_0009.asm"
        .include "script/sfx_script_000a.asm"
        .include "script/sfx_script_000b.asm"
        .include "script/sfx_script_000c.asm"
        .include "script/sfx_script_000d.asm"
        .include "script/sfx_script_000e.asm"
        .include "script/sfx_script_000f.asm"
        .include "script/sfx_script_0010.asm"
        .include "script/sfx_script_0011.asm"
        .include "script/sfx_script_0012.asm"
        .include "script/sfx_script_0013.asm"
        .include "script/sfx_script_0014.asm"
        .include "script/sfx_script_0015.asm"
        .include "script/sfx_script_0016.asm"
        .include "script/sfx_script_0017.asm"
        .include "script/sfx_script_0018.asm"
        .include "script/sfx_script_0019.asm"
        .include "script/sfx_script_001a.asm"
        .include "script/sfx_script_001b.asm"
        .include "script/sfx_script_001c.asm"
        .include "script/sfx_script_001d.asm"
        .include "script/sfx_script_001e.asm"
        .include "script/sfx_script_001f.asm"
        .include "script/sfx_script_0020.asm"
        .include "script/sfx_script_0021.asm"
        .include "script/sfx_script_0022.asm"
        .include "script/sfx_script_0023.asm"
        .include "script/sfx_script_0024.asm"
        .include "script/sfx_script_0025.asm"
        .include "script/sfx_script_0026.asm"
        .include "script/sfx_script_0027.asm"
        .include "script/sfx_script_0028.asm"
        .include "script/sfx_script_0029.asm"
        .include "script/sfx_script_002a.asm"
        .include "script/sfx_script_002b.asm"
        .include "script/sfx_script_002c.asm"
        .include "script/sfx_script_002d.asm"
        .include "script/sfx_script_002e.asm"
        .include "script/sfx_script_002f.asm"
        .include "script/sfx_script_0030.asm"
        .include "script/sfx_script_0031.asm"
        .include "script/sfx_script_0032.asm"
        .include "script/sfx_script_0033.asm"
        .include "script/sfx_script_0034.asm"
        .include "script/sfx_script_0035.asm"
        .include "script/sfx_script_0036.asm"
        .include "script/sfx_script_0037.asm"
        .include "script/sfx_script_0038.asm"
        .include "script/sfx_script_0039.asm"
        .include "script/sfx_script_003a.asm"
        .include "script/sfx_script_003b.asm"
        .include "script/sfx_script_003c.asm"
        .include "script/sfx_script_003d.asm"
        .include "script/sfx_script_003e.asm"
        .include "script/sfx_script_003f.asm"
        .include "script/sfx_script_0040.asm"
        .include "script/sfx_script_0041.asm"
        .include "script/sfx_script_0042.asm"
        .include "script/sfx_script_0043.asm"
        .include "script/sfx_script_0044.asm"
        .include "script/sfx_script_0045.asm"
        .include "script/sfx_script_0046.asm"
        .include "script/sfx_script_0047.asm"
        .include "script/sfx_script_0048.asm"
        .include "script/sfx_script_0049.asm"
        .include "script/sfx_script_004a.asm"
        .include "script/sfx_script_004b.asm"
        .include "script/sfx_script_004c.asm"
        .include "script/sfx_script_004d.asm"
        .include "script/sfx_script_004e.asm"
        .include "script/sfx_script_004f.asm"
        .include "script/sfx_script_0050.asm"
        .include "script/sfx_script_0051.asm"
        .include "script/sfx_script_0052.asm"
        .include "script/sfx_script_0053.asm"
        .include "script/sfx_script_0054.asm"
        .include "script/sfx_script_0055.asm"
        .include "script/sfx_script_0056.asm"
        .include "script/sfx_script_0057.asm"
        .include "script/sfx_script_0058.asm"
        .include "script/sfx_script_0059.asm"
        .include "script/sfx_script_005a.asm"
        .include "script/sfx_script_005b.asm"
        .include "script/sfx_script_005c.asm"
        .include "script/sfx_script_005d.asm"
        .include "script/sfx_script_005e.asm"
        .include "script/sfx_script_005f.asm"
        .include "script/sfx_script_0060.asm"
        .include "script/sfx_script_0061.asm"
        .include "script/sfx_script_0062.asm"
        .include "script/sfx_script_0063.asm"
        .include "script/sfx_script_0064.asm"
        .include "script/sfx_script_0065.asm"
        .include "script/sfx_script_0066.asm"
        .include "script/sfx_script_0067.asm"
        .include "script/sfx_script_0068.asm"
        .include "script/sfx_script_0069.asm"
        .include "script/sfx_script_006a.asm"
        .include "script/sfx_script_006b.asm"
        .include "script/sfx_script_006c.asm"
        .include "script/sfx_script_006d.asm"
        .include "script/sfx_script_006e.asm"
        .include "script/sfx_script_006f.asm"
        .include "script/sfx_script_0070.asm"
        .include "script/sfx_script_0071.asm"
        .include "script/sfx_script_0072.asm"
        .include "script/sfx_script_0073.asm"
        .include "script/sfx_script_0074.asm"
        .include "script/sfx_script_0075.asm"
        .include "script/sfx_script_0076.asm"
        .include "script/sfx_script_0077.asm"
        .include "script/sfx_script_0078.asm"
        .include "script/sfx_script_0079.asm"
        .include "script/sfx_script_007a.asm"
        .include "script/sfx_script_007b.asm"
        .include "script/sfx_script_007c.asm"
        .include "script/sfx_script_007d.asm"
        .include "script/sfx_script_007e.asm"
        .include "script/sfx_script_007f.asm"
        .include "script/sfx_script_0080.asm"
        .include "script/sfx_script_0081.asm"
        .include "script/sfx_script_0082.asm"
        .include "script/sfx_script_0083.asm"
        .include "script/sfx_script_0084.asm"
        .include "script/sfx_script_0085.asm"
        .include "script/sfx_script_0086.asm"
        .include "script/sfx_script_0087.asm"
        .include "script/sfx_script_0088.asm"
        .include "script/sfx_script_0089.asm"
        .include "script/sfx_script_008a.asm"
        .include "script/sfx_script_008b.asm"
        .include "script/sfx_script_008c.asm"
        .include "script/sfx_script_008d.asm"
        .include "script/sfx_script_008e.asm"
        .include "script/sfx_script_008f.asm"
        .include "script/sfx_script_0090.asm"
        .include "script/sfx_script_0091.asm"
        .include "script/sfx_script_0092.asm"
        .include "script/sfx_script_0093.asm"
        .include "script/sfx_script_0094.asm"
        .include "script/sfx_script_0095.asm"
        .include "script/sfx_script_0096.asm"
        .include "script/sfx_script_0097.asm"
        .include "script/sfx_script_0098.asm"
        .include "script/sfx_script_0099.asm"
        .include "script/sfx_script_009a.asm"
        .include "script/sfx_script_009b.asm"
        .include "script/sfx_script_009c.asm"
        .include "script/sfx_script_009d.asm"
        .include "script/sfx_script_009e.asm"
        .include "script/sfx_script_009f.asm"
        .include "script/sfx_script_00a0.asm"
        .include "script/sfx_script_00a1.asm"
        .include "script/sfx_script_00a2.asm"
        .include "script/sfx_script_00a3.asm"
        .include "script/sfx_script_00a4.asm"
        .include "script/sfx_script_00a5.asm"
        .include "script/sfx_script_00a6.asm"
        .include "script/sfx_script_00a7.asm"
        .include "script/sfx_script_00a8.asm"
        .include "script/sfx_script_00a9.asm"
        .include "script/sfx_script_00aa.asm"
        .include "script/sfx_script_00ab.asm"
        .include "script/sfx_script_00ac.asm"
        .include "script/sfx_script_00ad.asm"
        .include "script/sfx_script_00ae.asm"
        .include "script/sfx_script_00af.asm"
        .include "script/sfx_script_00b0.asm"
        .include "script/sfx_script_00b1.asm"
        .include "script/sfx_script_00b2.asm"
        .include "script/sfx_script_00b3.asm"
        .include "script/sfx_script_00b4.asm"
        .include "script/sfx_script_00b5.asm"
        .include "script/sfx_script_00b6.asm"
        .include "script/sfx_script_00b7.asm"
        .include "script/sfx_script_00b8.asm"
        .include "script/sfx_script_00b9.asm"
        .include "script/sfx_script_00ba.asm"
        .include "script/sfx_script_00bb.asm"
        .include "script/sfx_script_00bc.asm"
        .include "script/sfx_script_00bd.asm"
        .include "script/sfx_script_00be.asm"
        .include "script/sfx_script_00bf.asm"
        .include "script/sfx_script_00c0.asm"
        .include "script/sfx_script_00c1.asm"
        .include "script/sfx_script_00c2.asm"
        .include "script/sfx_script_00c3.asm"
        .include "script/sfx_script_00c4.asm"
        .include "script/sfx_script_00c5.asm"
        .include "script/sfx_script_00c6.asm"
        .include "script/sfx_script_00c7.asm"
        .include "script/sfx_script_00c8.asm"
        .include "script/sfx_script_00c9.asm"
        .include "script/sfx_script_00ca.asm"
        .include "script/sfx_script_00cb.asm"
        .include "script/sfx_script_00cc.asm"
        .include "script/sfx_script_00cd.asm"
        .include "script/sfx_script_00ce.asm"
        .include "script/sfx_script_00cf.asm"
        .include "script/sfx_script_00d0.asm"
        .include "script/sfx_script_00d1.asm"
        .include "script/sfx_script_00d2.asm"
        .include "script/sfx_script_00d3.asm"
        .include "script/sfx_script_00d4.asm"
        .include "script/sfx_script_00d5.asm"
        .include "script/sfx_script_00d6.asm"
        .include "script/sfx_script_00d7.asm"
        .include "script/sfx_script_00d8.asm"
        .include "script/sfx_script_00d9.asm"
        .include "script/sfx_script_00da.asm"
        .include "script/sfx_script_00db.asm"
        .include "script/sfx_script_00dc.asm"
        .include "script/sfx_script_00dd.asm"
        .include "script/sfx_script_00de.asm"
        .include "script/sfx_script_00df.asm"
        .include "script/sfx_script_00e0.asm"
        .include "script/sfx_script_00e1.asm"
        .include "script/sfx_script_00e2.asm"
        .include "script/sfx_script_00e3.asm"
        .include "script/sfx_script_00e4.asm"
        .include "script/sfx_script_00e5.asm"
        .include "script/sfx_script_00e6.asm"
        .include "script/sfx_script_00e7.asm"
        .include "script/sfx_script_00e8.asm"
        .include "script/sfx_script_00e9.asm"
        .include "script/sfx_script_00ea.asm"
        .include "script/sfx_script_00eb.asm"
        .include "script/sfx_script_00ec.asm"
        .include "script/sfx_script_00ed.asm"
        .include "script/sfx_script_00ee.asm"
        .include "script/sfx_script_00ef.asm"
        .include "script/sfx_script_00f0.asm"
        .include "script/sfx_script_00f1.asm"
        .include "script/sfx_script_00f2.asm"
        .include "script/sfx_script_00f3.asm"
        .include "script/sfx_script_00f4.asm"
        .include "script/sfx_script_00f5.asm"
        .include "script/sfx_script_00f6.asm"
        .include "script/sfx_script_00f7.asm"
        .include "script/sfx_script_00f8.asm"
        .include "script/sfx_script_00f9.asm"
        .include "script/sfx_script_00fa.asm"
        .include "script/sfx_script_00fb.asm"
        .include "script/sfx_script_00fc.asm"
        .res $10                                                ; c5/3c4e

NumSongs:
        .byte   SongScript_ARRAY_LENGTH                         ; c5/3c5e

SampleBRRPtrs:                                                  ; c5/3c5f
        make_ptr_tbl_far SampleBRR, SampleBRR_ARRAY_LENGTH, 0
        .include "assets/sample_loop_start.asm"                 ; c5/3d1c
        .include "assets/sample_freq_mult.asm"                  ; c5/3d9a
        .include "assets/sample_adsr.asm"                       ; c5/3e18

SongScriptPtrs:                                                 ; c5/3e96
        make_ptr_tbl_far SongScript, SongScript_ARRAY_LENGTH, 0
        .include "assets/song_samples.asm"                      ; c5/3f95
        .include "assets/sample_brr.asm"                        ; c5/4a35

SongScript:                                                     ; c8/5c7a

SongScript_0051:                        ; song $51 is the same as song 0
        .include "script/song_script_0000.asm"
        .include "script/song_script_0001.asm"
        .include "script/song_script_0005.asm"
        .include "script/song_script_0006.asm"
        .include "script/song_script_0007.asm"
        .include "script/song_script_0008.asm"
        .include "script/song_script_0009.asm"
        .include "script/song_script_000a.asm"
        .include "script/song_script_000b.asm"
        .include "script/song_script_000c.asm"
        .include "script/song_script_000d.asm"
        .include "script/song_script_000e.asm"
        .include "script/song_script_000f.asm"
        .include "script/song_script_0010.asm"
        .include "script/song_script_0011.asm"
        .include "script/song_script_0012.asm"
        .include "script/song_script_0013.asm"
        .include "script/song_script_0013a.asm"
        .include "script/song_script_0014.asm"
        .include "script/song_script_0015.asm"
        .include "script/song_script_0003.asm"
        .include "script/song_script_0016.asm"
        .include "script/song_script_0017.asm"
        .include "script/song_script_0018.asm"
        .include "script/song_script_0004.asm"
        .include "script/song_script_0019.asm"
        .include "script/song_script_001a.asm"
        .include "script/song_script_001b.asm"
        .include "script/song_script_001c.asm"
        .include "script/song_script_001d.asm"
        .include "script/song_script_001e.asm"
        .include "script/song_script_001f.asm"
        .include "script/song_script_0020.asm"
        .include "script/song_script_0021.asm"
        .include "script/song_script_0022.asm"
        .include "script/song_script_0023.asm"
        .include "script/song_script_0024.asm"
        .include "script/song_script_0025.asm"
        .include "script/song_script_0026.asm"
        .include "script/song_script_0027.asm"
        .include "script/song_script_002a.asm"
        .include "script/song_script_002d.asm"
        .include "script/song_script_002e.asm"
        .include "script/song_script_002f.asm"
        .include "script/song_script_0030.asm"
        .include "script/song_script_0031.asm"
        .include "script/song_script_0032.asm"
        .include "script/song_script_0033.asm"
        .include "script/song_script_0034.asm"
        .include "script/song_script_0035.asm"
        .include "script/song_script_0036.asm"
        .include "script/song_script_0037.asm"
        .include "script/song_script_0038.asm"
        .include "script/song_script_0039.asm"
        .include "script/song_script_003a.asm"
        .include "script/song_script_003b.asm"
        .include "script/song_script_003c.asm"
        .include "script/song_script_003d.asm"
        .include "script/song_script_003e.asm"
        .include "script/song_script_003f.asm"
        .include "script/song_script_0040.asm"
        .include "script/song_script_0041.asm"
        .include "script/song_script_0042.asm"
        .include "script/song_script_0043.asm"
        .include "script/song_script_0044.asm"
        .include "script/song_script_0045.asm"
        .include "script/song_script_0046.asm"
        .include "script/song_script_0002.asm"
        .include "script/song_script_0047.asm"
        .include "script/song_script_0048.asm"
        .include "script/song_script_0049.asm"
        .include "script/song_script_004a.asm"
        .include "script/song_script_002b.asm"
        .include "script/song_script_0028.asm"
        .include "script/song_script_0029.asm"
        .include "script/song_script_002c.asm"
        .include "script/song_script_004b.asm"
        .include "script/song_script_004c.asm"
        .include "script/song_script_004d.asm"
        .include "script/song_script_004e.asm"
        .include "script/song_script_004f.asm"
        .include "script/song_script_0050.asm"
        .include "script/song_script_0052.asm"
        .include "script/song_script_0053.asm"
        .include "script/song_script_0054.asm"

; ------------------------------------------------------------------------------

.segment "the_end_gfx2"

        .include "assets/the_end_gfx2.asm"                      ; c9/fe00
        .include "assets/the_end_pal.asm"                       ; c9/ff00

; ------------------------------------------------------------------------------

.segment "event_script"

        inc_lang "assets/event_script_%s.asm"                   ; ca/0000

; ------------------------------------------------------------------------------

.export DlgBankInc, DlgPtrs

.segment "dialogue_ptrs"

DlgBankInc:
        .word   Dlg1_ARRAY_LENGTH                               ; cc/e600
DlgPtrs:
        make_ptr_tbl_rel Dlg1, Dlg1_ARRAY_LENGTH                ; cc/e602
        make_ptr_tbl_rel Dlg2, Dlg2_ARRAY_LENGTH, Dlg1+$10000

; ------------------------------------------------------------------------------

.segment "dialogue"

        inc_lang "assets/dlg1_%s.asm"                           ; cd/0000
        inc_lang "assets/dlg2_%s.asm"

; ------------------------------------------------------------------------------

.if LANG_EN

.segment "map_title"

        inc_lang "assets/map_title_%s.asm"                      ; ce/f100

.endif

; ------------------------------------------------------------------------------

.segment "world_mod"

        .include "assets/world_mod_data.asm"                    ; ce/f600
        WorldModData_end := *
        .include "assets/world_mod_tiles.asm"                   ; ce/f648
        .res $0500+WorldModData-*

; unused (30 * 3 bytes)
.if LANG_EN
        .faraddr 1,2,3,4,5,6,7,8,9,0,0,0,0,0,0                  ; ce/fb00
        .faraddr 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.endif

; ------------------------------------------------------------------------------

.segment "rare_item"

RareItemDescPtrs:                                               ; ce/fb60
        make_ptr_tbl_rel RareItemDesc, RareItemDesc_ARRAY_LENGTH
        .res $40+RareItemDescPtrs-*
        inc_lang "assets/rare_item_name_%s.asm"                 ; ce/fba0
        .res $0110+RareItemName-*
        inc_lang "assets/rare_item_desc_%s.asm"                 ; ce/fcb0

; ------------------------------------------------------------------------------

.segment "battle_data"

        .include "assets/monster_prop.asm"                      ; cf/0000
        .include "assets/monster_items.asm"                     ; cf/3000
        .include "assets/monster_overlap.asm"                   ; cf/3600
        .include "assets/cond_battle.asm"                       ; cf/3780
        .include "assets/monster_special_anim.asm"              ; cf/37c0
        inc_lang "assets/genju_attack_desc_%s.asm"              ; cf/3940
        .res $0300+GenjuAttackDesc-*
        inc_lang "assets/bushido_name_%s.asm"                   ; cf/3c40
        .res $c0+BushidoName-*
        .include "assets/monster_control.asm"                   ; cf/3d00
        .include "assets/monster_sketch.asm"                    ; cf/4300
        .include "assets/monster_rage.asm"                      ; cf/4600
        .include "assets/rand_battle_group.asm"                 ; cf/4800
        .include "assets/event_battle_group.asm"                ; cf/5000
        .include "assets/world_battle_group.asm"                ; cf/5400
        .include "assets/sub_battle_group.asm"                  ; cf/5600
        .include "assets/world_battle_rate.asm"                 ; cf/5800
        .include "assets/sub_battle_rate.asm"                   ; cf/5880
        .include "assets/battle_prop.asm"                       ; cf/5900
        .include "assets/battle_monsters.asm"                   ; cf/6200
        .res $2200+BattleMonsters-*
        .include "assets/ai_script_ptr.asm"                     ; cf/8400
        .include "assets/ai_script.asm"                         ; cf/8700
        .res $3950+AIScript-*
        inc_lang "assets/monster_name_%s.asm"                   ; cf/c050
        .res $1080+MonsterName-*
        inc_lang "assets/monster_special_name_%s.asm"           ; cf/d0d0
        .res $0f10+MonsterSpecialName-*
MonsterDlgPtrs:                                                 ; cf/dfe0
        make_ptr_tbl_rel MonsterDlg, MonsterDlg_ARRAY_LENGTH, .bankbyte(*)<<16
        inc_lang "assets/monster_dlg_%s.asm"                    ; cf/e1e0

; ------------------------------------------------------------------------------

.segment "battle_data2"

        inc_lang "assets/blitz_desc_%s.asm"                     ; cf/fc00
        .res $0100+BlitzDesc-*
        inc_lang "assets/bushido_desc_%s.asm"                   ; cf/fd00
        .res $0100+BushidoDesc-*
        .include "assets/battle_cmd_prop.asm"                   ; cf/fe00
GenjuAttackDescPtrs:                                            ; cf/fe40
        make_ptr_tbl_rel GenjuAttackDesc, GenjuAttackDesc_ARRAY_LENGTH, GenjuAttackDesc
        .include "assets/dance_prop.asm"                        ; cf/fe80

; cf/fea0 desperation attacks for each character (unused)
        .byte   $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$ff,$fb,$ff
        inc_lang "assets/genju_bonus_name_%s.asm"               ; cf/feae
        .res $f0+GenjuBonusName-*
BlitzDescPtrs:                                                  ; cf/ff9e
        make_ptr_tbl_rel BlitzDesc, BlitzDesc_ARRAY_LENGTH, BlitzDesc
BushidoDescPtrs:                                                ; cf/ffae
        make_ptr_tbl_rel BushidoDesc, BushidoDesc_ARRAY_LENGTH, BushidoDesc

; ------------------------------------------------------------------------------

.segment "battle_event"

        .include "assets/attack_anim_script.asm"                ; d0/0000
        .include "assets/attack_anim_prop.asm"                  ; d0/7fb2
        .res $9800+AttackAnimScript-*

        .include "assets/battle_event_script_ptrs.asm"          ; d0/9800
        .include "assets/battle_event_script.asm"               ; d0/9842
        .res $3800+BattleEventScriptPtrs-*

BattleDlgPtrs:
        make_ptr_tbl_abs BattleDlg, 256                         ; d0/d000
        inc_lang "assets/battle_dlg_%s.asm"                     ; d0/d200
        .res $2d00+BattleDlgPtrs-*
        .include "assets/char_ai.asm"                           ; d0/fd00

; ------------------------------------------------------------------------------

.export ItemAnimPtrs

.segment "battle_anim1"

ItemAnimPtrs:
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   402*14
        .word   337*14
        .word   338*14
        .word   339*14
        .word   340*14
        .word   341*14
        .word   342*14
        .word   343*14
        .word   344*14
        .word   345*14
        .word   346*14
        .word   347*14
        .word   348*14
        .word   349*14
        .word   350*14
        .word   351*14
        .word   352*14
        .word   353*14
        .word   354*14
        .word   355*14
        .word   356*14
        .word   357*14
        .word   358*14
        .word   359*14
        .word   $ffff

        .include "assets/item_jump_throw_anim.asm"              ; d1/0040
        inc_lang "assets/attack_anim_frames_%s.asm"             ; d1/0141
        AttackAnimFramesEnd := *
        .res $ead8+ItemAnimPtrs-*

        .include "assets/attack_anim_script_ptrs.asm"           ; d1/ead8
        .res $f000+ItemAnimPtrs-*

        inc_lang "assets/attack_msg_%s.asm"                     ; d1/f000
        .res $07a0+AttackMsg-*
AttackMsgPtrs:                                                  ; d1/f7a0
        make_ptr_tbl_rel AttackMsg, AttackMsg_ARRAY_LENGTH, .bankbyte(*)<<16
        .res 11
        .include "assets/dance_bg.asm"                          ; d1/f9ab
        .byte   1,1
        .include "assets/genju_order.asm"                       ; d1/f9b5

; ------------------------------------------------------------------------------

.segment "map_init_event"

        .include "assets/map_init_event.asm"                    ; d1/fa00

; ------------------------------------------------------------------------------

.segment "battle_anim2"

        inc_lang "assets/attack_tiles_3bpp_%s.asm"              ; d2/0000
        .include "assets/attack_pal.asm"                        ; d2/6000
        inc_lang "assets/item_type_name_%s.asm"                 ; d2/6f00

; ------------------------------------------------------------------------------

.export MonsterStencil

.segment "monster_gfx_prop"

        inc_lang "assets/monster_gfx_prop_%s.asm"               ; d2/7000
        .include "assets/monster_pal.asm"                       ; d2/7820

MonsterStencil:
        .addr   MonsterStencilSmall
        .addr   MonsterStencilLarge
        inc_lang "assets/monster_stencil_small_%s.asm"          ; d2/a824
        inc_lang "assets/monster_stencil_large_%s.asm"          ; d2/ac24

; ------------------------------------------------------------------------------

.segment "item_name"

        inc_lang "assets/item_name_%s.asm"                      ; d2/b300

; ------------------------------------------------------------------------------

.segment "battle_anim3"

        .include "assets/attack_tiles_2bpp.asm"                 ; d2/c000
        .include "assets/status_gfx.asm"                        ; d2/e000

; ------------------------------------------------------------------------------

.segment "world_pal"

        .include "assets/world_bg_pal1.asm"                     ; d2/ec00
        .include "assets/world_bg_pal2.asm"                     ; d2/ed00
        .include "assets/world_sprite_pal1.asm"                 ; d2/ee00
        .include "assets/world_sprite_pal2.asm"                 ; d2/ef00

; ------------------------------------------------------------------------------

.segment "slot_gfx"

        .include "assets/slot_gfx.asm"                          ; d2/f000

; ------------------------------------------------------------------------------

.segment "attack_gfx_3bpp"

        inc_lang "assets/attack_gfx_3bpp_%s.asm"                ; d3/0000

; ------------------------------------------------------------------------------

.segment "battle_anim4"

        inc_lang "assets/attack_gfx_prop_%s.asm"                ; d4/d000

AttackAnimFramesPtrs:                                           ; d4/df3c
        make_ptr_tbl_rel AttackAnimFrames, AttackAnimFrames_ARRAY_LENGTH, .bankbyte(*)<<16
        .addr   AttackAnimFramesEnd

; ------------------------------------------------------------------------------

.segment "map_sprite_gfx"

; export map sprite graphics for battle
.repeat MapSpriteGfx_ARRAY_LENGTH, i
        .export .ident(.sprintf("MapSpriteGfx_%04x", i))
.endrep

        .include "assets/map_sprite_gfx.asm"                    ; d5/0000
        .include "assets/vehicle_gfx.asm"                       ; d8/3000

; ------------------------------------------------------------------------------

.segment "item_genju_prop"

        inc_lang "assets/item_prop_%s.asm"                      ; d8/5000
        .include "assets/genju_prop.asm"                        ; d8/6e00

; ------------------------------------------------------------------------------

.segment "attack_gfx_2bpp"

        .include "assets/attack_gfx_2bpp.asm"                   ; d8/7000

; ------------------------------------------------------------------------------

.segment "magic_desc"

        inc_lang "assets/magic_desc_%s.asm"                     ; d8/c9a0
        .res $0500+MagicDesc-*
        inc_lang "assets/battle_cmd_name_%s.asm"                ; d8/cea0
MagicDescPtrs:
        make_ptr_tbl_rel MagicDesc, MagicDesc_ARRAY_LENGTH      ; d8/cf80

; ------------------------------------------------------------------------------

.segment "attack_gfx_mode7"

        .include "assets/attack_gfx_mode7.asm"                  ; d8/d000
        .include "assets/attack_tiles_mode7.asm"                ; d8/daf2

; ------------------------------------------------------------------------------

.segment "cutscene_mode7"

        .include "assets/magitek_train_tiles.asm"               ; d8/dd00
        .include "assets/vector_approach_gfx.asm"               ; d8/dfb8
        .include "assets/vector_approach_tiles.asm"             ; d8/e5bf
        .include "assets/world_pal3.asm"                        ; d8/e6ba

; ------------------------------------------------------------------------------

.segment "title_opening_gfx"

        inc_lang "assets/title_opening_gfx_%s.asm"              ; d8/f000
.if LANG_EN
        .res $24
.endif
        .include "assets/floating_cont_gfx.asm"                 ; d9/4e96
        .res 3

; ------------------------------------------------------------------------------

.segment "credits_gfx"

        .include "assets/credits_gfx1.asm"                      ; d9/568f
        .res $46bc+CreditsGfx1-*
        .include "assets/ending_gfx4.asm"                       ; d9/9d4b
        .res $079a+EndingGfx4-*
        .include "assets/ending_gfx5.asm"                       ; d9/a4e5

; ------------------------------------------------------------------------------

.segment "map_tile_data"

        .include "assets/map_tile_prop.asm"                     ; d9/a800
        MapTileProp_end := *
        .res $2510+MapTileProp-*
MapTilePropPtrs:
        make_ptr_tbl_rel MapTileProp, MapTileProp_ARRAY_LENGTH  ; d9/cd10
        .addr MapTileProp_end - MapTileProp
        .res $80+MapTilePropPtrs-*
SubTilemapPtrs:
        make_ptr_tbl_far SubTilemap, SubTilemap_ARRAY_LENGTH    ; d9/cd90
        .faraddr SubTilemap_end - SubTilemap
        .res $420+SubTilemapPtrs-*
        .include "assets/sub_tilemap.asm"                       ; d9/d1b0
        SubTilemap_end := *

; ------------------------------------------------------------------------------

.segment "map_tile_data2"

        inc_lang "assets/map_tileset_%s.asm"                    ; de/0000
        MapTileset_end := *
        .res $01b400+MapTileset-*
        .include "assets/battle_magic_points.asm"               ; df/b400
        .include "assets/colosseum_prop.asm"                    ; df/b600
MapTilesetPtrs:
        make_ptr_tbl_far MapTileset, MapTileset_ARRAY_LENGTH    ; df/ba00
        .faraddr MapTileset_end - MapTileset
        .res $0100+MapTilesetPtrs-*
ShortEntrancePtrs:                                              ; df/bb00
        make_ptr_tbl_rel ShortEntrance, ShortEntrance_ARRAY_LENGTH, ShortEntrancePtrs
        .addr ShortEntrance_end - ShortEntrancePtrs
        .include "assets/short_entrance.asm"                    ; df/bf02
        ShortEntrance_end := *

; ------------------------------------------------------------------------------

.segment "map_gfx"

MapGfxPtrs:
        make_ptr_tbl_far MapGfx, MapGfx_ARRAY_LENGTH            ; df/da00
        .res $0100+MapGfxPtrs-*
        inc_lang "assets/map_gfx_%s.asm"                        ; df/db00

; ------------------------------------------------------------------------------

.export BlitzLevelTbl, BushidoLevelTbl

.segment "map_gfx2"

        .include "assets/map_anim_gfx.asm"                      ; e6/0000
        .include "assets/map_sprite_pal.asm"                    ; e6/8000
MapTitlePtrs:
        make_ptr_tbl_rel MapTitle, MapTitle_ARRAY_LENGTH        ; e6/8400
.if !LANG_EN
        inc_lang "assets/map_title_%s.asm"                      ; e6/84c0
.endif
        .res $0380+MapTitlePtrs-*
        .include "assets/map_gfx_bg3.asm"                       ; e6/8780
        MapGfxBG3End := *
        .res $45E0+MapGfxBG3-*
MapGfxBG3Ptrs:
        make_ptr_tbl_far MapGfxBG3, MapGfxBG3_ARRAY_LENGTH      ; e6/cd60
        .faraddr MapGfxBG3End-MapGfxBG3
        .res $40+MapGfxBG3Ptrs-*
MapAnimGfxBG3Ptrs:                                              ; e6/cda0
        make_ptr_tbl_far MapAnimGfxBG3, MapAnimGfxBG3_ARRAY_LENGTH
        .faraddr MapAnimGfxBG3End-MapAnimGfxBG3
        .res $20+MapAnimGfxBG3Ptrs-*
        .include "assets/map_anim_gfx_bg3.asm"                  ; e6/cdc0
        MapAnimGfxBG3End := *
        .res $2440+MapAnimGfxBG3-*
        .include "assets/map_pal_anim_colors.asm"               ; e6/f200
        .res $0290+MapPalAnimColors-*
BushidoLevelTbl:
        .byte   1,6,12,15,24,34,44,70                           ; e6/f490
BlitzLevelTbl:
        .byte   1,6,10,15,23,30,42,70                           ; e6/f498
        .include "assets/level_up_hp.asm"                       ; e6/f4a0
        inc_lang "assets/level_up_mp_%s.asm"                    ; e6/f502
        .include "assets/init_lore.asm"                         ; e6/f564
        inc_lang "assets/magic_name_%s.asm"                     ; e6/f567
        inc_lang "assets/genju_name_%s.asm"                     ; e6/f6e1
        inc_lang "assets/attack_name_%s.asm"                    ; e6/f7b9
        inc_lang "assets/genju_attack_name_%s.asm"              ; e6/fe8f
        inc_lang "assets/dance_name_%s.asm"                     ; e6/ff9d

; ------------------------------------------------------------------------------

.segment "battle_bg"

BattleBGGfx_000a := MapGfx_004a
BattleBGGfx_000b := MapGfx_001c
BattleBGGfx_000c := MapGfx_0017
BattleBGGfx_000d := MapGfx_0014
BattleBGGfx_000e := MapGfx_0015
BattleBGGfx_000f := MapGfx_0026
BattleBGGfx_0010 := MapGfx_002a
BattleBGGfx_0011 := MapGfx_000e
BattleBGGfx_0015 := MapGfx_0028
BattleBGGfx_001a := MapGfx_0041
BattleBGGfx_0027 := MapGfx_0036
BattleBGGfx_0028 := MapGfx_0048
BattleBGGfx_0029 := MapGfx_0030
BattleBGGfx_002a := MapGfx_0023
BattleBGGfx_002b := MapGfx_0049
BattleBGGfx_002c := MapGfx_0025
BattleBGGfx_002e := MapGfx_0000
BattleBGGfx_0030 := MapGfx_0019
BattleBGGfx_0031 := MapGfx_0027
BattleBGGfx_0033 := MapGfx_004b
BattleBGGfx_0035 := MapGfx_002b
BattleBGGfx_0037 := MapGfx_003e
BattleBGGfx_0038 := MapGfx_004f
BattleBGGfx_003a := MapGfx_002e
BattleBGGfx_0047 := MapGfx_0039
BattleBGGfx_0048 := MapGfx_0051
BattleBGGfx_0049 := MapGfx_0031

        .include "assets/battle_bg_prop.asm"                    ; e7/0000
        .include "assets/battle_bg_pal.asm"                     ; e7/0150

BattleBGGfxPtrs:                                                ; e7/1650
        make_ptr_tbl_far BattleBGGfx, BattleBGGfx_ARRAY_LENGTH, 0
        .res $0117, 0

BattleBGTilesPtrs:                                              ; e7/1848
        make_ptr_tbl_rel BattleBGTiles, BattleBGTiles_ARRAY_LENGTH, .bankbyte(*)<<16

        .include "assets/battle_bg_tiles.asm"                   ; e7/1928
        inc_lang "assets/battle_bg_gfx_%s.asm"                  ; e7/a9e7

; ------------------------------------------------------------------------------

.segment "the_end_gfx1"
        .include "assets/the_end_gfx1.asm"                      ; e9/6300

; ------------------------------------------------------------------------------

.segment "monster_gfx"

        inc_lang "assets/monster_gfx_%s.asm"                    ; e9/7000

; ------------------------------------------------------------------------------

.segment "weapon_anim"

        .include "assets/weapon_anim_prop.asm"                  ; ec/e400
        .include "assets/monster_attack_anim_prop.asm"          ; ec/e6e8
        .include "assets/monster_align.asm"                     ; ec/e800

; ------------------------------------------------------------------------------

.segment "ruin_cutscene_gfx"

        .include "assets/ruin_cutscene_gfx.asm"                 ; ec/e900

; ------------------------------------------------------------------------------

.export NaturalMagic_0000, NaturalMagic_0001

.segment "natural_magic"

        .include "assets/natural_magic.asm"                     ; ec/e3c0

; ------------------------------------------------------------------------------

.repeat PortraitGfx_ARRAY_LENGTH, i
        .export .ident(.sprintf("PortraitGfx_%04x", i))
.endrep

.repeat WindowGfx_ARRAY_LENGTH, i
        .export .ident(.sprintf("WindowGfx_%04x", i))
.endrep

.segment "menu_gfx"

        .include "assets/window_gfx.asm"                        ; ed/0000
        .include "assets/window_pal.asm"                        ; ed/1c00
        .include "assets/portrait_gfx.asm"                      ; ed/1d00
        .include "assets/portrait_pal.asm"                      ; ed/5860
        .include "assets/menu_sprite_gfx.asm"                   ; ed/5ac0
        .include "assets/battle_font_pal.asm"                   ; ed/62c0
        .include "assets/battle_char_pal.asm"                   ; ed/6300
        .res 32

; ------------------------------------------------------------------------------

        inc_lang "assets/item_desc_%s.asm"                      ; ed/6400
        .res $13a0+ItemDesc-*
        inc_lang "assets/lore_desc_%s.asm"                      ; ed/77a0
        .res $02d0+LoreDesc-*
LoreDescPtrs:                                                   ; ed/7a70
        make_ptr_tbl_rel LoreDesc, LoreDesc_ARRAY_LENGTH
ItemDescPtrs:                                                   ; ed/7aa0
        make_ptr_tbl_rel ItemDesc, ItemDesc_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "char_prop"

        .include "assets/char_prop.asm"                         ; ed/7ca0
        .include "assets/level_up_exp.asm"                      ; ed/8220

; ------------------------------------------------------------------------------

.segment "treasure_prop"

        .include "assets/imp_item.asm"                          ; ed/82e4
TreasurePropPtrs:                                               ; ed/82f4
        make_ptr_tbl_rel TreasureProp, TreasureProp_ARRAY_LENGTH
        .addr TreasurePropEnd - TreasureProp
        .include "assets/treasure_prop.asm"                     ; ed/8634
        TreasurePropEnd := *

; ------------------------------------------------------------------------------

.segment "battle_bg_dance"

        .include "assets/battle_bg_dance.asm"                   ; ed/8e5b

; ------------------------------------------------------------------------------

.segment "map_data"

        .include "assets/map_prop.asm"                          ; ed/8f00
        .res 1
        .include "assets/map_pal.asm"                           ; ed/c480
LongEntrancePtrs:                                               ; ed/f480
        make_ptr_tbl_rel LongEntrance, LongEntrance_ARRAY_LENGTH, LongEntrancePtrs
        .addr LongEntranceEnd - LongEntrancePtrs
        .include "assets/long_entrance.asm"                     ; ed/f882
        LongEntranceEnd := *

; ------------------------------------------------------------------------------

.segment "genju_bonus_desc"

        inc_lang "assets/genju_bonus_desc_%s.asm"               ; ed/fe00
        .res $01d0+GenjuBonusDesc-*
GenjuBonusDescPtrs:                                             ; ed/ffd0
        make_ptr_tbl_rel GenjuBonusDesc, GenjuBonusDesc_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.export WorldBackdropGfxPtr
.export WorldBackdropTilesPtr
.export AirshipGfx1Ptr
.export WorldTilemap1Ptr
.export WorldGfx1Ptr
.export MagitekTrainGfxPtr
.export MagitekTrainPalPtr
.export WorldGfx2Ptr
.export WorldTilemap2Ptr
.export WorldTilemap3Ptr
.export WorldGfx3Ptr
.export WorldChocoGfx1Ptr
.export VectorApproachPalPtr
.export WorldEsperTerraPalPtr
.export WorldSpriteGfx1Ptr
.export WorldSpriteGfx2Ptr
.export WorldChocoGfx2Ptr
.export MinimapGfx1Ptr
.export MinimapGfx2Ptr
.export AirshipGfx2Ptr
.export EndingAirshipScenePalPtr
.export VehicleEvent_00
.export VehicleEvent_01
.export VehicleEvent_02
.export VehicleEvent_03
.export VehicleEvent_04
.export VehicleEvent_05
.export VehicleEvent_06

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

WorldModDataPtrs:                                               ; ee/b260
        make_ptr_tbl_far WorldModData, WorldModData_ARRAY_LENGTH, 0
        .faraddr WorldModData_end

VehicleEvent_00:                                                ; ee/b269
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

        .include "assets/world_backdrop_gfx.asm"                ; ee/b290
        .include "assets/world_backdrop_tiles.asm"              ; ee/c295
        .include "assets/airship_gfx1.asm"                      ; ee/c702
        .include "assets/world_tilemap1.asm"                    ; ee/d434
        .include "assets/world_gfx1.asm"                        ; ef/114f
        .include "assets/magitek_train_gfx.asm"                 ; ef/3250
        .include "assets/magitek_train_pal.asm"                 ; ef/4846
        .include "assets/world_gfx2.asm"                        ; ef/4a46
        .include "assets/world_tilemap2.asm"                    ; ef/6a56
        .include "assets/world_tilemap3.asm"                    ; ef/9d17
        .include "assets/world_gfx3.asm"                        ; ef/b631
        .include "assets/world_choco_gfx1.asm"                  ; ef/c624
        .include "assets/vector_approach_pal.asm"               ; ef/ce77
        .include "assets/world_esper_terra_pal.asm"             ; ef/ce97
        .include "assets/world_sprite_gfx1.asm"                 ; ef/ceb7
        .include "assets/world_sprite_gfx2.asm"                 ; ef/cfb9
        .include "assets/world_choco_gfx2.asm"                  ; ef/dc4c
        .include "assets/minimap_gfx1.asm"                      ; ef/e49b
        .include "assets/minimap_gfx2.asm"                      ; ef/e8b3
        .include "assets/airship_gfx2.asm"                      ; ef/ed26
        .include "assets/ending_airship_scene_pal.asm"          ; ef/fac8

; ------------------------------------------------------------------------------

.segment "world_sine"

        inc_lang "assets/world_sine_%s.asm"                     ; ef/fef0

; ------------------------------------------------------------------------------
