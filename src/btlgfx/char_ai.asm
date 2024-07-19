
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: src/assets/char_ai.asm                                               |
; |                                                                            |
; | description: character a.i. properties                                     |
; |                                                                            |
; | created: 11/11/2023                                                        |
; +----------------------------------------------------------------------------+

; [ data format (24 bytes each) ]

;   0: p------h flags
;        p: hide characters in current party (show a.i. characters only)
;        h: hide names/gauges for all characters in battle menu
;   1: battle bg (ignored if $ff)
;   2: valid monster targets (change with a.i. command $fb)
;   3: song ($ff for default battle song, ignored if continuing current song)
;   4-23: character slots (4 * 5 bytes each)
;           0: pecccccc ($ff for empty slot, i.e. use party character)
;                p: character is not in the party (see anim cmd $C7/$10)
;                   exclude from entry/victory animations, also hide name/gauge
;                e: enemy character (faces opposite direction, acts as enemy)
;                c: character properties
;           1: character graphics ($ff to use default for character properties)
;           2: monster a.i. script (add $0100)
;           3: x position (multiply by 2)
;           4: y position (multiply by 2)

; ------------------------------------------------------------------------------

.include "btlgfx/char_ai.inc"
.include "sound/song_script.inc"

; ------------------------------------------------------------------------------

.segment "char_ai"

; d0/fd00
CharAI:

; ------------------------------------------------------------------------------

; $00: none

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte $ff
.byte 0,0
.byte 255,255

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $01: shadow_colosseum

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::SHADOW

; slot 0
.byte CHAR_PROP::SHADOW|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::SHADOW,<MONSTER::SHADOW_COLOSSEUM
.byte 40,48

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $02: terra_flashback

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::BURNING_BUILDING
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1|CHAR_AI_FLAG_NOT_IN_PARTY
.byte CHAR_GFX::KEFKA,0
.byte 255,255

; slot 1
.byte CHAR_PROP::TERRA
.byte $ff,<MONSTER::TERRA_FLASHBACK
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $03: vargas

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~BIT_0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::SABIN|CHAR_AI_FLAG_NOT_IN_PARTY
.byte $ff,$ff
.byte 60,108

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $04: kefka_imp_camp_1

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,<MONSTER::KEFKA_IMP_CAMP
.byte 32,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $05: cyan_imp_camp_1

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::CYAN
.byte CHAR_GFX::CYAN,<MONSTER::CYAN_IMP_CAMP
.byte 80,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $06: cyan_imp_camp_2

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::CYAN
.byte CHAR_GFX::CYAN,<MONSTER::CYAN_IMP_CAMP
.byte 80,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $07: piranha

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $08: unused_08

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_2|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,<MONSTER::KEFKA_IMP_CAMP
.byte 32,44

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $09: unused_09

.byte CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1
.byte CHAR_GFX::KEFKA,$ff
.byte 100,100

; slot 1
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 32,60

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0a: gau_veldt

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::GAU|CHAR_AI_FLAG_NOT_IN_PARTY|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::GAU,<MONSTER::GAU_VELDT
.byte 48,52

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0b: unused_0b

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 60,100

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::LOCKE,$ff
.byte 60,100

; slot 2
.byte CHAR_PROP::CELES
.byte CHAR_GFX::CELES,$ff
.byte 60,100

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0c: sealed_gate_1

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_2|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,<MONSTER::KEFKA_ESPER_GATE
.byte 100,44

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0d: sealed_gate_2

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_2|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,$ff
.byte 100,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0e: blackjack_espers

.byte CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::METAMORPHOSIS

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 60,100

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::LOCKE,$ff
.byte 60,100

; slot 2
.byte CHAR_PROP::SETZER
.byte CHAR_GFX::SETZER,$ff
.byte 60,100

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0f: ultros_relm

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::RELM|CHAR_AI_FLAG_NOT_IN_PARTY
.byte CHAR_GFX::RELM,$ff
.byte 255,255

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $10: espers go to thamasa

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 100,100

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $11: blitz_tutorial

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::KEFKA,$ff
.byte 64,88

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::SOLDIER,$ff
.byte 92,80

; slot 2
.byte CHAR_PROP::CYAN
.byte CHAR_GFX::SOLDIER,$ff
.byte 40,84

; slot 3
.byte CHAR_PROP::SHADOW
.byte CHAR_GFX::SOLDIER,$ff
.byte 100,100

; ------------------------------------------------------------------------------

; $12: kefka_esper

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_3
.byte CHAR_GFX::KEFKA,$ff
.byte 92,44

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $13: kefka_gestahl

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::KEFKA,$ff
.byte 88,84

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::GESTAHL,$ff
.byte 48,84

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $14: kefka_leo

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA|CHAR_AI_FLAG_NOT_IN_PARTY
.byte CHAR_GFX::KEFKA,$ff
.byte 60,100

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $15: unused_15

.byte CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1
.byte CHAR_GFX::KEFKA,$ff
.byte 255,255

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $16: unused_16

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~BIT_0
.byte SONG::NONE

; slot 0
.byte $ff
.byte 0,0
.byte 255,255

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $17: unused_17

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~BIT_0
.byte SONG::NONE

; slot 0
.byte $ff
.byte 0,0
.byte 255,255

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------
