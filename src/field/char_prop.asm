; ------------------------------------------------------------------------------

.macro reset_char_prop
        CharProp_HP                     .set 0
        CharProp_MP                     .set 0
        CharProp_Cmd1                   .set 0
        CharProp_Cmd2                   .set 0
        CharProp_Cmd3                   .set 0
        CharProp_Cmd4                   .set 0
        CharProp_Strength               .set 0
        CharProp_Agility                .set 0
        CharProp_Stamina                .set 0
        CharProp_MagicPower             .set 0
        CharProp_BattlePower            .set 0
        CharProp_Defense                .set 0
        CharProp_MagicDefense           .set 0
        CharProp_Evade                  .set 0
        CharProp_MagicBlock             .set 0
        CharProp_Weapon                 .set 0
        CharProp_Shield                 .set 0
        CharProp_Helmet                 .set 0
        CharProp_Armor                  .set 0
        CharProp_Relic1                 .set 0
        CharProp_Relic2                 .set 0
        CharProp_RunFactor              .set 0
        CharProp_LevelMod               .set 0
        CharProp_FixedEquip             .set 0
.endmac

.macro make_char_prop
        .byte CharProp_HP, CharProp_MP
        .byte CharProp_Cmd1, CharProp_Cmd2, CharProp_Cmd3, CharProp_Cmd4
        .byte CharProp_Strength, CharProp_Agility, CharProp_Stamina
        .byte CharProp_MagicPower, CharProp_BattlePower
        .byte CharProp_Defense, CharProp_MagicDefense
        .byte CharProp_Evade, CharProp_MagicBlock
        .byte CharProp_Weapon, CharProp_Shield
        .byte CharProp_Helmet, CharProp_Armor
        .byte CharProp_Relic1, CharProp_Relic2
        .byte CharProp_RunFactor|CharProp_LevelMod|CharProp_FixedEquip
.endmac

; ------------------------------------------------------------------------------

.export CharProp

; ------------------------------------------------------------------------------

.segment "char_prop"

CharProp:

; ------------------------------------------------------------------------------

; 0: terra
reset_char_prop
CharProp_HP                             .set 40
CharProp_MP                             .set 16
CharProp_Cmd1                           .set BATTLE_CMD_FIGHT
CharProp_Cmd2                           .set BATTLE_CMD_MORPH
CharProp_Cmd3                           .set BATTLE_CMD_MAGIC
CharProp_Cmd4                           .set BATTLE_CMD_ITEM
CharProp_Strength                       .set 31
CharProp_Agility                        .set 33
CharProp_Stamina                        .set 28
CharProp_MagicPower                     .set 39
CharProp_BattlePower                    .set 12
CharProp_Defense                        .set 42
CharProp_MagicDefense                   .set 33
CharProp_Evade                          .set 5
CharProp_MagicBlock                     .set 7
CharProp_Weapon                         .set ITEM_MITHRILKNIFE
CharProp_Shield                         .set ITEM_BUCKLER
CharProp_Helmet                         .set ITEM_LEATHER_HAT
CharProp_Armor                          .set ITEM_LEATHERARMOR
CharProp_Relic1                         .set ITEM_EMPTY
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_RunFactor                      .set RUN_FACTOR_NORMAL
CharProp_LevelMod                       .set LEVEL_MOD_NORMAL
make_char_prop

; ------------------------------------------------------------------------------

; 1: locke
reset_char_prop
CharProp_HP                             .set 48
CharProp_MP                             .set 7
CharProp_Cmd1                           .set BATTLE_CMD_FIGHT
CharProp_Cmd2                           .set BATTLE_CMD_STEAL
CharProp_Cmd3                           .set BATTLE_CMD_MAGIC
CharProp_Cmd4                           .set BATTLE_CMD_ITEM
CharProp_Strength                       .set 37
CharProp_Agility                        .set 40
CharProp_Stamina                        .set 31
CharProp_MagicPower                     .set 28
CharProp_BattlePower                    .set 14
CharProp_Defense                        .set 46
CharProp_MagicDefense                   .set 23
CharProp_Evade                          .set 15
CharProp_MagicBlock                     .set 2
CharProp_Weapon                         .set ITEM_DIRK
CharProp_Shield                         .set ITEM_EMPTY
CharProp_Helmet                         .set ITEM_LEATHER_HAT
CharProp_Armor                          .set ITEM_LEATHERARMOR
CharProp_Relic1                         .set ITEM_EMPTY
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_RunFactor                      .set RUN_FACTOR_HIGH
CharProp_LevelMod                       .set LEVEL_MOD_HIGH
make_char_prop

; ------------------------------------------------------------------------------

; 2: cyan
        .byte 53, 5
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_SWDTECH
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 40, 28, 33
        .byte 25, 25
        .byte 48, 20
        .byte 6, 1
        .byte ITEM_ASHURA
        .byte ITEM_BUCKLER
        .byte ITEM_LEATHER_HAT
        .byte ITEM_LEATHERARMOR
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_LOW|LEVEL_MOD_HIGH

; ------------------------------------------------------------------------------

; 3: shadow
        .byte 51, 6
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_THROW
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 39, 38, 30
        .byte 33, 23
        .byte 47, 25
        .byte 28, 9
        .byte ITEM_IMPERIAL
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_NINJA_GEAR
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_HIGH|LEVEL_MOD_NORMAL

; ------------------------------------------------------------------------------

; 4: edgar
        .byte 49, 6
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_TOOLS
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 39, 30, 34
        .byte 29, 20
        .byte 50, 22
        .byte 4, 1
        .byte ITEM_MITHRILBLADE
        .byte ITEM_BUCKLER
        .byte ITEM_LEATHER_HAT
        .byte ITEM_LEATHERARMOR
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_NORMAL|LEVEL_MOD_HIGH

; ------------------------------------------------------------------------------

; 5: sabin
        .byte 58, 3
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_BLITZ
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 47, 37, 39
        .byte 28, 26
        .byte 53, 21
        .byte 12, 4
        .byte ITEM_METALKNUCKLE
        .byte ITEM_EMPTY
        .byte ITEM_LEATHER_HAT
        .byte ITEM_KUNG_FU_SUIT
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_NORMAL|LEVEL_MOD_HIGH

; ------------------------------------------------------------------------------

; 6: celes
        .byte 44, 15
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_RUNIC
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 34, 34, 31
        .byte 36, 16
        .byte 44, 31
        .byte 7, 9
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_HAIR_BAND
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_NORMAL|LEVEL_MOD_NORMAL

; ------------------------------------------------------------------------------

; 7: strago
        .byte 35, 13
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_LORE
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 28, 25, 19
        .byte 34, 10
        .byte 33, 27
        .byte 6, 7
        .byte ITEM_MITHRIL_ROD
        .byte ITEM_MITHRIL_SHLD
        .byte ITEM_PLUMED_HAT
        .byte ITEM_COTTON_ROBE
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_LOW|LEVEL_MOD_HIGH

; ------------------------------------------------------------------------------

; 8: relm
        .byte 37, 18
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_SKETCH
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 26, 34, 22
        .byte 44, 11
        .byte 35, 30
        .byte 13, 9
        .byte ITEM_CHOCOBO_BRSH
        .byte ITEM_MITHRIL_SHLD
        .byte ITEM_PLUMED_HAT
        .byte ITEM_SILK_ROBE
        .byte ITEM_MEMENTO_RING
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_HIGH|LEVEL_MOD_NORMAL

; ------------------------------------------------------------------------------

; 9: setzer
        .byte 46, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_SLOT
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 36, 32, 32
        .byte 29, 18
        .byte 48, 26
        .byte 9, 1
        .byte ITEM_CARDS
        .byte ITEM_MITHRIL_SHLD
        .byte ITEM_BANDANA
        .byte ITEM_MITHRIL_VEST
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_NORMAL|LEVEL_MOD_NORMAL

; ------------------------------------------------------------------------------

; 10: mog
        .byte 39, 16
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_DANCE
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 29, 36, 26
        .byte 35, 16
        .byte 52, 36
        .byte 10, 12
        .byte ITEM_MITHRIL_PIKE
        .byte ITEM_MITHRIL_SHLD
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_HIGH|LEVEL_MOD_VERY_HIGH

; ------------------------------------------------------------------------------

; 11: gau
        .byte 45, 10
        .byte BATTLE_CMD_RAGE
        .byte BATTLE_CMD_LEAP
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_ITEM
        .byte 44, 38, 36
        .byte 34, 99
        .byte 44, 34
        .byte 21, 18
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_HIGH|LEVEL_MOD_HIGH

; ------------------------------------------------------------------------------

; 12: gogo
        .byte 36, 12
        .byte BATTLE_CMD_MIMIC
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte 25, 30, 20
        .byte 26, 13
        .byte 39, 25
        .byte 10, 6
        .byte ITEM_MITHRILKNIFE
        .byte ITEM_MITHRIL_SHLD
        .byte ITEM_PLUMED_HAT
        .byte ITEM_MITHRIL_VEST
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_NORMAL|LEVEL_MOD_HIGH

; ------------------------------------------------------------------------------

; 13: umaro
        .byte 60, 0
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte 57, 33, 46
        .byte 37, 47
        .byte 89, 68
        .byte 8, 5
        .byte ITEM_BONE_CLUB
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_SNOW_MUFFLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_LOW|LEVEL_MOD_NORMAL

; ------------------------------------------------------------------------------

; 14: banon
        .byte 46, 16
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_HEALTH
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 10, 24, 11
        .byte 32, 6
        .byte 56, 51
        .byte 36, 32
        .byte ITEM_PUNISHER
        .byte ITEM_EMPTY
        .byte ITEM_MAGUS_HAT
        .byte ITEM_SILK_ROBE
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_LOW|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 15: leo
        .byte 50, 10
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_SHOCK
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 52, 38, 41
        .byte 36, 60
        .byte 63, 41
        .byte 22, 21
        .byte ITEM_CRYSTAL
        .byte ITEM_AEGIS_SHLD
        .byte ITEM_GOLD_HELMET
        .byte ITEM_GOLD_ARMOR
        .byte ITEM_ATLAS_ARMLET
        .byte ITEM_OFFERING
        .byte RUN_FACTOR_LOW|LEVEL_MOD_VERY_HIGH|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 16: ghost 1
        .byte 26, 1
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_POSSESS
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 14, 15, 10
        .byte 30, 22
        .byte 66, 52
        .byte 0, 0
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_RELIC_RING
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_HIGH|LEVEL_MOD_HIGH|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 17: ghost 2
        .byte 20, 1
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_POSSESS
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 4, 8, 2
        .byte 15, 10
        .byte 17, 11
        .byte 0, 0
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_RELIC_RING
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_LOW|LEVEL_MOD_LOW|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 18: kupek
        .byte 50, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 18, 11, 12
        .byte 33, 35
        .byte 47, 27
        .byte 7, 5
        .byte ITEM_MITHRIL_PIKE
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_HIGH|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 19: kupop
        .byte 54, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 18, 14, 12
        .byte 33, 1
        .byte 38, 26
        .byte 7, 5
        .byte ITEM_MORNING_STAR
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_NORMAL|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 20: kumama
        .byte 48, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 18, 14, 12
        .byte 33, 1
        .byte 42, 33
        .byte 7, 5
        .byte ITEM_MITHRIL_CLAW
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_NORMAL|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 21: kuku
        .byte 64, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 17, 14, 12
        .byte 33, 11
        .byte 40, 32
        .byte 7, 5
        .byte ITEM_FLAIL
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_LOW|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 22: kutan
        .byte 55, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 16, 14, 12
        .byte 33, 11
        .byte 44, 29
        .byte 7, 5
        .byte ITEM_MITHRILBLADE
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_NORMAL|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 23: kupan
        .byte 51, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 20, 14, 12
        .byte 33, 21
        .byte 45, 30
        .byte 7, 5
        .byte ITEM_FULL_MOON
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_HIGH|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 24: kushu
        .byte 52, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 24, 14, 12
        .byte 33, 27
        .byte 41, 31
        .byte 7, 5
        .byte ITEM_CHOCOBO_BRSH
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_HIGH|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 25: kurin
        .byte 53, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 19, 14, 12
        .byte 33, 20
        .byte 41, 31
        .byte 7, 5
        .byte ITEM_MITHRIL_PIKE
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_NORMAL|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 26: kuru
        .byte 50, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 17, 14, 12
        .byte 33, 44
        .byte 27, 19
        .byte 7, 5
        .byte ITEM_MITHRILBLADE
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_NORMAL|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 27: kamog
        .byte 53, 9
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 20, 14, 12
        .byte 33, 11
        .byte 40, 33
        .byte 7, 5
        .byte ITEM_BOOMERANG
        .byte ITEM_BUCKLER
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_HIGH|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 28: mog
        .byte 12, 34
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte 12, 12, 12
        .byte 12, 12
        .byte 12, 12
        .byte 12, 12
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_VERY_LOW|LEVEL_MOD_VERY_HIGH|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 29:
reset_char_prop
make_char_prop

; ------------------------------------------------------------------------------

; 30: maduin
        .byte 10, 10
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte 30, 30, 30
        .byte 30, 30
        .byte 30, 30
        .byte 30, 30
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte ITEM_SPRINT_SHOES
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_HIGH|LEVEL_MOD_NORMAL

; ------------------------------------------------------------------------------

; 31:
        .byte 51, 6
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_MAGIC
        .byte BATTLE_CMD_NONE
        .byte 40, 40, 30
        .byte 35, 25
        .byte 49, 27
        .byte 30, 12
        .byte ITEM_BLOSSOM
        .byte ITEM_MITHRIL_SHLD
        .byte ITEM_MITHRIL_HELM
        .byte ITEM_NINJA_GEAR
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_HIGH|LEVEL_MOD_HIGH

; ------------------------------------------------------------------------------

; 32: wedge
        .byte 68, 0
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 40, 35, 46
        .byte 29, 24
        .byte 77, 50
        .byte 15, 0
        .byte ITEM_MITHRILBLADE
        .byte ITEM_BUCKLER
        .byte ITEM_LEATHER_HAT
        .byte ITEM_LEATHERARMOR
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_NORMAL|LEVEL_MOD_LOW|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 33: vicks
        .byte 70, 0
        .byte BATTLE_CMD_FIGHT
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_NONE
        .byte BATTLE_CMD_ITEM
        .byte 41, 36, 45
        .byte 28, 27
        .byte 79, 50
        .byte 12, 0
        .byte ITEM_MITHRILBLADE
        .byte ITEM_BUCKLER
        .byte ITEM_LEATHER_HAT
        .byte ITEM_LEATHERARMOR
        .byte ITEM_EMPTY
        .byte ITEM_EMPTY
        .byte RUN_FACTOR_NORMAL|LEVEL_MOD_LOW|CHAR_PROP_FIXED_EQUIP

; ------------------------------------------------------------------------------

; 34:
reset_char_prop
make_char_prop

; ------------------------------------------------------------------------------

; 35:
make_char_prop

; ------------------------------------------------------------------------------

; 36:
make_char_prop

; ------------------------------------------------------------------------------

; 37:
make_char_prop

; ------------------------------------------------------------------------------

; 38:
make_char_prop

; ------------------------------------------------------------------------------

; 39:
make_char_prop

; ------------------------------------------------------------------------------

; 40:
make_char_prop

; ------------------------------------------------------------------------------

; 41: kefka
reset_char_prop
CharProp_HP                             .set 14
CharProp_MP                             .set 17
CharProp_Cmd1                           .set BATTLE_CMD_NONE
CharProp_Cmd2                           .set BATTLE_CMD_NONE
CharProp_Cmd3                           .set BATTLE_CMD_NONE
CharProp_Cmd4                           .set BATTLE_CMD_NONE
CharProp_Strength                       .set 14
CharProp_Agility                        .set 26
CharProp_Stamina                        .set 18
CharProp_MagicPower                     .set 22
CharProp_BattlePower                    .set 7
CharProp_Defense                        .set 42
CharProp_MagicDefense                   .set 36
CharProp_Evade                          .set 50
CharProp_MagicBlock                     .set 40
CharProp_Weapon                         .set ITEM_MORNING_STAR
CharProp_Shield                         .set ITEM_EMPTY
CharProp_Helmet                         .set ITEM_MITHRIL_HELM
CharProp_Armor                          .set ITEM_MITHRIL_VEST
CharProp_Relic1                         .set ITEM_RIBBON
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_FixedEquip                     .set CHAR_PROP_FIXED_EQUIP
make_char_prop

; ------------------------------------------------------------------------------

; 42: kefka
reset_char_prop
CharProp_HP                             .set 255
CharProp_MP                             .set 17
CharProp_Cmd1                           .set BATTLE_CMD_NONE
CharProp_Cmd2                           .set BATTLE_CMD_NONE
CharProp_Cmd3                           .set BATTLE_CMD_NONE
CharProp_Cmd4                           .set BATTLE_CMD_NONE
CharProp_Strength                       .set 15
CharProp_Agility                        .set 15
CharProp_Stamina                        .set 15
CharProp_MagicPower                     .set 15
CharProp_BattlePower                    .set 15
CharProp_Defense                        .set 50
CharProp_MagicDefense                   .set 50
CharProp_Evade                          .set 10
CharProp_MagicBlock                     .set 10
CharProp_Weapon                         .set ITEM_MORNING_STAR
CharProp_Shield                         .set ITEM_EMPTY
CharProp_Helmet                         .set ITEM_MITHRIL_HELM
CharProp_Armor                          .set ITEM_MITHRIL_VEST
CharProp_Relic1                         .set ITEM_RIBBON
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_LevelMod                       .set LEVEL_MOD_HIGH
CharProp_FixedEquip                     .set CHAR_PROP_FIXED_EQUIP
make_char_prop

; ------------------------------------------------------------------------------

; 43: kefka
reset_char_prop
CharProp_HP                             .set 50
CharProp_MP                             .set 50
CharProp_Cmd1                           .set BATTLE_CMD_NONE
CharProp_Cmd2                           .set BATTLE_CMD_NONE
CharProp_Cmd3                           .set BATTLE_CMD_NONE
CharProp_Cmd4                           .set BATTLE_CMD_NONE
CharProp_Strength                       .set 80
CharProp_Agility                        .set 80
CharProp_Stamina                        .set 80
CharProp_MagicPower                     .set 80
CharProp_BattlePower                    .set 80
CharProp_Defense                        .set 180
CharProp_MagicDefense                   .set 180
CharProp_Evade                          .set 60
CharProp_MagicBlock                     .set 60
CharProp_Weapon                         .set ITEM_MORNING_STAR
CharProp_Shield                         .set ITEM_PALADIN_SHLD
CharProp_Helmet                         .set ITEM_EMPTY
CharProp_Armor                          .set ITEM_EMPTY
CharProp_Relic1                         .set ITEM_RIBBON
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_LevelMod                       .set LEVEL_MOD_HIGH
CharProp_FixedEquip                     .set CHAR_PROP_FIXED_EQUIP
make_char_prop

; ------------------------------------------------------------------------------

; 44: kefka
reset_char_prop
CharProp_HP                             .set 22
CharProp_MP                             .set 17
CharProp_Cmd1                           .set BATTLE_CMD_NONE
CharProp_Cmd2                           .set BATTLE_CMD_NONE
CharProp_Cmd3                           .set BATTLE_CMD_NONE
CharProp_Cmd4                           .set BATTLE_CMD_NONE
CharProp_Strength                       .set 15
CharProp_Agility                        .set 15
CharProp_Stamina                        .set 15
CharProp_MagicPower                     .set 15
CharProp_BattlePower                    .set 15
CharProp_Defense                        .set 50
CharProp_MagicDefense                   .set 50
CharProp_Evade                          .set 10
CharProp_MagicBlock                     .set 10
CharProp_Weapon                         .set ITEM_MORNING_STAR
CharProp_Shield                         .set ITEM_EMPTY
CharProp_Helmet                         .set ITEM_MITHRIL_HELM
CharProp_Armor                          .set ITEM_MITHRIL_VEST
CharProp_Relic1                         .set ITEM_RIBBON
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_LevelMod                       .set LEVEL_MOD_HIGH
CharProp_FixedEquip                     .set CHAR_PROP_FIXED_EQUIP
make_char_prop

; ------------------------------------------------------------------------------

; 45: kefka
reset_char_prop
CharProp_HP                             .set 34
CharProp_MP                             .set 17
CharProp_Cmd1                           .set BATTLE_CMD_NONE
CharProp_Cmd2                           .set BATTLE_CMD_NONE
CharProp_Cmd3                           .set BATTLE_CMD_NONE
CharProp_Cmd4                           .set BATTLE_CMD_NONE
CharProp_Strength                       .set 15
CharProp_Agility                        .set 15
CharProp_Stamina                        .set 15
CharProp_MagicPower                     .set 15
CharProp_BattlePower                    .set 15
CharProp_Defense                        .set 50
CharProp_MagicDefense                   .set 50
CharProp_Evade                          .set 10
CharProp_MagicBlock                     .set 10
CharProp_Weapon                         .set ITEM_MORNING_STAR
CharProp_Shield                         .set ITEM_EMPTY
CharProp_Helmet                         .set ITEM_MITHRIL_HELM
CharProp_Armor                          .set ITEM_MITHRIL_VEST
CharProp_Relic1                         .set ITEM_RIBBON
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_LevelMod                       .set LEVEL_MOD_HIGH
CharProp_FixedEquip                     .set CHAR_PROP_FIXED_EQUIP
make_char_prop

; ------------------------------------------------------------------------------

; 46: kefka
reset_char_prop
CharProp_HP                             .set 14
CharProp_MP                             .set 17
CharProp_Cmd1                           .set BATTLE_CMD_NONE
CharProp_Cmd2                           .set BATTLE_CMD_NONE
CharProp_Cmd3                           .set BATTLE_CMD_NONE
CharProp_Cmd4                           .set BATTLE_CMD_NONE
CharProp_Strength                       .set 15
CharProp_Agility                        .set 15
CharProp_Stamina                        .set 15
CharProp_MagicPower                     .set 15
CharProp_BattlePower                    .set 15
CharProp_Defense                        .set 50
CharProp_MagicDefense                   .set 50
CharProp_Evade                          .set 10
CharProp_MagicBlock                     .set 10
CharProp_Weapon                         .set ITEM_EMPTY
CharProp_Shield                         .set ITEM_EMPTY
CharProp_Helmet                         .set ITEM_EMPTY
CharProp_Armor                          .set ITEM_EMPTY
CharProp_Relic1                         .set ITEM_EMPTY
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_FixedEquip                     .set CHAR_PROP_FIXED_EQUIP
make_char_prop

; ------------------------------------------------------------------------------

; 47: kefka
reset_char_prop
CharProp_HP                             .set 14
CharProp_MP                             .set 17
CharProp_Cmd1                           .set BATTLE_CMD_NONE
CharProp_Cmd2                           .set BATTLE_CMD_NONE
CharProp_Cmd3                           .set BATTLE_CMD_NONE
CharProp_Cmd4                           .set BATTLE_CMD_NONE
CharProp_Strength                       .set 15
CharProp_Agility                        .set 15
CharProp_Stamina                        .set 15
CharProp_MagicPower                     .set 15
CharProp_BattlePower                    .set 15
CharProp_Defense                        .set 50
CharProp_MagicDefense                   .set 50
CharProp_Evade                          .set 10
CharProp_MagicBlock                     .set 10
CharProp_Weapon                         .set ITEM_EMPTY
CharProp_Shield                         .set ITEM_EMPTY
CharProp_Helmet                         .set ITEM_EMPTY
CharProp_Armor                          .set ITEM_EMPTY
CharProp_Relic1                         .set ITEM_EMPTY
CharProp_Relic2                         .set ITEM_EMPTY
CharProp_FixedEquip                     .set CHAR_PROP_FIXED_EQUIP
make_char_prop

; ------------------------------------------------------------------------------

; 48: tork
reset_char_prop
make_char_prop

; ------------------------------------------------------------------------------

; 49: jade
make_char_prop

; ------------------------------------------------------------------------------

; 50: custer
make_char_prop

; ------------------------------------------------------------------------------

; 51: fabian
make_char_prop

; ------------------------------------------------------------------------------

; 52: drake
make_char_prop

; ------------------------------------------------------------------------------

; 53: sara
make_char_prop

; ------------------------------------------------------------------------------

; 54: case
make_char_prop

; ------------------------------------------------------------------------------

; 55: siele
make_char_prop

; ------------------------------------------------------------------------------

; 56: ray
make_char_prop

; ------------------------------------------------------------------------------

; 57: reiker
make_char_prop

; ------------------------------------------------------------------------------

; 58: lance
make_char_prop

; ------------------------------------------------------------------------------

; 59: bob
make_char_prop

; ------------------------------------------------------------------------------

; 60: pepper
make_char_prop

; ------------------------------------------------------------------------------

; 61: tau
make_char_prop

; ------------------------------------------------------------------------------

; 62: victor
make_char_prop

; ------------------------------------------------------------------------------

; 63: ho
make_char_prop

; ------------------------------------------------------------------------------
