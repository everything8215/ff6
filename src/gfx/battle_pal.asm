; ------------------------------------------------------------------------------

.export BattleFontPal, BattleCharPal

; ------------------------------------------------------------------------------

.segment "battle_pal"

; ed/62c0
BattleFontPal:

; loaded to bg3 palette 0, 1, 2, 3
        .incbin "assets/gfx/battle_font_pal/pal_0000.pal"
        .incbin "assets/gfx/battle_font_pal/pal_0001.pal"
        .incbin "assets/gfx/battle_font_pal/pal_0002.pal"
        .incbin "assets/gfx/battle_font_pal/pal_0003.pal"

; unused (bg3 palette 4 is used for dialog text and animations)
        .incbin "assets/gfx/battle_font_pal/pal_0004.pal"

; loaded to bg3 palette 5, 6, 7 (also used for slot icons)
        .incbin "assets/gfx/battle_font_pal/pal_0005.pal"
        .incbin "assets/gfx/battle_font_pal/pal_0006.pal"
        .incbin "assets/gfx/battle_font_pal/pal_0007.pal"

; ------------------------------------------------------------------------------

; ed/6300
BattleCharPal:
        .incbin "assets/gfx/battle_char_pal/edgar_sabin_celes.pal"
        .incbin "assets/gfx/battle_char_pal/locke.pal"
        .incbin "assets/gfx/battle_char_pal/terra.pal"
        .incbin "assets/gfx/battle_char_pal/strago_relm_gau_gogo.pal"
        .incbin "assets/gfx/battle_char_pal/cyan_shadow_setzer.pal"
        .incbin "assets/gfx/battle_char_pal/mog_umaro.pal"
        .incbin "assets/gfx/battle_char_pal/esper_terra.pal"
        .res 32

; ------------------------------------------------------------------------------
