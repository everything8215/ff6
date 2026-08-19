.include "src/text/magic_desc.inc"

; ------------------------------------------------------------------------------

; d8/c9a0
.segment "magic_desc"

MagicDesc:
.if LANG_EN
        fixed_block $0500
.else
        fixed_block $0400
.endif
        .incbin "assets/text/magic_desc.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

; d8/cf80
.segment "magic_desc_ptrs"

MagicDescPtrs:
        ptr_tbl MAGIC_DESC

; ------------------------------------------------------------------------------
