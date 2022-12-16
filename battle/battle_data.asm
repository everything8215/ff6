
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
.export GenjuAttackDesc, GenjuAttackDescPtrs, MonsterSpecialName
.export BlitzDesc, BlitzDescPtrs, BushidoDesc, BushidoDescPtrs
.export MonsterDlgPtrs, MonsterDlg
.export RandBattleGroup, EventBattleGroup, SubBattleGroup, WorldBattleGroup
.export BattleCmdProp, BattleMonsters
.export WorldBattleRate, SubBattleRate

; ------------------------------------------------------------------------------

.segment "battle_data"

        .include "data/monster_prop.asm"                        ; cf/0000
        .include "data/monster_items.asm"                       ; cf/3000
        .include "data/monster_overlap.asm"                     ; cf/3600
        .include "data/cond_battle.asm"                         ; cf/3780
        .include "data/monster_special_anim.asm"                ; cf/37c0
        .include "text/genju_attack_desc.asm"                   ; cf/3940
        .res $0300+GenjuAttackDesc-*
        .include "text/bushido_name.asm"                        ; cf/3c40
        .res $c0+BushidoName-*
        .include "data/monster_control.asm"                     ; cf/3d00
        .include "data/monster_sketch.asm"                      ; cf/4300
        .include "data/monster_riot.asm"                        ; cf/4600
        .include "data/rand_battle_group.asm"                   ; cf/4800
        .include "data/event_battle_group.asm"                  ; cf/5000
        .include "data/world_battle_group.asm"                  ; cf/5400
        .include "data/sub_battle_group.asm"                    ; cf/5600
        .include "data/world_battle_rate.asm"                   ; cf/5800
        .include "data/sub_battle_rate.asm"                     ; cf/5880
        .include "data/battle_prop.asm"                         ; cf/5900
        .include "data/battle_monsters.asm"                     ; cf/6200
        .include "data/ai_script_ptr.asm"                       ; cf/8400
        .include "data/ai_script.asm"                           ; cf/8700
        .res $3950+AIScript-*
        .include "text/monster_name.asm"                        ; cf/c050
        .res $1080+MonsterName-*
        .include "text/monster_special_name.asm"                ; cf/d0d0
        .res $0f10+MonsterSpecialName-*
MonsterDlgPtrs:
        make_ptr_tbl_rel MonsterDlg, 256, .bankbyte(*)<<16      ; cf/dfe0
        .include "text/monster_dlg.asm"                         ; cf/e1e0

; ------------------------------------------------------------------------------

.segment "battle_data2"

        .include "text/blitz_desc.asm"                          ; cf/fc00
        .res $0100+BlitzDesc-*
        .include "text/bushido_desc.asm"                        ; cf/fd00
        .res $0100+BushidoDesc-*
        .include "data/battle_cmd_prop.asm"                     ; cf/fe00
GenjuAttackDescPtrs:
        make_ptr_tbl_rel GenjuAttackDesc, 32, GenjuAttackDesc   ; cf/fe40
        .include "data/dance_prop.asm"                          ; cf/fe80

; cf/fea0 desperation attacks for each character (unused)
        .byte   $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$ff,$fb,$ff
        .include "text/genju_bonus_name.asm"                    ; cf/feae
BlitzDescPtrs:
        make_ptr_tbl_rel BlitzDesc, 8, BlitzDesc                ; cf/ff9e
BushidoDescPtrs:
        make_ptr_tbl_rel BushidoDesc, 8, BushidoDesc            ; cf/ffae

; ------------------------------------------------------------------------------

.segment "battle_bg_dance"

        .include "data/battle_bg_dance.asm"                     ; ed/8e5b

; ------------------------------------------------------------------------------
