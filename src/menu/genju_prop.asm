; ------------------------------------------------------------------------------

.export GenjuProp

; ------------------------------------------------------------------------------

.segment "genju_prop"

; d8/6e00
GenjuProp:

; ------------------------------------------------------------------------------

; 0: ramuh
        .byte 10, ATTACK::BOLT
        .byte 2, ATTACK::BOLT_2
        .byte 5, ATTACK::POISON
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_STAMINA_1

; ------------------------------------------------------------------------------

; 1: ifrit
        .byte 10, ATTACK::FIRE
        .byte 5, ATTACK::FIRE_2
        .byte 1, ATTACK::DRAIN
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_STRENGH_1

; ------------------------------------------------------------------------------

; 2: shiva
        .byte 10, ATTACK::ICE
        .byte 5, ATTACK::ICE_2
        .byte 4, ATTACK::RASP
        .byte 4, ATTACK::OSMOSE
        .byte 3, ATTACK::CURE
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 3: siren
        .byte 10, ATTACK::SLEEP
        .byte 8, ATTACK::MUTE
        .byte 7, ATTACK::SLOW
        .byte 6, ATTACK::FIRE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_HP_10

; ------------------------------------------------------------------------------

; 4: terrato
        .byte 3, ATTACK::QUAKE
        .byte 1, ATTACK::QUARTR
        .byte 1, ATTACK::W_WIND
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_HP_30

; ------------------------------------------------------------------------------

; 5: shoat
        .byte 8, ATTACK::BIO
        .byte 5, ATTACK::BREAK
        .byte 2, ATTACK::DOOM
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_HP_10

; ------------------------------------------------------------------------------

; 6: maduin
        .byte 3, ATTACK::FIRE_2
        .byte 3, ATTACK::ICE_2
        .byte 3, ATTACK::BOLT_2
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_MAGPWR_1

; ------------------------------------------------------------------------------

; 7: bismark
        .byte 20, ATTACK::FIRE
        .byte 20, ATTACK::ICE
        .byte 20, ATTACK::BOLT
        .byte 2, ATTACK::LIFE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_STRENGH_2

; ------------------------------------------------------------------------------

; 8: stray
        .byte 7, ATTACK::MUDDLE
        .byte 5, ATTACK::IMP
        .byte 2, ATTACK::FLOAT
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_MAGPWR_1

; ------------------------------------------------------------------------------

; 9: palidor
        .byte 20, ATTACK::HASTE
        .byte 20, ATTACK::SLOW
        .byte 2, ATTACK::HASTE2
        .byte 2, ATTACK::SLOW_2
        .byte 5, ATTACK::FLOAT
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 10: tritoch
        .byte 1, ATTACK::FIRE_3
        .byte 1, ATTACK::ICE_3
        .byte 1, ATTACK::BOLT_3
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_MAGPWR_2

; ------------------------------------------------------------------------------

; 11: odin
        .byte 1, ATTACK::METEOR
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_SPEED_1

; ------------------------------------------------------------------------------

; 12: raiden
        .byte 1, ATTACK::QUICK
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_STRENGH_2

; ------------------------------------------------------------------------------

; 13: bahamut
        .byte 2, ATTACK::FLARE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_HP_50

; ------------------------------------------------------------------------------

; 14: alexandr
        .byte 2, ATTACK::PEARL
        .byte 10, ATTACK::SHELL
        .byte 10, ATTACK::SAFE
        .byte 10, ATTACK::DISPEL
        .byte 15, ATTACK::REMEDY
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 15: crusader
        .byte 1, ATTACK::MERTON
        .byte 10, ATTACK::METEOR
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_MP_50

; ------------------------------------------------------------------------------

; 16: ragnarok
        .byte 1, ATTACK::ULTIMA
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 17: kirin
        .byte 5, ATTACK::CURE
        .byte 1, ATTACK::CURE_2
        .byte 3, ATTACK::REGEN
        .byte 4, ATTACK::ANTDOT
        .byte 5, ATTACK::SCAN
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 18: zoneseek
        .byte 20, ATTACK::RASP
        .byte 15, ATTACK::OSMOSE
        .byte 5, ATTACK::SHELL
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_MAGPWR_2

; ------------------------------------------------------------------------------

; 19: carbunkl
        .byte 5, ATTACK::RFLECT
        .byte 3, ATTACK::HASTE
        .byte 2, ATTACK::SHELL
        .byte 2, ATTACK::SAFE
        .byte 2, ATTACK::WARP
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 20: phantom
        .byte 3, ATTACK::BSERK
        .byte 3, ATTACK::VANISH
        .byte 5, ATTACK::DEMI
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_MP_10

; ------------------------------------------------------------------------------

; 21: sraphim
        .byte 5, ATTACK::LIFE
        .byte 8, ATTACK::CURE_2
        .byte 20, ATTACK::CURE
        .byte 10, ATTACK::REGEN
        .byte 4, ATTACK::REMEDY
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 22: golem
        .byte 5, ATTACK::SAFE
        .byte 5, ATTACK::STOP
        .byte 5, ATTACK::CURE_2
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_STAMINA_2

; ------------------------------------------------------------------------------

; 23: unicorn
        .byte 4, ATTACK::CURE_2
        .byte 3, ATTACK::REMEDY
        .byte 2, ATTACK::DISPEL
        .byte 1, ATTACK::SAFE
        .byte 1, ATTACK::SHELL
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 24: fenrir
        .byte 10, ATTACK::WARP
        .byte 5, ATTACK::X_ZONE
        .byte 3, ATTACK::STOP
        .byte 0, ATTACK::NONE
        .byte 0, ATTACK::NONE
        .byte GENJU_BONUS_MP_30

; ------------------------------------------------------------------------------

; 25: starlet
        .byte 25, ATTACK::CURE
        .byte 16, ATTACK::CURE_2
        .byte 1, ATTACK::CURE_3
        .byte 20, ATTACK::REGEN
        .byte 20, ATTACK::REMEDY
        .byte GENJU_BONUS_STAMINA_2

; ------------------------------------------------------------------------------

; 26: phoenix
        .byte 10, ATTACK::LIFE
        .byte 2, ATTACK::LIFE_2
        .byte 1, ATTACK::LIFE_3
        .byte 2, ATTACK::CURE_3
        .byte 3, ATTACK::FIRE_3
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------
