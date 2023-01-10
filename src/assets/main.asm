
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
.include "assets/attack_anim_frames_en.inc"
.include "assets/attack_anim_prop.inc"
.include "assets/attack_anim_script.inc"
.include "assets/attack_anim_script_ptrs.inc"
.include "assets/attack_gfx_2bpp.inc"
.include "assets/attack_gfx_3bpp_en.inc"
.include "assets/attack_gfx_mode7.inc"
.include "assets/attack_gfx_prop_en.inc"
.include "assets/attack_msg_en.inc"
.include "assets/attack_name_en.inc"
.include "assets/attack_pal.inc"
.include "assets/attack_tiles_2bpp.inc"
.include "assets/attack_tiles_3bpp_en.inc"
.include "assets/attack_tiles_mode7.inc"
.include "assets/battle_bg_dance.inc"
.include "assets/battle_bg_gfx_en.inc"
.include "assets/battle_bg_pal.inc"
.include "assets/battle_bg_prop.inc"
.include "assets/battle_bg_tiles.inc"
.include "assets/battle_char_pal.inc"
.include "assets/battle_cmd_name_en.inc"
.include "assets/battle_cmd_prop.inc"
.include "assets/battle_dlg_en.inc"
.include "assets/battle_event_script.inc"
.include "assets/battle_event_script_ptrs.inc"
.include "assets/battle_font_pal.inc"
.include "assets/battle_magic_points.inc"
.include "assets/battle_monsters.inc"
.include "assets/battle_prop.inc"
.include "assets/blitz_code.inc"
.include "assets/blitz_desc_en.inc"
.include "assets/brr_sample.inc"
.include "assets/bushido_desc_en.inc"
.include "assets/bushido_name_en.inc"
.include "assets/char_ai.inc"
.include "assets/char_name_en.inc"
.include "assets/char_prop.inc"
.include "assets/colosseum_prop.inc"
.include "assets/cond_battle.inc"
.include "assets/credits_gfx1.inc"
.include "assets/dance_bg.inc"
.include "assets/dance_name_en.inc"
.include "assets/dance_prop.inc"
.include "assets/dlg1_en.inc"
.include "assets/dlg2_en.inc"
.include "assets/dte_table.inc"
.include "assets/ending_airship_scene_pal.inc"
.include "assets/ending_font_gfx.inc"
.include "assets/ending_gfx1.inc"
.include "assets/ending_gfx2.inc"
.include "assets/ending_gfx3.inc"
.include "assets/ending_gfx4.inc"
.include "assets/ending_gfx5.inc"
.include "assets/event_battle_group.inc"
.include "assets/event_script_en.inc"
.include "assets/event_trigger.inc"
.include "assets/floating_cont_gfx.inc"
.include "assets/font_gfx_debug.inc"
.include "assets/font_gfx_large_en.inc"
.include "assets/font_gfx_small_en.inc"
.include "assets/font_pal.inc"
.include "assets/font_width_en.inc"
.include "assets/genju_attack_desc_en.inc"
.include "assets/genju_attack_name_en.inc"
.include "assets/genju_bonus_desc_en.inc"
.include "assets/genju_bonus_name_en.inc"
.include "assets/genju_name_en.inc"
.include "assets/genju_order.inc"
.include "assets/genju_prop.inc"
.include "assets/imp_item.inc"
.include "assets/init_lore.inc"
.include "assets/init_npc_switch.inc"
.include "assets/init_rage.inc"
.include "assets/item_desc_en.inc"
.include "assets/item_jump_throw_anim.inc"
.include "assets/item_name_en.inc"
.include "assets/item_prop_en.inc"
.include "assets/item_type_name_en.inc"
.include "assets/level_up_exp.inc"
.include "assets/level_up_hp.inc"
.include "assets/level_up_mp_en.inc"
.include "assets/long_entrance.inc"
.include "assets/lore_desc_en.inc"
.include "assets/magic_desc_en.inc"
.include "assets/magic_name_en.inc"
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
.include "assets/map_gfx_en.inc"
.include "assets/map_init_event.inc"
.include "assets/map_pal.inc"
.include "assets/map_pal_anim_colors.inc"
.include "assets/map_pal_anim_prop.inc"
.include "assets/map_parallax.inc"
.include "assets/map_prop.inc"
.include "assets/map_sprite_gfx.inc"
.include "assets/map_sprite_pal.inc"
.include "assets/map_tile_prop.inc"
.include "assets/map_tileset_en.inc"
.include "assets/map_title_en.inc"
.include "assets/menu_pal.inc"
.include "assets/menu_sprite_gfx.inc"
.include "assets/metamorph_prop.inc"
.include "assets/minimap_gfx1.inc"
.include "assets/minimap_gfx2.inc"
.include "assets/monster_align.inc"
.include "assets/monster_attack_anim_prop.inc"
.include "assets/monster_control.inc"
.include "assets/monster_dlg_en.inc"
.include "assets/monster_gfx_en.inc"
.include "assets/monster_gfx_prop_en.inc"
.include "assets/monster_items.inc"
.include "assets/monster_name_en.inc"
.include "assets/monster_overlap.inc"
.include "assets/monster_pal.inc"
.include "assets/monster_prop.inc"
.include "assets/monster_rage.inc"
.include "assets/monster_sketch.inc"
.include "assets/monster_special_anim.inc"
.include "assets/monster_special_name_en.inc"
.include "assets/monster_stencil_large_en.inc"
.include "assets/monster_stencil_small_en.inc"
.include "assets/natural_magic.inc"
.include "assets/npc_prop.inc"
.include "assets/overlay_gfx.inc"
.include "assets/overlay_prop.inc"
.include "assets/overlay_tilemap.inc"
.include "assets/portrait_gfx.inc"
.include "assets/portrait_pal.inc"
.include "assets/rand_battle_group.inc"
.include "assets/rare_item_desc_en.inc"
.include "assets/rare_item_name_en.inc"
.include "assets/rng_tbl.inc"
.include "assets/ruin_cutscene_gfx.inc"
.include "assets/sample_adsr.inc"
.include "assets/sample_freq_mult.inc"
.include "assets/sample_loop_start.inc"
.include "assets/shop_prop.inc"
.include "assets/short_entrance.inc"
.include "assets/slot_gfx.inc"
.include "assets/snake_road_pal.inc"
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
.include "assets/title_opening_gfx_en.inc"
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
.include "assets/world_sine_en.inc"
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
        .include "dte_table.asm"                                ; c0/dfa0
.else
        DTETbl := *
.endif
        .include "init_npc_switch.asm"                          ; c0/e0a0
        .include "font_gfx_debug.asm"                           ; c0/e120
        .include "overlay_gfx.asm"                              ; c0/e2a0
        .res $0c00+OverlayGfx-*
        .include "overlay_tilemap.asm"                          ; c0/eea0
OverlayPropPtrs:                                                ; c0/f4a0
        make_ptr_tbl_rel OverlayProp, OVERLAY_PROP_ARRAY_LENGTH
        .res $60+OverlayPropPtrs-*
        .include "overlay_prop.asm"                             ; c0/f500
        .res $0800+OverlayProp-*
        .include "rng_tbl.asm"                                  ; c0/fd00
        .include "map_color_math.asm"                           ; c0/fe00
        .res $40+MapColorMath-*
        .include "map_parallax.asm"                             ; c0/fe40

; ------------------------------------------------------------------------------

.segment "event_triggers"

EventTriggerPtrs:                                               ; c4/0000
        make_ptr_tbl_rel EventTrigger, EVENT_TRIGGER_ARRAY_LENGTH, EventTriggerPtrs
        .addr EventTriggerEnd - EventTriggerPtrs
        .include "event_trigger.asm"                            ; c4/0342
        EventTriggerEnd := *
        .res $1a10+EventTriggerPtrs-*
NPCPropPtrs:                                                    ; c4/1a10
        make_ptr_tbl_rel NPCProp, NPC_PROP_ARRAY_LENGTH, NPCPropPtrs
        .addr NPCPropEnd - NPCPropPtrs
        .include "npc_prop.asm"                                 ; c4/1d52
        NPCPropEnd := *
        .res $50b0+NPCPropPtrs-*
        .include "magic_prop.asm"                               ; c4/6ac0
        inc_lang "char_name_%s.asm"                             ; c4/78c0
        .include "blitz_code.asm"                               ; c4/7a40
        .include "init_rage.asm"                                ; c4/7aa0

; ------------------------------------------------------------------------------

.segment "shop_prop"

        .include "shop_prop.asm"                                ; c4/7ac0
        .include "metamorph_prop.asm"                           ; c4/7f40

; ------------------------------------------------------------------------------

.segment "font_gfx"

        inc_lang "font_gfx_small_%s.asm"                        ; c4/7fc0
        inc_lang "font_width_%s.asm"                            ; c4/8fc0
        inc_lang "font_gfx_large_%s.asm"                        ; c4/90c0

; ------------------------------------------------------------------------------

.segment "ending_gfx"

        .include "ending_font_gfx.asm"                          ; c4/ba00
        .res $0608+EndingFontGfx-*
        .include "ending_gfx1.asm"                              ; c4/c008
        .res $346f+EndingGfx1-*
        .include "ending_gfx2.asm"                              ; c4/f477
        .res $0284+EndingGfx2-*
        .include "ending_gfx3.asm"                              ; c4/f6fb

; ------------------------------------------------------------------------------

.segment "sound_data"

.export NumSongs

        .include "spc_data.asm"                                 ; c5/070e
NumSongs:
        .byte   SONG_SCRIPT_ARRAY_LENGTH                        ; c5/3c5e

BRRSamplePtrs:                                                  ; c5/3c5f
        make_ptr_tbl_far BRRSample, BRR_SAMPLE_ARRAY_LENGTH, 0
        .include "sample_loop_start.asm"                        ; c5/3d1c
        .include "sample_freq_mult.asm"                         ; c5/3d9a
        .include "sample_adsr.asm"                              ; c5/3e18

SongScriptPtrs:                                                 ; c5/3e96
        make_ptr_tbl_far SongScript, SONG_SCRIPT_ARRAY_LENGTH, 0
        .include "song_samples.asm"                             ; c5/3f95
        .include "brr_sample.asm"                               ; c5/4a35
        .include "song_script.asm"                              ; c8/5c7a

; ------------------------------------------------------------------------------

.segment "the_end_gfx2"

        .include "the_end_gfx2.asm"                             ; c9/fe00
        .include "the_end_pal.asm"                              ; c9/ff00

; ------------------------------------------------------------------------------

.segment "event_script"

        inc_lang "event_script_%s.asm"                          ; ca/0000

; ------------------------------------------------------------------------------

.export DlgBankInc, DlgPtrs

.segment "dialogue_ptrs"

DlgBankInc:
        .word   DLG1_ARRAY_LENGTH                               ; cc/e600
DlgPtrs:
        make_ptr_tbl_rel Dlg1, DLG1_ARRAY_LENGTH                ; cc/e602
        make_ptr_tbl_rel Dlg2, DLG2_ARRAY_LENGTH, Dlg1+$10000

; ------------------------------------------------------------------------------

.segment "dialogue"

        inc_lang "dlg1_%s.asm"                                  ; cd/0000
        inc_lang "dlg2_%s.asm"

; ------------------------------------------------------------------------------

.if LANG_EN

.segment "map_title"

        inc_lang "map_title_%s.asm"                             ; ce/f100

.endif

; ------------------------------------------------------------------------------

.segment "world_mod"

        .include "world_mod_data.asm"                           ; ce/f600
        WorldModData_end := *
        .include "world_mod_tiles.asm"                          ; ce/f648
        .res $0500+WorldModData-*

; unused (30 * 3 bytes)
.if LANG_EN
        .faraddr 1,2,3,4,5,6,7,8,9,0,0,0,0,0,0                  ; ce/fb00
        .faraddr 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.endif

; ------------------------------------------------------------------------------

.segment "rare_item"

RareItemDescPtrs:                                               ; ce/fb60
        make_ptr_tbl_rel RareItemDesc, RARE_ITEM_DESC_ARRAY_LENGTH
        .res $40+RareItemDescPtrs-*
        inc_lang "rare_item_name_%s.asm"                        ; ce/fba0
        .res $0110+RareItemName-*
        inc_lang "rare_item_desc_%s.asm"                        ; ce/fcb0

; ------------------------------------------------------------------------------

.segment "battle_data"

        .include "monster_prop.asm"                             ; cf/0000
        .include "monster_items.asm"                            ; cf/3000
        .include "monster_overlap.asm"                          ; cf/3600
        .include "cond_battle.asm"                              ; cf/3780
        .include "monster_special_anim.asm"                     ; cf/37c0
        inc_lang "genju_attack_desc_%s.asm"                     ; cf/3940
        .res $0300+GenjuAttackDesc-*
        inc_lang "bushido_name_%s.asm"                          ; cf/3c40
        .res $c0+BushidoName-*
        .include "monster_control.asm"                          ; cf/3d00
        .include "monster_sketch.asm"                           ; cf/4300
        .include "monster_rage.asm"                             ; cf/4600
        .include "rand_battle_group.asm"                        ; cf/4800
        .include "event_battle_group.asm"                       ; cf/5000
        .include "world_battle_group.asm"                       ; cf/5400
        .include "sub_battle_group.asm"                         ; cf/5600
        .include "world_battle_rate.asm"                        ; cf/5800
        .include "sub_battle_rate.asm"                          ; cf/5880
        .include "battle_prop.asm"                              ; cf/5900
        .include "battle_monsters.asm"                          ; cf/6200
        .res $2200+BattleMonsters-*
        .include "ai_script_ptr.asm"                            ; cf/8400
        .include "ai_script.asm"                                ; cf/8700
        .res $3950+AIScript-*
        inc_lang "monster_name_%s.asm"                          ; cf/c050
        .res $1080+MonsterName-*
        inc_lang "monster_special_name_%s.asm"                  ; cf/d0d0
        .res $0f10+MonsterSpecialName-*
MonsterDlgPtrs:                                                 ; cf/dfe0
        make_ptr_tbl_rel MonsterDlg, MONSTER_DLG_ARRAY_LENGTH, .bankbyte(*)<<16
        inc_lang "monster_dlg_%s.asm"                           ; cf/e1e0

; ------------------------------------------------------------------------------

.segment "battle_data2"

        inc_lang "blitz_desc_%s.asm"                            ; cf/fc00
        .res $0100+BlitzDesc-*
        inc_lang "bushido_desc_%s.asm"                          ; cf/fd00
        .res $0100+BushidoDesc-*
        .include "battle_cmd_prop.asm"                          ; cf/fe00
GenjuAttackDescPtrs:                                            ; cf/fe40
        make_ptr_tbl_rel GenjuAttackDesc, GENJU_ATTACK_DESC_ARRAY_LENGTH, GenjuAttackDesc
        .include "dance_prop.asm"                               ; cf/fe80

; cf/fea0 desperation attacks for each character (unused)
        .byte   $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$ff,$fb,$ff
        inc_lang "genju_bonus_name_%s.asm"                      ; cf/feae
        .res $f0+GenjuBonusName-*
BlitzDescPtrs:                                                  ; cf/ff9e
        make_ptr_tbl_rel BlitzDesc, BLITZ_DESC_ARRAY_LENGTH, BlitzDesc
BushidoDescPtrs:                                                ; cf/ffae
        make_ptr_tbl_rel BushidoDesc, BUSHIDO_DESC_ARRAY_LENGTH, BushidoDesc

; ------------------------------------------------------------------------------

.segment "battle_event"

        .include "attack_anim_script.asm"                       ; d0/0000
        .include "attack_anim_prop.asm"                         ; d0/7fb2
        .res $9800+AttackAnimScript-*

        .include "battle_event_script_ptrs.asm"                 ; d0/9800
        .include "battle_event_script.asm"                      ; d0/9842
        .res $3800+BattleEventScriptPtrs-*

BattleDlgPtrs:
        make_ptr_tbl_abs BattleDlg, 256                         ; d0/d000
        inc_lang "battle_dlg_%s.asm"                            ; d0/d200
        .res $2d00+BattleDlgPtrs-*
        .include "char_ai.asm"                                  ; d0/fd00

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

        .include "item_jump_throw_anim.asm"                     ; d1/0040
        inc_lang "attack_anim_frames_%s.asm"                    ; d1/0141
        AttackAnimFramesEnd := *
        .res $ead8+ItemAnimPtrs-*

        .include "attack_anim_script_ptrs.asm"                  ; d1/ead8
        .res $f000+ItemAnimPtrs-*

        inc_lang "attack_msg_%s.asm"                            ; d1/f000
        .res $07a0+AttackMsg-*
AttackMsgPtrs:
        make_ptr_tbl_rel AttackMsg, 256, .bankbyte(*)<<16       ; d1/f7a0
        .res 11
        .include "dance_bg.asm"                                 ; d1/f9ab
        .byte   1,1
        .include "genju_order.asm"                              ; d1/f9b5

; ------------------------------------------------------------------------------

.segment "map_init_event"

        .include "map_init_event.asm"                           ; d1/fa00

; ------------------------------------------------------------------------------

.segment "battle_anim2"

        inc_lang "attack_tiles_3bpp_%s.asm"                     ; d2/0000
        .include "attack_pal.asm"                               ; d2/6000
        inc_lang "item_type_name_%s.asm"                        ; d2/6f00

; ------------------------------------------------------------------------------

.export MonsterStencil

.segment "monster_gfx_prop"

        inc_lang "monster_gfx_prop_%s.asm"                      ; d2/7000
        .include "monster_pal.asm"                              ; d2/7820

MonsterStencil:
        .addr   MonsterStencilSmall
        .addr   MonsterStencilLarge
        inc_lang "monster_stencil_small_%s.asm"                 ; d2/a824
        inc_lang "monster_stencil_large_%s.asm"                 ; d2/ac24

; ------------------------------------------------------------------------------

.segment "item_name"

        inc_lang "item_name_%s.asm"                             ; d2/b300

; ------------------------------------------------------------------------------

.segment "battle_anim3"

        .include "attack_tiles_2bpp.asm"                        ; d2/c000
        .include "status_gfx.asm"                               ; d2/e000

; ------------------------------------------------------------------------------

.segment "world_pal"

        .include "world_bg_pal1.asm"                            ; d2/ec00
        .include "world_bg_pal2.asm"                            ; d2/ed00
        .include "world_sprite_pal1.asm"                        ; d2/ee00
        .include "world_sprite_pal2.asm"                        ; d2/ef00

; ------------------------------------------------------------------------------

.segment "slot_gfx"

        .include "slot_gfx.asm"                                 ; d2/f000

; ------------------------------------------------------------------------------

.segment "attack_gfx_3bpp"

        inc_lang "attack_gfx_3bpp_%s.asm"                       ; d3/0000

; ------------------------------------------------------------------------------

.segment "battle_anim4"

        inc_lang "attack_gfx_prop_%s.asm"                       ; d4/d000

AttackAnimFramesPtrs:                                           ; d4/df3c
        make_ptr_tbl_rel AttackAnimFrames, 2948, .bankbyte(*)<<16
        .addr   AttackAnimFramesEnd

; ------------------------------------------------------------------------------

.segment "map_sprite_gfx"

; export map sprite graphics for battle
.repeat MAP_SPRITE_GFX_ARRAY_LENGTH, i
        .export .ident(.sprintf("MapSpriteGfx_%04x", i))
.endrep

        .include "map_sprite_gfx.asm"                           ; d5/0000
        .include "vehicle_gfx.asm"                              ; d8/3000

; ------------------------------------------------------------------------------

.segment "item_genju_prop"

        inc_lang "item_prop_%s.asm"                             ; d8/5000
        .include "genju_prop.asm"                               ; d8/6e00

; ------------------------------------------------------------------------------

.segment "attack_gfx_2bpp"

        .include "attack_gfx_2bpp.asm"                          ; d8/7000

; ------------------------------------------------------------------------------

.segment "magic_desc"

        inc_lang "magic_desc_%s.asm"                            ; d8/c9a0
        .res $0500+MagicDesc-*
        inc_lang "battle_cmd_name_%s.asm"                       ; d8/cea0
MagicDescPtrs:
        make_ptr_tbl_rel MagicDesc, 54                          ; d8/cf80

; ------------------------------------------------------------------------------

.segment "attack_gfx_mode7"

        .include "attack_gfx_mode7.asm"                         ; d8/d000
        .include "attack_tiles_mode7.asm"                       ; d8/daf2

; ------------------------------------------------------------------------------

.segment "cutscene_mode7"

        .include "magitek_train_tiles.asm"                      ; d8/dd00
        .include "vector_approach_gfx.asm"                      ; d8/dfb8
        .include "vector_approach_tiles.asm"                    ; d8/e5bf
        .include "snake_road_pal.asm"                           ; d8/e6ba

; ------------------------------------------------------------------------------

.segment "title_opening_gfx"

        inc_lang "title_opening_gfx_%s.asm"                     ; d8/f000
.if LANG_EN
        .res $24
.endif
        .include "floating_cont_gfx.asm"                        ; d9/4e96
        .res 3

; ------------------------------------------------------------------------------

.segment "credits_gfx"

        .include "credits_gfx1.asm"                             ; d9/568f
        .res $46bc+CreditsGfx1-*
        .include "ending_gfx4.asm"                              ; d9/9d4b
        .res $079a+EndingGfx4-*
        .include "ending_gfx5.asm"                              ; d9/a4e5

; ------------------------------------------------------------------------------

.segment "map_tile_data"

        .include "map_tile_prop.asm"                            ; d9/a800
        MapTileProp_end := *
        .res $2510+MapTileProp-*
MapTilePropPtrs:
        make_ptr_tbl_rel MapTileProp, 42                        ; d9/cd10
        .addr MapTileProp_end - MapTileProp
        .res $80+MapTilePropPtrs-*
SubTilemapPtrs:
        make_ptr_tbl_far SubTilemap, 350                        ; d9/cd90
        .faraddr SubTilemap_end - SubTilemap
        .res $420+SubTilemapPtrs-*
        .include "sub_tilemap.asm"                              ; d9/d1b0
        SubTilemap_end := *

; ------------------------------------------------------------------------------

.segment "map_tile_data2"

        inc_lang "map_tileset_%s.asm"                           ; de/0000
        MapTileset_end := *
        .res $01b400+MapTileset-*
        .include "battle_magic_points.asm"                      ; df/b400
        .include "colosseum_prop.asm"                           ; df/b600
MapTilesetPtrs:
        make_ptr_tbl_far MapTileset, 75                         ; df/ba00
        .faraddr MapTileset_end - MapTileset
        .res $0100+MapTilesetPtrs-*
ShortEntrancePtrs:
        make_ptr_tbl_rel ShortEntrance, 512, ShortEntrancePtrs  ; df/bb00
        .addr ShortEntrance_end - ShortEntrancePtrs
        .include "short_entrance.asm"                           ; df/bf02
        ShortEntrance_end := *

; ------------------------------------------------------------------------------

.segment "map_gfx"

MapGfxPtrs:
        make_ptr_tbl_far MapGfx, 82                             ; df/da00
        .res $0100+MapGfxPtrs-*
        inc_lang "map_gfx_%s.asm"                               ; df/db00

; ------------------------------------------------------------------------------

.export BlitzLevelTbl, BushidoLevelTbl

.segment "map_gfx2"

        .include "map_anim_gfx.asm"                             ; e6/0000
        .include "map_sprite_pal.asm"                           ; e6/8000
MapTitlePtrs:
        make_ptr_tbl_rel MapTitle, 73                           ; e6/8400
.if !LANG_EN
        inc_lang "map_title_%s.asm"                             ; e6/84c0
.endif
        .res $0380+MapTitlePtrs-*
        .include "map_gfx_bg3.asm"                              ; e6/8780
        MapGfxBG3End := *
        .res $45E0+MapGfxBG3-*
MapGfxBG3Ptrs:
        make_ptr_tbl_far MapGfxBG3, 18                          ; e6/cd60
        .faraddr MapGfxBG3End-MapGfxBG3
        .res $40+MapGfxBG3Ptrs-*
MapAnimGfxBG3Ptrs:
        make_ptr_tbl_far MapAnimGfxBG3, 6                       ; e6/cda0
        .faraddr MapAnimGfxBG3End-MapAnimGfxBG3
        .res $20+MapAnimGfxBG3Ptrs-*
        .include "map_anim_gfx_bg3.asm"                         ; e6/cdc0
        MapAnimGfxBG3End := *
        .res $2440+MapAnimGfxBG3-*
        .include "map_pal_anim_colors.asm"                      ; e6/f200
        .res $0290+MapPalAnimColors-*
BushidoLevelTbl:
        .byte   1,6,12,15,24,34,44,70                           ; e6/f490
BlitzLevelTbl:
        .byte   1,6,10,15,23,30,42,70                           ; e6/f498
        .include "level_up_hp.asm"                              ; e6/f4a0
        inc_lang "level_up_mp_%s.asm"                           ; e6/f502
        .include "init_lore.asm"                                ; e6/f564
        inc_lang "magic_name_%s.asm"                            ; e6/f567
        inc_lang "genju_name_%s.asm"                            ; e6/f6e1
        inc_lang "attack_name_%s.asm"                           ; e6/f7b9
        inc_lang "genju_attack_name_%s.asm"                     ; e6/fe8f
        inc_lang "dance_name_%s.asm"                            ; e6/ff9d

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

        .include "battle_bg_prop.asm"                           ; e7/0000
        .include "battle_bg_pal.asm"                            ; e7/0150

BattleBGGfxPtrs:
        make_ptr_tbl_far BattleBGGfx, 75, 0                     ; e7/1650
        .res $0117, 0

BattleBGTilesPtrs:
        make_ptr_tbl_rel BattleBGTiles, 112, .bankbyte(*)<<16   ; e7/1848

        .include "battle_bg_tiles.asm"                          ; e7/1928
        inc_lang "battle_bg_gfx_%s.asm"                         ; e7/a9e7

; ------------------------------------------------------------------------------

.segment "the_end_gfx1"
        .include "the_end_gfx1.asm"                             ; e9/6300

; ------------------------------------------------------------------------------

.segment "monster_gfx"

        inc_lang "monster_gfx_%s.asm"                           ; e9/7000

; ------------------------------------------------------------------------------

.segment "weapon_anim"

        .include "weapon_anim_prop.asm"                         ; ec/e400
        .include "monster_attack_anim_prop.asm"                 ; ec/e6e8
        .include "monster_align.asm"                            ; ec/e800

; ------------------------------------------------------------------------------

.segment "ruin_cutscene_gfx"

        .include "ruin_cutscene_gfx.asm"                        ; ec/e900

; ------------------------------------------------------------------------------

.export NaturalMagic_0000, NaturalMagic_0001

.segment "natural_magic"

        .include "natural_magic.asm"                            ; ec/e3c0

; ------------------------------------------------------------------------------

.repeat PORTRAIT_GFX_ARRAY_LENGTH, i
        .export .ident(.sprintf("PortraitGfx_%04x", i))
.endrep

.repeat WINDOW_GFX_ARRAY_LENGTH, i
        .export .ident(.sprintf("WindowGfx_%04x", i))
.endrep

.segment "menu_gfx"

        .include "window_gfx.asm"                               ; ed/0000
        .include "window_pal.asm"                               ; ed/1c00
        .include "portrait_gfx.asm"                             ; ed/1d00
        .include "portrait_pal.asm"                             ; ed/5860
        .include "menu_sprite_gfx.asm"                          ; ed/5ac0
        .include "battle_font_pal.asm"                          ; ed/62c0
        .include "battle_char_pal.asm"                          ; ed/6300
        .res 32

; ------------------------------------------------------------------------------

        inc_lang "item_desc_%s.asm"                             ; ed/6400
        .res $13a0+ItemDesc-*
        inc_lang "lore_desc_%s.asm"                             ; ed/77a0
        .res $02d0+LoreDesc-*
LoreDescPtrs:                                                   ; ed/7a70
        make_ptr_tbl_rel LoreDesc, LORE_DESC_ARRAY_LENGTH
ItemDescPtrs:                                                   ; ed/7aa0
        make_ptr_tbl_rel ItemDesc, ITEM_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "genju_bonus_desc"

        inc_lang "genju_bonus_desc_%s.asm"                      ; ed/fe00
        .res $01d0+GenjuBonusDesc-*
GenjuBonusDescPtrs:                                             ; ed/ffd0
        make_ptr_tbl_rel GenjuBonusDesc, GENJU_BONUS_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "char_prop"

        .include "char_prop.asm"                                ; ed/7ca0
        .include "level_up_exp.asm"                             ; ed/8220

; ------------------------------------------------------------------------------

.segment "treasure_prop"

        .include "imp_item.asm"                                 ; ed/82e4
TreasurePropPtrs:
        make_ptr_tbl_rel TreasureProp, 415                      ; ed/82f4
        .addr TreasurePropEnd - TreasureProp
        .include "treasure_prop.asm"                            ; ed/8634
        TreasurePropEnd := *

; ------------------------------------------------------------------------------

.segment "battle_bg_dance"

        .include "battle_bg_dance.asm"                          ; ed/8e5b

; ------------------------------------------------------------------------------

.segment "map_data"

        .include "map_prop.asm"                                 ; ed/8f00
        .res 1
        .include "map_pal.asm"                                  ; ed/c480
LongEntrancePtrs:
        make_ptr_tbl_rel LongEntrance, 512, LongEntrancePtrs    ; ed/f480
        .addr LongEntranceEnd - LongEntrancePtrs
        .include "long_entrance.asm"                            ; ed/f882
        LongEntranceEnd := *

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

WorldModDataPtrs:
        make_ptr_tbl_far WorldModData, 2, 0                     ; ee/b260
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

        .include "world_backdrop_gfx.asm"                       ; ee/b290
        .include "world_backdrop_tiles.asm"                     ; ee/c295
        .include "airship_gfx1.asm"                             ; ee/c702
        .include "world_tilemap1.asm"                           ; ee/d434
        .include "world_gfx1.asm"                               ; ef/114f
        .include "magitek_train_gfx.asm"                        ; ef/3250
        .include "magitek_train_pal.asm"                        ; ef/4846
        .include "world_gfx2.asm"                               ; ef/4a46
        .include "world_tilemap2.asm"                           ; ef/6a56
        .include "world_tilemap3.asm"                           ; ef/9d17
        .include "world_gfx3.asm"                               ; ef/b631
        .include "world_choco_gfx1.asm"                         ; ef/c624
        .include "vector_approach_pal.asm"                      ; ef/ce77
        .include "world_esper_terra_pal.asm"                    ; ef/ce97
        .include "world_sprite_gfx1.asm"                        ; ef/ceb7
        .include "world_sprite_gfx2.asm"                        ; ef/cfb9
        .include "world_choco_gfx2.asm"                         ; ef/dc4c
        .include "minimap_gfx1.asm"                             ; ef/e49b
        .include "minimap_gfx2.asm"                             ; ef/e8b3
        .include "airship_gfx2.asm"                             ; ef/ed26
        .include "ending_airship_scene_pal.asm"                 ; ef/fac8

; ------------------------------------------------------------------------------

.segment "world_sine"

        inc_lang "world_sine_%s.asm"                            ; ef/fef0

; ------------------------------------------------------------------------------
