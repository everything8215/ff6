.include "src/text/item_desc.inc"
.include "src/text/item_name.inc"
.if LANG_EN
.include "src/text/item_symbol_name.inc"
.endif

; ------------------------------------------------------------------------------

; d2/b300
.segment "item_name"

ItemName:
        .incbin "assets/text/item_name.bin"

; ------------------------------------------------------------------------------

; ed/6400
.segment "item_desc"

ItemDesc:
.if LANG_EN
        fixed_block $13a0
.else
        fixed_block $1000
.endif
        .incbin "assets/text/item_desc.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

; ed/7aa0
.segment "item_desc_ptrs"

ItemDescPtrs:
        ptr_tbl ITEM_DESC

; ------------------------------------------------------------------------------

.if LANG_EN

; d2/6f00
.segment "item_symbol_name"

ItemSymbolName:
        .incbin "assets/text/item_symbol_name.bin"

.endif

; ------------------------------------------------------------------------------
