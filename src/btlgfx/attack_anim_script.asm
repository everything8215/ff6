        .include "anim_script.inc"

; ------------------------------------------------------------------------------

; [ Animation Script $00E9: W Wind (bg1) ]

; d0/0000
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TORNADO_BG1
        anim_script BG1
        sfx
        fixed_draw_order
        mod_pal BG1, SUB, WHITE, 31
        set_scroll_hdma BG1, 8
        frame 0
        hide_bg1_thread
        move_to_attacker
        move UP, 64
        set_vec_target {100, 96}
        calc_vec
        vec_offset 0
        reset_tornado_pos
        move_tornado_to_anim
        move UP_BACK, 128
        loop 17
                move DOWN_FORWARD, 2
                move_tornado {2, 1}
                cycle_pal BG1_ANIM, 1, {1, 7}
                mod_pal BG1, SUB, WHITE, -2
                update_priority_tornado
                frame 0
                move_anim_to_vec
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, SPRITE
        loop 45
                move DOWN_FORWARD, 2
                move_tornado {2, 1}
                cycle_pal BG1_ANIM, 1, {1, 7}
                mod_pal BG1, SUB, WHITE, -2
                mod_pal BG3, SUB, WHITE, -1
                update_priority_tornado
                frame 0
                move_anim_to_vec
                end_loop
:       move_tornado_to_anim
        move_tornado {2, 1}
        cycle_pal BG1_ANIM, 1, {1, 7}
        update_priority_tornado
        frame 0
        move_vec :-, 1
        loop 97
                move_tornado {2, 1}
                cycle_pal BG1_ANIM, 1, {1, 7}
                update_priority_tornado
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        loop 20
                move_tornado {2, 1}
                cycle_pal BG1_ANIM, 1, {1, 7}
                mod_pal BG1, SUB, WHITE, +2
                update_priority_tornado
                frame 0
                end_loop
        set_scroll_hdma BG1, 3
        reset_tornado_pos
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A2: Goner (bg1) ]

; d0/0083
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GONER_BG1
        anim_script BG1
        set_blank_frame 31
        sfx CONFUSER, CENTER
        mod_pal BG2, SUB, WHITE, 0
        loop 32
                mod_pal BG2, SUB, CYAN, +1
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, SUB, BLUE, -1
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, SUB, RED, +1
                blank_frame
                end_loop
        sfx GONER, CENTER
        loop 32
                mod_pal BG2, SUB, RED, -1
                mod_pal BG2, SUB, BLUE, +1
                blank_frame
                end_loop
        set_blank_frame 15
        wait_scanline
        mod_pal MONSTER, SUB, CYAN, 0
        loop 32
                mod_pal MONSTER, SUB, CYAN, +1
                move_attacker BACK, 2
                blank_frame
                move_attacker FORWARD, 2
                blank_frame
                move_attacker BACK, 2
                blank_frame
                move_attacker FORWARD, 2
                blank_frame
                move_attacker BACK, 2
                blank_frame
                move_attacker FORWARD, 2
                blank_frame
                end_loop
        disable_kefka_head_shake
        sprite_priority 2
        fixed_draw_order
        move_bg1_here
        disable_char_pal_update
        sfx DEFAULT, CENTER
        wait_scanline
        mod_pal BG2, SUB, RED, +15
        mod_pal MONSTER, SUB, RED, +15
        mod_pal BG1, ADD, WHITE, 31
        mod_pal BG3, ADD, WHITE, 31
        mod_pal MONSTER, ADD, WHITE, 31
        mod_pal CHAR, ADD, WHITE, 31
        mod_pal BG2, ADD, WHITE, 31
        set_scroll_hdma BG1, 0
        loop 16
                mod_pal BG1, ADD, WHITE, -2
                mod_pal BG3, ADD, WHITE, -2
                bg1_scroll_goner
                frame 0
                hide_bg1_thread
                end_loop
        loop 48
                bg1_scroll_goner
                frame 0
                end_loop
        bg3_window 2
        bg1_window 2
        init_circle {128, 72}, 80, {255, 255}, 64, 0
        loop 4
                zoom_circle -4
                bg1_scroll_goner
                update_circle
                frame 0
                end_loop
        circle_shape HORZ_OVAL
        loop 4
                zoom_circle -4
                bg1_scroll_goner
                update_circle
                frame 0
                end_loop
        window2_size 72
        bg1_scroll_goner
        frame 0
        window2_size 74
        bg1_scroll_goner
        frame 0
        window2_size 76
        bg1_scroll_goner
        frame 0
        window2_size 72
        bg1_scroll_goner
        frame 0
        window2_size 64
        bg1_scroll_goner
        frame 0
        window2_size 56
        bg1_scroll_goner
        frame 0
        window2_size 48
        bg1_scroll_goner
        frame 0
        window2_size 40
        bg1_scroll_goner
        frame 0
        window2_size 32
        bg1_scroll_goner
        frame 0
        window2_size 24
        bg1_scroll_goner
        frame 0
        window2_size 16
        bg1_scroll_goner
        frame 0
        window2_size 8
        bg1_scroll_goner
        frame 0
        window2_size 0
        loop 65
                bg1_scroll_goner
                frame 0
                end_loop
        show_bg1_thread
        loop 16
                blank_frame
                mod_pal BG2, ADD, WHITE, -2
                blank_frame
                mod_pal MONSTER, ADD, WHITE, -2
                blank_frame
                mod_pal CHAR, ADD, WHITE, -2
                end_loop
        wait_scanline
        set_scroll_hdma BG1, 3
        enable_char_pal_update
        sfx NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A3: Goner (bg3) ]

; d0/0185
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GONER_BG3
        anim_script BG3
        move_bg3_here
        loop 32
                .repeat 10
                blank_frame
                .endrep
                end_loop
        anim_speed 4
        anim_loop 7
                frame 0
                end_anim_loop
        anim_loop 7
                frame 0
                end_anim_loop
        anim_loop 7
                frame 0
                end_anim_loop
        anim_speed 2
        loop 13
                blank_frame
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 8, 1, HORZ
        loop 33
                update_scroll_wave BG3, HORZ
                blank_frame
                end_loop
        loop 32
                move BACK, 8
                update_scroll_wave BG3, HORZ
                mod_pal BG1, ADD, WHITE, +1
                mod_pal BG3, ADD, WHITE, +1
                blank_frame
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0288: Monster Steal (bg1) ]

; d0/01ca
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MONSTER_STEAL_BG1
        anim_script BG1
        move_to_attacker
        init_monster_jump_pos
        blank_frame
        calc_vec_jump
:       blank_frame
        move_vec_monster :-, 12
:       blank_frame
        move_vec_monster :-, -8
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0287: BabaBreath (sprite) ]

; d0/01da
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BABABREATH_SPRITE
        anim_script SPRITE
        loop 32
                blank_frame
                end_loop
        loop 32
                move_target FORWARD, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                end_loop
        jump_hit :+
        end_anim_script
:       loop 22
                move_target FORWARD, 8
                blank_frame
                end_loop
        hide_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0286: Animation $0194 (control ???) ]

; d0/01f6
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONTROL_BG1
        anim_script BG1
        call _d07067
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        jump_hit :+
        loop 32
                blank_frame
                end_loop
                attacker_frame CHAR_FRAME::NONE
                end_anim_script
:       sfx CONTROL
        anim_speed 5
        loop 8
                flip_monster HORZ
                blank_frame
                flip_monster HORZ
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0285: Super Ball (extra) ]

; d0/021a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SUPER_BALL_EXTRA
        anim_script SPRITE
        call _d07019
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        loop 65
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        call _d07040
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0284: Misc. Monster Animation $0D: Final KEFKA Death (bg1) ]

; d0/022d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KEFKA_DEATH_BG1
        anim_script BG1
        fixed_draw_order
        set_song_vol 224
        loop 129
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        sfx SEALED_GATE_THUNDER
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                blank_frame
                end_loop
        loop 65
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        sfx SEALED_GATE_THUNDER
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                blank_frame
                end_loop
        loop 65
                blank_frame
                end_loop
        sfx RUMBLE
        disable_kefka_head_shake
        mod_pal BG2, SUB, CYAN, 0
        loop 16
                mod_pal BG2, SUB, WHITE, +1
                blank_frame 4
                mod_pal BG2, SUB, CYAN, +1
                blank_frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

        .if !LANG_EN
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_649
        .endif
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_650
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_651
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_652
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_653
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_654
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_655
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_656
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_657
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_658
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_659

; ------------------------------------------------------------------------------

; [ Animation Script $0283: Misc. Monster Animation $0C: Monsters Glow Short (bg1) ]

; d0/026d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MONSTER_GLOW_SHORT_BG1
        anim_script BG1
        hide_bg1_thread
        move_bg1_here
        mod_pal BG1, ADD, WHITE, 0
        loop 15
                blank_frame
                mod_pal BG1, ADD, WHITE, +1
                end_loop
        loop 5
                blank_frame
                mod_pal BG1, ADD, YELLOW, +1
                end_loop
        loop 17
                blank_frame
                end_loop
        loop 5
                blank_frame
                mod_pal BG1, ADD, YELLOW, -1
                end_loop
        loop 15
                blank_frame
                mod_pal BG1, ADD, WHITE, -1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0282: Misc. Monster Animation $0B: Monsters Glow Long (bg1) ]

; atma/ultima weapon glow with spinning gears

; d0/0292
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MONSTER_GLOW_LONG_BG1
        anim_script BG1
        hide_bg1_thread
        move_bg1_here
        mod_pal MONSTER, ADD, WHITE, 0

; increase glow
        loop 11
                blank_frame
                mod_pal MONSTER, ADD, WHITE, +1
                end_loop
        loop 5
                blank_frame
                mod_pal MONSTER, ADD, YELLOW, +1
                end_loop

; ramp up spinning gears
        loop 5
                cycle_pal MONSTER_1, 1, {13, 15}
                blank_frame 6
                end_loop
        loop 9
                cycle_pal MONSTER_1, 1, {13, 15}
                blank_frame 4
                end_loop
        loop 16
                cycle_pal MONSTER_1, 1, {13, 15}
                blank_frame 2
                end_loop

; gears spinning at full speed
        loop 33
                cycle_pal MONSTER_1, 1, {13, 15}
                blank_frame
                end_loop

; ramp down spinning gears
        loop 16
                cycle_pal MONSTER_1, 1, {13, 15}
                blank_frame 2
                end_loop
        loop 9
                cycle_pal MONSTER_1, 1, {13, 15}
                blank_frame 4
; ramp down has one frame more than ramp down here
                blank_frame
                end_loop
        loop 5
                cycle_pal MONSTER_1, 1, {13, 15}
                blank_frame 6
                end_loop

; decrease glow
        loop 5
                blank_frame
                mod_pal MONSTER, ADD, YELLOW, -1
                end_loop
        loop 11
                blank_frame
                mod_pal MONSTER, ADD, WHITE, -1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0281: Misc. Monster Animation $0A: Final KEFKA Disembodied Head (bg1) ]

; d0/02f7
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KEFKA_HEAD_BG1
        anim_script BG1
        move_bg1_here
        sprite_priority 2
        move FORWARD, 17
        move DOWN, 17
        move DOWN, 21
        mod_pal BG1, ADD, WHITE, 31
        loop 32
                mod_pal BG1, ADD, WHITE, -1
                frame 0
                end_loop
        enable_kefka_head_shake
        loop 65
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0280: Monster Entry $0F: Final KEFKA (sprite) ]

; d0/0321
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KEFKA_ENTRY_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        loop 5
                move_target UP, 32
                end_loop
        validate_monster_entry
        loop 160
                move_target DOWN, 1
                blank_frame 4
                end_loop
        loop 65
                blank_frame
                end_loop
        play_song DANCING_MAD_5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $027F: Flash (bg1) ]

; d0/0341
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLASH_BG1
        anim_script BG1, 2
        sfx
        frame 0
        frame 1
        frame 2
        loop 19
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0240: Monster Entry $0E: Chadarnook (sprite) ]

; not used at the beginning of the battle
; happens before chadarnook exit

; d0/034d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHADARNOOK_ENTRY_SPRITE
        anim_script SPRITE
        save_chadarnook_pos
        blank_frame
        validate_monster_entry
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0241: Monster Exit $0E: Chadarnook (bg1) ]

; used to fade from demon to girl chadarnook (or vice versa)
; happens after chadarnook entry

; d0/0356
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHADARNOOK_EXIT_SPRITE
        anim_script BG1
        move_bg1_here
        fixed_draw_order
        hide_bg1_thread
        wait_scanline
        sprite_priority 2
        restore_chadarnook_pos

; entering monster fades in
        mod_pal MONSTER, SUB, WHITE, 31
        load_chadarnook_bg_pal 1
        blank_frame 3
        load_chadarnook_bg_pal 0
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {SPRITE, BG2}
        loop 32
                mod_pal MONSTER, SUB, WHITE, -1
                blank_frame 3
                load_chadarnook_bg_pal 2
                blank_frame 3
                load_chadarnook_bg_pal 0
                end_loop

; exiting monster fades out
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                blank_frame 3
                load_chadarnook_bg_pal 2
                blank_frame 3
                load_chadarnook_bg_pal 0
                end_loop
        wait_scanline
        mainscreen_layers {SPRITE, BG2}
        hide_target_monsters
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $027E: Unused (sprite) ]

; d0/03a1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_638
        anim_script SPRITE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $011F: Atom Edge, True Edge (bg1) ]

; d0/03a4
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ODIN_BG1
        anim_script BG1
        fixed_draw_order
        hide_bg1_thread
        move_bg1_here
        call _d05516
        hide_bg1_thread
        loop 32
                blank_frame
                end_loop
        sfx
        jump_dir _d003bd, _d003c8
_d003bd:
        mode7_flip NONE
        loop 5
                move BACK, 32
                end_loop
        jump _d003d0
_d003c8:
        mode7_flip HORZ
        loop 5
                move FORWARD, 32
                end_loop
_d003d0:
        mod_pal BG2, SUB, WHITE, 0
        init_blue_gradient 15
        wait_scanline
        color_math {ADD, FIXED_CLR, OUTSIDE_SUB}, {BACK, BG2}
        loop 15
                mod_pal BG2, SUB, WHITE, +1
                update_blue_gradient -1
                blank_frame
                end_loop
        loop 17
                mod_pal BG2, SUB, WHITE, +1
                update_blue_gradient 0
                blank_frame
                end_loop
        move UP, 5
        update_blue_gradient 0
        blank_frame
        mode7_move {96, 0}
        wait_scanline
        mainscreen_layers {SPRITE, BG1}
        screen_mode 7
        sprite_priority 3
        wait_scanline
        loop 16
        mode7_zoom {-8, -8}
        update_blue_gradient 0
                blank_frame
                end_loop
        sprite_priority 0
        loop 16
        mode7_zoom {-8, -8}
        update_blue_gradient 0
                blank_frame
                end_loop
        sprite_priority 3
        update_blue_gradient 0
        blank_frame
        wait_scanline
        mainscreen_layers {SPRITE, BG2, BG3}
        screen_mode 1
        show_bg1_thread
        update_blue_gradient 0
        blank_frame
        bg_screen_pos BG1, TOP_RIGHT
        update_blue_gradient 0
        blank_frame
        bg_screen_pos BG1, BOTTOM_LEFT
        update_blue_gradient 0
        blank_frame
        bg_screen_pos BG1, BOTTOM_RIGHT
        update_blue_gradient 0
        blank_frame
        hide_bg1_thread
        loop 17
                mod_pal BG2, SUB, WHITE, -1
        update_blue_gradient 0
                blank_frame
                end_loop
        loop 15
        update_blue_gradient +1
                mod_pal BG2, SUB, WHITE, -1
                blank_frame
                end_loop
        reset_gradient
        call _d05549
        call _d02ca0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $027C: Misc. Monster Animation $08: Move Forward 64 (sprite) ]

; d0/0464
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MOVE_FORWARD_64_SPRITE
        anim_script SPRITE
        move_target FORWARD, 64
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $027D: Misc. Monster Animation $07: Move Back 64 (sprite) ]

; d0/046c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MOVE_BACK_64_SPRITE
        anim_script SPRITE
        move_target BACK, 64
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $027B: Monster Exit $0C: Boss Death (bg1) ]

; d0/0474
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOSS_DEATH_BG1
        anim_script BG1

; first flash
        mod_pal BG2, ADD, WHITE, 31
        sfx SEALED_GATE_THUNDER
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                blank_frame
                end_loop
        loop 65
                blank_frame
                end_loop

; second flash
        mod_pal BG2, ADD, WHITE, 31
        mod_pal MONSTER, ADD, WHITE, 31
        sfx SEALED_GATE_THUNDER
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        sprite_priority 0
        char_priority 3
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 24
                mod_pal MONSTER, ADD, WHITE, -1
                blank_frame
                end_loop
        mod_pal MONSTER, SUB, WHITE, 0
        loop 32
                blank_frame
                end_loop

; start shaking
        sfx BOSS_DEATH_B
        loop 16
                monster_x_offset +1
                blank_frame
                monster_x_offset -1
                blank_frame
                end_loop

; subtract blue and green
        anim_speed 3
        loop 16
                mod_boss_death_pal BLUE, +1
                monster_x_offset +1
                blank_frame
                monster_x_offset -1
                blank_frame
                mod_boss_death_pal BLUE, +1
                mod_boss_death_pal GREEN, +1
                monster_x_offset +1
                blank_frame
                monster_x_offset -1
                blank_frame
                end_loop

; subtract green and red
        loop 16
                mod_boss_death_pal GREEN, +1
                monster_x_offset +2
                blank_frame
                monster_x_offset -2
                blank_frame
                mod_boss_death_pal RED, +1
                monster_x_offset +2
                blank_frame
                monster_x_offset -2
                blank_frame
                end_loop

; subtract red
        loop 8
                mod_boss_death_pal RED, +1
                monster_x_offset +3
                blank_frame
                monster_x_offset -3
                blank_frame
                mod_boss_death_pal RED, +1
                monster_x_offset +3
                blank_frame
                monster_x_offset -3
                blank_frame
                end_loop
        hide_monsters
        blank_frame
        sfx NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $027A: Slash/Skull Hit (bg1) ]

; d0/051a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SKULL_HIT_BG1
        anim_script BG1
        sfx
        anim_loop 8
                frame 0, 2
                end_anim_loop
        loop 65
                frame 8
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0277: Black Ball Hit (bg1) ]

; d0/0528
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BALL_HIT_BG1
        anim_script BG1, 1, BOTTOM
        loop 5
                move UP, 32
                end_loop
        sfx
        loop 20
                move DOWN, 8
                frame 0
                end_loop
        target_frame CHAR_FRAME::HIT
        loop 16
                move BACK, 3
                frame 0
                move FORWARD, 3
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0276: Drill Hit (bg1) ]

; d0/0547
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DRILL_HIT_BG1
        anim_script BG1
        sfx
        move_to_attacker
        calc_vec
:       frame 0
        move_vec :-, 8
        reset_frame_offset
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0275: Net Hit (bg1) ]

; d0/0557
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NET_HIT_BG1
        anim_script BG1, 3
        sfx
        anim_loop 4
                frame 0
                end_anim_loop
        loop 8
                frame 3
                end_loop
        frame 2
        frame 1
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0274: Missiles Hit (bg1) ]

; d0/0567
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MISSILE_HIT_BG1
        anim_script BG1
        fixed_draw_order
        sfx
        move_to_attacker
        frame 0, 3
        frame 1, 3
        calc_vec
:       auto_frame 1, {0,3}
        frame 2
        move_vec :-, 8
        reset_frame_offset
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0273: Blooming Flowers Hit (bg1) ]

; d0/0582
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLOWER_HIT_BG1
        anim_script BG1, 4
        fixed_draw_order
        sfx
        move UP_FORWARD, 16
        target_frame CHAR_FRAME::HIT
        move_rand {31, 31}
        anim_loop 10
                frame 0
                end_anim_loop
        move_rand {31, 31}
        anim_loop 10
                frame 0
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0272: Wheel Hit (bg1) ]

; d0/059f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WHEEL_HIT_BG1
        anim_script BG1, 1, BOTTOM
        fixed_draw_order
        move BACK, 96
        sfx
        loop 18
                move FORWARD, 4
                auto_frame 1, {0, 3}
                frame 0
                end_loop
        target_frame CHAR_FRAME::HIT
        move FORWARD, 4
        move UP, 5
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move UP, 4
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move UP, 3
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move UP, 2
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move DOWN, 2
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move DOWN, 2
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move DOWN, 2
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move DOWN, 3
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move DOWN, 4
        auto_frame 1, {0, 3}
        frame 0
        move FORWARD, 4
        move DOWN, 5
        auto_frame 1, {0, 3}
        frame 0
        target_frame CHAR_FRAME::NONE
        loop 27
                move FORWARD, 4
                auto_frame 1, {0, 3}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0271: Heart Hit (bg1) ]

; d0/0614
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HEART_HIT_BG1
        anim_script BG1
        fixed_draw_order
        move_to_attacker
        calc_vec
        sfx
:       update_vec_wave
        auto_frame 4, {0, 2}
        frame 0
        move_vec :-, 2
        reset_frame_offset
        update_vec_wave
        frame 0
        frame 1
        frame 2
        frame 3
        frame 0
        frame 1
        frame 2
        frame 3
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0270: Music Note Hit (bg1) ]

; d0/0635
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MUSIC_HIT_BG1
        anim_script BG1
        fixed_draw_order
        move_to_attacker
        calc_vec
        sfx
:       update_vec_wave
        auto_frame 4, {0, 2}
        frame 0
        move_vec :-, 2
        reset_frame_offset
        update_vec_wave
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $026F: Bubble Hit (bg1) ]

; d0/064e
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BUBBLE_HIT_BG1
        anim_script BG1, 3
        sfx
        move UP_FORWARD, 8
        loop 4
                move_rand {15, 15}
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                target_frame CHAR_FRAME::HIT
                end_loop
        call _d0072f
        sfx NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $026E: Bit Hit (bg1) ]

; d0/0668
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIT_HIT_BG1
        anim_script BG1, 3
        sfx
        target_frame CHAR_FRAME::HIT
        move FORWARD, 5
        anim_loop 12
                frame 0
                end_anim_loop
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $026D: Vertical Hit (bg1) ]

; d0/0679
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::VERTICAL_HIT_BG1
        anim_script BG1, 3
        sfx
        target_frame CHAR_FRAME::HIT
        move FORWARD, 5
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $026C: Star Hit (bg1) ]

; d0/068b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STAR_HIT_BG1
        anim_script BG1, 4
        sfx
        target_frame CHAR_FRAME::HIT
        frame 0
        frame 1
        frame 2
        frame 3
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $026B: Blue Slime Hit (bg1) ]

; d0/069a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLIME_HIT_BG1
        anim_script BG1, 5, BOTTOM
        sfx
        move DOWN, 1
        frame 10
        frame 9
        frame 8
        frame 7
        frame 6
        frame 5
        move FORWARD, 8
        frame 4
        frame 3
        frame 2
        frame 1
        frame 0, 6
        frame 1
        frame 2
        frame 3
        frame 4
        move BACK, 8
        frame 5
        frame 6
        frame 7
        frame 8
        frame 9
        frame 10
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $026A: Robot Hand Hit (bg1) ]

; d0/06c2
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ROBOT_HIT_BG1
        anim_script BG1
        sfx
        move_to_attacker
        calc_vec
:       frame 0
        move_vec_arc :-, 8
        target_frame CHAR_FRAME::HIT
        move_target FORWARD, 8
:       frame 0
        move_vec_arc :-, 8
        loop 5
                move_target FORWARD, 1
                move FORWARD, 1
                blank_frame
                move_target BACK, 1
                move BACK, 1
                blank_frame
                end_loop
        move_target BACK, 8
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0269: Beam Hit (bg1) ]

; d0/06e8
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BEAM_HIT_BG1
        anim_script BG1, 1, BOTTOM
        target_frame CHAR_FRAME::HIT
        move DOWN, 5
        mod_pal BG1, SUB, WHITE, 31
        sfx
        loop 16
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                mod_pal BG1, SUB, WHITE, -2
                end_loop
        loop 49
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        loop 16
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                mod_pal BG1, SUB, WHITE, +2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0268: Lightning Hit (bg1) ]

; d0/0710
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LIGHTNING_HIT_BG1
        anim_script BG1, 3, BOTTOM
        sfx
        anim_loop 6
                frame 0
                end_anim_loop
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0266: Bone Hit (bg1) ]

; d0/071c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BONE_HIT_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WRENCH_HIT_BG1
        anim_script BG1
        sfx
        move_to_attacker
        calc_vec
:       auto_frame 2, {0, 4}
        frame 0
        move_vec :-, 8
        reset_frame_offset
        call _d0072f
        end_anim_script

; ------------------------------------------------------------------------------

; [ shake character hit by monster special attack ]

; d0/072f
_d0072f:
        set_blank_frame 15
        anim_speed 2
        target_frame CHAR_FRAME::HIT
        loop 4
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0265: Hammer Hit (bg1) ]

; d0/0741
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HAMMER_HIT_BG1
        anim_script BG1, 5, TOP
        move UP, 12
        move BACK, 12
        sfx
        target_frame CHAR_FRAME::HIT
        frame 0
        move FORWARD, 8
        loop 4
                frame 1
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0264: Ink Hit (bg1) ]

; d0/0757
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::INK_HIT_BG1
        anim_script BG1, 3
        rand_sprite_pal
        move BACK, 16
        target_frame CHAR_FRAME::HIT
        sfx
        anim_loop 6
                frame 0
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0263: Needles Hit (bg1) ]

; d0/076a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NEEDLE_HIT_BG1
        anim_script BG1
        sfx
        move BACK, 96
        loop 12
                move FORWARD, 8
                frame 0
                end_loop
        target_frame CHAR_FRAME::HIT
        move UP, 8
        move BACK, 64
        loop 4
                move FORWARD, 8
                move_target FORWARD, 1
                frame 0
                move FORWARD, 8
                move_target BACK, 1
                frame 0
                end_loop
        move DOWN, 16
        move BACK, 64
        loop 4
                move FORWARD, 8
                move_target FORWARD, 1
                frame 0
                move FORWARD, 8
                move_target BACK, 1
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00DB: Sketch (bg1) ]

; d0/07a7
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SKETCH_CMD_BG1
        anim_script BG1
        jump_hit :+
        jump _d007e2
:       hide_bg1_thread
        blank_frame 2
        wait_scanline
        bg1_tilemap_location $2800
        move_to_attacker
        update_sketch_pos
        wait_scanline
        mainscreen_layers {BG1, BG2, BG3, SPRITE}
        load_sketch_pal
        bg_screen_pos BG1, SKETCH
        move FORWARD, 64
        move UP, 4
        show_bg1_thread
        frame 1
        hide_bg1_thread
        loop 96
                frame 1
                end_loop
        loop 17
                wait_scanline
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                frame 1
                wait_scanline
                mainscreen_layers {BG2, BG3, SPRITE}
                frame 1
                end_loop
_d007e2:
        wait_scanline
        mainscreen_layers {BG2, BG3, SPRITE}
        show_bg1_thread
        bg_screen_pos BG1, SKETCH
        blank_frame
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG1, BOTTOM_RIGHT
        blank_frame
        wait_scanline
        bg1_tilemap_location $0c00
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0262: Sketch (bg3) ]

; d0/07fb
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SKETCH_CMD_BG3
        anim_script BG3, 1, BOTTOM
        jump_hit _d00801
        end_anim_script
_d00801:
        move_to_attacker
        move FORWARD, 64
        move BACK, 64
        move DOWN, 1
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 7, 2, HORZ
        update_window_hdma
        frame 0
        bg_screen_pos BG3, TOP_RIGHT
        frame 1
        loop 65
                move FORWARD, 4
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                end_loop
        wait_scanline
        validate_monster_entry
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0261: Confuser (sprite) ]

; d0/0837
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONFUSER_SPRITE
        anim_script SPRITE, 3
        loop 8
                blank_frame
                end_loop
        jump_hit :+
        end_anim_script
:       loop 8
                flip_monster HORZ
                blank_frame 2
                flip_monster HORZ
                blank_frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0260: Engulf (sprite) ]

; d0/084d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ENGULF_SPRITE
        anim_script SPRITE
        swap_attacker_and_target
        move_to_attacker
        loop 32
                move_attacker FORWARD, 3
                blank_frame
                move_attacker BACK, 3
                blank_frame
                end_loop
        jump_hit :+
        end_anim_script
:       calc_vec_char
:       blank_frame
        move_vec_char :-, 12
        hide_attacker_char
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $025E: Engulf (bg1) ]

; d0/0868
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ENGULF_BG1
        anim_script BG1
        move_to_attacker
        move FORWARD, 64
        loop 129
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $025F: Engulf (bg3) ]

; d0/0874
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ENGULF_BG3
        anim_script BG3
        sfx
        move_to_attacker
        move FORWARD, 64
        move DOWN, 1
        loop 129
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $025C: Misc. Monster Animation $06: Characters Run Right to Left (bg1) ]

; d0/0887
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHARS_RUN_LEFT_BG1
        anim_script BG1
        fixed_draw_order
        loop 56
                chars_run_left
                blank_frame
                end_loop
        flip_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $025D: Misc. Monster Animation $05: Characters Run Left to Right (bg1) ]

; d0/0894
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHARS_RUN_RIGHT_BG1
        anim_script BG1
        fixed_draw_order
        loop 56
                chars_run_right
                blank_frame
                end_loop
        flip_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $025B: Discard (sprite) ]

; d0/08a1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DISCARD_SPRITE
        anim_script SPRITE
        jump_hit :+
        end_anim_script
:       restore_seize_char_pos
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00F1: Spin Edge (bg1) ]

; d0/08ab
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SPIN_EDGE_BG1
        anim_script BG1, 2
        move UP, 16
        anim_loop 5
                frame 0
                end_anim_loop
        move DOWN, 16
        anim_loop 5
                frame 0
                end_anim_loop
        move DOWN, 16
        anim_loop 5
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01DD: Spin Edge (sprite) ]

; d0/08c0
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SPIN_EDGE_SPRITE
        anim_script SPRITE, 1, BOTTOM
        save_attacker_char_pos
        sfx
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        move_to_attacker
        calc_vec_char
:       blank_frame
        move_vec_char :-, 12, 16
        attacker_frame CHAR_FRAME::NONE
        move DOWN, 5
        unpause_layer BG1
        loop 6
                sfx SWORD
                attacker_frame CHAR_FRAME::WALKING_FORWARD_1
                frame 0, 2
                move BACK, 11
                attacker_frame CHAR_FRAME::WALKING_DOWN_3
                frame 1, 2
                move BACK, 19
                attacker_frame CHAR_FRAME::WALKING_FORWARD_3 + $30
                frame 2, 2
                move FORWARD, 30
                attacker_frame CHAR_FRAME::WALKING_UP_3
                blank_frame 2
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -12, 16
        restore_attacker_char_pos
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $025A: UMARO's throw (sprite) ]

; d0/0906
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UMARO_THROW_SPRITE
        anim_script SPRITE
        save_attacker_char_pos
        sfx
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        move_to_attacker
        calc_vec_char
:       blank_frame
        move_vec_char :-, 4, 16
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame 4
        unpause_layer BG1
        attacker_frame CHAR_FRAME::WALKING_FORWARD_3
        loop 17
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -4, 16
        restore_attacker_char_pos
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0227: UMARO's throw (bg1) ]

; d0/0936
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UMARO_THROW_BG1
        anim_script BG1
        save_attacker_char_pos
        sfx
        move_to_attacker
        calc_vec_char
        attacker_frame CHAR_FRAME::NEAR_FATAL
:       blank_frame
        move_vec_char :-, 12, 0
        sfx SFX_219
        loop 8
                move_target FORWARD, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -12, 32
        attacker_frame CHAR_FRAME::NONE
        restore_attacker_char_pos
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0258: Capture-to (sprite) ]

; d0/0964
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CAPTURE_TO_SPRITE
        anim_script SPRITE, 1, CHAR
        save_attacker_char_pos
        move_to_attacker
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 12, 32
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::NEAR_FATAL
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0259: Capture-from (sprite) ]

; d0/0977
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CAPTURE_FROM_SPRITE
        anim_script SPRITE, 1, CHAR
        vec_to_attacker_char_pos
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        calc_vec_char
        update_char_vec_dir_jump
:       blank_frame
        move_vec_char :-, 12, 32
        restore_attacker_char_pos
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0226: UMARO's tackle (sprite) ]

; d0/0990
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UMARO_TACKLE_SPRITE
        anim_script SPRITE
        jump_step :+
        call _d07019                    ; step forward
:       attacker_frame CHAR_FRAME::JUMPING_FORWARD
        sfx
        move_to_attacker
        calc_vec_char
:       blank_frame
        move_vec_char :-, 8
        sfx UMARO_TACKLE
        loop 8
                move_target FORWARD, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 32
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $020E: Super Ball (sprite) ]

; d0/09ba
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SUPER_BALL_SPRITE
        anim_script SPRITE
        fixed_draw_order
        loop 25
                blank_frame
                end_loop
        sfx
        move_to_attacker
        move FORWARD, 24
        calc_vec
:       update_super_ball $60, 8, $80
        frame 0
        move_vec_arc :-, 4
        anim_target_pal
        frame 0
        restore_target_pal
:       update_super_ball $60, 8, $80
        frame 0
        move_vec_arc :-, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0253: Misc. Monster Animation $04 (sprite) ]

; d0/09e0
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MOVE_FORWARD_8_SPRITE
        anim_script SPRITE
        move_target FORWARD, 8
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0254: Misc. Monster Animation $03 (sprite) ]

; d0/09e6
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MOVE_BACK_8_SPRITE
        anim_script SPRITE
        move_target BACK, 8
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0012: Dice, Fixed Dice (sprite) ]

; d0/09ec
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DICE_SPRITE
        anim_script SPRITE
        move_to_attacker
        calc_vec
        jump_thread _d009f9, _d00a6a, _d00acd, _d00b31
_d009f9:
        fixed_draw_order
        call _d07019
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        blank_frame 4
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        sfx
:       frame 0
        move_vec :-, 6
        sfx SFX_243
        attacker_frame CHAR_FRAME::NONE
        frame 0
        move BACK, 2
        move UP, 4
        frame 0
        move BACK, 2
        move UP, 4
        frame 1
        move BACK, 2
        move UP, 3
        frame 1
        move BACK, 2
        move UP, 2
        frame 1
        move BACK, 2
        move UP, 1
        frame 2
        move BACK, 2
        move UP, 1
        frame 2
        move BACK, 2
        move UP, 1
        frame 2
        move BACK, 2
        move DOWN, 2
        frame 1
        move BACK, 2
        move DOWN, 2
        frame 1
        move BACK, 2
        move DOWN, 3
        frame 1
        move BACK, 2
        move DOWN, 3
        frame 0
        move BACK, 2
        move DOWN, 3
        frame 0
        move BACK, 2
        move DOWN, 3
        frame 0
        move BACK, 2
        move DOWN, 3
        frame 3
        move BACK, 2
        move DOWN, 3
        frame 3
        dice_roll 1
        loop 65
                frame 0
                end_loop
        call _d07040
        end_anim_script

_d00a6a:
        jump_step :+
        move FORWARD, 24
        loop 12
                blank_frame
                end_loop
:       blank_frame 3
:       frame 1
        move_vec :-, 6
        frame 2
        move BACK, 1
        move UP, 5
        frame 2
        move BACK, 1
        move UP, 4
        frame 2
        move BACK, 1
        move UP, 3
        frame 3
        move BACK, 1
        move UP, 2
        frame 3
        move BACK, 1
        move UP, 1
        frame 3
        move BACK, 1
        move UP, 1
        frame 0
        move BACK, 1
        move UP, 1
        frame 0
        move BACK, 1
        move DOWN, 2
        frame 0
        move BACK, 1
        move DOWN, 3
        frame 1
        move BACK, 1
        move DOWN, 3
        frame 1
        move BACK, 1
        move DOWN, 4
        frame 1
        move BACK, 1
        move DOWN, 4
        frame 2
        move BACK, 1
        move DOWN, 5
        frame 2
        move BACK, 1
        move DOWN, 5
        frame 2
        move BACK, 1
        move DOWN, 5
        frame 2
        dice_roll 2
        loop 65
                frame 0
                end_loop
        end_anim_script

_d00acd:
        jump_step :+
        move FORWARD, 24
        loop 12
                blank_frame
                end_loop
:       blank_frame 6
:       frame 2
        move_vec :-, 6
        frame 0
        move FORWARD, 1
        move UP, 4
        frame 0
        move FORWARD, 1
        move UP, 4
        frame 0
        move FORWARD, 1
        move UP, 3
        frame 1
        move FORWARD, 1
        move UP, 2
        frame 1
        move FORWARD, 1
        move UP, 1
        frame 1
        move FORWARD, 1
        move UP, 1
        frame 0
        move FORWARD, 1
        move UP, 1
        frame 0
        move FORWARD, 1
        move DOWN, 2
        frame 0
        move FORWARD, 1
        move DOWN, 2
        frame 1
        move FORWARD, 1
        move DOWN, 3
        frame 1
        move FORWARD, 1
        move DOWN, 3
        frame 1
        move FORWARD, 1
        move DOWN, 4
        frame 0
        move FORWARD, 1
        move DOWN, 4
        frame 0
        move FORWARD, 1
        move DOWN, 4
        frame 0
        move FORWARD, 1
        move DOWN, 4
        dice_roll 0
        loop 65
                frame 0
                end_loop
_d00b31:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $024E: Misc. Monster Animation $02: Move Forward Slowly (sprite) ]

; d0/0b32
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MOVE_FORWARD_SLOW_SPRITE
        anim_script SPRITE
        loop 8
                blank_frame 2
                move_target DOWN, 1
                blank_frame 2
                move_target UP, 1
                blank_frame 2
                move_target DOWN, 1
                blank_frame 2
                move_target UP, 1
                blank_frame 2
                move_target FORWARD, 1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $024F: Misc. Monster Animation $01: Move Back (sprite) ]

; d0/0b4c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MOVE_BACK_SLOW_SPRITE
        anim_script SPRITE
        loop 8
                blank_frame 2
                move_target DOWN, 1
                blank_frame 2
                move_target UP, 1
                blank_frame 2
                move_target DOWN, 1
                blank_frame 2
                move_target UP, 1
                blank_frame 2
                move_target BACK, 1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $024D: Misc. Monster Animation $00/$09: Flash Red (bg1) ]

; d0/0b66
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLASH_RED_BG1
        anim_script BG1
        hide_bg1_thread
        move_bg1_here
        mod_pal BG1, SUB, CYAN, 0
        loop 32
                blank_frame
                mod_pal BG1, SUB, CYAN, +1
                end_loop
        loop 32
                blank_frame
                end_loop
        loop 32
                blank_frame
                mod_pal BG1, SUB, CYAN, -1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $024B: Monster Entry $0B: Horizontal Fade (bg3) ]

; d0/0b7f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HORZ_FADE_ENTRY_BG3
        anim_script BG3, 1, BOTTOM
        match_target_dir
        sfx
        move BACK, 64
        move DOWN, 1
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {SPRITE, BG2}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 7, 2, HORZ
        update_window_hdma
        frame 0
        bg_screen_pos BG3, TOP_RIGHT
        frame 1
        loop 129
                move FORWARD, 2
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                end_loop
        wait_scanline
        validate_monster_entry
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $024C: Monster Exit $0B: Horizontal Fade (bg3) ]

; d0/0bb5
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HORZ_FADE_EXIT_BG3
        anim_script BG3, 1, BOTTOM
        sfx
        match_target_dir
        move DOWN, 1
        loop 6
                move FORWARD, 32
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        init_scroll_wave BG3, 7, 1, HORZ
        set_scroll_hdma BG3, 7
        blank_frame
        update_scroll_wave BG3, HORZ
        align_bg3_vscroll
        bg_screen_pos BG3, TOP_RIGHT
        frame 1
        loop 128
                move BACK, 2
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                end_loop
        wait_scanline
                mainscreen_layers {BG2, BG3, SPRITE}
        hide_target_monsters
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0249: Monster Entry $0A: Materialize (bg3) ]

; d0/0bf0
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MATERIALIZE_ENTRY_BG3
        anim_script BG3, 1, BOTTOM
        match_target_dir
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 1, HORZ
        update_window_hdma
        sfx
        anim_loop 8
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                end_anim_loop
        wait_scanline
        validate_monster_entry
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $024A: Monster Exit $0A: Materialize (bg3) ]

; d0/0c26
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MATERIALIZE_EXIT_BG3
        anim_script BG3, 1, BOTTOM
        sfx
        match_target_dir
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 1, HORZ
        blank_frame
        anim_loop 8
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                end_anim_loop
        wait_scanline
        mainscreen_layers {BG2, BG3, SPRITE}
        hide_target_monsters
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0247: Monster Entry $09: Fade Bottom to Top (bg3) ]

; d0/0c5d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FADE_UP_ENTRY_BG3
        anim_script BG3, 1, BOTTOM
        sfx
        match_target_dir
        move DOWN, 64
        move DOWN, 16
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 1, HORZ
        update_window_hdma
        loop 129
                move UP, 2
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                end_loop
        wait_scanline
        validate_monster_entry
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0248: Monster Exit $09: Fade Bottom to Top (bg3) ]

; d0/0c8c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FADE_UP_EXIT_BG3
        anim_script BG3, 1, BOTTOM
        sfx
        match_target_dir
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 1, HORZ
        loop 6
                move DOWN, 32
                end_loop
        move DOWN, 16
        blank_frame
        loop 104
                move UP, 2
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                end_loop
        wait_scanline
        mainscreen_layers {BG2, BG3, SPRITE}
        hide_target_monsters
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0244: Monster Entry $08: Fade Top to Bottom (bg3) ]

; d0/0cbd
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FADE_DOWN_ENTRY_BG3
        anim_script BG3, 1, BOTTOM
        sfx
        match_target_dir
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 1, HORZ
        update_window_hdma
        loop 128
                move DOWN, 2
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                end_loop
        wait_scanline
        validate_monster_entry
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0245: Monster Exit $08: Fade Top to Bottom (bg3) ]

; d0/0ce6
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FADE_DOWN_EXIT_BG3
        anim_script BG3, 1, TOP
        sfx
        match_target_dir
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 1, HORZ
        loop 6
                move UP, 32
                end_loop
        move UP, 16
        blank_frame
        loop 137
                move DOWN, 2
                update_scroll_wave BG3, HORZ
                align_bg3_vscroll
                frame 0
                mainscreen_layers {BG1, BG2, BG3, SPRITE}
                end_loop
        wait_scanline
        mainscreen_layers {BG2, BG3, SPRITE}
        hide_target_monsters
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0243: step forward if needed (bg1) ]

; d0/0d17
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STEP_FORWARD_BG1
        anim_script BG1
        jump_step :+
        call _d07067
:       end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0242: runic absorb (sprite) ]

; d0/0d1f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RUNIC_ABSORB_SPRITE
        anim_script SPRITE
        sfx
        move UP, 13
        move BACK, 7
        target_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame 3
        loop 32
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0246: Lifeshaver (bg1) ]

; d0/0d35
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LIFESHAVER_BG1
        anim_script BG1, 1, BOTTOM
        target_priority 2
        fixed_draw_order
        mod_pal BG1, SUB, WHITE, 31
        loop 9
                move DOWN, 16
                end_loop
        frame 0
        hide_bg1_thread
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                hide_bg1_thread
                end_loop
        loop 9
                target_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                target_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                target_frame CHAR_FRAME::JUMPING_FORWARD + $30 , CHAR_FRAME::JUMPING_UP
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                target_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $023E: Monster Entry $06: Sand (sprite) ]

; d0/0d8e
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SAND_ENTRY_SPRITE
        anim_script SPRITE, 1, BOTTOM
        call _d05f25
        match_target_dir
        move DOWN, 8
        jump_thread _d00dc7, _d00db2, _d00da4, _d00d9f

_d00d9f:
        move BACK, 16
        jump _d01018

_d00da4:
        move FORWARD, 16
        anim_speed 4
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
        end_anim_script

_d00db2:
        move_target DOWN, 16
        validate_monster_entry
        loop 4
                move_target UP, 4
                frame 0
                end_loop
        anim_speed 4
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
_d00dc7:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $023F: Monster Exit $06: Sand (sprite) ]

; d0/0dc8
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SAND_EXIT_SPRITE
        anim_script SPRITE, 1, BOTTOM
        match_target_dir
        call _d05f25
        fixed_draw_order
        move DOWN, 8
        loop 4
                move_target DOWN, 4
                blank_frame
                end_loop
        hide_target_monsters
        frame
        anim_speed 4
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
        move_target UP, 16
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $023D: Seize (bg1) ]

; d0/0de9
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SEIZE_BG1
        anim_script BG1, 1, BOTTOM
        move_bg1_here
        hide_bg1_thread
        fixed_draw_order
        set_scroll_hdma BG1, 0
        loop 5
                update_seize_stretch 84
                blank_frame
                end_loop
        loop 8
                blank_frame
                end_loop
        loop 5
                update_seize_stretch -84
                blank_frame
                end_loop
        jump_hit :+
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        end_anim_script

:       save_seize_char_pos
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0214: Seize (sprite) ]

; d0/0e14
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SEIZE_SPRITE
        anim_script SPRITE
        loop 5
                blank_frame
                end_loop
        sfx
        anim_loop 14
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $023C: Monster Exit $05: Float (sprite) ]

; d0/0e21
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLOAT_EXIT_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        reset_ellipse
        move_ellipse 64, 128
        loop 20
                move_target UP, 8
                move_ellipse 0, 6
                blank_frame
                end_loop
        hide_target_monsters
        blank_frame
        loop 5
                move_target DOWN, 32
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $023B: Monster Entry $05: Float (sprite) ]

; d0/0e3d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLOAT_ENTRY_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        reset_ellipse
        move_ellipse 64, 128
        loop 5
                move_target UP, 32
                end_loop
        validate_monster_entry
        call _d00e56
        call _d00e56
        end_anim_script

.mac move_float count, yy
        .repeat count
        move_target DOWN, 2
        .if yy > 0
        move_target FORWARD, yy
        .elseif yy < 0
        move_target BACK, -yy
        .endif
        blank_frame
        .endrep
.endmac

_d00e56:
        move_float 3, +3
        move_float 3, +2
        move_float 3, +1
        move_float 2, 0
        move_float 3, -1
        move_float 3, -2
        move_float 3, -3
        move_float 3, -3
        move_float 3, -2
        move_float 3, -1
        move_float 2, 0
        move_float 3, +1
        move_float 3, +2
        move_float 3, +3
        return

.delmac move_float

; ------------------------------------------------------------------------------

; [ Animation Script $023A: Event Animation $0E: Transform into Magicite (bg3) ]

; d0/0f17
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRANSFORM_MAGICITE_BG3
        anim_script BG3
        fixed_draw_order
        move_bg3_here
        frame 0
        hide_bg3_thread
        sfx DEZONE
        init_circle {128, 100}, 80, {222, 255}, 128, 0
        move_circle_to_target
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 2, HORZ
        mod_pal BG2, ADD, WHITE, 31
        mod_pal BG3, ADD, WHITE, 31
        target_priority 0
        loop 38
                zoom_circle -1
                update_circle
                update_scroll_wave BG3, HORZ
                mod_pal BG2, ADD, WHITE, -2
                mod_pal BG3, ADD, WHITE, -2
                frame 0
                end_loop
        loop 19
                zoom_circle -2
                update_circle
                update_scroll_wave BG3, HORZ
                mod_pal BG2, ADD, WHITE, -2
                mod_pal BG3, ADD, WHITE, -2
                frame 0
                end_loop
        set_scroll_hdma BG3, 5
        hide_target_monsters
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0239: Event Animation $0E: Transform into Magicite (sprite) ]

; this is used when kefka turns an esper into magicite in thamasa

; d0/0f59
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRANSFORM_MAGICITE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_to_attacker
        calc_vec
        jump_thread _d00f70, _d00fed, _d00fed, _d00fed, _d00fed, _d00fed, _d00fed, _d00fed

; main thread
_d00f70:

; orbit and fly toward target
        sfx
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       update_orbit_32
        frame 0
        move_vec :-, 1

; move particle effect on target
        move_to_target
        attacker_frame CHAR_FRAME::NONE
        move UP_FORWARD, 16
        sfx
        loop 65
                move_rand {31, 31}
                blank_frame
                end_loop

; start bg3 effect, continue particle effect
        unpause_layer BG3
        loop 65
                move_rand {31, 31}
                blank_frame
                end_loop

; turn into magicite and bounce away
        sfx QUICK_A
        move DOWN_BACK, 16
        move_rand {0, 0}
        blank_frame
        frame 8
        move UP, 4
        move FORWARD, 2
        blank_frame
        frame 8
        move UP, 3
        move FORWARD, 2
        blank_frame
        frame 8
        move UP, 2
        move FORWARD, 2
        blank_frame
        frame 8
        move UP, 2
        move FORWARD, 2
        blank_frame
        frame 8
        move DOWN, 2
        move FORWARD, 2
        blank_frame
        frame 8
        move DOWN, 2
        move FORWARD, 2
        blank_frame
        frame 8
        move DOWN, 3
        move FORWARD, 2
        blank_frame
        frame 8
        move DOWN, 4
        move FORWARD, 2
        blank_frame
        frame 8
        loop 32
                blank_frame
                frame 8
                end_loop

; kefka walks over
        calc_vec_char
        update_char_vec_dir_walk
        ignore_char_vec_offset
:       frame 8
        move_vec_char :-, 1

; kefka picks it up
        attacker_action CHAR_ACTION::NONE
        attacker_frame CHAR_FRAME::WALKING_FORWARD_3
        loop 16
                move BACK, 1
                frame 8, 3
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; additional threads for particle effect
_d00fed:
        anim_speed 4
        loop 6
                move_to_first_thread
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0230: Event Animation $05: Bahamut (bg1) ]

; d0/0ffd
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_BAHAMUT_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_ZONESEEK_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_FENRIR_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_TERRATO_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_SHIVA_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_KIRIN_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_BISMARK_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_CARBUNKL_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVENT_PHANTOM_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHOCK_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GESTAHL_LIGHTNING_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GESTAHL_BLACK_MAGIC_BG1
        anim_script BG1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $022E: Monster Entry $04: Water (sprite) ]

; d0/1000
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WATER_ENTRY_SPRITE
        anim_script SPRITE, 1, BOTTOM
        call _d05f25
        match_target_dir
        move DOWN, 32
        jump_thread _d0103e, _d01024, _d01016, _d01011
_d01011:
        move BACK, 16
        jump _d01018
_d01016:
        move FORWARD, 16
_d01018:
        anim_speed 4
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
        end_anim_script
_d01024:
        move_target DOWN, 32
        validate_monster_entry
        loop 4
                move_target UP, 4
                frame 0
                end_loop
        loop 4
                move_target UP, 4
                frame 1
                end_loop
        anim_speed 4
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
_d0103e:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $022F: Monster Exit $04: Water (sprite) ]

; d0/103f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WATER_EXIT_SPRITE
        anim_script SPRITE, 1, BOTTOM
        match_target_dir
        fixed_draw_order
        call _d05f25
        move DOWN, 32
        loop 8
                move_target DOWN, 4
                blank_frame
                end_loop
        hide_target_monsters
        blank_frame
        anim_speed 4
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
        move_target UP, 32
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $022C: Monster Entry $03/$07: Sides (sprite) ]

; d0/1060
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SIDE_ENTRY_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        loop 8
                move_target BACK, 32
                end_loop
        validate_monster_entry
        loop 16
                move_target FORWARD, 16
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $022D: Monster Exit $03/$07: Sides (sprite) ]

; d0/1074
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SIDE_EXIT_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        loop 32
                move_target BACK, 8
                blank_frame
                end_loop
        hide_target_monsters
        blank_frame
        loop 8
                move_target FORWARD, 32
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $022B: Monster Exit $02: Ceiling (sprite) ]

; d0/1088
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CEILING_EXIT_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        loop 20
                move_target UP, 8
                blank_frame
                end_loop
        hide_target_monsters
        blank_frame
        loop 5
                move_target DOWN, 32
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $022A: Monster Entry $02: Ceiling (sprite) ]

; d0/109c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CEILING_ENTRY_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        loop 5
                move_target UP, 32
                end_loop
        validate_monster_entry
        loop 20
                move_target DOWN, 8
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0229: Monster Entry $01: Puff of Smoke (sprite) ]

; d0/10b0
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SMOKE_ENTRY_SPRITE
        anim_script SPRITE, 5, CENTER
        match_target_dir
        move UP_FORWARD, 16
        move_rand {31, 31}
        sfx
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        move_rand {31, 31}
        frame 0
        frame 1
        frame 2
        validate_monster_entry
        frame 3
        frame 4
        frame 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0228: Heal Force (sprite) ]

; d0/10cd
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HEAL_FORCE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        loop 25
                blank_frame
                end_loop
        anim_speed 4
        sfx
        anim_loop 17
                frame 0
                end_anim_loop
        sfx CURE_B
        frame 17
        frame 18
        frame 19
        frame 20
        frame 21
        frame 22
        frame 23
        frame 24
        frame 25
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0225: Possess (bg1) ]

; d0/10e9
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::POSSESS_BG1
        anim_script BG1
        jump_hit _d010f2
        call _d07067
        end_anim_script
_d010f2:
        hide_attacker_char
        move_to_attacker
        calc_vec
        vec_offset 0
        bg_target_draw_order
        target_priority 2
        jump_attacker _d01107, _d01120, _d01137, _d0114e, _d01164
_d01107:
        sfx
:       update_vec_wave
        frame 0
        move_vec :-, 2
        update_vec_wave
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        end_anim_script
_d01120:
        sfx
:       update_vec_wave
        frame 1
        move_vec :-, 2
        update_vec_wave
        ; wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                frame 1
                end_loop
        end_anim_script
_d01137:
        sfx
:       update_vec_wave
        frame 2
        move_vec :-, 2
        update_vec_wave
        ; wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                frame 2
                end_loop
        end_anim_script
_d0114e:
        sfx
:       update_vec_wave
        frame 3
        move_vec :-, 2
        update_vec_wave
        ; wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                frame 3
                end_loop
_d01164:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0224: Cure 3 (sprite) ]

; d0/1165
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CURAGA_SPRITE
        anim_script SPRITE
        reset_ellipse
        move_polar 48, 0
        jump_thread _d0117c, _d011a7, _d01175, _d01175
_d01175:
        loop 65
                blank_frame
                end_loop
        jump _d011cb
_d0117c:
        fixed_draw_order
        sfx
        blank_frame 3
        move_polar 0, -128
        loop 17
                move_polar 0, -6
                frame 0
                end_loop
        loop 17
                move_polar 0, -6
                frame 1
                end_loop
        loop 17
                move_polar 0, -6
                frame 2
                end_loop
        loop 17
                move_polar 0, -6
                frame 3
                end_loop
        sfx CURA
        jump _d011cb
_d011a7:
        loop 17
                update_rainbow_pal
                move_polar 0, -6
                frame 0
                end_loop
        loop 17
                update_rainbow_pal
                move_polar 0, -6
                frame 1
                end_loop
        loop 17
                update_rainbow_pal
                move_polar 0, -6
                frame 2
                end_loop
        loop 17
                update_rainbow_pal
                move_polar 0, -6
                frame 3
                end_loop
_d011cb:
        anim_speed 3
        loop 6
                move_rand {31, 31}
                frame 4
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C2: Meteo (bg3) ]

; d0/11d8
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::METEO_BG3
        anim_script BG3
        hide_bg3_thread
        mod_pal BG2, ADD, RED, 0
        loop 32
                mod_pal BG2, ADD, RED, +1
                blank_frame
                end_loop
        loop 81
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, ADD, RED, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01BB: Magnitude8 (sprite) ]

; d0/11ef
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MAGNITUDE8_SPRITE
        anim_script SPRITE
        loop 32
                blank_frame
                end_loop
        loop 32
                move_target FORWARD, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $018E: Slow, Slow 2 (bg3) ]

; d0/11ff
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLOW_BG3
        anim_script BG3
        fixed_draw_order
        sfx
        move_bg3_here
        blank_frame
        wait_scanline
        mainscreen_layers {BG1, BG2, SPRITE}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 1, HORZ
        mod_pal BG3, SUB, WHITE, 31
        update_scroll_wave BG3, HORZ
        frame 0
        bg_screen_pos BG3, TOP_RIGHT
        frame 0
        update_scroll_wave BG3, HORZ
        hide_bg3_thread
        wait_scanline
        mainscreen_layers {BG1, BG2, BG3, SPRITE}
        loop 32
                move FORWARD, 1
                mod_pal BG3, SUB, WHITE, -1
                update_scroll_wave BG3, HORZ
                frame 0
                end_loop
        loop 65
                move FORWARD, 1
                update_scroll_wave BG3, HORZ
                frame 0
                end_loop
        loop 32
                move FORWARD, 1
                mod_pal BG3, SUB, WHITE, +1
                update_scroll_wave BG3, HORZ
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 5
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        reset_scroll_hdma BG3
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0181: WaveCannon (sprite) ]

; d0/124b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WAVECANNON_SPRITE
        anim_script SPRITE, 3
        sprite_priority 2
        loop 22
                blank_frame
                end_loop
        move UP_FORWARD, 16
        move_rand {31, 31}
        anim_loop 9
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0133: WaveCannon (bg1) ]

; d0/125d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WAVECANNON_BG1
        anim_script BG1
        move_bg1_here
        fixed_draw_order
        sfx
        sprite_priority 2
        init_circle {0, 0}, 0, {255, 255}, 128, 0
        move_circle_to_attacker
        bg_target_draw_order
        change_anim_layer BG1
        sprite_priority 2
        bg_screen_pos BG1, TOP_RIGHT
        frame 0, 2
        loop 51
                zoom_circle +4
                move_circle {-4, 0}
                move FORWARD, 16
                wait_scanline 208
                update_circle
                frame 0
                end_loop
        loop 65
                move FORWARD, 16
                wait_scanline 208
                update_circle
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                move FORWARD, 16
                wait_scanline 208
                update_circle
                frame 0
                end_loop
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $021A: Purifier (bg1) ]

; d0/12a4
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CRUSADER_BG1
        anim_script BG1
        fixed_draw_order
        hide_bg1_thread
        call _d05516
        move_bg1_here
        sfx DEFAULT, CENTER
        loop 209
                blank_frame
                end_loop
        jump_dir _d012cc, _d012bc
_d012bc:
        mode7_flip HORZ
        move FORWARD, 96
        move UP, 40
        jump _d012d9
_d012cc:
        mode7_flip NONE
        move BACK, 96
        move UP, 40
_d012d9:
        wait_scanline
        mainscreen_layers {BG1, SPRITE}
        screen_mode 7
        sprite_priority 3
        mode7_move {-70, -70}
        mode7_move {-40, 33}
        loop 31
                mode7_move {3, 2}, {-4, -4}
                blank_frame
                end_loop
        sprite_priority 0
        loop 30
                mode7_move {3, 2}, {-4, -4}
                blank_frame
                end_loop
        wait_scanline
        sprite_priority 3
        blank_frame
        wait_scanline
        mainscreen_layers {BG2, SPRITE}
        screen_mode 1
        loop 49
                blank_frame 2
                end_loop
        call _d05549
        call _d02ca0
        enable_char_pal_update
        restore_char_pal
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00AF: Purifier (bg3) ]

; d0/1323
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CRUSADER_BG3
        anim_script BG3
        move_bg3_here
        jump_dir _d0132d, _d01338
_d0132d:
        init_circle {192, 104}, 64, {255, 255}, 128, 0
        jump _d01340
_d01338:
        init_circle {64, 104}, 64, {255, 255}, 128, 0
_d01340:
        mod_pal BG2, SUB, WHITE, 0
        loop 33
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, {GREEN, BLUE}, +2
                blank_frame
                end_loop
        loop 45
                blank_frame
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        loop 31
                zoom_circle -2
                move_circle {-2, 0}
                update_circle
                frame 8
                end_loop
        circle_shape ULTIMA
        loop 25
                zoom_circle +4
                update_circle
                frame 8
                end_loop
        bg3_window 2
        anim_loop 8
                frame 0, 3
                end_anim_loop
        anim_loop 8
                frame 0, 3
                end_anim_loop
        blank_frame
        loop 32
                mod_pal BG2, SUB, RED, +1
                blank_frame
                end_loop
        loop 129
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, SUB, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0219: Purifier (sprite) ]

; d0/138f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CRUSADER_SPRITE
        anim_script SPRITE
        move_xy {128, 72}
        loop 37
                blank_frame
                end_loop
        disable_char_pal_update
        blank_frame
        jump_thread _d013a4, _d013c5, _d013f9

_d013a4:
        blank_frame 2
        load_crusader_gfx
        use_8x8_bg1_tiles
        anim_sprite_pal 6
        move DOWN, 16
        move UP, 128
        loop 16
                blank_frame
                end_loop
        loop 16
                move DOWN, 8
                frame 2
                end_loop
        loop 169
                frame 2
                end_loop
        end_anim_script

_d013c5:
        blank_frame
        load_crusader_pal
        anim_sprite_pal 7
        move UP_BACK, 8
        blank_frame
        move DOWN_FORWARD, 128
        loop 16
                blank_frame
                end_loop
        loop 16
                move UP_BACK, 8
                frame 0
                end_loop
        loop 89
                frame 0, 2
                end_loop
        anim_priority 0
        loop 24
                frame 0, 2
                end_loop
        anim_priority 3
        loop 24
                frame 0, 2
                end_loop
        loop 16
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        end_anim_script

_d013f9:
        move FORWARD, 8
        blank_frame 2
        move DOWN_BACK, 128
        loop 16
                blank_frame
                end_loop
        loop 16
                move UP_FORWARD, 8
                frame 1
                end_loop
        loop 137
                frame 1, 2
                end_loop
        loop 16
                move DOWN_BACK, 8
                frame 1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0166: Tek Laser (sprite) ]

; d0/141b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TEK_LASER_SPRITE
        anim_script SPRITE, 4
        sfx L4_FLARE
        jump_thread _d01426, _d0142a, _d0142a
_d01426:
        anim_loop 21
                frame 0
                end_anim_loop
_d0142a:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0165: Tek Laser (bg1) ]

; d0/142b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TEK_LASER_BG1
        anim_script BG1, 3
        fixed_draw_order
        sfx
        loop 4
                move BACK, 31
                end_loop
        anim_loop 7
                frame 0
                end_anim_loop
        unpause_layer {BG3, SPRITE}
        target_frame CHAR_FRAME::HIT
        frame 7
        frame 8
        frame 9
        loop 16
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0175: ChokeSmoke (bg1) ]

; d0/144a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHOKESMOKE_BG1
        anim_script BG1, 3, BOTTOM
        move BACK, 16
        sfx
        anim_loop 6
                frame 0
                end_anim_loop
        move BACK, 8
        frame 6
        frame 7
        frame 8
        frame 9
        frame 10
        frame 11
        anim_speed 2
        loop 16
                move FORWARD, 1
                frame 11
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                frame 11
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $020C: HyperDrive (sprite) ]

; d0/1473
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HYPERDRIVE_SPRITE
        anim_script SPRITE, 1, BOTTOM
        move_to_attacker
        calc_vec
        move FORWARD, 32
        vec_offset 0
        jump_thread _d014ba, _d01488, _d01492, _d0149c, _d014a6, _d014b0

_d01488:
        loop 2
                blank_frame
                end_loop
:       frame 1
        frame 2
        move_vec :-, 16
        end_anim_script

_d01492:
        loop 4
                blank_frame
                end_loop
:       frame 2
        frame 3
        move_vec :-, 16
        end_anim_script

_d0149c:
        loop 6
                blank_frame
                end_loop
:       frame 3
        frame 4
        move_vec :-, 16
        end_anim_script

_d014a6:
        loop 8
                blank_frame
                end_loop
:       frame 4
        frame 5
        move_vec :-, 16
        end_anim_script

_d014b0:
        loop 10
                blank_frame
                end_loop
:       frame 5
        frame 6
        move_vec :-, 16
        end_anim_script

_d014ba:
        sfx
:       frame 0
        frame 1
        move_vec :-, 16
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        sfx FIRAGA
        init_circle {0, 0}, 0, {255, 255}, 128, 0
        move_circle_to_target
        bg_target_draw_order
        change_anim_layer BG1
        loop 25
                zoom_circle +2
                update_circle
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 16
                zoom_circle +2
                update_circle
                mod_pal BG1, SUB, WHITE, +2
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00CB: GrandTrain (bg1) ]

; d0/14ed
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GRANDTRAIN_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        move_bg1_here
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG1, SPRITE}
        bg1_window 2
        loop 138
                cycle_pal BG1_ANIM, -2, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D4: GrandTrain (bg3) ]

; d0/1504
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GRANDTRAIN_BG3
        anim_script BG3, 1, SCREEN
        move_bg3_here
        sprite_priority 2
        init_triangle {128, 80}, 0, 0
        frame 0
        hide_bg3_thread
        sfx DEFAULT, CENTER
        loop 57
                zoom_triangle 3, 4
                update_triangle_3d
                frame 0
                end_loop
        loop 49
                rotate_triangle 4
                update_triangle_3d
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        mod_pal BG3, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                mod_pal BG3, SUB, WHITE, +1
                rotate_triangle 4
                update_triangle_3d
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01E0: Wild Fang (sprite) ]

; d0/153c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WILD_FANG_SPRITE
        anim_script SPRITE, 1, BOTTOM
        loop 8
                move BACK, 32
                end_loop
        call _d01555
        sfx ESPER_TERRA_ZOZO
        anim_speed 5
        frame 1
        frame 3
        frame 4
        frame 3
        frame 1
        anim_speed 2
        call _d01555
        end_anim_script

_d01555:
        loop 5
                sfx
                .repeat 4
                move FORWARD, 4
                frame 0
                .endrep
                .repeat 4
                move FORWARD, 4
                frame 1
                .endrep
                .repeat 4
                move FORWARD, 4
                frame 2
                .endrep
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $01E4: Takedown (sprite) ]

; d0/157f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TAKEDOWN_SPRITE
        anim_script SPRITE, 1, BOTTOM
        loop 8
                move BACK, 32
                end_loop
        call _d01555
        unpause_layer BG1
        call _d01555
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01E5: Takedown (bg1) ]

; d0/158f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TAKEDOWN_BG1
        anim_script BG1, 5, CENTER
        sfx THROW
        anim_loop 4
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0189: L? Pearl (sprite) ]

; d0/1598
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PEARL_LORE_SPRITE
        anim_script SPRITE, 2, BOTTOM
        loop 5
                move UP_BACK, 32
                end_loop
        sfx
        loop 10
                move DOWN_FORWARD, 16
                frame 4
                end_loop
        frame 3
        frame 2
        frame 1
        frame 0
        bg_target_draw_order
        change_anim_layer BG1
        realign_to_target_center
        sfx L4_FLARE
        anim_speed 4
        anim_loop 14
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $018D: Aero (bg1) ]

; d0/15ba
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AERO_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        sprite_priority 2
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG3, SUB, WHITE, 31
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        sfx
        set_scroll_hdma BG3, 2
        frame 0
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                mod_pal BG3, SUB, WHITE, -1
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        loop 129
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                mod_pal BG3, SUB, WHITE, +1
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0191: Aero (bg3) ]

; d0/15f5
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AERO_BG3
        anim_script BG3
        move_bg3_here
        frame 0
        hide_bg3_thread
        loop 193
                rand_bg3_hscroll 0
                frame 0
                end_loop
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0197: Cyclonic (sprite) ]

; d0/1606
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CYCLONIC_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AERO_SPRITE
        anim_script SPRITE
        loop 16
                blank_frame
                end_loop
        anim_speed 3
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        loop 7
                frame 0
                frame 1
                frame 2
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B2: Big Guard (sprite) ]

; d0/161b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIG_GUARD_SPRITE
        anim_script SPRITE
        jump_thread _d01626, _d01630, _d01641, _d01641
_d01626:
        sfx
        anim_loop 11
                frame 0, 4
                end_anim_loop
        end_anim_script
_d01630:
        move DOWN_BACK, 8
        loop 29
                blank_frame
                end_loop
        bg_target_draw_order
        change_anim_layer BG1
        loop 65
                cycle_pal BG1_ANIM, 4, {1, 7}
                frame 0
                end_loop
_d01641:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0182:  ]

; d0/1642
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_386
        anim_script SPRITE, 3
        loop 21
                blank_frame
                end_loop
        anim_loop 11
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0183: Train (bg1) ]

; d0/164d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRAIN_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 73
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0184: Train (bg3) ]

; d0/1672
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRAIN_BG3
        anim_script BG3, 1, SCREEN
        fixed_draw_order
        move_bg3_here
        sprite_priority 2
        init_triangle {128, 80}, 0, 0
        frame 0
        hide_bg3_thread
        loop 57
                zoom_triangle 3, 4
                update_triangle_3d
                frame 0
                end_loop
        loop 49
                rotate_triangle 4
                update_triangle_3d
                frame 0
                end_loop
        mod_pal BG3, SUB, WHITE, 0
        loop 32
                mod_pal BG3, SUB, WHITE, +1
                rotate_triangle 4
                update_triangle_3d
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $018F: Aqua Rake (bg1) ]

; d0/16a5
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AQUA_RAKE_BG1
        anim_script BG1, 5
        sprite_priority 2
        sfx
        anim_loop 15
                frame 0
                end_anim_loop
        anim_loop 15
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0180: CleanSweep (bg1) ]

; d0/16b4
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLEANSWEEP_BG1
        anim_script BG1
        sfx
        sprite_priority 3
        fixed_draw_order
        move_bg1_here
        move DOWN, 80
        loop 37
                move UP, 1
                move BACK, 2
                auto_frame 2, {0, 4}
                frame 11
                move FORWARD, 2
                auto_frame 2, {0, 4}
                frame 11
                end_loop
        loop 9
                move UP, 3
                move BACK, 2
                auto_frame 2, {0, 4}
                frame 11
                move UP, 3
                move FORWARD, 2
                auto_frame 2, {0, 4}
                frame 11
                end_loop
        mod_pal BG2, SUB, {RED, GREEN}, 0
        init_scroll_wave BG2, 2, 1, HORZ
        loop 9
                auto_frame 2, {0, 4}
                update_scroll_wave BG2, HORZ
                wait_scanline
                mod_pal BG2, SUB, {RED, GREEN}, +4
                frame 11
                end_loop
        reset_frame_offset
        wait_scanline
        set_scroll_hdma BG1, 3
        move_bg1_here
        bg1_window 1
        loop 9
                move BACK, 32
                end_loop
        sprite_priority 2
        call _d01725
        call _d01725
        mainscreen_layers {BG2, SPRITE}
        loop 32
                mod_pal BG2, SUB, {RED, GREEN}, -4
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        wait_scanline
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, HORZ
        end_anim_script

_d01725:
        anim_loop 11
                .repeat 6
                update_scroll_wave BG2, HORZ
                move FORWARD, 4
                frame 0
                .endrep
                end_anim_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00F9: Wall (sprite) ]

; d0/1747
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WALL_SPRITE
        anim_script SPRITE
        fixed_draw_order
        anim_priority 0
        loop 65
                blank_frame
                end_loop
        sfx
        loop 65
                frame 0
                end_loop
        anim_speed 5
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00FA: Wall (bg1) ]

; d0/1761
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WALL_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        sprite_priority 2
        move_xy {128, 80}
        sfx DRAIN, CENTER
        mod_pal BG1, ADD, WHITE, 31
        loop 32
                mod_pal BG1, ADD, WHITE, -1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                frame 0
                end_loop
        hide_bg1_thread
        mod_pal BG2, SUB, WHITE, 0
; red
        loop 16
                mod_pal BG2, SUB, {GREEN, BLUE}, +1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
; yellow
        loop 16
                mod_pal BG2, SUB, GREEN, -1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
; green
        loop 16
                mod_pal BG2, SUB, RED, +1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
; cyan
        loop 16
                mod_pal BG2, SUB, BLUE, -1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
; blue
        loop 16
                mod_pal BG2, SUB, GREEN, +1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
; magenta
        loop 16
                mod_pal BG2, SUB, RED, -1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
; back to normal
        loop 16
                mod_pal BG2, SUB, GREEN, -1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
        loop 129
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                frame 0
                end_loop
        sfx DRAIN
        loop 16
                mod_pal BG1, ADD, WHITE, +1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                frame 0
                mod_pal BG1, ADD, WHITE, +1
                cycle_pal SPRITE_ANIM, 4, {1, 7}
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B0: Bserk (sprite) ]

; *** bug *** It looks like they intended to ramp the gradient
; intensity up and down, but because the subroutine
; includes "update_rainbow_gradient 0" every frame it uses
; the full intensity for the gradient the entire time.

; d0/17d5
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BERSERK_SPRITE
        anim_script SPRITE, 4
        fixed_draw_order
        sfx TEK_LASER
        anim_loop 8
                frame 0
                end_anim_loop
        sfx QUICK_A
        frame 8
        frame 9
        frame 10
        frame 11
        anim_speed 2
        wait_scanline
        color_math {ADD, FIXED_CLR}, BG1
        sfx BERSERK

.if 1
        update_rainbow_gradient 11
        call _d01823
        update_rainbow_gradient 7
        call _d01823
        update_rainbow_gradient 3
        call _d01823
        loop 65
                update_rainbow_gradient 0
                blank_frame
                end_loop
        update_rainbow_gradient 3
        call _d01823
        update_rainbow_gradient 7
        call _d01823
        update_rainbow_gradient 11
        call _d01823
        update_rainbow_gradient 15
        call _d01823
        reset_gradient
        end_anim_script

_d01823:
        loop 8
                update_rainbow_gradient 0
                blank_frame
                end_loop
        return
.else

; bugfix (ramps the gradient up and down and saves 8 bytes)
        call BserkRainbow1
        call BserkRainbow2
        call BserkRainbow3
        loop 65
                update_rainbow_gradient 0
                blank_frame
                end_loop
        call BserkRainbow3
        call BserkRainbow2
        call BserkRainbow1
        reset_gradient
        end_anim_script

BserkRainbow1:
        loop 8
                update_rainbow_gradient 11
                blank_frame
                end_loop
        return

BserkRainbow2:
        loop 8
                update_rainbow_gradient 7
                blank_frame
                end_loop
        return

BserkRainbow3:
        loop 8
                update_rainbow_gradient 3
                blank_frame
                end_loop
        return

; to match original script length
        ; .res 8

.endif

; ------------------------------------------------------------------------------

; [ Animation Script $00C9: Bio (sprite) ]

; d0/182b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIO_SPRITE
        anim_script SPRITE
        sfx
        jump_thread _d01838, _d01844, _d01843, _d01843
_d01838:
        anim_priority 3
        anim_speed 6
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
_d01843:
        end_anim_script
_d01844:
        wait_scanline
        color_math {ADD, FIXED_CLR}
        mod_pal BG1, SUB, WHITE, 0
        bg_target_draw_order
        change_anim_layer BG1
        wait_scanline
        set_scroll_hdma BG1, 6
        init_scroll_wave BG1, 4, 1, {VERT, HORZ}
        anim_speed 2
        loop 17
                update_scroll_wave BG1, {HORZ, VERT}
                frame 0, 2
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        loop 4
                mod_pal BG1, SUB, WHITE, +4
                update_scroll_wave BG1, {HORZ, VERT}
                frame 0
                mod_pal BG1, SUB, WHITE, +4
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG1, 3
        reset_scroll_hdma BG1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0223: Event Animation $04: Water Splash (sprite) ]

; d0/1878
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WATER_SPLASH_SPRITE
        anim_script SPRITE
        move_xy {96, 96}
        move FORWARD, 8
        jump_thread _d0189e, _d01893, _d0188e, _d01889
_d01889:
        move BACK, 16
        jump _d01893
_d0188e:
        move FORWARD, 16
        jump _d01893                    ; this could be removed
_d01893:
        anim_speed 5
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
_d0189e:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0222: Event Animation $03: Water Splash (bg1) ]

; d0/189f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WATER_SPLASH_BG1
        anim_script BG1
        fixed_draw_order
        move_xy {96, 96}
        loop 54
                blank_frame
                end_loop
        move DOWN_FORWARD, 8
        anim_speed 5
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 1
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E4: Pearl (sprite) ]

; d0/18b9
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HOLY_SPRITE
        anim_script SPRITE
        fixed_draw_order
        loop 16
                blank_frame
                end_loop
        reset_ellipse
        move UP, 160
        jump_thread _d018d4, _d018dc, _d018e2
_d018d4:
        sfx
        move_ellipse 64, 0
        jump _d018e5
_d018dc:
        move_ellipse 64, 85
        jump _d018e5
_d018e2:
        move_ellipse 64, -86
_d018e5:
        loop 161
                move_ellipse 0, 4
                move DOWN, 1
                update_ellipse_priority
                frame 0
                end_loop
        move_ellipse -64, 4
        unpause_layer BG1
        anim_speed 3
        move UP_FORWARD, 16
        loop 3
                move_rand {31, 31}
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                frame 7
                frame 8
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E5: Pearl (bg1) ]

; d0/1908
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HOLY_BG1
        anim_script BG1, 3
        anim_loop 14
                frame 0
                end_anim_loop
        mod_pal BG2, ADD, WHITE, 0
        anim_loop 14
                frame 0
                mod_pal BG2, ADD, WHITE, +2
                end_anim_loop
        anim_speed 2
        loop 33
                blank_frame
                end_loop
        loop 28
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E6: Pearl (bg3) ]

; d0/1923
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HOLY_BG3
        anim_script BG3
        fixed_draw_order
        init_bg3_hscroll_holy
        init_bg3_vscroll_holy
        mod_pal BG3, SUB, WHITE, 31
        move_bg3_here
        update_bg3_scroll_holy
        set_scroll_hdma BG3, 2
        bg_screen_pos BG3, BOTTOM_LEFT
        frame 0
        bg_screen_pos BG3, TOP_RIGHT
        frame 0
        bg_screen_pos BG3, BOTTOM_RIGHT
        frame 0
        loop 8
                mod_pal BG2, SUB, {RED, GREEN}, +2
                frame 0
                end_loop
        loop 32
                mod_pal BG3, SUB, WHITE, -1
                update_bg3_scroll_holy
                frame 0
                end_loop
        loop 225
                update_bg3_scroll_holy
                frame 0
                end_loop
        loop 32
                mod_pal BG3, SUB, WHITE, +1
                update_bg3_scroll_holy
                frame 0
                end_loop
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        bg_screen_pos BG3, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG3, BOTTOM_RIGHT
        blank_frame
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E0: Ice 3 (sprite) ]

; d0/1966
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZAGA_SPRITE
        anim_script SPRITE, 3
        fixed_draw_order
        sfx
        move DOWN, 8
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        frame 8
        frame 9
        mod_pal BG2, ADD, WHITE, 31
        frame 10
        mod_pal BG2, ADD, WHITE, -4
        frame 11
        mod_pal BG2, ADD, WHITE, -4
        frame 12
        mod_pal BG2, ADD, WHITE, -4
        frame 13
        mod_pal BG2, ADD, WHITE, -4
        frame 14
        mod_pal BG2, ADD, WHITE, -4
        frame 15
        mod_pal BG2, ADD, WHITE, -4
        frame 16
        mod_pal BG2, ADD, WHITE, -4
        frame 17
        mod_pal BG2, ADD, WHITE, -4
        frame 18
        frame 19
        frame 20
        frame 21
        frame 22
        anim_speed 2
        blank_frame 3
        realign_to_target_bottom
        move DOWN, 16
        change_anim_layer BG1
        bg_target_draw_order
        mod_pal BG1, SUB, WHITE, 0
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, SPRITE
        loop 16
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        loop 8
                mod_pal BG1, SUB, WHITE, +4
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00C4: Fire 3 (sprite) ]

; d0/19c3
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRAGA_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        loop 5
                move UP_BACK, 32
                end_loop
        jump_thread _d019f0, _d019d5, _d019dd, _d019e6

_d019d5:
        blank_frame
        loop 20
                move DOWN_FORWARD, 8
                frame 1
                end_loop
        end_anim_script

_d019dd:
        blank_frame 2
        loop 20
                move DOWN_FORWARD, 8
                frame 2
                end_loop
        end_anim_script

_d019e6:
        blank_frame 3
        loop 20
                move DOWN_FORWARD, 8
                frame 3
                end_loop
        end_anim_script

_d019f0:
        sfx
        loop 20
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        anim_speed 4
        mod_pal BG2, ADD, RED, 31
        wait_scanline
        color_math {ADD, FIXED_CLR}
        mod_pal BG1, SUB, WHITE, 0
        change_anim_layer BG1
        bg_target_draw_order
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        anim_speed 2
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        move UP, 16
        loop 8
                mod_pal BG1, SUB, WHITE, +4
                mod_pal BG2, ADD, RED, -4
                frame 6
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00ED: Sleep (bg1) ]

; d0/1a21
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLEEP_BG1
        anim_script BG1
        mod_pal BG2, SUB, WHITE, 0
        hide_bg1_thread
        loop 8
                mod_pal BG2, SUB, WHITE, +1
                blank_frame
                end_loop
        loop 129
                blank_frame
                end_loop
        loop 8
                mod_pal BG2, SUB, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A8: Sleep (sprite) ]

; d0/1a38
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLEEP_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move UP, 16
        jump_thread _d01a47, _d01a50, _d01a4e, _d01a4d
_d01a47:
        sfx
        loop 65
                frame 0
                end_loop
_d01a4d:
        end_anim_script

_d01a4e:
        move FORWARD, 8
_d01a50:
        move BACK, 8
        move DOWN, 8
        anim_loop 7
                .repeat 6
                move DOWN, 1
                frame 1
                .endrep
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D6: Slow 2 (bg1) ]

; d0/1a6a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLOW_2_BG1
        anim_script BG1
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D5: Safe (bg1) ]

; d0/1a73
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SAFE_BG1
        anim_script BG1
        fixed_draw_order
        loop 32
                cycle_pal BG1_ANIM, -3, {1, 7}
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                cycle_pal BG1_ANIM, -3, {1, 7}
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A9: Safe (sprite) ]

; d0/1a8a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SAFE_SPRITE
        anim_script SPRITE
        sfx
        loop 65
                blank_frame
                end_loop
        anim_speed 7
        anim_loop 6
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D3: Demi, Quartr, Reflect??? (sprite) ]

; d0/1a99
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DEMI_SPRITE
        anim_script SPRITE
        fixed_draw_order
        jump_hit :+
        end_anim_script
:       move_to_attacker
        calc_vec
        jump_thread _d01aac, _d01acd, _d01ad6, _d01adf
_d01aac:
        sfx
:       update_vec_wave
        frame 3
        move_vec :-, 2
        update_vec_wave
        frame 4
        move UP_FORWARD, 8
        frame 5
        frame 6
        frame 7
        loop 65
                frame 7
                end_loop
        anim_speed 4
        frame 7
        frame 6
        frame 5
        move DOWN_BACK, 8
        frame 4
        frame 3
        frame 2
        frame 1
        frame 0
        end_anim_script

_d01acd:
:       update_vec_wave
        frame 2
        move_vec :-, 2
        update_vec_wave
        end_anim_script

_d01ad6:
:       update_vec_wave
        frame 1
        move_vec :-, 2
        update_vec_wave
        end_anim_script

_d01adf:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A7: Step Mine (bg1) ]

; d0/1ae0
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STEP_MINE_BG1
        anim_script BG1
        move_to_attacker
        bg_attacker_draw_order
        frame 0, 4
        frame 1, 4
        frame 2, 4
        frame 3, 4
        loop 40
                move UP, 4
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0221: Storm (sprite) ]

; d0/1afc
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STORM_SPRITE
        anim_script SPRITE
        target_priority 2
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $021C: Storm (bg1) ]

; d0/1b02
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STORM_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        init_circle {0, 0}, 0, {255, 255}, 128, 0
        frame 0
        hide_bg1_thread
        move_circle_to_attacker
        sfx
        loop 43
                move_circle {-2, 0}
                zoom_circle +2
                cycle_pal BG1_ANIM, 1, {1, 6}
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 49
                move_circle {-2, 0}
                zoom_circle +2
                cycle_pal BG1_ANIM, 1, {1, 6}
                mod_pal BG1, SUB, WHITE, +1
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0220: 7-Flush (bg1) ]

; d0/1b3d
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SEVEN_FLUSH_BG1
        anim_script BG1, 1, BOTTOM
        fixed_draw_order
        hide_bg1_thread
        mod_pal BG2, SUB, WHITE, 0
; red
        loop 16
                mod_pal BG2, SUB, {BLUE, GREEN}, +1
                blank_frame
                end_loop
; magenta
        loop 16
                mod_pal BG2, SUB, GREEN, -1
                blank_frame
                end_loop
; green
        loop 16
                mod_pal BG2, SUB, RED, +1
                blank_frame
                end_loop
; cyan
        loop 16
                mod_pal BG2, SUB, BLUE, -1
                blank_frame
                end_loop
; blue
        loop 16
                mod_pal BG2, SUB, GREEN, +1
                blank_frame
                end_loop
; magenta
        loop 16
                mod_pal BG2, SUB, RED, -1
                blank_frame
                end_loop
; back to normal
        loop 16
                mod_pal BG2, SUB, GREEN, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $021F: 7-Flush (sprite) ]

; d0/1b70
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SEVEN_FLUSH_SPRITE
        anim_script SPRITE, 1, BOTTOM
        anim_priority 0
        sfx
        jump_thread _d01b7f, _d01b85, _d01b8d, _d01ba0
_d01b7f:
        move_rand {0, 15}
        jump _d01b92
_d01b85:
        move_rand {0, 15}
        move FORWARD, 16
        jump _d01b92
_d01b8d:
        move_rand {0, 15}
        move BACK, 16
_d01b92:
        sfx
        anim_loop 12
                .repeat 3
                update_rainbow_pal
                frame 0
                .endrep
                end_anim_loop
_d01ba0:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $021D: H-Bomb (sprite) ]

; d0/1ba1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::H_BOMB_SPRITE
        anim_script SPRITE, 3, CENTER
        loop 47
                blank_frame
                end_loop
        move UP_FORWARD, 16
        loop 2
                move_rand {31, 31}
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                frame 7
                frame 8
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $021E: H-Bomb (bg1) ]

; d0/1bb9
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::H_BOMB_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        hide_bg1_thread
        move_bg1_here
        sfx
        wait_scanline
        mod_pal BG2, ADD, WHITE, 0
        loop 32
                mod_pal BG2, ADD, WHITE, +1
                blank_frame
                end_loop
        wait_scanline
        mode7_flip NONE
        mode7_move {64, 80}
        mode7_move {56, 80}
        loop 4
                mode7_zoom {-64, -64}
                end_loop
        mainscreen_layers SPRITE
        screen_mode 7
        blank_frame
        mainscreen_layers {BG1, SPRITE}
        sprite_priority 0
        loop 96
                mode7_move {0, -1}, {2, 2}
                blank_frame
                end_loop
        sprite_priority 3
        loop 96
                mode7_move {0, -1}, {2, 2}
                blank_frame
                end_loop
        wait_scanline
        mainscreen_layers {BG2, SPRITE}
        screen_mode 1
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
        call _d02ca0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $021B: Chocobop (sprite) ]

; d0/1c1b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHOCOBOP_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        sfx
        jump_thread _d01c26, _d01c2b
_d01c26:
        move DOWN, 5
        jump _d01c31
_d01c2b:
        back_sprite
        move BACK, 32
        move UP, 8
_d01c31:
        loop 8
                move BACK, 32
                end_loop
        loop 64
                move FORWARD, 4
                auto_frame 2, {0, 3}
                frame 0
                end_loop
        loop 8
                move FORWARD, 4
                auto_frame 2, {0, 3}
                move_target FORWARD, 3
                frame 0
                move FORWARD, 4
                auto_frame 2, {0, 3}
                move_target BACK, 3
                frame 0
                end_loop
        loop 48
                move FORWARD, 4
                auto_frame 2, {0, 3}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0218: Revenger (sprite) ]

; d0/1c5c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REVENGER_SPRITE
        anim_script SPRITE
        fixed_draw_order
        sfx
        mod_pal BG2, SUB, WHITE, 0
        loop 16
                mod_pal BG2, SUB, RED, +1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, GREEN, +1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, RED, -1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, BLUE, +1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, GREEN, -1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, RED, +1
                mod_pal BG2, SUB, BLUE, -1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, RED, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0217: Magnitude8 (bg1) ]

; d0/1c91
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MAGNITUDE8_BG1
        anim_script BG1
        set_blank_frame 9               ; uses frame 9 for some reason
        hide_bg1_thread
        sfx
        loop 16
                scroll_bg {1, 0}
                blank_frame
                scroll_bg {-1, 0}
                blank_frame
                end_loop
        loop 33
                scroll_bg {2, 0}
                blank_frame
                scroll_bg {-2, 0}
                blank_frame
                end_loop
        loop 16
                scroll_bg {1, 0}
                blank_frame
                scroll_bg {-1, 0}
                blank_frame
                end_loop
        scroll_bg {0, 0}
        sfx NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0213: Soul Out (sprite) ]

; d0/1cbe
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SOUL_OUT_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_to_attacker
        calc_vec
        vec_offset 0
        sfx PHANTOM
:       auto_frame 2, {0, 4}
        frame 0
        move_vec :-, 6
        jump_thread _d01cd8, _d01ce8, _d01cf4, _d01d00
_d01cd8:
        sfx
        unpause_layer BG1
        loop 16
                move DOWN_FORWARD, 1
                auto_frame 2, {0, 4}
                frame 0
                end_loop
        jump _d01d09
_d01ce8:
        loop 16
                move DOWN_BACK, 1
                auto_frame 2, {0, 4}
                frame 0
                end_loop
        jump _d01d09
_d01cf4:
        loop 16
                move UP_FORWARD, 1
                auto_frame 2, {0, 4}
                frame 0
                end_loop
        jump _d01d09
_d01d00:
        loop 16
                move UP_BACK, 1
                auto_frame 2, {0, 4}
                frame 0
                end_loop
_d01d09:
        loop 33
                auto_frame 2, {0, 4}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0216: Soul Out (bg1) ]

; d0/1d11
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SOUL_OUT_BG1
        anim_script BG1
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        bg_target_draw_order
        target_priority 2
        jump_target _d01d28, _d01d39, _d01d4a, _d01d5b, _d01d6b
_d01d28:
        loop 32
                move FORWARD, 1
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                move FORWARD, 1
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        end_anim_script
_d01d39:
        loop 32
                move FORWARD, 1
                frame 1
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                move FORWARD, 1
                mod_pal BG1, SUB, WHITE, +1
                frame 1
                end_loop
        end_anim_script
_d01d4a:
        loop 32
                move FORWARD, 1
                frame 2
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                move FORWARD, 1
                mod_pal BG1, SUB, WHITE, +1
                frame 2
                end_loop
        end_anim_script
_d01d5b:
        loop 32
                move FORWARD, 1
                frame 3
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                move FORWARD, 1
                mod_pal BG1, SUB, WHITE, +1
                frame 3
                end_loop
_d01d6b:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0211: Shock Wave (sprite) ]

; d0/1d6c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHOCK_WAVE_SPRITE
        anim_script SPRITE, 2, BOTTOM
        anim_priority 0
        move_to_attacker
        calc_vec
        vec_offset 0
        move FORWARD, 40
        jump_thread _d01d85, _d01db7, _d01dc1, _d01dcb, _d01dd5, _d01ddf
_d01d85:
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        unpause_layer BG1
:       sfx
        frame 3
        frame 4
        move_vec :-, 16
        move_to_target
        reset_pos_offset
        move FORWARD, 32
        sfx MAGITEK_BEAM
        anim_speed 5
        frame 3
        frame 4
        frame 5
        frame 6
        target_frame CHAR_FRAME::HIT
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        bg_target_draw_order
        change_anim_layer BG1
        anim_loop 8
                frame 0
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script
_d01db7:
        loop 2
                blank_frame
                end_loop
:       frame 4
        frame 3
        move_vec :-, 16
        end_anim_script
_d01dc1:
        loop 4
                blank_frame
                end_loop
:       frame 3
        frame 2
        move_vec :-, 16
        end_anim_script
_d01dcb:
        loop 6
                blank_frame
                end_loop
:       frame 2
        frame 1
        move_vec :-, 16
        end_anim_script
_d01dd5:
        loop 8
                blank_frame
                end_loop
:       frame 1
        frame 0
        move_vec :-, 16
        end_anim_script
_d01ddf:
        loop 10
                blank_frame
                end_loop
:       frame 0, 2
        move_vec :-, 16
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $020F: Phantasm (sprite) ]

; d0/1de9
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PHANTASM_SPRITE
        anim_script SPRITE, 1, BOTTOM
        loop 82
                blank_frame
                end_loop
        sfx
        anim_loop 11
                frame 0, 2
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0210: Phantasm (bg3) ]

; d0/1df7
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PHANTASM_BG3
        anim_script BG3
        fixed_draw_order
        move_bg3_here
        mod_pal BG2, SUB, WHITE, 0
        sfx SEALED_GATE_THUNDER
        loop 16
                mod_pal BG2, SUB, WHITE, +1
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        mod_pal BG3, SUB, WHITE, 0
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                mod_pal BG3, SUB, WHITE, +2
                frame 0
                end_loop
        loop 8
                mod_pal BG2, SUB, WHITE, +2
                mod_pal BG3, SUB, WHITE, +2
                blank_frame
                end_loop
        loop 32
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        mod_pal BG3, SUB, WHITE, 0
        sfx SECURITY_CHECKPOINT
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                mod_pal BG3, SUB, WHITE, +2
                frame 1
                end_loop
        loop 8
                mod_pal BG2, SUB, WHITE, +2
                mod_pal BG3, SUB, WHITE, +2
                blank_frame
                end_loop
        loop 23
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0215: Zinger (bg1) ]

; d0/1e40
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ZINGER_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        move_bg1_here
        jump_hit :+
        end_anim_script
:       hide_bg1_thread
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        mod_pal BG2, SUB, WHITE, 0
        sfx
        loop 16
                mod_pal BG2, SUB, WHITE, +1
                blank_frame
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                move FORWARD, 1
                blank_frame
                move FORWARD, 1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, WHITE, -1
                blank_frame
                end_loop
        mainscreen_layers {BG2, SPRITE}
        hide_attacker_monster
        sfx NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $020B: Cold Dust (bg1) ]

; d0/1e77
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::COLD_DUST_BG1
        anim_script BG1, 4, BOTTOM
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        bg1_window 1
        anim_loop 6
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $020A: Cold Dust (sprite) ]

; d0/1e87
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::COLD_DUST_SPRITE
        anim_script SPRITE
        jump_thread _d01e96, _d01eb2, _d01eb2, _d01eb2, _d01eb2, _d01eb2
_d01e96:
        sfx
        move_to_attacker
        loop 5
                fixed_draw_order
                attacker_frame CHAR_FRAME::JUMPING_FORWARD
                frame 3
                move FORWARD, 8
                end_loop
        calc_vec_grav_bomb
:       frame 3
        move_vec_grav_bomb :-, 8
        sfx DRAIN
        unpause_layer BG1
        attacker_frame CHAR_FRAME::NONE
        end_anim_script
_d01eb2:
        anim_speed 4
        loop 2
                move_to_first_thread
                frame 3
                frame 2
                frame 1
                frame 0
                end_loop
        move_to_target
        move UP_FORWARD, 16
        loop 8
                blank_frame
                end_loop
        sfx FENIX_DOWN
        anim_speed 6
        loop 5
                move_rand {31, 31}
                frame 4
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0209: Sneeze (sprite) ]

; d0/1ed4
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SNEEZE_SPRITE
        anim_script SPRITE
        move_to_attacker
        sfx
        anim_priority 0
        calc_vec
        vec_offset 0
        cycle_pal SPRITE_ANIM, 1, {1, 7}
:       frame 0
        move_vec :-, 6
        loop 27
                move_target UP, 6
                move_target FORWARD, 4
                move FORWARD, 6
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        hide_target_chars
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0208: N. Cross (bg3) ]

; d0/1ef5
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::N_CROSS_BG3
        anim_script BG3
        hide_bg3_thread
        mod_pal BG2, ADD, BLUE, 0
        loop 8
                mod_pal BG2, ADD, BLUE, +2
                blank_frame
                end_loop
        loop 129
                blank_frame
                end_loop
        loop 8
                mod_pal BG2, ADD, BLUE, -2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0204: Echo Screen, Monster Exit $01: Puff of Smoke (sprite) ]

; d0/1f0c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ECHO_SCREEN_SPRITE
        anim_script SPRITE, 5, CENTER
        match_target_dir
        move UP_FORWARD, 16
        move_rand {31, 31}
        sfx
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        move_rand {31, 31}
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0205: Smoke Bomb (sprite) ]

; d0/1f26
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SMOKE_BOMB_SPRITE
        anim_script SPRITE, 5, CENTER
        match_target_dir
        move UP_FORWARD, 16
        move_rand {31, 31}
        sfx
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        move_rand {31, 31}
        frame 0
        frame 1
        frame 2
        jump_hit :+
        frame 3
        frame 4
        frame 5
        end_anim_script
:       hide_target_chars
        hide_target_monsters
        frame 3
        frame 4
        frame 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0201: Green Cherry (sprite) ]

; d0/1f4b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GREEN_CHERRY_SPRITE
        anim_script SPRITE, 4, BOTTOM
        anim_priority 0
        sfx
        anim_loop 8
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0202: Remedy item (sprite) ]

; d0/1f56
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REMEDY_ITEM_SPRITE
        anim_script SPRITE, 1, BOTTOM
        anim_priority 0
        move FORWARD, 16
        jump_thread _d01f69, _d01f6b, _d01f6b, _d01f6b, _d01f6b, _d01f6b
_d01f69:
        sfx
_d01f6b:
        call _d01f78
        call _d01f78
        call _d01f78
        call _d01f78
        end_anim_script

_d01f78:
        move_rand {31, 0}
        update_rainbow_pal
        frame 0
        update_rainbow_pal
        frame 0
        update_rainbow_pal
        frame 1
        update_rainbow_pal
        frame 1
        update_rainbow_pal
        frame 2
        update_rainbow_pal
        frame 2
        update_rainbow_pal
        frame 3
        update_rainbow_pal
        frame 3
        loop 10
                move UP, 16
                update_rainbow_pal
                frame 3
                update_rainbow_pal
                frame 3
                end_loop
        move DOWN, 160
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0200: Antidote, Soft (sprite) ]

; d0/1fa9
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ANTIDOTE_SPRITE
        anim_script SPRITE, 5, CENTER
        anim_priority 0
        match_target_dir
        move UP_FORWARD, 16
        loop 2
                sfx
                move_rand {31, 31}
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0203: Revivify, Eyedrop (sprite) ]

; d0/1fbf
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EYEDROP_SPRITE
        anim_script SPRITE, 1, BOTTOM
        jump_thread _d01fce, _d02009, _d0203a, _d02083, _d020cc, _d02115

_d01fce:
        sfx
        unpause_layer BG1
        move UP, 64
        loop 32
                move DOWN, 2
                frame 0
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move FORWARD, 1
                frame 0
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move FORWARD, 1
                frame 1
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move FORWARD, 1
                frame 2
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move FORWARD, 1
                frame 3
                end_loop
        end_anim_script

_d02009:
        loop 32
                blank_frame
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move BACK, 1
                frame 0
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move BACK, 1
                frame 1
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move BACK, 1
                frame 2
                end_loop
        loop 8
                update_eyedrop 32, 4, 128
                move BACK, 1
                frame 3
                end_loop
        end_anim_script

_d0203a:
        loop 32
                blank_frame
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_FORWARD, 1
                frame 0
                update_eyedrop 32, 4, 128
                frame 0
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_FORWARD, 1
                frame 1
                update_eyedrop 32, 4, 128
                frame 1
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_FORWARD, 1
                frame 2
                update_eyedrop 32, 4, 128
                frame 2
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_FORWARD, 1
                frame 3
                update_eyedrop 32, 4, 128
                frame 3
                end_loop
        end_anim_script

_d02083:
        loop 32
                blank_frame
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_BACK, 1
                frame 0
                update_eyedrop 32, 4, 128
                frame 0
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_BACK, 1
                frame 1
                update_eyedrop 32, 4, 128
                frame 1
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_BACK, 1
                frame 2
                update_eyedrop 32, 4, 128
                frame 2
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move DOWN_BACK, 1
                frame 3
                update_eyedrop 32, 4, 128
                frame 3
                end_loop
        end_anim_script

_d020cc:
        loop 32
                blank_frame
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_FORWARD, 1
                frame 0
                update_eyedrop 32, 4, 128
                frame 0
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_FORWARD, 1
                frame 1
                update_eyedrop 32, 4, 128
                frame 1
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_FORWARD, 1
                frame 2
                update_eyedrop 32, 4, 128
                frame 2
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_FORWARD, 1
                frame 3
                update_eyedrop 32, 4, 128
                frame 3
                end_loop
        end_anim_script

_d02115:
        loop 32
                blank_frame
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_BACK, 1
                frame 0
                update_eyedrop 32, 4, 128
                frame 0
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_BACK, 1
                frame 1
                update_eyedrop 32, 4, 128
                frame 1
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_BACK, 1
                frame 2
                update_eyedrop 32, 4, 128
                frame 2
                end_loop
        loop 4
                update_eyedrop 32, 4, 128
                move UP_BACK, 1
                frame 3
                update_eyedrop 32, 4, 128
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01FF: Fenix Down (sprite) ]

; d0/215e
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FENIX_DOWN_SPRITE
        anim_script SPRITE, 5, CENTER
        move FORWARD, 16
        jump_thread _d02184, _d02199, _d02199, _d02199, _d02199, _d0216f
_d0216f:
        move_rand {31, 15}
        move UP, 25
        call _d021ac
        call _d021ac
        call _d021ac
        frame 5
        frame 6
        frame 7
        frame 8
        sfx NONE
        end_anim_script
_d02184:
        sfx
        move_rand {31, 15}
        move UP, 25
        call _d021ac
        call _d021ac
        call _d021ac
        frame 5
        frame 6
        frame 7
        frame 8
        end_anim_script
_d02199:
        move_rand {31, 15}
        move UP, 25
        call _d021ac
        call _d021ac
        call _d021ac
        frame 5
        frame 6
        frame 7
        frame 8
        end_anim_script

_d021ac:
        move DOWN, 1
        frame 3
        move DOWN, 1
        frame 2
        move DOWN, 1
        frame 1
        move DOWN, 1
        frame 0
        move DOWN, 1
        frame 0
        move DOWN, 1
        frame 1
        move DOWN, 1
        frame 2
        move DOWN, 1
        frame 3
        move DOWN, 1
        frame 4
        move DOWN, 1
        frame 4
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0206: Megalixir (sprite) ]

; d0/21cb
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MEGALIXIR_SPRITE
        anim_script SPRITE
        anim_priority 0
        reset_ellipse
        jump_thread _d021da, _d02205, _d02214, _d02214
_d021da:
        sfx
        move_ellipse 40, 0
        loop 65
                move_ellipse 0, -4
                update_ellipse_priority
                auto_frame 4, {0, 8}
                update_rainbow_pal
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01FE: Elixir (sprite) ]

; d0/21ee
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ELIXIR_SPRITE
        anim_script SPRITE
        anim_priority 0
        reset_ellipse
        jump_thread _d021fd, _d02205, _d02214, _d02214
_d021fd:
        sfx
        move_ellipse 40, 0
        jump _d02208
_d02205:
        move_ellipse 40, 128
_d02208:
        loop 65
                move_ellipse 0, -4
                update_ellipse_priority
                auto_frame 4, {0, 8}
                frame 0
                end_loop
_d02214:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0207: X-Potion, X-Ether, Revivify, Eyedrop (bg3) ]

; d0/2215
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::X_POTION_BG3
        anim_script BG3
        hide_bg3_thread
        fixed_draw_order
        wait_scanline
        color_math {ADD, FIXED_CLR}, BG1
        loop 65
                wait_scanline
                update_rainbow_gradient 0
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 3
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 6
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 10
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 14
                blank_frame
                end_loop
        reset_gradient
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01FD: X-Potion (sprite) ]

; d0/2251
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::X_POTION_SPRITE
        anim_script SPRITE, 5, CENTER
        jump_thread _d0225c, _d0225c, _d0225c, _d02273
_d0225c:
        match_target_dir
        move UP_FORWARD, 16
        loop 2
                move_rand {31, 31}
                sfx
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                move DOWN_BACK, 8
                frame 6
                frame 7
                move UP_FORWARD, 8
                end_loop
_d02273:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01FC: Potion, Ether (sprite) ]

; d0/2274
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::POTION_SPRITE
        anim_script SPRITE, 5, CENTER
        anim_priority 0
        match_target_dir
        move UP_FORWARD, 16
        jump_thread _d02284, _d02284, _d02284, _d02297
_d02284:
        loop 2
                move_rand {31, 31}
                sfx
                frame 0
                frame 1
                move DOWN_BACK, 8
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                move UP_FORWARD, 8
                end_loop
_d02297:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01FB: Tonic, Tincture (sprite) ]

; d0/2298
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TONIC_SPRITE
        anim_script SPRITE, 5, CENTER
        anim_priority 0
        match_target_dir
        move UP_FORWARD, 16
        loop 2
                move_rand {31, 31}
                sfx
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01FA: Inviz Edge (bg1) ]

; d0/22af
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::INVIZ_EDGE_BG1
        anim_script BG1
        jump_step :+
        call _d07067
:       jump _d048f5

; ------------------------------------------------------------------------------

; [ Animation Script $01F8: Shadow Edge (sprite) ]

; d0/22b9
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHADOW_EDGE_SPRITE
        anim_script SPRITE
        use_8x8_bg1_tiles
        reset_ellipse
        jump_thread _d022c8, _d022d9, _d022df, _d022e5
_d022c8:
        wait_scanline
        color_math {ADD, HALF, SUBSCREEN}, BG1, BG2
        jump_step :+
        call _d07019
:       move_ellipse 32, 0
        jump _d022f0
_d022d9:
        move_ellipse 32, 64
        jump _d022e8
_d022df:
        move_ellipse 32, 128
        jump _d022e8
_d022e5:
        move_ellipse 32, -64

; this seems like a mistake, why would it jump to the middle of a loop?
_d022e8:
        jump_step :+
        loop 8
                move FORWARD, 3
:               blank_frame
                end_loop
_d022f0:
        jump_target _d022fb, _d02307, _d02313, _d0231f, _d02306
_d022fb:
        anim_sprite_pal 4
        loop 129
                move_ellipse 0, -4
                update_ellipse_priority
                frame 0
                end_loop
_d02306:
        end_anim_script
_d02307:
        anim_sprite_pal 5
        loop 129
                move_ellipse 0, -4
                update_ellipse_priority
                frame 1
                end_loop
        end_anim_script
_d02313:
        anim_sprite_pal 6
        loop 129
                move_ellipse 0, -4
                update_ellipse_priority
                frame 2
                end_loop
        end_anim_script
_d0231f:
        anim_sprite_pal 7
        loop 129
                move_ellipse 0, -4
                update_ellipse_priority
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F9: Bolt Edge (bg3) ]

; d0/232b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOLT_EDGE_BG3
        anim_script BG3
        jump_step :+
        loop 8
                blank_frame
                end_loop
:       move_bg3_here
        loop 13
                blank_frame
                end_loop
        anim_loop 9
                frame 0, 3
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F7: Bolt Edge (bg1) ]

; d0/2340
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOLT_EDGE_BG1
        anim_script BG1
        jump_step :+
        call _d07067
:       sfx
        move_bg1_here
        anim_loop 9
                frame 0, 3
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F5: Water Edge (sprite) ]

; d0/2352
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WATER_EDGE_SPRITE
        anim_script SPRITE
        jump_step :+
        loop 8
                blank_frame
                end_loop
:       mod_pal BG2, ADD, BLUE, 0
        loop 8
                mod_pal BG2, ADD, BLUE, +2
                blank_frame
                end_loop
        move_xy {128, 72}
        loop 8
                move BACK, 32
                end_loop
        loop 97
                move_rand {11, 3}
                move FORWARD, 4
                frame 0
                end_loop
        loop 8
                mod_pal BG2, ADD, BLUE, -2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F6: water edge (bg1) ]

; d0/237b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WATER_EDGE_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        jump_step :+
        call _d07067
:       move_bg1_here
        sfx
        loop 8
                move BACK, 32
                end_loop
        loop 97
                move_rand {11, 3}
                move FORWARD, 4
                frame 0
                end_loop
        sfx NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0289: Water Edge (bg1) ]

; this script is not present in japanese version

.if LANG_EN

; d0/2399
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WATER_EDGE_ALT_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        jump_step :+
        call _d07067
:       move_bg1_here
        sfx
        loop 8
                move BACK, 32
                end_loop
        loop 97
                move_rand {11, 3}
                move FORWARD, 4
                frame 0
                end_loop
        sfx NONE
        jump_step :+
        call _d0708e
:       end_anim_script

.endif

; ------------------------------------------------------------------------------

; [ Animation Script $01F4: Fire Skean (bg1) ]

; d0/23bc
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_SKEAN_BG1
        anim_script BG1
        fixed_draw_order
        jump_step :+
        call _d07067
:       sfx
        mod_pal BG2, SUB, {GREEN, BLUE}, 0
        loop 8
                mod_pal BG2, SUB, {GREEN, BLUE}, +2
                blank_frame
                end_loop
        move_bg1_here
        anim_speed 4
        sprite_priority 2
        anim_loop 13
                frame 0
                end_anim_loop
        loop 8
                mod_pal BG2, SUB, {GREEN, BLUE}, -2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01DB: TigerBreak (sprite) ]

; d0/23e0
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TIGERBREAK_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_to_attacker
        move DOWN, 8
        attacker_priority 0
        calc_vec_char
:       frame 0
        move_vec_char :-, 8
        attacker_priority 3
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 32
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01CC: TigerBreak (bg1) ]

; d0/23fd
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TIGERBREAK_BG1
        anim_script BG1
        move_to_attacker
        calc_vec
        move DOWN, 8
        sfx STEAL
        vec_offset 0
:       frame 0
        move_vec_arc :-, 8
        sfx
        mod_pal BG2, ADD, WHITE, 31
        loop 8
                mod_pal BG2, ADD, WHITE, -2
                move_target FORWARD, 4
                blank_frame
                mod_pal BG2, ADD, WHITE, -2
                blank_frame
                end_loop
        loop 4
                move_target BACK, 8
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01E7: Evil Toot (sprite) ]

; d0/2421
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EVIL_TOOT_SPRITE
        anim_script SPRITE
        fixed_draw_order
        anim_priority 0
        jump_dir _d0242d, _d02434
_d0242d:
        move_xy {248, 96}
        jump _d02438
_d02434:
        move_xy {8, 96}
_d02438:
        jump_thread _d0243f, _d02456, _d02467
_d0243f:
        sfx
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        loop 129
                move FORWARD, 2
                update_evil_toot 32, 4, 0
                update_vec_wave_narrow 4
                frame 0
                end_loop
        end_anim_script
_d02456:
        loop 129
                move UP, 1
                move FORWARD, 2
                update_evil_toot 32, 4, 0
                update_vec_wave_narrow 4
                frame 1
                end_loop
        end_anim_script
_d02467:
        loop 129
                move DOWN, 1
                move FORWARD, 2
                update_evil_toot 32, 4, 0
                update_vec_wave_narrow 4
                frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F3: Fader (bg1) ]

; d0/2478
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PHANTOM_BG1
        anim_script BG1
        sprite_priority 2
        fixed_draw_order
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG2, SUB, WHITE, 0
        loop 8
                mod_pal BG2, SUB, WHITE, +1
                blank_frame
                end_loop
        jump_dir _d0248e, _d02495
_d0248e:
        move_xy {208, 128}
        jump _d02499
_d02495:
        move_xy {48, 128}
_d02499:
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                move UP_FORWARD, 1
                update_evil_toot 32, 4, 0
                frame 0
                end_loop
        loop 65
                move UP_FORWARD, 1
                update_evil_toot 32, 4, 0
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                move UP_FORWARD, 1
                update_evil_toot 32, 4, 0
                frame 0
                end_loop
        loop 8
                mod_pal BG2, SUB, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F0: Tri-Dazer (bg1) ]

; d0/24c7
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRITOCH_BG1
        anim_script BG1
        move_bg1_here
        sprite_priority 2
        loop 72
                blank_frame
                end_loop
        mod_pal BG2, ADD, BLUE, 0
        loop 8
                mod_pal BG2, ADD, BLUE, +1
                blank_frame
                end_loop
        anim_speed 7
        anim_loop 14
                frame 0
                end_anim_loop
        anim_speed 2
        loop 8
                mod_pal BG2, ADD, BLUE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F1: Tri-Dazer (bg3) ]

; d0/24e8
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRITOCH_BG3
        anim_script BG3
        move_bg3_here
        loop 80
                blank_frame
                end_loop
        anim_speed 7
        anim_loop 9
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01F2: Tri-Dazer (sprite) ]

_d024f7:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRITOCH_SPRITE
        anim_script SPRITE
        fixed_draw_order
        call _d054b8
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        jump_dir _d0250a, _d02511
_d0250a:
        move_xy {208, 72}
        jump _d02515
_d02511:
        move_xy {48, 72}
_d02515:
        call _d04ccb
        sfx
        loop 65
                frame 0
                end_loop
        call _d054e7
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01EF: True Edge (bg3) ]

_d02522:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAIDEN_BG3
        anim_script BG3
        move_bg3_here
        loop 32
                blank_frame
                end_loop
        sfx THUNDARA
        anim_speed 3
        anim_loop 7
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01EC: Metamorph (sprite) ]

_d02533:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAGNAROK_SPRITE
        anim_script SPRITE
        jump_battle_type _d0253d, _d02544, _d0254b
_d0253d:
        move_xy {208, 80}
        jump _d0254f
_d02544:
        move_xy {48, 80}
        jump _d0254f
_d0254b:
        move_xy {128, 80}
_d0254f:
        loop 5
                move UP, 32
                end_loop
        loop 13
                move DOWN, 12
                frame 0
                end_loop
        loop 65
                frame 1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01ED: Metamorph (bg3) ]

; d0/255f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAGNAROK_BG3
        anim_script BG3
        jump_battle_type _d02569, _d02570, _d02577
_d02569:
        move_xy {208, 96}
        jump _d0257b
_d02570:
        move_xy {48, 96}
        jump _d0257b
_d02577:
        move_xy {128, 96}
_d0257b:
        loop 13
                blank_frame
                end_loop
        anim_speed 4
        anim_loop 9
                frame 0
                end_anim_loop
        anim_loop 9
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01EE: Metamorph (bg1) ]

; d0/258a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAGNAROK_BG1
        anim_script BG1
        fixed_draw_order
        call _d05516
        sfx
        hide_bg1_thread
        mod_pal BG2, SUB, WHITE, 0
        loop 8
                mod_pal BG2, SUB, {BLUE, GREEN}, +1
                blank_frame
                end_loop
        loop 21
                blank_frame
                end_loop
        mod_pal BG1, ADD, WHITE, 31
        loop 32
                mod_pal BG1, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 25
                blank_frame
                end_loop
        loop 8
                mod_pal BG2, SUB, {BLUE, GREEN}, -1
                blank_frame
                end_loop
        call _d05549
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01EA: Earth Wall (sprite) ]

; d0/25b7
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GOLEM_SPRITE
        anim_script SPRITE, 4, CENTER
        loop 9
                blank_frame
                end_loop
        jump_battle_type _d025c5, _d025cc, _d025d3
_d025c5:
        move_xy {208, 80}
        jump _d025d7
_d025cc:
        move_xy {48, 80}
        jump _d025d7
_d025d3:
        move_xy {128, 80}
_d025d7:
        call _d025de
        call _d025de
        end_anim_script

_d025de:
        move_rand {7, 3}
        anim_loop 8
                frame 0
                move BACK, 8
                end_anim_loop
        move FORWARD, 64
        return

; ------------------------------------------------------------------------------

; [ Animation Script $01EB: Earth Wall (bg1) ]

; d0/25ec
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GOLEM_BG1
        anim_script BG1
        fixed_draw_order
        call _d05516
        sfx
        jump_battle_type _d025fd, _d02604, _d0260b
_d025fd:
        move_xy {208, 112}
        jump _d0260f
_d02604:
        move_xy {48, 112}
        jump _d0260f
_d0260b:
        move_xy {128, 112}
_d0260f:
        mod_pal BG1, ADD, WHITE, 31
        mod_pal SPRITE, ADD, WHITE, 31
        loop 32
                mod_pal BG1, ADD, WHITE, -1
                mod_pal SPRITE, ADD, WHITE, -1
                frame 0
                end_loop
        loop 65
                frame 0
                end_loop
        call _d05549
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01E8: Cat Rain (sprite) ]

; d0/2623
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STRAY_SPRITE
        anim_script SPRITE
        anim_priority 0
        loop 72
                blank_frame
                end_loop
        jump _d03f39

; ------------------------------------------------------------------------------

; [ Animation Script $01E9: Cat Rain (bg1) ]

; d0/262e
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STRAY_BG1
        anim_script BG1
        fixed_draw_order
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        move_xy {128, 88}
        loop 8
                move BACK, 32
                end_loop
        sfx STRAY_CAT
        loop 16
                move FORWARD, 4
                update_eyedrop 64, 8, 128
                frame 0
                end_loop
        sfx STRAY_CAT
        loop 16
                move FORWARD, 4
                update_eyedrop 64, 8, 128
                frame 0
                end_loop
        sfx STRAY_CAT
        loop 16
                move FORWARD, 4
                update_eyedrop 64, 8, 128
                frame 0
                end_loop
        sfx STRAY_CAT
        loop 16
                move FORWARD, 4
                update_eyedrop 64, 8, 128
                frame 0
                end_loop
        sfx STRAY_CAT
        mod_pal BG2, ADD, WHITE, 31
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                update_eyedrop 112, 4, 128
                move FORWARD, 4
                frame 0
                end_loop
        loop 32
                frame 0
                update_eyedrop 112, 4, 128
                move FORWARD, 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01E6: Charm (sprite) ]

; d0/2692
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHARM_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_to_attacker
        calc_vec
        jump_thread _d0216a1, _d026ac, _d026b5, _d026be
_d0216a1:
        sfx
:       update_vec_wave
        frame 0
        move_vec :-, 2
        update_vec_wave
        end_anim_script
_d026ac:
:       update_vec_wave
        frame 1
        move_vec :-, 2
        update_vec_wave
        end_anim_script
_d026b5:
:       update_vec_wave
        frame 2
        move_vec :-, 2
        update_vec_wave
        end_anim_script
_d026be:
:       update_vec_wave
        frame 3
        move_vec :-, 2
        update_vec_wave
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused ??? (bg1) ]

; d0/26c7
        anim_script BG1, 1, SCREEN
        sprite_priority 2
        move_bg1_here
        wait_scanline
        init_moon_song_effect
        color_math {ADD, SUBSCREEN}, BG3, {BG1, SPRITE}
        set_scroll_hdma BG1, 0
        update_moon_song_effect
        blank_frame
        frame 0
        fixed_draw_order
        loop 127
                update_moon_song_effect
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        disable_char_pal_update
        mod_pal BG3, ADD, WHITE, 31
        mod_pal BG2, ADD, WHITE, 31
        mod_pal MONSTER, ADD, WHITE, 31
        mod_pal CHAR, ADD, WHITE, 31
        mod_pal BG3, ADD, WHITE, 31
        mainscreen_layers {BG2, SPRITE}
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                mod_pal MONSTER, ADD, WHITE, -1
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        enable_char_pal_update
        wait_scanline
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused ??? (bg3) ]

; d0/270d
        anim_script BG3, 1, SCREEN
        fixed_draw_order
        move_bg3_here
        circle_shape VERT_OVAL
        init_circle {176, 48}, 0, {255, 255}, 128, 0
        frame 0
        hide_bg3_thread
        loop 31
                zoom_circle +2
                update_circle
                frame 0
                end_loop
        loop 98
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01E2: Shrapnel (sprite) ]

; d0/272f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHRAPNEL_SPRITE
        anim_script SPRITE
        reset_ellipse
        sfx
        move_ellipse 32, 0
        loop 65
                auto_frame 2, {0, 4}
                move_ellipse 0, -4
                update_ellipse_priority
                frame 0
                end_loop
        reset_frame_offset
        sfx CLAW
        bg_target_draw_order
        change_anim_layer BG1
        target_frame CHAR_FRAME::HIT
        anim_loop 13
                move_target FORWARD, 3
                frame 0
                move_target BACK, 3
                frame 0
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01DF: Mirager (bg1) ]

; d0/275c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MIRAGER_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        hide_bg1_thread
        loop 16
                move FORWARD, 3
                blank_frame
                move BACK, 3
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01DE: Mirager (sprite) ]

; d0/276c
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MIRAGER_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        save_attacker_char_pos
        enable_echo_sprites 1
        sfx STEAL
        attacker_priority 3
        move_to_attacker
        calc_vec_char
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_char :-, 8, 32
        reset_char_vec_offset
        fixed_draw_order
        sfx
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 3
                move_attacker FORWARD, 8
                blank_frame
                end_loop
        unpause_layer BG1
        mod_pal BG2, ADD, WHITE, 31
        loop 16
                mod_pal BG2, ADD, WHITE, -2
                blank_frame
                end_loop
        sfx NONE
        reset_char_vec_offset
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        vec_to_attacker_char_pos
        calc_vec_char
:       blank_frame
        move_vec_char :-, 8, 32
        attacker_frame CHAR_FRAME::NONE
        restore_attacker_char_pos
        disable_echo_sprites 1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01DC: SabreSoul (bg1) ]

; d0/27b0
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SABRESOUL_BG1
        anim_script BG1, 1, FRONT_NEAR
        move_bg1_here
        hide_bg1_thread
        wait_scanline
        mainscreen_layers {BG2, SPRITE}
        sfx STEAL
        move_to_attacker
        calc_vec_char
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_char :-, 8, 32
        sfx
        fixed_draw_order
        move_bg1_here
        blank_frame
        mainscreen_layers {BG1, BG2, SPRITE}
        target_priority 2
        mod_pal BG2, ADD, WHITE, 31
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 16
                mod_pal BG2, ADD, WHITE, -2
                blank_frame
                end_loop
        loop 10
                move UP, 4
                blank_frame
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 16
                move UP, 4
                mod_pal BG1, SUB, WHITE, +2
                blank_frame
                end_loop
        normal_draw_order
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 32
        wait_scanline
        move_bg1_here
        mainscreen_layers {BG2, SPRITE}
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01DA: Star Prism (bg1) ]

; d0/2803
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STAR_PRISM_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        hide_bg1_thread
        fixed_draw_order
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 8
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        wait_scanline
        color_math FIXED_CLR, BG1
        loop 65
                wait_scanline
                update_rainbow_gradient 0
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 3
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 6
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 10
                blank_frame
                end_loop
        loop 8
                wait_scanline
                update_rainbow_gradient 14
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 8
                move_attacker BACK, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        reset_gradient
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01CB: Star Prism (sprite) ]

; d0/2855
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STAR_PRISM_SPRITE
        anim_script SPRITE, 1, BOTTOM
        anim_priority 2
        reset_ellipse
        jump_thread _d02868, _d02870, _d02876, _d0287c, _d028bc, _d028bc
_d02868:
        sfx
        move_ellipse 64, 0
        jump _d0287f
_d02870:
        move_ellipse 64, 64
        jump _d0287f
_d02876:
        move_ellipse 64, 128
        jump _d0287f
_d0287c:
        move_ellipse 64, -64
_d0287f:
        loop 65
                move_ellipse 0, -4
                update_ellipse_priority
                frame 0
                end_loop
        loop 8
                move_ellipse 0, -3
                update_ellipse_priority
                frame 0
                end_loop
        loop 8
                move_ellipse 0, -2
                update_ellipse_priority
                frame 0
                end_loop
        loop 8
                move_ellipse 0, -1
                update_ellipse_priority
                frame 0
                end_loop
        sfx BLIZZARD
        frame 0, 2
        move UP, 16
        frame 1, 2
        move UP, 16
        frame 2, 2
        move UP, 16
        frame 3, 2
        move UP, 16
        loop 16
                frame 4, 2
                move UP, 16
                end_loop
_d028bc:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01CD: Back Blade (bg3) ]

_d028bd:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BACK_BLADE_BG3
        anim_script BG3, 1, BOTTOM
        sfx STEAL
        move_to_attacker
        calc_vec_char
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_char :-, 8, 32
        fixed_draw_order
        sfx
        disable_char_pal_update
        blank_frame
        mod_pal BG2, SUB, WHITE, 31
        mod_pal MONSTER, SUB, WHITE, 31
        mod_pal CHAR, SUB, WHITE, 31
        anim_loop 8
                frame 0
                end_anim_loop
        loop 8
                mod_pal BG2, SUB, WHITE, -4
                blank_frame
                mod_pal MONSTER, SUB, WHITE, -4
                mod_pal CHAR, SUB, WHITE, -4
                blank_frame
                end_loop
        enable_char_pal_update
        normal_draw_order
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 32
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C8: (sprite) ]

_d028f9:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_456
        anim_script SPRITE, 1, FRONT_NEAR
        sfx STEAL
        move_to_attacker
        calc_vec_char
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_char :-, 6, 32
        fixed_draw_order
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 10
        move_if_flipped FORWARD, 2
        sfx
        .repeat 3
        call _d07f31
        .endrep
        sfx NONE
        normal_draw_order
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -6, 32
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C7: X-Meteo (bg1) ]

_d0292d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::X_METEO_BG1
        anim_script SPRITE
        call _d07067
        loop 8
                move UP_BACK, 32
                end_loop
        sfx
        loop 32
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        loop 8
                move_target FORWARD, 3
                move DOWN_FORWARD, 8
                frame 0
                move_target BACK, 3
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        loop 24
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        call _d0708e
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01CA: RoyalShock (bg1) ]

_d02956:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ROYALSHOCK_BG1
        anim_script BG1, 1, BOTTOM
        call _d07067
        sfx
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 8
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        mod_pal BG2, ADD, WHITE, 31
        anim_loop 10
                mod_pal BG2, ADD, WHITE, -2
                frame 0
                end_anim_loop
        set_blank_frame 9               ; uses frame 9 for some reason
        loop 11
                move UP, 16
                mod_pal BG2, ADD, WHITE, -2
                blank_frame
                end_loop
        call _d0708e
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C9: Riot Blade (sprite) ]

_d0297e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RIOT_BLADE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        anim_priority 0
        move_to_attacker
        move FORWARD, 24
        calc_vec
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        sfx
        vec_offset 0
:       auto_frame 2, {0, 5}
        frame 0
        move_vec_arc :-, 8
        attacker_frame CHAR_FRAME::NONE
        move_target FORWARD, 8
:       auto_frame 2, {0, 5}
        frame 0
        move_vec_arc :-, 8
        reset_frame_offset
        loop 5
                move_target FORWARD, 1
                move FORWARD, 1
                blank_frame
                move_target BACK, 1
                move BACK, 1
                blank_frame
                end_loop
        move_target BACK, 8
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0062: (sprite) ]

_d029b4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_98
        anim_script SPRITE
        loop 7
                blank_frame
                end_loop
        sfx
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C6: ShadowFang (bg1) ]

_d029bd:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHADOWFANG_BG1
        anim_script BG1, 1, BOTTOM
        save_attacker_dir
        sfx STEAL
        anim_draw_order RIGHT_HAND
        move_to_attacker
        calc_vec
        vec_offset 0
        move_if_flipped FORWARD, 2
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_jump :-, 8
        attacker_frame CHAR_FRAME::NEAR_FATAL
        sfx
        loop 16
                blank_frame
                end_loop
        fixed_draw_order
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        anim_loop 15
                move_attacker UP_FORWARD, 8
                frame 0
                end_anim_loop
        loop 5
                move_attacker UP_FORWARD, 8
                blank_frame
                end_loop
        loop 20
                move_attacker BACK, 8
                end_loop
        restore_attacker_dir
        clear_pos_offset
        hide_attacker_char
        normal_draw_order
        blank_frame 2
        fixed_draw_order
        show_attacker_char
        loop 20
                move_attacker UP, 8
                end_loop
        loop 20
                move_attacker DOWN, 8
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 9
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move_to_attacker_char
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C5: Meteo (sprite) ]

_d02a1a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::METEO_SPRITE
        anim_script BG1, 1, BOTTOM
        fixed_draw_order
        move UP_FORWARD, 16
        jump_thread _d02a37, _d02a29, _d02a39, _d02a42

_d02a29:
        move UP, 32
        back_sprite
        call _d02a43
        call _d02a43
        call _d02a43
        end_anim_script

_d02a37:
        sfx
_d02a39:
        call _d02a43
        call _d02a43
        call _d02a43
_d02a42:
        end_anim_script

_d02a43:
        move_rand {31, 31}
        loop 5
                move UP_BACK, 32
                end_loop
        loop 20
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        anim_loop 5
                frame 1, 3
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        return

; ------------------------------------------------------------------------------

; [ Animation Script $01C4: Tentacle (sprite) ]

_d02a5e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TENTACLE_SPRITE
        anim_script SPRITE, 1, BOTTOM
        move BACK, 32
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        sfx
        loop 4
                move FORWARD, 8
                frame 0
                end_loop
        loop 4
                move BACK, 8
                frame 0
                end_loop
        loop 8
                move FORWARD, 1
                frame 0
                move BACK, 1
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C3: Love Token (sprite) ]

_d02a80:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LOVE_TOKEN_SPRITE
        anim_script SPRITE, 4, CENTER
        fixed_draw_order
        sfx
        move UP_FORWARD, 16
        move_rand {31, 31}
        anim_loop 10
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C1:  ]

_d02a90:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_449
        anim_script BG1, 1, BOTTOM
        move DOWN, 16
        fixed_draw_order
        mod_pal BG1, SUB, WHITE, 31
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                hide_bg1_thread
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        loop 16
                mod_pal BG2, ADD, WHITE, -2
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01C0: Heart Burn (sprite) ]

_d02aca:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HEART_BURN_SPRITE
        anim_script SPRITE, 5, BOTTOM
        sfx
        move DOWN, 1
        frame 10
        frame 9
        frame 8
        frame 7
        frame 6
        frame 5
        move FORWARD, 8
        frame 4
        frame 3
        frame 2
        frame 1
        frame 0, 6
        frame 1
        frame 2
        frame 3
        frame 4
        move BACK, 8
        frame 5
        frame 6
        frame 7
        frame 8
        frame 9
        frame 10
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01BE: Mute (sprite) ]

_d02aef:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MUTE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        anim_priority 0
        move UP_FORWARD, 16
        jump_thread _d02b17, _d02b00, _d02b16, _d02b16
_d02b00:
        sfx
        move_rand {31, 31}
        anim_speed 4
        anim_loop 5
                frame 0
                end_anim_loop
        sfx
        move_rand {31, 31}
        anim_speed 4
        anim_loop 5
                frame 0
                end_anim_loop
_d02b16:
        end_anim_script

_d02b17:
        sfx
        move_rand {31, 31}
        anim_speed 4
        anim_loop 5
                frame 0
                end_anim_loop
        move_rand {31, 31}
        sfx
        anim_speed 4
        anim_loop 5
                frame 0
                end_anim_loop
        loop 5
                blank_frame
                end_loop
        sfx SECURITY_CHECKPOINT
        move DOWN_BACK, 16
        move_rand {0, 0}
        anim_speed 2
        bg_target_draw_order
        change_anim_layer BG1
        jump_dir _d02b44, _d02b49
_d02b44:
        loop 33
                frame 0
                end_loop
        end_anim_script

_d02b49:
        loop 33
                frame 1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01BC: Event Animation $01: Vargas' Blizzard Fist (bg1) ]

_d02b4e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZARD_FIST_BG1
        anim_script BG1
        sprite_priority 2
        fixed_draw_order
        move_bg1_here
        mod_pal BG1, SUB, WHITE, 31
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                hide_bg1_thread
                end_loop
        loop 129
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01BD: Event Animation $01: Vargas' Blizzard Fist (bg3) ]

_d02b7a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZARD_FIST_BG3
        anim_script BG3
        move_bg3_here
        wait_scanline
        set_scroll_hdma BG3, 2
        mod_pal BG3, SUB, WHITE, 31
        loop 32
                mod_pal BG3, SUB, WHITE, -1
                rand_bg3_hscroll 1
                frame 0
                hide_bg3_thread
                end_loop
        loop 129
                rand_bg3_hscroll 1
                frame 0
                rand_bg3_hscroll 1
                frame 0
                end_loop
        loop 32
                mod_pal BG3, SUB, WHITE, +1
                rand_bg3_hscroll 1
                frame 0
                end_loop
        wait_scanline
        reset_scroll_hdma BG3
        set_scroll_hdma BG3, 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B9: 50 Gs (sprite) ]

_d02baa:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIFTY_GS_SPRITE
        anim_script SPRITE
        loop 33
                blank_frame
                end_loop
        loop 65
                cycle_pal SPRITE_ANIM, 3, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01BA: 50 Gs (bg1) ]

_d02bb8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIFTY_GS_BG1
        anim_script BG1
        move_bg1_here
        sfx
        wait_scanline
        set_scroll_hdma BG1, 6
        bg1_tilemap_location $6100
        bg1_gfx_location $1000
        init_scroll_wave BG1, 4, 1, VERT
        init_scroll_wave BG2, 4, 1, HORZ
        loop 129
                update_scroll_wave BG2, HORZ
                update_scroll_wave BG1, VERT
                frame 0
                end_loop
        wait_scanline
        bg1_tilemap_location $0c00
        bg1_gfx_location $0000
        set_scroll_hdma BG1, 3
        move_bg1_here
        init_scroll_wave {BG2, BG1}, 0, 0, {HORZ, VERT}
        update_scroll_wave {BG2, BG1}, {VERT, HORZ}
        reset_scroll_hdma BG1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B8: Absolute 0 (bg1) ]

_d02bea:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ABSOLUTE0_BG1
        anim_script BG1, 1, SCREEN
        sfx
        fixed_draw_order
        move_bg1_here
        sprite_priority 2
        mod_pal BG2, SUB, YELLOW, 0
        loop 32
                mod_pal BG2, SUB, YELLOW, +1
                blank_frame
                end_loop
        sfx BLIZZARA_B
        mod_pal BG1, ADD, WHITE, 31
        loop 32
                mod_pal BG1, ADD, WHITE, -1
                frame 0
                end_loop
        loop 65
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                mod_pal BG2, SUB, YELLOW, -1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B6: Overcast (sprite) ]

_d02c15:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::OVERCAST_SPRITE
        anim_script SPRITE
        loop 65
                blank_frame
                end_loop
        anim_speed 5
        anim_loop 5
                frame 0
                end_anim_loop
        loop 3
                frame 5
                frame 6
                frame 7
                frame 8
                end_loop
        frame 5
        frame 9
        frame 10
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B7: Overcast (bg1) ]

_d02c2c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::OVERCAST_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        hide_bg1_thread
        move_bg1_here
        sprite_priority 3
        sfx
        wait_scanline
        mod_pal BG2, SUB, WHITE, 0
        loop 5
                move UP, 8
                end_loop
        init_blue_gradient 31
        wait_scanline
        color_math {ADD, FIXED_CLR, OUTSIDE_SUB}, {BG2, BACK}
        loop 31
                wait_scanline
                update_wide_blue_gradient -1
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, SUB, WHITE, +1
                blank_frame
                end_loop
        wait_scanline
        mode7_flip NONE
        mode7_move {+64, +64}
        mode7_move {+64, +64}
        mainscreen_layers SPRITE
        screen_mode 7
        mod_pal BG1, SUB, WHITE, 31
        sfx OVERCAST
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                mode7_rotate
                blank_frame
                mainscreen_layers {BG1, SPRITE}
                end_loop
        loop 95
                mode7_rotate
                blank_frame
                end_loop
        wait_scanline
        mainscreen_layers {BG2, SPRITE}
        screen_mode 1
        mod_pal BG2, SUB, WHITE, -1
        loop 31
                mod_pal BG2, SUB, WHITE, -1
                wait_scanline
                update_wide_blue_gradient +1
                blank_frame
                end_loop
        call _d02ca0
        reset_gradient
        end_anim_script

; ------------------------------------------------------------------------------

; [ ??? mode 7 subroutine ]

; always called at the very end of mode 7 animations, I think to reset
; the bg1 tilemap

_d02ca0:
        set_blank_frame 15
        clear_bg_frames
        wait_scanline
        mainscreen_layers {BG2, SPRITE}
        show_bg1_thread
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG1, BOTTOM_RIGHT
        blank_frame 2
        return

; ------------------------------------------------------------------------------

; [ Animation Script $01B4: Disaster (sprite) ]

_d02cb4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DISASTER_SPRITE
        anim_script SPRITE
        move_to_attacker
        loop 65
                blank_frame
                end_loop
        calc_vec
:       update_vec_wave
        frame 0
        move_vec :-, 2
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        update_vec_wave
        anim_speed 4
        loop 8
                move FORWARD, 2
                frame 0
                move BACK, 2
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B5: Disaster (bg1) ]

_d02cd6:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DISASTER_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        sfx
        sprite_priority 2
        move_bg1_here
        loop 8
                move BACK, 32
                end_loop
        wait_scanline
        set_scroll_hdma BG1, 6
        init_scroll_wave BG1, 4, 1, HORZ
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG2, SUB, WHITE, 0
        loop 8
                mod_pal BG2, SUB, WHITE, +1
                frame 0
                end_loop
        loop 32
                update_scroll_wave BG1, HORZ
                mod_pal BG1, SUB, WHITE, -1
                move FORWARD, 2
                frame 0
                hide_bg1_thread
                end_loop
        loop 129
                update_scroll_wave BG1, HORZ
                move FORWARD, 2
                frame 0
                end_loop
        loop 32
                update_scroll_wave BG1, HORZ
                mod_pal BG1, SUB, WHITE, +1
                move FORWARD, 2
                frame 0
                end_loop
        init_scroll_wave BG1, 0, 0, HORZ
        loop 8
                mod_pal BG2, SUB, WHITE, -1
                frame 0
                end_loop
        wait_scanline
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B1: Force Field (bg3) ]

_d02d24:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FORCEFIELD_BG3
        anim_script BG3
        fixed_draw_order
        move_bg3_here
        init_circle {128, 72}, 0, {255, 255}, 255, 0
        frame 0
        hide_bg3_thread
        sfx
        disable_char_pal_update
        mod_pal BG2, ADD, WHITE, 0
        mod_pal MONSTER, ADD, WHITE, 0
        mod_pal CHAR, ADD, WHITE, 0
        mod_pal BG3, ADD, WHITE, 0
        loop 32
                zoom_circle +2
                mod_pal BG2, ADD, WHITE, +1
                mod_pal BG3, ADD, WHITE, +1
                update_circle
                frame 0
                mod_pal MONSTER, ADD, WHITE, +1
                mod_pal CHAR, ADD, WHITE, +1
                zoom_circle +2
                update_circle
                frame 0
                end_loop
        show_bg3_thread
        blank_frame
        hide_bg3_thread
        loop 32
                mod_pal MONSTER, ADD, WHITE, -1
                mod_pal CHAR, ADD, WHITE, -1
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
        enable_char_pal_update
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01AE: Event Animation $00: Terra/Tritoch Lightning (sprite) ]

_d02d6c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TERRA_TRITOCH_SPRITE
        anim_script SPRITE
        move_to_attacker
        anim_priority 3
        loop 121
                blank_frame 2
                end_loop
        anim_speed 4
        move UP_FORWARD, 32
        loop 5
                sfx THUNDAGA
                move_rand {63, 63}
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01CE: Event Animation $02: Terra/Tritoch Lightning w/o Explosions (bg1) ]

_d02d8b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TERRA_TRITOCH_ALT_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        sprite_priority 2
        move UP_FORWARD, 8
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                end_loop
        loop 193
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01AF: Event Animation $00: Terra/Tritoch Lightning (bg1) ]

_d02dd2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TERRA_TRITOCH_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        sprite_priority 2
        move UP_FORWARD, 8
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        sfx XFER
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                .repeat 4
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                .endrep
                end_loop
        loop 129
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                end_loop
        mod_pal BG2, ADD, WHITE, 0
        loop 32
                mod_pal BG2, ADD, RED, +1
                .repeat 2
                cycle_pal BG1_ANIM, 2, {1, 5}
                frame 0
                .endrep
                end_loop
        mod_pal SPRITE, ADD, WHITE, 0
        mod_pal MONSTER, ADD, WHITE, 0
        mod_pal CHAR, ADD, WHITE, 0
        mod_pal BG1, ADD, WHITE, 0
        disable_char_pal_update
        loop 32
                cycle_pal BG1_ANIM, 2, {1, 5}
                mod_pal BG2, ADD, CYAN, +1
                mod_pal MONSTER, ADD, WHITE, +1
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 5}
                mod_pal SPRITE, ADD, WHITE, +1
                mod_pal BG1, ADD, WHITE, +1
                mod_pal CHAR, ADD, WHITE, +1
                frame 0
                end_loop
        set_sound_vol 32
        disable_menu
        anim_speed 3
        loop 16
                dec_brightness
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01B0: Event Animation $00/$02: Terra/Tritoch Lightning (bg3) ]

_d02e44:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TERRA_TRITOCH_BG3
        anim_script BG3
        move_bg3_here
        loop 129
                blank_frame
                end_loop
        anim_speed 5
        move UP_FORWARD, 8
        .repeat 4
        anim_loop 9
                frame 0
                end_anim_loop
        .endrep
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01AC: S. Cross (sprite) ]

_d02e61:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::S_CROSS_SPRITE
        anim_script SPRITE, 1, SCREEN
        move_xy {128, 72}
        call _d02e71
        call _d02e71
        call _d02e71
        end_anim_script

_d02e71:
        rand_angle
        jump_thread _d02e78, _d02e9f

_d02e78:
        move_polar -1, 0
        loop 8
                move_polar -8, 0
                frame 4
                end_loop
        loop 8
                move_polar -8, 0
                frame 3
                end_loop
        loop 8
                move_polar -6, 0
                frame 2
                end_loop
        loop 8
                move_polar -4, 0
                frame 1
                end_loop
        loop 8
                move_polar -2, 0
                frame 0
                end_loop
        return

_d02e9f:
        move_polar -76, 0
        loop 8
                move_polar -4, 0
                frame 4
                end_loop
        loop 8
                move_polar -4, 0
                frame 3
                end_loop
        loop 8
                move_polar -4, 0
                frame 2
                end_loop
        loop 8
                move_polar -3, 0
                frame 1
                end_loop
        loop 8
                move_polar -2, 0
                frame 0
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $01AD: S. Cross (bg1) ]

_d02ec6:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::S_CROSS_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        hide_bg1_thread
        move_bg1_here
        sfx DEFAULT, CENTER
        wait_scanline
        color_math {ADD, FIXED_CLR, OUTSIDE_SUB}, {BG2, BACK}
        init_blue_gradient 15
        mod_pal BG2, SUB, WHITE, 0
        loop 16
                mod_pal BG2, SUB, WHITE, +2
                update_blue_gradient -1
                cycle_pal BG1_ANIM, 1, {1, 7}
                wait_scanline 216
                blank_frame
                end_loop
        mode7_flip NONE
        mode7_move {-16, 0}
        wait_scanline
        mainscreen_layers SPRITE
        screen_mode 7
        sprite_priority 0
        loop 32
                mode7_zoom {-8, -8}
                update_blue_gradient 0
                cycle_pal BG1_ANIM, 1, {1, 7}
                wait_scanline 216
                frame 0
                mainscreen_layers {BG1, SPRITE}
                end_loop
        mainscreen_layers SPRITE
        mode7_flip HORZ
        mode7_zoom {+64, +64}
        mode7_zoom {+64, +64}
        mode7_zoom {+64, +64}
        mode7_zoom {+64, +64}
        loop 32
                mode7_zoom {-8, -8}
                update_blue_gradient 0
                cycle_pal BG1_ANIM, 1, {1, 7}
                wait_scanline 216
                frame 0
                mainscreen_layers {BG1, SPRITE}
                end_loop
        mainscreen_layers SPRITE
        mode7_zoom {+64, +64}
        mode7_zoom {+64, +64}
        mode7_zoom {+64, +64}
        mode7_zoom {+64, +64}
        jump_dir _d02f66, _d02f75
_d02f66:
        mode7_flip HORZ
        move BACK, 192
_d02f75:
        move FORWARD, 96
        mode7_move {+16, +8}
        mode7_move {+32, 0}
        loop 32
                mode7_zoom {-8, -8}
                update_blue_gradient 0
                cycle_pal BG1_ANIM, 1, {1, 7}
                wait_scanline 216
                frame 0
                mainscreen_layers {BG1, SPRITE}
                end_loop
        sprite_priority 3
        wait_scanline
        mainscreen_layers {BG2, BG3, SPRITE}
        screen_mode 1
        loop 16
                mod_pal BG2, SUB, WHITE, -2
                cycle_pal BG1_ANIM, 1, {1, 7}
                wait_scanline 216
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 0
        mod_pal SPRITE, ADD, WHITE, 0
        mod_pal MONSTER, ADD, WHITE, 0
        mod_pal CHAR, ADD, WHITE, 0
        disable_char_pal_update
        loop 16
                mod_pal BG2, ADD, WHITE, +2
                mod_pal SPRITE, ADD, WHITE, +2
                cycle_pal BG1_ANIM, 1, {1, 7}
                update_blue_gradient 0
                blank_frame
                mod_pal MONSTER, ADD, WHITE, +2
                mod_pal CHAR, ADD, WHITE, +2
                cycle_pal BG1_ANIM, 1, {1, 7}
                update_blue_gradient 0
                blank_frame
                end_loop
        reset_gradient
        loop 16
                mod_pal BG2, ADD, WHITE, -2
                blank_frame
                mod_pal MONSTER, ADD, WHITE, -2
                mod_pal CHAR, ADD, WHITE, -2
                blank_frame
                end_loop
        call _d02ca0
        enable_char_pal_update
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01AB: Mind Blast (bg3) ]

_d02fe9:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MIND_BLAST_BG3
        anim_script BG3, 4, SCREEN
        hide_bg3_thread
        mod_pal BG2, ADD, WHITE, 0
        loop 16
                mod_pal BG2, ADD, RED, +1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, ADD, RED, -1
                mod_pal BG2, ADD, BLUE, +1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, ADD, BLUE, -1
                mod_pal BG2, ADD, YELLOW, +1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, ADD, RED, -1
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, ADD, GREEN, -1
                blank_frame
                end_loop
        anim_speed 2
        loop 16
                mod_pal BG2, ADD, WHITE, +2
                blank_frame
                end_loop
        loop 65
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01AA: Mind Blast (bg1) ]

_d03024:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MIND_BLAST_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        fixed_draw_order
        hide_bg1_thread
        sfx DEFAULT, CENTER
        wait_scanline
        set_scroll_hdma BG1, 6
        color_math {ADD, FIXED_CLR}, SPRITE
        update_rainbow_gradient 12
        init_scroll_wave BG1, 2, 1, HORZ
        call _d030ae
        update_rainbow_gradient 7
        init_scroll_wave BG1, 4, 1, HORZ
        call _d030ae
        update_rainbow_gradient 5
        init_scroll_wave BG1, 8, 1, HORZ
        call _d030ae
        update_rainbow_gradient 3
        init_scroll_wave BG1, 12, 1, HORZ
        call _d030ae
        update_rainbow_gradient 1
        init_scroll_wave BG1, 15, 1, HORZ
        mod_pal BG1, ADD, WHITE, 0
        loop 32
                mod_pal BG1, ADD, WHITE, +1
                update_scroll_wave BG1, HORZ
                update_rainbow_gradient 0
                blank_frame
                end_loop
        init_mind_blast_scroll
        loop 256
                update_scroll_wave BG1, HORZ
                update_mind_blast_scroll
                update_rainbow_gradient 0
                blank_frame
                end_loop
        disable_char_pal_update
        mod_pal MONSTER, ADD, WHITE, 0
        mod_pal CHAR, ADD, WHITE, 0
        loop 32
                mod_pal MONSTER, ADD, WHITE, +1
                mod_pal CHAR, ADD, WHITE, +1
                update_scroll_wave BG1, HORZ
                update_mind_blast_scroll
                update_rainbow_gradient 0
                blank_frame
                end_loop
        update_rainbow_gradient 15
        wait_scanline
        reset_scroll_hdma BG3
        reset_mind_blast_scroll
        loop 32
                mod_pal BG1, ADD, WHITE, -1
                mod_pal MONSTER, ADD, WHITE, -1
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        wait_scanline
        set_scroll_hdma BG1, 3
        enable_char_pal_update
        reset_gradient
        end_anim_script

_d030ae:
        loop 16
                update_scroll_wave BG1, HORZ
                wait_scanline
                update_rainbow_gradient 0
                blank_frame
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $01A9: Step Forward to Attack (sprite) ]

_d030ba:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STEP_FORWARD_SPRITE
        anim_script SPRITE
        jump_step :+
        call _d07019
:       end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A8: (bg3) ]

_d030c2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_424
        anim_script BG3
        hide_bg3_thread
        loop 16
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A4: Flare Star (sprite) ]

_d030d3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLARE_STAR_SPRITE
        anim_script SPRITE
        loop 97
                blank_frame
                end_loop
        anim_speed 3
        anim_loop 21
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A5: Flare Star (bg1) ]

_d030e0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLARE_STAR_BG1
        anim_script BG1
        sprite_priority 2
        fixed_draw_order
        move_bg1_here
        init_scroll_wave BG1, 4, 1, {HORZ, VERT}
        disable_char_pal_update
        sfx DEFAULT, CENTER
        wait_scanline
        set_scroll_hdma BG1, 6
        mod_pal BG2, ADD, WHITE, 0
        mod_pal BG1, ADD, WHITE, 0
        mod_pal BG3, ADD, WHITE, 0
        mod_pal MONSTER, ADD, WHITE, 0
        mod_pal CHAR, ADD, WHITE, 0
        loop 32
                update_scroll_wave BG1, {HORZ, VERT}
                frame 0
                hide_bg1_thread
                mod_pal BG2, ADD, RED, +1
                end_loop
        loop 16
                update_scroll_wave BG1, {HORZ, VERT}
                mod_pal BG2, ADD, WHITE, +2
                mod_pal BG1, ADD, WHITE, +2
                frame 0
                update_scroll_wave BG1, {HORZ, VERT}
                mod_pal BG3, ADD, WHITE, +2
                mod_pal MONSTER, ADD, WHITE, +2
                mod_pal CHAR, ADD, WHITE, +2
                frame 0
                end_loop
        show_bg1_thread
        blank_frame
        hide_bg1_thread
        loop 32
                mod_pal BG2, ADD, CYAN, -1
                blank_frame
                mod_pal MONSTER, ADD, WHITE, -1
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, ADD, RED, -1
                blank_frame
                end_loop
        wait_scanline
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        enable_char_pal_update
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A6: Flare Star (bg3) ]

_d0313c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLARE_STAR_BG3
        anim_script BG3
        move_bg3_here
        wait_scanline
        set_scroll_hdma BG3, 2
        window2_size 72
        rand_bg3_hscroll 0
        frame 0
        hide_bg3_thread
        window2_size 64
        rand_bg3_hscroll 0
        frame 0
        window2_size 56
        rand_bg3_hscroll 0
        frame 0
        window2_size 48
        rand_bg3_hscroll 0
        frame 0
        window2_size 40
        rand_bg3_hscroll 0
        frame 0
        window2_size 32
        rand_bg3_hscroll 0
        frame 0
        window2_size 24
        rand_bg3_hscroll 0
        frame 0
        window2_size 16
        rand_bg3_hscroll 0
        frame 0
        window2_size 8
        rand_bg3_hscroll 0
        frame 0
        window2_size 0
        rand_bg3_hscroll 0
        frame 0
        loop 54
                rand_bg3_hscroll 0
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $019F: Quasar (sprite) ]

_d0319a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::QUASAR_SPRITE
        anim_script SPRITE
        move_xy {128, 76}
        loop 113
                blank_frame
                end_loop
        anim_speed 3
        anim_loop 29
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A0: Quasar (bg1) ]

_d031ab:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::QUASAR_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        move UP, 32
        move UP, 32
        sfx DEFAULT, CENTER
        wait_scanline
        set_scroll_hdma BG1, 0
        init_quasar_scroll
        mod_pal BG1, SUB, WHITE, 0
        mod_pal BG3, SUB, WHITE, 0
        loop 33
                update_quasar_scroll
                cycle_pal BG1_ANIM_EXTRA, 4, {1, 6}
                cycle_pal BG1_ANIM, -4, {1, 6}
                frame 0
                hide_bg1_thread
                end_loop
        mod_pal BG2, SUB, WHITE, 0
        loop 16
                mod_pal BG2, SUB, WHITE, +1
                cycle_pal BG1_ANIM_EXTRA, 4, {1, 6}
                cycle_pal BG1_ANIM, -4, {1, 6}
                frame 0
                end_loop
        loop 129
                cycle_pal BG1_ANIM_EXTRA, 4, {1, 6}
                cycle_pal BG1_ANIM, -4, {1, 6}
                frame 0
                end_loop
        loop 16
                mod_pal BG1, SUB, WHITE, +2
                mod_pal BG3, SUB, WHITE, +2
                cycle_pal BG1_ANIM_EXTRA, 4, {1, 6}
                cycle_pal BG1_ANIM, -4, {1, 6}
                frame 0
                end_loop
        loop 16
                mod_pal BG2, SUB, WHITE, -1
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG1, 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01A1: Quasar (bg3) ]

_d03203:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::QUASAR_BG3
        anim_script BG3
        move_bg3_here
        wait_scanline
        set_scroll_hdma BG3, 2
        frame 0
        hide_bg3_thread
        loop 225
                rand_bg3_hscroll 0
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $019D: Net (sprite) ]

_d0321c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NET_SPRITE
        anim_script SPRITE, 3, CENTER
        sfx
        move UP_FORWARD, 16
        move_rand {31, 31}
        anim_loop 4
                frame 0
                end_anim_loop
        loop 8
                frame 3
                end_loop
        frame 2
        frame 1
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $019E: Pearl Wind (bg1) ]

_d03231:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WHITE_WIND_BG1
        anim_script BG1
        sprite_priority 2
        fixed_draw_order
        reset_scroll_hdma BG1
        init_white_wind_scroll
        sfx
        mod_pal BG1, SUB, WHITE, 31
        move_bg1_here
        update_white_wind_scroll
        wait_scanline
        set_scroll_hdma BG1, 0
        bg_screen_pos BG1, BOTTOM_LEFT
        frame 0, 2
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                update_white_wind_scroll
                frame 0
                end_loop
        loop 97
                update_white_wind_scroll
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                update_white_wind_scroll
                frame 0
                end_loop
        show_bg1_thread
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame 2
        set_scroll_hdma BG1, 3
        reset_scroll_hdma BG1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $019C: Pep Up (bg1) ]

_d0326e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PEP_UP_BG1
        anim_script BG1
        sfx
        call _d060ea
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $019B: R.Polarity (sprite) ]

_d03276:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::R_POLARITY_SPRITE
        anim_script SPRITE
        loop 32
                blank_frame
                end_loop
        loop 6
                move_char_row
                blank_frame
                end_loop
        toggle_char_row
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $019A: R.Polarity (bg1) ]

_d03285:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::R_POLARITY_BG1
        anim_script BG1
        fixed_draw_order
        sfx
        mod_pal BG2, ADD, WHITE, 31
        init_scroll_wave BG2, 4, 1, VERT
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                update_scroll_wave BG2, VERT
                blank_frame
                end_loop
        loop 32
                update_scroll_wave BG2, VERT
                blank_frame
                end_loop
        init_scroll_wave BG2, 0, 0, VERT
        update_scroll_wave BG2, VERT
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0199: Dischord (sprite) ]

_d032a4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DISCHORD_SPRITE
        anim_script SPRITE
        fixed_draw_order
        init_scroll_wave BG1, 1, 1, VERT
        wait_scanline
        set_scroll_hdma BG1, 6
        color_math {ADD, FIXED_CLR}, BG1
        sfx
        update_rainbow_gradient 11
        call _d03300
        init_scroll_wave BG1, 3, 1, VERT
        update_rainbow_gradient 7
        call _d03300
        init_scroll_wave BG1, 5, 1, VERT
        update_rainbow_gradient 3
        call _d03300
        init_scroll_wave BG1, 7, 1, VERT
        loop 65
                update_scroll_wave BG1, VERT
                update_rainbow_gradient 0
                blank_frame
                end_loop
        update_rainbow_gradient 3
        init_scroll_wave BG1, 5, 1, VERT
        call _d03300
        update_rainbow_gradient 7
        init_scroll_wave BG1, 3, 1, VERT
        call _d03300
        update_rainbow_gradient 11
        init_scroll_wave BG1, 1, 1, VERT
        call _d03300
        update_rainbow_gradient 15
        wait_scanline
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        reset_gradient
        end_anim_script

_d03300:
        loop 8
                update_scroll_wave BG1, VERT
                update_rainbow_gradient 0
                blank_frame
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0198: Cyclonic (bg1) ]

_d0330a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CYCLONIC_BG1
        anim_script BG1
        fixed_draw_order
        sprite_priority 2
        move_bg1_here
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        loop 65
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, -1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0196: Entwine (sprite) ]

_d03333:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ENTWINE_SPRITE
        anim_script SPRITE, 2, CENTER
        fixed_draw_order
        sfx
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        anim_loop 19
                move_target FORWARD, 2
                frame 0
                move_target BACK, 2
                frame 0
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0194: Stone (sprite) ]

_d03349:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STONE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        sfx
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 8
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::FIGHTING_2
        blank_frame 4
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1
        move_to_attacker
        calc_vec
:       update_orbit_16
        frame 0
        move_vec :-, 4
        attacker_frame CHAR_FRAME::NONE
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        sfx THROW
        bg_target_draw_order
        change_anim_layer BG1
        anim_speed 5
        anim_loop 4
                frame 0
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0192: Rippler (sprite) ]

_d0337e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RIPPLER_SPRITE
        anim_script SPRITE, 1, BOTTOM
        loop 80
                blank_frame
                end_loop
        loop 5
                move UP, 32
                end_loop
        reset_ellipse
        jump_thread _d03394, _d0339a, _d033a0, _d033a6
_d03394:
        move_ellipse +48, 0
        jump _d033a9
_d0339a:
        move_ellipse +48, +64
        jump _d033a9
_d033a0:
        move_ellipse +48, -128
        jump _d033a9
_d033a6:
        move_ellipse +48, -64
_d033a9:
        loop 40
                move_ellipse 0, +8
                move DOWN, 4
                update_ellipse_priority
                frame 0
                end_loop
        loop 65
                move_ellipse 0, +8
                update_ellipse_priority
                frame 0
                end_loop
        jump_thread _d033c6, _d033ce, _d033ce, _d033ce
_d033c6:
        mod_pal BG2, ADD, WHITE, 31
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
_d033ce:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0193: Rippler (bg1) ]

_d033cf:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RIPPLER_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        sprite_priority 3
        mod_pal BG1, SUB, WHITE, 31
        init_scroll_wave BG1, 2, 1, {HORZ, VERT}
        wait_scanline
        set_scroll_hdma BG1, 6
        sfx
        loop 16
                mod_pal BG1, SUB, WHITE, -2
                update_scroll_wave BG1, {HORZ, VERT}
                cycle_pal BG1_ANIM, 4, {1, 6}
                frame 0
                hide_bg1_thread
                end_loop
        loop 33
                update_scroll_wave BG1, {HORZ, VERT}
                enable_vertical_image
                cycle_pal BG1_ANIM, 4, {1, 6}
                frame 0
                update_scroll_wave BG1, {HORZ, VERT}
                disable_vertical_image
                cycle_pal BG1_ANIM, 4, {1, 6}
                frame 0
                end_loop
        loop 65
                update_scroll_wave BG1, {HORZ, VERT}
                cycle_pal BG1_ANIM, 4, {1, 6}
                frame 0
                end_loop
        loop 33
                update_scroll_wave BG1, {HORZ, VERT}
                disable_vertical_image
                cycle_pal BG1_ANIM, 4, {1, 6}
                frame 0
                update_scroll_wave BG1, {HORZ, VERT}
                enable_vertical_image
                cycle_pal BG1_ANIM, 4, {1, 6}
                frame 0
                end_loop
        loop 16
                mod_pal BG1, SUB, WHITE, +2
                update_scroll_wave BG1, {HORZ, VERT}
                cycle_pal BG1_ANIM, 4, {1, 6}
                frame 0
                hide_bg1_thread
                end_loop
        reset_scroll_hdma BG1
        wait_scanline
        set_scroll_hdma BG1, 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $018C: TekMissile, Launcher, Missile (sprite) ]

_d03436:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TEKMISSILE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move UP, 16
        call _d05f25
        move_to_attacker
        loop 16
                move DOWN, 1
                frame 0
                end_loop
        frame 1
        frame 2
        calc_vec
:       auto_frame 1, {0, 3}
        frame 2
        move_vec :-, 8
        reset_frame_offset
        sfx L4_FLARE
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        loop 8
                move_target FORWARD, 3
                blank_frame
                move_target BACK, 3
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $018B: Step Mine (sprite) ]

_d03464:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STEP_MINE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        jump_thread _d03475, _d03480, _d0348b, _d03496, _d0349f, _d034aa

_d03475:
        sfx
        move UP, 16
        loop 48
                blank_frame
                end_loop
        jump _d034b2

_d03480:
        move UP, 8
        move FORWARD, 16
        loop 40
                blank_frame
                end_loop
        jump _d034b2

_d0348b:
        move DOWN, 8
        move FORWARD, 16
        loop 32
                blank_frame
                end_loop
        jump _d034b2

_d03496:
        move DOWN, 16
        loop 24
                blank_frame
                end_loop
        jump _d034b2

_d0349f:
        move DOWN, 8
        move BACK, 16
        loop 16
                blank_frame
                end_loop
        jump _d034b2

_d034aa:
        move UP, 8
        move BACK, 16
        loop 8
                blank_frame
                end_loop

_d034b2:
        loop 20
                move UP, 8
                blank_frame
                end_loop
        .repeat 4
        move BACK, 20
        .endrep
        jump_thread _d034cd, _d034f4, _d03501, _d03510, _d0351f, _d0352d

_d034cd:
        move BACK, 8
        loop 20
                move DOWN, 8
                move FORWARD, 4
                frame 0
                end_loop
        sfx PEARL_LORE
        mod_pal BG2, ADD, WHITE, 31
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                move DOWN, 8
                move FORWARD, 4
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        loop 12
                move DOWN, 8
                move FORWARD, 4
                frame 0
                end_loop
        end_anim_script

_d034f4:
        move BACK, 32
        move UP, 24
        loop 40
                move DOWN, 8
                move FORWARD, 4
                frame 1
                end_loop
        end_anim_script

_d03501:
        move UP_BACK, 40
        move UP, 16
        loop 40
                move DOWN, 8
                move FORWARD, 4
                frame 2
                end_loop
        end_anim_script

_d03510:
        move UP, 16
        move UP, 32
        move UP_BACK, 32
        loop 40
                move DOWN, 8
                move FORWARD, 4
                frame 3
                end_loop
        end_anim_script

_d0351f:
        move UP_BACK, 24
        move UP, 64
        loop 40
                move DOWN, 8
                move FORWARD, 4
                frame 4
                end_loop

_d0352d:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0188: Blow Fish (sprite) ]

_d0352e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLOW_FISH_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move BACK, 32
        move BACK, 32
        move BACK, 32
        move BACK, 32
        move UP, 16
        jump_thread _d03545, _d03564, _d03545, _d03564

_d03545:
        sfx
        move_rand {0, 31}
        loop 16
                move FORWARD, 8
                frame 0
                end_loop
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        loop 2
                move_target BACK, 2
                anim_target_pal
                frame 0
                move_target FORWARD, 2
                restore_target_pal
                frame 0
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

_d03564:
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        move_rand {0, 31}
        loop 16
                move FORWARD, 8
                frame 1
                end_loop
        loop 2
                move_target BACK, 2
                anim_target_pal
                frame 1
                move_target FORWARD, 2
                restore_target_pal
                frame 1
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0190: L.4 Flare (extra) ]

_d03581:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::L4_FLARE_EXTRA
        anim_script SPRITE
        fixed_draw_order
        mod_pal BG2, SUB, CYAN, 0
        init_scroll_wave BG2, 4, 4, HORZ
        loop 32
                mod_pal BG2, SUB, CYAN, +1
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        loop 129
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, SUB, CYAN, -1
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, HORZ
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0186: L.4 Flare (sprite) ]

_d035a6:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::L4_FLARE_SPRITE
        anim_script SPRITE, 3, CENTER
        fixed_draw_order
        loop 11
                blank_frame
                end_loop
        sfx
        anim_loop 27
                frame 0
                end_anim_loop
        jump_thread _d035b9, _d035c4

_d035b9:
        sfx L4_FLARE
        bg_target_draw_order
        change_anim_layer BG1
        anim_loop 16
                frame 0
                end_anim_loop
        end_anim_script

_d035c4:
        anim_speed 2
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        loop 16
                anim_target_pal
                frame 1
                move_target FORWARD, 2
                restore_target_pal
                frame 1
                move_target BACK, 2
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0185: L.5 Doom (sprite) ]

_d035da:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::L5_DOOM_SPRITE
        anim_script SPRITE, 9, CENTER
        fixed_draw_order
        sfx
        anim_loop 8
                frame 0
                end_anim_loop
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [  ]

_d035e6:
        mod_pal BG2, ADD, WHITE, 31
        loop 32
                update_scroll_wave BG2, HORZ
                update_scroll_wave BG1, VERT
                cycle_pal BG1_ANIM_EXTRA, 2, {1, 6}
                cycle_pal BG1_ANIM, -2, {1, 6}
                wait_scanline
                mod_pal BG2, ADD, WHITE, -4
                frame 4
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $017E: Condemned (bg1) ]

_d035fb:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONDEMNED_BG1
        anim_script BG1
        fixed_draw_order
        wait_scanline
        set_scroll_hdma BG1, 6
        mod_pal BG1, ADD, WHITE, 0
        init_scroll_wave BG1, 4, 2, VERT
        sfx
        loop 65
                update_scroll_wave BG1, VERT
                frame 0
                hide_bg1_thread
                end_loop
        loop 32
                update_scroll_wave BG1, VERT
                mod_pal BG1, ADD, WHITE, +1
                frame 0
                hide_bg1_thread
                end_loop
        wait_scanline
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $017F: Condemned (bg3) ]

_d03623:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONDEMNED_BG3
        anim_script BG3
        frame 0
        hide_bg3_thread
        loop 97
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $017D: Blaster (sprite) ]

_d0362d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLASTER_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_to_attacker
        calc_vec
        jump_thread _d0363c, _d0364d, _d03656, _d0365f

_d0363c:
        sfx
:       frame 3
        move_vec_arc :-, 8
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
:       frame 3
        move_vec_arc :-, 8
        target_frame CHAR_FRAME::NONE
        end_anim_script

_d0364d:
:       frame 2
        move_vec_arc :-, 8
:       frame 2
        move_vec_arc :-, 8
        end_anim_script

_d03656:
:       frame 1
        move_vec_arc :-, 8
:       frame 1
        move_vec_arc :-, 8
        end_anim_script

_d0365f:
:       frame 0
        move_vec_arc :-, 8
:       frame 0
        move_vec_arc :-, 8
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $017A: Delta Hit (sprite) ]

_d03668:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DELTA_HIT_SPRITE
        anim_script SPRITE
        move_xy {80, 96}
        init_polar
        jump_thread _d03677, _d0367f, _d03685

_d03677:
        sfx
        move_polar +112, -128
        jump _d03688

_d0367f:
        move_polar +112, -43
        jump _d03688

_d03685:
        move_polar +112, +42

_d03688:
        anim_speed 5
        anim_loop 4
                move_polar 0, 0
                frame 0
                end_anim_loop
        anim_speed 2
        loop 81
                move_polar 0, 0
                frame 4
                end_loop
        anim_speed 5
        move_polar 0, 0
        frame 3
        move_polar 0, 0
        frame 2
        move_polar 0, 0
        frame 1
        move_polar 0, 0
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $017B: Delta Hit (bg1) ]

_d036ad:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DELTA_HIT_BG1
        anim_script BG1
        sprite_priority 2
        fixed_draw_order
        init_triangle {0, 0}, 112, 128
        move_xy {80, 96}
        move_triangle_here
        calc_vec_triangle
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        loop 16
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 1, {1, 7}
                update_triangle_2d
                frame 0
                end_loop
:       move_triangle_here
        zoom_triangle 0, +6
        cycle_pal BG1_ANIM, 1, {1, 7}
        update_triangle_2d
        frame 0
        move_vec :-, 2
        loop 27
                zoom_triangle -4, +6
                cycle_pal BG1_ANIM, 1, {1, 7}
                update_triangle_2d
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0179: Slimer (bg1) ]

_d036f0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLIMER_BG1
        anim_script BG1
        fixed_draw_order
        init_circle {0, 0}, 16, {255, 255}, 32, 0
        move_circle_to_target
        mod_pal BG1, SUB, WHITE, 31
        sfx
        loop 32
                cycle_pal BG1_ANIM, 1, {1, 7}
                mod_pal BG1, SUB, WHITE, -1
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 16
                cycle_pal BG1_ANIM, 1, {1, 7}
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 32
                cycle_pal BG1_ANIM, 1, {1, 7}
                mod_pal BG1, SUB, WHITE, +1
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $017C: Run (sprite) ]

_d03724:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RUN_SPRITE
        anim_script SPRITE
        sfx
        jump_magitek _d0372d, _d03742

_d0372d:
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 139
                move BACK, 1
                move_attacker BACK, 1
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        end_anim_script

_d03742:
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 43
                move BACK, 3
                move_attacker BACK, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0178: Megazerk (bg1) ]

_d0374f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MEGAZERK_BG1
        anim_script BG1
        hide_bg1_thread
        fixed_draw_order
        sfx
        mod_pal BG2, ADD, RED, 0
        wait_scanline
        color_math {ADD, SUBSCREEN}, SPRITE
        loop 9
                mod_pal BG2, ADD, RED, +2
                blank_frame
                end_loop
        update_megazerk_gradient 15
        blank_frame
        update_megazerk_gradient 13
        blank_frame
        update_megazerk_gradient 11
        blank_frame
        update_megazerk_gradient 9
        blank_frame
        update_megazerk_gradient 7
        blank_frame
        update_megazerk_gradient 5
        blank_frame
        update_megazerk_gradient 3
        blank_frame
        update_megazerk_gradient 1
        blank_frame
        loop 97
                update_megazerk_gradient 0
                blank_frame
                end_loop
        update_megazerk_gradient 1
        mod_pal BG2, ADD, RED, -2
        blank_frame
        update_megazerk_gradient 3
        mod_pal BG2, ADD, RED, -2
        blank_frame
        update_megazerk_gradient 5
        mod_pal BG2, ADD, RED, -2
        blank_frame
        update_megazerk_gradient 7
        mod_pal BG2, ADD, RED, -2
        blank_frame
        update_megazerk_gradient 9
        mod_pal BG2, ADD, RED, -2
        blank_frame
        update_megazerk_gradient 11
        mod_pal BG2, ADD, RED, -2
        blank_frame
        update_megazerk_gradient 13
        mod_pal BG2, ADD, RED, -2
        blank_frame
        update_megazerk_gradient 15
        mod_pal BG2, ADD, RED, -2
        blank_frame
        reset_gradient
        loop 9
                mod_pal BG2, ADD, RED, -2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0177: Lullaby (sprite) ]

_d037c5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LULLABY_SPRITE
        anim_script SPRITE, 2, CENTER
        loop 2
                move_target BACK, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                move_target BACK, 1
                blank_frame
                move_target BACK, 1
                blank_frame 5
                move_target FORWARD, 1
                blank_frame
                move_target FORWARD, 1
                blank_frame
                move_target FORWARD, 2
                blank_frame
                move_target FORWARD, 2
                blank_frame
                move_target FORWARD, 2
                blank_frame
                move_target FORWARD, 2
                blank_frame
                move_target FORWARD, 1
                blank_frame
                move_target FORWARD, 1
                blank_frame 5
                move_target BACK, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                move_target BACK, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0176: Schiller (sprite) ]

_d03803:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SCHILLER_SPRITE
        anim_script SPRITE
        fixed_draw_order
        sfx
        .repeat 5
        call _d03819
        .endrep
        end_anim_script

_d03819:
        mod_pal BG2, ADD, WHITE, 31
        loop 8
                mod_pal BG2, ADD, WHITE, -4
                blank_frame
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0174: Virite (sprite) ]

_d03822:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::VIRITE_SPRITE
        anim_script SPRITE, 3, CENTER
        rand_sprite_pal
        move UP, 16
        move BACK, 16
        move_rand {7, 31}
        sfx
        anim_loop 6
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0173: Clear (bg3) ]

_d03834:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLEAR_BG3
        anim_script BG3, 1, SCREEN
        fixed_draw_order
        move_bg3_here
        mod_pal BG3, SUB, WHITE, 31
        bg_screen_pos BG3, TOP_RIGHT
        wait_scanline
        set_scroll_hdma BG3, 7
        frame 0, 2
        hide_bg3_thread
        init_scroll_wave BG3, 4, 1, HORZ
        init_scroll_wave BG3, 2, 2, VERT
        sfx
        loop 32
                mod_pal BG3, SUB, WHITE, -1
                update_scroll_wave BG3, {HORZ, VERT}
                move FORWARD, 1
                frame 0
                end_loop
        mod_pal BG1, ADD, WHITE, 0
        loop 32
                mod_pal BG1, ADD, WHITE, +1
                update_scroll_wave BG3, {HORZ, VERT}
                move FORWARD, 1
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                update_scroll_wave BG3, {HORZ, VERT}
                move FORWARD, 1
                frame 0
                end_loop
        mainscreen_layers {BG2, BG3, BG4, SPRITE}
        loop 32
                mod_pal BG3, SUB, WHITE, +1
                update_scroll_wave BG3, {HORZ, VERT}
                move FORWARD, 1
                frame 0
                end_loop
        reset_scroll_hdma BG3
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        wait_scanline
        set_scroll_hdma BG3, 5
        invisible_monster
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0171: Imp Song (sprite) ]

_d03891:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IMP_SONG_SPRITE
        anim_script SPRITE, 4, BOTTOM
        anim_priority 3
        loop 8
                blank_frame
                end_loop
        move FORWARD, 16
        move_rand {31, 0}
        anim_loop 14
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0172: Imp Song, Lullaby (bg1) ]

_d038a3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IMP_SONG_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        sprite_priority 2
        move_bg1_here
        bg_screen_pos BG1, TOP_RIGHT
        sfx
        wait_scanline
        set_scroll_hdma BG1, 6
        color_math {ADD, FIXED_CLR}, BG1
        frame 0, 2
        hide_bg1_thread
        init_scroll_wave BG1, 4, 1, HORZ
        init_scroll_wave BG1, 2, 2, VERT
        loop 32
                update_scroll_wave BG1, {HORZ, VERT}
                move FORWARD, 1
                update_rainbow_gradient 0
                frame 0
                end_loop
        loop 65
                update_scroll_wave BG1, {HORZ, VERT}
                move FORWARD, 1
                update_rainbow_gradient 0
                frame 0
                end_loop
        loop 32
                update_scroll_wave BG1, {HORZ, VERT}
                move FORWARD, 1
                update_rainbow_gradient 0
                frame 0
                end_loop
        reset_scroll_hdma BG1
        show_bg1_thread
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        wait_scanline
        set_scroll_hdma BG1, 3
        reset_gradient
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0170: Dread (sprite) ]

_d038f0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DREAD_SPRITE
        anim_script SPRITE, 5, CENTER
        fixed_draw_order
        move UP_FORWARD, 16
        sfx
        move_rand {31, 31}
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        loop 17
                frame 5
                end_loop
        move DOWN_BACK, 16
        move_rand {0, 0}
        anim_speed 2
        sfx RASP_B
        jump_thread _d0391a, _d03927, _d03934, _d03941, _d03950, _d03950

_d0391a:
        anim_loop 5
                .repeat 3
                move DOWN_FORWARD, 4
                frame 6
                .endrep
                end_anim_loop
        end_anim_script

_d03927:
        anim_loop 5
                .repeat 3
                move DOWN_BACK, 4
                frame 6
                .endrep
                end_anim_loop
        end_anim_script

_d03934:
        anim_loop 5
                .repeat 3
                move UP_FORWARD, 4
                frame 6
                .endrep
                end_anim_loop
        end_anim_script

_d03941:
        anim_loop 5
                .repeat 3
                move UP_BACK, 4
                frame 6
                .endrep
                end_anim_loop
        sfx NONE
        end_anim_script

_d03950:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $016F: Escape (sprite) ]

_d03951:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ESCAPE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        sfx
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                blank_frame
                end_loop
        mainscreen_layers {BG2, BG3, SPRITE}
        hide_target_monsters
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $016E: WallChange (sprite) ]

_d0396b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WALLCHANGE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        sfx
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1
        update_rainbow_gradient 15
        blank_frame
        update_rainbow_gradient 13
        blank_frame
        update_rainbow_gradient 11
        blank_frame
        update_rainbow_gradient 9
        blank_frame
        update_rainbow_gradient 7
        blank_frame
        update_rainbow_gradient 5
        blank_frame
        update_rainbow_gradient 3
        blank_frame
        update_rainbow_gradient 1
        blank_frame
        loop 97
                update_rainbow_gradient 0
                blank_frame
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        update_rainbow_gradient 1
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        update_rainbow_gradient 3
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        update_rainbow_gradient 5
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        update_rainbow_gradient 7
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        update_rainbow_gradient 9
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        update_rainbow_gradient 11
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        update_rainbow_gradient 13
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        update_rainbow_gradient 15
        mod_pal BG2, ADD, WHITE, -2
        blank_frame
        sfx FLASH
        loop 8
                mod_pal BG2, ADD, WHITE, -2
                blank_frame
                end_loop
        reset_gradient
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $016C: Acid Rain, Flash Rain (bg1) ]

_d039db:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLASH_RAIN_BG1
        anim_script BG3, 1, SCREEN
        fixed_draw_order
        sprite_priority 2
        move_bg1_here
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG3, SUB, WHITE, 31
        frame 0
        sfx DEFAULT, CENTER
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                mod_pal BG3, SUB, WHITE, -1
                cycle_pal BG1_ANIM, -2, {1, 6}
                frame 0
                end_loop
        loop 65
                cycle_pal BG1_ANIM, -2, {1, 6}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                mod_pal BG3, SUB, WHITE, +1
                cycle_pal BG1_ANIM, -2, {1, 6}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $016D: Flash Rain (bg3) ]

_d03a9b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLASH_RAIN_BG3
        anim_script BG3, 4, CENTER
        move_bg3_here
        loop 9
                frame 0
                frame 1
                frame 2
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $016A: Blizzard (sprite) ]

_d03a17:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SNOWSTORM_SPRITE
        anim_script SPRITE, 2, CENTER
        sfx SLEEP
        anim_loop 7
                anim_target_pal
                frame 0
                restore_target_pal
                frame 0
                end_anim_loop
        anim_loop 15
                frame 0, 2
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $016B: Blizzard (bg1) ]

_d03a2a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SNOWSTORM_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        sprite_priority 2
        move_bg1_here
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 65
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0167: Diffuser (sprite) ]

_d03a53:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DIFFUSER_SPRITE
        anim_script SPRITE, 4, SCREEN
        fixed_draw_order
        jump_battle_type _d03a5f, _d03a66, _d03a6a

_d03a5f:
        move_xy {192, 80}
        jump _d03a6a

_d03a66:
        move_xy {64, 80}

_d03a6a:
        move DOWN_BACK, 8
        frame 0
        frame 1
        frame 2
        frame 3
        loop 31
                frame 3
                end_loop
        frame 3
        frame 2
        frame 1
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0168: Diffuser (bg1) ]

_d03a79:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DIFFUSER_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        sfx
        jump_battle_type _d03a87, _d03a8e, _d03a92

_d03a87:
        move_xy {192, 80}
        jump _d03a92

_d03a8e:
        move_xy {64, 80}

_d03a92:
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG3, SUB, WHITE, 31
        loop 16
                mod_pal BG1, SUB, WHITE, -2
                mod_pal BG3, SUB, WHITE, -2
                frame 0
                hide_bg1_thread
                end_loop
        show_bg1_thread
        anim_speed 5
        anim_loop 12
                frame 0
                end_anim_loop
        anim_loop 12
                frame 0
                end_anim_loop
        anim_speed 2
        loop 16
                mod_pal BG1, SUB, WHITE, +2
                mod_pal BG3, SUB, WHITE, +2
                frame 11
                hide_bg1_thread
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0169: diffuser (bg3) ]

_d03ab9:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DIFFUSER_BG3
        anim_script BG3, 1, SCREEN
        move_bg3_here
        jump_battle_type _d03ac5, _d03acc, _d03ad0

_d03ac5:
        move_xy {192, 80}
        jump _d03ad0

_d03acc:
        move_xy {64, 80}

_d03ad0:
        loop 16
                frame 0
                hide_bg3_thread
                end_loop
        show_bg3_thread
        call _d03ae8
        call _d03ae8
        loop 6
                frame 0, 2
                frame 1, 2
                frame 2, 2
                end_loop
        end_anim_script

_d03ae8:
        loop 4
                mod_pal BG2, ADD, WHITE, 15
                frame 0
                mod_pal BG2, ADD, WHITE, -2
                frame 0
                mod_pal BG2, ADD, WHITE, -2
                frame 1
                mod_pal BG2, ADD, WHITE, -2
                frame 1
                mod_pal BG2, ADD, WHITE, -2
                frame 2
                mod_pal BG2, ADD, WHITE, -2
                frame 2
                mod_pal BG2, ADD, WHITE, -2
                frame 0
                mod_pal BG2, ADD, WHITE, -2
                frame 0
                mod_pal BG2, ADD, WHITE, -2
                frame 1, 2
                frame 2, 2
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0163: Atomic Ray (sprite) ]

_d03b0a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATOMIC_RAY_SPRITE
        anim_script SPRITE, 2, BOTTOM
        anim_priority 0
        fixed_draw_order
        jump_thread _d03b19, _d03b41, _d03b41, _d03b52

_d03b19:
        sfx
        call _d03b53
        call _d03b53
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        call _d03b53
        move DOWN, 64
        sfx L4_FLARE
        bg_target_draw_order
        change_anim_layer BG1
        anim_speed 2
        anim_loop 15
                anim_target_pal
                frame 0
                restore_target_pal
                frame 0, 2
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

_d03b41:
        move BACK, 16
        call _d03b53
        move FORWARD, 16
        call _d03b53
        move BACK, 31
        call _d03b53
        move FORWARD, 31
_d03b52:
        end_anim_script

_d03b53:
        move_rand {15, 0}
        anim_loop 9
                frame 0
                end_anim_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0162: Fire Ball (sprite) ]

_d03b5b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_BALL_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        move UP_FORWARD, 16
        anim_priority 0
        jump_thread _d03b7a, _d03b6c, _d03b7c, _d03b85

_d03b6c:
        move UP, 32
        back_sprite
        call _d03b86
        call _d03b86
        call _d03b86
        end_anim_script

_d03b7a:
        sfx
_d03b7c:
        call _d03b86
        call _d03b86
        call _d03b86
_d03b85:
        end_anim_script

_d03b86:
        move_rand {31, 31}
        loop 5
                move UP_BACK, 32
                end_loop
        loop 20
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        target_frame CHAR_FRAME::HIT, CHAR_FRAME::HIT + $30
        anim_target_pal
        frame 1
        restore_target_pal
        frame 1
        anim_target_pal
        frame 1
        restore_target_pal
        anim_loop 6
                frame 2, 3
                end_anim_loop
        target_frame CHAR_FRAME::NONE
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0160: Exploder (sprite) ]

_d03bac:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EXPLODER_SPRITE
        anim_script SPRITE, 3, CENTER
        sfx
        move UP_FORWARD, 32
        loop 2
                move_rand {63, 63}
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0161: Exploder (bg1) ]

_d03bc1:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EXPLODER_BG1
        anim_script BG1
        mod_pal BG2, SUB, CYAN, 0
        sfx
        anim_loop 6
                .repeat 2
                mod_pal BG2, SUB, CYAN, +2
                frame 0
                .endrep
                end_anim_loop
        loop 17
                anim_target_pal
                blank_frame
                restore_target_pal
                blank_frame
                hide_bg1_thread
                end_loop
        loop 12
                mod_pal BG2, SUB, CYAN, -2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $015E: X-fer (sprite) ]

_d03be2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::XFER_SPRITE
        anim_script SPRITE
        loop 49
                blank_frame
                end_loop
        anim_priority 3
        move FORWARD, 32
        .repeat 5
        call _d03bfc
        .endrep
        end_anim_script

_d03bfc:
        jump_thread _d03c09, _d03c18, _d03c27, _d03c09, _d03c18, _d03c27

_d03c09:
        move_rand {63, 0}
        loop 10
                move UP, 16
                frame 0
                end_loop
        loop 10
                move DOWN, 16
                end_loop
        return

_d03c18:
        move_rand {63, 0}
        loop 10
                move UP, 16
                frame 1
                end_loop
        loop 10
                move DOWN, 16
                end_loop
        return

_d03c27:
        move_rand {63, 0}
        loop 10
                move UP, 16
                frame 2
                end_loop
        loop 10
                move DOWN, 16
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $015F: X-fer (bg3) ]

_d03c36:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::XFER_BG3
        anim_script BG3, 1, BOTTOM
        sfx
        fixed_draw_order
        init_circle {0, 0}, 0, {255, 255}, 64, 0
        move_circle_to_target
        move DOWN, 80
        move_circle {0, +112}, 0
        loop 65
                zoom_circle +1
                auto_frame 4, {0, 3}
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 33
                auto_frame 4, {0, 3}
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        jump_hit :+
        loop 57
                auto_frame 4, {0, 3}
                move UP, 4
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        end_anim_script

:       mainscreen_layers {BG2, BG3, BG4, SPRITE}
        loop 57
                auto_frame 4, {0, 3}
                move UP, 4
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        hide_target_monsters
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $015C: Confuser (bg3) ]

_d03c89:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONFUSER_BG3
        anim_script BG3
        fixed_draw_order
        init_circle {0, 0}, 0, {255, 255}, 127, 0
        move_to_attacker
        move_circle_to_attacker
        frame 0
        hide_bg3_thread
        loop 41
                zoom_circle +1
                cycle_pal BG3_ANIM, 4, {1, 3}
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 65
                cycle_pal BG3_ANIM, 4, {1, 3}
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 40
                zoom_circle -1
                cycle_pal BG3_ANIM, 4, {1, 3}
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $015D: Confuser, Revenger, Shadow Edge (bg1) ]

_d03cc1:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONFUSER_BG1
        anim_script BG1
        move_bg1_here
        sfx
        wait_scanline
        set_scroll_hdma BG1, 6
        bg1_tilemap_location $6100
        bg1_gfx_location $1000
        init_scroll_wave BG1, 1, 1, {HORZ, VERT}
        call _d03d2a
        hide_bg1_thread
        init_scroll_wave BG1, 3, 1, {HORZ, VERT}
        call _d03d2a
        init_scroll_wave BG1, 5, 1, {HORZ, VERT}
        call _d03d2a
        init_scroll_wave BG1, 7, 1, HORZ
        call _d03d2a
        init_scroll_wave BG1, 9, 1, HORZ
        call _d03d2a
        loop 97
                update_scroll_wave BG1, {HORZ, VERT}
                frame 0
                end_loop
        init_scroll_wave BG1, 7, 1, HORZ
        call _d03d2a
        init_scroll_wave BG1, 5, 1, {HORZ, VERT}
        call _d03d2a
        init_scroll_wave BG1, 4, 1, {HORZ, VERT}
        call _d03d2a
        init_scroll_wave BG1, 3, 1, {HORZ, VERT}
        call _d03d2a
        init_scroll_wave BG1, 2, 1, {HORZ, VERT}
        call _d03d2a
        init_scroll_wave BG1, 1, 1, {HORZ, VERT}
        call _d03d2a
        wait_scanline
        bg1_tilemap_location $0c00
        bg1_gfx_location $0000
        set_scroll_hdma BG1, 3
        move_bg1_here
        reset_scroll_hdma BG1
        end_anim_script

_d03d2a:
        loop 4
                update_scroll_wave BG1, {HORZ, VERT}
                frame 0
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $015B: Grav Bomb (bg1) ]

; d0/3d31
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GRAV_BOMB_BG1
        anim_script BG1, 6, BOTTOM
        fixed_draw_order
        move DOWN, 8
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        move UP, 5
        frame 8
        frame 9
        frame 10
        frame 11
        loop 8
                frame 11
                end_loop
        anim_speed 4
        frame 10
        frame 9
        frame 8
        move DOWN, 5
        frame 7
        frame 6
        frame 5
        frame 4
        frame 3
        frame 2
        frame 1
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $015A: Grav Bomb (sprite) ]

; d0/3d59
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GRAV_BOMB_SPRITE
        anim_script SPRITE
        sfx GRAVITY_BOMB
        anim_priority 2
        jump_thread _d03d6c, _d03d7e, _d03d7e, _d03d7e, _d03d7e, _d03d7e

_d03d6c:
        sfx
        move_to_attacker
        fixed_draw_order
        calc_vec_grav_bomb
:       frame 4
        move_vec_grav_bomb :-, 8
        unpause_layer BG1
        loop 129
                blank_frame
                end_loop
        end_anim_script

_d03d7e:
        anim_speed 3
        loop 2
                move_to_first_thread
                frame 4
                frame 3
                frame 2
                frame 1
                frame 0
                end_loop
        move_to_target
        move UP_FORWARD, 16
        loop 32
                blank_frame
                end_loop
        anim_priority 3
        anim_speed 4
        loop 5
                move_rand {31, 31}
                frame 5
                frame 6
                frame 7
                frame 8
                frame 9
                frame 10
                frame 11
                frame 12
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0159:  ]

; d0/3da5
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_345
        anim_script SPRITE, 3
        anim_priority 2
        loop 8
                blank_frame
                end_loop
        anim_loop 7
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0158: Bio Blast (bg1) ]

; d0/3db2
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIO_BLAST_BG1
        anim_script BG1
        move_bg1_here
        sfx
        sprite_priority 2
        magitek_action 2
        fixed_draw_order
        init_circle {128, 75}, 4, {222, 255}, 127, 32
        move_circle_to_attacker
        move_circle {-32, 16}
        set_scroll_hdma BG1, 6
        init_scroll_wave BG1, 8, 1, HORZ
        init_scroll_wave BG1, 2, 2, VERT
        frame 0
        hide_bg1_thread
        loop 56
                move_circle {-2, 0}
                zoom_circle 2
                update_circle
                update_scroll_wave BG1, {HORZ, VERT}
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 33
                mod_pal BG1, SUB, WHITE, +1
                zoom_circle 1
                update_circle
                update_scroll_wave BG1, {HORZ, VERT}
                frame 0
                end_loop
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        normal_draw_order
        magitek_action 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0154: Bolt Beam (bg1) ]

; d0/3dff
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOLT_BEAM_BG1
        anim_script BG1, 1, FRONT_FAR
        move_to_attacker
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_FORWARD
        calc_vec_char
:       blank_frame
        move_vec_char :-, 2
        fixed_draw_order
        sfx
        attacker_action CHAR_ACTION::NONE
        magitek_action 2
        loop 4
                move FORWARD, 32
                end_loop
        move DOWN_FORWARD, 8
        unpause_layer BG3
        loop 7
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                end_loop
        unpause_layer SPRITE
        loop 16
                blank_frame
                end_loop
        normal_draw_order
        anim_speed 2
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_BACK
:       blank_frame
        move_vec_char :-, -2
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0155: Bolt Beam (bg3) ]

; d0/3e46
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOLT_BEAM_BG3
        anim_script BG3
        move_to_prev_thread
        loop 42
                frame 0
                hide_bg3_thread
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $014D: Fire Beam, Ice Beam (sprite) ]

; d0/3e51
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_BEAM_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOLT_BEAM_SPRITE
        anim_script SPRITE
        jump_thread _d03e5a, _d03e61, _d03e66

_d03e5a:
        sfx L4_FLARE
        move FORWARD, 1
        jump _d03e68

_d03e61:
        move FORWARD, 9
        jump _d03e68

_d03e66:
        move FORWARD, 17

_d03e68:
        anim_speed 3
        anim_loop 6
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $014C: Fire Beam, Ice Beam (bg3) ]

; d0/3e6f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_BEAM_BG3
        anim_script BG3
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {SPRITE, BG2}
        move_to_prev_thread
        anim_speed 5
        anim_loop 9
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0157: Ice Beam (bg1) ]

; d0/3e80
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ICE_BEAM_BG1
        anim_script BG1, 1, FRONT_FAR
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {SPRITE, BG2}
        jump _d03e8d

; ------------------------------------------------------------------------------

; [ Animation Script $014B: Fire Beam (bg1) ]

; d0/3e8b
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_BEAM_BG1
        anim_script BG1, 1, FRONT_FAR
_d03e8d:
        move_to_attacker
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_FORWARD
        calc_vec_char
:       blank_frame
        move_vec_char :-, 2
        fixed_draw_order
        sfx
        attacker_action CHAR_ACTION::NONE
        magitek_action 2
        loop 4
                move FORWARD, 32
                end_loop
        move DOWN_FORWARD, 8
        unpause_layer BG3
        loop 8
                .repeat 4
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                .endrep
                end_loop
        unpause_layer SPRITE
        loop 16
                blank_frame
                end_loop
        normal_draw_order
        anim_speed 2
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_BACK
:       blank_frame
        move_vec_char :-, -2
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0152: Snare (bg1) ]

; d0/3edc
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SNARE_BG1
        anim_script BG1, 1, BOTTOM
        target_priority 2
        fixed_draw_order
        loop 8
                move DOWN, 16
                end_loop
        move UP, 8
        sfx
        init_circle {0, 0}, 0, {255, 255}, 64, 0
        move_circle_to_target
        move_circle {0, 72}, 0
        frame 0
        hide_bg1_thread
        loop 32
                zoom_circle 2
                update_circle
                frame 0
                end_loop
        bg1_window 1
        jump_hit _d03f1b
        loop 128
                frame 0
                end_loop
        bg1_window 2
        loop 31
                zoom_circle -2
                update_circle
                frame 0
                end_loop
        end_anim_script

_d03f1b:
        loop 128
                move_target DOWN, 1
                frame 0
                end_loop
        hide_target_monsters
        bg1_window 2
        loop 31
                zoom_circle -2
                update_circle
                frame 0
                end_loop
        loop 4
                move_target UP, 32
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0153: Cure 2, Dried Meat, Pearl Wind, Health (sprite) ]

; d0/3f35
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CURA_SPRITE
        anim_script SPRITE
        fixed_draw_order

; called from cat rain, reviver
_d03f39:
        jump_thread _d03f42, _d03f49, _d03f52, _d03f5e

_d03f42:
        sfx
        move FORWARD, 12
        jump _d03f58

_d03f49:
        loop 4
                blank_frame
                end_loop
        move UP, 12
        jump _d03f58

_d03f52:
        loop 8
                blank_frame
                end_loop
        move BACK, 12

_d03f58:
        anim_speed 4
        anim_loop 14
                frame 0
                end_anim_loop

_d03f5e:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0150: Kitty (sprite) ]

; d0/3f5f
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KITTY_SPRITE
        anim_script SPRITE, 4
        anim_priority 0
        loop 7
                blank_frame
                end_loop
        sfx RASP_B
        anim_loop 9
                frame 0
                end_anim_loop
        sfx NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0151: Kitty (bg1) ]

; d0/3f70
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KITTY_BG1
        anim_script BG1, 2
        fixed_draw_order
        anim_priority 2
        move_to_attacker
        sfx
        move FORWARD, 32
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        loop 65
                frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $014E: Wild Bear (sprite) ]

; d0/3f85
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WILD_BEAR_SPRITE
        anim_script SPRITE, 4
        fixed_draw_order
        anim_priority 2
        move_to_attacker
        move FORWARD, 32
        sfx
        loop 4
                frame 0
                frame 1
                end_loop
        loop 33
                frame 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $014F: Wild Bear (bg1) ]

; d0/3f9a
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WILD_BEAR_BG1
        anim_script BG1
        move_bg1_here
        jump_dir _d03fe0, _d03fa4

_d03fa4:
        init_circle {32, 112}, 0, {255, 255}, 32, 0
        frame 0
        hide_bg1_thread
        loop 32
                frame 0
                end_loop
        sfx XFER
        loop 16
                cycle_pal BG1_ANIM, 1, {1, 6}
                zoom_circle 2
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 97
                cycle_pal BG1_ANIM, 1, {1, 6}
                move_circle {2, 0}, 0
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 16
                cycle_pal BG1_ANIM, 1, {1, 6}
                zoom_circle -2
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        end_anim_script

_d03fe0:
        init_circle {224, 112}, 0, {255, 255}, 32, 0
        frame 0
        hide_bg1_thread
        loop 32
                frame 0
                end_loop
        sfx XFER
        loop 16
                cycle_pal BG1_ANIM, 1, {1, 6}
                zoom_circle 2
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 97
                cycle_pal BG1_ANIM, 1, {1, 6}
                move_circle {-2, 0}, 0
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        loop 16
                cycle_pal BG1_ANIM, 1, {1, 6}
                zoom_circle -2
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $014A: Lagomorph (bg1) ]

_d0401c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LAGOMORPH_BG1
        anim_script BG1, 7, CENTER
        fixed_draw_order
        move_to_attacker
        move FORWARD, 32
        loop 2
                sfx
                frame 0, 4
                frame 1
                frame 0
                frame 1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0148: Ice Rabbit (bg1) ]

_d04031:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ICE_RABBIT_BG1
        anim_script BG1, 3, CENTER
        fixed_draw_order
        sfx
        wait_scanline
        color_math {ADD, FIXED_CLR}
        move_to_attacker
        move FORWARD, 32
        loop 4
                frame 0, 4
                frame 1
                frame 0
                frame 1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0149: Ice Rabbit (sprite) ]

_d0404c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ICE_RABBIT_SPRITE
        anim_script SPRITE, 3, CENTER
        jump_thread _d04057, _d04060, _d04067, _d0406e

_d04057:
        sfx CURE_A
        move BACK, 4
        move UP, 12
        jump _d04072

_d04060:
        move DOWN, 4
        move BACK, 12
        jump _d04072

_d04067:
        move FORWARD, 4
        move DOWN, 12
        jump _d04072

_d0406e:
        move UP, 4
        move FORWARD, 12

_d04072:
        anim_loop 7
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0146: Pois. Frog (bg1) ]

_d04077:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::POIS_FROG_BG1
        anim_script BG1, 4, BOTTOM
        fixed_draw_order
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        sfx
        loop 4
                frame 0
                frame 1
                frame 2
                frame 0, 6
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0147: Pois. Frog (sprite) ]

_d04090:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::POIS_FROG_SPRITE
        anim_script SPRITE, 4, BOTTOM
        anim_priority 0
        anim_loop 27
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0144: Tapir (bg1) ]

_d04099:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TAPIR_BG1
        anim_script BG1, 1, BOTTOM
        move_to_attacker
        fixed_draw_order
        move FORWARD, 32
        mod_pal BG1, ADD, WHITE, 31
        init_scroll_wave BG1, 4, 3, VERT
        wait_scanline
        color_math {ADD, FIXED_CLR}
        set_scroll_hdma BG1, 6
        frame 0
        hide_bg1_thread
        move DOWN, 8
        sfx
        loop 16
                mod_pal BG1, ADD, WHITE, -2
                update_scroll_wave BG1, VERT
                frame 0
                end_loop
        init_scroll_wave BG1, 3, 3, VERT
        call _d040d9
        init_scroll_wave BG1, 1, 3, VERT
        call _d040d9
        init_scroll_wave BG1, 0, 3, VERT
        call _d040d9
        loop 65
                frame 0
                end_loop
        reset_scroll_hdma BG1
        wait_scanline
        set_scroll_hdma BG1, 3
        end_anim_script

_d040d9:
        loop 16
                update_scroll_wave BG1, VERT
                frame 0
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0145: Tapir (sprite) ]


_d040e0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TAPIR_SPRITE
        anim_script SPRITE, 1, BOTTOM
        loop 96
                blank_frame
                end_loop
        jump_thread _d040ef, _d040f6, _d040ff, _d0410f

_d040ef:
        sfx CURA
        move FORWARD, 8
        jump _d04105

_d040f6:
        loop 4
                blank_frame
                end_loop
        move BACK, 8
        jump _d04105

_d040ff:
        loop 8
                blank_frame
                end_loop
        move DOWN, 8

_d04105:
        anim_speed 4
        anim_loop 8
                frame 0
                end_anim_loop
        anim_loop 8
                frame 0
                end_anim_loop

_d0410f:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0141: Whump (sprite) ]

_d04110:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WHUMP_SPRITE
        anim_script SPRITE, 1, BOTTOM
        move UP, 16
        move FORWARD, 16
        move_rand {15, 15}
        jump _d0411e

; ------------------------------------------------------------------------------

; [ Animation Script $013F: Wombat (sprite) ]

_d0411c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WOMBAT_SPRITE
        anim_script SPRITE, 1, BOTTOM

_d0411e:
        call _d05f25
        fixed_draw_order
        loop 8
                move BACK, 32
                end_loop
        loop 59
                move FORWARD, 4
                auto_frame 4, {0, 2}
                frame 0
                end_loop
        move FORWARD, 4
        move UP, 5
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move UP, 4
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move UP, 3
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move UP, 2
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move DOWN, 2
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move DOWN, 2
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move DOWN, 2
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move DOWN, 3
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move DOWN, 4
        auto_frame 4, {0, 2}
        frame 0
        move FORWARD, 4
        move DOWN, 5
        auto_frame 4, {0, 2}
        frame 0
        loop 59
                move FORWARD, 4
                auto_frame 4, {0, 2}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0140: Wombat (bg1) ]

_d0418b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WOMBAT_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WHUMP_BG1
        anim_script BG1, 1, BOTTOM
        loop 65
                blank_frame
                end_loop
        anim_speed 5
        frame 0
        frame 1
        frame 2
        frame 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $013D: Cokatrice (sprite) ]

_d04198:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::COKATRICE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        loop 5
                move UP_BACK, 32
                end_loop
        sfx STEAL
        loop 40
                move DOWN_FORWARD, 4
                frame 0
                end_loop
        loop 40
                move UP_FORWARD, 4
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $013E: Cokatrice (bg1) ]

_d041b0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::COKATRICE_BG1
        anim_script BG1
        loop 40
                blank_frame
                end_loop
        sfx
        anim_speed 4
        frame 0
        frame 1
        frame 2
        frame 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $013C: Surge, Slide (sprite) ]

_d041bf:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SURGE_SPRITE
        anim_script SPRITE
        loop 8
                blank_frame
                end_loop
        target_priority 2
        loop 65
                blank_frame
                end_loop
        loop 16
                move_target FORWARD, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $013A: Surge, Slide (bg1) ]

_d041d5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SURGE_BG1
        anim_script BG1
        fixed_draw_order
        sprite_priority 3
        move_bg1_here
        sfx
        loop 8
                move BACK, 32
                end_loop
        frame 0
        hide_bg1_thread
        loop 129
                move FORWARD, 2
                cycle_pal BG1_ANIM, -3, {1, 7}
                scroll_bg {+2, 0}
                frame 0
                move FORWARD, 2
                cycle_pal BG1_ANIM, -3, {1, 7}
                scroll_bg {-2, 0}
                frame 0
                end_loop
        scroll_bg {0, 0}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $013B: Surge, Slide (bg3) ]

_d04200:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SURGE_BG3
        anim_script BG3
        move_bg3_here
        init_scroll_wave BG3, 8, 1, HORZ
        loop 8
                move BACK, 32
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 7
        update_scroll_wave BG3, HORZ
        blank_frame
        frame 0
        hide_bg3_thread
        loop 256
                move FORWARD, 2
                update_scroll_wave BG3, HORZ
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0139: Snowball (sprite) ]

_d04225:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SNOWBALL_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        move UP_FORWARD, 16
        anim_priority 2
        jump_thread _d04238, _d04234, _d04238

_d04234:
        move UP, 32
        back_sprite

_d04238:
        sfx
        call _d04244
        call _d04244
        call _d04244
        end_anim_script

_d04244:
        move_rand {31, 31}
        loop 5
                move UP_BACK, 32
                end_loop
        loop 20
                move DOWN_FORWARD, 8
                frame 0
                end_loop
        anim_target_pal
        frame 1
        restore_target_pal
        frame 1
        anim_target_pal
        frame 1
        restore_target_pal
        anim_loop 5
                frame 2, 3
                end_anim_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0138: Cave In, Lode Stone (sprite) ]

_d04264:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CAVE_IN_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        anim_priority 2
        move FORWARD, 32
        jump_thread _d04273, _d0427d, _d04287

_d04273:
        call _d043a0
        call _d043a0
        call _d042de
        end_anim_script

_d0427d:
        call _d042de
        call _d04291
        call _d043a0
        end_anim_script

_d04287:
        call _d043a0
        call _d042de
        call _d042de
        end_anim_script

_d04291:
        sfx
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 0
                end_loop
        move UP, 5
        frame 0
        move UP, 4
        frame 0
        move UP, 3
        frame 0
        move UP, 3
        frame 0
        move UP, 2
        frame 0
        move UP, 2
        frame 0
        move UP, 2
        frame 0
        move UP, 1
        frame 0
        move UP, 1
        frame 0
        move UP, 1
        frame 0
        move DOWN, 1
        frame 0
        move DOWN, 1
        frame 0
        move DOWN, 1
        frame 0
        move DOWN, 2
        frame 0
        move DOWN, 2
        frame 0
        move DOWN, 2
        frame 0
        move DOWN, 3
        frame 0
        move DOWN, 3
        frame 0
        move DOWN, 4
        frame 0
        move DOWN, 5
        frame 0
        return

_d042de:
        sfx
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 0
                end_loop
        move UP, 5
        move FORWARD, 2
        anim_target_pal
        scroll_bg {+2, 0}
        frame 0
        move UP, 4
        move FORWARD, 2
        restore_target_pal
        scroll_bg {-2, 0}
        frame 0
        move UP, 3
        move FORWARD, 2
        anim_target_pal
        scroll_bg {+2, 0}
        frame 0
        move UP, 3
        move FORWARD, 2
        restore_target_pal
        scroll_bg {-2, 0}
        frame 0
        move UP, 2
        move FORWARD, 2
        anim_target_pal
        scroll_bg {+2, 0}
        frame 0
        move UP, 2
        move FORWARD, 2
        restore_target_pal
        scroll_bg {-2, 0}
        frame 0
        move UP, 2
        move FORWARD, 2
        anim_target_pal
        scroll_bg {+2, 0}
        frame 0
        move UP, 1
        move FORWARD, 2
        restore_target_pal
        scroll_bg {-2, 0}
        frame 0
        move UP, 1
        move FORWARD, 2
        anim_target_pal
        scroll_bg {+2, 0}
        frame 0
        move UP, 1
        move FORWARD, 2
        restore_target_pal
        scroll_bg {-2, 0}
        frame 0
        move DOWN, 1
        move FORWARD, 2
        anim_target_pal
        scroll_bg {+2, 0}
        frame 0
        move DOWN, 1
        move FORWARD, 2
        restore_target_pal
        scroll_bg {-2, 0}
        frame 0
        move DOWN, 1
        move FORWARD, 2
        anim_target_pal
        scroll_bg {+2, 0}
        frame 0
        move DOWN, 2
        move FORWARD, 2
        restore_target_pal
        scroll_bg {-2, 0}
        frame 0
        move DOWN, 2
        move FORWARD, 2
        scroll_bg {0, 0}
        frame 0
        move DOWN, 2
        move FORWARD, 2
        frame 0
        move DOWN, 3
        move FORWARD, 2
        frame 0
        move DOWN, 3
        move FORWARD, 2
        frame 0
        move DOWN, 4
        move FORWARD, 2
        frame 0
        move DOWN, 5
        move FORWARD, 2
        frame 0
        move BACK, 20
        move BACK, 20
        return

_d043a0:
        sfx
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 0
                end_loop
        move UP, 5
        move BACK, 2
        frame 0
        move UP, 4
        move BACK, 2
        frame 0
        move UP, 3
        move BACK, 2
        frame 0
        move UP, 3
        move BACK, 2
        frame 0
        move UP, 2
        move BACK, 2
        frame 0
        move UP, 2
        move BACK, 2
        frame 0
        move UP, 2
        move BACK, 2
        frame 0
        move UP, 1
        move BACK, 2
        frame 0
        move UP, 1
        move BACK, 2
        frame 0
        move UP, 1
        move BACK, 2
        frame 0
        move DOWN, 1
        move BACK, 2
        frame 0
        move DOWN, 1
        move BACK, 2
        frame 0
        move DOWN, 1
        move BACK, 2
        frame 0
        move DOWN, 2
        move BACK, 2
        frame 0
        move DOWN, 2
        move BACK, 2
        frame 0
        move DOWN, 2
        move BACK, 2
        frame 0
        move DOWN, 3
        move BACK, 2
        frame 0
        move DOWN, 3
        move BACK, 2
        frame 0
        move DOWN, 4
        move BACK, 2
        frame 0
        move DOWN, 5
        move BACK, 2
        frame 0
        move FORWARD, 20
        move FORWARD, 20
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0137: Plasma (sprite) ]

_d04419:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PLASMA_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        reset_ellipse
        jump_thread _d0444a, _d04442, _d04426

_d04426:
        mod_pal BG2, SUB, YELLOW, 0
        loop 16
                mod_pal BG2, SUB, YELLOW, +1
                cycle_pal SPRITE_ANIM, -1, {1, 7}
                blank_frame
                end_loop
        loop 161
                cycle_pal SPRITE_ANIM, -1, {1, 7}
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, SUB, YELLOW, -1
                cycle_pal SPRITE_ANIM, -1, {1, 7}
                blank_frame
                end_loop
        end_anim_script

_d04442:
        sfx
        move_ellipse +96, +64
        jump _d04451

_d0444a:
        loop 8
                blank_frame
                end_loop
        move_ellipse +96, -64

_d04451:
        update_ellipse_priority
        move_ellipse 0, 0
        frame 0, 4
        frame 1, 4
        frame 2, 4
        call _d0446f
        call _d0446f
        call _d0447c
        call _d0447c
        end_anim_script

_d0446f:
        loop 32
                update_ellipse_priority
                move_ellipse 0, +4
                frame 3
                end_loop
        move_ellipse 0, -128
        return

_d0447c:
        loop 32
                update_ellipse_priority
                move_ellipse 0, +4
                move UP, 3
                frame 3
                end_loop
        move_ellipse 0, -128
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0135: El Nino (sprite) ]

_d0448b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EL_NINO_SPRITE
        anim_script SPRITE, 3, CENTER
        anim_priority 2
        fixed_draw_order
        loop 16
                blank_frame
                end_loop
        jump_thread _d0496c, _d04973, _d0497a, _d04527

; ------------------------------------------------------------------------------

; [ Animation Script $0136: El Nino (bg1) ]

_d0449e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EL_NINO_BG1
        anim_script BG1
        move_bg1_here
        sprite_priority 2
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 31
        bg_screen_pos BG1, TOP_RIGHT
        frame 0, 2
        hide_bg1_thread
        sfx
        loop 16
                mod_pal BG1, SUB, WHITE, -2
                move FORWARD, 1
                wait_scanline 200
                update_rainbow_gradient 0
                frame 0
                end_loop
        mod_pal BG1, ADD, WHITE, 0
        loop 16
                mod_pal BG1, ADD, WHITE, +2
                move FORWARD, 1
                wait_scanline 200
                update_rainbow_gradient 0
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, FIXED_CLR}, BG1, {BG2, SPRITE}
        loop 16
                mod_pal BG1, ADD, WHITE, -2
                move FORWARD, 1
                wait_scanline 200
                update_rainbow_gradient 0
                frame 0
                end_loop
        loop 33
                move FORWARD, 1
                wait_scanline 200
                update_rainbow_gradient 0
                frame 0
                end_loop
        loop 16
                mod_pal BG1, ADD, WHITE, +2
                move FORWARD, 1
                wait_scanline 200
                update_rainbow_gradient 0
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        loop 16
                mod_pal BG1, ADD, WHITE, -2
                move FORWARD, 1
                wait_scanline 200
                update_rainbow_gradient 0
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 16
                mod_pal BG1, SUB, WHITE, +2
                move FORWARD, 1
                wait_scanline 200
                update_rainbow_gradient 0
                frame 0
                end_loop
        mainscreen_layers {BG2, SPRITE}
        reset_gradient
        show_bg1_thread
        bg_screen_pos BG1, TOP_RIGHT
        frame 0

_d04527:
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0134: Sonic Boom, Shimsham (sprite) ]

_d04528:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SONIC_BOOM_SPRITE
        anim_script SPRITE
        move_to_attacker
        calc_vec
        vec_offset 8
        jump_thread _d04535, _d04549, _d0455b

_d04535:
        sfx MAGITEK_BEAM
:       auto_frame 1, {0, 7}
        frame 0
        move_vec :-, 8
        reset_frame_offset
        sfx
        anim_speed 4
        anim_loop 24
                frame 0
                end_anim_loop
        end_anim_script

_d04549:
:       auto_frame 1, {0, 7}
        frame 0
        move_vec :-, 8
        reset_frame_offset
        loop 8
                anim_target_pal
                blank_frame
                restore_target_pal
                blank_frame
                end_loop

_d0455b:
:       auto_frame 1, {0, 7}
        frame 0
        move_vec :-, 8
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0132: Land Slide (sprite) ]

_d04563:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LAND_SLIDE_SPRITE
        anim_script SPRITE, 1, BOTTOM
        hide_bg1_thread
        anim_priority 2
        move FORWARD, 32
        jump_thread _d0457c, _d0459c, _d04588, _d04592, _d04592, _d04588, _d0459c, _d0457e

_d0457c:
        sfx
_d0457e:
        call _d045a6
        call _d0467a
        call _d04600
        end_anim_script

_d04588:
        call _d0462d
        call _d045d3
        call _d0467a
        end_anim_script

_d04592:
        call _d045d3
        call _d04600
        call _d046b7
        end_anim_script

_d0459c:
        call _d046b7
        call _d0462d
        call _d04600
        end_anim_script

_d045a6:
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 0
                end_loop
        move UP, 4
        frame 0
        move UP, 3
        frame 0
        move UP, 2
        frame 0
        move UP, 1
        frame 0
        move UP, 1
        frame 0
        move DOWN, 1
        frame 0
        move DOWN, 1
        frame 0
        move DOWN, 2
        frame 0
        move DOWN, 3
        frame 0
        move DOWN, 4
        frame 0
        return

_d045d3:
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 1
                end_loop
        move UP, 4
        frame 1
        move UP, 3
        frame 1
        move UP, 2
        frame 1
        move UP, 1
        frame 1
        move UP, 1
        frame 1
        move DOWN, 1
        frame 1
        move DOWN, 1
        frame 1
        move DOWN, 2
        frame 1
        move DOWN, 3
        frame 1
        move DOWN, 4
        frame 1
        return

_d04600:
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 2
                end_loop
        move UP, 4
        frame 2
        move UP, 3
        frame 2
        move UP, 2
        frame 2
        move UP, 1
        frame 2
        move UP, 1
        frame 2
        move DOWN, 1
        frame 2
        move DOWN, 1
        frame 2
        move DOWN, 2
        frame 2
        move DOWN, 3
        frame 2
        move DOWN, 4
        frame 2
        return

_d0462d:
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 3
                end_loop
        move UP, 4
        move FORWARD, 1
        anim_target_pal
        frame 3
        move UP, 3
        move FORWARD, 1
        restore_target_pal
        frame 3
        move UP, 2
        move FORWARD, 1
        anim_target_pal
        frame 3
        move UP, 1
        move FORWARD, 1
        restore_target_pal
        frame 3
        move UP, 1
        move FORWARD, 1
        anim_target_pal
        frame 3
        move DOWN, 1
        move FORWARD, 1
        restore_target_pal
        frame 3
        move DOWN, 1
        move FORWARD, 1
        anim_target_pal
        frame 3
        move DOWN, 2
        move FORWARD, 1
        restore_target_pal
        frame 3
        move DOWN, 3
        frame 3
        move DOWN, 4
        frame 3
        return

_d0467a:
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 3
                end_loop
        move UP, 4
        move FORWARD, 1
        frame 3
        move UP, 3
        move FORWARD, 1
        frame 3
        move UP, 2
        move FORWARD, 1
        frame 3
        move UP, 1
        move FORWARD, 1
        frame 3
        move UP, 1
        move FORWARD, 1
        frame 3
        move DOWN, 1
        move FORWARD, 1
        frame 3
        move DOWN, 1
        move FORWARD, 1
        frame 3
        move DOWN, 2
        move FORWARD, 1
        frame 3
        move DOWN, 3
        frame 3
        move DOWN, 4
        frame 3
        return

_d046b7:
        move_rand {63, 0}
        loop 5
                move UP, 32
                end_loop
        loop 40
                move DOWN, 4
                frame 3
                end_loop
        move UP, 4
        move BACK, 1
        frame 3
        move UP, 3
        move BACK, 1
        frame 3
        move UP, 2
        move BACK, 1
        frame 3
        move UP, 1
        move BACK, 1
        frame 3
        move UP, 1
        move BACK, 1
        frame 3
        move DOWN, 1
        move BACK, 1
        frame 3
        move DOWN, 1
        move BACK, 1
        frame 3
        move DOWN, 2
        move BACK, 1
        frame 3
        move DOWN, 3
        frame 3
        move DOWN, 4
        frame 3
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0131: Specter (sprite) ]

_d046f4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SPECTER_SPRITE
        anim_script SPRITE, 3, CENTER
        jump _d04763

; ------------------------------------------------------------------------------

; [ Animation Script $0130: Specter (bg1) ]

_d046f9:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SPECTER_BG1
        anim_script BG1, 3, CENTER
        reset_ellipse
        move_ellipse +32, +96
        loop 11
                move_ellipse +1, +1
                move UP, 1
                frame 0
                end_loop
        loop 11
                move_ellipse -1, +1
                move UP, 1
                frame 1
                end_loop
        loop 11
                move_ellipse +1, +1
                move DOWN, 1
                frame 0
                end_loop
        loop 11
                move_ellipse +1, +1
                move DOWN, 1
                frame 1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $012E: Wind Slash, Gale Cut (sprite) ]

_d04725:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WIND_SLASH_SPRITE
        anim_script SPRITE, 4, CENTER
        loop 8
                blank_frame
                end_loop
        anim_loop 23
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $012F: Wind Slash, Gale Cut (bg1) ]

_d04730:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WIND_SLASH_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        sprite_priority 2
        mod_pal BG1, SUB, WHITE, 31
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        frame 0
        hide_bg1_thread
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 129
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $012C: Elf Fire, Fire Wall (sprite) ]

_d0475f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ELF_FIRE_SPRITE
        anim_script SPRITE, 3, CENTER
        anim_priority 0

_d04763:
        fixed_draw_order
        reset_ellipse
        jump_thread _d04778, _d04787, _d04794, _d047a1, _d047ae, _d047bb, _d047c8, _d047d5

_d04778:
        sfx
        move_ellipse +64, 0
        call _d047df
        call _d047ec
        call _d04808
        end_anim_script

_d04787:
        move_ellipse +64, +47
        call _d04808
        call _d04808
        call _d047f9
        end_anim_script

_d04794:
        move_ellipse +64, +61
        call _d047ec
        call _d047f9
        call _d04808
        end_anim_script

_d047a1:
        move_ellipse +64, +104
        call _d047ec
        call _d047df
        call _d047f9
        end_anim_script

_d047ae:
        move_ellipse +64, -126
        call _d047ec
        call _d047df
        call _d047f9
        end_anim_script

_d047bb:
        move_ellipse +64, -96
        call _d04808
        call _d047df
        call _d047f9
        end_anim_script

_d047c8:
        move_ellipse +64, -58
        call _d047ec
        call _d047df
        call _d04808
        end_anim_script

_d047d5:
        call _d047df
        call _d047ec
        call _d04808
        end_anim_script

_d047df:
        loop 16
                move_ellipse +1, +1
                auto_frame 3, {0, 4}
                update_ellipse_priority
                frame 0
                end_loop
        return

_d047ec:
        loop 16
                move_ellipse -1, +1
                auto_frame 3, {0, 4}
                update_ellipse_priority
                frame 0
                end_loop
        return

_d047f9:
        loop 16
                move_ellipse 0, +1
                auto_frame 3, {0, 4}
                move DOWN, 1
                update_ellipse_priority
                frame 0
                end_loop
        return

_d04808:
        loop 16
                move_ellipse 0, +1
                auto_frame 3, {0, 4}
                update_ellipse_priority
                move UP, 1
                frame 0
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $012B: Antlion (bg1) ]

_d04817:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ANTLION_BG1
        anim_script BG1, 1, BOTTOM
        target_priority 2
        fixed_draw_order
        mod_pal BG1, SUB, WHITE, 31
        loop 9
                move DOWN, 16
                end_loop
        frame 0
        hide_bg1_thread
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                end_loop
        jump_hit _d0483d
        loop 128
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                end_loop
        end_anim_script

_d0483d:
        loop 128
                cycle_pal BG1_ANIM, 2, {1, 6}
                move_target DOWN, 1
                frame 0
                hide_bg1_thread
                end_loop
        hide_target_monsters
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                end_loop
        loop 4
                move_target UP, 32
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $012A: Sand Storm, BabaBreath (bg1) ]

_d04859:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SAND_STORM_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        sprite_priority 2
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        sfx
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 65
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 1, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0128: Harvester (sprite) ]

_d04882:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HARVESTER_SPRITE
        anim_script SPRITE, 4, CENTER
        loop 8
                blank_frame
                end_loop
        move UP_FORWARD, 32
        move_rand {31, 31}
        anim_loop 8
                frame 0
                end_anim_loop
        loop 5
                frame 8
                frame 9
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $012D: Harvester, Scar Beam (bg3) ]

_d04897:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HARVESTER_BG3
        anim_script BG3
        move_bg3_here
        mod_pal BG3, SUB, WHITE, 31
        wait_scanline
        bg_screen_pos BG3, TOP_RIGHT
        frame 0, 2
        hide_bg3_thread
        loop 32
                mod_pal BG3, SUB, WHITE, -1
                move FORWARD, 2
                frame 0
                end_loop
        loop 129
                move FORWARD, 2
                frame 0
                end_loop
        loop 32
                mod_pal BG3, SUB, WHITE, +1
                move FORWARD, 2
                frame 0
                end_loop
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0129: Harvester, Scar Beam (bg1) ]

_d048c1:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HARVESTER_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        mod_pal BG1, SUB, WHITE, 31
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        bg_screen_pos BG1, TOP_RIGHT
        frame 0, 2
        sfx
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                move FORWARD, 1
                frame 0
                end_loop
        loop 129
                move FORWARD, 1
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                move FORWARD, 1
                frame 0
                end_loop
        show_bg1_thread
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0126: Rage (bg1) ]

_d048f3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAGE_BG1
        anim_script BG1

_d048f5:
        fixed_draw_order
        sprite_priority 2
        wait_scanline
        mainscreen_layers {BG2, SPRITE}
        set_scroll_hdma BG1, 6
        blank_frame
        wait_scanline
        set_scroll_hdma BG3, 7
        blank_frame
        init_scroll_wave {BG3, BG1}, 7, 31, HORZ
        move_bg1_here
        sfx
        loop 8
                move BACK, 32
                end_loop
        wait_scanline
        mainscreen_layers {BG1, BG2, BG3, SPRITE}
        loop 225
                auto_frame 3, {0, 3}
                move FORWARD, 2
                update_scroll_wave {BG3, BG1}, HORZ
                frame 0
                end_loop
        reset_frame_offset
        wait_scanline
        mainscreen_layers {BG2, SPRITE}
        set_scroll_hdma BG1, 3
        blank_frame
        wait_scanline
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG1
        reset_scroll_hdma BG3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0127: Rage, Inviz Edge (bg3) ]

_d04935:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAGE_BG3
        anim_script BG3
        move_bg3_here
        loop 8
                move BACK, 32
                end_loop
        loop 225
                auto_frame 3, {0, 3}
                move FORWARD, 2
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0125: Sun Bath (extra) ]

_d04948:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SUN_BATH_EXTRA
        anim_script SPRITE
        sfx
        mod_pal BG2, ADD, YELLOW, 0
        loop 16
                mod_pal BG2, ADD, YELLOW, +1
                blank_frame
                end_loop
        loop 65
                blank_frame
                end_loop
        loop 16
                mod_pal BG2, ADD, YELLOW, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0124: Sun Bath (sprite) ]

_d0495f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SUN_BATH_SPRITE
        anim_script SPRITE, 3, CENTER
        fixed_draw_order
        jump_thread _d0496c, _d04973, _d0497a, _d04981

_d0496c:
        move BACK, 4
        move UP, 12
        jump _d04985

_d04973:
        move DOWN, 4
        move BACK, 12
        jump _d04985

_d0497a:
        move FORWARD, 4
        move DOWN, 12
        jump _d04985

_d04981:
        move UP, 4
        move FORWARD, 12

_d04985:
        anim_loop 5
                frame 0
                end_anim_loop
        anim_loop 5
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0123:  ]

_d0498e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_291
        anim_script SPRITE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0122: Moon Song (sprite) ]

_d04991:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FENRIR_SPRITE
        anim_script SPRITE
        jump_battle_type _d0499b, _d049a2, _d049a9

_d0499b:
        move_xy {208, 96}
        jump _d049ad

_d049a2:
        move_xy {48, 96}
        jump _d049ad

_d049a9:
        move_xy {128, 96}

_d049ad:
        anim_priority 0
        mod_pal SPRITE, SUB, WHITE, 31
        mod_pal BG2, SUB, YELLOW, 0
        loop 32
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, SUB, YELLOW, +1
                blank_frame
                end_loop
        loop 129
                blank_frame
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        loop 32
                mod_pal SPRITE, SUB, WHITE, -1
                frame 0
                end_loop
        loop 97
                frame 0
                end_loop
        loop 32
                mod_pal SPRITE, SUB, WHITE, +1
                mod_pal BG2, SUB, YELLOW, -1
                frame 0
                end_loop
        color_math {ADD, SUBSCREEN}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0121: Moon Song (bg1) ]

_d049de:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FENRIR_BG1
        anim_script BG1
        fixed_draw_order
        call _d05516
        sfx
        jump_battle_type _d049ef, _d049f6, _d049fd

_d049ef:
        move_xy {208, 96}
        jump _d04a01

_d049f6:
        move_xy {48, 96}
        jump _d04a01

_d049fd:
        move_xy {128, 96}

_d04a01:
        normal_draw_order
        blank_frame
        init_moon_song_effect
        set_scroll_hdma BG1, 0
        update_moon_song_effect
        blank_frame
        frame 0
        fixed_draw_order
        loop 127
                update_moon_song_effect
                frame 0
                end_loop
        loop 96
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        normal_draw_order
        loop 9
                frame 0
                blank_frame
                end_loop
        fixed_draw_order
        loop 65
                blank_frame
                end_loop
        wait_scanline
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        call _d05549
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0120: Atom Edge, True Edge (sprite) ]

_d04a3a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ODIN_SPRITE
        anim_script SPRITE
        loop 48
                blank_frame
                end_loop
        jump_dir _d04a46, _d04a4d

_d04a46:
        move_xy {192, 43}
        jump _d04a51

_d04a4d:
        move_xy {64, 43}

_d04a51:
        call _d04ccb
        loop 17
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $011D: Sonic Dive (sprite) ]

_d04a59:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PALIDOR_SPRITE
        anim_script SPRITE
        save_attacker_char_pos
        reset_char_vec_offset
        loop 9
                blank_frame
                end_loop
        blank_frame
        wait_bg1_reach_target
        jump_battle_type _d04a80, _d04a80, _d04a6e

_d04a6e:
        jump_dir _d04a74, _d04a7a

_d04a74:
        set_vec_target {120, 76}
        jump _d04a83

_d04a7a:
        set_vec_target {136, 76}
        jump _d04a83

_d04a80:
        set_vec_target {128, 76}

_d04a83:
        calc_vec
:       blank_frame
        move_vec_jump :-, 5
        sprite_priority 2
        loop 64
                move_attacker FORWARD, 4
                move_attacker UP, 1
                blank_frame
                end_loop
        hide_attacker_char
        restore_attacker_char_pos
        disable_step_back
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $011E: Sonic Dive (bg1) ]

_d04a99:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PALIDOR_BG1
        anim_script BG1
        move_xy {128, 92}
        sfx
        loop 8
                move BACK, 32
                end_loop
        frame 0
        hide_bg1_thread
        loop 64
                move FORWARD, 4
                frame 0
                end_loop
        loop 64
                move FORWARD, 4
                move UP, 1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $011A: Chaos Wing (bg1) ]

_d04ab8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MADUIN_BG1
        anim_script BG1
        fixed_draw_order
        sprite_priority 2
        move_bg1_here
        call _d05516
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        sfx DEFAULT, CENTER
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG2, SUB, WHITE, 0
        frame 0
        hide_bg1_thread
        loop 16
                mod_pal BG2, SUB, WHITE, +1
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 129
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 16
                mod_pal BG2, SUB, WHITE, -1
                frame 0
                end_loop
        show_bg1_thread
        blank_frame
        wait_scanline
        color_math {ADD, FIXED_CLR}
        call _d05549
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $011B: Chaos Wing (bg3) ]

_d04b0b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MADUIN_BG3
        anim_script BG3
        move_bg3_here
        loop 48
                frame 9
                end_loop
        init_circle {128, 76}, 0, {222, 255}, 128, 0
        update_circle
        frame 0
        loop 32
                auto_frame 2, {0, 8}
                wait_scanline 216
                zoom_circle 0
                update_circle
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        loop 42
                auto_frame 2, {0, 8}
                wait_scanline 216
                zoom_circle +2
                update_circle
                frame 0
                end_loop
        loop 44
                auto_frame 2, {0, 8}
                wait_scanline 216
                zoom_circle 0
                update_circle
                frame 0
                end_loop
        loop 43
                auto_frame 2, {0, 8}
                wait_scanline 216
                zoom_circle -2
                update_circle
                frame 0
                end_loop
        mainscreen_layers {BG1, BG2, SPRITE}
        reset_frame_offset
        loop 32
                wait_scanline 216
                update_circle
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $011C: Chaos Wing (sprite) ]

_d04b68:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MADUIN_SPRITE
        anim_script SPRITE
        move_xy {136, 84}
        loop 48
                blank_frame
                end_loop
        call _d04ccb
        loop 129
                frame 0
                end_loop
        call _d04cc2
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0117: Sun Flare (sprite) ]

_d04b7d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BAHAMUT_SPRITE
        anim_script SPRITE, 2, CENTER
        anim_priority 3
        loop 47
                blank_frame
                end_loop
        jump_dir _d04b8b, _d04b92

_d04b8b:
        move_xy {48, 64}
        jump _d04b96

_d04b92:
        move_xy {208, 64}

_d04b96:
        loop 5
                move_rand {127, 63}
                frame 0
                frame 1
                frame 2
                frame 3
                move DOWN_FORWARD, 8
                frame 4
                move DOWN_FORWARD, 8
                frame 5
                move DOWN_FORWARD, 8
                frame 6
                move DOWN_FORWARD, 8
                frame 7
                move UP_BACK, 32
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0118: Sun Flare (bg3) ]

_d04baf:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BAHAMUT_BG3
        anim_script BG3
        move_bg3_here
        bg_screen_pos BG3, TOP_RIGHT
        frame 0
        bg_screen_pos BG3, BOTTOM_LEFT
        frame 0
        bg_screen_pos BG3, BOTTOM_RIGHT
        frame 0, 2
        jump_dir _d04c01, _d04bc3

_d04bc3:
        init_circle {51, 74}, 0, {222, 255}, 128, 0
        hide_bg3_thread
        loop 68
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG1, BG2, SPRITE}
        loop 128
                move_circle {+3, +1}, +3
                move DOWN_FORWARD, 12
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        mod_pal BG3, SUB, WHITE, 0
        loop 32
                move_circle {+1, +1}, 0
                move DOWN_FORWARD, 12
                mod_pal BG3, SUB, WHITE, +1
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        bg_screen_pos BG3, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG3, BOTTOM_RIGHT
        blank_frame
        end_anim_script

_d04c01:
        init_circle {205, 74}, 0, {222, 255}, 128, 0
        hide_bg3_thread
        loop 68
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG1, BG2, SPRITE}
        loop 128
                move_circle {-3, +1}, +3
                move DOWN_FORWARD, 12
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        mod_pal BG3, SUB, WHITE, 0
        loop 32
                move_circle {-1, +1}, 0
                move DOWN_FORWARD, 12
                mod_pal BG3, SUB, WHITE, +1
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        bg_screen_pos BG3, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG3, BOTTOM_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0119: Sun Flare (bg1) ]

_d04c3f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BAHAMUT_BG1
        anim_script BG1
        set_blank_frame 31
        fixed_draw_order
        call _d05516
        sfx
        jump_dir _d04c4e, _d04c55

_d04c4e:
        move_xy {192, 64}
        jump _d04c59

_d04c55:
        move_xy {64, 64}

_d04c59:
        loop 8
                move DOWN_FORWARD, 32
                end_loop
        mod_pal BG1, ADD, WHITE, 31
        mod_pal BG2, SUB, YELLOW, 0
        frame 0
        hide_bg1_thread
        loop 32
                move UP_BACK, 8
                mod_pal BG1, ADD, WHITE, -1
                mod_pal BG2, SUB, YELLOW, +1
                frame 0
                end_loop
        loop 129
                frame 0
                end_loop
        loop 16
                mod_pal BG1, ADD, WHITE, +1
                mod_pal BG2, SUB, YELLOW, -1
                frame 0
                mod_pal BG1, ADD, WHITE, +1
                mod_pal BG2, SUB, YELLOW, -1
                blank_frame
                end_loop
        show_bg1_thread
        call _d05549
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0115: Group Hug (bg1) ]

_d04c86:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STARLET_BG1
        anim_script BG1
        move_bg1_here
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        sfx
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 96
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0116: Group Hug (sprite) ]

_d04cab:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STARLET_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_xy {128, 96}
        anim_priority 3
        sprite_priority 2
        call _d04ccb
        loop 96
                frame 0
                end_loop
        call _d04cc2
        end_anim_script

; ------------------------------------------------------------------------------

; *** bug *** There's no end_loop in this subroutine. I think this is a bug
_d04cc2:
        loop 16
                mod_pal SPRITE, ADD, WHITE, +1
                frame 0
                mod_pal SPRITE, ADD, WHITE, +1
                blank_frame
                return

_d04ccb:
        mod_pal SPRITE, ADD, WHITE, 31
        loop 32
                mod_pal SPRITE, ADD, WHITE, -1
                frame 0
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0112: Reviver (sprite) ]

_d04cd4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SRAPHIM_SPRITE
        anim_script SPRITE
        loop 193
                blank_frame
                end_loop
        jump _d03f39

; ------------------------------------------------------------------------------

; [ Animation Script $0113: Reviver (bg3) ]

_d04cdd:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SRAPHIM_BG3
        anim_script BG3
        move_bg3_here
        mod_pal BG3, SUB, WHITE, 31
        frame 0
        hide_bg3_thread
        sfx STARLET, CENTER
        loop 32
                mod_pal BG3, SUB, WHITE, -1
                frame 0
                end_loop
        loop 161
                frame 0
                end_loop
        loop 32
                mod_pal BG3, SUB, WHITE, +1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0114: Reviver (bg1) ]

_d04cfa:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SRAPHIM_BG1
        anim_script BG1
        fixed_draw_order
        move_xy {128, 96}
        sprite_priority 2
        loop 6
                move DOWN_BACK, 32
                end_loop
        loop 32
                blank_frame
                end_loop
        loop 161
                move UP_FORWARD, 2
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $010F: Rebirth (bg3) ]

_d04d14:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PHOENIX_BG3
        anim_script BG3
        jump_battle_type _d04d1e, _d04d25, _d04d2c

_d04d1e:
        move_xy {208, 96}
        jump _d04d30

_d04d25:
        move_xy {48, 96}
        jump _d04d30

_d04d2c:
        move_xy {128, 96}

_d04d30:
        anim_loop 4
                frame 0, 4
                end_anim_loop
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0110: Rebirth (bg1) ]

_d04d39:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PHOENIX_BG1
        anim_script BG1
        move_bg1_here
        sfx
        hide_bg1_thread
        loop 16
                blank_frame
                end_loop
        show_bg1_thread
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        loop 32
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 129
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 32
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0111: Rebirth (sprite) ]

_d04d6c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PHOENIX_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_xy {128, 96}
        anim_priority 3
        sprite_priority 2
        jump_battle_type _d04d80, _d04d87, _d04d8e

_d04d80:
        move_xy {208, 96}
        jump _d04d92

_d04d87:
        move_xy {48, 96}
        jump _d04d92

_d04d8e:
        move_xy {128, 96}

_d04d92:
        loop 14
                blank_frame
                end_loop
        call _d04ccb
        loop 65
                frame 0
                end_loop
        loop 32
                mod_pal SPRITE, ADD, YELLOW, +1
                frame 0
                end_loop
        loop 16
                frame 0
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $010C: Heal Horn (bg1) ]

_d04da9:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNICORN_BG1
        anim_script BG1
        move_xy {128, 76}
        mod_pal BG2, SUB, YELLOW, 0
        mod_pal BG1, SUB, WHITE, 0
        sfx DEFAULT, CENTER
        init_circle {128, 76}, 0, {222, 255}, 128, 0
        frame 0
        hide_bg1_thread
        loop 39
                cycle_pal BG1_ANIM, 2, {1, 6}
                zoom_circle +2
                mod_pal BG2, SUB, YELLOW, +1
                wait_scanline 216
                update_circle
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, BG3, SPRITE}
        loop 32
                cycle_pal BG1_ANIM, 2, {1, 6}
                wait_scanline 216
                mod_pal BG2, SUB, YELLOW, -1
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $010D: Heal Horn (bg3) ]

_d04de5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNICORN_BG3
        anim_script BG3, 4, CENTER
        move_xy {128, 76}
        anim_loop 9
                frame 0
                end_anim_loop
        anim_loop 9
                frame 0
                end_anim_loop
        anim_loop 9
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $010E: Heal Horn (sprite) ]

_d04df8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNICORN_SPRITE
        anim_script SPRITE, 1, SCREEN
        fixed_draw_order
        move_xy {128, 96}
        anim_priority 3
        sprite_priority 2
        call _d04ccb
        loop 33
                frame 0
                end_loop
        loop 16
                mod_pal SPRITE, ADD, WHITE, +1
                frame 0
                mod_pal SPRITE, ADD, WHITE, +1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $010A: Life Guard (bg1) ]

_d04e15:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KIRIN_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        sfx DEFAULT, CENTER
        init_circle {128, 76}, 0, {222, 255}, 128, 0
        init_scroll_wave BG1, 4, 2, HORZ
        mod_pal BG2, ADD, WHITE, 0
        mod_pal BG1, ADD, WHITE, 0
        mod_pal MONSTER, ADD, WHITE, 0
        mod_pal CHAR, ADD, WHITE, 0
        sprite_priority 2
        wait_scanline
        set_scroll_hdma BG1, 6
        frame 0
        hide_bg1_thread
        loop 32
                zoom_circle +1
                update_circle
                update_scroll_wave BG1, HORZ
                frame 0
                end_loop
        disable_char_pal_update
        loop 32
                mod_pal BG1, ADD, WHITE, +1
                mod_pal BG2, ADD, WHITE, +1
                mod_pal MONSTER, ADD, WHITE, +1
                mod_pal CHAR, ADD, WHITE, +1
                zoom_circle +1
                update_circle
                update_scroll_wave BG1, HORZ
                frame 0
                end_loop
        show_bg1_thread
        frame 15
        hide_bg1_thread
        loop 32
                blank_frame
                end_loop
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                mod_pal MONSTER, ADD, WHITE, -1
                mod_pal CHAR, ADD, WHITE, -1
                blank_frame
                end_loop
        enable_char_pal_update
        wait_scanline
        set_scroll_hdma BG1, 3
        reset_scroll_hdma BG1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $010B: Life Guard (sprite) ]

_d04e76:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KIRIN_SPRITE
        anim_script SPRITE, 1, SCREEN
        fixed_draw_order
        move_xy {128, 96}
        anim_priority 3
        sfx
        call _d04ccb
        loop 17
                frame 0
                end_loop
        loop 32
                mod_pal SPRITE, ADD, WHITE, +1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0108: Ruby Power (bg1) ]

_d04e90:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CARBUNKL_BG1
        anim_script BG1, 3, CENTER
        loop 25
                blank_frame
                end_loop
        jump_battle_type _d04e9e, _d04ea5, _d04eac

_d04e9e:
        move_xy {208, 96}
        jump _d04eb0

_d04ea5:
        move_xy {48, 96}
        jump _d04eb0

_d04eac:
        move_xy {128, 96}

_d04eb0:
        move UP, 9
        move FORWARD, 3
        loop 4
                frame 0
                frame 1
                frame 2
                frame 3
                end_loop
        frame 0
        frame 1
        frame 4
        frame 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0109: Ruby Power (sprite) ]

_d04ec0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CARBUNKL_SPRITE
        anim_script SPRITE, 1, SCREEN
        fixed_draw_order
        sprite_priority 2
        anim_priority 2
        sfx
        jump_battle_type _d04ed2, _d04ed9, _d04ee0

_d04ed2:
        move_xy {208, 96}
        jump _d04ee4

_d04ed9:
        move_xy {48, 96}
        jump _d04ee4

_d04ee0:
        move_xy {128, 96}

_d04ee4:
        wait_scanline
        color_math {ADD, FIXED_CLR}, BG2
        mod_pal SPRITE, ADD, WHITE, 31
        init_blue_gradient 15
        loop 15
                update_blue_gradient -1
                mod_pal SPRITE, ADD, WHITE, -1
                frame 0
                end_loop
        loop 17
                mod_pal SPRITE, ADD, WHITE, -1
                update_blue_gradient 0
                frame 0
                end_loop
        loop 81
                update_blue_gradient 0
                frame 0
                end_loop
        loop 15
                update_blue_gradient +1
                mod_pal SPRITE, ADD, WHITE, +2
                frame 0
                end_loop
        loop 9
                mod_pal SPRITE, ADD, WHITE, +2
                frame 0
                blank_frame
                end_loop
        reset_gradient
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0104: Justice (sprite) ]

_d04f1b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ALEXANDR_SPRITE
        anim_script SPRITE, 1, SCREEN
        loop 207
                blank_frame
                end_loop
        loop 33
                anim_target_pal
                blank_frame
                restore_target_pal
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0105: Justice (bg3) ]

_d04f2b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ALEXANDR_BG3
        anim_script BG3, 4, SCREEN
        move_bg3_here
        move DOWN, 64
        loop 16
                move UP, 2
                frame 0
                end_loop
        loop 16
                move DOWN, 2
                frame 0
                end_loop
        loop 17
                blank_frame
                end_loop
        load_bg3_pal 118
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG1, BG2, SPRITE}
        hi_priority_bg3
        move_bg3_here
        sfx ALEXANDR_B
        frame 3
        frame 4
        loop 5
                frame 5
                end_loop
        move BACK, 8
        loop 9
                frame 6
                frame 7
                frame 8
                end_loop
        mod_pal BG3, SUB, WHITE, 0
        anim_speed 2
        loop 5
                .repeat 3
                frame 6, 2
                mod_pal BG3, SUB, WHITE, +1
                .endrep
                .repeat 3
                frame 7, 2
                mod_pal BG3, SUB, WHITE, +1
                .endrep
                .repeat 3
                frame 8, 2
                mod_pal BG3, SUB, WHITE, +1
                .endrep
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0106: Justice (bg1) ]

_d04f8c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ALEXANDR_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        move_bg1_here
        loop 5
                move BACK, 32
                end_loop
        sfx
        move DOWN, 160
        frame 0
        hide_bg1_thread
        loop 40
                move UP, 2
                move FORWARD, 1
                frame 0
                move UP, 2
                move BACK, 1
                frame 0
                end_loop
        loop 104
                frame 0
                end_loop
        loop 65
                frame 0
                end_loop
        loop 32
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0107: Justice (extra) ]

_d04fc0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ALEXANDR_EXTRA
        anim_script SPRITE, 1, SCREEN
        mod_pal BG1, ADD, WHITE, 31
        mod_pal SPRITE, ADD, WHITE, 31
        jump_thread _d04fcd, _d04fdc, _d05001

_d04fcd:
        move DOWN, 2
        move DOWN_BACK, 2
        loop 127
                blank_frame
                end_loop
        anim_speed 2
        anim_loop 10
                frame 1
                end_anim_loop
        end_anim_script

_d04fdc:
        loop 5
                move DOWN, 32
                end_loop
        move DOWN, 16
        move BACK, 1
        anim_priority 0
        loop 40
                move UP, 2
                move FORWARD, 1
                frame 11
                move UP, 2
                move BACK, 1
                frame 11
                end_loop
        loop 39
                frame 11
                end_loop
        loop 129
                frame 11
                end_loop
        loop 32
                frame 11
                end_loop
        end_anim_script

_d05001:
        loop 5
                move DOWN, 32
                end_loop
        move DOWN, 16
        move BACK, 1
        move UP_BACK, 8
        loop 20
                move UP, 2
                move FORWARD, 1
                blank_frame
                move UP, 2
                move BACK, 1
                blank_frame
                end_loop
        loop 20
                move UP, 2
                move FORWARD, 1
                mod_pal BG1, ADD, WHITE, -1
                mod_pal SPRITE, ADD, WHITE, -1
                frame 0
                move UP, 2
                move BACK, 1
                mod_pal BG1, ADD, WHITE, -1
                mod_pal SPRITE, ADD, WHITE, -1
                frame 0
                end_loop
        loop 32
                frame 0
                end_loop
        loop 6
                move DOWN, 1
                frame 0
                end_loop
        loop 129
                frame 0
                end_loop
        loop 32
                mod_pal BG1, ADD, WHITE, +1
                mod_pal SPRITE, ADD, WHITE, +1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0102: Hope Song (bg3) ]

_d05045:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SIREN_BG3
        anim_script BG3, 1, SCREEN
        move_bg3_here
        mod_pal BG3, SUB, WHITE, 31
        mod_pal BG2, SUB, MAGENTA, 0
        wait_scanline
        set_scroll_hdma BG3, 7
        hide_bg3_thread
        loop 33
                blank_frame
                end_loop
        show_bg3_thread
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG1, BG2, SPRITE}
        bg_screen_pos BG3, TOP_RIGHT
        frame 0, 2
        hide_bg3_thread
        init_scroll_wave BG2, 4, 4, HORZ
        init_scroll_wave BG2, 2, 2, VERT
        init_scroll_wave BG3, 4, 1, HORZ
        init_scroll_wave BG3, 2, 2, VERT
        loop 16
                mod_pal BG3, SUB, WHITE, -2
                update_scroll_wave {BG3, BG2}, {HORZ, VERT}
                move FORWARD, 1
                wait_scanline 216
                mod_pal BG2, SUB, MAGENTA, +2
                frame 0
                end_loop
        copy_monster_pal_color_math
        wait_scanline 208
        frame 0
        enable_monster_color_math
        wait_scanline
        color_math {ADD, FIXED_CLR}, {BG3, SPRITE}
        call _d0511a
        update_rainbow_gradient 14
        call _d0511a
        update_rainbow_gradient 12
        call _d0511a
        update_rainbow_gradient 10
        call _d0511a
        update_rainbow_gradient 8
        call _d0511a
        update_rainbow_gradient 6
        call _d0511a
        update_rainbow_gradient 4
        call _d0511a
        update_rainbow_gradient 2
        loop 129
                update_scroll_wave {BG3, BG2}, {HORZ, VERT}
                move FORWARD, 1
                update_rainbow_gradient 0
                wait_scanline 208
                frame 0
                end_loop

; *** bug *** the rainbow gradient has no effect after this, so this
; command should probably happen later
        disable_monster_color_math
        call _d0511a
        update_rainbow_gradient 2
        call _d0511a
        update_rainbow_gradient 4
        call _d0511a
        update_rainbow_gradient 6
        call _d0511a
        update_rainbow_gradient 8
        call _d0511a
        update_rainbow_gradient 10
        call _d0511a
        update_rainbow_gradient 12
        call _d0511a
        update_rainbow_gradient 14
        reset_gradient
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG1, BG2, SPRITE}
        loop 16
                mod_pal BG3, SUB, WHITE, +2
                mod_pal BG2, SUB, MAGENTA, -2
                update_scroll_wave {BG3, BG2}, {HORZ, VERT}
                move FORWARD, 1
                wait_scanline 208
                frame 0
                end_loop
        wait_scanline
        set_scroll_hdma BG3, 5
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, {HORZ, VERT}
        reset_scroll_hdma BG3
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        reset_gradient
        restore_char_pal
        end_anim_script

_d0511a:
        update_scroll_wave {BG3, BG2}, {HORZ, VERT}
        move FORWARD, 1
        wait_scanline 208
        frame 0
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0101: Hope Song (sprite) ]

_d05122:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SIREN_SPRITE
        anim_script SPRITE
        loop 33
                blank_frame
                end_loop
        jump_dir _d0512e, _d05139

_d0512e:
        move_xy {255, 96}
        move BACK, 64
        jump _d05141

_d05139:
        move_xy {0, 96}
        move BACK, 64

_d05141:
        jump_thread _d0514e, _d05158, _d05162, _d0516c, _d05162, _d05158

_d0514e:
        loop 129
                update_vec_wave_wide 4
                move FORWARD, 3
                frame 0
                end_loop
        end_anim_script

_d05158:
        loop 129
                update_vec_wave_wide 4
                move FORWARD, 3
                frame 1
                end_loop
        end_anim_script

_d05162:
        loop 129
                update_vec_wave_wide 4
                move FORWARD, 3
                frame 2
                end_loop
        end_anim_script

_d0516c:
        loop 129
                update_vec_wave_wide 4
                move FORWARD, 3
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0103: Hope Song (bg1) ]

_d05176:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SIREN_BG1
        anim_script BG1
        fixed_draw_order
        sprite_priority 2
        call _d05516
        sfx
        jump_battle_type _d05189, _d05190, _d05197

_d05189:
        move_xy {208, 96}
        jump _d0519b

_d05190:
        move_xy {48, 96}
        jump _d0519b

_d05197:
        move_xy {128, 96}

_d0519b:
        mod_pal BG1, ADD, WHITE, 31
        loop 16
                mod_pal BG1, ADD, WHITE, -2
                frame 0
                end_loop
        loop 161
                frame 0
                end_loop
        call _d05549
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00FE: Gem Dust (bg1) ]

_d051ab:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHIVA_BG1
        anim_script BG1
        hide_bg1_thread
        loop 16
                blank_frame
                end_loop
        show_bg1_thread
        jump_dir _d051bb, _d051c2

_d051bb:
        move_xy {188, 69}
        jump _d051c6

_d051c2:
        move_xy {68, 69}

_d051c6:
        anim_loop 4
                frame 1, 4
                end_anim_loop
        move_bg1_here
        loop 103
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                hide_bg1_thread
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00FF: Gem Dust (bg3) ]

_d051d9:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHIVA_BG3
        anim_script BG3
        move_bg3_here
        bg_screen_pos BG3, TOP_RIGHT
        frame 6
        hide_bg3_thread
        loop 31
                blank_frame
                end_loop
        show_bg3_thread
        move FORWARD, 64
        anim_loop 6
                frame 0, 4
                end_anim_loop
        move UP, 1
        wait_scanline
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 2, 1, HORZ
        hide_bg3_thread
        loop 66
                update_scroll_wave BG3, HORZ
                frame 5
                end_loop
        show_bg3_thread
        anim_speed 4
        frame 4
        frame 3
        frame 2
        frame 1
        frame 0
        wait_scanline
        set_scroll_hdma BG3, 5
        reset_scroll_hdma BG3
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0100: Gem Dust (sprite) ]

_d05219:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHIVA_SPRITE
        anim_script SPRITE, 1, SCREEN
        fixed_draw_order
        sfx
        sprite_priority 2
        anim_priority 2
        mod_pal BG2, ADD, BLUE, 0
        jump_dir _d0522b, _d05232

_d0522b:
        move_xy {208, 96}
        jump _d05236

_d05232:
        move_xy {48, 96}

_d05236:
        mod_pal SPRITE, ADD, WHITE, 31
        loop 16
                mod_pal SPRITE, ADD, WHITE, -2
                mod_pal BG2, ADD, BLUE, +2
                frame 0
                end_loop
        loop 129
                frame 0
                end_loop
        mod_pal SPRITE, ADD, WHITE, 0
        loop 16
                mod_pal SPRITE, ADD, WHITE, +1
                mod_pal BG2, ADD, BLUE, -1
                frame 0
                mod_pal SPRITE, ADD, WHITE, +1
                mod_pal BG2, ADD, BLUE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00FB: Bolt Fist (bg3) ]

_d05254:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAMUH_BG3
        anim_script BG3, 1, SCREEN
        move_bg3_here
        hide_bg3_thread
        loop 101
                blank_frame
                end_loop
        show_bg3_thread
        anim_speed 4
        loop 3
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                end_loop
        frame 0
        frame 1
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00FC: Bolt Fist (bg1) ]

_d0526f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAMUH_BG1
        anim_script BG1
        hide_bg1_thread
        loop 49
                blank_frame
                end_loop
        jump_battle_type _d0527f, _d05286, _d0528d

_d0527f:
        move_xy {208, 96}
        jump _d05291

_d05286:
        move_xy {48, 96}
        jump _d05291

_d0528d:
        move_xy {128, 96}

_d05291:
        show_bg1_thread
        move UP, 16
        frame 0, 4
        move DOWN, 16
        anim_loop 4
                frame 1, 4
                end_anim_loop
        move_bg1_here
        loop 32
                blank_frame
                end_loop
        anim_speed 4
        loop 5
                mod_pal MONSTER, ADD, YELLOW, 15
                frame 5
                mod_pal MONSTER, ADD, YELLOW, 0
                frame 6
                mod_pal MONSTER, ADD, YELLOW, 15
                frame 7
                mod_pal MONSTER, ADD, YELLOW, 0
                frame 8
                end_loop
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00FD: Bolt Fist (sprite) ]

_d052bb:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAMUH_SPRITE
        anim_script SPRITE, 1, SCREEN
        fixed_draw_order
        sprite_priority 2
        anim_priority 2
        call _d054b8
        wait_scanline
        color_math {ADD, SUBSCREEN}, {BG1, BG3}, {BG2, SPRITE}
        sfx
        mod_pal BG2, ADD, BLUE, 0
        jump_battle_type _d052d8, _d052df, _d052e6

_d052d8:
        move_xy {208, 96}
        jump _d052ea

_d052df:
        move_xy {48, 96}
        jump _d052ea

_d052e6:
        move_xy {128, 96}

_d052ea:
        loop 16
                mod_pal BG2, ADD, BLUE, +2
                blank_frame
                end_loop
        loop 12
                blank_frame
                end_loop
        mod_pal SPRITE, ADD, WHITE, 31
        loop 16
                mod_pal SPRITE, ADD, WHITE, -2
                frame 0
                end_loop
        loop 81
                frame 0
                end_loop
        loop 16
                mod_pal BG2, ADD, BLUE, -2
                blank_frame
                end_loop
        call _d054e7
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00F6: Sea Song (bg1) ]

_d0530a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BISMARK_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        move_bg1_here
        sprite_priority 2
        mod_pal BG2, SUB, YELLOW, 0
        init_scroll_wave BG2, 4, 1, HORZ
        init_scroll_wave BG2, 3, 1, VERT
        sfx
        loop 16
                mod_pal BG2, SUB, YELLOW, +1
                update_scroll_wave BG2, {HORZ, VERT}
                blank_frame
                end_loop
        loop 27
                update_scroll_wave BG2, {HORZ, VERT}
                blank_frame
                end_loop
        loop 8
                move BACK, 32
                end_loop
        anim_loop 15
                .repeat 4
                move FORWARD, 6
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                .endrep
                end_anim_loop
        call _d0535d
        call _d0535d
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        loop 16
                update_scroll_wave BG2, {HORZ, VERT}
                mod_pal BG2, SUB, YELLOW, -1
                blank_frame
                end_loop
        init_scroll_wave BG2, 0, 0, {HORZ, VERT}
        update_scroll_wave BG2, {HORZ, VERT}
        end_anim_script

_d0535d:
        anim_loop 15
                .repeat 2
                move FORWARD, 6
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                .endrep
                bg_screen_pos BG1, TOP_RIGHT
                .repeat 2
                move FORWARD, 6
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                .endrep
                end_anim_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00F7: Sea Song (extra) ]

_d05377:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BISMARK_EXTRA
        anim_script SPRITE, 1, SCREEN
        move_xy {128, 80}
        loop 8
                move BACK, 32
                end_loop
        loop 85
                move FORWARD, 6
                update_vec_wave_wide 2
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00F8: Sea Song (sprite) ]

_d0538c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BISMARK_SPRITE
        anim_script SPRITE, 1, SCREEN
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00F3: Earth Aura (bg1) ]

_d0538f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TERRATO_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        move_bg1_here
        sprite_priority 3
        init_circle {128, 144}, 108, {222, 255}, 108, 0
        update_circle
        loop 35
                blank_frame
                end_loop
        move DOWN, 16
        loop 10
                frame 0
                hide_bg1_thread
                end_loop
        loop 16
                move FORWARD, 2
                move_circle {+2, 0}, 0
                scroll_bg {+2, 0}
                frame 0
                move BACK, 2
                move_circle {-2, 0}, 0
                scroll_bg {-2, 0}
                frame 0
                end_loop
        scroll_bg {0, 0}
        loop 65
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00F4: Earth Aura (bg3) ]

_d053cb:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TERRATO_BG3
        anim_script BG3, 1, SCREEN
        loop 35
                blank_frame
                end_loop
        sfx DEFAULT, CENTER
        move_bg3_here
        frame 4, 2
        frame 3, 2
        frame 2, 2
        frame 1, 2
        frame 0, 2
        loop 65
                blank_frame
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        load_bg3_pal 114
        loop 6
                move DOWN, 32
                end_loop
        init_scroll_wave BG2, 4, 1, HORZ
        loop 26
                auto_frame 2, {0, 2}
                move UP, 8
                update_scroll_wave BG2, HORZ
                frame 5
                end_loop
        loop 65
                auto_frame 2, {0, 2}
                update_scroll_wave BG2, HORZ
                frame 5
                end_loop
        loop 26
                move UP, 8
                auto_frame 2, {0, 2}
                update_scroll_wave BG2, HORZ
                frame 5
                end_loop
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, HORZ
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00F5: Earth Aura (sprite) ]

_d0541a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TERRATO_SPRITE
        anim_script SPRITE
        move_xy {128, 112}
        call _d054b8
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG3, {BG2, SPRITE}
        loop 10
                blank_frame
                end_loop
        loop 6
                move DOWN, 32
                end_loop
        mod_pal BG2, SUB, YELLOW, 0
        loop 26
                move UP, 8
                mod_pal BG2, SUB, YELLOW, +2
                frame 0
                end_loop
        loop 129
                frame 0
                end_loop
        loop 23
                move UP, 8
                mod_pal BG2, SUB, YELLOW, -2
                frame 0
                end_loop
        call _d054e7
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0252: Demon Eye (sprite) ]

_d0544c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHOAT_SPRITE
        anim_script SPRITE
        call _d054b8
        sfx
        anim_priority 2
        mod_pal BG2, SUB, YELLOW, 0
        jump_battle_type _d0545f, _d05466, _d0546d

_d0545f:
        move_xy {208, 112}
        jump _d05471

_d05466:
        move_xy {48, 112}
        jump _d05471

_d0546d:
        move_xy {128, 112}

_d05471:
        mod_pal SPRITE, ADD, WHITE, 31
        loop 16
                mod_pal SPRITE, ADD, WHITE, -2
                mod_pal BG2, SUB, YELLOW, +2
                frame 0
                end_loop
        loop 96
                frame 0
                end_loop
        loop 16
                mod_pal BG2, SUB, YELLOW, -2
                frame 0
                end_loop
        call _d054e7
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0251: Demon Eye (bg1) ]

_d05489:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHOAT_BG1
        anim_script BG1
        fixed_draw_order
        sprite_priority 2
        jump_battle_type _d05497, _d0549e, _d054a5

_d05497:
        move_xy {208, 112}
        jump _d054a9

_d0549e:
        move_xy {48, 112}
        jump _d054a9

_d054a5:
        move_xy {128, 112}

_d054a9:
        move FORWARD, 17
        move DOWN_FORWARD, 3
        loop 65
                blank_frame
                end_loop
        anim_speed 4
        anim_loop 9
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ hide characters for esper attack (sprite) ]

_d054b8:
        set_blank_frame 31
        sfx PRE_GENJU_B
        disable_char_pal_update
        blank_frame
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        char_priority 0
        hide_char_indicator
        mod_pal CHAR, SUB, WHITE, 0
        loop 16
                mod_pal CHAR, SUB, WHITE, +1
                hide_chars
                blank_frame
                mod_pal CHAR, SUB, WHITE, +1
                show_chars
                blank_frame
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}
        hide_chars
        mod_pal CHAR, SUB, WHITE, 0
        return

; ------------------------------------------------------------------------------

; [ show characters after esper attack (sprite) ]

_d054e7:
        set_blank_frame 31
        char_priority 0
        show_chars
        loop 16
                blank_frame
                end_loop
        disable_char_pal_update
        mod_pal CHAR, SUB, WHITE, 31
        blank_frame
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        loop 16
                mod_pal CHAR, SUB, WHITE, -1
                hide_chars
                blank_frame
                show_chars
                mod_pal CHAR, SUB, WHITE, -1
                blank_frame
                end_loop
        char_priority 3
        enable_char_pal_update
        show_char_indicator
        return

; ------------------------------------------------------------------------------

; [ hide characters for esper attack (bg1) ]

_d05516:
        set_blank_frame 15
        sfx PRE_GENJU_B
        hide_bg1_thread
        disable_char_pal_update
        blank_frame
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        char_priority 0
        hide_char_indicator
        mod_pal CHAR, SUB, WHITE, 0
        loop 16
                mod_pal CHAR, SUB, WHITE, +1
                hide_chars
                blank_frame
                mod_pal CHAR, SUB, WHITE, +1
                show_chars
                blank_frame
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}
        hide_chars
        mod_pal CHAR, SUB, WHITE, 0
        show_bg1_thread
        return

; ------------------------------------------------------------------------------

; [ show characters after esper attack (bg1) ]

_d05549:
        set_blank_frame 15
        char_priority 0
        show_chars
        loop 16
                blank_frame
                hide_bg1_thread
                end_loop
        disable_char_pal_update
        mod_pal CHAR, SUB, WHITE, 31
        blank_frame
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG2, SPRITE
        loop 16
                mod_pal CHAR, SUB, WHITE, -1
                hide_chars
                blank_frame
                show_chars
                mod_pal CHAR, SUB, WHITE, -1
                blank_frame
                end_loop
        char_priority 3
        enable_char_pal_update
        show_char_indicator
        show_bg1_thread
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00EE: Inferno (sprite) ]

_d0557c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IFRIT_SPRITE
        anim_script SPRITE, 1, SCREEN
        fixed_draw_order
        sprite_priority 2
        anim_priority 1
        loop 77
                blank_frame
                end_loop
        loop 2
                move BACK, 8
                frame 0, 4
                move FORWARD, 8
                frame 1, 6
                frame 2, 6
                move BACK, 8
                frame 3, 4
                move FORWARD, 8
                frame 4, 6
                frame 5, 6
                end_loop
        move BACK, 8
        loop 4
                move UP, 4
                frame 0
                end_loop
        move FORWARD, 8
        loop 6
                move UP, 4
                frame 1
                end_loop
        loop 6
                move UP, 4
                frame 2
                end_loop
        move BACK, 8
        loop 4
                move UP, 4
                frame 3
                end_loop
        move FORWARD, 8
        loop 6
                move UP, 4
                frame 4
                end_loop
        loop 6
                move UP, 4
                frame 5
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00EF: Inferno (bg1) ]

_d055e0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IFRIT_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        call _d05516
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, SPRITE
        sfx DEFAULT, CENTER
        mod_pal BG2, SUB, CYAN, 0
        init_scroll_wave BG2, 4, 1, HORZ
        init_scroll_wave BG2, 3, 1, VERT
        move BACK, 8
        anim_loop 11
                mod_pal BG2, SUB, CYAN, +1
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                mod_pal BG2, SUB, CYAN, +1
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                mod_pal BG2, SUB, CYAN, +1
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                mod_pal BG2, SUB, CYAN, +1
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                end_anim_loop
        load_bg1_pal 108
        mod_pal BG1, ADD, WHITE, 31
        show_bg1_thread
        loop 8
                frame 11
                cycle_pal BG1_ANIM, 2, {1, 7}
                update_scroll_wave BG2, {HORZ, VERT}
                mod_pal BG1, ADD, WHITE, -1
                end_loop
        hide_bg1_thread
        loop 13
                mod_pal MONSTER, ADD, RED, 31
                cycle_pal BG1_ANIM, 2, {1, 7}
                update_scroll_wave BG2, {HORZ, VERT}
                mod_pal BG1, ADD, WHITE, -1
                frame 11
                mod_pal MONSTER, ADD, RED, 0
                cycle_pal BG1_ANIM, 2, {1, 7}
                update_scroll_wave BG2, {HORZ, VERT}
                mod_pal BG1, ADD, WHITE, -1
                frame 11
                end_loop
        loop 16
                mod_pal MONSTER, ADD, RED, 31
                cycle_pal BG1_ANIM, 2, {1, 7}
                update_scroll_wave BG2, {HORZ, VERT}
                frame 11
                mod_pal MONSTER, ADD, RED, 0
                cycle_pal BG1_ANIM, 2, {1, 7}
                update_scroll_wave BG2, {HORZ, VERT}
                frame 11
                end_loop
        loop 33
                move UP, 4
                cycle_pal BG1_ANIM, 1, {1, 7}
                update_scroll_wave BG2, {HORZ, VERT}
                frame 11
                end_loop
        loop 16
                mod_pal BG2, SUB, CYAN, -2
                update_scroll_wave BG2, {HORZ, VERT}
                frame 11
                end_loop
        init_scroll_wave BG2, 3, 1, {HORZ, VERT}
        call _d05677
        init_scroll_wave BG2, 1, 1, {HORZ, VERT}
        call _d05677
        init_scroll_wave BG2, 0, 1, {HORZ, VERT}
        update_scroll_wave BG2, {HORZ, VERT}
        call _d05549
        end_anim_script

_d05677:
        loop 8
                update_scroll_wave BG2, {HORZ, VERT}
                blank_frame
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00F0: Inferno (bg3) ]

_d0567e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IFRIT_BG3
        anim_script BG3, 1, SCREEN
        move_bg3_here
        loop 77
                blank_frame
                end_loop
        .repeat 2
        anim_loop 9
                frame 0, 2
                end_anim_loop
        .endrep
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00EC: Cure (sprite) ]

_d05691:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CURE_SPRITE
        anim_script SPRITE, 3, CENTER
        fixed_draw_order
        sfx
        anim_loop 17
                frame 0
                end_anim_loop
        sfx CURE_B
        frame 17
        frame 18
        frame 19
        frame 20
        frame 21
        frame 22
        frame 23
        frame 24
        frame 25
        end_anim_script

; ------------------------------------------------------------------------------

; [ unused cure animation (sprite) ]

; There's an extra bit set in the header that doesn't correspond to anything
; so I can't replicate this with the header macro.

_d056a7:
        ; anim_script SPRITE, 3, CENTER
        .byte   $30, $20
        fixed_draw_order
        sfx
        anim_loop 12
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E7: Ultima (bg1) ]

_d056b2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ULTIMA_BG1
        anim_script BG1
        sfx DEFAULT, CENTER
        move_bg1_here
        fixed_draw_order
        sprite_priority 2
        init_circle {128, 96}, 0, {222, 255}, 127, 0
        frame 0
        hide_bg1_thread
        init_scroll_wave BG2, 4, 2, HORZ
        mod_pal BG2, SUB, CYAN, 0
        loop 16
                mod_pal BG2, SUB, YELLOW, +2
                update_scroll_wave BG2, HORZ
                frame 0
                end_loop
        loop 127
                cycle_pal BG1_ANIM, 1, {1, 6}
                update_scroll_wave BG2, HORZ
                zoom_circle +1
                wait_scanline 192
                update_circle
                frame 0
                end_loop
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, HORZ
        sfx ODIN_DEATH, CENTER
        mod_pal BG2, ADD, WHITE, 31
        mod_pal BG1, ADD, WHITE, 31
        show_bg1_thread
        loop 32
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E8: Ultima (bg3) ]

_d056fa:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ULTIMA_BG3
        anim_script BG3
        move_bg3_here
        loop 25
                blank_frame
                end_loop
        bg_screen_pos BG3, BOTTOM_LEFT
        frame 0
        loop 43
                move UP, 6
                blank_frame
                end_loop
        frame 0
        hide_bg3_thread
        loop 75
                move UP, 6
                frame 0
                end_loop
        show_bg3_thread
        bg_screen_pos BG3, BOTTOM_LEFT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D7: Flare (sprite) ]

_d0571a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLARE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        jump_thread _d057ab, _d0572f, _d0576e, _d0572f, _d0576e, _d0576d, _d0576d, _d0576d

_d0572f:
        loop 32
                blank_frame
                end_loop
        .repeat 5
        call _d057e2
        .endrep
        move UP_FORWARD, 32
        loop 8
                move_rand {63, 63}
                frame 6
                frame 7
                frame 8
                frame 9
                frame 10
                frame 11
                frame 12
                frame 13
                frame 14
                end_loop
        move DOWN_BACK, 32
        move_rand {0, 0}
        loop 65
                blank_frame
                end_loop
        sfx FLARE_B
        .repeat 5
        call _d05842
        .endrep
_d0576d:
        end_anim_script

_d0576e:
        loop 32
                blank_frame
                end_loop
        .repeat 5
        call _d057e2
        .endrep
        move UP_FORWARD, 16
        loop 8
                move_rand {31, 31}
                frame 6
                frame 7
                frame 8
                frame 9
                frame 10
                frame 11
                frame 12
                frame 13
                frame 14
                end_loop
        move DOWN_BACK, 16
        move_rand {0, 0}
        loop 65
                blank_frame
                end_loop
        .repeat 5
        call _d05842
        .endrep
        end_anim_script

_d057ab:
        sfx FLARE_A
        mod_pal BG2, SUB, CYAN, 0
        loop 32
                mod_pal BG2, SUB, CYAN, +1
                blank_frame
                end_loop
        .repeat 5
        call _d05812
        .endrep
        sfx BURNING_HOUSE
        anim_speed 3
        bg_target_draw_order
        change_anim_layer BG1
        anim_loop 14
                anim_target_pal
                frame 0
                restore_target_pal
                frame 0
                end_anim_loop
        anim_speed 2
        loop 193
                frame 15
                end_loop
        loop 32
                mod_pal BG2, SUB, CYAN, -1
                frame 15
                end_loop
        end_anim_script

_d057e2:
        rand_angle
        move_polar -80, 0
        loop 3
                move_polar -8, 0
                frame 5
                end_loop
        loop 3
                move_polar -8, 0
                frame 4
                end_loop
        loop 3
                move_polar -8, 0
                frame 3
                end_loop
        loop 4
                move_polar -8, 0
                frame 2
                end_loop
        loop 4
                move_polar -8, 0
                frame 1
                end_loop
        loop 5
                move_polar -8, 0
                frame 0
                end_loop
        return

_d05812:
        rand_angle
        move_polar -80, 0
        loop 3
                move_polar -8, 0
                frame 5
                end_loop
        loop 3
                move_polar -8, 0
                frame 4
                end_loop
        loop 3
                move_polar -8, 0
                frame 3
                end_loop
        loop 4
                move_polar -8, 0
                frame 2
                end_loop
        loop 4
                move_polar -8, 0
                frame 1
                end_loop
        loop 5
                move_polar -8, 0
                frame 0
                end_loop
        return

_d05842:
        rand_angle
        loop 3
                move_polar +12, 0
                frame 0
                end_loop
        loop 3
                move_polar +12, 0
                frame 1
                end_loop
        loop 3
                move_polar +12, 0
                frame 2
                end_loop
        loop 3
                move_polar +12, 0
                frame 3
                end_loop
        loop 3
                move_polar +12, 0
                frame 4
                end_loop
        loop 3
                move_polar +12, 0
                frame 5
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00EA: Bolt 3, Giga Volt (sprite) ]

_d0586f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THUNDAGA_SPRITE
        anim_script SPRITE, 2, BOTTOM
        fixed_draw_order
        jump_thread _d0588c, _d0587a, _d05882

_d0587a:
        blank_frame
        move BACK, 13
        anim_loop 10
                frame 0
                end_anim_loop
        end_anim_script

_d05882:
        blank_frame 3
        move FORWARD, 13
        anim_loop 10
                frame 0
                end_anim_loop
        end_anim_script

_d0588c:
        sfx
        mod_pal BG2, ADD, WHITE, 31
        anim_speed 2
        frame 0
        mod_pal BG2, ADD, WHITE, -4
        frame 1
        mod_pal BG2, ADD, WHITE, -4
        frame 2
        mod_pal BG2, ADD, WHITE, -4
        frame 3
        mod_pal BG2, ADD, WHITE, -4
        anim_target_pal
        frame 4
        mod_pal BG2, ADD, WHITE, -4
        restore_target_pal
        frame 5
        mod_pal BG2, ADD, WHITE, -4
        anim_target_pal
        frame 6
        mod_pal BG2, ADD, WHITE, -4
        restore_target_pal
        frame 7
        mod_pal BG2, ADD, WHITE, -4
        anim_target_pal
        frame 8
        restore_target_pal
        frame 9
        anim_speed 3
        bg_target_draw_order
        frame 10
        change_anim_layer BG1
        anim_loop 14
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E3: Break (bg1) ]

_d058c4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BREAK_BG1
        anim_script SPRITE
        fixed_draw_order
        sfx
        init_triangle {0, 0}, 80, 0
        move_triangle_to_target
        update_triangle_2d
        frame 0
        hide_bg1_thread
        loop 7
                zoom_triangle 0, +8
                update_triangle_2d
                frame 0
                end_loop
        loop 20
                zoom_triangle -4, +8
                update_triangle_2d
                frame 0
                end_loop
        init_triangle {0, 0}, 0, 0
        update_triangle_2d
        sfx QUICK_A
        call _d060ea
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00E2: Break (sprite) ]

_d058f4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BREAK_SPRITE
        anim_script SPRITE
        reset_ellipse
        jump_thread _d05926, _d0592d, _d05934, _d0593b, _d05942, _d05949, _d05950, _d05957

_d05909:
        loop 7
                move_polar 0, +8
                frame 3
                end_loop
        loop 7
                move_polar -4, +8
                frame 2
                end_loop
        loop 7
                move_polar -4, +8
                frame 1
                end_loop
        loop 7
                move_polar -4, +8
                frame 0
                end_loop
        return

_d05926:
        move_polar +80, 0
        call _d05909
        end_anim_script

_d0592d:
        move_polar +80, +32
        call _d05909
        end_anim_script

_d05934:
        move_polar +80, +64
        call _d05909
        end_anim_script

_d0593b:
        move_polar +80, +96
        call _d05909
        end_anim_script

_d05942:
        move_polar +80, -128
        call _d05909
        end_anim_script
_d05949:
        move_polar +80, -96
        call _d05909
        end_anim_script
_d05950:
        move_polar +80, -64
        call _d05909
        end_anim_script

_d05957:
        move_polar +80, -32
        call _d05909
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00DE: Ice 2, N. Cross (sprite) ]

_d0595e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZARA_SPRITE
        anim_script SPRITE
        fixed_draw_order
        sfx
        anim_loop 17
                frame 0, 3
                end_anim_loop
        frame 17, 3
        anim_target_pal
        frame 18, 3
        restore_target_pal
        frame 19, 3
        anim_target_pal
        frame 20, 3
        restore_target_pal
        frame 21, 3
        anim_target_pal
        frame 22, 3
        restore_target_pal
        frame 23, 2
        bg_target_draw_order
        frame 23
        change_anim_layer BG1
        wait_scanline
        sfx BLIZZARA_B
        color_math {ADD, SUBSCREEN}, BG1, SPRITE
        mod_pal BG1, SUB, WHITE, 0
        loop 16
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        mod_pal BG1, SUB, WHITE, 0
        loop 8
                mod_pal BG1, SUB, WHITE, +4
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00DC: Ice (sprite) ]

_d059ac:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZARD_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        sfx
        anim_loop 16
                frame 0
                end_anim_loop
        anim_target_pal
        frame 16
        frame 17
        restore_target_pal
        frame 18
        frame 19
        anim_target_pal
        sfx DRAIN
        bg_target_draw_order
        change_anim_layer BG1
        frame 0, 2
        frame 1, 2
        restore_target_pal
        frame 2, 2
        frame 3, 2
        frame 4, 2
        frame 5, 2
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0099: bg1 graphics only (no bg1 script) ]

_d059d5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLARE_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRA_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRAGA_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THUNDARA_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIO_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZARD_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZARA_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLIZZAGA_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THUNDAGA_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MONSTER_FIGHT_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATOMIC_RAY_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::L4_FLARE_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PEARL_LORE_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STONE_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIG_GUARD_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MUTE_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHRAPNEL_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HYPERDRIVE_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHOCK_WAVE_BG1
        anim_script BG1, 1, BOTTOM
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00DA: Merton (sprite) ]

_d059d8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MELTDOWN_SPRITE
        anim_script SPRITE
        loop 65
                move_target FORWARD, 2
                blank_frame
                move_target BACK, 2
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D9: Merton (bg3) ]

_d059e4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MELTDOWN_BG3
        anim_script BG3, 1, SCREEN
        sfx DEFAULT, CENTER
        fixed_draw_order
        move_bg3_here
        mod_pal BG3, SUB, WHITE, 31
        mod_pal BG2, SUB, WHITE, 0
        frame 0
        bg_screen_pos BG3, TOP_RIGHT
        frame 0
        hide_bg3_thread
        init_scroll_wave BG2, 4, 2, HORZ
        loop 16
                mod_pal BG3, SUB, WHITE, -1
                move FORWARD, 8
                update_scroll_wave BG2, HORZ
                frame 0
                end_loop
        loop 16
                mod_pal BG3, SUB, WHITE, -1
                mod_pal BG2, SUB, WHITE, +1
                move FORWARD, 8
                update_scroll_wave BG2, HORZ
                frame 0
                end_loop
        loop 97
                move FORWARD, 8
                update_scroll_wave BG2, HORZ
                frame 0
                end_loop
        loop 33
                mod_pal BG3, SUB, WHITE, +1
                mod_pal BG2, SUB, WHITE, -1
                move FORWARD, 8
                update_scroll_wave BG2, HORZ
                frame 0
                end_loop
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, HORZ
        sfx NONE
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D8: X-Zone (sprite) ]

_d05a31:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DEZONE_SPRITE
        anim_script SPRITE, 1, SCREEN
        jump_hit :+
        end_anim_script

:       monster_target_priority_zero
        loop 38
                blank_frame
                end_loop
        loop 19
                blank_frame
                end_loop
        hide_target_monsters
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D2: X-Zone (bg3) ]

_d05a44:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DEZONE_BG3
        anim_script BG3, 1, SCREEN
        fixed_draw_order
        sfx DEFAULT, CENTER
        move_bg3_here
        frame 0
        hide_bg3_thread
        init_circle {128, 100}, 80, {222, 255}, 128, 0
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 4, 2, HORZ
        mod_pal BG2, ADD, WHITE, 31
        mod_pal BG3, ADD, WHITE, 31
        loop 38
                zoom_circle -1
                update_circle
                update_scroll_wave BG3, HORZ
                mod_pal BG2, ADD, WHITE, -2
                mod_pal BG3, ADD, WHITE, -2
                frame 0
                end_loop
        loop 19
                zoom_circle -2
                update_circle
                update_scroll_wave BG3, HORZ
                mod_pal BG2, ADD, WHITE, -2
                mod_pal BG3, ADD, WHITE, -2
                frame 0
                end_loop
        reset_scroll_hdma BG3
        set_scroll_hdma BG3, 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D1: Quake (bg1) ]

_d05a84:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::QUAKE_BG1
        anim_script BG1, 1, SCREEN
        sfx DEFAULT, CENTER
        fixed_draw_order
        sprite_priority 3
        move_bg1_here
        init_circle {128, 144}, 2, {222, 255}, 127, 0
        frame 0
        hide_bg3_thread
        loop 16
                scroll_bg {+1, 0}
                zoom_circle +4
                update_circle
                frame 0
                scroll_bg {-1, 0}
                zoom_circle +4
                update_circle
                frame 0
                end_loop
        loop 33
                scroll_bg {+2, 0}
                move FORWARD, 2
                move_circle {+2, 0}, 0
                update_circle
                frame 0
                scroll_bg {-2, 0}
                move BACK, 2
                move_circle {-2, 0}, 0
                update_circle
                frame 0
                end_loop
        loop 12
                scroll_bg {+1, 0}
                zoom_circle -4
                update_circle
                frame 0
                scroll_bg {-1, 0}
                zoom_circle -4
                update_circle
                frame 0
                end_loop
        scroll_bg {0, 0}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00CF: Meteor (bg1) ]

_d05ae1:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::METEOR_BG1
        anim_script BG1, 1, SCREEN
        fixed_draw_order
        sfx DEFAULT, CENTER
        sprite_priority 2
        move_bg1_here
        init_circle {128, 80}, 2, {222, 255}, 127, 0
        frame 0
        hide_bg3_thread
        mod_pal BG2, SUB, CYAN, 0
        loop 16
                mod_pal BG2, SUB, CYAN, +3
                cycle_pal BG1_ANIM, 1, {1, 7}
                zoom_circle +8
                update_circle
                frame 0
                end_loop
        loop 197
                cycle_pal BG1_ANIM, 3, {1, 7}
                frame 0
                end_loop
        loop 33
                cycle_pal BG1_ANIM, 3, {1, 7}
                frame 0
                end_loop
        loop 15
                mod_pal BG2, SUB, CYAN, -3
                cycle_pal BG1_ANIM, 1, {1, 7}
                zoom_circle -8
                update_circle
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00D0: Meteor (bg3) ]

_d05b24:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::METEOR_BG3
        anim_script BG3, 1, SCREEN
        sprite_priority 3
        move_bg3_here
        frame 0
        hide_bg3_thread
        loop 8
                frame 0, 4
                end_loop
        loop 57
                frame 0, 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00CE: Meteor (sprite) ]

_d05b3c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::METEOR_SPRITE
        anim_script SPRITE, 1, SCREEN
        loop 17
                blank_frame
                end_loop
        jump_thread _d05b4f, _d05b4f, _d05b4f, _d05b6b, _d05b6b, _d05b6b

_d05b4f:
        call _d05b7b
        call _d05b7b
        call _d05b7b
        call _d05b7b
        call _d05b7b
        call _d05b7b
        call _d05b7b
        call _d05b7b
        call _d05b7b
        end_anim_script

_d05b6b:
        call _d05bc3
        call _d05bc3
        call _d05bc3
        call _d05bc3
        call _d05bc3
        end_anim_script

_d05b7b:
        rand_angle
        move DOWN_BACK, 8
        loop 2
                move_polar +8, 0
                frame 0
                end_loop
        loop 2
                move_polar +8, 0
                frame 1
                end_loop
        loop 2
                move_polar +8, 0
                frame 2
                end_loop
        loop 2
                move_polar +8, 0
                frame 3
                end_loop
        loop 2
                move_polar +8, 0
                frame 4
                end_loop
        loop 2
                move_polar +16, 0
                frame 5
                end_loop
        move UP_FORWARD, 4
        loop 2
                move_polar +16, 0
                frame 6
                end_loop
        move UP_FORWARD, 4
        loop 3
                move_polar +16, 0
                frame 7
                end_loop
        loop 3
                move_polar +16, 0
                frame 8
                end_loop
        return

_d05bc3:
        rand_angle
        move DOWN_BACK, 8
        loop 2
                move_polar +4, 0
                frame 0
                end_loop
        loop 2
                move_polar +4, 0
                frame 1
                end_loop
        loop 2
                move_polar +6, 0
                frame 2
                end_loop
        loop 3
                move_polar +6, 0
                frame 3
                end_loop
        loop 3
                move_polar +8, 0
                frame 4
                end_loop
        loop 3
                move_polar +8, 0
                frame 5
                end_loop
        move UP_FORWARD, 4
        loop 4
                move_polar +12, 0
                frame 6
                end_loop
        move UP_FORWARD, 4
        loop 4
                move_polar +12, 0
                frame 7
                end_loop
        loop 4
                move_polar +12, 0
                frame 8
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00CC: Poison (sprite) ]

_d05c0b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::POISON_SPRITE
        anim_script SPRITE, 3, BOTTOM
        sfx
        anim_loop 27
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00CD: Doom, Roulette (sprite) ]

_d05c14:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DOOM_SPRITE
        anim_script SPRITE, 1, TOP
        jump_hit :+
        end_anim_script

:       sfx
        fixed_draw_order
        anim_priority 2
        jump_target _d05c2b, _d05c2b, _d05c2b, _d05c2b, _d05c2f

_d05c2b:
        move UP, 16
        move BACK, 4

_d05c2f:
        loop 161
                move UP, 1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d05c36:
        hide_bg1_thread
        mod_pal BG1, SUB, WHITE, 0
        loop 17
                move UP, 1
                blank_frame
                mod_pal BG1, SUB, WHITE, +2
                end_loop
        sprite_priority 3
        show_bg1_thread
        return

; ------------------------------------------------------------------------------

; [ Animation Script $003C: Doom, Roulette (bg1) ]

_d05c47:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DOOM_BG1
        anim_script BG1
        jump_hit :+
        end_anim_script

:       target_priority 2
        jump_target _d05c6d, _d05c87, _d05ca1, _d05cbb, _d05c5a

_d05c5a:
        move_bg1_here
        hide_bg1_thread
        loop 89
                move UP, 1
                blank_frame
                end_loop
        call _d05c36
        move_bg1_here
        hide_bg1_thread
        blank_frame
        end_anim_script

_d05c6d:
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG1, BOTTOM_RIGHT
        blank_frame
        loop 89
                move UP, 1
                frame 0
                end_loop
        call _d05c36
        move DOWN, 89
        blank_frame
        end_anim_script

_d05c87:
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG1, BOTTOM_RIGHT
        blank_frame
        loop 89
                move UP, 1
                frame 1
                end_loop
        call _d05c36
        move DOWN, 89
        blank_frame
        end_anim_script

_d05ca1:
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG1, BOTTOM_RIGHT
        blank_frame
        loop 89
                move UP, 1
                frame 2
                end_loop
        call _d05c36
        move DOWN, 89
        blank_frame
        end_anim_script

_d05cbb:
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame
        bg_screen_pos BG1, BOTTOM_RIGHT
        blank_frame
        loop 89
                move UP, 1
                frame 3
                end_loop
        call _d05c36
        move DOWN, 89
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00C6: Bolt (sprite) ]

_d05cd5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THUNDER_SPRITE
        anim_script SPRITE, 3, BOTTOM
        fixed_draw_order
        anim_priority 0
        move BACK, 64
        sfx
        frame 0
        frame 1
        frame 2
        frame 3
        anim_target_pal
        frame 4
        restore_target_pal
        frame 5
        anim_target_pal
        frame 6
        restore_target_pal
        frame 7
        anim_target_pal
        frame 8
        restore_target_pal
        frame 9
        back_sprite
        frame 10
        frame 11
        frame 12
        front_sprite
        frame 13
        frame 14
        frame 15
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00C7: Bolt 2, Mega Volt (sprite) ]

_d05d02:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THUNDARA_SPRITE
        anim_script SPRITE, 1, BOTTOM
        fixed_draw_order
        sfx
        anim_loop 17
                frame 0
                end_anim_loop
        anim_target_pal
        frame 17
        frame 18
        restore_target_pal
        frame 19
        frame 20
        anim_target_pal
        frame 21
        frame 22
        restore_target_pal
        frame 23
        frame 24
        anim_target_pal
        frame 25
        frame 26
        restore_target_pal
        anim_speed 5
        change_anim_layer BG1
        bg_target_draw_order
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00C2: Fire 2 (sprite) ]

_d05d2e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRA_SPRITE
        anim_script SPRITE, 4, BOTTOM
        fixed_draw_order
        sfx
        frame 0
        frame 1
        anim_target_pal
        frame 2
        restore_target_pal
        frame 3
        anim_target_pal
        frame 4
        change_anim_layer BG1
        bg_target_draw_order
        move FORWARD, 10
        frame 0
        restore_target_pal
        frame 1
        frame 2
        frame 3
        frame 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00C1: Fire, Blaze (sprite) ]

_d05d4d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_SPRITE
        anim_script SPRITE, 5, BOTTOM
        anim_priority 0
        jump_thread _d05d58, _d05d5e, _d05d65

_d05d58:
        sfx
        anim_target_pal
        move BACK, 26

_d05d5e:
        anim_loop 5
                frame 0
                restore_target_pal
                end_anim_loop
        end_anim_script

_d05d65:
        move FORWARD, 26
        anim_loop 5
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00BE: Dispel (sprite) ]

_d05d6c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DISPEL_SPRITE
        anim_script SPRITE
        call _d05f25
        reset_ellipse
        jump_thread _d05d80, _d05d88, _d05d8e, _d05d94, _d05d9a, _d05da0

_d05d80:
        fixed_draw_order
        move_ellipse +40, 0
        jump _d05da3

_d05d88:
        move_ellipse +40, +42
        jump _d05da3

_d05d8e:
        move_ellipse +40, +84
        jump _d05da3

_d05d94:
        move_ellipse +40, +126
        jump _d05da3

_d05d9a:
        move_ellipse +40, -88
        jump _d05da3

_d05da0:
        move_ellipse +40, -46

_d05da3:
        loop 65
                move_ellipse 0, -6
                update_ellipse_priority
                auto_frame 4, {0, 3}
                frame 0
                end_loop
        unpause_layer BG1
        loop 21
                move UP, 8
                move_ellipse +6, -6
                update_ellipse_priority
                auto_frame 4, {0, 3}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00BF: Dispel (bg1) ]

_d05dc0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DISPEL_BG1
        anim_script BG1
        mod_pal BG2, ADD, WHITE, 31
        loop 6
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG2, ADD, WHITE, -1
                frame 0
                end_loop
        loop 6
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG2, ADD, WHITE, -1
                frame 1
                end_loop
        loop 6
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG2, ADD, WHITE, -1
                frame 2
                end_loop
        loop 6
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG2, ADD, WHITE, -1
                frame 3
                end_loop
        loop 33
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG2, ADD, WHITE, -1
                frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00BC: Warp, Warp Stone (bg1) ]

_d05df2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WARP_BG1
        anim_script BG1, 5, CENTER
        jump_hit :+
        end_anim_script

:       sfx DEFAULT, CENTER
        blank_frame
        mosaic {BG1, BG2}, 1
        blank_frame
        mosaic {BG1, BG2}, 2
        blank_frame
        mosaic {BG1, BG2}, 3
        blank_frame
        mosaic {BG1, BG2}, 4
        blank_frame
        mosaic {BG1, BG2}, 5
        blank_frame
        mosaic {BG1, BG2}, 6
        blank_frame
        mosaic {BG1, BG2}, 7
        blank_frame
        mosaic {BG1, BG2}, 9
        blank_frame
        mosaic {BG1, BG2}, 10
        blank_frame
        mosaic {BG1, BG2}, 11
        blank_frame
        mosaic {BG1, BG2}, 12
        blank_frame
        mosaic {BG1, BG2}, 13
        blank_frame
        mosaic {BG1, BG2}, 14
        blank_frame
        mosaic {BG1, BG2}, 15
        anim_speed 3
        loop 16
                dec_brightness
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B9: Vanish (bg1) ]

_d05e2e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::VANISH_BG1
        anim_script BG1, 4, CENTER
        sfx
        anim_loop 8
                frame 0
                end_anim_loop
        frame 7, 6
        sfx QUICK_A
        anim_loop 8
                frame 8
                end_anim_loop
        jump_hit :+
        end_anim_script

:       target_vanish
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00BD: Quick (sprite) ]

_d05e49:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::QUICK_SPRITE
        anim_script SPRITE, 5, CENTER
        fixed_draw_order
        sfx
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        sfx PRE_BUSHIDO
        frame 8
        frame 9
        frame 10
        frame 11
        frame 12
        end_anim_loop
end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B8: TekBarrier (bg3) ]

_d05e60:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TEKBARRIER_BG3
        anim_script BG3
        frame 0
        hide_bg3_thread
        loop 97
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B6: TekBarrier (sprite) ]

_d05e6a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TEKBARRIER_SPRITE
        anim_script SPRITE, 4, CENTER
        move UP_FORWARD, 16
        move_rand {31, 31}
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        frame 8
        frame 9
        frame 10
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B7: TekBarrier (bg1) ]

_d05e7d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TEKBARRIER_BG1
        anim_script BG1
        sfx
        fixed_draw_order
        init_triangle {0, 0}, 0, 0
        move_triangle_to_target
        update_triangle_2d
        frame 0
        hide_bg1_thread
        loop 49
                zoom_triangle +2, +8
                update_triangle_2d
                cycle_pal BG1_ANIM, 3, {1, 6}
                frame 0
                end_loop
        loop 49
                zoom_triangle -2, +8
                update_triangle_2d
                cycle_pal BG1_ANIM, 3, {1, 6}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B4: Rflect (sprite) ]

_d05ea8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REFLECT_SPRITE
        anim_script SPRITE, 3, CENTER
        loop 3
                sfx
                frame 0
                frame 1
                frame 2
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B5: Shell (bg1) ]

_d05eb4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHELL_BG1
        anim_script BG1
        sfx
        fixed_draw_order
        frame 0
        hide_bg1_thread
        loop 65
                cycle_pal BG1_ANIM, -3, {1, 6}
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 33
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, -3, {1, 6}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B2: Imp (sprite) ]

_d05ed0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IMP_SPRITE
        anim_script SPRITE, 3, CENTER
        anim_priority 0
        move UP_FORWARD, 17
        sfx
        move_rand {31, 31}
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        unpause_layer BG1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B3: Imp (bg1) ]

_d05ee4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IMP_BG1
        anim_script BG1
        fixed_draw_order
        init_circle {0, 0}, 0, {255, 255}, 48, 0
        frame 0
        hide_bg1_thread
        move_circle_to_target
        sfx SLOW
        loop 45
                zoom_circle +1
                update_circle
                frame 0
                end_loop
        target_priority 2
        jump_hit :+
        loop 45
                zoom_circle -1
                update_circle
                frame 0
                end_loop
        end_anim_script

:       target_imp
        loop 45
                zoom_circle -1
                update_circle
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00B1: Float (sprite) ]

_d05f1a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLOAT_SPRITE
        anim_script SPRITE, 5, CENTER
        fixed_draw_order
        sfx
        anim_loop 9
                frame 0
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ play default sound effect if first thread ]

_d05f25:
        jump_thread :+, _d05f38, _d05f38, _d05f38, _d05f38, _d05f38, _d05f38, _d05f38
:       sfx
_d05f38:
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00AE: Stop (sprite) ]

_d05f39:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STOP_SPRITE
        anim_script SPRITE, 4, CENTER
        sfx
        anim_loop 17
                frame 0
                end_anim_loop
        sfx CURE_B
        frame 17
        frame 18
        frame 19
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00AC: Haste, Haste2 (sprite) ]

_d05f47:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HASTE_SPRITE
        anim_script SPRITE, 3, CENTER
        sfx
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        frame 8
        frame 9
        frame 10
        frame 15
        frame 16
        frame 17
        frame 18
        frame 11
        frame 12
        frame 13
        frame 14
        frame 15
        frame 16
        frame 17
        frame 18
        frame 9
        frame 8
        frame 7
        frame 5
        frame 4
        frame 3
        frame 2
        frame 1
        frame 0
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00AD: Haste, Haste2 (bg3) ]

; also used by poisona

_d05f6c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HASTE_BG3
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REGEN_BG3
        anim_script BG3
        fixed_draw_order
        sfx
        move_bg3_here
        wait_scanline
        mainscreen_layers {BG1, BG2, SPRITE}
        mod_pal BG3, SUB, WHITE, 31
        frame 0
        bg_screen_pos BG3, TOP_RIGHT
        frame 0
        hide_bg3_thread
        wait_scanline
        mainscreen_layers {BG1, BG2, BG3, SPRITE}
        loop 32
                move FORWARD, 1
                mod_pal BG3, SUB, WHITE, -1
                frame 0
                end_loop
        loop 65
                move FORWARD, 1
                frame 0
                end_loop
        loop 32
                move FORWARD, 1
                mod_pal BG3, SUB, WHITE, +1
                frame 0
                end_loop
        show_bg3_thread
        bg_screen_pos BG3, TOP_RIGHT
        frame 9
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $003B: Character Graphics (bg1) ]

_d05fa2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHAR_GFX_BG1
        anim_script BG1
        bg_target_draw_order
        target_priority 2
        jump_target _d05fb3, _d05fbe, _d05fc9, _d05fd4, _d05fde

_d05fb3:
        loop 129
                frame 0
                hide_target_chars
                end_loop
        show_target_chars
        frame 0, 2
        end_anim_script

_d05fbe:
        loop 129
                frame 1
                hide_target_chars
                end_loop
        show_target_chars
        frame 1, 2
        end_anim_script

_d05fc9:
        loop 129
                frame 2
                hide_target_chars
                end_loop
        show_target_chars
        frame 2, 2
        end_anim_script

_d05fd4:
        loop 129
                frame 3
                hide_target_chars
                end_loop
        show_target_chars
        frame 3, 2

_d05fde:
        end_anim_script

; ------------------------------------------------------------------------------

; [  ]

_d05fdf:
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, -1
        bg_screen_pos BG1, TOP_LEFT
        frame 0
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, -1
        bg_screen_pos BG1, TOP_RIGHT
        frame 2
        return

_d05fee:
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, -1
        bg_screen_pos BG1, TOP_LEFT
        frame 1
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, -1
        bg_screen_pos BG1, TOP_RIGHT
        frame 3
        return

_d05ffd:
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, +1
        bg_screen_pos BG1, TOP_LEFT
        frame 0
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, +1
        bg_screen_pos BG1, TOP_RIGHT
        frame 2
        return

_d0600c:
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, +1
        bg_screen_pos BG1, TOP_LEFT
        frame 1
        move FORWARD, 1
        mod_pal BG1, SUB, WHITE, +1
        bg_screen_pos BG1, TOP_RIGHT
        frame 3
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00AB: Muddle, L.3 Muddle (bg1) ]

_d0601b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONFUSE_BG1
        anim_script BG1
        sprite_priority 2
        fixed_draw_order
        sfx
        mod_pal BG1, SUB, WHITE, 31
        move_bg1_here
        loop 16
                call _d05fdf
                call _d05fdf
                call _d05fee
                call _d05fee
                end_loop
        loop 8
                call _d05ffd
                call _d05ffd
                call _d0600c
                call _d0600c
                end_loop
        bg_screen_pos BG1, TOP_RIGHT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00AA: Muddle, L.3 Muddle, Confusion (sprite) ]

_d06049:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CONFUSE_SPRITE
        anim_script SPRITE, 2, TOP
        anim_priority 2
        jump_thread _d06056, _d0606a, _d0607c, _d0608e

_d06056:
        sfx
        init_polar
        move_ellipse +48, +64
        call _d060c5
        call _d060c5
        call _d060a0
        call _d060a0
        end_anim_script

_d0606a:
        init_polar
        move_ellipse +48, -128
        call _d060c5
        call _d060a0
        call _d060a0
        call _d060c5
        end_anim_script

_d0607c:
        init_polar
        move_ellipse +48, -64
        call _d060a0
        call _d060a0
        call _d060c5
        call _d060c5
        end_anim_script

_d0608e:
        init_polar
        move_ellipse +48, 0
        call _d060a0
        call _d060c5
        call _d060c5
        call _d060a0
        end_anim_script

_d060a0:
        loop 4
                frame 2
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        loop 4
                frame 3
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        loop 4
                frame 2
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        loop 4
                frame 3
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        return

_d060c5:
        loop 4
                frame 0
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        loop 4
                frame 1
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        loop 4
                frame 0
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        loop 4
                frame 1
                move_ellipse 0, +4
                update_ellipse_priority
                end_loop
        return

; ------------------------------------------------------------------------------

_d060ea:
        set_blank_frame 15
        mod_pal BG2, ADD, WHITE, 31
        loop 33
                mod_pal BG2, ADD, WHITE, -1
                blank_frame
                end_loop
        return

; ------------------------------------------------------------------------------

_d060f3:
        anim_script SPRITE, 3, CENTER
        fixed_draw_order
        sfx
        anim_priority 0
        anim_loop 18
                frame 0
                end_anim_loop
        sfx QUICK_A
        frame 18
        frame 19
        frame 20
        frame 21
        frame 22
        frame 23
        frame 24
        frame 25
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A5: Rasp (bg3) ]

_d0610a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RASP_BG3
        anim_script BG3, 2, CENTER
        set_blank_frame 15
        sfx
        fixed_draw_order
        init_circle {0, 0}, 46, {255, 255}, 48, 0
        frame 0
        hide_bg1_thread
        move_circle_to_target
        update_circle
        loop 45
                zoom_circle -1
                update_circle
                frame 0
                end_loop
        show_bg1_thread
        loop 16
                blank_frame
                end_loop
        sfx RASP_B
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A6: Rasp (sprite) ]

_d0612f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RASP_SPRITE
        anim_script SPRITE
        .repeat 5
        call _d06174
        .endrep
        loop 65
                blank_frame
                end_loop
        .repeat 3
        call _d0614e
        .endrep
        end_anim_script

_d0614e:
        rand_angle
        loop 3
                move_polar +12, 0
                frame 0
                end_loop
        loop 3
                move_polar +12, 0
                frame 1
                end_loop
        loop 3
                move_polar +12, 0
                frame 2
                end_loop
        loop 3
                move_polar +12, 0
                frame 3
                end_loop
        loop 3
                move_polar +12, 0
                frame 4
                end_loop
        return

_d06174:
        rand_angle
        move_polar -128, 0
        loop 3
                move_polar -8, +4
                frame 4
                end_loop
        loop 3
                move_polar -8, +4
                frame 3
                end_loop
        loop 3
                move_polar -8, +4
                frame 2
                end_loop
        loop 3
                move_polar -8, +4
                frame 1
                end_loop
        loop 3
                move_polar -8, +4
                frame 0
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $00A4: Slow, Slow 2 (sprite) ]

_d0619d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLOW_SPRITE
        anim_script SPRITE
        match_target_dir
        fixed_draw_order
        jump_thread _d061ab, _d061b7, _d061c3, _d061cc

_d061ab:
        sfx
        loop 9
                blank_frame
                end_loop
        move_polar 0, 0
        jump _d061cf

_d061b7:
        blank_frame 6
        move_polar 0, +64
        jump _d061cf

_d061c3:
        blank_frame 3
        move_polar 0, -128
        jump _d061cf

_d061cc:
        move_polar 0, -64

_d061cf:
        loop 8
                move_polar +1, +12
                frame 0
                end_loop
        loop 8
                move_polar +1, +12
                frame 1
                end_loop
        loop 8
                move_polar +1, +12
                frame 2
                end_loop
        loop 8
                move_polar +1, +12
                frame 3
                end_loop
        loop 8
                move_polar 0, +10
                frame 4
                end_loop
        loop 8
                move_polar 0, +8
                frame 4
                end_loop
        loop 8
                move_polar 0, +4
                frame 4
                end_loop
        loop 8
                move_polar 0, +1
                frame 4
                end_loop
        loop 33
                frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A2: Scan, Targetting (sprite) ]

_d0620c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SCAN_SPRITE
        anim_script SPRITE
        loop 33
                blank_frame
                end_loop
        anim_speed 7
        anim_priority 3
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        anim_speed 2
        loop 65
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A3: Scan, Targetting (bg1) ]

_d06224:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SCAN_BG1
        anim_script BG1
        sfx
        fixed_draw_order
        init_circle {0, 0}, 0, {255, 255}, 32, 0
        frame 0
        hide_bg1_thread
        move_circle_to_target
        loop 33
                zoom_circle +1
                update_circle
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        loop 65
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 31
                zoom_circle -1
                update_circle
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00BA: Drain, Osmose, Raid (sprite) ]

_d06258:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DRAIN_SPRITE
        anim_script SPRITE
        jump_thread _d06267, _d06273, _d0627d, _d06287, _d06291, _d0629a

_d06267:
        loop 15
                blank_frame
                end_loop
        sfx
        move_polar +124, 0
        jump _d0629d

_d06273:
        loop 12
                blank_frame
                end_loop
        move_polar +124, +42
        jump _d0629d

_d0627d:
        loop 9
                blank_frame
                end_loop
        move_polar +124, +84
        jump _d0629d

_d06287:
        loop 6
                blank_frame
                end_loop
        move_polar +124, +126
        jump _d0629d

_d06291:
        blank_frame 3
        move_polar +124, -88
        jump _d0629d

_d0629a:
        move_polar +124, -46

_d0629d:
        loop 32
                move_polar -4, +8
                frame 4
                end_loop
        jump_thread _d062b1, _d062bc, _d062c2, _d062c9, _d062d0, _d062d7

_d062b1:
        calc_vec_reverse
:       frame 4
        move_vec :-, 8
        unpause_layer BG1
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

_d062bc:
        blank_frame 3
        jump _d062db

_d062c2:
        loop 6
                blank_frame
                end_loop
        jump _d062db

_d062c9:
        loop 9
                blank_frame
                end_loop
        jump _d062db

_d062d0:
        loop 12
                blank_frame
                end_loop
        jump _d062db

_d062d7:
        loop 15
                blank_frame
                end_loop

_d062db:
        anim_speed 3
        loop 2
                move_to_first_thread
                frame 4
                frame 3
                frame 2
                frame 1
                frame 0
                end_loop
        move_to_target
        move_to_attacker
        move UP_FORWARD, 16
        anim_speed 5
        loop 3
                move_rand {31, 31}
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00BB: Drain, Osmose, Raid (bg1) ]

_d062f8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DRAIN_BG1
        anim_script BG1
        sfx SFX_34
        move_to_attacker
        bg_attacker_draw_order
        init_circle {0, 0}, 0, {255, 255}, 32, 0
        frame 0
        hide_bg1_thread
        move_circle_to_attacker
        loop 9
                zoom_circle +4
                update_circle
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        loop 33
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 8
                zoom_circle -4
                update_circle
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A0:  ]

_d0632d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_160
        anim_script SPRITE
        jump_thread _d0633c, _d06356, _d06356, _d06356, _d06356, _d06356

_d0633c:
        sfx
        move_to_attacker
        loop 5
                fixed_draw_order
                attacker_frame CHAR_FRAME::JUMPING_FORWARD
                frame 4
                move FORWARD, 8
                end_loop
        calc_vec_grav_bomb
:       frame 4
        move_vec_grav_bomb :-, 8
        unpause_layer BG1
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

_d06356:
        anim_speed 4
        loop 2
                move_to_first_thread
                frame 4
                frame 3
                frame 2
                frame 1
                frame 0
                end_loop
        move_to_target
        move UP_FORWARD, 16
        anim_speed 6
        loop 5
                move_rand {31, 31}
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $00A1:  ]

_d06372:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_161
        anim_script BG1
        sfx SFX_34
        init_circle {0, 0}, 0, {255, 255}, 32, 0
        frame 0
        hide_bg1_thread
        move_circle_to_target
        loop 33
                zoom_circle +1
                update_circle
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        loop 33
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 31
                zoom_circle -1
                update_circle
                cycle_pal BG1_ANIM, 3, {1, 5}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $009B: Life 3 (sprite/bg1) ]

_d063a4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RERAISE_SPRITE
        anim_script SPRITE
        jump_thread _d063ab, _d06400

_d063ab:
        fixed_draw_order
        sfx
        call _d063b6
        call _d06451
        end_anim_script

_d063b6:
        move UP_BACK, 32
        frame 0, 4
        frame 1, 4
        frame 2, 4
        frame 3, 4
        frame 4, 4
        loop 2
                .repeat 4
                move DOWN_FORWARD, 1
                frame 5
                .endrep
                .repeat 4
                move DOWN_FORWARD, 1
                frame 6
                .endrep
                .repeat 4
                move DOWN_FORWARD, 1
                frame 7
                .endrep
                .repeat 4
                move DOWN_FORWARD, 1
                frame 8
                .endrep
                end_loop
        return

_d06400:
        call _d06407
        call _d06451
        end_anim_script

_d06407:
        move UP_FORWARD, 32
        frame 0, 4
        frame 1, 4
        frame 2, 4
        frame 3, 4
        frame 4, 4
        loop 2
                .repeat 4
                move DOWN_BACK, 1
                frame 5
                .endrep
                .repeat 4
                move DOWN_BACK, 1
                frame 6
                .endrep
                .repeat 4
                move DOWN_BACK, 1
                frame 7
                .endrep
                .repeat 4
                move DOWN_BACK, 1
                frame 8
                .endrep
                end_loop
        return

_d06451:
        mod_pal BG1, SUB, WHITE, 0
        change_anim_layer BG1
        frame 8
        change_anim_layer SPRITE
        blank_frame
        change_anim_layer BG1
        set_blank_frame 15
        loop 3
                .repeat 2
                mod_pal BG1, SUB, WHITE, +2
                frame 5, 2
                .endrep
                .repeat 2
                mod_pal BG1, SUB, WHITE, +2
                frame 6, 2
                .endrep
                .repeat 2
                mod_pal BG1, SUB, WHITE, +2
                frame 7, 2
                .endrep
                .repeat 2
                mod_pal BG1, SUB, WHITE, +2
                frame 8, 2
                .endrep
                end_loop
        blank_frame
        change_anim_layer SPRITE
        return

; ------------------------------------------------------------------------------

; [ Animation Script $009A: Life, Fallen One (sprite) ]

_d06482:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RAISE_SPRITE
        anim_script SPRITE
        match_target_dir
        jump_thread _d06492, _d064c3, _d064c3, _d064c3, _d064c3, _d064c3

_d06492:
        fixed_draw_order
        sfx
        move UP_FORWARD, 128
        move_polar +16, +8
        loop 64
                move DOWN_BACK, 2
                move_polar 0, +8
                frame 1
                end_loop
        sfx MAGICITE_PICKUP
        anim_speed 5
        frame 2, 2
        frame 3, 2
        frame 4, 2
        frame 5, 2
        frame 6, 2
        frame 7, 2
        frame 8
        frame 9
        frame 10
        frame 11
        frame 12
        frame 13
        frame 14
        frame 15
        end_anim_script

_d064c3:
        anim_speed 7
        loop 4
                move_to_first_thread
                frame 1, 2
                frame 0, 2
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0071: Life 2 (sprite) ]

_d064cf:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ARISE_SPRITE
        anim_script SPRITE
        match_target_dir
        jump_thread _d064df, _d06524, _d06548, _d06548, _d06524, _d06548

_d064df:
        fixed_draw_order
        sfx
        move UP_FORWARD, 128
        move_polar +16, +8
        loop 64
                move DOWN_BACK, 2
                move_polar 0, +8
                frame 1
                end_loop
        anim_speed 5
        frame 2, 2
        frame 3, 2
        frame 4, 2
        frame 5, 2
        frame 6, 2
        frame 7, 2
        move_polar -16, 0
        move UP_FORWARD, 9
        move_rand {15, 15}
        frame 8
        frame 9
        frame 10
        frame 11
        frame 12
        frame 13
        frame 14
        frame 15
        frame 5
        frame 6
        frame 7
        frame 5
        frame 6
        frame 7
        frame 8
        frame 9
        frame 10
        frame 11
        frame 12
        frame 13
        frame 14
        frame 15
        end_anim_script

_d06524:
        anim_speed 7
        loop 4
                move_to_first_thread
                frame 1, 2
                frame 0, 2
                end_loop
        anim_speed 5
        move UP_FORWARD, 16
        loop 2
                move_rand {31, 31}
                frame 5
                frame 6
                frame 7
                frame 5
                frame 6
                frame 7
                frame 8
                frame 9
                frame 10
                frame 11
                frame 12
                frame 13
                frame 14
                frame 15
                end_loop
        end_anim_script

_d06548:
        anim_speed 7
        loop 4
                move_to_first_thread
                frame 1, 2
                frame 0, 2
                end_loop
        anim_speed 5
        move UP_FORWARD, 32
        loop 2
                move_rand {63, 63}
                frame 8
                frame 9
                frame 10
                frame 11
                frame 12
                frame 13
                frame 14
                frame 15
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $009D: Remedy (sprite) ]

_d06566:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REMEDY_SPRITE
        anim_script SPRITE, 1, BOTTOM
        sfx
        loop 32
                blank_frame
                end_loop
        anim_loop 23
                frame 0, 4
                end_anim_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $009E: Remedy (bg1) ]

_d06576:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REMEDY_BG1
        anim_script BG1, 1, BOTTOM
        fixed_draw_order
        frame 0
        bg_screen_pos BG1, BOTTOM_LEFT
        frame 0
        hide_bg1_thread
        init_circle {0, 0}, 0, {255, 255}, 32, 0
        move_circle_to_target
        move_circle {0, -127}, 0
        move_circle {0, -24}, 0
        loop 32
                move DOWN, 1
                cycle_pal BG1_ANIM, 1, {1, 5}
                frame 0
                zoom_circle +2
                update_circle
                frame 0
                end_loop
        loop 49
                move DOWN, 1
                cycle_pal BG1_ANIM, 1, {1, 5}
                frame 0, 2
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 17
                mod_pal BG1, SUB, WHITE, +1
                move DOWN, 1
                cycle_pal BG1_ANIM, 1, {1, 5}
                frame 0
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        show_bg1_thread
        bg_screen_pos BG1, BOTTOM_LEFT
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $009C: Antdot (sprite) ]

_d065c0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::POISONA_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REGEN_SPRITE
        anim_script SPRITE, 6, CENTER
        match_target_dir
        move UP_FORWARD, 16
        loop 2
                move_rand {31, 31}
                frame 0
                frame 1
                frame 2
                frame 3
                frame 4
                frame 5
                frame 6
                frame 7
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0039: GP Rain (sprite) ]

_d065d4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GP_RAIN_SPRITE
        anim_script SPRITE
        move_to_attacker
        jump_step :+
        move FORWARD, 24
        loop 8
                blank_frame
                end_loop
:       jump_hit :+
        end_anim_script
:       sfx
        calc_vec_rand
        vec_offset 8
:       frame 0
        move_vec :-, 8
        loop 8
                move_target BACK, 2
                frame 0
                move_target FORWARD, 2
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $003A: GP Rain (extra) ]

_d065f6:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GP_RAIN_EXTRA
        anim_script SPRITE
        jump_step :+
        call _d07019
:       attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        blank_frame 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        loop 32
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $008F: Throw Sword (sprite) ]

_d0660d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_SWORD_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_KATANA_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_ROD_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_SPEAR_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_FULL_MOON_SPRITE
        anim_script SPRITE
        move_to_attacker
        jump_step :+
        call _d07019
:       sfx
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move DOWN, 8
        calc_vec
        vec_offset 8
:       frame 1
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move_vec :-, 8
        sfx THROW
        loop 8
                move_target BACK, 2
                frame 1
                move_target FORWARD, 2
                frame 1
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0279: Throw Boomerang (sprite) ]

_d06635:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_BOOMERANG_SPRITE
        anim_script SPRITE
        move_to_attacker
        jump_step :+
        call _d07019
:       sfx
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        calc_vec
        vec_offset 8
:       auto_frame 2, {0, 6}
        frame 0
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move_vec :-, 8
        sfx THROW
        loop 8
                move_target BACK, 2
                auto_frame 2, {0, 6}
                frame 0
                move_target FORWARD, 2
                auto_frame 2, {0, 6}
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0064: Throw Hawk Eye/Sniper (sprite) ]

_d06664:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_HAWK_EYE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_THICK_KNIFE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THROW_THIN_KNIFE_SPRITE
        anim_script SPRITE
        move_to_attacker
        jump_step :+
        call _d07019
:       sfx
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        calc_vec
        vec_offset 8
:       auto_frame 2, {0, 3}
        frame 1
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move_vec :-, 8
        sfx THROW
        loop 8
                move_target BACK, 2
                auto_frame 2, {0, 3}
                frame 1
                move_target FORWARD, 2
                auto_frame 2, {0, 3}
                frame 1
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $003F: Jump w/ Hawk Eye/Sniper (sprite) ]

_d06693:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_HAWK_EYE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_SWORD_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_KATANA_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_ROD_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_SPEAR_SPRITE
        anim_script SPRITE, 1, BOTTOM
        move_to_attacker
        call _d06725
        attacker_frame CHAR_FRAME::NEAR_FATAL
        move BACK, 11
        move DOWN, 29
        sfx
        call _d0671c
        call _d066ec
        jump_dragon_horn :+
        call _d06753
        end_anim_script
:       jump _d066ce

; ------------------------------------------------------------------------------

; [ Animation Script $0087: Jump w/ Thick Knife (sprite) ]

_d066b2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_THICK_KNIFE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_THIN_KNIFE_SPRITE
        anim_script SPRITE, 1, BOTTOM
        move_to_attacker
        call _d06725
        sfx
        call _d06704
        attacker_frame CHAR_FRAME::NEAR_FATAL
        move BACK, 11
        move DOWN, 29
        call _d066ec
        jump_dragon_horn _d066ce
        call _d06753
        end_anim_script

_d066ce:
        attacker_frame CHAR_FRAME::JUMPING_DOWN
        loop 21
                move_attacker UP, 8
                blank_frame
                end_loop
        hide_attacker_char
        loop 9
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        disable_echo_sprites 1
        loop 21
                move_attacker DOWN, 8
                end_loop
:       move_vec_char :-, -8, 32
        end_anim_script

; ------------------------------------------------------------------------------

_d066ec:
        loop 4
                move_attacker DOWN, 8
                move DOWN, 8
                frame 0
                end_loop
        loop 8
                move_target FORWARD, 2
                frame 0
                move_target BACK, 2
                frame 0
                end_loop
        loop 4
                move_attacker DOWN, 8
                blank_frame
                end_loop
        return

; ------------------------------------------------------------------------------

_d06704:
        loop 3
                move_attacker DOWN, 8
                move DOWN, 8
                frame 1
                move_attacker DOWN, 8
                move DOWN, 8
                frame 2
                move_attacker DOWN, 8
                move DOWN, 8
                frame 3
                move_attacker DOWN, 8
                move DOWN, 8
                frame 4
                end_loop
        return

; ------------------------------------------------------------------------------

_d0671c:
        loop 12
                move_attacker DOWN, 8
                move DOWN, 8
                frame 0
                end_loop
        return

; ------------------------------------------------------------------------------

_d06725:
        hide_attacker_char
        jump_step :+
        move_attacker FORWARD, 24
        move FORWARD, 24
:       blank_frame
        calc_vec_jump
:       move_vec_char :-, 8, 32
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        blank_frame 2
        fixed_draw_order
        move_attacker UP, 160
        move UP, 160
        enable_echo_sprites 1
        show_attacker_char
        return

; ------------------------------------------------------------------------------

_d06753:
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        loop 7
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 32
        attacker_frame CHAR_FRAME::NONE
        loop 9
                blank_frame
                end_loop
        disable_echo_sprites 1
        normal_draw_order
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0082: Jump Unarmed (sprite) ]

_d0676e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_UNARMED_SPRITE
        anim_script SPRITE, 1, BOTTOM
        call _d06725
        sfx
        loop 20
                move_attacker DOWN, 8
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 8
                move_target BACK, 2
                blank_frame
                move_target FORWARD, 2
                blank_frame
                end_loop
        jump_dragon_horn :+
        call _d06753
        end_anim_script
:       jump _d066ce

; ------------------------------------------------------------------------------

; [ Animation Script $0085: Character Jump Miss (sprite) ]

_d06791:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_CHAR_MISS_SPRITE
        anim_script SPRITE, 1, BOTTOM
        hide_attacker_char
        jump_step :+
        move_attacker FORWARD, 24
:       attacker_frame CHAR_FRAME::JUMPING_FORWARD
        move_attacker UP, 160
        enable_echo_sprites 1
        show_attacker_char
        fixed_draw_order
        sfx
        loop 20
                move_attacker DOWN, 8
                blank_frame
                end_loop
        loop 7
                attacker_frame CHAR_FRAME::WALKING_FORWARD_1
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        loop 9
                blank_frame
                end_loop
        disable_echo_sprites 1
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01E1: Jump (sprite) ]

_d067c7:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_CMD_SPRITE
        anim_script SPRITE
        enable_echo_sprites 1
        fixed_draw_order
        jump_step :+
        call _d07019
:       sfx DEFAULT, X_POS
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 9
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        loop 21
                move_attacker UP, 8
                move_attacker FORWARD, 2
                blank_frame
                end_loop
        loop 17
                blank_frame
                end_loop
        disable_echo_sprites 1
        hide_attacker_char
        loop 21
                move_attacker DOWN, 8
                move_attacker BACK, 2
                end_loop
        jump_step :+
        move_attacker BACK, 24
:       normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0086: Monster Jump and miss (bg1) ]

_d067fd:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_MONSTER_MISS_SPRITE
        anim_script BG1, 1, BOTTOM
        fixed_draw_order
        loop 20
                move_attacker UP, 8
                end_loop
        sfx
        show_attacker_monster
        loop 20
                move_attacker DOWN, 8
                blank_frame
                end_loop
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0083: Monster jump (up) ]

_d06813:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_MONSTER_UP_BG1
        anim_script BG1, 1, BOTTOM
        fixed_draw_order
        sfx
        loop 20
                move_attacker UP, 8
                move_attacker FORWARD, 2
                blank_frame
                end_loop
        hide_attacker_monster
        loop 20
                move_attacker DOWN, 8
                move_attacker BACK, 2
                end_loop
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0084: Monster Jump (down) ]

_d0682d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_MONSTER_DOWN_BG1
        anim_script BG1, 1, BOTTOM
        hide_attacker_monster
        init_monster_jump_pos
        blank_frame
        calc_vec_jump
:       move_vec_monster :-, 8
        blank_frame
        fixed_draw_order
        move_attacker UP, 160
        show_attacker_monster
        sfx
        loop 20
                move_attacker DOWN, 8
                blank_frame
                end_loop
        normal_draw_order
:       blank_frame
        move_vec_monster :-, -8
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0080: Shock (sprite) ]

_d06856:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHOCK_CMD_SPRITE
        anim_script SPRITE
        fixed_draw_order
        anim_draw_order RIGHT_HAND
        move_to_attacker
        move_if_flipped FORWARD, 2
        jump_step :+
        call _d07019
:       attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        sfx SHOCK_A
        move UP_BACK, 9
        move FORWARD, 3
        frame 0, 2
        move BACK, 6
        frame 1, 2
        move FORWARD, 16
        move DOWN, 5
        frame 2, 2
        move BACK, 15
        move UP, 4
        frame 3, 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move BACK, 8
        move DOWN, 38
        frame 4, 2
        move UP_FORWARD, 8
        move DOWN, 2
        frame 5, 2
        move DOWN, 8
        move FORWARD, 3
        frame 6, 2
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP, 8
        move FORWARD, 10
        frame 7, 2
        move UP, 15
        move BACK, 9
        frame 8, 2
        move UP, 9
        move BACK, 9
        frame 9, 2
        move BACK, 8
        move DOWN, 8
        unpause_layer BG1
        loop 33
                frame 10
                end_loop
        loop 33
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0081: Shock (bg1) ]

_d068ba:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHOCK_CMD_BG1
        anim_script BG1
        sprite_priority 2
        mod_pal BG2, ADD, WHITE, 31
        move_bg1_here
        frame 0
        hide_bg1_thread
        sfx
        loop 49
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG2, ADD, WHITE, -1
                frame 0
                end_loop
        mod_pal BG1, SUB, WHITE, 0
        loop 33
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG1, SUB, WHITE, +1
                frame 0, 2
                end_loop
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0250: Dance Trip Up (sprite) ]

_d068e3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DANCE_FAIL_SPRITE
        anim_script SPRITE
        jump_step :+
        call _d07019
:       fixed_draw_order
        sfx
        call _d06931
        sfx
        call _d06931
        call _d0715d
        loop 9
                blank_frame
                end_loop
        call _d0715d
        sfx UMARO_TACKLE
        attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::DEAD_HORZ
        loop 32
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $007F: Dance (sprite) ]

_d0690e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DANCE_CMD_SPRITE
        anim_script SPRITE
        jump_step :+
        call _d07019
:       fixed_draw_order
        sfx
        call _d06931
        sfx
        call _d06931
        call _d0715d
        loop 9
                blank_frame
                end_loop
        sfx PRE_DANCE_B
        call _d0715d
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

_d06931:
        move_attacker UP, 3
        move UP, 3
        blank_frame
        move_attacker UP, 3
        move UP, 3
        blank_frame
        move_attacker UP, 2
        move UP, 2
        blank_frame
        move_attacker UP, 2
        move UP, 2
        blank_frame
        move_attacker UP, 1
        move UP, 1
        blank_frame
        move_attacker DOWN, 1
        move DOWN, 1
        blank_frame
        move_attacker DOWN, 2
        move DOWN, 2
        blank_frame
        move_attacker DOWN, 2
        move DOWN, 2
        blank_frame
        move_attacker DOWN, 3
        move DOWN, 3
        blank_frame
        move_attacker DOWN, 3
        move DOWN, 3
        blank_frame
        return

; ------------------------------------------------------------------------------

; [ Animation Script $007E: Runic (sprite) ]

_d06964:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RUNIC_CMD_SPRITE
        anim_script SPRITE
        move_to_attacker
        jump_step :+
        call _d07019
:       sfx DEFAULT, X_POS
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        anim_speed 5
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $007D: Blitz (bg1) ]

_d0697e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLITZ_CMD_SPRITE
        anim_script BG1
        move_to_attacker
        jump_step :+
        call _d07067
:       sfx DEFAULT, X_POS
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        mod_pal BG1, SUB, WHITE, 31
        anim_speed 3
        loop 17
                mod_pal BG1, SUB, WHITE, -2
                frame 0
                end_loop
        anim_speed 3
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        frame 6
        frame 7
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $007C: SwdTech (bg1) ]

_d069a4:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BUSHIDO_CMD_BG1
        anim_script BG1
        fixed_draw_order
        jump_step :+
        call _d07067
:       sfx DEFAULT, X_POS
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        move_to_attacker
        init_circle {0, 0}, 24, {255, 255}, 24, 0
        move_circle_to_attacker
        move BACK, 13
        move_circle {-48, 0}
        frame 0
        move_circle {+12, 0}
        frame 0
        update_circle
        frame 0
        hide_bg1_thread
        loop 19
                cycle_pal BG1_ANIM, 2, {1, 6}
                move_circle {+6, 0}
                update_circle
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $007A: Revert (sprite) ]

_d069da:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::REVERT_CMD_SPRITE
        anim_script SPRITE
        call _d07019
        fixed_draw_order
        call _d0715d
        toggle_attacker_status MORPH
        call _d0715d
        attacker_frame CHAR_FRAME::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $007B: Steal (sprite) ]

_d069f3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STEAL_CMD_SPRITE
        anim_script SPRITE, 1, BOTTOM
        sfx
        move_to_attacker
        calc_vec
        vec_offset 0
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_jump :-, 10
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 9
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_jump :-, -10
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0143: Leap (sprite) ]

_d06a14:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LEAP_CMD_SPRITE
        anim_script SPRITE, 1, BOTTOM
        call _d07019
        jump_hit :+
        end_anim_script
:       sfx
        move_to_attacker
        calc_vec
        vec_offset 0
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_jump :-, 6
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0079: Morph (bg1) ]

_d06a2b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MORPH_CMD_BG1
        anim_script BG1
        fixed_draw_order
        call _d07067
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        sfx DEFAULT, X_POS
        move_to_attacker
        mod_pal BG1, SUB, WHITE, 31
        loop 8
                mod_pal BG1, SUB, WHITE, -4
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                hide_bg1_thread
                end_loop
        cycle_pal BG1_ANIM, 1, {1, 6}
        toggle_attacker_status MORPH
        frame 0
        loop 33
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                end_loop
        loop 8
                mod_pal BG1, SUB, WHITE, +4
                cycle_pal BG1_ANIM, 2, {1, 6}
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0078: Rage/Lore (bg1) ]

_d06a64:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LORE_CMD_BG1
        anim_script BG1
        jump_step :+
        call _d07067
:       fixed_draw_order
        sfx DEFAULT, X_POS
        init_triangle {0, 0}, 0, 0
        move_triangle_to_attacker
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        mod_pal BG1, SUB, WHITE, 31
        zoom_triangle 0, +8
        update_triangle_2d
        frame 0
        hide_bg1_thread
        move_to_attacker
        loop 8
                mod_pal BG1, SUB, WHITE, -4
                cycle_pal BG1_ANIM, 4, {1, 7}
                zoom_triangle +4, +16
                update_triangle_2d
                frame 0
                end_loop
        loop 5
                cycle_pal BG1_ANIM, 4, {1, 7}
                zoom_triangle +4, +16
                update_triangle_2d
                frame 0
                end_loop
        loop 16
                cycle_pal BG1_ANIM, 4, {1, 7}
                zoom_triangle 0, +16
                update_triangle_2d
                frame 0
                end_loop
        loop 8
                mod_pal BG1, SUB, WHITE, +4
                cycle_pal BG1_ANIM, 4, {1, 7}
                zoom_triangle -4, +16
                update_triangle_2d
                frame 0
                end_loop
        normal_draw_order
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0077: Esper Magic (bg1) ]

_d06ac3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SUMMON_CMD_BG1
        anim_script BG1
        mod_pal SPRITE, SUB, WHITE, 31
        jump_step :+
        call _d07067
:       attacker_frame CHAR_FRAME::JUMPING_FORWARD
        sfx DEFAULT, X_POS
        loop 8
                mod_pal SPRITE, SUB, WHITE, -4
                blank_frame
                end_loop
        loop 24
                blank_frame
                end_loop
        loop 8
                mod_pal SPRITE, SUB, WHITE, +4
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0076: Esper Magic (sprite) ]

_d06ae6:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SUMMON_CMD_SPRITE
        anim_script SPRITE
        fixed_draw_order
        anim_priority 0
        move_to_attacker
        jump_step :+
        loop 8
                move FORWARD, 3
                blank_frame
                end_loop
:       loop 32
                update_genju_pre_anim
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0075: White/Effect Magic (sprite) ]

_d06afc:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WHITE_MAGIC_CMD_SPRITE
        anim_script SPRITE
        move_to_attacker
        jump_step :+
        loop 8
                move FORWARD, 3
                blank_frame
                end_loop
:       loop 33
                update_white_pre_anim
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0073: Black Magic (bg1) ]

_d06b0e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BLACK_MAGIC_CMD_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::WHITE_MAGIC_CMD_BG1
        anim_script BG1
        fixed_draw_order
        jump_step :+
        call _d07067
:       sfx DEFAULT, X_POS
        move_to_attacker
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
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

; [ Animation Script $0041: Monster Attack (sprite) ]

_d06b40:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MONSTER_ATTACK_SPRITE
        anim_script SPRITE
        jump_step :+
        call _d07019
:       attacker_frame CHAR_FRAME::JUMPING_FORWARD
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0072: Sketch (sprite) ]

_d06b4b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SKETCH_CMD_SPRITE
        anim_script SPRITE
        move_to_attacker
        move_if_flipped FORWARD, 2
        jump_step :+
        call _d07019
:       sfx
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        anim_speed 4
        move DOWN, 20
        move FORWARD, 18
        move UP, 7
        frame 0
        frame 2
        frame 3
        move DOWN, 9
        frame 4
        frame 5
        frame 6
        move UP, 9
        frame 7
        frame 0
        frame 1
        frame 2
        frame 3
        move DOWN, 9
        frame 4
        move UP, 9
        frame 3
        frame 2
        frame 1
        frame 0
        anim_speed 2
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0070: Spiraler (bg1) ]

_d06b80:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SPIRALER_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_147
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_148
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_149
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_150
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_151
        anim_script BG1
        fixed_draw_order
        sfx
        wait_scanline
        set_scroll_hdma BG1, 8
        mod_pal BG2, ADD, BLUE, 0
        blank_frame
        loop 8
                mod_pal BG2, ADD, BLUE, +2
                blank_frame
                end_loop
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        hide_bg1_thread
        call _d07172
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        move_to_attacker
        move UP, 64
        set_vec_target {128, 96}
        calc_vec
        vec_offset 0
        reset_tornado_pos
        move_tornado_to_anim
        loop 20
                move_tornado {2, 1}
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG1, SUB, WHITE, -2
                move_attacker UP, 8
                update_priority_tornado
                frame 0
                move_anim_to_vec
                end_loop
        hide_attacker_char
:       move_tornado_to_anim
        move_tornado {2, 1}
        cycle_pal BG1_ANIM, 2, {1, 7}
        update_priority_tornado
        frame 0
        move_vec :-, 1
        loop 129
                move_tornado {2, 1}
                cycle_pal BG1_ANIM, 2, {1, 7}
                update_priority_tornado
                frame 0
                end_loop
        loop 20
                move_tornado {2, 1}
                cycle_pal BG1_ANIM, 2, {1, 7}
                mod_pal BG1, SUB, WHITE, +2
                move_attacker DOWN, 8
                update_priority_tornado
                frame 0
                end_loop
        set_scroll_hdma BG1, 3
        reset_tornado_pos
        attacker_frame CHAR_FRAME::NONE
        loop 8
                mod_pal BG2, ADD, BLUE, -2
                frame 0
                end_loop
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $006F: Bum Rush (sprite) ]

_d06bfb:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BUM_RUSH_SPRITE
        anim_script SPRITE, 1, BOTTOM
        move_to_attacker
        calc_vec_char
        enable_echo_sprites 1
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_char :-, 6, 32
        sfx
        init_bum_rush_pos
        fixed_draw_order
        set_scroll_hdma BG1, 6
        init_scroll_wave BG1, 4, 2, HORZ
        loop 16
                update_bum_rush :+, +8, 0
                blank_frame
                end_loop
:       attacker_frame CHAR_FRAME::NONE
        attacker_action CHAR_ACTION::SPINNING
        call _d06c76
        call _d06c76
        call _d06c76
        attacker_priority 2
        loop 16
                update_bum_rush :+, +4, -8
:               update_scroll_wave BG1, HORZ
                blank_frame
                end_loop
        attacker_priority 3
        loop 4
                update_bum_rush :+, -8, -8
:               mod_pal BG2, ADD, WHITE, 0
                update_scroll_wave BG1, HORZ
                blank_frame
                update_bum_rush :+, -8, -8
:               mod_pal BG2, ADD, WHITE, 0
                update_scroll_wave BG1, HORZ
                blank_frame
                end_loop
        loop 17
                update_bum_rush :+, -8, 0
:               mod_pal BG2, ADD, WHITE, 0
                update_scroll_wave BG1, HORZ
                blank_frame
                end_loop
        reset_scroll_hdma BG1
        attacker_action CHAR_ACTION::NONE
        set_scroll_hdma BG1, 3
        normal_draw_order
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -6, 32
        attacker_frame CHAR_FRAME::NEAR_FATAL + $30
        loop 32
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        disable_echo_sprites 1
        end_anim_script

_d06c76:
        attacker_priority 2
        loop 8
                update_bum_rush :+, +4, -8
:               mod_pal BG2, ADD, WHITE, 31
                update_scroll_wave BG1, HORZ
                blank_frame
                update_bum_rush :+, +4, -8
:               mod_pal BG2, ADD, WHITE, 0
                update_scroll_wave BG1, HORZ
                blank_frame
                end_loop
        attacker_priority 3
        loop 8
                update_bum_rush :+, +4, -8
:               mod_pal BG2, ADD, WHITE, 31
                update_scroll_wave BG1, HORZ
                blank_frame
                update_bum_rush :+, +4, -8
:               mod_pal BG2, ADD, WHITE, 0
                update_scroll_wave BG1, HORZ
                blank_frame
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $006E: Mantra (bg1) ]

_d06ca5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MANTRA_BG1
        anim_script BG1
        fixed_draw_order
        move_bg1_here
        sfx
        init_scroll_wave BG1, 4, 2, HORZ
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        set_scroll_hdma BG1, 6
        mod_pal BG1, SUB, WHITE, 0
        init_circle {0, 0}, 2, {222, 255}, 127, 0
        move_circle_to_attacker
        move_circle {0, +3}
        loop 41
                cycle_pal BG1_ANIM, 1, {1, 7}
                zoom_circle +2
                update_circle
                update_scroll_wave BG1, HORZ
                frame 0
                end_loop
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        loop 16
                mod_pal BG1, SUB, WHITE, +2
                cycle_pal BG1_ANIM, 1, {1, 7}
                update_circle
                update_scroll_wave BG1, HORZ
                frame 0
                end_loop
        reset_scroll_hdma BG1
        attacker_frame CHAR_FRAME::NONE
        set_scroll_hdma BG1, 3
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $006C: Air Blade Hit (sprite) ]

_d06ced:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AIR_BLADE_SPRITE
        anim_script SPRITE
        fixed_draw_order
        move_to_attacker
        calc_vec
        vec_offset 16
        move BACK, 16
        attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
        frame 0, 2
        frame 1, 2
        attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
        frame 2, 2
        frame 3, 2
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_UP
        frame 4, 2
        frame 5, 2
        attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
        frame 6, 2
        unpause_layer BG1
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        sfx
:       frame 7
        move_vec :-, 8
        sfx DRAIN
        anim_speed 3
        move FORWARD, 16
        frame 8
        move_target FORWARD, 2
        frame 7
        move_target BACK, 2
        frame 9
        move_target FORWARD, 2
        frame 10
        move_target BACK, 2
        frame 11
        move_target FORWARD, 2
        frame 12
        move_target BACK, 2
        frame 13
        move_target FORWARD, 2
        frame 14
        move_target BACK, 2
        frame 15
        move_target FORWARD, 2
        frame 16
        move_target BACK, 2
        frame 17
        move_target FORWARD, 2
        frame 18
        move_target BACK, 2
        frame 19
        frame 20
        frame 21
        frame 22
        frame 23
        attacker_frame CHAR_FRAME::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $006D: Air Blade (bg1) ]

_d06d51:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AIR_BLADE_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        sprite_priority 2
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG1, SUB, WHITE, -1
        cycle_pal BG1_ANIM, 2, {1, 7}
        frame 0
        hide_bg1_thread
        loop 33
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 33
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 33
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $006B: Fire Dance (bg1) ]

_d06d7b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_DANCE_BG1
        anim_script BG1
        set_blank_frame 31
        fixed_draw_order
        hide_bg1_thread
        sfx
        mod_pal BG2, SUB, CYAN, 0
        attacker_action CHAR_ACTION::CASTING
        loop 8
                mod_pal BG2, SUB, CYAN, +2
                blank_frame
                end_loop
        init_scroll_wave BG2, 8, 2, HORZ
        loop 53
                update_scroll_wave BG2, HORZ
                frame 0
                update_scroll_wave BG2, HORZ
                frame 0
                update_scroll_wave BG2, HORZ
                frame 0
                end_loop
        init_scroll_wave BG2, 6, 2, HORZ
        call _d06dbd
        init_scroll_wave BG2, 4, 2, HORZ
        call _d06dbd
        init_scroll_wave BG2, 2, 2, HORZ
        call _d06dbd
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, HORZ
        loop 16
                mod_pal BG2, SUB, CYAN, -1
                frame 0, 2
                end_loop
        normal_draw_order
        end_anim_script

_d06dbd:
        update_scroll_wave BG2, HORZ
        frame 0
        update_scroll_wave BG2, HORZ
        frame 0
        update_scroll_wave BG2, HORZ
        frame 0
        return

; ------------------------------------------------------------------------------

; [ Animation Script $006A: Fire Dance (sprite) ]

_d06dc7:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FIRE_DANCE_SPRITE
        anim_script SPRITE
        loop 33
                blank_frame
                end_loop
        move_to_attacker
        move UP, 32
        rand_vec
        loop 129
                update_fire_dance 127
                move FORWARD, 1
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

_d06ddb:
        calc_vec
        vec_offset 0
:       blank_frame
        move_vec_jump :-, 8
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0069: Suplex (sprite) ]

_d06de3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SUPLEX_SPRITE
        anim_script SPRITE, 1, BOTTOM
        move_to_attacker
        calc_vec
        vec_offset 0
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        sfx STEAL
:       blank_frame
        move_vec_jump :-, 8
        fixed_draw_order
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 9
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        jump_hit _d06e0c
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_jump :-, -8
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

_d06e0c:
        sfx JUMP
        loop 22
                move_attacker UP, 8
                move_target UP, 8
                blank_frame
                end_loop
        loop 32
                blank_frame
                end_loop
        flip_monster VERT
        vflip_target_char
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 22
                move_attacker DOWN, 8
                move_target DOWN, 8
                blank_frame
                end_loop
        sfx EVENT_HIT
        loop 8
                scroll_bg {+2, +1}
                blank_frame
                scroll_bg {-2, -1}
                blank_frame
                end_loop
        scroll_bg {0, 0}
        flip_monster VERT
        vflip_target_char
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_jump :-, -8
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0066: AuraBolt (bg1) ]

_d06e48:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AURABOLT_BG1
        anim_script BG1
        wait_scanline
        color_math {ADD, SUBSCREEN}, BG1, {BG2, SPRITE}
        move_to_attacker_char
        move FORWARD, 135
        move DOWN, 16
        frame 0, 2
        frame 1, 2
        frame 2, 2
        frame 3, 2
        frame 4, 2
        move_target FORWARD, 5
        frame 5
        move_target FORWARD, 5
        frame 5
        move_target FORWARD, 5
        frame 6, 2
        frame 7, 2
        frame 8, 2
        frame 9, 2
        frame 10, 2
        frame 11, 2
        move_target BACK, 5
        frame 12
        move_target BACK, 5
        frame 12
        move_target BACK, 5
        frame 13, 2
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0067: AuraBolt (bg3) ]

_d06e87:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AURABOLT_BG3
        anim_script BG3, 1, FRONT_NEAR
        move_bg3_here
        mod_pal BG3, SUB, WHITE, 31
        frame 0
        hide_bg3_thread
        init_circle {0, 0}, 1, {255, 255}, 127, 0
        move_circle_to_attacker_char
        move_circle {0, -20}, 0
        move_circle {-8, 0}
        update_circle
        loop 19
                mod_pal BG3, SUB, WHITE, -2
                zoom_circle +2
                update_circle
                frame 0
                end_loop
        loop 4
                move_circle {0, +8}, -8
                update_circle
                frame 0
                end_loop
        frame 0
        attacker_frame CHAR_FRAME::CASTING_1
        unpause_layer BG1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0068: AuraBolt (sprite) ]

_d06ebc:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AURABOLT_SPRITE
        anim_script SPRITE, 1, FRONT_FAR
        move_to_attacker
        calc_vec_char
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_char :-, 8, 32
        fixed_draw_order
        unpause_layer BG3
        sfx
        loop 101
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 32
        attacker_frame CHAR_FRAME::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0065: Pummel, MoogleRush (sprite) ]

_d06ee0:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PUMMEL_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        move_to_attacker
        calc_vec_char
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_char :-, 8, 32
        fixed_draw_order
        unpause_layer BG1
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 10
        move_if_flipped FORWARD, 2
        call _d07f31
        normal_draw_order
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 32
        sfx NONE
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D9: Cleave (sprite) ]

_d06f0c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLEAVE_SPRITE
        anim_script SPRITE
        save_attacker_dir
        enable_echo_sprites 1
        anim_draw_order RIGHT_HAND
        move_to_attacker
        set_vec_target {16, 112}
        calc_vec
        vec_offset 0
        move_if_flipped FORWARD, 2
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move DOWN, 19
        move BACK, 22
        sfx STEAL
:       frame 0
        move_vec_jump :-, 12
        fixed_draw_order
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 17
                blank_frame
                end_loop
        sfx RETORT
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        loop 20
                move_attacker UP, 8
                blank_frame
                end_loop
        restore_attacker_dir
        clear_pos_offset
        loop 20
                move_attacker UP, 9
                end_loop
        normal_draw_order
        loop 20
                move_attacker DOWN, 9
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 9
                blank_frame
                end_loop
        sfx CLEAVE
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move_to_attacker_char
        move BACK, 22
        move DOWN, 26
        frame 0, 2
        move FORWARD, 4
        move DOWN, 3
        frame 1, 2
        move FORWARD, 34
        move UP, 5
        frame 2, 2
        move DOWN, 2
        move FORWARD, 3
        frame 3, 2
        move UP, 42
        move BACK, 3
        frame 4, 2
        move BACK, 4
        move UP, 2
        frame 5, 2
        move BACK, 37
        move DOWN, 4
        loop 17
                frame 6
                end_loop
        disable_echo_sprites 3
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D7: Empowerer (bg1) ]

_d06f95:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EMPOWERER_BG1
        anim_script BG1
        fixed_draw_order
        set_scroll_hdma BG1, 6
        move_to_attacker
        calc_vec
        vec_offset 16
        mod_pal BG1, SUB, WHITE, 31
        frame 0
        mod_pal BG2, SUB, YELLOW, 0
        hide_bg1_thread
        loop 8
                mod_pal BG2, SUB, YELLOW, +1
                frame 0, 2
                end_loop
:       frame 0
        mod_pal BG1, SUB, WHITE, -4
        move_vec :-, 4
        sfx CALMNESS
        loop 16
                move_target FORWARD, 3
                mod_pal BG2, SUB, YELLOW, -1
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                move_target BACK, 3
                mod_pal BG2, SUB, YELLOW, -1
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        loop 16
                mod_pal BG2, SUB, YELLOW, -1
                mod_pal BG1, SUB, WHITE, +1
                frame 0
                end_loop
        normal_draw_order
        set_scroll_hdma BG1, 3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D8: Empowerer (sprite) ]

_d06fd3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::EMPOWERER_SPRITE
        anim_script SPRITE
        move_to_attacker
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP_BACK, 22
        move_if_flipped FORWARD, 2
        unpause_layer BG1
        loop 17
                blank_frame
                end_loop
        sfx
        frame 0
        move UP, 17
        move FORWARD, 18
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        frame 2, 2
        move DOWN_FORWARD, 29
        loop 17
                frame 3
                end_loop
        loop 33
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0059: Stunner Hit (bg1) ]

_d07001:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STUNNER_BG1
        anim_script SPRITE, 1, SCREEN
        move_bg1_here
        sprite_priority 2
        move UP_BACK, 128
        frame 0
        hide_bg1_thread
        loop 33
                move DOWN_FORWARD, 12
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ step forward (sprite) ]

_d07019:
        set_blank_frame 31
        jump_magitek _d0701e, _d07033
_d0701e:
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 24
                move FORWARD, 1
                move_attacker FORWARD, 1
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        return
_d07033:
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 8
                move FORWARD, 3
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        return

; ------------------------------------------------------------------------------

; [ step back (sprite) ]

_d07040:
        set_blank_frame 31
        jump_magitek _d07045, _d0705a
_d07045:
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 24
                move BACK, 1
                move_attacker BACK, 1
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        return
_d0705a:
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 8
                move BACK, 3
                move_attacker BACK, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        return

; ------------------------------------------------------------------------------

; [ step forward (bg1) ]

_d07067:
        set_blank_frame 15
        jump_magitek _d0706c, _d07081
_d0706c:
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 24
                move FORWARD, 1
                move_attacker FORWARD, 1
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        return

_d07081:
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 8
                move FORWARD, 3
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        return

; ------------------------------------------------------------------------------

; [ step back (bg1) ]

_d0708e:
        set_blank_frame 15
        jump_magitek _d07093, _d070a8
_d07093:
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 24
                move BACK, 1
                move_attacker BACK, 1
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        return

_d070a8:
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 8
                move BACK, 3
                move_attacker BACK, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        return

; ------------------------------------------------------------------------------

; [ step forward (bg3) ]

_d070b5:
        set_blank_frame 9
        jump_magitek _d070ba, _d070cf
_d070ba:
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 24
                move FORWARD, 1
                move_attacker FORWARD, 1
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        return

_d070cf:
        attacker_action CHAR_ACTION::WALKING_FORWARD
        loop 8
                move FORWARD, 3
                move_attacker FORWARD, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        return

; ------------------------------------------------------------------------------

; [ step back (bg3) ]

_d070dc:
        set_blank_frame 9
        jump_magitek _d070e1, _d070f6
_d070e1:
        magitek_action 1
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 24
                move BACK, 1
                move_attacker BACK, 1
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        magitek_action 0
        return

_d070f6:
        attacker_action CHAR_ACTION::WALKING_BACK
        loop 8
                move BACK, 3
                move_attacker BACK, 3
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        return

; ------------------------------------------------------------------------------

; [ step forward (fight, frame 0) ]

_d07103:
        jump_magitek _d07108, _d07117
_d07108:
        magitek_action 1
        loop 24
                fight_anim 0
                frame 0
                end_loop
        magitek_action 0
        return

_d07117:
        fight_anim 0
        frame 0
        fight_anim 1
        frame 0
        fight_anim 2
        frame 0
        fight_anim 3
        frame 0
        fight_anim 4
        frame 0
        fight_anim 5
        frame 0
        fight_anim 6
        frame 0
        fight_anim 7
        frame 0
        return

; ------------------------------------------------------------------------------

; [ step forward (fight, blank frame) ]

_d07130:
        set_blank_frame 31
        jump_magitek _d07135, _d07144
_d07135:
        magitek_action 1
        loop 24
                fight_anim 0
                blank_frame
; *** bug ***
; should end loop before resetting magitek action
                magitek_action 0
                end_loop
        return
_d07144:
        fight_anim 0
        blank_frame
        fight_anim 1
        blank_frame
        fight_anim 2
        blank_frame
        fight_anim 3
        blank_frame
        fight_anim 4
        blank_frame
        fight_anim 5
        blank_frame
        fight_anim 6
        blank_frame
        fight_anim 7
        blank_frame
        return

; ------------------------------------------------------------------------------

; [ spin character (sprite) ]

_d0715d:
        set_blank_frame 31
        attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
        blank_frame 2
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_UP
        blank_frame 2
        attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame 2
        attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
        blank_frame 2
        return

; ------------------------------------------------------------------------------

; [ spin character (bg1) ]

_d07172:
        set_blank_frame 15
        attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
        blank_frame 2
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_UP
        blank_frame 2
        attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
        blank_frame 2
        attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
        blank_frame 2
        return

; ------------------------------------------------------------------------------

; [ spin character (sprite, stunner) ]

_d07187:
        set_blank_frame 31
        attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_FORWARD
        update_scroll_wave BG2, HORZ
        blank_frame
        update_scroll_wave BG2, HORZ
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_UP
        update_scroll_wave BG2, HORZ
        blank_frame
        update_scroll_wave BG2, HORZ
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_FORWARD + $30
        update_scroll_wave BG2, HORZ
        blank_frame
        update_scroll_wave BG2, HORZ
        blank_frame
        attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_DOWN
        update_scroll_wave BG2, HORZ
        blank_frame
        update_scroll_wave BG2, HORZ
        blank_frame
        return

; ------------------------------------------------------------------------------

; [ Animation Script $01D6: Stunner (sprite) ]

; d0/71ac
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STUNNER_SPRITE
        anim_script SPRITE
        fixed_draw_order
        sfx
        move_to_attacker
        anim_draw_order RIGHT_HAND
        move_if_flipped FORWARD, 2
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        mod_pal BG2, ADD, BLUE, 0
        init_scroll_wave BG2, 8, 2, HORZ
        move UP_BACK, 29
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 0
        move FORWARD, 10
        move UP, 6
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 1
        move FORWARD, 41
        move DOWN, 7
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 2
        move DOWN, 4
        move FORWARD, 6
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 3
        move DOWN, 47
        move BACK, 7
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 4
        move DOWN, 5
        move BACK, 10
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 5
        move BACK, 10
        move BACK, 32
        move UP, 6
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 6
        move UP, 3
        move BACK, 5
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 7
        move UP_FORWARD, 19
        move FORWARD, 17
        move UP_BACK, 29
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 0
        move FORWARD, 10
        move UP, 6
        mod_pal BG2, ADD, BLUE, +4
        update_scroll_wave BG2, HORZ
        frame 1
        move DOWN_FORWARD, 29
        move BACK, 10
        move DOWN, 6
        call _d07187
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        loop 21
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        unpause_layer BG1
        move UP_BACK, 23
        update_scroll_wave BG2, HORZ
        frame 0
        update_scroll_wave BG2, HORZ
        frame 0
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move UP, 6
        move FORWARD, 25
        update_scroll_wave BG2, HORZ
        frame 8
        update_scroll_wave BG2, HORZ
        frame 8
        update_scroll_wave BG2, HORZ
        frame 9
        update_scroll_wave BG2, HORZ
        frame 9
        move DOWN_FORWARD, 17
        move FORWARD, 6
        loop 4
                update_scroll_wave BG2, HORZ
                frame 2
                end_loop
        loop 17
                mod_pal BG2, ADD, BLUE, -2
                update_scroll_wave BG2, HORZ
                restore_target_pal  ; pretty sure this has no effect here
                frame 2
                end_loop
        init_scroll_wave BG2, 6, 2, HORZ
        loop 4
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        init_scroll_wave BG2, 4, 2, HORZ
        loop 4
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        init_scroll_wave BG2, 2, 2, HORZ
        loop 4
                update_scroll_wave BG2, HORZ
                blank_frame
                end_loop
        init_scroll_wave BG2, 0, 0, HORZ
        update_scroll_wave BG2, HORZ
        attacker_frame CHAR_FRAME::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D4: unused bushido (sprite) ]

; d0/7288
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNUSED_BUSHIDO_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        fixed_draw_order
        unpause_layer BG1
        enable_echo_sprites 1
        save_attacker_dir
        move_to_attacker
        calc_vec
        vec_offset 0
        move UP, 8
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
:       blank_frame
        move_vec_jump :-, 8
        normal_draw_order
        blank_frame
        fixed_draw_order
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 26
        move DOWN, 20
        move_if_flipped FORWARD, 2
        frame 0, 4
        move FORWARD, 18
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 4
        anim_draw_order LEFT_HAND
        move UP, 6
        frame 2, 4
        frame 3, 4
        loop 3
                move_target FORWARD, 6
                blank_frame
                end_loop
        loop 9
                move_target FORWARD, 3
                blank_frame
                move_target BACK, 3
                blank_frame
                end_loop
        loop 3
                move_target BACK, 6
                blank_frame
                end_loop
        move UP, 38
        move BACK, 15
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move_if_flipped FORWARD, 2
        move_attacker UP, 3
        move_attacker FORWARD, 4
        move UP, 3
        move FORWARD, 4
        frame 4
        move_attacker UP, 3
        move_attacker FORWARD, 4
        move UP, 3
        move FORWARD, 4
        frame 4
        move_attacker UP, 2
        move_attacker FORWARD, 4
        move UP, 2
        move FORWARD, 4
        frame 4
        move_attacker UP, 1
        move_attacker FORWARD, 4
        move UP, 1
        move FORWARD, 4
        frame 4
        move_attacker FORWARD, 4
        move FORWARD, 4
        frame 4
        move_attacker DOWN, 2
        move_attacker FORWARD, 4
        move DOWN, 2
        move FORWARD, 4
        frame 4
        move_attacker DOWN, 3
        move_attacker FORWARD, 4
        move DOWN, 3
        move FORWARD, 4
        frame 4
        move_attacker DOWN, 4
        move_attacker FORWARD, 4
        move DOWN, 4
        move FORWARD, 4
        frame 4
        move UP, 11
        move FORWARD, 21
        frame 5, 2
        frame 6, 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move DOWN, 25
        move FORWARD, 27
        loop 9
                frame 7
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 9
                move_target DOWN, 3
                blank_frame
                move_target UP, 3
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD
        loop 20
                move_attacker UP, 9
                blank_frame
                end_loop
        move_attacker BACK, 32
        restore_attacker_dir
        clear_pos_offset
        loop 20
                move_attacker UP, 9
                end_loop
        normal_draw_order
        loop 20
                move_attacker DOWN, 9
                blank_frame
                end_loop
        attacker_frame CHAR_FRAME::NEAR_FATAL
        loop 33
                blank_frame
                end_loop
        disable_echo_sprites 3
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D5: unused bushido (bg1) ]

; d0/7376
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNUSED_BUSHIDO_BG1
        anim_script BG1, 1, SCREEN
        move_bg1_here
        sprite_priority 2
        mod_pal BG1, SUB, WHITE, 31
        mod_pal BG1, SUB, WHITE, -1
        cycle_pal BG1_ANIM, 2, {1, 7}
        frame 0
        hide_bg1_thread
        sfx
        loop 33
                mod_pal BG1, SUB, WHITE, -1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 65
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        loop 33
                mod_pal BG1, SUB, WHITE, +1
                cycle_pal BG1_ANIM, 2, {1, 7}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D3: Quadra Slam, Quadra Slice (sprite) ]

; d0/73a2
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::QUADRA_SLAM_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        jump_quad _d073ad, _d073fb, _d07431, _d0747a

; first hit
_d073ad:
        save_attacker_dir
        move_to_attacker
        calc_vec
        double_action_speed
        vec_offset 0
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP, 8
        sfx STEAL
:       blank_frame
        move_vec_jump :-, 6
        unpause_layer BG1
        sfx
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        attacker_action CHAR_ACTION::NONE
        move_if_flipped FORWARD, 2
        move UP_BACK, 23
        frame 4, 4
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move UP, 11
        move FORWARD, 21
        mod_pal BG2, ADD, WHITE, 31
        frame 5, 4
        frame 6, 4
        move DOWN, 23
        move FORWARD, 27
        loop 9
                move_target DOWN, 4
                mod_pal BG2, ADD, WHITE, -2
                frame 7
                move_target UP, 4
                mod_pal BG2, ADD, WHITE, -2
                frame 7
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; second hit
_d073fb:
        enable_echo_sprites 1
        move UP, 8
        call _d07465
        mod_pal BG2, ADD, GREEN, 31
        attacker_action CHAR_ACTION::NONE
        move_to_attacker_char
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 26
        move DOWN, 28
        frame 0, 2
        move FORWARD, 18
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        anim_draw_order LEFT_HAND
        move UP, 6
        frame 2, 2
        move_if_flipped FORWARD, 2
        loop 5
                move_target FORWARD, 3
                mod_pal BG2, ADD, GREEN, -4
                frame 3
                move_target BACK, 3
                mod_pal BG2, ADD, GREEN, -4
                frame 3
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; third hit
_d07431:
        move UP, 8
        call _d07465
        mod_pal BG2, ADD, BLUE, 31
        attacker_action CHAR_ACTION::NONE
        move_to_attacker_char
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 26
        move DOWN, 28
        frame 0, 2
        move FORWARD, 18
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        anim_draw_order LEFT_HAND
        move UP, 6
        frame 2, 2
        move_if_flipped FORWARD, 2
        loop 5
                move_target FORWARD, 3
                mod_pal BG2, ADD, BLUE, -4
                frame 3
                move_target BACK, 3
                mod_pal BG2, ADD, BLUE, -4
                frame 3
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

_d07465:
        anim_draw_order RIGHT_HAND
        calc_vec_spiral
        attacker_action CHAR_ACTION::LAUGHING_ALT
        sfx STEAL
:       blank_frame
        move_vec_spiral :-, 6
        unpause_layer BG1
        loop 17
                blank_frame
                end_loop
        sfx
        return

; fourth hit and return
_d0747a:
        anim_draw_order RIGHT_HAND
        calc_vec_spiral
        move UP, 8
        attacker_action CHAR_ACTION::LAUGHING_ALT
:       blank_frame
        move_vec_spiral :-, 6
        unpause_layer BG1
        loop 17
                blank_frame
                end_loop
        sfx
        disable_echo_sprites 1
        mod_pal BG2, ADD, RED, 31
        attacker_action CHAR_ACTION::NONE
        move_to_attacker_char
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 26
        move DOWN, 28
        frame 0, 2
        move FORWARD, 18
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        anim_draw_order LEFT_HAND
        move UP, 6
        frame 2, 2
        move_if_flipped FORWARD, 2
        loop 5
                move_target FORWARD, 3
                mod_pal BG2, ADD, RED, -4
                frame 3
                move_target BACK, 3
                mod_pal BG2, ADD, RED, -4
                frame 3
                end_loop
        attacker_frame CHAR_FRAME::NONE
        restore_attacker_dir
        set_target_char_return
        attacker_action CHAR_ACTION::WALKING_BACK
:       blank_frame
        move_vec_spiral :-, 6
        clear_pos_offset
        attacker_action CHAR_ACTION::LAUGHING_ALT
        loop 9
                blank_frame
                end_loop
        attacker_action CHAR_ACTION::NONE
        normal_action_speed
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D1: Slash (sprite) ]

_d074d5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLASH_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        move_to_attacker
        calc_vec_char
        set_scroll_hdma BG1, 6
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 27
        move DOWN, 12
        sfx STEAL
:       frame 0
        move_vec_char :-, 8, 24
        unpause_layer BG3
        sfx
        init_scroll_wave BG1, 6, 4, HORZ
        move FORWARD, 17
        mod_pal BG2, ADD, WHITE, 31
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        loop 8
                update_scroll_wave BG1, HORZ
                mod_pal BG2, ADD, WHITE, -2
                frame 1
                end_loop
        move UP, 8
        loop 8
                update_scroll_wave BG1, HORZ
                mod_pal BG2, ADD, WHITE, -2
                frame 2
                end_loop
        loop 8
                update_scroll_wave BG1, HORZ
                frame 3
                end_loop
        init_scroll_wave BG1, 4, 1, HORZ
        update_scroll_wave BG1, HORZ
        blank_frame 2
        init_scroll_wave BG1, 2, 1, HORZ
        update_scroll_wave BG1, HORZ
        blank_frame 2
        init_scroll_wave BG1, 1, 1, HORZ
        update_scroll_wave BG1, HORZ
        blank_frame 2
        reset_scroll_hdma BG1
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
        wait_scanline
        set_scroll_hdma BG1, 3
:       blank_frame
        move_vec_char :-, -8, 24
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D2: slash (bg3) ]

_d07538:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SLASH_BG3
        anim_script BG3
        fixed_draw_order
        mod_pal BG3, ADD, WHITE, 31
        init_circle {0, 0}, 66, {255, 255}, 127, 0
        move_circle_to_target
        loop 16
                mod_pal BG3, ADD, WHITE, -2
                zoom_circle -4
                update_circle
                frame 0
                hide_bg3_thread
                end_loop
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01D0: Retort (sprite) ]

_d07557:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RETORT_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        move_to_attacker
        calc_vec_char
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP_BACK, 22
        move UP, 8
        sfx STEAL
:       frame 0
        move_vec_char :-, 8, 24
        sfx RETORT
        unpause_layer BG1
        move UP, 17
        move FORWARD, 18
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        frame 2, 2
        move DOWN_FORWARD, 29
        move_if_flipped FORWARD, 2
        loop 17
                frame 3
                end_loop
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 24
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $01CF: Dispatch (sprite) ]

_d0758e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DISPATCH_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        move_to_attacker
        calc_vec_char
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move_if_flipped FORWARD, 2
        move UP, 18
        move FORWARD, 26
        set_scroll_hdma BG1, 6
        enable_echo_sprites 1
        sfx WARP
:       frame 3
        move_vec_char :-, 8, 24
        fixed_draw_order
        sfx
        init_scroll_wave BG1, 7, 4, HORZ
        loop 33
                update_scroll_wave BG1, HORZ
                frame 3
                end_loop
        init_scroll_wave BG1, 5, 4, HORZ
        update_scroll_wave BG1, HORZ
        frame 3, 2
        init_scroll_wave BG1, 3, 4, HORZ
        update_scroll_wave BG1, HORZ
        frame 3, 2
        init_scroll_wave BG1, 1, 4, HORZ
        update_scroll_wave BG1, HORZ
        frame 3, 2
        reset_scroll_hdma BG1
        set_scroll_hdma BG1, 3
        normal_draw_order
        attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30
:       blank_frame
        move_vec_char :-, -8, 24
        attacker_frame CHAR_FRAME::NONE
        loop 32
                blank_frame
                end_loop
        disable_echo_sprites 1
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0057: Air Anchor (sprite) ]

_d075e2:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AIR_ANCHOR_SPRITE
        anim_script SPRITE
        loop 17
                blank_frame
                end_loop
        move_to_attacker
        calc_vec
        jump_step :+
        move FORWARD, 24
:       sfx
        move DOWN, 4
        frame 1
        move FORWARD, 8
        frame 1
        vec_offset 0
:       frame 1
        move_vec_arc :-, 8
        move_target FORWARD, 8
:       frame 1
        move_vec_arc :-, 8
        loop 5
                move_target FORWARD, 1
                move FORWARD, 1
                blank_frame
                move_target BACK, 1
                move BACK, 1
                blank_frame
                end_loop
        move_target BACK, 8
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0058: Air Anchor (extra) ]

_d07612:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AIR_ANCHOR_EXTRA
        anim_script SPRITE
        jump_step :+
        call _d07019
:       move_to_attacker
        attacker_frame CHAR_FRAME::READY
        move FORWARD, 13
        move DOWN, 5
        loop 65
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0053: Debilitator (sprite) ]

_d07629:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DEBILITATOR_SPRITE
        anim_script SPRITE, 5, CENTER
        frame 1
        frame 2
        frame 3
        frame 4
        frame 5
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0054: Debilitator (bg1) ]

_d07631:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DEBILITATOR_BG1
        anim_script BG1
        hide_bg1_thread
        loop 41
                blank_frame
                end_loop
        move_to_attacker
        init_circle {128, 75}, 1, {255, 255}, 29, 0
        move_circle_to_attacker
        jump_step :+
        move FORWARD, 24
        move_circle {-24, 0}
:       show_bg1_thread
        frame 0
        hide_bg1_thread
        loop 33
                zoom_circle +1
                update_circle
                cycle_pal BG1_ANIM, 4, {2, 4}
                frame 0
                end_loop
        loop 65
                cycle_pal BG1_ANIM, 4, {2, 4}
                frame 0
                end_loop
        loop 29
                zoom_circle -1
                update_circle
                cycle_pal BG1_ANIM, 4, {2, 4}
                frame 0
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0055: Debilitator (bg3) ]

_d0766f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DEBILITATOR_BG3
        anim_script BG3, 1, SCREEN
        move_to_attacker
        jump_step :+
        move FORWARD, 24
:       sfx
        hide_bg3_thread
        loop 71
                frame 1
                end_loop
        mosaic BG3, 15
        show_bg3_thread
        frame 0
        hide_bg3_thread
        mosaic BG3, 8
        call _d076b6
        mosaic BG3, 7
        call _d076b6
        mosaic BG3, 6
        call _d076b6
        mosaic BG3, 5
        call _d076b6
        mosaic BG3, 4
        call _d076b6
        mosaic BG3, 3
        call _d076b6
        mosaic BG3, 2
        call _d076b6
        mosaic BG3, 1
        call _d076b6
        mosaic {}, 0
        loop 21
                call _d076b6
                end_loop
        end_anim_script

_d076b6:
        cycle_pal BG3_ANIM, 8, {1, 3}
        frame 0, 2
        return

; ------------------------------------------------------------------------------

; [ Animation Script $0056: Debilitator (extra) ]

_d076bc:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DEBILITATOR_EXTRA
        anim_script SPRITE
        fixed_draw_order
        jump_step :+
        call _d07019
:       move_to_attacker
        move DOWN_BACK, 25
        loop 161
                frame 0
                end_loop
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0050: Chain Saw 1 (sprite) ]

_d076cf:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHAIN_SAW_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        jump_step :+
        call _d07019
:       attacker_frame CHAR_FRAME::READY
        move_to_attacker
        calc_vec_char
        move FORWARD, 12
        move DOWN, 5
:       cycle_pal SPRITE_ANIM, 8, {2, 4}
        frame 0
        move_vec_char :-, 4, 32
        sfx
        loop 3
                move BACK, 20
                move DOWN, 3
                attacker_frame CHAR_FRAME::WALKING_DOWN_3
                move_attacker FORWARD, 1
                move FORWARD, 1
                call _d077d5
                frame 1
                call _d077db
                frame 1
                call _d077d5
                frame 1
                move BACK, 4
                move UP, 3
                attacker_frame CHAR_FRAME::READY + $30
                move_attacker FORWARD, 1
                move FORWARD, 1
                call _d077db
                frame 2
                call _d077d5
                frame 2
                call _d077db
                frame 2
                move FORWARD, 4
                move UP, 21
                anim_draw_order BACK
                attacker_frame CHAR_FRAME::WALKING_UP_3
                move_attacker FORWARD, 1
                move FORWARD, 1
                call _d077d5
                frame 3
                call _d077db
                frame 3
                call _d077d5
                frame 3
                anim_draw_order FRONT
                move FORWARD, 20
                move DOWN, 21
                attacker_frame CHAR_FRAME::READY
                move_attacker FORWARD, 1
                move FORWARD, 1
                call _d077db
                frame 0
                call _d077d5
                frame 0
                call _d077db
                frame 0
                end_loop
        loop 3
                move BACK, 20
                move DOWN, 3
                attacker_frame CHAR_FRAME::WALKING_DOWN_3
                move_attacker BACK, 1
                move BACK, 1
                call _d077e1
                frame 1
                call _d077e7
                frame 1
                call _d077e1
                frame 1
                move BACK, 4
                move UP, 3
                attacker_frame CHAR_FRAME::READY + $30
                move_attacker BACK, 1
                move BACK, 1
                call _d077e7
                frame 2
                call _d077e1
                frame 2
                call _d077e7
                frame 2
                move FORWARD, 4
                move UP, 21
                anim_draw_order BACK
                attacker_frame CHAR_FRAME::WALKING_UP_3
                move_attacker BACK, 1
                move BACK, 1
                call _d077e1
                frame 3
                call _d077e7
                frame 3
                call _d077e1
                frame 3
                anim_draw_order FRONT
                move FORWARD, 20
                move DOWN, 21
                attacker_frame CHAR_FRAME::READY
                move_attacker BACK, 1
                move BACK, 1
                call _d077e7
                frame 0
                call _d077e1
                frame 0
                call _d077e7
                frame 0
                end_loop
        move BACK, 20
        move DOWN, 3
        attacker_frame CHAR_FRAME::WALKING_DOWN_3
        cycle_pal SPRITE_ANIM, 8, {2, 4}
        frame 1
        cycle_pal SPRITE_ANIM, 8, {2, 4}
        frame 1
        cycle_pal SPRITE_ANIM, 8, {2, 4}
        frame 1
        move BACK, 4
        move UP, 3
        attacker_frame CHAR_FRAME::READY + $30
:       cycle_pal SPRITE_ANIM, 8, {2, 4}
        frame 2
        move_vec_char :-, -4, 32
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

_d077d5:
        move_target FORWARD, 1
        cycle_pal SPRITE_ANIM, 8, {2, 4}
        return

_d077db:
        move_target BACK, 1
        cycle_pal SPRITE_ANIM, 8, {2, 4}
        return

_d077e1:
        move_target FORWARD, 1
        cycle_pal SPRITE_ANIM, 8, {2, 4}
        return

_d077e7:
        move_target BACK, 1
        cycle_pal SPRITE_ANIM, 8, {2, 4}
        return

; ------------------------------------------------------------------------------

; [ Animation Script $004B: AutoCrossbow (bg1) ]

_d077ed:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AUTOCROSSBOW_BG1
        anim_script BG1
        fixed_draw_order
        wait_scanline
        color_math {ADD, FIXED_CLR}
        jump_step :+
        call _d07067
:       sfx
        move_to_attacker
        attacker_frame CHAR_FRAME::READY
        move FORWARD, 11
        move DOWN, 4
        anim_loop_per_thread
                auto_frame 2, {0, 2}
                frame 0
                end_loop
        reset_frame_offset
        loop 17
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $004C: AutoCrossbow (sprite) ]

_d07819:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AUTOCROSSBOW_SPRITE
        anim_script SPRITE
        move_to_attacker
        jump_step :+
        loop 8
                blank_frame
                end_loop
        move FORWARD, 8
:       sfx
        calc_vec_rand
        vec_offset 16
:       frame 2
        move_vec :-, 8
        loop 9
                move_target FORWARD, 1
                move FORWARD, 1
                frame 3
                move_target BACK, 1
                move BACK, 1
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0052: Flash (sprite) ]

_d0783b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLASH_TOOL_SPRITE
        anim_script SPRITE
        fixed_draw_order
        jump_step :+
        call _d07019
:       sfx
        move_to_attacker
        attacker_frame CHAR_FRAME::READY
        move UP_FORWARD, 16
        loop 17
                frame 0
                end_loop
        mod_pal BG2, ADD, WHITE, 31
        mod_pal MONSTER, ADD, YELLOW, 0
        loop 17
                mod_pal MONSTER, ADD, YELLOW, +2
                frame 0
                end_loop
        loop 33
                mod_pal BG2, ADD, WHITE, -1
                mod_pal MONSTER, ADD, YELLOW, -2
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $004D: NoiseBlaster (sprite) ]

_d07868:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NOISEBLASTER_SPRITE
        anim_script SPRITE
        loop 33
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $004E: NoiseBlaster (extra) ]

_d07874:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NOISEBLASTER_EXTRA
        anim_script SPRITE
        fixed_draw_order
        jump_step :+
        call _d07019
:       attacker_frame CHAR_FRAME::READY
        move_to_attacker
        move FORWARD, 21
        move UP, 13
        sfx
        init_scroll_wave BG2, 0, 4, HORZ
        init_scroll_wave BG2, 2, 2, VERT
        update_scroll_wave BG2, {HORZ, VERT}
        frame 0, 4
        init_scroll_wave BG2, 2, 4, HORZ
        init_scroll_wave BG2, 4, 2, VERT
        loop 65
                update_scroll_wave BG2, {HORZ, VERT}
                frame 0
                end_loop
        init_scroll_wave BG2, 1, 4, HORZ
        init_scroll_wave BG2, 3, 2, VERT
        update_scroll_wave BG2, {HORZ, VERT}
        loop 4
                frame 0
                end_loop
        init_scroll_wave BG2, 0, 4, HORZ
        init_scroll_wave BG2, 2, 2, VERT
        update_scroll_wave BG2, {HORZ, VERT}
        frame 0, 2
        init_scroll_wave BG2, 1, 4, VERT
        update_scroll_wave BG2, {HORZ, VERT}
        frame 0, 2
        init_scroll_wave BG2, 0, 0, VERT
        update_scroll_wave BG2, {HORZ, VERT}
        frame 0
        attacker_frame CHAR_FRAME::NONE
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $004A: Bio Blaster (bg3) ]

_d078c8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIO_BLASTER_BG3
        anim_script BG3, 1, SCREEN
        fixed_draw_order
        init_circle {128, 75}, 4, {222, 255}, 127, 32
        move_circle_to_attacker
        jump_step :+
        move_circle {-24, 0}
        loop 8
                blank_frame
                end_loop
:       sfx
        move_circle {-40, -5}
        set_scroll_hdma BG3, 7
        init_scroll_wave BG3, 8, 1, HORZ
        init_scroll_wave BG3, 2, 2, VERT
        loop 56
                move_circle {-2, 0}
                zoom_circle +2
                update_circle
                update_scroll_wave BG3, {HORZ, VERT}
                frame 0
                end_loop
        mod_pal BG3, SUB, WHITE, 0
        loop 33
                mod_pal BG3, SUB, WHITE, +1
                zoom_circle +1
                update_circle
                update_scroll_wave BG3, {HORZ, VERT}
                frame 0
                end_loop
        reset_scroll_hdma BG3
        set_scroll_hdma BG3, 5
        normal_draw_order
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0049: Bio Blaster (sprite) ]

_d0790f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BIO_BLASTER_SPRITE
        anim_script SPRITE
        jump_step :+
        call _d07019
:       move_to_attacker
        attacker_frame CHAR_FRAME::READY
        move FORWARD, 12
        move UP, 12
        loop 65
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0051: Chain Saw 2 (sprite) ]

_d07926:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHAIN_SAW_ALT_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        jump_step :+
        call _d07019
:       calc_vec_char
        attacker_frame CHAR_FRAME::READY
        move_to_attacker
        move DOWN, 8
        move BACK, 2
        jump _d07945

; ------------------------------------------------------------------------------

; [ Animation Script $004F: Drill (sprite) ]

_d07939:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DRILL_SPRITE
        anim_script SPRITE, 1, FRONT_NEAR
        jump_step :+
        call _d07019
:       calc_vec_char
        attacker_frame CHAR_FRAME::READY
        move_to_attacker

_d07945:
        move FORWARD, 13
        move UP, 16
:       cycle_pal SPRITE_ANIM, 8, {2, 4}
        frame 0
        move_vec_char :-, 4, 32
        sfx
        loop 9
                move_attacker FORWARD, 1
                move FORWARD, 1
                move_target BACK, 1
                cycle_pal SPRITE_ANIM, 8, {2, 4}
                frame 0
                move_target FORWARD, 1
                cycle_pal SPRITE_ANIM, 8, {2, 4}
                frame 0
                end_loop
        loop 9
                move_attacker BACK, 1
                move BACK, 1
                move_target BACK, 1
                cycle_pal SPRITE_ANIM, 8, {2, 4}
                frame 0
                move_target FORWARD, 1
                cycle_pal SPRITE_ANIM, 8, {2, 4}
                frame 0
                end_loop
        hflip_anim
        attacker_frame CHAR_FRAME::READY + $30
        move FORWARD, 26
:       cycle_pal SPRITE_ANIM, 8, {2, 4}
        frame 0
        move_vec_char :-, -4, 32
        move BACK, 26
        attacker_frame CHAR_FRAME::READY
        hflip_anim
        loop 17
                cycle_pal SPRITE_ANIM, 8, {2, 4}
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0043: dog block ]

_d0799a:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DOG_BLOCK_SPRITE
        anim_script SPRITE
        match_target_dir
        loop 15
                blank_frame
                end_loop
        sfx
        move_block
        move FORWARD, 16
        move DOWN, 8
        loop 17
                move FORWARD, 1
                frame 24
                move BACK, 1
                frame 24
                end_loop
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0044: golem block ]

_d079b5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::GOLEM_BLOCK_SPRITE
        anim_script SPRITE
        match_target_dir
        loop 15
                blank_frame
                end_loop
        sfx
        move_block
        move FORWARD, 17
        move DOWN, 8
        loop 17
                move FORWARD, 1
                frame 25
                move BACK, 1
                frame 25
                end_loop
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0045: knife block ]

        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KNIFE_BLOCK_SPRITE
        anim_script SPRITE
        loop 15
                blank_frame
                end_loop
        sfx PARRY
        match_target_dir
        target_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move_if_block_flipped FORWARD, 2
        loop 17
                move_block
                move FORWARD, 12
                move DOWN, 24
                frame 26
                end_loop
        target_frame CHAR_FRAME::NONE
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0046: sword block ]

_d079ee:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SWORD_BLOCK_SPRITE
        anim_script SPRITE
        loop 15
                blank_frame
                end_loop
        sfx PARRY
        match_target_dir
        target_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move_if_block_flipped FORWARD, 2
        loop 17
                move_block
                move FORWARD, 12
                move DOWN, 24
                frame 27
                end_loop
        target_frame CHAR_FRAME::NONE
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0040: hands up block ]

_d07a0c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNARMED_BLOCK_SPRITE
        anim_script SPRITE
        loop 7
                blank_frame
                end_loop
        sfx
        target_frame CHAR_FRAME::JUMPING_FORWARD
        loop 17
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0047: cape block ]

_d07a21:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CAPE_BLOCK_SPRITE
        anim_script SPRITE
        loop 15
                blank_frame
                end_loop
        sfx MISS
        block_draw_order RIGHT_HAND
        match_target_dir
        move_block
        move DOWN, 14
        move FORWARD, 2
        target_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move_if_block_flipped BACK, 3
        flip_target_dir $40, 0
        loop 17
                frame 28
                end_loop
        block_draw_order FRONT
        move DOWN, 3
        move BACK, 2
        target_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        loop 17
                frame 29
                end_loop
        target_frame CHAR_FRAME::NONE
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0063:  ]

_d07a51:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::JUMP_UNUSED_SPRITE
        anim_script SPRITE
        match_target_dir
        loop 8
                blank_frame
                end_loop
        unknown_sfx
        target_frame CHAR_FRAME::WALKING_FORWARD_3, CHAR_FRAME::WALKING_FORWARD_1
        loop 33
                move_block
                move FORWARD, 8
                move DOWN, 16
                frame 30
                end_loop
        target_frame CHAR_FRAME::NONE
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0048: shield block ]

_d07a6d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHIELD_BLOCK_SPRITE
        anim_script SPRITE
        match_target_dir
        loop 8
                blank_frame
                end_loop
        target_frame CHAR_FRAME::WALKING_FORWARD_3, CHAR_FRAME::WALKING_FORWARD_1
        sfx SHIELD_BLOCK
        loop 33
                move_block
                move FORWARD, 8
                move DOWN, 16
                frame 30
                end_loop
        target_frame CHAR_FRAME::NONE
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0042:  ]

_d07a89:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_66
        anim_script SPRITE, 16, CENTER
        unknown_sfx
        match_target_dir
        move FORWARD, 8
        anim_sprite_pal 7
        frame 29
        frame 29
        unpause_layer {BG3, BG1}
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0098: (sprite) ]

_d07a97:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_152
        anim_script SPRITE, 3, BOTTOM
        move BACK, 9
        anim_priority 0
        frame 0
        frame 1
        frame 2
        frame 3
        frame 4
        block_draw_order BACK
        frame 5
        frame 6
        frame 7
        frame 8
        block_draw_order FRONT
        frame 9
        frame 10
        frame 11
        frame 12
        frame 13
        frame 14
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0002: Whiplash Hit (bg1) ]

_d07ab1:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STAB_HIT_1_BG1
        anim_script BG1
        jump_magitek _d07ab8, _d07abc

_d07ab8:
        loop 13
                blank_frame
                end_loop

_d07abc:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 6
                frame 0
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0003: Whiplash Hit (bg1) ]

_d07ad7:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STAB_HIT_2_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRIPLE_HORZ_HIT_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THIN_HORZ_HIT_BG1
        anim_script BG1
        jump_magitek _d07ade, _d07ae2

_d07ade:
        loop 13
                blank_frame
                end_loop

_d07ae2:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 7
                frame 0
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0004: Whiplash Hit (bg1) ]

_d07afd:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::STAB_HIT_3_BG1
        anim_script BG1
        jump_magitek _d07b04, _d07b08

_d07b04:
        loop 13
                blank_frame
                end_loop

_d07b08:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 5
                frame 0, 4
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0005: Horizontal Weapon Hit (bg1) ]

_d07b26:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HORZ_HIT_BG1
        anim_script BG1
        jump_magitek _d07b2d, _d07b31

_d07b2d:
        loop 13
                blank_frame
                end_loop

_d07b31:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 12
                frame 0
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0006: Katana Hit (bg1) ]

_d07b4c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KATANA_HIT_BG1
        anim_script BG1
        jump_magitek _d07b53, _d07b57

_d07b53:
        loop 13
                blank_frame
                end_loop

_d07b57:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 10
                frame 0
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0008: Unarmed Hit, Pummel, Revenge, MoogleRush (bg1) ]

_d07b72:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNARMED_HIT_BG1
        anim_script BG1
        jump_magitek _d07b79, _d07b7d

_d07b79:
        loop 13
                blank_frame
                end_loop

_d07b7d:
        loop 7
                blank_frame
                end_loop
        sfx
        target_frame CHAR_FRAME::HIT
        anim_loop 14
                frame 0, 2
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0009: Rod Hit (bg1) ]

_d07b98:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ROD_HIT_BG1
        anim_script BG1
        jump_magitek _d07b9f, _d07ba3

_d07b9f:
        loop 13
                blank_frame
                end_loop

_d07ba3:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 12
                frame 0, 2
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0001: Sword Hit (bg1) ]

_d07bbf:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THIN_DIAG_HIT_BG1
        anim_script BG1
        jump_magitek _d07bc6, _d07bca

_d07bc6:
        loop 13
                blank_frame
                end_loop

_d07bca:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 9
                frame 0
                end_anim_loop
        loop 9
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0000: Sword Hit (bg1) ]

_d07be5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THICK_DIAG_HIT_BG1
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLAW_HIT_BG1
        anim_script BG1
        jump_magitek _d07bec, _d07bf0

_d07bec:
        loop 13
                blank_frame
                end_loop

_d07bf0:
        loop 7
                blank_frame
                end_loop
        sfx DEFAULT, Y_POS
        target_frame CHAR_FRAME::HIT
        anim_loop 14
                frame 0
                end_anim_loop
        loop 5
                move_target FORWARD, 1
                blank_frame
                move_target BACK, 1
                blank_frame
                end_loop
        target_frame CHAR_FRAME::NONE
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $000A: Cards Hit (sprite) ]

_d07c0b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CARDS_HIT_SPRITE
        anim_script SPRITE
        jump_magitek _d07c12, _d07c16

_d07c12:
        loop 13
                blank_frame
                end_loop

_d07c16:
        loop 24
                blank_frame
                end_loop
        move_to_weapon_attacker
        move BACK, 16
        move UP, 24
        calc_vec_rand
        vec_offset 16
:       frame 4
        move_vec :-, 6
        sfx CARDS
        loop 17
                frame 5
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $000B: Darts Hit (sprite) ]

_d07c2d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DARTS_HIT_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_14
        anim_script SPRITE
        jump_magitek _d07c34, _d07c38

_d07c34:
        loop 15
                blank_frame
                end_loop

_d07c38:
        loop 8
                blank_frame
                end_loop
        move_to_weapon_attacker
        move BACK, 16
        move UP, 24
        calc_vec_rand
        vec_offset 16
:       frame 4
        move_vec :-, 6
        sfx CARDS
        loop 17
                frame 5
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $000C: Shuriken, Tack Star Hit (sprite) ]

_d07c4f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHURIKEN_HIT_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NINJA_STAR_HIT_SPRITE
        anim_script SPRITE
        jump_magitek _d07c56, _d07c5a

_d07c56:
        loop 17
                blank_frame
                end_loop

_d07c5a:
        loop 9
                blank_frame
                end_loop
        move_to_weapon_attacker
        move UP_BACK, 16
        calc_vec_rand
        vec_offset 16
:       frame 0
        move_vec :-, 6
        sfx THROW
        loop 17
                frame 4
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0035: Boomerang, Wing Edge Hit (sprite) ]

_d07c6f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOOMERANG_HIT_SPRITE
        anim_script SPRITE
        jump_magitek _d07c76, _d07c7a

_d07c76:
        loop 15
                blank_frame
                end_loop

_d07c7a:
        loop 8
                blank_frame
                end_loop
        move_to_weapon_attacker
        move UP, 9
        move BACK, 7
        move FORWARD, 17
        calc_vec_boomerang 0
:       auto_frame 2, {0, 6}
        frame 0
        move_vec_boomerang :-, 2
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0034: Full Moon, Rising Sun Hit (sprite) ]

_d07c8f:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FULL_MOON_HIT_SPRITE
        anim_script SPRITE
        jump_magitek _d07c96, _d07c9a

_d07c96:
        loop 15
                blank_frame
                end_loop

_d07c9a:
        loop 8
                blank_frame
                end_loop
        move_to_weapon_attacker
        move BACK, 16
        move UP, 24
        calc_vec_boomerang 4
:       frame 0
        move_vec_boomerang :-, 2
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $000F: Boomerang, Wing Edge (sprite) ]

_d07caa:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BOOMERANG_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP_BACK, 7
        call _d07103
        sfx
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        blank_frame
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0010: Cards (sprite) ]

_d07cbd:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CARDS_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DOOM_DARTS_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 23
        call _d07130
        loop 2
                attacker_frame CHAR_FRAME::JUMPING_DOWN, CHAR_FRAME::JUMPING_UP
                blank_frame 2
                attacker_frame CHAR_FRAME::JUMPING_FORWARD + $30, CHAR_FRAME::JUMPING_FORWARD
                blank_frame 2
                attacker_frame CHAR_FRAME::JUMPING_UP, CHAR_FRAME::JUMPING_DOWN
                blank_frame 2
                attacker_frame CHAR_FRAME::JUMPING_FORWARD, CHAR_FRAME::JUMPING_FORWARD + $30
                blank_frame 2
                end_loop
        sfx
        move FORWARD, 17
        move DOWN_FORWARD, 23
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 4
        frame 2, 4
        anim_draw_order LEFT_HAND
        frame 3, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $002F: Shuriken, Tack Star (sprite) ]

_d07cfa:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHURIKEN_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NINJA_STAR_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 23
        call _d07103
        sfx
        move FORWARD, 17
        move DOWN_FORWARD, 23
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 4
        frame 2, 4
        anim_draw_order LEFT_HAND
        frame 3, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0013: Darts (sprite) ]

_d07d20:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DARTS_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRUMP_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FULL_MOON_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLAW_ALT_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 23
        call _d07103
        sfx
        move FORWARD, 17
        move DOWN_FORWARD, 23
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 4
        frame 2, 4
        anim_draw_order LEFT_HAND
        frame 3, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0022: Imperial, Kodachi, Blossom - Right Hand (sprite) ]

_d07d46:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NINJA_SWORD_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move DOWN, 15
        move FORWARD, 7
        call _d07103
        sfx
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move UP, 15
        frame 1, 4
        frame 2, 4
        move UP, 8
        anim_draw_order FRONT
        frame 3, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0021: Imperial, Kodachi, Blossom - Left Hand (sprite) ]

_d07d6c:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::NINJA_SWORD_ALT_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP, 9
        move FORWARD, 7
        call _d07103
        sfx
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 4
        frame 2, 4
        move DOWN, 8
        anim_draw_order BACK
        frame 3, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script XX: most weapons ]

_d07d90:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CHOCO_BRUSH_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHORT_BRUSH_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::HAWK_EYE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_27
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHORT_KATANA_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::BONE_CLUB_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MAIN_GAUCHE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AIR_LANCET_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::KNIFE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SHORT_SWORD_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::THUNDERBLADE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::RUNE_BLADE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLAME_SABRE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::VALIANTKNIFE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FALCHION_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 23
        call _d07103
        sfx
        move FORWARD, 31
        move DOWN, 23
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 4
        move UP, 8
        anim_draw_order LEFT_HAND
        frame 2, 4
        frame 3, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0018: DaVinci Brsh (sprite) ]

_d07db8:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::DAVINCI_BRUSH_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 25
        call _d07103
        sfx
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 32
        frame 1, 2
        frame 2, 2
        move FORWARD, 23
        move DOWN, 11
        anim_draw_order BACK
        move_if_flipped FORWARD, 2
        loop 17
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0019: Flail, Morning Star (sprite) ]

_d07dde:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::FLAIL_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 23
        call _d07103
        sfx
        move FORWARD, 32
        frame 1, 2
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 2, 2
        move FORWARD, 19
        move DOWN, 10
        anim_draw_order BACK
        move_if_flipped FORWARD, 2
        loop 17
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0038: Atma Weapon 3 (sprite) ]

_d07e04:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATMA_WEAPON_3_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP_BACK, 22
        move BACK, 2
        move_if_flipped FORWARD, 2
        anim_priority 0
        call _d07103
        sfx
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 2
        move DOWN, 1
        frame 1
        move FORWARD, 1
        move DOWN, 2
        frame 2
        move FORWARD, 6
        move DOWN, 1
        frame 3
        move FORWARD, 32
        move FORWARD, 8
        move DOWN, 2
        frame 4
        move DOWN, 1
        frame 5
        move DOWN, 1
        loop 17
                frame 6
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0037: Atma Weapon 2 (sprite) ]

_d07e3b:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATMA_WEAPON_2_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP_BACK, 22
        move BACK, 2
        anim_priority 0
        call _d07103
        sfx
        move UP, 17
        move FORWARD, 19
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        frame 2, 2
        move UP, 5
        move DOWN_FORWARD, 31
        move_if_flipped FORWARD, 2
        loop 17
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0036: Atma Weapon 1 (sprite) ]

_d07e63:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATMA_WEAPON_1_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 23
        anim_priority 0
        call _d07103
        sfx
        move FORWARD, 31
        move DOWN, 23
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 4
        move UP, 8
        anim_draw_order LEFT_HAND
        frame 2, 4
        frame 3, 4
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $005C: Illumina (sprite) ]

_d07e8d:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ILLUMINA_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP_BACK, 22
        move DOWN, 8
        move BACK, 4
        call _d07103
        sfx
        move UP, 17
        move FORWARD, 22
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        frame 2, 2
        move DOWN_FORWARD, 29
        move_if_flipped FORWARD, 2
        loop 17
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $001D: Murasame, Aura, Strato, Sky Render (sprite) ]

_d07eb3:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::LONG_KATANA_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SCIMITAR_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move UP_BACK, 22
        call _d07103
        sfx
        move UP, 17
        move FORWARD, 18
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        frame 2, 2
        move DOWN_FORWARD, 29
        move_if_flipped FORWARD, 2
        loop 17
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $001E: Drainer, Excalibur, Ragnarok (sprite) ]

_d07ed5:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::MYSTIC_SWORD_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SOUL_SABRE_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 5
        move UP_BACK, 19
        call _d07103
        sfx
        move UP_FORWARD, 19
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        frame 1, 2
        frame 2, 2
        move DOWN, 27
        move FORWARD, 30
        move_if_flipped FORWARD, 2
        loop 17
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0024: Unarmed Attack (sprite) ]

_d07ef9:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::UNARMED_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLAW_PUNCH_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 9
        move DOWN, 12
        move_if_flipped FORWARD, 2
        call _d07103
        sfx
        loop 9
                move BACK, 2
                frame 0
                move FORWARD, 2
                frame 0
                end_loop
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0025:  ]

_d07f18:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ATTACK_ANIM_SCRIPT_37
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 10
        move DOWN, 13
        move_if_flipped FORWARD, 2
        call _d07103
        sfx
        call _d07f31
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        end_anim_script

; ------------------------------------------------------------------------------

; [  ]

_d07f31:
        loop 5
                move BACK, 1
                move_target FORWARD, 3
                frame 0
                move FORWARD, 1
                move_target BACK, 3
                frame 0
                move UP, 3
                move BACK, 1
                move_target FORWARD, 3
                frame 1
                move FORWARD, 1
                move_target FORWARD, 3
                frame 1
                move BACK, 1
                move_target BACK, 3
                frame 2
                move FORWARD, 1
                move_target BACK, 3
                frame 2
                move DOWN, 3
                end_loop
        return

; ------------------------------------------------------------------------------

; [ Animation Script $002D: Mithril Pike, Stout Spear, Gold Lance (sprite) ]

_d07f57:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::SPEAR_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::TRIDENT_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::AURA_LANCE_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::IMP_HALBERD_SPRITE
        anim_script SPRITE
        anim_draw_order BACK
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 27
        move UP, 7
        call _d07130
        sfx
        frame 0, 2
        loop 17
                frame 1
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0032: Mithril Claw, Fire Knuckle, Dragon Claw (sprite) ]

_d07f6e:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLAW_LEFT_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::CLAW_RIGHT_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::FIGHTING_2, CHAR_FRAME::FIGHTING_3
        move BACK, 2
        move UP_BACK, 21
        call _d07103
        sfx
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move_if_flipped DOWN_FORWARD, 2
        move DOWN_FORWARD, 17
        move FORWARD, 22
        frame 1, 4
        frame 2, 4
        move FORWARD, 9
        move UP, 3
        loop 17
                frame 3
                end_loop
        end_anim_script

; ------------------------------------------------------------------------------

; [ Animation Script $0028: Heal Rod, Mithril Rod, Fire Rod, Ice Rod, Thunder Rod, Poison Rod, Pearl Rod, Gravity Rod, Magus Rod (sprite) ]

_d07f98:
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::ROD_SPRITE
        array_label ATTACK_ANIM_SCRIPT, ATTACK_ANIM_SCRIPT::PUNISHER_SPRITE
        anim_script SPRITE
        anim_draw_order RIGHT_HAND
        attacker_frame CHAR_FRAME::WALKING_FORWARD_1, CHAR_FRAME::WALKING_FORWARD_3
        move FORWARD, 19
        move UP, 11
        call _d07130
        sfx
        anim_speed 5
        loop 3
                frame 0
                frame 1
                end_loop
        frame 2
        frame 3
        end_anim_script

; ------------------------------------------------------------------------------
