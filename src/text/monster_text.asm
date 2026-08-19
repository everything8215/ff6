.include "src/text/monster_dlg.inc"
.include "src/text/monster_name.inc"
.include "src/text/monster_special_name.inc"

; ------------------------------------------------------------------------------

.segment "monster_text"

; cf/c050
MonsterName:
.if LANG_EN
        fixed_block $1080
        .incbin "assets/text/monster_name.bin"
        end_fixed_block
.else
        .incbin "assets/text/monster_name.bin"
.endif

; ------------------------------------------------------------------------------

; cf/d0d0
MonsterSpecialName:
.if LANG_EN
        fixed_block $0f10
        .incbin "assets/text/monster_special_name.bin"
        end_fixed_block
.else
        .incbin "assets/text/monster_special_name.bin"
.endif

; ------------------------------------------------------------------------------

; cf/dfe0
MonsterDlgPtrs:
.if LANG_EN
        ptr_tbl MONSTER_DLG
.else
        fixed_block $0400
        ptr_tbl MONSTER_DLG
        end_fixed_block
.endif

; cf/e1e0
MonsterDlg:
.if LANG_EN
        .incbin "assets/text/monster_dlg.bin"
.else
        fixed_block $1000
        .incbin "assets/text/monster_dlg.bin"
        end_fixed_block
.endif

; ------------------------------------------------------------------------------
