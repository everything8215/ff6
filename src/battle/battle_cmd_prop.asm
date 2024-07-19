
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: src/battle/battle_cmd_prop.asm                                       |
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

; ------------------------------------------------------------------------------

.mac make_battle_cmd_prop flags, target
        opflg .byte, BATTLE_CMD_FLAG, {flags}
        opflg .byte, TARGET, {target}
.endmac

; ------------------------------------------------------------------------------

; cf/fe00
BattleCmdProp:

; ------------------------------------------------------------------------------

; $00: fight
make_battle_cmd_prop {GOGO, MIMIC, IMP, UNKNOWN}, {MANUAL, INIT_SINGLE, ENEMY}

; $01: item
make_battle_cmd_prop {GOGO, MIMIC, IMP}, MENU

; $02: magic
make_battle_cmd_prop {GOGO, MIMIC, IMP}, MENU

; $03: morph
make_battle_cmd_prop NONE, SELF

; $04: revert
make_battle_cmd_prop IMP, SELF

; $05: steal
make_battle_cmd_prop {GOGO, MIMIC, UNKNOWN}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $06: capture
make_battle_cmd_prop {GOGO, MIMIC, UNKNOWN}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $07: swdtech
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $08: throw
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $09: tools
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $0a: blitz
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $0b: runic
make_battle_cmd_prop {GOGO, MIMIC}, SELF

; $0c: lore
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $0d: sketch
make_battle_cmd_prop {GOGO, MIMIC}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $0e: control
make_battle_cmd_prop {GOGO}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $0f: slot
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $10: rage
make_battle_cmd_prop {GOGO, MIMIC, UNKNOWN}, MENU

; $11: leap
make_battle_cmd_prop NONE, SELF

; $12: mimic
make_battle_cmd_prop {GOGO, IMP}, SELF

; $13: dance
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $14: row
make_battle_cmd_prop {IMP}, MENU

; $15: def
make_battle_cmd_prop {IMP}, MENU

; $16: jump
make_battle_cmd_prop {GOGO, IMP}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $17: x_magic
make_battle_cmd_prop {GOGO, MIMIC, IMP}, MENU

; $18: gp_rain
make_battle_cmd_prop {GOGO, MIMIC}, {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}

; $19: summon
make_battle_cmd_prop {GOGO, MIMIC}, MENU

; $1a: health
make_battle_cmd_prop {MIMIC, IMP}, {ONE_SIDE, INIT_HALF, MULTI_TARGET}

; $1b: shock
make_battle_cmd_prop {MIMIC, IMP}, {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}

; $1c: possess
make_battle_cmd_prop {GOGO}, {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}

; $1d: magitek
make_battle_cmd_prop {MIMIC, UNKNOWN}, MENU

; $1e:
make_battle_cmd_prop NONE, MENU

; $1f:
make_battle_cmd_prop NONE, MENU

; ------------------------------------------------------------------------------
