
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: field_data.asm                                                       |
; |                                                                            |
; | description: data for field module                                         |
; |                                                                            |
; | created: 8/9/2022                                                          |
; +----------------------------------------------------------------------------+

.export RNGTbl
.export MapGfxPtrs, MapGfx, VehicleGfx
.export MagicProp, ItemName, FontGfxSmall, FontWidth, FontGfxLarge
.export ShortEntrancePtrs, EventTriggerPtrs
.export CharProp, LevelUpExp, BushidoLevelTbl, BlitzLevelTbl, BlitzCode
.export MagicName, AttackName, GenjuName, GenjuAttackName, DanceName
.export BattleMagicPoints, ColosseumProp

.repeat 82, i
      .export .ident(.sprintf("MapGfx_%04x", i))
.endrep

; ------------------------------------------------------------------------------

.segment "field_data"

        .include "data/dte_table.asm"                           ; c0/dfa0
        .include "data/init_npc_switch.asm"                     ; c0/e0a0
        .include "gfx/font_gfx_debug.asm"                       ; c0/e120
        .include "gfx/overlay_gfx.asm"                          ; c0/e2a0
        .res $0c00+OverlayGfx-*
        .include "data/overlay_tilemap.asm"                     ; c0/eea0
OverlayPropPtrs:
        make_ptr_tbl_rel OverlayProp, 45                        ; c0/f4a0
        .res $60+OverlayPropPtrs-*
        .include "data/overlay_prop.asm"                        ; c0/f500
        .res $0800+OverlayProp-*
        .include "data/rng_tbl.asm"                             ; c0/fd00
        .include "data/map_color_math.asm"                      ; c0/fe00
        .res $40+MapColorMath-*
        .include "data/map_parallax.asm"                        ; c0/fe40

; ------------------------------------------------------------------------------

.segment "event_triggers"

EventTriggerPtrs:
        make_ptr_tbl_rel EventTrigger, 416, EventTriggerPtrs    ; c4/0000
        .addr EventTriggerEnd - EventTriggerPtrs
        .include "data/event_trigger.asm"                       ; c4/0342
        EventTriggerEnd := *
        .res $1a10+EventTriggerPtrs-*
NPCPropPtrs:
        make_ptr_tbl_rel NPCProp, 416, NPCPropPtrs              ; c4/1a10
        .addr NPCPropEnd - NPCPropPtrs
        .include "data/npc_prop.asm"                            ; c4/1d52
        NPCPropEnd := *
        .res $50b0+NPCPropPtrs-*
        .include "data/magic_prop.asm"                          ; c4/6ac0
        .include "text/char_name_en.asm"                        ; c4/78c0
        .include "data/blitz_code.asm"                          ; c4/7a40
        .include "data/init_riot.asm"                           ; c4/7aa0

; ------------------------------------------------------------------------------

.segment "font_gfx"

        .include "gfx/font_gfx_small.asm"                       ; c4/7fc0
        .include "data/font_width.asm"                          ; c4/8fc0
        .include "gfx/font_gfx_large.asm"                       ; c4/90c0

; ------------------------------------------------------------------------------

.segment "event_script"

        .include "data/event_script.asm"                        ; ca/0000

; ------------------------------------------------------------------------------

.segment "dialogue_ptrs"

DlgBankInc:
        .word   $0626                                           ; cc/e600
DlgPtrs:
        make_ptr_tbl_rel Dlg1, 1574                             ; cc/e602
        make_ptr_tbl_rel Dlg2, 1510, Dlg1+$10000

; ------------------------------------------------------------------------------

.segment "dialogue"

        .include "text/dlg1.asm"                                ; cd/0000
        .include "text/dlg2.asm"
        .res $01f100+Dlg1-*
        .include "text/map_title_en.asm"                        ; ce/f100

; ------------------------------------------------------------------------------

.segment "map_init_event"

        .include "data/map_init_event.asm"                      ; d1/fa00

; ------------------------------------------------------------------------------

.segment "item_name"

        .include "text/item_name_en.asm"                        ; d2/b300

; ------------------------------------------------------------------------------

.segment "map_sprite_gfx"

; export map sprite graphics for battle
.repeat 23, i
        .export .ident(.sprintf("MapSpriteGfx_%04x", i))
.endrep

        .include "gfx/map_sprite_gfx.asm"                       ; d5/0000
        .include "gfx/vehicle_gfx.asm"                          ; d8/3000

; ------------------------------------------------------------------------------

.segment "map_tile_data"

        .include "data/map_tile_prop.asm"                       ; d9/a800
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
        .include "data/sub_tilemap.asm"                         ; d9/d1b0
        SubTilemap_end := *

; ------------------------------------------------------------------------------

.segment "map_tile_data2"

        .include "data/map_tileset.asm"                         ; de/0000
        MapTileset_end := *
        .res $01b400+MapTileset-*
        .include "data/battle_magic_points.asm"                 ; df/b400
        .include "data/colosseum_prop.asm"                      ; df/b600
MapTilesetPtrs:
        make_ptr_tbl_far MapTileset, 75                         ; df/ba00
        .faraddr MapTileset_end - MapTileset
        .res $0100+MapTilesetPtrs-*
ShortEntrancePtrs:
        make_ptr_tbl_rel ShortEntrance, 512, ShortEntrancePtrs  ; df/bb00
        .addr ShortEntrance_end - ShortEntrancePtrs
        .include "data/short_entrance.asm"                      ; df/bf02
        ShortEntrance_end := *

; ------------------------------------------------------------------------------

.segment "map_gfx"

MapGfxPtrs:
        make_ptr_tbl_far MapGfx, 82                             ; df/da00
        .res $0100+MapGfxPtrs-*
        .include "gfx/map_gfx.asm"                              ; df/db00

; ------------------------------------------------------------------------------

.segment "map_gfx2"

        .include "gfx/map_anim_gfx.asm"                         ; e6/0000
        .include "gfx/map_sprite_pal.asm"                       ; e6/8000
MapTitlePtrs:
        make_ptr_tbl_rel MapTitle, 73                           ; e6/8400
        .res $0380+MapTitlePtrs-*
        .include "gfx/map_gfx_bg3.asm"                          ; e6/8780
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
        .include "gfx/map_anim_gfx_bg3.asm"                     ; e6/cdc0
        MapAnimGfxBG3End := *
        .res $2440+MapAnimGfxBG3-*
        .include "gfx/map_pal_anim_colors.asm"                  ; e6/f200
        .res $0290+MapPalAnimColors-*
BushidoLevelTbl:
        .byte   1,6,12,15,24,34,44,70                           ; e6/f490
BlitzLevelTbl:
        .byte   1,6,10,15,23,30,42,70                           ; e6/f498
        .include "data/level_up_hp.asm"                         ; e6/f4a0
        .include "data/level_up_mp.asm"                         ; e6/f502
        .include "data/init_lore.asm"                           ; e6/f564
        .include "text/magic_name.asm"                          ; e6/f567
        .include "text/genju_name.asm"                          ; e6/f6e1
        .include "text/attack_name.asm"                         ; e6/f7b9
        .include "text/genju_attack_name.asm"                   ; e6/fe8f
        .include "text/dance_name.asm"                          ; e6/ff9d

; ------------------------------------------------------------------------------

.segment "natural_magic"

        .include "data/natural_magic.asm"                       ; ec/e3c0

; ------------------------------------------------------------------------------

.segment "char_prop"

        .include "data/char_prop.asm"                           ; ed/7ca0
        .include "data/level_up_exp.asm"                        ; ed/8220

; ------------------------------------------------------------------------------

.export ImpItem

.segment "treasure_prop"

        .include "data/imp_item.asm"                           ; ed/82e4
TreasurePropPtrs:
        make_ptr_tbl_rel TreasureProp, 415                      ; ed/82f4
        .addr TreasurePropEnd - TreasureProp
        .include "data/treasure_prop.asm"                       ; ed/8634
        TreasurePropEnd := *

; ------------------------------------------------------------------------------

.segment "map_data"

        .include "data/map_prop.asm"                            ; ed/8f00
        .res 1
        .include "gfx/map_pal.asm"                              ; ed/c480
LongEntrancePtrs:
        make_ptr_tbl_rel LongEntrance, 512, LongEntrancePtrs    ; ed/f480
        .addr LongEntranceEnd - LongEntrancePtrs
        .include "data/long_entrance.asm"                       ; ed/f882
        LongEntranceEnd := *

; ------------------------------------------------------------------------------
