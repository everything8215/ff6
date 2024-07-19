; ------------------------------------------------------------------------------

.include "btlgfx/attack_pal.inc"

; ------------------------------------------------------------------------------

.export AttackTiles2bpp, AttackTiles3bpp, AttackTilesMode7
.export AttackGfx2bpp, AttackGfx3bpp, AttackGfxMode7
.export AttackPal

; ------------------------------------------------------------------------------

.segment "attack_tiles_3bpp"

; d2/0000
AttackTiles3bpp:
        incbin_lang "attack_3bpp_%s.scr"

; ------------------------------------------------------------------------------

.segment "attack_pal"

; d2/6000
AttackPal:
.repeat ATTACK_PAL_ARRAY_LENGTH, _i
        .incbin .sprintf("attack_pal/pal_%04x.pal", _i)
.endrep

; ------------------------------------------------------------------------------

.segment "attack_tiles_2bpp"

; d2/c000
AttackTiles2bpp:
        .incbin "attack_2bpp.scr"

; ------------------------------------------------------------------------------

.segment "attack_gfx_3bpp"

; d3/0000
begin_block AttackGfx3bpp, $01ca00
        incbin_lang "attack_gfx_%s.3bpp"
end_block AttackGfx3bpp

; ------------------------------------------------------------------------------

.segment "attack_gfx_2bpp"

; d8/7000
AttackGfx2bpp:
        .incbin "attack_gfx.2bpp"

; ------------------------------------------------------------------------------

.segment "attack_gfx_mode7"

; d8/d000
AttackGfxMode7:
        .incbin "attack_mode7.4bpp.lz"

; d8/daf2
AttackTilesMode7:
        .incbin "attack_mode7.scr.lz"

; ------------------------------------------------------------------------------
