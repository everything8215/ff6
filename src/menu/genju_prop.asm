; ------------------------------------------------------------------------------

.export GenjuProp

; ------------------------------------------------------------------------------

.mac make_genju_spell spell_id, spell_rate
        .byte spell_rate, ATTACK::spell_id
.endmac

.mac make_genju_prop spell1, spell2, spell3, spell4, spell5, bonus
        .ifnblank spell1
                make_genju_spell spell1
        .else
                make_genju_spell NONE, 0
        .endif
        .ifnblank spell2
                make_genju_spell spell2
        .else
                make_genju_spell NONE, 0
        .endif
        .ifnblank spell3
                make_genju_spell spell3
        .else
                make_genju_spell NONE, 0
        .endif
        .ifnblank spell4
                make_genju_spell spell4
        .else
                make_genju_spell NONE, 0
        .endif
        .ifnblank spell5
                make_genju_spell spell5
        .else
                make_genju_spell NONE, 0
        .endif
        .ifnblank bonus
                .byte GENJU_BONUS::bonus
        .else
                .byte GENJU_BONUS::NONE
        .endif
.endmac

; ------------------------------------------------------------------------------

.segment "genju_prop"

; d8/6e00
GenjuProp:

; ------------------------------------------------------------------------------

; 0: ramuh
make_genju_prop {BOLT, 10}, {BOLT_2, 2}, {POISON, 5}, {}, {}, STAMINA_1

; 1: ifrit
make_genju_prop {FIRE, 10}, {FIRE_2, 5}, {DRAIN, 1}, {}, {}, STRENGTH_1

; 2: shiva
make_genju_prop {ICE, 10}, {ICE_2, 5}, {RASP, 4}, {OSMOSE, 4}, {CURE, 3}

; 3: siren
make_genju_prop {SLEEP, 10}, {MUTE, 8}, {SLOW, 7}, {FIRE, 6}, {}, HP_10

; 4: terrato
make_genju_prop {QUAKE, 3}, {QUARTR, 1}, {W_WIND, 1}, {}, {}, HP_30

; 5: shoat
make_genju_prop {BIO, 8}, {BREAK, 5}, {DOOM, 2}, {}, {}, HP_10

; 6: maduin
make_genju_prop {FIRE_2, 3}, {ICE_2, 3}, {BOLT_2, 3}, {}, {}, MAGPWR_1

; 7: bismark
make_genju_prop {FIRE, 20}, {ICE, 20}, {BOLT, 20}, {LIFE, 2}, {}, STRENGTH_2

; 8: stray
make_genju_prop {MUDDLE, 7}, {IMP, 5}, {FLOAT, 2}, {}, {}, MAGPWR_1

; 9: palidor
make_genju_prop {HASTE, 20}, {SLOW, 20}, {HASTE2, 2}, {SLOW_2, 2}, {FLOAT, 5}

; 10: tritoch
make_genju_prop {FIRE_3, 1}, {ICE_3, 1}, {BOLT_3, 1}, {}, {}, MAGPWR_2

; 11: odin
make_genju_prop {METEOR, 1}, {}, {}, {}, {}, SPEED_1

; 12: raiden
make_genju_prop {QUICK, 1}, {}, {}, {}, {}, STRENGTH_2

; 13: bahamut
make_genju_prop {FLARE, 2}, {}, {}, {}, {}, HP_50

; 14: alexandr
make_genju_prop {PEARL, 2}, {SHELL, 10}, {SAFE, 10}, {DISPEL, 10}, {REMEDY, 15}

; 15: crusader
make_genju_prop {MERTON, 1}, {METEOR, 10}, {}, {}, {}, MP_50

; 16: ragnarok
make_genju_prop {ULTIMA, 1}, {}, {}, {}, {}

; 17: kirin
make_genju_prop {CURE, 5}, {CURE_2, 1}, {REGEN, 3}, {ANTDOT, 4}, {SCAN, 5}

; 18: zoneseek
make_genju_prop {RASP, 20}, {OSMOSE, 15}, {SHELL, 5}, {}, {}, MAGPWR_2

; 19: carbunkl
make_genju_prop {RFLECT, 5}, {HASTE, 3}, {SHELL, 2}, {SAFE, 2}, {WARP, 2}

; 20: phantom
make_genju_prop {BSERK, 3}, {VANISH, 3}, {DEMI, 5}, {}, {}, MP_10

; 21: sraphim
make_genju_prop {LIFE, 5}, {CURE_2, 8}, {CURE, 20}, {REGEN, 10}, {REMEDY, 4}

; 22: golem
make_genju_prop {SAFE, 5}, {STOP, 5}, {CURE_2, 5}, {}, {}, STAMINA_2

; 23: unicorn
make_genju_prop {CURE_2, 4}, {REMEDY, 3}, {DISPEL, 2}, {SAFE, 1}, {SHELL, 1}

; 24: fenrir
make_genju_prop {WARP, 10}, {X_ZONE, 5}, {STOP, 3}, {}, {}, MP_30

; 25: starlet
make_genju_prop {CURE, 25}, {CURE_2, 16}, {CURE_3, 1}, {REGEN, 20}, {REMEDY, 20}, STAMINA_2

; 26: phoenix
make_genju_prop {LIFE, 10}, {LIFE_2, 2}, {LIFE_3, 1}, {CURE_3, 2}, {FIRE_3, 3}

; ------------------------------------------------------------------------------
