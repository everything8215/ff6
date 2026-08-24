
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: const.inc                                                            |
; |                                                                            |
; | description: global constant definitions                                   |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.list off  ; disable listing
.ifndef CONST_INC
CONST_INC = 1

; ------------------------------------------------------------------------------

; define a config constant if it's not already defined
.macro def_config _const, _value
        .ifndef _const
        _const = _value
        .endif
.endmacro

def_config ROM_VERSION, 0
def_config DEBUG, 0
def_config LANG_JP, 0
def_config LANG_EN, 0

; define language suffix
; .if LANG_EN
;         .define LANG_SUFFIX "en"
; .elseif LANG_JP
;         .define LANG_SUFFIX "jp"
; .else
;         .error "Unsupported language"
; .endif

; evade bugfix by Terii Senshi
def_config BUGFIX_EVADE, 0

; ------------------------------------------------------------------------------

.define BIT_0  %00000001
.define BIT_1  %00000010
.define BIT_2  %00000100
.define BIT_3  %00001000
.define BIT_4  %00010000
.define BIT_5  %00100000
.define BIT_6  %01000000
.define BIT_7  %10000000

.define BIT_8  %0000000100000000
.define BIT_9  %0000001000000000
.define BIT_10 %0000010000000000
.define BIT_11 %0000100000000000
.define BIT_12 %0001000000000000
.define BIT_13 %0010000000000000
.define BIT_14 %0100000000000000
.define BIT_15 %1000000000000000

; ------------------------------------------------------------------------------

MAX_LEVEL                               = 99
MAX_HP                                  = 9999
MAX_MP                                  = 999
MAX_GIL                                 = 9999999
MAX_ITEM_QTY                            = 99
MAX_STEPS                               = 9999999
MAX_EXPERIENCE                          = 15000000

; ------------------------------------------------------------------------------

; movement and facing directions (field module)

.enum EVENT_DIR
        UP                              ;= 0
        RIGHT                           ;= 1
        DOWN                            ;= 2
        LEFT                            ;= 3
        UP_RIGHT                        ;= 4
        RIGHT_UP                        = UP_RIGHT
        DOWN_RIGHT                      ;= 5
        RIGHT_DOWN                      = DOWN_RIGHT
        DOWN_LEFT                       ;= 6
        LEFT_DOWN                       = DOWN_LEFT
        UP_LEFT                         ;= 7
        LEFT_UP                         = UP_LEFT
        RIGHT_UP_UP                     ;= 8
        RIGHT_RIGHT_UP                  ;= 9
        RIGHT_RIGHT_DOWN                ;= 10
        RIGHT_DOWN_DOWN                 ;= 11
        LEFT_DOWN_DOWN                  ;= 12
        LEFT_LEFT_DOWN                  ;= 13
        LEFT_LEFT_UP                    ;= 14
        LEFT_UP_UP                      ;= 15
.endenum

; ------------------------------------------------------------------------------

.enum TOOLS
        NOISEBLASTER
        BIO_BLASTER
        FLASH
        CHAIN_SAW
        DEBILITATOR
        DRILL
        AIR_ANCHOR
        AUTOCROSSBOW

        COUNT
.endenum

; item ids
.enum ITEM
        FIRST_WEAPON                    ;= $00  ; 0
        DIRK = FIRST_WEAPON             ;= $00  ; 0
        MITHRILKNIFE                    ;= $01  ; 1
        MAIN_GAUCHE                     ;= $02  ; 2
        AIR_LANCET                      ;= $03  ; 3
        THIEFKNIFE                      ;= $04  ; 4
        ASSASSIN                        ;= $05  ; 5
        MAN_EATER                       ;= $06  ; 6
        SWORDBREAKER                    ;= $07  ; 7
        GRAEDUS                         ;= $08  ; 8
        VALIANTKNIFE                    ;= $09  ; 9
        MITHRILBLADE                    ;= $0a  ; 10
        REGAL_CUTLASS                   ;= $0b  ; 11
        RUNE_EDGE                       ;= $0c  ; 12
        FLAME_SABRE                     ;= $0d  ; 13
        BLIZZARD                        ;= $0e  ; 14
        THUNDERBLADE                    ;= $0f  ; 15
        EPEE                            ;= $10  ; 16
        BREAK_BLADE                     ;= $11  ; 17
        DRAINER                         ;= $12  ; 18
        ENHANCER                        ;= $13  ; 19
        CRYSTAL                         ;= $14  ; 20
        FALCHION                        ;= $15  ; 21
        SOUL_SABRE                      ;= $16  ; 22
        OGRE_NIX                        ;= $17  ; 23
        EXCALIBUR                       ;= $18  ; 24
        SCIMITAR                        ;= $19  ; 25
        ILLUMINA                        ;= $1a  ; 26
        RAGNAROK                        ;= $1b  ; 27
        ATMA_WEAPON                     ;= $1c  ; 28
        MITHRIL_PIKE                    ;= $1d  ; 29
        TRIDENT                         ;= $1e  ; 30
        STOUT_SPEAR                     ;= $1f  ; 31
        PARTISAN                        ;= $20  ; 32
        HOLY_LANCE                      ;= $21  ; 33
        GOLD_LANCE                      ;= $22  ; 34
        AURA_LANCE                      ;= $23  ; 35
        IMP_HALBERD                     ;= $24  ; 36
        IMPERIAL                        ;= $25  ; 37
        KODACHI                         ;= $26  ; 38
        BLOSSOM                         ;= $27  ; 39
        HARDENED                        ;= $28  ; 40
        STRIKER                         ;= $29  ; 41
        STUNNER                         ;= $2a  ; 42
        ASHURA                          ;= $2b  ; 43
        KOTETSU                         ;= $2c  ; 44
        FORGED                          ;= $2d  ; 45
        TEMPEST                         ;= $2e  ; 46
        MURASAME                        ;= $2f  ; 47
        AURA                            ;= $30  ; 48
        STRATO                          ;= $31  ; 49
        SKY_RENDER                      ;= $32  ; 50
        HEAL_ROD                        ;= $33  ; 51
        MITHRIL_ROD                     ;= $34  ; 52
        FIRE_ROD                        ;= $35  ; 53
        ICE_ROD                         ;= $36  ; 54
        THUNDER_ROD                     ;= $37  ; 55
        POISON_ROD                      ;= $38  ; 56
        HOLY_ROD                       ;= $39  ; 57
        GRAVITY_ROD                     ;= $3a  ; 58
        PUNISHER                        ;= $3b  ; 59
        MAGUS_ROD                       ;= $3c  ; 60
        CHOCOBO_BRSH                    ;= $3d  ; 61
        DAVINCI_BRSH                    ;= $3e  ; 62
        MAGICAL_BRSH                    ;= $3f  ; 63
        RAINBOW_BRSH                    ;= $40  ; 64
        SHURIKEN                        ;= $41  ; 65
        NINJA_STAR                      ;= $42  ; 66
        TACK_STAR                       ;= $43  ; 67
        FLAIL                           ;= $44  ; 68
        FULL_MOON                       ;= $45  ; 69
        MORNING_STAR                    ;= $46  ; 70
        BOOMERANG                       ;= $47  ; 71
        RISING_SUN                      ;= $48  ; 72
        HAWK_EYE                        ;= $49  ; 73
        BONE_CLUB                       ;= $4a  ; 74
        SNIPER                          ;= $4b  ; 75
        WING_EDGE                       ;= $4c  ; 76
        CARDS                           ;= $4d  ; 77
        DARTS                           ;= $4e  ; 78
        DOOM_DARTS                      ;= $4f  ; 79
        TRUMP                           ;= $50  ; 80
        DICE                            ;= $51  ; 81
        FIXED_DICE                      ;= $52  ; 82
        METALKNUCKLE                    ;= $53  ; 83
        MITHRIL_CLAW                    ;= $54  ; 84
        KAISER                          ;= $55  ; 85
        POISON_CLAW                     ;= $56  ; 86
        FIRE_KNUCKLE                    ;= $57  ; 87
        DRAGON_CLAW                     ;= $58  ; 88
        TIGER_FANGS                     ;= $59  ; 89

        FIRST_SHIELD                    ;= $5a  ; 90
        BUCKLER = FIRST_SHIELD          ;= $5a  ; 90
        HEAVY_SHLD                      ;= $5b  ; 91
        MITHRIL_SHLD                    ;= $5c  ; 92
        GOLD_SHLD                       ;= $5d  ; 93
        AEGIS_SHLD                      ;= $5e  ; 94
        DIAMOND_SHLD                    ;= $5f  ; 95
        FLAME_SHLD                      ;= $60  ; 96
        ICE_SHLD                        ;= $61  ; 97
        THUNDER_SHLD                    ;= $62  ; 98
        CRYSTAL_SHLD                    ;= $63  ; 99
        GENJI_SHLD                      ;= $64  ; 100
        TORTOISESHLD                    ;= $65  ; 101
        CURSED_SHLD                     ;= $66  ; 102
        PALADIN_SHLD                    ;= $67  ; 103
        FORCE_SHLD                      ;= $68  ; 104

        FIRST_HELMET                    ;= $69  ; 105
        LEATHER_HAT = FIRST_HELMET      ;= $69  ; 105
        HAIR_BAND                       ;= $6a  ; 106
        PLUMED_HAT                      ;= $6b  ; 107
        BERET                           ;= $6c  ; 108
        MAGUS_HAT                       ;= $6d  ; 109
        BANDANA                         ;= $6e  ; 110
        IRON_HELMET                     ;= $6f  ; 111
        CORONET                         ;= $70  ; 112
        BARDS_HAT                       ;= $71  ; 113
        GREEN_BERET                     ;= $72  ; 114
        HEAD_BAND                       ;= $73  ; 115
        MITHRIL_HELM                    ;= $74  ; 116
        TIARA                           ;= $75  ; 117
        GOLD_HELMET                     ;= $76  ; 118
        TIGER_MASK                      ;= $77  ; 119
        RED_CAP                         ;= $78  ; 120
        MYSTERY_VEIL                    ;= $79  ; 121
        CIRCLET                         ;= $7a  ; 122
        REGAL_CROWN                     ;= $7b  ; 123
        DIAMOND_HELM                    ;= $7c  ; 124
        DARK_HOOD                       ;= $7d  ; 125
        CRYSTAL_HELM                    ;= $7e  ; 126
        OATH_VEIL                       ;= $7f  ; 127
        CAT_HOOD                        ;= $80  ; 128
        GENJI_HELMET                    ;= $81  ; 129
        THORNLET                        ;= $82  ; 130
        TITANIUM                        ;= $83  ; 131

        FIRST_ARMOR                     ;= $84  ; 132
        LEATHERARMOR = FIRST_ARMOR      ;= $84  ; 132
        COTTON_ROBE                     ;= $85  ; 133
        KUNG_FU_SUIT                    ;= $86  ; 134
        IRON_ARMOR                      ;= $87  ; 135
        SILK_ROBE                       ;= $88  ; 136
        MITHRIL_VEST                    ;= $89  ; 137
        NINJA_GEAR                      ;= $8a  ; 138
        WHITE_DRESS                     ;= $8b  ; 139
        MITHRIL_MAIL                    ;= $8c  ; 140
        GAIA_GEAR                       ;= $8d  ; 141
        MIRAGE_VEST                     ;= $8e  ; 142
        GOLD_ARMOR                      ;= $8f  ; 143
        POWER_SASH                      ;= $90  ; 144
        LIGHT_ROBE                      ;= $91  ; 145
        DIAMOND_VEST                    ;= $92  ; 146
        RED_JACKET                      ;= $93  ; 147
        FORCE_ARMOR                     ;= $94  ; 148
        DIAMONDARMOR                    ;= $95  ; 149
        DARK_GEAR                       ;= $96  ; 150
        TAO_ROBE                        ;= $97  ; 151
        CRYSTAL_MAIL                    ;= $98  ; 152
        CZARINA_GOWN                    ;= $99  ; 153
        GENJI_ARMOR                     ;= $9a  ; 154
        IMPS_ARMOR                      ;= $9b  ; 155
        MINERVA                         ;= $9c  ; 156
        TABBY_SUIT                      ;= $9d  ; 157
        CHOCOBO_SUIT                    ;= $9e  ; 158
        MOOGLE_SUIT                     ;= $9f  ; 159
        NUTKIN_SUIT                     ;= $a0  ; 160
        BEHEMOTHSUIT                    ;= $a1  ; 161
        SNOW_MUFFLER                    ;= $a2  ; 162

        FIRST_TOOL                      ;= $a3  ; 163
        NOISEBLASTER = FIRST_TOOL       ;= $a3  ; 163
        BIO_BLASTER                     ;= $a4  ; 164
        FLASH                           ;= $a5  ; 165
        CHAIN_SAW                       ;= $a6  ; 166
        DEBILITATOR                     ;= $a7  ; 167
        DRILL                           ;= $a8  ; 168
        AIR_ANCHOR                      ;= $a9  ; 169
        AUTOCROSSBOW                    ;= $aa  ; 170

        FIRST_NINJA                     ;= $ab  ; 171
        FIRE_SKEAN = FIRST_NINJA        ;= $ab  ; 171
        WATER_EDGE                      ;= $ac  ; 172
        BOLT_EDGE                       ;= $ad  ; 173
        INVIZ_EDGE                      ;= $ae  ; 174
        SHADOW_EDGE                     ;= $af  ; 175

        FIRST_RELIC                     ;= $b0  ; 176
        GOGGLES = FIRST_RELIC           ;= $b0  ; 176
        STAR_PENDANT                    ;= $b1  ; 177
        PEACE_RING                      ;= $b2  ; 178
        AMULET                          ;= $b3  ; 179
        WHITE_CAPE                      ;= $b4  ; 180
        JEWEL_RING                      ;= $b5  ; 181
        FAIRY_RING                      ;= $b6  ; 182
        BARRIER_RING                    ;= $b7  ; 183
        MITHRILGLOVE                    ;= $b8  ; 184
        GUARD_RING                      ;= $b9  ; 185
        RUNNINGSHOES                    ;= $ba  ; 186
        WALL_RING                       ;= $bb  ; 187
        CHERUB_DOWN                     ;= $bc  ; 188
        CURE_RING                       ;= $bd  ; 189
        TRUE_KNIGHT                     ;= $be  ; 190
        DRAGOONBOOTS                    ;= $bf  ; 191
        ZEPHYR_CAPE                     ;= $c0  ; 192
        CZARINA_RING                    ;= $c1  ; 193
        CURSED_RING                     ;= $c2  ; 194
        EARRINGS                        ;= $c3  ; 195
        ATLAS_ARMLET                    ;= $c4  ; 196
        BLIZZARD_ORB                    ;= $c5  ; 197
        RAGE_RING                       ;= $c6  ; 198
        SNEAK_RING                      ;= $c7  ; 199
        POD_BRACELET                    ;= $c8  ; 200
        HERO_RING                       ;= $c9  ; 201
        RIBBON                          ;= $ca  ; 202
        MUSCLE_BELT                     ;= $cb  ; 203
        CRYSTAL_ORB                     ;= $cc  ; 204
        GOLD_HAIRPIN                    ;= $cd  ; 205
        ECONOMIZER                      ;= $ce  ; 206
        THIEF_GLOVE                     ;= $cf  ; 207
        GAUNTLET                        ;= $d0  ; 208
        GENJI_GLOVE                     ;= $d1  ; 209
        HYPER_WRIST                     ;= $d2  ; 210
        OFFERING                        ;= $d3  ; 211
        BEADS                           ;= $d4  ; 212
        BLACK_BELT                      ;= $d5  ; 213
        COIN_TOSS                       ;= $d6  ; 214
        FAKEMUSTACHE                    ;= $d7  ; 215
        GEM_BOX                         ;= $d8  ; 216
        DRAGON_HORN                     ;= $d9  ; 217
        MERIT_AWARD                     ;= $da  ; 218
        MEMENTO_RING                    ;= $db  ; 219
        SAFETY_BIT                      ;= $dc  ; 220
        RELIC_RING                      ;= $dd  ; 221
        MOOGLE_CHARM                    ;= $de  ; 222
        CHARM_BANGLE                    ;= $df  ; 223
        MARVEL_SHOES                    ;= $e0  ; 224
        BACK_GUARD                      ;= $e1  ; 225
        GALE_HAIRPIN                    ;= $e2  ; 226
        SNIPER_SIGHT                    ;= $e3  ; 227
        EXP_EGG                         ;= $e4  ; 228
        TINTINABAR                      ;= $e5  ; 229
        SPRINT_SHOES                    ;= $e6  ; 230

        FIRST_CONSUMABLE                ;= $e7  ; 231
        RENAME_CARD = FIRST_CONSUMABLE  ;= $e7  ; 231
        TONIC                           ;= $e8  ; 232
        POTION                          ;= $e9  ; 233
        X_POTION                        ;= $ea  ; 234
        TINCTURE                        ;= $eb  ; 235
        ETHER                           ;= $ec  ; 236
        X_ETHER                         ;= $ed  ; 237
        ELIXIR                          ;= $ee  ; 238
        MEGALIXIR                       ;= $ef  ; 239
        FENIX_DOWN                      ;= $f0  ; 240
        REVIVIFY                        ;= $f1  ; 241
        ANTIDOTE                        ;= $f2  ; 242
        EYEDROP                         ;= $f3  ; 243
        SOFT                            ;= $f4  ; 244
        REMEDY                          ;= $f5  ; 245
        SLEEPING_BAG                    ;= $f6  ; 246
        TENT                            ;= $f7  ; 247
        GREEN_CHERRY                    ;= $f8  ; 248
        MAGICITE                        ;= $f9  ; 249
        SUPER_BALL                      ;= $fa  ; 250
        ECHO_SCREEN                     ;= $fb  ; 251
        SMOKE_BOMB                      ;= $fc  ; 252
        WARP_STONE                      ;= $fd  ; 253
        DRIED_MEAT                      ;= $fe  ; 254
        EMPTY                           ;= $ff  ; 255
        UNARMED = EMPTY

        COUNT

.endenum

        .assert ITEM::COUNT = 256, error, "Item count must be 256"

; ------------------------------------------------------------------------------

; character/actor ids
.enum CHAR

; main characters
        TERRA                           ;= $00
        LOCKE                           ;= $01
        CYAN                            ;= $02
        SHADOW                          ;= $03
        EDGAR                           ;= $04
        SABIN                           ;= $05
        CELES                           ;= $06
        STRAGO                          ;= $07
        RELM                            ;= $08
        SETZER                          ;= $09
        MOG                             ;= $0a
        GAU                             ;= $0b
        GOGO                            ;= $0c
        UMARO                           ;= $0d

; extra moogles
        KUPEK                           = 2
        KUPOP                           = 3
        KUMAMA                          = 4
        KUKU                            = 5
        KUTAN                           = 6
        KUPAN                           = 7
        KUSHU                           = 8
        KURIN                           = 9
        KURU                            = 11
        KAMOG                           = 12

; phantom train ghosts
        GHOST_1                         = 7
        GHOST_2                         = 8

; other characters
        SCENARIO_MOG                    = 13
        WEDGE                           = 14
        BANON                           = 14
        MADUIN                          = 14
        VICKS                           = 15
        LEO                             = 15
        KEFKA                           = 15

.endenum

; ------------------------------------------------------------------------------

.enum EVENT_OBJ

; main characters
        TERRA                           = CHAR::TERRA
        LOCKE                           = CHAR::LOCKE
        CYAN                            = CHAR::CYAN
        SHADOW                          = CHAR::SHADOW
        EDGAR                           = CHAR::EDGAR
        SABIN                           = CHAR::SABIN
        CELES                           = CHAR::CELES
        STRAGO                          = CHAR::STRAGO
        RELM                            = CHAR::RELM
        SETZER                          = CHAR::SETZER
        MOG                             = CHAR::MOG
        GAU                             = CHAR::GAU
        GOGO                            = CHAR::GOGO
        UMARO                           = CHAR::UMARO

; extra moogles
        KUPEK                           = CHAR::KUPEK
        KUPOP                           = CHAR::KUPOP
        KUMAMA                          = CHAR::KUMAMA
        KUKU                            = CHAR::KUKU
        KUTAN                           = CHAR::KUTAN
        KUPAN                           = CHAR::KUPAN
        KUSHU                           = CHAR::KUSHU
        KURIN                           = CHAR::KURIN
        KURU                            = CHAR::KURU
        KAMOG                           = CHAR::KAMOG

; phantom train ghosts
        GHOST_1                         = CHAR::GHOST_1
        GHOST_2                         = CHAR::GHOST_2

; other characters
        SCENARIO_MOG                    = CHAR::SCENARIO_MOG
        WEDGE                           = CHAR::WEDGE
        BANON                           = CHAR::BANON
        MADUIN                          = CHAR::MADUIN
        VICKS                           = CHAR::VICKS
        LEO                             = CHAR::LEO
        KEFKA                           = CHAR::KEFKA

; npcs
        NPC_1                           = $10
        NPC_2                           ; = $11
        NPC_3                           ; = $12
        NPC_4                           ; = $13
        NPC_5                           ; = $14
        NPC_6                           ; = $15
        NPC_7                           ; = $16
        NPC_8                           ; = $17
        NPC_9                           ; = $18
        NPC_10                          ; = $19
        NPC_11                          ; = $1a
        NPC_12                          ; = $1b
        NPC_13                          ; = $1c
        NPC_14                          ; = $1d
        NPC_15                          ; = $1e
        NPC_16                          ; = $1f
        NPC_17                          ; = $20
        NPC_18                          ; = $21
        NPC_19                          ; = $22
        NPC_20                          ; = $23
        NPC_21                          ; = $24
        NPC_22                          ; = $25
        NPC_23                          ; = $26
        NPC_24                          ; = $27
        NPC_25                          ; = $28
        NPC_26                          ; = $29
        NPC_27                          ; = $2a
        NPC_28                          ; = $2b
        NPC_29                          ; = $2c
        NPC_30                          ; = $2d
        NPC_31                          ; = $2e
        NPC_32                          ; = $2f

; camera object
        CAMERA                          ; = $30

; party character slots
        SLOT_1                          ; = $31
        SLOT_2                          ; = $32
        SLOT_3                          ; = $33
        SLOT_4                          ; = $34
.endenum

; ------------------------------------------------------------------------------

; character graphics ids (battle and menu)
.enum CHAR_GFX
        TERRA                           ;= $00
        LOCKE                           ;= $01
        CYAN                            ;= $02
        SHADOW                          ;= $03
        EDGAR                           ;= $04
        SABIN                           ;= $05
        CELES                           ;= $06
        STRAGO                          ;= $07
        RELM                            ;= $08
        SETZER                          ;= $09
        MOG                             ;= $0a
        GAU                             ;= $0b
        GOGO                            ;= $0c
        UMARO                           ;= $0d
        BROWN_SOLDIER                   ;= $0e
        IMP                             ;= $0f
        LEO                             ;= $10
        BANON                           ;= $11
        ESPER_TERRA                     ;= $12
        MERCHANT                        ;= $13
        GHOST                           ;= $14
        KEFKA                           ;= $15
        GESTAHL                         ;= $16
        GREEN_SOLDIER                   ;= $17
.endenum

; ------------------------------------------------------------------------------

; battle command ids
.enum BATTLE_CMD
        FIGHT                           ;= $00  ; 0
        ITEM                            ;= $01  ; 1
        MAGIC                           ;= $02  ; 2
        MORPH                           ;= $03  ; 3
        REVERT                          ;= $04  ; 4
        STEAL                           ;= $05  ; 5
        CAPTURE                         ;= $06  ; 6
        BUSHIDO                         ;= $07  ; 7
        THROW                           ;= $08  ; 8
        TOOLS                           ;= $09  ; 9
        BLITZ                           ;= $0a  ; 10
        RUNIC                           ;= $0b  ; 11
        LORE                            ;= $0c  ; 12
        SKETCH                          ;= $0d  ; 13
        CONTROL                         ;= $0e  ; 14
        SLOT                            ;= $0f  ; 15
        RAGE                            ;= $10  ; 16
        LEAP                            ;= $11  ; 17
        MIMIC                           ;= $12  ; 18
        DANCE                           ;= $13  ; 19
        ROW                             ;= $14  ; 20
        DEF                             ;= $15  ; 21
        JUMP                            ;= $16  ; 22
        X_MAGIC                         ;= $17  ; 23
        GP_RAIN                         ;= $18  ; 24
        SUMMON                          ;= $19  ; 25
        HEALTH                          ;= $1a  ; 26
        SHOCK                           ;= $1b  ; 27
        POSSESS                         ;= $1c  ; 28
        MAGITEK                         ;= $1d  ; 29
        BATTLE_CMD_30                   ;= $1e  ; 30
        BATTLE_CMD_31                   ;= $1f  ; 31
        NONE = $ff                      ;= $ff  ; 255
.endenum

.enum GFX_BATTLE_CMD
        GFX_BATTLE_CMD_30               = BATTLE_CMD::BATTLE_CMD_30  ; 30
        GFX_BATTLE_CMD_31               ;= $1f  ; 31
        CHANGE_BATTLE                   ;= $20  ; 32
        ROULETTE                        ;= $21  ; 33
        RUN_AWAY                        ;= $22  ; 34
        UMARO_TACKLE                    ;= $23  ; 35
        UMARO_THROW                     ;= $24  ; 36
        RUNIC_ABSORB                    ;= $25  ; 37
        DICE_ROLL                       ;= $26  ; 38

        COUNT
.endenum

.enum ACTION_BATTLE_CMD
        ROULETTE                        = BATTLE_CMD::BATTLE_CMD_30  ; 30
        RANDOM                          ;= $1f  ; 31
        CHANGE_BATTLE                   ;= $20  ; 32
        MONSTER_DLG                     ;= $21  ; 33
        POISON_REGEN                    ;= $22  ; 34
        BATTLE_EVENT                    ;= $23  ; 35
        MONSTER_ENTRY_EXIT              ;= $24  ; 36
        ATTACK_MSG                      ;= $25  ; 37
        IMMEDIATE_ACTION                ;= $26  ; 38
        SCAN_INFO                       ;= $27  ; 39
        ACTION_BATTLE_CMD_40            ;= $28  ; 40
        STATUS_TIMER_EXPIRED            ;= $29  ; 41
        RUN_AWAY                        ;= $2a  ; 42
        MONSTER_ANIM                    ;= $2b  ; 43
        REVERT_CHAR_POSE                ;= $2c  ; 44
        SEIZE_DMG                       ;= $2d  ; 45
        CHANGE_VAR                      ;= $2e  ; 46
        CHANGE_SWITCH                   ;= $2f  ; 47
        MISC_AI_EFFECT                  ;= $30  ; 48
        ACTION_BATTLE_CMD_49            ;= $31  ; 49
        ACTION_BATTLE_CMD_50            ;= $32  ; 50
        ACTION_BATTLE_CMD_51            ;= $33  ; 51

        COUNT
.endenum

; ------------------------------------------------------------------------------

; attack ids
.enum ATTACK

; attack magic (black)
        FIRE                            ;= $00  ; 0
        BLIZZARD                        ;= $01  ; 1
        THUNDER                         ;= $02  ; 2
        POISON                          ;= $03  ; 3
        DRAIN                           ;= $04  ; 4
        FIRA                            ;= $05  ; 5
        BLIZZARA                        ;= $06  ; 6
        THUNDARA                        ;= $07  ; 7
        BIO                             ;= $08  ; 8
        FIRAGA                          ;= $09  ; 9
        BLIZZAGA                        ;= $0a  ; 10
        THUNDAGA                        ;= $0b  ; 11
        BREAK                           ;= $0c  ; 12
        DOOM                            ;= $0d  ; 13
        HOLY                            ;= $0e  ; 14
        FLARE                           ;= $0f  ; 15
        DEMI                            ;= $10  ; 16
        QUARTR                          ;= $11  ; 17
        DEZONE                          ;= $12  ; 18
        METEOR                          ;= $13  ; 19
        ULTIMA                          ;= $14  ; 20
        QUAKE                           ;= $15  ; 21
        TORNADO                         ;= $16  ; 22
        MELTDOWN                        ;= $17  ; 23

; effect magic (gray)
        SCAN                            ;= $18  ; 24
        SLOW                            ;= $19  ; 25
        RASP                            ;= $1a  ; 26
        MUTE                            ;= $1b  ; 27
        SAFE                            ;= $1c  ; 28
        SLEEP                           ;= $1d  ; 29
        CONFUSE                         ;= $1e  ; 30
        HASTE                           ;= $1f  ; 31
        STOP                            ;= $20  ; 32
        BERSERK                         ;= $21  ; 33
        FLOAT                           ;= $22  ; 34
        IMP                             ;= $23  ; 35
        REFLECT                         ;= $24  ; 36
        SHELL                           ;= $25  ; 37
        VANISH                          ;= $26  ; 38
        HASTE2                          ;= $27  ; 39
        SLOW_2                          ;= $28  ; 40
        OSMOSE                          ;= $29  ; 41
        WARP                            ;= $2a  ; 42
        QUICK                           ;= $2b  ; 43
        DISPEL                          ;= $2c  ; 44

; restorative magic (white)
        CURE                            ;= $2d  ; 45
        CURA                            ;= $2e  ; 46
        CURAGA                          ;= $2f  ; 47
        RAISE                           ;= $30  ; 48
        ARISE                           ;= $31  ; 49
        POISONA                         ;= $32  ; 50
        REMEDY                          ;= $33  ; 51
        REGEN                           ;= $34  ; 52
        RERAISE                         ;= $35  ; 53

; summons
        RAMUH                           ;= $36  ; 54
        IFRIT                           ;= $37  ; 55
        SHIVA                           ;= $38  ; 56
        SIREN                           ;= $39  ; 57
        TERRATO                         ;= $3a  ; 58
        SHOAT                           ;= $3b  ; 59
        MADUIN                          ;= $3c  ; 60
        BISMARK                         ;= $3d  ; 61
        STRAY                           ;= $3e  ; 62
        PALIDOR                         ;= $3f  ; 63
        TRITOCH                         ;= $40  ; 64
        ODIN                            ;= $41  ; 65
        RAIDEN                          ;= $42  ; 66
        BAHAMUT                         ;= $43  ; 67
        ALEXANDR                        ;= $44  ; 68
        CRUSADER                        ;= $45  ; 69
        RAGNAROK                        ;= $46  ; 70
        KIRIN                           ;= $47  ; 71
        ZONESEEK                        ;= $48  ; 72
        CARBUNKL                        ;= $49  ; 73
        PHANTOM                         ;= $4a  ; 74
        SRAPHIM                         ;= $4b  ; 75
        GOLEM                           ;= $4c  ; 76
        UNICORN                         ;= $4d  ; 77
        FENRIR                          ;= $4e  ; 78
        STARLET                         ;= $4f  ; 79
        PHOENIX                         ;= $50  ; 80

; ninja scrolls
        FIRE_SKEAN                      ;= $51  ; 81
        WATER_EDGE                      ;= $52  ; 82
        BOLT_EDGE                       ;= $53  ; 83

; umaro's storm
        STORM                           ;= $54  ; 84

; bushido
        DISPATCH                        ;= $55  ; 85
        RETORT                          ;= $56  ; 86
        SLASH                           ;= $57  ; 87
        QUADRA_SLAM                     ;= $58  ; 88
        EMPOWERER                       ;= $59  ; 89
        STUNNER                         ;= $5a  ; 90
        QUADRA_SLICE                    ;= $5b  ; 91
        CLEAVE                          ;= $5c  ; 92

; blitz
        PUMMEL                          ;= $5d  ; 93
        AURABOLT                        ;= $5e  ; 94
        SUPLEX                          ;= $5f  ; 95
        FIRE_DANCE                      ;= $60  ; 96
        MANTRA                          ;= $61  ; 97
        AIR_BLADE                       ;= $62  ; 98
        SPIRALER                        ;= $63  ; 99
        BUM_RUSH                        ;= $64  ; 100

; dance
        WIND_SLASH                      ;= $65  ; 101
        SUN_BATH                        ;= $66  ; 102
        RAGE                            ;= $67  ; 103
        HARVESTER                       ;= $68  ; 104
        SAND_STORM                      ;= $69  ; 105
        ANTLION                         ;= $6a  ; 106
        ELF_FIRE                        ;= $6b  ; 107
        SPECTER                         ;= $6c  ; 108
        LAND_SLIDE                      ;= $6d  ; 109
        SONIC_BOOM                      ;= $6e  ; 110
        EL_NINO                         ;= $6f  ; 111
        PLASMA                          ;= $70  ; 112
        SNARE                           ;= $71  ; 113
        CAVE_IN                         ;= $72  ; 114
        SNOWBALL                        ;= $73  ; 115
        SURGE                           ;= $74  ; 116
        COKATRICE                       ;= $75  ; 117
        WOMBAT                          ;= $76  ; 118
        KITTY                           ;= $77  ; 119
        TAPIR                           ;= $78  ; 120
        WHUMP                           ;= $79  ; 121
        WILD_BEAR                       ;= $7a  ; 122
        POIS_FROG                       ;= $7b  ; 123
        ICE_RABBIT                      ;= $7c  ; 124

; tools
        BIO_BLAST_TOOL                  ;= $7d  ; 125
        FLASH_TOOL                      ;= $7e  ; 126

; slot
        CHOCOBOP                        ;= $7f  ; 127
        H_BOMB                          ;= $80  ; 128
        SEVEN_FLUSH                     ;= $81  ; 129

; leo's shock
        SHOCK                           ;= $82  ; 130

; magitek
        FIRE_BEAM                       ;= $83  ; 131
        BOLT_BEAM                       ;= $84  ; 132
        ICE_BEAM                        ;= $85  ; 133
        BIO_BLAST_MAGITEK               ;= $86  ; 134
        HEAL_FORCE                      ;= $87  ; 135
        CONFUSER                        ;= $88  ; 136
        XFER                            ;= $89  ; 137
        TEKMISSILE                      ;= $8a  ; 138

; lore
        CONDEMNED                       ;= $8b  ; 139
        ROULETTE                        ;= $8c  ; 140
        CLEANSWEEP                      ;= $8d  ; 141
        AQUA_RAKE                       ;= $8e  ; 142
        AERO                            ;= $8f  ; 143
        BLOW_FISH                       ;= $90  ; 144
        BIG_GUARD                       ;= $91  ; 145
        REVENGE                         ;= $92  ; 146
        WHITE_WIND                      ;= $93  ; 147
        L5_DOOM                         ;= $94  ; 148
        L4_FLARE                        ;= $95  ; 149
        L3_CONFUSE                      ;= $96  ; 150
        REFLECT_LORE                    ;= $97  ; 151
        PEARL_LORE                      ;= $98  ; 152
        STEP_MINE                       ;= $99  ; 153
        FORCEFIELD                      ;= $9a  ; 154
        DISCHORD                        ;= $9b  ; 155
        SOUR_MOUTH                      ;= $9c  ; 156
        PEP_UP                          ;= $9d  ; 157
        RIPPLER                         ;= $9e  ; 158
        STONE                           ;= $9f  ; 159
        QUASAR                          ;= $a0  ; 160
        GRANDTRAIN                      ;= $a1  ; 161
        EXPLODER                        ;= $a2  ; 162

; monster attacks
        IMP_SONG                        ;= $a3  ; 163
        CLEAR                           ;= $a4  ; 164
        VIRITE                          ;= $a5  ; 165
        CHOKESMOKE                      ;= $a6  ; 166
        SCHILLER                        ;= $a7  ; 167
        LULLABY                         ;= $a8  ; 168
        ACID_RAIN                       ;= $a9  ; 169
        CONFUSION                       ;= $aa  ; 170
        MEGAZERK                        ;= $ab  ; 171
        ENEMY_MUTE                      ;= $ac  ; 172
        NET                             ;= $ad  ; 173
        SLIMER                          ;= $ae  ; 174
        DELTA_HIT                       ;= $af  ; 175
        ENTWINE                         ;= $b0  ; 176
        BLASTER                         ;= $b1  ; 177
        CYCLONIC                        ;= $b2  ; 178
        FIRE_BALL                       ;= $b3  ; 179
        ATOMIC_RAY                      ;= $b4  ; 180
        TEK_LASER                       ;= $b5  ; 181
        DIFFUSER                        ;= $b6  ; 182
        WAVECANNON                      ;= $b7  ; 183
        MEGA_VOLT                       ;= $b8  ; 184
        GIGA_VOLT                       ;= $b9  ; 185
        SNOWSTORM                       ;= $ba  ; 186
        ABSOLUTE0                       ;= $bb  ; 187
        MAGNITUDE8                      ;= $bc  ; 188
        RAID                            ;= $bd  ; 189
        FLASH_RAIN                      ;= $be  ; 190
        TEKBARRIER                      ;= $bf  ; 191
        FALLEN_ONE                      ;= $c0  ; 192
        WALLCHANGE                      ;= $c1  ; 193
        ESCAPE                          ;= $c2  ; 194
        FIFTY_GS                        ;= $c3  ; 195
        MIND_BLAST                      ;= $c4  ; 196
        N_CROSS                         ;= $c5  ; 197
        FLARE_STAR                      ;= $c6  ; 198
        LOVE_TOKEN                      ;= $c7  ; 199
        SEIZE                           ;= $c8  ; 200
        R_POLARITY                      ;= $c9  ; 201
        TARGETTING                      ;= $ca  ; 202
        SNEEZE                          ;= $cb  ; 203
        S_CROSS                         ;= $cc  ; 204
        LAUNCHER                        ;= $cd  ; 205
        CHARM                           ;= $ce  ; 206
        COLD_DUST                       ;= $cf  ; 207
        TENTACLE                        ;= $d0  ; 208
        HYPERDRIVE                      ;= $d1  ; 209
        TRAIN                           ;= $d2  ; 210
        EVIL_TOOT                       ;= $d3  ; 211
        GRAV_BOMB                       ;= $d4  ; 212
        ENGULF                          ;= $d5  ; 213
        DISASTER                        ;= $d6  ; 214
        SHRAPNEL                        ;= $d7  ; 215
        BOMBLET                         ;= $d8  ; 216
        HEART_BURN                      ;= $d9  ; 217
        ZINGER                          ;= $da  ; 218
        DISCARD                         ;= $db  ; 219
        OVERCAST                        ;= $dc  ; 220
        MISSILE                         ;= $dd  ; 221
        GONER                           ;= $de  ; 222
        METEO                           ;= $df  ; 223
        REVENGER                        ;= $e0  ; 224
        PHANTASM                        ;= $e1  ; 225
        DREAD                           ;= $e2  ; 226
        SHOCK_WAVE                      ;= $e3  ; 227
        BLAZE                           ;= $e4  ; 228
        SOUL_OUT                        ;= $e5  ; 229
        GALE_CUT                        ;= $e6  ; 230
        SHIMSHAM                        ;= $e7  ; 231
        LODE_STONE                      ;= $e8  ; 232
        SCAR_BEAM                       ;= $e9  ; 233
        BABABREATH                      ;= $ea  ; 234
        LIFESHAVER                      ;= $eb  ; 235
        FIRE_WALL                       ;= $ec  ; 236
        SLIDE                           ;= $ed  ; 237

; normal monster attack
        BATTLE                          ;= $ee  ; 238

; special monster attack
        SPECIAL                         ;= $ef  ; 239

; character desperation attacks
        RIOT_BLADE                      ;= $f0  ; 240
        MIRAGER                         ;= $f1  ; 241
        BACK_BLADE                      ;= $f2  ; 242
        SHADOWFANG                      ;= $f3  ; 243
        ROYALSHOCK                      ;= $f4  ; 244
        TIGERBREAK                      ;= $f5  ; 245
        SPIN_EDGE                       ;= $f6  ; 246
        SABRESOUL                       ;= $f7  ; 247
        STAR_PRISM                      ;= $f8  ; 248
        RED_CARD                        ;= $f9  ; 249
        MOOGLERUSH                      ;= $fa  ; 250
        X_METEO                         ;= $fb  ; 251

; interceptor attacks
        TAKEDOWN                        ;= $fc  ; 252
        WILD_FANG                       ;= $fd  ; 253

; mysidian rabbit (lagomorph)
        LAGOMORPH                       ;= $fe  ; 254

        NONE                            ;= $ff  ; 255

        FIRST_BLACK_MAGIC = FIRE
        FIRST_EFFECT_MAGIC = SCAN
        FIRST_WHITE_MAGIC = CURE
        FIRST_GENJU = RAMUH
        FIRST_NINJA = FIRE_SKEAN
        FIRST_BUSHIDO = DISPATCH
        FIRST_BLITZ = PUMMEL
        FIRST_DANCE = WIND_SLASH
        FIRST_TOOL = BIO_BLAST_TOOL
        FIRST_MAGITEK = FIRE_BEAM
        FIRST_LORE = CONDEMNED
        FIRST_DESPERATION = RIOT_BLADE
        FIRST_INTERCEPTOR = TAKEDOWN

        NUM_BLACK_MAGIC = FIRST_EFFECT_MAGIC
        NUM_EFFECT_MAGIC = FIRST_WHITE_MAGIC - FIRST_EFFECT_MAGIC
        NUM_WHITE_MAGIC = FIRST_GENJU - FIRST_WHITE_MAGIC

        NUM_MAGIC = FIRST_GENJU
        NUM_GENJU = FIRST_NINJA - FIRST_GENJU
        NUM_LORE = 24

.endenum

; ------------------------------------------------------------------------------

; genju bonus ids
.enum GENJU_BONUS
        HP_10
        HP_30
        HP_50
        MP_10
        MP_30
        MP_50
        HP_100
        LV_30
        LV_50
        STRENGTH_1
        STRENGTH_2
        SPEED_1
        SPEED_2
        STAMINA_1
        STAMINA_2
        MAGPWR_1
        MAGPWR_2

        COUNT
        NONE = $ff
.endenum

; ------------------------------------------------------------------------------

.enum BLITZ_CODE
        NONE                            ; = 0
        A_BUTTON                        ; = 1
        B_BUTTON                        ; = 2
        X_BUTTON                        ; = 3
        Y_BUTTON                        ; = 4
        L_BUTTON                        ; = 5
        R_BUTTON                        ; = 6
        DOWN_LEFT                       ; = 7
        DOWN                            ; = 8
        DOWN_RIGHT                      ; = 9
        RIGHT                           ; = 10
        UP_RIGHT                        ; = 11
        UP                              ; = 12
        UP_LEFT                         ; = 13
        LEFT                            ; = 14
.endenum

; ------------------------------------------------------------------------------

.enum WEAPON_FLAG
        PALADIN_SHLD                    = %00000001  ; no effect
        BUSHIDO                         = %00000010
        ;                               = %00000100
        ;                               = %00001000
        ;                               = %00010000
        BACK_ROW                        = %00100000
        TWO_HAND                        = %01000000
        RUNIC                           = %10000000
.endenum

; ------------------------------------------------------------------------------

.enum ITEM_FLAG
        ;                               = %00000001
        INVERT_UNDEAD                   = %00000010
        ;                               = %00000100
        AFFECT_HP                       = %00001000
        AFFECT_MP                       = %00010000
        REMOVE_STATUS                   = %00100000
        CAUSE_DAMAGE                    = %01000000
        FRACTIONAL_POWER                = %10000000
.endenum

; ------------------------------------------------------------------------------

.enum BATTLE_TYPE
        NORMAL                          ;= 0
        BACK                            ;= 1
        PINCER                          ;= 2
        SIDE                            ;= 3

        COUNT

        MASK = %11
.endenum

; ------------------------------------------------------------------------------

; monster ids
.enum MONSTER
        GUARD                           ;= $0000  ; 0
        SOLDIER                         ;= $0001  ; 1
        TEMPLAR                         ;= $0002  ; 2
        NINJA                           ;= $0003  ; 3
        SAMURAI                         ;= $0004  ; 4
        OROG                            ;= $0005  ; 5
        MAG_ROADER_1                    ;= $0006  ; 6
        RETAINER                        ;= $0007  ; 7
        HAZER                           ;= $0008  ; 8
        DAHLING                         ;= $0009  ; 9
        RAIN_MAN                        ;= $000a  ; 10
        BRAWLER                         ;= $000b  ; 11
        APOKRYPHOS                      ;= $000c  ; 12
        DARK_FORCE                      ;= $000d  ; 13
        WHISPER                         ;= $000e  ; 14
        OVER_MIND                       ;= $000f  ; 15
        OSTEOSAUR                       ;= $0010  ; 16
        COMMANDER                       ;= $0011  ; 17
        RHODOX                          ;= $0012  ; 18
        WERE_RAT                        ;= $0013  ; 19
        URSUS                           ;= $0014  ; 20
        RHINOTAUR                       ;= $0015  ; 21
        STEROIDITE                      ;= $0016  ; 22
        LEAFER                          ;= $0017  ; 23
        STRAY_CAT                       ;= $0018  ; 24
        LOBO                            ;= $0019  ; 25
        DOBERMAN                        ;= $001a  ; 26
        VOMAMMOTH                       ;= $001b  ; 27
        FIDOR                           ;= $001c  ; 28
        BASKERVOR                       ;= $001d  ; 29
        SURIANDER                       ;= $001e  ; 30
        CHIMERA                         ;= $001f  ; 31
        BEHEMOTH                        ;= $0020  ; 32
        MESOSAUR                        ;= $0021  ; 33
        PTERODON                        ;= $0022  ; 34
        FOSSILFANG                      ;= $0023  ; 35
        WHITE_DRGN                      ;= $0024  ; 36
        DOOM_DRGN                       ;= $0025  ; 37
        BRACHOSAUR                      ;= $0026  ; 38
        TYRANOSAUR                      ;= $0027  ; 39
        DARK_WIND                       ;= $0028  ; 40
        BEAKOR                          ;= $0029  ; 41
        VULTURE                         ;= $002a  ; 42
        HARPY                           ;= $002b  ; 43
        HERMITCRAB                      ;= $002c  ; 44
        TRAPPER                         ;= $002d  ; 45
        HORNET                          ;= $002e  ; 46
        CRASSHOPPR                      ;= $002f  ; 47
        DELTA_BUG                       ;= $0030  ; 48
        GILOMANTIS                      ;= $0031  ; 49
        TRILIUM                         ;= $0032  ; 50
        NIGHTSHADE                      ;= $0033  ; 51
        TUMBLEWEED                      ;= $0034  ; 52
        BLOOMPIRE                       ;= $0035  ; 53
        TRILOBITER                      ;= $0036  ; 54
        SIEGFRIED_1                     ;= $0037  ; 55
        NAUTILOID                       ;= $0038  ; 56
        EXOCITE                         ;= $0039  ; 57
        ANGUIFORM                       ;= $003a  ; 58
        REACH_FROG                      ;= $003b  ; 59
        LIZARD                          ;= $003c  ; 60
        CHICKENLIP                      ;= $003d  ; 61
        HOOVER                          ;= $003e  ; 62
        RIDER                           ;= $003f  ; 63
        CHUPON_COLOSSEUM                ;= $0040  ; 64
        PIPSQUEAK                       ;= $0041  ; 65
        M_TEKARMOR                      ;= $0042  ; 66
        SKY_ARMOR                       ;= $0043  ; 67
        TELSTAR                         ;= $0044  ; 68
        LETHAL_WPN                      ;= $0045  ; 69
        VAPORITE                        ;= $0046  ; 70
        FLAN                            ;= $0047  ; 71
        ING                             ;= $0048  ; 72
        HUMPTY                          ;= $0049  ; 73
        BRAINPAN                        ;= $004a  ; 74
        CRULLER                         ;= $004b  ; 75
        CACTROT                         ;= $004c  ; 76
        REPO_MAN                        ;= $004d  ; 77
        HARVESTER                       ;= $004e  ; 78
        BOMB                            ;= $004f  ; 79
        STILL_LIFE                      ;= $0050  ; 80
        BOXED_SET                       ;= $0051  ; 81
        SLAMDANCER                      ;= $0052  ; 82
        HADESGIGAS                      ;= $0053  ; 83
        PUG                             ;= $0054  ; 84
        MAGIC_URN                       ;= $0055  ; 85
        MOVER                           ;= $0056  ; 86
        FIGALIZ                         ;= $0057  ; 87
        BUFFALAX                        ;= $0058  ; 88
        ASPIK                           ;= $0059  ; 89
        GHOST                           ;= $005a  ; 90
        CRAWLER                         ;= $005b  ; 91
        SAND_RAY                        ;= $005c  ; 92
        ARENEID                         ;= $005d  ; 93
        ACTANEON                        ;= $005e  ; 94
        SAND_HORSE                      ;= $005f  ; 95
        DARK_SIDE                       ;= $0060  ; 96
        MAD_OSCAR                       ;= $0061  ; 97
        CRAWLY                          ;= $0062  ; 98
        BLEARY                          ;= $0063  ; 99
        MARSHAL                         ;= $0064  ; 100
        TROOPER                         ;= $0065  ; 101
        GENERAL                         ;= $0066  ; 102
        COVERT                          ;= $0067  ; 103
        OGOR                            ;= $0068  ; 104
        WARLOCK                         ;= $0069  ; 105
        MADAM                           ;= $006a  ; 106
        JOKER                           ;= $006b  ; 107
        IRON_FIST                       ;= $006c  ; 108
        GOBLIN                          ;= $006d  ; 109
        APPARITE                        ;= $006e  ; 110
        POWERDEMON                      ;= $006f  ; 111
        DISPLAYER                       ;= $0070  ; 112
        VECTOR_PUP                      ;= $0071  ; 113
        PEEPERS                         ;= $0072  ; 114
        SEWER_RAT                       ;= $0073  ; 115
        SLATTER                         ;= $0074  ; 116
        RHINOX                          ;= $0075  ; 117
        RHOBITE                         ;= $0076  ; 118
        WILD_CAT                        ;= $0077  ; 119
        RED_FANG                        ;= $0078  ; 120
        BOUNTY_MAN                      ;= $0079  ; 121
        TUSKER                          ;= $007a  ; 122
        RALPH                           ;= $007b  ; 123
        CHITONID                        ;= $007c  ; 124
        WART_PUCK                       ;= $007d  ; 125
        RHYOS                           ;= $007e  ; 126
        SRBEHEMOTH_UNDEAD               ;= $007f  ; 127
        VECTAUR                         ;= $0080  ; 128
        WYVERN                          ;= $0081  ; 129
        ZOMBONE                         ;= $0082  ; 130
        DRAGON                          ;= $0083  ; 131
        BRONTAUR                        ;= $0084  ; 132
        ALLOSAURUS                      ;= $0085  ; 133
        CIRPIUS                         ;= $0086  ; 134
        SPRINTER                        ;= $0087  ; 135
        GOBBLER                         ;= $0088  ; 136
        HARPIAI                         ;= $0089  ; 137
        GLOOMSHELL                      ;= $008a  ; 138
        DROP                            ;= $008b  ; 139
        MIND_CANDY                      ;= $008c  ; 140
        WEEDFEEDER                      ;= $008d  ; 141
        LURIDAN                         ;= $008e  ; 142
        TOE_CUTTER                      ;= $008f  ; 143
        OVER_GRUNK                      ;= $0090  ; 144
        EXORAY                          ;= $0091  ; 145
        CRUSHER                         ;= $0092  ; 146
        UROBUROS                        ;= $0093  ; 147
        PRIMORDITE                      ;= $0094  ; 148
        SKY_CAP                         ;= $0095  ; 149
        CEPHALER                        ;= $0096  ; 150
        MALIGA                          ;= $0097  ; 151
        GIGAN_TOAD                      ;= $0098  ; 152
        GECKOREX                        ;= $0099  ; 153
        CLUCK                           ;= $009a  ; 154
        LAND_WORM                       ;= $009b  ; 155
        TEST_RIDER                      ;= $009c  ; 156
        PLUTOARMOR                      ;= $009d  ; 157
        TOMB_THUMB                      ;= $009e  ; 158
        HEAVYARMOR                      ;= $009f  ; 159
        CHASER                          ;= $00a0  ; 160
        SCULLION                        ;= $00a1  ; 161
        POPLIUM                         ;= $00a2  ; 162
        INTANGIR                        ;= $00a3  ; 163
        MISFIT                          ;= $00a4  ; 164
        ELAND                           ;= $00a5  ; 165
        ENUO                            ;= $00a6  ; 166
        DEEP_EYE                        ;= $00a7  ; 167
        GREASEMONK                      ;= $00a8  ; 168
        NECKHUNTER                      ;= $00a9  ; 169
        GRENADE                         ;= $00aa  ; 170
        CRITIC                          ;= $00ab  ; 171
        PAN_DORA                        ;= $00ac  ; 172
        SOULDANCER                      ;= $00ad  ; 173
        GIGANTOS                        ;= $00ae  ; 174
        MAG_ROADER_2                    ;= $00af  ; 175
        SPEK_TOR                        ;= $00b0  ; 176
        PARASITE                        ;= $00b1  ; 177
        EARTHGUARD                      ;= $00b2  ; 178
        COELECITE                       ;= $00b3  ; 179
        ANEMONE                         ;= $00b4  ; 180
        HIPOCAMPUS                      ;= $00b5  ; 181
        SPECTRE                         ;= $00b6  ; 182
        EVIL_OSCAR                      ;= $00b7  ; 183
        SLURM                           ;= $00b8  ; 184
        LATIMERIA                       ;= $00b9  ; 185
        STILLGOING                      ;= $00ba  ; 186
        ALLO_VER                        ;= $00bb  ; 187
        PHASE                           ;= $00bc  ; 188
        OUTSIDER                        ;= $00bd  ; 189
        BARB_E                          ;= $00be  ; 190
        PARASOUL                        ;= $00bf  ; 191
        PM_STALKER                      ;= $00c0  ; 192
        HEMOPHYTE                       ;= $00c1  ; 193
        SP_FORCES                       ;= $00c2  ; 194
        NOHRABBIT                       ;= $00c3  ; 195
        WIZARD                          ;= $00c4  ; 196
        SCRAPPER                        ;= $00c5  ; 197
        CERITOPS                        ;= $00c6  ; 198
        COMMANDO                        ;= $00c7  ; 199
        OPINICUS                        ;= $00c8  ; 200
        POPPERS                         ;= $00c9  ; 201
        LUNARIS                         ;= $00ca  ; 202
        GARM                            ;= $00cb  ; 203
        VINDR                           ;= $00cc  ; 204
        KIWOK                           ;= $00cd  ; 205
        NASTIDON                        ;= $00ce  ; 206
        RINN                            ;= $00cf  ; 207
        INSECARE                        ;= $00d0  ; 208
        VERMIN                          ;= $00d1  ; 209
        MANTODEA                        ;= $00d2  ; 210
        BOGY                            ;= $00d3  ; 211
        PRUSSIAN                        ;= $00d4  ; 212
        BLACK_DRGN                      ;= $00d5  ; 213
        ADAMANCHYT                      ;= $00d6  ; 214
        DANTE                           ;= $00d7  ; 215
        WIREY_DRGN                      ;= $00d8  ; 216
        DUELLER                         ;= $00d9  ; 217
        PSYCHOT                         ;= $00da  ; 218
        MUUS                            ;= $00db  ; 219
        KARKASS                         ;= $00dc  ; 220
        PUNISHER                        ;= $00dd  ; 221
        BALLOON                         ;= $00de  ; 222
        GABBLDEGAK                      ;= $00df  ; 223
        GTBEHEMOTH                      ;= $00e0  ; 224
        SCORPION                        ;= $00e1  ; 225
        CHAOS_DRGN                      ;= $00e2  ; 226
        SPIT_FIRE                       ;= $00e3  ; 227
        VECTAGOYLE                      ;= $00e4  ; 228
        LICH                            ;= $00e5  ; 229
        OSPREY                          ;= $00e6  ; 230
        MAG_ROADER_3                    ;= $00e7  ; 231
        BUG                             ;= $00e8  ; 232
        SEA_FLOWER                      ;= $00e9  ; 233
        FORTIS                          ;= $00ea  ; 234
        ABOLISHER                       ;= $00eb  ; 235
        AQUILA                          ;= $00ec  ; 236
        JUNK                            ;= $00ed  ; 237
        MANDRAKE                        ;= $00ee  ; 238
        FIRST_CLASS                     ;= $00ef  ; 239
        TAP_DANCER                      ;= $00f0  ; 240
        NECROMANCR                      ;= $00f1  ; 241
        BORRAS                          ;= $00f2  ; 242
        MAG_ROADER_4                    ;= $00f3  ; 243
        WILD_RAT                        ;= $00f4  ; 244
        GOLD_BEAR                       ;= $00f5  ; 245
        INNOC                           ;= $00f6  ; 246
        TRIXTER                         ;= $00f7  ; 247
        RED_WOLF                        ;= $00f8  ; 248
        DIDALOS                         ;= $00f9  ; 249
        WOOLLY                          ;= $00fa  ; 250
        VETERAN                         ;= $00fb  ; 251
        SKY_BASE                        ;= $00fc  ; 252
        IRONHITMAN                      ;= $00fd  ; 253
        IO                              ;= $00fe  ; 254
        PUGS                            ;= $00ff  ; 255
        WHELK                           ;= $0100  ; 256
        PRESENTER                       ;= $0101  ; 257
        MEGA_ARMOR                      ;= $0102  ; 258
        VARGAS                          ;= $0103  ; 259
        TUNNELARMR                      ;= $0104  ; 260
        PROMETHEUS                      ;= $0105  ; 261
        GHOSTTRAIN                      ;= $0106  ; 262
        DADALUMA                        ;= $0107  ; 263
        SHIVA                           ;= $0108  ; 264
        IFRIT                           ;= $0109  ; 265
        NUMBER_024                      ;= $010a  ; 266
        NUMBER_128                      ;= $010b  ; 267
        INFERNO                         ;= $010c  ; 268
        CRANE_1                         ;= $010d  ; 269
        CRANE_2                         ;= $010e  ; 270
        UMARO_1                         ;= $010f  ; 271
        UMARO_2                         ;= $0110  ; 272
        GUARDIAN_VECTOR                 ;= $0111  ; 273
        GUARDIAN_BOSS                   ;= $0112  ; 274
        AIR_FORCE                       ;= $0113  ; 275
        TRITOCH_INTRO                   ;= $0114  ; 276
        TRITOCH_MORPH                   ;= $0115  ; 277
        FLAMEEATER                      ;= $0116  ; 278
        ATMAWEAPON                      ;= $0117  ; 279
        NERAPA                          ;= $0118  ; 280
        SRBEHEMOTH                      ;= $0119  ; 281
        KEFKA_1                         ;= $011a  ; 282
        TENTACLE                        ;= $011b  ; 283
        DULLAHAN                        ;= $011c  ; 284
        DOOM_GAZE                       ;= $011d  ; 285
        CHADARNOOK_1                    ;= $011e  ; 286
        CURLEY                          ;= $011f  ; 287
        LARRY                           ;= $0120  ; 288
        MOE                             ;= $0121  ; 289
        WREXSOUL                        ;= $0122  ; 290
        HIDON                           ;= $0123  ; 291
        KATANASOUL                      ;= $0124  ; 292
        L30_MAGIC                       ;= $0125  ; 293
        HIDONITE                        ;= $0126  ; 294
        DOOM                            ;= $0127  ; 295
        GODDESS                         ;= $0128  ; 296
        POLTRGEIST                      ;= $0129  ; 297
        FINAL_KEFKA                     ;= $012a  ; 298
        L40_MAGIC                       ;= $012b  ; 299
        ULTROS_RIVER                    ;= $012c  ; 300
        ULTROS_OPERA                    ;= $012d  ; 301
        ULTROS_MOUNTAIN                 ;= $012e  ; 302
        CHUPON_AIRSHIP                  ;= $012f  ; 303
        L20_MAGIC                       ;= $0130  ; 304
        SIEGFRIED_2                     ;= $0131  ; 305
        L10_MAGIC                       ;= $0132  ; 306
        L50_MAGIC                       ;= $0133  ; 307
        HEAD                            ;= $0134  ; 308
        WHELK_HEAD                      ;= $0135  ; 309
        COLOSSUS                        ;= $0136  ; 310
        CZARDRAGON                      ;= $0137  ; 311
        MASTER_PUG                      ;= $0138  ; 312
        L60_MAGIC                       ;= $0139  ; 313
        MERCHANT                        ;= $013a  ; 314
        B_DAY_SUIT                      ;= $013b  ; 315
        TENTACLE_1                      ;= $013c  ; 316
        TENTACLE_2                      ;= $013d  ; 317
        TENTACLE_3                      ;= $013e  ; 318
        RIGHTBLADE                      ;= $013f  ; 319
        LEFT_BLADE                      ;= $0140  ; 320
        ROUGH                           ;= $0141  ; 321
        STRIKER                         ;= $0142  ; 322
        L70_MAGIC                       ;= $0143  ; 323
        TRITOCH_BOSS                    ;= $0144  ; 324
        LASER_GUN                       ;= $0145  ; 325
        SPECK                           ;= $0146  ; 326
        MISSILEBAY                      ;= $0147  ; 327
        CHADARNOOK_2                    ;= $0148  ; 328
        ICE_DRAGON                      ;= $0149  ; 329
        KEFKA_NARSHE                    ;= $014a  ; 330
        STORM_DRGN                      ;= $014b  ; 331
        DIRT_DRGN                       ;= $014c  ; 332
        IPOOH                           ;= $014d  ; 333
        LEADER                          ;= $014e  ; 334
        GRUNT                           ;= $014f  ; 335
        GOLD_DRGN                       ;= $0150  ; 336
        SKULL_DRGN                      ;= $0151  ; 337
        BLUE_DRGN                       ;= $0152  ; 338
        RED_DRAGON                      ;= $0153  ; 339
        PIRANHA                         ;= $0154  ; 340
        RIZOPAS                         ;= $0155  ; 341
        SPECTER                         ;= $0156  ; 342
        SHORT_ARM                       ;= $0157  ; 343
        LONG_ARM                        ;= $0158  ; 344
        FACE                            ;= $0159  ; 345
        TIGER                           ;= $015a  ; 346
        TOOLS                           ;= $015b  ; 347
        MAGIC                           ;= $015c  ; 348
        HIT                             ;= $015d  ; 349
        GIRL                            ;= $015e  ; 350
        SLEEP                           ;= $015f  ; 351
        HIDONITE_1                      ;= $0160  ; 352
        HIDONITE_2                      ;= $0161  ; 353
        HIDONITE_3                      ;= $0162  ; 354
        L80_MAGIC                       ;= $0163  ; 355
        L90_MAGIC                       ;= $0164  ; 356
        PROTOARMOR                      ;= $0165  ; 357
        MAGIMASTER                      ;= $0166  ; 358
        SOULSAVER                       ;= $0167  ; 359
        ULTROS_AIRSHIP                  ;= $0168  ; 360
        NAUGHTY                         ;= $0169  ; 361
        PHUNBABA_1                      ;= $016a  ; 362
        PHUNBABA_2                      ;= $016b  ; 363
        PHUNBABA_3                      ;= $016c  ; 364
        PHUNBABA_4                      ;= $016d  ; 365
        TERRA_FLASHBACK                 ;= $016e  ; 366
        KEFKA_IMP_CAMP                  ;= $016f  ; 367
        CYAN_IMP_CAMP                   ;= $0170  ; 368
        ZONE_EATER                      ;= $0171  ; 369
        GAU_VELDT                       ;= $0172  ; 370
        KEFKA_VS_LEO                    ;= $0173  ; 371
        KEFKA_ESPER_GATE                ;= $0174  ; 372
        OFFICER                         ;= $0175  ; 373
        CADET                           ;= $0176  ; 374
        MONSTER_0177                    ;= $0177  ; 375
        MONSTER_0178                    ;= $0178  ; 376
        SOLDIER_FLASHBACK               ;= $0179  ; 377
        KEFKA_GENJU_MAGICITE            ;= $017a  ; 378
        EVENT                           ;= $017b  ; 379
        MONSTER_017C                    ;= $017c  ; 380
        ATMA                            ;= $017d  ; 381
        SHADOW_COLOSSEUM                ;= $017e  ; 382
        COLOSSEUM                       ;= $017f  ; 383
.endenum

.enum GENJU_GFX
        RAMUH = $0180
        IFRIT
        SHIVA
        SIREN
        TERRATO
        SHOAT
        MADUIN
        BISMARK
        STRAY
        PALIDOR
        TRITOCH
        ODIN
        RAIDEN
        BAHAMUT
        ALEXANDR
        CRUSADER_1
        RAGNAROK
        KIRIN
        ZONESEEK
        CARBUNKL
        PHANTOM
        SRAPHIM
        GOLEM
        UNICORN
        FENRIR
        STARLET
        PHOENIX
        TIGERBREAK
        CRUSADER_2
        CRUSADER_3
        IMP
.endenum

; ------------------------------------------------------------------------------

; dance ids
.enum DANCE
        WIND_SONG                       ;= 0
        FOREST_SUITE                    ;= 1
        DESERT_ARIA                     ;= 2
        LOVE_SONATA                     ;= 3
        EARTH_BLUES                     ;= 4
        WATER_RONDO                     ;= 5
        DUSK_REQUIEM                    ;= 6
        SNOWMAN_JAZZ                    ;= 7
.endenum

; ------------------------------------------------------------------------------

; target selection flags
.enum TARGET
        MANUAL                          = %00000001  ; can move cursor manually
        ONE_SIDE                        = %00000010  ; can't target opposite side
        INIT_MASK                       = %00001100  ; mask for initial target
        INIT_SINGLE                     = %00000000  ; single target
        INIT_ALL                        = %00000100  ; all characters and monsters
        INIT_GROUP                      = %00001000  ; one target group (one side)
        INIT_HALF                       = %00001100  ; all characters or all monsters
        AUTO_CONFIRM                    = %00010000  ; don't wait for A button
        MULTI_TARGET                    = %00100000  ; allow L/R button multi-target
        ENEMY                           = %01000000  ; target enemy by default
        ROULETTE                        = %10000000  ; random roulette cursor

; special values, not flags
        SELF                            = %00000010  ; cursor on attacker
        MENU                            = %11111111  ; uses a menu to choose target
.endenum

; ------------------------------------------------------------------------------

; battle command flags
.enum BATTLE_CMD_FLAG
        NONE                            = %00000000  ; no flags set
        GOGO                            = %00000001  ; can be used by gogo
        MIMIC                           = %00000010  ; can be mimicked
        IMP                             = %00000100  ; can be used by imp
        UNKNOWN                         = %00001000  ; unknown
.endenum

; ------------------------------------------------------------------------------

.enum CHAR_PROP
        TERRA                           ; = $00 // 0
        LOCKE                           ; = $01 // 1
        CYAN                            ; = $02 // 2
        SHADOW                          ; = $03 // 3
        EDGAR                           ; = $04 // 4
        SABIN                           ; = $05 // 5
        CELES                           ; = $06 // 6
        STRAGO                          ; = $07 // 7
        RELM                            ; = $08 // 8
        SETZER                          ; = $09 // 9
        MOG                             ; = $0a // 10
        GAU                             ; = $0b // 11
        GOGO                            ; = $0c // 12
        UMARO                           ; = $0d // 13
        BANON                           ; = $0e // 14
        LEO                             ; = $0f // 15
        GHOST_1                         ; = $10 // 16
        GHOST_2                         ; = $11 // 17
        KUPEK                           ; = $12 // 18
        KUPOP                           ; = $13 // 19
        KUMAMA                          ; = $14 // 20
        KUKU                            ; = $15 // 21
        KUTAN                           ; = $16 // 22
        KUPAN                           ; = $17 // 23
        KUSHU                           ; = $18 // 24
        KURIN                           ; = $19 // 25
        KURU                            ; = $1a // 26
        KAMOG                           ; = $1b // 27
        SCENARIO_MOG                    ; = $1c // 28
        TERRA_INTRO                     ; = $1d // 29
        MADUIN                          ; = $1e // 30
        SHADOW_COLOSSEUM                ; = $1f // 31
        WEDGE                           ; = $20 // 32
        VICKS                           ; = $21 // 33
        UNUSED_22                       ; = $22 // 34
        UNUSED_23                       ; = $23 // 35
        UNUSED_24                       ; = $24 // 36
        UNUSED_25                       ; = $25 // 37
        UNUSED_26                       ; = $26 // 38
        UNUSED_27                       ; = $27 // 39
        UNUSED_28                       ; = $28 // 40
        KEFKA_1                         ; = $29 // 41
        KEFKA_2                         ; = $2a // 42
        KEFKA_3                         ; = $2b // 43
        KEFKA_4                         ; = $2c // 44
        KEFKA_5                         ; = $2d // 45
        KEFKA_6                         ; = $2e // 46
        KEFKA_7                         ; = $2f // 47
        TORK                            ; = $30 // 48
        JADE                            ; = $31 // 49
        CUSTER                          ; = $32 // 50
        FABIAN                          ; = $33 // 51
        DRAKE                           ; = $34 // 52
        SARA                            ; = $35 // 53
        CASE                            ; = $36 // 54
        SIELE                           ; = $37 // 55
        RAY                             ; = $38 // 56
        REIKER                          ; = $39 // 57
        LANCE                           ; = $3a // 58
        BOB                             ; = $3b // 59
        PEPPER                          ; = $3c // 60
        TAU                             ; = $3d // 61
        VICTOR                          ; = $3e // 62
        HO                              ; = $3f // 63
.endenum

; character run factor values
.enum CHAR_RUN_FACTOR
        HIGH                            = %00000000  ; 125%
        NORMAL                          = %00000001  ; 100%
        LOW                             = %00000010  ; 75%
        VERY_LOW                        = %00000011  ; 50%
        MASK                            = %00000011
.endenum

; character level modifiers (see CharLevelModTbl)
.enum CHAR_LEVEL_MOD
        NORMAL                          = %00000000  ; +0
        HIGH                            = %00000100  ; +2
        VERY_HIGH                       = %00001000  ; +5
        LOW                             = %00001100  ; -3
        MASK                            = %00001100
.endenum

; character fixed equipment flag
CHAR_PROP_FIXED_EQUIP                   = %00010000

; ------------------------------------------------------------------------------

.enum CHAR_FLAG
        TERRA                           = %0000000000000001
        LOCKE                           = %0000000000000010
        CYAN                            = %0000000000000100
        SHADOW                          = %0000000000001000
        EDGAR                           = %0000000000010000
        SABIN                           = %0000000000100000
        CELES                           = %0000000001000000
        STRAGO                          = %0000000010000000
        RELM                            = %0000000100000000
        SETZER                          = %0000001000000000
        MOG                             = %0000010000000000
        GAU                             = %0000100000000000
        GOGO                            = %0001000000000000
        UMARO                           = %0010000000000000
.endenum

; ------------------------------------------------------------------------------

; element bitmasks

.enum ELEMENT
        FIRE                            = %00000001
        ICE                             = %00000010
        LIGHTNING                       = %00000100
        POISON                          = %00001000
        WIND                            = %00010000
        HOLY                            = %00100000
        EARTH                           = %01000000
        WATER                           = %10000000
        ALL                             = $ff
        NONE                            = 0
.endenum

; ------------------------------------------------------------------------------

; status effects in sequential order (not bitmasks)
.enum STATUS_ID
        BLIND
        ZOMBIE
        POISON
        MAGITEK
        VANISH
        IMP
        PETRIFY
        DEAD
        CONDEMNED
        NEAR_FATAL
        IMAGE
        SILENCE
        BERSERK
        CONFUSE
        SAP
        SLEEP
        DANCE
        REGEN
        SLOW
        HASTE
        STOP
        SHELL
        SAFE
        REFLECT
        RAGE
        FROZEN
        RERAISE
        MORPH
        CONTROL
        HIDE
        INTERCEPTOR
        FLOAT

        COUNT
.endenum

; status 1: harmful status that persist after battle
.enum STATUS1
        BLIND                           = %00000001
        ZOMBIE                          = %00000010
        POISON                          = %00000100
        MAGITEK                         = %00001000
        VANISH                          = %00010000
        IMP                             = %00100000
        PETRIFY                         = %01000000
        DEAD                            = %10000000
        ALL                             = $ff
        NONE                            = 0
.endenum

; status 2: harmful status that do not persist after battle
.enum STATUS2
        CONDEMNED                       = %00000001
        NEAR_FATAL                      = %00000010
        IMAGE                           = %00000100
        SILENCE                         = %00001000
        BERSERK                         = %00010000
        CONFUSE                         = %00100000
        SAP                             = %01000000
        SLEEP                           = %10000000
        ALL                             = $ff
        NONE                            = 0
.endenum

; status 3: helpful status that do not persist after battle
.enum STATUS3
        DANCE                           = %00000001
        FLYING                          = DANCE  ; for items and monsters
        REGEN                           = %00000010
        SLOW                            = %00000100
        HASTE                           = %00001000
        STOP                            = %00010000
        SHELL                           = %00100000
        SAFE                            = %01000000
        REFLECT                         = %10000000
        ALL                             = $ff
        NONE                            = 0
.endenum

; status 4: only float and interceptor persist after battle
.enum STATUS4
        RAGE                            = %00000001
        FROZEN                          = %00000010
        RERAISE                         = %00000100
        MORPH                           = %00001000
        CONTROL                         = %00010000
        HIDE                            = %00100000
        INTERCEPTOR                     = %01000000
        FLOAT                           = %10000000
        ALL                             = $ff
        NONE                            = 0
.endenum

; 16-bit combined status 1 and 2
.enum STATUS12
        BLIND                           = STATUS1::BLIND
        ZOMBIE                          = STATUS1::ZOMBIE
        POISON                          = STATUS1::POISON
        MAGITEK                         = STATUS1::MAGITEK
        VANISH                          = STATUS1::VANISH
        IMP                             = STATUS1::IMP
        PETRIFY                         = STATUS1::PETRIFY
        DEAD                            = STATUS1::DEAD
        CONDEMNED                       = STATUS2::CONDEMNED << 8
        NEAR_FATAL                      = STATUS2::NEAR_FATAL << 8
        IMAGE                           = STATUS2::IMAGE << 8
        SILENCE                         = STATUS2::SILENCE << 8
        BERSERK                         = STATUS2::BERSERK << 8
        CONFUSE                         = STATUS2::CONFUSE << 8
        SAP                             = STATUS2::SAP << 8
        SLEEP                           = STATUS2::SLEEP << 8
        ALL                             = $ffff
        NONE                            = 0
.endenum

; 16-bit combined status 2 and 3
.enum STATUS23
        CONDEMNED                       = STATUS2::CONDEMNED
        NEAR_FATAL                      = STATUS2::NEAR_FATAL
        IMAGE                           = STATUS2::IMAGE
        SILENCE                         = STATUS2::SILENCE
        BERSERK                         = STATUS2::BERSERK
        CONFUSE                         = STATUS2::CONFUSE
        SAP                             = STATUS2::SAP
        SLEEP                           = STATUS2::SLEEP
        DANCE                           = STATUS3::DANCE << 8
        FLYING                          = STATUS3::FLYING << 8
        REGEN                           = STATUS3::REGEN << 8
        SLOW                            = STATUS3::SLOW << 8
        HASTE                           = STATUS3::HASTE << 8
        STOP                            = STATUS3::STOP << 8
        SHELL                           = STATUS3::SHELL << 8
        SAFE                            = STATUS3::SAFE << 8
        REFLECT                         = STATUS3::REFLECT << 8
        ALL                             = $ffff
        NONE                            = 0
.endenum

; 16-bit combined status 3 and 4
.enum STATUS34
        DANCE                           = STATUS3::DANCE
        FLYING                          = STATUS3::FLYING
        REGEN                           = STATUS3::REGEN
        SLOW                            = STATUS3::SLOW
        HASTE                           = STATUS3::HASTE
        STOP                            = STATUS3::STOP
        SHELL                           = STATUS3::SHELL
        SAFE                            = STATUS3::SAFE
        REFLECT                         = STATUS3::REFLECT
        RAGE                            = STATUS4::RAGE << 8
        FROZEN                          = STATUS4::FROZEN << 8
        RERAISE                         = STATUS4::RERAISE << 8
        MORPH                           = STATUS4::MORPH << 8
        CONTROL                         = STATUS4::CONTROL << 8
        HIDE                            = STATUS4::HIDE << 8
        INTERCEPTOR                     = STATUS4::INTERCEPTOR << 8
        FLOAT                           = STATUS4::FLOAT << 8
        ALL                             = $ffff
        NONE                            = 0
.endenum

; 16-bit combined status 1 and 4
.enum STATUS14
        BLIND                           = STATUS1::BLIND
        ZOMBIE                          = STATUS1::ZOMBIE
        POISON                          = STATUS1::POISON
        MAGITEK                         = STATUS1::MAGITEK
        VANISH                          = STATUS1::VANISH
        IMP                             = STATUS1::IMP
        PETRIFY                         = STATUS1::PETRIFY
        DEAD                            = STATUS1::DEAD
        RAGE                            = STATUS4::RAGE << 8
        FROZEN                          = STATUS4::FROZEN << 8
        RERAISE                         = STATUS4::RERAISE << 8
        MORPH                           = STATUS4::MORPH << 8
        CONTROL                         = STATUS4::CONTROL << 8
        HIDE                            = STATUS4::HIDE << 8
        INTERCEPTOR                     = STATUS4::INTERCEPTOR << 8
        FLOAT                           = STATUS4::FLOAT << 8
        ALL                             = $ffff
        NONE                            = 0
.endenum

; ------------------------------------------------------------------------------

.enum ITEM_TYPE
        TOOL
        WEAPON
        ARMOR
        SHIELD
        HELMET
        RELIC
        CONSUMABLE
.endenum

.enum ITEM_USAGE
        THROW                           = %00010000
        BATTLE                          = %00100000
        MENU                            = %01000000

        MASK                            = %01110000
.endenum

.enum ITEM_EQUIP_FLAGS
        IMP                             = %0100000000000000
        MERIT                           = %1000000000000000
.endenum

.enum ITEM_FIELD_EFFECT
        REDUCE_RAND_BATTLES             = %00000001
        NO_RAND_BATTLES                 = %00000010
        ;                               = %00000100
        ;                               = %00001000
        ;                               = %00010000
        SPRINT_SHOES                    = %00100000
        ;                               = %01000000
        TINTINABAR                      = %10000000
.endenum

.enum BLOCK_GFX
        DAGGER                          ;= 0
        SWORD                           ;= 1
        SHIELD                          ;= 2
        CAPE                            ;= 3
.endenum

.enum BLOCK_TYPE
        PHYSICAL                        = %00000100
        MAGIC                           = %00001000
.endenum

.enum WEAPON_SPECIAL
        NONE                            ;= 0
        RAND_STEAL                      ;= 1
        ATMA_WEAPON                     ;= 2
        INSTANT_DEATH                   ;= 3
        STRONG_VS_HUMAN                 ;= 4
        ABSORB_HP                       ;= 5
        ABSORB_MP                       ;= 6
        MP_CRIT                         ;= 7
        STRONG_VS_FLYING                ;= 8
        DICE                            ;= 9
        STRONG_WHEN_HP_LOW              ;= 10
        RAND_WIND_SLASH                 ;= 11
        HEAL_HP                         ;= 12
        SCIMITAR_EFFECT                 ;= 13
        RAND_BREAK                      ;= 14
        MORE_MP_CRIT                    ;= 15
.endenum

.enum RELIC_EFFECT1
        ATLAS_ARMLET                    = %00000001  ; +50% physical damage
        EARRING                         = %00000010  ; +100% magic damage
        HP_PLUS_25                      = %00000100  ; RED_CAP
        HP_PLUS_50                      = %00001000  ; MUSCLE_BELT
        HP_PLUS_12                      = %00010000  ; GREEN_BERET
        MP_PLUS_25                      = %00100000  ; MINERVA
        MP_PLUS_50                      = %01000000  ; CRYSTAL_ORB
        MP_PLUS_12                      = %10000000  ; BARDS_HAT
        DRAGON_HORN                     = %10000000
.endenum

.enum RELIC_EFFECT2
        GALE_HAIRPIN                    = %00000001
        BACK_GUARD                      = %00000010
        JUMP                            = %00000100  ; DRAGOONBOOTS
        X_MAGIC                         = %00001000  ; GEM_BOX
        CONTROL                         = %00010000  ; FAKEMUSTACHE
        GP_RAIN                         = %00100000  ; COIN_TOSS
        CAPTURE                         = %01000000  ; THIEF_GLOVE
        DRAGON_HORN                     = %10000000
.endenum

.enum RELIC_EFFECT3
        INC_STEAL_RATE                  = %00000001  ; SNEAK_RING
        SINGLE_EARRING                  = %00000010  ; +50% magic damage
        INC_SKETCH_RATE                 = %00000100  ; BERET
        INC_CONTROL_RATE                = %00001000  ; CORONET
        MAX_HIT_RATE                    = %00010000  ; SNIPER_SIGHT
        MP_COST_HALF                    = %00100000  ; GOLD_HAIRPIN
        MP_COST_1                       = %01000000  ; ECONOMIZER
        STRENGTH_PLUS_50                = %10000000  ; HYPER_WRIST
.endenum

.enum RELIC_EFFECT4
        X_FIGHT                         = %00000001  ; OFFERING
        RAND_RETAL                      = %00000010  ; BLACK_BELT
        RAND_EVADE                      = %00000100  ; BEADS
        GAUNTLET                        = %00001000
        GENJI_GLOVE                     = %00010000
        EQUIP_MERIT                     = %00100000  ; MERIT_AWARD
        COVER                           = %01000000  ; TRUE_KNIGHT
        ;                               = %10000000
.endenum

.enum RELIC_EFFECT5
        SHELL_HP_LOW                    = %00000001  ; BARRIER_RING, CZARINA_RING
        SAFE_HP_LOW                     = %00000010  ; MITHRILGLOVE, CZARINA_RING
        REFLECT_HP_LOW                  = %00000100  ; unused
        DOUBLE_EXP                      = %00001000  ; EXP_EGG
        DOUBLE_GP                       = %00010000  ; CAT_HOOD
        ;                               = %00100000
        ;                               = %01000000
        MAKE_UNDEAD                     = %10000000  ; RELIC_RING (MONSTER_FLAG::UNDEAD)
.endenum

.enum ITEM_SPECIAL
        INVALID
        MAGICITE
        SUPER_BALL
        SMOKE_BOMB
        ELIXIR
        WARP_STONE
        DRIED_MEAT
        POSSESS                                 ; unused
        GP_RAIN                                 ; unused
        STEAL                                   ; unused
        CONTROL                                 ; unused
        LEAP                                    ; unused
        SKETCH                                  ; unused
        DEBILITATOR                             ; unused
        AIR_ANCHOR                              ; unused
        NONE                            = $ff
.endenum

.enum WEAPON_SPELL_FLAGS
        RAND_CAST                       = %01000000
        USE_AS_ITEM                     = %10000000
.endenum

.enum MONSTER_FLAG
        DIE_AT_0_MP                     = %00000001
        ;                               = %00000010
        HIDE_NAME                       = %00000100
        ;                               = %00001000
        HUMAN                           = %00010000
        ;                               = %00100000
        IMP_DMG_BONUS                   = %01000000
        UNDEAD                          = %10000000
.endenum

.enum RETAL_FLAGS
        RETORT                          = %00000001
        MONSTER_RUNIC                   = %00000010
        RUNIC                           = %00000100
        REGEN_TRIGGER                   = %00001000
        POISON_TRIGGER                  = %00010000
        ;                               = %00100000
        ;                               = %01000000
        PIRANHA                         = %10000000
.endenum

.enum MONSTER_STATUS
        HARDER_TO_RUN                   = %00000001
        FIRST_STRIKE                    = %00000010
        CANT_SUPLEX                     = %00000100
        CANT_ESCAPE                     = %00001000
        CANT_SCAN                       = %00010000
        CANT_SKETCH                     = %00100000
        SPECIAL_EVENT                   = %01000000
        CANT_CONTROL                    = %10000000
.endenum

.enum MONSTER_SPECIAL_FLAGS
        NO_DMG                          = %01000000
        CANT_MISS                       = %10000000
.endenum

.enum MONSTER_SPECIAL_EFFECT
        BLIND = STATUS_ID::BLIND
        ZOMBIE = STATUS_ID::ZOMBIE
        POISON = STATUS_ID::POISON
        MAGITEK = STATUS_ID::MAGITEK
        VANISH = STATUS_ID::VANISH
        IMP = STATUS_ID::IMP
        PETRIFY = STATUS_ID::PETRIFY
        DEAD = STATUS_ID::DEAD
        CONDEMNED = STATUS_ID::CONDEMNED
        NEAR_FATAL = STATUS_ID::NEAR_FATAL
        IMAGE = STATUS_ID::IMAGE
        SILENCE = STATUS_ID::SILENCE
        BERSERK = STATUS_ID::BERSERK
        CONFUSE = STATUS_ID::CONFUSE
        SAP = STATUS_ID::SAP
        SLEEP = STATUS_ID::SLEEP
        DANCE = STATUS_ID::DANCE
        REGEN = STATUS_ID::REGEN
        SLOW = STATUS_ID::SLOW
        HASTE = STATUS_ID::HASTE
        STOP = STATUS_ID::STOP
        SHELL = STATUS_ID::SHELL
        SAFE = STATUS_ID::SAFE
        REFLECT = STATUS_ID::REFLECT
        RAGE = STATUS_ID::RAGE
        FROZEN = STATUS_ID::FROZEN
        RERAISE = STATUS_ID::RERAISE
        MORPH = STATUS_ID::MORPH
        CONTROL = STATUS_ID::CONTROL
        HIDE = STATUS_ID::HIDE
        INTERCEPTOR = STATUS_ID::INTERCEPTOR
        FLOAT = STATUS_ID::FLOAT
        DMG_150_PCT
        DMG_200_PCT
        DMG_250_PCT
        DMG_300_PCT
        DMG_350_PCT
        DMG_400_PCT
        DMG_450_PCT
        DMG_500_PCT
        DMG_550_PCT
        DMG_600_PCT
        DMG_650_PCT
        DMG_700_PCT
        DMG_750_PCT
        DMG_800_PCT
        DMG_850_PCT
        DMG_900_PCT
        DRAIN_HP
        DRAIN_MP
        REMOVE_REFLECT
.endenum

.enum MONSTER_SPECIAL_ANIM
        MULTI_PUNCH
        THICK_DIAG_SLASH
        THIN_DIAG_SLASH
        RED_STAB
        BLUE_STAB_1
        BLUE_STAB_2
        THICK_HORZ_SLASH
        ARC_SLASH
        DIAG_CLAW
        LARGE_PIERCE
        HORZ_CLAW
        THIN_HORZ_SLASH
        SINGLE_PUNCH
        VERT_SLASH
        SMALL_PIERCE
        STING
        BLACK_CLOUD
        HAMMER
        BONE
        WRENCH
        LIGHTNING
        LIGHT_BEAM
        AIR_ANCHOR
        BLOB_MAN
        BUBBLE
        MUSIC_NOTE
        HEART
        WHEEL
        FLOWER
        MISSILE
        NET
        DRILL
        BLACK_BALL
        SKULL_SLASH
        MONSTER_SPECIAL_ANIM_34
.endenum

.enum MONSTER_ALIGN
        CEILING
        GROUND
        FLOATING
        BURIED
        FLYING

        COUNT
.endenum

.enum SHOP
        NARSHE_WEAPONS_1                ;= $00 ; 0
        NARSHE_ARMOR_1                  ;= $01 ; 1
        NARSHE_RELICS_1                 ;= $02 ; 2
        NARSHE_ITEMS_1                  ;= $03 ; 3
        FIGARO_CASTLE_ITEMS_1           ;= $04 ; 4
        SOUTH_FIGARO_WEAPONS_1          ;= $05 ; 5
        SOUTH_FIGARO_ARMOR_1            ;= $06 ; 6
        SOUTH_FIGARO_RELICS_1           ;= $07 ; 7
        SOUTH_FIGARO_ITEMS_1            ;= $08 ; 8
        MOBLIZ_WEAPONS                  ;= $09 ; 9
        MOBLIZ_ARMOR                    ;= $0a ; 10
        MOBLIZ_RELICS                   ;= $0b ; 11
        MOBLIZ_ITEMS                    ;= $0c ; 12
        NIKEAH_WEAPONS_1                ;= $0d ; 13
        NIKEAH_ARMOR_1                  ;= $0e ; 14
        NIKEAH_ITEMS_1                  ;= $0f ; 15
        NIKEAH_RELICS_1                 ;= $10 ; 16
        KOHLINGEN_WEAPONS_1             ;= $11 ; 17
        KOHLINGEN_ARMOR_1               ;= $12 ; 18
        KOHLINGEN_ITEMS_1               ;= $13 ; 19
        JIDOOR_WEAPONS_1                ;= $14 ; 20
        JIDOOR_ARMOR_1                  ;= $15 ; 21
        JIDOOR_ITEMS_1                  ;= $16 ; 22
        JIDOOR_RELICS_1                 ;= $17 ; 23
        ALBROOK_ITEMS_1                 ;= $18 ; 24
        ALBROOK_WEAPONS_1               ;= $19 ; 25
        ALBROOK_ARMOR_1                 ;= $1a ; 26
        VECTOR_WEAPONS                  ;= $1b ; 27
        VECTOR_ARMOR                    ;= $1c ; 28
        TZEN_WEAPONS_1                  ;= $1d ; 29
        TZEN_ARMOR_1                    ;= $1e ; 30
        TZEN_ITEMS_1                    ;= $1f ; 31
        TZEN_RELICS_1                   ;= $20 ; 32
        THAMASA_WEAPONS_1               ;= $21 ; 33
        THAMASA_ARMOR_1                 ;= $22 ; 34
        THAMASA_ITEMS_1                 ;= $23 ; 35
        RETURNERS_HIDEOUT_ITEMS         ;= $24 ; 36
        MARANDA_WEAPONS_1               ;= $25 ; 37
        MARANDA_ARMOR_1                 ;= $26 ; 38
        CRAZY_OLD_MANS_HOUSE            ;= $27 ; 39
        ALBROOK_RELICS_1                ;= $28 ; 40
        NARSHE_WEAPONS_2                ;= $29 ; 41
        NARSHE_ARMOR_2                  ;= $2a ; 42
        NARSHE_RELICS_2                 ;= $2b ; 43
        NARSHE_ITEMS_2                  ;= $2c ; 44
        THAMASA_RELICS_1                ;= $2d ; 45
        BLACKJACK_ITEMS                 ;= $2e ; 46
        FIGARO_CASTLE_ITEMS_2           ;= $2f ; 47
        ALBROOK_ITEMS_2                 ;= $30 ; 48
        ALBROOK_WEAPONS_2               ;= $31 ; 49
        ALBROOK_ARMOR_2                 ;= $32 ; 50
        ALBROOK_RELICS_2                ;= $33 ; 51
        TZEN_WEAPONS_2                  ;= $34 ; 52
        TZEN_ARMOR_2                    ;= $35 ; 53
        TZEN_ITEMS_2                    ;= $36 ; 54
        TZEN_RELICS_2                   ;= $37 ; 55
        NIKEAH_WEAPONS_2                ;= $38 ; 56
        NIKEAH_ARMOR_2                  ;= $39 ; 57
        NIKEAH_ITEMS_2                  ;= $3a ; 58
        NIKEAH_RELICS_2                 ;= $3b ; 59
        SOUTH_FIGARO_WEAPONS_2          ;= $3c ; 60
        SOUTH_FIGARO_ARMOR_2            ;= $3d ; 61
        SOUTH_FIGARO_RELICS_2           ;= $3e ; 62
        SOUTH_FIGARO_ITEMS_2            ;= $3f ; 63
        FIGARO_CASTLE_ITEMS_3           ;= $40 ; 64
        KOHLINGEN_WEAPONS_2             ;= $41 ; 65
        KOHLINGEN_ARMOR_2               ;= $42 ; 66
        KOHLINGEN_ITEMS_2               ;= $43 ; 67
        NARSHE_WEAPONS_3                ;= $44 ; 68
        NARSHE_ARMOR_3                  ;= $45 ; 69
        NARSHE_RELICS_3                 ;= $46 ; 70
        NARSHE_ITEMS_3                  ;= $47 ; 71
        THAMASA_WEAPONS_2               ;= $48 ; 72
        THAMASA_ARMOR_2                 ;= $49 ; 73
        THAMASA_ITEMS_2                 ;= $4a ; 74
        THAMASA_RELICS_2                ;= $4b ; 75
        JIDOOR_WEAPONS_2                ;= $4c ; 76
        JIDOOR_ARMOR_2                  ;= $4d ; 77
        JIDOOR_ITEMS_2                  ;= $4e ; 78
        JIDOOR_RELICS_2                 ;= $4f ; 79
        MARANDA_WEAPONS_2               ;= $50 ; 80
        MARANDA_ARMOR_2                 ;= $51 ; 81
        FIGARO_CASTLE_TOOLS_1           ;= $52 ; 82
        FIGARO_CASTLE_TOOLS_2           ;= $53 ; 83
        FIGARO_CASTLE_TOOLS_3           ;= $54 ; 84
        PHANTOM_TRAIN_ITEMS             ;= $55 ; 85
        UNUSED_ITEMS                    ;= $56 ; 86
        SHOP_87
        SHOP_88
        SHOP_89
        SHOP_90
        SHOP_91
        SHOP_92
        SHOP_93
        SHOP_94
        SHOP_95
        SHOP_96
        SHOP_97
        SHOP_98
        SHOP_99
        SHOP_100
        SHOP_101
        SHOP_102
        SHOP_103
        SHOP_104
        SHOP_105
        SHOP_106
        SHOP_107
        SHOP_108
        SHOP_109
        SHOP_110
        SHOP_111
        SHOP_112
        SHOP_113
        SHOP_114
        SHOP_115
        SHOP_116
        SHOP_117
        SHOP_118
        SHOP_119
        SHOP_120
        SHOP_121
        SHOP_122
        SHOP_123
        SHOP_124
        SHOP_125
        SHOP_126
        SHOP_127

        COUNT
.endenum

.enum SHOP_TYPE
        NONE
        WEAPON
        ARMOR
        ITEM
        RELICS
        VENDOR
.endenum

.enum SHOP_PRICE_MOD
        NONE                  ;  0 = none
        PLUS_50               ;  1 = +50%
        PLUS_100              ;  2 = +100%
        HALF                  ;  3 = -50%
        HALF_FOR_FEMALE       ;  4 = -50% for female showing character (terra, celes, or relm), +50% for male
        HALF_FOR_MALE         ;  5 = -50% for male showing character, +50% for female
        HALF_FOR_EDGAR        ;  6 = -50% if edgar is showing character

        COUNT
.endenum

; ------------------------------------------------------------------------------

.enum BATTLE_CHAR_PAL
        EDGAR                           = 0
        SABIN                           = 0
        CELES                           = 0
        IMP                             = 0
        LEO                             = 0
        GHOST                           = 0
        GREEN_SOLDIER                   = 0
        LOCKE                           = 1
        MERCHANT                        = 1
        BROWN_SOLDIER                   = 1
        TERRA                           = 2
        STRAGO                          = 3
        RELM                            = 3
        GAU                             = 3
        GOGO                            = 3
        BANON                           = 3
        KEFKA                           = 3
        GESTAHL                         = 3
        CYAN                            = 4
        SHADOW                          = 4
        SETZER                          = 4
        MOG                             = 5
        UMARO                           = 5
        ESPER_TERRA                     = 6
.endenum

; ------------------------------------------------------------------------------

.enum AI_CMD
        ATTACK                          ; = $00 // 0
        SET_TARGET                      ; = $01 // 1
        CHANGE_BATTLE                   ; = $02 // 2
        MONSTER_DLG                     ; = $03 // 3
        BATTLE_CMD                      ; = $04 // 4
        MONSTER_ENTRY_EXIT              ; = $05 // 5
        ITEM                            ; = $06 // 6
        BATTLE_EVENT                    ; = $07 // 7
        CHANGE_VAR                      ; = $08 // 8
        CHANGE_SWITCH                   ; = $09 // 9
        MONSTER_ANIM                    ; = $0a // 10
        MISC_AI_EFFECT                  ; = $0b // 11
        AI_COND                         ; = $0c // 12
        WAIT                            ; = $0d // 13
        END_IF                          ; = $0e // 14
        END_SCRIPT                      ; = $0f // 15

        COUNT
.endenum

.enum AI_COND
        IF_NEVER                        ; = $00 // 0
        IF_CMD                          ; = $01 // 1
        IF_ATTACK                       ; = $02 // 2
        IF_ITEM                         ; = $03 // 3
        IF_ELEMENT                      ; = $04 // 4
        IF_HIT                          ; = $05 // 5
        IF_HP                           ; = $06 // 6
        IF_MP                           ; = $07 // 7
        IF_STATUS_SET                   ; = $08 // 8
        IF_STATUS_CLR                   ; = $09 // 9
        AI_COND_10                      ; = $0a // 10
        IF_MONSTER_TIMER                ; = $0b // 11
        IF_BATTLE_VAR_LESS              ; = $0c // 12
        IF_BATTLE_VAR_GREATER           ; = $0d // 13
        IF_LEVEL_LESS                   ; = $0e // 14
        IF_LEVEL_GREATER                ; = $0f // 15
        IF_ONE_MONSTER_TYPE             ; = $10 // 16
        IF_ALIVE                        ; = $11 // 17
        IF_DEAD                         ; = $12 // 18
        IF_NUM_TARGETS                  ; = $13 // 19
        IF_SWITCH_SET                   ; = $14 // 20
        IF_SWITCH_CLR                   ; = $15 // 21
        IF_BATTLE_TIMER                 ; = $16 // 22
        IF_TARGET_VALID                 ; = $17 // 23
        IF_GAU_PRESENT                  ; = $18 // 24
        IF_SELF_IN_SLOT                 ; = $19 // 25
        IF_WEAK_ELEMENT                 ; = $1a // 26
        IF_BATTLE_ID                    ; = $1b // 27
        IF_ALWAYS                       ; = $1c // 28

        COUNT
.endenum

.enum MISC_AI_EFFECT
        RESET_MONSTER_TIMER             ; = $00 // 0
        INVINCIBLE_ON                   ; = $01 // 1
        END_BATTLE                      ; = $02 // 2
        RECRUIT_GAU                     ; = $03 // 3
        RESET_BATTLE_TIMER              ; = $04 // 4
        INVINCIBLE_OFF                  ; = $05 // 5
        TARGET_ON                       ; = $06 // 6
        TARGET_OFF                      ; = $07 // 7
        FILL_ATB                        ; = $08 // 8
        END_VELDT                       ; = $09 // 9
        MISC_AI_EFFECT_10
        SET_STATUS                      ; = $0b // 11
        CLR_STATUS                      ; = $0c // 12
        HIDE_PIRANHA                    ; = $0d // 13

        COUNT
.endenum

; ------------------------------------------------------------------------------

.enum BTL_GFX
        INIT                            ; 0
        WAIT_FRAME                      ; 1
        OPEN_MENU                       ; 2
        CLOSE_MENU                      ; 3
        GFX_SCRIPT                      ; 4
        GIVE_ITEM                       ; 5
        UPDATE_MONSTER_NAMES            ; 6
        BTL_GFX_7                       ; 7
        VICTORY                         ; 8
        TERMINATE_BATTLE                ; 9
        UPDATE_INVENTORY                ; 10
        BTL_GFX_11                      ; 11
        FINAL_BATTLE_SCROLL             ; 12
        GET_MENU_QUEUE_POS              ; 13

        COUNT
.endenum

.enum MONSTER_ENTRY_EXIT
        RESTORE_MONSTERS
        KILL_MONSTERS
        SHOW_MONSTERS
        HIDE_MONSTERS
        KILL_MONSTERS_WAIT
        KILL_MONSTERS_DEBUG

        COUNT
.endenum

.enum BATTLE_EVENT_CMD
        BATTLE_MSG                      ; = 0
        BATTLE_DLG                      ; = 1
        BATTLE_EVENT_CMD_2              ; = 2
        CHAR_1_ANIM                     ; = 3
        CHAR_2_ANIM                     ; = 4
        CHAR_3_ANIM                     ; = 5
        CHAR_4_ANIM                     ; = 6
        MONSTER_1_ANIM                  ; = 7
        MONSTER_2_ANIM                  ; = 8
        MONSTER_3_ANIM                  ; = 9
        MONSTER_4_ANIM                  ; = 10
        MONSTER_5_ANIM                  ; = 11
        MONSTER_6_ANIM                  ; = 12
        ATTACK_ANIM                     ; = 13
        RESET_ANIM                      ; = 14
        EXEC_ANIM                       ; = 15
        CLOSE_DLG                       ; = 16
        OPEN_DLG                        ; = 17
        ALL_CHARS_ANIM                  ; = 18
        ADD_CHAR_TARGET                 ; = 19
        SHOW_CHAR_MENU                  ; = 20

        COUNT

        TERMINATE = $ff
.endenum

.enum EVENT_ANIM_CMD
        ATTACKER_CHAR_DIR               ; 0
        RESET_CHAR_VEC_OFFSET           ; 1
        SAVE_ATTACKER_CHAR_POS          ; 2
        RESTORE_ATTACKER_CHAR_POS       ; 3
        VEC_TO_ATTACKER_CHAR_POS        ; 4
        EVENT_ANIM_CMD_5                ; 5
        CHAR_POS                        ; 6
        UPDATE_CHAR_VEC_DIR_WALK        ; 7
        CALC_VEC_REL                    ; 8
        UPDATE_CHAR_VEC_DIR_JUMP        ; 9
        EVENT_ANIM_CMD_10               ; 10
        SOUND_CMD                       ; 11
        CHANGE_CHAR_GFX                 ; 12
        TRITOCH_SPARKLE                 ; 13
        SHAKE_BG                        ; 14
        EVENT_ANIM_CMD_15               ; 15
        SHOW_CHAR                       ; 16
        DISABLE_RUN                     ; 17

        COUNT
.endenum

.enum ATTACK_EVENT_ANIM
        TERRA_TRITOCH
        BLIZZARD_FIST
        TERRA_TRITOCH_ALT
        WATER_SPLASH_BG1
        WATER_SPLASH_SPRITE
        EVENT_BAHAMUT
        EVENT_ZONESEEK
        EVENT_FENRIR
        EVENT_TERRATO
        EVENT_SHIVA
        EVENT_KIRIN
        EVENT_BISMARK
        EVENT_CARBUNKL
        EVENT_PHANTOM
        TRANSFORM_MAGICITE
        SHOCK
        GESTAHL_LIGHTNING
        GESTAHL_BLACK_MAGIC
        MOVE_BACK_SLOW
        MOVE_BACK_SLOW_ALT
.endenum

.enum ANIM_CMD
        COUNT = 127
.endenum

.enum ANIM_CMD_00
        COUNT = 141
.endenum

.enum ANIM_TYPE
        COUNT = 127
.endenum

.enum CMD_ANIM
        MORPH                           ; $00
        REVERT                          ; $01
        STEAL                           ; $02
        BUSHIDO                         ; $03
        BLITZ                           ; $04
        RUNIC                           ; $05
        RAGE                            ; $06 (also used for dance)
        SHOCK                           ; $07
        CMD_ANIM_8                      ; $08 (unused copy of gp rain)
        JUMP_MONSTER                    ; $09
        JUMP_CHAR_MISS                  ; $0a
        JUMP_MONSTER_MISS               ; $0b
        THREE_DICE                      ; $0c
        TWO_DICE                        ; $0d
        CAPTURE_TO                      ; $0e
        CAPTURE_FROM                    ; $0f
        CHARS_RUN_LEFT                  ; $10 (unused)
        CHOCOBOP                        ; $11 (unused)
        SEVEN_FLUSH                     ; $12 (unused)
        LAGOMORPH                       ; $13 (unused)
        THROW_THICK_KNIFE               ; $14
        THROW_THIN_KNIFE                ; $15
        THROW_SWORD                     ; $16
        THROW_KATANA                    ; $17
        THROW_ROD                       ; $18
        THROW_SPEAR                     ; $19
        THROW_HAWK_EYE                  ; $1a
        ARISE                           ; $1b
        FIRE_SKEAN                      ; $1c
        WATER_EDGE                      ; $1d
        BOLT_EDGE                       ; $1e
        INVIZ_EDGE                      ; $1f
        SHADOW_EDGE                     ; $20
        THROW_FULL_MOON                 ; $21
        THROW_BOOMERANG                 ; $22
        THROW_UNUSED                    ; $23
        GP_RAIN                         ; $24
        SKETCH                          ; $25
        LEAP                            ; $26
        HEALTH                          ; $27
        LORE                            ; $28
        RUN_AWAY                        ; $29
        MAGITEK                         ; $2a
        JUMP_UNARMED                    ; $2b
        JUMP_THICK_KNIFE                ; $2c
        JUMP_THIN_KNIFE                 ; $2d
        JUMP_SWORD                      ; $2e
        JUMP_KATANA                     ; $2f
        JUMP_ROD                        ; $30
        JUMP_SPEAR                      ; $31
        JUMP_HAWK_EYE                   ; $32
        JUMP_UNUSED                     ; $33 (dice and shurikens)
        POSSESS                         ; $34
        UMARO_TACKLE                    ; $35
        UMARO_THROW                     ; $36
        RUNIC_ABSORB                    ; $37
        CHANGE_BATTLE                   ; $38
        CONTROL                         ; $39
.endenum

.enum GFX_CMD

        GFX_CMD_0                       ; 0
        ATTACK_NAME                     ; 1
        ATTACK_MSG                      ; 2
        DMG_NUMERALS_MULTI              ; 3
        GFX_CMD_4                       ; 4
        GFX_CMD_5                       ; 5
        ATTACK_ANIM                     ; 6
        NEXT_SCRIPT_DATA                ; 7
        GFX_CMD_8                       ; 8
        REFLECT_ANIM                    ; 9
        OPEN_DLG_WINDOW                 ; 10
        DMG_NUMERALS_SINGLE             ; 11
        ADVANCE_WAIT                    ; 12
        STEP_BACK                       ; 13
        RESET_CHAR_ACTION               ; 14
        BATTLE_EVENT                    ; 15
        MONSTER_DLG                     ; 16
        MONSTER_SPECIAL                 ; 17
        CHANGE_BATTLE                   ; 18
        MONSTER_ENTRY_EXIT              ; 19
        MONSTER_ANIM                    ; 20
        SUPER_BALL                      ; 21
        GFX_CMD_22                      ; 22
        GFX_CMD_23                      ; 23
        GFX_CMD_24                      ; 24
        GFX_CMD_25                      ; 25
        GFX_CMD_26                      ; 26

        COUNT
        TERMINATE = $ff
.endenum

; ------------------------------------------------------------------------------

.endif
.list on
