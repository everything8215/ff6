; ------------------------------------------------------------------------------

.mac ai_script monster_name
        array_label AI_SCRIPT, MONSTER::monster_name
.endmac

; ------------------------------------------------------------------------------

.segment "ai_script"

.scope AI_SCRIPT
        COUNT = 384
        BASE_PTR = AIScript
.endscope

; cf/8400
AIScriptPtrs:
        ptr_tbl AI_SCRIPT

; ------------------------------------------------------------------------------

; cf/8700
AIScript:

.if LANG_EN
        fixed_block $3950
.else
        fixed_block $4100
.endif

; ------------------------------------------------------------------------------

ai_script GUARD
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script LOBO
        if_level_greater RAND_CHAR, 7
                attack BATTLE, SPECIAL, NOTHING
                attack SPECIAL, NOTHING, NOTHING
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script VOMAMMOTH
        if_level_greater RAND_CHAR, 5
                set_target ALL_CHARS
                attack SNOWSTORM
                wait
                attack BATTLE, NOTHING, SPECIAL
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script WERE_RAT
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script VAPORITE
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script REPO_MAN
        attack BATTLE, BATTLE, SPECIAL
        wait
        end

        if_hit
                set_target SELF
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script MARSHAL
        if_num_monsters 1
                attack BATTLE, SPECIAL, SPECIAL
                end_if
        set_target RAND_CHAR
        attack BATTLE, NET, BATTLE
        wait
        attack BATTLE
        wait
        attack NET, NET, BATTLE
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script LEAFER
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script DARK_WIND
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SAND_RAY
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ARENEID
        if_level_greater TERRA, 7
                attack BATTLE, SPECIAL, NOTHING
                wait
                attack BATTLE
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HORNET
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CRAWLY
        attack BATTLE, BATTLE, NOTHING
        wait
        attack SPECIAL, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BLEARY
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RHODOX
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RHINOTAUR
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd MAGIC
                attack MEGA_VOLT, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script GREASEMONK
        if_num_monsters 1
                attack BATTLE, SPECIAL, SPECIAL
                end_if
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BRAWLER
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TRILIUM
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TUSKER
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script CIRPIUS
        if_num_monsters 1
                attack BATTLE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PTERODON
        if_battle_var_greater 0, 3
                set_battle_var 0, 0
                set_target BANON
                attack BATTLE, BATTLE, NOTHING
                end_if
        attack BATTLE
        add_battle_var 0, 1
        wait
        attack BATTLE, BATTLE, SPECIAL
        add_battle_var 0, 1
        wait
        attack BATTLE, BATTLE, FIRE_BALL
        add_battle_var 0, 1
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script NAUTILOID
        if_battle_var_greater 0, 3
                set_battle_var 0, 0
                set_target BANON
                attack BATTLE
                end_if
        attack BATTLE, BATTLE, SPECIAL
        add_battle_var 0, 1
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script EXOCITE
        if_battle_var_greater 0, 3
                set_battle_var 0, 0
                set_target BANON
                attack BATTLE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        add_battle_var 0, 1
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HEAVYARMOR
        if_battle_switch_clr 0, 0
        if_target_valid CELES
                set_battle_switch 0, 0
                set_target SELF
                attack TEKBARRIER
                end_if
        if_num_chars 4
                attack BATTLE, TEK_LASER, SPECIAL
                wait
                attack BATTLE, BATTLE, MISSILE
                end_if
        attack BATTLE
        wait
        attack BATTLE, TEK_LASER, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script COMMANDER
        if_num_monsters 1
                attack SPECIAL
                attack BATTLE, BATTLE, NOTHING
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script VECTOR_PUP
        if_num_monsters 1
                set_target SELF
                attack ESCAPE
                end_if
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TRILOBITER
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PRIMORDITE
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GOLD_BEAR
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script DARK_SIDE
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SPECTRE
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack FIRE, BLIZZARD, THUNDER
        wait
        attack SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RINN
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script FIRST_CLASS
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script WILD_RAT
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script STRAY_CAT
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BEAKOR
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack BATTLE, NOTHING, NOTHING
                end_if
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script CRASSHOPPR
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RHOBITE
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SOLDIER
        attack BATTLE
        end

        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TEMPLAR
        attack BATTLE
        end

        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script DOBERMAN
        if_num_monsters 1
                set_target SELF
                attack ESCAPE
                end_if
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, SPECIAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script M_TEKARMOR
        attack SPECIAL, SPECIAL, TEK_LASER
        end

        if_battle_switch_set 12, 1
        if_cmd MAGIC
        if_battle_switch_clr 9, 1
                toggle_battle_switch 9, 1
                battle_event TERRA_MAGIC
                end_retal

; ------------------------------------------------------------------------------

ai_script TELSTAR
        if_monster_timer 200
        if_battle_switch_clr 0, 0
                set_battle_switch 0, 0
                sfx 48, 241
                dlg $44
; Alarm’s ringing!
                restore_monsters {MONSTER_3, MONSTER_4, MONSTER_5, MONSTER_6}, SIDE
                reset_monster_timer
                end_if
        if_monster_timer 80
        if_battle_switch_clr 0, 1
                set_battle_switch 0, 1
                sfx 48, 241
                dlg $44
; Alarm’s ringing!
                restore_monsters {MONSTER_3, MONSTER_4, MONSTER_5}, SIDE
                end_if
        if_monster_timer 25
        if_battle_switch_clr 0, 2
                set_battle_switch 0, 2
                sfx 48, 241
                dlg $44
; Alarm’s ringing!
                restore_monsters {MONSTER_3, MONSTER_4}, SIDE
                end_if
        if_battle_var_greater 3, 3
                attack DISCHORD
                set_battle_var 3, 0
                end_if
        attack BATTLE, BATTLE, SCHILLER
        wait
        attack BATTLE, SPECIAL, TEK_LASER
        wait
        attack BATTLE, BATTLE, MISSILE
        wait
        add_battle_var 3, 1
        end

        if_cmd BLITZ
                attack MEGAZERK
                end_retal

; ------------------------------------------------------------------------------

ai_script GHOST
        attack FIRE, FIRE, NOTHING
        wait
        attack BATTLE, SPECIAL, FIRE_WALL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script POPLIUM
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HAZER
        attack DRAIN, NOTHING, NOTHING
        wait
        attack SPECIAL, DRAIN, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script WHISPER
        set_target RAND_CHAR
        attack DEMI, BATTLE, NOTHING
        wait
        attack BATTLE, DEMI, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script OVER_MIND
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        wait
        attack DREAD, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BOMB
        attack BLAZE, NOTHING, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack EXPLODER, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script STILLGOING
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ANGUIFORM
        if_num_monsters 1
                attack BATTLE, BATTLE, AQUA_RAKE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ASPIK
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd FIGHT
                attack BATTLE, NOTHING, NOTHING
                end_if
        if_hit
                attack GIGA_VOLT, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script ACTANEON
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script FIDOR
        if_num_monsters 1
                attack SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RIDER
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, VIRITE
        end

        if_cmd STEAL, CAPTURE
                set_target PREV_ATTACKER
                attack SPECIAL
                end_if
        if_cmd FIGHT
                attack R_POLARITY, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TROOPER
        attack BATTLE
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script BOUNTY_MAN
        if_num_monsters 1
                set_target SELF
                attack ESCAPE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RED_FANG
        if_num_monsters 1
                attack SPECIAL, BATTLE, BATTLE
                end_if
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script VULTURE
        if_num_monsters 1
                attack SPECIAL, SHIMSHAM, SHIMSHAM
                end_if
        attack BATTLE, SHIMSHAM, BATTLE
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script IRON_FIST
        if_num_monsters 1
                attack BATTLE, STONE, STONE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MIND_CANDY
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_num_monsters 1
        if_cmd STEAL, CAPTURE
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script OVER_GRUNK
        if_num_monsters 1
                attack BATTLE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script FOSSILFANG
        attack BATTLE, SAND_STORM, SPECIAL
        end

        if_cmd FIGHT
                attack SAND_STORM, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script HARVESTER
        attack BATTLE, BATTLE, SPECIAL
        wait
        use_item POTION
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        throw_item MITHRILKNIFE
        end

        if_cmd STEAL, CAPTURE
                cmd STEAL, STEAL, CAPTURE
                end_retal

; ------------------------------------------------------------------------------

ai_script SLAMDANCER
        if_one_monster_type
                attack FIRA, BLIZZARA, THUNDARA
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HADESGIGAS
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                set_target ALL_CHARS
                attack MAGNITUDE8, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script GABBLDEGAK
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, VANISH
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SEWER_RAT
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_one_monster_type
        if_cmd MAGIC
                set_target SELF
                attack ESCAPE
                end_retal

; ------------------------------------------------------------------------------

ai_script VERMIN
        if_one_monster_type
        if_battle_id 112
        if_one_monster_type
                restore_monsters {MONSTER_4, MONSTER_5}, SIDE
                end_if
        if_battle_id 113
        if_one_monster_type
                restore_monsters {MONSTER_2, MONSTER_4, MONSTER_5}, SIDE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GRENADE
        attack BLAZE, NOTHING, SPECIAL
        wait
        attack BLAZE, FIRE_BALL, NOTHING
        wait
        attack BLAZE, FIRE_BALL, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack EXPLODER, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script WYVERN
        if_num_monsters 1
                attack BATTLE, BATTLE, CYCLONIC
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script JOKER
        if_num_monsters 1
                attack BATTLE, THUNDARA, THUNDARA
                end_if
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, ACID_RAIN, NOTHING
        wait
        attack BATTLE, ACID_RAIN, ACID_RAIN
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RALPH
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CHICKENLIP
        if_num_monsters 1
                attack BATTLE, BATTLE, QUAKE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script WEEDFEEDER
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BUG
        attack BATTLE
        end

        if_num_monsters 1
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script PIPSQUEAK
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack EXPLODER, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script COMMANDO
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GARM
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PROTOARMOR
        if_num_monsters 1
                attack LAUNCHER, SCHILLER, TEK_LASER
                end_if
        attack TEK_LASER, TEK_LASER, SPECIAL
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack LAUNCHER, SCHILLER, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script FLAN
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, SLIMER
        end

        if_self_dead
        if_battle_id 356
        if_self_in_slot MONSTER_1
                hide_monsters MONSTER_1, FADE_DOWN
                restore_monsters {MONSTER_2, MONSTER_6}, TOP
                kill_monsters MONSTER_1, INSTANT
                end_if
        if_self_dead
        if_battle_id 356
        if_self_in_slot MONSTER_2
        if_num_monsters 0
                hide_monsters MONSTER_2, FADE_DOWN
                restore_monsters {MONSTER_3, MONSTER_4, MONSTER_5}, TOP
                kill_monsters MONSTER_2, INSTANT
                end_if
        if_self_dead
        if_battle_id 356
        if_self_in_slot MONSTER_6
        if_num_monsters 0
                hide_monsters MONSTER_6, FADE_DOWN
                restore_monsters {MONSTER_3, MONSTER_4, MONSTER_5}, TOP
                kill_monsters MONSTER_6, INSTANT
                end_retal

; ------------------------------------------------------------------------------

ai_script GENERAL
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, CURA
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RHINOX
        if_one_monster_type
                attack BATTLE, BATTLE, RERAISE
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GOBBLER
        if_num_monsters 1
                attack SHIMSHAM
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CHASER
        if_battle_id 123
        if_num_monsters 1
                set_battle_var 0, 0
                sfx 48, 241
                restore_monsters MONSTER_3, TOP
                restore_monsters MONSTER_4, TOP
                restore_monsters MONSTER_5, TOP
                end_if
        set_target SELF
        attack SPECIAL, NOTHING, NOTHING
        wait
        attack BATTLE, BATTLE, PLASMA
        wait
        attack BATTLE, BATTLE, DISCHORD
        wait
        attack BATTLE, BATTLE, TEK_LASER
        end

        if_battle_id 122
        if_self_dead
                kill_monsters_wait MONSTER_1, FADE_HORIZONTAL
                sfx 48, 241
                restore_monsters MONSTER_5, TOP
                restore_monsters MONSTER_4, TOP
                restore_monsters MONSTER_3, TOP
                kill_monsters MONSTER_1, INSTANT
                end_if
        if_cmd BUSHIDO, BLITZ
                set_battle_switch 0, 0
                end_retal

; ------------------------------------------------------------------------------

ai_script TRAPPER
        attack SPECIAL, L5_DOOM, NOTHING
        wait
        attack SPECIAL, L4_FLARE, NOTHING
        wait
        attack SPECIAL, L3_CONFUSE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MAG_ROADER_1
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack FIRE, FIRA, FIRA
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MAG_ROADER_2
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BLIZZARD, BLIZZARA, BLIZZARA
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MEGA_ARMOR
        attack SPECIAL, SPECIAL, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack TEK_LASER, TEK_LASER, NOTHING
                end_if
        if_cmd MAGIC
                attack MISSILE, MISSILE, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script SP_FORCES
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CEPHALER
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack TENTACLE, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BASKERVOR
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_num_monsters 1
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script CHIMERA
        if_num_monsters 1
                attack BATTLE, BATTLE, SNOWSTORM
                wait
                attack BATTLE, BATTLE, FIRE_BALL
                wait
                attack BATTLE, BATTLE, CYCLONIC
                end_if
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, AQUA_RAKE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BALLOON
        attack NOTHING, BATTLE, BATTLE
        wait
        attack NOTHING, BATTLE, BATTLE
        wait
        attack NOTHING, NOTHING, EXPLODER
        end

        if_self_dead
                end_if
        if_element FIRE
                attack EXPLODER, SPECIAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script SLURM
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script INSECARE
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ADAMANCHYT
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd FIGHT
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script ABOLISHER
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack WHITE_WIND
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MANDRAKE
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_hit
                attack RAID, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script COELECITE
        if_num_monsters 1
                attack BATTLE
                end_if
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_num_monsters 1
        if_self_dead
                attack MAGNITUDE8, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script ING
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, LIFESHAVER
        end

        if_self_dead
                end_if
        if_cmd FIGHT
        if_num_monsters 1
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script APPARITE
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_hit
                attack IMP_SONG, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script ZOMBONE
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script LICH
        if_num_monsters 1
                attack FIRAGA, FIRAGA, NOTHING
                end_if
        attack FIRE, FIRE, SPECIAL
        wait
        attack FIRE, FIRA, FIRA
        wait
        attack FIRE, FIRA, FIRA
        wait
        attack FIRE, FIRE, SPECIAL
        wait
        attack FIRE, FIRA, FIRAGA
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SKY_ARMOR
        if_num_monsters 1
                attack SPECIAL, TEK_LASER, MISSILE
                end_if
        attack TEK_LASER, TEK_LASER, NOTHING
        wait
        attack TEK_LASER, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SPIT_FIRE
        if_num_monsters 1
                attack DIFFUSER, NOTHING, NOTHING
                end_if
        attack ABSOLUTE0, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BEHEMOTH
        attack BATTLE, SPECIAL, NOTHING
        end

        if_cmd SUMMON
                attack METEO, METEO, NOTHING
                end_if
        if_num_monsters 1
        if_hit
                attack SPECIAL, SPECIAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script APOKRYPHOS
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_num_monsters 1
        if_hit
                attack L5_DOOM, L4_FLARE, L3_CONFUSE
                end_retal

; ------------------------------------------------------------------------------

ai_script NINJA
        attack FIRE_SKEAN, WATER_EDGE, BATTLE
        wait
        attack FIRE_SKEAN, BATTLE, BOLT_EDGE
        wait
        attack BATTLE, WATER_EDGE, BOLT_EDGE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                set_target SELF
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script BRAINPAN
        if_num_monsters 1
                attack BATTLE, BATTLE, BLOW_FISH
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MISFIT
        attack BATTLE, BATTLE, LIFESHAVER
        wait
        attack BATTLE, LIFESHAVER, LIFESHAVER
        wait
        attack SPECIAL, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script WIREY_DRGN
        if_num_monsters 1
                attack BATTLE, BATTLE, CYCLONIC
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script DRAGON
        attack BATTLE, BATTLE, REVENGE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, SNOWSTORM
        wait
        attack BATTLE, BATTLE, COLD_DUST
        end

        if_self_dead
                end_if
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script GIGANTOS
        attack SPECIAL
        attack SPECIAL
        attack SPECIAL
        wait
        attack BATTLE
        end

        if_self_dead
                end_if
        if_hit
                attack BATTLE
                attack BATTLE
                attack SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script PEEPERS
        attack BATTLE, WHITE_WIND, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script EARTHGUARD
        attack SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BLACK_DRGN
        attack BATTLE, BATTLE, SAND_STORM
        wait
        attack BATTLE, SPECIAL, SAND_STORM
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MESOSAUR
        if_num_monsters 1
                attack BATTLE, SPECIAL, SPECIAL
                end_if
        set_target SELF
        attack ESCAPE, ESCAPE, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script GILOMANTIS
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script CHITONID
        attack BATTLE, BATTLE, SPECIAL
        end

        if_num_monsters 1
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script GIGAN_TOAD
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SLIMER
        wait
        attack BATTLE, BATTLE, RIPPLER
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script LUNARIS
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script OSPREY
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack SHIMSHAM, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script HERMITCRAB
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE, BATTLE, NET
        end

        if_num_monsters 1
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script INTANGIR
        if_hp SELF, 1280
                set_target SELF
                attack ESCAPE
                end_if
        if_monster_switch_set 0
                attack METEO
                set_target SELF
                attack SPECIAL
                clr_monster_switch 0
                end_if
        end

        if_self_dead
                attack METEO
                end_if
        if_hit
                set_monster_switch 0
                end_retal

; ------------------------------------------------------------------------------

ai_script SCORPION
        attack SPECIAL
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PM_STALKER
        attack BATTLE, BATTLE, DRAIN
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack DRAIN, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script DELTA_BUG
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, MEGA_VOLT
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script LIZARD
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BLOOMPIRE
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BIO, BIO, BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BUFFALAX
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack SPECIAL
        attack BATTLE
        attack BATTLE
        end

        if_cmd MAGIC
                attack SUN_BATH, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script CACTROT
        dlg $86
; Bundling up something
        wait
        attack BLOW_FISH
        wait
        dlg $86
; Bundling up something
        wait
        attack BLOW_FISH
        wait
        dlg $86
; Bundling up something
        wait
        attack BLOW_FISH
        wait
        dlg $87
; Work load up 10 times!
        wait
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        attack BLOW_FISH
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script NOHRABBIT
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        if_cmd FIGHT
                set_target RAND_CHAR
                attack CURE, CURA, REMEDY
                end_retal

; ------------------------------------------------------------------------------

ai_script LATIMERIA
        attack MAGNITUDE8, NOTHING, NOTHING
        wait
        attack SPECIAL, MAGNITUDE8, MAGNITUDE8
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MALIGA
        if_num_monsters 1
                attack SPECIAL, SPECIAL, NOTHING
                attack SPECIAL, SPECIAL, NOTHING
                end_if
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SAND_HORSE
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack SAND_STORM, SAND_STORM, NOTHING
        wait
        attack SPECIAL, SAND_STORM, SAND_STORM
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HUMPTY
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CRULLER
        attack FIRA, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SLIMER
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script DANTE
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack L3_CONFUSE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script DROP
        attack SPECIAL, SPECIAL, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script NECKHUNTER
        attack SPECIAL, BATTLE, NOTHING
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HARPIAI
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, AERO
        wait
        attack BATTLE, BATTLE, WHITE_WIND
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MUUS
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE, SPECIAL, PEP_UP
        end

        if_self_dead
                end_if
        if_num_monsters 1
        if_cmd MAGIC
                attack BATTLE, NOTHING, NOTHING
                end_if
        if_cmd MAGIC
                attack PEP_UP, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script BOGY
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script DEEP_EYE
        attack BATTLE, BATTLE, SPECIAL
        wait
        set_target SELF
        attack NOTHING, NOTHING, ESCAPE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HOOVER
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, SNEEZE
        end

        if_self_dead
                end_if
        if_hit
                attack SAND_STORM, SAND_STORM, NOTHING
                attack SAND_STORM, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script OROG
        attack SPECIAL, SPECIAL, NOTHING
        attack SPECIAL, NOTHING, NOTHING
        attack SPECIAL, NOTHING, NOTHING
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack BIO, NOTHING, NOTHING
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script OSTEOSAUR
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, CHOKESMOKE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MAD_OSCAR
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SOUR_MOUTH
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script POWERDEMON
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, SOUL_OUT
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script EXORAY
        if_num_monsters 1
                attack BATTLE, BATTLE, VIRITE
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SIEGFRIED_1
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CHUPON_COLOSSEUM
        attack SNEEZE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PUG
        attack STEP_MINE
        end

        if_hit
                attack SPECIAL
                attack STEP_MINE
                end_retal

; ------------------------------------------------------------------------------

ai_script KIWOK
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script POPPERS
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, STONE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TOMB_THUMB
        if_num_monsters 1
                attack IMP_SONG
                end_if
        attack BATTLE, BATTLE, NOTHING
        set_target SELF
        attack SPECIAL, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CERITOPS
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ANEMONE
        if_num_monsters 1
                attack GIGA_VOLT
                end_if
        attack SPECIAL, NOTHING, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                set_target SELF
                attack MEGA_VOLT
                end_retal

; ------------------------------------------------------------------------------

ai_script PUNISHER
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack SPECIAL
        attack BATTLE, BATTLE, NOTHING
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_cmd STEAL
                cmd STEAL, STEAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script URSUS
        cmd STEAL, STEAL, NOTHING
        wait
        set_target SELF
        attack ESCAPE
        end

        if_self_dead
                end_if
        if_hit
                cmd STEAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script LURIDAN
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, HARVESTER
        wait
        attack BATTLE, BATTLE, KITTY
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BORRAS
        attack BATTLE, BATTLE, NOTHING
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SCRAPPER
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_hit
                attack BATTLE, SPECIAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TOE_CUTTER
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script RHYOS
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack SPECIAL
        attack SNOWSTORM, FIRE_BALL, GIGA_VOLT
        attack MAGNITUDE8, AQUA_RAKE, GIGA_VOLT
        attack MAGNITUDE8, SNOWSTORM, FIRE_BALL
        end

        if_self_dead
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script RED_WOLF
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TEST_RIDER
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd STEAL, CAPTURE
                set_target PREV_ATTACKER
                attack SPECIAL
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script WIZARD
        attack MUTE, OSMOSE, NOTHING
        wait
        attack RASP, STOP, NOTHING
        wait
        attack CONFUSE, SLEEP, NOTHING
        end

        if_cmd MAGIC
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script NASTIDON
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PSYCHOT
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MAG_ROADER_3
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BLIZZARD, BLIZZARA, BLIZZARA
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MAG_ROADER_4
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack FIRE, FIRA, FIRA
        end

; *** bug *** missing end_retal
        set_ai_script_mode NORMAL

; ------------------------------------------------------------------------------

ai_script WILD_CAT
        if_num_monsters 1
                attack FIRE_BALL, NOTHING, NOTHING
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CRUSHER
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_num_monsters 1
        if_hit
                attack LIFESHAVER, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script VINDR
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SOULDANCER
        throw_item DIRK, MITHRILKNIFE
        wait
        throw_item MITHRILKNIFE, MAIN_GAUCHE
        wait
        throw_item AIR_LANCET, THIEFKNIFE
        wait
        throw_item THIEFKNIFE, ASSASSIN
        end

        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script DAHLING
        attack SPECIAL, MUTE, NOTHING
        wait
        attack BLIZZARA, THUNDARA, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack CURA, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script NIGHTSHADE
        attack BATTLE, BATTLE, CHARM
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script STILL_LIFE
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, LULLABY
        end

        if_self_dead
                end_if
        if_hit
                set_target NOTHING
                attack CONDEMNED
                end_retal

; ------------------------------------------------------------------------------

ai_script SLATTER
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HIPOCAMPUS
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack ACID_RAIN, NOTHING, NOTHING
                end_if
        if_hit
                attack FLASH_RAIN, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script WARLOCK
        if_num_monsters 1
                attack HOLY
                end_if
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack SPECIAL, SPECIAL, HOLY
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script DISPLAYER
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, CHOKESMOKE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CLUCK
        if_num_monsters 1
                attack BATTLE, BATTLE, QUAKE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ELAND
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script OPINICUS
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack SPECIAL
        attack BATTLE
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack WIND_SLASH, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script GOBLIN
        if_num_monsters 1
                attack L5_DOOM, L4_FLARE, L3_CONFUSE
                wait
                attack BLAZE, NOTHING, NOTHING
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script LETHAL_WPN
        if_num_monsters 1
                attack DIFFUSER, LAUNCHER, MISSILE
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BOXED_SET
        if_num_monsters 1
                attack BATTLE, METEO, COLD_DUST
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ENUO
        if_num_monsters 1
                attack CLEANSWEEP, AQUA_RAKE, SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script FIGALIZ
        if_num_monsters 1
                attack DISCHORD, RAID, SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SAMURAI
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RAIN_MAN
        if_num_monsters 1
                attack BATTLE, THUNDAGA, THUNDAGA
                end_if
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, FLASH_RAIN, FLASH_RAIN
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SURIANDER
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script ALLOSAURUS
        attack SPECIAL, NOTHING, VIRITE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PARASITE
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack GIGA_VOLT, GIGA_VOLT, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script PAN_DORA
        attack REVENGE, EVIL_TOOT, NOTHING
        wait
        attack REVENGE, ABSOLUTE0, NOTHING
        wait
        attack EVIL_TOOT, ABSOLUTE0, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script BARB_E
        set_target RAND_CHAR
        attack IMP
        wait
        attack DRAIN, LOVE_TOKEN, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack SPECIAL, SPECIAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script CRITIC
        attack BATTLE, ROULETTE, SPECIAL
        wait
        attack BATTLE, PEARL_LORE, LULLABY
        wait
        attack BATTLE, BATTLE, CONDEMNED
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SKY_CAP
        if_num_monsters 1
                attack SPECIAL, TEK_LASER, MISSILE
                end_if
        attack TEK_LASER, TEK_LASER, R_POLARITY
        wait
        attack TEK_LASER, R_POLARITY, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script PLUTOARMOR
        if_num_monsters 1
                attack LAUNCHER, SHRAPNEL, TEK_LASER
                end_if
        attack TEK_LASER, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack LAUNCHER, SHRAPNEL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script IO
        attack SPECIAL, NOTHING, NOTHING
        wait
        attack SPECIAL, NOTHING, NOTHING
        wait
        attack SPECIAL, NOTHING, NOTHING
        wait
        attack WAVECANNON, WAVECANNON, DIFFUSER
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TYRANOSAUR
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, METEOR
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script BRACHOSAUR
        attack BATTLE, BATTLE, DISASTER
        wait
        attack BATTLE, BATTLE, METEOR
        wait
        attack BATTLE, BATTLE, SNEEZE
        wait
        attack BATTLE, BATTLE, ULTIMA
        wait
        attack SPECIAL
        attack BATTLE, BATTLE, NOTHING
        attack BATTLE, BATTLE, NOTHING
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script REACH_FROG
        attack BATTLE, BATTLE, SPECIAL
        wait
        cmd JUMP
        wait
        attack BATTLE, BATTLE, RIPPLER
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CRAWLER
        if_num_monsters 1
                attack DISCHORD, RAID, SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TUMBLEWEED
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_num_monsters 1
        if_hit
                attack LIFESHAVER, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script MANTODEA
        attack BATTLE, BATTLE, NOTHING
        wait
        attack SPECIAL, BATTLE, BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GECKOREX
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SPRINTER
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, WHITE_WIND
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SPEK_TOR
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script HARPY
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, AERO
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack BATTLE, CYCLONIC, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script PRUSSIAN
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GLOOMSHELL
        attack BATTLE
        wait
        attack BATTLE, BATTLE, NET
        end

        if_self_dead
                end_if
        if_num_monsters 1
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script PHASE
        if_num_monsters 1
                attack BATTLE, BATTLE, BLOW_FISH
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_hit
                attack BLOW_FISH, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script PARASOUL
        if_num_monsters 1
                attack BATTLE, EL_NINO, EL_NINO
                end_if
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, FLASH_RAIN, FLASH_RAIN
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script CHAOS_DRGN
        wait
        attack DISASTER, NOTHING, NOTHING
        wait
        wait
        wait
        wait
        attack SPECIAL, NOTHING, NOTHING
        wait
        wait
        wait
        wait
        wait
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SEA_FLOWER
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script AQUILA
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, CYCLONIC
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack SHIMSHAM, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script NECROMANCR
        if_num_monsters 1
                attack DOOM, DEZONE, FLARE
                end_if
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        if_cmd FIGHT
                end_if
        if_hit
                attack DEMI, QUARTR, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TRIXTER
        if_status_set ALL_MONSTERS, REFLECT
                attack FIRE, FIRA, FIRAGA
                end_if
        if_status_set ALL_CHARS, REFLECT
                attack CURA, REFLECT, HASTE
                end_if
        attack FIRA, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script WHITE_DRGN
        attack HOLY, HOLY, NOTHING
        attack HOLY, HOLY, NOTHING
        attack HOLY, NOTHING, NOTHING
        wait
        end

        if_self_dead
                boss_death
                end_if
        if_cmd MAGIC
                set_target ALL_CHARS
                attack DISPEL, DISPEL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script UROBUROS
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BIO, BIO, BATTLE
        wait
        attack BATTLE, NOTHING, NOTHING
        wait
        attack SPECIAL, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script COVERT
        attack BATTLE, BATTLE, WIND_SLASH
        wait
        attack FIRE_SKEAN, WATER_EDGE, BOLT_EDGE
        end

        if_cmd THROW
                throw_item SHURIKEN, NINJA_STAR
                end_if
        if_cmd FIGHT
                set_target SELF
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script WART_PUCK
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script WOOLLY
        attack SPECIAL, NOTHING, NOTHING
        end

        if_cmd FIGHT
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script KARKASS
        attack SPECIAL, NOTHING, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack BATTLE, NOTHING, NOTHING
                end_if
        if_cmd MAGIC
                attack THUNDAGA, BREAK, FLARE
                end_if
        if_hit
                attack LIFESHAVER
                end_retal

; ------------------------------------------------------------------------------

ai_script TAP_DANCER
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd THROW
                throw_item ENHANCER, CRYSTAL
                end_retal

; ------------------------------------------------------------------------------

ai_script OGOR
        attack SPECIAL, SPECIAL, NOTHING
        attack SPECIAL, NOTHING, NOTHING
        attack SPECIAL, NOTHING, NOTHING
        end

        if_cmd MAGIC
                attack BIO, NOTHING, NOTHING
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script MAGIC_URN
        if_status_set ALL_CHARS, DEAD
                attack RAISE, RAISE, ARISE
                set_target SELF
                attack ESCAPE, NOTHING, NOTHING
                end_if
        if_status_set ALL_CHARS, PETRIFY
                use_item SOFT
                set_target SELF
                attack ESCAPE, NOTHING, NOTHING
                end_if
        set_target RAND_CHAR
        use_item REMEDY, TINCTURE
        set_target SELF
        attack ESCAPE, NOTHING, NOTHING
        wait
        set_target RAND_CHAR
        use_item POTION, ELIXIR
        set_target SELF
        attack ESCAPE, NOTHING, NOTHING
        wait
        set_target RAND_CHAR
        use_item TINCTURE, ETHER
        set_target SELF
        attack ESCAPE, NOTHING, NOTHING
        end

        if_hit
                set_target SELF
                attack ESCAPE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script L10_MAGIC
        attack FIRE, BLIZZARD, THUNDER
        end

        if_self_dead
                end_if
        if_hit
                attack SLOW, STOP, HASTE
                end_retal

; ------------------------------------------------------------------------------

ai_script L20_MAGIC
        attack DEMI, QUARTR, BREAK
        wait
        attack DEMI, QUARTR, DEZONE
        end

        if_self_dead
                end_if
        if_hit
                attack RASP, CONFUSE, SAFE
                end_retal

; ------------------------------------------------------------------------------

ai_script L30_MAGIC
        attack FIRA, BLIZZARA, THUNDARA
        end

        if_self_dead
                end_if
        if_hit
                attack IMP, OSMOSE, REFLECT
                end_retal

; ------------------------------------------------------------------------------

ai_script L40_MAGIC
        attack DRAIN, BREAK, VANISH
        end

        if_self_dead
                end_if
        if_hit
                attack MUTE, SLEEP, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script L50_MAGIC
        attack POISON, BIO, DOOM
        wait
        set_target ALL_MONSTERS
        attack REMEDY, DISPEL, DISPEL
        end

        if_self_dead
                end_if
        if_hit
                attack BERSERK, SLOW, HASTE2
                end_retal

; ------------------------------------------------------------------------------

ai_script L60_MAGIC
        attack QUAKE, TORNADO, HOLY
        end

        if_self_dead
                end_if
        if_hit
                attack OSMOSE, SLOW_2, REGEN
                end_retal

; ------------------------------------------------------------------------------

ai_script L70_MAGIC
        attack FIRAGA, BLIZZAGA, THUNDAGA
        end

        if_self_dead
                end_if
        if_hit
                attack SLEEP, RASP, SHELL
                end_retal

; ------------------------------------------------------------------------------

ai_script L80_MAGIC
        if_status_set ALL_CHARS, REFLECT
                attack CURA, REMEDY, HASTE
                end_if
        if_status_set ALL_MONSTERS, REFLECT
                attack FIRAGA, BLIZZAGA, THUNDAGA
                end_if
        attack BIO, BIO, POISON
        end

        if_self_dead
                end_if
        if_hit
        if_status_set ALL_CHARS, REFLECT
                attack CURAGA, CURE, RERAISE
                end_if
        if_hit
        if_status_set ALL_MONSTERS, REFLECT
                attack STOP, DISPEL, HOLY
                end_retal

; ------------------------------------------------------------------------------

ai_script L90_MAGIC
        attack METEOR, MELTDOWN, FLARE
        wait
        attack METEOR, MELTDOWN, FLARE
        wait
        attack METEOR, MELTDOWN, FLARE
        wait
        set_target NOTHING
        attack DISPEL
        attack FLARE, FLARE, NOTHING
        attack FLARE, FLARE, NOTHING
        attack FLARE, FLARE, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack STOP, THUNDAGA, RERAISE
                end_retal

; ------------------------------------------------------------------------------

ai_script MAGIMASTER
        if_status_set ALL_MONSTERS, REFLECT
                attack FIRAGA, BLIZZAGA, THUNDAGA
                end_if
        attack FIRA, BLIZZARA, THUNDARA
        wait
        attack FIRAGA, BLIZZAGA, THUNDAGA
        wait
        attack FIRAGA, BLIZZAGA, THUNDAGA
        attack FIRAGA, BLIZZAGA, THUNDAGA
        wait
        attack FIRAGA, BLIZZAGA, THUNDAGA
        attack FIRAGA, BLIZZAGA, THUNDAGA
        wait
        attack FIRAGA, BLIZZAGA, THUNDAGA
        wait
        attack DOOM, MUTE, BIO
        attack DOOM, MUTE, BIO
        end

        if_self_dead
                set_target NOTHING
                attack ULTIMA
                end_if
        if_hit
                set_target SELF
                attack WALLCHANGE
                end_retal

; ------------------------------------------------------------------------------

ai_script IRONHITMAN
        attack SPECIAL, DISCHORD, BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script JUNK
        if_num_monsters 1
                attack EXPLODER
                end_if
        attack PEP_UP, EXPLODER, NOTHING
        wait
        set_target SELF
        attack SPECIAL, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script FORTIS
        attack SNOWBALL, FIRE_BALL, MISSILE
        end

        if_element LIGHTNING
        if_hit
                attack SPECIAL
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script DUELLER
        attack L5_DOOM, L4_FLARE, SPECIAL
        end

        if_self_dead
                end_if
        if_hit
                attack SHRAPNEL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script INNOC
        attack SPECIAL
        wait
        attack COLD_DUST, PLASMA, NOTHING
        wait
        attack COLD_DUST, PLASMA, NOTHING
        wait
        attack COLD_DUST, PLASMA, NOTHING
        wait
        attack COLD_DUST, PLASMA, PEARL_LORE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SKY_BASE
        attack L5_DOOM
        wait
        attack SPECIAL, NOTHING, NOTHING
        wait
        attack SPECIAL, NOTHING, NOTHING
        wait
        attack DOOM, NOTHING, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                end_if
        if_hit
                attack BLASTER, NOTHING, NOTHING
                attack BLASTER, NOTHING, NOTHING
                attack BLASTER, NOTHING, NOTHING
                attack BLASTER, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script GUARDIAN_BOSS
        if_monster_switch_set 1
                dlg $82
; Included battle program!
                dlg $7e
; Ran Ultros’s battle program!
                attack BATTLE, TENTACLE, TENTACLE
                wait
                attack BATTLE, ENTWINE, SPECIAL
                wait
                attack BATTLE, STONE, SPECIAL
                wait
                attack ENTWINE
                clr_monster_switch 1
                clr_battle_switch 0, 0
                end_if
        if_monster_switch_set 2
                dlg $82
; Included battle program!
                dlg $7f
; Ran battle program!
                attack BATTLE, SHOCK_WAVE, SHOCK_WAVE
                wait
                attack BATTLE, SHOCK_WAVE, SHOCK_WAVE
                wait
                throw_item MITHRILKNIFE, ASHURA
                use_item TONIC, POTION
                use_item TONIC, POTION
                use_item TONIC, POTION
                set_target SELF
                attack TEKBARRIER
                clr_monster_switch 2
                clr_battle_switch 0, 0
                end_if
        if_monster_switch_set 3
                dlg $82
; Included battle program!
                dlg $80
; Ran Air Force’s battle program!
                attack TEK_LASER, DIFFUSER, DIFFUSER
                wait
                attack TEK_LASER, DIFFUSER, DIFFUSER
                wait
                attack TEK_LASER, LAUNCHER, LAUNCHER
                wait
                dlg $67
; Wave Cannon! Count down!!
; Count 3!
                dlg $3c
; Count 2!
                dlg $45
; Count 1!
                attack WAVECANNON
                clr_monster_switch 3
                clr_battle_switch 0, 0
                end_if
        if_monster_switch_set 4
                dlg $82
; Included battle program!
                dlg $81
; Ran Atma’s battle program!
                attack FLARE, METEO, METEO
                wait
                attack BATTLE, FLARE, FLARE
                wait
                attack BATTLE, METEO, BATTLE
                wait
                dlg $65
; Vast energy focused
                short_glow MONSTER_1
                short_glow MONSTER_1
                short_glow MONSTER_1
                set_target NOTHING
                attack FLARE_STAR
                clr_monster_switch 4
                clr_battle_switch 0, 0
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 3, 3
                set_battle_var 3, 0
                set_monster_var 0
                set_monster_switch 4
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 3, 2
                add_battle_var 3, 1
                set_monster_var 0
                set_monster_switch 3
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 3, 1
                add_battle_var 3, 1
                set_monster_var 0
                set_monster_switch 2
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 3, 0
                add_battle_var 3, 1
                set_monster_var 0
                set_monster_switch 1
                end_if
        dlg $68
; Ran basic program!
        attack BATTLE, TEK_LASER, MISSILE
        wait
        attack ATOMIC_RAY, MISSILE, TEK_LASER
        set_battle_switch 0, 0
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script PROMETHEUS
        attack SPECIAL, SHRAPNEL, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack S_CROSS, NOTHING, NOTHING
                end_if
        if_cmd MAGIC
                attack N_CROSS, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script SCULLION
        attack SPECIAL
        wait
        attack WAVECANNON, GRAV_BOMB, LAUNCHER
        wait
        attack GRAV_BOMB, GRAV_BOMB, ATOMIC_RAY
        wait
        attack SPECIAL, LAUNCHER, WAVECANNON
        wait
        attack SPECIAL, WAVECANNON, LAUNCHER
        end

        if_self_dead
                attack ATOMIC_RAY
                end_retal

; ------------------------------------------------------------------------------

ai_script VETERAN
        attack BATTLE, CONDEMNED, CONDEMNED
        wait
        attack BATTLE, CONDEMNED, BATTLE
        wait
        attack BATTLE, DREAD, DREAD
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack NOTHING, NOTHING, ROULETTE
                end_retal

; ------------------------------------------------------------------------------

ai_script DIDALOS
        if_monster_switch_clr 0
        if_status_set ALL_CHARS, REFLECT
                attack REFLECT_LORE
                set_monster_switch 0
                end_if
        attack BATTLE, L5_DOOM, BIO
        wait
        attack DEMI, DEMI, VIRITE
        wait
        attack BATTLE, BATTLE, NOTHING
        clr_monster_switch 0
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack FIRE_WALL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script MOVER
        if_num_monsters 1
                attack BIG_GUARD, BLOW_FISH, BLOW_FISH
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script RETAINER
        attack BATTLE, BATTLE, NOTHING
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        attack BATTLE, BATTLE, NOTHING
        wait
        attack WIND_SLASH, BATTLE, NOTHING
        attack WIND_SLASH, BATTLE, NOTHING
        end

        if_self_dead
                attack SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script DARK_FORCE
        attack CONDEMNED, ROULETTE, AQUA_RAKE
        wait
        attack REVENGE, WHITE_WIND, L5_DOOM
        wait
        attack L4_FLARE, L3_CONFUSE, REFLECT_LORE
        wait
        attack PEARL_LORE, STEP_MINE, LAUNCHER
        wait
        attack DISCHORD, SOUR_MOUTH, IMP_SONG
        wait
        attack AERO, BLOW_FISH, EXPLODER
        wait
        attack RIPPLER, STONE, QUASAR
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script STEROIDITE
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack GIGA_VOLT, SNOWSTORM, COLD_DUST
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack GIGA_VOLT, SNOWSTORM, COLD_DUST
        wait
        attack N_CROSS, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script OUTSIDER
        throw_item IMPERIAL, ASHURA
        wait
        throw_item KODACHI, KOTETSU
        wait
        throw_item BLOSSOM, FORGED
        wait
        throw_item HARDENED, TEMPEST
        wait
        throw_item STRIKER, MURASAME
        wait
        set_target SELF
        attack SPECIAL, SPECIAL, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                throw_item SHURIKEN
                end_if
        if_hit
                throw_item NINJA_STAR, TACK_STAR
                end_retal

; ------------------------------------------------------------------------------

ai_script HEMOPHYTE
        if_num_monsters 1
                attack SHOCK_WAVE, SHOCK_WAVE, NOTHING
                attack SHOCK_WAVE, SHOCK_WAVE, NOTHING
                attack SHOCK_WAVE, SHOCK_WAVE, NOTHING
                end_if
        attack BATTLE, BATTLE, CHOKESMOKE
        end

        if_hit
        if_self_dead
                end_if
        attack SPECIAL, SPECIAL, NOTHING
        end_retal

; ------------------------------------------------------------------------------

ai_script MADAM
        if_status_set ALL_MONSTERS, REFLECT
                attack CURAGA
                end_if
        attack HOLY, FLARE, IMP
        wait
        attack CURA, RERAISE, SAFE
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack CURA, RERAISE, SAFE
        attack FIRAGA, BLIZZAGA, THUNDAGA
        wait
        attack REMEDY, CURA, SHELL
        attack FIRAGA, BLIZZAGA, THUNDAGA
        wait
        attack REGEN, REMEDY, HASTE
        attack FIRAGA, BLIZZAGA, THUNDAGA
        end

        if_self_dead
                end_if
        if_hit
                set_target NOTHING
                attack CURA, NOTHING, NOTHING
                attack METEOR, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script VECTAUR
        attack BATTLE
        wait
        attack BATTLE, FIRE_BALL, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script EVIL_OSCAR
        if_num_monsters 1
                attack SOUR_MOUTH
                end_if
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script LAND_WORM
        attack MAGNITUDE8, MAGNITUDE8, LODE_STONE
        wait
        attack MAGNITUDE8, MAGNITUDE8, LODE_STONE
        wait
        attack MAGNITUDE8, SPECIAL, LODE_STONE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script VECTAGOYLE
        attack BATTLE, BATTLE, NOTHING
        wait
        attack GIGA_VOLT, SNOWSTORM, BLAZE
        wait
        attack AQUA_RAKE, SNOWSTORM, BATTLE
        wait
        attack AQUA_RAKE, GIGA_VOLT, BLAZE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, SPECIAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script BRONTAUR
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack LIFESHAVER, LIFESHAVER, NOTHING
        attack LIFESHAVER, LIFESHAVER, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack ATOMIC_RAY, LIFESHAVER, SPECIAL
        wait
        attack ATOMIC_RAY, LIFESHAVER, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GTBEHEMOTH
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, METEOR
        end

        if_hit
                set_target NOTHING
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script DOOM_DRGN
        attack S_CROSS, BATTLE, BATTLE
        wait
        attack S_CROSS, BATTLE, BATTLE
        wait
        attack S_CROSS, BATTLE, BATTLE
        wait
        attack S_CROSS, BATTLE, BATTLE
        wait
        attack N_CROSS, FLARE_STAR, BATTLE
        set_target SELF
        attack SPECIAL, SPECIAL, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                set_target ALL_CHARS
                attack FALLEN_ONE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script ALLO_VER
        if_monster_timer 60
                set_target ALL_CHARS
                attack ATOMIC_RAY
                set_target ALL_CHARS
                attack ATOMIC_RAY
                set_target ALL_CHARS
                attack ATOMIC_RAY
                set_target ALL_CHARS
                attack ATOMIC_RAY
                set_target ALL_CHARS
                attack ATOMIC_RAY
                set_target ALL_CHARS
                attack ATOMIC_RAY
                set_target ALL_CHARS
                attack ATOMIC_RAY
                set_target ALL_CHARS
                attack ATOMIC_RAY
                reset_monster_timer
                end_if
        attack DOOM, CONDEMNED, NOTHING
        end

        if_hit
                attack NOTHING, NOTHING, DOOM
                end_retal

; ------------------------------------------------------------------------------

ai_script SRBEHEMOTH_UNDEAD
        if_status_set CHAR_1, SLEEP
        if_status_clr CHAR_1, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_1
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_if
        if_status_set CHAR_2, SLEEP
        if_status_clr CHAR_2, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_2
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_if
        if_status_set CHAR_3, SLEEP
        if_status_clr CHAR_3, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_3
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_if
        if_status_set CHAR_4, SLEEP
        if_status_clr CHAR_4, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_4
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_if
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack BATTLE, DOOM, BATTLE
        wait
        attack NOTHING, METEO, SPECIAL
        end

        if_self_dead
                kill_monsters ALL, FADE_HORIZONTAL
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script PUGS
        if_self_in_slot MONSTER_3
        if_battle_var_greater 36, 8
                attack SPECIAL
                set_monster_var 0
                kill_monsters_wait MONSTER_3, MATERIALIZE
                move_back_64 MONSTER_3
                show_monsters MONSTER_3, MATERIALIZE
                end_if
        if_self_in_slot MONSTER_3
                move_forward_fast MONSTER_3
                attack BATTLE
                add_monster_var 1
                end_if
        if_self_in_slot MONSTER_4
        if_battle_var_greater 36, 8
                attack SPECIAL
                set_monster_var 0
                kill_monsters_wait MONSTER_4, MATERIALIZE
                move_back_64 MONSTER_4
                show_monsters MONSTER_4, MATERIALIZE
                end_if
        if_self_in_slot MONSTER_4
                move_forward_fast MONSTER_4
                attack BATTLE
                add_monster_var 1
                end_if
        if_self_in_slot MONSTER_5
        if_battle_var_greater 36, 8
                attack SPECIAL
                set_monster_var 0
                kill_monsters_wait MONSTER_5, MATERIALIZE
                move_back_64 MONSTER_5
                show_monsters MONSTER_5, MATERIALIZE
                end_if
        if_self_in_slot MONSTER_5
                move_forward_fast MONSTER_5
                attack BATTLE
                add_monster_var 1
                end_if
        end

        if_self_dead
                kill_monsters SELF, FADE_HORIZONTAL
                end_if
        if_self_in_slot MONSTER_3
        if_cmd FIGHT
                add_battle_var 0, 1
                if_battle_var_greater 36, 2
                if_battle_var_greater 0, 3
                        set_battle_var 0, 0
                        move_back_fast MONSTER_3
                        sub_monster_var 1
                        end_if
        if_self_in_slot MONSTER_4
        if_cmd FIGHT
                add_battle_var 1, 1
                if_battle_var_greater 36, 2
                if_battle_var_greater 1, 3
                        set_battle_var 1, 0
                        move_back_fast MONSTER_4
                        sub_monster_var 1
                        end_if
        if_self_in_slot MONSTER_5
        if_cmd FIGHT
                add_battle_var 2, 1
                if_battle_var_greater 36, 2
                if_battle_var_greater 2, 3
                        set_battle_var 2, 0
                        move_back_fast MONSTER_5
                        sub_monster_var 1
                        end_if
        if_cmd MAGIC
                set_target PREV_ATTACKER
                attack HOLY
                end_retal

; ------------------------------------------------------------------------------

ai_script WHELK
        if_battle_switch_clr 3, 0
                toggle_battle_switch 3, 0
                battle_event WHELK_INTRO
                end_if
        if_monster_timer 10
        if_monsters_dead MONSTER_2
                dlg $05
; Gruuu……
                show_monsters MONSTER_2, FADE_UP
                reset_monster_timer
                end_if
        if_monster_timer 10
        if_monsters_alive MONSTER_2
                dlg $05
; Gruuu……
                kill_monsters MONSTER_2, FADE_DOWN
                reset_monster_timer
                end

        if_self_dead
                boss_death
                end_if
        if_hit
                set_target NOTHING
                attack MEGA_VOLT
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script PRESENTER
        if_battle_switch_set 0, 0
                attack NOTHING, MAGNITUDE8, MAGNITUDE8
                end_if
        attack NOTHING, BATTLE, BATTLE
        wait
        attack NOTHING, MEGA_VOLT, BLOW_FISH
        end

        if_battle_switch_clr 3, 0
        if_self_dead
                set_battle_switch 3, 0
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, GIGA_VOLT
                end_retal

; ------------------------------------------------------------------------------

ai_script VARGAS
        if_battle_switch_set 0, 0
        if_battle_switch_clr 0, 4
        if_status_clr SABIN, CONDEMNED
                attack SPECIAL
                dlg $12
; Phew…
; I tire of this!
                set_battle_switch 0, 4
                end_if
        if_battle_switch_set 0, 4
        if_battle_switch_clr 0, 2
        if_status_set SABIN, CONDEMNED
                set_battle_switch 0, 2
                dlg $43
; Come on, SABIN!
; There’s no going back!
                end_if
        if_monster_timer 50
                reset_monster_timer
                dlg $0a
; Come on. What’s the matter?
                attack BATTLE
                attack BATTLE
                end_if
        attack BATTLE
        wait
        attack GALE_CUT, GALE_CUT, GALE_CUT
        wait
        attack BATTLE
        end

        if_self_dead
                boss_death
                end_if
        if_attack PUMMEL
                battle_event VARGAS_DEFEATED
                kill_monsters ALL, FADE_HORIZONTAL
                end_if
        if_hit
        if_hp SELF, 10880
        if_battle_switch_clr 0, 0
                set_battle_switch 0, 0
                dlg $42
; Enough!!
; Off with ya now!
                battle_event SABIN_INTRO
                end_if
        if_hit
        if_battle_switch_set 0, 0
        if_battle_switch_clr 0, 1
        if_hp SELF, 10368
                battle_event BLITZ_TUTORIAL
                set_battle_switch 0, 1
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script TUNNELARMR
        if_battle_switch_clr 0, 0
                battle_event TUNNELARMR_INTRO
                toggle_battle_switch 0, 0
                end_if
        if_hp SELF, 384
                set_target NOTHING
                attack BATTLE, FIRE, BATTLE
                wait
                set_target NOTHING
                attack TEK_LASER, SPECIAL, THUNDER
                end_if
        attack BATTLE, THUNDER, FIRE
        wait
        attack POISON, SPECIAL, FIRE
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script GHOSTTRAIN
        if_battle_switch_clr 0, 0
                toggle_battle_switch 0, 0
                attack BATTLE, SPECIAL, EVIL_TOOT
                end_if
        if_battle_var_greater 3, 2
        if_num_chars 2
                set_battle_var 3, 0
                attack EVIL_TOOT
                end_if
        if_monster_timer 15
                reset_monster_timer
                attack ACID_RAIN, ACID_RAIN, SCAR_BEAM
                end_if
        attack BATTLE, BATTLE, SPECIAL
        attack BATTLE, BATTLE, SPECIAL
        add_battle_var 3, 1
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script DADALUMA
        if_status_clr SELF, SILENCE
        if_monster_timer 30
                reset_monster_timer
                if_monsters_dead {MONSTER_2, MONSTER_3}
                        sfx 184, 64
                        restore_monsters {MONSTER_2, MONSTER_3}, SIDE
                        end_if
        if_battle_switch_clr 0, 0
        if_hp SELF, 1920
                set_target SELF
                use_item POTION, TONIC
                use_item POTION, TONIC
                use_item POTION, TONIC
                attack SAFE
                set_battle_switch 0, 0
                end_if
        if_battle_var_greater 3, 4
                set_target RAND_CHAR
                throw_item DIRK, MITHRILKNIFE
                set_target RAND_CHAR
                throw_item DIRK, MITHRILKNIFE
                set_battle_var 3, 0
                end_if
        if_battle_var_greater 2, 2
        if_status_clr SELF, SLOW
                set_target ALL_CHARS
                throw_item DIRK, MITHRILKNIFE
                wait
                set_target RAND_CHAR
                cmd JUMP
                set_battle_var 2, 0
                end_if
        set_target NOTHING
        attack BATTLE, BATTLE, SHOCK_WAVE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        if_cmd FIGHT
                add_battle_var 3, 1
                attack NOTHING, NOTHING, BATTLE
                end_if
        if_cmd MAGIC
                add_battle_var 2, 1
                set_target RAND_CHAR
                end_if
        if_cmd STEAL
                cmd STEAL
                end_retal

; ------------------------------------------------------------------------------

ai_script SHIVA
        if_battle_var_greater 3, 5
                set_battle_var 3, 0
                kill_monsters_wait MONSTER_2, MATERIALIZE
                show_monsters MONSTER_1, MATERIALIZE
                kill_monsters MONSTER_2, INSTANT
                end_if
        if_battle_var_greater 36, 3
                set_monster_var 0
                kill_monsters_wait MONSTER_2, MATERIALIZE
                show_monsters MONSTER_4, MATERIALIZE
                set_target RAND_CHAR
                attack REFLECT
                kill_monsters_wait MONSTER_4, MATERIALIZE
                show_monsters MONSTER_2, MATERIALIZE
                kill_monsters MONSTER_4, INSTANT
                end_if
        set_target NOTHING
        attack BLIZZARD, BLIZZARD, BLIZZARA
        wait
        attack BLIZZARD, BLIZZARA, SNOWSTORM
        end

        if_self_dead
                dlg $1b
; Who’re you…?
                restore_monsters {MONSTER_1, MONSTER_2}, INSTANT
                dlg $1c
; I sensed a kindred spirit…
                dlg $1d
; You have Ramuh’s power…?
; Wait!
; We’re…
; Espers…
                end_battle
                end_if
        if_cmd MAGIC
                attack NOTHING, NOTHING, BLIZZARD
                add_monster_var 1
                add_battle_var 3, 1
                end_if
        if_hit
                add_battle_var 3, 1
                attack NOTHING, NOTHING, BLIZZARD
                end_retal

; ------------------------------------------------------------------------------

ai_script IFRIT
        if_battle_var_greater 3, 5
                set_battle_var 3, 0
                kill_monsters_wait MONSTER_1, MATERIALIZE
                show_monsters MONSTER_2, MATERIALIZE
                kill_monsters MONSTER_1, INSTANT
                end_if
        if_battle_var_greater 36, 3
                set_monster_var 0
                kill_monsters_wait MONSTER_1, MATERIALIZE
                show_monsters MONSTER_3, MATERIALIZE
                set_target RAND_CHAR
                attack FIRAGA
                kill_monsters_wait MONSTER_3, MATERIALIZE
                show_monsters MONSTER_1, MATERIALIZE
                kill_monsters MONSTER_3, INSTANT
                end_if
        attack BATTLE, FIRE, FIRE
        wait
        attack BATTLE, BLAZE, FIRA
        add_battle_var 2, 1
        end

        if_self_dead
                dlg $1c
; I sensed a kindred spirit…
                restore_monsters {MONSTER_1, MONSTER_2}, INSTANT
                dlg $1b
; Who’re you…?
                dlg $1d
; You have Ramuh’s power…?
; Wait!
; We’re…
; Espers…
                end_battle
                end_if
        if_cmd MAGIC
                add_monster_var 1
                add_battle_var 3, 1
                attack NOTHING, NOTHING, FIRE
                end_if
        if_hit
                add_battle_var 3, 1
                attack NOTHING, NOTHING, FIRE
                end_retal

; ------------------------------------------------------------------------------

ai_script NUMBER_024
        if_monster_timer 30
                reset_monster_timer
                attack WALLCHANGE
                add_battle_var 3, 1
                end_if
        if_battle_var_greater 3, 3
                dlg $00
; System error!
                set_target SELF
                attack SUN_BATH, ICE_RABBIT, SCAN
                wait
                set_target SELF
                attack SUN_BATH, ICE_RABBIT, SCAN
                wait
                set_target SELF
                attack SUN_BATH, ICE_RABBIT, SCAN
                set_battle_var 3, 0
                end_if
        if_weak_element SELF, FIRE
                set_target NOTHING
                attack BLIZZARD, BLIZZARD, BLIZZARA
                end_if
        if_weak_element SELF, ICE
                set_target NOTHING
                attack FIRE, FIRA, FIRE_BALL
                end_if
        if_weak_element SELF, LIGHTNING
                set_target NOTHING
                attack AQUA_RAKE, ACID_RAIN, ACID_RAIN
                end_if
        if_weak_element SELF, POISON
                set_target NOTHING
                attack CURE, CURE, CURA
                end_if
        if_weak_element SELF, WIND
                set_target NOTHING
                attack MAGNITUDE8, MAGNITUDE8, CAVE_IN
                end_if
        if_weak_element SELF, HOLY
                set_target NOTHING
                attack BATTLE, BATTLE, R_POLARITY
                end_if
        if_weak_element SELF, EARTH
                set_target NOTHING
                attack SONIC_BOOM, GALE_CUT, GALE_CUT
                end_if
        if_weak_element SELF, WATER
                set_target NOTHING
                attack THUNDER, THUNDER, THUNDARA
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        if_element FIRE
        if_weak_element SELF, FIRE
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_element ICE
        if_weak_element SELF, ICE
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_element LIGHTNING
        if_weak_element SELF, LIGHTNING
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_element POISON
        if_weak_element SELF, POISON
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_element WIND
        if_weak_element SELF, WIND
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_element HOLY
        if_weak_element SELF, HOLY
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_element EARTH
        if_weak_element SELF, EARTH
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_element WATER
        if_weak_element SELF, WATER
                add_battle_var 3, 1
                attack WALLCHANGE
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script NUMBER_128
        if_monster_switch_clr 0
        if_num_monsters 1
        if_status_clr SELF, HASTE
                set_target SELF
                attack HASTE
                set_monster_switch 0
                end_if
        if_num_monsters 1
                attack BATTLE, GALE_CUT, ATOMIC_RAY
                wait
                attack BLASTER, ATOMIC_RAY, SHOCK_WAVE
                end_if
        attack BATTLE, BATTLE, BLIZZARD
        wait
        attack BATTLE, SPECIAL, NET
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script INFERNO
        if_battle_timer 30
        if_monsters_alive {MONSTER_1, MONSTER_2, MONSTER_4}
                attack DELTA_HIT
                reset_battle_timer
                end_if
        if_monster_switch_clr 0
        if_num_monsters 1
        if_status_clr SELF, HASTE
                set_target SELF
                attack TEKBARRIER
                set_monster_switch 0
                end_if
        if_num_monsters 2
                attack THUNDAGA, THUNDAGA, METEOR
                end_if
        attack THUNDARA, ATOMIC_RAY, ATOMIC_RAY
        wait
        attack GIGA_VOLT, GIGA_VOLT, ATOMIC_RAY
        wait
        attack THUNDARA, ATOMIC_RAY, SHOCK_WAVE
        wait
        attack THUNDARA, ATOMIC_RAY, SHOCK_WAVE
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script CRANE_1
        if_battle_var_greater 1, 3
                set_battle_var 1, 0
                set_target MONSTER_2
                attack FIRA
                end_if
        if_monster_switch_clr 0
        if_num_monsters 1
                set_target SELF
                attack TEKBARRIER
                set_monster_switch 0
                end_if
        if_battle_timer 60
                reset_battle_timer
                dlg $1f
; The crane shook the deck!
                attack MAGNITUDE8
                end_if
        attack BATTLE, THUNDER, THUNDER
        wait
        attack BATTLE, THUNDARA, SPECIAL
        end

        if_element LIGHTNING
        if_battle_var_greater 3, 2
                dlg $31
; Electrified LV 3
                dlg $26
; Unleashed electric energy!
                set_battle_var 3, 0
                set_target ALL_CHARS
                attack GIGA_VOLT
                end_if
        if_element LIGHTNING
        if_battle_var_greater 3, 1
                add_battle_var 3, 1
                dlg $2d
; Electrified LV 2
                end_if
        if_element LIGHTNING
        if_battle_var_greater 3, 0
                add_battle_var 3, 1
                dlg $2c
; Electrified LV 1
                end_if
        if_hit
                add_battle_var 1, 1
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script CRANE_2
        if_battle_var_greater 0, 3
                set_battle_var 0, 0
                set_target MONSTER_1
                attack THUNDARA
                end_if
        if_monster_switch_clr 0
        if_num_monsters 1
                set_target SELF
                attack TEKBARRIER
                set_monster_switch 0
                end_if
        if_battle_timer 60
                reset_battle_timer
                dlg $1f
; The crane shook the deck!
                attack MAGNITUDE8
                end_if
        attack BATTLE, FIRE, FIRE
        wait
        attack BATTLE, FIRA, SPECIAL
        end

        if_element FIRE
        if_battle_var_greater 2, 2
                dlg $47
; Heat source LV 3
                dlg $32
; Unleashed thermal energy!
                set_battle_var 2, 0
                set_target ALL_CHARS
                attack FIRAGA
                end_if
        if_element FIRE
        if_battle_var_greater 2, 1
                add_battle_var 2, 1
                dlg $46
; Heat source LV 2
                end_if
        if_element FIRE
        if_battle_var_greater 2, 0
                add_battle_var 2, 1
                dlg $33
; Heat source LV 1
                end_if
        if_hit
                add_battle_var 0, 1
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script UMARO_1
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, SNOWSTORM
        end

        if_self_dead
                boss_death
                end_if
        if_element FIRE
                set_target NOTHING
                attack NOTHING, SPECIAL, SNOWSTORM
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script UMARO_2
        if_battle_switch_clr 0, 0
        if_battle_switch_clr 0, 1
        if_hp SELF, 10240
                set_target SELF
                use_item GREEN_CHERRY
                flash_red MONSTER_1
                dlg $49
; Power 100 times up!
; Defense up
; Mag Def up
; Speed up
; Recovery up
                set_status SAFE
                set_status SHELL
                set_status HASTE
                set_status REGEN
                set_battle_switch 0, 0
                end_if
        if_battle_var_greater 36, 3
                cmd JUMP
                set_monster_var 0
                end_if
        if_num_chars 2
        if_monster_timer 40
                reset_monster_timer
                attack SNOWBALL, SURGE, LODE_STONE
                end_if
        if_num_chars 2
                attack BATTLE, BATTLE, SNOWSTORM
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        if_battle_switch_clr 0, 0
        if_battle_switch_clr 0, 1
        if_item GREEN_CHERRY
                flash_red MONSTER_1
                dlg $49
; Power 100 times up!
; Defense up
; Mag Def up
; Speed up
; Recovery up
                set_status SAFE
                set_status SHELL
                set_status HASTE
                set_status REGEN
                set_battle_switch 0, 1
                end_if
        if_cmd MAGIC
                add_monster_var 1
                end_if
        if_element FIRE
                attack NOTHING, SPECIAL, SNOWSTORM
                end_if
        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script GUARDIAN_VECTOR
        if_battle_switch_clr 0, 0
                invincible_on SELF
                dlg $30
; Won’t let you pass!!
                set_battle_switch 0, 0
                end_if
        end

        if_cmd FIGHT
        if_battle_var_greater 1, 2
                set_battle_var 1, 0
                dlg $2f
; No use!
                end_if
        if_cmd FIGHT
                add_battle_var 1, 1
                dlg $2e
; No use!
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script AIR_FORCE
        if_battle_switch_set 0, 0
        if_battle_var_greater 1, 6
                kill_monsters MONSTER_4, TOP
                attack WAVECANNON
                set_battle_var 1, 0
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 1, 5
                dlg $45
; Count 1!
                add_battle_var 1, 1
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 1, 4
                dlg $3c
; Count 2!
                add_battle_var 1, 1
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 1, 3
                dlg $3b
; Count 3!
                add_battle_var 1, 1
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 1, 2
                dlg $3a
; Count 4!
                add_battle_var 1, 1
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 1, 1
                dlg $39
; Count 5!
                add_battle_var 1, 1
                end_if
        if_battle_switch_set 0, 0
        if_battle_var_greater 1, 0
                restore_monsters MONSTER_4, SIDE
                set_status HASTE
                dlg $22
; Air Force launched a Speck.
; A Speck absorbs magic!
                dlg $38
; Count 6!
                add_battle_var 1, 1
                end_if
        if_num_monsters 2
                attack TEK_LASER, DIFFUSER, NOTHING
                end_if
        attack TEK_LASER, TEK_LASER, NOTHING
        end

        if_self_dead
                boss_death
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script TRITOCH_INTRO
        battle_event TRITOCH_INTRO
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TRITOCH_MORPH
        battle_event TRITOCH_TERRA_TRANSFORMS
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script FLAMEEATER
        if_monster_switch_clr 0
                set_monster_switch 0
                attack BOMBLET
                restore_monsters {MONSTER_3, MONSTER_4, MONSTER_5, MONSTER_6}, SMOKE
                end_if
        if_monster_timer 15
                reset_monster_timer
                add_battle_var 3, 1
                if_battle_var_greater 3, 6
                        set_battle_var 3, 0
                        end_if
        if_battle_var_greater 2, 6
        if_status_clr SELF, REFLECT
                set_target SELF
                attack SAFE
                attack REFLECT
                set_battle_var 2, 0
                end_if
        if_monster_switch_clr 1
        if_num_monsters 1
        if_battle_var_greater 3, 5
                attack BOMBLET
                restore_monsters MONSTER_2, SMOKE
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_num_monsters 1
        if_battle_var_greater 3, 4
                attack BOMBLET
                restore_monsters {MONSTER_3, MONSTER_6}, SMOKE
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_num_monsters 1
        if_battle_var_greater 3, 3
                attack BOMBLET
                restore_monsters {MONSTER_3, MONSTER_4, MONSTER_5, MONSTER_6}, SMOKE
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_num_monsters 1
        if_battle_var_greater 3, 2
                attack BOMBLET
                restore_monsters {MONSTER_3, MONSTER_5, MONSTER_6}, SMOKE
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_num_monsters 1
        if_battle_var_greater 3, 1
                attack BOMBLET
                restore_monsters {MONSTER_4, MONSTER_6}, SMOKE
                set_monster_switch 1
                end_if
        if_status_set SELF, REFLECT
                attack FIRA, FIRAGA, FIRA
                add_battle_var 3, 1
                clr_monster_switch 1
                end_if
        attack FIRE, NOTHING, FIRE
        wait
        attack FIRE, FIRE_BALL, FIRE_BALL
        wait
        attack FIRE, FIRE_BALL, NOTHING
        clr_monster_switch 1
        end

        if_self_dead
                boss_death
                end_if
        if_attack DEMI, QUARTR
                set_target ALL_CHARS
                attack QUARTR, FLARE, QUARTR
                end_if
        if_hit
                add_battle_var 2, 1
                attack NOTHING, NOTHING, FIRA
                end_retal

; ------------------------------------------------------------------------------

ai_script ATMAWEAPON
        if_monster_switch_clr 7
                dlg $85
; My name is Atma……
; I am pure energy…
; and as ancient as the cosmos.
; Feeble creatures, GO!
                set_monster_switch 7
                end_if
        if_monster_switch_set 0
                dlg $65
; Vast energy focused
                set_status SHELL
                set_status SAFE
                set_status HASTE
                short_glow MONSTER_1
                attack NOTHING, NOTHING, NOTHING
                wait
                short_glow MONSTER_1
                attack NOTHING, NOTHING, NOTHING
                wait
                long_glow MONSTER_1
                set_target NOTHING
                attack FLARE_STAR
                clr_monster_switch 0
                clr_monster_switch 1
                end_if
        if_hp SELF, 6144
                set_target NOTHING
                attack BATTLE, QUARTR, QUARTR
                wait
                set_target NOTHING
                attack RASP, TORNADO, BLAZE
                end_if
        if_hp SELF, 12800
                set_target NOTHING
                attack BIO, QUAKE, METEO
                wait
                set_target NOTHING
                attack BATTLE, SPECIAL, SPECIAL
                wait
                set_target ALL_CHARS
                attack FIRA
                wait
                set_target NOTHING
                attack MIND_BLAST
                set_monster_switch 0
                set_monster_switch 1
                end_if
        attack BATTLE, FLARE, BATTLE
        wait
        attack FLARE, BATTLE, BLAZE
        end

        if_self_dead
                boss_death
                end_if
        if_hit
        if_monster_switch_clr 1
        if_hp SELF, 6144
                set_target NOTHING
                attack NOTHING, FLARE, NOTHING
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script NERAPA
        if_monster_switch_clr 0
                dlg $66
; Mwa ha ha……You can’t run!
                set_target CHAR_1
                attack CONDEMNED
                set_target CHAR_2
                attack CONDEMNED
                set_target CHAR_3
                attack CONDEMNED
                set_target CHAR_4
                attack CONDEMNED
                set_monster_switch 0
                end_if
        if_battle_var_greater 0, 6
                set_battle_var 0, 0
                attack ROULETTE
                end_if
        attack BATTLE, BATTLE, FIRA
        wait
        attack BATTLE, FIRE_BALL, FIRAGA
        wait
        attack BATTLE, BATTLE, FIRA
        end

        if_cmd FIGHT
                attack BATTLE, NOTHING, NOTHING
                add_battle_var 0, 1
                end_retal

; ------------------------------------------------------------------------------

ai_script SRBEHEMOTH
        if_status_set SELF, IMP
                set_target RAND_CHAR
                attack BATTLE
                attack BATTLE
                wait
                set_target RAND_CHAR
                attack BATTLE
                attack BATTLE
                wait
                set_target RAND_CHAR
                attack BATTLE
                attack BATTLE
                wait
                if_status_clr SELF, REFLECT
                        set_target SELF
                        attack IMP
                        end_if
        if_monster_switch_clr 0
        if_status_set CHAR_1, REFLECT
                set_target CHAR_1
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_2, REFLECT
                set_target CHAR_2
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_3, REFLECT
                set_target CHAR_3
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_4, REFLECT
                set_target CHAR_4
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_hp SELF, 10240
                set_target NOTHING
                attack BATTLE, BLIZZAGA, BLIZZAGA
                wait
                set_target NOTHING
                attack BATTLE, METEO, HOLY
                wait
                set_target NOTHING
                attack BATTLE, BLIZZARA, METEO
                clr_monster_switch 0
                end_if
        attack HOLY, BLIZZARA, NOTHING
        wait
        attack BATTLE, BLIZZAGA, NOTHING
        clr_monster_switch 0
        end

        if_monsters_dead MONSTER_1
                set_battle_switch 10, 0
                hide_monsters SELF, FADE_HORIZONTAL
                dlg $7c
; Enemy’s coming from behind!
                chars_run_left
                dlg $7d
; Another monster appeared!
                change_battle 424, INSTANT, RESTORE_MONSTERS
                set_battle_switch 0, 0
                end_if
        if_attack HOLY, FLARE
                set_target NOTHING
                attack METEO
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script KEFKA_1
        if_monster_switch_clr 0
                target_off SELF
                set_monster_switch 0
                end_if
        if_battle_id 471
        if_num_monsters 1
                change_battle 512, SCROLL_BG, {RESTORE_MONSTERS, SCROLL_BG}
                end_if
        if_battle_id 512
        if_num_monsters 1
                change_battle 513, SCROLL_BG, {RESTORE_MONSTERS, SCROLL_BG}
                end_if
        if_battle_id 513
        if_num_monsters 1
                change_battle 514, KEFKA_ENTRY, {RESTORE_MONSTERS, SCROLL_BG}
                end_if
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TENTACLE
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_4, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
                reset_monster_timer
                attack SPECIAL, POISON, SPECIAL
                wait
                reset_monster_timer
                attack ENTWINE, ENTWINE, SPECIAL
                wait
                reset_monster_timer
                attack BATTLE, BIO, SPECIAL
                wait
                reset_monster_timer
                attack POISON, SPECIAL, ENTWINE
                end

        if_self_dead
        if_monster_switch_set 7
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script DULLAHAN
        if_monster_switch_clr 0
                attack PEARL_LORE
                set_monster_switch 0
                end_if
        if_monster_switch_clr 2
        if_hp SELF, 10240
                set_target SELF
                attack CURA
                set_monster_switch 2
                end_if
        if_battle_var_greater 1, 8
                attack N_CROSS, SPECIAL, NOTHING
                wait
                attack BLIZZARA, SPECIAL, NOTHING
                wait
                attack PEARL_LORE, NOTHING, ABSOLUTE0
                wait
                attack BLIZZARA, ABSOLUTE0, NOTHING
                set_battle_var 1, 0
                end_if
        if_monster_switch_clr 1
        if_status_set ALL_CHARS, REFLECT
                attack REFLECT_LORE
                set_monster_switch 1
                end_if
        attack BLIZZAGA, BLIZZARA, NOTHING
        wait
        attack BLIZZAGA, NOTHING, HOLY
        wait
        attack HOLY, BLIZZARA, NOTHING
        wait
        attack NOTHING, BLIZZARA, HOLY
        clr_monster_switch 1
        clr_monster_switch 2
        end_if
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                add_battle_var 1, 1
                end_retal

; ------------------------------------------------------------------------------

ai_script DOOM_GAZE
        if_monster_switch_clr 0
                attack L5_DOOM
                set_monster_switch 0
                end_if
        set_target NOTHING
        attack BATTLE, DOOM, BLIZZAGA
        wait
        attack DOOM, AERO, AERO
        wait
        set_target SELF
        attack NOTHING, ESCAPE, ESCAPE
        end

        if_self_dead
                set_battle_switch 13, 0
                boss_death
                end_if
        if_hit
                attack NOTHING, BATTLE, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script CHADARNOOK_1
        if_monster_switch_clr 0
                dlg $5f
; DEMON:
; The girl in the picture is mine!
; You can’t have her!
                set_monster_switch 0
                end_if
        if_battle_var_greater 3, 1
                attack BATTLE, BATTLE, CHARM
                wait
                attack BATTLE, SPECIAL, LULLABY
                wait
                attack BATTLE, BATTLE, SPECIAL
                set_battle_var 3, 0
                show_monsters MONSTER_2, CHADARNOOK
                kill_monsters MONSTER_1, CHADARNOOK
                end_if
        if_battle_var_greater 3, 0
                attack BATTLE, CHARM, BATTLE
                set_battle_var 3, 0
                show_monsters MONSTER_2, CHADARNOOK
                kill_monsters MONSTER_1, CHADARNOOK
                end_if
        end

        if_self_dead
                hide_monsters MONSTER_1, FADE_DOWN
                restore_monsters MONSTER_1, FADE_UP
                end_if
        if_hit
                set_target NOTHING
                attack NOTHING, BATTLE, PHANTASM
                end_retal

; ------------------------------------------------------------------------------

ai_script CURLEY
        if_monsters_alive {MONSTER_1, MONSTER_2, MONSTER_3}
        if_battle_timer 30
                reset_battle_timer
                set_target RAND_CHAR
                attack DELTA_HIT
                end_if
        if_battle_var_greater 3, 4
        if_status_clr SELF, REFLECT
                set_battle_var 3, 0
                set_target SELF
                attack REFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target SELF
                attack FIRA, FIRAGA, FIRAGA
                end_if
        if_monsters_dead MONSTER_2
                set_target MONSTER_2
                attack ARISE
                end_if
        if_monsters_dead MONSTER_3
                set_target MONSTER_3
                attack ARISE
                end_if
        if_num_monsters 2
                attack FIRA, FIRAGA, FIRAGA
                end_if
        attack SLOW, NOTHING, WHITE_WIND
        wait
        attack MUTE, SLOW, NOTHING
        wait
        attack STOP, MUTE, NOTHING
        end

        if_cmd MAGIC
                add_battle_var 3, 1
                set_target GHOST_2
                attack NOTHING, NOTHING, FIRA
                end_if
        if_hit
                set_target GHOST_2
                attack NOTHING, FIRA, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script LARRY
        if_monsters_alive {MONSTER_1, MONSTER_2, MONSTER_3}
        if_battle_timer 30
                reset_battle_timer
                set_target RAND_CHAR
                attack DELTA_HIT
                end_if
        if_battle_var_greater 3, 4
        if_status_clr SELF, REFLECT
                set_battle_var 3, 0
                set_target SELF
                attack REFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target SELF
                attack BLIZZARA, BLIZZAGA, BLIZZAGA
                end_if
        if_monster_switch_set 0
        if_monster_switch_clr 1
        if_monster_timer 30
                set_monster_switch 1
                set_monster_switch 2
                clr_monster_switch 0
                dlg $64
; Larry came back
                restore_monsters MONSTER_2, TOP
                end_if
        if_monster_switch_clr 0
        if_monster_switch_clr 2
        if_num_monsters 2
        if_battle_var_greater 2, 4
                set_battle_var 2, 0
                dlg $5b
; Larry ran away
                set_monster_switch 0
                reset_monster_timer
                hide_monsters MONSTER_2, TOP
                end_if
        if_monster_switch_clr 0
        if_num_monsters 2
                attack BLIZZARA, NOTHING, BLIZZAGA
                wait
                attack BLIZZARA, NOTHING, BLIZZAGA
                wait
                attack NOTHING, BLIZZARA, BLIZZARA
                end_if
        if_monster_switch_clr 0
                attack BATTLE
                end

        if_num_monsters 2
        if_hit
                set_target GHOST_2
                attack NOTHING, BLIZZARA, NOTHING
                add_battle_var 2, 1
                end_if
        if_hit
                set_target GHOST_2
                attack NOTHING, BLIZZARA, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script MOE
        if_monsters_alive {MONSTER_1, MONSTER_2, MONSTER_3}
        if_battle_timer 30
                reset_battle_timer
                set_target RAND_CHAR
                attack DELTA_HIT
                end_if
        if_battle_var_greater 3, 4
        if_status_clr SELF, REFLECT
                set_battle_var 3, 0
                set_target SELF
                attack REFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target SELF
                attack THUNDARA, THUNDAGA, THUNDAGA
                end_if
        if_num_monsters 2
                attack THUNDARA, NOTHING, NOTHING
                wait
                attack THUNDARA, THUNDAGA, NOTHING
                wait
                attack THUNDAGA, THUNDAGA, NOTHING
                end_if
        attack SAFE, HASTE, NOTHING
        wait
        attack SHELL, CURA, NOTHING
        end

        if_cmd MAGIC
                add_battle_var 3, 1
                set_target GHOST_2
                attack NOTHING, NOTHING, THUNDARA
                end_if
        if_hit
                set_target GHOST_2
                attack NOTHING, THUNDARA, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script WREXSOUL
        if_battle_switch_clr 0, 1
                set_battle_switch 0, 1
                battle_event WREXSOUL_INTRO
                attack ZINGER
                end_if
        if_battle_switch_set 0, 0
                set_target ALL_REFLECT_MONSTERS
                attack NOTHING, THUNDAGA, THUNDAGA
                wait
                set_target ALL_REFLECT_MONSTERS
                attack NOTHING, THUNDAGA, THUNDAGA
                wait
                set_target RAND_CHAR
                attack NOTHING, ZINGER, ZINGER
                end_if
        attack BATTLE
        wait
        attack BATTLE
        set_battle_switch 0, 0
        end

        if_self_dead
                boss_death
                end_if
        if_battle_switch_set 0, 0
        if_cmd FIGHT
                attack NOTHING, BATTLE, NOTHING
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script HIDON
        if_monsters_dead {MONSTER_3, MONSTER_4, MONSTER_5, MONSTER_6}
        if_battle_timer 80
                restore_monsters MONSTER_3, FADE_UP
                restore_monsters MONSTER_4, FADE_UP
                restore_monsters MONSTER_5, FADE_UP
                restore_monsters MONSTER_6, FADE_UP
                clr_monster_switch 0
                end_if
        if_battle_var_greater 3, 10
                set_battle_switch 0, 0
                set_battle_var 3, 0
                end_if
        if_monster_switch_clr 0
        if_num_monsters 1
                short_glow MONSTER_1
                set_target NOTHING
                attack GRANDTRAIN
                clr_battle_switch 0, 0
                set_monster_switch 0
                end_if
        if_num_monsters 1
                set_target NOTHING
                attack VIRITE, BATTLE, RAID
                wait
                attack BATTLE, RAID, BATTLE
                wait
                attack VIRITE, BATTLE, RAID
                end_if
        if_status_set CHAR_1, DEAD
        if_status_clr CHAR_1, ZOMBIE
                set_target CHAR_1
                attack CHOKESMOKE
                end_if
        if_status_set CHAR_2, DEAD
        if_status_clr CHAR_2, ZOMBIE
                set_target CHAR_2
                attack CHOKESMOKE
                end_if
        if_status_set CHAR_3, DEAD
        if_status_clr CHAR_3, ZOMBIE
                set_target CHAR_3
                attack CHOKESMOKE
                end_if
        if_status_set CHAR_4, DEAD
        if_status_clr CHAR_4, ZOMBIE
                set_target CHAR_4
                attack CHOKESMOKE
                end_if
        attack BATTLE, BATTLE, BIO
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, POISON
                add_battle_var 3, 1
                end_retal

; ------------------------------------------------------------------------------

ai_script KATANASOUL
        if_monster_switch_clr 0
        if_battle_timer 40
                short_glow MONSTER_1
                dlg $63
; KatanaSoul’s power up!
                set_target SELF
                set_status IMAGE
                set_status REFLECT
                set_status HASTE
                set_monster_switch 0
                end_if
        if_battle_var_greater 3, 3
                throw_item ASHURA, IMPERIAL
                wait
                set_target ALL_CHARS
                cmd GP_RAIN
                set_battle_var 3, 0
                end_if
        if_battle_var_greater 1, 6
                set_battle_var 1, 0
                set_target RAND_CHAR
                attack SPECIAL
                end_if
        attack WATER_EDGE, BATTLE, GALE_CUT
        wait
        attack BATTLE, BOLT_EDGE, SHOCK_WAVE
        wait
        attack BOLT_EDGE, FIRE_SKEAN, WATER_EDGE
        wait
        attack BATTLE, BLOW_FISH, FIRE_SKEAN
        end

        if_self_dead
                boss_death
                end_if
        if_cmd FIGHT
                attack NOTHING, NOTHING, BATTLE
                add_battle_var 1, 1
                end_if
        if_cmd MAGIC, LORE
                attack NOTHING, NOTHING, BATTLE
                add_battle_var 3, 1
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script HIDONITE
        attack BATTLE, NOTHING, BATTLE
        wait
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack BATTLE, NOTHING, NOTHING
        end

        if_self_dead
                reset_battle_timer
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script DOOM
        if_target_valid TARGETTING_TARGET
                attack SPECIAL
                end_if
        if_monster_switch_set 0
        if_monster_timer 20
        if_battle_var_less 2, 8
                attack FORCEFIELD
                add_battle_var 2, 1
                reset_monster_timer
                end_if
        if_battle_var_greater 3, 8
                set_battle_var 3, 0
                set_target ALL_CHARS
                attack R_POLARITY
                end_if
        if_monster_switch_set 0
                attack BATTLE, TARGETTING, TARGETTING
                wait
                attack BATTLE, TARGETTING, TARGETTING
                wait
                attack BATTLE, BATTLE, TARGETTING
                wait
                attack BATTLE, TARGETTING, TARGETTING
                end_if
        attack BLIZZAGA, N_CROSS, ABSOLUTE0
        wait
        attack NOTHING, BLIZZAGA, N_CROSS
        wait
        attack BLIZZAGA, N_CROSS, BLIZZAGA
        wait
        attack NOTHING, BLIZZAGA, ABSOLUTE0
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack BATTLE, BATTLE, NOTHING
                add_battle_var 3, 1
                if_hp SELF, 32640
                if_monster_switch_clr 1
                        short_glow MONSTER_1
                        short_glow MONSTER_1
                        dlg $88
; Doom’s aura is shaking!
                        set_target SELF
                        set_status IMAGE
                        set_status REFLECT
                        set_status HASTE
                        set_monster_switch 0
                        set_monster_switch 1
                        end_retal

; ------------------------------------------------------------------------------

ai_script GODDESS
        if_battle_switch_clr 0, 0
        if_battle_var_greater 3, 8
                set_battle_var 3, 0
                set_target NOTHING
                attack OVERCAST
                set_battle_switch 0, 0
                end_if
        if_hp SELF, 32640
                set_target NOTHING
                attack THUNDAGA, FLASH_RAIN, NOTHING
                wait
                set_target NOTHING
                attack THUNDAGA, THUNDAGA, FLASH_RAIN
                wait
                set_target NOTHING
                attack THUNDAGA, QUASAR, QUASAR
                wait
                set_target NOTHING
                attack THUNDAGA, THUNDAGA, FLASH_RAIN
                end_if
        attack THUNDARA, BATTLE, LULLABY
        wait
        attack THUNDAGA, CHARM, BATTLE
        wait
        attack THUNDARA, BATTLE, THUNDAGA
        end

        if_self_dead
                boss_death
                end_if
        if_cmd FIGHT
                attack NOTHING, NOTHING, LOVE_TOKEN
                add_battle_var 3, 1
                end_if
        if_hit
                attack NOTHING, NOTHING, THUNDARA
                add_battle_var 3, 1
                end_retal

; ------------------------------------------------------------------------------

ai_script POLTRGEIST
        if_battle_var_greater 3, 8
                set_battle_var 3, 0
                attack WAVECANNON
                end_if
        if_status_set CHAR_1, STOP
                attack BLASTER
                end_if
        if_status_set CHAR_2, STOP
                attack BLASTER
                end_if
        if_status_set CHAR_3, STOP
                attack BLASTER
                end_if
        if_status_set CHAR_4, STOP
                attack BLASTER
                end_if
        if_hp SELF, 32640
                set_target NOTHING
                attack FLARE_STAR, S_CROSS, NOTHING
                wait
                set_target NOTHING
                attack METEO, AERO, NOTHING
                wait
                set_target NOTHING
                attack AERO, FLARE_STAR, NOTHING
                end_if
        attack BATTLE, SHRAPNEL, STOP
        wait
        attack BATTLE, SHRAPNEL, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                add_battle_var 3, 1
                attack NOTHING, FIRAGA, NOTHING
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script FINAL_KEFKA
        if_monster_switch_clr 0
                battle_event FINAL_BATTLE_INTRO
                set_monster_switch 0
                end_if
        if_hp SELF, 7680
        if_battle_switch_clr 0, 1
                dlg $8c
; The end comes…beyond chaos.
                set_battle_switch 0, 0
                kefka_head MONSTER_1
                wait
                set_target NOTHING
                attack GONER
                wait
                set_target NOTHING
                attack METEOR
                clr_battle_switch 0, 0
                end_if
        if_hp SELF, 32640
                dlg $8c
; The end comes…beyond chaos.
                set_battle_switch 0, 0
                set_battle_switch 0, 1
                kefka_head MONSTER_1
                wait
                set_target NOTHING
                attack GONER
                wait
                clr_battle_switch 0, 0
                clr_battle_switch 0, 1
                set_target NOTHING
                attack SPECIAL, TRAIN, REVENGER
                attack SPECIAL, NOTHING, NOTHING
                wait
                set_target NOTHING
                attack TRAIN, SPECIAL, REVENGER
                attack SPECIAL, SPECIAL, NOTHING
                end_if
        set_target ALL_CHARS
        attack FALLEN_ONE
        wait
        set_target NOTHING
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack FIRAGA, TRAIN, SPECIAL
        wait
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack BLIZZAGA, TRAIN, SPECIAL
        wait
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack THUNDAGA, NOTHING, SPECIAL
        end

        if_self_dead
                kefka_death MONSTER_1
                kill_monsters ALL, KEFKA_DEATH
                end_if
        if_hp SELF, 10240
        if_battle_switch_clr 0, 0
        if_hit
                set_target NOTHING
                attack NOTHING, BATTLE, ULTIMA
                end_if
        if_hp SELF, 30080
        if_battle_switch_clr 0, 0
        if_hit
                set_target NOTHING
                attack NOTHING, BATTLE, HYPERDRIVE
                end_retal

; ------------------------------------------------------------------------------

ai_script ULTROS_RIVER
        if_battle_switch_clr 0, 0
                dlg $0c
; Uwee hee hee…
; Game over!
; Don’t tease the octopus, kids!
                toggle_battle_switch 0, 0
                attack BATTLE
                end_if
        if_battle_switch_clr 0, 1
        if_monster_timer 10
        if_level_greater TERRA, 0
                dlg $0d
; Delicious morsel!
; Let me get my bib…!
                attack TENTACLE
                toggle_battle_switch 0, 1
                reset_monster_timer
                end_if
        if_battle_switch_clr 0, 2
        if_monster_timer 10
        if_level_greater SABIN, 0
                dlg $0e
; Muscle-heads? Hate ’em!
                attack TENTACLE
                toggle_battle_switch 0, 2
                reset_monster_timer
                end_if
        set_target ALL_CHARS
        attack TENTACLE
        set_target RAND_CHAR
        attack BATTLE, SPECIAL, TENTACLE
        wait
        attack BATTLE
        attack BATTLE, SPECIAL, TENTACLE
        wait
        dlg $4d
; Y…you frighten me!
        set_target BANON
        attack TENTACLE
        end

        if_self_dead
                hide_monsters SELF, WATER
                dlg $09
; Th…that’s all, friends!
                battle_event ULTROS_RIVER_DEFEATED
                end_if
        if_element FIRE
                dlg $0b
; Yaaooouch!
; Seafood soup!
                attack SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script ULTROS_OPERA
        if_battle_switch_clr 0, 0
                dlg $13
; Long time no see!
; You’ve changed!
; Did ya miss me?
                set_battle_switch 0, 0
                end_if
        if_battle_timer 60
                reset_battle_timer
                dlg $62
; Imp! Pal! Buddy!
                attack IMP_SONG, IMP_SONG, IMP_SONG
                end_if
        if_self_in_slot MONSTER_1
                attack BATTLE, SPECIAL, TENTACLE
                add_battle_var 3, 1
                end_if
        if_self_in_slot MONSTER_2
                attack BATTLE, FIRE, FIRE
                add_battle_var 3, 1
                end_if
        if_self_in_slot MONSTER_3
                attack BATTLE, L3_CONFUSE, L3_CONFUSE
                add_battle_var 3, 1
                end_if
        if_self_in_slot MONSTER_4
                attack BATTLE, MEGA_VOLT, DRAIN
                add_battle_var 3, 1
                end_if
        end

        if_self_dead
                dlg $04
; What an unlucky day!
; Adios!
                kill_monsters ALL, SIDE
                end_if
        if_cmd BUSHIDO, BLITZ
                attack ACID_RAIN
                end_if
        if_self_in_slot MONSTER_2
        if_battle_var_greater 3, 16
        if_battle_switch_clr 2, 7
                set_battle_switch 2, 7
                hide_monsters MONSTER_2, SAND
                show_monsters MONSTER_3, SAND
                dlg $1e
; I ain’t ready ta go yet.
                kill_monsters MONSTER_2, INSTANT
                set_battle_var 3, 0
                end_if
        if_self_in_slot MONSTER_4
        if_battle_var_greater 3, 14
        if_battle_switch_clr 2, 6
                set_battle_switch 2, 6
                hide_monsters MONSTER_4, SAND
                show_monsters MONSTER_2, SAND
                dlg $19
; I ain’t no…
; garden-variety octopus!
                kill_monsters MONSTER_4, INSTANT
                end_if
        if_self_in_slot MONSTER_1
        if_battle_var_greater 3, 12
        if_battle_switch_clr 2, 5
                set_battle_switch 2, 5
                hide_monsters MONSTER_1, SAND
                show_monsters MONSTER_4, SAND
                dlg $16
; Here! Over here!
                kill_monsters MONSTER_1, INSTANT
                end_if
        if_self_in_slot MONSTER_2
        if_battle_var_greater 3, 10
        if_battle_switch_clr 2, 4
                set_battle_switch 2, 4
                hide_monsters MONSTER_2, SAND
                show_monsters MONSTER_1, SAND
                dlg $1a
; How sweet it is!
                kill_monsters MONSTER_2, INSTANT
                end_if
        if_self_in_slot MONSTER_4
        if_battle_var_greater 3, 8
        if_battle_switch_clr 2, 3
                set_battle_switch 2, 3
                hide_monsters MONSTER_4, SAND
                show_monsters MONSTER_2, SAND
                dlg $18
; Have ya read it?
                kill_monsters MONSTER_4, INSTANT
                end_if
        if_self_in_slot MONSTER_2
        if_battle_var_greater 3, 6
        if_battle_switch_clr 2, 2
                set_battle_switch 2, 2
                hide_monsters MONSTER_2, SAND
                show_monsters MONSTER_4, SAND
                dlg $17
; Havin’ fun?
                kill_monsters MONSTER_2, INSTANT
                end_if
        if_self_in_slot MONSTER_3
        if_battle_var_greater 3, 4
        if_battle_switch_clr 2, 1
                set_battle_switch 2, 1
                hide_monsters MONSTER_3, SAND
                show_monsters MONSTER_2, SAND
                dlg $19
; I ain’t no…
; garden-variety octopus!
                kill_monsters MONSTER_3, INSTANT
                end_if
        if_self_in_slot MONSTER_1
        if_battle_var_greater 3, 2
        if_battle_switch_clr 2, 0
                set_battle_switch 2, 0
                hide_monsters MONSTER_1, SAND
                show_monsters MONSTER_3, SAND
                dlg $16
; Here! Over here!
                kill_monsters MONSTER_1, INSTANT
                end_retal

; ------------------------------------------------------------------------------

ai_script ULTROS_MOUNTAIN
        if_battle_switch_clr 0, 6
                dlg $4f
; I was just thinking about you!
; I’ve more lives than I do arms!
                set_battle_switch 0, 6
                end_if
        if_battle_switch_clr 0, 5
        if_hp SELF, 15360
                set_target SELF
                attack HASTE
                attack SAFE
                set_battle_switch 0, 5
                dlg $4e
; Hope I’m not making a nuisance
; of myself! So sorry!
                end_if
        if_monster_timer 60
                reset_monster_timer
                set_target RAND_CHAR
                attack LODE_STONE
                end_if
        if_battle_var_less 1, 8
                add_battle_var 1, 1
                move_forward_slow MONSTER_1
                attack BATTLE, SPECIAL, TENTACLE
                wait
                set_target RAND_CHAR
                attack BATTLE, BATTLE, STONE
                end_if
        if_battle_var_greater 1, 8
                attack MAGNITUDE8, AQUA_RAKE, MAGNITUDE8
                kill_monsters_wait MONSTER_1, SAND
                move_back_64 MONSTER_1
                show_monsters MONSTER_1, SAND
                set_battle_var 1, 0
                clr_battle_switch 0, 1
                end_if
        end

        if_hit
        if_battle_switch_clr 0, 4
        if_hp SELF, 10240
                battle_event RELM_ULTROS_INTRO
                set_battle_switch 0, 4
                if_self_dead
                        kill_monsters ALL, SAND
                        end_if
        if_attack TENTACLE
                dlg $50
; How can this be?
; I…I’m nothing more than a
; stupid octopus!
                kill_monsters ALL, SAND
                end_if
        if_battle_var_greater 3, 8
        if_battle_var_greater 1, 2
                set_battle_var 3, 0
                move_back_slow MONSTER_1
                sub_battle_var 1, 1
                end_if
        if_cmd FIGHT
                add_battle_var 3, 1
                end_if
        if_battle_switch_set 0, 3
        if_element FIRE
                attack FIRAGA
                end_if
        if_battle_switch_set 0, 3
        if_element ICE
                attack BLIZZAGA
                end_if
        if_battle_switch_set 0, 3
        if_element LIGHTNING
                attack THUNDAGA
                end_if
        if_battle_switch_set 0, 2
        if_cmd MAGIC
                add_battle_var 3, 4
                end_if
        if_cmd MAGIC
                add_battle_var 2, 1
                add_battle_var 3, 4
                if_battle_switch_clr 0, 2
                if_battle_var_greater 2, 4
                        set_battle_switch 0, 2
                        set_battle_switch 0, 3
                        flash_red MONSTER_1
                        dlg $01
; Ultros’s form has changed!
; Beware his tri-elemental attack!
                        end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script CHUPON_AIRSHIP
        attack BATTLE
        wait
        attack BATTLE, BATTLE, FIRE_BALL
        end

        if_self_dead
                set_target ALL_CHARS
                attack SNEEZE
                end_battle
                end_retal

; ------------------------------------------------------------------------------

ai_script SIEGFRIED_2
        if_battle_switch_clr 0, 0
                dlg $5d
; Go! Guys!!
;
                .repeat 8
                attack BATTLE
                .endrep
                dlg $5e
; Ha, ha, ha!
; Give up?
                toggle_battle_switch 0, 0
                end_if
        attack BATTLE
        end

        if_self_dead
                kill_monsters ALL, FADE_HORIZONTAL
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script HEAD
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                boss_death
                end_retal

; ------------------------------------------------------------------------------

ai_script WHELK_HEAD
        if_battle_switch_set 0, 0
        if_monster_timer 20
                show_monsters MONSTER_2, FADE_UP
                clr_battle_switch 0, 0
                end_if
        if_battle_var_greater 36, 2
                set_monster_var 0
                hide_monsters MONSTER_2, FADE_DOWN
                reset_monster_timer
                set_battle_switch 0, 0
                end_if
        if_battle_switch_clr 0, 0
                attack BATTLE, BATTLE, MEGA_VOLT
                wait
                attack BATTLE, EL_NINO, SPECIAL
                end

        if_battle_switch_clr 3, 0
        if_self_dead
                set_battle_switch 3, 0
                boss_death
                end_if
        if_hit
                add_monster_var 1
                end_retal

; ------------------------------------------------------------------------------

ai_script COLOSSUS
        if_cmd BLITZ, BUSHIDO
                set_target NOTHING
                attack BATTLE, SPECIAL, LODE_STONE
                wait
                attack FIRE_WALL, MAGNITUDE8, LODE_STONE
                end_if
        if_target_valid GAU
                set_target NOTHING
                attack BATTLE, FIRE_WALL, SPECIAL
                wait
                set_target NOTHING
                attack BATTLE, MAGNITUDE8, LODE_STONE
                wait
                set_target NOTHING
                attack BATTLE, BATTLE, FIRE_WALL
                end_if
        attack BATTLE, FIRE_WALL, SPECIAL
        wait
        attack BATTLE, BATTLE, FIRE_WALL
        end

        if_self_dead
                boss_death
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script CZARDRAGON
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MASTER_PUG
        if_monster_timer 15
                reset_monster_timer
                attack WALLCHANGE
                move_forward_fast MONSTER_3
                add_battle_var 3, 1
                if_battle_var_greater 3, 7
                        set_battle_var 3, 0
                        set_target RAND_CHAR
                        attack SPECIAL
                        kill_monsters_wait MONSTER_3, MATERIALIZE
                        move_back_64 MONSTER_3
                        show_monsters MONSTER_3, MATERIALIZE
                        end_if
        if_weak_element SELF, ICE
                set_target NOTHING
                attack NOTHING, FIRAGA, FIRAGA
                end_if
        if_weak_element SELF, FIRE
                set_target NOTHING
                attack NOTHING, BLIZZAGA, BLIZZAGA
                end_if
        if_weak_element SELF, WIND
                set_target NOTHING
                attack NOTHING, THUNDAGA, THUNDAGA
                end_if
        if_weak_element SELF, HOLY
                set_target ALL_CHARS
                attack NOTHING, BIO, BIO
                end_if
        if_weak_element SELF, LIGHTNING
                set_target NOTHING
                attack NOTHING, TORNADO, TORNADO
                end_if
        if_weak_element SELF, POISON
                set_target NOTHING
                attack NOTHING, HOLY, HOLY
                end_if
        if_weak_element SELF, WATER
                set_target NOTHING
                attack NOTHING, QUAKE, QUAKE
                end_if
        if_weak_element SELF, EARTH
                set_target NOTHING
                attack NOTHING, CLEANSWEEP, CLEANSWEEP
                end_if
        attack BATTLE
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack STEP_MINE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script MERCHANT
        attack BATTLE
        end

        if_cmd STEAL
                set_battle_switch 13, 4
                clr_battle_switch 13, 5
                hide_monsters MONSTER_1, INSTANT
                restore_monsters MONSTER_2, INSTANT
                battle_event STEAL_MERCHANT
                kill_monsters MONSTER_1, INSTANT
                end_retal

; ------------------------------------------------------------------------------

ai_script B_DAY_SUIT
        dlg $08
; Wh…whew!!
        set_target SELF
        attack ESCAPE, ESCAPE, ESCAPE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TENTACLE_1
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_4, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
                reset_monster_timer
                attack BATTLE, BIO, SPECIAL
                wait
                reset_monster_timer
                attack SPECIAL, ENTWINE, SPECIAL
                wait
                reset_monster_timer
                attack BATTLE, BIO, SPECIAL
                wait
                reset_monster_timer
                attack POISON, SPECIAL, ENTWINE
                end

        if_self_dead
        if_monster_switch_set 7
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TENTACLE_2
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_4, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
                reset_monster_timer
                attack BATTLE, BATTLE, SPECIAL
                wait
                reset_monster_timer
                attack BATTLE, ENTWINE, SPECIAL
                wait
                reset_monster_timer
                attack BATTLE, BIO, SPECIAL
                wait
                reset_monster_timer
                attack POISON, SPECIAL, ENTWINE
                end

        if_self_dead
        if_monster_switch_set 7
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TENTACLE_3
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_4, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
                reset_monster_timer
                attack BATTLE, BIO, SPECIAL
                wait
                reset_monster_timer
                attack BATTLE, ENTWINE, SPECIAL
                wait
                reset_monster_timer
                attack BATTLE, BATTLE, SPECIAL
                wait
                reset_monster_timer
                attack POISON, SPECIAL, ENTWINE
                end

        if_self_dead
        if_monster_switch_set 7
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script RIGHTBLADE
        if_monsters_dead MONSTER_4
        if_monster_timer 15
                restore_monsters MONSTER_4, FADE_DOWN
                end_if
        if_monsters_alive MONSTER_4
                attack BATTLE, BATTLE, SPECIAL
                end_if
        end

        if_self_dead
                restore_monsters MONSTER_4, INSTANT
                hide_monsters MONSTER_4, FADE_UP
                reset_monster_timer
                end_retal

; ------------------------------------------------------------------------------

ai_script LEFT_BLADE
        if_monsters_dead MONSTER_2
        if_monster_timer 30
                restore_monsters MONSTER_2, FADE_DOWN
                end_if
        if_monsters_alive MONSTER_2
                attack BATTLE, BATTLE, SHIMSHAM
                wait
                attack BATTLE, BATTLE, SPECIAL
                end_if
        end

        if_self_dead
                restore_monsters MONSTER_2, INSTANT
                hide_monsters MONSTER_2, FADE_UP
                reset_monster_timer
                end_retal

; ------------------------------------------------------------------------------

ai_script ROUGH
        if_monsters_dead MONSTER_4
        if_monster_timer 20
                restore_monsters MONSTER_4, FADE_DOWN
                end_if
        if_monsters_alive MONSTER_4
                attack BATTLE, BATTLE, SPECIAL
                end_if
        end

        if_self_dead
                restore_monsters MONSTER_4, INSTANT
                hide_monsters MONSTER_4, FADE_UP
                reset_monster_timer
                end_retal

; ------------------------------------------------------------------------------

ai_script STRIKER
        if_monsters_dead MONSTER_2
        if_monster_timer 40
                restore_monsters MONSTER_2, FADE_DOWN
                end_if
        if_monsters_alive MONSTER_2
                attack BATTLE, BATTLE, SHRAPNEL
                end_if
        end

        if_self_dead
                restore_monsters MONSTER_2, INSTANT
                hide_monsters MONSTER_2, FADE_UP
                reset_monster_timer
                end_retal

; ------------------------------------------------------------------------------

ai_script TRITOCH_BOSS
        attack RASP, RASP, BLIZZAGA
        wait
        attack BLIZZAGA, BLIZZAGA, RASP
        wait
        attack RASP, COLD_DUST, BLIZZAGA
        end

        if_self_dead
                boss_death
                end_if
        if_element FIRE
                attack NOTHING, NOTHING, RASP
                end_if
        if_cmd BUSHIDO, TOOLS
                set_target PREV_ATTACKER
                attack NOTHING, NOTHING, COLD_DUST
                end_if
        if_cmd BLITZ, LORE
                set_target PREV_ATTACKER
                attack NOTHING, NOTHING, COLD_DUST
                end_if
        if_cmd SKETCH, RAGE
                set_target PREV_ATTACKER
                attack NOTHING, NOTHING, COLD_DUST
                end_retal

; ------------------------------------------------------------------------------

ai_script LASER_GUN
        if_hp SELF, 1536
                set_target NOTHING
                attack DIFFUSER, DIFFUSER, TEK_LASER
                wait
                set_target NOTHING
                attack DIFFUSER, DIFFUSER, TEK_LASER
                end_if
        attack ATOMIC_RAY, TEK_LASER, TEK_LASER
        end

        if_self_dead
        if_num_monsters 2
                set_battle_switch 0, 0
                kill_monsters MONSTER_3, SMOKE
                end_retal

; ------------------------------------------------------------------------------

ai_script SPECK
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MISSILEBAY
        if_hp SELF, 1536
                set_target NOTHING
                attack MISSILE
                wait
                set_target NOTHING
                attack LAUNCHER, MISSILE, MISSILE
                wait
                set_target NOTHING
                attack LAUNCHER
                end_if
        attack MISSILE
        end

        if_self_dead
                kill_monsters MONSTER_5, SMOKE
                end_retal

; ------------------------------------------------------------------------------

ai_script CHADARNOOK_2
        if_monster_timer 40
                reset_monster_timer
                set_battle_var 3, 1
                show_monsters MONSTER_1, CHADARNOOK
                kill_monsters MONSTER_2, CHADARNOOK
                end_if
        if_hp SELF, 15360
                set_target NOTHING
                attack BATTLE, FLASH_RAIN, THUNDAGA
                wait
                set_target NOTHING
                attack FLASH_RAIN, THUNDAGA, FLASH_RAIN
                wait
                set_target NOTHING
                attack FLASH_RAIN, BATTLE, THUNDAGA
                wait
                set_target NOTHING
                attack FLASH_RAIN, THUNDAGA, BATTLE
                end_if
        attack BATTLE, BATTLE, THUNDAGA
        wait
        attack BATTLE, THUNDARA, NOTHING
        wait
        attack BATTLE, THUNDARA, THUNDAGA
        wait
        attack BATTLE, THUNDARA, NOTHING
        end_if
        end

        if_self_dead
                dlg $7a
; I…I’m…
; This can’t be……
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, THUNDARA
                add_battle_var 0, 1
                if_battle_var_greater 0, 4
                        set_battle_var 0, 0
                        set_battle_var 3, 0
                        show_monsters MONSTER_1, CHADARNOOK
                        kill_monsters MONSTER_2, CHADARNOOK
                        end_retal

; ------------------------------------------------------------------------------

ai_script ICE_DRAGON
        attack BATTLE, N_CROSS, N_CROSS
        wait
        attack BATTLE, ABSOLUTE0, ABSOLUTE0
        wait
        attack BATTLE, SURGE, ABSOLUTE0
        end_if
        end

        if_self_dead
                boss_death
                end_if
        if_self_dead
                reset_battle_timer
                attack NOTHING, NOTHING, SURGE
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script KEFKA_NARSHE
        attack BATTLE
        wait
        attack BATTLE, BATTLE, POISON
        wait
        attack BATTLE, BLIZZARA, THUNDER
        wait
        attack CONFUSE, DRAIN, BLIZZARD
        end

        if_self_dead
                dlg $15
; Don’t think you won.
; I’ll be back!
                set_target SELF
                attack ESCAPE
                end_retal

; ------------------------------------------------------------------------------

ai_script STORM_DRGN
        if_hp SELF, 15360
                set_target NOTHING
                attack BATTLE, BATTLE, AERO
                wait
                set_target NOTHING
                attack BATTLE, SPECIAL, CYCLONIC
                end_if
        attack BATTLE, WIND_SLASH, RAGE
        wait
        attack BATTLE, WIND_SLASH, BATTLE
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script DIRT_DRGN
        if_monster_timer 20
                reset_monster_timer
                if_status_set RAND_CHAR, FLOAT
                        set_target ALL_CHARS
                        attack FIFTY_GS
                        end_if
        attack BATTLE, QUAKE, QUAKE
        wait
        attack BATTLE, MAGNITUDE8, SLIDE
        wait
        attack BATTLE, MAGNITUDE8, QUAKE
        wait
        attack BATTLE, BATTLE, SLIDE
        end_if
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script IPOOH
        attack BATTLE, BATTLE, SPECIAL
        end

        if_monsters_dead {MONSTER_2, MONSTER_3}
                target_on MONSTER_1
                end_retal

; ------------------------------------------------------------------------------

ai_script LEADER
        attack BATTLE, BATTLE, SPECIAL
        end

        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

ai_script GRUNT
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script GOLD_DRGN
        if_battle_switch_set 0, 0
        if_battle_var_greater 3, 2
                clr_battle_switch 0, 0
                set_monster_var 0
                set_battle_var 3, 0
                set_target ALL_CHARS
                attack THUNDAGA
                end_if
        if_battle_switch_set 0, 0
                add_battle_var 3, 1
                end_if
        if_status_set CHAR_1, REFLECT
        if_status_clr CHAR_1, DEAD
        if_status_clr SELF, REFLECT
                attack REFLECT
                end_if
        if_status_set CHAR_2, REFLECT
        if_status_clr CHAR_2, DEAD
        if_status_clr SELF, REFLECT
                attack REFLECT
                end_if
        if_status_set CHAR_3, REFLECT
        if_status_clr CHAR_3, DEAD
        if_status_clr SELF, REFLECT
                attack REFLECT
                end_if
        if_status_set CHAR_4, REFLECT
        if_status_clr CHAR_4, DEAD
        if_status_clr SELF, REFLECT
                attack REFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target NOTHING
                attack BATTLE
                wait
                set_target SELF
                attack THUNDARA, THUNDARA, THUNDER
                wait
                clr_battle_switch 0, 1
                set_target NOTHING
                attack BATTLE
                wait
                set_target SELF
                attack NOTHING, THUNDARA, THUNDER
                clr_battle_switch 0, 1
                end_if
        attack GIGA_VOLT, THUNDER, THUNDARA
        wait
        attack GIGA_VOLT, THUNDER, THUNDER
        wait
        clr_battle_switch 0, 1
        attack THUNDARA, THUNDER, THUNDER
        end

        if_self_dead
                boss_death
                end_if
        if_cmd FIGHT
        if_battle_switch_clr 0, 0
                add_monster_var 1
                if_battle_var_greater 36, 4
                if_battle_switch_clr 0, 0
                        set_battle_switch 0, 0
                        dlg $73
; Gold Dragon begins to
; store energy!
                        end_if
        if_cmd MAGIC
        if_battle_switch_clr 0, 0
                attack NOTHING, THUNDER, THUNDARA
                end_retal

; ------------------------------------------------------------------------------

ai_script SKULL_DRGN
        set_target NOTHING
        attack BATTLE, CONDEMNED, ELF_FIRE
        wait
        set_target NOTHING
        attack BATTLE, CONDEMNED, SPECTER
        wait
        set_target NOTHING
        attack BATTLE, CONDEMNED, ELF_FIRE
        wait
        set_target RAND_CHAR
        attack DISASTER
        end

        if_self_dead
                kill_monsters SELF, BOSS_DEATH
                end_if
        if_hit
                attack NOTHING, BATTLE, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script BLUE_DRGN
        if_monster_switch_clr 0
                attack CLEANSWEEP
                set_monster_switch 0
                end_if
        if_battle_timer 40
                reset_battle_timer
                attack CLEANSWEEP
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_1, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, SAFE
                set_target SELF
                attack SLOW
                set_target CHAR_1
                attack RIPPLER
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_2, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, SAFE
                set_target SELF
                attack SLOW
                set_target CHAR_2
                attack RIPPLER
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_3, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, SAFE
                set_target SELF
                attack SLOW
                set_target CHAR_3
                attack RIPPLER
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_4, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, SAFE
                set_target SELF
                attack SLOW
                set_target CHAR_4
                attack RIPPLER
                set_monster_switch 1
                end_if
        if_hp SELF, 16384
                set_target NOTHING
                attack BATTLE, AQUA_RAKE, AQUA_RAKE
                wait
                set_target NOTHING
                attack BATTLE, FLASH_RAIN, FLASH_RAIN
                clr_monster_switch 1
                end_if
        attack BATTLE, ACID_RAIN, ACID_RAIN
        wait
        attack BATTLE, BATTLE, ACID_RAIN
        clr_monster_switch 1
        end

        if_self_dead
                kill_monsters SELF, BOSS_DEATH
                end_if
        if_cmd MAGIC
                attack NOTHING, NOTHING, BATTLE
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script RED_DRAGON
        if_monster_timer 40
                reset_monster_timer
                attack S_CROSS, L4_FLARE, FLARE_STAR
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_1, REFLECT
                set_target CHAR_1
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_2, REFLECT
                set_target CHAR_2
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_3, REFLECT
                set_target CHAR_3
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_4, REFLECT
                set_target CHAR_4
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_hp SELF, 10240
                set_target NOTHING
                attack FLARE, FIRAGA, FLARE
                wait
                set_target NOTHING
                attack FLARE, FIRAGA, FLARE
                clr_monster_switch 0
                end_if
        attack FIRA, FIRE_BALL, FIRA
        wait
        attack FIRA, FIRA, FIRE_BALL
        clr_monster_switch 0
        end

        if_self_dead
                kill_monsters SELF, BOSS_DEATH
                clr_monster_switch 0
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script PIRANHA
        attack BATTLE
        end

        if_self_dead
        if_battle_timer 60
        if_num_monsters 0
                hide_piranha
                restore_monsters MONSTER_6, WATER
                end_if
        if_num_monsters 0
        if_self_dead
        if_self_in_slot MONSTER_1
                hide_piranha
                restore_monsters {MONSTER_2, MONSTER_3, MONSTER_5}, WATER
                end_if
        if_num_monsters 0
        if_self_dead
        if_self_in_slot MONSTER_2
                hide_piranha
                restore_monsters {MONSTER_1, MONSTER_5}, WATER
                end_if
        if_num_monsters 0
        if_self_dead
        if_self_in_slot MONSTER_3
                hide_piranha
                restore_monsters {MONSTER_2, MONSTER_4, MONSTER_5}, WATER
                end_if
        if_num_monsters 0
        if_self_dead
        if_self_in_slot MONSTER_4
                hide_piranha
                restore_monsters {MONSTER_1, MONSTER_3}, WATER
                end_if
        if_num_monsters 0
        if_self_dead
        if_self_in_slot MONSTER_5
                hide_piranha
                restore_monsters {MONSTER_2, MONSTER_3, MONSTER_4}, WATER
                end_retal

; ------------------------------------------------------------------------------

ai_script RIZOPAS
        attack BATTLE, SPECIAL, MEGA_VOLT
        attack BATTLE, BLIZZARD, BLIZZARD
        wait
        attack EL_NINO, BATTLE, BATTLE
        end

        if_self_dead
                boss_death
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script SPECTER
        attack BLIZZARD, BATTLE, NOTHING
        wait
        attack BATTLE, BLIZZARD, NOTHING
        wait
        attack NOTHING, BATTLE, RAID
        end

        if_hit
                set_target PREV_ATTACKER
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script SHORT_ARM
        if_hp SELF, 10112
                set_target NOTHING
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE, BATTLE, NOTHING
        end

        if_hit
                attack BATTLE, BATTLE, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script LONG_ARM
        if_hp SELF, 10240
                set_target NOTHING
                attack BATTLE, BATTLE, NOTHING
                set_target NOTHING
                attack BATTLE, BATTLE, NOTHING
                end_if
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SHOCK_WAVE
        wait
        attack BATTLE, SHOCK_WAVE, SHOCK_WAVE
        end

        if_num_monsters 0
                set_target NOTHING
                attack NOTHING, SHOCK_WAVE, SHOCK_WAVE
                attack SHOCK_WAVE, NOTHING, SHOCK_WAVE
                attack SHOCK_WAVE, SHOCK_WAVE, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script FACE
        if_hp SELF, 10240
                set_target NOTHING
                attack SPECIAL, SPECIAL, DREAD
                wait
                set_target NOTHING
                attack SPECIAL, SPECIAL, DREAD
                wait
                set_target NOTHING
                attack SPECIAL, SPECIAL, DREAD
                set_target NOTHING
                attack SPECIAL, SPECIAL, DREAD
                wait
                set_target NOTHING
                attack DREAD, MAGNITUDE8, R_POLARITY
                end_if
        attack R_POLARITY, NOTHING, NOTHING
        wait
        attack SPECIAL, NOTHING, NOTHING
        wait
        attack R_POLARITY, NOTHING, NOTHING
        wait
        attack SPECIAL, NOTHING, NOTHING
        wait
        set_target RAND_OTHER_MONSTER
        attack SAFE, SAFE, HASTE
        wait
        set_target NOTHING
        attack SPECIAL, NOTHING, NOTHING
        end

        if_num_monsters 0
        if_self_dead
                set_target NOTHING
                attack QUAKE
                end_retal

; ------------------------------------------------------------------------------

ai_script TIGER
        if_hp SELF, 11520
                set_target NOTHING
                attack S_CROSS, N_CROSS, FLARE_STAR
                attack SPECIAL, NOTHING, NOTHING
                end_if
        attack NOTHING, NOTHING, NOTHING
        wait
        attack S_CROSS, FLARE_STAR, N_CROSS
        wait
        attack NOTHING, NOTHING, NOTHING
        wait
        attack BATTLE, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script TOOLS
        if_hp SELF, 11520
                set_target NOTHING
                attack DIFFUSER, GRAV_BOMB, TEK_LASER
                wait
                set_target NOTHING
                attack DIFFUSER, MISSILE, ABSOLUTE0
                wait
                set_target NOTHING
                attack DELTA_HIT, GRAV_BOMB, ABSOLUTE0
                end_if
        attack DIFFUSER, GRAV_BOMB, TEK_LASER
        wait
        attack DIFFUSER, MISSILE, ATOMIC_RAY
        wait
        attack DELTA_HIT, GRAV_BOMB, ATOMIC_RAY
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MAGIC
        if_hp SELF, 20096
                set_target NOTHING
                attack THUNDAGA, THUNDAGA, MUTE
                wait
                set_target NOTHING
                attack HOLY, FLARE, RASP
                wait
                set_target NOTHING
                attack FIRAGA, BLIZZARA, THUNDAGA
                end_if
        if_hp SELF, 30720
                set_target NOTHING
                attack REFLECT, STOP, RERAISE
                wait
                set_target NOTHING
                attack BLIZZAGA, THUNDAGA, SLEEP
                wait
                set_target NOTHING
                attack HOLY, FLARE, SLOW_2
                end_if
        set_target NOTHING
        attack HASTE2, HASTE, IMP
        wait
        attack FIRAGA, FIRAGA, CONFUSE
        wait
        attack POISON, DRAIN, BIO
        set_target RAND_CHAR
        attack DISPEL, NOTHING, NOTHING
        attack DISPEL, NOTHING, NOTHING
        end

        if_hp SELF, 5120
        if_hit
                set_target NOTHING
                attack QUARTR, NOTHING, NOTHING
                set_target RAND_CHAR
                attack DISPEL, DISPEL, NOTHING
                attack DISPEL, DISPEL, NOTHING
                end_if
        if_hp SELF, 10240
        if_hit
                set_target NOTHING
                attack QUARTR, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script HIT
        attack BATTLE
        end

        if_self_dead
                set_target NOTHING
                attack SPECIAL
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script GIRL
        if_num_monsters 1
                set_target ALL_DEAD_MONSTERS
                attack ARISE
                end_if
        attack WHITE_WIND, WHITE_WIND, NOTHING
        wait
        attack WHITE_WIND, SPECIAL, NOTHING
        wait
        attack WHITE_WIND, WHITE_WIND, NOTHING
        wait
        attack WHITE_WIND, SPECIAL, NOTHING
        wait
        attack WHITE_WIND, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SLEEP
        if_hp SELF, 10240
                set_target NOTHING
                attack METEO
                end_if
        attack TORNADO, MELTDOWN, NOTHING
        wait
        attack BATTLE, BATTLE, CONDEMNED
        end

        if_self_dead
                set_target NOTHING
                attack SPECIAL
                attack SPECIAL, NOTHING, NOTHING
                end_if
        if_hp SELF, 10240
        if_hit
                set_target NOTHING
                attack METEO, TRAIN, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script HIDONITE_1
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack NOTHING, BATTLE, BATTLE
        wait
        attack BATTLE, NOTHING, NOTHING
        wait
        attack SPECIAL, NOTHING, BATTLE
        end

        if_self_dead
                reset_battle_timer
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script HIDONITE_2
        attack BATTLE, NOTHING, NOTHING
        wait
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack NOTHING, BATTLE, BATTLE
        wait
        attack BATTLE, NOTHING, SPECIAL
        end

        if_self_dead
                reset_battle_timer
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script HIDONITE_3
        attack NOTHING, BATTLE, BATTLE
        wait
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack BATTLE, NOTHING, NOTHING
        wait
        attack BATTLE, NOTHING, SPECIAL
        end

        if_self_dead
                reset_battle_timer
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script SOULSAVER
        if_monsters_alive MONSTER_1
        if_status_clr SELF, REFLECT
                set_target SELF
                attack REFLECT
                end_if
        if_monster_switch_clr 0
        if_mp SELF, 16
                set_target NOTHING
                attack SPECIAL
                set_monster_switch 0
                end_if
        if_one_monster_type
                attack NOTHING, BLIZZAGA, THUNDAGA
                wait
                attack FIRAGA, NOTHING, THUNDAGA
                wait
                attack FIRAGA, BLIZZAGA, NOTHING
                clr_monster_switch 0
                end_if
        set_target MONSTER_1
        attack CURE, NOTHING, NOTHING
        end

        if_self_in_slot MONSTER_4
        if_monsters_dead MONSTER_4
                hide_monsters MONSTER_4, FADE_DOWN
                restore_monsters MONSTER_4, FADE_UP
                end_if
        if_self_in_slot MONSTER_5
        if_monsters_dead MONSTER_5
                hide_monsters MONSTER_5, FADE_DOWN
                restore_monsters MONSTER_5, FADE_UP
                end_if
        if_hit
                attack BATTLE, BATTLE, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script ULTROS_AIRSHIP
        if_monster_switch_clr 0
                dlg $51
; No, really,
; this is our LAST battle!
; Trust me!
                set_monster_switch 0
                end_if
        if_monster_switch_set 1
        if_monster_switch_clr 4
        if_battle_var_greater 0, 2
                dlg $56
; Ultros:
; I was drowsing the other day
; when Mr. Chupon gnawed on
; my head!
; He needed something to
; polish his teeth on!
                set_monster_switch 4
                end_if
        if_monster_switch_set 1
        if_monster_switch_clr 3
        if_battle_var_greater 0, 1
                dlg $52
; Ultros:
; Better not irritate him!
; He gets hungry when he’s
; irritated…
                set_monster_switch 3
                end_if
        if_monster_switch_set 1
        if_monster_switch_clr 2
        if_battle_var_greater 0, 0
                dlg $54
; Ultros:
; Mr. Chupon’s taciturn,
; but terribly powerful!
                set_monster_switch 2
                end_if
        if_monster_switch_set 1
                attack BATTLE, TENTACLE, SPECIAL
                wait
                attack BATTLE, TENTACLE, SPECIAL
                add_battle_var 0, 1
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, TENTACLE, SPECIAL
        end

        if_hit
        if_monster_switch_clr 1
        if_hp SELF, 12800
                dlg $53
; Ultros:
; I lose AGAIN!
; Well, today I’ve brought a pal!
; Mr. Chupon! Come on down!
                restore_monsters MONSTER_1, SIDE
                dlg $57
; Chupon:
; Fungahhh!
                set_monster_switch 1
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script NAUGHTY
        if_status_set SELF, IMP
                set_target SELF
                attack IMP
                attack ESCAPE
                end_if
        attack BATTLE, COLD_DUST, SPECIAL
        wait
        attack BATTLE, BATTLE, BLIZZARA
        wait
        attack BATTLE, BLIZZARA, SNOWSTORM
        end

        if_cmd MAGIC
                set_target PREV_ATTACKER
                attack NOTHING, NOTHING, ENEMY_MUTE
                end_retal

; ------------------------------------------------------------------------------

ai_script PHUNBABA_1
        if_battle_switch_clr 0, 0
                invincible_on SELF
                set_battle_switch 0, 0
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack THUNDARA, THUNDARA, THUNDAGA
        wait
        attack THUNDARA, BLOW_FISH, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script PHUNBABA_2
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack THUNDARA, THUNDARA, THUNDAGA
        wait
        attack THUNDARA, BLOW_FISH, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        if_hit
        if_hp SELF, 20480
                set_target SELF
                attack ESCAPE
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script PHUNBABA_3
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack THUNDARA, THUNDARA, THUNDAGA
        wait
        attack THUNDARA, BLOW_FISH, SPECIAL
        end

        if_self_dead
                set_target RAND_CHAR
                attack BABABREATH
                boss_death
                end_if
        if_hit
        if_hp SELF, 15360
                set_target RAND_CHAR
                attack BABABREATH
                set_target RAND_CHAR
                attack BABABREATH
                end_battle
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script PHUNBABA_4
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack THUNDARA, THUNDARA, THUNDAGA
        wait
        attack THUNDARA, BLOW_FISH, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack THUNDARA, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

ai_script TERRA_FLASHBACK
        attack FIRE_BEAM
        battle_event KEFKA_TERRA_INTRO
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script KEFKA_IMP_CAMP
        attack BATTLE
        end

        if_hit
                battle_event SABIN_KEFKA_IMPERIAL_CAMP
                end_battle
                end_retal

; ------------------------------------------------------------------------------

ai_script CYAN_IMP_CAMP
        attack DISPATCH, BATTLE, BATTLE
        end

        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

ai_script ZONE_EATER
        attack DEMI, ENGULF, ENGULF
        wait
        attack DEMI, ENGULF, ENGULF
        end

        if_cmd MAGIC
                attack NOTHING, NOTHING, ENGULF
                end_if
        if_cmd FIGHT
                attack NOTHING, NOTHING, COLD_DUST
                end_if
        end_retal

; ------------------------------------------------------------------------------

ai_script GAU_VELDT
        if_battle_switch_clr 13, 1
                dlg $23
; Ooh_I'm hungry!
                end_if
        recruit_gau
        dlg $24
; Uwao, aooh!  I'm Gau!
; I'm your friend!
; Let's travel together!
        end_veldt
        end

        if_item DRIED_MEAT
        if_battle_switch_clr 13, 1
                recruit_gau
                set_battle_switch 13, 1
                battle_event GAU_INTRO
                end_battle
                end_if
        if_hit
                battle_event GAU_RUNS_AWAY
                end_battle
                end_retal

; ------------------------------------------------------------------------------

ai_script KEFKA_VS_LEO
        attack BATTLE, BATTLE, POISON
        wait
        attack BATTLE, FIRAGA, THUNDER
        wait
        attack BIO, DRAIN, BIO
        end

        if_self_dead
                hide_monsters MONSTER_2, FADE_HORIZONTAL
                battle_event KEFKA_KILLS_LEO
                end_battle
                end_retal

; ------------------------------------------------------------------------------

ai_script KEFKA_ESPER_GATE
        if_battle_var_greater 0, 3
                set_battle_var 0, 0
                set_target SELF
                use_item TONIC, POTION
                end_if
        attack POISON, FIRA, DISCHORD
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, RASP, SLOW
        end

        if_self_dead
                dlg $4b
                end_battle
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                add_battle_var 0, 1
                end_retal

; ------------------------------------------------------------------------------

ai_script OFFICER
        attack BATTLE, BATTLE, BATTLE
        end

        if_cmd STEAL
                set_battle_switch 13, 5
                clr_battle_switch 13, 4
                hide_monsters MONSTER_3, INSTANT
                restore_monsters MONSTER_4, INSTANT
                battle_event STEAL_GREEN_SOLDIER
                kill_monsters MONSTER_3, INSTANT
                end_retal

; ------------------------------------------------------------------------------

ai_script CADET
        if_battle_id $003b
                attack BATTLE, BATTLE, SPECIAL
                end_if
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MONSTER_0177
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MONSTER_0178
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script SOLDIER_FLASHBACK
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script KEFKA_GENJU_MAGICITE
        set_target KEFKA_3
        attack FIRE
        attack FIRA
        attack FIRAGA
        battle_event KEFKA_GENJU_MAGICITE
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script EVENT
        target_off SELF
        if_battle_id $0180
                battle_event KEFKA_SEALED_GATE_1
                kill_monsters MONSTER_1, INSTANT
                end_if
        if_battle_id $0181
                battle_event KEFKA_SEALED_GATE_2
                end_battle
                end_if
        if_battle_id $0182
                battle_event AIRSHIP_GENJU
                end_battle
                end_if
        if_battle_id $0185
                battle_event THAMASA_SEALED_GATE
                end_battle
                end_if
        if_battle_id $0186
                battle_event UNUSED_BLITZ_TUTORIAL
                end_battle
                end_if
        if_battle_id $0189
                battle_event KEFKA_KILLS_GESTAHL
                end_battle
                end_if
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script MONSTER_017C
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script ATMA
        if_monster_switch_set 0
                dlg $83
; Unknown light surrounded Atma!
                short_glow MONSTER_1
                attack NOTHING
                wait
                short_glow MONSTER_1
                attack NOTHING
                wait
                long_glow MONSTER_1
                set_target NOTHING
                attack ULTIMA
                clr_monster_switch 0
                end_if
        if_hp SELF, 32640
                set_target NOTHING
                attack FIRAGA, CLEANSWEEP, QUAKE
                wait
                set_target NOTHING
                attack FIRAGA, METEOR, FLARE_STAR
                wait
                set_target NOTHING
                attack METEOR, QUAKE, CLEANSWEEP
                wait
                set_target NOTHING
                attack FIRAGA, FIRAGA, FLARE_STAR
                end_if
        if_monster_switch_clr 3
                dlg $8b
                long_glow MONSTER_1
                set_monster_switch 3
                end_if
        attack FIRAGA, BLIZZAGA, S_CROSS
        wait
        attack THUNDAGA, BLIZZAGA, FIRAGA
        wait
        attack THUNDAGA, THUNDAGA, S_CROSS
        wait
        attack FIRAGA, N_CROSS, N_CROSS
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                if_monster_switch_clr 0
                attack BATTLE, NOTHING, NOTHING
                add_battle_var 3, 1
                if_battle_var_greater 3, 12
                        set_monster_switch 0
                        set_battle_var 3, 0
                        end_retal

; ------------------------------------------------------------------------------

ai_script SHADOW_COLOSSEUM
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

ai_script COLOSSEUM
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

        end_fixed_block

; ------------------------------------------------------------------------------

.delmac attack
.delmac set_target
.delmac dlg
.delmac if_hit
.delmac if_level_greater
.delmac wait
.delmac end

; ------------------------------------------------------------------------------
