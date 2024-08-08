
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

def_config ROM_VERSION,0
def_config DEBUG,0
def_config LANG_EN,0
.if (LANG_EN && ROM_VERSION)
        LANG_EN_REV1 = 1
.else
        LANG_EN_REV1 = 0
.endif

; define language suffix
.if LANG_EN
        .define LANG_SUFFIX "en"
.else
        .define LANG_SUFFIX "jp"
.endif

; ------------------------------------------------------------------------------

BIT_0                                   = %00000001
BIT_1                                   = %00000010
BIT_2                                   = %00000100
BIT_3                                   = %00001000
BIT_4                                   = %00010000
BIT_5                                   = %00100000
BIT_6                                   = %01000000
BIT_7                                   = %10000000

BIT_8                                   = %0000000100000000
BIT_9                                   = %0000001000000000
BIT_10                                  = %0000010000000000
BIT_11                                  = %0000100000000000
BIT_12                                  = %0001000000000000
BIT_13                                  = %0010000000000000
BIT_14                                  = %0100000000000000
BIT_15                                  = %1000000000000000

; ------------------------------------------------------------------------------

MAX_GIL                                 = 9999999
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

; item ids
.enum ITEM
        DIRK                            ;= $00  ; 0
        MITHRILKNIFE                    ;= $01  ; 1
        GUARDIAN                        ;= $02  ; 2
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
        PEARL_LANCE                     ;= $21  ; 33
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
        PEARL_ROD                       ;= $39  ; 57
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
        BUCKLER                         ;= $5a  ; 90
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
        LEATHER_HAT                     ;= $69  ; 105
        HAIR_BAND                       ;= $6a  ; 106
        PLUMED_HAT                      ;= $6b  ; 107
        BERET                           ;= $6c  ; 108
        MAGUS_HAT                       ;= $6d  ; 109
        BANDANA                         ;= $6e  ; 110
        IRONHELMET                      ;= $6f  ; 111
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
        LEATHERARMOR                    ;= $84  ; 132
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
        NOISEBLASTER                    ;= $a3  ; 163
        BIO_BLASTER                     ;= $a4  ; 164
        FLASH                           ;= $a5  ; 165
        CHAIN_SAW                       ;= $a6  ; 166
        DEBILITATOR                     ;= $a7  ; 167
        DRILL                           ;= $a8  ; 168
        AIR_ANCHOR                      ;= $a9  ; 169
        AUTOCROSSBOW                    ;= $aa  ; 170
        FIRE_SKEAN                      ;= $ab  ; 171
        WATER_EDGE                      ;= $ac  ; 172
        BOLT_EDGE                       ;= $ad  ; 173
        INVIZ_EDGE                      ;= $ae  ; 174
        SHADOW_EDGE                     ;= $af  ; 175
        GOGGLES                         ;= $b0  ; 176
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
        RENAME_CARD                     ;= $e7  ; 231
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
.endenum

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

; main characters
.enum EVENT_OBJ
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
        NPC_2                           = $11
        NPC_3                           = $12
        NPC_4                           = $13
        NPC_5                           = $14
        NPC_6                           = $15
        NPC_7                           = $16
        NPC_8                           = $17
        NPC_9                           = $18
        NPC_10                          = $19
        NPC_11                          = $1a
        NPC_12                          = $1b
        NPC_13                          = $1c
        NPC_14                          = $1d
        NPC_15                          = $1e
        NPC_16                          = $1f
        NPC_17                          = $20
        NPC_18                          = $21
        NPC_19                          = $22
        NPC_20                          = $23
        NPC_21                          = $24
        NPC_22                          = $25
        NPC_23                          = $26
        NPC_24                          = $27
        NPC_25                          = $28
        NPC_26                          = $29
        NPC_27                          = $2a
        NPC_28                          = $2b
        NPC_29                          = $2c
        NPC_30                          = $2d
        NPC_31                          = $2e
        NPC_32                          = $2f

; camera object
        CAMERA                          = $30

; party character slots
        SLOT_1                          = $31
        SLOT_2                          = $32
        SLOT_3                          = $33
        SLOT_4                          = $34
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
        SOLDIER                         ;= $0e
        IMP                             ;= $0f
        LEO                             ;= $10
        BANON                           ;= $11
        ESPER_TERRA                     ;= $12
        MERCHANT                        ;= $13
        GHOST                           ;= $14
        KEFKA                           ;= $15
        GESTAHL                         ;= $16
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
        NONE                            = $ff  ; 255
.endenum

; ------------------------------------------------------------------------------

; genju ids
.enum GENJU
        RAMUH                           = $36  ; 54
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
.endenum

; ------------------------------------------------------------------------------

; attack ids
.enum ATTACK
        FIRE                            ;= $00  ; 0
        ICE                             ;= $01  ; 1
        BOLT                            ;= $02  ; 2
        POISON                          ;= $03  ; 3
        DRAIN                           ;= $04  ; 4
        FIRE_2                          ;= $05  ; 5
        ICE_2                           ;= $06  ; 6
        BOLT_2                          ;= $07  ; 7
        BIO                             ;= $08  ; 8
        FIRE_3                          ;= $09  ; 9
        ICE_3                           ;= $0a  ; 10
        BOLT_3                          ;= $0b  ; 11
        BREAK                           ;= $0c  ; 12
        DOOM                            ;= $0d  ; 13
        PEARL                           ;= $0e  ; 14
        FLARE                           ;= $0f  ; 15
        DEMI                            ;= $10  ; 16
        QUARTR                          ;= $11  ; 17
        X_ZONE                          ;= $12  ; 18
        METEOR                          ;= $13  ; 19
        ULTIMA                          ;= $14  ; 20
        QUAKE                           ;= $15  ; 21
        W_WIND                          ;= $16  ; 22
        MERTON                          ;= $17  ; 23
        SCAN                            ;= $18  ; 24
        SLOW                            ;= $19  ; 25
        RASP                            ;= $1a  ; 26
        MUTE                            ;= $1b  ; 27
        SAFE                            ;= $1c  ; 28
        SLEEP                           ;= $1d  ; 29
        MUDDLE                          ;= $1e  ; 30
        HASTE                           ;= $1f  ; 31
        STOP                            ;= $20  ; 32
        BSERK                           ;= $21  ; 33
        FLOAT                           ;= $22  ; 34
        IMP                             ;= $23  ; 35
        RFLECT                          ;= $24  ; 36
        SHELL                           ;= $25  ; 37
        VANISH                          ;= $26  ; 38
        HASTE2                          ;= $27  ; 39
        SLOW_2                          ;= $28  ; 40
        OSMOSE                          ;= $29  ; 41
        WARP                            ;= $2a  ; 42
        QUICK                           ;= $2b  ; 43
        DISPEL                          ;= $2c  ; 44
        CURE                            ;= $2d  ; 45
        CURE_2                          ;= $2e  ; 46
        CURE_3                          ;= $2f  ; 47
        LIFE                            ;= $30  ; 48
        LIFE_2                          ;= $31  ; 49
        ANTDOT                          ;= $32  ; 50
        REMEDY                          ;= $33  ; 51
        REGEN                           ;= $34  ; 52
        LIFE_3                          ;= $35  ; 53
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
        FIRE_SKEAN                      ;= $51  ; 81
        WATER_EDGE                      ;= $52  ; 82
        BOLT_EDGE                       ;= $53  ; 83
        STORM                           ;= $54  ; 84
        DISPATCH                        ;= $55  ; 85
        RETORT                          ;= $56  ; 86
        SLASH                           ;= $57  ; 87
        QUADRA_SLAM                     ;= $58  ; 88
        EMPOWERER                       ;= $59  ; 89
        STUNNER                         ;= $5a  ; 90
        QUADRA_SLICE                    ;= $5b  ; 91
        CLEAVE                          ;= $5c  ; 92
        PUMMEL                          ;= $5d  ; 93
        AURABOLT                        ;= $5e  ; 94
        SUPLEX                          ;= $5f  ; 95
        FIRE_DANCE                      ;= $60  ; 96
        MANTRA                          ;= $61  ; 97
        AIR_BLADE                       ;= $62  ; 98
        SPIRALER                        ;= $63  ; 99
        BUM_RUSH                        ;= $64  ; 100
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
        BIO_BLAST_TOOL                  ;= $7d  ; 125
        FLASH_TOOL                      ;= $7e  ; 126
        CHOCOBOP                        ;= $7f  ; 127
        H_BOMB                          ;= $80  ; 128
        SEVEN_FLUSH                     ;= $81  ; 129
        SHOCK                           ;= $82  ; 130
        FIRE_BEAM                       ;= $83  ; 131
        BOLT_BEAM                       ;= $84  ; 132
        ICE_BEAM                        ;= $85  ; 133
        BIO_BLAST                       ;= $86  ; 134
        HEAL_FORCE                      ;= $87  ; 135
        CONFUSER                        ;= $88  ; 136
        XFER                            ;= $89  ; 137
        TEKMISSILE                      ;= $8a  ; 138
        CONDEMNED                       ;= $8b  ; 139
        ROULETTE                        ;= $8c  ; 140
        CLEANSWEEP                      ;= $8d  ; 141
        AQUA_RAKE                       ;= $8e  ; 142
        AERO                            ;= $8f  ; 143
        BLOW_FISH                       ;= $90  ; 144
        BIG_GUARD                       ;= $91  ; 145
        REVENGE                         ;= $92  ; 146
        PEARL_WIND                      ;= $93  ; 147
        L5_DOOM                         ;= $94  ; 148
        L4_FLARE                        ;= $95  ; 149
        L3_MUDDLE                       ;= $96  ; 150
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
        BLIZZARD                        ;= $ba  ; 186
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
        BATTLE                          ;= $ee  ; 238
        SPECIAL                         ;= $ef  ; 239
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
        TAKEDOWN                        ;= $fc  ; 252
        WILD_FANG                       ;= $fd  ; 253
        LAGOMORPH                       ;= $fe  ; 254
        NONE                            ;= $ff  ; 255
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
        NONE = $ff
.endenum

; ------------------------------------------------------------------------------

.enum WEAPON_FLAG
        SWDTECH                         = $02
        BACK_ROW                        = $20
        TWO_HAND                        = $40
        RUNIC                           = $80
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
        KEFKA_VS_ESPER                  ;= $017a  ; 378
        EVENT                           ;= $017b  ; 379
        MONSTER_017C                    ;= $017c  ; 380
        ATMA                            ;= $017d  ; 381
        SHADOW_COLOSSEUM                ;= $017e  ; 382
        COLOSSEUM                       ;= $017f  ; 383
.endenum

; ------------------------------------------------------------------------------

; dance ids
.enum DANCE
        WIND_SONG                       = 0
        FOREST_SUITE                    = 1
        DESERT_ARIA                     = 2
        LOVE_SONATA                     = 3
        EARTH_BLUES                     = 4
        WATER_RONDO                     = 5
        DUSK_REQUIUM                    = 6
        SNOWMAN_JAZZ                    = 7
.endenum

; ------------------------------------------------------------------------------

; target selection flags
.enum TARGET
        MANUAL                          = $01  ; can move cursor manually
        ONE_SIDE                        = $02  ; can't target opposite side
        INIT_MASK                       = $0c  ; mask for initial target
        INIT_SINGLE                     = $00  ; single target
        INIT_ALL                        = $04  ; all characters and monsters
        INIT_GROUP                      = $08  ; one target group (one side)
        INIT_HALF                       = $0c  ; all characters or all monsters
        AUTO_CONFIRM                    = $10  ; don't wait for A button
        MULTI_TARGET                    = $20  ; allow L/R button multi-target
        ENEMY                           = $40  ; target enemy by default
        ROULETTE                        = $80  ; random roulette cursor

; special values, not flags
        SELF                            = $02  ; cursor on attacker
        MENU                            = $ff  ; uses a menu to choose target
.endenum

; ------------------------------------------------------------------------------

; battle command flags
.enum BATTLE_CMD_FLAG
        NONE                            = $00  ; no flags set
        GOGO                            = $01  ; can be used by gogo
        MIMIC                           = $02  ; can be mimicked
        IMP                             = $04  ; can be used by imp
        UNKNOWN                         = $08  ; unknown
.endenum

; ------------------------------------------------------------------------------

.enum CHAR_PROP
        TERRA                           = $00
        LOCKE                           = $01
        CYAN                            = $02
        SHADOW                          = $03
        EDGAR                           = $04
        SABIN                           = $05
        CELES                           = $06
        STRAGO                          = $07
        RELM                            = $08
        SETZER                          = $09
        MOG                             = $0a
        GAU                             = $0b
        GOGO                            = $0c
        UMARO                           = $0d
        BANON                           = $0e
        LEO                             = $0f
        GHOST_1                         = $10
        GHOST_2                         = $11
        KUPEK                           = $12
        KUPOP                           = $13
        KUMAMA                          = $14
        KUKU                            = $15
        KUTAN                           = $16
        KUPAN                           = $17
        KUSHU                           = $18
        KURIN                           = $19
        KURU                            = $1a
        KAMOG                           = $1b
        SCENARIO_MOG                    = $1c
        TERRA_INTRO                     = $1d
        MADUIN                          = $1e
        SHADOW_COLOSSEUM                = $1f
        WEDGE                           = $20
        VICKS                           = $21
        UNUSED_22                       = $22
        UNUSED_23                       = $23
        UNUSED_24                       = $24
        UNUSED_25                       = $25
        UNUSED_26                       = $26
        UNUSED_27                       = $27
        UNUSED_28                       = $28
        KEFKA_1                         = $29
        KEFKA_2                         = $2a
        KEFKA_3                         = $2b
        KEFKA_4                         = $2c
        KEFKA_5                         = $2d
        KEFKA_6                         = $2e
        KEFKA_7                         = $2f
        TORK                            = $30
        JADE                            = $31
        CUSTER                          = $32
        FABIAN                          = $33
        DRAKE                           = $34
        SARA                            = $35
        CASE                            = $36
        SIELE                           = $37
        RAY                             = $38
        REIKER                          = $39
        LANCE                           = $3a
        BOB                             = $3b
        PEPPER                          = $3c
        TAU                             = $3d
        VICTOR                          = $3e
        HO                              = $3f
.endenum

; character run factor values
RUN_FACTOR_MASK                         = $03
RUN_FACTOR_HIGH                         = $00  ; 125%
RUN_FACTOR_NORMAL                       = $01  ; 100%
RUN_FACTOR_LOW                          = $02  ; 75%
RUN_FACTOR_VERY_LOW                     = $03  ; 50%

; character level modifiers (see CharLevelModTbl)
LEVEL_MOD_MASK                          = $0c
LEVEL_MOD_NORMAL                        = $00  ; +0
LEVEL_MOD_HIGH                          = $04  ; +2
LEVEL_MOD_VERY_HIGH                     = $08  ; +5
LEVEL_MOD_LOW                           = $0c  ; -3

; character fixed equipment flag
CHAR_PROP_FIXED_EQUIP                   = $10

; ------------------------------------------------------------------------------

.enum CHAR_FLAG
        TERRA                           = $0001
        LOCKE                           = $0002
        CYAN                            = $0004
        SHADOW                          = $0008
        EDGAR                           = $0010
        SABIN                           = $0020
        CELES                           = $0040
        STRAGO                          = $0080
        RELM                            = $0100
        SETZER                          = $0200
        MOG                             = $0400
        GAU                             = $0800
        GOGO                            = $1000
        UMARO                           = $2000
.endenum

; ------------------------------------------------------------------------------

; element bitmasks

.enum ELEMENT
        FIRE                            = BIT_0
        ICE                             = BIT_1
        LIGHTNING                       = BIT_2
        POISON                          = BIT_3
        WIND                            = BIT_4
        HOLY                            = BIT_5
        EARTH                           = BIT_6
        WATER                           = BIT_7
        NONE                            = 0
.endenum

; ------------------------------------------------------------------------------

; status effects in sequential order (not bitmasks)
.enum STATUS_ID
        BLIND
        ZOMBIE
        POISON
        MAGITEK
        INVISIBLE
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
        PROTECT
        REFLECT
        RAGE
        FROZEN
        RERAISE
        MORPH
        CHANT
        HIDE
        INTERCEPTOR
        FLOAT
.endenum

; status 1: harmful status that persist after battle
.enum STATUS1
        BLIND                           = BIT_0
        ZOMBIE                          = BIT_1
        POISON                          = BIT_2
        MAGITEK                         = BIT_3
        INVISIBLE                       = BIT_4
        IMP                             = BIT_5
        PETRIFY                         = BIT_6
        DEAD                            = BIT_7
        NONE                            = 0
.endenum

; status 2: harmful status that do not persist after battle
.enum STATUS2
        CONDEMNED                       = BIT_0
        NEAR_FATAL                      = BIT_1
        IMAGE                           = BIT_2
        SILENCE                         = BIT_3
        BERSERK                         = BIT_4
        CONFUSE                         = BIT_5
        SAP                             = BIT_6
        SLEEP                           = BIT_7
        NONE                            = 0
.endenum

; status 3: helpful status that do not persist after battle
.enum STATUS3
        DANCE                           = BIT_0
        REGEN                           = BIT_1
        SLOW                            = BIT_2
        HASTE                           = BIT_3
        STOP                            = BIT_4
        SHELL                           = BIT_5
        PROTECT                         = BIT_6
        REFLECT                         = BIT_7
        NONE                            = 0
.endenum

; status 4: only float and interceptor persist after battle
.enum STATUS4
        RAGE                            = BIT_0
        FROZEN                          = BIT_1
        RERAISE                         = BIT_2
        MORPH                           = BIT_3
        CHANT                           = BIT_4
        HIDE                            = BIT_5
        INTERCEPTOR                     = BIT_6
        FLOAT                           = BIT_7
        NONE                            = 0
.endenum

; 16-bit combined status 1 and 2
.enum STATUS12
        BLIND                           = STATUS1::BLIND
        ZOMBIE                          = STATUS1::ZOMBIE
        POISON                          = STATUS1::POISON
        MAGITEK                         = STATUS1::MAGITEK
        INVISIBLE                       = STATUS1::INVISIBLE
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
        REGEN                           = STATUS3::REGEN << 8
        SLOW                            = STATUS3::SLOW << 8
        HASTE                           = STATUS3::HASTE << 8
        STOP                            = STATUS3::STOP << 8
        SHELL                           = STATUS3::SHELL << 8
        PROTECT                         = STATUS3::PROTECT << 8
        REFLECT                         = STATUS3::REFLECT << 8
        NONE                            = 0
.endenum

; 16-bit combined status 3 and 4
.enum STATUS34
        DANCE                           = STATUS3::DANCE
        REGEN                           = STATUS3::REGEN
        SLOW                            = STATUS3::SLOW
        HASTE                           = STATUS3::HASTE
        STOP                            = STATUS3::STOP
        SHELL                           = STATUS3::SHELL
        PROTECT                         = STATUS3::PROTECT
        REFLECT                         = STATUS3::REFLECT
        RAGE                            = STATUS4::RAGE << 8
        FROZEN                          = STATUS4::FROZEN << 8
        RERAISE                         = STATUS4::RERAISE << 8
        MORPH                           = STATUS4::MORPH << 8
        CHANT                           = STATUS4::CHANT << 8
        HIDE                            = STATUS4::HIDE << 8
        INTERCEPTOR                     = STATUS4::INTERCEPTOR << 8
        FLOAT                           = STATUS4::FLOAT << 8
        NONE                            = 0
.endenum

; 16-bit combined status 1 and 4
.enum STATUS14
        BLIND                           = STATUS1::BLIND
        ZOMBIE                          = STATUS1::ZOMBIE
        POISON                          = STATUS1::POISON
        MAGITEK                         = STATUS1::MAGITEK
        INVISIBLE                       = STATUS1::INVISIBLE
        IMP                             = STATUS1::IMP
        PETRIFY                         = STATUS1::PETRIFY
        DEAD                            = STATUS1::DEAD
        RAGE                            = STATUS4::RAGE << 8
        FROZEN                          = STATUS4::FROZEN << 8
        RERAISE                         = STATUS4::RERAISE << 8
        MORPH                           = STATUS4::MORPH << 8
        CHANT                           = STATUS4::CHANT << 8
        HIDE                            = STATUS4::HIDE << 8
        INTERCEPTOR                     = STATUS4::INTERCEPTOR << 8
        FLOAT                           = STATUS4::FLOAT << 8
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
        THROW                           = $10
        BATTLE                          = $20
        MENU                            = $40
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

.endif
.list on
