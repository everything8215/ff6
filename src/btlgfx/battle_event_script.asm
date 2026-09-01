.include "anim_script.mac"

; ------------------------------------------------------------------------------

; [ battle event 0: character entry ]

; d0/9842
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::CHAR_ENTRY
        battle_event
        reset_event_anim
        all_chars_event_anim
        .addr   CharEntry_00            ; terra
        .addr   CharEntry_01            ; locke
        .addr   CharEntry_02            ; cyan
        .addr   CharEntry_03            ; shadow
        .addr   CharEntry_04            ; edgar
        .addr   CharEntry_05            ; sabin
        .addr   CharEntry_06            ; celes
        .addr   CharEntry_07            ; strago
        .addr   CharEntry_08            ; relm
        .addr   CharEntry_09            ; setzer
        .addr   CharEntry_10            ; mog
        .addr   CharEntry_11            ; gau
        .addr   CharEntry_12            ; gogo
        .addr   CharEntry_13            ; umaro
        .addr   CharEntry_14            ; soldier
        .addr   CharEntry_15            ; imp
        .addr   CharEntry_16            ; leo
        .addr   CharEntry_17            ; banon
        .addr   CharEntry_18            ; esper terra
        .addr   CharEntry_19            ; merchant
        .addr   CharEntry_20            ; ghost
        .addr   CharEntry_21            ; kefka
        .addr   CharEntry_22            ; magitek characters
        .addr   CharEntry_23            ; dead/petrified characters
        exec_event_anim
        end_battle_event

; ------------------------------------------------------------------------------

; [ dead/petrified characters entry ]

; d0/9876
CharEntry_23:
        anim_script SPRITE, 1, CHAR
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ terra / leo entry ]

; d0/987b
CharEntry_00:
CharEntry_16:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker BACK, 48
        show_target_chars
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ locke / banon entry ]

; d0/9894
CharEntry_01:
CharEntry_17:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        loop 5
                move_attacker DOWN, 32
                end_loop
        move_attacker UP, 4
        move_attacker FORWARD, 96
        show_target_chars
        attacker_action CHAR_ACTION::ARMS_RAISED_BACK
        loop 13
                move_attacker UP, 12
                blank_frame
                end_loop
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ cyan / esper terra entry ]

; d0/98c4
CharEntry_02:
CharEntry_18:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        loop 5
                move_attacker UP, 32
                end_loop
        move_attacker DOWN, 4
        move_attacker FORWARD, 96
        show_target_chars
        attacker_action CHAR_ACTION::ARMS_RAISED_BACK
        loop 13
                move_attacker DOWN, 12
                blank_frame
                end_loop
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ shadow / soldier / merchant entry ]

; d0/98f4
CharEntry_03:
CharEntry_14:
CharEntry_19:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker BACK, 48
        show_target_chars
        attacker_action CHAR_ACTION::ARMS_RAISED_BACK
        loop 6
                move_attacker FORWARD, 32
                blank_frame
                end_loop
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ edgar / ghost entry ]

; d0/991b
CharEntry_04:
CharEntry_20:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        loop 5
                move_attacker UP, 32
                end_loop
        show_target_chars
        attacker_action CHAR_ACTION::ARMS_RAISED_FORWARD
        loop 10
                move_attacker DOWN, 16
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NEAR_FATAL
        loop 16
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ sabin / kefka entry ]

; d0/993b
CharEntry_05:
CharEntry_21:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        loop 5
                move_attacker UP_FORWARD, 32
                end_loop
        show_target_chars
        attacker_action CHAR_ACTION::ARMS_RAISED_BACK
        loop 20
                move_attacker DOWN_BACK, 8
                blank_frame
                end_loop
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ celes entry ]

; d0/9963
CharEntry_06:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        move_attacker BACK, 48
        show_target_chars
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        fixed_draw_order
        attacker_frame CHAR_FRAME::SURPRISED
        call _d0c0de
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ strago entry ]

; d0/9985
CharEntry_07:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker BACK, 48
        show_target_chars
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        anim_speed 7
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_UP_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ relm entry ]

; d0/99b5
CharEntry_08:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker BACK, 48
        show_target_chars
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        anim_speed 9
        attacker_frame CHAR_FRAME::WAGGING_FINGER_1
        blank_frame
        attacker_frame CHAR_FRAME::WAGGING_FINGER_2
        blank_frame
        attacker_frame CHAR_FRAME::WAGGING_FINGER_1
        blank_frame
        attacker_frame CHAR_FRAME::WAGGING_FINGER_2
        blank_frame
        attacker_frame CHAR_FRAME::WAGGING_FINGER_1
        blank_frame
        attacker_frame CHAR_FRAME::WAGGING_FINGER_2
        blank_frame
        attacker_frame CHAR_FRAME::WAGGING_FINGER_1
        blank_frame
        attacker_frame CHAR_FRAME::WAGGING_FINGER_2
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ setzer entry ]

; d0/99f5
CharEntry_09:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker BACK, 48
        show_target_chars
        attacker_action CHAR_ACTION::HIT
        loop 12
                move_attacker FORWARD, 9
                blank_frame
                end_loop
        loop 11
                attacker_frame CHAR_FRAME::HIT
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ mog entry ]

; d0/9a26
CharEntry_10:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker FORWARD, 32
        show_target_chars
        anim_speed 9
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        blank_frame
        loop 3
                attacker_frame CHAR_FRAME::LAUGHING_1
                blank_frame
                attacker_frame CHAR_FRAME::LAUGHING_2
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::NONE
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 5, 40
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ gau entry ]

; d0/9a61
CharEntry_11:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        loop 5
                move_attacker DOWN, 32
                end_loop
        move_attacker UP, 4
        loop 6
                move_attacker FORWARD, 32
                end_loop
        show_target_chars
        attacker_frame CHAR_FRAME::NONE
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ gogo entry ]

; d0/9a8b
CharEntry_12:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        loop 13
                anim_speed 2
                hide_attacker_char
                blank_frame
                show_attacker_char
                blank_frame
                end_loop
        anim_speed 3
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 4
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 5
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 6
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 2
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ umaro entry ]

; d0/9ad3
CharEntry_13:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        char_pos {0, 80}
        reset_char_vec_offset
        move_attacker FORWARD, 8
        show_target_chars
        loop 4
                move_attacker BACK, 2
                blank_frame
                end_loop
        set_vec_target {64, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 5, 40
        reset_char_vec_offset
        set_vec_target {112, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 5, 40
        reset_char_vec_offset
        set_vec_target {144, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 5, 40
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script
        end_anim_script

; ------------------------------------------------------------------------------

; [ low hp character entry (unused) ]

; d0/9b22
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker BACK, 48
        show_target_chars
        move_attacker FORWARD, 9
        attacker_frame CHAR_FRAME::NEAR_FATAL
        move_attacker FORWARD, 4
        blank_frame
        move_attacker FORWARD, 3
        blank_frame
        move_attacker FORWARD, 3
        blank_frame
        move_attacker FORWARD, 3
        blank_frame
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script
        end_anim_script

; ------------------------------------------------------------------------------

; [ imp entry ]

; d0/9b51
CharEntry_15:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused entry ]

; d0/9b5a
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused entry ]

; d0/9b63
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused entry ]

; d0/9b6c
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused entry ]

; d0/9b75
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused entry ]

; d0/9b7e
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused entry ]

; d0/9b87
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        show_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ magitek entry ]

; d0/9b90
CharEntry_22:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        fixed_draw_order
        move_attacker BACK, 48
        show_target_chars
        magitek_action 1
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        magitek_action 0
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 17: kefka/terra intro ]

        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::KEFKA_TERRA_INTRO
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d09bc9, KEFKA_1
        exec_event_anim
        open_dlg_window
        battle_dlg KEFKA_INTRO
; KEFKA:{n}
; Uwee, hee, hee!{wait} Good!{wait}{key}{n}
; Burn up everything!{wait}{wait}{wait}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09bef, KEFKA_1
        char_event_anim SLOT_2, _d09bfa
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d09bc9:
        anim_script SPRITE, 1, CHAR
        move_attacker DOWN, 96
        show_target_chars
        magitek_action 1
        set_vec_target {144, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        magitek_action 0
        loop 16
                attacker_action CHAR_ACTION::JUMPING_UP
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d09bef:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::LAUGHING
        end_anim_script

; ------------------------------------------------------------------------------

_d09bfa:
        anim_script SPRITE, 1, CHAR
        disable_char_pal_update
        mod_pal BG2, SUB, WHITE, 0
        loop 32
                mod_pal BG2, SUB, WHITE, +1
                blank_frame 2
                end_loop
        mod_pal MONSTER, SUB, WHITE, 0
        loop 32
                mod_pal MONSTER, SUB, WHITE, +1
                blank_frame 2
                end_loop
        loop 32
                attacker_action CHAR_ACTION::NONE
                blank_frame 5
                end_loop
        disable_menu
        loop 16
                dec_brightness
                blank_frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 4: tritoch (intro) ]

; d0/9c26
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::TRITOCH_INTRO
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d09e2a
        char_event_anim SLOT_2, _d09e05, WEDGE
        exec_event_anim
        open_dlg_window
        battle_dlg TRITOCH_INTRO_1
; WEDGE:{n}
; Hey! What's the matter?{key}{n}
; Do you know something we{n}
; don't__?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09c86, TERRA
        monster_event_anim SLOT_6, _d09e42, WEDGE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d09c91, TERRA
        exec_event_anim
        battle_dlg TRITOCH_INTRO_2
; GIRL:{n}
; __{key}{0}
        battle_dlg TRITOCH_INTRO_3
; The frozen creature began{n}
; emitting an eerie light__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09cad
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d09d2b
        char_event_anim SLOT_2, _d09d02, WEDGE
        char_event_anim SLOT_3, _d09d02, VICKS
        exec_event_anim
        battle_dlg TRITOCH_INTRO_4
; WEDGE:{n}
; Where's that light coming{n}
; from?!{key} Uwaaaaaaa!!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09d2b
        char_event_anim SLOT_2, _d09da4, WEDGE
        exec_event_anim
        battle_dlg TRITOCH_INTRO_5
; VICKS:{n}
; Hey!{key}{n}
; Wedge__where are you?{n}
; W__what's happening?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09d2b
        char_event_anim SLOT_2, _d09da4, VICKS
        exec_event_anim
        battle_dlg TRITOCH_INTRO_6
; Girl:{n}
; __{key} __{key} __{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09d68, TERRA
        monster_event_anim SLOT_6, _d09e42, KUMAMA
        exec_event_anim
        attack_event_anim TERRA_TRITOCH
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d09c86:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        disable_char_pal_update
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d09c91:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        magitek_action 1
        set_vec_target {112, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1
        reset_char_vec_offset
        magitek_action 0
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d09cad:
        anim_script SPRITE
        save_attacker_char_pos
        disable_char_pal_update
        mod_pal MONSTER, ADD, WHITE, 0
        .repeat 3
        loop 11
                mod_pal MONSTER, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        .endrep
        enable_char_pal_update
        end_anim_script

; ------------------------------------------------------------------------------

_d09d02:
        anim_script SPRITE
        save_attacker_char_pos
        anim_speed 13
        attacker_frame CHAR_FRAME::WALKING_UP_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_UP_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::NONE
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; flash characters and tritoch twice
_d09d2b:
        anim_script SPRITE
        save_attacker_char_pos
        disable_char_pal_update
        mod_pal MONSTER, ADD, WHITE, 0
        .repeat 2
        loop 11
                mod_pal MONSTER, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        .endrep
        enable_char_pal_update
        end_anim_script

; ------------------------------------------------------------------------------

; terra walks to (160, 102)
_d09d68:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        magitek_action 1
        set_vec_target {160, 102}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1
        reset_char_vec_offset
        magitek_action 0
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; terra walks to (160, 104) (unused)
; d0/9d84
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        anim_speed 11
        magitek_action 1
        set_vec_target {160, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 6
        reset_char_vec_offset
        anim_speed 2
        magitek_action 0
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; vicks/wedge disappear
_d09da4:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        magitek_action 1
        sfx QUADRA_SLAM
        anim_speed 2
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        loop 11
                hide_attacker_char
                blank_frame
                show_attacker_char
                blank_frame
                end_loop
        anim_speed 3
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 4
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 5
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 6
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        hide_attacker_char
        blank_frame
        anim_speed 2
        end_anim_script

; ------------------------------------------------------------------------------

; terra walks to (160, 104) (unused)
; d0/9de5
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        anim_speed 11
        magitek_action 1
        set_vec_target {160, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 6
        reset_char_vec_offset
        anim_speed 2
        magitek_action 0
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; flash monsters white twice
_d09e05:
        anim_script SPRITE
        mod_pal MONSTER, ADD, WHITE, 0
        loop 11
                mod_pal MONSTER, ADD, WHITE, +1
                blank_frame 3
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame 3
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, +1
                blank_frame 3
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; play esper world song and fade background
_d09e2a:
        anim_script SPRITE
        play_song ESPER_WORLD
        mod_pal BG2, SUB, WHITE, 0
        loop 7
                mod_pal BG2, SUB, WHITE, +1
                blank_frame 9
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; tritoch sparkle
_d09e42:
        anim_script SPRITE, 1, CHAR
        call _d09e4f
        loop 129
                blank_frame
                end_loop
        call _d09e4f
        end_anim_script

; ------------------------------------------------------------------------------

_d09e4f:
        tritoch_sparkle 4
        blank_frame 3
        event_sfx MAGICITE_PICKUP, 16
        tritoch_sparkle 3
        blank_frame 4
        tritoch_sparkle 2
        blank_frame 5
        tritoch_sparkle 1
        blank_frame 6
        tritoch_sparkle 0
        blank_frame
        return

; ------------------------------------------------------------------------------

; [ battle event 5: whelk intro ]

_d09e77:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::WHELK_INTRO
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d09eaa, VICKS
        exec_event_anim
        open_dlg_window
        battle_dlg WHELK_1
; VICKS:{n}
; Hold it!{key}{n}
; Think back to our briefing__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09ed3, WEDGE
        exec_event_anim
        battle_dlg WHELK_2
; WEDGE:{n}
; What about it?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09ebf, VICKS
        exec_event_anim
        battle_dlg WHELK_3
; VICKS:{n}
; Do you recall hearing about a{n}
; monster that eats lightning__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09ebf, WEDGE
        exec_event_anim
        battle_dlg WHELK_4
; WEDGE:{n}
; __and stores the energy in{n}
; its shell!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09ebf, VICKS
        exec_event_anim
        battle_dlg WHELK_5
; VICKS:{n}
; Right. So whatever you do,{key}{n}
; don't attack the shell!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09eaa, WEDGE
        exec_event_anim
        battle_dlg WHELK_6
; WEDGE:{n}
; Alright already!{key}{0}
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d09eaa:
        anim_script SPRITE
        fixed_draw_order
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 2
                call _d0c0de
                end_loop
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

_d09ebf:
        anim_script SPRITE
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::FIGHTING_FRONT_HAND
                blank_frame 2
                end_loop
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d09ed3:
        anim_script SPRITE
        fixed_draw_order
        attacker_frame CHAR_FRAME::FIGHTING_3
        call _d0c0de
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 6: Locke and Edgar witness Terra using magic ]

_d09ee5:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::TERRA_MAGIC
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d09f92, EDGAR
        char_event_anim SLOT_2, _d09fba, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a198, TERRA
        char_event_anim SLOT_2, _d09fc8, LOCKE
        exec_event_anim
        open_dlg_window
        battle_dlg BATTLE_DLG_184
; {locke}:{n}
; {edgar},{n}
; What's the matter?{key} You look{n}
; positively spooked!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09fe1, EDGAR
        exec_event_anim
        battle_dlg BATTLE_DLG_185
; {edgar}:{n}
; Dddddddid you just see what{n}
; I saw_?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d09fff, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_186
; {locke}:{n}
; Yeah__this kid seems loaded{n}
; for bear__{key}{0}
        battle_dlg BATTLE_DLG_187
; {edgar}:{n}
; She's amazing!{key}{n}
; That was magic! {key}M{key}A{key}G{key}I{key}C!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a017, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_188
; {locke}:{n}
; M{key}{n}
; M{n}
; M{n}
; M{n}
; M{n}
; M{n}
; M{n}
; MAGIC?!{key}{n}
; She used magic?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a029, LOCKE
        char_event_anim SLOT_2, _d0a03f, EDGAR
        exec_event_anim
        battle_dlg BATTLE_DLG_189
; {edgar}  {locke}:{n}
; Pswswswsw!{key}{n}
; pswswswsw!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a055, EDGAR
        char_event_anim SLOT_2, _d0a198, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_190
; {edgar}:{n}
; {terra}__where on earth{n}
; did you learn that?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a06b, TERRA
        char_event_anim SLOT_2, _d0a192, EDGAR
        char_event_anim SLOT_3, _d0a192, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_191
; {terra}:{n}
; ___{key}{n}
; Sorry__I__{key}{n}
; um__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a083, LOCKE
        char_event_anim SLOT_2, _d0a0a6, EDGAR
        exec_event_anim
        battle_dlg BATTLE_DLG_192
; {locke}:{n}
; Look, I didn't mean to make{n}
; such a big deal of this__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a0c7, EDGAR
        exec_event_anim
        battle_dlg BATTLE_DLG_193
; {edgar}:{n}
; Me either__{key}it's just that{n}
; I've never actually SEEN magic{n}
; before! {key}Where did you_?{key}{0}
        battle_dlg BATTLE_DLG_194
; {terra}:{n}
; __{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a0dd, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_195
; {locke}:{n}
; {edgar}, {terra} can use magic,{n}
; and we can't. {key}That's the only{n}
; difference between us.{key}{n}
; The fact is__we could use{n}
; her help!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a0f3, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_196
; {terra}:{n}
; Thank you,  {locke}!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a102, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_197
; {terra}:{n}
; Thank you,  {edgar}!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a1a4, LOCKE
        char_event_anim SLOT_2, _d0a1a4, EDGAR
        char_event_anim SLOT_3, _d0a14d, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a111, LOCKE
        char_event_anim SLOT_2, _d0a111, EDGAR
        exec_event_anim
        battle_dlg BATTLE_DLG_198
; Stop swooning_!{wait}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a131, LOCKE
        char_event_anim SLOT_2, _d0a131, EDGAR
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d09f92:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_frame CHAR_FRAME::SURPRISED
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::SURPRISED
        set_vec_target {136, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 56
        reset_char_vec_offset
        call _d0c0de
        call _d0c0de
        attacker_frame CHAR_FRAME::SURPRISED
        end_anim_script

; ------------------------------------------------------------------------------

_d09fba:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        call _d0c0de
        attacker_frame CHAR_FRAME::READY
        end_anim_script

; ------------------------------------------------------------------------------

_d09fc8:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {160, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 32
        reset_char_vec_offset
        call _d0c0de
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d09fe1:
        anim_script SPRITE, 1, CHAR
        anim_speed 5
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d09fff:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
                blank_frame 2
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a017:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::SURPRISED
        call _d0c0de
        call _d0c0de
        call _d0c0de
        call _d0c0de
        end_anim_script

; ------------------------------------------------------------------------------

_d0a029:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {152, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a03f:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a055:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {176, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 24
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0a06b:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {176, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::EYES_CLOSED_DOWN
        end_anim_script

; ------------------------------------------------------------------------------

_d0a083:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {168, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 24
        reset_char_vec_offset
        set_vec_target {168, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a0a6:
        anim_script SPRITE, 1, CHAR
        loop 10
                attacker_frame CHAR_FRAME::NONE
                blank_frame
                end_loop
        set_vec_target {200, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 24
        reset_char_vec_offset
        loop 21
                attacker_frame CHAR_FRAME::DEAD_VERT
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a0c7:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {200, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a0dd:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {152, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0a0f3:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 16
                attacker_action CHAR_ACTION::BLINKING_FORWARD
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a102:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 16
                attacker_action CHAR_ACTION::BLINKING_BACK
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0a111:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::WALKING_DOWN_2
                blank_frame 3
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::LAUGHING_1
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::LAUGHING_1
        loop 32
                move_attacker DOWN, 1
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0a131:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; unused

_d0a147:
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0a14d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {192, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::WALKING_DOWN_2
                blank_frame 2
                end_loop
        anim_speed 5
        attacker_frame CHAR_FRAME::WINKING_DOWN
        blank_frame 2
        anim_speed 2
        loop 32
                attacker_frame CHAR_FRAME::WALKING_DOWN_2
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::NONE
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 16
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; unused

_d0a18c:
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0a192:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a198:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

; unused

_d0a19e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a1a4:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 10: ultros defeated (river) ]

_d0a1aa:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::ULTROS_RIVER_DEFEATED
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0a487, TERRA
        exec_event_anim
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0a278, EDGAR
        char_event_anim SLOT_2, _d0a28e, TERRA
        char_event_anim SLOT_3, _d0a2a4, SABIN
        char_event_anim SLOT_4, _d0a2ba, BANON
        exec_event_anim
        open_dlg_window
        battle_dlg ULTROS_RIVER_1
; {sabin}:{n}
; I guess we thrashed it.{key}{0}
        battle_dlg ULTROS_RIVER_2
; {edgar}:{n}
; Don't bet on it__{key}{n}
; It's probably just hiding{n}
; from us__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a2d0, TERRA
        char_event_anim SLOT_2, _d0a441, EDGAR
        char_event_anim SLOT_3, _d0a441, SABIN
        char_event_anim SLOT_4, _d0a441, BANON
        exec_event_anim
        battle_dlg ULTROS_RIVER_3
; {terra}:{n}
; Ewww!!{key}{n}
; Something's stuck to my leg!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a2f5, EDGAR
        exec_event_anim
        battle_dlg ULTROS_RIVER_4
; {edgar}:{n}
; {terra}! Over here!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a30b, EDGAR
        char_event_anim SLOT_2, _d0a334, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a34a, BANON
        char_event_anim SLOT_2, _d0a447, SABIN
        exec_event_anim
        battle_dlg ULTROS_RIVER_5
; BANON:{n}
; It's all right now.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a360, SABIN
        char_event_anim SLOT_2, _d0a441, EDGAR
        char_event_anim SLOT_3, _d0a441, BANON
        exec_event_anim
        battle_dlg ULTROS_RIVER_6
; {sabin}:{n}
; Watch out!{key}{n}
; I'm going to hit it with a{n}
; Blitz!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a39b, EDGAR
        exec_event_anim
        battle_dlg ULTROS_RIVER_7
; {edgar}:{n}
; No! {sabin}!!{key}{0}
        battle_dlg ULTROS_RIVER_8
; {sabin}:{n}
; Don't distract me, brother!!{key}{0}
        reset_event_anim
        attack_event_anim WATER_SPLASH_BG1, SABIN, ALL_MONSTERS
        char_event_anim SLOT_1, _d0a3b1, SABIN
        char_event_anim SLOT_2, _d0a3d8, EDGAR
        char_event_anim SLOT_3, _d0a44d, BANON
        char_event_anim SLOT_4, _d0a44d, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a41c, EDGAR
        char_event_anim SLOT_2, _d0a3ee, TERRA
        char_event_anim SLOT_4, _d0a404, BANON
        exec_event_anim
        battle_dlg ULTROS_RIVER_9
; {edgar}:{n}
; He's always been a tad{n}
; zealous__{key}{0}
        battle_dlg ULTROS_RIVER_10
; {terra}:{n}
; {sabin}__!!!{key}{0}
        battle_dlg ULTROS_RIVER_11
; BANON:{n}
; Don't worry about him!{key}{0}
        battle_dlg ULTROS_RIVER_12
; {edgar}:{n}
; Are you sure he's okay,{n}
; Banon?{key}{0}
        battle_dlg ULTROS_RIVER_13
; BANON:{n}
; You should know better than{n}
; any of us! {key}Any moment he'll{n}
; flop right onto the raft!{key}{0}
        reset_event_anim
        attack_event_anim WATER_SPLASH_SPRITE, SABIN, ALL_MONSTERS
        char_event_anim SLOT_1, _d0a432, SABIN
        char_event_anim SLOT_2, _d0a459, EDGAR
        char_event_anim SLOT_3, _d0a459, TERRA
        char_event_anim SLOT_4, _d0a459, BANON
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a453, EDGAR
        char_event_anim SLOT_2, _d0a453, TERRA
        char_event_anim SLOT_3, _d0a453, BANON
        exec_event_anim
        battle_dlg ULTROS_RIVER_14
; {sabin}:{n}
; What the_?{wait}{0}
        battle_dlg ULTROS_RIVER_15
; BANON:{n}
; __{key} __{key}{0}
        battle_dlg ULTROS_RIVER_16
; {edgar}:{n}
; Seems a little too perky__{key}{n}
; Ha_!{key}{0}
        battle_dlg ULTROS_RIVER_17
; {terra}:{n}
; {sabin}!!!!!{key}{0}
        battle_dlg ULTROS_RIVER_18
; {edgar}:{n}
; {sabin}!!!!{key}{n}
; Take care of yourself!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a48f, EDGAR
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a278:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {176, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a28e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {184, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a2a4:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {168, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a2ba:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {216, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a2d0:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        set_vec_target {208, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 6, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        anim_speed 9
        attacker_frame CHAR_FRAME::SURPRISED
        blank_frame
        attacker_frame CHAR_FRAME::SURPRISED
        blank_frame
        attacker_frame CHAR_FRAME::NEAR_FATAL
        blank_frame
        anim_speed 2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a2f5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {208, 136}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a30b:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {208, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {192, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0a334:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {208, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0a34a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {224, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a360:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {200, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::READY
        loop 2
                move_attacker UP, 10
                blank_frame
                move_attacker UP, 6
                blank_frame 2
                move_attacker UP, 2
                blank_frame 2
                move_attacker UP, 1
                blank_frame 4
                move_attacker DOWN, 1
                blank_frame 4
                move_attacker DOWN, 2
                blank_frame 2
                move_attacker DOWN, 6
                blank_frame 2
                move_attacker DOWN, 10
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0a39b:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {184, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0a3b1:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {192, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        set_vec_target {96, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 96
        reset_char_vec_offset
        sfx SPLASH
        hide_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

_d0a3d8:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {184, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::SURPRISED
        end_anim_script

; ------------------------------------------------------------------------------

_d0a3ee:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {184, 112}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a404:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        disable_menu
        set_vec_target {192, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a41c:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {176, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a432:
        anim_script SPRITE, 1, CHAR
        show_target_chars
        attacker_action CHAR_ACTION::DEAD_VERT
        sfx SPLASH
        loop 32
                move_attacker UP, 6
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0a441:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a447:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0a44d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a453:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a459:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::SURPRISED
        loop 2
                move_attacker UP, 10
                blank_frame
                move_attacker UP, 6
                blank_frame 2
                move_attacker UP, 2
                blank_frame 2
                move_attacker UP, 1
                blank_frame 4
                move_attacker DOWN, 1
                blank_frame 4
                move_attacker DOWN, 2
                blank_frame 2
                move_attacker DOWN, 6
                blank_frame 2
                move_attacker DOWN, 10
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a487:
        anim_script SPRITE, 1, CHAR
        play_song HUH
        end_anim_script

; ------------------------------------------------------------------------------

_d0a48f:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 7: Sabin intro during Vargas battle ]

_d0a49d:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::SABIN_INTRO
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0a65e, SABIN
        exec_event_anim
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0a6ac, TERRA
        exec_event_anim
        battle_dlg SABIN_INTRO_1
; Give it up, Vargas!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a675, SABIN
        exec_event_anim
        battle_dlg SABIN_INTRO_2
; VARGAS:{n}
; Is that you,  {sabin}?!{key}{0}
        add_char_target SABIN
        show_char_menu SABIN
        reset_event_anim
        char_event_anim SLOT_1, _d0a578, SABIN
        char_event_anim SLOT_2, _d0a58e, EDGAR
        char_event_anim SLOT_3, _d0a5a6, TERRA
        char_event_anim SLOT_4, _d0a5be, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a658, LOCKE
        char_event_anim SLOT_2, _d0a658, TERRA
        char_event_anim SLOT_3, _d0a658, EDGAR
        exec_event_anim
        battle_dlg SABIN_INTRO_3
; {sabin}:{n}
; Vargas, why'd you do it?{key}{n}
; How could you do your own{n}
; father in like that?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a64c, LOCKE
        char_event_anim SLOT_2, _d0a64c, TERRA
        char_event_anim SLOT_3, _d0a64c, EDGAR
        exec_event_anim
        battle_dlg SABIN_INTRO_4
; VARGAS:{n}
; Fool! He made the mistake of{n}
; choosing you as his successor!{key}{n}
; He snubbed me,{key}{n}
; his only son!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a658, LOCKE
        char_event_anim SLOT_2, _d0a658, TERRA
        char_event_anim SLOT_3, _d0a658, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a5d6, SABIN
        exec_event_anim
        battle_dlg SABIN_INTRO_5
; {sabin}:{n}
; No!{key}{n}
; You were the one he chose!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a64c, LOCKE
        char_event_anim SLOT_2, _d0a64c, TERRA
        char_event_anim SLOT_3, _d0a64c, EDGAR
        exec_event_anim
        battle_dlg SABIN_INTRO_6
; VARGAS:{n}
; You're a liar!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a5dc, SABIN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a658, LOCKE
        char_event_anim SLOT_2, _d0a658, TERRA
        char_event_anim SLOT_3, _d0a658, EDGAR
        exec_event_anim
        battle_dlg SABIN_INTRO_7
; {sabin}:{n}
; Our Master wanted you to be{n}
; his successor, not me. {key}{n}
; He appreciated your fine{n}
; spirit__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a64c, LOCKE
        char_event_anim SLOT_2, _d0a64c, TERRA
        char_event_anim SLOT_3, _d0a64c, EDGAR
        exec_event_anim
        battle_dlg SABIN_INTRO_8
; VARGAS:{n}
; Enough of your lies!{key}{n}
; Now, have a taste of my{n}
; superior technique!{key}{0}
        battle_dlg SABIN_INTRO_9, TOP
; Mortal Attack! Blizzard Fist!{key}{0}
        reset_event_anim
        attack_event_anim BLIZZARD_FIST
        char_event_anim SLOT_1, _d0a5ea, SABIN
        char_event_anim SLOT_2, _d0a633, EDGAR
        char_event_anim SLOT_3, _d0a5fd, TERRA
        char_event_anim SLOT_4, _d0a618, LOCKE
        exec_event_anim
        remove_char_target TERRA
        remove_char_target LOCKE
        remove_char_target EDGAR
        hide_char_menu TERRA
        hide_char_menu LOCKE
        hide_char_menu EDGAR
        reset_event_anim
        char_event_anim SLOT_1, _d0a6a7, TERRA
        char_event_anim SLOT_2, _d0a6a7, LOCKE
        char_event_anim SLOT_3, _d0a6a7, EDGAR
        exec_event_anim
        battle_dlg BATTLE_DLG_253
; {0}
        battle_dlg SABIN_INTRO_10
; VARGAS:{n}
; Ahh, {sabin}!{key}{n}
; The master taught you well!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a5e2, SABIN
        exec_event_anim
        battle_dlg SABIN_INTRO_11
; {sabin}:{n}
; I guess there's no avoiding{n}
; this!{key}{0}
        battle_dlg SABIN_INTRO_12
; VARGAS:{n}
; Fate made us train together,{key}{n}
; and fate will send you to{n}
; your doom!{key}{0}
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a578:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a58e:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 16, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a5a6:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 64}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 16, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a5be:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {152, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 16, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a5d6:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::EYES_CLOSED_DOWN
        end_anim_script

; ------------------------------------------------------------------------------

_d0a5dc:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a5e2:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::READY
        end_anim_script

; ------------------------------------------------------------------------------

_d0a5ea:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::HIT
        loop 64
                move_attacker BACK, 1
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0a5fd:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::HIT
        loop 41
                move_attacker BACK, 1
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::SURPRISED
        loop 16
                move_attacker BACK, 17
                blank_frame
                end_loop
        hide_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

_d0a618:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::HIT
        loop 34
                move_attacker BACK, 1
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::SURPRISED
        loop 16
                move_attacker BACK, 17
                blank_frame
                end_loop
        hide_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

_d0a633:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::HIT
        loop 24
                move_attacker BACK, 1
                blank_frame 3
                end_loop
        attacker_frame CHAR_FRAME::SURPRISED
        loop 16
                move_attacker BACK, 17
                blank_frame
                end_loop
        hide_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

_d0a64c:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused

_d0a652:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0a658:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a65e:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        hide_attacker_char
        set_vec_target {32, 200}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 8, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0a675:
        anim_script SPRITE, 1, CHAR
        show_attacker_char
        sfx JUMP
        set_vec_target {120, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 8, 64
        reset_char_vec_offset
        sfx JUMP
        set_vec_target {184, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 8, 64
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a69d:
        anim_script SPRITE, 1, CENTER
        restore_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0a6a7:
        anim_script SPRITE, 1, CHAR
        hide_attacker_char
        end_anim_script

; ------------------------------------------------------------------------------

_d0a6ac:
        anim_script SPRITE, 1, CHAR
        play_song THE_UNFORGIVEN
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 8: blitz tutorial ]

_d0a6b4:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::BLITZ_TUTORIAL
        battle_event
        open_dlg_window
        battle_dlg BATTLE_DLG_82
; VARGAS:{n}
; Time to put an end to this!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a6e3, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_83
; {sabin}{n}
; The Master's teachings__{key}{n}
; Must use a Blitz technique__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a6e9, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_84
; Choose Blitz, {key}press the{n}
; Control Pad left, {key}right,{key}{n}
; left, {key}then press the A Button!{key}{0}
        battle_dlg BATTLE_DLG_85
; How to use ``Blitz'':{key}{0}
        battle_dlg BATTLE_DLG_212
; 1. Choose ``Blitz'' and press the{n}
; A Button.{key}{0}
        battle_dlg BATTLE_DLG_213
; 2. When the cursor appears,{n}
; enter your technique.{key}{0}
        battle_dlg BATTLE_DLG_214
; 3. Using the Control Pad, press{n}
; left, right, and left again.{key}{0}
        battle_dlg BATTLE_DLG_215
; 4. Finally, press the A Button{n}
; to engage the attack.{key}{0}
        battle_dlg BATTLE_DLG_216
; 5. If you make a mistake,{n}
; nothing will happen. Relax,{n}
; there's no need to hurry!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a6ef, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_86
; {sabin}{n}
; Choose Blitz, {key}press the{n}
; Control Pad left {key}right{key}{n}
; left, {key}then press A!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a6f5, SABIN
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a6e3:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::EYES_CLOSED_DOWN
        end_anim_script

; ------------------------------------------------------------------------------

_d0a6e9:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a6ef:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a6f5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 9: Vargas defeated ]

_d0a6fb:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::VARGAS_DEFEATED
        battle_event
        open_dlg_window
        battle_dlg VARGAS_DEFEATED_1
; VARGAS:{n}
; W__what the__?! He__{key}{n}
; already taught you that?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a708, SABIN
        exec_event_anim
        battle_dlg VARGAS_DEFEATED_2
; {sabin}:{n}
; If only you hadn't been in{n}
; such a rush for power__{key}{0}
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a708:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::EYES_CLOSED_DOWN
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0a70e:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 2
        end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 12: Cyan intro ]

; Unused. Dialogues are blank in the English version but exist in the
; Japanese version. Translations are below.
_d0a71a:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::CYAN_INTRO
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0a739, CYAN
        exec_event_anim
        open_dlg_window
        battle_dlg BATTLE_DLG_79
; {cyan}{n}「くそっ！後ろに回り込まれたか！{key}
; CYAN:
; Damn it! They got around to my back!
        reset_event_anim
        char_event_anim SLOT_2, _d0a741, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_80
; {sabin}{n}「俺はフィガロの{sabin}！{key}{n}すけだちするぜ！！{key}
; SABIN:
; I am SABIN from Figaro, I will give you a hand!!
        battle_dlg BATTLE_DLG_81
; {cyan}{n}「すまん！{key}{n}だが、このままではまずい{n}いったんひこう{key}
; CYAN:
; Sorry! If this keeps up we should retreat
        reset_event_anim
        char_event_anim SLOT_1, _d0a749, CYAN
        char_event_anim SLOT_2, _d0a749, LOCKE
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a739:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a741:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a749:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 14: Locke steals green soldier's clothes ]

_d0a751:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::STEAL_GREEN_SOLDIER
        battle_event
        open_dlg_window
        battle_dlg LOCKE_CLOTHES_1
; Stole his clothing, too!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a76c, LOCKE
        exec_event_anim
        battle_dlg LOCKE_CLOTHES_2
; {locke}:{n}
; Here we go!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a784, LOCKE
        exec_event_anim
        battle_dlg LOCKE_CLOTHES_SOLDIER
; These are a little too big,{key}{n}
; but they'll do.{key}{0}
        close_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0a7b5, LOCKE
        exec_event_anim
        end_battle_event

; ------------------------------------------------------------------------------

_d0a76c:
        anim_script SPRITE
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 64
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a784:
        anim_script SPRITE
        attacker_frame CHAR_FRAME::NONE
        anim_speed 11
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        change_char_gfx LOCKE, GREEN_SOLDIER
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a7b5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0a7cb:
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 15: Locke steals merchant's clothes ]

_d0a7d1:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::STEAL_MERCHANT
        battle_event
        open_dlg_window
        battle_dlg LOCKE_CLOTHES_1
; Stole his clothing, too!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a7ec, LOCKE
        exec_event_anim
        battle_dlg LOCKE_CLOTHES_2
; {locke}:{n}
; Here we go!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a804, LOCKE
        exec_event_anim
        battle_dlg LOCKE_CLOTHES_MERCHANT
; These are a little tight,{key}{n}
; but the price was right.{key}{0}
        close_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0a835, LOCKE
        exec_event_anim
        end_battle_event

; ------------------------------------------------------------------------------

_d0a7ec:
        anim_script SPRITE
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 64
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a804:
        anim_script SPRITE
        attacker_frame CHAR_FRAME::NONE
        anim_speed 11
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        change_char_gfx LOCKE, MERCHANT
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a835:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0a84b:
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 11: Shadow leaves the party ]

_d0a851:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::SHADOW_LEAVES_PARTY
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0a86a, SHADOW
        exec_event_anim
        open_dlg_window
        battle_dlg BATTLE_DLG_251
; {shadow}:{n}
; My job here's over.{key}{n}
; I've earned my fee!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a87e, SHADOW
        exec_event_anim
        battle_dlg BATTLE_DLG_252
; {shadow}:{n}
; Ta-ta__!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a892, SHADOW
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a86a:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 31
                move_attacker FORWARD, 1
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a87e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 41
                move_attacker FORWARD, 1
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0a892:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        calc_vec_rel {-40, 0}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        calc_vec_rel {-48, 0}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 24
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::JUMPING_FORWARD
        loop 20
                move_attacker UP_FORWARD, 8
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 16: TunnelArmr intro ]

_d0a8c4:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::TUNNELARMR_INTRO
        battle_event
        open_dlg_window
        battle_dlg BATTLE_DLG_200
; {celes}:{n}
; TunnelArmr!!{key}{n}
; I'll draw its magic attack.{key}{n}
; It won't hurt us.{key}{0}
        battle_dlg BATTLE_DLG_201
; {locke}:{n}
; Come again?!{key}{0}
        battle_dlg BATTLE_DLG_202
; {celes}:{n}
; I can simply absorb the{n}
; attack with my Runic Blade.{key}{0}
        battle_dlg BATTLE_DLG_203
; {locke}:{n}
; Are you sure you'll be okay?!{key}{0}
        battle_dlg BATTLE_DLG_204
; {celes}:{n}
; Just you watch!!{key}{0}
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

; [ battle event 18: Tritoch, Terra transforms into an esper ]

_d0a8d1:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::TRITOCH_TERRA_TRANSFORMS
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0a960, TERRA
        char_event_anim SLOT_2, _d0a925, TERRA
        exec_event_anim
        open_dlg_window
        battle_dlg BATTLE_DLG_151
; {terra}:{n}
; What!? {key}What am I feeling?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a976, TERRA
        char_event_anim SLOT_2, _d0a925, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_152
; {terra}:{n}
; Huh? {key}W__what's going on__?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a990, TERRA
        char_event_anim SLOT_2, _d0a925, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_153
; {terra}:{n}
; Please__tell me!{key}{n}
; Who am I? {key}WHO?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a925, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_154
; {locke}:{n}
; {terra}!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a925, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_155
; {celes}:{n}
; An Esper__{key}{n}
; I can actually feel its mind__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a925, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_156
; {edgar}:{n}
; {terra}__{key}{n}
; Step away from the Esper__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0a925, TERRA
        exec_event_anim
        attack_event_anim TERRA_TRITOCH_ALT
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0a9a6, TERRA
        char_event_anim SLOT_2, _d0a9db, TERRA
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a925:
        anim_script SPRITE, 1, CHAR
        disable_char_pal_update
        mod_pal MONSTER, ADD, WHITE, 0
        loop 11
                mod_pal MONSTER, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, +1
                blank_frame
                end_loop
        loop 11
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 11
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        enable_char_pal_update
        end_anim_script

; ------------------------------------------------------------------------------

_d0a960:
        anim_script SPRITE
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {184, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a976:
        anim_script SPRITE
        attacker_frame CHAR_FRAME::NONE
        anim_speed 9
        attacker_frame CHAR_FRAME::EYES_CLOSED_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame
        attacker_frame CHAR_FRAME::EYES_CLOSED_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame
        anim_speed 2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a990:
        anim_script SPRITE
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {168, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0a9a6:
        anim_script SPRITE, 1, CHAR
        loop 5
                change_char_gfx TERRA, ESPER_TERRA
                blank_frame
                change_char_gfx TERRA, TERRA
                blank_frame
                end_loop
        loop 4
                change_char_gfx TERRA, ESPER_TERRA
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 5
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::WALKING_DOWN_2
                blank_frame 2
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::LAUGHING_1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0a9db:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 9
                blank_frame 5
                end_loop
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 27: Gau appears ]

_d0a9f1:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::GAU_APPEARS
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0a9fe, GAU
        exec_event_anim
        add_char_target GAU
        open_dlg_window
        battle_dlg BATTLE_DLG_254
; {gau}:{n}
; Uwaoo~!!{key}{0}
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0a9fe:
        anim_script SPRITE, 1, CHAR
        attacker_char_dir RIGHT
        disable_run
        save_attacker_char_pos
        show_attacker_char
        anim_speed 13
        attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 13: Gau intro ]

_d0aa21:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::GAU_INTRO
        battle_event
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0ac88, GAU
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ad21, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_58
; {sabin}:{n}
; What the__{key}{0}
        battle_dlg BATTLE_DLG_76
; {cyan}:{n}
; Thou art so__odd.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ad2d, CYAN
        exec_event_anim
        battle_dlg BATTLE_DLG_59
; {cyan}:{n}
; I'm {cyan} and he's {sabin}.{key}{0}
        battle_dlg BATTLE_DLG_60
; {gau}:{n}
; You {sabin}__ you {cyan},{key}{n}
; me want more food!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ad46, GAU
        char_event_anim SLOT_2, _d0ad59, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_61
; {sabin}:{n}
; No more for you.{key}{0}
        battle_dlg BATTLE_DLG_62
; {gau}:{n}
; You go__get more for me.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ad6c, GAU
        char_event_anim SLOT_2, _d0ada4, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_63
; {sabin}:{n}
; You're a regular munchkin!{key}{0}
        battle_dlg BATTLE_DLG_248
; {gau}:{n}
; And you__afraid of me!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ad7a, GAU
        char_event_anim SLOT_2, _d0adb2, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_64
; {sabin}:{n}
; You wanna fight?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ad88, GAU
        char_event_anim SLOT_2, _d0adc0, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_65
; {gau}:{n}
; Me not wanna hurt you__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ad96, GAU
        char_event_anim SLOT_2, _d0adce, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_66
; {sabin}:{n}
; Stop looking at me like that!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0addc, GAU
        char_event_anim SLOT_2, _d0ae5d, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_77
; {sabin}:{n}
; Wheeze__puff__!{n}
; You're pretty tough!{key}{0}
        battle_dlg BATTLE_DLG_249
; {gau}:{n}
; Wah, ha!{key}{n}
; That fun! You strong!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0aede, GAU
        char_event_anim SLOT_2, _d0af6e, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_67
; {gau}:{n}
; Me like dancing!{key}{n}
; You good leader!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0afef, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_68
; {sabin}:{n}
; Shut up!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0affd, CYAN
        char_event_anim SLOT_2, _d0b01a, GAU
        char_event_anim SLOT_3, _d0b038, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_69
; {cyan}:{n}
; Simmer down, sirs!{key}{n}
; And thou, o wild one__{n}
; who might thou be?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b056, GAU
        char_event_anim SLOT_2, _d0b415, CYAN
        char_event_anim SLOT_3, _d0b415, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_70
; {gau}:{n}
; Thou?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b074, GAU
        char_event_anim SLOT_2, _d0b409, CYAN
        char_event_anim SLOT_3, _d0b409, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_71
; {gau}:{n}
; Thou! Thou!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b08a, GAU
        char_event_anim SLOT_2, _d0b415, CYAN
        char_event_anim SLOT_3, _d0b415, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_71
; {gau}:{n}
; Thou! Thou!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b0a0, GAU
        char_event_anim SLOT_2, _d0b40f, CYAN
        char_event_anim SLOT_3, _d0b40f, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_71
; {gau}:{n}
; Thou! Thou!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b0b6, GAU
        char_event_anim SLOT_2, _d0b41b, CYAN
        char_event_anim SLOT_3, _d0b409, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_71
; {gau}:{n}
; Thou! Thou!{key}{0}
        battle_dlg BATTLE_DLG_72
; {gau}:{n}
; You angry?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b0cc, SABIN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b0df, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_73
; {gau}:{n}
; {cyan}!{key}{n}
; You angry__me?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b0f2, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_73
; {gau}:{n}
; {cyan}!{key}{n}
; You angry__me?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b105, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_73
; {gau}:{n}
; {cyan}!{key}{n}
; You angry__me?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b118, SABIN
        char_event_anim SLOT_2, _d0b130, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_74
; {sabin}:{n}
; Listen, his family was just__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b143, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_75
; {gau}:{n}
; Me understand__me sorry.{key}{n}
; Me not mean person__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b40f, CYAN
        exec_event_anim
        battle_dlg BATTLE_DLG_158
; {cyan}:{n}
; Look! We can't have ye two{n}
; prancing 'round all day!{key}{n}
; {gau}, I think we're going{n}
; to get on well together.{key}{n}
; Why don't you join us?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b156, GAU
        char_event_anim SLOT_2, _d0b409, CYAN
        char_event_anim SLOT_3, _d0b409, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_159
; {gau}:{n}
; Ah! I give you present!{key}{n}
; {gau} give {cyan} and{n}
; {sabin} nice gift in thanks{n}
; for food!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b41b, GAU
        char_event_anim SLOT_2, _d0b40f, CYAN
        char_event_anim SLOT_3, _d0b169, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_160
; {sabin}:{n}
; What manner of rubbish do{n}
; you suppose he's gonna_?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b176, GAU
        char_event_anim SLOT_2, _d0b409, CYAN
        exec_event_anim
        battle_dlg BATTLE_DLG_161
; {gau}:{n}
; {gau}'s treasure__{n}
; shiny, shiny!!{key}{n}
; Shiny, shiny, shiny!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b183, SABIN
        char_event_anim SLOT_2, _d0b40f, CYAN
        char_event_anim SLOT_3, _d0b40f, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_162
; {sabin}:{n}
; Can anything be THAT shiny?{key}{0}
        battle_dlg BATTLE_DLG_163
; {gau}:{n}
; Does Mr. Thou like shiny{n}
; thing?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b415, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_164
; {sabin}:{n}
; Mr. Thou's that one,{n}
; over THERE!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b196, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_78
; A shiny thing, eh_?{key} Think how{n}
; jealous {locke}'s gonna be{n}
; when he hears about this!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b19f, GAU
        char_event_anim SLOT_2, _d0b415, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_165
; {gau}:{n}
; Who be {locke}?{n}
; He bad man?{key} Maybe he try{n}
; steal my treasure!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b1b4, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_166
; {sabin}:{n}
; {locke}? Well, he's__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b1bc, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_167
; {sabin}:{n}
; Listen when someone's talking{n}
; to you!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b40f, CYAN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b409, CYAN
        char_event_anim SLOT_2, _d0b415, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_168
; {cyan}:{n}
; I think he's trying to tell us{n}
; something!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b1cb, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_169
; {sabin}:{n}
; Urgh__{key}all right__carry on__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b1da, GAU
        char_event_anim SLOT_2, _d0b409, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_170
; {gau}:{n}
; Here! Here!{key}{n}
; Shiny thing here!!{key}{0}
        battle_dlg BATTLE_DLG_171
; {gau}:{n}
; {sabin},{key}{n}
; place where you buy food_{n}
; it called Mobliz!{key}{0}
        battle_dlg BATTLE_DLG_172
; {gau}:{n}
; {cyan},{key}{n}
; place where you stand__{n}
; river brought you there__{key}{0}
        battle_dlg BATTLE_DLG_173
; Now,{n}
; we go Crescent Mountain!{key}{n}
; Shiny thing, there!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b217, GAU
        char_event_anim SLOT_2, _d0b22c, CYAN
        char_event_anim SLOT_3, _d0b241, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_174
; {cyan}:{n}
; Look, let's just go along with{n}
; him to this Crescent Mountain.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b256, GAU
        char_event_anim SLOT_2, _d0b268, CYAN
        char_event_anim SLOT_3, _d0b27a, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_175
; {sabin}:{n}
; Phew__{key}why'd we invite him{n}
; along, anyway_?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b291, GAU
        exec_event_anim
        battle_dlg BATTLE_DLG_176
; {gau}:{n}
; Mr. Thou! Hurry up!{key}{n}
; We're leaving!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b415, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_177
; {sabin}:{n}
; Hey! I told you once,{n}
; I'm not Mr. Thou!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b2e1, SABIN
        char_event_anim SLOT_2, _d0b2e1, GAU
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b3ec, SABIN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b2f6, SABIN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b409, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_183
; KAPPA:{n}
; Here's how to build up{n}
; {gau}'s skills.{key}{0}
        battle_dlg BATTLE_DLG_178
; 1. Choose ``Leap'', a command{n}
; that only appears when you{n}
; are on the Veldt.{key}{0}
        reset_event_anim
        attack_event_anim WATER_SPLASH_BG1, SABIN, ALL_MONSTERS
        char_event_anim SLOT_1, _d0b31a, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_179
; 2. Keep fighting on the Veldt,{n}
; and {gau} will reappear.{n}
; He'll have learned the_{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b33a, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_180
; 3. _attacks of the monsters{n}
; you were fighting when he{n}
; leapt and returned!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b35f, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_181
; Uwaau~!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b36e, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_181
; Uwaau~!!{key}{0}
        battle_dlg BATTLE_DLG_182
; 4. Choose the command ``Rage''{n}
; and you can use any of the{n}
; attacks he's learned.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b37d, SABIN
        exec_event_anim
        battle_dlg BATTLE_DLG_157
; And now, please continue your{n}
; quest!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b398, SABIN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b3dd, SABIN
        char_event_anim SLOT_2, _d0b3fd, SABIN
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

; unused
_d0ac60:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        play_song GAU
        hide_attacker_char
        set_vec_target {80, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        show_attacker_char
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0ac7e:
        anim_script SPRITE, 1, CHAR
        restore_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0ac88:
        anim_script SPRITE, 1, CHAR
        attacker_char_dir LEFT
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::FIGHTING_BACK_HAND
                blank_frame
                end_loop
        set_vec_target {96, 64}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 6, 40
        reset_char_vec_offset
        set_vec_target {112, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 5, 40
        reset_char_vec_offset
        set_vec_target {128, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        set_vec_target {144, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        set_vec_target {160, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 40
        reset_char_vec_offset
        set_vec_target {176, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::BLINKING_BACK
                blank_frame 2
                end_loop
        loop 32
                attacker_action CHAR_ACTION::BLINKING_DOWN
                blank_frame 2
                end_loop
        loop 32
                attacker_action CHAR_ACTION::BLINKING_FORWARD
                blank_frame 2
                end_loop
        set_vec_target {120, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        loop 32
                attacker_action CHAR_ACTION::BLINKING_FORWARD
                blank_frame 2
                end_loop
        set_vec_target {168, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad21:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        loop 32
                attacker_action CHAR_ACTION::READY
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad2d:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        anim_speed 9
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_UP_2
        blank_frame
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame
        anim_speed 2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad46:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        set_vec_target {96, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 64
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad59:
        anim_script SPRITE, 1, CHAR
        set_vec_target {120, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 80
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad6c:
        anim_script SPRITE, 1, CHAR
        set_vec_target {40, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad7a:
        anim_script SPRITE, 1, CHAR
        set_vec_target {80, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad88:
        anim_script SPRITE, 1, CHAR
        set_vec_target {120, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 32
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0ad96:
        anim_script SPRITE, 1, CHAR
        set_vec_target {160, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 16
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0ada4:
        anim_script SPRITE, 1, CHAR
        set_vec_target {64, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0adb2:
        anim_script SPRITE, 1, CHAR
        set_vec_target {104, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0adc0:
        anim_script SPRITE, 1, CHAR
        set_vec_target {144, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 32
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0adce:
        anim_script SPRITE, 1, CHAR
        set_vec_target {184, 88}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 16
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0addc:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        loop 3
                set_vec_target {160, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {192, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {192, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {160, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {120, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {88, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {88, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {120, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                end_loop
        set_vec_target {128, 104}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0ae5d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        loop 3
                set_vec_target {168, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {200, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {200, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {168, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {128, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {96, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {96, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                set_vec_target {128, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 3, 40
                reset_char_vec_offset
                end_loop
        set_vec_target {152, 104}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0aede:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        loop 2
                set_vec_target {160, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {192, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {192, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {160, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {120, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {88, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {88, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {120, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                end_loop
        set_vec_target {128, 96}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        loop 9
                anim_speed 9
                attacker_frame CHAR_FRAME::LAUGHING_1
                blank_frame
                attacker_frame CHAR_FRAME::LAUGHING_2
                blank_frame
                anim_speed 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0af6e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        loop 3
                set_vec_target {168, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {200, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {200, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {168, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {128, 64}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {96, 88}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {96, 112}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                set_vec_target {128, 136}
                calc_vec_char
                update_char_vec_dir_walk
:               blank_frame
                move_vec_char :-, 7, 40
                reset_char_vec_offset
                end_loop
        set_vec_target {152, 96}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 64
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0afef:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::JUMPING_FORWARD
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0affd:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 72}
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 6, 80
        reset_char_vec_offset
        loop 32
                attacker_action CHAR_ACTION::BLINKING_DOWN
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b01a:
        anim_script SPRITE, 1, CHAR
        loop 12
                blank_frame
                end_loop
        set_vec_target {104, 88}
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 6, 160
        reset_char_vec_offset
        loop 32
                attacker_action CHAR_ACTION::BLINKING_BACK
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b038:
        anim_script SPRITE, 1, CHAR
        loop 12
                blank_frame
                end_loop
        set_vec_target {160, 88}
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 6, 160
        reset_char_vec_offset
        loop 32
                attacker_action CHAR_ACTION::BLINKING_FORWARD
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b056:
        anim_script SPRITE, 1, CHAR
        set_vec_target {120, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 6, 0
        reset_char_vec_offset
        set_vec_target {120, 72}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 5, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b074:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b08a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {48, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b0a0:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {208, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b0b6:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b0cc:
        anim_script SPRITE, 1, CHAR
        set_vec_target {176, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b0df:
        anim_script SPRITE, 1, CHAR
        set_vec_target {136, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 24
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b0f2:
        anim_script SPRITE, 1, CHAR
        set_vec_target {112, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 6, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b105:
        anim_script SPRITE, 1, CHAR
        set_vec_target {160, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 6, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0b118:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        set_vec_target {232, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b130:
        anim_script SPRITE, 1, CHAR
        set_vec_target {208, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b143:
        anim_script SPRITE, 1, CHAR
        set_vec_target {152, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0b156:
        anim_script SPRITE, 1, CHAR
        set_vec_target {144, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b169:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::WAGGING_FINGER
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b176:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::JUMPING_UP
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b183:
        anim_script SPRITE, 1, CHAR
        set_vec_target {208, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::HEAD_TURNED
        end_anim_script

; ------------------------------------------------------------------------------

_d0b196:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_frame CHAR_FRAME::EYES_CLOSED_DOWN
        end_anim_script

; ------------------------------------------------------------------------------

_d0b19f:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        set_vec_target {184, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b1b4:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::SPINNING
        end_anim_script

; ------------------------------------------------------------------------------

_d0b1bc:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::ARMS_RAISED_FORWARD
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b1cb:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::BLINKING_DOWN
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b1da:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        set_vec_target {136, 128}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 0
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        anim_speed 9
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1
        blank_frame 2
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        blank_frame 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1
        blank_frame 2
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        blank_frame 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1
        blank_frame 2
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        blank_frame 3
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b217:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        set_vec_target {136, 112}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b22c:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        set_vec_target {136, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b241:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        set_vec_target {152, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 24
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b256:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 161
                move_attacker FORWARD, 1
                blank_frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b268:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 161
                move_attacker FORWARD, 1
                blank_frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b27a:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 41
                move_attacker FORWARD, 1
                blank_frame 3
                end_loop
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b291:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 61
                move_attacker BACK, 1
                blank_frame 3
                end_loop
        attacker_frame CHAR_FRAME::FIGHTING_3 + $30
        move_attacker UP, 4
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 4
        blank_frame
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b2e1:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 36
                move_attacker FORWARD, 4
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b2f6:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        change_char_gfx SABIN, IMP
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 161
                move_attacker BACK, 1
                blank_frame 2
                end_loop
        loop 32
                attacker_action CHAR_ACTION::WAGGING_FINGER_ALT
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WAGGING_FINGER
        end_anim_script

; ------------------------------------------------------------------------------

_d0b31a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 16
                attacker_action CHAR_ACTION::BLINKING_DOWN
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        set_vec_target {96, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 96
        reset_char_vec_offset
        sfx SPLASH
        hide_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

_d0b33a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 7, 0
        reset_char_vec_offset
        change_char_gfx SABIN, GAU
        show_target_chars
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::SPINNING
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b35f:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::SPINNING
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0b36e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::SPINNING
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b37d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        loop 32
                attacker_action CHAR_ACTION::SPINNING
                blank_frame
                end_loop
        change_char_gfx SABIN, IMP
        loop 32
                attacker_action CHAR_ACTION::SPINNING
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b398:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 56
                move_attacker BACK, 1
                blank_frame 2
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::DEAD_HORZ + $30
                blank_frame 4
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 3
                end_loop
        loop 4
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 4
                attacker_frame CHAR_FRAME::WALKING_FORWARD_1
                blank_frame 4
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::WAGGING_FINGER
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b3dd:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 82
                move_attacker BACK, 1
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b3ec:
        anim_script SPRITE, 1, CHAR
        mod_pal BG2, SUB, WHITE, 0
        loop 32
                mod_pal BG2, SUB, WHITE, +1
                blank_frame 2
                end_loop
        play_song SPINACH_RAG
        end_anim_script

; ------------------------------------------------------------------------------

_d0b3fd:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b409:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b40f:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b415:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b41b:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 28: Gau gets scared away ]

_d0b421:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::GAU_RUNS_AWAY
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0b436, GAU
        exec_event_anim
        open_dlg_window
        battle_dlg BATTLE_DLG_57
; {gau}:{n}
; Uwaou!! {key}Waooo__ooo!{key}{n}
; You__strangers_! {key}Go away!{key}{n}
; You scare animals!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b455, GAU
        char_event_anim SLOT_2, _d0b4ab, GAU
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0b436:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_char_dir LEFT
        anim_speed 11
        attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b455:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        set_vec_target {104, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        set_vec_target {80, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        set_vec_target {56, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        set_vec_target {32, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        set_vec_target {8, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        hide_attacker_char
        end_anim_script

; ------------------------------------------------------------------------------

_d0b4ab:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 5
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 19: Kefka at sealed gate 1 ]

_d0b4ba:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::KEFKA_SEALED_GATE_1
        battle_event
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0b5f2, LOCKE
        char_event_anim SLOT_2, _d0b5f2, CYAN
        char_event_anim SLOT_3, _d0b5f2, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b5f2, SABIN
        char_event_anim SLOT_2, _d0b5f2, SETZER
        char_event_anim SLOT_3, _d0b5f2, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b5f2, GAU
        char_event_anim SLOT_2, _d0b5f2, GOGO
        char_event_anim SLOT_3, _d0b5f2, UMARO
        exec_event_anim
        battle_dlg BATTLE_DLG_95
; K__{key}Kefka!!{key}{n}
; You followed us!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b569, KEFKA_2
        exec_event_anim
        battle_dlg BATTLE_DLG_96
; KEFKA:{n}
; U'hee, hee, heeee!!!!{key}{n}
; The Emperor was right!{key}{n}
; Let {terra} fall into your{n}
; hands, {key}and you'd open the{n}
; gate for us_!{key}{0}
        battle_dlg BATTLE_DLG_97
; __!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b5fe, KEFKA_2
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b57e, KEFKA_2
        exec_event_anim
        battle_dlg BATTLE_DLG_98
; KEFKA:{n}
; How does it feel to know{n}
; you've been working for us?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b604, KEFKA_2
        exec_event_anim
        battle_dlg BATTLE_DLG_99
; KEFKA:{n}
; Now I fear you've outlived{n}
; your usefulness__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b5a2, LOCKE
        char_event_anim SLOT_2, _d0b5a2, CYAN
        char_event_anim SLOT_3, _d0b5a2, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b5a2, SABIN
        char_event_anim SLOT_2, _d0b5a2, SETZER
        char_event_anim SLOT_3, _d0b5a2, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b5a2, GAU
        char_event_anim SLOT_2, _d0b5a2, GOGO
        char_event_anim SLOT_3, _d0b5a2, UMARO
        exec_event_anim
        battle_dlg BATTLE_DLG_100
; You'd better think again,{n}
; Kefka!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b569, KEFKA_2
        exec_event_anim
        battle_dlg BATTLE_DLG_101
; KEFKA:{n}
; Oh dear__{key}{n}
; you wanna fight me?!{key}{n}
; This is just dreadful!{key}{0}
        battle_dlg BATTLE_DLG_102
; Keep Kefka busy{key}{n}
; until {terra} slips through{n}
; the gate!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b586, LOCKE
        char_event_anim SLOT_2, _d0b586, CYAN
        char_event_anim SLOT_3, _d0b586, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b586, SABIN
        char_event_anim SLOT_2, _d0b586, SETZER
        char_event_anim SLOT_3, _d0b586, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b586, GAU
        char_event_anim SLOT_2, _d0b586, GOGO
        char_event_anim SLOT_3, _d0b586, UMARO
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0b569:
        anim_script SPRITE, 1, CHAR
        loop 9
                anim_speed 9
                attacker_frame CHAR_FRAME::LAUGHING_1
                blank_frame
                attacker_frame CHAR_FRAME::LAUGHING_2
                blank_frame
                anim_speed 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b57e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WAGGING_FINGER
        end_anim_script

; ------------------------------------------------------------------------------

_d0b586:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0b59c:
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b5a2:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        blank_frame
        fixed_draw_order
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 13
                move_attacker FORWARD, 4
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        move_attacker UP, 4
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 4
        blank_frame
        attacker_frame CHAR_FRAME::READY
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

_d0b5f2:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::READY
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0b5f8:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b5fe:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b604:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b60a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 20: Kefka at sealed gate 2 ]

_d0b610:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::KEFKA_SEALED_GATE_2
        battle_event
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0b7c8, LOCKE
        char_event_anim SLOT_2, _d0b7c8, CYAN
        char_event_anim SLOT_3, _d0b7c8, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7c8, SABIN
        char_event_anim SLOT_2, _d0b7c8, SETZER
        char_event_anim SLOT_3, _d0b7c8, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7c8, GAU
        char_event_anim SLOT_2, _d0b7c8, GOGO
        char_event_anim SLOT_3, _d0b7c8, UMARO
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b800, KEFKA_2
        exec_event_anim
        battle_dlg BATTLE_DLG_87
; KEFKA:{n}
; It opened!!{key}{0}
        battle_dlg BATTLE_DLG_89
; {terra}!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b7c8, LOCKE
        char_event_anim SLOT_2, _d0b7c8, CYAN
        char_event_anim SLOT_3, _d0b7c8, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7c8, SABIN
        char_event_anim SLOT_2, _d0b7c8, SETZER
        char_event_anim SLOT_3, _d0b7c8, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7c8, GAU
        char_event_anim SLOT_2, _d0b7c8, GOGO
        char_event_anim SLOT_3, _d0b7c8, UMARO
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7ee, LOCKE
        char_event_anim SLOT_2, _d0b7ee, CYAN
        char_event_anim SLOT_3, _d0b7ee, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7ee, SABIN
        char_event_anim SLOT_2, _d0b7ee, SETZER
        char_event_anim SLOT_3, _d0b7ee, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7ee, GAU
        char_event_anim SLOT_2, _d0b7ee, GOGO
        char_event_anim SLOT_3, _d0b7ee, UMARO
        exec_event_anim
        battle_dlg BATTLE_DLG_90
; KEFKA:{n}
; I, {key}I, {key}I, {key}I feel so anxious.{key}{0}
        battle_dlg BATTLE_DLG_91
; Something's coming!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b9da, KEFKA_2
        char_event_anim SLOT_2, _d0b7db, KEFKA_2
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7ce, LOCKE
        char_event_anim SLOT_2, _d0b7ce, CYAN
        char_event_anim SLOT_3, _d0b7ce, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7ce, SABIN
        char_event_anim SLOT_2, _d0b7ce, SETZER
        char_event_anim SLOT_3, _d0b7ce, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7ce, GAU
        char_event_anim SLOT_2, _d0b7ce, GOGO
        char_event_anim SLOT_3, _d0b7ce, UMARO
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_BAHAMUT
        char_event_anim SLOT_1, _d0b8be, KEFKA_2
        char_event_anim SLOT_2, _d0b881, KEFKA_2
        char_event_anim SLOT_3, _d0b98a, GOGO
        char_event_anim SLOT_4, _d0b98a, GAU
        exec_event_anim
        attack_event_anim EVENT_ZONESEEK
        char_event_anim SLOT_1, _d0b8e0, KEFKA_2
        char_event_anim SLOT_2, _d0b881, KEFKA_2
        char_event_anim SLOT_3, _d0b98a, SABIN
        char_event_anim SLOT_4, _d0b98a, UMARO
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b84d, KEFKA_2
        exec_event_anim
        battle_dlg BATTLE_DLG_92
; KEFKA:{n}
; Frightful energy!!{key}{0}
        reset_event_anim
        attack_event_anim EVENT_FENRIR
        char_event_anim SLOT_1, _d0b902, KEFKA_2
        char_event_anim SLOT_2, _d0b881, KEFKA_2
        char_event_anim SLOT_3, _d0b7db, KEFKA_2
        char_event_anim SLOT_4, _d0b98a, MOG
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_TERRATO
        char_event_anim SLOT_1, _d0b946, KEFKA_2
        char_event_anim SLOT_2, _d0b881, KEFKA_2
        char_event_anim SLOT_3, _d0b98a, LOCKE
        char_event_anim SLOT_4, _d0b98a, CYAN
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_SHIVA
        char_event_anim SLOT_1, _d0b924, KEFKA_2
        char_event_anim SLOT_2, _d0b881, KEFKA_2
        char_event_anim SLOT_3, _d0b98a, EDGAR
        char_event_anim SLOT_4, _d0b994, KEFKA_2
        exec_event_anim
        battle_dlg BATTLE_DLG_93
; KEFKA:{n}
; Uwaaa!{wait}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ba03, KEFKA_2
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_KIRIN
        char_event_anim SLOT_1, _d0b968, KEFKA_2
        char_event_anim SLOT_2, _d0b881, KEFKA_2
        char_event_anim SLOT_3, _d0b98a, SETZER
        char_event_anim SLOT_4, _d0b9a1, KEFKA_2
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7e8, LOCKE
        char_event_anim SLOT_2, _d0b7e8, CYAN
        char_event_anim SLOT_3, _d0b7e8, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7e8, SABIN
        char_event_anim SLOT_2, _d0b7e8, SETZER
        char_event_anim SLOT_3, _d0b7e8, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b7e8, GAU
        char_event_anim SLOT_2, _d0b7e8, GOGO
        char_event_anim SLOT_3, _d0b7e8, UMARO
        exec_event_anim
        battle_dlg BATTLE_DLG_89
; {terra}!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b9f0, LOCKE
        char_event_anim SLOT_2, _d0b9f0, CYAN
        char_event_anim SLOT_3, _d0b9f0, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b9f0, SABIN
        char_event_anim SLOT_2, _d0b9f0, SETZER
        char_event_anim SLOT_3, _d0b9f0, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0b9f0, GAU
        char_event_anim SLOT_2, _d0b9f0, GOGO
        char_event_anim SLOT_3, _d0b9f0, UMARO
        exec_event_anim
        battle_dlg BATTLE_DLG_94
; {terra}:{n}
; ___{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0b9d4, KEFKA_2
        char_event_anim SLOT_2, _d0b9e2, KEFKA_2
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0b7c8:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b7ce:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::SURPRISED
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::DEAD_VERT
        end_anim_script

; ------------------------------------------------------------------------------

_d0b7db:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::SURPRISED
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::DEAD_VERT + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0b7e8:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b7ee:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        calc_vec_rel {-8, 0}
        calc_vec_char
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0b800:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        attacker_char_dir RIGHT
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0b819:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 3
                end_loop
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {96, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        loop 26
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b83d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::BLINKING_DOWN
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::SURPRISED
        end_anim_script

; ------------------------------------------------------------------------------

_d0b84d:
        anim_script SPRITE, 1, CHAR
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL
                blank_frame 5
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL + $30
                blank_frame 5
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL
                blank_frame 5
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL + $30
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        blank_frame 2
        end_anim_script

; ------------------------------------------------------------------------------

_d0b881:
        anim_script SPRITE
        disable_char_pal_update
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        enable_char_pal_update
        end_anim_script

; ------------------------------------------------------------------------------

_d0b8be:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move UP, 1
                end_loop
        loop 52
                move FORWARD, 7
                move UP, 2
                update_vec_wave_wide 4
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b8e0:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 6
                end_loop
        loop 49
                move FORWARD, 7
                move UP, 2
                update_vec_wave_narrow 15
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b902:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move UP, 3
                end_loop
        loop 49
                move FORWARD, 8
                move UP, 3
                update_vec_wave_narrow 4
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b924:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 2
                end_loop
        loop 64
                move FORWARD, 5
                move UP, 2
                update_vec_wave_wide 1
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b946:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 11
                end_loop
        loop 49
                move FORWARD, 8
                move UP, 3
                update_vec_wave_narrow 4
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b968:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 3
                end_loop
        loop 64
                move FORWARD, 6
                move UP, 3
                update_vec_wave_narrow 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0b98a:
        anim_script SPRITE, 1, CHAR
        loop 13
                move_attacker FORWARD, 3
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b994:
        anim_script SPRITE, 1, CHAR
        loop 22
                move_attacker FORWARD, 6
                move_attacker UP, 2
                blank_frame
                end_loop
        hide_attacker_char
        end_anim_script

; ------------------------------------------------------------------------------

_d0b9a1:
        anim_script SPRITE, 1, CHAR
        loop 32
                move_attacker BACK, 8
                blank_frame
                end_loop
        show_attacker_char
        attacker_frame CHAR_FRAME::DEAD_HORZ + $30
        loop 22
                move_attacker FORWARD, 6
                move_attacker DOWN, 2
                end_loop
        blank_frame
        fixed_draw_order
        loop 22
                move_attacker BACK, 6
                move_attacker UP, 2
                end_loop
        loop 22
                move_attacker FORWARD, 6
                move_attacker DOWN, 2
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::DEAD_VERT
        loop 6
                move_attacker FORWARD, 4
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0b9d4:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::DEAD_VERT
        end_anim_script

; ------------------------------------------------------------------------------

_d0b9da:
        anim_script SPRITE, 1, CHAR
        play_song METAMORPHOSIS
        end_anim_script

; ------------------------------------------------------------------------------

_d0b9e2:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0b9f0:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 13
                move_attacker FORWARD, 4
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ba03:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        change_char_gfx KEFKA_2, TERRA
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0ba0c:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0ba12:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0ba18:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0ba1e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 21: espers fly over airship ]

_d0ba24:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::AIRSHIP_GENJU
        battle_event
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0bafd, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0bb13, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_103
; {locke}:{n}
; What's wrong, {terra}?{key}{0}
        battle_dlg BATTLE_DLG_104
; {terra}:{n}
; I can feel it__{key}{n}
; It's coming closer and closer_{key}{0}
        battle_dlg BATTLE_DLG_105
; {locke}:{n}
; What do you mean you can{n}
; feel it?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bb29, TERRA
        char_event_anim SLOT_2, _d0bcf0, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_106
; {terra}:{n}
; It was__glowing!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bb3f, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_107
; {locke}:{n}
; What's that?{key}{0}
        battle_dlg BATTLE_DLG_108
; {locke}:{n}
; It can't be__!{key}{n}
; An Esper???{key}{0}
        battle_dlg BATTLE_DLG_109
; {locke}:{n}
; It's coming!!!{key}{n}
; Watch out, {terra}!!{key}{0}
        reset_event_anim
        attack_event_anim EVENT_BAHAMUT
        char_event_anim SLOT_1, _d0bc23, TERRA
        char_event_anim SLOT_2, _d0bb55, TERRA
        char_event_anim SLOT_3, _d0bb62, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0bb78, SETZER
        exec_event_anim
        battle_dlg BATTLE_DLG_110
; {setzer}:{n}
; What was that!?{key}{0}
        battle_dlg BATTLE_DLG_111
; {locke}:{n}
; {setzer}, get down!{key}{0}
        reset_event_anim
        attack_event_anim EVENT_KIRIN
        char_event_anim SLOT_1, _d0bc49, TERRA
        char_event_anim SLOT_2, _d0bb8e, LOCKE
        char_event_anim SLOT_3, _d0bb55, SETZER
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_BISMARK
        char_event_anim SLOT_1, _d0bc6f, TERRA
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_CARBUNKL
        char_event_anim SLOT_1, _d0bc95, TERRA
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_PHANTOM
        char_event_anim SLOT_1, _d0bcbb, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0bcfd, TERRA
        char_event_anim SLOT_2, _d0bd30, LOCKE
        char_event_anim SLOT_3, _d0bd03, SETZER
        exec_event_anim
        battle_dlg BATTLE_DLG_112
; {setzer}:{n}
; Gulp__Espers__?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bd63, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_113
; {locke}:{n}
; Where are they going?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bbbd, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_114
; {terra}:{n}
; They were mad__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bd75, LOCKE
        char_event_anim SLOT_2, _d0bd75, SETZER
        exec_event_anim
        battle_dlg BATTLE_DLG_50
; {locke}:{n}
; They seemed__angry.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bd5d, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_115
; {terra}:{n}
; No__{key}Stop_!{key}{n}
; Please, {key}don't go!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bd69, SETZER
        exec_event_anim
        battle_dlg BATTLE_DLG_51
; {setzer}:{n}
; Forget that__{n}
; what's with this vibration?!{key}{n}
; Is it from the Espers?{key}{0}
        battle_dlg BATTLE_DLG_116
; {edgar}:{n}
; Um__{setzer} !!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bd63, LOCKE
        char_event_anim SLOT_2, _d0bd63, SETZER
        char_event_anim SLOT_3, _d0bd63, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_117
; {key}I've lost control!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bbd3, LOCKE
        char_event_anim SLOT_2, _d0bbd3, SETZER
        char_event_anim SLOT_3, _d0bbd3, TERRA
        char_event_anim SLOT_4, _d0bce2, TERRA
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0bafd:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bb13:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bb29:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bb3f:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bb55:
        anim_script SPRITE, 1, CHAR
        loop 16
                attacker_frame CHAR_FRAME::WALKING_UP_2
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::DEAD_HORZ + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0bb62:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 8
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_HORZ + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0bb78:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 123}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bb8e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_HORZ + $30
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0bb4:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 9
                anim_speed 9
                attacker_frame CHAR_FRAME::WALKING_DOWN_2
                blank_frame
                attacker_frame CHAR_FRAME::SURPRISED
                blank_frame
                anim_speed 2
                end_loop
        end_anim_script

        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bbbd:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bbd3:
        anim_script SPRITE, 1, CHAR
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::SURPRISED
        move_attacker UP, 4
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 4
        blank_frame
        attacker_action CHAR_ACTION::NONE
        set_vec_target {120, 176}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0bc23:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move UP, 32
                move FORWARD, 1
                end_loop
        loop 52
                move DOWN, 7
                move BACK, 3
                update_vec_wave_wide 4
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0bc49:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move UP, 32
                move BACK, 3
                end_loop
        loop 64
                move FORWARD, 3
                move DOWN, 7
                update_vec_wave_narrow 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0bc6f:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move UP, 32
                move BACK, 3
                end_loop
        loop 64
                move FORWARD, 3
                move DOWN, 6
                update_vec_wave_narrow 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0bc95:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move UP, 32
                move FORWARD, 3
                end_loop
        loop 64
                move BACK, 2
                move DOWN, 7
                update_vec_wave_wide 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0bcbb:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move UP, 32
                move FORWARD, 3
                end_loop
        mod_pal BG2, SUB, CYAN, 0
        loop 64
                mod_pal BG2, SUB, CYAN, +1
                move BACK, 3
                move DOWN, 8
                update_vec_wave_narrow 5
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0bce2:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0bcf0:
        anim_script SPRITE
        fixed_draw_order
        mod_pal BG2, ADD, WHITE, 7
        loop 8
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0bcfd:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0bd03:
        anim_script SPRITE, 1, CHAR
        loop 8
                move_attacker FORWARD, 2
                blank_frame
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL + $30
                blank_frame 5
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL
                blank_frame 5
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL + $30
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0bd30:
        anim_script SPRITE, 1, CHAR
        loop 8
                move_attacker BACK, 2
                blank_frame
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL
                blank_frame 5
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL + $30
                blank_frame 5
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::NEAR_FATAL
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bd5d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::EYES_CLOSED_DOWN
        end_anim_script

; ------------------------------------------------------------------------------

_d0bd63:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bd69:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0bd6f:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bd75:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::BATTLE_EVENT_SCRIPT_2

; ------------------------------------------------------------------------------

; [ battle event 22: Relm intro with Ultros ]

_d0bd7b:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::RELM_ULTROS_INTRO
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d0be2c, RELM
        exec_event_anim
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0be46, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_118
; {relm}:{n}
; Grandpa!{key}{n}
; I'm here__!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0be65, STRAGO
        exec_event_anim
        battle_dlg BATTLE_DLG_119
; {strago}:{n}
; {relm}!{key}{n}
; I told you to stay at home!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0be93, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_120
; {relm}:{n}
; I couldn't miss the chance to{n}
; practice my drawing!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0beb9, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_121
; Say, sweetie, who are you?{key}{0}
        battle_dlg BATTLE_DLG_122
; ULTROS:{n}
; How dare you!{key}{n}
; I'm Ultros!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0becf, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_123
; {locke}:{n}
; {relm} and Ultros__{key}{n}
; What ARE you doing__?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0befa, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_124
; {relm}:{n}
; Listen, Ulty__{key}{n}
; Why don't you pose for me?{key}{0}
        battle_dlg BATTLE_DLG_125
; ULTROS:{n}
; I'm not one of your kiddy{n}
; friends!{key} Don't talk to me as if{n}
; I were!!{key}{n}
; I don't want a portrait!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bf09, RELM
        char_event_anim SLOT_2, _d0c12d, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_126
; {relm}:{n}
; Forget it!{key}{n}
; I don't wanna draw it{n}
; anymore!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c12d, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_127
; {relm}:{n}
; It's okay__{key}{n}
; I'll just jump down from{n}
; here.{wait}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bf1f, TERRA
        char_event_anim SLOT_2, _d0bf51, STRAGO
        exec_event_anim
        battle_dlg BATTLE_DLG_128
; {terra}:{n}
; No!!{n}
; You can't do that!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bf60, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_129
; Whisper, whisper__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bf86, TERRA
        char_event_anim SLOT_2, _d0c115, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_130
; {terra}:{n}
; How dare you bother that{n}
; little girl!{key}{n}
; I'm not going to forgive{n}
; you if you hurt her!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bfc2, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_131
; ULTROS:{n}
; Well, whadduya want I should{n}
; do?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0bfe5, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_132
; {locke}:{n}
; Ask her to draw your{n}
; portrait. {key}She may actually{n}
; make you look pleasant!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c008, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_240
; {locke}:{n}
; Don't be so heartless!{key}{0}
        battle_dlg BATTLE_DLG_241
; ULTROS:{n}
; ___{key}{n}
; ___{key}{n}
; ___{key}{n}
; ___{key}{n}
; ___{key}{n}
; ___{key}{n}
; ___{key}{n}
; ___{key}{n}
; Oh, all right, Uncle Ulty REALLY{n}
; wants you to do his portrait!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c02b, RELM
        exec_event_anim
        battle_dlg BATTLE_DLG_242
; {relm}:{n}
; Hee, hee, hee_{key}{n}
; You're gonna love it!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c050, STRAGO
        exec_event_anim
        battle_dlg BATTLE_DLG_243
; {strago}:{n}
; At any rate, come here!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c05f, TERRA
        char_event_anim SLOT_2, _d0c077, LOCKE
        char_event_anim SLOT_3, _d0c05f, STRAGO
        char_event_anim SLOT_4, _d0c0a9, RELM
        exec_event_anim
        add_char_target RELM
        show_char_menu RELM
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0be2c:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        show_char RELM
        play_song RELM
        set_vec_target {144, 152}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 8, 0
        reset_char_vec_offset
        end_anim_script

; ------------------------------------------------------------------------------

_d0be46:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        loop 32
                move_attacker UP, 7
                end_loop
        show_attacker_char
        attacker_action CHAR_ACTION::SPINNING
        blank_frame
        loop 40
                move_attacker DOWN, 4
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        call _d0c0de
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0be65:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::SURPRISED
        call _d0c0de
        anim_speed 5
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0be93:
        anim_script SPRITE, 1, CHAR
        anim_speed 5
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0beb9:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {120, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0becf:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {152, 152}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 40
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        loop 16
                move_attacker UP, 1
                blank_frame 4
                end_loop
        loop 16
                attacker_action CHAR_ACTION::BLINKING_DOWN
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0befa:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::FIGHTING_FRONT_HAND
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bf09:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_VERT
        end_anim_script

; ------------------------------------------------------------------------------

_d0bf1f:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {160, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        set_vec_target {144, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 16
        reset_char_vec_offset
        set_vec_target {112, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0bf51:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::SURPRISED
        loop 2
                call _d0c0de
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bf60:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::WALKING_UP_2
                blank_frame 2
                end_loop
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_UP_2
        set_vec_target {120, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bf86:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {112, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        set_vec_target {112, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::FIGHTING_FRONT_HAND
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0bfc2:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        set_vec_target {160, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 24
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::HEAD_TURNED
        end_anim_script

; ------------------------------------------------------------------------------

_d0bfe5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {112, 160}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 32
        reset_char_vec_offset
        set_vec_target {64, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c008:
        anim_script SPRITE, 1, CHAR
        anim_speed 5
        attacker_frame CHAR_FRAME::READY
        blank_frame
        attacker_frame CHAR_FRAME::HEAD_TURNED
        blank_frame
        attacker_frame CHAR_FRAME::READY
        blank_frame
        attacker_frame CHAR_FRAME::HEAD_TURNED
        blank_frame
        attacker_frame CHAR_FRAME::READY
        blank_frame
        attacker_frame CHAR_FRAME::HEAD_TURNED
        blank_frame
        anim_speed 2
        attacker_frame CHAR_FRAME::HEAD_TURNED
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

_d0c02b:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL
        call _d0c0de
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        loop 32
                attacker_action CHAR_ACTION::WINKING_DOWN
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c050:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::BLINKING_FORWARD
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c05f:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

_d0c077:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 112}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 0
        reset_char_vec_offset
        set_vec_target {160, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 32
        reset_char_vec_offset
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 32
        reset_char_vec_offset
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

_d0c0a9:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        set_vec_target {160, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 24
        reset_char_vec_offset
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 3, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::NONE
        restore_attacker_char_pos
        end_anim_script

; ------------------------------------------------------------------------------

_d0c0de:
        move_attacker UP, 4
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 3
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 2
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker UP, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 1
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 2
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        blank_frame
        move_attacker DOWN, 4
        blank_frame
        return

; ------------------------------------------------------------------------------

_d0c115:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c11b:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c121:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c127:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c12d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 23: Kefka kills Leo ]

_d0c133:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::KEFKA_KILLS_LEO
        battle_event
        open_dlg_window
        battle_dlg BATTLE_DLG_133
; KEFKA:{n}
; Ah__Leo__always the{n}
; consummate soldier__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c1b6, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_134
; LEO:{n}
; Where are you, Kefka__{key}{n}
; Show yourself!!{key}{0}
        battle_dlg BATTLE_DLG_135
; KEFKA:{n}
; E{key}M{key}P{key}E{key}R{key}O{key}R{key} G{key}E{key}S{key}T{key}A{key}H{key}L__{key}{n}
; I need you here__{key}{0}
        reset_event_anim
        attack_event_anim SHOCK
        char_event_anim SLOT_1, _d0c227, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_136
; EMPEROR GESTAHL:{n}
; Leo__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c37c, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_137
; LEO:{n}
; My liege!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c1fb, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_138
; I'm sorry I deceived even{n}
; you, Leo.{key} My purpose has been{n}
; to gather Magicite, {key}and grow{n}
; powerful__{key}{n}
; Please understand me__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c37c, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_139
; LEO:{n}
; But, Emperor_!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c1fb, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_140
; GESTAHL:{n}
; Don't say anything.{key}{n}
; I understand how you feel.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c211, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_141
; KEFKA:{n}
; Uwee, hee, hee__{key}{n}
; That's right! {key}{n}
; What we have to do now is{n}
; to collect Magicite!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c37c, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_142
; LEO:{n}
; But my liege__what have I{n}
; been fighting for_?{key}{0}
        battle_dlg BATTLE_DLG_143
; GESTAHL:{n}
; Leo, I'd like you to take a{n}
; nice, long snooze_!{key}{n}
; Very long! Uwa, ha!{key}{0}
        reset_event_anim
        attack_event_anim SHOCK
        char_event_anim SLOT_1, _d0c255, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c281, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_144
; LEO:{n}
; !!!{key}{0}
        battle_dlg BATTLE_DLG_145
; KEFKA:{n}
; So__you think you hit me?!{key}{n}
; That was simply my shadow!{key}{n}
; And how did you like my{n}
; Gestahl? {key}I should've been on{n}
; the stage!{key} Well, General__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c297, TERRA
        char_event_anim SLOT_2, _d0c2ad, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_146
; You're such a goody{n}
; two-shoes!{key}{0}
        battle_dlg BATTLE_DLG_147
; LEO:{n}
; Shut up, Kefka!{key}{n}
; I oughtta__{key}{0}
        battle_dlg BATTLE_DLG_148
; KEFKA:{n}
; Oh! A threat_?{key} You're such a{n}
; violent little brute!{key}{n}
; I'll tell your ``liege'' I had to{n}
; exterminate a traitor_!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c2d4, TERRA
        char_event_anim SLOT_2, _d0c2f5, LEO
        exec_event_anim
        battle_dlg BATTLE_DLG_149
; KEFKA:{n}
; Hate__hate__HATE!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c35c, TERRA
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0c1b6:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        play_song GESTAHL
        set_vec_target {136, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 3
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
                blank_frame 2
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
                blank_frame 2
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        blank_frame 2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c1fb:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {168, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

_d0c211:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c227:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 56}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 4, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        change_char_gfx TERRA, GESTAHL
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move DOWN_BACK, 8
        anim_speed 7
        frame 0
        frame 1
        show_attacker_char
        frame 2
        frame 3
        anim_speed 2
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c255:
        anim_script SPRITE, 1, CHAR
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move DOWN_BACK, 8
        anim_speed 7
        frame 0
        frame 1
        hide_attacker_char
        frame 2
        frame 3
        loop 8
                frame 15
                end_loop
        change_char_gfx TERRA, KEFKA
        frame 0
        frame 1
        show_attacker_char
        frame 2
        frame 3
        anim_speed 2
        attacker_action CHAR_ACTION::NONE
        loop 32
                attacker_action CHAR_ACTION::LAUGHING
                frame 15, 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c281:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c297:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {136, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c2ad:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::NONE
                blank_frame
                end_loop
        set_vec_target {136, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 32
        reset_char_vec_offset
        set_vec_target {136, 112}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_VERT
        end_anim_script

; ------------------------------------------------------------------------------

_d0c2d4:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::SURPRISED
        set_vec_target {136, 112}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 96
        reset_char_vec_offset
        mod_pal BG2, SUB, CYAN, 31
        sfx SWORD
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::LAUGHING
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c2f5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        set_vec_target {136, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::DEAD_VERT
                blank_frame 3
                end_loop
        anim_speed 2
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 2
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 2
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 2
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 2
        hide_attacker_char
        blank_frame
        show_attacker_char
        blank_frame
        anim_speed 2
        hide_attacker_char
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

_d0c33e:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        play_song GESTAHL
        hide_attacker_char
        set_vec_target {64, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 5, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        show_attacker_char
        end_anim_script

; ------------------------------------------------------------------------------

_d0c35c:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c36a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c370:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c376:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c37c:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 24: Espers leave sealed gate to during Thamasa scene ]

_d0c382:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::THAMASA_SEALED_GATE
        battle_event
        open_dlg_window
        reset_event_anim
        attack_event_anim EVENT_BAHAMUT
        char_event_anim SLOT_1, _d0c3e1, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_208
; Wait! We're here to help!{wait}{0}
        reset_event_anim
        attack_event_anim EVENT_ZONESEEK
        char_event_anim SLOT_1, _d0c407, TERRA
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_FENRIR
        char_event_anim SLOT_1, _d0c42d, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_209
; Hurry!{wait}{0}
        reset_event_anim
        attack_event_anim EVENT_SHIVA
        char_event_anim SLOT_1, _d0c453, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_210
; Get going!{wait}{0}
        reset_event_anim
        attack_event_anim EVENT_KIRIN
        char_event_anim SLOT_1, _d0c479, TERRA
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_BISMARK
        char_event_anim SLOT_1, _d0c49f, TERRA
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_CARBUNKL
        char_event_anim SLOT_1, _d0c4c5, TERRA
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_PHANTOM
        char_event_anim SLOT_1, _d0c4e9, TERRA
        char_event_anim SLOT_2, _d0c50f, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_211
; We've no time to lose!{wait}{0}
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0c3e1:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move UP, 1
                end_loop
        loop 52
                move FORWARD, 7
                move UP, 2
                update_vec_wave_wide 4
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c407:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 6
                end_loop
        loop 49
                move FORWARD, 7
                move UP, 2
                update_vec_wave_narrow 15
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c42d:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move UP, 3
                end_loop
        loop 49
                move FORWARD, 8
                move UP, 3
                update_vec_wave_narrow 4
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c453:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 11
                end_loop
        loop 64
                move FORWARD, 8
                move UP, 3
                update_vec_wave_narrow 4
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c479:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 3
                end_loop
        loop 64
                move FORWARD, 6
                move UP, 3
                update_vec_wave_narrow 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c49f:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 3
                end_loop
        loop 64
                move FORWARD, 6
                move UP, 3
                update_vec_wave_narrow 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c4c5:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 3
                end_loop
        loop 64
                move FORWARD, 6
                update_vec_wave_narrow 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c4e9:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        shake_bg ENABLE
        loop 7
                move BACK, 32
                move DOWN, 3
                end_loop
        loop 64
                move FORWARD, 6
                move UP, 2
                update_vec_wave_narrow 5
                frame 0
                end_loop
        shake_bg DISABLE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c50f:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 25: unused blitz tutorial ]

_d0c51d:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::UNUSED_BLITZ_TUTORIAL
        battle_event
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0c604, CYAN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c6a9, CYAN
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_SHIVA
        char_event_anim SLOT_1, _d0c71c, SHADOW
        char_event_anim SLOT_2, _d0c79c, SHADOW
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c672, CYAN
        exec_event_anim
        battle_dlg BATTLE_DLG_212
; 1. Choose ``Blitz'' and press the{n}
; A Button.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c61a, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_213
; 2. When the cursor appears,{n}
; enter your technique.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c6a9, LOCKE
        char_event_anim SLOT_2, _d0c6a9, CYAN
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_PHANTOM
        char_event_anim SLOT_1, _d0c77c, SHADOW
        char_event_anim SLOT_2, _d0c79c, SHADOW
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_KIRIN
        char_event_anim SLOT_1, _d0c73c, SHADOW
        char_event_anim SLOT_2, _d0c79c, SHADOW
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c672, LOCKE
        char_event_anim SLOT_2, _d0c672, CYAN
        exec_event_anim
        battle_dlg BATTLE_DLG_214
; 3. Using the Control Pad, press{n}
; left, right, and left again.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c630, LOCKE
        char_event_anim SLOT_2, _d0c646, CYAN
        exec_event_anim
        battle_dlg BATTLE_DLG_215
; 4. Finally, press the A Button{n}
; to engage the attack.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c65c, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_216
; 5. If you make a mistake,{n}
; nothing will happen. Relax,{n}
; there's no need to hurry!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c69a, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c6a9, LOCKE
        char_event_anim SLOT_2, _d0c6a9, CYAN
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_BISMARK
        char_event_anim SLOT_1, _d0c75c, SHADOW
        char_event_anim SLOT_2, _d0c79c, SHADOW
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_BAHAMUT
        char_event_anim SLOT_1, _d0c6dc, SHADOW
        char_event_anim SLOT_2, _d0c79c, SHADOW
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c672, LOCKE
        char_event_anim SLOT_2, _d0c672, CYAN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c6a9, LOCKE
        char_event_anim SLOT_2, _d0c6a9, CYAN
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_ZONESEEK
        char_event_anim SLOT_1, _d0c6fc, SHADOW
        char_event_anim SLOT_2, _d0c79c, SHADOW
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c672, LOCKE
        char_event_anim SLOT_2, _d0c672, CYAN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c6a9, LOCKE
        char_event_anim SLOT_2, _d0c6a9, CYAN
        exec_event_anim
        reset_event_anim
        attack_event_anim EVENT_KIRIN
        char_event_anim SLOT_1, _d0c73c, SHADOW
        char_event_anim SLOT_2, _d0c6b6, TERRA
        char_event_anim SLOT_2, _d0c79c, SHADOW
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0c604:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c61a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {104, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c630:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {88, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 5, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0c646:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {80, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 5, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0c65c:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c672:
        anim_script SPRITE, 1, CHAR
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
                blank_frame 2
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
                blank_frame 2
                end_loop
        loop 16
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        blank_frame 2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c69a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::LAUGHING
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

_d0c6a9:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::SURPRISED
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::DEAD_VERT
        end_anim_script

; ------------------------------------------------------------------------------

_d0c6b6:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c6c4:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c6ca:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c6d0:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0c6d6:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c6dc:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        loop 7
                move FORWARD, 32
                move UP, 1
                end_loop
        loop 52
                move BACK, 7
                move UP, 1
                update_vec_wave_wide 3
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c6fc:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        loop 7
                move BACK, 32
                move DOWN, 6
                end_loop
        loop 49
                move FORWARD, 7
                move UP, 2
                update_vec_wave_narrow 5
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c71c:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        loop 7
                move BACK, 32
                move DOWN, 1
                end_loop
        loop 64
                move FORWARD, 7
                move UP, 1
                update_vec_wave_narrow 4
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c73c:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        loop 7
                move BACK, 32
                move DOWN, 3
                end_loop
        loop 64
                move FORWARD, 6
                move UP, 2
                update_vec_wave_narrow 5
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c75c:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        loop 7
                move BACK, 32
                move DOWN, 5
                end_loop
        loop 64
                move FORWARD, 6
                move UP, 3
                update_vec_wave_narrow 5
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c77c:
        anim_script SPRITE
        blank_frame
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        move_xy {128, 112}
        loop 7
                move FORWARD, 32
                move DOWN, 3
                end_loop
        loop 64
                move BACK, 6
                move UP, 2
                update_vec_wave_narrow 5
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c79c:
        anim_script SPRITE
        fixed_draw_order
        disable_char_pal_update
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 29
        mod_pal CHAR, ADD, WHITE, 29
        loop 6
                mod_pal BG2, ADD, WHITE, -6
                blank_frame
                mod_pal CHAR, ADD, WHITE, -6
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 26: Kefka turns alt-Ifrit esper into magicite ]

_d0c7d8:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::KEFKA_GENJU_MAGICITE
        battle_event
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0c803, KEFKA_3
        exec_event_anim
        battle_dlg BATTLE_DLG_205
; KEFKA:{n}
; Imagine! Thinking you could{n}
; defeat ME!!{key}{n}
; This is rich! Mwa, ha, ha!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c818, KEFKA_3
        exec_event_anim
        battle_dlg BATTLE_DLG_206
; KEFKA:{n}
; Now, my little Magicite{n}
; pretties__{key}come, and help me{n}
; build the magical empire of{n}
; ``Kefka''!{key}{0}
        reset_event_anim
        attack_event_anim TRANSFORM_MAGICITE, MADUIN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c824, KEFKA_3
        exec_event_anim
        battle_dlg BATTLE_DLG_207
; KEFKA:{n}
; G'haw, haw__{key}{n}
; Ooh! They're warm to the{n}
; touch!{key} What treasures!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c803, KEFKA_3
        char_event_anim SLOT_2, _d0c82a, KEFKA_3
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0c803:
        anim_script SPRITE, 1, CHAR
        loop 9
                anim_speed 9
                attacker_frame CHAR_FRAME::LAUGHING_1
                blank_frame
                attacker_frame CHAR_FRAME::LAUGHING_2
                blank_frame
                anim_speed 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c818:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 6
                attacker_action CHAR_ACTION::CASTING
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0c824:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0c82a:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 30: Kefka kills Gestahl ]

_d0c838:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::KEFKA_KILLS_GESTAHL
        battle_event
        open_dlg_window
        reset_event_anim
        char_event_anim SLOT_1, _d0ccb9, TERRA
        char_event_anim SLOT_2, _d0cccc, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0c9df, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_217
; GESTAHL:{n}
; Kefka! Are you nuts?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0c9f5, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_218
; KEFKA:{n}
; Nuts_?!{key}{n}
; Emperor! Don't disturb me!{key}{n}
; I'm showing them the{n}
; meaning of power!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ca01, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_219
; GESTAHL:{n}
; I don't think so, friend.{key}{n}
; Your days are now over.{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ca0d, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_220
; GESTAHL:{n}
; Now relax__{key}I'm simply going{n}
; to put you to sleep with the{n}
; very power you unleashed__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ca13, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ca3c, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_221
; GESTAHL:{n}
; What's so funny?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ca3c, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_222
; GESTAHL:{n}
; Very well. {key}It is only fitting{n}
; that you go to sleep laughing!{key}{0}
        battle_dlg BATTLE_DLG_223, TOP
; Fire 3!!!{wait}{0}
        reset_event_anim
        attack_event_anim GESTAHL_BLACK_MAGIC, {}, MONSTER_1
        char_event_anim SLOT_1, _d0cd72, LOCKE
        char_event_anim SLOT_2, _d0ca36, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ca0d, TERRA
        char_event_anim SLOT_2, _d0ca3c, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ca26, TERRA
        char_event_anim SLOT_2, _d0ca56, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cce5, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_224, TOP
; Flare!!!{wait}{0}
        reset_event_anim
        attack_event_anim GESTAHL_BLACK_MAGIC, {}, MONSTER_1
        char_event_anim SLOT_1, _d0cd72, LOCKE
        char_event_anim SLOT_2, _d0ca36, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ca0d, TERRA
        char_event_anim SLOT_2, _d0ca3c, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ca2e, TERRA
        char_event_anim SLOT_2, _d0ca56, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cc6f, TERRA
        char_event_anim SLOT_2, _d0ca66, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_225
; GESTAHL:{n}
; N__noooo!!{key}{n}
; Why isn't my magic working?!{key}{0}
        battle_dlg BATTLE_DLG_226, TOP
; Merton!!!{wait}{0}
        reset_event_anim
        attack_event_anim GESTAHL_BLACK_MAGIC, {}, MONSTER_1
        char_event_anim SLOT_1, _d0cc94, TERRA
        char_event_anim SLOT_2, _d0cd72, LOCKE
        char_event_anim SLOT_3, _d0ca36, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_2, _d0ca3c, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cc6f, TERRA
        char_event_anim SLOT_2, _d0ca56, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cc94, TERRA
        char_event_anim SLOT_2, _d0ca75, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_227
; GESTAHL:{n}
; K__Kefka!!!!!{key}{n}
; H__how_?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ca91, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ca49, TERRA
        char_event_anim SLOT_2, _d0ca3c, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_228
; GESTAHL:{n}
; How are you doing this?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0caa7, TERRA
        char_event_anim SLOT_2, _d0caad, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cceb, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_229
; KEFKA:{n}
; How? {key}Simple! {key}I'm standing{n}
; within the field of the{n}
; Statues!{key} Their strong field{n}
; absorbs all magic sent their{n}
; way!{key} Or didn't you notice?!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0cce5, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_230
; GESTAHL:{n}
; ____!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0cac3, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_231
; KEFKA:{n}
; And now, Statues!{n}
; You've shown me a sign! {key}{n}
; It is time you show this old{n}
; man your true power!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0cac9, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_232
; GESTAHL:{n}
; No! Kefka!!{key}{n}
; Don't do something stupid__{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0cadf, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_233
; KEFKA:{n}
; I command you, Statues!!!{wait}{0}
        reset_event_anim
        attack_event_anim GESTAHL_LIGHTNING
        char_event_anim SLOT_1, _d0cd05, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cae5, TERRA
        char_event_anim SLOT_2, _d0cb08, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_234
; KEFKA:{n}
; I__incredible!{key}{0}
        reset_event_anim
        attack_event_anim GESTAHL_LIGHTNING
        char_event_anim SLOT_1, _d0cd12, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cb2b, TERRA
        char_event_anim SLOT_2, _d0cb59, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cb7a, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_235
; KEFKA:{n}
; You're way off!!!!{key}{n}
; Where're you aiming?!{key}{0}
        reset_event_anim
        attack_event_anim GESTAHL_LIGHTNING
        char_event_anim SLOT_1, _d0cd21, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cb91, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_236
; KEFKA:{n}
; Whoa! More to the right!{key}{0}
        reset_event_anim
        attack_event_anim GESTAHL_LIGHTNING
        char_event_anim SLOT_1, _d0cd2c, TERRA
        char_event_anim SLOT_2, _d0cbad, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_237
; KEFKA:{n}
; Run! Run!{key}{n}
; Or you'll be well done!{key}{0}
        reset_event_anim
        attack_event_anim GESTAHL_LIGHTNING
        char_event_anim SLOT_1, _d0cd3f, TERRA
        char_event_anim SLOT_2, _d0cbde, LOCKE
        exec_event_anim
        battle_dlg BATTLE_DLG_238
; KEFKA:{n}
; YES!!!{wait}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0cc00, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0caa7, TERRA
        char_event_anim SLOT_2, _d0cc1e, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cc34, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0caa7, TERRA
        char_event_anim SLOT_2, _d0cc51, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cceb, TERRA
        exec_event_anim
        battle_dlg BATTLE_DLG_239
; KEFKA:{n}
; Poor old__{key}{n}
; Oh well, what a worthless{n}
; excuse of an Emperor!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0cc67, TERRA
        char_event_anim SLOT_2, _d0ccf7, LOCKE
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0c9df:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {80, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0c9f5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        call _d0c0de
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca01:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        call _d0c0de
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca0d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::SURPRISED
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca13:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::LAUGHING
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0ca1b:
        anim_script SPRITE, 1, CHAR
        call _d0c0de
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::LAUGHING
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca26:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WAGGING_FINGER
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca2e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WAGGING_FINGER_ALT
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca36:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca3c:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca49:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca56:
        anim_script SPRITE, 1, CHAR
        loop 32
                attacker_frame CHAR_FRAME::WALKING_DOWN_2
                blank_frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca66:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        call _d0c0de
        call _d0c0de
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca75:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_UP_2
        call _d0c0de
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ca91:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 88}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0caa7:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1
        end_anim_script

; ------------------------------------------------------------------------------

_d0caad:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        set_vec_target {80, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        end_anim_script

; ------------------------------------------------------------------------------

_d0cac3:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0cac9:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {112, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_3 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0cadf:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        end_anim_script

; ------------------------------------------------------------------------------

_d0cae5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {160, 112}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 8
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::DEAD_VERT
                blank_frame 7
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cb08:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 8
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::DEAD_GESTAHL
                blank_frame 7
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cb2b:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_frame CHAR_FRAME::SURPRISED
        set_vec_target {144, 80}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 16
        reset_char_vec_offset
        set_vec_target {128, 48}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::DEAD_VERT
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cb59:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        set_vec_target {80, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 8
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::DEAD_GESTAHL
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        end_anim_script

; ------------------------------------------------------------------------------

_d0cb7a:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        call _d0c0de
        call _d0c0de
        call _d0c0de
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::JUMPING_BACK
        end_anim_script

; ------------------------------------------------------------------------------

_d0cb91:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_frame CHAR_FRAME::SURPRISED
                blank_frame
                end_loop
        call _d0c0de
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_action CHAR_ACTION::JUMPING_BACK
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cbad:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {40, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        set_vec_target {64, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 3, 8
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::DEAD_GESTAHL
                blank_frame 5
                end_loop
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        end_anim_script

; ------------------------------------------------------------------------------

_d0cbde:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        loop 32
                attacker_frame CHAR_FRAME::WALKING_DOWN_2
                blank_frame 3
                end_loop
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        end_anim_script

; ------------------------------------------------------------------------------

_d0cc00:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cc1e:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        set_vec_target {112, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 8
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        end_anim_script

; ------------------------------------------------------------------------------

_d0cc34:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {128, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        loop 32
                attacker_frame CHAR_FRAME::WALKING_FORWARD_2
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cc51:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        set_vec_target {96, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 8
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::DEAD_GESTAHL
        end_anim_script

; ------------------------------------------------------------------------------

_d0cc67:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::LAUGHING
        end_anim_script

; ------------------------------------------------------------------------------

_d0cc6f:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {152, 104}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        set_vec_target {168, 120}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::LAUGHING
        end_anim_script

; ------------------------------------------------------------------------------

_d0cc94:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {184, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        set_vec_target {160, 72}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 16
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::LAUGHING
        end_anim_script

; ------------------------------------------------------------------------------

_d0ccb9:
        anim_script SPRITE, 1, CHAR
        set_vec_target {176, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cccc:
        anim_script SPRITE, 1, CHAR
        set_vec_target {64, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 1, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0ccdf:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_DOWN_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0cce5:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2 + $30
        end_anim_script

; ------------------------------------------------------------------------------

_d0cceb:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

; unused
_d0ccf1:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::WALKING_UP_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ccf7:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0cd05:
        anim_script SPRITE, 1, BOTTOM
        move_bg1_here
        move BACK, 16
        move UP, 32
        move UP, 32
        jump _d0cd51

; ------------------------------------------------------------------------------

_d0cd12:
        anim_script SPRITE, 1, BOTTOM
        move_bg1_here
        move BACK, 128
        jump _d0cd51

; ------------------------------------------------------------------------------

_d0cd21:
        anim_script SPRITE, 1, BOTTOM
        move_bg1_here
        move BACK, 32
        move UP_BACK, 16
        jump _d0cd51

; ------------------------------------------------------------------------------

_d0cd2c:
        anim_script SPRITE, 1, BOTTOM
        move_bg1_here
        move FORWARD, 32
        move UP, 32
        move UP, 32
        loop 9
                blank_frame 3
                end_loop
        jump _d0cd51

; ------------------------------------------------------------------------------

_d0cd3f:
        anim_script SPRITE, 1, BOTTOM
        move_bg1_here
        move BACK, 32
        move UP_BACK, 16
        move UP, 21
        loop 9
                blank_frame 5
                end_loop
; fallthrough

; ------------------------------------------------------------------------------

_d0cd51:
        loop 5
                move UP_BACK, 32
                end_loop
        move BACK, 32
        move BACK, 24
        bg_target_draw_order
        change_anim_layer BG1
        loop 10
                move DOWN_FORWARD, 16
                frame 0
                end_loop
        sfx THUNDARA
        anim_speed 5
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        frame 8
        frame 9
        end_anim_script

; ------------------------------------------------------------------------------

_d0cd72:
        anim_script SPRITE
        fixed_draw_order
        sfx PRE_BLACK
        bg_target_draw_order
        change_anim_layer BG1
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        mod_pal BG1, SUB, WHITE, 31
        loop 8
                mod_pal BG1, SUB, WHITE, -4
                cycle_pal BG1_ANIM, 4, {1, 7}
                frame 0
                end_loop
        loop 16
                cycle_pal BG1_ANIM, 4, {1, 7}
                frame 0
                end_loop
        loop 8
                mod_pal BG1, SUB, WHITE, +4
                cycle_pal BG1_ANIM, 4, {1, 7}
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 29: Sabin fights Kefka at Imperial camp ]

_d0cd9e:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::SABIN_KEFKA_IMPERIAL_CAMP
        battle_event
        open_dlg_window
        battle_dlg KEFKA_IMP_CAMP_1
; KEFKA:{n}
; Yeouch!!{key}{0}
        char_event_anim SLOT_1, _d0cdca, KEFKA_1
        exec_event_anim
        battle_dlg KEFKA_IMP_CAMP_2
; {sabin}:{n}
; Kefka! {key}Wait!!!{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ce0d, SABIN
        char_event_anim SLOT_2, _d0ce40, KEFKA_1
        exec_event_anim
        battle_dlg KEFKA_IMP_CAMP_3
; KEFKA:{n}
; ``Wait,'' he says__{key}{n}
; Do I look like a waiter?{key}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0ce30, SABIN
        char_event_anim SLOT_2, _d0ce58, KEFKA_1
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0ce68, SHADOW
        char_event_anim SLOT_2, _d0ce78, KEFKA_1
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0cdca:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        loop 3
                attacker_frame CHAR_FRAME::SURPRISED
                move_attacker UP, 4
                blank_frame
                move_attacker UP, 3
                blank_frame
                move_attacker UP, 3
                blank_frame
                move_attacker UP, 3
                blank_frame
                move_attacker UP, 2
                blank_frame
                move_attacker UP, 2
                blank_frame
                move_attacker UP, 1
                blank_frame
                move_attacker UP, 1
                blank_frame
                move_attacker UP, 1
                blank_frame
                move_attacker DOWN, 1
                blank_frame
                move_attacker DOWN, 1
                blank_frame
                move_attacker DOWN, 1
                blank_frame
                move_attacker DOWN, 2
                blank_frame
                move_attacker DOWN, 2
                blank_frame
                move_attacker DOWN, 3
                blank_frame
                move_attacker DOWN, 3
                blank_frame
                move_attacker DOWN, 3
                blank_frame
                move_attacker DOWN, 4
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ce0d:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        set_vec_target {144, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 40
        reset_char_vec_offset
        set_vec_target {120, 96}
        calc_vec_char
        update_char_vec_dir_walk
:       blank_frame
        move_vec_char :-, 2, 0
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::READY
        end_anim_script

; ------------------------------------------------------------------------------

_d0ce30:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 81
                move_attacker FORWARD, 2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0ce40:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        loop 7
                anim_speed 9
                attacker_frame CHAR_FRAME::LAUGHING_1
                blank_frame
                attacker_frame CHAR_FRAME::LAUGHING_2
                blank_frame
                anim_speed 2
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_2
        end_anim_script

; ------------------------------------------------------------------------------

_d0ce58:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 81
                move_attacker BACK, 2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0ce68:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 100
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d0ce78:
        anim_script SPRITE, 1, CHAR
        disable_menu
        loop 16
                dec_brightness
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 32: final Kefka battle intro ]

_d0ce84:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::FINAL_BATTLE_INTRO
        battle_event
        open_dlg_window
        battle_dlg BATTLE_DLG_245
; KEFKA:{n}
; Life_ {wait}Dreams_ {wait}Hope_{wait}{wait}{wait}{0}
        battle_dlg BATTLE_DLG_246
; Where'd they come from?{wait}{n}
; And where are they headed_?{wait}{wait}{wait}{0}
        battle_dlg BATTLE_DLG_247
; These things_{wait}{wait}{n}
; I am going to destroy!!{wait}{0}
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, TERRA
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, LOCKE
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, CYAN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, SHADOW
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, EDGAR
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, SABIN
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, CELES
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, STRAGO
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, RELM
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, SETZER
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, MOG
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, GAU
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, GOGO
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d0cee1, UMARO
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d0cee1:
        anim_script SPRITE, 1, CHAR
        attacker_frame CHAR_FRAME::NONE
        sfx KEFKA_LAUGH
        attacker_frame CHAR_FRAME::NONE
        blank_frame
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::BATTLE_EVENT_SCRIPT_3

; ------------------------------------------------------------------------------

; [ battle event 1: victory fanfare ]

_d0cef0:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::VICTORY_FANFARE
        battle_event
        reset_event_anim
        all_chars_event_anim
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf24
        .addr _d0cf42
        exec_event_anim
        end_battle_event

; ------------------------------------------------------------------------------

; [ victory animation for all characters ]

_d0cf24:
        anim_script SPRITE, 4, CENTER
        call _d0cf2c
        attacker_action CHAR_ACTION::JUMPING_FORWARD
        end_anim_script

; ------------------------------------------------------------------------------

; [ spin character (victory animation) ]

_d0cf2c:
        attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_UP
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
        blank_frame
        attacker_frame CHAR_FRAME::NONE
        anim_speed 2
        return

; ------------------------------------------------------------------------------

; [ victory animation for dead/petrified characters ]

_d0cf42:
        anim_script SPRITE
        end_anim_script

; ------------------------------------------------------------------------------

; [ battle event 31: Wrexsoul intro ]

_d0cf45:
        array_label BATTLE_EVENT_SCRIPT, BATTLE_EVENT_SCRIPT::WREXSOUL_INTRO
        battle_event
        open_dlg_window
        battle_dlg BATTLE_DLG_244
; WREXSOUL:{n}
; I'm gonna possess your body!{key}{n}
; I'll only appear in this form{n}
; again when you're about to{n}
; expire!{key}{0}
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------
