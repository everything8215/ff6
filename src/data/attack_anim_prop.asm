; ------------------------------------------------------------------------------

.export AttackAnimProp

.include "attack_anim_prop.mac"
.include "src/btlgfx/attack_anim_script.inc"
.include "src/sound/sfx.inc"

; ------------------------------------------------------------------------------

.segment "attack_anim_prop"

; d0/7fb2
AttackAnimProp:

; ------------------------------------------------------------------------------

; 0: FIRE
        attack_anim_prop FIRE
        sprite_script FIRE_SPRITE
        sprite_pal 56
        sfx FIRE
        init_fn 37
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 1: BLIZZARD
        attack_anim_prop BLIZZARD
        sprite_script BLIZZARD_SPRITE
        sprite_pal 82
        bg1_gfx BLIZZARD_BG1
        bg1_pal 86
        sfx BLIZZARD
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 2: THUNDER
        attack_anim_prop THUNDER
        sprite_script THUNDER_SPRITE
        sprite_pal 97
        sfx THUNDER
        init_fn 0
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 3: POISON
        attack_anim_prop POISON
        sprite_script POISON_SPRITE
        sprite_pal 104
        sfx POISON
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 4: DRAIN
        attack_anim_prop DRAIN
        sprite_script DRAIN_SPRITE
        sprite_pal 76
        bg1_script DRAIN_BG1
        bg1_pal 90
        sfx DRAIN
        init_fn 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 5: FIRA
        attack_anim_prop FIRA
        sprite_script FIRA_SPRITE
        sprite_pal 81
        bg1_gfx FIRA_BG1
        bg1_pal 81
        sfx FIRA
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 6: BLIZZARA
        attack_anim_prop BLIZZARA
        sprite_script BLIZZARA_SPRITE
        sprite_pal 84
        bg1_gfx BLIZZARA_BG1
        bg1_pal 86
        sfx BLIZZARA_A
        init_fn 16
        delay 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 7: THUNDARA
        attack_anim_prop THUNDARA
        sprite_script THUNDARA_SPRITE
        sprite_pal 97
        bg1_gfx THUNDARA_BG1
        bg1_pal 105
        sfx THUNDARA
        init_fn 27
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 8: BIO
        attack_anim_prop BIO
        sprite_script BIO_SPRITE
        sprite_pal 85
        bg1_gfx BIO_BG1
        bg1_pal 85
        sfx BIO
        init_fn 37
        delay 42
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 9: FIRAGA
        attack_anim_prop FIRAGA
        sprite_script FIRAGA_SPRITE
        sprite_pal 210
        bg1_gfx FIRAGA_BG1
        bg1_pal 83
        sfx FIRAGA
        init_fn 28
        delay 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 10: BLIZZAGA
        attack_anim_prop BLIZZAGA
        sprite_script BLIZZAGA_SPRITE
        sprite_pal 201
        bg1_gfx BLIZZAGA_BG1
        bg1_pal 201
        sfx BLIZZAGA
        init_fn 27
        delay 41
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 11: THUNDAGA
        attack_anim_prop THUNDAGA
        sprite_script THUNDAGA_SPRITE
        sprite_pal 97
        bg1_gfx THUNDAGA_BG1
        bg1_pal 86
        sfx THUNDAGA
        init_fn 86
        delay 40
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 12: BREAK
        attack_anim_prop BREAK
        sprite_script BREAK_SPRITE
        sprite_pal 122
        bg1_script BREAK_BG1
        bg1_pal 106
        sfx BREAK_A
        init_fn 48
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 13: DOOM
        attack_anim_prop DOOM
        sprite_script DOOM_SPRITE
        sprite_pal 111
        bg1_script DOOM_BG1
        sfx DOOM
        init_fn 167
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 14: HOLY
        attack_anim_prop HOLY
        sprite_script HOLY_SPRITE
        sprite_pal 82
        bg1_script HOLY_BG1
        bg1_pal 82
        bg3_script HOLY_BG3
        bg3_pal 120
        sfx HOLY
        init_fn 49
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 15: FLARE
        attack_anim_prop FLARE
        sprite_script FLARE_SPRITE
        sprite_pal 81
        bg1_script FLARE_BG1
        bg1_pal 81
        init_fn 21
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 16: DEMI
        attack_anim_prop DEMI
        sprite_script DEMI_SPRITE
        sprite_pal 225
        sfx DEMI
        init_fn 103
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 17: QUARTR
        attack_anim_prop QUARTR
        sprite_script DEMI_SPRITE
        sprite_pal 225
        sfx DEMI
        init_fn 103
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 18: DEZONE
        attack_anim_prop DEZONE
        sprite_script DEZONE_SPRITE
        bg3_script DEZONE_BG3
        bg3_pal 94
        sfx DEZONE
        init_fn 42
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 19: METEOR
        attack_anim_prop METEOR
        sprite_script METEOR_SPRITE
        sprite_pal 100
        bg1_script METEOR_BG1
        bg1_pal 89
        bg3_script METEOR_BG3
        bg3_pal 94
        sfx METEOR
        init_fn 40
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 20: ULTIMA
        attack_anim_prop ULTIMA
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script ULTIMA_BG1
        bg1_pal 110
        bg3_script ULTIMA_BG3
        bg3_pal 113
        sfx ULTIMA
        init_fn 50
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 21: QUAKE
        attack_anim_prop QUAKE
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script QUAKE_BG1
        bg1_pal 101
        sfx QUAKE
        init_fn 41
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 22: TORNADO
        attack_anim_prop TORNADO
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script TORNADO_BG1
        bg1_pal 80
        sfx TORNADO
        init_fn 15
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 23: MELTDOWN
        attack_anim_prop MELTDOWN
        sprite_script MELTDOWN_SPRITE
        bg3_script MELTDOWN_BG3
        bg3_pal 108
        sfx MELTDOWN
        init_fn 45
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 24: SCAN
        attack_anim_prop SCAN
        sprite_script SCAN_SPRITE
        sprite_pal 58
        bg1_script SCAN_BG1
        bg1_pal 93
        sfx SCAN
        init_fn 25
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 25: SLOW
        attack_anim_prop SLOW
        sprite_script SLOW_SPRITE
        sprite_pal 212
        bg1_script CHAR_GFX_BG1
        bg3_script SLOW_BG3
        bg3_pal 78
        sfx SLOW
        init_fn 239
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 26: RASP
        attack_anim_prop RASP
        sprite_script RASP_SPRITE
        sprite_pal 73
        bg3_script RASP_BG3
        bg3_pal 73
        sfx RASP_A
        init_fn 26
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 27: MUTE
        attack_anim_prop MUTE
        sprite_script MUTE_SPRITE
        sprite_pal 58
        bg1_script MUTE_BG1
        bg1_pal 228
        sfx SMOKE_BOMB
        init_fn 71
        delay 40
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 28: SAFE
        attack_anim_prop SAFE
        sprite_script SAFE_SPRITE
        sprite_pal 225
        bg1_script SAFE_BG1
        bg1_pal 216
        sfx SAFE
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 29: SLEEP
        attack_anim_prop SLEEP
        sprite_script SLEEP_SPRITE
        sprite_pal 200
        bg1_script SLEEP_BG1
        sfx SLEEP
        init_fn 87
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 30: CONFUSE
        attack_anim_prop CONFUSE
        sprite_script CONFUSE_SPRITE
        sprite_pal 63
        bg1_script CONFUSE_BG1
        bg1_pal 63
        sfx CONFUSE
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 31: HASTE
        attack_anim_prop HASTE
        sprite_script HASTE_SPRITE
        sprite_pal 62
        bg1_script CHAR_GFX_BG1
        bg3_script HASTE_BG3
        bg3_pal 75
        sfx HASTE
        init_fn 157
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 32: STOP
        attack_anim_prop STOP
        sprite_script STOP_SPRITE
        sprite_pal 95
        sfx BLIZZARA_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 33: BERSERK
        attack_anim_prop BERSERK
        sprite_script BERSERK_SPRITE
        sprite_pal 220
        bg1_script CHAR_GFX_BG1
        bg1_pal 220
        init_fn 157
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 34: FLOAT
        attack_anim_prop FLOAT
        sprite_script FLOAT_SPRITE
        sprite_pal 63
        sfx RAISE_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 35: IMP
        attack_anim_prop IMP
        sprite_script IMP_SPRITE
        sprite_pal 85
        bg1_script IMP_BG1
        bg1_pal 58
        sfx SMOKE_BOMB
        init_fn 31
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 36: REFLECT
        attack_anim_prop REFLECT
        sprite_script REFLECT_SPRITE
        sprite_pal 58
        bg1_pal 92
        sfx REFLECT
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 37: SHELL
        attack_anim_prop SHELL
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script SHELL_BG1
        bg1_pal 92
        sfx SHELL
        init_fn 27
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 38: VANISH
        attack_anim_prop VANISH
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 255
        bg1_script VANISH_BG1
        bg1_pal 227
        sfx VANISH
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 39: HASTE2
        attack_anim_prop HASTE2
        sprite_script HASTE_SPRITE
        sprite_pal 62
        bg3_script HASTE_BG3
        bg3_pal 221
        sfx HASTE
        init_fn 35
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 40: SLOW_2
        attack_anim_prop SLOW_2
        sprite_script SLOW_SPRITE
        sprite_pal 212
        bg1_script SLOW_2_BG1
        bg3_script SLOW_BG3
        bg3_pal 222
        sfx SLOW
        init_fn 71
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 41: OSMOSE
        attack_anim_prop OSMOSE
        sprite_script DRAIN_SPRITE
        sprite_pal 202
        bg1_script DRAIN_BG1
        bg1_pal 130
        sfx DRAIN
        init_fn 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 42: WARP
        attack_anim_prop WARP
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script WARP_BG1
        sfx WARP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 43: QUICK
        attack_anim_prop QUICK
        sprite_script QUICK_SPRITE
        sprite_pal 58
        sfx QUICK_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 44: DISPEL
        attack_anim_prop DISPEL
        sprite_script DISPEL_SPRITE
        sprite_pal 84
        bg1_script DISPEL_BG1
        bg1_pal 84
        sfx DISPEL
        init_fn 34
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 45: CURE
        attack_anim_prop CURE
        sprite_script CURE_SPRITE
        sprite_pal 104
        sfx CURE_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 46: CURA
        attack_anim_prop CURA
        sprite_script CURA_SPRITE
        sprite_pal 104
        sfx CURA
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 47: CURAGA
        attack_anim_prop CURAGA
        sprite_script CURAGA_SPRITE
        sprite_pal 104
        sfx CURE_A
        init_fn 71
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 48: RAISE
        attack_anim_prop RAISE
        sprite_script RAISE_SPRITE
        sprite_pal 63
        sfx RAISE_A
        init_fn 20
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 49: ARISE
        attack_anim_prop ARISE
        sprite_script ARISE_SPRITE
        sprite_pal 63
        sfx ARISE
        init_fn 20
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 50: POISONA
        attack_anim_prop POISONA
        sprite_script POISONA_SPRITE
        sprite_pal 239
        bg1_script CHAR_GFX_BG1
        bg3_script REGEN_BG3
        bg3_pal 76
        sfx FENIX_DOWN
        init_fn 164
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 51: REMEDY
        attack_anim_prop REMEDY
        sprite_script REMEDY_SPRITE
        sprite_pal 59
        bg1_script REMEDY_BG1
        bg1_pal 93
        sfx ESUNA
        init_fn 22
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 52: REGEN
        attack_anim_prop REGEN
        sprite_script REGEN_SPRITE
        sprite_pal 65
        bg1_script CHAR_GFX_BG1
        bg3_script REGEN_BG3
        bg3_pal 74
        sfx FENIX_DOWN
        init_fn 164
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 53: RERAISE
        attack_anim_prop RERAISE
        sprite_script RERAISE_SPRITE
        sprite_pal 63
        bg1_gfx RERAISE_SPRITE
        bg1_pal 63
        sfx RAISE_A
        init_fn 23
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 54: RAMUH
        attack_anim_prop RAMUH
        sprite_gfx RAMUH_SPRITE
        sprite_pal 10
        bg1_script RAMUH_BG1
        bg1_pal 123
        bg3_script RAMUH_BG3
        bg3_pal 134
        extra_gfx RAMUH_SPRITE
        sfx RAMUH
        init_fn 56
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 55: IFRIT
        attack_anim_prop IFRIT
        sprite_gfx IFRIT_SPRITE
        sprite_pal 10
        bg1_script IFRIT_BG1
        bg1_pal 83
        bg3_script IFRIT_BG3
        bg3_pal 83
        extra_gfx IFRIT_SPRITE
        sfx IFRIT
        init_fn 51
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 56: SHIVA
        attack_anim_prop SHIVA
        sprite_gfx SHIVA_SPRITE
        sprite_pal 64
        bg1_script SHIVA_BG1
        bg1_pal 110
        bg3_script SHIVA_BG3
        bg3_pal 94
        extra_gfx SHIVA_SPRITE
        sfx SHIVA
        init_fn 57
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 57: SIREN
        attack_anim_prop SIREN
        sprite_script SIREN_SPRITE
        sprite_pal 60
        bg1_script SIREN_BG1
        bg3_script SIREN_BG3
        bg3_pal 68
        extra_gfx SIREN_SPRITE
        sfx SIREN
        init_fn 58
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 58: TERRATO
        attack_anim_prop TERRATO
        sprite_gfx TERRATO_SPRITE
        bg1_script TERRATO_BG1
        bg1_pal 115
        bg3_script TERRATO_BG3
        bg3_pal 136
        extra_gfx TERRATO_SPRITE
        sfx TERRATO
        init_fn 53
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 59: SHOAT
        attack_anim_prop SHOAT
        sprite_gfx SHOAT_SPRITE
        sprite_pal 210
        bg1_script SHOAT_BG1
        extra_gfx SHOAT_SPRITE
        sfx SHOAT
        init_fn 52
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 60: MADUIN
        attack_anim_prop MADUIN
        sprite_gfx MADUIN_SPRITE
        sprite_pal 10
        bg1_script MADUIN_BG1
        bg1_pal 103
        bg3_script MADUIN_BG3
        bg3_pal 131
        extra_gfx MADUIN_SPRITE
        sfx MADUIN
        init_fn 67
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 61: BISMARK
        attack_anim_prop BISMARK
        sprite_script BISMARK_SPRITE
        sprite_pal 10
        bg1_script BISMARK_BG1
        bg1_pal 120
        bg3_pal 134
        extra_gfx BISMARK_EXTRA
        sfx BISMARCK
        init_fn 54
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 62: STRAY
        attack_anim_prop STRAY
        sprite_script STRAY_SPRITE
        sprite_pal 60
        bg1_script STRAY_BG1
        sfx CURAGA_B
        init_fn 104
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 63: PALIDOR
        attack_anim_prop PALIDOR
        sprite_script PALIDOR_SPRITE
        sprite_pal 10
        bg1_script PALIDOR_BG1
        sfx PALIDOR
        init_fn 68
        delay 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 64: TRITOCH
        attack_anim_prop TRITOCH
        sprite_gfx TRITOCH_SPRITE
        sprite_pal 10
        bg1_script TRITOCH_BG1
        bg1_pal 56
        bg3_script TRITOCH_BG3
        bg3_pal 67
        extra_gfx TRITOCH_SPRITE
        sfx BURNING_HOUSE
        init_fn 108
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 65: ODIN
        attack_anim_prop ODIN
        sprite_gfx ODIN_SPRITE
        sprite_pal 10
        bg1_script ODIN_BG1
        extra_gfx ODIN_SPRITE
        sfx ODIN
        init_fn 69
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 66: RAIDEN
        attack_anim_prop RAIDEN
        sprite_gfx ODIN_SPRITE
        sprite_pal 10
        bg1_script ODIN_BG1
        bg1_pal 67
        bg3_script RAIDEN_BG3
        bg3_pal 67
        extra_gfx ODIN_SPRITE
        sfx ODIN
        init_fn 107
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 67: BAHAMUT
        attack_anim_prop BAHAMUT
        sprite_script BAHAMUT_SPRITE
        sprite_pal 120
        bg1_script BAHAMUT_BG1
        bg3_script BAHAMUT_BG3
        bg3_pal 127
        sfx BAHAMUT
        init_fn 66
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 68: ALEXANDR
        attack_anim_prop ALEXANDR
        sprite_script ALEXANDR_SPRITE
        sprite_pal 126
        bg1_script ALEXANDR_BG1
        bg3_script ALEXANDR_BG3
        bg3_pal 233
        extra_gfx ALEXANDR_EXTRA
        sfx ALEXANDR_A
        init_fn 59
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 69: CRUSADER
        attack_anim_prop CRUSADER
        sprite_gfx CRUSADER_SPRITE
        bg1_script CRUSADER_BG1
        bg3_script CRUSADER_BG3
        bg3_pal 232
        extra_gfx CRUSADER_SPRITE
        sfx CRUSADER
        init_fn 116
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 70: RAGNAROK
        attack_anim_prop RAGNAROK
        sprite_gfx RAGNAROK_SPRITE
        sprite_pal 137
        bg1_script RAGNAROK_BG1
        bg1_pal 137
        bg3_script RAGNAROK_BG3
        bg3_pal 132
        extra_gfx RAGNAROK_SPRITE
        sfx SHOCK_A
        init_fn 106
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 71: KIRIN
        attack_anim_prop KIRIN
        sprite_gfx KIRIN_SPRITE
        sprite_pal 10
        bg1_script KIRIN_BG1
        bg1_pal 117
        extra_gfx KIRIN_SPRITE
        sfx KIRIN
        init_fn 61
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 72: ZONESEEK
        attack_anim_prop ZONESEEK
        sprite_script WALL_SPRITE
        sprite_pal 219
        bg1_script WALL_BG1
        bg1_pal 127
        sfx SNOWSTORM
        init_fn 55
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 73: CARBUNKL
        attack_anim_prop CARBUNKL
        sprite_gfx CARBUNKL_SPRITE
        sprite_pal 10
        bg1_script CARBUNKL_BG1
        bg1_pal 120
        extra_gfx CARBUNKL_SPRITE
        sfx CARBUNKL
        init_fn 60
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 74: PHANTOM
        attack_anim_prop PHANTOM
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 10
        bg1_script PHANTOM_BG1
        sfx PHANTOM
        init_fn 109
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 75: SRAPHIM
        attack_anim_prop SRAPHIM
        sprite_script SRAPHIM_SPRITE
        sprite_pal 81
        bg1_script SRAPHIM_BG1
        bg1_pal 124
        bg3_script SRAPHIM_BG3
        bg3_pal 127
        sfx CURA
        init_fn 64
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 76: GOLEM
        attack_anim_prop GOLEM
        sprite_script GOLEM_SPRITE
        sprite_pal 106
        bg1_script GOLEM_BG1
        bg1_pal 106
        sfx GOLEM
        init_fn 105
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 77: UNICORN
        attack_anim_prop UNICORN
        sprite_gfx UNICORN_SPRITE
        sprite_pal 10
        bg1_script UNICORN_BG1
        bg1_pal 93
        bg3_script UNICORN_BG3
        bg3_pal 132
        extra_gfx UNICORN_SPRITE
        sfx CARBUNKL
        init_fn 62
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 78: FENRIR
        attack_anim_prop FENRIR
        sprite_gfx FENRIR_SPRITE
        sprite_pal 82
        bg1_script FENRIR_BG1
        extra_gfx FENRIR_SPRITE
        sfx FENRIR
        init_fn 70
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 79: STARLET
        attack_anim_prop STARLET
        sprite_gfx STARLET_SPRITE
        sprite_pal 10
        bg1_script STARLET_BG1
        bg1_pal 88
        extra_gfx STARLET_SPRITE
        sfx STARLET
        init_fn 65
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 80: PHOENIX
        attack_anim_prop PHOENIX
        sprite_gfx PHOENIX_SPRITE
        sprite_pal 10
        bg1_script PHOENIX_BG1
        bg1_pal 128
        bg3_script PHOENIX_BG3
        bg3_pal 119
        extra_gfx PHOENIX_SPRITE
        sfx PHOENIX
        init_fn 63
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 81: FIRE_SKEAN
        attack_anim_prop FIRE_SKEAN
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script FIRE_SKEAN_BG1
        bg1_pal 56
        sfx FIRAGA
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 82: WATER_EDGE
        attack_anim_prop WATER_EDGE
        sprite_gfx WATER_EDGE_SPRITE
        sprite_pal 120
        .if LANG_EN
        bg1_script WATER_EDGE_ALT_BG1
        .else
        bg1_script WATER_EDGE_BG1
        .endif
        bg1_pal 120
        extra_gfx WATER_EDGE_SPRITE
        sfx CLEANSWEEP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 83: BOLT_EDGE
        attack_anim_prop BOLT_EDGE
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script BOLT_EDGE_BG1
        bg1_pal 123
        bg3_script BOLT_EDGE_BG3
        bg3_pal 55
        sfx THUNDER
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 84: STORM
        attack_anim_prop STORM
        sprite_script STORM_SPRITE
        bg1_script STORM_BG1
        bg1_pal 110
        sfx ESUNA
        init_fn 19
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 85: DISPATCH
        attack_anim_prop DISPATCH
        sprite_script DISPATCH_SPRITE
        sprite_pal 24
        bg1_script CHAR_GFX_BG1
        sfx EVENT_HIT
        init_fn 157
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 86: RETORT
        attack_anim_prop RETORT
        sprite_gfx RETORT_SPRITE
        sprite_pal 24
        bg1_script THICK_DIAG_HIT_BG1
        bg1_pal 54
        extra_script RETORT_SPRITE
        init_fn 7
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 87: SLASH
        attack_anim_prop SLASH
        sprite_script SLASH_SPRITE
        sprite_pal 24
        bg1_script CHAR_GFX_BG1
        bg3_script SLASH_BG3
        sfx SLASH
        init_fn 136
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 88: QUADRA_SLAM
        attack_anim_prop QUADRA_SLAM
        sprite_gfx QUADRA_SLAM_SPRITE
        sprite_pal 24
        bg1_script THICK_DIAG_HIT_BG1
        bg1_pal 50
        extra_script QUADRA_SLAM_SPRITE
        sfx QUADRA_SLAM
        init_fn 9
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 89: EMPOWERER
        attack_anim_prop EMPOWERER
        sprite_gfx EMPOWERER_SPRITE
        sprite_pal 24
        bg1_script EMPOWERER_BG1
        bg1_pal 12
        extra_script EMPOWERER_SPRITE
        sfx CLEAVE
        init_fn 9
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 90: STUNNER
        attack_anim_prop STUNNER
        sprite_gfx STUNNER_SPRITE
        sprite_pal 24
        bg1_script STUNNER_BG1
        bg1_pal 51
        extra_script STUNNER_SPRITE
        sfx SHOCK_A
        init_fn 10
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 91: QUADRA_SLICE
        attack_anim_prop QUADRA_SLICE
        sprite_gfx QUADRA_SLAM_SPRITE
        sprite_pal 24
        bg1_script THICK_DIAG_HIT_BG1
        bg1_pal 50
        extra_script QUADRA_SLAM_SPRITE
        sfx QUADRA_SLAM
        init_fn 9
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 92: CLEAVE
        attack_anim_prop CLEAVE
        sprite_gfx CLEAVE_SPRITE
        sprite_pal 24
        extra_script CLEAVE_SPRITE
        init_fn 11
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 93: PUMMEL
        attack_anim_prop PUMMEL
        sprite_gfx PUMMEL_SPRITE
        sprite_pal 35
        bg1_script UNARMED_HIT_BG1
        bg1_pal 54
        extra_script PUMMEL_SPRITE
        sfx PUMMEL
        init_fn 9
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 94: AURABOLT
        attack_anim_prop AURABOLT
        sprite_gfx AURABOLT_SPRITE
        sprite_pal 12
        bg1_script AURABOLT_BG1
        bg1_pal 12
        bg3_script AURABOLT_BG3
        bg3_pal 12
        extra_script AURABOLT_SPRITE
        sfx AURA_BOLT
        init_fn 12
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 95: SUPLEX
        attack_anim_prop SUPLEX
        sprite_script SUPLEX_SPRITE
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 96: FIRE_DANCE
        attack_anim_prop FIRE_DANCE
        sprite_script FIRE_DANCE_SPRITE
        sprite_pal 8
        bg1_script FIRE_DANCE_BG1
        bg1_pal 8
        sfx FIRE_DANCE
        init_fn 40
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 97: MANTRA
        attack_anim_prop MANTRA
        bg1_script MANTRA_BG1
        bg1_pal 10
        sfx MANTRA
        init_fn 14
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 98: AIR_BLADE
        attack_anim_prop AIR_BLADE
        sprite_script AIR_BLADE_SPRITE
        sprite_pal 12
        bg1_script AIR_BLADE_BG1
        bg1_pal 11
        sfx REFLECT
        init_fn 9
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 99: SPIRALER
        attack_anim_prop SPIRALER
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script SPIRALER_BG1
        bg1_pal 9
        sfx TORNADO
        init_fn 15
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 100: BUM_RUSH
        attack_anim_prop BUM_RUSH
        sprite_gfx BUM_RUSH_SPRITE
        bg1_script CHAR_GFX_BG1
        extra_script BUM_RUSH_SPRITE
        sfx BUM_RUSH
        init_fn 157
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 101: WIND_SLASH
        attack_anim_prop WIND_SLASH
        sprite_script WIND_SLASH_SPRITE
        sprite_pal 120
        bg1_script WIND_SLASH_BG1
        bg1_pal 206
        sfx ESUNA
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 102: SUN_BATH
        attack_anim_prop SUN_BATH
        sprite_script SUN_BATH_SPRITE
        sprite_pal 81
        extra_gfx SUN_BATH_EXTRA
        sfx SUN_BATH
        init_fn 71
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 103: RAGE
        attack_anim_prop RAGE
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script RAGE_BG1
        bg1_pal 143
        bg3_script RAGE_BG3
        bg3_pal 143
        sfx RAGE_DANCE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 104: HARVESTER
        attack_anim_prop HARVESTER
        sprite_script HARVESTER_SPRITE
        sprite_pal 158
        bg1_script HARVESTER_BG1
        bg1_pal 120
        bg3_script HARVESTER_BG3
        bg3_pal 120
        sfx BERSERK
        init_fn 72
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 105: SAND_STORM
        attack_anim_prop SAND_STORM
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script SAND_STORM_BG1
        bg1_pal 207
        sfx SAND_STORM
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 106: ANTLION
        attack_anim_prop ANTLION
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script ANTLION_BG1
        bg1_pal 141
        sfx LIFESHAVER
        init_fn 73
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 107: ELF_FIRE
        attack_anim_prop ELF_FIRE
        sprite_script ELF_FIRE_SPRITE
        sprite_pal 105
        sfx PHANTOM
        init_fn 74
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 108: SPECTER
        attack_anim_prop SPECTER
        sprite_script SPECTER_SPRITE
        sprite_pal 120
        bg1_script SPECTER_BG1
        sfx PHANTOM
        init_fn 75
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 109: LAND_SLIDE
        attack_anim_prop LAND_SLIDE
        sprite_script LAND_SLIDE_SPRITE
        sprite_pal 100
        sfx LAND_SLIDE
        init_fn 76
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 110: SONIC_BOOM
        attack_anim_prop SONIC_BOOM
        sprite_script SONIC_BOOM_SPRITE
        sprite_pal 158
        sfx REFLECT
        init_fn 37
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 111: EL_NINO
        attack_anim_prop EL_NINO
        sprite_script EL_NINO_SPRITE
        sprite_pal 120
        bg1_script EL_NINO_BG1
        bg1_pal 120
        sfx EL_NINO
        init_fn 71
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 112: PLASMA
        attack_anim_prop PLASMA
        sprite_script PLASMA_SPRITE
        sprite_pal 120
        sfx PLASMA
        init_fn 37
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 113: SNARE
        attack_anim_prop SNARE
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 139
        bg1_script SNARE_BG1
        bg1_pal 139
        bg3_pal 138
        sfx SNARE
        init_fn 80
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 114: CAVE_IN
        attack_anim_prop CAVE_IN
        sprite_script CAVE_IN_SPRITE
        sprite_pal 106
        sfx CAVE_IN
        init_fn 77
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 115: SNOWBALL
        attack_anim_prop SNOWBALL
        sprite_script SNOWBALL_SPRITE
        sprite_pal 58
        sfx FLARE_A
        init_fn 77
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 116: SURGE
        attack_anim_prop SURGE
        sprite_script SURGE_SPRITE
        bg1_script SURGE_BG1
        bg1_pal 82
        bg3_script SURGE_BG3
        bg3_pal 136
        sfx SURGE
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 117: COKATRICE
        attack_anim_prop COKATRICE
        sprite_script COKATRICE_SPRITE
        sprite_pal 145
        bg1_script COKATRICE_BG1
        bg1_pal 55
        sfx RETORT
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 118: WOMBAT
        attack_anim_prop WOMBAT
        sprite_script WOMBAT_SPRITE
        sprite_pal 146
        bg1_script WOMBAT_BG1
        bg1_pal 55
        sfx CHOCOBOP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 119: KITTY
        attack_anim_prop KITTY
        sprite_script KITTY_SPRITE
        sprite_pal 56
        bg1_script KITTY_BG1
        bg1_pal 148
        sfx KITTY
        init_fn 79
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 120: TAPIR
        attack_anim_prop TAPIR
        sprite_script TAPIR_SPRITE
        sprite_pal 71
        bg1_script TAPIR_BG1
        bg1_pal 147
        sfx VANISH
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 121: WHUMP
        attack_anim_prop WHUMP
        sprite_script WHUMP_SPRITE
        sprite_pal 144
        bg1_script WHUMP_BG1
        bg1_pal 55
        sfx CHOCOBOP
        init_fn 20
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 122: WILD_BEAR
        attack_anim_prop WILD_BEAR
        sprite_gfx WILD_BEAR_SPRITE
        sprite_pal 148
        bg1_script WILD_BEAR_BG1
        bg1_pal 93
        extra_gfx WILD_BEAR_SPRITE
        sfx LAGOMORPH
        init_fn 22
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 123: POIS_FROG
        attack_anim_prop POIS_FROG
        sprite_script POIS_FROG_SPRITE
        sprite_pal 85
        bg1_script POIS_FROG_BG1
        bg1_pal 151
        sfx POISON
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 124: ICE_RABBIT
        attack_anim_prop ICE_RABBIT
        sprite_script ICE_RABBIT_SPRITE
        sprite_pal 51
        bg1_script ICE_RABBIT_BG1
        bg1_pal 150
        sfx CURE_B
        init_fn 28
        delay 22
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 125: SUPER_BALL
        attack_anim_prop SUPER_BALL
        sprite_script SUPER_BALL_SPRITE
        sprite_pal 209
        extra_script SUPER_BALL_EXTRA
        sfx STRAY_CAT
        init_fn 16
        delay 3
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 126: FLASH_SLOT
        attack_anim_prop FLASH_SLOT
        sprite_pal 53
        bg1_script FLASH_BG1
        bg1_pal 53
        sfx SECURITY_CHECKPOINT
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 127: CHOCOBOP
        attack_anim_prop CHOCOBOP
        sprite_script CHOCOBOP_SPRITE
        sprite_pal 186
        sfx CHOCOBOP
        init_fn 94
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 128: H_BOMB
        attack_anim_prop H_BOMB
        sprite_script H_BOMB_SPRITE
        sprite_pal 60
        bg1_script H_BOMB_BG1
        bg1_pal 184
        sfx FLARE_STAR
        init_fn 117
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 129: SEVEN_FLUSH
        attack_anim_prop SEVEN_FLUSH
        sprite_script SEVEN_FLUSH_SPRITE
        sprite_pal 192
        bg1_script SEVEN_FLUSH_BG1
        sfx DRAIN
        init_fn 87
        delay 22
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 130: SHOCK
        attack_anim_prop SHOCK
        sprite_gfx SHOCK_CMD_SPRITE
        sprite_pal 20
        bg1_script SHOCK_CMD_BG1
        bg1_pal 17
        extra_script SHOCK_CMD_SPRITE
        sfx SHOCK_B
        init_fn 9
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 131: FIRE_BEAM
        attack_anim_prop FIRE_BEAM
        sprite_script FIRE_BEAM_SPRITE
        sprite_pal 57
        bg1_script FIRE_BEAM_BG1
        bg1_pal 57
        bg3_script FIRE_BEAM_BG3
        bg3_pal 161
        sfx MAGITEK_BEAM
        init_fn 78
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 132: BOLT_BEAM
        attack_anim_prop BOLT_BEAM
        sprite_script BOLT_BEAM_SPRITE
        sprite_pal 120
        bg1_script BOLT_BEAM_BG1
        bg1_pal 159
        bg3_script BOLT_BEAM_BG3
        bg3_pal 161
        sfx MAGITEK_BEAM
        init_fn 78
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 133: ICE_BEAM
        attack_anim_prop ICE_BEAM
        sprite_script FIRE_BEAM_SPRITE
        sprite_pal 82
        bg1_script ICE_BEAM_BG1
        bg1_pal 127
        bg3_script FIRE_BEAM_BG3
        bg3_pal 160
        sfx MAGITEK_BEAM
        init_fn 78
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 134: BIO_BLAST
        attack_anim_prop BIO_BLAST
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 157
        bg1_script BIO_BLAST_BG1
        bg1_pal 153
        sfx BIO_BLASTER
        init_fn 82
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 135: HEAL_FORCE
        attack_anim_prop HEAL_FORCE
        sprite_script HEAL_FORCE_SPRITE
        sprite_pal 104
        sfx CURE_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 136: CONFUSER
        attack_anim_prop CONFUSER
        sprite_script CONFUSER_SPRITE
        bg1_script CONFUSER_BG1
        bg3_script CONFUSER_BG3
        bg3_pal 155
        sfx CONFUSER
        init_fn 84
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 137: XFER
        attack_anim_prop XFER
        sprite_script XFER_SPRITE
        sprite_pal 156
        bg3_script XFER_BG3
        bg3_pal 156
        sfx XFER
        init_fn 85
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 138: TEKMISSILE
        attack_anim_prop TEKMISSILE
        sprite_script TEKMISSILE_SPRITE
        sprite_pal 162
        sfx MAGITEK_MISSILE
        init_fn 92
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 139: CONDEMNED
        attack_anim_prop CONDEMNED
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script CONDEMNED_BG1
        bg1_pal 166
        bg3_script CONDEMNED_BG3
        bg3_pal 129
        sfx DOOM
        init_fn 38
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 140: ROULETTE
        attack_anim_prop ROULETTE
        sprite_script DOOM_SPRITE
        sprite_pal 111
        bg1_script DOOM_BG1
        sfx DOOM
        init_fn 167
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 141: CLEANSWEEP
        attack_anim_prop CLEANSWEEP
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 208
        bg1_script CLEANSWEEP_BG1
        bg1_pal 120
        sfx CLEANSWEEP
        init_fn 92
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 142: AQUA_RAKE
        attack_anim_prop AQUA_RAKE
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 185
        bg1_script AQUA_RAKE_BG1
        bg1_pal 185
        sfx AQUA_RAKE
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 143: AERO
        attack_anim_prop AERO
        sprite_script AERO_SPRITE
        sprite_pal 225
        bg1_script AERO_BG1
        bg1_pal 171
        bg3_script AERO_BG3
        bg3_pal 50
        sfx FLASH_RAIN
        init_fn 16
        delay 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 144: BLOW_FISH
        attack_anim_prop BLOW_FISH
        sprite_script BLOW_FISH_SPRITE
        sprite_pal 58
        sfx NEEDLES
        init_fn 86
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 145: BIG_GUARD
        attack_anim_prop BIG_GUARD
        sprite_script BIG_GUARD_SPRITE
        sprite_pal 56
        bg1_gfx BIG_GUARD_BG1
        bg1_pal 218
        bg3_pal 78
        sfx BIG_GUARD
        init_fn 28
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 146: REVENGE
        attack_anim_prop REVENGE
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script UNARMED_HIT_BG1
        bg1_pal 16
        sfx REVENGE
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 147: WHITE_WIND
        attack_anim_prop WHITE_WIND
        sprite_script CURA_SPRITE
        sprite_pal 120
        bg1_script WHITE_WIND_BG1
        bg1_pal 120
        sfx WHITE_WIND
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 148: L5_DOOM
        attack_anim_prop L5_DOOM
        sprite_script L5_DOOM_SPRITE
        sprite_pal 231
        sfx DOOM
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 149: L4_FLARE
        attack_anim_prop L4_FLARE
        sprite_script L4_FLARE_SPRITE
        sprite_pal 57
        bg1_script L4_FLARE_BG1
        bg1_pal 57
        extra_gfx L4_FLARE_EXTRA
        sfx FLARE_B
        init_fn 94
        delay 48
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 150: L3_CONFUSE
        attack_anim_prop L3_CONFUSE
        sprite_script CONFUSE_SPRITE
        sprite_pal 63
        bg1_script CONFUSE_BG1
        bg1_pal 63
        sfx CONFUSE
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 151: REFLECT_LORE
        attack_anim_prop REFLECT_LORE
        sprite_script DEMI_SPRITE
        sprite_pal 225
        sfx DEMI
        init_fn 103
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 152: PEARL_LORE
        attack_anim_prop PEARL_LORE
        sprite_script PEARL_LORE_SPRITE
        sprite_pal 82
        bg1_gfx PEARL_LORE_BG1
        bg1_pal 82
        bg3_pal 112
        sfx PEARL_LORE
        init_fn 27
        delay 42
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 153: STEP_MINE
        attack_anim_prop STEP_MINE
        sprite_script STEP_MINE_SPRITE
        sprite_pal 208
        bg1_script STEP_MINE_BG1
        bg1_pal 208
        sfx STEP_MINE
        init_fn 21
        delay 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 154: FORCEFIELD
        attack_anim_prop FORCEFIELD
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg3_script FORCEFIELD_BG3
        bg3_pal 78
        sfx FORCE_FIELD
        init_fn 101
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 155: DISCHORD
        attack_anim_prop DISCHORD
        sprite_gfx DISCHORD_SPRITE
        bg1_script CHAR_GFX_BG1
        extra_gfx DISCHORD_SPRITE
        sfx BERSERK
        init_fn 157
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 156: SOUR_MOUTH
        attack_anim_prop SOUR_MOUTH
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg3_script BIO_BLASTER_BG3
        bg3_pal 234
        sfx BIO_BLASTER
        init_fn 3
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 157: PEP_UP
        attack_anim_prop PEP_UP
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script PEP_UP_BG1
        sfx FLASH
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 158: RIPPLER
        attack_anim_prop RIPPLER
        sprite_script RIPPLER_SPRITE
        sprite_pal 120
        bg1_script RIPPLER_BG1
        bg1_pal 170
        sfx RIPPLER
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 159: STONE
        attack_anim_prop STONE
        sprite_script STONE_SPRITE
        sprite_pal 100
        bg1_script STONE_BG1
        bg1_pal 54
        sfx STONE_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 160: QUASAR
        attack_anim_prop QUASAR
        sprite_gfx QUASAR_SPRITE
        sprite_pal 200
        bg1_script QUASAR_BG1
        bg1_pal 164
        bg3_script QUASAR_BG3
        bg3_pal 173
        extra_gfx QUASAR_SPRITE
        sfx QUASAR
        init_fn 95
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 161: GRANDTRAIN
        attack_anim_prop GRANDTRAIN
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script GRANDTRAIN_BG1
        bg1_pal 89
        bg3_script GRANDTRAIN_BG3
        bg3_pal 94
        sfx GRAND_TRAIN
        init_fn 93
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 162: EXPLODER
        attack_anim_prop EXPLODER
        sprite_script EXPLODER_SPRITE
        sprite_pal 56
        bg1_script EXPLODER_BG1
        bg1_pal 56
        sfx BURNING_HOUSE
        init_fn 86
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 163: IMP_SONG
        attack_anim_prop IMP_SONG
        sprite_script IMP_SONG_SPRITE
        sprite_pal 85
        bg1_script IMP_SONG_BG1
        bg1_pal 167
        sfx IMP_SONG
        init_fn 86
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 164: CLEAR
        attack_anim_prop CLEAR
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg3_script CLEAR_BG3
        bg3_pal 164
        sfx IMP_SONG
        init_fn 88
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 165: VIRITE
        attack_anim_prop VIRITE
        sprite_script VIRITE_SPRITE
        sfx SMOKE_BOMB
        init_fn 86
        delay 20
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 166: CHOKESMOKE
        attack_anim_prop CHOKESMOKE
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 226
        bg1_script CHOKESMOKE_BG1
        bg1_pal 226
        sfx BLUE_MAN
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 167: SCHILLER
        attack_anim_prop SCHILLER
        sprite_gfx SCHILLER_SPRITE
        extra_gfx SCHILLER_SPRITE
        sfx MAGICITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 168: LULLABY
        attack_anim_prop LULLABY
        sprite_script LULLABY_SPRITE
        sprite_pal 167
        bg1_script IMP_SONG_BG1
        bg1_pal 167
        sfx IMP_SONG
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 169: ACID_RAIN
        attack_anim_prop ACID_RAIN
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script FLASH_RAIN_BG1
        bg1_pal 168
        sfx ACID_RAIN
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 170: CONFUSION
        attack_anim_prop CONFUSION
        sprite_script CONFUSE_SPRITE
        sprite_pal 63
        bg1_pal 63
        sfx CONFUSE
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 171: MEGAZERK
        attack_anim_prop MEGAZERK
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script MEGAZERK_BG1
        sfx BERSERK
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 172: ENEMY_MUTE
        attack_anim_prop ENEMY_MUTE
        sprite_script MUTE_SPRITE
        sprite_pal 58
        bg1_script MUTE_BG1
        bg1_pal 228
        sfx SMOKE_BOMB
        init_fn 71
        delay 40
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 173: NET
        attack_anim_prop NET
        sprite_script NET_SPRITE
        sprite_pal 120
        sfx NET
        init_fn 86
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 174: SLIMER
        attack_anim_prop SLIMER
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script SLIMER_BG1
        bg1_pal 157
        sfx SLIMER
        init_fn 90
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 175: DELTA_HIT
        attack_anim_prop DELTA_HIT
        sprite_gfx DELTA_HIT_SPRITE
        sprite_pal 122
        bg1_script DELTA_HIT_BG1
        bg1_pal 169
        extra_gfx DELTA_HIT_SPRITE
        sfx DELTA_HIT
        init_fn 91
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 176: ENTWINE
        attack_anim_prop ENTWINE
        sprite_script ENTWINE_SPRITE
        sprite_pal 58
        sfx SHRAPNEL
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 177: BLASTER
        attack_anim_prop BLASTER
        sprite_script BLASTER_SPRITE
        sprite_pal 57
        sfx BLASTER
        init_fn 71
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 178: CYCLONIC
        attack_anim_prop CYCLONIC
        sprite_script CYCLONIC_SPRITE
        sprite_pal 225
        bg1_script CYCLONIC_BG1
        bg1_pal 175
        sfx SAND_STORM
        init_fn 27
        delay 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 179: FIRE_BALL
        attack_anim_prop FIRE_BALL
        sprite_script FIRE_BALL_SPRITE
        sprite_pal 56
        sfx BURNING_HOUSE
        init_fn 87
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 180: ATOMIC_RAY
        attack_anim_prop ATOMIC_RAY
        sprite_script ATOMIC_RAY_SPRITE
        sprite_pal 56
        bg1_script ATOMIC_RAY_BG1
        bg1_pal 60
        sfx ATOMIC_RAY_A
        init_fn 71
        delay 32
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 181: TEK_LASER
        attack_anim_prop TEK_LASER
        sprite_script TEK_LASER_SPRITE
        sprite_pal 120
        bg1_script TEK_LASER_BG1
        bg1_pal 51
        sfx PEARL_LORE
        init_fn 78
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 182: DIFFUSER
        attack_anim_prop DIFFUSER
        sprite_gfx DIFFUSER_SPRITE
        sprite_pal 122
        bg1_script DIFFUSER_BG1
        bg1_pal 48
        bg3_script DIFFUSER_BG3
        bg3_pal 51
        extra_gfx DIFFUSER_SPRITE
        sfx DIFFUSER
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 183: WAVECANNON
        attack_anim_prop WAVECANNON
        sprite_script WAVECANNON_SPRITE
        sprite_pal 120
        bg1_script WAVECANNON_BG1
        bg1_pal 127
        sfx WAVE_CANNON
        init_fn 118
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 184: MEGA_VOLT
        attack_anim_prop MEGA_VOLT
        sprite_script THUNDARA_SPRITE
        sprite_pal 97
        bg1_gfx THUNDARA_BG1
        bg1_pal 105
        sfx THUNDARA
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 185: GIGA_VOLT
        attack_anim_prop GIGA_VOLT
        sprite_script THUNDAGA_SPRITE
        sprite_pal 97
        bg1_gfx THUNDAGA_BG1
        bg1_pal 86
        sfx THUNDAGA
        init_fn 27
        delay 40
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 186: SNOWSTORM
        attack_anim_prop SNOWSTORM
        sprite_script SNOWSTORM_SPRITE
        sprite_pal 82
        bg1_script SNOWSTORM_BG1
        bg1_pal 10
        sfx SNOWSTORM
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 187: ABSOLUTE0
        attack_anim_prop ABSOLUTE0
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script ABSOLUTE0_BG1
        bg1_pal 120
        sfx DRAIN
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 188: MAGNITUDE8
        attack_anim_prop MAGNITUDE8
        sprite_script MAGNITUDE8_SPRITE
        bg1_script MAGNITUDE8_BG1
        sfx QUAKE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 189: RAID
        attack_anim_prop RAID
        sprite_script DRAIN_SPRITE
        sprite_pal 76
        bg1_script DRAIN_BG1
        bg1_pal 90
        sfx DRAIN
        init_fn 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 190: FLASH_RAIN
        attack_anim_prop FLASH_RAIN
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script FLASH_RAIN_BG1
        bg1_pal 51
        bg3_script FLASH_RAIN_BG3
        bg3_pal 49
        sfx FLASH_RAIN
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 191: TEKBARRIER
        attack_anim_prop TEKBARRIER
        sprite_script TEKBARRIER_SPRITE
        sprite_pal 69
        bg1_script TEKBARRIER_BG1
        bg1_pal 96
        bg3_script TEKBARRIER_BG3
        bg3_pal 73
        sfx MAGITEK_BARRIER
        init_fn 32
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 192: FALLEN_ONE
        attack_anim_prop FALLEN_ONE
        sprite_script RAISE_SPRITE
        sprite_pal 63
        sfx RAISE_A
        init_fn 20
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 193: WALLCHANGE
        attack_anim_prop WALLCHANGE
        sprite_gfx WALLCHANGE_SPRITE
        extra_gfx WALLCHANGE_SPRITE
        sfx BERSERK
        init_fn 29
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 194: ESCAPE
        attack_anim_prop ESCAPE
        sprite_gfx ESCAPE_SPRITE
        extra_gfx ESCAPE_SPRITE
        sfx ESCAPE
        init_fn 29
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 195: FIFTY_GS
        attack_anim_prop FIFTY_GS
        sprite_script FIFTY_GS_SPRITE
        sprite_pal 120
        bg1_script FIFTY_GS_BG1
        sfx SFX_173
        init_fn 84
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 196: MIND_BLAST
        attack_anim_prop MIND_BLAST
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script MIND_BLAST_BG1
        bg1_pal 99
        bg3_script MIND_BLAST_BG3
        bg3_pal 99
        sfx MIND_BLAST
        init_fn 98
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 197: N_CROSS
        attack_anim_prop N_CROSS
        sprite_script BLIZZARA_SPRITE
        sprite_pal 84
        bg1_gfx BLIZZARA_BG1
        bg1_pal 86
        bg3_script N_CROSS_BG3
        sfx BLIZZARA_A
        init_fn 16
        delay 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 198: FLARE_STAR
        attack_anim_prop FLARE_STAR
        sprite_script FLARE_STAR_SPRITE
        sprite_pal 56
        bg1_script FLARE_STAR_BG1
        bg1_pal 102
        bg3_script FLARE_STAR_BG3
        bg3_pal 94
        sfx FLARE_STAR
        init_fn 97
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 199: LOVE_TOKEN
        attack_anim_prop LOVE_TOKEN
        sprite_script LOVE_TOKEN_SPRITE
        sprite_pal 57
        sfx BLASTER
        init_fn 87
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 200: SEIZE
        attack_anim_prop SEIZE
        sprite_script SEIZE_SPRITE
        sprite_pal 59
        bg1_script SEIZE_BG1
        sfx STEAL
        init_fn 226
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 201: R_POLARITY
        attack_anim_prop R_POLARITY
        sprite_script R_POLARITY_SPRITE
        bg1_script R_POLARITY_BG1
        sfx REVERSE_POLARITY
        init_fn 16
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 202: TARGETTING
        attack_anim_prop TARGETTING
        sprite_script SCAN_SPRITE
        sprite_pal 58
        bg1_script SCAN_BG1
        bg1_pal 93
        sfx SCAN
        init_fn 25
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 203: SNEEZE
        attack_anim_prop SNEEZE
        sprite_script SNEEZE_SPRITE
        sprite_pal 171
        bg1_pal 171
        sfx DRAIN
        init_fn 79
        delay 63
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 204: S_CROSS
        attack_anim_prop S_CROSS
        sprite_gfx S_CROSS_SPRITE
        sprite_pal 182
        bg1_script S_CROSS_BG1
        bg1_pal 176
        extra_gfx S_CROSS_SPRITE
        sfx S_CROSS
        init_fn 99
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 205: LAUNCHER
        attack_anim_prop LAUNCHER
        sprite_script TEKMISSILE_SPRITE
        sprite_pal 162
        sfx MAGITEK_MISSILE
        init_fn 92
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 206: CHARM
        attack_anim_prop CHARM
        sprite_script CHARM_SPRITE
        sprite_pal 187
        sfx IMP_SONG
        init_fn 103
        delay 64
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 207: COLD_DUST
        attack_anim_prop COLD_DUST
        sprite_script COLD_DUST_SPRITE
        sprite_pal 120
        bg1_script COLD_DUST_BG1
        bg1_pal 120
        sfx MAGITEK_BEAM
        init_fn 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 208: TENTACLE
        attack_anim_prop TENTACLE
        sprite_script TENTACLE_SPRITE
        sprite_pal 179
        sfx TENTACLE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 209: HYPERDRIVE
        attack_anim_prop HYPERDRIVE
        sprite_script HYPERDRIVE_SPRITE
        sprite_pal 229
        bg1_script HYPERDRIVE_BG1
        bg1_pal 232
        sfx FLARE_B
        init_fn 114
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 210: TRAIN
        attack_anim_prop TRAIN
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 56
        bg1_script TRAIN_BG1
        bg1_pal 127
        bg3_script TRAIN_BG3
        bg3_pal 76
        sfx GRAND_TRAIN
        init_fn 93
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 211: EVIL_TOOT
        attack_anim_prop EVIL_TOOT
        sprite_gfx EVIL_TOOT_SPRITE
        sprite_pal 199
        extra_gfx EVIL_TOOT_SPRITE
        sfx PHANTOM
        init_fn 91
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 212: GRAV_BOMB
        attack_anim_prop GRAV_BOMB
        sprite_script GRAV_BOMB_SPRITE
        sprite_pal 154
        bg1_script GRAV_BOMB_BG1
        bg1_pal 152
        sfx EVENT_HIT
        init_fn 83
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 213: ENGULF
        attack_anim_prop ENGULF
        sprite_script ENGULF_SPRITE
        bg1_script ENGULF_BG1
        bg1_pal 103
        bg3_script ENGULF_BG3
        bg3_pal 136
        sfx ENGULF
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 214: DISASTER
        attack_anim_prop DISASTER
        sprite_script DISASTER_SPRITE
        sprite_pal 177
        bg1_script DISASTER_BG1
        bg1_pal 177
        sfx WILL_O_THE_WISP
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 215: SHRAPNEL
        attack_anim_prop SHRAPNEL
        sprite_script SHRAPNEL_SPRITE
        sprite_pal 58
        bg1_script SHRAPNEL_BG1
        bg1_pal 54
        sfx SHRAPNEL
        init_fn 27
        delay 24
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 216: BOMBLET
        attack_anim_prop BOMBLET
        sprite_script ATTACK_ANIM_SCRIPT_638
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 217: HEART_BURN
        attack_anim_prop HEART_BURN
        sprite_script HEART_BURN_SPRITE
        sprite_pal 120
        bg1_pal 183
        sfx BIO_BLASTER
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 218: ZINGER
        attack_anim_prop ZINGER
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script ZINGER_BG1
        sfx SFX_173
        init_fn 226
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 219: DISCARD
        attack_anim_prop DISCARD
        sprite_script DISCARD_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 220: OVERCAST
        attack_anim_prop OVERCAST
        sprite_script OVERCAST_SPRITE
        sprite_pal 230
        bg1_script OVERCAST_BG1
        bg1_pal 120
        sfx DRAIN
        init_fn 100
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 221: MISSILE
        attack_anim_prop MISSILE
        sprite_gfx TEKMISSILE_SPRITE
        sprite_pal 162
        extra_gfx TEKMISSILE_SPRITE
        sfx MAGITEK_MISSILE
        init_fn 92
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 222: GONER
        attack_anim_prop GONER
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script GONER_BG1
        bg1_pal 174
        bg3_script GONER_BG3
        bg3_pal 136
        sfx CRUSADER
        init_fn 96
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 223: METEO
        attack_anim_prop METEO
        sprite_script METEO_SPRITE
        sprite_pal 56
        bg3_script METEO_BG3
        sfx BURNING_HOUSE
        init_fn 87
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 224: REVENGER
        attack_anim_prop REVENGER
        sprite_gfx REVENGER_SPRITE
        bg1_script CONFUSER_BG1
        extra_gfx REVENGER_SPRITE
        sfx SFX_173
        init_fn 84
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 225: PHANTASM
        attack_anim_prop PHANTASM
        sprite_script PHANTASM_SPRITE
        sprite_pal 56
        bg3_script PHANTASM_BG3
        bg3_pal 55
        sfx THUNDER
        init_fn 35
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 226: DREAD
        attack_anim_prop DREAD
        sprite_script DREAD_SPRITE
        sprite_pal 122
        sfx POISON
        init_fn 21
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 227: SHOCK_WAVE
        attack_anim_prop SHOCK_WAVE
        sprite_script SHOCK_WAVE_SPRITE
        sprite_pal 201
        bg1_script SHOCK_WAVE_BG1
        bg1_pal 201
        sfx SHOCK_WAVE_A
        init_fn 34
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 228: BLAZE
        attack_anim_prop BLAZE
        sprite_script FIRE_SPRITE
        sprite_pal 120
        sfx FIRE
        init_fn 37
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 229: SOUL_OUT
        attack_anim_prop SOUL_OUT
        sprite_script SOUL_OUT_SPRITE
        sprite_pal 202
        bg1_script SOUL_OUT_BG1
        sfx SOUL_OUT
        init_fn 243
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 230: GALE_CUT
        attack_anim_prop GALE_CUT
        sprite_script WIND_SLASH_SPRITE
        sprite_pal 58
        bg1_script WIND_SLASH_BG1
        bg1_pal 203
        sfx ESUNA
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 231: SHIMSHAM
        attack_anim_prop SHIMSHAM
        sprite_script SONIC_BOOM_SPRITE
        sprite_pal 81
        sfx REFLECT
        init_fn 37
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 232: LODE_STONE
        attack_anim_prop LODE_STONE
        sprite_script CAVE_IN_SPRITE
        sprite_pal 120
        sfx CAVE_IN
        init_fn 77
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 233: SCAR_BEAM
        attack_anim_prop SCAR_BEAM
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 158
        bg1_script HARVESTER_BG1
        bg1_pal 56
        bg3_script HARVESTER_BG3
        bg3_pal 56
        sfx BERSERK
        init_fn 72
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 234: BABABREATH
        attack_anim_prop BABABREATH
        sprite_script BABABREATH_SPRITE
        bg1_script SAND_STORM_BG1
        bg1_pal 204
        sfx SAND_STORM
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 235: LIFESHAVER
        attack_anim_prop LIFESHAVER
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script LIFESHAVER_BG1
        bg1_pal 205
        sfx LIFESHAVER
        init_fn 73
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 236: FIRE_WALL
        attack_anim_prop FIRE_WALL
        sprite_script ELF_FIRE_SPRITE
        sprite_pal 81
        sfx PHANTOM
        init_fn 74
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 237: SLIDE
        attack_anim_prop SLIDE
        sprite_script SURGE_SPRITE
        sprite_pal 142
        bg1_script SURGE_BG1
        bg1_pal 142
        bg3_script SURGE_BG3
        bg3_pal 136
        sfx SURGE
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 238: BATTLE
        attack_anim_prop BATTLE
        sprite_script MONSTER_FIGHT_BG1
        init_fn 11
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 239: SPECIAL
        attack_anim_prop SPECIAL
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 240: RIOT_BLADE
        attack_anim_prop RIOT_BLADE
        sprite_script RIOT_BLADE_SPRITE
        sprite_pal 48
        extra_script SUPER_BALL_EXTRA
        sfx MAGITEK_BEAM
        init_fn 71
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 241: MIRAGER
        attack_anim_prop MIRAGER
        sprite_script MIRAGER_SPRITE
        bg1_script MIRAGER_BG1
        sfx BUM_RUSH
        init_fn 230
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 242: BACK_BLADE
        attack_anim_prop BACK_BLADE
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg3_script BACK_BLADE_BG3
        bg3_pal 123
        sfx CLEAVE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 243: SHADOWFANG
        attack_anim_prop SHADOWFANG
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script SHADOWFANG_BG1
        bg1_pal 53
        sfx CLAW
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 244: ROYALSHOCK
        attack_anim_prop ROYALSHOCK
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script ROYALSHOCK_BG1
        bg1_pal 51
        sfx DRAIN
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 245: TIGERBREAK
        attack_anim_prop TIGERBREAK
        sprite_gfx TIGERBREAK_SPRITE
        bg1_script TIGERBREAK_BG1
        extra_script TIGERBREAK_SPRITE
        sfx CLEAVE
        init_fn 110
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 246: SPIN_EDGE
        attack_anim_prop SPIN_EDGE
        sprite_gfx SPIN_EDGE_SPRITE
        sprite_pal 24
        bg1_script SPIN_EDGE_BG1
        bg1_pal 24
        bg3_pal 24
        extra_script SPIN_EDGE_SPRITE
        sfx STEAL
        init_fn 10
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 247: SABRESOUL
        attack_anim_prop SABRESOUL
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script SABRESOUL_BG1
        sfx REVERSE_POLARITY
        init_fn 167
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 248: STAR_PRISM
        attack_anim_prop STAR_PRISM
        sprite_script STAR_PRISM_SPRITE
        sprite_pal 67
        bg1_script STAR_PRISM_BG1
        bg1_pal 67
        sfx CURE_A
        init_fn 164
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 249: RED_CARD
        attack_anim_prop RED_CARD
        sprite_script ATTACK_ANIM_SCRIPT_638
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 250: MOOGLERUSH
        attack_anim_prop MOOGLERUSH
        sprite_script PUMMEL_SPRITE
        sprite_pal 188
        bg1_script UNARMED_HIT_BG1
        bg1_pal 54
        sfx PUMMEL
        init_fn 9
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 251: X_METEO
        attack_anim_prop X_METEO
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script X_METEO_BG1
        bg1_pal 100
        sfx FIRAGA
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 252: TAKEDOWN
        attack_anim_prop TAKEDOWN
        sprite_script TAKEDOWN_SPRITE
        sprite_pal 191
        bg1_script TAKEDOWN_BG1
        bg1_pal 54
        sfx DOG_BARK
        init_fn 10
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 253: WILD_FANG
        attack_anim_prop WILD_FANG
        sprite_script WILD_FANG_SPRITE
        sprite_pal 191
        sfx DOG_BARK
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 254: LAGOMORPH
        attack_anim_prop LAGOMORPH
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script LAGOMORPH_BG1
        bg1_pal 149
        sfx LAGOMORPH
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 255: NONE
        attack_anim_prop NONE
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 256: STEP_FORWARD
        attack_anim_prop STEP_FORWARD
        sprite_gfx STEP_FORWARD_SPRITE
        bg3_pal 136
        extra_gfx STEP_FORWARD_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 257: TERRA_TRITOCH
        attack_anim_prop TERRA_TRITOCH
        sprite_script TERRA_TRITOCH_SPRITE
        sprite_pal 56
        bg1_script TERRA_TRITOCH_BG1
        bg1_pal 180
        bg3_script TERRA_TRITOCH_BG3
        bg3_pal 134
        init_fn 86
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 258: BLIZZARD_FIST
        attack_anim_prop BLIZZARD_FIST
        bg1_script BLIZZARD_FIST_BG1
        bg1_pal 181
        bg3_script BLIZZARD_FIST_BG3
        bg3_pal 78
        sfx BLIZZARD_FIST
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 259: TERRA_TRITOCH_ALT
        attack_anim_prop TERRA_TRITOCH_ALT
        bg1_script TERRA_TRITOCH_ALT_BG1
        bg1_pal 180
        bg3_script TERRA_TRITOCH_BG3
        bg3_pal 134
        init_fn 86
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 260: WATER_SPLASH_BG1
        attack_anim_prop WATER_SPLASH_BG1
        sprite_pal 82
        bg1_script WATER_SPLASH_BG1
        bg1_pal 82
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 261: WATER_SPLASH_SPRITE
        attack_anim_prop WATER_SPLASH_SPRITE
        sprite_script WATER_SPLASH_SPRITE
        sprite_pal 82
        init_fn 71
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 262: EVENT_BAHAMUT
        attack_anim_prop EVENT_BAHAMUT
        bg1_script EVENT_BAHAMUT_BG1
        init_fn 66
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 263: EVENT_ZONESEEK
        attack_anim_prop EVENT_ZONESEEK
        sprite_pal 219
        bg1_script EVENT_ZONESEEK_BG1
        bg1_pal 127
        sfx GRAND_TRAIN
        init_fn 55
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 264: EVENT_FENRIR
        attack_anim_prop EVENT_FENRIR
        bg1_script EVENT_FENRIR_BG1
        init_fn 70
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 265: EVENT_TERRATO
        attack_anim_prop EVENT_TERRATO
        bg1_script EVENT_TERRATO_BG1
        sfx ESCAPE
        init_fn 121
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 266: EVENT_SHIVA
        attack_anim_prop EVENT_SHIVA
        bg1_script EVENT_SHIVA_BG1
        init_fn 121
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 267: EVENT_KIRIN
        attack_anim_prop EVENT_KIRIN
        bg1_script EVENT_KIRIN_BG1
        sfx PRE_BLACK
        init_fn 121
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 268: EVENT_BISMARK
        attack_anim_prop EVENT_BISMARK
        bg1_script EVENT_BISMARK_BG1
        sfx PRE_WHITE_EFFECT
        init_fn 121
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 269: EVENT_CARBUNKL
        attack_anim_prop EVENT_CARBUNKL
        bg1_script EVENT_CARBUNKL_BG1
        sfx PRE_GENJU_A
        init_fn 121
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 270: EVENT_PHANTOM
        attack_anim_prop EVENT_PHANTOM
        bg1_script EVENT_PHANTOM_BG1
        init_fn 109
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 271: TRANSFORM_MAGICITE
        attack_anim_prop TRANSFORM_MAGICITE
        sprite_script TRANSFORM_MAGICITE_SPRITE
        sprite_pal 236
        bg3_script TRANSFORM_MAGICITE_BG3
        bg3_pal 94
        sfx REGEN
        init_fn 122
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 272: MOVE_FORWARD_SLOW
        attack_anim_prop MOVE_FORWARD_SLOW
        sprite_script MOVE_FORWARD_SLOW_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 273: MOVE_BACK_SLOW
        attack_anim_prop MOVE_BACK_SLOW
        sprite_script MOVE_BACK_SLOW_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 274: FLASH_RED
        attack_anim_prop FLASH_RED
        bg1_script FLASH_RED_BG1
        init_fn 157
        delay 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 275: RUNIC_ABSORB
        attack_anim_prop RUNIC_ABSORB
        sprite_script RUNIC_ABSORB_SPRITE
        sprite_pal 24
        bg1_script STEP_FORWARD_BG1
        sfx RUNIC_ABSORB
        init_fn 16
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 276: UMARO_THROW
        attack_anim_prop UMARO_THROW
        sprite_script UMARO_THROW_SPRITE
        bg1_script UMARO_THROW_BG1
        sfx STEAL
        init_fn 126
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 277: UMARO_TACKLE
        attack_anim_prop UMARO_TACKLE
        sprite_script UMARO_TACKLE_SPRITE
        sfx STEAL
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 278: POSSESS
        attack_anim_prop POSSESS
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script POSSESS_BG1
        sfx PHANTOM
        init_fn 247
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 279: JUMP_UNARMED
        attack_anim_prop JUMP_UNARMED
        sprite_gfx JUMP_UNARMED_SPRITE
        extra_script JUMP_UNARMED_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 280: JUMP_CMD
        attack_anim_prop JUMP_CMD
        sprite_gfx JUMP_CMD_SPRITE
        extra_script JUMP_CMD_SPRITE
        sfx JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 281: ATTACK_GFX_281
        attack_anim_prop ATTACK_GFX_281
        sprite_pal 22
        sfx SKETCH
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 282: STEP_FORWARD_ALT
        attack_anim_prop STEP_FORWARD_ALT
        sprite_gfx MONSTER_ATTACK_SPRITE
        extra_script MONSTER_ATTACK_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 283: MORPH
        attack_anim_prop MORPH
        bg1_script MORPH_CMD_BG1
        bg1_pal 16
        sfx PRE_BUSHIDO
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 284: BLACK_MAGIC
        attack_anim_prop BLACK_MAGIC
        bg1_script BLACK_MAGIC_CMD_BG1
        bg1_pal 8
        sfx PRE_BLACK
        init_fn 15
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 285: WHITE_MAGIC
        attack_anim_prop WHITE_MAGIC
        sprite_gfx WHITE_MAGIC_CMD_SPRITE
        sprite_pal 12
        bg1_script WHITE_MAGIC_CMD_BG1
        bg1_pal 12
        extra_script WHITE_MAGIC_CMD_SPRITE
        sfx PRE_WHITE_EFFECT
        init_fn 17
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 286: SUMMON
        attack_anim_prop SUMMON
        sprite_gfx SUMMON_CMD_SPRITE
        sprite_pal 197
        bg1_script SUMMON_CMD_BG1
        bg1_pal 197
        extra_script SUMMON_CMD_SPRITE
        sfx PRE_GENJU_A
        init_fn 18
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 287: LORE
        attack_anim_prop LORE
        bg1_script LORE_CMD_BG1
        bg1_pal 15
        init_fn 19
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 288: REVERT
        attack_anim_prop REVERT
        sprite_gfx REVERT_CMD_SPRITE
        extra_script REVERT_CMD_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 289: STEAL
        attack_anim_prop STEAL
        sprite_gfx STEAL_CMD_SPRITE
        extra_script STEAL_CMD_SPRITE
        sfx STEAL
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 290: BUSHIDO
        attack_anim_prop BUSHIDO
        bg1_script BUSHIDO_CMD_BG1
        bg1_pal 15
        sfx PRE_BUSHIDO
        init_fn 19
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 291: BLITZ
        attack_anim_prop BLITZ
        bg1_script BLITZ_CMD_SPRITE
        bg1_pal 21
        sfx PRE_BLITZ
        init_fn 15
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 292: RUNIC
        attack_anim_prop RUNIC
        sprite_gfx RUNIC_CMD_SPRITE
        sprite_pal 12
        extra_script RUNIC_CMD_SPRITE
        sfx RUNIC
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 293: DANCE
        attack_anim_prop DANCE
        sprite_gfx DANCE_CMD_SPRITE
        extra_script DANCE_CMD_SPRITE
        sfx PRE_DANCE_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 294: SHOCK
        attack_anim_prop SHOCK
        bg1_script SHOCK_BG1
        bg1_pal 82
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 295: JUMP_MONSTER_UP
        attack_anim_prop JUMP_MONSTER_UP
        bg1_script JUMP_MONSTER_UP_BG1
        sfx JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 296: GP_RAIN
        attack_anim_prop GP_RAIN
        sprite_script GP_RAIN_SPRITE
        sprite_pal 24
        extra_script GP_RAIN_EXTRA
        sfx EVENT_JUMP
        init_fn 94
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 297: JUMP_MONSTER_DOWN
        attack_anim_prop JUMP_MONSTER_DOWN
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script JUMP_MONSTER_DOWN_BG1
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 298: JUMP_CHAR_MISS
        attack_anim_prop JUMP_CHAR_MISS
        sprite_gfx JUMP_CHAR_MISS_SPRITE
        extra_script JUMP_CHAR_MISS_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 299: JUMP_MONSTER_MISS
        attack_anim_prop JUMP_MONSTER_MISS
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script JUMP_MONSTER_MISS_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 300: SKETCH
        attack_anim_prop SKETCH
        sprite_gfx SKETCH_CMD_SPRITE
        bg1_script SKETCH_CMD_BG1
        bg3_script SKETCH_CMD_BG3
        bg3_pal 136
        extra_script SKETCH_CMD_SPRITE
        sfx SKETCH
        init_fn 47
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 301: LEAP
        attack_anim_prop LEAP
        sprite_script LEAP_CMD_SPRITE
        sfx STEAL
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 302: HEALTH
        attack_anim_prop HEALTH
        sprite_script CURA_SPRITE
        sprite_pal 86
        sfx CURA
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 303: RUN
        attack_anim_prop RUN
        sprite_script RUN_SPRITE
        sfx ESCAPE
        init_fn 89
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 304: JUMP_THICK_KNIFE
        attack_anim_prop JUMP_THICK_KNIFE
        sprite_gfx JUMP_THICK_KNIFE_SPRITE
        sprite_pal 24
        extra_script JUMP_THICK_KNIFE_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 305: JUMP_THIN_KNIFE
        attack_anim_prop JUMP_THIN_KNIFE
        sprite_gfx JUMP_THIN_KNIFE_SPRITE
        sprite_pal 24
        extra_script JUMP_THIN_KNIFE_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 306: JUMP_SWORD
        attack_anim_prop JUMP_SWORD
        sprite_gfx JUMP_SWORD_SPRITE
        sprite_pal 24
        extra_script JUMP_SWORD_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 307: JUMP_KATANA
        attack_anim_prop JUMP_KATANA
        sprite_gfx JUMP_KATANA_SPRITE
        sprite_pal 24
        extra_script JUMP_KATANA_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 308: JUMP_ROD
        attack_anim_prop JUMP_ROD
        sprite_gfx JUMP_ROD_SPRITE
        sprite_pal 24
        extra_script JUMP_ROD_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 309: JUMP_SPEAR
        attack_anim_prop JUMP_SPEAR
        sprite_gfx JUMP_SPEAR_SPRITE
        sprite_pal 24
        extra_script JUMP_SPEAR_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 310: JUMP_HAWK_EYE
        attack_anim_prop JUMP_HAWK_EYE
        sprite_gfx JUMP_HAWK_EYE_SPRITE
        sprite_pal 24
        extra_script JUMP_HAWK_EYE_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 311: JUMP_UNUSED
        attack_anim_prop JUMP_UNUSED
        sprite_gfx JUMP_UNUSED_SPRITE
        sprite_pal 24
        extra_script JUMP_UNUSED_SPRITE
        sfx SFX_228
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 312: THROW_THICK_KNIFE
        attack_anim_prop THROW_THICK_KNIFE
        sprite_script THROW_THICK_KNIFE_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 313: THROW_THIN_KNIFE
        attack_anim_prop THROW_THIN_KNIFE
        sprite_script THROW_THIN_KNIFE_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 314: THROW_SWORD
        attack_anim_prop THROW_SWORD
        sprite_script THROW_SWORD_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 315: THROW_KATANA
        attack_anim_prop THROW_KATANA
        sprite_script THROW_KATANA_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 316: THROW_ROD
        attack_anim_prop THROW_ROD
        sprite_script THROW_ROD_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 317: THROW_SPEAR
        attack_anim_prop THROW_SPEAR
        sprite_script THROW_SPEAR_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 318: THROW_HAWK_EYE
        attack_anim_prop THROW_HAWK_EYE
        sprite_script THROW_HAWK_EYE_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 319: THROW_ARISE
        attack_anim_prop THROW_ARISE
        sprite_script ARISE_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 320: THROW_FIRE_SKEAN
        attack_anim_prop THROW_FIRE_SKEAN
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script FIRE_SKEAN_BG1
        bg1_pal 56
        sfx FIRAGA
        init_fn 27
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 321: THROW_WATER_EDGE
        attack_anim_prop THROW_WATER_EDGE
        sprite_gfx WATER_EDGE_SPRITE
        sprite_pal 120
        bg1_script WATER_EDGE_BG1
        bg1_pal 120
        extra_gfx WATER_EDGE_SPRITE
        sfx CLEANSWEEP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 322: THROW_BOLT_EDGE
        attack_anim_prop THROW_BOLT_EDGE
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script BOLT_EDGE_BG1
        bg1_pal 123
        bg3_script BOLT_EDGE_BG3
        bg3_pal 55
        sfx THUNDER
        init_fn 81
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 323: THROW_INVIZ_EDGE
        attack_anim_prop THROW_INVIZ_EDGE
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 143
        bg1_script INVIZ_EDGE_BG1
        bg1_pal 143
        bg3_script RAGE_BG3
        bg3_pal 143
        sfx RAGE_DANCE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 324: THROW_SHADOW_EDGE
        attack_anim_prop THROW_SHADOW_EDGE
        sprite_script SHADOW_EDGE_SPRITE
        bg1_script CONFUSER_BG1
        sfx SHADOW_EDGE
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 325: THROW_FULL_MOON
        attack_anim_prop THROW_FULL_MOON
        sprite_script THROW_FULL_MOON_SPRITE
        sprite_pal 28
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 326: THROW_BOOMERANG
        attack_anim_prop THROW_BOOMERANG
        sprite_script THROW_BOOMERANG_SPRITE
        sprite_pal 24
        sfx EVENT_JUMP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 327: THROW_UNUSED
        attack_anim_prop THROW_UNUSED
        sprite_script ATTACK_ANIM_SCRIPT_638
        sprite_pal 24
        sfx EVENT_JUMP
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 328: NOISEBLASTER
        attack_anim_prop NOISEBLASTER
        sprite_script NOISEBLASTER_SPRITE
        extra_script NOISEBLASTER_EXTRA
        sfx NOISEBLASTER
        init_fn 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 329: BIO_BLASTER
        attack_anim_prop BIO_BLASTER
        sprite_gfx BIO_BLASTER_SPRITE
        bg3_script BIO_BLASTER_BG3
        bg3_pal 238
        extra_script BIO_BLASTER_SPRITE
        sfx BIO_BLASTER
        init_fn 3
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 330: FLASH_TOOL
        attack_anim_prop FLASH_TOOL
        sprite_gfx FLASH_TOOL_SPRITE
        extra_script FLASH_TOOL_SPRITE
        sfx FLASH
        init_fn 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 331: CHAIN_SAW
        attack_anim_prop CHAIN_SAW
        sprite_gfx CHAIN_SAW_SPRITE
        sprite_pal 1
        extra_script CHAIN_SAW_SPRITE
        sfx CHAINSAW
        init_fn 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 332: DEBILITATOR
        attack_anim_prop DEBILITATOR
        sprite_script DEBILITATOR_SPRITE
        sprite_pal 2
        bg1_script DEBILITATOR_BG1
        bg1_pal 5
        bg3_script DEBILITATOR_BG3
        bg3_pal 2
        extra_script DEBILITATOR_EXTRA
        sfx SCAN
        init_fn 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 333: DRILL
        attack_anim_prop DRILL
        sprite_gfx DRILL_SPRITE
        sprite_pal 1
        extra_script DRILL_SPRITE
        sfx DRILL
        init_fn 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 334: AIR_ANCHOR
        attack_anim_prop AIR_ANCHOR
        sprite_script AIR_ANCHOR_SPRITE
        sprite_pal 1
        extra_script AIR_ANCHOR_EXTRA
        sfx AIR_ANCHOR
        init_fn 5
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 335: AUTOCROSSBOW
        attack_anim_prop AUTOCROSSBOW
        sprite_script AUTOCROSSBOW_SPRITE
        sprite_pal 3
        bg1_script AUTOCROSSBOW_BG1
        bg1_pal 3
        sfx AUTOCROSSBOW
        init_fn 94
        delay 8
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 336: CHAINSAW_ALT
        attack_anim_prop CHAINSAW_ALT
        sprite_gfx CHAIN_SAW_ALT_SPRITE
        sprite_pal 1
        extra_script CHAIN_SAW_ALT_SPRITE
        sfx CHAINSAW
        init_fn 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 337: TONIC
        attack_anim_prop TONIC
        sprite_script TONIC_SPRITE
        sprite_pal 195
        sfx CURA
        init_fn 125
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 338: POTION
        attack_anim_prop POTION
        sprite_script POTION_SPRITE
        sprite_pal 194
        sfx CURA
        init_fn 125
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 339: X_POTION
        attack_anim_prop X_POTION
        sprite_script X_POTION_SPRITE
        sprite_pal 192
        bg1_script CHAR_GFX_BG1
        bg3_script X_POTION_BG3
        sfx CURA
        init_fn 239
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 340: TINCTURE
        attack_anim_prop TINCTURE
        sprite_script TONIC_SPRITE
        sprite_pal 196
        sfx CURA
        init_fn 125
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 341: ETHER
        attack_anim_prop ETHER
        sprite_script POTION_SPRITE
        sprite_pal 193
        sfx CURA
        init_fn 125
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 342: X_ETHER
        attack_anim_prop X_ETHER
        sprite_script X_POTION_SPRITE
        sprite_pal 197
        bg1_script CHAR_GFX_BG1
        bg3_script X_POTION_BG3
        sfx CURA
        init_fn 239
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 343: ELIXIR
        attack_anim_prop ELIXIR
        sprite_script ELIXIR_SPRITE
        sprite_pal 192
        sfx FENIX_DOWN
        init_fn 125
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 344: MEGALIXIR
        attack_anim_prop MEGALIXIR
        sprite_script MEGALIXIR_SPRITE
        sprite_pal 192
        sfx FENIX_DOWN
        init_fn 125
        delay 31
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 345: FENIX_DOWN
        attack_anim_prop FENIX_DOWN
        sprite_script FENIX_DOWN_SPRITE
        sprite_pal 192
        sfx FENIX_DOWN
        init_fn 21
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 346: REVIVIFY
        attack_anim_prop REVIVIFY
        sprite_script EYEDROP_SPRITE
        sprite_pal 120
        bg1_script CHAR_GFX_BG1
        bg3_script X_POTION_BG3
        sfx REVIVIFY
        init_fn 240
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 347: ANTIDOTE
        attack_anim_prop ANTIDOTE
        sprite_script ANTIDOTE_SPRITE
        sprite_pal 193
        sfx CURA
        init_fn 125
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 348: EYEDROP
        attack_anim_prop EYEDROP
        sprite_script EYEDROP_SPRITE
        sprite_pal 120
        bg1_script CHAR_GFX_BG1
        bg3_script X_POTION_BG3
        sfx REVIVIFY
        init_fn 240
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 349: SOFT
        attack_anim_prop SOFT
        sprite_script ANTIDOTE_SPRITE
        sprite_pal 194
        sfx CURA
        init_fn 125
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 350: REMEDY
        attack_anim_prop REMEDY
        sprite_script REMEDY_ITEM_SPRITE
        sprite_pal 192
        sfx ESUNA
        init_fn 241
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 351: SLEEPING_BAG
        attack_anim_prop SLEEPING_BAG
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 352: TENT
        attack_anim_prop TENT
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 353: GREEN_CHERRY
        attack_anim_prop GREEN_CHERRY
        sprite_script GREEN_CHERRY_SPRITE
        sprite_pal 198
        sfx CURA
        init_fn 79
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 354: MAGICITE
        attack_anim_prop MAGICITE
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 355: SUPER_BALL
        attack_anim_prop SUPER_BALL
        sprite_script SUPER_BALL_SPRITE
        sprite_pal 209
        extra_script SUPER_BALL_EXTRA
        sfx STRAY_CAT
        init_fn 16
        delay 3
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 356: ECHO_SCREEN
        attack_anim_prop ECHO_SCREEN
        sprite_script ECHO_SCREEN_SPRITE
        sprite_pal 82
        sfx SMOKE_BOMB
        init_fn 120
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 357: SMOKE_BOMB
        attack_anim_prop SMOKE_BOMB
        sprite_script SMOKE_BOMB_SPRITE
        sprite_pal 82
        sfx SMOKE_BOMB
        init_fn 120
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 358: WARP_STONE
        attack_anim_prop WARP_STONE
        sprite_script ATTACK_ANIM_SCRIPT_638
        bg1_script WARP_BG1
        sfx WARP
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 359: DRIED_MEAT
        attack_anim_prop DRIED_MEAT
        sprite_script CURA_SPRITE
        sprite_pal 86
        sfx CURA
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 360: SMOKE_ENTRY
        attack_anim_prop SMOKE_ENTRY
        sprite_script SMOKE_ENTRY_SPRITE
        sprite_pal 82
        sfx SMOKE_BOMB
        init_fn 120
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 361: CEILING_EXIT
        attack_anim_prop CEILING_EXIT
        sprite_script CEILING_EXIT_SPRITE
        sprite_pal 82
        init_fn 16
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 362: CEILING_ENTRY
        attack_anim_prop CEILING_ENTRY
        sprite_script CEILING_ENTRY_SPRITE
        sprite_pal 82
        init_fn 16
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 363: SIDE_EXIT
        attack_anim_prop SIDE_EXIT
        sprite_script SIDE_EXIT_SPRITE
        sprite_pal 82
        init_fn 16
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 364: SIDE_ENTRY
        attack_anim_prop SIDE_ENTRY
        sprite_script SIDE_ENTRY_SPRITE
        sprite_pal 82
        init_fn 16
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 365: WATER_EXIT
        attack_anim_prop WATER_EXIT
        sprite_script WATER_EXIT_SPRITE
        sprite_pal 82
        bg1_pal 82
        sfx SPLASH
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 366: WATER_ENTRY
        attack_anim_prop WATER_ENTRY
        sprite_script WATER_ENTRY_SPRITE
        sprite_pal 82
        bg1_pal 82
        sfx SPLASH
        init_fn 120
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 367: FLOAT_EXIT
        attack_anim_prop FLOAT_EXIT
        sprite_script FLOAT_EXIT_SPRITE
        sprite_pal 82
        init_fn 16
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 368: FLOAT_ENTRY
        attack_anim_prop FLOAT_ENTRY
        sprite_script FLOAT_ENTRY_SPRITE
        sprite_pal 82
        init_fn 16
        delay 4
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 369: SAND_EXIT
        attack_anim_prop SAND_EXIT
        sprite_script SAND_EXIT_SPRITE
        sprite_pal 101
        bg1_pal 80
        sfx SPLASH
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 370: SAND_ENTRY
        attack_anim_prop SAND_ENTRY
        sprite_script SAND_ENTRY_SPRITE
        sprite_pal 101
        bg1_pal 80
        sfx SPLASH
        init_fn 120
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 371: FADE_DOWN_EXIT
        attack_anim_prop FADE_DOWN_EXIT
        bg3_script FADE_DOWN_EXIT_BG3
        bg3_pal 136
        sfx BOSS_DEATH_A
        init_fn 124
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 372: FADE_DOWN_ENTRY
        attack_anim_prop FADE_DOWN_ENTRY
        bg3_script FADE_DOWN_ENTRY_BG3
        bg3_pal 136
        sfx BOSS_DEATH_A
        init_fn 123
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 373: FADE_UP_EXIT
        attack_anim_prop FADE_UP_EXIT
        bg3_script FADE_UP_EXIT_BG3
        bg3_pal 136
        sfx BOSS_DEATH_A
        init_fn 124
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 374: FADE_UP_ENTRY
        attack_anim_prop FADE_UP_ENTRY
        bg3_script FADE_UP_ENTRY_BG3
        bg3_pal 136
        sfx BOSS_DEATH_A
        init_fn 123
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 375: MATERIALIZE_EXIT
        attack_anim_prop MATERIALIZE_EXIT
        bg3_script MATERIALIZE_EXIT_BG3
        bg3_pal 136
        sfx BOSS_DEATH_A
        init_fn 124
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 376: MATERIALIZE_ENTRY
        attack_anim_prop MATERIALIZE_ENTRY
        bg3_script MATERIALIZE_ENTRY_BG3
        bg3_pal 136
        sfx BOSS_DEATH_A
        init_fn 123
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 377: HORZ_FADE_EXIT
        attack_anim_prop HORZ_FADE_EXIT
        bg3_script HORZ_FADE_EXIT_BG3
        bg3_pal 136
        sfx HORZ_FADE_ENTRY
        init_fn 124
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 378: HORZ_FADE_ENTRY
        attack_anim_prop HORZ_FADE_ENTRY
        bg3_script HORZ_FADE_ENTRY_BG3
        bg3_pal 136
        sfx HORZ_FADE_ENTRY
        init_fn 123
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 379: DANCE_FAIL
        attack_anim_prop DANCE_FAIL
        sprite_gfx DANCE_FAIL_SPRITE
        extra_script DANCE_FAIL_SPRITE
        sfx PRE_DANCE_A
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 380: THREE_DICE
        attack_anim_prop THREE_DICE
        sprite_script DICE_SPRITE
        sprite_pal 30
        sfx SFX_250
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 381: TWO_DICE
        attack_anim_prop TWO_DICE
        sprite_script DICE_SPRITE
        sprite_pal 30
        sfx SFX_250
        init_fn 94
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 382: MOVE_FORWARD_8
        attack_anim_prop MOVE_FORWARD_8
        sprite_script MOVE_FORWARD_8_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 383: MOVE_BACK_8
        attack_anim_prop MOVE_BACK_8
        sprite_script MOVE_BACK_8_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 384: GESTAHL_LIGHTNING
        attack_anim_prop GESTAHL_LIGHTNING
        bg1_script GESTAHL_LIGHTNING_BG1
        bg1_pal 237
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 385: GESTAHL_BLACK_MAGIC
        attack_anim_prop GESTAHL_BLACK_MAGIC
        bg1_script GESTAHL_BLACK_MAGIC_BG1
        bg1_pal 8
        init_fn 15
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 386: CAPTURE_TO
        attack_anim_prop CAPTURE_TO
        sprite_script CAPTURE_TO_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 387: CAPTURE_FROM
        attack_anim_prop CAPTURE_FROM
        sprite_script CAPTURE_FROM_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 388: CHARS_RUN_LEFT
        attack_anim_prop CHARS_RUN_LEFT
        bg1_script CHARS_RUN_LEFT_BG1
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 389: CHARS_RUN_RIGHT
        attack_anim_prop CHARS_RUN_RIGHT
        bg1_script CHARS_RUN_RIGHT_BG1
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 390: SMOKE_EXIT
        attack_anim_prop SMOKE_EXIT
        sprite_script ECHO_SCREEN_SPRITE
        sprite_pal 82
        sfx SMOKE_BOMB
        init_fn 120
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 391: BOSS_DEATH
        attack_anim_prop BOSS_DEATH
        bg1_script BOSS_DEATH_BG1
        bg1_pal 136
        bg3_pal 136
        sfx SMOKE_BOMB
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 392: MOVE_FORWARD_64
        attack_anim_prop MOVE_FORWARD_64
        sprite_script MOVE_FORWARD_64_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 393: MOVE_BACK_64
        attack_anim_prop MOVE_BACK_64
        sprite_script MOVE_BACK_64_SPRITE
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 394: CHARDARNOOK_EXIT
        attack_anim_prop CHARDARNOOK_EXIT
        bg1_script CHADARNOOK_EXIT_SPRITE
        bg1_pal 136
        bg3_pal 136
        sfx SMOKE_BOMB
        init_fn 157
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 395: CHARDARNOOK_ENTRY
        attack_anim_prop CHARDARNOOK_ENTRY
        sprite_script CHADARNOOK_ENTRY_SPRITE
        bg1_pal 136
        bg3_pal 136
        sfx SMOKE_BOMB
        init_fn 16
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 396: SIDE_EXIT_INSTANT
        attack_anim_prop SIDE_EXIT_INSTANT
        sprite_script SIDE_EXIT_SPRITE
        sprite_pal 82
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 397: SIDE_ENTRY_INSTANT
        attack_anim_prop SIDE_ENTRY_INSTANT
        sprite_script SIDE_ENTRY_SPRITE
        sprite_pal 82
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 398: KEFKA_ENTRY
        attack_anim_prop KEFKA_ENTRY
        sprite_script KEFKA_ENTRY_SPRITE
        sprite_pal 82
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 399: KEFKA_HEAD
        attack_anim_prop KEFKA_HEAD
        bg1_script KEFKA_HEAD_BG1
        bg1_pal 239
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 400: MONSTER_GLOW_LONG
        attack_anim_prop MONSTER_GLOW_LONG
        bg1_script MONSTER_GLOW_LONG_BG1
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 401: MONSTER_GLOW_SHORT
        attack_anim_prop MONSTER_GLOW_SHORT
        bg1_script MONSTER_GLOW_SHORT_BG1
        init_fn 157
        delay 1
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 402: RENAME_CARD
        attack_anim_prop RENAME_CARD
        sprite_script CURA_SPRITE
        sprite_pal 104
        sfx CURA
        init_fn 28
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 403: KEFKA_DEATH
        attack_anim_prop KEFKA_DEATH
        bg1_script KEFKA_DEATH_BG1
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 404: CONTROL
        attack_anim_prop CONTROL
        bg1_script CONTROL_BG1
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

; 405: MONSTER_STEAL
        attack_anim_prop MONSTER_STEAL
        bg1_script MONSTER_STEAL_BG1
        init_fn 16
        delay 0
        end_attack_anim_prop

; ------------------------------------------------------------------------------

.include "attack_anim_prop.mac"

; ------------------------------------------------------------------------------
