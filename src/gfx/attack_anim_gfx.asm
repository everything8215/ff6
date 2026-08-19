; ------------------------------------------------------------------------------

.include "attack_pal.inc"

; ------------------------------------------------------------------------------

.export AttackTiles2bpp, AttackTiles3bpp, AttackTilesMode7
.export AttackGfx2bpp, AttackGfx3bpp, AttackGfxMode7
.export AttackPal

; ------------------------------------------------------------------------------

.segment "attack_tiles_3bpp"

; d2/0000
AttackTiles3bpp:
        .incbin "assets/gfx/attack_3bpp.scr"

; ------------------------------------------------------------------------------

.segment "attack_pal"

; d2/6000
AttackPal:
.repeat AttackPal::COUNT, i
        .incbin .sprintf("assets/gfx/attack_pal/pal_%04x.pal", i)
.endrep

; ------------------------------------------------------------------------------

.segment "attack_tiles_2bpp"

; d2/c000
AttackTiles2bpp:
        .incbin "assets/gfx/attack_2bpp.scr"

; ------------------------------------------------------------------------------

.segment "attack_gfx_3bpp"

; d3/0000
AttackGfx3bpp:
        fixed_block $01ca00
        .incbin "assets/gfx/attack_gfx.3bpp"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "attack_gfx_2bpp"

; d8/7000
AttackGfx2bpp:
        .incbin "assets/gfx/attack_gfx.2bpp"

; ------------------------------------------------------------------------------

.segment "attack_gfx_mode7"

; d8/d000
AttackGfxMode7:
        .incbin "assets/gfx/attack_mode7.4bpp.lz"

; d8/daf2
AttackTilesMode7:
        .incbin "assets/gfx/attack_mode7.scr.lz"

; ------------------------------------------------------------------------------
