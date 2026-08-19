
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: battle/battle_main.asm                                               |
; |                                                                            |
; | description: battle program                                                |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "src/common/const.inc"
.include "src/common/hardware.inc"
.include "src/common/macros.inc"
.include "src/common/code_ext.inc"

.include "battle_common.inc"
.include "battle_ram.inc"

; ------------------------------------------------------------------------------

.include "ai_script.inc"
.include "src/sound/song_script.inc"
.include "src/gfx/battle_bg.inc"
.include "src/btlgfx/char_ai.inc"
.include "src/text/monster_name.inc"

.import CharProp, ItemProp

; ------------------------------------------------------------------------------

.segment "battle_code"
.a8
.i16

; ------------------------------------------------------------------------------

        .include "battle_ext.asm"
        .include "main.asm"
        .include "action_1.asm"
        .include "calc_dmg.asm"
        .include "equip.asm"
        .include "atb.asm"
        .include "cover.asm"
        .include "apply_dmg.asm"
        .include "battle_cmd.asm"
        .include "ai_cmd.asm"
        .include "main_2.asm"
        .include "check_hit.asm"
        .include "init.asm"
        .include "init_target.asm"
        .include "init_attacker.asm"
        .include "init_2.asm"
        .include "attack.asm"
        .include "target_effect.asm"
        .include "attacker_effect.asm"
        .include "status_effect.asm"
        .include "menu_effect.asm"
        .include "math.asm"
        .include "battle_end.asm"
        .include "rand.asm"
        .include "action_2.asm"
        .include "bit_math.asm"
        .include "party.asm"
        .include "init_gfx_params.asm"
        .include "init_skills.asm"
        .include "check_status.asm"
        .include "choose_target.asm"
        .include "timer.asm"
        .include "gfx_buf.asm"
        .include "win.asm"
        .include "main_3.asm"

; ------------------------------------------------------------------------------

        .include "ai_script.asm"

; ------------------------------------------------------------------------------
