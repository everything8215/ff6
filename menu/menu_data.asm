
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: menu_data.asm                                                        |
; |                                                                            |
; | description: data for menu program                                         |
; |                                                                            |
; | created: 8/12/2022                                                         |
; +----------------------------------------------------------------------------+

.export ItemProp, GenjuProp
.export WindowGfx, WindowPal, PortraitGfx, PortraitPal

; ------------------------------------------------------------------------------

.segment "shop_prop"

; c4/7ac0
        .include "data/shop_prop.asm"

; ------------------------------------------------------------------------------

.segment "rare_item"

; ce/fb60
RareItemDescPtrs:
        make_ptr_tbl_rel RareItemDesc, 20
        .res $40+RareItemDescPtrs-*

; ce/fba0
        .include "text/rare_item_name.asm"
        .res $0110+RareItemName-*

; ce/fcb0
        .include "text/rare_item_desc.asm"

; ------------------------------------------------------------------------------

.segment "item_genju_prop"

; d8/5000
        .include "data/item_prop.asm"

; d8/6e00
        .include "data/genju_prop.asm"

; ------------------------------------------------------------------------------

.segment "magic_desc"

; d8/c9a0
        .include "text/magic_desc.asm"
        .res $0500+MagicDesc-*

; d8/cea0
        .include "text/battle_cmd_name.asm"

; d8/cf80
MagicDescPtrs:
        make_ptr_tbl_rel MagicDesc, 54

; ------------------------------------------------------------------------------

.segment "menu_data"

; d8/e800
        .include "gfx/menu_pal.asm"

; ------------------------------------------------------------------------------

; name change letters
NameChangeLetters:
@e8c8:  .byte   $80,$81,$82,$83,$84,$9a,$9b,$9c,$9d,$9e
        .byte   $85,$86,$87,$88,$89,$9f,$a0,$a1,$a2,$a3
        .byte   $8a,$8b,$8c,$8d,$8e,$a4,$a5,$a6,$a7,$a8
        .byte   $8f,$90,$91,$92,$93,$a9,$aa,$ab,$ac,$ad
        .byte   $94,$95,$96,$97,$98,$ae,$af,$b0,$b1,$b2
        .byte   $99,$be,$bf,$c0,$c1,$b3,$c2,$c3,$c4,$c5
        .byte   $b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd

; element symbols
ElementSymbols:
@e90e:  .byte   $dd,$da,$d6,$d9,$de,$d8,$db,$dc,0

; ------------------------------------------------------------------------------

; d8/e917
        .include "menu_anim.asm"

; ------------------------------------------------------------------------------

.segment "menu_gfx"

; ed/0000
        .include "gfx/window_gfx.asm"

; ed/1c00
        .include "gfx/window_pal.asm"

; ed/1d00
        .include "gfx/portrait_gfx.asm"

; ed/5860
        .include "gfx/portrait_pal.asm"

; ed/5ac0
        .include "gfx/menu_sprite_gfx.asm"

; ed/62c0
        .include "gfx/battle_font_pal.asm"

; ed/6300
        .include "gfx/battle_char_pal.asm"

; ------------------------------------------------------------------------------

; ed/6400
        .include "text/item_desc.asm"
        .res $13a0+ItemDesc-*

; ed/77a0
        .include "text/lore_desc.asm"
        .res $02d0+LoreDesc-*

; ed/7a70
LoreDescPtrs:
        make_ptr_tbl_rel LoreDesc, 24

; ed/7aa0
ItemDescPtrs:
        make_ptr_tbl_rel ItemDesc, 256

; ------------------------------------------------------------------------------
