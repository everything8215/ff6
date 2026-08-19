
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: btlgfx/btlgfx_main.asm                                               |
; |                                                                            |
; | description: battle graphics program                                       |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "src/common/const.inc"
.include "src/common/hardware.inc"
.include "src/common/macros.inc"
.include "src/common/code_ext.inc"

.include "src/battle/battle_common.inc"
.include "btlgfx_ram.inc"

; ------------------------------------------------------------------------------

.include "src/gfx/battle_bg.inc"
.include "src/sound/song_script.inc"

.include "src/text/bushido_name.inc"
.include "src/text/genju_attack_name.inc"

; ------------------------------------------------------------------------------

.import AttackPal, BattleCharPal
.import RNGTbl

; ------------------------------------------------------------------------------

        .a8
        .i16

.segment "btlgfx_code"

        .include "main.asm"
        .include "interrupt.asm"
        .include "init.asm"
        .include "sfx.asm"
        .include "math.asm"
        .include "vram.asm"
        .include "decimal.asm"
        .include "ctrl.asm"
        .include "mask.asm"
        .include "battle_bg.asm"
        .include "monster_gfx.asm"
        .include "sprite.asm"
        .include "menu.asm"
        .include "vector.asm"
        .include "cursor.asm"
        .include "gfx_cmd.asm"
        .include "cursor_sprite.asm"
        .include "anim_cmd.asm"
        .include "event.asm"

; ------------------------------------------------------------------------------

.segment "btlgfx_code_far"

        .include "cursor_2.asm"
        .include "kefka_death.asm"
        .include "menu_3.asm"
        .include "anim_cmd_2.asm"
        .include "battle_bg_2.asm"
        .include "anim_cmd_3.asm"
        .include "train_gfx.asm"
        .include "cursor_mem.asm"
        .include "init_2.asm"
        .include "event_2.asm"
        .include "menu_2.asm"
        .include "anim_init_2.asm"
        .include "char_ai.asm"
        .include "condemn.asm"
        .include "event_anim.asm"
        .include "sprite_data.asm"
        .include "interrupt_2.asm"
        .include "mask_2.asm"
        .include "menu_data.asm"
        .include "sprite_data_2.asm"
        .include "kefka_death_2.asm"
        .include "monster_anim.asm"
        .include "anim_init.asm"

; ------------------------------------------------------------------------------

.segment "decompress_code"

        .include "sine_tbl.asm"
        .include "decomp.asm"

; ------------------------------------------------------------------------------
