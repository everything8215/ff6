.include "anim_script.inc"

; ------------------------------------------------------------------------------

; [ Battle Event Script $00 ]

; d0/9842
BattleEvent_00:
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
        attacker_frame 4
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        attacker_frame 0
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
        attacker_frame 25
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
        attacker_frame 0
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
        attacker_frame 25
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
        attacker_frame 0
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
        attacker_frame 25
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
        attacker_frame 0
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
        attacker_frame 26
        loop 10
                move_attacker DOWN, 16
                blank_frame
                end_loop
        attacker_frame 10
        loop 16
                blank_frame
                end_loop
        attacker_frame 0
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
        attacker_frame 25
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
        attacker_frame 0
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
        attacker_frame 4
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        fixed_draw_order
        attacker_action 28
        call _d0c0de
        attacker_action 0
        attacker_frame 0
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
        attacker_frame 4
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        anim_speed 7
        attacker_action 2
        blank_frame
        attacker_action 5 | $30
        blank_frame
        attacker_action 15
        blank_frame
        attacker_action 5
        blank_frame
        anim_speed 2
        attacker_action 0
        attacker_frame 0
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
        attacker_frame 4
        loop 16
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        anim_speed 9
        attacker_action 30
        blank_frame
        attacker_action 31
        blank_frame
        attacker_action 30
        blank_frame
        attacker_action 31
        blank_frame
        attacker_action 30
        blank_frame
        attacker_action 31
        blank_frame
        attacker_action 30
        blank_frame
        attacker_action 31
        blank_frame
        anim_speed 2
        attacker_action 0
        attacker_frame 0
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
        attacker_frame 12
        loop 12
                move_attacker FORWARD, 9
                blank_frame
                end_loop
        loop 11
                attacker_action 22
                blank_frame
                end_loop
        attacker_action 0
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 4, 40
        reset_char_vec_offset
        attacker_frame 0
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
        attacker_action 2
        blank_frame
        attacker_action 2
        blank_frame
        loop 3
                attacker_action 26
                blank_frame
                attacker_action 27
                blank_frame
                end_loop
        attacker_action 23
        blank_frame
        anim_speed 2
        attacker_action 0
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 5, 40
        reset_char_vec_offset
        attacker_frame 0
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
        attacker_action 0
        reset_char_vec_offset
        vec_to_attacker_char_pos
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        attacker_frame 0
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
        attacker_frame 0
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
        attacker_frame 0
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
        attacker_action 20
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
        attacker_frame 0
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
        attacker_frame 0
        restore_attacker_char_pos
        magitek_action 0
        attacker_action 0
        attacker_frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Battle Event Script $11 ]

BattleEvent_11:
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d09bc9, KEFKA_1
        exec_event_anim
        open_dlg_window
        battle_dlg 31
; KEFKA:
; Uwee, hee, hee!  Good!
; Burn up everything!
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
                attacker_frame 22
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d09bef:
        anim_script SPRITE, 1, CHAR
        attacker_action 15
        attacker_action 0
        attacker_frame 35
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
                attacker_frame 0
                blank_frame 5
                end_loop
        disable_menu
        loop 16
                dec_brightness
                blank_frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Battle Event Script $04 ]

; d0/9c26
BattleEvent_04:
        battle_event
        reset_event_anim
        char_event_anim SLOT_1, _d09e2a
        char_event_anim SLOT_2, _d09e05, WEDGE
        exec_event_anim
        open_dlg_window
        battle_dlg 0
; WEDGE:
; Hey! What's the matter?
; Do you know something we
; don't__?
        reset_event_anim
        char_event_anim SLOT_1, _d09c86, TERRA
        monster_event_anim SLOT_6, _d09e42, 32
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d09c91, TERRA
        exec_event_anim
        battle_dlg 1
; GIRL:
; __
        battle_dlg 3
; The frozen creature began
; emitting an eerie light__
        reset_event_anim
        char_event_anim SLOT_1, _d09cad
        exec_event_anim
        reset_event_anim
        char_event_anim SLOT_1, _d09d2b
        char_event_anim SLOT_2, _d09d02, WEDGE
        char_event_anim SLOT_3, _d09d02, VICKS
        exec_event_anim
        battle_dlg 2
; WEDGE:
; Where's that light coming
; from?!  Uwaaaaaaa!!!!
        reset_event_anim
        char_event_anim SLOT_1, _d09d2b
        char_event_anim SLOT_2, _d09da4, WEDGE
        exec_event_anim
        battle_dlg 5
; VICKS:
; Hey!
; Wedge__where are you?
; W__what's happening?!
        reset_event_anim
        char_event_anim SLOT_1, _d09d2b
        char_event_anim SLOT_2, _d09da4, VICKS
        exec_event_anim
        battle_dlg 4
; Girl:
; __  __  __
        reset_event_anim
        char_event_anim SLOT_1, _d09d68, TERRA
        monster_event_anim SLOT_6, _d09e42, 20
        exec_event_anim
        attack_event_anim 0
        exec_event_anim
        close_dlg_window
        end_battle_event

; ------------------------------------------------------------------------------

_d09c86:
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        disable_char_pal_update
        attacker_action 0
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
        attacker_frame 0
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
        attacker_action 15
        blank_frame
        attacker_action 5
        blank_frame
        attacker_action 2
        blank_frame
        attacker_action 5
        blank_frame
        attacker_action 15
        blank_frame
        attacker_action 5
        blank_frame
        attacker_action 2
        blank_frame
        anim_speed 2
        attacker_action 0
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
        attacker_frame 0
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
        attacker_frame 0
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
        attacker_frame 0
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

_d0c0de := $d0c0de

; ------------------------------------------------------------------------------
