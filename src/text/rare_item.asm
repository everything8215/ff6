.include "src/text/rare_item_desc.inc"
.include "src/text/rare_item_name.inc"

; ------------------------------------------------------------------------------

.segment "rare_item"

; ce/fb00 unused (30 * 3 bytes)
        fixed_block $60
        .faraddr 1,2,3,4,5,6,7,8,9,0,0,0,0,0,0
        .faraddr 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        end_fixed_block

; ce/fb60
RareItemDescPtrs:
        fixed_block $40
        ptr_tbl RARE_ITEM_DESC
        end_fixed_block

; ce/fba0
RareItemName:
.if LANG_EN
        fixed_block $0110
.else
        fixed_block $00f0
.endif
        .incbin "assets/text/rare_item_name.bin"
        end_fixed_block

; ce/fcb0
RareItemDesc:
        .incbin "assets/text/rare_item_desc.bin"

; ------------------------------------------------------------------------------
