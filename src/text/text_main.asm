
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
.if LANG_EN
begin_block Dlg, $01f100
.else
begin_block Dlg, $01b000
.endif
Dlg1:
        incbin_lang "dlg1_%s.dat"
Dlg2:
        incbin_lang "dlg2_%s.dat"
end_block Dlg

; ------------------------------------------------------------------------------

.segment "rare_item"

; ce/fb00 unused (30 * 3 bytes)
begin_block _cefb00, $60
        .faraddr 1,2,3,4,5,6,7,8,9,0,0,0,0,0,0
        .faraddr 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
end_block _cefb00

; ce/fb60
begin_block RareItemDescPtrs, $40
        make_ptr_tbl_rel RareItemDesc, RARE_ITEM_DESC_ARRAY_LENGTH
end_block RareItemDescPtrs

; ce/fba0
.if LANG_EN
begin_block RareItemName, $0110
.else
begin_block RareItemName, $00f0
.endif
        incbin_lang "rare_item_name_%s.dat"
end_block RareItemName

; ce/fcb0
RareItemDesc:
        incbin_lang "rare_item_desc_%s.dat"

; ------------------------------------------------------------------------------

.segment "genju_attack_desc"

; cf/3940
.if LANG_EN
begin_block GenjuAttackDesc, $0300
.else
begin_block GenjuAttackDesc, $0260
.endif
        incbin_lang "genju_attack_desc_%s.dat"
end_block GenjuAttackDesc

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
.if LANG_EN
begin_block BushidoName, $c0
.else
begin_block BushidoName
.endif
        incbin_lang "bushido_name_%s.dat"
end_block BushidoName

; ------------------------------------------------------------------------------

.segment "monster_text"

; cf/c050
.if LANG_EN
begin_block MonsterName, $1080
.else
begin_block MonsterName
.endif
        incbin_lang "monster_name_%s.dat"
end_block MonsterName

; ------------------------------------------------------------------------------

; cf/d0d0
.if LANG_EN
begin_block MonsterSpecialName, $0f10
.else
begin_block MonsterSpecialName
.endif
        incbin_lang "monster_special_name_%s.dat"
end_block MonsterSpecialName

; ------------------------------------------------------------------------------

; cf/dfe0
.if LANG_EN
begin_block MonsterDlgPtrs
.else
begin_block MonsterDlgPtrs, $0400
.endif
        make_ptr_tbl_rel MonsterDlg, MONSTER_DLG_ARRAY_LENGTH, .bankbyte(*)<<16
end_block MonsterDlgPtrs

; cf/e1e0
.if LANG_EN
begin_block MonsterDlg
.else
begin_block MonsterDlg, $1000
.endif
        incbin_lang "monster_dlg_%s.dat"
end_block MonsterDlg

; ------------------------------------------------------------------------------

.segment "bushido_blitz_desc"

; ------------------------------------------------------------------------------

; cf/fc00
begin_block BlitzDesc, $0100
        incbin_lang "blitz_desc_%s.dat"
end_block BlitzDesc

; ------------------------------------------------------------------------------

; cf/fd00
begin_block BushidoDesc, $0100
        incbin_lang "bushido_desc_%s.dat"
end_block BushidoDesc

; ------------------------------------------------------------------------------

.segment "genju_attack_desc_ptrs"

; cf/fe40
GenjuAttackDescPtrs:
        make_ptr_tbl_rel GenjuAttackDesc, GENJU_ATTACK_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "genju_bonus_name"

; cf/feae
.if LANG_EN
begin_block GenjuBonusName, $f0
.else
begin_block GenjuBonusName, $90
.endif
        incbin_lang "genju_bonus_name_%s.dat"
end_block GenjuBonusName

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

.segment "battle_dlg_ptrs"

BattleDlgPtrs:
; d0/d000
        make_ptr_tbl_abs BattleDlg, BATTLE_DLG_ARRAY_LENGTH

.segment "battle_dlg"

; d0/d200
BattleDlg:
        incbin_lang "battle_dlg_%s.dat"

; ------------------------------------------------------------------------------

.segment "attack_msg"

; d1/f000
.if LANG_EN
begin_block AttackMsg, $07a0
.else
begin_block AttackMsg, $09ab
.endif
        incbin_lang "attack_msg_%s.dat"
end_block AttackMsg

; ------------------------------------------------------------------------------

.segment "attack_msg_ptrs"

; d1/f7a0
.if LANG_EN
begin_block AttackMsgPtrs, $020b
.else
begin_block AttackMsgPtrs
.endif
        make_ptr_tbl_rel AttackMsg, ATTACK_MSG_ARRAY_LENGTH, .bankbyte(*)<<16
end_block AttackMsgPtrs

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
.if LANG_EN
begin_block MagicDesc, $0500
.else
begin_block MagicDesc, $0400
.endif
        incbin_lang "magic_desc_%s.dat"
end_block MagicDesc

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
.if LANG_EN
begin_block MapTitlePtrs, $0380
.else
begin_block MapTitlePtrs, $c0
.endif
        make_ptr_tbl_rel MapTitle, MAP_TITLE_ARRAY_LENGTH
end_block MapTitlePtrs

; e6/84c0

.segment "map_title"

.if LANG_EN
begin_block MapTitle, $0500
.else
begin_block MapTitle, $02c0
.endif
        incbin_lang "map_title_%s.dat"
end_block MapTitle

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
.if LANG_EN
begin_block ItemDesc, $13a0
.else
begin_block ItemDesc, $1000
.endif
        incbin_lang "item_desc_%s.dat"
end_block ItemDesc

; ------------------------------------------------------------------------------

.segment "lore_desc"

; ed/77a0
.if LANG_EN
begin_block LoreDesc, $02d0
.else
begin_block LoreDesc
.endif
        incbin_lang "lore_desc_%s.dat"
end_block LoreDesc

; ------------------------------------------------------------------------------

.segment "lore_desc_ptrs"

; ed/7a70
LoreDescPtrs:
        make_ptr_tbl_rel LoreDesc, LORE_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "item_desc_ptrs"

; ed/7aa0
ItemDescPtrs:
        make_ptr_tbl_rel ItemDesc, ITEM_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------

.segment "genju_bonus_desc"

; ed/fe00
begin_block GenjuBonusDesc, $01d0
        incbin_lang "genju_bonus_desc_%s.dat"
end_block GenjuBonusDesc

.segment "genju_bonus_desc_ptrs"

; ed/ffd0
GenjuBonusDescPtrs:
        make_ptr_tbl_rel GenjuBonusDesc, GENJU_BONUS_DESC_ARRAY_LENGTH

; ------------------------------------------------------------------------------
