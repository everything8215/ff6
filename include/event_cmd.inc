.ifndef EVENT_INC
EVENT_INC = 1

.setcpu "none"

.enum SCRIPT_MODE
        EVENT
        OBJ
        WORLD
        VEHICLE
.endenum

.define set_script_mode(mode) ::script_mode .set SCRIPT_MODE::mode
.define is_script_mode(mode) ::script_mode = SCRIPT_MODE::mode

set_script_mode EVENT

.mac _assert_script_mode mode
        .assert ::script_mode = SCRIPT_MODE::mode, error, "Invalid script mode"
.endmac

; ------------------------------------------------------------------------------

.mac _cmd_impl op
        .byte op
.endmac

.mac _e_cmd_impl cmd
        _assert_script_mode EVENT
        _cmd_impl cmd
.endmac

.mac _o_cmd_impl cmd
        _assert_script_mode OBJ
        _cmd_impl cmd
.endmac

.mac _w_cmd_impl cmd
        _assert_script_mode WORLD
        _cmd_impl cmd
.endmac

.mac _v_cmd_impl cmd
        _assert_script_mode VEHICLE
        _cmd_impl cmd
.endmac

.mac _cmd_byte op, b
        .byte op, b
.endmac

.mac _e_cmd_byte op, b
        _assert_script_mode EVENT
        _cmd_byte op, b
.endmac

.mac _o_cmd_byte op, b
        _assert_script_mode OBJ
        _cmd_byte op, b
.endmac

.mac _w_cmd_byte op, b
        _assert_script_mode WORLD
        _cmd_byte op, b
.endmac

.mac _v_cmd_byte op, b
        _assert_script_mode VEHICLE
        _cmd_byte op, b
.endmac

.mac _cmd_2byte op, b1, b2
        .byte op, b1, b2
.endmac

.mac _e_cmd_2byte op, b1, b2
        _assert_script_mode EVENT
        _cmd_2byte op, b1, b2
.endmac

.mac _o_cmd_2byte op, b1, b2
        _assert_script_mode OBJ
        _cmd_2byte op, b1, b2
.endmac

.mac _cmd_3byte op, b1, b2, b3, mode
        .ifnblank mode
                _assert_script_mode mode
        .endif
        .byte op, b1, b2, b3
.endmac

.mac _cmd_word op, w, mode
        .ifnblank mode
                _assert_script_mode mode
        .endif
        .byte op
        .word w
.endmac

.define _event_addr(addr) ((addr - EventScript) & $ffffff)

.mac _cmd_addr op, addr, mode
        .ifnblank mode
                _assert_script_mode mode
        .endif
        .byte op
        .faraddr _event_addr {addr}
.endmac

; ------------------------------------------------------------------------------

.enum OBJ_SCRIPT_FLAGS
        ASYNC = 0
        AWAIT = $80                     ; default
.endenum

.mac obj_script obj, flags
        .scope
        .ifblank flags
                _e_cmd_byte EVENT_OBJ::obj, (_ObjEnd - _ObjStart) | OBJ_SCRIPT_FLAGS::AWAIT
        .else
                _e_cmd_byte EVENT_OBJ::obj, (_ObjEnd - _ObjStart) | OBJ_SCRIPT_FLAGS::flags
        .endif
        _ObjStart := *
        set_script_mode OBJ
.endmac

.define wait_obj(obj) _e_cmd_byte $35, EVENT_OBJ::obj
.define pass_on(obj) _e_cmd_byte $36, EVENT_OBJ::obj
.define obj_gfx(obj, gfx) _e_cmd_2byte $37, EVENT_OBJ::obj, gfx
.define lock_camera _e_cmd_impl $38
.define unlock_camera _e_cmd_impl $39
.define player_ctrl_on _e_cmd_impl $3a
.define player_ctrl_off _e_cmd_impl $3b

.mac party_chars char1, char2, char3, char4
        _e_cmd_impl $3c
        .byte char1
        .ifnblank char2
                .byte char2
        .else
                .byte $ff
        .endif
        .ifnblank char3
                .byte char3
        .else
                .byte $ff
        .endif
        .ifnblank char4
                .byte char4
        .else
                .byte $ff
        .endif
.endmac

.define create_obj(obj) _e_cmd_byte $3d, EVENT_OBJ::obj
.define delete_obj(obj) _e_cmd_byte $3e, EVENT_OBJ::obj
.define char_party(char, party) _e_cmd_2byte $3f, char, (party << 5)
.define char_prop(char, prop) _e_cmd_2byte $40, char, prop
.define _e_show_obj(obj) _e_cmd_byte $41, EVENT_OBJ::obj
.define _e_hide_obj(obj) _e_cmd_byte $42, EVENT_OBJ::obj
.define obj_pal(obj, pal) _e_cmd_2byte $43, EVENT_OBJ::obj, pal
.define sort_obj _e_cmd_impl $45
.define activate_party(party) _e_cmd_byte $46, party
.define update_party _e_cmd_impl $47

.enum DLG_FLAGS
        BOTTOM                          = $8000
        TEXT_ONLY                       = $4000
        ASYNC                           = 0
        AWAIT                           = 0
.endenum

.mac _dlg_op f1, f2, f3
        .if .paramcount > 0 .and .xmatch(f1, ASYNC)
                _e_cmd_impl $48
        .elseif .paramcount > 1 .and .xmatch(f2, ASYNC)
                _e_cmd_impl $48
        .elseif .paramcount > 2 .and .xmatch(f3, ASYNC)
                _e_cmd_impl $48
        .else
                _e_cmd_impl $4b
        .endif
.endmac

.mac dlg dlg_id, flags
        .ifblank flags
                _cmd_word $4b, dlg_id, EVENT
        .else
                _dlg_op flags
                make_bitmask .word, dlg_id, DLG_FLAGS, flags
        .endif
.endmac

.define wait_dlg _e_cmd_impl $49
.define wait_key _e_cmd_impl $4a

.enum BATTLE_FLAGS
        NO_BLUR = $80
        NO_SFX = $40
        COLLISION = 0
.endenum

.define treasure_battle _e_cmd_impl $8e
.define colosseum_battle _e_cmd_impl $af

.mac _battle_op battle_id, f1, f2, f3
        .if is_script_mode VEHICLE
                _v_cmd_byte $ca, battle_id
        .elseif .paramcount > 0 .and .xmatch(f1, COLLISION)
                _e_cmd_byte $4d, battle_id
        .elseif .paramcount > 1 .and .xmatch(f2, COLLISION)
                _e_cmd_byte $4d, battle_id
        .elseif .paramcount > 2 .and .xmatch(f3, COLLISION)
                _e_cmd_byte $4d, battle_id
        .else
                _e_cmd_byte $4c, battle_id
        .endif
.endmac

.mac battle battle_id, bg, flags
        _battle_op battle_id, flags
        .ifblank flags
                .byte bg
        .else
                make_bitmask .byte, bg, BATTLE_FLAGS, flags
        .endif
.endmac

.define rand_battle _e_cmd_impl $4e
.define restore_save _e_cmd_impl $4f

; modify color palettes

.define MOD_PAL_RESTORE $00
.define MOD_PAL_INC $20
.define MOD_PAL_INC_FLASH $40
.define MOD_PAL_UNINC $60
.define MOD_PAL_DEC $80
.define MOD_PAL_DEC_FLASH $a0
.define MOD_PAL_UNDEC $c0

.define MOD_PAL_WHITE $1c
.define MOD_PAL_RED $10
.define MOD_PAL_GREEN $08
.define MOD_PAL_BLUE $04
.define MOD_PAL_BLACK $00

.macro _mod_pal op, type, color, intensity, first_color, last_color
        .if .blank(first_color) .or .blank(last_color)
                _e_cmd_byte op, type | color | intensity
        .else
                _e_cmd_byte op + 1, type | color | intensity
                .byte first_color, last_color
        .endif
.endmac

.define mod_bg_pal _mod_pal $50,
.define mod_sprite_pal _mod_pal $52,

.define fixed_clr_off _e_cmd_impl $54

.mac flash clr
        _e_cmd_impl $55
        make_bitmask .byte, 0, FIXED_CLR, clr
.endmac

.mac fixed_clr clr, rate, intensity
        .if intensity >= 0
                ; add
                _e_cmd_impl $56
                make_bitmask .byte, (rate << 3) | intensity, FIXED_CLR, clr
        .else
                ; subtract
                _e_cmd_impl $57
                make_bitmask .byte, (rate << 3) | -intensity, FIXED_CLR, clr
        .endif
.endmac

.enum SHAKE_LAYERS
        BG1                             = $10
        BG2                             = $20
        BG3                             = $40
        SPRITES                         = $80
        ALL                             = $f0
.endenum

.mac shake layers, amplitude, frequency
        _e_cmd_impl $58
        make_bitmask .byte, amplitude | (frequency << 2), SHAKE_LAYERS, layers
.endmac

.mac fade_in rate
        .if (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _cmd_impl $d8
        .elseif .blank(rate)
                _e_cmd_impl $96
        .else
                _e_cmd_byte $59, rate
        .endif
.endmac

.mac fade_out rate
        .if (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _cmd_impl $d9
        .elseif .blank(rate)
                _e_cmd_impl $97
        .else
                _e_cmd_byte $5a, rate
        .endif
.endmac

.define pause_fade _e_cmd_impl $5b
.define wait_fade _e_cmd_impl $5c

; scroll bg

.define mosaic(rate) _e_cmd_byte $62, rate
.define flashlight(size) _e_cmd_byte $63, size
.define bg_anim_frame(tile, frame) _e_cmd_2byte $64, tile, frame
.define bg_anim_rate(tile, rate) _e_cmd_2byte $65, tile, rate

.mac _load_map op, map, xx, yy, dd, flags1, flags2
        .byte op
        .word map | (flags1 << 8) | (EVENT_DIR::dd << 12)
        .byte xx, yy, flags2
.endmac

.macro load_map map, xx, yy, dd, flags1, flags2
        .if is_script_mode EVENT
                _load_map $6b, map, xx, yy, dd, flags1, flags2
        .elseif (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _load_map $d2, map, xx, yy, dd, flags1, flags2
        .else
                .error("Incorrect script mode")
        .endif
.endmac

.macro load_map_vehicle map, xx, yy, dd, flags1, flags2
        .if (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _load_map $d3, map, xx, yy, dd, flags1, flags2
        .else
                .error("Incorrect script mode")
        .endif
.endmac

.macro load_map_fade map, xx, yy, dd, flags1, flags2
        _assert_script_mode EVENT
        _load_map $6a, map, xx, yy, dd, flags1, flags2
.endmac

.macro set_parent_map map, xx, yy, dd, flags1, flags2
        _assert_script_mode EVENT
        _load_map $6c, map, xx, yy, dd, flags1, flags2
.endmac

.enum MOD_BG_FLAGS
        AWAIT = $73                     ; default
        ASYNC = $74
.endenum

.enum MOD_BG_LAYER
        BG1 = $00
        BG2 = $40
        BG3 = $80
.endenum

.macro mod_bg layer, xx, yy, width, height, flags
        .ifblank flags
                _e_cmd_impl MOD_BG_FLAGS::AWAIT
        .else
                _e_cmd_impl MOD_BG_FLAGS::flags
        .endif
        .byte xx, yy | MOD_BG_LAYER::layer, width, height
.endmac

.define norm_lvl(char) _e_cmd_byte $77, char
.define pass_off(obj) _e_cmd_byte $78, EVENT_OBJ::obj

.macro set_party_map party, map
        _e_cmd_byte $79, party
        .word map
.endmac

.macro obj_event obj, addr
        _e_cmd_byte $7a, EVENT_OBJ::obj
        .faraddr _event_addr addr
.endmac

.mac _char_status op, prefix, char, status14
        _e_cmd_byte op, EVENT_OBJ::char
        make_bitmask .word, 0, STATUS14, status14
.endmac

.define restore_default_party _e_cmd_impl $7b
.define collision_on(obj) _e_cmd_byte $7c, EVENT_OBJ::obj
.define collision_off(obj) _e_cmd_byte $7d, EVENT_OBJ::obj
.define party_pos(xx, yy) _e_cmd_2byte $7e, xx, yy
.define char_name(char, name) _e_cmd_2byte $7f, char, name
.define give_item(item) _e_cmd_byte $80, item
.define take_item(item) _e_cmd_byte $81, item
.define reset_default_party _e_cmd_impl $82
.define give_gil(gil) _cmd_word $84, gil, EVENT
.define take_gil(gil) _cmd_word $85, gil, EVENT
.define give_genju(genju) _e_cmd_byte $86, GENJU::genju
.define take_genju(genju) _e_cmd_byte $87, GENJU::genju
.define and_status _char_status $88, .byte,
.define clr_status _char_status $88, .byte $ffff^,
.define set_status _char_status $89, .byte,
.define toggle_status _char_status $8a, .byte,
.define inc_hp(char,hp) _e_cmd_2byte $8b, EVENT_OBJ::char, hp
.define dec_hp(char,hp) _e_cmd_2byte $8b, EVENT_OBJ::char, hp | $80
.define max_hp(char) _e_cmd_2byte $8b, EVENT_OBJ::char, $7f
.define inc_mp(char,mp) _e_cmd_2byte $8c, EVENT_OBJ::char, mp
.define dec_mp(char,mp) _e_cmd_2byte $8c, EVENT_OBJ::char, mp | $80
.define max_mp(char) _e_cmd_2byte $8c, EVENT_OBJ::char, $7f
.define remove_equip(char) _e_cmd_byte $8d, char
.define give_bushido _e_cmd_impl $8f
.define give_blitz _e_cmd_impl $90

.macro wait_15f dur
        .ifblank dur
                _e_cmd_impl $91
        .else
                _e_cmd_byte $b5, dur
        .endif
.endmac

.define wait_30f _e_cmd_impl $92
.define wait_45f _e_cmd_impl $93
.define wait_60f _e_cmd_impl $94
.define wait_90f wait_15f 6
.define wait_120f _e_cmd_impl $95

.define wait_1s wait_60f
.define wait_2s wait_120f

.define _e_wait(dur) _e_cmd_byte $b4, dur
.define _o_wait(dur) _o_cmd_byte $e0, dur
.define _w_wait(dur) _w_cmd_byte $e0, dur
.define _v_wait(dur) _v_cmd_byte $e0, dur

.mac wait dur
        .if is_script_mode EVENT
                _e_wait dur
        .elseif is_script_mode OBJ
                _o_wait dur
        .elseif is_script_mode WORLD
                _w_wait dur
        .elseif is_script_mode VEHICLE
                _v_wait dur
        .endif
.endmac

.define name_menu(char) _e_cmd_byte $98, char

.enum PARTY_MENU_FLAGS
        RESET = $80  ; default
        NO_RESET = 0
.endenum

.mac party_menu num_parties, flags, forced_chars
        .ifblank flags
                _e_cmd_byte $99, num_parties | PARTY_MENU_FLAGS::RESET
        .else
                _e_cmd_byte $99, num_parties | PARTY_MENU_FLAGS::flags
        .endif
        .ifblank forced_chars
                .word 0
        .else
                make_bitmask .word, 0, CHAR_FLAG, forced_chars
        .endif
.endmac

.define colosseum_menu _e_cmd_impl $9a
.define shop_menu(shop_id) _e_cmd_byte $9b, shop_id
.define opt_equip(char) _e_cmd_byte $9c, EVENT_OBJ::char
.define final_order _e_cmd_impl $9d

.enum TIMER_FLAGS
        FIELD_ONLY                      = $80
        FIELD_VISIBLE                   = $40
        BANQUET                         = $20
        MENU_BATTLE_VISIBLE             = $10
.endenum

.mac start_timer timer, dur, addr, flags
        _cmd_word $a0, dur, EVENT
        .ifblank flags
                .faraddr (_event_addr addr) | (timer << 18)
        .else
                make_bitmask .faraddr, (_event_addr addr) | (timer << 18), TIMER_FLAGS, flags
        .endif
.endmac

.define stop_timer(timer) _e_cmd_byte $a1, timer
.define clr_overlay _e_cmd_impl $a2
.define pyramid_off _e_cmd_impl $a6
.define pyramid_on(obj) _e_cmd_byte $a7, EVENT_OBJ::obj

.enum EVENT_CUTSCENE
        FLOATING_CONT = $a8
        TITLE = $a9
        INTRO = $aa
        RUIN = $ad
        TRAIN = $ae
        THE_END = $bb
        FALCON = $bf
        FALCON_ENDING = $f2
        JUDGMENT_1 = $f3
        JUDGMENT_2 = $f4
        FALCON_EMERGE = $fa
        VECTOR_APPROACH = $fe
.endenum

.mac cutscene val
        _e_cmd_impl EVENT_CUTSCENE::val
.endmac

.define load_menu _e_cmd_impl $ab
.define restore_game _e_cmd_impl $ac

.define loop(count) _e_cmd_byte $b0, count
.define end_loop _e_cmd_impl $b1

.mac call addr, repeat
        .ifblank repeat
                _cmd_addr $b2, addr, EVENT
        .else
                _e_cmd_byte $b3, repeat
                .faraddr _event_addr addr
        .endif
.endmac

.mac choice f1, f2, f3, f4, f5, f6, f7, f8
        _e_cmd_impl $b6
        .ifnblank f1
                .faraddr _event_addr f1
        .endif
        .ifnblank f2
                .faraddr _event_addr f2
        .endif
        .ifnblank f3
                .faraddr _event_addr f3
        .endif
        .ifnblank f4
                .faraddr _event_addr f4
        .endif
        .ifnblank f5
                .faraddr _event_addr f5
        .endif
        .ifnblank f6
                .faraddr _event_addr f6
        .endif
        .ifnblank f7
                .faraddr _event_addr f7
        .endif
        .ifnblank f8
                .faraddr _event_addr f8
        .endif
.endmac

.mac if_b_switch battle_switch, addr
        _e_cmd_byte $b7, battle_switch
        .faraddr _event_addr addr
.endmac

.define set_b_switch(battle_switch) _e_cmd_byte $b8, battle_switch
.define clr_b_switch(battle_switch) _e_cmd_byte $b9, battle_switch
.define ending(scene) _e_cmd_byte $ba, scene

.define loop_until(switch_id) _cmd_word $bc, switch_id, EVENT
.define if_rand(addr) _cmd_addr $bd, addr, EVENT

_multi_case_mode .set 0

.mac case val, addr
        .faraddr (val << 20) | (_event_addr addr)
.endmac

.mac if_case val, addr
        .local n_cases
        .ifnblank addr
                ; single case
                _cmd_byte $be, 1
                case val, addr
        .else
                ; beginning of multi-case block
                .scope
                n_cases = (_CaseEnd - _CaseStart) / 3
                .assert n_cases <= 16, error, "Too many cases"
                _cmd_byte $be, n_cases
                _CaseStart = *
                ::_multi_case_mode .set 1
        .endif
.endmac

.mac end_case
        .assert ::_multi_case_mode = 1, error, "Invalid case block"
        _CaseEnd = *
        ::_multi_case_mode .set 0
        .endscope
.endmac

.mac _make_if_switch switch_id
        .if .xmatch(.right(2, {switch_id}), =0)
                .word .left(.tcount({switch_id}) - 2, {switch_id})
        .elseif .xmatch(.right(2, {switch_id}), =1)
                .word .left(.tcount({switch_id}) - 2, {switch_id}) | $8000
        .else
                .error "Invalid switch"
        .endif
.endmac

_multi_switch_mode .set 0

.mac switch val
        .if ::_multi_switch_mode = 1
                _make_if_switch val
        .else
                .if .xmatch(.right(2, {val}), =0)
                        clr_switch .left(.tcount({val}) - 2, {val})
                .elseif .xmatch(.right(2, {val}), =1)
                        set_switch .left(.tcount({val}) - 2, {val})
                .endif
        .endif
.endmac

.mac _if_multi op
        .scope
        n_switches = (_IfEnd - _IfStart) / 2
        .assert n_switches <= 8, error, "Too many switches"
        _cmd_impl op + n_switches - 1
        _IfStart = *
        ::_multi_switch_mode .set 1
.endmac

.mac if_any
        .if is_script_mode EVENT
                _if_multi $c0
        .elseif (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _if_multi $b0
        .endif
.endmac

.mac if_all
        .if is_script_mode EVENT
                _if_multi $c8
        .elseif (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _if_multi $b8
        .endif
.endmac

.mac goto addr
        .assert ::_multi_switch_mode = 1, error, "Invalid conditional block"
        _IfEnd = *
        .faraddr _event_addr addr
        ::_multi_switch_mode .set 0
        .endscope
.endmac

; single if switch
.mac if_switch switch_id, addr
        .if is_script_mode EVENT
                _cmd_impl $c0
        .elseif (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _cmd_impl $b0
        .endif
        _make_if_switch switch_id
        .faraddr _event_addr addr
.endmac

.mac set_switch switch_id
        .assert (switch_id <= $06ff), error, "Invalid switch"
        .if is_script_mode EVENT
                _cmd_byte $d0 + (>switch_id) * 2, <switch_id
        .elseif is_script_mode OBJ
                .assert (switch_id <= $02ff), error, "Invalid switch"
                _cmd_byte $e1 + (>switch_id), <switch_id
        .elseif (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _cmd_word $c8, switch_id
        .endif
.endmac

.mac clr_switch switch_id
        .assert (switch_id <= $06ff), error, "Invalid switch"
        .if is_script_mode EVENT
                _cmd_byte $d1 + (>switch_id) * 2, <switch_id
        .elseif is_script_mode OBJ
                .assert (switch_id <= $02ff), error, "Invalid switch"
                _cmd_byte $e4 + (>switch_id), <switch_id
        .elseif (is_script_mode WORLD) .or (is_script_mode VEHICLE)
                _cmd_word $c9, switch_id
        .endif
.endmac

.enum EVENT_CASE
        PARTY_CHARS = $de
        OBJ_CHARS = $df
        INIT_CHARS = $e0
        AVAIL_CHARS = $e1
        TOP_CHAR = $e2
        ALL_PARTIES = $e3
        CURR_PARTY = $e4
.endenum

.define set_case(case) _e_cmd_impl EVENT_CASE::case

.mac _var_cmd op, var, val
        _e_cmd_byte op, var
        .word val
.endmac

.define set_var _var_cmd $e8,
.define add_var _var_cmd $e9,
.define sub_var _var_cmd $ea,
.define cmp_var _var_cmd $eb,

.define fade_song(dur) _e_cmd_byte $f2, dur

.define play_song(song) _e_cmd_byte $f0, song
.define play_song_pause(song) _e_cmd_byte $f0, song | $80

.define resume_song(dur) _e_cmd_byte $f3, dur
.define sfx(sfx_id) _e_cmd_byte $f4, sfx_id

.define spc_cmd(p1, p2, p3) _cmd_3byte $f6, p1, p2, p3, EVENT
.define continue_song _e_cmd_impl $f7
.define wait_spc _e_cmd_impl $f8
.define wait_song_pos _e_cmd_impl $f9
.define wait_song_end _e_cmd_impl $fa
.define event_cmd_fb _e_cmd_impl $fb
.define event_cmd_fd _e_cmd_impl $fd
.define return _e_cmd_impl $fe
.define _e_end return
.define no_event _e_cmd_impl $ff

.mac end
        .if is_script_mode EVENT
                _e_end
        .elseif is_script_mode OBJ
                _o_end
        .elseif is_script_mode WORLD
                _w_end
        .elseif is_script_mode VEHICLE
                _v_end
        .endif
.endmac

; ------------------------------------------------------------------------------

.define ACTION_H_FLIP $40

.macro action aa
        .assert (is_script_mode OBJ) .or (is_script_mode WORLD), error, "Invalid script mode"
        _cmd_impl aa
.endmac

.macro dir dd
        .assert (is_script_mode OBJ) .or (is_script_mode WORLD), error, "Invalid script mode"
        _cmd_impl $cc + EVENT_DIR::dd
.endmac

.mac move dd, steps
        .assert (is_script_mode OBJ) .or (is_script_mode WORLD), error, "Invalid script mode"
        .if (EVENT_DIR::dd <= 3)
                .assert steps >= 1 .and steps <= 32, error, "Steps must be [1..32]"
                .if steps <= 8
                        _cmd_impl $80 | ((steps - 1) << 2) | EVENT_DIR::dd
                .elseif steps <= 16
                        _cmd_impl $80 | $1c | EVENT_DIR::dd
                        _cmd_impl $80 | ((steps - 9) << 2) | EVENT_DIR::dd
                .elseif steps <= 24
                        _cmd_impl $80 | $1c | EVENT_DIR::dd
                        _cmd_impl $80 | $1c | EVENT_DIR::dd
                        _cmd_impl $80 | ((steps - 17) << 2) | EVENT_DIR::dd
                .else
                        _cmd_impl $80 | $1c | EVENT_DIR::dd
                        _cmd_impl $80 | $1c | EVENT_DIR::dd
                        _cmd_impl $80 | $1c | EVENT_DIR::dd
                        _cmd_impl $80 | ((steps - 25) << 2) | EVENT_DIR::dd
                .endif
        .else
                .ifblank steps
                        _cmd_impl $a0 | (EVENT_DIR::dd - 4)
                .else
                        .repeat steps
                                _cmd_impl $a0 | (EVENT_DIR::dd - 4)
                        .endrep
                .endif
        .endif
.endmac

.enum OBJ_SPEED
        SLOWER = 0
        SLOW = 1
        NORMAL = 2
        FAST = 3
        FASTER = 4
        FASTEST = 5
.endenum

.mac speed val
        .ifndef OBJ_SPEED::val
                .error "Speed parameter must be one of the following: SLOWER, SLOW, NORMAL, FAST, FASTER, FASTEST"
        .endif

        .if is_script_mode OBJ
                _cmd_impl $c0 + OBJ_SPEED::val
        .elseif is_script_mode WORLD
                .assert OBJ_SPEED::val <> 4, error, "FASTEST speed can't be used on world map"
                _cmd_impl $c0 + OBJ_SPEED::val
        .else
                .error "Invalid script mode"
        .endif
.endmac

.enum EVENT_VEHICLE
        NONE = $00
        CHOCOBO = $20
        MAGITEK = $40
        RAFT = $60
        SHOW_RIDER = $80
        HIDE_RIDER = $00
.endenum

.mac vehicle p1, p2
        .if is_script_mode OBJ
                _o_cmd_impl $c9
                make_bitmask .byte, 0, EVENT_VEHICLE, p1
        .elseif is_script_mode EVENT
                _e_cmd_byte $44, EVENT_OBJ::p1
                make_bitmask .byte, 0, EVENT_VEHICLE, p2
        .endif
.endmac

.mac hide_obj obj
        .if is_script_mode OBJ
                _o_hide_obj
        .elseif is_script_mode EVENT
                _e_hide_obj obj
        .endif
.endmac

.mac show_obj obj
        .if is_script_mode OBJ
                _o_show_obj
        .elseif is_script_mode EVENT
                _e_show_obj obj
        .endif
.endmac

.define anim_on _o_cmd_impl $c6
.define anim_off _o_cmd_impl $c7
.define layer(ll) _o_cmd_byte $c8, ll

.define _o_show_obj _o_cmd_impl $d0
.define _o_hide_obj _o_cmd_impl $d1

.define pos(xx, yy) _o_cmd_2byte $d5, xx, yy

.define scroll_obj _o_cmd_impl $d7

.define jump_low _o_cmd_impl $dc
.define jump_high _o_cmd_impl $dd

.macro exec addr
        _assert_script_mode OBJ
        _cmd_addr $f9, addr
.endmac

.macro _branch op, addr
        _assert_script_mode OBJ
        .if .def(addr) .and ((addr) - (* - 1)) < 0
                ; branch backward
                _cmd_byte op, (* - 1) - (addr)
        .else
                ; branch forward
                _cmd_byte op + 1, (addr) - (* - 1)
        .endif
.endmac

.define branch _branch $fc,
.define branch_rand _branch $fa,

.mac _o_end
        .ifndef _ObjStart
                .error "Missing start of object script"
        .endif
        _o_cmd_impl $ff
        _ObjEnd := *
        .endscope
        set_script_mode EVENT
.endmac

; ------------------------------------------------------------------------------

.define ship_gfx _w_cmd_impl $fc
.define figaro_submerge _w_cmd_impl $fd
.define figaro_emerge _w_cmd_impl $fe
.define _w_end _w_cmd_impl $ff

.macro airship_pos xx, yy
        .assert (is_script_mode WORLD) .or (is_script_mode VEHICLE), error, "Invalid script mode"
        _cmd_2byte $c7, xx, yy
.endmac

.define show_arrows _v_cmd_impl $da
.define lock_arrows _v_cmd_impl $db
.define hide_arrows _v_cmd_impl $dc

.macro hide_minimap
        .assert (is_script_mode WORLD) .or (is_script_mode VEHICLE), error, "Invalid script mode"
        _cmd_impl $dd
.endmac

.define rotation_center(xx, yy) _cmd_2byte $de, xx, yy

.macro show_minimap
        .assert (is_script_mode WORLD) .or (is_script_mode VEHICLE), error, "Invalid script mode"
        _cmd_impl $df
.endmac

.define _v_end _v_cmd_impl $ff

; ------------------------------------------------------------------------------

.endif
