
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: field/field_main.asm                                                 |
; |                                                                            |
; | description: field program                                                 |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "src/common/const.inc"
.include "src/common/hardware.inc"
.include "src/common/macros.inc"
.include "src/common/code_ext.inc"
.include "src/menu/menu_const.inc"

.scope EventScript
        .import RandBattle, GameStart
        .import WaitDlg
        .import Tent, Warp
        .import NoEvent
        .import TreasureItem, TreasureMagic
        .import TreasureGil, TreasureEmpty
        .import TreasureMonster

        .if ::DEBUG
        .import DebugEvent
        .endif
.endscope

; ------------------------------------------------------------------------------

.include "field_ext.asm"
.include "reset.asm"
.include "screen.asm"
.include "dma.asm"
.include "color.asm"
.include "scroll.asm"
.include "entrance.asm"
.include "map.asm"
.include "window.asm"
.include "hdma.asm"
.include "player.asm"
.include "obj.asm"
.include "text.asm"
.include "anim.asm"
.include "event.asm"
.include "init.asm"
.include "battle.asm"
.include "menu.asm"
.include "overlay.asm"
.include "sprite_data.asm"
.include "debug.asm"
.include "rng_tbl.asm"
.include "header.asm"

.include "char_prop.asm"
.include "init_npc_switch.asm"
.include "map_tile_prop.asm"
.include "map_tileset.asm"
.include "sub_tilemap.asm"

; ------------------------------------------------------------------------------

