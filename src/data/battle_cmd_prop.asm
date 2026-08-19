
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

; $00: fight
battle_cmd_prop FIGHT, {GOGO, MIMIC, IMP, UNKNOWN}, {MANUAL, INIT_SINGLE, ENEMY}

; $01: item
battle_cmd_prop ITEM, {GOGO, MIMIC, IMP}, MENU

; $02: magic
battle_cmd_prop MAGIC, {GOGO, MIMIC, IMP}, MENU

; $03: morph
battle_cmd_prop MORPH, NONE, SELF

; $04: revert
battle_cmd_prop REVERT, IMP, SELF

; $05: steal
battle_cmd_prop STEAL, {GOGO, MIMIC, UNKNOWN}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $06: capture
battle_cmd_prop CAPTURE, {GOGO, MIMIC, UNKNOWN}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $07: swdtech
battle_cmd_prop BUSHIDO, {GOGO, MIMIC}, MENU

; $08: throw
battle_cmd_prop THROW, {GOGO, MIMIC}, MENU

; $09: tools
battle_cmd_prop TOOLS, {GOGO, MIMIC}, MENU

; $0a: blitz
battle_cmd_prop BLITZ, {GOGO, MIMIC}, MENU

; $0b: runic
battle_cmd_prop RUNIC, {GOGO, MIMIC}, SELF

; $0c: lore
battle_cmd_prop LORE, {GOGO, MIMIC}, MENU

; $0d: sketch
battle_cmd_prop SKETCH, {GOGO, MIMIC}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $0e: control
battle_cmd_prop CONTROL, GOGO, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $0f: slot
battle_cmd_prop SLOT, {GOGO, MIMIC}, MENU

; $10: rage
battle_cmd_prop RAGE, {GOGO, MIMIC, UNKNOWN}, MENU

; $11: leap
battle_cmd_prop LEAP, NONE, SELF

; $12: mimic
battle_cmd_prop MIMIC, {GOGO, IMP}, SELF

; $13: dance
battle_cmd_prop DANCE, {GOGO, MIMIC}, MENU

; $14: row
battle_cmd_prop ROW, IMP, MENU

; $15: def
battle_cmd_prop DEF, IMP, MENU

; $16: jump
battle_cmd_prop JUMP, {GOGO, IMP}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $17: x_magic
battle_cmd_prop X_MAGIC, {GOGO, MIMIC, IMP}, MENU

; $18: gp_rain
battle_cmd_prop GP_RAIN, {GOGO, MIMIC}, {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}

; $19: summon
battle_cmd_prop SUMMON, {GOGO, MIMIC}, MENU

; $1a: health
battle_cmd_prop HEALTH, {MIMIC, IMP}, {ONE_SIDE, INIT_HALF, MULTI_TARGET}

; $1b: shock
battle_cmd_prop SHOCK, {MIMIC, IMP}, {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}

; $1c: possess
battle_cmd_prop POSSESS, GOGO, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $1d: magitek
battle_cmd_prop MAGITEK, {MIMIC, UNKNOWN}, MENU

; $1e:
battle_cmd_prop BATTLE_CMD_30, NONE, MENU

; $1f:
battle_cmd_prop BATTLE_CMD_31, NONE, MENU

; ------------------------------------------------------------------------------
