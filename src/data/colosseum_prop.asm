
; ------------------------------------------------------------------------------

.export ColosseumProp

; ------------------------------------------------------------------------------

; [ colosseum data format ]

;   0: monster opponent
;   1: unused (always $40)
;   2: prize item
;   3: hide prize name if nonzero

.macro colosseum_prop monster, item, hide_prize
        .ifblank monster
                .byte MONSTER::CHUPON_COLOSSEUM
                .byte $40
                .byte ITEM::ELIXIR
        .else
                .byte MONSTER::monster
                .byte $40
                .byte ITEM::item
        .endif
        .ifnblank hide_prize
                .byte $ff
        .else
                .byte 0
        .endif
.endmac

; ------------------------------------------------------------------------------

.segment "colosseum_prop"

; df/b600
ColosseumProp:

        colosseum_prop                                     ; DIRK
        colosseum_prop                                     ; MITHRILKNIFE
        colosseum_prop                                     ; MAIN_GAUCHE
        colosseum_prop                                     ; AIR_LANCET
        colosseum_prop WART_PUCK, THIEF_GLOVE              ; THIEFKNIFE
        colosseum_prop TEST_RIDER, SWORDBREAKER            ; ASSASSIN
        colosseum_prop                                     ; MAN_EATER
        colosseum_prop                                     ; SWORDBREAKER
        colosseum_prop KARKASS, DIRK                       ; GRAEDUS
        colosseum_prop WOOLLY, ASSASSIN                    ; VALIANTKNIFE
        colosseum_prop                                     ; MITHRILBLADE
        colosseum_prop                                     ; REGAL_CUTLASS
        colosseum_prop                                     ; RUNE_EDGE
        colosseum_prop EVIL_OSCAR, OGRE_NIX                ; FLAME_SABRE
        colosseum_prop SCULLION, OGRE_NIX                  ; BLIZZARD
        colosseum_prop STEROIDITE, OGRE_NIX                ; THUNDERBLADE
        colosseum_prop                                     ; EPEE
        colosseum_prop LETHAL_WPN, BREAK_BLADE             ; BREAK_BLADE
        colosseum_prop ENUO, DRAINER                       ; DRAINER
        colosseum_prop                                     ; ENHANCER
        colosseum_prop BORRAS, ENHANCER                    ; CRYSTAL
        colosseum_prop OUTSIDER, FLAME_SHLD                ; FALCHION
        colosseum_prop OPINICUS, FALCHION                  ; SOUL_SABRE
        colosseum_prop SRBEHEMOTH_UNDEAD, SOUL_SABRE       ; OGRE_NIX
        colosseum_prop                                     ; EXCALIBUR
        colosseum_prop COVERT, OGRE_NIX                    ; SCIMITAR
        colosseum_prop SCULLION, SCIMITAR                  ; ILLUMINA
        colosseum_prop DIDALOS, ILLUMINA, 1                ; RAGNAROK
        colosseum_prop GTBEHEMOTH, GRAEDUS                 ; ATMA_WEAPON
        colosseum_prop                                     ; MITHRIL_PIKE
        colosseum_prop                                     ; TRIDENT
        colosseum_prop                                     ; STOUT_SPEAR
        colosseum_prop                                     ; PARTISAN
        colosseum_prop SKY_BASE, STRATO                    ; HOLY_LANCE
        colosseum_prop                                     ; GOLD_LANCE
        colosseum_prop LAND_WORM, SKY_RENDER               ; AURA_LANCE
        colosseum_prop ALLOSAURUS, CAT_HOOD                ; IMP_HALBERD
        colosseum_prop                                     ; IMPERIAL
        colosseum_prop                                     ; KODACHI
        colosseum_prop                                     ; BLOSSOM
        colosseum_prop PHASE, MURASAME                     ; HARDENED
        colosseum_prop CHUPON_COLOSSEUM, STRIKER, 1        ; STRIKER
        colosseum_prop TEST_RIDER, STRATO                  ; STUNNER
        colosseum_prop                                     ; ASHURA
        colosseum_prop                                     ; KOTETSU
        colosseum_prop                                     ; FORGED
        colosseum_prop                                     ; TEMPEST
        colosseum_prop BORRAS, AURA                        ; MURASAME
        colosseum_prop RHYOS, STRATO                       ; AURA
        colosseum_prop AQUILA, HOLY_LANCE                  ; STRATO
        colosseum_prop SCULLION, AURA_LANCE                ; SKY_RENDER
        colosseum_prop PUG, MAGUS_ROD                      ; HEAL_ROD
        colosseum_prop                                     ; MITHRIL_ROD
        colosseum_prop                                     ; FIRE_ROD
        colosseum_prop                                     ; ICE_ROD
        colosseum_prop                                     ; THUNDER_ROD
        colosseum_prop                                     ; POISON_ROD
        colosseum_prop                                     ; HOLY_ROD
        colosseum_prop                                     ; GRAVITY_ROD
        colosseum_prop OPINICUS, GRAVITY_ROD               ; PUNISHER
        colosseum_prop ALLOSAURUS, STRATO                  ; MAGUS_ROD
        colosseum_prop                                     ; CHOCOBO_BRSH
        colosseum_prop                                     ; DAVINCI_BRSH
        colosseum_prop                                     ; MAGICAL_BRSH
        colosseum_prop TEST_RIDER, GRAVITY_ROD             ; RAINBOW_BRSH
        colosseum_prop                                     ; SHURIKEN
        colosseum_prop CHAOS_DRGN, TACK_STAR               ; NINJA_STAR
        colosseum_prop OPINICUS, RISING_SUN                ; TACK_STAR
        colosseum_prop                                     ; FLAIL
        colosseum_prop                                     ; FULL_MOON
        colosseum_prop                                     ; MORNING_STAR
        colosseum_prop                                     ; BOOMERANG
        colosseum_prop ALLOSAURUS, BONE_CLUB               ; RISING_SUN
        colosseum_prop                                     ; HAWK_EYE
        colosseum_prop TEST_RIDER, RED_JACKET              ; BONE_CLUB
        colosseum_prop BORRAS, BONE_CLUB                   ; SNIPER
        colosseum_prop RHYOS, SNIPER                       ; WING_EDGE
        colosseum_prop                                     ; CARDS
        colosseum_prop                                     ; DARTS
        colosseum_prop OPINICUS, BONE_CLUB                 ; DOOM_DARTS
        colosseum_prop ALLOSAURUS, TRUMP                   ; TRUMP
        colosseum_prop                                     ; DICE
        colosseum_prop TRIXTER, FIRE_KNUCKLE               ; FIXED_DICE
        colosseum_prop                                     ; METALKNUCKLE
        colosseum_prop                                     ; MITHRIL_CLAW
        colosseum_prop                                     ; KAISER
        colosseum_prop                                     ; POISON_CLAW
        colosseum_prop TUMBLEWEED, FIRE_KNUCKLE            ; FIRE_KNUCKLE
        colosseum_prop TEST_RIDER, SNIPER                  ; DRAGON_CLAW
        colosseum_prop MANTODEA, FIRE_KNUCKLE              ; TIGER_FANGS
        colosseum_prop                                     ; BUCKLER
        colosseum_prop                                     ; HEAVY_SHLD
        colosseum_prop                                     ; MITHRIL_SHLD
        colosseum_prop                                     ; GOLD_SHLD
        colosseum_prop BORRAS, TORTOISESHLD                ; AEGIS_SHLD
        colosseum_prop                                     ; DIAMOND_SHLD
        colosseum_prop IRONHITMAN, ICE_SHLD                ; FLAME_SHLD
        colosseum_prop INNOC, FLAME_SHLD                   ; ICE_SHLD
        colosseum_prop OUTSIDER, GENJI_SHLD                ; THUNDER_SHLD
        colosseum_prop                                     ; CRYSTAL_SHLD
        colosseum_prop RETAINER, THUNDER_SHLD              ; GENJI_SHLD
        colosseum_prop STEROIDITE, TITANIUM                ; TORTOISESHLD
        colosseum_prop DIDALOS, CURSED_RING                ; CURSED_SHLD
        colosseum_prop HEMOPHYTE, FORCE_SHLD               ; PALADIN_SHLD
        colosseum_prop DARK_FORCE, THORNLET                ; FORCE_SHLD
        colosseum_prop                                     ; LEATHER_HAT
        colosseum_prop                                     ; HAIR_BAND
        colosseum_prop                                     ; PLUMED_HAT
        colosseum_prop                                     ; BERET
        colosseum_prop                                     ; MAGUS_HAT
        colosseum_prop                                     ; BANDANA
        colosseum_prop                                     ; IRON_HELMET
        colosseum_prop EVIL_OSCAR, REGAL_CROWN             ; CORONET
        colosseum_prop                                     ; BARDS_HAT
        colosseum_prop                                     ; GREEN_BERET
        colosseum_prop                                     ; HEAD_BAND
        colosseum_prop                                     ; MITHRIL_HELM
        colosseum_prop                                     ; TIARA
        colosseum_prop                                     ; GOLD_HELMET
        colosseum_prop                                     ; TIGER_MASK
        colosseum_prop RHYOS, CORONET                      ; RED_CAP
        colosseum_prop                                     ; MYSTERY_VEIL
        colosseum_prop                                     ; CIRCLET
        colosseum_prop OPINICUS, GENJI_HELMET              ; REGAL_CROWN
        colosseum_prop                                     ; DIAMOND_HELM
        colosseum_prop                                     ; DARK_HOOD
        colosseum_prop DUELLER, DIAMOND_HELM               ; CRYSTAL_HELM
        colosseum_prop                                     ; OATH_VEIL
        colosseum_prop HOOVER, MERIT_AWARD, 1              ; CAT_HOOD
        colosseum_prop FORTIS, CRYSTAL_HELM                ; GENJI_HELMET
        colosseum_prop OPINICUS, MIRAGE_VEST               ; THORNLET
        colosseum_prop BRACHOSAUR, CAT_HOOD                ; TITANIUM
        colosseum_prop                                     ; LEATHERARMOR
        colosseum_prop                                     ; COTTON_ROBE
        colosseum_prop                                     ; KUNG_FU_SUIT
        colosseum_prop                                     ; IRON_ARMOR
        colosseum_prop                                     ; SILK_ROBE
        colosseum_prop                                     ; MITHRIL_VEST
        colosseum_prop                                     ; NINJA_GEAR
        colosseum_prop                                     ; WHITE_DRESS
        colosseum_prop                                     ; MITHRIL_MAIL
        colosseum_prop                                     ; GAIA_GEAR
        colosseum_prop VECTAGOYLE, RED_JACKET              ; MIRAGE_VEST
        colosseum_prop                                     ; GOLD_ARMOR
        colosseum_prop                                     ; POWER_SASH
        colosseum_prop                                     ; LIGHT_ROBE
        colosseum_prop                                     ; DIAMOND_VEST
        colosseum_prop VECTAGOYLE, RED_JACKET              ; RED_JACKET
        colosseum_prop SRBEHEMOTH_UNDEAD, FORCE_ARMOR      ; FORCE_ARMOR
        colosseum_prop                                     ; DIAMONDARMOR
        colosseum_prop                                     ; DARK_GEAR
        colosseum_prop TEST_RIDER, TAO_ROBE                ; TAO_ROBE
        colosseum_prop COVERT, ICE_SHLD                    ; CRYSTAL_MAIL
        colosseum_prop SKY_BASE, MINERVA                   ; CZARINA_GOWN
        colosseum_prop BORRAS, AIR_ANCHOR                  ; GENJI_ARMOR
        colosseum_prop RHYOS, TORTOISESHLD                 ; IMPS_ARMOR
        colosseum_prop PUG, CZARINA_GOWN                   ; MINERVA
        colosseum_prop VECTAUR, CHOCOBO_SUIT               ; TABBY_SUIT
        colosseum_prop VETERAN, MOOGLE_SUIT                ; CHOCOBO_SUIT
        colosseum_prop MADAM, NUTKIN_SUIT                  ; MOOGLE_SUIT
        colosseum_prop OPINICUS, GENJI_ARMOR               ; NUTKIN_SUIT
        colosseum_prop OUTSIDER, SNOW_MUFFLER              ; BEHEMOTHSUIT
        colosseum_prop RETAINER, CHARM_BANGLE              ; SNOW_MUFFLER
        colosseum_prop                                     ; NOISEBLASTER
        colosseum_prop                                     ; BIO_BLASTER
        colosseum_prop                                     ; FLASH
        colosseum_prop                                     ; CHAIN_SAW
        colosseum_prop                                     ; DEBILITATOR
        colosseum_prop                                     ; DRILL
        colosseum_prop BRONTAUR, ZEPHYR_CAPE               ; AIR_ANCHOR
        colosseum_prop                                     ; AUTOCROSSBOW
        colosseum_prop                                     ; FIRE_SKEAN
        colosseum_prop                                     ; WATER_EDGE
        colosseum_prop                                     ; BOLT_EDGE
        colosseum_prop                                     ; INVIZ_EDGE
        colosseum_prop                                     ; SHADOW_EDGE
        colosseum_prop                                     ; GOGGLES
        colosseum_prop                                     ; STAR_PENDANT
        colosseum_prop                                     ; PEACE_RING
        colosseum_prop                                     ; AMULET
        colosseum_prop                                     ; WHITE_CAPE
        colosseum_prop                                     ; JEWEL_RING
        colosseum_prop                                     ; FAIRY_RING
        colosseum_prop                                     ; BARRIER_RING
        colosseum_prop                                     ; MITHRILGLOVE
        colosseum_prop                                     ; GUARD_RING
        colosseum_prop                                     ; RUNNINGSHOES
        colosseum_prop                                     ; WALL_RING
        colosseum_prop                                     ; CHERUB_DOWN
        colosseum_prop                                     ; CURE_RING
        colosseum_prop                                     ; TRUE_KNIGHT
        colosseum_prop                                     ; DRAGOONBOOTS
        colosseum_prop                                     ; ZEPHYR_CAPE
        colosseum_prop                                     ; CZARINA_RING
        colosseum_prop STEROIDITE, AIR_ANCHOR              ; CURSED_RING
        colosseum_prop                                     ; EARRINGS
        colosseum_prop                                     ; ATLAS_ARMLET
        colosseum_prop ALLOSAURUS, RAGE_RING               ; BLIZZARD_ORB
        colosseum_prop ALLOSAURUS, BLIZZARD_ORB            ; RAGE_RING
        colosseum_prop TAP_DANCER, THIEF_GLOVE             ; SNEAK_RING
        colosseum_prop HEMOPHYTE, HERO_RING                ; POD_BRACELET
        colosseum_prop RHYOS, POD_BRACELET                 ; HERO_RING
        colosseum_prop DARK_FORCE, GOLD_HAIRPIN            ; RIBBON
        colosseum_prop ALLOSAURUS, CRYSTAL_ORB             ; MUSCLE_BELT
        colosseum_prop BORRAS, GOLD_HAIRPIN                ; CRYSTAL_ORB
        colosseum_prop EVIL_OSCAR, DRAGON_HORN             ; GOLD_HAIRPIN
        colosseum_prop VECTAGOYLE, DRAGON_HORN             ; ECONOMIZER
        colosseum_prop HARPY, DIRK                         ; THIEF_GLOVE
        colosseum_prop VECTAGOYLE, THUNDER_SHLD            ; GAUNTLET
        colosseum_prop HEMOPHYTE, THUNDER_SHLD             ; GENJI_GLOVE
        colosseum_prop                                     ; HYPER_WRIST
        colosseum_prop                                     ; OFFERING
        colosseum_prop                                     ; BEADS
        colosseum_prop                                     ; BLACK_BELT
        colosseum_prop                                     ; COIN_TOSS
        colosseum_prop                                     ; FAKEMUSTACHE
        colosseum_prop SRBEHEMOTH_UNDEAD, ECONOMIZER       ; GEM_BOX
        colosseum_prop RHYOS, GOLD_HAIRPIN                 ; DRAGON_HORN
        colosseum_prop COVERT, RENAME_CARD, 1              ; MERIT_AWARD
        colosseum_prop CHUPON_COLOSSEUM, MEMENTO_RING      ; MEMENTO_RING
        colosseum_prop PUG, DRAGON_HORN                    ; SAFETY_BIT
        colosseum_prop SKY_BASE, CHARM_BANGLE              ; RELIC_RING
        colosseum_prop OUTSIDER, CHARM_BANGLE              ; MOOGLE_CHARM
        colosseum_prop RETAINER, DRAGON_HORN               ; CHARM_BANGLE
        colosseum_prop TYRANOSAUR, TINTINABAR              ; MARVEL_SHOES
        colosseum_prop                                     ; BACK_GUARD
        colosseum_prop                                     ; GALE_HAIRPIN
        colosseum_prop                                     ; SNIPER_SIGHT
        colosseum_prop STEROIDITE, TINTINABAR              ; EXP_EGG
        colosseum_prop DARK_FORCE, EXP_EGG                 ; TINTINABAR
        colosseum_prop                                     ; SPRINT_SHOES
        colosseum_prop DOOM_DRGN, MARVEL_SHOES             ; RENAME_CARD
        colosseum_prop                                     ; TONIC
        colosseum_prop                                     ; POTION
        colosseum_prop                                     ; X_POTION
        colosseum_prop                                     ; TINCTURE
        colosseum_prop                                     ; ETHER
        colosseum_prop                                     ; X_ETHER
        colosseum_prop CACTROT, RENAME_CARD                ; ELIXIR
        colosseum_prop SIEGFRIED_1, TINTINABAR             ; MEGALIXIR
        colosseum_prop CACTROT, MAGICITE                   ; FENIX_DOWN
        colosseum_prop                                     ; REVIVIFY
        colosseum_prop                                     ; ANTIDOTE
        colosseum_prop                                     ; EYEDROP
        colosseum_prop                                     ; SOFT
        colosseum_prop                                     ; REMEDY
        colosseum_prop                                     ; SLEEPING_BAG
        colosseum_prop                                     ; TENT
        colosseum_prop                                     ; GREEN_CHERRY
        colosseum_prop                                     ; MAGICITE
        colosseum_prop                                     ; SUPER_BALL
        colosseum_prop                                     ; ECHO_SCREEN
        colosseum_prop                                     ; SMOKE_BOMB
        colosseum_prop                                     ; WARP_STONE
        colosseum_prop                                     ; DRIED_MEAT
        colosseum_prop                                     ; EMPTY

; ------------------------------------------------------------------------------

.delmac colosseum_prop

; ------------------------------------------------------------------------------
