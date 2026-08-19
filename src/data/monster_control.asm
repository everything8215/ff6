.export MonsterControl

; ------------------------------------------------------------------------------

.mac monster_control attack2, attack3, attack4
        .byte ATTACK::BATTLE
        .ifnblank attack2
                .byte ATTACK::attack2
        .else
                .byte ATTACK::NONE
        .endif
        .ifnblank attack3
                .byte ATTACK::attack3
        .else
                .byte ATTACK::NONE
        .endif
        .ifnblank attack4
                .byte ATTACK::attack4
        .else
                .byte ATTACK::NONE
        .endif
.endmac

; ------------------------------------------------------------------------------

.segment "monster_control"

; cf/3d00
MonsterControl:
        monster_control                                   ; GUARD
        monster_control SCAN                              ; SOLDIER
        monster_control SPECIAL                           ; TEMPLAR
        monster_control FIRE_SKEAN, WATER_EDGE, BOLT_EDGE ; NINJA
        monster_control FLARE, DOOM, HASTE2               ; SAMURAI
        monster_control BIO, HOLY                         ; OROG
        monster_control SPECIAL                           ; MAG_ROADER_1
        monster_control SPECIAL, WIND_SLASH, CONDEMNED    ; RETAINER
        monster_control DRAIN, FIRE                       ; HAZER
        monster_control MUTE, CURA                        ; DAHLING
        monster_control SPECIAL, THUNDAGA, FLASH_RAIN     ; RAIN_MAN
        monster_control SPECIAL                           ; BRAWLER
        monster_control SPECIAL, L3_CONFUSE, L4_FLARE     ; APOKRYPHOS
        monster_control L5_DOOM, CLEANSWEEP, WHITE_WIND   ; DARK_FORCE
        monster_control FIRE, DEMI                        ; WHISPER
        monster_control DREAD                             ; OVER_MIND
        monster_control SPECIAL                           ; OSTEOSAUR
        monster_control FIRE                              ; COMMANDER
        monster_control                                   ; RHODOX
        monster_control SPECIAL                           ; WERE_RAT
        monster_control SPECIAL                           ; URSUS
        monster_control MEGA_VOLT                         ; RHINOTAUR
        monster_control SPECIAL, SNOWSTORM, BLASTER       ; STEROIDITE
        monster_control SPECIAL                           ; LEAFER
        monster_control SPECIAL                           ; STRAY_CAT
        monster_control SPECIAL                           ; LOBO
        monster_control SPECIAL                           ; DOBERMAN
        monster_control SPECIAL, SNOWSTORM                ; VOMAMMOTH
        monster_control SPECIAL                           ; FIDOR
        monster_control SPECIAL, SNOWSTORM                ; BASKERVOR
        monster_control SPECIAL, AQUA_RAKE                ; SURIANDER
        monster_control SPECIAL, AQUA_RAKE, SNOWSTORM     ; CHIMERA
        monster_control SPECIAL, METEOR, FIRAGA           ; BEHEMOTH
        monster_control SPECIAL, STEP_MINE                ; MESOSAUR
        monster_control SPECIAL, FIRE_BALL                ; PTERODON
        monster_control SPECIAL, SAND_STORM, DEZONE       ; FOSSILFANG
        monster_control HOLY, HOLY, HOLY                  ; WHITE_DRGN
        monster_control FALLEN_ONE, N_CROSS, S_CROSS      ; DOOM_DRGN
        monster_control SPECIAL                           ; BRACHOSAUR
        monster_control SPECIAL, SLOW, HASTE              ; TYRANOSAUR
        monster_control SPECIAL                           ; DARK_WIND
        monster_control SPECIAL                           ; BEAKOR
        monster_control SPECIAL, SHIMSHAM                 ; VULTURE
        monster_control SPECIAL, CYCLONIC, AERO           ; HARPY
        monster_control SPECIAL, NET                      ; HERMITCRAB
        monster_control L5_DOOM, L3_CONFUSE, L4_FLARE     ; TRAPPER
        monster_control SPECIAL                           ; HORNET
        monster_control SPECIAL                           ; CRASSHOPPR
        monster_control SPECIAL, MEGA_VOLT                ; DELTA_BUG
        monster_control SPECIAL, SHRAPNEL                 ; GILOMANTIS
        monster_control SPECIAL                           ; TRILIUM
        monster_control SPECIAL, CHARM                    ; NIGHTSHADE
        monster_control SPECIAL, LIFESHAVER               ; TUMBLEWEED
        monster_control SPECIAL, BIO, DOOM                ; BLOOMPIRE
        monster_control SPECIAL, POISON                   ; TRILOBITER
        monster_control HYPERDRIVE, SHRAPNEL, BATTLE      ; SIEGFRIED_1
        monster_control SPECIAL                           ; NAUTILOID
        monster_control SPECIAL                           ; EXOCITE
        monster_control SPECIAL, AQUA_RAKE                ; ANGUIFORM
        monster_control SPECIAL, SLIMER                   ; REACH_FROG
        monster_control BREAK, DISCHORD                   ; LIZARD
        monster_control SPECIAL, QUAKE                    ; CHICKENLIP
        monster_control SPECIAL, SAND_STORM, QUAKE        ; HOOVER
        monster_control SPECIAL, VIRITE                   ; RIDER
        monster_control SNEEZE, SNEEZE, SNEEZE            ; CHUPON_COLOSSEUM
        monster_control DEMI, QUARTR                      ; PIPSQUEAK
        monster_control TEK_LASER                         ; M_TEKARMOR
        monster_control SPECIAL, TEK_LASER                ; SKY_ARMOR
        monster_control TEK_LASER, FIRE_BALL              ; TELSTAR
        monster_control SPECIAL, TEK_LASER, ABSOLUTE0     ; LETHAL_WPN
        monster_control SLOW                              ; VAPORITE
        monster_control SPECIAL, SLIMER                   ; FLAN
        monster_control SPECIAL, LIFESHAVER               ; ING
        monster_control SPECIAL, POISON                   ; HUMPTY
        monster_control SPECIAL, BLOW_FISH                ; BRAINPAN
        monster_control SPECIAL, SLIMER                   ; CRULLER
        monster_control SPECIAL, BLOW_FISH                ; CACTROT
        monster_control SPECIAL, SPECIAL, SPECIAL         ; REPO_MAN
        monster_control SPECIAL, DRAIN                    ; HARVESTER
        monster_control EXPLODER, BLAZE                   ; BOMB
        monster_control SPECIAL, LULLABY, CONDEMNED       ; STILL_LIFE
        monster_control SPECIAL, METEOR, LODE_STONE       ; BOXED_SET
        monster_control FIRA, BLIZZARA, THUNDARA          ; SLAMDANCER
        monster_control SPECIAL, MAGNITUDE8               ; HADESGIGAS
        monster_control SPECIAL, BREAK                    ; PUG
        monster_control REMEDY, CURAGA, TORNADO           ; MAGIC_URN
        monster_control BIG_GUARD                         ; MOVER
        monster_control SPECIAL, DISCHORD, RAID           ; FIGALIZ
        monster_control SPECIAL, SURGE                    ; BUFFALAX
        monster_control SPECIAL, GIGA_VOLT                ; ASPIK
        monster_control FIRE                              ; GHOST
        monster_control SPECIAL, STEP_MINE                ; CRAWLER
        monster_control SPECIAL                           ; SAND_RAY
        monster_control SPECIAL                           ; ARENEID
        monster_control SPECIAL                           ; ACTANEON
        monster_control SPECIAL, SAND_STORM               ; SAND_HORSE
        monster_control SPECIAL, FIRE                     ; DARK_SIDE
        monster_control SPECIAL, SOUR_MOUTH               ; MAD_OSCAR
        monster_control SPECIAL, MAGNITUDE8               ; CRAWLY
        monster_control SPECIAL, DREAD                    ; BLEARY
        monster_control SPECIAL, THUNDARA                 ; MARSHAL
        monster_control SPECIAL                           ; TROOPER
        monster_control SPECIAL, CURA                     ; GENERAL
        monster_control SPECIAL, WIND_SLASH, RAGE         ; COVERT
        monster_control COLD_DUST, WHITE_WIND             ; OGOR
        monster_control SPECIAL, HOLY                     ; WARLOCK
        monster_control FLARE, HOLY, BLIZZAGA             ; MADAM
        monster_control SPECIAL, THUNDARA, ACID_RAIN      ; JOKER
        monster_control SPECIAL, STONE                    ; IRON_FIST
        monster_control FIRAGA, THUNDAGA, BLIZZAGA        ; GOBLIN
        monster_control SPECIAL, IMP                      ; APPARITE
        monster_control SPECIAL, FLARE                    ; POWERDEMON
        monster_control SPECIAL, DOOM, DEZONE             ; DISPLAYER
        monster_control SPECIAL                           ; VECTOR_PUP
        monster_control SPECIAL, WHITE_WIND               ; PEEPERS
        monster_control SPECIAL                           ; SEWER_RAT
        monster_control SPECIAL                           ; SLATTER
        monster_control SPECIAL, RERAISE                  ; RHINOX
        monster_control SPECIAL                           ; RHOBITE
        monster_control SPECIAL, BLASTER                  ; WILD_CAT
        monster_control SPECIAL                           ; RED_FANG
        monster_control SPECIAL                           ; BOUNTY_MAN
        monster_control SPECIAL                           ; TUSKER
        monster_control SPECIAL                           ; RALPH
        monster_control SPECIAL                           ; CHITONID
        monster_control SPECIAL, EXPLODER                 ; WART_PUCK
        monster_control FLARE_STAR, SURGE, AERO           ; RHYOS
        monster_control BATTLE, BATTLE, BATTLE            ; SRBEHEMOTH_UNDEAD
        monster_control SPECIAL, WHITE_WIND               ; VECTAUR
        monster_control SPECIAL, CYCLONIC                 ; WYVERN
        monster_control SPECIAL, POISON, BIO              ; ZOMBONE
        monster_control SPECIAL, REVENGE, SNOWSTORM       ; DRAGON
        monster_control SPECIAL, FIRAGA, METEOR           ; BRONTAUR
        monster_control SPECIAL, DOOM                     ; ALLOSAURUS
        monster_control SPECIAL, BREAK                    ; CIRPIUS
        monster_control SPECIAL, CYCLONIC                 ; SPRINTER
        monster_control SPECIAL, SHIMSHAM                 ; GOBBLER
        monster_control SPECIAL, AERO                     ; HARPIAI
        monster_control SPECIAL, NET                      ; GLOOMSHELL
        monster_control SPECIAL, CONFUSE                  ; DROP
        monster_control SPECIAL, SLEEP                    ; MIND_CANDY
        monster_control SPECIAL, BERSERK                  ; WEEDFEEDER
        monster_control SPECIAL, LAND_SLIDE, CAVE_IN      ; LURIDAN
        monster_control SPECIAL, SHRAPNEL                 ; TOE_CUTTER
        monster_control SPECIAL, CONFUSE                  ; OVER_GRUNK
        monster_control SPECIAL, VIRITE                   ; EXORAY
        monster_control SPECIAL, LIFESHAVER               ; CRUSHER
        monster_control BIO, QUAKE                        ; UROBUROS
        monster_control SPECIAL                           ; PRIMORDITE
        monster_control SPECIAL, TEK_LASER                ; SKY_CAP
        monster_control SPECIAL, STOP                     ; CEPHALER
        monster_control SPECIAL, REMEDY                   ; MALIGA
        monster_control SPECIAL, SLIMER                   ; GIGAN_TOAD
        monster_control SPECIAL, BREAK, DREAD             ; GECKOREX
        monster_control SPECIAL, QUAKE                    ; CLUCK
        monster_control SPECIAL, MAGNITUDE8, LODE_STONE   ; LAND_WORM
        monster_control SPECIAL, FLASH_RAIN               ; TEST_RIDER
        monster_control SPECIAL, TEK_LASER, SHRAPNEL      ; PLUTOARMOR
        monster_control SPECIAL, STEP_MINE                ; TOMB_THUMB
        monster_control SPECIAL, TEK_LASER                ; HEAVYARMOR
        monster_control SPECIAL, PLASMA, DISCHORD         ; CHASER
        monster_control SPECIAL, SPECIAL, SPECIAL         ; SCULLION
        monster_control SLOW                              ; POPLIUM
        monster_control SPECIAL, PEP_UP                   ; INTANGIR
        monster_control SPECIAL, LIFESHAVER               ; MISFIT
        monster_control SPECIAL, BIO, POISON              ; ELAND
        monster_control SPECIAL, CLEANSWEEP, AQUA_RAKE    ; ENUO
        monster_control SPECIAL, DREAD                    ; DEEP_EYE
        monster_control SPECIAL, STEP_MINE                ; GREASEMONK
        monster_control SPECIAL, IMP                      ; NECKHUNTER
        monster_control SPECIAL, BLAZE, FIRE_BALL         ; GRENADE
        monster_control SPECIAL, CONDEMNED                ; CRITIC
        monster_control SPECIAL, REVENGE                  ; PAN_DORA
        monster_control DRAIN, OSMOSE, FIRA               ; SOULDANCER
        monster_control SPECIAL, REVENGE                  ; GIGANTOS
        monster_control SPECIAL                           ; MAG_ROADER_2
        monster_control SPECIAL, ACID_RAIN                ; SPEK_TOR
        monster_control SPECIAL, GIGA_VOLT                ; PARASITE
        monster_control SPECIAL, BIG_GUARD                ; EARTHGUARD
        monster_control SPECIAL, MAGNITUDE8               ; COELECITE
        monster_control THUNDAGA, GIGA_VOLT               ; ANEMONE
        monster_control ACID_RAIN, FLASH_RAIN             ; HIPOCAMPUS
        monster_control THUNDER, FIRE, BLIZZARD           ; SPECTRE
        monster_control POISON, SNEEZE, SOUR_MOUTH        ; EVIL_OSCAR
        monster_control SPECIAL, MAGNITUDE8, QUAKE        ; SLURM
        monster_control SPECIAL, MAGNITUDE8               ; LATIMERIA
        monster_control SPECIAL                           ; STILLGOING
        monster_control SPECIAL, SPECIAL, SPECIAL         ; ALLO_VER
        monster_control SPECIAL, BLOW_FISH                ; PHASE
        monster_control SPECIAL, DEZONE, FLARE            ; OUTSIDER
        monster_control SPECIAL, CONFUSE, DISPEL          ; BARB_E
        monster_control SPECIAL, FLASH_RAIN, EL_NINO      ; PARASOUL
        monster_control POISON, DRAIN, BIO                ; PM_STALKER
        monster_control SPECIAL, SHOCK_WAVE, HOLY         ; HEMOPHYTE
        monster_control SPECIAL, SAFE                     ; SP_FORCES
        monster_control CURE, CURA, REMEDY                ; NOHRABBIT
        monster_control RASP, DEMI, STOP                  ; WIZARD
        monster_control SPECIAL, ELF_FIRE                 ; SCRAPPER
        monster_control THUNDAGA, GIGA_VOLT               ; CERITOPS
        monster_control SPECIAL, SHELL                    ; COMMANDO
        monster_control SPECIAL, SLIDE, SURGE             ; OPINICUS
        monster_control BREAK, STONE                      ; POPPERS
        monster_control SPECIAL                           ; LUNARIS
        monster_control SPECIAL, FIRA                     ; GARM
        monster_control SPECIAL, ACID_RAIN                ; VINDR
        monster_control REMEDY                            ; KIWOK
        monster_control SPECIAL                           ; NASTIDON
        monster_control SLOW                              ; RINN
        monster_control SPECIAL                           ; INSECARE
        monster_control SPECIAL, BIO                      ; VERMIN
        monster_control SPECIAL, WIND_SLASH               ; MANTODEA
        monster_control SPECIAL                           ; BOGY
        monster_control SPECIAL, STONE                    ; PRUSSIAN
        monster_control SAND_STORM, DOOM, THUNDARA        ; BLACK_DRGN
        monster_control SPECIAL, ACID_RAIN                ; ADAMANCHYT
        monster_control SPECIAL, L3_CONFUSE, BLIZZARA     ; DANTE
        monster_control SPECIAL, CYCLONIC                 ; WIREY_DRGN
        monster_control SPECIAL, MEGA_VOLT, GIGA_VOLT     ; DUELLER
        monster_control SPECIAL, LIFESHAVER               ; PSYCHOT
        monster_control SPECIAL, PEP_UP                   ; MUUS
        monster_control BREAK, THUNDAGA, FLARE            ; KARKASS
        monster_control                                   ; PUNISHER
        monster_control SPECIAL, EXPLODER                 ; BALLOON
        monster_control SPECIAL, VANISH                   ; GABBLDEGAK
        monster_control SPECIAL, METEOR, FIRAGA           ; GTBEHEMOTH
        monster_control SPECIAL                           ; SCORPION
        monster_control SPECIAL, DISASTER, METEOR         ; CHAOS_DRGN
        monster_control SPECIAL, TEK_LASER, SCHILLER      ; SPIT_FIRE
        monster_control GIGA_VOLT, AQUA_RAKE, BLAZE       ; VECTAGOYLE
        monster_control FIRE, FIRA, FIRAGA                ; LICH
        monster_control SPECIAL, SHIMSHAM                 ; OSPREY
        monster_control SPECIAL                           ; MAG_ROADER_3
        monster_control SPECIAL                           ; BUG
        monster_control SPECIAL                           ; SEA_FLOWER
        monster_control SPECIAL, FIRE_BALL, SNOWBALL      ; FORTIS
        monster_control SPECIAL, POISON                   ; ABOLISHER
        monster_control SPECIAL, CYCLONIC, SHIMSHAM       ; AQUILA
        monster_control SPECIAL, PEP_UP, EXPLODER         ; JUNK
        monster_control SPECIAL, RAID                     ; MANDRAKE
        monster_control SPECIAL                           ; 1ST_CLASS
        monster_control SPECIAL, SLOW_2, HASTE2           ; TAP_DANCER
        monster_control DEZONE, DOOM, FLARE               ; NECROMANCR
        monster_control SPECIAL, SPECIAL, SPECIAL         ; BORRAS
        monster_control SPECIAL                           ; MAG_ROADER_4
        monster_control SPECIAL                           ; WILD_RAT
        monster_control SPECIAL                           ; GOLD_BEAR
        monster_control PEARL_LORE                        ; INNOC
        monster_control FIRE, FIRA, FIRAGA                ; TRIXTER
        monster_control SPECIAL                           ; RED_WOLF
        monster_control FLARE, FLARE_STAR, BLASTER        ; DIDALOS
        monster_control SPECIAL                           ; WOOLLY
        monster_control DOOM, DEZONE, ROULETTE            ; VETERAN
        monster_control DOOM, DOOM, DOOM                  ; SKY_BASE
        monster_control SPECIAL, DISCHORD, TEK_LASER      ; IRONHITMAN
        monster_control SPECIAL, PLASMA, BLASTER          ; IO
        monster_control                                   ; PUGS
        monster_control SPECIAL                           ; WHELK
        monster_control SPECIAL                           ; PRESENTER
        monster_control SPECIAL, TEK_LASER                ; MEGA_ARMOR
        monster_control SPECIAL                           ; VARGAS
        monster_control SPECIAL                           ; TUNNELARMR
        monster_control SPECIAL, S_CROSS, N_CROSS         ; PROMETHEUS
        monster_control SPECIAL                           ; GHOSTTRAIN
        monster_control SPECIAL                           ; DADALUMA
        monster_control SPECIAL                           ; SHIVA
        monster_control SPECIAL                           ; IFRIT
        monster_control SPECIAL                           ; NUMBER_024
        monster_control SPECIAL                           ; NUMBER_128
        monster_control SPECIAL                           ; INFERNO
        monster_control SPECIAL                           ; CRANE_1
        monster_control SPECIAL                           ; CRANE_2
        monster_control SPECIAL                           ; UMARO_1
        monster_control SPECIAL                           ; UMARO_2
        monster_control SPECIAL                           ; GUARDIAN_VECTOR
        monster_control SPECIAL, PLASMA                   ; GUARDIAN_BOSS
        monster_control SPECIAL                           ; AIR_FORCE
        monster_control SPECIAL                           ; TRITOCH_INTRO
        monster_control SPECIAL                           ; TRITOCH_MORPH
        monster_control SPECIAL                           ; FLAMEEATER
        monster_control SPECIAL                           ; ATMAWEAPON
        monster_control SPECIAL                           ; NERAPA
        monster_control SPECIAL                           ; SRBEHEMOTH
        monster_control SPECIAL                           ; KEFKA_1
        monster_control SPECIAL                           ; TENTACLE
        monster_control SPECIAL                           ; DULLAHAN
        monster_control SPECIAL                           ; DOOM_GAZE
        monster_control SPECIAL                           ; CHADARNOOK_1
        monster_control SPECIAL                           ; CURLEY
        monster_control SPECIAL                           ; LARRY
        monster_control SPECIAL                           ; MOE
        monster_control SPECIAL                           ; WREXSOUL
        monster_control SPECIAL                           ; HIDON
        monster_control SPECIAL                           ; KATANASOUL
        monster_control THUNDARA, OSMOSE, REFLECT         ; L30_MAGIC
        monster_control SPECIAL                           ; HIDONITE
        monster_control SPECIAL                           ; DOOM
        monster_control SPECIAL                           ; GODDESS
        monster_control SPECIAL                           ; POLTRGEIST
        monster_control SPECIAL                           ; FINAL_KEFKA
        monster_control DRAIN, MUTE, VANISH               ; L40_MAGIC
        monster_control SPECIAL                           ; ULTROS_RIVER
        monster_control SPECIAL                           ; ULTROS_OPERA
        monster_control SPECIAL                           ; ULTROS_MOUNTAIN
        monster_control SPECIAL                           ; CHUPON_AIRSHIP
        monster_control QUARTR, RASP, SAFE                ; L20_MAGIC
        monster_control SPECIAL                           ; SIEGFRIED_2
        monster_control THUNDER, SLOW, HASTE              ; L10_MAGIC
        monster_control BIO, BERSERK, HASTE2              ; L50_MAGIC
        monster_control SPECIAL                           ; HEAD
        monster_control SPECIAL                           ; WHELK_HEAD
        monster_control SPECIAL                           ; COLOSSUS
        monster_control SPECIAL                           ; CZARDRAGON
        monster_control SPECIAL                           ; MASTER_PUG
        monster_control QUAKE, SLOW_2, REGEN              ; L60_MAGIC
        monster_control SPECIAL                           ; MERCHANT
        monster_control SPECIAL                           ; B_DAY_SUIT
        monster_control SPECIAL                           ; TENTACLE_1
        monster_control SPECIAL                           ; TENTACLE_2
        monster_control SPECIAL                           ; TENTACLE_3
        monster_control SPECIAL                           ; RIGHTBLADE
        monster_control SPECIAL                           ; LEFT_BLADE
        monster_control SPECIAL                           ; ROUGH
        monster_control SPECIAL                           ; STRIKER
        monster_control FIRAGA, BLIZZAGA, THUNDAGA        ; L70_MAGIC
        monster_control SPECIAL                           ; TRITOCH_BOSS
        monster_control SPECIAL                           ; LASER_GUN
        monster_control SPECIAL                           ; SPECK
        monster_control SPECIAL                           ; MISSILEBAY
        monster_control SPECIAL                           ; CHADARNOOK_2
        monster_control SPECIAL                           ; ICE_DRAGON
        monster_control SPECIAL                           ; KEFKA_NARSHE
        monster_control SPECIAL                           ; STORM_DRGN
        monster_control SPECIAL                           ; DIRT_DRGN
        monster_control SPECIAL                           ; IPOOH
        monster_control SPECIAL                           ; LEADER
        monster_control SPECIAL                           ; GRUNT
        monster_control SPECIAL                           ; GOLD_DRGN
        monster_control SPECIAL                           ; SKULL_DRGN
        monster_control SPECIAL                           ; BLUE_DRGN
        monster_control SPECIAL                           ; RED_DRAGON
        monster_control SPECIAL                           ; PIRANHA
        monster_control SPECIAL                           ; RIZOPAS
        monster_control SPECIAL                           ; SPECTER
        monster_control SPECIAL                           ; SHORT_ARM
        monster_control SPECIAL                           ; LONG_ARM
        monster_control SPECIAL                           ; FACE
        monster_control SPECIAL                           ; TIGER
        monster_control SPECIAL                           ; TOOLS
        monster_control SPECIAL                           ; MAGIC
        monster_control SPECIAL                           ; HIT
        monster_control SPECIAL                           ; GIRL
        monster_control SPECIAL                           ; SLEEP
        monster_control SPECIAL                           ; HIDONITE_1
        monster_control SPECIAL                           ; HIDONITE_2
        monster_control SPECIAL                           ; HIDONITE_3
        monster_control REFLECT, CURAGA, REMEDY           ; L80_MAGIC
        monster_control METEOR, MELTDOWN, TORNADO         ; L90_MAGIC
        monster_control SPECIAL, TEK_LASER, SCHILLER      ; PROTOARMOR
        monster_control ULTIMA                            ; MAGIMASTER
        monster_control SPECIAL                           ; SOULSAVER
        monster_control SPECIAL                           ; ULTROS_AIRSHIP
        monster_control SPECIAL                           ; NAUGHTY
        monster_control SPECIAL                           ; PHUNBABA_1
        monster_control SPECIAL                           ; PHUNBABA_2
        monster_control SPECIAL                           ; PHUNBABA_3
        monster_control SPECIAL                           ; PHUNBABA_4
        monster_control SPECIAL                           ; TERRA_FLASHBACK
        monster_control SPECIAL                           ; KEFKA_IMP_CAMP
        monster_control SPECIAL                           ; CYAN_IMP_CAMP
        monster_control SPECIAL                           ; ZONE_EATER
        monster_control SPECIAL                           ; GAU_VELDT
        monster_control SPECIAL                           ; KEFKA_VS_LEO
        monster_control SPECIAL                           ; KEFKA_ESPER_GATE
        monster_control SPECIAL                           ; OFFICER
        monster_control SPECIAL                           ; CADET
        monster_control SPECIAL                           ; 0177
        monster_control SPECIAL                           ; 0178
        monster_control SPECIAL                           ; SOLDIER_FLASHBACK
        monster_control SPECIAL                           ; KEFKA_VS_ESPER
        monster_control SPECIAL                           ; EVENT
        monster_control SPECIAL                           ; 017C
        monster_control SPECIAL                           ; ATMA
        monster_control SPECIAL                           ; SHADOW_COLOSSEUM
        monster_control SPECIAL                           ; COLOSSEUM

; ------------------------------------------------------------------------------

.delmac monster_control