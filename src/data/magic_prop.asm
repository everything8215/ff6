.include "magic_prop.mac"

.export MagicProp

; ------------------------------------------------------------------------------

; c4/6ac0
.segment "magic_prop"

MagicProp:

; ------------------------------------------------------------------------------

; 0: FIRE
        magic_prop FIRE
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element FIRE
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 4
        spell_power 21
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 1: BLIZZARD
        magic_prop BLIZZARD
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element ICE
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 5
        spell_power 22
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 2: THUNDER
        magic_prop THUNDER
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 6
        spell_power 20
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 3: POISON
        magic_prop POISON
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        element POISON
        flags {INVERT_UNDEAD, RUNIC, AUTO_RETARGET}
        mp_cost 3
        spell_power 25
        hit_rate 100
        status12 POISON
        end_magic_prop

; ------------------------------------------------------------------------------

; 4: DRAIN
        magic_prop DRAIN
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {INVERT_UNDEAD, NO_REFLECT, RUNIC, AUTO_RETARGET, DRAIN}
        mp_cost 15
        spell_power 38
        hit_rate 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 5: FIRA
        magic_prop FIRA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element FIRE
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 20
        spell_power 60
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 6: BLIZZARA
        magic_prop BLIZZARA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element ICE
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 21
        spell_power 62
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 7: THUNDARA
        magic_prop THUNDARA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 22
        spell_power 61
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 8: BIO
        magic_prop BIO
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element POISON
        flags {INVERT_UNDEAD, RUNIC, AUTO_RETARGET}
        mp_cost 26
        spell_power 53
        hit_rate 120
        status12 POISON
        end_magic_prop

; ------------------------------------------------------------------------------

; 9: FIRAGA
        magic_prop FIRAGA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element FIRE
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 51
        spell_power 121
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 10: BLIZZAGA
        magic_prop BLIZZAGA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element ICE
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 52
        spell_power 122
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 11: THUNDAGA
        magic_prop THUNDAGA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 53
        spell_power 120
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 12: BREAK
        magic_prop BREAK
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, RUNIC, AUTO_RETARGET, STAMINA_DEF}
        mp_cost 25
        hit_rate 120
        status_block
        status12 PETRIFY
        end_magic_prop

; ------------------------------------------------------------------------------

; 13: DOOM
        magic_prop DOOM
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, RUNIC, AUTO_RETARGET, STAMINA_DEF}
        mp_cost 35
        hit_rate 95
        special_effect DOOM
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 14: HOLY
        magic_prop HOLY
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        element HOLY
        flags {RUNIC, AUTO_RETARGET}
        mp_cost 40
        spell_power 108
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 15: FLARE
        magic_prop FLARE
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, RUNIC, AUTO_RETARGET}
        mp_cost 45
        spell_power 60
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 16: DEMI
        magic_prop DEMI
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, NO_DMG_SPLIT, NO_REFLECT, RUNIC, AUTO_RETARGET, STAMINA_DEF, HP_FRAC}
        mp_cost 33
        spell_power 8
        hit_rate 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 17: QUARTR
        magic_prop QUARTR
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, NO_DMG_SPLIT, NO_REFLECT, RUNIC, AUTO_RETARGET, STAMINA_DEF, HP_FRAC}
        mp_cost 48
        spell_power 12
        hit_rate 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 18: DEZONE
        magic_prop DEZONE
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, RUNIC, AUTO_RETARGET, STAMINA_DEF}
        mp_cost 53
        hit_rate 85
        special_effect NO_RETAL
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 19: METEOR
        magic_prop METEOR
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 62
        spell_power 36
        end_magic_prop

; ------------------------------------------------------------------------------

; 20: ULTIMA
        magic_prop ULTIMA
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, RUNIC, AUTO_RETARGET, NO_DODGE}
        mp_cost 80
        spell_power 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 21: QUAKE
        magic_prop QUAKE
        targetting INIT_ALL
        element EARTH
        flags {RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, NO_DODGE}
        mp_cost 50
        spell_power 111
        hit_rate 150
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 22: TORNADO
        magic_prop TORNADO
        targetting INIT_ALL
        flags {INSTANT_DEATH, RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, STAMINA_DEF, HP_FRAC}
        mp_cost 75
        spell_power 15
        hit_rate 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 23: MELTDOWN
        magic_prop MELTDOWN
        targetting INIT_ALL
        element {FIRE, WIND}
        flags {RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, NO_DODGE}
        mp_cost 85
        spell_power 138
        end_magic_prop

; ------------------------------------------------------------------------------

; 24: SCAN
        magic_prop SCAN
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags RUNIC
        mp_cost 3
        hit_rate 222
        special_effect SCAN
        end_magic_prop

; ------------------------------------------------------------------------------

; 25: SLOW
        magic_prop SLOW
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags RUNIC
        mp_cost 5
        hit_rate 120
        status_block
        status34 SLOW
        end_magic_prop

; ------------------------------------------------------------------------------

; 26: RASP
        magic_prop RASP
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {INVERT_UNDEAD, RUNIC, AUTO_RETARGET, AFFECT_MP}
        mp_cost 12
        spell_power 10
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 27: MUTE
        magic_prop MUTE
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags RUNIC
        mp_cost 8
        hit_rate 100
        status_block
        status12 SILENCE
        end_magic_prop

; ------------------------------------------------------------------------------

; 28: SAFE
        magic_prop SAFE
        targetting {MANUAL, INIT_SINGLE}
        flags {RUNIC, NO_DODGE}
        mp_cost 12
        status34 SAFE
        end_magic_prop

; ------------------------------------------------------------------------------

; 29: SLEEP
        magic_prop SLEEP
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags RUNIC
        mp_cost 5
        hit_rate 111
        status_block
        status12 SLEEP
        end_magic_prop

; ------------------------------------------------------------------------------

; 30: CONFUSE
        magic_prop CONFUSE
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags RUNIC
        mp_cost 8
        hit_rate 94
        status_block
        status12 CONFUSE
        end_magic_prop

; ------------------------------------------------------------------------------

; 31: HASTE
        magic_prop HASTE
        targetting {MANUAL, INIT_SINGLE}
        flags {RUNIC, NO_DODGE}
        mp_cost 10
        status34 HASTE
        end_magic_prop

; ------------------------------------------------------------------------------

; 32: STOP
        magic_prop STOP
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags RUNIC
        mp_cost 10
        hit_rate 100
        status_block
        status34 STOP
        end_magic_prop

; ------------------------------------------------------------------------------

; 33: BERSERK
        magic_prop BERSERK
        targetting {MANUAL, INIT_SINGLE}
        flags RUNIC
        mp_cost 16
        hit_rate 150
        status_block
        status12 BERSERK
        end_magic_prop

; ------------------------------------------------------------------------------

; 34: FLOAT
        magic_prop FLOAT
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET}
        flags {MENU_USAGE, NO_REFLECT, RUNIC, NO_DODGE}
        mp_cost 17
        status34 FLOAT
        end_magic_prop

; ------------------------------------------------------------------------------

; 35: IMP
        magic_prop IMP
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {MENU_USAGE, RUNIC, TOGGLE_STATUS}
        mp_cost 10
        hit_rate 100
        status_block
        status12 IMP
        end_magic_prop

; ------------------------------------------------------------------------------

; 36: REFLECT
        magic_prop REFLECT
        targetting {MANUAL, INIT_SINGLE}
        flags {RUNIC, NO_DODGE}
        mp_cost 22
        status34 REFLECT
        end_magic_prop

; ------------------------------------------------------------------------------

; 37: SHELL
        magic_prop SHELL
        targetting {MANUAL, INIT_SINGLE}
        flags {RUNIC, NO_DODGE}
        mp_cost 15
        status34 SHELL
        end_magic_prop

; ------------------------------------------------------------------------------

; 38: VANISH
        magic_prop VANISH
        targetting {MANUAL, INIT_SINGLE}
        flags {NO_REFLECT, RUNIC, TOGGLE_STATUS, NO_DODGE}
        mp_cost 18
        status12 VANISH
        end_magic_prop

; ------------------------------------------------------------------------------

; 39: HASTE2
        magic_prop HASTE2
        targetting {MANUAL, INIT_GROUP, MULTI_TARGET}
        flags {RUNIC, NO_DODGE}
        mp_cost 38
        status34 HASTE
        end_magic_prop

; ------------------------------------------------------------------------------

; 40: SLOW_2
        magic_prop SLOW_2
        targetting {MANUAL, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags RUNIC
        mp_cost 26
        hit_rate 150
        status_block
        status34 SLOW
        end_magic_prop

; ------------------------------------------------------------------------------

; 41: OSMOSE
        magic_prop OSMOSE
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {INVERT_UNDEAD, NO_REFLECT, RUNIC, AUTO_RETARGET, AFFECT_MP, DRAIN}
        mp_cost 1
        spell_power 26
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 42: WARP
        magic_prop WARP
        flags {RANDOM_TARGET, MENU_USAGE, NO_REFLECT, QUICK_WARP, NO_DODGE}
        mp_cost 20
        special_effect WARP
        end_magic_prop

; ------------------------------------------------------------------------------

; 43: QUICK
        magic_prop QUICK
        targetting SELF
        flags {NO_REFLECT, QUICK_WARP, NO_DODGE}
        mp_cost 99
        special_effect QUICK
        end_magic_prop

; ------------------------------------------------------------------------------

; 44: DISPEL
        magic_prop DISPEL
        targetting {MANUAL, INIT_SINGLE, ENEMY}
        flags {MENU_USAGE, NO_REFLECT, RUNIC, REMOVE_STATUS, NO_DODGE}
        mp_cost 25
        status12 {VANISH, IMAGE, BERSERK}
        status34 {REGEN, SLOW, HASTE, STOP, SHELL, SAFE, REFLECT, RERAISE, FLOAT}
        end_magic_prop

; ------------------------------------------------------------------------------

; 45: CURE
        magic_prop CURE
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET}
        flags {INVERT_UNDEAD, IGNORE_DEF, MENU_USAGE, RUNIC, RESTORATIVE, NO_DODGE}
        mp_cost 5
        spell_power 10
        end_magic_prop

; ------------------------------------------------------------------------------

; 46: CURA
        magic_prop CURA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET}
        flags {INVERT_UNDEAD, IGNORE_DEF, MENU_USAGE, RUNIC, RESTORATIVE, NO_DODGE}
        mp_cost 25
        spell_power 28
        end_magic_prop

; ------------------------------------------------------------------------------

; 47: CURAGA
        magic_prop CURAGA
        targetting {MANUAL, INIT_SINGLE, MULTI_TARGET}
        flags {INVERT_UNDEAD, IGNORE_DEF, MENU_USAGE, RUNIC, RESTORATIVE, NO_DODGE}
        mp_cost 40
        spell_power 66
        end_magic_prop

; ------------------------------------------------------------------------------

; 48: RAISE
        magic_prop RAISE
        targetting {MANUAL, INIT_SINGLE}
        flags {RESURRECT, INVERT_UNDEAD, IGNORE_DEF, MENU_USAGE, NO_REFLECT, RUNIC, RESTORATIVE, REMOVE_STATUS, NO_DODGE, HP_FRAC}
        mp_cost 30
        spell_power 2
        status12 DEAD
        .if LANG_EN
        status34 HIDE
        .endif
        end_magic_prop

; ------------------------------------------------------------------------------

; 49: ARISE
        magic_prop ARISE
        targetting {MANUAL, INIT_SINGLE}
        flags {RESURRECT, INVERT_UNDEAD, IGNORE_DEF, MENU_USAGE, NO_REFLECT, RUNIC, RESTORATIVE, REMOVE_STATUS, NO_DODGE, HP_FRAC}
        mp_cost 60
        spell_power 16
        status12 DEAD
        .if LANG_EN
        status34 HIDE
        .endif
        end_magic_prop

; ------------------------------------------------------------------------------

; 50: POISONA
        magic_prop POISONA
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE}
        flags {MENU_USAGE, NO_REFLECT, RUNIC, REMOVE_STATUS, NO_DODGE}
        mp_cost 3
        status12 {POISON, SAP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 51: REMEDY
        magic_prop REMEDY
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE}
        flags {MENU_USAGE, NO_REFLECT, RUNIC, REMOVE_STATUS, NO_DODGE}
        mp_cost 15
        status12 {BLIND, POISON, PETRIFY, SILENCE, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 52: REGEN
        magic_prop REGEN
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE}
        flags {INVERT_UNDEAD, RUNIC, NO_DODGE}
        mp_cost 10
        status34 REGEN
        end_magic_prop

; ------------------------------------------------------------------------------

; 53: RERAISE
        magic_prop RERAISE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE}
        flags {NO_REFLECT, RUNIC, NO_DODGE}
        mp_cost 50
        status34 RERAISE
        end_magic_prop

; ------------------------------------------------------------------------------

; 54: RAMUH
        magic_prop RAMUH
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 25
        spell_power 50
        end_magic_prop

; ------------------------------------------------------------------------------

; 55: IFRIT
        magic_prop IFRIT
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element FIRE
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 26
        spell_power 51
        end_magic_prop

; ------------------------------------------------------------------------------

; 56: SHIVA
        magic_prop SHIVA
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element ICE
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 27
        spell_power 52
        end_magic_prop

; ------------------------------------------------------------------------------

; 57: SIREN
        magic_prop SIREN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {MONSTERS_ONLY, NO_REFLECT}
        mp_cost 16
        hit_rate 136
        status12 SILENCE
        end_magic_prop

; ------------------------------------------------------------------------------

; 58: TERRATO
        magic_prop TERRATO
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element EARTH
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 40
        spell_power 93
        hit_rate 150
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 59: SHOAT
        magic_prop SHOAT
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, MONSTERS_ONLY, NO_REFLECT, STAMINA_DEF}
        mp_cost 45
        hit_rate 96
        status_block
        status12 PETRIFY
        end_magic_prop

; ------------------------------------------------------------------------------

; 60: MADUIN
        magic_prop MADUIN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 44
        spell_power 55
        end_magic_prop

; ------------------------------------------------------------------------------

; 61: BISMARK
        magic_prop BISMARK
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element WATER
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 50
        spell_power 58
        end_magic_prop

; ------------------------------------------------------------------------------

; 62: STRAY
        magic_prop STRAY
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {MONSTERS_ONLY, NO_REFLECT}
        mp_cost 28
        hit_rate 128
        status_block
        status12 CONFUSE
        end_magic_prop

; ------------------------------------------------------------------------------

; 63: PALIDOR
        magic_prop PALIDOR
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {RANDOM_TARGET, IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 61
        special_effect PALIDOR
        status34 HIDE
        end_magic_prop

; ------------------------------------------------------------------------------

; 64: TRITOCH
        magic_prop TRITOCH
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element {FIRE, ICE, LIGHTNING}
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 68
        spell_power 110
        end_magic_prop

; ------------------------------------------------------------------------------

; 65: ODIN
        magic_prop ODIN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, MONSTERS_ONLY, NO_REFLECT, STAMINA_DEF}
        mp_cost 70
        hit_rate 110
        special_effect NO_RETAL
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 66: RAIDEN
        magic_prop RAIDEN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, MONSTERS_ONLY, NO_REFLECT, STAMINA_DEF}
        mp_cost 80
        hit_rate 140
        special_effect NO_RETAL
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 67: BAHAMUT
        magic_prop BAHAMUT
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 86
        spell_power 92
        end_magic_prop

; ------------------------------------------------------------------------------

; 68: ALEXANDR
        magic_prop ALEXANDR
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element HOLY
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 90
        spell_power 114
        end_magic_prop

; ------------------------------------------------------------------------------

; 69: CRUSADER
        magic_prop CRUSADER
        targetting INIT_ALL
        flags {NO_DMG_SPLIT, NO_REFLECT, NO_DODGE}
        mp_cost 96
        spell_power 190
        special_effect CRUSADER
        end_magic_prop

; ------------------------------------------------------------------------------

; 70: RAGNAROK
        magic_prop RAGNAROK
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {MONSTERS_ONLY, NO_REFLECT, NO_DODGE}
        mp_cost 6
        special_effect METAMORPH
        end_magic_prop

; ------------------------------------------------------------------------------

; 71: KIRIN
        magic_prop KIRIN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {INVERT_UNDEAD, NO_REFLECT, NO_DODGE}
        mp_cost 18
        status34 REGEN
        end_magic_prop

; ------------------------------------------------------------------------------

; 72: ZONESEEK
        magic_prop ZONESEEK
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {NO_REFLECT, NO_DODGE}
        mp_cost 30
        status34 SHELL
        end_magic_prop

; ------------------------------------------------------------------------------

; 73: CARBUNKL
        magic_prop CARBUNKL
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {NO_REFLECT, NO_DODGE}
        mp_cost 36
        status34 REFLECT
        end_magic_prop

; ------------------------------------------------------------------------------

; 74: PHANTOM
        magic_prop PHANTOM
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {NO_REFLECT, NO_DODGE}
        mp_cost 38
        status12 VANISH
        end_magic_prop

; ------------------------------------------------------------------------------

; 75: SRAPHIM
        magic_prop SRAPHIM
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {INVERT_UNDEAD, IGNORE_DEF, NO_REFLECT, RESTORATIVE, NO_DODGE}
        mp_cost 40
        spell_power 18
        end_magic_prop

; ------------------------------------------------------------------------------

; 76: GOLEM
        magic_prop GOLEM
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {NO_REFLECT, NO_DODGE}
        mp_cost 33
        special_effect GOLEM_BLOCK
        end_magic_prop

; ------------------------------------------------------------------------------

; 77: UNICORN
        magic_prop UNICORN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {NO_REFLECT, REMOVE_STATUS, NO_DODGE}
        mp_cost 30
        status12 {BLIND, POISON, PETRIFY, SILENCE, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 78: FENRIR
        magic_prop FENRIR
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {NO_REFLECT, NO_DODGE}
        mp_cost 70
        status12 IMAGE
        end_magic_prop

; ------------------------------------------------------------------------------

; 79: STARLET
        magic_prop STARLET
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {INVERT_UNDEAD, IGNORE_DEF, NO_REFLECT, RESTORATIVE, NO_DODGE}
        mp_cost 74
        spell_power 34
        end_magic_prop

; ------------------------------------------------------------------------------

; 80: PHOENIX
        magic_prop PHOENIX
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {RESURRECT, INVERT_UNDEAD, NO_REFLECT, RESTORATIVE, REMOVE_STATUS, NO_DODGE, HP_FRAC}
        mp_cost 110
        spell_power 4
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 81: FIRE_SKEAN
        magic_prop FIRE_SKEAN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element FIRE
        flags {NO_REFLECT, NO_DODGE}
        spell_power 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 82: WATER_EDGE
        magic_prop WATER_EDGE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element WATER
        flags {NO_REFLECT, NO_DODGE}
        spell_power 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 83: BOLT_EDGE
        magic_prop BOLT_EDGE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {NO_REFLECT, NO_DODGE}
        spell_power 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 84: STORM
        magic_prop STORM
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        element ICE
        flags {RANDOM_TARGET, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 85: DISPATCH
        magic_prop DISPATCH
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {PHYSICAL, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 86: RETORT
        magic_prop RETORT
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 56
        special_effect RETORT
        end_magic_prop

; ------------------------------------------------------------------------------

; 87: SLASH
        magic_prop SLASH
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {PHYSICAL, INSTANT_DEATH, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE, HP_FRAC}
        spell_power 8
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 88: QUADRA_SLAM
        magic_prop QUADRA_SLAM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {PHYSICAL, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 72
        special_effect QUADRA_SLAM
        end_magic_prop

; ------------------------------------------------------------------------------

; 89: EMPOWERER
        magic_prop EMPOWERER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {INVERT_UNDEAD, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, AFFECT_MP, DRAIN, NO_DODGE}
        spell_power 49
        special_effect EMPOWERER
        end_magic_prop

; ------------------------------------------------------------------------------

; 90: STUNNER
        magic_prop STUNNER
        targetting {ONE_SIDE, INIT_GROUP, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 97
        hit_rate 140
        special_effect STUNNER
        status34 STOP
        end_magic_prop

; ------------------------------------------------------------------------------

; 91: QUADRA_SLICE
        magic_prop QUADRA_SLICE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {PHYSICAL, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 70
        special_effect QUADRA_SLAM
        end_magic_prop

; ------------------------------------------------------------------------------

; 92: CLEAVE
        magic_prop CLEAVE
        targetting {ONE_SIDE, INIT_GROUP, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET}
        hit_rate 182
        special_effect NO_RETAL
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 93: PUMMEL
        magic_prop PUMMEL
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {PHYSICAL, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 110
        special_effect NO_EFFECT
        end_magic_prop

; ------------------------------------------------------------------------------

; 94: AURABOLT
        magic_prop AURABOLT
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        element HOLY
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 68
        end_magic_prop

; ------------------------------------------------------------------------------

; 95: SUPLEX
        magic_prop SUPLEX
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        flags {PHYSICAL, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 180
        special_effect SUPLEX
        end_magic_prop

; ------------------------------------------------------------------------------

; 96: FIRE_DANCE
        magic_prop FIRE_DANCE
        targetting {ONE_SIDE, INIT_GROUP, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        element FIRE
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 42
        end_magic_prop

; ------------------------------------------------------------------------------

; 97: MANTRA
        magic_prop MANTRA
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {INVERT_UNDEAD, RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, RESTORATIVE, REMOVE_STATUS, NO_DODGE}
        spell_power 1
        special_effect MANTRA
        status12 {BLIND, POISON, SILENCE, SAP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 98: AIR_BLADE
        magic_prop AIR_BLADE
        targetting {ONE_SIDE, INIT_GROUP, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        element WIND
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 78
        end_magic_prop

; ------------------------------------------------------------------------------

; 99: SPIRALER
        magic_prop SPIRALER
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {INVERT_UNDEAD, RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, RESTORATIVE, REMOVE_STATUS, NO_DODGE}
        spell_power 200
        special_effect SPIRALER
        status12 {BLIND, ZOMBIE, POISON, IMP, PETRIFY, CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP, FROZEN}
        end_magic_prop

; ------------------------------------------------------------------------------

; 100: BUM_RUSH
        magic_prop BUM_RUSH
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 128
        end_magic_prop

; ------------------------------------------------------------------------------

; 101: WIND_SLASH
        magic_prop WIND_SLASH
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        element WIND
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, NO_DODGE}
        spell_power 48
        end_magic_prop

; ------------------------------------------------------------------------------

; 102: SUN_BATH
        magic_prop SUN_BATH
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {INVERT_UNDEAD, RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, RESTORATIVE, NO_DODGE}
        spell_power 50
        end_magic_prop

; ------------------------------------------------------------------------------

; 103: RAGE
        magic_prop RAGE
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, NO_DODGE}
        spell_power 50
        end_magic_prop

; ------------------------------------------------------------------------------

; 104: HARVESTER
        magic_prop HARVESTER
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {RANDOM_TARGET, NO_REFLECT, REMOVE_STATUS, NO_DODGE}
        status12 {BLIND, POISON, PETRIFY, SILENCE, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 105: SAND_STORM
        magic_prop SAND_STORM
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        element WIND
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT}
        spell_power 45
        hit_rate 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 106: ANTLION
        magic_prop ANTLION
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, STAMINA_DEF}
        hit_rate 100
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 107: ELF_FIRE
        magic_prop ELF_FIRE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        element FIRE
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 72
        end_magic_prop

; ------------------------------------------------------------------------------

; 108: SPECTER
        magic_prop SPECTER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        hit_rate 120
        status_block
        status12 CONFUSE
        end_magic_prop

; ------------------------------------------------------------------------------

; 109: LAND_SLIDE
        magic_prop LAND_SLIDE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 65
        end_magic_prop

; ------------------------------------------------------------------------------

; 110: SONIC_BOOM
        magic_prop SONIC_BOOM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, NO_DODGE, HP_FRAC}
        spell_power 10
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 111: EL_NINO
        magic_prop EL_NINO
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        element WATER
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, NO_DODGE}
        spell_power 61
        end_magic_prop

; ------------------------------------------------------------------------------

; 112: PLASMA
        magic_prop PLASMA
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        element LIGHTNING
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 70
        end_magic_prop

; ------------------------------------------------------------------------------

; 113: SNARE
        magic_prop SNARE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, STAMINA_DEF}
        hit_rate 100
        special_effect NO_RETAL
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 114: CAVE_IN
        magic_prop CAVE_IN
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, NO_DODGE, HP_FRAC}
        spell_power 12
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 115: SNOWBALL
        magic_prop SNOWBALL
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, NO_DODGE, HP_FRAC}
        spell_power 8
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 116: SURGE
        magic_prop SURGE
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        element ICE
        flags {RANDOM_TARGET, NO_DMG_SPLIT, NO_REFLECT, NO_DODGE}
        spell_power 55
        end_magic_prop

; ------------------------------------------------------------------------------

; 117: COKATRICE
        magic_prop COKATRICE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {INSTANT_DEATH, IGNORE_DEF, NO_REFLECT, AUTO_RETARGET}
        spell_power 50
        hit_rate 96
        status12 PETRIFY
        end_magic_prop

; ------------------------------------------------------------------------------

; 118: WOMBAT
        magic_prop WOMBAT
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 88
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 119: KITTY
        magic_prop KITTY
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {RANDOM_TARGET, NO_REFLECT, NO_DODGE}
        status34 HASTE
        end_magic_prop

; ------------------------------------------------------------------------------

; 120: TAPIR
        magic_prop TAPIR
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {RANDOM_TARGET, NO_REFLECT, RESTORATIVE, REMOVE_STATUS, NO_DODGE}
        special_effect TAPIR
        status12 {BLIND, ZOMBIE, POISON, IMP, PETRIFY, CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 121: WHUMP
        magic_prop WHUMP
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 53
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 122: WILD_BEAR
        magic_prop WILD_BEAR
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {INVERT_UNDEAD, RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, RESTORATIVE, REMOVE_STATUS, NO_DODGE}
        spell_power 100
        status12 {BLIND, ZOMBIE, POISON, PETRIFY, CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP, FROZEN}
        end_magic_prop

; ------------------------------------------------------------------------------

; 123: POIS_FROG
        magic_prop POIS_FROG
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        element POISON
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 56
        status12 POISON
        end_magic_prop

; ------------------------------------------------------------------------------

; 124: ICE_RABBIT
        magic_prop ICE_RABBIT
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {INVERT_UNDEAD, RANDOM_TARGET, IGNORE_DEF, NO_REFLECT, RESTORATIVE, NO_DODGE}
        spell_power 60
        end_magic_prop

; ------------------------------------------------------------------------------

; 125: BIO_BLAST_TOOL
        magic_prop BIO_BLAST_TOOL
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element POISON
        flags {NO_DMG_SPLIT, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 20
        status12 POISON
        end_magic_prop

; ------------------------------------------------------------------------------

; 126: FLASH_TOOL
        magic_prop FLASH_TOOL
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_DMG_SPLIT, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET}
        spell_power 42
        hit_rate 128
        status12 BLIND
        end_magic_prop

; ------------------------------------------------------------------------------

; 127: CHOCOBOP
        magic_prop CHOCOBOP
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        flags {RANDOM_TARGET, IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, NO_DODGE}
        spell_power 36
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 128: H_BOMB
        magic_prop H_BOMB
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        flags {RANDOM_TARGET, NO_REFLECT, NO_DODGE}
        spell_power 130
        end_magic_prop

; ------------------------------------------------------------------------------

; 129: SEVEN_FLUSH
        magic_prop SEVEN_FLUSH
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET, ENEMY}
        flags {RANDOM_TARGET, NO_REFLECT, NO_DODGE}
        spell_power 84
        end_magic_prop

; ------------------------------------------------------------------------------

; 130: SHOCK
        magic_prop SHOCK
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, NO_DODGE}
        spell_power 128
        end_magic_prop

; ------------------------------------------------------------------------------

; 131: FIRE_BEAM
        magic_prop FIRE_BEAM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        element FIRE
        flags {AUTO_RETARGET, NO_DODGE}
        spell_power 60
        end_magic_prop

; ------------------------------------------------------------------------------

; 132: BOLT_BEAM
        magic_prop BOLT_BEAM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        element LIGHTNING
        flags {AUTO_RETARGET, NO_DODGE}
        spell_power 62
        end_magic_prop

; ------------------------------------------------------------------------------

; 133: ICE_BEAM
        magic_prop ICE_BEAM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        element ICE
        flags {AUTO_RETARGET, NO_DODGE}
        spell_power 61
        end_magic_prop

; ------------------------------------------------------------------------------

; 134: BIO_BLAST_MAGITEK
        magic_prop BIO_BLAST_MAGITEK
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element POISON
        flags {NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 60
        status12 {POISON, SAP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 135: HEAL_FORCE
        magic_prop HEAL_FORCE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE}
        flags {INVERT_UNDEAD, IGNORE_DEF, NO_REFLECT, RESTORATIVE, NO_DODGE}
        spell_power 50
        end_magic_prop

; ------------------------------------------------------------------------------

; 136: CONFUSER
        magic_prop CONFUSER
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        hit_rate 128
        status_block
        status12 CONFUSE
        end_magic_prop

; ------------------------------------------------------------------------------

; 137: XFER
        magic_prop XFER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, STAMINA_DEF}
        hit_rate 120
        special_effect NO_RETAL
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 138: TEKMISSILE
        magic_prop TEKMISSILE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 58
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 139: CONDEMNED
        magic_prop CONDEMNED
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, LORE, NO_DODGE}
        mp_cost 20
        status_block
        status12 CONDEMNED
        end_magic_prop

; ------------------------------------------------------------------------------

; 140: ROULETTE
        magic_prop ROULETTE
        targetting {INIT_SINGLE, ENEMY, ROULETTE}
        flags {INSTANT_DEATH, NO_REFLECT, LORE, AUTO_RETARGET, NO_DODGE}
        mp_cost 10
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 141: CLEANSWEEP
        magic_prop CLEANSWEEP
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element WATER
        flags {NO_DMG_SPLIT, NO_REFLECT, LORE, AUTO_RETARGET}
        mp_cost 30
        spell_power 50
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 142: AQUA_RAKE
        magic_prop AQUA_RAKE
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element {WIND, WATER}
        flags {NO_REFLECT, LORE, AUTO_RETARGET}
        mp_cost 22
        spell_power 71
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 143: AERO
        magic_prop AERO
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element WIND
        flags {NO_REFLECT, LORE, AUTO_RETARGET}
        mp_cost 41
        spell_power 125
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 144: BLOW_FISH
        magic_prop BLOW_FISH
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, LORE, AUTO_RETARGET, NO_DODGE}
        mp_cost 50
        spell_power 1
        special_effect BLOW_FISH
        end_magic_prop

; ------------------------------------------------------------------------------

; 145: BIG_GUARD
        magic_prop BIG_GUARD
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {NO_REFLECT, LORE, NO_DODGE}
        mp_cost 80
        status34 {SHELL, SAFE}
        end_magic_prop

; ------------------------------------------------------------------------------

; 146: REVENGE
        magic_prop REVENGE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, LORE, AUTO_RETARGET, NO_DODGE}
        mp_cost 31
        spell_power 1
        special_effect REVENGE
        end_magic_prop

; ------------------------------------------------------------------------------

; 147: WHITE_WIND
        magic_prop WHITE_WIND
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        flags {INVERT_UNDEAD, IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, LORE, RESTORATIVE, NO_DODGE}
        mp_cost 45
        spell_power 1
        special_effect WHITE_WIND
        end_magic_prop

; ------------------------------------------------------------------------------

; 148: L5_DOOM
        magic_prop L5_DOOM
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, LORE, LEVEL_DIV}
        mp_cost 22
        hit_rate 5
        status_block
        show_msg
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 149: L4_FLARE
        magic_prop L4_FLARE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, LORE, LEVEL_DIV}
        mp_cost 42
        spell_power 66
        hit_rate 4
        show_msg
        end_magic_prop

; ------------------------------------------------------------------------------

; 150: L3_CONFUSE
        magic_prop L3_CONFUSE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, LORE, LEVEL_DIV}
        mp_cost 28
        hit_rate 3
        status_block
        show_msg
        status12 CONFUSE
        end_magic_prop

; ------------------------------------------------------------------------------

; 151: REFLECT_LORE
        magic_prop REFLECT_LORE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, LORE, NO_DODGE}
        special_effect REFLECT_LORE
        status_block
        show_msg
        status12 {BLIND, SILENCE}
        status34 SLOW
        end_magic_prop

; ------------------------------------------------------------------------------

; 152: PEARL_LORE
        magic_prop PEARL_LORE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element HOLY
        flags {NO_REFLECT, LORE, LEVEL_DIV}
        mp_cost 50
        spell_power 120
        special_effect PEARL_LORE
        show_msg
        end_magic_prop

; ------------------------------------------------------------------------------

; 153: STEP_MINE
        magic_prop STEP_MINE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, LORE, NO_DODGE}
        mp_cost 1
        spell_power 32
        special_effect STEP_MINE
        end_magic_prop

; ------------------------------------------------------------------------------

; 154: FORCEFIELD
        magic_prop FORCEFIELD
        targetting INIT_ALL
        flags {NO_REFLECT, LORE, NO_DODGE}
        mp_cost 24
        special_effect FORCEFIELD
        end_magic_prop

; ------------------------------------------------------------------------------

; 155: DISCHORD
        magic_prop DISCHORD
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, LORE, AUTO_RETARGET}
        mp_cost 68
        hit_rate 100
        special_effect DISCHORD
        show_msg
        end_magic_prop

; ------------------------------------------------------------------------------

; 156: SOUR_MOUTH
        magic_prop SOUR_MOUTH
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, LORE, AUTO_RETARGET}
        mp_cost 32
        hit_rate 100
        status_block
        status12 {BLIND, POISON, IMP, SILENCE, CONFUSE, SLEEP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 157: PEP_UP
        magic_prop PEP_UP
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE}
        flags {NO_REFLECT, LORE, AUTO_RETARGET, AIR_ANCHOR, RESTORATIVE, REMOVE_STATUS, NO_DODGE, HP_FRAC}
        mp_cost 1
        spell_power 16
        special_effect PEP_UP
        status12 {BLIND, ZOMBIE, POISON, PETRIFY, CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 158: RIPPLER
        magic_prop RIPPLER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, LORE, AUTO_RETARGET}
        mp_cost 66
        hit_rate 111
        special_effect RIPPLER
        status_block
        show_msg
        status12 {BLIND, ZOMBIE, POISON, VANISH, IMP, CONDEMNED, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        status34 {REGEN, SLOW, HASTE, STOP, SHELL, SAFE, REFLECT, RERAISE, FLOAT}
        end_magic_prop

; ------------------------------------------------------------------------------

; 159: STONE
        magic_prop STONE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, LORE, AUTO_RETARGET}
        mp_cost 22
        spell_power 40
        hit_rate 75
        special_effect STONE
        show_msg
        status12 CONFUSE
        end_magic_prop

; ------------------------------------------------------------------------------

; 160: QUASAR
        magic_prop QUASAR
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, LORE, NO_DODGE}
        mp_cost 50
        spell_power 57
        end_magic_prop

; ------------------------------------------------------------------------------

; 161: GRANDTRAIN
        magic_prop GRANDTRAIN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, LORE, NO_DODGE}
        mp_cost 64
        spell_power 84
        end_magic_prop

; ------------------------------------------------------------------------------

; 162: EXPLODER
        magic_prop EXPLODER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, LORE, AUTO_RETARGET, AIR_ANCHOR, NO_DODGE}
        mp_cost 1
        spell_power 1
        special_effect EXPLODER
        end_magic_prop

; ------------------------------------------------------------------------------

; 163: IMP_SONG
        magic_prop IMP_SONG
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, TOGGLE_STATUS}
        mp_cost 20
        hit_rate 100
        status_block
        show_msg
        status12 IMP
        end_magic_prop

; ------------------------------------------------------------------------------

; 164: CLEAR
        magic_prop CLEAR
        targetting SELF
        flags {NO_REFLECT, NO_DODGE}
        mp_cost 20
        special_effect CLEAR
        status12 {BLIND, POISON, IMP, CONDEMNED, SILENCE, CONFUSE, SAP, SLEEP}
        status34 STOP
        end_magic_prop

; ------------------------------------------------------------------------------

; 165: VIRITE
        magic_prop VIRITE
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element POISON
        flags {INVERT_UNDEAD, NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 20
        hit_rate 80
        status12 POISON
        end_magic_prop

; ------------------------------------------------------------------------------

; 166: CHOKESMOKE
        magic_prop CHOKESMOKE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {RESURRECT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        status_block
        show_msg
        status12 ZOMBIE
        end_magic_prop

; ------------------------------------------------------------------------------

; 167: SCHILLER
        magic_prop SCHILLER
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 80
        status_block
        status12 BLIND
        end_magic_prop

; ------------------------------------------------------------------------------

; 168: LULLABY
        magic_prop LULLABY
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 90
        status_block
        status12 SLEEP
        end_magic_prop

; ------------------------------------------------------------------------------

; 169: ACID_RAIN
        magic_prop ACID_RAIN
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element {POISON, WATER}
        flags {INVERT_UNDEAD, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 25
        hit_rate 100
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 170: CONFUSION
        magic_prop CONFUSION
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 68
        status_block
        status12 CONFUSE
        end_magic_prop

; ------------------------------------------------------------------------------

; 171: MEGAZERK
        magic_prop MEGAZERK
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, RUNIC, NO_DODGE}
        mp_cost 20
        status12 BERSERK
        end_magic_prop

; ------------------------------------------------------------------------------

; 172: ENEMY_MUTE
        magic_prop ENEMY_MUTE
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 90
        status_block
        status12 SILENCE
        end_magic_prop

; ------------------------------------------------------------------------------

; 173: NET
        magic_prop NET
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 100
        status_block
        status34 STOP
        end_magic_prop

; ------------------------------------------------------------------------------

; 174: SLIMER
        magic_prop SLIMER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 100
        status_block
        status34 SLOW
        end_magic_prop

; ------------------------------------------------------------------------------

; 175: DELTA_HIT
        magic_prop DELTA_HIT
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        status_block
        status12 PETRIFY
        end_magic_prop

; ------------------------------------------------------------------------------

; 176: ENTWINE
        magic_prop ENTWINE
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        status_block
        status34 SLOW
        end_magic_prop

; ------------------------------------------------------------------------------

; 177: BLASTER
        magic_prop BLASTER
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, RUNIC, AUTO_RETARGET}
        mp_cost 20
        hit_rate 70
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 178: CYCLONIC
        magic_prop CYCLONIC
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, HP_FRAC}
        mp_cost 20
        spell_power 15
        hit_rate 75
        status12 NEAR_FATAL
        end_magic_prop

; ------------------------------------------------------------------------------

; 179: FIRE_BALL
        magic_prop FIRE_BALL
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element FIRE
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 50
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 180: ATOMIC_RAY
        magic_prop ATOMIC_RAY
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element FIRE
        flags {NO_REFLECT, RUNIC, AUTO_RETARGET}
        mp_cost 20
        spell_power 80
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 181: TEK_LASER
        magic_prop TEK_LASER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        element LIGHTNING
        flags {NO_REFLECT, RUNIC, AUTO_RETARGET}
        mp_cost 20
        spell_power 20
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 182: DIFFUSER
        magic_prop DIFFUSER
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {NO_REFLECT, RUNIC, AUTO_RETARGET}
        mp_cost 20
        spell_power 62
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 183: WAVECANNON
        magic_prop WAVECANNON
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 110
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 184: MEGA_VOLT
        magic_prop MEGA_VOLT
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {NO_REFLECT, RUNIC, AUTO_RETARGET}
        mp_cost 20
        spell_power 20
        hit_rate 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 185: GIGA_VOLT
        magic_prop GIGA_VOLT
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element LIGHTNING
        flags {NO_REFLECT, RUNIC, AUTO_RETARGET}
        mp_cost 20
        spell_power 110
        hit_rate 130
        end_magic_prop

; ------------------------------------------------------------------------------

; 186: SNOWSTORM
        magic_prop SNOWSTORM
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element ICE
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 25
        hit_rate 140
        end_magic_prop

; ------------------------------------------------------------------------------

; 187: ABSOLUTE0
        magic_prop ABSOLUTE0
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element ICE
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 110
        hit_rate 140
        end_magic_prop

; ------------------------------------------------------------------------------

; 188: MAGNITUDE8
        magic_prop MAGNITUDE8
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element EARTH
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 100
        hit_rate 130
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 189: RAID
        magic_prop RAID
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INVERT_UNDEAD, NO_REFLECT, AUTO_RETARGET, DRAIN}
        mp_cost 20
        spell_power 40
        hit_rate 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 190: FLASH_RAIN
        magic_prop FLASH_RAIN
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element {ICE, WATER}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 60
        hit_rate 140
        end_magic_prop

; ------------------------------------------------------------------------------

; 191: TEKBARRIER
        magic_prop TEKBARRIER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE}
        flags {AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        status34 {SAFE, REFLECT}
        end_magic_prop

; ------------------------------------------------------------------------------

; 192: FALLEN_ONE
        magic_prop FALLEN_ONE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        special_effect FALLEN_ONE
        end_magic_prop

; ------------------------------------------------------------------------------

; 193: WALLCHANGE
        magic_prop WALLCHANGE
        targetting {ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM}
        flags {NO_REFLECT, NO_DODGE}
        special_effect WALLCHANGE
        end_magic_prop

; ------------------------------------------------------------------------------

; 194: ESCAPE
        magic_prop ESCAPE
        targetting SELF
        flags {NO_REFLECT, NO_DODGE}
        special_effect ESCAPE
        status34 HIDE
        end_magic_prop

; ------------------------------------------------------------------------------

; 195: FIFTY_GS
        magic_prop FIFTY_GS
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, RUNIC, REMOVE_STATUS, NO_DODGE}
        mp_cost 20
        status34 FLOAT
        end_magic_prop

; ------------------------------------------------------------------------------

; 196: MIND_BLAST
        magic_prop MIND_BLAST
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags NO_REFLECT
        mp_cost 20
        hit_rate 110
        special_effect MIND_BLAST
        status_block
        status12 {BLIND, ZOMBIE, POISON, IMP, PETRIFY, CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        status34 {SLOW, STOP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 197: N_CROSS
        magic_prop N_CROSS
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element ICE
        flags {NO_REFLECT, RUNIC}
        mp_cost 20
        hit_rate 90
        special_effect N_CROSS
        status_block
        show_msg
        status34 FROZEN
        end_magic_prop

; ------------------------------------------------------------------------------

; 198: FLARE_STAR
        magic_prop FLARE_STAR
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element FIRE
        flags {IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        spell_power 80
        special_effect FLARE_STAR
        end_magic_prop

; ------------------------------------------------------------------------------

; 199: LOVE_TOKEN
        magic_prop LOVE_TOKEN
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        special_effect LOVE_TOKEN
        show_msg
        end_magic_prop

; ------------------------------------------------------------------------------

; 200: SEIZE
        magic_prop SEIZE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, REMOVE_STATUS, NO_DODGE}
        special_effect SEIZE
        status34 SLOW
        end_magic_prop

; ------------------------------------------------------------------------------

; 201: R_POLARITY
        magic_prop R_POLARITY
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        special_effect R_POLARITY
        end_magic_prop

; ------------------------------------------------------------------------------

; 202: TARGETTING
        magic_prop TARGETTING
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        special_effect TARGETTING
        end_magic_prop

; ------------------------------------------------------------------------------

; 203: SNEEZE
        magic_prop SNEEZE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        special_effect SNEEZE
        status_block
        status34 HIDE
        end_magic_prop

; ------------------------------------------------------------------------------

; 204: S_CROSS
        magic_prop S_CROSS
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        element FIRE
        flags {NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 120
        hit_rate 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 205: LAUNCHER
        magic_prop LAUNCHER
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, RANDOM_TARGET, IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET, HP_FRAC}
        mp_cost 20
        spell_power 8
        hit_rate 100
        special_effect LAUNCHER
        end_magic_prop

; ------------------------------------------------------------------------------

; 206: CHARM
        magic_prop CHARM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 80
        special_effect CHARM
        show_msg
        end_magic_prop

; ------------------------------------------------------------------------------

; 207: COLD_DUST
        magic_prop COLD_DUST
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        element ICE
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        status_block
        show_msg
        status34 FROZEN
        end_magic_prop

; ------------------------------------------------------------------------------

; 208: TENTACLE
        magic_prop TENTACLE
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {PHYSICAL, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 146
        end_magic_prop

; ------------------------------------------------------------------------------

; 209: HYPERDRIVE
        magic_prop HYPERDRIVE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, NO_REFLECT, RUNIC, AUTO_RETARGET, NO_DODGE}
        spell_power 118
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 210: TRAIN
        magic_prop TRAIN
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        status12 {BLIND, SILENCE}
        end_magic_prop

; ------------------------------------------------------------------------------

; 211: EVIL_TOOT
        magic_prop EVIL_TOOT
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags NO_REFLECT
        mp_cost 20
        hit_rate 120
        special_effect EVIL_TOOT
        status_block
        status12 {BLIND, POISON, IMP, CONDEMNED, BERSERK, CONFUSE, SAP}
        status34 SLOW
        end_magic_prop

; ------------------------------------------------------------------------------

; 212: GRAV_BOMB
        magic_prop GRAV_BOMB
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, RANDOM_TARGET, NO_REFLECT, AUTO_RETARGET, STAMINA_DEF, HP_FRAC}
        mp_cost 20
        spell_power 8
        hit_rate 100
        end_magic_prop

; ------------------------------------------------------------------------------

; 213: ENGULF
        magic_prop ENGULF
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {RANDOM_TARGET, NO_REFLECT, NO_DODGE}
        special_effect ENGULF
        show_msg
        end_magic_prop

; ------------------------------------------------------------------------------

; 214: DISASTER
        magic_prop DISASTER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, RUNIC, AUTO_RETARGET}
        mp_cost 20
        hit_rate 62
        status_block
        status12 {BLIND, IMP, CONDEMNED, SILENCE, CONFUSE}
        status34 FLOAT
        end_magic_prop

; ------------------------------------------------------------------------------

; 215: SHRAPNEL
        magic_prop SHRAPNEL
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 120
        hit_rate 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 216: BOMBLET
        magic_prop BOMBLET
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        end_magic_prop

; ------------------------------------------------------------------------------

; 217: HEART_BURN
        magic_prop HEART_BURN
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 30
        hit_rate 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 218: ZINGER
        magic_prop ZINGER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        special_effect ZINGER
        end_magic_prop

; ------------------------------------------------------------------------------

; 219: DISCARD
        magic_prop DISCARD
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, NO_DODGE}
        special_effect DISCARD
        end_magic_prop

; ------------------------------------------------------------------------------

; 220: OVERCAST
        magic_prop OVERCAST
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        special_effect OVERCAST
        show_msg
        status12 CONDEMNED
        end_magic_prop

; ------------------------------------------------------------------------------

; 221: MISSILE
        magic_prop MISSILE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, HP_FRAC}
        mp_cost 20
        spell_power 4
        hit_rate 126
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 222: GONER
        magic_prop GONER
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        spell_power 220
        end_magic_prop

; ------------------------------------------------------------------------------

; 223: METEO
        magic_prop METEO
        targetting {MANUAL, ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {IGNORE_DEF, NO_DMG_SPLIT, NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 60
        hit_rate 80
        end_magic_prop

; ------------------------------------------------------------------------------

; 224: REVENGER
        magic_prop REVENGER
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, REMOVE_STATUS, NO_DODGE}
        status_block
        status12 {VANISH, IMAGE}
        status34 {REGEN, HASTE, SHELL, SAFE, REFLECT, RERAISE, FLOAT}
        end_magic_prop

; ------------------------------------------------------------------------------

; 225: PHANTASM
        magic_prop PHANTASM
        targetting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        special_effect PHANTASM
        show_msg
        end_magic_prop

; ------------------------------------------------------------------------------

; 226: DREAD
        magic_prop DREAD
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        hit_rate 75
        status_block
        status12 PETRIFY
        end_magic_prop

; ------------------------------------------------------------------------------

; 227: SHOCK_WAVE
        magic_prop SHOCK_WAVE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 25
        hit_rate 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 228: BLAZE
        magic_prop BLAZE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, MULTI_TARGET, ENEMY}
        element FIRE
        flags {NO_REFLECT, AUTO_RETARGET}
        mp_cost 20
        spell_power 68
        hit_rate 120
        end_magic_prop

; ------------------------------------------------------------------------------

; 229: SOUL_OUT
        magic_prop SOUL_OUT
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        status_block
        show_msg
        status12 ZOMBIE
        end_magic_prop

; ------------------------------------------------------------------------------

; 230: GALE_CUT
        magic_prop GALE_CUT
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element WIND
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 15
        end_magic_prop

; ------------------------------------------------------------------------------

; 231: SHIMSHAM
        magic_prop SHIMSHAM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, RUNIC, AUTO_RETARGET, NO_DODGE, HP_FRAC}
        mp_cost 20
        spell_power 8
        end_magic_prop

; ------------------------------------------------------------------------------

; 232: LODE_STONE
        magic_prop LODE_STONE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, NO_REFLECT, AUTO_RETARGET, NO_DODGE, HP_FRAC}
        mp_cost 20
        spell_power 12
        end_magic_prop

; ------------------------------------------------------------------------------

; 233: SCAR_BEAM
        magic_prop SCAR_BEAM
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element HOLY
        flags {NO_DMG_SPLIT, NO_REFLECT, RUNIC, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        spell_power 28
        end_magic_prop

; ------------------------------------------------------------------------------

; 234: BABABREATH
        magic_prop BABABREATH
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        special_effect BABABREATH
        status_block
        status34 HIDE
        end_magic_prop

; ------------------------------------------------------------------------------

; 235: LIFESHAVER
        magic_prop LIFESHAVER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        element EARTH
        flags {INVERT_UNDEAD, NO_REFLECT, AUTO_RETARGET, DRAIN, NO_DODGE}
        mp_cost 20
        spell_power 84
        end_magic_prop

; ------------------------------------------------------------------------------

; 236: FIRE_WALL
        magic_prop FIRE_WALL
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        element FIRE
        flags {NO_REFLECT, RUNIC, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        spell_power 50
        end_magic_prop

; ------------------------------------------------------------------------------

; 237: SLIDE
        magic_prop SLIDE
        targetting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        element EARTH
        flags {NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        mp_cost 20
        spell_power 75
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 238: BATTLE
        magic_prop BATTLE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {PHYSICAL, NO_REFLECT, AUTO_RETARGET}
        end_magic_prop

; ------------------------------------------------------------------------------

; 239: SPECIAL
        magic_prop SPECIAL
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {PHYSICAL, NO_REFLECT, AUTO_RETARGET}
        end_magic_prop

; ------------------------------------------------------------------------------

; 240: RIOT_BLADE
        magic_prop RIOT_BLADE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 142
        end_magic_prop

; ------------------------------------------------------------------------------

; 241: MIRAGER
        magic_prop MIRAGER
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 139
        end_magic_prop

; ------------------------------------------------------------------------------

; 242: BACK_BLADE
        magic_prop BACK_BLADE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 140
        end_magic_prop

; ------------------------------------------------------------------------------

; 243: SHADOWFANG
        magic_prop SHADOWFANG
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 140
        status12 SAP
        end_magic_prop

; ------------------------------------------------------------------------------

; 244: ROYALSHOCK
        magic_prop ROYALSHOCK
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 143
        end_magic_prop

; ------------------------------------------------------------------------------

; 245: TIGERBREAK
        magic_prop TIGERBREAK
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 140
        end_magic_prop

; ------------------------------------------------------------------------------

; 246: SPIN_EDGE
        magic_prop SPIN_EDGE
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 143
        end_magic_prop

; ------------------------------------------------------------------------------

; 247: SABRESOUL
        magic_prop SABRESOUL
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 248: STAR_PRISM
        magic_prop STAR_PRISM
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {INSTANT_DEATH, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        status_block
        status12 DEAD
        end_magic_prop

; ------------------------------------------------------------------------------

; 249: RED_CARD
        magic_prop RED_CARD
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 147
        end_magic_prop

; ------------------------------------------------------------------------------

; 250: MOOGLERUSH
        magic_prop MOOGLERUSH
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 150
        end_magic_prop

; ------------------------------------------------------------------------------

; 251: X_METEO
        magic_prop X_METEO
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 146
        end_magic_prop

; ------------------------------------------------------------------------------

; 252: TAKEDOWN
        magic_prop TAKEDOWN
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 55
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 253: WILD_FANG
        magic_prop WILD_FANG
        targetting {MANUAL, ONE_SIDE, INIT_SINGLE, AUTO_CONFIRM, ENEMY}
        flags {IGNORE_DEF, MONSTERS_ONLY, NO_REFLECT, AUTO_RETARGET, NO_DODGE}
        spell_power 66
        special_effect MISS_FLYING
        end_magic_prop

; ------------------------------------------------------------------------------

; 254: LAGOMORPH
        magic_prop LAGOMORPH
        targetting {ONE_SIDE, INIT_HALF, AUTO_CONFIRM, MULTI_TARGET}
        flags {NO_REFLECT, RESTORATIVE, REMOVE_STATUS, NO_DODGE}
        spell_power 10
        status12 {BLIND, POISON, SLEEP}
        end_magic_prop

; ------------------------------------------------------------------------------

; 255: NONE
        magic_prop NONE
        end_magic_prop

; ------------------------------------------------------------------------------

.include "magic_prop.mac"

; ------------------------------------------------------------------------------
