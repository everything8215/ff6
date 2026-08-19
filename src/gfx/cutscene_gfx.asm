; ------------------------------------------------------------------------------

.export TitleOpeningGfx, FloatingContGfx, CreditsGfx, EndingFontGfx
.export EndingGfx1, EndingGfx2, EndingGfx3, EndingGfx4, EndingGfx5

; ------------------------------------------------------------------------------

.segment "title_opening_gfx"

; d8/f000
TitleOpeningGfx:
.if LANG_EN
        .incbin "assets/gfx/title_opening.4bpp.lz"
        .res $24
.else
        .incbin "assets/gfx/title_opening.4bpp.lz"
.endif

; ------------------------------------------------------------------------------

.segment "floating_cont_gfx"

; d9/4e96
FloatingContGfx:
        .incbin "assets/gfx/floating_cont.4bpp.lz"
        .res 3

; ------------------------------------------------------------------------------

.segment "credits_gfx"

; d9/568f
CreditsGfx:
        fixed_block $46bc
        .incbin "assets/gfx/credits.4bpp.lz"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "ending_gfx_1"

; c4/ba00
EndingFontGfx:
        fixed_block $0608
        .incbin "assets/gfx/ending_font.2bpp.lz"
        end_fixed_block

; c4/c008
EndingGfx1:
        fixed_block $346f
        .incbin "assets/gfx/ending1.4bpp.lz"
        end_fixed_block

; c4/f477
EndingGfx2:
        fixed_block $0284
        .incbin "assets/gfx/ending2.4bpp.lz"
        end_fixed_block

; c4/f6fb
EndingGfx3:
        fixed_block $0905
        .incbin "assets/gfx/ending3.4bpp.lz"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "ending_gfx_2"

; d9/9d4b
EndingGfx4:
        fixed_block $079a
        .incbin "assets/gfx/ending4.4bpp.lz"
        end_fixed_block

; d9/a4e5
EndingGfx5:
        .incbin "assets/gfx/ending5.4bpp.lz"

; ------------------------------------------------------------------------------
