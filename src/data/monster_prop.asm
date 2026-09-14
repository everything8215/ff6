.export MonsterProp, MonsterSpecialAnim

; ------------------------------------------------------------------------------

.include "monster_prop.mac"

; ------------------------------------------------------------------------------

; cf/0000
.segment "monster_prop"

MonsterProp:

; ------------------------------------------------------------------------------

; cf/37c0
.segment "monster_special_anim"

MonsterSpecialAnim:

; ------------------------------------------------------------------------------

; 0: GUARD
        monster_prop GUARD
        speed 30
        attack_power 16
        defense 100
        mag_def 140
        mag_pwr 6
        hp 40
        mp 15
        exp 48
        gil 48
        level 5
        attack_anim DIRK
        special_attack RED_STAB, DMG_150_PCT
        metamorph 0, 0
        monster_flags HUMAN
        elem_weak POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 1: SOLDIER
        monster_prop SOLDIER
        speed 30
        attack_power 12
        defense 80
        mag_def 150
        mag_pwr 10
        hp 100
        mp 15
        gil 48
        level 11
        attack_anim RUNE_EDGE
        special_attack RED_STAB, DMG_150_PCT
        metamorph 0, 0
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_weak POISON
        immune_status1 BLIND
        immune_status2 SLEEP
        end_monster_prop

; ------------------------------------------------------------------------------

; 2: TEMPLAR
        monster_prop TEMPLAR
        speed 30
        attack_power 16
        defense 50
        mag_def 150
        mag_pwr 10
        hp 205
        mp 50
        gil 96
        level 11
        attack_anim TRIDENT
        special_attack VERT_SLASH, DMG_200_PCT
        metamorph 1, 2
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_weak POISON
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 3: NINJA
        monster_prop NINJA
        speed 37
        attack_power 22
        evade 50
        defense 135
        mag_def 140
        mag_pwr 5
        hp 1650
        mp 130
        exp 694
        gil 520
        level 27
        attack_anim FORGED
        special_attack BUBBLE, VANISH, NO_DMG
        metamorph 25, 4
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_absorb POISON
        elem_weak {LIGHTNING, HOLY}
        immune_status1 {BLIND, PETRIFY}
        immune_status2 {NEAR_FATAL, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 4: SAMURAI
        monster_prop SAMURAI
        speed 20
        attack_power 13
        defense 10
        mag_def 20
        mag_pwr 10
        hp 3000
        mp 500
        exp 1545
        gil 791
        level 40
        attack_anim FORGED
        special_attack ARC_SLASH, DEAD, NO_DMG
        metamorph 16, 4
        monster_flags {HUMAN, IMP_DMG_BONUS}
        elem_weak POISON
        immune_status1 {ZOMBIE, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, IMAGE, SILENCE, BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 5: OROG
        monster_prop OROG
        speed 35
        attack_power 45
        defense 105
        mag_def 140
        mag_pwr 10
        hp 1584
        mp 250
        exp 510
        gil 716
        level 30
        attack_anim PARTISAN
        special_attack SMALL_PIERCE, ZOMBIE, NO_DMG
        metamorph 1, 3
        monster_flags {HUMAN, UNDEAD}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 6: MAG_ROADER_1
        monster_prop MAG_ROADER_1
        speed 30
        attack_power 12
        defense 25
        mag_def 140
        mag_pwr 1
        hp 420
        mp 100
        exp 232
        gil 277
        level 19
        attack_anim UNARMED
        special_attack WHEEL, DMG_150_PCT
        metamorph 4, 4
        monster_status CANT_ESCAPE
        elem_absorb ICE
        elem_weak FIRE
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, CONFUSE, SLEEP}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 7: RETAINER
        monster_prop RETAINER
        speed 35
        attack_power 13
        evade 40
        defense 100
        mag_def 180
        mag_pwr 5
        hp 7050
        mp 2600
        exp 2300
        gil 2000
        level 59
        attack_anim FORGED
        special_attack SKULL_SLASH, DEAD, NO_DMG
        metamorph 16, 4
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status HARDER_TO_RUN
        elem_weak POISON
        immune_status1 {BLIND, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 8: HAZER
        monster_prop HAZER
        speed 25
        attack_power 5
        defense 110
        mag_def 150
        mag_pwr 7
        hp 120
        mp 100
        exp 35
        gil 101
        level 12
        attack_anim ICE_ROD
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, HUMAN}
        elem_weak HOLY
        immune_status1 {ZOMBIE, IMP, DEAD}
        immune_status2 CONDEMNED
        end_monster_prop

; ------------------------------------------------------------------------------

; 9: DAHLING
        monster_prop DAHLING
        speed 35
        attack_power 1
        evade 20
        defense 110
        mag_def 145
        mag_pwr 8
        hp 3580
        mp 500
        exp 1151
        gil 1260
        level 37
        attack_anim ICE_ROD
        special_attack BLACK_CLOUD, BLIND, NO_DMG
        metamorph 19, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_ESCAPE
        elem_weak POISON
        immune_status1 {BLIND, ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 10: RAIN_MAN
        monster_prop RAIN_MAN
        speed 34
        attack_power 13
        mblock 30
        defense 110
        mag_def 145
        mag_pwr 10
        hp 2722
        mp 180
        exp 890
        gil 485
        level 39
        attack_anim UNARMED
        special_attack THIN_HORZ_SLASH, SLEEP, NO_DMG
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_SUPLEX
        elem_weak {ICE, HOLY, WATER}
        immune_status1 {ZOMBIE, MAGITEK, VANISH, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 11: BRAWLER
        monster_prop BRAWLER
        speed 35
        attack_power 14
        defense 100
        mag_def 70
        mag_pwr 10
        hp 137
        mp 100
        exp 79
        gil 84
        level 9
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 0, 0
        monster_flags {HUMAN, IMP_DMG_BONUS}
        elem_absorb POISON
        elem_weak ICE
        immune_status1 POISON
        apply_status2 BERSERK
        end_monster_prop

; ------------------------------------------------------------------------------

; 12: APOKRYPHOS
        monster_prop APOKRYPHOS
        speed 37
        attack_power 18
        defense 80
        mag_def 150
        mag_pwr 10
        hp 1900
        mp 195
        exp 1200
        gil 525
        level 26
        attack_anim ICE_ROD
        special_attack SINGLE_PUNCH, SILENCE, NO_DMG
        metamorph 14, 3
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        elem_weak {LIGHTNING, HOLY, WATER}
        immune_status1 {ZOMBIE, POISON, IMP}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 13: DARK_FORCE
        monster_prop DARK_FORCE
        speed 35
        attack_power 12
        defense 105
        mag_def 155
        mag_pwr 7
        hp 8940
        mp 700
        exp 2950
        gil 600
        level 55
        attack_anim ICE_ROD
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 14, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status HARDER_TO_RUN
        elem_weak HOLY
        immune_status1 IMP
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 14: WHISPER
        monster_prop WHISPER
        speed 30
        attack_power 12
        defense 95
        mag_def 150
        mag_pwr 10
        hp 230
        mp 90
        exp 42
        gil 125
        level 12
        attack_anim UNARMED
        special_attack FLOWER, IMP, NO_DMG
        metamorph 0, 0
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 15: OVER_MIND
        monster_prop OVER_MIND
        speed 30
        attack_power 12
        defense 55
        mag_def 150
        mag_pwr 7
        hp 390
        mp 190
        exp 65
        gil 228
        level 13
        attack_anim ICE_ROD
        special_attack SMALL_PIERCE, CONFUSE, NO_DMG
        metamorph 3, 2
        monster_flags UNDEAD
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 16: OSTEOSAUR
        monster_prop OSTEOSAUR
        speed 33
        attack_power 45
        defense 115
        mag_def 155
        mag_pwr 10
        hp 1584
        mp 143
        exp 770
        gil 542
        level 30
        attack_anim DRAGON_CLAW
        special_attack BONE, ZOMBIE, NO_DMG
        metamorph 3, 4
        monster_flags {DIE_AT_0_MP, UNDEAD}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 17: COMMANDER
        monster_prop COMMANDER
        speed 30
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 102
        mp 50
        exp 85
        gil 153
        level 10
        attack_anim RUNE_EDGE
        special_attack THIN_HORZ_SLASH, DMG_200_PCT
        metamorph 0, 0
        monster_flags HUMAN
        elem_weak POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 18: RHODOX
        monster_prop RHODOX
        speed 30
        attack_power 11
        defense 100
        mag_def 155
        mag_pwr 10
        hp 119
        mp 100
        exp 59
        gil 80
        level 7
        attack_anim UNARMED
        special_attack LIGHT_BEAM, DMG_500_PCT
        metamorph 2, 0
        monster_status CANT_SUPLEX
        immune_status1 BLIND
        immune_status2 {SILENCE, BERSERK}
        end_monster_prop

; ------------------------------------------------------------------------------

; 19: WERE_RAT
        monster_prop WERE_RAT
        speed 30
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 24
        mp 0
        exp 21
        gil 22
        level 4
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        monster_flags IMP_DMG_BONUS
        elem_absorb POISON
        elem_weak FIRE
        immune_status1 BLIND
        immune_status2 SLEEP
        end_monster_prop

; ------------------------------------------------------------------------------

; 20: URSUS
        monster_prop URSUS
        speed 34
        attack_power 15
        evade 110
        defense 165
        mag_def 140
        mag_pwr 10
        hp 2409
        mp 74
        exp 882
        gil 2000
        level 34
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, DMG_150_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH}
        immune_status2 {SILENCE, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 21: RHINOTAUR
        monster_prop RHINOTAUR
        speed 35
        attack_power 25
        defense 100
        mag_def 155
        mag_pwr 10
        hp 232
        mp 100
        exp 246
        gil 186
        level 8
        attack_anim DRAGON_CLAW
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        elem_absorb LIGHTNING
        immune_status1 PETRIFY
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 22: STEROIDITE
        monster_prop STEROIDITE
        speed 45
        attack_power 13
        defense 5
        mag_def 70
        mag_pwr 15
        hp 25000
        mp 350
        exp 4200
        gil 100
        level 54
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 8, 4
        monster_flags IMP_DMG_BONUS
        monster_status HARDER_TO_RUN
        elem_weak HOLY
        immune_status1 {BLIND, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 23: LEAFER
        monster_prop LEAFER
        speed 30
        attack_power 13
        defense 60
        mag_def 140
        mag_pwr 10
        hp 33
        mp 0
        exp 24
        gil 45
        level 5
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        elem_absorb ICE
        elem_weak {FIRE, WATER}
        end_monster_prop

; ------------------------------------------------------------------------------

; 24: STRAY_CAT
        monster_prop STRAY_CAT
        speed 30
        attack_power 9
        defense 10
        mag_def 135
        mag_pwr 10
        hp 156
        mp 30
        exp 42
        gil 90
        level 10
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_400_PCT
        metamorph 10, 4
        end_monster_prop

; ------------------------------------------------------------------------------

; 25: LOBO
        monster_prop LOBO
        speed 35
        attack_power 20
        defense 80
        mag_def 120
        mag_pwr 3
        hp 27
        mp 5
        exp 37
        gil 30
        level 5
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        monster_status CANT_ESCAPE
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 26: DOBERMAN
        monster_prop DOBERMAN
        speed 35
        attack_power 10
        defense 100
        mag_def 150
        mag_pwr 10
        hp 465
        mp 10
        gil 83
        level 12
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 27: VOMAMMOTH
        monster_prop VOMAMMOTH
        speed 25
        attack_power 110
        defense 75
        mag_def 160
        hp 115
        mp 30
        exp 50
        gil 90
        level 1
        attack_anim DRAGON_CLAW
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 2, 2
        monster_status CANT_ESCAPE
        elem_weak FIRE
        immune_status2 SLEEP
        end_monster_prop

; ------------------------------------------------------------------------------

; 28: FIDOR
        monster_prop FIDOR
        speed 35
        attack_power 25
        defense 55
        mag_def 170
        mag_pwr 10
        hp 355
        mp 80
        exp 160
        gil 180
        level 13
        attack_anim UNARMED
        special_attack HORZ_CLAW, DMG_200_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        monster_status CANT_ESCAPE
        elem_weak FIRE
        immune_status1 PETRIFY
        immune_status2 SLEEP
        end_monster_prop

; ------------------------------------------------------------------------------

; 29: BASKERVOR
        monster_prop BASKERVOR
        speed 35
        attack_power 17
        defense 110
        mag_def 120
        mag_pwr 10
        hp 750
        mp 100
        exp 465
        gil 458
        level 22
        attack_anim UNARMED
        special_attack DIAG_CLAW, DMG_150_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        immune_status1 {POISON, DEAD}
        immune_status2 CONDEMNED
        end_monster_prop

; ------------------------------------------------------------------------------

; 30: SURIANDER
        monster_prop SURIANDER
        speed 30
        attack_power 13
        defense 105
        mag_def 155
        mag_pwr 10
        hp 2912
        mp 228
        exp 1150
        gil 435
        level 40
        attack_anim UNARMED
        special_attack MUSIC_NOTE, SLEEP, NO_DMG
        metamorph 1, 3
        elem_weak HOLY
        immune_status1 {ZOMBIE, MAGITEK, VANISH, IMP, DEAD}
        immune_status2 {CONDEMNED, BERSERK, CONFUSE}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 31: CHIMERA
        monster_prop CHIMERA
        speed 45
        attack_power 25
        defense 100
        mag_def 110
        mag_pwr 10
        hp 2237
        mp 100
        exp 1144
        gil 760
        level 22
        attack_anim TRIDENT
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 20, 4
        immune_status1 ALL
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, SILENCE, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 32: BEHEMOTH
        monster_prop BEHEMOTH
        speed 50
        attack_power 25
        defense 100
        mag_def 135
        mag_pwr 7
        hp 5800
        mp 180
        exp 2055
        level 28
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_300_PCT
        metamorph 14, 4
        elem_weak ICE
        immune_status1 {BLIND, POISON, IMP}
        immune_status2 {CONDEMNED, SILENCE, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 33: MESOSAUR
        monster_prop MESOSAUR
        speed 30
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 10
        hp 1112
        mp 130
        exp 459
        gil 456
        level 26
        attack_anim UNARMED
        special_attack SMALL_PIERCE, SAP, NO_DMG
        metamorph 0, 0
        elem_weak ICE
        end_monster_prop

; ------------------------------------------------------------------------------

; 34: PTERODON
        monster_prop PTERODON
        speed 45
        attack_power 25
        defense 65
        mag_def 180
        mag_pwr 10
        hp 380
        mp 70
        exp 464
        gil 325
        level 12
        attack_anim DRAGON_CLAW
        special_attack BLUE_STAB_1, SAP, NO_DMG
        metamorph 0, 2
        monster_status CANT_SUPLEX
        elem_weak FIRE
        immune_status1 IMP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 35: FOSSILFANG
        monster_prop FOSSILFANG
        speed 35
        attack_power 25
        defense 100
        mag_def 165
        mag_pwr 3
        hp 1399
        mp 219
        exp 380
        gil 1870
        level 20
        attack_anim UNARMED
        special_attack BONE, ZOMBIE, NO_DMG
        metamorph 3, 2
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, ICE, HOLY, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 36: WHITE_DRGN
        monster_prop WHITE_DRGN
        speed 55
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 9
        hp 18500
        mp 12000
        level 71
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 24, 4
        monster_status {CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb HOLY
        immune_status1 {POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 37: DOOM_DRGN
        monster_prop DOOM_DRGN
        speed 48
        attack_power 13
        defense 110
        mag_def 90
        mag_pwr 13
        hp 18008
        mp 10000
        exp 8500
        gil 2700
        level 54
        attack_anim UNARMED
        special_attack BUBBLE, VANISH, NO_DMG
        metamorph 14, 4
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 38: BRACHOSAUR
        monster_prop BRACHOSAUR
        speed 95
        attack_power 55
        evade 70
        mblock 50
        defense 190
        mag_def 145
        mag_pwr 25
        hp 46050
        mp 51420
        exp 14396
        level 77
        attack_anim UNARMED
        special_attack HORZ_CLAW, DMG_600_PCT
        metamorph 2, 2
        elem_weak ICE
        immune_status1 {BLIND, ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 39: TYRANOSAUR
        monster_prop TYRANOSAUR
        speed 55
        attack_power 33
        defense 125
        mag_def 160
        mag_pwr 16
        hp 12770
        mp 420
        exp 8800
        level 57
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, DMG_700_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        monster_status HARDER_TO_RUN
        elem_weak ICE
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 40: DARK_WIND
        monster_prop DARK_WIND
        speed 30
        attack_power 13
        defense 55
        mag_def 140
        mag_pwr 10
        hp 34
        mp 0
        exp 28
        gil 41
        level 5
        attack_anim ICE_ROD
        special_attack THIN_DIAG_SLASH, DMG_150_PCT
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak FIRE
        immune_status1 IMP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 41: BEAKOR
        monster_prop BEAKOR
        speed 30
        attack_power 12
        defense 80
        mag_def 150
        mag_pwr 10
        hp 290
        mp 30
        exp 108
        gil 135
        level 11
        attack_anim ICE_ROD
        special_attack SMALL_PIERCE, POISON, NO_DMG
        metamorph 0, 0
        monster_flags IMP_DMG_BONUS
        elem_weak FIRE
        immune_status1 IMP
        end_monster_prop

; ------------------------------------------------------------------------------

; 42: VULTURE
        monster_prop VULTURE
        speed 30
        attack_power 13
        defense 100
        mag_def 155
        mag_pwr 10
        hp 412
        mp 60
        exp 160
        gil 485
        level 15
        attack_anim ICE_ROD
        special_attack SMALL_PIERCE, BLIND, NO_DMG
        metamorph 1, 2
        monster_status CANT_SUPLEX
        elem_weak WIND
        immune_status1 IMP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 43: HARPY
        monster_prop HARPY
        speed 35
        attack_power 13
        defense 115
        mag_def 145
        mag_pwr 10
        hp 3615
        mp 233
        exp 1994
        gil 1221
        level 42
        attack_anim ICE_ROD
        special_attack HORZ_CLAW, DMG_200_PCT
        metamorph 18, 4
        monster_status CANT_SUPLEX
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 44: HERMITCRAB
        monster_prop HERMITCRAB
        speed 10
        attack_power 5
        defense 150
        mag_def 80
        mag_pwr 5
        hp 305
        mp 35
        exp 267
        gil 400
        level 26
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, PETRIFY, NO_DMG
        metamorph 0, 0
        elem_weak WATER
        immune_status1 {BLIND, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE, SLEEP}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 45: TRAPPER
        monster_prop TRAPPER
        speed 35
        attack_power 13
        defense 180
        mag_def 135
        mag_pwr 10
        hp 555
        mp 80
        exp 235
        gil 200
        level 19
        attack_anim UNARMED
        special_attack MULTI_PUNCH, REFLECT, NO_DMG
        metamorph 4, 2
        monster_status CANT_SUPLEX
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 46: HORNET
        monster_prop HORNET
        speed 30
        attack_power 16
        defense 100
        mag_def 150
        mag_pwr 10
        hp 92
        mp 0
        exp 48
        gil 64
        level 6
        attack_anim ICE_ROD
        special_attack STING, DMG_150_PCT
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak FIRE
        immune_status1 IMP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 47: CRASSHOPPR
        monster_prop CRASSHOPPR
        speed 30
        attack_power 10
        defense 50
        mag_def 155
        mag_pwr 10
        hp 243
        mp 80
        exp 89
        gil 145
        level 11
        attack_anim UNARMED
        special_attack MUSIC_NOTE, BERSERK, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak {FIRE, WIND}
        immune_status1 IMP
        immune_status2 SLEEP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 48: DELTA_BUG
        monster_prop DELTA_BUG
        speed 30
        attack_power 11
        defense 220
        mag_def 5
        mag_pwr 10
        hp 612
        mp 80
        exp 288
        gil 211
        level 26
        attack_anim ICE_ROD
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 0, 2
        elem_weak FIRE
        immune_status1 {BLIND, POISON, IMP}
        immune_status2 {BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 49: GILOMANTIS
        monster_prop GILOMANTIS
        speed 35
        attack_power 16
        defense 115
        mag_def 140
        mag_pwr 10
        hp 1412
        mp 110
        exp 559
        gil 756
        level 26
        attack_anim RUNE_EDGE
        special_attack THICK_DIAG_SLASH, DMG_150_PCT
        metamorph 1, 3
        elem_weak FIRE
        immune_status1 {IMP, DEAD}
        immune_status2 {CONDEMNED, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 50: TRILIUM
        monster_prop TRILIUM
        speed 30
        attack_power 13
        defense 102
        mag_def 170
        mag_pwr 10
        hp 147
        mp 100
        exp 97
        gil 134
        level 9
        attack_anim MAGICAL_BRSH
        special_attack SMALL_PIERCE, POISON, NO_DMG
        metamorph 3, 2
        monster_status CANT_SUPLEX
        elem_absorb WATER
        elem_weak FIRE
        immune_status1 IMP
        end_monster_prop

; ------------------------------------------------------------------------------

; 51: NIGHTSHADE
        monster_prop NIGHTSHADE
        speed 35
        attack_power 13
        defense 110
        mag_def 140
        mag_pwr 9
        hp 2200
        mp 305
        exp 872
        gil 767
        level 37
        attack_anim UNARMED
        special_attack BUBBLE, POISON, NO_DMG
        metamorph 3, 3
        elem_absorb WATER
        elem_weak FIRE
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 52: TUMBLEWEED
        monster_prop TUMBLEWEED
        speed 30
        attack_power 10
        defense 120
        mag_def 90
        mag_pwr 10
        hp 6200
        mp 600
        exp 2554
        gil 1333
        level 55
        attack_anim UNARMED
        special_attack SMALL_PIERCE, BLIND, NO_DMG
        metamorph 3, 3
        elem_absorb WATER
        elem_weak FIRE
        immune_status1 {BLIND, POISON, IMP}
        immune_status2 {SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 53: BLOOMPIRE
        monster_prop BLOOMPIRE
        speed 35
        attack_power 13
        defense 254
        mag_def 254
        mag_pwr 10
        hp 12
        mp 400
        exp 510
        gil 896
        level 26
        attack_anim MAGICAL_BRSH
        special_attack BLOB_MAN, ZOMBIE, NO_DMG
        metamorph 3, 3
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb WATER
        elem_weak FIRE
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 54: TRILOBITER
        monster_prop TRILOBITER
        speed 30
        attack_power 11
        defense 90
        mag_def 150
        mag_pwr 10
        hp 150
        mp 20
        exp 105
        gil 135
        level 12
        attack_anim UNARMED
        special_attack STING, POISON, NO_DMG
        metamorph 0, 0
        immune_status1 IMP
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 55: SIEGFRIED_1
        monster_prop SIEGFRIED_1
        speed 90
        attack_power 53
        evade 25
        mblock 25
        defense 160
        mag_def 150
        mag_pwr 25
        hp 32760
        mp 6000
        level 53
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_500_PCT
        metamorph 23, 4
        monster_flags {HUMAN, IMP_DMG_BONUS}
        elem_weak {FIRE, ICE, LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        immune_status1 {PETRIFY, DEAD}
        immune_status2 CONDEMNED
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 56: NAUTILOID
        monster_prop NAUTILOID
        speed 35
        attack_power 18
        defense 100
        mag_def 150
        mag_pwr 10
        hp 236
        mp 100
        exp 216
        gil 173
        level 11
        attack_anim MAGICAL_BRSH
        special_attack BLACK_CLOUD, BLIND, NO_DMG
        metamorph 0, 0
        elem_absorb WATER
        elem_weak {FIRE, LIGHTNING}
        immune_status1 IMP
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 57: EXOCITE
        monster_prop EXOCITE
        speed 30
        attack_power 19
        defense 100
        mag_def 150
        mag_pwr 10
        hp 196
        mp 100
        exp 162
        gil 153
        level 11
        attack_anim HARDENED
        special_attack THICK_HORZ_SLASH, DMG_150_PCT
        metamorph 0, 0
        elem_absorb WATER
        elem_weak {FIRE, LIGHTNING}
        immune_status1 {BLIND, IMP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 58: ANGUIFORM
        monster_prop ANGUIFORM
        speed 25
        attack_power 14
        defense 80
        mag_def 150
        mag_pwr 6
        hp 315
        mp 150
        exp 96
        gil 358
        level 13
        attack_anim UNARMED
        special_attack HORZ_CLAW, DMG_500_PCT
        metamorph 1, 2
        monster_status HARDER_TO_RUN
        elem_absorb WATER
        elem_weak LIGHTNING
        immune_status1 IMP
        apply_status1 BLIND
        end_monster_prop

; ------------------------------------------------------------------------------

; 59: REACH_FROG
        monster_prop REACH_FROG
        speed 35
        attack_power 13
        defense 130
        mag_def 145
        mag_pwr 7
        hp 3511
        mp 220
        exp 1550
        gil 2600
        level 52
        attack_anim UNARMED
        special_attack BLUE_STAB_2, SAP, NO_DMG
        metamorph 0, 2
        elem_weak ICE
        immune_status1 POISON
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 60: LIZARD
        monster_prop LIZARD
        speed 30
        attack_power 14
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1280
        mp 70
        exp 297
        gil 356
        level 26
        attack_anim UNARMED
        special_attack THICK_HORZ_SLASH, IMP, NO_DMG
        metamorph 0, 2
        elem_absorb POISON
        elem_weak ICE
        immune_status1 PETRIFY
        immune_status2 {NEAR_FATAL, SILENCE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 61: CHICKENLIP
        monster_prop CHICKENLIP
        speed 30
        attack_power 11
        defense 150
        mag_def 150
        mag_pwr 3
        hp 545
        mp 155
        exp 190
        gil 279
        level 18
        attack_anim ICE_ROD
        special_attack LARGE_PIERCE, SILENCE, NO_DMG
        metamorph 0, 0
        elem_weak ICE
        immune_status1 {POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 62: HOOVER
        monster_prop HOOVER
        speed 54
        attack_power 54
        hit_rate 180
        evade 30
        defense 130
        mag_def 60
        mag_pwr 22
        hp 12018
        mp 10500
        exp 7524
        gil 10000
        level 49
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_500_PCT
        metamorph 14, 4
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        elem_weak {ICE, WATER}
        immune_status1 {IMP, PETRIFY}
        immune_status2 SLEEP
        end_monster_prop

; ------------------------------------------------------------------------------

; 63: RIDER
        monster_prop RIDER
        speed 45
        attack_power 48
        defense 120
        mag_def 150
        mag_pwr 10
        hp 1300
        mp 170
        exp 400
        gil 1290
        level 14
        attack_anim TRIDENT
        special_attack RED_STAB, DMG_300_PCT
        metamorph 5, 3
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_weak {FIRE, POISON}
        immune_status1 {ZOMBIE, IMP}
        immune_status2 CONFUSE
        end_monster_prop

; ------------------------------------------------------------------------------

; 64: CHUPON_COLOSSEUM
        monster_prop CHUPON_COLOSSEUM
        speed 99
        attack_power 13
        defense 190
        mag_def 190
        mag_pwr 10
        hp 50305
        mp 55530
        level 53
        attack_anim DRAGON_CLAW
        special_attack BLOB_MAN, POISON, NO_DMG
        metamorph 24, 4
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, CONFUSE, SAP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 65: PIPSQUEAK
        monster_prop PIPSQUEAK
        speed 25
        attack_power 13
        defense 200
        mag_def 150
        mag_pwr 10
        hp 250
        mp 50
        exp 115
        gil 100
        level 18
        attack_anim DIRK
        special_attack MULTI_PUNCH, IMP, NO_DMG
        metamorph 4, 3
        monster_flags HUMAN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 66: M_TEKARMOR
        monster_prop M_TEKARMOR
        speed 25
        attack_power 18
        defense 30
        mag_def 130
        mag_pwr 3
        hp 210
        mp 250
        level 8
        attack_anim UNARMED
        special_attack ARC_SLASH, DMG_150_PCT
        metamorph 4, 3
        monster_status {CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak LIGHTNING
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SAP}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 67: SKY_ARMOR
        monster_prop SKY_ARMOR
        speed 30
        attack_power 16
        defense 150
        mag_def 120
        mag_pwr 7
        hp 900
        mp 170
        exp 350
        gil 400
        level 24
        attack_anim FORGED
        special_attack DIAG_CLAW, SILENCE, NO_DMG
        metamorph 4, 4
        monster_status {CANT_SUPLEX, CANT_ESCAPE}
        elem_weak {LIGHTNING, WIND}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 68: TELSTAR
        monster_prop TELSTAR
        speed 35
        attack_power 20
        defense 120
        mag_def 150
        mag_pwr 13
        hp 1800
        mp 250
        level 14
        attack_anim DRAGON_CLAW
        special_attack MUSIC_NOTE, CONFUSE, NO_DMG
        metamorph 4, 4
        monster_status {CANT_SUPLEX, CANT_ESCAPE, CANT_CONTROL}
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 69: LETHAL_WPN
        monster_prop LETHAL_WPN
        speed 55
        attack_power 18
        evade 10
        mblock 10
        defense 190
        mag_def 125
        mag_pwr 15
        hp 9200
        mp 1956
        exp 5848
        gil 1189
        level 47
        attack_anim UNARMED
        special_attack AIR_ANCHOR, DMG_200_PCT
        metamorph 5, 4
        elem_weak {LIGHTNING, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 70: VAPORITE
        monster_prop VAPORITE
        speed 30
        attack_power 13
        defense 95
        mag_def 150
        mag_pwr 10
        hp 15
        mp 0
        exp 23
        gil 29
        level 5
        attack_anim UNARMED
        special_attack FLOWER, SLOW, NO_DMG
        metamorph 0, 0
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb LIGHTNING
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 71: FLAN
        monster_prop FLAN
        speed 30
        attack_power 13
        defense 13
        mag_def 100
        mag_pwr 10
        hp 255
        mp 110
        exp 160
        gil 120
        level 19
        attack_anim UNARMED
        special_attack BLOB_MAN, SAP, NO_DMG
        metamorph 0, 0
        elem_null {POISON, WIND, HOLY, EARTH, WATER}
        elem_weak FIRE
        immune_status1 {BLIND, POISON, IMP, PETRIFY}
        end_monster_prop

; ------------------------------------------------------------------------------

; 72: ING
        monster_prop ING
        speed 35
        attack_power 18
        defense 110
        mag_def 150
        mag_pwr 12
        hp 1100
        mp 50
        exp 740
        gil 442
        level 21
        attack_anim UNARMED
        special_attack THICK_HORZ_SLASH, BLIND, NO_DMG
        metamorph 3, 2
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb {FIRE, POISON}
        elem_weak {HOLY, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 73: HUMPTY
        monster_prop HUMPTY
        speed 30
        attack_power 8
        defense 145
        mag_def 135
        mag_pwr 10
        hp 800
        mp 100
        exp 421
        gil 326
        level 27
        attack_anim UNARMED
        special_attack FLOWER, CONFUSE, NO_DMG
        metamorph 0, 3
        monster_flags {DIE_AT_0_MP, IMP_DMG_BONUS, UNDEAD}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 74: BRAINPAN
        monster_prop BRAINPAN
        speed 35
        attack_power 24
        defense 120
        mag_def 110
        mag_pwr 10
        hp 1300
        mp 1000
        exp 550
        gil 600
        level 25
        attack_anim UNARMED
        special_attack HEART, STOP, NO_DMG
        metamorph 1, 2
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, LIGHTNING, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 75: CRULLER
        monster_prop CRULLER
        speed 30
        attack_power 11
        evade 100
        defense 110
        mag_def 70
        mag_pwr 4
        hp 1334
        mp 100
        exp 419
        gil 797
        level 28
        attack_anim UNARMED
        special_attack LIGHTNING, CONFUSE, NO_DMG
        metamorph 14, 4
        monster_flags {DIE_AT_0_MP, UNDEAD}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status1 {BLIND, POISON}
        end_monster_prop

; ------------------------------------------------------------------------------

; 76: CACTROT
        monster_prop CACTROT
        speed 39
        attack_power 1
        evade 250
        mblock 250
        defense 255
        mag_def 255
        mag_pwr 50
        hp 3
        mp 60000
        gil 10000
        level 27
        attack_anim ICE_ROD
        special_attack STING, BERSERK, NO_DMG
        metamorph 7, 4
        elem_weak {ICE, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY}
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 77: REPO_MAN
        monster_prop REPO_MAN
        speed 35
        attack_power 19
        defense 90
        mag_def 120
        mag_pwr 10
        hp 35
        mp 0
        exp 25
        gil 25
        level 5
        attack_anim UNARMED
        special_attack WRENCH, DMG_150_PCT
        metamorph 0, 0
        monster_flags HUMAN
        elem_weak POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 78: HARVESTER
        monster_prop HARVESTER
        speed 50
        attack_power 13
        defense 105
        mag_def 150
        mag_pwr 10
        hp 428
        mp 85
        exp 291
        gil 314
        level 16
        attack_anim RUNE_EDGE
        special_attack THIN_DIAG_SLASH, DMG_150_PCT
        metamorph 0, 2
        monster_flags HUMAN
        elem_weak POISON
        immune_status1 IMP
        immune_status3 {SLOW, STOP}
        apply_status3 {FLYING, HASTE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 79: BOMB
        monster_prop BOMB
        speed 30
        attack_power 10
        defense 90
        mag_def 150
        mag_pwr 1
        hp 160
        mp 50
        exp 35
        gil 80
        level 8
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 20, 4
        monster_status CANT_SUPLEX
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 80: STILL_LIFE
        monster_prop STILL_LIFE
        speed 45
        attack_power 13
        defense 150
        mag_def 150
        mag_pwr 10
        hp 4889
        mp 390
        exp 2331
        gil 1574
        level 37
        attack_anim UNARMED
        special_attack HEART, POISON, NO_DMG
        metamorph 14, 4
        monster_flags DIE_AT_0_MP
        monster_status {CANT_SUPLEX, CANT_ESCAPE}
        elem_weak FIRE
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 81: BOXED_SET
        monster_prop BOXED_SET
        speed 30
        attack_power 13
        defense 90
        mag_def 250
        mag_pwr 7
        hp 4020
        mp 105
        exp 1504
        gil 465
        level 45
        attack_anim UNARMED
        special_attack LIGHTNING, DMG_300_PCT
        metamorph 17, 4
        monster_flags DIE_AT_0_MP
        monster_status CANT_SUPLEX
        elem_weak HOLY
        immune_status1 {POISON, IMP}
        immune_status2 NEAR_FATAL
        apply_status3 {FLYING, REFLECT}
        end_monster_prop

; ------------------------------------------------------------------------------

; 82: SLAMDANCER
        monster_prop SLAMDANCER
        speed 35
        attack_power 13
        defense 115
        mag_def 145
        mag_pwr 10
        hp 392
        mp 120
        exp 224
        gil 296
        level 15
        attack_anim DIRK
        special_attack HORZ_CLAW, SLEEP, NO_DMG
        metamorph 9, 4
        monster_flags HUMAN
        elem_weak POISON
        immune_status1 {POISON, IMP}
        immune_status2 {BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 83: HADESGIGAS
        monster_prop HADESGIGAS
        speed 40
        attack_power 18
        defense 125
        mag_def 115
        mag_pwr 5
        hp 1200
        mp 60
        exp 550
        gil 600
        level 16
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_400_PCT
        metamorph 8, 4
        monster_flags {HUMAN, IMP_DMG_BONUS}
        elem_absorb EARTH
        elem_weak POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 84: PUG
        monster_prop PUG
        speed 35
        attack_power 13
        evade 50
        mblock 50
        defense 150
        mag_def 180
        mag_pwr 10
        hp 8000
        mp 15500
        exp 1200
        gil 3333
        level 27
        attack_anim FORGED
        special_attack VERT_SLASH, DMG_800_PCT
        metamorph 7, 4
        monster_flags IMP_DMG_BONUS
        elem_absorb WATER
        elem_weak {FIRE, LIGHTNING}
        immune_status1 DEAD
        immune_status2 {CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 85: MAGIC_URN
        monster_prop MAGIC_URN
        speed 40
        attack_power 5
        evade 100
        defense 220
        mag_def 190
        mag_pwr 35
        hp 100
        mp 10000
        level 31
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 11, 5
        monster_flags DIE_AT_0_MP
        elem_absorb {FIRE, ICE, LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 86: MOVER
        monster_prop MOVER
        speed 85
        attack_power 20
        evade 225
        defense 115
        mag_def 254
        mag_pwr 10
        hp 120
        mp 10500
        exp 1500
        level 51
        attack_anim UNARMED
        special_attack SMALL_PIERCE, SILENCE, NO_DMG
        metamorph 3, 3
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        elem_absorb POISON
        immune_status1 {IMP, PETRIFY}
        immune_status2 ALL
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 87: FIGALIZ
        monster_prop FIGALIZ
        speed 30
        attack_power 29
        defense 90
        mag_def 250
        mag_pwr 10
        hp 4220
        mp 140
        exp 1219
        gil 554
        level 45
        attack_anim TRIDENT
        special_attack FLOWER, POISON, NO_DMG
        metamorph 0, 2
        monster_flags IMP_DMG_BONUS
        elem_weak ICE
        immune_status1 POISON
        immune_status2 SLEEP
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 88: BUFFALAX
        monster_prop BUFFALAX
        speed 30
        attack_power 15
        defense 100
        mag_def 150
        mag_pwr 10
        hp 2252
        mp 218
        exp 562
        gil 458
        level 26
        attack_anim ICE_ROD
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 1, 3
        monster_flags IMP_DMG_BONUS
        elem_weak {FIRE, WATER}
        immune_status1 PETRIFY
        immune_status2 {NEAR_FATAL, SLEEP}
        apply_status1 POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 89: ASPIK
        monster_prop ASPIK
        speed 40
        attack_power 2
        defense 100
        mag_def 150
        mag_pwr 2
        hp 220
        mp 330
        exp 48
        gil 115
        level 12
        attack_anim UNARMED
        special_attack STING, STOP, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_absorb WATER
        elem_weak FIRE
        immune_status1 {BLIND, IMP}
        immune_status2 {SILENCE, CONFUSE, SLEEP}
        apply_status1 BLIND
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 90: GHOST
        monster_prop GHOST
        speed 30
        attack_power 1
        defense 105
        mag_def 150
        mag_pwr 1
        hp 226
        mp 70
        exp 48
        gil 75
        level 10
        attack_anim ICE_ROD
        special_attack HAMMER, STOP, NO_DMG
        metamorph 0, 2
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 91: CRAWLER
        monster_prop CRAWLER
        speed 40
        attack_power 13
        defense 115
        mag_def 150
        mag_pwr 8
        hp 3200
        mp 620
        exp 1456
        gil 1224
        level 51
        attack_anim UNARMED
        special_attack BLUE_STAB_2, POISON, NO_DMG
        metamorph 0, 2
        monster_status HARDER_TO_RUN
        elem_weak ICE
        immune_status1 POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 92: SAND_RAY
        monster_prop SAND_RAY
        speed 30
        attack_power 20
        defense 110
        mag_def 145
        mag_pwr 10
        hp 67
        mp 10
        exp 41
        gil 54
        level 6
        attack_anim UNARMED
        special_attack ARC_SLASH, DMG_150_PCT
        metamorph 0, 0
        elem_weak {ICE, WATER}
        end_monster_prop

; ------------------------------------------------------------------------------

; 93: ARENEID
        monster_prop ARENEID
        speed 30
        attack_power 20
        defense 80
        mag_def 135
        mag_pwr 10
        hp 87
        mp 15
        exp 37
        gil 94
        level 6
        attack_anim ICE_ROD
        special_attack STING, STOP, NO_DMG
        metamorph 0, 0
        elem_weak {ICE, WATER}
        end_monster_prop

; ------------------------------------------------------------------------------

; 94: ACTANEON
        monster_prop ACTANEON
        speed 35
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 230
        mp 98
        exp 57
        gil 125
        level 12
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 0, 0
        elem_absorb WATER
        elem_weak {FIRE, LIGHTNING}
        immune_status1 {ZOMBIE, IMP}
        immune_status2 {SILENCE, BERSERK, CONFUSE, SLEEP}
        apply_status1 BLIND
        end_monster_prop

; ------------------------------------------------------------------------------

; 95: SAND_HORSE
        monster_prop SAND_HORSE
        speed 30
        attack_power 15
        defense 135
        mag_def 155
        mag_pwr 9
        hp 1025
        mp 100
        exp 475
        gil 726
        level 27
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_500_PCT
        metamorph 1, 3
        monster_flags DIE_AT_0_MP
        elem_weak {ICE, WATER}
        immune_status1 {BLIND, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 96: DARK_SIDE
        monster_prop DARK_SIDE
        speed 30
        attack_power 10
        defense 100
        mag_def 150
        mag_pwr 8
        hp 255
        mp 85
        exp 165
        gil 138
        level 13
        attack_anim UNARMED
        special_attack SMALL_PIERCE, SAP, NO_DMG
        metamorph 0, 2
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 97: MAD_OSCAR
        monster_prop MAD_OSCAR
        speed 30
        attack_power 20
        hit_rate 80
        defense 95
        mag_def 145
        mag_pwr 10
        hp 2900
        mp 980
        exp 780
        gil 2292
        level 30
        attack_anim UNARMED
        special_attack BLOB_MAN, SAP, NO_DMG
        metamorph 3, 2
        elem_absorb {POISON, WATER}
        elem_weak FIRE
        immune_status1 IMP
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 98: CRAWLY
        monster_prop CRAWLY
        speed 30
        attack_power 13
        defense 45
        mag_def 155
        mag_pwr 10
        hp 122
        mp 0
        exp 71
        gil 120
        level 7
        attack_anim UNARMED
        special_attack BLOB_MAN, SAP, NO_DMG
        metamorph 0, 2
        monster_status CANT_SUPLEX
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 99: BLEARY
        monster_prop BLEARY
        speed 30
        attack_power 13
        defense 100
        mag_def 155
        mag_pwr 10
        hp 119
        mp 10
        exp 53
        gil 80
        level 7
        attack_anim UNARMED
        special_attack MUSIC_NOTE, SLEEP, NO_DMG
        metamorph 0, 2
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 100: MARSHAL
        monster_prop MARSHAL
        speed 40
        attack_power 60
        defense 110
        mag_def 140
        mag_pwr 9
        hp 420
        mp 150
        gil 350
        level 8
        attack_anim DIRK
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {FIRST_STRIKE, CANT_ESCAPE}
        elem_weak POISON
        immune_status1 POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 101: TROOPER
        monster_prop TROOPER
        speed 25
        attack_power 15
        defense 100
        mag_def 125
        mag_pwr 10
        hp 255
        mp 60
        exp 90
        gil 96
        level 13
        attack_anim RUNE_EDGE
        special_attack BLUE_STAB_2, DMG_200_PCT
        metamorph 0, 0
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_weak POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 102: GENERAL
        monster_prop GENERAL
        speed 30
        attack_power 13
        defense 155
        mag_def 105
        mag_pwr 10
        hp 650
        mp 30
        exp 232
        gil 308
        level 19
        attack_anim FORGED
        special_attack SMALL_PIERCE, SAP, NO_DMG
        metamorph 1, 2
        monster_flags {HUMAN, IMP_DMG_BONUS}
        elem_weak POISON
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 103: COVERT
        monster_prop COVERT
        speed 35
        attack_power 25
        evade 50
        defense 100
        mag_def 150
        mag_pwr 11
        hp 4530
        mp 240
        exp 1757
        gil 1768
        level 44
        attack_anim FORGED
        special_attack LIGHT_BEAM, VANISH, NO_DMG
        metamorph 25, 4
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status CANT_ESCAPE
        elem_absorb POISON
        elem_weak HOLY
        immune_status1 {PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 104: OGOR
        monster_prop OGOR
        speed 32
        attack_power 19
        evade 30
        mblock 30
        defense 100
        mag_def 150
        mag_pwr 11
        hp 4211
        mp 219
        exp 1583
        gil 869
        level 44
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, ZOMBIE, NO_DMG
        metamorph 1, 4
        monster_flags HUMAN
        elem_weak {LIGHTNING, POISON}
        immune_status1 {PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 105: WARLOCK
        monster_prop WARLOCK
        speed 39
        attack_power 10
        defense 180
        mag_def 225
        mag_pwr 10
        hp 1300
        mp 1250
        exp 970
        gil 333
        level 38
        attack_anim ICE_ROD
        special_attack FLOWER, DRAIN_MP
        metamorph 0, 2
        monster_flags {DIE_AT_0_MP, HUMAN}
        elem_weak {LIGHTNING, POISON}
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 106: MADAM
        monster_prop MADAM
        speed 35
        attack_power 8
        defense 100
        mag_def 155
        mag_pwr 12
        hp 8150
        mp 900
        exp 2200
        gil 700
        level 53
        attack_anim HARDENED
        special_attack SMALL_PIERCE, BLIND, NO_DMG
        metamorph 19, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status HARDER_TO_RUN
        elem_weak POISON
        immune_status1 {BLIND, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 107: JOKER
        monster_prop JOKER
        speed 35
        attack_power 13
        defense 125
        mag_def 150
        mag_pwr 10
        hp 467
        mp 90
        exp 194
        gil 320
        level 17
        attack_anim UNARMED
        special_attack THICK_HORZ_SLASH, DMG_200_PCT
        metamorph 0, 0
        monster_flags HUMAN
        monster_status CANT_SUPLEX
        elem_weak {LIGHTNING, POISON}
        immune_status1 IMP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 108: IRON_FIST
        monster_prop IRON_FIST
        speed 35
        attack_power 13
        defense 75
        mag_def 145
        mag_pwr 10
        hp 333
        mp 65
        exp 144
        gil 249
        level 15
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 0, 0
        monster_flags {HUMAN, IMP_DMG_BONUS}
        elem_absorb POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 109: GOBLIN
        monster_prop GOBLIN
        speed 30
        attack_power 18
        defense 70
        mag_def 250
        mag_pwr 7
        hp 5555
        mp 1150
        exp 2189
        gil 960
        level 46
        attack_anim ICE_ROD
        special_attack SINGLE_PUNCH, DMG_400_PCT
        metamorph 14, 4
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        elem_weak HOLY
        immune_status1 IMP
        immune_status2 {CONDEMNED, SILENCE, BERSERK, SLEEP}
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 110: APPARITE
        monster_prop APPARITE
        speed 35
        attack_power 17
        defense 110
        mag_def 150
        mag_pwr 10
        hp 781
        mp 60
        exp 415
        gil 300
        level 20
        attack_anim UNARMED
        special_attack SMALL_PIERCE, SAP, NO_DMG
        metamorph 0, 0
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb {FIRE, POISON}
        elem_weak {ICE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 111: POWERDEMON
        monster_prop POWERDEMON
        speed 40
        attack_power 13
        defense 145
        mag_def 140
        mag_pwr 10
        hp 2058
        mp 360
        exp 485
        gil 385
        level 29
        attack_anim ICE_ROD
        special_attack HORZ_CLAW, DRAIN_HP
        metamorph 3, 3
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status HARDER_TO_RUN
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 112: DISPLAYER
        monster_prop DISPLAYER
        speed 44
        attack_power 13
        evade 30
        defense 150
        mag_def 135
        mag_pwr 10
        hp 3826
        mp 1327
        exp 1510
        gil 393
        level 38
        attack_anim DRAGON_CLAW
        special_attack BONE, DMG_200_PCT
        metamorph 3, 3
        monster_flags {DIE_AT_0_MP, UNDEAD}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 113: VECTOR_PUP
        monster_prop VECTOR_PUP
        speed 25
        attack_power 14
        defense 80
        mag_def 150
        mag_pwr 10
        hp 166
        mp 10
        exp 128
        gil 83
        level 11
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        elem_weak FIRE
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 114: PEEPERS
        monster_prop PEEPERS
        speed 35
        attack_power 7
        defense 5
        mag_def 5
        mag_pwr 10
        hp 1
        mp 19
        exp 2
        level 23
        attack_anim UNARMED
        special_attack ARC_SLASH, DMG_150_PCT
        metamorph 2, 0
        monster_status CANT_SUPLEX
        elem_weak {ICE, WATER}
        immune_status1 POISON
        apply_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 115: SEWER_RAT
        monster_prop SEWER_RAT
        speed 30
        attack_power 13
        defense 110
        mag_def 160
        mag_pwr 10
        hp 299
        mp 20
        exp 108
        gil 156
        level 16
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        monster_status CANT_ESCAPE
        elem_absorb POISON
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 116: SLATTER
        monster_prop SLATTER
        speed 35
        attack_power 13
        evade 20
        mblock 10
        defense 125
        mag_def 145
        mag_pwr 10
        hp 2600
        mp 97
        exp 830
        gil 415
        level 37
        attack_anim DRAGON_CLAW
        special_attack ARC_SLASH, DMG_150_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        elem_weak HOLY
        immune_status1 {PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 117: RHINOX
        monster_prop RHINOX
        speed 30
        attack_power 13
        defense 200
        mag_def 100
        mag_pwr 10
        hp 800
        mp 35
        exp 592
        gil 400
        level 19
        attack_anim UNARMED
        special_attack SMALL_PIERCE, POISON, NO_DMG
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        elem_absorb LIGHTNING
        immune_status1 {PETRIFY, DEAD}
        immune_status2 CONDEMNED
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 118: RHOBITE
        monster_prop RHOBITE
        speed 30
        attack_power 9
        defense 70
        mag_def 140
        mag_pwr 10
        hp 135
        mp 40
        exp 53
        gil 110
        level 10
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        elem_weak WATER
        end_monster_prop

; ------------------------------------------------------------------------------

; 119: WILD_CAT
        monster_prop WILD_CAT
        speed 30
        attack_power 17
        evade 10
        defense 100
        mag_def 140
        mag_pwr 10
        hp 1115
        mp 78
        exp 701
        gil 416
        level 36
        attack_anim DRAGON_CLAW
        special_attack HORZ_CLAW, DMG_150_PCT
        metamorph 10, 4
        elem_weak {FIRE, WATER}
        immune_status2 SILENCE
        end_monster_prop

; ------------------------------------------------------------------------------

; 120: RED_FANG
        monster_prop RED_FANG
        speed 30
        attack_power 13
        defense 95
        mag_def 150
        mag_pwr 10
        hp 325
        mp 20
        exp 135
        gil 185
        level 14
        attack_anim DRAGON_CLAW
        special_attack BUBBLE, POISON, NO_DMG
        metamorph 2, 0
        end_monster_prop

; ------------------------------------------------------------------------------

; 121: BOUNTY_MAN
        monster_prop BOUNTY_MAN
        speed 32
        attack_power 16
        defense 75
        mag_def 140
        mag_pwr 10
        hp 285
        mp 50
        exp 115
        gil 55
        level 13
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 2, 0
        monster_status CANT_ESCAPE
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 122: TUSKER
        monster_prop TUSKER
        speed 30
        attack_power 28
        defense 100
        mag_def 135
        mag_pwr 10
        hp 270
        mp 100
        exp 163
        gil 102
        level 10
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 123: RALPH
        monster_prop RALPH
        speed 35
        attack_power 14
        defense 135
        mag_def 145
        mag_pwr 10
        hp 620
        mp 10
        exp 255
        gil 345
        level 17
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        immune_status1 PETRIFY
        end_monster_prop

; ------------------------------------------------------------------------------

; 124: CHITONID
        monster_prop CHITONID
        speed 25
        attack_power 13
        defense 140
        mag_def 80
        mag_pwr 10
        hp 1111
        mp 60
        exp 321
        gil 356
        level 26
        attack_anim DRAGON_CLAW
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        elem_weak LIGHTNING
        immune_status1 {PETRIFY, DEAD}
        immune_status2 SILENCE
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 125: WART_PUCK
        monster_prop WART_PUCK
        speed 35
        attack_power 15
        defense 120
        mag_def 160
        mag_pwr 11
        hp 3559
        mp 330
        exp 1595
        gil 1169
        level 44
        attack_anim UNARMED
        special_attack MUSIC_NOTE, SLEEP, NO_DMG
        metamorph 1, 3
        elem_weak FIRE
        immune_status1 {POISON, IMP, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 126: RHYOS
        monster_prop RHYOS
        speed 60
        attack_power 40
        defense 150
        mag_def 160
        mag_pwr 15
        hp 7191
        mp 354
        exp 4928
        gil 1889
        level 36
        attack_anim TRIDENT
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 21, 4
        monster_status CANT_ESCAPE
        immune_status1 {BLIND, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 127: SRBEHEMOTH_UNDEAD
        monster_prop SRBEHEMOTH_UNDEAD
        speed 39
        attack_power 27
        defense 105
        mag_def 150
        mag_pwr 10
        hp 19000
        mp 9999
        level 49
        attack_anim UNARMED
        special_attack BLACK_CLOUD, SLEEP, NO_DMG
        metamorph 23, 4
        monster_flags UNDEAD
        monster_status {CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {POISON, IMP, PETRIFY}
        immune_status2 {IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 128: VECTAUR
        monster_prop VECTAUR
        speed 30
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 7
        hp 2800
        mp 180
        exp 1400
        gil 350
        level 59
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 0, 3
        monster_status HARDER_TO_RUN
        elem_weak {ICE, WATER}
        immune_status1 {BLIND, POISON, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 129: WYVERN
        monster_prop WYVERN
        speed 30
        attack_power 15
        defense 140
        mag_def 155
        mag_pwr 10
        hp 892
        mp 95
        exp 484
        gil 434
        level 18
        attack_anim DRAGON_CLAW
        special_attack HORZ_CLAW, SAP, NO_DMG
        metamorph 0, 2
        monster_status CANT_SUPLEX
        elem_weak ICE
        immune_status1 IMP
        end_monster_prop

; ------------------------------------------------------------------------------

; 130: ZOMBONE
        monster_prop ZOMBONE
        speed 40
        attack_power 29
        defense 150
        mag_def 100
        mag_pwr 10
        hp 1991
        mp 160
        exp 1072
        gil 309
        level 21
        attack_anim UNARMED
        special_attack BONE, ZOMBIE, NO_DMG
        metamorph 3, 3
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 131: DRAGON
        monster_prop DRAGON
        speed 55
        attack_power 45
        evade 40
        defense 130
        mag_def 110
        mag_pwr 10
        hp 7000
        mp 850
        exp 2931
        level 29
        attack_anim UNARMED
        special_attack ARC_SLASH, DMG_500_PCT
        metamorph 14, 4
        monster_status HARDER_TO_RUN
        elem_weak LIGHTNING
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 132: BRONTAUR
        monster_prop BRONTAUR
        speed 35
        attack_power 15
        defense 130
        mag_def 110
        mag_pwr 12
        hp 10050
        mp 12850
        exp 3000
        gil 1200
        level 50
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_500_PCT
        metamorph 2, 0
        monster_status HARDER_TO_RUN
        elem_weak ICE
        immune_status1 DEAD
        immune_status2 {CONDEMNED, BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 133: ALLOSAURUS
        monster_prop ALLOSAURUS
        speed 15
        attack_power 10
        defense 105
        mag_def 50
        mag_pwr 3
        hp 3000
        mp 300
        exp 953
        gil 731
        level 38
        attack_anim DRAGON_CLAW
        special_attack SKULL_SLASH, POISON, NO_DMG
        metamorph 2, 2
        monster_status HARDER_TO_RUN
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status1 POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 134: CIRPIUS
        monster_prop CIRPIUS
        speed 30
        attack_power 13
        defense 80
        mag_def 110
        mag_pwr 10
        hp 134
        mp 100
        exp 82
        gil 102
        level 10
        attack_anim ICE_ROD
        special_attack SMALL_PIERCE, PETRIFY, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        immune_status1 IMP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 135: SPRINTER
        monster_prop SPRINTER
        speed 55
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 4500
        mp 350
        exp 2293
        gil 1420
        level 53
        attack_anim ICE_ROD
        special_attack SMALL_PIERCE, DRAIN_MP
        metamorph 0, 0
        elem_weak LIGHTNING
        immune_status1 {BLIND, POISON, IMP, PETRIFY}
        immune_status2 NEAR_FATAL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 136: GOBBLER
        monster_prop GOBBLER
        speed 30
        attack_power 13
        defense 170
        mag_def 120
        mag_pwr 8
        hp 470
        mp 63
        exp 438
        gil 250
        level 19
        attack_anim ICE_ROD
        special_attack BLUE_STAB_1, SILENCE, NO_DMG
        metamorph 1, 2
        monster_status CANT_SUPLEX
        immune_status1 IMP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 137: HARPIAI
        monster_prop HARPIAI
        speed 30
        attack_power 19
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1418
        mp 100
        exp 449
        gil 909
        level 29
        attack_anim ICE_ROD
        special_attack DIAG_CLAW, DMG_150_PCT
        metamorph 18, 4
        monster_status CANT_SUPLEX
        elem_weak WIND
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 138: GLOOMSHELL
        monster_prop GLOOMSHELL
        speed 35
        attack_power 13
        defense 115
        mag_def 150
        mag_pwr 10
        hp 2905
        mp 175
        exp 1096
        gil 421
        level 41
        attack_anim UNARMED
        special_attack NET, PETRIFY, NO_DMG
        metamorph 0, 2
        elem_weak ICE
        immune_status1 {BLIND, POISON, IMP, PETRIFY}
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 139: DROP
        monster_prop DROP
        speed 30
        attack_power 6
        defense 100
        mag_def 150
        mag_pwr 10
        hp 1000
        mp 80
        exp 398
        gil 427
        level 27
        attack_anim UNARMED
        special_attack THICK_HORZ_SLASH, CONFUSE, NO_DMG
        metamorph 4, 2
        monster_flags DIE_AT_0_MP
        monster_status CANT_SUPLEX
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        apply_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 140: MIND_CANDY
        monster_prop MIND_CANDY
        speed 30
        attack_power 14
        defense 105
        mag_def 165
        mag_pwr 10
        hp 290
        mp 100
        exp 128
        gil 168
        level 15
        attack_anim ICE_ROD
        special_attack STING, SLEEP, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak {FIRE, WIND}
        immune_status1 IMP
        immune_status2 SLEEP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 141: WEEDFEEDER
        monster_prop WEEDFEEDER
        speed 30
        attack_power 13
        defense 115
        mag_def 150
        mag_pwr 10
        hp 480
        mp 20
        exp 278
        gil 234
        level 17
        attack_anim UNARMED
        special_attack MUSIC_NOTE, BERSERK, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak {FIRE, WIND}
        immune_status1 {BLIND, IMP}
        immune_status2 {SILENCE, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 142: LURIDAN
        monster_prop LURIDAN
        speed 33
        attack_power 12
        evade 25
        defense 210
        mag_def 125
        mag_pwr 10
        hp 2079
        mp 122
        exp 707
        gil 1000
        level 34
        attack_anim ICE_ROD
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 0, 2
        elem_weak {FIRE, WIND}
        immune_status1 {BLIND, IMP}
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 143: TOE_CUTTER
        monster_prop TOE_CUTTER
        speed 40
        attack_power 21
        evade 20
        defense 125
        mag_def 140
        mag_pwr 12
        hp 2500
        mp 187
        exp 1753
        gil 726
        level 36
        attack_anim RUNE_EDGE
        special_attack RED_STAB, DRAIN_HP
        metamorph 1, 3
        elem_absorb ICE
        elem_weak {FIRE, WIND}
        immune_status1 {BLIND, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 144: OVER_GRUNK
        monster_prop OVER_GRUNK
        speed 30
        attack_power 13
        defense 125
        mag_def 125
        mag_pwr 10
        hp 492
        mp 100
        exp 219
        gil 365
        level 15
        attack_anim MAGICAL_BRSH
        special_attack SMALL_PIERCE, POISON, NO_DMG
        metamorph 3, 0
        monster_status CANT_SUPLEX
        elem_weak FIRE
        immune_status1 {BLIND, ZOMBIE, IMP}
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 145: EXORAY
        monster_prop EXORAY
        speed 33
        attack_power 13
        defense 105
        mag_def 105
        mag_pwr 10
        hp 1200
        mp 112
        exp 449
        gil 370
        level 29
        attack_anim UNARMED
        special_attack FLOWER, ZOMBIE, NO_DMG
        metamorph 3, 2
        monster_flags UNDEAD
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, CONFUSE, SLEEP}
        apply_status3 SHELL
        end_monster_prop

; ------------------------------------------------------------------------------

; 146: CRUSHER
        monster_prop CRUSHER
        speed 30
        attack_power 13
        defense 145
        mag_def 85
        mag_pwr 5
        hp 2095
        mp 340
        exp 788
        gil 577
        level 36
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_500_PCT
        metamorph 3, 2
        elem_weak FIRE
        immune_status1 {BLIND, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 147: UROBUROS
        monster_prop UROBUROS
        speed 40
        attack_power 13
        defense 252
        mag_def 252
        mag_pwr 10
        hp 50
        mp 760
        exp 1780
        gil 390
        level 48
        attack_anim MAGICAL_BRSH
        special_attack SMALL_PIERCE, ZOMBIE, NO_DMG
        metamorph 3, 2
        elem_absorb FIRE
        elem_weak ICE
        immune_status1 {BLIND, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 148: PRIMORDITE
        monster_prop PRIMORDITE
        speed 30
        attack_power 13
        defense 50
        mag_def 150
        mag_pwr 10
        hp 145
        mp 10
        exp 90
        gil 115
        level 11
        attack_anim UNARMED
        special_attack BLUE_STAB_1, STOP, NO_DMG
        metamorph 0, 2
        elem_weak LIGHTNING
        immune_status1 IMP
        end_monster_prop

; ------------------------------------------------------------------------------

; 149: SKY_CAP
        monster_prop SKY_CAP
        speed 35
        attack_power 13
        defense 105
        mag_def 150
        mag_pwr 8
        hp 3262
        mp 200
        exp 1253
        gil 441
        level 40
        attack_anim UNARMED
        special_attack BLUE_STAB_1, SAP, NO_DMG
        metamorph 4, 2
        monster_status CANT_SUPLEX
        elem_weak {LIGHTNING, WIND, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 150: CEPHALER
        monster_prop CEPHALER
        speed 30
        attack_power 10
        defense 100
        mag_def 140
        mag_pwr 10
        hp 420
        mp 100
        exp 214
        gil 280
        level 21
        attack_anim MAGICAL_BRSH
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 0, 0
        elem_weak LIGHTNING
        immune_status1 {IMP, DEAD}
        immune_status2 {CONDEMNED, CONFUSE}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 151: MALIGA
        monster_prop MALIGA
        speed 30
        attack_power 15
        defense 110
        mag_def 145
        mag_pwr 10
        hp 952
        mp 100
        exp 360
        gil 576
        level 26
        attack_anim UNARMED
        special_attack THICK_DIAG_SLASH, DMG_150_PCT
        metamorph 0, 2
        elem_weak {ICE, LIGHTNING, WATER}
        immune_status1 {BLIND, IMP, PETRIFY}
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 152: GIGAN_TOAD
        monster_prop GIGAN_TOAD
        speed 30
        attack_power 11
        defense 100
        mag_def 130
        mag_pwr 10
        hp 458
        mp 20
        exp 235
        gil 340
        level 26
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 0, 2
        elem_weak ICE
        immune_status1 {POISON, DEAD}
        immune_status2 CONDEMNED
        end_monster_prop

; ------------------------------------------------------------------------------

; 153: GECKOREX
        monster_prop GECKOREX
        speed 35
        attack_power 13
        evade 10
        mblock 10
        defense 135
        mag_def 155
        mag_pwr 10
        hp 5000
        mp 1020
        exp 2400
        gil 1120
        level 54
        attack_anim UNARMED
        special_attack THICK_HORZ_SLASH, PETRIFY, NO_DMG
        metamorph 0, 3
        elem_weak ICE
        immune_status1 PETRIFY
        end_monster_prop

; ------------------------------------------------------------------------------

; 154: CLUCK
        monster_prop CLUCK
        speed 33
        attack_power 13
        defense 105
        mag_def 155
        mag_pwr 10
        hp 2366
        mp 185
        exp 770
        gil 422
        level 38
        attack_anim ICE_ROD
        special_attack THICK_HORZ_SLASH, PETRIFY, NO_DMG
        metamorph 0, 2
        elem_absorb POISON
        elem_weak ICE
        immune_status1 {BLIND, POISON, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 155: LAND_WORM
        monster_prop LAND_WORM
        speed 30
        attack_power 13
        defense 80
        mag_def 120
        mag_pwr 8
        hp 12000
        mp 1300
        exp 4600
        level 59
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 14, 4
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE}
        elem_absorb EARTH
        elem_weak ICE
        immune_status1 IMP
        end_monster_prop

; ------------------------------------------------------------------------------

; 156: TEST_RIDER
        monster_prop TEST_RIDER
        speed 40
        attack_power 27
        defense 135
        mag_def 155
        mag_pwr 10
        hp 3100
        mp 220
        exp 1947
        gil 520
        level 32
        attack_anim TRIDENT
        special_attack HORZ_CLAW, DMG_300_PCT
        metamorph 21, 4
        monster_flags {DIE_AT_0_MP, HUMAN, IMP_DMG_BONUS}
        monster_status HARDER_TO_RUN
        elem_weak POISON
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 157: PLUTOARMOR
        monster_prop PLUTOARMOR
        speed 35
        attack_power 13
        defense 105
        mag_def 150
        mag_pwr 9
        hp 2850
        mp 220
        exp 853
        gil 629
        level 39
        attack_anim TRIDENT
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 4, 3
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 158: TOMB_THUMB
        monster_prop TOMB_THUMB
        speed 32
        attack_power 10
        defense 150
        mag_def 120
        mag_pwr 10
        hp 2000
        mp 100
        exp 500
        gil 150
        level 33
        attack_anim DIRK
        special_attack LIGHT_BEAM, HASTE, NO_DMG
        metamorph 4, 2
        monster_flags HUMAN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 159: HEAVYARMOR
        monster_prop HEAVYARMOR
        speed 40
        attack_power 53
        defense 150
        mag_def 110
        mag_pwr 11
        hp 495
        mp 150
        exp 80
        gil 195
        level 13
        attack_anim UNARMED
        special_attack AIR_ANCHOR, DMG_150_PCT
        metamorph 4, 3
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 160: CHASER
        monster_prop CHASER
        speed 40
        attack_power 13
        defense 200
        mag_def 150
        mag_pwr 8
        hp 1202
        mp 140
        exp 691
        gil 380
        level 19
        attack_anim DRAGON_CLAW
        special_attack MULTI_PUNCH, SHELL, NO_DMG
        metamorph 4, 3
        monster_status CANT_SUPLEX
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 161: SCULLION
        monster_prop SCULLION
        speed 40
        attack_power 13
        defense 175
        mag_def 145
        mag_pwr 15
        hp 27000
        mp 9000
        exp 9000
        level 57
        attack_anim UNARMED
        special_attack LIGHT_BEAM, CONDEMNED, NO_DMG
        metamorph 5, 4
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 162: POPLIUM
        monster_prop POPLIUM
        speed 25
        attack_power 13
        defense 55
        mag_def 150
        mag_pwr 10
        hp 145
        mp 25
        exp 55
        gil 55
        level 11
        attack_anim UNARMED
        special_attack NET, SLOW, NO_DMG
        metamorph 0, 2
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 163: INTANGIR
        monster_prop INTANGIR
        speed 50
        attack_power 25
        evade 50
        defense 150
        mag_def 150
        mag_pwr 10
        hp 32000
        mp 16000
        level 26
        attack_anim UNARMED
        special_attack BUBBLE, VANISH, {NO_DMG, CANT_MISS}
        metamorph 11, 4
        monster_flags {DIE_AT_0_MP, IMP_DMG_BONUS}
        elem_absorb {FIRE, ICE, LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        apply_status1 VANISH
        apply_status3 {FLYING, HASTE, SHELL, SAFE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 164: MISFIT
        monster_prop MISFIT
        speed 35
        attack_power 26
        defense 105
        mag_def 155
        mag_pwr 10
        hp 1750
        mp 140
        exp 750
        gil 786
        level 26
        attack_anim UNARMED
        special_attack THICK_HORZ_SLASH, BLIND, NO_DMG
        metamorph 1, 2
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 165: ELAND
        monster_prop ELAND
        speed 32
        attack_power 13
        evade 10
        defense 110
        mag_def 155
        mag_pwr 10
        hp 2470
        mp 145
        exp 775
        gil 550
        level 37
        attack_anim UNARMED
        special_attack FLOWER, CONFUSE, NO_DMG
        metamorph 0, 2
        elem_weak LIGHTNING
        immune_status1 IMP
        immune_status2 SLEEP
        end_monster_prop

; ------------------------------------------------------------------------------

; 166: ENUO
        monster_prop ENUO
        speed 30
        attack_power 13
        defense 50
        mag_def 250
        mag_pwr 10
        hp 4635
        mp 280
        exp 1429
        gil 968
        level 46
        attack_anim UNARMED
        special_attack BLOB_MAN, SLOW, NO_DMG
        metamorph 14, 4
        elem_weak HOLY
        immune_status1 {BLIND, POISON, IMP}
        immune_status2 {NEAR_FATAL, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status2 SAP
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 167: DEEP_EYE
        monster_prop DEEP_EYE
        speed 30
        attack_power 14
        defense 100
        mag_def 150
        mag_pwr 10
        hp 1334
        mp 100
        exp 385
        gil 485
        level 28
        attack_anim UNARMED
        special_attack FLOWER, SLEEP, NO_DMG
        metamorph 0, 2
        elem_weak FIRE
        immune_status1 IMP
        immune_status2 SLEEP
        end_monster_prop

; ------------------------------------------------------------------------------

; 168: GREASEMONK
        monster_prop GREASEMONK
        speed 35
        attack_power 15
        defense 100
        mag_def 150
        mag_pwr 10
        hp 132
        mp 100
        exp 53
        gil 256
        level 8
        attack_anim DIRK
        special_attack WRENCH, DMG_150_PCT
        metamorph 0, 0
        monster_flags HUMAN
        elem_weak POISON
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 169: NECKHUNTER
        monster_prop NECKHUNTER
        speed 30
        attack_power 5
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1334
        mp 150
        exp 588
        gil 1330
        level 28
        attack_anim RUNE_EDGE
        special_attack BLUE_STAB_1, CONFUSE, NO_DMG
        metamorph 0, 2
        monster_flags {HUMAN, IMP_DMG_BONUS}
        elem_weak POISON
        immune_status1 IMP
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 170: GRENADE
        monster_prop GRENADE
        speed 30
        attack_power 13
        mag_def 150
        mag_pwr 10
        hp 3000
        mp 500
        exp 190
        gil 500
        level 17
        attack_anim UNARMED
        special_attack THIN_HORZ_SLASH, BERSERK, NO_DMG
        metamorph 20, 4
        monster_status CANT_SUPLEX
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {IMP, PETRIFY}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 171: CRITIC
        monster_prop CRITIC
        speed 30
        attack_power 13
        defense 125
        mag_def 150
        mag_pwr 10
        hp 1200
        mp 330
        exp 1323
        gil 531
        level 40
        attack_anim UNARMED
        special_attack BLUE_STAB_1, SAP, NO_DMG
        metamorph 24, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 172: PAN_DORA
        monster_prop PAN_DORA
        speed 25
        attack_power 13
        defense 140
        mag_def 80
        mag_pwr 10
        hp 1522
        mp 350
        exp 622
        gil 461
        level 39
        attack_anim UNARMED
        special_attack BUBBLE, SLEEP, NO_DMG
        metamorph 19, 4
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 173: SOULDANCER
        monster_prop SOULDANCER
        speed 30
        attack_power 1
        defense 60
        mag_def 170
        mag_pwr 30
        hp 2539
        mp 100
        exp 1531
        gil 769
        level 22
        attack_anim HARDENED
        special_attack DIAG_CLAW, DRAIN_HP
        metamorph 9, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status HARDER_TO_RUN
        elem_weak POISON
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL}
        end_monster_prop

; ------------------------------------------------------------------------------

; 174: GIGANTOS
        monster_prop GIGANTOS
        speed 50
        attack_power 20
        defense 1
        mag_def 1
        mag_pwr 10
        hp 6000
        mp 1120
        exp 7550
        level 25
        attack_anim UNARMED
        special_attack DIAG_CLAW, DMG_500_PCT
        metamorph 8, 4
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_weak POISON
        immune_status2 {CONFUSE, SLEEP}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 175: MAG_ROADER_2
        monster_prop MAG_ROADER_2
        speed 25
        attack_power 10
        defense 20
        mag_def 140
        mag_pwr 1
        hp 250
        mp 100
        exp 198
        gil 300
        level 18
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 4, 3
        monster_status CANT_ESCAPE
        elem_weak ICE
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, SLEEP}
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 176: SPEK_TOR
        monster_prop SPEK_TOR
        speed 70
        attack_power 30
        evade 50
        defense 100
        mag_def 200
        mag_pwr 10
        hp 250
        mp 20
        exp 1356
        gil 1524
        level 50
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, DMG_150_PCT
        metamorph 10, 4
        monster_flags IMP_DMG_BONUS
        elem_weak WATER
        immune_status1 DEAD
        immune_status2 {CONDEMNED, SILENCE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 177: PARASITE
        monster_prop PARASITE
        speed 20
        attack_power 1
        defense 140
        mag_def 5
        mag_pwr 1
        hp 1000
        mp 230
        exp 455
        gil 461
        level 39
        attack_anim UNARMED
        special_attack LIGHT_BEAM, STOP, NO_DMG
        metamorph 0, 2
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        elem_weak FIRE
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 178: EARTHGUARD
        monster_prop EARTHGUARD
        speed 45
        attack_power 6
        defense 5
        mag_def 5
        mag_pwr 10
        hp 1
        mp 18
        exp 1
        level 23
        attack_anim UNARMED
        special_attack ARC_SLASH, POISON, NO_DMG
        metamorph 0, 2
        elem_weak WATER
        immune_status1 {BLIND, IMP, PETRIFY}
        immune_status2 {CONDEMNED, SLEEP}
        apply_status2 SAP
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 179: COELECITE
        monster_prop COELECITE
        speed 35
        attack_power 20
        defense 120
        mag_def 130
        mag_pwr 10
        hp 480
        mp 15
        exp 290
        gil 270
        level 20
        attack_anim ICE_ROD
        special_attack STING, SLEEP, NO_DMG
        metamorph 0, 0
        elem_absorb FIRE
        elem_weak ICE
        immune_status1 {BLIND, IMP}
        immune_status2 {SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 180: ANEMONE
        monster_prop ANEMONE
        speed 33
        attack_power 10
        defense 115
        mag_def 145
        mag_pwr 10
        hp 2000
        mp 100
        exp 1000
        gil 550
        level 33
        attack_anim UNARMED
        special_attack SMALL_PIERCE, IMP, NO_DMG
        metamorph 0, 2
        elem_absorb {LIGHTNING, WATER}
        elem_weak {FIRE, LIGHTNING}
        immune_status1 {BLIND, IMP}
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 181: HIPOCAMPUS
        monster_prop HIPOCAMPUS
        speed 37
        attack_power 15
        defense 115
        mag_def 160
        mag_pwr 10
        hp 2444
        mp 82
        exp 981
        gil 669
        level 37
        attack_anim UNARMED
        special_attack SMALL_PIERCE, SAP, NO_DMG
        metamorph 0, 2
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 182: SPECTRE
        monster_prop SPECTRE
        speed 35
        attack_power 1
        mag_def 160
        mag_pwr 8
        hp 235
        mp 120
        exp 220
        gil 138
        level 13
        attack_anim ICE_ROD
        special_attack LARGE_PIERCE, DMG_150_PCT
        metamorph 0, 0
        monster_flags {HUMAN, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 183: EVIL_OSCAR
        monster_prop EVIL_OSCAR
        speed 30
        attack_power 13
        defense 115
        mag_def 105
        mag_pwr 6
        hp 7000
        mp 500
        exp 2800
        gil 1320
        level 56
        attack_anim UNARMED
        special_attack SKULL_SLASH, DEAD, NO_DMG
        metamorph 3, 3
        monster_status HARDER_TO_RUN
        elem_absorb {ICE, LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        elem_weak FIRE
        immune_status1 BLIND
        immune_status2 SILENCE
        end_monster_prop

; ------------------------------------------------------------------------------

; 184: SLURM
        monster_prop SLURM
        speed 30
        attack_power 12
        defense 50
        mag_def 50
        mag_pwr 10
        hp 505
        mp 20
        exp 232
        gil 270
        level 23
        attack_anim UNARMED
        special_attack BLOB_MAN, SAP, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak FIRE
        immune_status1 {BLIND, VANISH, IMP}
        immune_status2 {IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 185: LATIMERIA
        monster_prop LATIMERIA
        speed 35
        attack_power 15
        defense 125
        mag_def 140
        mag_pwr 9
        hp 1700
        mp 100
        exp 612
        gil 971
        level 27
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 1, 2
        elem_weak LIGHTNING
        immune_status1 {BLIND, POISON, IMP, DEAD}
        immune_status2 {BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 186: STILLGOING
        monster_prop STILLGOING
        speed 30
        attack_power 10
        defense 100
        mag_def 150
        mag_pwr 10
        hp 200
        mp 84
        exp 54
        gil 135
        level 12
        attack_anim DIRK
        special_attack SMALL_PIERCE, SAP, NO_DMG
        metamorph 0, 0
        monster_flags {HUMAN, UNDEAD}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 187: ALLO_VER
        monster_prop ALLO_VER
        speed 55
        attack_power 13
        defense 140
        mag_def 160
        mag_pwr 55
        hp 8000
        mp 8000
        level 19
        attack_anim RUNE_EDGE
        special_attack SKULL_SLASH, DEAD, NO_DMG
        metamorph 3, 4
        monster_flags {HUMAN, UNDEAD}
        monster_status CANT_ESCAPE
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {POISON, IMP}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 188: PHASE
        monster_prop PHASE
        speed 30
        attack_power 11
        defense 105
        mag_def 150
        mag_pwr 10
        hp 4550
        mp 1700
        exp 2600
        gil 890
        level 47
        attack_anim UNARMED
        special_attack MUSIC_NOTE, STOP, NO_DMG
        metamorph 14, 4
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_ESCAPE}
        elem_absorb FIRE
        elem_weak ICE
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 189: OUTSIDER
        monster_prop OUTSIDER
        speed 40
        attack_power 15
        defense 105
        mag_def 155
        mag_pwr 4
        hp 8050
        mp 400
        exp 2600
        gil 2800
        level 18
        attack_anim FORGED
        special_attack SKULL_SLASH, DEAD, NO_DMG
        metamorph 25, 4
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        elem_absorb POISON
        elem_weak HOLY
        immune_status1 {BLIND, POISON, IMP}
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 190: BARB_E
        monster_prop BARB_E
        speed 30
        attack_power 13
        defense 100
        mag_def 160
        mag_pwr 10
        hp 3062
        mp 198
        exp 1410
        gil 631
        level 39
        attack_anim HARDENED
        special_attack MULTI_PUNCH, SILENCE, NO_DMG
        metamorph 19, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        elem_weak POISON
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 191: PARASOUL
        monster_prop PARASOUL
        speed 30
        attack_power 13
        defense 80
        mag_def 150
        mag_pwr 10
        hp 2077
        mp 500
        exp 1620
        gil 674
        level 47
        attack_anim UNARMED
        special_attack THICK_HORZ_SLASH, CONFUSE, NO_DMG
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_SUPLEX
        elem_absorb FIRE
        elem_weak ICE
        immune_status1 {IMP, PETRIFY}
        immune_status2 SILENCE
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 192: PM_STALKER
        monster_prop PM_STALKER
        speed 20
        attack_power 9
        defense 140
        mag_def 115
        mag_pwr 6
        hp 265
        mp 190
        exp 258
        gil 491
        level 26
        attack_anim UNARMED
        special_attack SMALL_PIERCE, SAP, NO_DMG
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 193: HEMOPHYTE
        monster_prop HEMOPHYTE
        speed 40
        attack_power 12
        defense 110
        mag_def 145
        mag_pwr 14
        hp 6800
        mp 1600
        exp 3090
        gil 200
        level 56
        attack_anim FORGED
        special_attack THICK_HORZ_SLASH, SAP, NO_DMG
        metamorph 1, 2
        monster_flags HUMAN
        monster_status HARDER_TO_RUN
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL}
        end_monster_prop

; ------------------------------------------------------------------------------

; 194: SP_FORCES
        monster_prop SP_FORCES
        speed 40
        attack_power 13
        defense 100
        mag_def 140
        mag_pwr 10
        hp 700
        mp 20
        exp 200
        level 21
        attack_anim RUNE_EDGE
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 1, 2
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status CANT_ESCAPE
        elem_weak POISON
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, PETRIFY, DEAD}
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 195: NOHRABBIT
        monster_prop NOHRABBIT
        speed 30
        attack_power 7
        defense 100
        mag_def 100
        mag_pwr 30
        hp 75
        mp 200
        level 26
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 2, 0
        elem_weak WATER
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK}
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 196: WIZARD
        monster_prop WIZARD
        speed 33
        attack_power 13
        defense 50
        mag_def 160
        mag_pwr 10
        hp 1677
        mp 200
        exp 587
        gil 388
        level 32
        attack_anim ICE_ROD
        special_attack MUSIC_NOTE, ZOMBIE, NO_DMG
        metamorph 0, 0
        monster_flags HUMAN
        elem_weak {LIGHTNING, POISON}
        immune_status1 {BLIND, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, BERSERK, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 197: SCRAPPER
        monster_prop SCRAPPER
        speed 37
        attack_power 10
        evade 120
        defense 125
        mag_def 145
        mag_pwr 10
        hp 1759
        mp 68
        exp 797
        gil 2000
        level 34
        attack_anim DRAGON_CLAW
        special_attack ARC_SLASH, DMG_150_PCT
        metamorph 0, 0
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status HARDER_TO_RUN
        elem_absorb POISON
        immune_status1 {PETRIFY, DEAD}
        immune_status2 {CONDEMNED, BERSERK, CONFUSE}
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 198: CERITOPS
        monster_prop CERITOPS
        speed 34
        attack_power 10
        defense 130
        mag_def 150
        mag_pwr 10
        hp 2000
        mp 100
        exp 1000
        gil 850
        level 33
        attack_anim UNARMED
        special_attack FLOWER, IMP, NO_DMG
        metamorph 2, 2
        monster_flags {DIE_AT_0_MP, IMP_DMG_BONUS}
        elem_absorb LIGHTNING
        elem_weak FIRE
        immune_status1 {BLIND, POISON, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, CONFUSE}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 199: COMMANDO
        monster_prop COMMANDO
        speed 30
        attack_power 13
        defense 210
        mag_def 145
        mag_pwr 10
        hp 580
        mp 35
        exp 252
        gil 273
        level 18
        attack_anim RUNE_EDGE
        special_attack MULTI_PUNCH, SILENCE, NO_DMG
        metamorph 0, 0
        monster_flags HUMAN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 200: OPINICUS
        monster_prop OPINICUS
        speed 38
        attack_power 22
        mblock 20
        defense 135
        mag_def 150
        mag_pwr 10
        hp 3210
        mp 514
        exp 1270
        gil 519
        level 38
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 1, 3
        monster_flags {IMP_DMG_BONUS, UNDEAD}
        monster_status HARDER_TO_RUN
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 201: POPPERS
        monster_prop POPPERS
        speed 34
        attack_power 5
        defense 120
        mag_def 140
        mag_pwr 10
        hp 1000
        mp 100
        exp 800
        gil 350
        level 33
        attack_anim UNARMED
        special_attack ARC_SLASH, IMP, NO_DMG
        metamorph 2, 0
        monster_status CANT_SUPLEX
        elem_weak FIRE
        immune_status1 IMP
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 202: LUNARIS
        monster_prop LUNARIS
        speed 25
        attack_power 13
        defense 155
        mag_def 145
        mag_pwr 10
        hp 582
        mp 25
        exp 308
        gil 247
        level 26
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, BLIND, NO_DMG
        metamorph 2, 0
        immune_status1 DEAD
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 203: GARM
        monster_prop GARM
        speed 30
        attack_power 13
        defense 220
        mag_def 140
        mag_pwr 10
        hp 615
        mp 45
        exp 228
        gil 343
        level 19
        attack_anim DRAGON_CLAW
        special_attack MULTI_PUNCH, CONFUSE, NO_DMG
        metamorph 4, 0
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 204: VINDR
        monster_prop VINDR
        speed 30
        attack_power 14
        evade 90
        defense 100
        mag_def 150
        mag_pwr 10
        hp 885
        mp 87
        exp 653
        gil 497
        level 36
        attack_anim ICE_ROD
        special_attack SMALL_PIERCE, PETRIFY, NO_DMG
        metamorph 0, 0
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        elem_weak FIRE
        immune_status1 IMP
        immune_status2 SLEEP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 205: KIWOK
        monster_prop KIWOK
        speed 33
        attack_power 10
        defense 105
        mag_def 145
        mag_pwr 10
        hp 2000
        mp 100
        exp 1000
        gil 750
        level 33
        attack_anim UNARMED
        special_attack SMALL_PIERCE, IMP, NO_DMG
        metamorph 0, 0
        monster_flags IMP_DMG_BONUS
        monster_status HARDER_TO_RUN
        elem_weak ICE
        immune_status1 {IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 206: NASTIDON
        monster_prop NASTIDON
        speed 35
        attack_power 13
        defense 145
        mag_def 105
        mag_pwr 10
        hp 1877
        mp 100
        exp 697
        gil 298
        level 32
        attack_anim UNARMED
        special_attack HORZ_CLAW, DMG_150_PCT
        metamorph 2, 2
        elem_weak FIRE
        immune_status1 DEAD
        immune_status2 CONDEMNED
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 207: RINN
        monster_prop RINN
        speed 25
        attack_power 10
        defense 55
        mag_def 125
        mag_pwr 10
        hp 110
        mp 35
        exp 95
        gil 100
        level 11
        attack_anim UNARMED
        special_attack NET, SLOW, NO_DMG
        metamorph 0, 0
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 208: INSECARE
        monster_prop INSECARE
        speed 35
        attack_power 15
        defense 115
        mag_def 155
        mag_pwr 10
        hp 977
        mp 80
        exp 292
        gil 410
        level 23
        attack_anim UNARMED
        special_attack MUSIC_NOTE, BERSERK, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak {FIRE, WIND}
        immune_status1 {BLIND, IMP}
        immune_status2 {SILENCE, CONFUSE, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 209: VERMIN
        monster_prop VERMIN
        speed 35
        attack_power 20
        defense 120
        mag_def 190
        mag_pwr 10
        hp 499
        mp 40
        exp 145
        gil 235
        level 16
        attack_anim UNARMED
        special_attack BUBBLE, SAP, NO_DMG
        metamorph 2, 0
        monster_flags IMP_DMG_BONUS
        monster_status CANT_ESCAPE
        elem_absorb POISON
        elem_weak ICE
        end_monster_prop

; ------------------------------------------------------------------------------

; 210: MANTODEA
        monster_prop MANTODEA
        speed 45
        attack_power 180
        defense 145
        mag_def 100
        mag_pwr 10
        hp 4500
        mp 420
        exp 4612
        gil 501
        level 54
        attack_anim RUNE_EDGE
        special_attack BLUE_STAB_1, DRAIN_MP
        metamorph 1, 3
        monster_status HARDER_TO_RUN
        elem_weak FIRE
        immune_status1 {BLIND, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 211: BOGY
        monster_prop BOGY
        speed 30
        attack_power 15
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1318
        mp 100
        exp 532
        gil 1200
        level 29
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        immune_status1 PETRIFY
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 212: PRUSSIAN
        monster_prop PRUSSIAN
        speed 35
        attack_power 13
        defense 115
        mag_def 155
        mag_pwr 10
        hp 3300
        mp 188
        exp 1396
        gil 773
        level 41
        attack_anim DRAGON_CLAW
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 2, 2
        immune_status1 PETRIFY
        immune_status2 {NEAR_FATAL, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 213: BLACK_DRGN
        monster_prop BLACK_DRGN
        speed 30
        attack_power 14
        defense 102
        mag_def 20
        mag_pwr 10
        hp 4000
        mp 600
        exp 780
        gil 502
        level 26
        attack_anim UNARMED
        special_attack FLOWER, ZOMBIE, NO_DMG
        metamorph 3, 3
        monster_flags UNDEAD
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 214: ADAMANCHYT
        monster_prop ADAMANCHYT
        speed 40
        attack_power 22
        defense 225
        mag_def 45
        mag_pwr 10
        hp 1305
        mp 50
        exp 1450
        gil 189
        level 24
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, DMG_150_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        immune_status1 {PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, CONFUSE}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 215: DANTE
        monster_prop DANTE
        speed 40
        attack_power 17
        defense 105
        mag_def 150
        mag_pwr 10
        hp 1945
        mp 200
        exp 1150
        gil 712
        level 28
        attack_anim TRIDENT
        special_attack ARC_SLASH, DMG_300_PCT
        metamorph 22, 4
        monster_flags {DIE_AT_0_MP, HUMAN, UNDEAD}
        elem_weak POISON
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 216: WIREY_DRGN
        monster_prop WIREY_DRGN
        speed 31
        attack_power 35
        defense 150
        mag_def 115
        mag_pwr 10
        hp 2802
        mp 200
        exp 895
        gil 1300
        level 26
        attack_anim DRAGON_CLAW
        special_attack HORZ_CLAW, DMG_200_PCT
        metamorph 6, 4
        monster_status CANT_SUPLEX
        immune_status1 IMP
        apply_status3 {FLYING, SAFE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 217: DUELLER
        monster_prop DUELLER
        speed 35
        attack_power 13
        defense 185
        mag_def 145
        mag_pwr 10
        hp 7200
        mp 1600
        exp 2500
        gil 800
        level 53
        attack_anim UNARMED
        special_attack LIGHTNING, DMG_300_PCT
        metamorph 4, 3
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 218: PSYCHOT
        monster_prop PSYCHOT
        speed 33
        attack_power 14
        defense 165
        mag_def 125
        mag_pwr 10
        hp 900
        mp 55
        exp 347
        gil 275
        level 32
        attack_anim UNARMED
        special_attack LIGHTNING, DRAIN_MP
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_absorb FIRE
        elem_weak ICE
        immune_status1 {BLIND, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 219: MUUS
        monster_prop MUUS
        speed 30
        attack_power 11
        defense 110
        mag_def 105
        mag_pwr 10
        hp 900
        mp 100
        exp 189
        gil 287
        level 28
        attack_anim UNARMED
        special_attack BLOB_MAN, SLOW, NO_DMG
        metamorph 0, 0
        monster_flags DIE_AT_0_MP
        monster_status HARDER_TO_RUN
        elem_null {POISON, WIND, HOLY, EARTH, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE, SLEEP}
        apply_status3 SHELL
        end_monster_prop

; ------------------------------------------------------------------------------

; 220: KARKASS
        monster_prop KARKASS
        speed 33
        attack_power 13
        defense 105
        mag_def 155
        mag_pwr 10
        hp 3850
        mp 185
        exp 1399
        gil 826
        level 43
        attack_anim UNARMED
        special_attack BLOB_MAN, IMP, NO_DMG
        metamorph 3, 2
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, IMP, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 221: PUNISHER
        monster_prop PUNISHER
        speed 35
        attack_power 28
        evade 115
        defense 100
        mag_def 155
        mag_pwr 10
        hp 2191
        mp 136
        exp 1242
        gil 3000
        level 35
        attack_anim RUNE_EDGE
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 0, 2
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status HARDER_TO_RUN
        elem_weak POISON
        immune_status1 IMP
        immune_status2 SLEEP
        immune_status3 {SLOW, STOP}
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 222: BALLOON
        monster_prop BALLOON
        speed 25
        attack_power 11
        defense 20
        mag_def 130
        mag_pwr 10
        hp 555
        mp 80
        exp 369
        gil 300
        level 22
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 20, 4
        monster_status CANT_SUPLEX
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 IMP
        immune_status2 SLEEP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 223: GABBLDEGAK
        monster_prop GABBLDEGAK
        speed 30
        attack_power 13
        defense 85
        mag_def 155
        mag_pwr 10
        hp 350
        mp 20
        exp 104
        gil 126
        level 15
        attack_anim DIRK
        special_attack WRENCH, DMG_150_PCT
        metamorph 0, 0
        monster_flags HUMAN
        elem_weak POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 224: GTBEHEMOTH
        monster_prop GTBEHEMOTH
        speed 35
        attack_power 7
        defense 90
        mag_def 105
        mag_pwr 10
        hp 11000
        mp 700
        exp 4100
        gil 2900
        level 58
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_400_PCT
        metamorph 14, 4
        monster_status {HARDER_TO_RUN, CANT_ESCAPE}
        immune_status1 {BLIND, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, CONFUSE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 225: SCORPION
        monster_prop SCORPION
        speed 20
        attack_power 10
        defense 5
        mag_def 215
        mag_pwr 9
        hp 290
        mp 19
        exp 199
        gil 336
        level 26
        attack_anim ICE_ROD
        special_attack STING, CONDEMNED, NO_DMG
        metamorph 0, 0
        immune_status1 {BLIND, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 226: CHAOS_DRGN
        monster_prop CHAOS_DRGN
        speed 30
        attack_power 13
        defense 5
        mag_def 85
        mag_pwr 10
        hp 9013
        mp 1300
        exp 4881
        gil 1000
        level 44
        attack_anim DRAGON_CLAW
        special_attack LIGHTNING, DEAD, NO_DMG
        metamorph 2, 3
        monster_flags IMP_DMG_BONUS
        elem_absorb FIRE
        elem_weak ICE
        immune_status1 {PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 227: SPIT_FIRE
        monster_prop SPIT_FIRE
        speed 35
        attack_power 17
        defense 155
        mag_def 130
        mag_pwr 4
        hp 1400
        mp 180
        exp 550
        gil 300
        level 25
        attack_anim TRIDENT
        special_attack HORZ_CLAW, DMG_150_PCT
        metamorph 5, 3
        monster_status {CANT_SUPLEX, CANT_ESCAPE}
        elem_weak {LIGHTNING, WIND}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 228: VECTAGOYLE
        monster_prop VECTAGOYLE
        speed 37
        attack_power 22
        evade 30
        mblock 30
        defense 110
        mag_def 150
        mag_pwr 9
        hp 7500
        mp 880
        exp 2900
        gil 900
        level 57
        attack_anim TRIDENT
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 22, 4
        monster_status HARDER_TO_RUN
        immune_status1 {BLIND, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 229: LICH
        monster_prop LICH
        speed 35
        attack_power 1
        defense 50
        mag_def 190
        mag_pwr 10
        hp 590
        mp 90
        exp 374
        gil 350
        level 20
        attack_anim UNARMED
        special_attack SMALL_PIERCE, CONFUSE, NO_DMG
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb {FIRE, POISON}
        elem_weak HOLY
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 230: OSPREY
        monster_prop OSPREY
        speed 25
        attack_power 12
        defense 105
        mag_def 120
        mag_pwr 10
        hp 850
        mp 100
        exp 249
        gil 596
        level 26
        attack_anim DRAGON_CLAW
        special_attack SMALL_PIERCE, PETRIFY, NO_DMG
        metamorph 1, 2
        monster_status CANT_SUPLEX
        elem_weak ICE
        immune_status1 {IMP, PETRIFY}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 231: MAG_ROADER_3
        monster_prop MAG_ROADER_3
        speed 33
        attack_power 13
        defense 115
        mag_def 145
        mag_pwr 10
        hp 1777
        mp 100
        exp 621
        gil 352
        level 32
        attack_anim UNARMED
        special_attack WHEEL, DMG_150_PCT
        metamorph 5, 4
        monster_flags DIE_AT_0_MP
        monster_status HARDER_TO_RUN
        immune_status1 {POISON, IMP, PETRIFY}
        immune_status2 SILENCE
        end_monster_prop

; ------------------------------------------------------------------------------

; 232: BUG
        monster_prop BUG
        speed 35
        attack_power 13
        defense 120
        mag_def 150
        mag_pwr 10
        hp 310
        mp 20
        exp 165
        gil 210
        level 16
        attack_anim ICE_ROD
        special_attack STING, PETRIFY, NO_DMG
        metamorph 0, 0
        monster_status CANT_SUPLEX
        elem_weak {ICE, WATER}
        immune_status1 {BLIND, IMP}
        immune_status2 {SILENCE, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 233: SEA_FLOWER
        monster_prop SEA_FLOWER
        speed 30
        attack_power 13
        defense 135
        mag_def 100
        mag_pwr 10
        hp 4200
        mp 200
        exp 1315
        gil 670
        level 47
        attack_anim RUNE_EDGE
        special_attack BLUE_STAB_2, POISON, NO_DMG
        metamorph 0, 0
        elem_absorb {FIRE, WATER}
        elem_weak {ICE, LIGHTNING}
        immune_status1 {BLIND, POISON, IMP}
        immune_status2 {SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 234: FORTIS
        monster_prop FORTIS
        speed 35
        attack_power 5
        defense 160
        mag_def 150
        mag_pwr 10
        hp 9800
        mp 700
        exp 3500
        gil 250
        level 54
        attack_anim UNARMED
        special_attack AIR_ANCHOR, DMG_200_PCT
        metamorph 4, 3
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 235: ABOLISHER
        monster_prop ABOLISHER
        speed 35
        attack_power 16
        defense 125
        mag_def 150
        mag_pwr 10
        hp 860
        mp 82
        exp 485
        gil 525
        level 24
        attack_anim ICE_ROD
        special_attack FLOWER, POISON, NO_DMG
        metamorph 0, 2
        immune_status1 {IMP, PETRIFY}
        immune_status2 {SILENCE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 236: AQUILA
        monster_prop AQUILA
        speed 40
        attack_power 13
        evade 30
        defense 120
        mag_def 145
        mag_pwr 10
        hp 6013
        mp 820
        exp 2781
        gil 906
        level 49
        attack_anim ICE_ROD
        special_attack MULTI_PUNCH, DMG_500_PCT
        metamorph 18, 4
        monster_status CANT_SUPLEX
        elem_absorb FIRE
        elem_weak ICE
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 237: JUNK
        monster_prop JUNK
        speed 35
        attack_power 2
        defense 190
        mag_def 170
        mag_pwr 10
        hp 2000
        mp 200
        exp 2200
        gil 1100
        level 53
        attack_anim UNARMED
        special_attack LIGHT_BEAM, VANISH, NO_DMG
        metamorph 4, 2
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 238: MANDRAKE
        monster_prop MANDRAKE
        speed 30
        attack_power 16
        defense 115
        mag_def 125
        mag_pwr 10
        hp 1150
        mp 104
        exp 378
        gil 450
        level 23
        attack_anim HARDENED
        special_attack SMALL_PIERCE, PETRIFY, NO_DMG
        metamorph 3, 0
        monster_status CANT_SUPLEX
        elem_absorb WATER
        elem_weak FIRE
        immune_status1 {BLIND, POISON, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, IMAGE, SILENCE, BERSERK, CONFUSE, SLEEP}
        apply_status2 CONFUSE
        end_monster_prop

; ------------------------------------------------------------------------------

; 239: FIRST_CLASS
        monster_prop FIRST_CLASS
        speed 30
        attack_power 13
        defense 55
        mag_def 135
        mag_pwr 10
        hp 180
        mp 25
        exp 117
        gil 112
        level 11
        attack_anim DIRK
        special_attack WRENCH, DMG_150_PCT
        metamorph 0, 2
        monster_flags HUMAN
        elem_weak POISON
        end_monster_prop

; ------------------------------------------------------------------------------

; 240: TAP_DANCER
        monster_prop TAP_DANCER
        speed 39
        attack_power 13
        defense 105
        mag_def 150
        mag_pwr 11
        hp 4452
        mp 270
        exp 1727
        gil 526
        level 43
        attack_anim DIRK
        special_attack HORZ_CLAW, CONFUSE, NO_DMG
        metamorph 9, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        elem_weak POISON
        immune_status1 {BLIND, POISON, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 241: NECROMANCR
        monster_prop NECROMANCR
        speed 25
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 7
        hp 3525
        mp 900
        exp 1510
        gil 791
        level 48
        attack_anim ICE_ROD
        special_attack SKULL_SLASH, ZOMBIE, NO_DMG
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, HUMAN, UNDEAD}
        monster_status CANT_SUPLEX
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 242: BORRAS
        monster_prop BORRAS
        speed 43
        attack_power 23
        evade 105
        mblock 10
        defense 150
        mag_def 145
        mag_pwr 10
        hp 4771
        mp 590
        exp 2953
        gil 2500
        level 35
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_500_PCT
        metamorph 8, 4
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status HARDER_TO_RUN
        elem_weak POISON
        immune_status1 DEAD
        immune_status2 {CONDEMNED, SILENCE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 243: MAG_ROADER_4
        monster_prop MAG_ROADER_4
        speed 33
        attack_power 14
        defense 105
        mag_def 150
        mag_pwr 10
        hp 1380
        mp 70
        exp 647
        gil 284
        level 32
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 4, 2
        monster_flags DIE_AT_0_MP
        monster_status HARDER_TO_RUN
        immune_status1 {BLIND, POISON, IMP}
        immune_status2 SILENCE
        apply_status3 HASTE
        end_monster_prop

; ------------------------------------------------------------------------------

; 244: WILD_RAT
        monster_prop WILD_RAT
        speed 30
        attack_power 10
        defense 85
        mag_def 100
        mag_pwr 10
        hp 160
        mp 10
        exp 135
        gil 135
        level 12
        attack_anim UNARMED
        special_attack DIAG_CLAW, DMG_150_PCT
        metamorph 2, 0
        elem_absorb POISON
        elem_weak FIRE
        end_monster_prop

; ------------------------------------------------------------------------------

; 245: GOLD_BEAR
        monster_prop GOLD_BEAR
        speed 25
        attack_power 13
        defense 40
        mag_def 140
        mag_pwr 10
        hp 275
        mp 0
        exp 160
        gil 185
        level 13
        attack_anim DRAGON_CLAW
        special_attack SINGLE_PUNCH, DMG_250_PCT
        metamorph 2, 2
        monster_flags IMP_DMG_BONUS
        end_monster_prop

; ------------------------------------------------------------------------------

; 246: INNOC
        monster_prop INNOC
        speed 33
        attack_power 13
        defense 155
        mag_def 155
        mag_pwr 12
        hp 6600
        mp 390
        exp 2400
        gil 1950
        level 52
        attack_anim UNARMED
        special_attack BUBBLE, CONFUSE, NO_DMG
        metamorph 4, 3
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        immune_status3 STOP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 247: TRIXTER
        monster_prop TRIXTER
        speed 30
        attack_power 13
        defense 120
        mag_def 165
        mag_pwr 7
        hp 3815
        mp 9900
        exp 1698
        gil 826
        level 49
        attack_anim MAGICAL_BRSH
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 17, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_SUPLEX
        elem_weak HOLY
        immune_status1 {BLIND, IMP, DEAD}
        immune_status2 {CONDEMNED, SILENCE, CONFUSE, SLEEP}
        immune_status3 STOP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 248: RED_WOLF
        monster_prop RED_WOLF
        speed 25
        attack_power 10
        defense 155
        mag_def 140
        mag_pwr 10
        hp 1510
        mp 110
        exp 687
        gil 412
        level 32
        attack_anim DRAGON_CLAW
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 2, 2
        monster_status HARDER_TO_RUN
        immune_status1 {BLIND, POISON, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 249: DIDALOS
        monster_prop DIDALOS
        speed 37
        attack_power 13
        defense 105
        mag_def 150
        mag_pwr 12
        hp 12280
        mp 100
        exp 3500
        level 59
        attack_anim UNARMED
        special_attack SMALL_PIERCE, POISON, NO_DMG
        metamorph 23, 4
        monster_flags UNDEAD
        monster_status HARDER_TO_RUN
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 250: WOOLLY
        monster_prop WOOLLY
        speed 32
        attack_power 17
        evade 20
        defense 105
        mag_def 150
        mag_pwr 11
        hp 3609
        mp 300
        exp 1385
        gil 826
        level 43
        attack_anim UNARMED
        special_attack BUBBLE, BERSERK, NO_DMG
        metamorph 17, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_SUPLEX
        elem_absorb {ICE, LIGHTNING, POISON, WIND, EARTH, WATER}
        elem_weak FIRE
        immune_status1 {BLIND, POISON, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, BERSERK, CONFUSE}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 251: VETERAN
        monster_prop VETERAN
        speed 30
        attack_power 11
        defense 110
        mag_def 145
        mag_pwr 17
        hp 10000
        mp 300
        exp 2820
        level 51
        attack_anim UNARMED
        special_attack RED_STAB, DMG_250_PCT
        metamorph 23, 4
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, CANT_SUPLEX}
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL}
        end_monster_prop

; ------------------------------------------------------------------------------

; 252: SKY_BASE
        monster_prop SKY_BASE
        speed 35
        attack_power 10
        defense 140
        mag_def 140
        mag_pwr 5
        hp 6000
        mp 550
        exp 2300
        gil 670
        level 52
        attack_anim UNARMED
        special_attack LIGHT_BEAM, STOP, NO_DMG
        metamorph 4, 3
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 253: IRONHITMAN
        monster_prop IRONHITMAN
        speed 31
        attack_power 13
        defense 20
        mag_def 165
        mag_pwr 25
        hp 2000
        mp 800
        exp 2000
        gil 700
        level 52
        attack_anim UNARMED
        special_attack LIGHTNING, DMG_200_PCT
        metamorph 4, 3
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 254: IO
        monster_prop IO
        speed 60
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 10
        hp 7862
        mp 1550
        exp 3253
        gil 1995
        level 39
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 5, 4
        elem_null {POISON, WIND, EARTH}
        elem_weak {LIGHTNING, HOLY, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP}
        immune_status2 {NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 255: PUGS
        monster_prop PUGS
        speed 70
        attack_power 5
        evade 150
        defense 100
        mag_def 150
        mag_pwr 1
        hp 14001
        mp 11000
        level 99
        attack_anim DIRK
        special_attack VERT_SLASH, DMG_800_PCT
        metamorph 7, 4
        monster_flags IMP_DMG_BONUS
        monster_status {HARDER_TO_RUN, CANT_ESCAPE}
        elem_absorb WATER
        elem_weak FIRE
        immune_status1 {PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 256: WHELK
        monster_prop WHELK
        speed 25
        attack_power 13
        defense 102
        mag_def 155
        mag_pwr 5
        hp 50000
        mp 120
        level 4
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_400_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 257: PRESENTER
        monster_prop PRESENTER
        speed 30
        attack_power 53
        defense 160
        mag_def 195
        mag_pwr 10
        hp 9230
        mp 1600
        gil 1000
        level 19
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {ICE, LIGHTNING, WATER}
        elem_weak FIRE
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, IMP}
        immune_status2 {NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 258: MEGA_ARMOR
        monster_prop MEGA_ARMOR
        speed 45
        attack_power 19
        defense 120
        mag_def 100
        mag_pwr 10
        hp 1000
        mp 50
        exp 350
        level 21
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 259: VARGAS
        monster_prop VARGAS
        speed 30
        attack_power 13
        defense 85
        mag_def 150
        mag_pwr 10
        hp 11600
        mp 220
        level 12
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, CONDEMNED, CANT_MISS
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak POISON
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 260: TUNNELARMR
        monster_prop TUNNELARMR
        speed 40
        attack_power 10
        defense 29
        mag_def 145
        mag_pwr 15
        hp 1300
        mp 900
        gil 250
        level 16
        attack_anim UNARMED
        special_attack DRILL, DMG_200_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 261: PROMETHEUS
        monster_prop PROMETHEUS
        speed 47
        attack_power 13
        defense 170
        mag_def 150
        mag_pwr 10
        hp 14500
        mp 2050
        exp 5200
        gil 1300
        level 56
        attack_anim UNARMED
        special_attack DRILL, DMG_150_PCT
        metamorph 0, 7
        monster_status HARDER_TO_RUN
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 262: GHOSTTRAIN
        monster_prop GHOSTTRAIN
        speed 30
        attack_power 10
        defense 30
        mag_def 210
        mag_pwr 5
        hp 1900
        mp 350
        level 14
        attack_anim UNARMED
        special_attack WHEEL, DMG_200_PCT
        metamorph 0, 7
        monster_flags UNDEAD
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb POISON
        elem_weak {FIRE, LIGHTNING, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 263: DADALUMA
        monster_prop DADALUMA
        speed 30
        attack_power 12
        mblock 10
        defense 85
        mag_def 143
        mag_pwr 3
        hp 3270
        mp 1005
        gil 1210
        level 22
        attack_anim UNARMED
        special_attack ARC_SLASH, SAP
        metamorph 0, 7
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status {HARDER_TO_RUN, CANT_ESCAPE}
        elem_weak POISON
        immune_status1 {ZOMBIE, POISON, DEAD}
        immune_status2 {NEAR_FATAL, BERSERK, CONFUSE, SAP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 264: SHIVA
        monster_prop SHIVA
        speed 35
        attack_power 15
        hit_rate 150
        evade 20
        defense 200
        mag_def 110
        mag_pwr 7
        hp 3000
        mp 500
        level 21
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_null {LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 265: IFRIT
        monster_prop IFRIT
        speed 35
        attack_power 25
        hit_rate 150
        evade 20
        defense 215
        mag_def 115
        mag_pwr 7
        hp 3300
        mp 600
        level 21
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_null {LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        elem_weak ICE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 266: NUMBER_024
        monster_prop NUMBER_024
        speed 40
        attack_power 20
        defense 170
        mag_def 100
        mag_pwr 3
        hp 4777
        mp 777
        level 24
        attack_anim RUNE_EDGE
        special_attack MULTI_PUNCH, CONFUSE, NO_DMG
        metamorph 0, 7
        monster_flags {DIE_AT_0_MP, HUMAN, IMP_DMG_BONUS}
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, CANT_CONTROL}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 267: NUMBER_128
        monster_prop NUMBER_128
        speed 30
        attack_power 13
        defense 120
        mag_def 125
        mag_pwr 3
        hp 3276
        mp 810
        level 23
        attack_anim RUNE_EDGE
        special_attack ARC_SLASH, DRAIN_HP
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, IMAGE, SILENCE, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 268: INFERNO
        monster_prop INFERNO
        speed 45
        attack_power 13
        defense 130
        mag_def 145
        mag_pwr 10
        hp 30800
        mp 9700
        level 67
        attack_anim RUNE_EDGE
        special_attack ARC_SLASH, DMG_300_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_weak LIGHTNING
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 269: CRANE_1
        monster_prop CRANE_1
        speed 35
        attack_power 14
        defense 145
        mag_def 120
        mag_pwr 4
        hp 1800
        mp 447
        level 23
        attack_anim PARTISAN
        special_attack BLACK_BALL, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak WATER
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 270: CRANE_2
        monster_prop CRANE_2
        speed 30
        attack_power 14
        defense 125
        mag_def 120
        mag_pwr 4
        hp 2300
        mp 447
        level 24
        attack_anim PARTISAN
        special_attack BLACK_BALL, DMG_200_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 271: UMARO_1
        monster_prop UMARO_1
        speed 30
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 1000
        mp 150
        level 14
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_weak {FIRE, POISON}
        immune_status1 {ZOMBIE, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, CONFUSE, SAP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 272: UMARO_2
        monster_prop UMARO_2
        speed 45
        attack_power 25
        defense 100
        mag_def 150
        mag_pwr 11
        hp 17200
        mp 6990
        gil 10
        level 33
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_weak {FIRE, POISON}
        immune_status1 {ZOMBIE, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, CONFUSE, SAP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 273: GUARDIAN_VECTOR
        monster_prop GUARDIAN_VECTOR
        speed 50
        attack_power 250
        evade 50
        mblock 50
        defense 235
        mag_def 185
        mag_pwr 10
        hp 50000
        mp 5000
        level 71
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 274: GUARDIAN_BOSS
        monster_prop GUARDIAN_BOSS
        speed 80
        attack_power 13
        defense 150
        mag_def 150
        mag_pwr 25
        hp 60000
        mp 5200
        level 67
        attack_anim UNARMED
        special_attack BLACK_CLOUD, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, CANT_CONTROL}
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 275: AIR_FORCE
        monster_prop AIR_FORCE
        speed 35
        attack_power 10
        defense 150
        mag_def 120
        mag_pwr 12
        hp 8000
        mp 750
        level 25
        attack_anim TRIDENT
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 276: TRITOCH_INTRO
        monster_prop TRITOCH_INTRO
        speed 30
        attack_power 13
        defense 100
        mag_def 155
        mag_pwr 10
        hp 12000
        mp 600
        level 19
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 277: TRITOCH_MORPH
        monster_prop TRITOCH_MORPH
        speed 30
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 12000
        mp 12000
        level 19
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 278: FLAMEEATER
        monster_prop FLAMEEATER
        speed 34
        attack_power 13
        hit_rate 130
        evade 20
        defense 105
        mag_def 150
        mag_pwr 7
        hp 8400
        mp 480
        level 26
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_null {LIGHTNING, POISON, HOLY, EARTH}
        elem_weak ICE
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 279: ATMAWEAPON
        monster_prop ATMAWEAPON
        speed 67
        attack_power 45
        evade 20
        mblock 10
        defense 142
        mag_def 97
        mag_pwr 5
        hp 24000
        mp 5000
        level 37
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 {ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 STOP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 280: NERAPA
        monster_prop NERAPA
        speed 48
        attack_power 11
        defense 105
        mag_def 150
        mag_pwr 10
        hp 2800
        mp 280
        level 26
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_null {POISON, WIND, EARTH, WATER}
        elem_weak {ICE, LIGHTNING, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, IMAGE, SILENCE, SAP, SLEEP}
        immune_status3 SLOW
        apply_status3 {FLYING, REFLECT}
        end_monster_prop

; ------------------------------------------------------------------------------

; 281: SRBEHEMOTH
        monster_prop SRBEHEMOTH
        speed 60
        attack_power 11
        defense 120
        mag_def 130
        mag_pwr 9
        hp 19000
        mp 1600
        level 43
        attack_anim UNARMED
        special_attack DIAG_CLAW, REMOVE_REFLECT, CANT_MISS
        metamorph 0, 7
        monster_flags IMP_DMG_BONUS
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, CANT_CONTROL}
        elem_absorb ICE
        elem_weak {FIRE, POISON}
        immune_status1 {ZOMBIE, POISON, MAGITEK, PETRIFY, DEAD}
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 282: KEFKA_1
        monster_prop KEFKA_1
        speed 65
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 63001
        mp 60000
        level 83
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 283: TENTACLE
        monster_prop TENTACLE
        speed 25
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 8
        hp 7000
        mp 800
        level 31
        attack_anim MAGICAL_BRSH
        special_attack BLUE_STAB_2, SLOW, NO_DMG
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {ZOMBIE, MAGITEK, VANISH, IMP, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE, SAP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 284: DULLAHAN
        monster_prop DULLAHAN
        speed 55
        attack_power 55
        hit_rate 150
        evade 10
        defense 130
        mag_def 160
        mag_pwr 7
        hp 23450
        mp 1721
        level 37
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_200_PCT
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 STOP
        apply_status3 {FLYING, HASTE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 285: DOOM_GAZE
        monster_prop DOOM_GAZE
        speed 95
        attack_power 35
        hit_rate 150
        evade 30
        mblock 30
        defense 150
        mag_def 170
        mag_pwr 8
        hp 55555
        mp 38000
        level 68
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, POISON, NO_DMG
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {CANT_SUPLEX, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {ICE, POISON}
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 {FLYING, SHELL, SAFE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 286: CHADARNOOK_1
        monster_prop CHADARNOOK_1
        speed 50
        attack_power 13
        defense 140
        mag_def 150
        mag_pwr 10
        hp 56000
        mp 9400
        level 37
        attack_anim MAGICAL_BRSH
        special_attack HEART, CONDEMNED, NO_DMG
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {HOLY, WATER}
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 287: CURLEY
        monster_prop CURLEY
        speed 35
        attack_power 1
        defense 100
        mag_def 110
        mag_pwr 4
        hp 15000
        mp 2000
        level 47
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 0, 7
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 288: LARRY
        monster_prop LARRY
        speed 30
        attack_power 2
        defense 90
        mag_def 120
        mag_pwr 5
        hp 10000
        mp 2000
        level 47
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {ICE, WIND}
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, BERSERK, SAP, SLEEP}
        immune_status3 STOP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 289: MOE
        monster_prop MOE
        speed 25
        attack_power 4
        defense 80
        mag_def 130
        mag_pwr 6
        hp 12500
        mp 2000
        level 47
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 0, 7
        monster_flags {DIE_AT_0_MP, HUMAN, IMP_DMG_BONUS}
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, CONFUSE, SAP, SLEEP}
        immune_status3 SLOW
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 290: WREXSOUL
        monster_prop WREXSOUL
        speed 40
        attack_power 27
        defense 70
        mag_def 220
        mag_pwr 5
        hp 23066
        mp 5066
        level 53
        attack_anim UNARMED
        special_attack ARC_SLASH, CONDEMNED, NO_DMG
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {FIRE, HOLY}
        elem_weak ICE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 291: HIDON
        monster_prop HIDON
        speed 55
        attack_power 13
        defense 110
        mag_def 160
        mag_pwr 10
        hp 25000
        mp 12500
        level 43
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags UNDEAD
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb POISON
        elem_weak {FIRE, HOLY, EARTH}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 292: KATANASOUL
        monster_prop KATANASOUL
        speed 75
        attack_power 25
        hit_rate 130
        evade 20
        defense 115
        mag_def 175
        mag_pwr 11
        hp 37620
        mp 7400
        gil 30000
        level 61
        attack_anim FORGED
        special_attack SKULL_SLASH, DEAD, NO_DMG
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {SPECIAL_EVENT, CANT_CONTROL}
        elem_weak POISON
        immune_status1 {ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 293: L30_MAGIC
        monster_prop L30_MAGIC
        speed 36
        attack_power 10
        evade 100
        defense 200
        mag_def 140
        mag_pwr 20
        hp 3000
        mp 700
        level 54
        attack_anim HARDENED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 0
        monster_flags DIE_AT_0_MP
        monster_status CANT_ESCAPE
        elem_absorb HOLY
        elem_weak POISON
        immune_status1 {BLIND, IMP}
        immune_status2 {SILENCE, CONFUSE}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 294: HIDONITE
        monster_prop HIDONITE
        speed 30
        attack_power 13
        defense 85
        mag_def 150
        mag_pwr 10
        hp 3500
        mp 1000
        level 43
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, POISON, NO_DMG
        metamorph 0, 7
        monster_status SPECIAL_EVENT
        elem_absorb POISON
        elem_weak EARTH
        immune_status1 {ZOMBIE, IMP}
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 295: DOOM
        monster_prop DOOM
        speed 61
        attack_power 60
        defense 110
        mag_def 160
        mag_pwr 9
        hp 63000
        mp 4800
        level 73
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_400_PCT, CANT_MISS
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {ICE, POISON}
        elem_weak HOLY
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 296: GODDESS
        monster_prop GODDESS
        speed 50
        attack_power 13
        defense 85
        mag_def 150
        mag_pwr 14
        hp 44000
        mp 19000
        level 68
        attack_anim MAGICAL_BRSH
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {LIGHTNING, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 {HASTE, SHELL}
        end_monster_prop

; ------------------------------------------------------------------------------

; 297: POLTRGEIST
        monster_prop POLTRGEIST
        speed 53
        attack_power 15
        defense 180
        mag_def 145
        mag_pwr 13
        hp 58000
        mp 18900
        level 67
        attack_anim FORGED
        special_attack VERT_SLASH, DMG_200_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {FIRE, WIND}
        elem_weak POISON
        immune_status1 {ZOMBIE, POISON, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 ALL
        apply_status2 IMAGE
        apply_status3 {FLYING, HASTE, SAFE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 298: FINAL_KEFKA
        monster_prop FINAL_KEFKA
        speed 72
        attack_power 80
        hit_rate 190
        evade 45
        defense 117
        mag_def 135
        mag_pwr 8
        hp 62000
        mp 38000
        level 71
        attack_anim UNARMED
        special_attack HORZ_CLAW, DMG_400_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_null POISON
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, HASTE, STOP, SHELL, SAFE, REFLECT}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 299: L40_MAGIC
        monster_prop L40_MAGIC
        speed 38
        attack_power 10
        evade 100
        defense 200
        mag_def 135
        mag_pwr 19
        hp 4000
        mp 1000
        level 55
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 2
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_ESCAPE
        elem_absorb POISON
        elem_weak LIGHTNING
        immune_status1 {BLIND, IMP, DEAD}
        immune_status2 {CONDEMNED, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 300: ULTROS_RIVER
        monster_prop ULTROS_RIVER
        speed 35
        attack_power 15
        defense 40
        mag_def 140
        mag_pwr 3
        hp 3000
        mp 640
        level 13
        attack_anim MAGICAL_BRSH
        special_attack BLACK_CLOUD, BLIND
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WATER
        elem_weak {FIRE, LIGHTNING}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 301: ULTROS_OPERA
        monster_prop ULTROS_OPERA
        speed 40
        attack_power 13
        defense 105
        mag_def 150
        mag_pwr 4
        hp 2550
        mp 500
        gil 2
        level 19
        attack_anim MAGICAL_BRSH
        special_attack BLACK_CLOUD, BLIND
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WATER
        elem_weak {FIRE, LIGHTNING}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 302: ULTROS_MOUNTAIN
        monster_prop ULTROS_MOUNTAIN
        speed 35
        attack_power 22
        defense 95
        mag_def 155
        mag_pwr 7
        hp 22000
        mp 750
        gil 3
        level 25
        attack_anim MAGICAL_BRSH
        special_attack BLACK_CLOUD, BLIND
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WATER
        elem_weak {FIRE, LIGHTNING}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 303: CHUPON_AIRSHIP
        monster_prop CHUPON_AIRSHIP
        speed 10
        attack_power 13
        defense 100
        mag_def 55
        mag_pwr 10
        hp 10000
        mp 40000
        level 26
        attack_anim DRAGON_CLAW
        special_attack MULTI_PUNCH, POISON, NO_DMG
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, CONFUSE, SAP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 304: L20_MAGIC
        monster_prop L20_MAGIC
        speed 35
        attack_power 10
        evade 100
        defense 200
        mag_def 145
        mag_pwr 21
        hp 2000
        mp 500
        level 51
        attack_anim FLAIL
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_ESCAPE
        elem_absorb POISON
        immune_status1 {IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        immune_status3 STOP
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 305: SIEGFRIED_2
        monster_prop SIEGFRIED_2
        speed 30
        attack_power 1
        defense 50
        mag_def 150
        mag_pwr 10
        hp 100
        mp 5
        gil 1
        level 7
        attack_anim FORGED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 306: L10_MAGIC
        monster_prop L10_MAGIC
        speed 33
        attack_power 10
        evade 100
        defense 200
        mag_def 150
        mag_pwr 22
        hp 1000
        mp 300
        level 48
        attack_anim ICE_ROD
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 0
        monster_flags {DIE_AT_0_MP, HUMAN, UNDEAD}
        monster_status {CANT_SUPLEX, CANT_ESCAPE}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {IMP, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 307: L50_MAGIC
        monster_prop L50_MAGIC
        speed 45
        attack_power 10
        evade 100
        defense 200
        mag_def 130
        mag_pwr 18
        hp 5000
        mp 2000
        level 57
        attack_anim ICE_ROD
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 3, 2
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status CANT_ESCAPE
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 308: HEAD
        monster_prop HEAD
        speed 45
        attack_power 22
        defense 100
        mag_def 155
        mag_pwr 10
        hp 1600
        mp 1000
        level 6
        attack_anim UNARMED
        special_attack BLOB_MAN, SLOW, NO_DMG
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 309: WHELK_HEAD
        monster_prop WHELK_HEAD
        speed 35
        attack_power 75
        defense 80
        mag_def 150
        mag_pwr 7
        hp 9845
        mp 1600
        gil 1000
        level 31
        attack_anim UNARMED
        special_attack ARC_SLASH, PETRIFY, NO_DMG
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {CANT_SUPLEX, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {ICE, LIGHTNING, WATER}
        elem_null POISON
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP}
        immune_status2 {NEAR_FATAL, IMAGE, BERSERK, CONFUSE, SAP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 310: COLOSSUS
        monster_prop COLOSSUS
        speed 73
        attack_power 10
        defense 125
        mag_def 125
        mag_pwr 10
        hp 18000
        mp 2000
        level 73
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak WIND
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 311: CZARDRAGON
        monster_prop CZARDRAGON
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 60001
        mp 60000
        level 83
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 312: MASTER_PUG
        monster_prop MASTER_PUG
        speed 45
        attack_power 13
        defense 100
        mag_def 165
        mag_pwr 9
        hp 22000
        mp 1200
        level 73
        attack_anim DIRK
        special_attack VERT_SLASH, DMG_800_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WATER
        immune_status1 {ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 313: L60_MAGIC
        monster_prop L60_MAGIC
        speed 35
        attack_power 10
        evade 100
        defense 200
        mag_def 125
        mag_pwr 17
        hp 6000
        mp 5000
        level 58
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 17, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_weak FIRE
        immune_status1 {BLIND, POISON, IMP, DEAD}
        immune_status2 {CONDEMNED, BERSERK, CONFUSE}
        immune_status3 STOP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 314: MERCHANT
        monster_prop MERCHANT
        speed 30
        attack_power 10
        defense 50
        mag_def 150
        mag_pwr 10
        hp 119
        mp 20
        exp 26
        gil 60
        level 5
        attack_anim DIRK
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 315: B_DAY_SUIT
        monster_prop B_DAY_SUIT
        speed 30
        attack_power 13
        defense 5
        mag_def 150
        mag_pwr 10
        hp 100
        mp 100
        exp 18
        gil 54
        level 6
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak POISON
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 316: TENTACLE_1
        monster_prop TENTACLE_1
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 8
        hp 6000
        mp 700
        level 32
        attack_anim MAGICAL_BRSH
        special_attack BLUE_STAB_2, SLOW, NO_DMG
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {ICE, WATER}
        elem_weak FIRE
        immune_status1 {ZOMBIE, MAGITEK, VANISH, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 317: TENTACLE_2
        monster_prop TENTACLE_2
        speed 35
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 8
        hp 5000
        mp 600
        level 33
        attack_anim MAGICAL_BRSH
        special_attack BLUE_STAB_2, SLOW, NO_DMG
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {LIGHTNING, WATER}
        immune_status1 {ZOMBIE, MAGITEK, VANISH, IMP, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE, SAP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 318: TENTACLE_3
        monster_prop TENTACLE_3
        speed 40
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 8
        hp 4000
        mp 500
        level 34
        attack_anim MAGICAL_BRSH
        special_attack BLUE_STAB_2, SLOW, NO_DMG
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {EARTH, WATER}
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP, DEAD}
        immune_status2 {CONDEMNED, SILENCE, BERSERK, CONFUSE, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 319: RIGHTBLADE
        monster_prop RIGHTBLADE
        speed 30
        attack_power 20
        defense 120
        mag_def 150
        mag_pwr 5
        hp 400
        mp 150
        level 21
        attack_anim ICE_ROD
        special_attack LARGE_PIERCE, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP}
        immune_status2 {IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 320: LEFT_BLADE
        monster_prop LEFT_BLADE
        speed 30
        attack_power 13
        defense 120
        mag_def 150
        mag_pwr 5
        hp 700
        mp 470
        level 22
        attack_anim RUNE_EDGE
        special_attack THICK_HORZ_SLASH, DMG_200_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP}
        immune_status2 {IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 321: ROUGH
        monster_prop ROUGH
        speed 30
        attack_power 13
        defense 80
        mag_def 190
        mag_pwr 10
        hp 8000
        mp 770
        level 69
        attack_anim ICE_ROD
        special_attack LARGE_PIERCE, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak ICE
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP}
        immune_status2 {IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 322: STRIKER
        monster_prop STRIKER
        speed 26
        attack_power 13
        defense 75
        mag_def 185
        mag_pwr 7
        hp 11000
        mp 2600
        level 67
        attack_anim RUNE_EDGE
        special_attack THICK_HORZ_SLASH, DMG_200_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_weak FIRE
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP}
        immune_status2 {IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 323: L70_MAGIC
        monster_prop L70_MAGIC
        speed 40
        attack_power 10
        evade 100
        defense 200
        mag_def 120
        mag_pwr 16
        hp 7000
        mp 3000
        level 56
        attack_anim HARDENED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 14, 3
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_ESCAPE
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {POISON, IMP}
        immune_status2 {NEAR_FATAL, BERSERK, CONFUSE, SLEEP}
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 324: TRITOCH_BOSS
        monster_prop TRITOCH_BOSS
        speed 40
        attack_power 19
        defense 254
        mag_def 70
        mag_pwr 4
        hp 30000
        mp 50000
        level 62
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_null {LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        elem_weak FIRE
        immune_status1 {POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 325: LASER_GUN
        monster_prop LASER_GUN
        speed 30
        attack_power 12
        defense 130
        mag_def 140
        mag_pwr 9
        hp 3300
        mp 335
        level 24
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT}
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 326: SPECK
        monster_prop SPECK
        speed 15
        attack_power 12
        defense 230
        mag_def 160
        mag_pwr 10
        hp 420
        mp 285
        level 25
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        retal_flags MONSTER_RUNIC
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 327: MISSILEBAY
        monster_prop MISSILEBAY
        speed 20
        attack_power 12
        defense 135
        mag_def 150
        mag_pwr 8
        hp 3000
        mp 7000
        level 25
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT}
        elem_weak {LIGHTNING, WATER}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 328: CHADARNOOK_2
        monster_prop CHADARNOOK_2
        speed 61
        attack_power 18
        defense 135
        mag_def 130
        mag_pwr 10
        hp 30000
        mp 7600
        level 41
        attack_anim UNARMED
        special_attack MULTI_PUNCH, CONDEMNED, NO_DMG
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak {FIRE, HOLY}
        immune_status1 {ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 329: ICE_DRAGON
        monster_prop ICE_DRAGON
        speed 60
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 10
        hp 24400
        mp 9000
        level 74
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 6, 4
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_weak FIRE
        immune_status1 {ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {NEAR_FATAL, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 330: KEFKA_NARSHE
        monster_prop KEFKA_NARSHE
        speed 45
        attack_power 25
        evade 30
        mblock 30
        defense 55
        mag_def 160
        mag_pwr 9
        hp 3000
        mp 3000
        level 18
        attack_anim DIRK
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 331: STORM_DRGN
        monster_prop STORM_DRGN
        speed 65
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 9
        hp 42000
        mp 1250
        level 74
        attack_anim DRAGON_CLAW
        special_attack RED_STAB, DMG_300_PCT
        metamorph 6, 4
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WIND
        elem_weak LIGHTNING
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 332: DIRT_DRGN
        monster_prop DIRT_DRGN
        speed 55
        attack_power 23
        defense 110
        mag_def 150
        mag_pwr 12
        hp 28500
        mp 16500
        level 53
        attack_anim DRAGON_CLAW
        special_attack HORZ_CLAW, DMG_500_PCT
        metamorph 6, 4
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak {WIND, WATER}
        immune_status1 {ZOMBIE, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP}
        immune_status3 STOP
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 333: IPOOH
        monster_prop IPOOH
        speed 35
        attack_power 18
        defense 105
        mag_def 150
        mag_pwr 10
        hp 360
        mp 60
        level 11
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, DMG_150_PCT
        metamorph 0, 7
        monster_flags IMP_DMG_BONUS
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, BERSERK, CONFUSE, SAP, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 334: LEADER
        monster_prop LEADER
        speed 35
        attack_power 18
        defense 5
        mag_def 110
        mag_pwr 10
        hp 456
        mp 20
        gil 50
        level 12
        attack_anim FORGED
        special_attack VERT_SLASH, DMG_150_PCT
        metamorph 0, 7
        monster_flags {HUMAN, IMP_DMG_BONUS}
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 335: GRUNT
        monster_prop GRUNT
        speed 35
        attack_power 11
        defense 50
        mag_def 150
        mag_pwr 10
        hp 100
        mp 10
        gil 48
        level 12
        attack_anim RUNE_EDGE
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        end_monster_prop

; ------------------------------------------------------------------------------

; 336: GOLD_DRGN
        monster_prop GOLD_DRGN
        speed 75
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 10
        hp 32400
        mp 4000
        level 62
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_400_PCT
        metamorph 6, 4
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak WATER
        immune_status1 {ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 337: SKULL_DRGN
        monster_prop SKULL_DRGN
        speed 57
        attack_power 15
        defense 140
        mag_def 120
        mag_pwr 10
        hp 32800
        mp 1999
        level 62
        attack_anim PARTISAN
        ; *** bug ***
        ; invalid special attack value. this bug has no effect because
        ; skull dragon never uses its special attack
        _monster_prop_special_attack .set $ff
        metamorph 6, 4
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 338: BLUE_DRGN
        monster_prop BLUE_DRGN
        speed 75
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 10
        hp 26900
        mp 3800
        level 65
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DRAIN_MP
        metamorph 6, 4
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WATER
        elem_weak LIGHTNING
        immune_status1 {ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 339: RED_DRAGON
        monster_prop RED_DRAGON
        speed 75
        attack_power 13
        defense 110
        mag_def 150
        mag_pwr 10
        hp 30000
        mp 1780
        level 67
        attack_anim UNARMED
        special_attack LIGHT_BEAM, REMOVE_REFLECT, CANT_MISS
        metamorph 6, 4
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb FIRE
        elem_weak {ICE, WATER}
        immune_status1 {ZOMBIE, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 340: PIRANHA
        monster_prop PIRANHA
        speed 30
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 10
        mp 60
        level 9
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        retal_flags PIRANHA
        elem_weak LIGHTNING
        immune_status1 {ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 341: RIZOPAS
        monster_prop RIZOPAS
        speed 40
        attack_power 14
        defense 110
        mag_def 175
        mag_pwr 3
        hp 775
        mp 39
        level 13
        attack_anim UNARMED
        special_attack SMALL_PIERCE, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WATER
        elem_weak LIGHTNING
        immune_status1 {ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, SILENCE}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 342: SPECTER
        monster_prop SPECTER
        speed 40
        attack_power 15
        defense 120
        mag_def 180
        mag_pwr 8
        hp 1500
        mp 10000
        level 19
        attack_anim PARTISAN
        special_attack LIGHTNING, DMG_200_PCT
        metamorph 0, 7
        monster_flags {DIE_AT_0_MP, UNDEAD}
        monster_status {CANT_ESCAPE, CANT_CONTROL}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, IMP}
        immune_status2 {BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 343: SHORT_ARM
        monster_prop SHORT_ARM
        speed 37
        attack_power 50
        evade 10
        defense 115
        mag_def 155
        mag_pwr 10
        hp 27000
        mp 10000
        level 73
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, CANT_CONTROL}
        elem_weak WATER
        immune_status1 ALL
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, CONFUSE, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 344: LONG_ARM
        monster_prop LONG_ARM
        speed 39
        attack_power 35
        evade 5
        defense 110
        mag_def 150
        mag_pwr 30
        hp 33000
        mp 10000
        level 73
        attack_anim UNARMED
        special_attack DIAG_CLAW, DRAIN_HP
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, CANT_CONTROL}
        elem_weak WIND
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP}
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, SILENCE, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 345: FACE
        monster_prop FACE
        speed 44
        attack_power 63
        evade 10
        defense 140
        mag_def 140
        mag_pwr 12
        hp 30000
        mp 10000
        level 74
        attack_anim PARTISAN
        special_attack LARGE_PIERCE, SAP, NO_DMG
        metamorph 0, 7
        monster_flags {HIDE_NAME, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, CANT_CONTROL}
        elem_null EARTH
        elem_weak FIRE
        immune_status1 {ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 346: TIGER
        monster_prop TIGER
        speed 21
        attack_power 13
        defense 120
        mag_def 153
        mag_pwr 7
        hp 30000
        mp 10000
        level 70
        attack_anim RUNE_EDGE
        special_attack HORZ_CLAW, ZOMBIE, NO_DMG
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb EARTH
        elem_weak ICE
        immune_status1 {BLIND, ZOMBIE, MAGITEK, VANISH, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 347: TOOLS
        monster_prop TOOLS
        speed 29
        attack_power 13
        defense 105
        mag_def 153
        mag_pwr 10
        hp 24000
        mp 10000
        level 73
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak LIGHTNING
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, VANISH, IMP, PETRIFY}
        immune_status2 {NEAR_FATAL, IMAGE, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {FLYING, REGEN, HASTE, SHELL, SAFE, REFLECT}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 348: MAGIC
        monster_prop MAGIC
        speed 35
        attack_power 1
        defense 145
        mag_def 125
        mag_pwr 8
        hp 41000
        mp 10000
        level 72
        attack_anim DIRK
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags {HIDE_NAME, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak EARTH
        immune_status1 ALL
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {FLYING, REGEN, SLOW, HASTE, STOP, SHELL, SAFE, REFLECT}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 349: HIT
        monster_prop HIT
        speed 33
        attack_power 6
        defense 115
        mag_def 153
        mag_pwr 9
        hp 28000
        mp 10000
        level 73
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags {HIDE_NAME, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak POISON
        immune_status1 ALL
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, SILENCE, CONFUSE, SAP, SLEEP}
        immune_status3 {FLYING, REGEN, HASTE, SHELL, SAFE, REFLECT}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 350: GIRL
        monster_prop GIRL
        speed 41
        attack_power 73
        defense 150
        mag_def 155
        mag_pwr 9
        hp 9999
        mp 10000
        level 58
        attack_anim HARDENED
        special_attack HEART, SLEEP, NO_DMG
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {FIRE, ICE, LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        elem_weak {FIRE, ICE, LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {FLYING, REGEN, SLOW, HASTE, STOP, SHELL, SAFE, REFLECT}
        apply_status3 {FLYING, REGEN}
        end_monster_prop

; ------------------------------------------------------------------------------

; 351: SLEEP
        monster_prop SLEEP
        speed 46
        attack_power 63
        defense 140
        mag_def 120
        mag_pwr 6
        hp 40000
        mp 10000
        level 71
        attack_anim ICE_ROD
        special_attack LIGHT_BEAM, DEAD, NO_DMG
        metamorph 0, 7
        monster_flags {HIDE_NAME, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        immune_status3 {SLOW, HASTE, STOP, SHELL, SAFE}
        apply_status3 FLYING
        end_monster_prop

; ------------------------------------------------------------------------------

; 352: HIDONITE_1
        monster_prop HIDONITE_1
        speed 30
        attack_power 13
        defense 115
        mag_def 120
        mag_pwr 10
        hp 3500
        mp 1000
        level 43
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, CONFUSE, NO_DMG
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        elem_absorb {FIRE, ICE, LIGHTNING, POISON, WIND, HOLY, WATER}
        immune_status1 {IMP, DEAD}
        immune_status2 {CONDEMNED, SILENCE, CONFUSE, SLEEP}
        immune_status3 {SLOW, STOP}
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 353: HIDONITE_2
        monster_prop HIDONITE_2
        speed 30
        attack_power 13
        defense 105
        mag_def 130
        mag_pwr 10
        hp 3500
        mp 1000
        level 43
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, ZOMBIE, NO_DMG
        metamorph 0, 7
        monster_flags UNDEAD
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb POISON
        elem_weak {FIRE, HOLY}
        immune_status1 {BLIND, ZOMBIE, POISON, IMP, PETRIFY}
        immune_status2 {SILENCE, BERSERK, SLEEP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 354: HIDONITE_3
        monster_prop HIDONITE_3
        speed 30
        attack_power 13
        defense 95
        mag_def 140
        mag_pwr 10
        hp 3500
        mp 1000
        level 43
        attack_anim DRAGON_CLAW
        special_attack DIAG_CLAW, DMG_400_PCT
        metamorph 0, 7
        monster_flags IMP_DMG_BONUS
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_weak {FIRE, ICE, LIGHTNING, POISON, WIND, HOLY, EARTH, WATER}
        immune_status1 {ZOMBIE, IMP, PETRIFY}
        immune_status2 NEAR_FATAL
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 355: L80_MAGIC
        monster_prop L80_MAGIC
        speed 37
        attack_power 10
        evade 100
        defense 200
        mag_def 115
        mag_pwr 15
        hp 8000
        mp 2800
        level 53
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 19, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status CANT_ESCAPE
        elem_weak POISON
        immune_status1 IMP
        immune_status2 {SILENCE, BERSERK, CONFUSE}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 356: L90_MAGIC
        monster_prop L90_MAGIC
        speed 38
        attack_power 10
        evade 100
        defense 200
        mag_def 110
        mag_pwr 14
        hp 9000
        mp 9000
        level 55
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 17, 4
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status {CANT_SUPLEX, CANT_ESCAPE}
        elem_absorb WIND
        elem_null {HOLY, EARTH, WATER}
        immune_status1 {IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, SLEEP}
        apply_status3 REFLECT
        end_monster_prop

; ------------------------------------------------------------------------------

; 357: PROTOARMOR
        monster_prop PROTOARMOR
        speed 30
        attack_power 12
        defense 230
        mag_def 110
        mag_pwr 7
        hp 670
        mp 125
        exp 499
        gil 296
        level 19
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 6, 4
        elem_weak LIGHTNING
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY}
        immune_status2 SAP
        end_monster_prop

; ------------------------------------------------------------------------------

; 358: MAGIMASTER
        monster_prop MAGIMASTER
        speed 90
        attack_power 1
        evade 100
        defense 250
        mag_def 100
        mag_pwr 25
        hp 50000
        mp 50000
        level 68
        attack_anim TRIDENT
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags {DIE_AT_0_MP, HUMAN}
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, SILENCE, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 359: SOULSAVER
        monster_prop SOULSAVER
        speed 15
        attack_power 50
        defense 150
        mag_def 175
        mag_pwr 3
        hp 3066
        mp 566
        level 41
        attack_anim ICE_ROD
        special_attack LIGHT_BEAM, DRAIN_MP
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {CANT_ESCAPE, CANT_CONTROL}
        elem_absorb {FIRE, HOLY}
        elem_weak ICE
        immune_status1 {POISON, IMP}
        immune_status2 {SILENCE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 360: ULTROS_AIRSHIP
        monster_prop ULTROS_AIRSHIP
        speed 30
        attack_power 10
        defense 20
        mag_def 10
        mag_pwr 3
        hp 17000
        mp 8000
        level 26
        attack_anim MAGICAL_BRSH
        special_attack BLACK_CLOUD, BLIND
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb WATER
        elem_weak {FIRE, POISON}
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 361: NAUGHTY
        monster_prop NAUGHTY
        speed 48
        attack_power 11
        defense 115
        mag_def 145
        mag_pwr 10
        hp 3000
        mp 195
        level 24
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_200_PCT
        metamorph 0, 7
        monster_flags {DIE_AT_0_MP, HUMAN, IMP_DMG_BONUS}
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_CONTROL}
        elem_absorb ICE
        elem_null {POISON, WIND, EARTH, WATER}
        elem_weak {FIRE, LIGHTNING, HOLY}
        immune_status1 DEAD
        immune_status2 {CONDEMNED, NEAR_FATAL, IMAGE, BERSERK, CONFUSE, SAP}
        immune_status3 {SLOW, STOP}
        apply_status3 {FLYING, SAFE}
        end_monster_prop

; ------------------------------------------------------------------------------

; 362: PHUNBABA_1
        monster_prop PHUNBABA_1
        speed 30
        attack_power 53
        defense 102
        mag_def 153
        mag_pwr 10
        hp 60000
        mp 10000
        level 26
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 0, 7
        monster_flags IMP_DMG_BONUS
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak POISON
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 363: PHUNBABA_2
        monster_prop PHUNBABA_2
        speed 30
        attack_power 15
        defense 105
        mag_def 150
        mag_pwr 6
        hp 28000
        mp 10000
        level 31
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 0, 7
        monster_flags IMP_DMG_BONUS
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak POISON
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 364: PHUNBABA_3
        monster_prop PHUNBABA_3
        speed 30
        attack_power 15
        defense 105
        mag_def 150
        mag_pwr 6
        hp 26000
        mp 10000
        level 31
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 0, 7
        monster_flags IMP_DMG_BONUS
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak POISON
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 365: PHUNBABA_4
        monster_prop PHUNBABA_4
        speed 35
        attack_power 15
        defense 100
        mag_def 130
        mag_pwr 6
        hp 26000
        mp 10000
        level 31
        attack_anim UNARMED
        special_attack SINGLE_PUNCH, DMG_300_PCT
        metamorph 0, 7
        monster_flags IMP_DMG_BONUS
        monster_status {HARDER_TO_RUN, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb LIGHTNING
        elem_weak POISON
        immune_status1 {ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SAP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 366: TERRA_FLASHBACK
        monster_prop TERRA_FLASHBACK
        speed 30
        attack_power 13
        defense 100
        mag_def 105
        mag_pwr 10
        hp 35
        mp 0
        level 5
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 367: KEFKA_IMP_CAMP
        monster_prop KEFKA_IMP_CAMP
        speed 30
        attack_power 13
        defense 102
        mag_def 150
        mag_pwr 10
        hp 1001
        mp 0
        level 11
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 368: CYAN_IMP_CAMP
        monster_prop CYAN_IMP_CAMP
        speed 30
        attack_power 25
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1001
        mp 0
        level 11
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 369: ZONE_EATER
        monster_prop ZONE_EATER
        speed 60
        attack_power 23
        defense 120
        mag_def 150
        mag_pwr 10
        hp 7700
        mp 57000
        exp 2000
        gil 2000
        level 61
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {CANT_SUPLEX, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb ICE
        elem_null {FIRE, LIGHTNING, POISON, WIND, EARTH, WATER}
        elem_weak HOLY
        immune_status1 {BLIND, ZOMBIE, POISON, MAGITEK, IMP, PETRIFY, DEAD}
        immune_status2 ALL
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 370: GAU_VELDT
        monster_prop GAU_VELDT
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1001
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 371: KEFKA_VS_LEO
        monster_prop KEFKA_VS_LEO
        speed 30
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 5001
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 372: KEFKA_ESPER_GATE
        monster_prop KEFKA_ESPER_GATE
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 373: OFFICER
        monster_prop OFFICER
        speed 30
        attack_power 13
        defense 100
        mag_def 150
        mag_pwr 10
        hp 102
        mp 25
        exp 33
        gil 66
        level 7
        attack_anim RUNE_EDGE
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_weak POISON
        immune_status1 {POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, BERSERK, CONFUSE, SAP, SLEEP}
        immune_status3 {SLOW, STOP}
        end_monster_prop

; ------------------------------------------------------------------------------

; 374: CADET
        monster_prop CADET
        speed 30
        attack_power 13
        defense 80
        mag_def 140
        mag_pwr 10
        hp 380
        mp 48
        gil 144
        level 13
        attack_anim TRIDENT
        special_attack VERT_SLASH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HUMAN
        monster_status CANT_ESCAPE
        elem_weak POISON
        apply_status3 SAFE
        end_monster_prop

; ------------------------------------------------------------------------------

; 375: MONSTER_0177
        monster_prop MONSTER_0177
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 376: MONSTER_0178
        monster_prop MONSTER_0178
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 377: SOLDIER_FLASHBACK
        monster_prop SOLDIER_FLASHBACK
        speed 1
        attack_power 1
        hit_rate 1
        defense 1
        mag_def 1
        mag_pwr 1
        hp 1
        mp 50
        level 2
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        apply_status2 SLEEP
        apply_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 378: KEFKA_GENJU_MAGICITE
        monster_prop KEFKA_GENJU_MAGICITE
        speed 30
        attack_power 1
        defense 102
        mag_def 153
        mag_pwr 1
        hp 50001
        mp 10000
        level 2
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 379: EVENT
        monster_prop EVENT
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags HIDE_NAME
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 380: MONSTER_017C
        monster_prop MONSTER_017C
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 381: ATMA
        monster_prop ATMA
        speed 63
        attack_power 20
        defense 75
        mag_def 70
        mag_pwr 10
        hp 55000
        mp 19000
        level 67
        attack_anim UNARMED
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_flags DIE_AT_0_MP
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, SPECIAL_EVENT, CANT_CONTROL}
        elem_absorb {POISON, WIND, HOLY, EARTH, WATER}
        immune_status1 {ZOMBIE, POISON, IMP, PETRIFY, DEAD}
        immune_status2 {CONDEMNED, NEAR_FATAL, SILENCE, BERSERK, CONFUSE, SLEEP}
        immune_status3 STOP
        end_monster_prop

; ------------------------------------------------------------------------------

; 382: SHADOW_COLOSSEUM
        monster_prop SHADOW_COLOSSEUM
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1
        mp 1000
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

; 383: COLOSSEUM
        monster_prop COLOSSEUM
        speed 30
        attack_power 13
        defense 102
        mag_def 153
        mag_pwr 10
        hp 1
        mp 0
        level 1
        attack_anim PARTISAN
        special_attack MULTI_PUNCH, DMG_150_PCT
        metamorph 0, 7
        monster_status {HARDER_TO_RUN, FIRST_STRIKE, CANT_SUPLEX, CANT_ESCAPE, CANT_SCAN, CANT_SKETCH, SPECIAL_EVENT, CANT_CONTROL}
        immune_status1 ALL
        immune_status2 ALL
        end_monster_prop

; ------------------------------------------------------------------------------

.include "monster_prop.mac"

; ------------------------------------------------------------------------------
