; ------------------------------------------------------------------------------

.export BattleFontPal, BattleCharPal

; ------------------------------------------------------------------------------

.segment "battle_pal"

; ed/62c0
BattleFontPal:
        .incbin "battle_font_pal/pal_0000.pal"
        .incbin "battle_font_pal/pal_0001.pal"
        .incbin "battle_font_pal/pal_0002.pal"
        .incbin "battle_font_pal/pal_0003.pal"

; ------------------------------------------------------------------------------

; ed/6300
BattleCharPal:
        .incbin "battle_char_pal/edgar_sabin_celes.pal"
        .incbin "battle_char_pal/locke.pal"
        .incbin "battle_char_pal/terra.pal"
        .incbin "battle_char_pal/strago_relm_gau_gogo.pal"
        .incbin "battle_char_pal/cyan_shadow_setzer.pal"
        .incbin "battle_char_pal/mog_umaro.pal"
        .incbin "battle_char_pal/esper_terra.pal"
        .incbin "battle_char_pal/unused.pal"

; ------------------------------------------------------------------------------
