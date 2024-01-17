
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: text/main.asm                                                        |
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
inc_lang "text/item_type_name_%s.inc"
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
        .incbin "dte_tbl.dat"
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
        .word   DLG1_ARRAY_LENGTH

; cc/e602
DlgPtrs:
        make_ptr_tbl_rel Dlg1, DLG1_ARRAY_LENGTH
        make_ptr_tbl_rel Dlg2, DLG2_ARRAY_LENGTH, Dlg1+$010000

; ------------------------------------------------------------------------------

.segment "dialogue"

; cd/0000
begin_fixed_block Dlg, $01f100
Dlg1:
        incbin_lang "dlg1_%s.dat"
Dlg2:
        incbin_lang "dlg2_%s.dat"
end_fixed_block Dlg

; ------------------------------------------------------------------------------

.if LANG_EN

.segment "map_title"

; ce/f100
begin_fixed_block MapTitle, $0500
        incbin_lang "map_title_%s.dat"
end_fixed_block MapTitle

.endif

; ------------------------------------------------------------------------------

.segment "rare_item"

; ce/fb60
begin_fixed_block RareItemDescPtrs, $40
        make_ptr_tbl_rel RareItemDesc, RARE_ITEM_DESC_ARRAY_LENGTH
end_fixed_block RareItemDescPtrs

; ce/fba0
begin_fixed_block RareItemName, $0110
        incbin_lang "rare_item_name_%s.dat"
end_fixed_block RareItemName

; ce/fcb0
RareItemDesc:
        incbin_lang "rare_item_desc_%s.dat"

; ------------------------------------------------------------------------------

.segment "genju_attack_desc"

; cf/3940
begin_fixed_block GenjuAttackDesc, $0300
        incbin_lang "genju_attack_desc_%s.dat"
end_fixed_block GenjuAttackDesc

; ------------------------------------------------------------------------------

.segment "bushido_name"

; cf/3c40
begin_fixed_block BushidoName, $c0
        incbin_lang "bushido_name_%s.dat"
end_fixed_block BushidoName

; ------------------------------------------------------------------------------

.segment "monster_text"

; cf/c050
begin_fixed_block MonsterName, $1080
        incbin_lang "monster_name_%s.dat"
end_fixed_block MonsterName

; ------------------------------------------------------------------------------

; cf/d0d0
begin_fixed_block MonsterSpecialName, $0f10
        incbin_lang "monster_special_name_%s.dat"
end_fixed_block MonsterSpecialName

; ------------------------------------------------------------------------------

; cf/dfe0
MonsterDlgPtrs:
        make_ptr_tbl_rel MonsterDlg, MONSTER_DLG_ARRAY_LENGTH, .bankbyte(*)<<16

; cf/e1e0
MonsterDlg:
        incbin_lang "monster_dlg_%s.dat"

; ------------------------------------------------------------------------------

.segment "bushido_blitz_desc"

; ------------------------------------------------------------------------------

; cf/fc00
begin_fixed_block BlitzDesc, $0100
        incbin_lang "blitz_desc_%s.dat"
end_fixed_block BlitzDesc

; ------------------------------------------------------------------------------

; cf/fd00
begin_fixed_block BushidoDesc, $0100
        incbin_lang "bushido_desc_%s.dat"
end_fixed_block BushidoDesc

; ------------------------------------------------------------------------------

.segment "genju_attack_desc_ptrs"

; cf/fe40
GenjuAttackDescPtrs:
        make_ptr_tbl_rel GenjuAttackDesc, GENJU_ATTACK_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "genju_bonus_name"

; cf/feae
begin_fixed_block GenjuBonusName, $f0
        incbin_lang "genju_bonus_name_%s.dat"
end_fixed_block GenjuBonusName

; ------------------------------------------------------------------------------

.segment "bushido_blitz_desc_ptrs"

; cf/ff9e
BlitzDescPtrs:
        make_ptr_tbl_rel BlitzDesc, BLITZ_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

; cf/ffae
BushidoDescPtrs:
        make_ptr_tbl_rel BushidoDesc, BUSHIDO_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "battle_dlg"

BattleDlgPtrs:
; d0/d000
        make_ptr_tbl_abs BattleDlg, BATTLE_DLG_ARRAY_LENGTH

; d0/d200
BattleDlg:
        incbin_lang "battle_dlg_%s.dat"

; ------------------------------------------------------------------------------

.segment "attack_msg"

; d1/f000
begin_fixed_block AttackMsg, $07a0
        incbin_lang "attack_msg_%s.dat"
end_fixed_block AttackMsg

; ------------------------------------------------------------------------------

; d1/f7a0
AttackMsgPtrs:
        make_ptr_tbl_rel AttackMsg, ATTACK_MSG_ARRAY_LENGTH, .bankbyte(*)<<16
        .res 11

; ------------------------------------------------------------------------------

.segment "item_type_name"

; d2/6f00
ItemTypeName:
        incbin_lang "item_type_name_%s.dat"

; ------------------------------------------------------------------------------

.segment "item_name"

; d2/b300
ItemName:
        incbin_lang "item_name_%s.dat"

; ------------------------------------------------------------------------------

.segment "magic_desc"

; d8/c9a0
begin_fixed_block MagicDesc, $0500
        incbin_lang "magic_desc_%s.dat"
end_fixed_block MagicDesc

; ------------------------------------------------------------------------------

.segment "battle_cmd_name"

; d8/cea0
BattleCmdName:
        incbin_lang "battle_cmd_name_%s.dat"

; ------------------------------------------------------------------------------

.segment "magic_desc_ptrs"

; d8/cf80
MagicDescPtrs:
        make_ptr_tbl_rel MagicDesc, MAGIC_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "map_title_ptrs"

; e6/8400
begin_fixed_block MapTitlePtrs, $0380
        make_ptr_tbl_rel MapTitle, MAP_TITLE_ARRAY_LENGTH

; e6/84c0
.if !LANG_EN

        .segment "map_title"
        incbin_lang "map_title_%s.dat"

.endif
end_fixed_block MapTitlePtrs

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

.segment "item_lore_desc"

; ed/6400
begin_fixed_block ItemDesc, $13a0
        incbin_lang "item_desc_%s.dat"
end_fixed_block ItemDesc

; ------------------------------------------------------------------------------

; ed/77a0
begin_fixed_block LoreDesc, $02d0
        incbin_lang "lore_desc_%s.dat"
end_fixed_block LoreDesc

; ------------------------------------------------------------------------------

; ed/7a70
LoreDescPtrs:
        make_ptr_tbl_rel LoreDesc, LORE_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

; ed/7aa0
ItemDescPtrs:
        make_ptr_tbl_rel ItemDesc, ITEM_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "genju_bonus_desc"

; ed/fe00
begin_fixed_block GenjuBonusDesc, $01d0
        incbin_lang "genju_bonus_desc_%s.dat"
end_fixed_block GenjuBonusDesc

; ed/ffd0
GenjuBonusDescPtrs:
        make_ptr_tbl_rel GenjuBonusDesc, GENJU_BONUS_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------
