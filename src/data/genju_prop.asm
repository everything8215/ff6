.include "genju_prop.mac"

; ------------------------------------------------------------------------------

.export GenjuProp

; ------------------------------------------------------------------------------

.segment "genju_prop"

; d8/6e00
GenjuProp:

; ------------------------------------------------------------------------------

; 0: ramuh
        genju_prop RAMUH
        genju_spell THUNDER, 10
        genju_spell THUNDARA, 2
        genju_spell POISON, 5
        genju_bonus STAMINA_1
        end_genju_prop

; 1: ifrit
        genju_prop IFRIT
        genju_spell FIRE, 10
        genju_spell FIRA, 5
        genju_spell DRAIN, 1
        genju_bonus STRENGTH_1
        end_genju_prop

; 2: shiva
        genju_prop SHIVA
        genju_spell BLIZZARD, 10
        genju_spell BLIZZARA, 5
        genju_spell RASP, 4
        genju_spell OSMOSE, 4
        genju_spell CURE, 3
        end_genju_prop

; 3: siren
        genju_prop SIREN
        genju_spell SLEEP, 10
        genju_spell MUTE, 8
        genju_spell SLOW, 7
        genju_spell FIRE, 6
        genju_bonus HP_10
        end_genju_prop

; 4: terrato
        genju_prop TERRATO
        genju_spell QUAKE, 3
        genju_spell QUARTR, 1
        genju_spell TORNADO, 1
        genju_bonus HP_30
        end_genju_prop

; 5: shoat
        genju_prop SHOAT
        genju_spell BIO, 8
        genju_spell BREAK, 5
        genju_spell DOOM, 2
        genju_bonus HP_10
        end_genju_prop

; 6: maduin
        genju_prop MADUIN
        genju_spell FIRA, 3
        genju_spell BLIZZARA, 3
        genju_spell THUNDARA, 3
        genju_bonus MAGPWR_1
        end_genju_prop

; 7: bismark
        genju_prop BISMARK
        genju_spell FIRE, 20
        genju_spell BLIZZARD, 20
        genju_spell THUNDER, 20
        genju_spell RAISE, 2
        genju_bonus STRENGTH_2
        end_genju_prop

; 8: stray
        genju_prop STRAY
        genju_spell CONFUSE, 7
        genju_spell IMP, 5
        genju_spell FLOAT, 2
        genju_bonus MAGPWR_1
        end_genju_prop

; 9: palidor
        genju_prop PALIDOR
        genju_spell HASTE, 20
        genju_spell SLOW, 20
        genju_spell HASTE2, 2
        genju_spell SLOW_2, 2
        genju_spell FLOAT, 5
        end_genju_prop

; 10: tritoch
        genju_prop TRITOCH
        genju_spell FIRAGA, 1
        genju_spell BLIZZAGA, 1
        genju_spell THUNDAGA, 1
        genju_bonus MAGPWR_2
        end_genju_prop

; 11: odin
        genju_prop ODIN
        genju_spell METEOR, 1
        genju_bonus SPEED_1
        end_genju_prop

; 12: raiden
        genju_prop RAIDEN
        genju_spell QUICK, 1
        genju_bonus STRENGTH_2
        end_genju_prop

; 13: bahamut
        genju_prop BAHAMUT
        genju_spell FLARE, 2
        genju_bonus HP_50
        end_genju_prop

; 14: alexandr
        genju_prop ALEXANDR
        genju_spell HOLY, 2
        genju_spell SHELL, 10
        genju_spell SAFE, 10
        genju_spell DISPEL, 10
        genju_spell REMEDY, 15
        end_genju_prop

; 15: crusader
        genju_prop CRUSADER
        genju_spell MELTDOWN, 1
        genju_spell METEOR, 10
        genju_bonus MP_50
        end_genju_prop

; 16: ragnarok
        genju_prop RAGNAROK
        genju_spell ULTIMA, 1
        end_genju_prop

; 17: kirin
        genju_prop KIRIN
        genju_spell CURE, 5
        genju_spell CURA, 1
        genju_spell REGEN, 3
        genju_spell POISONA, 4
        genju_spell SCAN, 5
        end_genju_prop

; 18: zoneseek
        genju_prop ZONESEEK
        genju_spell RASP, 20
        genju_spell OSMOSE, 15
        genju_spell SHELL, 5
        genju_bonus MAGPWR_2
        end_genju_prop

; 19: carbunkl
        genju_prop CARBUNKL
        genju_spell REFLECT, 5
        genju_spell HASTE, 3
        genju_spell SHELL, 2
        genju_spell SAFE, 2
        genju_spell WARP, 2
        end_genju_prop

; 20: phantom
        genju_prop PHANTOM
        genju_spell BERSERK, 3
        genju_spell VANISH, 3
        genju_spell DEMI, 5
        genju_bonus MP_10
        end_genju_prop

; 21: sraphim
        genju_prop SRAPHIM
        genju_spell RAISE, 5
        genju_spell CURA, 8
        genju_spell CURE, 20
        genju_spell REGEN, 10
        genju_spell REMEDY, 4
        end_genju_prop

; 22: golem
        genju_prop GOLEM
        genju_spell SAFE, 5
        genju_spell STOP, 5
        genju_spell CURA, 5
        genju_bonus STAMINA_2
        end_genju_prop

; 23: unicorn
        genju_prop UNICORN
        genju_spell CURA, 4
        genju_spell REMEDY, 3
        genju_spell DISPEL, 2
        genju_spell SAFE, 1
        genju_spell SHELL, 1
        end_genju_prop

; 24: fenrir
        genju_prop FENRIR
        genju_spell WARP, 10
        genju_spell DEZONE, 5
        genju_spell STOP, 3
        genju_bonus MP_30
        end_genju_prop

; 25: starlet
        genju_prop STARLET
        genju_spell CURE, 25
        genju_spell CURA, 16
        genju_spell CURAGA, 1
        genju_spell REGEN, 20
        genju_spell REMEDY, 20
        genju_bonus STAMINA_2
        end_genju_prop

; 26: phoenix
        genju_prop PHOENIX
        genju_spell RAISE, 10
        genju_spell ARISE, 2
        genju_spell RERAISE, 1
        genju_spell CURAGA, 2
        genju_spell FIRAGA, 3
        end_genju_prop

; ------------------------------------------------------------------------------

.include "genju_prop.mac"
