.include "src/text/genju_attack_desc.inc"
.include "src/text/genju_bonus_desc.inc"
.include "src/text/genju_bonus_name.inc"

; ------------------------------------------------------------------------------

; cf/3940
.segment "genju_attack_desc"

GenjuAttackDesc:
.if LANG_EN
        fixed_block $0300
.else
        fixed_block $0260
.endif
        .incbin "assets/text/genju_attack_desc.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

; cf/fe40
.segment "genju_attack_desc_ptrs"

GenjuAttackDescPtrs:
        ptr_tbl GENJU_ATTACK_DESC

; ------------------------------------------------------------------------------

; cf/feae
.segment "genju_bonus_name"

GenjuBonusName:
.if LANG_EN
        fixed_block $f0
.else
        fixed_block $90
.endif
        .incbin "assets/text/genju_bonus_name.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

; ed/fe00
.segment "genju_bonus_desc"

GenjuBonusDesc:
        fixed_block $01d0
        .incbin "assets/text/genju_bonus_desc.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

; ed/ffd0
.segment "genju_bonus_desc_ptrs"

GenjuBonusDescPtrs:
        ptr_tbl GENJU_BONUS_DESC

; ------------------------------------------------------------------------------
