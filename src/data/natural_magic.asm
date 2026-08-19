; ------------------------------------------------------------------------------

.export NaturalMagic

; ------------------------------------------------------------------------------

; ec/e3c0
.segment "natural_magic"

; ------------------------------------------------------------------------------

NaturalMagic:

; ------------------------------------------------------------------------------

; terra
        .byte ATTACK::CURE, 1
        .byte ATTACK::FIRE, 3
        .byte ATTACK::POISONA, 6
        .byte ATTACK::DRAIN, 12
        .byte ATTACK::RAISE, 18
        .byte ATTACK::FIRA, 22
        .byte ATTACK::WARP, 26
        .byte ATTACK::CURA, 33
        .byte ATTACK::DISPEL, 37
        .byte ATTACK::FIRAGA, 43
        .byte ATTACK::ARISE, 49
        .byte ATTACK::HOLY, 57
        .byte ATTACK::BREAK, 68
        .byte ATTACK::QUARTR, 75
        .byte ATTACK::MELTDOWN, 86
        .byte ATTACK::ULTIMA, 99

; ------------------------------------------------------------------------------

; celes
        .byte ATTACK::BLIZZARD, 1
        .byte ATTACK::CURE, 4
        .byte ATTACK::POISONA, 8
        .byte ATTACK::IMP, 13
        .byte ATTACK::SCAN, 18
        .byte ATTACK::SAFE, 22
        .byte ATTACK::BLIZZARA, 26
        .byte ATTACK::HASTE, 32
        .byte ATTACK::BERSERK, 40
        .byte ATTACK::CONFUSE, 32
        .byte ATTACK::BLIZZAGA, 42
        .byte ATTACK::VANISH, 48
        .byte ATTACK::HASTE2, 52
        .byte ATTACK::HOLY, 72
        .byte ATTACK::FLARE, 81
        .byte ATTACK::METEOR, 98

; ------------------------------------------------------------------------------
