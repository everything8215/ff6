
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/main.asm                                                       |
; |                                                                            |
; | description: world map program                                             |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"
.include "code_ext.inc"

; ------------------------------------------------------------------------------

.include "field/event_trigger.inc"
.include "field/short_entrance.inc"
.include "gfx/world_gfx.inc"

; ------------------------------------------------------------------------------

.segment "world_code"
.include "world_ext.asm"
.include "world_main.asm"
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

; .segment "world_data"
.include "world_data.asm"

; ------------------------------------------------------------------------------
