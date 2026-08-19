.include "src/text/map_title.inc"

; ------------------------------------------------------------------------------

; e6/8400
.segment "map_title_ptrs"

MapTitlePtrs:
.if LANG_EN
        fixed_block $0380
.else
        fixed_block $c0
.endif
        ptr_tbl MAP_TITLE
        end_fixed_block

; ------------------------------------------------------------------------------

; e6/84c0
.segment "map_title"

MapTitle:
.if LANG_EN
        fixed_block $0500
.else
        fixed_block $02c0
.endif
        .incbin "assets/text/map_title.bin"
        end_fixed_block

; ------------------------------------------------------------------------------
