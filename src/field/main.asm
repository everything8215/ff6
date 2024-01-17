
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: field/main.asm                                                       |
; |                                                                            |
; | description: field program                                                 |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"
.include "code_ext.inc"

; ------------------------------------------------------------------------------

.include "field_ext.asm"
.include "field_main.asm"
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
.include "map_tile_prop.asm"
.include "map_tileset.asm"
.include "sub_tilemap.asm"

; ------------------------------------------------------------------------------

