; ------------------------------------------------------------------------------

.mac empty_char_prop
        .res 22, 0
.endmac

.macro make_char_prop
        _char_prop_hp                   .set 0
        _char_prop_mp                   .set 0
        _char_prop_cmd1                 .set BATTLE_CMD::NONE
        _char_prop_cmd2                 .set BATTLE_CMD::NONE
        _char_prop_cmd3                 .set BATTLE_CMD::NONE
        _char_prop_cmd4                 .set BATTLE_CMD::NONE
        _char_prop_strength             .set 0
        _char_prop_agility              .set 0
        _char_prop_stamina              .set 0
        _char_prop_magic_power          .set 0
        _char_prop_battle_power         .set 0
        _char_prop_defense              .set 0
        _char_prop_magic_defense        .set 0
        _char_prop_evade                .set 0
        _char_prop_magic_block          .set 0
        _char_prop_weapon               .set ITEM::EMPTY
        _char_prop_shield               .set ITEM::EMPTY
        _char_prop_helmet               .set ITEM::EMPTY
        _char_prop_armor                .set ITEM::EMPTY
        _char_prop_relic1               .set ITEM::EMPTY
        _char_prop_relic2               .set ITEM::EMPTY
        _char_prop_flags                .set 0
.endmac

.mac end_char_prop
        .byte _char_prop_hp, _char_prop_mp
        .byte _char_prop_cmd1, _char_prop_cmd2, _char_prop_cmd3, _char_prop_cmd4
        .byte _char_prop_strength, _char_prop_agility, _char_prop_stamina
        .byte _char_prop_magic_power, _char_prop_battle_power
        .byte _char_prop_defense, _char_prop_magic_defense
        .byte _char_prop_evade, _char_prop_magic_block
        .byte _char_prop_weapon, _char_prop_shield
        .byte _char_prop_helmet, _char_prop_armor
        .byte _char_prop_relic1, _char_prop_relic2
        .byte _char_prop_flags
.endmac

.mac set_char_prop_hp_mp hp, mp
        _char_prop_hp .set hp
        _char_prop_mp .set mp
.endmac

.mac set_char_prop_cmds cmd1, cmd2, cmd3, cmd4
        .ifnblank cmd1
                _char_prop_cmd1 .set BATTLE_CMD::cmd1
        .else
                _char_prop_cmd1 .set BATTLE_CMD::NONE
        .endif
        .ifnblank cmd2
                _char_prop_cmd2 .set BATTLE_CMD::cmd2
        .else
                _char_prop_cmd2 .set BATTLE_CMD::NONE
        .endif
        .ifnblank cmd3
                _char_prop_cmd3 .set BATTLE_CMD::cmd3
        .else
                _char_prop_cmd3 .set BATTLE_CMD::NONE
        .endif
        .ifnblank cmd4
                _char_prop_cmd4 .set BATTLE_CMD::cmd4
        .else
                _char_prop_cmd4 .set BATTLE_CMD::NONE
        .endif
.endmac

.mac set_char_prop_stats strength, agility, stamina, magic_power, battle_power, defense, magic_defense, evade, magic_block
        _char_prop_strength .set strength
        _char_prop_agility .set agility
        _char_prop_stamina .set stamina
        _char_prop_magic_power .set magic_power
        _char_prop_battle_power .set battle_power
        _char_prop_defense .set defense
        _char_prop_magic_defense .set magic_defense
        _char_prop_evade .set evade
        _char_prop_magic_block .set magic_block
.endmac

.mac set_char_prop_equip weapon, shield, helmet, armor
        .ifnblank weapon
                _char_prop_weapon .set ITEM::weapon
        .else
                _char_prop_weapon .set ITEM::EMPTY
        .endif
        .ifnblank shield
                _char_prop_shield .set ITEM::shield
        .else
                _char_prop_shield .set ITEM::EMPTY
        .endif
        .ifnblank helmet
                _char_prop_helmet .set ITEM::helmet
        .else
                _char_prop_helmet .set ITEM::EMPTY
        .endif
        .ifnblank armor
                _char_prop_armor .set ITEM::armor
        .else
                _char_prop_armor .set ITEM::EMPTY
        .endif
.endmac

.mac set_char_prop_relics relic1, relic2
        .ifnblank relic1
                _char_prop_relic1 .set ITEM::relic1
        .else
                _char_prop_relic1 .set ITEM::EMPTY
        .endif
        .ifnblank relic2
                _char_prop_relic2 .set ITEM::relic2
        .else
                _char_prop_relic2 .set ITEM::EMPTY
        .endif
.endmac

.mac set_char_prop_flags run_factor, level_mod, fixed_equip
        .ifblank fixed_equip
                _char_prop_flags .set run_factor | level_mod
        .else
                _char_prop_flags .set run_factor | level_mod | fixed_equip
        .endif
.endmac

; ------------------------------------------------------------------------------

.export CharProp

; ------------------------------------------------------------------------------

.segment "char_prop"

CharProp:

; ------------------------------------------------------------------------------

; 0: terra
        make_char_prop
        set_char_prop_hp_mp 40, 16
        set_char_prop_cmds FIGHT, MORPH, MAGIC, ITEM
        set_char_prop_stats 31, 33, 28, 39, 12, 42, 33, 5, 7
        set_char_prop_equip MITHRILKNIFE, BUCKLER, LEATHER_HAT, LEATHERARMOR
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_NORMAL
        end_char_prop

; ------------------------------------------------------------------------------

; 1: locke
        make_char_prop
        set_char_prop_hp_mp 48, 7
        set_char_prop_cmds FIGHT, STEAL, MAGIC, ITEM
        set_char_prop_stats 37, 40, 31, 28, 14, 46, 23, 15, 2
        set_char_prop_equip DIRK, EMPTY, LEATHER_HAT, LEATHERARMOR
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 2: cyan
        make_char_prop
        set_char_prop_hp_mp 53, 5
        set_char_prop_cmds FIGHT, BUSHIDO, MAGIC, ITEM
        set_char_prop_stats 40, 28, 33, 25, 25, 48, 20, 6, 1
        set_char_prop_equip ASHURA, BUCKLER, LEATHER_HAT, LEATHERARMOR
        set_char_prop_flags RUN_FACTOR_LOW, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 3: shadow
        make_char_prop
        set_char_prop_hp_mp 51, 6
        set_char_prop_cmds FIGHT, THROW, MAGIC, ITEM
        set_char_prop_stats 39, 38, 30, 33, 23, 47, 25, 28, 9
        set_char_prop_equip IMPERIAL, EMPTY, EMPTY, NINJA_GEAR
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_NORMAL
        end_char_prop

; ------------------------------------------------------------------------------

; 4: edgar
        make_char_prop
        set_char_prop_hp_mp 49, 6
        set_char_prop_cmds FIGHT, TOOLS, MAGIC, ITEM
        set_char_prop_stats 39, 30, 34, 29, 20, 50, 22, 4, 1
        set_char_prop_equip MITHRILBLADE, BUCKLER, LEATHER_HAT, LEATHERARMOR
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 5: sabin
        make_char_prop
        set_char_prop_hp_mp 58, 3
        set_char_prop_cmds FIGHT, BLITZ, MAGIC, ITEM
        set_char_prop_stats 47, 37, 39, 28, 26, 53, 21, 12, 4
        set_char_prop_equip METALKNUCKLE, EMPTY, LEATHER_HAT, KUNG_FU_SUIT
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 6: celes
        make_char_prop
        set_char_prop_hp_mp 44, 15
        set_char_prop_cmds FIGHT, RUNIC, MAGIC, ITEM
        set_char_prop_stats 34, 34, 31, 36, 16, 44, 31, 7, 9
        set_char_prop_equip EMPTY, EMPTY, HAIR_BAND, EMPTY
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_NORMAL
        end_char_prop

; ------------------------------------------------------------------------------

; 7: strago
        make_char_prop
        set_char_prop_hp_mp 35, 13
        set_char_prop_cmds FIGHT, LORE, MAGIC, ITEM
        set_char_prop_stats 28, 25, 19, 34, 10, 33, 27, 6, 7
        set_char_prop_equip MITHRIL_ROD, MITHRIL_SHLD, PLUMED_HAT, COTTON_ROBE
        set_char_prop_flags RUN_FACTOR_LOW, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 8: relm
        make_char_prop
        set_char_prop_hp_mp 37, 18
        set_char_prop_cmds FIGHT, SKETCH, MAGIC, ITEM
        set_char_prop_stats 26, 34, 22, 44, 11, 35, 30, 13, 9
        set_char_prop_equip CHOCOBO_BRSH, MITHRIL_SHLD, PLUMED_HAT, SILK_ROBE
        set_char_prop_relics MEMENTO_RING
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_NORMAL
        end_char_prop

; ------------------------------------------------------------------------------

; 9: setzer
        make_char_prop
        set_char_prop_hp_mp 46, 9
        set_char_prop_cmds FIGHT, SLOT, MAGIC, ITEM
        set_char_prop_stats 36, 32, 32, 29, 18, 48, 26, 9, 1
        set_char_prop_equip CARDS, MITHRIL_SHLD, BANDANA, MITHRIL_VEST
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_NORMAL
        end_char_prop

; ------------------------------------------------------------------------------

; 10: mog
        make_char_prop
        set_char_prop_hp_mp 39, 16
        set_char_prop_cmds FIGHT, DANCE, MAGIC, ITEM
        set_char_prop_stats 29, 36, 26, 35, 16, 52, 36, 10, 12
        set_char_prop_equip MITHRIL_PIKE, MITHRIL_SHLD
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_VERY_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 11: gau
        make_char_prop
        set_char_prop_hp_mp 45, 10
        set_char_prop_cmds RAGE, LEAP, MAGIC, ITEM
        set_char_prop_stats 44, 38, 36, 34, 99, 44, 34, 21, 18
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 12: gogo
        make_char_prop
        set_char_prop_hp_mp 36, 12
        set_char_prop_cmds MIMIC
        set_char_prop_stats 25, 30, 20, 26, 13, 39, 25, 10, 6
        set_char_prop_equip MITHRILKNIFE, MITHRIL_SHLD, PLUMED_HAT, MITHRIL_VEST
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 13: umaro
        make_char_prop
        set_char_prop_hp_mp 60, 0
        set_char_prop_stats 57, 33, 46, 37, 47, 89, 68, 8, 5
        set_char_prop_equip BONE_CLUB, EMPTY, EMPTY, SNOW_MUFFLER
        set_char_prop_flags RUN_FACTOR_LOW, LEVEL_MOD_NORMAL
        end_char_prop

; ------------------------------------------------------------------------------

; 14: banon
        make_char_prop
        set_char_prop_hp_mp 46, 16
        set_char_prop_cmds FIGHT, HEALTH, NONE, ITEM
        set_char_prop_stats 10, 24, 11, 32, 6, 56, 51, 36, 32
        set_char_prop_equip PUNISHER, EMPTY, MAGUS_HAT, SILK_ROBE
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_LOW, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 15: leo
        make_char_prop
        set_char_prop_hp_mp 50, 10
        set_char_prop_cmds FIGHT, SHOCK, NONE, ITEM
        set_char_prop_stats 52, 38, 41, 36, 60, 63, 41, 22, 21
        set_char_prop_equip CRYSTAL, AEGIS_SHLD, GOLD_HELMET, GOLD_ARMOR
        set_char_prop_relics ATLAS_ARMLET, OFFERING
        set_char_prop_flags RUN_FACTOR_LOW, LEVEL_MOD_VERY_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 16: ghost 1
        make_char_prop
        set_char_prop_hp_mp 26, 1
        set_char_prop_cmds FIGHT, POSSESS, NONE, ITEM
        set_char_prop_stats 14, 15, 10, 30, 22, 66, 52, 0, 0
        set_char_prop_relics RELIC_RING
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 17: ghost 2
        make_char_prop
        set_char_prop_hp_mp 20, 1
        set_char_prop_cmds FIGHT, POSSESS, NONE, ITEM
        set_char_prop_stats 4, 8, 2, 15, 10, 17, 11, 0, 0
        set_char_prop_relics RELIC_RING
        set_char_prop_flags RUN_FACTOR_LOW, LEVEL_MOD_LOW, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 18: kupek
        make_char_prop
        set_char_prop_hp_mp 50, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 18, 11, 12, 33, 35, 47, 27, 7, 5
        set_char_prop_equip MITHRIL_PIKE, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 19: kupop
        make_char_prop
        set_char_prop_hp_mp 54, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 18, 14, 12, 33, 1, 38, 26, 7, 5
        set_char_prop_equip MORNING_STAR, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 20: kumama
        make_char_prop
        set_char_prop_hp_mp 48, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 18, 14, 12, 33, 1, 42, 33, 7, 5
        set_char_prop_equip MITHRIL_CLAW, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 21: kuku
        make_char_prop
        set_char_prop_hp_mp 64, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 17, 14, 12, 33, 11, 40, 32, 7, 5
        set_char_prop_equip FLAIL, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_LOW, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 22: kutan
        make_char_prop
        set_char_prop_hp_mp 55, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 16, 14, 12, 33, 11, 44, 29, 7, 5
        set_char_prop_equip MITHRILBLADE, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 23: kupan
        make_char_prop
        set_char_prop_hp_mp 51, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 20, 14, 12, 33, 21, 45, 30, 7, 5
        set_char_prop_equip FULL_MOON, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 24: kushu
        make_char_prop
        set_char_prop_hp_mp 52, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 24, 14, 12, 33, 27, 41, 31, 7, 5
        set_char_prop_equip CHOCOBO_BRSH, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 25: kurin
        make_char_prop
        set_char_prop_hp_mp 53, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 19, 14, 12, 33, 20, 41, 31, 7, 5
        set_char_prop_equip MITHRIL_PIKE, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 26: kuru
        make_char_prop
        set_char_prop_hp_mp 50, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 17, 14, 12, 33, 44, 27, 19, 7, 5
        set_char_prop_equip MITHRILBLADE, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 27: kamog
        make_char_prop
        set_char_prop_hp_mp 53, 9
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 20, 14, 12, 33, 11, 40, 33, 7, 5
        set_char_prop_equip BOOMERANG, BUCKLER
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 28: mog (3 scenarios)
        make_char_prop
        set_char_prop_hp_mp 12, 34
        set_char_prop_stats 12, 12, 12, 12, 12, 12, 12, 12, 12
        set_char_prop_flags RUN_FACTOR_VERY_LOW, LEVEL_MOD_VERY_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 29:
        empty_char_prop

; ------------------------------------------------------------------------------

; 30: maduin
        make_char_prop
        set_char_prop_hp_mp 10, 10
        set_char_prop_stats 30, 30, 30, 30, 30, 30, 30, 30, 30
        set_char_prop_relics SPRINT_SHOES
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_NORMAL
        end_char_prop

; ------------------------------------------------------------------------------

; 31: shadow at colosseum
        make_char_prop
        set_char_prop_hp_mp 51, 6
        set_char_prop_cmds FIGHT, NONE, MAGIC, NONE
        set_char_prop_stats 40, 40, 30, 35, 25, 49, 27, 30, 12
        set_char_prop_equip BLOSSOM, MITHRIL_SHLD, MITHRIL_HELM, NINJA_GEAR
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH
        end_char_prop

; ------------------------------------------------------------------------------

; 32: wedge
        make_char_prop
        set_char_prop_hp_mp 68, 0
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 40, 35, 46, 29, 24, 77, 50, 15, 0
        set_char_prop_equip MITHRILBLADE, BUCKLER, LEATHER_HAT, LEATHERARMOR
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_LOW, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 33: vicks
        make_char_prop
        set_char_prop_hp_mp 70, 0
        set_char_prop_cmds FIGHT, NONE, NONE, ITEM
        set_char_prop_stats 41, 36, 45, 28, 27, 79, 50, 12, 0
        set_char_prop_equip MITHRILBLADE, BUCKLER, LEATHER_HAT, LEATHERARMOR
        set_char_prop_flags RUN_FACTOR_NORMAL, LEVEL_MOD_LOW, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 34-40
.repeat 7
        empty_char_prop
.endrep

; ------------------------------------------------------------------------------

; 41: kefka
        make_char_prop
        set_char_prop_hp_mp 14, 17
        set_char_prop_stats 14, 26, 18, 22, 7, 42, 36, 50, 40
        set_char_prop_equip MORNING_STAR, EMPTY, MITHRIL_HELM, MITHRIL_VEST
        set_char_prop_relics RIBBON
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 42: kefka
        make_char_prop
        set_char_prop_hp_mp 255, 17
        set_char_prop_stats 15, 15, 15, 15, 15, 50, 50, 10, 10
        set_char_prop_equip MORNING_STAR, EMPTY, MITHRIL_HELM, MITHRIL_VEST
        set_char_prop_relics RIBBON
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 43: kefka
        make_char_prop
        set_char_prop_hp_mp 50, 50
        set_char_prop_stats 80, 80, 80, 80, 80, 180, 180, 60, 60
        set_char_prop_equip MORNING_STAR, PALADIN_SHLD, EMPTY, EMPTY
        set_char_prop_relics RIBBON
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 44: kefka
        make_char_prop
        set_char_prop_hp_mp 22, 17
        set_char_prop_stats 15, 15, 15, 15, 15, 50, 50, 10, 10
        set_char_prop_equip MORNING_STAR, EMPTY, MITHRIL_HELM, MITHRIL_VEST
        set_char_prop_relics RIBBON
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 45: kefka
        make_char_prop
        set_char_prop_hp_mp 34, 17
        set_char_prop_stats 15, 15, 15, 15, 15, 50, 50, 10, 10
        set_char_prop_equip MORNING_STAR, EMPTY, MITHRIL_HELM, MITHRIL_VEST
        set_char_prop_relics RIBBON
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_HIGH, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 46: kefka
        make_char_prop
        set_char_prop_hp_mp 14, 17
        set_char_prop_stats 15, 15, 15, 15, 15, 50, 50, 10, 10
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 47: kefka
        make_char_prop
        set_char_prop_hp_mp 14, 17
        set_char_prop_stats 15, 15, 15, 15, 15, 50, 50, 10, 10
        set_char_prop_flags RUN_FACTOR_HIGH, LEVEL_MOD_NORMAL, CHAR_PROP_FIXED_EQUIP
        end_char_prop

; ------------------------------------------------------------------------------

; 48-63
.repeat 16
        empty_char_prop
.endrep

; ------------------------------------------------------------------------------
