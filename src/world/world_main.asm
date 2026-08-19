
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/world_main.asm                                                 |
; |                                                                            |
; | description: world map program                                             |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "src/common/const.inc"
.include "src/common/hardware.inc"
.include "src/common/macros.inc"
.include "src/common/code_ext.inc"

; ------------------------------------------------------------------------------

.include "src/field/short_entrance.inc"
.include "src/gfx/world_gfx.inc"

.scope EventScript
        .import NoEvent, PartyDefeated
        .import AirshipDeck, WorldTent
        .import AirshipGround, EnterPhoenixCave
        .import EnterKefkasTower, EnterGogosLair
        .import DoomGazeDefeated
.endscope

; ------------------------------------------------------------------------------

        .segment "world_code"
        .include "world_ext.asm"
        .include "world_start.asm"
        .include "cutscene.asm"
        .include "move.asm"
        .include "fade.asm"
        .include "train_script.asm"
        .include "tilemap.asm"
        .include "rotate.asm"
        .include "tfr_gfx.asm"
        .include "sprite.asm"
        .include "world_anim.asm"
        .include "ctrl.asm"
        .include "event.asm"
        .include "init.asm"
        .include "liftoff.asm"
        .include "train_init.asm"
        .include "fix_minimap.asm"
        .include "tile_prop.asm"
        .include "train_update.asm"
        .include "decompress.asm"
        .include "interrupt.asm"
        .include "ppu.asm"

        .include "world_mod.asm"
        .include "world_data.asm"

; ------------------------------------------------------------------------------
