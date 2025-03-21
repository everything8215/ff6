
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: menu.asm                                                             |
; |                                                                            |
; | description: menu program                                                  |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"
.include "code_ext.inc"

.include "menu_ram.inc"
inc_lang "menu_text_%s.inc.raw"

; ------------------------------------------------------------------------------

.a8
.i16

.include "ending_anim.asm"
.include "menu_anim.asm"
.include "genju_prop.asm"

.include "menu_ext.asm"
.include "menu_common.asm"
.include "save.asm"
.include "field_menu.asm"
.include "config.asm"
.include "skills.asm"
.include "status.asm"
.include "name_change.asm"
.include "menu_init.asm"
.include "menu_gfx.asm"
.include "menu_sram.asm"
.include "party.asm"
.include "menu_misc.asm"
.include "item.asm"
.include "equip.asm"
.include "ctrl.asm"
.include "big_text.asm"
.include "final_order.asm"
.include "colosseum.asm"
.include "bushido_name.asm"
.include "shop.asm"
.include "ending.asm"
.include "menu_init_2.asm"
