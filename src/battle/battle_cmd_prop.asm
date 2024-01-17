
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

; cf/fe00
BattleCmdProp:

; ------------------------------------------------------------------------------

; $00: fight
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_IMP|BATTLE_CMD_FLAG_UNKNOWN
.byte TARGET_MANUAL|TARGET_INIT_SINGLE|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $01: item
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_IMP
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $02: magic
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_IMP
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $03: morph
.byte BATTLE_CMD_FLAG_NONE
.byte TARGET_SELF

; ------------------------------------------------------------------------------

; $04: revert
.byte BATTLE_CMD_FLAG_IMP
.byte TARGET_SELF

; ------------------------------------------------------------------------------

; $05: steal
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_UNKNOWN
.byte TARGET_MANUAL|TARGET_ONE_SIDE|TARGET_INIT_SINGLE|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $06: capture
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_UNKNOWN
.byte TARGET_MANUAL|TARGET_ONE_SIDE|TARGET_INIT_SINGLE|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $07: swdtech
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $08: throw
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $09: tools
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $0a: blitz
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $0b: runic
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_SELF

; ------------------------------------------------------------------------------

; $0c: lore
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $0d: sketch
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MANUAL|TARGET_ONE_SIDE|TARGET_INIT_SINGLE|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $0e: control
.byte BATTLE_CMD_FLAG_GOGO
.byte TARGET_MANUAL|TARGET_ONE_SIDE|TARGET_INIT_SINGLE|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $0f: slot
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $10: rage
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_UNKNOWN
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $11: leap
.byte BATTLE_CMD_FLAG_NONE
.byte TARGET_SELF

; ------------------------------------------------------------------------------

; $12: mimic
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_IMP
.byte TARGET_SELF

; ------------------------------------------------------------------------------

; $13: dance
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $14: row
.byte BATTLE_CMD_FLAG_IMP
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $15: def
.byte BATTLE_CMD_FLAG_IMP
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $16: jump
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_IMP
.byte TARGET_MANUAL|TARGET_ONE_SIDE|TARGET_INIT_SINGLE|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $17: x_magic
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_IMP
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $18: gp_rain
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_ONE_SIDE|TARGET_INIT_GROUP|TARGET_MULTI_TARGET|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $19: summon
.byte BATTLE_CMD_FLAG_GOGO|BATTLE_CMD_FLAG_MIMIC
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $1a: health
.byte BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_IMP
.byte TARGET_ONE_SIDE|TARGET_INIT_HALF|TARGET_MULTI_TARGET

; ------------------------------------------------------------------------------

; $1b: shock
.byte BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_IMP
.byte TARGET_ONE_SIDE|TARGET_INIT_HALF|TARGET_MULTI_TARGET|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $1c: possess
.byte BATTLE_CMD_FLAG_GOGO
.byte TARGET_MANUAL|TARGET_ONE_SIDE|TARGET_INIT_SINGLE|TARGET_ENEMY

; ------------------------------------------------------------------------------

; $1d: magitek
.byte BATTLE_CMD_FLAG_MIMIC|BATTLE_CMD_FLAG_UNKNOWN
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $1e:
.byte BATTLE_CMD_FLAG_NONE
.byte TARGET_MENU

; ------------------------------------------------------------------------------

; $1f:
.byte BATTLE_CMD_FLAG_NONE
.byte TARGET_MENU

; ------------------------------------------------------------------------------
