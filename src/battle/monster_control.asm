; ------------------------------------------------------------------------------

.mac make_monster_control attack2, attack3, attack4
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

; cf/3d00
MonsterControl:
        make_monster_control                                   ; GUARD
        make_monster_control SCAN                              ; SOLDIER
        make_monster_control SPECIAL                           ; TEMPLAR
        make_monster_control FIRE_SKEAN, WATER_EDGE, BOLT_EDGE ; NINJA
        make_monster_control FLARE, DOOM, HASTE2               ; SAMURAI
        make_monster_control BIO, PEARL                        ; OROG
        make_monster_control SPECIAL                           ; MAG_ROADER_1
        make_monster_control SPECIAL, WIND_SLASH, CONDEMNED    ; RETAINER
        make_monster_control DRAIN, FIRE                       ; HAZER
        make_monster_control MUTE, CURE_2                      ; DAHLING
        make_monster_control SPECIAL, BOLT_3, FLASH_RAIN       ; RAIN_MAN
        make_monster_control SPECIAL                           ; BRAWLER
        make_monster_control SPECIAL, L3_MUDDLE, L4_FLARE      ; APOKRYPHOS
        make_monster_control L5_DOOM, CLEANSWEEP, PEARL_WIND   ; DARK_FORCE
        make_monster_control FIRE, DEMI                        ; WHISPER
        make_monster_control DREAD                             ; OVER_MIND
        make_monster_control SPECIAL                           ; OSTEOSAUR
        make_monster_control FIRE                              ; COMMANDER
        make_monster_control                                   ; RHODOX
        make_monster_control SPECIAL                           ; WERE_RAT
        make_monster_control SPECIAL                           ; URSUS
        make_monster_control MEGA_VOLT                         ; RHINOTAUR
        make_monster_control SPECIAL, BLIZZARD, BLASTER        ; STEROIDITE
        make_monster_control SPECIAL                           ; LEAFER
        make_monster_control SPECIAL                           ; STRAY_CAT
        make_monster_control SPECIAL                           ; LOBO
        make_monster_control SPECIAL                           ; DOBERMAN
        make_monster_control SPECIAL, BLIZZARD                 ; VOMAMMOTH
        make_monster_control SPECIAL                           ; FIDOR
        make_monster_control SPECIAL, BLIZZARD                 ; BASKERVOR
        make_monster_control SPECIAL, AQUA_RAKE                ; SURIANDER
        make_monster_control SPECIAL, AQUA_RAKE, BLIZZARD      ; CHIMERA
        make_monster_control SPECIAL, METEOR, FIRE_3           ; BEHEMOTH
        make_monster_control SPECIAL, STEP_MINE                ; MESOSAUR
        make_monster_control SPECIAL, FIRE_BALL                ; PTERODON
        make_monster_control SPECIAL, SAND_STORM, X_ZONE       ; FOSSILFANG
        make_monster_control PEARL, PEARL, PEARL               ; WHITE_DRGN
        make_monster_control FALLEN_ONE, N_CROSS, S_CROSS      ; DOOM_DRGN
        make_monster_control SPECIAL                           ; BRACHOSAUR
        make_monster_control SPECIAL, SLOW, HASTE              ; TYRANOSAUR
        make_monster_control SPECIAL                           ; DARK_WIND
        make_monster_control SPECIAL                           ; BEAKOR
        make_monster_control SPECIAL, SHIMSHAM                 ; VULTURE
        make_monster_control SPECIAL, CYCLONIC, AERO           ; HARPY
        make_monster_control SPECIAL, NET                      ; HERMITCRAB
        make_monster_control L5_DOOM, L3_MUDDLE, L4_FLARE      ; TRAPPER
        make_monster_control SPECIAL                           ; HORNET
        make_monster_control SPECIAL                           ; CRASSHOPPR
        make_monster_control SPECIAL, MEGA_VOLT                ; DELTA_BUG
        make_monster_control SPECIAL, SHRAPNEL                 ; GILOMANTIS
        make_monster_control SPECIAL                           ; TRILIUM
        make_monster_control SPECIAL, CHARM                    ; NIGHTSHADE
        make_monster_control SPECIAL, LIFESHAVER               ; TUMBLEWEED
        make_monster_control SPECIAL, BIO, DOOM                ; BLOOMPIRE
        make_monster_control SPECIAL, POISON                   ; TRILOBITER
        make_monster_control HYPERDRIVE, SHRAPNEL, BATTLE      ; SIEGFRIED_1
        make_monster_control SPECIAL                           ; NAUTILOID
        make_monster_control SPECIAL                           ; EXOCITE
        make_monster_control SPECIAL, AQUA_RAKE                ; ANGUIFORM
        make_monster_control SPECIAL, SLIMER                   ; REACH_FROG
        make_monster_control BREAK, DISCHORD                   ; LIZARD
        make_monster_control SPECIAL, QUAKE                    ; CHICKENLIP
        make_monster_control SPECIAL, SAND_STORM, QUAKE        ; HOOVER
        make_monster_control SPECIAL, VIRITE                   ; RIDER
        make_monster_control SNEEZE, SNEEZE, SNEEZE            ; CHUPON_COLOSSEUM
        make_monster_control DEMI, QUARTR                      ; PIPSQUEAK
        make_monster_control TEK_LASER                         ; M_TEKARMOR
        make_monster_control SPECIAL, TEK_LASER                ; SKY_ARMOR
        make_monster_control TEK_LASER, FIRE_BALL              ; TELSTAR
        make_monster_control SPECIAL, TEK_LASER, ABSOLUTE0     ; LETHAL_WPN
        make_monster_control SLOW                              ; VAPORITE
        make_monster_control SPECIAL, SLIMER                   ; FLAN
        make_monster_control SPECIAL, LIFESHAVER               ; ING
        make_monster_control SPECIAL, POISON                   ; HUMPTY
        make_monster_control SPECIAL, BLOW_FISH                ; BRAINPAN
        make_monster_control SPECIAL, SLIMER                   ; CRULLER
        make_monster_control SPECIAL, BLOW_FISH                ; CACTROT
        make_monster_control SPECIAL, SPECIAL, SPECIAL         ; REPO_MAN
        make_monster_control SPECIAL, DRAIN                    ; HARVESTER
        make_monster_control EXPLODER, BLAZE                   ; BOMB
        make_monster_control SPECIAL, LULLABY, CONDEMNED       ; STILL_LIFE
        make_monster_control SPECIAL, METEOR, LODE_STONE       ; BOXED_SET
        make_monster_control FIRE_2, ICE_2, BOLT_2             ; SLAMDANCER
        make_monster_control SPECIAL, MAGNITUDE8               ; HADESGIGAS
        make_monster_control SPECIAL, BREAK                    ; PUG
        make_monster_control REMEDY, CURE_3, W_WIND            ; MAGIC_URN
        make_monster_control BIG_GUARD                         ; MOVER
        make_monster_control SPECIAL, DISCHORD, RAID           ; FIGALIZ
        make_monster_control SPECIAL, SURGE                    ; BUFFALAX
        make_monster_control SPECIAL, GIGA_VOLT                ; ASPIK
        make_monster_control FIRE                              ; GHOST
        make_monster_control SPECIAL, STEP_MINE                ; CRAWLER
        make_monster_control SPECIAL                           ; SAND_RAY
        make_monster_control SPECIAL                           ; ARENEID
        make_monster_control SPECIAL                           ; ACTANEON
        make_monster_control SPECIAL, SAND_STORM               ; SAND_HORSE
        make_monster_control SPECIAL, FIRE                     ; DARK_SIDE
        make_monster_control SPECIAL, SOUR_MOUTH               ; MAD_OSCAR
        make_monster_control SPECIAL, MAGNITUDE8               ; CRAWLY
        make_monster_control SPECIAL, DREAD                    ; BLEARY
        make_monster_control SPECIAL, BOLT_2                   ; MARSHAL
        make_monster_control SPECIAL                           ; TROOPER
        make_monster_control SPECIAL, CURE_2                   ; GENERAL
        make_monster_control SPECIAL, WIND_SLASH, RAGE         ; COVERT
        make_monster_control COLD_DUST, PEARL_WIND             ; OGOR
        make_monster_control SPECIAL, PEARL                    ; WARLOCK
        make_monster_control FLARE, PEARL, ICE_3               ; MADAM
        make_monster_control SPECIAL, BOLT_2, ACID_RAIN        ; JOKER
        make_monster_control SPECIAL, STONE                    ; IRON_FIST
        make_monster_control FIRE_3, BOLT_3, ICE_3             ; GOBLIN
        make_monster_control SPECIAL, IMP                      ; APPARITE
        make_monster_control SPECIAL, FLARE                    ; POWERDEMON
        make_monster_control SPECIAL, DOOM, X_ZONE             ; DISPLAYER
        make_monster_control SPECIAL                           ; VECTOR_PUP
        make_monster_control SPECIAL, PEARL_WIND               ; PEEPERS
        make_monster_control SPECIAL                           ; SEWER_RAT
        make_monster_control SPECIAL                           ; SLATTER
        make_monster_control SPECIAL, LIFE_3                   ; RHINOX
        make_monster_control SPECIAL                           ; RHOBITE
        make_monster_control SPECIAL, BLASTER                  ; WILD_CAT
        make_monster_control SPECIAL                           ; RED_FANG
        make_monster_control SPECIAL                           ; BOUNTY_MAN
        make_monster_control SPECIAL                           ; TUSKER
        make_monster_control SPECIAL                           ; RALPH
        make_monster_control SPECIAL                           ; CHITONID
        make_monster_control SPECIAL, EXPLODER                 ; WART_PUCK
        make_monster_control FLARE_STAR, SURGE, AERO           ; RHYOS
        make_monster_control BATTLE, BATTLE, BATTLE            ; SRBEHEMOTH_UNDEAD
        make_monster_control SPECIAL, PEARL_WIND               ; VECTAUR
        make_monster_control SPECIAL, CYCLONIC                 ; WYVERN
        make_monster_control SPECIAL, POISON, BIO              ; ZOMBONE
        make_monster_control SPECIAL, REVENGE, BLIZZARD        ; DRAGON
        make_monster_control SPECIAL, FIRE_3, METEOR           ; BRONTAUR
        make_monster_control SPECIAL, DOOM                     ; ALLOSAURUS
        make_monster_control SPECIAL, BREAK                    ; CIRPIUS
        make_monster_control SPECIAL, CYCLONIC                 ; SPRINTER
        make_monster_control SPECIAL, SHIMSHAM                 ; GOBBLER
        make_monster_control SPECIAL, AERO                     ; HARPIAI
        make_monster_control SPECIAL, NET                      ; GLOOMSHELL
        make_monster_control SPECIAL, MUDDLE                   ; DROP
        make_monster_control SPECIAL, SLEEP                    ; MIND_CANDY
        make_monster_control SPECIAL, BSERK                    ; WEEDFEEDER
        make_monster_control SPECIAL, LAND_SLIDE, CAVE_IN      ; LURIDAN
        make_monster_control SPECIAL, SHRAPNEL                 ; TOE_CUTTER
        make_monster_control SPECIAL, MUDDLE                   ; OVER_GRUNK
        make_monster_control SPECIAL, VIRITE                   ; EXORAY
        make_monster_control SPECIAL, LIFESHAVER               ; CRUSHER
        make_monster_control BIO, QUAKE                        ; UROBUROS
        make_monster_control SPECIAL                           ; PRIMORDITE
        make_monster_control SPECIAL, TEK_LASER                ; SKY_CAP
        make_monster_control SPECIAL, STOP                     ; CEPHALER
        make_monster_control SPECIAL, REMEDY                   ; MALIGA
        make_monster_control SPECIAL, SLIMER                   ; GIGAN_TOAD
        make_monster_control SPECIAL, BREAK, DREAD             ; GECKOREX
        make_monster_control SPECIAL, QUAKE                    ; CLUCK
        make_monster_control SPECIAL, MAGNITUDE8, LODE_STONE   ; LAND_WORM
        make_monster_control SPECIAL, FLASH_RAIN               ; TEST_RIDER
        make_monster_control SPECIAL, TEK_LASER, SHRAPNEL      ; PLUTOARMOR
        make_monster_control SPECIAL, STEP_MINE                ; TOMB_THUMB
        make_monster_control SPECIAL, TEK_LASER                ; HEAVYARMOR
        make_monster_control SPECIAL, PLASMA, DISCHORD         ; CHASER
        make_monster_control SPECIAL, SPECIAL, SPECIAL         ; SCULLION
        make_monster_control SLOW                              ; POPLIUM
        make_monster_control SPECIAL, PEP_UP                   ; INTANGIR
        make_monster_control SPECIAL, LIFESHAVER               ; MISFIT
        make_monster_control SPECIAL, BIO, POISON              ; ELAND
        make_monster_control SPECIAL, CLEANSWEEP, AQUA_RAKE    ; ENUO
        make_monster_control SPECIAL, DREAD                    ; DEEP_EYE
        make_monster_control SPECIAL, STEP_MINE                ; GREASEMONK
        make_monster_control SPECIAL, IMP                      ; NECKHUNTER
        make_monster_control SPECIAL, BLAZE, FIRE_BALL         ; GRENADE
        make_monster_control SPECIAL, CONDEMNED                ; CRITIC
        make_monster_control SPECIAL, REVENGE                  ; PAN_DORA
        make_monster_control DRAIN, OSMOSE, FIRE_2             ; SOULDANCER
        make_monster_control SPECIAL, REVENGE                  ; GIGANTOS
        make_monster_control SPECIAL                           ; MAG_ROADER_2
        make_monster_control SPECIAL, ACID_RAIN                ; SPEK_TOR
        make_monster_control SPECIAL, GIGA_VOLT                ; PARASITE
        make_monster_control SPECIAL, BIG_GUARD                ; EARTHGUARD
        make_monster_control SPECIAL, MAGNITUDE8               ; COELECITE
        make_monster_control BOLT_3, GIGA_VOLT                 ; ANEMONE
        make_monster_control ACID_RAIN, FLASH_RAIN             ; HIPOCAMPUS
        make_monster_control BOLT, FIRE, ICE                   ; SPECTRE
        make_monster_control POISON, SNEEZE, SOUR_MOUTH        ; EVIL_OSCAR
        make_monster_control SPECIAL, MAGNITUDE8, QUAKE        ; SLURM
        make_monster_control SPECIAL, MAGNITUDE8               ; LATIMERIA
        make_monster_control SPECIAL                           ; STILLGOING
        make_monster_control SPECIAL, SPECIAL, SPECIAL         ; ALLO_VER
        make_monster_control SPECIAL, BLOW_FISH                ; PHASE
        make_monster_control SPECIAL, X_ZONE, FLARE            ; OUTSIDER
        make_monster_control SPECIAL, MUDDLE, DISPEL           ; BARB_E
        make_monster_control SPECIAL, FLASH_RAIN, EL_NINO      ; PARASOUL
        make_monster_control POISON, DRAIN, BIO                ; PM_STALKER
        make_monster_control SPECIAL, SHOCK_WAVE, PEARL        ; HEMOPHYTE
        make_monster_control SPECIAL, SAFE                     ; SP_FORCES
        make_monster_control CURE, CURE_2, REMEDY              ; NOHRABBIT
        make_monster_control RASP, DEMI, STOP                  ; WIZARD
        make_monster_control SPECIAL, ELF_FIRE                 ; SCRAPPER
        make_monster_control BOLT_3, GIGA_VOLT                 ; CERITOPS
        make_monster_control SPECIAL, SHELL                    ; COMMANDO
        make_monster_control SPECIAL, SLIDE, SURGE             ; OPINICUS
        make_monster_control BREAK, STONE                      ; POPPERS
        make_monster_control SPECIAL                           ; LUNARIS
        make_monster_control SPECIAL, FIRE_2                   ; GARM
        make_monster_control SPECIAL, ACID_RAIN                ; VINDR
        make_monster_control REMEDY                            ; KIWOK
        make_monster_control SPECIAL                           ; NASTIDON
        make_monster_control SLOW                              ; RINN
        make_monster_control SPECIAL                           ; INSECARE
        make_monster_control SPECIAL, BIO                      ; VERMIN
        make_monster_control SPECIAL, WIND_SLASH               ; MANTODEA
        make_monster_control SPECIAL                           ; BOGY
        make_monster_control SPECIAL, STONE                    ; PRUSSIAN
        make_monster_control SAND_STORM, DOOM, BOLT_2          ; BLACK_DRGN
        make_monster_control SPECIAL, ACID_RAIN                ; ADAMANCHYT
        make_monster_control SPECIAL, L3_MUDDLE, ICE_2         ; DANTE
        make_monster_control SPECIAL, CYCLONIC                 ; WIREY_DRGN
        make_monster_control SPECIAL, MEGA_VOLT, GIGA_VOLT     ; DUELLER
        make_monster_control SPECIAL, LIFESHAVER               ; PSYCHOT
        make_monster_control SPECIAL, PEP_UP                   ; MUUS
        make_monster_control BREAK, BOLT_3, FLARE              ; KARKASS
        make_monster_control                                   ; PUNISHER
        make_monster_control SPECIAL, EXPLODER                 ; BALLOON
        make_monster_control SPECIAL, VANISH                   ; GABBLDEGAK
        make_monster_control SPECIAL, METEOR, FIRE_3           ; GTBEHEMOTH
        make_monster_control SPECIAL                           ; SCORPION
        make_monster_control SPECIAL, DISASTER, METEOR         ; CHAOS_DRGN
        make_monster_control SPECIAL, TEK_LASER, SCHILLER      ; SPIT_FIRE
        make_monster_control GIGA_VOLT, AQUA_RAKE, BLAZE       ; VECTAGOYLE
        make_monster_control FIRE, FIRE_2, FIRE_3              ; LICH
        make_monster_control SPECIAL, SHIMSHAM                 ; OSPREY
        make_monster_control SPECIAL                           ; MAG_ROADER_3
        make_monster_control SPECIAL                           ; BUG
        make_monster_control SPECIAL                           ; SEA_FLOWER
        make_monster_control SPECIAL, FIRE_BALL, SNOWBALL      ; FORTIS
        make_monster_control SPECIAL, POISON                   ; ABOLISHER
        make_monster_control SPECIAL, CYCLONIC, SHIMSHAM       ; AQUILA
        make_monster_control SPECIAL, PEP_UP, EXPLODER         ; JUNK
        make_monster_control SPECIAL, RAID                     ; MANDRAKE
        make_monster_control SPECIAL                           ; 1ST_CLASS
        make_monster_control SPECIAL, SLOW_2, HASTE2           ; TAP_DANCER
        make_monster_control X_ZONE, DOOM, FLARE               ; NECROMANCR
        make_monster_control SPECIAL, SPECIAL, SPECIAL         ; BORRAS
        make_monster_control SPECIAL                           ; MAG_ROADER_4
        make_monster_control SPECIAL                           ; WILD_RAT
        make_monster_control SPECIAL                           ; GOLD_BEAR
        make_monster_control PEARL_LORE                        ; INNOC
        make_monster_control FIRE, FIRE_2, FIRE_3              ; TRIXTER
        make_monster_control SPECIAL                           ; RED_WOLF
        make_monster_control FLARE, FLARE_STAR, BLASTER        ; DIDALOS
        make_monster_control SPECIAL                           ; WOOLLY
        make_monster_control DOOM, X_ZONE, ROULETTE            ; VETERAN
        make_monster_control DOOM, DOOM, DOOM                  ; SKY_BASE
        make_monster_control SPECIAL, DISCHORD, TEK_LASER      ; IRONHITMAN
        make_monster_control SPECIAL, PLASMA, BLASTER          ; IO
        make_monster_control                                   ; PUGS
        make_monster_control SPECIAL                           ; WHELK
        make_monster_control SPECIAL                           ; PRESENTER
        make_monster_control SPECIAL, TEK_LASER                ; MEGA_ARMOR
        make_monster_control SPECIAL                           ; VARGAS
        make_monster_control SPECIAL                           ; TUNNELARMR
        make_monster_control SPECIAL, S_CROSS, N_CROSS         ; PROMETHEUS
        make_monster_control SPECIAL                           ; GHOSTTRAIN
        make_monster_control SPECIAL                           ; DADALUMA
        make_monster_control SPECIAL                           ; SHIVA
        make_monster_control SPECIAL                           ; IFRIT
        make_monster_control SPECIAL                           ; NUMBER_024
        make_monster_control SPECIAL                           ; NUMBER_128
        make_monster_control SPECIAL                           ; INFERNO
        make_monster_control SPECIAL                           ; CRANE_1
        make_monster_control SPECIAL                           ; CRANE_2
        make_monster_control SPECIAL                           ; UMARO_1
        make_monster_control SPECIAL                           ; UMARO_2
        make_monster_control SPECIAL                           ; GUARDIAN_VECTOR
        make_monster_control SPECIAL, PLASMA                   ; GUARDIAN_BOSS
        make_monster_control SPECIAL                           ; AIR_FORCE
        make_monster_control SPECIAL                           ; TRITOCH_INTRO
        make_monster_control SPECIAL                           ; TRITOCH_MORPH
        make_monster_control SPECIAL                           ; FLAMEEATER
        make_monster_control SPECIAL                           ; ATMAWEAPON
        make_monster_control SPECIAL                           ; NERAPA
        make_monster_control SPECIAL                           ; SRBEHEMOTH
        make_monster_control SPECIAL                           ; KEFKA_1
        make_monster_control SPECIAL                           ; TENTACLE
        make_monster_control SPECIAL                           ; DULLAHAN
        make_monster_control SPECIAL                           ; DOOM_GAZE
        make_monster_control SPECIAL                           ; CHADARNOOK_1
        make_monster_control SPECIAL                           ; CURLEY
        make_monster_control SPECIAL                           ; LARRY
        make_monster_control SPECIAL                           ; MOE
        make_monster_control SPECIAL                           ; WREXSOUL
        make_monster_control SPECIAL                           ; HIDON
        make_monster_control SPECIAL                           ; KATANASOUL
        make_monster_control BOLT_2, OSMOSE, RFLECT            ; L30_MAGIC
        make_monster_control SPECIAL                           ; HIDONITE
        make_monster_control SPECIAL                           ; DOOM
        make_monster_control SPECIAL                           ; GODDESS
        make_monster_control SPECIAL                           ; POLTRGEIST
        make_monster_control SPECIAL                           ; FINAL_KEFKA
        make_monster_control DRAIN, MUTE, VANISH               ; L40_MAGIC
        make_monster_control SPECIAL                           ; ULTROS_RIVER
        make_monster_control SPECIAL                           ; ULTROS_OPERA
        make_monster_control SPECIAL                           ; ULTROS_MOUNTAIN
        make_monster_control SPECIAL                           ; CHUPON_AIRSHIP
        make_monster_control QUARTR, RASP, SAFE                ; L20_MAGIC
        make_monster_control SPECIAL                           ; SIEGFRIED_2
        make_monster_control BOLT, SLOW, HASTE                 ; L10_MAGIC
        make_monster_control BIO, BSERK, HASTE2                ; L50_MAGIC
        make_monster_control SPECIAL                           ; HEAD
        make_monster_control SPECIAL                           ; WHELK_HEAD
        make_monster_control SPECIAL                           ; COLOSSUS
        make_monster_control SPECIAL                           ; CZARDRAGON
        make_monster_control SPECIAL                           ; MASTER_PUG
        make_monster_control QUAKE, SLOW_2, REGEN              ; L60_MAGIC
        make_monster_control SPECIAL                           ; MERCHANT
        make_monster_control SPECIAL                           ; B_DAY_SUIT
        make_monster_control SPECIAL                           ; TENTACLE_1
        make_monster_control SPECIAL                           ; TENTACLE_2
        make_monster_control SPECIAL                           ; TENTACLE_3
        make_monster_control SPECIAL                           ; RIGHTBLADE
        make_monster_control SPECIAL                           ; LEFT_BLADE
        make_monster_control SPECIAL                           ; ROUGH
        make_monster_control SPECIAL                           ; STRIKER
        make_monster_control FIRE_3, ICE_3, BOLT_3             ; L70_MAGIC
        make_monster_control SPECIAL                           ; TRITOCH_BOSS
        make_monster_control SPECIAL                           ; LASER_GUN
        make_monster_control SPECIAL                           ; SPECK
        make_monster_control SPECIAL                           ; MISSILEBAY
        make_monster_control SPECIAL                           ; CHADARNOOK_2
        make_monster_control SPECIAL                           ; ICE_DRAGON
        make_monster_control SPECIAL                           ; KEFKA_NARSHE
        make_monster_control SPECIAL                           ; STORM_DRGN
        make_monster_control SPECIAL                           ; DIRT_DRGN
        make_monster_control SPECIAL                           ; IPOOH
        make_monster_control SPECIAL                           ; LEADER
        make_monster_control SPECIAL                           ; GRUNT
        make_monster_control SPECIAL                           ; GOLD_DRGN
        make_monster_control SPECIAL                           ; SKULL_DRGN
        make_monster_control SPECIAL                           ; BLUE_DRGN
        make_monster_control SPECIAL                           ; RED_DRAGON
        make_monster_control SPECIAL                           ; PIRANHA
        make_monster_control SPECIAL                           ; RIZOPAS
        make_monster_control SPECIAL                           ; SPECTER
        make_monster_control SPECIAL                           ; SHORT_ARM
        make_monster_control SPECIAL                           ; LONG_ARM
        make_monster_control SPECIAL                           ; FACE
        make_monster_control SPECIAL                           ; TIGER
        make_monster_control SPECIAL                           ; TOOLS
        make_monster_control SPECIAL                           ; MAGIC
        make_monster_control SPECIAL                           ; HIT
        make_monster_control SPECIAL                           ; GIRL
        make_monster_control SPECIAL                           ; SLEEP
        make_monster_control SPECIAL                           ; HIDONITE_1
        make_monster_control SPECIAL                           ; HIDONITE_2
        make_monster_control SPECIAL                           ; HIDONITE_3
        make_monster_control RFLECT, CURE_3, REMEDY            ; L80_MAGIC
        make_monster_control METEOR, MERTON, W_WIND            ; L90_MAGIC
        make_monster_control SPECIAL, TEK_LASER, SCHILLER      ; PROTOARMOR
        make_monster_control ULTIMA                            ; MAGIMASTER
        make_monster_control SPECIAL                           ; SOULSAVER
        make_monster_control SPECIAL                           ; ULTROS_AIRSHIP
        make_monster_control SPECIAL                           ; NAUGHTY
        make_monster_control SPECIAL                           ; PHUNBABA_1
        make_monster_control SPECIAL                           ; PHUNBABA_2
        make_monster_control SPECIAL                           ; PHUNBABA_3
        make_monster_control SPECIAL                           ; PHUNBABA_4
        make_monster_control SPECIAL                           ; TERRA_FLASHBACK
        make_monster_control SPECIAL                           ; KEFKA_IMP_CAMP
        make_monster_control SPECIAL                           ; CYAN_IMP_CAMP
        make_monster_control SPECIAL                           ; ZONE_EATER
        make_monster_control SPECIAL                           ; GAU_VELDT
        make_monster_control SPECIAL                           ; KEFKA_VS_LEO
        make_monster_control SPECIAL                           ; KEFKA_ESPER_GATE
        make_monster_control SPECIAL                           ; OFFICER
        make_monster_control SPECIAL                           ; CADET
        make_monster_control SPECIAL                           ; 0177
        make_monster_control SPECIAL                           ; 0178
        make_monster_control SPECIAL                           ; SOLDIER_FLASHBACK
        make_monster_control SPECIAL                           ; KEFKA_VS_ESPER
        make_monster_control SPECIAL                           ; EVENT
        make_monster_control SPECIAL                           ; 017C
        make_monster_control SPECIAL                           ; ATMA
        make_monster_control SPECIAL                           ; SHADOW_COLOSSEUM
        make_monster_control SPECIAL                           ; COLOSSEUM

; ------------------------------------------------------------------------------
