
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: battle_data.asm                                                      |
; |                                                                            |
; | description: data for battle module                                        |
; |                                                                            |
; | created: 8/13/2022                                                         |
; +----------------------------------------------------------------------------+

.export MonsterOverlap, BushidoName, MonsterName, GenjuBonusName
.export GenjuAttackDesc, GenjuAttackDescPtrs
.export BlitzDesc, BlitzDescPtrs, BushidoDesc, BushidoDescPtrs
.export MonsterDlgPtrs, MonsterDlg
.export RandBattleGroup, EventBattleGroup, SubBattleGroup, WorldBattleGroup
.export BattleCmdProp, BattleMonsters
.export WorldBattleRate, SubBattleRate

; ------------------------------------------------------------------------------

.segment "battle_data"

; cf/0000
        .include "data/monster_prop.asm"

; cf/3000
        .include "data/monster_items.asm"

; cf/3600
        .include "data/monster_overlap.asm"

; cf/3780
        .include "data/cond_battle.asm"

; cf/37c0
        .include "data/monster_special_anim.asm"

; cf/3940
        .include "text/genju_attack_desc.asm"
        .res $0300+GenjuAttackDesc-*

; cf/3c40
        .include "text/bushido_name.asm"
        .res $c0+BushidoName-*

; cf/3d00
        .include "data/monster_control.asm"

; cf/4300
        .include "data/monster_sketch.asm"

; cf/4600
        .include "data/monster_riot.asm"

; cf/4800
        .include "data/rand_battle_group.asm"

; cf/5000
        .include "data/event_battle_group.asm"

; cf/5400
        .include "data/world_battle_group.asm"

; cf/5600
        .include "data/sub_battle_group.asm"

; cf/5800
        .include "data/world_battle_rate.asm"

; cf/5880
        .include "data/sub_battle_rate.asm"

; cf/5900
        .include "data/battle_prop.asm"

; cf/6200
        .include "data/battle_monsters.asm"

; cf/8400
        .include "data/ai_script_ptr.asm"

; cf/8700
        .include "data/ai_script.asm"
        .res $3950+AIScript-*

; cf/c050
        .include "text/monster_name.asm"
        .res $1080+MonsterName-*

; cf/d0d0
        .include "text/monster_special_name.asm"
        .res $0f10+MonsterSpecialName-*

; cf/dfe0
MonsterDlgPtrs:
        make_ptr_tbl_rel MonsterDlg, 256, .bankbyte(*)<<16

; cf/e1e0
        .include "text/monster_dlg.asm"

; ------------------------------------------------------------------------------

.segment "battle_data2"

; cf/fc00
        .include "text/blitz_desc.asm"
        .res $0100+BlitzDesc-*

; cf/fd00
        .include "text/bushido_desc.asm"
        .res $0100+BushidoDesc-*

; cf/fe00
        .include "data/battle_cmd_prop.asm"

; cf/fe40
GenjuAttackDescPtrs:
        make_ptr_tbl_rel GenjuAttackDesc, 32, GenjuAttackDesc

; cf/fe80
        .include "data/dance_prop.asm"

; cf/fea0 desperation attacks for each character (unused)
        .byte   $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$ff,$fb,$ff

; cf/feae
        .include "text/genju_bonus_name.asm"

; cf/ff9e
BlitzDescPtrs:
        make_ptr_tbl_rel BlitzDesc, 8, BlitzDesc

; cf/ffae
BushidoDescPtrs:
        make_ptr_tbl_rel BushidoDesc, 8, BushidoDesc

; ------------------------------------------------------------------------------
