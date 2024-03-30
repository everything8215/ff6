; ------------------------------------------------------------------------------

.export GenjuProp

; ------------------------------------------------------------------------------

.segment "genju_prop"

; d8/6e00
GenjuProp:

; ------------------------------------------------------------------------------

; 0: ramuh
        .byte 10, ATTACK_BOLT
        .byte 2, ATTACK_BOLT_2
        .byte 5, ATTACK_POISON
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_STAMINA_1

; ------------------------------------------------------------------------------

; 1: ifrit
        .byte 10, ATTACK_FIRE
        .byte 5, ATTACK_FIRE_2
        .byte 1, ATTACK_DRAIN
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_STRENGH_1

; ------------------------------------------------------------------------------

; 2: shiva
        .byte 10, ATTACK_ICE
        .byte 5, ATTACK_ICE_2
        .byte 4, ATTACK_RASP
        .byte 4, ATTACK_OSMOSE
        .byte 3, ATTACK_CURE
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 3: siren
        .byte 10, ATTACK_SLEEP
        .byte 8, ATTACK_MUTE
        .byte 7, ATTACK_SLOW
        .byte 6, ATTACK_FIRE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_HP_10

; ------------------------------------------------------------------------------

; 4: terrato
        .byte 3, ATTACK_QUAKE
        .byte 1, ATTACK_QUARTR
        .byte 1, ATTACK_W_WIND
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_HP_30

; ------------------------------------------------------------------------------

; 5: shoat
        .byte 8, ATTACK_BIO
        .byte 5, ATTACK_BREAK
        .byte 2, ATTACK_DOOM
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_HP_10

; ------------------------------------------------------------------------------

; 6: maduin
        .byte 3, ATTACK_FIRE_2
        .byte 3, ATTACK_ICE_2
        .byte 3, ATTACK_BOLT_2
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_MAGPWR_1

; ------------------------------------------------------------------------------

; 7: bismark
        .byte 20, ATTACK_FIRE
        .byte 20, ATTACK_ICE
        .byte 20, ATTACK_BOLT
        .byte 2, ATTACK_LIFE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_STRENGH_2

; ------------------------------------------------------------------------------

; 8: stray
        .byte 7, ATTACK_MUDDLE
        .byte 5, ATTACK_IMP
        .byte 2, ATTACK_FLOAT
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_MAGPWR_1

; ------------------------------------------------------------------------------

; 9: palidor
        .byte 20, ATTACK_HASTE
        .byte 20, ATTACK_SLOW
        .byte 2, ATTACK_HASTE2
        .byte 2, ATTACK_SLOW_2
        .byte 5, ATTACK_FLOAT
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 10: tritoch
        .byte 1, ATTACK_FIRE_3
        .byte 1, ATTACK_ICE_3
        .byte 1, ATTACK_BOLT_3
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_MAGPWR_2

; ------------------------------------------------------------------------------

; 11: odin
        .byte 1, ATTACK_METEOR
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_SPEED_1

; ------------------------------------------------------------------------------

; 12: raiden
        .byte 1, ATTACK_QUICK
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_STRENGH_2

; ------------------------------------------------------------------------------

; 13: bahamut
        .byte 2, ATTACK_FLARE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_HP_50

; ------------------------------------------------------------------------------

; 14: alexandr
        .byte 2, ATTACK_PEARL
        .byte 10, ATTACK_SHELL
        .byte 10, ATTACK_SAFE
        .byte 10, ATTACK_DISPEL
        .byte 15, ATTACK_REMEDY
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 15: crusader
        .byte 1, ATTACK_MERTON
        .byte 10, ATTACK_METEOR
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_MP_50

; ------------------------------------------------------------------------------

; 16: ragnarok
        .byte 1, ATTACK_ULTIMA
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 17: kirin
        .byte 5, ATTACK_CURE
        .byte 1, ATTACK_CURE_2
        .byte 3, ATTACK_REGEN
        .byte 4, ATTACK_ANTDOT
        .byte 5, ATTACK_SCAN
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 18: zoneseek
        .byte 20, ATTACK_RASP
        .byte 15, ATTACK_OSMOSE
        .byte 5, ATTACK_SHELL
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_MAGPWR_2

; ------------------------------------------------------------------------------

; 19: carbunkl
        .byte 5, ATTACK_RFLECT
        .byte 3, ATTACK_HASTE
        .byte 2, ATTACK_SHELL
        .byte 2, ATTACK_SAFE
        .byte 2, ATTACK_WARP
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 20: phantom
        .byte 3, ATTACK_BSERK
        .byte 3, ATTACK_VANISH
        .byte 5, ATTACK_DEMI
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_MP_10

; ------------------------------------------------------------------------------

; 21: sraphim
        .byte 5, ATTACK_LIFE
        .byte 8, ATTACK_CURE_2
        .byte 20, ATTACK_CURE
        .byte 10, ATTACK_REGEN
        .byte 4, ATTACK_REMEDY
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 22: golem
        .byte 5, ATTACK_SAFE
        .byte 5, ATTACK_STOP
        .byte 5, ATTACK_CURE_2
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_STAMINA_2

; ------------------------------------------------------------------------------

; 23: unicorn
        .byte 4, ATTACK_CURE_2
        .byte 3, ATTACK_REMEDY
        .byte 2, ATTACK_DISPEL
        .byte 1, ATTACK_SAFE
        .byte 1, ATTACK_SHELL
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------

; 24: fenrir
        .byte 10, ATTACK_WARP
        .byte 5, ATTACK_X_ZONE
        .byte 3, ATTACK_STOP
        .byte 0, ATTACK_NONE
        .byte 0, ATTACK_NONE
        .byte GENJU_BONUS_MP_30

; ------------------------------------------------------------------------------

; 25: starlet
        .byte 25, ATTACK_CURE
        .byte 16, ATTACK_CURE_2
        .byte 1, ATTACK_CURE_3
        .byte 20, ATTACK_REGEN
        .byte 20, ATTACK_REMEDY
        .byte GENJU_BONUS_STAMINA_2

; ------------------------------------------------------------------------------

; 26: phoenix
        .byte 10, ATTACK_LIFE
        .byte 2, ATTACK_LIFE_2
        .byte 1, ATTACK_LIFE_3
        .byte 2, ATTACK_CURE_3
        .byte 3, ATTACK_FIRE_3
        .byte GENJU_BONUS_NONE

; ------------------------------------------------------------------------------
