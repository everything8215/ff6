; ------------------------------------------------------------------------------

.segment "ai_script"

; ------------------------------------------------------------------------------

AI_SCRIPT_ARRAY_LENGTH = 384

; cf/8400
AIScriptPtr:
        make_ptr_tbl_rel AIScript, AI_SCRIPT_ARRAY_LENGTH

; cf/8700
.if LANG_EN
begin_block AIScript, $3950
.else
begin_block AIScript, $4100
.endif

; ------------------------------------------------------------------------------

; guard
AIScript_0000:
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; lobo
AIScript_0019:
        if_level_greater RAND_CHAR, 7
                attack BATTLE, SPECIAL, NOTHING
                attack SPECIAL, NOTHING, NOTHING
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; vomammoth
AIScript_001b:
        if_level_greater RAND_CHAR, 5
                set_target ALL_CHARS
                attack BLIZZARD
                wait
                attack BATTLE, NOTHING, SPECIAL
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; were-rat
AIScript_0013:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; vaporite
AIScript_0046:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; repo man
AIScript_004d:
        attack BATTLE, BATTLE, SPECIAL
        wait
        end

        if_hit
                set_target SELF
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; marshal
AIScript_0064:
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

; leafer
AIScript_0017:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; dark wind
AIScript_0028:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; sand ray
AIScript_005c:
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; areneid
AIScript_005d:
        if_level_greater TERRA, 7
                attack BATTLE, SPECIAL, NOTHING
                wait
                attack BATTLE
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; hornet
AIScript_002e:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; crawly
AIScript_0062:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack SPECIAL, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; bleary
AIScript_0063:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; rhodox
AIScript_0012:
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; rhinotaur
AIScript_0015:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd MAGIC
                attack MEGA_VOLT, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; greasemonk
AIScript_00a8:
        if_num_monsters 1
                attack BATTLE, SPECIAL, SPECIAL
                end_if
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; brawler
AIScript_000b:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; trilium
AIScript_0032:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; tusker
AIScript_007a:
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; cirpius
AIScript_0086:
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

; pterodon
AIScript_0022:
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

; nautiloid
AIScript_0038:
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

; exocite
AIScript_0039:
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

; heavyarmor
AIScript_009f:
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

; commander
AIScript_0011:
        if_num_monsters 1
                attack SPECIAL
                attack BATTLE, BATTLE, NOTHING
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; vector pup
AIScript_0071:
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

; trilobiter
AIScript_0036:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; primordite
AIScript_0094:
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

; gold bear
AIScript_00f5:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; dark side
AIScript_0060:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; spectre
AIScript_00b6:
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack FIRE, ICE, BOLT
        wait
        attack SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; rinn
AIScript_00cf:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; 1st class
AIScript_00ef:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; wild rat
AIScript_00f4:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; stray cat
AIScript_0018:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; beakor
AIScript_0029:
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

; crasshoppr
AIScript_002f:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; rhobite
AIScript_0076:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; soldier
AIScript_0001:
        attack BATTLE
        end

        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; templar
AIScript_0002:
        attack BATTLE
        end

        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; doberman
AIScript_001a:
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

; m-tekarmor
AIScript_0042:
        attack SPECIAL, SPECIAL, TEK_LASER
        end

        if_battle_switch_set 12, 1
        if_cmd MAGIC
        if_battle_switch_clr 9, 1
                toggle_battle_switch 9, 1
                battle_event $06
                end_retal

; ------------------------------------------------------------------------------

; telstar
AIScript_0044:
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

; ghost
AIScript_005a:
        attack FIRE, FIRE, NOTHING
        wait
        attack BATTLE, SPECIAL, FIRE_WALL
        end

        end_retal

; ------------------------------------------------------------------------------

; poplium
AIScript_00a2:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; hazer
AIScript_0008:
        attack DRAIN, NOTHING, NOTHING
        wait
        attack SPECIAL, DRAIN, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; whisper
AIScript_000e:
        set_target RAND_CHAR
        attack DEMI, BATTLE, NOTHING
        wait
        attack BATTLE, DEMI, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; over-mind
AIScript_000f:
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        wait
        attack DREAD, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; bomb
AIScript_004f:
        attack BLAZE, NOTHING, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack EXPLODER, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; stillgoing
AIScript_00ba:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; anguiform
AIScript_003a:
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

; aspik
AIScript_0059:
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

; actaneon
AIScript_005e:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; fidor
AIScript_001c:
        if_num_monsters 1
                attack SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        end

        end_retal

; ------------------------------------------------------------------------------

; rider
AIScript_003f:
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

; trooper
AIScript_0065:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; bounty man
AIScript_0079:
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

; red fang
AIScript_0078:
        if_num_monsters 1
                attack SPECIAL, BATTLE, BATTLE
                end_if
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; vulture
AIScript_002a:
        if_num_monsters 1
                attack SPECIAL, SHIMSHAM, SHIMSHAM
                end_if
        attack BATTLE, SHIMSHAM, BATTLE
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; iron fist
AIScript_006c:
        if_num_monsters 1
                attack BATTLE, STONE, STONE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; mind candy
AIScript_008c:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_num_monsters 1
        if_cmd STEAL, CAPTURE
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; over grunk
AIScript_0090:
        if_num_monsters 1
                attack BATTLE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; fossilfang
AIScript_0023:
        attack BATTLE, SAND_STORM, SPECIAL
        end

        if_cmd FIGHT
                attack SAND_STORM, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; harvester
AIScript_004e:
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

; slamdancer
AIScript_0052:
        if_one_monster_type
                attack FIRE_2, ICE_2, BOLT_2
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; hadesgigas
AIScript_0053:
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

; gabbldegak
AIScript_00df:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, VANISH
        end

        end_retal

; ------------------------------------------------------------------------------

; sewer rat
AIScript_0073:
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

; vermin
AIScript_00d1:
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

; grenade
AIScript_00aa:
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

; wyvern
AIScript_0081:
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

; joker
AIScript_006b:
        if_num_monsters 1
                attack BATTLE, BOLT_2, BOLT_2
                end_if
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, ACID_RAIN, NOTHING
        wait
        attack BATTLE, ACID_RAIN, ACID_RAIN
        end

        end_retal

; ------------------------------------------------------------------------------

; ralph
AIScript_007b:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; chickenlip
AIScript_003d:
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

; weedfeeder
AIScript_008d:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; bug
AIScript_00e8:
        attack BATTLE
        end

        if_num_monsters 1
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; pipsqueak
AIScript_0041:
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

; commando
AIScript_00c7:
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; garm
AIScript_00cb:
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; protoarmor
AIScript_0165:
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

; flan
AIScript_0047:
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

; general
AIScript_0066:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, CURE_2
        end

        end_retal

; ------------------------------------------------------------------------------

; rhinox
AIScript_0075:
        if_one_monster_type
                attack BATTLE, BATTLE, LIFE_3
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; gobbler
AIScript_0088:
        if_num_monsters 1
                attack SHIMSHAM
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; chaser
AIScript_00a0:
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
        if_cmd SWDTECH, BLITZ
                set_battle_switch 0, 0
                end_retal

; ------------------------------------------------------------------------------

; trapper
AIScript_002d:
        attack SPECIAL, L5_DOOM, NOTHING
        wait
        attack SPECIAL, L4_FLARE, NOTHING
        wait
        attack SPECIAL, L3_MUDDLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; mag roader
AIScript_0006:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack FIRE, FIRE_2, FIRE_2
        end

        end_retal

; ------------------------------------------------------------------------------

; mag roader
AIScript_00af:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack ICE, ICE_2, ICE_2
        end

        end_retal

; ------------------------------------------------------------------------------

; mega armor
AIScript_0102:
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

; sp forces
AIScript_00c2:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; cephaler
AIScript_0096:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack TENTACLE, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; baskervor
AIScript_001d:
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

; chimera
AIScript_001f:
        if_num_monsters 1
                attack BATTLE, BATTLE, BLIZZARD
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

; balloon
AIScript_00de:
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

; slurm
AIScript_00b8:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; insecare
AIScript_00d0:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; adamanchyt
AIScript_00d6:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd FIGHT
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; abolisher
AIScript_00eb:
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        wait
        attack BATTLE
        wait
        attack PEARL_WIND
        end

        end_retal

; ------------------------------------------------------------------------------

; mandrake
AIScript_00ee:
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

; coelecite
AIScript_00b3:
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

; ing
AIScript_0048:
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

; apparite
AIScript_006e:
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

; zombone
AIScript_0082:
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

; lich
AIScript_00e5:
        if_num_monsters 1
                attack FIRE_3, FIRE_3, NOTHING
                end_if
        attack FIRE, FIRE, SPECIAL
        wait
        attack FIRE, FIRE_2, FIRE_2
        wait
        attack FIRE, FIRE_2, FIRE_2
        wait
        attack FIRE, FIRE, SPECIAL
        wait
        attack FIRE, FIRE_2, FIRE_3
        end

        end_retal

; ------------------------------------------------------------------------------

; sky armor
AIScript_0043:
        if_num_monsters 1
                attack SPECIAL, TEK_LASER, MISSILE
                end_if
        attack TEK_LASER, TEK_LASER, NOTHING
        wait
        attack TEK_LASER, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; spit fire
AIScript_00e3:
        if_num_monsters 1
                attack DIFFUSER, NOTHING, NOTHING
                end_if
        attack ABSOLUTE0, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; behemoth
AIScript_0020:
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

; apokryphos
AIScript_000c:
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_num_monsters 1
        if_hit
                attack L5_DOOM, L4_FLARE, L3_MUDDLE
                end_retal

; ------------------------------------------------------------------------------

; ninja
AIScript_0003:
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

; brainpan
AIScript_004a:
        if_num_monsters 1
                attack BATTLE, BATTLE, BLOW_FISH
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; misfit
AIScript_00a4:
        attack BATTLE, BATTLE, LIFESHAVER
        wait
        attack BATTLE, LIFESHAVER, LIFESHAVER
        wait
        attack SPECIAL, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; wirey drgn
AIScript_00d8:
        if_num_monsters 1
                attack BATTLE, BATTLE, CYCLONIC
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; dragon
AIScript_0083:
        attack BATTLE, BATTLE, REVENGE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, BLIZZARD
        wait
        attack BATTLE, BATTLE, COLD_DUST
        end

        if_self_dead
                end_if
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; gigantos
AIScript_00ae:
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

; peepers
AIScript_0072:
        attack BATTLE, PEARL_WIND, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; earthguard
AIScript_00b2:
        attack SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; black drgn
AIScript_00d5:
        attack BATTLE, BATTLE, SAND_STORM
        wait
        attack BATTLE, SPECIAL, SAND_STORM
        end

        end_retal

; ------------------------------------------------------------------------------

; mesosaur
AIScript_0021:
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

; gilomantis
AIScript_0031:
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; chitonid
AIScript_007c:
        attack BATTLE, BATTLE, SPECIAL
        end

        if_num_monsters 1
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; gigan toad
AIScript_0098:
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

; lunaris
AIScript_00ca:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; osprey
AIScript_00e6:
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

; hermitcrab
AIScript_002c:
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

; intangir
AIScript_00a3:
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

; scorpion
AIScript_00e1:
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

; pm stalker
AIScript_00c0:
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

; delta bug
AIScript_0030:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, MEGA_VOLT
        end

        end_retal

; ------------------------------------------------------------------------------

; lizard
AIScript_003c:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; bloompire
AIScript_0035:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BIO, BIO, BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; buffalax
AIScript_0058:
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

; cactrot
AIScript_004c:
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

; nohrabbit
AIScript_00c3:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        if_cmd FIGHT
                set_target RAND_CHAR
                attack CURE, CURE_2, REMEDY
                end_retal

; ------------------------------------------------------------------------------

; latimeria
AIScript_00b9:
        attack MAGNITUDE8, NOTHING, NOTHING
        wait
        attack SPECIAL, MAGNITUDE8, MAGNITUDE8
        end

        end_retal

; ------------------------------------------------------------------------------

; maliga
AIScript_0097:
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

; sand horse
AIScript_005f:
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack SAND_STORM, SAND_STORM, NOTHING
        wait
        attack SPECIAL, SAND_STORM, SAND_STORM
        end

        end_retal

; ------------------------------------------------------------------------------

; humpty
AIScript_0049:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; cruller
AIScript_004b:
        attack FIRE_2, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SLIMER
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; dante
AIScript_00d7:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE
        end

        if_self_dead
                end_if
        if_cmd MAGIC
                attack L3_MUDDLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; drop
AIScript_008b:
        attack SPECIAL, SPECIAL, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

; neckhunter
AIScript_00a9:
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

; harpiai
AIScript_0089:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, AERO
        wait
        attack BATTLE, BATTLE, PEARL_WIND
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; muus
AIScript_00db:
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

; bogy
AIScript_00d3:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; deep eye
AIScript_00a7:
        attack BATTLE, BATTLE, SPECIAL
        wait
        set_target SELF
        attack NOTHING, NOTHING, ESCAPE
        end

        end_retal

; ------------------------------------------------------------------------------

; hoover
AIScript_003e:
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

; orog
AIScript_0005:
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

; osteosaur
AIScript_0010:
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, CHOKESMOKE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; mad oscar
AIScript_0061:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SOUR_MOUTH
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; powerdemon
AIScript_006f:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, SOUL_OUT
        end

        end_retal

; ------------------------------------------------------------------------------

; exoray
AIScript_0091:
        if_num_monsters 1
                attack BATTLE, BATTLE, VIRITE
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; siegfried
AIScript_0037:
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; chupon
AIScript_0040:
        attack SNEEZE
        end

        end_retal

; ------------------------------------------------------------------------------

; pug
AIScript_0054:
        attack STEP_MINE
        end

        if_hit
                attack SPECIAL
                attack STEP_MINE
                end_retal

; ------------------------------------------------------------------------------

; kiwok
AIScript_00cd:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; poppers
AIScript_00c9:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, STONE
        end

        end_retal

; ------------------------------------------------------------------------------

; tomb thumb
AIScript_009e:
        if_num_monsters 1
                attack IMP_SONG
                end_if
        attack BATTLE, BATTLE, NOTHING
        set_target SELF
        attack SPECIAL, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; ceritops
AIScript_00c6:
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; anemone
AIScript_00b4:
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

; punisher
AIScript_00dd:
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

; ursus
AIScript_0014:
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

; luridan
AIScript_008e:
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

; borras
AIScript_00f2:
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

; scrapper
AIScript_00c5:
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

; toe cutter
AIScript_008f:
        attack BATTLE, BATTLE, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; rhyos
AIScript_007e:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack SPECIAL
        attack BLIZZARD, FIRE_BALL, GIGA_VOLT
        attack MAGNITUDE8, AQUA_RAKE, GIGA_VOLT
        attack MAGNITUDE8, BLIZZARD, FIRE_BALL
        end

        if_self_dead
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; red wolf
AIScript_00f8:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; test rider
AIScript_009c:
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

; wizard
AIScript_00c4:
        attack MUTE, OSMOSE, NOTHING
        wait
        attack RASP, STOP, NOTHING
        wait
        attack MUDDLE, SLEEP, NOTHING
        end

        if_cmd MAGIC
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; nastidon
AIScript_00ce:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; psychot
AIScript_00da:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; mag roader
AIScript_00e7:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack ICE, ICE_2, ICE_2
        end

        end_retal

; ------------------------------------------------------------------------------

; mag roader
AIScript_00f3:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack FIRE, FIRE_2, FIRE_2
        end

; *** bug ***
        set_ai_script_mode NORMAL

; ------------------------------------------------------------------------------

; wild cat
AIScript_0077:
        if_num_monsters 1
                attack FIRE_BALL, NOTHING, NOTHING
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; crusher
AIScript_0092:
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

; vindr
AIScript_00cc:
        if_num_monsters 1
                attack BATTLE, BATTLE, SPECIAL
                end_if
        attack BATTLE
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; souldancer
AIScript_00ad:
        throw_item DIRK, MITHRILKNIFE
        wait
        throw_item MITHRILKNIFE, GUARDIAN
        wait
        throw_item AIR_LANCET, THIEFKNIFE
        wait
        throw_item THIEFKNIFE, ASSASSIN
        end

        if_hit
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; dahling
AIScript_0009:
        attack SPECIAL, MUTE, NOTHING
        wait
        attack ICE_2, BOLT_2, NOTHING
        end

        if_self_dead
                end_if
        if_hit
                attack CURE_2, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; nightshade
AIScript_0033:
        attack BATTLE, BATTLE, CHARM
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; still life
AIScript_0050:
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

; slatter
AIScript_0074:
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; hipocampus
AIScript_00b5:
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

; warlock
AIScript_0069:
        if_num_monsters 1
                attack PEARL
                end_if
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack SPECIAL, SPECIAL, PEARL
        end

        end_retal

; ------------------------------------------------------------------------------

; displayer
AIScript_0070:
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, BATTLE, CHOKESMOKE
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; cluck
AIScript_009a:
        if_num_monsters 1
                attack BATTLE, BATTLE, QUAKE
                end_if
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; eland
AIScript_00a5:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; opinicus
AIScript_00c8:
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

; goblin
AIScript_006d:
        if_num_monsters 1
                attack L5_DOOM, L4_FLARE, L3_MUDDLE
                wait
                attack BLAZE, NOTHING, NOTHING
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; lethal wpn
AIScript_0045:
        if_num_monsters 1
                attack DIFFUSER, LAUNCHER, MISSILE
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; boxed set
AIScript_0051:
        if_num_monsters 1
                attack BATTLE, METEO, COLD_DUST
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; enuo
AIScript_00a6:
        if_num_monsters 1
                attack CLEANSWEEP, AQUA_RAKE, SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; figaliz
AIScript_0057:
        if_num_monsters 1
                attack DISCHORD, RAID, SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; samurai
AIScript_0004:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; rain man
AIScript_000a:
        if_num_monsters 1
                attack BATTLE, BOLT_3, BOLT_3
                end_if
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, FLASH_RAIN, FLASH_RAIN
        end

        end_retal

; ------------------------------------------------------------------------------

; suriander
AIScript_001e:
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

; allosaurus
AIScript_0085:
        attack SPECIAL, NOTHING, VIRITE
        end

        end_retal

; ------------------------------------------------------------------------------

; parasite
AIScript_00b1:
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

; pan dora
AIScript_00ac:
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

; barb-e
AIScript_00be:
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

; critic
AIScript_00ab:
        attack BATTLE, ROULETTE, SPECIAL
        wait
        attack BATTLE, PEARL_LORE, LULLABY
        wait
        attack BATTLE, BATTLE, CONDEMNED
        end

        end_retal

; ------------------------------------------------------------------------------

; sky cap
AIScript_0095:
        if_num_monsters 1
                attack SPECIAL, TEK_LASER, MISSILE
                end_if
        attack TEK_LASER, TEK_LASER, R_POLARITY
        wait
        attack TEK_LASER, R_POLARITY, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; plutoarmor
AIScript_009d:
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

; io
AIScript_00fe:
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

; tyranosaur
AIScript_0027:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, METEOR
        wait
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; brachosaur
AIScript_0026:
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

; reach frog
AIScript_003b:
        attack BATTLE, BATTLE, SPECIAL
        wait
        cmd JUMP
        wait
        attack BATTLE, BATTLE, RIPPLER
        end

        end_retal

; ------------------------------------------------------------------------------

; crawler
AIScript_005b:
        if_num_monsters 1
                attack DISCHORD, RAID, SPECIAL
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; tumbleweed
AIScript_0034:
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

; mantodea
AIScript_00d2:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack SPECIAL, BATTLE, BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; geckorex
AIScript_0099:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; sprinter
AIScript_0087:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, PEARL_WIND
        end

        end_retal

; ------------------------------------------------------------------------------

; spek tor
AIScript_00b0:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; harpy
AIScript_002b:
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

; prussian
AIScript_00d4:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, SPECIAL, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; gloomshell
AIScript_008a:
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

; phase
AIScript_00bc:
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

; parasoul
AIScript_00bf:
        if_num_monsters 1
                attack BATTLE, EL_NINO, EL_NINO
                end_if
        attack BATTLE, SPECIAL, NOTHING
        wait
        attack BATTLE, FLASH_RAIN, FLASH_RAIN
        end

        end_retal

; ------------------------------------------------------------------------------

; chaos drgn
AIScript_00e2:
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

; sea flower
AIScript_00e9:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; aquila
AIScript_00ec:
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

; necromancr
AIScript_00f1:
        if_num_monsters 1
                attack DOOM, X_ZONE, FLARE
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

; trixter
AIScript_00f7:
        if_status_set ALL_MONSTERS, REFLECT
                attack FIRE, FIRE_2, FIRE_3
                end_if
        if_status_set ALL_CHARS, REFLECT
                attack CURE_2, RFLECT, HASTE
                end_if
        attack FIRE_2, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; white drgn
AIScript_0024:
        attack PEARL, PEARL, NOTHING
        attack PEARL, PEARL, NOTHING
        attack PEARL, NOTHING, NOTHING
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

; uroburos
AIScript_0093:
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

; covert
AIScript_0067:
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

; wart puck
AIScript_007d:
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                end_if
        if_hit
                attack SNEEZE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; woolly
AIScript_00fa:
        attack SPECIAL, NOTHING, NOTHING
        end

        if_cmd FIGHT
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

; karkass
AIScript_00dc:
        attack SPECIAL, NOTHING, NOTHING
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack BATTLE, NOTHING, NOTHING
                end_if
        if_cmd MAGIC
                attack BOLT_3, BREAK, FLARE
                end_if
        if_hit
                attack LIFESHAVER
                end_retal

; ------------------------------------------------------------------------------

; tap dancer
AIScript_00f0:
        attack BATTLE, BATTLE, SPECIAL
        end

        if_cmd THROW
                throw_item ENHANCER, CRYSTAL
                end_retal

; ------------------------------------------------------------------------------

; ogor
AIScript_0068:
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

; magic urn
AIScript_0055:
        if_status_set ALL_CHARS, DEAD
                attack LIFE, LIFE, LIFE_2
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

; l.10 magic
AIScript_0132:
        attack FIRE, ICE, BOLT
        end

        if_self_dead
                end_if
        if_hit
                attack SLOW, STOP, HASTE
                end_retal

; ------------------------------------------------------------------------------

; l.20 magic
AIScript_0130:
        attack DEMI, QUARTR, BREAK
        wait
        attack DEMI, QUARTR, X_ZONE
        end

        if_self_dead
                end_if
        if_hit
                attack RASP, MUDDLE, SAFE
                end_retal

; ------------------------------------------------------------------------------

; l.30 magic
AIScript_0125:
        attack FIRE_2, ICE_2, BOLT_2
        end

        if_self_dead
                end_if
        if_hit
                attack IMP, OSMOSE, RFLECT
                end_retal

; ------------------------------------------------------------------------------

; l.40 magic
AIScript_012b:
        attack DRAIN, BREAK, VANISH
        end

        if_self_dead
                end_if
        if_hit
                attack MUTE, SLEEP, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; l.50 magic
AIScript_0133:
        attack POISON, BIO, DOOM
        wait
        set_target ALL_MONSTERS
        attack REMEDY, DISPEL, DISPEL
        end

        if_self_dead
                end_if
        if_hit
                attack BSERK, SLOW, HASTE2
                end_retal

; ------------------------------------------------------------------------------

; l.60 magic
AIScript_0139:
        attack QUAKE, W_WIND, PEARL
        end

        if_self_dead
                end_if
        if_hit
                attack OSMOSE, SLOW_2, REGEN
                end_retal

; ------------------------------------------------------------------------------

; l.70 magic
AIScript_0143:
        attack FIRE_3, ICE_3, BOLT_3
        end

        if_self_dead
                end_if
        if_hit
                attack SLEEP, RASP, SHELL
                end_retal

; ------------------------------------------------------------------------------

; l.80 magic
AIScript_0163:
        if_status_set ALL_CHARS, REFLECT
                attack CURE_2, REMEDY, HASTE
                end_if
        if_status_set ALL_MONSTERS, REFLECT
                attack FIRE_3, ICE_3, BOLT_3
                end_if
        attack BIO, BIO, POISON
        end

        if_self_dead
                end_if
        if_hit
        if_status_set ALL_CHARS, REFLECT
                attack CURE_3, CURE, LIFE_3
                end_if
        if_hit
        if_status_set ALL_MONSTERS, REFLECT
                attack STOP, DISPEL, PEARL
                end_retal

; ------------------------------------------------------------------------------

; l.90 magic
AIScript_0164:
        attack METEOR, MERTON, FLARE
        wait
        attack METEOR, MERTON, FLARE
        wait
        attack METEOR, MERTON, FLARE
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
                attack STOP, BOLT_3, LIFE_3
                end_retal

; ------------------------------------------------------------------------------

; magimaster
AIScript_0166:
        if_status_set ALL_MONSTERS, REFLECT
                attack FIRE_3, ICE_3, BOLT_3
                end_if
        attack FIRE_2, ICE_2, BOLT_2
        wait
        attack FIRE_3, ICE_3, BOLT_3
        wait
        attack FIRE_3, ICE_3, BOLT_3
        attack FIRE_3, ICE_3, BOLT_3
        wait
        attack FIRE_3, ICE_3, BOLT_3
        attack FIRE_3, ICE_3, BOLT_3
        wait
        attack FIRE_3, ICE_3, BOLT_3
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

; ironhitman
AIScript_00fd:
        attack SPECIAL, DISCHORD, BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; junk
AIScript_00ed:
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

; fortis
AIScript_00ea:
        attack SNOWBALL, FIRE_BALL, MISSILE
        end

        if_element LIGHTNING
        if_hit
                attack SPECIAL
                attack BATTLE
                end_retal

; ------------------------------------------------------------------------------

; dueller
AIScript_00d9:
        attack L5_DOOM, L4_FLARE, SPECIAL
        end

        if_self_dead
                end_if
        if_hit
                attack SHRAPNEL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; innoc
AIScript_00f6:
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

; sky base
AIScript_00fc:
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

; guardian
AIScript_0112:
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

; prometheus
AIScript_0105:
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

; scullion
AIScript_00a1:
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

; veteran
AIScript_00fb:
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

; didalos
AIScript_00f9:
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

; mover
AIScript_0056:
        if_num_monsters 1
                attack BIG_GUARD, BLOW_FISH, BLOW_FISH
                end_if
        attack BATTLE, BATTLE, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; retainer
AIScript_0007:
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

; dark force
AIScript_000d:
        attack CONDEMNED, ROULETTE, AQUA_RAKE
        wait
        attack REVENGE, PEARL_WIND, L5_DOOM
        wait
        attack L4_FLARE, L3_MUDDLE, REFLECT_LORE
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

; steroidite
AIScript_0016:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack GIGA_VOLT, BLIZZARD, COLD_DUST
        wait
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack GIGA_VOLT, BLIZZARD, COLD_DUST
        wait
        attack N_CROSS, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; outsider
AIScript_00bd:
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

; hemophyte
AIScript_00c1:
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

; madam
AIScript_006a:
        if_status_set ALL_MONSTERS, REFLECT
                attack CURE_3
                end_if
        attack PEARL, FLARE, IMP
        wait
        attack CURE_2, LIFE_3, SAFE
        attack SPECIAL, SPECIAL, NOTHING
        wait
        attack CURE_2, LIFE_3, SAFE
        attack FIRE_3, ICE_3, BOLT_3
        wait
        attack REMEDY, CURE_2, SHELL
        attack FIRE_3, ICE_3, BOLT_3
        wait
        attack REGEN, REMEDY, HASTE
        attack FIRE_3, ICE_3, BOLT_3
        end

        if_self_dead
                end_if
        if_hit
                set_target NOTHING
                attack CURE_2, NOTHING, NOTHING
                attack METEOR, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; vectaur
AIScript_0080:
        attack BATTLE
        wait
        attack BATTLE, FIRE_BALL, SPECIAL
        end

        end_retal

; ------------------------------------------------------------------------------

; evil oscar
AIScript_00b7:
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

; land worm
AIScript_009b:
        attack MAGNITUDE8, MAGNITUDE8, LODE_STONE
        wait
        attack MAGNITUDE8, MAGNITUDE8, LODE_STONE
        wait
        attack MAGNITUDE8, SPECIAL, LODE_STONE
        end

        end_retal

; ------------------------------------------------------------------------------

; vectagoyle
AIScript_00e4:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack GIGA_VOLT, BLIZZARD, BLAZE
        wait
        attack AQUA_RAKE, BLIZZARD, BATTLE
        wait
        attack AQUA_RAKE, GIGA_VOLT, BLAZE
        end

        if_self_dead
                end_if
        if_cmd FIGHT
                attack SPECIAL, SPECIAL, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; brontaur
AIScript_0084:
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

; gtbehemoth
AIScript_00e0:
        attack BATTLE, BATTLE, NOTHING
        wait
        attack BATTLE, BATTLE, METEOR
        end

        if_hit
                set_target NOTHING
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; doom drgn
AIScript_0025:
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

; allo ver
AIScript_00bb:
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

; srbehemoth
AIScript_007f:
        if_status_set CHAR_SLOT_1, SLEEP
        if_status_clr CHAR_SLOT_1, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_SLOT_1
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_if
        if_status_set CHAR_SLOT_2, SLEEP
        if_status_clr CHAR_SLOT_2, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_SLOT_2
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_if
        if_status_set CHAR_SLOT_3, SLEEP
        if_status_clr CHAR_SLOT_3, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_SLOT_3
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                end_if
        if_status_set CHAR_SLOT_4, SLEEP
        if_status_clr CHAR_SLOT_4, DEAD
                dlg $8a
; 4 attacks!!
                set_target CHAR_SLOT_4
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

; pugs
AIScript_00ff:
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
                attack PEARL
                end_retal

; ------------------------------------------------------------------------------

; whelk
AIScript_0100:
        if_battle_switch_clr 3, 0
                toggle_battle_switch 3, 0
                battle_event $05
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

; presenter
AIScript_0101:
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

; vargas
AIScript_0103:
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
                battle_event $09
                kill_monsters ALL, FADE_HORIZONTAL
                end_if
        if_hit
        if_hp SELF, 10880
        if_battle_switch_clr 0, 0
                set_battle_switch 0, 0
                dlg $42
; Enough!!
; Off with ya now!
                battle_event $07
                end_if
        if_hit
        if_battle_switch_set 0, 0
        if_battle_switch_clr 0, 1
        if_hp SELF, 10368
                battle_event $08
                set_battle_switch 0, 1
                end_if
        end_retal

; ------------------------------------------------------------------------------

; tunnelarmr
AIScript_0104:
        if_battle_switch_clr 0, 0
                battle_event $10
                toggle_battle_switch 0, 0
                end_if
        if_hp SELF, 384
                set_target NOTHING
                attack BATTLE, FIRE, BATTLE
                wait
                set_target NOTHING
                attack TEK_LASER, SPECIAL, BOLT
                end_if
        attack BATTLE, BOLT, FIRE
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

; ghosttrain
AIScript_0106:
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

; dadaluma
AIScript_0107:
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

; shiva
AIScript_0108:
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
                attack RFLECT
                kill_monsters_wait MONSTER_4, MATERIALIZE
                show_monsters MONSTER_2, MATERIALIZE
                kill_monsters MONSTER_4, INSTANT
                end_if
        set_target NOTHING
        attack ICE, ICE, ICE_2
        wait
        attack ICE, ICE_2, BLIZZARD
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
                attack NOTHING, NOTHING, ICE
                add_monster_var 1
                add_battle_var 3, 1
                end_if
        if_hit
                add_battle_var 3, 1
                attack NOTHING, NOTHING, ICE
                end_retal

; ------------------------------------------------------------------------------

; ifrit
AIScript_0109:
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
                attack FIRE_3
                kill_monsters_wait MONSTER_3, MATERIALIZE
                show_monsters MONSTER_1, MATERIALIZE
                kill_monsters MONSTER_3, INSTANT
                end_if
        attack BATTLE, FIRE, FIRE
        wait
        attack BATTLE, BLAZE, FIRE_2
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

; number 024
AIScript_010a:
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
                attack ICE, ICE, ICE_2
                end_if
        if_weak_element SELF, ICE
                set_target NOTHING
                attack FIRE, FIRE_2, FIRE_BALL
                end_if
        if_weak_element SELF, LIGHTNING
                set_target NOTHING
                attack AQUA_RAKE, ACID_RAIN, ACID_RAIN
                end_if
        if_weak_element SELF, POISON
                set_target NOTHING
                attack CURE, CURE, CURE_2
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
                attack BOLT, BOLT, BOLT_2
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

; number 128
AIScript_010b:
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
        attack BATTLE, BATTLE, ICE
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

; inferno
AIScript_010c:
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
                attack BOLT_3, BOLT_3, METEOR
                end_if
        attack BOLT_2, ATOMIC_RAY, ATOMIC_RAY
        wait
        attack GIGA_VOLT, GIGA_VOLT, ATOMIC_RAY
        wait
        attack BOLT_2, ATOMIC_RAY, SHOCK_WAVE
        wait
        attack BOLT_2, ATOMIC_RAY, SHOCK_WAVE
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

; crane
AIScript_010d:
        if_battle_var_greater 1, 3
                set_battle_var 1, 0
                set_target MONSTER_SLOT_2
                attack FIRE_2
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
        attack BATTLE, BOLT, BOLT
        wait
        attack BATTLE, BOLT_2, SPECIAL
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

; crane
AIScript_010e:
        if_battle_var_greater 0, 3
                set_battle_var 0, 0
                set_target MONSTER_SLOT_1
                attack BOLT_2
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
        attack BATTLE, FIRE_2, SPECIAL
        end

        if_element FIRE
        if_battle_var_greater 2, 2
                dlg $47
; Heat source LV 3
                dlg $32
; Unleashed thermal energy!
                set_battle_var 2, 0
                set_target ALL_CHARS
                attack FIRE_3
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

; umaro
AIScript_010f:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BATTLE, BATTLE, BLIZZARD
        end

        if_self_dead
                boss_death
                end_if
        if_element FIRE
                set_target NOTHING
                attack NOTHING, SPECIAL, BLIZZARD
                end_if
        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

; umaro
AIScript_0110:
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
                set_status PROTECT
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
                attack BATTLE, BATTLE, BLIZZARD
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
                set_status PROTECT
                set_status SHELL
                set_status HASTE
                set_status REGEN
                set_battle_switch 0, 1
                end_if
        if_cmd MAGIC
                add_monster_var 1
                end_if
        if_element FIRE
                attack NOTHING, SPECIAL, BLIZZARD
                end_if
        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

; guardian
AIScript_0111:
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

; air force
AIScript_0113:
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

; tritoch
AIScript_0114:
        battle_event $04
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

; tritoch
AIScript_0115:
        battle_event $12
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

; flameeater
AIScript_0116:
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
                attack RFLECT
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
                attack FIRE_2, FIRE_3, FIRE_2
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
                attack NOTHING, NOTHING, FIRE_2
                end_retal

; ------------------------------------------------------------------------------

; atmaweapon
AIScript_0117:
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
                set_status PROTECT
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
                attack RASP, W_WIND, BLAZE
                end_if
        if_hp SELF, 12800
                set_target NOTHING
                attack BIO, QUAKE, METEO
                wait
                set_target NOTHING
                attack BATTLE, SPECIAL, SPECIAL
                wait
                set_target ALL_CHARS
                attack FIRE_2
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

; nerapa
AIScript_0118:
        if_monster_switch_clr 0
                dlg $66
; Mwa ha ha……You can’t run!
                set_target CHAR_SLOT_1
                attack CONDEMNED
                set_target CHAR_SLOT_2
                attack CONDEMNED
                set_target CHAR_SLOT_3
                attack CONDEMNED
                set_target CHAR_SLOT_4
                attack CONDEMNED
                set_monster_switch 0
                end_if
        if_battle_var_greater 0, 6
                set_battle_var 0, 0
                attack ROULETTE
                end_if
        attack BATTLE, BATTLE, FIRE_2
        wait
        attack BATTLE, FIRE_BALL, FIRE_3
        wait
        attack BATTLE, BATTLE, FIRE_2
        end

        if_cmd FIGHT
                attack BATTLE, NOTHING, NOTHING
                add_battle_var 0, 1
                end_retal

; ------------------------------------------------------------------------------

; srbehemoth
AIScript_0119:
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
        if_status_set CHAR_SLOT_1, REFLECT
                set_target CHAR_SLOT_1
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_SLOT_2, REFLECT
                set_target CHAR_SLOT_2
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_SLOT_3, REFLECT
                set_target CHAR_SLOT_3
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_SLOT_4, REFLECT
                set_target CHAR_SLOT_4
                attack SPECIAL
                dlg $5a
; Effect of “Rflect” vanished
                set_monster_switch 0
                end_if
        if_hp SELF, 10240
                set_target NOTHING
                attack BATTLE, ICE_3, ICE_3
                wait
                set_target NOTHING
                attack BATTLE, METEO, PEARL
                wait
                set_target NOTHING
                attack BATTLE, ICE_2, METEO
                clr_monster_switch 0
                end_if
        attack PEARL, ICE_2, NOTHING
        wait
        attack BATTLE, ICE_3, NOTHING
        clr_monster_switch 0
        end

        if_monsters_dead MONSTER_1
                set_battle_switch 10, 0
                hide_monsters SELF, FADE_HORIZONTAL
                dlg $7c
; Enemy’s coming from behind!
                chars_right_to_left
                dlg $7d
; Another monster appeared!
                change_battle 424, INSTANT, RESTORE_MONSTERS
                set_battle_switch 0, 0
                end_if
        if_attack PEARL, FLARE
                set_target NOTHING
                attack METEO
                end_if
        if_hit
                attack BATTLE, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; kefka
AIScript_011a:
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

; tentacle
AIScript_011b:
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_4, SLOW
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

; dullahan
AIScript_011c:
        if_monster_switch_clr 0
                attack PEARL_LORE
                set_monster_switch 0
                end_if
        if_monster_switch_clr 2
        if_hp SELF, 10240
                set_target SELF
                attack CURE_2
                set_monster_switch 2
                end_if
        if_battle_var_greater 1, 8
                attack N_CROSS, SPECIAL, NOTHING
                wait
                attack ICE_2, SPECIAL, NOTHING
                wait
                attack PEARL_LORE, NOTHING, ABSOLUTE0
                wait
                attack ICE_2, ABSOLUTE0, NOTHING
                set_battle_var 1, 0
                end_if
        if_monster_switch_clr 1
        if_status_set ALL_CHARS, REFLECT
                attack REFLECT_LORE
                set_monster_switch 1
                end_if
        attack ICE_3, ICE_2, NOTHING
        wait
        attack ICE_3, NOTHING, PEARL
        wait
        attack PEARL, ICE_2, NOTHING
        wait
        attack NOTHING, ICE_2, PEARL
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

; doom gaze
AIScript_011d:
        if_monster_switch_clr 0
                attack L5_DOOM
                set_monster_switch 0
                end_if
        set_target NOTHING
        attack BATTLE, DOOM, ICE_3
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

; chadarnook
AIScript_011e:
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

; curley
AIScript_011f:
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
                attack RFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target SELF
                attack FIRE_2, FIRE_3, FIRE_3
                end_if
        if_monsters_dead MONSTER_2
                set_target MONSTER_SLOT_2
                attack LIFE_2
                end_if
        if_monsters_dead MONSTER_3
                set_target MONSTER_SLOT_3
                attack LIFE_2
                end_if
        if_num_monsters 2
                attack FIRE_2, FIRE_3, FIRE_3
                end_if
        attack SLOW, NOTHING, PEARL_WIND
        wait
        attack MUTE, SLOW, NOTHING
        wait
        attack STOP, MUTE, NOTHING
        end

        if_cmd MAGIC
                add_battle_var 3, 1
                set_target GHOST_2
                attack NOTHING, NOTHING, FIRE_2
                end_if
        if_hit
                set_target GHOST_2
                attack NOTHING, FIRE_2, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; larry
AIScript_0120:
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
                attack RFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target SELF
                attack ICE_2, ICE_3, ICE_3
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
                attack ICE_2, NOTHING, ICE_3
                wait
                attack ICE_2, NOTHING, ICE_3
                wait
                attack NOTHING, ICE_2, ICE_2
                end_if
        if_monster_switch_clr 0
                attack BATTLE
                end

        if_num_monsters 2
        if_hit
                set_target GHOST_2
                attack NOTHING, ICE_2, NOTHING
                add_battle_var 2, 1
                end_if
        if_hit
                set_target GHOST_2
                attack NOTHING, ICE_2, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; moe
AIScript_0121:
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
                attack RFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target SELF
                attack BOLT_2, BOLT_3, BOLT_3
                end_if
        if_num_monsters 2
                attack BOLT_2, NOTHING, NOTHING
                wait
                attack BOLT_2, BOLT_3, NOTHING
                wait
                attack BOLT_3, BOLT_3, NOTHING
                end_if
        attack SAFE, HASTE, NOTHING
        wait
        attack SHELL, CURE_2, NOTHING
        end

        if_cmd MAGIC
                add_battle_var 3, 1
                set_target GHOST_2
                attack NOTHING, NOTHING, BOLT_2
                end_if
        if_hit
                set_target GHOST_2
                attack NOTHING, BOLT_2, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; wrexsoul
AIScript_0122:
        if_battle_switch_clr 0, 1
                set_battle_switch 0, 1
                battle_event $1f
                attack ZINGER
                end_if
        if_battle_switch_set 0, 0
                set_target ALL_REFLECT_MONSTERS
                attack NOTHING, BOLT_3, BOLT_3
                wait
                set_target ALL_REFLECT_MONSTERS
                attack NOTHING, BOLT_3, BOLT_3
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

; hidon
AIScript_0123:
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
        if_status_set CHAR_SLOT_1, DEAD
        if_status_clr CHAR_SLOT_1, ZOMBIE
                set_target CHAR_SLOT_1
                attack CHOKESMOKE
                end_if
        if_status_set CHAR_SLOT_2, DEAD
        if_status_clr CHAR_SLOT_2, ZOMBIE
                set_target CHAR_SLOT_2
                attack CHOKESMOKE
                end_if
        if_status_set CHAR_SLOT_3, DEAD
        if_status_clr CHAR_SLOT_3, ZOMBIE
                set_target CHAR_SLOT_3
                attack CHOKESMOKE
                end_if
        if_status_set CHAR_SLOT_4, DEAD
        if_status_clr CHAR_SLOT_4, ZOMBIE
                set_target CHAR_SLOT_4
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

; katanasoul
AIScript_0124:
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

; hidonite
AIScript_0126:
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

; doom
AIScript_0127:
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
        attack ICE_3, N_CROSS, ABSOLUTE0
        wait
        attack NOTHING, ICE_3, N_CROSS
        wait
        attack ICE_3, N_CROSS, ICE_3
        wait
        attack NOTHING, ICE_3, ABSOLUTE0
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

; goddess
AIScript_0128:
        if_battle_switch_clr 0, 0
        if_battle_var_greater 3, 8
                set_battle_var 3, 0
                set_target NOTHING
                attack OVERCAST
                set_battle_switch 0, 0
                end_if
        if_hp SELF, 32640
                set_target NOTHING
                attack BOLT_3, FLASH_RAIN, NOTHING
                wait
                set_target NOTHING
                attack BOLT_3, BOLT_3, FLASH_RAIN
                wait
                set_target NOTHING
                attack BOLT_3, QUASAR, QUASAR
                wait
                set_target NOTHING
                attack BOLT_3, BOLT_3, FLASH_RAIN
                end_if
        attack BOLT_2, BATTLE, LULLABY
        wait
        attack BOLT_3, CHARM, BATTLE
        wait
        attack BOLT_2, BATTLE, BOLT_3
        end

        if_self_dead
                boss_death
                end_if
        if_cmd FIGHT
                attack NOTHING, NOTHING, LOVE_TOKEN
                add_battle_var 3, 1
                end_if
        if_hit
                attack NOTHING, NOTHING, BOLT_2
                add_battle_var 3, 1
                end_retal

; ------------------------------------------------------------------------------

; poltrgeist
AIScript_0129:
        if_battle_var_greater 3, 8
                set_battle_var 3, 0
                attack WAVECANNON
                end_if
        if_status_set CHAR_SLOT_1, STOP
                attack BLASTER
                end_if
        if_status_set CHAR_SLOT_2, STOP
                attack BLASTER
                end_if
        if_status_set CHAR_SLOT_3, STOP
                attack BLASTER
                end_if
        if_status_set CHAR_SLOT_4, STOP
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
                attack NOTHING, FIRE_3, NOTHING
                end_if
        end_retal

; ------------------------------------------------------------------------------

; final kefka
AIScript_012a:
        if_monster_switch_clr 0
                battle_event $20
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
        attack FIRE_3, TRAIN, SPECIAL
        wait
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack ICE_3, TRAIN, SPECIAL
        wait
        attack BATTLE, NOTHING, SPECIAL
        wait
        attack BOLT_3, NOTHING, SPECIAL
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

; ultros (lete river)
AIScript_012c:
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
                battle_event $0a
                end_if
        if_element FIRE
                dlg $0b
; Yaaooouch!
; Seafood soup!
                attack SPECIAL
                end_retal

; ------------------------------------------------------------------------------

; ultros (opera house)
AIScript_012d:
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
                attack BATTLE, L3_MUDDLE, L3_MUDDLE
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
        if_cmd SWDTECH, BLITZ
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

; ultros (esper mountain)
AIScript_012e:
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
                battle_event $16
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
                attack FIRE_3
                end_if
        if_battle_switch_set 0, 3
        if_element ICE
                attack ICE_3
                end_if
        if_battle_switch_set 0, 3
        if_element LIGHTNING
                attack BOLT_3
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

; chupon
AIScript_012f:
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

; siegfried
AIScript_0131:
        if_battle_switch_clr 0, 0
                dlg $5d
; Go! Guys!!
;
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
                attack BATTLE
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

; head
AIScript_0134:
        attack BATTLE, BATTLE, SPECIAL
        end

        if_self_dead
                boss_death
                end_retal

; ------------------------------------------------------------------------------

; whelk head
AIScript_0135:
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

; colossus
AIScript_0136:
        if_cmd BLITZ, SWDTECH
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

; czardragon
AIScript_0137:
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; master pug
AIScript_0138:
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
                attack NOTHING, FIRE_3, FIRE_3
                end_if
        if_weak_element SELF, FIRE
                set_target NOTHING
                attack NOTHING, ICE_3, ICE_3
                end_if
        if_weak_element SELF, WIND
                set_target NOTHING
                attack NOTHING, BOLT_3, BOLT_3
                end_if
        if_weak_element SELF, HOLY
                set_target ALL_CHARS
                attack NOTHING, BIO, BIO
                end_if
        if_weak_element SELF, LIGHTNING
                set_target NOTHING
                attack NOTHING, W_WIND, W_WIND
                end_if
        if_weak_element SELF, POISON
                set_target NOTHING
                attack NOTHING, PEARL, PEARL
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

; merchant
AIScript_013a:
        attack BATTLE
        end

        if_cmd STEAL
                set_battle_switch 13, 4
                clr_battle_switch 13, 5
                hide_monsters MONSTER_1, INSTANT
                restore_monsters MONSTER_2, INSTANT
                battle_event $0f
                kill_monsters MONSTER_1, INSTANT
                end_retal

; ------------------------------------------------------------------------------

; b.day suit
AIScript_013b:
        dlg $08
; Wh…whew!!
        set_target SELF
        attack ESCAPE, ESCAPE, ESCAPE
        end

        end_retal

; ------------------------------------------------------------------------------

; tentacle
AIScript_013c:
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_4, SLOW
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

; tentacle
AIScript_013d:
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_4, SLOW
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

; tentacle
AIScript_013e:
        if_monster_switch_set 7
        if_monster_timer 30
                attack DISCARD
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_1, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_2, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_3, SLOW
                attack SEIZE
                end_if
        if_monster_switch_clr 7
        if_status_set CHAR_SLOT_4, SLOW
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

; rightblade
AIScript_013f:
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

; left blade
AIScript_0140:
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

; rough
AIScript_0141:
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

; striker
AIScript_0142:
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

; tritoch
AIScript_0144:
        attack RASP, RASP, ICE_3
        wait
        attack ICE_3, ICE_3, RASP
        wait
        attack RASP, COLD_DUST, ICE_3
        end

        if_self_dead
                boss_death
                end_if
        if_element FIRE
                attack NOTHING, NOTHING, RASP
                end_if
        if_cmd SWDTECH, TOOLS
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

; laser gun
AIScript_0145:
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

; speck
AIScript_0146:
        end

        end_retal

; ------------------------------------------------------------------------------

; missilebay
AIScript_0147:
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

; chadarnook
AIScript_0148:
        if_monster_timer 40
                reset_monster_timer
                set_battle_var 3, 1
                show_monsters MONSTER_1, CHADARNOOK
                kill_monsters MONSTER_2, CHADARNOOK
                end_if
        if_hp SELF, 15360
                set_target NOTHING
                attack BATTLE, FLASH_RAIN, BOLT_3
                wait
                set_target NOTHING
                attack FLASH_RAIN, BOLT_3, FLASH_RAIN
                wait
                set_target NOTHING
                attack FLASH_RAIN, BATTLE, BOLT_3
                wait
                set_target NOTHING
                attack FLASH_RAIN, BOLT_3, BATTLE
                end_if
        attack BATTLE, BATTLE, BOLT_3
        wait
        attack BATTLE, BOLT_2, NOTHING
        wait
        attack BATTLE, BOLT_2, BOLT_3
        wait
        attack BATTLE, BOLT_2, NOTHING
        end_if
        end

        if_self_dead
                dlg $7a
; I…I’m…
; This can’t be……
                boss_death
                end_if
        if_hit
                attack NOTHING, NOTHING, BOLT_2
                add_battle_var 0, 1
                if_battle_var_greater 0, 4
                        set_battle_var 0, 0
                        set_battle_var 3, 0
                        show_monsters MONSTER_1, CHADARNOOK
                        kill_monsters MONSTER_2, CHADARNOOK
                        end_retal

; ------------------------------------------------------------------------------

; ice dragon
AIScript_0149:
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

; kefka at narshe
AIScript_014a:
        attack BATTLE
        wait
        attack BATTLE, BATTLE, POISON
        wait
        attack BATTLE, ICE_2, BOLT
        wait
        attack MUDDLE, DRAIN, ICE
        end

        if_self_dead
                dlg $15
; Don’t think you won.
; I’ll be back!
                set_target SELF
                attack ESCAPE
                end_retal

; ------------------------------------------------------------------------------

; storm drgn
AIScript_014b:
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

; dirt drgn
AIScript_014c:
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

; ipooh
AIScript_014d:
        attack BATTLE, BATTLE, SPECIAL
        end

        if_monsters_dead {MONSTER_2, MONSTER_3}
                target_on MONSTER_SLOT_1
                end_retal

; ------------------------------------------------------------------------------

; leader
AIScript_014e:
        attack BATTLE, BATTLE, SPECIAL
        end

        if_hit
                attack NOTHING, NOTHING, SPECIAL
                end_retal

; ------------------------------------------------------------------------------

; grunt
AIScript_014f:
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; gold drgn
AIScript_0150:
        if_battle_switch_set 0, 0
        if_battle_var_greater 3, 2
                clr_battle_switch 0, 0
                set_monster_var 0
                set_battle_var 3, 0
                set_target ALL_CHARS
                attack BOLT_3
                end_if
        if_battle_switch_set 0, 0
                add_battle_var 3, 1
                end_if
        if_status_set CHAR_SLOT_1, REFLECT
        if_status_clr CHAR_SLOT_1, DEAD
        if_status_clr SELF, REFLECT
                attack RFLECT
                end_if
        if_status_set CHAR_SLOT_2, REFLECT
        if_status_clr CHAR_SLOT_2, DEAD
        if_status_clr SELF, REFLECT
                attack RFLECT
                end_if
        if_status_set CHAR_SLOT_3, REFLECT
        if_status_clr CHAR_SLOT_3, DEAD
        if_status_clr SELF, REFLECT
                attack RFLECT
                end_if
        if_status_set CHAR_SLOT_4, REFLECT
        if_status_clr CHAR_SLOT_4, DEAD
        if_status_clr SELF, REFLECT
                attack RFLECT
                end_if
        if_status_set SELF, REFLECT
                set_target NOTHING
                attack BATTLE
                wait
                set_target SELF
                attack BOLT_2, BOLT_2, BOLT
                wait
                clr_battle_switch 0, 1
                set_target NOTHING
                attack BATTLE
                wait
                set_target SELF
                attack NOTHING, BOLT_2, BOLT
                clr_battle_switch 0, 1
                end_if
        attack GIGA_VOLT, BOLT, BOLT_2
        wait
        attack GIGA_VOLT, BOLT, BOLT
        wait
        clr_battle_switch 0, 1
        attack BOLT_2, BOLT, BOLT
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
                attack NOTHING, BOLT, BOLT_2
                end_retal

; ------------------------------------------------------------------------------

; skull drgn
AIScript_0151:
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

; blue drgn
AIScript_0152:
        if_monster_switch_clr 0
                attack CLEANSWEEP
                set_monster_switch 0
                end_if
        if_battle_timer 40
                reset_battle_timer
                attack CLEANSWEEP
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_SLOT_1, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, PROTECT
                set_target SELF
                attack SLOW
                set_target CHAR_SLOT_1
                attack RIPPLER
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_SLOT_2, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, PROTECT
                set_target SELF
                attack SLOW
                set_target CHAR_SLOT_2
                attack RIPPLER
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_SLOT_3, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, PROTECT
                set_target SELF
                attack SLOW
                set_target CHAR_SLOT_3
                attack RIPPLER
                set_monster_switch 1
                end_if
        if_monster_switch_clr 1
        if_status_set CHAR_SLOT_4, HASTE
        if_status_clr SELF, HASTE
        if_status_clr SELF, PROTECT
                set_target SELF
                attack SLOW
                set_target CHAR_SLOT_4
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

; red dragon
AIScript_0153:
        if_monster_timer 40
                reset_monster_timer
                attack S_CROSS, L4_FLARE, FLARE_STAR
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_SLOT_1, REFLECT
                set_target CHAR_SLOT_1
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_SLOT_2, REFLECT
                set_target CHAR_SLOT_2
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_SLOT_3, REFLECT
                set_target CHAR_SLOT_3
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_monster_switch_clr 0
        if_status_set CHAR_SLOT_4, REFLECT
                set_target CHAR_SLOT_4
                attack SPECIAL
                dlg $76
; Remove “Rflect”
                set_monster_switch 0
                end_if
        if_hp SELF, 10240
                set_target NOTHING
                attack FLARE, FIRE_3, FLARE
                wait
                set_target NOTHING
                attack FLARE, FIRE_3, FLARE
                clr_monster_switch 0
                end_if
        attack FIRE_2, FIRE_BALL, FIRE_2
        wait
        attack FIRE_2, FIRE_2, FIRE_BALL
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

; piranha
AIScript_0154:
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

; rizopas
AIScript_0155:
        attack BATTLE, SPECIAL, MEGA_VOLT
        attack BATTLE, ICE, ICE
        wait
        attack EL_NINO, BATTLE, BATTLE
        end

        if_self_dead
                boss_death
                end_if
        end_retal

; ------------------------------------------------------------------------------

; specter
AIScript_0156:
        attack ICE, BATTLE, NOTHING
        wait
        attack BATTLE, ICE, NOTHING
        wait
        attack NOTHING, BATTLE, RAID
        end

        if_hit
                set_target PREV_ATTACKER
                attack SPECIAL, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; short arm
AIScript_0157:
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

; long arm
AIScript_0158:
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

; face
AIScript_0159:
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

; tiger
AIScript_015a:
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

; tools
AIScript_015b:
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

; magic
AIScript_015c:
        if_hp SELF, 20096
                set_target NOTHING
                attack BOLT_3, BOLT_3, MUTE
                wait
                set_target NOTHING
                attack PEARL, FLARE, RASP
                wait
                set_target NOTHING
                attack FIRE_3, ICE_2, BOLT_3
                end_if
        if_hp SELF, 30720
                set_target NOTHING
                attack RFLECT, STOP, LIFE_3
                wait
                set_target NOTHING
                attack ICE_3, BOLT_3, SLEEP
                wait
                set_target NOTHING
                attack PEARL, FLARE, SLOW_2
                end_if
        set_target NOTHING
        attack HASTE2, HASTE, IMP
        wait
        attack FIRE_3, FIRE_3, MUDDLE
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

; hit
AIScript_015d:
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

; girl
AIScript_015e:
        if_num_monsters 1
                set_target ALL_DEAD_MONSTERS
                attack LIFE_2
                end_if
        attack PEARL_WIND, PEARL_WIND, NOTHING
        wait
        attack PEARL_WIND, SPECIAL, NOTHING
        wait
        attack PEARL_WIND, PEARL_WIND, NOTHING
        wait
        attack PEARL_WIND, SPECIAL, NOTHING
        wait
        attack PEARL_WIND, NOTHING, NOTHING
        end

        end_retal

; ------------------------------------------------------------------------------

; sleep
AIScript_015f:
        if_hp SELF, 10240
                set_target NOTHING
                attack METEO
                end_if
        attack W_WIND, MERTON, NOTHING
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

; hidonite
AIScript_0160:
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

; hidonite
AIScript_0161:
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

; hidonite
AIScript_0162:
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

; soulsaver
AIScript_0167:
        if_monsters_alive MONSTER_1
        if_status_clr SELF, REFLECT
                set_target SELF
                attack RFLECT
                end_if
        if_monster_switch_clr 0
        if_mp SELF, 16
                set_target NOTHING
                attack SPECIAL
                set_monster_switch 0
                end_if
        if_one_monster_type
                attack NOTHING, ICE_3, BOLT_3
                wait
                attack FIRE_3, NOTHING, BOLT_3
                wait
                attack FIRE_3, ICE_3, NOTHING
                clr_monster_switch 0
                end_if
        set_target MONSTER_SLOT_1
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

; ultros (airship)
AIScript_0168:
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

; naughty
AIScript_0169:
        if_status_set SELF, IMP
                set_target SELF
                attack IMP
                attack ESCAPE
                end_if
        attack BATTLE, COLD_DUST, SPECIAL
        wait
        attack BATTLE, BATTLE, ICE_2
        wait
        attack BATTLE, ICE_2, BLIZZARD
        end

        if_cmd MAGIC
                set_target PREV_ATTACKER
                attack NOTHING, NOTHING, ENEMY_MUTE
                end_retal

; ------------------------------------------------------------------------------

; phunbaba
AIScript_016a:
        if_battle_switch_clr 0, 0
                invincible_on SELF
                set_battle_switch 0, 0
                end_if
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BOLT_2, BOLT_2, BOLT_3
        wait
        attack BOLT_2, BLOW_FISH, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        end_retal

; ------------------------------------------------------------------------------

; phunbaba
AIScript_016b:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BOLT_2, BOLT_2, BOLT_3
        wait
        attack BOLT_2, BLOW_FISH, SPECIAL
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

; phunbaba
AIScript_016c:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BOLT_2, BOLT_2, BOLT_3
        wait
        attack BOLT_2, BLOW_FISH, SPECIAL
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

; phunbaba
AIScript_016d:
        attack BATTLE, BATTLE, SPECIAL
        wait
        attack BOLT_2, BOLT_2, BOLT_3
        wait
        attack BOLT_2, BLOW_FISH, SPECIAL
        end

        if_self_dead
                boss_death
                end_if
        if_hit
                attack BOLT_2, NOTHING, NOTHING
                end_retal

; ------------------------------------------------------------------------------

; terra flashback vs. soldiers
AIScript_016e:
        attack FIRE_BEAM
        battle_event $11
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

; sabin vs. kefka at imperial camp
AIScript_016f:
        attack BATTLE
        end

        if_hit
                battle_event $1d
                end_battle
                end_retal

; ------------------------------------------------------------------------------

; cyan at imperial camp
AIScript_0170:
        attack DISPATCH, BATTLE, BATTLE
        end

        if_hit
                attack NOTHING, NOTHING, BATTLE
                end_retal

; ------------------------------------------------------------------------------

; zone eater
AIScript_0171:
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

; gau returning from veldt
AIScript_0172:
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
                battle_event $0d
                end_battle
                end_if
        if_hit
                battle_event $1c
                end_battle
                end_retal

; ------------------------------------------------------------------------------

; kefka vs. leo
AIScript_0173:
        attack BATTLE, BATTLE, POISON
        wait
        attack BATTLE, FIRE_3, BOLT
        wait
        attack BIO, DRAIN, BIO
        end

        if_self_dead
                hide_monsters MONSTER_2, FADE_HORIZONTAL
                battle_event $17
                end_battle
                end_retal

; ------------------------------------------------------------------------------

; kefka at the sealed gate
AIScript_0174:
        if_battle_var_greater 0, 3
                set_battle_var 0, 0
                set_target SELF
                use_item TONIC, POTION
                end_if
        attack POISON, FIRE_2, DISCHORD
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

; officer (locke steals clothes)
AIScript_0175:
        attack BATTLE, BATTLE, BATTLE
        end

        if_cmd STEAL
                set_battle_switch 13, 5
                clr_battle_switch 13, 4
                hide_monsters MONSTER_3, INSTANT
                restore_monsters MONSTER_4, INSTANT
                battle_event $0e
                kill_monsters MONSTER_3, INSTANT
                end_retal

; ------------------------------------------------------------------------------

; cadet
AIScript_0176:
        if_battle_id $003b
                attack BATTLE, BATTLE, SPECIAL
                end_if
        end

        end_retal

; ------------------------------------------------------------------------------

; unused
AIScript_0177:
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; unused
AIScript_0178:
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; flashback soldier
AIScript_0179:
        end

        end_retal

; ------------------------------------------------------------------------------

; esper vs. kefka
AIScript_017a:
        set_target KEFKA_3
        attack FIRE
        attack FIRE_2
        attack FIRE_3
        battle_event $1a
        end_battle
        end

        end_retal

; ------------------------------------------------------------------------------

; battle event
AIScript_017b:
        target_off SELF
        if_battle_id $0180
                battle_event $13
                kill_monsters MONSTER_1, INSTANT
                end_if
        if_battle_id $0181
                battle_event $14
                end_battle
                end_if
        if_battle_id $0182
                battle_event $15
                end_battle
                end_if
        if_battle_id $0185
                battle_event $18
                end_battle
                end_if
        if_battle_id $0186
                battle_event $19
                end_battle
                end_if
        if_battle_id $0189
                battle_event $1e
                end_battle
                end_if
        end

        end_retal

; ------------------------------------------------------------------------------

; unused
AIScript_017c:
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; atma
AIScript_017d:
        if_monster_switch_set 0
                dlg $83
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
                attack FIRE_3, CLEANSWEEP, QUAKE
                wait
                set_target NOTHING
                attack FIRE_3, METEOR, FLARE_STAR
                wait
                set_target NOTHING
                attack METEOR, QUAKE, CLEANSWEEP
                wait
                set_target NOTHING
                attack FIRE_3, FIRE_3, FLARE_STAR
                end_if
        if_monster_switch_clr 3
                dlg $8b
                long_glow MONSTER_1
                set_monster_switch 3
                end_if
        attack FIRE_3, ICE_3, S_CROSS
        wait
        attack BOLT_3, ICE_3, FIRE_3
        wait
        attack BOLT_3, BOLT_3, S_CROSS
        wait
        attack FIRE_3, N_CROSS, N_CROSS
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

; unused
AIScript_017e:
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

; unused
AIScript_017f:
        attack BATTLE
        end

        end_retal

; ------------------------------------------------------------------------------

end_block AIScript

; ------------------------------------------------------------------------------

.delmac attack
.delmac set_target
.delmac dlg
.delmac if_hit
.delmac if_level_greater
.delmac wait
.delmac end

; ------------------------------------------------------------------------------
