
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: src/data/battle_cmd_prop.asm                                         |
; |                                                                            |
; | description: battle command properties                                     |
; |                                                                            |
; | created: 11/5/2023                                                         |
; +----------------------------------------------------------------------------+

; [ data format (2 bytes each) ]

;   0: battle command flags (see include/const.inc)
;   1: target selection flags (see include/const.inc)

; ------------------------------------------------------------------------------

.export BattleCmdProp

.segment "battle_cmd_prop"

; ------------------------------------------------------------------------------

_battle_cmd_prop_seq .set 0

.mac battle_cmd_prop battle_cmd_id, flags, target
        .assert _battle_cmd_prop_seq = BATTLE_CMD::battle_cmd_id, error, .sprintf("battle_cmd_prop index mismatch (%s != %d)", .string(battle_cmd_id), _battle_cmd_prop_seq)
        opflg .byte, BATTLE_CMD_FLAG, {flags}
        opflg .byte, TARGET, {target}
        _battle_cmd_prop_seq .set _battle_cmd_prop_seq + 1
.endmac

; ------------------------------------------------------------------------------

; cf/fe00
BattleCmdProp:

; ------------------------------------------------------------------------------

; $00: FIGHT
battle_cmd_prop FIGHT, {GOGO, MIMIC, IMP, UNKNOWN}, {MANUAL, INIT_SINGLE, ENEMY}

; $01: ITEM
battle_cmd_prop ITEM, {GOGO, MIMIC, IMP}, MENU

; $02: MAGIC
battle_cmd_prop MAGIC, {GOGO, MIMIC, IMP}, MENU

; $03: MORPH
battle_cmd_prop MORPH, NONE, SELF

; $04: REVERT
battle_cmd_prop REVERT, IMP, SELF

; $05: STEAL
battle_cmd_prop STEAL, {GOGO, MIMIC, UNKNOWN}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $06: CAPTURE
battle_cmd_prop CAPTURE, {GOGO, MIMIC, UNKNOWN}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $07: SWDTECH
battle_cmd_prop BUSHIDO, {GOGO, MIMIC}, MENU

; $08: THROW
battle_cmd_prop THROW, {GOGO, MIMIC}, MENU

; $09: TOOLS
battle_cmd_prop TOOLS, {GOGO, MIMIC}, MENU

; $0a: BLITZ
battle_cmd_prop BLITZ, {GOGO, MIMIC}, MENU

; $0b: RUNIC
battle_cmd_prop RUNIC, {GOGO, MIMIC}, SELF

; $0c: LORE
battle_cmd_prop LORE, {GOGO, MIMIC}, MENU

; $0d: SKETCH
battle_cmd_prop SKETCH, {GOGO, MIMIC}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $0e: CONTROL
battle_cmd_prop CONTROL, GOGO, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $0f: SLOT
battle_cmd_prop SLOT, {GOGO, MIMIC}, MENU

; $10: RAGE
battle_cmd_prop RAGE, {GOGO, MIMIC, UNKNOWN}, MENU

; $11: LEAP
battle_cmd_prop LEAP, NONE, SELF

; $12: MIMIC
battle_cmd_prop MIMIC, {GOGO, IMP}, SELF

; $13: DANCE
battle_cmd_prop DANCE, {GOGO, MIMIC}, MENU

; $14: ROW
battle_cmd_prop ROW, IMP, MENU

; $15: DEF
battle_cmd_prop DEF, IMP, MENU

; $16: JUMP
battle_cmd_prop JUMP, {GOGO, IMP}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $17: X_MAGIC
battle_cmd_prop X_MAGIC, {GOGO, MIMIC, IMP}, MENU

; $18: GIL_TOSS
battle_cmd_prop GIL_TOSS, {GOGO, MIMIC}, {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}

; $19: SUMMON
battle_cmd_prop SUMMON, {GOGO, MIMIC}, MENU

; $1a: HEALTH
battle_cmd_prop HEALTH, {MIMIC, IMP}, {ONE_SIDE, INIT_HALF, MULTI_TARGET}

; $1b: SHOCK
battle_cmd_prop SHOCK, {MIMIC, IMP}, {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}

; $1c: POSSESS
battle_cmd_prop POSSESS, GOGO, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $1d: MAGITEK
battle_cmd_prop MAGITEK, {MIMIC, UNKNOWN}, MENU

; $1e:
battle_cmd_prop BATTLE_CMD_30, NONE, MENU

; $1f:
battle_cmd_prop BATTLE_CMD_31, NONE, MENU

; ------------------------------------------------------------------------------
