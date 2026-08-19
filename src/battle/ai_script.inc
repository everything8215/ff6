.list off
.ifndef AI_SCRIPT_INC
AI_SCRIPT_INC = 1

; ------------------------------------------------------------------------------

.enum AI_TARGET
        MONSTER_1                       = 48
        MONSTER_2                       = 49
        MONSTER_3                       = 50
        MONSTER_4                       = 51
        MONSTER_5                       = 52
        MONSTER_6                       = 53
        SELF                            = 54
        ALL_OTHER_MONSTERS              = 55
        ALL_MONSTERS                    = 56
        RAND_OTHER_MONSTER              = 57
        RAND_MONSTER                    = 58
        ALL_DEAD_CHARS                  = 59
        RAND_DEAD_CHAR                  = 60
        ALL_DEAD_MONSTERS               = 61
        RAND_DEAD_MONSTER               = 62
        ALL_REFLECT_CHARS               = 63
        RAND_REFLECT_CHAR               = 64
        ALL_REFLECT_MONSTERS            = 65
        RAND_REFLECT_MONSTER            = 66
        ALL_CHARS                       = 67
        RAND_CHAR                       = 68
        PREV_ATTACKER                   = 69
        ALL_TARGETS                     = 70
        NOTHING                         = 71
        CHAR_1                          = 72
        CHAR_2                          = 73
        CHAR_3                          = 74
        CHAR_4                          = 75
        RAND_TARGET                     = 76
        TARGETTING_TARGET               = 77
.endenum

.enum CHAR_MASK
        CHAR_1                          = %00000001
        CHAR_2                          = %00000010
        CHAR_3                          = %00000100
        CHAR_4                          = %00001000
.endenum

.enum MONSTER_MASK
        MONSTER_1                       = %00000001
        MONSTER_2                       = %00000010
        MONSTER_3                       = %00000100
        MONSTER_4                       = %00001000
        MONSTER_5                       = %00010000
        MONSTER_6                       = %00100000
        ALL                             = $ff
        SELF                            = 0
.endenum


.enum TARGET_MASK
        CHAR_1                          = %0000000000000001
        CHAR_2                          = %0000000000000010
        CHAR_3                          = %0000000000000100
        CHAR_4                          = %0000000000001000
        MONSTER_1                       = %0000000100000000
        MONSTER_2                       = %0000001000000000
        MONSTER_3                       = %0000010000000000
        MONSTER_4                       = %0000100000000000
        MONSTER_5                       = %0001000000000000
        MONSTER_6                       = %0010000000000000
.endenum

; ------------------------------------------------------------------------------

.mac ai_cmd_op ai_cmd_id
        .byte $f0 + AI_CMD::ai_cmd_id
.endmac

.mac make_ai_target target
        .ifdef CHAR_PROP::target
                .byte CHAR_PROP::target
        .else
                .byte AI_TARGET::target
        .endif
.endmac

; use an attack
.mac attack a1, a2, a3
        .if .blank(a2) .and .blank(a3)
                .if .xmatch(a1, NOTHING)
                        ai_cmd_op ATTACK
                        .byte $fe, $fe, $fe
                .elseif ATTACK::a1 < $f0
                        .byte ATTACK::a1
                .else
                        ai_cmd_op ATTACK
                        .byte $ATTACK::a1, ATTACK::a1, ATTACK::a1
                .endif
        .else
                ai_cmd_op ATTACK
                .if .xmatch(a1, NOTHING)
                        .byte $fe
                .else
                        .byte ATTACK::a1
                .endif
                .if .xmatch(a2, NOTHING)
                        .byte $fe
                .else
                        .byte ATTACK::a2
                .endif
                .if .xmatch(a3, NOTHING)
                        .byte $fe
                .else
                        .byte ATTACK::a3
                .endif
        .endif
.endmac

; set the target for this monster's next action
.mac set_target target
        ai_cmd_op SET_TARGET
        make_ai_target target
.endmac

.enum CHANGE_BATTLE_FLAGS_1
        RESTORE_MONSTERS = 0
        SCROLL_BG = $80
.endenum

.enum CHANGE_BATTLE_FLAGS_2
        RESTORE_MONSTERS = $8000
        SCROLL_BG = 0
.endenum

; change battle
.mac change_battle battle_id, exit_type, flags
        ai_cmd_op CHANGE_BATTLE
        .ifnblank flags
                make_bitmask .byte, MONSTER_ENTRY_EXIT_ANIM::exit_type, CHANGE_BATTLE_FLAGS_1, flags
                make_bitmask .word, battle_id, CHANGE_BATTLE_FLAGS_2, flags
        .else
                .byte MONSTER_ENTRY_EXIT_ANIM::exit_type
                .word battle_id
        .endif
.endmac

; show monster dialogue
.mac dlg dlg_id
        ai_cmd_op MONSTER_DLG
        .word dlg_id
.endmac

; use battle command
.mac cmd c1, c2, c3
        ai_cmd_op BATTLE_CMD
        .if .blank(c2) && .blank(c3)
                .byte BATTLE_CMD::c1
                .byte BATTLE_CMD::c1
                .byte BATTLE_CMD::c1
        .else
                .if .xmatch(c1, NOTHING)
                        .byte $fe
                .else
                        .byte BATTLE_CMD::c1
                .endif
                .if .xmatch(c2, NOTHING)
                        .byte $fe
                .else
                        .byte BATTLE_CMD::c2
                .endif
                .if .xmatch(c3, NOTHING)
                        .byte $fe
                .else
                        .byte BATTLE_CMD::c3
                .endif
        .endif
.endmac

.enum MONSTER_ENTRY_EXIT_ANIM
        INSTANT
        SMOKE
        TOP
        SIDE
        WATER
        CEILING
        SAND
        SIDE_TOGETHER
        FADE_DOWN
        FADE_UP
        MATERIALIZE
        FADE_HORIZONTAL
        BOSS_DEATH
        FLASH
        CHADARNOOK
        KEFKA_ENTRY
        SCROLL_BG
        KEFKA_DEATH
.endenum

.mac _op_monster_entry_exit op, monster_mask, anim
        ai_cmd_op MONSTER_ENTRY_EXIT
        .byte MONSTER_ENTRY_EXIT_ANIM::anim
        .byte op
        .ifblank monster_mask
                .byte 0
        .else
                make_bitmask .byte, 0, MONSTER_MASK, monster_mask
        .endif
.endmac

; monster entry/exit
.define restore_monsters _op_monster_entry_exit 0,
.define kill_monsters _op_monster_entry_exit 1,
.define show_monsters _op_monster_entry_exit 2,
.define hide_monsters _op_monster_entry_exit 3,
.define kill_monsters_wait _op_monster_entry_exit 4,
.define kill_monsters_debug _op_monster_entry_exit 5,
.define boss_death kill_monsters ALL, BOSS_DEATH

.mac _op_item op, item1, item2
        ai_cmd_op ITEM
        .byte op
        .ifblank item2
                .byte ITEM::item1, ITEM::item1
        .else
                .byte ITEM::item1, ITEM::item2
        .endif
.endmac

; use or throw an item
.define use_item _op_item 0,
.define throw_item _op_item 1,

; execute battle event
.mac battle_event event_id
        ai_cmd_op BATTLE_EVENT
        .byte event_id
.endmac

.mac _op_battle_var op, var_id, var_value
        ai_cmd_op CHANGE_VAR
        .byte var_id, var_value | op
.endmac

; modify global battle variable
.define set_battle_var _op_battle_var $00,
.define add_battle_var _op_battle_var $80,
.define sub_battle_var _op_battle_var $c0,

; modify monster variable
.define set_monster_var _op_battle_var $00, $24,
.define add_monster_var _op_battle_var $80, $24,
.define sub_monster_var _op_battle_var $c0, $24,

.mac _op_battle_switch op, var_id, switch_id
        ai_cmd_op CHANGE_SWITCH
        .byte op, var_id, switch_id
.endmac

; modify global battle switch
.define toggle_battle_switch _op_battle_switch 0,
.define set_battle_switch _op_battle_switch 1,
.define clr_battle_switch _op_battle_switch 2,

; modify monster switch
.define toggle_monster_switch _op_battle_switch 0, 36,
.define set_monster_switch _op_battle_switch 1, 36,
.define clr_monster_switch _op_battle_switch 2, 36,

; flash monster red (umaro)
.mac flash_red monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $00, MONSTER_MASK::monster_slot, 0
.endmac

; move monster back 8 pixels (slow)
.mac move_back_slow monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $01, MONSTER_MASK::monster_slot, 0
.endmac

; move monster forward 8 pixels (slow)
.mac move_forward_slow monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $02, MONSTER_MASK::monster_slot, 0
.endmac

; move monster back 8 pixels (fast)
.mac move_back_fast monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $03, MONSTER_MASK::monster_slot, 0
.endmac

; move monster forward 8 pixels (fast)
.mac move_forward_fast monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $04, MONSTER_MASK::monster_slot, 0
.endmac

; characters run from left to right side of the screen
.mac chars_run_right
        ai_cmd_op MONSTER_ANIM
        .byte $05, 0, 0
.endmac

; characters run from right to left side of the screen
.mac chars_run_left
        ai_cmd_op MONSTER_ANIM
        .byte $06, 0, 0
.endmac

; move monster back 64 pixels
.mac move_back_64 monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $07, MONSTER_MASK::monster_slot, 0
.endmac

; move monster forward 64 pixels
.mac move_forward_64 monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $08, MONSTER_MASK::monster_slot, 0
.endmac

; play sound effect
.mac sfx sfx_id, pan
        ai_cmd_op MONSTER_ANIM
        .byte $09, pan, sfx_id
.endmac

; show kefka head animation
.mac kefka_head monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $0a, MONSTER_MASK::monster_slot, 0
.endmac

; long monster glow (atma)
.mac long_glow monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $0b, MONSTER_MASK::monster_slot, 0
.endmac

; short monster glow (atma)
.mac short_glow monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $0c, MONSTER_MASK::monster_slot, 0
.endmac

; kefka death animation
.mac kefka_death monster_slot
        ai_cmd_op MONSTER_ANIM
        .byte $0d, MONSTER_MASK::monster_slot, 0
.endmac

; reset the timer for this monster
.mac reset_monster_timer
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::RESET_MONSTER_TIMER, 0
.endmac

; make a target invincible
.mac invincible_on target
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::INVINCIBLE_ON
        make_ai_target target
.endmac

; end battle instantly
.mac end_battle
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::END_BATTLE, 0
.endmac

; add gau to the party
.mac recruit_gau
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::RECRUIT_GAU, 0
.endmac

; reset the global battle timer
.mac reset_battle_timer
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::RESET_BATTLE_TIMER, 0
.endmac

; make a target un-invincible
.mac invincible_off target
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::INVINCIBLE_OFF
        make_ai_target target
.endmac

; target can be targetted
.mac target_on target
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::TARGET_ON
        make_ai_target target
.endmac

; target cannot be targetted
.mac target_off target
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::TARGET_OFF
        make_ai_target target
.endmac

; fill a target's ATB gauge
.mac fill_atb target
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::FILL_ATB
        make_ai_target target
.endmac

;
.mac end_veldt
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::END_VELDT, 0
.endmac

; apply status conditions to this monster
.mac set_status status
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::SET_STATUS, STATUS_ID::status
.endmac

; remove status conditions from this monster
.mac clr_status status
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::CLR_STATUS, STATUS_ID::status
.endmac

; hide monster (used in piranha battle)
.mac hide_piranha
        ai_cmd_op MISC_AI_EFFECT
        .byte MISC_AI_EFFECT::HIDE_PIRANHA, 0
.endmac

; never continue
.mac IF_NEVER
        ai_cmd_op AI_COND
        .byte AI_COND::IF_NEVER, 0, 0
.endmac

; if battle command is used on this monster
.mac if_cmd cmd1, cmd2
        ai_cmd_op AI_COND
        .byte AI_COND::IF_CMD
        .byte BATTLE_CMD::cmd1
        .ifnblank cmd2
                .byte BATTLE_CMD::cmd2
        .else
                .byte BATTLE_CMD::cmd1
        .endif
.endmac

; if a specific attack is used on this monster
.mac if_attack attack1, attack2
        ai_cmd_op AI_COND
        .byte AI_COND::IF_ATTACK
        .byte ATTACK::attack1
        .ifnblank attack2
                .byte ATTACK::attack2
        .else
                .byte ATTACK::attack1
        .endif
.endmac

; if item used on this monster
.mac if_item item1, item2
        ai_cmd_op AI_COND
        .byte AI_COND::IF_ITEM
        .byte ITEM::item1
        .ifnblank item2
                .byte ITEM::item2
        .else
                .byte ITEM::item1
        .endif
.endmac

; if attacked with element(s)
.mac if_element elem
        ai_cmd_op AI_COND
        .byte AI_COND::IF_ELEMENT
        make_bitmask .byte, 0, ELEMENT, elem
        .byte 0
.endmac

; if hit by any action
.mac if_hit
        ai_cmd_op AI_COND
        .byte AI_COND::IF_HIT, 0, 0
.endmac

; if this monster's HP is less than a given value
.mac if_hp target, hp
        ai_cmd_op AI_COND
        .byte AI_COND::IF_HP
        make_ai_target target
        .if (hp .mod 128)
                .warning .sprintf("hp %d not a multiple of 128", hp)
        .endif
        .byte (hp / 128)
.endmac

; if this monster's MP is less than a given value
.mac if_mp target, mp
        ai_cmd_op AI_COND
        .byte AI_COND::IF_MP
        make_ai_target target
        .byte mp
.endmac

; if a target has a given status
.mac if_status_set target, status
        ai_cmd_op AI_COND
        .byte AI_COND::IF_STATUS_SET
        make_ai_target target
        .byte STATUS_ID::status
.endmac

; if a target does not have a given status
.mac if_status_clr target, status
        ai_cmd_op AI_COND
        .byte AI_COND::IF_STATUS_CLR
        make_ai_target target
        .byte STATUS_ID::status
.endmac

; if the monster timer reaches a certain value
.mac if_monster_timer timer_value
        ai_cmd_op AI_COND
        .byte AI_COND::IF_MONSTER_TIMER, timer_value, 0
.endmac

; if a global battle variable is less than a certain value
.mac if_battle_var_less var_id, cmp_val
        ai_cmd_op AI_COND
        .byte AI_COND::IF_BATTLE_VAR_LESS, var_id, cmp_val
.endmac

; if a global battle variable is greater than a certain value
.mac if_battle_var_greater var_id, cmp_val
        ai_cmd_op AI_COND
        .byte AI_COND::IF_BATTLE_VAR_GREATER, var_id, cmp_val
.endmac

; if a target's level is less than a certain value
.mac if_level_less target, level
        ai_cmd_op AI_COND
        .byte AI_COND::IF_LEVEL_LESS
        make_ai_target target
        .byte level
.endmac

; if a target's level is greater than a certain value
.mac if_level_greater target, level
        ai_cmd_op AI_COND
        .byte AI_COND::IF_LEVEL_GREATER
        make_ai_target target
        .byte level
.endmac

; if there is only type of monster remaining
.mac if_one_monster_type
        ai_cmd_op AI_COND
        .byte AI_COND::IF_ONE_MONSTER_TYPE, 0, 0
.endmac

; if the specified monster slots are alive
.mac if_monsters_alive monster_mask
        ai_cmd_op AI_COND
        .byte AI_COND::IF_ALIVE
        make_bitmask .byte, 0, MONSTER_MASK, monster_mask
        .byte 0
.endmac

; if this monster is alive
.mac if_self_alive
        ai_cmd_op AI_COND
        .byte AI_COND::IF_ALIVE, 0, 0
.endmac

; if the specified monster slots are dead (even if unresponsive)
.mac if_monsters_dead monster_mask
        ai_cmd_op AI_COND
        .byte AI_COND::IF_DEAD
        make_bitmask .byte, 0, MONSTER_MASK, monster_mask
        .byte 0
.endmac

; if this monster is dead (even if unresponsive)
.mac if_self_dead
        ai_cmd_op AI_COND
        .byte AI_COND::IF_DEAD, 0, 0
.endmac

; if number of characters remaining >= num_chars
.mac if_num_chars num_chars
        ai_cmd_op AI_COND
        .byte AI_COND::IF_NUM_TARGETS, 0, num_chars
.endmac

; if number of monsters remaining <= num_monsters
.mac if_num_monsters num_monsters
        ai_cmd_op AI_COND
        .byte AI_COND::IF_NUM_TARGETS, 1, num_monsters
.endmac

; if a global battle switch is set
.mac if_battle_switch_set var_id, switch_id
        ai_cmd_op AI_COND
        .byte AI_COND::IF_SWITCH_SET, var_id, switch_id
.endmac

; if a global battle switch is clear
.mac if_battle_switch_clr var_id, switch_id
        ai_cmd_op AI_COND
        .byte AI_COND::IF_SWITCH_CLR, var_id, switch_id
.endmac

; if a monster switch is set
.mac if_monster_switch_set switch_id
        ai_cmd_op AI_COND
        .byte AI_COND::IF_SWITCH_SET, $24, (switch_id .mod 8)
.endmac

; if a monster switch is cleared
.mac if_monster_switch_clr switch_id
        ai_cmd_op AI_COND
        .byte AI_COND::IF_SWITCH_CLR, $24, (switch_id .mod 8)
.endmac

; if the global battle timer reaches the specified value
.mac if_battle_timer timer_value
        ai_cmd_op AI_COND
        .byte AI_COND::IF_BATTLE_TIMER, timer_value, 0
.endmac

; if the specified target is valid
.mac if_target_valid target
        ai_cmd_op AI_COND
        .byte AI_COND::IF_TARGET_VALID
        make_ai_target target
        .byte 0
.endmac

; if gau is in the party
.mac if_gau_present
        ai_cmd_op AI_COND
        .byte AI_COND::IF_GAU_PRESENT, 0, 0
.endmac

; if this monster is in a specified monster slot
.mac if_self_in_slot slot_id
        ai_cmd_op AI_COND
        .byte AI_COND::IF_SELF_IN_SLOT, MONSTER_MASK::slot_id, 0
.endmac

; if a target is weak vs. a certain element
.mac if_weak_element target, elem
        ai_cmd_op AI_COND
        .byte AI_COND::IF_WEAK_ELEMENT
        make_ai_target target
        make_bitmask .byte, 0, ELEMENT, elem
.endmac

; if the current battle index matches the specified value
.mac if_battle_id battle_id
        ai_cmd_op AI_COND
        .byte AI_COND::IF_BATTLE_ID
        .word battle_id
.endmac

; always continue (even if dead or unresponsive)
.mac if_always
        ai_cmd_op AI_COND
        .byte AI_COND::IF_ALWAYS, 0, 0
.endmac

; wait until this monster's next turn
.mac wait
        ai_cmd_op WAIT
.endmac

; end of conditional block
.mac end_if
        ai_cmd_op END_IF
.endmac

; end of main script
.mac end
        assert_ai_script_mode NORMAL
        ai_cmd_op END_SCRIPT
        set_ai_script_mode RETALIATION
.endmac

; end of retaliation script
.mac end_retal
        assert_ai_script_mode RETALIATION
        ai_cmd_op END_SCRIPT
        set_ai_script_mode NORMAL
.endmac

.enum AI_SCRIPT_MODE
        NORMAL
        RETALIATION
.endenum

.define set_ai_script_mode(mode) ::_ai_script_mode .set AI_SCRIPT_MODE::mode
.define assert_ai_script_mode(mode) .assert ::_ai_script_mode = AI_SCRIPT_MODE::mode, error, "Invalid A.I. script mode"

set_ai_script_mode NORMAL

.endif
.list on
