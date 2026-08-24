.ifndef ANIM_SCRIPT_INC
ANIM_SCRIPT_INC = 1

.include "src/common/script_mode.inc"

; ------------------------------------------------------------------------------

.mac _cmd_impl op
        .byte op
.endmac

.mac _a_cmd_impl cmd
        _assert_script_mode BATTLE_ANIM
        _cmd_impl cmd
.endmac

.mac _b_cmd_impl cmd
        _assert_script_mode BATTLE_EVENT
        _cmd_impl cmd
.endmac

.mac _cmd_byte op, b
        .byte op, b
.endmac

.mac _a_cmd_byte op, b
        _assert_script_mode BATTLE_ANIM
        _cmd_byte op, b
.endmac

.mac _b_cmd_byte op, b
        _assert_script_mode BATTLE_EVENT
        _cmd_byte op, b
.endmac

.mac _cmd_2byte op, b1, b2
        .byte op, b1, b2
.endmac

.mac _a_cmd_2byte op, b1, b2
        _assert_script_mode BATTLE_ANIM
        _cmd_2byte op, b1, b2
.endmac

.mac _b_cmd_2byte op, b1, b2
        _assert_script_mode BATTLE_EVENT
        _cmd_2byte op, b1, b2
.endmac

.mac _a_cmd_3byte op, b1, b2, b3
        _assert_script_mode BATTLE_ANIM
        .byte op, b1, b2, b3
.endmac

.mac _a_cmd_word op, w
        _assert_script_mode BATTLE_ANIM
        .byte op
        .word w
.endmac

.mac _a_cmd_addr op, addr
        _assert_script_mode BATTLE_ANIM
        .byte op
        .addr addr
.endmac

.mac _2_bytes b1, b2
        .byte b1, b2
.endmac

.mac _2_bytes_signed b1, b2
        .lobytes b1, b2
.endmac

; ------------------------------------------------------------------------------

.mac battle_event
        set_script_mode BATTLE_EVENT
.endmac

; display message in bottom window (dialogue window) or top window (message window)
.enum BATTLE_DLG_WINDOW_POS
        BOTTOM = BATTLE_EVENT_CMD::BATTLE_DLG  ; default
        TOP = BATTLE_EVENT_CMD::BATTLE_MSG
.endenum

.mac battle_dlg val, window_pos
        .ifblank window_pos
                _b_cmd_byte BATTLE_DLG_WINDOW_POS::BOTTOM, BATTLE_DLG::val
        .else
                _b_cmd_byte BATTLE_DLG_WINDOW_POS::window_pos, BATTLE_DLG::val
        .endif
.endmac

.enum EVENT_ANIM_SLOT
        SLOT_1
        SLOT_2
        SLOT_3
        SLOT_4
        SLOT_5
        SLOT_6
.endenum

.mac char_event_anim slot, addr, char_id
        _b_cmd_impl BATTLE_EVENT_CMD::CHAR_1_ANIM + EVENT_ANIM_SLOT::slot
        .ifblank char_id
                .byte 0
        .else
                .byte CHAR_PROP::char_id
        .endif
        .addr addr
.endmac

.mac monster_event_anim slot, addr, char_id
        _b_cmd_impl BATTLE_EVENT_CMD::MONSTER_1_ANIM + EVENT_ANIM_SLOT::slot
        .ifblank char_id
                .byte 0
        .else
                .byte CHAR_PROP::char_id
        .endif
        .addr addr
.endmac

.enum ATTACK_EVENT_ANIM_TARGETS
        CHAR_1 = $01
        CHAR_2 = $02
        CHAR_3 = $04
        CHAR_4 = $08
        MONSTER_1 = $81
        MONSTER_2 = $82
        MONSTER_3 = $84
        MONSTER_4 = $88
        MONSTER_5 = $90
        MONSTER_6 = $a0
        ALL_MONSTERS = $ff
.endenum

.mac attack_event_anim anim_id, attacker_id, anim_targets
        _b_cmd_byte BATTLE_EVENT_CMD::ATTACK_ANIM, ATTACK_EVENT_ANIM::anim_id
        .ifnblank attacker_id
                .byte CHAR_PROP::attacker_id
        .else
                .byte 0
        .endif
        .ifnblank anim_targets
                make_bitmask .byte, 0, ATTACK_EVENT_ANIM_TARGETS, anim_targets
        .else
                .byte ATTACK_EVENT_ANIM_TARGETS::CHAR_1
        .endif
.endmac

.mac reset_event_anim
        _b_cmd_impl BATTLE_EVENT_CMD::RESET_ANIM
.endmac

.mac exec_event_anim
        _b_cmd_impl BATTLE_EVENT_CMD::EXEC_ANIM
.endmac

.mac close_dlg_window
        _b_cmd_impl BATTLE_EVENT_CMD::CLOSE_DLG
.endmac

.mac open_dlg_window
        _b_cmd_impl BATTLE_EVENT_CMD::OPEN_DLG
.endmac

.mac all_chars_event_anim
        _b_cmd_impl BATTLE_EVENT_CMD::ALL_CHARS_ANIM
.endmac

.mac add_char_target val
        _b_cmd_byte BATTLE_EVENT_CMD::ADD_CHAR_TARGET, CHAR_PROP::val
.endmac

.mac remove_char_target val
        _b_cmd_byte BATTLE_EVENT_CMD::ADD_CHAR_TARGET, CHAR_PROP::val | $80
.endmac

.mac show_char_menu val
        _b_cmd_byte BATTLE_EVENT_CMD::SHOW_CHAR_MENU, CHAR_PROP::val
.endmac

.mac hide_char_menu val
        _b_cmd_byte BATTLE_EVENT_CMD::SHOW_CHAR_MENU, CHAR_PROP::val | $80
.endmac

.mac end_battle_event
        _b_cmd_impl BATTLE_EVENT_CMD::TERMINATE
.endmac

; ------------------------------------------------------------------------------

.enum ANIM_ALIGN
        BOTTOM                          = $00 ; align with bottom of attacker/target
        CENTER                          = $20 ; align with center of attacker/target
        TOP                             = $40 ; align with top of attacker/target
        UNUSED                          = $60 ; align with center of attacker/target (unused)
        FRONT_NEAR                      = $80 ; align with front of attacker/target (near, 16/24 pixels away)
        SCREEN                          = $a0 ; align with center of screen
        FRONT_FAR                       = $c0 ; align with front of attacker/target (far, 32/24 pixels away)
        CHAR                            = $e0 ; align with character
.endenum

.enum ANIM_LAYER
        SPRITE
        BG1
        BG3
.endenum

.define set_anim_layer(layer) ::anim_layer .set ANIM_LAYER::layer
.define is_anim_layer(layer) ::anim_layer = ANIM_LAYER::layer

.mac _assert_anim_layer layer
        .assert ::anim_layer = ANIM_LAYER::layer, error, "Invalid animation layer"
.endmac

.mac set_blank_frame val
        _blank_frame .set val
.endmac

.mac anim_script layer, speed, align
        set_script_mode BATTLE_ANIM
        set_anim_layer layer
        .if is_anim_layer SPRITE
                set_blank_frame 31  ; blank frame (sprite)
        .elseif is_anim_layer BG1
                set_blank_frame 15  ; blank frame (bg1)
        .else
                set_blank_frame 9  ; blank frame (bg3)
        .endif
        .ifnblank speed
                .assert speed > 0 .and speed <= 16, error, "Invalid animation speed"
                .byte (speed - 1) << 4
        .else
                .byte 0
        .endif
        .ifnblank align
                .byte ANIM_ALIGN::align
        .else
                .byte ANIM_ALIGN::CENTER
        .endif
.endmac

.mac frame val, count
        .ifblank val
                blank_frame count
        .else
                .ifblank count
                        _a_cmd_impl val
                .else
                        .repeat count
                                _a_cmd_impl val
                        .endrep
                .endif
        .endif
.endmac

.mac blank_frame count
        .ifblank count
                _a_cmd_impl _blank_frame
        .else
                .repeat count
                        _a_cmd_impl _blank_frame
                .endrep
        .endif
.endmac

; set thread target position to attacking character position
; used for quadra slam/slice to return cyan to his original position
.mac set_target_char_return
        _a_cmd_byte $80, $00
.endmac

; clear attacking character and thread x/y offset
.mac clear_pos_offset
        _a_cmd_byte $80, $01
.endmac

.mac save_attacker_dir
        _a_cmd_byte $80, $02
.endmac

.mac restore_attacker_dir
        _a_cmd_byte $80, $03
.endmac

.mac rand_vec
        _a_cmd_byte $80, $04
.endmac

.mac init_bum_rush_pos
        _a_cmd_byte $80, $05
.endmac

.mac reset_tornado_pos
        _a_cmd_byte $80, $06
.endmac

.mac move_tornado_to_anim
        _a_cmd_byte $80, $07
.endmac

.mac move_anim_to_vec
        _a_cmd_byte $80, $08
.endmac

.mac update_priority_tornado
        _a_cmd_byte $80, $09
.endmac

; update white/effect magic pre-animation
.mac update_white_pre_anim
        _a_cmd_byte $80, $0a
.endmac

; update esper pre-animation balls position
.mac update_genju_pre_anim
        _a_cmd_byte $80, $0b
.endmac

.mac move_to_first_thread
        _a_cmd_byte $80, $0c
.endmac

.mac init_monster_jump_pos
        _a_cmd_byte $80, $0e
.endmac

; also used for cold dust and something else
.mac calc_vec_grav_bomb
        _a_cmd_byte $80, $0f
.endmac

.mac move_to_target
        _a_cmd_byte $80, $10
.endmac

.mac rand_angle
        _a_cmd_byte $80, $11
.endmac

.mac init_polar
        _a_cmd_byte $80, $12
.endmac

.mac target_imp
        _a_cmd_byte $80, $13
.endmac

.mac target_vanish
        _a_cmd_byte $80, $14
.endmac

.mac reset_ellipse
        _a_cmd_byte $80, $16
.endmac

; target and objects behind target in draw order are shown behind high priority bg layers
.mac bg_target_draw_order
        _a_cmd_byte $80, $17
.endmac

.mac load_sketch_pal
        _a_cmd_byte $80, $18
.endmac

.mac update_sketch_pos
        _a_cmd_byte $80, $19
.endmac

.mac validate_monster_entry
        _a_cmd_2byte $80, $1a, 1
.endmac

; it often uses hide_target_monsters instead, not sure why
.mac invalidate_monster_entry
        _a_cmd_2byte $80, $1a, 0
.endmac

; used when kefka turns an esper into magicite
.mac ignore_char_vec_offset
        _a_cmd_byte $80, $1b
.endmac

.mac dec_brightness
        _a_cmd_byte $80, $1c
.endmac

; orbit around thread position with radius 32 (turning into magicite)
.mac update_orbit_32
        _a_cmd_byte $80, $1d
.endmac

.mac update_bg3_scroll_holy
        _a_cmd_byte $80, $1e
.endmac

.mac init_bg3_hscroll_holy
        _a_cmd_byte $80, $1f
.endmac

.mac init_bg3_vscroll_holy
        _a_cmd_byte $80, $20
.endmac

; update animation sprite priority based on ellipse angle (front or back)
.mac update_ellipse_priority
        _a_cmd_byte $80, $21
.endmac

.mac init_white_wind_scroll
        _a_cmd_byte $80, $22
.endmac

.mac update_white_wind_scroll
        _a_cmd_byte $80, $23
.endmac

.mac reset_scroll_hdma layer
        .if SET_SCROLL_HDMA_LAYER::layer = SET_SCROLL_HDMA_LAYER::BG1
                _a_cmd_byte $80, $25
        .elseif SET_SCROLL_HDMA_LAYER::layer = SET_SCROLL_HDMA_LAYER::BG3
                _a_cmd_byte $80, $24
        .else
                .error "Invalid layer"
        .endif
.endmac

.mac enable_char_pal_update
        _a_cmd_2byte $80, $26, 0
.endmac

.mac disable_char_pal_update
        _a_cmd_2byte $80, $26, 1
.endmac

; show all characters (after esper attack)
.mac show_chars
        _a_cmd_2byte $80, $27, 0
.endmac

; hide all characters (before esper attack)
.mac hide_chars
        _a_cmd_2byte $80, $27, 1
.endmac

; set layer priority for all character sprites
.mac char_priority val
        _a_cmd_2byte $80, $28, val << 4
.endmac

.mac show_char_indicator
        _a_cmd_2byte $80, $29, 0
.endmac

.mac hide_char_indicator
        _a_cmd_2byte $80, $29, 1
.endmac

.mac load_bg1_pal val
        _a_cmd_2byte $80, $2b, val
.endmac

.mac load_bg3_pal val
        _a_cmd_2byte $80, $2c, val
.endmac

.mac jump_battle_type addr_normal, addr_back, addr_pincer
        _a_cmd_byte $80, $2d
        .addr addr_normal, addr_back, addr_pincer
.endmac

.mac move_xy xy_pos
        _a_cmd_byte $80, $2e
        _2_bytes xy_pos
.endmac

.mac update_vec_wave_wide val
        _a_cmd_2byte $80, $31, val
.endmac

; jump based on facing direction
.mac jump_dir addr_left, addr_right
        _a_cmd_byte $80, $32
        .addr addr_left, addr_right
.endmac

.enum MAINSCREEN_LAYERS
        BG1 = $01
        BG2 = $02
        BG3 = $04
        BG4 = $08
        SPRITE = $10
.endenum

.mac update_rainbow_gradient val
        _a_cmd_2byte $80, $33, <val
.endmac

; copy monster palettes to sprite palettes 5-7 (for color math)
.mac copy_monster_pal_color_math
        _a_cmd_byte $80, $34
.endmac

; adjust monster sprite data to use palettes 5-7
.mac enable_monster_color_math
        _a_cmd_byte $80, $35
.endmac

; adjust monster sprite data to use palettes 5-7
.mac disable_monster_color_math
        _a_cmd_byte $80, $36
.endmac

.mac reset_gradient
        _a_cmd_byte $80, $37
.endmac

.mac hi_priority_bg3
        _a_cmd_byte $80, $38
.endmac

.mac update_blue_gradient val
        _a_cmd_2byte $80, $39, <val
.endmac

.mac init_blue_gradient val
        _a_cmd_2byte $80, $3a, val
.endmac

.mac anim_target_pal
        _a_cmd_byte $80, $3b
.endmac

.mac restore_target_pal
        _a_cmd_byte $80, $3c
.endmac

.mac calc_vec_spiral
        _a_cmd_byte $80, $3d
.endmac

.mac mainscreen_layers val
        _a_cmd_byte $80, $3e
        make_bitmask .byte, 0, MAINSCREEN_LAYERS, val
.endmac

; wait for bg1 thread to reach target (used by sonic dive)
.mac wait_bg1_reach_target
        _a_cmd_byte $80, $3f
.endmac

.mac screen_mode val
        _a_cmd_2byte $80, $40, val
.endmac

.mac mode7_move pos_xy, zoom_xy
        _a_cmd_byte $80, $41
        .ifnblank zoom_xy
                _2_bytes_signed zoom_xy
        .else
                .byte 0, 0
        .endif
        _2_bytes_signed pos_xy
.endmac

.mac mode7_zoom zoom_xy
        _a_cmd_byte $80, $41
        _2_bytes_signed zoom_xy
        .byte 0, 0
.endmac

.enum MODE7_FLIP
        NONE = 0
        HORZ = $01
        VERT = $02
.endenum

.mac mode7_flip val
        _a_cmd_byte $80, $42
        make_bitmask .byte, 0, MODE7_FLIP, val
.endmac

; entrance effect for fenrir (moon song)
.mac init_moon_song_effect
        _a_cmd_2byte $80, $43, 0
.endmac

.mac update_moon_song_effect
        _a_cmd_2byte $80, $43, 1
.endmac

.mac move_to_prev_thread
        _a_cmd_byte $80, $44
.endmac

.mac bg1_window val
        _a_cmd_byte $80, $45
        .if val = 1
                .byte $33
        .elseif val = 2
                .byte $3c
        .else
                .error "Invalid BG1 window"
        .endif
.endmac

.mac bg1_tilemap_location val
        .assert val & $00ff = 0, error, "Invalid BG1 tilemap location"
        _a_cmd_2byte $80, $46, val >> 8
.endmac

.mac bg1_gfx_location val
        .assert val & $0fff = 0, error, "Invalid BG1 gfx location"
        _a_cmd_2byte $80, $47, $10 | val >> 12
.endmac

.mac invisible_monster
        _a_cmd_byte $80, $48
.endmac

.mac rand_sprite_pal
        _a_cmd_byte $80, $49
.endmac

.mac disable_step_back
        _a_cmd_byte $80, $4a
.endmac

.mac update_megazerk_gradient val
        _a_cmd_2byte $80, $4b, <val
.endmac

.mac move_triangle_here
        _a_cmd_byte $80, $4c
.endmac

.mac calc_vec_triangle
        _a_cmd_byte $80, $4d
.endmac

.mac reset_frame_offset
        _a_cmd_byte $80, $4e
.endmac

.mac move_to_attacker_char
        _a_cmd_byte $80, $4f
.endmac

.mac rand_bg3_hscroll val
        _a_cmd_2byte $80, $50, val
.endmac

.mac disable_vertical_image
        _a_cmd_2byte $80, $51, 0
.endmac

.mac enable_vertical_image
        _a_cmd_2byte $80, $51, 1
.endmac

; orbit around thread position with radius 16 (stone)
.mac update_orbit_16
        _a_cmd_byte $80, $52
.endmac

; causes the target to move to the other row
; similar to row command, used by r.polarity
.mac move_char_row
        _a_cmd_byte $80, $53
.endmac

; toggle a character's row (instantly)
; used by r.polarity
.mac toggle_char_row
        _a_cmd_byte $80, $54
.endmac

.mac init_quasar_scroll
        _a_cmd_2byte $80, $55, 0
.endmac

.mac update_quasar_scroll
        _a_cmd_2byte $80, $55, 1
.endmac

.mac bg1_scroll_goner
        _a_cmd_byte $80, $56
.endmac

.mac bg3_window val
        _a_cmd_byte $80, $57
        .if val = 1
                .byte $c3
        .elseif val = 2
                .byte $cc
        .else
                .error "Invalid BG1 window"
        .endif
.endmac

.mac circle_shape val
        _a_cmd_2byte $80, $58, CIRCLE_SHAPE::val
.endmac

.mac window2_size val
        _a_cmd_2byte $80, $59, val
.endmac

.mac update_mind_blast_scroll
        _a_cmd_byte $80, $5a
.endmac

.mac init_mind_blast_scroll
        _a_cmd_byte $80, $5b
.endmac

.mac reset_mind_blast_scroll
        _a_cmd_byte $80, $5c
.endmac

.mac update_vec_wave
        _a_cmd_byte $80, $5d
.endmac

; used by overcast (zoom and rotate every frame)
.mac mode7_rotate
        _a_cmd_byte $80, $5e
.endmac

.mac update_wide_blue_gradient val
        _a_cmd_2byte $80, $5f, <val
.endmac

.mac toggle_attacker_status val
        _a_cmd_byte $80, $60
        .dword 1 << STATUS_ID::val
.endmac

.mac update_eyedrop height, speed, angle
        _a_cmd_byte $80, $61
        .byte height, speed, angle
.endmac

.mac update_evil_toot height, speed, angle
        _a_cmd_byte $80, $62
        .byte height, speed, angle
.endmac

.mac update_vec_wave_narrow val
        _a_cmd_2byte $80, $63, val
.endmac

.mac use_8x8_bg1_tiles
        _a_cmd_byte $80, $64
.endmac

.mac update_rainbow_pal
        _a_cmd_byte $80, $65
.endmac

.mac reset_pos_offset
        _a_cmd_byte $80, $66
.endmac

.mac load_crusader_pal
        _a_cmd_byte $80, $67
.endmac

.mac load_crusader_gfx
        _a_cmd_byte $80, $68
.endmac

; attacker and objects behind attacker in draw order are shown behind high priority bg layers
.mac bg_attacker_draw_order
        _a_cmd_byte $80, $69
.endmac

.mac realign_to_target_bottom
        _a_cmd_byte $80, $6a
.endmac

.mac realign_to_target_center
        _a_cmd_byte $80, $6b
.endmac

.mac clear_bg_frames
        _a_cmd_byte $80, $6c
.endmac

.mac disable_menu
        _a_cmd_byte $80, $6d
.endmac

.mac update_window_hdma
        _a_cmd_byte $80, $6f
.endmac

.mac align_bg3_vscroll
        _a_cmd_byte $80, $70
.endmac

.mac restore_char_pal
        _a_cmd_byte $80, $71
.endmac

.mac jump_hit addr
        _a_cmd_2byte $80, $72, addr - * - 1
.endmac

.mac dice_roll val
        _a_cmd_2byte $80, $73, val
.endmac

; update super ball graphic and position
.mac update_super_ball height, speed, angle
        _a_cmd_byte $80, $75
        .byte height, speed, angle
.endmac

.mac update_seize_stretch val
        _a_cmd_2byte $80, $76, <val
.endmac

.mac save_seize_char_pos
        _a_cmd_byte $80, $77
.endmac

.mac restore_seize_char_pos
        _a_cmd_byte $80, $78
.endmac

.mac chars_run_left
        _a_cmd_byte $80, $79
.endmac

.mac chars_run_right
        _a_cmd_byte $80, $7a
.endmac

.mac flip_chars
        _a_cmd_byte $80, $7b
.endmac

.mac swap_attacker_and_target
        _a_cmd_byte $80, $7c
.endmac

.mac jump_dragon_horn addr
        _a_cmd_2byte $80, $7d, addr - * - 1
.endmac

; hide all monsters (boss death)
.mac hide_monsters
        _a_cmd_byte $80, $7f
.endmac

; v-flip target character (suplex)
.mac vflip_target_char
        _a_cmd_byte $80, $7e
.endmac

.mac monster_x_offset val
        _a_cmd_2byte $80, $82, <val
.endmac

.mac save_chadarnook_pos
        _a_cmd_byte $80, $83
.endmac

.mac restore_chadarnook_pos
        _a_cmd_byte $80, $84
.endmac

.mac load_chadarnook_bg_pal val
        _a_cmd_2byte $80, $85, val
.endmac

.mac move_block
        _a_cmd_byte $80, $88
.endmac

.mac disable_kefka_head_shake
        _a_cmd_2byte $80, $89, 0
.endmac

.mac enable_kefka_head_shake
        _a_cmd_2byte $80, $89, 1
.endmac

.mac monster_target_priority_zero
        _a_cmd_byte $80, $8a
.endmac

.mac unknown_sfx
        _a_cmd_byte $80, $8b
.endmac

; set attacking character's animated action (use status animation if zero)
.mac attacker_action left, right
        .ifblank right
                _a_cmd_2byte $81, left, left
        .else
                _a_cmd_2byte $81, left, right
        .endif
.endmac

.mac target_action left, right
        .ifblank right
                _a_cmd_2byte $82, left, left
        .else
                _a_cmd_2byte $82, left, right
        .endif
.endmac

.enum ANIM_MOVE_DIR
        DOWN_FORWARD = $00
        DOWN = $20
        DOWN_BACK = $40
        FORWARD = $60
        BACK = $80
        UP_FORWARD = $a0
        UP = $c0
        UP_BACK = $e0
.endenum

.mac _move op, direction, distance
        .if distance > 32
                _a_cmd_byte op, ANIM_MOVE_DIR::direction | 31
                _move op, direction, distance - 32
        .else
                _a_cmd_byte op, ANIM_MOVE_DIR::direction | (distance - 1)
        .endif
.endmac

.mac move direction, distance
        _move $83, direction, distance
.endmac

.mac anim_speed val
        _a_cmd_byte $84, val - 1
.endmac

.mac move_to_attacker
        _a_cmd_impl $85
.endmac

.mac move_attacker direction, distance
        _move $86, direction, distance
.endmac

.mac move_target direction, distance
        _move $87, direction, distance
.endmac

.mac fight_anim val
        _a_cmd_byte $88, val
.endmac

.mac loop count
        _a_cmd_byte $89, count - 1
.endmac

.mac end_loop
        _a_cmd_impl $8a
.endmac

.mac anim_loop count
        _a_cmd_byte $8b, count - 1
.endmac

.mac end_anim_loop
        _a_cmd_impl $8c
.endmac

.enum ANIM_DRAW_ORDER
        FRONT = $40
        BACK = $80
        RIGHT_HAND = $01
        LEFT_HAND = $00
.endenum

.mac anim_draw_order val
        _a_cmd_byte $8e, ANIM_DRAW_ORDER::val
.endmac

.mac move_if_flipped direction, distance
        _move $8f, direction, distance
.endmac

; set layer priority for animation sprites
.mac anim_priority val
        _a_cmd_byte $90, val << 4
.endmac


.mac move_to_weapon_attacker
        _a_cmd_impl $91
.endmac

.mac move_vec addr, speed
        _a_cmd_byte $92, speed
        .byte * - addr
.endmac

.mac vec_offset val
        _a_cmd_byte $93, val
.endmac

.mac calc_vec_rand
        _a_cmd_impl $94
.endmac

.mac calc_vec
        _a_cmd_impl $95
.endmac

.mac move_vec_boomerang addr, val
        _a_cmd_byte $96, val
        .byte * - addr
.endmac

.mac calc_vec_boomerang val
        _a_cmd_byte $97, val
.endmac

.mac _auto_frame_range begin, end
        .byte (begin << 4) | end
.endmac

; automatically increment animation frame
.mac auto_frame speed, range
        _a_cmd_byte $98, speed
        _auto_frame_range range
.endmac

; set palette index for sprite animation
.mac anim_sprite_pal val
        _a_cmd_byte $99, val << 1
.endmac

.mac match_target_dir
        _a_cmd_impl $9a
.endmac

.mac block_draw_order val
        _a_cmd_byte $9b, ANIM_DRAW_ORDER::val
.endmac

.mac move_if_block_flipped direction, distance
        _move $9c, direction, distance
.endmac

.mac flip_target_dir left, right
        _a_cmd_2byte $9e, left, right
.endmac

.mac anim_loop_per_thread
        _a_cmd_byte $9f, 0
.endmac

.mac move_vec_jump addr, speed
        .if speed >= 0
                _a_cmd_byte $a0, speed
        .else
                _a_cmd_byte $a1, -speed
        .endif
        .byte * - addr
.endmac

.mac hflip_anim
        _a_cmd_byte $a2, $40
.endmac

.enum BATTLE_CGRAM_PAL
        BG3_ANIM = 1
        BG1_ANIM = 3
        BG1_ANIM_EXTRA = 4
        MONSTER_1 = 8
        MONSTER_2 = 9
        MONSTER_3 = 10
        SPRITE_ANIM = 11
.endenum

; color range for cycling palette (inclusive)
.mac _cycle_pal_range range_begin, range_end
        .byte (range_end - range_begin + 1) | (range_begin << 4)
.endmac

.mac cycle_pal pal_id, rate, color_range
        .if rate >= 0
                _a_cmd_impl $a3
                _cycle_pal_range color_range
                .byte rate | BATTLE_CGRAM_PAL::pal_id << 4
        .else
                _a_cmd_impl $a4
                _cycle_pal_range color_range
                .byte -rate | BATTLE_CGRAM_PAL::pal_id << 4
        .endif
.endmac

.mac init_circle init_xy, init_size, final_xy, final_size, speed
        _a_cmd_impl $a5
        _2_bytes init_xy
        .byte init_size
        _2_bytes final_xy
        .byte final_size
        .byte speed
.endmac

.mac move_circle xy, size
        .ifnblank size
                _a_cmd_impl $a6
                _2_bytes_signed xy
                .byte <size
        .else
                _a_cmd_impl $a9
                _2_bytes_signed xy
        .endif
.endmac

.mac zoom_circle size
        _a_cmd_impl $a6
        .byte 0, 0, <size
.endmac

.mac update_circle
        _a_cmd_impl $a7
.endmac

.mac move_circle_to_attacker
        _a_cmd_impl $a8
.endmac

.enum INIT_SCROLL_WAVE_LAYER
        BG1 = $80
        BG2 = $40
        BG3 = $20
.endenum

.enum INIT_SCROLL_WAVE_DIR
        VERT = $80
        HORZ = $40
.endenum

.mac init_scroll_wave layer, amplitude, frequency, direction
        _a_cmd_impl $ac
        make_bitmask .byte, frequency, INIT_SCROLL_WAVE_LAYER, layer
        make_bitmask .byte, amplitude, INIT_SCROLL_WAVE_DIR, direction
.endmac

.enum SET_SCROLL_HDMA_LAYER
        BG1 = $00
        BG2 = $40
        BG3 = $80
.endenum

.mac set_scroll_hdma layer, val
        _a_cmd_impl $ad
        .byte SET_SCROLL_HDMA_LAYER::layer | val
.endmac

.enum UPDATE_SCROLL_WAVE_LAYER
        BG3 = $01
        BG2 = $02
        BG1 = $04
        VERT = $80
        HORZ = $40
.endenum

.mac update_scroll_wave layer, direction
        _a_cmd_impl $ae
        make_bitmask .byte, 0, UPDATE_SCROLL_WAVE_LAYER, layer, direction
.endmac

.enum MOD_PAL_LAYER
        BG1
        BG2
        BG3
        SPRITE
        MONSTER
        CHAR
.endenum

.enum MOD_PAL_TYPE
        ADD
        SUB
.endenum

.enum MOD_PAL_COLORS
        BLACK = $00
        BLUE = $20
        GREEN = $40
        CYAN = $60
        RED = $80
        MAGENTA = $a0
        YELLOW = $c0
        WHITE = $e0
.endenum

.mac _mod_pal add_abs, sub_abs, add_rel, sub_rel, mod_type, colors, val
        .if MOD_PAL_TYPE::mod_type = MOD_PAL_TYPE::ADD
                .if .xmatch(.left(1, {val}), +) .or .xmatch(.left(1, {val}), -)
                        _a_cmd_impl add_rel
                        .if val < 0
                                make_bitmask .byte, 16 - val, MOD_PAL_COLORS, colors
                        .else
                                make_bitmask .byte, val, MOD_PAL_COLORS, colors
                        .endif
                .else
                        _a_cmd_impl add_abs
                        make_bitmask .byte, val, MOD_PAL_COLORS, colors
                .endif
        .elseif MOD_PAL_TYPE::mod_type = MOD_PAL_TYPE::SUB
                .if .xmatch(.left(1, {val}), +) .or .xmatch(.left(1, {val}), -)
                        _a_cmd_impl sub_rel
                        .if val < 0
                                make_bitmask .byte, 16 - val, MOD_PAL_COLORS, colors
                        .else
                                make_bitmask .byte, val, MOD_PAL_COLORS, colors
                        .endif
                .else
                        _a_cmd_impl sub_abs
                        make_bitmask .byte, val, MOD_PAL_COLORS, colors
                .endif
        .endif
.endmac

.mac mod_pal layer, mod_type, colors, val
        .if MOD_PAL_LAYER::layer = MOD_PAL_LAYER::BG1
                _mod_pal $cd, $cc, $ce, $cf, mod_type, {colors}, val
        .elseif MOD_PAL_LAYER::layer = MOD_PAL_LAYER::BG2
                _mod_pal $b0, $af, $b5, $b6, mod_type, {colors}, val
        .elseif MOD_PAL_LAYER::layer = MOD_PAL_LAYER::BG3
                _mod_pal $ab, $aa, $b3, $b4, mod_type, {colors}, val
        .elseif MOD_PAL_LAYER::layer = MOD_PAL_LAYER::SPRITE
                _mod_pal $b2, $b1, $b7, $b8, mod_type, {colors}, val
        .elseif MOD_PAL_LAYER::layer = MOD_PAL_LAYER::MONSTER
                _mod_pal $ba, $b9, $bb, $bc, mod_type, {colors}, val
        .elseif MOD_PAL_LAYER::layer = MOD_PAL_LAYER::CHAR
                _mod_pal $fc, $fb, $fd, $fe, mod_type, {colors}, val
        .endif
.endmac

.mac mod_boss_death_pal colors, val, num_colors, color_offset
        _a_cmd_byte $80, $80
        .if val < 0
                make_bitmask .byte, 16 - val, MOD_PAL_COLORS, colors
        .else
                make_bitmask .byte, val, MOD_PAL_COLORS, colors
        .endif
        .ifnblank num_colors
                .byte num_colors
        .else
                .byte 16
        .endif
        .ifnblank color_offset
                .byte color_offset
        .else
                .byte 0
        .endif
.endmac

.mac show_bg1_thread
        _a_cmd_byte $bd, $80
.endmac

.mac show_bg3_thread
        _a_cmd_byte $bd, $40
.endmac

.mac hide_bg1_thread
        _a_cmd_byte $bd, $a0
.endmac

.mac hide_bg3_thread
        _a_cmd_byte $bd, $50
.endmac

.enum MOSAIC_LAYER
        BG1 = $01
        BG2 = $02
        BG3 = $04
        BG4 = $08
.endenum

.mac mosaic layers, val
        _a_cmd_impl $be
        make_bitmask .byte, val << 4, MOSAIC_LAYER, layers
.endmac

.mac call addr
        _a_cmd_addr $bf, addr
.endmac

.mac return
        _a_cmd_impl $c0
.endmac

.mac move_vec_arc addr, speed
        _a_cmd_byte $c1, speed
        .byte * - addr
.endmac

.enum UNPAUSE_LAYER
        BG1 = $80
        BG3 = $40
        SPRITE = $20
.endenum

.mac unpause_layer val
        _a_cmd_impl $c2
        make_bitmask .byte, 0, UNPAUSE_LAYER, val
.endmac

.mac move_circle_to_target
        _a_cmd_impl $c3
.endmac

.mac move_bg1_here
        _a_cmd_byte $c4, $80
.endmac

.mac move_bg3_here
        _a_cmd_byte $c4, $40
.endmac

.mac jump_quad hit1, hit2, hit3, hit4
        _a_cmd_impl $c5
        .addr hit1, hit2, hit3, hit4
.endmac

.mac move_vec_spiral addr, speed
        _a_cmd_byte $c6, speed
        .byte * - addr
.endmac

.enum ATTACKER_CHAR_DIR
        LEFT = 0
        RIGHT = 1
.endenum

.mac attacker_char_dir val
        _a_cmd_byte $c7, EVENT_ANIM_CMD::ATTACKER_CHAR_DIR
        .byte ATTACKER_CHAR_DIR::val
.endmac

.mac reset_char_vec_offset
        _a_cmd_byte $c7, EVENT_ANIM_CMD::RESET_CHAR_VEC_OFFSET
.endmac

.mac save_attacker_char_pos
        _a_cmd_byte $c7, EVENT_ANIM_CMD::SAVE_ATTACKER_CHAR_POS
.endmac

.mac restore_attacker_char_pos
        _a_cmd_byte $c7, EVENT_ANIM_CMD::RESTORE_ATTACKER_CHAR_POS
.endmac

.mac vec_to_attacker_char_pos
        _a_cmd_byte $c7, EVENT_ANIM_CMD::VEC_TO_ATTACKER_CHAR_POS
.endmac

.mac char_pos xy_pos
        _a_cmd_byte $c7, EVENT_ANIM_CMD::CHAR_POS
        _2_bytes xy_pos
.endmac

.mac update_char_vec_dir_walk
        _a_cmd_byte $c7, EVENT_ANIM_CMD::UPDATE_CHAR_VEC_DIR_WALK
.endmac

.mac calc_vec_rel xy_pos
        _a_cmd_byte $c7, EVENT_ANIM_CMD::CALC_VEC_REL
        _2_bytes_signed xy_pos
.endmac

.mac update_char_vec_dir_jump
        _a_cmd_byte $c7, EVENT_ANIM_CMD::UPDATE_CHAR_VEC_DIR_JUMP
.endmac

.mac play_song song_id, volume
        _a_cmd_byte $c7, EVENT_ANIM_CMD::SOUND_CMD
        .byte $10, SONG::song_id
        .ifnblank volume
                .byte volume
        .else
                .byte $ff
        .endif
.endmac

.mac event_sfx sfx, pan
        _a_cmd_byte $c7, EVENT_ANIM_CMD::SOUND_CMD
        .byte $18, SFX::sfx, pan
.endmac

.mac set_sound_vol val
        _a_cmd_byte $c7, EVENT_ANIM_CMD::SOUND_CMD
        .byte $80, val, 0
.endmac

.mac set_song_vol val
        _a_cmd_byte $c7, EVENT_ANIM_CMD::SOUND_CMD
        .byte $81, val, 0
.endmac

.mac set_sfx_vol val
        _a_cmd_byte $c7, EVENT_ANIM_CMD::SOUND_CMD
        .byte $82, val, 0
.endmac

.mac change_char_gfx char_id, gfx_id
        _a_cmd_byte $c7, EVENT_ANIM_CMD::CHANGE_CHAR_GFX
        .byte CHAR_PROP::char_id
        .byte CHAR_GFX::gfx_id
.endmac

.mac tritoch_sparkle val
        _a_cmd_2byte $c7, EVENT_ANIM_CMD::TRITOCH_SPARKLE, val
.endmac

.enum BATTLE_EVENT_SHAKE_BG
        ENABLE = 1
        DISABLE = 0
        HORZ = $80
.endenum

.mac shake_bg val
        _a_cmd_byte $c7, EVENT_ANIM_CMD::SHAKE_BG
        make_bitmask .byte, 0, BATTLE_EVENT_SHAKE_BG, val
.endmac

.mac show_char val
        _a_cmd_2byte $c7, EVENT_ANIM_CMD::SHOW_CHAR, CHAR_PROP::val
.endmac

.mac disable_run
        _a_cmd_byte $c7, EVENT_ANIM_CMD::DISABLE_RUN
.endmac

; set attacking character's fixed animation frame (use animated action if zero)
.mac attacker_frame val
        _a_cmd_byte $c8, val
.endmac

.enum SFX_PAN
        X_POS = $86
        Y_POS = $87
        CENTER = $8c
.endenum

.mac sfx val, pan
        .ifnblank pan
                _a_cmd_2byte $80, SFX_PAN::pan, SFX::val
        .else
                .ifblank val
                        _a_cmd_byte $c9, SFX::DEFAULT
                .else
                        _a_cmd_byte $c9, SFX::val
                .endif
        .endif
.endmac

.mac normal_action_speed
        _a_cmd_byte $ca, 0
.endmac

.mac double_action_speed
        _a_cmd_byte $ca, 1
.endmac

.mac enable_echo_sprites delay
        _a_cmd_byte $cb, $80 | delay
.endmac

.mac disable_echo_sprites delay
        _a_cmd_byte $cb, delay
.endmac

; set layer priority for all character/monster sprites
.mac sprite_priority val
        _a_cmd_byte $d0, val << 4
.endmac

; target draw order is updated every frame
.mac normal_draw_order
        _a_cmd_byte $d1, 0
.endmac

; target draw order is static
.mac fixed_draw_order
        _a_cmd_byte $d1, 1
.endmac

.mac set_vec_target xy_pos
        _a_cmd_2byte $d2, xy_pos
.endmac

.mac move_circle_to_attacker_char
        _a_cmd_impl $d3
.endmac

.enum COLOR_MATH_FLAGS
; math flags
        ADD = 0
        SUB = $8000
        HALF = $4000
        FULL = 0
        FIXED_CLR = 0
        SUBSCREEN = 2
        ALWAYS_MAIN = $00
        INSIDE_MAIN = $40
        OUTSIDE_MAIN = $80
        NEVER_MAIN = $c0
        ALWAYS_SUB = $00
        INSIDE_SUB = $10
        OUTSIDE_SUB = $20
        NEVER_SUB = $30
; layers
        BG1 = $0100
        BG2 = $0200
        BG3 = $0400
        BG4 = $0800
        SPRITE = $1000
        BACK = $2000
.endenum

.mac color_math math_flags, main_layers, sub_layers
        _a_cmd_impl $d4
        make_bitmask .word, 0, COLOR_MATH_FLAGS, math_flags, main_layers
        .ifnblank sub_layers
                make_bitmask .hibytes, 0, COLOR_MATH_FLAGS, sub_layers
        .else
                .byte 0
        .endif
.endmac

.enum FLIP_MONSTER
        HORZ = %01
        VERT = %10
.endenum

.mac flip_monster val
        _a_cmd_byte $d5, FLIP_MONSTER::val
.endmac

.mac scroll_bg xy
        _a_cmd_impl $d6
        _2_bytes_signed xy
.endmac

.mac update_fire_dance val
        _a_cmd_byte $d7, val
.endmac

.mac update_bum_rush addr, x1, x2
        _a_cmd_2byte $d8, <x1, <x2
        .byte addr - * - 1
.endmac

.mac attacker_priority val
        _a_cmd_byte $d9, val << 4
.endmac

.mac move_tornado xy_speed
        _a_cmd_2byte $da, xy_speed
.endmac

.mac jump_step addr
        _a_cmd_impl $db
        .byte <(addr - * - 1)
.endmac

.mac update_triangle_2d
        _a_cmd_impl $dc
.endmac

.mac init_triangle xy_pos, size, angle
        _a_cmd_2byte $dd, xy_pos
        .byte size, angle
.endmac

.mac move_triangle_to_attacker
        _a_cmd_impl $de
.endmac

.mac move_triangle_to_target
        _a_cmd_impl $df
.endmac

.mac move_triangle xy, size, angle
        _a_cmd_2byte $e0, xy_pos
        .ifnblank size
                .byte <size
        .else
                .byte 0
        .endif
        .ifnblank angle
                .byte <angle
        .else
                .byte 0
        .endif
.endmac

.mac zoom_triangle size, angle
        _a_cmd_2byte $e0, 0, 0
        .ifnblank size
                .byte <size
        .else
                .byte 0
        .endif
        .ifnblank angle
                .byte <angle
        .else
                .byte 0
        .endif
.endmac

.mac rotate_triangle angle
        _a_cmd_2byte $e0, 0, 0
        .byte 0
        .ifnblank angle
                .byte <angle
        .else
                .byte 0
        .endif
.endmac

.mac hide_attacker_monster
        _a_cmd_byte $e1, $80
.endmac

.mac hide_attacker_char
        _a_cmd_byte $e1, $00
.endmac

.mac show_attacker_monster
        _a_cmd_byte $e1, $81
.endmac

.mac show_attacker_char
        _a_cmd_byte $e1, $01
.endmac

.mac move_vec_monster addr, speed
        .if speed >= 0
                _a_cmd_byte $e2, speed
        .else
                _a_cmd_byte $e3, -speed
        .endif
        .byte * - addr
.endmac

.mac calc_vec_jump
        _a_cmd_impl $e4
.endmac

.mac move_vec_char addr, speed, height
        .if speed >= 0
                _a_cmd_byte $e5, speed
        .else
                _a_cmd_byte $e6, -speed
        .endif
        .byte * - addr
        .ifnblank height
                .byte height
        .else
                .byte 0
        .endif
.endmac

.mac calc_vec_char
        _a_cmd_impl $e7
.endmac

.mac move_polar radius, angle
        _a_cmd_impl $e8
        .byte <radius, <angle
.endmac

.mac move_rand xy
        _a_cmd_impl $e9
        _2_bytes xy
.endmac

.enum BG_SCREEN_POS_LAYER
        BG1 = $80
        BG3 = $40
.endenum

.enum BG_SCREEN_POS
        TOP_LEFT
        TOP_RIGHT
        BOTTOM_LEFT
        BOTTOM_RIGHT
        SKETCH
        UNKNOWN_2800
        TOP_LEFT_BG3
        TOP_RIGHT_BG3
.endenum

.mac bg_screen_pos layer, val
        _a_cmd_impl $ea
        .byte BG_SCREEN_POS_LAYER::layer | BG_SCREEN_POS::val
.endmac

.mac jump_thread t1, t2, t3, t4, t5, t6, t7, t8
        _a_cmd_impl $eb
        .if .paramcount >= 1
                .addr t1
        .endif
        .if .paramcount >= 2
                .addr t2
        .endif
        .if .paramcount >= 3
                .addr t3
        .endif
        .if .paramcount >= 4
                .addr t4
        .endif
        .if .paramcount >= 5
                .addr t5
        .endif
        .if .paramcount >= 6
                .addr t6
        .endif
        .if .paramcount >= 7
                .addr t7
        .endif
        .if .paramcount >= 8
                .addr t8
        .endif
.endmac

.mac change_anim_layer val
        _a_cmd_byte $ec, ANIM_LAYER::val
.endmac

; also used for cold dust
.mac move_vec_grav_bomb addr, speed
        _a_cmd_byte $ed, speed
        .byte * - addr
.endmac

; set layer priority for target sprites
.mac target_priority val
        _a_cmd_byte $ee, val << 4
.endmac

.mac move_ellipse radius, angle
        _a_cmd_impl $ef
        .byte <radius, <angle
.endmac

.mac jump_target char1, char2, char3, char4, monster
        _a_cmd_impl $f0
        .addr char1, char2, char3, char4, monster
.endmac

.mac hide_target_monsters
        _a_cmd_byte $f1, $80
.endmac

.mac hide_target_chars
        _a_cmd_byte $f1, $00
.endmac

.mac show_target_monsters
        _a_cmd_byte $f1, $81
.endmac

.mac show_target_chars
        _a_cmd_byte $f1, $01
.endmac

.mac calc_vec_reverse
        _a_cmd_impl $f2
.endmac

.mac jump_attacker char1, char2, char3, char4, monster
        _a_cmd_impl $f3
        .addr char1, char2, char3, char4, monster
.endmac

.mac front_sprite
        _a_cmd_byte $f4, 0
.endmac

.mac back_sprite
        _a_cmd_byte $f4, 1
.endmac

.mac update_triangle_3d
        _a_cmd_impl $f6
.endmac

.mac wait_scanline val
        _a_cmd_impl $f7
        .ifblank val
                .byte 160
        .else
                .byte val
        .endif
.endmac

; jump to magitek_addr if magitek, otherwise jump to normal_addr
.mac jump_magitek magitek_addr, normal_addr
        _a_cmd_impl $f8
        .addr normal_addr, magitek_addr
.endmac

; set animated action for attacker's magitek armor
.mac magitek_action frame, char_id
        _a_cmd_byte $f9, frame
        .byte 0
        .ifnblank char_id
                .byte CHAR::char_id | $80
        .else
                .byte 0
        .endif
.endmac

.mac magitek_target_action frame, char_id
        _a_cmd_byte $f9, frame
        .byte 1
        .ifnblank char_id
                .byte CHAR::char_id | $80
        .else
                .byte 0
        .endif
.endmac

.mac jump addr
        _a_cmd_addr $fa, addr
.endmac

.mac end_anim_script
        _a_cmd_impl $ff
.endmac

; ------------------------------------------------------------------------------

.else
.endif