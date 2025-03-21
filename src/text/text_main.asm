
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: text/text_main.asm                                                   |
; |                                                                            |
; | description: game text                                                     |
; |                                                                            |
; | created: 1/8/2023                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "macros.inc"
.include "const.inc"

; ------------------------------------------------------------------------------

inc_lang "text/attack_msg_%s.inc"
inc_lang "text/attack_name_%s.inc"
inc_lang "text/battle_cmd_name_%s.inc"
inc_lang "text/battle_dlg_%s.inc"
inc_lang "text/blitz_desc_%s.inc"
inc_lang "text/bushido_desc_%s.inc"
inc_lang "text/bushido_name_%s.inc"
inc_lang "text/char_name_%s.inc"
.if !LANG_EN
inc_lang "text/char_title_%s.inc"
.endif
inc_lang "text/dance_name_%s.inc"
inc_lang "text/dlg1_%s.inc"
inc_lang "text/dlg2_%s.inc"
inc_lang "text/genju_attack_desc_%s.inc"
inc_lang "text/genju_attack_name_%s.inc"
inc_lang "text/genju_bonus_desc_%s.inc"
inc_lang "text/genju_bonus_name_%s.inc"
inc_lang "text/genju_name_%s.inc"
inc_lang "text/item_desc_%s.inc"
inc_lang "text/item_name_%s.inc"
.if LANG_EN
inc_lang "text/item_type_name_%s.inc"
.endif
inc_lang "text/lore_desc_%s.inc"
inc_lang "text/magic_desc_%s.inc"
inc_lang "text/magic_name_%s.inc"
inc_lang "text/map_title_%s.inc"
inc_lang "text/monster_dlg_%s.inc"
inc_lang "text/monster_name_%s.inc"
inc_lang "text/monster_special_name_%s.inc"
inc_lang "text/rare_item_desc_%s.inc"
inc_lang "text/rare_item_name_%s.inc"

; ------------------------------------------------------------------------------

.segment "dte_tbl"

; c0/dfa0
.export DTETbl := *
.if LANG_EN
        .incbin "dte_tbl_en.dat"
.else
        .res $0100
.endif

; ------------------------------------------------------------------------------

.segment "char_name"

; c4/78c0
CharName:
        incbin_lang "char_name_%s.dat"

; ------------------------------------------------------------------------------

.export DlgBankInc, DlgPtrs

.segment "dialogue_ptrs"

; cc/e600
DlgBankInc:
        .word   Dlg1::ARRAY_LENGTH

; cc/e602
DlgPtrs:
        ptr_tbl Dlg1
        ptr_tbl Dlg2

; ------------------------------------------------------------------------------

.segment "dialogue"

; cd/0000
.if LANG_EN
        fixed_block $01f100
.else
        fixed_block $01b000
.endif

Dlg1:   incbin_lang "dlg1_%s.dat"
Dlg2:   incbin_lang "dlg2_%s.dat"

        end_fixed_block

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
        ptr_tbl RareItemDesc
        end_fixed_block

; ce/fba0
RareItemName:
.if LANG_EN
        fixed_block $0110
.else
        fixed_block $00f0
.endif
        incbin_lang "rare_item_name_%s.dat"
        end_fixed_block

; ce/fcb0
RareItemDesc:
        incbin_lang "rare_item_desc_%s.dat"

; ------------------------------------------------------------------------------

.segment "genju_attack_desc"

; cf/3940
GenjuAttackDesc:
.if LANG_EN
        fixed_block $0300
.else
        fixed_block $0260
.endif
        incbin_lang "genju_attack_desc_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.if !LANG_EN

.segment "char_title"

; cf/3b40
CharTitle:
        incbin_lang "char_title_%s.dat"

.endif

; ------------------------------------------------------------------------------
.segment "bushido_name"

; cf/3c40
BushidoName:
.if LANG_EN
        fixed_block $c0
        incbin_lang "bushido_name_%s.dat"
        end_fixed_block
.else
        incbin_lang "bushido_name_%s.dat"
.endif

; ------------------------------------------------------------------------------

.segment "monster_text"

; cf/c050
MonsterName:
.if LANG_EN
        fixed_block $1080
        incbin_lang "monster_name_%s.dat"
        end_fixed_block
.else
        incbin_lang "monster_name_%s.dat"
.endif

; ------------------------------------------------------------------------------

; cf/d0d0
MonsterSpecialName:
.if LANG_EN
        fixed_block $0f10
        incbin_lang "monster_special_name_%s.dat"
        end_fixed_block
.else
        incbin_lang "monster_special_name_%s.dat"
.endif

; ------------------------------------------------------------------------------

; cf/dfe0
MonsterDlgPtrs:
.if LANG_EN
        ptr_tbl MonsterDlg
.else
        fixed_block $0400
        ptr_tbl MonsterDlg
        end_fixed_block
.endif

; cf/e1e0
MonsterDlg:
.if LANG_EN
        incbin_lang "monster_dlg_%s.dat"
.else
        fixed_block $1000
        incbin_lang "monster_dlg_%s.dat"
        end_fixed_block
.endif

; ------------------------------------------------------------------------------

.segment "bushido_blitz_desc"

; ------------------------------------------------------------------------------

; cf/fc00
BlitzDesc:
        fixed_block $0100
        incbin_lang "blitz_desc_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

; cf/fd00
BushidoDesc:
        fixed_block $0100
        incbin_lang "bushido_desc_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "genju_attack_desc_ptrs"

; cf/fe40
GenjuAttackDescPtrs:
        ptr_tbl GenjuAttackDesc

; ------------------------------------------------------------------------------

.segment "genju_bonus_name"

; cf/feae
GenjuBonusName:
.if LANG_EN
        fixed_block $f0
.else
        fixed_block $90
.endif
        incbin_lang "genju_bonus_name_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "bushido_blitz_desc_ptrs"

; cf/ff9e
BlitzDescPtrs:
        ptr_tbl BlitzDesc

; ------------------------------------------------------------------------------

; cf/ffae
BushidoDescPtrs:
        ptr_tbl BushidoDesc

; ------------------------------------------------------------------------------

.segment "battle_dlg_ptrs"

; d0/d000
BattleDlgPtrs:
        ptr_tbl BattleDlg

.segment "battle_dlg"

; d0/d200
BattleDlg:
        incbin_lang "battle_dlg_%s.dat"

; ------------------------------------------------------------------------------

.segment "attack_msg"

; d1/f000
AttackMsg:
.if LANG_EN
        fixed_block $07a0
.else
        fixed_block $09ab
.endif
        incbin_lang "attack_msg_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "attack_msg_ptrs"

; d1/f7a0
AttackMsgPtrs:
.if LANG_EN
        fixed_block $020b
        ptr_tbl AttackMsg
        end_fixed_block
.else
        ptr_tbl AttackMsg
.endif

; ------------------------------------------------------------------------------

.if LANG_EN

.segment "item_type_name"

; d2/6f00
ItemTypeName:
        incbin_lang "item_type_name_%s.dat"

.endif

; ------------------------------------------------------------------------------

.segment "item_name"

; d2/b300
ItemName:
        incbin_lang "item_name_%s.dat"

; ------------------------------------------------------------------------------

.segment "magic_desc"

; d8/c9a0
MagicDesc:
.if LANG_EN
        fixed_block $0500
.else
        fixed_block $0400
.endif
        incbin_lang "magic_desc_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "battle_cmd_name"

; d8/cea0
BattleCmdName:
        incbin_lang "battle_cmd_name_%s.dat"

; ------------------------------------------------------------------------------

.segment "magic_desc_ptrs"

; d8/cf80
MagicDescPtrs:
        ptr_tbl MagicDesc

; ------------------------------------------------------------------------------

.segment "map_title_ptrs"

; e6/8400
MapTitlePtrs:
.if LANG_EN
        fixed_block $0380
.else
        fixed_block $c0
.endif
        ptr_tbl MapTitle
        end_fixed_block

.segment "map_title"

; e6/84c0
MapTitle:
.if LANG_EN
        fixed_block $0500
.else
        fixed_block $02c0
.endif
        incbin_lang "map_title_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "magic_name"

; e6/f567
MagicName:
        incbin_lang "magic_name_%s.dat"

; ------------------------------------------------------------------------------

; e6/f6e1
GenjuName:
        incbin_lang "genju_name_%s.dat"

; ------------------------------------------------------------------------------

; e6/f7b9
AttackName:
        incbin_lang "attack_name_%s.dat"

; ------------------------------------------------------------------------------

; e6/fe8f
GenjuAttackName:
        incbin_lang "genju_attack_name_%s.dat"

; ------------------------------------------------------------------------------

; e6/ff9d
DanceName:
        incbin_lang "dance_name_%s.dat"

; ------------------------------------------------------------------------------

.segment "item_desc"

; ed/6400
ItemDesc:
.if LANG_EN
        fixed_block $13a0
.else
        fixed_block $1000
.endif
        incbin_lang "item_desc_%s.dat"
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "lore_desc"

; ed/77a0
LoreDesc:
.if LANG_EN
        fixed_block $02d0
        incbin_lang "lore_desc_%s.dat"
        end_fixed_block
.else
        incbin_lang "lore_desc_%s.dat"
.endif

; ------------------------------------------------------------------------------

.segment "lore_desc_ptrs"

; ed/7a70
LoreDescPtrs:
        ptr_tbl LoreDesc

; ------------------------------------------------------------------------------

.segment "item_desc_ptrs"

; ed/7aa0
ItemDescPtrs:
        ptr_tbl ItemDesc

; ------------------------------------------------------------------------------

.segment "genju_bonus_desc"

; ed/fe00
GenjuBonusDesc:
        fixed_block $01d0
        incbin_lang "genju_bonus_desc_%s.dat"
        end_fixed_block

.segment "genju_bonus_desc_ptrs"

; ed/ffd0
GenjuBonusDescPtrs:
        ptr_tbl GenjuBonusDesc

; ------------------------------------------------------------------------------
