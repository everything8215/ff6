
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
ITEM_DIRK                               = $00  ; 0
ITEM_MITHRILKNIFE                       = $01  ; 1
ITEM_GUARDIAN                           = $02  ; 2
ITEM_AIR_LANCET                         = $03  ; 3
ITEM_THIEFKNIFE                         = $04  ; 4
ITEM_ASSASSIN                           = $05  ; 5
ITEM_MAN_EATER                          = $06  ; 6
ITEM_SWORDBREAKER                       = $07  ; 7
ITEM_GRAEDUS                            = $08  ; 8
ITEM_VALIANTKNIFE                       = $09  ; 9
ITEM_MITHRILBLADE                       = $0a  ; 10
ITEM_REGAL_CUTLASS                      = $0b  ; 11
ITEM_RUNE_EDGE                          = $0c  ; 12
ITEM_FLAME_SABRE                        = $0d  ; 13
ITEM_BLIZZARD                           = $0e  ; 14
ITEM_THUNDERBLADE                       = $0f  ; 15
ITEM_EPEE                               = $10  ; 16
ITEM_BREAK_BLADE                        = $11  ; 17
ITEM_DRAINER                            = $12  ; 18
ITEM_ENHANCER                           = $13  ; 19
ITEM_CRYSTAL                            = $14  ; 20
ITEM_FALCHION                           = $15  ; 21
ITEM_SOUL_SABRE                         = $16  ; 22
ITEM_OGRE_NIX                           = $17  ; 23
ITEM_EXCALIBUR                          = $18  ; 24
ITEM_SCIMITAR                           = $19  ; 25
ITEM_ILLUMINA                           = $1a  ; 26
ITEM_RAGNAROK                           = $1b  ; 27
ITEM_ATMA_WEAPON                        = $1c  ; 28
ITEM_MITHRIL_PIKE                       = $1d  ; 29
ITEM_TRIDENT                            = $1e  ; 30
ITEM_STOUT_SPEAR                        = $1f  ; 31
ITEM_PARTISAN                           = $20  ; 32
ITEM_PEARL_LANCE                        = $21  ; 33
ITEM_GOLD_LANCE                         = $22  ; 34
ITEM_AURA_LANCE                         = $23  ; 35
ITEM_IMP_HALBERD                        = $24  ; 36
ITEM_IMPERIAL                           = $25  ; 37
ITEM_KODACHI                            = $26  ; 38
ITEM_BLOSSOM                            = $27  ; 39
ITEM_HARDENED                           = $28  ; 40
ITEM_STRIKER                            = $29  ; 41
ITEM_STUNNER                            = $2a  ; 42
ITEM_ASHURA                             = $2b  ; 43
ITEM_KOTETSU                            = $2c  ; 44
ITEM_FORGED                             = $2d  ; 45
ITEM_TEMPEST                            = $2e  ; 46
ITEM_MURASAME                           = $2f  ; 47
ITEM_AURA                               = $30  ; 48
ITEM_STRATO                             = $31  ; 49
ITEM_SKY_RENDER                         = $32  ; 50
ITEM_HEAL_ROD                           = $33  ; 51
ITEM_MITHRIL_ROD                        = $34  ; 52
ITEM_FIRE_ROD                           = $35  ; 53
ITEM_ICE_ROD                            = $36  ; 54
ITEM_THUNDER_ROD                        = $37  ; 55
ITEM_POISON_ROD                         = $38  ; 56
ITEM_PEARL_ROD                          = $39  ; 57
ITEM_GRAVITY_ROD                        = $3a  ; 58
ITEM_PUNISHER                           = $3b  ; 59
ITEM_MAGUS_ROD                          = $3c  ; 60
ITEM_CHOCOBO_BRSH                       = $3d  ; 61
ITEM_DAVINCI_BRSH                       = $3e  ; 62
ITEM_MAGICAL_BRSH                       = $3f  ; 63
ITEM_RAINBOW_BRSH                       = $40  ; 64
ITEM_SHURIKEN                           = $41  ; 65
ITEM_NINJA_STAR                         = $42  ; 66
ITEM_TACK_STAR                          = $43  ; 67
ITEM_FLAIL                              = $44  ; 68
ITEM_FULL_MOON                          = $45  ; 69
ITEM_MORNING_STAR                       = $46  ; 70
ITEM_BOOMERANG                          = $47  ; 71
ITEM_RISING_SUN                         = $48  ; 72
ITEM_HAWK_EYE                           = $49  ; 73
ITEM_BONE_CLUB                          = $4a  ; 74
ITEM_SNIPER                             = $4b  ; 75
ITEM_WING_EDGE                          = $4c  ; 76
ITEM_CARDS                              = $4d  ; 77
ITEM_DARTS                              = $4e  ; 78
ITEM_DOOM_DARTS                         = $4f  ; 79
ITEM_TRUMP                              = $50  ; 80
ITEM_DICE                               = $51  ; 81
ITEM_FIXED_DICE                         = $52  ; 82
ITEM_METALKNUCKLE                       = $53  ; 83
ITEM_MITHRIL_CLAW                       = $54  ; 84
ITEM_KAISER                             = $55  ; 85
ITEM_POISON_CLAW                        = $56  ; 86
ITEM_FIRE_KNUCKLE                       = $57  ; 87
ITEM_DRAGON_CLAW                        = $58  ; 88
ITEM_TIGER_FANGS                        = $59  ; 89
ITEM_BUCKLER                            = $5a  ; 90
ITEM_HEAVY_SHLD                         = $5b  ; 91
ITEM_MITHRIL_SHLD                       = $5c  ; 92
ITEM_GOLD_SHLD                          = $5d  ; 93
ITEM_AEGIS_SHLD                         = $5e  ; 94
ITEM_DIAMOND_SHLD                       = $5f  ; 95
ITEM_FLAME_SHLD                         = $60  ; 96
ITEM_ICE_SHLD                           = $61  ; 97
ITEM_THUNDER_SHLD                       = $62  ; 98
ITEM_CRYSTAL_SHLD                       = $63  ; 99
ITEM_GENJI_SHLD                         = $64  ; 100
ITEM_TORTOISESHLD                       = $65  ; 101
ITEM_CURSED_SHLD                        = $66  ; 102
ITEM_PALADIN_SHLD                       = $67  ; 103
ITEM_FORCE_SHLD                         = $68  ; 104
ITEM_LEATHER_HAT                        = $69  ; 105
ITEM_HAIR_BAND                          = $6a  ; 106
ITEM_PLUMED_HAT                         = $6b  ; 107
ITEM_BERET                              = $6c  ; 108
ITEM_MAGUS_HAT                          = $6d  ; 109
ITEM_BANDANA                            = $6e  ; 110
ITEM_IRONHELMET                         = $6f  ; 111
ITEM_CORONET                            = $70  ; 112
ITEM_BARDS_HAT                          = $71  ; 113
ITEM_GREEN_BERET                        = $72  ; 114
ITEM_HEAD_BAND                          = $73  ; 115
ITEM_MITHRIL_HELM                       = $74  ; 116
ITEM_TIARA                              = $75  ; 117
ITEM_GOLD_HELMET                        = $76  ; 118
ITEM_TIGER_MASK                         = $77  ; 119
ITEM_RED_CAP                            = $78  ; 120
ITEM_MYSTERY_VEIL                       = $79  ; 121
ITEM_CIRCLET                            = $7a  ; 122
ITEM_REGAL_CROWN                        = $7b  ; 123
ITEM_DIAMOND_HELM                       = $7c  ; 124
ITEM_DARK_HOOD                          = $7d  ; 125
ITEM_CRYSTAL_HELM                       = $7e  ; 126
ITEM_OATH_VEIL                          = $7f  ; 127
ITEM_CAT_HOOD                           = $80  ; 128
ITEM_GENJI_HELMET                       = $81  ; 129
ITEM_THORNLET                           = $82  ; 130
ITEM_TITANIUM                           = $83  ; 131
ITEM_LEATHERARMOR                       = $84  ; 132
ITEM_COTTON_ROBE                        = $85  ; 133
ITEM_KUNG_FU_SUIT                       = $86  ; 134
ITEM_IRON_ARMOR                         = $87  ; 135
ITEM_SILK_ROBE                          = $88  ; 136
ITEM_MITHRIL_VEST                       = $89  ; 137
ITEM_NINJA_GEAR                         = $8a  ; 138
ITEM_WHITE_DRESS                        = $8b  ; 139
ITEM_MITHRIL_MAIL                       = $8c  ; 140
ITEM_GAIA_GEAR                          = $8d  ; 141
ITEM_MIRAGE_VEST                        = $8e  ; 142
ITEM_GOLD_ARMOR                         = $8f  ; 143
ITEM_POWER_SASH                         = $90  ; 144
ITEM_LIGHT_ROBE                         = $91  ; 145
ITEM_DIAMOND_VEST                       = $92  ; 146
ITEM_RED_JACKET                         = $93  ; 147
ITEM_FORCE_ARMOR                        = $94  ; 148
ITEM_DIAMONDARMOR                       = $95  ; 149
ITEM_DARK_GEAR                          = $96  ; 150
ITEM_TAO_ROBE                           = $97  ; 151
ITEM_CRYSTAL_MAIL                       = $98  ; 152
ITEM_CZARINA_GOWN                       = $99  ; 153
ITEM_GENJI_ARMOR                        = $9a  ; 154
ITEM_IMPS_ARMOR                         = $9b  ; 155
ITEM_MINERVA                            = $9c  ; 156
ITEM_TABBY_SUIT                         = $9d  ; 157
ITEM_CHOCOBO_SUIT                       = $9e  ; 158
ITEM_MOOGLE_SUIT                        = $9f  ; 159
ITEM_NUTKIN_SUIT                        = $a0  ; 160
ITEM_BEHEMOTHSUIT                       = $a1  ; 161
ITEM_SNOW_MUFFLER                       = $a2  ; 162
ITEM_NOISEBLASTER                       = $a3  ; 163
ITEM_BIO_BLASTER                        = $a4  ; 164
ITEM_FLASH                              = $a5  ; 165
ITEM_CHAIN_SAW                          = $a6  ; 166
ITEM_DEBILITATOR                        = $a7  ; 167
ITEM_DRILL                              = $a8  ; 168
ITEM_AIR_ANCHOR                         = $a9  ; 169
ITEM_AUTOCROSSBOW                       = $aa  ; 170
ITEM_FIRE_SKEAN                         = $ab  ; 171
ITEM_WATER_EDGE                         = $ac  ; 172
ITEM_BOLT_EDGE                          = $ad  ; 173
ITEM_INVIZ_EDGE                         = $ae  ; 174
ITEM_SHADOW_EDGE                        = $af  ; 175
ITEM_GOGGLES                            = $b0  ; 176
ITEM_STAR_PENDANT                       = $b1  ; 177
ITEM_PEACE_RING                         = $b2  ; 178
ITEM_AMULET                             = $b3  ; 179
ITEM_WHITE_CAPE                         = $b4  ; 180
ITEM_JEWEL_RING                         = $b5  ; 181
ITEM_FAIRY_RING                         = $b6  ; 182
ITEM_BARRIER_RING                       = $b7  ; 183
ITEM_MITHRILGLOVE                       = $b8  ; 184
ITEM_GUARD_RING                         = $b9  ; 185
ITEM_RUNNINGSHOES                       = $ba  ; 186
ITEM_WALL_RING                          = $bb  ; 187
ITEM_CHERUB_DOWN                        = $bc  ; 188
ITEM_CURE_RING                          = $bd  ; 189
ITEM_TRUE_KNIGHT                        = $be  ; 190
ITEM_DRAGOONBOOTS                       = $bf  ; 191
ITEM_ZEPHYR_CAPE                        = $c0  ; 192
ITEM_CZARINA_RING                       = $c1  ; 193
ITEM_CURSED_RING                        = $c2  ; 194
ITEM_EARRINGS                           = $c3  ; 195
ITEM_ATLAS_ARMLET                       = $c4  ; 196
ITEM_BLIZZARD_ORB                       = $c5  ; 197
ITEM_RAGE_RING                          = $c6  ; 198
ITEM_SNEAK_RING                         = $c7  ; 199
ITEM_POD_BRACELET                       = $c8  ; 200
ITEM_HERO_RING                          = $c9  ; 201
ITEM_RIBBON                             = $ca  ; 202
ITEM_MUSCLE_BELT                        = $cb  ; 203
ITEM_CRYSTAL_ORB                        = $cc  ; 204
ITEM_GOLD_HAIRPIN                       = $cd  ; 205
ITEM_ECONOMIZER                         = $ce  ; 206
ITEM_THIEF_GLOVE                        = $cf  ; 207
ITEM_GAUNTLET                           = $d0  ; 208
ITEM_GENJI_GLOVE                        = $d1  ; 209
ITEM_HYPER_WRIST                        = $d2  ; 210
ITEM_OFFERING                           = $d3  ; 211
ITEM_BEADS                              = $d4  ; 212
ITEM_BLACK_BELT                         = $d5  ; 213
ITEM_COIN_TOSS                          = $d6  ; 214
ITEM_FAKEMUSTACHE                       = $d7  ; 215
ITEM_GEM_BOX                            = $d8  ; 216
ITEM_DRAGON_HORN                        = $d9  ; 217
ITEM_MERIT_AWARD                        = $da  ; 218
ITEM_MEMENTO_RING                       = $db  ; 219
ITEM_SAFETY_BIT                         = $dc  ; 220
ITEM_RELIC_RING                         = $dd  ; 221
ITEM_MOOGLE_CHARM                       = $de  ; 222
ITEM_CHARM_BANGLE                       = $df  ; 223
ITEM_MARVEL_SHOES                       = $e0  ; 224
ITEM_BACK_GUARD                         = $e1  ; 225
ITEM_GALE_HAIRPIN                       = $e2  ; 226
ITEM_SNIPER_SIGHT                       = $e3  ; 227
ITEM_EXP_EGG                            = $e4  ; 228
ITEM_TINTINABAR                         = $e5  ; 229
ITEM_SPRINT_SHOES                       = $e6  ; 230
ITEM_RENAME_CARD                        = $e7  ; 231
ITEM_TONIC                              = $e8  ; 232
ITEM_POTION                             = $e9  ; 233
ITEM_X_POTION                           = $ea  ; 234
ITEM_TINCTURE                           = $eb  ; 235
ITEM_ETHER                              = $ec  ; 236
ITEM_X_ETHER                            = $ed  ; 237
ITEM_ELIXIR                             = $ee  ; 238
ITEM_MEGALIXIR                          = $ef  ; 239
ITEM_FENIX_DOWN                         = $f0  ; 240
ITEM_REVIVIFY                           = $f1  ; 241
ITEM_ANTIDOTE                           = $f2  ; 242
ITEM_EYEDROP                            = $f3  ; 243
ITEM_SOFT                               = $f4  ; 244
ITEM_REMEDY                             = $f5  ; 245
ITEM_SLEEPING_BAG                       = $f6  ; 246
ITEM_TENT                               = $f7  ; 247
ITEM_GREEN_CHERRY                       = $f8  ; 248
ITEM_MAGICITE                           = $f9  ; 249
ITEM_SUPER_BALL                         = $fa  ; 250
ITEM_ECHO_SCREEN                        = $fb  ; 251
ITEM_SMOKE_BOMB                         = $fc  ; 252
ITEM_WARP_STONE                         = $fd  ; 253
ITEM_DRIED_MEAT                         = $fe  ; 254
ITEM_EMPTY                              = $ff  ; 255

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
        SWDTECH                         ;= $07  ; 7
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
ATTACK_FIRE                             = $00  ; 0
ATTACK_ICE                              = $01  ; 1
ATTACK_BOLT                             = $02  ; 2
ATTACK_POISON                           = $03  ; 3
ATTACK_DRAIN                            = $04  ; 4
ATTACK_FIRE_2                           = $05  ; 5
ATTACK_ICE_2                            = $06  ; 6
ATTACK_BOLT_2                           = $07  ; 7
ATTACK_BIO                              = $08  ; 8
ATTACK_FIRE_3                           = $09  ; 9
ATTACK_ICE_3                            = $0a  ; 10
ATTACK_BOLT_3                           = $0b  ; 11
ATTACK_BREAK                            = $0c  ; 12
ATTACK_DOOM                             = $0d  ; 13
ATTACK_PEARL                            = $0e  ; 14
ATTACK_FLARE                            = $0f  ; 15
ATTACK_DEMI                             = $10  ; 16
ATTACK_QUARTR                           = $11  ; 17
ATTACK_X_ZONE                           = $12  ; 18
ATTACK_METEOR                           = $13  ; 19
ATTACK_ULTIMA                           = $14  ; 20
ATTACK_QUAKE                            = $15  ; 21
ATTACK_W_WIND                           = $16  ; 22
ATTACK_MERTON                           = $17  ; 23
ATTACK_SCAN                             = $18  ; 24
ATTACK_SLOW                             = $19  ; 25
ATTACK_RASP                             = $1a  ; 26
ATTACK_MUTE                             = $1b  ; 27
ATTACK_SAFE                             = $1c  ; 28
ATTACK_SLEEP                            = $1d  ; 29
ATTACK_MUDDLE                           = $1e  ; 30
ATTACK_HASTE                            = $1f  ; 31
ATTACK_STOP                             = $20  ; 32
ATTACK_BSERK                            = $21  ; 33
ATTACK_FLOAT                            = $22  ; 34
ATTACK_IMP                              = $23  ; 35
ATTACK_RFLECT                           = $24  ; 36
ATTACK_SHELL                            = $25  ; 37
ATTACK_VANISH                           = $26  ; 38
ATTACK_HASTE2                           = $27  ; 39
ATTACK_SLOW_2                           = $28  ; 40
ATTACK_OSMOSE                           = $29  ; 41
ATTACK_WARP                             = $2a  ; 42
ATTACK_QUICK                            = $2b  ; 43
ATTACK_DISPEL                           = $2c  ; 44
ATTACK_CURE                             = $2d  ; 45
ATTACK_CURE_2                           = $2e  ; 46
ATTACK_CURE_3                           = $2f  ; 47
ATTACK_LIFE                             = $30  ; 48
ATTACK_LIFE_2                           = $31  ; 49
ATTACK_ANTDOT                           = $32  ; 50
ATTACK_REMEDY                           = $33  ; 51
ATTACK_REGEN                            = $34  ; 52
ATTACK_LIFE_3                           = $35  ; 53
ATTACK_RAMUH                            = $36  ; 54
ATTACK_IFRIT                            = $37  ; 55
ATTACK_SHIVA                            = $38  ; 56
ATTACK_SIREN                            = $39  ; 57
ATTACK_TERRATO                          = $3a  ; 58
ATTACK_SHOAT                            = $3b  ; 59
ATTACK_MADUIN                           = $3c  ; 60
ATTACK_BISMARK                          = $3d  ; 61
ATTACK_STRAY                            = $3e  ; 62
ATTACK_PALIDOR                          = $3f  ; 63
ATTACK_TRITOCH                          = $40  ; 64
ATTACK_ODIN                             = $41  ; 65
ATTACK_RAIDEN                           = $42  ; 66
ATTACK_BAHAMUT                          = $43  ; 67
ATTACK_ALEXANDR                         = $44  ; 68
ATTACK_CRUSADER                         = $45  ; 69
ATTACK_RAGNAROK                         = $46  ; 70
ATTACK_KIRIN                            = $47  ; 71
ATTACK_ZONESEEK                         = $48  ; 72
ATTACK_CARBUNKL                         = $49  ; 73
ATTACK_PHANTOM                          = $4a  ; 74
ATTACK_SRAPHIM                          = $4b  ; 75
ATTACK_GOLEM                            = $4c  ; 76
ATTACK_UNICORN                          = $4d  ; 77
ATTACK_FENRIR                           = $4e  ; 78
ATTACK_STARLET                          = $4f  ; 79
ATTACK_PHOENIX                          = $50  ; 80
ATTACK_FIRE_SKEAN                       = $51  ; 81
ATTACK_WATER_EDGE                       = $52  ; 82
ATTACK_BOLT_EDGE                        = $53  ; 83
ATTACK_STORM                            = $54  ; 84
ATTACK_DISPATCH                         = $55  ; 85
ATTACK_RETORT                           = $56  ; 86
ATTACK_SLASH                            = $57  ; 87
ATTACK_QUADRA_SLAM                      = $58  ; 88
ATTACK_EMPOWERER                        = $59  ; 89
ATTACK_STUNNER                          = $5a  ; 90
ATTACK_QUADRA_SLICE                     = $5b  ; 91
ATTACK_CLEAVE                           = $5c  ; 92
ATTACK_PUMMEL                           = $5d  ; 93
ATTACK_AURABOLT                         = $5e  ; 94
ATTACK_SUPLEX                           = $5f  ; 95
ATTACK_FIRE_DANCE                       = $60  ; 96
ATTACK_MANTRA                           = $61  ; 97
ATTACK_AIR_BLADE                        = $62  ; 98
ATTACK_SPIRALER                         = $63  ; 99
ATTACK_BUM_RUSH                         = $64  ; 100
ATTACK_WIND_SLASH                       = $65  ; 101
ATTACK_SUN_BATH                         = $66  ; 102
ATTACK_RAGE                             = $67  ; 103
ATTACK_HARVESTER                        = $68  ; 104
ATTACK_SAND_STORM                       = $69  ; 105
ATTACK_ANTLION                          = $6a  ; 106
ATTACK_ELF_FIRE                         = $6b  ; 107
ATTACK_SPECTER                          = $6c  ; 108
ATTACK_LAND_SLIDE                       = $6d  ; 109
ATTACK_SONIC_BOOM                       = $6e  ; 110
ATTACK_EL_NINO                          = $6f  ; 111
ATTACK_PLASMA                           = $70  ; 112
ATTACK_SNARE                            = $71  ; 113
ATTACK_CAVE_IN                          = $72  ; 114
ATTACK_SNOWBALL                         = $73  ; 115
ATTACK_SURGE                            = $74  ; 116
ATTACK_COKATRICE                        = $75  ; 117
ATTACK_WOMBAT                           = $76  ; 118
ATTACK_KITTY                            = $77  ; 119
ATTACK_TAPIR                            = $78  ; 120
ATTACK_WHUMP                            = $79  ; 121
ATTACK_WILD_BEAR                        = $7a  ; 122
ATTACK_POIS_FROG                        = $7b  ; 123
ATTACK_ICE_RABBIT                       = $7c  ; 124
ATTACK_BIO_BLAST_TOOL                   = $7d  ; 125
ATTACK_FLASH_TOOL                       = $7e  ; 126
ATTACK_CHOCOBOP                         = $7f  ; 127
ATTACK_H_BOMB                           = $80  ; 128
ATTACK_7_FLUSH                          = $81  ; 129
ATTACK_SHOCK                            = $82  ; 130
ATTACK_FIRE_BEAM                        = $83  ; 131
ATTACK_BOLT_BEAM                        = $84  ; 132
ATTACK_ICE_BEAM                         = $85  ; 133
ATTACK_BIO_BLAST                        = $86  ; 134
ATTACK_HEAL_FORCE                       = $87  ; 135
ATTACK_CONFUSER                         = $88  ; 136
ATTACK_XFER                             = $89  ; 137
ATTACK_TEKMISSILE                       = $8a  ; 138
ATTACK_CONDEMNED                        = $8b  ; 139
ATTACK_ROULETTE                         = $8c  ; 140
ATTACK_CLEANSWEEP                       = $8d  ; 141
ATTACK_AQUA_RAKE                        = $8e  ; 142
ATTACK_AERO                             = $8f  ; 143
ATTACK_BLOW_FISH                        = $90  ; 144
ATTACK_BIG_GUARD                        = $91  ; 145
ATTACK_REVENGE                          = $92  ; 146
ATTACK_PEARL_WIND                       = $93  ; 147
ATTACK_L5_DOOM                          = $94  ; 148
ATTACK_L4_FLARE                         = $95  ; 149
ATTACK_L3_MUDDLE                        = $96  ; 150
ATTACK_REFLECT_LORE                     = $97  ; 151
ATTACK_PEARL_LORE                       = $98  ; 152
ATTACK_STEP_MINE                        = $99  ; 153
ATTACK_FORCEFIELD                       = $9a  ; 154
ATTACK_DISCHORD                         = $9b  ; 155
ATTACK_SOUR_MOUTH                       = $9c  ; 156
ATTACK_PEP_UP                           = $9d  ; 157
ATTACK_RIPPLER                          = $9e  ; 158
ATTACK_STONE                            = $9f  ; 159
ATTACK_QUASAR                           = $a0  ; 160
ATTACK_GRANDTRAIN                       = $a1  ; 161
ATTACK_EXPLODER                         = $a2  ; 162
ATTACK_IMP_SONG                         = $a3  ; 163
ATTACK_CLEAR                            = $a4  ; 164
ATTACK_VIRITE                           = $a5  ; 165
ATTACK_CHOKESMOKE                       = $a6  ; 166
ATTACK_SCHILLER                         = $a7  ; 167
ATTACK_LULLABY                          = $a8  ; 168
ATTACK_ACID_RAIN                        = $a9  ; 169
ATTACK_CONFUSION                        = $aa  ; 170
ATTACK_MEGAZERK                         = $ab  ; 171
ATTACK_ENEMY_MUTE                       = $ac  ; 172
ATTACK_NET                              = $ad  ; 173
ATTACK_SLIMER                           = $ae  ; 174
ATTACK_DELTA_HIT                        = $af  ; 175
ATTACK_ENTWINE                          = $b0  ; 176
ATTACK_BLASTER                          = $b1  ; 177
ATTACK_CYCLONIC                         = $b2  ; 178
ATTACK_FIRE_BALL                        = $b3  ; 179
ATTACK_ATOMIC_RAY                       = $b4  ; 180
ATTACK_TEK_LASER                        = $b5  ; 181
ATTACK_DIFFUSER                         = $b6  ; 182
ATTACK_WAVECANNON                       = $b7  ; 183
ATTACK_MEGA_VOLT                        = $b8  ; 184
ATTACK_GIGA_VOLT                        = $b9  ; 185
ATTACK_BLIZZARD                         = $ba  ; 186
ATTACK_ABSOLUTE0                        = $bb  ; 187
ATTACK_MAGNITUDE8                       = $bc  ; 188
ATTACK_RAID                             = $bd  ; 189
ATTACK_FLASH_RAIN                       = $be  ; 190
ATTACK_TEKBARRIER                       = $bf  ; 191
ATTACK_FALLEN_ONE                       = $c0  ; 192
ATTACK_WALLCHANGE                       = $c1  ; 193
ATTACK_ESCAPE                           = $c2  ; 194
ATTACK_50_GS                            = $c3  ; 195
ATTACK_MIND_BLAST                       = $c4  ; 196
ATTACK_N_CROSS                          = $c5  ; 197
ATTACK_FLARE_STAR                       = $c6  ; 198
ATTACK_LOVE_TOKEN                       = $c7  ; 199
ATTACK_SEIZE                            = $c8  ; 200
ATTACK_R_POLARITY                       = $c9  ; 201
ATTACK_TARGETTING                       = $ca  ; 202
ATTACK_SNEEZE                           = $cb  ; 203
ATTACK_S_CROSS                          = $cc  ; 204
ATTACK_LAUNCHER                         = $cd  ; 205
ATTACK_CHARM                            = $ce  ; 206
ATTACK_COLD_DUST                        = $cf  ; 207
ATTACK_TENTACLE                         = $d0  ; 208
ATTACK_HYPERDRIVE                       = $d1  ; 209
ATTACK_TRAIN                            = $d2  ; 210
ATTACK_EVIL_TOOT                        = $d3  ; 211
ATTACK_GRAV_BOMB                        = $d4  ; 212
ATTACK_ENGULF                           = $d5  ; 213
ATTACK_DISASTER                         = $d6  ; 214
ATTACK_SHRAPNEL                         = $d7  ; 215
ATTACK_BOMBLET                          = $d8  ; 216
ATTACK_HEART_BURN                       = $d9  ; 217
ATTACK_ZINGER                           = $da  ; 218
ATTACK_DISCARD                          = $db  ; 219
ATTACK_OVERCAST                         = $dc  ; 220
ATTACK_MISSILE                          = $dd  ; 221
ATTACK_GONER                            = $de  ; 222
ATTACK_METEO                            = $df  ; 223
ATTACK_REVENGER                         = $e0  ; 224
ATTACK_PHANTASM                         = $e1  ; 225
ATTACK_DREAD                            = $e2  ; 226
ATTACK_SHOCK_WAVE                       = $e3  ; 227
ATTACK_BLAZE                            = $e4  ; 228
ATTACK_SOUL_OUT                         = $e5  ; 229
ATTACK_GALE_CUT                         = $e6  ; 230
ATTACK_SHIMSHAM                         = $e7  ; 231
ATTACK_LODE_STONE                       = $e8  ; 232
ATTACK_SCAR_BEAM                        = $e9  ; 233
ATTACK_BABABREATH                       = $ea  ; 234
ATTACK_LIFESHAVER                       = $eb  ; 235
ATTACK_FIRE_WALL                        = $ec  ; 236
ATTACK_SLIDE                            = $ed  ; 237
ATTACK_BATTLE                           = $ee  ; 238
ATTACK_SPECIAL                          = $ef  ; 239
ATTACK_RIOT_BLADE                       = $f0  ; 240
ATTACK_MIRAGER                          = $f1  ; 241
ATTACK_BACK_BLADE                       = $f2  ; 242
ATTACK_SHADOWFANG                       = $f3  ; 243
ATTACK_ROYALSHOCK                       = $f4  ; 244
ATTACK_TIGERBREAK                       = $f5  ; 245
ATTACK_SPIN_EDGE                        = $f6  ; 246
ATTACK_SABRESOUL                        = $f7  ; 247
ATTACK_STAR_PRISM                       = $f8  ; 248
ATTACK_RED_CARD                         = $f9  ; 249
ATTACK_MOOGLERUSH                       = $fa  ; 250
ATTACK_X_METEO                          = $fb  ; 251
ATTACK_TAKEDOWN                         = $fc  ; 252
ATTACK_WILD_FANG                        = $fd  ; 253
ATTACK_LAGOMORPH                        = $fe  ; 254
ATTACK_NONE                             = $ff  ; 255

; ------------------------------------------------------------------------------

; genju bonus ids
GENJU_BONUS_HP_10                       = $00  ; 0
GENJU_BONUS_HP_30                       = $01  ; 1
GENJU_BONUS_HP_50                       = $02  ; 2
GENJU_BONUS_MP_10                       = $03  ; 3
GENJU_BONUS_MP_30                       = $04  ; 4
GENJU_BONUS_MP_50                       = $05  ; 5
GENJU_BONUS_HP_100                      = $06  ; 6
GENJU_BONUS_LV_30                       = $07  ; 7
GENJU_BONUS_LV_50                       = $08  ; 8
GENJU_BONUS_STRENGH_1                   = $09  ; 9
GENJU_BONUS_STRENGH_2                   = $0a  ; 10
GENJU_BONUS_SPEED_1                     = $0b  ; 11
GENJU_BONUS_SPEED_2                     = $0c  ; 12
GENJU_BONUS_STAMINA_1                   = $0d  ; 13
GENJU_BONUS_STAMINA_2                   = $0e  ; 14
GENJU_BONUS_MAGPWR_1                    = $0f  ; 15
GENJU_BONUS_MAGPWR_2                    = $10  ; 16
GENJU_BONUS_NONE                        = $ff  ; 255

; ------------------------------------------------------------------------------

WEAPON_FLAG_SWDTECH                     = $02
WEAPON_FLAG_BACK_ROW                    = $20
WEAPON_FLAG_TWO_HAND                    = $40
WEAPON_FLAG_RUNIC                       = $80

; ------------------------------------------------------------------------------

; monster ids
MONSTER_GUARD                           = $0000  ; 0
MONSTER_SOLDIER                         = $0001  ; 1
MONSTER_TEMPLAR                         = $0002  ; 2
MONSTER_NINJA                           = $0003  ; 3
MONSTER_SAMURAI                         = $0004  ; 4
MONSTER_OROG                            = $0005  ; 5
MONSTER_MAG_ROADER_1                    = $0006  ; 6
MONSTER_RETAINER                        = $0007  ; 7
MONSTER_HAZER                           = $0008  ; 8
MONSTER_DAHLING                         = $0009  ; 9
MONSTER_RAIN_MAN                        = $000a  ; 10
MONSTER_BRAWLER                         = $000b  ; 11
MONSTER_APOKRYPHOS                      = $000c  ; 12
MONSTER_DARK_FORCE                      = $000d  ; 13
MONSTER_WHISPER                         = $000e  ; 14
MONSTER_OVER_MIND                       = $000f  ; 15
MONSTER_OSTEOSAUR                       = $0010  ; 16
MONSTER_COMMANDER                       = $0011  ; 17
MONSTER_RHODOX                          = $0012  ; 18
MONSTER_WERE_RAT                        = $0013  ; 19
MONSTER_URSUS                           = $0014  ; 20
MONSTER_RHINOTAUR                       = $0015  ; 21
MONSTER_STEROIDITE                      = $0016  ; 22
MONSTER_LEAFER                          = $0017  ; 23
MONSTER_STRAY_CAT                       = $0018  ; 24
MONSTER_LOBO                            = $0019  ; 25
MONSTER_DOBERMAN                        = $001a  ; 26
MONSTER_VOMAMMOTH                       = $001b  ; 27
MONSTER_FIDOR                           = $001c  ; 28
MONSTER_BASKERVOR                       = $001d  ; 29
MONSTER_SURIANDER                       = $001e  ; 30
MONSTER_CHIMERA                         = $001f  ; 31
MONSTER_BEHEMOTH                        = $0020  ; 32
MONSTER_MESOSAUR                        = $0021  ; 33
MONSTER_PTERODON                        = $0022  ; 34
MONSTER_FOSSILFANG                      = $0023  ; 35
MONSTER_WHITE_DRGN                      = $0024  ; 36
MONSTER_DOOM_DRGN                       = $0025  ; 37
MONSTER_BRACHOSAUR                      = $0026  ; 38
MONSTER_TYRANOSAUR                      = $0027  ; 39
MONSTER_DARK_WIND                       = $0028  ; 40
MONSTER_BEAKOR                          = $0029  ; 41
MONSTER_VULTURE                         = $002a  ; 42
MONSTER_HARPY                           = $002b  ; 43
MONSTER_HERMITCRAB                      = $002c  ; 44
MONSTER_TRAPPER                         = $002d  ; 45
MONSTER_HORNET                          = $002e  ; 46
MONSTER_CRASSHOPPR                      = $002f  ; 47
MONSTER_DELTA_BUG                       = $0030  ; 48
MONSTER_GILOMANTIS                      = $0031  ; 49
MONSTER_TRILIUM                         = $0032  ; 50
MONSTER_NIGHTSHADE                      = $0033  ; 51
MONSTER_TUMBLEWEED                      = $0034  ; 52
MONSTER_BLOOMPIRE                       = $0035  ; 53
MONSTER_TRILOBITER                      = $0036  ; 54
MONSTER_SIEGFRIED_1                     = $0037  ; 55
MONSTER_NAUTILOID                       = $0038  ; 56
MONSTER_EXOCITE                         = $0039  ; 57
MONSTER_ANGUIFORM                       = $003a  ; 58
MONSTER_REACH_FROG                      = $003b  ; 59
MONSTER_LIZARD                          = $003c  ; 60
MONSTER_CHICKENLIP                      = $003d  ; 61
MONSTER_HOOVER                          = $003e  ; 62
MONSTER_RIDER                           = $003f  ; 63
MONSTER_CHUPON_COLOSSEUM                = $0040  ; 64
MONSTER_PIPSQUEAK                       = $0041  ; 65
MONSTER_M_TEKARMOR                      = $0042  ; 66
MONSTER_SKY_ARMOR                       = $0043  ; 67
MONSTER_TELSTAR                         = $0044  ; 68
MONSTER_LETHAL_WPN                      = $0045  ; 69
MONSTER_VAPORITE                        = $0046  ; 70
MONSTER_FLAN                            = $0047  ; 71
MONSTER_ING                             = $0048  ; 72
MONSTER_HUMPTY                          = $0049  ; 73
MONSTER_BRAINPAN                        = $004a  ; 74
MONSTER_CRULLER                         = $004b  ; 75
MONSTER_CACTROT                         = $004c  ; 76
MONSTER_REPO_MAN                        = $004d  ; 77
MONSTER_HARVESTER                       = $004e  ; 78
MONSTER_BOMB                            = $004f  ; 79
MONSTER_STILL_LIFE                      = $0050  ; 80
MONSTER_BOXED_SET                       = $0051  ; 81
MONSTER_SLAMDANCER                      = $0052  ; 82
MONSTER_HADESGIGAS                      = $0053  ; 83
MONSTER_PUG                             = $0054  ; 84
MONSTER_MAGIC_URN                       = $0055  ; 85
MONSTER_MOVER                           = $0056  ; 86
MONSTER_FIGALIZ                         = $0057  ; 87
MONSTER_BUFFALAX                        = $0058  ; 88
MONSTER_ASPIK                           = $0059  ; 89
MONSTER_GHOST                           = $005a  ; 90
MONSTER_CRAWLER                         = $005b  ; 91
MONSTER_SAND_RAY                        = $005c  ; 92
MONSTER_ARENEID                         = $005d  ; 93
MONSTER_ACTANEON                        = $005e  ; 94
MONSTER_SAND_HORSE                      = $005f  ; 95
MONSTER_DARK_SIDE                       = $0060  ; 96
MONSTER_MAD_OSCAR                       = $0061  ; 97
MONSTER_CRAWLY                          = $0062  ; 98
MONSTER_BLEARY                          = $0063  ; 99
MONSTER_MARSHAL                         = $0064  ; 100
MONSTER_TROOPER                         = $0065  ; 101
MONSTER_GENERAL                         = $0066  ; 102
MONSTER_COVERT                          = $0067  ; 103
MONSTER_OGOR                            = $0068  ; 104
MONSTER_WARLOCK                         = $0069  ; 105
MONSTER_MADAM                           = $006a  ; 106
MONSTER_JOKER                           = $006b  ; 107
MONSTER_IRON_FIST                       = $006c  ; 108
MONSTER_GOBLIN                          = $006d  ; 109
MONSTER_APPARITE                        = $006e  ; 110
MONSTER_POWERDEMON                      = $006f  ; 111
MONSTER_DISPLAYER                       = $0070  ; 112
MONSTER_VECTOR_PUP                      = $0071  ; 113
MONSTER_PEEPERS                         = $0072  ; 114
MONSTER_SEWER_RAT                       = $0073  ; 115
MONSTER_SLATTER                         = $0074  ; 116
MONSTER_RHINOX                          = $0075  ; 117
MONSTER_RHOBITE                         = $0076  ; 118
MONSTER_WILD_CAT                        = $0077  ; 119
MONSTER_RED_FANG                        = $0078  ; 120
MONSTER_BOUNTY_MAN                      = $0079  ; 121
MONSTER_TUSKER                          = $007a  ; 122
MONSTER_RALPH                           = $007b  ; 123
MONSTER_CHITONID                        = $007c  ; 124
MONSTER_WART_PUCK                       = $007d  ; 125
MONSTER_RHYOS                           = $007e  ; 126
MONSTER_SRBEHEMOTH_UNDEAD               = $007f  ; 127
MONSTER_VECTAUR                         = $0080  ; 128
MONSTER_WYVERN                          = $0081  ; 129
MONSTER_ZOMBONE                         = $0082  ; 130
MONSTER_DRAGON                          = $0083  ; 131
MONSTER_BRONTAUR                        = $0084  ; 132
MONSTER_ALLOSAURUS                      = $0085  ; 133
MONSTER_CIRPIUS                         = $0086  ; 134
MONSTER_SPRINTER                        = $0087  ; 135
MONSTER_GOBBLER                         = $0088  ; 136
MONSTER_HARPIAI                         = $0089  ; 137
MONSTER_GLOOMSHELL                      = $008a  ; 138
MONSTER_DROP                            = $008b  ; 139
MONSTER_MIND_CANDY                      = $008c  ; 140
MONSTER_WEEDFEEDER                      = $008d  ; 141
MONSTER_LURIDAN                         = $008e  ; 142
MONSTER_TOE_CUTTER                      = $008f  ; 143
MONSTER_OVER_GRUNK                      = $0090  ; 144
MONSTER_EXORAY                          = $0091  ; 145
MONSTER_CRUSHER                         = $0092  ; 146
MONSTER_UROBUROS                        = $0093  ; 147
MONSTER_PRIMORDITE                      = $0094  ; 148
MONSTER_SKY_CAP                         = $0095  ; 149
MONSTER_CEPHALER                        = $0096  ; 150
MONSTER_MALIGA                          = $0097  ; 151
MONSTER_GIGAN_TOAD                      = $0098  ; 152
MONSTER_GECKOREX                        = $0099  ; 153
MONSTER_CLUCK                           = $009a  ; 154
MONSTER_LAND_WORM                       = $009b  ; 155
MONSTER_TEST_RIDER                      = $009c  ; 156
MONSTER_PLUTOARMOR                      = $009d  ; 157
MONSTER_TOMB_THUMB                      = $009e  ; 158
MONSTER_HEAVYARMOR                      = $009f  ; 159
MONSTER_CHASER                          = $00a0  ; 160
MONSTER_SCULLION                        = $00a1  ; 161
MONSTER_POPLIUM                         = $00a2  ; 162
MONSTER_INTANGIR                        = $00a3  ; 163
MONSTER_MISFIT                          = $00a4  ; 164
MONSTER_ELAND                           = $00a5  ; 165
MONSTER_ENUO                            = $00a6  ; 166
MONSTER_DEEP_EYE                        = $00a7  ; 167
MONSTER_GREASEMONK                      = $00a8  ; 168
MONSTER_NECKHUNTER                      = $00a9  ; 169
MONSTER_GRENADE                         = $00aa  ; 170
MONSTER_CRITIC                          = $00ab  ; 171
MONSTER_PAN_DORA                        = $00ac  ; 172
MONSTER_SOULDANCER                      = $00ad  ; 173
MONSTER_GIGANTOS                        = $00ae  ; 174
MONSTER_MAG_ROADER_2                    = $00af  ; 175
MONSTER_SPEK_TOR                        = $00b0  ; 176
MONSTER_PARASITE                        = $00b1  ; 177
MONSTER_EARTHGUARD                      = $00b2  ; 178
MONSTER_COELECITE                       = $00b3  ; 179
MONSTER_ANEMONE                         = $00b4  ; 180
MONSTER_HIPOCAMPUS                      = $00b5  ; 181
MONSTER_SPECTRE                         = $00b6  ; 182
MONSTER_EVIL_OSCAR                      = $00b7  ; 183
MONSTER_SLURM                           = $00b8  ; 184
MONSTER_LATIMERIA                       = $00b9  ; 185
MONSTER_STILLGOING                      = $00ba  ; 186
MONSTER_ALLO_VER                        = $00bb  ; 187
MONSTER_PHASE                           = $00bc  ; 188
MONSTER_OUTSIDER                        = $00bd  ; 189
MONSTER_BARB_E                          = $00be  ; 190
MONSTER_PARASOUL                        = $00bf  ; 191
MONSTER_PM_STALKER                      = $00c0  ; 192
MONSTER_HEMOPHYTE                       = $00c1  ; 193
MONSTER_SP_FORCES                       = $00c2  ; 194
MONSTER_NOHRABBIT                       = $00c3  ; 195
MONSTER_WIZARD                          = $00c4  ; 196
MONSTER_SCRAPPER                        = $00c5  ; 197
MONSTER_CERITOPS                        = $00c6  ; 198
MONSTER_COMMANDO                        = $00c7  ; 199
MONSTER_OPINICUS                        = $00c8  ; 200
MONSTER_POPPERS                         = $00c9  ; 201
MONSTER_LUNARIS                         = $00ca  ; 202
MONSTER_GARM                            = $00cb  ; 203
MONSTER_VINDR                           = $00cc  ; 204
MONSTER_KIWOK                           = $00cd  ; 205
MONSTER_NASTIDON                        = $00ce  ; 206
MONSTER_RINN                            = $00cf  ; 207
MONSTER_INSECARE                        = $00d0  ; 208
MONSTER_VERMIN                          = $00d1  ; 209
MONSTER_MANTODEA                        = $00d2  ; 210
MONSTER_BOGY                            = $00d3  ; 211
MONSTER_PRUSSIAN                        = $00d4  ; 212
MONSTER_BLACK_DRGN                      = $00d5  ; 213
MONSTER_ADAMANCHYT                      = $00d6  ; 214
MONSTER_DANTE                           = $00d7  ; 215
MONSTER_WIREY_DRGN                      = $00d8  ; 216
MONSTER_DUELLER                         = $00d9  ; 217
MONSTER_PSYCHOT                         = $00da  ; 218
MONSTER_MUUS                            = $00db  ; 219
MONSTER_KARKASS                         = $00dc  ; 220
MONSTER_PUNISHER                        = $00dd  ; 221
MONSTER_BALLOON                         = $00de  ; 222
MONSTER_GABBLDEGAK                      = $00df  ; 223
MONSTER_GTBEHEMOTH                      = $00e0  ; 224
MONSTER_SCORPION                        = $00e1  ; 225
MONSTER_CHAOS_DRGN                      = $00e2  ; 226
MONSTER_SPIT_FIRE                       = $00e3  ; 227
MONSTER_VECTAGOYLE                      = $00e4  ; 228
MONSTER_LICH                            = $00e5  ; 229
MONSTER_OSPREY                          = $00e6  ; 230
MONSTER_MAG_ROADER_3                    = $00e7  ; 231
MONSTER_BUG                             = $00e8  ; 232
MONSTER_SEA_FLOWER                      = $00e9  ; 233
MONSTER_FORTIS                          = $00ea  ; 234
MONSTER_ABOLISHER                       = $00eb  ; 235
MONSTER_AQUILA                          = $00ec  ; 236
MONSTER_JUNK                            = $00ed  ; 237
MONSTER_MANDRAKE                        = $00ee  ; 238
MONSTER_1ST_CLASS                       = $00ef  ; 239
MONSTER_TAP_DANCER                      = $00f0  ; 240
MONSTER_NECROMANCR                      = $00f1  ; 241
MONSTER_BORRAS                          = $00f2  ; 242
MONSTER_MAG_ROADER_4                    = $00f3  ; 243
MONSTER_WILD_RAT                        = $00f4  ; 244
MONSTER_GOLD_BEAR                       = $00f5  ; 245
MONSTER_INNOC                           = $00f6  ; 246
MONSTER_TRIXTER                         = $00f7  ; 247
MONSTER_RED_WOLF                        = $00f8  ; 248
MONSTER_DIDALOS                         = $00f9  ; 249
MONSTER_WOOLLY                          = $00fa  ; 250
MONSTER_VETERAN                         = $00fb  ; 251
MONSTER_SKY_BASE                        = $00fc  ; 252
MONSTER_IRONHITMAN                      = $00fd  ; 253
MONSTER_IO                              = $00fe  ; 254
MONSTER_PUGS                            = $00ff  ; 255
MONSTER_WHELK                           = $0100  ; 256
MONSTER_PRESENTER                       = $0101  ; 257
MONSTER_MEGA_ARMOR                      = $0102  ; 258
MONSTER_VARGAS                          = $0103  ; 259
MONSTER_TUNNELARMR                      = $0104  ; 260
MONSTER_PROMETHEUS                      = $0105  ; 261
MONSTER_GHOSTTRAIN                      = $0106  ; 262
MONSTER_DADALUMA                        = $0107  ; 263
MONSTER_SHIVA                           = $0108  ; 264
MONSTER_IFRIT                           = $0109  ; 265
MONSTER_NUMBER_024                      = $010a  ; 266
MONSTER_NUMBER_128                      = $010b  ; 267
MONSTER_INFERNO                         = $010c  ; 268
MONSTER_CRANE_1                         = $010d  ; 269
MONSTER_CRANE_2                         = $010e  ; 270
MONSTER_UMARO_1                         = $010f  ; 271
MONSTER_UMARO_2                         = $0110  ; 272
MONSTER_GUARDIAN_VECTOR                 = $0111  ; 273
MONSTER_GUARDIAN_BOSS                   = $0112  ; 274
MONSTER_AIR_FORCE                       = $0113  ; 275
MONSTER_TRITOCH_INTRO                   = $0114  ; 276
MONSTER_TRITOCH_MORPH                   = $0115  ; 277
MONSTER_FLAMEEATER                      = $0116  ; 278
MONSTER_ATMAWEAPON                      = $0117  ; 279
MONSTER_NERAPA                          = $0118  ; 280
MONSTER_SRBEHEMOTH                      = $0119  ; 281
MONSTER_KEFKA_1                         = $011a  ; 282
MONSTER_TENTACLE                        = $011b  ; 283
MONSTER_DULLAHAN                        = $011c  ; 284
MONSTER_DOOM_GAZE                       = $011d  ; 285
MONSTER_CHADARNOOK_1                    = $011e  ; 286
MONSTER_CURLEY                          = $011f  ; 287
MONSTER_LARRY                           = $0120  ; 288
MONSTER_MOE                             = $0121  ; 289
MONSTER_WREXSOUL                        = $0122  ; 290
MONSTER_HIDON                           = $0123  ; 291
MONSTER_KATANASOUL                      = $0124  ; 292
MONSTER_L30_MAGIC                       = $0125  ; 293
MONSTER_HIDONITE                        = $0126  ; 294
MONSTER_DOOM                            = $0127  ; 295
MONSTER_GODDESS                         = $0128  ; 296
MONSTER_POLTRGEIST                      = $0129  ; 297
MONSTER_FINAL_KEFKA                     = $012a  ; 298
MONSTER_L40_MAGIC                       = $012b  ; 299
MONSTER_ULTROS_RIVER                    = $012c  ; 300
MONSTER_ULTROS_OPERA                    = $012d  ; 301
MONSTER_ULTROS_MOUNTAIN                 = $012e  ; 302
MONSTER_CHUPON_AIRSHIP                  = $012f  ; 303
MONSTER_L20_MAGIC                       = $0130  ; 304
MONSTER_SIEGFRIED_2                     = $0131  ; 305
MONSTER_L10_MAGIC                       = $0132  ; 306
MONSTER_L50_MAGIC                       = $0133  ; 307
MONSTER_HEAD                            = $0134  ; 308
MONSTER_WHELK_HEAD                      = $0135  ; 309
MONSTER_COLOSSUS                        = $0136  ; 310
MONSTER_CZARDRAGON                      = $0137  ; 311
MONSTER_MASTER_PUG                      = $0138  ; 312
MONSTER_L60_MAGIC                       = $0139  ; 313
MONSTER_MERCHANT                        = $013a  ; 314
MONSTER_B_DAY_SUIT                      = $013b  ; 315
MONSTER_TENTACLE_1                      = $013c  ; 316
MONSTER_TENTACLE_2                      = $013d  ; 317
MONSTER_TENTACLE_3                      = $013e  ; 318
MONSTER_RIGHTBLADE                      = $013f  ; 319
MONSTER_LEFT_BLADE                      = $0140  ; 320
MONSTER_ROUGH                           = $0141  ; 321
MONSTER_STRIKER                         = $0142  ; 322
MONSTER_L70_MAGIC                       = $0143  ; 323
MONSTER_TRITOCH_BOSS                    = $0144  ; 324
MONSTER_LASER_GUN                       = $0145  ; 325
MONSTER_SPECK                           = $0146  ; 326
MONSTER_MISSILEBAY                      = $0147  ; 327
MONSTER_CHADARNOOK_2                    = $0148  ; 328
MONSTER_ICE_DRAGON                      = $0149  ; 329
MONSTER_KEFKA_NARSHE                    = $014a  ; 330
MONSTER_STORM_DRGN                      = $014b  ; 331
MONSTER_DIRT_DRGN                       = $014c  ; 332
MONSTER_IPOOH                           = $014d  ; 333
MONSTER_LEADER                          = $014e  ; 334
MONSTER_GRUNT                           = $014f  ; 335
MONSTER_GOLD_DRGN                       = $0150  ; 336
MONSTER_SKULL_DRGN                      = $0151  ; 337
MONSTER_BLUE_DRGN                       = $0152  ; 338
MONSTER_RED_DRAGON                      = $0153  ; 339
MONSTER_PIRANHA                         = $0154  ; 340
MONSTER_RIZOPAS                         = $0155  ; 341
MONSTER_SPECTER                         = $0156  ; 342
MONSTER_SHORT_ARM                       = $0157  ; 343
MONSTER_LONG_ARM                        = $0158  ; 344
MONSTER_FACE                            = $0159  ; 345
MONSTER_TIGER                           = $015a  ; 346
MONSTER_TOOLS                           = $015b  ; 347
MONSTER_MAGIC                           = $015c  ; 348
MONSTER_HIT                             = $015d  ; 349
MONSTER_GIRL                            = $015e  ; 350
MONSTER_SLEEP                           = $015f  ; 351
MONSTER_HIDONITE_1                      = $0160  ; 352
MONSTER_HIDONITE_2                      = $0161  ; 353
MONSTER_HIDONITE_3                      = $0162  ; 354
MONSTER_L80_MAGIC                       = $0163  ; 355
MONSTER_L90_MAGIC                       = $0164  ; 356
MONSTER_PROTOARMOR                      = $0165  ; 357
MONSTER_MAGIMASTER                      = $0166  ; 358
MONSTER_SOULSAVER                       = $0167  ; 359
MONSTER_ULTROS_AIRSHIP                  = $0168  ; 360
MONSTER_NAUGHTY                         = $0169  ; 361
MONSTER_PHUNBABA_1                      = $016a  ; 362
MONSTER_PHUNBABA_2                      = $016b  ; 363
MONSTER_PHUNBABA_3                      = $016c  ; 364
MONSTER_PHUNBABA_4                      = $016d  ; 365
MONSTER_TERRA_FLASHBACK                 = $016e  ; 366
MONSTER_KEFKA_IMP_CAMP                  = $016f  ; 367
MONSTER_CYAN_IMP_CAMP                   = $0170  ; 368
MONSTER_ZONE_EATER                      = $0171  ; 369
MONSTER_GAU_VELDT                       = $0172  ; 370
MONSTER_KEFKA_VS_LEO                    = $0173  ; 371
MONSTER_KEFKA_ESPER_GATE                = $0174  ; 372
MONSTER_OFFICER                         = $0175  ; 373
MONSTER_CADET                           = $0176  ; 374
MONSTER_0177                            = $0177  ; 375
MONSTER_0178                            = $0178  ; 376
MONSTER_SOLDIER_FLASHBACK               = $0179  ; 377
MONSTER_KEFKA_VS_ESPER                  = $017a  ; 378
MONSTER_EVENT                           = $017b  ; 379
MONSTER_017C                            = $017c  ; 380
MONSTER_ATMA                            = $017d  ; 381
MONSTER_SHADOW_COLOSSEUM                = $017e  ; 382
MONSTER_COLOSSEUM                       = $017f  ; 383

; ------------------------------------------------------------------------------

; dance ids
DANCE_WIND_SONG                         = 0
DANCE_FOREST_SUITE                      = 1
DANCE_DESERT_ARIA                       = 2
DANCE_LOVE_SONATA                       = 3
DANCE_EARTH_BLUES                       = 4
DANCE_WATER_RONDO                       = 5
DANCE_DUSK_REQUIUM                      = 6
DANCE_SNOWMAN_JAZZ                      = 7

; ------------------------------------------------------------------------------

; target selection flags
TARGET_MANUAL                           = $01  ; can move cursor manually
TARGET_ONE_SIDE                         = $02  ; can't target opposite side

TARGET_INIT_MASK                        = $0c  ; mask for initial target
TARGET_INIT_SINGLE                      = $00  ; single target
TARGET_INIT_ALL                         = $04  ; all characters and monsters
TARGET_INIT_GROUP                       = $08  ; one target group (one side)
TARGET_INIT_HALF                        = $0c  ; all characters or all monsters

TARGET_AUTO_CONFIRM                     = $10  ; don't wait for A button
TARGET_MULTI_TARGET                     = $20  ; allow L/R button multi-target
TARGET_ENEMY                            = $40  ; target enemy by default
TARGET_ROULETTE                         = $80  ; random roulette cursor

; special values, not flags
TARGET_SELF                             = $02  ; cursor on attacker
TARGET_MENU                             = $ff  ; uses a menu to choose target

; ------------------------------------------------------------------------------

; battle command flags
BATTLE_CMD_FLAG_NONE                    = $00  ; no flags set
BATTLE_CMD_FLAG_GOGO                    = $01  ; can be used by gogo
BATTLE_CMD_FLAG_MIMIC                   = $02  ; can be mimicked
BATTLE_CMD_FLAG_IMP                     = $04  ; can be used by imp
BATTLE_CMD_FLAG_UNKNOWN                 = $08  ; unknown

; ------------------------------------------------------------------------------

CHAR_PROP_TERRA                         = $00
CHAR_PROP_LOCKE                         = $01
CHAR_PROP_CYAN                          = $02
CHAR_PROP_SHADOW                        = $03
CHAR_PROP_EDGAR                         = $04
CHAR_PROP_SABIN                         = $05
CHAR_PROP_CELES                         = $06
CHAR_PROP_STRAGO                        = $07
CHAR_PROP_RELM                          = $08
CHAR_PROP_SETZER                        = $09
CHAR_PROP_MOG                           = $0a
CHAR_PROP_GAU                           = $0b
CHAR_PROP_GOGO                          = $0c
CHAR_PROP_UMARO                         = $0d
CHAR_PROP_BANON                         = $0e
CHAR_PROP_LEO                           = $0f
CHAR_PROP_GHOST_1                       = $10
CHAR_PROP_GHOST_2                       = $11
CHAR_PROP_KUPEK                         = $12
CHAR_PROP_KUPOP                         = $13
CHAR_PROP_KUMAMA                        = $14
CHAR_PROP_KUKU                          = $15
CHAR_PROP_KUTAN                         = $16
CHAR_PROP_KUPAN                         = $17
CHAR_PROP_KUSHU                         = $18
CHAR_PROP_KURIN                         = $19
CHAR_PROP_KURU                          = $1a
CHAR_PROP_KAMOG                         = $1b
CHAR_PROP_SCENARIO_MOG                  = $1c
CHAR_PROP_TERRA_INTRO                   = $1d
CHAR_PROP_MADUIN                        = $1e
CHAR_PROP_SHADOW_COLOSSEUM              = $1f
CHAR_PROP_WEDGE                         = $20
CHAR_PROP_VICKS                         = $21
CHAR_PROP_22                            = $22
CHAR_PROP_23                            = $23
CHAR_PROP_24                            = $24
CHAR_PROP_25                            = $25
CHAR_PROP_26                            = $26
CHAR_PROP_27                            = $27
CHAR_PROP_28                            = $28
CHAR_PROP_KEFKA_1                       = $29
CHAR_PROP_KEFKA_2                       = $2a
CHAR_PROP_KEFKA_3                       = $2b
CHAR_PROP_KEFKA_4                       = $2c
CHAR_PROP_KEFKA_5                       = $2d
CHAR_PROP_KEFKA_6                       = $2e
CHAR_PROP_KEFKA_7                       = $2f
CHAR_PROP_TORK                          = $30
CHAR_PROP_JADE                          = $31
CHAR_PROP_CUSTER                        = $32
CHAR_PROP_FABIAN                        = $33
CHAR_PROP_DRAKE                         = $34
CHAR_PROP_SARA                          = $35
CHAR_PROP_CASE                          = $36
CHAR_PROP_SIELE                         = $37
CHAR_PROP_RAY                           = $38
CHAR_PROP_REIKER                        = $39
CHAR_PROP_LANCE                         = $3a
CHAR_PROP_BOB                           = $3b
CHAR_PROP_PEPPER                        = $3c
CHAR_PROP_TAU                           = $3d
CHAR_PROP_VICTOR                        = $3e
CHAR_PROP_HO                            = $3f

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
; ELEMENT_FIRE                            = $01
; ELEMENT_ICE                             = $02
; ELEMENT_LIGHTNING                       = $04
; ELEMENT_POISON                          = $08
; ELEMENT_WIND                            = $10
; ELEMENT_HOLY                            = $20
; ELEMENT_EARTH                           = $40
; ELEMENT_WATER                           = $80

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

; ; status 1: harmful status that persist after battle
; STATUS1_BLIND                           = $01
; STATUS1_ZOMBIE                          = $02
; STATUS1_POISON                          = $04
; STATUS1_MAGITEK                         = $08
; STATUS1_INVISIBLE                       = $10
; STATUS1_IMP                             = $20
; STATUS1_PETRIFY                         = $40
; STATUS1_DEAD                            = $80

; ; status 2: harmful status that do not persist after battle
; STATUS2_CONDEMNED                       = $01
; STATUS2_NEAR_FATAL                      = $02
; STATUS2_IMAGE                           = $04
; STATUS2_SILENCE                         = $08
; STATUS2_BERSERK                         = $10
; STATUS2_CONFUSE                         = $20
; STATUS2_SAP                             = $40
; STATUS2_SLEEP                           = $80

; ; status 3: helpful status that do not persist after battle
; STATUS3_DANCE                           = $01
; STATUS3_REGEN                           = $02
; STATUS3_SLOW                            = $04
; STATUS3_HASTE                           = $08
; STATUS3_STOP                            = $10
; STATUS3_SHELL                           = $20
; STATUS3_PROTECT                         = $40
; STATUS3_REFLECT                         = $80

; ; status 4: only float and interceptor persist after battle
; STATUS4_RAGE                            = $01
; STATUS4_FROZEN                          = $02
; STATUS4_RERAISE                         = $04
; STATUS4_MORPH                           = $08
; STATUS4_CHANT                           = $10
; STATUS4_HIDE                            = $20
; STATUS4_INTERCEPTOR                     = $40
; STATUS4_FLOAT                           = $80

; ------------------------------------------------------------------------------

ITEM_TYPE_TOOL                          = 0
ITEM_TYPE_WEAPON                        = 1
ITEM_TYPE_ARMOR                         = 2
ITEM_TYPE_SHIELD                        = 3
ITEM_TYPE_HELMET                        = 4
ITEM_TYPE_RELIC                         = 5
ITEM_TYPE_CONSUMABLE                    = 6

ITEM_USAGE_THROW                        = $10
ITEM_USAGE_BATTLE                       = $20
ITEM_USAGE_MENU                         = $40

; ------------------------------------------------------------------------------

.endif
.list on
