.include "src/text/lore_desc.inc"

; ------------------------------------------------------------------------------

; ed/77a0
.segment "lore_desc"

LoreDesc:
.if LANG_EN
        fixed_block $02d0
        .incbin "assets/text/lore_desc.bin"
        end_fixed_block
.else
        .incbin "assets/text/lore_desc.bin"
.endif

; ------------------------------------------------------------------------------

; ed/7a70
.segment "lore_desc_ptrs"

LoreDescPtrs:
        ptr_tbl LORE_DESC

; ------------------------------------------------------------------------------
