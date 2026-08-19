.export ItemProp

; ------------------------------------------------------------------------------

.include "item_prop.inc"

.segment "item_prop"

; d8/5000
ItemProp:

; ------------------------------------------------------------------------------

; 0: DIRK
        item_prop DIRK, WEAPON
        usage THROW
        equip {TERRA, LOCKE, SHADOW, EDGAR, CELES, STRAGO, RELM, SETZER, MOG, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 26
        hit_rate 180
        price 150
        end_item_prop

; ------------------------------------------------------------------------------

; 1: MITHRILKNIFE
        item_prop MITHRILKNIFE, WEAPON
        usage THROW
        equip {TERRA, LOCKE, SHADOW, EDGAR, CELES, STRAGO, RELM, SETZER, MOG, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 30
        hit_rate 180
        price 300
        end_item_prop

; ------------------------------------------------------------------------------

; 2: MAIN_GAUCHE
        item_prop MAIN_GAUCHE, WEAPON
        usage THROW
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 59
        hit_rate 180
        speed +4
        evade +10
        block DAGGER, PHYSICAL
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 3: AIR_LANCET
        item_prop AIR_LANCET, WEAPON
        usage THROW
        equip {LOCKE, STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 76
        hit_rate 180
        elem_attack WIND
        price 950
        end_item_prop

; ------------------------------------------------------------------------------

; 4: THIEFKNIFE
        item_prop THIEFKNIFE, WEAPON
        usage THROW
        equip {LOCKE, SHADOW}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        weapon_special RAND_STEAL
        attack_power 88
        hit_rate 180
        speed +3
        evade +10
        mblock +10
        block DAGGER, PHYSICAL
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 5: ASSASSIN
        item_prop ASSASSIN, WEAPON
        usage THROW
        equip {LOCKE, SHADOW}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        weapon_special INSTANT_DEATH
        attack_power 106
        hit_rate 180
        speed +3
        mag_pwr +2
        evade +10
        block DAGGER, PHYSICAL
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 6: MAN_EATER
        item_prop MAN_EATER, WEAPON
        usage THROW
        equip {TERRA, LOCKE, SHADOW, EDGAR, CELES, STRAGO, RELM, SETZER, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        weapon_special STRONG_VS_HUMAN
        attack_power 146
        hit_rate 180
        mblock +10
        block DAGGER, PHYSICAL
        price 11000
        end_item_prop

; ------------------------------------------------------------------------------

; 7: SWORDBREAKER
        item_prop SWORDBREAKER, WEAPON
        usage THROW
        equip {LOCKE, SHADOW, STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 164
        hit_rate 180
        evade +30
        block DAGGER, PHYSICAL
        price 16000
        end_item_prop

; ------------------------------------------------------------------------------

; 8: GRAEDUS
        item_prop GRAEDUS, WEAPON
        usage THROW
        equip {TERRA, LOCKE, SHADOW, EDGAR, CELES, STRAGO, RELM, SETZER, MOG, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 204
        hit_rate 180
        evade +10
        block DAGGER, PHYSICAL
        elem_attack HOLY
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 9: VALIANTKNIFE
        item_prop VALIANTKNIFE, WEAPON
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        weapon_special STRONG_WHEN_HP_LOW
        attack_power 145
        hit_rate 180
        evade +10
        block DAGGER, PHYSICAL
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 10: MITHRILBLADE
        item_prop MITHRILBLADE, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 38
        hit_rate 150
        price 450
        end_item_prop

; ------------------------------------------------------------------------------

; 11: REGAL_CUTLASS
        item_prop REGAL_CUTLASS, WEAPON
        usage THROW
        equip {TERRA, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 54
        hit_rate 150
        price 800
        end_item_prop

; ------------------------------------------------------------------------------

; 12: RUNE_EDGE
        item_prop RUNE_EDGE, WEAPON
        usage THROW
        equip {TERRA, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        weapon_special MP_CRIT
        attack_power 55
        hit_rate 150
        evade +10
        block SWORD, PHYSICAL
        price 7500
        end_item_prop

; ------------------------------------------------------------------------------

; 13: FLAME_SABRE
        item_prop FLAME_SABRE, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 108
        hit_rate 150
        mag_pwr +2
        elem_attack FIRE
        spell_cast FIRE, RAND_CAST
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 14: BLIZZARD
        item_prop BLIZZARD, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 108
        hit_rate 150
        mag_pwr +2
        elem_attack ICE
        spell_cast BLIZZARD, RAND_CAST
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 15: THUNDERBLADE
        item_prop THUNDERBLADE, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 108
        hit_rate 150
        mag_pwr +2
        elem_attack LIGHTNING
        spell_cast THUNDER, RAND_CAST
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 16: EPEE
        item_prop EPEE, WEAPON
        usage THROW
        equip {TERRA, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 98
        hit_rate 150
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 17: BREAK_BLADE
        item_prop BREAK_BLADE, WEAPON
        usage THROW
        equip {TERRA, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 117
        hit_rate 150
        spell_cast BREAK, RAND_CAST
        price 12000
        end_item_prop

; ------------------------------------------------------------------------------

; 18: DRAINER
        item_prop DRAINER, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        weapon_special ABSORB_HP
        attack_power 121
        hit_rate 150
        evade +10
        block SWORD, PHYSICAL
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 19: ENHANCER
        item_prop ENHANCER, WEAPON
        usage THROW
        equip {TERRA, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 135
        hit_rate 150
        mag_pwr +7
        mblock +20
        block SWORD, PHYSICAL
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 20: CRYSTAL
        item_prop CRYSTAL, WEAPON
        usage THROW
        equip {TERRA, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 167
        hit_rate 150
        price 15000
        end_item_prop

; ------------------------------------------------------------------------------

; 21: FALCHION
        item_prop FALCHION, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 176
        hit_rate 150
        evade +10
        block SWORD, PHYSICAL
        price 17000
        end_item_prop

; ------------------------------------------------------------------------------

; 22: SOUL_SABRE
        item_prop SOUL_SABRE, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        weapon_special ABSORB_MP
        attack_power 125
        hit_rate 150
        evade +10
        block SWORD, PHYSICAL
        spell_cast DOOM, RAND_CAST
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 23: OGRE_NIX
        item_prop OGRE_NIX, WEAPON
        usage THROW
        equip {TERRA, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        weapon_special RAND_BREAK
        attack_power 182
        hit_rate 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 24: EXCALIBUR
        item_prop EXCALIBUR, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 217
        hit_rate 150
        strength +2
        speed +2
        stamina +1
        mag_pwr +1
        evade +20
        block SWORD, PHYSICAL
        elem_attack HOLY
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 25: SCIMITAR
        item_prop SCIMITAR, WEAPON
        usage THROW
        equip {TERRA, CYAN, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        weapon_special SCIMITAR_EFFECT
        attack_power 208
        hit_rate 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 26: ILLUMINA
        item_prop ILLUMINA, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, BACK_ROW, TWO_HAND, RUNIC}
        weapon_special MP_CRIT
        attack_power 255
        hit_rate 255
        strength +7
        speed +7
        stamina +7
        mag_pwr +7
        evade +50
        mblock +50
        block SWORD, PHYSICAL
        spell_cast HOLY, RAND_CAST
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 27: RAGNAROK
        item_prop RAGNAROK, WEAPON
        usage THROW
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        weapon_special MP_CRIT
        attack_power 255
        hit_rate 150
        strength +7
        speed +3
        stamina +7
        mag_pwr +7
        evade +30
        mblock +30
        block SWORD, PHYSICAL
        spell_cast FLARE, RAND_CAST
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 28: ATMA_WEAPON
        item_prop ATMA_WEAPON, WEAPON
.if LANG_EN
        equip {TERRA, LOCKE, EDGAR, CELES}
.else
        equip {TERRA, LOCKE, EDGAR, CELES}, MERIT
.endif
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_special ATMA_WEAPON
        attack_power 255
        hit_rate 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 29: MITHRIL_PIKE
        item_prop MITHRIL_PIKE, WEAPON
        usage THROW
        equip {EDGAR, MOG}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 70
        hit_rate 150
        price 800
        end_item_prop

; ------------------------------------------------------------------------------

; 30: TRIDENT
        item_prop TRIDENT, WEAPON
        usage THROW
        equip {EDGAR, MOG}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 93
        hit_rate 150
        elem_attack WATER
        price 1700
        end_item_prop

; ------------------------------------------------------------------------------

; 31: STOUT_SPEAR
        item_prop STOUT_SPEAR, WEAPON
        usage THROW
        equip {EDGAR, MOG}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 112
        hit_rate 150
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 32: PARTISAN
        item_prop PARTISAN, WEAPON
        usage THROW
        equip {EDGAR, MOG}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 150
        hit_rate 150
        price 13000
        end_item_prop

; ------------------------------------------------------------------------------

; 33: HOLY_LANCE
        item_prop HOLY_LANCE, WEAPON
        usage THROW
        equip {EDGAR, MOG}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 194
        hit_rate 150
        mag_pwr +3
        elem_attack HOLY
        spell_cast HOLY, RAND_CAST
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 34: GOLD_LANCE
        item_prop GOLD_LANCE, WEAPON
        usage THROW
        equip {EDGAR, MOG}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 139
        hit_rate 150
        price 12000
        end_item_prop

; ------------------------------------------------------------------------------

; 35: AURA_LANCE
        item_prop AURA_LANCE, WEAPON
        usage THROW
        equip {EDGAR, MOG}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 227
        hit_rate 180
        strength +3
        speed +2
        stamina +1
        mag_pwr +3
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 36: IMP_HALBERD
        item_prop IMP_HALBERD, WEAPON
        usage THROW
        equip EQUIP_ALL_EXCEPT_UMARO, {IMP, MERIT}
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 253
        hit_rate 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 37: IMPERIAL
        item_prop IMPERIAL, WEAPON
        usage THROW
        equip SHADOW, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 82
        hit_rate 180
        price 600
        end_item_prop

; ------------------------------------------------------------------------------

; 38: KODACHI
        item_prop KODACHI, WEAPON
        usage THROW
        equip SHADOW, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 93
        hit_rate 180
        price 1200
        end_item_prop

; ------------------------------------------------------------------------------

; 39: BLOSSOM
        item_prop BLOSSOM, WEAPON
        usage THROW
        equip SHADOW, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 112
        hit_rate 180
        elem_attack WIND
        price 3200
        end_item_prop

; ------------------------------------------------------------------------------

; 40: HARDENED
        item_prop HARDENED, WEAPON
        usage THROW
        equip SHADOW, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 121
        hit_rate 180
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 41: STRIKER
        item_prop STRIKER, WEAPON
        usage THROW
        equip SHADOW, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        weapon_special INSTANT_DEATH
        attack_power 190
        hit_rate 180
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 42: STUNNER
        item_prop STUNNER, WEAPON
        usage THROW
        equip SHADOW, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 220
        hit_rate 180
        spell_cast STOP, RAND_CAST
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 43: ASHURA
        item_prop ASHURA, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 57
        hit_rate 150
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 44: KOTETSU
        item_prop KOTETSU, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 66
        hit_rate 150
        price 800
        end_item_prop

; ------------------------------------------------------------------------------

; 45: FORGED
        item_prop FORGED, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 81
        hit_rate 150
        price 1200
        end_item_prop

; ------------------------------------------------------------------------------

; 46: TEMPEST
        item_prop TEMPEST, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        weapon_special RAND_WIND_SLASH
        attack_power 101
        hit_rate 150
        elem_attack WIND
        price 8000
        end_item_prop

; ------------------------------------------------------------------------------

; 47: MURASAME
        item_prop MURASAME, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 110
        hit_rate 150
        evade +10
        block SWORD, PHYSICAL
        price 9000
        end_item_prop

; ------------------------------------------------------------------------------

; 48: AURA
        item_prop AURA, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 162
        hit_rate 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 49: STRATO
        item_prop STRATO, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 199
        hit_rate 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 50: SKY_RENDER
        item_prop SKY_RENDER, WEAPON
        usage THROW
        equip CYAN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BUSHIDO, TWO_HAND, RUNIC}
        attack_power 215
        hit_rate 150
        evade +20
        block SWORD, PHYSICAL
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 51: HEAL_ROD
        item_prop HEAL_ROD, WEAPON
        usage THROW
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE}
        weapon_flags TWO_HAND
        weapon_special HEAL_HP
        attack_power 200
        hit_rate 255
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 52: MITHRIL_ROD
        item_prop MITHRIL_ROD, WEAPON
        usage THROW
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 60
        hit_rate 135
        mag_pwr +2
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 53: FIRE_ROD
        item_prop FIRE_ROD, WEAPON
        usage BATTLE
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_GROUP, MULTI_TARGET, ENEMY}
        weapon_flags TWO_HAND
        attack_power 79
        hit_rate 135
        elem_attack FIRE
        spell_cast FIRA, {RAND_CAST, USE_AS_ITEM}
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 54: ICE_ROD
        item_prop ICE_ROD, WEAPON
        usage BATTLE
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_GROUP, MULTI_TARGET, ENEMY}
        weapon_flags TWO_HAND
        attack_power 79
        hit_rate 135
        elem_attack ICE
        spell_cast BLIZZARA, {RAND_CAST, USE_AS_ITEM}
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 55: THUNDER_ROD
        item_prop THUNDER_ROD, WEAPON
        usage BATTLE
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_GROUP, MULTI_TARGET, ENEMY}
        weapon_flags TWO_HAND
        attack_power 79
        hit_rate 135
        elem_attack LIGHTNING
        spell_cast THUNDARA, {RAND_CAST, USE_AS_ITEM}
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 56: POISON_ROD
        item_prop POISON_ROD, WEAPON
        usage {THROW, BATTLE}
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 86
        hit_rate 135
        elem_attack POISON
        spell_cast POISON, {RAND_CAST, USE_AS_ITEM}
        price 1500
        end_item_prop

; ------------------------------------------------------------------------------

; 57: HOLY_ROD
        item_prop HOLY_ROD, WEAPON
        usage {THROW, BATTLE}
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 124
        hit_rate 135
        elem_attack HOLY
        spell_cast HOLY, {RAND_CAST, USE_AS_ITEM}
        price 12000
        end_item_prop

; ------------------------------------------------------------------------------

; 58: GRAVITY_ROD
        item_prop GRAVITY_ROD, WEAPON
        usage {THROW, BATTLE}
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 120
        hit_rate 135
        elem_attack EARTH
        spell_cast QUARTR, {RAND_CAST, USE_AS_ITEM}
        price 13000
        end_item_prop

; ------------------------------------------------------------------------------

; 59: PUNISHER
        item_prop PUNISHER, WEAPON
        usage THROW
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        weapon_special MP_CRIT
        attack_power 111
        hit_rate 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 60: MAGUS_ROD
        item_prop MAGUS_ROD, WEAPON
        usage THROW
        equip {STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {TWO_HAND, RUNIC}
        attack_power 168
        hit_rate 135
        mag_pwr +7
        mblock +30
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 61: CHOCOBO_BRSH
        item_prop CHOCOBO_BRSH, WEAPON
        equip RELM, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 60
        hit_rate 135
        mag_pwr +1
        price 600
        end_item_prop

; ------------------------------------------------------------------------------

; 62: DAVINCI_BRSH
        item_prop DAVINCI_BRSH, WEAPON
        equip RELM, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 100
        hit_rate 135
        speed +1
        mag_pwr +1
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 63: MAGICAL_BRSH
        item_prop MAGICAL_BRSH, WEAPON
        equip RELM, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 130
        hit_rate 135
        speed +1
        stamina +1
        mag_pwr +1
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 64: RAINBOW_BRSH
        item_prop RAINBOW_BRSH, WEAPON
        equip RELM, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 146
        hit_rate 135
        strength +1
        speed +2
        stamina +1
        mag_pwr +2
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 65: SHURIKEN
        item_prop SHURIKEN, WEAPON
        usage THROW
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 86
        hit_rate 230
        price 30
        end_item_prop

; ------------------------------------------------------------------------------

; 66: NINJA_STAR
        item_prop NINJA_STAR, WEAPON
        usage THROW
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 132
        hit_rate 230
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 67: TACK_STAR
        item_prop TACK_STAR, WEAPON
        usage THROW
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 190
        hit_rate 230
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 68: FLAIL
        item_prop FLAIL, WEAPON
        equip {TERRA, CELES, STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BACK_ROW, TWO_HAND}
        attack_power 86
        hit_rate 150
        price 2000
        end_item_prop

; ------------------------------------------------------------------------------

; 69: FULL_MOON
        item_prop FULL_MOON, WEAPON
        usage THROW
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 95
        hit_rate 230
        price 2500
        end_item_prop

; ------------------------------------------------------------------------------

; 70: MORNING_STAR
        item_prop MORNING_STAR, WEAPON
        equip {TERRA, CELES, STRAGO, RELM, GOGO}, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags {BACK_ROW, TWO_HAND}
        attack_power 109
        hit_rate 150
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 71: BOOMERANG
        item_prop BOOMERANG, WEAPON
        usage THROW
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 102
        hit_rate 230
        price 4500
        end_item_prop

; ------------------------------------------------------------------------------

; 72: RISING_SUN
        item_prop RISING_SUN, WEAPON
        usage THROW
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 117
        hit_rate 230
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 73: HAWK_EYE
        item_prop HAWK_EYE, WEAPON
        usage THROW
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        weapon_special STRONG_VS_FLYING
        attack_power 111
        hit_rate 180
        price 6000
        end_item_prop

; ------------------------------------------------------------------------------

; 74: BONE_CLUB
        item_prop BONE_CLUB, WEAPON
        equip UMARO
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags TWO_HAND
        attack_power 151
        hit_rate 150
        price 20000
        end_item_prop

; ------------------------------------------------------------------------------

; 75: SNIPER
        item_prop SNIPER, WEAPON
        usage THROW
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        weapon_special STRONG_VS_FLYING
        attack_power 172
        hit_rate 180
        price 15000
        end_item_prop

; ------------------------------------------------------------------------------

; 76: WING_EDGE
        item_prop WING_EDGE, WEAPON
        usage THROW
        equip LOCKE, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        weapon_special INSTANT_DEATH
        attack_power 198
        hit_rate 230
        strength +7
        speed +7
        stamina +1
        mag_pwr +2
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 77: CARDS
        item_prop CARDS, WEAPON
        usage THROW
        equip SETZER, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 104
        hit_rate 230
        price 1000
        end_item_prop

; ------------------------------------------------------------------------------

; 78: DARTS
        item_prop DARTS, WEAPON
        usage THROW
        equip SETZER, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 115
        hit_rate 230
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 79: DOOM_DARTS
        item_prop DOOM_DARTS, WEAPON
        usage THROW
        equip SETZER, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 187
        hit_rate 230
        spell_cast DOOM, RAND_CAST
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 80: TRUMP
        item_prop TRUMP, WEAPON
        usage THROW
        equip SETZER, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        weapon_special INSTANT_DEATH
        attack_power 133
        hit_rate 230
        price 13000
        end_item_prop

; ------------------------------------------------------------------------------

; 81: DICE
        item_prop DICE, WEAPON
        equip SETZER, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        weapon_special DICE
        attack_power 1
        hit_rate 2
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 82: FIXED_DICE
        item_prop FIXED_DICE, WEAPON
        equip SETZER, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        weapon_special DICE
        attack_power 1
        hit_rate 3
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 83: METALKNUCKLE
        item_prop METALKNUCKLE, WEAPON
        equip SABIN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 55
        hit_rate 200
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 84: MITHRIL_CLAW
        item_prop MITHRIL_CLAW, WEAPON
        equip SABIN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 65
        hit_rate 200
        price 800
        end_item_prop

; ------------------------------------------------------------------------------

; 85: KAISER
        item_prop KAISER, WEAPON
        equip SABIN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 83
        hit_rate 200
        elem_attack HOLY
        price 1000
        end_item_prop

; ------------------------------------------------------------------------------

; 86: POISON_CLAW
        item_prop POISON_CLAW, WEAPON
        equip SABIN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 95
        hit_rate 200
        elem_attack POISON
        spell_cast POISON, RAND_CAST
        price 2500
        end_item_prop

; ------------------------------------------------------------------------------

; 87: FIRE_KNUCKLE
        item_prop FIRE_KNUCKLE, WEAPON
        equip SABIN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 122
        hit_rate 200
        elem_attack FIRE
        spell_cast FIRE, RAND_CAST
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 88: DRAGON_CLAW
        item_prop DRAGON_CLAW, WEAPON
        equip SABIN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 188
        hit_rate 200
        strength +2
        mag_pwr +1
        elem_attack HOLY
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 89: TIGER_FANGS
        item_prop TIGER_FANGS, WEAPON
        equip SABIN, MERIT
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 215
        hit_rate 200
        strength +3
        speed +2
        stamina +2
        mag_pwr +3
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 90: BUCKLER
        item_prop BUCKLER, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 16
        mag_def 10
        evade +10
        block SHIELD, PHYSICAL
        price 200
        end_item_prop

; ------------------------------------------------------------------------------

; 91: HEAVY_SHLD
        item_prop HEAVY_SHLD, SHIELD
        equip {TERRA, LOCKE, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 22
        mag_def 14
        evade +10
        block SHIELD, PHYSICAL
        price 400
        end_item_prop

; ------------------------------------------------------------------------------

; 92: MITHRIL_SHLD
        item_prop MITHRIL_SHLD, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 27
        mag_def 18
        evade +10
        block SHIELD, PHYSICAL
        price 1200
        end_item_prop

; ------------------------------------------------------------------------------

; 93: GOLD_SHLD
        item_prop GOLD_SHLD, SHIELD
        equip {TERRA, CYAN, EDGAR, CELES, SETZER, MOG}, MERIT
        def_power 34
        mag_def 23
        evade +10
        block SHIELD, PHYSICAL
        price 2500
        end_item_prop

; ------------------------------------------------------------------------------

; 94: AEGIS_SHLD
        item_prop AEGIS_SHLD, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 46
        mag_def 52
        evade +20
        mblock +40
        block SHIELD, {PHYSICAL, MAGIC}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 95: DIAMOND_SHLD
        item_prop DIAMOND_SHLD, SHIELD
        equip {TERRA, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 40
        mag_def 27
        evade +10
        block SHIELD, PHYSICAL
        price 3500
        end_item_prop

; ------------------------------------------------------------------------------

; 96: FLAME_SHLD
        item_prop FLAME_SHLD, SHIELD
        usage BATTLE
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        targeting {MANUAL, INIT_GROUP, MULTI_TARGET, ENEMY}
        def_power 41
        mag_def 28
        evade +20
        mblock +10
        block SHIELD, PHYSICAL
        elem_absorb FIRE
        elem_null ICE
        elem_weak WATER
        spell_learned FIRA, 5
        spell_cast FIRAGA, USE_AS_ITEM
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 97: ICE_SHLD
        item_prop ICE_SHLD, SHIELD
        usage BATTLE
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        targeting {MANUAL, INIT_GROUP, MULTI_TARGET, ENEMY}
        def_power 42
        mag_def 28
        evade +20
        mblock +10
        block SHIELD, PHYSICAL
        elem_absorb ICE
        elem_null FIRE
        elem_weak WIND
        spell_learned BLIZZARA, 5
        spell_cast BLIZZAGA, USE_AS_ITEM
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 98: THUNDER_SHLD
        item_prop THUNDER_SHLD, SHIELD
        usage BATTLE
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        targeting {MANUAL, INIT_GROUP, MULTI_TARGET, ENEMY}
        def_power 43
        mag_def 28
        evade +20
        mblock +10
        block SHIELD, PHYSICAL
        elem_half {FIRE, ICE}
        elem_absorb LIGHTNING
        elem_null WIND
        spell_learned THUNDARA, 5
        spell_cast THUNDAGA, USE_AS_ITEM
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 99: CRYSTAL_SHLD
        item_prop CRYSTAL_SHLD, SHIELD
        equip {TERRA, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 50
        mag_def 34
        evade +10
        block SHIELD, PHYSICAL
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 100: GENJI_SHLD
        item_prop GENJI_SHLD, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 54
        mag_def 50
        evade +20
        mblock +20
        block SHIELD, {PHYSICAL, MAGIC}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 101: TORTOISESHLD
        item_prop TORTOISESHLD, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, {IMP, MERIT}
        def_power 66
        mag_def 66
        evade +30
        mblock +30
        block SHIELD, PHYSICAL
        elem_absorb WATER
        spell_learned IMP, 1
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 102: CURSED_SHLD
        item_prop CURSED_SHLD, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        strength -7
        speed -7
        stamina -7
        mag_pwr -7
        elem_weak {FIRE, ICE, LIGHTNING, POISON, EARTH, WATER}
        equip_status {CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 103: PALADIN_SHLD
        item_prop PALADIN_SHLD, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        weapon_flags PALADIN_SHLD
        def_power 59
        mag_def 59
        evade +40
        mblock +40
        block SHIELD, {PHYSICAL, MAGIC}
        elem_absorb {FIRE, ICE, LIGHTNING, HOLY}
        elem_null {POISON, WIND, EARTH, WATER}
        spell_learned ULTIMA, 1
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 104: FORCE_SHLD
        item_prop FORCE_SHLD, SHIELD
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        mag_def 70
        mblock +50
        block SHIELD, MAGIC
        elem_half {FIRE, ICE, LIGHTNING, WIND, EARTH, WATER}
        equip_status SHELL
        spell_learned SHELL, 5
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 105: LEATHER_HAT
        item_prop LEATHER_HAT, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 11
        mag_def 7
        price 50
        end_item_prop

; ------------------------------------------------------------------------------

; 106: HAIR_BAND
        item_prop HAIR_BAND, HELMET
        equip EQUIP_FEMALE
        def_power 12
        mag_def 8
        price 150
        end_item_prop

; ------------------------------------------------------------------------------

; 107: PLUMED_HAT
        item_prop PLUMED_HAT, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 14
        mag_def 9
        price 250
        end_item_prop

; ------------------------------------------------------------------------------

; 108: BERET
        item_prop BERET, HELMET
        equip RELM, MERIT
        def_power 21
        mag_def 21
        mag_pwr +3
        relic_effect3 INC_SKETCH_RATE
        price 3500
        end_item_prop

; ------------------------------------------------------------------------------

; 109: MAGUS_HAT
        item_prop MAGUS_HAT, HELMET
        equip {TERRA, CELES, STRAGO, RELM, MOG, GOGO}, MERIT
        def_power 15
        mag_def 16
        mag_pwr +5
        price 600
        end_item_prop

; ------------------------------------------------------------------------------

; 110: BANDANA
        item_prop BANDANA, HELMET
        equip {TERRA, LOCKE, SABIN, CELES, RELM, GAU}, MERIT
        def_power 16
        mag_def 10
        price 800
        end_item_prop

; ------------------------------------------------------------------------------

; 111: IRON_HELMET
        item_prop IRON_HELMET, HELMET
        equip {TERRA, LOCKE, CYAN, EDGAR, CELES, SETZER, GAU}, MERIT
        def_power 18
        mag_def 12
        price 1000
        end_item_prop

; ------------------------------------------------------------------------------

; 112: CORONET
        item_prop CORONET, HELMET
        equip RELM, MERIT
        def_power 23
        mag_def 23
        speed +2
        mag_pwr +4
        relic_effect3 INC_CONTROL_RATE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 113: BARDS_HAT
        item_prop BARDS_HAT, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 19
        mag_def 21
        mblock +10
        relic_effect1 MP_PLUS_12
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 114: GREEN_BERET
        item_prop GREEN_BERET, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 19
        mag_def 13
        evade +10
        relic_effect1 HP_PLUS_12
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 115: HEAD_BAND
        item_prop HEAD_BAND, HELMET
        equip {LOCKE, CYAN, SHADOW, SABIN, MOG, GAU}, MERIT
        def_power 16
        mag_def 10
        strength +3
        speed +1
        stamina +2
        price 1600
        end_item_prop

; ------------------------------------------------------------------------------

; 116: MITHRIL_HELM
        item_prop MITHRIL_HELM, HELMET
        equip {TERRA, LOCKE, CYAN, SHADOW, EDGAR, CELES, SETZER, GAU, GOGO}, MERIT
        def_power 20
        mag_def 13
        price 2000
        end_item_prop

; ------------------------------------------------------------------------------

; 117: TIARA
        item_prop TIARA, HELMET
        equip EQUIP_FEMALE
        def_power 22
        mag_def 20
        mag_pwr +2
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 118: GOLD_HELMET
        item_prop GOLD_HELMET, HELMET
        equip {TERRA, CYAN, EDGAR, CELES, MOG}, MERIT
        def_power 22
        mag_def 15
        price 4000
        end_item_prop

; ------------------------------------------------------------------------------

; 119: TIGER_MASK
        item_prop TIGER_MASK, HELMET
        equip {SABIN, GAU}, MERIT
        def_power 21
        mag_def 13
        strength +3
        speed +2
        stamina +1
        price 2500
        end_item_prop

; ------------------------------------------------------------------------------

; 120: RED_CAP
        item_prop RED_CAP, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 24
        mag_def 17
        strength +4
        speed +3
        stamina +2
        relic_effect1 HP_PLUS_25
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 121: MYSTERY_VEIL
        item_prop MYSTERY_VEIL, HELMET
        equip EQUIP_FEMALE
        def_power 24
        mag_def 25
        speed +1
        mag_pwr +3
        mblock +10
        price 5500
        end_item_prop

; ------------------------------------------------------------------------------

; 122: CIRCLET
        item_prop CIRCLET, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 25
        mag_def 19
        strength +2
        speed +1
        stamina +3
        mag_pwr +4
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 123: REGAL_CROWN
        item_prop REGAL_CROWN, HELMET
        equip {EDGAR, SABIN}
        def_power 28
        mag_def 23
        strength +1
        speed +1
        stamina +1
        mag_pwr +1
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 124: DIAMOND_HELM
        item_prop DIAMOND_HELM, HELMET
        equip {TERRA, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 27
        mag_def 18
        price 8000
        end_item_prop

; ------------------------------------------------------------------------------

; 125: DARK_HOOD
        item_prop DARK_HOOD, HELMET
        equip {LOCKE, SHADOW, SABIN, MOG, GAU, GOGO}, MERIT
        def_power 26
        mag_def 17
        price 7500
        end_item_prop

; ------------------------------------------------------------------------------

; 126: CRYSTAL_HELM
        item_prop CRYSTAL_HELM, HELMET
        equip {TERRA, EDGAR, CELES, SETZER}, MERIT
        def_power 29
        mag_def 19
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 127: OATH_VEIL
        item_prop OATH_VEIL, HELMET
        equip EQUIP_FEMALE
        def_power 32
        mag_def 31
        price 9000
        end_item_prop

; ------------------------------------------------------------------------------

; 128: CAT_HOOD
        item_prop CAT_HOOD, HELMET
        equip RELM
        def_power 33
        mag_def 33
        speed +2
        mag_pwr +4
        evade +10
        mblock +10
        elem_half {FIRE, ICE, LIGHTNING, WIND, HOLY, EARTH}
        relic_effect5 DOUBLE_GP
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 129: GENJI_HELMET
        item_prop GENJI_HELMET, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 36
        mag_def 38
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 130: THORNLET
        item_prop THORNLET, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 38
        equip_status SAP
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 131: TITANIUM
        item_prop TITANIUM, HELMET
        equip EQUIP_ALL_EXCEPT_UMARO, {IMP, MERIT}
        def_power 42
        mag_def 42
        elem_absorb WATER
        spell_learned IMP, 1
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 132: LEATHERARMOR
        item_prop LEATHERARMOR, ARMOR
        equip {TERRA, LOCKE, CYAN, SHADOW, EDGAR, CELES, STRAGO, RELM, SETZER, MOG, GAU, GOGO}, MERIT
        def_power 28
        mag_def 19
        price 150
        end_item_prop

; ------------------------------------------------------------------------------

; 133: COTTON_ROBE
        item_prop COTTON_ROBE, ARMOR
        equip {TERRA, STRAGO, RELM, GOGO}, MERIT
        def_power 32
        mag_def 21
        price 200
        end_item_prop

; ------------------------------------------------------------------------------

; 134: KUNG_FU_SUIT
        item_prop KUNG_FU_SUIT, ARMOR
        equip {LOCKE, SHADOW, SABIN, GAU}, MERIT
        def_power 34
        mag_def 23
        price 250
        end_item_prop

; ------------------------------------------------------------------------------

; 135: IRON_ARMOR
        item_prop IRON_ARMOR, ARMOR
        equip {TERRA, LOCKE, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 40
        mag_def 27
        speed -2
        price 700
        end_item_prop

; ------------------------------------------------------------------------------

; 136: SILK_ROBE
        item_prop SILK_ROBE, ARMOR
        equip {TERRA, CELES, STRAGO, RELM, MOG, GOGO}, MERIT
        def_power 39
        mag_def 29
        mag_pwr +1
        price 600
        end_item_prop

; ------------------------------------------------------------------------------

; 137: MITHRIL_VEST
        item_prop MITHRIL_VEST, ARMOR
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 45
        mag_def 30
        price 1200
        end_item_prop

; ------------------------------------------------------------------------------

; 138: NINJA_GEAR
        item_prop NINJA_GEAR, ARMOR
        equip {LOCKE, SHADOW, SABIN, SETZER, GAU, GOGO}, MERIT
        def_power 47
        mag_def 32
        speed +2
        price 1100
        end_item_prop

; ------------------------------------------------------------------------------

; 139: WHITE_DRESS
        item_prop WHITE_DRESS, ARMOR
        equip EQUIP_FEMALE
        def_power 47
        mag_def 35
        mag_pwr +5
        price 2200
        end_item_prop

; ------------------------------------------------------------------------------

; 140: MITHRIL_MAIL
        item_prop MITHRIL_MAIL, ARMOR
        equip {TERRA, LOCKE, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 51
        mag_def 34
        price 3500
        end_item_prop

; ------------------------------------------------------------------------------

; 141: GAIA_GEAR
        item_prop GAIA_GEAR, ARMOR
        equip {TERRA, LOCKE, SHADOW, SABIN, CELES, STRAGO, RELM, SETZER, MOG, GAU, GOGO}, MERIT
        def_power 53
        mag_def 43
        elem_absorb EARTH
        price 6000
        end_item_prop

; ------------------------------------------------------------------------------

; 142: MIRAGE_VEST
        item_prop MIRAGE_VEST, ARMOR
        equip EQUIP_ALL_EXCEPT_UMARO, MERIT
        def_power 48
        mag_def 36
        speed +6
        mblock +10
        equip_status IMAGE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 143: GOLD_ARMOR
        item_prop GOLD_ARMOR, ARMOR
        equip {TERRA, CYAN, EDGAR, CELES, SETZER, MOG}, MERIT
        def_power 55
        mag_def 37
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 144: POWER_SASH
        item_prop POWER_SASH, ARMOR
        equip {LOCKE, CYAN, SHADOW, SABIN, GAU}, MERIT
        def_power 52
        mag_def 35
        strength +5
        speed +1
        stamina +5
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 145: LIGHT_ROBE
        item_prop LIGHT_ROBE, ARMOR
        equip {STRAGO, RELM, GOGO}, MERIT
        def_power 60
        mag_def 43
        mag_pwr +2
        price 11000
        end_item_prop

; ------------------------------------------------------------------------------

; 146: DIAMOND_VEST
        item_prop DIAMOND_VEST, ARMOR
        equip {TERRA, LOCKE, CYAN, SHADOW, EDGAR, SABIN, CELES, SETZER, MOG, GAU, GOGO}, MERIT
        def_power 65
        mag_def 44
        price 12000
        end_item_prop

; ------------------------------------------------------------------------------

; 147: RED_JACKET
        item_prop RED_JACKET, ARMOR
        equip {EDGAR, SABIN}, MERIT
        def_power 78
        mag_def 55
        strength +5
        speed +2
        stamina +4
        mag_pwr +1
        elem_null FIRE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 148: FORCE_ARMOR
        item_prop FORCE_ARMOR, ARMOR
        equip {TERRA, LOCKE, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 69
        mag_def 68
        mblock +30
        elem_half {FIRE, ICE, LIGHTNING, WIND, EARTH}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 149: DIAMONDARMOR
        item_prop DIAMONDARMOR, ARMOR
        equip {TERRA, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 70
        mag_def 47
        price 15000
        end_item_prop

; ------------------------------------------------------------------------------

; 150: DARK_GEAR
        item_prop DARK_GEAR, ARMOR
        equip {LOCKE, SHADOW, SABIN, SETZER, GAU, GOGO}, MERIT
        def_power 68
        mag_def 46
        speed +6
        price 13000
        end_item_prop

; ------------------------------------------------------------------------------

; 151: TAO_ROBE
        item_prop TAO_ROBE, ARMOR
        equip {STRAGO, RELM, GOGO}, MERIT
        def_power 68
        mag_def 50
        mag_pwr +5
        mblock +10
        price 13000
        end_item_prop

; ------------------------------------------------------------------------------

; 152: CRYSTAL_MAIL
        item_prop CRYSTAL_MAIL, ARMOR
        equip {TERRA, LOCKE, CYAN, EDGAR, CELES, SETZER}, MERIT
        def_power 72
        mag_def 49
        price 17000
        end_item_prop

; ------------------------------------------------------------------------------

; 153: CZARINA_GOWN
        item_prop CZARINA_GOWN, ARMOR
        equip RELM
        def_power 70
        mag_def 64
        strength +1
        speed +2
        stamina +2
        mag_pwr +3
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 154: GENJI_ARMOR
        item_prop GENJI_ARMOR, ARMOR
        equip {TERRA, LOCKE, CYAN, SHADOW, EDGAR, CELES, SETZER}, MERIT
        def_power 90
        mag_def 80
        strength +5
        speed +3
        stamina +2
        mag_pwr +3
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 155: IMPS_ARMOR
        item_prop IMPS_ARMOR, ARMOR
        equip EQUIP_ALL_EXCEPT_UMARO, {IMP, MERIT}
        def_power 100
        mag_def 100
        elem_absorb WATER
        spell_learned IMP, 1
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 156: MINERVA
        item_prop MINERVA, ARMOR
        equip {TERRA, CELES}
        def_power 88
        mag_def 70
        strength +1
        speed +2
        stamina +1
        mag_pwr +4
        mblock +10
        elem_half {POISON, HOLY, EARTH, WATER}
        elem_null {FIRE, ICE, LIGHTNING, WIND}
        relic_effect1 MP_PLUS_25
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 157: TABBY_SUIT
        item_prop TABBY_SUIT, ARMOR
        equip {STRAGO, RELM}
        def_power 54
        mag_def 36
        strength +2
        speed +2
        stamina +2
        mag_pwr +2
        elem_null POISON
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 158: CHOCOBO_SUIT
        item_prop CHOCOBO_SUIT, ARMOR
        equip {STRAGO, RELM}
        def_power 56
        mag_def 38
        strength +3
        speed +6
        stamina +2
        elem_null POISON
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 159: MOOGLE_SUIT
        item_prop MOOGLE_SUIT, ARMOR
        equip {STRAGO, RELM}
        def_power 58
        mag_def 52
        mag_pwr +5
        elem_null POISON
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 160: NUTKIN_SUIT
        item_prop NUTKIN_SUIT, ARMOR
        equip {STRAGO, RELM}
        def_power 86
        mag_def 67
        speed +7
        mag_pwr +3
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 161: BEHEMOTHSUIT
        item_prop BEHEMOTHSUIT, ARMOR
        equip {STRAGO, RELM}
        def_power 94
        mag_def 73
        strength +6
        speed +6
        stamina +6
        mag_pwr +6
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 162: SNOW_MUFFLER
        item_prop SNOW_MUFFLER, ARMOR
        equip {MOG, GAU, UMARO}
        def_power 128
        mag_def 90
        evade +10
        mblock +10
        elem_half FIRE
        elem_absorb ICE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 163: NOISEBLASTER
        item_prop NOISEBLASTER, TOOL
        targeting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        weapon_flags BACK_ROW
        hit_rate 255
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 164: BIO_BLASTER
        item_prop BIO_BLASTER, TOOL
        targeting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        weapon_flags BACK_ROW
        hit_rate 255
        price 750
        end_item_prop

; ------------------------------------------------------------------------------

; 165: FLASH
        item_prop FLASH, TOOL
        targeting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        weapon_flags BACK_ROW
        hit_rate 255
        price 1000
        end_item_prop

; ------------------------------------------------------------------------------

; 166: CHAIN_SAW
        item_prop CHAIN_SAW, TOOL
        targeting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 252
        hit_rate 255
        price 2000
        end_item_prop

; ------------------------------------------------------------------------------

; 167: DEBILITATOR
        item_prop DEBILITATOR, TOOL
        targeting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        hit_rate 255
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 168: DRILL
        item_prop DRILL, TOOL
        targeting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        weapon_flags BACK_ROW
        attack_power 191
        hit_rate 255
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 169: AIR_ANCHOR
        item_prop AIR_ANCHOR, TOOL
        targeting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        attack_power 128
        hit_rate 255
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 170: AUTOCROSSBOW
        item_prop AUTOCROSSBOW, TOOL
        targeting {ONE_SIDE, INIT_GROUP, MULTI_TARGET, ENEMY}
        weapon_flags BACK_ROW
        attack_power 125
        hit_rate 255
        price 250
        end_item_prop

; ------------------------------------------------------------------------------

; 171: FIRE_SKEAN
        item_prop FIRE_SKEAN, CONSUMABLE
        usage THROW
        targeting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 172: WATER_EDGE
        item_prop WATER_EDGE, CONSUMABLE
        usage THROW
        targeting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 173: BOLT_EDGE
        item_prop BOLT_EDGE, CONSUMABLE
        usage THROW
        targeting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 174: INVIZ_EDGE
        item_prop INVIZ_EDGE, CONSUMABLE
        usage THROW
        targeting SELF
        item_special NONE
        item_status12 VANISH
        price 200
        end_item_prop

; ------------------------------------------------------------------------------

; 175: SHADOW_EDGE
        item_prop SHADOW_EDGE, CONSUMABLE
        usage THROW
        targeting SELF
        item_special NONE
        item_status12 IMAGE
        price 400
        end_item_prop

; ------------------------------------------------------------------------------

; 176: GOGGLES
        item_prop GOGGLES, RELIC
        equip EQUIP_ALL
        immune_status BLIND
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 177: STAR_PENDANT
        item_prop STAR_PENDANT, RELIC
        equip EQUIP_ALL
        immune_status POISON
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 178: PEACE_RING
        item_prop PEACE_RING, RELIC
        equip EQUIP_ALL
        immune_status {BERSERK, CONFUSE}
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 179: AMULET
        item_prop AMULET, RELIC
        equip EQUIP_ALL
        immune_status {BLIND, ZOMBIE, POISON}
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 180: WHITE_CAPE
        item_prop WHITE_CAPE, RELIC
        equip EQUIP_ALL
        def_power 5
        mag_def 5
        mblock +10
        immune_status {IMP, SILENCE}
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 181: JEWEL_RING
        item_prop JEWEL_RING, RELIC
        equip EQUIP_ALL
        immune_status PETRIFY
        price 1000
        end_item_prop

; ------------------------------------------------------------------------------

; 182: FAIRY_RING
        item_prop FAIRY_RING, RELIC
        equip EQUIP_ALL
        immune_status {BLIND, POISON}
        price 1500
        end_item_prop

; ------------------------------------------------------------------------------

; 183: BARRIER_RING
        item_prop BARRIER_RING, RELIC
        equip EQUIP_ALL
        mag_pwr +2
        relic_effect5 SHELL_HP_LOW
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 184: MITHRILGLOVE
        item_prop MITHRILGLOVE, RELIC
        equip EQUIP_ALL
        def_power 6
        relic_effect5 SAFE_HP_LOW
        price 700
        end_item_prop

; ------------------------------------------------------------------------------

; 185: GUARD_RING
        item_prop GUARD_RING, RELIC
        equip EQUIP_ALL
        equip_status SAFE
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 186: RUNNINGSHOES
        item_prop RUNNINGSHOES, RELIC
        equip EQUIP_ALL
        equip_status HASTE
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 187: WALL_RING
        item_prop WALL_RING, RELIC
        equip EQUIP_ALL
        equip_status REFLECT
        price 6000
        end_item_prop

; ------------------------------------------------------------------------------

; 188: CHERUB_DOWN
        item_prop CHERUB_DOWN, RELIC
        equip EQUIP_ALL
        equip_status FLYING
        price 6300
        end_item_prop

; ------------------------------------------------------------------------------

; 189: CURE_RING
        item_prop CURE_RING, RELIC
        equip EQUIP_ALL
        equip_status REGEN
        price 8000
        end_item_prop

; ------------------------------------------------------------------------------

; 190: TRUE_KNIGHT
        item_prop TRUE_KNIGHT, RELIC
        equip EQUIP_ALL
        relic_effect4 COVER
        price 1000
        end_item_prop

; ------------------------------------------------------------------------------

; 191: DRAGOONBOOTS
        item_prop DRAGOONBOOTS, RELIC
        equip EQUIP_ALL_EXCEPT_UMARO
        relic_effect2 JUMP
        price 9000
        end_item_prop

; ------------------------------------------------------------------------------

; 192: ZEPHYR_CAPE
        item_prop ZEPHYR_CAPE, RELIC
        equip EQUIP_ALL
        evade +10
        mblock +10
        block CAPE, PHYSICAL
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 193: CZARINA_RING
        item_prop CZARINA_RING, RELIC
        equip EQUIP_FEMALE
        relic_effect5 {SHELL_HP_LOW, SAFE_HP_LOW}
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 194: CURSED_RING
        item_prop CURSED_RING, RELIC
        equip EQUIP_ALL
        equip_status CONDEMNED
        spell_learned DEZONE, 5
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 195: EARRINGS
        item_prop EARRINGS, RELIC
        equip EQUIP_ALL
        relic_effect1 EARRING
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 196: ATLAS_ARMLET
        item_prop ATLAS_ARMLET, RELIC
        equip EQUIP_ALL
        relic_effect1 ATLAS_ARMLET
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 197: BLIZZARD_ORB
        item_prop BLIZZARD_ORB, RELIC
        equip UMARO
        mag_pwr +5
        elem_absorb ICE
        elem_null FIRE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 198: RAGE_RING
        item_prop RAGE_RING, RELIC
        equip UMARO
        strength +5
        elem_absorb FIRE
        elem_null LIGHTNING
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 199: SNEAK_RING
        item_prop SNEAK_RING, RELIC
        equip {LOCKE, GOGO}
        speed +5
        relic_effect3 INC_STEAL_RATE
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 200: POD_BRACELET
        item_prop POD_BRACELET, RELIC
        equip EQUIP_ALL
        equip_status {SHELL, SAFE}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 201: HERO_RING
        item_prop HERO_RING, RELIC
        equip EQUIP_ALL
        relic_effect1 {ATLAS_ARMLET, EARRING}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 202: RIBBON
        item_prop RIBBON, RELIC
        equip EQUIP_ALL
        immune_status {BLIND, ZOMBIE, POISON, IMP, PETRIFY, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 203: MUSCLE_BELT
        item_prop MUSCLE_BELT, RELIC
        equip EQUIP_ALL
        relic_effect1 HP_PLUS_50
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 204: CRYSTAL_ORB
        item_prop CRYSTAL_ORB, RELIC
        equip EQUIP_ALL
        relic_effect1 MP_PLUS_50
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 205: GOLD_HAIRPIN
        item_prop GOLD_HAIRPIN, RELIC
        equip EQUIP_ALL
        relic_effect3 MP_COST_HALF
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 206: ECONOMIZER
        item_prop ECONOMIZER, RELIC
        equip EQUIP_ALL_EXCEPT_UMARO
        relic_effect3 MP_COST_1
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 207: THIEF_GLOVE
        item_prop THIEF_GLOVE, RELIC
        equip {LOCKE, GOGO}
        relic_effect2 CAPTURE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 208: GAUNTLET
        item_prop GAUNTLET, RELIC
        equip EQUIP_ALL
        def_power 5
        relic_effect4 GAUNTLET
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 209: GENJI_GLOVE
        item_prop GENJI_GLOVE, RELIC
        equip EQUIP_ALL_EXCEPT_UMARO
        def_power 5
        relic_effect4 GENJI_GLOVE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 210: HYPER_WRIST
        item_prop HYPER_WRIST, RELIC
        equip EQUIP_ALL
        relic_effect3 STRENGTH_PLUS_50
        price 8000
        end_item_prop

; ------------------------------------------------------------------------------

; 211: OFFERING
        item_prop OFFERING, RELIC
        equip EQUIP_ALL
        relic_effect4 X_FIGHT
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 212: BEADS
        item_prop BEADS, RELIC
        equip EQUIP_ALL
        evade +20
        relic_effect4 RAND_EVADE
        price 4000
        end_item_prop

; ------------------------------------------------------------------------------

; 213: BLACK_BELT
        item_prop BLACK_BELT, RELIC
        equip EQUIP_ALL
        relic_effect4 RAND_RETAL
        price 5000
        end_item_prop

; ------------------------------------------------------------------------------

; 214: COIN_TOSS
        item_prop COIN_TOSS, RELIC
        equip {SETZER, GOGO}
        relic_effect2 GP_RAIN
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 215: FAKEMUSTACHE
        item_prop FAKEMUSTACHE, RELIC
        equip {RELM, GOGO}
        relic_effect2 CONTROL
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 216: GEM_BOX
        item_prop GEM_BOX, RELIC
        equip EQUIP_ALL_EXCEPT_UMARO
        relic_effect2 X_MAGIC
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 217: DRAGON_HORN
        item_prop DRAGON_HORN, RELIC
        equip EQUIP_ALL_EXCEPT_UMARO
        relic_effect2 DRAGON_HORN
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 218: MERIT_AWARD
        item_prop MERIT_AWARD, RELIC
        equip EQUIP_ALL
        relic_effect4 EQUIP_MERIT
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 219: MEMENTO_RING
        item_prop MEMENTO_RING, RELIC
        equip {SHADOW, RELM}
        weapon_flags PALADIN_SHLD
        immune_status {ZOMBIE, PETRIFY, DEAD}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 220: SAFETY_BIT
        item_prop SAFETY_BIT, RELIC
        equip EQUIP_ALL
        weapon_flags PALADIN_SHLD
        immune_status {ZOMBIE, PETRIFY, DEAD}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 221: RELIC_RING
        item_prop RELIC_RING, RELIC
        equip EQUIP_ALL
        relic_effect5 MAKE_UNDEAD
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 222: MOOGLE_CHARM
        item_prop MOOGLE_CHARM, RELIC
        equip MOG
        field_effect NO_RAND_BATTLES
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 223: CHARM_BANGLE
        item_prop CHARM_BANGLE, RELIC
        equip EQUIP_ALL
        field_effect REDUCE_RAND_BATTLES
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 224: MARVEL_SHOES
        item_prop MARVEL_SHOES, RELIC
        equip EQUIP_ALL
        equip_status {REGEN, HASTE, SHELL, SAFE}
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 225: BACK_GUARD
        item_prop BACK_GUARD, RELIC
        equip EQUIP_ALL
        relic_effect2 BACK_GUARD
        price 7000
        end_item_prop

; ------------------------------------------------------------------------------

; 226: GALE_HAIRPIN
        item_prop GALE_HAIRPIN, RELIC
        equip EQUIP_ALL
        relic_effect2 GALE_HAIRPIN
        price 8000
        end_item_prop

; ------------------------------------------------------------------------------

; 227: SNIPER_SIGHT
        item_prop SNIPER_SIGHT, RELIC
        equip EQUIP_ALL
        relic_effect3 MAX_HIT_RATE
        price 3000
        end_item_prop

; ------------------------------------------------------------------------------

; 228: EXP_EGG
        item_prop EXP_EGG, RELIC
        equip EQUIP_ALL
        relic_effect5 DOUBLE_EXP
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 229: TINTINABAR
        item_prop TINTINABAR, RELIC
        equip EQUIP_ALL
        field_effect TINTINABAR
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 230: SPRINT_SHOES
        item_prop SPRINT_SHOES, RELIC
        equip EQUIP_ALL
        field_effect SPRINT_SHOES
        price 1500
        end_item_prop

; ------------------------------------------------------------------------------

; 231: RENAME_CARD
        item_prop RENAME_CARD, CONSUMABLE
        usage MENU
        targeting {MANUAL, ONE_SIDE, INIT_SINGLE}
        item_special NONE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 232: TONIC
        item_prop TONIC, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags {INVERT_UNDEAD, AFFECT_HP}
        item_special NONE
        item_power 50
        price 50
        end_item_prop

; ------------------------------------------------------------------------------

; 233: POTION
        item_prop POTION, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags {INVERT_UNDEAD, AFFECT_HP}
        item_special NONE
        item_power 250
        price 300
        end_item_prop

; ------------------------------------------------------------------------------

; 234: X_POTION
        item_prop X_POTION, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags {INVERT_UNDEAD, AFFECT_HP, FRACTIONAL_POWER}
        item_special NONE
        item_power 16
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 235: TINCTURE
        item_prop TINCTURE, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags AFFECT_MP
        item_special NONE
        item_power 50
        price 1500
        end_item_prop

; ------------------------------------------------------------------------------

; 236: ETHER
        item_prop ETHER, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags AFFECT_MP
        item_special NONE
        item_power 150
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 237: X_ETHER
        item_prop X_ETHER, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags {AFFECT_MP, FRACTIONAL_POWER}
        item_special NONE
        item_power 16
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 238: ELIXIR
        item_prop ELIXIR, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags {INVERT_UNDEAD, AFFECT_HP, AFFECT_MP, FRACTIONAL_POWER}
        item_special ELIXIR
        item_power 16
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 239: MEGALIXIR
        item_prop MEGALIXIR, CONSUMABLE
        usage BATTLE
        targeting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        item_flags {INVERT_UNDEAD, AFFECT_HP, AFFECT_MP, FRACTIONAL_POWER}
        item_special ELIXIR
        item_power 16
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 240: FENIX_DOWN
        item_prop FENIX_DOWN, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags {INVERT_UNDEAD, AFFECT_HP, REMOVE_STATUS, FRACTIONAL_POWER}
        item_special NONE
        item_power 2
        item_status12 DEAD
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 241: REVIVIFY
        item_prop REVIVIFY, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags {INVERT_UNDEAD, AFFECT_HP, REMOVE_STATUS, FRACTIONAL_POWER}
        item_special NONE
        item_power 2
        item_status12 ZOMBIE
        price 300
        end_item_prop

; ------------------------------------------------------------------------------

; 242: ANTIDOTE
        item_prop ANTIDOTE, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags REMOVE_STATUS
        item_special NONE
        item_status12 POISON
        price 50
        end_item_prop

; ------------------------------------------------------------------------------

; 243: EYEDROP
        item_prop EYEDROP, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags REMOVE_STATUS
        item_special NONE
        item_status12 BLIND
        price 50
        end_item_prop

; ------------------------------------------------------------------------------

; 244: SOFT
        item_prop SOFT, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags REMOVE_STATUS
        item_special NONE
        item_status12 PETRIFY
        price 200
        end_item_prop

; ------------------------------------------------------------------------------

; 245: REMEDY
        item_prop REMEDY, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags REMOVE_STATUS
        item_special NONE
        item_status12 {BLIND, POISON, IMP, PETRIFY, SILENCE, SAP}
        price 1000
        end_item_prop

; ------------------------------------------------------------------------------

; 246: SLEEPING_BAG
        item_prop SLEEPING_BAG, CONSUMABLE
        usage MENU
        targeting {MANUAL, INIT_SINGLE}
        item_flags {AFFECT_HP, AFFECT_MP, REMOVE_STATUS, FRACTIONAL_POWER}
        item_special NONE
        item_power 16
        item_status12 {BLIND, ZOMBIE, POISON, VANISH, IMP, PETRIFY}
        item_status34 FLOAT
        price 500
        end_item_prop

; ------------------------------------------------------------------------------

; 247: TENT
        item_prop TENT, CONSUMABLE
        usage MENU
        item_flags {AFFECT_HP, AFFECT_MP, REMOVE_STATUS, FRACTIONAL_POWER}
        item_special NONE
        item_power 16
        item_status12 {BLIND, ZOMBIE, POISON, VANISH, IMP, PETRIFY, DEAD}
        item_status34 FLOAT
        price 1200
        end_item_prop

; ------------------------------------------------------------------------------

; 248: GREEN_CHERRY
        item_prop GREEN_CHERRY, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags REMOVE_STATUS
        item_special NONE
        item_status12 IMP
        price 150
        end_item_prop

; ------------------------------------------------------------------------------

; 249: MAGICITE
        item_prop MAGICITE, CONSUMABLE
        usage BATTLE
        targeting {MANUAL, ONE_SIDE, INIT_SINGLE, ENEMY}
        item_flags CAUSE_DAMAGE
        item_special MAGICITE
        price 2
        end_item_prop

; ------------------------------------------------------------------------------

; 250: SUPER_BALL
        item_prop SUPER_BALL, CONSUMABLE
        usage BATTLE
        targeting {ONE_SIDE, INIT_HALF, MULTI_TARGET, ENEMY}
        item_flags CAUSE_DAMAGE
        item_special SUPER_BALL
        item_power 1
        price 10000
        end_item_prop

; ------------------------------------------------------------------------------

; 251: ECHO_SCREEN
        item_prop ECHO_SCREEN, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags REMOVE_STATUS
        item_special NONE
        item_status12 SILENCE
        price 120
        end_item_prop

; ------------------------------------------------------------------------------

; 252: SMOKE_BOMB
        item_prop SMOKE_BOMB, CONSUMABLE
        usage BATTLE
        targeting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        item_special SMOKE_BOMB
        price 300
        end_item_prop

; ------------------------------------------------------------------------------

; 253: WARP_STONE
        item_prop WARP_STONE, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {ONE_SIDE, INIT_HALF, MULTI_TARGET}
        item_special WARP_STONE
        price 700
        end_item_prop

; ------------------------------------------------------------------------------

; 254: DRIED_MEAT
        item_prop DRIED_MEAT, CONSUMABLE
        usage {BATTLE, MENU}
        targeting {MANUAL, INIT_SINGLE}
        item_flags AFFECT_HP
        item_special DRIED_MEAT
        item_power 150
        price 150
        end_item_prop

; ------------------------------------------------------------------------------

; Lots of weird stuff set here. Not sure if any of this is used when unarmed.

; 255: EMPTY
        item_prop EMPTY, WEAPON
        equip {TERRA, LOCKE, CYAN, SHADOW, EDGAR, SABIN, CELES, STRAGO}
        targeting {MANUAL, INIT_SINGLE, ENEMY}
        attack_power 10
        hit_rate 200
        elem_absorb ALL
        elem_weak ALL
        equip_status {CONDEMNED, NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        price 0
        end_item_prop

; ------------------------------------------------------------------------------

.include "item_prop.inc"

; ------------------------------------------------------------------------------
