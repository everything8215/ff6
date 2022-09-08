
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
.export ItemName, FontGfxSmall
.export ShortEntrancePtrs, EventTriggerPtrs
.export CharProp, LevelUpExp, BushidoLevelTbl, BlitzLevelTbl

; ------------------------------------------------------------------------------

.segment "field_data"

; c0/dfa0
        .include "data/dte_table.asm"

; c0/e0a0
        .include "data/init_npc_switch.asm"

; c0/e120
        .res $0180

; c0/e2a0
        .include "gfx/overlay_gfx.asm"
        .res $0c00+OverlayGfx-*

; c0/eea0
        .include "data/overlay_tilemap.asm"

; c0/f4a0
OverlayPropPtrs:
        make_ptr_tbl_rel OverlayProp, 45
        .res $60+OverlayPropPtrs-*

; c0/f500
        .include "data/overlay_prop.asm"
        .res $0800+OverlayProp-*

; c0/fd00
        .include "data/rng_tbl.asm"

; c0/fe00
        .include "data/map_color_math.asm"
        .res $40+MapColorMath-*

; c0/fe40
        .include "data/map_parallax.asm"

; ------------------------------------------------------------------------------

.segment "event_triggers"

; c4/0000
EventTriggerPtrs:
        make_ptr_tbl_rel EventTrigger, 416, EventTriggerPtrs
        .addr EventTriggerEnd - EventTrigger

; c4/0342
        .include "data/event_trigger.asm"
        EventTriggerEnd := *
        .res $1a10+EventTriggerPtrs-*

; c4/1a10
NPCPropPtrs:
        make_ptr_tbl_rel NPCProp, 416, NPCPropPtrs
        .addr NPCPropEnd - NPCProp

; c4/1d52
        .include "data/npc_prop.asm"
        NPCPropEnd := *
        .res $50b0+NPCPropPtrs-*

; c4/6ac0
        .res $0e00

; c4/78c0
        .include "text/char_name_en.asm"

; ------------------------------------------------------------------------------

.segment "font_gfx"

; c4/7fc0
        .include "gfx/font_gfx_small.asm"

; c4/8fc0
        .include "data/font_width.asm"

; c4/90c0
        .include "gfx/font_gfx_large.asm"

; ------------------------------------------------------------------------------

.segment "event_script"

; ca/0000
        .include "data/event_script.asm"

; ------------------------------------------------------------------------------

.segment "dialogue_ptrs"

; cc/e600
DlgBankInc:
        .word   $0626

; cc/e602
DlgPtrs:
        make_ptr_tbl_rel Dlg1, 1574
        make_ptr_tbl_rel Dlg2, 1510, Dlg1+$10000

; ------------------------------------------------------------------------------

.segment "dialogue"

; cd/0000
        .include "text/dlg1.asm"
        .include "text/dlg2.asm"
        .res $01f100+Dlg1-*

; ce/f100
        .include "text/map_title_en.asm"

; ------------------------------------------------------------------------------

.segment "map_init_event"

; d1/fa00
        .include "data/map_init_event.asm"

; ------------------------------------------------------------------------------

.segment "item_name"

; d2/b300
        .include "text/item_name_en.asm"

; ------------------------------------------------------------------------------

.segment "map_sprite_gfx"

; d5/0000
        .include "gfx/map_sprite_gfx.asm"

; d8/3000
        .include "gfx/map_vehicle_gfx.asm"

; ------------------------------------------------------------------------------

.segment "map_tile_data"

; d9/a800
        .include "data/map_tile_prop.asm"
        MapTilePropEnd := *
        .res $2510+MapTileProp-*

; d9/cd10
MapTilePropPtrs:
        make_ptr_tbl_rel MapTileProp, 42
        .addr MapTilePropEnd - MapTileProp
        .res $80+MapTilePropPtrs-*

; d9/cd90
SubTilemapPtrs:
        make_ptr_tbl_far SubTilemap, 350
        .faraddr SubTilemapEnd - SubTilemap
        .res $420+SubTilemapPtrs-*

; d9/d1b0
        .include "data/sub_tilemap.asm"
        SubTilemapEnd := *

; ------------------------------------------------------------------------------

.segment "map_tile_data2"

; de/0000
        .include "data/map_tileset.asm"
        .res $01b400+MapTileset-*

; df/b400
        .res $0200

; df/b600
        .res $0400

; df/ba00
MapTilesetPtrs:
        make_ptr_tbl_far MapTileset, 75
        .res $0100+MapTilesetPtrs-*

; df/bb00
ShortEntrancePtrs:
        make_ptr_tbl_rel ShortEntrance, 416, ShortEntrancePtrs
        .addr ShortEntranceEnd - ShortEntrancePtrs

; df/bf02
        .include "data/short_entrance.asm"
        ShortEntranceEnd := *

; ------------------------------------------------------------------------------

.segment "map_gfx"

; df/da00
MapGfxPtrs:
        make_ptr_tbl_far MapGfx, 82
        .res $0100+MapGfxPtrs-*

; df/db00
        .include "gfx/map_gfx.asm"

; ------------------------------------------------------------------------------

.segment "map_gfx2"

; e6/0000
        .include "gfx/map_anim_gfx.asm"

; e6/8000
        .include "gfx/map_sprite_pal.asm"

; e6/8400
MapTitlePtrs:
        make_ptr_tbl_rel MapTitle, 73
        .res $0380+MapTitlePtrs-*

; e6/8780
        .include "gfx/map_gfx_bg3.asm"
        MapGfxBG3End := *
        .res $45E0+MapGfxBG3-*

; e6/cd60
MapGfxBG3Ptrs:
        make_ptr_tbl_far MapGfxBG3, 18
        .faraddr MapGfxBG3End-MapGfxBG3
        .res $40+MapGfxBG3Ptrs-*

; e6/cda0
MapAnimGfxBG3Ptrs:
        make_ptr_tbl_far MapAnimGfxBG3, 6
        .faraddr MapAnimGfxBG3End-MapAnimGfxBG3
        .res $20+MapAnimGfxBG3Ptrs-*

; e6/cdc0
        .include "gfx/map_anim_gfx_bg3.asm"
        MapAnimGfxBG3End := *
        .res $2440+MapAnimGfxBG3-*

; e6/f200
        .include "gfx/map_pal_anim_colors.asm"
        .res $0290+MapPalAnimColors-*

; e6/f490
BushidoLevelTbl:
        .byte   1,6,12,15,24,34,44,70

; e6/f498
BlitzLevelTbl:
        .byte   1,6,10,15,23,30,42,70

; e6/f4a0
        .include "data/level_up_hp.asm"

; e6/f502
        .include "data/level_up_mp.asm"

; ------------------------------------------------------------------------------

.segment "char_prop"

; ed/7ca0
        .include "data/char_prop.asm"

; ed/8220
        .include "data/level_up_exp.asm"

; ------------------------------------------------------------------------------

.segment "treasure_prop"

; ed/82f4
TreasurePropPtrs:
        make_ptr_tbl_rel TreasureProp, 415
        .addr TreasurePropEnd - TreasurePropPtrs

; ed/8634
        .include "data/treasure_prop.asm"
        TreasurePropEnd := *

; ------------------------------------------------------------------------------

.segment "map_data"

; ed/8f00
        .include "data/map_prop.asm"
        .res 1

; ed/c480
        .include "gfx/map_pal.asm"

; ed/f480
LongEntrancePtrs:
        make_ptr_tbl_rel LongEntrance, 416, LongEntrancePtrs
        .addr LongEntranceEnd - LongEntrancePtrs

; ed/f882
        .include "data/long_entrance.asm"
        LongEntranceEnd := *

; ------------------------------------------------------------------------------
